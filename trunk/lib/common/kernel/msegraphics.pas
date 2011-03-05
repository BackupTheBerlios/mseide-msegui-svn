{ MSEgui Copyright (c) 1999-2011 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit msegraphics;

{$ifdef FPC}{$mode objfpc}{$h+}{$GOTO ON}{$interfaces corba}{$endif}

interface
uses
 {$ifdef FPC}classes{$else}Classes{$endif},msetypes,msestrings,mseerr,
 msegraphutils,mseguiglob,mseclasses,mseglob,msesys;

const

 linewidthshift = 16;
 linewidthroundvalue = $8000;
 fontsizeshift = 16;
 fontsizeroundvalue = $8000;
 defaultfontalias = 'stf_default';
 
 invalidgchandle = ptruint(-1);
 
type
 gckindty = (gck_screen,gck_pixmap,gck_printer,gck_metafile);
 
 alignmentty = (al_left,al_xcentered,al_right,al_top,al_ycentered,al_bottom,
                al_grayed,
                al_stretchx,al_stretchy,al_fit,al_tiled,
                al_intpol,al_or,al_and);
 alignmentsty = set of alignmentty;

 drawingflagty = (df_canvasispixmap,df_canvasismonochrome,df_highresfont,
                  df_colorconvert,
                  df_opaque,df_monochrome,df_brush{,df_dashed},df_last = 31);
 drawingflagsty = set of drawingflagty;

 capstylety = (cs_butt,cs_round,cs_projecting);
 joinstylety = (js_miter,js_round,js_bevel);
 lineoptionty = (lio_antialias);
 lineoptionsty = set of lineoptionty;

 dashesstringty = string[9];    //last byte 0 -> opaque

const
 fillmodeinfoflags = [df_opaque,df_monochrome,df_brush];
 da_dot = dashesstringty(#1#1);
 da_dash = dashesstringty(#3#3);
 da_dashdot = dashesstringty(#3#1#1#1);

type
                                       //fontalias option char:
 fontoptionty = (foo_fixed,            // 'p'
                 foo_proportional,     // 'P'
                 foo_helvetica,        // 'H'
                 foo_roman,            // 'R'
                 foo_script,           // 'S'
                 foo_decorative,       // 'D'
                 foo_antialiased,      // 'A' 
                 foo_antialiased2,     // 'B' cleartype on windows
                 foo_nonantialiased    // 'a'
//                 foo_xcore,            // 'C'  //seems not to work with xft2
//                 foo_noxcore           // 'c'
                 );
 fontoptionsty = set of fontoptionty;

const
 fontpitchmask = [foo_fixed,foo_proportional];
 fontfamilymask = [foo_helvetica,foo_roman,foo_script,foo_decorative];
 fontantialiasedmask = [foo_antialiased,foo_antialiased2,foo_nonantialiased];
// fontxcoremask = [foo_xcore,foo_noxcore];
 fontaliasoptionchars : array[fontoptionty] of char =
                ('p','P','H','R','S','D','A','B','a'{,'C','c'});
type
 canvasstatety =
  (cs_regioncopy,cs_clipregion,cs_origin,cs_gc,
   cs_acolorbackground,cs_acolorforeground,cs_color,cs_colorbackground,
   cs_dashes,cs_linewidth,cs_capstyle,cs_joinstyle,cs_lineoptions,
   cs_fonthandle,cs_font,cs_fontcolor,cs_fontcolorbackground,cs_fonteffect,
   cs_rasterop,cs_brush,cs_brushorigin,
   cs_painted,cs_internaldrawtext,cs_highresdevice,
   cs_inactive,cs_pagestarted,cs_metafile{,cs_monochrome});
 canvasstatesty = set of canvasstatety;
const
 linecanvasstates = [cs_dashes,cs_linewidth,cs_capstyle,cs_joinstyle,
                     cs_lineoptions];

const
 fontstylehandlemask = 3; //[fs_bold,fs_italic]
 fontstylesmamask: fontstylesty = 
           [fs_bold,fs_italic,fs_underline,fs_strikeout,fs_selected];

type
 pgdifunctionaty = ^gdifunctionaty;

 fontdatapty = array[0..15] of pointer;
 
 fonthashdty = record       //hashed by byteshash
  glyph: unicharty;
  gdifuncs: pgdifunctionaty;   //gdi framework
  height: integer;
  width: integer;
  style: fontstylesty;         //fs_bold,fs_italic
  pitchoptions,familyoptions,antialiasedoptions: fontoptionsty;
  rotation: real; //0..1 -> 0deg..360deg CCW
  xscale: real;   //default 1.0
 end;

 fonthashdataty = record
  d: fonthashdty;
  name: string;      
  charset: string;
 end;
  
 fontdataty = record
  h: fonthashdataty;

  font: fontty;
  fonthighres: fontty;
  basefont: fontty;
  ascent,descent,linespacing,caretshift,linewidth: integer;
  platformdata: fontdatapty; //platform dependent
 end;
 pfontdataty = ^fontdataty;

 fontmetricsty = record
  leftbearing: integer; //left undersize, origin of left edge
  width: integer;       //character advance
  rightbearing: integer;//right undersize
  sum: integer;         //with - leftbearing - rightbearing, glyph width
 end;
 pfontmetricsty = ^fontmetricsty;



 rasteropty = (rop_clear,rop_and,rop_andnot,rop_copy,
                 rop_notand,rop_nop,rop_xor,rop_or,
                 rop_nor,rop_notxor,rop_not,rop_ornot,
                 rop_notcopy,rop_notor,rop_nand,rop_set);

 tfont = class;
 tsimplebitmap = class;
 fontchangedeventty = procedure(sender: tfont; changed: canvasstatesty) of object;

 fontstatety = (fsta_infovalid,fsta_none);
 fontstatesty = set of fontstatety;

 fontnumty = longword;

 tcanvas = class;

 fontaliasmodety = (fam_nooverwrite,    //do not change if allready registered
                    fam_overwrite,      //do change if allready registered not fam_fix
                    fam_fix,            //will never be changed
                    fam_fixnooverwrite);//do not change if allready registered,
                                        //fix existing
 fontinfoty = record
  handles: array[0..fontstylehandlemask] of fontnumty;
  color: colorty;
  colorbackground: colorty;
  shadow_color: colorty;
  shadow_shiftx: integer;
  shadow_shifty: integer;
  gloss_color: colorty;
  gloss_shiftx: integer;
  gloss_shifty: integer;
  style: fontstylesty;
  height: integer;
  width: integer;
  extraspace: integer;
  name: string;
  charset: string;
  options: fontoptionsty;
  glyph: unicharty;
  gdifuncs: pgdifunctionaty;
  rotation: real; //0..2*pi -> 0deg..360deg CCW
  xscale: real;   //default 1.0
 end;
 pfontinfoty = ^fontinfoty;

 icanvas = interface(inullinterface)
  procedure gcneeded(const sender: tcanvas);
  function getmonochrome: boolean;
  function getsize: sizety;
 end;
 
 gcpty = array[0..31] of pointer;
 gcty = record
  handle: ptruint;//cardinal;
  refgc: ptruint;//cardinal; //for windowsmetafile
  gdifuncs: pgdifunctionaty;
  drawingflags: drawingflagsty;
  cliporigin: pointty;
  paintdevicesize: sizety;
  ppmm: real;
  platformdata: gcpty; //platform dependent
 end;
 gcpoty = ^gcty;

 bufferty = record
  size: integer;
  buffer: pointer;
 end;

 pdrawinfoty = ^drawinfoty;
 rectinfoty = record         ///
  rect: prectty;              //
 end;                         // same layout!
 arcinfoty = record           //
  rect: prectty;             ///
  startang: real;
  extentang: real;
  pieslice: boolean;
 end;
 posinfoty = record          ///
  pos: ppointty;              //
 end;                         // same layout!
 textposinfoty = record       //
  pos: ppointty;             ///
  text: pchar;
  count: integer;
 end;
 text16posinfoty = record
  pos: ppointty;
  text: pmsechar;
  count: integer;
 end;
 pointsinfoty = record
  points: ppointty;
  count: integer;
  closed: boolean;
 end;
 colorinfoty = record
  color: colorty;
 end;
 getfontinfoty = record
  fontdata: pfontdataty;
  basefont: fontty;
  ok: boolean;
 end;
 {
 gettextwidthinfoty = record
  text: pchar;
  count: integer;
  datapo: pfontdataty;
 end;
 }
 gettext16widthinfoty = record
  text: pmsechar;
  count: integer;
  fontdata: pfontdataty;
  result: integer;
 end;
 {
 getcharwidthsinfoty = record
  text: pchar;
  count: integer;
  datapo: pfontdataty;
  resultpo: pinteger;
 end;
 }
 getchar16widthsinfoty = record
  text: pmsechar;
  count: integer;
  fontdata: pfontdataty;
  resultpo: pinteger;
 end;
 getfontmetricsinfoty = record
  char: msechar;
  fontdata: pfontdataty;
  resultpo: pfontmetricsty;
 end;
 copyareainfoty = record
  source: tcanvas{pdrawinfoty};     //can be equal to self
  sourcerect: prectty;
  destrect: prectty;
  tileorigin: ppointty;
  alignment: alignmentsty;
  copymode: rasteropty;
  transparentcolor: pixelty;
  mask: tsimplebitmap;
  transparency: rgbtriplety;
 end;
 fonthasglyphinfoty = record
  font: fontty;
  unichar: unicharty;
  hasglyph: boolean;
 end;

 rectsty = array[0..bigint div sizeof(rectty)] of rectty;
 prectsty = ^rectsty;
 regionoperationinfoty = record
  source,dest: regionty;
  rect: rectty;
  rectspo:  prectsty;
  rectscount: integer;
 end;
 
 gcvaluemaskty = (gvm_clipregion,gvm_colorbackground,gvm_colorforeground,
                  gvm_dashes,gvm_linewidth,gvm_capstyle,gvm_joinstyle,
                  gvm_lineoptions,
                  gvm_font,gvm_brush,gvm_brushorigin,gvm_rasterop,
                  gvm_brushflag);
 gcvaluemasksty = set of gcvaluemaskty;

 lineinfoty = record
  width: integer; //pixel shl linewidthshift
  dashes: dashesstringty;
  capstyle: capstylety;
  joinstyle: joinstylety;
  options: lineoptionsty;
 end;

 gcvaluesty = record
  mask: gcvaluemasksty;
  clipregion: regionty;
  colorbackground: pixelty;
  colorforeground: pixelty;
  font: fontty;
  fontnum: fontnumty;
  fontdata: pfontdataty;
  brush: tsimplebitmap;
  brushorigin: pointty;
  rasterop: rasteropty;
  lineinfo: lineinfoty;
 end;
 pgcvaluesty = ^gcvaluesty;
 
 drawinfoty = record
  buffer: bufferty;
  gc: gcty;
  statestamp: longword;
//  gcident: longword;
  paintdevice: paintdevicety;
  origin: pointty;
  acolorbackground,acolorforeground: colorty;
  gcvalues: pgcvaluesty; //valid in gui_changegc
  case integer of
   0: (rect: rectinfoty);
   1: (arc: arcinfoty);
   2: (pos: posinfoty);
   3: (textpos: textposinfoty);
   4: (text16pos: text16posinfoty);
   5: (points: pointsinfoty);
   6: (color: colorinfoty);
   7: (getfont: getfontinfoty);
//   8: (gettextwidth: gettextwidthinfoty);
   9: (gettext16width: gettext16widthinfoty);
//  10: (getcharwidths: getcharwidthsinfoty);
  11: (getchar16widths: getchar16widthsinfoty);
  12: (getfontmetrics: getfontmetricsinfoty);
  13: (copyarea: copyareainfoty);
  14: (regionoperation: regionoperationinfoty);
  15: (fonthasglyph: fonthasglyphinfoty);
 end;

 getfontfuncty = function (var drawinfo: drawinfoty): boolean of object;

 tfont = class(toptionalpersistent,icanvas)
  private
   finfopo: pfontinfoty;
   fonchange: notifyeventty;
   function getextraspace: integer;
   procedure setextraspace(const avalue: integer);
   procedure setcolorbackground(const Value: colorty);
   function getcolorbackground: colorty;

   procedure setshadow_color(avalue: colorty);
   function getshadow_color: colorty;
   procedure setshadow_shiftx(const avalue: integer);
   function getshadow_shiftx: integer;
   procedure setshadow_shifty(const avalue: integer);
   function getshadow_shifty: integer;

   procedure setgloss_color(avalue: colorty);
   function getgloss_color: colorty;
   procedure setgloss_shiftx(const avalue: integer);
   function getgloss_shiftx: integer;
   procedure setgloss_shifty(const avalue: integer);
   function getgloss_shifty: integer;

   procedure setcolor(const Value: colorty);
   function getcolor: colorty;
   procedure setheight(avalue: integer);
   function getheight: integer;
   function getwidth: integer;
   procedure setwidth(avalue: integer);
   procedure setstyle(const Value: fontstylesty);
   function getstyle: fontstylesty;
   function getascent: integer;
   function getdescent: integer;
   function getglyphheight: integer;
   function getlineheight: integer;
   function getcaretshift: integer;
   procedure updatehandlepo;
   procedure dochanged(const changed: canvasstatesty; 
                                    const nochange: boolean); virtual;
   procedure releasehandles(const nochanged: boolean = false);
   function getcharset: string;
   function getname: string;
   procedure setcharset(const Value: string);
   function getoptions: fontoptionsty;
   procedure setoptions(const avalue: fontoptionsty);
  //icanvas
   procedure gcneeded(const sender: tcanvas);
   function getmonochrome: boolean;
   function getsize: sizety;
   function getbold: boolean;
   procedure setbold(const avalue: boolean);
   function getitalic: boolean;
   procedure setitalic(const avalue: boolean);
   function getunderline: boolean;
   procedure setunderline(const avalue: boolean);
   function getstrikeout: boolean;
   procedure setstrikeout(const avalue: boolean);
   procedure createhandle(const canvas: tcanvas);
   function getrotation: real;
   procedure setrotation(const avalue: real);
   function getxscale: real;
   procedure setxscale(const avalue: real);
   
   procedure readcolorshadow(reader: treader);
   function getlinewidth: integer;
  protected
   finfo: fontinfoty;
   fhandlepo: ^fontnumty;
   function getfont(var drawinfo: drawinfoty): boolean; virtual;
   procedure setname(const Value: string); virtual;
   function gethandle: fontnumty; virtual;
   function getdatapo: pfontdataty;
   procedure assignproperties(const source: tfont; const handles: boolean);
   property rotation: real read getrotation write setrotation; 
                                 //0..2*pi-> 0degree..360degree CCW
   procedure defineproperties(filer: tfiler); override;
  public
   constructor create; override;
   destructor destroy; override;
   procedure assign(source: tpersistent); override;
   procedure scale(const ascale: real); virtual;

   function gethandleforcanvas(const canvas: tcanvas): fontnumty;
   property handle: fontnumty read gethandle;
   property ascent: integer read getascent;
   property descent: integer read getdescent;
   property glyphheight: integer read getglyphheight; //ascent + descent
   property lineheight: integer read getlineheight;
   property linewidth: integer read getlinewidth;
   property caretshift: integer read getcaretshift;
   property onchange: notifyeventty read fonchange write fonchange;
   
   property bold: boolean read getbold write setbold;
   property italic: boolean read getitalic write setitalic;
   property underline: boolean read getunderline write setunderline;
   property strikeout: boolean read getstrikeout write setstrikeout;   

  published
   property color: colorty read getcolor write setcolor default cl_text;
   property colorbackground: colorty read getcolorbackground
                 write setcolorbackground default cl_transparent;
   property shadow_color: colorty read getshadow_color
                 write setshadow_color default cl_none;
   property shadow_shiftx: integer read getshadow_shiftx write
                setshadow_shiftx default 1;
   property shadow_shifty: integer read getshadow_shifty write
                setshadow_shifty default 1;

   property gloss_color: colorty read getgloss_color
                 write setgloss_color default cl_none;
   property gloss_shiftx: integer read getgloss_shiftx write
                setgloss_shiftx default -1;
   property gloss_shifty: integer read getgloss_shifty write
                setgloss_shifty default -1;

   property height: integer read getheight write setheight default 0;
   property width: integer read getwidth write setwidth default 0;
                  //avg. character width in 1/10 pixel, 0 = default
   property extraspace: integer read getextraspace write setextraspace default 0;
   property style: fontstylesty read getstyle write setstyle default [];
   property name: string read getname write setname;
   property charset: string read getcharset write setcharset;
   property options: fontoptionsty read getoptions write setoptions default [];
   property xscale: real read getxscale write setxscale;
                                 //default 1.0
 end;
 pfont = ^tfont;
 fontarty = array of tfont;
 
 toptionalfont = class(tfont)
 end;
 
 tparentfont = class(tfont)
  public
   class function getinstancepo(owner: tobject): pfont; virtual; abstract;
 end;
 parentfontclassty = class of tparentfont;

 tcanvasfont = class(tfont)
  private
   fcanvas: tcanvas;
   procedure dochanged(const changed: canvasstatesty;
                              const nochange: boolean); override;
  protected
   function gethandle: fontnumty; override;
  public
   constructor create(const acanvas: tcanvas); reintroduce;
 end;

 gdifunctionty = procedure(var drawinfo: drawinfoty);

 gdifuncty = (gdf_destroygc,gdf_changegc,
              gdf_drawlines,gdf_drawlinesegments,gdf_drawellipse,gdf_drawarc,
              gdf_fillrect,
              gdf_fillelipse,gdf_fillarc,gdf_fillpolygon,{gdf_drawstring,}
              gdf_drawstring16,
              gdf_setcliporigin,
              gdf_createemptyregion,gdf_createrectregion,gdf_createrectsregion,
              gdf_destroyregion,gdf_copyregion,gdf_moveregion,
              gdf_regionisempty,gdf_regionclipbox,
              gdf_regsubrect,gdf_regsubregion,
              gdf_regaddrect,gdf_regaddregion,gdf_regintersectrect,
              gdf_regintersectregion,
              gdf_copyarea,gdf_fonthasglyph,
              gdf_getfont,gdf_getfonthighres,gdf_freefontdata,
              gdf_gettext16width,gdf_getchar16widths,gdf_getfontmetrics
              );

 gdifunctionaty = array[gdifuncty] of gdifunctionty;
// pgdifunctionaty = ^gdifunctionaty;

 canvasvaluesty = record
  changed: canvasstatesty;
  origin: pointty;
  brushorigin: pointty;
  clipregion: regionty;
  color: colorty;
  rasterop: rasteropty;
  colorbackground: colorty;
  font: fontinfoty;
  brush: tsimplebitmap;
  lineinfo: lineinfoty;
 end;

 canvasvaluespoty = ^canvasvaluesty;
 canvasvaluesarty = array of canvasvaluesty;

 canvasvaluestackty = record
  count: integer;
  stack: canvasvaluesarty;
 end;

 edgety = (edg_right,edg_top,edg_left,edg_bottom);
 edgesty = set of edgety;
 
 edgecolorinfoty = record
  color,effectcolor: colorty;
  effectwidth: integer;
 end;
 framecolorinfoty = record
  light,shadow: edgecolorinfoty;
  frame: colorty;
  hiddenedges: edgesty;
 end;

 imagety = record
  monochrome: boolean;
  bgr: boolean;
  size: sizety;
  length: integer;  //number of longword
  pixels: plongwordaty;
 end;
 pimagety = ^imagety;


 edgeinfoty = (kin_dark,kin_reverseend,kin_reversestart);
 edgeinfosty = set of edgeinfoty;

 gdiintffuncty = procedure (func: gdifuncty; var drawinfo: drawinfoty);
 canvasarty = array of tcanvas;
 
 tcanvas = class(tpersistent)
  private
   fvaluestack: canvasvaluestackty;
   gccolorbackground,gccolorforeground: colorty;
   fdefaultfont: fontnumty;
   fcliporigin: pointty;
   fgclinksto: canvasarty;
   fgclinksfrom: canvasarty;
//   fppmm: real;
   procedure adjustrectar(po: prectty; count: integer);
   procedure readjustrectar(po: prectty; count: integer);
   procedure error(nr: gdierrorty; const text: string);
   procedure intparametererror(value: integer; const text: string);
   procedure freevalues(var values: canvasvaluesty);

   function getcolor: colorty;
   procedure setcolor(const value: colorty);
   procedure setclipregion(const Value: regionty);
   function getorigin: pointty;
   procedure setorigin(const Value: pointty);


   function checkforeground(acolor: colorty; lineinfo: boolean): boolean;
   procedure checkcolors;
   procedure setfont(const Value: tfont);
   procedure updatefontinfo;
   function getbrush: tsimplebitmap;
   procedure setbrush(const Value: tsimplebitmap);
   function getbrushorigin: pointty;
   procedure setbrushorigin(const Value: pointty);
   function getrootbrushorigin: pointty;
   procedure setrootbrushorigin(const Value: pointty);
   function getcolorbackground: colorty;
   procedure setcolorbackground(const Value: colorty);
   function getrasterop: rasteropty;
   procedure setrasterop(const Value: rasteropty);
   function getdashes: dashesstringty;
   procedure setdashes(const Value: dashesstringty);
   function getlinewidth: integer;
   procedure setlinewidth(Value: integer);
   function getcapstyle: capstylety;
   function getjoinstyle: joinstylety;
   function getlineoptions: lineoptionsty;
   procedure setcapstyle(const Value: capstylety);
   procedure setjoinstyle(const Value: joinstylety);
   procedure setlineoptions(const avalue: lineoptionsty);
   procedure initregrect(const adest: regionty; const arect: rectty);
   procedure initregreg(const adest: regionty; const asource: regionty);
   procedure updatecliporigin(const Value: pointty);
   function getlinewidthmm: real;
   procedure setlinewidthmm(const avalue: real);
   function getmonochrome: boolean;
  protected
   fuser: tobject;
   fintf: pointer; //icanvas;
   fgdinum: integer;
   fstate: canvasstatesty;
   fvaluepo: canvasvaluespoty;
   fdrawinfo: drawinfoty;
   gcfonthandle1: fontnumty;
   afonthandle1: fontnumty;
   ffont: tfont;

   function getgdifuncs: pgdifunctionaty; virtual;
   procedure registergclink(const dest: tcanvas);
   procedure unregistergclink(const dest: tcanvas);
   procedure gcdestroyed(const sender: tcanvas); virtual;
   
   procedure setppmm(avalue: real); virtual;
   procedure valuechanged(value: canvasstatety);
   procedure valueschanged(values: canvasstatesty);
   procedure initgcvalues; virtual;
   procedure initgcstate; virtual;
   procedure finalizegcstate; virtual;
   procedure checkrect(const rect: rectty);
   procedure checkgcstate(state: canvasstatesty); virtual;
   procedure checkregionstate;  //copies region if necessary
   function defaultcliprect: rectty; virtual;
   function lock: boolean; virtual;
   procedure unlock; virtual;
   procedure gdi(const func: gdifuncty); virtual;
   procedure init;
   procedure internalcopyarea(asource: tcanvas; const asourcerect: rectty;
              const adestrect: rectty; acopymode: rasteropty;
              atransparentcolor: colorty;
              amask: tsimplebitmap;
              const aalignment: alignmentsty; 
              //only al_stretchx, al_stretchy and al_tiled used
              const atileorigin: pointty;
              const atransparency: colorty); //cl_none -> opaque);

   procedure setcliporigin(const Value: pointty);
               //value not saved!
   function getgchandle: ptruint;
   function getimage(const bgr: boolean): imagety; virtual;
   
   procedure fillarc(const def: rectty; const startang,extentang: real; 
                              const acolor: colorty; const pieslice: boolean);
   procedure getarcinfo(out startpo,endpo: pointty);
   procedure internaldrawtext(var info); virtual;
                       //info = drawtextinfoty
   function createfont: tcanvasfont; virtual;
   procedure drawfontline(const startpoint,endpoint: pointty); 
                           //draws line with font color 
   procedure nextpage; virtual; //used by tcustomprintercanvas
  public
   drawinfopo: pointer; //used to transport additional drawing information
   constructor create(const user: tobject; const intf: icanvas);
   destructor destroy; override;
   procedure linktopaintdevice(apaintdevice: paintdevicety; const gc: gcty;
                {const size: sizety;} const cliporigin: pointty); virtual;
         //calls reset, resets cliporigin, canvas owns the gc!
   function highresdevice: boolean;
   procedure initflags(const dest: tcanvas); virtual;
   procedure unlink; //frees gc
   procedure initdrawinfo(var adrawinfo: drawinfoty);
   function active: boolean;

   procedure reset; virtual;//clears savestack, origin and clipregion
   function save: integer; //returns actual saveindex
   function restore(index: integer = -1): integer; //-1 -> pop from stack
                     //returns actual saveindex
   procedure resetpaintedflag;

   procedure move(const dist: pointty);   //add dist to origin
   procedure remove(const dist: pointty); //sub dist from origin

   procedure copyarea(const asource: tcanvas; const asourcerect: rectty;
              const adestpoint: pointty; const acopymode: rasteropty = rop_copy;
              const atransparentcolor: colorty = cl_default;
              //atransparentcolor used for convert color to monochrome
              //cl_default -> colorbackground
              const atransparency: colorty = cl_none); overload;
   procedure copyarea(const asource: tcanvas; const asourcerect: rectty;
              const adestrect: rectty; const alignment: alignmentsty = [];
              const acopymode: rasteropty = rop_copy;
              const atransparentcolor: colorty = cl_default;
              //atransparentcolor used for convert color to monochrome
              //cl_default -> colorbackground
              const atransparency: colorty = cl_none); overload;

   procedure drawpoint(const point: pointty; const acolor: colorty = cl_default);
   procedure drawpoints(const apoints: array of pointty; 
                          const acolor: colorty = cl_default;
                          first: integer = 0; acount: integer = -1); //-1 -> all

   procedure drawline(const startpoint,endpoint: pointty; const acolor: colorty = cl_default);
   procedure drawlinesegments(const apoints: array of segmentty;
                         const acolor: colorty = cl_default);
   procedure drawlines(const apoints: array of pointty;
                       const aclosed: boolean = false; 
                       const acolor: colorty = cl_default;
                       const first: integer = 0; const acount: integer = -1);
                                                          //-1 -> all
   procedure drawvect(const startpoint: pointty; const direction: graphicdirectionty;
                      const length: integer; const acolor: colorty = cl_default);
                                                           overload;
   procedure drawvect(const startpoint: pointty; const direction: graphicdirectionty;
                      const length: integer; out endpoint: pointty;
                      const acolor: colorty = cl_default); overload;
                      
   procedure drawrect(const arect: rectty; const acolor: colorty = cl_default);
   procedure drawcross(const arect: rectty; const acolor: colorty = cl_default;
                   const alignment: alignmentsty = [al_xcentered,al_ycentered]);

   procedure drawellipse(const def: rectty; const acolor: colorty = cl_default);
                             //def.pos = center, def.cx = width, def.cy = height
   procedure drawellipse1(const def: rectty; const acolor: colorty = cl_default);
                             //def.pos = topleft
   procedure drawcircle(const center: pointty; const radius: integer;
                                               const acolor: colorty = cl_default);
   procedure drawarc(const def: rectty; const startang,extentang: real; 
                              const acolor: colorty = cl_default); overload;
                             //def.pos = center, def.cx = width, def.cy = height
                             //startang,extentang in radiant (2*pi = 360deg CCW)
   procedure drawarc1(const def: rectty; const startang,extentang: real; 
                              const acolor: colorty = cl_default);
                             //def.pos = topleft
   procedure drawarc(const center: pointty; const radius: integer;
                              const startang,extentang: real; 
                              const acolor: colorty = cl_default); overload;

   procedure fillrect(const arect: rectty; const acolor: colorty = cl_default;
                      const linecolor: colorty = cl_none);
   procedure fillellipse(const def: rectty; const acolor: colorty = cl_default;
                        const linecolor: colorty = cl_none);
                             //def.pos = center, def.cx = width, def.cy = height
   procedure fillellipse1(const def: rectty; const acolor: colorty = cl_default;
                        const linecolor: colorty = cl_none);
                             //def.pos = topleft
   procedure fillcircle(const center: pointty; const radius: integer;
                        const acolor: colorty = cl_default;
                        const linecolor: colorty = cl_none);
   procedure fillarcchord(const def: rectty; const startang,extentang: real; 
                              const acolor: colorty = cl_default;
                              const linecolor: colorty = cl_none); overload;
                             //def.pos = center, def.cx = width, def.cy = height
                             //startang,extentang in radiant (2*pi = 360deg CCW)
   procedure fillarcchord1(const def: rectty; const startang,extentang: real; 
                              const acolor: colorty = cl_default;
                              const linecolor: colorty = cl_none);
                             //def.pos = topleft
   procedure fillarcchord(const center: pointty; const radius: integer;
                              const startang,extentang: real; 
                              const acolor: colorty = cl_default;
                              const linecolor: colorty = cl_none); overload;
   procedure fillarcpieslice(const def: rectty; const startang,extentang: real; 
                            const acolor: colorty = cl_default;
                            const linecolor: colorty = cl_none); overload;
                             //def.pos = center, def.cx = width, def.cy = height
                             //startang,extentang in radiant (2*pi = 360deg CCW)
   procedure fillarcpieslice1(const def: rectty; const startang,extentang: real; 
                            const acolor: colorty = cl_default;
                            const linecolor: colorty = cl_none); overload;
                             //def.pos = topleft
   procedure fillarcpieslice(const center: pointty; const radius: integer;
                            const startang,extentang: real; 
                            const acolor: colorty = cl_default;
                            const linecolor: colorty = cl_none); overload;
   procedure fillpolygon(const apoints: array of pointty; 
                         const acolor: colorty = cl_default;
                         const linecolor: colorty = cl_none);
                         
   procedure drawframe(const arect: rectty; awidth: integer = -1;
                   const acolor: colorty = cl_default;
                   const hiddenedges: edgesty = []);
                    //no dashes, awidth < 0 -> inside frame,!
   procedure drawxorframe(const arect: rectty; const awidth: integer = -1;
                           const abrush: tsimplebitmap = nil); overload;
   procedure drawxorframe(const po1: pointty; const po2: pointty;
                           const awidth: integer = -1;
                                 const abrush: tsimplebitmap = nil); overload;
   procedure fillxorrect(const arect: rectty;
                        const abrush: tsimplebitmap = nil); overload;
   procedure fillxorrect(const start: pointty; const length: integer;
                      const direction: graphicdirectionty;
                      const awidth: integer = 0;
                      const abrush: tsimplebitmap = nil); overload;
   procedure drawstring(const atext: msestring; const apos: pointty;
                        const afont: tfont = nil; const grayed: boolean = false;
                        const arotation: real = 0); overload;
                         //0..2*pi-> 0degree..360degree CCW
   procedure drawstring(const atext: pmsechar; const acount: integer; const apos: pointty;
                        const afont: tfont = nil; const grayed: boolean = false;
                        const arotation: real = 0); overload;
   function getstringwidth(const atext: msestring; 
                                 const afont: tfont = nil): integer; overload;
   function getstringwidth(const atext: pmsechar; const acount: integer;
                                 const afont: tfont = nil): integer; overload;
                  //sum of cellwidths
   function getfontmetrics(const achar: msechar;
                                     const afont: tfont = nil): fontmetricsty;

                   //all boundaries of regionrects are clipped to
                   // -$8000..$7fff in device space
   procedure addcliprect(const rect: rectty);
   procedure addclipframe(const frame: rectty; inflate: integer);
   procedure subcliprect(const rect: rectty);
   procedure subclipframe(const frame: rectty; inflate: integer);
   procedure intersectcliprect(const rect: rectty);
   procedure intersectclipframe(const frame: rectty; inflate: integer);

   procedure addclipregion(const region: regionty);
   procedure subclipregion(const region: regionty);
   procedure intersectclipregion(const region: regionty);

   function copyclipregion: regionty;
                  //returns a copy of the current clipregion

   function clipregionisempty: boolean; //true if no drawing possible
   function clipbox: rectty; //smallest possible rect around clipregion

   function createregion: regionty; overload;
   function createregion(const asource: regionty): regionty; overload;
   function createregion(const arect: rectty): regionty; overload;
   function createregion(const rects: array of rectty): regionty; overload;
   function createregion(frame: rectty; const inflate: integer): regionty; overload;
   procedure destroyregion(region: regionty);

   procedure regmove(const adest: regionty; const dist: pointty);
   procedure regremove(const adest: regionty; const dist: pointty);
   procedure regaddrect(const dest: regionty; const rect: rectty);
   procedure regsubrect(const dest: regionty; const rect: rectty);
   procedure regintersectrect(const dest: regionty; const rect: rectty);
   procedure regaddregion(const dest: regionty; const region: regionty);
   procedure regsubregion(const dest: regionty; const region: regionty);
   procedure regintersectregion(const dest: regionty; const region: regionty);

   function regionisempty(const region: regionty): boolean;
   function regionclipbox(const region: regionty): rectty;
                 //returns nullrect if region = 0

   property origin: pointty read getorigin write setorigin;
   property clipregion: regionty {read getclipregion} write setclipregion;
                  //canvas owns the region!

   property monochrome: boolean read getmonochrome;
   property color: colorty read getcolor write setcolor default cl_black;
   property colorbackground: colorty read getcolorbackground
              write setcolorbackground default cl_transparent;
   property rasterop: rasteropty read getrasterop write setrasterop default rop_copy;
   property font: tfont read ffont write setfont;
   property brush: tsimplebitmap read getbrush write setbrush;
   property brushorigin: pointty read getbrushorigin write setbrushorigin;
   property rootbrushorigin: pointty read getrootbrushorigin write setrootbrushorigin;
                   //origin = paintdevice top left
   procedure adjustbrushorigin(const arect: rectty; 
                                               const alignment: alignmentsty);

   property linewidth: integer read getlinewidth write setlinewidth default 0;
   property linewidthmm: real read getlinewidthmm write setlinewidthmm;
   
   property dashes: dashesstringty read getdashes write setdashes;
     //last byte 0 -> opaque dash  //todo: dashoffset
   property capstyle: capstylety read getcapstyle write setcapstyle
                default cs_butt;
   property joinstyle: joinstylety read getjoinstyle write setjoinstyle
                default js_miter;
   property lineoptions: lineoptionsty read getlineoptions write setlineoptions
                default [];

   property paintdevice: paintdevicety read fdrawinfo.paintdevice;
   property gchandle: ptruint read getgchandle;
   property ppmm: real read fdrawinfo.gc.ppmm write setppmm; 
                   //used for linewidth mm, value not saved/restored
   property statestamp: longword read fdrawinfo.statestamp; 
                 //incremented by drawing operations
 end;

 pixmapstatety = (pms_monochrome,pms_ownshandle,pms_maskvalid,pms_nosave);
 pixmapstatesty = set of pixmapstatety;

 pixmapinfoty = record
  handle: pixmapty;
  size: sizety;
  depth: integer;
 end;

 tsimplebitmap = class(tnullinterfacedpersistent,icanvas)
  private
   function gethandle: pixmapty;
   procedure sethandle(const Value: pixmapty);
   procedure gcneeded(const sender: tcanvas);
   function getcanvas: tcanvas;
   procedure switchtomonochrome;
   function getsize: sizety;
  protected
   fcanvas: tcanvas;
   fhandle: pixmapty;
   fsize: sizety;
   fstate: pixmapstatesty;
   fcolorbackground: colorty;
   fcolorforeground: colorty;
   fdefaultcliporigin: pointty;
   function createcanvas: tcanvas; virtual;
   procedure creategc;
   procedure internaldestroyhandle;
   procedure destroyhandle; virtual;
   procedure createhandle(copyfrom: pixmapty); virtual;
   function getmonochrome: boolean;
   procedure setmonochrome(const avalue: boolean); virtual;
   function getconverttomonochromecolorbackground: colorty; virtual;
   function getmask: tsimplebitmap; virtual;
//   function getmaskhandle(var gchandle: ptruint): pixmapty; virtual;
                  //gc handle is invalid if result = 0,
                  //gc handle can be 0
//   function getimagepo: pimagety; virtual;
   procedure initimage(alloc: boolean; out aimage: imagety);
                  //sets inf in aimage acording to self,
                  //allocates memory if alloc = true, no clear
   procedure setsize(const Value: sizety); virtual;
   function normalizeinitcolor(const acolor: colorty): colorty;
   procedure assign1(const source: tsimplebitmap; const docopy: boolean); virtual;
  public
   constructor create(monochrome: boolean); reintroduce;
   destructor destroy; override;

   procedure copyhandle;
   procedure releasehandle; virtual;
   procedure acquirehandle; virtual;
   property handle: pixmapty read gethandle write sethandle;

   procedure assign(source: tpersistent); override;
   procedure assignnegative(source: tsimplebitmap);
                      //gets negative copy
   procedure clear;//sets with and height to 0
   procedure init(const acolor: colorty); virtual;
   procedure freecanvas;
   function canvasallocated: boolean;
   procedure copyarea(const asource: tsimplebitmap; const asourcerect: rectty;
              const adestpoint: pointty; const acopymode: rasteropty = rop_copy;
              const masked: boolean = true;
              const acolorforeground: colorty = cl_default; //cl_default -> asource.colorforeground
                    //used for monochrome -> color conversion
              const acolorbackground: colorty = cl_default;//cl_default -> asource.colorbackground
                    //used for monochrome -> color conversion or
                    //colorbackground for color -> monochrome conversion
              const atransparency: colorty = cl_none); overload;
   procedure copyarea(const asource: tsimplebitmap; const asourcerect: rectty;
              const adestrect: rectty; const aalignment: alignmentsty = [];
              const acopymode: rasteropty = rop_copy;
              const masked: boolean = true;
              const acolorforeground: colorty = cl_default; //cl_default -> asource.colorforeground
                    //used for monochrome -> color conversion
              const acolorbackground: colorty = cl_default;//cl_default -> asource.colorbackground
                    //used for monochrome -> color conversion or
                    //colorbackground for color -> monochrome conversion
              const atransparency: colorty = cl_none); overload;

   property canvas: tcanvas read getcanvas;
   property size: sizety read fsize write setsize;
         //pixels are not inited
   function isempty: boolean;
   property monochrome: boolean read getmonochrome write setmonochrome;
 end;

const
 {$ifdef FPC}
  {$warnings off}
 {$endif}
 nullgc: gcty = (handle: 0);
 {$ifdef FPC}
  {$warnings on}
 {$endif}
 changedmask = [cs_clipregion,cs_origin,cs_rasterop,
                cs_acolorbackground,cs_acolorforeground,
                cs_color,cs_colorbackground,
                cs_fonthandle,cs_font,cs_fontcolor,cs_fontcolorbackground,
                cs_fonteffect,
                cs_brush,cs_brushorigin] + linecanvasstates;
var
 defaultframecolors: framecolorinfoty =
  (light: (color: cl_light; effectcolor: cl_highlight; effectwidth: 1);
   shadow: (color: cl_shadow; effectcolor: cl_dkshadow; effectwidth: 1);
   frame: cl_black;
   hiddenedges: []
  );

procedure init;
procedure deinit;
procedure gdi_lock;   //locks only if not mainthread
procedure gdi_unlock; //unlocks only if not mainthread
procedure gdi_call(const func: gdifuncty; var drawinfo: drawinfoty);
function registergdi(const agdifuncs: pgdifunctionaty): integer;
                                            //returns unique number
procedure freefontdata(var drawinfo: drawinfoty);

procedure allocbuffer(var buffer: bufferty; size: integer);
procedure freebuffer(var buffer: bufferty);

procedure gdierrorlocked(error: gdierrorty; const text: string = ''); overload;
procedure gdierrorlocked(error: gdierrorty; sender: tobject; text: string = ''); overload;

function colortorgb(color: colorty): rgbtriplety;
function colortopixel(color: colorty): pixelty;
function rgbtocolor(const red,green,blue: integer): colorty;
function blendcolor(const weight: real; const a,b: colorty): colorty;
                       //0..1

procedure setcolormapvalue(index: colorty; const red,green,blue: integer); overload;
                    //RGB values 0..255
procedure setcolormapvalue(const index: colorty; const acolor: colorty); overload;
function isvalidmapcolor(index: colorty): boolean;

procedure drawdottedlinesegments(const acanvas: tcanvas; const lines: segmentarty;
             const colorline: colorty);

var
 flushgdi: boolean;
{$ifdef mse_debuggdisync}
procedure checkgdilock;
procedure checkgdiunlocked;
{$endif}

implementation
uses
 SysUtils,msegui,mseguiintf,msestreaming,mseformatstr,msestockobjects,
 msedatalist,mselist,msebits,msewidgets,msesysintf,msesysutils,msefont;

var
 gdilockcount: integer;
 gdilocked: boolean;
 
{$ifdef mse_debuggdisync}
procedure gdilockerror(const text: string);
var
 str1: string;
begin
 str1:= text+lineend+
      'currentth:'+inttostr(sys_getcurrentthread)+
      ' mainth:'+inttostr(application.mainthread)+
      ' applockth:'+inttostr(application.lockthread)+
      ' applockc:'+inttostr(application.lockcount)+lineend+
      ' gdilockc:'+inttostr(gdilockcount)+lineend+
      'appmutexlockth:'+inttostr(appmutexlockth)+
      ' appmutexunlockth:'+inttostr(appmutexunlockth)+
      ' appmutexlockc:'+inttostr(appmutexlockc)+
      ' appmutexunlockc:'+inttostr(appmutexunlockc)+
      ' appmutexlocks:'+inttostr(appmutexlocks)+
      ' appmutexunlocks:'+inttostr(appmutexunlocks);
 debugwriteln(str1);
 debugwritestack;
end;

procedure checkgdilock;
begin
 if not application.locked then begin
  gdilockerror('GDI lock error.');
 end;
end;

procedure checkgdiunlocked;
begin
 if gdilockcount <> 0 then begin
  gdilockerror('GDI unlock error.');
 end;
end;
{$endif}

procedure gdi_lock;
begin
 with application do begin
  if not locked then begin
   lock;
   gdilocked:= true;
  end;
  inc(gdilockcount);
 end;
end;

procedure gdi_unlock;
begin
 with application do begin
  dec(gdilockcount);
  if gdilocked and (gdilockcount = 0) then begin
   gdilocked:= false;
   unlock;
  end;
 end;
end;

procedure gdi_call(const func: gdifuncty; var drawinfo: drawinfoty);
begin
 with application do begin
  if not locked then begin
   lock;
   try
    gui_getgdifuncs^[func](drawinfo);
    if flushgdi then begin
     gui_flushgdi;
    end;
   finally
    unlock;
   end;
  end
  else begin
   gui_getgdifuncs^[func](drawinfo);
   if flushgdi then begin
    gui_flushgdi;
   end;
  end;
 end;
end;

procedure drawdottedlinesegments(const acanvas: tcanvas; const lines: segmentarty;
                     const colorline: colorty);
var
 int1: integer;
 {$ifdef windows}
 int2: integer;
 {$endif}
begin                         
 acanvas.save;
 acanvas.color:= colorline;
 acanvas.brush:= stockobjects.bitmaps[stb_dens50];
{$ifdef mswindows}
 {workaround: colors are wrong by negativ x on win2000! bug?}
 {
 int2:= levelshift;
 acanvas.remove(makepoint(int2,0));
 for int1:= 0 to high(lines) do begin
  inc(lines[int1].a.x,int2);
  inc(lines[int1].b.x,int2);
 end;
 }
 if iswin95 then begin //win95 can not draw brushed lines
  for int1:= 0 to high(lines) do begin
   with lines[int1] do begin
    if a.x <> b.x then begin
     acanvas.fillrect(makerect(a.x,a.y,b.x-a.x+1,1),cl_brushcanvas);
    end
    else begin
     acanvas.fillrect(makerect(a.x,a.y,1,b.y-a.y+1),cl_brushcanvas);
    end;
   end;
  end;
 end
 else begin
{$endif}
  acanvas.drawlinesegments(lines,cl_brushcanvas);
{$ifdef mswindows}
 end;
{$endif}
 acanvas.restore;
end;

var
 colormaps: array[colormapsty] of array of pixelty;
 inited: boolean;

function checkfontoptions(const new,old: fontoptionsty): fontoptionsty;
const
 mask1: fontoptionsty = fontpitchmask;
 mask2: fontoptionsty = fontfamilymask;
 mask3: fontoptionsty = fontantialiasedmask;
// mask4: fontoptionsty = fontxcoremask;
var
 value1: fontoptionsty;
 value2: fontoptionsty;
 value3: fontoptionsty;
// value4: fontoptionsty;
begin
  value1:= fontoptionsty(
         setsinglebit({$ifdef FPC}longword{$else}byte{$endif}(new),
                      {$ifdef FPC}longword{$else}byte{$endif}(old),
                      {$ifdef FPC}longword{$else}byte{$endif}(mask1)));
  value2:= fontoptionsty(
         setsinglebit({$ifdef FPC}longword{$else}byte{$endif}(new),
                      {$ifdef FPC}longword{$else}byte{$endif}(old),
                      {$ifdef FPC}longword{$else}byte{$endif}(mask2)));
  value3:= fontoptionsty(
         setsinglebit({$ifdef FPC}longword{$else}byte{$endif}(new),
                      {$ifdef FPC}longword{$else}byte{$endif}(old),
                      {$ifdef FPC}longword{$else}byte{$endif}(mask3)));
(*                      
  value4:= fontoptionsty(
         setsinglebit({$ifdef FPC}longword{$else}byte{$endif}(new),
                      {$ifdef FPC}longword{$else}byte{$endif}(old),
                      {$ifdef FPC}longword{$else}byte{$endif}(mask4)));
*)
  result:= value1 * mask1 + value2 * mask2 + value3 * mask3 {+ value4 * mask4};
end;

procedure freebuffer(var buffer: bufferty);
begin
 if buffer.buffer <> nil then begin
//  freemem(buffer.buffer,buffer.size);
  freemem(buffer.buffer);
  buffer.size:= 0;
  buffer.buffer:= nil;
 end;
end;

procedure allocbuffer(var buffer: bufferty; size: integer);
begin
 if size > buffer.size then begin
  freebuffer(buffer);
  getmem(buffer.buffer,size);
  buffer.size:= size;
 end;
end;

procedure gdierrorlocked(error: gdierrorty; const text: string = ''); overload;
begin
 gdi_unlock;
 gdierror(error,text);
end;

procedure gdierrorlocked(error: gdierrorty; sender: tobject;
                       text: string = ''); overload;
begin
 gdi_unlock;
 gdierror(error,sender,text);
end;

function getdefaultcolorinfo(map: colormapsty; index: integer): pcolorinfoty;
begin
 case map of
  cm_functional: begin
   result:= @defaultfunctional[index];
  end;
  cm_mapped: begin
   result:= @defaultmapped[index];
  end;
  cm_namedrgb: begin
   result:= @defaultnamedrgb[index];
  end;
  cm_user: begin
   result:= @defaultuser[index];
  end;
  else begin
   result:= nil;
  end;
 end;
end;

function colortorgb(color: colorty): rgbtriplety;
var
 map: colormapsty;
begin
 map:= colormapsty((longword(color) shr speccolorshift));
 color:= colorty(longword(color) and not speccolormask);
 if map = cm_rgb then begin
  result:= rgbtriplety(color);
 end
 else begin
  dec(map,7);
  if (map < cm_rgb) or (map > high(map)) or
       (longword(color) >= longword(mapcolorcounts[map])) then begin
   gdierror(gde_invalidcolor,
       hextostr(longword(color)+longword(map) shl speccolorshift,8));
  end;
  result:= rgbtriplety(gui_pixeltorgb(colormaps[map][longword(color)]));
 end;
end;

function colortopixel(color: colorty): pixelty;
var
 map: colormapsty;
begin
 map:= colormapsty((longword(color) shr speccolorshift));
 color:= colorty(longword(color) and not speccolormask);
 if map = cm_rgb then begin
  result:= gui_rgbtopixel(color);
 end
 else begin
  dec(map,7);
  if (map < cm_rgb) or (map > high(map)) or
       (longword(color) >= longword(mapcolorcounts[map])) then begin
   gdierror(gde_invalidcolor,
       hextostr(longword(color)+longword(map) shl speccolorshift,8));
  end;
  result:= colormaps[map][longword(color)];
 end;
end;

function rgbtocolor(const red,green,blue: integer): colorty;
begin
 result:= (blue and $ff) or ((green and $ff) shl 8) or ((red and $ff) shl 16);
end;

function blendcolor(const weight: real; const a,b: colorty): colorty;
var
 by1: byte;
 ca,cb: rgbtriplety;
begin
 ca:= colortorgb(a);
 cb:= colortorgb(b);
 rgbtriplety(result).red:= ca.red + round((cb.red - ca.red)*weight);
 rgbtriplety(result).green:= ca.green + round((cb.green - ca.green)*weight);
 rgbtriplety(result).blue:= ca.blue + round((cb.blue - ca.blue)*weight);
 rgbtriplety(result).res:= 0;
end;

function initcolormap: boolean;
var
 colormap: colormapsty;
 int1: integer;
begin
 result:= true;
 for colormap:= low(colormapsty) to high(colormapsty) do begin
  setlength(colormaps[colormap],mapcolorcounts[colormap]);
 {$ifdef FPC} {$checkpointer off} {$endif}
  for int1:= 0 to mapcolorcounts[colormap] - 1 do begin
   colormaps[colormap][int1]:= gui_rgbtopixel(
        longword(getdefaultcolorinfo(colormap,int1)^.rgb));
  end;
 {$ifdef FPC} {$checkpointer default} {$endif}
 end;
 colormaps[cm_namedrgb,integer(longword(cl_0)-longword(cl_namedrgb))]:= 
                                                              mseguiintf.pixel0;
 colormaps[cm_namedrgb,integer(longword(cl_1)-longword(cl_namedrgb))]:= 
                                                              mseguiintf.pixel1;
 gui_initcolormap;
end;

function isvalidmapcolor(index: colorty): boolean;
var
 map: colormapsty;
begin
 result:= true;
 application.initialize; //colormap must be valid
 map:= colormapsty((longword(index) shr speccolorshift));
 index:= colorty(longword(index) and not speccolormask);
 dec(map,7);
 if (map <= cm_rgb) or (map > high(map)) or
       (longword(index) >= longword(mapcolorcounts[map])) then begin
  result:= false;
 end;
end;

procedure setcolormapvalue(index: colorty; const red,green,blue: integer);
var
 map: colormapsty;
begin
 application.initialize; //colormap must be valid
 map:= colormapsty((longword(index) shr speccolorshift));
 index:= colorty(longword(index) and not speccolormask);
 dec(map,7);
 if (map <= cm_rgb) or (map > high(map)) or
       (longword(index) >= longword(mapcolorcounts[map])) then begin
  gdierror(gde_invalidcolor,
       hextostr(longword(index)+longword(map) shl speccolorshift,8));
 end;
 colormaps[map][longword(index)]:= gui_rgbtopixel(rgbtocolor(red,green,blue));
end;

procedure setcolormapvalue(const index: colorty; const acolor: colorty);
var
 rgb1: rgbtriplety;
begin
 rgb1:= colortorgb(acolor);
 setcolormapvalue(index,rgb1.red,rgb1.green,rgb1.blue);
end;

var
 gdinum: integer;
 gdifuncs: array of pgdifunctionaty;
 
function registergdi(const agdifuncs: pgdifunctionaty): integer; 
                         //returns unique number
begin
 inc(gdinum);
 setlength(gdifuncs,gdinum+1); //item 0 = system default
 gdifuncs[gdinum]:= agdifuncs;
 result:= gdinum;
end;

procedure freefontdata(var drawinfo: drawinfoty);
begin
 drawinfo.getfont.fontdata^.h.d.gdifuncs^[gdf_freefontdata](drawinfo);
end;

procedure init;
var
 icon,mask: pixmapty;
begin
 gdi_lock;
 try
  initcolormap;
  msefont.init;
  msestockobjects.init;
  inited:= true;
  getwindowicon(nil,icon,mask);
  gui_setapplicationicon(icon,mask);
 finally
  gdi_unlock;
 end;
end;

procedure deinit;
begin
 if inited then begin
  msestockobjects.deinit;
  msefont.deinit;
 end;
 inited:= false;
end;


 { tsimplebitmap }

constructor tsimplebitmap.create(monochrome: boolean);
begin
 if monochrome then begin
  include(fstate,pms_monochrome);
 end;
 fcolorbackground:= cl_white;
 fcolorforeground:= cl_black;
end;

destructor tsimplebitmap.destroy;
begin
 inherited;
 destroyhandle;
 freecanvas;
end;

procedure tsimplebitmap.freecanvas;
begin
 freeandnil(fcanvas);
end;

function tsimplebitmap.canvasallocated: boolean;
begin
 result:= fcanvas <> nil;
end;

procedure tsimplebitmap.clear;
begin
 size:= nullsize;
end;

function tsimplebitmap.getmonochrome: boolean;
begin
 result:= pms_monochrome in fstate;
end;

function tsimplebitmap.getconverttomonochromecolorbackground: colorty;
begin
 result:= fcolorbackground;
end;

procedure tsimplebitmap.setmonochrome(const avalue: boolean);
var
 bmp: tsimplebitmap;
 ahandle: pixmapty;
begin
 if avalue <> getmonochrome then begin
  if isempty then begin
   if avalue then begin
    include(fstate,pms_monochrome);
   end
   else begin
    exclude(fstate,pms_monochrome);
   end
  end
  else begin
   if avalue then begin
    bmp:= tsimplebitmap.create(true);
    bmp.size:= fsize;
    bmp.canvas.copyarea(canvas,makerect(nullpoint,fsize),nullpoint,rop_copy,
       getconverttomonochromecolorbackground);
   end
   else begin
    bmp:= tsimplebitmap.create(false);
    bmp.size:= fsize;
    bmp.canvas.colorbackground:= fcolorbackground;
    bmp.canvas.color:= fcolorforeground;
    bmp.canvas.copyarea(canvas,makerect(nullpoint,fsize),nullpoint);
   end;
   ahandle:= bmp.fhandle;
   bmp.releasehandle;
   bmp.Free;
   handle:= ahandle;
   acquirehandle;
  end;
 end;
end;

procedure tsimplebitmap.switchtomonochrome;
begin
 include(fstate,pms_monochrome);
 if fcanvas <> nil then begin
  fcanvas.init;
 end;
end;

procedure tsimplebitmap.creategc;
var
 gc: gcty;
 err: guierrorty;
begin
 if fcanvas <> nil then begin
  fillchar(gc,sizeof(gcty),0);
  gc.drawingflags:= [df_canvasispixmap];
  gc.paintdevicesize:= fsize;
  if pms_monochrome in fstate then begin
   include(gc.drawingflags,df_canvasismonochrome);
  end;
  gdi_lock;
  err:= gui_creategc(fhandle,gck_pixmap,gc);
  gdi_unlock;
  guierror(err,self);
  fcanvas.linktopaintdevice(fhandle,gc,fdefaultcliporigin);
 end;
end;

function tsimplebitmap.createcanvas: tcanvas;
begin
 result:= tcanvas.create(self,icanvas(self));
end;

function tsimplebitmap.getcanvas: tcanvas;
begin
 if fcanvas = nil then begin
  fcanvas:= createcanvas;
 end;
 result:= fcanvas;
end;

procedure tsimplebitmap.createhandle(copyfrom: pixmapty);
      //copyfrom does not work on windws with in dc selected bmp!
begin
 if (fsize.cx > 0) and (fsize.cy > 0) then begin
  if fhandle = 0 then begin
   gdi_lock;
   fhandle:= gui_createpixmap(fsize,0,pms_monochrome in fstate,copyfrom);
   gdi_unlock;
   if fhandle = 0 then begin
    gdierror(gde_pixmap);
   end;
   include(fstate,pms_ownshandle);
  end;
 end;
end;

procedure tsimplebitmap.releasehandle;
begin
 if fhandle <> 0 then begin
  if fcanvas <> nil then begin
   fcanvas.unlink;
  end;
//  fhandle:= 0;
  exclude(fstate,pms_ownshandle);
 end;
end;

procedure tsimplebitmap.acquirehandle;
begin
 if fhandle <> 0 then begin
  include(fstate,pms_ownshandle);
 end;
end;

procedure tsimplebitmap.copyhandle;
var
 ahandle: pixmapty;
begin
 releasehandle;
 ahandle:= fhandle;
 fhandle:= 0;
 createhandle(ahandle);
end;

procedure tsimplebitmap.internaldestroyhandle;
var
 bo1: boolean;
begin
 if fhandle <> 0 then begin
  bo1:= pms_ownshandle in fstate;
  releasehandle;
  if bo1 then begin
   gdi_lock;
   gui_freepixmap(fhandle);
   gdi_unlock;
  end;
  fhandle:= 0;
 end;
end;

procedure tsimplebitmap.destroyhandle;
begin
 internaldestroyhandle;
end;

function tsimplebitmap.getsize: sizety;
begin
 result:= fsize;
end;

procedure tsimplebitmap.setsize(const Value: sizety);
begin
 destroyhandle;
 fsize := Value;
end;

function tsimplebitmap.isempty: boolean;
begin
 result:= (fsize.cx = 0) or (fsize.cy = 0);
end;

function tsimplebitmap.gethandle: pixmapty;
begin
 if fhandle = 0 then begin
  createhandle(0);
 end;
 result:= fhandle;
end;

procedure tsimplebitmap.sethandle(const Value: pixmapty);
var
 info: pixmapinfoty;
begin
 if fhandle <> value then begin
  internaldestroyhandle;
 end;
 if value <> 0 then begin
  info.handle:= value;
  gdi_lock;
  try
  gdierror(gui_getpixmapinfo(info));
  finally
   gdi_unlock;
  end;
  fhandle:= value;
  with info do begin
   fsize:= size;
   if depth = 1 then begin
    include(fstate,pms_monochrome);
   end
   else begin
    exclude(fstate,pms_monochrome);
   end;
  end;
 end;
end;

procedure tsimplebitmap.gcneeded(const sender: tcanvas);
begin
 if isempty then begin
  gdierror(gde_pixmap);
 end
 else begin
  if not (pms_ownshandle in fstate) and (fhandle <> 0) then begin
   copyhandle;
  end
  else begin
   createhandle(0);
  end;
  creategc;
 end;
end;

function tsimplebitmap.normalizeinitcolor(const acolor: colorty): colorty;
begin
 if acolor = cl_transparent then begin
  if getmonochrome then begin
   result:= cl_0;
  end
  else begin
   result:= cl_white;
  end;
 end
 else begin
  result:= acolor;
 end;
end;

procedure tsimplebitmap.init(const acolor: colorty);
begin
 with canvas.fvaluepo^.origin do begin
  canvas.fillrect(makerect(-x,-y,fsize.cx,fsize.cy),normalizeinitcolor(acolor));
 end;
end;

procedure tsimplebitmap.assign1(const source: tsimplebitmap; const docopy: boolean);
begin
 clear;
 with tsimplebitmap(source) do begin
  if not isempty then begin
   if docopy then begin
 //   self.handle:= handle; //windows problem: copy handle does not work with bmp selected in dc
 //   self.copyhandle;
    self.monochrome:= monochrome;
    self.size:= size;
    self.copyarea(source,makerect(nullpoint,fsize),nullpoint,rop_copy,false);
   end
   else begin
    self.handle:= handle;
    releasehandle;
    self.acquirehandle;
   end;
  end;
 end;
end;

procedure tsimplebitmap.assign(source: tpersistent);
begin
 if source is tsimplebitmap then begin
  assign1(tsimplebitmap(source),true);
 end
 else begin
  inherited;
 end;
end;

procedure tsimplebitmap.assignnegative(source: tsimplebitmap);
                       //gets negative copy
begin
 clear;
 monochrome:= source.monochrome;
 if not source.isempty then begin
  size:= source.size;
  copyarea(source,makerect(nullpoint,fsize),nullpoint,rop_notcopy);
 end;
end;

procedure tsimplebitmap.copyarea(const asource: tsimplebitmap;
              const asourcerect: rectty;
              const adestrect: rectty; const aalignment: alignmentsty = [];
              const acopymode: rasteropty = rop_copy;
              const masked: boolean = true;
              const acolorforeground: colorty = cl_default; 
                    //cl_default -> asource.colorforeground
                    //used for monochrome -> color conversion
              const acolorbackground: colorty = cl_default;
                    //cl_default -> asource.colorbackground
                    //used for monochrome -> color conversion or
                    //colorbackground for color -> monochrome conversion
              const atransparency: colorty = cl_none);
var
 bo1,bo2: boolean;
 amask: tsimplebitmap;
begin
 bo1:= canvasallocated;
 bo2:= asource.canvasallocated;
 if bo1 then begin
  canvas.save;
  canvas.clipregion:= 0;
  canvas.origin:= nullpoint;
 end;
 if bo2 then begin
  asource.canvas.save;
  asource.canvas.origin:= nullpoint;
 end;
 if acolorforeground = cl_default then begin
  canvas.color:= asource.fcolorforeground;
 end
 else begin
  canvas.color:= acolorforeground;
 end;
 if acolorbackground = cl_default then begin
  canvas.colorbackground:= asource.fcolorbackground;
 end
 else begin
  canvas.colorbackground:= acolorbackground;
 end;
 if masked then begin
  amask:= asource.getmask;
 end
 else begin
  amask:= nil;
 end;
 canvas.internalcopyarea(asource.canvas,asourcerect,
                         adestrect,acopymode,
                         cl_default,amask,aalignment,nullpoint,atransparency);
 if bo1 then begin
  canvas.restore;
 end
 else begin
  freecanvas;
 end;
 if bo2 then begin
  asource.canvas.restore;
 end
 else begin
  asource.freecanvas;
 end;
end;

procedure tsimplebitmap.copyarea(const asource: tsimplebitmap; const asourcerect: rectty;
              const adestpoint: pointty; const acopymode: rasteropty = rop_copy;
              const masked: boolean = true;
              const acolorforeground: colorty = cl_default; //cl_default -> asource.colorforeground
                    //used if asource is monchrome
              const acolorbackground: colorty = cl_default;//cl_default -> asource.colorbackground
                    //used if asource is monchrome or
                    //colorbackground for color -> monochrome conversion
              const atransparency: colorty = cl_none);
begin
 copyarea(asource,asourcerect,makerect(adestpoint,asourcerect.size),[],acopymode,
                        masked,acolorforeground,acolorbackground,atransparency);
end;

{
procedure tsimplebitmap.stretch(const source: tsimplebitmap; const asize: sizety);
type
 cardarty = array[0..0] of longword;
var
 sim: pimagety;
 simage,dimage: imagety;
 po1: ^cardarty;
 po2: plongword;
 ca1,ca2: longword;
 stepx: longword;
 int1: integer;
begin
 if source.isempty then begin
  gdierror(gde_pixmap,self,'stretch');
 end;
 if source <> self then begin
  clear;
  if source.monochrome <> monochrome then begin
   gdierror(gde_unmatchedmonochrome,self,'stretch');
  end;
  if monochrome then begin
   include(fstate,pms_monochrome);
  end
  else begin
   exclude(fstate,pms_monochrome);
  end;
 end;
 sim:= source.getimagepo;
 if sim = nil then begin
  source.initimage(false,simage);
 end
 else begin
  simage:= sim^;
 end;
 if simage.pixels = nil then begin
  if source.fcanvas <> nil then begin
   gdierror(gui_pixmaptoimage(source.handle,simage,source.fcanvas.fdrawinfo.gc.handle))
  end
  else begin
   gdierror(gui_pixmaptoimage(source.handle,simage,0))
  end;
 end;
 size:= asize;
 initimage(true,dimage);
 if monochrome then begin
 end
 else begin
  po1:= pointer(simage.pixels);
  po2:= pointer(dimage.pixels);
  stepx:= ((($10000*simage.size.cx) + $8000) div dimage.size.cx) shl 15;
  ca2:= 0;
  for int1:= 0 to asize.cx - 1 do begin
   ca1:= po1^[int1];
   repeat
    po2^:= ca1;
    inc(po2);
    inc(ca2,stepx);
   until integer(ca2) < 0;
   dec(ca2,$80000000);
  end;
 end;
end;
}
{
function tsimplebitmap.getmaskhandle(var gchandle: ptruint): pixmapty;
begin
 result:= 0; //dummy
end;
}

function tsimplebitmap.getmask: tsimplebitmap;
begin
 result:= nil; //dummy
end;
{
function tsimplebitmap.getimagepo: pimagety;
begin
 result:= nil; //dummy
end;
}
procedure tsimplebitmap.initimage(alloc: boolean; out aimage: imagety);
                  //allocates memory, no clear
var
 int1: integer;
begin
 with aimage do begin
  monochrome:= pms_monochrome in fstate;
  pixels:= nil;
  size:= fsize;
  if alloc and (size.cx <> 0) and (size.cy <> 0) then begin
   if monochrome then begin
    int1:= fsize.cy * ((fsize.cx+31) div 32);
   end
   else begin
    int1:= fsize.cy * fsize.cx;
   end;
   allocuninitedarray(int1,sizeof(longword),pixels);
  end;
 end;
end;

{ tfont }

constructor tfont.create;
begin
 if finfopo = nil then begin
  finfopo:= @finfo;
 end;
 finfopo^.color:= cl_text;
 finfopo^.colorbackground:= cl_transparent;
 finfopo^.shadow_color:= cl_none;
 finfopo^.shadow_shiftx:= 1;
 finfopo^.shadow_shifty:= 1;

 finfopo^.gloss_color:= cl_none;
 finfopo^.gloss_shiftx:= -1;
 finfopo^.gloss_shifty:= -1;

 finfopo^.xscale:= 1.0;
 updatehandlepo;
 dochanged([cs_fontcolor,cs_fontcolorbackground,cs_fonteffect],true);
end;

destructor tfont.destroy;
begin
 //handle:= 0;
 releasehandles(true);
 inherited;
end;

function tfont.getfont(var drawinfo: drawinfoty): boolean;
begin
 gdi_lock;
// gdi_getfont(drawinfo);
 drawinfo.gc.gdifuncs^[gdf_getfont](drawinfo);
 result:= drawinfo.getfont.ok;
 if result then begin
  with drawinfo.getfont.fontdata^ do begin
   linewidth:= height div (9 * (1 shl fontsizeshift));
  end;
 end;
 gdi_unlock;
end;

procedure tfont.createhandle(const canvas: tcanvas);
begin
 if (canvas <> nil) then begin
  releasefont(fhandlepo^);
  canvas.checkgcstate([cs_gc]); //windows needs gc
  finfopo^.gdifuncs:= gdifuncs[canvas.fgdinum];
  fhandlepo^:= getfontnum(finfopo^,canvas.fdrawinfo,
                                         {$ifdef FPC}@{$endif}getfont);
  if fhandlepo^ = 0 then begin
   canvas.error(gde_font,finfopo^.name);
  end;
 end
 else begin
  fhandlepo^:= 0;
 end;
end;

function tfont.gethandleforcanvas(const canvas: tcanvas): fontnumty;
begin
 if fhandlepo^ = 0 then begin
  createhandle(canvas);
 end;
 result:= fhandlepo^;
end;

function tfont.gethandle: fontnumty;
var
 canvas: tcanvas;
begin
 if fhandlepo^ = 0 then begin
  canvas:= tcanvas.create(self,icanvas(self));
  try
   createhandle(canvas);
  finally
   canvas.Free;
  end;
 end;
 result:= fhandlepo^;
end;

function tfont.getdatapo: pfontdataty;
begin
 result:= getfontdata(gethandle);
end;
{
procedure tfont.sethandle(const Value: fontty);
begin
 if fhandlepo^ <> value then begin
  releasefont(fhandlepo^);
  fhandlepo^ := Value;
  dochanged([cs_font]);
 end;
end;
}
procedure tfont.dochanged(const changed: canvasstatesty; const nochange: boolean);
begin
 if assigned(fonchange) and not nochange then begin
  fonchange(self);
 end;
end;

function tfont.getascent: integer;
begin
 result:= getdatapo^.ascent {+ finfopo^.extraspace};
end;

function tfont.getdescent: integer;
begin
 result:= getdatapo^.descent;
end;

function tfont.getglyphheight: integer;
begin
 with getdatapo^ do begin
  result:= ascent+descent;
 end;
end;

function tfont.getlineheight: integer;
begin
 with getdatapo^ do begin
  result:= ascent + descent;
  if linespacing > result then begin
   result:= linespacing;
  end;
 end;
 result:= result + finfopo^.extraspace;
end;

function tfont.getlinewidth: integer;
begin
 result:= getdatapo^.linewidth;
end;

function tfont.getcaretshift: integer;
begin
 result:= getdatapo^.caretshift;
end;

function tfont.getextraspace: integer;
begin
 result:= finfopo^.extraspace;
end;

procedure tfont.setextraspace(const avalue: integer);
begin
 if finfopo^.extraspace <> avalue then begin
  finfopo^.extraspace := avalue;
  dochanged([cs_font],false);
 end;
end;

procedure tfont.setcolorbackground(const Value: colorty);
begin
 if finfopo^.colorbackground <> value then begin
  finfopo^.colorbackground := Value;
  dochanged([cs_fontcolorbackground],false);
 end;
end;

function tfont.getcolorbackground: colorty;
begin
 result:= finfopo^.colorbackground;
end;

procedure tfont.setshadow_color(avalue: colorty);
begin
 if avalue = cl_invalid then begin
  avalue:= cl_none;
 end;
 if finfopo^.shadow_color <> avalue then begin
  finfopo^.shadow_color:= avalue;
  dochanged([cs_fonteffect],false);
 end;
end;

function tfont.getshadow_color: colorty;
begin
 result:= finfopo^.shadow_color;
end;

procedure tfont.setshadow_shiftx(const avalue: integer);
begin
 if finfopo^.shadow_shiftx <> avalue then begin
  finfopo^.shadow_shiftx:= avalue;
  dochanged([cs_fonteffect],false);
 end;
end;

function tfont.getshadow_shiftx: integer;
begin
 result:= finfopo^.shadow_shiftx;
end;

procedure tfont.setshadow_shifty(const avalue: integer);
begin
 if finfopo^.shadow_shifty <> avalue then begin
  finfopo^.shadow_shifty:= avalue;
  dochanged([cs_fonteffect],false);
 end;
end;

function tfont.getshadow_shifty: integer;
begin
 result:= finfopo^.shadow_shifty;
end;

procedure tfont.setgloss_color(avalue: colorty);
begin
 if avalue = cl_invalid then begin
  avalue:= cl_none;
 end;
 if finfopo^.gloss_color <> avalue then begin
  finfopo^.gloss_color:= avalue;
  dochanged([cs_fonteffect],false);
 end;
end;

function tfont.getgloss_color: colorty;
begin
 result:= finfopo^.gloss_color;
end;

procedure tfont.setgloss_shiftx(const avalue: integer);
begin
 if finfopo^.gloss_shiftx <> avalue then begin
  finfopo^.gloss_shiftx:= avalue;
  dochanged([cs_fonteffect],false);
 end;
end;

function tfont.getgloss_shiftx: integer;
begin
 result:= finfopo^.gloss_shiftx;
end;

procedure tfont.setgloss_shifty(const avalue: integer);
begin
 if finfopo^.gloss_shifty <> avalue then begin
  finfopo^.gloss_shifty:= avalue;
  dochanged([cs_fonteffect],false);
 end;
end;

function tfont.getgloss_shifty: integer;
begin
 result:= finfopo^.gloss_shifty;
end;

procedure tfont.setcolor(const Value: colorty);
begin
 if finfopo^.color <> value then begin
  finfopo^.color := Value;
  dochanged([cs_fontcolor],false);
 end;
end;

procedure tfont.assignproperties(const source: tfont; const handles: boolean);
var
 int1: integer;
 changed: canvasstatesty;
begin
 changed:= [];
 with tfont(source) do begin
  if finfopo^.colorbackground <> self.finfopo^.colorbackground then begin
   self.finfopo^.colorbackground:= finfopo^.colorbackground;
   include(changed,cs_fontcolorbackground);
  end;

  if finfopo^.shadow_color <> self.finfopo^.shadow_color then begin
   self.finfopo^.shadow_color:= finfopo^.shadow_color;
   include(changed,cs_fonteffect);
  end;
  if finfopo^.shadow_shiftx <> self.finfopo^.shadow_shiftx then begin
   self.finfopo^.shadow_shiftx:= finfopo^.shadow_shiftx;
   include(changed,cs_fonteffect);
  end;
  if finfopo^.shadow_shifty <> self.finfopo^.shadow_shifty then begin
   self.finfopo^.shadow_shifty:= finfopo^.shadow_shifty;
   include(changed,cs_fonteffect);
  end;
  
  if finfopo^.gloss_color <> self.finfopo^.gloss_color then begin
   self.finfopo^.gloss_color:= finfopo^.gloss_color;
   include(changed,cs_fonteffect);
  end;
  if finfopo^.gloss_shiftx <> self.finfopo^.gloss_shiftx then begin
   self.finfopo^.gloss_shiftx:= finfopo^.gloss_shiftx;
   include(changed,cs_fonteffect);
  end;
  if finfopo^.gloss_shifty <> self.finfopo^.gloss_shifty then begin
   self.finfopo^.gloss_shifty:= finfopo^.gloss_shifty;
   include(changed,cs_fonteffect);
  end;
  
  if finfopo^.color <> self.finfopo^.color then begin
   self.finfopo^.color:= finfopo^.color;
   include(changed,cs_fontcolor);
  end;
  if self.finfopo^.style <> finfopo^.style then begin
   self.finfopo^.style:= finfopo^.style;
   self.updatehandlepo;
   include(changed,cs_font);
  end;
  if self.finfopo^.extraspace <> finfopo^.extraspace then begin
   self.finfopo^.extraspace:= finfopo^.extraspace;
   include(changed,cs_font);
  end;
  self.finfopo^.height:= finfopo^.height;
  self.finfopo^.width:= finfopo^.width;
  self.finfopo^.name:= finfopo^.name;
  self.finfopo^.charset:= finfopo^.charset;
  self.finfopo^.options:= finfopo^.options;
  self.finfopo^.xscale:= finfopo^.xscale;
  if handles then begin
   for int1:= 0 to high(self.finfopo^.handles) do begin
    if self.finfopo^.handles[int1] <> finfopo^.handles[int1] then begin
     releasefont(self.finfopo^.handles[int1]);
     self.finfopo^.handles[int1]:= finfopo^.handles[int1];
     addreffont(self.finfopo^.handles[int1]);
     changed:= changed + [cs_font,cs_fonthandle];
    end;
   end;
  end
  else begin
   releasehandles;
  end;
 end;
 if changed <> [] then begin
  dochanged(changed,false);
 end;
end;

procedure tfont.readcolorshadow(reader: treader);
begin
 shadow_color:= reader.readinteger;
end;

procedure tfont.defineproperties(filer: tfiler);
begin
 inherited;
 filer.defineproperty('colorshadow',{$ifdef FPC}@{$endif}readcolorshadow,
                                                                  nil,false);
end;

procedure tfont.assign(source: tpersistent);
begin
 if source <> self then begin
  if source is tfont then begin
   assignproperties(tfont(source),true);
  end
  else begin
   inherited;
  end;
 end;
end;

procedure tfont.updatehandlepo;
begin
 fhandlepo:= @finfopo^.handles[
    {$ifdef FPC}longword{$else}byte{$endif}(finfopo^.style) and
                    fontstylehandlemask];
end;

procedure tfont.setstyle(const Value: fontstylesty);
begin
 if finfopo^.style <> value then begin
  finfopo^.style := Value;
  updatehandlepo;
  dochanged([cs_font],false);
 end;
end;

procedure tfont.releasehandles(const nochanged: boolean = false);
var
 int1: integer;
begin
 for int1:= 0 to high(finfopo^.handles) do begin
  releasefont(finfopo^.handles[int1]);
 end;
 fillchar(finfopo^.handles,sizeof(finfopo^.handles),0);
 dochanged([cs_font,cs_fonthandle],nochanged);
end;

function tfont.getcolor: colorty;
begin
 result:= finfopo^.color;
end;

function tfont.getheight: integer;
begin
 result:= (finfopo^.height + fontsizeroundvalue) shr fontsizeshift;
end;

procedure tfont.setheight(avalue: integer);
begin
 if avalue < 0 then begin
  avalue:= 0;
 end;
 if finfopo^.height <> avalue then begin
  finfopo^.height:= avalue shl fontsizeshift;
  releasehandles;
 end;
end;

function tfont.getwidth: integer;
begin
 result:= (finfopo^.width + fontsizeroundvalue) shr fontsizeshift;
end;

procedure tfont.setwidth(avalue: integer);
begin
 if avalue < 0 then begin
  avalue:= 0;
 end;
 if finfopo^.width <> avalue then begin
  finfopo^.width:= avalue shl fontsizeshift;
  releasehandles;
 end;
end;

function tfont.getstyle: fontstylesty;
begin
 result:= finfopo^.style;
end;

function tfont.getname: string;
begin
 result:= finfopo^.name;
end;

procedure tfont.setname(const Value: string);
begin
 if finfopo^.name <> value then begin
  finfopo^.name := trim(Value);
  releasehandles;
 end;
end;

function tfont.getoptions: fontoptionsty;
begin
 result:= finfopo^.options;
end;

procedure tfont.setoptions(const avalue: fontoptionsty);
begin
 if finfopo^.options <> avalue then begin
  finfopo^.options:= checkfontoptions(avalue,finfopo^.options);
  releasehandles;
 end;
end;

function tfont.getrotation: real;
begin
 result:= finfopo^.rotation;
end;

procedure tfont.setrotation(const avalue: real);
begin
 if finfopo^.rotation <> avalue then begin
  finfopo^.rotation:= avalue;
  releasehandles(true);
 end;
end;

function tfont.getxscale: real;
begin
 result:= finfopo^.xscale;
end;

procedure tfont.setxscale(const avalue: real);
begin
 if finfopo^.xscale <> avalue then begin
  finfopo^.xscale:= avalue;
  releasehandles;
 end;
end;

function tfont.getcharset: string;
begin
 result:= finfopo^.charset;
end;

procedure tfont.setcharset(const Value: string);
begin
 if finfopo^.charset <> value then begin
  finfopo^.charset := trim(Value);
  releasehandles;
 end;
end;

     //icanvas
procedure tfont.gcneeded(const sender: tcanvas);
var
 gc: gcty;
 err: guierrorty;
begin
 fillchar(gc,sizeof(gcty),0);
 gdi_lock;
 err:= gui_creategc(0,gck_screen,gc);
 gdi_unlock;
 guierror(err,self);
 sender.linktopaintdevice(0,gc,{nullsize,}nullpoint);
end;

function tfont.getmonochrome: boolean;
begin
 result:= false;
end;

function tfont.getsize: sizety;
begin
 result:= nullsize;
end;

function tfont.getbold: boolean;
begin
 result:= fs_bold in style;
end;

procedure tfont.setbold(const avalue: boolean);
begin
 if avalue then begin
  style:= style + [fs_bold];
 end
 else begin
  style:= style - [fs_bold];
 end;
end;

function tfont.getitalic: boolean;
begin
 result:= fs_italic in style;
end;

procedure tfont.setitalic(const avalue: boolean);
begin
 if avalue then begin
  style:= style + [fs_italic];
 end
 else begin
  style:= style - [fs_italic];
 end;
end;

function tfont.getunderline: boolean;
begin
 result:= fs_underline in style;
end;

procedure tfont.setunderline(const avalue: boolean);
begin
 if avalue then begin
  style:= style + [fs_underline];
 end
 else begin
  style:= style - [fs_underline];
 end;
end;

function tfont.getstrikeout: boolean;
begin
 result:= fs_strikeout in style;
end;

procedure tfont.setstrikeout(const avalue: boolean);
begin
 if avalue then begin
  style:= style + [fs_strikeout];
 end
 else begin
  style:= style - [fs_strikeout];
 end;
end;

procedure tfont.scale(const ascale: real);
begin
 height:= round(height * ascale);
 width:= round(width * ascale);
end;

{ tcanvasfont }

constructor tcanvasfont.create(const acanvas: tcanvas);
begin
 fcanvas:= acanvas;
 finfopo:= @fcanvas.fvaluepo^.font;
 inherited create;
end;

procedure tcanvasfont.dochanged(const changed: canvasstatesty;
                                               const nochange: boolean);
begin
// inherited;
 fcanvas.valueschanged(changed);
end;

function tcanvasfont.gethandle: fontnumty;
begin
 if fhandlepo^ = 0 then begin
  createhandle(fcanvas);
 end;
 result:= fhandlepo^;
// result:= gethandleforcanvas(fcanvas);
end;

{ tcanvas }

constructor tcanvas.create(const user: tobject; const intf: icanvas);
begin
 fdrawinfo.gc.gdifuncs:= getgdifuncs; //default
 fuser:= user;
 fintf:= pointer(intf);
 with fvaluestack do begin
  setlength(stack,1);
  count:= 1;
  fvaluepo:= @stack[0];
 end;
 ffont:= createfont;
 initflags(self);
 init;
end;

destructor tcanvas.destroy;
var
 int1: integer;
begin
 inherited;
 unlink; //deinit, unregister defaultfont
 ffont.free;
 freebuffer(fdrawinfo.buffer);
 for int1:= 0 to high(fgclinksto) do begin
  removeitem(pointerarty(tcanvas(fgclinksto[int1]).fgclinksfrom),self);
 end;
 for int1:= 0 to high(fgclinksfrom) do begin
  removeitem(pointerarty(tcanvas(fgclinksfrom[int1]).fgclinksto),self);
 end;
end;

procedure tcanvas.registergclink(const dest: tcanvas);
begin
 adduniqueitem(pointerarty(dest.fgclinksto),self);
 adduniqueitem(pointerarty(fgclinksfrom),dest);
end;

procedure tcanvas.unregistergclink(const dest: tcanvas);
begin
 removeitem(pointerarty(dest.fgclinksto),self);
 removeitem(pointerarty(fgclinksfrom),dest);
end;

procedure tcanvas.gcdestroyed(const sender: tcanvas);
begin
 //dummy
end;

function tcanvas.createfont: tcanvasfont;
begin
 result:= tcanvasfont.create(self);
end;

function tcanvas.getgdifuncs: pgdifunctionaty;
begin
 result:= gui_getgdifuncs;
end;

procedure tcanvas.error(nr: gdierrorty; const text: string);
begin
 gdierror(nr,fuser,text);
end;

function tcanvas.lock: boolean;
begin
 with application do begin
  result:= not locked;
  if result then begin
   lock;
  end;
 end;
end;

procedure tcanvas.unlock;
begin
 application.unlock;
end;

procedure tcanvas.gdi(const func: gdifuncty);
begin
 if lock then begin
  try
   fdrawinfo.gc.gdifuncs^[func](fdrawinfo);
   if flushgdi then begin
    gui_flushgdi;
   end;
  finally
   unlock;
  end;
 end
 else begin
  fdrawinfo.gc.gdifuncs^[func](fdrawinfo);
  if flushgdi then begin
   gui_flushgdi;
  end;
 end;
end;

procedure tcanvas.checkrect(const rect: rectty);
begin
 if (rect.cx < 0) or (rect.cy < 0) then begin
  error(gde_invalidrect,'');
 end;
end;


procedure tcanvas.intparametererror(value: integer; const text: string);
begin
 error(gde_parameter,text + ' ' + inttostr(value));
end;

procedure tcanvas.initgcvalues;
begin
 gccolorbackground:= cl_none;
 gccolorforeground:= cl_none;
 gcfonthandle1:= 0;
 fstate:= fstate - changedmask;
end;

procedure tcanvas.initgcstate;
begin
 initgcvalues;
end;

procedure tcanvas.finalizegcstate;
begin
 //dummy
end;

//var
// gcident: longword;
 
procedure tcanvas.linktopaintdevice(apaintdevice: paintdevicety;
               const gc: gcty; const cliporigin: pointty);
var
 rea1: real;
 int1: integer;
begin
 resetpaintedflag;
 if (fdrawinfo.gc.handle <> 0) then begin
  for int1:= 0 to high(fgclinksto) do begin
   fgclinksto[int1].gcdestroyed(self);
  end;
  gdi(gdf_destroygc);
 end;
 fdrawinfo.paintdevice:= apaintdevice;
 rea1:= fdrawinfo.gc.ppmm;
 fdrawinfo.gc:= gc;
 if fdrawinfo.gc.gdifuncs = nil then begin
  fdrawinfo.gc.gdifuncs:= getgdifuncs; //default
 end;
 fdrawinfo.gc.ppmm:= rea1;
 updatecliporigin(cliporigin);
 if gc.handle <> 0 then begin
  gdi(gdf_setcliporigin);
 end;
 if fdefaultfont <> 0 then begin
  releasefont(fdefaultfont);
  fdefaultfont:= 0;
 end;
 if gc.handle <> 0 then begin
  initgcstate;
 end
 else begin
  finalizegcstate;
 end;
end;

procedure tcanvas.unlink;
begin
 reset;
 gdi_lock;
 try
  linktopaintdevice(0,nullgc,{nullsize,}nullpoint);
 finally
  gdi_unlock;
 end;
end;

procedure tcanvas.initdrawinfo(var adrawinfo: drawinfoty);
begin
 with fdrawinfo do begin
  adrawinfo.paintdevice:= paintdevice;
  adrawinfo.gc:= gc;
 end;
end;

//
// save stack, properties
//

procedure tcanvas.init;

 procedure initvalues(var values: canvasvaluesty);
 begin
  with values do begin
   if icanvas(fintf).getmonochrome then begin
    color:= cl_1;
    colorbackground:= cl_0;
    font.color:= cl_1;
    font.colorbackground:= cl_transparent;
   end
   else begin
    color:= cl_black;
    colorbackground:= cl_transparent;
    font.color:= cl_black;
    font.colorbackground:= cl_transparent;
   end;
   rasterop:= rop_copy;
  end;
 end;

begin
 fdrawinfo.gc.ppmm:= defaultppmm;
 restore(0); 
// reset;
 initvalues(fvaluestack.stack[0]);
 initvalues(fvaluestack.stack[1]);
end;

procedure tcanvas.reset;
begin
 restore(0);
// clipregion:= 0;
// origin:= nullpoint;
end;

function tcanvas.save: integer;
var
 int1,int2: integer;

begin
// if fdrawinfo.gc.handle <> 0 then begin
//  checkgcstate([]); //update pending changes
// end;
 with fvaluestack do begin
  result:= count-1;
  if count >= length(stack) then begin
   setlength(stack,count+1);
  end;
  if count > 0 then begin
   system.move(stack[count-1],stack[count],sizeof(canvasvaluesty));
  end
  else begin
   error(gde_invalidsaveindex,'save 0');
  end;
  fvaluepo:= @stack[count];
  for int1:= 0 to high(fvaluepo^.font.handles) do begin
   int2:= fvaluepo^.font.handles[int1];
   if int2 <> 0 then begin
    addreffont(int2);
   end;
  end;
  stringaddref(fvaluepo^.font.name);
  stringaddref(fvaluepo^.font.charset);
  updatefontinfo;
  fvaluepo^.changed:= []; //reset changes
  inc(count);
 end;
end;

procedure tcanvas.freevalues(var values: canvasvaluesty);
var
 int1,int2: integer;
begin
 with values do begin
  if cs_regioncopy in changed then begin
   destroyregion(clipregion);
  end;
  for int1:= 0 to high(values.font.handles) do begin
   int2:= values.font.handles[int1];
   if int2 <> 0 then begin
    releasefont(int2);
    values.font.handles[int1]:= 0;
   end;
  end;
//  stringrelease({fvaluepo^.}font.name);
//  stringrelease({fvaluepo^.}font.charset);
 end;
 finalize(values);
end;

function tcanvas.restore(index: integer = -1): integer;
var
 int1: integer;
 achanged: canvasstatesty;
begin
 with fvaluestack do begin
  if index >= count then begin
   error(gde_invalidsaveindex,inttostr(index));
//index:= count-1;
  end;
  if index < 0 then begin
   if count < 2 then begin
    error(gde_invalidsaveindex,inttostr(index));
   end;
   index:= count - 2;
  end;
  achanged:= [];
  for int1:= count-1 downto index + 1 do begin
   achanged:= achanged + stack[int1].changed;
   freevalues(stack[int1]);
  end;
  fstate:= fstate - achanged * changedmask;
  fvaluepo:= @stack[index];
  updatefontinfo;
  count:= index + 1;
  if index = 0 then begin
   result:= save;
  end
  else begin
   result:= index;
  end;
 end;
end;

procedure tcanvas.valuechanged(value: canvasstatety);
begin
 include(fvaluepo^.changed,value);
 exclude(fstate,value);
end;

procedure tcanvas.valueschanged(values: canvasstatesty);
begin
 fvaluepo^.changed:= fvaluepo^.changed + values;
 fstate:= fstate - values;
end;

procedure tcanvas.setfont(const Value: tfont);
begin
 if ffont <> nil then begin
  if value.fhandlepo^ = 0 then begin
   value.createhandle(self);
  end;
  ffont.assign(Value);
 end;
end;

procedure tcanvas.updatefontinfo;
begin
 ffont.finfopo:= @fvaluepo^.font;
 ffont.updatehandlepo;
end;

//
// painting
//

procedure tcanvas.checkgcstate(state: canvasstatesty);
var
 values: gcvaluesty;
 bo1,bo2: boolean;
 po1: pfontdataty;
begin
 if fdrawinfo.gc.handle = 0 then begin
  gdi_lock;
  try
   icanvas(fintf).gcneeded(self);
  finally
   gdi_unlock;
  end;
  if fdrawinfo.gc.handle = 0 then begin
   gdierror(gde_invalidgc,fuser);
  end;
 end;
 if state = [cs_gc] then begin
  exit;
 end;
 include(fstate,cs_painted);
 inc(fdrawinfo.statestamp);
 values.mask:= [];

 if not (cs_clipregion in fstate) then begin
  values.clipregion:= fvaluepo^.clipregion;
  include(values.mask,gvm_clipregion);
  include(fstate,cs_clipregion);
 end;
 if not (cs_origin in fstate) then begin
  fdrawinfo.origin:= fvaluepo^.origin;
  include(fstate,cs_origin);
  exclude(fstate,cs_brushorigin);
 end;
 if not (cs_rasterop in fstate) then begin
  values.rasterop:= fvaluepo^.rasterop;
  include(values.mask,gvm_rasterop);
  include(fstate,cs_rasterop);
 end;
 with fdrawinfo,gc do begin
  bo2:= df_brush in drawingflags;
  drawingflags:= drawingflags - fillmodeinfoflags;

  if (cs_acolorforeground in state) then begin
   bo1:= (acolorforeground = cl_brushcanvas);
   if ((acolorforeground = cl_brush) or bo1) and (fvaluepo^.brush <> nil) then begin
    include(drawingflags,df_brush);
   end;
   if (df_brush in drawingflags) xor bo2 then begin
    include(values.mask,gvm_brushflag);
   end;
   if (df_brush in drawingflags) and not (cs_brushorigin in fstate) then begin
    include(fstate,cs_brushorigin);
    include(values.mask,gvm_brushorigin);
//    values.brushorigin:= addpoint(fvaluepo^.brushorigin,fvaluepo^.origin);
    values.brushorigin:= fvaluepo^.brushorigin;
   end;
   if acolorforeground <> gccolorforeground then begin
    if df_brush in drawingflags then begin
     with fvaluepo^.brush do begin
      if not (cs_brush in self.fstate) then begin
       include(values.mask,gvm_brush);
       values.brush:= fvaluepo^.brush;
      end;
      if getmonochrome then begin
       include(drawingflags,df_monochrome);
       include(state,cs_acolorbackground);
       if bo1 then begin //use canvas colors
        acolorforeground:= fvaluepo^.color;
        acolorbackground:= fvaluepo^.colorbackground;
       end
       else begin       //use brush colors
        acolorforeground:= fcolorforeground;
        acolorbackground:= fcolorbackground;
       end;
      end
      else begin
       exclude(drawingflags,df_monochrome);
      end;
     end;
     include(fstate,cs_brush);
    end;
   end;
   if acolorforeground <> gccolorforeground then begin
    if drawingflags * [df_brush,df_monochrome] <> [df_brush] then begin
     include(values.mask,gvm_colorforeground);
     values.colorforeground:= colortopixel(acolorforeground);
    end;
    gccolorforeground:= acolorforeground;
    include(fstate,cs_acolorforeground);
   end;
  end;
  if (cs_acolorbackground in state) and (acolorbackground <> gccolorbackground) then begin
   include(values.mask,gvm_colorbackground);
   values.colorbackground:= colortopixel(acolorbackground);
   gccolorbackground:= acolorbackground;
  end;
  if gccolorbackground = cl_transparent then begin
   exclude(drawingflags,df_opaque);
  end
  else begin
   include(drawingflags,df_opaque);
  end;
  if cs_font in state then begin
   if (afonthandle1 <> gcfonthandle1) then begin
    include(values.mask,gvm_font);
    values.fontnum:= afonthandle1;
    po1:= getfontdata(afonthandle1); 
    values.fontdata:= po1;
    with po1^ do begin
     values.font:= font;
     if (df_highresfont in fdrawinfo.gc.drawingflags) then begin
      checkhighresfont(po1,fdrawinfo);
     end;
    end;
    gcfonthandle1:= afonthandle1;
   end;
   include(drawingflags,df_monochrome);
  end;

  state:= (state - fstate) * linecanvasstates; //update lineinfos
  if state <> [] then begin
   values.lineinfo:= fvaluepo^.lineinfo;
   fstate:= fstate + state;
   if cs_linewidth in state then include(values.mask,gvm_linewidth);
   if cs_dashes in state then include(values.mask,gvm_dashes);
   if cs_capstyle in state then include(values.mask,gvm_capstyle);
   if cs_joinstyle in state then include(values.mask,gvm_joinstyle);
   if cs_lineoptions in state then include(values.mask,gvm_lineoptions);
   fstate:= fstate + state;
  end;
  if values.mask <> [] then begin
   fdrawinfo.gcvalues:= @values;
   gdi(gdf_changegc);
  end;
 end;
end;

function tcanvas.getgchandle: ptruint;
begin
 checkgcstate([cs_gc]);
 result:= fdrawinfo.gc.handle;
end;

function tcanvas.getimage(const bgr: boolean): imagety;
begin
 fillchar(result,sizeof(result),0);
end;

function tcanvas.checkforeground(acolor: colorty; lineinfo: boolean): boolean;
begin
 with fdrawinfo do begin
  if (acolor = cl_default) or (acolor = cl_parent) then begin
   acolorforeground:= fvaluepo^.color;
  end
  else begin
   acolorforeground:= acolor;
  end;
  if acolorforeground <> cl_transparent then begin
   if lineinfo then begin
    if length(dashes) > 0 then begin
     acolorbackground:= fvaluepo^.colorbackground;
     checkgcstate([cs_acolorforeground,cs_acolorbackground]+linecanvasstates);
    end
    else begin
     checkgcstate([cs_acolorforeground]+linecanvasstates);
    end;
   end
   else begin
    checkgcstate([cs_acolorforeground]);
   end;
   result:= true;
  end
  else begin
   result:= false;
  end;
 end;
end;

procedure tcanvas.checkcolors;
begin
 with fdrawinfo do begin
  acolorforeground:= fvaluepo^.color;
  acolorbackground:= fvaluepo^.colorbackground;
  checkgcstate([cs_acolorforeground,cs_acolorbackground]);
 end;
end;

procedure tcanvas.internalcopyarea(asource: tcanvas; const asourcerect: rectty;
                           const adestrect: rectty; acopymode: rasteropty;
                           atransparentcolor: colorty;
                           amask: tsimplebitmap{pixmapty;  amaskgchandle: ptruint};
                           const aalignment: alignmentsty;
                           const atileorigin: pointty;
                           const atransparency: colorty); //cl_none -> opaque

                           //todo: use serverside tiling
                           //      limit stretched rendering to cliprects
var
 srect,drect,rect1: rectty;
 spoint,dpoint,tileorig: pointty;
 startx: integer;
 endx,endy: integer;
// endcx,endcy: integer;
 stepx,stepy: integer;
 sourcex,sourcey: integer;
 int1,int2: integer;
// bo1,bo2: boolean;

begin
 checkgcstate([]);  //gc must be valid
 if asource <> self then begin
  asource.checkgcstate([cs_gc]); //gc must be valid
 end;
 dpoint.x:= adestrect.x + fdrawinfo.origin.x;
 dpoint.y:= adestrect.y + fdrawinfo.origin.y;
 tileorig.x:= atileorigin.x + fdrawinfo.origin.x;
 tileorig.y:= atileorigin.y + fdrawinfo.origin.y;
 with asourcerect,asource.fvaluepo^ do begin
  spoint.x:= x + origin.x;
  spoint.y:= y + origin.y;
 end;
 rect1:= moverect(clipbox,fvaluepo^.origin);
 drect.size:= adestrect.size;
 if aalignment * [al_stretchx,al_stretchy,al_fit,al_tiled] = [] then begin
  if not msegraphutils.intersectrect(makerect(spoint,asourcerect.size),
       makerect(makepoint(0,0),icanvas(asource.fintf).getsize),srect) then begin
   exit;
  end;
  dpoint.x:= dpoint.x + srect.x - spoint.x;
  dpoint.y:= dpoint.y + srect.y - spoint.y;
  if not msegraphutils.intersectrect(makerect(dpoint,srect.size),
               rect1,drect) then begin
   exit;
  end;
  srect.x:= srect.x + drect.x - dpoint.x;
  srect.cx:= drect.cx;
  srect.y:= srect.y + drect.y - dpoint.y;
  srect.cy:= drect.cy;
 end
 else begin
  srect.pos:= spoint;
  srect.size:= asourcerect.size;
  drect.pos:= dpoint;
 end;
 with fdrawinfo,copyarea do begin
  source:= asource;
  sourcerect:= @srect;
  destrect:= @drect;
  alignment:= aalignment;
  copymode:= acopymode;
  mask:= amask;
  if al_fit in aalignment then begin
   alignment:= alignment + [al_stretchx,al_stretchy];
   if (srect.cx = 0) or (srect.cy = 0) then begin
    exit;
   end;
   if srect.cy * drect.cx > srect.cx * drect.cy then begin //fit vert
    drect.cx:= (srect.cx * drect.cy) div srect.cy;
    int1:= adestrect.cx - drect.cx;
    if al_right in aalignment then begin
     drect.x:= drect.x + int1;
    end
    else begin
     if al_xcentered in aalignment then begin
      drect.x:= drect.x + int1 div 2;
     end;
    end;
   end
   else begin
    drect.cy:= (srect.cy * drect.cx) div srect.cx;
    int1:= adestrect.cy - drect.cy;
    if al_bottom in aalignment then begin
     drect.y:= drect.y + int1;
    end
    else begin
     if al_ycentered in aalignment then begin
      drect.y:= drect.y + int1 div 2;
     end;
    end;
   end;
  end;
  if atransparency = cl_none then begin
   longword(transparency):= 0;
  end
  else begin
   transparency:= colortorgb(atransparency);
  end;

  if drawingflagsty((longword(gc.drawingflags) xor 
                   longword(source.fdrawinfo.gc.drawingflags))) *
          [df_canvasismonochrome] <> [] then begin //different colorformat
   include(gc.drawingflags,df_colorconvert);
   with fdrawinfo,gc do begin
    acolorforeground:= fvaluepo^.color;
    if not (df_canvasismonochrome in gc.drawingflags) then begin //monochrome to color
     acolorbackground:= fvaluepo^.colorbackground;
     checkgcstate([cs_acolorforeground,cs_acolorbackground]);
    end
    else begin
     if atransparentcolor = cl_default then begin                //color to monochrome
      transparentcolor:= colortopixel(fvaluepo^.colorbackground);
     end
     else begin
      transparentcolor:= colortopixel(atransparentcolor);
     end;
    end;
   end;
  end
  else begin
   exclude(gc.drawingflags,df_colorconvert);
  end;
 end;
 if al_tiled in aalignment then begin
  if msegraphutils.intersectrect(drect,rect1,rect1) then begin
   if not (al_stretchy in aalignment) then begin
    drect.cy:= srect.cy;
    if drect.y >= tileorig.y then begin
     drect.y:= tileorig.y + ((rect1.y - tileorig.y) div srect.cy) * srect.cy;
    end
    else begin
     drect.y:= tileorig.y - ((tileorig.y - rect1.y + srect.cy) div srect.cy) * srect.cy;
    end;
   end;
   if not (al_stretchx in aalignment) then begin
    drect.cx:= srect.cx;
    if drect.x >= tileorig.x then begin
     startx:= tileorig.x + ((rect1.x - tileorig.x) div srect.cx) * srect.cx;
    end
    else begin
     startx:= tileorig.x - ((tileorig.x - rect1.x + srect.cx) div srect.cx) * srect.cx;
    end;
   end
   else begin
    startx:= drect.x;
   end;
   stepx:= srect.cx;
   stepy:= srect.cy;
   endx:= rect1.x + rect1.cx;
//   endcx:= endx - stepx;
   endy:= rect1.y + rect1.cy;
//   endcy:= endy - stepy;
   sourcex:= srect.x;
   sourcey:= srect.y;
   if not (al_stretchy in aalignment) then begin
    int1:= drect.y - rect1.y;
    if int1 < 0 then begin
     dec(srect.y,int1);
     dec(drect.y,int1);
     inc(srect.cy,int1);
     drect.cy:= srect.cy;
    end;
   end;
   if al_stretchx in aalignment then begin
    int1:= 0;
   end
   else begin
    int1:= startx - rect1.x;
    if int1 > 0 then begin
     int1:= 0;
    end;
   end;
//   bo2:= true;
   repeat
    if not (al_stretchy in aalignment) then begin
     if drect.y + srect.cy > endy then begin
      srect.cy:= endy - drect.y;
     end;
//     if (drect.y > endcy) and not bo2 then begin
//      srect.cy:= endy - drect.y;
//      bo2:= false;
//     end;
     drect.cy:= srect.cy;
    end;
    drect.x:= startx;
    dec(srect.x,int1);
    dec(drect.x,int1);
    inc(srect.cx,int1);
 //   bo1:= true;
    repeat
     if not (al_stretchx in aalignment) then begin
      if drect.x + srect.cx > endx then begin
       srect.cx:= endx - drect.x;
      end;
//      if (drect.x > endcx) {and not bo1} then begin
//       srect.cx:= endx - drect.x;
//      end;
 //     bo1:= false;
      drect.cx:= srect.cx;
     end;
     gdi(gdf_copyarea);
     inc(drect.x,srect.cx);
     srect.cx:= stepx;
     srect.x:= sourcex;
    until (al_stretchx in aalignment) or (drect.x >= endx);
    inc(drect.y,srect.cy);
    srect.y:= sourcey;
    srect.cy:= stepy;
    drect.cy:= stepy;
   until (al_stretchy in aalignment) or (drect.y >= endy);
  end;
 end
 else begin
  gdi(gdf_copyarea);
 end;
 if amask <> nil then begin
  exclude(fstate,cs_clipregion);
 end;
end;

procedure tcanvas.copyarea(const asource: tcanvas; const asourcerect: rectty;
                           const adestpoint: pointty; 
                           const acopymode: rasteropty = rop_copy;
                           const atransparentcolor: colorty = cl_default;
                           const atransparency: colorty = cl_none);
begin
 if cs_inactive in fstate then exit;
 internalcopyarea(asource,asourcerect,makerect(adestpoint,asourcerect.size),
              acopymode,atransparentcolor,nil,[],nullpoint,atransparency);
end;

procedure tcanvas.copyarea(const asource: tcanvas; const asourcerect: rectty;
              const adestrect: rectty; const alignment: alignmentsty = [];
              const acopymode: rasteropty = rop_copy;
              const atransparentcolor: colorty = cl_default;
              //atransparentcolor used for convert color to monochrome
              //cl_default -> colorbackground
              const atransparency: colorty = cl_none);
begin
 if cs_inactive in fstate then exit;
 internalcopyarea(asource,asourcerect,adestrect,
              acopymode,atransparentcolor,nil,alignment,nullpoint,atransparency);
end;

procedure tcanvas.drawpoints(const apoints: array of pointty; const acolor: colorty;
                   first, acount: integer);
var
 int1,int2: integer;
 pointar: pointarty;
begin
 if cs_inactive in fstate then exit;
 if length(apoints) > 0 then begin
  if checkforeground(acolor,true) then begin
   with fdrawinfo.points do begin
    int1:= length(apoints) - first;
    if int1 < 0 then begin
     intparametererror(first,'drawpoints first');
    end;
    if acount < 0 then begin
     acount:= int1;
    end
    else begin
     if acount > int1 then begin
      intparametererror(acount,'drawponts acount');
     end;
    end;
    count:= 2*acount;
    setlength(pointar,count);
    int2:= 0;
    for int1:= first to first + acount - 1 do begin
     pointar[int2]:= apoints[int1];
     pointar[int2+1]:= apoints[int1];
     inc(int2,2);
    end;
    points:= @pointar[0];
   end;
   gdi(gdf_drawlinesegments);
  end;
 end;
end;

procedure tcanvas.drawpoint(const point: pointty; const acolor: colorty = cl_default);
begin
 if cs_inactive in fstate then exit;
 drawpoints(point,acolor,0,1);
end;

procedure tcanvas.drawlines(const apoints: array of pointty;
                       const aclosed: boolean = false;
                       const acolor: colorty = cl_default;
                       const first: integer = 0; const acount: integer = -1);
                                                          //-1 -> all
var
 int1: integer;
begin
 if cs_inactive in fstate then exit;
 if length(apoints) > 0 then begin
  if checkforeground(acolor,true) then begin
   with fdrawinfo.points do begin
    closed:= aclosed;
    points:= @apoints[first];
    int1:= length(apoints) - first;
    if int1 < 0 then begin
     intparametererror(first,'drawlines first');
    end;
    if acount < 0 then begin
     count:= int1;
    end
    else begin
     if acount > int1 then begin
      intparametererror(acount,'drawlines acount');
     end;
     count:= acount;
    end;
   end;
   gdi(gdf_drawlines);
  end;
 end;
end;

procedure tcanvas.drawrect(const arect: rectty; const acolor: colorty = cl_default);
begin
 if cs_inactive in fstate then exit;
 with arect do begin
  drawlines([pos,makepoint(x+cx,y),makepoint(x+cx,y+cy),makepoint(x,y+cy)],
                          true,acolor);
 end;
end;

procedure tcanvas.drawcross(const arect: rectty; const acolor: colorty = cl_default;
                const alignment: alignmentsty = [al_xcentered,al_ycentered]);
var
 ar1: segmentarty;
begin
 if cs_inactive in fstate then exit;
 if (arect.cx > 0) and (arect.cy > 0) then begin
  setlength(ar1,2);
  with arect do begin
   with ar1[0] do begin
    a:= pos;
    b.x:= x + cx - 1;
    b.y:= y + cy - 1;
   end;
   with ar1[1] do begin
    a.x:= x;
    a.y:= ar1[0].b.y;
    b.x:= ar1[0].b.x;
    b.y:= y;
   end;
   drawlinesegments(ar1,acolor);
  end;
 end;
end;

procedure tcanvas.drawlinesegments(const apoints: array of segmentty;
               const acolor: colorty = cl_default);
begin
 if cs_inactive in fstate then exit;
 if length(apoints) > 0 then begin
  if (high(apoints) >= 0) and checkforeground(acolor,true) then begin
   with fdrawinfo.points do begin
    points:= @apoints[0];
    count:= length(apoints) * 2;
   end;
   gdi(gdf_drawlinesegments);
  end;
 end;
end;

procedure tcanvas.drawline(const startpoint,endpoint: pointty;
          const acolor: colorty = cl_default);
begin
 if cs_inactive in fstate then exit;
 drawlinesegments([segment(startpoint,endpoint)],acolor);
end;

procedure tcanvas.drawvect(const startpoint: pointty; const direction: graphicdirectionty;
                      const length: integer; out endpoint: pointty;
                      const acolor: colorty = cl_default);
var
 endpoint1: pointty;
begin
 if cs_inactive in fstate then exit;
 endpoint1:= startpoint;
 case direction of
  gd_right: inc(endpoint1.x,length);
  gd_up: dec(endpoint1.y,length);
  gd_left: dec(endpoint1.x,length);
  gd_down: inc(endpoint1.y,length);
  else begin
   endpoint:= endpoint1;
   exit;
  end;
 end;
 drawlinesegments([segment(startpoint,endpoint1)],acolor);
 endpoint:= endpoint1;
end;

procedure tcanvas.drawvect(const startpoint: pointty; const direction: graphicdirectionty;
                      const length: integer; const acolor: colorty = cl_default);
var
 po1: pointty;
begin
 if cs_inactive in fstate then exit;
 drawvect(startpoint,direction,length,po1,acolor);
end;

procedure tcanvas.drawellipse(const def: rectty; const acolor: colorty = cl_default);
                             //def.pos = center, def.cx = width, def.cy = height
begin
 if cs_inactive in fstate then exit;
 if checkforeground(acolor,true) then begin
  fdrawinfo.rect.rect:= @def;
  gdi(gdf_drawellipse);
 end;
end;

procedure tcanvas.drawcircle(const center: pointty; const radius: integer;
                                               const acolor: colorty = cl_default);
var
 rect1: rectty;
begin
 rect1.pos:= center;
 rect1.cx:= 2*radius;
 rect1.cy:= rect1.cx;
 drawellipse(rect1,acolor);
end;

procedure tcanvas.drawellipse1(const def: rectty; const acolor: colorty = cl_default);
                             //def.pos = topleft, def.cx = width, def.cy = height
begin
 drawellipse(recenterrect(def),acolor);
end;

procedure tcanvas.drawarc(const def: rectty; const startang,extentang: real; 
                              const acolor: colorty = cl_default);
begin
 if cs_inactive in fstate then exit;
 if checkforeground(acolor,true) then begin
  fdrawinfo.arc.rect:= @def;
  fdrawinfo.arc.startang:= startang;
  fdrawinfo.arc.extentang:= extentang;
  gdi(gdf_drawarc);
 end;
end;

procedure tcanvas.drawarc(const center: pointty; const radius: integer;
                              const startang,extentang: real; 
                              const acolor: colorty = cl_default);
var
 rect1: rectty;
begin
 rect1.pos:= center;
 rect1.cx:= 2*radius;
 rect1.cy:= rect1.cx;
 drawarc(rect1,startang,extentang,acolor);
end;

procedure tcanvas.drawarc1(const def: rectty; const startang,extentang: real; 
                              const acolor: colorty = cl_default);
begin
 drawarc(recenterrect(def),startang,extentang,acolor);
end;

procedure tcanvas.fillrect(const arect: rectty; const acolor: colorty = cl_default;
                           const linecolor: colorty = cl_none);
var
 rect1: rectty;
begin
 if cs_inactive in fstate then exit;
 if checkforeground(acolor,false) then begin
  with fdrawinfo.rect do begin
   rect:= @arect;
   if (arect.cx < 0) then begin
    rect:= @rect1;
    rect1.x:= arect.x + arect.cx + 1;
    rect1.cx:= -arect.cx;
    if arect.cy < 0 then begin
     rect1.y:= arect.y + arect.cy + 1;
     rect1.cy:= -arect.cy;
    end
    else begin
     rect1.y:= arect.y;
     rect1.cy:= arect.cy;
    end;
   end
   else begin
    if arect.cy < 0 then begin
     rect:= @rect1;
     rect1.y:= arect.y + arect.cy + 1;
     rect1.cy:= -arect.cy;
     rect1.x:= arect.x;
     rect1.cx:= arect.cx;
    end;
   end;
  end;
  gdi(gdf_fillrect);
 end;
 if (linecolor <> cl_none) then begin
  drawrect(arect,linecolor);
 end;
end;

procedure tcanvas.fillellipse(const def: rectty; const acolor: colorty = cl_default;
                              const linecolor: colorty = cl_none);
begin
 if cs_inactive in fstate then exit;
 if checkforeground(acolor,false) then begin
  with fdrawinfo.rect do begin
   rect:= @def;
  end;
  gdi(gdf_fillelipse);
 end;
 if (linecolor <> cl_none) then begin
  drawellipse(def,linecolor);
 end;
end;

procedure tcanvas.fillcircle(const center: pointty; const radius: integer;
                        const acolor: colorty = cl_default;
                        const linecolor: colorty = cl_none);
var
 rect1: rectty;
begin
 rect1.pos:= center;
 rect1.cx:= 2*radius;
 rect1.cy:= rect1.cx;
 fillellipse(rect1,acolor,linecolor);
end;

procedure tcanvas.fillellipse1(const def: rectty; const acolor: colorty = cl_default;
                              const linecolor: colorty = cl_none);
begin
 fillellipse(recenterrect(def),acolor,linecolor);
end;

procedure tcanvas.fillarc(const def: rectty; const startang: real;
                          const extentang: real; const acolor: colorty;
                          const pieslice: boolean);
begin
 if cs_inactive in fstate then exit;
 if checkforeground(acolor,false) then begin
  fdrawinfo.arc.rect:= @def;
  fdrawinfo.arc.startang:= startang;
  fdrawinfo.arc.extentang:= extentang;
  fdrawinfo.arc.pieslice:= pieslice;
  gdi(gdf_fillarc);
 end;
end;

procedure tcanvas.getarcinfo(out startpo,endpo: pointty);
var
 stopang: real;
begin
 with fdrawinfo,arc,rect^ do begin
  stopang:= (startang+extentang);
  startpo.x:= (round(cos(startang)*cx) div 2) + x;
  startpo.y:= (round(-sin(startang)*cy) div 2) + y;
  endpo.x:= (round(cos(stopang)*cx) div 2) + x;
  endpo.y:= (round(-sin(stopang)*cy) div 2) + y;
 end;
end;

procedure tcanvas.fillarcchord(const def: rectty; const startang: real;
               const extentang: real; const acolor: colorty = cl_default;
               const linecolor: colorty = cl_none);
var
 startpo,endpo: pointty;
begin
 if cs_inactive in fstate then exit;
 fillarc(def,startang,extentang,acolor,false);
 if (linecolor <> cl_none) then begin
  getarcinfo(startpo,endpo);
  drawline(startpo,endpo,linecolor);
  drawarc(def,startang,extentang,linecolor);
 end;
end;

procedure tcanvas.fillarcchord(const center: pointty; const radius: integer;
                              const startang,extentang: real; 
                              const acolor: colorty = cl_default;
                              const linecolor: colorty = cl_none);
var
 rect1: rectty;
begin
 rect1.pos:= center;
 rect1.cx:= 2*radius;
 rect1.cy:= rect1.cx;
 fillarcchord(rect1,startang,extentang,acolor,linecolor);
end;

procedure tcanvas.fillarcchord1(const def: rectty; const startang: real;
               const extentang: real; const acolor: colorty = cl_default;
               const linecolor: colorty = cl_none);
begin
 fillarcchord(recenterrect(def),startang,extentang,acolor,linecolor);
end;

procedure tcanvas.fillarcpieslice(const def: rectty; const startang: real;
               const extentang: real; const acolor: colorty = cl_default;
                const linecolor: colorty = cl_none);
var
 startpo,endpo: pointty;
begin
 if cs_inactive in fstate then exit;
 fillarc(def,startang,extentang,acolor,true);
 if (linecolor <> cl_none) then begin
  getarcinfo(startpo,endpo);
  drawlines([startpo,def.pos,endpo],false,linecolor);
  drawarc(def,startang,extentang,linecolor);
 end;
end;

procedure tcanvas.fillarcpieslice(const center: pointty; const radius: integer;
                            const startang,extentang: real; 
                            const acolor: colorty = cl_default;
                            const linecolor: colorty = cl_none);
var
 rect1: rectty;
begin
 rect1.pos:= center;
 rect1.cx:= 2*radius;
 rect1.cy:= rect1.cx;
 fillarcpieslice(rect1,startang,extentang,acolor,linecolor);
end;

procedure tcanvas.fillarcpieslice1(const def: rectty; const startang: real;
               const extentang: real; const acolor: colorty = cl_default;
               const linecolor: colorty = cl_none);
begin
 fillarcpieslice(recenterrect(def),startang,extentang,acolor,linecolor);
end;

procedure tcanvas.fillpolygon(const apoints: array of pointty;
                              const acolor: colorty = cl_default; 
                              const linecolor: colorty = cl_none);
begin
 if cs_inactive in fstate then exit;
 if checkforeground(acolor,false) then begin
  with fdrawinfo.points do begin
   points:= @apoints;
   count:= length(apoints);
  end;
  gdi(gdf_fillpolygon);
 end;
 if (linecolor <> cl_none) then begin
  drawlines(apoints,true,linecolor);
 end;
end;

procedure tcanvas.drawstring(const atext: pmsechar; const acount: integer;
                        const apos: pointty;
                        const afont: tfont = nil; const grayed: boolean = false;
                        const arotation: real = 0);
var
 afontnum: integer;
 po1: pfontinfoty;
 font1: tfont;
 int1: integer;
begin
 if cs_inactive in fstate then exit;
 with fdrawinfo do begin
  if afont <> nil then begin //foreign font
   font1:= afont;
   with afont do begin
    po1:= finfopo;
    rotation:= arotation;
    afontnum:= gethandleforcanvas(self);
    afonthandle1:= afontnum;
    acolorbackground:= colorbackground;
   end;
  end
  else begin
   font1:= ffont;
   ffont.rotation:= arotation;
   afonthandle1:= ffont.gethandle;
   po1:= @fvaluepo^.font;
   with fvaluepo^.font do begin
    acolorbackground:= colorbackground;
   end;
  end;
  with fdrawinfo.text16pos do begin
   pos:= @apos;
   text:= pointer(atext);
   count:= acount;
   if grayed or (po1^.shadow_color <> cl_none) or
                                 (po1^.gloss_color <> cl_none) then begin
    if grayed then begin
     acolorforeground:= cl_white;
     inc(pos^.x,po1^.shadow_shiftx);
     inc(pos^.y,po1^.shadow_shifty);
    end
    else begin
     if po1^.shadow_color <> cl_none then begin
      acolorforeground:= po1^.shadow_color;
      inc(pos^.x,po1^.shadow_shiftx);
      inc(pos^.y,po1^.shadow_shifty);
     end
     else begin
      acolorforeground:= po1^.gloss_color;
      inc(pos^.x,po1^.gloss_shiftx);
      inc(pos^.y,po1^.gloss_shifty);
     end;
    end;
    acolorbackground:= cl_transparent;
    checkgcstate([cs_font,cs_acolorforeground,cs_acolorbackground]);
    gdi(gdf_drawstring16);
    if grayed then begin
     dec(pos^.x);
     dec(pos^.y);
     acolorforeground:= cl_dkgray;
    end
    else begin
     if po1^.shadow_color <> cl_none then begin
      dec(pos^.x,po1^.shadow_shiftx);
      dec(pos^.y,po1^.shadow_shifty);
      if po1^.gloss_color <> cl_none then begin
       acolorforeground:= po1^.gloss_color;
       inc(pos^.x,po1^.gloss_shiftx);
       inc(pos^.y,po1^.gloss_shifty);
       checkgcstate([cs_font,cs_acolorforeground,cs_acolorbackground]);
       gdi(gdf_drawstring16);
       dec(pos^.x,po1^.gloss_shiftx);
       dec(pos^.y,po1^.gloss_shifty);
      end;
     end
     else begin
      dec(pos^.x,po1^.gloss_shiftx);
      dec(pos^.y,po1^.gloss_shifty);
     end;
     acolorforeground:= po1^.color;
    end;
    checkgcstate([cs_acolorforeground]);
    gdi(gdf_drawstring16);
   end
   else begin
    acolorforeground:= po1^.color;
    checkgcstate([cs_font,cs_acolorforeground,cs_acolorbackground]);
    gdi(gdf_drawstring16);
   end;
  end;
  font1.rotation:= 0;
 end;
end;

procedure tcanvas.drawfontline(const startpoint,endpoint: pointty); 
                           //draws line with font color 
var
 linewidthbefore: integer;
 capstylebefore: capstylety;
 pt1,pt2: pointty;
begin
 linewidthbefore:= linewidth;
 capstylebefore:= capstyle;
 linewidth:= font.linewidth;
 capstyle:= cs_butt;
 
 with fvaluepo^.font do begin
  if (shadow_color <> cl_none) then begin
   pt1.x:= startpoint.x + shadow_shiftx;     
   pt1.y:= startpoint.y + shadow_shifty;     
   pt2.x:= endpoint.x + shadow_shiftx;     
   pt2.y:= endpoint.y + shadow_shifty;     
   drawline(pt1,pt2,shadow_color);
  end;
  if (gloss_color <> cl_none) then begin
   pt1.x:= startpoint.x + gloss_shiftx;     
   pt1.y:= startpoint.y + gloss_shifty;     
   pt2.x:= endpoint.x + gloss_shiftx;     
   pt2.y:= endpoint.y + gloss_shifty;     
   drawline(pt1,pt2,gloss_color);
  end;
 end;
 
 drawline(startpoint,endpoint,font.color);
 linewidth:= linewidthbefore;
 capstyle:= capstylebefore;
end;

procedure tcanvas.nextpage; //used by tcustomprintercanvas
begin
 //dummy
end;

procedure tcanvas.drawstring(const atext: msestring; const apos: pointty;
                 const afont: tfont = nil; const grayed: boolean = false;
                 const arotation: real = 0);
begin
 if cs_inactive in fstate then exit;
 drawstring(pointer(atext),length(atext),apos,afont,grayed,arotation);
end;

function tcanvas.getstringwidth(const atext: pmsechar; const acount: integer;
                                 const afont: tfont = nil): integer;
var
 afontnum: integer;
begin
 if atext = '' then begin
  result:= 0;
 end
 else begin
  checkgcstate([cs_gc]);
  if afont <> nil then begin //foreign font
   afontnum:= afont.gethandleforcanvas(self);
  end
  else begin
   afontnum:= ffont.handle;
  end;
  with fdrawinfo.gettext16width do begin
   fontdata:= getfontdata(afontnum);
   text:= atext;
   count:= acount;
  end;
  gdi(gdf_gettext16width);
  result:= fdrawinfo.gettext16width.result;
//  gdi_lock;
//  result:= gui_gettext16width(fdrawinfo);
//  gdi_unlock;
 end;
end;

function tcanvas.getstringwidth(const atext: msestring; const afont: tfont = nil): integer;
begin
 result:= getstringwidth(pmsechar(atext),length(atext),afont);
end;

function tcanvas.getfontmetrics(const achar: msechar;
                     const afont: tfont = nil): fontmetricsty;
var
 afontnum: integer;
begin
 if afont <> nil then begin //foreign font
  afontnum:= afont.gethandleforcanvas(self);
 end
 else begin
  afontnum:= ffont.handle;
 end;
 with fdrawinfo.getfontmetrics do begin
  fontdata:= getfontdata(afontnum);
  char:= achar;
  resultpo:= @result;
 end;
 checkgcstate([cs_gc]);
 gdi(gdf_getfontmetrics);
// gdi_lock;
// gdierrorlocked(gui_getfontmetrics(fdrawinfo),self);
 with result do begin
  sum:= width - leftbearing - rightbearing;
 end;
end;

procedure tcanvas.drawframe(const arect: rectty; awidth: integer;
                         const acolor: colorty; const hiddenedges: edgesty);
var
 rect1,rect2: rectty;
begin
 if cs_inactive in fstate then exit;
 if acolor <> cl_transparent then begin
  if awidth <> 0 then begin
   if awidth < 0 then begin
    rect2:= arect;
    awidth:= - awidth;
   end
   else begin
    rect2.x:= arect.x - awidth;
    rect2.y:= arect.y - awidth;
    rect2.cx:= arect.cx + awidth + awidth;
    rect2.cy:= arect.cy + awidth + awidth;
   end;
   if checkforeground(acolor,false) then begin
    with fdrawinfo.rect do begin
     rect:= @rect1;
     with rect2 do begin
      rect1.pos:= pos;
      rect1.cx:= cx;
      rect1.cy:= awidth;
      if not (edg_top in hiddenedges) then begin
       gdi(gdf_fillrect); //top
      end;
      rect1.pos.y:= y + cy - awidth;
      if not (edg_bottom in hiddenedges) then begin
       gdi(gdf_fillrect); //bottom
      end;
      rect1.pos.y:= y;
      rect1.cy:= cy;
      if not (edg_top in hiddenedges) then begin
       inc(rect1.pos.y,awidth);
       dec(rect1.cy,awidth);
      end;
      if not (edg_bottom in hiddenedges) then begin
       dec(rect1.cy,awidth);
      end;
      rect1.cx:= awidth;
      if not (edg_left in hiddenedges) then begin
       gdi(gdf_fillrect); //left
      end;
      rect1.pos.x:= x + cx - awidth;
      if not (edg_right in hiddenedges) then begin
       gdi(gdf_fillrect); //right
      end;
     end;
    end;
   end;
  end;
 end;
end;

procedure tcanvas.drawxorframe(const arect: rectty; const awidth: integer = -1;
                           const abrush: tsimplebitmap = nil);
var
 rasteropbefore: rasteropty;
 brushbefore: tsimplebitmap;
 brushoriginbefore: pointty;
 int1: integer;
begin
 if cs_inactive in fstate then exit;
 int1:= -awidth*2;
 if (abs(arect.cx) < int1) or (abs(arect.cy) < int1) then begin
  fillxorrect(arect,abrush); //avoid xor overlap
 end
 else begin
  rasteropbefore:= rasterop;
  rasterop:= rop_xor;
  if abrush = nil then begin
   drawframe(arect,awidth,cl_white);
  end
  else begin
   brushbefore:= brush;
   brushoriginbefore:= brushorigin;
   brushorigin:= nullpoint;
   brush:= abrush;
   drawframe(arect,awidth,cl_brush);
   brush:= brushbefore;
   brushorigin:= brushoriginbefore;
  end;
  rasterop:= rasteropbefore;
 end;
end;

procedure tcanvas.drawxorframe(const po1, po2: pointty; const awidth: integer = -1;
  const abrush: tsimplebitmap = nil);
begin
 if cs_inactive in fstate then exit;
 drawxorframe(makerect(po1,makesize(po2.x-po1.x,po2.y-po1.y)),awidth,abrush);
end;

procedure tcanvas.fillxorrect(const arect: rectty;
                                     const abrush: tsimplebitmap = nil);
var
 rasteropbefore: rasteropty;
 brushbefore: tsimplebitmap;
 brushoriginbefore: pointty;
begin
 if cs_inactive in fstate then exit;
 rasteropbefore:= rasterop;
 rasterop:= rop_xor;
 if abrush = nil then begin
  fillrect(arect,cl_white);
 end
 else begin
  brushbefore:= brush;
  brushoriginbefore:= brushorigin;
  brushorigin:= nullpoint;
  brush:= abrush;
  fillrect(arect,cl_brush);
  brush:= brushbefore;
  brushorigin:= brushoriginbefore;
 end;
 rasterop:= rasteropbefore;
end;

procedure tcanvas.fillxorrect(const start: pointty; const length: integer;
                      const direction: graphicdirectionty;
                      const awidth: integer = 0;
                      const abrush: tsimplebitmap = nil);
var
 rect1: rectty;
begin
 case direction of
  gd_left: begin
   rect1.x:= start.x - length;
   rect1.y:= start.y - awidth div 2;
   rect1.cx:= length;
   rect1.cy:= awidth;
  end;
  gd_down: begin
   rect1.y:= start.y;
   rect1.x:= start.x - awidth div 2;
   rect1.cy:= length;
   rect1.cx:= awidth;
  end;
  gd_up: begin
   rect1.y:= start.y - length;
   rect1.x:= start.x - awidth div 2;
   rect1.cy:= length;
   rect1.cx:= awidth;
  end;
  else begin //gd_right
   rect1.x:= start.x;
   rect1.y:= start.y - awidth div 2;
   rect1.cx:= length;
   rect1.cy:= awidth;
  end;
 end;
 fillxorrect(rect1,abrush);
end;


//
// region helpers
//

function tcanvas.createregion: regionty;
begin
 gdi(gdf_createemptyregion);
 result:= fdrawinfo.regionoperation.dest;
end;

function tcanvas.createregion(const asource: regionty): regionty;
begin
 with fdrawinfo.regionoperation do begin
  source:= asource;
  gdi(gdf_copyregion);
  result:= dest;
 end;
end;

function tcanvas.createregion(const arect: rectty): regionty;
begin
 with fvaluepo^,fdrawinfo.regionoperation do begin
  rect:= arect;
  inc(rect.x,origin.x);
  inc(rect.y,origin.y);
  gdi(gdf_createrectregion);
  result:= dest;
 end;
end;

function tcanvas.createregion(const rects: array of rectty): regionty;
begin
 with fdrawinfo.regionoperation do begin
  rectscount:= high(rects) + 1;
  if rectscount > 0 then begin
   rectspo:= @rects[0];
   adjustrectar(@rects[0],rectscount);
   gdi(gdf_createrectsregion);
   result:= dest;
   readjustrectar(@rects[0],rectscount);
  end
  else begin
   result:= createregion;
  end;
 end;
end;

function tcanvas.createregion(frame: rectty; const inflate: integer): regionty;
          //frame
var
 reg1: regionty;
begin
 with fvaluepo^ do begin
  inc(frame.x,origin.x);
  inc(frame.y,origin.y);
 end;
 if inflate > 0 then begin
  result:= createregion(inflaterect(frame,inflate));
  reg1:= createregion(frame);
 end
 else begin
  result:= createregion(frame);
  reg1:= createregion(inflaterect(frame,inflate));
 end;
 regsubregion(result,reg1);
 destroyregion(reg1);
end;

procedure tcanvas.destroyregion(region: regionty);
begin
 with fdrawinfo.regionoperation do begin
  source:= region;
  gdi(gdf_destroyregion);
 end;
end;

procedure tcanvas.regmove(const adest: regionty; const dist: pointty);
begin
 with fdrawinfo.regionoperation do begin
  dest:= adest;
  rect.pos:= dist;
 end;
 gdi(gdf_moveregion);
end;

procedure tcanvas.regremove(const adest: regionty; const dist: pointty);
begin
 regmove(adest,makepoint(-dist.x,-dist.y));
end;

procedure tcanvas.initregrect(const adest: regionty; const arect: rectty);
begin
 with fdrawinfo,regionoperation do begin
  dest:= adest;
  rect:= arect;
  inc(rect.x,fvaluepo^.origin.x);
  dec(rect.x,gc.cliporigin.x);
  inc(rect.y,fvaluepo^.origin.y);
  dec(rect.y,gc.cliporigin.y);
  if rect.x < -$8000 then begin
   rect.x:= -$8000;
  end;
  if rect.x > $7fff then begin
   rect.x:= $7fff;
  end;
  if rect.cx < 0 then begin
   rect.cx:= 0;
  end;
  if rect.cx + rect.x > $7fff then begin
   rect.cx:= $7fff - rect.x
  end;
  if rect.y < -$8000 then begin
   rect.y:= -$8000;
  end;
  if rect.y > $7fff then begin
   rect.y:= $7fff;
  end;
  if rect.cy < 0 then begin
   rect.cy:= 0;
  end;
  if rect.cy + rect.y > $7fff then begin
   rect.cy:= $7fff - rect.y;
  end;
 end;
end;

procedure tcanvas.initregreg(const adest: regionty; const asource: regionty);
begin
 with fdrawinfo,regionoperation do begin
  dest:= adest;
  source:= asource;
 end;
end;

procedure tcanvas.regsubrect(const dest: regionty; const rect: rectty);
begin
 initregrect(dest,rect);
 gdi(gdf_regsubrect);
end;

procedure tcanvas.regaddrect(const dest: regionty; const rect: rectty);
begin
 initregrect(dest,rect);
 gdi(gdf_regaddrect);
end;

procedure tcanvas.regintersectrect(const dest: regionty; const rect: rectty);
begin
 initregrect(dest,rect);
 gdi(gdf_regintersectrect);
end;

procedure tcanvas.regaddregion(const dest: regionty; const region: regionty);
begin
 initregreg(dest,region);
 gdi(gdf_regaddregion);
end;

procedure tcanvas.regsubregion(const dest: regionty; const region: regionty);
begin
 initregreg(dest,region);
 gdi(gdf_regsubregion);
end;

procedure tcanvas.regintersectregion(const dest: regionty; const region: regionty);
begin
 initregreg(dest,region);
 gdi(gdf_regintersectregion);
end;

function tcanvas.regionisempty(const region: regionty): boolean;
begin
 with fdrawinfo.regionoperation do begin
  source:= region;
  gdi(gdf_regionisempty);
  result:= dest <> 0;
 end;
end;

function tcanvas.regionclipbox(const region: regionty): rectty;
begin
 if region <> 0 then begin
  with fdrawinfo.regionoperation do begin
   source:= region;
   gdi(gdf_regionclipbox);
   result:= rect;
  end;
 end
 else begin
  result:= nullrect;
 end;
end;

//
// clip region functions
//

procedure tcanvas.setclipregion(const Value: regionty);
begin
 with fvaluepo^ do begin
  if cs_regioncopy in changed then begin
   destroyregion(clipregion);
  end;
  include(changed,cs_regioncopy);
  clipregion := Value;
  valuechanged(cs_clipregion);
 end;
end;

procedure tcanvas.subcliprect(const rect: rectty);
begin
 checkregionstate;
 regsubrect(fvaluepo^.clipregion,rect);
end;

procedure tcanvas.subclipframe(const frame: rectty; inflate: integer);
var
 reg1: regionty;
begin
 checkregionstate;
 reg1:= createregion(frame,inflate);
 regsubregion(fvaluepo^.clipregion,reg1);
 destroyregion(reg1);
end;

procedure tcanvas.subclipregion(const region: regionty);
begin
 checkregionstate;
 regsubregion(fvaluepo^.clipregion,region);
end;

procedure tcanvas.addcliprect(const rect: rectty);
begin
 checkregionstate;
 regaddrect(fvaluepo^.clipregion,rect);
end;

procedure tcanvas.addclipframe(const frame: rectty; inflate: integer);
var
 reg1: regionty;
begin
 checkregionstate;
 reg1:= createregion(frame,inflate);
 regaddregion(fvaluepo^.clipregion,reg1);
 destroyregion(reg1);
end;

procedure tcanvas.addclipregion(const region: regionty);
begin
 checkregionstate;
 regaddregion(fvaluepo^.clipregion,region);
end;

procedure tcanvas.intersectcliprect(const rect: rectty);
begin
 checkregionstate;
 regintersectrect(fvaluepo^.clipregion,rect);
end;

procedure tcanvas.intersectclipframe(const frame: rectty; inflate: integer);
var
 reg1: regionty;
begin
 checkregionstate;
 reg1:= createregion(frame,inflate);
 regintersectregion(fvaluepo^.clipregion,reg1);
 destroyregion(reg1);
end;

procedure tcanvas.intersectclipregion(const region: regionty);
begin
 checkregionstate;
 regintersectregion(fvaluepo^.clipregion,region);
end;

function tcanvas.copyclipregion: regionty;
begin
 with fdrawinfo.regionoperation do begin
  source:= fvaluepo^.clipregion;
  gdi(gdf_copyregion);
  result:= dest;
 end;
end;

//
//
//

procedure tcanvas.adjustrectar(po: prectty; count: integer);
var
 dx,dy: integer;
begin
 dx:= fvaluepo^.origin.x;
 dy:= fvaluepo^.origin.y;
 if (dx <> 0) or (dy <> 0 ) then begin
  while count > 0 do begin
   inc(po^.x,dx);
   inc(po^.y,dy);
   inc(po);
   dec(count);
  end;
 end;
end;

procedure tcanvas.readjustrectar(po: prectty; count: integer);
var
 dx,dy: integer;
begin
 dx:= fvaluepo^.origin.x;
 dy:= fvaluepo^.origin.y;
 if (dx <> 0) or (dy <> 0 ) then begin
  while count > 0 do begin
   dec(po^.x,dx);
   dec(po^.y,dy);
   inc(po);
   dec(count);
  end;
 end;
end;

function tcanvas.getcolor: colorty;
begin
 result:= fvaluepo^.color;
end;

procedure tcanvas.setcolor(const value: colorty);
begin
 if fvaluepo^.color <> value then begin
  fvaluepo^.color:= value;
  valuechanged(cs_color);
 end;
end;

function tcanvas.getcolorbackground: colorty;
begin
 result:= fvaluepo^.colorbackground;
end;

procedure tcanvas.setcolorbackground(const Value: colorty);
begin
 if fvaluepo^.colorbackground <> value then begin
  fvaluepo^.colorbackground:= value;
  valuechanged(cs_colorbackground);
 end;
end;

function tcanvas.getrasterop: rasteropty;
begin
 result:= fvaluepo^.rasterop;
end;

procedure tcanvas.setrasterop(const Value: rasteropty);
begin
 if fvaluepo^.rasterop <> value then begin
  fvaluepo^.rasterop:= value;
  valuechanged(cs_rasterop);
 end;
end;

function tcanvas.getlinewidth: integer;
begin
 result:= (fvaluepo^.lineinfo.width + linewidthroundvalue) shr linewidthshift;
end;

procedure tcanvas.setlinewidth(Value: integer);
begin
 value:= value shl linewidthshift;
 if fvaluepo^.lineinfo.width <> value then begin
  fvaluepo^.lineinfo.width:= value;
  valuechanged(cs_linewidth);
 end;
end;

function tcanvas.getlinewidthmm: real;
begin
 result:= fvaluepo^.lineinfo.width / 
                        (fdrawinfo.gc.ppmm * (1 shl linewidthshift));
end;

procedure tcanvas.setlinewidthmm(const avalue: real);
var
 int1: integer;
begin
 int1:= round(avalue * (1 shl linewidthshift) * fdrawinfo.gc.ppmm);
 if fvaluepo^.lineinfo.width <> int1 then begin
  fvaluepo^.lineinfo.width:= int1;
  valuechanged(cs_linewidth);
 end;
end;

function tcanvas.getdashes: dashesstringty;
begin
 result:= fvaluepo^.lineinfo.dashes;
end;

procedure tcanvas.setdashes(const Value: dashesstringty);
var
 int1: integer;
begin
 with fvaluepo^.lineinfo do begin
  dashes:= value;
  for int1:= 1 to length(dashes) do begin
   if dashes[int1] = #0 then begin
    setlength(dashes,int1);
    break;
   end;
  end;
 end;
 valuechanged(cs_dashes);
end;

function tcanvas.getcapstyle: capstylety;
begin
 result:= fvaluepo^.lineinfo.capstyle;
end;

procedure tcanvas.setcapstyle(const Value: capstylety);
begin
 fvaluepo^.lineinfo.capstyle:= value;
 valuechanged(cs_capstyle);
end;

function tcanvas.getjoinstyle: joinstylety;
begin
 result:= fvaluepo^.lineinfo.joinstyle;
end;

function tcanvas.getlineoptions: lineoptionsty;
begin
 result:= fvaluepo^.lineinfo.options;
end;

procedure tcanvas.setjoinstyle(const Value: joinstylety);
begin
 fvaluepo^.lineinfo.joinstyle:= value;
 valuechanged(cs_joinstyle);
end;

procedure tcanvas.setlineoptions(const avalue: lineoptionsty);
begin
 fvaluepo^.lineinfo.options:= avalue;
 valuechanged(cs_lineoptions);
end;

function tcanvas.defaultcliprect: rectty;
begin
 result:= makerect(nullpoint,fdrawinfo.gc.paintdevicesize);
end;

procedure tcanvas.checkregionstate;
begin
 with fvaluepo^ do begin
  if clipregion = 0 then begin
   checkgcstate([cs_gc]); //fsize must be valid
   clipregion:= createregion(defaultcliprect);
  end
  else begin
   if not (cs_regioncopy in changed) then begin
    clipregion:= createregion(clipregion);
   end;
  end;
  include(changed,cs_regioncopy);
  include(changed,cs_clipregion);
 end;
 exclude(fstate,cs_clipregion);
end;

procedure tcanvas.move(const dist: pointty);
begin
 if (dist.x <> 0) or (dist.y <> 0) then begin
  with fvaluepo^ do begin
   inc(origin.x,dist.x);
   inc(origin.y,dist.y);
  end;
  valuechanged(cs_origin);
 end;
end;

procedure tcanvas.remove(const dist: pointty);
begin
 with fvaluepo^ do begin
  dec(origin.x,dist.x);
  dec(origin.y,dist.y);
 end;
 valuechanged(cs_origin);
end;

function tcanvas.getorigin: pointty;
begin
 result:= subpoint(fvaluepo^.origin,fdrawinfo.gc.cliporigin);
end;

procedure tcanvas.setorigin(const Value: pointty);
var
 po1: pointty;
begin
 po1:= addpoint(value,fdrawinfo.gc.cliporigin);
 if not pointisequal(fvaluepo^.origin,po1) then begin
  fvaluepo^.origin:= po1;
  valuechanged(cs_origin);
 end;
end;

function tcanvas.clipregionisempty: boolean;
begin
 with fvaluepo^ do begin
  if clipregion = 0 then begin
   result:= false;
  end
  else begin
   result:= regionisempty(clipregion);
  end;
 end;
end;

function tcanvas.clipbox: rectty;
begin
 with fvaluepo^ do begin
  if clipregion = 0 then begin
   result:= makerect(makepoint(-origin.x,-origin.y),icanvas(fintf).getsize);
  end
  else begin
   result:= regionclipbox(clipregion);
   dec(result.x,origin.x);
   inc(result.x,fdrawinfo.gc.cliporigin.x);
   dec(result.y,origin.y);
   inc(result.y,fdrawinfo.gc.cliporigin.y);
  end;
 end;
end;

{
procedure tcanvas.drawedge(const vector: graphicvectorty; level: integer;
                                const colorinfo: framecolorinfoty);
//procedure paintkante2(painter: qpainterh; const startpoint: tpoint;
//                         length: integer; direction: tgraphicdirection;
//                         width: integer; const color: qcolorh;
//                         glanz: integer = 0; const colorglanz: qcolorh = nil;
//                         infos: kanteninfosty = []);
                          //glanz < 0 -> am schluss bei dark
var
 points: tpointarray;
 breite1,breite2: integer;
 step1a,step2a,step3a: integer;
 step1b,step2b,step3b: integer;
 reverseoffset: integer;

begin
 if length <= 0 then begin
  exit;
 end;
 if not (kin_dark in infos) then begin
  glanz:= -glanz;
 end;
 setlength(points,8);
 points[0]:= startpoint;
 if glanz <= 0 then begin          //glanz am schluss
  breite1:= width+glanz;
  qpainter_setpen(painter,color);
  qpainter_setbrush(painter,color);
 end
 else begin                        //glanz zu beginn
  breite1:= glanz;
  qpainter_setpen(painter,colorglanz);
  qpainter_setbrush(painter,colorglanz);
 end;
 if breite1 > width then begin
  breite1:= width;
 end;
 if breite1 < 0 then begin
  breite1:= 0;
 end;
 reverseoffset:= 2*width;
 dec(length);
 dec(width);
 dec(breite1);
 breite2:= width-breite1-1;
 if kin_reverseend in infos then begin
  step1a:= -breite1;
  step2a:= -1;
  step3a:= -width;
  length:= length-reverseoffset;
 end
 else begin
  step1a:= breite1;
  step2a:= 1;
  step3a:= width;
 end;
 if kin_reversestart in infos then begin
  step1b:= -breite1+reverseoffset;
  step2b:= -1;
  step3b:= -width+reverseoffset;
 end
 else begin
  reverseoffset:= 0;
  step1b:= breite1;
  step2b:= 1;
  step3b:= width;
 end;
 case direction of
  gd_right: begin
   points[0].X:= startpoint.X + reverseoffset;
   points[1].x:= startpoint.X + length;
   points[1].Y:= startpoint.Y;
   points[2].X:= points[1].X - step1a;
   points[2].Y:= startpoint.Y + breite1;
   points[3].x:= startpoint.x + step1b;
   points[3].Y:= points[2].Y;
   if breite2 >= 0 then begin
    points[4].X:= points[3].X + step2b;
    points[4].Y:= points[3].Y + 1;
    points[5].X:= points[2].X - step2a;
    points[5].y:= points[2].y + 1;
    points[6].X:= points[1].X - step3a;
    points[6].Y:= startpoint.Y + width;
    points[7].x:= startpoint.x + step3b;
    points[7].Y:= points[6].Y;
   end;
  end;
  gd_up: begin
   points[0].y:= startpoint.y - reverseoffset;
   points[1].x:= startpoint.X;
   points[1].Y:= startpoint.Y-length;
   points[2].X:= startpoint.X + breite1;
   points[2].Y:= points[1].Y + step1a;
   points[3].x:= points[2].x;
   points[3].Y:= startpoint.Y - step1b;
   if breite2 >= 0 then begin
    points[4].X:= points[3].X + 1;
    points[4].Y:= points[3].Y - step2b;
    points[5].X:= points[2].X + 1;
    points[5].y:= points[2].y + step2a;
    points[6].X:= startpoint.x + width;
    points[6].Y:= points[1].Y + step3a;
    points[7].x:= points[6].x;
    points[7].Y:= startpoint.y - step3b;
   end;
  end;
  gd_left: begin
   points[0].X:= startpoint.X - reverseoffset;
   points[1].x:= startpoint.X - length;
   points[1].Y:= startpoint.Y;
   points[2].X:= points[1].X + step1a;
   points[2].Y:= startpoint.Y - breite1;
   points[3].x:= startpoint.x - step1b;
   points[3].Y:= points[2].Y;
   if breite2 >= 0 then begin
    points[4].X:= points[3].X - step2b;
    points[4].Y:= points[3].Y - 1;
    points[5].X:= points[2].X + step2a;
    points[5].y:= points[2].y - 1;
    points[6].X:= points[1].X + step3a;
    points[6].Y:= startpoint.Y - width;
    points[7].x:= startpoint.x - step3b;
    points[7].Y:= points[6].Y;
   end;
  end;
  gd_down: begin
   points[0].y:= startpoint.y + reverseoffset;
   points[1].x:= startpoint.X;
   points[1].Y:= startpoint.Y+length;
   points[2].X:= startpoint.X - breite1;
   points[2].Y:= points[1].Y - step1a;
   points[3].x:= points[2].x;
   points[3].Y:= startpoint.Y + step1b;
   if breite2 >= 0 then begin
    points[4].X:= points[3].X - 1;
    points[4].Y:= points[3].Y + step2b;
    points[5].X:= points[2].X - 1;
    points[5].y:= points[2].y - step2a;
    points[6].X:= startpoint.x - width;
    points[6].Y:= points[1].Y - step3a;
    points[7].x:= points[6].x;
    points[7].Y:= startpoint.y + step3b;
   end;
  end;
 end;
 if breite1 >= 0 then begin
  if breite1 > 1 then begin
   qpainter_drawpolygon(painter,@points[0],false,0,4);
  end
  else begin
   qpainter_moveto(painter,@points[0]);
   qpainter_lineto(painter,@points[1]);
   if breite1 = 1 then begin
    qpainter_moveto(painter,@points[2]);
    qpainter_lineto(painter,@points[3]);
   end;
  end;
 end;
 if breite2 >= 0 then begin
  if glanz < 0 then begin
   qpainter_setpen(painter,colorglanz);
   qpainter_setbrush(painter,colorglanz);
  end
  else begin
   qpainter_setpen(painter,color);
   qpainter_setbrush(painter,color);
  end;
  if breite2 > 1 then begin
   qpainter_drawpolygon(painter,@points[0],false,4,4);
  end
  else begin
   qpainter_moveto(painter,@points[4]);
   qpainter_lineto(painter,@points[5]);
   if breite2 = 1 then begin
    qpainter_moveto(painter,@points[6]);
    qpainter_lineto(painter,@points[7]);
   end;
  end;
 end;
end;
}
{
procedure tcanvas.drawedge(const vector: graphicvectorty; level: integer;
                                const colorinfo: framecolorinfoty);
var
 poly: pointarty;

 procedure shrink(value: integer);
 begin
  case vector.direction of
   gd_right: begin
    poly[2].x:= poly[1].x - value;
    poly[2].y:= poly[1].y - value;
    poly[3].x:= poly[0].x + value;
    poly[3].y:= poly[0].y - value;
   end;
   gd_up: begin
    poly[2].x:= poly[1].x - value;
    poly[2].y:= poly[1].y + value;
    poly[3].x:= poly[0].x - value;
    poly[3].y:= poly[0].y - value;
   end;
   gd_left: begin
    poly[2].x:= poly[1].x - value;
    poly[2].y:= poly[1].y + value;
    poly[3].x:= poly[0].x + value;
    poly[3].y:= poly[0].y + value;
   end;
   gd_down: begin
    poly[2].x:= poly[1].x + value;
    poly[2].y:= poly[1].y + value;
    poly[3].x:= poly[0].x + value;
    poly[3].y:= poly[0].y - value;
   end;
  end;
 end;

 procedure offset;
 begin
  case vector.direction of
   gd_right: begin
    inc(poly[0].x);
    dec(poly[0].y);
    dec(poly[1].x);
    dec(poly[1].y);
   end;
   gd_up: begin
    dec(poly[0].x);
    dec(poly[0].y);
    dec(poly[1].x);
    inc(poly[1].y);
   end;
   gd_left: begin
    inc(poly[0].x);
    inc(poly[0].y);
    dec(poly[1].x);
    inc(poly[1].y);
   end;
   gd_down: begin
    inc(poly[0].x);
    dec(poly[0].y);
    inc(poly[1].x);
    inc(poly[1].y);
   end;
  end;
 end;

 procedure draw(with1,with2: integer; col1,col2: colorty);
 begin
  if with1 > 0 then begin
   if with1 = 1 then begin
    drawlines(poly,col1,2);
   end
   else begin
    shrink(with1);
    fillpolygon(poly,col1);
    poly[0]:= poly[3];
    poly[1]:= poly[2];
   end;
  end;
  if with2 > 0 then begin
   offset;
   if with2 = 1 then begin
    drawlines(poly,col2,2);
   end
   else begin
    shrink(with2);
    fillpolygon(poly,col2);
   end;
  end;
 end;

var
 topleft,inlight,effectfirst: boolean;
 effcol,normcol: colorty;
 effwidth: integer;

begin
 if level = 0 then begin
  exit;
 end;
 with colorinfo do begin
  topleft:= vector.direction in [gd_left,gd_down];
  inlight:= topleft;
  if level < 0 then begin
   level:= -level;
   inlight:= not inlight;
  end;
  if inlight then begin
   normcol:= collight;
   effcol:= colhighlight;
   effwidth:= highlight;
  end
  else begin
   normcol:= colshadow;
   effcol:= coldkshadow;
   effwidth:= dkshadow;
  end;
  if effwidth < 0 then begin
   effwidth:= -effwidth;
   effectfirst:= topleft;
  end
  else begin
   effectfirst:= false;
  end;
  if effwidth > level then begin
   effwidth:= level;
   level:= 0;
  end
  else begin
   level:= level - effwidth;
  end;
  if not inlight then begin
   if (level = 0) then begin
    level:= effwidth;
    effwidth:= 0;
   end;
  end;
 end;
 setlength(poly,4);
 vectortoline(vector,poly[0],poly[1]);
 poly[0]:= vector.start;
 if effectfirst then begin
  draw(effwidth,level,effcol,normcol);
 end
 else begin
  draw(level,effwidth,normcol,effcol);
 end;
end;
}
function tcanvas.getbrush: tsimplebitmap;
begin
 result:= fvaluepo^.brush;
end;

procedure tcanvas.setbrush(const Value: tsimplebitmap);
begin
 if fvaluepo^.brush <> value then begin
  fvaluepo^.brush:= value;
  valuechanged(cs_brush);
  gccolorforeground:= cl_none; //force reload
 end;
end;

procedure tcanvas.resetpaintedflag;
begin
 exclude(fstate,cs_painted);
end;

function tcanvas.getbrushorigin: pointty;
begin
 result.x:= fvaluepo^.brushorigin.x-fvaluepo^.origin.x;
 result.y:= fvaluepo^.brushorigin.y-fvaluepo^.origin.y;
end;

procedure tcanvas.setbrushorigin(const Value: pointty);
begin
 fvaluepo^.brushorigin.x:= value.x+fvaluepo^.origin.x;
 fvaluepo^.brushorigin.y:= value.y+fvaluepo^.origin.y;
 valuechanged(cs_brushorigin);
end;

function tcanvas.getrootbrushorigin: pointty;
begin
 result.x:= fvaluepo^.brushorigin.x-fcliporigin.x;
 result.y:= fvaluepo^.brushorigin.y-fcliporigin.y;
end;

procedure tcanvas.setrootbrushorigin(const Value: pointty);
begin
 fvaluepo^.brushorigin.x:= value.x+fcliporigin.x;
 fvaluepo^.brushorigin.y:= value.y+fcliporigin.y;
 valuechanged(cs_brushorigin);
end;

procedure tcanvas.adjustbrushorigin(const arect: rectty; 
                                            const alignment: alignmentsty);
var
 siz1: sizety;
 pt1: pointty;
begin
 if fvaluepo^.brush <> nil then begin
  siz1:= fvaluepo^.brush.size;
 end
 else begin
  siz1:= nullsize;
 end;
 pt1.x:= -fvaluepo^.origin.x;
 pt1.y:= -fvaluepo^.origin.y;
 if al_left in alignment then begin
  pt1.x:= arect.x;
 end
 else begin
  if al_xcentered in alignment then begin
   pt1.x:= arect.x + (arect.cx - siz1.cx) div 2;
  end
  else begin
   if al_right in alignment then begin
    pt1.x:= arect.x + arect.cx - siz1.cx;
   end;
  end;
 end;
 if al_top in alignment then begin
  pt1.y:= arect.y;
 end
 else begin
  if al_ycentered in alignment then begin
   pt1.y:= arect.y + (arect.cy - siz1.cy) div 2;
  end
  else begin
   if al_bottom in alignment then begin
    pt1.y:= arect.y + arect.cy - siz1.cy;
   end;
  end;
 end;
 brushorigin:= pt1;
end;

function tcanvas.active: boolean;
begin
 result:= fdrawinfo.gc.handle <> 0;
end;

procedure tcanvas.updatecliporigin(const Value: pointty);
var
 delta: pointty;
 int1: integer;
begin
 delta:= subpoint(value,fcliporigin);
 fcliporigin:= value;
 fdrawinfo.gc.cliporigin:= value;
 with fvaluestack do begin
  for int1:= 0 to count-1 do begin
   addpoint1(stack[int1].origin,delta);
  end;
 end;
 addpoint1(fdrawinfo.origin,delta);
end;

procedure tcanvas.setcliporigin(const Value: pointty);
begin
 checkgcstate([cs_gc]);
 updatecliporigin(value);
 gdi(gdf_setcliporigin);
end;

procedure tcanvas.setppmm(avalue: real);
begin
 if avalue < 0.1 then begin
  avalue:= 0.1;
 end;
 fdrawinfo.gc.ppmm:= avalue; 
end;

procedure tcanvas.internaldrawtext(var info);
begin
 gdierror(gde_notimplemented);
end;

procedure tcanvas.initflags(const dest: tcanvas);
begin
 with dest do begin
  exclude(fdrawinfo.gc.drawingflags,df_highresfont);
  ffont.releasehandles;
  gcfonthandle1:= 0; //invalid  
 end; 
end;

function tcanvas.highresdevice: boolean;
begin
 result:= cs_highresdevice in fstate;
end;

function tcanvas.getmonochrome: boolean;
begin
 result:= icanvas(fintf).getmonochrome;
end;

initialization
{$ifdef mse_flushgdi}
 flushgdi:= true;
{$endif}
 setlength(gdifuncs,1); //item 0 = system default
 gdifuncs[0]:= gui_getgdifuncs;
finalization
 deinit;
end.

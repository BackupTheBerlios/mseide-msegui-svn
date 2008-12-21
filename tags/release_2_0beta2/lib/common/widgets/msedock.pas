{ MSEgui Copyright (c) 1999-2008 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit msedock;

{$ifdef FPC}{$mode objfpc}{$h+}{$GOTO ON}{$interfaces corba}{$endif}

interface
uses
 msewidgets,classes,msedrag,msegui,msegraphutils,mseevent,mseclasses,
 msegraphics,msestockobjects,mseglob,mseguiglob,msestat,msestatfile,msepointer,
 msesplitter,msesimplewidgets,msetypes,msestrings,msebitmap,mseobjectpicker,
 msetabsglob,msemenus;
 
//todo: optimize

const
 defaultgripsize = 10;
 defaultgripgrip = stb_none;
 defaultgripcolor = cl_white;
 defaultgripcoloractive = cl_activegrip;
 defaultgrippos = cp_right;
 defaultsplittersize = 3;

type
 optiondockty = (od_savepos,od_savezorder,od_savechildren,
            od_canmove,od_cansize,od_canfloat,od_candock,od_acceptsdock,
            od_dockparent,od_expandforfixsize,
            od_splitvert,od_splithorz,od_tabed,od_proportional,
            od_propsize,od_fixsize,od_top,od_background,
            od_alignbegin,od_aligncenter,od_alignend,
            od_nofit,od_banded,od_nosplitsize,od_nosplitmove);
 optionsdockty = set of optiondockty;

 dockbuttonrectty = (dbr_none,dbr_handle,dbr_close,dbr_maximize,dbr_normalize,
                     dbr_minimize,dbr_fixsize,
                     dbr_top,dbr_background);
const
 defaultoptionsdock = [od_savepos,od_savezorder,od_savechildren];
 dbr_first = dbr_handle;
 dbr_last = dbr_background;
 defaulttaboptions= [tabo_dragdest,tabo_dragsource];
 
type
 twidgetdragobject = class(tdragobject)
  private
   function getwidget: twidget;
  public
   constructor create(const asender: twidget; var instance: tdragobject;
                       const apickpos: pointty);
  property widget: twidget read getwidget;
 end;

 tdockcontroller = class;

 tdockdragobject = class(twidgetdragobject)
  private
   fxorwidget: twidget;
   fxorrect: rectty; //screen origin
   fdock: tdockcontroller;
   findex: integer;
   fcheckeddockcontroller: tdockcontroller;
  protected
   procedure drawxorpic;
   procedure setxorwidget(const awidget: twidget; const screenrect: rectty);
  public
   constructor create(const adock: tdockcontroller; const asender: twidget;
          var instance: tdragobject; const apickpos: pointty);
   destructor destroy; override;
   procedure refused(const apos: pointty); override;
 end;

 idockcontroller = interface(idragcontroller)
  function checkdock(var info: draginfoty): boolean;
  function getbuttonrects(const index: dockbuttonrectty): rectty;  
                                      //origin = clientrect.pos
  function getplacementrect: rectty;  //origin = container.pos
  function getminimizedsize(out apos: captionposty): sizety;  
                     //cx = 0 -> normalwidth, cy = 0 -> normalheight
  function getcaption: msestring;
 end;

 checkdockeventty = procedure(const sender: tobject; const apos: pointty;
                      const dockdragobject: tdockdragobject;
                      var accept: boolean) of object;

 tdockhandle = class(tpublishedwidget)
  private
   fcontroller: tdockcontroller;
   fgrip_pos: captionposty;
   fgrip_color: colorty;
   fgrip_grip: stockbitmapty;
   procedure setgrip_color(const Value: colorty);
   procedure setgrip_grip(const Value: stockbitmapty);
   procedure setgrip_pos(const Value: captionposty);
  protected
   function gethandlerect: rectty;
   procedure clientmouseevent(var info: mouseeventinfoty); override;
   procedure dopaint(const canvas: tcanvas); override;
  public
   constructor create(aowner: tcomponent); override;
  published
   property grip_pos: captionposty read fgrip_pos write setgrip_pos default cp_bottomright;
   property grip_grip: stockbitmapty read fgrip_grip write setgrip_grip default stb_none;
   property grip_color: colorty read fgrip_color write setgrip_color default defaultgripcolor;
   property bounds_cx default 15;
   property bounds_cy default 15;
   property anchors default [an_right,an_bottom];
   property color default cl_transparent;
   property optionswidget default defaultoptionswidget + [ow_top,ow_noautosizing];
 end;

 dockstatety = (dos_layoutvalid,dos_updating1,dos_updating2,dos_updating3,
                 dos_updating4,dos_updating5,dos_tabedending,
                    dos_closebuttonclicked,dos_maximizebuttonclicked,
                    dos_normalizebuttonclicked,dos_minimizebuttonclicked,
                    dos_fixsizebuttonclicked,
                    dos_topbuttonclicked,dos_backgroundbuttonclicked,
                    dos_moving,
                    dos_proprefvalid);
 dockstatesty = set of dockstatety;

 splitdirty = (sd_none,sd_x,sd_y,sd_tabed);
 mdistatety = (mds_normal,mds_maximized,mds_minimized,mds_floating);

 dockcontrollereventty = procedure(const sender: tdockcontroller) of object;
 
 docklayouteventty = procedure(const sender: twidget; 
                                        const achildren: widgetarty) of object;
 mdistatechangedeventty = procedure(const sender: twidget;
                             const oldvalue,newvalue: mdistatety) of object;

 bandinfoty = record
  first: integer;
  last: integer;
  size: integer;
 end;
 
 bandinfoarty = array of bandinfoty;
 
 tdockcontroller = class(tdragcontroller)
  private
   foncalclayout: docklayouteventty;
   fonlayoutchanged: dockcontrollereventty;
   fonfloat: notifyeventty;
   fondock: notifyeventty;
   fonchilddock: widgeteventty;
   fonchildfloat: widgeteventty;
   foncheckdock: checkdockeventty;
   fdockhandle: tdockhandle;
   fsplitter_size: integer;
   fcursorbefore: cursorshapety;
   fsizeindex: integer;
   fmoveindex: integer;
   fsizingrect: rectty;
   fsizeoffset: integer;
   fdockstate: dockstatesty;
   fcaption: msestring;
   fsize: sizety;
   fsplitter_color: colorty;
   fsplitter_colorgrip: colorty;
   fsplitter_grip: stockbitmapty;
   fsplitterrects: rectarty;
   frecalclevel: integer;
   fsplitdir,fasplitdir: splitdirty;
   fmdistate: mdistatety;
   fnormalrect: rectty;
   ftabwidget: twidget; //tdocktabwidget, circular interface reference
   ftaborder: msestringarty;
   factivetab: integer; //used only for statreading
   fuseroptions: optionsdockty;
   floatdockcount: integer;
   fonmdistatechanged: mdistatechangedeventty;
   ftab_options: tabbaroptionsty;
   ftab_size: integer;
   ftab_sizemin: integer;
   ftab_sizemax: integer;
   ftab_color: colorty;
   ftab_colortab: colorty;
   ftab_coloractivetab: colorty;
   ftab_frame: tframecomp;
   ftab_face: tfacecomp;
   ftab_facetab: tfacecomp;
   ftab_faceactivetab: tfacecomp;
   fplacementrect: rectty;
   fbands: bandinfoarty;
   fbandstart: integer;
   fbandgap: integer;
   fsizes: integerarty;
   frefsize: integer;
   procedure updaterefsize;
   procedure setdockhandle(const avalue: tdockhandle);
   procedure layoutchanged;
   function checksplit(const awidgets: widgetarty;
                 out propsize,varsize,fixsize,fixcount: integer;
                 out isprop,isfix: booleanarty;
                 const fixedareprop: boolean): widgetarty; overload;
   function checksplit(out propsize,fixsize: integer;
                 out isprop,isfix: booleanarty;
                 const fixedareprop: boolean): widgetarty; overload;
   function checksplit: widgetarty; overload;
   procedure setcaption(const Value: msestring);
   procedure setsplitter_size(const Value: integer);
   procedure setsplitter_setgrip(const Value: stockbitmapty);
   procedure setsplitter_color(const Value: colorty);
   procedure setsplitter_colorgrip(const Value: colorty);
   procedure splitterchanged;
   procedure updategrip(const asplitdir: splitdirty; const awidget: twidget);
   procedure setuseroptions(const avalue: optionsdockty);
   function placementrect: rectty;
   procedure settab_options(const avalue: tabbaroptionsty);
   procedure settab_frame(const avalue: tframecomp);
   procedure settab_face(const avalue: tfacecomp);
   procedure settab_color(const avalue: colorty);
   procedure settab_colortab(const avalue: colorty);
   procedure settab_coloractivetab(const avalue: colorty);
   procedure settab_facetab(const avalue: tfacecomp);
   procedure settab_faceactivetab(const avalue: tfacecomp);
   procedure settab_size(const avalue: integer);
   procedure settab_sizemin(const avalue: integer);
   procedure settab_sizemax(const avalue: integer);
   procedure setbandgap(const avalue: integer);
  protected
   foptionsdock: optionsdockty;
   fr: prectaccessty;
   fw: pwidgetaccessty;
   procedure checkdirection;
   procedure objectevent(const sender: tobject; const event: objecteventty); override;
   function checkclickstate(const info: mouseeventinfoty): boolean; override;
   
   function doclose(const awidget: twidget): boolean;
   procedure setmdistate(const avalue: mdistatety); virtual;
   procedure domdistatechanged(const oldstate,newstate: mdistatety); virtual;
   procedure dofloat(const adist: pointty); virtual;
   procedure dodock; virtual;
   procedure dochilddock(const awidget: twidget); virtual;
   procedure dochildfloat(const awidget: twidget); virtual;
   function docheckdock(const info: draginfoty): boolean; virtual;

   function getparentcontroller(out acontroller: tdockcontroller): boolean;
   property useroptions: optionsdockty read fuseroptions write setuseroptions
                     default defaultoptionsdock;

   function canfloat: boolean;
   procedure refused(const apos: pointty);
   procedure calclayout(const dragobject: tdockdragobject;
                        const nonewplace: boolean);
   procedure setpickshape(const ashape: cursorshapety);
   procedure restorepickshape;
   function checkbuttonarea(const apos: pointty): dockbuttonrectty;
   procedure updatesplitterrects(const awidgets: widgetarty);
   procedure setoptionsdock(const avalue: optionsdockty); virtual;
   function isfullarea: boolean;
   function istabed: boolean;
   function ismdi: boolean;
   function isfloating: boolean;
   function canmdisize: boolean;
   procedure dolayoutchanged;
   function findbandpos(const apos: integer; out aindex: integer;
                                     out arect: rectty): boolean;
             //false if not found, band index and band rect
   function findbandwidget(const apos: pointty; out aindex: integer;
                                     out arect: rectty): boolean;
             //false if not found. widget index and widget rect
   function findbandindex(const widgetindex: integer; out aindex: integer;
                                     out arect: rectty): boolean;
   function nofit: boolean;
   function writechild(const index: integer): msestring;
   procedure readchildrencount(const acount: integer);
   procedure readchild(const index: integer; const avalue: msestring);

  public
   constructor create(aintf: idockcontroller);
   destructor destroy; override;
   function beforedragevent(var info: draginfoty): boolean; override;
   procedure enddrag; override;
   procedure clientmouseevent(var info: mouseeventinfoty); override;
   procedure childmouseevent(const sender: twidget; var info: mouseeventinfoty);
   procedure checkmouseactivate(const sender: twidget; 
                                      var info: mouseeventinfoty);
   procedure dopaint(const acanvas: tcanvas); //canvasorigin = container.clientpos;
   procedure doactivate;
   procedure sizechanged(force: boolean = false; scalefixedalso: boolean = false;
                           const awidgets: widgetarty = nil);
   procedure poschanged;
   procedure widgetregionchanged(const sender: twidget);
   procedure beginclientrectchanged;
   procedure endclientrectchanged;
   property mdistate: mdistatety read fmdistate write setmdistate;
      //istatfile
   procedure dostatread(const reader: tstatreader);
   procedure dostatwrite(const writer: tstatwriter; const bounds: prectty = nil);
   procedure statreading;
   procedure statread;
   function getdockcaption: msestring;
   function getfloatcaption: msestring;
   function getitems: widgetarty; //reference count = 1
   function getwidget: twidget;
   function activewidget: twidget; //focused child or active tab
   function close: boolean; //simulates mr_windowclosed for owner
   function closeactivewidget: boolean;
                   //simulates mr_windowclosed for active widget, true if ok
  published
   property dockhandle: tdockhandle read fdockhandle write setdockhandle;
   property splitter_size: integer read fsplitter_size write setsplitter_size default defaultsplittersize;
   property splitter_grip: stockbitmapty read fsplitter_grip
                        write setsplitter_setgrip default defaultsplittergrip;
   property splitter_color: colorty read fsplitter_color
                        write setsplitter_color default defaultsplittercolor;
   property splitter_colorgrip: colorty read fsplitter_colorgrip
                        write setsplitter_colorgrip default defaultsplittercolorgrip;
   property tab_options: tabbaroptionsty read ftab_options write settab_options 
                                   default defaulttaboptions;
   property tab_frame: tframecomp read ftab_frame write settab_frame;
   property tab_face: tfacecomp read ftab_face write settab_face;
   property tab_color: colorty read ftab_color write settab_color default cl_default;
   property tab_colortab: colorty read ftab_colortab 
                        write settab_colortab default cl_transparent;
   property tab_coloractivetab: colorty read ftab_coloractivetab 
                        write settab_coloractivetab default cl_active;
   property tab_facetab: tfacecomp read ftab_facetab write settab_facetab;
   property tab_faceactivetab: tfacecomp read ftab_faceactivetab 
                                                 write settab_faceactivetab;
   property tab_size: integer read ftab_size write settab_size;
   property tab_sizemin: integer read ftab_sizemin write settab_sizemin
                            default defaulttabsizemin;
   property tab_sizemax: integer read ftab_sizemax write settab_sizemax
                            default defaulttabsizemax;
   
   property caption: msestring read fcaption write setcaption;
   property optionsdock: optionsdockty read foptionsdock write setoptionsdock
                      default defaultoptionsdock;
   property bandgap: integer read fbandgap write setbandgap default 0;
   
   property oncalclayout: docklayouteventty read foncalclayout write foncalclayout;
   property onlayoutchanged: dockcontrollereventty read fonlayoutchanged 
                                                       write fonlayoutchanged;
   property onfloat: notifyeventty read fonfloat write fonfloat;
   property ondock: notifyeventty read fondock write fondock;
   property onchilddock: widgeteventty read fonchilddock write fonchilddock;
   property onchildfloat: widgeteventty read fonchildfloat write fonchildfloat;
   property oncheckdock: checkdockeventty read foncheckdock write foncheckdock;
   property onmdistatechanged: mdistatechangedeventty read fonmdistatechanged 
                              write fonmdistatechanged;
 end;

 idocktarget = interface(inullinterface)['{1A50A4E4-5B46-4C7C-A992-51EFEA1202B8}']
  function getdockcontroller: tdockcontroller;
 end;

type
 gripoptionty = (go_closebutton,go_minimizebutton,go_normalizebutton,
                 go_maximizebutton,
                 go_fixsizebutton,go_topbutton,go_backgroundbutton,
                 go_horz,go_vert,go_opposite,go_showsplitcaption,
                 go_showfloatcaption);
 gripoptionsty = set of gripoptionty;

const
 defaultgripoptions = [go_closebutton];

type

 tgripframe = class(tcaptionframe,iobjectpicker,iface)
  private
   fgrip_pos: captionposty;
   fgrip_color: colorty;
   fgrip_size: integer;
   fgrip_grip: stockbitmapty;
   fgrip_options: gripoptionsty;
   fgrip_colorglyph: colorty;
   fcontroller: tdockcontroller;
   fgrip_coloractive: colorty;
   fobjectpicker: tobjectpicker;
   fgrip_colorbutton: colorty;
   fgrip_colorbuttonactive: colorty;
   fgrip_colorglyphactive: colorty;
   fgrip_face: tface;
   procedure setgrip_color(const avalue: colorty);
   procedure setgrip_grip(const avalue: stockbitmapty);
   procedure setgrip_size(const avalue: integer);
   procedure setgrip_options(avalue: gripoptionsty);
   procedure setgrip_colorglyph(const avalue: colorty);
   function getbuttonrects(const index: dockbuttonrectty): rectty;
   procedure setgrip_coloractive(const avalue: colorty);
   procedure setgrip_colorbutton(const avalue: colorty);
   procedure setgrip_colorbuttonactive(const avalue: colorty);
   procedure setgrip_colorglyphactive(const avalue: colorty);
   function getgrip_face: tface;
   procedure setgrip_face(const avalue: tface);
   procedure createface;
  protected
   frects: array[dbr_first..dbr_last] of rectty;
   fgriprect: rectty;
   procedure updatewidgetstate; override;   
   procedure updaterects; override;
   procedure updatestate; override;
   procedure getpaintframe(var frame: framety); override;
   function calcsizingrect(const akind: sizingkindty;
                                const offset: pointty): rectty;
   //iface
   function getclientrect: rectty;
   procedure invalidate;
   function translatecolor(const acolor: colorty): colorty;
   procedure setlinkedvar(const source: tmsecomponent; var dest: tmsecomponent;
              const linkintf: iobjectlink = nil);
   function getcomponentstate: tcomponentstate;
   procedure widgetregioninvalid;
   //iobjectpicker
   function getwidget: twidget;
   function getcursorshape(const pos: pointty; const shiftstate: shiftstatesty; 
                                     var shape: cursorshapety): boolean;
                   //true if found
   procedure getpickobjects(const rect: rectty;  const shiftstate: shiftstatesty;
                                     var objects: integerarty);
   procedure beginpickmove(const objects: integerarty);
   procedure endpickmove(const pos,offset: pointty; const objects: integerarty);
   procedure paintxorpic(const canvas: tcanvas; const pos,offset: pointty;
                 const objects: integerarty);
   procedure drawgripbutton(const acanvas: tcanvas; const kind: dockbuttonrectty;
                    const arect: rectty; 
                    const acolorglyph,acolorbutton: colorty); virtual;
  public
   constructor create(const intf: icaptionframe;
                                     const acontroller: tdockcontroller);
   destructor destroy; override;
   procedure updatemousestate(const sender: twidget;
                                  const info: mouseeventinfoty); override;
   procedure mouseevent(var info: mouseeventinfoty);
   procedure paintoverlay(const canvas: tcanvas; const arect: rectty); override;
   property buttonrects[const index:  dockbuttonrectty]: rectty 
                                                 read getbuttonrects;
   function getminimizedsize(out apos: captionposty): sizety;
   function griprect: rectty; //origin = pos
  published
   property grip_size: integer read fgrip_size write setgrip_size stored true;
                               //for optionalclass
   property grip_grip: stockbitmapty read fgrip_grip write setgrip_grip
                                                       default defaultgripgrip;
   property grip_color: colorty read fgrip_color write setgrip_color
                                                       default defaultgripcolor;
   property grip_coloractive: colorty read fgrip_coloractive 
                      write setgrip_coloractive default defaultgripcoloractive;
   property grip_colorglyph: colorty read fgrip_colorglyph write
                 setgrip_colorglyph default cl_glyph;
   property grip_colorglyphactive: colorty read fgrip_colorglyphactive write
                 setgrip_colorglyphactive default cl_glyph;
   property grip_colorbutton: colorty read fgrip_colorbutton write
                 setgrip_colorbutton default cl_transparent;
   property grip_colorbuttonactive: colorty read fgrip_colorbuttonactive write
                 setgrip_colorbuttonactive default cl_transparent;
   property grip_options: gripoptionsty read fgrip_options write setgrip_options
                                                     default defaultgripoptions;
   property grip_face: tface read getgrip_face write setgrip_face;
 end;

 tdockpanel = class(tscalingwidget,idockcontroller,idocktarget,istatfile)
  private
   fdragdock: tdockcontroller;
   foptionswindow: windowoptionsty;
   fstatfile: tstatfile;
   fstatvarname: string;
   ficon: tmaskedbitmap;
   procedure setdragdock(const Value: tdockcontroller);
   function getframe: tgripframe;
   procedure setframe(const Value: tgripframe);
   procedure setstatfile(const Value: tstatfile);
   procedure seticon(const avalue: tmaskedbitmap);
   procedure iconchanged(const sender: tobject);
  protected
   procedure mouseevent(var info: mouseeventinfoty); override;
   procedure updatewindowinfo(var info: windowinfoty); override;
   procedure internalcreateframe; override;
   //idockcontroller
   function checkdock(var info: draginfoty): boolean;
   function getbuttonrects(const index: dockbuttonrectty): rectty;
   function getplacementrect: rectty;
   function getminimizedsize(out apos: captionposty): sizety;
   function getcaption: msestring;
   //istatfile
   procedure dostatread(const reader: tstatreader);
   procedure dostatwrite(const writer: tstatwriter);
   procedure statreading;
   procedure statread;
   function getstatvarname: msestring;
   procedure clientrectchanged; override;
   procedure widgetregionchanged(const sender: twidget); override;
   procedure setparentwidget(const Value: twidget); override;
   procedure dopaint(const acanvas: tcanvas); override;
   procedure doactivate; override;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   procedure dragevent(var info: draginfoty); override;
   function getdockcontroller: tdockcontroller;
  published
   property dragdock: tdockcontroller read fdragdock write setdragdock;
   property optionswindow: windowoptionsty read foptionswindow write foptionswindow default [];
   property frame: tgripframe read getframe write setframe;
   property statfile: tstatfile read fstatfile write setstatfile;
   property statvarname: string read fstatvarname write fstatvarname;
   property icon: tmaskedbitmap read ficon write seticon;
 end;

implementation
uses
 msedatalist,mseshapes,sysutils,msebits,msetabs,mseguiintf,msedrawtext,
 mseforms,msestream;

type
 twidget1 = class(twidget);
 twindow1 = class(twindow);
 tcustomframe1 = class(tcustomframe);
 tcustomtabwidget1 = class(tcustomtabwidget);
 tface1 = class(tface);

const
 useroptionsmask: optionsdockty = [od_fixsize,od_top,od_background];

type
 tdocktabwidget = class(ttabwidget)
  private
   fcontroller: tdockcontroller;
  protected
   procedure doclosepage(const sender: tobject); override;
   procedure dopageremoved(const apage: twidget);  override;
   procedure updateoptions;
  public
   constructor create(const acontroller: tdockcontroller; const aparent: twidget);
                    reintroduce;
   destructor destroy; override;
 end;

 tdocktabpage = class(ttabpage,idocktarget)
  private
   fcontroller: tdockcontroller;
   ftarget: twidget;
   ftargetanchors: anchorsty;
   //idocktarget
   function getdockcontroller: tdockcontroller;
  protected
   procedure unregisterchildwidget(const child: twidget); override;
   procedure widgetregionchanged(const sender: twidget); override;
  public
   constructor create(const atabwidget: tdocktabwidget; const awidget: twidget);
              reintroduce;
 end;

{ twidgetdragobject }

constructor twidgetdragobject.create(const asender: twidget; var instance: tdragobject;
                     const apickpos: pointty);
begin
 inherited create(asender,instance,apickpos);
end;

function twidgetdragobject.getwidget: twidget;
begin
 result:= twidget(fsender);
end;

{ tdockdragobject }

constructor tdockdragobject.create(const adock: tdockcontroller;
            const asender: twidget; var instance: tdragobject;
            const apickpos: pointty);
begin
 fdock:= adock;
 inherited create(asender,instance,apickpos);
end;

destructor tdockdragobject.destroy;
begin
 if fcheckeddockcontroller <> nil then begin
  fcheckeddockcontroller.fasplitdir:= sd_none;
 end;
 inherited;
end;

procedure tdockdragobject.drawxorpic;
begin
 if fxorwidget <> nil then begin
  with fxorwidget.getcanvas(org_screen) do begin
   drawxorframe(fxorrect,-3,stockobjects.bitmaps[stb_dens50]);
  end;
 end;
end;

procedure tdockdragobject.refused(const apos: pointty);
begin
 inherited;
 drawxorpic;
 fxorwidget:= nil;
 fdock.refused(apos);
end;

procedure tdockdragobject.setxorwidget(const awidget: twidget; const screenrect: rectty);
begin
 if (awidget <> fxorwidget) or not rectisequal(fxorrect,screenrect) then begin
  drawxorpic;
  fxorwidget:= awidget;
  fxorrect:= screenrect;
  drawxorpic;
 end;
end;

{ tdocktabwidget }

constructor tdocktabwidget.create(const acontroller: tdockcontroller;
                     const aparent: twidget);
begin
 fcontroller:= acontroller;
 inherited create(nil);
 parentwidget:= aparent;
 updateoptions;
 synctofontheight;
end;

procedure tdocktabwidget.updateoptions;
begin
 with fcontroller do begin
  self.options:= ftab_options;
  self.tab_color:= ftab_color;
  self.tab_colortab:= ftab_colortab;
  self.tab_coloractivetab:= ftab_coloractivetab;
  self.tab_size:= ftab_size;
  self.tab_sizemin:= ftab_sizemin;
  self.tab_sizemax:= ftab_sizemax;
  if ftab_frame <> nil then begin
   self.tab_frame:= tstepboxframe1(1);
   self.tab_frame.assign(ftab_frame);
  end
  else begin
   self.tab_frame:= nil;
  end;
  if ftab_face <> nil then begin
   self.tab_face:= tface(1);
   self.tab_face.assign(ftab_face);
  end
  else begin
   self.tab_face:= nil;
  end;
  if ftab_facetab <> nil then begin
   self.tab_facetab:= tface(1);
   self.tab_facetab.assign(ftab_facetab);
  end
  else begin
   self.tab_facetab:= nil;
  end;
  if ftab_faceactivetab <> nil then begin
   self.tab_faceactivetab:= tface(1);
   self.tab_faceactivetab.assign(ftab_faceactivetab);
  end
  else begin
   self.tab_faceactivetab:= nil;
  end;
 end;
end;

destructor tdocktabwidget.destroy;
begin
 if fcontroller.ftabwidget = self then begin
  fcontroller.ftabwidget:= nil;
 end;
 inherited;
end;

procedure tdocktabwidget.doclosepage(const sender: tobject);
begin
 fcontroller.doclose(tdocktabpage(items[fpopuptab]).ftarget);
end;

procedure tdocktabwidget.dopageremoved(const apage: twidget);
begin
 inherited;
 if (count = 0) and not application.terminated then begin
  fcontroller.ftabwidget:= nil;
  fcontroller.fsplitterrects:= nil;
  release;
 end;
 fcontroller.dolayoutchanged;
end;

{ tdocktabpage }

constructor tdocktabpage.create(const atabwidget: tdocktabwidget;
                        const awidget: twidget);
var
 intf1: idocktarget;
begin
 fcontroller:= atabwidget.fcontroller;
 inherited create(nil);
 optionswidget:= optionswidget - [ow_destroywidgets];
 ftarget:= awidget;
 ftargetanchors:= awidget.anchors;
 if awidget.getcorbainterface(typeinfo(idocktarget),intf1) then begin
  caption:= intf1.getdockcontroller.getdockcaption;
 end
 else begin
  caption:= 'Page '+inttostr(atabwidget.count);
 end;
 awidget.anchors:= [];
 parentwidget:= atabwidget;
 insertwidget(awidget,paintpos);
end;

procedure tdocktabpage.unregisterchildwidget(const child: twidget);
begin
 inherited;
 if (child = ftarget) then begin
  ftarget:= nil;
  if not application.terminated then begin
   visible:= false;
   parentwidget:= nil;
   release;
  end;
 end;
end;

procedure tdocktabpage.widgetregionchanged(const sender: twidget);
begin
 inherited;
 if (sender <> nil) and (sender = ftarget) and not sender.visible and
  (fparentwidget <> nil) and (fparentwidget.parentwidget <> nil) and
            not (csdestroying in sender.componentstate) then begin
   sender.parentwidget:= fparentwidget.parentwidget;  //remove page
 end;
end;

function tdocktabpage.getdockcontroller: tdockcontroller;
begin
 result:= fcontroller;
end;

{ tdockcontroller }

constructor tdockcontroller.create(aintf: idockcontroller);
begin
 fr:= @rectaccessx;
 fw:= @widgetaccessx;
 fsizeindex:= -1;
 foptionsdock:= defaultoptionsdock;
 fuseroptions:= defaultoptionsdock;
 fsplitter_grip:= defaultsplittergrip;
 fsplitter_color:= defaultsplittercolor;
 fsplitter_colorgrip:= defaultsplittercolorgrip;
 fsplitter_size:= defaultsplittersize;
 ftab_options:= defaulttaboptions;
 ftab_color:= cl_default;
 ftab_colortab:= cl_transparent;
 ftab_coloractivetab:= cl_active;
 ftab_sizemin:= defaulttabsizemin;
 ftab_sizemax:= defaulttabsizemax;
 inherited create(aintf);
end;

destructor tdockcontroller.destroy;
begin
 freeandnil(ftabwidget);
 inherited;
end;

function tdockcontroller.checksplit(const awidgets: widgetarty;
              out propsize,varsize,fixsize,fixcount: integer;
              out isprop,isfix: booleanarty;
              const fixedareprop: boolean): widgetarty;
                 //calculate order and total widths/heights of elements
var
 ar1: widgetarty;
 int1,int2: integer;
 intf1: idocktarget;
 opt1: optionsdockty;
 fixend: boolean;
 banded: boolean;
 needspropref: boolean;
 dcont1: tdockcontroller;
 
begin
 checkdirection;
 banded:= (od_banded in foptionsdock) and (fsplitdir in [sd_x,sd_y]);
 if awidgets = nil then begin
  if (fsplitdir = sd_x) then begin
   ar1:= fintf.getwidget.getsortxchildren(banded);
  end
  else begin
   if (fsplitdir = sd_y) or (fsplitdir = sd_tabed) then begin
    ar1:= fintf.getwidget.getsortychildren(banded);
   end
   else begin
    ar1:= nil;
   end;
  end;
 end
 else begin
  if fsplitdir = sd_tabed then begin
   ar1:= nil;
  end
  else begin
   ar1:= awidgets;
  end;
 end;
 setlength(result,length(ar1));
 setlength(isprop,length(ar1));
 setlength(isfix,length(ar1));
 int2:= 0;
 propsize:= 0;
 varsize:= 0;
 fixsize:= 0;
 fixcount:= 0;
 fixend:= foptionsdock * [od_nofit] <> [];
 needspropref:= false;
 for int1:= 0 to high(ar1) do begin
  with twidget1(ar1[int1]) do begin
   if not (ow_noautosizing in foptionswidget) and visible then begin
    result[int2]:= ar1[int1];
    if fixend then begin
     isfix[int2]:= true;
     inc(fixcount);
    end
    else begin
     if ar1[int1].getcorbainterface(typeinfo(idocktarget),intf1) then begin
      dcont1:= intf1.getdockcontroller;
      needspropref:= needspropref or not (dos_proprefvalid in dcont1.fdockstate);
      include(dcont1.fdockstate,dos_proprefvalid);
      opt1:= dcont1.foptionsdock;
      if not fixedareprop and (od_fixsize in opt1) then begin
       isfix[int2]:= true;
       inc(fixcount);
      end;
      if (od_propsize in opt1) and not (od_fixsize in opt1) or 
                             fixedareprop and (od_fixsize in opt1) then begin
       isprop[int2]:= true;
       if fsplitdir = sd_x then begin
        inc(propsize,ar1[int1].bounds_cx);
       end
       else begin
        inc(propsize,ar1[int1].bounds_cy);
       end;
      end
     end;
    end;
    if not isprop[int2] then begin
     if fsplitdir = sd_x then begin
      inc(fixsize,ar1[int1].bounds_cx);
      if not isfix[int2] then begin
       inc(varsize,ar1[int1].bounds_cx);
      end;
     end
     else begin
      inc(fixsize,ar1[int1].bounds_cy);
      if not isfix[int2] then begin
       inc(varsize,ar1[int1].bounds_cy);
      end;
     end;
    end;
    inc(int2);
   end;
  end;
 end;
 if needspropref then begin
  updaterefsize;
 end;
 setlength(result,int2);
 setlength(isprop,int2);
 setlength(isfix,int2);
end;

function tdockcontroller.checksplit(out propsize,fixsize: integer;
                out isprop,isfix: booleanarty; const fixedareprop: boolean): widgetarty;
var
 int1,int2: integer;
begin
 result:= checksplit(nil,propsize,int1,fixsize,int2,isprop,isfix,fixedareprop);
end;

function tdockcontroller.checksplit: widgetarty;
var
 ar1,ar2: booleanarty;
 int1,int2,int3,int4: integer;
begin
 if ftabwidget <> nil then begin
  setlength(result,tdocktabwidget(ftabwidget).count);
  int2:= 0;
  for int1:= 0 to high(result) do begin
   result[int2]:= tdocktabpage(tdocktabwidget(ftabwidget)[int1]).ftarget;
   if result[int2] <> nil then begin
    inc(int2);
   end;
  end;
  setlength(result,int2);
 end
 else begin
  result:= checksplit(nil,int1,int2,int3,int4,ar1,ar2,false);
 end;
end;

procedure tdockcontroller.dopaint(const acanvas: tcanvas); //canvasorigin = container.clientpos;
var
 int1: integer;
 color1: colorty;
 brush1: tsimplebitmap;
begin
 if fsplitterrects <> nil then begin
  if fsplitter_color <> cl_none then begin
   for int1:= 0 to high(fsplitterrects) do begin
    acanvas.fillrect(fsplitterrects[int1],fsplitter_color);
   end;
  end;
  if fsplitter_grip <> stb_none then begin
   with acanvas do begin
    color1:= color;
    brush1:= brush;
    brush:= stockobjects.bitmaps[fsplitter_grip];
    color:= fsplitter_colorgrip;
    for int1:= 0 to high(fsplitterrects) do begin
     fillrect(fsplitterrects[int1],cl_brushcanvas);
    end;
    brush:= brush1;
    color:= color1;
   end;
  end;
 end;
end;

procedure tdockcontroller.doactivate;
var
 size1: sizety;
 intf1: idocktarget;
 widget1: twidget;
begin
 size1:= fintf.getwidget.size;
 if (size1.cx <= 0) or (size1.cy <= 0) then begin
  widget1:= fintf.getwidget.parentwidget;
  if (widget1 <> nil) and widget1.getcorbainterface(typeinfo(idocktarget),intf1) then begin
   intf1.getdockcontroller.calclayout(nil,false);
  end;
 end;
end;

procedure tdockcontroller.updategrip(const asplitdir: splitdirty;
                       const awidget: twidget);
var
 frame1: tcustomframe;
 grippos1: captionposty;
begin
 frame1:= twidget1(awidget).fframe;
 if frame1 is tgripframe then begin
  with tgripframe(frame1) do begin
   grippos1:= fgrip_pos;
   if fgrip_options * [go_horz,go_vert] = [] then begin
    if asplitdir = sd_x then begin
     if go_opposite in fgrip_options then begin
      fgrip_pos:= cp_bottom;
     end
     else begin
      fgrip_pos:= cp_top;
     end;
    end
    else begin
     if (asplitdir = sd_y) or (asplitdir = sd_tabed) or 
                                    (asplitdir = sd_none) then begin
      if go_opposite in fgrip_options then begin
       fgrip_pos:= cp_left;
      end
      else begin
       fgrip_pos:= cp_right;
      end;
     end;
    end;
   end;
   if grippos1 <> fgrip_pos then begin
    internalupdatestate;
   end;
  end;
 end;
end;

procedure tdockcontroller.updatesplitterrects(const awidgets: widgetarty);
var
 fixend: boolean;

 procedure calcsplitters;
 var
  rect1: rectty;
  int1,int2: integer;
  bandpos: integer;
 begin
  fr^.setsize(rect1,fsplitter_size);
  bandpos:= fbandstart;
  for int2:= 0 to high(fbands) do begin
   with fbands[int2] do begin
    fr^.setopos(rect1,bandpos);
    fr^.setosize(rect1,size);
    for int1:= first to last do begin
     fr^.setpos(rect1,fw^.stop(awidgets[int1]));
     fsplitterrects[int1]:= rect1;
    end;
    bandpos:= bandpos + size + fbandgap;
   end;
  end;
 end;

var
 po1: pointty;
 int1: integer;
 sd1: splitdirty;
begin
 sd1:= fsplitdir;
 if nofit then begin
  if sd1 = sd_x then begin
   sd1:= sd_y;
  end
  else begin
   sd1:= sd_x;
  end;
 end;
 for int1:= 0 to high(awidgets) do begin
  updategrip(sd1,awidgets[int1]);
 end;
 if (high(awidgets) >= 0) and (fsplitter_size > 0) and 
     ((fsplitter_color <> cl_none) or (fsplitter_grip <> stb_none)) then begin
  fixend:= foptionsdock * [od_nofit] <> [];
  setlength(fsplitterrects,length(awidgets));
  calcsplitters;
  if not fixend then begin
   setlength(fsplitterrects,high(fsplitterrects));
  end;
  po1:= fintf.getwidget.container.clientwidgetpos;
  for int1:= 0 to high(fsplitterrects) do begin
   subpoint1(fsplitterrects[int1].pos,po1); //clientorg
  end;
 end
 else begin
  fsplitterrects:= nil;
 end;
 fintf.getwidget.container.invalidate;
end;

procedure tdockcontroller.setoptionsdock(const avalue: optionsdockty);
const
 mask1: optionsdockty = [od_top,od_background];
 mask2: optionsdockty = [od_alignbegin,od_aligncenter,od_alignend];
  
var
 splitdirbefore: splitdirty;
 intf1: idocktarget;
 cont1: tdockcontroller;
 int1: integer;
 val1,val2,val3: optionsdockty;
 bo1: boolean;
begin
 if foptionsdock <> avalue then begin
  bo1:= od_fixsize in foptionsdock;
  splitdirbefore:= fsplitdir;
  val1:= optionsdockty(
       setsinglebit({$ifdef FPC}longword{$else}longword{$endif}(avalue),
       {$ifdef FPC}longword{$else}longword{$endif}(foptionsdock),
                          {$ifdef FPC}longword{$else}longword{$endif}(mask1)));
  val2:= optionsdockty(
       setsinglebit({$ifdef FPC}longword{$else}longword{$endif}(avalue),
       {$ifdef FPC}longword{$else}longword{$endif}(foptionsdock),
                          {$ifdef FPC}longword{$else}longword{$endif}(mask2)));
  foptionsdock:= (avalue - (mask1+mask2{+mask3})) + val1*mask1 + val2*mask2 {+ 
                                 val3*mask3};
  if not (od_nofit in foptionsdock) then begin
   exclude(foptionsdock,od_banded);
  end;
  if (od_banded in foptionsdock) and (foptionsdock * mask2 = []) then begin
   include(foptionsdock,od_aligncenter);
  end;
  if bo1 xor (od_fixsize in foptionsdock) then begin
   exclude(fdockstate,dos_proprefvalid);
  end;
  
  fuseroptions:= foptionsdock;
  if not (od_splitvert in avalue) and (fsplitdir = sd_x) then begin
   fsplitdir:= sd_none;
  end;
  if not (od_splithorz in avalue) and (fsplitdir = sd_y) then begin
   fsplitdir:= sd_none;
  end;
  if not (od_tabed in avalue) and (fsplitdir = sd_tabed) then begin
   fsplitdir:= sd_none;
  end;
  if (fsplitdir = sd_none) then begin
   if od_splithorz in avalue then begin
    fsplitdir:= sd_y;
   end
   else begin
    if od_splitvert in avalue then begin
     fsplitdir:= sd_x;
    end
    else begin
     if od_tabed in avalue then begin
      fsplitdir:= sd_tabed;
     end;
    end;
   end;
  end;
  with fintf.getwidget do begin
   if od_top in foptionsdock then begin
    optionswidget:= optionswidget + [ow_top];
   end
   else begin
    optionswidget:= optionswidget - [ow_top];
   end;
   if od_background in foptionsdock then begin
    optionswidget:= optionswidget + [ow_background];
   end
   else begin
    optionswidget:= optionswidget - [ow_background];
   end;
   if (splitdirbefore <> fsplitdir) and 
               not (csloading in componentstate) then begin
    calclayout(nil,false);
    with container do begin
     if fsplitdir = sd_none then begin
      for int1:= 0 to widgetcount - 1 do begin
       with widgets[int1] do begin
        if getcorbainterface(typeinfo(idocktarget),intf1) then begin
         cont1:= intf1.getdockcontroller;
         cont1.fmdistate:= mds_normal;
         anchors:= [an_left,an_top];
         widgetrect:= cont1.fnormalrect;
        end;
       end;
      end;
     end;
    end;
    invalidate;
   end;
  end;
 end;
end;

procedure tdockcontroller.setuseroptions(const avalue: optionsdockty);
begin
 optionsdock:= optionsdockty(replacebits(
           {$ifdef FPC}longword{$else}longword{$endif}(avalue),
           {$ifdef FPC}longword{$else}longword{$endif}(foptionsdock),
           {$ifdef FPC}longword{$else}longword{$endif}(useroptionsmask)));
end;

procedure tdockcontroller.splitterchanged;
begin
 if not (csloading in fintf.getwidget.ComponentState) then begin
  updatesplitterrects(checksplit);
 end;
end;

procedure tdockcontroller.checkdirection;
begin
 if fsplitdir = sd_y then begin
  fr:= @rectaccessy;
  fw:= @widgetaccessy;
 end
 else begin
  fr:= @rectaccessx;
  fw:= @widgetaccessx;
 end;
end;

procedure tdockcontroller.sizechanged(force: boolean = false;
                                          scalefixedalso: boolean = false;
                                          const awidgets: widgetarty = nil);
var
 ar1: widgetarty;
 ar2: realarty;
 prop,fix: booleanarty;
 fixsize: integer;
 propsize: integer;
 banded: boolean;
 opt1: optionsdockty;
 
 procedure calcsize;
 var
  int1: integer;
  rea1,rea2: real;
 begin 
  int1:= fr^.size(fplacementrect) - high(ar1) * fsplitter_size - fixsize;
  if int1 < 0 then begin
   int1:= 0;
  end;
  if (frefsize > 0) and (high(ar1) = high(fsizes)) then begin
   rea1:= int1 / frefsize;
   for int1:= 0 to high(ar1) do begin
    if prop[int1] then begin
     ar2[int1]:= fsizes[int1] * rea1;
    end
    else begin
     ar2[int1]:= fw^.size(ar1[int1]);
    end;
   end;
  end
  else begin
   if (propsize = 0) then begin
    rea1:= 1;
   end
   else begin
    rea1:= int1/propsize;
   end;
   for int1:= 0 to high(ar1) do begin
    ar2[int1]:= fw^.size(ar1[int1]);
    if prop[int1] then begin
     ar2[int1]:= ar2[int1] * rea1;
    end;
   end;
  end;
  rea2:= 0;
  for int1:= 0 to high(ar2) do begin
   if (fw^.max(ar1[int1]) <> 0) and (ar2[int1] > fw^.max(ar1[int1])) then begin
    ar2[int1]:= fw^.max(ar1[int1]);
   end;
   if ar2[int1] < fw^.min(ar1[int1]) then begin
    ar2[int1]:= fw^.min(ar1[int1]);
   end;
   rea2:= rea2 + ar2[int1]; //total size
  end;
  rea1:= fr^.size(fplacementrect);
  if not nofit then begin
         //adjust sizes for fit      
   rea2:= rea1 - (rea2 + high(ar2) * fsplitter_size);
               //delta
   if rea2 < 0 then begin
    for int1:= high(ar2) downto 0 do begin
     if not (fix[int1] and not scalefixedalso) and not prop[int1] then begin
      rea1:= fw^.min(ar1[int1]);
      ar2[int1]:= ar2[int1] + rea2;
      if ar2[int1] < rea1 then begin
       rea2:= ar2[int1] - rea1;
       ar2[int1]:= rea1;
      end
      else begin
       break;
      end;
     end;
    end;
   end
   else begin
    for int1:= high(ar2) downto 0 do begin
     if not fix[int1] and not prop[int1] then begin
      rea1:= fw^.max(ar1[int1]);
      ar2[int1]:= ar2[int1] + rea2;
      if (ar2[int1] > rea1) and (rea1 > 0) then begin
       rea2:= ar2[int1] - rea1;
       ar2[int1]:= rea1;
      end
      else begin
       break;
      end;
     end;
    end;
   end;
  end;
  rea2:= fr^.pos(fplacementrect);
  ar2[0]:= ar2[0] + rea2 + fsplitter_size;
  for int1:= 1 to high(ar1) do begin        //calc pos vector
   ar2[int1]:= ar2[int1-1] + fsplitter_size + ar2[int1];
  end;
 end; //calcsize

var
 minsize1: integer;
 
 procedure calcpos;
 var  
  bandindex: integer;
  
  procedure calcbandheight(const aindex: integer);
  var
   int2,int3,int4: integer;
  begin
   setlength(fbands,high(fbands)+2);
   int3:= 0;
   for int2:= bandindex to aindex - 1 do begin
    int4:= fw^.osize(ar1[int2]);
    if int4 > int3 then begin
     int3:= int4;       //find biggest widget
    end;
   end;
   with fbands[high(fbands)] do begin 
    first:= bandindex;
    last:= aindex-1;
    size:= int3;
   end;
   bandindex:= aindex;
  end; //calcbandheight

 var
  rea1,rea2: real;
  int1: integer;
  rect1: prectty;
  rect2: rectty;
  ar3: rectarty;
  int2: integer;
  bandpos: integer;
  
  procedure clipwidget;
  var
   int1: integer;
  begin
   int1:= fr^.stop(fplacementrect) - fsplitter_size;
   if fr^.stop(rect1^) > int1 then begin
    fr^.setstop(rect1^,int1);
   end;
  end; //clipwidget

 begin
  rea2:= fr^.pos(fplacementrect);
  if not nofit then begin
   setlength(fbands,1);
   with fbands[0] do begin
    first:= 0;
    last:= high(ar1);
    size:= fr^.osize(fplacementrect);
   end;
   rect2:= fplacementrect;
   for int1:= 0 to high(ar1) do begin
    fr^.setpos(rect2,round(rea2));
    fr^.setsize(rect2,round(ar2[int1] - rea2) - fsplitter_size);
    ar1[int1].widgetrect:= rect2;
    rea2:= rea2 + fw^.size(ar1[int1]) + fsplitter_size;
   end;
   minsize1:= fr^.stop(rect2) - fr^.pos(fplacementrect);
  end
  else begin
   setlength(ar3,length(ar1));
   bandindex:= 0;
   rea1:= 0;
   int2:= 0;
   for int1:= 0 to high(ar1) do begin
    rect1:= @ar3[int1];         //set size
    rect1^:= fplacementrect;
    fr^.setpos(rect1^,round(rea2));
    fr^.setsize(rect1^,round(ar2[int1] - rea2 - rea1) - fsplitter_size);
    if banded and 
      (fr^.stop(rect1^) + fsplitter_size > fr^.stop(fplacementrect)) then begin
     if int1 > int2 then begin //next band
      calcbandheight(int1);
      int2:= int1;       // minimal one widget in band
      fr^.setpos(rect1^,fr^.pos(fplacementrect)); //restart
      clipwidget;
      rea1:= rea1 + rea2;
      rea2:= fr^.pos(rect1^);
      rea1:= rea1 - rea2;
     end
     else begin  
      clipwidget;
     end;
    end;
    rea2:= rea2 + fr^.size(rect1^) + fsplitter_size;
   end;
   calcbandheight(length(ar1));
   if not banded then begin
    fbands[0].size:= fr^.osize(fplacementrect);
   end;
   bandpos:= fbandstart;
   for int2:= 0 to high(fbands) do begin
    with fbands[int2] do begin
     for int1:= first to last do begin
      rect1:= @ar3[int1];                      //set ortho size
      fr^.setosize(rect1^,fw^.osize(ar1[int1]));
      if opt1 = [od_aligncenter] then begin
       fr^.setopos(rect1^,
                bandpos + (size-fr^.osize(rect1^)) div 2);
      end
      else begin
       if opt1 = [od_alignend] then begin
        fr^.setopos(rect1^,bandpos + (size-fr^.osize(rect1^)));
       end
       else begin
        if opt1 = [od_alignbegin] then begin
         fr^.setopos(rect1^,bandpos);
        end
        else begin
         fr^.setopos(rect1^,bandpos + fr^.osize(rect1^));
        end;
       end;
      end; 
      ar1[int1].widgetrect:= rect1^;
     end;
     bandpos:= bandpos + size + fbandgap;
    end;
   end;
  end;
 end; //calcpos

var
 needsfixscale: boolean;
 hasparent1: boolean;
 
 procedure updateplacement;
 var
  rect1: rectty;
  widget1: twidget;
  int1: integer;
 begin
  widget1:= fintf.getwidget;
  rect1.pos:= fplacementrect.pos;
  rect1.size:= nullsize;         //update placementrect
  int1:= minsize1 - fr^.size(fplacementrect);
  if (int1 > 0) then begin       //extend placementrect
   if not scalefixedalso and 
              not (od_expandforfixsize in foptionsdock) then begin
    needsfixscale:= true;
   end
   else begin
    if hasparent1 then begin
     if not fw^.anchstop(widget1) then begin
      fw^.setsize(widget1,fw^.size(widget1)+int1); //extend size
     end
     else begin
      widget1.parentwidget.changeclientsize(fr^.makesize(int1,0));
     end;
    end;
   end;
  end
  else begin
   if not nofit then begin      
    fw^.setstop(ar1[high(ar1)],fr^.stop(fplacementrect));
   end;
  end;
 end;       
          
var
 int1,int2: integer;
 widget1: twidget;
 rea2: real;
 widget2: twidget;
 
begin
 widget2:= fintf.getwidget;
 hasparent1:= widget2.parentwidget <> nil;
 widget1:= widget2.container;
 checkdirection;
 if (widget1 <> nil) and 
        (widget1.ComponentState * [csloading,csdesigning] = []) then begin
  banded:= od_banded in foptionsdock;
  fplacementrect:= idockcontroller(fintf).getplacementrect;
  fbandstart:= fr^.opos(fplacementrect);
  if fsplitdir in [sd_x,sd_y] then begin
   ar1:= nil; //compiler warning
   if not sizeisequal(fsize,fplacementrect.size) or force then begin
    fbands:= nil;
    fsize:= fplacementrect.size;
    if fdockstate * [dos_updating1,dos_updating2,dos_updating4] <> [] then begin
     exclude(fdockstate,dos_layoutvalid);
    end
    else begin
     needsfixscale:= false;
     fdockstate:= fdockstate + [dos_layoutvalid,dos_updating2];
     try
      inc(frecalclevel);
      ar1:= checksplit(awidgets,propsize,int1,fixsize,int2,prop,fix,false);
      if high(ar1) >= 0 then begin
       setlength(ar2,length(ar1));
       if not (od_proportional in foptionsdock) then begin
        for int1:= 0 to high(prop) do begin
         prop[int1]:= false;
        end;
       end;
       minsize1:= 0;
       opt1:= foptionsdock * [od_alignbegin,od_aligncenter,od_alignend];
       if fsplitdir in [sd_x,sd_y] then begin
        calcsize;
        calcpos;
       end;
       if (opt1 = []) and not nofit then begin
        updateplacement;
       end;
      end;
     finally 
      fdockstate:= fdockstate - [dos_updating1,dos_updating2];
      if (not (dos_layoutvalid in fdockstate) or needsfixscale) and 
                        (frecalclevel < 4) then begin
       try
        sizechanged(force or needsfixscale,needsfixscale);
       finally
        dec(frecalclevel);
       end;
      end
      else begin
       dec(frecalclevel);
       updatesplitterrects(ar1);
      end;
     end;
    end;
   end;
  end
  else begin
   fbands:= nil;
   if ismdi then begin
    case fmdistate of
     mds_normal: begin
      fnormalrect:= widget2.widgetrect;
     end;
    end;
   end;  
  end;
 end;
end;

function tdockcontroller.getparentcontroller(out acontroller: tdockcontroller): boolean;
var
 widget1: twidget;
 intf1: idocktarget;
begin
 result:= false;
 acontroller:= nil;
 widget1:= fintf.getwidget.parentwidget;
 if widget1 <> nil then begin
  if widget1.getcorbainterface(typeinfo(idocktarget),intf1) then begin
   acontroller:= intf1.getdockcontroller;
   result:= true;
  end;
 end;
end;

procedure tdockcontroller.updaterefsize;
var
 int1: integer;
 ar1: widgetarty;
 ar2,ar3: booleanarty; 
begin
 if fsplitdir in [sd_x,sd_y] then begin
  ar1:= checksplit(frefsize,int1,ar2,ar3,false);
  setlength(fsizes,length(ar1));
  for int1:= 0 to high(ar1) do begin
   fsizes[int1]:= fw^.size(ar1[int1]);
  end;
 end
 else begin
  fsizes:= nil;
 end;
end;

procedure tdockcontroller.calclayout(const dragobject: tdockdragobject;
                                     const nonewplace: boolean);
var
 rect1,rect2: rectty;
 po1: pointty;
 ar1: widgetarty;
 int1,int2: integer;
 step,pos: real;
 container1: twidget1;
 widget1,widget2: twidget;
 index: integer;
 xorrect: rectty;
 intf1: idocktarget;
 propsize,varsize,fixsize,fixcount: integer;
 prop,fix: booleanarty;
 dirchanged: boolean;
 newwidget: boolean;
 controller1: tdockcontroller;
begin
 container1:= twidget1(fintf.getwidget.container);
 if container1.componentstate * [csdestroying,csdesigning] <> [] then begin
  exit;
 end;
 checkdirection;
 if (ftabwidget <> nil) and (fsplitdir = sd_tabed) then begin
  include(fdockstate,dos_updating5);
  int1:= 0;
  while int1 <= high(container1.fwidgets) do begin
   widget1:= container1.fwidgets[int1];
   if widget1.visible and (widget1 <> ftabwidget) then begin
    tdocktabpage.create(tdocktabwidget(ftabwidget),widget1);
   end
   else begin
    inc(int1);
   end;
  end;
  exclude(fdockstate,dos_updating5);
 end;
 ar1:= checksplit;
 if fasplitdir <> sd_none then begin
  dirchanged:= fsplitdir <> fasplitdir;
  fsplitdir:= fasplitdir;
  fasplitdir:= sd_none;
 end
 else begin
  dirchanged:= false;
 end;
 if (ar1 = nil) and (dragobject = nil) then begin
  if fsplitdir = sd_none then begin
   fsplitterrects:= nil;
  end;
  exit;
 end;
 rect1:= fplacementrect;//idockcontroller(fintf).getplacementrect;
 po1:= addpoint(pointty(rect1.size),rect1.pos); //lower right
 include(fdockstate,dos_updating1);
 if dragobject <> nil then begin
  with dragobject do begin
   widget1:= widget;
   index:= findex;
   xorrect:= fxorrect;
  end;
 end
 else begin
  widget1:= nil;
  index:= 0;
 end;
 if (ftabwidget <> nil) and (fsplitdir <> sd_tabed) then begin
  with tdocktabwidget(ftabwidget) do begin
   for int1:= count - 1 downto 0 do begin
    with tdocktabpage(items[int1]) do begin
     widget2:= ftarget;
     ftarget:= nil;
     include(fdockstate,dos_tabedending);
     widget2.anchors:= fanchors;
     widget2.parentwidget:= container1;
     exclude(fdockstate,dos_tabedending);
    end;
   end;
   freeandnil(ftabwidget);
  end;
 end;
 if (widget1 <> nil) then begin
  newwidget:= true;
  if (widget1.parentwidget = container1) then begin
   for int1:= 0 to high(ar1) do begin
    if ar1[int1] = widget1 then begin
     deleteitem(pointerarty(ar1),int1);
     newwidget:= false;
     break;
    end;
   end;
  end
  else begin
   widget2:= widget1.parentwidget;
   if fsplitdir <> sd_tabed then begin
    widget1.size:= xorrect.size;
    widget1.parentwidget:= container1;
   end;
   if getparentcontroller(controller1) then begin
    controller1.layoutchanged; //notify removing
   end;
   if (widget2 <> nil) and widget2.getcorbainterface(typeinfo(idocktarget),intf1) then begin
    intf1.getdockcontroller.layoutchanged; 
   end;
  end;
 end
 else begin
  newwidget:= false;
 end;
 if (length(ar1) > 0) or (widget1 <> nil) then begin
  step:= 0; //compiler warning
  if (fsplitdir <> sd_none) then begin
   if (widget1 <> nil) then begin
    if index > length(ar1) then begin
     index:= length(ar1);
    end;
    insertitem(pointerarty(ar1),index,widget1);
    if nofit then begin
//     if not newwidget then begin
      fr^.setosize(fsizingrect,fw^.osize(widget1));
                 //don't change height
//     end;
     widget1.widgetrect:= fsizingrect;
    end;
   end;
   checksplit(ar1,propsize,varsize,fixsize,fixcount,prop,fix,false);
   if dirchanged or (propsize = 0) and newwidget then begin
    for int1:= 0 to high(prop) do begin //split even
     prop[int1]:= true;
     fix[int1]:= false;
     propsize:= fixsize + propsize;
     fixsize:= 0;
     varsize:= 0;
     fixcount:= 0;
    end;
   end;
   if fixcount < length(ar1) then begin
    if fsplitdir = sd_y then begin
     step:= rect1.cy;
    end
    else begin
     step:= rect1.cx;
    end;
    step:= (step - fixsize + varsize - fsplitter_size * high(ar1)) / 
                                                (length(ar1) - fixcount);
    if step < 0 then begin
     step:= 0;
    end;
   end
   else begin
    step:= 0;
   end;
  end;
  case fsplitdir of
   sd_x,sd_y: begin
    if not nonewplace and not nofit then begin
     pos:= fr^.pos(rect1);
     for int1:= 0 to high(ar1) do begin
      fr^.setpos(rect1,round(pos));
      if prop[int1] then begin
       pos:= pos + step;
      end
      else begin
       pos:= pos + fw^.size(ar1[int1]);
      end;
      if int1 = high(ar1) then begin
       fr^.setsize(rect1,fr^.pt(po1) - fr^.pos(rect1));
      end
      else begin
       fr^.setsize(rect1,round(pos) - fr^.pos(rect1));
      end;
      ar1[int1].widgetrect:= rect1;
      pos:= pos + fsplitter_size;
     end;
    end;
   end;
   sd_tabed: begin
    include(fdockstate,dos_updating5);
    try
     if ftabwidget = nil then begin
      ftabwidget:= tdocktabwidget.create(self,container1);
      ftabwidget.anchors:= [];
      include(twidget1(ftabwidget).foptionswidget,ow_noautosizing);
     end;
     with tdocktabwidget(ftabwidget) do begin
      for int1:= 0 to high(ar1) do begin
       if (ar1[int1] <> ftabwidget) and
             ((ar1[int1].parentwidget = nil) or
              (ar1[int1].parentwidget.parentwidget <> ftabwidget)) then begin
        tdocktabpage.create(tdocktabwidget(ftabwidget),ar1[int1]);
       end;
      end;
     end;
    finally
     exclude(fdockstate,dos_updating5);
    end;
   end;
   else begin
    if widget1 <> nil then begin
     widget1.parentwidget:= container1;
     widget1.widgetrect:= translatewidgetrect(xorrect,nil,container1);
    end;
   end;
  end;
 end;
 exclude(fdockstate,dos_updating1);
 sizechanged(true,false,ar1);
 updatesplitterrects(ar1);
 widget1:= fintf.getwidget;
 if widget1.canevent(tmethod(foncalclayout)) then begin
  foncalclayout(widget1,ar1);
 end;
 dolayoutchanged;
end;

function tdockcontroller.nofit: boolean;
begin
 result:= (od_nofit in foptionsdock) and (fsplitdir in [sd_x,sd_y]);
end;

function tdockcontroller.beforedragevent(var info: draginfoty): boolean;

var
 widget1: twidget;
 container1: twidget;
 rect1: rectty;
 size1: sizety;
 count1: integer;
 x1,y1: integer;
 sd1: splitdirty;
 int1,int2: integer;
 mouseinhandle: boolean;

 function checkaccept: boolean;
 var
  intf1: idocktarget;
  widget2: twidget;
 begin
  result:= (od_acceptsdock in foptionsdock)  and 
           (info.dragobjectpo^ is tdockdragobject);
  if result and not mouseinhandle and (od_dockparent in foptionsdock) and 
     not widget1.checkdescendent(
          tdockdragobject(info.dragobjectpo^).fdock.fintf.getwidget) then begin    
   widget2:= widget1.parentwidget;
   while widget2 <> nil do begin
    if widget2.getcorbainterface(typeinfo(idocktarget),intf1) and 
           (od_acceptsdock in intf1.getdockcontroller.foptionsdock) then begin
     result:= false;
     break;
    end;
    widget2:= widget2.parentwidget;
   end;
  end;
 end;

 procedure adjustdockrect;
 var
  nofit: boolean;
  rect2: rectty;
  pt1: pointty;
 begin
  with info,tdockdragobject(dragobjectpo^) do begin
   nofit:= (od_nofit in optionsdock) and (fsplitdir in [sd_x,sd_y]);
   if (fcheckeddockcontroller <> self) then begin
    if fcheckeddockcontroller <> nil then begin
     fcheckeddockcontroller.fasplitdir:= sd_none;
    end;
    fcheckeddockcontroller:= self;
   end;
   if fasplitdir = sd_none then begin
    fasplitdir:= fsplitdir;
   end;
   if not widget.checkdescendent(widget1) and 
      idockcontroller(fintf).checkdock(info) and
                docheckdock(info) then begin
    accept:= true;
    rect1:= makerect(addpoint(pos,subpoint(widget1.screenpos,pickpos)),
                  widget.size);
    if not nofit then begin
     size1:= widget1.clientsize;
     with size1 do begin
      x1:= cx div 8;
      y1:= (cy * 7) div 8;
     end;
     if (od_splitvert in foptionsdock) and
        (info.pos.x < x1) and (info.pos.y < y1) then begin
      fasplitdir:= sd_x;
     end
     else begin
      if (od_splithorz in foptionsdock) and
         (info.pos.y > y1) and (info.pos.x > x1) then begin
       fasplitdir:= sd_y;
      end
      else begin
       if (od_tabed in foptionsdock) and
          (info.pos.x > (size1.cx * 7) div 16) and 
          (info.pos.x < (size1.cx * 9) div 16) and
          (info.pos.y > (size1.cy * 7) div 16) and 
          (info.pos.y < (size1.cy * 9) div 16) then begin
        fasplitdir:= sd_tabed;
       end;
      end;
     end;
     size1:= container1.paintsize;
     if (widget.anchors * [an_left,an_right] = []) and 
                               (fsplitdir = sd_none) then begin
      rect1.cx:= size1.cx;
     end;
     if (widget.anchors * [an_top,an_bottom] = []) and 
                               (fsplitdir = sd_none) then begin
      rect1.cy:= size1.cy;
     end;
     sd1:= fsplitdir;
     fsplitdir:= fasplitdir;
     count1:= length(checksplit);
     fsplitdir:= sd1;
     if (widget.parentwidget <> container1) and
                 not widget1.checkdescendent(ftabwidget) then begin
      inc(count1);
     end;
     findex:= count1-1;
     case fasplitdir of
      sd_x: begin
       rect1.y:= container1.screenpos.y + container1.paintpos.y;
       rect1.cy:= size1.cy;
       rect1.cx:= size1.cx div (count1);
       if rect1.cx > 0 then begin
        findex:= (pos.x div rect1.cx);
        rect1.x:=  findex * rect1.cx +
                container1.screenpos.x + container1.paintpos.x;
       end;
       if count1 = 1 then begin
        dec(rect1.cx,rect1.cx div 16);
       end;
      end;
      sd_y: begin
       rect1.x:= container1.screenpos.x + container1.paintpos.x;
       rect1.cx:= size1.cx;
       rect1.cy:= size1.cy div (count1);
       if rect1.cy > 0 then begin
        findex:= (pos.y div rect1.cy);
        rect1.y:=  findex * rect1.cy +
                container1.screenpos.y + container1.paintpos.y;
       end;
       if count1 = 1 then begin
        int1:= rect1.cy div 16;
        dec(rect1.cy,int1);
        inc(rect1.y,int1);
       end;
      end;
      sd_tabed: begin
       int1:= size1.cy div 16;
       int2:= size1.cx div 16;
       if int2 < int1 then begin
        int1:= int2;
       end;
       rect1:= inflaterect(fplacementrect
               {idockcontroller(fintf).getplacementrect},-int1);
       translatewidgetpoint1(rect1.pos,container1,nil);
      end;
     end;
     if fasplitdir = sd_none then begin
      subpoint1(rect1.pos,widget.paintpos);
      if widget1 <> container1 then begin
       addpoint1(rect1.pos,widget1.paintpos);
      end;
      setxorwidget(container1,clipinrect(rect1,
        makerect(translatewidgetpoint(container1.clientwidgetpos,
        container1,nil),container1.maxclientsize)));
     end
     else begin
      setxorwidget(container1,clipinrect(rect1,
        makerect(translatewidgetpoint(container1.paintpos,
        container1,nil),size1)));
     end;
    end
    else begin //nofit
//     pt1:= translateclientpoint(rect1.pos,nil,container1);
     pt1:= addpoint(info.pos,widget1.paintpos);
     if findbandwidget(pt1,int1,rect2) then begin
      findex:= int1;
      fr^.setsize(rect2,fr^.size(rect1));
      fsizingrect:= rect2;
      translatewidgetpoint1(rect2.pos,container1,nil);
      setxorwidget(container1,rect2);
     end;
    end;
    result:= true;
   end;
  end;
 end;
 
 procedure dockwidget;
 begin
  with info,tdockdragobject(dragobjectpo^) do begin
   if container1 = fxorwidget then begin
    with tdockdragobject(dragobjectpo^).fdock do begin
     if fmdistate = mds_floating then begin
      fmdistate:= mds_normal;
     end
     else begin
      if fmdistate = mds_maximized then begin
       fnormalrect:= widget1.widgetrect;
       mdistate:= mds_normal;
      end;
     end;
     translatewidgetpoint1(fsizingrect.pos,nil,container1); 
            //used incalclayout
    end;
    fsizes:= nil;
    calclayout(tdockdragobject(dragobjectpo^),false);
    updaterefsize;
    dochilddock(widget);
    result:= true;
   end;
  end;
 end;
 
begin
 widget1:= fintf.getwidget;
 container1:= widget1.container;
 result:= false;
 if not(csdesigning in widget1.ComponentState) then begin
  with info do begin
   mouseinhandle:= (fdockhandle <> nil) and pointinrect(
     translateclientpoint(info.pos,idockcontroller(fintf).getwidget,fdockhandle),
       fdockhandle.gethandlerect) or
      pointinrect(info.pos,idockcontroller(fintf).getbuttonrects(dbr_handle));
   case eventkind of
    dek_begin: begin
     if mouseinhandle then begin
      if (widget1.parentwidget <> nil)  then  begin
       if od_canmove in foptionsdock then begin
        tdockdragobject.create(self,widget1,dragobjectpo^,fpickpos);
        result:= true;
       end
       else begin
        if canfloat then begin
         dofloat(nullpoint);
         result:= true;
        end;
       end;
      end
      else begin
       if (od_candock in foptionsdock) and (widget1.parentwidget = nil) and
              (dragobjectpo^ = nil) then  begin
        tdockdragobject.create(self,widget1,dragobjectpo^,fpickpos);
        result:= true;
       end;
      end;
     end
    end;
    dek_check: begin
     if checkaccept then begin        
      adjustdockrect;
     end;
    end;
    dek_drop: begin
     if checkaccept then begin
      dockwidget;
     end;
    end;
   end;
  end;
 end;
 if not result then begin
  result:= inherited beforedragevent(info);
 end;
end;

procedure tdockcontroller.setdockhandle(const avalue: tdockhandle);
begin
 if fdockhandle <> nil then begin
  fdockhandle.fcontroller:= nil;
 end;
 setlinkedvar(avalue,tmsecomponent(fdockhandle));
 if fdockhandle <> nil then begin
  fdockhandle.fcontroller:= self;
 end;
end;

procedure tdockcontroller.dodock;
var
 widget1: twidget1;
 int1: integer;
 controller1: tdockcontroller;
begin
 fmdistate:= mds_normal;
 widget1:= twidget1(fintf.getwidget);
 inc(floatdockcount);
 int1:= floatdockcount;
 if widget1.canevent(tmethod(fondock)) then begin
  fondock(widget1);
 end;
 if floatdockcount = int1 then begin
  if getparentcontroller(controller1) then begin
   controller1.dochilddock(widget1);
  end;
 end;
end;

procedure tdockcontroller.dofloat(const adist: pointty);
var
 widget1: twidget1;
 wstr1: msestring;
 int1: integer;
 controller1: tdockcontroller;
begin
 widget1:= twidget1(fintf.getwidget);
 fmdistate:= mds_floating;
 getparentcontroller(controller1);
 widget1.parentwidget:= nil;
 widget1.pos:= addpoint(widget1.pos,adist);
 wstr1:= getfloatcaption;
 if wstr1 <> '' then begin
  widget1.window.caption:= wstr1;
 end;
 updategrip(sd_none,widget1);
 inc(floatdockcount);
 int1:= floatdockcount;
 if widget1.canevent(tmethod(fonfloat)) then begin
  fonfloat(widget1);
 end;
 if (floatdockcount = int1) and (controller1 <> nil) then begin
  controller1.dochildfloat(widget1);
  widget1.activate;
 end;
end;

function tdockcontroller.canfloat: boolean;
begin
 result:= (od_canfloat in foptionsdock) and 
               not (ismdi and (mdistate = mds_minimized))
end;

procedure tdockcontroller.refused(const apos: pointty);
var
 widget1: twidget;
 intf1: idocktarget;
 dir1: splitdirty;
begin
 if canfloat then begin
  widget1:= fintf.getwidget.parentwidget;
  dir1:= sd_none; //compiler warning
  if widget1 <> nil then begin
   if widget1.getcorbainterface(typeinfo(idocktarget),intf1) then begin
    with intf1.getdockcontroller do begin
     dir1:= fasplitdir;
     fasplitdir:= fsplitdir; //no change of dir in calclayout
    end;
   end;
   dofloat(subpoint(apos,translateclientpoint(fpickpos,fintf.getwidget,nil)));
   if intf1 <> nil then begin
    with intf1.getdockcontroller do begin
     fasplitdir:= dir1;
    end;
   end;
  end;
 end;
end;

procedure tdockcontroller.dochilddock(const awidget: twidget);
var
 widget1: twidget1;
begin
 widget1:= twidget1(fintf.getwidget);
 if widget1.canevent(tmethod(fonchilddock)) then begin
  fonchilddock(widget1,awidget);
 end;
end;

procedure tdockcontroller.dochildfloat(const awidget: twidget);
var
 widget1: twidget1;
begin
 widget1:= twidget1(fintf.getwidget);
 if widget1.canevent(tmethod(fonchildfloat)) then begin
  fonchildfloat(widget1,awidget);
 end;
end;

procedure tdockcontroller.domdistatechanged(const oldstate,newstate: mdistatety);
var
 widget1: twidget1;
begin
 widget1:= twidget1(fintf.getwidget);
 if widget1.canevent(tmethod(fonmdistatechanged)) then begin
  fonmdistatechanged(widget1,oldstate,newstate);
 end;
end;

function tdockcontroller.docheckdock(const info: draginfoty): boolean;
var
 widget1: twidget1;
begin
 widget1:= twidget1(fintf.getwidget);
 if widget1.canevent(tmethod(foncheckdock)) then begin
  result:= false;
  foncheckdock(widget1,info.pos,tdockdragobject(info.dragobjectpo^),result);
 end
 else begin
  result:= true;
 end;
end;

procedure tdockcontroller.enddrag;
begin
 if fdragobject is tdockdragobject then begin
  with tdockdragobject(fdragobject) do begin
   if fxorwidget <> nil then begin
    fxorwidget.invalidatewidget;
   end;
  end;
 end;
 inherited;
end;

   //istatfile
procedure tdockcontroller.statreading;
begin
 include(fdockstate,dos_updating4);
end;

procedure tdockcontroller.statread;
var
 int1,int2,int3: integer;
 str1: string;
 widget1: twidget;
begin
 fsize:= idockcontroller(fintf).getplacementrect.size;
 exclude(fdockstate,dos_updating4);
 calclayout(nil,true);
 if (fsplitdir = sd_tabed) and (ftabwidget <> nil) then begin
  int3:= 0;
  for int1:= 0 to high(ftaborder) do begin
   str1:= ftaborder[int1];
   for int2:= int3 to tdocktabwidget(ftabwidget).count - 1 do begin
    widget1:= tdocktabpage(tdocktabwidget(ftabwidget)[int2]).ftarget;
    if (widget1 <> nil) and (widget1.Name = str1) then begin
     tdocktabwidget(ftabwidget).movepage(int2,int3);
     inc(int3);
     break;
    end;
   end;
  end;
  if factivetab < tdocktabwidget(ftabwidget).count then begin
   tdocktabwidget(ftabwidget).activepageindex:= factivetab;
  end;
 end;
 ftaborder:= nil;
 sizechanged(true);
end;

function tdockcontroller.getdockcaption: msestring;
begin
 if fcaption = '' then begin
  result:= idockcontroller(fintf).getcaption;
 end
 else begin
  result:= fcaption
 end;
end;

function tdockcontroller.getfloatcaption: msestring;
begin
 result:= idockcontroller(fintf).getcaption;
 if result = '' then begin
  result:= fcaption
 end;
end;

procedure tdockcontroller.readchildrencount(const acount: integer);
begin
 //dummy;
end;

procedure tdockcontroller.readchild(const index: integer;
               const avalue: msestring);
var
 na: ansistring;
 rect1,rect2: rectty;
 w1: twidget;
begin
 decoderecord(avalue,[@na,@rect1.x,@rect1.y,@rect1.cx,@rect1.cy],'siiii');
 with fintf.getwidget do begin
  w1:= findwidget(na);
  if w1 <> nil then begin
   rect2.pos:= nullpoint;
   rect2.size:= application.screensize;
   shiftinrect(rect1,rect2);
   clipinrect(rect1,rect2);
   w1.widgetrect:= rect1;
  end;
 end;
end;

procedure tdockcontroller.dostatread(const reader: tstatreader);
var
 rect1: rectty;
 widget1: twidget;
 str1: string;
 bo1: boolean;
 intf1: idocktarget;
begin
 fsplitdir:= splitdirty(reader.readinteger('splitdir',ord(fsplitdir),
                              0,ord(high(splitdirty))));
 useroptions:= optionsdockty({$ifdef FPC}longword{$else}longword{$endif}(
     reader.readinteger('useroptions',
     integer({$ifdef FPC}longword{$else}longword{$endif}(fuseroptions)))));
// setoptionsdock(foptionsdock); //check valid values
 ftaborder:= reader.readarray('order',msestringarty(nil));
 factivetab:= reader.readinteger('activetab',0);
 with fintf.getwidget do begin
  if od_savepos in foptionsdock then begin
   if parentwidget = nil then begin
    str1:= '';
   end
   else begin
    str1:= ownernamepath(parentwidget);
   end;
   str1:= reader.readstring('parent',str1);
   fmdistate:= mdistatety(reader.readinteger('mdistate',ord(fmdistate)));
   with fnormalrect do begin
    x:= reader.readinteger('nx',x);
    y:= reader.readinteger('ny',y);
    cx:= reader.readinteger('ncx',cx,0);
    cy:= reader.readinteger('ncy',cy,0);
   end;
   rect1:= widgetrect;
   with rect1 do begin
    x:= reader.readinteger('x',x);
    y:= reader.readinteger('y',y);
    cx:= reader.readinteger('cx',cx,0);
    cy:= reader.readinteger('cy',cy,0);
   end;
   bo1:= visible;
   if application.findwidget(str1,widget1) then begin
    visible:= false;
    parentwidget:= widget1;
   end;
   bo1:= reader.readboolean('visible',bo1);
   if (parentwidget <> nil) then begin
    if not parentwidget.getcorbainterface(typeinfo(idocktarget),intf1)then begin
     rect1:= clipinrect(rect1,parentwidget.paintrect); //shift into widget
    end;
    widgetrect:= rect1;
   end
   else begin
    setclippedwidgetrect(rect1); //shift into screen
   end;
   visible:= bo1;
  end;
  if od_savechildren in foptionsdock then begin
   reader.readrecordarray('children',{$ifdef FPC}@{$endif}readchildrencount,
             {$ifdef FPC}@{$endif}readchild);
  end;
  if (parentwidget = nil) and (od_savezorder in foptionsdock) then  begin
   str1:= '~';
   str1:= reader.readstring('stackedunder',str1);
   if str1 <> '~' then begin
    if trim(str1) = '' then begin
     window.stackunder(nil);
    end
    else begin
     if application.findwidget(str1,widget1) and (widget1 <> nil) then begin
      window.stackunder(widget1.window);
     end;
    end;
   end;
   window.caption:= getfloatcaption;
  end;
 end;
end;

function tdockcontroller.writechild(const index: integer): msestring;
begin
 with twidget1(fintf.getwidget).widgets[index] do begin
  result:= encoderecord([name,bounds_x,bounds_y,bounds_cx,bounds_cy]);
 end;
end;

procedure tdockcontroller.dostatwrite(const writer: tstatwriter;
                                    const bounds: prectty = nil);
var
 str1: string;
 window1: twindow;
 tabed: boolean;
 ar1: msestringarty;
 int1: integer;
begin
 writer.writeinteger('splitdir',ord(fsplitdir));
 writer.writeinteger('useroptions',
         {$ifdef FPC}longword{$else}longword{$endif}(fuseroptions));
 if ftabwidget <> nil then begin
  with tdocktabwidget(ftabwidget) do begin
   setlength(ar1,count);
   for int1:= 0 to high(ar1) do begin
    ar1[int1]:= tdocktabpage(items[int1]).ftarget.Name;
   end;
   writer.writearray('order',ar1);
   writer.writeinteger('activetab',activepageindex);
  end;
 end;
 with twidget1(fintf.getwidget) do begin
  if od_savezorder in foptionsdock then begin
   if parentwidget = nil then begin
    str1:= '';
    window1:= window.stackedunder;
    if window1 <> nil then begin
     writer.writestring('stackedunder',ownernamepath(window1.owner));
    end
    else begin
     writer.writestring('stackedunder','');
    end;
   end;
  end;
  if od_savepos in foptionsdock then begin
   tabed:= (parentwidget is tdocktabpage) and (parentwidget.parentwidget <> nil);
   if parentwidget <> nil then begin
    if tabed then begin
     str1:= ownernamepath(parentwidget.parentwidget.parentwidget);
    end
    else begin
     str1:= ownernamepath(parentwidget);
    end;
   end;
   writer.writestring('parent',str1);
   if bounds = nil then begin
    writer.writeboolean('visible',visible);
   end;
   writer.writeinteger('mdistate',ord(fmdistate));
   writer.writeinteger('nx',fnormalrect.x);
   writer.writeinteger('ny',fnormalrect.y);
   writer.writeinteger('ncx',fnormalrect.cx);
   writer.writeinteger('ncy',fnormalrect.cy);
   writer.writeinteger('x',bounds_x);
   writer.writeinteger('y',bounds_y);
   writer.writeinteger('cx',bounds_cx);
   writer.writeinteger('cy',bounds_cy);
  end;
  if od_savechildren in foptionsdock then begin
   writer.writerecordarray('children',widgetcount,
             {$ifdef FPC}@{$endif}writechild);
  end;
 end;
end;

procedure tdockcontroller.setsplitter_size(const Value: integer);
begin
 if value <> fsplitter_size then begin
  fsplitter_size := Value;
  layoutchanged;
 end;
end;

procedure tdockcontroller.setsplitter_setgrip(const Value: stockbitmapty);
begin
 if fsplitter_grip <> value then begin
  fsplitter_grip:= Value;
  splitterchanged;
 end;
end;

procedure tdockcontroller.setsplitter_color(const Value: colorty);
begin
 if fsplitter_color <> value then begin
  fsplitter_color := Value;
  splitterchanged;
 end;
end;

procedure tdockcontroller.setsplitter_colorgrip(const Value: colorty);
begin
 if fsplitter_colorgrip <> value then begin
  fsplitter_colorgrip := Value;
  splitterchanged;
 end;
end;

procedure tdockcontroller.setbandgap(const avalue: integer);
begin
 if fbandgap <> avalue then begin
  fbandgap:= avalue;
  layoutchanged;
 end;
end;

procedure tdockcontroller.layoutchanged;
begin
 if not (csloading in fintf.getwidget.ComponentState) then begin
  calclayout(nil,false);
 end;
end;

procedure tdockcontroller.setpickshape(const ashape: cursorshapety);
begin
 with fintf.getwidget do begin
  if not (ds_cursorshapechanged in fstate) then begin
   fcursorbefore:= cursor;
   include(fstate,ds_cursorshapechanged);
  end;
  cursor:= ashape;
 end;
end;

procedure tdockcontroller.restorepickshape;
begin
 if ds_cursorshapechanged in fstate then begin
  fintf.getwidget.cursor:= fcursorbefore;
  exclude(fstate,ds_cursorshapechanged);
 end;
end;

function tdockcontroller.checkbuttonarea(const apos: pointty): dockbuttonrectty;
var
 dbr1: dockbuttonrectty;
begin
 result:= dbr_none;
 for dbr1:= dbr_first to dbr_last do begin
  if pointinrect(apos,idockcontroller(fintf).getbuttonrects(dbr1)) then begin
   result:= dbr1;
   break;
  end;
 end;
end;

function tdockcontroller.findbandpos(const apos: integer; out aindex: integer;
                                     out arect: rectty): boolean;
var
 int1,int2: integer;
begin
 result:= false;
 int2:= fbandstart;
 for int1:= 0 to high(fbands) do begin
  with fbands[int1] do begin
   if (apos >= int2) and (apos < int2 + size) then begin
    result:= true;
    aindex:= int1;
    fr^.setopos(arect,int2);
    fr^.setosize(arect,size);
    fr^.setpos(arect,fr^.pos(fplacementrect));
    fr^.setsize(arect,fr^.size(fplacementrect));
    break;
   end;
   int2:= int2 + size + fbandgap;
  end;
 end;
end;

function tdockcontroller.findbandwidget(const apos: pointty; out aindex: integer;
                                     out arect: rectty): boolean;
             //false if not found. widget index and widget rect
var
 ar1: widgetarty;
 int1,int2,int3,int4,int5: integer;
begin
 result:= findbandpos(fr^.opt(apos),int4,arect);
 if result then begin
  ar1:= checksplit;
  aindex:= -1;
  if ar1 <> nil then begin
   int3:= fr^.pos(arect);
   int5:= fr^.pt(apos);
   with fbands[int4] do begin
    aindex:= last;
    for int1:= first to last - 1 do begin
     int2:= fw^.size(ar1[int1]) + fsplitter_size;
     if int3 + int2 >= int5 then begin
      aindex:= int1;
      break;
     end;
     int3:= int3 + int2;
    end;
   end;
   fr^.setpos(arect,int3);
   fr^.setsize(arect,fw^.size(ar1[aindex]));
  end;
 end;
end;

function tdockcontroller.findbandindex(const widgetindex: integer; out aindex: integer;
                                     out arect: rectty): boolean;
var
 int1,int2: integer;
begin
 result:= false;
 int2:= fbandstart;
 for int1:= 0 to high(fbands) do begin
  with fbands[int1] do begin
   if last >= widgetindex then begin
    result:= true;
    aindex:= int1;
    fr^.setopos(arect,int2);
    fr^.setosize(arect,size);
    fr^.setpos(arect,fr^.pos(fplacementrect));
    fr^.setsize(arect,fr^.size(fplacementrect));
    break;
   end;
   int2:= int2 + size + fbandgap;
  end;
 end;
end;

function tdockcontroller.doclose(const awidget: twidget): boolean;
begin
 result:= simulatemodalresult(awidget,mr_windowclosed);
end;

procedure tdockcontroller.clientmouseevent(var info: mouseeventinfoty);

var
 po1: pointty;
 widget1: twidget1;
 propsize,fixsize: integer;
 ar1: widgetarty;
 prop,fix: booleanarty;
 fixend: boolean;

 function checksizing(const move: boolean): integer;
 
  function updatesizingrect: integer;
  var
   int1,int2: integer;
   w1: twidget;
   p1: integer;
   bandnumber: integer;
   bandrect: rectty;
   lastitem: integer;
  begin
   result:= -1;
   if not findbandpos(fr^.opt(po1),bandnumber,bandrect) then begin
    exit;
   end;
   p1:= fr^.pt(po1);      //widget direction
   lastitem:= fbands[bandnumber].last;
   if not fixend then begin
    dec(lastitem);
   end;
   for int1:= fbands[bandnumber].first to lastitem do begin
    w1:= twidget1(ar1[int1]);
    int2:= fw^.stop(w1);
    if (fsplitter_size = 0) and (p1 >= int2 - sizingtol) and
                    (p1 < int2 + sizingtol) or
       (fsplitter_size <> 0) and (p1 >= int2) and
            (p1 < int2 + fsplitter_size) then begin
     fr^.setopos(fsizingrect,fr^.opos(bandrect));
     fr^.setosize(fsizingrect,fr^.osize(bandrect));
     if move then begin
      fr^.setsize(fsizingrect,fw^.size(w1));
      fr^.setpos(fsizingrect,int2-fr^.size(fsizingrect));
     end
     else begin
      if fsplitter_size = 0 then begin
       fr^.setpos(fsizingrect,int2-sizingtol);
       fr^.setsize(fsizingrect,2*sizingtol);
      end
      else begin
       fr^.setpos(fsizingrect,int2);
       fr^.setsize(fsizingrect,fsplitter_size);
      end;
     end;
     result:= int1;
     break;
    end;
   end;
  end;
  
 var
  int1,int2: integer;
  
 begin
  ar1:= nil; //compilerwarning
  result:= -1;
  if move and (optionsdock * [od_nofit,od_nosplitmove] <> [od_nofit]) then begin
   exit;
  end;
  if not move and (optionsdock * [od_nosplitsize] <> []) then begin
   exit;
  end;
  ar1:= checksplit;
  if fsplitdir in [sd_x,sd_y] then begin
   result:= updatesizingrect;
   if result >= 0 then begin
    if fsplitdir = sd_x then begin
     setpickshape(cr_sizehor);
    end
    else begin
     setpickshape(cr_sizever);
    end;
   end;
  end;
  if result < 0 then begin
   restorepickshape;
  end;
 end;

 procedure checksizeoffset;
 var
  start,stop: integer;
  int1,int2,int4: integer;
  movestart: integer;
  rect1: rectty;
  bandindex,first,last: integer;
 begin
  ar1:= checksplit(propsize,fixsize,prop,fix,false);
  if fsizeindex <= high(ar1) then begin
   movestart:= fr^.pos(fplacementrect);
   start:= movestart - fw^.stop(ar1[fsizeindex]);
   stop:= start + fr^.size(fplacementrect);
   if not fixend then begin
    for int1:= 0 to fsizeindex - 1 do begin
     if fix[int1] then begin
      start:= start + fw^.size(ar1[int1]);
     end
     else begin
      start:= start + fw^.min(ar1[int1]);
     end;
    end;
    for int1:= fsizeindex + 1 to high(ar1) do begin
     if fix[int1] and (int1 <> fsizeindex + 1) then begin
      stop:= stop - fw^.size(ar1[int1]);
     end
     else begin
      stop:= stop - fw^.min(ar1[int1]);
     end;
    end;
    start:= start + fsizeindex * fsplitter_size;
    stop:= stop - (high(ar1)-fsizeindex) * fsplitter_size;
   end
   else begin 
    if dos_moving in fdockstate then begin
     movestart:= movestart + fsplitter_size;
     fmoveindex:= fsizeindex;
     int4:= fsizeoffset + fw^.pos(ar1[fsizeindex]); //mouse position
     if findbandpos(fr^.opt(po1),bandindex,rect1) then begin
      with fbands[bandindex] do begin
       fmoveindex:= last;
       for int1:= first to last do begin
        int2:= fw^.pos(ar1[int1]);
        movestart:= movestart + int2 + fsplitter_size;      
        if movestart > int4 then begin
         fmoveindex:= int1;
         break;
        end;
       end;
      end;
     end
     else begin
      findbandindex(fsizeindex,int1,rect1);
     end;
     fr^.setopos(fsizingrect,fr^.opos(rect1));
     fr^.setosize(fsizingrect,fr^.osize(rect1));
     fr^.setpos(fsizingrect,fw^.pos(ar1[fmoveindex]));
    end
    else begin
     start:= start + fw^.pos(ar1[fsizeindex]) - fr^.pos(fplacementrect) + 
                           fw^.min(ar1[fsizeindex]);
     stop:= stop - fsplitter_size;
    end;
   end;
  end;
  if fsizeoffset < start then begin
   fsizeoffset:= start;
  end;
  if fsizeoffset > stop then begin
   fsizeoffset:= stop;
  end;
 end;

 procedure calcdelta;
 var
  int1,int2,int3: integer;
  wi1: twidget;
  rect1,rect2: rectty;
 begin
  ar1:= checksplit(propsize,fixsize,prop,fix,false);
  if high(ar1) > 0 then begin
   int2:= fsizeoffset;
   include(fdockstate,dos_updating4);
   try
    if not fixend then begin
     for int1:= fsizeindex downto 0 do begin
      if not fix[int1] or (int1 = fsizeindex) then begin
       int3:= fw^.size(ar1[int1]);
       fw^.setsize(ar1[int1],int3+int2);
       int2:= int2 + int3 - fw^.size(ar1[int1]);
       if int2 = 0 then begin
        break;
       end;
      end;
     end;
     fw^.setsize(ar1[0],fw^.size(ar1[0]) + int2); //ev. rest
     int2:= - fsizeoffset;
     for int1:= fsizeindex + 1 to high(ar1) do begin
      if not fix[int1] or (int1 = fsizeindex + 1) then begin
       int3:= fw^.size(ar1[int1]);
       fw^.setsize(ar1[int1],int3+int2);
       int2:= int2 + int3 - fw^.size(ar1[int1]);
       if int2 = 0 then begin
        break;
       end;
      end;
     end;
    end;
    if dos_moving in fdockstate then begin
     findbandindex(fsizeindex,int1,rect1);
     findbandindex(fmoveindex,int2,rect2);
     int1:= fr^.opos(rect2)-fr^.opos(rect1);
     wi1:= ar1[fsizeindex];
     fw^.setopos(wi1,fw^.opos(wi1)+int1); //shift in new band;
     deleteitem(pointerarty(ar1),fsizeindex);     
     insertitem(pointerarty(ar1),fmoveindex,wi1);
     int2:= 0;
     for int1:= 0 to high(ar1) do begin
      fw^.setpos(ar1[int1],int2);
      int2:= int2 + fw^.size(ar1[int1]);
     end;
    end
    else begin
     fw^.setsize(ar1[fsizeindex],fw^.size(ar1[fsizeindex]) + int2); //ev. rest
    end;
   finally
    exclude(fdockstate,dos_updating4);
   end;
  end;
  updaterefsize;
 end;

var
 canvas1: tcanvas;
 
 procedure drawxorpic;
 var
  rect1: rectty;
 begin
  if canvas1 = nil then begin
   canvas1:= widget1.container.getcanvas(org_widget);
  end;
  if dos_moving in fdockstate then begin
   canvas1.drawxorframe(fsizingrect,-2,stockobjects.bitmaps[stb_dens50]);
  end
  else begin
   if fsplitdir = sd_x then begin
    rect1:= moverect(fsizingrect,makepoint(fsizeoffset,0));
   end
   else begin
    rect1:= moverect(fsizingrect,makepoint(0,fsizeoffset));
   end;
   canvas1.fillxorrect(rect1,stockobjects.bitmaps[stb_dens50]);
  end;
 end;
 
begin
 inherited;
 with info do begin
  if (eventstate * [es_processed] = []) then begin
   canvas1:= nil;
   fixend:= foptionsdock * [od_nofit] <> [];
   widget1:= twidget1(fintf.getwidget);
   po1:= translatewidgetpoint(addpoint(info.pos,widget1.clientwidgetpos),
           widget1,widget1.container); //widget origin
   case info.eventkind of
    ek_mouseleave,ek_clientmouseleave: begin
     if not (ds_clicked in fstate) then begin
      restorepickshape;
      fsizeindex:= -1;
      exclude(fdockstate,dos_moving);
     end;
    end;
    ek_mousemove: begin
     if fsizeindex < 0 then begin
      checksizing((dos_moving in fdockstate) or 
                         (od_nosplitsize in foptionsdock));
     end
     else begin
      if fsplitdir = sd_x then begin
       drawxorpic;   //remove pic
       fsizeoffset:= pos.x - fpickpos.x;
       checksizeoffset;
       drawxorpic;   //draw pic
      end;
      if fsplitdir = sd_y then begin
       drawxorpic;  //remove pic
       fsizeoffset:= pos.y - fpickpos.y;
       checksizeoffset;
       drawxorpic;  //draw pic
      end;
     end;
    end;
    ek_buttonpress: begin
     fsizeoffset:= 0;
     if shiftstate - [ss_left,ss_shift] = [] then begin
      fsizeindex:= checksizing((ss_shift in shiftstate) or 
                                (od_nosplitsize in foptionsdock));
      if fsizeindex >= 0 then begin
       if (ss_shift in shiftstate) or 
                  (od_nosplitsize in foptionsdock) then begin
        include(fdockstate,dos_moving);
       end
       else begin
        exclude(fdockstate,dos_moving);
       end;
       drawxorpic;
      end;
      if not (ss_shift in shiftstate) then begin
       case checkbuttonarea(pos) of
        dbr_close: include(fdockstate,dos_closebuttonclicked);
        dbr_maximize: include(fdockstate,dos_maximizebuttonclicked);
        dbr_normalize: include(fdockstate,dos_normalizebuttonclicked);
        dbr_minimize: include(fdockstate,dos_minimizebuttonclicked);
        dbr_fixsize: include(fdockstate,dos_fixsizebuttonclicked);
        dbr_top: include(fdockstate,dos_topbuttonclicked);
        dbr_background: include(fdockstate,dos_backgroundbuttonclicked);
       end;
      end;
     end;
    end;
    ek_buttonrelease: begin
     restorepickshape;
     if fsizeindex >= 0 then begin
      checksizeoffset;
      if high(ar1) > 0 then begin
       calcdelta;
       sizechanged(true);
      end;
      fsizeindex:= -1;
      fintf.getwidget.invalidate;
     end
     else begin
      case checkbuttonarea(pos) of
       dbr_close: begin
        if (dos_closebuttonclicked in fdockstate) then begin
         doclose(widget1);
        end;
       end;
       dbr_maximize: mdistate:= mds_maximized;
       dbr_normalize: mdistate:= mds_normal;
       dbr_minimize: mdistate:= mds_minimized;
       dbr_fixsize: begin
        if (dos_fixsizebuttonclicked in fdockstate) then begin
         useroptions:= optionsdockty(
          togglebit({$ifdef FPC}longword{$else}longword{$endif}(fuseroptions),
          ord(od_fixsize)));
         widget1.invalidatewidget;
        end;
       end;
       dbr_top: begin
        if (dos_topbuttonclicked in fdockstate) then begin
         useroptions:= optionsdockty(
          togglebit({$ifdef FPC}longword{$else}longword{$endif}(fuseroptions),
          ord(od_top)));
         widget1.invalidatewidget;
        end;
       end;
       dbr_background: begin
        if (dos_backgroundbuttonclicked in fdockstate) then begin
         useroptions:= optionsdockty(
          togglebit({$ifdef FPC}longword{$else}longword{$endif}(fuseroptions),
          ord(od_background)));
         widget1.invalidatewidget;
        end;
       end;
      end;
     end;
     fdockstate:= fdockstate - 
        [dos_closebuttonclicked,dos_maximizebuttonclicked,
            dos_normalizebuttonclicked,dos_minimizebuttonclicked,
            dos_fixsizebuttonclicked,dos_topbuttonclicked,
            dos_backgroundbuttonclicked,dos_moving];
    end;
   end;
  end;
 end;
end;

procedure tdockcontroller.checkmouseactivate(const sender: twidget;
                                                 var info: mouseeventinfoty);
var
 widget1: twidget;
begin
 if (info.eventkind = ek_buttonpress) then begin
  if ismdi then begin
   widget1:= fintf.getwidget;
   widget1.bringtofront;
   if ((sender = widget1) or (sender = widget1.container)) and 
                  widget1.canfocus then begin
    widget1.setfocus;
   end;
  end;
 end;
end;

procedure tdockcontroller.childmouseevent(const sender: twidget;
               var info: mouseeventinfoty);
begin
 checkmouseactivate(sender,info);
end;

procedure tdockcontroller.widgetregionchanged(const sender: twidget);
begin
 if (sender <> nil) and
         (fdockstate * [dos_updating1,dos_updating2,dos_updating3,dos_updating4,
                       dos_updating5] = []) then begin
  with fintf.getwidget do begin
   if (componentstate * [csloading,csdesigning] = []) and 
                        not (ws_destroying in widgetstate) and
     not (ow_noautosizing in sender.optionswidget) then begin
    include(fdockstate,dos_updating3);
    try
     calclayout(nil,not(ws1_parentupdating in sender.widgetstate1));
     updaterefsize;
    finally
     exclude(fdockstate,dos_updating3);
    end;
   end;
  end;
 end;
end;

procedure tdockcontroller.setcaption(const Value: msestring);
var
 widget1: twidget;
begin
 fcaption := Value;
 widget1:= fintf.getwidget;
 if widget1.ownswindow then begin
  widget1.window.caption:= fcaption;
 end;
end;

procedure tdockcontroller.beginclientrectchanged;
begin
 include(fdockstate,dos_updating1);
end;

procedure tdockcontroller.endclientrectchanged;
begin
 exclude(fdockstate,dos_updating1);
 if (fdockstate * [dos_updating2,dos_updating4] = []) then begin
  sizechanged;
 end
 else begin
  exclude(fdockstate,dos_layoutvalid);
 end;
end;

function tdockcontroller.isfullarea: boolean;
var
 acontroller: tdockcontroller;
begin
 result:= getparentcontroller(acontroller) and 
              (acontroller.fsplitdir <> sd_none);
end;

function tdockcontroller.istabed: boolean;
var
 acontroller: tdockcontroller;
begin
 result:= getparentcontroller(acontroller) and 
              (acontroller.fsplitdir = sd_tabed);
end;

function tdockcontroller.ismdi: boolean;
var
 acontroller: tdockcontroller;
begin
 result:= (fintf.getwidget.parentwidget <> nil) and 
  (fmdistate <> mds_floating) and getparentcontroller(acontroller) and 
        (acontroller.fsplitdir = sd_none) and 
                 not (dos_tabedending in acontroller.fdockstate);
end;

function tdockcontroller.isfloating: boolean;
begin
 with fintf.getwidget do begin
  result:= (parentwidget = nil) or (csdesigning in componentstate) and 
               (parentwidget = owner);
 end;
end;

function tdockcontroller.canmdisize: boolean;
begin
 result:= ismdi and (od_cansize in foptionsdock);
end;

function tdockcontroller.getitems: widgetarty; //reference count = 1
var
 int1: integer;
begin
 if ftabwidget <> nil then begin
  with tdocktabwidget(ftabwidget) do begin
   setlength(result,count);
   for int1:= 0 to high(result) do begin
    result[int1]:= tdocktabpage(items[int1]).ftarget;
   end;
  end;
 end
 else begin
  with twidget1(fintf.getwidget.container) do begin
   result:= copy(fwidgets);
  end;
 end;
end;

{
procedure tdockcontroller.maximize;
begin
 if ismdi then begin
  with fintf.getwidget do begin  
   if fmdistate = mds_normal then begin
    fnormalrect:= widgetrect;
   end;
   fmdistate:= mds_maximized;
   anchors:= [];
   widgetrect:= placementrect;
  end;
 end; 
end;

procedure tdockcontroller.normalize;
begin
 if ismdi and (fmdistate <> mds_normal) then begin
  fmdistate:= mds_normal;
  with fintf.getwidget do begin
   anchors:= [an_left,an_top];
   widgetrect:= fnormalrect;
  end;
 end; 
end;

procedure tdockcontroller.minimize;
var
 rect1: rectty;
 pos1: captionposty;
begin
 if ismdi then begin
  with fintf.getwidget do begin
   if fmdistate = mds_normal then begin
    fnormalrect:= widgetrect;
   end;
   if canclose(nil) then begin
    fmdistate:= mds_minimized;
    nextfocus;
    with rect1 do begin
     pos:= fnormalrect.pos;
     size:= idockcontroller(fintf).getminimizedsize(pos1);
     if cx = 0 then begin
      cx:= fnormalrect.cx;
     end;
     if cy = 0 then begin
      cy:= fnormalrect.cy;
     end;
     case pos1 of
      cp_right: inc(x,fnormalrect.cx - cx);
      cp_bottom: inc(y,fnormalrect.cy - cy);
     end;
    end;
    anchors:= [an_left,an_top];
    widgetrect:= rect1;
   end; 
  end;
 end;
end;
}
procedure tdockcontroller.setmdistate(const avalue: mdistatety);
var
 statebefore: mdistatety;
 rect1: rectty;
 pos1: captionposty;
begin
 if fmdistate <> avalue then begin
  if ismdi then begin
   statebefore:= fmdistate;
   with twidget1(fintf.getwidget) do begin
    if fmdistate = mds_normal then begin
     fnormalrect:= widgetrect;
    end;
    case avalue of
     mds_normal: begin
      fmdistate:= mds_normal;
      anchors:= [an_left,an_top];
      widgetrect:= fnormalrect;
     end;
     mds_minimized: begin
      if canclose(nil) then begin
       fmdistate:= mds_minimized;
       nextfocus;
       with rect1 do begin
        pos:= fnormalrect.pos;
        size:= idockcontroller(fintf).getminimizedsize(pos1);
        if cx = 0 then begin
         cx:= fnormalrect.cx;
        end;
        if cy = 0 then begin
         cy:= fnormalrect.cy;
        end;
        case pos1 of
         cp_right: inc(x,fnormalrect.cx - cx);
         cp_bottom: inc(y,fnormalrect.cy - cy);
        end;
       end;
       anchors:= [an_left,an_top];
       widgetrect:= rect1;
      end
      else begin
       exit;
      end;
     end;
     mds_maximized: begin
      fmdistate:= mds_maximized;
      anchors:= [];
     end;
    end;
    if (fframe <> nil) then begin
     tcustomframe1(fframe).updatestate;
    end;        
    domdistatechanged(statebefore,fmdistate);
   end;
  end
  else begin
   fmdistate:= avalue;
  end;
 end;  
end;

function tdockcontroller.placementrect: rectty;
var
 contr1: tdockcontroller;
begin
 if getparentcontroller(contr1) then begin
  result:= idockcontroller(contr1.fintf).getplacementrect;
 end
 else begin
  result:= nullrect;
 end;
end;

procedure tdockcontroller.poschanged;
var
 pos1: captionposty;
 widget1: twidget;
begin
 if ismdi then begin 
  widget1:= fintf.getwidget;
  case fmdistate of
   mds_normal: begin
    fnormalrect:= widget1.widgetrect;
   end;
   mds_minimized: begin
    idockcontroller(fintf).getminimizedsize(pos1);
    with widget1 do begin
     case pos1 of
      cp_left,cp_top: begin
       fnormalrect.pos:= pos;
      end;
      cp_right: begin
       fnormalrect.y:= bounds_y;
       fnormalrect.x:= bounds_x + bounds_cx - fnormalrect.cx;
      end;
      cp_bottom: begin
       fnormalrect.x:= bounds_x;
       fnormalrect.y:= bounds_y + bounds_cy - fnormalrect.cy;
      end;
     end;
    end;
   end;
  end;
 end; 
end;

procedure tdockcontroller.settab_options(const avalue: tabbaroptionsty);
begin
 ftab_options:= avalue;
 if ftabwidget <> nil then begin
  tdocktabwidget(ftabwidget).updateoptions;
 end;
end;

procedure tdockcontroller.settab_color(const avalue: colorty);
begin
 ftab_color:= avalue;
 if ftabwidget <> nil then begin
  tdocktabwidget(ftabwidget).updateoptions;
 end;
end;

procedure tdockcontroller.settab_colortab(const avalue: colorty);
begin
 ftab_colortab:= avalue;
 if ftabwidget <> nil then begin
  tdocktabwidget(ftabwidget).updateoptions;
 end;
end;

procedure tdockcontroller.settab_coloractivetab(const avalue: colorty);
begin
 ftab_coloractivetab:= avalue;
 if ftabwidget <> nil then begin
  tdocktabwidget(ftabwidget).updateoptions;
 end;
end;

procedure tdockcontroller.settab_size(const avalue: integer);
begin
 ftab_size:= avalue;
 if ftabwidget <> nil then begin
  tdocktabwidget(ftabwidget).updateoptions;
 end;
end;

procedure tdockcontroller.settab_sizemin(const avalue: integer);
begin
 ftab_sizemin:= avalue;
 if ftabwidget <> nil then begin
  tdocktabwidget(ftabwidget).updateoptions;
 end;
end;

procedure tdockcontroller.settab_sizemax(const avalue: integer);
begin
 ftab_sizemax:= avalue;
 if ftabwidget <> nil then begin
  tdocktabwidget(ftabwidget).updateoptions;
 end;
end;

procedure tdockcontroller.settab_frame(const avalue: tframecomp);
begin
 setlinkedvar(avalue,tmsecomponent(ftab_frame));
end;

procedure tdockcontroller.settab_face(const avalue: tfacecomp);
begin
 setlinkedvar(avalue,tmsecomponent(ftab_face));
end;

procedure tdockcontroller.settab_facetab(const avalue: tfacecomp);
begin
 setlinkedvar(avalue,tmsecomponent(ftab_facetab));
end;

procedure tdockcontroller.settab_faceactivetab(const avalue: tfacecomp);
begin
 setlinkedvar(avalue,tmsecomponent(ftab_faceactivetab));
end;

procedure tdockcontroller.objectevent(const sender: tobject;
               const event: objecteventty);
begin
 inherited;
 if (event = oe_changed) and (ftabwidget <> nil) then begin
  tdocktabwidget(ftabwidget).updateoptions;
 end;
end;

procedure tdockcontroller.dolayoutchanged;
var
 widget1: twidget;
 intf1: idocktarget;
begin
 widget1:= fintf.getwidget;
 if widget1.canevent(tmethod(fonlayoutchanged)) then begin
  fonlayoutchanged(self);
 end;
 widget1:= widget1.parentwidget;
 while widget1 <> nil do begin
  if widget1.getcorbainterface(typeinfo(idocktarget),intf1) then begin
   intf1.getdockcontroller.dolayoutchanged;
   break;
  end;
  widget1:= widget1.parentwidget;
 end;   
end;

function tdockcontroller.getwidget: twidget;
begin
 result:= fintf.getwidget;
end;

function tdockcontroller.activewidget: twidget; //focused child or active tab
var
 tab1: tdocktabpage;
begin
 result:= nil;
 if ftabwidget <> nil then begin
  tab1:= tdocktabpage(tdocktabwidget(ftabwidget).activepage);
  if tab1 <> nil then begin
   result:= tab1.ftarget;
  end;
 end
 else begin
  result:= fintf.getwidget.focusedchild;
 end;
end;

function tdockcontroller.close: boolean; //simulates mr_windowclosed for owner
begin
 result:= doclose(fintf.getwidget);
end;

function tdockcontroller.closeactivewidget: boolean;
                   //simulates mr_windowclosed for active widget, true if ok
begin
 result:= doclose(activewidget);
end;

function tdockcontroller.checkclickstate(const info: mouseeventinfoty): boolean;
begin
 if od_nofit in foptionsdock then begin
  result:= info.shiftstate - [ss_left,ss_shift] = [];
 end
 else begin
  result:= info.shiftstate - [ss_left] = [];
 end;
end;

{ tgripframe }

constructor tgripframe.create(const intf: icaptionframe;
                       const acontroller: tdockcontroller);
begin
 fgrip_color:= defaultgripcolor;
 fgrip_coloractive:= defaultgripcoloractive;
 fgrip_colorglyph:= cl_glyph;
 fgrip_colorglyphactive:= cl_glyph;
 fgrip_colorbutton:= cl_transparent;
 fgrip_colorbuttonactive:= cl_transparent;
 fgrip_size:= defaultgripsize;
 fgrip_pos:= defaultgrippos;
 fgrip_grip:= defaultgripgrip;
 fgrip_options:= defaultgripoptions;
 fcontroller:= acontroller;
 inherited create(intf);
 fobjectpicker:= tobjectpicker.create(iobjectpicker(self));
end;

destructor tgripframe.destroy;
begin
 fobjectpicker.free;
 fgrip_face.free;
 inherited;
end;

procedure tgripframe.drawgripbutton(const acanvas: tcanvas;
               const kind: dockbuttonrectty; const arect: rectty;
               const acolorglyph: colorty; const acolorbutton: colorty);
               
 function calclevel(const aoption: optiondockty): integer;
 begin
  if aoption in fcontroller.foptionsdock then begin
   result:= -1;
  end
  else begin
   result:= 1;
  end;
 end;
 
var
 rect2: rectty;
 int1: integer;
begin
 with acanvas,arect do begin
  fillrect(arect,acolorbutton);
  case kind of
   dbr_close: begin
    if fgrip_size >= 8 then begin
     draw3dframe(acanvas,arect,1,defaultframecolors);
     drawcross(inflaterect(arect,-2),acolorglyph);
    end
    else begin
     drawcross(arect,acolorglyph);
    end;
   end;
   dbr_maximize: begin
    draw3dframe(acanvas,arect,1,defaultframecolors);
    drawframe(inflaterect(arect,-2),-1,acolorglyph);
    drawvect(makepoint(x+2,y+3),gd_right,cx-5,acolorglyph);
   end;
   dbr_normalize: begin
    draw3dframe(acanvas,arect,1,defaultframecolors);
    rect2.cx:= cx * 2 div 3 - 3;
    rect2.cy:= rect2.cx;
    rect2.pos:= addpoint(pos,makepoint(2,2));
    drawrect(rect2,acolorglyph);
    rect2.x:= x + cx - 3 - rect2.cx;
    rect2.y:= y + cy - 3 - rect2.cy;
    drawrect(rect2,acolorglyph);
   end;
   dbr_minimize: begin
    draw3dframe(acanvas,arect,1,defaultframecolors);
    case fgrip_pos of
     cp_left: begin
      drawvect(makepoint(x+2,y+2),gd_down,cy-5,acolorglyph);
      drawvect(makepoint(x+3,y+2),gd_down,cy-5,acolorglyph);
     end;
     cp_right: begin
      drawvect(makepoint(x+cx-3,y+2),gd_down,cy-5,acolorglyph);
      drawvect(makepoint(x+cx-4,y+2),gd_down,cy-5,acolorglyph);
     end;
     cp_bottom: begin
      drawvect(makepoint(x+2,y+cy-3),gd_right,cx-5,acolorglyph);
      drawvect(makepoint(x+2,y+cy-4),gd_right,cx-5,acolorglyph);
     end;
     else begin //cp_top
      drawvect(makepoint(x+2,y+2),gd_right,cx-5,acolorglyph);
      drawvect(makepoint(x+2,y+3),gd_right,cx-5,acolorglyph);
     end;
    end;
   end;
   dbr_fixsize: begin
    draw3dframe(acanvas,arect,calclevel(od_fixsize),
                 defaultframecolors);
    drawframe(inflaterect(arect,-2),-1,acolorglyph);
   end;
   dbr_top: begin
    int1:= x + cx div 2;
    draw3dframe(acanvas,arect,calclevel(od_top),defaultframecolors);
    drawlines([makepoint(int1-3,y+4),makepoint(int1,y+1),makepoint(int1,y+cy-1)],
             false,acolorglyph);
    drawline(makepoint(int1+3,y+4),makepoint(int1,y+1),acolorglyph);
   end;
   dbr_background: begin
    int1:= x + cx div 2;
    draw3dframe(acanvas,arect,calclevel(od_background),defaultframecolors);
    drawlines([makepoint(int1-3,y+cx-4),makepoint(int1,y+cy-1),makepoint(int1,y+1)],
             false,acolorglyph);
    drawline(makepoint(int1+3,y+cx-4),makepoint(int1,y+cy-1),acolorglyph);
   end;
  end;
 end;  
end;

procedure tgripframe.paintoverlay(const canvas: tcanvas; const arect: rectty);

var
 brushbefore: tsimplebitmap;
 colorbefore: colorty;
 po1,po2: pointty;
 int1,int2: integer;
 rect1: rectty;
 col1: colorty;
 info1: drawtextinfoty;
 floating: boolean;
 colorbutton,colorglyph: colorty;
 bo1: boolean;
 dirbefore: graphicdirectionty;
label
 endlab;
begin
 inherited;
 with canvas do begin
  checkstate;
  rect1:= clipbox;
  if testintersectrect(rect1,fgriprect) then begin
   colorbefore:= color;
   if fintf.getwidget.active then begin
    colorbutton:= fgrip_colorbuttonactive;
    colorglyph:= fgrip_colorglyphactive;
   end
   else begin
    colorbutton:= fgrip_colorbutton;
    colorglyph:= fgrip_colorglyph;
   end;
   if go_closebutton in fgrip_options then begin
    drawgripbutton(canvas,dbr_close,frects[dbr_close],colorglyph,colorbutton);
   end;
   if (frects[dbr_maximize].cx > 0) and 
           (go_maximizebutton in fgrip_options) then begin
    drawgripbutton(canvas,dbr_maximize,frects[dbr_maximize],colorglyph,colorbutton);
   end;
   if (frects[dbr_normalize].cx > 0) and 
                           (go_normalizebutton in fgrip_options) then begin
    drawgripbutton(canvas,dbr_normalize,frects[dbr_normalize],colorglyph,colorbutton);
   end;
   if (frects[dbr_minimize].cx > 0) and 
                           (go_minimizebutton in fgrip_options) then begin
    drawgripbutton(canvas,dbr_minimize,frects[dbr_minimize],colorglyph,colorbutton);
   end;
   if (frects[dbr_fixsize].cx > 0) and 
                           (go_fixsizebutton in fgrip_options) then begin
    drawgripbutton(canvas,dbr_fixsize,frects[dbr_fixsize],colorglyph,colorbutton);
   end;
   if (frects[dbr_top].cx > 0) and 
                           (go_topbutton in fgrip_options)  then begin
    drawgripbutton(canvas,dbr_top,frects[dbr_top],colorglyph,colorbutton);
   end;
   if (frects[dbr_background].cx > 0) and 
                           (go_backgroundbutton in fgrip_options) then begin
    drawgripbutton(canvas,dbr_background,frects[dbr_background],colorglyph,
                                                                 colorbutton);
   end;
   rect1:= frects[dbr_handle];
//   if fgrip_pos in [cp_top,cp_bottom] then begin
    info1.text.text:= fcontroller.caption;
    floating:= fcontroller.isfloating;
    if fgrip_face <> nil then begin
     bo1:= fgrip_pos in [cp_left,cp_right];
     if bo1 then begin
      with tface1(fgrip_face).fi do begin
       dirbefore:= fade_direction;
       fade_direction:= graphicdirectionty((ord(fade_direction) + 1) and 3);
      end;
     end;
     fgrip_face.paint(canvas,rect1);
     if bo1 then begin
      with tface1(fgrip_face).fi do begin
       fade_direction:= dirbefore;
      end;
     end;
    end;
    if (info1.text.text <> '') and 
      (not floating and (go_showsplitcaption in fgrip_options) or 
      floating and (go_showfloatcaption in fgrip_options) or
                                                 fcontroller.ismdi) then begin
     with info1 do begin
      text.format:= nil;
      dest:= rect1;
      font:= self.font;
      tabulators:= nil;
      flags:= [tf_clipi,tf_ycentered];
      if fgrip_pos in [cp_top,cp_bottom] then begin
       inc(dest.x,1);
       dec(dest.cx,1);
       drawtext(canvas,info1);
       inc(res.cx,1);
       inc(rect1.x,res.cx);
       dec(rect1.cx,res.cx);
       if rect1.cx < 0 then begin
        goto endlab;
       end;
      end
      else begin
       inc(dest.y,1);
       dec(dest.cy,1);
       int1:= (dest.cx - font.glyphheight) div 2 + dest.x + font.ascent;
       canvas.save;
       canvas.intersectcliprect(dest);
       canvas.drawstring(text.text,makepoint(int1,dest.y+dest.cy-1),font,
                        false,pi/2);
       canvas.restore;
       res:= dest;
       res.cy:= canvas.getstringwidth(text.text,font);
       inc(res.cy,1);
//       inc(rect1.y,res.cy);
       dec(rect1.cy,res.cy);
       if rect1.cy < 0 then begin
        goto endlab;
       end;
      end;
     end;
    end;
//   end;
   if fgrip_grip = stb_none then begin
    if fintf.getwidget.active then begin
     col1:= fgrip_coloractive;
    end
    else begin
     col1:=  cl_shadow;
    end;
    with rect1 do begin
     int1:= fgrip_size div 4;
     int2:= (fgrip_size mod 4) div 2;
     if fgrip_pos in [cp_left,cp_right] then begin
      if cy > 4 then begin
       po1.x:= x + int2;
       po1.y:= y + 2;
       po2.x:= po1.x;
       po2.y:= y + cy - 3;
       for int2:= 1 to int1 do begin
        drawline(po1,po2,cl_highlight);
        inc(po1.x,2);
        inc(po2.x,2);
        drawline(po1,po2,col1);
        inc(po1.x,2);
        inc(po2.x,2);
       end;
      end;
     end
     else begin
      if cy > 4 then begin
       po1.y:= y + int2;
       po1.x:= x + 2;
       po2.y:= po1.y;
       po2.x:= x + cx - 3;
       for int2:= 1 to int1 do begin
        drawline(po1,po2,cl_highlight);
        inc(po1.y,2);
        inc(po2.y,2);
        drawline(po1,po2,col1);
        inc(po1.y,2);
        inc(po2.y,2);
       end;
      end;
     end;
    end;
   end
   else begin
    brushbefore:= brush;
    brush:= stockobjects.bitmaps[fgrip_grip];
    if fintf.getwidget.active then begin
     color:= fgrip_coloractive;
    end
    else begin
     color:= fgrip_color;
    end;
    fillrect(rect1,cl_brushcanvas);
    brush:= brushbefore;
 //  stockobjects.bitmaps[fgrip_grip].paint(canvas,fhandlerect,
 //         [al_xcentered,al_ycentered,al_tiled],fgrip_color,cl_transparent);
   end;
endlab:
   color:= colorbefore;
  end;
 end;
end;

function tgripframe.getbuttonrects(const index: dockbuttonrectty): rectty;
begin
 result:= frects[index];
 dec(result.x,fpaintrect.x+fclientrect.x);
 dec(result.y,fpaintrect.y+fclientrect.y);
end;

function tgripframe.getminimizedsize(out apos: captionposty): sizety;
begin
 checkstate;
 if fgrip_pos in [cp_right,cp_left] then begin
  result.cy:= 0;
  result.cx:= fpaintframe.left + fpaintframe.right;
 end
 else begin
  result.cx:= 0;
  result.cy:= fpaintframe.top + fpaintframe.bottom;;
 end;
 apos:= fgrip_pos;
end;

procedure tgripframe.getpaintframe(var frame: framety);
begin
 inherited;
 case fgrip_pos of
  cp_right: inc(frame.right,fgrip_size);
  cp_top: inc(frame.top,fgrip_size);
  cp_bottom: inc(frame.bottom,fgrip_size);
  else inc(frame.left,fgrip_size);
 end;
end;

procedure tgripframe.setgrip_color(const avalue: colorty);
begin
 if fgrip_color <> avalue then begin
  fgrip_color := avalue;
  fintf.invalidatewidget;
 end;
end;

procedure tgripframe.setgrip_coloractive(const avalue: colorty);
begin
 if fgrip_coloractive <> avalue then begin
  fgrip_coloractive:= avalue;
  fintf.invalidatewidget;
 end;
end;

procedure tgripframe.setgrip_grip(const avalue: stockbitmapty);
begin
 if fgrip_grip <> avalue then begin
  fgrip_grip:= avalue;
  fintf.invalidatewidget;
 end;
end;

procedure tgripframe.setgrip_size(const avalue: integer);
begin
 if fgrip_size <> avalue then begin
  fgrip_size:= avalue;
  internalupdatestate;
 end;
end;

procedure tgripframe.setgrip_options(avalue: gripoptionsty);
const
 amask: gripoptionsty = [go_horz,go_vert];
begin
 avalue:= gripoptionsty(setsinglebit(
              {$ifdef FPC}longword{$else}word{$endif}(avalue),
              {$ifdef FPC}longword{$else}word{$endif}(fgrip_options),
              {$ifdef FPC}longword{$else}word{$endif}(amask)));
 if fgrip_options <> avalue then begin
  fgrip_options:= avalue;
  internalupdatestate;
 end;
end;

procedure tgripframe.setgrip_colorglyph(const avalue: colorty);
begin
 if fgrip_colorglyph <> avalue then begin
  fgrip_colorglyph := avalue;
  internalupdatestate;
 end;
end;

procedure tgripframe.setgrip_colorglyphactive(const avalue: colorty);
begin
 if fgrip_colorglyphactive <> avalue then begin
  fgrip_colorglyphactive := avalue;
  internalupdatestate;
 end;
end;

procedure tgripframe.setgrip_colorbutton(const avalue: colorty);
begin
 if fgrip_colorbutton <> avalue then begin
  fgrip_colorbutton := avalue;
  internalupdatestate;
 end;
end;

procedure tgripframe.setgrip_colorbuttonactive(const avalue: colorty);
begin
 if fgrip_colorbuttonactive <> avalue then begin
  fgrip_colorbuttonactive := avalue;
  internalupdatestate;
 end;
end;

procedure tgripframe.updaterects;

 procedure initrect(const index: dockbuttonrectty);
 begin
  with frects[dbr_handle] do begin
   case fgrip_pos of
    cp_right,cp_left: begin
     frects[index].x:= x;
     frects[index].y:= y;
     inc(y,fgrip_size);
     dec(cy,fgrip_size);
    end;
    else begin //top,bottom
     dec(cx,fgrip_size);
     frects[index].x:= x + cx;
     frects[index].y:= y;
    end;
   end;
  end;
  with frects[index] do begin
   cx:= fgrip_size;
   cy:= fgrip_size;
  end;
 end;

var
 bo1,bo2,bo3,designing: boolean;
 parentcontroller: tdockcontroller;
  
begin
 inherited;
 with fgriprect do begin
  case fgrip_pos of
   cp_right: begin
    x:= fpaintrect.x + fpaintrect.cx;
    y:= fpaintrect.y;
    cx:= fgrip_size;
    cy:= fpaintrect.cy;
   end;
   cp_left: begin
    x:= fpaintrect.x - fgrip_size;
    y:= fpaintrect.y;
    cx:= fgrip_size;
    cy:= fpaintrect.cy;
   end;
   cp_top: begin
    x:= fpaintrect.x;
    y:= fpaintrect.y - fgrip_size;
    cx:= fpaintrect.cx;
    cy:= fgrip_size;
   end;
   else begin //cp_bottom
    x:= fpaintrect.x;
    y:= fpaintrect.y + fpaintrect.cy;
    cx:= fpaintrect.cx;
    cy:= fgrip_size;
   end;
  end;
 end;
 with fintf.getwidget do begin
  fillchar(frects,sizeof(frects),0);
  frects[dbr_handle]:= fgriprect;
  designing:= csdesigning in componentstate;
  bo1:= (parentwidget <> nil) and (fcontroller.fmdistate <> mds_floating) or
                                 designing;
  bo3:= fcontroller.isfullarea;
  bo2:= not bo3 or designing;
  if bo1 and (go_closebutton in fgrip_options) then begin
   initrect(dbr_close);
  end;
  if fcontroller.ismdi or designing then begin
   if (go_maximizebutton in fgrip_options) and 
             ((fcontroller.mdistate <> mds_maximized) or designing) then begin
    initrect(dbr_maximize);
   end;
   if (go_normalizebutton in fgrip_options) and 
           ((fcontroller.mdistate <> mds_normal) or designing) then begin
    initrect(dbr_normalize);
   end;
   if (go_minimizebutton in fgrip_options) and
        ((fcontroller.mdistate <> mds_minimized) or designing) then begin
    initrect(dbr_minimize);
   end;
  end;
  if bo1 and (go_fixsizebutton in fgrip_options) then begin
   if designing or fcontroller.getparentcontroller(parentcontroller) and
                   bo3 and not parentcontroller.nofit and 
                  (parentcontroller.fsplitdir <> sd_tabed)  then begin
    initrect(dbr_fixsize);
   end;
  end;
  if bo2 then begin
   if go_topbutton in fgrip_options then begin
    initrect(dbr_top);
   end;
   if go_backgroundbutton in fgrip_options then begin
    initrect(dbr_background);
   end;
  end;
 end;
end;

procedure tgripframe.updatestate;
begin
 if go_horz in fgrip_options then begin
  if go_opposite in fgrip_options then begin
   fgrip_pos:= cp_bottom;
  end
  else begin
   fgrip_pos:= cp_top;
  end;
 end
 else begin
  if go_vert in fgrip_options then begin
   if go_opposite in fgrip_options then begin
    fgrip_pos:= cp_left;
   end
   else begin
    fgrip_pos:= cp_right;
   end;
  end;
 end;
 inherited;
end;

function tgripframe.griprect: rectty;
begin
 result:= frects[dbr_handle];
end;

function tgripframe.getwidget: twidget;
begin
 result:= fcontroller.fintf.getwidget;
end;

function tgripframe.getclientrect: rectty;
begin
 fcontroller.fintf.getwidget.clientrect;
end;

procedure tgripframe.invalidate;
begin
 fcontroller.fintf.getwidget.invalidate;
end;

procedure tgripframe.setlinkedvar(const source: tmsecomponent;
               var dest: tmsecomponent; const linkintf: iobjectlink = nil);
begin
 twidget1(fcontroller.fintf).setlinkedvar(source,dest,linkintf);
end;

function tgripframe.getcomponentstate: tcomponentstate;
begin
 result:= fcontroller.fintf.getwidget.componentstate;
end;

procedure tgripframe.widgetregioninvalid;
begin
 twidget1(fcontroller.fintf.getwidget).widgetregioninvalid;
end;

procedure tgripframe.updatemousestate(const sender: twidget;
               const info: mouseeventinfoty);
begin
 inherited;
 if pointinrect(info.pos,fgriprect) or (fcontroller.canmdisize) then begin
  with twidget1(sender) do begin
   fwidgetstate:= fwidgetstate + [ws_wantmousemove,ws_wantmousebutton];
  end;
 end;  
end;
 
procedure tgripframe.getpickobjects(const rect: rectty;
               const shiftstate: shiftstatesty; var objects: integerarty);
var
 kind1: sizingkindty;
begin
 if (fcontroller.mdistate <> mds_minimized) and
      (not pointinrect(rect.pos,fgriprect) or 
         pointinrect(rect.pos,frects[dbr_handle])) then begin
  with fintf.getwidget do begin
   kind1:= calcsizingkind(rect.pos,makerect(nullpoint,size));
   if anchors * [an_left,an_right] = [] then begin
    case kind1 of
     sik_right,sik_left: kind1:= sik_none;
     sik_topright,sik_topleft: kind1:= sik_top;
     sik_bottomright,sik_bottomleft: kind1:= sik_bottom;
    end;
   end;
   if anchors * [an_top,an_bottom] = [] then begin
    case kind1 of
     sik_top,sik_bottom: kind1:= sik_none;
     sik_topleft,sik_bottomleft: kind1:= sik_left;
     sik_topright,sik_bottomright: kind1:= sik_right;
    end;
   end;
  end;
  if kind1 <> sik_none then begin
   setlength(objects,1);
   objects[0]:= ord(kind1);
  end
  else begin
   objects:= nil;
  end;
 end
 else begin
  objects:= nil;
 end;
end;

function tgripframe.getcursorshape(const pos: pointty;
           const shiftstate: shiftstatesty; var shape: cursorshapety): boolean;
var
 ar1: integerarty;
begin
 getpickobjects(makerect(pos,nullsize),shiftstate,ar1);
 result:= ar1 <> nil;
 if result then begin
  shape:= sizingcursors[sizingkindty(ar1[0])];
 end
end;

procedure tgripframe.beginpickmove(const objects: integerarty);
begin
end;

function tgripframe.calcsizingrect(const akind: sizingkindty;
                                const offset: pointty): rectty;
var
 cxmin,cymin: integer;
 int1: integer;
begin
 with fintf.getwidget do begin
  cxmin:= bounds_cxmin;
  cymin:= bounds_cymin;
  if fgrip_pos in [cp_right,cp_left] then begin
   int1:= fpaintframe.left + fpaintframe.right;
   if cxmin < int1 then begin
    cxmin:= int1;
   end;
   int1:= fpaintframe.top + fpaintframe.bottom +
              fgriprect.cy - frects[dbr_handle].cy;
   if cymin < int1 then begin
    cymin:= int1;
   end;
  end
  else begin
   int1:= fpaintframe.top + fpaintframe.bottom;
   if cymin < int1 then begin
    cymin:= int1;
   end;
   int1:= fpaintframe.left + fpaintframe.right +
              fgriprect.cx - frects[dbr_handle].cx;
   if cxmin < int1 then begin
    cxmin:= int1;
   end;
  end;  
  result:= adjustsizingrect(widgetrect,akind,offset,
                   cxmin,bounds_cxmax,cymin,bounds_cymax);
  if parentwidget <> nil then begin
//   intersectrect(result,parentwidget.clientwidgetrect,result);
   with parentwidget do begin
    intersectrect(result,makerect(clientwidgetpos,maxclientsize),result);   
   end;
  end;
 end;
end;
 
procedure tgripframe.endpickmove(const pos: pointty; const offset: pointty;
               const objects: integerarty);
begin
 fcontroller.fnormalrect:= calcsizingrect(sizingkindty(objects[0]),offset);
 fcontroller.mdistate:= mds_normal;
 fintf.getwidget.widgetrect:= fcontroller.fnormalrect;
end;

procedure tgripframe.paintxorpic(const canvas: tcanvas; const pos: pointty;
               const offset: pointty; const objects: integerarty);
var
 rect1: rectty;
begin
 rect1:= calcsizingrect(sizingkindty(objects[0]),offset);
 with fintf.getwidget do begin
  subpoint1(rect1.pos,paintparentpos);
  canvas.save;
  canvas.addcliprect(paintrectparent);
  canvas.drawxorframe(rect1,-3,stockobjects.bitmaps[stb_dens50]);
  canvas.restore;
 end;
end;

procedure tgripframe.mouseevent(var info: mouseeventinfoty);
begin
 if not fcontroller.active then begin
  fobjectpicker.mouseevent(info);
 end;
end;

procedure tgripframe.updatewidgetstate;
begin
 inherited;
 fintf.getwidget.invalidaterect(fgriprect,org_widget);
end;

function tgripframe.getgrip_face: tface;
begin
 fintf.getwidget.getoptionalobject(fgrip_face,{$ifdef FPC}@{$endif}createface);
 result:= fgrip_face;
end;

procedure tgripframe.setgrip_face(const avalue: tface);
begin
 fintf.getwidget.setoptionalobject(avalue,fgrip_face,
                              {$ifdef FPC}@{$endif}createface);
end;

procedure tgripframe.createface;
begin
 fgrip_face:= tface.create(iface(self));
end;

function tgripframe.translatecolor(const acolor: colorty): colorty;
begin
 result:= fintf.getwidget.translatecolor(acolor);
end;

{ tdockhandle }

constructor tdockhandle.create(aowner: tcomponent);
begin
 fgrip_color:= defaultgripcolor;
 fgrip_pos:= cp_bottomright;
 fgrip_grip:= stb_none;
 inherited;
 foptionswidget:= defaultoptionswidget + [ow_top,ow_noautosizing];
 size:= makesize(15,15);
 anchors:= [an_right,an_bottom];
 color:= cl_transparent;
end;

function tdockhandle.gethandlerect: rectty;
begin
 result:= paintrect;
end;

procedure tdockhandle.setgrip_color(const Value: colorty);
begin
 if fgrip_color <> value then begin
  fgrip_color:= value;
  invalidate;
 end;
end;

procedure tdockhandle.setgrip_grip(const Value: stockbitmapty);
begin
 if fgrip_grip <> value then begin
  fgrip_grip:= value;
  invalidate;
 end;
end;

procedure tdockhandle.setgrip_pos(const Value: captionposty);
begin
 if fgrip_pos <> value then begin
  fgrip_pos:= value;
  invalidate;
 end;
end;

procedure tdockhandle.clientmouseevent(var info: mouseeventinfoty);
var
 po1: pointty;
begin
 inherited;
 if not (es_processed in info.eventstate) and (fcontroller <> nil) then begin
  po1:= translateclientpoint(nullpoint,self,fcontroller.fintf.getwidget);
  addpoint1(info.pos,po1);
  fcontroller.clientmouseevent(info);
  subpoint1(info.pos,po1);
 end;
end;

procedure tdockhandle.dopaint(const canvas: tcanvas);
var
 rect1: rectty;
 int1,int2,x,y: integer;
 po1: pointty;
begin
 inherited;
 rect1:= innerclientrect;
 if fgrip_grip <> stb_none then begin
  with canvas do begin
   brush:= stockobjects.bitmaps[fgrip_grip];
   color:= fgrip_color;
   fillrect(rect1,cl_brushcanvas);
  end;
 end
 else begin
  case fgrip_pos of
   cp_bottomright: begin
    po1.x:= rect1.x + rect1.cx;
    po1.y:= rect1.y + rect1.cy;
    x:= rect1.x + rect1.cx - 1;
    y:= rect1.y + rect1.cy - 1;
    if rect1.cy < rect1.cx then begin
     int2:= rect1.cy;
    end
    else begin
     int2:= rect1.cx
    end;
    dec(int2);
    int1:= 2;
    while (int1 < int2) do begin
     canvas.drawline(makepoint(x-int1,y),makepoint(x,y-int1),cl_shadow);
     canvas.drawline(makepoint(x-int1-1,y-1),makepoint(x-1,y-int1-1),cl_highlight);
     inc(int1,4);
    end;
   end;
  end;
 end;
end;

{ tdockpanel }

constructor tdockpanel.create(aowner: tcomponent);
begin
 ficon:= tmaskedbitmap.create(false);
 ficon.onchange:= {$ifdef FPC}@{$endif}iconchanged;
 if fdragdock = nil then begin
  fdragdock:= tdockcontroller.create(idockcontroller(self));
 end;
 inherited;
end;

destructor tdockpanel.destroy;
begin
 ficon.free;
 inherited;
 fdragdock.Free;
end;

function tdockpanel.checkdock(var info: draginfoty): boolean;
begin
 result:= true;
end;

procedure tdockpanel.mouseevent(var info: mouseeventinfoty);
begin
 inherited;
 if not (es_processed in info.eventstate) then begin
  fdragdock.mouseevent(info);
 end;
end;

procedure tdockpanel.internalcreateframe;
begin
 tgripframe.create(iscrollframe(self),fdragdock);
end;

procedure tdockpanel.dragevent(var info: draginfoty);
begin
 if not fdragdock.beforedragevent(info) then begin
  inherited;
 end;
 fdragdock.afterdragevent(info);
end;

function tdockpanel.getframe: tgripframe;
begin
 result:= tgripframe(inherited getframe);
end;

procedure tdockpanel.setframe(const Value: tgripframe);
begin
 inherited setframe(value);
end;

procedure tdockpanel.setdragdock(const Value: tdockcontroller);
begin
 fdragdock.assign(Value);
end;

procedure tdockpanel.updatewindowinfo(var info: windowinfoty);
begin
 inherited;
 info.options:= foptionswindow;
 getwindowicon(ficon,info.icon,info.iconmask);
end;

function tdockpanel.getbuttonrects(const index: dockbuttonrectty): rectty;
begin
 if fframe = nil then begin
  if index = dbr_handle then begin
   result:= clientrect;
  end
  else begin
   result:= nullrect;
  end;
 end
 else begin
  result:= tgripframe(fframe).getbuttonrects(index);
 end;
end;

function tdockpanel.getminimizedsize(out apos: captionposty): sizety;
begin
 if fframe = nil then begin
  result:= nullsize;
 end
 else begin
  result:= tgripframe(fframe).getminimizedsize(apos);
 end;
end;

function tdockpanel.getplacementrect: rectty;
begin
 result:= innerpaintrect;
 minsize:= nullsize;
end;

function tdockpanel.getcaption: msestring;
begin
 result:= '';
end;

procedure tdockpanel.setstatfile(const Value: tstatfile);
begin
 setstatfilevar(istatfile(self),value,fstatfile);
end;

procedure tdockpanel.seticon(const avalue: tmaskedbitmap);
begin
 ficon.assign(avalue);
end;

procedure tdockpanel.iconchanged(const sender: tobject);
var
 icon1,mask1: pixmapty;
begin
 if ownswindow then begin
  getwindowicon(ficon,icon1,mask1);
  gui_setwindowicon(window.winid,icon1,mask1);
 end;
end;

   //istatfile
procedure tdockpanel.dostatread(const reader: tstatreader);
begin
 fdragdock.dostatread(reader);
end;

procedure tdockpanel.dostatwrite(const writer: tstatwriter);
begin
 fdragdock.dostatwrite(writer,nil);
end;

procedure tdockpanel.statreading;
begin
 fdragdock.statreading;
end;

procedure tdockpanel.statread;
begin
 fdragdock.statread;
end;

function tdockpanel.getstatvarname: msestring;
begin
 result:= fstatvarname;
end;

procedure tdockpanel.clientrectchanged;
begin
 fdragdock.beginclientrectchanged;
 inherited;
 fdragdock.endclientrectchanged;
end;

procedure tdockpanel.widgetregionchanged(const sender: twidget);
begin
 inherited;
 fdragdock.widgetregionchanged(sender);
end;

procedure tdockpanel.setparentwidget(const Value: twidget);
begin
 if fframe <> nil then begin
  exclude(tcustomframe1(fframe).fstate,fs_rectsvalid);
 end;
 inherited;
end;

procedure tdockpanel.dopaint(const acanvas: tcanvas);
begin
 inherited;
 fdragdock.dopaint(acanvas);
end;

procedure tdockpanel.doactivate;
begin
 fdragdock.doactivate;
 inherited;
end;

function tdockpanel.getdockcontroller: tdockcontroller;
begin
 result:= fdragdock;
end;

end.
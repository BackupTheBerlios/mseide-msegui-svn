{ MSEgui Copyright (c) 1999-2007 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit msedock;

{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface
uses
 msewidgets,classes,msedrag,msegui,msegraphutils,mseevent,mseclasses,
 msegraphics,msestockobjects,mseguiglob,msestat,msestatfile,msepointer,
 msesplitter,msesimplewidgets,msetypes,msestrings,msebitmap,mseobjectpicker;
 
//todo: optimize

const
 defaultgripsize = 10;
 defaultgripgrip = stb_none;
 defaultgripcolor = cl_white;
 defaultgripcoloractive = cl_activegrip;
 defaultgrippos = cp_right;
 defaultsplittersize = 3;

type
 optiondockty = (od_savepos,
            od_canmove,od_cansize,od_canfloat,od_candock,od_acceptsdock,
            od_splitvert,od_splithorz,od_tabed,od_proportional,
            od_propsize,od_fixsize,od_top,od_background);
 optionsdockty = set of optiondockty;

 dockbuttonrectty = (dbr_none,dbr_handle,dbr_close,dbr_maximize,dbr_normalize,
                     dbr_minimize,dbr_fixsize,
                     dbr_top,dbr_background);
const
 defaultoptionsdock = [od_savepos];
 dbr_first = dbr_handle;
 dbr_last = dbr_background;

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
                    dos_topbuttonclicked,dos_backgroundbuttonclicked);
 dockstatesty = set of dockstatety;

 splitdirty = (sd_none,sd_x,sd_y,sd_tabed);
 mdistatety = (mds_normal,mds_maximized,mds_minimized,mds_floating);

 docklayouteventty = procedure(const sender: twidget; 
                                        const achildren: widgetarty) of object;
 mdistatechangedeventty = procedure(const sender: twidget;
                             const oldvalue,newvalue: mdistatety) of object;

 tdockcontroller = class(tdragcontroller)
  private
   foncalclayout: docklayouteventty;
   fonfloat: notifyeventty;
   fondock: notifyeventty;
   fonchilddock: widgeteventty;
   fonchildfloat: widgeteventty;
   foncheckdock: checkdockeventty;
   fdockhandle: tdockhandle;
   fsplitter_size: integer;
   fcursorbefore: cursorshapety;
   fsizeindex: integer;
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
   procedure setdockhandle(const avalue: tdockhandle);
   procedure layoutchanged;
   function checksplit(const awidgets: widgetarty;
                 out propsize,varsize,fixsize,fixcount: integer;
                 out isprop,isfix: booleanarty; const fixedareprop: boolean): widgetarty; overload;
   function checksplit(out propsize,fixsize: integer;
                 out isprop,isfix: booleanarty; const fixedareprop: boolean): widgetarty; overload;
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
   procedure setmdistate(const avalue: mdistatety);
  protected
   foptionsdock: optionsdockty;
   function getparentcontroller(out acontroller: tdockcontroller): boolean;
   property useroptions: optionsdockty read fuseroptions write setuseroptions
                     default defaultoptionsdock;
   procedure dofloat(const adist: pointty);
   procedure dodock;
   procedure dochilddock(const awidget: twidget);
   procedure dochildfloat(const awidget: twidget);
   procedure domdistatechanged(const oldstate,newstate: mdistatety);
   function docheckdock(const info: draginfoty): boolean;
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
   function ismdi: boolean;
   function canmdisize: boolean;
  public
   constructor create(aintf: idockcontroller);
   destructor destroy; override;
   function beforedragevent(var info: draginfoty): boolean; override;
   procedure enddrag; override;
   procedure clientmouseevent(var info: mouseeventinfoty); override;
   procedure childmouseevent(const sender: twidget; const info: mouseeventinfoty);
   procedure checkmouseactivate(const sender: twidget; 
                                      const info: mouseeventinfoty);
   procedure dopaint(const acanvas: tcanvas); //canvasorigin = container.clientpos;
   procedure doactivate;
   procedure sizechanged(force: boolean = false; scalefixedalso: boolean = false);
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
  published
   property dockhandle: tdockhandle read fdockhandle write setdockhandle;
   property splitter_size: integer read fsplitter_size write setsplitter_size default defaultsplittersize;
   property splitter_grip: stockbitmapty read fsplitter_grip
                        write setsplitter_setgrip default defaultsplittergrip;
   property splitter_color: colorty read fsplitter_color
                        write setsplitter_color default defaultsplittercolor;
   property splitter_colorgrip: colorty read fsplitter_colorgrip
                        write setsplitter_colorgrip default defaultsplittercolorgrip;
   property caption: msestring read fcaption write setcaption;
   property optionsdock: optionsdockty read foptionsdock write setoptionsdock
                      default defaultoptionsdock;
   property oncalclayout: docklayouteventty read foncalclayout write foncalclayout;
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
                 go_horz,go_vert,go_opposite);
 gripoptionsty = set of gripoptionty;

const
 defaultgripoptions = [go_closebutton];

type

 tgripframe = class(tcaptionframe,iobjectpicker)
  private
   frects: array[dbr_first..dbr_last] of rectty;
   fgriprect: rectty;
   fgrip_pos: captionposty;
   fgrip_color: colorty;
   fgrip_size: integer;
   fgrip_grip: stockbitmapty;
   fgrip_options: gripoptionsty;
   fgrip_colorbutton: colorty;
   fcontroller: tdockcontroller;
   fgrip_coloractive: colorty;
   fobjectpicker: tobjectpicker;
   procedure setgrip_color(const avalue: colorty);
   procedure setgrip_grip(const avalue: stockbitmapty);
   procedure setgrip_size(const avalue: integer);
   procedure setgrip_options(avalue: gripoptionsty);
   procedure setgrip_colorbutton(const Value: colorty);
   function getbuttonrects(const index: dockbuttonrectty): rectty;
   procedure setgrip_coloractive(const avalue: colorty);
  protected
   procedure updaterects; override;
   procedure updatestate; override;
   procedure getpaintframe(var frame: framety); override;
   function calcsizingrect(const akind: sizingkindty;
                                const offset: pointty): rectty;
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
  public
   constructor create(const intf: iframe; const acontroller: tdockcontroller);
   destructor destroy; override;
   procedure updatemousestate(const sender: twidget;
                                                const apos: pointty); override;
   procedure mouseevent(var info: mouseeventinfoty);
   procedure dopaintframe(const canvas: tcanvas; const rect: rectty); override;
   property buttonrects[const index:  dockbuttonrectty]: rectty 
                                                 read getbuttonrects;
   function getminimizedsize(out apos: captionposty): sizety;
   function griprect: rectty; //origin = pos
  published
//   property grip_pos: captionposty read fgrip_pos write setgrip_pos stored true;
   property grip_size: integer read fgrip_size write setgrip_size stored true;
                               //for optionalclass
   property grip_grip: stockbitmapty read fgrip_grip write setgrip_grip
                                                       default defaultgripgrip;
   property grip_color: colorty read fgrip_color write setgrip_color
                                                       default defaultgripcolor;
   property grip_coloractive: colorty read fgrip_coloractive 
                      write setgrip_coloractive default defaultgripcoloractive;
   property grip_colorbutton: colorty read fgrip_colorbutton write
                 setgrip_colorbutton default cl_black;
   property grip_options: gripoptionsty read fgrip_options write setgrip_options
                                                     default defaultgripoptions;
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
 msedatalist,mseshapes,sysutils,msebits,msetabs,mseguiintf,msedrawtext;

type
 twidget1 = class(twidget);
 tcustomframe1 = class(tcustomframe);
 tcustomtabwidget1 = class(tcustomtabwidget);

const
 useroptionsmask: optionsdockty = [od_fixsize,od_top,od_background];

type
 tdocktabwidget = class(ttabwidget)
  private
   fcontroller: tdockcontroller;
  protected
   procedure dopageremoved(const apage: twidget);  override;
  public
   constructor create(const acontroller: tdockcontroller);
                    reintroduce;
   destructor destroy; override;
 end;

 tdocktabpage = class(ttabpage)
  private
   ftarget: twidget;
   ftargetanchors: anchorsty;
  protected
   procedure unregisterchildwidget(const child: twidget); override;
   procedure widgetregionchanged(const sender: twidget); override;
//   procedure visiblechanged; override;
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

constructor tdocktabwidget.create(const acontroller: tdockcontroller);
begin
 fcontroller:= acontroller;
 inherited create(nil);
 options:= options + [tabo_dragdest,tabo_dragsource];
end;

destructor tdocktabwidget.destroy;
begin
 if fcontroller.ftabwidget = self then begin
  fcontroller.ftabwidget:= nil;
 end;
 inherited;
end;

procedure tdocktabwidget.dopageremoved(const apage: twidget);
begin
 inherited;
 if (count = 0) and not application.terminated then begin
  fcontroller.ftabwidget:= nil;
  fcontroller.fsplitterrects:= nil;
  release;
 end;
end;

{ tdocktabpage }

constructor tdocktabpage.create(const atabwidget: tdocktabwidget; const awidget: twidget);
var
 intf1: idocktarget;
begin
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
 {
 if (sender <> nil) and (sender = ftarget) and not sender.visible then begin
  hide;
  if tabwidget <> nil then begin
   ttabwidget1(tabwidget).internalremove(itabpage(self));
  end;
 end;
 }
 if (sender <> nil) and (sender = ftarget) and not sender.visible and
  (fparentwidget <> nil) and (fparentwidget.parentwidget <> nil) then begin
   sender.parentwidget:= fparentwidget.parentwidget;  //remove page
 end;
end;
{
procedure tdocktabpage.visiblechanged;
begin
 if visible and (tabwidget = nil) and (parentwidget is ttabwidget) then begin
  ttabwidget1(parentwidget).internaladd(itabpage(self));
 end;
 inherited;
end;
}
{ tdockcontroller }

constructor tdockcontroller.create(aintf: idockcontroller);
begin
 fsizeindex:= -1;
 foptionsdock:= defaultoptionsdock;
 fuseroptions:= defaultoptionsdock;
 fsplitter_grip:= defaultsplittergrip;
 fsplitter_color:= defaultsplittercolor;
 fsplitter_colorgrip:= defaultsplittercolorgrip;
 fsplitter_size:= defaultsplittersize;
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

var
 ar1: widgetarty;
 int1,int2: integer;
 intf1: idocktarget;
 opt1: optionsdockty;
begin
 if awidgets = nil then begin
  if (fsplitdir = sd_x) then begin
   ar1:= fintf.getwidget.getsortxchildren;
  end
  else begin
   if (fsplitdir = sd_y) or (fsplitdir = sd_tabed) then begin
    ar1:= fintf.getwidget.getsortychildren;
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
 for int1:= 0 to high(ar1) do begin
  with twidget1(ar1[int1]) do begin
   if not (ow_noautosizing in foptionswidget) and visible then begin
    result[int2]:= ar1[int1];
    if ar1[int1].getcorbainterface(typeinfo(idocktarget),intf1) then begin
     opt1:= intf1.getdockcontroller.foptionsdock;
     if not fixedareprop and (od_fixsize in opt1) then begin
      isfix[int2]:= true;
      inc(fixcount);
     end;
     if (od_propsize in opt1) and not (od_fixsize in opt1) or fixedareprop and (od_fixsize in opt1) then begin
      isprop[int2]:= true;
      if fsplitdir = sd_x then begin
       inc(propsize,ar1[int1].bounds_cx);
      end
      else begin
       inc(propsize,ar1[int1].bounds_cy);
      end;
     end
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
//  if (widget1 <> nil) and widget1.getcorbainterface(idocktarget,intf1) then begin
   intf1.getdockcontroller.calclayout(nil,false);
  end;
 end;
end;

procedure tdockcontroller.updategrip(const asplitdir: splitdirty; const awidget: twidget);
var
 frame1: tcustomframe;
 grippos1: captionposty;
begin
 frame1:= twidget1(awidget).fframe;
 if frame1 is tgripframe then begin
  with tgripframe(frame1) do begin
   grippos1:= fgrip_pos;
   if fgrip_options * [go_horz,go_vert] = [] then begin
    if fsplitdir = sd_x then begin
     if go_opposite in fgrip_options then begin
      fgrip_pos:= cp_bottom;
     end
     else begin
      fgrip_pos:= cp_top;
     end;
    end
    else begin
     if (fsplitdir = sd_y) or (fsplitdir = sd_tabed) or (fsplitdir = sd_none) then begin
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
 rect1: rectty;
 int1: integer;
 po1: pointty;

begin
 for int1:= 0 to high(awidgets) do begin
  updategrip(fsplitdir,awidgets[int1]);
 end;
 if (fsplitter_size > 0) and ((fsplitter_color <> cl_none) or
                  (fsplitter_grip <> stb_none)) and (high(awidgets) > 0) then begin
  rect1:= idockcontroller(fintf).getplacementrect;
  setlength(fsplitterrects,high(awidgets));
  if fsplitdir = sd_y then begin
   rect1.cy:= fsplitter_size;
   for int1:= 1 to high(awidgets) do begin
    rect1.y:= awidgets[int1].bounds_y - fsplitter_size;
    fsplitterrects[int1-1]:= rect1;
   end;
  end;
  if fsplitdir = sd_x then begin
   rect1.cx:= fsplitter_size;
   for int1:= 1 to high(awidgets) do begin
    rect1.x:= awidgets[int1].bounds_x - fsplitter_size;
    fsplitterrects[int1-1]:= rect1;
   end;
   po1:= fintf.getwidget.container.clientwidgetpos;
   for int1:= 0 to high(fsplitterrects) do begin
    subpoint1(fsplitterrects[int1].pos,po1); //clientorg
   end;
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
var
 splitdirbefore: splitdirty;
 intf1: idocktarget;
 cont1: tdockcontroller;
 int1: integer;
begin
 splitdirbefore:= fsplitdir;
 foptionsdock:= optionsdockty(
      setsinglebit({$ifdef FPC}longword{$else}word{$endif}(avalue),
      {$ifdef FPC}longword{$else}word{$endif}(foptionsdock),
                         {$ifdef FPC}longword{$else}word{$endif}(mask1)));
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
//   sizechanged;
  end;
 end;
end;

procedure tdockcontroller.setuseroptions(const avalue: optionsdockty);
begin
 optionsdock:= optionsdockty(replacebits({$ifdef FPC}longword{$else}word{$endif}(avalue),
           {$ifdef FPC}longword{$else}word{$endif}(foptionsdock),
           {$ifdef FPC}longword{$else}word{$endif}(useroptionsmask)));
end;

procedure tdockcontroller.splitterchanged;
begin
 if not (csloading in fintf.getwidget.ComponentState) then begin
  updatesplitterrects(checksplit);
 end;
end;

procedure tdockcontroller.sizechanged(force: boolean = false;
                         scalefixedalso: boolean = false);
var
 ar1: widgetarty;
 rect1: rectty; //placementrect
 rect2: rectty;
 minsize1: integer;
 int1: integer;
 propsize,fixsize: integer;
 widget1: twidget;
 ar2: realarty;
 rea2: real;
 prop,fix: booleanarty;
 hasparent1: boolean;

 function calcscale(const aval: real): real;
 begin
  result:= aval - high(ar1) * fsplitter_size - fixsize;
  if result <= 0 then begin
   result:= 0;
  end;
  if (propsize = 0) then begin
   result:= 1;
  end
  else begin
   result:= result/propsize;
  end;
 end;

 procedure calcsize(c,cmin,cmax: getwidgetintegerty);
 var
  int1: integer;
  rea1,rea2: real;
  horz: boolean;
 begin
  horz:= {$ifndef FPC}@{$endif}c = @wbounds_cx;
  if horz then begin
   rea1:= calcscale(rect1.cx);
  end
  else begin
   rea1:= calcscale(rect1.cy);
  end;
  for int1:= 0 to high(ar1) do begin
   ar2[int1]:= c(ar1[int1]);
   if prop[int1] then begin
    ar2[int1]:= ar2[int1] * rea1;
   end;
  end;
  rea2:= 0;
  for int1:= 0 to high(ar2) do begin
   if (cmax(ar1[int1]) <> 0) and (ar2[int1] > cmax(ar1[int1])) then begin
    ar2[int1]:= cmax(ar1[int1]);
   end;
   if ar2[int1] < cmin(ar1[int1]) then begin
    ar2[int1]:= cmin(ar1[int1]);
   end;
   rea2:= rea2 + ar2[int1]; //total size
  end;
  if horz then begin
   rea1:= rect1.cx;
  end
  else begin
   rea1:= rect1.cy;
  end;
  rea2:= rea1 - (rea2 + high(ar2) * fsplitter_size);
              //delta
  if rea2 < 0 then begin
   for int1:= high(ar2) downto 0 do begin
    if not (fix[int1] and not scalefixedalso) and not prop[int1] then begin
     rea1:= cmin(ar1[int1]);
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
     rea1:= cmax(ar1[int1]);
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
  if horz then begin
   rea2:= rect1.x;
  end
  else begin
   rea2:= rect1.y;
  end;
  ar2[0]:= ar2[0] + rea2 + fsplitter_size;
  for int1:= 1 to high(ar1) do begin        //calc pos vector
   ar2[int1]:= ar2[int1-1] + fsplitter_size + ar2[int1];
  end;
 end;

var
 needsfixscale: boolean;
 intf1: idocktarget;
 widget2: twidget;
begin
 widget2:= fintf.getwidget;
 hasparent1:= widget2.parentwidget <> nil;
 widget1:= widget2.container;
 if (widget1 <> nil) and (widget1.ComponentState * [csloading,csdesigning] = []) then begin
  rect1:= idockcontroller(fintf).getplacementrect;
  if (fsplitdir = sd_x) or (fsplitdir = sd_y) then begin
   ar1:= nil; //compiler warning
   if not sizeisequal(fsize,rect1.size) or force then begin
    fsize:= rect1.size;
    if fdockstate * [dos_updating1,dos_updating2,dos_updating4] <> [] then begin
     exclude(fdockstate,dos_layoutvalid);
    end
    else begin
     needsfixscale:= false;
     rect2:= rect1;
     fdockstate:= fdockstate + [dos_layoutvalid,dos_updating2];
     try
      inc(frecalclevel);
      ar1:= checksplit(propsize,fixsize,prop,fix,false);
      if high(ar1) >= 0 then begin
       setlength(ar2,length(ar1));
       if not (od_proportional in foptionsdock) then begin
        for int1:= 0 to high(prop) do begin
         prop[int1]:= false;
        end;
       end;
       minsize1:= 0;
       if fsplitdir = sd_x then begin

        calcsize({$ifdef FPC}@{$endif}wbounds_cx,
                 {$ifdef FPC}@{$endif}wbounds_cxmin,
                 {$ifdef FPC}@{$endif}wbounds_cxmax);

        rea2:= rect1.x;
        for int1:= 0 to high(ar1) do begin
         rect1.x:= round(rea2);
         rect1.cx:= round(ar2[int1] - rea2) - fsplitter_size;
         with ar1[int1] do begin
          widgetrect:= rect1;
          rea2:= rea2 + bounds_cx + fsplitter_size;
         end;
        end;
        minsize1:= rect1.x + rect1.cx - rect2.x;
       end;

       if fsplitdir = sd_y then begin

        calcsize({$ifdef FPC}@{$endif}wbounds_cy,
                 {$ifdef FPC}@{$endif}wbounds_cymin,
                 {$ifdef FPC}@{$endif}wbounds_cymax);

        rea2:= rect1.y;
        for int1:= 0 to high(ar1) do begin
         rect1.y:= round(rea2);
         rect1.cy:= round(ar2[int1] - rea2) - fsplitter_size;
         with ar1[int1] do begin
          widgetrect:= rect1;
          rea2:= rea2 + bounds_cy + fsplitter_size;
         end;
        end;
        minsize1:= rect1.y + rect1.cy - rect2.y;
       end;

       rect1.size:= nullsize;         //update placementrect
       with fintf.getwidget do begin
        if fsplitdir = sd_x then begin
         int1:= minsize1 - rect2.cx;
         if (int1 > 0) then begin
          if not scalefixedalso then begin
           needsfixscale:= true;
          end
          else begin
           if hasparent1 then begin
            if not (an_right in anchors) then begin
             bounds_cx:= bounds_cx + int1;
            end
            else begin
             parentwidget.changeclientsize(makesize(int1,0));
 //           parentwidget.clientwidth:= parentwidget.clientwidth + int1;
            end;
           end;
          end;
         end
         else begin
          with ar1[high(ar1)] do begin
           bounds_cx:= rect2.cx + rect2.x - bounds_x;
          end;
         end;
        end;
        if fsplitdir = sd_y then begin
         int1:= minsize1 - rect2.cy;
         if int1 > 0 then begin
          if not scalefixedalso then begin
           needsfixscale:= true;
          end
          else begin
           if hasparent1 then begin
            if not (an_bottom in anchors) then begin
             bounds_cy:= bounds_cy + int1;
            end
            else begin
             parentwidget.changeclientsize(makesize(0,int1));
 //           parentwidget.clientheight:= parentwidget.clientheight + int1;
            end;
           end;
          end;
         end
         else begin
          with ar1[high(ar1)] do begin
           bounds_cy:= rect2.cy + rect2.y - bounds_y;
          end;
         end;
        end;
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
   if ismdi then begin
    if fmdistate = mds_normal then begin
     fnormalrect:= widget2.widgetrect;
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

procedure tdockcontroller.calclayout(const dragobject: tdockdragobject;
                                                  const nonewplace: boolean);
var
 rect1: rectty;
 po1: pointty;
 ar1: widgetarty;
 int1: integer;
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
 if csdestroying in container1.componentstate then begin
  exit;
 end;
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
   fsplitterrects:=nil;
  end;
  exit;
 end;
 rect1:= idockcontroller(fintf).getplacementrect;
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
//   if (widget2 <> nil) and widget2.getcorbainterface(idocktarget,intf1) then begin
    intf1.getdockcontroller.layoutchanged; 
   end;
  end;
 end
 else begin
  newwidget:= false;
 end;
 if (length(ar1) > 0) or (widget1 <> nil) then begin
  if (fsplitdir <> sd_none) then begin
   if (widget1 <> nil) then begin
    if index > length(ar1) then begin
     index:= length(ar1);
    end;
    insertitem(pointerarty(ar1),index,widget1);
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
    step:= (step - fixsize + varsize - fsplitter_size * high(ar1)) / (length(ar1) - fixcount);
    if step < 0 then begin
     step:= 0;
    end;
   end
   else begin
    step:= 0;
   end;
  end;
  case fsplitdir of
   sd_y: begin
    if not nonewplace then begin
     pos:= rect1.y;
     for int1:= 0 to high(ar1) do begin
      rect1.y:= round(pos);
      if prop[int1] then begin
       pos:= pos + step;
      end
      else begin
       pos:= pos + ar1[int1].bounds_cy;
      end;
      if int1 = high(ar1) then begin
       rect1.cy:= po1.y - rect1.y;
      end
      else begin
       rect1.cy:= round(pos)-rect1.y;
      end;
      ar1[int1].widgetrect:= rect1;
      pos:= pos + fsplitter_size;
     end;
    end;
   end;
   sd_x: begin
    if not nonewplace then begin
     pos:= rect1.y;
     for int1:= 0 to high(ar1) do begin
      rect1.x:= round(pos);
      if prop[int1] then begin
       pos:= pos + step;
      end
      else begin
       pos:= pos + ar1[int1].bounds_cx;
      end;
      if int1 = high(ar1) then begin
       rect1.cx:= po1.x - rect1.x;
      end
      else begin
       rect1.cx:= round(pos)-rect1.x;
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
      ftabwidget:= tdocktabwidget.create(self);
      ftabwidget.parentwidget:= container1;
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
 updatesplitterrects(ar1);
 exclude(fdockstate,dos_updating1);
// if not (dos_layoutvalid in fdockstate) then begin
  sizechanged(true);
 widget1:= fintf.getwidget;
 if twidget1(widget1).canevent(tmethod(foncalclayout)) then begin
  foncalclayout(widget1,ar1);
 end;
// end;
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

 function checkaccept: boolean;
 var
  intf1: idocktarget;
 begin
  result:= (od_acceptsdock in foptionsdock)  and (info.dragobject^ is tdockdragobject);
  if result and
   (tdockdragobject(info.dragobject^).fdock.fintf.getwidget.parentwidget <>
           widget1.container) and
   (widget1.parentwidget <> nil) and
        widget1.parentwidget.getinterface(idocktarget,intf1) and
         (od_acceptsdock in intf1.getdockcontroller.foptionsdock)then begin
   result:= false;
  end;
 end;


begin
 widget1:= fintf.getwidget;
 container1:= widget1.container;
 result:= false;
 if not(csdesigning in widget1.ComponentState) then begin
  with info do begin
   case eventkind of
    dek_begin: begin
     if (fdockhandle <> nil) and pointinrect(
     translateclientpoint(info.pos,idockcontroller(fintf).getwidget,fdockhandle),
       fdockhandle.gethandlerect) or
      pointinrect(info.pos,idockcontroller(fintf).getbuttonrects(dbr_handle)) then begin
      if (widget1.parentwidget <> nil)  then  begin
       if od_canmove in foptionsdock then begin
        tdockdragobject.create(self,widget1,dragobject^,fpickpos);
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
              (dragobject^ = nil) then  begin
        tdockdragobject.create(self,widget1,dragobject^,fpickpos);
        result:= true;
       end;
      end;
     end
    end;
    dek_check: begin
     if checkaccept then begin
      with tdockdragobject(dragobject^) do begin
       if (fcheckeddockcontroller <> self) then begin
        if fcheckeddockcontroller <> nil then begin
         fcheckeddockcontroller.fasplitdir:= sd_none;
        end;
        fcheckeddockcontroller:= self;
       end;
       if fasplitdir = sd_none then begin
        fasplitdir:= fsplitdir;
       end;
       if not widget.checkdescendent(widget1) and idockcontroller(fintf).checkdock(info) and
                    docheckdock(info) then begin
        accept:= true;
//        rect1:= makerect(addpoint(widget.screenpos,
//                   subpoint(translateclientpoint(pos,container1,nil),pickpos)),
//                         widget.size);
        rect1:= makerect(addpoint(pos,subpoint(widget1.screenpos,pickpos)),
                      widget.size);
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
             (info.pos.x > (size1.cx * 7) div 16) and (info.pos.x < (size1.cx * 9) div 16) and
             (info.pos.y > (size1.cy * 7) div 16) and (info.pos.y < (size1.cy * 9) div 16) then begin
           fasplitdir:= sd_tabed;
          end;
         end;
        end;
        size1:= container1.paintsize;
        if (widget.anchors * [an_left,an_right] = []) and (fsplitdir = sd_none) then begin
         rect1.cx:= size1.cx;
        end;
        if (widget.anchors * [an_top,an_bottom] = []) and (fsplitdir = sd_none) then begin
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
          rect1:= inflaterect(idockcontroller(fintf).getplacementrect,-int1);
          translatewidgetpoint1(rect1.pos,container1,nil);
         end;
        end;
        if fasplitdir = sd_none then begin
         subpoint1(rect1.pos,widget.paintpos);
         setxorwidget(container1,clipinrect(rect1,
           makerect(translatewidgetpoint(container1.clientwidgetpos,
           container1,nil),container1.clientsize)));
        end
        else begin
         setxorwidget(container1,clipinrect(rect1,
           makerect(translatewidgetpoint(container1.paintpos,
           container1,nil),size1)));
        end;
        result:= true;
       end;
      end;
     end;
    end;
    dek_drop: begin
     if checkaccept then begin
      with tdockdragobject(dragobject^) do begin
       if container1 = fxorwidget then begin
        with tdockdragobject(dragobject^).fdock do begin
         if fmdistate = mds_floating then begin
          fmdistate:= mds_normal;
         end;
        end;
        calclayout(tdockdragobject(dragobject^),false);
        dochilddock(widget);
        result:= true;
       end;
      end;
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
 if ismdi then begin
  widget1.anchors:= [an_left,an_top];
 end;  
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
//   if widget1.getcorbainterface(idocktarget,intf1) then begin
   if intf1 <> nil then begin
    with intf1.getdockcontroller do begin
     fasplitdir:= dir1;
//     layoutchanged;
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
  foncheckdock(widget1,info.pos,tdockdragobject(info.dragobject^),result);
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
//  calclayout(nil);
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
 useroptions:= optionsdockty({$ifdef FPC}longword{$else}word{$endif}(
     reader.readinteger('useroptions',
     integer({$ifdef FPC}longword{$else}word{$endif}(fuseroptions)))));
// setoptionsdock(foptionsdock); //check valid values
 ftaborder:= reader.readarray('order',msestringarty(nil));
 factivetab:= reader.readinteger('activetab',0);
 if od_savepos in foptionsdock then begin
  with fintf.getwidget do begin
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
     rect1:= clipinrect(rect1,parentwidget.paintrect);
    end;
   end
   else begin
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
   widgetrect:= rect1;
   visible:= bo1;
  end;
 end;
end;

procedure tdockcontroller.dostatwrite(const writer: tstatwriter; const bounds: prectty = nil);
var
 str1: string;
 window1: twindow;
// po1: prectty;
 tabed: boolean;
 ar1: msestringarty;
 int1: integer;
begin
 writer.writeinteger('splitdir',ord(fsplitdir));
 writer.writeinteger('useroptions',{$ifdef FPC}longword{$else}word{$endif}(fuseroptions));
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
 if od_savepos in foptionsdock then begin
  with twidget1(fintf.getwidget) do begin
   tabed:= (parentwidget is tdocktabpage) and (parentwidget.parentwidget <> nil);
   if parentwidget = nil then begin
    str1:= '';
    window1:= window.stackedunder;
    if window1 <> nil then begin
     writer.writestring('stackedunder',ownernamepath(window1.owner));
    end
    else begin
     writer.writestring('stackedunder','');
    end;
   end
   else begin
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
//  updatecursorshape(true);
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

procedure tdockcontroller.clientmouseevent(var info: mouseeventinfoty);

var
 po1: pointty;
 widget1: twidget1;
 propsize,fixsize: integer;
 ar1: widgetarty;
 prop,fix: booleanarty;

 function checksizing: integer;
 var
  int1: integer;
  containerpaintrect: rectty;
 begin
  ar1:= nil; //compilerwarning
  result:= -1;
  ar1:= checksplit;
  containerpaintrect:= idockcontroller(fintf).getplacementrect;
  if fsplitdir = sd_x then begin
   for int1:= 1 to high(ar1) do begin
    with twidget1(ar1[int1]) do begin
     if (fsplitter_size = 0) and (po1.x >= fwidgetrect.x - sizingtol) and
             (po1.x < fwidgetrect.x + sizingtol) or
        (fsplitter_size <> 0) and (po1.x >= fwidgetrect.x-fsplitter_size) and
             (po1.x < fwidgetrect.x) then begin
      setpickshape(cr_sizehor);
      fsizingrect.y:= containerpaintrect.y;
      fsizingrect.cy:= containerpaintrect.cy;
      if fsplitter_size = 0 then begin
       fsizingrect.x:= fwidgetrect.x - sizingtol;
       fsizingrect.cx:= 2*sizingtol;
      end
      else begin
       fsizingrect.x:= fwidgetrect.x - fsplitter_size;
       fsizingrect.cx:= fsplitter_size;
      end;
      result:= int1;
      break;
     end;
    end;
   end;
  end;
  if fsplitdir = sd_y then begin
   for int1:= 1 to high(ar1) do begin
    with twidget1(ar1[int1]) do begin
     if (fsplitter_size = 0) and (po1.y >= fwidgetrect.y - sizingtol) and
             (po1.y < fwidgetrect.y + sizingtol) or
        (fsplitter_size <> sizingwidth) and (po1.y >= fwidgetrect.y-fsplitter_size) and
             (po1.y < fwidgetrect.y) then begin
      setpickshape(cr_sizever);
      fsizingrect.x:= containerpaintrect.x;
      fsizingrect.cx:= containerpaintrect.cx;
      if fsplitter_size = 0 then begin
       fsizingrect.y:= fwidgetrect.y - sizingtol;
       fsizingrect.cy:= 2*sizingtol;
      end
      else begin
       fsizingrect.y:= fwidgetrect.y - fsplitter_size;
       fsizingrect.cy:= fsplitter_size;
      end;
      result:= int1;
      break;
     end;
    end;
   end;
  end;
  if result < 0 then begin
   restorepickshape;
  end;
 end;

 procedure checksizeoffset(wpos,size,min: getwidgetintegerty);
 var
  start,stop: integer;
  int1: integer;
  rect1: rectty;
 begin
  ar1:= checksplit(propsize,fixsize,prop,fix,false);
  if fsizeindex <= high(ar1) then begin
   start:= 0;
   for int1:= 0 to fsizeindex - 2 do begin
    if fix[int1]{ and (int1 <> 0)} then begin
     start:= start + size(ar1[int1]);
    end
    else begin
     start:= start + min(ar1[int1]);
    end;
   end;
   stop:= 0;
   for int1:= fsizeindex to high(ar1) do begin
    if fix[int1] and (int1 <> high(ar1)) then begin
     stop:= stop + size(ar1[int1]);
    end
    else begin
     stop:= stop + min(ar1[int1]);
    end;
   end;
   rect1:= idockcontroller(fintf).getplacementrect;
   if {$ifndef FPC}@{$endif}size = @wbounds_cx then begin
    start:= rect1.x + start;
    stop:= rect1.x + rect1.cx - stop;
   end
   else begin
    start:= rect1.y + start;
    stop:= rect1.cy - stop;
   end;
   int1:= wpos(ar1[fsizeindex]);
   start:= start - int1 + (fsizeindex) * fsplitter_size;
   stop:= stop - int1 - (high(ar1)-fsizeindex) * fsplitter_size;
   if fsizeoffset < start then begin
    fsizeoffset:= start;
   end;
   if fsizeoffset > stop then begin
    fsizeoffset:= stop;
   end;
  end;
 end;

 procedure calcdelta(getc: getwidgetintegerty; setc: setwidgetintegerty);
 var
  int1,int2,int3: integer;
 begin
  ar1:= checksplit(propsize,fixsize,prop,fix,false);
  if high(ar1) > 0 then begin
   int2:= fsizeoffset;
   include(fdockstate,dos_updating4);
   try
    for int1:= fsizeindex - 1 downto 0 do begin
     if not fix[int1] or (int1 = fsizeindex - 1) then begin
      int3:= getc(ar1[int1]);
      setc(ar1[int1],int3+int2);
      int2:= int2 + int3 - getc(ar1[int1]);
      if int2 = 0 then begin
       break;
      end;
     end;
    end;
    setc(ar1[0],getc(ar1[0]) + int2); //ev. rest
    int2:= - fsizeoffset;
    if fix[fsizeindex] then begin
     for int1:= fsizeindex + 1 to high(ar1) do begin
      if not fix[int1] then begin
       int3:= getc(ar1[int1]);
       setc(ar1[int1],int3+int2);
       int2:= int2 + int3 - getc(ar1[int1]);
       if int2 = 0 then begin
        break;
       end;
      end;
     end;
    end;
    setc(ar1[fsizeindex],getc(ar1[fsizeindex]) + int2);
   finally
    exclude(fdockstate,dos_updating4);
   end;
  end;
 end;

begin
 inherited;
 with info do begin
  if (eventstate * [es_processed] = []) then begin
   widget1:= twidget1(fintf.getwidget);
   po1:= translatewidgetpoint(addpoint(info.pos,widget1.clientwidgetpos),
           widget1,widget1.container); //widget origin
   case info.eventkind of
    ek_mouseleave,ek_clientmouseleave: begin
     if not (ds_clicked in fstate) then begin
      restorepickshape;
      fsizeindex:= -1;
     end;
    end;
    ek_mousemove: begin
     if fsizeindex <= 0 then begin
      checksizing;
     end
     else begin
      with widget1.container.getcanvas(org_widget) do begin
       if fsplitdir = sd_x then begin
        fillxorrect(moverect(fsizingrect,makepoint(fsizeoffset,0)),
                 stockobjects.bitmaps[stb_dens50]);
          //remove pic
        fsizeoffset:= pos.x - fpickpos.x;
        checksizeoffset({$ifdef FPC}@{$endif}wbounds_x,
                        {$ifdef FPC}@{$endif}wbounds_cx,
                        {$ifdef FPC}@{$endif}wbounds_cxmin);
        fillxorrect(moverect(fsizingrect,makepoint(fsizeoffset,0)),
                 stockobjects.bitmaps[stb_dens50]);
          //draw pic
       end;
       if fsplitdir = sd_y then begin
        fillxorrect(moverect(fsizingrect,makepoint(0,fsizeoffset)),
                 stockobjects.bitmaps[stb_dens50]);
          //remove pic
        fsizeoffset:= pos.y - fpickpos.y;
        checksizeoffset({$ifdef FPC}@{$endif}wbounds_y,
                        {$ifdef FPC}@{$endif}wbounds_cy,
                        {$ifdef FPC}@{$endif}wbounds_cymin);
        fillxorrect(moverect(fsizingrect,makepoint(0,fsizeoffset)),
                 stockobjects.bitmaps[stb_dens50]);
          //draw pic
       end;
      end;
     end;
    end;
    ek_buttonpress: begin
     if shiftstate = [ss_left] then begin
      fsizeindex:= checksizing;
      if fsizeindex >= 0 then begin
       widget1.container.getcanvas(org_widget).fillxorrect(fsizingrect,
             stockobjects.bitmaps[stb_dens50]);
      end;
      fsizeoffset:= 0;
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
    ek_buttonrelease: begin
     restorepickshape;
     if fsizeindex >= 0 then begin
      if fsizeindex > 0 then begin
       if fsplitdir = sd_x then begin
        checksizeoffset({$ifdef FPC}@{$endif}wbounds_x,
                        {$ifdef FPC}@{$endif}wbounds_cx,
                        {$ifdef FPC}@{$endif}wbounds_cxmin);
       end
       else begin
        checksizeoffset({$ifdef FPC}@{$endif}wbounds_y,
                        {$ifdef FPC}@{$endif}wbounds_cy,
                        {$ifdef FPC}@{$endif}wbounds_cymin);
       end;
       if high(ar1) > 0 then begin
        if fsplitdir = sd_x then begin
         calcdelta({$ifdef FPC}@{$endif}wbounds_cx,
                   {$ifdef FPC}@{$endif}wsetbounds_cx);
        end
        else begin
         calcdelta({$ifdef FPC}@{$endif}wbounds_cy,
                   {$ifdef FPC}@{$endif}wsetbounds_cy);
        end;
        sizechanged(true);
       end;
      end;
      fsizeindex:= -1;
      fintf.getwidget.invalidate;
     end
     else begin
      case checkbuttonarea(pos) of
       dbr_close: begin
        if (dos_closebuttonclicked in fdockstate) then begin
         widget1.hide;
        end;
       end;
       dbr_maximize: mdistate:= mds_maximized;
       dbr_normalize: mdistate:= mds_normal;
       dbr_minimize: mdistate:= mds_minimized;
       dbr_fixsize: begin
        if (dos_fixsizebuttonclicked in fdockstate) then begin
         useroptions:= optionsdockty(
          togglebit({$ifdef FPC}longword{$else}word{$endif}(fuseroptions),
          ord(od_fixsize)));
         widget1.invalidatewidget;
        end;
       end;
       dbr_top: begin
        if (dos_topbuttonclicked in fdockstate) then begin
         useroptions:= optionsdockty(
          togglebit({$ifdef FPC}longword{$else}word{$endif}(fuseroptions),
          ord(od_top)));
         widget1.invalidatewidget;
        end;
       end;
       dbr_background: begin
        if (dos_backgroundbuttonclicked in fdockstate) then begin
         useroptions:= optionsdockty(
          togglebit({$ifdef FPC}longword{$else}word{$endif}(fuseroptions),
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
            dos_backgroundbuttonclicked];
    end;
   end;
  end;
 end;
end;

procedure tdockcontroller.checkmouseactivate(const sender: twidget;
                                                 const info: mouseeventinfoty);
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
               const info: mouseeventinfoty);
begin
 checkmouseactivate(sender,info);
end;

procedure tdockcontroller.widgetregionchanged(const sender: twidget);
begin
 if (sender <> nil) and
         (fdockstate * [dos_updating1,dos_updating2,dos_updating3,dos_updating4,
                       dos_updating5] = [])then begin
  with fintf.getwidget do begin
   if (componentstate * [csloading,csdesigning] = []) and not (ws_destroying in widgetstate) and
     not (ow_noautosizing in sender.optionswidget) then begin
    include(fdockstate,dos_updating3);
    try
//     if (ftabwidget <> nil) and sender.visible then begin
//      tdocktabpage.create(tdocktabwidget(ftabwidget),sender);
//     end;
     calclayout(nil,false);
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

function tdockcontroller.ismdi: boolean;
var
 acontroller: tdockcontroller;
begin
 result:= (fintf.getwidget.parentwidget <> nil) and 
  (fmdistate <> mds_floating) and getparentcontroller(acontroller) and 
        (acontroller.fsplitdir = sd_none) and 
                 not (dos_tabedending in acontroller.fdockstate);
end;

function tdockcontroller.canmdisize: boolean;
begin
 result:= ismdi and (od_cansize in foptionsdock);
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
begin
 if ismdi and (fmdistate = mds_normal) then begin
  fnormalrect:= fintf.getwidget.widgetrect;
 end; 
end;

{ tgripframe }

constructor tgripframe.create(const intf: iframe;
                       const acontroller: tdockcontroller);
begin
 fgrip_color:= defaultgripcolor;
 fgrip_coloractive:= defaultgripcoloractive;
 fgrip_colorbutton:= cl_black;
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
 inherited;
end;

procedure tgripframe.dopaintframe(const canvas: tcanvas; const rect: rectty);

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
 brushbefore: tsimplebitmap;
 colorbefore: colorty;
 po1,po2: pointty;
 int1,int2: integer;
 rect1,rect2: rectty;
 col1: colorty;
 info1: drawtextinfoty;
label
 endlab;
begin
 inherited;
 with canvas do begin
  checkstate;
  rect1:= clipbox;
  if testintersectrect(rect1,fgriprect) then begin
   colorbefore:= color;
   with frects[dbr_handle] do begin
    int1:= x + cx div 2;
   end;
   if go_closebutton in fgrip_options then begin
    if fgrip_size >= 8 then begin
     draw3dframe(canvas,frects[dbr_close],1,defaultframecolors);
     drawcross(inflaterect(frects[dbr_close],-2),fgrip_colorbutton);
    end
    else begin
     drawcross(frects[dbr_close],fgrip_colorbutton);
    end;
   end;
   with frects[dbr_maximize] do begin
    if (cx > 0) and (go_maximizebutton in fgrip_options) then begin
     draw3dframe(canvas,frects[dbr_maximize],1,defaultframecolors);
     drawframe(inflaterect(frects[dbr_maximize],-2),-1,fgrip_colorbutton);
     drawvect(makepoint(x+2,y+3),gd_right,cx-5,fgrip_colorbutton);
    end;
   end;
   with frects[dbr_normalize] do begin
    if (cx > 0) and (go_normalizebutton in fgrip_options) then begin
     draw3dframe(canvas,frects[dbr_normalize],1,defaultframecolors);
     rect2.cx:= cx * 2 div 3 - 3;
     rect2.cy:= rect2.cx;
     rect2.pos:= addpoint(pos,makepoint(2,2));
     drawrect(rect2,fgrip_colorbutton);
     rect2.x:= x + cx - 3 - rect2.cx;
     rect2.y:= y + cy - 3 - rect2.cy;
     drawrect(rect2,fgrip_colorbutton);
    end;
   end;
   with frects[dbr_minimize] do begin
    if (cx > 0) and (go_minimizebutton in fgrip_options) then begin
     draw3dframe(canvas,frects[dbr_minimize],1,defaultframecolors);
     case fgrip_pos of
      cp_left: begin
       drawvect(makepoint(x+2,y+2),gd_down,cy-5,fgrip_colorbutton);
       drawvect(makepoint(x+3,y+2),gd_down,cy-5,fgrip_colorbutton);
      end;
      cp_right: begin
       drawvect(makepoint(x+cx-3,y+2),gd_down,cy-5,fgrip_colorbutton);
       drawvect(makepoint(x+cx-4,y+2),gd_down,cy-5,fgrip_colorbutton);
      end;
      cp_bottom: begin
       drawvect(makepoint(x+2,y+cy-3),gd_right,cx-5,fgrip_colorbutton);
       drawvect(makepoint(x+2,y+cy-4),gd_right,cx-5,fgrip_colorbutton);
      end;
      else begin //cp_top
       drawvect(makepoint(x+2,y+2),gd_right,cx-5,fgrip_colorbutton);
       drawvect(makepoint(x+2,y+3),gd_right,cx-5,fgrip_colorbutton);
      end;
     end;
    end;
   end;
   with frects[dbr_fixsize] do begin
    if (cx > 0) and (go_fixsizebutton in fgrip_options) then begin
     draw3dframe(canvas,frects[dbr_fixsize],calclevel(od_fixsize),defaultframecolors);
     drawframe(inflaterect(frects[dbr_fixsize],-2),-1,fgrip_colorbutton);
    end;
   end;
   with frects[dbr_top] do begin
    if (cx > 0) and (go_topbutton in fgrip_options)  then begin
     draw3dframe(canvas,frects[dbr_top],calclevel(od_top),defaultframecolors);
     drawlines([makepoint(int1-3,y+4),makepoint(int1,y+1),makepoint(int1,y+cy-1)],
              false,fgrip_colorbutton);
     drawline(makepoint(int1+3,y+4),makepoint(int1,y+1),fgrip_colorbutton);
    end;
   end;
   with frects[dbr_background] do begin
    if (cx > 0) and (go_backgroundbutton in fgrip_options) then begin
     draw3dframe(canvas,frects[dbr_background],calclevel(od_background),defaultframecolors);
     drawlines([makepoint(int1-3,y+cx-4),makepoint(int1,y+cy-1),makepoint(int1,y+1)],
              false,fgrip_colorbutton);
     drawline(makepoint(int1+3,y+cx-4),makepoint(int1,y+cy-1),fgrip_colorbutton);
    end;
   end;
   rect1:= frects[dbr_handle];
   if fgrip_pos in [cp_top,cp_bottom] then begin
    info1.text.text:= fcontroller.caption;
    if (info1.text.text <> '') and fcontroller.ismdi then begin
     with info1 do begin
      text.format:= nil;
      dest:= rect1;
      inc(dest.x,1);
      dec(dest.cx,1);
      font:= self.font;
      tabulators:= nil;
      flags:= [tf_clipi];
      drawtext(canvas,info1);
      inc(res.cx,1);
      inc(rect1.x,res.cx);
      dec(rect1.cx,res.cx);
      if rect1.cx < 0 then begin
       goto endlab;
      end;
     end;
    end;
   end;
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

procedure tgripframe.setgrip_colorbutton(const Value: colorty);
begin
 if fgrip_colorbutton <> value then begin
  fgrip_colorbutton := Value;
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
  if bo1 and bo3 and (go_fixsizebutton in fgrip_options) then begin
   initrect(dbr_fixsize);
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

procedure tgripframe.updatemousestate(const sender: twidget;
               const apos: pointty);
begin
 inherited;
 if pointinrect(apos,fgriprect) or (fcontroller.canmdisize) then begin
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
 if (fcontroller.mdistate = mds_normal) and
      (not pointinrect(rect.pos,fgriprect) or 
         pointinrect(rect.pos,frects[dbr_handle])) then begin
  kind1:= calcsizingkind(rect.pos,makerect(nullpoint,fintf.getwidget.size));
  if kind1 <> sk_none then begin
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
   intersectrect(result,parentwidget.clientwidgetrect,result);
  end;
 end;
end;
 
procedure tgripframe.endpickmove(const pos: pointty; const offset: pointty;
               const objects: integerarty);
begin
 fintf.getwidget.widgetrect:= calcsizingrect(sizingkindty(objects[0]),offset);
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
 fdragdock:= tdockcontroller.create(idockcontroller(self));
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
 tgripframe.create(iframe(self),fdragdock);
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

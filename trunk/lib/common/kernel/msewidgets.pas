{ MSEgui Copyright (c) 1999-2008 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit msewidgets;

{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface
uses
 classes,msegui,mseguiglob,msetypes,msestrings,msegraphutils,msegraphics,mseevent,
 msescrollbar,msemenus,mserichstring,msedrawtext,mseglob,mseact,mseshapes,
 mseclasses,msebitmap;

type

 sizeeventty = procedure(const sender: tobject; var asize: sizety) of object;

 tframefont = class(tparentfont)
  public
   class function getinstancepo(owner: tobject): pfont; override;
 end;

 captionframeoptionty = (cfo_fixleft,cfo_fixright,cfo_fixtop,cfo_fixbottom,
                         cfo_nofocusrect);
 captionframeoptionsty = set of captionframeoptionty;
 
 tcustomcaptionframe = class(tcustomframe)
  private
   fcaptionpos: captionposty;
   fcaptiondist: integer;
   fcaptionoffset: integer;
   fupdating: integer;
   foptions: captionframeoptionsty;
   function getcaption: msestring;
   procedure setcaption(const Value: msestring);
   procedure fontchanged(const sender: tobject);
   function isfontstored: Boolean;
   procedure setfont(const Value: tframefont);
   function getfont: tframefont;
   procedure setcaptionpos(const Value: captionposty);
   procedure setcaptiondist(const Value: integer);
   procedure setcaptionoffset(const Value: integer);
   procedure readouterframe(reader: treader);
   procedure writeouterframe(writer: twriter);
   function getcaptiondistouter: boolean;
   procedure setcaptiondistouter(const Value: boolean);
   procedure setcaptionnoclip(const avalue: boolean);
   function getcaptionnoclip: boolean;
  protected
   ffont: tframefont;
   finfo: drawtextinfoty;
   procedure parentfontchanged; override;
   procedure fontcanvaschanged; override;
   procedure visiblechanged; override;

   procedure updaterects; override;
   procedure defineproperties(filer: tfiler); override;
   procedure setdisabled(const value: boolean); override;
   procedure dopaintfocusrect(const canvas: tcanvas; const rect: rectty); override;
   function checkshortcut(var info: keyeventinfoty): boolean; override;
   function needsfocuspaint: boolean; override;
  public
   constructor create(const intf: icaptionframe);
   destructor destroy; override;
   procedure paintoverlay(const canvas: tcanvas; const arect: rectty); override;
   procedure scale(const ascale: real); override;
   procedure createfont;
//   procedure paintoverlay(const canvas: tcanvas; const arect: rectty);
//   procedure afterpaint(const canvas: tcanvas); override;
   procedure updatemousestate(const sender: twidget; const apos: pointty); override;
   function pointincaption(const point: pointty): boolean; override;
                //origin = widgetrect

   property options: captionframeoptionsty read foptions write foptions;
   property caption: msestring read getcaption write setcaption;
   property captionpos: captionposty read fcaptionpos
             write setcaptionpos default cp_topleft;
   property captiondist: integer read fcaptiondist write setcaptiondist default 1;
   property captiondistouter: boolean read getcaptiondistouter
                 write setcaptiondistouter default false;
   property captionoffset: integer read fcaptionoffset write setcaptionoffset 
                                        default 0;
   property captionnoclip: boolean read getcaptionnoclip write setcaptionnoclip
                                        default false;   
   property font: tframefont read getfont write setfont stored isfontstored;
 end;

 tcaptionframe = class(tcustomcaptionframe)
  published
   property options;
   property levelo;
   property leveli;
   property framewidth;
   property colorframe;
   property colorframeactive;
   property colordkshadow;
   property colorshadow;
   property colorlight;
   property colorhighlight;
   property colordkwidth;
   property colorhlwidth;
   property framei_left;
   property framei_top;
   property framei_right;
   property framei_bottom;

   property frameimage_list;
   property frameimage_left;
   property frameimage_top;
   property frameimage_right;
   property frameimage_bottom;
   property frameimage_offset;
   property frameimage_offsetmouse;
   property frameimage_offsetclicked;
   property frameimage_offsetactive;
   property frameimage_offsetactivemouse;
   property frameimage_offsetactiveclicked;
   
   property optionsskin;

   property colorclient;
   property caption;
   property captionpos;
   property captiondist;
   property captiondistouter;
   property captionoffset;
   property captionnoclip;
   property font;
   property localprops;  //before template
   property template;
 end;

const
 defaultscrollboxscrollbaroptions = [sbo_thumbtrack,sbo_moveauto,sbo_showauto];
 scrollbarframestates: framestatesty = [fs_sbleft,fs_sbtop,fs_sbright,fs_sbbottom];

type
 tscrollboxscrollbar = class(tcustomscrollbar)
  public
   constructor create(intf: iscrollbar; org: originty = org_client;
              ondimchanged: objectprocty = nil); override;
  published
   property options default defaultscrollboxscrollbaroptions;
   property width;
   property indentstart;
   property indentend;
   property buttonlength;
   property buttonminlength;
   property facebutton;
   property faceendbutton;
   property framebutton;
   property frameendbutton1;
   property frameendbutton2;
   property color;
   property colorpattern;
   property colorglyph;
 end;

const
 defaultthumbtrackscrollbaroptions = [sbo_thumbtrack,sbo_showauto];

type
 tthumbtrackscrollbar = class(tcustomnomoveautoscrollbar)
  public
   constructor create(intf: iscrollbar; org: originty = org_client;
              ondimchanged: objectprocty = nil); override;
  published
   property options default defaultthumbtrackscrollbaroptions;
   property width;
   property indentstart;
   property indentend;
   property buttonlength;
   property buttonminlength;
   property facebutton;
   property faceendbutton;
   property framebutton;
   property frameendbutton1;
   property frameendbutton2;
   property color;
 end;
 
 framescrollbarclassty = class of tcustomscrollbar;

 tcustomscrollframe = class(tcustomcaptionframe)
  private
   procedure setsbhorz(const Value: tcustomscrollbar);
   function getsbhorz: tcustomscrollbar;
   procedure setsbvert(const Value: tcustomscrollbar);
   function getsbvert: tcustomscrollbar;
  protected
   fhorz,fvert: tcustomscrollbar;
   procedure updatestate; override;
   procedure updatevisiblescrollbars; virtual;
   procedure updaterects; override;
   procedure getpaintframe(var frame: framety); override;
   function getscrollbarclass(vert: boolean): framescrollbarclassty; virtual;
   procedure activechanged; override;
 public
   constructor create(const intf: iscrollframe; const scrollintf: iscrollbar);
   destructor destroy; override;
   procedure checktemplate(const sender: tobject); override;
                 //true if match
   procedure updatemousestate(const sender: twidget; const apos: pointty); override;
   procedure paintoverlay(const canvas: tcanvas; const arect: rectty); override;
   procedure mouseevent(var info: mouseeventinfoty); virtual;
   procedure domousewheelevent(var info: mousewheeleventinfoty); virtual;
   property state: framestatesty read fstate;
   property sbhorz: tcustomscrollbar read getsbhorz write setsbhorz;
   property sbvert: tcustomscrollbar read getsbvert write setsbvert;
 end;

 tscrollframe = class(tcustomscrollframe)
  private
   procedure setsbhorz(const avalue: tscrollbar);
   function getsbhorz: tscrollbar;
   procedure setsbvert(const avalue: tscrollbar);
   function getsbvert: tscrollbar;
  protected
   function getscrollbarclass(vert: boolean): framescrollbarclassty; override;
  published
   property options;
   property levelo;
   property leveli;
   property framewidth;
   property colordkshadow;
   property colorshadow;
   property colorlight;
   property colorhighlight;
   property colordkwidth;
   property colorhlwidth;
   property colorframe;
   property colorframeactive;
   property framei_left;
   property framei_top;
   property framei_right;
   property framei_bottom;

   property frameimage_list;
   property frameimage_left;
   property frameimage_top;
   property frameimage_right;
   property frameimage_bottom;
   property frameimage_offset;
   property frameimage_offsetmouse;
   property frameimage_offsetclicked;
   property frameimage_offsetactive;
   property frameimage_offsetactivemouse;
   property frameimage_offsetactiveclicked;
   
   property optionsskin;

   property sbhorz: tscrollbar read getsbhorz write setsbhorz;
   property sbvert: tscrollbar read getsbvert write setsbvert;
   property colorclient;
   property caption;
   property captionpos;
   property captiondist;
   property captiondistouter;
   property captionoffset;
   property captionnoclip;
   property font;
   property localprops; //before template
   property template;
 end;

 tcustomthumbtrackscrollframe = class(tcustomscrollframe)
  protected
   function getscrollbarclass(vert: boolean): framescrollbarclassty; override;
 end;
 
 iscrollbox = interface(iscrollbar)
  function getscrollsize: sizety;
 end;

 tcustomscrollboxframe = class(tcustomscrollframe,iscrollbox)
  private
   fscrolling: integer;
   fclientheight: integer;
   fclientwidth: integer;
   fowner: twidget;
   procedure clientrecttoscrollbar(const rect: rectty);
   procedure scrollpostoclientpos(var aclientrect: rectty);
   procedure setclientheigth(const Value: integer);
   procedure setclientwidth(const Value: integer);
   procedure calcclientrect(var aclientrect: rectty);
   function getwidget: twidget;
   procedure setsbhorz(const avalue: tscrollboxscrollbar);
   function getsbhorz: tscrollboxscrollbar;
   procedure setsbvert(const avalue: tscrollboxscrollbar);
   function getsbvert: tscrollboxscrollbar;
  protected
   procedure initinnerframe; virtual;
   function getscrollbarclass(vert: boolean): framescrollbarclassty; override;
   procedure updatevisiblescrollbars; override;
   procedure scrollevent(sender: tcustomscrollbar; event: scrolleventty); virtual;
   //iscrollbar
   function translatecolor(const acolor: colorty): colorty;
   procedure invalidaterect(const rect: rectty; org: originty);
    //iscrollbox
   function getscrollsize: sizety;
  public
   constructor create(const intf: iscrollframe; const owner: twidget);
   procedure updateclientrect; override;
   procedure showrect(const arect: rectty; const bottomright: boolean); 
                           //origin paintpos
   property clientwidth: integer read fclientwidth write setclientwidth default 0;
   property clientheight: integer read fclientheight write setclientheigth default 0;
   property framei_left default 2;
   property framei_top default 2;
   property framei_right default 2;
   property framei_bottom default 2;
   property sbhorz: tscrollboxscrollbar read getsbhorz write setsbhorz;
   property sbvert: tscrollboxscrollbar read getsbvert write setsbvert;
 end;

 tscrollboxframe = class(tcustomscrollboxframe)
  published
   property clientwidth;
   property clientheight;
   property levelo;
   property leveli;
   property framewidth;
   property colorframe;
   property colorframeactive;
   property colordkshadow;
   property colorshadow;
   property colorlight;
   property colorhighlight;
   property colordkwidth;
   property colorhlwidth;
   property colorclient;
   property framei_left;
   property framei_top;
   property framei_right;
   property framei_bottom;

   property frameimage_list;
   property frameimage_left;
   property frameimage_top;
   property frameimage_right;
   property frameimage_bottom;
   property frameimage_offset;
   property frameimage_offsetmouse;
   property frameimage_offsetclicked;
   property frameimage_offsetactive;
   property frameimage_offsetactivemouse;
   property frameimage_offsetactiveclicked;
   
   property optionsskin;

   property caption;
   property captionpos;
   property captiondist;
   property captiondistouter;
   property captionoffset;
   property captionnoclip;
   property font;
   property localprops; //before template
   property template;
   property sbhorz;
   property sbvert;
 end;

 stepkindty = (sk_right,sk_up,sk_left,sk_down,sk_first,sk_last);
 stepkindsty = set of stepkindty;

 istepbar = interface
  function translatecolor(const aclor: colorty): colorty;
  procedure invalidaterect(const rect: rectty; org: originty);
  procedure dostep(const event: stepkindty);
 end;
 stepbuttonposty = (sbp_right,sbp_top,sbp_left,sbp_bottom);

 framestepinfoty = record
  down,up,pagedown,pageup,pagelast: integer;
 end;

const
 defaultstepbuttonsize = 13;

type
 tcustomstepframe = class(tcustomcaptionframe)
  private
   fstepintf: istepbar;
   fbuttonsize: integer;
   fbuttons: shapeinfoarty;
   fdim: rectty;
   fcolorbutton: colorty;
   fbuttonpos: stepbuttonposty;
   fbuttonslast: boolean;
   fdisabledbuttons: stepkindsty;
   fneededbuttons: stepkindsty;
   fforceinvisiblebuttons: stepkindsty;
   fforcevisiblebuttons: stepkindsty;
   fbuttonsinline: boolean;
   fmousewheel: boolean;
   procedure setbuttonsize(const Value: integer);
   procedure setbuttonpos(const Value: stepbuttonposty);
   procedure setbuttonsinline(const value: boolean);
   procedure setbuttonslast(const avalue: boolean);
   procedure setcolorbutton(const avalue: colorty);
   procedure setdisabledbuttons(const avalue: stepkindsty);
   procedure setbuttonsinvisible(const avalue: stepkindsty);
   procedure setbuttonsvisible(const avalue: stepkindsty);
   procedure setneededbuttons(const avalue: stepkindsty);
  protected
   procedure layoutchanged;
   procedure updaterects; override;
   procedure getpaintframe(var frame: framety); override;
   procedure updatelayout;
   procedure execute(const tag: integer; const info: mouseeventinfoty);
   property neededbuttons: stepkindsty read fneededbuttons write setneededbuttons;
  public
   constructor create(const intf: icaptionframe; const stepintf: istepbar);
   procedure updatemousestate(const sender: twidget; const apos: pointty); override;
   procedure mouseevent(var info: mouseeventinfoty); virtual;
   procedure domousewheelevent(var info: mousewheeleventinfoty); virtual;
   procedure paintoverlay(const canvas: tcanvas; const arect: rectty); override;
   procedure updatebuttonstate(const first,delta,count: integer);
   function executestepevent(const event: stepkindty; const stepinfo: framestepinfoty;
               const aindex: integer): integer;
   property buttonsize: integer read fbuttonsize write setbuttonsize default defaultstepbuttonsize;
   property colorbutton: colorty read fcolorbutton write setcolorbutton default cl_parent;
   property disabledbuttons: stepkindsty read fdisabledbuttons
              write setdisabledbuttons default [];
   property buttonsinvisible: stepkindsty read fforceinvisiblebuttons
              write setbuttonsinvisible default [sk_first,sk_last];
   property buttonsvisible: stepkindsty read fforcevisiblebuttons
              write setbuttonsvisible default [];
   property buttonpos: stepbuttonposty read fbuttonpos write setbuttonpos default sbp_right;
   property buttonslast: boolean read fbuttonslast write setbuttonslast default false;
   property buttonsinline: boolean read fbuttonsinline write setbuttonsinline default false;
   property mousewheel: boolean read fmousewheel write fmousewheel default true;
 end;

 tstepframe = class(tcustomstepframe)
  published
   property options;
   property levelo;
   property leveli;
   property framewidth;
   property colorframe;
   property colorframeactive;
   property colordkshadow;
   property colorshadow;
   property colorlight;
   property colorhighlight;
   property colordkwidth;
   property colorhlwidth;
   property colorclient;
   property colorbutton;
   property framei_left;
   property framei_top;
   property framei_right;
   property framei_bottom;

   property frameimage_list;
   property frameimage_left;
   property frameimage_top;
   property frameimage_right;
   property frameimage_bottom;
   property frameimage_offset;
   property frameimage_offsetmouse;
   property frameimage_offsetclicked;
   property frameimage_offsetactive;
   property frameimage_offsetactivemouse;
   property frameimage_offsetactiveclicked;
   
   property optionsskin;
 
   property caption;
   property captionpos;
   property font;
   property localprops; //before template
   property template;
   property disabledbuttons;
   property buttonsvisible;
   property buttonsinvisible;
   property buttonsize;
   property buttonpos;
   property buttonslast;
   property buttonsinline;
   property mousewheel;
 end;

 queryeventty = procedure(const sender: tobject; var answer: boolean) of object;
 popupeventty = procedure(const sender: tobject; var amenu: tpopupmenu;
                     var mouseinfo: mouseeventinfoty) of object;

 tactionwidget = class(twidget)
  private
   fpopupmenu: tpopupmenu;
   fonpopup: popupeventty;
   fonshowhint: showhinteventty;
   fonenter: notifyeventty;
   fonexit: notifyeventty;
   fonfocus: notifyeventty;
   fondefocus: notifyeventty;
   fonactivate: notifyeventty;
   fondeactivate: notifyeventty;
   procedure setpopupmenu(const Value: tpopupmenu);
   function getframe: tcaptionframe;
   procedure setframe(const value: tcaptionframe);
   function getface: tface;
   procedure setface(const Value: tface);
  protected
   procedure clientmouseevent(var info: mouseeventinfoty); override;
   procedure showhint(var info: hintinfoty); override;
   procedure dopopup(var amenu: tpopupmenu; var mouseinfo: mouseeventinfoty); virtual;
   procedure doenter; override;
   procedure doexit; override;
   procedure dofocus; override;
   procedure dodefocus; override;
   procedure doactivate; override;
   procedure dodeactivate; override;
   procedure internalcreateframe; override;
   procedure enabledchanged; override;
   property frame: tcaptionframe read getframe write setframe;
   property face: tface read getface write setface;
   property popupmenu: tpopupmenu read fpopupmenu write setpopupmenu;
   property onpopup: popupeventty read fonpopup write fonpopup;
   property onshowhint: showhinteventty read fonshowhint write fonshowhint;
   property onenter: notifyeventty read fonenter write fonenter;
   property onexit: notifyeventty read fonexit write fonexit;
   property onfocus: notifyeventty read fonfocus write fonfocus;
   property ondefocus: notifyeventty read fondefocus write fondefocus;
   property onactivate: notifyeventty read fonactivate write fonactivate;
   property ondeactivate: notifyeventty read fondeactivate write fondeactivate;
 end;

 tactionpublishedwidget = class(tactionwidget)
  published
   property optionswidget;
   property optionsskin;
   property bounds_x;
   property bounds_y;
   property bounds_cx;
   property bounds_cy;
   property bounds_cxmin;
   property bounds_cymin;
   property bounds_cxmax;
   property bounds_cymax;
   property color;
   property cursor;
   property frame;
   property face;
   property anchors;
   property taborder;
   property hint;
   property popupmenu;
   property onpopup;
   property onshowhint;
   property onenter;
   property onexit;
   property onfocus;
   property ondefocus;
   property onactivate;
   property ondeactivate;
 end;

 tpublishedwidget = class(tactionpublishedwidget)
  published
   property enabled;
   property visible;
 end;

 tcustomeventwidget = class(tpublishedwidget)
  private
   fonloaded: notifyeventty;
   fonmouseevent: mouseeventty;
   fonmousewheelevent: mousewheeleventty;
   fonchildmouseevent: mouseeventty;
   fonclientmouseevent: mouseeventty;
   fonkeyup: keyeventty;
   fonkeydown: keyeventty;
   fonshortcut: keyeventty;
//   fonenter: notifyeventty;
//   fonexit: notifyeventty;
//   fonfocus: notifyeventty;
//   fondefocus: notifyeventty;
   fonpaint: painteventty;
   fonbeforepaint: painteventty;
   fonafterpaint: painteventty;
   fonmove: notifyeventty;
   fonresize: notifyeventty;
   fonhide: notifyeventty;
   fonshow: notifyeventty;
//   fonactivate: notifyeventty;
//   fondeactivate: notifyeventty;
   fonclosequery: queryeventty;
   fonevent: eventeventty;
   fonasyncevent: asynceventeventty;
   fonfocusedwidgetchanged: focuschangeeventty;
   fonpaintbackground: painteventty;
  protected
   procedure poschanged; override;
   procedure sizechanged; override;
   procedure dobeforepaint(const canvas: tcanvas); override;
   procedure dopaintbackground(const canvas: tcanvas); override;
   procedure doonpaint(const canvas: tcanvas); override;
   procedure doafterpaint(const canvas: tcanvas); override;
   procedure mouseevent(var info: mouseeventinfoty); override;
   procedure clientmouseevent(var info: mouseeventinfoty); override;
   procedure childmouseevent(const sender: twidget; var info: mouseeventinfoty); override;
   procedure domousewheelevent(var info: mousewheeleventinfoty); override;
   procedure dokeydown(var info: keyeventinfoty); override;
   procedure dokeyup(var info: keyeventinfoty); override;
   procedure doshortcut(var info: keyeventinfoty; const sender: twidget); override;
   procedure dofocuschanged(const oldwidget,newwidget: twidget); override;
//   procedure doenter; override;
//   procedure doexit; override;
//   procedure dofocus; override;
//   procedure dodefocus; override;
   procedure doloaded; override;
   procedure dohide; override;
   procedure doshow; override;
//   procedure doactivate; override;
//   procedure dodeactivate; override;
   procedure receiveevent(const event: tobjectevent); override;
   procedure doasyncevent(var atag: integer); override;
  public
   function canclose(const newfocus: twidget): boolean; override;
//   property onenter: notifyeventty read fonenter write fonenter;
//   property onexit: notifyeventty read fonexit write fonexit;
//   property onfocus: notifyeventty read fonfocus write fonfocus;
//   property ondefocus: notifyeventty read fondefocus write fondefocus;
   property onfocusedwidgetchanged: focuschangeeventty 
                     read fonfocusedwidgetchanged write fonfocusedwidgetchanged;

   property onmouseevent: mouseeventty read fonmouseevent write fonmouseevent;
   property onchildmouseevent: mouseeventty read fonchildmouseevent
                        write fonchildmouseevent;
   property onclientmouseevent: mouseeventty read fonclientmouseevent 
                                             write fonclientmouseevent;
   property onmousewheelevent: mousewheeleventty read fonmousewheelevent 
                                             write fonmousewheelevent;

   property onkeydown: keyeventty read fonkeydown write fonkeydown;
   property onkeyup: keyeventty read fonkeyup write fonkeyup;
   property onshortcut: keyeventty read fonshortcut write fonshortcut;

   property onloaded: notifyeventty read fonloaded write fonloaded;

   property onbeforepaint: painteventty read fonbeforepaint write fonbeforepaint;
   property onpaintbackground: painteventty read fonpaintbackground write fonpaintbackground;
   property onpaint: painteventty read fonpaint write fonpaint;
   property onafterpaint: painteventty read fonafterpaint write fonafterpaint;

   property onshow: notifyeventty read fonshow write fonshow;
   property onhide: notifyeventty read fonhide write fonhide;
//   property onactivate: notifyeventty read fonactivate write fonactivate;
//   property ondeactivate: notifyeventty read fondeactivate write fondeactivate;
   property onresize: notifyeventty read fonresize write fonresize;
   property onmove: notifyeventty read fonmove write fonmove;
   property onclosequery: queryeventty read fonclosequery write fonclosequery;

   property onevent: eventeventty read fonevent write fonevent;
   property onasyncevent: asynceventeventty read fonasyncevent write fonasyncevent;
 end;

 const
  defaultoptionstoplevelwidget = defaultoptionswidget + [ow_subfocus];

type

 ttoplevelwidget = class(tcustomeventwidget)
  public
   constructor create(aowner: tcomponent); override;
   property visible default false;
   property optionswidget default defaultoptionstoplevelwidget;
  published
   property optionsskin default defaultcontainerskinoptions;
 end;

 tcaptionwidget = class(ttoplevelwidget)
  private
   fcaption: msestring;
  protected
   function getcaption: msestring; virtual;
   procedure setcaption(const Value: msestring); virtual;
   procedure windowcreated; override;
  public
   property caption: msestring read getcaption write setcaption;
 end;

 tscrollbarwidget = class(tcustomeventwidget,iscrollbar)
  private
   function getframe: tscrollframe;
   procedure setframe(const Value: tscrollframe);
  protected
   procedure internalcreateframe; override;
   procedure mouseevent(var info: mouseeventinfoty); override;
   procedure scrollevent(sender: tcustomscrollbar; event: scrolleventty); virtual;
  public
   constructor create(aowner: tcomponent); override;
  published
   property frame: tscrollframe read getframe write setframe;
 end;

 iautoscrollframe = interface
  function getscrollrect: rectty;
  procedure setscrollrect(const rect: rectty);
  procedure scrollevent(sender: tcustomscrollbar; event: scrolleventty);
 end;

 tcustomautoscrollframe = class(tcustomscrollboxframe)
  private
   function getscrollpos: pointty;
   procedure setscrollpos(const avalue: pointty);
   function getscrollpos_x: integer;
   procedure setscrollpos_x(const avalue: integer);
   function getscrollpos_y: integer;
   procedure setscrollpos_y(const avalue: integer);
  protected
   fintf1: iautoscrollframe;
   procedure scrollevent(sender: tcustomscrollbar; event: scrolleventty); override;
   procedure updaterects; override;
  public
   constructor create(const intf: iscrollframe; const owner: twidget;
                 const autoscrollintf: iautoscrollframe);
   procedure updateclientrect; override;
   property scrollpos: pointty read getscrollpos write setscrollpos;
   property scrollpos_x: integer read getscrollpos_x write setscrollpos_x;
   property scrollpos_y: integer read getscrollpos_y write setscrollpos_y;
               //origin = paintpos
 end;

 fontheightdeltaeventty = procedure (const sender: tobject;
                     var delta: integer) of object;

 tscrollface = class(tface)
  public
   procedure paint(const canvas: tcanvas; const rect: rectty); override;
 end;

 tscrollingwidget = class;
 calcminscrollsizeeventty = procedure(const sender: tscrollingwidget;
                                  var asize: sizety) of object;
 
 tscrollingwidget = class(tcustomeventwidget)
  private
   fonscroll: pointeventty;
   fonfontheightdelta: fontheightdeltaeventty;
   fonchildscaled: notifyeventty;
   foncalcminscrollsize: calcminscrollsizeeventty;
   fminclientsize: sizety;
   function getframe: tscrollboxframe;
   procedure setframe(const Value: tscrollboxframe);
   procedure setclientpos(const avalue: pointty);
  protected
   fminminclientsize: sizety; //exteded in design mode
   procedure widgetregionchanged(const sender: twidget); override;
   procedure sizechanged; override;
   procedure minscrollsizechanged;
   procedure dofontheightdelta(var delta: integer); override;
   procedure internalcreateframe; override;
   procedure doscroll(const dist: pointty); override;
   procedure mouseevent(var info: mouseeventinfoty); override;
   procedure domousewheelevent(var info: mousewheeleventinfoty); override;
   procedure writestate(writer: twriter); override;
   procedure internalcreateface; override;
   function calcminscrollsize: sizety; override;
   procedure setclientsize(const asize: sizety); override;
   procedure loaded; override;
   procedure clampinview(const arect: rectty; const bottomright: boolean); override;
                //origin paintpos
 public
   constructor create(aowner: tcomponent); override;
   function maxclientsize: sizety; override;
   procedure dochildscaled(const sender: twidget); override;
   property onscroll: pointeventty read fonscroll write fonscroll;
   property onfontheightdelta: fontheightdeltaeventty read fonfontheightdelta
                     write fonfontheightdelta;
   property onchildscaled: notifyeventty read fonchildscaled write fonchildscaled;
   property oncalcminscrollsize: calcminscrollsizeeventty 
                   read foncalcminscrollsize write foncalcminscrollsize;
   property scrollpos: pointty read getclientpos write setclientpos;
  published
   property frame: tscrollboxframe read getframe write setframe;
   property optionswidget default defaultoptionswidgetmousewheel;
   property optionsskin default defaultcontainerskinoptions;
 end;

 tpopupwidget = class(ttoplevelwidget)
  private
   ftransientfor: twindow;
  protected
   procedure updatewindowinfo(var info: windowinfoty); override;
   function internalshow(const modal: boolean; transientfor: twindow;
           const windowevent: boolean): modalresultty; override;
  public
   constructor create(aowner: tcomponent; transientfor: twindow); reintroduce; overload;
 end;

 thintwidget = class(tpopupwidget)
  private
   fcaption: captionty;
  protected
   procedure dopaint(const canvas: tcanvas); override;
  public
   constructor create(aowner: tcomponent; transientfor: twindow;
                             var info: hintinfoty);
destructor destroy; override;
 end;

 tmessagewidget = class(tcaptionwidget)
  private
   fpopuptransient: boolean;
   fhasaction: boolean;
  protected
   procedure updatewindowinfo(var info: windowinfoty); override;
   procedure dokeydown(var info: keyeventinfoty); override;
   function getcaption: msestring; override;
   procedure setcaption(const Value: msestring); override;
   procedure internalcreateframe; override;
  public
   constructor create(const aowner: tcomponent; const apopuptransient: boolean;
                        const ahasaction: boolean);
                               reintroduce;
   function canclose(const newfocus: twidget): boolean; override;
 end;

 buttonoptionty = (bo_executeonclick,bo_executeonkey,bo_executeonshortcut,
                   bo_executedefaultonenterkey,
                   bo_asyncexecute,
                   bo_focusonshortcut, //for tcustombutton
                   bo_shortcutcaption,
                   {bo_flat,bo_noanim,bo_nofocusrect,bo_nodefaultrect,}
                   bo_nodefaultframeactive
                   );
 buttonoptionsty = set of buttonoptionty;

const
 defaultbuttonoptions = [bo_executeonclick,bo_executeonkey,
                         bo_executeonshortcut,bo_executedefaultonenterkey];

type
 tactionsimplebutton = class(tactionpublishedwidget)
  private
   foptions: buttonoptionsty;
   procedure setcolorglyph(const value: colorty);
  protected
   finfo: shapeinfoty;
   class function classskininfo: skininfoty; override;
   procedure setoptions(const avalue: buttonoptionsty); virtual;
   procedure internalexecute;
   procedure doshapeexecute(const atag: integer; const info: mouseeventinfoty);
   procedure doexecute; virtual;
   procedure doasyncevent(var atag: integer); override;
   procedure statechanged; override;
   procedure clientmouseevent(var info: mouseeventinfoty); override;
   procedure dokeydown(var info: keyeventinfoty); override;
   procedure dokeyup(var info: keyeventinfoty); override;
   procedure dopaint(const canvas: tcanvas); override;
   procedure clientrectchanged; override;
//   procedure setoptionswidget(const avalue: optionswidgetty); override;
   function getframeclicked: boolean; override;
   function getframemouse: boolean; override;
   function getframeactive: boolean; override;
  public
   constructor create(aowner: tcomponent); override;
   property options: buttonoptionsty read foptions write setoptions
                 default defaultbuttonoptions;
   property colorglyph: colorty read finfo.colorglyph write setcolorglyph
                    default cl_black;
   property focusrectdist: integer read finfo.focusrectdist 
                write finfo.focusrectdist default defaultshapefocusrectdist;
  published
   property optionswidget default defaultoptionswidget - [ow_mousefocus];
 end;

 tsimplebutton = class(tactionsimplebutton)
//  published
//   property enabled;
//   property visible;
 end;

procedure getdropdownpos(const parent: twidget; var rect: rectty);


//following routines are thread save
//exttext will be appended for copy to clipboard
function showmessage(const atext,caption: msestring;
                     const buttons: array of modalresultty;
                     const defaultbutton: modalresultty = mr_cancel;
                     const noshortcut: modalresultsty = [];
                     const minwidth: integer = 0;
                     const exttext: msestring = ''): modalresultty; overload;
function showmessage(const atext,caption: msestring;
                     const buttons: array of modalresultty;
                     const defaultbutton: modalresultty;
                     const noshortcut: modalresultsty;
                     const minwidth: integer;
                     const actions: array of notifyeventty;
                     const exttext: msestring = ''): modalresultty; overload;
function showmessage(const atext,caption: msestring;
                     const buttons: array of modalresultty;
                     const adest: rectty; const awidget: twidget = nil;
                     //origin = awidget.clientpos, screen if awidget = nil
                     const placement: captionposty = cp_bottomleft;
                     const defaultbutton: modalresultty = mr_cancel;
                     const noshortcut: modalresultsty = [];
                     const minwidth: integer = 0;
                     const exttext: msestring = ''): modalresultty; overload;
function showmessage(const atext: msestring; const caption: msestring = '';
                     const minwidth: integer = 0;
                     const exttext: msestring = ''): modalresultty; overload;
procedure showmessage1(const atext: msestring; const caption: msestring);
            //for ps
procedure showerror(const atext: msestring; const caption: msestring = 'ERROR';
                     const minwidth: integer = 0;
                     const exttext: msestring = '');
function askok(const atext: msestring; const caption: msestring = '';
                     const defaultbutton: modalresultty = mr_ok;  
                     const minwidth: integer = 0): boolean;
                             //true if ok pressed
function askyesno(const atext: msestring; const caption: msestring = '';
                     const defaultbutton: modalresultty = mr_yes;  
                     const minwidth: integer = 0): boolean;
                            //true if yes pressed
function askyesnocancel(const atext: msestring; const caption: msestring = '';
                     const defaultbutton: modalresultty = mr_yes;  
                     const minwidth: integer = 0): modalresultty;
function confirmsavechangedfile(const filename: filenamety;
               out modalresult: modalresultty; multiple: boolean = false): boolean;
//end threadsave routines

procedure copytoclipboard(const value: msestring);
function canpastefromclipboard: boolean;
function pastefromclipboard(out value: msestring): boolean;
            //false if empty
function placepopuprect(const awindow: twindow; const adest: rectty; //screenorig
                 const placement: captionposty; const asize: sizety): rectty; overload;
 //placement actually only cp_bottomleft
 //todo
function placepopuprect(const awidget: twidget; const adest: rectty; //clientorig
                 const placement: captionposty; const asize: sizety): rectty; overload;
procedure getwindowicon(const abitmap: tmaskedbitmap; out aicon,amask: pixmapty);
{
procedure buttonoptionstoshapestate(avalue: buttonoptionsty;
                                              var astate: shapestatesty);
}
implementation

uses
 msebits,mseguiintf,msestockobjects,msekeyboard,sysutils,msemenuwidgets,mseactions;

const
 captionmargin = 1; //distance focusrect to caption in tcaptionframe

type
 twidget1 = class(twidget);
 twindow1 = class(twindow);
 tcustomscrollbar1 = class(tcustomscrollbar);
 tbitmap1 = class(tbitmap);

 tmessagebutton = class(tsimplebutton)
  protected
   modalresult: modalresultty;
   procedure doexecute; override;
   procedure doshortcut(var info: keyeventinfoty; const sender: twidget); override;
  public
   onexecute: notifyeventty;
 end;

 tshowmessagewidget = class(tmessagewidget)
  protected
   info: drawtextinfoty;
   fexttext: msestring;
   procedure dopaint(const canvas: tcanvas); override;
   procedure dokeydown(var ainfo: keyeventinfoty); override;
  public
   constructor create(const aowner: tcomponent; const apopuptransient: boolean;
                        const ahasaction: boolean; const exttext: msestring);
end;
{
procedure buttonoptionstoshapestate(avalue: buttonoptionsty; var astate: shapestatesty);
begin
 if bo_flat in avalue then begin
  include(astate,ss_flat);
 end
 else begin
  exclude(astate,ss_flat);
 end;
 if bo_noanim in avalue then begin
  include(astate,ss_noanimation);
 end
 else begin
  exclude(astate,ss_noanimation);
 end;
 if bo_nofocusrect in avalue then begin
  exclude(astate,ss_showfocusrect);
 end
 else begin
  include(astate,ss_showfocusrect);
 end;
 if bo_nodefaultrect in avalue then begin
  exclude(astate,ss_showdefaultrect);
 end
 else begin
  include(astate,ss_showdefaultrect);
 end;
end;
}
procedure copytoclipboard(const value: msestring);
begin
 gui_copytoclipboard(value);
end;

function canpastefromclipboard: boolean;
begin
 result:= gui_canpastefromclipboard;
end;

function pastefromclipboard(out value: msestring): boolean;
begin
 result:= gui_pastefromclipboard(value) = gue_ok;
end;

function confirmsavechangedfile(const filename: filenamety;
         out modalresult: modalresultty; multiple: boolean = false): boolean;
begin
 if multiple then begin
  modalresult:= showmessage('File '+filename+' is modified. Save?','Confirmation',
                  [mr_yes,mr_all,mr_no,mr_noall,mr_cancel],mr_yes);
 end
 else begin
  modalresult:= showmessage('File '+filename+' is modified. Save?','Confirmation',
                  [mr_yes,mr_no,mr_cancel],mr_yes);
 end;
 if modalresult = mr_windowclosed then begin
  modalresult:= mr_cancel;
 end;
 result:= modalresult in [mr_yes,mr_all];
end;

procedure getdropdownpos(const parent: twidget; var rect: rectty);
var
 int1: integer;
 size1: sizety;
 workarea: rectty;
begin
 size1:= parent.framesize;
 rect.pos:= translatewidgetpoint(parent.framerect.pos,parent,nil);
 workarea:= application.workarea(parent.window);
 inc(rect.pos.y,size1.cy);
 if rect.y + rect.cy > workarea.cy then begin
  dec(rect.y,size1.cy + rect.cy);
 end;
 int1:= workarea.cx - (rect.x + rect.cx);
 if int1 < 0 then begin
  inc(rect.x,int1);
 end;
 if rect.x < 0 then begin
  rect.x:= 0;
 end;
end;

function placepopuprect(const awindow: twindow; const adest: rectty;
                 const placement: captionposty; const asize: sizety): rectty;
 //placement actually only cp_bottomleft
 //todo

var
 rect1: rectty;
 int1: integer;
begin
 result.size:= asize;
 with adest do begin
  result.x:= x;
  result.y:= y + cy;
  rect1:= application.workarea(awindow);
  with result do begin
   int1:= (rect1.x + rect1.cx) - (x + cx);
   if int1 < 0 then begin
    inc(x,int1);
    if x < rect1.x then begin
     x:= rect1.x;
    end;
   end;
   if y + cy > rect1.y + rect1.cy then begin
    y:= adest.y - asize.cy;
    if y < rect1.y then begin
     y:= rect1.y;
    end;
   end;
  end;
 end;
end;

function placepopuprect(const awidget: twidget; const adest: rectty; //widgetorig
                 const placement: captionposty; const asize: sizety): rectty;
begin
 result:= placepopuprect(awidget.window,moverect(adest,
               translateclientpoint(nullpoint,awidget,nil)),placement,asize);
end;

procedure getwindowicon(const abitmap: tmaskedbitmap; out aicon,amask: pixmapty);
var
 bmp: tmaskedbitmap;
begin
 aicon:= 0;
 amask:= 0;
 if abitmap <> nil then begin
  if abitmap.source <> nil then begin
   bmp:= abitmap.source.bitmap;
  end
  else begin
   bmp:= abitmap;
  end;
  if not bmp.isempty then begin
   aicon:= tbitmap1(bmp).handle;
   if bmp.masked then begin
    amask:= tbitmap1(bmp.mask).handle;
   end;
  end;
 end;
 if aicon = 0 then begin
  getwindowicon(stockobjects.mseicon,aicon,amask);
 end;
end;

function internalshowmessage(const atext,caption: msestring;
                  buttons: array of modalresultty;
                  defaultbutton: modalresultty;
                  noshortcut: modalresultsty;
                  placementrect: prectty; placement: captionposty;
                  minwidth: integer; actions: array of notifyeventty;
                  const exttext: msestring): modalresultty;
const
 maxtextwidth = 500;
 verttextdist = 10;
 horztextdist = 10;
 buttondist = 10;
var
 buttonheight: integer;
 buttonwidth: integer;
 widget: tshowmessagewidget;
 widget1: twidget; //dummy parent to get invisible canvas
 but: array[0..integer(high(modalresultty))] of tmessagebutton;
 int1,int2: integer;
 rect1,rect2: rectty;
 acanvas: tcanvas;
 textoffset: integer;
 transientfor: twindow;
 
begin 
 application.lock;
 try
  transientfor:= application.unreleasedactivewindow;
  widget1:= twidget.create(nil); 
  widget1.visible:= false;
        //stays invisible, no wm_configured processing on win32
  widget:= tshowmessagewidget.create(nil,(transientfor <> nil) and 
              (wo_popup in transientfor.options) and transientfor.owner.visible,
              high(actions) >= 0,exttext);
  widget.parentwidget:= widget1; //do not create window handle of widget
  try
   acanvas:= widget1.getcanvas; 
   buttonheight:= acanvas.font.glyphheight + 6;
   buttonwidth:= 50;
   for int1:= 0 to ord(high(buttons)) do begin
    int2:= acanvas.getstringwidth(
                stockobjects.modalresulttextnoshortcut[buttons[int1]]) + 10;
    if int2 > buttonwidth then begin
     buttonwidth:= int2;
    end;
   end;
   widget.caption:= caption;
   rect1:= textrect(acanvas,atext);
   if rect1.cx > maxtextwidth then begin
    rect1.cx:= maxtextwidth;
    rect1.cy:= bigint;
    rect1:= textrect(acanvas,atext,rect1,[tf_wordbreak]);
    widget.info.flags:= [tf_wordbreak];
   end;
   rect1.x:= horztextdist;
   rect1.y:= verttextdist;
   textoffset:= minwidth - rect1.cx;
   if textoffset > 0 then begin
    rect1.cx:= minwidth;
   end
   else begin
    textoffset:= 0;
   end;
   with widget.info do begin
    dest:= rect1;
    text.text:= atext;
   end;
   int1:= length(buttons);
   if int1 > 0 then begin
    int2:= int1 * buttonwidth;
    int2:= int2 + buttondist * (int1 - 1);
    inc(rect1.cy,buttonheight+verttextdist);
   end
   else begin
    int2:= 0;
   end;
   if int2 > rect1.cx then begin
    rect1.cx:= int2;         //width of buttons greater then text width
    widget.info.dest.cx:= int2;
   end;
 
   inc(rect1.cx,2*horztextdist);
   inc(rect1.cy,2*verttextdist);
   
   widget.parentwidget:= nil;  //remove dummy parent
   widget.clientsize:= rect1.size;
   if placementrect = nil then begin
 //   widget.widgetrect:= makerect(rect1.pos,addsize(rect1.size,widget.framewidth));
    widget.window.windowpos:= wp_screencentered;
   end
   else begin
    rect2:= placementrect^;
    dec(rect2.y,8);
    inc(rect2.cy,28); //for windowdecoration
    widget.widgetrect:= placepopuprect(transientfor,rect2,placement,widget.size);
   end;
 
   with widget.info.dest do begin
    rect1.x:= x + (cx - int2) div 2;
    rect1.y:= y + cy + verttextdist + widget.paintpos.y;
    rect1.cx:= buttonwidth;
    rect1.cy:= buttonheight;
   end;
   for int1:= 0 to high(buttons) do begin
    but[int1]:= tmessagebutton.create(widget);
    with but[int1] do begin
     widgetrect:= rect1;
     parentwidget:= widget;
     if buttons[int1] in noshortcut then begin
      captiontorichstring(stockobjects.modalresulttextnoshortcut[buttons[int1]],
                                 finfo.caption);
     end
     else begin
      captiontorichstring(stockobjects.modalresulttext[buttons[int1]],
                              finfo.caption);
     end;
     if int1 <= high(actions) then begin
      onexecute:= actions[int1];
     end;
     modalresult:= buttons[int1];
    end;
    if buttons[int1] = defaultbutton then begin
     widget.defaultfocuschild:= but[int1];
    end;
    inc(rect1.x,buttonwidth + buttondist);
   end;
   inc(widget.info.dest.x,textoffset div 2);
   dec(widget.info.dest.cx,textoffset);
   widget.updateskin(true);
   result:= widget.show(true,transientfor);
  finally
   widget1.free;
   widget.Free;
  end;
 finally
  application.unlock;
 end;
end;

function showmessage(const atext,caption: msestring;
                     const buttons: array of modalresultty;
                     const defaultbutton: modalresultty = mr_cancel;
                     const noshortcut: modalresultsty = [];
                     const minwidth: integer = 0;
                     const exttext: msestring = ''): modalresultty;
begin
 result:= internalshowmessage(atext,caption,buttons,defaultbutton,
                 noshortcut,nil,cp_bottomleft,minwidth,[],exttext);
end;

function showmessage(const atext,caption: msestring;
                     const buttons: array of modalresultty;
                     const defaultbutton: modalresultty;
                     const noshortcut: modalresultsty;
                     const minwidth: integer;
                     const actions: array of notifyeventty;
                     const exttext: msestring = ''): modalresultty;
begin
 result:= internalshowmessage(atext,caption,buttons,defaultbutton,
                 noshortcut,nil,cp_bottomleft,minwidth,actions,exttext);
end;

function showmessage(const atext,caption: msestring;
                     const buttons: array of modalresultty;
                     const adest: rectty; const awidget: twidget = nil;
                     //origin = awidget.clientpos, screen if awidget = nil
                     const placement: captionposty = cp_bottomleft;
                     const defaultbutton: modalresultty = mr_cancel;
                     const noshortcut: modalresultsty = [];
                     const minwidth: integer = 0;
                     const exttext: msestring = ''): modalresultty; overload;
var
 rect1: rectty;
begin
 if awidget = nil then begin
  rect1.pos:= adest.pos;
 end
 else begin
  rect1.pos:= translateclientpoint(adest.pos,awidget,nil);
 end;
 rect1.size:= adest.size;
 result:= internalshowmessage(atext,caption,buttons,defaultbutton,noshortcut,
                @rect1,placement,minwidth,[],exttext);
end;

function showmessage(const atext: msestring; const caption: msestring = '';
                        const minwidth: integer = 0;
                        const exttext: msestring = ''): modalresultty;
begin
 result:= showmessage(atext,caption,[mr_ok],mr_ok,[],minwidth,exttext);
end;

procedure showmessage1(const atext: msestring; const caption: msestring);
            //for ps
begin
 showmessage(atext,caption);
end;

procedure showerror(const atext: msestring; const caption: msestring = 'ERROR';
                    const minwidth: integer = 0;
                    const exttext: msestring = '');
begin
 showmessage(atext,caption,minwidth,exttext);
end;

function askok(const atext: msestring; const caption: msestring = '';
               const defaultbutton: modalresultty = mr_ok;  
               const minwidth: integer = 0): boolean;
                  //true if ok pressed
begin
 result:= showmessage(atext,caption,[mr_ok,mr_cancel],defaultbutton,[],
                    minwidth) = mr_ok;
end;

function askyesno(const atext: msestring; const caption: msestring = '';
                    const defaultbutton: modalresultty = mr_yes;  
                    const minwidth: integer = 0): boolean;
                  //true if yes pressed
begin
 result:= showmessage(atext,caption,[mr_yes,mr_no],defaultbutton,[],
                          minwidth) = mr_yes;
end;

function askyesnocancel(const atext: msestring; const caption: msestring = '';
                    const defaultbutton: modalresultty = mr_yes;  
                    const minwidth: integer = 0 ): modalresultty;
begin
 result:= showmessage(atext,caption,[mr_yes,mr_no,mr_cancel],defaultbutton,[],
                          minwidth);
end;

{ tframefont}

class function tframefont.getinstancepo(owner: tobject): pfont;
begin
 result:= @tcustomcaptionframe(owner).ffont;
end;

{ tactionsimplebutton}

constructor tactionsimplebutton.create(aowner: tcomponent);
begin
 foptions:= defaultbuttonoptions;
 inherited;
 optionswidget:= defaultoptionswidget - [ow_mousefocus];
 initshapeinfo(finfo);
 finfo.dim:= innerclientrect;
 finfo.color:= cl_transparent;
 finfo.colorglyph:= cl_black;
 finfo.doexecute:= {$ifdef FPC}@{$endif}doshapeexecute;
 finfo.state:= finfo.state+[ss_showfocusrect,ss_showdefaultrect];
end;
{
procedure tactionsimplebutton.setoptionswidget(const avalue: optionswidgetty);
begin
 if ow_nofocusrect in avalue then begin
  exclude(finfo.state,ss_showfocusrect);
 end
 else begin
  include(finfo.state,ss_showfocusrect);
 end;
 inherited;
end;
}
procedure tactionsimplebutton.clientrectchanged;
begin
 inherited;
 finfo.dim:= innerclientrect;
 frameskinoptionstoshapestate(fframe,finfo.state);
 if ss_flat in finfo.state then begin
  exclude(fwidgetstate1,ws1_nodesignframe);
 end
 else begin
  include(fwidgetstate1,ws1_nodesignframe);
 end;
end;

procedure tactionsimplebutton.doexecute;
begin
 //dummy
end;

procedure tactionsimplebutton.doasyncevent(var atag: integer);
begin
 if atag = 0 then begin
  doexecute;
 end;
end;

procedure tactionsimplebutton.internalexecute;
begin
 if bo_asyncexecute in foptions then begin
  asyncevent;
 end
 else begin
  doexecute;
 end;
end;

procedure tactionsimplebutton.doshapeexecute(const atag: integer;
                  const info: mouseeventinfoty);
begin
 internalexecute;
end;

procedure tactionsimplebutton.dopaint(const canvas: tcanvas);
begin
 inherited;
 drawbutton(canvas,finfo);
end;

procedure tactionsimplebutton.clientmouseevent(var info: mouseeventinfoty);
begin
 inherited;
 if not (csdesigning in componentstate) and 
        not (es_processed in info.eventstate) then begin
  updatemouseshapestate(finfo,info,self,nil,bo_executeonclick in foptions);
 end;
end;

procedure tactionsimplebutton.dokeydown(var info: keyeventinfoty);
begin
 inherited;
 if (info.shiftstate = []) and (bo_executeonkey in foptions) then begin
  if (info.key = key_space) then begin
   include(finfo.state,ss_clicked);
   invalidateframestaterect(finfo.dim);
  end
  else begin
   if isenterkey(info.key) then begin
    include(info.eventstate,es_processed);
    internalexecute;
   end;
  end;
 end;
end;

procedure tactionsimplebutton.dokeyup(var info: keyeventinfoty);
begin
 inherited;
 if (info.key = key_space) and (ss_clicked in finfo.state) then begin
  exclude(finfo.state,ss_clicked);
  invalidateframestaterect(finfo.dim);
  if (info.shiftstate = []) and (bo_executeonkey in foptions) then begin
   include(info.eventstate,es_processed);
   internalexecute;
  end;
 end;
end;

procedure tactionsimplebutton.statechanged;
begin
 inherited;
 updatewidgetshapestate(finfo,self);
end;

procedure tactionsimplebutton.setcolorglyph(const value: colorty);
begin
 if finfo.colorglyph <> value then begin
  finfo.colorglyph := value;
  invalidate;
 end;
end;

class function tactionsimplebutton.classskininfo: skininfoty;
begin
 result:= inherited classskininfo;
 result.objectkind:= sok_simplebutton;
end;

procedure tactionsimplebutton.setoptions(const avalue: buttonoptionsty);
begin
 if foptions <> avalue then begin
  foptions:= avalue;
//  buttonoptionstoshapestate(avalue,finfo.state);
  invalidate;
 end;
end;

function tactionsimplebutton.getframeclicked: boolean;
begin
 result:= ss_clicked in finfo.state;
end;

function tactionsimplebutton.getframemouse: boolean;
begin
 result:= ss_mouse in finfo.state;
end;

function tactionsimplebutton.getframeactive: boolean;
begin
 result:= not (bo_nodefaultframeactive in foptions) and 
                           (ss_default in finfo.state) or active;
end;

{ tmessagebutton }

procedure tmessagebutton.doexecute;
begin
 if assigned(onexecute) then begin
  onexecute(self);
 end;
 window.modalresult:= modalresult;
end;

procedure tmessagebutton.doshortcut(var info: keyeventinfoty; const sender: twidget);
begin
 if checkshortcut(info,finfo.caption,true) then begin
  include(info.eventstate,es_processed);
  internalexecute;
 end
 else begin
  inherited;
 end;
end;

{ tshowmessagewidget }

constructor tshowmessagewidget.create(const aowner: tcomponent;
           const apopuptransient: boolean; const ahasaction: boolean;
           const exttext: msestring);
begin
 fexttext:= exttext;
 inherited create(aowner,apopuptransient,ahasaction);
end;

procedure tshowmessagewidget.dopaint(const canvas: tcanvas);
begin
 inherited;
 drawtext(canvas,info);
end;

procedure tshowmessagewidget.dokeydown(var ainfo: keyeventinfoty);
begin
 if issysshortcut(sho_copy,ainfo) or issysshortcut(sho_cut,ainfo) then begin
  copytoclipboard(replacechar(info.text.text+fexttext,#0 ,' '));
 end;
 inherited;
end;

{ tcustomcaptionframe }

constructor tcustomcaptionframe.create(const intf: icaptionframe);
begin
 fcaptionpos:= cp_topleft;
 fcaptiondist:= 1;
 inherited create(intf);
 if ffont = nil then begin
  finfo.font:= icaptionframe(fintf).getframefont;
 end;
end;

destructor tcustomcaptionframe.destroy;
begin
 inherited;
 ffont.free;
end;

function tcustomcaptionframe.getcaption: msestring;
begin
 result:= richstringtocaption(finfo.text);
end;

procedure tcustomcaptionframe.setcaption(const Value: msestring);
begin
 captiontorichstring(value,finfo.text);
 internalupdatestate;
end;

procedure tcustomcaptionframe.setcaptionpos(const Value: captionposty);
begin
 if fcaptionpos <> value then begin
  fcaptionpos := Value;
  internalupdatestate;
 end;
end;

procedure tcustomcaptionframe.fontchanged(const sender: tobject);
begin
 internalupdatestate;
end;

procedure tcustomcaptionframe.fontcanvaschanged;
begin
 exclude(fstate,fs_rectsvalid);
end;

procedure tcustomcaptionframe.dopaintfocusrect(const canvas: tcanvas;
                            const rect: rectty);
begin
 if (fs_captionfocus in fstate) and (finfo.text.text <> '') then begin
  drawfocusrect(canvas,inflaterect(finfo.dest,captionmargin));
 end
 else begin
  inherited;
 end;
end;

procedure tcustomcaptionframe.paintoverlay(const canvas: tcanvas;
                                  const arect: rectty);
var
 reg1: regionty;
begin
 reg1:= 0;
 if not (fs_captionnoclip in fstate) and (finfo.text.text <> '') then begin
  reg1:= canvas.copyclipregion;
//  drawtext(canvas,finfo);
  canvas.subcliprect(inflaterect(finfo.dest,captionmargin));
 end;
 inherited;
 if reg1 <> 0 then begin
  canvas.clipregion:= reg1;
 end;
 if finfo.text.text <> '' then begin
  drawtext(canvas,finfo);
 end;
end;
{
procedure tcustomcaptionframe.afterpaint(const canvas: tcanvas);
begin
 if finfo.text.text <> '' then begin
  drawtext(canvas,finfo);
 end;
 inherited;
end;
}
procedure tcustomcaptionframe.createfont;
begin
 if ffont = nil then begin
  ffont:= tframefont.create;
  ffont.onchange:= {$ifdef FPC}@{$endif}fontchanged;
  finfo.font:= ffont;
 end;
end;

function tcustomcaptionframe.getfont: tframefont;
begin
// getoptionalobject(fintf.getcomponentstate,ffont,{$ifdef FPC}@{$endif}createfont);
 icaptionframe(fintf).getwidget.getoptionalobject(ffont,
                                         {$ifdef FPC}@{$endif}createfont);
 if ffont <> nil then begin
  result:= ffont;
 end
 else begin
  result:= tframefont(icaptionframe(fintf).getframefont);
 end;
end;

procedure tcustomcaptionframe.setfont(const Value: tframefont);
begin
 if value <> ffont then begin
  setoptionalobject(fintf.getcomponentstate,value,ffont,{$ifdef FPC}@{$endif}createfont);
  internalupdatestate;
  if ffont <> nil then begin
   finfo.font:= ffont;
  end
  else begin
   finfo.font:= icaptionframe(fintf).getframefont;
  end;
 end;
end;

function tcustomcaptionframe.isfontstored: Boolean;
begin
 result:= ffont <> nil;
end;

procedure tcustomcaptionframe.parentfontchanged;
begin
 inherited;
 if ffont = nil then begin
  finfo.font:= icaptionframe(fintf).getframefont;
  if not (ws_loadedproc in icaptionframe(fintf).getwidget.widgetstate) then begin
   internalupdatestate;
  end;
 end;
end;

procedure tcustomcaptionframe.visiblechanged;
begin
 inherited;
 if finfo.text.text <> '' then begin
  internalupdatestate;
 end;
end;

procedure tcustomcaptionframe.updaterects;
var
 canvas: tcanvas;
 fra1: framety;
 rect1,rect2: rectty;
 bo1: boolean;
begin
 inherited;
 fra1:= fouterframe;
 if (finfo.text.text <> '') and 
             twidget1(icaptionframe(fintf).getwidget).isvisible then begin
  updatebit({$ifdef FPC}longword{$else}word{$endif}(finfo.flags),ord(tf_grayed),fs_disabled in fstate);
  canvas:= icaptionframe(fintf).getcanvas;
  canvas.font:= getfont;
  finfo.dest:= textrect(canvas,finfo.text);
  rect1:= deflaterect(makerect(nullpoint,icaptionframe(fintf).getwidgetrect.size),
                                 fouterframe);
  bo1:= fs_captiondistouter in fstate;
  rect2:= inflaterect(finfo.dest,captionmargin);
  with rect2 do begin
   if fcaptionpos = cp_center then begin
    x:= (rect1.x + rect1.x + rect1.cx - rect2.cx) div 2 + fcaptiondist;
    y:= (rect1.y + rect1.y + rect1.cy - rect2.cy) div 2 + fcaptionoffset;
   end
   else begin
    case fcaptionpos of
     cp_lefttop,cp_left,cp_leftbottom: begin
      x:= rect1.x - fcaptiondist;
      if not bo1 then begin
       x:= x - cx;
      end;
     end;
     cp_topleft,cp_bottomleft: begin
      x:=  rect1.x + fcaptionoffset;
     end;
     cp_top,cp_bottom: begin
      x:= rect1.x + (rect1.cx - cx) div 2 + fcaptionoffset;
     end;
     cp_topright,cp_bottomright: begin
      x:= rect1.x + rect1.cx - cx + fcaptionoffset;
     end;
     cp_righttop,cp_right,cp_rightbottom: begin
      x:= rect1.x + rect1.cx + fcaptiondist;
      if bo1 then begin
       x:= x - cx;
      end;
     end;
    end;
    case fcaptionpos of
     cp_topleft,cp_top,cp_topright: begin
      y:= rect1.y - fcaptiondist;
      if not bo1 then begin
       y:= y - cy;
      end;
     end;
     cp_lefttop,cp_righttop: begin
      y:= rect1.y + fcaptionoffset;
     end;
     cp_left,cp_right: begin
      y:= rect1.y + (rect1.cy - cy) div 2 + fcaptionoffset;
     end;
     cp_leftbottom,cp_rightbottom: begin
      y:= rect1.y + rect1.cy - cy + fcaptionoffset;
     end;
     cp_bottomleft,cp_bottom,cp_bottomright: begin
      y:= rect1.y + rect1.cy + fcaptiondist;
      if bo1 then begin
       y:= y - cy;
      end;
     end;
    end;
   end;
   fouterframe.left:= rect1.x - x;
   if fouterframe.left < 0 then begin
    fouterframe.left:= 0;
   end;
   fouterframe.top:= rect1.y - y;
   if fouterframe.top < 0 then begin
    fouterframe.top:= 0;
   end;
   fouterframe.right:= x + cx - (rect1.x + rect1.cx);
   if fouterframe.right < 0 then begin
    fouterframe.right:= 0;
   end;
   fouterframe.bottom:= y + cy - (rect1.y + rect1.cy);
   if fouterframe.bottom < 0 then begin
    fouterframe.bottom:= 0;
   end;
  end;
  finfo.dest:= inflaterect(rect2,-captionmargin);
 end
 else begin
  fouterframe:= nullframe;
 end;
 subframe1(fra1,fouterframe);
 if not isnullframe(fra1) then begin
  subpoint1(finfo.dest.pos,pointty(fra1.topleft));
  if fupdating < 16 then begin
   inc(fupdating);
   try
    rect1:= icaptionframe(fintf).getwidgetrect;
    rect2:= deflaterect(rect1,fra1);
    if cfo_fixleft in foptions then begin
     rect2.x:= rect1.x;
     if cfo_fixright in foptions then begin
      rect2.cx:= rect1.cx;
     end;
    end
    else begin
     if cfo_fixright in foptions then begin
      rect2.x:= rect1.x+rect1.cx-rect2.cx;
     end;
    end;
    if cfo_fixtop in foptions then begin
     rect2.y:= rect1.y;
     if cfo_fixbottom in foptions then begin
      rect2.cy:= rect1.cy;
     end;
    end
    else begin
     if cfo_fixbottom in foptions then begin
      rect2.y:= rect1.y+rect1.cy-rect2.cy;
     end;
    end;
    icaptionframe(fintf).setwidgetrect(rect2);
   finally
    dec(fupdating);
   end;
  end;
 end;
 inherited;
end;

procedure tcustomcaptionframe.setcaptiondist(const Value: integer);
begin
 if fcaptiondist <> value then begin
  fcaptiondist := Value;
  internalupdatestate;
 end;
end;

procedure tcustomcaptionframe.setcaptionoffset(const Value: integer);
begin
 if fcaptionoffset <> value then begin
  fcaptionoffset := Value;
  internalupdatestate;
 end;
end;

function tcustomcaptionframe.getcaptiondistouter: boolean;
begin
 result:= fs_captiondistouter in fstate;
end;

procedure tcustomcaptionframe.setcaptiondistouter(const Value: boolean);
var
 size1: sizety;
begin
 if updatebit({$ifdef FPC}longword{$else}longword{$endif}(fstate),
       ord(fs_captiondistouter),value) then begin
  if (fintf.getcomponentstate * [csdesigning,csloading] = [csdesigning]) and
                            (caption <> '') then begin
   size1.cy:= font.glyphheight + 2 * captionmargin;
   size1.cx:= icaptionframe(fintf).getcanvas.getstringwidth(caption,getfont) + 
                        2 * captionmargin;
   case captionpos of
    cp_center: begin
    end;
    cp_lefttop,cp_left,cp_leftbottom,cp_rightbottom,cp_right,cp_righttop: begin
     if fs_captiondistouter in fstate then begin
      fcaptiondist:= fcaptiondist + size1.cx;
     end
     else begin
      fcaptiondist:= fcaptiondist - size1.cx;
     end;
    end;
    cp_topright,cp_top,cp_topleft,cp_bottomleft,cp_bottom,cp_bottomright: begin
     if fs_captiondistouter in fstate then begin
      fcaptiondist:= fcaptiondist + size1.cy;
     end
     else begin
      fcaptiondist:= fcaptiondist - size1.cy;
     end;
    end;
   end;
  end;
  internalupdatestate;
 end;
end;

function tcustomcaptionframe.getcaptionnoclip: boolean;
begin
 result:= fs_captionnoclip in fstate;
end;

procedure tcustomcaptionframe.setcaptionnoclip(const avalue: boolean);
begin
 if updatebit({$ifdef FPC}longword{$else}longword{$endif}(fstate),
       ord(fs_captionnoclip),avalue) then begin
  internalupdatestate;
 end;   
end;

procedure tcustomcaptionframe.defineproperties(filer: tfiler);
var
 bo1: boolean;
begin
 inherited;
 if filer.ancestor <> nil then begin
  bo1:= not frameisequal(fouterframe,tcustomcaptionframe(filer.ancestor).fouterframe);
 end
 else begin
  bo1:= not isnullframe(fouterframe);
 end;
 filer.DefineProperty('outerframe',{$ifdef FPC}@{$endif}readouterframe,
                  {$ifdef FPC}@{$endif}writeouterframe,bo1);
end;

procedure tcustomcaptionframe.readouterframe(reader: treader);
begin
 with fouterframe,reader do begin
  readlistbegin;
  left:= ReadInteger;
  top:= ReadInteger;
  right:= ReadInteger;
  bottom:= ReadInteger;
  readlistend;
 end;
end;

procedure tcustomcaptionframe.writeouterframe(writer: twriter);
begin
 with fouterframe,writer do begin
  writelistbegin;
  writeinteger(left);
  writeinteger(top);
  writeinteger(right);
  writeinteger(bottom);
  writelistend;
 end;
end;

function tcustomcaptionframe.checkshortcut(var info: keyeventinfoty): boolean;
begin
 result:= mserichstring.checkshortcut(info,finfo.text,true);
end;

procedure tcustomcaptionframe.setdisabled(const value: boolean);
var
 flags1: textflagsty;
begin
 inherited;
 flags1:= finfo.flags;
 updatebit({$ifdef FPC}longword{$else}word{$endif}(finfo.flags),
                 ord(tf_grayed),value);
 if finfo.flags <> flags1 then begin
  fintf.invalidatewidget;
 end;
end;

function tcustomcaptionframe.pointincaption(const point: pointty): boolean;
var
 rect1: rectty;
 int1: integer;
begin
 if finfo.text.text = '' then begin
  result:= false;
 end
 else begin
  checkstate;
  rect1:= finfo.dest;
  with rect1 do begin
   case fcaptionpos of
    cp_left,cp_lefttop,cp_leftbottom: begin
     int1:= fpaintrect.x - (x + cx);
     if int1 > 0 then begin
      inc(rect1.cx,int1);
     end;
    end;
    cp_top,cp_topleft,cp_topright: begin
     int1:= fpaintrect.y - (y + cy);
     if int1 > 0 then begin
      inc(rect1.cy,int1);
     end;
    end;
    cp_right,cp_righttop,cp_rightbottom: begin
     int1:= x - (fpaintrect.x + fpaintrect.cx);
     if int1 > 0 then begin
      dec(rect1.x,int1);
      inc(rect1.cx,int1);
     end;
    end;
    cp_bottom,cp_bottomleft,cp_bottomright: begin
     int1:= y - (fpaintrect.y + fpaintrect.cy);
     if int1 > 0 then begin
      dec(rect1.y,int1);
      inc(rect1.cy,int1);
     end;
    end;
   end;
  end;
  result:= pointinrect(point,rect1);
 end;
end;

procedure tcustomcaptionframe.updatemousestate(const sender: twidget;
        const apos: pointty);
begin
 inherited;
 if pointincaption(apos) then begin
  with twidget1(sender) do begin
   include(fwidgetstate,ws_wantmousebutton);    //for twidget.iswidgetclick
   if fs_captionfocus in fstate then begin
    include(fwidgetstate,ws_wantmousefocus);
   end;
   if fs_captionhint in fstate then begin
    include(fwidgetstate,ws_wantmousemove);
   end;
  end;
 end;
end;

procedure tcustomcaptionframe.scale(const ascale: real);
begin
 if ffont <> nil then begin
  ffont.scale(ascale);
 end;
 inherited;
end;

function tcustomcaptionframe.needsfocuspaint: boolean;
begin
 result:= inherited needsfocuspaint and not (cfo_nofocusrect in foptions);
end;

{ tcustomscrollframe }

constructor tcustomscrollframe.create(const intf: iscrollframe;
                                                const scrollintf: iscrollbar);
begin
 intf.setstaticframe(true);
 inherited create(intf);
 fhorz:= getscrollbarclass(false).create(scrollintf,org_widget,
             {$ifdef FPC}@{$endif}updatestate);
 fvert:= getscrollbarclass(true).create(scrollintf,org_widget,
             {$ifdef FPC}@{$endif}updatestate);
 fvert.tag:= 1;
 fvert.direction:= gd_down;
end;

destructor tcustomscrollframe.destroy;
begin
 fhorz.Free;
 fvert.free;
 inherited;
end;

procedure tcustomscrollframe.checktemplate(const sender: tobject);
                 //true if match
begin
 inherited;
 fhorz.checktemplate(sender);
 fvert.checktemplate(sender);
end;

function tcustomscrollframe.getscrollbarclass(vert: boolean): framescrollbarclassty;
begin
 result:= tcustomscrollbar;
end;

procedure tcustomscrollframe.getpaintframe(var frame: framety);
begin
 with frame do begin
  if fs_sbleft in fstate then inc(left,fvert.width);
  if fs_sbtop in fstate then inc(top,fhorz.width);
  if fs_sbright in fstate then inc(right,fvert.width);
  if fs_sbbottom in fstate then inc(bottom,fhorz.width);
 end;
end;

procedure tcustomscrollframe.mouseevent(var info: mouseeventinfoty);
begin
 if not (ws_clientmousecaptured in iscrollframe(fintf).widgetstate) then begin
  if fs_sbhorzon in fstate then begin
   fhorz.mouseevent(info);
  end;
  if fs_sbverton in fstate then begin
   fvert.mouseevent(info);
  end;
 end;
end;

procedure tcustomscrollframe.domousewheelevent(var info: mousewheeleventinfoty);
var
 scrollbar: tcustomscrollbar;
begin
 with info do begin
  if not (es_processed in eventstate) then begin
   if (fs_sbverton in fstate) then begin
    scrollbar:= sbvert;
   end
   else begin
    if fs_sbhorzon in fstate then begin
     scrollbar:= sbhorz;
    end
    else begin
     scrollbar:= nil;
    end;
   end;
   if scrollbar <> nil then begin
    include(eventstate,es_processed);
    case wheel of
     mw_up: begin
      scrollbar.wheeldown;
     end;
     mw_down: begin
      scrollbar.wheelup;
     end;
    end;
   end;
  end;
 end;
end;

procedure tcustomscrollframe.paintoverlay(const canvas: tcanvas;
                                 const arect: rectty);
begin
 inherited;
 if fs_sbverton in fstate then begin
  fvert.paint(canvas);
 end;
 if fs_sbhorzon in fstate then begin
  fhorz.paint(canvas);
 end;
end;

procedure tcustomscrollframe.updatemousestate(const sender: twidget;
         const apos: pointty);
begin
 inherited;
 if (fs_sbverton in fstate) and fvert.wantmouseevent(apos) or
    (fs_sbhorzon in fstate) and fhorz.wantmouseevent(apos) then begin
  with twidget1(sender) do begin
   fwidgetstate:= (fwidgetstate - [ws_mouseinclient]) +
                      [ws_wantmousebutton,ws_wantmousemove];
  end;
 end;
end;

procedure tcustomscrollframe.updaterects;
var
 rect1: rectty;
 int1,int2: integer;

 procedure checkvert;
 begin
  with tcustomscrollbar1(fvert) do begin
   if findentstart < 0 then begin
    int1:= 0;
   end
   else begin
    if findentstart = 0 then begin
     int1:= fpaintframedelta.top;
    end
    else begin
     int1:= findentstart;
    end;
   end;
   if findentend < 0 then begin
    int2:= 0;
   end
   else begin
    if findentend = 0 then begin
     int2:= fpaintframedelta.bottom;
    end
    else begin
     int2:= findentend;
    end;
   end;
  end;
 end;

 procedure checkhorz;
 begin
  with tcustomscrollbar1(fhorz) do begin
   if findentstart < 0 then begin
    int1:= 0;
   end
   else begin
    if findentstart = 0 then begin
     int1:= fpaintframedelta.left;
    end
    else begin
     int1:= findentstart;
    end;
   end;
   if findentend < 0 then begin
    int2:= 0;
   end
   else begin
    if findentend = 0 then begin
     int2:= fpaintframedelta.right;
    end
    else begin
     int2:= findentend;
    end;
   end;
  end;
 end;

begin
 fstate:= fstate - [fs_sbleft,fs_sbtop,fs_sbright,fs_sbbottom];
 if fs_sbhorzon in fstate then begin
  if fs_sbhorztop in fstate then begin
   include(fstate,fs_sbtop);
  end
  else begin
   include(fstate,fs_sbbottom);
  end;
 end;
 if fs_sbverton in fstate then begin
  if fs_sbvertleft in fstate then begin
   include(fstate,fs_sbleft);
  end
  else begin
   include(fstate,fs_sbright);
  end;
 end;
 inherited;
 rect1:= inflaterect(fpaintrect,fpaintframedelta);
 with rect1 do begin
  if fs_sbleft in fstate then begin
   checkvert;
   with fvert do begin
    dim:= makerect(x,y+int1,width,cy-int1-int2);
   end;
  end;
  if fs_sbright in fstate then begin
   checkvert;
   with fvert do begin
    dim:= makerect(x + cx-width,y+int1,width,cy-int1-int2);
   end;
  end;
  if fs_sbtop in fstate then begin
   checkhorz;
   with fhorz do begin
    dim:= makerect(x+int1,y,cx-int1-int2,width);
   end;
  end;
  if fs_sbbottom in fstate then begin
   checkhorz;
   with fhorz do begin
    dim:= makerect(x+int1,y+cy-width,cx-int1-int2,width);
   end;
  end;
 end;
end;

procedure tcustomscrollframe.updatevisiblescrollbars;
begin
 updatebit({$ifdef FPC}longword{$else}longword{$endif}(fstate),ord(fs_sbhorztop),
                sbo_opposite in fhorz.options);
 updatebit({$ifdef FPC}longword{$else}longword{$endif}(fstate),ord(fs_sbvertleft),
                sbo_opposite in fvert.options);
 if sbo_show in fhorz.options then begin
  include(fstate,fs_sbhorzon);
 end
 else begin
  if not (sbo_showauto in fhorz.options) then begin
   exclude(fstate,fs_sbhorzon);
  end
  else begin
   if fhorz.pagesize = 1 then begin
    exclude(fstate,fs_sbhorzon);
   end
   else begin
    include(fstate,fs_sbhorzon);
   end;
  end;
 end;
 if sbo_show in fvert.options then begin
  include(fstate,fs_sbverton);
 end
 else begin
  if not (sbo_showauto in fvert.options) then begin
   exclude(fstate,fs_sbverton);
  end
  else begin
   if fvert.pagesize = 1 then begin
    exclude(fstate,fs_sbverton);
   end
   else begin
    include(fstate,fs_sbverton);
   end;
  end;
 end;
end;

procedure tcustomscrollframe.updatestate;
var
 statebefore: framestatesty;
begin
 statebefore:= fstate;
 updatevisiblescrollbars;
 inherited;
 if ({$ifdef FPC}longword{$else}longword{$endif}(statebefore) xor
     {$ifdef FPC}longword{$else}longword{$endif}(fstate)) and
     {$ifdef FPC}longword{$else}longword{$endif}(scrollbarframestates) <> 0 then begin
  iscrollframe(fintf).getwidget.invalidatewidget;
 end;
end;

function tcustomscrollframe.getsbhorz: tcustomscrollbar;
begin
 result:= fhorz;
end;

procedure tcustomscrollframe.setsbhorz(const Value: tcustomscrollbar);
begin
 fhorz.assign(Value);
end;

function tcustomscrollframe.getsbvert: tcustomscrollbar;
begin
 result:= fvert;
end;

procedure tcustomscrollframe.setsbvert(const Value: tcustomscrollbar);
begin
 fvert.assign(Value);
end;

procedure tcustomscrollframe.activechanged;
begin
 inherited;
 fvert.activechanged;
 fhorz.activechanged;
end;

{ tcustomstepframe }

constructor tcustomstepframe.create(const intf: icaptionframe;
  const stepintf: istepbar);
begin
 fstepintf:= stepintf;
 fbuttonsize:= defaultstepbuttonsize;
 fforceinvisiblebuttons:= [sk_first,sk_last];
 fcolorbutton:= cl_parent;
 intf.setstaticframe(true);
 fmousewheel:= true;
 inherited create(intf);
end;

procedure tcustomstepframe.execute(const tag: integer; const info: mouseeventinfoty);
begin
 fstepintf.dostep(stepkindty(tag));
end;

procedure tcustomstepframe.getpaintframe(var frame: framety);
begin
 case fbuttonpos of
  sbp_right: begin
   inc(frame.right,fdim.cx);
  end;
  sbp_top: begin
   inc(frame.top,fdim.cy);
  end;
  sbp_left: begin
   inc(frame.left,fdim.cx);
  end;
  sbp_bottom: begin
   inc(frame.bottom,fdim.cy);
  end;
 end;
end;

procedure tcustomstepframe.layoutchanged;
var
 widget: twidget;
begin
 widget:= icaptionframe(fintf).getwidget;
 if not (csloading in widget.ComponentState) then begin
  updatestate;
  widget.invalidaterect(fdim,org_widget);
 end;
end;

procedure tcustomstepframe.mouseevent(var info: mouseeventinfoty);
var
 int1: integer;
begin
 for int1:= 0 to high(fbuttons) do begin
  if updatemouseshapestate(fbuttons[int1],info,nil) then begin
   icaptionframe(fintf).getwidget.invalidaterect(fbuttons[int1].dim,org_widget);
   if info.eventkind in [ek_buttonpress,ek_buttonrelease] then begin
    include(info.eventstate,es_processed);
   end;
  end;
 end;
end;

procedure tcustomstepframe.paintoverlay(const canvas: tcanvas; const arect: rectty);
var
 int1: integer;
begin
 inherited;
 for int1:= 0 to high(fbuttons) do begin
  drawtoolbutton(canvas,fbuttons[int1]);
 end;
end;

procedure tcustomstepframe.updatebuttonstate(const first,delta,count: integer);
var
 disabled: stepkindsty;
begin
 disabled:= [];
 if first = 0 then begin
  include(disabled,sk_left);
  include(disabled,sk_up);
  include(disabled,sk_first);
 end;
 if first >= count - 1 then begin
  include(disabled,sk_right);
  include(disabled,sk_down);
 end;
 disabledbuttons:= disabled;
 if (first+delta >= count) and (first <= 0) then begin
  neededbuttons:= [];
//  invisiblebuttons:= [sk_right,sk_up,sk_left,sk_down];
 end
 else begin
  neededbuttons:= [sk_right,sk_up,sk_left,sk_down,sk_first,sk_last];
//  invisiblebuttons:= forceinvisiblebuttons;
 end;
end;

function tcustomstepframe.executestepevent(const event: stepkindty;
                 const stepinfo: framestepinfoty; const aindex: integer): integer;
var
 steps: array[stepkindty] of integer;
begin
 with stepinfo do begin
  steps[sk_first]:= -bigint;
  steps[sk_last]:= pagelast;
  case fbuttonpos of
   sbp_right,sbp_left: begin
    steps[sk_right]:= up;
    steps[sk_left]:= down;
    steps[sk_up]:= pagedown;
    steps[sk_down]:= pageup;
   end;
   sbp_top: begin
    steps[sk_right]:= pageup;
    steps[sk_left]:= pagedown;
    steps[sk_up]:= down;
    steps[sk_down]:= up;
   end;
   else begin //sbp_bottom
    steps[sk_right]:= pageup;
    steps[sk_left]:= pagedown;
    steps[sk_up]:= down;
    steps[sk_down]:= up;
   end;
  end;
 end;
 result:= aindex + steps[event];
end;

procedure tcustomstepframe.setbuttonsize(const Value: integer);
begin
 if fbuttonsize <> value then begin
  fbuttonsize := Value;
  layoutchanged;
 end;
end;

procedure tcustomstepframe.setbuttonpos(const Value: stepbuttonposty);
begin
 if fbuttonpos <> value then begin
  fbuttonpos := Value;
  layoutchanged;
 end;
end;

procedure tcustomstepframe.setbuttonsinline(const Value: boolean);
begin
 if fbuttonsinline <> value then begin
  fbuttonsinline := Value;
  layoutchanged;
 end;
end;

procedure tcustomstepframe.setbuttonslast(const avalue: boolean);
begin
 if fbuttonslast <> avalue then begin
  fbuttonslast:= avalue;
  layoutchanged;
 end;
end;

procedure tcustomstepframe.setcolorbutton(const avalue: colorty);
begin
 if fcolorbutton <> avalue then begin
  fcolorbutton:= avalue;
  updatelayout;
  icaptionframe(fintf).getwidget.invalidaterect(fdim,org_widget);
 end;
end;

procedure tcustomstepframe.setdisabledbuttons(const avalue: stepkindsty);
begin
 if fdisabledbuttons <> avalue then begin
  fdisabledbuttons:= avalue;
  layoutchanged;
 end;
end;

procedure tcustomstepframe.setbuttonsinvisible(const avalue: stepkindsty);
begin
 if fforceinvisiblebuttons <> avalue then begin
  fforceinvisiblebuttons:= avalue;
  layoutchanged;
 end;
end;

procedure tcustomstepframe.setbuttonsvisible(const avalue: stepkindsty);
begin
 if fforcevisiblebuttons <> avalue then begin
  fforcevisiblebuttons:= avalue;
  layoutchanged;
 end;
end;

procedure tcustomstepframe.setneededbuttons(const avalue: stepkindsty);
begin
 if fneededbuttons <> avalue then begin
  fneededbuttons:= avalue;
  layoutchanged;
 end;
end;

procedure tcustomstepframe.updatelayout;
type
 buttonarty = array[stepkindty] of stepkindty;
const
 buttonpos1: array[boolean,stepbuttonposty] of buttonarty =
    (
     (                                   //not fbuttonsinline
      (sk_left,sk_right,sk_up,sk_down,sk_first,sk_last),  //sbp_right
      (sk_left,sk_up,sk_right,sk_down,sk_first,sk_last),  //sbp_top
      (sk_left,sk_right,sk_up,sk_down,sk_first,sk_last),  //sbp_left
      (sk_up,sk_left,sk_down,sk_right,sk_first,sk_last)   //sbp_bottom
     ),
     (                                   //fbuttonsinline
      (sk_left,sk_right,sk_up,sk_down,sk_first,sk_last),  //sbp_right
      (sk_up,sk_down,sk_left,sk_right,sk_first,sk_last),  //sbp_top
      (sk_left,sk_right,sk_up,sk_down,sk_first,sk_last),  //sbp_left
      (sk_up,sk_down,sk_left,sk_right,sk_first,sk_last)   //sbp_bottom
     )
    );
var
 buttoncount: integer;
 acx,acy: integer;
 ax,ay: integer;

 procedure checkbutton(button: stepkindty; vert: boolean);
 begin
  with fbuttons[ord(button)] do begin
   if button in fdisabledbuttons then begin
    include(state,ss_disabled);
   end
   else begin
    exclude(state,ss_disabled);
   end;
   if (button in fforcevisiblebuttons) or
        not (button in fforceinvisiblebuttons) and (button in fneededbuttons) then begin
    inc(buttoncount);
    dim.x:= ax;
    dim.y:= ay;
    if vert then begin
     inc(ay,acy);
    end
    else begin
     inc(ax,acx);
    end;
   end;
  end;
 end;

var
 a,b: integer;
 int1: integer;
 akind: stepkindty;
 bo1: boolean;
 bo2: boolean;
 color1: colorty;

begin             //updatelayout
 setlength(fbuttons,ord(high(stepkindty)) + 1);
 buttoncount:= 0;
 a:= 0; //compilerwarning
 b:= 0; //compilerwarning
 for akind:= low(stepkindty) to high(stepkindty) do begin
//  if not (akind in finvisiblebuttons) or (akind in fvisiblebuttons) then begin
  if (akind in fforcevisiblebuttons) or
        not (akind in fforceinvisiblebuttons) and (akind in fneededbuttons) then begin
   inc(buttoncount);
   exclude(fbuttons[ord(akind)].state,ss_invisible);
  end
  else begin
   include(fbuttons[ord(akind)].state,ss_invisible);
  end;
 end;
 if buttoncount = 0 then begin
  fdim.cx:= 0;
  fdim.cy:= 0;
 end
 else begin
  if not fbuttonsinline then begin
   a:= (buttoncount + 1) div 2;
   b:= (buttoncount + a - 1) div a;
   bo2:= a > 1;
  end
  else begin
   bo2:= false;
  end;
  if not bo2 then begin
   a:= buttoncount;
   b:= 1;
  end;
  if fbuttonpos in [sbp_left,sbp_right] then begin
   acy:= fpaintrect.cy div a;
   if acy > fbuttonsize then begin
    acy:= fbuttonsize;
   end;
   if fbuttonslast then begin
    ay:= fpaintrect.y + fpaintrect.cy - a * acy;
   end
   else begin
    ay:= fpaintrect.y;
   end;
   acx:= fbuttonsize;
   if fbuttonpos = sbp_left then begin
    ax:= fpaintrect.x - acx * b;
   end
   else begin
    ax:= fpaintrect.x + fpaintrect.cx;
   end;
  end
  else begin
   acx:= fpaintrect.cx div a;
   if acx > fbuttonsize then begin
    acx:= fbuttonsize;
   end;
   if fbuttonslast then begin
    ax:= fpaintrect.x;
   end
   else begin
    ax:= fpaintrect.x + fpaintrect.cx - a * acx;
   end;
   acy:= fbuttonsize;
   if fbuttonpos = sbp_top then begin
    ay:= fpaintrect.y - acy * b;
   end
   else begin
    ay:= fpaintrect.y + fpaintrect.cy;
   end;
  end;
  color1:= fcolorbutton;
  if (color1 = cl_parent) or (color1 = cl_default) then begin
   color1:= icaptionframe(fintf).getwidget.actualcolor;
  end;
  for int1:= 0 to high(fbuttons) do begin
   with fbuttons[int1] do begin
    imagelist:= stockobjects.glyphs;
    imagenr:= integer(stg_arrowrightsmall) + int1;
    imagenrdisabled:= -2;
    color:= color1;
    tag:= int1;
    doexecute:= {$ifdef FPC}@{$endif}execute;
    dim.cx:= acx;
    dim.cy:= acy;
   end;
  end;
  fdim.x:= ax;
  fdim.y:= ay;
  bo1:= fbuttonpos in [sbp_left,sbp_right];
  buttoncount:= 0;
  for akind:= low(stepkindty) to high(stepkindty) do begin
   if bo2 then begin
    if not odd(buttoncount) and (akind <> low(stepkindty)) then begin
     if bo1 then begin
      ax:= fdim.x;
     end
     else begin
      ay:= fdim.y;
     end;
    end;
     checkbutton(buttonpos1[fbuttonsinline][fbuttonpos][akind],not odd(buttoncount) xor bo1);
   end
   else begin
    checkbutton(buttonpos1[fbuttonsinline][fbuttonpos][akind],bo1);
   end;
  end;
  {
  if bo1 then begin  //left or right
   acx:= acx * b;
   acy:= acy * a;
  end
  else begin
   acx:= acx * a;
   acy:= acy * b;
   int2:= fpaintrect.cx-acx;
   for int1:= 0 to high(fbuttons) do begin
    inc(fbuttons[int1].dim.x,int2);
   end;
   inc(fdim.x,int2);
  end;
  }
  if bo1 then begin  //left or right
   fdim.cx:= acx * b;
   fdim.cy:= acy * a;
  end
  else begin
   fdim.cx:= acx * a;
   fdim.cy:= acy * b;
  end;
 end;
end;

procedure tcustomstepframe.updaterects;
begin
 updatelayout;
 inherited;
 updatelayout;
end;

procedure tcustomstepframe.updatemousestate(const sender: twidget;
                      const apos: pointty);
begin
 inherited;
 if pointinrect(apos,fdim) then begin
  with twidget1(sender) do begin
   fwidgetstate:= fwidgetstate + [ws_wantmousebutton,ws_wantmousemove];
  end;
 end;
end;

procedure tcustomstepframe.domousewheelevent(var info: mousewheeleventinfoty);
const
 stepdir: array[stepbuttonposty,boolean] of stepkindty =
                  //down     //up
             ((sk_down,        sk_up),          //sbp_right
              (sk_right,      sk_left),       //sbp_top
              (sk_down,        sk_up),          //sbp_left
              (sk_right,      sk_left));      //sbp_bottom
begin
 if fmousewheel and (info.wheel <> mw_none) then begin
  fstepintf.dostep(stepdir[fbuttonpos][info.wheel = mw_up]);
  include(info.eventstate,es_processed);
 end;
end;

{ tscrollboxscrollbar }

constructor tscrollboxscrollbar.create(intf: iscrollbar; org: originty;
  ondimchanged: objectprocty);
begin
 inherited;
 foptions:= defaultscrollboxscrollbaroptions;
end;

{ tthumbtrackscrollbar }

constructor tthumbtrackscrollbar.create(intf: iscrollbar; org: originty;
  ondimchanged: objectprocty);
begin
 inherited;
 foptions:= defaultthumbtrackscrollbaroptions;
end;

{ tcustomscrollboxframe }

constructor tcustomscrollboxframe.create(const intf: iscrollframe; const owner: twidget);
begin
 fowner:= owner;
 inherited create(intf,iscrollbox(self));
 initinnerframe;
 internalupdatestate;
// options:= defaultscrolloptions;
end;

procedure tcustomscrollboxframe.initinnerframe;
begin
 fi.innerframe.left:= 2;
 fi.innerframe.top:= 2;
 fi.innerframe.right:= 2;
 fi.innerframe.bottom:= 2;
end;

procedure tcustomscrollboxframe.clientrecttoscrollbar(const rect: rectty);
var
 int1: integer;
begin
 inc(fscrolling);
 with rect do begin
  if fstate * [fs_sbhorzon,fs_sbhorzfix] = [fs_sbhorzon] then begin
   if cx = 0 then begin
    fhorz.pagesize:= 1;
   end
   else begin
    fhorz.pagesize:= fpaintrect.cx/cx;
   end;
   int1:= cx - fpaintrect.cx;
   if int1 = 0 then begin
    fhorz.value:= 0;
   end
   else begin
    fhorz.value:= ({fpaintrect.x}-x)/int1;
   end;
  end;
  if fstate * [fs_sbverton,fs_sbvertfix] = [fs_sbverton] then begin
   if cy = 0 then begin
    fvert.pagesize:= 1;
   end
   else begin
    fvert.pagesize:= fpaintrect.cy/cy;
   end;
   int1:= cy - fpaintrect.cy;
   if int1 = 0 then begin
    fvert.value:= 0;
   end
   else begin
    fvert.value:= ({fpaintrect.y}-y)/int1;
   end;
  end;
 end;
 dec(fscrolling);
end;

procedure tcustomscrollboxframe.scrollpostoclientpos(var aclientrect: rectty);
begin
 with aclientrect do begin
  x:= - round(fhorz.value * (cx-fpaintrect.cx));
  y:= - round(fvert.value * (cy-fpaintrect.cy));
//  inc(x,fpaintrect.x);
//  inc(y,fpaintrect.y);
 end;
end;

procedure tcustomscrollboxframe.updatevisiblescrollbars;
begin
 updatebit({$ifdef FPC}longword{$else}longword{$endif}(fstate),
             ord(fs_sbhorztop),sbo_opposite in fhorz.options);
 updatebit({$ifdef FPC}longword{$else}longword{$endif}(fstate),
             ord(fs_sbvertleft),sbo_opposite in fvert.options);
 updatebit({$ifdef FPC}longword{$else}longword{$endif}(fstate),
             ord(fs_sbhorzon),sbo_show in fhorz.options);
 updatebit({$ifdef FPC}longword{$else}longword{$endif}(fstate),
             ord(fs_sbverton),sbo_show in fvert.options);
end;

function tcustomscrollboxframe.getwidget: twidget;
begin
 result:= fowner;
end;

procedure tcustomscrollboxframe.calcclientrect(var aclientrect: rectty);

var
 asize: sizety;
 statebefore: framestatesty;
 int1: integer;

begin
 updatevisiblescrollbars;
 updaterects;
 inc(fscrolling);
 int1:= 0;
 repeat
  statebefore:= fstate;
  asize:= twidget1(fowner).calcminscrollsize;
  with asize do begin
   if fclientwidth <> 0 then begin
    cx:= fclientwidth;
   end;
   if fclientheight <> 0 then begin
    cy:= fclientheight;
   end;
   if sbo_showauto in fhorz.options then begin
    if cx > fpaintrect.cx then begin
     include(fstate,fs_sbhorzon);
    end
    else begin
     exclude(fstate,fs_sbhorzon);
     fhorz.value:= 0;
    end;
   end;
   if sbo_showauto in fvert.options then begin
    if cy > fpaintrect.cy then begin
     include(fstate,fs_sbverton);
    end
    else begin
     exclude(fstate,fs_sbverton);
     fvert.value:= 0;
    end;
   end;
  end;
  if state = statebefore then begin
   break;
  end;
  updaterects;
  inc(int1);
 until int1 > 16; //emergency brake
 dec(fscrolling);

 aclientrect.size:= asize;
 with aclientrect.size do begin
  if cx < fpaintrect.cx then begin
   cx:= fpaintrect.cx;
  end;
  if cy < fpaintrect.cy then begin
   cy:= fpaintrect.cy;
  end;
  int1:= fpaintrect.cx {+ fpaintrect.x} - aclientrect.cx - aclientrect.x;
  if int1 > 0 then begin
   inc(aclientrect.x,int1);
  end;
  int1:= fpaintrect.cy {+ fpaintrect.y} - aclientrect.cy - aclientrect.y;
  if int1 > 0 then begin
   inc(aclientrect.y,int1);
  end;
 end;
 clientrecttoscrollbar(aclientrect);
end;

procedure tcustomscrollboxframe.updateclientrect;
var
 rect1: rectty;
begin
 rect1:= fclientrect;
 calcclientrect(fclientrect);
 finnerclientrect:= deflaterect(fclientrect,fi.innerframe);
 twidget1(fowner).scroll(subpoint(fclientrect.pos,rect1.pos));
 if (rect1.cx <> fclientrect.cx) or (rect1.cy <> fclientrect.cy) then begin
  twidget1(fowner).clientrectchanged;
 end;
end;

procedure tcustomscrollboxframe.scrollevent(sender: tcustomscrollbar;
                  event: scrolleventty);
var
 po1: pointty;
begin
 if fscrolling = 0 then begin
  if event = sbe_valuechanged then begin
   po1:= fclientrect.pos;
   scrollpostoclientpos(fclientrect);
   po1:= subpoint(fclientrect.pos,po1); 
   addpoint1(finnerclientrect.pos,po1);
   twidget1(fowner).scroll(po1);
  end;
 end;
end;

function tcustomscrollboxframe.translatecolor(const acolor: colorty): colorty;
begin
 result:= fowner.translatecolor(acolor);
end;

procedure tcustomscrollboxframe.invalidaterect(const rect: rectty; org: originty);
begin
 fowner.invalidaterect(rect,org);
end;

function tcustomscrollboxframe.getscrollsize: sizety;
begin
 checkstate;
 result:= fclientrect.size;
end;

procedure tcustomscrollboxframe.setclientheigth(const value: integer);
begin
 if fclientheight <> value then begin
  if value < 0 then begin
   fclientheight:= 0;
  end
  else begin
   fclientheight:= value;
  end;
  internalupdatestate;
 end;
end;

procedure tcustomscrollboxframe.setclientwidth(const value: integer);
begin
 if fclientwidth <> value then begin
  if value < 0 then begin
   fclientwidth:= 0;
  end
  else begin
   fclientwidth:= value;
  end;
  internalupdatestate;
 end;
end;

procedure tcustomscrollboxframe.showrect(const arect: rectty; 
                                     const bottomright: boolean);
var
 scrollvalue: pointty;
// po1: pointty;
 int1: integer;
 
 procedure adjuststart;
 begin
  int1:= fclientrect.x + scrollvalue.x + arect.x;
  if int1 < 0 then begin
   dec(scrollvalue.x,int1);
  end;
  int1:= fclientrect.x + scrollvalue.x;
  if int1 > 0 then begin
   dec(scrollvalue.x,int1);
  end;
  int1:= fclientrect.y + scrollvalue.y + arect.y;
  if int1 < 0 then begin
   dec(scrollvalue.y,int1);
  end;
  int1:= fclientrect.y + scrollvalue.y;
  if int1 > 0 then begin
   dec(scrollvalue.y,int1);
  end;
 end;
 
 procedure adjustend;
 begin
  int1:= fclientrect.x + scrollvalue.x + arect.x + arect.cx - fpaintrect.cx;
  if int1 > 0 then begin
   dec(scrollvalue.x,int1);
  end;
  int1:= fclientrect.x + scrollvalue.x + fclientrect.cx - fpaintrect.cx;
  if int1 < 0 then begin
   dec(scrollvalue.x,int1);
  end;
  int1:= fclientrect.y + scrollvalue.y + arect.y + arect.cy - fpaintrect.cy;
  if int1 > 0 then begin
   dec(scrollvalue.y,int1);
  end;
  int1:= fclientrect.y + scrollvalue.y + fclientrect.cy - fpaintrect.cy;
  if int1 < 0 then begin
   dec(scrollvalue.y,int1);
  end;
 end;
 
begin
 scrollvalue:= nullpoint;
 checkstate;
// po1:= addpoint(fclientrect.pos,arect.pos);
 if bottomright then begin
  adjuststart;
  adjustend;
 end
 else begin
  adjustend;
  adjuststart;
 end;
 if (scrollvalue.y <> 0) or (scrollvalue.x <> 0) then begin
  addpoint1(fclientrect.pos,scrollvalue);
  addpoint1(finnerclientrect.pos,scrollvalue);
  twidget1(fowner).scroll(scrollvalue);
  clientrecttoscrollbar(fclientrect);
 end;
end;

function tcustomscrollboxframe.getscrollbarclass(vert: boolean): framescrollbarclassty;
begin
 result:= tscrollboxscrollbar;
end;

procedure tcustomscrollboxframe.setsbhorz(const avalue: tscrollboxscrollbar);
begin
 inherited setsbhorz(avalue);
end;

function tcustomscrollboxframe.getsbhorz: tscrollboxscrollbar;
begin
 result:= tscrollboxscrollbar(inherited sbhorz);
end;

procedure tcustomscrollboxframe.setsbvert(const avalue: tscrollboxscrollbar);
begin
 inherited setsbvert(avalue);
end;

function tcustomscrollboxframe.getsbvert: tscrollboxscrollbar;
begin
 result:= tscrollboxscrollbar(inherited sbvert);
end;

{ tcustomautoscrollframe }

constructor tcustomautoscrollframe.create(const intf: iscrollframe; const owner: twidget;
                    const autoscrollintf: iautoscrollframe);
begin
 fintf1:= autoscrollintf;
 inherited create(intf,owner);
end;

function tcustomautoscrollframe.getscrollpos: pointty;
begin
 result:= fintf1.getscrollrect.pos;
end;

procedure tcustomautoscrollframe.setscrollpos(const avalue: pointty);
var
 rect1: rectty;
begin
 rect1:= fintf1.getscrollrect;
 if (rect1.x <> avalue.x) or (rect1.y <> avalue.y) then begin
  rect1.pos:= avalue;
  with rect1 do begin
   if x + cx < fpaintrect.cx then begin
    x:= fpaintrect.cx - rect1 .cx;
   end;
   if x > 0{fpaintrect.x} then begin
    x:= 0{fpaintrect.x};
   end;
   if y + cy < fpaintrect.cy then begin
    y:= fpaintrect.cy - cy;
   end;
   if y > 0{fpaintrect.y} then begin
    y:= 0{fpaintrect.y};
   end;
  end;
  clientrecttoscrollbar(rect1);
  fintf1.setscrollrect(rect1);
 end;
end;

function tcustomautoscrollframe.getscrollpos_x: integer;
begin
 result:= getscrollpos.x;
end;

procedure tcustomautoscrollframe.setscrollpos_x(const avalue: integer);
begin
 setscrollpos(makepoint(avalue,getscrollpos.y));
end;

function tcustomautoscrollframe.getscrollpos_y: integer;
begin
 result:= getscrollpos.y;
end;

procedure tcustomautoscrollframe.setscrollpos_y(const avalue: integer);
begin
 setscrollpos(makepoint(getscrollpos.x,avalue));
end;

procedure tcustomautoscrollframe.scrollevent(sender: tcustomscrollbar;
                  event: scrolleventty);
var
 rect1: rectty;
begin
 if fscrolling = 0 then begin
  if event = sbe_valuechanged then begin
   rect1:= fintf1.getscrollrect;
   scrollpostoclientpos(rect1);
   fintf1.setscrollrect(rect1);
  end
  else begin
   fintf1.scrollevent(sender,event);
  end;
 end;
end;

procedure tcustomautoscrollframe.updaterects;
begin
 inherited;
 fclientrect.pos:= nullpoint;
 fclientrect.size:= fpaintrect.size;
 finnerclientrect:= deflaterect(fclientrect,fi.innerframe);
end;

procedure tcustomautoscrollframe.updateclientrect;
var
 rect1: rectty;
begin
 rect1:= fintf1.getscrollrect;
 calcclientrect(rect1);
 fintf1.setscrollrect(rect1);
end;


{ tactionwidget }

procedure tactionwidget.dopopup(var amenu: tpopupmenu;
                                        var mouseinfo: mouseeventinfoty);
var
 widget1: twidget;
 bo1: boolean;
 menu1: tpopupmenu;

begin
 menu1:= amenu;
 try
  if (fpopupmenu <> nil) then begin
   tpopupmenu.additems(amenu,self,mouseinfo,fpopupmenu);
  end;
  if canevent(tmethod(fonpopup)) then begin
   fonpopup(self,amenu,mouseinfo);
  end;
  widget1:= fparentwidget;
  while widget1 <> nil do begin
   if widget1 is tactionwidget then begin
    translateclientpoint1(mouseinfo.pos,self,widget1);
    bo1:= not (es_child in mouseinfo.eventstate);
    include(mouseinfo.eventstate,es_child);
    try
     tactionwidget(widget1).dopopup(amenu,mouseinfo);
    finally
     if bo1 then begin
      exclude(mouseinfo.eventstate,es_child);
     end;
     translateclientpoint1(mouseinfo.pos,widget1,self);
    end;
    break;
   end;
   widget1:= twidget1(widget1).fparentwidget;
  end;
  if (amenu <> nil) and (mouseinfo.eventstate * [es_processed,es_child] = []) then begin
   amenu.show(self,mouseinfo);
  end;
 finally
  if not (es_child in mouseinfo.eventstate) then begin
   if amenu <> menu1 then begin
    freetransientmenu(tcustommenu(menu1)); //if amenu overwritten
   end;
   freetransientmenu(tcustommenu(amenu));
  end;
 end;
end;

procedure tactionwidget.clientmouseevent(var info: mouseeventinfoty);
var
 dummy: tpopupmenu;
 po1: pointty;
begin
 inherited;
 with info do begin
  if (eventkind = ek_buttonrelease) and
             not (csdesigning in componentstate) and
             (eventstate * [es_processed,es_child] = []) and
             (button = mb_right) then begin
   dummy:= nil;
   po1:= info.pos;
   dopopup(dummy,info);
   info.pos:= po1; //no mousemove by chage of popup pos
  end;
 end;
end;

procedure tactionwidget.showhint(var info: hintinfoty);
begin
 inherited;
 if canevent(tmethod(fonshowhint)) then begin
  fonshowhint(self,info);
 end;
end;

procedure tactionwidget.internalcreateframe;
begin
 tcaptionframe.create(iscrollframe(self));
end;

procedure tactionwidget.enabledchanged;
begin
 inherited;
 if (fframe <> nil) and
      (tcustomcaptionframe(fframe).finfo.text.text <> '') then begin
  invalidatewidget;
 end;
end;

function tactionwidget.getframe: tcaptionframe;
begin
 result:= tcaptionframe(inherited getframe);
end;

procedure tactionwidget.setframe(const value: tcaptionframe);
begin
 inherited setframe(value);
end;

function tactionwidget.getface: tface;
begin
 result:= tface(inherited getface);
end;

procedure tactionwidget.setface(const Value: tface);
begin
 inherited setface(value);
end;

procedure tactionwidget.setpopupmenu(const Value: tpopupmenu);
begin
 setlinkedvar(value,tmsecomponent(fpopupmenu));
end;

procedure tactionwidget.doenter;
begin
 inherited;
 if canevent(tmethod(fonenter)) then begin
  fonenter(self);
 end;
end;

procedure tactionwidget.doexit;
begin
 inherited;
 if canevent(tmethod(fonexit)) then begin
  fonexit(self);
 end;
end;

procedure tactionwidget.dofocus;
begin
 inherited;
 if canevent(tmethod(fonfocus)) then begin
  fonfocus(self);
 end;
end;

procedure tactionwidget.dodefocus;
begin
 inherited;
 if canevent(tmethod(fondefocus)) then begin
  fondefocus(self);
 end;
end;

procedure tactionwidget.doactivate;
begin
 inherited;
 if canevent(tmethod(fonactivate)) then begin
  fonactivate(self);
 end;
end;

procedure tactionwidget.dodeactivate;
begin
 inherited;
 if canevent(tmethod(fondeactivate)) then begin
  fondeactivate(self);
 end;
end;

{ tcustomeventwidget }

procedure tcustomeventwidget.mouseevent(var info: mouseeventinfoty);
begin
 if canevent(tmethod(fonmouseevent)) then begin
  fonmouseevent(self,info);
 end;
 inherited;
end;

procedure tcustomeventwidget.clientmouseevent(var info: mouseeventinfoty);
begin
 if canevent(tmethod(fonclientmouseevent)) then begin
  fonclientmouseevent(self,info);
 end;
 inherited;
end;

procedure tcustomeventwidget.childmouseevent(const sender: twidget;
                var info: mouseeventinfoty);
begin
 if canevent(tmethod(fonchildmouseevent)) then begin
  fonchildmouseevent(sender,info);
 end;
 inherited;
end;

procedure tcustomeventwidget.domousewheelevent(var info: mousewheeleventinfoty);
begin
 inherited;
 if canevent(tmethod(fonmousewheelevent)) then begin
  fonmousewheelevent(self,info);
 end;
end;

procedure tcustomeventwidget.dobeforepaint(const canvas: tcanvas);
var
 pt1: pointty;
begin
 inherited;
 canvas.font:= getfont;
 if canevent(tmethod(fonbeforepaint)) then begin
  pt1:= clientwidgetpos;
  canvas.move(pt1);
  fonbeforepaint(self,canvas);
  canvas.remove(pt1);
 end;
end;

procedure tcustomeventwidget.dopaintbackground(const canvas: tcanvas);
begin
 inherited;
 if canevent(tmethod(fonpaintbackground)) then begin
  fonpaintbackground(self,canvas);
 end;
end;

procedure tcustomeventwidget.doonpaint(const canvas: tcanvas);
begin
 inherited;
 if canevent(tmethod(fonpaint)) then begin
  fonpaint(self,canvas);
 end;
end;

procedure tcustomeventwidget.doafterpaint(const canvas: tcanvas);
var
 pt1: pointty;
begin
 inherited;
 if canevent(tmethod(fonafterpaint)) then begin
  pt1:= clientwidgetpos;
  canvas.move(pt1);
  fonafterpaint(self,canvas);
  canvas.remove(pt1);
 end;
end;

procedure tcustomeventwidget.doloaded;
begin
 inherited;
 if canevent(tmethod(fonloaded)) then begin
  fonloaded(self);
 end;
end;

procedure tcustomeventwidget.poschanged;
begin
 inherited;
 if canevent(tmethod(fonmove)) then begin
  fonmove(self);
 end;
end;

procedure tcustomeventwidget.sizechanged;
begin
 inherited;
 if canevent(tmethod(fonresize)) then begin
  fonresize(self);
 end;
end;
{
procedure tcustomeventwidget.doenter;
begin
 inherited;
 if canevent(tmethod(fonenter)) then begin
  fonenter(self);
 end;
end;

procedure tcustomeventwidget.doexit;
begin
 inherited;
 if canevent(tmethod(fonexit)) then begin
  fonexit(self);
 end;
end;

procedure tcustomeventwidget.dofocus;
begin
 inherited;
 if canevent(tmethod(fonfocus)) then begin
  fonfocus(self);
 end;
end;

procedure tcustomeventwidget.dodefocus;
begin
 inherited;
 if canevent(tmethod(fondefocus)) then begin
  fondefocus(self);
 end;
end;

procedure tcustomeventwidget.doactivate;
begin
 inherited;
 if canevent(tmethod(fonactivate)) then begin
  fonactivate(self);
 end;
end;

procedure tcustomeventwidget.dodeactivate;
begin
 inherited;
 if canevent(tmethod(fondeactivate)) then begin
  fondeactivate(self);
 end;
end;
}
procedure tcustomeventwidget.dohide;
begin
 if canevent(tmethod(fonhide)) then begin
  fonhide(self);
 end;
 inherited;
 include(fwidgetstate,ws_hidden);
 exclude(fwidgetstate,ws_showed);
end;

procedure tcustomeventwidget.doshow;
begin
 inherited;
 if canevent(tmethod(fonshow)) then begin
  fonshow(self);
 end;
 include(fwidgetstate,ws_showed);
 exclude(fwidgetstate,ws_hidden);
end;

procedure tcustomeventwidget.doshortcut(var info: keyeventinfoty; const sender: twidget);
begin
 if not (es_processed in info.eventstate) and canevent(tmethod(fonshortcut)) then begin
  fonshortcut(self,info);
 end;
 inherited;
end;

procedure tcustomeventwidget.dokeydown(var info: keyeventinfoty);
begin
 if not (es_processed in info.eventstate) and canevent(tmethod(fonkeydown)) then begin
  fonkeydown(self,info);
 end;
 inherited;
end;

procedure tcustomeventwidget.dokeyup(var info: keyeventinfoty);
begin
 if not (es_processed in info.eventstate) and canevent(tmethod(fonkeyup)) then begin
  fonkeyup(self,info);
 end;
 inherited;
end;

function tcustomeventwidget.canclose(const newfocus: twidget): boolean;
begin
 result:= inherited canclose(newfocus);
 if result and assigned(fonclosequery) then begin
  fonclosequery(self,result);
 end;
end;

procedure tcustomeventwidget.receiveevent(const event: tobjectevent);
begin
 if canevent(tmethod(fonevent)) then begin
  fonevent(self,event);
 end;
 inherited;
end;

procedure tcustomeventwidget.doasyncevent(var atag: integer);
begin
 if canevent(tmethod(fonasyncevent)) then begin
  fonasyncevent(self,atag);
 end;
 inherited;
end;

procedure tcustomeventwidget.dofocuschanged(const oldwidget: twidget;
               const newwidget: twidget);
begin
 inherited;
 if canevent(tmethod(fonfocusedwidgetchanged)) and 
  (checkdescendent(oldwidget) or checkdescendent(newwidget)) then begin
  fonfocusedwidgetchanged(oldwidget,newwidget);
 end; 
end;

{ ttoplevelwidget }

constructor ttoplevelwidget.create(aowner: tcomponent);
begin
 inherited;
 visible:= false;
 optionswidget:= defaultoptionstoplevelwidget;
 optionsskin:= defaultcontainerskinoptions;
// fcolor:= cl_background;
end;

{ tcaptionwidget }

function tcaptionwidget.getcaption: msestring;
begin
 result:= fcaption;
end;

procedure tcaptionwidget.setcaption(const Value: msestring);
begin
 fcaption := Value;
 if (fwindow <> nil) and (fwindow.winid <> 0) then begin
  gui_setwindowcaption(fwindow.winid,fcaption);
 end;
end;

procedure tcaptionwidget.windowcreated;
begin
 inherited;
 if fcaption <> '' then begin
  caption:= fcaption;                //set windowcaption
 end;
end;

{ tscrollface }

procedure tscrollface.paint(const canvas: tcanvas; const rect: rectty);
begin
 inherited paint(canvas,fintf.getwidget.clientrect);
end;

{ tscrollingwidget }

constructor tscrollingwidget.create(aowner: tcomponent);
begin
 inherited;
 foptionswidget:= defaultoptionswidgetmousewheel;
 optionsskin:= defaultcontainerskinoptions;
 internalcreateframe;
 setstaticframe(true);
end;

procedure tscrollingwidget.internalcreateframe;
begin
 tscrollboxframe.create(iscrollframe(self),self);
end;

function tscrollingwidget.getframe: tscrollboxframe;
begin
 result:= tscrollboxframe(inherited getframe);
end;

procedure tscrollingwidget.setframe(const Value: tscrollboxframe);
begin
 inherited setframe(tcaptionframe(value));
end;

procedure tscrollingwidget.mouseevent(var info: mouseeventinfoty);
begin
 tscrollframe(fframe).mouseevent(info);
 inherited;
end;

procedure tscrollingwidget.domousewheelevent(var info: mousewheeleventinfoty);
begin
 tscrollframe(fframe).domousewheelevent(info);
 inherited;
end;

procedure tscrollingwidget.doscroll(const dist: pointty);
begin
 inherited;
 if canevent(tmethod(fonscroll)) then begin
// if assigned(fonscroll) then begin
  fonscroll(self,dist);
 end;
end;

procedure tscrollingwidget.widgetregionchanged(const sender: twidget);
begin
 inherited;
 if not (ws1_anchorsizing in twidget1(sender).fwidgetstate1) and
                not (ws_destroying in fwidgetstate) and not (csloading in componentstate) then begin
  tcustomscrollboxframe(fframe).updateclientrect;
 end;
// else begin
//  tscrollboxframe(fframe).updatestate; ww
// end;
end;

procedure tscrollingwidget.writestate(writer: twriter);
begin
 frame.sbhorz.value:= 0;
 frame.sbvert.value:= 0;
 inherited;
end;

procedure tscrollingwidget.internalcreateface;
begin
 tscrollface.create(twidget(self));
end;

procedure tscrollingwidget.sizechanged;
begin
 inherited;
 tcustomscrollboxframe(fframe).updatestate;
// tcustomscrollboxframe(fframe).updateclientrect;
    //set endresult of autosizing
end;

procedure tscrollingwidget.minscrollsizechanged;
begin
 tcustomscrollboxframe(fframe).updatestate;
end;

function tscrollingwidget.calcminscrollsize: sizety;
begin
 result:= inherited calcminscrollsize;
 if result.cx < fminclientsize.cx then begin
  result.cx:= fminclientsize.cx;
 end;
 if result.cy < fminclientsize.cy then begin
  result.cy:= fminclientsize.cy;
 end;
// result:= inherited calcminscrollsize;
 if checkcanevent(owner,tmethod(foncalcminscrollsize)) then begin
  foncalcminscrollsize(self,result);
 end;
end;

procedure tscrollingwidget.setclientsize(const asize: sizety);
begin
 with tcustomscrollboxframe(fframe) do begin
  fminclientsize:= fminminclientsize;
  if (asize.cx > fclientrect.cx) then begin
   fminclientsize.cx:= asize.cx;
  end;
  if (asize.cy > fclientrect.cy) then begin
   fminclientsize.cy:= asize.cy;
  end;
  if (fminclientsize.cx > 0) or (fminclientsize.cy > 0) then begin
   updatestate;
   fminclientsize:= fminminclientsize;
  end;
 end;
end;

procedure tscrollingwidget.dochildscaled(const sender: twidget);
begin
 if canevent(tmethod(fonchildscaled)) then begin
  fonchildscaled(self);
 end
 else begin
  inherited;
 end;
end;

procedure tscrollingwidget.loaded;
begin
 inherited;
 if canevent(tmethod(fonchildscaled)) then begin
  postchildscaled;
 end;
end;

procedure tscrollingwidget.dofontheightdelta(var delta: integer);
begin
 if canevent(tmethod(fonfontheightdelta)) then begin
  fonfontheightdelta(self,delta);
 end;
 inherited;
end;

procedure tscrollingwidget.clampinview(const arect: rectty; const bottomright: boolean);
begin
 frame.showrect(removerect(arect,clientpos),bottomright);
// frame.showrect(removerect(arect,clientwidgetpos));
// frame.showrect(arect);
end;

function tscrollingwidget.maxclientsize: sizety;
begin
 result:= makesize(bigint,bigint);
end;

procedure tscrollingwidget.setclientpos(const avalue: pointty);
begin
 frame.showrect(makerect(avalue,paintsize),false);
end;

{ tscrollbarwidget }

constructor tscrollbarwidget.create(aowner: tcomponent);
begin
 inherited;
 internalcreateframe;
end;

procedure tscrollbarwidget.internalcreateframe;
begin
 tscrollframe.create(self,iscrollbar(self));
end;

function tscrollbarwidget.getframe: tscrollframe;
begin
 result:= tscrollframe(inherited getframe);
end;

procedure tscrollbarwidget.setframe(const Value: tscrollframe);
begin
 inherited setframe(tcaptionframe(value));
end;

procedure tscrollbarwidget.scrollevent(sender: tcustomscrollbar;
  event: scrolleventty);
begin
 //dummy
end;

procedure tscrollbarwidget.mouseevent(var info: mouseeventinfoty);
begin
 tscrollframe(fframe).mouseevent(info);
 inherited;
end;

{ tpopupwidget }

constructor tpopupwidget.create(aowner: tcomponent; transientfor: twindow);
begin
 inherited create(aowner);
 if transientfor <> nil then begin
  getobjectlinker.setlinkedvar(ievent(self),transientfor,tlinkedobject(ftransientfor));
 end;
 window.localshortcuts:= true;
end;

function tpopupwidget.internalshow(const modal: boolean; transientfor: twindow;
                   const windowevent: boolean): modalresultty;
begin
 if transientfor = nil then begin
  result:=  inherited internalshow(modal,ftransientfor,windowevent);
 end
 else begin
  result:= inherited internalshow(modal,transientfor,windowevent);
 end;
end;

procedure tpopupwidget.updatewindowinfo(var info: windowinfoty);
begin
 with info do begin
  options:= [wo_popup];
  transientfor:= ftransientfor;
 end;
end;

{ thintwidget }

constructor thintwidget.create(aowner: tcomponent; transientfor: twindow;
                 var info: hintinfoty);
var
 rect1,rect2: rectty;
begin
 fcaption:= info.caption;
 inherited create(aowner,transientfor);
 internalcreateframe;
 fframe.levelo:= 1;
 fframe.framei_left:= 1;
 fframe.framei_top:= 1;
 fframe.framei_right:= 1;
 fframe.framei_bottom:= 1;
 color:= cl_infobackground;
 rect2:= deflaterect(application.workarea(transientfor),fframe.innerframe);
 rect1:= textrect(getcanvas,info.caption,rect2,[tf_wordbreak]);
 inc(rect1.cx,fframe.innerframewidth.cx);
 inc(rect1.cy,fframe.innerframewidth.cy);
 widgetrect:= placepopuprect(transientfor,info.posrect,info.placement,rect1.size);
end;

procedure thintwidget.dopaint(const canvas: tcanvas);
begin
 inherited;
 drawtext(canvas,fcaption,innerclientrect,[tf_wordbreak]);
end;

destructor thintwidget.destroy;
begin
 inherited;
end;

{ tmessagewidget }

constructor tmessagewidget.create(const aowner: tcomponent;
               const apopuptransient: boolean; const ahasaction: boolean);
begin
 fpopuptransient:= apopuptransient;
 fhasaction:= ahasaction;
 inherited create(aowner);
 if apopuptransient then begin
  color:= cl_active;
//exit;
  createframe;
  with tcustomcaptionframe(fframe) do begin
   colorframe:= cl_black;
   framewidth:= 2;
   captionpos:= cp_top;
  end;
 end;
end;

procedure tmessagewidget.dokeydown(var info: keyeventinfoty);
begin
 with info do begin
  if not((key = key_escape) and (shiftstate = []) and window.close) then begin
   inherited;
  end;
 end;
end;

procedure tmessagewidget.updatewindowinfo(var info: windowinfoty);
begin
 inherited;
 info.options:= [wo_message];
 if fpopuptransient then begin
  include(info.options,wo_popup);
 end;
 window.localshortcuts:= true;
end;

function tmessagewidget.getcaption: msestring;
begin
 if fframe <> nil then begin
  result:= tcustomcaptionframe(fframe).caption;
 end
 else begin
  result:= inherited getcaption;
 end;
end;

procedure tmessagewidget.setcaption(const Value: msestring);
begin
 if fframe <> nil then begin
  tcustomcaptionframe(fframe).caption:= value;
 end
 else begin
  inherited;
 end; 
end;

procedure tmessagewidget.internalcreateframe;
begin
 tcustomcaptionframe.create(iscrollframe(self));
end;

function tmessagewidget.canclose(const newfocus: twidget): boolean;
begin
 result:= not fhasaction or (window.modalresult <> mr_windowclosed);
end;

{ tcustomthumbtrackscrollframe }

function tcustomthumbtrackscrollframe.getscrollbarclass(vert: boolean): framescrollbarclassty;
begin
 result:= tthumbtrackscrollbar;
end;

{ tscrollframe }

function tscrollframe.getscrollbarclass(vert: boolean): framescrollbarclassty;
begin
 result:= tscrollbar;
end;

procedure tscrollframe.setsbhorz(const avalue: tscrollbar);
begin
 inherited setsbhorz(avalue);
end;

function tscrollframe.getsbhorz: tscrollbar;
begin
 result:= tscrollbar(inherited sbhorz);
end;

procedure tscrollframe.setsbvert(const avalue: tscrollbar);
begin
 inherited setsbvert(avalue);
end;

function tscrollframe.getsbvert: tscrollbar;
begin
 result:= tscrollbar(inherited sbvert);
end;

end.

{ MSEgui Copyright (c) 1999-2007 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit msesimplewidgets;

{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface

uses
 msegui,mseguiglob,msetypes,msestrings,msegraphics,mseevent,mseactions,msewidgets,
 mserichstring,mseshapes,Classes,mseclasses,msebitmap,msedrawtext,
 msedrag,msestockobjects,msegraphutils;

const
 defaultbuttonwidth = 50;
 defaultbuttonheight = 20;
 defaultlabeltextflags = [tf_ycentered];
 defaultlabeloptionswidget = (defaultoptionswidget + [ow_fontglyphheight,ow_autosize]) - 
              [ow_mousefocus,ow_tabfocus,ow_arrowfocus];
 defaultlabelwidgetwidth = 100;
 defaultlabelwidgetheight = 20;

type

 tpaintbox = class(tpublishedwidget)
  private
   fonbeforepaint: painteventty;
   fonpaint: painteventty;
   fonafterpaint: painteventty;
   fonpaintbackground: painteventty;
  protected
   procedure dobeforepaint(const canvas: tcanvas); override;
   procedure dopaintbackground(const canvas: tcanvas); override;
   procedure doonpaint(const canvas: tcanvas); override;
   procedure doafterpaint(const canvas: tcanvas); override;
  published
   property onbeforepaint: painteventty read fonbeforepaint write fonbeforepaint;
   property onpaintbackground: painteventty read fonpaintbackground 
                                                  write fonpaintbackground;
   property onpaint: painteventty read fonpaint write fonpaint;
   property onafterpaint: painteventty read fonafterpaint write fonafterpaint;
 end;

 teventwidget = class(tcustomeventwidget)
  published
   property onfocusedwidgetchanged;
   property onenter;
   property onexit;
   property onfocus;
   property ondefocus;

   property onmouseevent;
   property onchildmouseevent;
   property onclientmouseevent;
   property onmousewheelevent;

   property onkeydown;
   property onkeyup;
   property onshortcut;

   property onloaded;

   property onbeforepaint;
   property onpaintbackground;
   property onpaint;
   property onafterpaint;

   property onshow;
   property onhide;
   property onactivate;
   property ondeactivate;
   property onresize;
   property onmove;
   property onclosequery;

 end;

 tcustombutton = class(tactionsimplebutton,iactionlink)
  private
   fmodalresult: modalresultty;
   factioninfo: actioninfoty;
   fautosize_cx: integer;
   fautosize_cy: integer;
   procedure setcaption(const Value: captionty);
   function getframe: tframe;
   procedure setframe(const Value: tframe);
   function getcaption: captionty;
   procedure setonexecute(const value: notifyeventty);
   procedure setaction(const value: tcustomaction); virtual;
   function isonexecutestored: boolean;
   function iscaptionstored: boolean;
   function getstate: actionstatesty;
   procedure setstate(const value: actionstatesty); virtual;
   function isstatestored: boolean;
   procedure setimagelist(const Value: timagelist);
   function isimageliststored: Boolean;
   procedure setimagenr(const Value: integer);
   function isimagenrstored: Boolean;
   procedure setimagenrdisabled(const avalue: integer);
   function isimagenrdisabledstored: Boolean;
   procedure setcolorglyph(const avalue: colorty);
   function iscolorglyphstored: boolean;
   procedure setcaptionpos(const avalue: captionposty);
   procedure setcaptiondist(const avalue: integer);
   procedure setautosize_cx(const avalue: integer);
   procedure setautosize_cy(const avalue: integer);
   procedure setimagedist(const avalue: integer);
  protected
   //iactionlink
   function getactioninfopo: pactioninfoty;
   function shortcutseparator: msechar;
   
   procedure setoptions(const avalue: buttonoptionsty); override;
   function gethint: msestring; override;
   procedure sethint(const Value: msestring); override;
   function ishintstored: boolean; override;

   procedure actionchanged;
   procedure readstate(reader: treader); override;
   procedure loaded; override;
   procedure enabledchanged; override;
   procedure visiblechanged; override;
   procedure clientrectchanged; override;
   procedure doexecute; override;
   procedure doenter; override;
   procedure doexit; override;
   procedure dopaint(const canvas: tcanvas); override;
   function checkfocusshortcut(var info: keyeventinfoty): boolean; override;
   procedure doshortcut(var info: keyeventinfoty; const sender: twidget); override;
   procedure getautopaintsize(var asize: sizety); override;
   procedure objectevent(const sender: tobject;
                                     const event: objecteventty); override;

  public
   constructor create(aowner: tcomponent); override;
   procedure synctofontheight; override;

   property bounds_cx default defaultbuttonwidth;
   property bounds_cy default defaultbuttonheight;
   property frame: tframe read getframe write setframe;
   property action: tcustomaction read factioninfo.action write setaction;
   property caption: captionty read getcaption write setcaption stored iscaptionstored;
   property captionpos: captionposty read finfo.captionpos write setcaptionpos
                              default cp_center;
   property captiondist: integer read finfo.captiondist write setcaptiondist
                            default defaultshapecaptiondist;
   property imagelist: timagelist read factioninfo.imagelist write setimagelist
                    stored isimageliststored;
   property imagenr: integer read factioninfo.imagenr write setimagenr
                            stored isimagenrstored default -1;
   property imagenrdisabled: integer read factioninfo.imagenrdisabled
                              write setimagenrdisabled
                            stored isimagenrdisabledstored default -2;
   property imagedist: integer read finfo.imagedist write setimagedist;
   property colorglyph: colorty read factioninfo.colorglyph write setcolorglyph
                      stored iscolorglyphstored default cl_glyph;
   property font: twidgetfont read getfont write setfont stored isfontstored;
   property modalresult: modalresultty read fmodalresult write fmodalresult
                                default mr_none;
   property onexecute: notifyeventty read factioninfo.onexecute
                            write setonexecute stored isonexecutestored;
   property autosize_cx: integer read fautosize_cx write setautosize_cx;
   property autosize_cy: integer read fautosize_cy write setautosize_cy;
  published
   property state: actionstatesty read getstate write setstate stored isstatestored;
 end;

 tbutton = class(tcustombutton)
  published
   property autosize_cx;
   property autosize_cy;
   property action;
   property caption;
   property captionpos;
   property captiondist;
   property font;
   property modalresult;
   property imagelist;
   property imagenr;
   property imagenrdisabled;
   property imagedist;
   property colorglyph;
   property options;
   property onexecute;
 end;

 tstockglyphbutton = class(tcustombutton)
  private
   fglyph: stockglyphty;
   procedure setglyph(const avalue: stockglyphty);
   procedure setstate(const avalue: actionstatesty); override;
   procedure setaction(const avalue: tcustomaction); override;
  public
   constructor create(aowner: tcomponent); override;
  published
   property glyph: stockglyphty read fglyph write setglyph default stg_none;
   property autosize_cx;
   property autosize_cy;
   property action;
   property caption;
   property captionpos;
   property font;
   property modalresult;
   property colorglyph;
   property options;
   property onexecute;
 end;

 labeloptionty = (lao_nogray);
 labeloptionsty = set of labeloptionty;
 
type 
 tcustomlabel = class(tpublishedwidget)
  private
   fcaption: richstringty;
   factualtextflags: textflagsty;
   ftextflags: textflagsty;
   foptions: labeloptionsty;
   procedure setcaption(const Value: msestring);
   function getcaption: msestring;
   procedure updatetextflags;
   procedure settextflags(const Value: textflagsty);
   procedure setoptions(const avalue: labeloptionsty);
  protected
   procedure dopaint(const canvas: tcanvas); override;
   procedure enabledchanged; override;
   procedure getautopaintsize(var asize: sizety); override;
   procedure fontchanged; override;
   procedure clientrectchanged; override;
  public
   constructor create(aowner: tcomponent); override;
   procedure synctofontheight; override;
   procedure initnewcomponent(const ascale: real); override;
   property caption: msestring read getcaption write setcaption;
   property font: twidgetfont read getfont write setfont stored isfontstored;
   property textflags: textflagsty read ftextflags write settextflags default 
                             defaultlabeltextflags;
   property options: labeloptionsty read foptions write setoptions default [];
  published
   property optionswidget default defaultlabeloptionswidget;
   property bounds_cx default defaultlabelwidgetwidth;
   property bounds_cy default defaultlabelwidgetheight;
 end;

 tlabel = class(tcustomlabel)
  published
   property caption;
   property font;
   property textflags;
   property options;
 end;
 
 tgroupboxframe = class(tcaptionframe)
  public
   constructor create(const intf: iframe);
  published
   property framei_left default 2;
   property framei_top default 2;
   property framei_right default 2;
   property framei_bottom default 2;
   property levelo default -1;
   property leveli default 1;
   property captiondist default - 7;
   property captionoffset default 4;
 end;

 optionscalety = (osc_expandx,osc_shrinkx,osc_expandy,osc_shrinky,
                  osc_invisishrinkx,osc_invisishrinky);
 optionsscalety = set of optionscalety;
 
 tcustomscalingwidget = class(tpublishedwidget)
  private
   fonfontheightdelta: fontheightdeltaeventty;
   fonchildscaled: notifyeventty;
   fscaling: integer;
   fonresize: notifyeventty;
   fonmove: notifyeventty;
   fsizebefore: sizety;
   procedure setoptionsscale(const avalue: optionsscalety);
  protected
   foptionsscale: optionsscalety;
   procedure beginscaling;
   procedure endscaling;
   procedure updateoptionsscale;
   procedure dofontheightdelta(var delta: integer); override;
   procedure widgetregionchanged(const sender: twidget); override;
   procedure clientrectchanged; override;
   procedure poschanged; override;
   procedure sizechanged; override;
   procedure visiblepropchanged; override;
  public
   procedure dochildscaled(const sender: twidget); override;
   property onresize: notifyeventty read fonresize write fonresize;
   property onmove: notifyeventty read fonmove write fonmove;
  published
   property optionsscale: optionsscalety read foptionsscale write setoptionsscale;
   property onfontheightdelta: fontheightdeltaeventty read fonfontheightdelta
                     write fonfontheightdelta;
   property onchildscaled: notifyeventty read fonchildscaled write fonchildscaled;
 end;
 
 tscalingwidget = class(tcustomscalingwidget)
  published
   property optionsscale;
   property onfontheightdelta;
   property onchildscaled;
   property onresize;
   property onmove;
 end;
 
const
 defaultgroupboxoptionswidget = defaultoptionswidget + 
        [ow_arrowfocusin,ow_arrowfocusout,ow_parenttabfocus,ow_subfocus];
 
type
 tgroupbox = class(tscalingwidget)
  private
   fonfocusedwidgetchanged: focuschangeeventty;
  protected
   procedure internalcreateframe; override;
   procedure dofocuschanged(const oldwidget,newwidget: twidget); override;
  public
   constructor create(aowner: tcomponent); override;
   procedure initnewcomponent(const ascale: real); override;
  published
   property optionswidget default defaultgroupboxoptionswidget;
   property onfocusedwidgetchanged: focuschangeeventty 
                     read fonfocusedwidgetchanged write fonfocusedwidgetchanged;
 end;

 tscrollbox = class(tscalingwidget)
  private
   fonscroll: pointeventty;
   function getframe: tscrollboxframe;
   procedure setframe(const value: tscrollboxframe);
  protected
   procedure internalcreateframe; override;
   procedure widgetregionchanged(const sender: twidget); override;
   procedure mouseevent(var info: mouseeventinfoty); override;
   procedure domousewheelevent(var info: mousewheeleventinfoty); override;
   procedure doscroll(const dist: pointty); override;
  public
   constructor create(aowner: tcomponent); override;
  published
   property frame: tscrollboxframe read getframe write setframe;
   property onscroll: pointeventty read fonscroll write fonscroll;
   property optionswidget default defaultoptionswidgetmousewheel;
 end;

 tstepboxframe = class(tcustomstepframe)
  published
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
   property caption;
   property captionpos;
   property captiondist;
   property captiondistouter;
   property captionoffset;
   property captionnoclip;
   property font;
   property buttonsize;
   property buttonpos;
   property buttonslast;
   property buttonsinline;
   property buttonsinvisible;
   property buttonsvisible;
   property mousewheel;
 end;

 stepdirty = (sd_right,sd_up,sd_left,sd_down);

 stepeventty = procedure (const sender: tobject; const stepkind: stepkindty) of object;

 tcustomstepbox = class(tpublishedwidget,istepbar,idragcontroller)
  private
   fonstep: stepeventty;
   function getframe: tstepboxframe;
   procedure setframe(const value: tstepboxframe);
  protected
   fdragcontroller: tdragcontroller;
//   finvisiblebuttons: stepkindsty;
   procedure internalcreateframe; override;
   procedure widgetregionchanged(const sender: twidget); override;
   procedure clientmouseevent(var info: mouseeventinfoty); override;
   procedure mouseevent(var info: mouseeventinfoty); override;
   procedure mousewheelevent(var info: mousewheeleventinfoty); override;
  procedure dostep(const event: stepkindty); virtual;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;

   property onstep: stepeventty read fonstep write fonstep;
//   property invisiblebuttons: stepkindsty read finvisiblebuttons write setinvisiblebuttons;

  published
   property frame: tstepboxframe read getframe write setframe;
   property optionswidget default defaultoptionswidgetnofocus;
 end;

 tstepbox = class(tcustomstepbox)
  published
   property onstep;
//   property invisiblebuttons;
 end;

implementation
uses
 msekeyboard,sysutils;

{ tcustombutton }

constructor tcustombutton.create(aowner: tcomponent);
begin
 initactioninfo(factioninfo);
 inherited;
 include(fwidgetstate1,ws1_nodesignframe);
 size:= makesize(defaultbuttonwidth,defaultbuttonheight);
end;

procedure tcustombutton.setoptions(const avalue: buttonoptionsty);
begin
 inherited;
 if bo_flat in avalue then begin
  exclude(fwidgetstate1,ws1_nodesignframe);
 end
 else begin
  include(fwidgetstate1,ws1_nodesignframe);
 end;
end;

procedure tcustombutton.synctofontheight;
begin
 inherited;
 bounds_cy:= font.glyphheight + innerclientframewidth.cy + 6;
end;

procedure tcustombutton.doexecute;
begin
 if assigned(factioninfo.onexecute) then begin
  factioninfo.onexecute(self);
 end;
 if fmodalresult <> mr_none then begin
  window.modalresult:= fmodalresult;
 end;
end;                                           

procedure tcustombutton.dopaint(const canvas: tcanvas);
begin
 finfo.font:= getfont;
 inherited;
end;

function tcustombutton.checkfocusshortcut(var info: keyeventinfoty): boolean;
begin
 result:= inherited checkfocusshortcut(info) or
     (bo_focusonshortcut in options) and
          mserichstring.checkshortcut(info,factioninfo.caption1,true) and canfocus;
end;

procedure tcustombutton.doshortcut(var info: keyeventinfoty; const sender: twidget);
begin
 if not (es_processed in info.eventstate) then begin
  if (bo_executeonshortcut in options) and
           mserichstring.checkshortcut(info,factioninfo.caption1,true) and
           not (ss_disabled in finfo.state) or
     (finfo.state * [ss_invisible,ss_disabled,ss_default] = [ss_default]) and
       (info.key = key_return) and (info.shiftstate = []) then begin
   include(info.eventstate,es_processed);
//   if (fmodalresult = mr_cancel) or window.candefocus and isenabled then begin
   doexecute;
//   end
//   else begin
//    exclude(info.eventstate,es_processed);
//   end;
  end;
  if not (es_processed in info.eventstate) then begin
   inherited;
  end;
 end;
end;

function tcustombutton.getframe: tframe;
begin
 result:= tframe(fframe);
end;

procedure tcustombutton.setframe(const Value: tframe);
begin
 fframe.Assign(value);
end;

procedure tcustombutton.enabledchanged;
begin
 inherited;
 {
 if enabled then begin
  state:= state - [as_disabled];
 end
 else begin
  state:= state + [as_disabled];
 end;
 }
 invalidate;
end;

procedure tcustombutton.visiblechanged;
begin
 inherited;
 {
 if visible then begin
  state:= state - [as_invisible];
 end
 else begin
  state:= state + [as_invisible];
 end;
 }
end;

procedure tcustombutton.actionchanged;
begin
 actioninfotoshapeinfo(self,factioninfo,finfo);
 if csdesigning in componentstate then begin
  exclude(finfo.state,ss_invisible);
 end;
 checkautosize;
end;

function tcustombutton.getactioninfopo: pactioninfoty;
begin
 result:= @factioninfo;
end;

function tcustombutton.shortcutseparator: msechar;
begin
 result:= ' ';
end;

procedure tcustombutton.setaction(const value: tcustomaction);
begin
 linktoaction(iactionlink(self),value,factioninfo);
end;

procedure tcustombutton.setonexecute(const value: notifyeventty);
begin
 setactiononexecute(iactionlink(self),value,csloading in componentstate);
end;

function tcustombutton.isonexecutestored: boolean;
begin
 result:= isactiononexecutestored(factioninfo);
end;

function tcustombutton.getcaption: captionty;
begin
 result:= factioninfo.captiontext;
end;

procedure tcustombutton.setcaption(const Value: captionty);
begin
 setactioncaption(iactionlink(self),value);
end;

function tcustombutton.iscaptionstored: boolean;
begin
 result:= isactioncaptionstored(factioninfo);
end;

procedure tcustombutton.setimagelist(const Value: timagelist);
begin
 setactionimagelist(iactionlink(self),Value);
end;

function tcustombutton.isimageliststored: Boolean;
begin
 result:= isactionimageliststored(factioninfo);
end;

procedure tcustombutton.setimagenr(const Value: integer);
begin
 setactionimagenr(iactionlink(self),Value);
end;

function tcustombutton.isimagenrstored: Boolean;
begin
 result:= isactionimagenrstored(factioninfo);
end;

procedure tcustombutton.setimagenrdisabled(const avalue: integer);
begin
 setactionimagenrdisabled(iactionlink(self),avalue);
end;

function tcustombutton.isimagenrdisabledstored: Boolean;
begin
 result:= isactionimagenrdisabledstored(factioninfo);
end;

procedure tcustombutton.setcolorglyph(const avalue: colorty);
begin
 setactioncolorglyph(iactionlink(self),avalue);
end;

function tcustombutton.iscolorglyphstored: boolean;
begin
 result:= isactioncolorglyphstored(factioninfo);
end;

function tcustombutton.gethint: msestring;
begin
 result:= factioninfo.hint;
end;

procedure tcustombutton.sethint(const Value: msestring);
begin
 setactionhint(iactionlink(self),value);
end;

function tcustombutton.ishintstored: boolean;
begin
 result:= isactionhintstored(factioninfo);
end;

function tcustombutton.getstate: actionstatesty;
begin
 result:= factioninfo.state;
end;

procedure tcustombutton.setstate(const value: actionstatesty);
begin
 setactionstate(iactionlink(self),value);
 visible:= not (as_invisible in factioninfo.state);
 enabled:= not (as_disabled in factioninfo.state);
end;

function tcustombutton.isstatestored: boolean;
begin
 result:= isactionstatestored(factioninfo);
end;

procedure tcustombutton.setcaptionpos(const avalue: captionposty);
begin
 if avalue <> finfo.captionpos then begin
  if avalue in [cp_left,cp_right] then begin
   finfo.captionpos:= avalue;
  end
  else begin
   finfo.captionpos:= cp_center;
  end;
  checkautosize;
//  invalidate;
 end;
end;

procedure tcustombutton.setcaptiondist(const avalue: integer);
begin
 if avalue <> finfo.captiondist then begin
  finfo.captiondist:= avalue;
  checkautosize;
 end;
end;

procedure tcustombutton.setimagedist(const avalue: integer);
begin
 if avalue <> finfo.imagedist then begin
  finfo.imagedist:= avalue;
  checkautosize;
 end;
end;

{
procedure tcustombutton.setenabled(const Value: boolean);
begin
 inherited;
 if value then begin
  state:= state -[ss_disabled];
 end
 else begin
  state:= state +[ss_disabled];
 end;
end;

function tcustombutton.isenabledstored: Boolean;
begin
 result:= isactionenabledstored(factioninfo);
end;


procedure tcustombutton.setvisible(const Value: boolean);
begin
 inherited;
 setactionvisible(iactionlink(self),value);
end;

function tcustombutton.isvisiblestored: Boolean;
begin
 result:= isactionvisiblestored(factioninfo);
end;
}
procedure tcustombutton.readstate(reader: treader);
begin
 actionbeginload(iactionlink(self));
 inherited;
end;

procedure tcustombutton.loaded;
begin
 inherited;
 actionendload(iactionlink(self));
// actionchanged;
end;
{
procedure tcustombutton.doidle;
begin
 actiondoidle(factioninfo);
 inherited;
end;
}
procedure tcustombutton.doenter;
var
 int1: integer;
 widget1: twidget;
begin
 if fparentwidget <> nil then begin
  for int1:= 0 to fparentwidget.widgetcount - 1 do begin
   widget1:= fparentwidget.widgets[int1];
   if widget1 is tcustombutton then begin
    with tcustombutton(widget1) do begin
     if ss_default in finfo.state then begin
      exclude(finfo.state,ss_default);
      invalidate;
     end;
    end;
   end;
  end;
 end;
 inherited;
end;

procedure tcustombutton.doexit;
var
 int1: integer;
 widget1: twidget;
begin
 if fparentwidget <> nil then begin
  for int1:= 0 to fparentwidget.widgetcount - 1 do begin
   widget1:= fparentwidget.widgets[int1];
   if widget1 is tcustombutton then begin
    with tcustombutton(widget1) do begin
     if as_default in factioninfo.state then begin
      if not (ss_default in finfo.state) then begin
       include(finfo.state,ss_default);
       invalidate;
      end;
     end;
    end;
   end;
  end;
 end;
 inherited;
end;

procedure tcustombutton.getautopaintsize(var asize: sizety);
begin
 asize:= textrect(getcanvas,finfo.caption,[],font).size;
 inc(asize.cx,finfo.captiondist);
 if imagelist <> nil then begin
  with imagelist do begin
   if height > asize.cy then begin
    asize.cy:= height;
   end;
   if captionpos <> cp_center then begin
    asize.cx:= asize.cx + width;
   end
   else begin
    if width > asize.cx then begin
     asize.cx:= width;
    end;
   end;
   inc(asize.cx,finfo.imagedist);
  end;
 end;
 inc(asize.cx,8+fautosize_cx);
 inc(asize.cy,6+fautosize_cy);
 if fframe <> nil then begin
  with fframe do begin
   asize.cx:= asize.cx + framei_left + framei_right;
   asize.cy:= asize.cy + framei_top + framei_bottom;
  end;
 end;
end;

procedure tcustombutton.clientrectchanged;
begin
 inherited;
 checkautosize; //for frame.framei
end;

procedure tcustombutton.setautosize_cx(const avalue: integer);
begin
 if fautosize_cx <> avalue then begin
  fautosize_cx:= avalue;
  checkautosize;
 end;
end;

procedure tcustombutton.setautosize_cy(const avalue: integer);
begin
 if fautosize_cy <> avalue then begin
  fautosize_cy:= avalue;
  checkautosize;
 end;
end;

procedure tcustombutton.objectevent(const sender: tobject;
               const event: objecteventty);
begin
 inherited;
 if (event = oe_changed) and (sender = finfo.imagelist) then begin
  actionchanged;
 end;
end;

{
function tcustombutton.getobjectlink: iobjectlink;
begin
 result:= iactionlink(self);
end;
}
{ tstockglyphbutton }

constructor tstockglyphbutton.create(aowner: tcomponent);
begin
 inherited;
 imagelist:= stockobjects.glyphs;
 glyph:= stg_none;
end;

procedure tstockglyphbutton.setglyph(const avalue: stockglyphty);
begin
 fglyph:= avalue;
 imagenr:= ord(avalue);
end;

procedure tstockglyphbutton.setstate(const avalue: actionstatesty);
begin
 inherited setstate(avalue + [as_localimagelist,as_localimagenr]);
end;

procedure tstockglyphbutton.setaction(const avalue: tcustomaction);
begin
 inherited;
 glyph:= glyph;
 imagelist:= stockobjects.glyphs;
end;

{ tcustomlabel }

constructor tcustomlabel.create(aowner: tcomponent);
begin
 ftextflags:= defaultlabeltextflags;
 inherited;
 foptionswidget:= defaultlabeloptionswidget;
 fwidgetrect.cx:= defaultlabelwidgetwidth;
 fwidgetrect.cy:= defaultlabelwidgetheight;
end;

procedure tcustomlabel.dopaint(const canvas: tcanvas);
begin
 inherited;
 drawtext(canvas,fcaption,innerclientrect,factualtextflags,font);
end;

function tcustomlabel.getcaption: msestring;
begin
 result:= richstringtocaption(fcaption);
end;

procedure tcustomlabel.setcaption(const Value: msestring);
begin
 captiontorichstring(Value,fcaption);
 checkautosize;
 invalidate;
end;

procedure tcustomlabel.settextflags(const Value: textflagsty);
begin
 if ftextflags <> value then begin
  ftextflags:= Value;
  updatetextflags;
  checkautosize;
  invalidate;
 end;
end;

procedure tcustomlabel.synctofontheight;
begin
 syncsinglelinefontheight;
end;

procedure tcustomlabel.updatetextflags;
begin
 if not (csloading in componentstate) then begin
  if isenabled or (lao_nogray in foptions) then begin
   factualtextflags:= ftextflags;
  end
  else begin
   factualtextflags:= ftextflags + [tf_grayed];
  end;
 end;
end;

procedure tcustomlabel.enabledchanged;
begin
 inherited;
 updatetextflags;
 invalidate;
end;

procedure tcustomlabel.setoptions(const avalue: labeloptionsty);
begin
 if foptions <> avalue then begin
  foptions:= avalue;
  updatetextflags;
  invalidate;
 end;
end;

procedure tcustomlabel.getautopaintsize(var asize: sizety);
begin
 asize:= textrect(getcanvas,fcaption,ftextflags).size;
 if fframe <> nil then begin
  with fframe do begin
   asize.cx:= asize.cx + framei_left + framei_right;
   asize.cy:= asize.cy + framei_top + framei_bottom;
  end;
 end;
end;

procedure tcustomlabel.fontchanged;
begin
 inherited;
 checkautosize;
end;

procedure tcustomlabel.clientrectchanged;
begin
 inherited;
 checkautosize; //for frame.framei
end;

procedure tcustomlabel.initnewcomponent(const ascale: real);
begin
 inherited;
 caption:= name;
end;

{ tgroupboxframe }

constructor tgroupboxframe.create(const intf: iframe);
begin
 inherited;
 fi.levelo:= -1;
 fi.leveli:= 1;
 fi.innerframe.left:= 2;
 fi.innerframe.top:= 2;
 fi.innerframe.right:= 2;
 fi.innerframe.bottom:= 2;
 captiondist:= -7;
 captionoffset:= 4;
end;

{ tcustomscalingwidget }

procedure tcustomscalingwidget.dochildscaled(const sender: twidget);
begin
 if canevent(tmethod(fonchildscaled)) then begin
  fonchildscaled(self);
 end
 else begin
  inherited;
 end;
end;

procedure tcustomscalingwidget.dofontheightdelta(var delta: integer);
begin
 if canevent(tmethod(fonfontheightdelta)) then begin
  fonfontheightdelta(self,delta);
 end;
 inherited;
end;

procedure tcustomscalingwidget.setoptionsscale(const avalue: optionsscalety);
begin
 if foptionsscale <> avalue then begin
  foptionsscale:= avalue;
  updateoptionsscale;
 end;
end;

procedure tcustomscalingwidget.updateoptionsscale;
var
 size1,size2: sizety;
 rect1: rectty;
 bo1: boolean;
 box,boy: boolean;
begin
 if foptionsscale * [osc_expandx,osc_expandy,
                    osc_shrinkx,osc_shrinky,
                    osc_invisishrinkx,osc_invisishrinky] <> [] then begin
  if (componentstate * [csloading,csdestroying] = []) then begin
   if fscaling <> 0 then begin    
    include(fwidgetstate1,ws1_scaled);
   end
   else begin
    inc(fscaling);
    try
     exclude(fwidgetstate1,ws1_scaled);
     size1:= calcminscrollsize;
     bo1:= not isvisible;
     size2:= paintsize;
     box:= false;
     boy:= false;
//     bo1:= not (visible or (csdesigning in componentstate));
     if (osc_invisishrinkx in foptionsscale) then begin
      if bo1 then begin
       if fsizebefore.cx = 0 then begin
        fsizebefore.cx:= size2.cx;
       end;
       size1.cx:= paintsize.cx-bounds_cx;
      end
      else begin
       if fsizebefore.cx <> 0 then begin
        if foptionsscale * [osc_shrinkx,osc_expandx] <> 
                                         [osc_shrinkx,osc_expandx] then begin
         size1.cx:= fsizebefore.cx;
        end;
        fsizebefore.cx:= 0;
        box:= true;
       end;
      end;
     end;
     if (osc_invisishrinky in foptionsscale) then begin
      if bo1 then begin
       if fsizebefore.cy = 0 then begin
        fsizebefore.cy:= size2.cy;
       end;
       size1.cy:= paintsize.cy-bounds_cy;
      end
      else begin
       if fsizebefore.cy <> 0 then begin
        if foptionsscale * [osc_shrinky,osc_expandy] <> 
                                         [osc_shrinky,osc_expandy] then begin
         size1.cy:= fsizebefore.cy;
        end;
        fsizebefore.cy:= 0;
        boy:= true;
       end;
      end;
     end;
     rect1.cx:= size1.cx - size2.cx;
     rect1.cy:= size1.cy - size2.cy;
     if not (bo1 and (osc_invisishrinkx in foptionsscale)) then begin
      if not (osc_expandx in foptionsscale) and not box then begin
       if rect1.cx > 0 then begin
        rect1.cx:= 0;
       end;
      end;
      if not (osc_shrinkx in foptionsscale) then begin
       if rect1.cx < 0 then begin
        rect1.cx:= 0;
       end;
      end;
     end;
     if not (bo1 and (osc_invisishrinky in foptionsscale)) then begin
      if not (osc_expandy in foptionsscale) and not boy then begin
       if rect1.cy > 0 then begin
        rect1.cy:= 0;
       end;
      end;
      if not (osc_shrinky in foptionsscale) then begin
       if rect1.cy < 0 then begin
        rect1.cy:= 0;
       end;
      end;
     end;
     rect1.pos:= fwidgetrect.pos;
     if an_right in fanchors then begin
      dec(rect1.x,rect1.cx);
     end;
     if an_bottom in fanchors then begin
      dec(rect1.y,rect1.cy);
     end;
     addsize1(rect1.size,fwidgetrect.size);
     internalsetwidgetrect(rect1,false);
     if bo1 then begin
      parentwidgetregionchanged(self);
     end;
    finally
     dec(fscaling)
    end;
   end;
  end;
 end;
end;

procedure tcustomscalingwidget.beginscaling;
begin
 if fscaling = 0 then begin
  exclude(fwidgetstate1,ws1_scaled);
 end;
 inc(fscaling);
end;

procedure tcustomscalingwidget.endscaling;
begin
 dec(fscaling);
 if (fscaling = 0) and (ws1_scaled in fwidgetstate1) then begin
  updateoptionsscale;
 end;
end;

procedure tcustomscalingwidget.widgetregionchanged(const sender: twidget);
begin
 inherited;
 updateoptionsscale;
end;

procedure tcustomscalingwidget.clientrectchanged;
begin
 inherited;
 updateoptionsscale;
end;

procedure tcustomscalingwidget.poschanged;
begin
 inherited;
 if canevent(tmethod(fonmove)) then begin
  fonmove(self);
 end;
end;

procedure tcustomscalingwidget.sizechanged;
begin
 inherited;
 if canevent(tmethod(fonresize)) then begin
  fonresize(self);
 end;
end;

procedure tcustomscalingwidget.visiblepropchanged;
begin
 inherited;
 if foptionsscale * [osc_invisishrinkx,osc_invisishrinky] <> [] then begin
  updateoptionsscale;
 end;
end;

{ tgroupbox }

constructor tgroupbox.create(aowner: tcomponent);
begin
 inherited;
 optionswidget:= defaultgroupboxoptionswidget;
end;

procedure tgroupbox.initnewcomponent(const ascale: real);
begin
 inherited;
 internalcreateframe;
 fframe.scale(ascale);
end;

procedure tgroupbox.internalcreateframe;
begin
 tgroupboxframe.create(iframe(self));
end;

procedure tgroupbox.dofocuschanged(const oldwidget: twidget;
               const newwidget: twidget);
begin
 inherited;
 if canevent(tmethod(fonfocusedwidgetchanged)) and 
  (checkdescendent(oldwidget) or checkdescendent(newwidget)) then begin
  fonfocusedwidgetchanged(oldwidget,newwidget);
 end; 
end;

{ tscrollbox }

constructor tscrollbox.create(aowner: tcomponent);
begin
 inherited;
 foptionswidget:= defaultoptionswidgetmousewheel;
 internalcreateframe;
end;

procedure tscrollbox.internalcreateframe;
begin
 tscrollboxframe.create(iframe(self),self);
end;

function tscrollbox.getframe: tscrollboxframe;
begin
 result:= tscrollboxframe(inherited getframe);
end;

procedure tscrollbox.mouseevent(var info: mouseeventinfoty);
begin
 tscrollframe(fframe).mouseevent(info);
 inherited;
end;

procedure tscrollbox.domousewheelevent(var info: mousewheeleventinfoty);
begin
 tscrollframe(fframe).domousewheelevent(info);
 inherited;
end;

procedure tscrollbox.setframe(const value: tscrollboxframe);
begin
 inherited setframe(value);
end;

procedure tscrollbox.widgetregionchanged(const sender: twidget);
begin
 inherited;
 if not (csdestroying in componentstate) then begin
  tscrollboxframe(fframe).updateclientrect;
 end;
end;

procedure tscrollbox.doscroll(const dist: pointty);
begin
 inherited;
 if canevent(tmethod(fonscroll)) then begin
  fonscroll(self,dist);
 end;
end;

{ tcustomstepbox }

constructor tcustomstepbox.create(aowner: tcomponent);
begin
 inherited;
 internalcreateframe;
 if fdragcontroller = nil then begin
  fdragcontroller:= tdragcontroller.create(idragcontroller(self));
 end;
 optionswidget:= defaultoptionswidgetnofocus;
end;

destructor tcustomstepbox.destroy;
begin
 fdragcontroller.Free;
 inherited;
end;

procedure tcustomstepbox.internalcreateframe;
begin
 tstepboxframe.create(iframe(self),istepbar(self));
end;

procedure tcustomstepbox.clientmouseevent(var info: mouseeventinfoty);
begin
 inherited;
 if not (es_processed in info.eventstate) then begin
  fdragcontroller.clientmouseevent(info);
 end;
end;

procedure tcustomstepbox.mouseevent(var info: mouseeventinfoty);
begin
 tstepboxframe(fframe).mouseevent(info);
 inherited;
end;

function tcustomstepbox.getframe: tstepboxframe;
begin
 result:= tstepboxframe(inherited getframe);
end;

procedure tcustomstepbox.setframe(const value: tstepboxframe);
begin
 inherited setframe(value);
end;

procedure tcustomstepbox.widgetregionchanged(const sender: twidget);
begin
 inherited;
 tscrollboxframe(fframe).updateclientrect;
end;

procedure tcustomstepbox.dostep(const event: stepkindty);
begin
 if canevent(tmethod(fonstep)) then begin
  fonstep(self,event);
 end;
end;

procedure tcustomstepbox.mousewheelevent(var info: mousewheeleventinfoty);
begin
 frame.domousewheelevent(info);
 inherited;
end;

{ tpaintbox }

procedure tpaintbox.dobeforepaint(const canvas: tcanvas);
var
 pt1: pointty;
begin
 inherited;
 if canevent(tmethod(fonbeforepaint)) then begin
  pt1:= clientwidgetpos;
  canvas.move(pt1);
  fonbeforepaint(self,canvas);
  canvas.remove(pt1);
 end;
end;

procedure tpaintbox.dopaintbackground(const canvas: tcanvas);
begin
 inherited;
 if canevent(tmethod(fonpaintbackground)) then begin
  fonpaintbackground(self,canvas);
 end;
end;

procedure tpaintbox.doonpaint(const canvas: tcanvas);
begin
 inherited;
 if canevent(tmethod(fonpaint)) then begin
  fonpaint(self,canvas);
 end;
end;

procedure tpaintbox.doafterpaint(const canvas: tcanvas);
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

end.


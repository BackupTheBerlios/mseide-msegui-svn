{ MSEgui Copyright (c) 1999-2006 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit mseobjectpicker;

{$ifdef FPC}{$mode objfpc}{$h+}{$interfaces corba}{$endif}

interface
uses
 mseevent,mseglob,mseguiglob,mseclasses,msegui,msegraphics,msegraphutils,msepointer,
 msetypes;
{$ifdef FPC}
 { $interfaces corba}
{$endif}

type
 ihintcontroller = interface(inullinterface)
  function getwidget: twidget;
 end;

 thintcontroller = class
  private
   fintf: ihintcontroller;
  public
   constructor create(const intf: ihintcontroller);
   procedure mouseevent(var info: mouseeventinfoty);
 end;

 iobjectpicker = interface(inullinterface)
  function getwidget: twidget;
  function getcursorshape(const apos: pointty; const ashiftstate: shiftstatesty; 
                                    var ashape: cursorshapety): boolean;
                            //true if object found
  procedure getpickobjects(const arect: rectty;  const ashiftstate: shiftstatesty;
                                    var objects: integerarty);
  procedure beginpickmove(const aobjects: integerarty);
  procedure endpickmove(const apos: pointty; const ashiftstate: shiftstatesty;
                    const aoffset: pointty; const aobjects: integerarty);
  procedure paintxorpic(const acanvas: tcanvas; const apos,aoffset: pointty;
                const aobjects: integerarty);
 end;

 objectpickerstatety = (ops_moving,ops_xorpicpainted{,ops_cursorchanged});
 objectpickerstatesty = set of objectpickerstatety;
// objectpickeroptionty = (opo_candoubleclick);
// objectpickeroptionsty = set of objectpickeroptionty;
 
 tobjectpicker = class      //todo: area selecting, area deselecting
  private
   fintf: iobjectpicker;
   fobjects: integerarty;
   fpickpos: pointty;
   fpickoffset: pointty;
   fstate: objectpickerstatesty;
   forigin: originty;
//   foptions: objectpickeroptionsty;
   procedure removexorpic;
   procedure paintxorpic;
   procedure dokeypress(const sender: twidget; var info: keyeventinfoty);
   procedure endmoving;
  public
   constructor create(const intf: iobjectpicker; aorigin: originty = org_client);
   destructor destroy; override;
   procedure mouseevent(var info: mouseeventinfoty);
   procedure restorexorpic(const canvas: tcanvas);
   property objects: integerarty read fobjects;
//   property options: objectpickeroptionsty read foptions write foptions;
 end;

implementation
uses
 msekeyboard;
type
 twidget1 = class(twidget);

{ tobjectpicker }

constructor tobjectpicker.create(const intf: iobjectpicker;
           aorigin: originty = org_client);
begin
 fintf:= intf;
 forigin:= aorigin;
end;

destructor tobjectpicker.destroy;
begin
 application.unregisteronkeypress({$ifdef FPC}@{$endif}dokeypress);
 inherited;
end;

procedure tobjectpicker.endmoving;
var
 widget1: twidget;
begin
 application.unregisteronkeypress({$ifdef FPC}@{$endif}dokeypress);
 removexorpic;
 widget1:= twidget1(fintf.getwidget);
// widget1.cursor:= fcursorbefore;
 widget1.releasemouse;
 application.widgetcursorshape:= cr_default;
 exclude(fstate,ops_moving);
end;

procedure tobjectpicker.mouseevent(var info: mouseeventinfoty);
var
 shape: cursorshapety;
 widget1: twidget1;

 procedure doend;
 begin
    endmoving;
    fintf.endpickmove(info.pos,info.shiftstate,fpickoffset,fobjects);
    with fintf.getwidget do begin
     shape:= actualcursor(widgetmousepos(info));
    end;
    fintf.getcursorshape(info.pos,info.shiftstate,shape);
    application.widgetcursorshape:= shape;
           //restore pick cursor
    include(info.eventstate,es_processed);
 end;

begin
 case info.eventkind of
  ek_buttonpress: begin
   if info.button = mb_left then begin
    fobjects:= nil;
    exclude(fstate,ops_moving);
    fintf.getcursorshape(info.pos,info.shiftstate,shape); //refresh positioninfo
    fintf.getpickobjects(makerect(info.pos,nullsize),info.shiftstate,fobjects);
    fpickpos:= info.pos;
    fpickoffset:= nullpoint;
    if length(fobjects) > 0 then begin
     application.registeronkeypress({$ifdef FPC}@{$endif}dokeypress);
     include(fstate,ops_moving);
     widget1:= twidget1(fintf.getwidget);
     widget1.capturemouse(true);
     fintf.beginpickmove(fobjects);
     paintxorpic;
     include(info.eventstate,es_processed);
//     if (ss_double in info.shiftstate) and 
//                          (opo_candoubleclick in foptions) then begin
//      doend;
//     end;
    end;
   end;
  end;
  ek_buttonrelease: begin
   if (info.button = mb_left) and (ops_moving in fstate) then begin
    doend;
   end;
  end;
  ek_mousemove,ek_mousepark: begin
   if ops_moving in fstate then begin
    removexorpic;
    fpickoffset:= subpoint(info.pos,fpickpos);
    paintxorpic;
    include(info.eventstate,es_processed);
   end
   else begin
    with fintf.getwidget do begin
     shape:= actualcursor(widgetmousepos(info));
    end;
    if fintf.getcursorshape(info.pos,info.shiftstate,shape) then begin
     include(info.eventstate,es_processed);
//     include(fstate,ops_cursorchanged);
     application.widgetcursorshape:= shape;
    end
    else begin
     application.widgetcursorshape:= cr_default;
//     if ops_cursorchanged in fstate then begin
//      exclude(fstate,ops_cursorchanged);
//      application.updatecursorshape;
//     end;
    end;
   end;
  end;
//  ek_mouseleave,ek_clientmouseleave: begin
//   fintf.getwidget.updatecursorshape{(true)};
//  end;
 end;
end;

procedure tobjectpicker.paintxorpic;
var
 canvas1: tcanvas;
 widget1: twidget;
begin
 if not (ops_xorpicpainted in fstate) then begin
  widget1:= fintf.getwidget;
  widget1.update;
  canvas1:= widget1.getcanvas(forigin);
  canvas1.rasterop:= rop_xor;
  fintf.paintxorpic(canvas1,addpoint(fpickoffset,fpickpos),fpickoffset,fobjects);
  include(fstate,ops_xorpicpainted);
 end;
end;

procedure tobjectpicker.removexorpic;
var
 canvas1: tcanvas;
begin
 if ops_xorpicpainted in fstate then begin
  canvas1:= fintf.getwidget.getcanvas(forigin);
  canvas1.rasterop:= rop_xor;
  fintf.paintxorpic(canvas1,addpoint(fpickoffset,fpickpos),fpickoffset,fobjects);
  exclude(fstate,ops_xorpicpainted);
 end;
end;

procedure tobjectpicker.restorexorpic(const canvas: tcanvas);
var
 int1: integer;
begin
 if ops_moving in fstate then begin
  int1:= canvas.save;
  canvas.rasterop:= rop_xor;
  if not (forigin = org_widget) then begin //todo org_screen
   canvas.intersectcliprect(fintf.getwidget.clientrect);
   canvas.move(fintf.getwidget.clientwidgetpos);
  end;
  fintf.paintxorpic(canvas,addpoint(fpickoffset,fpickpos),fpickoffset,fobjects);
  include(fstate,ops_xorpicpainted);
  canvas.restore(int1);
 end;
end;

procedure tobjectpicker.dokeypress(const sender: twidget;
               var info: keyeventinfoty);
begin
 if (ops_moving in fstate) and (info.key = key_escape) then begin
  endmoving;
  include(info.eventstate,es_processed);
 end;
end;

{ thintcontroller }

constructor thintcontroller.create(const intf: ihintcontroller);
begin
 fintf:= intf;
end;

procedure thintcontroller.mouseevent(var info: mouseeventinfoty);
begin

end;

end.

{ MSEgui Copyright (c) 1999-2006 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit mseobjectpicker;

{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface
uses
 mseevent,mseguiglob,mseclasses,msegui,msegraphics,msegraphutils,msepointer,
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
  function getcursorshape(const pos: pointty; const shiftstate: shiftstatesty; 
                                    var shape: cursorshapety): boolean;
   //true if found
  procedure getpickobjects(const rect: rectty;  const shiftstate: shiftstatesty;
                                    var objects: integerarty);
  procedure beginpickmove(const objects: integerarty);
  procedure endpickmove(const pos,offset: pointty; const objects: integerarty);
  procedure paintxorpic(const canvas: tcanvas; const pos,offset: pointty;
                const objects: integerarty);
 end;

 objectpickerstatety = (ops_moving,ops_xorpicpainted,ops_cursorchanged);
 objectpickerstatesty = set of objectpickerstatety;

 tobjectpicker = class      //todo: area selecting, area deselecting
  private
   fintf: iobjectpicker;
   fobjects: integerarty;
   fpickpos: pointty;
   fpickoffset: pointty;
   fstate: objectpickerstatesty;
   forigin: originty;
   fcursorbefore: cursorshapety;
   procedure removexorpic;
   procedure paintxorpic;
  public
   constructor create(const intf: iobjectpicker; aorigin: originty = org_client);
   procedure mouseevent(var info: mouseeventinfoty);
   procedure restorexorpic(const canvas: tcanvas);
   property objects: integerarty read fobjects;
 end;

implementation
type
 twidget1 = class(twidget);

{ tobjectpicker }

constructor tobjectpicker.create(const intf: iobjectpicker;
           aorigin: originty = org_client);
begin
 fintf:= intf;
 forigin:= aorigin;
end;

procedure tobjectpicker.mouseevent(var info: mouseeventinfoty);
var
 shape: cursorshapety;
 widget1: twidget1;
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
     include(fstate,ops_moving);
     widget1:= twidget1(fintf.getwidget);
     fcursorbefore:= widget1.cursor;
     widget1.cursor:= application.mouse.shape;
     widget1.capturemouse(true);
     fintf.beginpickmove(fobjects);
     paintxorpic;
     include(info.eventstate,es_processed);
    end;
   end;
  end;
  ek_buttonrelease: begin
   if (info.button = mb_left) and (ops_moving in fstate) then begin
    removexorpic;
    widget1:= twidget1(fintf.getwidget);
    widget1.cursor:= fcursorbefore;
//    widget1.updatecursorshape(true);
    widget1.releasemouse;
    fintf.endpickmove(info.pos,fpickoffset,fobjects);
    exclude(fstate,ops_moving);
    include(info.eventstate,es_processed);
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
    shape:= fintf.getwidget.cursor;
    if fintf.getcursorshape(info.pos,info.shiftstate,shape) then begin
     include(info.eventstate,es_processed);
     include(fstate,ops_cursorchanged);
     application.cursorshape:= shape;
    end
    else begin
     if ops_cursorchanged in fstate then begin
      exclude(fstate,ops_cursorchanged);
      application.updatecursorshape;
     end;
    end;
   end;
  end;
  ek_mouseleave,ek_clientmouseleave: begin
   fintf.getwidget.updatecursorshape(true);
  end;
 end;
end;

procedure tobjectpicker.paintxorpic;
var
 canvas1: tcanvas;
begin
 if not (ops_xorpicpainted in fstate) then begin
  canvas1:= fintf.getwidget.getcanvas(forigin);
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

{ thintcontroller }

constructor thintcontroller.create(const intf: ihintcontroller);
begin
 fintf:= intf;
end;

procedure thintcontroller.mouseevent(var info: mouseeventinfoty);
begin

end;

end.

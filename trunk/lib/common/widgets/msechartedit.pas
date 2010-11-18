{ MSEgui Copyright (c) 1999-2010 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit msechartedit;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 classes,msechart,mseguiglob,mseevent,mseeditglob,msegraphutils,msetypes,
 mseobjectpicker,msepointer,msegraphics;
 
const
 defaultsnapdist = 4;
 
type
 tchartedit = class(tchart,iobjectpicker)
  private
   factivetrace: integer;
   foptionsedit: optionseditty;
   fobjectpicker: tobjectpicker;
   fsnapdist: integer;
   foffsetmin: pointty;
   foffsetmax: pointty;
   procedure setactivetrace(const avalue: integer);
   function limitmoveoffset(const aoffset: pointty): pointty;
  protected
   function hasactivetrace: boolean;
   function nodepos(const aindex: integer): pointty;
   function nearestnode(const apos: pointty): integer;   
   function chartcoord(const avalue: complexty): pointty;
   function tracecoord(const apos: pointty): complexty;
   procedure clientmouseevent(var info: mouseeventinfoty); override;
    //iobjectpicker
   function getcursorshape(const apos: pointty;  const shiftstate: shiftstatesty;
                const objects: integerarty; var shape: cursorshapety): boolean;
   procedure getpickobjects(const rect: rectty;  const shiftstate: shiftstatesty;
                                    var objects: integerarty);
   procedure beginpickmove(const apos: pointty;
               const ashiftstate: shiftstatesty; const objects: integerarty);
   procedure endpickmove(const apos: pointty; const ashiftstate: shiftstatesty;
                         const offset: pointty; const objects: integerarty);
   procedure paintxorpic(const canvas: tcanvas; const apos,offset: pointty;
                                   const objects: integerarty);
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
  published
   property activetrace: integer read factivetrace 
                           write setactivetrace default 0;
   property optoinsedit: optionseditty read foptionsedit 
                                     write foptionsedit default [];
   property snapdist: integer read fsnapdist write fsnapdist 
                                              default defaultsnapdist;
 end;
 
implementation
uses
 msereal;
 
{ tchartedit }

constructor tchartedit.create(aowner: tcomponent);
begin
 fsnapdist:= defaultsnapdist;
 inherited;
 fobjectpicker:= tobjectpicker.create(iobjectpicker(self));
 fobjectpicker.options:= [opo_mousemoveobjectquery];
end;

destructor tchartedit.destroy;
begin
 fobjectpicker.free;
 inherited;
end;

procedure tchartedit.setactivetrace(const avalue: integer);
begin
 factivetrace:= avalue;
end;

function tchartedit.hasactivetrace: boolean;
begin
 result:= (factivetrace >= 0) and (factivetrace < traces.count);
end;

procedure tchartedit.clientmouseevent(var info: mouseeventinfoty);
var
 co1: complexty;
begin
 if not (es_processed in info.eventstate) then begin
  fobjectpicker.mouseevent(info);
  if not (es_processed in info.eventstate) and 
     not (csdesigning in componentstate) and not (oe_readonly in foptionsedit) and 
            hasactivetrace then begin
   if (info.eventkind = ek_buttonpress) and 
             (info.shiftstate * shiftstatesmask = [ss_left]) then begin
    if pointinrect(info.pos,innerclientrect) then begin
     co1:= tracecoord(info.pos);
     with traces[factivetrace] do begin
      addxydata(co1.re,co1.im);
     end;
     include(info.eventstate,es_processed);
    end;   
   end;
   if not (es_processed in info.eventstate) then begin
    inherited;
   end;
  end;
 end;
end;

function tchartedit.tracecoord(const apos: pointty): complexty;
var
 rect1: rectty;
begin
 rect1:= innerclientrect;
 with traces[factivetrace] do begin
  if rect1.cx <= 0 then begin
   result.re:= xstart;
  end
  else begin
   result.re:= xstart + ((apos.x - rect1.x) / rect1.cx)*xrange;
  end;
  if rect1.cy <= 0 then begin
   result.im:= ystart;
  end
  else begin
   result.im:= ystart + ((rect1.y+rect1.cy-apos.y) / rect1.cy)*yrange;
  end;
 end;
end;

function tchartedit.chartcoord(const avalue: complexty): pointty;
var
 rect1: rectty;
begin
 rect1:= innerclientrect;
 with traces[factivetrace] do begin
  result.x:= rect1.x + round(((avalue.re-start)/xrange)*rect1.cx);
  result.y:= rect1.y + rect1.cy - round(((avalue.im-start)/xrange)*rect1.cy);
 end;
end;

function tchartedit.nodepos(const aindex: integer): pointty;
begin
 with traces[factivetrace] do begin
  result:= chartcoord(xyvalue[aindex]);
 end;
end;

function tchartedit.nearestnode(const apos: pointty): integer;   
var
 dist: integer;
 int1,int2,int3: integer;
 datahigh: integer;
 px,py: preal;
 pxy: pcomplexty;
// nearestpos: pointty;
 pt1: pointty;
begin
 result:= -1;
 if hasactivetrace then begin
  with traces[factivetrace] do begin
   dist:= maxint;
   datahigh:= count-1;
   pxy:= xydatapo;
   if pxy <> nil then begin
    for int1:= 0 to datahigh do begin
     pt1:= chartcoord(pxy^);
     int2:= apos.x - pt1.x;
     int2:= int2*int2;
     int3:= apos.y - pt1.y;
     int3:= int3*int3;
     int3:= int2+int3;
     if int3 < dist then begin
      dist:= int3;
      result:= int1;
     end;
     inc(pxy);
    end;
   end
   else begin
    px:= xdatapo;
    py:= ydatapo;
    if (px <> nil) and (py <> nil) then begin
     for int1:= 0 to datahigh do begin
      pt1:= chartcoord(makecomplex(px^,py^));
      int2:= apos.x - pt1.x;
      int2:= int2*int2;
      int3:= apos.y - pt1.y;
      int3:= int3*int3;
      int3:= int2+int3;
      if int3 < dist then begin
       dist:= int3;
       result:= int1;
      end;
      inc(px);
      inc(py);
     end;
    end;
   end;
   if (dist >= fsnapdist*fsnapdist) then begin
    result:= -1;
   end;
  end;
 end;
end;

function tchartedit.getcursorshape(const apos: pointty;
               const shiftstate: shiftstatesty;
               const objects: integerarty; var shape: cursorshapety): boolean;
begin
 result:= (shiftstate*buttonshiftstatesmask = [ss_left]) and 
                                                   (high(objects) = 0);
 if result then begin
  shape:= cr_none;
 end;
end;

procedure tchartedit.getpickobjects(const rect: rectty;
               const shiftstate: shiftstatesty; var objects: integerarty);
var
 int1: integer;
 
begin
 if (rect.cx = 0) and (rect.cy = 0) then begin
  int1:= nearestnode(rect.pos);
  if int1 >= 0 then begin
   setlength(objects,1);
   objects[0]:= int1;
  end
  else begin
   objects:= nil;
  end;
 end;
end;

function tchartedit.limitmoveoffset(const aoffset: pointty): pointty;
begin
 result:= aoffset;
 if ops_moving in fobjectpicker.state then begin
  if result.x > foffsetmax.x then begin
   result.x:= foffsetmax.x;
  end;
  if result.y > foffsetmax.y then begin
   result.y:= foffsetmax.y;
  end;
  if result.x < foffsetmin.x then begin
   result.x:= foffsetmin.x;
  end;
  if result.y < foffsetmin.y then begin
   result.y:= foffsetmin.y;
  end;
 end;
end;

procedure tchartedit.beginpickmove(const apos: pointty;
               const ashiftstate: shiftstatesty; const objects: integerarty);
var
 rect1: rectty;
 int1,int2,int3,int4: integer;
 mi,ma: pointty;
 pt1: pointty;
 ar1: pointarty;
begin
 rect1:= innerclientrect;
 mi.x:= maxint;
 mi.y:= maxint;
 ma.x:= minint;
 ma.y:= minint;
 setlength(ar1,length(objects));
 for int1:= 0 to high(objects) do begin
  pt1:= nodepos(objects[int1]);
  ar1[int1]:= pt1;
  if pt1.x < mi.x then begin
   mi.x:= pt1.x;
  end;
  if pt1.y < mi.y then begin
   mi.y:= pt1.y;
  end;
  if pt1.x > ma.x then begin
   ma.x:= pt1.x;
  end;
  if pt1.y > ma.y then begin
   ma.y:= pt1.y;
  end;
 end;
 with rect1 do begin
  foffsetmin.x:= x - mi.x;
  foffsetmin.y:= y - mi.y;
  foffsetmax.x:= x + cx - ma.x;
  foffsetmax.y:= y + cy - ma.y;
 end;
 if cto_xordered in traces[factivetrace].options then begin
            //limit to neighbours
  for int1:= 0 to high(ar1) do begin
   int2:= objects[int1];
   if (int2 > 0) and ((int1 = 0) or (objects[int1-1] <> int2 - 1)) then begin
    pt1:= nodepos(int2-1);
    int3:= pt1.x - ar1[int1].x;
    if int3 > foffsetmin.x then begin
     foffsetmin.x:= int3;
    end;
   end;
   int4:= traces[factivetrace].count - 1;
   if (int2 < int4) and ((int1 = high(ar1)) or 
                         (objects[int1+1] <> int2 + 1)) then begin
    pt1:= nodepos(int2+1);
    int3:= pt1.x - ar1[int1].x;
    if int3 < foffsetmax.x then begin
     foffsetmax.x:= int3;
    end;
   end;
  end;
 end;
end;

procedure tchartedit.endpickmove(const apos: pointty;
               const ashiftstate: shiftstatesty; const offset: pointty;
               const objects: integerarty);
var
 int1,int2: integer;
 pt1: pointty;
 co1,co2: complexty;
 offs: pointty;
begin
 offs:= limitmoveoffset(offset);
 for int1:= 0 to high(objects) do begin
  int2:= objects[int1];
  pt1:= nodepos(int2);
  co1:= traces[factivetrace].xyvalue[int2];
  co2:= tracecoord(addpoint(pt1,offs));
  if offset.x <> 0 then begin //no rounding if nochange
   co1.re:= co2.re;
  end;
  if offset.y <> 0 then begin //no rounding if nochange
   co1.im:= co2.im;
  end;
  traces[factivetrace].xyvalue[int2]:= co1;
 end;
end;

procedure tchartedit.paintxorpic(const canvas: tcanvas; const apos: pointty;
               const offset: pointty; const objects: integerarty);
var
 ar1: pointarty;
 ar2: segmentarty;
 int1,int2: integer;
 offs: pointty;
begin
 if objects <> nil then begin
  offs:= limitmoveoffset(offset);
  setlength(ar1,length(objects));
  setlength(ar2,length(objects)*2); //max
  int2:= 0;
  for int1:= 0 to high(objects) do begin
   ar1[int1]:= addpoint(nodepos(objects[int1]),offs);
   if objects[int1] > 0 then begin
    ar2[int2].a:= nodepos(objects[int1]-1);
    ar2[int2].b:= ar1[int1];
    inc(int2);
   end;
   if objects[int1] < traces[factivetrace].count-1 then begin
    ar2[int2].a:= ar1[int1];
    ar2[int2].b:= nodepos(objects[int1]+1);
    inc(int2);
   end;
  end;
  setlength(ar2,int2);
  canvas.drawlinesegments(ar2);
  for int1:= 0 to high(ar1) do begin
   canvas.drawellipse(makerect(ar1[int1],makesize(6,6)));
  end;
  if (ops_moving in fobjectpicker.state) and (high(objects) = 0) then begin
   canvas.drawline(makepoint(0,ar1[0].y),makepoint(clientwidth,ar1[0].y));
   canvas.drawline(makepoint(ar1[0].x,0),makepoint(ar1[0].x,clientheight));
                    //crosshair cursor
  end;
 end;
end;

end.

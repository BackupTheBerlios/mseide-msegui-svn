{ MSEide Copyright (c) 1999-2006 by Martin Schreiber
   
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
}
unit watchpointsform;

{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface
uses
 msegui,mseclasses,mseforms,msedataedits,msegraphedits,msewidgetgrid,msestat,
 msegdbutils,msesimplewidgets,msemenus;

type
 twatchpointsfo = class(tdockform)
   gripopup: tpopupmenu;
   tlabel1: tlabel;
   wptkind: tenumedit;
   wptno: tintegeredit;
   wptcondition: tstringedit;
   wptignore: tintegeredit;
   wptcount: tintegeredit;
   wptexpression: tstringedit;
   wpton: tbooleanedit;
   grid: twidgetgrid;
   procedure wptondataentered(const sender: TObject);
   procedure wptononsetvalue(const sender: TObject; var avalue: Boolean;
                        var accept: Boolean);
   procedure watchpointsonshow(const sender: TObject);
   procedure deleteallonexecute(const sender: TObject);
  private
   procedure changed;
   function watchpointerror(const error: gdbresultty): boolean;
  public
   gdb: tgdbmi;
   procedure refresh(const breakpoints: breakpointinfoarty);
   procedure clear(const all: boolean = false);
 end;

var
 watchpointsfo: twatchpointsfo;

implementation

uses
 watchpointsform_mfm,projectoptionsform,msewidgets,breakpointsform;

{ twatchpointsfo }

procedure twatchpointsfo.refresh(const breakpoints: breakpointinfoarty);
var
 int1,int2: integer;
begin
 for int1:= 0 to grid.rowhigh do begin
  for int2:= 0 to high(breakpoints) do begin
   with breakpoints[int2] do begin
    if bkptno = wptno[int1] then begin
     wptcount[int1]:= passcount;
    end;
   end;
  end;
 end;
end;

procedure twatchpointsfo.clear(const all: boolean);
begin
 if all then begin
  grid.clear;
 end
 else begin
  wpton.fillcol(false);
 end;
end;

procedure twatchpointsfo.changed;
begin
 with projectoptions do begin
  modified:= true;
//  watchpointexpressions:= wptexpression.gridvalues;
//  watchpointignore:= wptignore.gridvalues;
//  watchpointconditions:= wptcondition.gridvalues;
//  watchpointkinds:= wptkind.gridvalues;
 end;
end;

function twatchpointsfo.watchpointerror(const error: gdbresultty): boolean;
var
 str1: string;
begin
 result:= error <> gdb_ok;
 if result then begin
  if error = gdb_message then begin
   str1:= gdb.errormessage;
  end
  else begin
   str1:= 'Watchpoint error.';
  end;
  showmessage(str1,'WATCHPOINT ERROR');
 end;
end;

procedure twatchpointsfo.wptondataentered(const sender: TObject);
begin
 changed;
 wpton.value:= false;
 if gdb.started then begin
  wpton.checkvalue;
 end;
end;

procedure twatchpointsfo.watchpointsonshow(const sender: TObject);
begin
 breakpointsfo.refresh;
end;

procedure twatchpointsfo.wptononsetvalue(const sender: TObject;
                      var avalue: Boolean; var accept: Boolean);
var
 info: watchpointinfoty;
begin
 if gdb.started then begin
  if avalue then begin
   with info do begin
    kind:= watchpointkindty(wptkind.value);
    expression:= wptexpression.value;
    ignore:= wptignore.value;
    condition:= wptcondition.value;
   end;
   if watchpointerror(gdb.watchinsert(info)) then begin
    avalue:= false;
    wptno.value:= 0;
   end
   else begin
    wptno.value:= info.wptno;
   end;
  end
  else begin
   if wptno.value <> 0 then begin
    gdb.breakdelete(wptno.value);
    wptno.value:= 0;
   end;
  end;
 end
 else begin
  showerror('Program not loaded.');
 end;
end;

procedure twatchpointsfo.deleteallonexecute(const sender: TObject);
begin
 if askok('Do you wish to delete all watchpoints?','Confirmation') then begin
  grid.clear;
 end;
end;

end.

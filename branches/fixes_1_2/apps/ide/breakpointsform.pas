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
unit breakpointsform;

{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface
uses
 mseforms,msewidgetgrid,msedataedits,msegdbutils,msetypes,msegrids,msegraphedits,
 msestat,msemenuwidgets,msemenus,msestrings;

type
 bkptstatety = (bkpts_none,bkpts_normal,bkpts_disabled,bkpts_error);

 bkptlineinfoty = record
  line: integer;
  state: bkptstatety;
 end;
 bkptlineinfoarty = array of bkptlineinfoty;

 tbreakpointsfo = class(tdockform)
   grid: twidgetgrid;
   filename: tstringedit;
   path: tstringedit;
   line: tintegeredit;
   bkptno: tintegeredit;
   bkpton: tbooleanedit;
   bkptson: tbooleanedit;
   condition: tstringedit;
   conderr: tdataicon;
   ignore: tintegeredit;
   count: tintegeredit;
   gridpopup: tpopupmenu;
   flags: tintegeredit;
   procedure bkptsononchange(const sender: TObject);
   procedure bkptsononsetvalue(const sender: TObject; var avalue: boolean;
                                            var accept: Boolean);

   procedure breakpointsonshow(const sender: TObject);
   procedure gridoncellevent(const sender: TObject; var info: celleventinfoty);
   procedure gridonrowsdeleted(const sender: tcustomgrid; const aindex: Integer;
                       const acount: Integer);
   procedure gridonrowsdeleting(const sender: tcustomgrid; var aindex,acount: integer);

   procedure ononsetvalue(const sender: TObject; var avalue: Boolean;
                      var accept: Boolean);
   procedure ignoreonsetvalue(const sender: TObject; var avalue: Integer; var accept: Boolean);
   procedure conditiononsetvalue(const sender: TObject; var avalue: mseString; var accept: Boolean);
   procedure ondataentered(const sender: tobject);

   procedure lineonsetvalue(const sender: TObject; var avalue: Integer; var accept: Boolean);
   procedure filenameonsetvalue(const sender: tobject; var avalue: msestring; var accept: boolean);
   procedure ondataenterednewbkpt(const sender: tobject);

   procedure deleteallexecute(const sender: TObject);
  private
   fbreakpointsvalid: boolean;
   function infotolineinfo(const info: breakpointinfoty): bkptlineinfoty;
   function breakpointerror(const error: gdbresultty): boolean;
   procedure removeactbreakpoint;
   function findbreakpointrow(const anum: integer): integer;
  protected
   procedure infotolist(const index: integer; const info: breakpointinfoty;
                          const nobkpton: boolean);
   procedure listtoinfo(const index: integer; var info: breakpointinfoty);
   procedure changed;
   procedure insertbkpt(index: integer; withcondition,witherrormessage: boolean);
  public
   gdb: tgdbmi;
   procedure clear;
   procedure refresh;
   procedure updatestat(const statfiler: tstatfiler);
   function addbreakpoint(var info: breakpointinfoty): boolean;
                 //true if gdb ok
   procedure deletebreakpoint(var info: breakpointinfoty);
   function updatebreakpointon(var info: breakpointinfoty): boolean;
                 //true if gdb ok
   function getbreakpointlines(const filepath: filenamety): bkptlineinfoarty;
   procedure sourcelinesinserted(const filepath: filenamety; const aindex,acount: integer);
   procedure sourcelinesdeleted(const filepath: filenamety; const aindex,acount: integer);

   procedure updatebreakpoints; //transfer breakpoints to gdb
   procedure showbreakpoint(const filepath: filenamety; const aline: integer; focus: boolean);
   function checkbreakpointcontinue(const stopinfo: stopinfoty): boolean;
                                //set condition
 end;

var
 breakpointsfo: tbreakpointsfo;

implementation

uses
 breakpointsform_mfm,msefileutils,sourceform,projectoptionsform,msedatalist,
 main,msewidgets,actionsmodule,watchpointsform,mseformatstr;

{ tbreakpointsfo }

procedure tbreakpointsfo.updatestat(const statfiler: tstatfiler);
var
 int1: integer;
begin
 with statfiler,projectoptions do begin
  setsection('breakpoints');
  updatevalue('on',breakpointons);
  updatevalue('path',breakpointpaths);
  updatevalue('line',breakpointlines);
  updatevalue('ignore',breakpointignore);
  updatevalue('condition',breakpointconditions);
  if not iswriter then begin
   ignore.gridvalues:= breakpointignore;
   condition.gridvalues:= breakpointconditions;
   bkpton.gridvalues:= breakpointons;
   path.gridvalues:= breakpointpaths;
   line.gridvalues:= breakpointlines;
//   updatebreakpoints(true);
  end;
//  updatestat(istatfile(bkptson));
//  updatestat(istatfile(grid));
 end;
 for int1:= 0 to grid.rowhigh do begin
  filename[int1]:= msefileutils.filename(path[int1]);
 end;
end;

procedure tbreakpointsfo.infotolist(const index: integer;
  const info: breakpointinfoty; const nobkpton: boolean);
var
 int1: integer;
 lineinfo: bkptlineinfoty;
 info1: breakpointinfoty;
begin
 path[index]:= info.path;
 filename[index]:= msefileutils.filename(info.path);
 line[index]:= info.line;
 bkptno[index]:= info.bkptno;
 if not nobkpton then begin
  bkpton[index]:= info.bkpton;
 end;
 ignore[index]:= info.ignore;
 if info.conditionmessage <> '' then begin
  int1:= 0;
 end
 else begin
  int1:= -1;
 end;
 conderr[index]:= int1;
 condition[index]:= info.condition;
 info1:= info;
 info1.bkpton:= bkpton[index];
 lineinfo:= infotolineinfo(info1);
 sourcefo.updatebreakpointicon(info.path,lineinfo);
end;

procedure tbreakpointsfo.listtoinfo(const index: integer; var info: breakpointinfoty);
begin
 info.path:= path[index];
 info.line:= line[index];
 info.bkptno:= bkptno[index];
 info.bkpton:= bkpton[index] and bkptson.value;
 info.ignore:= ignore[index];
 info.condition:= condition[index];
 if (info.conditionmessage = '') and (conderr[index] = 0) then begin
  info.conditionmessage:= ' '; //old error
 end;
end;

procedure tbreakpointsfo.bkptsononchange(const sender: TObject);
var
 int1: integer;
 bo1: boolean;
begin
 projectoptions.modified:= true;
 if gdb.execloaded then begin
  bo1:= bkptson.value;
  gdb.interrupttarget;
  for int1:= 0 to grid.rowhigh do begin
   if bkpton[int1] then begin
    gdb.breakenable(bkptno[int1],bo1);
   end;
  end;
  gdb.restarttarget;
 end;
end;

procedure tbreakpointsfo.bkptsononsetvalue(
            const sender: TObject; var avalue: boolean; var accept: Boolean);
begin
 actionsmo.bkptsonact.checked:= avalue;
end;

procedure tbreakpointsfo.breakpointsonshow(const sender: TObject);
begin
 refresh;
end;

procedure tbreakpointsfo.gridoncellevent(const sender: TObject; var info: celleventinfoty);
begin
 if iscellclick(info,[ccr_dblclick]) then begin
  sourcefo.showsourceline(path[info.cell.row],line[info.cell.row]-1,0,true);
 end;
end;

procedure tbreakpointsfo.gridonrowsdeleted(const sender: tcustomgrid;
           const aindex: Integer; const acount: Integer);
begin
 changed;
end;

procedure tbreakpointsfo.gridonrowsdeleting(const sender: tcustomgrid;
  var aindex, acount: integer);
var
 int1,int2: integer;
 info: bkptlineinfoty;
begin
 if gdb.execloaded then begin
  for int1:= aindex to aindex + acount - 1 do begin
   int2:= bkptno[int1];
   if int2 > 0 then begin
    gdb.breakdelete(int2);
   end;
  end;
 end;
 for int1:= aindex to aindex + acount - 1 do begin
  info.line:= line[int1];
  if info.line > 0 then begin
   info.state:= bkpts_none;
   sourcefo.updatebreakpointicon(path[int1],info);
  end;
 end;
end;

procedure tbreakpointsfo.deletebreakpoint(var info: breakpointinfoty);
var
 int1: integer;
 wstr1: msestring;
begin
 wstr1:= msefileutils.filename(info.path);
 for int1:= grid.rowcount - 1 downto 0 do begin
  if (line[int1] = info.line) and (filename[int1] = wstr1) then begin
   grid.deleterow(int1);
  end;
 end;
end;

function tbreakpointsfo.infotolineinfo(const info: breakpointinfoty): bkptlineinfoty;
begin
 result.line:= info.line;
 if info.bkpton then begin
  if info.conditionmessage <> '' then begin
   result.state:= bkpts_error;
  end
  else begin
   result.state:= bkpts_normal;
  end;
 end
 else begin
  result.state:= bkpts_disabled;
 end;
end;

function tbreakpointsfo.getbreakpointlines(const filepath: filenamety): bkptlineinfoarty;
var
 int1,int2: integer;
 wstr1: filenamety;
begin
 int2:= 0;
 wstr1:= msefileutils.filename(filepath);
 setlength(result,grid.rowcount);
 for int1:= 0 to grid.rowcount - 1 do begin
  if issamefilename(filename[int1],wstr1) then begin
   with result[int2] do begin
    line:= self.line[int1];
    if bkpton[int1] then begin
     state:= bkpts_normal;
    end
    else begin
     state:= bkpts_disabled;
    end;
   end;
   inc(int2);
  end;
 end;
 setlength(result,int2);
end;

function tbreakpointsfo.breakpointerror(const error: gdbresultty): boolean;
var
 str1: string;
begin
 result:= error <> gdb_ok;
 if result then begin
  if error = gdb_message then begin
   str1:= gdb.errormessage;
  end
  else begin
   str1:= 'Breakpoint error.';
  end;
  showmessage(str1,'BREAKPOINT ERROR');
 end;
end;

procedure tbreakpointsfo.insertbkpt(index: integer;
                 withcondition,witherrormessage: boolean);
var
 info: breakpointinfoty;
 str1: string;
begin
 fillchar(info,sizeof(info),0);
 listtoinfo(index,info);
 str1:= info.condition;
 if not withcondition then begin
  info.condition:= '';
 end;
 if gdb.execloaded then begin
  if witherrormessage then begin
   breakpointerror(gdb.breakinsert(info));
  end
  else begin
   gdb.breakinsert(info);
  end;
 end;
 info.condition:= str1;
 infotolist(index,info,true);
end;

function tbreakpointsfo.addbreakpoint(var info: breakpointinfoty): boolean;
var
 int1: integer;
 info1: breakpointinfoty;
begin
 info1:= info;
 info1.bkpton:= info1.bkpton and bkptson.value;
 if gdb.execloaded then begin
  result:= gdb.breakinsert(info1) = gdb_ok;
 end
 else begin
  result:= true;
 end;
 if result then begin
  if (grid.rowcount = 0) or not grid.datacols.rowempty(grid.rowcount - 1) then begin
   int1:= grid.appendrow;
  end
  else begin
   int1:= grid.rowcount - 1;
  end;
  info1.bkpton:= info.bkpton;
  infotolist(int1,info1,false);
  changed;
 end;
end;

procedure tbreakpointsfo.updatebreakpoints;
var
 int1: integer;
begin
 if gdb.active then begin
  gdb.breakdelete(0);
  flags.fillcol(0);
//  gdb.breakinsert('main');
  for int1:= 0 to grid.rowhigh do begin
   insertbkpt(int1,false,false);
  end;
  fbreakpointsvalid:= true;
 end
 else begin
  fbreakpointsvalid:= false;
 end;
end;

function tbreakpointsfo.findbreakpointrow(const anum: integer): integer;
var
 int1: integer;
begin
 result:= -1;
 for int1:= 0 to grid.rowhigh do begin
  if bkptno[int1] = anum then begin
   result:= int1;
   break;
  end;
 end;
end;

function tbreakpointsfo.checkbreakpointcontinue(const stopinfo: stopinfoty): boolean;
                          //set condition
var
 int1: integer;
 str1,str2: string;
 ptrint1: ptrint;
 inf1: breakpointinfoty;
begin
 result:= false;
 if (stopinfo.reason = sr_breakpoint_hit) then begin
  int1:= findbreakpointrow(stopinfo.bkptno);
  if int1 >= 0 then begin
   if (condition[int1] <> '') and (flags[int1] = 0) then begin
    flags[int1]:= 1;
    str1:= condition[int1];
    if breakpointerror(gdb.breakcondition(stopinfo.bkptno,str1)) then begin
     conderr[int1]:= 0;
    end
    else begin
     conderr[int1]:= -1;
     gdb.evaluateexpression(str1,str2);
     if not (str2 = 'true') or trystrtoptrint(str2,ptrint1) and (ptrint1 <> 0) then begin
      flags[int1]:= 2; //count has to be decremented
      result:= true;
     end;
    end;
    listtoinfo(int1,inf1);
    infotolist(int1,inf1,true);
   end;
  end;
 end;
end;

function tbreakpointsfo.updatebreakpointon(var info: breakpointinfoty): boolean;
var
 int1: integer;
 wstr1: filenamety;
begin
 result:= true;
 wstr1:= msefileutils.filename(info.path);
 for int1:= grid.rowcount - 1 downto 0 do begin
  if (line[int1] = info.line) and (filename[int1] = wstr1) then begin
   bkpton[int1]:= info.bkpton;
   if gdb.execloaded then begin
    result:= gdb.breakenable(bkptno[int1],info.bkpton and bkptson.value) = gdb_ok;
   end;
   if conderr[int1] >= 0 then begin
    info.conditionmessage:= ' ';
   end
   else begin
    info.conditionmessage:= '';
   end;
   sourcefo.updatebreakpointicon(path[int1],infotolineinfo(info));
   if not result then begin
    break;
   end;
  end;
 end;
 changed;
end;

procedure tbreakpointsfo.ononsetvalue(const sender: TObject; var avalue: Boolean;
                                        var accept: Boolean);
begin
 if gdb.execloaded then begin
  gdb.breakenable(bkptno.value,avalue and bkptson.value)
 end;
end;

procedure tbreakpointsfo.ignoreonsetvalue(const sender: TObject; var avalue: Integer; var accept: Boolean);
begin
 if gdb.execloaded then begin
  gdb.breakafter(bkptno.value,avalue)
 end;
end;

procedure tbreakpointsfo.conditiononsetvalue(const sender: TObject;
                       var avalue: mseString; var accept: Boolean);
begin
 if gdb.execloaded then begin
  if breakpointerror(gdb.breakcondition(bkptno.value,avalue)) then begin
   conderr.value:= 0;
  end
  else begin
   conderr.value:= -1;
  end;
 end;
end;

procedure tbreakpointsfo.ondataentered(const sender: tobject);
var
 int1: integer;
 info: breakpointinfoty;
begin
 int1:= grid.row;
 fillchar(info,sizeof(info),0);
 listtoinfo(int1,info);
 infotolist(int1,info,true);
 changed;
end;

procedure tbreakpointsfo.ondataenterednewbkpt(const sender: tobject);
begin
 insertbkpt(grid.row,true,true);
 changed;
end;

procedure tbreakpointsfo.removeactbreakpoint;
var
 int1,int2: integer;
begin
 int1:= grid.row;
 int2:= 1;
 gridonrowsdeleting(nil,int1,int2);
end;

procedure tbreakpointsfo.lineonsetvalue(const sender: TObject; var avalue: Integer; var accept: Boolean);
begin
 removeactbreakpoint;
end;

procedure tbreakpointsfo.filenameonsetvalue(const sender: tobject;
  var avalue: msestring; var accept: boolean);
begin
 removeactbreakpoint;
 path.value:= filepath(avalue);
end;

procedure tbreakpointsfo.sourcelinesdeleted(const filepath: msestring;
  const aindex, acount: integer);
var
 int1: integer;
begin
 for int1:= grid.rowcount - 1 downto 0 do begin
  if (line[int1] >= aindex) and (path[int1] = filepath) then begin
   if line[int1] < aindex + acount then begin
    grid.deleterow(int1);
   end
   else begin
    line[int1]:= line[int1] - acount;
   end;
  end;
 end;
 changed;
end;

procedure tbreakpointsfo.sourcelinesinserted(const filepath: msestring;
  const aindex, acount: integer);
var
 int1: integer;
begin
 for int1:= 0 to grid.rowcount - 1 do begin
  if (line[int1] >= aindex) and (path[int1] = filepath) then begin
   line[int1]:= line[int1] + acount;
  end;
 end;
 changed;
end;

procedure tbreakpointsfo.changed;
begin
 fbreakpointsvalid:= false;
 with projectoptions do begin
  modified:= true;
  breakpointons:= bkpton.gridvalues;
  breakpointpaths:= path.gridvalues;
  breakpointlines:= line.gridvalues;
  breakpointignore:= ignore.gridvalues;
  breakpointconditions:= condition.gridvalues;
 end;
end;

procedure tbreakpointsfo.refresh;
var
 breakpoints: breakpointinfoarty;
 int1,int2: integer;
 po1: pintegeraty;
begin
 if gdb.active and (visible or watchpointsfo.visible) then begin
  gdb.breaklist(breakpoints,false);
  if visible then begin
   po1:= bkptno.griddata.datapo;
   for int1:= 0 to high(breakpoints) do begin
    with breakpoints[int1] do begin
     for int2:= 0 to grid.rowhigh do begin
      if po1^[int2] = bkptno then begin
       count[int2]:= passcount;
      end;
     end;
    end;
   end;
  end;
  if watchpointsfo.visible then begin
   watchpointsfo.refresh(breakpoints);
  end;
 end;
end;

procedure tbreakpointsfo.showbreakpoint(const filepath: filenamety;
                          const aline: integer; focus: boolean);
var
 int1: integer;
begin
 for int1:= 0 to grid.rowhigh do begin
  if (line[int1] = aline) and issamefilename(filepath,path[int1]) then begin
   grid.row:= int1;
   show;
   if focus then begin
    grid.setfocus;
    bringtofront;
   end;
  end;
 end;
end;

procedure tbreakpointsfo.deleteallexecute(const sender: TObject);
begin
 if askok('Do you wish to delete all breakpoints?','Confirmation') then begin
  grid.deleterow(0,grid.rowcount);
 end;
end;

procedure tbreakpointsfo.clear;
begin
 grid.clear;
end;

end.

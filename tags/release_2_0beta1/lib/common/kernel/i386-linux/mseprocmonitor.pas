{ MSEgui Copyright (c) 2008 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit mseprocmonitor;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msesys,mseevent;
 
 {$include ../mseprocmonitor.inc}
implementation
uses
 mseapplication,msedatalist,mselibc;
type
 procinfoty = record
  prochandle: prochandlety;
  dest: ievent;
  data: pointer;
 end;
 procinfoarty = array of procinfoty;
var
 infos: procinfoarty;
  
function pro_listentoprocess(const aprochandle: prochandlety;
                             const adest: ievent; const adata: pointer): boolean;
begin
 application.lock;
 setlength(infos,high(infos)+2);
 with infos[high(infos)] do begin
  prochandle:= aprochandle;
  dest:= adest;
  data:= adata;
 end;
 application.unlock;
 result:= true;
end;

procedure pro_unlistentoprocess(const aprochandle: prochandlety;
                                     const adest: ievent);
var
 int1: integer;
begin
 application.lock;
 for int1:= high(infos) downto 0 do begin
  with infos[int1] do begin
   if (prochandle = aprochandle) and (dest = adest) then begin
    deleteitem(infos,typeinfo(procinfoarty),int1);
   end;
  end;
 end;
 application.unlock;
end;

procedure checkchildproc;
var
 int1,int2: integer;
 execresult: integer;
begin
 application.lock;
 int1:= high(infos);
 while int1 >= 0 do begin
  if waitpid(infos[int1].prochandle,@execresult,wnohang) > 0 then begin
   for int2:= int1 downto 0 do begin
    with infos[int2] do begin
     if prochandle = infos[int1].prochandle then begin     
      application.postevent(tchildprocevent.create(dest,prochandle,execresult,
                                                     data));
      deleteitem(infos,typeinfo(procinfoarty),int2);
      if int2 <> int1 then begin
       dec(int1);
      end;
     end;
    end;
   end;
  end;
  dec(int1);
 end;
 application.unlock;
end;

initialization
 onhandlesigchld:= @checkchildproc;
finalization
 onhandlesigchld:= nil;
end.

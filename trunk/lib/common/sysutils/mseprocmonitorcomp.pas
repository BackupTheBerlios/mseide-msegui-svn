{ MSEgui Copyright (c) 2008 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit mseprocmonitorcomp;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseclasses,msesys,mseevent;
 
type
 proclisteninfoty = record
  prochandle: prochandlety;
  data: pointer;
 end;
 proclisteninfoarty = array of proclisteninfoty;
 
 childdiedeventty = procedure(const sender: tobject;
                     const prochandle: prochandlety; const execresult: integer;
                     const data: pointer) of object;
                               
 tprocessmonitor = class(tmsecomponent)
  private
   fonchilddied: childdiedeventty;
   finfos: proclisteninfoarty;
  protected
   procedure receiveevent(const event: tobjectevent); override;
   procedure internalunlistentoprocess(const aprochandle: prochandlety;
                                       const internal: boolean);
  public
   destructor destroy; override;
   procedure listentoprocess(const aprochandle: prochandlety;
                                 const adata: pointer = nil);
   procedure unlistentoprocess(const aprochandle: prochandlety);
  published
   property onchilddied: childdiedeventty read fonchilddied write fonchilddied;
 end;
 
implementation
uses
 mseprocmonitor,msedatalist;
 
{ tprocessmonitor }

destructor tprocessmonitor.destroy;
var
 int1: integer;
begin
 for int1:= high(finfos) downto 0 do begin
  pro_unlistentoprocess(finfos[int1].prochandle,ievent(self));
 end;
 inherited;
end;

procedure tprocessmonitor.listentoprocess(const aprochandle: prochandlety;
               const adata: pointer);
begin
 setlength(finfos,high(finfos)+2);
 with finfos[high(finfos)] do begin
  prochandle:= aprochandle;
  data:= adata;
 end;
 pro_listentoprocess(aprochandle,ievent(self),adata);
end;

procedure tprocessmonitor.internalunlistentoprocess(
      const aprochandle: prochandlety; const internal: boolean);
var
 int1: integer;
begin
 for int1:= high(finfos) downto 0 do begin
  with finfos[int1] do begin
   if prochandle = aprochandle then begin 
    if not internal then begin
     pro_unlistentoprocess(aprochandle,ievent(self));
    end;
    deleteitem(finfos,typeinfo(proclisteninfoarty),int1);
   end;
  end;
 end;
end;

procedure tprocessmonitor.receiveevent(const event: tobjectevent);
begin
 if (event.kind = ek_childproc) then begin 
  if canevent(tmethod(fonchilddied)) then begin
   with tchildprocevent(event) do begin
    fonchilddied(self,prochandle,execresult,data);
    internalunlistentoprocess(prochandle,true);
   end;
  end
  else begin
   inherited;
  end;
 end;
end;

procedure tprocessmonitor.unlistentoprocess(const aprochandle: prochandlety);
begin
 internalunlistentoprocess(aprochandle, false);
end;

end.

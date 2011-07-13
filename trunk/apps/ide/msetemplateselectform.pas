{ MSEide Copyright (c) 2010 by Martin Schreiber

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
unit msetemplateselectform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msesimplewidgets,
 msewidgets,msedataedits,mseedit,msegrids,msestrings,msetypes,msewidgetgrid,
 msedispwidgets,msecodetemplates,msestatfile,msegraphedits;
type
 tmsetemplateselectfo = class(tmseform)
   tbutton1: tbutton;
   tbutton2: tbutton;
   grid: twidgetgrid;
   templatename: tstringedit;
   comment: tstringedit;
   par1: tstringedit;
   par2: tstringedit;
   par3: tstringedit;
   par4: tstringedit;
   filename: tstringdisp;
   tstatfile1: tstatfile;
   tstockglyphdatabutton1: tstockglyphdatabutton;
   procedure celle(const sender: TObject; var info: celleventinfoty);
   procedure edtemplateactonexecute(const sender: TObject);
  private
   ftemplates: tcodetemplates;
  public
   finfos: templateinfoarty;
   constructor create(const atemplates: tcodetemplates); reintroduce;
 end;

implementation
uses
 msetemplateselectform_mfm,templateeditor,projectoptionsform;
 
type
 tcodetemplates1 = class(tcodetemplates);
 
constructor tmsetemplateselectfo.create(const atemplates: tcodetemplates);
begin
 ftemplates:= atemplates;
 inherited create(nil);
end;

procedure tmsetemplateselectfo.edtemplateactonexecute(const sender: TObject);
var
 mstr1: msestring;
begin
 if ttemplateeditorfo.create(grid.row).show(mstr1) = mr_ok then begin
  ftemplates.scan(projectoptions.o.texp.codetemplatedirs);
  tcodetemplates1(ftemplates).reload(self);
  templatename.editor.filtertext:= mstr1;
 end;
end;

procedure tmsetemplateselectfo.celle(const sender: TObject;
               var info: celleventinfoty);
begin
 if isrowenter(info) then begin
  if info.newcell.row > high(finfos) then begin
   filename.value:= '';
  end
  else begin
   filename.value:= finfos[info.newcell.row].path;
  end;
 end;
end;

end.

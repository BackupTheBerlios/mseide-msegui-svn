{ MSEide Copyright (c) 2007 by Martin Schreiber
   
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
unit regunitgroups;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
interface
implementation
uses
 msedesignintf;
 
procedure reggroups;
begin
 registerunitgroup(['mseapplication'],['sysutils']);
 registerunitgroup(['msestatfile'],['msestat']);
 registerunitgroup(['msemenuwidgets'],['msemenus','mseevent','msegui']);
 registerunitgroup(['mseactions'],['mseact']);
 registerunitgroup(['msefiledialog'],['msemenus','mseevent','msegui','mselistbrowser','msegrids','mseedit','msestrings','msedataedits']);
 registerunitgroup(['mseforms'],['msemenus','mseevent','msegui','mseglob','msegraphics','msestat']);
 registerunitgroup(['msesimplewidgets'],['msemenus','mseevent','msegui','msegraphics','msegraphutils','msewidgets']);
 registerunitgroup(['msedispwidgets'],['msemenus','mseevent','msegui','msestrings','msetypes']);
 registerunitgroup(['msedataedits'],['msemenus','mseevent','msegui','mseedit','msestrings','msetypes']);
 registerunitgroup(['msetoolbar'],['msemenus','mseevent','msegui','msewidgets']);
 registerunitgroup(['msegrids'],['msemenus','mseevent','msegui']);
 registerunitgroup(['msetabs'],['msemenus','mseevent','msegui','msewidgets']);
 registerunitgroup(['msedock'],['msemenus','mseevent','msegui']);
 registerunitgroup(['msesysenv'],['msestrings']);
 registerunitgroup(['msepostscriptprinter'],['mseprinter']);
 registerunitgroup(['msesplitter'],['msemenus','mseevent','msegui']);
 registerunitgroup(['mseedit'],['msemenus','mseevent','msegui','msestrings']);
 registerunitgroup(['msewidgetgrid'],['msemenus','mseevent','msegui','msegrids']);
 registerunitgroup(['mselistbrowser'],['msemenus','mseevent','msegui','msegrids','mseedit','msestrings','msedataedits','msedatanodes']);
 registerunitgroup(['msedialog'],['msemenus','mseevent','msegui','mseedit','msestrings','msedataedits','mseglob']);
 registerunitgroup(['msegraphedits'],['msemenus','mseevent','msegui','msegraphics','msetypes']);
 registerunitgroup(['msesockets'],['msesys']);
 registerunitgroup(['msetextedit'],['msemenus','mseevent','msegui','mseinplaceedit','msegrids']);
 registerunitgroup(['msesyntaxedit'],['msemenus','mseevent','msegui','msetextedit','mseinplaceedit','msegrids']);
 registerunitgroup(['msecolordialog'],['msemenus','mseevent','msegui','mseedit','msestrings','msedataedits','msegraphutils']);
 registerunitgroup(['msereport'],['msemenus','mseevent','msegui','msegraphics','msestrings']);
 registerunitgroup(['mseprinter'],['msemenus','mseevent','msegui','mseedit','msestrings','msedataedits']);
 registerunitgroup(['mseimage'],['msemenus','mseevent','msegui']);
 registerunitgroup(['msedial'],['msemenus','mseevent','msegui']);
 registerunitgroup(['msewindowwidget'],['msemenus','mseevent','msegui','msegraphics','msegraphutils']);
 registerunitgroup(['msechart'],['msemenus','mseevent','msegui','msegraphutils','msegraphics']);
 registerunitgroup(['mseopenglwidget'],['msemenus','mseevent','msegui','msegraphics','msegraphutils','msewindowwidget']);
 registerunitgroup(['msedb'],['db']);
 registerunitgroup(['msegdiprint'],['mseprinter']);
 registerunitgroup(['msedbgraphics'],['db','msemenus','mseevent','msegui']);
 registerunitgroup(['msedataimage'],['msemenus','mseevent','msegui']);
 registerunitgroup(['msedbdispwidgets'],['msemenus','mseevent','msegui','msestrings','msetypes']);
 registerunitgroup(['msedbedit'],['msemenus','mseevent','msegui','mseedit','msestrings','msedataedits','msedialog','mseglob','msetypes','msegrids']);
 registerunitgroup(['mseterminal'],['msemenus','mseevent','msegui','msestrings']);
 registerunitgroup(['msesqldb'],['msqldb','sysutils','msebufdataset','db']);
 registerunitgroup(['msqldb'],['sysutils']);
 registerunitgroup(['msedbf'],['dbf','dbf_idxfile','db']);
 registerunitgroup(['msesdfdata'],['db']);
 registerunitgroup(['msememds'],['db']);
 registerunitgroup(['msedbdialog'],['msemenus','mseevent','msegui','mseedit','msestrings','msedataedits']);
 registerunitgroup(['msesqlite3ds'],['db']);
 registerunitgroup(['ZSqlMetadata'],['db']);
 registerunitgroup(['ZSqlProcessor'],['sysutils']);
 registerunitgroup(['msezeos'],['db']);
 registerunitgroup(['msepascalscript'],['uPSComponent','uPSCompiler','uPSRuntime','uPSPreProcessor']);
 registerunitgroup(['msecommutils'],['msemenus','mseevent','msegui','mseedit','msestrings','msedataedits','msecommport']);
 registerunitgroup(['rgbsimulator'],['msemenus','mseevent','msegui']);
end;

initialization
 reggroups;
end.

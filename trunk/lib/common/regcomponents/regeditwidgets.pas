{ MSEgui Copyright (c) 1999-2006 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit regeditwidgets;

{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 {$ifdef FPC}classes{$else}Classes{$endif},mseedit,msedataedits,msegraphedits,
 msedataimage,mselistbrowser,
 msewidgetgrid,msetextedit,msedesignintf,regeditwidgets_bmp,msepropertyeditors,
 msedropdownlist,mseterminal,msedrawtext,msedatanodes,msedialog,msestrings,
 regwidgets,msearrayprops,typinfo,msestockobjects,msefoldedit;

type
 tdropdowncolpropertyeditor = class(tarraypropertyeditor)
  protected
   function geteditorclass: propertyeditorclassty; override;
 end;

 titemlistpropertyeditor = class(tdatalistpropertyeditor)
  protected
   function getdefaultstate: propertystatesty; override;
 end;
                        
 twidgetcolelementeditor = class(tdatacoleditor)
  public
   function getvalue: msestring; override;
 end;
 
 twidgetcolspropertyeditor = class(tdatacolseditor)
  protected
   function geteditorclass: propertyeditorclassty; override;
 end;

 tstockglypheditor = class(tenumpropertyeditor)
  protected
   function gettypeinfo: ptypeinfo; override;
 end;
 
 tstockglypharraypropertyeditor = class(tintegerarraypropertyeditor)
  protected
   function geteditorclass: propertyeditorclassty; override;
 end;

  
procedure Register;
begin
 registercomponents('Edit',[twidgetgrid,tedit,tslider,tprogressbar,
   tbooleanedit,tbooleaneditradio,
   tdatabutton,tstockglyphdatabutton,tdataicon,tdataimage,
   tpointeredit,
   tstringedit,tdropdownlistedit,thistoryedit,tdialogstringedit,
   thexstringedit,tmemoedit,tfoldedit,
   tintegeredit,trealedit,trealspinedit,tdatetimeedit,tcalendardatetimeedit,tkeystringedit,
   tenumedit,tenumtypeedit,tselector,
   {tstringlistedit,}
   titemedit,tdropdownitemedit,tmbdropdownitemedit,ttreeitemedit,
   trecordfieldedit,
   ttextedit,tterminal]);
 registercomponenttabhints(['Edit'],
 ['Edit Widgets, twidgetgrid and Widgets'+c_linefeed+
  'which can be placed into twidgetgrid']);
 registerpropertyeditor(tdropdowncols.classinfo,nil,'',tdropdowncolpropertyeditor);
 registerpropertyeditor(ttabulators.classinfo,tcustomtextedit,'tabulators',
            toptionalpersistentarraypropertyeditor);
 registerpropertyeditor(tcustomitemlist.classinfo,nil,'',titemlistpropertyeditor);
 registerpropertyeditor(typeinfo(twidgetcols),nil,'',twidgetcolspropertyeditor);
 registerpropertyeditor(typeinfo(tintegerarrayprop),tstockglyphdatabutton,'',
              tstockglypharraypropertyeditor);
end;

{ tdropdowncolpropertyeditor }

function tdropdowncolpropertyeditor.geteditorclass: propertyeditorclassty;
begin
 result:= tmsestringdatalistpropertyeditor;
end;

{ titemlistpropertyeditor }

function titemlistpropertyeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate - [ps_dialog];
end;

{ twidgetcolelementeditor }

function twidgetcolelementeditor.getvalue: msestring;
var
 col1: twidgetcol;
begin
 col1:= twidgetcol(getordvalue);
 result:= inherited getvalue;
 if col1.editwidget <> nil then begin
  result:= result + '<'+col1.editwidget.name+'>';
 end
 else begin
  result:= result + '<>';
 end;
end;

{ twidgetcolspropertyeditor }

function twidgetcolspropertyeditor.geteditorclass: propertyeditorclassty;
begin
 result:= twidgetcolelementeditor;
end;

{ tstockglypharraypropertyeditor }

function tstockglypharraypropertyeditor.geteditorclass: propertyeditorclassty;
begin
 result:= tstockglypheditor;
end;

{ tstockglypheditor }

function tstockglypheditor.gettypeinfo: ptypeinfo;
begin
 result:= typeinfo(stockglyphty);
end;

initialization
 register;
end.

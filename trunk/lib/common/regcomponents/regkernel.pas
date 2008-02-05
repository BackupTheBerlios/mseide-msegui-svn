{ MSEgui Copyright (c) 1999-2008 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit regkernel;

{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface

implementation

uses
 classes,mseguithread,msebitmap,msetimer,msestatfile,mseact,mseactions,
 mseshapes,
 msedesignintf,msepropertyeditors,msemenus,msegui,msepipestream,sysutils,
 msegraphutils,regkernel_bmp,msegraphics,msestrings,msepostscriptprinter,
 mseprinter,msetypes,msedatalist,msedatamodules,mseclasses,formdesigner,
 mseapplication,mseglob,mseguiglob,mseskin,msedesigner,typinfo;

type
 twidget1 = class(twidget);
 tactivator1 = class(tactivator);

 tactionpropertyeditor = class(tcomponentpropertyeditor)
  protected
   function getdefaultstate: propertystatesty; override;
 end;
 
 tshortcutactionpropertyeditor = class(tclasselementeditor)
  protected
   function getvalue: msestring; override;
 end;
 
 tshortcutactionspropertyeditor = class(tpersistentarraypropertyeditor)
  protected
   function geteditorclass: propertyeditorclassty; override;
 end;
  
 tshapestatespropertyeditor = class(tsetpropertyeditor)
  protected
   function getdefaultstate: propertystatesty; override;
 end;

 tbounds_xeditor = class(tordinalpropertyeditor)
  public
   function getvalue: msestring; override;
   procedure setvalue(const value: msestring); override;
 end;

 tbounds_yeditor = class(tordinalpropertyeditor)
  public
   function getvalue: msestring; override;
   procedure setvalue(const value: msestring); override;
 end;

 tframepropertyeditor = class(toptionalclasspropertyeditor)
  public
   procedure edit; override;
 end;
 
 tactivatorclientspropertyeditor = class(tconstarraypropertyeditor)
  protected
   procedure itemmoved(const source,dest: integer); override;
  public
   function subproperties: propertyeditorarty; override;
 end;

 tsysshortcutelementeditor = class(tarrayelementeditor)
  public
   function name: msestring; override;
 end;
 
 tsysshortcutspropertyeditor = class(tconstarraypropertyeditor)
  protected
   function geteditorclass: propertyeditorclassty; override;
   function getelementeditorclass: elementeditorclassty; override;
  public
 end;
 
const   
 datamoduleintf: designmoduleintfty = 
  (createfunc: {$ifdef FPC}@{$endif}createmsedatamodule);

procedure Register;
begin
 registercomponents('NoGui',[tstatfile,tnoguiaction,tactivator,
                             ttimer,tthreadcomp,tpipereadercomp]);
 registercomponenttabhints(['NoGui'],['Components without GUI Dependence']);
 registercomponents('Gui',[tmainmenu,tpopupmenu,
                    tfacecomp,tframecomp,tskincontroller,
                    tbitmapcomp,timagelist,taction,tshortcutcontroller]);
 registercomponenttabhints(['Gui'],['Non visual Components with GUI Dependence']);
 registercomponents('Dialog',[tpagesizeselector,tpageorientationselector]);

// registerpropertyeditor(typeinfo(twidget),nil,'',tcomponentpropertyeditor);
 registerpropertyeditor(typeinfo(tcustomaction),nil,'',tactionpropertyeditor);
 registerpropertyeditor(typeinfo(tshortcutactions),nil,'',
                           tshortcutactionspropertyeditor);
 registerpropertyeditor(typeinfo(tsysshortcuts),nil,'',tsysshortcutspropertyeditor);
 registerpropertyeditor(typeinfo(string),tfont,'name',tfontnamepropertyeditor);
 registerpropertyeditor(typeinfo(actionstatesty),nil,'',tshapestatespropertyeditor);
 registerpropertyeditor(typeinfo(shortcutty),nil,'',tshortcutpropertyeditor);
 registerpropertyeditor(typeinfo(tcollection),nil,'',tcollectionpropertyeditor);
 registerpropertyeditor(typeinfo(tmenuitems),nil,'',tmenuarraypropertyeditor);
// registerpropertyeditor(typeinfo(tcustomframe),twidget,'frame',tframepropertyeditor);
// registerpropertyeditor(typeinfo(tcustomface),twidget,'face',
//                             toptionalclasspropertyeditor);
 registerpropertyeditor(typeinfo(tcustomframe),nil,'',tframepropertyeditor);
 registerpropertyeditor(typeinfo(tcustomface),nil,'',
                             toptionalclasspropertyeditor);
 registerpropertyeditor(typeinfo(toptionalfont),nil,'',
                             toptionalclasspropertyeditor);
 registerpropertyeditor(typeinfo(tparentfont),nil,'',
                             tparentfontpropertyeditor);
 registerpropertyeditor(typeinfo(integer),twidget,'bounds_x',tbounds_xeditor);
 registerpropertyeditor(typeinfo(integer),twidget,'bounds_y',tbounds_yeditor);
 registerpropertyeditor(typeinfo(tfacetemplate),tcustommenu,'facetemplate',
                           toptionalclasspropertyeditor);
 registerpropertyeditor(typeinfo(tfacetemplate),tmainmenu,'popupfacetemplate',
                           toptionalclasspropertyeditor);
 registerpropertyeditor(typeinfo(integer),tactivator,'clients',
                         tactivatorclientspropertyeditor);
 registerunitgroup(['msestatfile'],['msestat']);
 
 registerdesignmoduleclass(tmsedatamodule,datamoduleintf);
end;

{ tactionpropertyeditor }

function tactionpropertyeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate + [ps_volatile];
end;

{ tshapestatespropertyeditor }

function tshapestatespropertyeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate + [ps_volatile,ps_refresh];
end;

{ tbounds_xeditor }

function tbounds_xeditor.getvalue: msestring;
begin
 if fprops[0].instance = fmodule then begin
  result:= inttostr(twidget(fprops[0].instance).screenpos.x);
 end
 else begin
  result:= inherited getvalue;
 end;
end;

procedure tbounds_xeditor.setvalue(const value: msestring);
begin
 if fprops[0].instance = fmodule then begin
  fdesigner.setmodulex(fmodule,strtoint(value));
 end
 else begin
  inherited;
 end;
end;

{ tbounds_yeditor }

function tbounds_yeditor.getvalue: msestring;
begin
 if fprops[0].instance = fmodule then begin
  result:= inttostr(twidget(fprops[0].instance).screenpos.y);
 end
 else begin
  result:= inherited getvalue;
 end;
end;

procedure tbounds_yeditor.setvalue(const value: msestring);
begin
 if fprops[0].instance = fmodule then begin
  fdesigner.setmoduley(fmodule,strtoint(value));
 end
 else begin
  inherited;
 end;
end;

{ tframepropertyeditor }

procedure tframepropertyeditor.edit;
begin
 inherited;
 if fprops[0].instance is twidget then begin
  twidget1(fprops[0].instance).clientrectchanged;
 end;
end;

{ tactivatorclientspropertyeditor }

function tactivatorclientspropertyeditor.subproperties: propertyeditorarty;
var
 int1: integer;
 ar1: stringarty;
begin
 with tactivator1(fprops[0].instance) do begin
  updateorder;
  fclientnames:= nil;
  ar1:= getclientnames;
  setlength(result,length(fclients));
  for int1:= 0 to high(result) do begin
   result[int1]:= tconstelementeditor.create(ar1[int1],
         int1,self,geteditorclass,fdesigner,fobjectinspector,fprops,ftypeinfo);
  end;
 end;
end;

procedure tactivatorclientspropertyeditor.itemmoved(const source: integer;
                        const dest: integer);
begin
 moveitem(tactivator1(fprops[0].instance).fclients,source,dest);
 modified;
end;

{ tsysshortcutspropertyeditor }

function tsysshortcutspropertyeditor.geteditorclass: propertyeditorclassty;
begin
 result:= tshortcutpropertyeditor;
end;

function tsysshortcutspropertyeditor.getelementeditorclass: elementeditorclassty;
begin
 result:= tsysshortcutelementeditor;
end;

{ tshortcutactionpropertyeditor }

function tshortcutactionpropertyeditor.getvalue: msestring;
var
 item1: tshortcutaction;
begin
 item1:= tshortcutaction(getordvalue);
 if item1.action = nil then begin
  result:= '<--->';
 end
 else begin
  result:= '<';
  if item1.action.owner <> module then begin
   result:= result+module.name+'.';
  end;
  result:= result+designer.getcomponentdispname(item1.action)+'>';
 end;
 result:= result + '<' + item1.dispname + '>';
end;

{ tshortcutactionspropertyeditor }

function tshortcutactionspropertyeditor.geteditorclass: propertyeditorclassty;
begin
 result:= tshortcutactionpropertyeditor;
end;

{ tsysshortcutelementeditor }

function tsysshortcutelementeditor.name: msestring;
begin
 result:= getenumname(typeinfo(sysshortcutty),findex);
end;

initialization
 register;
end.

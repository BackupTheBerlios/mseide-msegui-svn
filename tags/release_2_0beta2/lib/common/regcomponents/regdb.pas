{ MSEgui Copyright (c) 1999-2006 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit regdb;

{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface
uses
 classes,typinfo,msesqldb,msedbedit,msepropertyeditors,msedb,mseclasses,msetypes,msestrings,
 mseglob,mseguiglob,msegui,msedatabase,msesqlresult,msedesignintf;
 
type
 tdbfieldnamepropertyeditor = class(tstringpropertyeditor)
  private
   fnocalc: boolean;
  protected
   fdbeditinfointf: idbeditinfo;
   function getdefaultstate: propertystatesty; override;
  public
   function getvalues: msestringarty; override;
 end;
 
 tdbfieldnamenocalcpropertyeditor = class(tdbfieldnamepropertyeditor)
  public
   constructor create(const adesigner: idesigner;
        const amodule: tmsecomponent; const acomponent: tcomponent;
            const aobjectinspector: iobjectinspector;
            const aprops: propinstancearty; atypeinfo: ptypeinfo); override;  
 end;
 
 tdbcolnamepropertyeditor = class(tstringpropertyeditor)
  protected
   fdbcolinfointf: idbcolinfo;
   function getdefaultstate: propertystatesty; override;
  public
   function getvalues: msestringarty; override;
 end;
 
 tdbcolnamearraypropertyeditor = class(tstringarraypropertyeditor)
  protected
   function geteditorclass: propertyeditorclassty; override;
 end;

 
 tdbparampropertyeditor = class(tclasspropertyeditor)
  public
   function getvalue: msestring; override;
 end;
  
 tdbparamnamepropertyeditor = class(tstringpropertyeditor)
  protected
   fdbparaminfointf: idbparaminfo;
   function getdefaultstate: propertystatesty; override;
  public
   function getvalues: msestringarty; override;
 end;
 
 tdbfieldnamearraypropertyeditor = class(tstringarraypropertyeditor)
  protected
   function geteditorclass: propertyeditorclassty; override;
 end;

 tsqlpropertyeditor = class(ttextstringspropertyeditor)
  private
   factivebefore: boolean;
   fintf: isqlpropertyeditor;
  protected
   function nocheck: boolean; virtual;
   function getsyntaxindex: integer; override;
   procedure doafterclosequery(var amodalresult: modalresultty); override;
   function gettestbutton: boolean; override;
   function getutf8: boolean; override;
   function getcaption: msestring; override;
  public
   procedure edit; override;
 end;

 tmsesqlpropertyeditor = class(ttextstringspropertyeditor)
  private
   factivebefore: boolean;
   fintf: isqlpropertyeditor;
  protected
   function ismsestring: boolean; override;
   function nocheck: boolean; virtual;
   function getsyntaxindex: integer; override;
   procedure doafterclosequery(var amodalresult: modalresultty); override;
   function gettestbutton: boolean; override;
   function getutf8: boolean; override;
   function getcaption: msestring; override;
  public
   procedure edit; override;
 end;
 
 tsqlnocheckpropertyeditor = class(tsqlpropertyeditor)
  protected
   function nocheck: boolean; override;
 end;

 tmsesqlnocheckpropertyeditor = class(tmsesqlpropertyeditor)
  protected
   function nocheck: boolean; override;
 end;
 
implementation
uses
 dbconst,db,mseibconnection,
 msepqconnection,mseodbcconn,msemysql40conn,msemysql41conn,msemysql50conn,{sqldb,}
 mselookupbuffer,msedbf,msesdfdata,msememds,
 msedatalist,msedbfieldeditor,sysutils,msetexteditor,
 msedbdispwidgets,msedbgraphics,regdb_bmp,msedbdialog,msegrids,
 regwidgets,msebufdataset,msedbevents,msesqlite3conn,msqldb
 {$ifdef mse_with_sqlite}
 ,msesqlite3ds
 {$endif}
 ;

type
 tpropertyeditor1 = class(tpropertyeditor);
 
 tnolistdropdowncolpropertyeditor = class(tarraypropertyeditor)
  protected
   function geteditorclass: propertyeditorclassty; override;
 end;

 tpersistentfieldelementeditor = class(tclasselementeditor)
  public
   function getvalue: msestring; override;
 end;
 
 tpersistentfieldspropertyeditor = class(tpersistentarraypropertyeditor)
  protected
   function getdefaultstate: propertystatesty; override;
   function geteditorclass: propertyeditorclassty; override;
  public
   procedure edit; override;
 end;

 tfieldfieldnamepropertyeditor = class(tstringpropertyeditor)
  protected
   function getdefaultstate: propertystatesty; override;
   function getvalues: msestringarty; override;
  public
   procedure setvalue(const value: msestring); override;
 end;

 tfielddatasetpropertyeditor = class(tcomponentpropertyeditor)
  protected
   procedure checkcomponent(const avalue: tcomponent); override;
 end;

 tonfilterpropertyeditor = class(tmethodpropertyeditor)
  public
   function getdefaultstate: propertystatesty; override;
   procedure setvalue(const value: msestring); override;
 end;

 tfielddefpropertyeditor = class(tclasspropertyeditor)
  public
   function getvalue: msestring; override;
 end;
 
 tfielddefspropertyeditor = class(tcollectionpropertyeditor)
  public
   procedure setvalue(const value: msestring); override;
 end;

 tdatasetactivepropertyeditor = class(tbooleanpropertyeditor)
  public
   function getdefaultstate: propertystatesty; override;
 end;
   
 tdbstringcoleditor = class(tdatacoleditor)
  public
   function getvalue: msestring; override;
 end;
 
 tdbstringcolseditor = class(tdatacolseditor)
  protected
   function geteditorclass: propertyeditorclassty; override;  
 end;

 tindexfieldnamepropertyeditor = class(tstringpropertyeditor)
  protected
   function getdefaultstate: propertystatesty; override;   
   function getvalues: msestringarty; override;
 end;
 
 tindexfieldpropertyeditor = class(tclasselementeditor)
  protected
   function getdefaultstate: propertystatesty; override;
  public
   function getvalue: msestring; override;
 end;

 tindexfieldspropertyeditor = class(tpersistentarraypropertyeditor)
  protected
   function geteditorclass: propertyeditorclassty; override;
 end;
 
 tlocalindexpropertyeditor = class(tclasselementeditor)
  protected
   function getdefaultstate: propertystatesty; override;
  public
   function getvalue: msestring; override;
 end;

 tlocalindexespropertyeditor = class(tpersistentarraypropertyeditor)
  protected
   function geteditorclass: propertyeditorclassty; override;
 end;
    
procedure Register;
begin
 registercomponents('DB',[     
      tdbnavigator,tdbstringgrid,
      tlookupbuffer,tdblookupbuffer,tdbmemolookupbuffer,
      tmsedatasource,
      tmsedbf,tmsefixedformatdataset,tmsesdfdataset,tmsememdataset,
      tmsesqlquery,tmsesqltransaction,
      tsqlstatement,tmsesqlscript,tsqlresult,tsqllookupbuffer,
      tmseibconnection,tmsepqconnection,tsqlite3connection,tmseodbcconnection,
      tmsemysql40connection,tmsemysql41connection,tmsemysql50connection
      {$ifdef mse_with_sqlite}
       ,tmsesqlite3dataset
      {$endif}
      ]);
 registercomponenttabhints(['DB'],['Database Components']);
 registercomponents('DBe',[tdbwidgetgrid,
      tenumeditdb,tenum64editdb,tkeystringeditdb,tenumeditlb,tenum64editlb,
      tkeystringeditlb,
      tdbmemoedit,tdbstringedit,tdbdropdownlistedit,tdbdialogstringedit,
      tdbbooleantextedit,
      tdbkeystringedit,tdbkeystringeditdb,tdbkeystringeditlb,
      tdbintegeredit,tdbenumedit,tdbenumeditdb,tdbenum64editdb,
      tdbenumeditlb,tdbenum64editlb,
      tdbdataicon,tdbdataimage,tdbdatabutton,tdbrealedit,tdbrealspinedit,
      tdbprogressbar,tdbslider,
      tdbdatetimeedit,
      tdbcalendardatetimeedit,tdbfilenameedit,tdbcoloredit,
      tdbbooleanedit,tdbbooleaneditradio
      ]);
 registercomponenttabhints(['DBe'],['Data edit Components']);
 registercomponents('DBf',[
      tfieldparamlink,tfieldlink,ttimestampfieldlink,tfieldfieldlink,
      tsequencelink,tdbevent,
      tmsestringfield,tmselongintfield,tmselargeintfield,tmsesmallintfield,
      tmsewordfield,tmseautoincfield,tmsefloatfield,tmsecurrencyfield,
      tmsebooleanfield,tmsedatetimefield,tmsedatefield,tmsetimefield,
      tmsebinaryfield,tmsebytesfield,tmsevarbytesfield,
      tmsebcdfield,tmseblobfield,tmsememofield,tmsegraphicfield,
      tdblabel,tdbstringdisp,tdbintegerdisp,tdbbooleandisp,
      tdbrealdisp,tdbdatetimedisp,
      tdbstringdisplb,tdbintegerdisplb,tdbrealdisplb,tdbdatetimedisplb
      ]);
 registercomponenttabhints(['DBf'],['Datafield and Data display Components']);
 registerpropertyeditor(typeinfo(tnolistdropdowncol),nil,'',tclasspropertyeditor);
 registerpropertyeditor(typeinfo(tnolistdropdowncols),nil,'',
        tnolistdropdowncolpropertyeditor);
 registerpropertyeditor(typeinfo(string),nil,'datafield',
        tdbfieldnamepropertyeditor);
 registerpropertyeditor(typeinfo(string),tfieldfieldlink,'datafield',
        tdbfieldnamenocalcpropertyeditor);
 registerpropertyeditor(typeinfo(string),tfieldlink,'destdatafield',
        tdbfieldnamepropertyeditor);
 registerpropertyeditor(typeinfo(string),tfieldparamlink,'datafield',
        tdbfieldnamenocalcpropertyeditor);
 registerpropertyeditor(typeinfo(string),nil,'keyfield',
        tdbfieldnamepropertyeditor);
 registerpropertyeditor(typeinfo(string),tgriddatalink,'',
        tdbfieldnamepropertyeditor);
 registerpropertyeditor(typeinfo(tdbfieldnamearrayprop),nil,'',
        tdbfieldnamearraypropertyeditor);
 registerpropertyeditor(typeinfo(tdbcolnamearrayprop),nil,'',
        tdbcolnamearraypropertyeditor);
 registerpropertyeditor(typeinfo(tpersistentfields),nil,'',
        tpersistentfieldspropertyeditor);
 registerpropertyeditor(typeinfo(string),tfield,'FieldName',
        tfieldfieldnamepropertyeditor);
 registerpropertyeditor(typeinfo(tcomponent),tfield,'Dataset',
        tfielddatasetpropertyeditor);
 registerpropertyeditor(typeinfo(string),tfieldparamlink,'paramname',
        tdbparamnamepropertyeditor);
 registerpropertyeditor(typeinfo(tstrings),nil,'SQL',
        tsqlpropertyeditor);
 registerpropertyeditor(typeinfo(tsqlstringlist),nil,'',
        tmsesqlpropertyeditor);
 registerpropertyeditor(typeinfo(tsqlstringlist),nil,'SQLupdate',
        tmsesqlnocheckpropertyeditor);
 registerpropertyeditor(typeinfo(tsqlstringlist),nil,'SQLinsert',
        tmsesqlnocheckpropertyeditor);
 registerpropertyeditor(typeinfo(tsqlstringlist),nil,'SQLdelete',
        tmsesqlnocheckpropertyeditor);
{        
 registerpropertyeditor(typeinfo(tmsestringdatalist),nil,'SQL',
        tmsesqlpropertyeditor);
 registerpropertyeditor(typeinfo(tstringlist),tsqlquery,'SQLupdate',
        tsqlnocheckpropertyeditor);
 registerpropertyeditor(typeinfo(tstringlist),tsqlquery,'SQLinsert',
        tsqlnocheckpropertyeditor);
 registerpropertyeditor(typeinfo(tstringlist),tsqlquery,'SQLdelete',
        tsqlnocheckpropertyeditor);
}
 registerpropertyeditor(typeinfo(tdataset),nil,'',
                             tcomponentpropertyeditor);
 registerpropertyeditor(typeinfo(tdataset),tfield,'dataset',
                             tlocalcomponentpropertyeditor);
 registerpropertyeditor(typeinfo(lbfiltereventty),tlbdropdownlistcontroller,
                           'onfilter',tonfilterpropertyeditor);
 registerpropertyeditor(typeinfo(tfielddefs),tdataset,'',
                              tfielddefspropertyeditor);
 registerpropertyeditor(typeinfo(boolean),tdataset,'Active',
                                         tdatasetactivepropertyeditor);                              
 registerpropertyeditor(typeinfo(boolean),tsqlresult,'active',
                                         tdatasetactivepropertyeditor);                              
 registerpropertyeditor(typeinfo(tfielddef),nil,'',tfielddefpropertyeditor);
 registerpropertyeditor(typeinfo(tparam),nil,'',tdbparampropertyeditor);
 registerpropertyeditor(typeinfo(tdbstringcols),nil,'',tdbstringcolseditor);
 registerpropertyeditor(typeinfo(string),tindexfield,'fieldname',
                 tindexfieldnamepropertyeditor);
 registerpropertyeditor(typeinfo(tindexfields),nil,'',tindexfieldspropertyeditor);
 registerpropertyeditor(typeinfo(tlocalindexes),nil,'',tlocalindexespropertyeditor);
end;


{ tnolistdropdowncolpropertyeditor }

function tnolistdropdowncolpropertyeditor.geteditorclass: propertyeditorclassty;
begin
 result:= tclasspropertyeditor;
end;

{ tdbparamnamepropertyeditor }

function tdbparamnamepropertyeditor.getdefaultstate: propertystatesty;
var
 obj1: tobject;
begin
 result:= inherited getdefaultstate;
 if fremote <> nil then begin
  obj1:= tobject(tpropertyeditor1(fremote.getparenteditor).getordvalue);
  if obj1 <> nil then begin
   getcorbainterface(obj1,typeinfo(idbparaminfo),fdbparaminfointf);
  end;
 end
 else begin
  if (high(fprops) = 0) then begin
   with fprops[0] do begin
    getcorbainterface(instance,typeinfo(idbparaminfo),fdbparaminfointf);
   end;
  end;
 end;
 if (fdbparaminfointf <> nil) and (fdbparaminfointf.getdestdataset <> nil) then begin
  result:= result + [ps_valuelist,ps_sortlist];
 end;
end;

function tdbparamnamepropertyeditor.getvalues: msestringarty;
var
 int1: integer;
begin
 with fdbparaminfointf.getdestdataset.params do begin
  for int1:= 0 to count - 1 do begin
   additem(result,msestring(items[int1].name));
  end;
 end;
end;

{ tdbfieldnamepropertyeditor }

function tdbfieldnamepropertyeditor.getdefaultstate: propertystatesty;
var
 datasource1: tdatasource;
 obj1: tobject;
 ar1: stringarty;
 ar2: fieldtypesarty;
 int1,int2: integer;
begin
 result:= inherited getdefaultstate;
 if fremote <> nil then begin
  obj1:= tobject(tpropertyeditor1(fremote.getparenteditor).getordvalue);
  if obj1 <> nil then begin
   getcorbainterface(obj1,typeinfo(idbeditinfo),fdbeditinfointf);
  end;
 end
 else begin
  if (high(fprops) = 0) then begin
   with fprops[0] do begin
    getcorbainterface(instance,typeinfo(idbeditinfo),fdbeditinfointf);
   end;
  end;
 end;
 if fdbeditinfointf <> nil then begin
  fdbeditinfointf.getfieldtypes(ar1,ar2);
  int2:= 0;
  for int1:= 0 to high(ar1) do begin
   if ar1[int1] = name then begin
    int2:= int1;
    break;
   end;
  end;
  datasource1:= fdbeditinfointf.getdatasource(int2);
  if (datasource1 <> nil) and (datasource1.dataset <> nil) then begin
   result:= result + [ps_valuelist,ps_sortlist];
  end;
 end;
end;

function tdbfieldnamepropertyeditor.getvalues: msestringarty;
var
 propertynames: stringarty;
 fieldtypes: fieldtypesarty;
 ft: fieldtypesty;
 int1,int2: integer;
 ds: tdataset;
 dataso: tdatasource;
 
begin
 result:= nil;
 if (fdbeditinfointf <> nil) then begin
  int2:= 0;
  fdbeditinfointf.getfieldtypes(propertynames,fieldtypes);
  if high(propertynames) >= 0 then begin
   for int1:= 0 to high(propertynames) do begin
    if propertynames[int1] = fname then begin
     int2:= int1;
     break;
    end;
   end; 
  end;
  if int2 <= high(fieldtypes) then begin
   ft:= fieldtypes[int2];
  end
  else begin
   ft:= [];
  end;
  dataso:= fdbeditinfointf.getdatasource(int2);
  if dataso <> nil then begin
   ds:= dataso.dataset;
  end
  else begin
   ds:= nil;
  end;
  if ds <> nil then begin
   if ds.active or (ds.fields.count > 0) then begin
    for int1:= 0 to ds.fields.count -1 do begin
     with ds.fields[int1] do begin
      if ((ft = []) or (datatype = ftunknown) or (datatype in ft)) and
             (not fnocalc or (fieldkind <> fkcalculated)) then begin
       additem(result,msestring(fieldname));
      end;
     end;
    end;
   end
   else begin
    for int1:= 0 to ds.fielddefs.count -1 do begin
     with ds.fielddefs[int1] do begin
      if (ft = []) or (datatype = ftunknown) or (datatype in ft) then begin
       additem(result,msestring(name));
      end;
     end;
    end;
   end;
  end;
 end;
end;

{ tdbcolnamepropertyeditor }

function tdbcolnamepropertyeditor.getdefaultstate: propertystatesty;
var
 sqlresult1: tsqlresult;
 obj1: tobject;
 ar1: stringarty;
 ar2: fieldtypesarty;
 int1,int2: integer;
begin
 result:= inherited getdefaultstate;
 if fremote <> nil then begin
  obj1:= tobject(tpropertyeditor1(fremote.getparenteditor).getordvalue);
  if obj1 <> nil then begin
   getcorbainterface(obj1,typeinfo(idbcolinfo),fdbcolinfointf);
  end;
 end
 else begin
  if (high(fprops) = 0) then begin
   with fprops[0] do begin
    getcorbainterface(instance,typeinfo(idbcolinfo),fdbcolinfointf);
   end;
  end;
 end;
 if fdbcolinfointf <> nil then begin
  fdbcolinfointf.getfieldtypes(ar1,ar2);
  int2:= 0;
  for int1:= 0 to high(ar1) do begin
   if ar1[int1] = name then begin
    int2:= int1;
    break;
   end;
  end;
  sqlresult1:= fdbcolinfointf.getsqlresult(int2);
  if (sqlresult1 <> nil) and (sqlresult1.active)  then begin
   result:= result + [ps_valuelist,ps_sortlist];
  end;
 end; 
end;

function tdbcolnamepropertyeditor.getvalues: msestringarty;
var
 propertynames: stringarty;
 fieldtypes: fieldtypesarty;
 ft: fieldtypesty;
 int1,int2: integer;
 sqlresult1: tsqlresult;
 
begin
 result:= nil;
 if (fdbcolinfointf <> nil) then begin
  int2:= 0;
  fdbcolinfointf.getfieldtypes(propertynames,fieldtypes);
  if high(propertynames) >= 0 then begin
   for int1:= 0 to high(propertynames) do begin
    if propertynames[int1] = fname then begin
     int2:= int1;
     break;
    end;
   end; 
  end;
  if int2 <= high(fieldtypes) then begin
   ft:= fieldtypes[int2];
  end
  else begin
   ft:= [];
  end;
  sqlresult1:= fdbcolinfointf.getsqlresult(int2);
  if sqlresult1 <> nil then begin
   if sqlresult1.active or (sqlresult1.cols.count > 0) then begin
    for int1:= 0 to sqlresult1.cols.count -1 do begin
     with sqlresult1.cols[int1] do begin
      if (ft = []) or (datatype = ftunknown) or (datatype in ft) then begin
       additem(result,msestring(fieldname));
      end;
     end;
    end;
   end;
  end;
 end;
end;

{ tdbfieldnamearraypropertyeditor }

function tdbfieldnamearraypropertyeditor.geteditorclass: propertyeditorclassty;
begin
 result:= tdbfieldnamepropertyeditor;
end;

{ tdbcolnamearraypropertyeditor }

function tdbcolnamearraypropertyeditor.geteditorclass: propertyeditorclassty;
begin
 result:= tdbcolnamepropertyeditor;
end;

{ tpersistentfieldelementeditor }

function tpersistentfieldelementeditor.getvalue: msestring;
begin
 result:= '<'+tfield(getordvalue).fieldname+'>' + inherited getvalue;
end;

{ tpersistentfieldspropertyeditor }

function tpersistentfieldspropertyeditor.geteditorclass: propertyeditorclassty;
begin
 result:= tpersistentfieldelementeditor;
end;

function tpersistentfieldspropertyeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate + [ps_noadditems,ps_dialog];
end;

procedure tpersistentfieldspropertyeditor.edit;
begin
 if editpersistentfields(tpersistentfields(getordvalue)) then begin
  modified;
 end;
end;

{ tfieldfieldnamepropertyeditor }

function tfieldfieldnamepropertyeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate + [ps_valuelist,ps_sortlist];
end;

function tfieldfieldnamepropertyeditor.getvalues: msestringarty;
var
 ds: tdataset;
 int1,int2: integer;
 ar1,ar2,ar3: stringarty;
 intf: ipersistentfieldsinfo;
 fclass: tclass;
begin
 result:= nil;
 ds:= tfield(fprops[0].instance).dataset;
 if ds <> nil then begin
  setlength(ar1,ds.fielddefs.count);
  setlength(ar3,length(ar1));
  for int1:= 0 to high(ar1) do begin
   ar3[int1]:= ds.fielddefs[int1].name;
   ar1[int1]:= uppercase(ar3[int1]);
  end;
  setlength(ar2,ds.fields.count);
  for int1:= 0 to high(ar2) do begin
   ar2[int1]:= uppercase(ds.fields[int1].fieldname);
  end;
  for int1:= 0 to high(ar1) do begin
   for int2:= 0 to high(ar2) do begin
    if ar1[int1] = ar2[int2] then begin
     ar1[int1]:= '';
     break;
    end;
   end;
  end;
  if getcorbainterface(fprops[0].instance,
         typeinfo(ipersistentfieldsinfo),intf) then begin
   ar2:= intf.getfieldnames;
   for int1:= 0 to high(ar2) do begin
    ar2[int1]:= uppercase(ar2[int1]);
   end;
   for int1:= 0 to high(ar1) do begin
    for int2:= 0 to high(ar2) do begin
     if ar1[int1] = ar2[int2] then begin
      ar1[int1]:= '';
      break;
     end;
    end;
   end;
  end; 
  fclass:= tfield(fprops[0].instance).classtype;
  for int1:= 0 to high(ar1) do begin
   if (ar1[int1] <> '') and 
   fclass.inheritsfrom(ds.fielddefs[int1].fieldclass) then begin
    additem(result,ar3[int1]);
   end;
  end;
 end;
end;

procedure tfieldfieldnamepropertyeditor.setvalue(const value: msestring);
var
 ds: tdataset;
begin
 ds:= tfield(fprops[0].instance).dataset;
 if (ds <> nil) and (ds.findfield(value) <> nil) then begin
  raise exception.create('Field '''+value+''' exists in '+ds.name+'.');
 end;
 inherited;
end;

{ tfielddatasetpropertyeditor }

procedure tfielddatasetpropertyeditor.checkcomponent(const avalue: tcomponent);
var
 str1: string;
begin
 if avalue is tdataset then begin
  str1:= tfield(fprops[0].instance).fieldname;
  with tdataset(avalue) do begin
   if findfield(str1) <> nil then begin
    raise exception.create('Field '''+str1+''' exists in '+name+'.');
   end;
  end;
 end;  
end;

const
 sqlsyntax = 
'caseinsensitive'+lineend+
'styles'+lineend+
' default '''''+lineend+
' words ''b'''+lineend+
' comment ''i'' cl_dkblue'+lineend+
' option ''b'' cl_dkblue'+lineend+
' string '''' cl_dkblue'+lineend+
' '+lineend+
'keyworddefs sql'+lineend+
' ''ACTION'' ''ACTIVE'' ''ADD'' ''ADMIN'' ''AFTER'' ''ALL'' ''ALTER'' ''AND'''+lineend+
' ''ANY'' ''AS'' ''ASC'''+lineend+
' ''ASCENDING'' ''AT'' ''AUTO'' ''AUTODDL'''+lineend+
' ''AVG'' ''BASED'' ''BASENAME'' ''BASE_NAME'' ''BEFORE'' ''BEGIN'' ''BETWEEN'''+lineend+
' ''BLOB'' '+lineend+
' ''BLOBEDIT'' ''BUFFER'' ''BY'' ''CACHE'''+lineend+
' ''CASCADE'' ''CASE'' ''CAST'' ''CHAR'' ''CHARACTER'' ''CHARACTER_LENGTH'''+lineend+
' ''CHAR_LENGTH'' ''CHECK'' '+lineend+
' ''CHECK_POINT_LEN'''+lineend+
' ''CHECK_POINT_LENGTH'' ''COLLATE'' ''COLLATION'' ''COLUMN'' ''COMMIT'''+lineend+
' ''COMMITTED'' '+lineend+
' ''COMPILETIME'''+lineend+
' ''COMPUTED'' ''CLOSE'' ''CONDITIONAL'' ''CONNECT'' ''CONSTRAINT'''+lineend+
' ''CONTAINING'' ''CONTINUE'' '+lineend+
' ''COUNT'' ''CREATE'''+lineend+
' ''CSTRING'' ''CURRENT'' ''CURRENT_DATE'' ''CURRENT_TIME'''+lineend+
' ''CURRENT_TIMESTAMP'' ''CURSOR'''+lineend+
' ''DATABASE'' ''DATE'' ''DAY'' ''DB_KEY'' ''DEBUG'' ''DEC'' ''DECIMAL'''+lineend+
' ''DECLARE'' ''DEFAULT'' '+lineend+
' ''DELETE'' ''DESC'' ''DESCENDING'''+lineend+
' ''DESCRIBE'' ''DESCRIPTOR'' ''DISCONNECT'' ''DISPLAY'' ''DISTINCT'' ''DO'''+lineend+
' ''DOMAIN'' '+lineend+
' ''DOUBLE'' ''DROP'''+lineend+
' ''ECHO'' ''EDIT'' ''ELSE'' ''END'' ''ENTRY_POINT'' ''ESCAPE'' ''EVENT'''+lineend+
' ''EXCEPTION'' ''EXECUTE'''+lineend+
' ''EXISTS'' ''EXIT'' ''EXTERN'' ''EXTERNAL'' ''EXTRACT'' ''FETCH'' ''FILE'''+lineend+
' ''FILTER'' ''FLOAT'' '+lineend+
' ''FOR'' ''FOREIGN'' ''FOUND'''+lineend+
' ''FREE_IT'' ''FROM'' ''FULL'' ''FUNCTION'' ''GDSCODE'' ''GENERATOR'''+lineend+
' ''GEN_ID'' ''GLOBAL'' '+lineend+
' ''GOTO'''+lineend+
' ''GRANT'' ''GROUP'' ''GROUP_COMMIT_WAIT'' ''GROUP_COMMIT_'' ''WAIT_TIME'''+lineend+
' ''HAVING'' ''HELP'' '+lineend+
' ''HOUR'' ''IF'''+lineend+
' ''IMMEDIATE'' ''IN'' ''INACTIVE'' ''INDEX'' ''INDICATOR'' ''INIT'' ''INNER'''+lineend+
' ''INPUT'' '+lineend+
' ''INPUT_TYPE'''+lineend+
' ''INSERT'' ''INT'' ''INTEGER'' ''INTO'' ''IS'' ''ISOLATION'' ''ISQL'''+lineend+
' ''JOIN'' ''KEY'' '+lineend+
' ''LC_MESSAGES'' ''LC_TYPE'' ''LEFT'''+lineend+
' ''LENGTH'' ''LEV'' ''LEVEL'' ''LIKE'' ''LIMIT'''+lineend+
' ''LOGFILE'' ''LOG_BUFFER_SIZE'''+lineend+
' ''LOG_BUF_SIZE'' '+lineend+
' ''LONG'' ''MANUAL'''+lineend+
' ''MAX'' ''MAXIMUM'' ''MAXIMUM_SEGMENT'' ''MAX_SEGMENT'' ''MERGE'''+lineend+
' ''MESSAGE'' ''MIN'' '+lineend+
' ''MINIMUM'' ''MINUTE'''+lineend+
' ''MODULE_NAME'' ''MONTH'' ''NAMES'' ''NATIONAL'' ''NATURAL'' ''NCHAR'''+lineend+
' ''NO'' ''NOAUTO'' '+lineend+
' ''NOT'''+lineend+
' ''NULL'' ''NUMERIC'' ''NUM_LOG_BUFS'' ''NUM_LOG_BUFFERS'' ''OCTET_LENGTH'''+lineend+
' ''OF'' ''ON'' '+lineend+
' ''ONLY'' ''OPEN'''+lineend+
' ''OPTION'' ''OR'' ''ORDER'' ''OUTER'' ''OUTPUT'' ''OUTPUT_TYPE'' ''OVERFLOW'''+lineend+
' ''PAGE'' '+lineend+
' ''PAGELENGTH'''+lineend+
' ''PAGES'' ''PAGE_SIZE'' ''PARAMETER'' ''PASSWORD'' ''PLAN'' ''POSITION'''+lineend+
' ''POST_EVENT'' '+lineend+
' ''PRECISION'' ''PREPARE'''+lineend+
' ''PROCEDURE'' ''PROTECTED'' ''PRIMARY'' ''PRIVILEGES'' ''PUBLIC'' ''QUIT'''+lineend+
' ''RAW_PARTITIONS'' ''RDB$DB_KEY'' ''READ'' ''REAL'' ''RECORD_VERSION'''+lineend+
' ''REFERENCES'''+lineend+
' ''RELEASE'' ''RESERV'' ''RESERVING'' ''RESTRICT'' ''RETAIN'' ''RETURN'''+lineend+
' ''RETURNING_VALUES'' ''RETURNS'' ''REVOKE'' ''RIGHT'' ''ROLE'' ''ROLLBACK'''+lineend+
' ''RUNTIME'' '+lineend+
' ''SCHEMA'' ''SECOND'''+lineend+
' ''SEGMENT'' ''SELECT'' ''SET'' ''SHADOW'' ''SHARED'' ''SHELL'' ''SHOW'''+lineend+
' ''SINGULAR'' ''SIZE'''+lineend+
' ''SMALLINT'' ''SNAPSHOT'' ''SOME'' ''SORT'' ''SQLCODE'' ''SQLERROR'''+lineend+
' ''SQLWARNING'' '+lineend+
' ''STABILITY'' ''STARTING'''+lineend+
' ''STARTS'' ''STATEMENT'' ''STATIC'' ''STATISTICS'' ''SUB_TYPE'' ''SUM'''+lineend+
' ''SUSPEND'' '+lineend+
' ''TABLE'' ''TERMINATOR'''+lineend+
' ''THEN'' ''TIME'' ''TIMESTAMP'' ''TO'' ''TRANSACTION'' ''TRANSLATE'''+lineend+
' ''TRANSLATION'' '+lineend+
' ''TRIGGER'' ''TRIM'''+lineend+
' ''TYPE'' ''UNCOMMITTED'' ''UNION'' ''UNIQUE'' ''UPDATE'' ''UPPER'' ''USER'''+lineend+
' ''USING'' '+lineend+
' ''VALUE'+lineend+
' ''VALUES'' ''VARCHAR'' ''VARIABLE'' ''VARYING'' ''VERSION'' ''VIEW'' ''WAIT'''+lineend+
' ''WEEKDAY'' '+lineend+
' ''WHEN'''+lineend+
' ''WHENEVER'' ''WHERE'' ''WHILE'' ''WITH'' ''WORK'' ''WRITE'' ''YEAR'''+lineend+
' ''YEARDAY'''+lineend+
''+lineend+
'scope comment1 comment'+lineend+
' endtokens'+lineend+
'  ''*/'''+lineend+
'  '+lineend+
'scope comment2 comment'+lineend+
' endtokens'+lineend+
'  '''''+lineend+
'  '+lineend+
'scope string string'+lineend+
' endtokens'+lineend+
'  '''''''' '''''+lineend+
'  '+lineend+
'scope main'+lineend+
''+lineend+
' keywords words'+lineend+
'  sql'+lineend+
' calltokens'+lineend+
'  ''/*'' comment1'+lineend+
'  ''--'' comment2'+lineend+
'  '''''''' string'+lineend;

var
 sqlindex: integer = -1;
 
{ tsqlpropertyeditor }

function tsqlpropertyeditor.getsyntaxindex: integer;
begin
 if sqlindex < 0 then begin
  sqlindex:= msetexteditor.syntaxpainter.readdeffile(sqlsyntax);
 end;
 result:= sqlindex;
end;

procedure tsqlpropertyeditor.doafterclosequery(
                 var amodalresult: modalresultty);
begin
 if amodalresult = mr_canclose then begin
  if fintf <> nil then begin
   fintf.setactive(true);
  end;
 end;
end;

function tsqlpropertyeditor.gettestbutton: boolean;
begin
 result:= fintf <> nil;
end;

function tsqlpropertyeditor.getutf8: boolean;
begin
 result:= (fintf <> nil) and fintf.isutf8;
end;

procedure tsqlpropertyeditor.edit;
begin
 if not nocheck and getcorbainterface(fprops[0].instance,
                            typeinfo(isqlpropertyeditor),fintf) then begin
  factivebefore:= fintf.getactive;
 end
 else begin
  fintf:= nil;
 end;
 inherited;
 if not factivebefore and (fintf <> nil) then begin
  fintf.setactive(false);
 end;
end;

function tsqlpropertyeditor.getcaption: msestring;
begin
 result:= 'SQL Editor';
end;

function tsqlpropertyeditor.nocheck: boolean;
begin
 result:= false;
end;

{ tmsesqlpropertyeditor }

function tmsesqlpropertyeditor.getsyntaxindex: integer;
begin
 if sqlindex < 0 then begin
  sqlindex:= msetexteditor.syntaxpainter.readdeffile(sqlsyntax);
 end;
 result:= sqlindex;
end;

procedure tmsesqlpropertyeditor.doafterclosequery(
                 var amodalresult: modalresultty);
begin
 if amodalresult = mr_canclose then begin
  if fintf <> nil then begin
   fintf.setactive(true);
  end;
 end;
end;

function tmsesqlpropertyeditor.gettestbutton: boolean;
begin
 result:= fintf <> nil;
end;

function tmsesqlpropertyeditor.getutf8: boolean;
begin
 result:= (fintf <> nil) and fintf.isutf8;
end;

procedure tmsesqlpropertyeditor.edit;
begin
 if not nocheck and getcorbainterface(fprops[0].instance,
                            typeinfo(isqlpropertyeditor),fintf) then begin
  factivebefore:= fintf.getactive;
 end
 else begin
  fintf:= nil;
 end;
 inherited;
 if not factivebefore and (fintf <> nil) then begin
  fintf.setactive(false);
 end;
end;

function tmsesqlpropertyeditor.getcaption: msestring;
begin
 result:= 'SQL Editor';
end;

function tmsesqlpropertyeditor.nocheck: boolean;
begin
 result:= false;
end;

function tmsesqlpropertyeditor.ismsestring: boolean;
begin
 result:= true;
end;

{ tsqlnocheckpropertyeditor }

function tsqlnocheckpropertyeditor.nocheck: boolean;
begin
 result:= true;
end;

{ tmsesqlnocheckpropertyeditor }

function tmsesqlnocheckpropertyeditor.nocheck: boolean;
begin
 result:= true;
end;

{ tonfilterpropertyeditor }

function tonfilterpropertyeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate + [ps_volatile];
end;

procedure tonfilterpropertyeditor.setvalue(const value: msestring);

begin
 inherited;
 with tlbdropdownlistcontroller(fprops[0].instance) do begin
  if not (olb_copyitems in optionslb) then begin
   if getmethodvalue.data <> nil then begin
    if buttonlength = 0 then begin
     buttonlength:= -1;
    end;
   end
   else begin
    if buttonlength = -1 then begin
     buttonlength:= 0;
    end;
   end;
  end;
 end;
end;

{ tfielddefspropertyeditor }

procedure tfielddefspropertyeditor.setvalue(const value: msestring);
var
 int1: integer;
begin
 for int1:= 0 to high(fprops) do begin
  tdataset(fprops[int1].instance).active:= false;
 end; 
 inherited;
end;

{ tdatasetactivepropertyeditor }

function tdatasetactivepropertyeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate + [ps_volatile];
end;

{ tfielddefpropertyeditor }

function tfielddefpropertyeditor.getvalue: msestring;
begin
 with tfielddef(fprops[0].instance) do begin
  result:= '<'+name+'><'+
    getenumname(typeinfo(tfieldtype),ord(datatype))+'>';
 end;
end;

{ tdbparampropertyeditor }

function tdbparampropertyeditor.getvalue: msestring;
begin
 with tparam(fprops[0].instance) do begin
  result:= '<'+name+'><'+getenumname(typeinfo(tfieldtype),ord(datatype))+
      {'><'+getenumname(typeinfo(tparamtype),ord(paramtype))+}'>';
 end;
end;

{ tdbstringcoleditor }

function tdbstringcoleditor.getvalue: msestring;
begin
 result:= inherited getvalue +  '<'+tdbstringcol(getordvalue).datafield+'>';
end;

{ tdbstringcolseditor }

function tdbstringcolseditor.geteditorclass: propertyeditorclassty;
begin
 result:= tdbstringcoleditor;
end;

{ tindexfieldnamepropertyeditor }

function tindexfieldnamepropertyeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate + [ps_valuelist,ps_sortlist];
end;

function tindexfieldnamepropertyeditor.getvalues: msestringarty;
var
 int1: integer;
begin
 if high(fprops) = 0 then begin
  with tmsebufdataset(fcomponent) do begin
   result:= nil;
   if active or (fields.count > 0) then begin
    for int1:= 0 to fields.count -1 do begin
     with fields[int1] do begin
      if (datatype in indexfieldtypes) and 
                           (fieldkind in [fkdata,fkinternalcalc]) then begin
       additem(result,msestring(fieldname));
      end;
     end;
    end;
   end
   else begin
    for int1:= 0 to fielddefs.count -1 do begin
     with fielddefs[int1] do begin
      if (datatype in indexfieldtypes) then begin
       additem(result,msestring(name));
      end;
     end;
    end;
   end;
  end;
 end;  
end;

{ tindexfieldpropertyeditor }

function tindexfieldpropertyeditor.getvalue: msestring;
begin
 result:= '<'+tindexfield(getordvalue).fieldname+'>';
end;

function tindexfieldpropertyeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate + [ps_refresh]
end;

{ tindexfieldspropertyeditor }

function tindexfieldspropertyeditor.geteditorclass: propertyeditorclassty;
begin
 result:= tindexfieldpropertyeditor;
end;

{ tlocalindexpropertyeditor }

function tlocalindexpropertyeditor.getvalue: msestring;
var
 int1: integer;
begin
 result:= '<';
 with tlocalindex(getordvalue).fields do begin
  if count > 0 then begin
   for int1:= 0 to count - 1 do begin
    result:= result + items[int1].fieldname+',';
   end;
   setlength(result,length(result)-1);
  end;
 end;
 result:= result + '>';
end;

function tlocalindexpropertyeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate + [ps_refresh];
end;

{ tlocalindexespropertyeditor }

function tlocalindexespropertyeditor.geteditorclass: propertyeditorclassty;
begin
 result:= tlocalindexpropertyeditor;
end;

{ tdbfieldnamenocalcpropertyeditor }

constructor tdbfieldnamenocalcpropertyeditor.create(const adesigner: idesigner;
               const amodule: tmsecomponent; const acomponent: tcomponent;
               const aobjectinspector: iobjectinspector;
               const aprops: propinstancearty; atypeinfo: ptypeinfo);
begin
 fnocalc:= true;
 inherited;
end;

initialization
 register;
end.

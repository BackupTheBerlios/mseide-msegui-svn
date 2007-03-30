{ MSEgui Copyright (c) 1999-2006 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit regdb;

{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface
uses
 msesqldb,msedbedit,msepropertyeditors,msedb,mseclasses,msetypes,msestrings;
 
type
 tdbfieldnamepropertyeditor = class(tstringpropertyeditor)
  protected
   fdbeditinfointf: idbeditinfo;
   function getdefaultstate: propertystatesty; override;
  public
   function getvalues: msestringarty; override;
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

implementation
uses
 dbconst,classes,msedesignintf,db,typinfo,mseibconnection,
 msepqconnection,mseodbcconn,msemysql40conn,msemysql41conn,msemysql50conn,{sqldb,}
 mselookupbuffer,msedbf,msesdfdata,msememds,
 msedatalist,msedbfieldeditor,sysutils,msetexteditor,
 msedbdispwidgets,msedbgraphics,regdb_bmp,msegui,msedbdialog,msegrids,
 regwidgets,msebufdataset,msedbevents,msesqlite3conn
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
 
 tsqlpropertyeditor = class(ttextstringspropertyeditor)
  protected
   function getsyntaxindex: integer; override;
 end;

 tsqlquerysqlpropertyeditor = class(tsqlpropertyeditor)
  private
   factivebefore: boolean;
  protected
   procedure doafterclosequery(var amodalresult: modalresultty); override;
   function gettestbutton: boolean; override;
   function getutf8: boolean; override;
  public
   procedure edit; override;
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
 registercomponents('Dbf',[
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
 registercomponents('Db',[
      tenumeditdb,tkeystringeditdb,tenumeditlb,tkeystringeditlb,
      tdbmemoedit,tdbstringedit,tdbdropdownlistedit,tdbdialogstringedit,
      tdbbooleantextedit,
      tdbkeystringedit,tdbkeystringeditdb,tdbkeystringeditlb,
      tdbintegeredit,tdbenumedit,tdbenumeditdb,tdbenumeditlb,
      tdbdataicon,tdbdataimage,tdbdatabutton,tdbrealedit,tdbdatetimeedit,
      tdbcalendardatetimeedit,tdbfilenameedit,
      tdbbooleanedit,tdbbooleaneditradio,
      tdbwidgetgrid,tdbstringgrid,
      
      
      tlookupbuffer,tdblookupbuffer,tdbmemolookupbuffer,
      tmsedatasource,tdbnavigator,
      tmsedbf,tmsefixedformatdataset,tmsesdfdataset,tmsememdataset,
      tmsesqlquery,tmsesqltransaction,
      tmseibconnection,tmsepqconnection,tmseodbcconnection,
      tmsemysql40connection,tmsemysql41connection,tmsemysql50connection,
      tsqlite3connection
      {$ifdef mse_with_sqlite}
       ,tmsesqlite3dataset
      {$endif}
      ]);
 registerpropertyeditor(typeinfo(tnolistdropdowncol),nil,'',tclasspropertyeditor);
 registerpropertyeditor(typeinfo(tnolistdropdowncols),nil,'',
        tnolistdropdowncolpropertyeditor);
 registerpropertyeditor(typeinfo(string),nil,'datafield',
        tdbfieldnamepropertyeditor);
 registerpropertyeditor(typeinfo(string),tfieldfieldlink,'sourcedatafield',
        tdbfieldnamepropertyeditor);
 registerpropertyeditor(typeinfo(string),nil,'keyfield',
        tdbfieldnamepropertyeditor);
 registerpropertyeditor(typeinfo(string),tgriddatalink,'',
        tdbfieldnamepropertyeditor);
 registerpropertyeditor(typeinfo(tdbfieldnamearrayprop),nil,'',
        tdbfieldnamearraypropertyeditor);
 registerpropertyeditor(typeinfo(tpersistentfields),nil,'',
        tpersistentfieldspropertyeditor);
 registerpropertyeditor(typeinfo(string),tfield,'FieldName',
        tfieldfieldnamepropertyeditor);
 registerpropertyeditor(typeinfo(tcomponent),tfield,'Dataset',
        tfielddatasetpropertyeditor);
 registerpropertyeditor(typeinfo(string),tfieldparamlink,'paramname',
        tdbparamnamepropertyeditor);
 registerpropertyeditor(typeinfo(tstringlist),nil,'SQL',
        tsqlpropertyeditor);
 registerpropertyeditor(typeinfo(tstringlist),tmsesqlquery,'SQL',
        tsqlquerysqlpropertyeditor);
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
      if (ft = []) or (datatype = ftunknown) or (datatype in ft) then begin
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
 {
 if (fdbeditinfointf <> nil) and (fdbeditinfointf.getdatasource <> nil) then begin
  ds:= fdbeditinfointf.getdatasource.dataset;
  if ds <> nil then begin
   ft:= [];
   fdbeditinfointf.getfieldtypes(propertynames,fieldtypes);
   if high(fieldtypes) >= 0 then begin
    if high(propertynames) >= 0 then begin
     str1:= fname;
     for int1:= 0 to high(propertynames) do begin
      if propertynames[int1] = str1 then begin
       ft:= fieldtypes[int1];
       break;
      end;
     end; 
    end
    else begin
     ft:= fieldtypes[0];
    end;
   end;
   if ds.active then begin
    for int1:= 0 to ds.fields.count -1 do begin
     with ds.fields[int1] do begin
      if (ft = []) or (datatype = ftunknown) or (datatype in ft) then begin
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
 }
end;


{ tdbfieldnamearraypropertyeditor }

function tdbfieldnamearraypropertyeditor.geteditorclass: propertyeditorclassty;
begin
 result:= tdbfieldnamepropertyeditor;
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

{ tsqlquerysqlpropertyeditor }

procedure tsqlquerysqlpropertyeditor.doafterclosequery(
                 var amodalresult: modalresultty);
begin
 if amodalresult = mr_canclose then begin
  tmsesqlquery(fprops[0].instance).active:= true;
 end;
end;

function tsqlquerysqlpropertyeditor.gettestbutton: boolean;
begin
 result:= true;
end;

function tsqlquerysqlpropertyeditor.getutf8: boolean;
begin
 result:= dso_utf8 in tmsesqlquery(fprops[0].instance).controller.options;
end;

procedure tsqlquerysqlpropertyeditor.edit;
begin
 factivebefore:= tmsesqlquery(fprops[0].instance).active;
 inherited;
 if not factivebefore then begin
  tmsesqlquery(fprops[0].instance).active:= false;
 end;
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

initialization
 register;
end.

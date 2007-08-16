{ MSEgui Copyright (c) 1999-2007 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit msesqldb;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
interface
uses
 classes,db,msebufdataset,
                   msqldb,msedb,mseclasses,msetypes,mseguiglob,msedatabase;
  
type
 tmsesqltransaction = class(tsqltransaction)
  private
   fcontroller: ttacontroller;
   function getactive: boolean;
   procedure setactive(const avalue: boolean);
   procedure setcontroller(const avalue: ttacontroller);
  protected
   procedure loaded; override;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
  published
   property Active : boolean read getactive write setactive;
   property controller: ttacontroller read fcontroller write setcontroller;
 end;

 tmsesqlquery = class;
 
 sqlquerystatety = (sqs_userapplayrecupdate,sqs_updateabort,sqs_updateerror);
 sqlquerystatesty = set of sqlquerystatety;
 applyrecupdateeventty = 
     procedure(const sender: tmsesqlquery; const updatekind: tupdatekind;
                        var asql: string; var done: boolean) of object;
 updateerroreventty = procedure(const sender: tmsesqlquery;
                          const aupdatekind: tupdatekind;
                          var aupdateaction: tupdateaction) of object;
                             
 tmsesqlquery = class(tsqlquery,imselocate,idscontroller,igetdscontroller,
                              isqlpropertyeditor)
  private
   fsqlonchangebefore: tnotifyevent;
   fcontroller: tdscontroller;
   fmstate: sqlquerystatesty;
   fonapplyrecupdate: applyrecupdateeventty;
//   fwantedreadonly: boolean;
   procedure setcontroller(const avalue: tdscontroller);
   procedure setactive(value : boolean); {override;}
   function getactive: boolean;
   procedure setonapplyrecupdate(const avalue: applyrecupdateeventty);
//   function getreadonly: boolean;
//   procedure setreadonly(const avalue: boolean);
//   function getparsesql: boolean;
//   procedure setparsesql(const avalue: boolean);
//   function recupdatesql(updatekind : tupdatekind): string;
   function getcontroller: tdscontroller;
   function getindexdefs: TIndexDefs;
   procedure setindexdefs(const avalue: TIndexDefs);
   function getetstatementtype: TStatementType;
   procedure setstatementtype(const avalue: TStatementType);
   procedure afterapply; override;
  protected
   procedure updateindexdefs; override;
   procedure sqlonchange(sender: tobject);
   procedure loaded; override;
   procedure internalopen; override;
   procedure internalclose; override;
   procedure internalinsert; override;
   procedure internaldelete; override;
//   procedure internalpost; override;
   procedure applyrecupdate(updatekind: tupdatekind); override;
   function  getcanmodify: boolean; override;
   function  getfieldclass(fieldtype: tfieldtype): tfieldclass; override;
   function islocal: boolean; override;
       //idscontroller
   procedure inheriteddataevent(const event: tdataevent; const info: ptrint);
   procedure inheritedcancel;
   procedure inheritedpost;
   function inheritedmoveby(const distance: integer): integer;  
   procedure inheritedinternalinsert;
   procedure inheritedinternaldelete;
   procedure inheritedinternalopen;
   procedure inheritedinternalclose;
   
   procedure DoAfterDelete; override;
   procedure dataevent(event: tdataevent; info: ptrint); override;
   function wantblobfetch: boolean; override;
   function closetransactiononrefresh: boolean; override;
      
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   function isutf8: boolean; override;
   function locate(const key: integer; const field: tfield;
                   const options: locateoptionsty = []): locateresultty;
   function locate(const key: string; const field: tfield; 
                 const options: locateoptionsty = []): locateresultty;
   procedure appendrecord(const values: array of const);
   function moveby(const distance: integer): integer;
   procedure cancel; override;
   procedure post; override;
   procedure applyupdates(const maxerrors: integer;
                     const cancelonerror: boolean); override; overload;
   procedure applyupdates(const maxerrors: integer = 0); override; overload;
   procedure applyupdate; override; overload;
  published
   property FieldDefs;
   property controller: tdscontroller read fcontroller write setcontroller;
   property Active: boolean read getactive write setactive;
   property onapplyrecupdate: applyrecupdateeventty read fonapplyrecupdate
                                  write setonapplyrecupdate;
//   property ParseSQL: boolean read getparsesql write setparsesql default true;
//   property ReadOnly: boolean read getreadonly write setreadonly default false;
   property UpdateMode default upWhereKeyOnly;
   property UsePrimaryKeyAsKey default true;
   property IndexDefs : TIndexDefs read getindexdefs write setindexdefs;
               //must be writable because it is streamed
   property StatementType : TStatementType read getetstatementtype 
                                  write setstatementtype;
               //must be writable because it was streamed in FPC 2.0.4
 end;

 idbparaminfo = interface(inullinterface)['{D0EDEE1E-A4CC-DA11-9F9B-00C0CA1308FF}']
  function getdestdataset: tsqlquery;
 end;
 
 tfieldparamlink = class;

 setparameventty = procedure(const sender: tfieldparamlink;
                        var done: boolean) of object;  
                        
 tparamsourcedatalink = class(tfielddatalink)
  private
   fowner: tfieldparamlink;
   fparamset: boolean;
  protected
   procedure recordchanged(afield: tfield); override;
  public
   constructor create(const aowner: tfieldparamlink);
   procedure loaded;
 end;
 
 fieldparamlinkoptionty = (fplo_autorefresh);
 fieldparamlinkoptionsty = set of fieldparamlinkoptionty;
const
 defaultfieldparamlinkoptions = [fplo_autorefresh];
 
type  
 tfieldparamlink = class(tmsecomponent,idbeditinfo,idbparaminfo)
  private
   fsourcedatalink: tparamsourcedatalink;
   fdestdatasource: tdatasource;
   fparamname: string;
   fonsetparam: setparameventty;
   fonaftersetparam: notifyeventty;
   foptions: fieldparamlinkoptionsty;
   function getdatafield: string;
   procedure setdatafield(const avalue: string);
   function getdatasource: tdatasource; overload;
   procedure setdatasource(const avalue: tdatasource);
   function getvisualcontrol: boolean;
   procedure setvisualcontrol(const avalue: boolean);
   function getdestdataset: tsqlquery;
   procedure setdestdataset(const avalue: tsqlquery);
  protected
   procedure loaded; override;
   //idbeditinfo
   function getdatasource(const aindex: integer): tdatasource; overload;
   procedure getfieldtypes(out propertynames: stringarty;
                          out fieldtypes: fieldtypesarty);
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   function param: tparam;
   function field: tfield;
  published
   property datafield: string read getdatafield write setdatafield;
   property datasource: tdatasource read getdatasource write setdatasource;
   property visualcontrol: boolean read getvisualcontrol 
                    write setvisualcontrol default false;
   property destdataset: tsqlquery read getdestdataset write setdestdataset;
   property paramname: string read fparamname write fparamname;
   property options: fieldparamlinkoptionsty read foptions write foptions
                      default defaultfieldparamlinkoptions;
   property onsetparam: setparameventty read fonsetparam write fonsetparam;
   property onaftersetparam: notifyeventty read fonaftersetparam
                                  write fonaftersetparam;
 end;

 tsequencelink = class;
 
 tsequencedatalink = class(tfielddatalink)
  private
   fowner: tsequencelink;
  protected
   procedure updatedata; override;
  public
   constructor create(const aowner: tsequencelink);
 end;
  
 tsequencelink = class(tmsecomponent,idbeditinfo)
  private
   fsequencename: string;
   fdatabase: tsqlconnection;
   fdbintf: idbcontroller;
   fdatalink: tfielddatalink;
   procedure checkintf;
   procedure setdatabase(const avalue: tsqlconnection);
   procedure setsequencename(const avalue: string);
   function getaslargeint: largeint;
   procedure setaslargeint(const avalue: largeint);
   function getasinteger: integer;
   procedure setasinteger(const avalue: integer);
   function getdatasource: tdatasource; overload;
   procedure setdatasource(const avalue: tdatasource);
   function getdatafield: string;
   procedure setdatafield(const avalue: string);
   //idbeditinfo
   function getdatasource(const aindex: integer): tdatasource; overload;
   procedure getfieldtypes(out propertynames: stringarty;
                          out fieldtypes: fieldtypesarty);
  protected
   procedure notification(acomponent: tcomponent; operation: toperation); override;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   property aslargeint: largeint read getaslargeint write setaslargeint;
   property asinteger: integer read getasinteger write setasinteger;
   function assql: string;
  published
   property database: tsqlconnection read fdatabase write setdatabase;
   property datasource: tdatasource read getdatasource write setdatasource;
   property datafield: string read getdatafield write setdatafield;
   property sequencename: string read fsequencename write setsequencename;
 end;
 
implementation
uses
 msestrings,dbconst,msesysutils,typinfo,sysutils,msedatalist,msegui;
 
//type 
{
  TBufDatasetcracker = class(TDBDataSet)
  private
    FCurrentRecBuf  : PBufRecLinkItem;
    FLastRecBuf     : PBufRecLinkItem;
    FFirstRecBuf    : PBufRecLinkItem;
    FBRecordCount   : integer;

    FPacketRecords  : integer;
    FRecordSize     : Integer;
    FNullmaskSize   : byte;
    FOpen           : Boolean;
    FUpdateBuffer   : TRecordsUpdateBuffer;
    FCurrentUpdateBuffer : integer;

    FFieldBufPositions : array of longint;
    
    FAllPacketsFetched : boolean;
    FOnUpdateError  : TResolverErrorEvent;

  end;
 }
 { 
  TSQLQuerycracker = class (Tmsebufdataset)
  private
    FCursor              : TSQLCursor;
    FUpdateable          : boolean;
    FTableName           : string;
    FSQL                 : TStringList;
    FUpdateSQL,
    FInsertSQL,
    FDeleteSQL           : TStringList;
    FIsEOF               : boolean;
    FLoadingFieldDefs    : boolean;
    FIndexDefs           : TIndexDefs;
    FReadOnly            : boolean;
    FUpdateMode          : TUpdateMode;
    FParams              : TParams;
    FusePrimaryKeyAsKey  : Boolean;
    FSQLBuf              : String;
    FFromPart            : String;
    FWhereStartPos       : integer;
    FWhereStopPos        : integer;
    FParseSQL            : boolean;
    FMasterLink          : TMasterParamsDatalink;
//    FSchemaInfo          : TSchemaInfo;

    FUpdateQry,
    FDeleteQry,
    FInsertQry           : TSQLQuery;
  end;
  }
{  
function GetFieldIsNull(NullMask : pbyte;x : longint) : boolean; //inline;
begin
  result := ord(NullMask[x div 8]) and (1 shl (x mod 8)) > 0
end;

procedure unSetFieldIsNull(NullMask : pbyte;x : longint); //inline;
begin
  NullMask[x div 8] := (NullMask[x div 8]) and not (1 shl (x mod 8));
end;

procedure SetFieldIsNull(NullMask : pbyte;x : longint); //inline;
begin
  NullMask[x div 8] := (NullMask[x div 8]) or (1 shl (x mod 8));
end;
}
{ tmsesqltransaction }

constructor tmsesqltransaction.create(aowner: tcomponent);
begin
 inherited;
 fcontroller:= ttacontroller.create(self);
end;

destructor tmsesqltransaction.destroy;
begin
 fcontroller.free;
 inherited;
end;

function tmsesqltransaction.getactive: boolean;
begin
 result:= inherited active;
end;

procedure tmsesqltransaction.setactive(const avalue: boolean);
begin
 if fcontroller.setactive(avalue) then begin
  inherited active:= avalue;
 end;
end;

procedure tmsesqltransaction.setcontroller(const avalue: ttacontroller);
begin
 fcontroller.assign(avalue);
end;

procedure tmsesqltransaction.loaded;
begin
 inherited;
 fcontroller.loaded;
end;

{ tmsesqlquery }

constructor tmsesqlquery.create(aowner: tcomponent);
begin
 inherited;
// updatemode:= upwhereall;
 fsqlonchangebefore:= sql.onchange;
 sql.onchange:= {$ifdef FPC}@{$endif}sqlonchange;
 fcontroller:= tdscontroller.create(self,idscontroller(self),-1,false);
end;

destructor tmsesqlquery.destroy;
begin
 fcontroller.free;
 inherited;
end;

function tmsesqlquery.getindexdefs: TIndexDefs;
begin
 result:= inherited indexdefs;
end;

procedure tmsesqlquery.setindexdefs(const avalue: TIndexDefs);
begin
 inherited indexdefs.assign(avalue);
end;

procedure tmsesqlquery.updateindexdefs;
begin
 indexdefs.clear;
 inherited;
end;

function tmsesqlquery.locate(const key: integer; const field: tfield;
                      const options: locateoptionsty = []): locateresultty;
begin
 result:= fcontroller.locate(key,field,options);
end;
                     
function tmsesqlquery.locate(const key: string; const field: tfield; 
                      const options: locateoptionsty = []): locateresultty;
begin
 result:= fcontroller.locate(key,field,options);
end;

procedure tmsesqlquery.appendrecord(const values: array of const);
begin
 fcontroller.appendrecord(values);
end;

procedure tmsesqlquery.sqlonchange(sender: tobject);
begin
 if (csdesigning in componentstate) and active then begin
  active:= false;
  fsqlonchangebefore(sender);
  active:= true;
 end
 else begin
  fsqlonchangebefore(sender);
 end;
end;

procedure tmsesqlquery.setcontroller(const avalue: tdscontroller);
begin
 fcontroller.assign(avalue);
end;

procedure tmsesqlquery.setactive(value: boolean);
begin
 if fcontroller.setactive(value) then begin
  inherited;
 end;
end;

procedure tmsesqlquery.loaded;
begin
// if not fwantedreadonly and assigned(fonapplyrecupdate) then begin
//  readonly:= false;
// end;
 inherited;
 fcontroller.loaded;
end;

function tmsesqlquery.getactive: boolean;
begin
 result:= inherited active;
end;

procedure tmsesqlquery.inheritedinternalopen;
begin
 inherited internalopen;
end;

procedure tmsesqlquery.internalopen;
var
 intf1: idbcontroller;
 bo1: boolean;
begin
 if (database <> nil) and 
          getcorbainterface(database,typeinfo(idbcontroller),intf1) then begin
  bo1:= dso_utf8 in fcontroller.options;
  intf1.updateutf8(bo1);
  if bo1 then begin
   fcontroller.options:= fcontroller.options + [dso_utf8];
  end
  else begin
   fcontroller.options:= fcontroller.options - [dso_utf8];
  end;
 end;
 fcontroller.internalopen;
 if not streamloading and not (dso_local in fcontroller.options) then begin
  connected:= not (dso_offline in fcontroller.options);
 end;
end;

procedure tmsesqlquery.setonapplyrecupdate(const avalue: applyrecupdateeventty);
begin
 if not (csloading in componentstate) then begin
  checkinactive;
 end;
 if assigned(avalue) and not (csdesigning in componentstate) then begin
  include(fmstate,sqs_userapplayrecupdate);
 end
 else begin
  exclude(fmstate,sqs_userapplayrecupdate);
 end;
 fonapplyrecupdate:= avalue;
// if not assigned(avalue) and not inherited parsesql then begin
//  freadonly:= true;
// end;
end;

function tmsesqlquery.getcanmodify: Boolean;
begin
 result:= inherited getcanmodify or not readonly and 
               (sqs_userapplayrecupdate in fmstate);
end;
{
function tmsesqlquery.recupdatesql(updatekind: tupdatekind): string;

 procedure updatewherepart(var sql_where: string; x: integer);
 begin
  if (pfinkey in fields[x].providerflags) or
       ((pfinwhere in fields[x].providerflags) and 
        ((updatemode = upwhereall) or
         (updatemode = upwherechanged) and (pfinwhere in fields[x].providerflags)
                 and fieldchanged(fields[x])
        )
       ) then begin
   sql_where:= sql_where + '(' + fields[x].fieldname + '=' + 
            fieldtooldsql(fields[x]) + ') and ';
   end;
  end;

  function modifyrecquery : string;
  var
   x: integer;
   sql_set: string;
   sql_where: string;
  begin
   sql_set := '';
   sql_where := '';
   for x := 0 to fields.count -1 do begin
    updatewherepart(sql_where,x);
    if (pfinupdate in fields[x].providerflags) then begin
     sql_set := sql_set + fields[x].fieldname + '=' + fieldtosql(fields[x]) + ',';
    end;
   end;
   setlength(sql_set,length(sql_set)-1);
   setlength(sql_where,length(sql_where)-5);
   result:= 'update ' + ftablename + 
         ' set ' + sql_set + ' where ' + sql_where;
  end;

  function insertrecquery: string;
  var 
   x: integer;
   sql_fields: string;
   sql_values: string;

  begin
   sql_fields := '';
   sql_values := '';
   for x := 0 to fields.count -1 do begin
    if not fields[x].IsNull then begin
     sql_fields := sql_fields + fields[x].fieldname + ',';
     sql_values := sql_values + fieldtosql(fields[x]) + ',';
    end;
   end;
   setlength(sql_fields,length(sql_fields)-1);
   setlength(sql_values,length(sql_values)-1);
   result := 'insert into ' + ftablename + 
               ' (' + sql_fields + ') values (' + sql_values + ')';
  end;

  function deleterecquery : string;
  var
   x: integer;
   sql_where: string;
  begin
   sql_where := '';
   for x := 0 to fields.Count -1 do begin
    updatewherepart(sql_where,x);
   end;
   setlength(sql_where,length(sql_where)-5);
   result := 'delete from ' + ftablename +
                     ' where ' + sql_where;
  end;

begin
 result:= '';
 case updatekind of
  ukmodify: result:= modifyrecquery;
  ukinsert: result:= insertrecquery;
  ukdelete: result:= deleterecquery;
 end;
end;
}
procedure tmsesqlquery.applyrecupdate(updatekind: tupdatekind);
var
 bo1: boolean;
 str1: string;
begin
 try
  if sqs_userapplayrecupdate in fmstate then begin
   bo1:= false;
   fonapplyrecupdate(self,updatekind,str1,bo1);
   if not bo1 then begin
    if str1 = '' then begin
     inherited;
    end
    else begin
 {$ifdef debugsqlquery}  
     debugwriteln(getenumname(typeinfo(tupdatekind),ord(updatekind))+' '+str1);
 {$endif}  
     tsqlconnection(database).executedirect(str1,tsqltransaction(transaction));
    end;
   end;
  end
  else begin
  internalapplyrecupdate(updatekind);
  end;
 except
  include(fmstate,sqs_updateerror);
  raise;
 end;
end;

procedure tmsesqlquery.post;
begin
 if fcontroller.post and (dso_autoapply in fcontroller.options) then begin
  try
   applyupdates;
  except
   application.handleexception(self);
  end;
 end;
end;

procedure tmsesqlquery.afterapply;
begin
 if (dso_autocommitret in fcontroller.options) and (transaction <> nil) then begin
  tsqltransaction(transaction).commitretaining;
 end;
end;

procedure tmsesqlquery.applyupdates(const maxerrors: integer;
                const cancelonerror: boolean = false);
begin
 if not islocal then begin
  checkconnected;
 end;
 try
  fmstate:= fmstate - [sqs_updateabort,sqs_updateerror];
  inherited;
 finally
  if (sqs_updateerror in fmstate) and 
              (dso_cancelupdatesonerror in fcontroller.options) then begin
   cancelupdates;
  end;
 end;
end;

procedure tmsesqlquery.applyupdates(const maxerrors: integer = 0);
begin
 applyupdates(maxerrors,fcontroller.options *
      [dso_cancelupdateonerror,dso_cancelupdatesonerror] <> []);
end;

procedure tmsesqlquery.applyupdate;
begin
 if not islocal then begin
  checkconnected;
 end;
 inherited applyupdate(fcontroller.options *
      [dso_cancelupdateonerror,dso_cancelupdatesonerror] <> []);
end;
{
function tmsesqlquery.getreadonly: boolean;
begin
 result:= inherited readonly;
end;

function tmsesqlquery.getparsesql: boolean;
begin
 result:= inherited parsesql;
end;
}
{
procedure tmsesqlquery.setreadonly(const avalue: boolean);
begin
 checkinactive;
 fwantedreadonly:= avalue;
// if not avalue then begin
//  if not (inherited parsesql or assigned(fonapplyrecupdate)) then begin
//   databaseerrorfmt(snoparsesql,['Updating ']);
//  end;
 end;
 freadonly:= avalue;
end;
}
{
procedure tmsesqlquery.setparsesql(const avalue: boolean);
var
 bo1: boolean;
begin
 bo1:= inherited readonly;
 inherited parsesql:= avalue;
 if not bo1 and assigned(fonapplyrecupdate) then begin
  freadonly:= false;
 end;
end;
}
function tmsesqlquery.getfieldclass(fieldtype: tfieldtype): tfieldclass;
begin
 fcontroller.getfieldclass(fieldtype,result);
end;

procedure tmsesqlquery.cancel;
begin
 fcontroller.cancel;
end;

procedure tmsesqlquery.dataevent(event: tdataevent; info: ptrint);
begin
 fcontroller.dataevent(event,info);
end;

function tmsesqlquery.getcontroller: tdscontroller;
begin
 result:= fcontroller;
end;

procedure tmsesqlquery.inheriteddataevent(const event: tdataevent;
               const info: ptrint);
begin
 inherited dataevent(event,info);
end;

procedure tmsesqlquery.inheritedcancel;
begin
 inherited cancel;
end;

function tmsesqlquery.inheritedmoveby(const distance: integer): integer;
begin
 result:= inherited moveby(distance);
end;

function tmsesqlquery.moveby(const distance: integer): integer;
begin
 result:= fcontroller.moveby(distance);
end;

procedure tmsesqlquery.internalinsert;
begin
 fcontroller.internalinsert;
end;

procedure tmsesqlquery.inheritedinternalinsert;
begin
 inherited internalinsert;
end;

procedure tmsesqlquery.internaldelete;
begin
 fcontroller.internaldelete;
end;

procedure tmsesqlquery.inheritedinternaldelete;
begin
 inherited internaldelete;
end;

procedure tmsesqlquery.DoAfterDelete;
begin
 inherited;
 if dso_autoapply in fcontroller.options then begin
  applyupdates;
 end;
end;

function tmsesqlquery.getetstatementtype: TStatementType;
begin
 result:= inherited statementtype;
end;

procedure tmsesqlquery.setstatementtype(const avalue: TStatementType);
begin
 //dummy
end;

procedure tmsesqlquery.inheritedpost;
begin
 inherited post;
end;

function tmsesqlquery.isutf8: boolean;
begin
 result:= fcontroller.isutf8;
end;

function tmsesqlquery.wantblobfetch: boolean;
begin
 result:= (dso_cacheblobs in fcontroller.options);
end;

function tmsesqlquery.closetransactiononrefresh: boolean;
begin
 result:= (dso_refreshtransaction in fcontroller.options);
end;

function tmsesqlquery.islocal: boolean;
begin
 result:= dso_local in fcontroller.options;
end;

procedure tmsesqlquery.inheritedinternalclose;
begin
 inherited internalclose;
end;

procedure tmsesqlquery.internalclose;
begin
 fcontroller.internalclose;
end;

{ tparamsourcedatalink }

constructor tparamsourcedatalink.create(const aowner: tfieldparamlink);
begin
 fowner:= aowner;
 inherited create;
end;

procedure tparamsourcedatalink.recordchanged(afield: tfield);
var
 bo1: boolean;
begin
 if not (csloading in fowner.componentstate) then begin
  inherited;
  if active and (field <> nil) and
                ((afield = nil) or (afield = self.field)) then begin
   with fowner do begin
    if not (csdesigning in componentstate) then begin
     fparamset:= true;
     bo1:= false;
     if assigned(fonsetparam) then begin
      fonsetparam(fowner,bo1);
     end;
     if not bo1 and (fparamname <> '') and (dataset <> nil) then begin
      fieldtoparam(self.field,param);
     end;
     if assigned(fonaftersetparam) then begin
      fonaftersetparam(fowner);
     end;
     if (fplo_autorefresh in foptions) and (destdataset <> nil) and 
                          destdataset.active then begin
      destdataset.refresh;
//      destdataset.active:= false;
//      destdataset.active:= true;     
     end;
    end;
   end;
  end;
 end;
end;

procedure tparamsourcedatalink.loaded;
begin
 if not fparamset then begin
  recordchanged(nil);
 end;
end;

{ tfieldparamlink }

constructor tfieldparamlink.create(aowner: tcomponent);
begin
 foptions:= defaultfieldparamlinkoptions;
 fsourcedatalink:= tparamsourcedatalink.create(self);
 fdestdatasource:= tdatasource.create(nil);
 inherited;
end;

destructor tfieldparamlink.destroy;
begin
 inherited;
 fsourcedatalink.free;
 fdestdatasource.free;
end;

function tfieldparamlink.getdatafield: string;
begin
 result:= fsourcedatalink.fieldname;
end;

procedure tfieldparamlink.setdatafield(const avalue: string);
begin
 fsourcedatalink.fieldname:= avalue;
end;

function tfieldparamlink.getdatasource: tdatasource;
begin
 result:= fsourcedatalink.datasource;
end;

procedure tfieldparamlink.setdatasource(const avalue: tdatasource);
begin
 fsourcedatalink.datasource:= avalue;
end;

function tfieldparamlink.getvisualcontrol: boolean;
begin
 result:= fsourcedatalink.visualcontrol;
end;

procedure tfieldparamlink.setvisualcontrol(const avalue: boolean);
begin
 fsourcedatalink.visualcontrol:= avalue;
end;

function tfieldparamlink.getdestdataset: tsqlquery;
begin
 result:= tsqlquery(fdestdatasource.dataset);
end;

procedure tfieldparamlink.setdestdataset(const avalue: tsqlquery);
begin
 fdestdatasource.dataset:= avalue;
end;

function tfieldparamlink.param: tparam;
begin
 if fdestdatasource.dataset = nil then begin
  databaseerror(name+': No destdataset');
 end
 else begin
  result:= tsqlquery(fdestdatasource.dataset).params.findparam(fparamname);
  if result = nil then begin
   databaseerror(name+': param "'+fparamname+'" not found');
  end;
 end;
end;

function tfieldparamlink.field: tfield;
begin
 result:= fsourcedatalink.field;
end;

procedure tfieldparamlink.getfieldtypes(out propertynames: stringarty; 
                    out fieldtypes: fieldtypesarty);
begin
 propertynames:= nil;
 fieldtypes:= nil;
end;

procedure tfieldparamlink.loaded;
begin
 inherited;
 fsourcedatalink.loaded;
end;

function tfieldparamlink.getdatasource(const aindex: integer): tdatasource;
begin
 result:= datasource;
end;

{ tsequencedatalink }

constructor tsequencedatalink.create(const aowner: tsequencelink);
begin
 fowner:= aowner;
 inherited create;
end;

procedure tsequencedatalink.updatedata;
begin
 inherited;
 if (field <> nil) and field.isnull and (dataset <> nil) and 
                                               (dataset.modified) then begin
  if field is tlargeintfield then begin
   field.aslargeint:= fowner.aslargeint;
  end
  else begin
   field.asinteger:= fowner.asinteger;
  end;
 end;
end;

{ tsequencelink }

constructor tsequencelink.create(aowner: tcomponent);
begin
 fdatalink:= tsequencedatalink.create(self);
 inherited;
end;

destructor tsequencelink.destroy;
begin
 inherited;
 fdatalink.free;
end;

procedure tsequencelink.setdatabase(const avalue: tsqlconnection);
begin
 if fdatabase <> avalue then begin
  fdbintf:= nil;
  if fdatabase <> nil then begin
   fdatabase.removefreenotification(self);
  end;
  if avalue <> nil then begin
   avalue.freenotification(self);
   mseclasses.getcorbainterface(avalue,typeinfo(idbcontroller),fdbintf);
  end;
  fdatabase:= avalue;
 end;
end;

procedure tsequencelink.setsequencename(const avalue: string);
begin
 fsequencename:= avalue;
end;

procedure tsequencelink.notification(acomponent: tcomponent;
               operation: toperation);
begin
 inherited;
 if (acomponent = fdatabase) and (operation = opremove) then begin
  fdatabase:= nil;
 end;
end;

procedure tsequencelink.checkintf;
begin
 if fdbintf = nil then begin
  raise edatabaseerror.create('Database has no idscontroller interface.');
 end;
end;

function tsequencelink.getaslargeint: largeint;
var                       //todo: optimize
 ds1: tsqlquery;
begin
 checkintf;
 ds1:= tsqlquery.create(nil);
 try
  ds1.parsesql:= false;
  ds1.sql.add(fdbintf.readsequence(fsequencename));
  ds1.database:= fdatabase;
  ds1.active:= true;
  result:= ds1.fields[0].aslargeint;
 finally
  ds1.free;
 end;
end;

procedure tsequencelink.setaslargeint(const avalue: largeint);
begin
 checkintf;
 fdbintf.executedirect(
   fdbintf.writesequence(fsequencename,avalue));
end;

function tsequencelink.getasinteger: integer;
begin
 result:= getaslargeint;
end;

procedure tsequencelink.setasinteger(const avalue: integer);
begin
 setaslargeint(avalue); 
end;

function tsequencelink.getdatasource: tdatasource;
begin
 result:= fdatalink.datasource;
end;

procedure tsequencelink.setdatasource(const avalue: tdatasource);
begin
 fdatalink.datasource:= avalue;
 if (csdesigning in componentstate) and (fdatabase = nil) and 
      (fdatalink.dataset is tsqlquery) then begin
  database:= tsqlconnection(tsqlquery(fdatalink.dataset).database);
 end;
end;

function tsequencelink.getdatafield: string;
begin
 result:= fdatalink.fieldname;
end;

procedure tsequencelink.setdatafield(const avalue: string);
begin
 fdatalink.fieldname:= avalue;
end;

procedure tsequencelink.getfieldtypes(out propertynames: stringarty;
               out fieldtypes: fieldtypesarty);
begin
 propertynames:= nil;
 setlength(fieldtypes,1);
 fieldtypes[0]:= integerfields;
end;

function tsequencelink.assql: string;
begin
 result:= inttostr(aslargeint);
end;

function tsequencelink.getdatasource(const aindex: integer): tdatasource;
begin
 result:= datasource;
end;

end.

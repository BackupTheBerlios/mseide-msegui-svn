unit msedb;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface

uses
 classes,db,mseclasses,mseguiglob,msestrings,msetypes,msearrayprops,msegui,
 msestockobjects,sysutils;
 
type
 fieldtypesty = set of tfieldtype;
 fieldtypesarty = array of fieldtypesty;
const
 textfields = [ftstring,ftfixedchar,ftwidestring,ftmemo];
 memofields = textfields+[ftmemo];
 integerfields = [ftsmallint,ftinteger,ftword,ftlargeint,ftbcd];
 booleanfields = [ftboolean,ftstring,ftfixedchar]+integerfields-[ftbcd];
 realfields = [ftfloat,ftcurrency,ftbcd];
 datetimefields = [ftdate,fttime,ftdatetime];
 stringfields = textfields + integerfields + booleanfields +
                realfields + datetimefields;
 blobfields = [ftblob,ftmemo,ftgraphic,ftstring];
 defaultproviderflags = [pfInUpdate,pfInWhere];
 
type
 locateresultty = (loc_timeout,loc_notfound,loc_ok); 
 locateoptionty = (loo_caseinsensitive,loo_partialkey,
                        loo_noforeward,loo_nobackward);
 locateoptionsty = set of locateoptionty;
 fieldarty = array of tfield;

 imselocate = interface(inullinterface)['{2680958F-F954-DA11-9015-00C0CA1308FF}']
   function locate(const key: integer; const field: tfield;
                     const options: locateoptionsty = []): locateresultty;
   function locate(const key: string; const field: tfield; 
                 const options: locateoptionsty = []): locateresultty;
 end;
  
 idbeditinfo = interface(inullinterface)['{E63A9950-BFAE-DA11-83DF-00C0CA1308FF}']
  function getdatasource(const aindex: integer): tdatasource;
  procedure getfieldtypes(out apropertynames: stringarty;
                          out afieldtypes: fieldtypesarty);
    //propertynames = nil -> propertyname = 'datafield'
 end;

 ipersistentfieldsinfo = interface(inullinterface)
                   ['{A8493C65-34BB-DA11-9DCA-00C0CA1308FF}'] 
  function getfieldnames: stringarty;
 end;
 
  
 getdatasourcefuncty = function: tdatasource of object;
 
 tdbfieldnamearrayprop = class(tstringarrayprop,idbeditinfo)
  private
   ffieldtypes: fieldtypesty;
   fgetdatasource: getdatasourcefuncty;
  protected
   //idbeditinfo
   function getdatasource(const aindex: integer): tdatasource;
   procedure getfieldtypes(out apropertynames: stringarty;
                          out afieldtypes: fieldtypesarty);
  public
   constructor create(const afieldtypes: fieldtypesty;
                         const agetdatasource: getdatasourcefuncty);
   property fieldtypes: fieldtypesty read ffieldtypes write ffieldtypes;
 end;

 tactivatorcontroller = class(tlinkedpersistent)
  private
   factive: boolean;
   floaded: boolean;
   factivator: tactivator;
   procedure setactivator(const avalue: tactivator);
  protected
   fowner: tcomponent;
   function getinstance: tobject; override;
   procedure objectevent(const sender: tobject;
                          const event: objecteventty); override;
   procedure setowneractive(const avalue: boolean); virtual; abstract;
  public
   constructor create(const aowner: tcomponent); reintroduce;
   function setactive (const value : boolean): boolean;
   procedure loaded;
  published 
   property activator: tactivator read factivator write setactivator;
 end;

type
 tdscontroller = class;

 ifieldcomponent = interface;
  
 idsfieldcontroller = interface(inullinterface)
  function getcontroller: tdscontroller;
  procedure fielddestroyed(const sender: ifieldcomponent);
 end;
 
 ifieldcomponent = interface(inullinterface)['{81BB6312-74BA-4B50-963D-F1DB908F7FB7}']
  procedure setdsintf(const avalue: idsfieldcontroller);
  function getinstance: tfield;
 end;
  
 tmsefield = class(tfield)
  private
   function getasmsestring: msestring;
   procedure setasmsestring(const avalue: msestring);
  protected
   function HasParent: Boolean; override;
  public
   procedure Clear; override;
   property asmsestring: msestring read getasmsestring write setasmsestring;
  published
   property DataSet stored false;
   property ProviderFlags default defaultproviderflags;
 end;
 tmsestringfield = class(tstringfield,ifieldcomponent)
  private
   fdsintf: idsfieldcontroller;
   function getasmsestring: msestring;
   procedure setasmsestring(const avalue: msestring);
   //ifieldcomponent
   procedure setdsintf(const avalue: idsfieldcontroller);
   function getinstance: tfield;
  protected
   function HasParent: Boolean; override;
  public
   destructor destroy; override;
   procedure Clear; override;
   function assql: string;
   property asmsestring: msestring read getasmsestring write setasmsestring;
  published
   property DataSet stored false;
   property ProviderFlags default defaultproviderflags;
 end;
 tmsememofield = class(tmemofield,ifieldcomponent)
  private
   fdsintf: idsfieldcontroller;
   function getasmsestring: msestring;
   procedure setasmsestring(const avalue: msestring);
   //ifieldcomponent
   procedure setdsintf(const avalue: idsfieldcontroller);
   function getinstance: tfield;
  protected
   function HasParent: Boolean; override;
   property asmsestring: msestring read getasmsestring write setasmsestring;
  public
   destructor destroy; override;
   procedure Clear; override;
   function assql: string;
  published
   property DataSet stored false;
   property ProviderFlags default defaultproviderflags;
 end;
 tmsenumericfield = class(tnumericfield)
  private
   function getasmsestring: msestring;
   procedure setasmsestring(const avalue: msestring);
  protected
   function HasParent: Boolean; override;
  public
   procedure Clear; override;
   function assql: string;
   property asmsestring: msestring read getasmsestring write setasmsestring;
  published
   property DataSet stored false;
   property ProviderFlags default defaultproviderflags;
 end;
 tmselongintfield = class(tlongintfield)
  private
   function getasmsestring: msestring;
   procedure setasmsestring(const avalue: msestring);
   procedure setasenum(const avalue: integer);
  protected
   function HasParent: Boolean; override;
   function getasboolean: boolean; override;
   procedure setasboolean(avalue: boolean); override;
  public
   procedure Clear; override;
   function assql: string;
   property asmsestring: msestring read getasmsestring write setasmsestring;
   property asenum: integer read getaslongint write setasenum;
  published
   property DataSet stored false;
   property ProviderFlags default defaultproviderflags;
 end;
 tmselargeintfield = class(tlargeintfield)
  private
   function getasmsestring: msestring;
   procedure setasmsestring(const avalue: msestring);
  protected
   function HasParent: Boolean; override;
   function getasboolean: boolean; override;
   procedure setasboolean(avalue: boolean); override;
  public
   procedure Clear; override;
   function assql: string;
   property asmsestring: msestring read getasmsestring write setasmsestring;
  published
   property DataSet stored false;
   property ProviderFlags default defaultproviderflags;
 end;
 tmsesmallintfield = class(tsmallintfield)
  private
   function getasmsestring: msestring;
   procedure setasmsestring(const avalue: msestring);
  protected
   function HasParent: Boolean; override;
   function getasboolean: boolean; override;
   procedure setasboolean(avalue: boolean); override;
  public
   procedure Clear; override;
   function assql: string;
   property asmsestring: msestring read getasmsestring write setasmsestring;
  published
   property DataSet stored false;
   property ProviderFlags default defaultproviderflags;
 end;
 tmsewordfield = class(twordfield)
  private
   function getasmsestring: msestring;
   procedure setasmsestring(const avalue: msestring);
  protected
   function HasParent: Boolean; override;
   function getasboolean: boolean; override;
   procedure setasboolean(avalue: boolean); override;
  public
   procedure Clear; override;
   function assql: string;
   property asmsestring: msestring read getasmsestring write setasmsestring;
  published
   property DataSet stored false;
   property ProviderFlags default defaultproviderflags;
 end;
 tmseautoincfield = class(tautoincfield)
  private
   function getasmsestring: msestring;
   procedure setasmsestring(const avalue: msestring);
  protected
   function HasParent: Boolean; override;
  public
   procedure Clear; override;
   function assql: string;
   property asmsestring: msestring read getasmsestring write setasmsestring;
  published
   property DataSet stored false;
   property ProviderFlags default defaultproviderflags;
 end;
 tmsefloatfield = class(tfloatfield)
  private
   function getasmsestring: msestring;
   procedure setasmsestring(const avalue: msestring);
  protected
   function HasParent: Boolean; override;
   function getasfloat: double; override;
   procedure setasfloat(avalue: double); override;
  public
   procedure Clear; override;
   function assql: string;
   property asmsestring: msestring read getasmsestring write setasmsestring;
  published
   property DataSet stored false;
   property ProviderFlags default defaultproviderflags;
 end;
 tmsecurrencyfield = class(tcurrencyfield)
  private
   function getasmsestring: msestring;
   procedure setasmsestring(const avalue: msestring);
  protected
   function HasParent: Boolean; override;
  public
   procedure Clear; override;
   function assql: string;
   property asmsestring: msestring read getasmsestring write setasmsestring;
  published
   property DataSet stored false;
   property ProviderFlags default defaultproviderflags;
 end;
 tmsebooleanfield = class(tbooleanfield)
  private
   fdisplayvalues: msestring;
   fdisplays : array[boolean,boolean] of msestring;
   procedure setdisplayvalues(const avalue: msestring);
   function getasmsestring: msestring;
   procedure setasmsestring(const avalue: msestring);
  protected
   function HasParent: Boolean; override;
   function getasstring: string; override;
   procedure setasstring(const avalue: string); override;
   function GetDefaultWidth: Longint; override;
  public
   constructor Create(AOwner: TComponent); override;
   procedure Clear; override;
   function assql: string;
   property asmsestring: msestring read getasmsestring write setasmsestring;
  published
   property DataSet stored false;
   property ProviderFlags default defaultproviderflags;
   property displayvalues: msestring read fdisplayvalues write setdisplayvalues;
 end;
 tmsedatetimefield = class(tdatetimefield)
  private
   function getasmsestring: msestring;
   procedure setasmsestring(const avalue: msestring);
  protected
   function HasParent: Boolean; override;
   function getasdatetime: tdatetime; override;
   procedure setasdatetime(avalue: tdatetime); override;
  public
   procedure Clear; override;
   function assql: string;
   property asmsestring: msestring read getasmsestring write setasmsestring;
  published
   property DataSet stored false;
   property ProviderFlags default defaultproviderflags;
 end;
 tmsedatefield = class(tdatefield)
  private
   function getasmsestring: msestring;
   procedure setasmsestring(const avalue: msestring);
  protected
   function getasdatetime: tdatetime; override;
   procedure setasdatetime(avalue: tdatetime); override;
   function HasParent: Boolean; override;
  public
   procedure Clear; override;
   function assql: string;
   property asmsestring: msestring read getasmsestring write setasmsestring;
  published
   property DataSet stored false;
   property ProviderFlags default defaultproviderflags;
 end;
 tmsetimefield = class(ttimefield)
  private
   function getasmsestring: msestring;
   procedure setasmsestring(const avalue: msestring);
  protected
   function getasdatetime: tdatetime; override;
   procedure setasdatetime(avalue: tdatetime); override;
   function HasParent: Boolean; override;
  public
   procedure Clear; override;
   function assql: string;
   property asmsestring: msestring read getasmsestring write setasmsestring;
  published
   property DataSet stored false;
   property ProviderFlags default defaultproviderflags;
 end;
 tmsebinaryfield = class(tbinaryfield)
  private
   function getasmsestring: msestring;
   procedure setasmsestring(const avalue: msestring);
  protected
   function HasParent: Boolean; override;
  public
   procedure Clear; override;
   function assql: string;
   property asmsestring: msestring read getasmsestring write setasmsestring;
  published
   property DataSet stored false;
   property ProviderFlags default defaultproviderflags;
 end;
 tmsebytesfield = class(tbytesfield)
  private
   function getasmsestring: msestring;
   procedure setasmsestring(const avalue: msestring);
  protected
   function HasParent: Boolean; override;
  public
   procedure Clear; override;
   function assql: string;
   property asmsestring: msestring read getasmsestring write setasmsestring;
  published
   property DataSet stored false;
   property ProviderFlags default defaultproviderflags;
 end;
 tmsevarbytesfield = class(tvarbytesfield)
  private
   function getasmsestring: msestring;
   procedure setasmsestring(const avalue: msestring);
  protected
   function HasParent: Boolean; override;
  public
   procedure Clear; override;
   function assql: string;
   property asmsestring: msestring read getasmsestring write setasmsestring;
  published
   property DataSet stored false;
   property ProviderFlags default defaultproviderflags;
 end;
 tmsebcdfield = class(tbcdfield)
  private
   function getasmsestring: msestring;
   procedure setasmsestring(const avalue: msestring);
  protected
   function HasParent: Boolean; override;
  public
   procedure Clear; override;
   function assql: string;
   property asmsestring: msestring read getasmsestring write setasmsestring;
  published
   property DataSet stored false;
   property ProviderFlags default defaultproviderflags;
 end;
 tmseblobfield = class(tblobfield)
  private
   function getasmsestring: msestring;
   procedure setasmsestring(const avalue: msestring);
  protected
   function HasParent: Boolean; override;
  public
//   procedure Clear; override;
   function assql: string;
   property asmsestring: msestring read getasmsestring write setasmsestring;
   procedure LoadFromFile(const FileName: filenamety);
   procedure SaveToFile(const FileName: filenamety);
  published
   property DataSet stored false;
   property ProviderFlags default defaultproviderflags;
 end;
 tmsegraphicfield = class(tmseblobfield)
  private
   fformat: string;
  protected
  public
  published
   property format: string read fformat write fformat;
 end;

 tmsedatalink = class(tdatalink)
  private
  protected
   fdscontroller: tdscontroller;
   procedure activechanged; override;
   function getdataset: tdataset;
   function getutf8: boolean;
   function  GetActiveRecord: Integer; override;
  public
   function moveby(distance: integer): integer; override;
   property dataset: tdataset read getdataset;
   property dscontroller: tdscontroller read fdscontroller;
   property utf8: boolean read getutf8;
 end;

 tfielddatalink = class(tmsedatalink)
  private
   ffield: tfield;
   ffieldname: string;
   procedure setfieldname(const Value: string);
   procedure updatefield;
   function getasmsestring: msestring;
   procedure setasmsestring(const avalue: msestring);
   procedure checkfield;
   function GetAsBoolean: Boolean;
   procedure SetAsBoolean(const avalue: Boolean);
   function GetAsCurrency: Currency;
   procedure SetAsCurrency(const avalue: Currency);
   function GetAsDateTime: TDateTime;
   procedure SetAsDateTime(const avalue: TDateTime);
   function GetAsFloat: Double;
   procedure SetAsFloat(const avalue: Double);
   function GetAsLongint: Longint;
   procedure SetAsLongint(const avalue: Longint);
   function GetAsLargeInt: LargeInt;
   procedure SetAsLargeInt(const avalue: LargeInt);
   function GetAsInteger: Integer;
   procedure SetAsInteger(const avalue: Integer);
   function GetAsString: string;
   procedure SetAsString(const avalue: string);
   function GetAsVariant: variant;
   procedure SetAsVariant(const avalue: variant);
  protected
   procedure setfield(const value: tfield); virtual;
   procedure activechanged; override;
   procedure layoutchanged; override;
  public
   function assql: string;
   property field: tfield read ffield;
   property fieldname: string read ffieldname write setfieldname;
   
   property AsBoolean: Boolean read GetAsBoolean write SetAsBoolean;
   property AsCurrency: Currency read GetAsCurrency write SetAsCurrency;
   property AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
   property AsFloat: Double read GetAsFloat write SetAsFloat;
   property AsLongint: Longint read GetAsLongint write SetAsLongint;
   property AsLargeInt: LargeInt read GetAsLargeInt write SetAsLargeInt;
   property AsInteger: Integer read GetAsInteger write SetAsInteger;
   property AsString: string read GetAsString write SetAsString;
   property AsVariant: variant read GetAsVariant write SetAsVariant;
   property asmsestring: msestring read getasmsestring write setasmsestring;
   function msedisplaytext: msestring;
 end;
 
 fieldarrayty = array of tfield;
 
 fieldclassty = class of tfield;
 
 fieldclasstypety = (ft_unknown,ft_string,ft_numeric,
                     ft_longint,ft_largeint,ft_smallint,
                     ft_word,ft_autoinc,ft_float,ft_currency,ft_boolean,
                     ft_datetime,ft_date,ft_time,
                     ft_binary,ft_bytes,ft_varbytes,
                     ft_bcd,ft_blob,ft_memo,ft_graphic);
 fieldclasstypearty = array of fieldclasstypety; 
        
 tmsedatasource = class(tdatasource)
  protected
   Procedure DoDataChange (Info : Pointer); override;
   Procedure DoStateChange; override;
 end;
 
 tpersistentfields = class(tpersistentarrayprop,ipersistentfieldsinfo)
  private
   fdataset: tdataset;
   procedure readfields(reader: treader);
   procedure writefields(writer: twriter);
   procedure setitems(const index: integer; const avalue: tfield);
   function getitems(const index: integer): tfield;
  protected
   procedure createitem(const index: integer; out item: tpersistent); override;
   procedure defineproperties(filer: tfiler); override;
  public
   constructor create(const adataset: tdataset);
   procedure move(const curindex,newindex: integer); override;
   procedure updateorder;
   function getfieldnames: stringarty;
   property dataset: tdataset read fdataset;
   property items[const index: integer]: tfield read getitems write setitems; default;
 end;

 idscontroller = interface(inullinterface)
  procedure inheriteddataevent(const event: tdataevent; const info: ptrint);
  procedure inheritedcancel;
  procedure inheritedpost;
  function inheritedmoveby(const distance: integer): integer;
  procedure inheritedinternalinsert;
  procedure inheritedinternalopen;
 end;

 igetdscontroller = interface(inullinterface)
             ['{0BF9F81D-D420-44FB-AE1C-0343C823CB95}']
  function getcontroller: tdscontroller;
 end;

 datasetoptionty = (dso_utf8,dso_cancelupdateonerror,dso_cancelupdatesonerror,
                         dso_autoapply,dso_autocommitret);
 datasetoptionsty = set of datasetoptionty;
 
const
 defaultdscontrolleroptions = [];
 
type
 fieldlinkarty = array of ifieldcomponent;
 dscontrollerstatety = (dscs_posting);
 dscontrollerstatesty = set of dscontrollerstatety;
 
 tdscontroller = class(tactivatorcontroller,idsfieldcontroller)
  private
   ffields: tpersistentfields;
   fintf: idscontroller;
   fneedsrefresh: integer;
   frecno: integer;
   frecnovalid: boolean;
   fscrollsum: integer;
   factiverecordbefore: integer;
   frecnooffset: integer;
   fmovebylock: boolean;
   fcancelresync: boolean;
   finsertbm: string;
   flinkedfields: fieldlinkarty;
   foptions: datasetoptionsty;
   fstate: dscontrollerstatesty;
   procedure setfields(const avalue: tpersistentfields);
   function getcontroller: tdscontroller;
   procedure updatelinkedfields;
   function getrecnonullbased: integer;
   procedure setrecnonullbased(const avalue: integer);
   function getrecno: integer;
   procedure setrecno(const avalue: integer);
  protected
   procedure setowneractive(const avalue: boolean); override;
   procedure fielddestroyed(const sender: ifieldcomponent);
  public
   constructor create(const aowner: tdataset; const aintf: idscontroller;
                      const arecnooffset: integer = 0;
                      const acancelresync: boolean = true);
   destructor destroy; override;
   function locate(const key: integer; const field: tfield;
                       const options: locateoptionsty = []): locateresultty;
                       overload;
   function locate(const key: msestring; const field: tfield; 
                 const options: locateoptionsty = []): locateresultty; overload;
   procedure appendrecord(const values: array of const);
   procedure getfieldclass(const fieldtype: tfieldtype; out result: tfieldclass);
   
   procedure dataevent(const event: tdataevent; const info: ptrint);
   procedure cancel;
   property recno: integer read getrecno write setrecno;
   property recnonullbased: integer read getrecnonullbased 
                                       write setrecnonullbased;
   property recnooffset: integer read frecnooffset;
   function moveby(const distance: integer): integer;
   procedure internalinsert;
   procedure internalopen;
   procedure closequery(var amodalresult: modalresultty);
   procedure post; //calls post if in edit or insert state
   function posting: boolean; //true if in post procedure
   function emptyinsert: boolean;
   function assql(const avalue: msestring): string; overload;
   function assql(const avalue: integer): string; overload;
   function assql(const avalue: realty): string; overload;
   function assql(const avalue: tdatetime): string; overload;
   function assqldate(const avalue: tdatetime): string;
   function assqltime(const avalue: tdatetime): string;
  published
   property fields: tpersistentfields read ffields write setfields;
   property options: datasetoptionsty read foptions write foptions 
                   default defaultdscontrolleroptions;
 end;
 
 ttacontroller = class(tactivatorcontroller)
  protected
   procedure setowneractive(const avalue: boolean); override;
  public
   constructor create(const aowner: tdbtransaction);
 end;

 idbcontroller = interface(inullinterface)
          ['{B26D004A-7FEE-44F2-9919-3B8612BDD598}']
  function readsequence(const sequencename: string): string;
  function writesequence(const sequencename: string;
                    const avalue: largeint): string;
  procedure ExecuteDirect(SQL : String);
 end;

 databaseeventty = procedure(const sender: tdatabase) of object;
 databaseerroreventty = procedure(const sender: tdatabase;
             const aexception: exception; var handled: boolean) of object;
 
 tdbcontroller = class(tactivatorcontroller)
  private
   fdatabasename: filenamety;
   fintf: idbcontroller;
   fonbeforeconnect: databaseeventty;
   fonconnecterror: databaseerroreventty;
  protected
   procedure setowneractive(const avalue: boolean); override;
  public
   constructor create(const aowner: tdatabase; const aintf: idbcontroller);
   function getdatabasename: filenamety;
   procedure setdatabasename(const avalue: filenamety);
  published
   property onbeforeconnect: databaseeventty read fonbeforeconnect 
                                   write fonbeforeconnect;  
   property onconnecterror: databaseerroreventty read fonconnecterror 
                                   write fonconnecterror; 
 end;
  
 tfieldlink = class;
 
 tfieldlinkdatalink = class(tfielddatalink)
  private
   fdatasource: tdatasource;
   fowner: tfieldlink;
  protected
   procedure updatedata; override;
  public
   constructor create(const aowner: tfieldlink);
   destructor destroy; override;
 end;

 fieldeventty = procedure(const afield: tfield) of object;
 
 fieldlinkoptionty = (flo_onlyifnull);
 fieldlinkoptionsty = set of fieldlinkoptionty;
  
 tfieldlink = class(tmsecomponent,idbeditinfo)
  private
   fdestdatalink: tfieldlinkdatalink;
   fonupdatedata: fieldeventty;
   foptions: fieldlinkoptionsty;
   function getdataset: tdataset;
   procedure setdataset(const avalue: tdataset);
   function getdatafield: string;
   procedure setdatafield(const avalue: string);
   //idbeditinfo
   procedure getfieldtypes(out propertynames: stringarty;
                          out fieldtypes: fieldtypesarty);
   function getdatasource(const aindex: integer): tdatasource;
  protected
   procedure updatedata(const afield: tfield); virtual;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   function field: tfield;
  published
   property dataset: tdataset read getdataset write setdataset;
   property datafield: string read getdatafield write setdatafield;
   property options: fieldlinkoptionsty read foptions write foptions default [];
   property onupdatedata: fieldeventty read fonupdatedata write fonupdatedata;
 end;
 
 ttimestampfieldlink = class(tfieldlink)
  protected
   procedure updatedata(const afield: tfield); override;
 end;
   
 tfieldfieldlink = class(tfieldlink,idbeditinfo)
  private
   fsourcedatalink: tfielddatalink;
   function getsourcedatafield: string;
   procedure setsourcedatafield(const avalue: string);
   function getdatasource: tdatasource; overload;
   function getdatasource(const aindex: integer): tdatasource; overload;
   procedure setdatasource(const avalue: tdatasource);
   //idbeditinfo
   procedure getfieldtypes(out propertynames: stringarty;
                          out fieldtypes: fieldtypesarty);
  protected
   procedure updatedata(const afield: tfield); override;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   function sourcefield: tfield;
  published
   property sourcedatafield: string read getsourcedatafield 
                             write setsourcedatafield;
   property datasource: tdatasource read getdatasource write setdatasource;
 end;
 
const
 fieldtypeclasses: array[fieldclasstypety] of fieldclassty = 
          (tfield,tstringfield,tnumericfield,
           tlongintfield,tlargeintfield,tsmallintfield,
           twordfield,tautoincfield,tfloatfield,tcurrencyfield,
           tbooleanfield,
           tdatetimefield,tdatefield,ttimefield,
           tbinaryfield,tbytesfield,tvarbytesfield,
           tbcdfield,tblobfield,tmemofield,tgraphicfield);

 msefieldtypeclasses: array[fieldclasstypety] of fieldclassty = 
          (tmsefield,tmsestringfield,tmsenumericfield,
           tmselongintfield,tmselargeintfield,tmsesmallintfield,
           tmsewordfield,tmseautoincfield,tmsefloatfield,tmsecurrencyfield,
           tmsebooleanfield,
           tmsedatetimefield,tmsedatefield,tmsetimefield,
           tmsebinaryfield,tmsebytesfield,tmsevarbytesfield,
           tmsebcdfield,tmseblobfield,tmsememofield,tmsegraphicfield);
           
 tfieldtypetotypety: array[tfieldtype] of fieldclasstypety = (
    //ftUnknown, ftString, ftSmallint, ftInteger, ftWord,
      ft_unknown,ft_string,ft_smallint,ft_longint,ft_word,
    //ftBoolean, ftFloat, ftCurrency, ftBCD, ftDate,  ftTime, ftDateTime,
      ft_boolean,ft_float,ft_currency,ft_bcd,ft_date,ft_time,ft_datetime,
    //ftBytes, ftVarBytes, ftAutoInc, ftBlob, ftMemo, ftGraphic, ftFmtMemo,
      ft_bytes,ft_varbytes,ft_autoinc,ft_blob,ft_memo,ft_graphic,ft_memo,
    //ftParadoxOle, ftDBaseOle, ftTypedBinary, ftCursor, ftFixedChar,
      ft_unknown,ft_unknown,ft_unknown,ft_unknown,ft_string,
    //ftWideString, ftLargeint, ftADT, ftArray, ftReference,
      ft_unknown,ft_largeint,ft_unknown,ft_unknown,ft_unknown,
    //ftDataSet, ftOraBlob, ftOraClob, ftVariant, ftInterface,
      ft_unknown,ft_unknown,ft_unknown,ft_unknown,ft_unknown,
    //ftIDispatch, ftGuid, ftTimeStamp, ftFMTBcd);
      ft_unknown,ft_unknown,ft_unknown,ft_unknown
      );

 realfcomp = [ftfloat,ftcurrency];
 datetimefcomp = [ftdate,fttime,ftdatetime];
 blobfcomp = [ftblob,ftgraphic,ftmemo];
 memofcomp = [ftmemo];
 longintfcomp = [ftsmallint,ftinteger,ftword];
 stringfcomp = [ftstring,ftfixedchar];
      
 fieldcompatibility: array[tfieldtype] of fieldtypesty = (
    //ftUnknown, ftString,    ftSmallint,    ftInteger,     ftWord,
      [ftunknown],stringfcomp,longintfcomp,longintfcomp,longintfcomp,
    //ftBoolean,   ftFloat, ftCurrency, ftBCD,
      [ftboolean],realfcomp,realfcomp,[ftbcd],
    //ftDate,        ftTime,       tDateTime,
      datetimefcomp,datetimefcomp,datetimefcomp,
    //ftBytes, ftVarBytes, ftAutoInc,
      [ftbytes],[ftvarbytes],[ftautoinc],
    // ftBlob, ftMemo, ftGraphic, ftFmtMemo,
      blobfcomp,memofcomp,blobfcomp,memofcomp,
    //ftParadoxOle, ftDBaseOle, ftTypedBinary,     ftCursor, tFixedChar,
      [ftParadoxOle],[ftDBaseOle],[ftTypedBinary],[ftCursor],stringfcomp,
    //ftWideString, ftLargeint, ftADT, ftArray, ftReference,
     [ftWideString],[ftLargeint],[ftADT],[ftArray],[ftReference],
    //ftDataSet, ftOraBlob, ftOraClob, ftVariant, ftInterface,
      [ftDataSet],[ftOraBlob],[ftOraClob],[ftVariant],[ftInterface],
    //ftIDispatch, ftGuid, ftTimeStamp, ftFMTBcd);
      [ftIDispatch],[ftGuid],[ftTimeStamp],[ftFMTBcd]
      );
      
function fieldclasstoclasstyp(const fieldclass: fieldclassty): fieldclasstypety;
function fieldtosql(const field: tfield): string;
function fieldtooldsql(const field: tfield): string;
function fieldchanged(const field: tfield): boolean;
procedure fieldtoparam(const field: tfield; const param: tparam);
procedure msestringtoparam(const avalue: msestring; const param: tparam);
//function getasmsestring(const field: tfield): msestring;
function getasmsestring(const field: tfield; const utf8: boolean): msestring;
function checkfieldcompatibility(const afield: tfield;
                     const adatatype: tfieldtype): boolean;
           //true if ok
function vartorealty(const avalue: variant): realty;

implementation
uses
 rtlconsts,msefileutils,typinfo,dbconst,msedatalist,mseformatstr,
 msereal,variants;
type
 tdataset1 = class(tdataset);
{
function getasmsestring(const field: tfield): msestring;
begin
 if field is tmsestringfield then begin
  result:= tmsestringfield(field).asmsestring;
 end
 else begin
  if field is tmsememofield then begin
   result:= tmsememofield(field).asmsestring;
  end
  else begin
   result:= field.asstring;
  end;
 end;
end;
}
function getasmsestring(const field: tfield; const utf8: boolean): msestring;
begin
 if utf8 then begin
  result:= utf8tostring(field.asstring);
 end
 else begin
  result:= field.asstring;
 end;
end;

procedure msestringtoparam(const avalue: msestring; const param: tparam);
var
 intf1: igetdscontroller;
begin
 with param do begin
  if dataset <> nil then begin
   if getcorbainterface(dataset,typeinfo(igetdscontroller),intf1) then begin
    if dso_utf8 in intf1.getcontroller.options then begin
     param.asstring:= stringtoutf8(avalue);
     exit;
    end;
   end;
  end;
  param.asstring:= avalue;
 end;
end;

procedure fieldtoparam(const field: tfield; const param: tparam);
begin
 param.value:= field.value; //paramvalue is variant anyway
 {
 with param do begin
  case field.datatype of
   ftUnknown:  DatabaseErrorFmt(SUnknownParamFieldType,[Name],DataSet);
      // Need TField.AsSmallInt
   ftSmallint: AsSmallInt:= Field.AsInteger;
      // Need TField.AsWord
   ftWord:     AsWord:= Field.AsInteger;
   ftInteger,
   ftAutoInc:  AsInteger:= Field.AsInteger;
      // Need TField.AsCurrency
   ftCurrency: AsCurrency:= Field.asFloat;
   ftFloat:    AsFloat:= Field.asFloat;
   ftBoolean:  AsBoolean:= Field.AsBoolean;
   ftBlob,
   ftGraphic..ftTypedBinary,
   ftOraBlob,
   ftOraClob,
   ftString,
   ftMemo,
   ftAdt,
   ftFixedChar: AsString:= Field.AsString;
   ftTime,
   ftDate,
   ftDateTime: AsDateTime:= Field.AsDateTime;
   ftBytes,
   ftVarBytes: ; // Todo.
   else begin
    if not (DataType in [ftCursor, ftArray, ftDataset,ftReference]) then begin
        DatabaseErrorFmt(SBadParamFieldType, [Name], DataSet);
    end;
   end;
  end;
 end;
 }
end;

function encodesqlstring(const avalue: string): string;
var
 int1: integer;
 str1: string;
 po1: pchar;
begin
 str1:= avalue;
 setlength(result,length(str1)*2 + 2); //max
 po1:= pchar(result);
 po1^:= '''';
 inc(po1);
 for int1:= 1 to length(str1) do begin
  po1^:= str1[int1];
  if po1^ = '''' then begin
   inc(po1);
   po1^:= '''';
  end;
  inc(po1);
 end;
 po1^:= '''';
 setlength(result,po1-pchar(result)+1);
end;

function encodesqldatetime(const avalue: tdatetime): string;
begin
 result := '''' + formatdatetime('yyyy-mm-dd hh:mm:ss',avalue) + '''';
end;

function encodesqldate(const avalue: tdatetime): string;
begin
 result:= '''' + formatdatetime('yyyy-mm-dd',avalue) + '''';
end;

function encodesqltime(const avalue: tdatetime): string;
begin
 result:= '''' + formatdatetime('hh:mm:ss',avalue) + '''';
end;

function encodesqlfloat(const avalue: real): string;
begin
 result:= formatfloatmse(avalue,'');
end;

function encodesqlcurrency(const avalue: currency): string;
begin
 result:= formatfloatmse(avalue,'0.####');
end;

function encodesqlboolean(const avalue: boolean): string;
begin
 if avalue then begin
  result:= '''t''';
 end
 else begin
  result:= '''f''';
 end;
end;

function fieldtosql(const field: tfield): string;
begin
 if (field = nil) or field.isnull then begin
  result:= 'NULL'
 end
 else begin
  case field.datatype of
   ftstring,ftmemo: begin
    result:= encodesqlstring(field.asstring);
   end;
   ftdate: begin
    result := encodesqldate(field.asdatetime)
   end;
   fttime: begin
    result := encodesqltime(field.asdatetime)
   end;
   ftdatetime: begin
    result:= encodesqldatetime(field.asdatetime);
   end;
   ftfloat: begin
    result:= encodesqlfloat(field.asfloat);
   end;
   ftbcd: begin
    result:= encodesqlcurrency(field.ascurrency);
   end;
   ftboolean: begin
    result:= encodesqlboolean(field.asboolean);
   end;
   else begin
    result := field.asstring;
   end;
  end;
 end;
end;

function fieldtooldsql(const field: tfield): string;
var
 statebefore: tdatasetstate;
begin
 statebefore:= field.dataset.state;
 tdataset1(field.dataset).settempstate(dsoldvalue);
 result:= fieldtosql(field);
 tdataset1(field.dataset).restorestate(statebefore);
end;
 
function fieldchanged(const field: tfield): boolean;
      //todo: fast compare in tbufdataset
var
 statebefore: tdatasetstate;
 isnull: boolean;
 ds1: tdataset1;
 int1: integer;
 bo1: boolean;
 str1: string;
 wstr1: widestring;
 rea1: real;
 int641: int64;
begin
 result:= false;
 if field.fieldno > 0 then begin
  ds1:= tdataset1(field.dataset);
  statebefore:= ds1.state;
  isnull:= field.isnull;
  case field.datatype of
   ftString,ftFixedChar: begin
    str1:= field.asstring;
    ds1.settempstate(dsoldvalue); 
    result:= (field.isnull xor isnull) or (str1 <> field.asstring);
   end;
   ftSmallint,ftInteger,ftWord: begin
    int1:= field.asinteger;
    ds1.settempstate(dsoldvalue); 
    result:= (field.isnull xor isnull) or (int1 <> field.asinteger);
   end;
   ftBoolean: begin
    bo1:= field.asboolean;
    ds1.settempstate(dsoldvalue); 
    result:= (field.isnull xor isnull) or (bo1 <> field.asboolean);
   end; 
   ftFloat,ftCurrency,ftBCD,ftDate,ftTime,ftDateTime,ftTimeStamp,ftFMTBcd: begin
    rea1:= field.asfloat;
    ds1.settempstate(dsoldvalue); 
    result:= (field.isnull xor isnull) or (rea1 <> field.asfloat);
   end;
//    ftBytes, ftVarBytes, ftAutoInc, ftBlob, ftMemo, ftGraphic, ftFmtMemo,
//    ftParadoxOle, ftDBaseOle, ftTypedBinary, ftCursor, 
   ftWideString: begin
//    wstr1:= field.aswidestring;
    wstr1:= field.asstring;
    ds1.settempstate(dsoldvalue); 
//    result:= (field.isnull xor isnull) or (wstr1 <> field.aswidestring);
    result:= (field.isnull xor isnull) or (wstr1 <> field.asstring);
   end;
   ftLargeint: begin
    int641:= tlargeintfield(field).aslargeint;
    ds1.settempstate(dsoldvalue); 
    result:= (field.isnull xor isnull) or 
                (int641 <> tlargeintfield(field).aslargeint);
   end;
//    ftADT, ftArray, ftReference,
//    ftDataSet, ftOraBlob, ftOraClob, ftVariant, ftInterface,
//    ftIDispatch, ftGuid, ftTimeStamp, ftFMTBcd);

  end;
  ds1.restorestate(statebefore); 
 end;
end;

function fieldclasstoclasstyp(const fieldclass: fieldclassty): fieldclasstypety;
var
 type1: fieldclasstypety;
begin
 result:= fieldclasstypety(-1);
 for type1:= low(fieldclasstypety) to high(fieldclasstypety) do begin
  if fieldclass = fieldtypeclasses[type1]  then begin
   result:= type1;
   break;
  end;
 end;
 if ord(result) = -1 then begin
  result:= ft_unknown;
  for type1:= low(fieldclasstypety) to high(fieldclasstypety) do begin
   if fieldclass = msefieldtypeclasses[type1]  then begin
    result:= type1;
    break;
   end;
  end;
 end;
end;

function checkfieldcompatibility(const afield: tfield;
                     const adatatype: tfieldtype): boolean;
           //true if ok
begin
 result:= (afield.datatype in fieldcompatibility[adatatype]) or 
                            (adatatype = ftunknown);
end;

function vartorealty(const avalue: variant): realty;
begin
 if varisnull(avalue) then begin
  result:= emptyreal;
 end
 else begin
  real(result):= avalue;
 end;
end;

procedure fieldsetmsestring(const avalue: msestring; const sender: tfield;
                                   const aintf: idsfieldcontroller);
begin
 if (aintf <> nil) and (dso_utf8 in aintf.getcontroller.options) then begin
  sender.asstring:= stringtoutf8(avalue);
 end
 else begin
  sender.asstring:= avalue; //locale conversion
 end; 
end;

function fieldgetmsestring(const sender: tfield;
                      const aintf: idsfieldcontroller): msestring;
begin
 if (aintf <> nil) and (dso_utf8 in aintf.getcontroller.options) then begin
  result:= utf8tostring(sender.asstring);
 end
 else begin
  result:= sender.asstring;
 end;
end;

{ tmsefield }

function tmsefield.HasParent: Boolean;
begin
 result:= dataset <> nil;
end;

procedure tmsefield.setasmsestring(const avalue: msestring);
begin
 asstring:= avalue;
end;

function tmsefield.getasmsestring: msestring;
begin
 result:= asstring;
end;

procedure tmsefield.Clear;
begin
 setdata(nil);
end;

{ tmsestringfield }

destructor tmsestringfield.destroy;
begin
 if fdsintf <> nil then begin
  fdsintf.fielddestroyed(ifieldcomponent(self));
 end;
 inherited;
end;

function tmsestringfield.HasParent: Boolean;
begin
 result:= dataset <> nil;
end;

function tmsestringfield.assql: string;
begin
 result:= fieldtosql(self);
{
 if isnull then begin
  result:= 'NULL';
 end
 else begin
  result:= ''''+asstring+'''';
 end;
 }
end;

function tmsestringfield.getasmsestring: msestring;
begin
 result:= fieldgetmsestring(self,fdsintf);
end;

procedure tmsestringfield.setasmsestring(const avalue: msestring);
begin
 fieldsetmsestring(avalue,self,fdsintf);
end;

procedure tmsestringfield.setdsintf(const avalue: idsfieldcontroller);
begin
 fdsintf:= avalue;
end;

function tmsestringfield.getinstance: tfield;
begin
 result:= self;
end;

procedure tmsestringfield.Clear;
begin
 setdata(nil);
end;

{ tmsememofield }

destructor tmsememofield.destroy;
begin
 if fdsintf <> nil then begin
  fdsintf.fielddestroyed(ifieldcomponent(self));
 end;
 inherited;
end;

function tmsememofield.HasParent: Boolean;
begin
 result:= dataset <> nil;
end;

function tmsememofield.assql: string;
begin
 result:= fieldtosql(self);
end;

function tmsememofield.getasmsestring: msestring;
begin
 result:= fieldgetmsestring(self,fdsintf);
end;

procedure tmsememofield.setasmsestring(const avalue: msestring);
begin
 fieldsetmsestring(avalue,self,fdsintf);
end;

procedure tmsememofield.setdsintf(const avalue: idsfieldcontroller);
begin
 fdsintf:= avalue;
end;

function tmsememofield.getinstance: tfield;
begin
 result:= self;
end;

procedure tmsememofield.Clear;
begin
 setdata(nil);
end;

{ tmsenumericfield }

function tmsenumericfield.HasParent: Boolean;
begin
 result:= dataset <> nil;
end;

function tmsenumericfield.assql: string;
begin
 result:= fieldtosql(self);
end;

procedure tmsenumericfield.setasmsestring(const avalue: msestring);
begin
 asstring:= value;
end;

function tmsenumericfield.getasmsestring: msestring;
begin
 result:= asstring;
end;

procedure tmsenumericfield.Clear;
begin
 setdata(nil);
end;

{ tmselongintfield }

function tmselongintfield.HasParent: Boolean;
begin
 result:= dataset <> nil;
end;

function tmselongintfield.assql: string;
begin
 result:= fieldtosql(self);
end;

procedure tmselongintfield.setasmsestring(const avalue: msestring);
begin
 asstring:= avalue;
end;

function tmselongintfield.getasmsestring: msestring;
begin
 result:= asstring;
end;

function tmselongintfield.getasboolean: boolean;
begin
 result:= asinteger <> 0;
end;

procedure tmselongintfield.setasboolean(avalue: boolean);
begin
 if avalue then begin
  asinteger:= 1;
 end
 else begin
  asinteger:= 0;
 end;
end;

procedure tmselongintfield.Clear;
begin
 setdata(nil);
end;

procedure tmselongintfield.setasenum(const avalue: integer);
begin
 if avalue = -1 then begin
  clear;
 end
 else begin
  asinteger:= avalue;
 end;
end;

{ tmselargeintfield }

function tmselargeintfield.HasParent: Boolean;
begin
 result:= dataset <> nil;
end;

function tmselargeintfield.assql: string;
begin
 result:= fieldtosql(self);
end;

procedure tmselargeintfield.setasmsestring(const avalue: msestring);
begin
 asstring:= avalue;
end;

function tmselargeintfield.getasmsestring: msestring;
begin
 result:= asstring;
end;

function tmselargeintfield.getasboolean: boolean;
begin
 result:= asinteger <> 0;
end;

procedure tmselargeintfield.setasboolean(avalue: boolean);
begin
 if avalue then begin
  asinteger:= 1;
 end
 else begin
  asinteger:= 0;
 end;
end;

procedure tmselargeintfield.Clear;
begin
 setdata(nil);
end;

{ tmsesmallintfield }

function tmsesmallintfield.HasParent: Boolean;
begin
 result:= dataset <> nil;
end;

function tmsesmallintfield.assql: string;
begin
 result:= fieldtosql(self);
end;

procedure tmsesmallintfield.setasmsestring(const avalue: msestring);
begin
 asstring:= avalue;
end;

function tmsesmallintfield.getasmsestring: msestring;
begin
 result:= asstring;
end;

function tmsesmallintfield.getasboolean: boolean;
begin
 result:= asinteger <> 0;
end;

procedure tmsesmallintfield.setasboolean(avalue: boolean);
begin
 if avalue then begin
  asinteger:= 1;
 end
 else begin
  asinteger:= 0;
 end;
end;

procedure tmsesmallintfield.Clear;
begin
 setdata(nil);
end;

{ tmsewordfield }

function tmsewordfield.HasParent: Boolean;
begin
 result:= dataset <> nil;
end;

function tmsewordfield.assql: string;
begin
 result:= fieldtosql(self);
end;

procedure tmsewordfield.setasmsestring(const avalue: msestring);
begin
 asstring:= avalue;
end;

function tmsewordfield.getasmsestring: msestring;
begin
 result:= asstring;
end;

function tmsewordfield.getasboolean: boolean;
begin
 result:= asinteger <> 0;
end;

procedure tmsewordfield.setasboolean(avalue: boolean);
begin
 if avalue then begin
  asinteger:= 1;
 end
 else begin
  asinteger:= 0;
 end;
end;

procedure tmsewordfield.Clear;
begin
 setdata(nil);
end;

{ tmseautoincfield }

function tmseautoincfield.HasParent: Boolean;
begin
 result:= dataset <> nil;
end;

function tmseautoincfield.assql: string;
begin
 result:= fieldtosql(self);
end;

procedure tmseautoincfield.setasmsestring(const avalue: msestring);
begin
 asstring:= avalue;
end;

function tmseautoincfield.getasmsestring: msestring;
begin
 result:= asstring;
end;

procedure tmseautoincfield.Clear;
begin
 setdata(nil);
end;

{ tmsefloatfield }

function tmsefloatfield.HasParent: Boolean;
begin
 result:= dataset <> nil;
end;

function tmsefloatfield.assql: string;
begin
 result:= fieldtosql(self);
end;

procedure tmsefloatfield.setasmsestring(const avalue: msestring);
begin
 asstring:= avalue;
end;

function tmsefloatfield.getasmsestring: msestring;
begin
 result:= asstring;
end;

function tmsefloatfield.getasfloat: double;
begin
 if isnull then begin
  result:= emptyreal;
 end
 else begin
  result:= inherited getasfloat;
 end;
end;

procedure tmsefloatfield.setasfloat(avalue: double);
begin
 if isemptyreal(avalue) then begin
  clear;
 end
 else begin
  inherited;
 end;
end;

procedure tmsefloatfield.Clear;
begin
 setdata(nil);
end;

{ tmsecurrencyfield }

function tmsecurrencyfield.HasParent: Boolean;
begin
 result:= dataset <> nil;
end;

function tmsecurrencyfield.assql: string;
begin
 result:= fieldtosql(self);
end;

procedure tmsecurrencyfield.setasmsestring(const avalue: msestring);
begin
 asstring:= avalue;
end;

function tmsecurrencyfield.getasmsestring: msestring;
begin
 result:= asstring;
end;

procedure tmsecurrencyfield.Clear;
begin
 setdata(nil);
end;

{ tmsebooleanfield }

constructor tmsebooleanfield.Create(AOwner: TComponent);
begin
 inherited;
 displayvalues:= 'True;False';
end;

function tmsebooleanfield.HasParent: Boolean;
begin
 result:= dataset <> nil;
end;

function tmsebooleanfield.assql: string;
begin
 result:= fieldtosql(self);
end;

procedure tmsebooleanfield.setasmsestring(const avalue: msestring);
var
 mstr1: msestring;
begin
 if avalue= '' then begin
  clear;
 end
 else begin
  mstr1:= mseuppercase(avalue);
  if pos(mstr1,fdisplays[true,false]) = 1 then begin
   asboolean:= false;
  end
  else begin
   if pos(mstr1,fdisplays[true,true]) = 1 then begin
    asboolean:= true;
   end
   else begin
    DatabaseErrorFmt(SNotABoolean,[string(AValue)]);
   end;
  end;
 end;
end;

function tmsebooleanfield.getasmsestring: msestring;
var 
 bo1: wordbool;
begin
 if getdata(@bo1) then begin
  result:= fdisplays[false,bo1]
 end
 else begin
  result:='';
 end;
end;

procedure tmsebooleanfield.Clear;
begin
 setdata(nil);
end;

procedure tmsebooleanfield.setdisplayvalues(const avalue: msestring);
var
 ar1: msestringarty;
begin
 if fdisplayvalues <> avalue then begin
  ar1:= splitstring(avalue,';');
  if (high(ar1) <> 1) or (ar1[0] = ar1[1]) then begin
   databaseerrorfmt(SInvalidDisplayValues,[string(avalue)]);
  end;
  fdisplayvalues:= avalue;
    // Store display values and their uppercase equivalents;
  fdisplays[false,true]:= ar1[0];
  fdisplays[true,true]:= mseUpperCase(ar1[0]);
  fdisplays[false,false]:= ar1[1];
  fdisplays[true,false]:= mseuppercase(ar1[1]);
  propertychanged(true);
 end;
end;

function tmsebooleanfield.getasstring: string;
begin
 result:= getasmsestring;
end;

procedure tmsebooleanfield.setasstring(const avalue: string);
begin
 setasmsestring(avalue);
end;

function tmsebooleanfield.GetDefaultWidth: Longint;
begin
 result:= length(fdisplays[false,false]);
 if result < length(fdisplays[false,true]) then begin
  result:= length(fdisplays[false,true]);
 end;
end;

{ tmsedatetimefield }

function tmsedatetimefield.HasParent: Boolean;
begin
 result:= dataset <> nil;
end;

function tmsedatetimefield.assql: string;
begin
 result:= fieldtosql(self);
end;

procedure tmsedatetimefield.setasmsestring(const avalue: msestring);
begin
 asstring:= avalue;
end;

function tmsedatetimefield.getasmsestring: msestring;
begin
 result:= asstring;
end;

function tmsedatetimefield.getasdatetime: tdatetime;
begin
 if isnull then begin
  result:= emptydatetime;
 end
 else begin
  result:= inherited getasdatetime;
 end;
end;

procedure tmsedatetimefield.setasdatetime(avalue: tdatetime);
begin
 if isemptydatetime(avalue) then begin
  clear;
 end
 else begin
  inherited;
 end;
end;

procedure tmsedatetimefield.Clear;
begin
 setdata(nil);
end;

{ tmsedatefield }

function tmsedatefield.HasParent: Boolean;
begin
 result:= dataset <> nil;
end;

function tmsedatefield.assql: string;
begin
 result:= fieldtosql(self);
end;

procedure tmsedatefield.setasmsestring(const avalue: msestring);
begin
 asstring:= avalue;
end;

function tmsedatefield.getasmsestring: msestring;
begin
 result:= asstring;
end;

function tmsedatefield.getasdatetime: tdatetime;
begin
 if isnull then begin
  result:= emptydatetime;
 end
 else begin
  result:= inherited getasdatetime;
 end;
end;

procedure tmsedatefield.setasdatetime(avalue: tdatetime);
begin
 if isemptydatetime(avalue) then begin
  clear;
 end
 else begin
  inherited;
 end;
end;

procedure tmsedatefield.Clear;
begin
 setdata(nil);
end;

{ tmsetimefield }

function tmsetimefield.HasParent: Boolean;
begin
 result:= dataset <> nil;
end;

function tmsetimefield.assql: string;
begin
 result:= fieldtosql(self);
end;

procedure tmsetimefield.setasmsestring(const avalue: msestring);
begin
 asstring:= avalue;
end;

function tmsetimefield.getasmsestring: msestring;
begin
 result:= asstring;
end;

function tmsetimefield.getasdatetime: tdatetime;
begin
 if isnull then begin
  result:= emptydatetime;
 end
 else begin
  result:= inherited getasdatetime;
 end;
end;

procedure tmsetimefield.setasdatetime(avalue: tdatetime);
begin
 if isemptydatetime(avalue) then begin
  clear;
 end
 else begin
  inherited;
 end;
end;

procedure tmsetimefield.Clear;
begin
 setdata(nil);
end;

{ tmsebinaryfield }

function tmsebinaryfield.HasParent: Boolean;
begin
 result:= dataset <> nil;
end;

function tmsebinaryfield.assql: string;
begin
 result:= fieldtosql(self);
end;

procedure tmsebinaryfield.setasmsestring(const avalue: msestring);
begin
 asstring:= avalue;
end;

function tmsebinaryfield.getasmsestring: msestring;
begin
 result:= asstring;
end;

procedure tmsebinaryfield.Clear;
begin
 setdata(nil);
end;

{ tmsebytesfield }

function tmsebytesfield.HasParent: Boolean;
begin
 result:= dataset <> nil;
end;

function tmsebytesfield.assql: string;
begin
 result:= fieldtosql(self);
end;

procedure tmsebytesfield.setasmsestring(const avalue: msestring);
begin
 asstring:= avalue;
end;

function tmsebytesfield.getasmsestring: msestring;
begin
 result:= asstring;
end;

procedure tmsebytesfield.Clear;
begin
 setdata(nil);
end;

{ tmsevarbytesfield }

function tmsevarbytesfield.HasParent: Boolean;
begin
 result:= dataset <> nil;
end;

function tmsevarbytesfield.assql: string;
begin
 result:= fieldtosql(self);
end;

procedure tmsevarbytesfield.setasmsestring(const avalue: msestring);
begin
 asstring:= avalue;
end;

function tmsevarbytesfield.getasmsestring: msestring;
begin
 result:= asstring;
end;

procedure tmsevarbytesfield.Clear;
begin
 setdata(nil);
end;

{ tmsebcdfield }

function tmsebcdfield.HasParent: Boolean;
begin
 result:= dataset <> nil;
end;

function tmsebcdfield.assql: string;
begin
 result:= fieldtosql(self);
end;

procedure tmsebcdfield.setasmsestring(const avalue: msestring);
begin
 asstring:= avalue;
end;

function tmsebcdfield.getasmsestring: msestring;
begin
 result:= asstring;
end;

procedure tmsebcdfield.Clear;
begin
 setdata(nil);
end;

{ tmseblobfield }

function tmseblobfield.HasParent: Boolean;
begin
 result:= dataset <> nil;
end;

function tmseblobfield.assql: string;
begin
 result:= fieldtosql(self);
end;

procedure tmseblobfield.setasmsestring(const avalue: msestring);
begin
 asstring:= avalue;
end;

function tmseblobfield.getasmsestring: msestring;
begin
 result:= asstring;
end;

procedure tmseblobfield.LoadFromFile(const FileName: filenamety);
begin
 if filename = '' then begin
  clear;
 end
 else begin
  inherited loadfromfile(tosysfilepath(filename));
 end;
end;

procedure tmseblobfield.SaveToFile(const FileName: filenamety);
begin
 inherited savetofile(tosysfilepath(filename));
end;

{ tmsegraphicfield }

{ tdbfieldnamearrayprop }

constructor tdbfieldnamearrayprop.create(const afieldtypes: fieldtypesty;
   const agetdatasource: getdatasourcefuncty);
begin
 ffieldtypes:= afieldtypes;
 fgetdatasource:= agetdatasource;
 inherited create;
end;

function tdbfieldnamearrayprop.getdatasource(const aindex: integer): tdatasource;
begin
 result:= fgetdatasource();
end;

procedure tdbfieldnamearrayprop.getfieldtypes(out apropertynames: stringarty;
                  out afieldtypes: fieldtypesarty);
begin
 apropertynames:= nil;
 setlength(afieldtypes,1);
 afieldtypes[0]:= ffieldtypes;
end;

{ tmsedatalink }

procedure tmsedatalink.activechanged;
var
 intf1: igetdscontroller;
begin
 fdscontroller:= nil;
 if dataset <> nil then begin
  if getcorbainterface(dataset,typeinfo(igetdscontroller),intf1) then begin
   fdscontroller:= intf1.getcontroller;
  end;   
 end;
 inherited;
end;

function tmsedatalink.getutf8: boolean;
begin
 result:= (fdscontroller <> nil) and (dso_utf8 in fdscontroller.foptions);
end;

function tmsedatalink.getdataset: tdataset;
begin
 if datasource <> nil then begin
  result:= datasource.dataset;
 end
 else begin
  result:= nil;
 end;
end;

function tmsedatalink.moveby(distance: integer): integer;
 
begin
 if (distance <> 0) and active then begin
  if fdscontroller <> nil then begin
   result:= fdscontroller.moveby(distance);
  end
  else begin
   result:= inherited moveby(distance);
  end;
 end;
end;

function tmsedatalink.GetActiveRecord: Integer;
begin
 if (dataset = nil) or (csdestroying in dataset.componentstate) then begin
  result:= -1;
 end
 else begin
  result:= inherited getactiverecord;
 end;
end;

{ tfielddatalink }

procedure tfielddatalink.setfieldname(const Value: string);
begin
 if ffieldname <> value then begin
  ffieldname :=  value;
  updatefield;
 end;
end; 

procedure tfielddatalink.setfield(const value: tfield);
begin
 if ffield <> value then begin
  ffield := value;
  editingchanged;
  recordchanged(nil);
 end;
end;

procedure tfielddatalink.updatefield;
begin
 if active and (ffieldname <> '') then begin
  setfield(datasource.dataset.fieldbyname(ffieldname));
 end
 else begin
  setfield(nil);
 end;
end;

procedure tfielddatalink.activechanged;
begin
 inherited;
 updatefield;
end;

procedure tfielddatalink.layoutchanged;
begin
 inherited;
 updatefield;
end;

function tfielddatalink.getasmsestring: msestring;
begin
 if utf8 then begin
  result:= utf8tostring(field.asstring);
 end
 else begin
  result:= field.asstring;
 end;
end;

procedure tfielddatalink.setasmsestring(const avalue: msestring);
begin
 if utf8 then begin
  field.asstring:= stringtoutf8(avalue);
 end
 else begin
  field.asstring:= avalue;
 end;
end;

function tfielddatalink.msedisplaytext: msestring;
begin
 if utf8 then begin
  result:= utf8tostring(ffield.displaytext);
 end
 else begin
  result:= ffield.displaytext;
 end;
end;

function tfielddatalink.assql: string;
begin
 result:= fieldtosql(ffield);
end;

procedure tfielddatalink.checkfield;
begin
 if ffield = nil then begin
  raise exception.create('Field is nil.');
 end;
end;

function tfielddatalink.GetAsBoolean: Boolean;
begin
 checkfield;
 result:= field.asboolean;
end;

procedure tfielddatalink.SetAsBoolean(const avalue: Boolean);
begin
 checkfield;
 field.asboolean:= avalue;
end;

function tfielddatalink.GetAsCurrency: Currency;
begin
 checkfield;
 result:= field.ascurrency;
end;

procedure tfielddatalink.SetAsCurrency(const avalue: Currency);
begin
 checkfield;
 field.ascurrency:= avalue;
end;

function tfielddatalink.GetAsDateTime: TDateTime;
begin
 checkfield;
 result:= field.asdatetime;
end;

procedure tfielddatalink.SetAsDateTime(const avalue: TDateTime);
begin
 checkfield;
 field.asdatetime:= avalue;
end;

function tfielddatalink.GetAsFloat: Double;
begin
 checkfield;
 result:= field.asfloat;
end;

procedure tfielddatalink.SetAsFloat(const avalue: Double);
begin
 checkfield;
 field.asfloat:= avalue;
end;

function tfielddatalink.GetAsLongint: Longint;
begin
 checkfield;
 result:= field.aslongint;
end;

procedure tfielddatalink.SetAsLongint(const avalue: Longint);
begin
 checkfield;
 field.aslongint:= avalue;
end;

function tfielddatalink.GetAsLargeInt: LargeInt;
begin
 checkfield;
 result:= field.aslargeint;
end;

procedure tfielddatalink.SetAsLargeInt(const avalue: LargeInt);
begin
 checkfield;
 field.aslargeint:= avalue;
end;

function tfielddatalink.GetAsInteger: Integer;
begin
 checkfield;
 result:= field.asinteger;
end;

procedure tfielddatalink.SetAsInteger(const avalue: Integer);
begin
 checkfield;
 field.asinteger:= avalue;
end;

function tfielddatalink.GetAsString: string;
begin
 checkfield;
 result:= field.asstring;
end;

procedure tfielddatalink.SetAsString(const avalue: string);
begin
 checkfield;
 field.asstring:= avalue;
end;

function tfielddatalink.GetAsVariant: variant;
begin
 checkfield;
 result:= field.asvariant;
end;

procedure tfielddatalink.SetAsVariant(const avalue: variant);
begin
 checkfield;
 field.asvariant:= avalue;
end;

{ tactivatorcontroller }

constructor tactivatorcontroller.create(const aowner: tcomponent);
begin
 fowner:= aowner;
 inherited create;
end;

function tactivatorcontroller.setactive(const value: boolean): boolean;
begin
 factive:= value;
 result:= floaded or not (csloading in fowner.componentstate);
end;

procedure tactivatorcontroller.loaded;
begin
 floaded:= true;
 if (factivator = nil) or factivator.activated then begin
  if factivator <> nil then begin
   factive:= true; //activated
  end;
  if csdesigning in fowner.componentstate then begin
   try
    setowneractive(factive);
   except
    application.handleexception(fowner);
   end;
  end
  else begin
   setowneractive(factive);
  end;
 end;
end;

procedure tactivatorcontroller.setactivator(const avalue: tactivator);
begin
 tactivator.addclient(avalue,iobjectlink(self),factivator);
end;

procedure tactivatorcontroller.objectevent(const sender: tobject;
                     const event: objecteventty);
begin
 if (sender = factivator) then begin
  case event of
   oe_activate: begin
    floaded:= true;
    factive:= true;
    setowneractive(factive);
   end;
   oe_deactivate: begin
    factive:= false;
    setowneractive(factive);
   end;
  end;
 end;
end;

function tactivatorcontroller.getinstance: tobject;
begin
 result:= fowner;
end;

{ tpersistentfields }

constructor tpersistentfields.create(const adataset: tdataset);
begin
 fdataset:= adataset;
 inherited create(nil);
end;

procedure tpersistentfields.createitem(const index: integer; out item: tpersistent);
begin
 if csloading in fdataset.componentstate then begin
  item:= nil;
 end
 else begin
  item:= tfield.create(nil);
  tfield(item).dataset:= fdataset;
 end;
end;

procedure tpersistentfields.readfields(reader: treader);
var
 int1: integer; 
 fieldtypes: fieldclasstypearty;
begin
 setlength(fieldtypes,count);
 int1:= 0;
 reader.readlistbegin;
 reader.readlistbegin;
 while not reader.endoflist do begin
  if int1 <= high(fieldtypes) then begin
   fieldtypes[int1]:= fieldclasstypety(getenumvalue(typeinfo(fieldclasstypety),
                               reader.readident));    
  end;
  inc(int1);
 end;
 reader.readlistend;
 for int1:= 0 to high(fieldtypes) do begin
  fitems[int1]:= msefieldtypeclasses[fieldtypes[int1]].create(nil);
 end;
 readcollection(reader);
 for int1:= 0 to high(fitems) do begin
  tfield(fitems[int1]).dataset:= fdataset;
 end;
 reader.readlistend;
end;

procedure tpersistentfields.writefields(writer: twriter);
var
 int1: integer;
begin
 writer.writelistbegin;
 writer.writelistbegin;
 for int1:= 0 to high(fitems) do begin
  writer.writeident(getenumname(typeinfo(fieldclasstypety),
            ord(fieldclasstoclasstyp(fieldclassty(fitems[int1].classtype)))));
 end;
 writer.writelistend;
 writecollection(writer);
 writer.writelistend;
end;

procedure tpersistentfields.defineproperties(filer: tfiler);
var
 int1: integer; 
begin
 filer.defineproperty('fields',{$ifdef FPC}@{$endif}readfields,
                                   {$ifdef FPC}@{$endif}writefields,count > 0);
end;

procedure tpersistentfields.setitems(const index: integer; const avalue: tfield);
begin
 items[index].assign(avalue);
end;

function tpersistentfields.getitems(const index: integer): tfield;
begin
 result:= tfield(inherited getitems(index));
end;

procedure tpersistentfields.updateorder;
var
 int1: integer;
 bo1: boolean;
begin
 bo1:= fdataset.active;
 fdataset.active:= false;
 for int1:= 0 to count - 1 do begin
  items[int1].index:= int1;
 end;
 fdataset.active:= bo1;
end;

procedure tpersistentfields.move(const curindex: integer; const newindex: integer);
begin
 inherited;
 updateorder;
end;

function tpersistentfields.getfieldnames: stringarty;
var
 int1: integer;
begin
 setlength(result,count);
 for int1:= 0 to high(result) do begin
  result[int1]:= tfield(fitems[int1]).fieldname;
 end;
end;


{ tdscontroller }

constructor tdscontroller.create(const aowner: tdataset; const aintf: idscontroller;
                                   const arecnooffset: integer = 0;
                                   const acancelresync: boolean = true);
begin
 ffields:= tpersistentfields.create(aowner); 
 fintf:= aintf;
 frecnooffset:= arecnooffset;
 fcancelresync:= acancelresync;
 inherited create(aowner);
end;

destructor tdscontroller.destroy;
var
 int1: integer;
 field1: tfield;
begin
 tdataset(fowner).active:= false; //avoid later calls from fowner
 for int1:= 0 to high(flinkedfields) do begin
  flinkedfields[int1].setdsintf(nil);
 end;
 flinkedfields:= nil;
 with tdataset(fowner).fields do begin
  for int1:= count-1 downto 0 do begin
   field1:= fields[int1];
   if (field1.owner <> nil) and not 
         (csdestroying in field1.componentstate) then begin
    field1.dataset:= nil;
   end;
  end;
 end;
 ffields.free;
 inherited;
end;

procedure tdscontroller.fielddestroyed(const sender: ifieldcomponent);
begin
 removeitem(pointerarty(flinkedfields),sender);
end;

procedure tdscontroller.setowneractive(const avalue: boolean); 
begin
 tdataset(fowner).active:= avalue;
end;

function tdscontroller.locate(const key: integer; const field: tfield;
                              const options: locateoptionsty = []): locateresultty;
var
 bm: string;
begin
 with tdataset(fowner) do begin
  result:= loc_notfound;
  bm:= bookmark;
  disablecontrols;
  try
   if not (loo_noforeward in options) then begin
    while not eof do begin
     if field.asinteger = key then begin
      result:= loc_ok;
      exit;
     end;
     next;
    end;
   end;
   bookmark:= bm;
   if not (loo_nobackward in options) then begin
    while not bof do begin
     if field.asinteger = key then begin
      result:= loc_ok;
      exit;
     end;
     prior;
    end;
   end;
  finally
   try
    if result <> loc_ok then begin
     bookmark:= bm;
    end;
   finally
    enablecontrols;
   end;
  end;
 end;
end;

function tdscontroller.locate(const key: msestring; const field: tfield;
                         const options: locateoptionsty = []): locateresultty;
var
 int2: integer;
 str1,str2,bm: string;
 mstr1,mstr2: msestring;
 bo1: boolean;
 
 function checkcaseinsensitive: boolean;
 var
  int1: integer;
 begin
  if dso_utf8 in foptions then begin
   mstr2:= utf8tostring(field.asstring);
  end
  else begin
   mstr2:= field.asstring;
  end;
  mstr2:= mseuppercase(mstr2);      //todo: optimize
  result:= true;
  for int1:= 0 to int2 - 1 do begin
   if pmsechar(mstr1)[int1] <> pmsechar(mstr2)[int1] then begin
    result:= false;
    break;
   end;
   if pmsechar(mstr1)[int1] = #0 then begin
    break;
   end;
  end;
 end;
 
 function checkcasesensitive: boolean;
 var
  int1: integer;
 begin
  str2:= field.asstring;
  result:= true;
  for int1:= 0 to int2 - 1 do begin
   if pchar(str1)[int1] <> pchar(str2)[int1] then begin
    result:= false;
    break;
   end;
   if pchar(str1)[int1] = #0 then begin
    break;
   end;
  end;
 end;
 
begin
 with tdataset(fowner) do begin
  result:= loc_notfound;
  bm:= bookmark;
  bo1:= loo_caseinsensitive in options;
  if bo1 then begin 
   mstr1:= mseuppercase(key);
   if loo_partialkey in options then begin
    int2:= length(mstr1);
   end
   else begin
    int2:= bigint;
   end;
  end
  else begin
   if dso_utf8 in foptions then begin
    str1:= stringtoutf8(key);
   end
   else begin
    str1:= key;
   end;
   if loo_partialkey in options then begin
    int2:= length(str1);
   end
   else begin
    int2:= bigint;
   end;
  end;
  disablecontrols;
  try
   if not (loo_noforeward in options) then begin
    if bo1 then begin
     while not eof do begin
      if checkcaseinsensitive then begin
       result:= loc_ok;
       exit;
      end;
      next;
     end;
    end
    else begin
     while not eof do begin
      if checkcasesensitive then begin
       result:= loc_ok;
       exit;
      end;
      next;
     end;
    end;
    bookmark:= bm;
   end;
   if not (loo_nobackward in options) then begin
    if bo1 then begin
     while not bof do begin
      if checkcaseinsensitive then begin
       result:= loc_ok;
       exit;
      end;
      prior;
     end;
    end
    else begin
     while not bof do begin
      if checkcasesensitive then begin
       result:= loc_ok;
       exit;
      end;
      prior;
     end;
    end;
   end;
  finally
   try
    if result <> loc_ok then begin
     bookmark:= bm;
    end;
   finally
    enablecontrols;
   end;
  end;
 end;
end;

procedure tdscontroller.appendrecord(const values: array of const);
var
 int1: integer;
 field1: tfield;
begin
 with tdataset(fowner) do begin
  append;
  for int1:= 0 to high(values) do begin
   field1:= fields[int1];
   with values[int1] do begin
    case vtype of
     vtInteger:    field1.asinteger:= VInteger;
     vtBoolean:    field1.asboolean:= VBoolean;
     vtChar:       field1.asstring:= VChar;
     vtWideChar:   field1.asstring:= VWideChar;
     vtExtended:   field1.asfloat:= VExtended^;
     vtString:     field1.asstring:= VString^;
 //  vtPointer:
     vtPChar:      field1.asstring:= VPChar;
 //  vtObject:
 //  vtClass:
     vtPWideChar:  field1.asstring:= VPWideChar;
     vtAnsiString: field1.asstring:= ansistring(VAnsiString);
     vtCurrency:   field1.ascurrency:= VCurrency^;
     vtVariant:    field1.asvariant:= VVariant^;
 //    vtInterface:
     vtWideString: field1.asstring:= widestring(VWideString);
 //  vtInt64:
 //  vtQWord:
    end;
   end;
  end; 
 end;
end;

procedure tdscontroller.setfields(const avalue: tpersistentfields);
begin
 ffields.assign(avalue);
end;

procedure tdscontroller.getfieldclass(const fieldtype: tfieldtype; out result: tfieldclass);
begin
 result:= msefieldtypeclasses[tfieldtypetotypety[fieldtype]];
end;

function tdscontroller.getrecnonullbased: integer;
begin
 with tdataset1(fowner) do begin
  if not frecnovalid then begin
   if bof then begin
    frecno:= 0;
   end
   else begin
    if eof then begin
     frecno:= recordcount - 1;
    end
    else begin
     frecno:= recno + frecnooffset;
    end;
   end;
   frecnovalid:= true;
  end
  else begin
   inc(frecno,fscrollsum + activerecord - factiverecordbefore);
  end;
  factiverecordbefore:= activerecord;
  fscrollsum:= 0;
 end;
 result:= frecno;
end;

procedure tdscontroller.setrecnonullbased(const avalue: integer);
begin
 if not frecnovalid or (avalue <> frecno) then begin
  tdataset1(fowner).recno:= avalue - recnooffset;
  frecno:= avalue;
  factiverecordbefore:= tdataset1(fowner).activerecord;
  fscrollsum:= 0;
  frecnovalid:= true;
 end;
end;

function tdscontroller.getrecno: integer;
begin
 result:= recnonullbased - frecnooffset;
end;

procedure tdscontroller.setrecno(const avalue: integer);
begin
 recnonullbased:= avalue + frecnooffset;
end;

procedure tdscontroller.updatelinkedfields;
var
 int1: integer;
 intf1: ifieldcomponent;
 field1: tfield;
begin
 with tdataset(fowner) do begin
  for int1:= 0 to fields.count - 1 do begin
   field1:= fields[int1];
   if getcorbainterface(field1,typeinfo(ifieldcomponent),intf1) and 
       (finditem(pointerarty(flinkedfields),intf1) < 0) then begin
    additem(pointerarty(flinkedfields),intf1);
    intf1.setdsintf(idsfieldcontroller(self));
   end;
  end;
  for int1:= high(flinkedfields) downto 0 do begin
   if fields.indexof(flinkedfields[int1].getinstance) < 0 then begin
    flinkedfields[int1].setdsintf(nil);
    deleteitem(pointerarty(flinkedfields),int1);
   end;
  end;       
 end;
end;

procedure tdscontroller.dataevent(const event: tdataevent; const info: ptrint);
begin
 case event of
  dedatasetscroll: begin
   fmovebylock:= false;
   dec(fscrollsum,info);
  end;
  dedatasetchange,deupdatestate: begin
   frecnovalid:= false;
  end;
  defieldlistchange: begin
   updatelinkedfields;
  end;
 end;
 if not fmovebylock or (event <> dedatasetchange) then begin
  fintf.inheriteddataevent(event,info);
 end;
end;

procedure tdscontroller.cancel;
begin
 with tdataset1(fowner) do begin
  if fcancelresync and (state = dsinsert) and not modified then begin
   fintf.inheritedcancel;
   try
    if finsertbm <> '' then begin
     bookmark:= finsertbm;
    end;  
   except
   end;
   finsertbm:= '';
  end
  else begin
   fintf.inheritedcancel;
  end;
 end;
end;

function tdscontroller.moveby(const distance: integer): integer;
begin
 with tdataset1(fowner) do begin
  if (abs(distance) = 1) and (state = dsinsert) and not modified then begin
   checkbrowsemode;
  end
  else begin
   if state = dsbrowse then begin
    fmovebylock:= true;
   end;
   try
    result:= fintf.inheritedmoveby(distance);
    if fmovebylock then begin
     fmovebylock:= false;
     dataevent(dedatasetscroll,0);
    end;
   finally
    fmovebylock:= false;
   end;
  end;
 end;
end;

procedure tdscontroller.internalinsert;
begin
 finsertbm:= tdataset(fowner).bookmark;
 fintf.inheritedinternalinsert;
end;

procedure tdscontroller.internalopen;
var
 int1,int2: integer;
begin
 updatelinkedfields;
 fintf.inheritedinternalopen;
 with tdataset(fowner) do begin
  for int1:= 0 to fields.count - 1 do begin
   with fields[int1] do begin
    int2:= fielddefs.indexof(fieldname);
    if (int2 >= 0) and not checkfieldcompatibility(fields[int1],
                          fielddefs[int2].datatype) then begin
     databaseerror('Datatype mismatch dataset '''+fowner.name+''' field '''+
      fieldname+''''+lineend+
        'expected: '''+getenumname(typeinfo(tfieldtype),
         ord(fielddefs[int2].datatype))+''' actual: '''+
         getenumname(typeinfo(tfieldtype),ord(datatype))+'''.');
    end;
   end;
  end;
 end;
end;

function tdscontroller.getcontroller: tdscontroller;
begin
 result:= self;
end;

function tdscontroller.assql(const avalue: msestring): string;
begin
 if avalue = '' then begin
  result:= 'NULL';
 end
 else begin
  if dso_utf8 in foptions then begin
   result:= encodesqlstring(stringtoutf8(avalue));
  end
  else begin
   result:= encodesqlstring(avalue);
  end;
 end;
end;

function tdscontroller.assql(const avalue: integer): string;
begin
 result:= inttostr(avalue);
end;

function tdscontroller.assql(const avalue: realty): string;
begin
 if isemptyreal(avalue) then begin
  result:= 'NULL';
 end
 else begin
  result:= realtostr(avalue);
 end;
end;

function tdscontroller.assql(const avalue: tdatetime): string;
begin
 if isemptydatetime(avalue) then begin
  result:= 'NULL';
 end
 else begin
  result:= encodesqldatetime(avalue);
 end;
end;

function tdscontroller.assqldate(const avalue: tdatetime): string;
begin
 if isemptydatetime(avalue) then begin
  result:= 'NULL';
 end
 else begin
  result:= encodesqldate(avalue);
 end;
end;

function tdscontroller.assqltime(const avalue: tdatetime): string;
begin
 if isemptydatetime(avalue) then begin
  result:= 'NULL';
 end
 else begin
  result:= encodesqltime(avalue);
 end;
end;

procedure tdscontroller.closequery(var amodalresult: modalresultty);
begin
 try
  with tdataset(fowner) do begin;
   if state in dseditmodes then begin
    checkbrowsemode;
   end;
  end;
 except
  amodalresult:= mr_exception;
  application.handleexception(nil);
 end;
end;

procedure tdscontroller.post;
begin
 with tdataset(fowner) do begin;
  if state in dseditmodes then begin
   include(fstate,dscs_posting);
   try    
    fintf.inheritedpost;
   finally
    exclude(fstate,dscs_posting);
   end;
  end;
 end;
end;

function tdscontroller.emptyinsert: boolean;
begin
 result:= false;
 if not posting then begin
  with tdataset1(fowner) do begin
   if state = dsinsert then begin
    DataEvent(deUpdateRecord,0);
    result:= not modified;
   end;
  end;
 end;
end;

function tdscontroller.posting: boolean;
begin
 result:= dscs_posting in fstate;
end;

{ ttacontroller }

constructor ttacontroller.create(const aowner: tdbtransaction);
begin
 inherited create(aowner);
end;

procedure ttacontroller.setowneractive(const avalue: boolean);
begin
 tdbtransaction(fowner).active:= avalue;
end;

{ tdbcontroller }

constructor tdbcontroller.create(const aowner: tdatabase; const aintf: idbcontroller);
begin
 fintf:= aintf;
 inherited create(aowner);
end;

procedure tdbcontroller.setowneractive(const avalue: boolean);
var
 bo1: boolean;
begin
 if avalue then begin
  with tdatabase(fowner) do begin
   if checkcanevent(fowner,tmethod(fonbeforeconnect)) then begin
    fonbeforeconnect(tdatabase(fowner));
   end;
   try
    connected:= avalue;
   except
    on e: exception do begin
     if checkcanevent(fowner,tmethod(fonconnecterror)) then begin
      bo1:= false;
      fonconnecterror(tdatabase(fowner),e,bo1);
      if not bo1 then begin
       raise;
      end;
     end;
    end;
   end;
  end;
 end
 else begin
  tdatabase(fowner).connected:= avalue;
 end;
end;

function tdbcontroller.getdatabasename: filenamety;
begin
 result:= fdatabasename;
end;

procedure tdbcontroller.setdatabasename(const avalue: filenamety);
begin
 fdatabasename:= tomsefilepath(avalue);
 tdatabase(fowner).databasename:= tosysfilepath(filepath(avalue,fk_default,true));
end;

{ tmsedatasource }

procedure tmsedatasource.DoDataChange(Info: Pointer);
begin
 if not (csdesigning in componentstate) then begin
  inherited;
 end;
end;

procedure tmsedatasource.DoStateChange;
begin
 if not (csdesigning in componentstate) then begin
  inherited;
 end;
end;

{ tfieldlinkdatalink }

constructor tfieldlinkdatalink.create(const aowner: tfieldlink);
begin
 fowner:= aowner;
 inherited create;
 fdatasource:= tdatasource.create(nil);
 datasource:= fdatasource;
end;

destructor tfieldlinkdatalink.destroy;
begin
 fdatasource.free;
 inherited;
end;

procedure tfieldlinkdatalink.updatedata;
begin
 if field <> nil then begin
  with fowner do begin
   if not (flo_onlyifnull in foptions) or (field.isnull) then begin
    fowner.updatedata(field);
   end;
  end;
 end;
end;

{ tfieldlink }

constructor tfieldlink.create(aowner: tcomponent);
begin
 inherited;
 fdestdatalink:= tfieldlinkdatalink.create(self);
end;

destructor tfieldlink.destroy;
begin
 fdestdatalink.free;
 inherited;
end;

procedure tfieldlink.setdataset(const avalue: tdataset);
begin
 fdestdatalink.fdatasource.dataset:= avalue;
end;

function tfieldlink.getdataset: tdataset;
begin
 result:= fdestdatalink.dataset;
end;

function tfieldlink.getdatafield: string;
begin
 result:= fdestdatalink.fieldname;
end;

procedure tfieldlink.setdatafield(const avalue: string);
begin
 fdestdatalink.fieldname:= avalue;
end;

function tfieldlink.field: tfield;
begin
 result:= fdestdatalink.field;
end;

procedure tfieldlink.getfieldtypes(out propertynames: stringarty;
                          out fieldtypes: fieldtypesarty);
begin
 propertynames:= nil;
 fieldtypes:= nil;
end;

function tfieldlink.getdatasource(const aindex: integer): tdatasource;
begin
 result:= fdestdatalink.datasource;
end;

procedure tfieldlink.updatedata(const afield: tfield);
begin
 if canevent(tmethod(fonupdatedata)) then begin
  fonupdatedata(afield);
 end;
end;

{ tfieldfieldlink }

constructor tfieldfieldlink.create(aowner: tcomponent);
begin
 inherited;
 fsourcedatalink:= tfielddatalink.create;
end;

destructor tfieldfieldlink.destroy;
begin
 fsourcedatalink.free;
 inherited;
end;

function tfieldfieldlink.getsourcedatafield: string;
begin
 result:= fsourcedatalink.fieldname;
end;

procedure tfieldfieldlink.setsourcedatafield(const avalue: string);
begin
 fsourcedatalink.fieldname:= avalue;
end;

function tfieldfieldlink.getdatasource: tdatasource;
begin
 result:= fsourcedatalink.datasource;
end;

function tfieldfieldlink.getdatasource(const aindex: integer): tdatasource;
begin
 if aindex = 0 then begin
  result:= fdestdatalink.datasource;
 end
 else begin
  result:= fsourcedatalink.datasource;
 end;  
end;

procedure tfieldfieldlink.setdatasource(const avalue: tdatasource);
begin
 fsourcedatalink.datasource:= avalue;
end;

function tfieldfieldlink.sourcefield: tfield;
begin
 result:= fsourcedatalink.field;
end;

procedure tfieldfieldlink.getfieldtypes(out propertynames: stringarty;
               out fieldtypes: fieldtypesarty);
begin
 setlength(propertynames,2);
 propertynames[0]:= 'datafield';
 propertynames[1]:= 'sourcedatafield';
 setlength(fieldtypes,2);
 fieldtypes[0]:= [];
 fieldtypes[1]:= [];
end;

procedure tfieldfieldlink.updatedata(const afield: tfield);
begin
 if fsourcedatalink.field <> nil then begin
  field.value:= fsourcedatalink.field.value;
 end;
 inherited;
end;

{ ttimestampfieldlink }

procedure ttimestampfieldlink.updatedata(const afield: tfield);
begin
 afield.asdatetime:= now;
 inherited;
end;

end.

unit msesqlresult;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
interface
uses
 classes,db,msqldb,mseclasses,msedb,msedatabase,msearrayprops,msestrings,msereal,
 msetypes;
 
type
 tsqlresult = class;
 
 tdbcol = class(tvirtualpersistent)
  private
  protected
   fuppername: ansistring;
   ffieldname: ansistring;
   fsqlresult: tsqlresult;
   fcursor: tsqlcursor;
   fdatatype: tfieldtype;
   ffieldnum: integer;
   futf8: boolean;
//   fbuffer: array[0..31] of byte;
   fdatasize: integer;
   function accesserror(const typename: string): edatabaseerror;
   function getasboolean: boolean; virtual;
   function getascurrency: currency; virtual;
   function getaslargeint: largeint; virtual;
   function getasdatetime: tdatetime; virtual;
   function getasfloat: double; virtual;
   function getasinteger: longint; virtual;
   function getasstring: string; virtual;
   function getasmsestring: msestring; virtual;
   function getisnull: boolean; virtual;
   function loadfield(const buffer: pointer; var bufsize: integer): boolean; overload;
                //false if null or inactive
   function loadfield(const buffer: pointer): boolean; overload;
                //false if null or inactive
  public
   constructor create(const asqlresult: tsqlresult;
          const acursor: tsqlcursor; const afielddef: tfielddef); reintroduce;
   property datatype: tfieldtype read fdatatype;
   property fieldname: ansistring read ffieldname;
   property datasize: integer read fdatasize;
      
   property asboolean: boolean read getasboolean;
   property ascurrency: currency read getascurrency;
   property aslargeint: largeint read getaslargeint;
   property asdatetime: tdatetime read getasdatetime;
   property asfloat: double read getasfloat;
   property asinteger: longint read getasinteger;
   property asstring: ansistring read getasstring;
   property asmsestring: msestring read getasmsestring;
   property isnull: boolean read getisnull;
   
 end;
 dbcolclassty = class of tdbcol;

 tstringdbcol = class(tdbcol)
  protected
   function getasstring: ansistring; override;
  public
   property value: msestring read getasmsestring;
 end;
 
 tnumericdbcol = class(tdbcol)
  private
  protected
 end;
 
 tlongintdbcol = class(tdbcol)
  protected
   function getasinteger: integer; override;
  public
   property value: integer read getasinteger;
 end;
 
 tlargeintdbcol = class(tnumericdbcol)
  protected
   function getaslargeint: largeint; override;
   function getasinteger: integer; override;
  public
   property value: largeint read getaslargeint;
 end;
 
 tsmallintdbcol = class(tnumericdbcol)
  protected
   function getasinteger: integer; override;
  public
   property value: integer read getasinteger;
 end;
 
 tworddbcol = class(tnumericdbcol)
  protected
   function getasinteger: integer; override;
  public
   property value: integer read getasinteger;
 end;
 
// tautoincdbcol = class(tdbcol);

 tfloatdbcol = class(tdbcol)
  protected
   function getasfloat: double; override;
   function getascurrency: currency; override;
  public
   property value: double read getasfloat;
 end;
 tcurrencydbcol = class(tdbcol)
  protected
   function getascurrency: currency; override;
   function getasfloat: double; override;
  public
   property value: currency read getascurrency;
 end;
 tbooleandbcol = class(tdbcol)
  protected
   function getasboolean: boolean; override;
  public
   property value: boolean read getasboolean;
 end;
 tdatetimedbcol = class(tdbcol)
  protected
   function getasdatetime: tdatetime; override;
  public
   property value: tdatetime read getasdatetime;
 end;
  
// tdatedbcol = class(tdbcol);
// ttimedbcol = class(tdbcol);
// tbinarydbcol = class(tdbcol);
// tbytesdbcol = class(tdbcol);
// tvarbytesdbcol = class(tdbcol);
// tbcddbcol = class(tdbcol);

 tblobdbcol = class(tdbcol)
  private
  protected 
   function getasstring: ansistring; override;
  public
   property value: ansistring read getasstring;
 end;
 
 tmemodbcol = class(tblobdbcol)
  public
   property value: msestring read getasmsestring;
 end;
 
// tgraphicdbcol = class(tdbcol);
  
 tdbcols = class(tpersistentarrayprop)
  private 
   fname: ansistring;
   function getitems(const index: integer): tdbcol;
   procedure initfields(const asqlresult: tsqlresult;
                  const acursor: tsqlcursor; const afielddefs: tfielddefs);
  public
   constructor create(const aname: ansistring);
   function findcol(const aname: ansistring): tdbcol;   
   function colbyname(const aname: ansistring): tdbcol;
   property items[const index: integer]: tdbcol read getitems;
 end;

 sqlresultoptionty = (sro_utf8);
 sqlresultoptionsty = set of sqlresultoptionty;
 
 tsqlresult = class(tmsecomponent,isqlpropertyeditor,isqlclient)
  private
   fsql: tstringlist;
   fopenafterread: boolean;
   factive: boolean;
   fdatabase: tcustomsqlconnection;
   ftransaction: tsqltransaction;
   fcursor: tsqlcursor;
   fparams: tmseparams;
   ffielddefs: tfielddefs;
   fcols: tdbcols;
   feof: boolean;
   foptions: sqlresultoptionsty;
   procedure setsql(const avalue: tstringlist);
   function getactive: boolean;
   procedure setactive(avalue: boolean);
   procedure setdatabase1(const avalue: tcustomsqlconnection);
   function getsqltransaction: tsqltransaction;
   procedure setsqltransaction(const avalue: tsqltransaction);
   procedure setparams(const avalue: tmseparams);
   procedure onchangesql(sender : tobject);
  protected
   procedure loaded; override;
   procedure freefldbuffers;
   function isprepared: boolean;
   procedure open;
   procedure close;
   procedure prepare;
   procedure unprepare;
   procedure execute;
   //idatabaseclient
   procedure setdatabase(const avalue: tmdatabase);
   function getname: ansistring;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   function isutf8: boolean;
   procedure next;
   procedure refresh;
   property cols: tdbcols read fcols;
   property eof: boolean read feof;
  published
   property params : tmseparams read fparams write setparams;
               //before sql
   property sql: tstringlist read fsql write setsql;
   property database: tcustomsqlconnection read fdatabase write setdatabase1;
   property transaction: tsqltransaction read getsqltransaction 
                                      write setsqltransaction;
   property active: boolean read getactive write setactive;
   property options: sqlresultoptionsty read foptions write foptions;
 end;
 
implementation
uses
 sysutils,dbconst,rtlconsts;
const 
 msedbcoltypeclasses: array[fieldclasstypety] of dbcolclassty = 
//        ft_unknown,ft_string,   ft_numeric,
          (tdbcol,   tstringdbcol,tlongintdbcol,
//         ft_longint,   ft_largeint,   ft_smallint,
           tlongintdbcol,tlargeintdbcol,tsmallintdbcol,
//         ft_word,   ft_autoinc,   ft_float,   ft_currency,   ft_boolean,
           tworddbcol,tlongintdbcol,tfloatdbcol,tcurrencydbcol,tbooleandbcol,
//         ft_datetime,   ft_date,       ft_time,
           tdatetimedbcol,tdatetimedbcol,tdatetimedbcol,
//         ft_binary,ft_bytes,ft_varbytes,
           tdbcol,   tdbcol,  tdbcol,
//         ft_bcd,        ft_blob,   ft_memo,   ft_graphic);
           tcurrencydbcol,tblobdbcol,tmemodbcol,tblobdbcol);
 SBoolean = 'Boolean';
 SDateTime = 'TDateTime';
 SFloat = 'Float';
 SInteger = 'Integer';
 SLargeInt = 'LargeInt';
 SVariant = 'Variant';
 SString = 'String';
           
{ tdbcol }

constructor tdbcol.create(const asqlresult: tsqlresult;
                     const acursor: tsqlcursor; const afielddef: tfielddef);
begin
 fsqlresult:= asqlresult;
 fcursor:= acursor;
 ffieldname:= afielddef.name;
 fuppername:= uppercase(ffieldname);
 fdatatype:= afielddef.datatype;
 ffieldnum:= afielddef.fieldno-1;
 fdatasize:= afielddef.size;
 futf8:= asqlresult.isutf8;
 inherited create;
end;

function tdbcol.accesserror(const typename: string): edatabaseerror;
begin
 result:= edatabaseerror.createfmt(sinvalidtypeconversion,[typename,ffieldname]);
end;

function tdbcol.getasboolean: boolean;
begin
 result:= getasinteger <> 0;
end;

function tdbcol.getascurrency: currency;
begin
 result:= getasfloat;
end;

function tdbcol.getaslargeint: largeint;
begin
 result:= getasinteger;
end;

function tdbcol.getasdatetime: tdatetime;
begin
 raise accesserror(sdatetime);
end;

function tdbcol.getasfloat: double;
begin
 result:= getaslargeint;
end;

function tdbcol.getasinteger: longint;
begin
 raise accesserror(sinteger);
end;

function tdbcol.getasstring: string;
begin
 raise accesserror(sstring);
end;

function tdbcol.getasmsestring: msestring;
var
 str1: ansistring;
begin
 str1:= getasstring;
 if futf8 then begin
  result:= utf8tostring(str1);
 end
 else begin
  result:= str1;
 end;
end;

function tdbcol.getisnull: boolean;
var
 int1: integer;
begin
 int1:= 0;
 result:= not fsqlresult.active or 
            not fsqlresult.fdatabase.loadfield(fsqlresult.fcursor,
            fdatatype,ffieldnum,nil,int1)
end;

function tdbcol.loadfield(const buffer: pointer; var bufsize: integer): boolean;
begin
 result:= fsqlresult.active;
 if result then begin
  result:= fsqlresult.fdatabase.loadfield(fsqlresult.fcursor,
             fdatatype,ffieldnum,buffer,bufsize);
 end;
end;

function tdbcol.loadfield(const buffer: pointer): boolean;
var
 int1: integer;
begin
 int1:= 0;
 result:= fsqlresult.active;
 if result then begin
  result:= fsqlresult.fdatabase.loadfield(fsqlresult.fcursor,
             fdatatype,ffieldnum,buffer,int1);
 end;
end;

{ tlongintdbcol }

function tlongintdbcol.getasinteger: integer;
begin
 if not loadfield(@result) then begin
  result:= 0;
 end;
end;

{ tlargeintdbcol }

function tlargeintdbcol.getaslargeint: largeint;
begin
 if not loadfield(@result) then begin
  result:= 0;
 end;
end;

function tlargeintdbcol.getasinteger: integer;
begin
 result:= getaslargeint;
end;

{ tsmallintdbcol }

function tsmallintdbcol.getasinteger: integer;
var
 buf: smallint;
begin
 if not loadfield(@buf) then begin
  result:= 0;
 end
 else begin
  result:= buf;
 end;
end;

{ tworddbcol }

function tworddbcol.getasinteger: integer;
var
 buf: word;
begin
 if not loadfield(@buf) then begin
  result:= 0;
 end
 else begin
  result:= buf;
 end;
end;

{ tfloatdbcol }

function tfloatdbcol.getasfloat: double;
begin
 if not loadfield(@result) then begin
  result:= emptyreal;
 end;
end;

function tfloatdbcol.getascurrency: currency;
var
 do1: double;
begin
 if not loadfield(@do1) then begin
  result:= 0;
 end
 else begin
  result:= do1;
 end;
end;

{ tcurrencydbcol }

function tcurrencydbcol.getascurrency: currency;
begin
 if not loadfield(@result) then begin
  result:= 0;
 end;
end;

function tcurrencydbcol.getasfloat: double;
begin
 result:= getascurrency;
end;

{ tbooleandbcol }

function tbooleandbcol.getasboolean: boolean;
var
 buf: wordbool;
begin
 if not loadfield(@buf) then begin
  result:= false;
 end
 else begin
  result:= buf;
 end;
end;

{ tdatetimedbcol }

function tdatetimedbcol.getasdatetime: tdatetime;
begin
 if not loadfield(@result) then begin
  result:= emptydatetime;
 end
end;

{ tstringdbcol }

function tstringdbcol.getasstring: ansistring;
var
 int1: integer;
begin
 int1:= fdatasize*4+4; //room for multibyte encodings
 setlength(result,int1);
 if not loadfield(pointer(result),int1) then begin
  result:= '';
 end
 else begin
  if int1 < 0 then begin //too small
   int1:= -int1;
   setlength(result,int1);
   loadfield(pointer(result),int1);
  end;
  setlength(result,int1);
 end;
end;

{ tblobdbcol }

function tblobdbcol.getasstring: ansistring;
begin
 with fsqlresult do begin
  if active then begin
   result:= fdatabase.fetchblob(fcursor,ffieldnum);
  end
  else begin
   result:= '';
  end;
 end;
end;

{ tdbcols }

constructor tdbcols.create(const aname: ansistring);
begin
 fname:= aname;
 inherited create(tdbcol);
end;

function tdbcols.getitems(const index: integer): tdbcol;
begin
 result:= tdbcol (inherited getitems(index));
end;

procedure tdbcols.initfields(const asqlresult: tsqlresult;
                   const acursor: tsqlcursor; const afielddefs: tfielddefs);
var
 int1: integer;
 fdef1: tfielddef;
begin
 for int1:= 0 to afielddefs.count - 1 do begin
  fdef1:= afielddefs[int1];
  add(msedbcoltypeclasses[tfieldtypetotypety[fdef1.datatype]].
                                 create(asqlresult,acursor,fdef1));
 end;
end;

function tdbcols.findcol(const aname: ansistring): tdbcol;
var
 str1: ansistring;
 int1: integer;
begin
 str1:= uppercase(aname);
 for int1:= 0 to high(fitems) do begin
  result:= tdbcol(fitems[int1]);
  if result.fuppername = str1 then begin
   exit;
  end;
 end;
 result:= nil;
end;

function tdbcols.colbyname(const aname: ansistring): tdbcol;
begin
 result:= findcol(aname);
 if result = nil then begin
  raise edatabaseerror.create(fname+': col "'+aname+'" not found.');
 end;
end;

{ tsqlresult }

constructor tsqlresult.create(aowner: tcomponent);
begin
 fparams:= tmseparams.create(self);
 ffielddefs:= tfielddefs.create(nil);
 fsql:= tstringlist.create;
 fsql.onchange:= @onchangesql;
 fcols:= tdbcols.create(name);
 inherited;
end;

destructor tsqlresult.destroy;
begin
 active:= false;
 database:= nil;
 transaction:= nil;
 inherited;
 fsql.free;
 fparams.free;
 ffielddefs.free;
 fcols.free;
end;

procedure tsqlresult.setsql(const avalue: tstringlist);
begin
 fsql.assign(avalue);
end;

function tsqlresult.getactive: boolean;
begin
 result:= factive;
end;

procedure tsqlresult.setactive(avalue: boolean);
begin
 if csreading in componentstate then begin
  fopenafterread:= avalue;
 end
 else begin
  if factive <> avalue then begin
   if avalue then begin
    open;
   end
   else begin
    fopenafterread:= false;
    close;
   end;
  end;
 end;
end;

function tsqlresult.isutf8: boolean;
begin
 result:= (sro_utf8 in foptions);
 if fdatabase <> nil then begin
  fdatabase.updateutf8(result);
 end;
end;

procedure tsqlresult.setdatabase1(const avalue: tcustomsqlconnection);
begin
 setdatabase(avalue);
end;

procedure tsqlresult.setdatabase(const avalue: tmdatabase);
begin
 dosetsqldatabase(isqlclient(self),avalue,fcursor,fdatabase);
end;

function tsqlresult.getname: ansistring;
begin
 result:= name;
end;

function tsqlresult.getsqltransaction: tsqltransaction;
begin
 result:= ftransaction;
end;

procedure tsqlresult.setsqltransaction(const avalue: tsqltransaction);
begin
 ftransaction:= avalue;
end;

procedure tsqlresult.open;
begin
 prepare;
 execute;
 ffielddefs.clear;
 fdatabase.addfielddefs(fcursor,ffielddefs);
 fcols.initfields(self,fcursor,ffielddefs);
 factive:= true;
 next;
end;

procedure tsqlresult.close;
begin
 factive:= false;
 feof:= false;
 freefldbuffers;
 unprepare;
 ffielddefs.clear;
 fcols.clear;
end;

procedure tsqlresult.freefldbuffers;
begin
 if fcursor <> nil then begin
  tcustomsqlconnection(database).FreeFldBuffers(FCursor);
 end;
end;

procedure tsqlresult.unprepare;
begin
 CheckInactive(active,name);
 if IsPrepared  then begin
  with tcustomsqlconnection(Database) do begin
   UnPrepareStatement(FCursor);
  end;
 end;
end;

procedure tsqlresult.prepare;
var
 db: tcustomsqlconnection;
 trans: tsqltransaction;
 str1: ansistring;
begin
 if not isprepared then begin
  checkdatabase(name,fdatabase);
  checktransaction(name,ftransaction);
  str1:= trimright(fsql.text);
  if str1 = '' then begin
   raise edatabaseerror.create(name+': Empty query.');
  end;
  db:= tcustomsqlconnection(fdatabase);
  trans:= tsqltransaction(ftransaction);
  db.connected:= true;
  trans.active:= true;
  if not assigned(fcursor) then begin
   fcursor:= db.allocatecursorhandle(nil,name);
  end;
  fcursor.ftrans:= trans.handle;
  fcursor.fstatementtype:= stselect;
   
  Db.PrepareStatement(Fcursor,trans,str1,FParams);
  FCursor.FInitFieldDef:= True;
 end;
end;

procedure tsqlresult.setparams(const avalue: tmseparams);
begin
 fparams.assign(avalue);
end;

function tsqlresult.isprepared: boolean;
begin
 result:= (fcursor <> nil) and fcursor.fprepared;
end;

procedure tsqlresult.execute;
begin
 doexecute(fparams,ftransaction,fcursor,fdatabase);
end;

procedure tsqlresult.loaded;
begin
 inherited;
 active:= fopenafterread;
end;

procedure tsqlresult.onchangesql(sender: tobject);
var
 bo1: boolean;
begin
 bo1:= (csdesigning in componentstate) and active;
 if bo1 then begin
  active:= false;
 end;
 unprepare;
 fparams.parsesql(fsql.text,true);
 if bo1 then begin
  active:= true;
 end;
end;

procedure tsqlresult.next;
begin
 checkactive(active,name);
 if feof then begin
  raise edatabaseerror.create(name+': EOF.');
 end;
 feof:= not fdatabase.fetch(fcursor);
end;

procedure tsqlresult.refresh;
begin
 checkactive(active,name);
 fcursor.close;
 feof:= false;
 execute; 
 next;
end;

end.

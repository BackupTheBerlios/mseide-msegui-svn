{
    This file is part of the Free Pascal run time library.
    Copyright (c) 1999-2000 by Michael Van Canneyt, member of the
    Free Pascal development team
    
    Rewritten 2006-2007 by Martin Schreiber
    
    BufDataset implementation

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
 
unit msebufdataset;
 
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface 

uses
 db,classes,variants,msetypes,msearrayprops,mseclasses,mselist,msestrings,
 msedb;
  
const
 defaultpacketrecords = 10;
 integerindexfields = [ftsmallint,ftinteger,ftword,ftboolean];
 largeintindexfields = [ftlargeint];
 floatindexfields = [ftfloat,ftdatetime,ftdate,fttime];
 currencyindexfields = [ftcurrency,ftbcd];
 stringindexfields = [ftstring,ftfixedchar];
 indexfieldtypes =  integerindexfields+largeintindexfields+floatindexfields+
                    currencyindexfields+stringindexfields;
 dsbuffieldkinds = [fkcalculated,fklookup];
 bufferfieldkinds = [fkdata];
 
 dscheckfilter = ord(high(tdatasetstate)) + 1; 
 
const
 bufstreambuffersize = 4096; 
  
type  
 fieldinfoty = record
  offset: integer; //data offset in buffer     ////
  size: integer;   //size in buffer              //  checked by save/restore
  fieldtype:  tfieldtype;                        //
  dbfieldsize: integer; //maxsize of dbfield   ////
  field: tfield; //last!
 end;
 fieldinfoarty = array of fieldinfoty;
 
 fielddataty = record
  nullmask: array[0..0] of byte; //variable length
                                 //fielddata following
 end;
 
 blobcacheinfoty = record
  id: int64;
  data: string;
 end;
 blobcacheinfoarty = array of blobcacheinfoty;
   
 blobinfoty = record
  field: tfield;
  data: pointer;
  datalength: integer;
  new: boolean;
 end;
 
 pblobinfoty = ^blobinfoty;
 blobinfoarty = array of blobinfoty;
 pblobinfoarty = ^blobinfoarty;

 blobstreamfixinfoty = record
  id: int64;
  new: boolean;
  current: boolean;
 end;
 blobstreaminfoty = record
  info: blobstreamfixinfoty;
  data: string;
 end;
 
 recheaderty = record
  blobinfo: blobinfoarty;
  fielddata: fielddataty;   
 end;
 precheaderty = ^recheaderty;
   
 intheaderty = record
 end;

 intrecordty = record              
  intheader: intheaderty;
  header: recheaderty;      
 end;
 pintrecordty = ^intrecordty;

 bookmarkdataty = record
  recno: integer;
  recordpo: pintrecordty;
 end;
 pbookmarkdataty = ^bookmarkdataty;
 
 bufbookmarkty = record
  data: bookmarkdataty;
  flag : tbookmarkflag;
 end;
 pbufbookmarkty = ^bufbookmarkty;

 dsheaderty = record
  bookmark: bufbookmarkty;
 end;
 dsrecordty = record
  dsheader: dsheaderty;
  header: recheaderty;
 end;
 pdsrecordty = ^dsrecordty;
 
const
 intheadersize = sizeof(intrecordty.intheader);
 dsheadersize = sizeof(dsrecordty.dsheader);
     
// structure of internal recordbuffer:
//                 +---------<frecordsize>---------+
// intrecheaderty, |recheaderty,fielddata          |
//                 |moved to tdataset buffer header|
//                 |fieldoffsets are in ffieldinfos[].offset
//                 |                               |
// structure of dataset recordbuffer:
//                 +----------------------<fcalcrecordsize>----------+
//                 +---------<frecordsize>---------+                 |
// dsrecheaderty,  |recheaderty,fielddata          |calcfields       |
//                 |moved to internal buffer header|                 | 
//                 |<-field offsets are in ffieldinfos[].offset      |
//                 |<-calcfield offsets are in fcalcfieldbufpositions|

type
 indexty = record
  ind: pointerarty;
 end;
 pindexty = ^indexty;

 tmsebufdataset = class;
 
 logflagty = (lf_end,lf_rec,lf_update,lf_cancel,lf_apply);
 reclogheaderty = record
  kind: tupdatekind;
  po: pointer;
 end;
 updatelogheaderty = record
  logging: boolean;
  kind: tupdatekind;
  po: pointer;
  deletedrecord: pintrecordty;
 end;
 logbufferheaderty = record
  case flag: logflagty of
   lf_rec: (
    rec: reclogheaderty;
   );
   lf_update,lf_cancel,lf_apply: (
    update: updatelogheaderty;
   );
 end;
 
 tbufstreamwriter = class
  private
   fstream: tstream;
   fowner: tmsebufdataset;
   fbuffer: array [0..bufstreambuffersize-1] of byte;
   fbufindex: integer;
   procedure flushbuffer;
  public
   constructor create(const aowner: tmsebufdataset; const astream: tstream);
   destructor destroy; override;
   procedure write(const buffer; length: integer);
   procedure writefielddata(const data: precheaderty;
                          const aindex: integer);
   procedure writestring(const avalue: string);
   procedure writemsestring(const avalue: msestring);
   procedure writeinteger(const avalue: integer);
   procedure writepointer(const avalue: pointer);
   
   procedure writefielddef(const afielddef: tfielddef);
   procedure writelogbufferheader(const aheader: logbufferheaderty);
   procedure writeendmarker;
 end;

 tbufstreamreader = class
  private
   fstream: tstream;
   fowner: tmsebufdataset;
   fbuffer: array [0..bufstreambuffersize-1] of byte;
   fbuflen: integer;
   fbufindex: integer;
  public
   constructor create(const aowner: tmsebufdataset; const astream: tstream);
   function read(out buffer; length: integer): integer;
   procedure readbuffer(out buffer; const length: integer);
   procedure readfielddata(const data: precheaderty; const aindex: integer);
   function readstring: string;
   function readmsestring: msestring;
   function readinteger: integer;
   function readpointer: pointer;
   procedure readfielddef(const aowner: tfielddefs);
   function readlogbufferheader(out aheader: logbufferheaderty): boolean;
                    //false if eof or lf_end
   procedure readrecord(const arecord: pintrecordty);
 end;
 
  TResolverErrorEvent = procedure(Sender: TObject; DataSet: tmsebufdataset;
                          E: EUpdateError; UpdateKind: TUpdateKind;
                           var Response: TResolverResponse) of object;
  
 tblobbuffer = class(tmemorystream)
  private
   fowner: tmsebufdataset;
   ffield: tfield;
  public
   constructor create(const aowner: tmsebufdataset; const afield: tfield);
   destructor destroy; override;
 end;

 tblobcopy = class(tmemorystream)
  public
   constructor create(const ablob: blobinfoty);
   destructor destroy; override;
 end;

 indexfieldoptionty = (ifo_desc,ifo_caseinsensitive);
 indexfieldoptionsty = set of indexfieldoptionty;
 
 tindexfield = class(townedpersistent)
  private
   ffieldname: string;
   foptions: indexfieldoptionsty;
   procedure change;
   procedure setfieldname(const avalue: string);
   procedure setoptions(const avalue: indexfieldoptionsty);
  published
   property fieldname: string read ffieldname write setfieldname;
   property options: indexfieldoptionsty read foptions write setoptions;
 end;

 localindexoptionty = (lio_desc);
 localindexoptionsty = set of localindexoptionty;

 tlocalindex = class;  
 
 tindexfields = class(townedpersistentarrayprop)
  private
   function getitems(const index: integer): tindexfield;
  public
   constructor create(const aowner: tlocalindex); reintroduce;
   property items[const index: integer]: tindexfield read getitems; default;
 end;

 intrecordpoaty = array[0..0] of pintrecordty;
 pintrecordpoaty = ^intrecordpoaty;
 indexfieldinfoty = record
  comparefunc: arraysortcomparety;
  vtype: integer;
  recoffset: integer;
  fieldindex: integer;
  desc: boolean;
  caseinsensitive: boolean;
  canpartialstring: boolean;
 end;
 indexfieldinfoarty = array of indexfieldinfoty;
  
 tlocalindex = class(townedpersistent)
  private
   ffields: tindexfields;
   foptions: localindexoptionsty;
   fsortarray: pintrecordpoaty;
   findexfieldinfos: indexfieldinfoarty;
   procedure change;
   procedure setoptions(const avalue: localindexoptionsty);
   procedure setfields(const avalue: tindexfields);
   function compare(l,r: pintrecordty; const alastindex: integer;
                                  const apartialstring: boolean): integer;
   procedure quicksort(l,r: integer);
   procedure sort(var adata: pointerarty);
   function getactive: boolean;
   procedure setactive(const avalue: boolean);
   procedure bindfields;
   function findboundary(const arecord: pintrecordty;
                 const alastindex: integer; const abigger: boolean): integer;
                          //returns index of next bigger or lower
   function findrecord(const arecord: pintrecordty): integer;
                         //returns index, -1 if not found
  public
   constructor create(aowner: tobject); override;
   destructor destroy; override;
   function find(const avalues: array of const; const aisnull: array of boolean;
                 //itemcount of avalues can be smaller than fields count in index
               out abookmark: string;
               const abigger: boolean = false;
               const partialstring: boolean = false): boolean; overload;
                //true if found else nearest lower or bigger,
                //abookmark = '' if no lower or bigger found
                //string values must be msestring
   function find(const avalues: array of const; const aisnull: array of boolean;
                 //itemcount of avalues can be smaller than fields count in index   
                const alast: boolean = false;
                const partialstring: boolean = false): boolean; overload;
                //sets dataset cursor if found
   function getbookmark(const arecno: integer): string;
  published
   property fields: tindexfields read ffields write setfields;
   property options: localindexoptionsty read foptions write setoptions;
   property active: boolean read getactive write setactive default false;
 end;
 
 tlocalindexes = class(townedpersistentarrayprop)
  private
   function getitems(const index: integer): tlocalindex;
   procedure bindfields;
   function getactiveindex: integer;
   procedure setactiveindex(const avalue: integer);
  protected
   procedure checkinactive;
   procedure setcount1(acount: integer; doinit: boolean); override;
 public
   constructor create(const aowner: tmsebufdataset); reintroduce;
   procedure move(const curindex,newindex: integer); override;
   property items[const index: integer]: tlocalindex read getitems; default;
   property activeindex: integer read getactiveindex write setactiveindex;
                       //-1 > none
 end;
  
type
 
 recupdatebufferty = record
  updatekind: tupdatekind;
  bookmark: bookmarkdataty;
  oldvalues: pintrecordty;
 end;
 precupdatebufferty = ^recupdatebufferty;

 recupdatebufferarty = array of recupdatebufferty;
 
 bufdatasetstatety = (bs_opening,bs_loading,bs_fetching,bs_applying,
                      bs_connected,
                      bs_hasindex,bs_fetchall,
                      bs_blobsfetched,bs_blobscached,bs_blobssorted,
                      bs_indexvalid,
                      bs_editing,bs_append,bs_internalcalc,bs_utf8,
                      bs_hasfilter,bs_visiblerecordcountvalid);
 bufdatasetstatesty = set of bufdatasetstatety;

 internalcalcfieldseventty = procedure(const sender: tmsebufdataset;
                                              const fetching: boolean) of object;
 tmsebufdataset = class(tdbdataset)
  private
   fbrecordcount: integer;
   fpacketrecords: integer;
   fopen: boolean;
   fupdatebuffer: recupdatebufferarty;
   fcurrentupdatebuffer: integer;

   frecordsize: integer;
   fnullmasksize: integer;
   fcalcfieldcount: integer;
   finternalcalcfieldcount: integer;
   ffieldinfos: fieldinfoarty;
   fstringpositions: integerarty;
   
   fcalcrecordsize: integer;
   fcalcnullmasksize: integer;
   fcalcfieldbufpositions: integerarty;
   fcalcfieldsizes: integerarty;
   fcalcstringpositions: integerarty;
   
   fbuffercountbefore: integer;
   fonupdateerror: tresolvererrorevent;

   femptybuffer: pintrecordty;
   ffilterbuffer: pdsrecordty;
   fcheckfilterbuffer: pdsrecordty;
   fnewvaluebuffer: pdsrecordty; //buffer for applyupdates
   
   factindexpo: pindexty;    
   findexlocal: tlocalindexes;
   factindex: integer;
   foninternalcalcfields: internalcalcfieldseventty;
   fvisiblerecordcount: integer;
   floadingstream: tstream;
   
   flogfilename: filenamety;
   flogger: tbufstreamwriter;
   procedure calcrecordsize;
   procedure alignfieldpos(var avalue: integer);
   function loadbuffer(var buffer: recheaderty): tgetresult;
   function getfieldsize(const datatype: tfieldtype; 
                                   out isstring: boolean) : longint;
   function getrecordupdatebuffer: boolean;
   procedure setpacketrecords(avalue: integer);
   function  intallocrecord: pintrecordty;    
   procedure finalizestrings(var header: recheaderty);
   procedure finalizecalcstrings(var header: recheaderty);
   procedure finalizechangedstrings(const tocompare: recheaderty; 
                                      var tofinalize: recheaderty);
   procedure addrefstrings(var header: recheaderty);
   procedure intfinalizerecord(const buffer: pintrecordty);
   procedure intfreerecord(var buffer: pintrecordty);

   procedure clearindex;
   procedure checkindexsize;    
   function appendrecord(const arecord: pintrecordty): integer;
             //returns new recno
   function insertrecord(arecno: integer; const arecord: pintrecordty): integer;
             //returns new recno
   procedure deleterecord(const arecno: integer); overload;
   procedure deleterecord(const arecord: pintrecordty); overload;
   procedure getnewupdatebuffer;
   procedure setindexlocal(const avalue: tlocalindexes);
   function insertindexrefs(const arecord: pintrecordty): integer;
              //returns new recno of active index
   procedure removeindexrefs(const arecord: pintrecordty);
   function remove0indexref(const arecord: pintrecordty): integer;
                    //returns index
   procedure internalsetrecno(const avalue: integer);
   procedure setactindex(const avalue: integer);
   procedure checkindex(const force: boolean);
   
   function getfieldbuffer(const afield: tfield;
             out buffer: pointer; out datasize: integer): boolean; overload; 
             //read, true if not null
   function getfieldbuffer(const afield: tfield;
             const isnull: boolean; out datasize: integer): pointer; overload;
             //write
   function getmsestringdata(const sender: tmsestringfield; 
                               out avalue: msestring): boolean;
   procedure setmsestringdata(const sender: tmsestringfield; const avalue: msestring);
   procedure setoninternalcalcfields(const avalue: internalcalcfieldseventty);
   procedure checkfilterstate;
   procedure openlocal;
   procedure dointernalopen;
   procedure doloadfromstream;
   procedure dointernalclose;
   procedure logupdatebuffer(const awriter: tbufstreamwriter; 
            const abuffer: recupdatebufferty; const adeletedrecord: pintrecordty;
            const alogging: boolean; const alogmode: logflagty);
   procedure logrecbuffer(const awriter: tbufstreamwriter; 
                         const akind: tupdatekind; const abuffer: pintrecordty);
  protected
   fbstate: bufdatasetstatesty;
   fallpacketsfetched : boolean;
   fapplyindex: integer; //take care about canceled updates while applying
   ffailedcount: integer;
   frecno: integer; //null based
   findexes: array of indexty;
   fblobcache: blobcacheinfoarty;
   fblobcount: integer;
   fcurrentbuf: pintrecordty;

   function findcachedblob(var info: blobcacheinfoty): boolean; overload;
   function findcachedblob(const id: int64; 
                           out info: blobcacheinfoty): boolean; overload;
   function addblobcache(const adata: pointer;
                    const alength: integer): integer; overload;
   function addblobcache(const aid: int64; const adata: string): integer; overload;
   procedure updatestate;
   function getintblobpo: pblobinfoarty; //in currentrecbuf
   procedure internalcancel; override;
   procedure cancelrecupdate(var arec: recupdatebufferty);
   procedure setdatastringvalue(const afield: tfield; const avalue: string);
   procedure setcurvalue(const afield: tfield; const avalue: int64);

   function wantblobfetch: boolean; virtual;
   procedure resetblobcache;
   procedure sortblobcache;   
   procedure fetchblobs;
   procedure fetchallblobs;
   procedure getofflineblob(const data: precheaderty; const aindex: integer;
                                   out ainfo: blobstreaminfoty);
   procedure setofflineblob(const adata: precheaderty; const aindex: integer;
                                   const ainfo: blobstreaminfoty);
   function getblobrecpo: precheaderty;
   function createblobstream(field: tfield;
                                     mode: tblobstreammode): tstream; override;
   procedure internalapplyupdate(const maxerrors: integer;
                const cancelonerror: boolean; var response: tresolverresponse);
   procedure afterapply; virtual;
   procedure freeblob(const ablob: blobinfoty);
   procedure freeblobs(var ablobs: blobinfoarty);
   procedure deleteblob(var ablobs: blobinfoarty; const aindex: integer); overload;
   procedure deleteblob(var ablobs: blobinfoarty; const afield: tfield); overload;
   procedure addblob(const ablob: tblobbuffer);
   
   procedure setrecno1(value: longint; const nocheck: boolean);
   procedure setrecno(value: longint); override;
   function  getrecno: longint; override;
   function getchangecount: integer; virtual;
   function  allocrecordbuffer: pchar; override;
   procedure clearcalcfields(buffer: pchar); override;
   procedure freerecordbuffer(var buffer: pchar); override;
   procedure internalinitrecord(buffer: pchar); override;
   function  getcanmodify: boolean; override;
   function getrecord(buffer: pchar; getmode: tgetmode;
                                   docheck: boolean): tgetresult; override;
   function bookmarktostring(const abookmark: bookmarkdataty): string;
   procedure checkrecno(const avalue: integer);
   procedure setonfilterrecord(const value: tfilterrecordevent); override;
   procedure setfiltered(value: boolean); override;

   procedure loaded; override;                              
   procedure internalopen; override;
   procedure internalclose; override;
   procedure clearbuffers; override;
   procedure internalinsert; override;
   procedure internaledit; override;
   procedure dataevent(event: tdataevent; info: ptrint); override;
   procedure checkconnected;
   procedure startlogger;
   procedure closelogger;
   procedure savestate(const awriter: tbufstreamwriter);
 
   function  getfieldclass(fieldtype: tfieldtype): tfieldclass; override;
   function getnextpacket(const all: boolean) : integer;
   function getrecordsize: word; override;
   procedure internalpost; override;
   procedure internaldelete; override;
   procedure internalfirst; override;
   procedure internallast; override;
   procedure internalsettorecord(buffer: pchar); override;
   procedure internalgotobookmark(abookmark: pointer); override;
   procedure setbookmarkdata(buffer: pchar; data: pointer); override;
   procedure setbookmarkflag(buffer: pchar; value: tbookmarkflag); override;
   procedure getbookmarkdata(buffer: pchar; data: pointer); override;
   function getbookmarkflag(buffer: pchar): tbookmarkflag; override;
   function getfielddata(field: tfield; buffer: pointer;
                       nativeformat: boolean): boolean; override;
   function getfielddata(field: tfield; buffer: pointer): boolean; override;
   function getfieldblobid(const field: tfield; out aid: blobidty): boolean;
                    //false if null
   procedure setfielddata(field: tfield; buffer: pointer;
                                    nativeformat: boolean); override;
   procedure setfielddata(field: tfield; buffer: pointer); override;
   function iscursoropen: boolean; override;
   function  getrecordcount: longint; override;
   procedure applyrecupdate(updatekind : tupdatekind); virtual;
   procedure setonupdateerror(const avalue: tresolvererrorevent);
   property actindex: integer read factindex write setactindex;
   function findrecord(arecordpo: pintrecordty): integer;
                         //returns index, -1 if not found
   procedure dofilterrecord(var acceptable: boolean); virtual;
   function islocal: boolean; virtual;

 {abstracts, must be overidden by descendents}
   function fetch : boolean; virtual; abstract;
   function getblobdatasize: integer; virtual; abstract;
   function blobscached: boolean; virtual; abstract;
   function loadfield(const afield: tfield; const buffer: pointer;
                    var bufsize: integer): boolean; virtual; abstract;
           //if bufsize < 0 -> buffer was to small, should be -bufsize
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   procedure Append;

   procedure recover; //loads from logfile
   procedure savetostream(const astream: tstream);
   procedure loadfromstream(const astream: tstream);
   procedure savetofile(const afilename: filenamety);
   procedure loadfromfile(const afilename: filenamety);
   function streamloading: boolean;
   
   function isutf8: boolean; virtual;
   procedure bindfields(const bind: boolean);
   procedure fieldtoparam(const source: tfield; const dest: tparam);
   procedure oldfieldtoparam(const source: tfield; const dest: tparam);
   procedure stringtoparam(const source: msestring; const dest: tparam);
                  //takes care about utf8 conversion
   procedure clearrecord;
   procedure beginfilteredit;
   procedure endfilteredit;
   procedure filterchanged;
   function countvisiblerecords: integer;
   procedure fetchall;
   procedure resetindex; //deactivates all indexes
   function createblobbuffer(const afield: tfield): tblobbuffer;
   procedure applyupdates(const maxerrors: integer = 0); virtual; overload;
   procedure applyupdates(const maxerrors: integer;
                   const cancelonerror: boolean); virtual; overload;
   procedure applyupdate(const cancelonerror: boolean); virtual; overload;
   procedure applyupdate; virtual; overload;
                   //applies current record
   procedure cancelupdates; virtual;
   procedure cancelupdate; virtual; //cancels current record
//    function locate(const keyfields: string; const keyvalues: variant; options: tlocateoptions) : boolean; override;
   function updatestatus: tupdatestatus; override;
   property changecount : integer read getchangecount;
  published
   property logfilename: filenamety read flogfilename write flogfilename;
   property packetrecords : integer read fpacketrecords write setpacketrecords 
                                 default defaultpacketrecords;
   property onupdateerror: tresolvererrorevent read fonupdateerror 
                                 write setonupdateerror;
   property oninternalcalcfields: internalcalcfieldseventty 
                      read foninternalcalcfields write setoninternalcalcfields;
   property indexlocal: tlocalindexes read findexlocal write setindexlocal;
  end;
   
function getfieldisnull(nullmask: pbyte; const x: integer): boolean;

implementation
uses
 rtlconsts,dbconst,msedatalist,sysutils,mseformatstr,msereal,msestream,msesys,
 msefileutils;
{$ifdef FPC_2_2}
const
 snotineditstate = 
 'Operation not allowed, dataset "%s" is not in an edit or insert state.';
            //name changed in FPC 2_2
{$endif}

type
 tmsestringfield1 = class(tmsestringfield); 
 tmseblobfield1 = class(tmseblobfield);
  
 TFieldcracker = class(TComponent)
  private
   FAlignMent : TAlignment;
   FAttributeSet : String;
   FCalculated : Boolean;
   FConstraintErrorMessage : String;
   FCustomConstraint : String;
   FDataSet : TDataSet;
//    FDataSize : Word;
   FDataType : TFieldType;
   FDefaultExpression : String;
   FDisplayLabel : String;
   FDisplayWidth : Longint;
   FFieldKind : TFieldKind;
   FFieldName : String;
   FFieldNo : Longint;
 end;
   
function compblobcache(const a,b): integer;
var
 lint1: int64;
begin
 lint1:= blobcacheinfoty(a).id - blobcacheinfoty(b).id;
 result:= 0;
 if lint1 < 0 then begin
  result:= -1;
 end
 else begin
  if lint1 > 0 then begin
   result:= 1;
  end;
 end;
end;

function compinteger(const l,r): integer;
begin
 result:= integer(l) - integer(r);
end;

function compint64(const l,r): integer;
begin
 if int64(l) > int64(r) then begin
  result:= 1;
 end
 else begin
  if int64(l) = int64(r) then begin
   result:= 0;
  end
  else begin
   result:= -1;
  end;
 end;
end;

function compfloat(const l,r): integer;
begin
 result:= 0;
 if double(l) > double(r) then begin
  inc(result);
 end
 else begin
  if double(l) < double(r) then begin
   dec(result);
  end;
 end;
end;

function compcurrency(const l,r): integer;
begin
 result:= 0;
 if currency(l) > currency(r) then begin
  inc(result);
 end
 else begin
  if currency(l) < currency(r) then begin
   dec(result);
  end;
 end;
end;

function compstring(const l,r): integer;
begin
 result:= msecomparestr(msestring(l),msestring(r));
end;

function compstringi(const l,r): integer;
begin
 result:= msecomparetext(msestring(l),msestring(r));
end;

type
 fieldcomparekindty = (fct_integer,fct_largeint,fct_float,fct_currency,fct_text);
 fieldcompareinfoty = record
  datatypes: set of tfieldtype;
  cvtype: integer;
  compfunc: arraysortcomparety;
  compfunci: arraysortcomparety;
 end;
const
 comparefuncs: array[fieldcomparekindty] of fieldcompareinfoty = 
  ((datatypes: integerindexfields; cvtype: vtinteger; compfunc: @compinteger;
                                   compfunci: @compinteger),
   (datatypes: largeintindexfields; cvtype: vtint64; compfunc: @compint64;
                                   compfunci: @compint64),
   (datatypes: floatindexfields; cvtype: vtextended; compfunc: @compfloat;
                                 compfunci: @compfloat),
   (datatypes: currencyindexfields; cvtype: vtcurrency; compfunc: @compcurrency;
                                    compfunci: @compcurrency),
   (datatypes: stringindexfields; cvtype: vtwidestring; compfunc: @compstring;
                                  compfunci: @compstringi));
const
 ormask:  array[0..7] of byte = (%00000001,%00000010,%00000100,%00001000,
                                 %00010000,%00100000,%01000000,%10000000);
 andmask: array[0..7] of byte = (%11111110,%11111101,%11111011,%11110111,
                                 %11101111,%11011111,%10111111,%01111111);
          
procedure unsetfieldisnull(nullmask: pbyte; const x: integer);
var
 int1: integer;
begin
 inc(nullmask,(x shr 3));
 nullmask^:= nullmask^ or ormask[x and 7];
end;

procedure setfieldisnull(nullmask: pbyte; const x: integer);
begin
 inc(nullmask,(x shr 3));
 nullmask^:= nullmask^ and andmask[x and 7];
end;

function getfieldisnull(nullmask: pbyte; const x: integer): boolean;
begin
 inc(nullmask,(x shr 3));
 result:= nullmask^ and ormask[x and 7] = 0;
end;


{ tbufstreamwriter }

constructor tbufstreamwriter.create(const aowner: tmsebufdataset; 
                                            const astream: tstream);
begin
 fowner:= aowner;
 fstream:= astream;
end;

destructor tbufstreamwriter.destroy;
begin
 flushbuffer;
 inherited;
end;

procedure tbufstreamwriter.flushbuffer;
begin
 fstream.writebuffer(fbuffer,fbufindex);
 fbufindex:= 0;
end;

procedure tbufstreamwriter.write(const buffer; length: integer);
var
 po1: pointer;
 int1: integer;
begin
 po1:= @buffer;
 while length > 0 do begin
  int1:= length;
  if int1 + fbufindex > bufstreambuffersize then begin
   int1:= bufstreambuffersize - fbufindex;
  end;
  move(po1^,fbuffer[fbufindex],int1);
  inc(fbufindex,int1);
  if fbufindex >= bufstreambuffersize then begin
   flushbuffer;
  end;
  inc(po1,int1);
  dec(length,int1);
 end;
end;

procedure tbufstreamwriter.writefielddata(const data: precheaderty; 
                                                    const aindex: integer);
var
 fielddata: pointer;
 blobinfo: blobstreaminfoty;
begin
 with fowner.ffieldinfos[aindex] do begin
  fielddata:= pointer(data) + offset;
  case fieldtype of
   ftstring,ftfixedchar: begin
    writemsestring(msestring(fielddata^));
   end;
   ftmemo,ftblob,ftgraphic: begin
    if not getfieldisnull(@data^.fielddata.nullmask,aindex) then begin
     fowner.getofflineblob(data,aindex,blobinfo);
     write(blobinfo.info,sizeof(blobinfo.info));
     writestring(blobinfo.data);
    end;
   end;
   else begin
    write(fielddata^,size);
   end;
  end;
 end; 
end;

procedure tbufstreamwriter.writestring(const avalue: string);
begin
 writeinteger(length(avalue));
 write(pointer(avalue)^,length(avalue));
end;

procedure tbufstreamwriter.writemsestring(const avalue: msestring);
begin
 writeinteger(length(avalue));
 write(pointer(avalue)^,length(avalue)*sizeof(msechar));
end;

procedure tbufstreamwriter.writeinteger(const avalue: integer);
begin
 write(avalue,sizeof(integer));
end;

procedure tbufstreamwriter.writefielddef(const afielddef: tfielddef);
begin
 with afielddef do begin
  writestring(name);
  writeinteger(ord(datatype));  
  writeinteger(size);
  writeinteger(integer(required));
  writeinteger(fieldno);
  writeinteger(precision);
 end;
end;

procedure tbufstreamwriter.writelogbufferheader(
                                const aheader: logbufferheaderty);
begin
 write(aheader,sizeof(aheader));
end;

procedure tbufstreamwriter.writeendmarker;
var
 abuffer: logbufferheaderty;
begin
 fillchar(abuffer,sizeof(abuffer),0);
 abuffer.flag:= lf_end;
 write(abuffer,sizeof(abuffer));
end;

procedure tbufstreamwriter.writepointer(const avalue: pointer);
begin
 write(avalue,sizeof(pointer));
end;

{ tbufstreamreader }

constructor tbufstreamreader.create(const aowner: tmsebufdataset; 
                                               const astream: tstream);
begin
 fowner:= aowner;
 fstream:= astream;
end;

function tbufstreamreader.read(out buffer; length: integer): integer;
var
 po1: pointer;
 int1: integer;
begin
 po1:= @buffer;
 result:= 0;
 while length > 0 do begin
  int1:= length;
  if int1 + fbufindex >= fbuflen then begin
   int1:= fbuflen - fbufindex;
  end;
  move(fbuffer[fbufindex],po1^,int1);
  inc(po1,int1);
  inc(result,int1);
  dec(length,int1);
  inc(fbufindex,int1);
  if fbufindex >= fbuflen then begin
   fbufindex:= 0;
   fbuflen:= fstream.read(fbuffer,bufstreambuffersize);
   if fbuflen = 0 then begin
    exit;        //eof
   end;
  end; 
 end;
end;

procedure tbufstreamreader.readbuffer(out buffer; const length: integer);
begin
 if read(buffer,length) < length then begin
  raise ereaderror.create(sreaderror);
 end;
end;

procedure tbufstreamreader.readfielddata(const data: precheaderty; 
                         const aindex: integer);
var
 fielddata: pointer;
 blobinfo: blobstreaminfoty;
begin
 with fowner.ffieldinfos[aindex] do begin
  fielddata:= pointer(data) + offset;
  case fieldtype of
   ftstring,ftfixedchar: begin
    msestring(fielddata^):= readmsestring;
   end;
   ftmemo,ftblob,ftgraphic: begin
    if not getfieldisnull(@data^.fielddata.nullmask,aindex) then begin
     readbuffer(blobinfo.info,sizeof(blobinfo.info));
     blobinfo.data:= readstring;
     fowner.setofflineblob(data,aindex,blobinfo);
    end;
   end;
   else begin
    readbuffer(fielddata^,size);
   end;
  end;
 end;
end;

function tbufstreamreader.readstring: string;
var
 int1: integer;
begin
 int1:= readinteger;
 setlength(result,int1);
 readbuffer(pointer(result)^,int1);
end;

function tbufstreamreader.readmsestring: msestring;
var
 int1: integer;
begin
 int1:= readinteger;
 setlength(result,int1);
 readbuffer(pointer(result)^,int1*sizeof(msechar));
end;

function tbufstreamreader.readinteger: integer;
begin
 readbuffer(result,sizeof(integer));
end;

procedure tbufstreamreader.readfielddef(const aowner: tfielddefs);
var
 name: string;
 datatype: tfieldtype;
 size: integer;
 required: boolean;
 fieldno: integer;
 precision: integer; 
 def1: tfielddef;
begin
 name:= readstring;
 datatype:= tfieldtype(readinteger);  
 size:= readinteger;
 if datatype in blobfields then begin
  size:= fowner.getblobdatasize;
 end;
 required:= boolean(readinteger);
 fieldno:= readinteger;
 precision:= readinteger;
 def1:= tfielddef.create(aowner,name,datatype,size,required,fieldno);
 def1.precision:= precision;
end;

function tbufstreamreader.readlogbufferheader(
                      out aheader: logbufferheaderty): boolean;
begin
 result:= (read(aheader,sizeof(aheader)) = sizeof(aheader)) and 
          (aheader.flag <> lf_end);
end;

function tbufstreamreader.readpointer: pointer;
begin
 readbuffer(result,sizeof(pointer));
end;

type
 bufdattagty = array[0..15]of char;
 tbsfheaderty = packed record
  tag: bufdattagty;
  byteorder: byte;      //0 -> little endian, 1 - big endian
  version: integer;
  fieldcount: integer;
  fielddefcount: integer;
  recordcount: integer;
 end;
 
procedure tbufstreamreader.readrecord(const arecord: pintrecordty);
var
 int1: integer;
 datapo: precheaderty;
begin
 datapo:= @arecord^.header;
 readbuffer(datapo^.fielddata,fowner.fnullmasksize);
 for int1:= 0 to high(fowner.ffieldinfos) do begin
  readfielddata(datapo,int1);
 end;
end;

{ tblobbuffer }

constructor tblobbuffer.create(const aowner: tmsebufdataset; const afield: tfield);
begin
 fowner:= aowner;
 ffield:= afield;
 inherited create;
end;

destructor tblobbuffer.destroy;
begin
 fowner.addblob(self);
 setpointer(nil,0);
 inherited;
end;

{ tblobcopy }

constructor tblobcopy.create(const ablob: blobinfoty);
begin
 inherited create;
 setpointer(ablob.data,ablob.datalength);
end;

destructor tblobcopy.destroy;
begin
 setpointer(nil,0);
 inherited;
end;

{ tmsebufdataset }

constructor tmsebufdataset.Create(AOwner : TComponent);
begin
 frecno:= -1;
 findexlocal:= tlocalindexes.create(self);
 packetrecords:= defaultpacketrecords;
 inherited;
 bookmarksize := sizeof(bufbookmarkty);
end;

destructor tmsebufdataset.destroy;
begin
 inherited destroy;
 findexlocal.free;
 closelogger;
end;

procedure tmsebufdataset.setpacketrecords(avalue : integer);
begin
 if (avalue = 0) then begin
  databaseerror('Packetrecords can not be 0.'{sinvpacketrecordsvalue});
 end;
 fpacketrecords:= avalue;
 updatestate;
end;

Function tmsebufdataset.GetCanModify: Boolean;
begin
 result:= false;
end;

function tmsebufdataset.intallocrecord: pintrecordty;
begin
 result:= allocmem(frecordsize+intheadersize);
 fillchar(result^,frecordsize+intheadersize,0);
 {
 fillchar(result^,sizeof(intrecordty),0);
 for int1:= high(fstringpositions) downto 0 do begin
  pointer(pointer(@result^.header)+fstringpositions[int1])^):= nil;
 end;
 }
end;

procedure tmsebufdataset.finalizestrings(var header: recheaderty);
var
 int1: integer;
begin
 for int1:= high(fstringpositions) downto 0 do begin
  pmsestring(pointer(@header)+fstringpositions[int1])^:= '';
 end;
end;

procedure tmsebufdataset.finalizecalcstrings(var header: recheaderty);
var
 int1: integer;
begin
 for int1:= high(fcalcstringpositions) downto 0 do begin
  pmsestring(pointer(@header)+fcalcstringpositions[int1])^:= '';
 end;
end;

procedure tmsebufdataset.finalizechangedstrings(const tocompare: recheaderty; 
                                      var tofinalize: recheaderty);
var
 int1: integer;
begin
 for int1:= high(fstringpositions) downto 0 do begin
  if ppointer(pointer(@tocompare)+fstringpositions[int1])^ <>
     ppointer(pointer(@tofinalize)+fstringpositions[int1])^ then begin
   pmsestring(pointer(@tofinalize)+fstringpositions[int1])^:= '';
  end;
 end;
end;

procedure tmsebufdataset.addrefstrings(var header: recheaderty);
var
 int1: integer;
begin
 for int1:= high(fstringpositions) downto 0 do begin
  stringaddref(pmsestring(pointer(@header)+fstringpositions[int1])^);
 end;
end;

procedure tmsebufdataset.intfinalizerecord(const buffer: pintrecordty);
begin
 freeblobs(buffer^.header.blobinfo);
 finalizestrings(buffer^.header);
end;

procedure tmsebufdataset.intfreerecord(var buffer: pintrecordty);
begin
 if buffer <> nil then begin
  intfinalizerecord(buffer);  
  freemem(buffer);
  buffer:= nil;
 end;
end;

function tmsebufdataset.allocrecordbuffer: pchar;
begin
 result := allocmem(dsheadersize+fcalcrecordsize);
 initrecord(result);
end;

procedure tmsebufdataset.clearcalcfields(buffer: pchar);
var
 int1: integer;
begin
 with pdsrecordty(buffer)^ do begin
  for int1:= high(fcalcstringpositions) downto 0 do begin
   pmsestring(pointer(@header)+fcalcstringpositions[int1])^:= '';
  end;
  fillchar((pointer(@header)+frecordsize)^,fcalcrecordsize-frecordsize,0);
 end;
end;

procedure tmsebufdataset.freerecordbuffer(var buffer: pchar);
var
 int1: integer;
 bo1: boolean;
begin
 if buffer <> nil then begin
  with pdsrecordty(buffer)^,header do begin
{ there can be copies of invalid buffers
   bo1:= false;
   for int1:= high(blobinfo) downto 0 do begin
    if blobinfo[int1].new then begin
     freeblob(blobinfo[int1]);
     bo1:= true;
    end;
   end;
   if bo1 then begin
    blobinfo:= nil;
   end;
}
   finalizecalcstrings(header);
  end;
  reallocmem(buffer,0);
 end;
end;

function tmsebufdataset.getintblobpo: pblobinfoarty;
begin
 if bs_applying in fbstate then begin
  result:= @fnewvaluebuffer^.header.blobinfo;
 end
 else begin
  result:= @fcurrentbuf^.header.blobinfo;
 end;
end;

procedure tmsebufdataset.freeblob(const ablob: blobinfoty);
begin
 with ablob do begin
  if datalength > 0 then begin
   freemem(data);
  end;
 end;
end;

function tmsebufdataset.createblobbuffer(const afield: tfield): tblobbuffer;
begin
 result:= tblobbuffer.create(self,afield);
end;

procedure tmsebufdataset.addblob(const ablob: tblobbuffer);
var
 int1,int2: integer;
 bo1: boolean;
 po2: pointer;
begin
 bo1:= false;
 int2:= -1;
 with pdsrecordty(activebuffer)^.header do begin
  for int1:= high(blobinfo) downto 0 do begin
   with blobinfo[int1] do begin
    if new then begin
     bo1:= true;
    end;
    if field = ablob.ffield then begin
     int2:= int1;
    end;
   end;
  end;
  if not bo1 then begin //copy needed
   po2:= pointer(blobinfo);
   pointer(blobinfo):= nil;
   blobinfo:= copy(blobinfoarty(po2));
  end;
  if int2 >= 0 then begin
   deleteblob(blobinfo,int2);
  end;
  setlength(blobinfo,high(blobinfo)+2);
  with blobinfo[high(blobinfo)],ablob do begin
   data:= memory;
   reallocmem(data,size);
   datalength:= size;
   field:= ffield;
   new:= true;
   if size = 0 then begin
    setfieldisnull(fielddata.nullmask,field.fieldno-1);
   end
   else begin
    unsetfieldisnull(fielddata.nullmask,field.fieldno-1);
   end;
   if not (State in [dsCalcFields, dsFilter, dsNewValue]) then begin
    DataEvent(deFieldChange, Ptrint(Field));
   end;
  end;
 end;
end;

procedure tmsebufdataset.freeblobs(var ablobs: blobinfoarty);
var
 int1: integer;
begin
 for int1:= 0 to high(ablobs) do begin
  freeblob(ablobs[int1]);
 end;
 ablobs:= nil;
end;

procedure tmsebufdataset.deleteblob(var ablobs: blobinfoarty; const aindex: integer);
begin
 freeblob(ablobs[aindex]);
 deleteitem(ablobs,typeinfo(blobinfoarty),aindex); 
end;

procedure tmsebufdataset.deleteblob(var ablobs: blobinfoarty; 
                                              const afield: tfield);
var
 int1: integer;
begin
 for int1:= high(ablobs) downto 0 do begin
  if ablobs[int1].field = afield then begin
   freeblob(ablobs[int1]);
   deleteitem(ablobs,typeinfo(blobinfoarty),int1); 
   break;
  end;
 end;
end;

procedure tmsebufdataset.dointernalopen;
var
 int1: integer;
begin
 for int1:= 0 to fields.count - 1 do begin
  with fields[int1] do begin
   if (fieldkind = fkdata) and (fielddefs.indexof(fieldname) < 0) then begin
    databaseerrorfmt(sfieldnotfound,[fieldname],self);
   end;
  end;
 end;
 include(fbstate,bs_opening);
 if wantblobfetch then begin
  include(fbstate,bs_blobsfetched);
 end
 else begin 
  exclude(fbstate,bs_blobsfetched);
 end;
 if isutf8 then begin
  include(fbstate,bs_utf8);
 end
 else begin
  exclude(fbstate,bs_utf8);
 end;
 bindfields(true); //calculate calc fields size
 setlength(findexes,1+findexlocal.count);
 factindexpo:= @findexes[factindex];
 calcrecordsize;
 findexlocal.bindfields;
 femptybuffer:= intallocrecord;
 ffilterbuffer:= pdsrecordty(allocrecordbuffer);
 fnewvaluebuffer:= pdsrecordty(allocrecordbuffer);
 updatestate;
 fallpacketsfetched:= false;
 fopen:= true;
end;

procedure tmsebufdataset.internalopen;
begin
 if blobscached then begin
  include(fbstate,bs_blobscached);
 end
 else begin
  exclude(fbstate,bs_blobscached);
 end;
 if streamloading then begin
  doloadfromstream;
 end
 else begin
  dointernalopen;
 end;
end;

procedure tmsebufdataset.openlocal;
var
 bo1: boolean;
begin
 bo1:= false;
 if defaultfields then begin
  createfields;
 end;
 if (flogfilename <> '') and findfile(flogfilename) then begin
  floadingstream:= tmsefilestream.create(flogfilename,fm_read);
  try
   doloadfromstream
  finally
   floadingstream.free;
  end;
 end
 else begin
  dointernalopen;
  fallpacketsfetched:= true;
 end;
 if (flogfilename <> '') and not (csdesigning in componentstate) then begin
  startlogger;   
 end;
end;

procedure tmsebufdataset.dointernalclose;
var 
 int1: integer;
begin
 exclude(fbstate,bs_opening);
 closelogger;
 frecno:= -1;
 resetblobcache;
 if fopen then begin
  fopen:= false;
  with findexes[0] do begin
   for int1:= 0 to fbrecordcount - 1 do begin
    intfreerecord(ind[int1]);
   end;
  end;
  intfreerecord(femptybuffer);
  intfinalizerecord(@ffilterbuffer^.header);
  freerecordbuffer(pchar(ffilterbuffer));
 // pointer(fnewvaluebuffer^.header.blobinfo):= nil;
 // freerecordbuffer(pchar(fnewvaluebuffer));
  freemem(fnewvaluebuffer); //allways copied by move, needs no finalize
  for int1:= 0 to high(fupdatebuffer) do begin
   with fupdatebuffer[int1] do begin
    if bookmark.recordpo <> nil then begin
     intfreerecord(oldvalues);
    end;
   end;
  end;
  fupdatebuffer:= nil;
 end;
 clearindex;
 fbrecordcount:= 0;
 
 ffieldinfos:= nil;
 fstringpositions:= nil;
 fcalcfieldbufpositions:= nil;
 fcalcfieldsizes:= nil;
 fcalcstringpositions:= nil;
 
 bindfields(false);
end;

procedure tmsebufdataset.internalclose;
begin
 dointernalclose;
end;

procedure tmsebufdataset.clearbuffers;
begin
 if bs_editing in fbstate then begin
  internalcancel; //free data
 end;
 inherited;
end;

procedure tmsebufdataset.internalinsert;
begin
 include(fbstate,bs_editing);
 with pdsrecordty(activebuffer)^.dsheader.bookmark.data do begin
  recordpo:= nil;
//  recno:= -1;
  recno:= frecno;
  {
  if eof then begin
   recno:= fbrecordcount //append
  end
  else begin
   recno:= frecno;
  end;
  }
 end;
 inherited;
end;

procedure tmsebufdataset.internaledit;
begin
 addrefstrings(pdsrecordty(activebuffer)^.header);
 include(fbstate,bs_editing);
 inherited;
end;

procedure tmsebufdataset.internalfirst;
begin
 internalsetrecno(-1);
end;

procedure tmsebufdataset.internallast;
begin
{
 repeat
 until (getnextpacket < fpacketrecords) or (bs_fetchall in fbstate);
}
 getnextpacket(true);
 internalsetrecno(fbrecordcount)
end;

function tmsebufdataset.getrecord(buffer: pchar; getmode: tgetmode;
                                            docheck: boolean): tgetresult;
var
 acceptable: boolean;
 state1: tdatasetstate; 
begin
 result:= grok;
 acceptable:= true;
 fcheckfilterbuffer:= pointer(buffer);
 repeat
  case getmode of
   gmprior: begin
    if frecno <= 0 then begin
     result := grbof;
    end
    else begin
     internalsetrecno(frecno-1);
    end;
   end;
   gmcurrent: begin
    if (frecno < 0) or (frecno >= fbrecordcount) or (fcurrentbuf = nil) then begin
     result := grerror;
    end;
   end;
   gmnext: begin
    if frecno >= fbrecordcount - 1 then begin
     if getnextpacket(bs_fetchall in fbstate) = 0 then begin
      result:= greof;
     end
     else begin
      internalsetrecno(frecno+1);
     end;
    end
    else begin
     internalsetrecno(frecno+1);
    end;
   end;
  end;
  if result = grok then begin
   with pdsrecordty(buffer)^ do begin
    with dsheader.bookmark do  begin
     data.recno:= frecno;
     data.recordpo:= fcurrentbuf;
     flag:= bfcurrent;
    end;
    move(fcurrentbuf^.header,header,frecordsize);
    getcalcfields(buffer);
    if filtered then begin
     state1:= settempstate(tdatasetstate(dscheckfilter));
     try
      dofilterrecord(acceptable);
     finally
      restorestate(state1);
     end;
    end;
    if (getmode = gmcurrent) and not acceptable then begin
     result:= grerror;
    end;
   end;
  end;
 until acceptable or (result <> grok);
 if docheck and (result = grerror) then begin
  databaseerror('No record');
 end;
end;

function tmsebufdataset.getrecordupdatebuffer : boolean;
var 
 int1: integer;
begin
 if bs_applying in fbstate then begin
  result:= true; //fcurrentupdatebuffer is valid
 end
 else begin
  with pdsrecordty(activebuffer)^.dsheader.bookmark.data do begin
   if (fcurrentupdatebuffer >= length(fupdatebuffer)) or 
        (fupdatebuffer[fcurrentupdatebuffer].bookmark.recordpo <> 
                                                         recordpo) then begin
    for int1:= 0 to high(fupdatebuffer) do begin
     if fupdatebuffer[int1].bookmark.recordpo = recordpo then begin
      fcurrentupdatebuffer:= int1;
      break;
     end;
    end;
   end;
   result:= (fcurrentupdatebuffer <= high(fupdatebuffer))  and 
          (fupdatebuffer[fcurrentupdatebuffer].bookmark.recordpo = recordpo) and 
          (recordpo <> nil);
  end;
 end;
end;

procedure tmsebufdataset.internalsettorecord(buffer: pchar);
begin
 internalsetrecno(pdsrecordty(buffer)^.dsheader.bookmark.data.recno);
end;

procedure tmsebufdataset.setbookmarkdata(buffer: pchar; data: pointer);
begin
 move(data^,pdsrecordty(buffer)^.dsheader.bookmark,sizeof(bookmarkdataty));
end;

procedure tmsebufdataset.setbookmarkflag(buffer: pchar; value: tbookmarkflag);
begin
 pdsrecordty(buffer)^.dsheader.bookmark.flag := value;
end;

procedure tmsebufdataset.GetBookmarkData(Buffer: PChar; Data: Pointer);
begin
 move(pdsrecordty(buffer)^.dsheader.bookmark,data^,sizeof(bookmarkdataty));
end;

function tmsebufdataset.getbookmarkflag(buffer: pchar): tbookmarkflag;
begin
 result:= pdsrecordty(buffer)^.dsheader.bookmark.flag;
end;

function tmsebufdataset.findrecord(arecordpo: pintrecordty): integer;
//-1 if not found
var
 int1: integer;
 po1: ppointeraty;
begin
 if factindex = 0 then begin
  result:= -1;
  po1:= pointer(findexes[0].ind);
  for int1:= fbrecordcount - 1 downto 0 do begin
   if po1^[int1] = arecordpo then begin
    result:= int1;
    break;
   end;
  end;
 end
 else begin
  result:= findexlocal[factindex-1].findrecord(arecordpo);
 end;
end;

procedure tmsebufdataset.internalgotobookmark(abookmark: pointer);
var
 int1: integer;
begin
 with pbufbookmarkty(abookmark)^.data do begin
  if (recno >= fbrecordcount) or (recno < 0) then begin
   databaseerror('Invalid bookmark recno: '+inttostr(recno)+'.'); 
  end;
  if (factindexpo^.ind[recno] <> recordpo) and (recordpo <> nil) then begin
   int1:= findrecord(recordpo);
   if int1 < 0 then begin
    databaseerror('Invalid bookmarkdata.');
   end;
  end
  else begin
   int1:= recno;
  end;
  internalsetrecno(int1);
 end;
end;

function tmsebufdataset.getnextpacket(const all: boolean): integer;
var
 state1: tdatasetstate;
 int1,int2: integer;
 recnobefore: integer;
 bufbefore: pointer;
begin
 result:= 0;
 if fallpacketsfetched then  begin
  exit;
 end;
 int2:= fbrecordcount;
 while ((result < fpacketrecords) or all) and 
                             (loadbuffer(femptybuffer^.header) = grok) do begin
  appendrecord(femptybuffer);
  femptybuffer:= intallocrecord;
  inc(result);
 end;
 if checkcanevent(self,tmethod(foninternalcalcfields)) then begin
  state1:= settempstate(dsinternalcalc);
  fbstate:= fbstate + [bs_internalcalc,bs_fetching];
  recnobefore:= frecno;
  bufbefore:= fcurrentbuf;
  try
   for int1:= int2 to fbrecordcount-1 do begin
    frecno:= int1;
    fcurrentbuf:= findexes[0].ind[int1];
    foninternalcalcfields(self,true);
   end;
  finally
   frecno:= recnobefore;
   fcurrentbuf:= bufbefore;
   fbstate:= fbstate - [bs_internalcalc,bs_opening,bs_fetching];
   restorestate(state1);
  end;
 end;
 exclude(fbstate,bs_opening);
end;

function tmsebufdataset.getfieldsize(const datatype: tfieldtype;
                                         out isstring: boolean): longint;
begin
 isstring:= false;
 case datatype of
  ftstring,ftfixedchar: begin
   isstring:= true;
   result:= sizeof(msestring);
  end;
  ftsmallint,ftinteger,ftword: result:= sizeof(longint);
  ftboolean: result:= sizeof(wordbool);
  ftbcd: result:= sizeof(currency);
  ftfloat,ftcurrency: result:= sizeof(double);
  ftlargeint: result:= sizeof(largeint);
  fttime,ftdate,ftdatetime: result:= sizeof(tdatetime);
  ftmemo,ftblob: result:= getblobdatasize;
  else result:= 0;
 end;
end;

function tmsebufdataset.loadbuffer(var buffer: recheaderty): tgetresult;
var
 int1,int2: integer;
 str1: string;
 field1: tfield;
 po2: pmsestring;
 fno: integer;
begin
 if not fetch then  begin
  result := greof;
  fallpacketsfetched := true;
  exit;
 end;
 pointer(buffer.blobinfo):= nil;
 fillchar(buffer.fielddata.nullmask,fnullmasksize,$ff);
 for int1:= 0 to fields.count-1 do begin
  field1:= fields[int1];
  fno:= field1.fieldno-1;
  with ffieldinfos[fno] do begin
   case field1.fieldkind of
    fkdata: begin
     int2:= dbfieldsize;
     if field1.datatype in charfields then begin
      int2:= int2*4+4; //room for multibyte encodings
      setlength(str1,int2); 
      if not loadfield(field1,pointer(str1),int2) then begin
       setfieldisnull(buffer.fielddata.nullmask,fno);
      end
      else begin
       if int2 < 0 then begin //buffer to small
        int2:= -int2;
        setlength(str1,int2);
        loadfield(field1,pointer(str1),int2);
       end;
       setlength(str1,int2);
       po2:= pointer(@buffer) + offset;
       if bs_utf8 in fbstate then begin
        po2^:= utf8tostring(str1);
       end
       else begin
        po2^:= msestring(str1);
       end;
       if length(po2^) > dbfieldsize then begin
        setlength(po2^,dbfieldsize);
       end;
      end;
     end
     else begin
      if not loadfield(field1,pointer(@buffer)+offset,int2) or 
                           (int2 < 0)then begin
       setfieldisnull(buffer.fielddata.nullmask,fno);        //buffer too small
      end;
     end;
    end;
    fkinternalcalc: begin
     setfieldisnull(buffer.fielddata.nullmask,fno);
    end;
   end;
  end;
 end;
 result:= grok;
end;

function tmsebufdataset.getfieldbuffer(const afield: tfield;
             out buffer: pointer; out datasize: integer): boolean;
              //read buffer
              //true if not null
var
 int1: integer;
begin 
 result:= false;
 if not active then begin
  buffer:= nil;
  exit;
 end;
 int1:= afield.fieldno - 1;
 case ord(state) of
  ord(dscalcfields): begin
   buffer:= @pdsrecordty(calcbuffer)^.header;
  end;
  dscheckfilter: begin
   buffer:= @fcheckfilterbuffer^.header;
  end;
  ord(dsfilter): begin
   buffer:= @ffilterbuffer^.header;
  end;
  ord(dscurvalue): begin
   buffer:= @fcurrentbuf^.header;
  end;
  else begin
   if bs_internalcalc in fbstate then begin
    if int1 < 0 then begin//calc field
     buffer:= @pdsrecordty(activebuffer)^.header;
     //values invalid!
    end
    else begin
     buffer:= @fcurrentbuf^.header;
    end;
   end
   else begin
    if bs_applying in fbstate then begin
     buffer:= @fnewvaluebuffer^.header;
    end
    else begin
     buffer:= @pdsrecordty(activebuffer)^.header;
    end;
   end;
  end;
 end;
 if int1 >= 0 then begin // data field
  result:= false;
  if state = dsoldvalue then begin
   if getrecordupdatebuffer then begin
    buffer:= fupdatebuffer[fcurrentupdatebuffer].oldvalues;
    if buffer <> nil then begin
     buffer:= @pintrecordty(buffer)^.header;
    end;
   end
   else begin
    buffer:= @fcurrentbuf^.header   //there is no old value available
   end;
  end;
  if buffer <> nil then begin
   result:= not getfieldisnull(precheaderty(buffer)^.fielddata.nullmask,int1);
   inc(buffer,ffieldinfos[int1].offset{ffieldbufpositions[int1]});
   datasize:= ffieldinfos[int1].size{ffieldsizes[int1]};
  end
  else begin
   datasize:= 0;
  end;
 end
 else begin   
  int1:= -2 - int1;
  if int1 >= 0 then begin //calc field
   result:= not getfieldisnull(pbyte(buffer+frecordsize),int1);
   inc(buffer,fcalcfieldbufpositions[int1]);
   datasize:= fcalcfieldsizes[int1];
  end
  else begin
   buffer:= nil;
   datasize:= 0;
  end;
 end;
end;

function tmsebufdataset.getfielddata(field: tfield; buffer: pointer): boolean;
var 
 po1: pointer;
 datasize: integer;
begin
 result:= getfieldbuffer(field,po1,datasize);
 if (buffer <> nil) and result then begin 
  move(po1^,buffer^,datasize);
 end;
end;

function tmsebufdataset.getfielddata(field: tfield; buffer: pointer;
                         nativeformat: boolean): boolean;
begin
 result:= getfielddata(field,buffer);
end;

function tmsebufdataset.getmsestringdata(const sender: tmsestringfield;
               out avalue: msestring): boolean;
var
 po1: pointer;
 int1: integer;
begin
 result:= getfieldbuffer(sender,po1,int1);
 if result then begin
  avalue:= msestring(po1^);
 end
 else begin
  avalue:= '';
 end;
end;

procedure tmsebufdataset.setcurvalue(const afield: tfield; const avalue: int64);
var
 po1: pointer;
 int1: integer;
begin
 if bs_applying in fbstate then begin
  int1:= afield.fieldno - 1;
  if int1 >= 0 then begin
   po1:= @fupdatebuffer[fcurrentupdatebuffer].bookmark.recordpo^.header;
 //  po1:= @fcurrentbuf^.header;
   if getfieldisnull(precheaderty(po1)^.fielddata.nullmask,int1) then begin
    unsetfieldisnull(precheaderty(po1)^.fielddata.nullmask,int1);
    inc(po1,ffieldinfos[int1].offset);
    case afield.datatype of
     ftinteger,ftautoinc: pinteger(po1)^:= avalue;
     ftlargeint: pint64(po1)^:= avalue;
    end;
   end;
  end;
 end;
end;

function tmsebufdataset.getfieldbuffer(const afield: tfield;
                        const isnull: boolean; out datasize: integer): pointer;
           //write buffer
var
 int1: integer;
begin 
 if not ((state in dswritemodes - [dsinternalcalc]) or 
       (afield.fieldkind = fkinternalcalc) and 
                                (state = dsinternalcalc)) then begin
  databaseerrorfmt(snotineditstate,[name],self);
 end;
 int1:= afield.fieldno-1;
 case state of
  dscalcfields: begin
   result:= @pdsrecordty(calcbuffer)^.header;
  end;
  dsfilter:  begin 
   result:= @ffilterbuffer^.header;
  end;
  else begin
   if bs_internalcalc in fbstate then begin
    if int1 < 0 then begin//calc field
     result:= @pdsrecordty(activebuffer)^.header;
     //values invalid!
    end
    else begin
     result:= @fcurrentbuf^.header;
    end;
   end
   else begin
    if bs_applying in fbstate then begin
     result:= @fnewvaluebuffer^.header;
    end
    else begin
     result:= @pdsrecordty(activebuffer)^.header;
    end;
   end;
  end;
 end;
 if int1 >= 0 then begin // data field
  if isnull then begin
   setfieldisnull(precheaderty(result)^.fielddata.nullmask,int1);
  end
  else begin
   unsetfieldisnull(precheaderty(result)^.fielddata.nullmask,int1);
  end;
  inc(result,ffieldinfos[int1].offset{ffieldbufpositions[int1]});
  datasize:= ffieldinfos[int1].size{ffieldsizes[int1]};
 end
 else begin
  int1:= -2 - int1;
  if int1 >= 0 then begin //calc field
   if isnull then begin
    setfieldisnull(pbyte(result+frecordsize),int1);
   end
   else begin
    unsetfieldisnull(pbyte(result+frecordsize),int1);
   end;
   inc(result,fcalcfieldbufpositions[int1]);
   datasize:= fcalcfieldsizes[int1];
  end
  else begin
   result:= nil;
   datasize:= 0;
  end;
 end;
end;

procedure tmsebufdataset.setfielddata(field: tfield; buffer: pointer);

var 
 po1: pointer;
 datasize: integer;
begin
 po1:= getfieldbuffer(field,buffer = nil,datasize);
 if buffer <> nil then begin
  move(buffer^,po1^,datasize);
 end;
 if (field.fieldno > 0) and not 
                 (state in [dscalcfields,dsinternalcalc,{dsfilter,}dsnewvalue]) then begin
  dataevent(defieldchange, ptrint(field));
 end;
end;

procedure tmsebufdataset.setmsestringdata(const sender: tmsestringfield;
               const avalue: msestring);
var
 po1: pointer;
 int1: integer;
begin
 po1:= getfieldbuffer(sender,false,int1);
 msestring(po1^):= avalue;
 if (sender.characterlength > 0) and 
                     (length(avalue) > sender.characterlength) then begin
  setlength(msestring(po1^),sender.characterlength);
 end;
 if (sender.fieldno > 0) and not 
                 (state in [dscalcfields,dsinternalcalc,{dsfilter,}dsnewvalue]) then begin
  dataevent(defieldchange,ptrint(sender));
 end;
end;

procedure tmsebufdataset.setfielddata(field: tfield; buffer: pointer;
                                                  nativeformat: boolean);
begin
 setfielddata(field,buffer);
end;

procedure tmsebufdataset.getnewupdatebuffer;
begin
 setlength(fupdatebuffer,high(fupdatebuffer)+2);
 fcurrentupdatebuffer:= high(fupdatebuffer);
end;

procedure tmsebufdataset.internaldelete;
var
 po1: pintrecordty;
 
begin
 po1:= fcurrentbuf;
 if not getrecordupdatebuffer then begin
  getnewupdatebuffer;
  with fupdatebuffer[fcurrentupdatebuffer] do begin
   bookmark.recno:= frecno;
   bookmark.recordpo:= fcurrentbuf;
   oldvalues:= bookmark.recordpo;
  end;
 end
 else begin
  with fupdatebuffer[fcurrentupdatebuffer] do begin
   intfreerecord(bookmark.recordpo);
   if updatekind = ukmodify then begin
    bookmark.recordpo:= oldvalues;
   end
   else begin //ukinsert
    bookmark.recordpo := nil;  //this 'disables' the updatebuffer
   end;
  end;
 end;
 deleterecord(frecno);
 fupdatebuffer[fcurrentupdatebuffer].updatekind := ukdelete;
 if flogger <> nil then begin
  logupdatebuffer(flogger,fupdatebuffer[fcurrentupdatebuffer],po1,true,lf_update);
  flogger.flushbuffer;
 end;
end;

procedure tmsebufdataset.applyrecupdate(updatekind : tupdatekind);
begin
 raise edatabaseerror.create(sapplyrecnotsupported);
end;

procedure tmsebufdataset.cancelrecupdate(var arec: recupdatebufferty);
begin
 if (flogger <> nil) and not (bs_loading in fbstate) then begin
  logupdatebuffer(flogger,arec,nil,true,lf_cancel);
  flogger.flushbuffer;
 end;
 with arec do begin
  if bookmark.recordpo <> nil then begin
   if updatekind = ukmodify then begin
    freeblobs(bookmark.recordpo^.header.blobinfo);
    finalizestrings(bookmark.recordpo^.header);
    move(oldvalues^.header,bookmark.recordpo^.header,frecordsize);
    freemem(oldvalues); //no finalize
   end
   else begin
    if updatekind = ukdelete then begin
     insertrecord(bookmark.recno,bookmark.recordpo);
    end
    else begin
     if updatekind = ukinsert then begin
      deleterecord(bookmark.recordpo);
      if bookmark.recordpo = fcurrentbuf then begin
       fcurrentbuf:= nil;
       if frecno >= 0 then begin
        dec(frecno);
       end;
      end;
      intfreerecord(bookmark.recordpo);
     end;
    end;
   end;
  end;
 end;
end;

procedure tmsebufdataset.cancelupdate;
var 
 int1: integer;
begin
 cancel;
 checkbrowsemode;
 if (fupdatebuffer <> nil) and (frecno >= 0) then begin
  for int1:= high(fupdatebuffer) downto 0 do begin
   if fupdatebuffer[int1].bookmark.recordpo = fcurrentbuf then begin
    cancelrecupdate(fupdatebuffer[int1]);
    deleteitem(fupdatebuffer,typeinfo(recupdatebufferarty),int1);
    if int1 <= fapplyindex then begin
     dec(fapplyindex);
    end;
    resync([]);
    break;
   end;
  end;
 end;
end;

procedure tmsebufdataset.cancelupdates;
var
 int1: integer;
begin
 cancel;
 checkbrowsemode;
 if high(fupdatebuffer) >= 0 then begin
  for int1:= high(fupdatebuffer) downto 0 do begin
   cancelrecupdate(fupdatebuffer[int1]);
  end;
  fupdatebuffer:= nil;
  resync([]);
 end;
end;

procedure tmsebufdataset.SetOnUpdateError(const AValue: TResolverErrorEvent);

begin
  FOnUpdateError := AValue;
end;

procedure tmsebufdataset.internalapplyupdate(const maxerrors: integer;
               const cancelonerror: boolean; var response: tresolverresponse);
               
 procedure checkcancel;
 begin
  if cancelonerror then begin
   cancelrecupdate(fupdatebuffer[fcurrentupdatebuffer]);
   fupdatebuffer[fcurrentupdatebuffer].bookmark.recordpo:= nil;
   resync([]);
  end;
 end;
 
var
 EUpdErr: EUpdateError;
 by1: boolean;

begin
 include(fbstate,bs_applying);
 by1:= not islocal;
 with fupdatebuffer[fcurrentupdatebuffer] do begin
  try
   move(bookmark.recordpo^.header,fnewvaluebuffer^.header,frecordsize);
   getcalcfields(pchar(fnewvaluebuffer));
   Response:= rrApply;
   try
    try
     if by1 then begin
      ApplyRecUpdate(UpdateKind);
     end;
    finally
     pointer(bookmark.recordpo^.header.blobinfo):= 
         pointer(fnewvaluebuffer^.header.blobinfo); //update deleted blobs
    end;
   except
    on E: EDatabaseError do begin
     Inc(fFailedCount);
     if longword(ffailedcount) > longword(MaxErrors) then begin
      Response:= rrAbort
     end
     else begin
      Response:= rrSkip;
     end;
     EUpdErr:= EUpdateError.Create(SOnUpdateError,E.Message,0,0,E);
     try
      if checkcanevent(self,tmethod(OnUpdateError)) then begin
       OnUpdateError(Self,Self,EUpdErr,UpdateKind,Response);
      end;
     finally
      if Response = rrAbort then begin
       try
        checkcancel;
       finally
        Raise EUpdErr;
       end;
      end;
      eupderr.free;
     end;
    end
    else begin
     raise;
    end;
   end;
   if response = rrApply then begin
    if flogger <> nil then begin
     logupdatebuffer(flogger,fupdatebuffer[fcurrentupdatebuffer],nil,true,lf_apply);
     flogger.flushbuffer;
    end;
    intFreeRecord(OldValues);
    Bookmark.recordpo:= nil;
   end
   else begin
    checkcancel;
   end;
  finally
   exclude(fbstate,bs_applying);
   finalizecalcstrings(fnewvaluebuffer^.header);
  end;
 end;
end;

procedure tmsebufdataset.afterapply;
begin
 //dummy
end;

procedure tmsebufdataset.applyupdate(const cancelonerror: boolean = false); //applies current record
var
 response: tresolverresponse;
 int1: integer;
begin
 checkbrowsemode;
 if getrecordupdatebuffer then begin
  ffailedcount:= 0;
  int1:= fcurrentupdatebuffer;
  internalapplyupdate(0,cancelonerror,response);
  if response = rrapply then begin
   afterapply;
   deleteitem(fupdatebuffer,typeinfo(recupdatebufferarty),int1);
   fcurrentupdatebuffer:= bigint; //invalid
  end;
 end;
end;

procedure tmsebufdataset.ApplyUpdates(const MaxErrors: Integer; 
                                const cancelonerror: boolean = false);
var
 Response: TResolverResponse;
 recnobefore: integer;

begin
 CheckBrowseMode;
 disablecontrols;
 recnobefore:= frecno;
 try
  fapplyindex := 0;
  fFailedCount := 0;
  Response := rrApply;
  while (fapplyindex <= high(FUpdateBuffer)) and (Response <> rrAbort) do begin
   fcurrentupdatebuffer:= fapplyindex;
   if FUpdateBuffer[fcurrentupdatebuffer].Bookmark.recordpo <> nil then begin
    internalapplyupdate(maxerrors,cancelonerror,response);
   end;
   inc(fapplyindex);
  end;
  if ffailedcount = 0 then begin
   fupdatebuffer:= nil;
  end;
 finally 
  if active then begin
   internalsetrecno(recnobefore);
   Resync([]);
   enablecontrols;
  end
  else begin
   enablecontrols;
  end;
 end;
 afterapply;
end;

procedure tmsebufdataset.ApplyUpdates(const maxerrors: integer = 0);
begin
 applyupdates(maxerrors,false);
end;

procedure tmsebufdataset.applyupdate;
begin
 applyupdate(false);
end;

procedure tmsebufdataset.internalpost;
var
 po1,po2: pblobinfoarty;
 po3: pointer;
 int1,int2,int3: integer;
 bo1: boolean;
 ar1,ar2,ar3: integerarty;
 lastind: integer;
 newupdatebuffer: boolean;
 
begin
 checkindex(false); //needed for first append
 with pdsrecordty(activebuffer)^ do begin
  bo1:= false;
  with header do begin
   for int1:= high(blobinfo) downto 0 do begin
    if blobinfo[int1].new then begin
     blobinfo[int1].new:= false;
     bo1:= true;
    end;
   end;
  end;
  if state = dsinsert then begin
   fcurrentbuf:= intallocrecord;
  end;
  newupdatebuffer:= not getrecordupdatebuffer;
  if newupdatebuffer then begin
   getnewupdatebuffer;
   with fupdatebuffer[fcurrentupdatebuffer] do begin
    bookmark.recordpo:= fcurrentbuf;
    bookmark.recno:= frecno;
    if state = dsedit then begin
     oldvalues:= intallocrecord;
     move(bookmark.recordpo^,oldvalues^,frecordsize+intheadersize);
     addrefstrings(oldvalues^.header);
     po1:= getintblobpo;
     if po1^ <> nil then begin
      po2:= @oldvalues^.header.blobinfo;
      pointer(po2^):= nil;
      setlength(po2^,length(po1^));
      for int1:= high(po1^) downto 0 do begin
       po2^[int1]:= po1^[int1];
       with po2^[int1] do begin
        if datalength > 0 then begin
         po3:= getmem(datalength);
         move(data^,po3^,datalength);
         data:= po3;
        end
        else begin
         data:= nil;
        end;
       end;
      end;
     end;
     updatekind := ukmodify;
    end
    else begin
     updatekind := ukinsert;
    end;
   end;
  end;
  if (state = dsedit) and (bs_indexvalid in fbstate) then begin
   setlength(ar1,findexlocal.count);
   setlength(ar2,length(ar1));
   setlength(ar3,length(ar1));
   for int1:= high(ar1) downto 0 do begin
    with findexlocal[int1] do begin
     lastind:= high(findexfieldinfos);
     ar2[int1]:= compare(fcurrentbuf,@header,lastind,false);
     if ar2[int1] <> 0 then begin
      if int1 = factindex - 1 then begin
       ar1[int1]:= frecno + 1; //for fast find of bufpo
      end
      else begin
       ar1[int1]:= findboundary(fcurrentbuf,lastind,true); //old boundary
      end;
      ar3[int1]:= findboundary(@header,lastind,true); //new boundary
     end;
    end;
   end;
  end;   
  if bo1 then begin
   fcurrentbuf^.header.blobinfo:= nil; //free old array
  end;
  finalizestrings(fcurrentbuf^.header);
  move(header,fcurrentbuf^.header,frecordsize); //get new field values
  if flogger <> nil then begin
   logrecbuffer(flogger,fupdatebuffer[fcurrentupdatebuffer].updatekind,
                     fcurrentbuf);
   if newupdatebuffer then begin
    logupdatebuffer(flogger,fupdatebuffer[fcurrentupdatebuffer],nil,true,
                           lf_update);
   end;
   flogger.flushbuffer;
  end;
  if state = dsinsert then begin
   with dsheader.bookmark do  begin
    frecno:= insertrecord(frecno,fcurrentbuf);
    fcurrentbuf:= factindexpo^.ind[frecno];
    data.recordpo:= fcurrentbuf;
    data.recno:= frecno;
    flag := bfinserted;
   end;      
  end
  else begin
   if (state = dsedit) and (bs_indexvalid in fbstate) then begin
    for int1:= high(ar1) downto 0 do begin
     if ar2[int1] <> 0 then begin // position changed
      int2:= ar3[int1];           //new boundary
      with findexes[int1+1] do begin
       for int3:= ar1[int1] - 1 downto 0 do begin
        if ind[int3] = fcurrentbuf then begin //update indexes
         move(ind[int3+1],ind[int3],(fbrecordcount-int3-1)*sizeof(pointer));
         if int3 < int2 then begin
          dec(int2);
         end;
         move(ind[int2],ind[int2+1],(fbrecordcount-int2-1)*sizeof(pointer));
         ind[int2]:= fcurrentbuf;
         if int1 = factindex - 1 then begin
          frecno:= int2;
         end;
         break;
        end;
       end;
      end;
     end;
    end;
    dsheader.bookmark.data.recno:= frecno;
   end;
  end;
 end;
 fbstate:= fbstate - [bs_editing,bs_append];
end;

procedure tmsebufdataset.internalcancel;
var
 int1: integer;
begin
 with pdsrecordty(activebuffer)^,header do begin
  finalizestrings(header);
  for int1:= high(blobinfo) downto 0 do begin
   if blobinfo[int1].new then begin
    deleteblob(blobinfo,int1);
   end;
  end;
 end;
 fbstate:= fbstate - [bs_editing,bs_append];
end;

procedure tmsebufdataset.alignfieldpos(var avalue: integer);
const
 step = sizeof(pointer);
begin
 avalue:= (avalue + step - 1) and -step; //align to pointer
end;

procedure tmsebufdataset.calcrecordsize;

 procedure addfield(const aindex: integer; const datatype: tfieldtype;
                        const asize: integer; const afield: tfield);
 var
  bo1: boolean;
 begin
  with ffieldinfos[aindex] do begin
   offset:= frecordsize;
   size:= getfieldsize(datatype,bo1);
   if bo1 then begin
    additem(fstringpositions,frecordsize);
    dbfieldsize:= asize;     //max size
   end
   else begin
    dbfieldsize:= size;
   end;
   fieldtype:= datatype;        //used for savetostream;
   field:= afield;
   inc(frecordsize,size);
   alignfieldpos(frecordsize);
  end;
 end; //addfield

var 
 int1,int2: integer;
 field1: tfield;
begin
 fcalcfieldcount:= 0;
 finternalcalcfieldcount:= 0;
 for int1:= fields.count - 1 downto 0 do begin
  with fields[int1] do begin
   if fieldkind in dsbuffieldkinds then begin
    inc(fcalcfieldcount);
   end;
   if fieldkind = fkinternalcalc then begin
    inc(finternalcalcfieldcount);
   end;
  end;
 end;
 int1:= fielddefs.count+finternalcalcfieldcount;
 frecordsize:= sizeof(blobinfoarty);
 fnullmasksize:= (int1+7) div 8;
 inc(frecordsize,fnullmasksize);
 alignfieldpos(frecordsize);
 
 setlength(ffieldinfos,int1);
 fstringpositions:= nil;
 for int1:= 0 to fielddefs.count - 1 do begin
  with fielddefs[int1] do begin
   field1:= fields.findfield(name);
   if (field1 <> nil) and (field1.fieldkind = fkdata) then begin
    addfield(int1,datatype,size,field1);
   end;
  end;
 end;
 int2:= fielddefs.count;
 for int1:= 0 to fields.count -1 do begin
  field1:= fields[int1];
  with field1 do begin
   if fieldkind = fkinternalcalc then begin
    addfield(int2,datatype,size,field1);
    tfieldcracker(field1).ffieldno:= int2 + 1;
    inc(int2);
   end;
  end;
 end;
 setlength(fcalcfieldbufpositions,fcalcfieldcount);
 setlength(fcalcfieldsizes,fcalcfieldcount);
 fcalcstringpositions:= nil;
 fcalcrecordsize:= frecordsize;
 fcalcnullmasksize:= (fcalcfieldcount+7) div 8;
 inc(fcalcrecordsize,fcalcnullmasksize);
 alignfieldpos(fcalcrecordsize);
 int2:= 0;
 for int1:= fields.count - 1 downto 0 do begin
  field1:= fields[int1];
  with field1 do begin
   if fieldkind in dsbuffieldkinds then begin
    tfieldcracker(field1).ffieldno:= -1 - int2;
    fcalcfieldbufpositions[int2]:= fcalcrecordsize;
    if field1 is tmsestringfield then begin
     additem(fcalcstringpositions,fcalcrecordsize);
    end;
    fcalcfieldsizes[int2]:= datasize;
    inc(fcalcrecordsize,fcalcfieldsizes[int2]);
    alignfieldpos(fcalcrecordsize);
    inc(int2);
   end;
  end;
 end; 
end;

function tmsebufdataset.getrecordsize : word;
begin
 result:= frecordsize;
end;

function tmsebufdataset.getchangecount: integer;
begin
 result:= length(fupdatebuffer);
end;

procedure tmsebufdataset.internalinitrecord(buffer: pchar);

begin
 with pdsrecordty(buffer)^ do begin
  fillchar(header,fcalcrecordsize, #0);
 end;
end;

procedure tmsebufdataset.setrecno1(value: longint; const nocheck: boolean);
var
 bm: bufbookmarkty;
begin
 checkbrowsemode;
 if value > recordcount then begin
  repeat
  until (getnextpacket(bs_fetchall in fbstate) < fpacketrecords) or 
                       (value <= recordcount) or (bs_fetchall in fbstate);
 end;
 if nocheck then begin
  if value > fbrecordcount then begin
   value:= fbrecordcount;
  end;
  if value < 1 then begin
   exit;
  end;
 end;
 checkrecno(value);
 bm.data.recordpo:= nil;
 bm.data.recno:= value-1;
 gotobookmark(@bm);
end;

procedure tmsebufdataset.setrecno(value: longint);
begin
 setrecno1(value,false);
end;

function tmsebufdataset.getrecno: longint;
begin
 if bs_internalcalc in fbstate then begin
  result:= frecno + 1;
 end
 else begin
  result:= 0;
  if activebuffer <> nil then begin
   with pdsrecordty(activebuffer)^.dsheader.bookmark do begin
    if state = dsinsert  then begin
     if (bs_append in fbstate) or (fbrecordcount = 0) then begin
      result:= fbrecordcount + 1;
     end
     else begin
      result:= data.recno + 1;
     end;
    end
    else begin
     if fbrecordcount > 0 then begin
      result:= data.recno + 1;
     end;
    end;
   end;
  end;
 end;
end;

function tmsebufdataset.iscursoropen: boolean;
begin
 result:= fopen;
end;

function tmsebufdataset.getrecordcount: longint;
begin
 result:= fbrecordcount;
end;

function tmsebufdataset.updatestatus: tupdatestatus;
begin
 result:= usunmodified;
 if getrecordupdatebuffer then begin
  case fupdatebuffer[fcurrentupdatebuffer].updatekind of
   ukmodify : result := usmodified;
   ukinsert : result := usinserted;
   ukdelete : result := usdeleted;
  end;
 end;
end;
{
Function tmsebufdataset.Locate(const KeyFields: string; const KeyValues: Variant; options: TLocateOptions) : boolean;


  function CompareText0(substr, astr: pchar; len : integer; options: TLocateOptions): integer;

  var
    i : integer; Chr1, Chr2: byte;
  begin
    result := 0;
    i := 0;
    chr1 := 1;
    while (result=0) and (i<len) and (chr1 <> 0) do
      begin
      Chr1 := byte(substr[i]);
      Chr2 := byte(astr[i]);
      inc(i);
      if loCaseInsensitive in options then
        begin
        if Chr1 in [97..122] then
          dec(Chr1,32);
        if Chr2 in [97..122] then
          dec(Chr2,32);
        end;
      result := Chr1 - Chr2;
      end;
    if (result <> 0) and (chr1 = 0) and (loPartialKey in options) then result := 0;
  end;


var keyfield    : TField;     // Field to search in
    ValueBuffer : pchar;      // Pointer to value to search for, in TField' internal format
    VBLength    : integer;

    FieldBufPos : PtrInt;     // Amount to add to the record buffer to get the FieldBuffer
    CurrLinkItem: Pbufreclinkitem1;
    CurrBuff    : pchar;
    bm          : TBufBookmarkty;

    CheckNull   : Boolean;
    SaveState   : TDataSetState;

begin
// For now it is only possible to search in one field at the same time
  result := False;

  if IsEmpty then exit;

  keyfield := FieldByName(keyfields);
  CheckNull := VarIsNull(KeyValues);

  if not CheckNull then
    begin
    SaveState := State;
    SetTempState(dsFilter);
    keyfield.Value := KeyValues;
    RestoreState(SaveState);

    FieldBufPos := FFieldBufPositions[keyfield.FieldNo-1];
    VBLength := keyfield.DataSize;
    ValueBuffer := AllocMem(VBLength);
    currbuff := pointer(FLastRecBuf)+sizeof(Tbufreclinkitem1)+FieldBufPos;
    move(currbuff^,ValueBuffer^,VBLength);
    end;

  CurrLinkItem := FFirstRecBuf;

  if CheckNull then
    begin
    repeat
    currbuff := pointer(CurrLinkItem)+sizeof(Tbufreclinkitem1);
    if GetFieldIsnull(pbyte(CurrBuff),keyfield.Fieldno-1) then
      begin
      result := True;
      break;
      end;
    CurrLinkItem := CurrLinkItem^.next;
    if CurrLinkItem = FLastRecBuf then getnextpacket;
    until CurrLinkItem = FLastRecBuf;
    end
  else if keyfield.DataType = ftString then
    begin
    repeat
    currbuff := pointer(CurrLinkItem)+sizeof(Tbufreclinkitem1);
    if not GetFieldIsnull(pbyte(CurrBuff),keyfield.Fieldno-1) then
      begin
      inc(CurrBuff,FieldBufPos);
      if CompareText0(ValueBuffer,CurrBuff,VBLength,options) = 0 then
        begin
        result := True;
        break;
        end;
      end;
    CurrLinkItem := CurrLinkItem^.next;
    if CurrLinkItem = FLastRecBuf then getnextpacket;
    until CurrLinkItem = FLastRecBuf;
    end
  else
    begin
    repeat
    currbuff := pointer(CurrLinkItem)+sizeof(Tbufreclinkitem1);
    if not GetFieldIsnull(pbyte(CurrBuff),keyfield.Fieldno-1) then
      begin
      inc(CurrBuff,FieldBufPos);
      if CompareByte(ValueBuffer^,CurrBuff^,VBLength) = 0 then
        begin
        result := True;
        break;
        end;
      end;

    CurrLinkItem := CurrLinkItem^.next;
    if CurrLinkItem = FLastRecBuf then getnextpacket;
    until CurrLinkItem = FLastRecBuf;
    end;


  if Result then
    begin
    bm.BookmarkData := CurrLinkItem;
    bm.BookmarkFlag := bfCurrent;
    GotoBookmark(@bm);
    end;

  ReAllocmem(ValueBuffer,0);
end;
}
function tmsebufdataset.getblobrecpo: precheaderty;
begin
 if state = dsoldvalue then begin
  if getrecordupdatebuffer then begin
   result:= pointer(fupdatebuffer[fcurrentupdatebuffer].oldvalues);
   if result <> nil then begin
    result:= @pintrecordty(result)^.header;
   end;
  end
  else begin
   result:= @fcurrentbuf^.header   //there is no old value available
  end;
 end
 else begin
  if state = dscurvalue then begin
   result:= @fcurrentbuf^.header;
  end
  else begin
   result:= @pdsrecordty(activebuffer)^.header;
  end;
 end;
end;

function tmsebufdataset.createblobstream(field: tfield;
               mode: tblobstreammode): tstream;
var
 int1: integer;
 buffer: pointer;
begin
 if (mode <> bmread) and not (state in dseditmodes) then begin
  databaseerrorfmt(snotineditstate,[name],self);
 end;  
 result:= nil;
 if mode = bmread then begin
  buffer:= getblobrecpo;
  with precheaderty(buffer)^ do begin
   for int1:= high(blobinfo) downto 0 do begin
    if blobinfo[int1].field = field then begin
     result:= tblobcopy.create(blobinfo[int1]);
     break;
    end;
   end;
  end;
 end; 
end;

function tmsebufdataset.getfieldblobid(const field: tfield;
               out aid: blobidty): boolean;
var
 po1: precheaderty;
 po2: pointer;
 int1: integer;
begin
 result:= getfieldbuffer(field,po2,int1);
 if result then begin
  po1:= getblobrecpo;
  with po1^ do begin
   for int1:= high(blobinfo) downto 0 do begin
    if blobinfo[int1].field = field then begin
     aid.local:= true;
     aid.id:= ptrint(blobinfo[int1].data);
     result:= aid.id <> 0;
     exit;
    end;
   end;   
   aid.local:= false;
   aid.id:= 0;
   move(po2^,aid.id,getblobdatasize);
  end;
 end;
end;

procedure tmsebufdataset.fetchallblobs;
begin
 fetchall;
 fetchblobs;
end;

function tmsebufdataset.findcachedblob(var info: blobcacheinfoty): boolean;
var
 int1: integer;
begin
 if bs_blobscached in fbstate then begin
  info:= fblobcache[integer(info.id)];
  result:= true;
 end
 else begin
  if not (bs_blobssorted in fbstate) then begin
   sortblobcache;
  end;
  result:= findarrayvalue(info,fblobcache,fblobcount,@compblobcache,
                                         sizeof(blobcacheinfoty),int1);
  if result then begin
   info.data:= fblobcache[int1].data;
  end
  else begin
   info.data:= '';
  end;
 end
end;

procedure tmsebufdataset.sortblobcache;
begin
 setlength(fblobcache,fblobcount);
 sortarray(fblobcache,@compblobcache,sizeof(blobcacheinfoty));
 include(fbstate,bs_blobssorted);
end;

procedure tmsebufdataset.resetblobcache;
begin
 fblobcache:= nil;
 fblobcount:= 0;
 exclude(fbstate,bs_blobssorted);
end;

procedure tmsebufdataset.fetchblobs;
var
 datapobefore: pintrecordty;
 statebefore: tdatasetstate;
 int1,int2,int3: integer;
 ind1: pointerarty;
 fieldar1: fieldarty;
 ar1: integerarty;
 stream1: tmemorystream;
 id: int64;
begin
 if not blobscached and not (bs_blobsfetched in fbstate) then begin
  setlength(fieldar1,fields.count);
  int2:= 0;
  for int1:= 0 to high(fieldar1) do begin
   fieldar1[int2]:= fields[int1];
   if fieldar1[int2].isblob then begin
    inc(int2);
   end;
  end;
  if int2 > 0 then begin
   setlength(fieldar1,int2);
   setlength(ar1,int2);
   for int1:= 0 to high(ar1) do begin
    ar1[int1]:= fieldar1[int1].fieldno-1;
   end;
   datapobefore:= fcurrentbuf;
   ind1:= findexes[0].ind;
   statebefore:= settempstate(dscurvalue);
   resetblobcache;
   try
    for int1:= 0 to recordcount - 1 do begin
     fcurrentbuf:= ind1[int1];
     for int2:= 0 to high(fieldar1) do begin
      if not getfieldisnull(fcurrentbuf^.header.fielddata.nullmask,
                                                        ar1[int2]) then begin
       stream1:= tmemorystream(createblobstream(fieldar1[int2],bmread));
       int3:= addblobcache(stream1.memory,stream1.size);
       fieldar1[int2].getdata(@fblobcache[int3].id);
       stream1.free;
      end;
     end;
    end;
   finally
    fcurrentbuf:= datapobefore;
    restorestate(statebefore);
   end;
  end;
 end
 else begin
  setlength(fblobcache,fblobcount);
 end;
 include(fbstate,bs_blobsfetched);
end;

function tmsebufdataset.findcachedblob(const id: int64; 
                           out info: blobcacheinfoty): boolean; overload;
begin
 info.id:= id;
 result:= findcachedblob(info);
end;

procedure tmsebufdataset.getofflineblob(const data: precheaderty;
                       const aindex: integer; out ainfo: blobstreaminfoty);
var
 cacheinfo: blobcacheinfoty;
 int1: integer;
begin
 with ffieldinfos[aindex] do begin
  cacheinfo.id:= 0; //field size can be 32 bit
  move((pointer(data)+offset)^,cacheinfo.id,size);
  with data^ do begin
   for int1:= high(blobinfo) downto 0 do begin
    if blobinfo[int1].field = field then begin
     with blobinfo[int1] do begin
      ainfo.info.id:= cacheinfo.id;
      ainfo.info.new:= new;
      ainfo.info.current:= true;
      setlength(ainfo.data,datalength);
      move(data^,pointer(ainfo.data)^,datalength);
             //todo: no move
     end;
     exit;
    end;
   end;
  end;
  findcachedblob(cacheinfo);
  with ainfo,info do begin
   id:= cacheinfo.id;
   new:= false;
   current:= false;
   data:= cacheinfo.data;
  end;
 end;
end;

procedure tmsebufdataset.setofflineblob(const adata: precheaderty;
                       const aindex: integer; const ainfo: blobstreaminfoty);
begin
 with ainfo,info do begin
  with ffieldinfos[aindex] do begin
   move(id,(pointer(adata)+offset)^,size);
   if current then begin
    with adata^ do begin
     setlength(blobinfo,high(blobinfo) + 2);
     with blobinfo[high(blobinfo)] do begin
      field:= ffieldinfos[aindex].field;
      new:= info.new; //??
      datalength:= length(ainfo.data);
      data:= getmem(datalength); //todo: no move
      move(pointer(ainfo.data)^,data^,datalength);
     end;
    end;
   end
   else begin
    addblobcache(id,data);
   end;
  end;
 end;
end;

procedure tmsebufdataset.setdatastringvalue(const afield: tfield; const avalue: string);
var
 po1: pbyte;
 int1: integer;
begin
 if bs_applying in fbstate then begin
  po1:= pbyte(@fupdatebuffer[fcurrentupdatebuffer].bookmark.recordpo^.header);
 end
 else begin
  po1:= pbyte(@fcurrentbuf^.header);
 end;
 int1:= afield.fieldno - 1;
 if avalue <> '' then begin
  move(avalue[1],(po1+ffieldinfos[int1].offset{ffieldbufpositions[int1]})^,length(avalue));
  unsetfieldisnull(precheaderty(po1)^.fielddata.nullmask,int1);
 end
 else begin
  setfieldisnull(precheaderty(po1)^.fielddata.nullmask,int1);
 end;
end; 

procedure tmsebufdataset.checkindexsize;
var
 int1,int2: integer;
begin
 if high(factindexpo^.ind) <= fbrecordcount then begin
  int2:= (fbrecordcount+16)*2;
  setlength(findexes[0].ind,int2);
  if bs_indexvalid in fbstate then begin
   for int1:= 1 to high(findexes) do begin
    setlength(findexes[int1].ind,int2);
   end;
  end;
 end;
end;

function tmsebufdataset.insertindexrefs(const arecord: pintrecordty): integer;
var
 int1,int2: integer;
begin
 result:= frecno;
 if bs_indexvalid in fbstate then begin
  for int1:= 1 to high(findexes) do begin
   with findexlocal[int1-1] do begin
    int2:= findboundary(arecord,high(findexfieldinfos),true);
   end;
   with findexes[int1] do begin
    if int2 < fbrecordcount then begin
     move(ind[int2],ind[int2+1],(fbrecordcount-int2)*sizeof(pointer));
    end;
    ind[int2]:= arecord;
    if int1 = factindex then begin
     result:= int2;
    end;
   end;
  end;
 end;
end;

procedure tmsebufdataset.removeindexrefs(const arecord: pintrecordty);
var
 int1,int2: integer;
begin
 if bs_indexvalid in fbstate then begin
  for int1:= 1 to high(findexes) do begin
   if int1 <> factindex then begin
    int2:= findexlocal[int1-1].findrecord(arecord);
    with findexes[int1] do begin
     move(ind[int2+1],ind[int2],(fbrecordcount-int2-1)*sizeof(pointer));
    end;
   end;
  end;
 end;
end;

function tmsebufdataset.appendrecord(const arecord: pintrecordty): integer;
begin
 checkindexsize;
 findexes[0].ind[fbrecordcount]:= arecord;
 result:= insertindexrefs(arecord);
 if factindex = 0 then begin
  result:= fbrecordcount;
 end;
 inc(fbrecordcount);
end;

function tmsebufdataset.insertrecord(arecno: integer; 
                       const arecord: pintrecordty): integer;
begin
 if arecno < 0 then begin
  arecno:= 0;
 end;
 checkindexsize;
 result:= insertindexrefs(arecord);
 if factindex <> 0 then begin
  findexes[0].ind[fbrecordcount]:= arecord; //append
 end
 else begin
  result:= arecno;
  move(findexes[0].ind[arecno],findexes[0].ind[arecno+1],
             (fbrecordcount-arecno)*sizeof(pointer));
  findexes[0].ind[arecno]:= arecord;           
 end;
 if (frecno > arecno) then begin
  inc(frecno);
 end;
 fcurrentbuf:= factindexpo^.ind[frecno];
 inc(fbrecordcount);
end;

function tmsebufdataset.remove0indexref(const arecord: pintrecordty): integer;
var
 po1: pintrecordty;
 po2: ppointer;
 int1: integer;
begin  
 result:= -1;
 dec(fbrecordcount);
 po1:= arecord;
 with findexes[0] do begin
  po2:= pointer(ind) + fbrecordcount*sizeof(pointer);
  for int1:= fbrecordcount downto 0 do begin
   if po2^ = po1 then begin
    result:= int1;
    break;
   end;
   dec(po2);
  end;
  if result >= 0 then begin
   move(ind[result+1],ind[result],(fbrecordcount-result)*sizeof(pointer));
  end;
 end;
end;

procedure tmsebufdataset.deleterecord(const arecord: pintrecordty);
var
 int1: integer;
begin
 if bs_indexvalid in fbstate then begin
  int1:= factindex;
  factindex:= 0;
  removeindexrefs(arecord);
  factindex:= int1;
 end;
 remove0indexref(arecord);
end;

procedure tmsebufdataset.deleterecord(const arecno: integer);
var
 po1: pintrecordty;
 int1: integer;
begin
 po1:= factindexpo^.ind[arecno];
 if bs_indexvalid in fbstate then begin
  removeindexrefs(po1);
  if factindex <> 0 then begin
   move(factindexpo^.ind[arecno+1],factindexpo^.ind[arecno],
              (fbrecordcount-arecno-1)*sizeof(pointer));
  end;
 end;
 if factindex = 0 then begin
  dec(fbrecordcount);
  with findexes[0] do begin
   move(ind[arecno+1],ind[arecno],(fbrecordcount-arecno)*sizeof(pointer));
  end;
 end
 else begin
  remove0indexref(po1);
 end;
 if (frecno > arecno) or (frecno >= fbrecordcount) then begin
  dec(frecno);
 end;
 if frecno < 0 then begin
  fcurrentbuf:= nil;
 end
 else begin
  fcurrentbuf:= factindexpo^.ind[frecno];
 end;
end;

procedure tmsebufdataset.checkindex(const force: boolean);
var
 int1,int2,int3: integer;
begin
 if (force or (factindex <> 0)) and not (bs_indexvalid in fbstate) then begin
  int2:= length(findexes[0].ind);
  if int2 > 0 then begin
   for int1:= 1 to high(findexes) do begin
    with findexes[int1] do begin
     if ind = nil then begin
      allocuninitedarray(int2,sizeof(pointer),ind);
      if fbrecordcount > 0 then begin
       move(findexes[0].ind[0],ind[0],fbrecordcount*sizeof(pointer));
       findexlocal.items[int1-1].sort(ind);
      end;
     end;
    end;
   end;
  end;
  include(fbstate,bs_indexvalid);
 end;
end;

procedure tmsebufdataset.internalsetrecno(const avalue: integer);
begin
 frecno:= avalue;
 if (avalue < 0) or (avalue >= fbrecordcount)  then begin
  fcurrentbuf:= nil;
 end
 else begin
  checkindex(false);
  fcurrentbuf:= factindexpo^.ind[avalue];
 end;
end;

procedure tmsebufdataset.clearindex;
begin
 findexes:= nil;
 factindexpo:= nil;
 exclude(fbstate,bs_indexvalid);
end;

procedure tmsebufdataset.setindexlocal(const avalue: tlocalindexes);
begin
 findexlocal.assign(avalue);
end;

procedure tmsebufdataset.updatestate;
begin
 if (fpacketrecords < 0) {or assigned(foninternalcalcfields)} then begin
  include(fbstate,bs_fetchall);
 end
 else begin
  exclude(fbstate,bs_fetchall);
 end;
 if findexlocal.count > 0 then begin
  fbstate:= fbstate + [bs_hasindex,bs_fetchall];
 end
 else begin
  exclude(fbstate,bs_hasindex);
 end;
end;

procedure tmsebufdataset.setactindex(const avalue: integer);
var
 int1: integer;
begin
 if factindex <> avalue then begin
  if active then begin
   checkbrowsemode;
   factindex:= avalue;
   factindexpo:= @findexes[avalue];
   internalsetrecno(findrecord(fcurrentbuf));
   resync([]);
  end
  else begin
   factindex:= avalue;
   factindexpo:= @findexes[avalue];
  end;
 end;
end;

procedure tmsebufdataset.resetindex;
var
 int1: integer;
begin
 actindex:= 0;
 for int1:= 1 to high(findexes) do begin
  findexes[int1].ind:= nil;
 end;
 exclude(fbstate,bs_indexvalid);
end;

function tmsebufdataset.GetFieldClass(FieldType: TFieldType): TFieldClass;
begin
 result:= getmsefieldclass(fieldtype);
end;

procedure tmsebufdataset.fieldtoparam(const source: tfield; const dest: tparam);
var
 int1: integer;
 mstr1: msestring;
begin
 if source is tmsestringfield then begin
  with tmsestringfield(source) do begin
   if source.isnull then begin
    dest.clear;
    if fixedchar then begin
     dest.datatype:= ftfixedchar;
    end
    else begin
     dest.datatype:= ftstring;
    end;
   end
   else begin
    mstr1:= asmsestring;
    if length(mstr1) > characterlength then begin
     setlength(mstr1,characterlength);
    end;
    if bs_utf8 in fbstate then begin
//     dest.asstring:= stringtoutf8(copy(asmsestring,1,size));
     dest.asstring:= stringtoutf8(mstr1);
    end
    else begin
//     dest.asstring:= copy(asmsestring,1,size);
     dest.asstring:= mstr1;
    end;
    if fixedchar then begin
     dest.datatype:= ftfixedchar;
    end;
   end;
  end;
 end
 else begin
  dest.assignfieldvalue(source,source.value);
 end;
end;

procedure tmsebufdataset.oldfieldtoparam(const source: tfield;
               const dest: tparam);
var
 bo1:boolean;
 mstr1: msestring;
begin
 if source is tmsestringfield then begin
  mstr1:= tmsestringfield(source).oldmsestring(bo1);
  if bo1 then begin
   dest.clear;
   if tmsestringfield(source).fixedchar then begin
    dest.datatype:= ftfixedchar;
   end
   else begin
    dest.datatype:= ftstring;
   end;
  end
  else begin
   if bs_utf8 in fbstate then begin
    dest.asstring:= stringtoutf8(mstr1);
   end
   else begin
    dest.asstring:= mstr1;
   end;
   if tmsestringfield(source).fixedchar then begin
    dest.datatype:= ftfixedchar;
   end;
  end;
 end
 else begin
  dest.assignfieldvalue(source,source.oldvalue);
 end;
end;

procedure tmsebufdataset.stringtoparam(const source: msestring;
               const dest: tparam);
begin
 if bs_utf8 in fbstate then begin
  dest.asstring:= stringtoutf8(source);
 end
 else begin
  dest.asstring:= source;
 end;
end;

procedure tmsebufdataset.bindfields(const bind: boolean);
var
 int1: integer;
 field1: tfield;
 int2: integer;
 fielddef1: tfielddef;
begin
 for int1:= fields.count - 1 downto 0 do begin
  field1:= fields[int1];
  if field1 is tmsestringfield then begin
   int2:= 0;
   if bind then begin
    if field1.fieldkind = fkdata then begin
     fielddef1:= tfielddef(fielddefs.find(field1.fieldname));
                   //needed for FPC 2_2
     if fielddef1 <> nil then begin
      int2:= fielddef1.size;
     end;
    end;
    tmsestringfield1(field1).setismsestring(@getmsestringdata,
                                                  @setmsestringdata,int2);
   end
   else begin
    tmsestringfield1(field1).setismsestring(nil,nil,int2);
   end;
  end
  else begin
   if field1 is tmseblobfield then begin
    if bind then begin
     tmseblobfield1(field1).fgetblobid:= @getfieldblobid;
    end
    else begin
     tmseblobfield1(field1).fgetblobid:= nil;
    end;
   end;
  end;
 end;
 inherited;
end;

function tmsebufdataset.isutf8: boolean;
begin
 result:= false; //default
end;

procedure tmsebufdataset.append;
begin
 include(fbstate,bs_append);
 inherited;
end;

procedure tmsebufdataset.setoninternalcalcfields(
            const avalue: internalcalcfieldseventty);
begin
 foninternalcalcfields:= avalue;
 updatestate;
end;

procedure tmsebufdataset.dataevent(event: tdataevent; info: ptrint);
begin
 if event in [deupdaterecord,dedatasetchange] then begin
  exclude(fbstate,bs_visiblerecordcountvalid);
 end;
 if (event = deupdatestate) and (state = dsbrowse) then begin
  updatecursorpos; //update fcurrentbuf after open
 end;
 inherited;
 case event of
  deupdaterecord: begin
   if checkcanevent(self,tmethod(foninternalcalcfields)) then begin
    foninternalcalcfields(self,false);
   end;
  end;
 end;
end;

function tmsebufdataset.bookmarktostring(const abookmark: bookmarkdataty): string;
begin
 setlength(result,sizeof(abookmark));
 move(abookmark,pointer(result)^,sizeof(abookmark));
end;

procedure tmsebufdataset.checkrecno(const avalue: integer);
begin
 if (avalue > recordcount) or (avalue < 1) then begin
  databaseerror(snosuchrecord,self);
 end;
end;

procedure tmsebufdataset.setonfilterrecord(const value: tfilterrecordevent);
begin
 inherited;
 if not (csdesigning in componentstate) then begin
  checkfilterstate;
  filterchanged;
 end;
end;

procedure tmsebufdataset.setfiltered(value: boolean);
begin
 inherited;
 filterchanged; 
end;

procedure tmsebufdataset.filterchanged;
begin
 exclude(fbstate,bs_visiblerecordcountvalid);
 if not (state in [dsinactive,dsfilter]) then begin
  checkbrowsemode;
  resync([]);
 end;
end;

procedure tmsebufdataset.beginfilteredit;
begin
 if state <> dsfilter then begin
  checkbrowsemode;
  fbuffercountbefore:= buffercount;
  setbuflistsize(1);
  setstate(dsfilter);
  dataevent(dedatasetchange,0);
 end;
end;

procedure tmsebufdataset.endfilteredit;
begin
 if state = dsfilter then begin
  dataevent(deupdaterecord, 0);
  setbuflistsize(fbuffercountbefore);
  setstate(dsbrowse);
  resync([]);
 end;
end;

procedure tmsebufdataset.checkfilterstate;
begin
 exclude(fbstate,bs_hasfilter);
 if checkcanevent(self,tmethod(onfilterrecord)) then begin
  include(fbstate,bs_hasfilter);
 end
end;

procedure tmsebufdataset.loaded;
begin
 inherited;
 checkfilterstate;
end;

procedure tmsebufdataset.dofilterrecord(var acceptable: boolean);
begin
 if checkcanevent(self,tmethod(onfilterrecord)) then begin
  onfilterrecord(self,acceptable);
 end;
end;

procedure tmsebufdataset.clearrecord;
var
 int1: integer;
begin
 checkactive;
 try
  disablecontrols;
  for int1:= 0 to fields.count - 1 do begin
   with fields[int1] do begin
    if state = dsfilter then begin
     if not isblob then begin
      clear;
     end;
    end
    else begin
     if not readonly then begin
      clear;
     end;
    end;
   end;
  end;
 finally
  enablecontrols;
 end;
end;

procedure tmsebufdataset.fetchall;
begin
 getnextpacket(true);
end;

function tmsebufdataset.countvisiblerecords: integer;
var
 int1,int2: integer;
 getresult: tgetresult;
begin
 checkbrowsemode;
 if not (bs_visiblerecordcountvalid in fbstate) then begin
  if not filtered then begin
   fetchall;
   fvisiblerecordcount:= fbrecordcount;
  end
  else begin
   int1:= frecno;
   disablecontrols;
   getnextpacket(true);
   try
    fvisiblerecordcount:= 0;
    internalsetrecno(0);
    if (getrecord(activebuffer,gmcurrent,false) = grok) or 
       (getrecord(activebuffer,gmnext,false) = grok) then begin
     repeat
      inc(fvisiblerecordcount);
     until getrecord(activebuffer,gmnext,false) <> grok;
    end;   
   finally
    internalsetrecno(int1);
    getrecord(activebuffer,gmcurrent,false);
    enablecontrols;
   end;
  end;
  include(fbstate,bs_visiblerecordcountvalid);
 end;    
 result:= fvisiblerecordcount;
end;

const
 bufdattag: bufdattagty = 'MSEBUFDAT'#0#0#0#0#0#0;
   
// data format:
//
// header: bdsfheaderty
// fielddefs
// currentvalues: recbufferheader,pointer,nullmask,fielddata
// updatebuffer
// updatebufferitem: updatebufferheader,old nullmask,fielddata if not insert
// post log
// endmarker
 
procedure tmsebufdataset.logupdatebuffer(const awriter: tbufstreamwriter; 
                const abuffer: recupdatebufferty; const adeletedrecord: pintrecordty;
                const alogging: boolean; const alogmode: logflagty);
var
 header1: logbufferheaderty;
 datapo: precheaderty;
 int2: integer;
begin
 header1.flag:= alogmode;
 with abuffer,header1.update do begin
  if (bookmark.recordpo <> nil) or (deletedrecord <> nil) then begin
   deletedrecord:= adeletedrecord;
   logging:= alogging;
   kind:= updatekind;
   po:= bookmark.recordpo;
   awriter.writelogbufferheader(header1);
   if (alogmode = lf_update) and 
       ((kind = ukmodify) or 
              not logging and (kind = ukdelete) and (po <> nil)) then begin
    datapo:= @(oldvalues^.header);
    awriter.write(datapo^.fielddata,fnullmasksize);
    for int2:= 0 to high(ffieldinfos) do begin
     awriter.writefielddata(datapo,int2);
    end;
   end;
  end;
 end;
end;

procedure tmsebufdataset.logrecbuffer(const awriter: tbufstreamwriter;
                       const akind: tupdatekind; const abuffer: pintrecordty);
var
 datapo: precheaderty;
 header1: logbufferheaderty;
 int1: integer;
begin
 header1.flag:= lf_rec;
 with header1.rec do begin
  kind:= akind;
  po:= abuffer;
 end;
 awriter.writelogbufferheader(header1);
 if akind in [ukmodify,ukinsert] then begin
  datapo:= @(abuffer^.header);
  awriter.write(datapo^.fielddata,fnullmasksize);
  for int1:= 0 to high(ffieldinfos) do begin
   awriter.writefielddata(datapo,int1);
  end;
 end;
end;

procedure tmsebufdataset.savestate(const awriter: tbufstreamwriter);
var
 header: tbsfheaderty;
 writer: tbufstreamwriter;
 fieldco: integer;
 int1,int2: integer;
begin
 fieldco:= length(ffieldinfos);
 with header do begin
  tag:= bufdattag;
  byteorder:= 0;
  version:= 0;
  fieldcount:= fieldco;
  fielddefcount:= fielddefs.count;
  recordcount:= self.recordcount;
 end;
 if header.fieldcount > 0 then begin
  awriter.write(header,sizeof(header));
  for int1:= 0 to header.fielddefcount - 1 do begin
   awriter.writefielddef(fielddefs[int1]);
  end;
  awriter.write(ffieldinfos[0],fieldco * sizeof(ffieldinfos[0]));
  with findexes[0] do begin
   for int1:= 0 to recordcount - 1 do begin
    logrecbuffer(awriter,ukinsert,pintrecordty(ind[int1]));
   end;
  end;
  for int1:= 0 to high(fupdatebuffer) do begin
   with fupdatebuffer[int1] do begin
    if bookmark.recordpo <> nil then begin
    {
     if updatekind = ukinsert then begin
      logrecbuffer(awriter,updatekind,
                      bookmark.recordpo);
     end;    
    }
     logupdatebuffer(awriter,fupdatebuffer[int1],nil,false,lf_update);
    end;
   end;
  end;
 end;
end;

procedure tmsebufdataset.savetostream(const astream: tstream);
var
 writer: tbufstreamwriter;
begin
 checkbrowsemode;
 fetchallblobs;
 writer:= tbufstreamwriter.create(self,astream);
 try
  savestate(writer);
  writer.writeendmarker;
 finally
  writer.free;
 end;
end;

procedure tmsebufdataset.doloadfromstream;

 procedure formaterror;
 begin
  databaseerror('Invalid data stream.',self);
 end;
 
var
 header: tbsfheaderty;
 reader: tbufstreamreader;
 fieldco: integer;
 ar1: fieldinfoarty;
 ar2: pointerarty;
 ar3: integerarty;
 appended: pointerarty;
 po1: pointer;
 
 function findrec(const oldpo: pointer; out newpo: pointer;
                                out aindex: integer;
                                const delete: boolean = false): boolean;
           //returns new pointer
 var
  int1: integer;
 begin
  result:= findarrayitem(oldpo,ar2,@comparepointer,
                                          sizeof(pointer),int1);
  if result then begin
   aindex:= ar3[int1];
   newpo:= findexes[0].ind[aindex];
   if delete then begin
    dec(header.recordcount);
    dec(fbrecordcount);
    deleteitem(findexes[0].ind,aindex);
    deleteitem(ar3,int1);
    deleteitem(ar2,int1);
   end;
  end
  else begin
   for int1:= 0 to high(appended) do begin
    if appended[int1] = oldpo then begin
     aindex:= header.recordcount+int1;
     newpo:= findexes[0].ind[aindex];
     result:= true;
     if delete then begin
      deleteitem(appended,int1);
      dec(fbrecordcount);
     end;
     break;
    end;
   end;
  end;
 end;

var
 actindexbefore: integer; 
 oldupdatepointers: pointerarty;
 bo1: boolean;
 int1,int2,int3: integer;
 header1: logbufferheaderty;
 updabuf: recupdatebufferarty;
 
begin
 actindexbefore:= factindex;
 factindex:= 0;
 factindexpo:= @findexes[0];
 fbstate:= fbstate - [bs_blobscached,bs_indexvalid];
// exclude(fbstate,bs_blobscached);
 reader:= tbufstreamreader.create(self,floadingstream);
 try
  reader.readbuffer(header,sizeof(header));
  if (header.tag <> bufdattag) or (header.fielddefcount > 1000) then begin
   formaterror;
  end;
  try
   fielddefs.beginupdate;
   try
    fielddefs.clear;
    for int1:= 0 to header.fielddefcount - 1 do begin
     reader.readfielddef(fielddefs);
    end;
   finally
    fielddefs.endupdate;
   end;
   dointernalopen;
   fieldco:= length(ffieldinfos);
   if (header.fieldcount <> fieldco) then begin
    formaterror;
   end;
   if fieldco > 0 then begin
    setlength(ar1,fieldco);
    reader.readbuffer(ar1[0],fieldco * sizeof(ar1[0]));
    for int1:= 0 to high(ar1) do begin
     if not comparemem(@ar1[int1],@ffieldinfos[int1],sizeof(ar1[0]) - 
                  sizeof(ar1[0].field)) then begin
      formaterror;
     end;
    end;
    setlength(ar2,header.recordcount);
    for int1:= 0 to high(ar2) do begin
     if not reader.readlogbufferheader(header1) or 
                                   (header1.flag <> lf_rec) then begin
      formaterror;
     end;
     ar2[int1]:= header1.rec.po;
     reader.readrecord(femptybuffer);
     appendrecord(femptybuffer);
     femptybuffer:= intallocrecord;
    end;
    ar1:= nil;
    if header.recordcount > 0 then begin
     allocuninitedarray(fbrecordcount,sizeof(pointer),ar1);
     move(pointer(findexes[0])^,pointer(ar1)^,fbrecordcount*sizeof(pointer));
     sortarray(ar2,@comparepointer,sizeof(pointer),ar3);
         //index of old pointers
    end
    else begin
     ar3:= nil;
    end;
    int2:= 0;
    while reader.readlogbufferheader(header1) do begin
     case header1.flag of
      lf_rec: begin
       with header1.rec do begin
        if not findrec(po,po1,int1) then begin
         if kind <> ukinsert then begin
          formaterror;
         end;
         reader.readrecord(femptybuffer);
         appendrecord(femptybuffer);
         femptybuffer:= intallocrecord;
         additem(appended,po);
        end
        else begin
         reader.readrecord(po1);
        end;
       end;        
      end;
      lf_update: begin
       if high(updabuf) < int2 then begin
        setlength(updabuf,2*high(updabuf)+258);
        setlength(oldupdatepointers,length(updabuf));
       end;     
       with updabuf[int2],header1.update do begin
        updatekind:= kind;
        oldupdatepointers[int2]:= po;
        int3:= -1;
        if deletedrecord <> nil then begin
         for int1:= 0 to int2-1 do begin
          if oldupdatepointers[int1] = deletedrecord then begin
           int3:= int1;
           break;
          end;
         end;
        end;
        if kind = ukdelete then begin 
         if logging and (po <> deletedrecord) then begin
          if (int3 < 0) or 
                           not findrec(deletedrecord,po1,int1,true) then begin
           formaterror;
          end;
          if po = nil then begin
           bookmark.recordpo:= nil;   //deleting of inserted record
           intfreerecord(po1);
          end
          else begin        //deleting of modified record
           intfreerecord(updabuf[int3].bookmark.recordpo);
           bookmark.recordpo:= updabuf[int3].oldvalues;
           bookmark.recno:= 0;
          end;
          updabuf[int3].bookmark.recordpo:= nil; //to be removed
         end
         else begin
          if logging then begin
           if not findrec(deletedrecord,bookmark.recordpo,
                                         bookmark.recno,true) then begin
            formaterror;
           end;
          end
          else begin
           bookmark.recno:= 0;
           bookmark.recordpo:= intallocrecord;
           reader.readrecord(bookmark.recordpo);
          end;
         end;
         oldvalues:= bookmark.recordpo;
        end
        else begin
         if not findrec(po,bookmark.recordpo,bookmark.recno) then begin
          formaterror;        //old pointer not found
         end;
        end;
        if kind = ukmodify then begin
         oldvalues:= intallocrecord;
         reader.readrecord(oldvalues);
        end;
       end;
       inc(int2);
      end;
      lf_cancel: begin
       with header1.update do begin
        int3:= -1;
        for int1:= 0 to int2 - 1 do begin
         if oldupdatepointers[int1] = po then begin
          int3:= int1;
          break;
         end;
        end;
        if int3 < 0 then begin
         formaterror;
        end;
        case kind of
         ukmodify: begin
          cancelrecupdate(updabuf[int3]);
         end;
         ukdelete: begin
          with updabuf[int3] do begin
           appendrecord(bookmark.recordpo);
           additem(appended,bookmark.recordpo);
          end;
         end;
         ukinsert: begin
          if not findrec(oldupdatepointers[int3],po1,int1,true) then begin
           formaterror;
          end;
          with updabuf[int3] do begin
           intfreerecord(bookmark.recordpo);
          end;
         end;
        end;
        updabuf[int3].bookmark.recordpo:= nil;
        oldupdatepointers[int3]:= nil;
                    //inactive
       end;
      end;
      lf_apply: begin
       with header1.update do begin
        int3:= -1;
        for int1:= 0 to int2-1 do begin
         if oldupdatepointers[int1] = po then begin
          int3:= int1;
          break;
         end;
        end;
        if int3 < 0 then begin
         formaterror;
        end;
        with updabuf[int3] do begin
         intfreerecord(oldvalues);
         bookmark.recordpo:= nil;
         oldupdatepointers[int3]:= nil;
                    //inactive
        end;
       end;
      end;
      else begin
       formaterror;
      end;
     end;
    end; 
    setlength(updabuf,int2);
    setlength(fupdatebuffer,int2);   
    int2:= 0;     //pack updatebuffer
    for int1:= 0 to high(updabuf) do begin
     if updabuf[int1].bookmark.recordpo <> nil then begin
      fupdatebuffer[int2]:= updabuf[int1];
      inc(int2);
     end;
    end;
    setlength(fupdatebuffer,int2);
    fallpacketsfetched:= true;
   end;
   include(fbstate,bs_blobsfetched);
   sortblobcache;
  except
   dointernalclose;
   raise;
  end;
 finally
  reader.free;
  factindex:= actindexbefore;
  factindexpo:= @findexes[factindex];
 end;
end;

procedure tmsebufdataset.loadfromstream(const astream: tstream);
begin
 checkinactive;
 floadingstream:= astream;
 include(fbstate,bs_loading);
 try
  active:= true;
 finally
  exclude(fbstate,bs_loading);
 end;
end;

function tmsebufdataset.streamloading: boolean;
begin
 result:= bs_loading in fbstate;
end;

function tmsebufdataset.addblobcache(const adata: pointer;
                         const alength: integer): integer;
begin
 result:= fblobcount;
 inc(fblobcount);
 if result > high(fblobcache) then begin
  setlength(fblobcache,2*result+256);
 end;
 with fblobcache[result] do begin
  id:= result;
  setlength(data,alength);
 {$ifdef FPC} {$checkpointer off} {$endif} //adata can be foreign memory
  move(adata^,pointer(data)^,alength);
 {$ifdef FPC} {$checkpointer default} {$endif}
 end;
 exclude(fbstate,bs_blobssorted);
end;

function tmsebufdataset.addblobcache(const aid: int64;
                                const adata: string): integer;
begin
 result:= fblobcount;
 inc(fblobcount);
 if result > high(fblobcache) then begin
  setlength(fblobcache,2*result+256);
 end;
 with fblobcache[result] do begin
  id:= aid;
  data:= adata;
 end;
 exclude(fbstate,bs_blobssorted);
end;

function tmsebufdataset.wantblobfetch: boolean;
begin
 result:= false;
end;

procedure tmsebufdataset.checkconnected;
begin
 if not (bs_connected in fbstate) then begin
  databaseerror('Not connected.',self);
 end;
end;

procedure tmsebufdataset.savetofile(const afilename: filenamety);
var
 stream1: tstream;
begin
 stream1:= tmsefilestream.create(afilename,fm_create);
 try
  savetostream(stream1);
 finally
  stream1.free;
 end;
end;

procedure tmsebufdataset.loadfromfile(const afilename: filenamety);
var
 stream1: tstream;
begin
 stream1:= tmsefilestream.create(afilename,fm_read);
 try
  loadfromstream(stream1);
 finally
  stream1.free;
 end;
end;

procedure tmsebufdataset.recover;
begin
 if trim(flogfilename) = '' then begin
  databaseerror('No log file name.',self);
 end;
 if islocal then begin
  active:= true;
 end
 else begin
  loadfromfile(flogfilename);
  startlogger;
 end;
end;

procedure tmsebufdataset.startlogger;
var
 stream1: tmsefilestream;
begin
 if flogfilename <> '' then begin
  stream1:= tmsefilestream.create(flogfilename,fm_create);
  flogger:= tbufstreamwriter.create(self,stream1);
  savestate(flogger);
  flogger.flushbuffer;
 end;
end;

procedure tmsebufdataset.closelogger;
var
 stream1: tstream;
begin
 if flogger <> nil then begin
  flogger.writeendmarker;
  stream1:= flogger.fstream;
  freeandnil(flogger);
  stream1.free;
 end;
end;

function tmsebufdataset.islocal: boolean;
begin
 result:= false;
end;

{ tlocalindexes }

constructor tlocalindexes.create(const aowner: tmsebufdataset);
begin
 inherited create(aowner,tlocalindex);
end;

function tlocalindexes.getitems(const index: integer): tlocalindex;
begin
 result:= tlocalindex(inherited items[index]);
end;

procedure tlocalindexes.checkinactive;
begin
 if tmsebufdataset(fowner).active then begin
  databaseerror(SActiveDataset,tmsebufdataset(fowner));
 end;
end;

procedure tlocalindexes.setcount1(acount: integer; doinit: boolean);
begin
 checkinactive;
 inherited;
 if not (aps_destroying in fstate) then begin
  tmsebufdataset(fowner).updatestate;
 end;
end;

procedure tlocalindexes.bindfields;
var
 int1: integer;
begin
 for int1:= count - 1 downto 0 do begin
  items[int1].bindfields;
 end;
end;

procedure tlocalindexes.move(const curindex: integer; const newindex: integer);
begin
 checkinactive;
 inherited;
end;

function tlocalindexes.getactiveindex: integer;
begin
 result:= tmsebufdataset(fowner).actindex - 1;
end;

procedure tlocalindexes.setactiveindex(const avalue: integer);
begin
 if avalue < 0 then begin
  tmsebufdataset(fowner).actindex:= 0;
 end
 else begin
  items[avalue].active:= true;
 end;
end;

{ tlocalindex }

constructor tlocalindex.create(aowner: tobject);
begin
 ffields:= tindexfields.create(self);
 inherited;
end;

destructor tlocalindex.destroy;
begin
 ffields.free;
 inherited;
end;

procedure tlocalindex.setfields(const avalue: tindexfields);
begin
 ffields.assign(avalue);
end;

procedure tlocalindex.change;
var
 int1: integer;
begin
 with tmsebufdataset(fowner) do begin
  if fopen then begin
   self.bindfields;
   int1:= findexlocal.indexof(self) + 1;
   with findexes[int1] do begin
    if ind <> nil then begin
     if factindex = int1 then begin
      checkbrowsemode;
     end;
     ind:= nil;
     exclude(fbstate,bs_indexvalid);
     if factindex = int1 then begin
      internalsetrecno(findrecord(fcurrentbuf));
      resync([]);
     end;
    end;
   end;
  end;
 end;
end;

procedure tlocalindex.setoptions(const avalue: localindexoptionsty);
begin
 if foptions <> avalue then begin
  foptions:= avalue;
  change;
 end;
end;

function tlocalindex.compare(l,r: pintrecordty; const alastindex: integer;
             const apartialstring: boolean): integer;
var
 int1: integer;
begin
 result:= 0;
 for int1:= 0 to alastindex do begin
  with findexfieldinfos[int1] do begin
   if getfieldisnull(@l^.header.fielddata.nullmask,fieldindex) then begin
    if getfieldisnull(@r^.header.fielddata.nullmask,fieldindex) then begin
     continue;
    end
    else begin
     dec(result);
    end;
   end
   else begin
    if getfieldisnull(@r^.header.fielddata.nullmask,fieldindex) then begin
     inc(result);
    end
    else begin    
     result:= comparefunc((pointer(l)+recoffset)^,(pointer(r)+recoffset)^);
    end;
   end;
   if desc then begin
    result:= -result;
   end;
   if result <> 0 then begin
    if apartialstring and canpartialstring and (int1 = alastindex) and
     (caseinsensitive and 
        mseissametextlen(pmsestring(pointer(l)+recoffset)^,
                pmsestring(pointer(r)+recoffset)^) or
      not caseinsensitive and 
        mseissamestrlen(pmsestring(pointer(l)+recoffset)^,
                pmsestring(pointer(r)+recoffset)^)) then begin
     result:= 0;
    end;               
    break;
   end;
  end;
 end;
 if lio_desc in foptions then begin
  result:= -result;
 end;
end;

procedure tlocalindex.quicksort(l,r: integer);
var
  i,j: integer;
  p: integer;
  int: integer;
  po1: pintrecordty;
  lastind: integer;
begin
 lastind:= high(findexfieldinfos);
 repeat
  i:= l;
  j:= r;
  p:= (l + r) shr 1;
  repeat
   while compare(fsortarray^[i],fsortarray^[p],lastind,false) < 0 do begin
    inc(i);
   end;
   while compare(fsortarray^[j],fsortarray^[p],lastind,false) > 0 do begin
    dec(j);
   end;
   if i <= j then begin
    po1:= fsortarray^[i];
    fsortarray^[i]:= fsortarray^[j];
    fsortarray^[j]:= po1;
    if p = i then begin
     p:= j
    end
    else begin
     if p = j then begin
      p:= i;
     end;
    end;
    inc(i);
    dec(j);
   end;
  until i > j;
  if l < j then begin
   quicksort(l,j);
  end;
  l:= i;
 until i >= r;
end;

function tlocalindex.findboundary(const arecord: pintrecordty;
                       const alastindex: integer; const abigger: boolean): integer;
                          //returns index of next bigger
var
 int1: integer;
 lo,up,pivot: integer;
begin
 result:= 0;
 with tmsebufdataset(fowner),findexes[findexlocal.indexof(self) + 1] do begin
  if fbrecordcount > 0 then begin
   int1:= 0;
   checkindex(true);
   lo:= 0;
   up:= fbrecordcount - 1;
   if abigger then begin
    while lo <= up do begin
     pivot:= (up + lo) div 2;
     int1:= compare(arecord,ind[pivot],alastindex,false);
     if int1 >= 0 then begin //pivot <= rev
      lo:= pivot + 1;
     end
     else begin
      up:= pivot;
      if up = lo then begin
       break;
      end;
     end;
    end;
    result:= lo;
   end
   else begin
    while lo <= up do begin
     pivot:= (up + lo + 1) div 2;
     int1:= compare(arecord,ind[pivot],alastindex,false);
     if int1 <= 0 then begin //pivot >= rev
      up:= pivot - 1;
     end
     else begin
      lo:= pivot;
      if up = lo then begin
       break;
      end;
     end;
    end;
    result:= up;
   end;
  end;
 end;
end;

function tlocalindex.findrecord(const arecord: pintrecordty): integer;
var
 int1: integer;
 po1: ppointeraty;
begin
 result:= -1;
 int1:= findboundary(arecord,high(findexfieldinfos),true) - 1;
 with tmsebufdataset(fowner) do begin
  po1:= pointer(findexes[findexlocal.indexof(self) + 1].ind);
 end;
 for int1:= int1 downto 0 do begin
  if po1^[int1] = arecord then begin 
   result:= int1;
   break;
  end;
 end;
end;

procedure tlocalindex.sort(var adata: pointerarty);
begin
 if adata <> nil then begin
  fsortarray:= @adata[0];
  quicksort(0,tmsebufdataset(fowner).fbrecordcount - 1);
 end;
end;

function tlocalindex.getactive: boolean;
begin
 with tmsebufdataset(fowner) do begin
  result:= actindex = findexlocal.indexof(self) + 1;
 end;
end;

procedure tlocalindex.setactive(const avalue: boolean);
var
 int1: integer;
begin
 with tmsebufdataset(fowner) do begin
  int1:= findexlocal.indexof(self) + 1;
  if avalue then begin
   actindex:= int1;
  end
  else begin
   if actindex = int1 then begin
    actindex:= 0;
   end;
  end;
 end;   
end;

procedure tlocalindex.bindfields;
var
 int1: integer;
 field1: tfield;
 kind1: fieldcomparekindty;
begin
 setlength(findexfieldinfos,ffields.count);
 with tmsebufdataset(fowner) do begin
  for int1:= 0 to high(findexfieldinfos) do begin
   with ffields.items[int1],findexfieldinfos[int1] do begin
    field1:= findfield(fieldname);
    if field1 = nil then begin
     databaseerror('Index field "'+fieldname+'" not found.',
                                                   tmsebufdataset(fowner));
    end;
    with field1 do begin
     if not(fieldkind in [fkdata,fkinternalcalc]) or 
                      not (datatype in indexfieldtypes) then begin
      databaseerror('Invalid index field "'+fieldname+'".',
                                                   tmsebufdataset(fowner));
     end;
     for kind1:= low(fieldcomparekindty) to high(fieldcomparekindty) do begin
      with comparefuncs[kind1] do begin
       if datatype in datatypes then begin
        vtype:= cvtype;
        if ifo_caseinsensitive in options then begin
         comparefunc:= compfunci;
        end
        else begin
         comparefunc:= compfunc;
        end;
        break;
       end;
      end;
     end;
     fieldindex:= fieldno - 1;
     if fieldindex >= 0 then begin
      recoffset:= ffieldinfos[fieldindex].offset{ffieldbufpositions[fieldindex]}+
                          intheadersize;
     end
     else begin
      recoffset:= offset; //calc field
     end;
     desc:= ifo_desc in foptions;
     caseinsensitive:= ifo_caseinsensitive in foptions;
     canpartialstring:= vtype = vtwidestring;
    end;
   end;
  end;
 end;
end;

procedure paramerror;
begin
 databaseerror('Invalid find parameters.');
end;

function tlocalindex.find(const avalues: array of const;
             const aisnull: array of boolean; out abookmark: string;
             const abigger: boolean = false;
             const partialstring: boolean = false): boolean;
var
 int1: integer; 
 v: tvarrec;
 po1: pintrecordty;
 po2: pointer;
 bo1: boolean;
 bm1: bookmarkdataty;
 lastind: integer;
label
 endlab;
begin
 tmsebufdataset(fowner).checkbrowsemode;
 lastind:= high(avalues);
 if lastind > high(findexfieldinfos) then begin
  paramerror;
 end;
 for int1:= lastind downto 0 do begin
  if avalues[int1].vtype <> findexfieldinfos[int1].vtype then begin
   paramerror;
  end;
 end;
 po1:= tmsebufdataset(fowner).intallocrecord;
 for int1:= lastind downto 0 do begin
  with findexfieldinfos[int1],avalues[int1] do begin
   po2:= pointer(po1) + recoffset;
   bo1:= false;
   case vtype of
    vtinteger: begin
     pinteger(po2)^:= vinteger;
    end;
    vtwidestring: begin
     ppointer(po2)^:= vwidestring;
     bo1:= vwidestring = nil;
    end;
    vtextended: begin
     pdouble(po2)^:= vextended^;
     bo1:= isemptyreal(pdouble(po2)^);
    end;
    vtcurrency: begin
     pcurrency(po2)^:= vcurrency^;
    end;
    vtboolean: begin
     pwordbool(po2)^:= vboolean;
    end;
    vtint64: begin
     pint64(po2)^:= vint64^;
    end;
   end;
   if int1 <= high(aisnull) then begin
    bo1:= aisnull[int1];
   end;
   if not bo1 then begin
    unsetfieldisnull(@po1^.header.fielddata.nullmask,fieldindex);
   end; 
  end;
 end;
 int1:= findboundary(po1,lastind,abigger);
 result:= false;
 abookmark:= '';
 with tmsebufdataset(fowner) do begin
  with findexes[findexlocal.indexof(self) + 1] do begin
   if abigger then begin
    if int1 <= 0 then begin
     goto endlab;
    end;
    if compare(po1,ind[int1-1],lastind,false) = 0 then begin
     result:= true;
     dec(int1);
    end;
   end
   else begin
    if int1 >= fbrecordcount - 1 then begin
     goto endlab;
    end;     
    if compare(po1,ind[int1+1],lastind,false) = 0 then begin
     result:= true;
     inc(int1);
    end;
   end;
   if (int1 >= 0) and (int1 < fbrecordcount) then begin
    if partialstring then begin
     if not result then begin
      result:= compare(po1,ind[int1],lastind,true) = 0;
      if not result then begin
       inc(int1);
       if (int1 >= fbrecordcount) or 
                      (compare(po1,ind[int1],lastind,true) <> 0) then begin
        dec(int1,2);         //for reversed order
        if (int1 < 0) or 
                      (compare(po1,ind[int1],lastind,true) <> 0) then begin
         dec(int1);
         if (int1 < 0) or 
                      (compare(po1,ind[int1],lastind,true) <> 0) then begin
          inc(int1,2);
         end
         else begin
          result:= true;
         end;
        end
        else begin
         result:= true;
        end;
       end
       else begin
        result:= true;
       end;
      end;         
     end;
    end;          
    bm1.recno:= int1;
    bm1.recordpo:= ind[int1];
    abookmark:= bookmarktostring(bm1);
   end;
  end;
 end;
endlab:
 freemem(po1);
end;

function tlocalindex.find(const avalues: array of const;
    const aisnull: array of boolean;
    const alast: boolean = false; const partialstring: boolean = false): boolean;
                //sets dataset cursor if found
var
 str1: string;
begin
 result:= find(avalues,aisnull,str1,alast,partialstring);
 if result then begin
  tmsebufdataset(fowner).bookmark:= str1;
 end;
end;

function tlocalindex.getbookmark(const arecno: integer): string;
var
 bm1: bookmarkdataty;
begin
 with tmsebufdataset(fowner) do begin
  checkrecno(arecno);
  checkindex(true);
  bm1.recno:= arecno - 1;
  bm1.recordpo:= findexes[findexlocal.indexof(self) + 1].ind[arecno-1];
  result:= bookmarktostring(bm1);
 end;
end;

{ tindexfields }

constructor tindexfields.create(const aowner: tlocalindex);
begin
 inherited create(aowner,tindexfield);
end;

function tindexfields.getitems(const index: integer): tindexfield;
begin
 result:= tindexfield(inherited items[index]);
end;

{ tindexfield }

procedure tindexfield.change;
begin
 tlocalindex(fowner).change;
end;

procedure tindexfield.setfieldname(const avalue: string);
begin
 ffieldname:= avalue;
 change;
end;

procedure tindexfield.setoptions(const avalue: indexfieldoptionsty);
begin
 if foptions <> avalue then begin
  foptions:= avalue;
  change;
 end;
end;

end.

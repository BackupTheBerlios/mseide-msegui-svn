{ MSEgui Copyright (c) 1999-2009 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit msestream;   

{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifndef FPC}{$ifdef linux} {$define UNIX} {$endif}{$endif}

// {$WARN SYMBOL_PLATFORM off}
interface
uses 
 Classes,Sysutils,msestrings,msetypes,msethread,msesys,msereal,mseevent;

const
 defaultfilerights = [s_irusr,s_iwusr,s_irgrp,s_iwgrp,s_iroth,s_iwoth];
 defaultdirrights = [s_irusr,s_iwusr,s_ixusr,s_irgrp,s_iwgrp,
                     s_ixgrp,s_iroth,s_iwoth,s_ixoth];
type
 tmsefilestream = class(thandlestream)
  private
   ffilename: filenamety;
   ftransactionname: filenamety;
   function getmemory: pointer;
   procedure checkmemorystream;
  protected
   fmemorystream: tmemorystream;
   procedure sethandle(value: integer); virtual;
   procedure closehandle(const ahandle: integer); virtual;
  public
   constructor create(const afilename: filenamety; openmode: fileopenmodety = fm_read;
                                 accessmode: fileaccessmodesty = [];
                                 rights: filerightsty = defaultfilerights); overload;
   constructor createtransaction(const afilename: filenamety;
                                 rights: filerightsty = defaultfilerights); overload;
   constructor create(ahandle: integer); overload; virtual; //allways called
   constructor create; overload; //tmemorystream
   destructor destroy; override;
   function read(var buffer; count: longint): longint; override;
   function write(const buffer; count: longint): longint; override;
   function seek(const offset: int64; origin: tseekorigin): int64; override;
   function readdatastring: string; virtual; //bringt ab filepointer alle zeichen
   procedure writedatastring(const value: string);
   function isopen: boolean;
   property filename: filenamety read ffilename;
   property transactionname: filenamety read ftransactionname;
   function close: boolean; //false on commit error
   procedure cancel; //calls close without commit, removes intermediate file
   procedure flush; virtual;

   procedure setsize(const newsize: int64); override;
   procedure clear;        //only for memorystream
   property memory: pointer read getmemory;     //only for memorystream
 end;

const
 defaultbuflen = 256;

type
 textstreamstatety = (tss_eof,tss_error,tss_notopen,tss_pipeactive,tss_response,
                      tss_nosigio,tss_unblocked);
 textstreamstatesty = set of textstreamstatety;

 charencodingty = (ce_locale,ce_utf8n,ce_ascii,ce_iso8859_1);
                         //ce_ascii -> 7Bit,
                         //string and msestrings -> pascalstrings

 ttextstream = class(tmsefilestream)
  private
   fposvorher: integer;
//   fnotopen: boolean;
   fsearchabortpo: pboolean;
   fsearchlinestartpos: cardinal;
   fsearchlinenumber: cardinal;
   fsearchpos: cardinal;
   fsearchfoundpos: cardinal;
   fsearchtext: string;
   fsearchtextlower: string;
   fsearchtextupper: string;
   fsearchoptions: searchoptionsty;
   fsearchtextvalid: boolean;
   finternalbuffer: string;
   fbuflen: integer;

   procedure setsearchtext(const Value: string);
   function getmsesearchtext: msestring;
   procedure setmsesearchtext(const avalue: msestring);
   procedure setsearchoptions(const Value: searchoptionsty);
   function geteof: boolean;
   function getnotopen: boolean;
  protected
   fbuffer: pchar;
   bufoffset, bufend: pchar;
   fstate: textstreamstatesty;
   fencoding: charencodingty;
   procedure setbuflen(const Value: integer); virtual;
   function readbytes(var buf): integer; virtual;
              //reads max. buflen bytes
   function encode(const value: msestring): string;
   function decode(const value: string): msestring;
  public
   constructor create(ahandle: integer); override;
   constructor createdata(const adata: string);
   function Read(var Buffer; Count: Longint): Longint; override;
   function Write(const Buffer; Count: Longint): Longint; overload; override;
   function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; override;
   procedure return;    //setzt filepointer auf letzte readln position

   procedure writestr(const value: string); //no encoding
   procedure writestrln(const value: string); //no encoding
   function readstrln(out value: string): boolean; overload; virtual;
                                              //no encoding
   procedure writetotext(var dest: text);   //no encoding

   procedure write(const value: string); reintroduce; overload;
   procedure writeln(const value: string); overload; virtual;
   procedure write(const value: msestring); reintroduce; overload;
   procedure writeln(const value: msestring); overload;
   procedure writeln(const value: real);  overload;
   procedure writeln(const value: integer);  overload;
   procedure writeln(const value: msestringarty);  overload;
   procedure writeln(const value: stringarty);  overload;

   function readln: boolean; overload;
   function readln(out value: string): boolean; overload;      
           //true wenn zeile vollstaendig, sonst eof erreicht
   function readln(out value: msestring): boolean; overload;       
           //true wenn zeile vollstaendig, sonst eof erreicht
   function readln(out value: integer): boolean; overload;
           //true wenn zeile vollstaendig, sonst eof erreicht
   function readln(out value: real): boolean; overload;
           //true wenn zeile vollstaendig, sonst eof erreicht
   function readln(out value: msestringarty): boolean; overload;
           //true wenn zeile vollstaendig, sonst eof erreicht
   function readln(out value: stringarty): boolean; overload;
           //true wenn zeile vollstaendig, sonst eof erreicht

   procedure writestrings(const value: stringarty);
   procedure writemsestrings(const value: msestringarty);
   function readstrings: stringarty;
   function readmsestrings: msestringarty;
   function readstring(const default: string): string;
                //liest string, bringt defaultwert bei fehler
   function readinteger(default: integer; min: integer = minint;
                            max: integer = maxint): integer;
                //liest integer, bringt defaultwert bei fehler
   function readreal(default: real; min: real = -bigreal;
                            max: real = bigreal): real;
                //liest double, bringt defaultwert bei fehler
                //       begrenzt wert auf min..max
   function findnext(const substring: string): boolean;
            //positioiniert filepointer auf erstes vorkommen von substring, true wenn gefunden
            //wenn nicht gefunden wird filepointer nicht veraendert
            //performance verbesserungswuerdig!!
   function linecount: integer;
            //zaehlt ab aktueller position anzahl linefeeds bis eof


   procedure resetsearch;
   function searchnext: boolean; //true wenn gefunden
   property nativesearchtext: string read fsearchtext write setsearchtext;
   property msesearchtext: msestring read getmsesearchtext write setmsesearchtext;
   property searchoptions: searchoptionsty read fsearchoptions write setsearchoptions;
   property searchpos: cardinal read fsearchpos write fsearchpos;
   property searchfoundpos: cardinal read fsearchfoundpos;
   property searchlinestartpos: cardinal read fsearchlinestartpos write fsearchlinestartpos;
   property searchlinenumber: cardinal read fsearchlinenumber write fsearchlinenumber;
   property searchabortpo: pboolean read fsearchabortpo write fsearchabortpo;

   property notopen: boolean read getnotopen;
   property eof: boolean read geteof;
   property encoding: charencodingty read fencoding write fencoding default ce_locale;
   property buflen: integer read fbuflen write setbuflen default defaultbuflen;

 end;

 ttextdatastream = class(ttextstream)
  private
   fquotechar: msechar;
   fseparator: msechar;
   fforcequote: boolean;
  public                //!!!!!!todo: correct encoding, (linebreaks, whitespaces ...)
   constructor create(ahandle: integer); override;
   procedure writerecord(const fields: array of const); overload;
   procedure writerecord(const fields: msestringarty); overload;
   procedure writerecord(const fields: stringarty); overload;
   procedure writerecord(const fields: integerarty); overload;
   procedure writerecord(const fields: realarty); overload;
   procedure writerecord(const fields: int64arty); overload;
   procedure writerecord(const fields: booleanarty); overload;
   function readrecord(fields: array of pointer; types: string): boolean; //true if no error
                // b -> boolean
                // i -> integer
                // I -> int64
                // s -> ansistring
                // S -> msestring
                // r -> real
   property separator: msechar read fseparator write fseparator default ',';
   property quotechar: msechar read fquotechar write fquotechar default '"';
   property forcequote: boolean read fforcequote write fforcequote default false;
 end;

 tresourcefilestream = class(tmsefilestream)
  public
   procedure WriteResourceHeader(resourcetyp: word;
             const ResName: string; out FixupInfo: Integer);
 end;

 tcryptfilestream = class(tfilestream)      //seek nicht erlaubt!
  private
   seed: word;
   schluesseln: boolean;
   procedure krypt16(var buffer; count: integer);

  public
   constructor Create(const aFileName: string; Mode: Word);

   function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; override;
   function Read(var Buffer; Count: Longint): Longint; override;
   function Write(const Buffer; Count: Longint): Longint; override;
                       //buffer wird veraendert!
 end;

 tstringcopystream = class(tmemorystream)
  private
   fdata: string;
  protected
  public
   constructor create(const adata: string);
   destructor destroy; override;
   function write(const Buffer; Count: Longint): Longint; override;
 end;

 tmemorycopystream = class(tmemorystream)
  private
  protected
  public
   constructor create(const adata: pointer; const asize: integer);
   destructor destroy; override;
   function write(const Buffer; Count: Longint): Longint; override;
 end;
 
function getnextbufferline(var data: pchar; len: integer): string;
                  //data = nil -> fertig
function getbufferline(const data: pchar; linenr,len: integer): string;
                  //1. zeile = 0
function getkeystring(const data: pchar; len: integer; name: string): string;
                  //bringt nach '<name>=' folgenden text
procedure setfilenonblock(handle: integer; value: boolean);

procedure copyvariantarray(const source: array of const; const dest: array of pointer);

function getrecordtypechars(const fields: array of const): string;
                // b -> boolean
                // i -> integer
                // I -> int64
                // s -> ansistring
                // S -> msestring
                // r -> real

function encoderecord(const fields: array of const;
               forcequote: boolean = false; const quotechar: msechar = '"';
               const separator: msechar = ','): msestring;
function decoderecord(const value: msestring;
                   const fields: array of pointer; const types: string;
               const quotechar: msechar = '"';
               const separator: msechar = ','): boolean; overload;
                // types:
                // b -> boolean
                // i -> integer
                // I -> int64
                // s -> ansistring
                // S -> msestring
                // r -> real
               
function readfiledatastring(const afilename: filenamety): string;
procedure writefiledatastring(const afilename: filenamety; const adata: string);

{$ifdef FPC}
type
  THandleStreamcracker = class(TStream)
   public
    FHandle: Integer;
  end;
{$endif}

implementation

uses
 msefileutils,msebits,{msegui,}mseformatstr,sysconst,msesysutils,msesysintf,
 msedatalist,mseclasses,
        {$ifdef UNIX} mselibc,
        {$else} windows,
        {$endif}
  rtlconsts;

{
 tmemorystreamcracker = class(tcustommemorystream)
  private
    FCapacity: Longint;
 end;
}
{$ifdef FPC}
type
 pboolean = ^boolean;
{$endif}

 {$ifdef MSWINDOWS}

 {$else}

  {$ifdef FPC}  //bug in bfcntlh.inc
  {
const
   O_ACCMODE = $3;
   O_RDONLY = $0;
   O_WRONLY = $1;
   O_RDWR = $2;
   O_CREAT = $40;
   O_EXCL = $80;
   O_NOCTTY = $100;
   O_TRUNC = $200;
   O_APPEND = $400;
   O_NONBLOCK = $800;
   O_NDELAY = O_NONBLOCK;
   O_SYNC = $1000;
   O_FSYNC = O_SYNC;
   O_ASYNC = $2000;

   O_DIRECT = $4000;
   O_DIRECTORY = $10000;
   O_NOFOLLOW = $20000;

   O_DSYNC = O_SYNC;
   O_RSYNC = O_SYNC;

   O_LARGEFILE = $8000;
   }
  {$endif}
 {$endif}
const
 {$ifdef mswindows}
 eor: array[0..1] of char = (#$0d,#$0a);
 {$else}
 eor: array[0..0] of char = (#$0a);
 {$endif}

const
 kryptsignatur = $9617ae3c;
type
 tstream1 = class(tstream);
 tmemorystream1 = class(tmemorystream);

function readfiledatastring(const afilename: filenamety): string;
var
 stream1: tmsefilestream;
begin
 stream1:= tmsefilestream.create(afilename);
 try
  result:= stream1.readdatastring;
 finally
  stream1.free;
 end;
end;

procedure writefiledatastring(const afilename: filenamety; const adata: string);
var
 stream1: tmsefilestream;
begin
 stream1:= tmsefilestream.create(afilename,fm_create);
 try
  stream1.writedatastring(adata);
 finally
  stream1.free;
 end;
end;

procedure streamerror;
begin
 raise exception.Create('Streamerror!');
end;

 {$ifdef UNIX}
procedure setfilenonblock(handle: integer; value: boolean);
var
 int1: integer;
begin
 int1:= fcntl(handle,f_getfl,0);
 if int1 = -1 then streamerror;
 if value then begin
  int1:= int1 or o_nonblock;
 end
 else begin
  int1:= int1 and not o_nonblock;
 end;
 if fcntl(handle,f_setfl,int1) = -1 then streamerror;
end;
 {$else}
procedure setfilenonblock(handle: integer; value: boolean);
begin
 raise exception.Create('nonblock not supported');
end;
 {$endif}

function getnextbufferline(var data: pchar; len: integer): string;
     //data = nil -> fertig
var
 po1: pchar;
 int1: integer;
begin
 result:= '';
 po1:= data;
 int1:= len;
 po1:= strlscan(po1,c_linefeed,int1);
 if po1 <> nil then begin
  int1:= po1-data;
  dec(int1);
  if (po1+int1)^ = c_return then begin
   dec(int1);
  end;
  if int1 > 0 then begin
   setlength(result,int1);
   move(data^,result[1],int1)
  end;
  inc(po1);
 end;
 data:= po1;
end;

function getbufferline(const data: pchar; linenr,len: integer): string;
                  //1. zeile = 0
var
 po1: pchar;
 int1: integer;
begin
 result:= '';
 po1:= data;
 for int1:= 0 to linenr do begin
  result:= getnextbufferline(po1,len-(po1-data));
 end;
end;

function getkeystring(const data: pchar; len: integer; name: string): string;
                  //bringt nach '<name>=' folgenden text
var
 po1: pchar;
begin
 result:= '';
 po1:= data;
 name:= name+'=';
 while po1 <> nil do begin
  result:= getnextbufferline(po1,len-(po1-data));
  if pos(name,result) = 1 then begin
   result:= copy(result,length(name)+1,length(result));
   break;
  end;
 end;
end;

function encode(const value: msestring; 
                           const encoding: charencodingty = ce_utf8n): string;
begin
 case encoding  of
  ce_ascii: begin
   result:= stringtopascalstring(value);
  end;
  ce_utf8n: begin
   result:= stringtoutf8(value);
  end;
  ce_iso8859_1: begin
   result:= stringtolatin1(value);
  end;
  else begin //ce_locale
   result:= value;
  end;
 end;
end;

function decode(const value: string; 
                   const encoding: charencodingty = ce_utf8n): msestring;
begin
 case encoding  of
  ce_ascii: begin
   result:= pascalstringtostring(value);
  end;
  ce_utf8n: begin
   result:= utf8tostring(value);
  end;
  ce_iso8859_1: begin
   result:= latin1tostring(value);
  end;
  else begin //ce_ansi or current locale
   result:= value;
  end;
 end;
end;

function encoderecord(const fields: array of const;
               forcequote: boolean = false; const quotechar: msechar = '"';
               const separator: msechar = ','): msestring;
var
 int1: integer;
 mstr1: msestring;
 first: boolean;
 seps: msestring;
begin
 first:= true;
 seps:= msechar(c_return) + msestring(c_linefeed) + msestring(quotechar) + separator;
 result:= '';
 for int1:= 0 to high(fields) do begin
  mstr1:= '';
  with tvarrec(fields[int1]) do begin
   case vtype of
    vtInteger:    mstr1:= inttostr(VInteger);
    vtBoolean:    if VBoolean then mstr1:= 'T' else mstr1:= 'F';
    vtChar:       mstr1:= VChar;
    vtExtended:   if not isemptyreal(vextended^) then mstr1:= realtostr(VExtended^);
    vtString:     mstr1:= VString^;
    vtWideChar:   mstr1:= VWideChar;
    vtPChar:      mstr1:= string(VPChar);
    vtPWideChar:  mstr1:= msestring(VPWideChar);
    vtAnsiString: mstr1:= ansistring(VAnsiString);
    vtCurrency:   mstr1:= realtostr(VCurrency^);
    vtWideString: mstr1:= msestring(VWideString);
    vtInt64:      mstr1:= inttostr(VInt64^);
   end;
  end;
//  escapechars(mstr1);
  if (mstr1 <> '') and (quotechar <> #0) then begin
   if forcequote or (findchars(mstr1,seps) <> 0) then begin
    mstr1:= quotestring(mstr1,quotechar);
   end;
  end;
  if not first then begin
   result:= result + separator + mstr1;
  end
  else begin
   result:= result + mstr1;
  end;
  first:= false;
 end;
end;

procedure copyvariantarray(const source: array of const; const dest: array of pointer);
var
 int1,int2: integer;
begin
 int2:= high(source);
 if int2 > high(dest) then begin
  int2:= high(dest);
 end;
 for int1:= 0 to int2 do begin
  case source[int1].vtype of
   vtInteger:    pinteger(dest[int1])^:= source[int1].vinteger;
   vtBoolean:    pboolean(dest[int1])^:= source[int1].VBoolean;
   vtChar:       pchar(dest[int1])^:= source[int1].VChar;
   vtExtended:   preal(dest[int1])^:= source[int1].VExtended^;
   vtString:     pshortstring(dest[int1])^:= source[int1].VString^;
   vtWideChar:   pwidechar(dest[int1])^:= source[int1].VWideChar;
   vtPChar:      ppchar(dest[int1])^:= source[int1].VPChar;
   vtPWideChar:  ppwidechar(dest[int1])^:= source[int1].VPwideChar;
   vtAnsiString: pansistring(dest[int1])^:= ansistring(source[int1].VAnsiString);
   vtCurrency:   pcurrency(dest[int1])^:= source[int1].Vcurrency^;
   vtwidestring: pmsestring(dest[int1])^:= msestring(source[int1].VwideString);
   vtInt64:      pint64(dest[int1])^:= source[int1].Vint64^;
  end;
 end;
end;

function getrecordtypechars(const fields: array of const): string;
                // b -> boolean
                // i -> integer
                // I -> int64
                // s -> ansistring
                // S -> msestring
                // r -> real
var
 int1: integer;
 ch1: char;
begin
 setlength(result,length(fields));
 for int1:= 0 to high(fields) do begin
  ch1:= ' ';
  case fields[int1].VType of
   vtboolean: begin
    ch1:= 'b';
   end;
   vtinteger: begin
    ch1:= 'i';
   end;
   vtint64: begin
    ch1:= 'I';
   end;
   vtansistring: begin
    ch1:= 's';
   end;
   vtwidestring: begin
    ch1:= 'S';
   end;
   vtextended: begin
    ch1:= 'r';
   end;
  end;
  result[int1+1]:= ch1;
 end;
end;

function decoderecord(const value: msestring;
                   const fields: array of pointer; const types: string;
                // b -> boolean
                // i -> integer
                // I -> int64
                // s -> ansistring
                // S -> msestring
                // r -> real
               const quotechar: msechar = '"';
               const separator: msechar = ','): boolean;
var
 ar1: msestringarty;
 int1: integer;
begin
 result:= true;
 ar1:= nil;
 if quotechar <> #0 then begin
  splitstringquoted(value,ar1,quotechar,separator);
 end
 else begin
  splitstring(value,ar1,separator);
 end;
 for int1:= 0 to length(types) - 1 do begin
  if int1 > high(fields) then begin
   result:= false;
   break;
  end;
  if int1 > high(ar1) then begin
   break;
  end;
//  unescapechars(ar1[int1]);
  if fields[int1] <> nil then begin
   case types[int1+1] of
    ' ': begin
    end;
    'b': begin
     if ar1[int1] = 'T' then begin
      pboolean(fields[int1])^:= true;
     end
     else begin
      pboolean(fields[int1])^:= false;
     end;
    end;
    'i': begin
     try
      pinteger(fields[int1])^:= strtoint(ar1[int1]);
     except
      result:= false;
     end;
    end;
    'I': begin
     try
      pint64(fields[int1])^:= strtoint64(ar1[int1]);
     except
      result:= false;
     end;
    end;
    'r': begin
     if ar1[int1] = '' then begin
      preal(fields[int1])^:= emptyreal;
     end
     else begin
      try
       preal(fields[int1])^:= strtoreal(ar1[int1]);
      except
       result:= false;
      end;
     end;
    end;
    's': begin
     pstring(fields[int1])^:= ar1[int1];
    end;
    'S': begin
      pmsestring(fields[int1])^:= ar1[int1];
    end;
    else begin
     result:= false;
    end;
   end;
  end;
 end;
end;

{ tmsefilestream }

constructor tmsefilestream.create(ahandle: integer); //allways called
begin
 inherited;
end;

constructor tmsefilestream.Create;
begin
 if fmemorystream = nil then begin
  fmemorystream:= tmemorystream.create;
 end;
 create(invalidfilehandle);
end;

constructor tmsefilestream.create(const afilename: filenamety;
            openmode: fileopenmodety = fm_read;
            accessmode: fileaccessmodesty = [];
            Rights: filerightsty = defaultfilerights);   //!!!!todo linux lock
var
 ahandle: integer;
 error: syserrorty;
 mstr1: msestring;
begin
 ffilename:= filepath(afilename);
 if openmode = fm_append then begin
  error:= sys_openfile(ffilename,fm_readwrite,accessmode,rights,ahandle);
  if error <> sye_ok then begin
   error:= sys_openfile(ffilename,fm_create,accessmode,rights,ahandle);
  end;
 end
 else begin
  error:= sys_openfile(ffilename,openmode,accessmode,rights,ahandle);
 end;
 create(ahandle);
 if error = sye_ok then begin
  if openmode = fm_append then begin
   position:= size;
  end;
 end
 else begin
  mstr1:= ffilename;
  ffilename:= '';
  if openmode in [fm_create,fm_append] then begin
{$ifdef FPC}
   raise EFCreateError.CreateFmt(SFCreateError,[mstr1,
        sys_geterrortext(mselasterror)]);
{$else}

 {$if rtlversion > 14.1}
   raise EFCreateError.CreateResFmt(@SFCreateErrorEx,
       [mstr1, sys_geterrortext(mselasterror)]);
 {$else}
   raise EFCreateError.CreateResFmt(@SFCreateError,
       [mstr1, sys_geterrortext(mselasterror)]);
 {$ifend}
{$endif}
  end
  else begin
{$ifdef FPC}
   raise EFCreateError.CreateFmt(SFopenError,[filepath(filename),sys_geterrortext(sys_getlasterror)]);
{$else}
  {$if rtlversion > 14.1}
   raise EFOpenError.CreateResFmt(@SFOpenErrorEx,
      [mstr1,sys_geterrortext(mselasterror)]);
  {$else}
   raise EFOpenError.CreateResFmt(@SFOpenError,
      [mstr1,sys_geterrortext(mselasterror)]);
  {$ifend}
{$endif}
  end;
 end;
end;

constructor tmsefilestream.createtransaction(const afilename: filenamety;
            rights: filerightsty = defaultfilerights);
begin
 if afilename = '' then begin
  raise exception.create('No transaction name.');
 end;
 ftransactionname:= afilename;
 create(intermediatefilename(afilename),fm_create,[fa_denywrite],rights);
end;

destructor tmsefilestream.Destroy;
begin
 close;
 inherited Destroy;
 fmemorystream.Free;
end;

procedure tmsefilestream.closehandle(const ahandle: integer);
begin
 sys_closefile(ahandle);
end;
 
procedure tmsefilestream.sethandle(value: integer);
begin
 if handle <> invalidfilehandle then begin
  closehandle(handle);
 end;
 {$ifdef FPC}
 thandlestreamcracker(self).fhandle:= value;
 {$else}
 fhandle:= value;
 {$endif}
end;

function tmsefilestream.close: boolean;  //false on commit error
begin
 result:= true;
 if (handle <> invalidfilehandle) and (ftransactionname <> '') and
          (ffilename <> '') then begin
  flush;
  sethandle(invalidfilehandle);
  result:= sys_renamefile(ffilename,ftransactionname) = sye_ok;
 end
 else begin
  sethandle(invalidfilehandle);
 end;
 ffilename:= '';
 ftransactionname:= '';
end;

procedure tmsefilestream.cancel;
var
 fstr1: filenamety;
begin
 if (ftransactionname <> '') and (ffilename <> '') then begin
  fstr1:= ffilename;
  ftransactionname:= '';
  close;
  sys_deletefile(fstr1);
 end
 else begin
  close;
 end;
end;

procedure tmsefilestream.flush;
begin
 if handle <> invalidfilehandle then begin
  syserror(sys_flushfile(handle));
 end;
end;

function tmsefilestream.isopen: boolean;
begin
 result:= handle <> invalidfilehandle;
end;

function tmsefilestream.Read(var Buffer; Count: Integer): Longint;
begin
 if fmemorystream <> nil then begin
  result:= fmemorystream.Read(buffer,count);
 end
 else begin
  result:= sys_read({$ifdef FPC}thandlestreamcracker(self).{$endif}fhandle,
                                      @buffer,count);
  if result = - 1 then begin
   result:= 0;
  end;
 end;
end;

function tmsefilestream.Seek(const Offset: Int64;
  Origin: TSeekOrigin): Int64;
begin
 if fmemorystream <> nil then begin
  result:= fmemorystream.Seek(offset,origin);
 end
 else begin
  result:= inherited seek(offset,origin);
 end;
end;

function tmsefilestream.Write(const Buffer; Count: Integer): Longint;
begin
 if fmemorystream <> nil then begin
  result:= fmemorystream.Write(Buffer,count);
 end
 else begin
  result:= sys_write({$ifdef FPC}thandlestreamcracker(self).{$endif}fhandle,
                             @buffer,count);
  if result = -1 then begin
   result:= 0;
  end;
 end;
end;

function tmsefilestream.readdatastring: string;
begin
 setlength(result,size-position);
 setlength(result,read(result[1],length(result)));
end;

procedure tmsefilestream.writedatastring(const value: string);
begin
 writebuffer(value[1],length(value));
end;

procedure tmsefilestream.SetSize(const NewSize: Int64);
begin
 if fmemorystream <> nil then begin
  fmemorystream.SetSize(newsize);
 end
 else begin
  inherited;
 end;
end;

function tmsefilestream.getmemory: pointer;
begin
 result:= fmemorystream.memory;
end;

procedure tmsefilestream.checkmemorystream;
begin
 if fmemorystream = nil then begin
  raise exception.create('Must be memory stream.');
 end;
end;

procedure tmsefilestream.clear;
begin
 checkmemorystream;
 fmemorystream.clear; 
end;

{ tresourcefilestream}

procedure TresourcefileStream.WriteResourceHeader(resourcetyp: word;
            const ResName: string; out FixupInfo: Integer);
var
  HeaderSize: Integer;
  Header: array[0..79] of Char;
begin
  Byte((@Header[0])^) := $FF;
  Word((@Header[1])^) := resourcetyp;
  HeaderSize := StrLen(StrUpper(StrPLCopy(@Header[3], ResName, 63))) + 10;
  Word((@Header[HeaderSize - 6])^) := $1030;
  Longint((@Header[HeaderSize - 4])^) := 0;
  WriteBuffer(Header, HeaderSize);
  FixupInfo := Position;
end;

{ ttextstream }

constructor ttextstream.Create(AHandle: integer);
begin
// bufoffset:= nil;
 buflen:= defaultbuflen;
 inherited;
end;

constructor ttextstream.createdata(const adata: string);
begin
 create;
 writedatastring(adata);
 position:= 0;
end;

function ttextstream.Read(var Buffer; Count: Integer): Longint;
begin
 bufoffset:= nil;
 result:= inherited read(buffer,count);
end;

function ttextstream.Write(const Buffer; Count: Integer): Longint;
begin
 bufoffset:= nil;
 result:= inherited write(buffer,count);
end;

function ttextstream.Seek(const Offset: Int64;
  Origin: TSeekOrigin): Int64;
begin
 if (origin <> socurrent) or (offset <> 0) then bufoffset:= nil;
 if bufoffset = nil then begin
  result:= inherited seek(offset,origin);
 end
 else begin
  result:= inherited seek(offset,origin) + (bufoffset-bufend);
 end;
 exclude(fstate,tss_eof);
end;

procedure ttextstream.setbuflen(const Value: integer);
var
 int1: integer;
begin
 if fbuflen <> value then begin
  if value < defaultbuflen then begin
   int1:= defaultbuflen;
  end
  else begin
   int1:= value;
  end;
  fbuflen:= int1;
  setlength(finternalbuffer,fbuflen);
  fbuffer:= pointer(finternalbuffer);
  bufoffset:= nil;
 end;
end;

function ttextstream.readbytes(var buf): integer;
begin
 result:= read(buf,fbuflen);
end;

function ttextstream.readstrln(out value: string): boolean;
     //true wenn zeile vollstaendig

 procedure fillbuffer;
 begin
  bufend:= fbuffer + readbytes(fbuffer^);
  bufoffset:= fbuffer;
 end;

var
 int1,int2,int3: integer;
 gefunden: boolean;
 po1,po2: pchar;

begin
 if (tss_eof in fstate) then begin
  raise EInOutError.Create(sendoffile);
 end;
 gefunden:= false;
 if @value <> nil then begin
  setlength(value,0);
 end;
 if bufoffset = nil then begin  //buffer ungueltig
  fillbuffer;
 end;
 fposvorher:= position + (bufend - bufoffset);
 repeat
  po1:= nil;
  po2:= bufoffset;
  for int1:= 0 to bufend-bufoffset-1 do begin
   if (po2^ = c_return) or (po2^ = c_linefeed) then begin
    po1:= po2;
    break;
   end;
   inc(po2);
  end;
  if po1 <> nil then begin
   gefunden:= true;
  end
  else begin
   po1:= bufend;
  end;
  if @value <> nil then begin
   int2:= po1-bufoffset;
   if int2 > 0 then begin
    int3:= length(value);
    setlength(value,int3+int2);
    move(bufoffset^,value[int3+1],int2);     //anhaengen
   end;
  end;
  if po1 = bufend then begin    //noch nicht gefunden
   fillbuffer;
  end;
 until gefunden or (bufoffset = bufend);

 if gefunden then begin
  bufoffset:= po1;
 end
 else begin
  bufoffset:= bufend;
 end;

 if bufoffset < bufend then begin
  inc(bufoffset);
  if (bufoffset-1)^ = c_return then begin      //return-linefeed entfernen
   if bufoffset = bufend then begin
    fillbuffer;
   end;
   if bufoffset < bufend then begin
    if bufoffset^ = c_linefeed then begin
     inc(bufoffset);
     if bufoffset = bufend then begin
      fillbuffer;
     end;
    end;
   end;
  end
  else begin
  {
   if bufoffset = bufend then begin          //linefeed-return entfernen
    fillbuffer;
   end;
   if bufoffset < bufend then begin
    if bufoffset^ = c_return then begin
     inc(bufoffset);
     if bufoffset = bufend then begin
      fillbuffer;
     end;
    end;
   end;
  }
  end;
 end;

 result:= gefunden;
 updatebit({$ifdef FPC}longword{$else}byte{$endif}(fstate),ord(tss_eof),not result);
end;

procedure ttextstream.return;
begin
 position:= fposvorher;
end;

procedure ttextstream.writestr(const value: string);
begin
 writebuffer(value[1],length(value));
end;

function ttextstream.encode(const value: msestring): string;
begin
 result:= msestream.encode(value,fencoding);
end;

function ttextstream.decode(const value: string): msestring;
begin
 result:= msestream.decode(value,fencoding);
{
 case fencoding  of
  ce_ascii: begin
   result:= pascalstringtostring(value);
  end;
  ce_utf8n: begin
   result:= utf8tostring(value);
  end
  else begin //ce_ansi
   result:= value;
  end;
 end;
}
end;

procedure ttextstream.write(const value: string);
begin
 writestr(encode(value));
end;

procedure ttextstream.write(const value: msestring);
begin
 writestr(encode(value));
end;

procedure ttextstream.writestrln(const value: string);
begin
 write(value+eor);
// writebuffer(eor,sizeof(eor));
end;

procedure ttextstream.writeln(const value: string);
begin
 write(value+eor);
// writebuffer(eor,sizeof(eor));
end;

procedure ttextstream.writeln(const value: msestring);
begin
 write(value+lineend);
// writebuffer(eor,sizeof(eor));
end;

procedure ttextstream.writeln(const value: real);
begin
 writestrln(realtostr(value));
end;

procedure ttextstream.writeln(const value: integer);
begin
 writestrln(inttostr(value));
end;

procedure ttextstream.writeln(const value: msestringarty);
var
 int1: integer;
begin
 writeln(length(value));
 for int1:= 0 to high(value) do begin
  writeln(value[int1]);
 end;
end;

procedure ttextstream.writeln(const value: stringarty);
var
 int1: integer;
begin
 writeln(length(value));
 for int1:= 0 to high(value) do begin
  writeln(string(value[int1]));
 end;
end;

function ttextstream.readln: boolean;
var
 str1: string;
begin
 result:= readstrln(str1);
end;

function ttextstream.readln(out value: string): boolean;
begin
 result:= readstrln(value);
 value:= decode(value);
end;

function ttextstream.readln(out value: msestring): boolean;
var
 str1: string;
begin
 result:= readstrln(str1);
 value:= decode(str1);
end;

function ttextstream.readln(out value: integer): boolean;
var
 str1: string;
begin
 result:= readstrln(str1);
 value:= strtoint(str1);
end;

function ttextstream.readln(out value: real): boolean;
var
 str1: string;
begin
 result:= readstrln(str1);
 value:= strtoreal(str1);
end;

function ttextstream.readln(out value: msestringarty): boolean;
var
 str1: string;
 int1: integer;
begin
 result:= readstrln(str1);
 if result then begin
  int1:= strtoint(str1);
 end
 else begin
  int1:= 0;
 end;
 setlength(value,int1);
 for int1:= 0 to int1-1 do begin
  if not result then begin
   exit;
  end;
  result:= readln(str1);
  value[int1]:= str1;
 end;
end;

function ttextstream.readln(out value: stringarty): boolean;
var
 str1: string;
 int1: integer;
begin
 result:= readstrln(str1);
 if result then begin
  int1:= strtoint(str1);
 end
 else begin
  int1:= 0;
 end;
 setlength(value,int1);
 for int1:= 0 to int1-1 do begin
  if not result then begin
   exit;
  end;
  result:= readln(str1);
  value[int1]:= str1;
 end;
end;

function ttextstream.readinteger(default: integer; min: integer = minint;
                            max: integer = maxint): integer;
  //liest integer, bringt defaultwert bei fehler
begin
 try
  readln(result);
  if (result < min) then begin
   result:= min;
  end
  else begin
   if result > max then begin
    result:= max;
   end;
  end;
 except
  result:= default;
 end;
end;

function ttextstream.readreal(default: real; min: real = -bigreal;
                            max: real = bigreal): real;
begin
 try
  readln(result);
  if (result < min) then begin
   result:= min;
  end
  else begin
   if result > max then begin
    result:= max;
   end;
  end;
 except
  result:= default;
 end;
end;

function ttextstream.readstring(const default: string): string;
begin
 try
  readln(result);
 except
  result:= default;
 end;
end;

function ttextstream.findnext(const substring: string): boolean;
var
 buffer: string;
 int1,len,posstart,posvorher: integer;
begin
 len:= length(substring);
 result:= false;
 posstart:= position;
 if len > 0 then begin
  setlength(buffer,len);
  while true do begin
   posvorher:= position;
   int1:= read(buffer[1],len);
   if int1 < len then begin
   position:= posstart;
     break;
   end;
   if buffer = substring then begin
    position:= posvorher;
    result:= true;
    break;
   end;
   int1:= pos(substring[1],buffer);
   if int1 > 0 then begin
    position:= posvorher + int1;
   end;
  end;
 end;
end;

function ttextstream.linecount: integer;
var
 po1: ^string;
begin
 result:= 0;
 po1:= nil;
 while readln(string(po1^)) do begin
  inc(result);
 end;
end;

procedure ttextstream.resetsearch;
begin
 fsearchlinestartpos:= 0;
 fsearchlinenumber:= 0;
 fsearchpos:= 0;
 fsearchfoundpos:= 0;
end;

procedure ttextstream.setsearchtext(const Value: string);
begin
 fsearchtext := Value;
 fsearchtextvalid:= false;
end;

function ttextstream.getmsesearchtext: msestring;
begin
 result:= decode(fsearchtext);
end;

procedure ttextstream.setmsesearchtext(const avalue: msestring);
begin
 setsearchtext(encode(avalue));
end;

procedure ttextstream.setsearchoptions(const Value: searchoptionsty);
begin
 fsearchoptions := Value;
 fsearchtextvalid:= false;
end;

function ttextstream.searchnext: boolean;
var
 bo1: boolean;
 ca1: cardinal;
 str1: string;
begin
 Position:= fsearchpos;
 bo1:= true;
 if (so_caseinsensitive in fsearchoptions) and not fsearchtextvalid then begin
  fsearchtextupper:= ansiuppercase(fsearchtext);
  fsearchtextlower:= ansilowercase(fsearchtext);
  fsearchtextvalid:= true;
 end;
 repeat
  if not bo1 then begin
   fsearchlinestartpos:= position;
   fsearchpos:= fsearchlinestartpos;
   inc(fsearchlinenumber);
  end
  else begin
   bo1:= false;
  end;
//  readln(str1);
  readstrln(str1); //no encoding
  if so_caseinsensitive in fsearchoptions then begin
   ca1:= stringsearch(fsearchtextupper,str1,1,fsearchoptions,fsearchtextlower);
  end
  else begin
   ca1:= stringsearch(fsearchtext,str1,1,fsearchoptions,'');
  end;
 until (ca1 <> 0) or eof or ((fsearchabortpo <> nil) and fsearchabortpo^);
 if ca1 <> 0 then begin
  fsearchfoundpos:= fsearchpos + ca1 - 1;
  result:= true;
 end
 else begin
  result:= false;
  fsearchfoundpos:= Position;
 end;
 fsearchpos:= fsearchfoundpos + cardinal(length(fsearchtext));
end;

function ttextstream.geteof: boolean;
begin
 result:= fstate * [tss_eof,tss_notopen,tss_error] <> [];
end;

function ttextstream.getnotopen: boolean;
begin
 result:= tss_notopen in fstate;
end;

function ttextstream.readstrings: stringarty;
var
 int1: integer;
 str1: string;
begin
 int1:= 0;
 result:= nil;
 while not eof do begin
  if not readln(str1) and (str1 = '') then begin
   break;
  end;
  additem(result,str1,int1);
 end;
 setlength(result,int1);
end;

function ttextstream.readmsestrings: msestringarty;
var
 int1: integer;
 mstr1: msestring;
begin
 int1:= 0;
 result:= nil;
 while not eof do begin
  if not readln(mstr1) and (mstr1 = '') then begin
   break;
  end;
  additem(result,mstr1,int1);
 end;
 setlength(result,int1);
end;

procedure ttextstream.writestrings(const value: stringarty);
var
 int1: integer;
begin
 for int1:= 0 to high(value) do begin
  writeln(string(value[int1]));
 end;
end;

procedure ttextstream.writemsestrings(const value: msestringarty);
var
 int1: integer;
begin
 for int1:= 0 to high(value) do begin
  writeln(value[int1]);
 end;
end;

procedure ttextstream.writetotext(var dest: text);
var
 str1: string;
begin
 while not eof do begin
  readstrln(str1);
  system.writeln(dest,str1);
 end;
end;

{ ttextdatastream }

constructor ttextdatastream.create(ahandle: integer);
begin
 fseparator:= ',';
 fquotechar:= '"';
 inherited;
end;

procedure ttextdatastream.writerecord(const fields: array of const);
begin
 writeln(encoderecord(fields,fforcequote,fquotechar,fseparator));
end;

procedure ttextdatastream.writerecord(const fields: msestringarty);
var
 ar1: varrecarty;
 int1: integer;
begin
 setlength(ar1,length(fields));
 for int1:= 0 to high(ar1) do begin
  with ar1[int1] do begin
   vtype:= vtwidestring;
   vwidestring:= pointer(fields[int1]);
  end;
 end;
 writerecord(ar1);
end;

procedure ttextdatastream.writerecord(const fields: stringarty);
var
 ar1: varrecarty;
 int1: integer;
begin
 setlength(ar1,length(fields));
 for int1:= 0 to high(ar1) do begin
  with ar1[int1] do begin
   vtype:= vtansistring;
   vansistring:= pointer(fields[int1]);
  end;
 end;
 writerecord(ar1);
end;

procedure ttextdatastream.writerecord(const fields: integerarty);
var
 ar1: varrecarty;
 int1: integer;
begin
 setlength(ar1,length(fields));
 for int1:= 0 to high(ar1) do begin
  with ar1[int1] do begin
   vtype:= vtinteger;
   vinteger:= fields[int1];
  end;
 end;
 writerecord(ar1);
end;

procedure ttextdatastream.writerecord(const fields: realarty);
var
 ar1: varrecarty;
 ar2: array of extended;
 int1: integer;
 ext1: extended;
begin
 setlength(ar1,length(fields));
 setlength(ar2,length(fields));
 for int1:= 0 to high(ar1) do begin
  with ar1[int1] do begin
   ar2[int1]:= fields[int1];
   vtype:= vtextended;
   vextended:= @ar2[int1];
  end;
 end;
 writerecord(ar1);
end;

procedure ttextdatastream.writerecord(const fields: int64arty);
var
 ar1: varrecarty;
 int1: integer;
begin
 setlength(ar1,length(fields));
 for int1:= 0 to high(ar1) do begin
  with ar1[int1] do begin
   vtype:= vtint64;
   vint64:= @fields[int1];
  end;
 end;
 writerecord(ar1);
end;

procedure ttextdatastream.writerecord(const fields: booleanarty);
var
 ar1: varrecarty;
 int1: integer;
begin
 setlength(ar1,length(fields));
 for int1:= 0 to high(ar1) do begin
  with ar1[int1] do begin
   vtype:= vtboolean;
   vboolean:= fields[int1];
  end;
 end;
 writerecord(ar1);
end;

function ttextdatastream.readrecord(fields: array of pointer; types: string): boolean;
                // b -> boolean
                // i -> integer
                // I -> int64
                // s -> ansistring
                // S -> msestring
                // r -> real
var
 mstr1,mstr2: msestring;
begin
 readln(mstr1);
 if odd(countchars(mstr1,fquotechar)) then begin
  while not eof do begin
   readln(mstr2);
   mstr1:= mstr1+lineend+mstr2;
   if odd(countchars(mstr2,fquotechar)) then begin
    break;
   end;
  end;
 end;
 result:= decoderecord(mstr1,fields,types,fquotechar,fseparator);
end;

{ tcryptfilestream }

constructor tcryptfilestream.Create(const aFileName: string; Mode: Word);
const
 schluessel = $51b2;
var
 wo1: word;
 int1: integer;
begin
 inherited;
 if mode = fmcreate then begin
  int1:= integer(kryptsignatur);
  writebuffer(int1,4);
  randomize;
  repeat
   wo1:= random($ffff);
  until wo1 <> 0;
  seed:= wo1;
  wo1:= wo1 xor schluessel;
  writebuffer(wo1,2);
 end
 else begin
  readbuffer(int1,4);
  if int1 <> integer(kryptsignatur) then begin
   raise exception.create(afilename + ' falsches Dateiformat!');
  end;
  readbuffer(seed,2);
  seed:= seed xor schluessel;
 end;
 schluesseln:= true;
end;

function tcryptfilestream.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
begin
 result:= 0; //compiler warning
 raise exception.create('seek nicht erlaubt!');
end;

procedure tcryptfilestream.krypt16(var buffer; count: integer);
const
 crcpolynom = $a001;
var
 int1,int2: integer;
 bo1: boolean;
 bytepo: ^byte;
begin
 bytepo:= @buffer;
 for int2:= count-1 downto 0 do begin
  for int1:= 0 to 7 do begin
   bo1:= odd(seed);
   seed:= seed shr 1;
   if bo1 then begin
    seed:= seed xor crcpolynom;
   end;
  end;
  bytepo^:= bytepo^ xor seed;
  inc(bytepo);
 end;
end;

function tcryptfilestream.Read(var Buffer; Count: Integer): Longint;
begin
 result:= inherited read(buffer,count);
 if schluesseln then begin
  krypt16(buffer,result);
 end;
end;

function tcryptfilestream.Write(const Buffer; Count: Integer): Longint;
var
 po: pointer;
begin
 if schluesseln then begin
  po:= @byte(buffer);
  krypt16(po^,count);
 end;
 result:= inherited write(buffer,count);
end;

{ tstringcopystream }

constructor tstringcopystream.create(const adata: string);
begin
 fdata:= adata;
 inherited create;
 if adata <> '' then begin
  setpointer(pointer(adata),length(adata));
 end;
end;

destructor tstringcopystream.destroy;
begin
 setpointer(nil,0);
 inherited;
end;

function tstringcopystream.write(const Buffer; Count: Longint): Longint;
begin
 result:= 0;
end;

{ tmemorycopystream }

constructor tmemorycopystream.create(const adata: pointer; const asize: integer);
begin
 inherited create;
 setpointer(adata,asize);
end;

destructor tmemorycopystream.destroy;
begin
 setpointer(nil,0);
 inherited;
end;

function tmemorycopystream.write(const Buffer; Count: Longint): Longint;
begin
 result:= 0;
end;

end.

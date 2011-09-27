{ MSEgui Copyright (c) 1999-2011 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit msesys;

{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface
uses
 {$ifdef mswindows}windows,{$endif}mseerr,msetypes,msestrings,msesystypes
  {$ifdef FPC},dynlibs{$endif};

type
 internalthreadprocty = function(): integer of object;

 procitemty = record
  pid,ppid: procidty;
  children: procidarty;
 end;
 procitemarty = array of procitemty;

 threadinfoty = record
  id: threadty;
  threadproc: internalthreadprocty;
  stacksize: ptruint;
  platformdata: array[0..3] of pointer;
 end;
 
 socketkindty = (sok_local,sok_inet,sok_inet6);
 socketshutdownkindty = (ssk_rx,ssk_tx,ssk_both);
 pollkindty = (poka_read,poka_write,poka_except);
 pollkindsty = set of pollkindty;

 
 socketaddrty = record
  kind: socketkindty;
  url: filenamety;
  port: integer;
  size: integer;
  platformdata: array[0..32] of longword;
 end;

type
 fileopenmodety = (fm_read,fm_write,fm_readwrite,fm_create,fm_append);
 fileaccessmodety = (fa_denywrite,fa_denyread);
 fileaccessmodesty = set of fileaccessmodety;
 filerightty = (s_irusr,s_iwusr,s_ixusr,
                s_irgrp,s_iwgrp,s_ixgrp,
                s_iroth,s_iwoth,s_ixoth,
                s_isuid,s_isgid,s_isvtx);
 filerightsty = set of filerightty;
 filetypety = (ft_unknown,ft_dir,ft_blk,ft_chr,ft_reg,ft_lnk,ft_sock,ft_fifo);
 fileattributety = (fa_rusr,fa_wusr,fa_xusr,
                    fa_rgrp,fa_wgrp,fa_xgrp,
                    fa_roth,fa_woth,fa_xoth,
                    fa_suid,fa_sgid,fa_svtx,
                    fa_dir,
                    fa_archive,fa_compressed,fa_encrypted,fa_hidden,
                    fa_offline,fa_reparsepoint,fa_sparsefile,fa_system,
                    fa_temporary,
                    fa_all);

 fileattributesty = set of fileattributety;
  
type
 ext1fileinfoty = record
  filetype: filetypety;
  attributes: fileattributesty;
  size: int64;
  modtime: tdatetime;
  accesstime: tdatetime;
  ctime: tdatetime;
 end;

 ext2fileinfoty = record
  id: int64;
  owner: longword;
  group: longword;
 end;

 fileinfostatety = (fis_typevalid,fis_extinfo1valid,fis_extinfo2valid,
                    fis_diropen,fis_hasentry);
 fileinfostatesty = set of fileinfostatety;

 fileinfoty = record
  name: filenamety;
  state: fileinfostatesty;
  extinfo1: ext1fileinfoty;
  extinfo2: ext2fileinfoty;
 end;
 pfileinfoty = ^fileinfoty;

 fileinfolevelty = (fil_name,fil_type, //fa_dir and fa_hidden
                    fil_ext1,fil_ext2);
 dirstreamoptionty = (dso_casesensitive,dso_caseinsensitive);
                             //platform default if empty,
                             // same layout as filelistviewoptionty
 dirstreamoptionsty = set of dirstreamoptionty;

 dirstreaminfoty = record
  dirname: filenamety;
  mask: filenamearty;
  include,exclude: fileattributesty;
  infolevel: fileinfolevelty;
  options: dirstreamoptionsty;
  caseinsensitive: boolean;
 end;

 dirstreampty = array[0..7] of longword;
 dirstreamty = record
//  checkcallback: dirstreamcheckeventty;
  dirinfo: dirstreaminfoty;
  platformdata: dirstreampty;
 end;

 esys = class(eerror)
  private
    function geterror: syserrorty;
  public
   constructor create(aerror: syserrorty; atext: string);
   property error: syserrorty read geterror;
 end;

type
  TMonthNameArraymse = array[1..12] of msestring;
  TWeekNameArraymse = array[1..7] of msestring;

  TFormatSettingsmse = record
    CurrencyFormat: Byte;
    NegCurrFormat: Byte;
    ThousandSeparator: mseChar;
    DecimalSeparator: mseChar;
    CurrencyDecimals: Byte;
    DateSeparator: mseChar;
    TimeSeparator: mseChar;
    ListSeparator: mseChar;
    CurrencyString: msestring;
    ShortDateFormat: msestring;
    LongDateFormat: msestring;
    TimeAMString: msestring;
    TimePMString: msestring;
    ShortTimeFormat: msestring;
    LongTimeFormat: msestring;
    ShortMonthNames: TMonthNameArraymse;
    LongMonthNames: TMonthNameArraymse;
    ShortDayNames: TWeekNameArraymse;
    LongDayNames: TWeekNameArraymse;
    TwoDigitYearCenturyWindow: Word;
  end;

var
 defaultprintcommand: string;
 
 DefaultFormatSettingsmse : TFormatSettingsmse = (
   CurrencyFormat: 1;
   NegCurrFormat: 5;
   ThousandSeparator: ',';
   DecimalSeparator: '.';
   CurrencyDecimals: 2;
   DateSeparator: '-';
   TimeSeparator: ':';
   ListSeparator: ',';
   CurrencyString: '$';
   ShortDateFormat: 'd/m/y';
   LongDateFormat: 'dd" "mmmm" "yyyy';
   TimeAMString: 'AM';
   TimePMString: 'PM';
   ShortTimeFormat: 'hh:nn';
   LongTimeFormat: 'hh:nn:ss';
   ShortMonthNames: ('Jan','Feb','Mar','Apr','May','Jun', 
                     'Jul','Aug','Sep','Oct','Nov','Dec');
   LongMonthNames: ('January','February','March','April','May','June',
                    'July','August','September','October','November','December');
   ShortDayNames: ('Sun','Mon','Tue','Wed','Thu','Fri','Sat');
   LongDayNames:  ('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday');
   TwoDigitYearCenturyWindow: 50;
 );

procedure checkdirstreamdata(var adata: dirstreamty);
 
procedure syserror(const error: syserrorty; const text: string = ''); overload;
procedure syserror(const error: syserrorty;
                  const sender: tobject; text: string = ''); overload;

function syelasterror: syserrorty; //returns sye_lasterror, sets mselasterror
function syeseterror(aerror: integer): syserrorty;
          //if aerror <> 0 -> returns sye_lasterror, sets mselasterror,
          //                  returns sye_ok otherwise
function syesetextendederror(const aerrormessage: msestring): syserrorty;
function getcommandlinearguments: stringarty;
                 //refcount of result = 1
function getcommandlineargument(const index: integer): string;
procedure deletecommandlineargument(const index: integer);
                //index 1..argumentcount-1, no action otherwise

function nowutc: tdatetime;


{$ifdef FPC}
function getexceptiontext(obj: tobject; addr: pointer; framecount: longint;
                                     frames: ppointer): msestring;
{$endif}
{$ifndef FPC}
 {$ifdef MSWINDOWS}
function InterlockedIncrement(var I: Integer): Integer;
function InterlockedDecrement(var I: Integer): Integer;
function InterlockedExchange(var A: Integer; B: Integer): Integer;
function InterlockedExchangeAdd(var A: Integer; B: Integer): Integer;
 {$endif}
{$endif}
threadvar
 mselasterror: integer;
 mselasterrormessage: msestring;

procedure saveformatsettings;
procedure initdefaultformatsettings;
             //initialization order is wrong, FPC bug?
implementation
uses
 Classes,{msestreaming,}msesysintf1,msesysintf,msearrayutils,sysutils,
 mseglob,msesysutils;
{$ifdef FPC}
 {$ifdef MSWINDOWS}
Procedure CatchUnhandledException (Obj : TObject; Addr: Pointer;
 FrameCount: Longint; Frames: PPointer);external name 'FPC_BREAK_UNHANDLED_EXCEPTION';
 //[public,alias:'FPC_BREAK_UNHANDLED_EXCEPTION'];
 {$endif}
{$endif}

function nowutc: tdatetime;
begin
 result:= sys_getutctime;
end;

procedure checkdirstreamdata(var adata: dirstreamty);
var
 int1: integer;
begin
 with adata.dirinfo do begin
  caseinsensitive:= sys_filesystemiscaseinsensitive;
  if dso_caseinsensitive in options then begin
   caseinsensitive:= true;
  end;
  if dso_casesensitive in options then begin
   caseinsensitive:= false;
  end;
  if caseinsensitive then begin
   setlength(mask,length(mask)); //unique
   for int1:= 0 to high(mask) do begin
    mask[int1]:= mseuppercase(mask[int1]);
   end;
  end;
 end;
end;

{$ifndef FPC}
 {$ifdef MSWINDOWS}
function InterlockedIncrement(var I: Integer): Integer;
begin
 result:= windows.interlockedincrement(i);
end;

function InterlockedDecrement(var I: Integer): Integer;
begin
 result:= windows.interlockeddecrement(i);
end;

function InterlockedExchange(var A: Integer; B: Integer): Integer;
begin
 result:= windows.interlockedexchange(a,b);
end;

function InterlockedExchangeAdd(var A: Integer; B: Integer): Integer;
begin
 result:= windows.interlockedexchangeadd(a,b);
end;
 {$endif}
{$endif}

const
 errortexts: array[syserrorty] of string =
  ('','','','Busy','Dirstream','Network error',
     'Thread error',
    'Mutex error',
    'Semaphore error',
    'Condition error',
    'Time out',
    'Copy file error',
    'Can not create directory',
    'No console',
    'Not implemented',
    'Socket address error',
    'Socket error',
    'File is directory.'
   );

var
 commandlineargs: stringarty;

procedure initcommandlineargs;
begin
 if commandlineargs = nil then begin
  commandlineargs:= sys_getcommandlinearguments;
 end;
end;

function getcommandlineargument(const index: integer): string;
begin
 initcommandlineargs;
 if index > high(commandlineargs) then begin
  result:= '';
 end
 else begin
  result:= commandlineargs[index];
 end;
end;

function getcommandlinearguments: stringarty;
begin
 initcommandlineargs;
 result:= copy(commandlineargs);
end;

procedure deletecommandlineargument(const index: integer);
begin
 initcommandlineargs;
 if (index > 0) and (index <= high(commandlineargs)) then begin
  deleteitem(commandlineargs,index);
 end;
end;

function syeseterror(aerror: integer): syserrorty;
          //if aerror <> 0 -> returns sye_lasterror, sets mselasterror,
          //                  returns sye_ok othrewise
begin
 if aerror <> 0 then begin
  result:= sye_lasterror;
  mselasterror:= aerror;
 end
 else begin
  result:= sye_ok;
 end;
end;

function syesetextendederror(const aerrormessage: msestring): syserrorty;
begin
 mselasterrormessage:= aerrormessage;
 result:= sye_extendederror;
end;

function syelasterror: syserrorty; //returns sye_lasterror, sets mselasterror
begin
 result:= sye_lasterror;
 mselasterror:= sys_getlasterror;
end;

procedure syserror(const error: syserrorty; const text: string); overload;
begin
 if error = sye_ok then begin
  exit;
 end;
 if error = sye_lasterror then begin
  raise esys.create(error,text + sys_geterrortext(mselasterror));
 end
 else begin
  if error = sye_extendederror then begin
   raise esys.create(error,text + mselasterrormessage);
  end
  else begin
   raise esys.create(error,text);
  end;
 end;
end;

procedure syserror(const error: syserrorty; const sender: tobject;
                       text: string = ''); overload;
begin
 if error = sye_ok then begin
  exit;
 end;
 if sender <> nil then begin
  text:= sender.classname + ' ' + text;
  if sender is tcomponent then begin
   text:= text + fullcomponentname(tcomponent(sender));
  end;
 end;
 syserror(error,text);
end;

{ esys }

constructor esys.create(aerror: syserrorty;  atext: string);
begin
 inherited create(integer(aerror),atext,errortexts);
end;

function esys.geterror: syserrorty;
begin
 result:= syserrorty(ferror);
end;

var
 defaultformatset: boolean = false;
 
procedure initdefaultformatsettings;
var
 int1: integer;
begin
 if not defaultformatset then begin
  defaultformatset:= true;
  defaultformatsettingsmse.CurrencyFormat:= 
     {$ifdef FPC}defaultformatsettings.{$endif}CurrencyFormat;
  defaultformatsettingsmse.NegCurrFormat:= 
     {$ifdef FPC}defaultformatsettings.{$endif}NegCurrFormat;
  defaultformatsettingsmse.ThousandSeparator:= widechar(
     {$ifdef FPC}defaultformatsettings.{$endif}ThousandSeparator);
  defaultformatsettingsmse.DecimalSeparator:= widechar(
     {$ifdef FPC}defaultformatsettings.{$endif}DecimalSeparator);
  defaultformatsettingsmse.CurrencyDecimals:= 
     {$ifdef FPC}defaultformatsettings.{$endif}CurrencyDecimals;
  defaultformatsettingsmse.DateSeparator:= widechar(
     {$ifdef FPC}defaultformatsettings.{$endif}DateSeparator);
  defaultformatsettingsmse.TimeSeparator:= widechar(
     {$ifdef FPC}defaultformatsettings.{$endif}TimeSeparator);
  defaultformatsettingsmse.ListSeparator:= widechar(
     {$ifdef FPC}defaultformatsettings.{$endif}ListSeparator);
  defaultformatsettingsmse.CurrencyString:= 
     {$ifdef FPC}defaultformatsettings.{$endif}CurrencyString;
  defaultformatsettingsmse.ShortDateFormat:= 
     {$ifdef FPC}defaultformatsettings.{$endif}ShortDateFormat;
  defaultformatsettingsmse.LongDateFormat:= 
     {$ifdef FPC}defaultformatsettings.{$endif}LongDateFormat;
  defaultformatsettingsmse.TimeAMString:= 
     {$ifdef FPC}defaultformatsettings.{$endif}TimeAMString;
  defaultformatsettingsmse.TimePMString:= 
     {$ifdef FPC}defaultformatsettings.{$endif}TimePMString;
  defaultformatsettingsmse.ShortTimeFormat:= 
     {$ifdef FPC}defaultformatsettings.{$endif}ShortTimeFormat;
  defaultformatsettingsmse.LongTimeFormat:= 
     {$ifdef FPC}defaultformatsettings.{$endif}LongTimeFormat;
  for int1:= low(tmonthnamearraymse) to high(tmonthnamearraymse) do begin
   defaultformatsettingsmse.ShortMonthNames[int1]:= 
     {$ifdef FPC}defaultformatsettings.{$endif}ShortMonthNames[int1];
  end;
  for int1:= low(tmonthnamearraymse) to high(tmonthnamearraymse) do begin
   defaultformatsettingsmse.LongMonthNames[int1]:= 
     {$ifdef FPC}defaultformatsettings.{$endif}LongMonthNames[int1];
  end;
  for int1:= low(tweeknamearraymse) to high(tweeknamearraymse) do begin
   defaultformatsettingsmse.ShortDayNames[int1]:= 
     {$ifdef FPC}defaultformatsettings.{$endif}ShortDayNames[int1];
  end;
  for int1:= low(tweeknamearraymse) to high(tweeknamearraymse) do begin
   defaultformatsettingsmse.LongDayNames[int1]:= 
     {$ifdef FPC}defaultformatsettings.{$endif}LongDayNames[int1];
  end;
  defaultformatsettingsmse.TwoDigitYearCenturyWindow:= 
     {$ifdef FPC}defaultformatsettings.{$endif}TwoDigitYearCenturyWindow;
 end;
end;

procedure saveformatsettings;
var
 int1: integer;
begin
 {$ifdef FPC}defaultformatsettings.{$endif}CurrencyFormat:=
                      defaultformatsettingsmse.CurrencyFormat;
 {$ifdef FPC}defaultformatsettings.{$endif}NegCurrFormat:= 
                      defaultformatsettingsmse.NegCurrFormat;
 {$ifdef FPC}defaultformatsettings.{$endif}ThousandSeparator:=
                      char(defaultformatsettingsmse.ThousandSeparator);
 {$ifdef FPC}defaultformatsettings.{$endif}DecimalSeparator:= 
                      char(defaultformatsettingsmse.DecimalSeparator);
 {$ifdef FPC}defaultformatsettings.{$endif}CurrencyDecimals:= 
                      defaultformatsettingsmse.CurrencyDecimals;
 {$ifdef FPC}defaultformatsettings.{$endif}DateSeparator:= 
                      char(defaultformatsettingsmse.DateSeparator);
 {$ifdef FPC}defaultformatsettings.{$endif}TimeSeparator:= 
                      char(defaultformatsettingsmse.TimeSeparator);
 {$ifdef FPC}defaultformatsettings.{$endif}ListSeparator:= 
                      char(defaultformatsettingsmse.ListSeparator);
 {$ifdef FPC}defaultformatsettings.{$endif}CurrencyString:= 
                      defaultformatsettingsmse.CurrencyString;
 {$ifdef FPC}defaultformatsettings.{$endif}ShortDateFormat:= 
                      defaultformatsettingsmse.ShortDateFormat;
 {$ifdef FPC}defaultformatsettings.{$endif}LongDateFormat:= 
                      defaultformatsettingsmse.LongDateFormat;
 {$ifdef FPC}defaultformatsettings.{$endif}TimeAMString:= 
                      defaultformatsettingsmse.TimeAMString;
 {$ifdef FPC}defaultformatsettings.{$endif}TimePMString:= 
                      defaultformatsettingsmse.TimePMString;
 {$ifdef FPC}defaultformatsettings.{$endif}ShortTimeFormat:= 
                      defaultformatsettingsmse.ShortTimeFormat;
 {$ifdef FPC}defaultformatsettings.{$endif}LongTimeFormat:= 
                      defaultformatsettingsmse.LongTimeFormat;
 for int1:= low(tmonthnamearraymse) to high(tmonthnamearraymse) do begin
  {$ifdef FPC}defaultformatsettings.{$endif}ShortMonthNames[int1]:=
                      defaultformatsettingsmse.ShortMonthNames[int1];
 end;
 for int1:= low(tmonthnamearraymse) to high(tmonthnamearraymse) do begin
  {$ifdef FPC}defaultformatsettings.{$endif}LongMonthNames[int1]:=
                      defaultformatsettingsmse.LongMonthNames[int1];
 end;
 for int1:= low(tweeknamearraymse) to high(tweeknamearraymse) do begin
  {$ifdef FPC}defaultformatsettings.{$endif}ShortDayNames[int1]:=
                      defaultformatsettingsmse.ShortDayNames[int1];
 end;
 for int1:= low(tweeknamearraymse) to high(tweeknamearraymse) do begin
  {$ifdef FPC}defaultformatsettings.{$endif}LongDayNames[int1]:=
                      defaultformatsettingsmse.LongDayNames[int1];
 end;
 {$ifdef FPC}defaultformatsettings.{$endif}TwoDigitYearCenturyWindow:=
                      defaultformatsettingsmse.TwoDigitYearCenturyWindow;
end;

{$ifdef FPC}

 {$ifopt S+}
 {$define STACKCHECK_WAS_ON}
 {$S-}
 {$endif OPT S }

function getexceptionstack(obj: tobject; addr: pointer; framecount: longint;
                                     frames: ppointer): msestring;
Var
 i: longint;
begin
 if Obj is exception then begin
    result:= Exception(Obj).ClassName+' : '+Exception(Obj).Message+ lineend;
 end
 else begin
  result:= 'Exception object '+Obj.ClassName+
           ' is not of class Exception.'+lineend;
 end;
 result:= result + BackTraceStrFunc(Addr)+lineend;
 if (FrameCount>0) then begin
  for i:=0 to FrameCount-1 do begin
    result:= result+BackTraceStrFunc(Frames[i])+lineend;
  end;
 end;
end;

function getexceptiontext(obj: tobject; addr: pointer; framecount: longint;
                                     frames: ppointer): msestring;
begin
 result:= 'An exception occurred at $'+
               HexStr(Ptrint(Addr),sizeof(PtrInt)*2)+' :' + lineend;
 result:= result + getexceptionstack(obj,addr,framecount,frames); 
end;

procedure listexceptionstack(Obj: TObject; Addr:Pointer; FrameCount: Longint;
                                  Frames: PPointer);
{
Var
 Message: String;
 i: longint;
}
begin
{
 if Obj is exception then begin
    Message:=Exception(Obj).ClassName+' : '+Exception(Obj).Message;
    debugWriteln(Message);
 end
 else begin
  debugWriteln('Exception object '+Obj.ClassName+' is not of class Exception.');
 end;
 debugWriteln(BackTraceStrFunc(Addr));
 if (FrameCount>0) then begin
  for i:=0 to FrameCount-1 do begin
    debugWriteln(BackTraceStrFunc(Frames[i]));
  end;
 end;
 debugWriteln('');
}
 debugwriteln(getexceptionstack(obj,addr,framecount,frames));
end;

Procedure CatchUnhandledExcept(Obj : TObject; Addr: Pointer; FrameCount: Longint;
                                  Frames: PPointer);
begin
 {$ifdef MSWINDOWS}
  if getstdhandle(std_error_handle) <= 0 then begin
   catchunhandledexception(obj,addr,framecount,frames);
  end
  else begin
 {$endif}
   debugWriteln('An unhandled exception occurred at $'+
               HexStr(Ptrint(Addr),sizeof(PtrInt)*2)+' :');
   listexceptionstack(obj,addr,framecount,frames);
  {$ifdef MSWINDOWS}
  end;
  {$endif}
end;

{$ifdef mse_debugexception}
procedure raisepro(obj: tobject; addr: pointer; framecount: longint;
                                     frames: ppointer);
begin
 debugWriteln('An exception occurred at $'+
               HexStr(Ptrint(Addr),sizeof(PtrInt)*2)+' :');
 listexceptionstack(obj,addr,framecount,frames);
end;
{$endif}

initialization
 exceptproc:= @catchunhandledexcept;
{$ifdef mse_debugexception}
 raiseproc:= @raisepro;
 raisemaxframecount:= 100;
{$endif}
{$else}    //fpc
initialization
{$endif}   //delphi
 initdefaultformatsettings;
end.

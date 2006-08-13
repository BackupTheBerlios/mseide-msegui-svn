{ MSEgui Copyright (c) 1999-2006 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit msesysintf; //i386-linux

{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface
uses
 msesys,msethread,msetypes,msestrings;

{$include ..\msesysintf.inc}

var
 iswin95: boolean;
 iswin98: boolean;

implementation
uses
 sysutils,windows,msebits,msefileutils,mseguiintf,msedatalist;

//todo: correct unicode implementation, long filepaths, stubs for win95

var
 homedir: filenamety;

const
 FILE_ATTRIBUTE_ENCRYPTED	= $0040;
 FILE_ATTRIBUTE_REPARSE_POINT = $0400;
 FILE_ATTRIBUTE_SPARSE_FILE = $0200;
 {$ifdef FPC}
 FILE_ATTRIBUTE_OFFLINE              = $00001000;
 {$endif}
 filetimeoffset = -109205.0;

type
 win32threadinfoty = record
  handle: cardinal;
  platformdata: array[1..3] of cardinal;
 end;

 {$ifdef FPC}
 PCRITICAL_SECTION_DEBUG = ^CRITICAL_SECTION_DEBUG;
     //bug in struct.inc
     CRITICAL_SECTION = record
          DebugInfo : PCRITICAL_SECTION_DEBUG;
          LockCount : LONG;
          RecursionCount : LONG;
          OwningThread : HANDLE;
          LockSemaphore : HANDLE;
          Reserved : DWORD;
       end;
 {$endif}
 win32mutexty = record
  mutex: trtlcriticalsection;
  trycount: integer;
  platformdata: array[7..7] of cardinal;
 end;

 win32semty = record
  event: cardinal;
  semacount: integer;
  destroyed: integer;
  platformdata: array[3..7] of cardinal;
 end;

 condeventsty = (ce_signal,ce_broadcast);
 win32condty = record
  events: array[condeventsty] of cardinal;
  waiterscount: integer;
  waiterscountlock: trtlcriticalsection;
  mutex: trtlcriticalsection;
  platformdata: array[15..31] of cardinal;
 end;

 winfileinfoty = record
  dwFileAttributes: DWORD;
  ftCreationTime: TFileTime;
  ftLastAccessTime: TFileTime;
  ftLastWriteTime: TFileTime;
 end;
 winfilesizety = record
  nFileSizeHigh: DWORD;
  nFileSizeLow: DWORD;
 end;
 winfilenameaty = array[0..MAX_PATH - 1] of Char;
 pwinfilenameaty = ^winfilenameaty;
 WIN32_FIND_DATAA = record
   winfo: winfileinfoty;
   wsize: winfilesizety;
   dwReserved0: DWORD;
   dwReserved1: DWORD;
   cFileName: winfilenameaty;
   cAlternateFileName: array[0..13] of Char;
 end;
 pwin32_find_dataa = ^win32_find_dataa;
 WIN32_FIND_DATAW = record
   winfo: winfileinfoty;
   wsize: winfilesizety;
   dwReserved0: DWORD;
   dwReserved1: DWORD;
   cFileName: array[0..MAX_PATH - 1] of WideChar;
   cAlternateFileName: array[0..13] of WideChar;
 end;
 pwin32_find_dataw = ^win32_find_dataw;

 BY_HANDLE_FILE_INFORMATION = record
  winfo: winfileinfoty;
  dwVolumeSerialNumber: DWORD;
  wsize: winfilesizety;
  nNumberOfLinks: DWORD;
  nFileIndexHigh: DWORD;
  nFileIndexLow: DWORD;
 end;

 dirstreamwin32ty = record
  handle: cardinal;
  finddatapo: pwin32_find_dataw;
  last: boolean;
  drivenum: integer; //for root directory
  platformdata: array[4..7] of cardinal;
 end;
 
const
 TH32CS_SNAPHEAPLIST = $00000001;
 TH32CS_SNAPPROCESS  = $00000002;
 TH32CS_SNAPTHREAD   = $00000004;
 TH32CS_SNAPMODULE   = $00000008;
 TH32CS_SNAPALL      = TH32CS_SNAPHEAPLIST or TH32CS_SNAPPROCESS or 
                       TH32CS_SNAPTHREAD or TH32CS_SNAPMODULE;
 TH32CS_INHERIT      = $80000000;
type
 PROCESSENTRY32 = record
  dwSize: DWORD;
  cntUsage: DWORD;
  th32ProcessID: DWORD;
  th32DefaultHeapID: pointer;
  th32ModuleID: DWORD;
  cntThreads: DWORD;
  th32ParentProcessID: DWORD;
  pcPriClassBase: LONG;
  dwFlags: DWORD;
  szExeFile: array[0..MAX_PATH-1] of char;
 end;
 PPROCESSENTRY32 = ^PROCESSENTRY32;
 
function CreateToolhelp32Snapshot(dwFlags: dword; th32ProcessId: dword): thandle;
              stdcall; external kernel32 name 'CreateToolhelp32Snapshot';
function Process32First(hSnapshot: thandle; lppe: PPROCESSENTRY32): BOOL;
              stdcall; external kernel32 name 'Process32First';
function Process32Next(hSnapshot: thandle; lppe: PPROCESSENTRY32): BOOL;
              stdcall; external kernel32 name 'Process32Next';

function sys_getprintcommand: string;
begin
 result:= 'gswin32c.exe -dNOPAUSE -sDEVICE=mswinpr2 -';
end;

function sys_getlasterror: Integer;
begin
 result:= windows.GetLastError;
end;

procedure sys_setlasterror(const avalue: integer);
begin
 windows.setlasterror(avalue);
end;

function sys_geterrortext(aerror: integer): string;
const
 maxlen = 1024;
var
 int1: integer;
begin
 setlength(result,maxlen);
 int1:= formatmessage(format_message_from_system,nil,aerror,0,pchar(result),maxlen,nil);
 setlength(result,int1);
end;
{
function sys_towupper(char: msechar): msechar;
begin
 result:= windows.charupperw(ord(char)); //win95?
end;

function sys_toupper(char: char): char;
begin
 result:= windows.charupper(ord(char));
end;
}

function sys_getprocesses: procitemarty;
var
 int1: integer;
 th: thandle;
 info: processentry32;
begin
 result:= nil;
 th:= createtoolhelp32snapshot(th32cs_snapprocess,0);
 int1:= 0;
 if th <> invalid_handle_value then begin
  info.dwsize:= sizeof(info);
  if process32first(th,@info) then begin
   repeat
    additem(result,typeinfo(procitemarty),int1);
    with result[int1-1] do begin
     pid:= info.th32processid;
     ppid:= info.th32parentprocessid;
    end;
   until not process32next(th,@info);
  end;
  closehandle(th);
  setlength(result,int1);
 end;
end;

procedure sys_usleep(const us: cardinal);
begin
 sleep(us div 1000);
end;

function sys_getapplicationpath: filenamety;
const
 bufsize = 1024;
var
 int1: integer;
 str1: string;
begin
 setlength(str1,bufsize);
 int1:= getmodulefilename(hinstance,@str1[1],bufsize-1);
 setlength(str1,int1);
 result:= tomsefilepath(str1);
end;

function sys_getcommandlinearguments: stringarty;
begin
 {$ifdef FPC}{$checkpointer off}{$endif}
 result:= parsecommandline(cmdline);
 {$ifdef FPC}{$checkpointer default}{$endif}
end;

function winfilepath(dirname,filename: msestring): msestring;
begin
 replacechar1(dirname,msechar('/'),msechar('\'));
 replacechar1(filename,msechar('/'),msechar('\'));
 if (length(dirname) >= 3) and (dirname[1] = '\') and (dirname[3] = ':') then begin
  dirname[1]:= dirname[2]; // '/c:' -> 'c:\'
  dirname[2]:= ':';
  dirname[3]:= '\';
  if (dirname[4] = '\') and (length(dirname) > 4) then begin
   move(dirname[5],dirname[4],(length(dirname) - 4)*sizeof(msechar));
   setlength(dirname,length(dirname) - 1);
  end;
 end;
 if filename <> '' then begin
  if dirname = '' then begin
   result:= '.\'+filename;
  end
  else begin
   if dirname[length(dirname)] <> '\' then begin
    result:= dirname + '\' + filename;
   end
   else begin
    result:= dirname + filename;
   end;
  end;
 end
 else begin
  result:= dirname;
 end;
end;

function sys_filesystemiscaseinsensitive: boolean;
begin
 result:= true;
end;

function sys_tosysfilepath(var path: msestring): syserrorty;
begin
 path:= winfilepath(path,'');
 result:= sye_ok;
end;

function sys_read(fd:longint; buf:pointer; nbytes: dword): integer;
begin
 result:= -1; //compilerwarning;
 if not windows.readfile(fd,buf^,nbytes,dword(result),nil) then begin
  result:= -1;
 end;
 {
 if nbytes > 0 then begin
  repeat
   if not windows.readfile(fd,buf^,nbytes,dword(result),nil) then begin
    result:= -1;
   end;
  until result <> 0;
 end
 else begin
  result:= 0;
 end;
 }
end;

function sys_write(fd:longint; buf:pointer; nbytes: dword): integer;
begin
 result:= -1; //compilerwarning;
 if nbytes > 0 then begin
  repeat
   if not windows.WriteFile(fd,buf^,nbytes,dword(result),nil) then begin
    result:= -1;
   end;
  until result <> 0;
 end
 else begin
  result:= 0;
 end;
end;

function sys_errorout(const atext: string): syserrorty;
var
 ca1: cardinal;
begin
 if length(atext) > 0 then begin
  if isconsole then begin
   if windows.writefile(getstdhandle(std_input_handle),pchar(atext)^,
      length(atext),ca1,nil) then begin
    result:= sye_ok;
   end
   else begin
    result:= syelasterror;
   end;
  end
  else begin
   result:= sye_noconsole;
  end;
 end
 else begin
  result:= sye_ok;
 end;
end;

function sys_openfile(const path: msestring; const openmode: fileopenmodety;
          const accessmode: fileaccessmodesty;
          const rights: filerightsty; out handle: integer): syserrorty;
const
 openmodes: array[fileopenmodety] of cardinal =
     (generic_read,generic_write,generic_read or generic_write,
      generic_read or generic_write,generic_read or generic_write);
var
 ca1: cardinal;
 str1: string;
 str2: msestring;

begin
 str2:= winfilepath(path,'');
 str1:= str2;
 if not (fa_denyread in accessmode) then begin
  ca1:= file_share_read;
 end
 else begin
  ca1:= 0;
 end;
 if not (fa_denywrite in accessmode) then begin
  ca1:= ca1 or file_share_write;
 end;

 if openmode = fm_Create then begin
  handle:= CreateFile(PChar(str1),openmodes[openmode], //todo: rights -> securityattributes
    ca1, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
 end
 else begin
  handle:= CreateFile(PChar(str1),openmodes[openmode],
    ca1, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
 end;
 if handle = invalidfilehandle then begin
  result:= syelasterror;
 end
 else begin
  result:= sye_ok;
 end;
end;

function sys_closefile(const handle: integer): syserrorty;
begin
 if (handle = invalidfilehandle) or closehandle(handle) then begin
  result:= sye_ok;
 end
 else begin
  result:= syelasterror;
 end;
end;

function sys_copyfile(const oldfile,newfile: msestring): syserrorty;
var
 str1,str2: string;
begin
 str1:= winfilepath(oldfile,'');
 str2:= winfilepath(newfile,'');
 if windows.copyfile(pchar(str1),pchar(str2),false) then begin
  result:= sye_ok;
 end
 else begin
  result:= syelasterror;
 end;
end;

function sys_renamefile(const oldname,newname: filenamety): syserrorty;
var
 str1,str2: string;
begin
 str1:= winfilepath(oldname,'');
 str2:= winfilepath(newname,'');
 if windows.movefileex(pchar(str1),pchar(str2),movefile_replace_existing) then begin
  result:= sye_ok;
 end
 else begin
  result:= syelasterror;
 end;  
end;

function sys_createdir(const path: msestring;
                 const rights: filerightsty): syserrorty;
var
 str1: string;
begin
 str1:= winfilepath(path,'');
 if windows.createdirectory(pchar(str1),nil) then begin //todo: rights -> securityattributes
  result:= sye_ok;
 end
 else begin
  result:= syelasterror;
 end;
end;

function sys_gettimeus: cardinal;
begin
 result:= gettickcount * 1000;
end;
{
function sys_getlastsyserror: integer;
begin
 result:= getlasterror;
end;
}
{$ifdef FPC}

function threadexec(infopo : pointer) : longint;
begin
//result:= 0;
//exit;
 result:= threadinfoty(infopo^).threadproc();
end;

{$else}

function threadexec(infopo: pointer): integer; stdcall;
begin
 result:= threadinfoty(infopo^).threadproc();
end;

{$endif}

function sys_threadcreate(var info: threadinfoty): syserrorty;
begin
{$ifdef FPC}
 with info,win32threadinfoty(platformdata) do begin
  handle:= beginthread(@threadexec,@info,id);
  if handle = 0 then begin
   result:= sye_thread;
  end
  else begin
   result:= sye_ok;
  end;
 end;
{$else}
 ismultithread:= true;
 with info,win32threadinfoty(platformdata) do begin
  handle:= windows.CreateThread(nil,0,@threadexec,@info,0,id);
  if handle = 0 then begin
   result:= sye_thread;
   id:= 0;
  end
  else begin
   result:= sye_ok;
  end;
 end;
{$endif}
end;

function sys_threadwaitfor(var info: threadinfoty): syserrorty;
begin
 with info,win32threadinfoty(platformdata) do begin
  if waitforsingleobject(handle,infinite) = wait_object_0 then begin
   result:= sye_ok;
  end
  else begin
   result:= sye_thread;
  end;
 end;
end;

function sys_getcurrentthread: threadty;
begin
 result:= getcurrentthreadid;
end;

function sys_issamethread(const a,b: threadty): boolean;
begin
 result:= a = b;
end;

function sys_threaddestroy(var info: threadinfoty): syserrorty;
var
 ca1: cardinal;
begin
 result:= sye_ok;
 with win32threadinfoty(info.platformdata) do begin
  if getexitcodethread(handle,ca1) then begin
   if ca1 = still_active then begin
    terminatethread(handle,exitcode);
   end;
  end;
  closehandle(handle);
 end;
end;

function sys_mutexcreate(out mutex: mutexty): syserrorty;
begin
 with win32mutexty(mutex) do begin
  windows.initializecriticalsection(mutex);
  trycount:= 0;
 end;
 result:= sye_ok;
end;

function sys_mutexdestroy(var mutex: mutexty): syserrorty;
begin
 result:= sye_ok;
 windows.deletecriticalsection(win32mutexty(mutex).mutex);
end;

function lockmutex(var mutex: mutexty; const noblock: boolean): syserrorty;
var
 bo1: boolean;
begin
 with win32mutexty(mutex) do begin
  while interlockedincrement(trycount) > 1 do begin
   interlockeddecrement(trycount);
   windows.sleep(0);
  end;
  bo1:= (mutex.lockcount = -1) or (mutex.owningthread = getcurrentthreadid);
  interlockeddecrement(trycount);
  if not bo1 and noblock then begin
   result:= sye_busy;
   exit;
  end;
  windows.entercriticalsection(mutex);
 end;
 result:= sye_ok;
end;

function sys_mutexlock(var mutex: mutexty): syserrorty;
begin
 result:= lockmutex(mutex,false);
end;

function sys_mutextrylock(var mutex: mutexty): syserrorty;
begin
 result:= lockmutex(mutex,true);
end;

function sys_mutexunlock(var mutex: mutexty): syserrorty;
begin
 windows.leavecriticalsection(win32mutexty(mutex).mutex);
 result:= sye_ok;
end;

function sys_semcreate(out sem: semty; count: integer): syserrorty;
begin
 fillchar(sem,sizeof(sem),0);
 with win32semty(sem) do begin
  semacount:= count;
  event:= createevent(nil,false,false,nil);
  result:= sye_ok;
 end;
end;

function sempost1(var sem: semty): syserrorty;
begin
 with win32semty(sem) do begin
  if interlockedincrement(semacount) <= 0 then begin
   setevent(event);
  end;
  result:= sye_ok;
 end;
end;

function sys_sempost(var sem: semty): syserrorty;
begin
 with win32semty(sem) do begin
  if destroyed <> 0 then begin
   result:= sye_semaphore;
   exit;
  end;
 end;
 result:= sempost1(sem);
end;

function sys_semdestroy(var sem: semty): syserrorty;
var
 int1: integer;

begin
 with win32semty(sem) do begin
  int1:= interlockedincrement(destroyed);
  if int1 = 1 then begin
   while semacount < 0 do begin
    sempost1(sem);
   end;
   closehandle(event);
  end;
 end;
 result:= sye_ok;
end;

function sys_semwait(var sem: semty; timeoutusec: integer): syserrorty;
var
 int1: integer;
begin
 result:= sye_semaphore;
 with win32semty(sem) do begin
  if destroyed <> 0 then begin
   exit;
  end;
  if interlockeddecrement(semacount) < 0 then begin
   if timeoutusec = 0 then begin
    timeoutusec:= integer(infinite);
   end
   else begin
    timeoutusec:= timeoutusec div 1000;
   end;
   int1:= waitforsingleobject(event,timeoutusec);
   if int1 = wait_object_0 then begin
    result:= sye_ok;
   end
   else begin
    if int1 = wait_timeout then begin
     result:= sye_timeout;
    end;
   end;
  end
  else begin
   result:= sye_ok;
  end;
 end;
end;

function sys_semcount(var sem: semty): integer;
begin
 with win32semty(sem) do begin
  result:= semacount;
  if result < 0 then begin
   result:= 0;
  end;
 end;
end;

function sys_semtrywait(var sem: semty): boolean;
begin
 with win32semty(sem) do begin
  if destroyed <> 0 then begin
   result:= false;
   exit;
  end;
  result:= semacount > 0;
  if result then begin
   result:= interlockeddecrement(semacount) >= 0;
   if not result then begin
    interlockeddecrement(semacount);
   end;
  end;
 end;
end;

function sys_condcreate(out cond: condty): syserrorty;
begin
 with win32condty(cond) do begin
  waiterscount:= 0;
  windows.initializecriticalsection({$ifdef FPC}@{$endif}waiterscountlock);
  windows.initializecriticalsection({$ifdef FPC}@{$endif}mutex);
  events[ce_signal]:= createevent(nil,false,false,nil);
  events[ce_broadcast]:= createevent(nil,true,false,nil);
 end;
 result:= sye_ok;
end;

function sys_conddestroy(var cond: condty): syserrorty;
begin
 with win32condty(cond) do begin
  closehandle(events[ce_signal]);
  closehandle(events[ce_broadcast]);
  windows.deletecriticalsection({$ifdef FPC}@{$endif}waiterscountlock);
  windows.deletecriticalsection({$ifdef FPC}@{$endif}mutex);
 end;
 result:= sye_ok;
end;

function sys_condlock(var cond: condty): syserrorty;
begin
 with win32condty(cond) do begin
  windows.entercriticalsection({$ifdef FPC}@{$endif}mutex);
 end;
 result:= sye_ok;
end;

function sys_condunlock(var cond: condty): syserrorty;
begin
 with win32condty(cond) do begin
  windows.leavecriticalsection({$ifdef FPC}@{$endif}mutex);
 end;
 result:= sye_ok;
end;

function sys_condsignal(var cond: condty): syserrorty;
var
 bo1: boolean;
begin
 with win32condty(cond) do begin
  windows.entercriticalsection({$ifdef FPC}@{$endif}waiterscountlock);
  bo1:= waiterscount > 0;
  windows.leavecriticalsection({$ifdef FPC}@{$endif}waiterscountlock);
  if bo1 then begin
   setevent(events[ce_signal]);
  end;
 end;
 result:= sye_ok;
end;

function sys_condbroadcast(var cond: condty): syserrorty;
var
 bo1: boolean;
begin
 with win32condty(cond) do begin
  windows.entercriticalsection({$ifdef FPC}@{$endif}waiterscountlock);
  bo1:= waiterscount > 0;
  windows.leavecriticalsection({$ifdef FPC}@{$endif}waiterscountlock);
  if bo1 then begin
   setevent(events[ce_broadcast]);
  end;
 end;
 result:= sye_ok;
end;

function sys_condwait(var cond: condty; timeoutusec: integer): syserrorty;
          //timeoutusec = 0 -> no timeout
          //sye_ok -> condition signaled
          //sye_timeout -> timeout
          //sye_cond -> error
var
 int1: integer;
 bo1: boolean;

begin
 result:= sye_cond;
 with win32condty(cond) do begin
  windows.entercriticalsection({$ifdef FPC}@{$endif}waiterscountlock);
  inc(waiterscount);
  windows.leavecriticalsection({$ifdef FPC}@{$endif}waiterscountlock);
  windows.leavecriticalsection({$ifdef FPC}@{$endif}mutex);
  if timeoutusec = 0 then begin
   timeoutusec:= integer(infinite);
  end
  else begin
   timeoutusec:= timeoutusec div 1000;
  end;
  int1:= waitformultipleobjects(2,@events,false,timeoutusec);
  windows.entercriticalsection({$ifdef FPC}@{$endif}waiterscountlock);
  dec(waiterscount);
  bo1:= (int1 = wait_object_0 + ord(ce_broadcast)) and (waiterscount = 0);
  windows.leavecriticalsection({$ifdef FPC}@{$endif}waiterscountlock);
  if bo1 then begin
   resetevent(events[ce_broadcast]);
  end;
  if int1 = wait_timeout then begin
   result:= sye_timeout;
  end
  else begin
   if (int1 < wait_abandoned_0) or (int1 > wait_abandoned_0 + 1) then begin
    result:= sye_ok;
   end;
  end;
  windows.entercriticalsection({$ifdef FPC}@{$endif}mutex);
 end;
end;

function sys_localtimeoffset: tdatetime;
var
 info: _time_zone_information;
begin
 if gettimezoneinformation(info) = $ffffffff then begin
  result:= 0;
 end
 else begin
  result:= - info.Bias / (24.0*60.0);
 end;
end;

function filetimetotime(const wtime: tfiletime): tdatetime;
begin
 with wtime do begin
  if (dwLowDateTime = 0) and (dwhighdatetime = 0) then begin
   result:= 0;
  end
  else begin
   result:= (dwhighdatetime*twoexp32 + dwLowDateTime) /
                   (24.0*60.0*60.0*1000000.0*10.0) + filetimeoffset;
  end;
 end;
end;

procedure winfileinfotofileinfo(const winfo: winfileinfoty; const wsize: winfilesizety;
                         var info: fileinfoty);
begin
 with winfo,info,extinfo1 do begin
  include(state,fis_extinfo1valid);
  if filetype = ft_dir then begin
   attributes:= [fa_dir];
  end
  else begin
   attributes:= [];
  end;
  if file_attribute_archive and dwfileattributes <> 0 then begin
   include(attributes,fa_archive);
  end;
  if file_attribute_compressed and dwfileattributes <> 0 then begin
   include(attributes,fa_compressed);
  end;
  if file_attribute_encrypted and dwfileattributes <> 0 then begin
   include(attributes,fa_encrypted);
  end;
  if file_attribute_hidden and dwfileattributes <> 0 then begin
   include(attributes,fa_hidden);
  end;
  if file_attribute_offline and dwfileattributes <> 0 then begin
   include(attributes,fa_offline);
  end;
  attributes:= attributes + [fa_rusr,fa_xusr,fa_rgrp,fa_xgrp,fa_roth,fa_xoth];
  if file_attribute_readonly and dwfileattributes = 0 then begin
   attributes:= attributes + [fa_wusr,fa_wgrp,fa_woth];
  end;
  if file_attribute_reparse_point and dwfileattributes <> 0 then begin
   include(attributes,fa_reparsepoint);
  end;
  if file_attribute_sparse_file and dwfileattributes <> 0 then begin
   include(attributes,fa_sparsefile);
  end;
  if file_attribute_system and dwfileattributes <> 0 then begin
   include(attributes,fa_system);
  end;
  if file_attribute_temporary and dwfileattributes <> 0 then begin
   include(attributes,fa_temporary);
  end;
  with int64recty(size) do begin
   lsw:= wsize.nfilesizelow;
   msw:= wsize.nfilesizehigh;
  end;
  modtime:= filetimetotime(ftlastwritetime);
  accesstime:= filetimetotime(ftlastaccesstime);
  ctime:= filetimetotime(ftcreationtime);
 end;
end;

function rembackslash(po: pchar): pchar;
begin
 result:= po;
 while result^ = '\' do begin
  inc(result);
 end;
end;

function findservers(const resource: pnetresource; var names: msestringarty): syserrorty;
var
 wo1: longword;
 handle: thandle;
 po1:  pnetresource;
 ca1,ca2: cardinal;
begin
 result:= sye_network;
 wo1:= wnetopenenum(resource_globalnet,resourcetype_disk,0,resource,handle);
 if wo1 <> no_error then begin
  exit;
 end;
 getmem(po1,sizeof(tnetresource));
 ca2:= sizeof(tnetresource);
 wo1:= 0; //compilerwarning
 repeat
  while true do begin
   ca1:= 1;
   wo1:= wnetenumresource(handle,ca1,po1,ca2);
   if wo1 = error_more_data then begin
    reallocmem(po1,ca2);
   end
   else begin
    break;
   end;
  end;
  if wo1 = no_error then begin
   if (po1^.dwtype = resourcetype_disk) and
        (po1^.dwdisplaytype = resourcedisplaytype_server) and
             (po1^.lpRemoteName <> nil) then begin
    setlength(names,high(names)+2);
    names[high(names)]:= rembackslash(po1^.lpRemoteName);
    result:= sye_ok;
   end
   else begin
    if po1^.dwUsage and resourceusage_container <> 0 then begin
     if findservers(po1,names) = sye_ok then begin
      result:= sye_ok;
     end;
    end
   end;
  end;
 until wo1 <> no_error;
 wnetcloseenum(handle);
 freemem(po1);
// result:= sye_ok;
end;

function findserver(const name: string; var resource: pnetresource): syserrorty;

var
 wo1: longword;
 handle: thandle;
 ca1,ca2: cardinal;
 po1: pnetresource;
begin
 result:= sye_network;
 wo1:= wnetopenenum(resource_globalnet,resourcetype_disk,0,resource,handle);
 resource:= nil;
 if wo1 <> no_error then begin
  exit;
 end;
 getmem(po1,sizeof(tnetresource));
 ca2:= sizeof(tnetresource);
 wo1:= 0; //compilerwarning
 repeat
  while true do begin
   ca1:= 1;
   wo1:= wnetenumresource(handle,ca1,po1,ca2);
   if wo1 = error_more_data then begin
    reallocmem(po1,ca2);
   end
   else begin
    break;
   end;
  end;
  if wo1 = no_error then begin
   if (po1^.dwtype = resourcetype_disk) and (po1^.lpremotename <> nil) and
         (strcomp(pchar(name),rembackslash(po1^.lpremotename)) = 0)  then begin
    resource:= po1;
    result:= sye_ok;
    break;
   end
   else begin
    if po1^.dwUsage and resourceusage_container <> 0 then begin
     resource:= po1;
     result:= findserver(name,resource);
    end
   end;
  end;
 until (wo1 <> no_error) or (result = sye_ok);
 wnetcloseenum(handle);
 if resource <> po1 then begin
  freemem(po1);
 end;
end;

function sys_opendirstream(var stream: dirstreamty): syserrorty;
var
 wo1: longword;
 int1: integer;
// ar1: msestringarty;
begin
 with stream,dirstreamwin32ty(platformdata) do begin
  result:= sye_ok;
  if dirname <> '/' then begin
   if msestartsstr('//',dirname) then begin //UNC
    if length(dirname) = 2 then begin
     finddatapo:= nil;
     result:= findservers(nil,msestringarty(finddatapo));
     if finddatapo <> nil then begin
      result:= sye_ok;
     end;
     drivenum:= -3;     //network root
     handle:= 0;
     {
     wo1:= wnetopenenum(resource_globalnet,resourcetype_disk,0,nil,handle);
     if wo1 <> no_error then begin
      result:= sye_dirstream;
     end;
     }
     exit;
    end
    else begin
     if countchars(dirname,msechar('/')) = 2 then begin //list shares
      drivenum:= -2;
      finddatapo:= nil;
      result:= findserver(copy(ansiuppercase(dirname),3,bigint),
                              pnetresource(finddatapo));
      if finddatapo <> nil then begin
       result:= sye_ok;
      end;
      if result = sye_ok then begin
       wo1:= wnetopenenum(resource_globalnet,resourcetype_disk,0,
                    pnetresource(finddatapo),handle);
       if wo1 <> no_error then begin
        result:= sye_dirstream;
       end;
       freemem(finddatapo);
      end;
      exit;
     end;
    end;
   end;
   drivenum:= -1;
   last:= true;
   new(finddatapo);
   if iswin95 then begin
    handle:= findfirstfilea(pchar(string(winfilepath(stream.dirname,'*'))),
    {$ifdef FPC}
     lpwin32_find_data(finddatapo));
    {$else}
     _win32_find_dataa(pointer(finddatapo)^));
    {$endif}
   end
   else begin
    handle:= findfirstfilew(pmsechar(winfilepath(stream.dirname,'*')),
    {$ifdef FPC}
     lpwin32_find_dataw(finddatapo));
    {$else}
     _win32_find_dataw(finddatapo^));
    {$endif}
   end;
   if handle = invalid_handle_value then begin
    int1:= getlasterror;
    if int1 <> error_file_not_found then begin
     dispose(finddatapo);
     setlasterror(int1);
     result:= syelasterror;
    end;
   end
   else begin
    last:= false;
   end;
  end;
 end;
end;

function sys_closedirstream(var stream: dirstreamty): syserrorty;
begin
 with dirstreamwin32ty(stream.platformdata) do begin
  case drivenum of
   -3: begin
    finalize(msestringarty(finddatapo));
   end;
   -2: begin
     wnetcloseenum(handle);
   end;
   -1: begin
    dispose(finddatapo);
    if handle <> invalid_handle_value then begin
     findclose(handle);
    end;
   end;
  end;
 end;
 result:= sye_ok;
end;

function sys_readdirstream(var stream: dirstreamty; var info: fileinfoty): boolean;

 procedure checkinfo;
 begin
  result:= ((fa_all in stream.include) or
                    (info.extinfo1.attributes * stream.include <> [])) and
             checkfilename(info.name,stream.mask) and
               (info.extinfo1.attributes * stream.exclude = []);
 end;

var
 ca1,ca2: cardinal;
 wo1: longword;
 po1:  pnetresource;
 po2: pchar;

begin
 with stream,dirstreamwin32ty(platformdata),finddatapo^,winfo do begin
  result:= false;
  if (include <> []) and not (fa_all in exclude) then begin
   case drivenum of
    -3: begin          //network root
     info.state:= [fis_extinfo1valid];
     info.extinfo1.attributes:= [fa_dir];
     if integer(handle) <= high(msestringarty(finddatapo)) then begin
      repeat
       info.name:= msestringarty(finddatapo)[handle];
       checkinfo;
       inc(handle);
      until result or (integer(handle) > high(msestringarty(finddatapo)));
     end;
    end;
    -2: begin
     info.state:= [fis_extinfo1valid];
     info.extinfo1.attributes:= [fa_dir];
     getmem(po1,sizeof(tnetresource));
     fillchar(po1^,sizeof(tnetresource),0);
     ca2:= sizeof(tnetresource);
     wo1:= 0; //compilerwarning
     repeat
      while true do begin
       ca1:= 1;
       wo1:= wnetenumresource(handle,ca1,po1,ca2);
       if wo1 = error_more_data then begin
        reallocmem(po1,ca2);
       end
       else begin
        break;
       end;
      end;
      if wo1 = no_error then begin
       po2:= strrscan(po1^.lpRemoteName,'\');
       if po2 <> nil then begin
        info.name:= copy(po1^.lpRemoteName,po2-po1^.lpRemoteName+2,bigint);
        checkinfo;
       end
       else begin
        break;
       end;
      end
      else begin
       break;
      end;
     until result;
     freemem(po1);
    end;
    -1: begin          //local root dir
     if not last then begin
      repeat
       if iswin95 then begin
        info.name:= pwinfilenameaty(@cfilename)^;
       end
       else begin
        info.name:= cfilename;
       end;

       if file_attribute_directory and dwfileattributes <> 0 then begin
        info.extinfo1.filetype:= ft_dir;
       end
       else begin
        info.extinfo1.filetype:= ft_reg;
       end;
       winfileinfotofileinfo(winfo,wsize,info);
       if infolevel = fil_ext2 then begin
        //read security level
       end;
       checkinfo;
       if iswin95 then begin
        last:= not findnextfilea(handle,
        {$ifdef FPC}
        lpwin32_find_data(finddatapo));
        {$else}
        _win32_find_dataa(pointer(finddatapo)^));
        {$endif}
       end
       else begin
        last:= not findnextfilew(handle,
        {$ifdef FPC}
        lpwin32_find_dataw(finddatapo));
        {$else}
        _win32_find_dataw(finddatapo^));
        {$endif}
       end;
      until result or last;
     end;
    end
    else begin
     ca1:= getlogicaldrives;
     info.extinfo1.filetype:= ft_dir;
     system.include(info.state,fis_extinfo1valid);
     info.extinfo1.attributes:= [fa_dir];
     while (drivenum < 32) and not result do begin
      if ca1 and bits[drivenum] <> 0 then begin
       setlength(info.name,2);
       info.name[1]:= msechar(ord('A') + drivenum);
       info.name[2]:= ':';
       checkinfo;
      end;
      inc(drivenum);
     end;
    end;
   end;
  end;
 end;
end;

function sys_getfileinfo(const path: filenamety; var info: fileinfoty): boolean;
var
 handle: integer;
 wstr1: filenamety;
 finddata: win32_find_dataw;
begin
 clearfileinfo(info);
 wstr1:= tosysfilepath(path);
 if iswin95 then begin
  handle:= findfirstfilea(pchar(string(wstr1)),
            {$ifdef FPC}@win32_find_dataa
            {$else}twin32finddataa{$endif}(pointer(@finddata)^));
 end
 else begin
  handle:= findfirstfilew(pmsechar(wstr1),
             {$ifdef FPC}@finddata
             {$else}twin32finddataw(finddata){$endif});
 end;
 if cardinal(handle) <> invalid_handle_value then begin
  with win32_find_dataw(finddata) do begin
   if winfo.dwfileattributes and file_attribute_directory <> 0 then begin
    info.extinfo1.filetype:= ft_dir;
   end
   else begin
    info.extinfo1.filetype:= ft_reg;
   end;
   winfileinfotofileinfo(winfo,wsize,info);
   if iswin95 then begin
    info.name:= pwinfilenameaty(@cfilename)^;
   end
   else begin
    info.name:= cfilename;
   end;
  end;
  findclose(handle);
  result:= true;
 end
 else begin
  result:= false;
 end;
end;

function sys_getcurrentdir: msestring;
var
 ca1: cardinal;
 str1: string;
begin
 if iswin95 then begin
  repeat
   ca1:= getcurrentdirectorya(0,nil);
   setlength(str1,ca1-1);
  until (ca1 < 2) or (getcurrentdirectorya(ca1,@str1[1]) = ca1-1);
  result:= str1;
 end
 else begin
  repeat
   ca1:= getcurrentdirectoryw(0,nil);
   setlength(result,ca1-1);
  until (ca1 < 2) or (getcurrentdirectoryw(ca1,@result[1]) = ca1-1);
 end;
 tomsefilepath1(result);
end;

function sys_gethomedir: filenamety;
begin
 result:= homedir;
end;

function sys_setcurrentdir(const dirname: filenamety): syserrorty;
var
 str1: string;
begin
 if iswin95 then begin
  str1:= tosysfilepath(dirname);
  if not setcurrentdirectorya(pchar(str1)) then begin
   result:= syelasterror;
  end
  else begin
   result:= sye_ok;
  end;
 end
 else begin
  if not setcurrentdirectoryw(pmsechar(tosysfilepath(dirname))) then begin
   result:= syelasterror;
  end
  else begin
   result:= sye_ok;
  end;
 end;
end;

const
  CSIDL_PROGRAMS                = $0002; { %SYSTEMDRIVE%\Program Files                                      }
  CSIDL_PERSONAL                = $0005; { %USERPROFILE%\My Documents                                       }
  CSIDL_FAVORITES               = $0006; { %USERPROFILE%\Favorites                                          }
  CSIDL_STARTUP                 = $0007; { %USERPROFILE%\Start menu\Programs\Startup                        }
  CSIDL_RECENT                  = $0008; { %USERPROFILE%\Recent                                             }
  CSIDL_SENDTO                  = $0009; { %USERPROFILE%\Sendto                                             }
  CSIDL_STARTMENU               = $000B; { %USERPROFILE%\Start menu                                         }
  CSIDL_MYMUSIC                 = $000D; { %USERPROFILE%\Documents\My Music                                 }
  CSIDL_MYVIDEO                 = $000E; { %USERPROFILE%\Documents\My Videos                                }
  CSIDL_DESKTOPDIRECTORY        = $0010; { %USERPROFILE%\Desktop                                            }
  CSIDL_NETHOOD                 = $0013; { %USERPROFILE%\NetHood                                            }
  CSIDL_TEMPLATES               = $0015; { %USERPROFILE%\Templates                                          }
  CSIDL_COMMON_STARTMENU        = $0016; { %PROFILEPATH%\All users\Start menu                               }
  CSIDL_COMMON_PROGRAMS         = $0017; { %PROFILEPATH%\All users\Start menu\Programs                      }
  CSIDL_COMMON_STARTUP          = $0018; { %PROFILEPATH%\All users\Start menu\Programs\Startup              }
  CSIDL_COMMON_DESKTOPDIRECTORY = $0019; { %PROFILEPATH%\All users\Desktop                                  }
  CSIDL_APPDATA                 = $001A; { %USERPROFILE%\Application Data (roaming)                         }
  CSIDL_PRINTHOOD               = $001B; { %USERPROFILE%\Printhood                                          }
  CSIDL_LOCAL_APPDATA           = $001C; { %USERPROFILE%\Local Settings\Application Data (non roaming)      }
  CSIDL_COMMON_FAVORITES        = $001F; { %PROFILEPATH%\All users\Favorites                                }
  CSIDL_INTERNET_CACHE          = $0020; { %USERPROFILE%\Local Settings\Temporary Internet Files            }
  CSIDL_COOKIES                 = $0021; { %USERPROFILE%\Cookies                                            }
  CSIDL_HISTORY                 = $0022; { %USERPROFILE%\Local settings\History                             }
  CSIDL_COMMON_APPDATA          = $0023; { %PROFILESPATH%\All Users\Application Data                        }
  CSIDL_WINDOWS                 = $0024; { %SYSTEMROOT%                                                     }
  CSIDL_SYSTEM                  = $0025; { %SYSTEMROOT%\SYSTEM32 (may be system on 95/98/ME)                }
  CSIDL_PROGRAM_FILES           = $0026; { %SYSTEMDRIVE%\Program Files                                      }
  CSIDL_MYPICTURES              = $0027; { %USERPROFILE%\My Documents\My Pictures                           }
  CSIDL_PROFILE                 = $0028; { %USERPROFILE%                                                    }
  CSIDL_PROGRAM_FILES_COMMON    = $002B; { %SYSTEMDRIVE%\Program Files\Common                               }
  CSIDL_COMMON_TEMPLATES        = $002D; { %PROFILEPATH%\All Users\Templates                                }
  CSIDL_COMMON_DOCUMENTS        = $002E; { %PROFILEPATH%\All Users\Documents                                }
  CSIDL_COMMON_ADMINTOOLS       = $002F; { %PROFILEPATH%\All Users\Start Menu\Programs\Administrative Tools }
  CSIDL_ADMINTOOLS              = $0030; { %USERPROFILE%\Start Menu\Programs\Administrative Tools           }
  CSIDL_COMMON_MUSIC            = $0035; { %PROFILEPATH%\All Users\Documents\my music                       }
  CSIDL_COMMON_PICTURES         = $0036; { %PROFILEPATH%\All Users\Documents\my pictures                    }
  CSIDL_COMMON_VIDEO            = $0037; { %PROFILEPATH%\All Users\Documents\my videos                      }
  CSIDL_CDBURN_AREA             = $003B; { %USERPROFILE%\Local Settings\Application Data\Microsoft\CD Burning }
  CSIDL_PROFILES                = $003E; { %PROFILEPATH%                                                    }

  CSIDL_FLAG_CREATE             = $8000; { (force creation of requested folder if it doesn't exist yet)     }


type
 SHGetFolderPathW = function (hwndowner: HWND; nFolder: integer; hToken: thandle;
                                 dwFlags: DWORD; pszPath: LPTSTR): HRESULT; stdcall;


procedure doinit;
var
 info: osversioninfo;
 libhandle: thandle;
 po1: SHGetFolderPathW;
 buffer: array[0..max_path] of widechar;

begin
 po1:= nil; //compiler warning
 info.dwOSVersionInfoSize:= sizeof(info);
 if getversionex(info) then begin
  iswin95:= info.dwPlatformId = ver_platform_win32_windows;
  if iswin95 then begin
   iswin98:= (info.dwMajorVersion >= 4) or
               (info.dwMajorVersion = 4) and (info.dwminorVersion > 0);
  end;
 end;
 libhandle:= loadlibrary('shell32.dll');
 if libhandle <> 0 then begin
  {$ifdef FPC}pointer(po1){$else}po1{$endif}:= getprocaddress(libhandle,'SHGetFolderPathW');
  if not assigned(po1) then begin
   freelibrary(libhandle);
   libhandle:= loadlibrary('shfolder.dll');
   if libhandle <> 0 then begin
      {$ifdef FPC}pointer(po1){$else}po1{$endif}:= getprocaddress(libhandle,'SHGetFolderPathW');
   end;
  end;
 end;
 if libhandle <> 0 then begin
  if assigned(po1) then begin
   if po1(0,csidl_appdata or CSIDL_FLAG_CREATE,0,0,@buffer) = 0 then begin
    homedir:= filepath(buffer,fk_file);
   end;
  end;
  freelibrary(libhandle);
 end;
end;

initialization
{$ifdef FPC}
 winwidestringalloc:= false;
 {$endif}
 doinit;
//iswin95:= true;
//iswin98:= true;
end.

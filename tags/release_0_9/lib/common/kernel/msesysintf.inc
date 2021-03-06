{ MSEgui Copyright (c) 1999-2006 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}

function sys_getlasterror: integer;
procedure sys_setlasterror(const avalue: integer);
function sys_geterrortext(aerror: integer): string;
function sys_gettimeus: cardinal;
               //systemtime in microseconds, origin undefined

//function sys_towupper(char: widechar): widechar;
//function sys_toupper(char: char): char;

function sys_threadcreate(var info: threadinfoty): syserrorty;
function sys_threadwaitfor(var info: threadinfoty): syserrorty;
function sys_threaddestroy(var info: threadinfoty): syserrorty;
function sys_getcurrentthread: threadty;
function sys_issamethread(const a,b: threadty): boolean;

function sys_mutexcreate(out mutex: mutexty): syserrorty;
function sys_mutexdestroy(var mutex: mutexty): syserrorty;
function sys_mutexlock(var mutex: mutexty): syserrorty;
function sys_mutextrylock(var mutex: mutexty): syserrorty;
  //sye_ok if calling thread has lock, sye_busy if already locked by other thread
function sys_mutexunlock(var mutex: mutexty): syserrorty;

function sys_semcreate(out sem: semty; count: integer): syserrorty;
function sys_semdestroy(var sem: semty): syserrorty;
//function sys_semreset(var sem: semty): syserrorty; //call from single thread!
function sys_sempost(var sem: semty): syserrorty;
function sys_semwait(var sem: semty;  timeoutusec: integer): syserrorty;
          //timeoutusec = 0 -> no timeout
          //sye_ok -> semaphore signaled
          //sye_timeout -> timeout
          //sye_semaphore -> error
function sys_semtrywait(var sem: semty): boolean;
function sys_semcount(var sem: semty): integer;

function sys_condcreate(out cond: condty): syserrorty;
function sys_conddestroy(var cond: condty): syserrorty;
function sys_condlock(var cond: condty): syserrorty;
function sys_condunlock(var cond: condty): syserrorty;
function sys_condsignal(var cond: condty): syserrorty;
function sys_condbroadcast(var cond: condty): syserrorty;
function sys_condwait(var cond: condty; timeoutusec: integer): syserrorty;
          //timeoutusec = 0 -> no timeout
          //sye_ok -> condition signaled
          //sye_timeout -> timeout
          //sye_cond -> error

function sys_getapplicationpath: filenamety;
function sys_getcommandlinearguments: stringarty;

function sys_filesystemiscaseinsensitive: boolean;
function sys_tosysfilepath(var path: widestring): syserrorty;

  //all filenames below are in mseformat!
function sys_getcurrentdir: filenamety;
function sys_gethomedir: filenamety;
function sys_setcurrentdir(const dirname: filenamety): syserrorty;
function sys_copyfile(const oldfile,newfile: widestring): syserrorty;
function sys_renamefile(const oldname,newname: filenamety): syserrorty;
function sys_createdir(const path: widestring;
                  const rights: filerightsty): syserrorty;

function sys_openfile(const path: filenamety; const openmode: fileopenmodety;
          const accessmode: fileaccessmodesty;
          const rights: filerightsty; out handle: integer): syserrorty;
function sys_closefile(const handle: integer): syserrorty;
function sys_read(fd: longint; buf: pointer; nbytes: longword): integer;
function sys_write(fd: longint; buf: pointer; nbytes: longword): integer;
function sys_errorout(const atext: string): syserrorty;

function sys_getfileinfo(const path: filenamety; var info: fileinfoty): boolean;
function sys_opendirstream(var stream: dirstreamty): syserrorty;
function sys_closedirstream(var stream: dirstreamty): syserrorty;
function sys_readdirstream(var stream: dirstreamty; var info: fileinfoty): boolean;
 //true if valid

procedure sys_usleep(const us: cardinal);

function sys_localtimeoffset: tdatetime;
//function sys_getlastsyserror: integer;
function sys_getprintcommand: string;



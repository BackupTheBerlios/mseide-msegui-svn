{ MSEgui Copyright (c) 1999-2006 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit msepipestream;

{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
{$ifndef FPC}{$ifdef linux} {$define UNIX} {$endif}{$endif}

interface

uses
  msestream,msethread,msesys,classes,msebits,mseclasses;

type

 pr_piperesultty = (pr_empty,pr_data,pr_line);

 tpipewriter = class(ttextstream)
  protected
   procedure sethandle(value: integer); override;
  public
   constructor create; reintroduce;
//   destructor destroy; override;

   function releasehandle: integer; virtual;
   property handle: integer read fhandle write sethandle;
    //nimmt handle in besitz
 end;

 tpipereader = class;

 pipereadereventty = procedure(const sender: tpipereader) of object;

 //todo: no thread.kill, single thread for all pipreaders
 bufferty = array[0..defaultbuflen-1] of char;

 tpipereader = class(tpipewriter)
  private
   fpipebuffer: string;
   fdatastatus: pr_piperesultty;
   fthread: tsemthread;         //simulate nonblocking pipes on windows
   fmsbuf: bufferty;
   fmsbufcount: integer;
   foninputavailable: pipereadereventty;
   fonpipebroken: pipereadereventty;
   finputcond: condty;
   fwritehandle: integer;
   foverloadsleepus: integer;
   function execthread(thread: tmsethread): integer;
   function checkdata: pr_piperesultty;
   procedure clearpipebuffer;
   function getresponseflag: boolean;
   procedure setresponseflag(const Value: boolean);
   procedure setwritehandle(const Value: integer);
  protected
   procedure sethandle(value: integer); override;
   procedure setbuflen(const Value: integer); override;
   function readbytes(var buf): integer; override;
   procedure doinputavailable;
  public
   constructor create;
   destructor destroy; override;

   function releasehandle: integer; override;
   function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; override;
                   //no seek, result always 0
   function readdatastring: string; override;
         //bringt alle erhaeltlichen zeichen, keine lineauswertung
   function readuln(out value: string): boolean;
           //bringt auch unvollstaendige zeilen, false wenn unvollstaendig
           //no decoding
   function readstrln(out value: string): boolean; override; 
           //bringt nur vollstaendige zeilen, sonst false
           //no decoding
   procedure clear;
   procedure terminate;
   procedure terminateandwait;
   function waitforresponse(timeoutusec: integer = 0;
                      resetflag: boolean = true): boolean;
             //false if timeout or error
   function active: boolean; //true if handle set and not eof or error
   property responseflag: boolean read getresponseflag write setresponseflag;
   property text: string read fpipebuffer;
   property writehandle: integer read fwritehandle write setwritehandle;
   property overloadsleepus: integer read foverloadsleepus 
                  write foverloadsleepus default -1;
            //checks application.checkoverload before calling oninputavaliable
            //if >= 0
   property oninputavailable: pipereadereventty read foninputavailable 
                         write foninputavailable;
   property onpipebroken: pipereadereventty read fonpipebroken write fonpipebroken;
 end;

 tpipereadercomp = class(tmsecomponent)
  private
   fpipereader: tpipereader;
   function getoninputavailable: pipereadereventty;
   function getonpipebroken: pipereadereventty;
   procedure setoninputavailable(const Value: pipereadereventty);
   procedure setonpipebroken(const Value: pipereadereventty);
   function getoverloadsleepus: integer;
   procedure setoverloadsleepus(const avalue: integer);
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   property pipereader: tpipereader read fpipereader;
  published
   property overloadsleepus: integer read getoverloadsleepus 
                  write setoverloadsleepus default -1;
            //checks application.checkoverload before calling oninputavaliable
            //if >= 0
   property oninputavailable: pipereadereventty read getoninputavailable write setoninputavailable;
   property onpipebroken: pipereadereventty read getonpipebroken write setonpipebroken;
 end;

implementation
uses
  {$ifdef UNIX}libc, {$else}windows, {$endif}
 msegui,msesysintf,sysutils,msesysutils;

{ tpipewriter }

constructor tpipewriter.create;
begin
 inherited create(invalidfilehandle);
end;
{
destructor tpipewriter.destroy;
begin
 sethandle(invalidfilehandle);
 inherited;
end;
}
function tpipewriter.releasehandle: integer;
begin
 result:= handle;
{$ifdef FPC}
 thandlestreamcracker(self).fhandle:= invalidfilehandle;
{$else}
 fhandle:= invalidfilehandle;
{$endif}
end;

procedure tpipewriter.sethandle(value: integer);
begin
 inherited;
 bufoffset:= nil;
end;

{ tpipereader }

constructor tpipereader.create;
begin
 sys_condcreate(finputcond);
 fwritehandle:= invalidfilehandle;
 foverloadsleepus:= -1;
 inherited;
end;

destructor tpipereader.destroy;
begin
 terminateandwait;
 writehandle:= invalidfilehandle;
 inherited;
 sys_conddestroy(finputcond);
end;

function tpipereader.releasehandle: integer;
begin
 terminateandwait;
 freeandnil(fthread);
 writehandle:= invalidfilehandle;
 result:= inherited releasehandle;
end;

procedure tpipereader.sethandle(value: integer);
begin
 if handle <> invalidfilehandle then begin
  terminateandwait;
 end;
 freeandnil(fthread);
 inherited;
 if value <> invalidfilehandle then begin
  writehandle:= invalidfilehandle;
  fstate:= fstate - [tss_eof,tss_error,tss_pipeactive];
  fmsbufcount:= 0;
  fthread:= tsemthread.create({$ifdef FPC}@{$endif}execthread);
 end;
end;

procedure tpipereader.setwritehandle(const Value: integer);
begin
 if fwritehandle <> invalidfilehandle then begin
  sys_closefile(fwritehandle);
 end;
 fwritehandle := Value;
end;

procedure tpipereader.terminate;
var
 by1: byte;
begin
 if fthread <> nil then begin
  fthread.terminate;
  if fthread.running then begin
   fthread.sempost;
   if fwritehandle <> invalidfilehandle then begin
    by1:= 0;
    sys_write(fwritehandle,@by1,1); //wake up thread
   end
   else begin
    {$ifdef linux}
    pthread_kill(fthread.id,sigio);
    {$else}
    inherited sethandle(invalidfilehandle);
    {$endif}
   end;
   writehandle:= invalidfilehandle;
  end;
 end;
end;

procedure tpipereader.terminateandwait;
begin
 if fthread <> nil then begin
  terminate;
  application.waitforthread(fthread);
 end;
end;

procedure tpipereader.setbuflen(const Value: integer);
begin
 if value < defaultbuflen then begin
  inherited setbuflen(defaultbuflen);
 end
 else begin
  inherited;
 end;
end;

function tpipereader.readbytes(var buf): integer;
 
 procedure getmorebytes;
 var
  int1: integer;
 begin
  {$ifdef mswindows}
  if peeknamedpipe(handle,nil,0,nil,@int1,nil) and (int1 > 0) then begin
   if int1 > defaultbuflen then begin
    int1:= defaultbuflen;
   end;
   int1:= fileRead(Handle,fmsBuf,int1);
   if (int1 < 0) then begin
    fmsbufcount:= 0;
    fstate:= fstate + [tss_error,tss_eof];
   end
   else begin
    fmsbufcount:= int1;
   end;
  end
  else begin
   fmsbufcount:= 0;
  end;
  {$else}
  setfilenonblock(handle,true);
  int1:= sys_read(Handle,@fmsBuf,defaultbuflen);
  setfilenonblock(handle,false);
  if int1 <= 0 then begin
   fmsbufcount:= 0;
   if sys_getlasterror <> EAGAIN then begin
    fstate:= fstate + [tss_error,tss_eof]; //broken pipe
   end
  end
  else begin
   fmsbufcount:= int1;
  end;
  {$endif}
  if fmsbufcount = 0 then begin
   exclude(fstate,tss_pipeactive);
   fthread.sempost;
  end;
 end;
 
begin
 result:= fmsbufcount;
 if result > 0 then begin
  move(fmsbuf,buf,fmsbufcount);
  getmorebytes;
 end
 else begin
  if sys_getcurrentthread = fthread.id then begin //check again fore more
   include(fstate,tss_pipeactive);
   if fthread.semcount > 0 then begin
    fthread.semwait; //reset semaphore
   end;
   getmorebytes;
   result:= fmsbufcount;
   if result > 0 then begin
    move(fmsbuf,buf,fmsbufcount);
    getmorebytes;
   end;
  end;
  if tss_error in fstate then begin
   include(fstate,tss_eof);
  end;
 end;
end;

function tpipereader.execthread(thread: tmsethread): integer;
var
 int1: integer;
 {$ifdef linux}
 fdsetr,fdsete: tfdset;
 {$endif}
begin                          
 fthread:= tsemthread(thread);
 {$ifdef linux}
 fd_zero(fdsetr);
 fd_zero(fdsete);
 {$endif}
 with fthread do begin
  while not terminated and not (tss_error in fstate) do begin
  {$ifdef linux}
   fd_set(handle,fdsetr);
   fd_set(handle,fdsete);
   if select(fd_setsize,@fdsetr,nil,@fdsete,nil) > 0 then begin
  {$else}
   if true then begin
  {$endif}
    int1:= sys_read(Handle,@fmsBuf, buflen);
    if not terminated then begin
     if {$ifdef mswindows}int1 < 0{$else}(int1 <= 0){$endif} then begin
                      //on win32 int1 can be 0
      include(fstate,tss_error); //broken pipe
     end
     else begin
      fmsbufcount:= int1;
     end;
     if (int1 > 0) or (tss_error in fstate) then begin
      include(fstate,tss_pipeactive);
      doinputavailable;
      if not terminated and not (tss_error in fstate) then begin
       semwait;
      end;
     end;
    end;
   end;
  end;
  include(fstate,tss_eof);
 end;
 result:= 0;
end;

function tpipereader.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
begin
 result:= 0;
end;

procedure tpipereader.doinputavailable;
begin
 if assigned(foninputavailable) or assigned(fonpipebroken) then begin
  if foverloadsleepus >= 0 then begin
   while not fthread.terminated and application.checkoverload(-1) do begin
    sleepus(foverloadsleepus);
   end;
  end;
  application.lock;
  try
   if assigned(foninputavailable) then begin
    foninputavailable(self);
   end;
   if eof and assigned(fonpipebroken) then begin
    fonpipebroken(self);
   end;
  finally
   application.unlock;
  end;
 end;
 sys_condlock(finputcond);
 include(fstate,tss_response);
 sys_condbroadcast(finputcond);
 sys_condunlock(finputcond);
end;

procedure tpipereader.clearpipebuffer;
begin
 fpipebuffer:= '';
 fdatastatus:= pr_empty;
end;

function tpipereader.readdatastring: string;
var
 int1,int2: integer;
begin
 result:= '';
 if bufoffset <> nil then begin
  int1:= bufend-bufoffset;
  setlength(result,int1);
  move(bufoffset^,result[1],int1);
  bufoffset:= nil;
 end;
 while true do begin
  int1:= readbytes(fbuffer^);
  if int1 > 0 then begin
   int2:= length(result);
   setlength(result,int1+int2);
   move(fbuffer^,result[int2+1],int1);
  end
  else begin
   break;
  end;
 end;
end;

function tpipereader.checkdata: pr_piperesultty;
var
 str1: string;
 bo1: boolean;
begin
 if (tss_pipeactive in fstate) or (bufend <> bufoffset) then begin
  bo1:= inherited readstrln(str1);
  fpipebuffer:= fpipebuffer + str1;
  if bo1 then begin
   fdatastatus:= pr_line;
  end
  else begin
   if str1 <> '' then begin
    fdatastatus:= pr_data;
   end;
   if not (tss_error in fstate) then begin
    exclude(fstate,tss_eof);
   end;
   bufoffset:= nil; //neu laden
  end;
  result:= fdatastatus;
 end
 else begin
  result:= pr_empty;
 end;
end;

function tpipereader.readuln(out value: string): boolean;
begin
 value:= '';
 result:= false;
// if (tss_pipeactive in fstate) or (fdatastatus <> pr_empty) then begin
  repeat
   if fdatastatus = pr_empty then begin
    checkdata;
   end;
   value:= value + fpipebuffer;
   result:= fdatastatus = pr_line;
   clearpipebuffer;
   checkdata;
  until result or (fdatastatus = pr_empty);
// end;
end;

function tpipereader.readstrln(out value: string): boolean;
begin
 case checkdata of
  pr_line: begin
   result:= true;
   value:= fpipebuffer;
   clearpipebuffer;
  end;
  else begin
   result:= false;
   value:= '';
  end;
 end;
end;

procedure tpipereader.clear;
begin
 clearpipebuffer;
 bufoffset:= nil;
end;

function tpipereader.waitforresponse(timeoutusec: integer = 0; resetflag: boolean = true): boolean;
             //false if timeout or error
begin
 sys_condlock(finputcond);
 result:= responseflag;
 if not result then begin
  if not eof then begin
   result:= sys_condwait(finputcond,timeoutusec) = sye_ok;
  end;
 end;
 if result and resetflag then begin
  responseflag:= false;
 end;
 sys_condunlock(finputcond);
end;

function tpipereader.getresponseflag: boolean;
begin
 result:= tss_response in fstate;
end;

procedure tpipereader.setresponseflag(const Value: boolean);
begin
 updatebit({$ifdef FPC}longword{$else}byte{$endif}(fstate),ord(tss_response),value);
end;

function tpipereader.active: boolean;
begin
 result:= (handle <> invalidfilehandle) and (fstate * [tss_error,tss_eof] = []);
end;

{ tpipereadercomp }

constructor tpipereadercomp.create(aowner: tcomponent);
begin
 fpipereader:= tpipereader.create;
 inherited;
end;

destructor tpipereadercomp.destroy;
begin
 fpipereader.free;
 inherited;
end;

function tpipereadercomp.getoninputavailable: pipereadereventty;
begin
 result:= fpipereader.foninputavailable;
end;

function tpipereadercomp.getonpipebroken: pipereadereventty;
begin
 result:= fpipereader.fonpipebroken;
end;

procedure tpipereadercomp.setoninputavailable(
  const Value: pipereadereventty);
begin
 fpipereader.foninputavailable:= value;
end;

procedure tpipereadercomp.setonpipebroken(const Value: pipereadereventty);
begin
 fpipereader.fonpipebroken:= value;
end;

function tpipereadercomp.getoverloadsleepus: integer;
begin
 result:= fpipereader.overloadsleepus;
end;

procedure tpipereadercomp.setoverloadsleepus(const avalue: integer);
begin
 fpipereader.overloadsleepus:= avalue;
end;

{$ifdef UNIX}
var
 sigpipebefore: tsignalhandler;
initialization
  sigpipebefore:= signal(sigpipe,tsignalhandler(sig_ign));
finalization
 signal(sigpipe,sigpipebefore);
{$endif}
end.


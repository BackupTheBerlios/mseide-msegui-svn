{ MSEgui Copyright (c) 1999-2006 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit msetimer;

{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface
uses
 Classes,msetypes,mseevent,mseguiglob,mseclasses;

type
 tsimpletimer = class(tnullinterfacedobject)
  private
   fenabled: boolean;
   finterval: integer;
   fontimer: notifyeventty;
   procedure setenabled(const Value: boolean);
   procedure setinterval(const Value: integer);
  protected
   procedure dotimer;
  public
   constructor create(interval: integer; ontimer: notifyeventty; active: boolean);
             //activates timer
   destructor destroy; override;
   property interval: integer read finterval write setinterval;
             //in microseconds, <= 0 -> single shot, max +-2000 seconds
             //restarts timer if active
   property ontimer: notifyeventty read fontimer write fontimer;
   property enabled: boolean read fenabled write setenabled default true;
             //last!
 end;

 ttimer = class(tmsecomponent)
  private
   ftimer: tsimpletimer;
   fenabled: boolean; //for design
   function getenabled: boolean;
   procedure setenabled(const Value: boolean);
   function getinterval: integer;
   procedure setinterval(const Value: integer);
   function getontimer: notifyeventty;
   procedure setontimer(const Value: notifyeventty);
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
  published
   property interval: integer read getinterval write setinterval default 1000000;
             //in microseconds, <= 0 -> single shot, max +-2000 seconds
             //restarts timer if enabled
   property ontimer: notifyeventty read getontimer write setontimer;
   property enabled: boolean read getenabled write setenabled default false;
             //last!
 end;

procedure tick(sender: tobject);
procedure init;
procedure deinit;

implementation
uses
 msesysintf,mseguiintf,SysUtils,msegui,msesys,msesysutils;

type
 ptimerinfoty = ^timerinfoty;
 timerinfoty = record
  nexttime: cardinal;
  interval: cardinal;
  prevpo,nextpo: ptimerinfoty;
  ontimer: objectprocty;
 end;
 
var
 first: ptimerinfoty;
 mutex: mutexty;
 rewaked: boolean;

procedure extract(po: ptimerinfoty);
          //mutex has to be locked
begin
 if first = po then begin
  first:= po^.nextpo;
  if first <> nil then begin
   first^.prevpo:= nil;
  end;
 end;
 if po^.prevpo <> nil then begin
  po^.prevpo^.nextpo:= po^.nextpo;
 end;
 if po^.nextpo <> nil then begin
  po^.nextpo^.prevpo:= po^.prevpo;
 end;
end;

procedure insert(po: ptimerinfoty); //mutex has to be locked
var
 po1,po2: ptimerinfoty;
 ca1: cardinal;
begin
 ca1:= po^.nexttime;
 po2:= po;
 po1:= po^.nextpo;
 if po1 = nil then begin
  po1:= first;
 end;
// while (po1 <> nil) and (integer(po1^.nexttime-ca1) < 0) do begin //todo!!!!!: FPC bug 4768
 while (po1 <> nil) and later(po1^.nexttime,ca1) do begin
  po2:= po1;
  po1:= po1^.nextpo;
 end;
 if po1 = nil then begin //last
  if po2 = po then begin //single
   po^.prevpo:= nil;
   first:= po;
  end
  else begin //last
   po^.prevpo:= po2;
   po2^.nextpo:= po;
  end;
  po^.nextpo:= nil;
 end
 else begin
  if po1^.prevpo = nil then begin //first
   po^.prevpo:= nil;
   po1^.prevpo:= po;
   first:= po;
   po^.nextpo:= po1;
  end
  else begin
   po^.prevpo:= po1^.prevpo;
   po^.prevpo^.nextpo:= po;
   po1^.prevpo:= po;
   po^.nextpo:= po1;
  end;
 end;
end;

procedure killtimertick(aontimer: objectprocty);
var
 po1: ptimerinfoty;
begin
 sys_mutexlock(mutex);
 po1:= first;
 while po1 <> nil do begin
  if issamemethod(tmethod(po1^.ontimer),tmethod(aontimer)) then begin
   po1^.ontimer:= nil;
  end;
  po1:= po1^.nextpo;
 end;
 sys_mutexunlock(mutex);
end;

procedure starttimer(const reftime: cardinal);
var
 int1: integer;
begin
 int1:= first^.nexttime-reftime;
 if int1 < 1000 then begin
//writeln('post');
//flush(output);
  application.postevent(tevent.create(ek_timer));
 end
 else begin
  gui_settimer(int1);
 end;
end;

procedure settimertick(ainterval: integer; aontimer: objectprocty);
var
 po: ptimerinfoty;
 time: cardinal;
begin
//writeln('set ',ainterval);
//flush(output);
 new(po);
 sys_mutexlock(mutex);
 time:= sys_gettimeus;
 fillchar(po^,sizeof(timerinfoty),0);
 with po^ do begin
  if ainterval < 0 then begin
   nexttime:= time + cardinal(-ainterval);
   interval:= 0;
  end
  else begin
   nexttime:= time + cardinal(ainterval);
   interval:= ainterval;
  end;
  ontimer:= aontimer;
 end;
 insert(po);
 if first = po then begin
  starttimer(time);
 end
 else begin
//  if (integer(first^.nexttime - time) < 0) and not rewaked then begin//todo!!!!!: FPC bug 4768
  if later(first^.nexttime,time) {and not rewaked} then begin
   rewaked:= true;
   application.postevent(tevent.create(ek_timer)); //timerevent is ev. lost
  end;
 end;
 sys_mutexunlock(mutex);
end;

procedure tick(sender: tobject);
var
 time: cardinal;
 po,po2: ptimerinfoty;
 ontimer: objectprocty;
begin
 sys_mutexlock(mutex);
 rewaked:= false;
 if first <> nil then begin
  time:= sys_gettimeus;
  po:= first;
//  while (po <> nil) and (integer(po^.nexttime - time) < 0) do begin//todo!!!!!: FPC bug 4768
  while (po <> nil) and laterorsame(po^.nexttime,time) do begin
   extract(po);
   ontimer:= po^.ontimer;
   po2:= po^.nextpo;
   if (po^.interval = 0) or not assigned(ontimer) then begin
                  //single shot or killed, remove item
    dispose(po);
   end
   else begin
    repeat
     inc(po^.nexttime,po^.interval)
//    until integer(po^.nexttime-time) > 0;//todo!!!!!: FPC bug 4768
    until later(time,po^.nexttime);
    insert(po);
   end;
   if assigned(ontimer) then begin
    try
     ontimer;
    except
     application.handleexception(sender);
    end;
   end;
   po:= po2;
  end;
  if first <> nil then begin
   starttimer(time);
  end;
 end;
 sys_mutexunlock(mutex);
end;

procedure init;
begin
 sys_mutexcreate(mutex);
end;

procedure deinit;
var
 po1,po2: ptimerinfoty;
begin
 sys_mutexlock(mutex);
 po1:= first;
 while po1 <> nil do begin
  po2:= po1;
  po1:= po1^.nextpo;
  dispose(po2);
 end;
 first:= nil;
 sys_mutexunlock(mutex);
 sys_mutexdestroy(mutex);
end;

{ tsimpletimer }

constructor tsimpletimer.create(interval: integer; ontimer: notifyeventty;
                active: boolean);
begin
 finterval:= interval;
 fontimer:= ontimer;
 setenabled(active);
end;

destructor tsimpletimer.destroy;
begin
 enabled:= false;
 inherited;
end;

procedure tsimpletimer.dotimer;
begin
 if finterval <= 0 then begin
  fenabled:= false;
 end;
 if assigned(fontimer) then begin
  fontimer(self);
 end;
end;

procedure tsimpletimer.setenabled(const Value: boolean);
begin
 if fenabled <> value then begin
  sys_mutexlock(mutex);
  fenabled := Value;
  if not value then begin
   killtimertick({$ifdef FPC}@{$endif}dotimer);
  end
  else begin
   settimertick(finterval,{$ifdef FPC}@{$endif}dotimer);
  end;
  sys_mutexunlock(mutex);
 end;
end;

procedure tsimpletimer.setinterval(const Value: integer);
begin
 if (value > 2000000000) or (value < -2000000000) then begin
  raise exception.create('Invalid timer interval ' + inttostr(value));
 end;
 finterval:= Value;
 if fenabled then begin
  sys_mutexlock(mutex);
  killtimertick({$ifdef FPC}@{$endif}dotimer);
  settimertick(finterval,{$ifdef FPC}@{$endif}dotimer);
  sys_mutexunlock(mutex);
 end;
end;

{ ttimer }

constructor ttimer.create(aowner: tcomponent);
begin
 ftimer:= tsimpletimer.create(1000000,nil,false);
 inherited;
end;

destructor ttimer.destroy;
begin
 ftimer.Free;
 inherited;
end;

function ttimer.getenabled: boolean;
begin
 if csdesigning in componentstate then begin
  result:= fenabled;
 end
 else begin
  result:= ftimer.enabled;
 end;
end;

procedure ttimer.setenabled(const Value: boolean);
begin
 if csdesigning in componentstate then begin
  fenabled:= value;
 end
 else begin
  ftimer.enabled:= value;
 end;
end;

function ttimer.getinterval: integer;
begin
 result:= ftimer.interval;
end;

procedure ttimer.setinterval(const Value: integer);
begin
 ftimer.interval:= value;
end;

function ttimer.getontimer: notifyeventty;
begin
 result:= ftimer.ontimer;
end;

procedure ttimer.setontimer(const Value: notifyeventty);
begin
 ftimer.ontimer:= value;
end;

end.

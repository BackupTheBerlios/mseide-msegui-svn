{ MSEgui Copyright (c) 1999-2007 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit msedatamodules;

{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface
uses
 classes,mseclasses,msetypes,msegraphutils,msestatfile,mseevent,mseapplication;
 
type
 datamoduleoptionty = (dmo_autoreadstat,dmo_autowritestat);
 datamoduleoptionsty = set of datamoduleoptionty;
const
 defaultdatamoduleoptions = [dmo_autoreadstat,dmo_autowritestat];
 
type
 tmsedatamodule = class(tactcomponent)
  private
   fsize: sizety;
   foncreate: notifyeventty;
   fondestroy: notifyeventty;
   fondestroyed: notifyeventty;
   foptions: datamoduleoptionsty;
   fstatfile: tstatfile;
   fonloaded: notifyeventty;
   fonasyncevent: asynceventeventty;
   foneventloopstart: notifyeventty;
   fonevent: eventeventty;
   fonterminatequery: terminatequeryeventty;
   fonterminated: notifyeventty;
   procedure writesize(writer: twriter);
   procedure readsize(reader: treader);
   procedure setstatfile(const avalue: tstatfile);
  protected
   procedure doterminated(const sender: tobject);
   procedure doterminatequery(var terminate: boolean);
   procedure getchildren(proc: tgetchildproc; root: tcomponent); override;
   class function getmoduleclassname: string; override;
   class function hasresource: boolean; override;
   procedure defineproperties(filer: tfiler); override;
   procedure doonloaded; virtual;
   procedure loaded; override;
   procedure doasyncevent(var atag: integer); override;
   procedure doeventloopstart; virtual;
   procedure receiveevent(const event: tobjectevent); override;
  public
   constructor create(aowner: tcomponent); overload; override;
   constructor create(aowner: tcomponent; load: boolean); reintroduce; overload;
   destructor destroy; override;
   procedure beforedestruction; override;
   property size: sizety read fsize write fsize;
  published
   property options: datamoduleoptionsty read foptions write foptions 
                           default defaultdatamoduleoptions;
   property statfile: tstatfile read fstatfile write setstatfile;
   property oncreate: notifyeventty read foncreate write foncreate;
   property onloaded: notifyeventty read fonloaded write fonloaded;
   property oneventloopstart: notifyeventty read foneventloopstart 
                                   write foneventloopstart;
   property ondestroy: notifyeventty read fondestroy write fondestroy;
   property ondestroyed: notifyeventty read fondestroyed write fondestroyed;
   property onevent: eventeventty read fonevent write fonevent;
   property onasyncevent: asynceventeventty read fonasyncevent write fonasyncevent;
   property onterminatequery: terminatequeryeventty read fonterminatequery 
                 write fonterminatequery;
   property onterminated: notifyeventty read fonterminated 
                 write fonterminated;
 end;
 datamoduleclassty = class of tmsedatamodule;
 
function createmsedatamodule(const aclass: tclass;
                     const aclassname: pshortstring): tmsecomponent;
implementation
 
type
 tmsecomponent1 = class(tmsecomponent);
  
function createmsedatamodule(const aclass: tclass;
                     const aclassname: pshortstring): tmsecomponent;
begin
 result:= datamoduleclassty(aclass).create(nil,false);
 tmsecomponent1(result).factualclassname:= aclassname;
end;

{ tmsedatamodule }

constructor tmsedatamodule.create(aowner: tcomponent);
begin
 create(aowner,not (cs_noload in fmsecomponentstate));
end;

constructor tmsedatamodule.create(aowner: tcomponent; load: boolean);
begin
 foptions:= defaultdatamoduleoptions;
 include(fmsecomponentstate,cs_ismodule);
 designinfo:= 100+(100 shl 16);
 inherited create(aowner);
 application.registeronterminated({$ifdef FPC}@{$endif}doterminated);
 application.registeronterminate({$ifdef FPC}@{$endif}doterminatequery);
 if load and not (csdesigning in componentstate) then begin
  loadmsemodule(self,tmsedatamodule);
  if (fstatfile <> nil) and (dmo_autoreadstat in foptions) then begin
   fstatfile.readstat;
  end;
  doonloaded;
 end;
end;

destructor tmsedatamodule.destroy;
var
 bo1: boolean;
begin
 application.unregisteronterminated({$ifdef FPC}@{$endif}doterminated);
 application.unregisteronterminate({$ifdef FPC}@{$endif}doterminatequery);
 bo1:= csdesigning in componentstate;
 inherited; //csdesigningflag is removed
 if not bo1 and candestroyevent(tmethod(fondestroyed)) then begin
  fondestroyed(self);
 end;
end;

procedure tmsedatamodule.doonloaded;
begin
 if canevent(tmethod(fonloaded)) then begin
  fonloaded(self);
 end;
end;

procedure tmsedatamodule.beforedestruction;
begin
 if (fstatfile <> nil) and (dmo_autowritestat in foptions) and
                 not (csdesigning in componentstate) then begin
  fstatfile.writestat;
 end;
 inherited;
 if candestroyevent(tmethod(fondestroy)) then begin
  fondestroy(self);
 end;
end;

procedure tmsedatamodule.getchildren(proc: tgetchildproc;
  root: tcomponent);
var
 int1: integer;
 component: tcomponent;
begin
 if root = self then begin
  for int1 := 0 to componentcount - 1 do begin
   component := components[int1];
   if not component.hasparent then begin
    proc(component);
   end;
  end;
 end;
end;

class function tmsedatamodule.getmoduleclassname: string;
begin
// result:= tmsedatamodule.ClassName;
 //bug in dcc32: tmsedatamodule is replaced by self
 result:= 'tmsedatamodule';
end;

class function tmsedatamodule.hasresource: boolean;
begin
 result:= self <> tmsedatamodule;
end;

procedure tmsedatamodule.writesize(writer: twriter);
begin
 with writer do begin
  writelistbegin;
  writeinteger(fsize.cx);
  writeinteger(fsize.cy);
  writelistend;
 end;
end;

procedure tmsedatamodule.readsize(reader: treader);
begin
 with reader do begin
  readlistbegin;
  fsize.cx:= readinteger;
  fsize.cy:= readinteger;
  readlistend;
 end;
end;

procedure tmsedatamodule.defineproperties(filer: tfiler);
begin
 inherited;
 filer.defineproperty('size',{$ifdef FPC}@{$endif}readsize,
                       {$ifdef FPC}@{$endif}writesize, true);  
end;

procedure tmsedatamodule.loaded;
begin
 inherited;
 application.postevent(tobjectevent.create(ek_loaded,ievent(self)));
 if canevent(tmethod(foncreate)) then begin
  foncreate(self);
 end;
end;

procedure tmsedatamodule.setstatfile(const avalue: tstatfile);
begin
 setlinkedvar(avalue,tmsecomponent(fstatfile));
end;

procedure tmsedatamodule.doasyncevent(var atag: integer);
begin
 if canevent(tmethod(fonasyncevent)) then begin
  fonasyncevent(self,atag);
 end;
 inherited;
end;

procedure tmsedatamodule.doeventloopstart;
begin
 if canevent(tmethod(foneventloopstart)) then begin
  foneventloopstart(self);
 end;
end;

procedure tmsedatamodule.receiveevent(const event: tobjectevent);
begin
 if canevent(tmethod(fonevent)) then begin
  fonevent(self,event);
 end;
 inherited;
 if event.kind = ek_loaded then begin
  doeventloopstart;
 end;
end;

procedure tmsedatamodule.doterminated(const sender: tobject);
begin
 if canevent(tmethod(fonterminated)) then begin
  fonterminated(sender);
 end;
end;

procedure tmsedatamodule.doterminatequery(var terminate: boolean);
begin
 if canevent(tmethod(fonterminatequery)) then begin
  fonterminatequery(terminate);
 end;
end;

end.

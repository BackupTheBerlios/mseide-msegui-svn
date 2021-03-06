{ MSEide Copyright (c) 1999-2006 by Martin Schreiber
   
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
}
unit msedesigner;

{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface
uses
 classes,msegraphutils,mseguiglob,msedesignintf,
 mseforms,mselist,msedatalist,msebitmap,msetypes,sysutils,msehash,mseclasses,
 mseformdatatools,typinfo,msepropertyeditors,msecomponenteditors,msegraphics,
 msegui,msestrings;

const
 formfileext = 'mfm';
 pasfileext = 'pas';
 backupext = '.bak';

type
 tdesigner = class;

 methodinfoty = record
  name: string;
  address: pointer;
  typeinfo: ptypeinfo;
 end;
 pmethodinfoty = ^methodinfoty;

 tmethods = class(tbucketlist)
  private
   fdesigner: tdesigner;
   {fapropname,fapropvalue: string;}
   fmethodtable: pointer;
  protected
   procedure freedata(var data); override;
   procedure deletemethod(const aadress: pointer);
   procedure addmethod(const aname: string; const aaddress: pointer;
                       const atypeinfo: ptypeinfo);
   function findmethod(const aadress: pointer): pmethodinfoty;
   function findmethodbyname(const aname: string;
         const atype: ptypeinfo; out namefound: boolean): pmethodinfoty; overload;
   function findmethodbyname(const aname: string): pmethodinfoty; overload;
  public
   constructor create(adesigner: tdesigner);
   destructor destroy; override;
   function createmethodtable: pointer;
   procedure releasemethodtable;
 end;

 tcomponents = class;

 tcomponentslink = class(tcomponent)
  private
   fowner: tcomponents;
  protected
   procedure notification(acomponent: tcomponent; operation: toperation); override;
 end;

 componentnamety = record
  instance: tcomponent;
  dispname: string;
 end;
 componentnamearty = array of componentnamety;

 moduleinfoty = record
  filename: msestring;
  backupcreated: boolean;
  moduleclassname: string[80]; //can not be ansistring!
  instancevarname: string;
  instance: tmsecomponent;
  methods: tmethods;
  components: tcomponents;
  designform: tmseform;
  modified: boolean;
  referencedmodules: stringarty;
  methodtablebefore: pointer;
 end;
 pmoduleinfoty = ^moduleinfoty;
 moduleinfopoarty = array of pmoduleinfoty;
 
 tcomponents = class(tbucketlist)
  private
   fdesigner: tdesigner;
   fcomponent: tcomponentslink; // to receive componentnotifications
   famodule: tcomponent;
   fowner: pmoduleinfoty;
   procedure doadd(component: tcomponent);
  protected
   procedure freedata(var data); override;
   function find(const value: tobject): pcomponentinfoty;
   procedure destroynotification(const acomponent: tcomponent);
   procedure swapcomponent(const old,new: tcomponent);
  public
   constructor create(const aowner: pmoduleinfoty; const adesigner: tdesigner);
   destructor destroy; override;
   procedure assigncomps(const module: tmsecomponent);
   procedure add(comp: tcomponent);
   function next: pcomponentinfoty;
   function getcomponents: componentarty;
   function getdispnames: componentnamearty;
   function getcomponent(const aname: string): tcomponent;
   procedure namechanged(const acomponent: tcomponent; const newname: string);
 end;

 tmoduleinfo = class(tlinkedobject)
  protected
   fdesigner: tdesigner;
  public
   info: moduleinfoty;
   constructor create(adesigner: tdesigner);
   destructor destroy; override;
 end;

 pmoduleinfo = ^tmoduleinfo;

 tmodulelist = class(tlinkedobjectqueue)
  private
   fdesigner: tdesigner;
   function getitempo1(const index: integer): pmoduleinfoty;
  protected
   function newmodule(const afilename: msestring;
                const amoduleclassname,ainstancevarname,
                     designmoduleclassname: string): pmoduleinfoty;
   function findmethodbyname(const name: string; const atype: ptypeinfo;
                               const amodule: tmsecomponent): tmethod;
   function findmethodname(const method: tmethod; const comp: tcomponent): string;
   function findform(aform: tmseform): pmoduleinfoty;
   function removemoduleinfo(po: pmoduleinfoty): integer;
   procedure componentmodified(const acomponent: tobject);

  public
   constructor create(adesigner: tdesigner); reintroduce;
   function delete(index: integer): pointer; override;
   function findmodule(const filename: msestring): pmoduleinfoty; overload;
   function findmodule(const amodule: tmsecomponent): pmoduleinfoty; overload;
   function findmodule(const po: pmoduleinfoty): integer;  overload;
   function findmodulebyname(const name: string): pmoduleinfoty;
   function findmoduleinstancebyname(const name: string): tcomponent;
   function findmoduleinstancebyclass(const aclass: tclass): tcomponent;
   function findmodulebycomponent(const acomponent: tobject): pmoduleinfoty;
   function findmodulebyinstance(const ainstance: tcomponent): pmoduleinfoty;
   function filenames: filenamearty;

   property itempo[const index: integer]: pmoduleinfoty read getitempo1; default;
 end;

 tdesignformlist = class(tcomponentqueue)
  private
   function getitems(const index: integer): tmseform;//tformdesignerfo;
  public
   property items[const index: integer]: tmseform read getitems; default;
 end;

 ancestorinfoty = record
  descendent,ancestor: tmsecomponent
 end;
 pancestorinfoty = ^ancestorinfoty;

 tancestorlist = class(tobjectlinkrecordlist)
  private
  protected
   procedure dounlink(var item); override;
   procedure itemdestroyed(const sender: iobjectlink); override;
  public
   constructor create;
   function findancestor(const adescendent: tcomponent): tmsecomponent;
   function finddescendent(const aancestor: tcomponent): tmsecomponent;
   function finddescendentinfo(const adescendent: tcomponent): pancestorinfoty;
   function findancestorinfo(const aancestor: tcomponent): pancestorinfoty;
   procedure add(const adescendent,aancestor: tmsecomponent);
 end;

 tdesignerancestorlist = class(tancestorlist)
  private
   fdesigner: tdesigner;
  public
   constructor create(aowner: tdesigner);
 end;

 tsubmodulelist = class(tdesignerancestorlist)
       //ancestor is copy of old state of descendent,
       //descendent is real submodule
  protected
   procedure finalizerecord(var item); override;
  public
   procedure add(const amodule: tmsecomponent);
   procedure renewbackup(const amodule: tmsecomponent);
 end;

 treaderrorhandler = class(tcomponent)
  private
   fcomponentar: componentarty;
   fnewcomponents: componentarty;
   froot: tcomponent;
   procedure doraise(const acomponent: tcomponent);
   procedure ancestornotfound(Reader: TReader; const ComponentName: string;
                   ComponentClass: TPersistentClass; var Component: TComponent);
   procedure onsetname(reader: treader; component: tcomponent; var aname: string);
   procedure onerror(reader: treader; const message: string; var handled: boolean);
  protected
   procedure notification(acomponent: tcomponent; operation: toperation);
                               override;        
  public
   destructor destroy; override;   
 end;
 
 tdescendentinstancelist = class(tdesignerancestorlist)
  private
   ferrorhandler: treaderrorhandler;
   fdelcomps:componentarty;
   froot: tcomponent;
   fmodule: pmoduleinfoty;
   procedure delcomp(child: tcomponent);
   procedure addcomp(child: tcomponent);
  protected
   procedure modulemodified(const amodule: pmoduleinfoty);
   procedure revert(const info: pancestorinfoty; const module: pmoduleinfoty);
  public
   procedure add(const instance,ancestor: tmsecomponent; const submodulelist: tsubmodulelist);
   function getclassname(const comp: tcomponent): string;
                   //returns submodule or root classname if appropriate
 end;

 getmoduleeventty = procedure(const amodule: pmoduleinfoty;
                             const aname: string; var action: modalresultty) of object;
                                      //mr_ignore,mr_ok, cancel otherwise
 getmoduletypeeventty = procedure(const atypename: string) of object;

 tdesigner = class(tguicomponent,idesigner)
  private
   fselections: tdesignerselections;
   factmodulepo: pmoduleinfoty;
   floadingmodulepo: pmoduleinfoty;
   fmodules: tmodulelist;
   fcomponenteditor: tcomponenteditor;
   fobjformat: objformatty;
   fsubmoduleinfopo: pmoduleinfoty;
   fsubmodulelist: tsubmodulelist;
   fdescendentinstancelist: tdescendentinstancelist;
   fdesignfiles: tmseindexednamelist;
   fongetmodulenamefile: getmoduleeventty;
   fongetmoduletypefile: getmoduletypeeventty;
   fnotifymodule: tmsecomponent;
   fcomponentmodifying: integer;
   floadedsubmodules: componentarty;
   fformloadlevel: integer;
   flookupmodule: pmoduleinfoty;
   fnotifydeletedlock: integer;
   function formfiletoname(const filename: msestring): msestring;
   procedure findmethod(Reader: TReader; const aMethodName: string;
                   var Address: Pointer; var Error: Boolean);
   procedure findmethod2(Reader: TReader; const aMethodName: string;
                   var Address: Pointer; var Error: Boolean);
   procedure findcomponentclass(Reader: TReader; const aClassName: string;
                   var ComponentClass: TComponentClass);
   procedure ancestornotfound(Reader: TReader; const ComponentName: string;
                   ComponentClass: TPersistentClass; var Component: TComponent);
   procedure createcomponent(Reader: TReader; ComponentClass: TComponentClass;
                   var Component: TComponent);
   procedure findancestor(Writer: TWriter; Component: TComponent;
              const aName: string; var Ancestor, RootAncestor: TComponent);
   function findcomponentmodule(const acomponent: tcomponent): pmoduleinfoty;
   procedure selectionchanged;
   procedure docopymethods(const source, dest: tcomponent);
   procedure dorefreshmethods(const descendent,newancestor,oldancestor: tcomponent);
   procedure writemodule(const amodule: pmoduleinfoty; const astream: tstream);
   procedure notifydeleted(comp: tcomponent);
   procedure componentdestroyed(const acomponent: tcomponent; const module: pmoduleinfoty);
   function checkmethodtypes(const amodule: pmoduleinfoty; const init: boolean): boolean;
   procedure dofixup;
   procedure buildmethodtable(const amodule: pmoduleinfoty);
   procedure releasemethodtable(const amodule: pmoduleinfoty);
  protected
   procedure componentevent(const event: tcomponentevent); override;
   function checkmodule(const filename: msestring): pmoduleinfoty;
   procedure checkident(const aname: string);
  public
   constructor create; reintroduce;
   destructor destroy; override;

   procedure begincomponentmodify;
   procedure endcomponentmodify;
   
   procedure modulechanged(const amodule: pmoduleinfoty);
   function changemodulename(const filename: msestring; const avalue: string): string;
   function changemoduleclassname(const filename: msestring; const avalue: string): string;
   function changeinstancevarname(const filename: msestring; const avalue: string): string;
   function checksubmodule(const ainstance: tcomponent; 
              out aancestormodule: pmoduleinfoty): boolean;
   function getreferencingmodulenames(const amodule: pmoduleinfoty): stringarty;
   
   //idesigner
   procedure componentmodified(const component: tobject);
   procedure selectcomponent(instance: tcomponent);
   procedure setselections(const list: idesignerselections);
   function createcurrentcomponent(const module: tmsecomponent): tcomponent;
   function hascurrentcomponent: boolean;
   procedure addcomponent(const module: tmsecomponent; const acomponent: tcomponent);
   procedure deleteselection(adoall: boolean = false);
   procedure deletecomponent(const acomponent: tcomponent);
   procedure clearselection;
   procedure noselection;

   function getmethod(const aname: string; const methodowner: tmsecomponent;
                        const atype: ptypeinfo): tmethod;
   function getmethodname(const method: tmethod; const comp: tcomponent): string;
   procedure changemethodname(const method: tmethod; newname: string;
                                           const atypeinfo: ptypeinfo);
   function createmethod(const aname: string; const module: tmsecomponent;
                                 const atype: ptypeinfo): tmethod;
   
   function getcomponentname(const comp: tcomponent): string;
                   //returns qualified name for foreign modules
   function getcomponentdispname(const comp: tcomponent): string;
                   //returns qualified name into root
   procedure validaterename(const acomponent: tcomponent;
                      const curname, newname: string); reintroduce;
   function getclassname(const comp: tcomponent): string;
                   //returns submoduleclassname if appropriate
   function getcomponent(const aname: string; 
                               const aroot: tcomponent): tcomponent;
                   //handles qualified names for foreign forms
   function componentcanedit: boolean;
   function getcomponenteditor: icomponenteditor;
   function getcomponentlist(const acomponentclass: tcomponentclass): componentarty;
   function getcomponentnamelist(const acomponentclass: tcomponentclass;
                                 const includeinherited: boolean;
                                 const aowner: tcomponent = nil): msestringarty;
   procedure setmodulex(const amodule: tmsecomponent; avalue: integer);
   procedure setmoduley(const amodule: tmsecomponent; avalue: integer);


   procedure getmethodinfo(const method: tmethod; out moduleinfo: pmoduleinfoty;
                      out methodinfo: pmethodinfoty);
   function getmodules: tmodulelist;

   function loadformfile(filename: msestring): pmoduleinfoty;
   function saveformfile(const modulepo: pmoduleinfoty;
                 const afilename: msestring; createdatafile: boolean): boolean;
                        //false if canceled
   function saveall(noconfirm,createdatafile: boolean): modalresultty;
   procedure setactivemodule(const adesignform: tmseform);
   function sourcenametoformname(const aname: filenamety): filenamety;

   function closemodule(const amodule: pmoduleinfoty;
                     const checksave: boolean): boolean; //true if closed
   procedure showformdesigner(const amodule: pmoduleinfoty);
   procedure showastext(const amodule: pmoduleinfoty);
   procedure showobjectinspector;
   function actmodulepo: pmoduleinfoty;
   function modified: boolean;
   procedure moduledestroyed(const amodule: pmoduleinfoty);
   procedure addancestorinfo(const ainstance,aancestor: tmsecomponent);
   function copycomponent(const source: tmsecomponent;
                          const root: tmsecomponent):tmsecomponent;
   procedure revert(const acomponent: tcomponent);
   function checkcanclose(const amodule: pmoduleinfoty; out references:  string): boolean;

   property modules: tmodulelist read getmodules;

   property objformat: objformatty read fobjformat write fobjformat default of_default;
   property designfiles: tmseindexednamelist read fdesignfiles;

   property ongetmodulenamefile: getmoduleeventty read fongetmodulenamefile
                   write fongetmodulenamefile;
   property ongetmoduletypefile: getmoduletypeeventty read fongetmoduletypefile
                   write fongetmoduletypefile;

 end;

procedure createbackupfile(const newname,origname: filenamety;
                      var backupcreated: boolean; const backupcount: integer);
           
function designer: tdesigner;

implementation

uses
 msestream,msefileutils,{$ifdef mswindows}windows{$else}libc{$endif},
 designer_bmp,msesys,msewidgets,formdesigner,mseevent,objectinspector,
 msefiledialog,projectoptionsform,sourceupdate,sourceform,pascaldesignparser,
 msearrayprops;

type
 tcomponent1 = class(tcomponent);
 tmsecomponent1 = class(tmsecomponent);
 twidget1 = class(twidget);
 twriter1 = class(twriter);
 treader1 = class(treader);

 moduleeventty = (me_none,me_componentmodified);

var
 fdesigner: tdesigner;
 loadingdesigner: tdesigner;
 methodaddressdummy: cardinal;
 submodulecopy: integer;

function designer: tdesigner;
begin
 result:= fdesigner;
end;

function getglobalcomponent(const Name: string): TComponent;
begin
 if (loadingdesigner <> nil) or (submodulecopy > 0) then begin
  result:= fdesigner.fmodules.findmoduleinstancebyname(name);
 end
 else begin
  result:= nil;
 end;
end;

procedure beginsubmodulecopy;
begin
 inc(submodulecopy);
 if submodulecopy = 1 then begin
  lockfindglobalcomponent;
  RegisterFindGlobalComponentProc({$ifdef FPC}@{$endif}getglobalcomponent);
 end;
end;

procedure endsubmodulecopy;
begin
 dec(submodulecopy);
 if submodulecopy = 0 then begin
  unlockfindglobalcomponent;
  unregisterFindGlobalComponentProc({$ifdef FPC}@{$endif}getglobalcomponent);
 end;
end;

{ tancestorlist }

constructor tancestorlist.create;
begin
 inherited create(sizeof(ancestorinfoty));
end;

procedure tancestorlist.itemdestroyed(const sender: iobjectlink);
var
 int1: integer;
 comp: tmsecomponent;
begin
 comp:= tmsecomponent(sender.getinstance);
 for int1:= count - 1 downto 0 do begin
  with pancestorinfoty(getitempo(int1))^ do begin
   if (descendent = comp) or (ancestor = comp) then begin
    delete(int1);
   end;
  end;
 end;
end;

procedure tancestorlist.add(const adescendent, aancestor: tmsecomponent);
var
 info: ancestorinfoty;
begin
 fillchar(info,sizeof(info),0);
 fobjectlinker.link(adescendent);
 fobjectlinker.link(aancestor);
 info.descendent:= adescendent;
 info.ancestor:= aancestor;
 inherited add(info);
end;

procedure tancestorlist.dounlink(var item);
begin
 with ancestorinfoty(item) do begin
  fobjectlinker.unlink(descendent);
  fobjectlinker.unlink(ancestor);
 end;
end;

function tancestorlist.findancestor(const adescendent: tcomponent): tmsecomponent;
var
 po1: pancestorinfoty;
 int1: integer;
begin
 result:= nil;
 po1:= datapo;
 for int1:= 0 to fcount - 1 do begin
  if po1^.descendent = adescendent then begin
   result:= po1^.ancestor;
   break;
  end;
  inc(po1);
 end;
end;

function tancestorlist.finddescendent(const aancestor: tcomponent): tmsecomponent;
var
 po1: pancestorinfoty;
 int1: integer;
begin
 result:= nil;
 po1:= datapo;
 for int1:= 0 to fcount - 1 do begin
  if po1^.ancestor = aancestor then begin
   result:= po1^.descendent;
   break;
  end;
  inc(po1);
 end;
end;

function tancestorlist.finddescendentinfo(const adescendent: tcomponent): pancestorinfoty;
var
 po1: pancestorinfoty;
 int1: integer;
begin
 result:= nil;
 po1:= datapo;
 for int1:= 0 to fcount - 1 do begin
  if po1^.descendent = adescendent then begin
   result:= po1;
   break;
  end;
  inc(po1);
 end;
end;

function tancestorlist.findancestorinfo(const aancestor: tcomponent): pancestorinfoty;
var
 po1: pancestorinfoty;
 int1: integer;
begin
 result:= nil;
 po1:= datapo;
 for int1:= 0 to fcount - 1 do begin
  if po1^.ancestor = aancestor then begin
   result:= po1;
   break;
  end;
  inc(po1);
 end;
end;

{ tdesignerancestorlist }

constructor tdesignerancestorlist.create(aowner: tdesigner);
begin
 fdesigner:= aowner;
 inherited create;
end;

{ tsubmodulelist }

procedure tsubmodulelist.finalizerecord(var item);
var
 comp: tmsecomponent;
begin
 with ancestorinfoty(item) do begin
  comp:= ancestor;
  ancestor:= nil;
 end;
 inherited;
 comp.Free;
end;

procedure tsubmodulelist.add(const amodule: tmsecomponent);
begin
 if findancestor(amodule) = nil then begin
  inherited add(amodule,fdesigner.copycomponent(amodule,amodule));
 end;
end;

procedure tsubmodulelist.renewbackup(const amodule: tmsecomponent);
var
 po1: pancestorinfoty;
 comp: tmsecomponent;
begin
 po1:= finddescendentinfo(amodule);
 if po1 <> nil then begin
  comp:= po1^.ancestor;
  po1^.ancestor:= nil;
  comp.Free;
  po1^.ancestor:= fdesigner.copycomponent(amodule,amodule);
  fobjectlinker.link(po1^.ancestor);
 end;
end;


const
 skipmark = '1w%f62*7/*+z';
 
type
 trefreshexception = class(exception)
 end;
 
{ treaderrorhandler }

destructor treaderrorhandler.destroy;
var
 int1: integer;
begin
 for int1:= 0 to high(fcomponentar) do begin
  fcomponentar[int1].free; //FPC does not free the component
 end;
 inherited;
end;

procedure treaderrorhandler.onerror(reader: treader; const message: string;
                        var handled: boolean);
begin
 if message = skipmark then begin
  handled:= true;
 end;
end;

procedure treaderrorhandler.notification(acomponent: tcomponent; operation: toperation);
begin
 if (operation = opremove) then begin
  removeitem(pointerarty(fcomponentar),acomponent);
  removeitem(pointerarty(fnewcomponents),acomponent);
 end;
 inherited;
end;

procedure treaderrorhandler.doraise(const acomponent: tcomponent);
begin  
 if acomponent <> nil then begin
  additem(pointerarty(fcomponentar),acomponent);
  acomponent.freenotification(self);
 end;
 raise trefreshexception.create(skipmark);
end;  

procedure treaderrorhandler.ancestornotfound(Reader: TReader;
                   const ComponentName: string;
                   ComponentClass: TPersistentClass; var Component: TComponent);
begin
 doraise(nil); //changed name
end;

procedure treaderrorhandler.onsetname(reader: treader; 
                                    component: tcomponent; var aname: string);
begin
// if (component.owner <> nil) and (csinline in component.owner.componentstate) and
//        not (csancestor in component.componentstate) then begin
 if component.owner = froot then begin
  additem(pointerarty(fnewcomponents),component);
  component.freenotification(self);
//  doraise(component);    //new component placed into submodule
 end;
end;

{ tdescendentinstancelist }

procedure checkancestor(const acomponent: tcomponent);
var
 int1: integer;
begin
 if not (csinline in acomponent.componentstate) then begin
  for int1:= 0 to acomponent.componentcount - 1 do begin
   checkancestor(acomponent.components[int1]);
  end;
  tcomponent1(acomponent).setancestor(true);
 end;
end;

procedure tdescendentinstancelist.delcomp(child: tcomponent);
begin
 tcomponent1(child).getchildren({$ifdef FPC}@{$endif}delcomp,froot);
 additem(pointerarty(fdelcomps),child);
end;

procedure tdescendentinstancelist.addcomp(child: tcomponent);
begin
 fmodule^.components.add(child);
 tcomponent1(child).getchildren({$ifdef FPC}@{$endif}addcomp,child);
end;

procedure tdescendentinstancelist.revert(const info: pancestorinfoty; 
                    const module: pmoduleinfoty);

 
var
 comp1,comp2: tmsecomponent;
 parent1: twidget;
 str1: string;
 int1: integer;
begin
 comp1:= info^.descendent;
 info^.descendent:= nil;
 if comp1 is twidget then begin
  parent1:= twidget(comp1).parentwidget;
 end
 else begin
  parent1:= nil;
 end;
 str1:= comp1.name;
 fobjectlinker.unlink(comp1);
 fdelcomps:= nil;
 froot:= comp1.owner;
 delcomp(comp1);
 for int1:= 0 to high(fdelcomps) do begin
  fdelcomps[int1].free;
 end;
 fdelcomps:= nil;
 comp2:= fdesigner.copycomponent(info^.ancestor,info^.ancestor);
 info^.descendent:= comp2;
 comp2.name:= str1;
 checkancestor(comp2);
 tmsecomponent1(comp2).setinline(true);
 fobjectlinker.link(comp2);
 module^.instance.insertcomponent(comp2);
 if parent1 <> nil then begin
  twidget(info^.descendent).parentwidget:= parent1;
 end;
 fmodule:= module;
 addcomp(comp2);
 removefixupreferences(module^.instance,'');
end;         

{$define debug submodule}

procedure tdescendentinstancelist.modulemodified(const amodule: pmoduleinfoty);
type
 streamarty = array of tstream;
 ancestorinfopoarty = array of pancestorinfoty;
 

{$ifdef debugsubmodule}
var
 teststream: ttextstream;
 procedure debugout(const atext: string; const stream: tstream);
 begin
  writeln(atext);
  stream.position:= 0;
  teststream.size:= 0;
  objectbinarytotext(stream,teststream);
  teststream.position:= 0;
  teststream.writetotext(output);
 end;
{$endif}

var
 modules,module: moduleinfopoarty;
 streams: streamarty;
 infos: ancestorinfopoarty;
 stream1: tmemorystream;
 writer1: twriter;
 reader1: treader;
 ancestor: tcomponent;
 int1,int2: integer;
 po1: pancestorinfoty;
 po2: pmoduleinfoty;

begin
 po1:= datapo;
 for int1:= 0 to fcount - 1 do begin
  if po1^.ancestor = amodule^.instance then begin
   additem(pointerarty(infos),po1);
   po2:= fdesigner.modules.findmodule(tmsecomponent(po1^.descendent.owner));
   additem(pointerarty(modules),po2);
   if finditem(pointerarty(module),po2) < 0 then begin
    additem(pointerarty(module),po2);
   end;
  end;
  inc(po1);
 end;
 if high(infos) >= 0 then begin
 {$ifdef debugsubmodule}
  teststream:= ttextstream.create;
 {$endif}
  ancestor:= fdesigner.fsubmodulelist.findancestor(amodule^.instance);
  beginsubmodulecopy;
  try 
   setlength(streams,length(infos));
   for int1:= 0 to high(modules) do begin
    fdesigner.buildmethodtable(modules[int1]);
    try
     streams[int1]:= tmemorystream.create;
     writer1:= twriter.create(streams[int1],4096);
     try
      writer1.onfindancestor:= {$ifdef FPC}@{$endif}fdesigner.findancestor;
      writer1.writedescendent(infos[int1]^.descendent,ancestor);
     finally
      writer1.free;
     end;
 {$ifdef debugsubmodule}
     debugout('state ' + modules[int1]^.instance.name,streams[int1]);
 {$endif}
    finally
     fdesigner.releasemethodtable(modules[int1]);
    end;
   end;
   fdesigner.fsubmodulelist.renewbackup(amodule^.instance);
   ferrorhandler:= treaderrorhandler.create(nil);
   try
    for int1:= 0 to high(modules) do begin
     streams[int1].position:= 0;
     revert(infos[int1],modules[int1]);
     reader1:= treader.create(streams[int1],4096);
     fdesigner.buildmethodtable(modules[int1]);
     try
      reader1.onerror:= {$ifdef FPC}@{$endif}ferrorhandler.onerror;
      reader1.onancestornotfound:= {$ifdef FPC}@{$endif}ferrorhandler.ancestornotfound;
      reader1.onsetname:= {$ifdef FPC}@{$endif}ferrorhandler.onsetname;
      reader1.onfindcomponentclass:= {$ifdef FPC}@{$endif}fdesigner.findcomponentclass;
      reader1.oncreatecomponent:= {$ifdef FPC}@{$endif}fdesigner.createcomponent;
      reader1.onfindmethod:= {$ifdef FPC}@{$endif}fdesigner.findmethod2;
      reader1.root:= modules[int1]^.instance;
      ferrorhandler.fnewcomponents:= nil;
      reader1.root:= modules[int1]^.instance;
      ferrorhandler.froot:= modules[int1]^.instance;
      reader1.parent:= infos[int1]^.descendent.getparentcomponent;
      {$ifdef FPC}
      reader1.driver.beginrootcomponent;
      {$else}
      reader1.readsignature;
      {$endif}
      reader1.beginreferences;
      reader1.readcomponent(infos[int1]^.descendent);
      reader1.fixupreferences;
      reader1.endreferences;
     finally
      reader1.free;
      fdesigner.releasemethodtable(modules[int1]);
      removefixupreferences(modules[int1]^.instance,'');
     end;
     for int2:= high(ferrorhandler.fnewcomponents) downto 0 do begin
      if ferrorhandler.fnewcomponents[int2] <> infos[int1]^.descendent then begin
       modules[int1]^.components.add(ferrorhandler.fnewcomponents[int2]);
      end;
     end;
    end;
   finally
    ferrorhandler.free;
    for int1:= 0 to high(streams) do begin
     streams[int1].free;
    end;
   end;
   for int1:= 0 to high(module) do begin
    fdesigner.componentmodified(module[int1]^.instance);
   end;
  finally
   endsubmodulecopy;
 {$ifdef debugsubmodule}
   teststream.free;
 {$endif}
  end;
 end;
end;
(*
procedure tdescendentinstancelist.modulemodified(const amodule: tcomponent;
                         const oldmodule: tmsecomponent);
var
 po1: pancestorinfoty;
 int1,int2: integer;
 po2,po3: pmoduleinfoty;
 bo1: boolean;
 desttable: pointer; 
begin
 po1:= datapo;
 po3:= nil;
 beginsubmodulecopy;
 try
  bo1:= false;
  for int1:= 0 to fcount - 1 do begin
   if po1^.ancestor = amodule then begin
    if po3 = nil then begin
     po3:= fdesigner.modules.findmodule(tmsecomponent(amodule));
     fdesigner.flookupmodule:= po3;
     desttable:= po3^.methods.createmethodtable;
    end;     
    po2:= fdesigner.modules.findmodule(tmsecomponent(po1^.descendent.owner));
    fdesigner.buildmethodtable(po2);
    try
     refreshancestor(po1^.descendent,po1^.ancestor,oldmodule,false,
     {$ifdef FPC}@{$endif}fdesigner.findancestor,
     {$ifdef FPC}@{$endif}fdesigner.findcomponentclass,
     {$ifdef FPC}@{$endif}fdesigner.createcomponent,
     {$ifdef FPC}@{$endif}fdesigner.findmethod2,
     desttable,po2^.methods.createmethodtable);
//     fdesigner.dorefreshmethods(po1^.descendent,po1^.ancestor,oldmodule);
    finally
     fdesigner.releasemethodtable(po2);
    end;
   end;
   inc(po1);
  end;
 finally
  endsubmodulecopy;
  if po3 <> nil then begin
   designer.releasemethodtable(po3);
  end;
 end;
 po1:= datapo;
 for int1:= 0 to fcount - 1 do begin
  if po1^.ancestor = amodule then begin
   fdesigner.componentmodified(po1^.descendent);
  end;
  inc(po1);
 end;
end;
*)

procedure tdescendentinstancelist.add(const instance,ancestor: tmsecomponent;
       const submodulelist: tsubmodulelist);
begin
 submodulelist.add(ancestor);
 inherited add(instance,ancestor);
end;

function tdescendentinstancelist.getclassname(const comp: tcomponent): string;
                   //returns submoduleclassname if appropriate
var
 comp1: tmsecomponent;
begin
 if (comp.Owner <> nil) and (comp.Owner.owner = nil) then begin
  //module, must be tmsecomponent;
  result:= tmsecomponent(comp).actualclassname;
 end
 else begin
  if csinline in comp.ComponentState then begin
   comp1:= findancestor(comp);
   if comp1 <> nil then begin
    result:= comp1.actualclassname;
    exit;
   end;
  end;
  result:= comp.ClassName;
 end;
end;

{ tmethods }

constructor tmethods.create(adesigner: tdesigner);
begin
 fdesigner:= adesigner;
 inherited create(sizeof(methodinfoty));
end;

destructor tmethods.destroy;
begin
 releasemethodtable;
 inherited;
end;

procedure tmethods.addmethod(const aname: string; const aaddress: pointer;
                             const atypeinfo: ptypeinfo);
var
 po1: pmethodinfoty;
begin
 {$ifdef FPC} {$checkpointer off} {$endif}
 po1:= add(cardinal(aaddress),nil^);
 {$ifdef FPC} {$checkpointer default} {$endif}
 with po1^ do begin
  name:= aname;
  address:= aaddress;
  typeinfo:= atypeinfo;
 end;
end;

procedure tmethods.deletemethod(const aadress: pointer);
begin
// inherited delete(cardinal(aadress)); do nothing
end;

type
{$ifdef FPC}
  tmethodnamerec = packed record
     name : pshortstring;
     addr : pointer;
  end;
  pmethodtableentryty = ^tmethodnamerec;
  
  tmethodnametable = packed record
    count : dword;
    entries : packed array[0..0] of tmethodnamerec;
  end;

function tmethods.createmethodtable: pointer;
var
 int1,int2: integer;
 po1: pmethodinfoty;
 po2: pmethodtableentryty;
 po3: pchar;

begin
 releasemethodtable;
 if count > 0 then begin
  int2:= count; //lenbyte
  for int1:= 0 to count -1 do begin
   int2:= int2 + length(pmethodinfoty(next)^.name);       //stringsize
  end;
  int1:= sizeof(dword) + count * sizeof(tmethodnamerec); //tablesize
  getmem(fmethodtable,int1+int2);
  pdword(fmethodtable)^:= count;
  po2:= pmethodtableentryty(pchar(fmethodtable) + sizeof(dword));
  po3:= pchar(fmethodtable) + int1;   //stringtable
  for int1:= 0 to count - 1 do begin
   po1:= pmethodinfoty(next);
   int2:= length(po1^.name);
   po2^.name:= pshortstring(po3);
   po3^:= char(int2); //namelen
   inc(po3);
   move(pointer(po1^.name)^,po3^,int2);
   inc(po3,int2);
   po2^.addr:= po1^.address;
   inc(po1);
   inc(po2);
  end;
 end;
 result:= fmethodtable;
end;

{$else}

 methodtableentryfixty = packed record
  len: word;
  addr: pointer;
  namlen: byte;
end;

 methodtableentryty = packed record
  len: word;
  adr: pointer;
  name: shortstring; //variable length
 end;
 pmethodtableentryty = ^methodtableentryty;

function tmethods.createmethodtable: pointer;
var
 int1,int2: integer;
 po1: pmethodinfoty;
 po2: pmethodtableentryty;

begin
 releasemethodtable;
 if count > 0 then begin
  int2:= sizeof(word); //numentries
  for int1:= 0 to count -1 do begin
   int2:= int2 + length(pmethodinfoty(next)^.name);
  end;
  getmem(fmethodtable,int2 + count * sizeof(methodtableentryfixty));
  pword(fmethodtable)^:= count;
  po2:= pmethodtableentryty(pchar(fmethodtable) + sizeof(word));
//  po1:= pmethodinfoty(fdatapo);
  for int1:= 0 to count - 1 do begin
   po1:= pmethodinfoty(next);
   int2:= length(po1^.name);
   po2^.len:= sizeof(methodtableentryfixty) + int2;
   po2^.adr:= po1^.address;
   po2^.name[0]:= char(int2);
   move(po1^.name[1],po2^.name[1],int2);
   inc(pchar(po2),po2^.len);
  end;
 end;
 result:= fmethodtable;
end;

{$endif}

procedure tmethods.releasemethodtable;
begin
 if fmethodtable <> nil then begin
  freemem(fmethodtable);
  fmethodtable:= nil;
 end;
end;

function tmethods.findmethod(const aadress: pointer): pmethodinfoty;
begin
 result:= pmethodinfoty(find(cardinal(aadress)));
end;

function tmethods.findmethodbyname(const aname: string;
                       const atype: ptypeinfo; out namefound: boolean): pmethodinfoty;
var
 int1: integer;
 po1: pmethodinfoty;
 str1: string;
begin
 str1:= uppercase(aname);
 result:= nil;
 namefound:= false;
 for int1:= 0 to fcount - 1 do begin
  po1:= next;
  if uppercase(po1^.name) = str1 then begin
   namefound:= true;
   if (po1^.typeinfo = atype) then begin
    result:= po1;
    break;
   end;
  end;
 end;
end;

function tmethods.findmethodbyname(const aname: string): pmethodinfoty;
var
 int1: integer;
 po1: pmethodinfoty;
 str1: string;
begin
 str1:= uppercase(aname);
 result:= nil;
 for int1:= 0 to fcount - 1 do begin
  po1:= next;
  if uppercase(po1^.name) = str1 then begin
   result:= po1;
   break;
  end;
 end;
end;

procedure tmethods.freedata(var data);
begin
 with methodinfoty(data) do begin
  name:= ''
 end;
end;

{ tcomponents }

constructor tcomponents.create(const aowner: pmoduleinfoty; const adesigner: tdesigner);
begin
 fowner:= aowner;
 fdesigner:= adesigner;
 fcomponent:= tcomponentslink.Create(nil);
 fcomponent.fowner:= self;
 inherited create(sizeof(componentinfoty));
end;

destructor tcomponents.destroy;
begin
 fcomponent.Free;
 inherited;
end;

procedure tcomponents.destroynotification(const acomponent: tcomponent);
begin
 fdesigner.componentdestroyed(acomponent,fowner);
 delete(cardinal(acomponent));
end;

procedure tcomponents.freedata(var data);
begin
 with componentinfoty(data) do begin
  name:= '';
 end;
end;

procedure tcomponents.doadd(component: tcomponent);
var
 root: tcomponent;
begin
 add(component);
 root:= famodule;
 if csinline in component.componentstate then begin
  famodule:= component;
 end;
 tcomponent1(component).GetChildren({$ifdef FPC}@{$endif}doadd,famodule);
 famodule:= root;
end;

procedure tcomponents.assigncomps(const module: tmsecomponent);
begin
 clear;
 if module <> nil then begin
  famodule:= module;
  doadd(module);
 end;
end;

procedure tcomponents.add(comp: tcomponent);
var
 po1: pcomponentinfoty;
begin
 {$ifdef FPC} {$checkpointer off} {$endif}
 po1:= inherited add(cardinal(comp),nil^);
 {$ifdef FPC} {$checkpointer default} {$endif}
 with po1^ do begin
  instance:= comp;
  name:= comp.Name;
 end;
 comp.freenotification(fcomponent);
end;

function tcomponents.find(const value: tobject): pcomponentinfoty;
begin
 result:= pcomponentinfoty(inherited find(cardinal(value)));
end;

procedure tcomponents.swapcomponent(const old,new: tcomponent);
var
 po1: pcomponentinfoty;
begin
 po1:= find(old);
 if po1 <> nil then begin
  po1^.instance:= new;
  old.removefreenotification(fcomponent);
  new.freenotification(fcomponent);
 end;
end;

function tcomponents.getcomponents: componentarty;
var
 int1: integer;
begin
 setlength(result,fcount);
 for int1:= 0 to fcount - 1 do begin
  result[int1]:= next^.instance;
 end;
end;

function tcomponents.next: pcomponentinfoty;
begin
 result:= pcomponentinfoty (inherited next);
end;

function tcomponents.getcomponent(const aname: string): tcomponent;
var
 int1: integer;
 po1: pcomponentinfoty;
 str1: string;

begin
 result:= nil;
 str1:= uppercase(aname);
 if aname <> '' then begin
  for int1:= 0 to fcount - 1 do begin
   po1:= next;
   if uppercase(po1^.name) = str1 then begin
    result:= po1^.instance;
    break;
   end;
  end;
 end;
end;

procedure tcomponents.namechanged(const acomponent: tcomponent; const newname: string);
var
 po1: pcomponentinfoty;
begin
 po1:= find(acomponent);
 if po1 <> nil then begin
  po1^.name:= newname;
 end;
end;

function comparecomponentname(const l,r): integer;
begin
 result:= comparetext(componentnamety(l).dispname,componentnamety(r).dispname);
end;

function tcomponents.getdispnames: componentnamearty;
var
 int1: integer;
begin
 setlength(result,count);
 for int1:= 0 to fcount - 1 do begin
  with result[int1] do begin
   instance:= next^.instance;
   dispname:= fdesigner.getcomponentdispname(instance);
  end;
 end;
 sortarray(result,{$ifdef FPC}@{$endif}comparecomponentname,sizeof(componentnamety));
end;

{ tmoduleinfo }

constructor tmoduleinfo.create(adesigner: tdesigner);
begin
 fdesigner:= adesigner;
 with info do begin
  methods:= tmethods.create(fdesigner);
  components:= tcomponents.create(@info,fdesigner);
 end;
end;

destructor tmoduleinfo.destroy;
begin
 with info do begin
  freeandnil(methods);
  freeandnil(components);
  freeandnil(designform);
 end;
end;

{ tmodulelist }

constructor tmodulelist.create(adesigner: tdesigner);
begin
 fdesigner:= adesigner;
 inherited create(true);
end;

function tmodulelist.getitempo1(const index: integer): pmoduleinfoty;
begin
 result:= @(tmoduleinfo(items[index]).info);
end;

function tmodulelist.findmodule(const filename: msestring): pmoduleinfoty;
var
 int1: integer;
 po1: ppointeraty;
 po2: pmoduleinfoty;
begin
 result:= nil;
 po1:= datapo;
 for int1:= 0 to fcount-1 do begin
  po2:= @tmoduleinfo(iobjectlink(po1^[int1]).getinstance).info;
  if po2^.filename = filename then begin
   result:= po2;
   break;
  end;
 end;
end;

function tmodulelist.findmodule(const amodule: tmsecomponent): pmoduleinfoty;
var
 int1: integer;
 po1: ppointeraty;
 po2: pmoduleinfoty;
begin
 result:= nil;
 if amodule <> nil then begin
  po1:= datapo;
  for int1:= 0 to fcount-1 do begin
   po2:= @tmoduleinfo(iobjectlink(po1^[int1]).getinstance).info;
   if po2^.instance = amodule then begin
    result:= po2;
    break;
   end;
  end;
 end;
end;

function tmodulelist.findmodulebyinstance(const ainstance: tcomponent): pmoduleinfoty;
var
 int1: integer;
 po1: ppointeraty;
 po2: pmoduleinfoty;
begin
 result:= nil;
 po1:= datapo;
 for int1:= 0 to fcount-1 do begin
  po2:= @tmoduleinfo(iobjectlink(po1^[int1]).getinstance).info;
  if po2^.instance = ainstance then begin
   result:= po2;
   break;
  end;
 end;
end;

function tmodulelist.findmodule(const po: pmoduleinfoty): integer;
var
 int1: integer;
 po1: ppointeraty;
begin
 result:= -1;
 po1:= datapo;
 for int1:= 0 to fcount-1 do begin
  if @tmoduleinfo(iobjectlink(po1^[int1]).getinstance).info = po then begin
   result:= int1;
   break;
  end;
 end;
end;

function tmodulelist.findmodulebyname(const name: string): pmoduleinfoty;
var
 int1: integer;
 po1: ppointeraty;
begin
 result:= nil;
 po1:= datapo;
 for int1:= 0 to fcount-1 do begin
  with tmoduleinfo(iobjectlink(po1^[int1]).getinstance) do begin
   if info.instancevarname = name then begin
    result:= @info;
    break;
   end;
  end;
 end;
end;

function tmodulelist.findmoduleinstancebyname(const name: string): tcomponent;
var
 po1: pmoduleinfoty;
begin
 po1:= findmodulebyname(name);
 if po1 <> nil then begin
  result:= po1^.instance;
 end
 else begin
  result:= nil;
 end;
end;

function tmodulelist.findmoduleinstancebyclass(const aclass: tclass): tcomponent;
var
 int1: integer;
 po1: ppointeraty;
begin
 result:= nil;
 po1:= datapo;
 for int1:= 0 to fcount-1 do begin
  with tmoduleinfo(iobjectlink(po1^[int1]).getinstance) do begin
   if info.instance.classtype = aclass then begin
    result:= info.instance;
    break;
   end;
  end;
 end;
end;

function tmodulelist.newmodule(const afilename: msestring;
         const amoduleclassname,ainstancevarname,designmoduleclassname: string): pmoduleinfoty;
var
 moduleinfo: tmoduleinfo;
begin
 result:= findmodule(afilename);
 if result <> nil then begin
  delete(findmodule(result));
 end;
 moduleinfo:= tmoduleinfo.create(fdesigner);
 result:= @moduleinfo.info;
 with moduleinfo.info do begin
  filename:= afilename;
  instancevarname:= ainstancevarname;
  moduleclassname:= amoduleclassname;
  try
   instance:= createdesignmodule(designmoduleclassname,@moduleclassname);
   tcomponent1(instance).setdesigning(true{$ifndef FPC},true{$endif});
  except
   moduleinfo.Free;
   raise;
  end;
 end;
 add(moduleinfo);
end;

function tmodulelist.findmethodbyname(const name: string; 
                                      const atype: ptypeinfo; 
                                      const amodule: tmsecomponent): tmethod;

 procedure getmethod(ainfo: pmoduleinfoty; aname: string);
 var
  po1: pmethodinfoty;
  bo1: boolean;
 begin
  if ainfo <> nil then begin
   po1:= ainfo^.methods.findmethodbyname(aname,atype,bo1);
   if po1 <> nil then begin
    result.code:= po1^.address;
    result.Data:= ainfo^.instance;
   end
   else begin
    if bo1 then begin
     result.data:= pointer(1); //name found
    end;
   end;
  end;
 end;

var
 ar1: stringarty;
begin
 result:= nullmethod;
 if amodule <> nil then begin
  getmethod(findmodule(amodule),name);
 end
 else begin
  ar1:= nil;
  splitstring(name,ar1,'.');
  if length(ar1) = 2 then begin
   getmethod(findmodulebyname(ar1[0]),ar1[1]);
  end;
 end;
end;

function tmodulelist.findmethodname(const method: tmethod; const comp: tcomponent): string;
var
 int1: integer;
 po1: ppointeraty;
 po2: pmethodinfoty;
begin
 result:= '';
 po1:= datapo;
 for int1:= 0 to fcount - 1 do begin
  with tmoduleinfo(iobjectlink(po1^[int1]).getinstance) do begin
   po2:= info.methods.findmethod(method.Code);
   if po2 <> nil then begin
    if info.components.find(comp) = nil then begin
     result:= info.instance.actualclassname + '.' + po2^.name //foreign module
    end
    else begin
     result:= po2^.name;
    end;
    break;
   end;
  end;
 end;
end;

function tmodulelist.delete(index: integer): pointer;
begin
 fdesigner.moduledestroyed(itempo[index]);
 result:= inherited delete(index);
end;

function tmodulelist.removemoduleinfo(po: pmoduleinfoty): integer;
begin
 result:= findmodule(po);
 delete(result);
end;

function tmodulelist.findform(aform: tmseform): pmoduleinfoty;
var
 int1: integer;
 po1: ppointeraty;
begin
 result:= nil;
 po1:= datapo;
 for int1:= 0 to count - 1 do begin
  with tmoduleinfo(iobjectlink(po1^[int1]).getinstance) do begin
   if info.designform = aform then begin
    result:= @info;
    break;
   end;
  end;
 end;
end;

procedure tmodulelist.componentmodified(const acomponent: tobject);
var
 int1: integer;
 po1: ppointeraty;
 comp: tcomponent;

begin
 if acomponent is tcomponent then begin
  comp:= tcomponent(acomponent);
  po1:= datapo;
  for int1:= 0 to count - 1 do begin
   with tmoduleinfo(iobjectlink(po1^[int1]).getinstance) do begin
    if info.components.find(comp) <> nil then begin
     if not info.modified then begin
      info.modified:= true;
      if info.designform <> nil then begin
       tformdesignerfo(info.designform).updatecaption;
      end;
     end;
     if (info.designform <> nil) and (fdesigner.fcomponentmodifying > 0) then begin
      idesignnotification(
           tdesignwindow(info.designform.window)).itemsmodified(nil,comp);
     end;
     fdesigner.fdescendentinstancelist.modulemodified(@info);
     break;
    end;
   end;
  end;
  {
  while comp <> nil do begin
   fdesigner.fdescendentinstancelist.modulemodified(comp,
        fdesigner.fsubmodulelist.findancestor(comp));
   fdesigner.fsubmodulelist.renewbackup(comp);
   comp:= comp.owner;
  end;
  }
 end;
end;

function tmodulelist.findmodulebycomponent(const acomponent: tobject): pmoduleinfoty;
var
 int1: integer;
 po1: ppointeraty;
 po2: pmoduleinfoty;
begin
 result:= nil;
 po1:= datapo;
 for int1:= 0 to fcount-1 do begin
  po2:= @tmoduleinfo(iobjectlink(po1^[int1]).getinstance).info;
  if po2^.components.find(acomponent) <> nil then begin
   result:= po2;
   break;
  end;
 end;
end;

function tmodulelist.filenames: filenamearty;
var
 int1: integer;
 po1: ppointeraty;
begin
 setlength(result,count);
 po1:= datapo;
 for int1:= 0 to high(result) do begin
  result[int1]:= tmoduleinfo(iobjectlink(po1^[int1]).getinstance).info.filename;
 end;
end;

{ tdesignformlist }

function tdesignformlist.getitems(const index: integer): tmseform;//tformdesignerfo;
begin
 result:= tmseform(inherited getitems(index));
end;

{ tdesigner }

constructor tdesigner.create;
begin
 fobjformat:= of_default;
 fselections:= tdesignerselections.create;
 fmodules:= tmodulelist.create(self);
 fsubmodulelist:= tsubmodulelist.create(self);
 fdescendentinstancelist:= tdescendentinstancelist.create(self);
 fdesignfiles:= tmseindexednamelist.create;
 ondesignchanged:= {$ifdef FPC}@{$endif}componentmodified;
 onfreedesigncomponent:= {$ifdef FPC}@{$endif}deletecomponent;
end;

destructor tdesigner.destroy;
begin
 ondesignchanged:= nil;
 fdescendentinstancelist.Free;
 fsubmodulelist.Free;
 inherited;
 fcomponenteditor.Free;
 fmodules.free;
 fselections.Free;
 fdesignfiles.Free;
end;

procedure tdesigner.ClearSelection;
begin

end;

procedure tdesigner.addcomponent(const module: tmsecomponent; const acomponent: tcomponent);
var
 int1: integer;
 str1: string;
 bo1: boolean;
 classna: string;
 
begin
 with registeredcomponents do begin
  if (acomponent.ComponentState * [csancestor] = []) or
         (acomponent.Owner = nil) or (acomponent.Owner = module) then begin //probaly inline

   str1:= acomponent.Name;
   acomponent.name:= '';
   if csinline in acomponent.componentstate then begin
    if str1 <> '' then begin
     classna:= str1;
     str1:= str1 + '1';
    end;
   end
   else begin
    classna:= acomponent.ClassName;
   end;
   if acomponent.Owner <> nil then begin
    acomponent.owner.removecomponent(acomponent);
   end;
   module.InsertComponent(acomponent);
   if str1 = '' then begin
    str1:= classna + '1';
   end;
   int1:= 1;
   repeat
    bo1:= true;
    try
     acomponent.Name:= str1;
    except
     on ecomponenterror do begin
      inc(int1);
      str1:= classna + inttostr(int1);
      bo1:= false;
     end;
     else raise;
    end;
   until bo1;
   fmodules.findmodulebyinstance(module)^.components.add(acomponent);
   designnotifications.ItemInserted(self,module,acomponent);
  end
  else begin
   fmodules.findmodulebyinstance(module)^.components.add(acomponent);
  end;
  componentmodified(acomponent);
 end;
end;

function tdesigner.createcurrentcomponent(const module: tmsecomponent): tcomponent;
begin
 with registeredcomponents do begin
  if selectedclass <> nil then begin
   result:= tcomponent(selectedclass.newinstance);
   try
    tcomponent1(result).setdesigning(true);
    result.create(nil);
   except
    result.Free;
    raise;
   end;
   addcomponent(module,result);
  end
  else begin
   result:= nil;
  end;
 end;
end;

function tdesigner.hascurrentcomponent: boolean;
begin
 result:= registeredcomponents.selectedclass <> nil;
end;

procedure tdesigner.notifydeleted(comp: tcomponent);
begin
 if fnotifydeletedlock = 0 then begin
  if comp is twidget then begin
   tcomponent1(comp).getchildren({$ifdef FPC}@{$endif}notifydeleted,fnotifymodule);
  end;
  designnotifications.itemdeleted(idesigner(self),fnotifymodule,comp);
 end;
end;

procedure tdesigner.deleteselection(adoall: boolean);
var
 int1: integer;
 comp1,comp2: tcomponent;
 po1: pmoduleinfoty;

begin
 for int1:= 0 to fselections.count - 1 do begin
  comp1:= fselections[int1];
  comp2:= comp1.owner;
  po1:= fmodules.findmodulebycomponent(comp1);
  if po1 <> nil then begin
   fnotifymodule:= po1^.instance;
   notifydeleted(comp1);
  end;
  inc(fnotifydeletedlock);
  try
   comp1.free;
  finally
   dec(fnotifydeletedlock);
  end;
  fmodules.componentmodified(comp2);
 end;
 fselections.clear;
 selectionchanged;
// designnotifications.SelectionChanged(idesigner(self),idesignerselections(fselections));
end;

procedure tdesigner.componentdestroyed(const acomponent: tcomponent;
                                           const module: pmoduleinfoty);
begin
 if fnotifydeletedlock = 0 then begin
//  designnotifications.itemdeleted(idesigner(self),module^.instance,acomponent);
  if fselections.remove(acomponent) >= 0 then begin
   selectionchanged;
  end;
 end;
end;

procedure tdesigner.deletecomponent(const acomponent: tcomponent);
begin
 if acomponent <> nil then begin
  fmodules.componentmodified(acomponent);
  designnotifications.ItemDeleted(idesigner(self),
            fmodules.findmodulebycomponent(acomponent)^.instance,acomponent);
  acomponent.free;
 end;
end;

function tdesigner.createmethod(const aname: string; const module: tmsecomponent;
                                   const atype: ptypeinfo): tmethod;
var
 po1: pmoduleinfoty;
begin
 if module = nil then begin
  po1:= floadingmodulepo;
 end
 else begin
  po1:= fmodules.findmodulebyinstance(module);
 end;
 if po1 <> nil then begin
  with po1^.methods do begin
   inc(methodaddressdummy);
   result.code:= pointer(methodaddressdummy);
   result.Data:= po1^.instance;
   addmethod(aname,result.code,atype);
  end;
  if atype <> nil then begin
   designnotifications.methodcreated(idesigner(self),module,aname,atype);
  end;
 end
 else begin
  result:= nullmethod;
 end;
end;

procedure tdesigner.findmethod(Reader: TReader; const aMethodName: string;
  var Address: Pointer; var Error: Boolean);
var
 method: tmethod;
begin
 if error then begin
  method:= createmethod(amethodname,nil,nil);
  address:= method.code;
  error:= false;
 end;
end;

procedure tdesigner.findmethod2(Reader: TReader; const aMethodName: string;
  var Address: Pointer; var Error: Boolean);
var
 method: tmethod;
 po2: pmethodinfoty;
begin
 if error then begin
  error:= false; //ignore new method error
  po2:= flookupmodule^.methods.findmethodbyname(amethodname);
  if po2 <> nil then begin
   address:= po2^.address;
  end;
 end;
end;

procedure tdesigner.findcomponentclass(Reader: TReader; const aClassName: string;
        var ComponentClass: TComponentClass);

 function findclass(const classname: string): pmoduleinfoty;
 var
  int1: integer;
  po1: pmoduleinfoty;
 begin
  result:= nil;
  for int1:= 0 to fmodules.count - 1 do begin
   po1:= fmodules[int1];
   if uppercase(po1^.moduleclassname) = classname then begin
    result:= po1;
    break;
   end;
  end;
 end;

var
 str1: string;
 po1: pmoduleinfoty;
begin
 fsubmoduleinfopo:= nil;
 if componentclass = nil then begin
  str1:= uppercase(aclassname);
  po1:= findclass(str1);
  if po1 = nil then begin
   if assigned(fongetmoduletypefile) then begin
    fongetmoduletypefile(aclassname);
   end;
   po1:= findclass(str1);
  end;
  if po1 <> nil then begin
   fsubmoduleinfopo:= po1;  //used in createcomponent
   componentclass:= tcomponentclass(po1^.instance.classtype);
  end;
 end;
end;

procedure tdesigner.ancestornotfound(Reader: TReader; const ComponentName: string;
                   ComponentClass: TPersistentClass; var Component: TComponent);
begin
 component:= fmodules.findmoduleinstancebyclass(componentclass);
end;

procedure tdesigner.createcomponent(Reader: TReader; ComponentClass: TComponentClass;
                   var Component: TComponent);
var
 asubmoduleinfopo: pmoduleinfoty;
begin
 asubmoduleinfopo:= fsubmoduleinfopo;    //can be recursive
 if asubmoduleinfopo <> nil then begin
//  component:= mseclasses.copycomponent(asubmoduleinfopo^.instance,reader.root,
//      {$ifdef FPC}@{$endif}findancestor,
//      {$ifdef FPC}@{$endif}findcomponentclass,{$ifdef FPC}@{$endif}createcomponent);
//  docopymethods(asubmoduleinfopo^.instance,component);
  component:= copycomponent(asubmoduleinfopo^.instance,asubmoduleinfopo^.instance);
  reader.root.insertcomponent(component);
  checkancestor(component);
  tmsecomponent1(component).setinline(true);
  if (submodulecopy = 0) and 
          (reader.root.componentstate * [csinline,csancestor] = [])  then begin
   additem(pointerarty(floadedsubmodules),component);
   fdescendentinstancelist.add(tmsecomponent(component),asubmoduleinfopo^.instance,fsubmodulelist);
  end;
 end;
end;

procedure tdesigner.docopymethods(const source, dest: tcomponent);
var
 propar: propinfopoarty;
 po1: ^ppropinfo;
 int1: integer;
 method,method1: tmethod;
 comp1,comp2: tcomponent;
begin
 propar:= getpropinfoar(source);
 po1:= pointer(propar);
 for int1:= 0 to high(propar) do begin
  if po1^^.proptype^.kind = tkmethod then begin
   method:= getmethodprop(source,po1^);
   method1:= getmethodprop(dest,po1^);
   if (method1.code <> method.code) or (method1.data <> method.data) then begin
    setmethodprop(dest,po1^,method);
   end;
  end;
  inc(po1);
 end;
 for int1:= 0 to source.ComponentCount - 1 do begin
  comp1:= source.Components[int1];
  comp2:= dest.FindComponent(comp1.name);
  if (comp2 <> nil) and (comp1.ClassType = comp2.ClassType) then begin
   docopymethods(comp1,comp2);
  end;
 end;
end;

procedure tdesigner.dorefreshmethods(const descendent,newancestor,oldancestor: tcomponent);
var
 propar: propinfopoarty;
 po1: ^ppropinfo;
 int1: integer;
 method1,method2,method3: tmethod;
 comp1,comp2,comp3: tcomponent;
begin
 propar:= getpropinfoar(descendent);
 po1:= pointer(propar);
 for int1:= 0 to high(propar) do begin
  if po1^^.proptype^.kind = tkmethod then begin
   method2:= getmethodprop(newancestor,po1^);
   if (method2.code <> nil) and (method2.data <> nil) then begin
    setmethodprop(descendent,po1^,method2); 
         //refresh ancestor value, it is not possible to override methods
   end;
{
   method1:= getmethodprop(descendent,po1^);
   method2:= getmethodprop(newancestor,po1^);
   method3:= getmethodprop(oldancestor,po1^);
   if (method1.code = method3.code) and (method1.data = method3.data) and 
       ((method1.code <> method2.code) or (method1.data <> method2.data)) then begin
    setmethodprop(descendent,po1^,method2); //refresh ancestor value
   end;
}
  end;
  inc(po1);
 end;
 for int1:= 0 to descendent.ComponentCount - 1 do begin
  comp1:= descendent.Components[int1];
  comp2:= newancestor.findcomponent(comp1.name);
  comp3:= oldancestor.findcomponent(comp1.name);
  if (comp2 <> nil) and (comp3 <> nil) and
       (comp1.classtype = comp2.classtype) and
       (comp1.classtype = comp3.classtype) then begin
   dorefreshmethods(comp1,comp2,comp3);
  end;
 end;
end;

procedure tdesigner.componentevent(const event: tcomponentevent);
begin
 with event do begin
  if tag = ord(me_componentmodified) then begin
   designnotifications.ItemsModified(idesigner(self),sender);
  end;
 end;
 inherited;
end;

procedure tdesigner.setmodulex(const amodule: tmsecomponent; avalue: integer);
var
 po1: pmoduleinfoty;
begin
 po1:= fmodules.findmodule(tmsecomponent(amodule));
 if po1 <> nil then begin
  po1^.designform.bounds_x:= avalue;
 end;
end;

procedure tdesigner.setmoduley(const amodule: tmsecomponent; avalue: integer);
var
 po1: pmoduleinfoty;
begin
 po1:= fmodules.findmodule(tmsecomponent(amodule));
 if po1 <> nil then begin
  po1^.designform.bounds_y:= avalue;
 end;
end;

function tdesigner.checkmodule(const filename: msestring): pmoduleinfoty;
begin
 result:= fmodules.findmodule(filename);
 if result = nil then begin
  raise exception.Create('Module "'+filename+'" not found');
 end;
end;

procedure tdesigner.modulechanged(const amodule: pmoduleinfoty);
begin
 componentmodified(amodule^.instance);
end;

function tdesigner.changemodulename(const filename: msestring; const avalue: string): string;
var
 po1: pmoduleinfoty;
 str1: string;
begin
 po1:= checkmodule(filename);
 str1:= po1^.instance.name;
 po1^.instance.Name:= avalue;
 result:= po1^.instance.name;
 if result <> str1 then begin
  modulechanged(po1);
 end;
end;

function tdesigner.componentcanedit: boolean;
begin
 result:= (fcomponenteditor <> nil) and (cs_canedit in fcomponenteditor.state);
end;
  
procedure tdesigner.checkident(const aname: string);
begin
 if not isvalidident(aname) or (aname = '') then begin
  raise exception.Create('Invalid name "'+aname+'".');
 end;
end;

function tdesigner.changemoduleclassname(const filename: msestring; const avalue: string): string;
var
 po1: pmoduleinfoty;
begin
 po1:= checkmodule(filename);
 checkident(avalue);
 designnotifications.moduleclassnamechanging(idesigner(self),po1^.instance,avalue);
 po1^.moduleclassname:= avalue;
 result:= po1^.moduleclassname;
 modulechanged(po1);
end;

function tdesigner.changeinstancevarname(const filename: msestring; const avalue: string): string;
var
 po1: pmoduleinfoty;
begin
 po1:= checkmodule(filename);
 checkident(avalue);
 designnotifications.instancevarnamechanging(idesigner(self),po1^.instance,avalue);
 po1^.instancevarname:= avalue;
 result:= po1^.instancevarname;
 modulechanged(po1);
end;

function tdesigner.checksubmodule(const ainstance: tcomponent; 
              out aancestormodule: pmoduleinfoty): boolean;
begin
 aancestormodule:= modules.findmodule(
          fdescendentinstancelist.findancestor(ainstance));
 result:= aancestormodule <> nil;
end;

procedure tdesigner.componentmodified(const component: tobject);
begin
 if component <> nil then begin
  fmodules.componentmodified(component);
 end;
 if fcomponentmodifying = 0 then begin
  postcomponentevent(tcomponentevent.create(component,ord(me_componentmodified),false));
 end
end;

procedure tdesigner.begincomponentmodify;
begin
 inc(fcomponentmodifying);
end;

procedure tdesigner.endcomponentmodify;
begin
 dec(fcomponentmodifying);
end;

function tdesigner.copycomponent(const source: tmsecomponent;
                            const root: tmsecomponent): tmsecomponent;
var
 po1: pmoduleinfoty;
begin
 beginsubmodulecopy;
 if root <> nil then begin
  po1:= fmodules.findmodule(root);
  if po1 <> nil then begin
   buildmethodtable(po1);
  end;
 end
 else begin
  po1:= nil;
 end;
 try
  result:= tmsecomponent(mseclasses.copycomponent(source,nil,
            {$ifdef FPC}@{$endif}findancestor,
            {$ifdef FPC}@{$endif}findcomponentclass,
            {$ifdef FPC}@{$endif}createcomponent));
  if po1 = nil then begin
   docopymethods(source,result);
  end;
 finally
  endsubmodulecopy;
  if po1 <> nil then begin
   releasemethodtable(po1);
  end;
 end;
end;

procedure tdesigner.revert(const acomponent: tcomponent);
var
 comp1: tcomponent;
 po1: pancestorinfoty;
 po2: pmoduleinfoty;
 bo1: boolean;
 pos1: pointty;
begin
 comp1:= nil;
 if csinline in acomponent.componentstate then begin
  po1:= fdescendentinstancelist.finddescendentinfo(acomponent);
  if po1 <> nil then begin
   po2:= fmodules.findmodule(tmsecomponent(acomponent.owner));
   if po2 <> nil then begin
    bo1:= acomponent is twidget;
    if bo1 then begin
     pos1:= twidget(acomponent).pos;
    end;
    fdescendentinstancelist.revert(po1,po2);
    if bo1 then begin
     twidget(po1^.descendent).pos:= pos1;
    end;
   end;
  end;
 end
 else begin
  if csancestor in acomponent.componentstate then begin
   comp1:= fdescendentinstancelist.findancestor(acomponent.owner);
   if comp1 <> nil then begin
    comp1:= comp1.findcomponent(acomponent.name);
    if comp1 <> nil then begin
     refreshancestor(acomponent,comp1,comp1,true,
      {$ifdef FPC}@{$endif}findancestor,
      {$ifdef FPC}@{$endif}findcomponentclass,
      {$ifdef FPC}@{$endif}createcomponent);
     dorefreshmethods(acomponent,comp1,acomponent);
    end;
   end;
  end;
 end;
 if comp1 <> nil then begin
  componentmodified(comp1);
 end;
end;

function tdesigner.getreferencingmodulenames(const amodule: pmoduleinfoty): stringarty;
var
 int1,int2: integer;
begin
 result:= nil;
 for int1:= 0 to fmodules.count - 1 do begin
  with fmodules[int1]^ do begin
   for int2:= 0 to high(referencedmodules) do begin
    if referencedmodules[int2] = amodule^.instance.Name then begin
     additem(result,instance.name);
    end;
   end;
  end;
 end;
end;

function tdesigner.checkcanclose(const amodule: pmoduleinfoty;
                  out references:  string): boolean;
begin
 references:= concatstrings(getreferencingmodulenames(amodule),',');
 result:= references = '';
end;

procedure tdesigner.findancestor(Writer: TWriter; Component: TComponent;
              const aName: string; var Ancestor, RootAncestor: TComponent);
begin
 if (csinline in component.ComponentState) then begin
  if (ancestor = nil) then begin
   ancestor:= fdescendentinstancelist.findancestor(component);
   rootancestor:= ancestor;
  end;
 end
 else begin
  if (component.owner <> nil) and 
          not (csinline in component.owner.componentstate) then begin
   ancestor:= nil; //has name duplicate
  end;
 end; 
end;

procedure tdesigner.getmethodinfo(const method: tmethod; out moduleinfo: pmoduleinfoty;
                      out methodinfo: pmethodinfoty);
var
 int1: integer;
begin
 moduleinfo:= fmodules.findmodulebyinstance(tcomponent(method.data));
 if moduleinfo <> nil then begin
  with moduleinfo^.methods do begin
   methodinfo:= findmethod(method.Code);
  end;
 end
 else begin
  methodinfo:= nil;
  for int1:= 0 to fmodules.count - 1 do begin
   methodinfo:= fmodules[int1]^.methods.findmethod(method.code);
   if methodinfo <> nil then begin
    moduleinfo:= fmodules[int1];
    break;
   end;
  end;
 end;
end;

procedure tdesigner.changemethodname(const method: tmethod; newname: string;
                              const atypeinfo: ptypeinfo);
var
 po1: pmethodinfoty;
 po2: pmoduleinfoty;
 oldname: string;
begin
 if not isvalidident(newname) then begin
  raise exception.Create('Invalid methodname '''+newname+'''.');
 end;
 getmethodinfo(method,po2,po1);
 if po2 = nil then begin
  raise exception.Create('Module not found');
 end;
 if po1 = nil then begin
  raise exception.Create('Method not found');
 end;
 oldname:= po1^.name;
 po1^.name:= newname;
 po2^.modified:= true;
 designnotifications.methodnamechanged(fdesigner,po2^.instance,newname,oldname,atypeinfo);
end;

procedure tdesigner.setactivemodule(const adesignform: tmseform);
var
 po1: pmoduleinfoty;
begin
 if adesignform <> nil then begin
  po1:= fmodules.findform(adesignform);
 end
 else begin
  po1:= nil;
 end;
 floadingmodulepo:= po1;
 if po1 <> factmodulepo then begin
  if factmodulepo <> nil then begin
   designnotifications.moduledeactivated(idesigner(self),factmodulepo^.instance);
  end;
  if po1 <> nil then begin
   factmodulepo:= po1;
//   checkobjectinspector; //ev. create
   designnotifications.moduleactivated(idesigner(self),factmodulepo^.instance);
  end
  else begin
   factmodulepo:= nil;
  end;
 end;
end;

function tdesigner.sourcenametoformname(const aname: filenamety): filenamety;
begin
 result:= replacefileext(aname,formfileext);
end;

procedure tdesigner.moduledestroyed(const amodule: pmoduleinfoty);
var
 int1: integer;
begin
 if amodule = factmodulepo then begin
  setactivemodule(nil);
 end;
 for int1:= 0 to amodule^.components.fcount - 1 do begin
  fselections.remove(amodule^.components.next^.instance);
 end;
 designnotifications.selectionchanged(idesigner(self),
       idesignerselections(fselections));
 designnotifications.moduledestroyed(idesigner(self),amodule^.instance);
end;

procedure tdesigner.addancestorinfo(const ainstance,aancestor: tmsecomponent);
begin
 fdescendentinstancelist.add(ainstance,aancestor,fsubmodulelist);
end;

procedure tdesigner.showformdesigner(const amodule: pmoduleinfoty);
begin
 amodule^.designform.activate;
end;

procedure tdesigner.showastext(const amodule: pmoduleinfoty);
var
 mstr1: filenamety;
 bo1: boolean;
begin
 if (amodule <> nil) then begin
  mstr1:= amodule^.filename;
  bo1:= amodule^.backupcreated;
  if closemodule(amodule,true) then begin
   designnotifications.showobjecttext(idesigner(self),mstr1,bo1);
  end;
 end;
end;

function tdesigner.checkmethodtypes(const amodule: pmoduleinfoty;
                                    const init: boolean): boolean;
                                      //false on cancel
var
 classinf: pclassinfoty;
 comp1: tcomponent;
 
 procedure doinit(const instance: tobject);
 var
  ar1: propinfopoarty;
  int1,int2: integer;
  method1: tmethod;
  po1: pmethodinfoty;
  obj1: tobject;
  po2: pprocedureinfoty;
  mr1: modalresultty;
 begin
  ar1:= getpropinfoar(instance);
  for int1:= 0 to high(ar1) do begin
   case ar1[int1]^.proptype^.kind of
    tkmethod: begin
     method1:= getmethodprop(instance,ar1[int1]);
     if method1.code <> nil then begin
      po1:= amodule^.methods.findmethod(method1.code);
      if po1 <> nil then begin
       if init then begin
        po1^.typeinfo:= ar1[int1]^.proptype{$ifndef FPC}^{$endif};
       end
       else begin
        po2:= classinf^.procedurelist.finditembyname(po1^.name);
        mr1:= mr_none;
        if po2 = nil then begin
         mr1:= askyesnocancel('Method '+amodule^.instance.name+'.'+po1^.name+' ('+
                 comp1.name+'.'+ar1[int1]^.name+') does not exist.'+lineend+
                 'Do you wish to delete the event?','WARNING');
        end
        else begin
         if not parametersmatch(po1^.typeinfo,po2^.params) then begin
          mr1:= askyesnocancel('Method '+amodule^.instance.name+'.'+po1^.name+' ('+
                 comp1.name+'.'+ar1[int1]^.name+') has different parameters.'+lineend+
                 'Do you wish to delete the event?','WARNING');
         end;
        end;
        if mr1 = mr_yes then begin
         setmethodprop(instance,ar1[int1],nullmethod);
         modulechanged(amodule);
        end;
        result:= mr1 <> mr_cancel;
       end;
      end;
     end;
    end;
    tkclass: begin
     obj1:= getobjectprop(instance,ar1[int1]);
     if (obj1 <> nil) and (not (obj1 is tcomponent) or 
               (cssubcomponent in tcomponent(obj1).componentstyle)) then begin
      doinit(obj1);
      if obj1 is tpersistentarrayprop then begin
       with tpersistentarrayprop(obj1) do begin
        for int2:= 0 to count - 1 do begin
         doinit(items[int2]);
         if not result then begin
          break;
         end;
        end;
       end;
      end
      else begin
       if obj1 is tcollection then begin
        with tcollection(obj1) do begin
         for int2:= 0 to count - 1 do begin
          doinit(items[int2]);
          if not result then begin
           break;
          end;
         end;
        end;
       end;
      end;
     end;
    end;
   end;
   if not result then begin
    break;
   end;
  end;
 end;

var
 int1: integer;
 mstr1: msestring;
 po3: punitinfoty;
begin
 result:= true;
 if not init then begin
  mstr1:= replacefileext(amodule^.filename,pasfileext);
  if sourcefo.findsourcepage(mstr1) = nil then begin
   exit;
  end;
  po3:= sourceupdater.updateformunit(amodule^.filename,true);
  if po3= nil then begin
   exit;
  end;
  classinf:= findclassinfobyinstance(amodule^.instance,po3);
  if classinf = nil then begin
   exit;
  end;
 end;
 with amodule^ do begin
  for int1:= 0 to components.count - 1 do begin
   comp1:= components.next^.instance;
   doinit(comp1);
   if not result then begin
    break;
   end;
  end;
 end;
end;

procedure tdesigner.dofixup;
begin
 RegisterFindGlobalComponentProc({$ifdef FPC}@{$endif}getglobalcomponent);
 try
  globalfixupreferences;
 finally
  unregisterFindGlobalComponentProc({$ifdef FPC}@{$endif}getglobalcomponent);
 end;
end;

function tdesigner.loadformfile(filename: msestring): pmoduleinfoty;

var
 module: tmsecomponent;
 loadedsubmodulesindex: integer;
  
 procedure dodelete;
 var
  int1: integer;
 begin
  removefixupreferences(module,'');
  for int1:= high(floadedsubmodules) downto loadedsubmodulesindex+1 do begin
   removefixupreferences(floadedsubmodules[int1],'');
  end;
  fmodules.delete(fmodules.findmodule(result)); //remove added module
  module.Free;
  module:= nil;
  result:= nil;
 end;
 
var
 moduleclassname1,modulename,designmoduleclassname: string;
 stream1: ttextstream;
 stream2: tmemorystream;
 reader: treader;
 flags: tfilerflags;
 pos: integer;
 rootnames: tstringlist;
 int1: integer;
 wstr1: msestring;
 res1: modalresultty;
 bo1: boolean;
 loadingdesignerbefore: tdesigner;

begin //loadformfile
 filename:= filepath(filename);
 result:= fmodules.findmodule(filename);
 if result = nil then begin
  designnotifications.closeobjecttext(idesigner(self),filename,bo1);
  if bo1 then begin
   exit; //canceled
  end;
  stream1:= ttextstream.Create(filename,fm_read);
  designmoduleclassname:= '';
  try
   stream2:= tmemorystream.Create;
   try
    try
     objecttexttobinary(stream1,stream2);
     stream2.position:= 0;
     reader:= treader.create(stream2,4096);
     try
      with treader1(reader) do begin
      {$ifdef FPC}
       driver.beginrootcomponent;
       driver.begincomponent(flags,pos,moduleclassname1,modulename);
      {$else}
       readsignature;
       ReadPrefix(flags,pos);
       moduleclassname1 := ReadStr;
       modulename := ReadStr;
       {$endif}
       while not endoflist do begin
      {$ifdef FPC}
        if driver.beginproperty = moduleclassnamename then begin
      {$else}
        if readstr = moduleclassnamename then begin
       {$endif}
         designmoduleclassname:= readstring;
         break;
        end
        else begin
         {$ifdef FPC}driver.{$endif}skipvalue;
        end;
       end;
      end;
     finally
      reader.free;
     end;
     stream2.Position:= 0;
     loadingdesignerbefore:= loadingdesigner;
     loadingdesigner:= self;
     begingloballoading;
     try
      try
       result:= fmodules.newmodule(filename,moduleclassname1,modulename,designmoduleclassname);
       module:= result^.instance;
       stream2.Position:= 0;
       reader:= treader.Create(stream2,4096);
       loadedsubmodulesindex:= high(floadedsubmodules);
       inc(fformloadlevel);
       try
        floadingmodulepo:= result;
        lockfindglobalcomponent;
        try
         reader.onfindmethod:= {$ifdef FPC}@{$endif}findmethod;
         reader.onfindcomponentclass:= {$ifdef FPC}@{$endif}findcomponentclass;
         reader.onancestornotfound:= {$ifdef FPC}@{$endif}ancestornotfound;
         reader.oncreatecomponent:= {$ifdef FPC}@{$endif}createcomponent;
         reader.ReadrootComponent(module);
         module.Name:= modulename;
         result^.components.assigncomps(module);
         rootnames:= tstringlist.create;
         getfixupreferencenames(module,rootnames);
         setlength(result^.referencedmodules,rootnames.Count);
         for int1:= 0 to high(result^.referencedmodules) do begin
          result^.referencedmodules[int1]:= rootnames[int1];
         end;
         dofixup;
         while true do begin
          rootnames.clear;
          getfixupreferencenames(module,rootnames);
          if rootnames.Count > 0 then begin
           if assigned(fongetmodulenamefile) then begin
            try
             res1:= mr_cancel;
             fongetmodulenamefile(result,rootnames[0],res1);
             dofixup;
             case res1 of
              mr_ok: begin
              end;
              mr_ignore: begin
               rootnames.Clear;
               break;
              end;
              else begin
               break;
              end;
             end;
            except
             application.handleexception(self);
             break;
            end;
           end
           else begin
            break;
           end;
          end
          else begin
           break;
          end;
         end;
         if module <> nil then begin
          removefixupreferences(module,'');
         end;
         if rootnames.Count > 0 then begin
          wstr1:= rootnames[0];
          for int1:= 1 to rootnames.Count - 1 do begin
           wstr1:= wstr1 + ','+rootnames[int1];
          end;
          rootnames.free;
          raise exception.Create('Unresolved reference to '+wstr1+'.');
         end;
         rootnames.free;
        except
         dodelete;
         raise;
        end;
       finally
        setlength(floadedsubmodules,loadedsubmodulesindex+1);
                     //remove info
        dec(fformloadlevel);
        if fformloadlevel = 0 then begin
         removefixupreferences(nil,'');
        end;
        unlockfindglobalcomponent;
        reader.free;
       end;
       if result <> nil then begin
        result^.designform:= tformdesignerfo.create(nil,self);
        tformdesignerfo(result^.designform).module:= module;
        checkmethodtypes(result,true);
 //       showformdesigner(result);
        result^.modified:= false;
       end;
      finally
       loadingdesigner:= nil;
      end;
      notifygloballoading;
     finally
      loadingdesigner:= loadingdesignerbefore;
      endgloballoading;
     end;
    except
     on e: exception do begin
      e.Message:= 'Can not read formfile "'+filename+'".'+lineend+e.Message;
      raise;
     end;
    end;
   finally
    stream2.Free;
   end;
  finally
   stream1.Free;
  end;
 end;
end; //loadformfile

procedure createbackupfile(const newname,origname: filenamety;
           var backupcreated: boolean; const backupcount: integer);
var
 int1: integer;
 mstr1: filenamety;
 mstr2: filenamety;
begin
 if (backupcount > 0) and not backupcreated and 
      issamefilename(newname,origname) then begin
  backupcreated:= true;
  mstr1:= origname + backupext;
  for int1:= backupcount-1 downto 2 do begin
   mstr2:= mstr1+inttostr(int1-1);
   if findfile(mstr2) then begin
    msefileutils.renamefile(mstr2,mstr1+inttostr(int1));
   end;
  end;
  if backupcount > 1 then begin
   if findfile(mstr1) then begin
    msefileutils.renamefile(mstr1,mstr1+'1');
   end;
  end;
  msefileutils.copyfile(origname,mstr1);
 end;
end;  

procedure tdesigner.buildmethodtable(const amodule: pmoduleinfoty);
begin
 flookupmodule:= amodule;
 with amodule^ do begin
  methodtablebefore:= swapmethodtable(instance,methods.createmethodtable);
 end;
end;

procedure tdesigner.releasemethodtable(const amodule: pmoduleinfoty);
var
 {$ifdef mswindows}
 ca1: cardinal;
 {$endif}
 methodtabpo: ppointer;
begin
 with amodule^ do begin
  swapmethodtable(instance,methodtablebefore);
  methods.releasemethodtable;
 end;
 flookupmodule:= nil;
end;

procedure tdesigner.writemodule(const amodule: pmoduleinfoty;
                                     const astream: tstream);
var
 writer1: twriter;
begin
 buildmethodtable(amodule);
 with amodule^ do begin
  if instance is twidget then begin
   twidget1(instance).fwidgetrect.pos:= designform.pos;
  end
  else begin
   setcomponentpos(instance,designform.pos);
  end;
  writer1:= twriter.create(astream,4096);
  try
   writer1.onfindancestor:= {$ifdef FPC}@{$endif}findancestor;
   writer1.writedescendent(instance,nil);
  finally
   writer1.free;
   releasemethodtable(amodule);
   if instance is twidget then begin
    twidget1(instance).fwidgetrect.pos:= nullpoint;
   end;
  end;
 end;
end;

function tdesigner.saveformfile(const modulepo: pmoduleinfoty;
                 const afilename: msestring; createdatafile: boolean): boolean;
                      //false if aborted
var
 stream1: tmemorystream;
 stream2: tmsefilestream;
 
begin
 if createdatafile and projectoptions.checkmethods 
                       and not checkmethodtypes(modulepo,false) then begin
  result:= false;
  exit;
 end;
 result:= true;
 with modulepo^ do begin
  createbackupfile(afilename,filename,backupcreated,projectoptions.backupfilecount);
  stream1:= tmemorystream.Create;
  try
   writemodule(modulepo,stream1);
   stream2:= tmsefilestream.create(afilename,fm_create);
   try
    stream1.position:= 0;
    objectbinarytotext(stream1,stream2);
   finally
    stream2.Free;
   end;
   if issamefilename(afilename,filename) then begin
    modified:= false;
   end;
   if createdatafile then begin
    formtexttoobjsource(afilename,moduleclassname,'',fobjformat);
   end;
  finally
   stream1.free;
  end;
 end;
end;

function tdesigner.saveall(noconfirm,createdatafile: boolean): modalresultty;
var
 int1: integer;
 po1: pmoduleinfoty;
begin
 result:= mr_none;
 for int1:= 0 to modules.count - 1 do begin
  po1:= modules[int1];
  with po1^ do begin
   if not modified and projectoptions.checkmethods then begin
    if not checkmethodtypes(po1,false) then begin
     result:= mr_cancel;
     exit;
    end;
   end;
   if modified and (result <> mr_noall) and (noconfirm or (result = mr_all) or
                confirmsavechangedfile(filename,result,true)) then begin
    if not saveformfile(po1,filename,createdatafile) then begin
     result:= mr_cancel;
    end;
   end;
   if result in [mr_cancel,mr_noall] then begin
    exit;
   end;
  end;
 end;
end;

function tdesigner.closemodule(const amodule: pmoduleinfoty;
                             const checksave: boolean): boolean; //true if closed
var
 closingmodules: moduleinfopoarty;
 
 procedure dochecksave(const amodule: pmoduleinfoty);
 var
  modalresult: modalresultty;
  int1: integer;
  ar1: stringarty;
  ar2: moduleinfopoarty;
 begin
  ar1:= nil; //compiler warning
  if amodule <> nil then begin
   modalresult:= mr_none;
   for int1:= 0 to high(closingmodules) do begin
    if closingmodules[int1] = amodule then begin
     exit; //already checked;
    end;
   end;
   with amodule^ do begin
    if modified and checksave and
                 confirmsavechangedfile(filename,modalresult,false) then begin
     saveformfile(amodule,filename,true);
    end;
   end;
   result:= modalresult <> mr_cancel;
   if result then begin
    additem(pointerarty(closingmodules),amodule);
    ar1:= getreferencingmodulenames(amodule);
    setlength(ar2,length(ar1));
    for int1:= 0 to high(ar1) do begin
     ar2[int1]:= modules.findmodulebyname(ar1[int1]);
     dochecksave(ar2[int1]);
     if not result then begin
      break;
     end;
    end;
   end;
  end;
 end;
 
var
 int1: integer;
 
begin //closemodule
 result:= false;
 closingmodules:= nil;
 dochecksave(amodule);
 if result then begin
  for int1:= 0 to high(closingmodules) do begin
   if closingmodules[int1] <> nil then begin
    modules.removemoduleinfo(closingmodules[int1]);
   end;
  end;
 end;
end; //closemodule

function tdesigner.modified: boolean;
var
 int1: integer;
begin
 result:= false;
 for int1:= 0 to fmodules.count - 1 do begin
  if modules[int1]^.modified then begin
   result:= true;
   break;
  end;
 end;
end;

procedure tdesigner.NoSelection;
begin
 selectcomponent(nil);
end;

procedure tdesigner.SelectComponent(Instance: Tcomponent);
var
 list: tdesignerselections;
begin
 freeandnil(fcomponenteditor);
 list:= tdesignerselections.create;
 try
  if instance <> nil then begin
   list.Add(instance);
   fcomponenteditor:= componenteditors.geteditorclass(
                componentclassty(instance.classtype)).create(idesigner(self),instance);
  end;
  setselections(idesignerselections(list));
 finally
  list.Free;
 end;
end;

procedure tdesigner.selectionchanged;
begin
 designnotifications.SelectionChanged(idesigner(self),idesignerselections(fselections));
end;

procedure tdesigner.SetSelections(const List: IDesignerSelections);
var
 int1: integer;
 component1: tcomponent;
begin
 for int1:= 0 to fselections.count - 1 do begin
  component1:= fselections[int1];
  if component1 is tmsecomponent then begin
   tmsecomponent1(component1).designselected(false);
  end;
 end;
 fselections.assign(list);
 for int1:= 0 to fselections.count - 1 do begin
  component1:= fselections[int1];
  if component1 is tmsecomponent then begin
   tmsecomponent1(component1).designselected(true);
  end;
 end;
 selectionchanged;
end;
{
procedure tdesigner.checkobjectinspector;
begin
 if objectinspectorfo = nil then begin
  objectinspectorfo:= tobjectinspectorfo.create(nil,self);
 end;
end;
}
procedure tdesigner.showobjectinspector;
begin
// checkobjectinspector;
 objectinspectorfo.activate;
end;

function tdesigner.formfiletoname(const filename: msestring): msestring;
begin
 result:= removefileext(msefileutils.filename(filename));
end;

function tdesigner.getmethod(const aname: string;
               const methodowner: tmsecomponent; const atype: ptypeinfo): tmethod;
begin
 result:= fmodules.findmethodbyname(aname,atype,methodowner);
end;

function tdesigner.getmethodname(const Method: TMethod; const comp: tcomponent): string;
begin
 result:= fmodules.findmethodname(method,comp);
end;

function tdesigner.actmodulepo: pmoduleinfoty;
begin
 result:= factmodulepo;
end;

function tdesigner.getcomponentname(const comp: tcomponent): string;
var
 int1: integer;
 po1: pmoduleinfoty;
begin
 result:= '';
 if comp <> nil then begin
  if comp.Owner = floadingmodulepo^.instance then begin
   result:= comp.name;
  end
  else begin
   for int1:= 0 to fmodules.count - 1 do begin
    po1:= fmodules[int1];
    if issubcomponent(po1^.instance,comp) then begin
     result:= po1^.instancevarname + '.' + getcomponentdispname(comp);
//    if po1^.instance = comp.Owner then begin
//     result:= po1^.instancevarname + '.' + comp.Name;
     break;
    end;
   end;
  end;
 end;
end;

function tdesigner.getcomponentdispname(const comp: tcomponent): string;
                   //returns qualified name
var
 comp1: tcomponent;
begin
 result:= comp.Name;
 comp1:= comp.owner;
 if comp1 <> nil then begin
  while (comp1.owner <> nil) and (comp1.Owner.Owner <> nil) do begin
   result:= comp1.Name + '.' + result;
   comp1:= comp1.Owner;
  end;
 end;
end;

function tdesigner.getcomponent(const aname: string; 
                      const aroot: tcomponent): tcomponent;
var
 strar1: stringarty;
 po1,po2: pmoduleinfoty;
 int1,int2: integer;
 bo1: boolean;
begin
 if floadingmodulepo <> nil then begin
  result:= floadingmodulepo^.components.getcomponent(aname);
  if result = nil then begin
   splitstring(aname,strar1,'.');
   if high(strar1) = 1 then begin
    strar1[0]:= uppercase(strar1[0]);
    for int1:= 0 to fmodules.count - 1 do begin
     po1:= fmodules[int1];
     if stricomp(pchar(po1^.instancevarname),pchar(strar1[0])) = 0 then begin
      result:= po1^.components.getcomponent(strar1[1]);
      if result <> nil then begin
       if (aroot <> nil) and (aroot <> po1^.instance) then begin
        po2:= fmodules.findmodulebyinstance(aroot);
        if po2 <> nil then begin
         bo1:= false;
         for int2:= 0 to high(po2^.referencedmodules) do begin
          if po2^.referencedmodules[int2] = aroot.name then begin
           bo1:= true;
           break;
          end;
         end;
         if not bo1 then begin
          additem(po2^.referencedmodules,po1^.instance.name);
         end;
        end;
       end;
       break;
      end;
     end;
    end;
   end;
  end;
 end
 else begin
  result:= nil;
 end;
end;

function tdesigner.getcomponentlist(
             const acomponentclass: tcomponentclass): componentarty;
var
 int1,int2: integer;
 comp1: tcomponent;
begin
 if floadingmodulepo <> nil then begin
  with floadingmodulepo^.components do begin
   setlength(result,count);
   int2:= 0;
   for int1:= 0 to high(result) do begin
    comp1:= next^.instance;
    if comp1.InheritsFrom(acomponentclass) then begin
     result[int2]:= comp1;
     inc(int2);
    end;
   end;
  end;
  setlength(result,int2);
 end
 else begin
  result:= nil;
 end;
end;

function compcompname(const l,r): integer;
begin
 result:= ord(msestring(l)[1])-ord(msestring(r)[1]);
 if result = 0 then begin
  result:= countchars(msestring(l),msechar('.')) -
                countchars(msestring(r),msechar('.'));
  if result = 0 then begin
   result:= msestringicomp(msestring(l),msestring(r));
  end;
 end;
end;

function tdesigner.getcomponentnamelist(const acomponentclass: tcomponentclass;
                            const includeinherited: boolean;
                            const aowner: tcomponent = nil): msestringarty;
var
 int1,int2: integer;
 comp1: tcomponent;
 str1: msestring;
 po1: pmoduleinfoty;
 acount: integer;
 ar1: componentarty;
begin
 result:= nil;
 acount:= 0;
 for int1:= 0 to fmodules.count - 1 do begin
  po1:= fmodules[int1];
  if po1 = floadingmodulepo then begin
   str1:= ' ';
  end
  else begin
   str1:= 'z'+po1^.instancevarname + '.';
  end;
  with po1^.components do begin
   for int2:= 0 to count - 1 do begin
    comp1:= next^.instance;
    if comp1.InheritsFrom(acomponentclass) then begin
     if ((aowner = nil) or (aowner = comp1.owner)) and 
              (includeinherited or 
              (comp1.componentstate * [csinline,csancestor] = [])) then begin
      additem(result,str1+getcomponentdispname(comp1),acount);
     end;
    end;
   end;
  end;
 end;
 setlength(result,acount);
 sortarray(result,{$ifdef FPC}@{$endif}compcompname);
 for int1:= 0 to high(result) do begin
  result[int1]:= copy(result[int1],2,bigint);
 end;
end;

function tdesigner.getmodules: tmodulelist;
begin
 result:= fmodules;
end;

function tdesigner.findcomponentmodule(const acomponent: tcomponent): pmoduleinfoty;
var
 int1: integer;
 po1: pmoduleinfoty;
begin
 result:= nil;
 for int1:= 0 to fmodules.count-1 do begin
  po1:= fmodules[int1];
  if po1^.components.find(acomponent) <> nil then begin
   result:= po1;
   break;
  end;
 end;
end;

procedure tdesigner.validaterename(const acomponent: tcomponent; const curname,NewName: string);
var
 po1: pmoduleinfoty;
begin
 po1:= findcomponentmodule(acomponent);
 if po1 <> nil then begin
  if newname = '' then begin
   raise exception.Create('Invalid component name,');
  end;
  if acomponent.name <> newname then begin
   po1^.components.namechanged(acomponent,newname);
   designnotifications.componentnamechanging(idesigner(self),po1^.instance,acomponent,newname);
  end;
 end;
end;

function tdesigner.getclassname(const comp: tcomponent): string;
                   //returns submoduleclass if appropriate
begin
 result:= fdescendentinstancelist.getclassname(comp);
end;

function tdesigner.getcomponenteditor: icomponenteditor;
begin
 if fcomponenteditor = nil then begin
  result:= nil;
 end
 else begin
  result:= icomponenteditor(fcomponenteditor);
 end;
end;

{ tcomponentslink }

procedure tcomponentslink.notification(acomponent: tcomponent;
  operation: toperation);
begin
 if operation = opremove then begin
  fowner.destroynotification(acomponent);
 end;
 inherited;
end;

initialization
 fdesigner:= tdesigner.create;
finalization
 fdesigner.Free;
end.

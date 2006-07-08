{ MSEgui Copyright (c) 1999-2006 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit msedesignintf;

{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface
uses
 Classes,msegraphutils,mselist,Sysutils,Typinfo,msebitmap,
 msetypes,msestrings,msegraphics,msegui,
 mseclasses,mseforms,msestat;
const
 defaultmoduleclassname = 'tmseform';
type
 initcomponentprocty = procedure(acomponent: tcomponent; aparent: tcomponent) of object;

 componentclassinfoty = record
  classtyp: tcomponentclass;
  icon: integer;
  page: integer;
 end;
 pcomponentclassinfoty = ^componentclassinfoty;

 tcomponentclasslist = class(torderedrecordlist)
  private
   fselectedclass: tcomponentclass;
   fimagelist: timagelist;
   fpagenames: msestringarty;
   fpagecomporders: integerararty;
   function getpagecomporders(const index: integer): integerarty;
   procedure setpagecomporders(const index: integer;
      const Value: integerarty);
   procedure checkpageindex(const index: integer);
  protected
   function addpage(const pagename: msestring): integer;
   function getcompareproc: compareprocty; override;
   procedure compare(const l,r; out result: integer);
   function componentcounts: integerarty;
  public
   constructor create;
   destructor destroy; override;
   function indexof(const value: tcomponentclass): integer;  //-1 if not found
   function add(const value: componentclassinfoty): integer;
           //-1 if allready registred
   function itempo(const index: integer): pcomponentclassinfoty;
   procedure registercomponents(const page: msestring;
                 const componentclasses: array of tcomponentclass);
   function pagehigh: integer;
   function pagenames: msestringarty;
   property pagecomporders[const index: integer]: integerarty
                  read getpagecomporders write setpagecomporders;
   procedure drawcomponenticon(const acomponent: tcomponent;
              const canvas: tcanvas; const dest: rectty);
   procedure updatestat(const filer: tstatfiler);
   property selectedclass: tcomponentclass read fselectedclass write fselectedclass;
   property imagelist: timagelist read fimagelist;
 //nil for unselect
 end;

 idesignerselections = interface
  function add(const item: tcomponent): integer;
  function equals(const list: idesignerselections): boolean;
  function get(index: integer): tcomponent;
  function getcount: integer;
  function getarray: componentarty;
  property count: integer read getcount;
  property items[index: integer]: tcomponent read get; default;
 end;

 componenteditorstatety = (cs_canedit);
 componenteditorstatesty = set of componenteditorstatety;

 icomponenteditor = interface
  procedure edit;
  function state: componenteditorstatesty;
 end;

 idesigner = interface
  procedure componentmodified(const component: tobject);
  function createcurrentcomponent(const module: tmsecomponent): tcomponent;
  function hascurrentcomponent: boolean;
  procedure addcomponent(const module: tmsecomponent; const acomponent: tcomponent);
  procedure deleteselection(adoall: Boolean = False);
  procedure deletecomponent(const acomponent: tcomponent);
  procedure clearselection;
  procedure selectcomponent(instance: tcomponent);
  procedure setselections(const list: idesignerselections);
  procedure noselection;
  function getmethod(const name: string; const methodowner: tmsecomponent;
                      const atype: ptypeinfo): tmethod;
  function getmethodname(const method: tmethod; const comp: tcomponent): string;
  procedure changemethodname(const method: tmethod; newname: string;
                             const atypeinfo: ptypeinfo);
  function createmethod(const name: string; const module: tmsecomponent;
                 const atype: ptypeinfo): tmethod;
  function getcomponentname(const comp: tcomponent): string;
                   //returns qualified name
  procedure validaterename(const acomponent: tcomponent; const curname, newname: string);
  function getcomponentdispname(const comp: tcomponent): string;
                   //returns qualified name into root
  function getclassname(const comp: tcomponent): string;
                   //returns submoduleclass if appropriate
  function getcomponent(const aname: string; const aroot: tcomponent): tcomponent;
                   //handles qualified names for foreign forms
  function componentcanedit: boolean;
  function getcomponenteditor: icomponenteditor;
  function getcomponentlist(const acomponentclass: tcomponentclass): componentarty;
  function getcomponentnamelist(const acomponentclass: tcomponentclass;
                          const includeinherited: boolean;
                          const aowner: tcomponent = nil): msestringarty;
  procedure setactivemodule(const adesignform: tmseform);
  procedure setmodulex(const amodule: tmsecomponent; avalue: integer);
  procedure setmoduley(const amodule: tmsecomponent; avalue: integer);
 end;

 idesignnotification = interface
  procedure itemdeleted(const adesigner: idesigner;
              const amodule: tmsecomponent; const aitem: tcomponent);
  procedure iteminserted(const adesigner: idesigner;
              const amodule: tmsecomponent; const aitem: tcomponent);
  procedure itemsmodified(const adesigner: idesigner; const aitem: tobject);
                      //nil for undefined aitem
  procedure componentnamechanging(const adesigner: idesigner;
                    const amodule: tmsecomponent; const aitem: tcomponent;
                    const newname: string);
  procedure moduleclassnamechanging(const adesigner: idesigner;
                    const amodule: tmsecomponent; const newname: string);
  procedure instancevarnamechanging(const adesigner: idesigner;
                    const amodule: tmsecomponent; const newname: string);
  procedure selectionchanged(const adesigner: idesigner;
                    const aselection: idesignerSelections);

  procedure moduleactivated(const adesigner: idesigner;
                          const amodule: tmsecomponent);
  procedure moduledeactivated(const adesigner: idesigner;
                          const amodule: tmsecomponent);
  procedure moduledestroyed(const adesigner: idesigner;
                          const amodule: tmsecomponent);
  procedure methodcreated(const adesigner: idesigner;
                          const amodule: tmsecomponent;
                          const aname: string; const atype: ptypeinfo);
  procedure methodnamechanged(const adesigner: idesigner;
                          const amodule: tmsecomponent;
                          const newname,oldname: string; const atypeinfo: ptypeinfo);
  procedure showobjecttext(const adesigner: idesigner;
                 const afilename: filenamety; const backupcreated: boolean);
  procedure closeobjecttext(const adesigner: idesigner;
                      const afilename: filenamety; var cancel: boolean);
 end;

 selectedinfoty = record
  instance: tcomponent;
 end;
 pselectedinfoty = ^selectedinfoty;
 
 objinfoty = record
  owner: tcomponent;
  parent: twidget;
  objtext: string;
 end;
 objinfoarty = array of objinfoty;

 tdesignerselections = class(trecordlist,idesignerselections)
  private
   fupdating: integer;
   factcomp: tcomponent;
   function Getitems(const index: integer): tcomponent;
   procedure Setitems(const index: integer; const Value: tcomponent);
   procedure dosetactcomp(component: tcomponent);
   procedure doadd(component: tcomponent);
  protected
   procedure dochanged; virtual;
   function getrecordsize: integer; virtual;
  public
   constructor create;
   procedure change; virtual;
   procedure beginupdate;
   procedure endupdate;
    // idesignerselections
   function Add(const Item: Tcomponent): Integer;
   function Equals(const List: IDesignerSelections): Boolean;
   function Get(Index: Integer): Tcomponent;
   function GetCount: Integer;
   function getarray: componentarty;

   function getobjinfoar: objinfoarty;   
   function getobjecttext: string;
   function pastefromobjecttext(const aobjecttext: string; 
           aowner,aparent: tcomponent; initproc: initcomponentprocty): integer;
                  //returns count of added components
   procedure copytoclipboard;
   function pastefromclipboard(aowner,aparent: tcomponent;
                             initproc: initcomponentprocty): integer;
                  //returns count of added components

   function itempo(const index: integer): pselectedinfoty;
   function indexof(const ainstance: tcomponent): integer;
   function remove(const ainstance: tcomponent): integer; virtual;
   procedure assign(const source: idesignerselections);
   property items[const index: integer]: tcomponent
              read Getitems write Setitems; default;
   function isembedded(const component: tcomponent): boolean;
                 //true if subchild of another selected component
 end;

 tdesignnotifications = class(tpointerlist)
  public
   procedure ItemDeleted(const ADesigner: IDesigner; const amodule: tmsecomponent;
                               const AItem: tcomponent);
   procedure ItemInserted(const ADesigner: IDesigner; const amodule: tmsecomponent;
                             const AItem: tcomponent);
   procedure ItemsModified(const ADesigner: IDesigner; const aitem: tobject);
                       //nil for undefined aitem
   procedure componentnamechanging(const adesigner: idesigner;
                    const amodule: tmsecomponent; const aitem: tcomponent;
                    const newname: string);
   procedure moduleclassnamechanging(const adesigner: idesigner;
                    const amodule: tmsecomponent; const newname: string);
   procedure instancevarnamechanging(const adesigner: idesigner;
                    const amodule: tmsecomponent; const newname: string);
   procedure SelectionChanged(const ADesigner: IDesigner;
                      const ASelection: IDesignerSelections);
   procedure moduleactivated(const adesigner: idesigner;
                          const amodule: tmsecomponent);
   procedure moduledeactivated(const adesigner: idesigner;
                          const amodule: tmsecomponent);
   procedure moduledestroyed(const adesigner: idesigner;
                          const amodule: tmsecomponent);
   procedure methodcreated(const adesigner: idesigner;
                          const amodule: tmsecomponent;
                          const aname: string; const atype: ptypeinfo);
   procedure methodnamechanged(const adesigner: idesigner;
                          const amodule: tmsecomponent;
                          const newname,oldname: string; const atypeinfo: ptypeinfo);
   procedure showobjecttext(const adesigner: idesigner;
               const afilename: filenamety; const backupcreated: boolean);
   procedure closeobjecttext(const adesigner: idesigner; 
                 const afilename: filenamety; out cancel: boolean);
   
   procedure Registernotification(const DesignNotification: IDesignNotification);
   procedure Unregisternotification(const DesignNotification: IDesignNotification);
 end;
 
 unitgroupinfoty = record
  dependents: stringarty;
  group: stringarty;
 end;
 punitgroupinfoty = ^unitgroupinfoty;
 
 tunitgroups = class(trecordlist)
  protected
   procedure finalizerecord(var item); override;
   procedure copyrecord(var item); override;
  public
   constructor create;
   procedure registergroups(const adependents: array of string;
                                      const agroup: array of string);
   function getneededunits(const unitname: string): stringarty;
 end;

 createdesignmodulefuncty = function(const aclass: tclass;
                                 const aclassname: pshortstring): tmsecomponent;
 designmoduleinfoty = record
  classtype: tcomponentclass;
  createfunc: createdesignmodulefuncty;
 end;
 designmoduleinfoarty = array of designmoduleinfoty;

procedure registercomponents(const page: msestring;
                 const componentclasses: array of tcomponentclass);
function registeredcomponents: tcomponentclasslist;
function unitgroups: tunitgroups;
procedure registerunitgroup(const adependents,agroup: array of string);

procedure registerdesignmoduleclass(const aclass: tcomponentclass;
                     acreatefunc: createdesignmodulefuncty);
function createdesignmodule(designmoduleclassname: string;
                           const aclassname: pshortstring): tmsecomponent;

function designnotifications: tdesignnotifications;

procedure setcomponentpos(const component: tcomponent; const pos: pointty);
function getcomponentpos(const component: tcomponent): pointty;

implementation
uses
 msesysutils,msestream,msewidgets,msedatalist,rtlconsts;
// msedesigner;
type
 tcomponent1 = class(tcomponent);
var
 adesignnotifications: tdesignnotifications;
 aregisteredcomponents: tcomponentclasslist;
 aregistereddesignmoduleclasses: designmoduleinfoarty;
 aunitgroups: tunitgroups;

function createdesignmodule(designmoduleclassname: string;
                                  const aclassname: pshortstring): tmsecomponent;
var
 int1: integer;
begin
 if designmoduleclassname = '' then begin
  designmoduleclassname:= defaultmoduleclassname;
 end;
 designmoduleclassname:= uppercase(designmoduleclassname);
 for int1:= 0 to high(aregistereddesignmoduleclasses) do begin
  with aregistereddesignmoduleclasses[int1] do begin
   if uppercase(classtype.classname) = designmoduleclassname then begin
    result:= createfunc(classtype,aclassname);
    exit;
   end;
  end;
 end;
 raise exception.Create('Unknown moduleclass for "'+ aclassname^ +'": "'+
              designmoduleclassname+'".');
end;

procedure registerdesignmoduleclass(const aclass: tcomponentclass;
              acreatefunc: createdesignmodulefuncty);
var
 int1: integer;
begin
 for int1:= 0 to high(aregistereddesignmoduleclasses) do begin
  with aregistereddesignmoduleclasses[int1] do begin
   if classtype = aclass then begin
    createfunc:= createfunc;
    exit;
   end;
  end;
 end;
 registerclass(aclass);
 setlength(aregistereddesignmoduleclasses,high(aregistereddesignmoduleclasses)+2);
 with aregistereddesignmoduleclasses[high(aregistereddesignmoduleclasses)] do begin
  classtype:= aclass;
  createfunc:= acreatefunc;
 end;
end;


procedure setcomponentpos(const component: tcomponent; const pos: pointty);
var
 lo1: longint;
begin
 {$ifdef FPC} //fpbug
 longrec(lo1).hi:= pos.x;
 longrec(lo1).lo:= pos.y;
 {$else}
 longrec(lo1).lo:= pos.x;
 longrec(lo1).hi:= pos.y;
 {$endif}
 component.designinfo:= lo1;
end;

function getcomponentpos(const component: tcomponent): pointty;
begin
 {$ifdef FPC} //fpbug
 result.x:= smallint(longrec(component.DesignInfo).hi);
 result.y:= smallint(longrec(component.DesignInfo).lo);
 {$else}
 result.x:= smallint(longrec(component.DesignInfo).Lo);
 result.y:= smallint(longrec(component.DesignInfo).hi);
 {$endif}
end;

function registeredcomponents: tcomponentclasslist;
begin
 if aregisteredcomponents = nil then begin
  aregisteredcomponents:= tcomponentclasslist.create;
 end;
 result:= aregisteredcomponents;
end;

function unitgroups: tunitgroups;
begin
 if aunitgroups = nil then begin
  aunitgroups:= tunitgroups.create;
 end;
 result:= aunitgroups;
end;

function designnotifications: tdesignnotifications;
begin
 result:= adesignnotifications;
end;

procedure registercomponents(const page: msestring;
                 const componentclasses: array of tcomponentclass);
begin
 registeredcomponents.registercomponents(page,componentclasses);
end;

procedure registerunitgroup(const adependents,agroup: array of string);
begin
 unitgroups.registergroups(adependents,agroup);
end;

procedure registerdesignmodule(const name: string;
                                      createfunc: createdesignmodulefuncty);
begin
end;

{ tcomponentclasslist }

constructor tcomponentclasslist.create;
begin
 fimagelist:= timagelist.create(nil);
 fimagelist.size:= makesize(24,24);
 inherited create(sizeof(componentclassinfoty));
end;

destructor tcomponentclasslist.destroy;
begin
 fimagelist.Free;
 inherited;
end;

function tcomponentclasslist.add(const value: componentclassinfoty): integer;
begin
 if indexof(value.classtyp) < 0 then begin
  result:= inherited add(value);
 end
 else begin
  result:= -1;
 end;
end;

procedure tcomponentclasslist.registercomponents(const page: msestring;
                 const componentclasses: array of tcomponentclass);
var
 info: componentclassinfoty;
 int1: integer;
 bitmap: tbitmapcomp;
 class1: tclass;
 pagenr: integer;
begin
 pagenr:= addpage(page);
 bitmap:= tbitmapcomp.create(nil);
 try
  if fimagelist.count = 0 then begin
   bitmap.name:= 'TComponent';
   initmsecomponent(bitmap,nil);
   bitmap.bitmap.automask;
   fimagelist.addimage(bitmap.bitmap);
  end;
  with info do begin
   for int1:= 0 to high(componentclasses) do begin               
    classtyp:= componentclasses[int1];
    page:= pagenr;
    icon:= 0;
    class1:= classtyp;
    while class1 <> nil do begin
     bitmap.name:= class1.classname;
     if initmsecomponent(bitmap,nil) then begin
      bitmap.bitmap.automask;
      icon:= fimagelist.addimage(bitmap.bitmap);
      break;
     end;
     class1:= class1.ClassParent;
    end;
    classes.registerclass(info.classtyp);
    add(info);
   end;
  end;
 finally
  bitmap.Free;
 end;
end;

function tcomponentclasslist.indexof(
  const value: tcomponentclass): integer;
begin
 result:= inherited indexof(value);
end;

function tcomponentclasslist.itempo(
  const index: integer): pcomponentclassinfoty;
begin
 result:= pcomponentclassinfoty(getitempo(index));
end;

function tcomponentclasslist.addpage(const pagename: msestring): integer;
var
 int1: integer;
begin
 for int1:= 0 to high(fpagenames) do begin
  if fpagenames[int1] = pagename then begin
   result:= int1;
   exit;
  end;
 end;
 setlength(fpagenames,length(fpagenames) + 1);
 setlength(fpagecomporders,length(fpagenames));
 result:= high(fpagenames);
 fpagenames[result]:= pagename;
end;

function tcomponentclasslist.pagenames: msestringarty;
begin
 result:= fpagenames;
end;

function tcomponentclasslist.pagehigh: integer;
begin
 result:= high(fpagenames);
end;

procedure tcomponentclasslist.drawcomponenticon(
  const acomponent: tcomponent; const canvas: tcanvas; const dest: rectty);
var
 int1: integer;
begin
 int1:= indexof(tcomponentclass(acomponent.classtype));
 if int1 >= 0 then begin
  fimagelist.paint(canvas,dest, itempo(int1)^.icon);
 end;
end;

function tcomponentclasslist.componentcounts: integerarty;
var
 int1: integer;
begin
 setlength(result,length(fpagenames));
 for int1:= 0 to count - 1 do begin
  with itempo(int1)^ do begin
   if page <= high(result) then begin
    inc(result[page]);
   end;
  end;
 end;
end;

procedure tcomponentclasslist.updatestat(const filer: tstatfiler);
var
 int1,int2: integer;
 ar1,ar2,ar3: integerarty;
begin
 ar1:= nil; //compiler warning
 ar2:= nil; //compiler warning
 filer.setsection('componentpalette');
 if filer.iswriter then begin
  for int1:= 0 to high(fpagecomporders) do begin
   tstatwriter(filer).writearray('order'+inttostr(int1),fpagecomporders[int1]);
  end;
 end
 else begin
  ar2:= componentcounts;
  for int1:= 0 to high(fpagecomporders) do begin
   ar1:= tstatreader(filer).readarray('order'+inttostr(int1),integerarty(nil));
   if ar1 <> nil then begin
    if length(ar1) <> ar2[int1] then begin
     ar1:= nil; //invalid
    end
    else begin
     ar3:= copy(ar1);
     sortarray(ar3);
     for int2:= 0 to high(ar3) do begin
      if ar3[int2] <> int2 then begin
       ar1:= nil; //invalid
       break;
      end;
     end;
    end;
   end;
   fpagecomporders[int1]:= ar1;
  end;
 end;
 filer.endlist;
end;

procedure tcomponentclasslist.compare(const l, r; out result: integer);
begin
 result:= integer(componentclassinfoty(l).classtyp) -
              integer(componentclassinfoty(r).classtyp);
end;

function tcomponentclasslist.getcompareproc: compareprocty;
begin
 result:= {$ifdef FPC}@{$endif}compare;
end;

procedure tcomponentclasslist.checkpageindex(const index: integer);
begin
 if (index < 0) or (index > high(fpagecomporders)) then begin
  tlist.Error(SListIndexError, Index);
 end;
end;

function tcomponentclasslist.getpagecomporders(
  const index: integer): integerarty;
begin
 checkpageindex(index);
 result:= fpagecomporders[index];
end;

procedure tcomponentclasslist.setpagecomporders(const index: integer;
  const Value: integerarty);
begin
 checkpageindex(index);
 fpagecomporders[index]:= value;
end;

{ tdesignerselections }

constructor tdesignerselections.create;
begin
 inherited create(getrecordsize);
end;

function tdesignerselections.itempo(const index: integer): pselectedinfoty;
begin
 result:= pselectedinfoty(getitempo(index));
end;

procedure tdesignerselections.assign(const source: idesignerselections);
var
 int1: integer;
begin
 clear;
 count:= source.Count;
 for int1:= 0 to source.count - 1 do begin
  itempo(int1)^.instance:= source.Items[int1];
 end;
 change;
end;

function tdesignerselections.getarray: componentarty;
begin
 if fcount > 0 then begin
  setlength(result,fcount);
  move(datapo^,pointer(result)^,fcount*sizeof(pointer));
 end
 else begin
  result:= nil;
 end;
end;

function tdesignerselections.Add(const Item: Tcomponent): Integer;
var
 info: selectedinfoty;
begin
 result:= indexof(item);
 if result < 0 then begin
  fillchar(info,sizeof(info),0);
  info.instance:= item;
  result:= inherited add(info);
  change;
 end;
end;

function tdesignerselections.Equals(const List: IDesignerSelections): Boolean;
var
 int1: integer;
begin
 result:= false;
 if list.Count = count then begin
  for int1:= 0 to count-1 do begin
   if list.Items[int1] <> itempo(int1)^.instance then begin
    exit;
   end;
  end;
 end;
 result:= true;
end;

function tdesignerselections.Get(Index: Integer): Tcomponent;
begin
 result:= itempo(index)^.instance;
end;

function tdesignerselections.GetCount: Integer;
begin
 result:= count;
end;

function tdesignerselections.indexof(const ainstance: tcomponent): integer;
var
 int1: integer;
begin
 result:= -1;
 for int1:= 0 to count-1 do begin
  if itempo(int1)^.instance = ainstance then begin
   result:= int1;
   break;
  end;
 end;
end;

function tdesignerselections.remove(const ainstance: tcomponent): integer;
begin
 result:= indexof(ainstance);
 if result >= 0 then begin
  delete(result);
  change;
 end;
end;

procedure tdesignerselections.dochanged;
begin
 //dummy
end;

function tdesignerselections.getrecordsize: integer;
begin
 result:= sizeof(selectedinfoty);
end;

function tdesignerselections.Getitems(const index: integer): tcomponent;
begin
 result:= itempo(index)^.instance;
end;

procedure tdesignerselections.Setitems(const index: integer;
  const Value: tcomponent);
begin
 itempo(index)^.instance:= value;
end;

procedure tdesignerselections.beginupdate;
begin
 inc(fupdating);
end;

procedure tdesignerselections.change;
begin
 if fupdating = 0 then begin
  dochanged;
 end;
end;

procedure tdesignerselections.endupdate;
begin
 dec(fupdating);
 if fupdating = 0 then begin
  dochanged;
 end;
end;

function tdesignerselections.isembedded(const component: tcomponent): boolean;
                 //true if subchild of another selected component
var
 comp1: tcomponent;
begin
 result:= false;
 comp1:= component.getparentcomponent;
 while comp1 <> nil do begin
  if (indexof(comp1) >= 0) then begin
   result:= true;
   break;  //stored bay parent
  end;
  comp1:= comp1.getparentcomponent;
 end;
end;

function tdesignerselections.getobjecttext: string;
var
 binstream: tmemorystream;
 textstream: ttextstream;
 int1: integer;
 component: tcomponent;
 writer: twriter;
begin
 result:= '';
 if count > 0 then begin
  binstream:= tmemorystream.Create;
  textstream:= ttextstream.Create;
  try
   for int1:= 0 to count -1 do begin
    component:= items[int1];
    if not isembedded(component) then begin
//     binstream.WriteComponent(items[int1]);
     writer:= twriter.Create(binstream,4096);
     try
      writer.Root:= component.Owner;
      {$ifndef FPC}
      writer.WriteSignature;
      {$endif}
      writer.writecomponent(component);
     finally
      writer.Free;
     end;
    end;
   end;
   binstream.Position:= 0;
   while binstream.Position < binstream.Size do begin
    objectbinarytotext(binstream,textstream);
   end;
   textstream.Position:= 0;
   result:= textstream.readdatastring;
//   msewidgets.copytoclipboard(textstream.readdatastring);
  finally
   binstream.Free;
   textstream.Free;
  end;
 end;
end;

function tdesignerselections.getobjinfoar: objinfoarty;
var
 int1: integer;   
 co1: tcomponent;
 binstream: tmemorystream;
 textstream: ttextstream;
 writer: twriter;
begin
 result:= nil;
 for int1:= 0 to count - 1 do begin
  co1:= items[int1];
  if not isembedded(co1) then begin
   setlength(result,high(result)+2);
   with result[high(result)] do begin
    owner:= co1.owner;
    if co1 is twidget then begin
     parent:= twidget(co1).parentwidget;
    end
    else begin
     parent:= nil;
    end;
    binstream:= tmemorystream.create;
    writer:= twriter.create(binstream,4096);
    textstream:= ttextstream.create;
    try
     writer.root:= co1.owner;
     {$ifndef FPC}
     writer.writesignature;
     {$endif}
     writer.writecomponent(co1);
     freeandnil(writer);
     binstream.position:= 0;
     objectbinarytotext(binstream,textstream);
     textstream.position:= 0;
     objtext:= textstream.readdatastring;
    finally
     writer.free;
     binstream.free;
     textstream.free;
    end;   
   end;
  end;
 end; 
end;

procedure tdesignerselections.copytoclipboard;
begin
 msewidgets.copytoclipboard(getobjecttext);
end;

procedure tdesignerselections.doadd(component: tcomponent);
begin
 add(component);
end;

procedure tdesignerselections.dosetactcomp(component: tcomponent);
begin
 factcomp:= component;
end;

function tdesignerselections.pastefromobjecttext(const aobjecttext: string; 
           aowner,aparent: tcomponent; initproc: initcomponentprocty): integer;
                  //returns count of added components
var
 binstream: tmemorystream;
 textstream: ttextstream;
 int1: integer;
 str1: msestring;
 countbefore: integer;
 reader: treader;
 comp1: tcomponent;
 listend: tvaluetype;

begin
 if aobjecttext = '' then begin
  result:= 0;
  exit;
 end; 
 countbefore:= count;
 try
  textstream:= ttextstream.Create;
  comp1:= tcomponent.create(nil);
  tcomponent1(comp1).SetDesigning(true{$ifndef FPC},false{$endif});
  try
   lockfindglobalcomponent;
   listend:= vanull;
   textstream.writestr(aobjecttext);
   textstream.Position:= 0;
   binstream:= tmemorystream.Create;
   try
    while textstream.position < textstream.Size do begin
     binstream.Position:= 0;
     objecttexttobinary(textstream,binstream);
     binstream.Write(listend,sizeof(listend));
     binstream.Position:= 0;
     reader:= treader.create(binstream,4096);
     try
      factcomp:= nil;
      reader.Readcomponents(comp1,nil,{$ifdef FPC}@{$endif}dosetactcomp);
      if factcomp <> nil then begin
       if assigned(initproc) then begin
        initproc(factcomp,aparent);
       end;
       add(factcomp);
       tcomponent1(factcomp).GetChildren({$ifdef FPC}@{$endif}doadd,factcomp.owner);
      end;
     finally
      reader.Free;
     end;
    end;
   finally
    binstream.Free;
   end;
  finally
   unlockfindglobalcomponent;
   textstream.Free;
   comp1.Free;
  end;
 except
  for int1:= countbefore to count - 1 do begin
   items[int1].Free;
  end;
  count:= countbefore;
 end;
 result:= count - countbefore;
end;

function tdesignerselections.pastefromclipboard(aowner,aparent: tcomponent;
                initproc: initcomponentprocty): integer;
                  //returns count of added components
var
 str1: msestring;
begin
 if msewidgets.pastefromclipboard(str1) then begin
  result:= pastefromobjecttext(str1,aowner,aparent,initproc);
 end;
end;

{ tdesignnotifications }

procedure tdesignnotifications.RegisterNotification(const DesignNotification: IDesignNotification);
begin
 if indexof(pointer(designnotification)) = -1 then begin
  add(pointer(designnotification));
 end;
end;

procedure tdesignnotifications.UnregisterNotification(const DesignNotification: IDesignNotification);
begin
 if self <> nil then begin
  extract(pointer(designnotification));
 end;
end;
{
procedure tdesignnotifications.DesignerClosed(const ADesigner: IDesigner;
  AGoingDormant: Boolean);
var
 int1: integer;
begin
 for int1:= 0 to count - 1 do begin
  idesignnotification(fitems[int1]).DesignerClosed(adesigner,agoingdormant);
 end;
end;

procedure tdesignnotifications.DesignerOpened(const ADesigner: IDesigner;
  AResurrecting: Boolean);
var
 int1: integer;
begin
 for int1:= 0 to count - 1 do begin
  idesignnotification(fitems[int1]).Designeropened(adesigner,aresurrecting);
 end;
end;
}
procedure tdesignnotifications.ItemDeleted(const ADesigner: IDesigner;
                const amodule: tmsecomponent; const AItem: tcomponent);
var
 int1: integer;
begin
 for int1:= 0 to count - 1 do begin
  idesignnotification(fitems[int1]).itemdeleted(adesigner,amodule,aitem);
 end;
end;

procedure tdesignnotifications.ItemInserted(const ADesigner: IDesigner;
                const amodule: tmsecomponent; const AItem: tcomponent);
var
 int1: integer;
begin
 for int1:= 0 to count - 1 do begin
  idesignnotification(fitems[int1]).iteminserted(adesigner,amodule,aitem);
 end;
end;

procedure tdesignnotifications.ItemsModified(const ADesigner: IDesigner;
  const aitem: tobject);
var
 int1: integer;
begin
 for int1:= 0 to count - 1 do begin
  idesignnotification(fitems[int1]).itemsmodified(adesigner,aitem);
 end;
end;

procedure tdesignnotifications.SelectionChanged(const ADesigner: IDesigner;
  const ASelection: IDesignerSelections);
var
 int1: integer;
begin
 for int1:= 0 to count - 1 do begin
  idesignnotification(fitems[int1]).selectionchanged(adesigner,aselection);
 end;
end;

procedure tdesignnotifications.moduleactivated(const adesigner: idesigner;
                  const amodule: tmsecomponent);
var
 int1: integer;
begin
 for int1:= 0 to count - 1 do begin
  idesignnotification(fitems[int1]).moduleactivated(adesigner,amodule);
 end;
end;

procedure tdesignnotifications.moduledeactivated(const adesigner: idesigner;
                  const amodule: tmsecomponent);
var
 int1: integer;
begin
 for int1:= 0 to count - 1 do begin
  idesignnotification(fitems[int1]).moduledeactivated(adesigner,amodule);
 end;
end;

procedure tdesignnotifications.moduledestroyed(const adesigner: idesigner;
                  const amodule: tmsecomponent);
var
 int1: integer;
begin
 for int1:= 0 to count - 1 do begin
  idesignnotification(fitems[int1]).moduledestroyed(adesigner,amodule);
 end;
end;

procedure tdesignnotifications.methodcreated(const adesigner: idesigner;
                          const amodule: tmsecomponent;
                          const aname: string; const atype: ptypeinfo);
var
 int1: integer;
begin
 for int1:= 0 to count - 1 do begin
  idesignnotification(fitems[int1]).methodcreated(adesigner,amodule,aname,atype);
 end;
end;

procedure tdesignnotifications.methodnamechanged(
  const adesigner: idesigner; const amodule: tmsecomponent; const newname,
  oldname: string; const atypeinfo: ptypeinfo);
var
 int1: integer;
begin
 for int1:= 0 to count - 1 do begin
  idesignnotification(fitems[int1]).methodnamechanged(adesigner,amodule,
           newname,oldname,atypeinfo);
 end;
end;

procedure tdesignnotifications.showobjecttext(const adesigner: idesigner; 
              const afilename: filenamety; const backupcreated: boolean);
var
 int1: integer;
begin
 for int1:= 0 to count - 1 do begin
  idesignnotification(fitems[int1]).showobjecttext(adesigner,afilename,
                                  backupcreated);
 end;
end;

procedure tdesignnotifications.closeobjecttext(const adesigner: idesigner;
               const afilename: filenamety; out cancel: boolean);
var
 int1: integer;
begin
 cancel:= false;
 for int1:= 0 to count - 1 do begin
  idesignnotification(fitems[int1]).closeobjecttext(adesigner,afilename,cancel);
  if cancel then begin
   break;
  end;
 end;
end;

procedure tdesignnotifications.componentnamechanging(
  const adesigner: idesigner; const amodule: tmsecomponent;
  const aitem: tcomponent; const newname: string);
var
 int1: integer;
begin
 for int1:= 0 to count - 1 do begin
  idesignnotification(fitems[int1]).componentnamechanging(adesigner,amodule,
           aitem,newname);
 end;
end;

procedure tdesignnotifications.moduleclassnamechanging(const adesigner: idesigner;
                    const amodule: tmsecomponent; const newname: string);
var
 int1: integer;
begin
 for int1:= 0 to count - 1 do begin
  idesignnotification(fitems[int1]).moduleclassnamechanging(adesigner,amodule,
           newname);
 end;
end;

procedure tdesignnotifications.instancevarnamechanging(const adesigner: idesigner;
                    const amodule: tmsecomponent; const newname: string);
var
 int1: integer;
begin
 for int1:= 0 to count - 1 do begin
  idesignnotification(fitems[int1]).instancevarnamechanging(adesigner,amodule,
           newname);
 end;
end;

{ tunitgroups }

constructor tunitgroups.create;
begin
 inherited create(sizeof(unitgroupinfoty),[rels_needsfinalize,rels_needscopy]);
end;

procedure tunitgroups.registergroups(const adependents: array of string; 
                                                const agroup: array of string);
var
 info: unitgroupinfoty;
 int1: integer;
begin
 with info do begin
  setlength(dependents,length(adependents));
  for int1:= 0 to high(adependents) do begin
   dependents[int1]:= struppercase(adependents[int1]);
  end;
  setlength(group,length(agroup));
  for int1:= 0 to high(agroup) do begin
   group[int1]:= agroup[int1];
  end;
 end;
 add(info);
end;

procedure tunitgroups.finalizerecord(var item);
begin
 finalize(unitgroupinfoty(item));
end;

procedure tunitgroups.copyrecord(var item);
begin
 with unitgroupinfoty(item) do begin
  arrayaddref(dependents);
  arrayaddref(group);
 end;
end;

function tunitgroups.getneededunits(const unitname: string): stringarty;
var
 ar1,ar2: stringarty;
 ar3: integerarty;
 int1,int2,int3,int4: integer;
 po1: punitgroupinfoty;
 str1: string;
begin
 str1:= struppercase(unitname);
 ar1:= nil;
 po1:= datapo;
 for int1:= 0 to count - 1 do begin
  for int2:= 0 to high(po1^.dependents) do begin
   if str1 = po1^.dependents[int2] then begin
    int3:= length(ar1);
    setlength(ar1,int3+length(po1^.group));
    for int4:= int3 to high(ar1) do begin
     ar1[int4]:= po1^.group[int4-int3];
    end;
    break;
   end;
  end;
  inc(po1);
 end;
 setlength(ar1,high(ar1)+2);
 ar1[high(ar1)]:= unitname; //add dependent
 setlength(ar2,length(ar1));
 for int1:= 0 to high(ar1) do begin
  ar2[int1]:= struppercase(ar1[int1]);
 end;
 sortarray(ar2,{$ifdef FPC}@{$endif}compareasciistring,ar3);
 setlength(result,length(ar1));
 str1:= '';
 int2:= 0;
 for int1:= 0 to high(ar2) do begin
  if ar2[int1] <> str1 then begin
   result[int2]:= ar1[ar3[int1]];
   inc(int2);
   str1:= ar2[int1];
  end;
 end;
 setlength(result,int2);
end;

initialization
 adesignnotifications:= tdesignnotifications.Create;
 aregisteredcomponents:= tcomponentclasslist.create;
finalization
 freeandnil(adesignnotifications);
 freeandnil(aregisteredcomponents);
 freeandnil(aunitgroups);
end.

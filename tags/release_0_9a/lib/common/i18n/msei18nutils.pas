unit msei18nutils;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface
uses
 msei18nglob;

function loadlangunit(aname: string): boolean;
            //'' -> reset to builtin
            //true if ok
procedure registermodule(datapo: pointer; //pobjectdataty
                              const objectclassname: shortstring;
                              const name: shortstring); cdecl;
procedure unregistermodule(datapo: pointer; //pobjectdataty
                              const objectclassname: shortstring;
                              const name: shortstring); cdecl;
procedure registerresourcestrings(datapo: pointer); cdecl;
procedure unregisterresourcestrings(datapo: pointer); cdecl;

implementation
uses
 {$ifdef FPC}dynlibs,{$ifdef linux}dl,{$endif}{$endif}sysutils,mseclasses,
                           mselist,msestrings,msegui;
 
type
 resourcestringinfoty = record
  name: string;
  value: msestring;
 end;
 presourcestringinfoty = ^resourcestringinfoty;
 
 tresourcestringlist = class(torderedrecordlist)
  protected
   function getcompareproc: compareprocty; override;
   procedure finalizerecord(var item); override;
   procedure copyrecord(var item); override;
   procedure compare(const l,r; out result: integer);
  public
   constructor create;
   procedure readvalues(data: pobjectdataty);
   function find(const aname: string; out po: presourcestringinfoty): boolean;
 end;

Type          //copied from objpas.pp

  PResourceStringRecord = ^TResourceStringRecord;
  TResourceStringRecord = Packed Record
     DefaultValue,
     CurrentValue : AnsiString;
     HashValue : longint;
     Name : AnsiString;
   end;

   TResourceStringTable = Packed Record
     Count : longint;
     Resrec : Array[Word] of TResourceStringRecord;
   end;
   PResourceStringTable = ^TResourceStringTable;

   TResourceTableList = Packed Record
     Count : longint;
     Tables : Array[Word] of PResourceStringTable;
     end;


{$ifdef FPC}
Var
  ResourceStringTable : TResourceTablelist; External Name 'FPC_RESOURCESTRINGTABLES';
{$endif}

var
 langlibhandle: {$ifdef FPC}tlibhandle{$else}hmodule{$endif};
type
 registerlangty = procedure(const registermoduleproc: registermodulety;
                              const registerresourceproc: registerresourcety);

procedure registermodule(datapo: pointer; const objectclassname: shortstring;
                                              const name: shortstring); cdecl;
begin
 registerobjectdata(pobjectdataty(datapo),objectclassname,name);
end;

procedure unregistermodule(datapo: pointer; const objectclassname: shortstring;
                                              const name: shortstring); cdecl;
begin
 unregisterobjectdata(objectclassname,name);
end;

procedure registerresourcestrings(datapo: pointer); cdecl;
{$ifdef FPC}
var
 int1,int2: integer;
 list1: tresourcestringlist;
 po1: presourcestringinfoty;
{$endif}
begin
{$ifdef FPC}
 list1:= tresourcestringlist.create;
 try
  list1.readvalues(pobjectdataty(datapo));
  for int1:= 0 to resourcestringtable.count - 1 do begin
   with resourcestringtable.tables[int1]^ do begin
    for int2:= 0 to count - 1 do begin
     with resrec[int2] do begin
      if list1.find(name,po1) then begin
       currentvalue:= po1^.value;
      end;
     end;
    end;
   end;
  end;
 finally
  list1.free;
 end;
{$endif}
end;

procedure unregisterresourcestrings(datapo: pointer); cdecl;
var
 int1,int2: integer;
 list1: tresourcestringlist;
 po1: presourcestringinfoty;
begin
{$ifdef FPC}
 list1:= tresourcestringlist.create;
 try
  list1.readvalues(pobjectdataty(datapo));
  for int1:= 0 to resourcestringtable.count - 1 do begin
   with resourcestringtable.tables[int1]^ do begin
    for int2:= 0 to count - 1 do begin
     with resrec[int2] do begin
      if list1.find(name,po1) then begin
       currentvalue:= defaultvalue;
      end;
     end;
    end;
   end;
  end;
 finally
  list1.free;
 end;
{$endif}
end;

function loadlangunit(aname: string): boolean;
            //true if ok
var
 reglang: registerlangty;
begin
 result:= false;
 try
  resetchangedmodules;
  if langlibhandle <> 0 then begin
   {$ifdef FPC}pointer({$endif}reglang{$ifdef FPC}){$endif}:=
                  getprocaddress(langlibhandle,unregisterlangname);
   if {$ifndef FPC}@{$endif}reglang <> nil then begin
    reglang(@unregistermodule,@unregisterresourcestrings);
   end;
   {$ifdef FPC}unloadlibrary{$else}freelibrary{$endif}(langlibhandle);
   langlibhandle:= 0;
  end;
  if aname <> '' then begin
   {$ifdef mswindows}
   aname:= aname+'.dll';
   {$else}
   aname:= 'lib'+aname+'.so';
   {$endif}
   langlibhandle:= loadlibrary({$ifndef FPC}pchar({$endif}aname{$ifndef FPC}){$endif});
   if langlibhandle <> 0 then begin
    {$ifdef FPC}pointer({$endif}reglang{$ifdef FPC}){$endif}:=
                  getprocaddress(langlibhandle,registerlangname);
    if {$ifndef FPC}@{$endif}reglang <> nil then begin
     reglang(@registermodule,@registerresourcestrings);
    end;
    result:= true;
   end
   else begin
   {$ifdef FPC} 
    {$ifdef linux}
    raise exception.create(dlerror);
    {$else}
    raise exception.create('Library not found.');
    {$endif}
   {$else}
    raise exception.create('Library not found.');
   {$endif}
   end;
  end;
  reloadchangedmodules;
 except
  on e: exception do begin
   e.message:= 'Can not load langunit "'+aname+'":'+lineend+e.message;
   application.handleexception(nil);
  end;
 end;
end;

{ tresourcestringlist }

constructor tresourcestringlist.create;
begin
 inherited create(sizeof(resourcestringinfoty),[rels_needsfinalize,rels_needscopy]);
end;

procedure tresourcestringlist.finalizerecord(var item);
begin
 finalize(resourcestringinfoty(item));
end;

procedure tresourcestringlist.copyrecord(var item);
begin
 with resourcestringinfoty(item) do begin
  stringaddref(name);
  stringaddref(value);
 end;
end;

function tresourcestringlist.getcompareproc: compareprocty;
begin
 result:= {$ifdef FPC}@{$endif}compare;
end;

procedure tresourcestringlist.compare(const l; const r; out result: integer);
begin
 result:= stringcomp(resourcestringinfoty(l).name,resourcestringinfoty(r).name);
end;

procedure tresourcestringlist.readvalues(data: pobjectdataty);
var
 po1: pchar;
 info: resourcestringinfoty;
 str1: string;
begin
 clear;
 if data^.size > 0 then begin
  po1:= @data^.data;
  repeat
   info.name:= po1;
   inc(po1,length(info.name)+1);
   str1:= po1;
   inc(po1,length(str1)+1);
   info.value:= utf8tostring(str1);
   add(info);
  until po1 - pchar(@data^.data) >= data^.size;
 end;
end;

function tresourcestringlist.find(const aname: string;
                               out po: presourcestringinfoty): boolean;
var
 info: resourcestringinfoty;
 int1: integer;
begin
 info.name:= aname;
 result:= internalfind(info,int1);
 if result then begin
  po:= presourcestringinfoty(pchar(datapo) + int1 * sizeof(resourcestringinfoty));
 end
 else begin
  po:= nil;
 end;
end;

end.

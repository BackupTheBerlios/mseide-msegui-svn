{ MSEgui Copyright (c) 1999-2006 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit msedirtree;

{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface
uses
 mseforms,msewidgetgrid,mselistbrowser,msedatanodes,msefileutils,
 msetypes,msestrings,msegui,mseglob,
 mseclasses,msegrids,msesys;
type

 tdirlistitem = class(ttreelistedititem)
  private
   finfo: fileinfoty;                                           
  protected
   procedure updateinfo;
  public
   constructor create(const aowner: tcustomitemlist = nil;
              const aparent: ttreelistitem = nil); override;
   procedure setentries(const list: tcustomfiledatalist);
   function findsubdir(const aname: filenamety): tdirlistitem;
   function getpath: filenamety;
 end;

 tdirtreefo = class(tmseform)
   grid: twidgetgrid;
   treeitem: ttreeitemedit;
   procedure treeitemoncreateitem(const sender: tcustomitemlist;
                     var item: ttreelistedititem);
   procedure treeitemonitemnotification(const sender: tlistitem;
                 var action: nodeactionty);
   procedure treeitemondataentered(const sender: tobject);
   procedure treeitemoncellevent(const sender: tobject; var info: celleventinfoty);
  private
   fshowhiddenfiles: boolean;
   fcasesensitive: boolean;
//   fpath: filenamety;
   fonpathchanged: notifyeventty;
   procedure setpath(const Value: filenamety);
   function getpath: filenamety;
   procedure adddir(const aitem: tdirlistitem);
  public
   property casesensitive: boolean read fcasesensitive write fcasesensitive;
   property showhiddenfiles: boolean read fshowhiddenfiles write fshowhiddenfiles;
   property path: filenamety read getpath write setpath;
   property onpathchanged: notifyeventty read fonpathchanged write fonpathchanged;
 end;
{
 tdiredit = class(tstringedit)
  private
 end;
}
var
 dirtreefo: tdirtreefo;

implementation
uses
 msedirtree_mfm,msesysintf,mseeditglob,msefiledialog,msebitmap,mseevent,
 mseguiglob;

{ tdirlistitem }

constructor tdirlistitem.create(const aowner: tcustomitemlist;
  const aparent: ttreelistitem);
begin
 inherited;
 include(fstate,ns_subitems);
end;

function tdirlistitem.getpath: filenamety;
begin
 if fparent = nil then begin
  result:= fcaption;
 end
 else begin
  result:= copy(concatstrings(rootcaptions,'/'),2,bigint);
 end;
end;

procedure tdirlistitem.updateinfo;
begin
 updatefileinfo(self,finfo,true);
end;

procedure tdirlistitem.setentries(const list: tcustomfiledatalist);
var
 po1: pfileinfoty;
 ar1: treelistedititemarty;
 int1: integer;
 item1: tdirlistitem;
begin
 clear;
 if list <> nil then begin
  po1:= list.datapo;
  setlength(ar1,list.count);
  for int1:= 0 to list.count - 1 do begin
   item1:= tdirlistitem.create;
   ar1[int1]:= item1;
   item1.finfo:= po1^;
   item1.updateinfo;
   inc(po1);
  end;
  add(ar1);
 end;
end;

function tdirlistitem.findsubdir(const aname: filenamety): tdirlistitem;
begin
 result:= tdirlistitem(finditembycaption(aname,true));
 if (result = nil) and sys_filesystemiscaseinsensitive then begin
  result:= tdirlistitem(finditembycaption(aname,false));
 end;
end;

{ tdirtreefo }

procedure tdirtreefo.adddir(const aitem: tdirlistitem);
var
 list: tcustomfiledatalist;
 exclude: fileattributesty;
begin
 list:= tcustomfiledatalist.create;
 try
  if fcasesensitive then begin
   list.options:= [flo_sortname,flo_casesensitive];
  end
  else begin
   list.options:= [flo_sortname];
  end;
  if fshowhiddenfiles then begin
   exclude:= [];
  end
  else begin
   exclude:= [fa_hidden];
  end;
  list.adddirectory(aitem.getpath,fil_name,nil,[fa_dir],exclude);
  aitem.setentries(list);
 finally
  list.free;
 end;
end;

function tdirtreefo.getpath: filenamety;
begin
 if treeitem.item = nil then begin
  result:= '';
 end
 else begin
  result:= filepath(tdirlistitem(treeitem.item).getpath,fk_dir);
 end;
end;

procedure tdirtreefo.setpath(const Value: filenamety);
var
 ar1: msestringarty;
 int1: integer;
 aitem,item1: tdirlistitem;
 {$ifdef mswindows}
 uncitem: tdirlistitem;
 {$endif}

begin
 ar1:= splitrootpath(value);
 treeitem.itemlist.clear;
 treeitem.itemlist.count:= 1;
 aitem:= tdirlistitem(treeitem.itemlist[0]);
 {$ifdef mswindows}
 treeitem.itemlist.count:= 2;
 uncitem:= tdirlistitem(treeitem.itemlist[1]);
 initdirfileinfo(uncitem.finfo,'//'); //UNC
 uncitem.updateinfo;
 {$endif}

 if (high(ar1) > 0) and (ar1[0] = '') then begin
 {$ifdef mswindows}
  initdirfileinfo(aitem.finfo,'/');
  aitem.updateinfo;
  aitem:= uncitem;
 {$else}
  initdirfileinfo(aitem.finfo,'//'); //UNC
 {$endif}
  int1:= 1;
 end
 else begin
  initdirfileinfo(aitem.finfo,'/');
  int1:= 0;
 end;
 aitem.updateinfo;
 item1:= aitem;
 for int1:= int1 to high(ar1) do begin
  aitem.expanded:= true;
  aitem:= aitem.findsubdir(ar1[int1]);
  if aitem = nil then begin
   break;
  end;
  item1:= aitem;
 end;
 grid.focuscell(makegridcoord(0,treeitem.itemlist.indexof(item1)),fca_setfocusedcell);
end;

procedure tdirtreefo.treeitemoncellevent(const sender: tobject;
  var info: celleventinfoty);
begin
 case info.eventkind of
  cek_enter: begin
   if assigned(fonpathchanged) then begin
    fonpathchanged(self);
   end;
  end;
 end;
 if iscellclick(info) and (info.zone = cz_caption) then begin
  treeitem.checkvalue;
 end;
end;

procedure tdirtreefo.treeitemoncreateitem(const sender: tcustomitemlist;
  var item: ttreelistedititem);
begin
 item:= tdirlistitem.create(sender);
end;

procedure tdirtreefo.treeitemondataentered(const sender: tobject);
begin
 window.modalresult:= mr_ok;
end;

procedure tdirtreefo.treeitemonitemnotification(const sender: tlistitem;
  var action: nodeactionty);
var
 bo1: boolean;
begin
 with tdirlistitem(sender) do begin
  case action of
   na_expand: begin
    include(finfo.state,fis_diropen);
    updateinfo;
    adddir(tdirlistitem(sender));
    if count = 0 then begin
     state:= state - [ns_subitems,ns_expanded];
     action:= na_none;
    end;
   end;
   na_collapse: begin
    bo1:= count > 0;
    clear;
    if bo1 then begin
     state:= state + [ns_subitems];
    end;
    exclude(finfo.state,fis_diropen);
    updateinfo;
   end;
  end;
 end;
end;

end.

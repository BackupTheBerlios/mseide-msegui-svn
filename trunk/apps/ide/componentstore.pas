{ MSEide Copyright (c) 2008 by Martin Schreiber
   
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
unit componentstore;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
interface
uses
 classes,mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msedock,mseact,mseactions,
 msestrings,msedataedits,mseedit,msegrids,msetypes,msewidgetgrid,msedatanodes,
 mselistbrowser,msewidgets,msestatfile,msebitmap,msefiledialog,msesys,msedialog,
 msememodialog;

type
 storedcomponentinfoty = record
  compclass: ansistring;
  componentname: ansistring;
  compname: msestring;
  compdesc: msestring;
  filepath: filenamety;
  storedir: filenamety;
 end;
 pstoredcomponentinfoty = ^storedcomponentinfoty;
 
 tstoredcomponent = class(ttreelistedititem)
  private
   finfo: storedcomponentinfoty;
   fisnode: boolean;
   fpasting: boolean;
   procedure setinfo(const avalue: storedcomponentinfoty);
   procedure setcompname(const avalue: msestring);
   procedure checkisnode;
   procedure setfilepath(const avalue: filenamety);
   function getfilepath: msestring;
   procedure setcompdesc(const avalue: msestring);
  protected
   procedure setcaption(const avalue: msestring); override;
  public
   constructor create(const aowner: tcustomitemlist = nil;
              const aparent: ttreelistitem = nil); override; overload;
   constructor create(const isnode: boolean); overload;
   property info: storedcomponentinfoty read finfo write setinfo;
   property compclass: ansistring read finfo.compclass write finfo.compclass;
   property componentname: ansistring read finfo.componentname write 
                           finfo.componentname;
   property compname: msestring read finfo.compname write setcompname;
   property compdesc: msestring read finfo.compdesc write setcompdesc;
   property filepath: msestring read getfilepath write setfilepath;
   property storedir: msestring read finfo.storedir write finfo.storedir;

   procedure updatestoredir;
   procedure dostatread(const reader: tstatreader); override;
   procedure dostatwrite(const writer: tstatwriter); override;
 end;
 
 storedcomponentarty = array of tstoredcomponent;
 
 tcomponentstorefo = class(tdockform)
   grid: twidgetgrid;
   node: ttreeitemedit;
   copycompact: taction;
   pastecompact: taction;
   tpopupmenu1: tpopupmenu;
   storefile: tstatfile;
   filepath: tfilenameedit;
   compdesc: tmemodialogedit;
   storefiledialog: tfiledialog;
   procedure docreate(const sender: TObject);
   procedure dopastecomponent(const sender: TObject);
   procedure dostatread(const sender: TObject; const reader: tstatreader);
   procedure dostatwrite(const sender: TObject; const writer: tstatwriter);
   procedure dostatreaditem(const sender: TObject; const reader: tstatreader;
                   var aitem: ttreelistitem);
   procedure doupdaterowvalues(const sender: TObject; const aindex: Integer;
                   const aitem: tlistitem);
   procedure filenamesetva(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure docopycomponent(const sender: TObject);
   procedure donewnode(const sender: TObject);
   procedure popupupdate(const sender: tcustommenu);
   procedure copyupda(const sender: tcustomaction);
   procedure pasteupda(const sender: tcustomaction);
   procedure docellevent(const sender: TObject; var info: celleventinfoty);
   procedure newstoreex(const sender: TObject);
   procedure addstoreex(const sender: TObject);
   procedure removestoreex(const sender: TObject);
   procedure compdescsetva(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure compnamesetva(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure delnode(const sender: TObject);
   procedure copynodeex(const sender: TObject);
   procedure pastenodeex(const sender: TObject);
   procedure beforedrag(const sender: TObject; const apos: pointty;
                   var dragobject: tdragobject; var processed: Boolean);
   procedure drago(const sender: ttreeitemedit; const source: ttreelistitem;
                   const dest: ttreelistitem;
                   var dragobject: ttreeitemdragobject; var accept: Boolean;
                   var processed: Boolean);
  private
//   frootnode: tstoredcomponent;
   far1: storedcomponentarty;
   fstoredir: msestring;
   procedure initcomponentinfo(out ainfo: storedcomponentinfoty);
   function isnode: boolean;
   function dogetstorerec(const index: integer): msestring;
   procedure dosetstorescount(const count: integer);
   procedure dosetstorerec(const index: integer; const avalue: msestring);
   procedure readstore(const aitem: tstoredcomponent);
  public
   procedure updatestat(afiler: tstatfiler);
 end;

var
 componentstorefo: tcomponentstorefo;
 
implementation
uses
 componentstore_mfm,msestream,storedcomponentinfodialog,msedatalist,msefileutils,
 sysutils,projectoptionsform;
 
type
 treader1 = class(treader);
 
function getstoredir: filenamety;
begin
 result:= expandprmacros('${COMPSTOREDIR}');
end;

{ tstoredcomponent }

constructor tstoredcomponent.create(const aowner: tcustomitemlist = nil;
               const aparent: ttreelistitem = nil);
begin
 inherited;
 include(fstate1,ns1_candrag);
end;

constructor tstoredcomponent.create(const isnode: boolean);
begin
 include(fstate1,ns1_rootchange);
 fisnode:= isnode;
 create(nil,nil);
 checkisnode;
end;

procedure tstoredcomponent.setinfo(const avalue: storedcomponentinfoty);
begin
 finfo:= avalue;
 caption:= finfo.compname;
end;

procedure tstoredcomponent.dostatread(const reader: tstatreader);
begin
 inherited;
 if not fpasting and isroot then begin
  caption:= compname; //restore
 end
 else begin
  with reader do begin
   fisnode:= readboolean('isnode',fisnode);
   compname:= readmsestring('compname',compname);
   compclass:= readmsestring('compclass',compclass);
   compdesc:= readmsestring('compdesc',compdesc);
   finfo.filepath:= readmsestring('filepath',filepath);
   finfo.storedir:= readmsestring('storedir',storedir);
  end;
 end;
 checkisnode;
end;

procedure tstoredcomponent.dostatwrite(const writer: tstatwriter);
begin
 inherited;
 with writer do begin
  writeboolean('isnode',fisnode);
  writemsestring('compname',compname);
  writemsestring('compclass',compclass);
  writemsestring('compdesc',compdesc);
  writemsestring('filepath',finfo.filepath);
  writemsestring('storedir',storedir);
 end;
end;

procedure tstoredcomponent.setcompname(const avalue: msestring);
begin
 finfo.compname:= avalue;
 caption:= avalue;
end;

procedure tstoredcomponent.setcaption(const avalue: msestring);
begin
 finfo.compname:= avalue;
 inherited;
end;

procedure tstoredcomponent.checkisnode;
begin
 if not fisnode then begin
  fimagenr:= 2;
 end
 else begin
  if not isroot then begin
   finfo.filepath:= '';
  end;
  fimagenr:= 0;
 end;
end;

procedure tstoredcomponent.updatestoredir;
begin
 finfo.storedir:= getstoredir;
end;

procedure tstoredcomponent.setfilepath(const avalue: filenamety);
begin
 finfo.filepath:= avalue;
 statechanged;
 updatestoredir;
end;

function tstoredcomponent.getfilepath: msestring;
begin
 relocatepath(finfo.storedir,getstoredir,finfo.filepath);
 result:= finfo.filepath;
end;

procedure tstoredcomponent.setcompdesc(const avalue: msestring);
begin
 finfo.compdesc:= avalue;
 statechanged;
end;

{ tcomponentstorefo }

procedure tcomponentstorefo.docreate(const sender: TObject);
begin
{
 frootnode:= tstoredcomponent.create(true);
 frootnode.caption:= 'Root';
 node.itemlist.add(frootnode);
 }
end;

procedure tcomponentstorefo.initcomponentinfo(out ainfo: storedcomponentinfoty);
begin
 fillchar(ainfo,sizeof(ainfo),0);
end;

procedure tcomponentstorefo.dopastecomponent(const sender: TObject);
var
 str1: ansistring;
 str2: msestring;
 stream1: tstringcopystream;
 stream2: ttextstream;
 stream3: ttextstream;
 reader1: treader;
 info: storedcomponentinfoty;
 flags: tfilerflags;
 int1: integer;
 compname1: string;
 node1: tstoredcomponent;
 statwriter1: tstatwriter;
begin
 statwriter1:= nil;
 stream1:= nil;
 stream2:= nil;
 stream3:= nil;
 reader1:= nil;
 initcomponentinfo(info);
 try
  if pastefromclipboard(str2) then begin  
   str1:= str2;
   stream1:= tstringcopystream.create(str1);
   stream2:= ttextstream.create;
   try
    objecttexttobinary(stream1,stream2);
    stream2.position:= 0;
    reader1:= treader.create(stream2,4096);
    with info,treader1(reader1) do begin
    {$ifdef FPC}
     driver.beginrootcomponent;
     driver.begincomponent(flags,int1,compclass,componentname);
    {$else}
     readsignature;
     ReadPrefix(flags,int1);
     compclass:= ReadStr;
     componentname:= ReadStr;
    {$endif}
    end;    
   except
    exit;        //invalid
   end;
   info.compname:= info.compclass;
   if tstoredcomponentinfodialogfo.create(info).show(true) = mr_ok then begin
    stream3:= ttextstream.create(info.filepath,fm_create);
    node1:= tstoredcomponent.create(false);
    node1.info:= info;
    node.item.add(node1);    
    node1.statechanged;
    stream3.writedatastring(str1);
   end;
  end;
 finally
  statwriter1.free;
  reader1.free;
  stream1.free;
  stream2.free;
  stream3.free;
 end; 
end;

procedure tcomponentstorefo.docopycomponent(const sender: TObject);
var
 stream1: ttextstream;
begin
 with tstoredcomponent(node.item) do begin
  stream1:= ttextstream.create(filepath);
  try
   copytoclipboard(stream1.readdatastring);
  finally
   stream1.free;
  end;
 end;
end;

procedure tcomponentstorefo.dostatread(const sender: TObject;
               const reader: tstatreader);
begin
// frootnode.dostatread(reader);
end;

procedure tcomponentstorefo.dostatwrite(const sender: TObject;
               const writer: tstatwriter);
begin
// frootnode.dostatwrite(writer);
end;

procedure tcomponentstorefo.dostatreaditem(const sender: TObject;
               const reader: tstatreader; var aitem: ttreelistitem);
begin
 aitem:= tstoredcomponent.create(true);
end;

function tcomponentstorefo.dogetstorerec(const index: integer): msestring;
begin
 with far1[index].finfo do begin
  result:= encoderecord([compname,filepath,compdesc]);
 end;
end;

procedure tcomponentstorefo.dosetstorescount(const count: integer);
var
 int1: integer;
begin
 setlength(far1,count);
 for int1:= 0 to high(far1) do begin
  far1[int1]:= tstoredcomponent.create(true);
 end;
end;

procedure tcomponentstorefo.dosetstorerec(const index: integer; 
                                                const avalue: msestring);
var
 mstr1,mstr2,mstr3: msestring;
begin
 if not decoderecord(avalue,[@mstr1,@mstr2,@mstr3],'SSS') then begin
  freeandnil(far1[index]);
 end
 else begin
  with far1[index] do begin
   compname:= mstr1;
   finfo.filepath:= mstr2;
   compdesc:= mstr3;
  end;
 end;
end;

procedure tcomponentstorefo.readstore(const aitem: tstoredcomponent);
var
 reader1: tstatreader;
begin
 with aitem do begin
  reader1:= tstatreader.create(finfo.filepath);
  try
   reader1.setsection('store'); 
   aitem.dostatread(reader1);
  finally
   reader1.free;
  end;
 end;
end;

procedure tcomponentstorefo.updatestat(afiler: tstatfiler);
var
 int1: integer;
 item1: tstoredcomponent;
 ar2: msestringarty;
 writer1: tstatwriter;
 storedir1: filenamety;
begin
 storedir1:= getstoredir;
 if afiler.iswriter then begin
  with node do begin
   for int1:= 0 to itemlist.count - 1 do begin
    item1:= tstoredcomponent(items[int1]);
    if item1.isroot then begin
     additem(pointerarty(far1),item1);
    end;
   end;
   with tstatwriter(afiler) do begin
    writesection('componentstore');
    writemsestring('storedir',storedir1);
    writerecordarray('stores',length(far1),{$ifdef FPC}@{$endif}dogetstorerec);
   end;
   try
    for int1:= 0 to high(far1) do begin
     with far1[int1] do begin
      if isstatechanged then begin
       writer1:= tstatwriter.create(finfo.filepath);
       try
        writer1.writesection('store'); 
        far1[int1].dostatwrite(writer1);
       finally
        writer1.free;
       end;
      end;
     end; 
    end;
   except
    application.handleexception(self);
   end;
  end;
 end
 else begin
  grid.clear;
  with tstatreader(afiler) do begin
   setsection('componentstore'); 
   fstoredir:= readmsestring('storedir','');
   readrecordarray('stores',{$ifdef FPC}@{$endif}dosetstorescount,
                  {$ifdef FPC}@{$endif}dosetstorerec);
   try
    for int1:= 0 to high(far1) do begin
     item1:= far1[int1];
     if item1 <> nil then begin
      with item1 do begin
       if relocatepath(fstoredir,storedir1,finfo.filepath) then begin
        readstore(item1);
       end;
      end;
     end;
    end;
   except
    application.handleexception(self);
   end;
   for int1:= 0 to high(far1) do begin
    if far1[int1] <> nil then begin
     node.itemlist.add(far1[int1]);
    end;
   end;
  end;
 end;
 far1:= nil;
end;

procedure tcomponentstorefo.doupdaterowvalues(const sender: TObject;
               const aindex: Integer; const aitem: tlistitem);
begin
 with tstoredcomponent(aitem).info do begin
  self.filepath[aindex]:= filepath;
  self.compdesc[aindex]:= compdesc;
 end;
end;

procedure tcomponentstorefo.filenamesetva(const sender: TObject;
               var avalue: msestring; var accept: Boolean);
begin
 tstoredcomponent(node.item).filepath:= avalue;
end;

procedure tcomponentstorefo.compdescsetva(const sender: TObject;
               var avalue: msestring; var accept: Boolean);
begin
 tstoredcomponent(node.item).compdesc:= avalue;
end;

procedure tcomponentstorefo.compnamesetva(const sender: TObject;
               var avalue: msestring; var accept: Boolean);
begin
 tstoredcomponent(node.item).compname:= avalue;
end;

procedure tcomponentstorefo.donewnode(const sender: TObject);
var
 int1: integer;
begin
 with node.item do begin
  int1:= add(tstoredcomponent.create(true));
  expanded:= true;
 end;
 grid.row:= grid.row + int1 + 1;
 node.beginedit;
end;

function tcomponentstorefo.isnode: boolean;
begin
 result:= (node.item <> nil) and (tstoredcomponent(node.item).fisnode);
end;

procedure tcomponentstorefo.popupupdate(const sender: tcustommenu);
var
 bo1: boolean;
begin
 bo1:= isnode;
 sender.menu.submenu.itembyname('addnode').enabled:= bo1;
 sender.menu.submenu.itembyname('pastenode').enabled:= bo1;
 sender.menu.submenu.itembyname('removestore').enabled:= isnode and 
                                      node.item.isroot;
 bo1:= isnode and not node.item.isroot;
 sender.menu.submenu.itembyname('removenode').enabled:= bo1;
 sender.menu.submenu.itembyname('copynode').enabled:= bo1;
end;

procedure tcomponentstorefo.copyupda(const sender: tcustomaction);
begin
 sender.enabled:= not isnode;
end;

procedure tcomponentstorefo.pasteupda(const sender: tcustomaction);
begin
 sender.enabled:= isnode;
end;

procedure tcomponentstorefo.docellevent(const sender: TObject;
               var info: celleventinfoty);
var
 bo1: boolean;
begin
 case info.eventkind of
  cek_enter: begin
   with tstoredcomponent(node.item) do begin
    bo1:= fisnode;
    self.filepath.readonly:= bo1;;
    if bo1 and (treelevel > 0) then begin
     self.filepath.value:= '';
    end;
   end;
  end;
 end;
end;
//todo: check duplicates
procedure tcomponentstorefo.newstoreex(const sender: TObject);
var
 stream1: ttextstream;
 node1: tstoredcomponent;
begin
 with storefiledialog do begin
  if execute(fdk_save) = mr_ok then begin
   stream1:= ttextstream.create(controller.filename,fm_create);
   stream1.free;
   node1:= tstoredcomponent.create(true);
   with node1.finfo do begin
    filepath:= controller.filename;
    compname:= removefileext(filename(filepath));
    node1.caption:= compname;
   end;
   node.itemlist.add(node1);
  end;
 end;
end;
//todo: check duplicates
procedure tcomponentstorefo.addstoreex(const sender: TObject);
var
 stream1: ttextstream;
 node1: tstoredcomponent;
begin
 with storefiledialog do begin
  if execute(fdk_open) = mr_ok then begin
   node1:= tstoredcomponent.create(true);
   with node1.finfo do begin
    storedir:= getstoredir;
    filepath:= controller.filename;
    compname:= removefileext(filename(filepath));
    node1.caption:= compname;
   end;
   readstore(node1);
   node.itemlist.add(node1);
  end;
 end;
end;

procedure tcomponentstorefo.removestoreex(const sender: TObject);
begin
 with tstoredcomponent(node.item).finfo do begin
  if askyesno('Do you want to remove "'+compname+'"?') then begin
   tstoredcomponent(node.item).free;
  end;
 end;
end;

procedure tcomponentstorefo.delnode(const sender: TObject);
begin
 with tstoredcomponent(node.item).finfo do begin
  if askyesno('Do you want to remove "'+compname+'" branch?') then begin
   tstoredcomponent(node.item).free;
  end; 
 end;
end;

const
 nodecopysig = '{DEA80549-4F45-4117-B182-A0EF49C4A097}';
procedure tcomponentstorefo.copynodeex(const sender: TObject);
var
 stream1: ttextstream;
 writer1: tstatwriter;
begin
 stream1:= ttextstream.create; //memory stream
 writer1:= tstatwriter.create(stream1);
 stream1.encoding:= ce_utf8n;
 try
  writer1.writesection('nodecopy');
  writer1.writemsestring('signature',nodecopysig);
  node.item.dostatwrite(writer1);
  stream1.position:= 0;
  copytoclipboard(utf8tostring(stream1.readdatastring));
 finally
  writer1.free;
  stream1.free;
 end;
end;

procedure tcomponentstorefo.pastenodeex(const sender: TObject);
var
 reader1: tstatreader;
 stream1: ttextstream;
 node1: tstoredcomponent;
 mstr1: msestring;
begin
 if pastefromclipboard(mstr1) then begin
  reader1:= nil;
  stream1:= nil;
  try
   stream1:= ttextstream.createdata(stringtoutf8(mstr1));
   stream1.encoding:= ce_utf8n;
   reader1:= tstatreader.create(stream1);
   if reader1.findsection('nodecopy') and 
        (reader1.readmsestring('signature','') = nodecopysig) then begin
    node1:= tstoredcomponent.create(true);
    node1.fpasting:= true;
    node1.dostatread(reader1);   
    node1.fpasting:= false;
    with node.item do begin
     expanded:= true;
     add(node1);
     grid.row:= grid.row + count;
    end;
   end;
  finally
   reader1.free;
   stream1.free;
  end;
 end;
end;

procedure tcomponentstorefo.beforedrag(const sender: TObject;
               const apos: pointty; var dragobject: tdragobject;
               var processed: Boolean);
var
 widget1: twidget;
begin
end;

procedure tcomponentstorefo.drago(const sender: ttreeitemedit;
               const source: ttreelistitem; const dest: ttreelistitem;
               var dragobject: ttreeitemdragobject; var accept: Boolean;
               var processed: Boolean);
begin
 accept:= not dest.checkancestor(source);
end;

end.

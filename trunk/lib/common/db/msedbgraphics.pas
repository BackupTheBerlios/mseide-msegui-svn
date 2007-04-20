{ MSEgui Copyright (c) 1999-2006 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit msedbgraphics;

{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface
uses
 classes,db,mseimage,msedataimage,msedbdispwidgets,msedb,msetypes,msedbedit,
 msegrids,msewidgetgrid,msedatalist,msebitmap,msebintree;

{ add the needed graphic format units to your project:
 mseformatbmpico,mseformatjpg,mseformatpng,
 mseformatpnm,mseformattga,mseformatxpm
}

type
 idbgraphicfieldlink = interface(idbeditfieldlink)
  procedure setformat(const avalue: string);
 end;

 timagecachenode = class(tcachenode)
  private
   fimage: imagebufferinfoty;
  public
   destructor destroy; override;
 end;
 
 timagecache = class(tcacheavltree)
 end;
  
 tmsegraphicfield = class(tmseblobfield)
  private
   fformat: string;
   fimagecache: timagecache;
   function getimagecachekb: integer;
   procedure setimagecachekb(const avalue: integer);
  protected
   procedure removecache(const aid: int64); override;
  public
   destructor destroy; override;
   procedure loadbitmap(const abitmap: tmaskedbitmap; aformat: string);
   procedure clearcache; override;
  published
   property format: string read fformat write fformat;
   property imagecachekb: integer read getimagecachekb 
                           write setimagecachekb default 0;
                //cachesize in kilo bytes, 0 -> no cache
 end;

 tgraphicdatalink = class(teditwidgetdatalink)
  protected
   procedure setfield(const value: tfield); override;
  public
   constructor create(const intf: idbgraphicfieldlink);
   procedure loadbitmap(const abitmap: tmaskedbitmap; const aformat: string);
 end;

 tdbdataimage = class(tcustomdataimage,idbeditinfo,idbgraphicfieldlink,ireccontrol)
  private
   fdatalink: tgraphicdatalink;
   function getdatafield: string; overload;
   procedure setdatafield(const avalue: string);
   function getdatasource: tdatasource;
   procedure setdatasource(const avalue: tdatasource);
   procedure griddatasourcechanged; override;
   function getrowdatapo(const info: cellinfoty): pointer; override;
   function createdatalist(const sender: twidgetcol): tdatalist; override;
     //idbeditinfo
   function getdatasource(const aindex: integer): tdatasource; overload;
   procedure getfieldtypes(out propertynames: stringarty;
                          out fieldtypes: fieldtypesarty); virtual;
     //idbeditfieldlink
   function getgriddatasource: tdatasource;
   function edited: boolean;
   procedure initfocus;
   function checkvalue(const quiet: boolean = false): boolean;
   procedure valuetofield;
   procedure updatereadonlystate;
     //idbgraphicfieldlink
   procedure fieldtovalue; virtual;
   procedure setnullvalue;
   //ireccontrol
   procedure recchanged;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   property datalink: tgraphicdatalink read fdatalink;
  published
   property datafield: string read getdatafield write setdatafield;
   property datasource: tdatasource read getdatasource write setdatasource;
   property format;
 end;
 
implementation
uses
 msestream,msegraphics,sysutils;
 
type
 tsimplebitmap1 = class(tsimplebitmap);
 
 { tdbdataimage }

constructor tdbdataimage.create(aowner: tcomponent);
begin
 fdatalink:= tgraphicdatalink.create(idbgraphicfieldlink(self));
 inherited;
 include(tsimplebitmap1(bitmap).fstate,pms_nosave);
end;

destructor tdbdataimage.destroy;
begin
 inherited;
 fdatalink.free;
end;

function tdbdataimage.getdatafield: string;
begin
 result:= fdatalink.fieldname;
end;

procedure tdbdataimage.setdatafield(const avalue: string);
begin
 fdatalink.fieldname:= avalue;
end;

function tdbdataimage.getdatasource: tdatasource;
begin
 result:= fdatalink.datasource;
end;

procedure tdbdataimage.setdatasource(const avalue: tdatasource);
begin
 fdatalink.datasource:= avalue;
end;

procedure tdbdataimage.getfieldtypes(out propertynames: stringarty; 
                    out fieldtypes: fieldtypesarty);
begin
 propertynames:= nil;
 setlength(fieldtypes,1);
 fieldtypes[0]:= blobfields;
end;

procedure tdbdataimage.fieldtovalue;
begin
 datalink.loadbitmap(bitmap,format);
end;

procedure tdbdataimage.setnullvalue;
begin
 bitmap.clear;
end;

function tdbdataimage.getdatasource(const aindex: integer): tdatasource;
begin
 result:= datasource;
end;

procedure tdbdataimage.recchanged;
begin
 fdatalink.recordchanged(nil);
end;

procedure tdbdataimage.griddatasourcechanged;
begin
 fdatalink.griddatasourcechanged;
end;

function tdbdataimage.getgriddatasource: tdatasource;
begin
 result:= tcustomdbwidgetgrid(fgridintf.getcol.grid).datasource;
end;

function tdbdataimage.edited: boolean;
begin
 result:= false;
end;

procedure tdbdataimage.initfocus;
begin
 //dummy
end;

function tdbdataimage.checkvalue(const quiet: boolean = false): boolean;
begin
 result:= false;
 //dummy
end;

procedure tdbdataimage.valuetofield;
begin
 //dumy
end;

procedure tdbdataimage.updatereadonlystate;
begin
 //dummy
end;

function tdbdataimage.getrowdatapo(const info: cellinfoty): pointer;
begin
 with info do begin
  if griddatalink <> nil then begin
   result:= tgriddatalink(griddatalink).getansistringbuffer(
                                                 fdatalink.field,cell.row);
  end
  else begin
   result:= nil;
  end;
 end;
end;

function tdbdataimage.createdatalist(const sender: twidgetcol): tdatalist;
begin
 result:= nil;
end;

{ tmsegraphicfield }

destructor tmsegraphicfield.destroy;
begin
 freeandnil(fimagecache);
 inherited;
end;

procedure tmsegraphicfield.loadbitmap(const abitmap: tmaskedbitmap; 
                                             aformat: string);
var
 stream1: tstringcopystream;
 str1: string;
 id1: int64;
 n1: timagecachenode;
begin
 if not getid(id1) then begin
  abitmap.clear;
 end
 else begin
  if (fimagecache = nil) or 
               not fimagecache.find(id1,tcachenode(n1)) then begin
   str1:= asstring;
   if str1 = '' then begin
    abitmap.clear;
   end
   else begin
    if aformat = '' then begin
     aformat:= format;
    end;
    stream1:= tstringcopystream.create(str1);
    try
     abitmap.loadfromstream(stream1,aformat);
    except
     abitmap.clear;
    end;
    stream1.free;
   end;
   if fimagecache <> nil then begin
    n1:= timagecachenode.create(id1);
    abitmap.savetoimagebuffer(n1.fimage);
    n1.fsize:= (n1.fimage.image.length + n1.fimage.mask.length) *
                                       sizeof(cardinal);
    fimagecache.addnode(n1);
   end;
  end
  else begin
   abitmap.loadfromimagebuffer(n1.fimage);
  end;
 end;
end;

function tmsegraphicfield.getimagecachekb: integer;
begin
 result:= 0;
 if fimagecache <> nil then begin
  result:= fimagecache.maxsize div 1024;
 end;
end;

procedure tmsegraphicfield.setimagecachekb(const avalue: integer);
begin
 if imagecachekb <> avalue then begin
  if avalue > 0 then begin
   if fimagecache = nil then begin
    fimagecache:= timagecache.create;
   end;
   fimagecache.maxsize:= avalue * 1024;
  end
  else begin
   freeandnil(fimagecache);
  end;
 end;
end;

procedure tmsegraphicfield.clearcache;
begin
 if fimagecache <> nil then begin
  fimagecache.clear;
 end;
 inherited;
end;

procedure tmsegraphicfield.removecache(const aid: int64);
var
 n1: timagecachenode; 
begin
 if fimagecache <> nil then begin
  if fimagecache.find(aid,n1) then begin
   fimagecache.removenode(n1);
   n1.free;
  end;
 end;
 inherited;
end;


{ tgraphicdatalink }

constructor tgraphicdatalink.create(const intf: idbgraphicfieldlink);
begin
 inherited;
end;

procedure tgraphicdatalink.setfield(const value: tfield);
begin
 if value is tmsegraphicfield then begin
  idbgraphicfieldlink(fintf).setformat(tmsegraphicfield(value).format);
 end;
 inherited;
end;

procedure tgraphicdatalink.loadbitmap(const abitmap: tmaskedbitmap;
                                                const aformat: string);
var
 stream1: tstringcopystream;
 str1: string;
begin
 if field is tmsegraphicfield then begin
  with tmsegraphicfield(field) do begin
   loadbitmap(abitmap,aformat);
  end;
 end
 else begin
  str1:= field.asstring;
  if str1 = '' then begin
   abitmap.clear;
  end
  else begin
   stream1:= tstringcopystream.create(str1);
   try
    abitmap.loadfromstream(stream1,aformat);
   except
    abitmap.clear;
   end;
   stream1.free;
  end;
 end;
end;

{ timagecachenode }

destructor timagecachenode.destroy;
begin
 tmaskedbitmap.freeimageinfo(fimage);
 inherited;
end;

end.

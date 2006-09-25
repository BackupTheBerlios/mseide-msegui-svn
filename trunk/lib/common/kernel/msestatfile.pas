unit msestatfile;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
interface
uses
 classes,msestat,msegui,msetypes,msestrings,mseclasses,msestream,mseguiglob;
type
 statupdateeventty = procedure(const sender: tobject; const filer: tstatfiler) of object;
 statreadeventty = procedure(const sender: tobject; const reader: tstatreader) of object;
 statwriteeventty = procedure(const sender: tobject; const writer: tstatwriter) of object;

 statfileoptionty = (sfo_memory,sfo_savedata,sfo_activatorread,sfo_activatorwrite);
 statfileoptionsty = set of statfileoptionty;
const
 defaultstatfileoptions = [sfo_activatorread,sfo_activatorwrite];
 
type
 tstatfile = class(tguicomponent,istatfile)
  private
   ffilename: filenamety;
   ffiledir: filenamety;
   floadedfile: filenamety;

   fstatvarname: msestring;
   fonstatupdate: statupdateeventty;
   fonstatread: statreadeventty;
   fonstatwrite: statwriteeventty;
   fonstatbeforeread: notifyeventty;
   fonstatafterread: notifyeventty;
   fonstatbeforewrite: notifyeventty;
   fonstatafterwrite: notifyeventty;
   areader: tstatreader;
   awriter: tstatwriter;
   foptions: statfileoptionsty;
   fencoding: charencodingty;
   fstatfile: tstatfile;
   procedure dolinkstatread(const info: linkinfoty);
   procedure dolinkstatreading(const info: linkinfoty);
   procedure dolinkstatreaded(const info: linkinfoty);
   procedure dolinkstatwrite(const info: linkinfoty);
   procedure setstatfile(const Value: tstatfile);
   procedure setfilename(const avalue: filenamety);
   procedure setfiledir(const avalue: filenamety);
   procedure setoptions(avalue: statfileoptionsty);
  protected
   procedure objectevent(const sender: tobject;
                          const event: objecteventty); override;
   //istatfile
   procedure dostatread(const reader: tstatreader);
   procedure dostatwrite(const writer: tstatwriter);
   procedure statreading;
   procedure statread;
   function getstatvarname: msestring;
  public
   constructor create(aowner: tcomponent); override;
   procedure initnewcomponent; override;
   procedure readstat(stream: ttextstream = nil); overload;
   procedure readstat(const aname: msestring; const statreader: tstatreader); overload;
   procedure writestat(const stream: ttextstream = nil); overload;
   procedure writestat(const aname: msestring; const statwriter: tstatwriter); overload;
   procedure updatestat(const aname: msestring; const statfiler: tstatfiler);
  published
   property filename: filenamety read ffilename write setfilename nodefault;
   property filedir: filenamety read ffiledir write setfiledir;
   property encoding: charencodingty read fencoding write fencoding default ce_utf8n;
   property options: statfileoptionsty read foptions write setoptions 
                              default defaultstatfileoptions;
   property statfile: tstatfile read fstatfile write setstatfile;
            //filename is stored in linked statfile, dostatread and dostatwrite are
            //called by linked statfile
   property statvarname: msestring read getstatvarname write fstatvarname;
   property activator;
   property onstatupdate: statupdateeventty read fonstatupdate write fonstatupdate;
   property onstatread: statreadeventty read fonstatread write fonstatread;
   property onstatwrite: statwriteeventty read fonstatwrite write fonstatwrite;
   property onstatbeforewrite: notifyeventty read fonstatbeforewrite write fonstatbeforewrite;
   property onstatafterwrite: notifyeventty read fonstatafterwrite write fonstatafterwrite;
   property onstatbeforeread: notifyeventty read fonstatbeforeread write fonstatbeforeread;
   property onstatafterread: notifyeventty read fonstatafterread write fonstatafterread;
 end;

procedure setstatfilevar(const sender: istatfile; const source: tstatfile;
              var instance: tstatfile);
implementation
uses
 msesys,msefileutils,sysutils;
 
procedure setstatfilevar(const sender: istatfile; const source: tstatfile;
              var instance: tstatfile);
begin
 setlinkedcomponent(sender,source,tmsecomponent(instance),typeinfo(istatfile));
end;

{ tstatfile }

constructor tstatfile.create(aowner: tcomponent);
begin
// ffilename:= defaultstatfilename;
 fencoding:= ce_utf8n;
 foptions:= defaultstatfileoptions;
 inherited;
end;

procedure tstatfile.initnewcomponent;
begin
 ffilename:= defaultstatfilename;
end;

procedure tstatfile.dostatread(const reader: tstatreader);
var
 ar1,ar2: stringarty;
 stream1: ttextstream;
begin
 if reader <> areader then begin
  if not (sfo_memory in foptions) then begin
   filename:= reader.readstring('filename',ffilename);
  end
  else begin
   if sfo_savedata in foptions then begin
    stream1:= memorystatstreams.open(ffilename,fm_read);
    try
     ar2:= stream1.readstrings;
    finally
     stream1.free;
    end;
    ar1:= reader.readarray('data',ar2);
    stream1:= memorystatstreams.open(ffilename,fm_create);
    try
     stream1.writestrings(ar1);     
    finally
     stream1.free;
    end;
   end;
  end;
  statread;
 end
 else begin
  if assigned(fonstatupdate) then begin
   fonstatupdate(self,reader);
  end;
  if assigned(fonstatread) then begin
   fonstatread(self,reader);
  end;
 end;
end;

procedure tstatfile.dostatwrite(const writer: tstatwriter);
var
 ar1: stringarty;
 stream1: ttextstream;
begin
 if (writer <> awriter) then begin
  if not (sfo_memory in foptions) then begin
   writer.writestring('filename',ffilename);
  end
  else begin
   if sfo_savedata in foptions then begin
    stream1:= memorystatstreams.open(ffilename,fm_read);
    try
     ar1:= stream1.readstrings;     
    finally
     stream1.free;
    end;
    writer.writearray('data',ar1);
   end;
  end;
//  if ffilename <> '' then begin
//   writestat;
//  end;
 end
 else begin
  if assigned(fonstatupdate) then begin
   fonstatupdate(self,writer);
  end;
  if assigned(fonstatwrite) then begin
   fonstatwrite(self,writer);
  end;
 end;
end;

function tstatfile.getstatvarname: msestring;
begin
 result:= fstatvarname;
end;

procedure tstatfile.dolinkstatread(const info: linkinfoty);
begin
 areader.readstat(istatfile(info.dest));
end;

procedure tstatfile.dolinkstatreading(const info: linkinfoty);
begin
 istatfile(info.dest).statreading;
end;

procedure tstatfile.dolinkstatreaded(const info: linkinfoty);
begin
 istatfile(info.dest).statread;
end;

procedure tstatfile.readstat(stream: ttextstream = nil);
var
 stream1: ttextstream;
 ar1: filenamearty;
begin
 if assigned(fonstatbeforeread) then begin
  fonstatbeforeread(self);
 end;
 stream1:= stream;
 try
  if (stream1 = nil) and (filename <> '') then begin
   try
    if sfo_memory in foptions then begin
     stream1:= memorystatstreams.open(ffilename,fm_read);
    end
    else begin
     unquotefilename(ffiledir,ar1);
     if not findfile(ffilename,ar1,floadedfile) then begin
      floadedfile:= ffilename;
     end;
     stream1:= ttextstream.Create(floadedfile,fm_read);
    end;
    stream1.encoding:= fencoding;
   except
    floadedfile:= '';
   end;
  end;
  areader:= tstatreader.create(stream1);
  try
   if assigned(fonstatread) or assigned(fonstatupdate) then begin
    areader.readstat(istatfile(self));
   end;
   if fobjectlinker <> nil then begin
    fobjectlinker.forall({$ifdef FPC}@{$endif}dolinkstatreading,typeinfo(istatfile));
    try
     fobjectlinker.forall({$ifdef FPC}@{$endif}dolinkstatread,typeinfo(istatfile));
    finally
     fobjectlinker.forall({$ifdef FPC}@{$endif}dolinkstatreaded,typeinfo(istatfile));
    end;
    if assigned(fonstatafterread) then begin
     fonstatafterread(self);
    end;
   end;
  finally
   areader.free;
  end;
 finally
  if stream = nil then begin
   stream1.Free;
  end;
 end;
end;

procedure tstatfile.statreading;
begin
 //dummy
end;

procedure tstatfile.statread;
begin
 //dummy
end;

procedure tstatfile.dolinkstatwrite(const info: linkinfoty);
begin
 awriter.writestat(istatfile(info.dest));
end;

procedure tstatfile.writestat(const stream: ttextstream = nil);
var
 stream1: ttextstream;
 ar1: filenamearty;
begin
 if assigned(fonstatbeforewrite) then begin
  fonstatbeforewrite(self);
 end;
 stream1:= stream;
 if (stream1 = nil) and (filename <> '') then begin
  if sfo_memory in foptions then begin
   stream1:= memorystatstreams.open(ffilename,fm_create);
  end
  else begin
   if floadedfile = '' then begin
    unquotefilename(ffiledir,ar1);
    if not findfile(ffilename,ar1,floadedfile) then begin
     if high(ar1) >= 0 then begin
      floadedfile:= filepath(ar1[0],ffilename);
     end
     else begin
      floadedfile:= ffilename;
     end;
    end;
   end;
   try
    stream1:= ttextstream.Create(floadedfile,fm_create);
   except
    floadedfile:= '';
    raise;
   end;
  end;
  stream1.encoding:= fencoding;
 end;
 try
  awriter:= tstatwriter.create(stream1);
  try
   if assigned(fonstatwrite) or assigned(fonstatupdate) then begin
    awriter.writestat(istatfile(self));
   end;
   if fobjectlinker <> nil then begin
    fobjectlinker.forall({$ifdef FPC}@{$endif}dolinkstatwrite,typeinfo(istatfile));
   end;
   if assigned(fonstatafterwrite) then begin
    fonstatafterwrite(self);
   end;
  finally
   awriter.free;
  end;
 finally
  if stream = nil then begin
   stream1.Free;
  end;
 end;
end;

procedure tstatfile.setstatfile(const Value: tstatfile);
var
 sf: tstatfile;
begin
 if fstatfile <> value then begin
  if value <> nil then begin
   sf:= value;
   while sf <> nil do begin
    if sf = self then begin
     raise exception.Create(name+': Recursive statfile');
    end;
    sf:= sf.fstatfile;
   end;
  end;
  setstatfilevar(istatfile(self),value,fstatfile);
 end;
end;

procedure tstatfile.setfilename(const avalue: filenamety);
begin
 floadedfile:= '';
 ffilename:= avalue;
end;

procedure tstatfile.setfiledir(const avalue: filenamety);
begin
 floadedfile:= '';
 ffiledir:= avalue;
end;

procedure tstatfile.setoptions(avalue: statfileoptionsty);
begin
 if not (sfo_memory in avalue) then begin
  exclude(avalue,sfo_savedata);
 end;
 foptions:= avalue;
end;

procedure tstatfile.objectevent(const sender: tobject;
               const event: objecteventty);
begin
 inherited;
 if (sender = activator) and not (csdesigning in componentstate) then begin
  case event of
   oe_activate: begin
    readstat;
   end;
   oe_deactivate: begin
    writestat;
   end;
  end;
 end;
end;

procedure tstatfile.readstat(const aname: msestring;
                                 const statreader: tstatreader);
var
 stream: ttextstream;
 ar1: msestringarty;
begin
 ar1:= statreader.readarray(aname,msestringarty(nil));
 stream:= ttextstream.Create;
 try
  stream.writemsestrings(ar1);
  stream.Position:= 0;
  readstat(stream);
 finally
  stream.Free;
 end;
end;

procedure tstatfile.writestat(const aname: msestring;
                                         const statwriter: tstatwriter);
var
 stream: ttextstream;
 ar1: msestringarty;
begin
 stream:= ttextstream.Create;
 try
  writestat(stream);
  stream.position:= 0;
  ar1:= stream.readmsestrings;
  statwriter.writearray(aname,ar1);
 finally
  stream.Free;
 end;
end;

procedure tstatfile.updatestat(const aname: msestring; const statfiler: tstatfiler);
begin
 if statfiler.iswriter then begin
  writestat(aname,tstatwriter(statfiler));
 end
 else begin
  readstat(aname,tstatreader(statfiler));
 end;
end;

end.

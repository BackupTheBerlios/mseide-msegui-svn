unit mseformatjpgwrite;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
const
 jpglabel = 'jpg';
 
implementation
uses
 classes,msegraphics,msebitmap,fpreadjpeg,msegraphicstream,msestockobjects,
 msestream,fpwritejpeg,sysutils,typinfo;

procedure writegraphic(const dest: tstream;
                               const source: tobject;
                               const params: array of const);
                            //[compressionquality: integer] 0..100, default 75
var
 ima: tmsefpmemoryimage;
 writer: tfpwriterjpeg;
begin
 try
  ima:= tmsefpmemoryimage.create(0,0);
  ima.assign(tpersistent(source));
  writer:= tfpwriterjpeg.create;
  if (length(params) > 0) and (tvarrec(params[0]).vtype = vtinteger) then begin
   writer.compressionquality:= tvarrec(params[0]).vinteger;
  end;
  ima.writetostream(dest,writer);
 finally
  ima.free;
 end;
end;
 
initialization
 registergraphicformat(jpglabel,nil,{$ifdef FPC}@{$endif}writegraphic,
         stockobjects.captions[sc_JPEG_Image],['*.jpg','*.jpeg']);

end.

unit imageselectorform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 classes,mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msedataedits,msedatanodes,mseedit,
 msegrids,mselistbrowser,msestrings,msetypes,msebitmap,msestatfile;
type
 timageselectorfo = class(tmseform)
   lv: tlistview;
   tstatfile1: tstatfile;
   procedure itemev(const sender: tcustomlistview; const index: Integer;
                   var info: celleventinfoty);
  private
   fimagelist: timagelist;
   fimagenr: integer;
  public
   constructor create(const aowner: tcomponent; const aimagelist: timagelist;
                      var aimagenr: integer); reintroduce;
 end;
implementation
uses
 imageselectorform_mfm,sysutils;
 
{ timageselectorfo }

constructor timageselectorfo.create(const aowner: tcomponent;
               const aimagelist: timagelist; var aimagenr: integer);
var
 int1: integer;
begin
 if aimagelist <> nil then begin
  fimagelist:= aimagelist;
  fimagenr:= aimagenr;
  inherited create(aowner);
  with lv do begin
   int1:= aimagelist.width + 2;
   if int1 < 20 then begin
    int1:= 20;
   end;
   cellwidth:= int1;
   cellheight:= aimagelist.height + font.lineheight + 3;
  end;
  with lv.itemlist do begin
   imagelist:= aimagelist;
   count:= aimagelist.count;
   imagewidth:= aimagelist.width;
   imageheight:= aimagelist.height+2;
   for int1:= 0 to count -1 do begin
    with items[int1] do begin
     imagenr:= int1;
     caption:= inttostr(int1);
    end;
   end;
  end;
  lv.focusedindex:= fimagenr;
  show(true);
  aimagenr:= fimagenr;
 end;
 release;
end;

procedure timageselectorfo.itemev(const sender: tcustomlistview;
               const index: Integer; var info: celleventinfoty);
begin
 if iscellclick(info) then begin
  fimagenr:= index;
  window.modalresult:= mr_ok;
 end;
end;

end.

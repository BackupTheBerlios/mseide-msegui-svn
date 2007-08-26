unit psimportmsegui;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
interface
uses
 upscomponent,upscompiler,upsruntime;
type
 tpsimportmsegui = class(tpsplugin)
  protected
   procedure CompOnUses(CompExec: TPSScript); override;
   procedure ExecOnUses(CompExec: TPSScript); override;
 end;
 
procedure registermsegui_c(s: tpspascalcompiler);
procedure registermsegui_r(s: tpsexec);

implementation
uses
 msewidgets,upsutils;
 
procedure registermsegui_c(s: tpspascalcompiler);
begin
 with s do begin
  addtype('msestring',btwidestring);
  adddelphifunction(
  'procedure showmessage1(const atext: msestring; const caption: msestring);')
 end;
end;

procedure registermsegui_r(s: tpsexec);
begin
 with s do begin
  registerdelphifunction(@showmessage1,'SHOWMESSAGE1',cdregister);
 end;
end;

{ tpsimportmsegui }

procedure tpsimportmsegui.CompOnUses(CompExec: TPSScript);
begin
 registermsegui_c(compexec.comp);
end;

procedure tpsimportmsegui.ExecOnUses(CompExec: TPSScript);
begin
 registermsegui_r(compexec.exec);
end;

end.


unit regexperimental;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
interface
implementation
uses
 msedesignintf;
 
procedure Register;
begin
// registercomponents('Exp',[]);
 registercomponenttabhints(['Exp'],['Experimental Components']);
end;
initialization
 register;
end.

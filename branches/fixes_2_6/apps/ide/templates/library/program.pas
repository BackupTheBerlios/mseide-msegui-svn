program ${%PROGRAMNAME%};
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifdef mswindows}{$apptype console}{$endif}
uses
 {$ifdef FPC}{$ifdef linux}cthreads,cwstring{$endif}{$endif}
 sysutils;
begin
end.

unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms;

type
 tmainfo = class(tmseform)
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
end.

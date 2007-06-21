{ MSEgui Copyright (c) 1999-2007 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit mseuniintf; //i386-linux

{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
interface
uses
 msegraphics;
 
{$include ../mseuniintf.inc}

implementation
uses
 mseguiintf;
 
function uni_getfontwithglyph(var drawinfo: drawinfoty): boolean;
begin
 if hasxft then begin
  result:= gui_getfont(drawinfo);
 end
 else begin
  result:= gui_getfont(drawinfo);
 end;
end;

end.

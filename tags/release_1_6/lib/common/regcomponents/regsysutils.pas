{ MSEgui Copyright (c) 1999-2006 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit regsysutils;

{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface

implementation
uses
 msedesignintf,msesysenv,msefilechange,regsysutils_bmp;

procedure Register;
begin
 registercomponents('NoGui',[tsysenvmanager,tfilechangenotifyer]);
end;

initialization
 register;
end.

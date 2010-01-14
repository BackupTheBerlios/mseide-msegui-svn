{ MSEgui Copyright (c) 1999-2006 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit regdialogs;

{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 Classes,msefiledialog,msedesignintf,regdialogs_bmp,msecolordialog,
 msememodialog;

procedure Register;
begin
 registercomponents('Dialog',[tfilelistview,tfiledialog,
                     tfilenameedit,{thistoryfilenameedit,}
                     tdirdropdownedit,tcoloredit,tmemodialogedit,
                     tmemodialoghistoryedit]);
 registercomponenttabhints(['Dialog'],['User Dialogs']);
end;

initialization
 register;
end.

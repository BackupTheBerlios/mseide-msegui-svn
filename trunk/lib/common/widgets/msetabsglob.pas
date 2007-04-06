{ MSEgui Copyright (c) 1999-2007 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit msetabsglob;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
interface
const
 defaulttabsizemin = 20;
 defaulttabsizemax = 200;

type
  tabbaroptionty = (tabo_dragsource,tabo_dragdest,
                     tabo_dragsourceenabledonly,tabo_dragdestenabledonly,
                                //no action on disabled pages
                     tabo_vertical,tabo_opposite,
                     tabo_buttonsoutside,tabo_tabsizing,
                     tabo_acttabfirst,tabo_clickedtabfirst,tabo_dblclickedtabfirst,
                     tabo_sorted);
 tabbaroptionsty = set of tabbaroptionty;

implementation
end.

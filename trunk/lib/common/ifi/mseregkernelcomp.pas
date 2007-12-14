unit mseregkernelcomp;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
interface
implementation
uses
 classes,msestatfile,mseact,mseapplication,msetimer,mseguithread,
 msepipestream,msemenus,msegui,msebitmap,mseactions,mseprinter;
initialization
 registerclasses([tstatfile,tnoguiaction,tactivator,
                             ttimer,tthreadcomp,tpipereadercomp,
                    tmainmenu,tpopupmenu,tfacecomp,tframecomp,
                    tbitmapcomp,timagelist,taction,
                    tpagesizeselector,tpageorientationselector
                    ]);
end.

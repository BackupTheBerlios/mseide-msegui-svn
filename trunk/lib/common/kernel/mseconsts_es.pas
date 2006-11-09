{ MSEgui Copyright (c) 1999-2006 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    Spanish translation by Julio Jimenez Borreguero.
    
} 
unit mseconsts_es;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
interface
uses
 mseconsts;
 
implementation
const
 es_modalresulttext: defaultmodalresulttextty =
 ('',            //mr_none
  '',            //mr_canclose
  '',            //mr_windowclosed
  '',            //mr_windowdestroyed
  '',            //mr_escape
  '',            //mr_f10
  '',            //mr_exception
  '&Cancelar',   //mr_cancel
  '&Abortar',    //mr_abort
  '&OK',         //mr_ok
  '&Si',         //mr_yes
  '&No',         //mr_no
  '&Todo',       //mr_all
  'N&o todo',    //mr_noall
  '&Ignorar'     //mr_ignore
  );

 es_modalresulttextnoshortcut: defaultmodalresulttextty =
 ('',           //mr_none
  '',           //mr_canclose
  '',           //mr_windowclosed
  '',           //mr_windowdestroyed
  '',           //mr_escape
  '',           //mr_f10
  '',           //mr_exception
  'Cancelar',   //mr_cancel
  'Abortar',    //mr_abort
  'OK',         //mr_ok
  'Si',         //mr_yes
  'No',         //mr_no
  'Todo',       //mr_all
  'No todo',    //mr_noall
  'Ignorar'     //mr_ignore
  );

 es_stockcaption: stockcaptionty = (
  '',                           //sc_none
  'es inv'#225'lido',           //sc_is_invalid
  'Error de formato',           //sc_Format_error
  'Debe introducir un valor',   //sc_Value_is_required
  'Error',                      //sc_Error
  'Min',                        //sc_Min
  'M'#225'x',                   //sc_Max
  'Error de rango',             //sc_Range_error  
  '&Deshacer',                  //sc_Undo  ///
  '&Copiar',                    //sc_Copy   // hotkeys
  'C&ortar',                    //sc_Cut    //
  '&Pegar',                     //sc_Paste ///
  '&Directorio',                //sc_Dir               /// 
  '&Arriba',                    //sc_Up                 //
  'N&uevo dir.',                //sc_New_dir            // hotkeys
  'N&ombre',                    //sc_Name               //
  '&Mostrar archivos ocultos',  //sc_Show_hidden_files  //
  '&Filtrar',                   //sc_Filter            ///   
  'Guardar',                    //sc_save 
  'Abrir',                      //sc_open
  'Formato gr'#225'fico no soportado', //sc_graphic_not_supported
  'Error de formato gr'#225'fico',     //sc_graphic_format_error
  'MS Bitmap',                         //sc_MS_Icon
  'MS Icono',                          //sc_MS_Icon
  'JPEG imagen',                       //sc_JPEG_Image 
  'PNG imagen',                        //sc_PNG_Image
  'XPM imagen',                        //sc_XPM_Image
  'PNM imagen',                        //sc_PNM_Image
  'TARGA imagen',                      //sc_TARGA_image
  'Todo',                              //sc_All
  'Confirmaci'#243'n',                 //sc_Confirmation
  'Borrar registro?'                   //sc_Delete_record
);
    
initialization
 registerlangconsts(langnames[la_es],es_stockcaption,es_modalresulttext,
                               es_modalresulttextnoshortcut);
end.

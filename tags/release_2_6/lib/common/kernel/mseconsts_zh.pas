{ MSEgui Copyright (c) 1999-2009 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    Chinese translation by liuzg2.
    
} 
unit mseconsts_zh;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseconsts;
 
implementation
uses
 msestrings,sysutils;
const
 zh_modalresulttext: defaultmodalresulttextty =
 ('',                        //mr_none
  '',                        //mr_canclose
  '',                        //mr_windowclosed
  '',                        //mr_windowdestroyed
  '',                        //mr_escape
  '',                        //mr_f10
  '',                        //mr_exception
  '&C'#31163#24320,          //mr_cancel
  '&A'#21462#28040,          //mr_abort
  '&O'#30830#23450,          //mr_ok
  '&Y'#26159,                //mr_yes
  '&N'#21542,                //mr_no
  '&l'#25152#26377,          //mr_all
  #21462#28040#25152#26377,  //mr_noall
  '&g'#24573#30053           //mr_ignore
  );

 zh_modalresulttextnoshortcut: defaultmodalresulttextty =
 ('',                       //mr_none
  '',                       //mr_canclose
  '',                       //mr_windowclosed
  '',                       //mr_windowdestroyed
  '',                       //mr_esc
  '',                       //mr_f10
  '',                       //mr_exception
  #31163#24320,             //mr_cancel
  #21462#28040,             //mr_abort
  #30830#23450,             //mr_ok
  #26159,                   //mr_yes
  #21542,                   //mr_no
  #25152#26377,             //mr_all
  #21462#28040#25152#26377, //mr_noall
  #24573#30053              //mr_ignore
  );

 zh_stockcaption: stockcaptionaty = (
  '',                                 //sc_none
  #26080#25928,                       //sc_is_invalid
  #26684#24335#38169#35823,           //sc_Format_error
  #20540#19981#33021#20026#31354,     //sc_Value_is_required
  #38169#35823,                       //sc_Error
  #26368#23567,                       //sc_Min
  #26368#22823,                       //sc_Max
  #28322#20986#38169#35823,           //sc_Range_error  

  '&u'#21462#28040,                   //sc_Undo  ///              ///
  '&Redo',                            //sc_Redo   //               //
  '&c'#22797#21046,                   //sc_Copy   // hotkeys       //
  '&t'#21098#20999,                   //sc_Cut    //               //
  '&p'#31896#36148,                   //sc_Paste ///               // hotkeys
  '&I'#25554#20837#19968#34892,       //sc_insert_row ///          //
  '&A'#22686#21152#19968#34892,       //sc_append_row  // hotkeys  //
  '&D'#21024#38500#25152#36873#34892, //sc_delete_row ///         ///

  '&D'#25991#20214#22841,                    //sc_Dir               /// 
  '&Home',                                   //sc_home               //
  '&U'#21521#19978,                          //sc_Up                 //
  '&N'#26032#25991#20214#22841,              //sc_New_dir            // hotkeys
  '&N'#25991#20214#21517,                    //sc_Name               //
  '&S'#26174#31034#38544#34255#25991#20214,  //sc_Show_hidden_files  //
  '&F'#20445#23384#31867#22411,              //sc_Filter            /// 
  #20445#23384,                              //sc_save 
  'O'#25171#24320,                           //sc_open
  #21517#31216,                              //sc_name1
  #26032#24314#25991#20214#22841,            //sc_create_new_directory
  #25991#20214,                              //sc_file
  #25991#20214#24050#32463#23384#22312#65292#26159#21542#35206#30422#65311, //sc_exists_overwrite
  #35686#21578,                              //sc_warningupper
  #38169#35823,                              //sc_errorupper
  #19981#23384#22312,                        //sc_does_not_exist
  #25214#19981#21040#25991#20214#22841,      //sc_can_not_read_directory
  #22270#24418#26684#24335#19981#25903#25345,//sc_graphic_not_supported
  #22270#24418#26684#24335#38169#35823,      //sc_graphic_format_error
  'MS Bitmap',          //sc_MS_Bitmap
  'MS Icon',            //sc_MS_Icon
  'JPEG Image',         //sc_JPEG_Image 
  'PNG Image',          //sc_PNG_Image
  'XPM Image',          //sc_XPM_Image
  'PNM Image',          //sc_PNM_Image
  'TARGA Image',        //sc_TARGA_image
  #25152#26377,                        //sc_All
  #35777#26126,                        //sc_Confirmation
  #21024#38500#35760#24405#65311,      //sc_Delete_record
  #20851#38381#39029,                  //sc_close_page
  #31532#19968#26465,                  //sc_first
  #21069#19968#26465,                  //sc_prior
  #19979#19968#26465,                  //sc_next
  #26368#21518,                        //sc_last
  #22686#21152,                        //sc_append
  #21024#38500,                        //sc_delete
  #20462#25913,                        //sc_edit
  #20445#23384,                        //sc_post
  #31163#24320,                        //sc_cancel
  #21047#26032,                        //sc_refresh
  #32534#36753#22120#36807#28388,      //sc_filter_filter
  'Edit filter minimum',               //sc_edit_filter_min
  'Edit filter maximum',               //sc_filter_edit_max
  #36807#28388#24320#21551,            //sc_filter_on
  #26597#25214,                        //sc_search
  #25554#20837,                        //sc_insert
  #36807#28388#20851#38381,            //sc_filter_off
  'Portrait',                          //sc_portrait print orientation
  'Landscape',                         //sc_landscape print orientation
  #30830#23450#21024#38500#27492#26465#35760#24405#21527#65311,
                                      //sc_Delete_row_question
  #30830#23450#21024#38500#25152#36873#35760#24405#21527#65311,
                                      //sc_selected_rows
  'Single item only',    //sc_Single_item_only 
  'Copy Cells',          //sc_Copy_Cells
  'Paste Cells'          //sc_Paste_Cells
                       );
    
function delete_n_selected_rows(const params: array of const): msestring;
begin
 with params[0] do begin
  if vinteger = 1 then begin
   result:= #30830#23450#21024#38500#27492#26465#35760#24405#21527#65311
  end
  else begin
   result:= #30830#23450#21024#38500#25152#36873#25321#30340' '+
                    inttostr(vinteger)+' '#34892#35760#24405#21527#65311;
  end;
 end;
end;

const
 zh_textgenerator: defaultgeneratortextty = (
              {$ifdef FPC}@{$endif}delete_n_selected_rows //tg_delete_n_selected_rows
                                     );
initialization
 registerlangconsts(langnames[la_zh],@zh_stockcaption,@zh_modalresulttext,
                               @zh_modalresulttextnoshortcut,@zh_textgenerator);
end.

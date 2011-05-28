{ MSEgui Copyright (c) 1999-2010 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    Indonesia translation by Wahono.
    
} 
unit mseconsts_id;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseconsts,msestrings,sysutils;
 
implementation
const
 id_modalresulttext: defaultmodalresulttextty =
 ('',            //mr_none
  '',            //mr_canclose
  '',            //mr_windowclosed
  '',            //mr_windowdestroyed
  '',            //mr_escape
  '',            //mr_f10
  '',            //mr_exception
  '&Batal',   //mr_cancel
  '&Gagalkan',    //mr_abort
  '&OK',         //mr_ok
  '&Ya',      //mr_yes
  '&Tidak',         //mr_no
  '&Semua',       //mr_all
  'Tid&ak Semua',    //mr_noall
  '&Abaikan'     //mr_ignore
  );

 id_modalresulttextnoshortcut: defaultmodalresulttextty =
 ('',           //mr_none
  '',           //mr_canclose
  '',           //mr_windowclosed
  '',           //mr_windowdestroyed
  '',           //mr_escape
  '',           //mr_f10
  '',           //mr_exception
  'Gagal',   //mr_cancel
  'Batal',    //mr_abort
  'OK',         //mr_ok
  'Ya',      //mr_yes
  'Tidak',         //mr_no
  'Semua',       //mr_all
  'Tidak Semua',    //mr_noall
  'Abaikan'     //mr_ignore
  );

 id_stockcaption: stockcaptionaty = (
  '',                      //sc_none
  'adalah salah',          //sc_is_invalid
  'Format salah',          //sc_Format_error
  'Nilai dibutuhkan',      //sc_Value_is_required
  'Salah',                 //sc_Error
  'Min',                   //sc_Min
  'Max',                   //sc_Max
  'Range salah',           //sc_Range_error  
  '&Batal',                //sc_Undohk  ///
  '&Redo',                 //sc_Redohk   //               //
  '&Salin',                //sc_Copyhk   // hotkeys
  'Po&tong',               //sc_Cuthk    //
  '&Tempel',               //sc_Pastehk ///
  '&Sisipkan Baris',       //sc_insert_rowhk
  '&Tambah Baris',         //sc_append_rowhk
  '&Hapus Baris',          //sc_delete_rowhk
  '&Direktori',            //sc_Dirhk               /// 
  '&Home',                 //sc_homehk               //
  '&Naik',                 //sc_Uphk                 //
  'Dir &Baru',             //sc_New_dirhk            // hotkeys
  '&Nama File',            //sc_Namehk               //
  '&File tersembunyi',     //sc_Show_hidden_fileshk  //
  '&Filter',               //sc_Filterhk            /// 
  'Simpan',                //sc_save 
  'Buka',                  //sc_open
  'Nama',                  //sc_name
  'Buat Direktori Baru',   //sc_create_new_directory
  'File',                  //sc_file
  'sudah ada, akan ditimpa?', //sc_exists_overwrite
  'PERINGATAN',            //sc_warningupper
  'SALAH',                 //sc_errorupper
  'tidak ada',             //sc_does_not_exist
  'tidak dapat membaca direktori', //sc_can_not_read_directory
  'Format grafik tidak didukung', //sc_graphic_not_supported
  'Format grafik salah',  //sc_graphic_format_error
  'MS Bitmap',            //sc_MS_Bitmap
  'MS Icon',              //sc_MS_Icon
  'JPEG Image',           //sc_JPEG_Image 
  'PNG Image',            //sc_PNG_Image
  'XPM Image',            //sc_XPM_Image
  'PNM Image',            //sc_PNM_Image
  'TARGA Image',          //sc_TARGA_image
  'Semua',                //sc_All
  'Konfirmasi',           //sc_Confirmation
  'Hapus Rekaman?',       //sc_Delete_record_question
  'Copy record?',         //sc_Copy_record_question
  'Tutup',                //sc_close_page
  'Awal',                 //sc_first
  'Sebelum',              //sc_prior
  'Sesudah',              //sc_next
  'Akhir',                //sc_last
  'Tambah',               //sc_append
  'Hapus',                //sc_delete
  'Rubah',                //sc_edit
  'Simpan',               //sc_post
  'Batal',                //sc_cancel
  'Refresh',              //sc_refresh
  'Rubah filter',         //sc_filter_filter
  'Rubah filter minimum', //sc_edit_filter_min
  'Rubah filter maximum', //sc_filter_edit_max
  'Filter hidup',         //sc_filter_on
  'Cari',                 //sc_search
  'Auto edit',            //sc_autoedit
  'Copy record',          //sc_copy_record
  'Dialog',               //sc_dialog
  'Sisipkan',             //sc_insert
  'Copy',                 //sc_copy
  'Filter mati',          //sc_filter_off
  'Berdiri',              //sc_portrait print orientation
  'Rebah',                //sc_landscape print orientation
  'Hapus baris?',          //sc_Delete_row_question
  'baris yang terpilih?',        //sc_selected_rows
  'Hanya satu item',     //sc_Single_item_only,
  'Salin Cell',          //sc_Copy_Cells
  'Tempel Cell'          //sc_Paste_Cells 
);
    
function delete_n_selected_rows(const params: array of const): msestring;
begin
 with params[0] do begin
  if vinteger = 1 then begin
   result:= 'Delete selected row?'
  end
  else begin
   result:= 'Delete '+inttostr(vinteger)+' selected rows?';
  end;
 end;
end;

const
 id_textgenerator: defaultgeneratortextty = (
              {$ifdef FPC}@{$endif}delete_n_selected_rows //tg_delete_n_selected_rows
                                     );
initialization
 registerlangconsts(langnames[la_id],@id_stockcaption,@id_modalresulttext,
                               @id_modalresulttextnoshortcut,@id_textgenerator);
end.

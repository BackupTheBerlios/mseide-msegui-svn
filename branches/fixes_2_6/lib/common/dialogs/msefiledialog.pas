{ MSEgui Copyright (c) 1999-2011 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit msefiledialog;

{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

uses
 mseglob,mseguiglob,msegui,mseforms,Classes,mseclasses,msewidgets,msegrids,
 mselistbrowser,mseedit,msesimplewidgets,msedataedits,msedialog,msetypes,
 msestrings,msesys,msedispwidgets,msedatalist,msestat,msestatfile,msebitmap,
 msedatanodes,msefileutils,msedropdownlist,mseevent,msegraphedits,mseeditglob,
 msesplitter,msemenus,msegridsglob,msegraphics,msegraphutils;

const
 defaultlistviewoptionsfile = defaultlistviewoptions + [lvo_readonly];
 
type
 tfilelistitem = class(tlistitem)
  private
  protected
  public
   constructor create(const aowner: tcustomitemlist);
 end;
 pfilelistitem = ^tfilelistitem;

 tfileitemlist = class(titemviewlist)
  protected
   procedure createitem(out item: tlistitem); override;
 end;

 getfileiconeventty = procedure(const sender: tobject; const ainfo: fileinfoty;
              var imagelist: timagelist; var imagenr: integer) of object;
 
 tfilelistview = class(tlistview)
  private
   ffilelist: tfiledatalist;
   foptionsfile: filelistviewoptionsty;
   fmaskar: filenamearty;
   fdirectory: filenamety;
   ffilecount: integer;
   fincludeattrib,fexcludeattrib: fileattributesty;
   fonlistread: notifyeventty;
   ffocusmoved: boolean;
   fongetfileicon: getfileiconeventty;
   foncheckfile: checkfileeventty;
   procedure filelistchanged(const sender: tobject);
   procedure setfilelist(const Value: tfiledatalist);
   function getpath: msestring;
   procedure setpath(const Value: msestring);
   procedure setdirectory(const Value: msestring);
   function getmask: filenamety;
   procedure setmask(const value: filenamety);
   function getselectednames: filenamearty;
   procedure setselectednames(const avalue: filenamearty);
   function getchecksubdir: boolean;
   procedure setchecksubdir(const avalue: boolean);
   procedure setoptionsfile(const avalue: filelistviewoptionsty);
   procedure checkcasesensitive;
  protected
   foptionsdir: dirstreamoptionsty;
   fcaseinsensitive: boolean;
//   procedure setoptions(const Value: listviewoptionsty); override;
   procedure docellevent(var info: celleventinfoty); override;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   procedure readlist;
   procedure updir;
   function filecount: integer;
   property directory: filenamety read fdirectory write setdirectory;
   property includeattrib: fileattributesty read fincludeattrib 
                  write fincludeattrib default [fa_all];
   property excludeattrib: fileattributesty read fexcludeattrib 
                  write fexcludeattrib default [fa_hidden];
   property maskar: filenamearty read fmaskar write fmaskar; //nil -> all
   property mask: filenamety read getmask write setmask; //'' -> all
   property path: filenamety read getpath write setpath;
                  //calls readlist
   property selectednames: filenamearty read getselectednames write setselectednames;
   property  checksubdir: boolean read getchecksubdir write setchecksubdir;
  published
   property options default defaultlistviewoptionsfile;
   property optionsfile: filelistviewoptionsty read foptionsfile 
                 write setoptionsfile default defaultfilelistviewoptions;
   property filelist: tfiledatalist read ffilelist write setfilelist;
   property onlistread: notifyeventty read fonlistread write fonlistread;
   property ongetfileicon: getfileiconeventty read fongetfileicon 
                                              write fongetfileicon;
   property oncheckfile: checkfileeventty read foncheckfile write foncheckfile;
 end;

const
 defaulthistorymaxcount = 10;
 
type
 filedialogoptionty = (fdo_filtercasesensitive,    //flvo_maskcasesensitive
                       fdo_filtercaseinsensitive,  //flvo_maskcaseinsensitive
                       fdo_save,
                       fdo_dispname,fdo_dispnoext,fdo_sysfilename,fdo_params,
                       fdo_directory,fdo_file,
                       fdo_absolute,fdo_relative,fdo_quotesingle,
                       fdo_link, //links lastdir of controllers with same group
                       fdo_checkexist,fdo_acceptempty,fdo_single,
                       fdo_chdir,fdo_savelastdir,
                       fdo_checksubdir);
 filedialogoptionsty = set of filedialogoptionty;
const
 defaultfiledialogoptions = [fdo_savelastdir];
type
 filedialogkindty = (fdk_none,fdk_open,fdk_save,fdk_new);

 tfiledialogcontroller = class;

 filedialogbeforeexecuteeventty = procedure(const sender: tfiledialogcontroller;
              var dialogkind: filedialogkindty; var aresult: modalresultty) of object;
 filedialogafterexecuteeventty = procedure(const sender: tfiledialogcontroller;
              var aresult: modalresultty) of object;

 tfiledialogcontroller = class(tlinkedpersistent)
  private
   fowner: tmsecomponent;
   fgroup: integer;
   fonchange: proceventty;
   ffilenames: filenamearty;
   ffilterlist: tdoublemsestringdatalist;
   ffilter: filenamety;
   ffilterindex: integer;
   fcolwidth: integer;
   fwindowrect: rectty;
   fhistorymaxcount: integer;
   fhistory: msestringarty;
   fcaptionopen: msestring;
   fcaptionsave: msestring;
   fcaptionnew: msestring;
   finclude: fileattributesty;
   fexclude: fileattributesty;
   fonbeforeexecute: filedialogbeforeexecuteeventty;
   fonafterexecute: filedialogafterexecuteeventty;
   fongetfilename: setstringeventty;
   fongetfileicon: getfileiconeventty;
   foncheckfile: checkfileeventty;
   fimagelist: timagelist;
   fparams: msestring;
   procedure setfilterlist(const Value: tdoublemsestringdatalist);
   procedure sethistorymaxcount(const Value: integer);
   function getfilename: filenamety;
   procedure setfilename(const avalue: filenamety);
   procedure dochange;
   procedure setdefaultext(const avalue: filenamety);
   procedure setoptions(Value: filedialogoptionsty);
   procedure checklink;
   procedure setlastdir(const avalue: filenamety);
   procedure setimagelist(const avalue: timagelist);
   function getsyscommandline: filenamety;
  protected
   flastdir: filenamety;
   fdefaultext: filenamety;
   foptions: filedialogoptionsty;
  public
   constructor create(const aowner: tmsecomponent = nil; 
                    const onchange: proceventty = nil); reintroduce;
   destructor destroy; override;
   procedure readstatvalue(const reader: tstatreader);
   procedure readstatstate(const reader: tstatreader);
   procedure readstatoptions(const reader: tstatreader);
   procedure writestatvalue(const writer: tstatwriter);
   procedure writestatstate(const writer: tstatwriter);
   procedure writestatoptions(const writer: tstatwriter);
   function actcaption(const dialogkind: filedialogkindty): msestring;
   function execute(dialogkind: filedialogkindty = fdk_none): modalresultty; overload;
                           //fdk_none -> use options fdo_save
   function execute(dialogkind: filedialogkindty; const acaption: msestring;
              aoptions: filedialogoptionsty): modalresultty; overload;
   function execute(const dialogkind: filedialogkindty;
                         const acaption: msestring): modalresultty; overload;
   function execute(const dialogkind: filedialogkindty;
                         const aoptions: filedialogoptionsty): modalresultty; overload;
   function execute(var avalue: filenamety;
                  dialogkind: filedialogkindty = fdk_none): boolean; overload;
   function execute(var avalue: filenamety; const  dialogkind: filedialogkindty;
                  const acaption: msestring): boolean; overload;
   procedure clear;
   procedure componentevent(const event: tcomponentevent);
   property history: msestringarty read fhistory write fhistory;
   property filenames: filenamearty read ffilenames write ffilenames;
   property syscommandline: filenamety read getsyscommandline;
   property params: msestring read fparams;
  published
   property filename: filenamety read getfilename write setfilename;
   property lastdir: filenamety read flastdir write setlastdir;
   property filter: filenamety read ffilter write ffilter;
   property filterlist: tdoublemsestringdatalist read ffilterlist write setfilterlist;
   property filterindex: integer read ffilterindex write ffilterindex default 0;
   property include: fileattributesty read finclude write finclude default [fa_all];
   property exclude: fileattributesty read fexclude write fexclude default [fa_hidden];
   property colwidth: integer read fcolwidth write fcolwidth default 0;
   property defaultext: filenamety read fdefaultext write setdefaultext;
   property options: filedialogoptionsty read foptions write setoptions 
                                     default defaultfiledialogoptions;
   property historymaxcount: integer read fhistorymaxcount
                          write sethistorymaxcount default defaulthistorymaxcount;
   property captionopen: msestring read fcaptionopen write fcaptionopen;
   property captionsave: msestring read fcaptionsave write fcaptionsave;
   property captionnew: msestring read fcaptionnew write fcaptionnew;
   property group: integer read fgroup write fgroup default 0;
   property imagelist: timagelist read fimagelist write setimagelist;
   property ongetfilename: setstringeventty read fongetfilename write fongetfilename;
   property ongetfileicon: getfileiconeventty read fongetfileicon 
                                              write fongetfileicon;
   property oncheckfile: checkfileeventty read foncheckfile write foncheckfile;
   property onbeforeexecute: filedialogbeforeexecuteeventty
                  read fonbeforeexecute write fonbeforeexecute;
   property onafterexecute: filedialogafterexecuteeventty
                  read fonafterexecute write fonafterexecute;
 end;

const
 defaultfiledialogoptionsedit = defaultoptionsedit+
                                  [oe_savevalue,oe_savestate,oe_saveoptions];
 
type 
 tfiledialog = class(tdialog,istatfile)
  private
   fcontroller: tfiledialogcontroller;
   fstatvarname: msestring;
   fstatfile: tstatfile;
   fdialogkind: filedialogkindty;
   foptionsedit: optionseditty;
   procedure setcontroller(const value: tfiledialogcontroller);
   procedure setstatfile(const Value: tstatfile);
  protected
   //istatfile
   procedure dostatread(const reader: tstatreader);
   procedure dostatwrite(const writer: tstatwriter);
   procedure statreading;
   procedure statread;
   function getstatvarname: msestring;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   function execute: modalresultty; overload; override;
   function execute(const akind: filedialogkindty): modalresultty;
                                                    reintroduce; overload;
   function execute(const akind: filedialogkindty;
                   const aoptions: filedialogoptionsty): modalresultty;
                                                    reintroduce; overload;
   procedure componentevent(const event: tcomponentevent); override;
  published
   property statfile: tstatfile read fstatfile write setstatfile;
   property statvarname: msestring read getstatvarname write fstatvarname;
   property controller: tfiledialogcontroller read fcontroller write setcontroller;
   property dialogkind: filedialogkindty read fdialogkind write fdialogkind
                                                           default fdk_none;
   property optionsedit: optionseditty read foptionsedit write foptionsedit
                                  default defaultfiledialogoptionsedit;
 end;

 tcustomfilenameedit = class;
 tfilenameeditcontroller = class(tstringdialogcontroller)
  protected
   function execute(var avalue: msestring): boolean; override;
  public
   constructor create(const aowner: tcustomfilenameedit);
 end;
 
 tcustomfilenameedit = class(tcustomdialogstringed)
  private
   fcontroller: tfiledialogcontroller;
//   fdialogkind: filedialogkindty;
   procedure setcontroller(const avalue: tfiledialogcontroller);
  protected
   function createdialogcontroller: tstringdialogcontroller; override;
   procedure texttovalue(var accept: boolean; const quiet: boolean); override;
//   function execute(var avalue: msestring): boolean; override;
   procedure updatedisptext(var avalue: msestring); override;
   function getvaluetext: msestring; override;
   procedure readstatvalue(const reader: tstatreader); override;
   procedure readstatstate(const reader: tstatreader); override;
   procedure readstatoptions(const reader: tstatreader); override;
   procedure writestatvalue(const writer: tstatwriter); override;
   procedure writestatstate(const writer: tstatwriter); override;
   procedure writestatoptions(const writer: tstatwriter); override;
   procedure valuechanged; override;
   procedure updatecopytoclipboard(var atext: msestring); override;
   procedure updatepastefromclipboard(var atext: msestring); override;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   procedure componentevent(const event: tcomponentevent); override;
   property controller: tfiledialogcontroller read fcontroller write setcontroller;
  published
//   property dialogkind: filedialogkindty read fdialogkind write fdialogkind default fdk_open;
 end;

 tfilenameedit = class(tcustomfilenameedit)
  published
   property frame;
   property passwordchar;
   property maxlength;
   property value;
   property onsetvalue;
   property controller;
 end; 

 dirdropdowneditoptionty = (ddeo_showhiddenfiles,ddeo_checksubdir);
 dirdropdowneditoptionsty = set of dirdropdowneditoptionty;
 
 tdirdropdownedit = class(tdropdownwidgetedit)
  private
   foptions: dirdropdowneditoptionsty;
   function getshowhiddenfiles: boolean;
   procedure setshowhiddenfiles(const avalue: boolean);
   function getchecksubdir: boolean;
   procedure setchecksubdir(const avalue: boolean);
  protected
   procedure createdropdownwidget(const atext: msestring;
                                     out awidget: twidget); override;
   function getdropdowntext(const awidget: twidget): msestring; override;
   procedure pathchanged(const sender: tobject);
   procedure doafterclosedropdown; override;
   procedure updatecopytoclipboard(var atext: msestring); override;
   procedure updatepastefromclipboard(var atext: msestring); override;
  public
   property showhiddenfiles: boolean read getshowhiddenfiles 
                                               write setshowhiddenfiles;
   property checksubdir: boolean read getchecksubdir 
                                               write setchecksubdir;
  published
   property options: dirdropdowneditoptionsty read foptions 
                                              write foptions default [];
 end;

 tfiledialogfo = class(tmseform)
   cancel: tbutton;
   listview: tfilelistview;
   ok: tbutton;
   showhidden: tbooleanedit;
   namecont: tgroupbox;
   tspacer1: tspacer;
   tspacer2: tspacer;
   bucont: tspacer;
   tspacer4: tspacer;
   up: tbutton;
   createdir: tbutton;
   filename: thistoryedit;
   filter: tdropdownlistedit;
   dir: tdirdropdownedit;
   home: tbutton;
   tspacer3: tspacer;
   procedure createdironexecute(const sender: TObject);
   procedure listviewselectionchanged(const sender: tcustomlistview);
   procedure listviewitemevent(const sender: tcustomlistview;
     const index: Integer; var info: celleventinfoty);
   procedure listviewonkeydown(const sender: twidget; var info: keyeventinfoty);
   procedure upaction(const sender: TObject);
   procedure dironsetvalue(const sender: TObject; var avalue: mseString;
     var accept: Boolean);
   procedure filenamesetvalue(const sender: TObject; var avalue: mseString;
     var accept: Boolean);
   procedure listviewonlistread(const sender: tobject);
   procedure filteronafterclosedropdown(const sender: tobject);
   procedure filteronsetvalue(const sender: tobject; var avalue: msestring; var accept: boolean);
   procedure filepathentered(const sender: tobject);
   procedure okonexecute(const sender: tobject);
   procedure foonchildscaled(const sender: TObject);
   procedure showhiddenonsetvalue(const sender: TObject; var avalue: Boolean; 
                  var accept: Boolean);
   procedure formoncreate(const sender: TObject);
   procedure dirshowhint(const sender: TObject; var info: hintinfoty);
   procedure copytolip(const sender: TObject; var avalue: msestring);
   procedure pastefromclip(const sender: TObject; var avalue: msestring);
   procedure homeaction(const sender: TObject);
  private
    { Private declarations }
   fselectednames: filenamearty;
   procedure updatefiltertext;
   procedure readlist;
   procedure changedir(const adir: filenamety);
  public
   dialogoptions: filedialogoptionsty;
   defaultext: filenamety;
   filenames: filenamearty;
    { Public declarations }
 end;

function filedialog(var afilenames: filenamearty;
           const aoptions: filedialogoptionsty;
           const acaption: msestring;    //'' -> 'Open' or 'Save'
           const filterdesc: array of msestring;
           const filtermask: array of msestring;
           const adefaultext: filenamety = '';
           const filterindex: pinteger = nil;     //nil -> 0
           const filter: pfilenamety = nil;       //nil -> unused
           const colwidth: pinteger = nil;        //nil -> default
           const includeattrib: fileattributesty = [fa_all];
           const excludeattrib: fileattributesty = [fa_hidden];
           const history: pmsestringarty = nil;
           const historymaxcount: integer = defaulthistorymaxcount;
           const imagelist: timagelist = nil;
           const ongetfileicon: getfileiconeventty = nil;
           const oncheckfile: checkfileeventty = nil
                      ): modalresultty; overload;
//theadsave
function filedialog(var afilename: filenamety;
           const aoptions: filedialogoptionsty;
           const acaption: msestring;
           const filterdesc: array of msestring;
           const filtermask: array of msestring;
           const adefaultext: filenamety = '';
           const filterindex: pinteger = nil;     //nil -> 0
           const filter: pfilenamety = nil;       //nil -> unused
           const colwidth: pinteger = nil;        //nil -> default
           const includeattrib: fileattributesty = [fa_all];
           const excludeattrib: fileattributesty = [fa_hidden];
           const history: pmsestringarty = nil;
           const historymaxcount: integer = defaulthistorymaxcount;
           const imagelist: timagelist = nil;
           const ongetfileicon: getfileiconeventty = nil;
           const oncheckfile: checkfileeventty = nil
           ): modalresultty; overload;
//theadsave

procedure getfileicon(const info: fileinfoty; var imagelist: timagelist;
                            out imagenr: integer);
procedure updatefileinfo(const item: tlistitem; const info: fileinfoty;
                   const withicon: boolean);

implementation
uses
 msefiledialog_mfm,sysutils,msebits,
 msestringenter,msedirtree,msefiledialogres,msekeyboard,
 msestockobjects,msesysintf;

procedure getfileicon(const info: fileinfoty; var imagelist: timagelist;
                      out imagenr: integer);
begin
 with info do begin
//  imagelist:= nil;
  imagenr:= -1;
  if fis_typevalid in state then begin
   case extinfo1.filetype of
    ft_dir: begin
     if fis_diropen in state then begin
      filedialogres.getfileicon(fdi_diropen,imagelist,imagenr);
     end
     else begin
      if fis_hasentry in state then begin
       filedialogres.getfileicon(fdi_direntry,imagelist,imagenr);
      end
      else begin
       filedialogres.getfileicon(fdi_dir,imagelist,imagenr);
      end;
     end;
    end;
    ft_reg,ft_lnk: begin
     filedialogres.getfileicon(fdi_file,imagelist,imagenr);
    end;
   end;
  end;
 end;
end;

procedure updatefileinfo(const item: tlistitem; const info: fileinfoty;
                const withicon: boolean);
var
 aimagelist: timagelist;
 aimagenr: integer;
begin
 aimagelist:= item.imagelist;
 item.caption:= info.name;
 if withicon then begin
  getfileicon(info,aimagelist,aimagenr);
  item.imagelist:= aimagelist;
  if aimagelist <> nil then begin
   item.imagenr:= aimagenr;
  end;
 end;
end;

function filedialog1(dialog: tfiledialogfo; var afilenames: filenamearty;
           const filterdesc: array of msestring;
           const filtermask: array of msestring;
           const filterindex: pinteger;
           const afilter: pfilenamety;      //nil -> unused
           const colwidth: pinteger;        //nil -> default
           const includeattrib: fileattributesty;
           const excludeattrib: fileattributesty;
           const history: pmsestringarty;
           const historymaxcount: integer;
           const acaption: msestring;
           const aoptions: filedialogoptionsty;
           const adefaultext: filenamety;
           const imagelist: timagelist;
           const ongetfileicon: getfileiconeventty;
           const oncheckfile: checkfileeventty
           ): modalresultty;
var
 int1: integer;
begin
 with dialog do begin
  dir.checksubdir:= fdo_checksubdir in aoptions;
  listview.checksubdir:= fdo_checksubdir in aoptions;
  dialogoptions:= aoptions;
  if fdo_filtercasesensitive in aoptions then begin
   listview.optionsfile:= listview.optionsfile + [flvo_maskcasesensitive];
  end;
  if fdo_filtercaseinsensitive in aoptions then begin
   listview.optionsfile:= listview.optionsfile + [flvo_maskcaseinsensitive];
  end;
  if fdo_single in aoptions then begin
   listview.options:= listview.options - [lvo_multiselect];
  end;
  defaultext:= adefaultext;
  caption:= acaption;
  listview.includeattrib:= includeattrib;
  listview.excludeattrib:= excludeattrib;
  listview.itemlist.imagelist:= imagelist;
  if imagelist <> nil then begin
   listview.itemlist.imagesize:= imagelist.size;
  end;
  listview.ongetfileicon:= ongetfileicon;
  listview.oncheckfile:= oncheckfile;
  filter.dropdown.cols[0].count:= high(filtermask) + 1;
  for int1:= 0 to high(filtermask) do begin
   if (int1 <= high(filterdesc)) and (filterdesc[int1] <> '') then begin
    filter.dropdown.cols[0][int1]:= filterdesc[int1] + ' ('+
       filtermask[int1] + ')';
   end
   else begin
    filter.dropdown.cols[0][int1]:= filtermask[int1];
   end;
  end;
  filter.dropdown.cols[1].assignopenarray(filtermask);
  if filterindex <> nil then begin
   filter.dropdown.itemindex:= filterindex^;
  end
  else begin
   filter.dropdown.itemindex:= 0;
  end;
  if (afilter = nil) or (afilter^ = '') or
     (filter.dropdown.itemindex >= 0) and
     (afilter^ = filter.dropdown.cols[1][filter.dropdown.itemindex]) then begin
   updatefiltertext;
  end
  else begin
   filter.value:= afilter^;
   listview.mask:= afilter^;
  end;
  if history <> nil then begin
   filename.dropdown.valuelist.asarray:= history^;
   filename.dropdown.historymaxcount:= historymaxcount;
  end
  else begin
   filename.dropdown.options:= [deo_disabled];
  end;
  if (high(afilenames) = 0) and (fdo_directory in aoptions) then begin
   filename.value:= filepath(afilenames[0]);
  end
  else begin
   filename.value:= quotefilename(afilenames);
  end;
  if (colwidth <> nil) and (colwidth^ <> 0) then begin
   listview.cellwidth:= colwidth^;
  end;
  filename.checkvalue;
  showhidden.value:= not (fa_hidden in excludeattrib);
  show(true);
  result:= window.modalresult;
  if (colwidth <> nil) then begin
   colwidth^:= listview.cellwidth;
  end;
  if result = mr_ok then begin
   afilenames:= filenames;
   if filterindex <> nil then begin
    filterindex^:= filter.dropdown.itemindex;
   end;
   if afilter <> nil then begin
    afilter^:= listview.mask;
   end;
   if high(afilenames) = 0 then begin
    filename.dropdown.savehistoryvalue(afilenames[0]);
   end;
   if history <> nil then begin
    history^:= filename.dropdown.valuelist.asarray;
   end;
   if fdo_chdir in aoptions then begin
    msefileutils.setcurrentdir(listview.directory);
   end;
  end;
 end;
end;

function filedialog(var afilenames: filenamearty;
           const aoptions: filedialogoptionsty;
           const acaption: msestring;
           const filterdesc: array of msestring;
           const filtermask: array of msestring;
           const adefaultext: filenamety = '';
           const filterindex: pinteger = nil;
           const filter: pfilenamety = nil;       //nil -> unused
           const colwidth: pinteger = nil;        //nil -> default
           const includeattrib: fileattributesty = [fa_all];
           const excludeattrib: fileattributesty = [fa_hidden];
           const history: pmsestringarty = nil;
           const historymaxcount: integer = defaulthistorymaxcount;
           const imagelist: timagelist = nil;
           const ongetfileicon: getfileiconeventty = nil;
           const oncheckfile: checkfileeventty = nil
           ): modalresultty;
var
 dialog: tfiledialogfo;
 str1: msestring;
begin
 application.lock;
 try
  dialog:= tfiledialogfo.create(nil);
  if acaption = '' then begin
   with stockobjects do begin
    if fdo_save in aoptions then begin
     str1:= captions[sc_save];
    end
    else begin
     str1:= captions[sc_open];
    end;
   end;
  end
  else begin
   str1:= acaption;
  end;
  try
   result:= filedialog1(dialog,afilenames,filterdesc,filtermask,
            filterindex,filter,colwidth,
            includeattrib,excludeattrib,history,historymaxcount,str1,aoptions,
            adefaultext,imagelist,ongetfileicon,oncheckfile);
 
  finally
   dialog.Free;
  end;
 finally
  application.unlock;
 end;
end;

function filedialog(var afilename: filenamety;
           const aoptions: filedialogoptionsty;
           const acaption: msestring;
           const filterdesc: array of msestring;
           const filtermask: array of msestring;
           const adefaultext: filenamety = '';
           const filterindex: pinteger = nil;
           const filter: pfilenamety = nil;       //nil -> unused
           const colwidth: pinteger = nil;        //nil -> default
           const includeattrib: fileattributesty = [fa_all];
           const excludeattrib: fileattributesty = [fa_hidden];
           const history: pmsestringarty = nil;
           const historymaxcount: integer = defaulthistorymaxcount;
           const imagelist: timagelist = nil;
           const ongetfileicon: getfileiconeventty = nil;
           const oncheckfile: checkfileeventty = nil
           ): modalresultty;
var
 ar1: filenamearty;
begin
 setlength(ar1,1);
 ar1[0]:= afilename;
 result:= filedialog(ar1,aoptions,acaption,filterdesc,filtermask,adefaultext,
           filterindex,
           filter,colwidth,includeattrib,excludeattrib,history,historymaxcount,
           imagelist,ongetfileicon,oncheckfile);
 if result = mr_ok then begin
  if (high(ar1) > 0) or (fdo_quotesingle in aoptions) then begin 
   afilename:= quotefilename(ar1);
  end
  else begin
   if high(ar1) = 0 then begin
    afilename:= ar1[0];
   end
   else begin
    afilename:= '';
   end;
  end;
 end;
end;

{ tfilelistview }

constructor tfilelistview.create(aowner: tcomponent);
begin
 fcaseinsensitive:= filesystemiscaseinsensitive;
 fincludeattrib:= [fa_all];
 fexcludeattrib:= [fa_hidden];
 fitemlist:= tfileitemlist.create(self);
 foptionsfile:= defaultfilelistviewoptions;
 ffilelist:= tfiledatalist.create;
 ffilelist.onchange:= {$ifdef FPC}@{$endif}filelistchanged;
 inherited;
 options:= defaultlistviewoptionsfile;
 checkcasesensitive;
end;

destructor tfilelistview.destroy;
begin
 inherited;
 ffilelist.Free;
end;

procedure tfilelistview.checkcasesensitive;
begin
 fcaseinsensitive:= filesystemiscaseinsensitive;
 if flvo_maskcasesensitive in foptionsfile then begin
  fcaseinsensitive:= false;
 end;
 if flvo_maskcaseinsensitive in foptionsfile then begin
  fcaseinsensitive:= true;
 end;
// options:= options; //set casesensitive
end;
{
procedure tfilelistview.setoptions(const Value: listviewoptionsty);
begin
 if fcaseinsensitive then begin
  inherited setoptions(value - [lvo_casesensitive]);
 end
 else begin
  inherited setoptions(value + [lvo_casesensitive]);
 end;
end;
}
procedure tfilelistview.docellevent(var info: celleventinfoty);
var
 index: integer;
begin
 with info do begin
  if iscellclick(info,[ccr_buttonpress]) then begin
   options:= options + [lvo_focusselect];
  end;
  case eventkind of
   cek_enter: begin
    if ffocusmoved then begin
     options:= options + [lvo_focusselect];
    end
    else begin
     ffocusmoved:= true;
    end;
    inherited;
   end;
   cek_select: begin
    index:= celltoindex(cell,false);
    if index >= 0 then begin
     if (flvo_nofileselect in foptionsfile) and
             (ffilelist[index].extinfo1.filetype <> ft_dir) then begin
      accept:= false;
     end
     else begin
      if (flvo_nodirselect in foptionsfile) and
             (ffilelist[index].extinfo1.filetype = ft_dir) then begin
       accept:= false;
      end;
     end;
     inherited;
    end
    else begin
     inherited;
    end;
   end;
   else begin
    inherited;
   end;
  end;
 end;
end;

procedure tfilelistview.filelistchanged(const sender: tobject);
var
 int1: integer;
 po1: pfilelistitem;
 po2: pfileinfoty;
 imlist1: timagelist;
 imnr1: integer;
 bo1: boolean;
begin
 options:= options - [lvo_focusselect];
 ffocusmoved:= false;
 with ffilelist do begin
  self.beginupdate;
  self.fitemlist.beginupdate;
  try
   self.fitemlist.clear;
   self.fitemlist.count:= count;
   po1:= pfilelistitem(self.fitemlist.datapo);
   po2:= pfileinfoty(datapo);
   bo1:= checksubdir;
   for int1:= 0 to count - 1 do begin
    if bo1 and (po2^.extinfo1.filetype = ft_dir) and
      dirhasentries(path+'/'+po2^.name,includeattrib,excludeattrib) then begin
     include(po2^.state,fis_hasentry);
    end;
    updatefileinfo(po1^,po2^,true);
    if assigned(fongetfileicon) then begin
     imlist1:= po1^.imagelist;
     imnr1:= po1^.imagenr;
     fongetfileicon(self,po2^,imlist1,imnr1);
     po1^.imagelist:= imlist1;
     po1^.imagenr:= imnr1;
    end;
    inc(po1);
    inc(po2);
   end;
  finally
   self.fitemlist.endupdate;
   self.endupdate;
  end;
 end;
end;

function tfilelistview.getselectednames: msestringarty;
var
 int1,int2: integer;
begin
 int2:=0;
 result:= nil;
 for int1:= 0 to ffilelist.count - 1 do begin
  if fitemlist[int1].selected then begin
   additem(result,ffilelist[int1].name,int2);
  end;
 end;
 setlength(result,int2);
end;

procedure tfilelistview.setselectednames(const avalue: filenamearty);
var
 int1: integer;
 item1: tlistitem;
 po1: plistitematy;
// cell1: gridcoordty;
begin
 po1:= fitemlist.datapo;
 fitemlist.beginupdate;
 try
  for int1:= 0 to fitemlist.count - 1 do begin
   po1^[int1].selected:= false;
  end;
  for int1:= 0 to high(avalue) do begin
   item1:= finditembycaption(avalue[int1]);
   if item1 <> nil then begin
    item1.selected:= true;
   end;
  end;
 finally
  fitemlist.endupdate;
 end;
{
 for int1:= 0 to high(avalue) do begin
  if findcellbycaption(avalue[int1],cell1) then begin
   fdatacols.selected[cell1]:= true;
  end;
 end;
 }
// focuscell(cell1);
end;

procedure tfilelistview.setfilelist(const Value: tfiledatalist);
begin
 if ffilelist <> value then begin
  ffilelist.Assign(value);
 end;
end;

procedure tfilelistview.readlist;
var
 int1: integer;
 po1: pfileinfoty;
 level1: fileinfolevelty;
begin
 beginupdate;
 try
  defocuscell;
  fdatacols.clearselection;
  ffilelist.clear;
  ffilecount:= 0;
  level1:= fil_type;
  if assigned(foncheckfile) then begin
   level1:= fil_ext2;
  end;
  if fmaskar = nil then begin
   ffilelist.adddirectory(fdirectory,level1,fmaskar,
                          fincludeattrib,fexcludeattrib,foptionsdir,
                          foncheckfile);
   if ffilelist.count > 0 then begin
    po1:= ffilelist.itempo(0);
    for int1:= 0 to ffilelist.count - 1 do begin
     if not (fa_dir in po1^.extinfo1.attributes) then begin
      inc(ffilecount);
     end;
     inc(po1);
    end;
   end;
  end
  else begin
   if (fincludeattrib = [fa_all]) or not(fa_dir in fincludeattrib) then begin
    ffilelist.adddirectory(fdirectory,level1,nil,[fa_dir],
               fexcludeattrib*[fa_hidden],foptionsdir,foncheckfile);
    int1:= ffilelist.count;
    ffilelist.adddirectory(fdirectory,level1,fmaskar,fincludeattrib,
                   fexcludeattrib+[fa_dir],foptionsdir,foncheckfile);
    ffilecount:= ffilelist.count - int1;
   end
   else begin
    ffilelist.adddirectory(fdirectory,level1,fmaskar,
                       fincludeattrib,fexcludeattrib,foptionsdir,foncheckfile);
    ffilecount:= ffilelist.count;
   end;
  end;
 finally
  endupdate;
 end;
 if assigned(fonlistread) then begin
  fonlistread(self);
 end;
end;

procedure tfilelistview.updir;
var
 str1: msestring;
 int1: integer;
begin
 str1:= removelastdir(fdirectory,fdirectory);
 if str1 <> '' then begin
  readlist;
  int1:= ffilelist.indexof(str1);
  if int1 >= 0 then begin
   focuscell(indextocell(int1),fca_focusin);
  end;
 end;
end;

procedure tfilelistview.setdirectory(const Value: msestring);
begin
 fdirectory:= filepath(value,fk_dir);
end;

function tfilelistview.getpath: msestring;
begin
 if fmaskar = nil then begin
  result:= filepath(fdirectory);
 end
 else begin
  result:= filepath(fdirectory,fmaskar[0]);
 end;
end;

procedure tfilelistview.setpath(const Value: filenamety);
var
 str1: msestring;
begin
 splitfilepath(value,fdirectory,str1);
 mask:= str1;
 readlist;
end;

procedure tfilelistview.setmask(const value: filenamety);
begin
 unquotefilename(value,fmaskar);
end;

function tfilelistview.getmask: filenamety;
begin
 result:= quotefilename(fmaskar);
end;

function tfilelistview.filecount: integer;
begin
 if ffilelist.count < ffilecount then begin
  ffilecount:= 0;
 end;
 result:= ffilecount;
end;

function tfilelistview.getchecksubdir: boolean;
begin
 result:= flvo_checksubdir in foptionsfile;
end;

procedure tfilelistview.setchecksubdir(const avalue: boolean);
begin
 if avalue then begin
  include(foptionsfile,flvo_checksubdir);
 end
 else begin
  exclude(foptionsfile,flvo_checksubdir);
 end;
end;

procedure tfilelistview.setoptionsfile(const avalue: filelistviewoptionsty);
const
 mask1: filelistviewoptionsty = [flvo_maskcasesensitive,flvo_maskcaseinsensitive];
begin
 if avalue <> foptionsfile then begin
  foptionsfile:= filelistviewoptionsty(
                  setsinglebit({$ifdef FPC}longword{$else}byte{$endif}(avalue),
                               {$ifdef FPC}longword{$else}byte{$endif}(foptionsfile),
                               {$ifdef FPC}longword{$else}byte{$endif}(mask1)));
  foptionsdir:= dirstreamoptionsty(foptionsfile) * 
                             [dso_casesensitive,dso_caseinsensitive];
  checkcasesensitive;
 end;
end;

{ tfilelistitem }

constructor tfilelistitem.create(const aowner: tcustomitemlist);
begin
 inherited;
end;

{ tfileitemlist }

procedure tfileitemlist.createitem(out item: tlistitem);
begin
 item:= tfilelistitem.create(self);
end;

 { tfiledialogfo }

procedure Tfiledialogfo.createdironexecute(const sender: TObject);
var
 mstr1: msestring;
begin
 mstr1:= '';
 with stockobjects do begin
  if stringenter(mstr1,captions[sc_name1],
               captions[sc_create_new_directory]) = mr_ok then begin
   mstr1:= filepath(listview.directory,mstr1,fk_file);
   msefileutils.createdir(mstr1);
   changedir(mstr1);
   filename.setfocus;
  end;
 end;
end;

procedure tfiledialogfo.listviewselectionchanged(const sender: tcustomlistview);
var
 ar1: msestringarty;
begin
 ar1:= nil; //compiler warning
 if not (fdo_directory in dialogoptions) then begin
  ar1:= listview.selectednames;
  if length(ar1) > 0 then begin
   if length(ar1) > 1 then begin
    filename.value:= quotefilename(ar1);
   end
   else begin
    filename.value:= ar1[0];
   end;
  end
  else begin
//   filename.value:= ''; //dir chanaged
  end;
 end;
end;

procedure tfiledialogfo.changedir(const adir: filenamety);
begin
 with listview do begin
  directory:= filepath(adir);
  readlist;
  if filelist.count > 0 then begin
   focuscell(makegridcoord(0,0));
  end;
 end;
end;

procedure tfiledialogfo.listviewitemevent(const sender: tcustomlistview;
                const index: Integer; var info: celleventinfoty);
begin
 with tfilelistview(sender) do begin
  if iscellclick(info) then begin
   if filelist.isdir(index) then begin
    changedir(filepath(directory+filelist[index].name));
   end
   else begin
    if info.eventkind = cek_keydown then begin
     system.exclude(info.keyeventinfopo^.eventstate,es_processed);
     //do not eat key_return
    end;
    if iscellclick(info,[ccr_dblclick,ccr_nokeyreturn]) and
              (length(fdatacols.selectedcells) = 1) then begin
     okonexecute(nil);
    end;
   end;
  end;
 end;
end;

procedure tfiledialogfo.listviewonkeydown(const sender: twidget; var info: keyeventinfoty);
begin
 with info do begin
  if (key = key_pageup) and (shiftstate = [ss_ctrl]) then begin
   listview.updir;
   include(info.eventstate,es_processed);
  end;
 end;
end;

procedure Tfiledialogfo.upaction(const sender: TObject);
begin
 listview.updir;
end;

procedure tfiledialogfo.readlist;
begin
 try
  with listview do begin
   readlist;
  end;
 except
  on ex: esys do begin
   if esys(ex).error = sye_dirstream then begin
    listview.directory:= '';
    with stockobjects do begin
     showerror(captions[sc_can_not_read_directory]+ ' ' + esys(ex).text,
               captions[sc_error]);
//     showerror('Can not read directory '''+ esys(ex).text+'''.','Error');
    end;
    try
     listview.readlist;
    except
     application.handleexception(self);
    end;
   end
   else begin
    application.handleexception(self);
   end;
  end;
  else begin
   application.handleexception(self);
  end;
 end;
end;

procedure Tfiledialogfo.filenamesetvalue(const sender: TObject; 
                                var avalue: msestring;  var accept: Boolean);
var
 str1,str2,str3: filenamety;
// ar1: msestringarty;
 bo1: boolean;
begin
 avalue:= trim(avalue);
 unquotefilename(avalue,fselectednames);
 if (fdo_single in dialogoptions) and (high(fselectednames) > 0) then begin
  with stockobjects do begin
   showmessage(captions[sc_single_item_only]+'.',captions[sc_error]);
  end;
  accept:= false;
  exit;  
 end;
 bo1:= false;
 if high(fselectednames) > 0 then begin
  str1:= extractrootpath(fselectednames);
  if str1 <> '' then begin
   bo1:= true;
   listview.directory:= str1;
   avalue:= quotefilename(fselectednames);
  end;
 end
 else begin
  str3:= filepath(listview.directory,avalue);
  splitfilepath(str3,str1,str2);
  listview.directory:= str1;
  if hasmaskchars(str2) then begin
   filter.value:= str2;
   listview.mask:= str2;
   str2:= '';
  end
  else begin
   if searchfile(str3,true) <> '' then begin
    listview.directory:= str3;
    str2:= '';
   end;
  end;
  avalue:= str2;
  if str2 = '' then begin
   fselectednames:= nil;
  end
  else begin
   setlength(fselectednames,1);
   fselectednames[0]:= str2;
  end;
  bo1:= true;
 end;
 if bo1 then begin
  readlist;
  if fdo_directory in dialogoptions then begin
   avalue:= listview.directory;
  end;
 end;
 listview.selectednames:= fselectednames;
end;

procedure tfiledialogfo.filepathentered(const sender: tobject);
begin
 readlist;
end;

procedure tfiledialogfo.dironsetvalue(const sender: TObject;
  var avalue: mseString; var accept: Boolean);
begin
 listview.directory:= avalue;
end;

procedure tfiledialogfo.listviewonlistread(const sender: tobject);
begin
 with listview do begin
  dir.value:= directory;
//  if fa_dir in finclude then begin
  if fdo_directory in self.dialogoptions then begin
   filename.value:= directory;
  end;
 end;
end;

procedure tfiledialogfo.updatefiltertext;
begin
 with filter,dropdown do begin
  if itemindex >= 0 then begin
   value:= cols[0][itemindex];
   listview.mask:= cols[1][itemindex];
  end;
 end;
end;

procedure tfiledialogfo.filteronafterclosedropdown(const sender: tobject);
begin
 updatefiltertext;
 filter.initfocus;
end;

procedure tfiledialogfo.filteronsetvalue(const sender: tobject;
  var avalue: msestring; var accept: boolean);
begin
 listview.mask:= avalue;
end;

procedure tfiledialogfo.okonexecute(const sender: tobject);
var
 bo1: boolean;
 int1: integer;
 str1: filenamety;
begin
 if filename.checkvalue then begin
  if (filename.value <> '') or (fdo_acceptempty in dialogoptions) then begin
   if fdo_directory in dialogoptions then begin
    str1:= quotefilename(listview.directory);
   end
   else begin
    str1:= quotefilename(listview.directory,filename.value);
   end;
   unquotefilename(str1,filenames);
   if (defaultext <> '') then begin
    for int1:= 0 to high(filenames) do begin
     if not hasfileext(filenames[int1]) then begin
      filenames[int1]:= filenames[int1] + '.'+defaultext;
     end;
    end;
   end;
   if (fdo_checkexist in dialogoptions) and 
       not ((filename.value = '') and (fdo_acceptempty in dialogoptions)) then begin
    if fdo_directory in dialogoptions then begin
     bo1:= finddir(filenames[0]);
    end
    else begin
     bo1:= findfile(filenames[0]);
    end;
    if fdo_save in dialogoptions then begin
     if bo1 then begin
      with stockobjects do begin
       if not askok(captions[sc_file]+' "'+filenames[0]+
            '" '+ captions[sc_exists_overwrite],
            captions[sc_warningupper]) then begin
//      if not askok('File "'+filenames[0]+
//            '" exists, do you want to overwrite?','WARNING') then begin
        filename.setfocus;
        exit;
       end;
      end;
     end;
    end
    else begin
     if not bo1 then begin
      with stockobjects do begin
       showerror(captions[sc_file]+' "'+filenames[0]+'" '+
                                        captions[sc_does_not_exist]+'.',
                  captions[sc_errorupper]);
      end;
//      showerror('File "'+filenames[0]+'" does not exist.');
      filename.setfocus;
      exit;
     end;
    end;
   end;
   window.modalresult:= mr_ok;
  end
  else begin
   filename.setfocus;
  end;
 end;
end;

procedure tfiledialogfo.foonchildscaled(const sender: TObject);
begin
// syncmaxautosize([up,createdir]);
 placeyorder(2,[2],[dir,listview,filename,filter],2);
 aligny(wam_center,[dir,home,up,createdir]);
 aligny(wam_center,[filename,showhidden]);
 aligny(wam_center,[filter,ok,cancel]);
 syncpaintwidth([filename,filter],namecont.bounds_cx);
 listview.synctofontheight;
end;

procedure tfiledialogfo.showhiddenonsetvalue(const sender: TObject; 
         var avalue: Boolean; var accept: Boolean);
begin
 dir.showhiddenfiles:= avalue;
 if avalue then begin
  listview.excludeattrib:= listview.excludeattrib - [fa_hidden];
 end
 else begin
  listview.excludeattrib:= listview.excludeattrib + [fa_hidden];
 end;
 listview.readlist;
end;

procedure tfiledialogfo.formoncreate(const sender: TObject);
begin
 with stockobjects do begin
  dir.frame.caption:= captions[sc_dir];
  home.caption:= captions[sc_home];
  up.caption:= captions[sc_up];
  createdir.caption:= captions[sc_new_dir];
  filename.frame.caption:= captions[sc_name];
  filter.frame.caption:= captions[sc_filter];
  showhidden.frame.caption:= captions[sc_show_hidden_files];
  ok.caption:= modalresulttext[mr_ok];
  cancel.caption:= modalresulttext[mr_cancel];  
 end;
end;

procedure tfiledialogfo.dirshowhint(const sender: TObject;
               var info: hintinfoty);
begin
 if dir.editor.textclipped then begin
  info.caption:= dir.value;
 end;
end;

procedure tfiledialogfo.copytolip(const sender: TObject; var avalue: msestring);
begin
 tosysfilepath1(avalue);
end;

procedure tfiledialogfo.pastefromclip(const sender: TObject;
               var avalue: msestring);
begin
 tomsefilepath1(avalue);
end;

procedure tfiledialogfo.homeaction(const sender: TObject);
begin
 dir.value:= sys_getuserhomedir;
 listview.directory:= dir.value;
 readlist;
end;

{ tfiledialogcontroller }

constructor tfiledialogcontroller.create(const aowner: tmsecomponent = nil;
                                       const onchange: proceventty = nil);
begin
 foptions:= defaultfiledialogoptions;
 fhistorymaxcount:= defaulthistorymaxcount;
 fowner:= aowner;
 ffilterlist:= tdoublemsestringdatalist.create;
 finclude:= [fa_all];
 fexclude:= [fa_hidden];
 fonchange:= onchange;
 inherited create;
end;

destructor tfiledialogcontroller.destroy;
begin
 inherited;
 ffilterlist.Free;
end;

procedure tfiledialogcontroller.readstatvalue(const reader: tstatreader);
begin
 ffilenames:= reader.readarray('filenames',ffilenames);
 if fdo_params in foptions then begin
  fparams:= reader.readmsestring('params',fparams);
 end;
end;

procedure tfiledialogcontroller.readstatstate(const reader: tstatreader);
begin
 if fdo_savelastdir in foptions then begin
  flastdir:= reader.readmsestring('lastdir',flastdir);
 end;
 if fhistorymaxcount > 0 then begin
  fhistory:= reader.readarray('filehistory',fhistory);
 end;
 ffilterindex:= reader.readinteger('filefilterindex',ffilterindex);
 ffilter:= reader.readstring('filefilter',ffilter);
 fwindowrect.x:= reader.readinteger('x',fwindowrect.x);
 fwindowrect.y:= reader.readinteger('y',fwindowrect.y);
 fwindowrect.cx:= reader.readinteger('cx',fwindowrect.cx);
 fwindowrect.cy:= reader.readinteger('cy',fwindowrect.cy);
 fcolwidth:= reader.readinteger('filecolwidth',fcolwidth);
 if fdo_chdir in foptions then begin
  try
   setcurrentdir(flastdir);
  except
  end;
 end;
end;

procedure tfiledialogcontroller.readstatoptions(const reader: tstatreader);
begin
end;

procedure tfiledialogcontroller.writestatvalue(const writer: tstatwriter);
begin
 writer.writearray('filenames',ffilenames);
 if fdo_params in foptions then begin
  writer.writemsestring('params',fparams);
 end;
end;

procedure tfiledialogcontroller.writestatstate(const writer: tstatwriter);
begin
 if fdo_savelastdir in foptions then begin
  writer.writemsestring('lastdir',flastdir);
 end;
 if fhistorymaxcount > 0 then begin
  writer.writearray('filehistory',fhistory);
 end;
 writer.writeinteger('filefilterindex',ffilterindex);
 writer.writestring('filefilter',ffilter);
 writer.writeinteger('filecolwidth',fcolwidth);
 writer.writeinteger('x',fwindowrect.x);
 writer.writeinteger('y',fwindowrect.y);
 writer.writeinteger('cx',fwindowrect.cx);
 writer.writeinteger('cy',fwindowrect.cy);
end;

procedure tfiledialogcontroller.writestatoptions(const writer: tstatwriter);
begin
 //dummy
end;

procedure tfiledialogcontroller.componentevent(const event: tcomponentevent);
begin
 if (fdo_link in foptions) and (event.sender <> self) and 
                (event.sender is tfiledialogcontroller) then begin
  with tfiledialogcontroller(event.sender) do begin
   if fgroup = self.fgroup then begin
    self.flastdir:= flastdir;
   end;
  end;
 end;
end;

procedure tfiledialogcontroller.checklink;
begin
 if (fdo_link in foptions) and (fowner <> nil) then begin
  fowner.sendrootcomponentevent(tcomponentevent.create(self),true);
 end;
end;

function tfiledialogcontroller.execute(dialogkind: filedialogkindty;
                         const acaption: msestring;
                         aoptions: filedialogoptionsty): modalresultty;
var
 po1: pmsestringarty;
 fo: tfiledialogfo;
 ara,arb: msestringarty;
begin
 ara:= nil; //compiler warning
 arb:= nil; //compiler warning
 result:= mr_ok;
 if assigned(fonbeforeexecute) then begin
  fonbeforeexecute(self,dialogkind,result);
  if result <> mr_ok then begin
   exit;
  end;
 end;
 if fhistorymaxcount > 0 then begin
  po1:= @fhistory;
 end
 else begin
  po1:= nil;
 end;
 fo:= tfiledialogfo.create(nil);
 try
 {$ifdef FPC} {$checkpointer off} {$endif}    //todo!!!!! bug 3348
  ara:= ffilterlist.asarraya;
  arb:= ffilterlist.asarrayb;
  if dialogkind <> fdk_none then begin
   if dialogkind in [fdk_save,fdk_new] then begin
    system.include(aoptions,fdo_save);
   end
   else begin
    system.exclude(aoptions,fdo_save);
   end;
  end;
  if fdo_relative in foptions then begin
   fo.listview.directory:= getcurrentdir;
  end
  else begin
   fo.listview.directory:= flastdir;
  end;
  if (fwindowrect.cx > 0) and (fwindowrect.cy > 0) then begin
   fo.widgetrect:= clipinrect(fwindowrect,application.screenrect(fo.window));
  end;
  result:= filedialog1(fo,ffilenames,ara,arb,
        @ffilterindex,@ffilter,@fcolwidth,finclude,
            fexclude,po1,fhistorymaxcount,acaption,aoptions,fdefaultext,
            fimagelist,fongetfileicon,foncheckfile);
  fwindowrect:= fo.widgetrect;
  if assigned(fonafterexecute) then begin
   fonafterexecute(self,result);
  end;
 {$ifdef FPC} {$checkpointer default} {$endif}
  if result = mr_ok then begin
   if fdo_relative in foptions then begin
    flastdir:= getcurrentdir;
   end
   else begin
    flastdir:= fo.dir.value;
   end;
  end;
 finally
  fo.Free;
 end;
end;

function tfiledialogcontroller.execute(const dialogkind: filedialogkindty;
                         const acaption: msestring): modalresultty;
begin
 result:= execute(dialogkind,acaption,foptions);
end;

function tfiledialogcontroller.actcaption(
                            const dialogkind: filedialogkindty): msestring;
begin
 case dialogkind of
  fdk_save: begin
   result:= fcaptionsave;
  end;
  fdk_new: begin
   result:= fcaptionnew;
  end;
  else begin
   result:= fcaptionopen;
  end;
 end;
end;

function tfiledialogcontroller.execute(const dialogkind: filedialogkindty;
                         const aoptions: filedialogoptionsty): modalresultty;
begin
 result:= execute(dialogkind,actcaption(dialogkind),aoptions);
end;

function tfiledialogcontroller.execute(
                dialogkind: filedialogkindty = fdk_none): modalresultty;
begin
 if dialogkind = fdk_none then begin
  if fdo_save in foptions then begin
   dialogkind:= fdk_save;
  end
  else begin
   dialogkind:= fdk_open;
  end;
 end; 
 result:= execute(dialogkind,actcaption(dialogkind));
end;

function tfiledialogcontroller.execute(var avalue: filenamety;
                   dialogkind: filedialogkindty = fdk_none): boolean;
begin
 if dialogkind = fdk_none then begin
  if fdo_save in foptions then begin
   dialogkind:= fdk_save;
  end
  else begin
   dialogkind:= fdk_open;
  end;
 end; 
 result:= execute(avalue,dialogkind,actcaption(dialogkind));
end;

function tfiledialogcontroller.execute(var avalue: filenamety;
                  const dialogkind: filedialogkindty;
                  const acaption: msestring): boolean;
var
 wstr1: filenamety;
begin
 wstr1:= filename;
 if assigned(fongetfilename) then begin
  result:= true;
  fongetfilename(self,avalue,result);
  if not result then begin
   exit;
  end;
 end;
 filename:= avalue;
 result:= execute(dialogkind,acaption) = mr_ok;
 if result then begin
  avalue:= filename;
  checklink;
 end
 else begin
  filename:= wstr1;
 end;
end;

function tfiledialogcontroller.getfilename: filenamety;
begin
 if (high(ffilenames) > 0) or (fdo_quotesingle in foptions) or
  (fdo_params in foptions) and (high(ffilenames) = 0) and 
    (findchar(pmsechar(ffilenames[0]),' ') > 0) then begin
  result:= quotefilename(ffilenames);
 end
 else begin
  if high(ffilenames) = 0 then begin
   result:= ffilenames[0];
  end
  else begin
   result:= '';
  end;
 end;
 if (fdo_params in foptions) and (fparams <> '') then begin
  if fdo_sysfilename in foptions then begin
   tosysfilepath1(result);
  end;
  result:= result + ' '+fparams;
 end
 else begin
  if fdo_sysfilename in foptions then begin
   tosysfilepath1(result);
  end;
 end;
end;

const
 quotechar = msechar('"');
 
procedure tfiledialogcontroller.setfilename(const avalue: filenamety);
var
 int1: integer;
 akind: filekindty;
begin
 unquotefilename(avalue,ffilenames);
 if fdo_params in foptions then begin
  fparams:= '';
  if high(ffilenames) >= 0 then begin
   if avalue[1] = quotechar then begin
    fparams:= copy(avalue,length(ffilenames[0])+3,bigint);
    if (fparams <> '') and (fparams[1] = ' ') then begin
     delete(fparams,1,1);
    end;
    setlength(ffilenames,1);
   end
   else begin
    int1:= findchar(ffilenames[0],' ');
    if int1 > 0 then begin
     fparams:= copy(ffilenames[0],int1+1,bigint);
     setlength(ffilenames[0],int1-1);
    end;
   end;
  end;
 end;
 if fdo_directory in foptions then begin
  akind:= fk_dir;
 end
 else begin
  if fdo_file in foptions then begin
   akind:= fk_file;
  end
  else begin
   akind:= fk_default;
  end;
 end;
 if fdo_relative in foptions then begin
  flastdir:= getcurrentdir;
  for int1:= 0 to high(ffilenames) do begin
   ffilenames[int1]:= relativepath(filenames[int1],'',akind);
  end;
 end
 else begin
  if high(ffilenames) = 0 then begin
   if akind = fk_dir then begin
    flastdir:= filepath(avalue,fk_dir);
   end
   else begin
    flastdir:= filedir(avalue);
   end;
  end;
  for int1:= 0 to high(ffilenames) do begin
   ffilenames[int1]:= filepath(filenames[int1],akind,
          not (fdo_absolute in foptions));
  end;
 end;
end;

procedure tfiledialogcontroller.setfilterlist(
  const Value: tdoublemsestringdatalist);
begin
 ffilterlist.assign(Value);
end;

procedure tfiledialogcontroller.sethistorymaxcount(const Value: integer);
begin
 fhistorymaxcount := Value;
 if length(fhistory) > fhistorymaxcount then begin
  setlength(fhistory,fhistorymaxcount);
 end;
end;

procedure tfiledialogcontroller.dochange;
begin
 if assigned(fonchange) then begin
  fonchange;
 end;
end;

procedure tfiledialogcontroller.setdefaultext(const avalue: filenamety);
begin
 if fdefaultext <> avalue then begin
  fdefaultext := avalue;
  dochange;
 end;
end;

procedure tfiledialogcontroller.setoptions(Value: filedialogoptionsty);
const
 mask1: filedialogoptionsty = [fdo_absolute,fdo_relative];
 mask2: filedialogoptionsty = [fdo_directory,fdo_file];
 mask3: filedialogoptionsty = [fdo_filtercasesensitive,fdo_filtercaseinsensitive];
begin
 {$ifdef FPC}longword{$else}longword{$endif}(value):=
      setsinglebit({$ifdef FPC}longword{$else}longword{$endif}(value),
      {$ifdef FPC}longword{$else}longword{$endif}(foptions),
      {$ifdef FPC}longword{$else}longword{$endif}(mask1));
 {$ifdef FPC}longword{$else}longword{$endif}(value):=
      setsinglebit({$ifdef FPC}longword{$else}longword{$endif}(value),
      {$ifdef FPC}longword{$else}longword{$endif}(foptions),
      {$ifdef FPC}longword{$else}longword{$endif}(mask2));
 {$ifdef FPC}longword{$else}longword{$endif}(value):=
      setsinglebit({$ifdef FPC}longword{$else}longword{$endif}(value),
      {$ifdef FPC}longword{$else}longword{$endif}(foptions),
      {$ifdef FPC}longword{$else}longword{$endif}(mask3));
 if foptions <> value then begin
  foptions:= Value;
  if not (fdo_params in foptions) then begin
   fparams:= '';
  end;
  dochange;
 end;
end;

procedure tfiledialogcontroller.clear;
begin
 ffilenames:= nil;
 flastdir:= '';
 fhistory:= nil;
end;

procedure tfiledialogcontroller.setlastdir(const avalue: filenamety);
begin
 flastdir:= avalue;
 checklink;
end;

procedure tfiledialogcontroller.setimagelist(const avalue: timagelist);
begin
 setlinkedvar(avalue,tmsecomponent(fimagelist));
end;

function tfiledialogcontroller.getsyscommandline: filenamety;
var
 bo1: boolean;
begin
 bo1:= fdo_sysfilename in foptions;
 system.include(foptions,fdo_sysfilename);
 result:= getfilename;
 if not bo1 then begin
  system.exclude(foptions,fdo_sysfilename);
 end;
end;

{ tfiledialog }

constructor tfiledialog.create(aowner: tcomponent);
begin
 foptionsedit:= defaultfiledialogoptionsedit;
 fcontroller:= tfiledialogcontroller.create(nil);
 inherited;
end;

destructor tfiledialog.destroy;
begin
 inherited;
 fcontroller.free;
end;

function tfiledialog.execute: modalresultty;
begin
 result:= fcontroller.execute(fdialogkind);
end;

function tfiledialog.execute(const akind: filedialogkindty): modalresultty;
begin
 result:= fcontroller.execute(akind);
end;

function tfiledialog.execute(const akind: filedialogkindty;
                   const aoptions: filedialogoptionsty): modalresultty;
begin
 result:= fcontroller.execute(akind,aoptions);
end;

procedure tfiledialog.setcontroller(const value: tfiledialogcontroller);
begin
 fcontroller.assign(value);
end;

procedure tfiledialog.dostatread(const reader: tstatreader);
begin
 if canstatvalue(foptionsedit,reader) then begin
  fcontroller.readstatvalue(reader);
 end;
 if canstatstate(foptionsedit,reader) then begin
  fcontroller.readstatstate(reader);
 end;
 if canstatoptions(foptionsedit,reader) then begin
  fcontroller.readstatoptions(reader);
 end;
end;

procedure tfiledialog.dostatwrite(const writer: tstatwriter);
begin
 if canstatvalue(foptionsedit,writer) then begin
  fcontroller.writestatvalue(writer);
 end;
 if canstatstate(foptionsedit,writer) then begin
  fcontroller.writestatstate(writer);
 end;
 if canstatoptions(foptionsedit,writer) then begin
  fcontroller.writestatoptions(writer);
 end;
end;

function tfiledialog.getstatvarname: msestring;
begin
 result:= fstatvarname;
end;

procedure tfiledialog.setstatfile(const Value: tstatfile);
begin
 setstatfilevar(istatfile(self),value,fstatfile);
end;

procedure tfiledialog.statreading;
begin
 //dummy
end;

procedure tfiledialog.statread;
begin
 //dummy
end;

procedure tfiledialog.componentevent(const event: tcomponentevent);
begin
 fcontroller.componentevent(event);
 inherited;
end;

{ tfilenameeditcontroller }

constructor tfilenameeditcontroller.create(const aowner: tcustomfilenameedit);
begin
 inherited create(aowner);
end;

function tfilenameeditcontroller.execute(var avalue: msestring): boolean;
begin
 with tcustomfilenameedit(fowner) do begin
  result:= fcontroller.execute(avalue);
 end;
end;

{ tcustomfilenameedit }

constructor tcustomfilenameedit.create(aowner: tcomponent);
begin
 fcontroller:= tfiledialogcontroller.create(self,{$ifdef FPC}@{$endif}formatchanged);
 inherited;
end;

destructor tcustomfilenameedit.destroy;
begin
 inherited;
 fcontroller.Free;
end;
{
function tcustomfilenameedit.execute(var avalue: msestring): boolean;
begin
 result:= fcontroller.execute(avalue);
end;
}
procedure tcustomfilenameedit.setcontroller(const avalue: tfiledialogcontroller);
begin
 fcontroller.assign(avalue);
end;

procedure tcustomfilenameedit.readstatvalue(const reader: tstatreader);
begin
 if fgridintf <> nil then begin
  inherited;
 end
 else begin
  fcontroller.readstatvalue(reader);
  value:= fcontroller.filename;
 end;
end;

procedure tcustomfilenameedit.readstatstate(const reader: tstatreader);
begin
 fcontroller.readstatstate(reader);
end;

procedure tcustomfilenameedit.readstatoptions(const reader: tstatreader);
begin
 fcontroller.readstatoptions(reader);
end;

procedure tcustomfilenameedit.writestatvalue(const writer: tstatwriter);
begin
 if fgridintf <> nil then begin
  inherited;
 end
 else begin
  fcontroller.writestatvalue(writer);
 end;
end;

procedure tcustomfilenameedit.writestatstate(const writer: tstatwriter);
begin
 fcontroller.writestatstate(writer);
end;

procedure tcustomfilenameedit.writestatoptions(const writer: tstatwriter);
begin
 fcontroller.writestatoptions(writer);
end;

function tcustomfilenameedit.getvaluetext: msestring;
begin
// result:= filepath(fcontroller.filename);
 result:= fcontroller.filename;
end;

procedure tcustomfilenameedit.texttovalue(var accept: boolean;
                                                    const quiet: boolean);
var
 ar1: filenamearty;
 mstr1: filenamety;
 int1: integer;
begin
 if (fcontroller.defaultext <> '') then begin
  unquotefilename(text,ar1);
  for int1:= 0 to high(ar1) do begin
   if not hasfileext(ar1[int1]) then begin
    ar1[int1]:= ar1[int1] + '.'+controller.defaultext;
   end;
  end;
  mstr1:= quotefilename(ar1);
 end
 else begin
  mstr1:= text;
 end;
 fcontroller.filename:= mstr1;
 inherited;
end;

procedure tcustomfilenameedit.updatedisptext(var avalue: msestring);
begin
 with fcontroller do begin
  if fdo_dispname in foptions then begin
   avalue:= msefileutils.filename(avalue);
  end;
  if fdo_dispnoext in foptions then begin
   avalue:= removefileext(avalue);
  end;
 end;
end;

procedure tcustomfilenameedit.valuechanged;
begin
 fcontroller.filename:= value;
 inherited;
end;

procedure tcustomfilenameedit.componentevent(const event: tcomponentevent);
begin
 fcontroller.componentevent(event);
 inherited;
end;

procedure tcustomfilenameedit.updatecopytoclipboard(var atext: msestring);
begin
 tosysfilepath1(atext);
 inherited;
end;

procedure tcustomfilenameedit.updatepastefromclipboard(var atext: msestring);
begin
 tomsefilepath1(atext);
 inherited;
end;

function tcustomfilenameedit.createdialogcontroller: tstringdialogcontroller;
begin
 result:= tfilenameeditcontroller.create(self);
end;

{ tdirdropdownedit }

procedure tdirdropdownedit.createdropdownwidget(const atext: msestring;
                    out awidget: twidget);
begin
 awidget:= tdirtreefo.create(nil);
 with tdirtreefo(awidget) do begin
  showhiddenfiles:= ddeo_showhiddenfiles in foptions;
  checksubdir:= ddeo_checksubdir in foptions;
  path:= atext;
  onpathchanged:= {$ifdef FPC}@{$endif}pathchanged;
  text:= path;
 end;
 feditor.sellength:= 0;
end;

procedure tdirdropdownedit.doafterclosedropdown;
begin
 text:= value;
 feditor.selectall;
 inherited;
end;

function tdirdropdownedit.getdropdowntext(const awidget: twidget): msestring;
begin
 result:= tdirtreefo(awidget).path;
end;

procedure tdirdropdownedit.pathchanged(const sender: tobject);
begin
 text:= tdirtreefo(sender).path;
end;

function tdirdropdownedit.getshowhiddenfiles: boolean;
begin
 result:= ddeo_showhiddenfiles in foptions;
end;

procedure tdirdropdownedit.setshowhiddenfiles(const avalue: boolean);
begin
 if avalue then begin
  include(foptions,ddeo_showhiddenfiles)
 end
 else begin
  exclude(foptions,ddeo_showhiddenfiles)
 end;
end;

function tdirdropdownedit.getchecksubdir: boolean;
begin
 result:= ddeo_checksubdir in foptions;
end;

procedure tdirdropdownedit.setchecksubdir(const avalue: boolean);
begin
 if avalue then begin
  include(foptions,ddeo_checksubdir)
 end
 else begin
  exclude(foptions,ddeo_checksubdir)
 end;
end;

procedure tdirdropdownedit.updatecopytoclipboard(var atext: msestring);
begin
 tosysfilepath1(atext);
 inherited;
end;

procedure tdirdropdownedit.updatepastefromclipboard(var atext: msestring);
begin
 tomsefilepath1(atext);
 inherited;
end;

end.

{ MSEgui Copyright (c) 1999-2008 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}

unit msedbedit;

{$ifdef FPC}{$mode objfpc}{$h+}{$interfaces corba}{$endif}

interface
uses
 db,classes,mseguiglob,mseclasses,msegui,msetoolbar,mseeditglob,mseglob,
 msewidgetgrid,msedatalist,msetypes,msegrids,msegraphics,mseevent,msekeyboard,
 msegraphedits,msestrings,{sqldb,}msegraphutils,mselist,msedropdownlist,
 msescrollbar,msedataedits,msewidgets,msearrayprops,msedb,mselookupbuffer,
 msedialog,mseinplaceedit,msemenus,mseedit,msestat;

type

 dbnavigbuttonty = (dbnb_first,dbnb_prior,dbnb_next,dbnb_last,dbnb_insert,
           dbnb_delete,dbnb_edit,dbnb_post,dbnb_cancel,dbnb_refresh,
           dbnb_filter,dbnb_filtermin,dbnb_filtermax,dbnb_filteronoff,dbnb_find);
 dbnavigbuttonsty = set of dbnavigbuttonty;
 
const
 defaultvisibledbnavigbuttons = 
          [dbnb_first,dbnb_prior,dbnb_next,dbnb_last,dbnb_insert,
           dbnb_delete,dbnb_edit,dbnb_post,dbnb_cancel,dbnb_refresh];
 filterdbnavigbuttons = [dbnb_filter,dbnb_filtermin,dbnb_filtermax,dbnb_find];
 defaultdbnavigatorheight = 24;
 defaultdbnavigatorwidth = (ord(dbnb_refresh)+1)*defaultdbnavigatorheight;
 
type

 dbnavigatoroptionty = (dno_confirmdelete,dno_append,dno_shortcuthint);
 dbnavigatoroptionsty = set of dbnavigatoroptionty;

const
 defaultdbnavigatoroptions = [dno_confirmdelete,dno_append];
 designdbnavigbuttons = [dbnb_first,dbnb_prior,dbnb_next,dbnb_last];
 
type  
 idbnaviglink = interface(inullinterface)
  procedure setactivebuttons(const abuttons: dbnavigbuttonsty;
               const afiltered: boolean);
  function getwidget: twidget;
  function getnavigoptions: dbnavigatoroptionsty;
 end;

 tnavigdatalink = class(tmsedatalink)
  private
   fintf: idbnaviglink;
  protected
   procedure updatebuttonstate;
   procedure activechanged; override;
   procedure datasetchanged; override;
   procedure editingchanged; override;
   procedure recordchanged(Field: TField); override;
  public
   constructor create(const intf: idbnaviglink);
   procedure execbutton(const abutton: dbnavigbuttonty);
 end;
 
 tdbnavigator = class(tcustomtoolbar,idbnaviglink)
  private
   fdatalink: tnavigdatalink;
   fvisiblebuttons: dbnavigbuttonsty;
   fshortcuts: array[dbnavigbuttonty] of shortcutty;
   foptions: dbnavigatoroptionsty;
   function getdatasource: tdatasource;
   procedure setdatasource(const Value: tdatasource);
   procedure setvisiblebuttons(const avalue: dbnavigbuttonsty);
   function getcolorglyph: colorty;
   procedure setcolorglyph(const avalue: colorty);
   procedure setoptions(const avalue: dbnavigatoroptionsty);
   function getbuttonface: tface;
   procedure setbuttonface(const avalue: tface);
  protected
   procedure inithints;
   procedure doexecute(const sender: tobject);
   procedure loaded; override;
   procedure doshortcut(var info: keyeventinfoty; const sender: twidget); override;
   procedure doasyncevent(var atag: integer); override;
   //idbnaviglink
   procedure setactivebuttons(const abuttons: dbnavigbuttonsty;
                             const afiltered: boolean);
   function getnavigoptions: dbnavigatoroptionsty;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override; 
  published
   property datasource: tdatasource read getdatasource write setdatasource;
   property visiblebuttons: dbnavigbuttonsty read fvisiblebuttons 
                 write setvisiblebuttons default defaultvisibledbnavigbuttons;
   property colorglyph: colorty read getcolorglyph write setcolorglyph default cl_glyph;
   property buttonface: tface read getbuttonface write setbuttonface;
   property bounds_cx default defaultdbnavigatorwidth;
   property bounds_cy default defaultdbnavigatorheight;
   property shortcut_first: shortcutty read fshortcuts[dbnb_first] 
                  write fshortcuts[dbnb_first] default key_modctrl + ord(key_pageup);
   property shortcut_prior: shortcutty read fshortcuts[dbnb_prior] 
                  write fshortcuts[dbnb_prior] default ord(key_pageup);
   property shortcut_next: shortcutty read fshortcuts[dbnb_next] 
                  write fshortcuts[dbnb_next] default ord(key_pagedown);
   property shortcut_last: shortcutty read fshortcuts[dbnb_last] 
                  write fshortcuts[dbnb_last] default key_modctrl + ord(key_pagedown);
   property shortcut_insert: shortcutty read fshortcuts[dbnb_insert] 
                  write fshortcuts[dbnb_insert] default ord(key_none);
   property shortcut_delete: shortcutty read fshortcuts[dbnb_delete] 
                  write fshortcuts[dbnb_delete] default ord(key_none);
   property shortcut_edit: shortcutty read fshortcuts[dbnb_edit]
                  write fshortcuts[dbnb_edit] default ord(key_f2);
   property shortcut_post: shortcutty read fshortcuts[dbnb_post] 
                  write fshortcuts[dbnb_post] default ord(key_none);
   property shortcut_cancel: shortcutty read fshortcuts[dbnb_cancel] 
                  write fshortcuts[dbnb_cancel] default ord(key_none);
   property shortcut_refresh: shortcutty read fshortcuts[dbnb_refresh]
                  write fshortcuts[dbnb_refresh] default ord(key_none);
   property options: dbnavigatoroptionsty read foptions write setoptions 
                  default defaultdbnavigatoroptions;
 end;

 idbeditfieldlink = interface(inullinterface)
  function getwidget: twidget;
  function getenabled: boolean;
  procedure setenabled(const avalue: boolean);
  function getgridintf: iwidgetgrid;
  function getgriddatasource: tdatasource;
  function edited: boolean;
  function seteditfocus: boolean;
  procedure initeditfocus;
  function checkvalue(const quiet: boolean = false): boolean;
  procedure valuetofield;
  procedure fieldtovalue;
  procedure setnullvalue;
  function getoptionsedit: optionseditty;
  function getoptionsdb: optionseditdbty;
  procedure updatereadonlystate;
 end;

 tgriddatalink = class;
 
 editwidgetdatalinkstatety = (ewds_editing,ewds_modified,ewds_filterediting,
                              ewds_filtereditdisabled);
 editwidgetdatalinkstatesty = set of editwidgetdatalinkstatety;
 
 teditwidgetdatalink = class(tfielddatalink)
  private
//   fediting: boolean;
//   fmodified: boolean;
//   ffilterediting: boolean;
   fstate: editwidgetdatalinkstatesty;
   frecordchange: integer;
   fbeginedit: integer;
   fmaxlength: integer;
   fposting: integer;
   function canmodify: boolean;
   procedure setediting(avalue: boolean);
  protected
   fintf: idbeditfieldlink;
   procedure dataevent(event: tdataevent; info: ptrint); override;
   procedure activechanged; override;
   procedure editingchanged; override;
   procedure focuscontrol(afield: tfieldref); override;
   procedure updatedata; override;
  public
   constructor create(const intf: idbeditfieldlink);
   procedure recordchanged(afield: tfield); override;
   function nullcheckneeded: boolean;
   procedure setwidgetdatasource(const avalue: tdatasource);
   procedure griddatasourcechanged;
   function edit: Boolean;
   procedure modified;
//   function dataentered: boolean;
   procedure dataentered;
   procedure updateoptionsedit(var aoptions: optionseditty);
   function cuttext(const atext: msestring; out maxlength: integer): boolean; 
             //true if text to long
 end;

 tdbstringedit = class(tcustomstringedit,idbeditfieldlink,idbeditinfo,ireccontrol)
  private
   fdatalink: teditwidgetdatalink;
   function getdatafield: string;
   procedure setdatafield(const avalue: string);
   function getdatasource: tdatasource; overload;
   function getdatasource(const aindex: integer): tdatasource; overload;
   procedure setdatasource(const avalue: tdatasource);
  protected

   procedure editnotification(var info: editnotificationinfoty); override;
   function nullcheckneeded(const newfocus: twidget): boolean; override;
   procedure griddatasourcechanged; override;
   function getgriddatasource: tdatasource;
   function createdatalist(const sender: twidgetcol): tdatalist; override;
   procedure modified; override;
   function getoptionsedit: optionseditty; override;
   procedure dochange; override;

   function getrowdatapo(const info: cellinfoty): pointer; override;
   //idbeditfieldlink
   procedure valuetofield;
   procedure fieldtovalue;
   //idbeditinfo
   procedure getfieldtypes(out propertynames: stringarty;
                          out fieldtypes: fieldtypesarty);
   //ireccontrol
   procedure recchanged;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
//   function checkvalue(const quiet: boolean = false): boolean; override;
   property datalink: teditwidgetdatalink read fdatalink;
  published
   property datafield: string read getdatafield write setdatafield;
   property datasource: tdatasource read getdatasource write setdatasource;
   property optionsdb;

   property passwordchar;
   property maxlength;
   property onsetvalue;
 end;

 tdbdialogstringedit = class(tcustomdialogstringedit,idbeditfieldlink,idbeditinfo,ireccontrol)
  private
   fdatalink: teditwidgetdatalink;
   function getdatafield: string;
   procedure setdatafield(const avalue: string);
   function getdatasource: tdatasource; overload;
   function getdatasource(const aindex: integer): tdatasource; overload;
   procedure setdatasource(const avalue: tdatasource);
  protected

   function nullcheckneeded(const newfocus: twidget): boolean; override;
   procedure griddatasourcechanged; override;
   function getgriddatasource: tdatasource;
   function createdatalist(const sender: twidgetcol): tdatalist; override;
   procedure modified; override;
   function getoptionsedit: optionseditty; override;
   procedure dochange; override;

   function getrowdatapo(const info: cellinfoty): pointer; override;
   //idbeditfieldlink
   procedure valuetofield;
   procedure fieldtovalue;
   //idbeditinfo
   procedure getfieldtypes(out propertynames: stringarty;
                          out fieldtypes: fieldtypesarty);
   //ireccontrol
   procedure recchanged;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
//   function checkvalue(const quiet: boolean = false): boolean; override;
   property datalink: teditwidgetdatalink read fdatalink;
  published
   property datafield: string read getdatafield write setdatafield;
   property datasource: tdatasource read getdatasource write setdatasource;
   property optionsdb;

   property passwordchar;
   property maxlength;
   property onsetvalue;
   property onexecute;
 end;
 
 tcustomdbdropdownlistedit = class(tcustomdropdownlistedit,idbeditfieldlink,idbeditinfo,ireccontrol)
  private
   fdatalink: teditwidgetdatalink;
   function getdatafield: string;
   procedure setdatafield(const avalue: string);
   function getdatasource: tdatasource; overload;
   function getdatasource(const aindex: integer): tdatasource; overload;
   procedure setdatasource(const avalue: tdatasource);
  protected

   function nullcheckneeded(const newfocus: twidget): boolean; override;
   procedure griddatasourcechanged; override;
   function getgriddatasource: tdatasource;
   function createdatalist(const sender: twidgetcol): tdatalist; override;
   procedure modified; override;
   function getoptionsedit: optionseditty; override;
   procedure dochange; override;

   function getrowdatapo(const info: cellinfoty): pointer; override;
   //idbeditfieldlink
   procedure valuetofield;
   procedure fieldtovalue;
   //idbeditinfo
   procedure getfieldtypes(out propertynames: stringarty;
                          out fieldtypes: fieldtypesarty);
   //ireccontrol
   procedure recchanged;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
//   function checkvalue(const quiet: boolean = false): boolean; override;
   property datalink: teditwidgetdatalink read fdatalink;
   property datafield: string read getdatafield write setdatafield;
   property datasource: tdatasource read getdatasource write setdatasource;
 end;
 
 tdbdropdownlistedit = class(tcustomdbdropdownlistedit)
  published
   property datafield;
   property datasource;
   property optionsdb;
   property dropdown;
   property onsetvalue;
   property onbeforedropdown;
   property onafterclosedropdown;
 end;

 tdbkeystringedit = class(tcustomkeystringedit,idbeditfieldlink,idbeditinfo,ireccontrol)
  private
   fdatalink: teditwidgetdatalink;
   function getdatafield: string;
   procedure setdatafield(const avalue: string);
   function getdatasource: tdatasource; overload;
   function getdatasource(const aindex: integer): tdatasource; overload;
   procedure setdatasource(const avalue: tdatasource);
  protected

   function nullcheckneeded(const newfocus: twidget): boolean; override;
   procedure griddatasourcechanged; override;
   function getgriddatasource: tdatasource;
   function createdatalist(const sender: twidgetcol): tdatalist; override;
   procedure modified; override;
   function getoptionsedit: optionseditty; override;
   procedure dochange; override;

   function getrowdatapo(const info: cellinfoty): pointer; override;
   //idbeditfieldlink
   procedure valuetofield;
   procedure fieldtovalue;
   //idbeditinfo
   procedure getfieldtypes(out propertynames: stringarty;
                          out fieldtypes: fieldtypesarty);
   //ireccontrol
   procedure recchanged;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
//   function checkvalue(const quiet: boolean = false): boolean; override;
   property datalink: teditwidgetdatalink read fdatalink;
  published
   property datafield: string read getdatafield write setdatafield;
   property datasource: tdatasource read getdatasource write setdatasource;

   property optionsdb;
   property valuedefault;
   property onsetvalue;
   property dropdown;
   property onbeforedropdown;
   property onafterclosedropdown;
   property oninit;
 end;

 tdbmemoedit = class(tcustommemoedit,idbeditfieldlink,idbeditinfo,ireccontrol)
  private
   fdatalink: teditwidgetdatalink;
   function getdatafield: string;
   procedure setdatafield(const avalue: string);
   function getdatasource: tdatasource; overload;
   function getdatasource(const aindex: integer): tdatasource; overload;
   procedure setdatasource(const avalue: tdatasource);
  protected

   function nullcheckneeded(const newfocus: twidget): boolean; override;
   procedure griddatasourcechanged; override;
   function getgriddatasource: tdatasource;
   function createdatalist(const sender: twidgetcol): tdatalist; override;
   procedure modified; override;
   function getoptionsedit: optionseditty; override;
   procedure dochange; override;

   function getrowdatapo(const info: cellinfoty): pointer; override;
   //idbeditfieldlink
   procedure valuetofield;
   procedure fieldtovalue;
   //idbeditinfo
   procedure getfieldtypes(out propertynames: stringarty;
                          out fieldtypes: fieldtypesarty);
   //ireccontrol
   procedure recchanged;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
//   function checkvalue(const quiet: boolean = false): boolean; override;
   property datalink: teditwidgetdatalink read fdatalink;
  published
   property datafield: string read getdatafield write setdatafield;
   property datasource: tdatasource read getdatasource write setdatasource;

   property optionsdb;
   property onsetvalue;
   property frame;
 end;

 tdbintegeredit = class(tcustomintegeredit,idbeditfieldlink,idbeditinfo,ireccontrol)
  private
   fdatalink: teditwidgetdatalink;
   function getdatafield: string;
   procedure setdatafield(const avalue: string);
   function getdatasource: tdatasource; overload;
   function getdatasource(const aindex: integer): tdatasource; overload;
   procedure setdatasource(const avalue: tdatasource);
  protected

   function nullcheckneeded(const newfocus: twidget): boolean; override;
   procedure griddatasourcechanged; override;
   function getgriddatasource: tdatasource;
   function createdatalist(const sender: twidgetcol): tdatalist; override;
   procedure modified; override;
   function getoptionsedit: optionseditty; override;
   procedure dochange; override;

   function internaldatatotext(const data): msestring; override;
   procedure texttovalue(var accept: boolean; const quiet: boolean); override;
   procedure setnullvalue; override;
   function getrowdatapo(const info: cellinfoty): pointer; override;
   //idbeditfieldlink
   procedure valuetofield;
   procedure fieldtovalue;
   //idbeditinfo
   procedure getfieldtypes(out propertynames: stringarty;
                          out fieldtypes: fieldtypesarty);
   //ireccontrol
   procedure recchanged;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
//   function checkvalue(const quiet: boolean = false): boolean; override;
   property isnull: boolean read fisnull;
   property datalink: teditwidgetdatalink read fdatalink;
  published
   property datafield: string read getdatafield write setdatafield;
   property datasource: tdatasource read getdatasource write setdatasource;

   property optionsdb;
   property base;
   property bitcount;
   property min;
   property max;
   property onsetvalue;
 end;

 tdbbooleanedit = class(tcustombooleanedit,idbeditfieldlink,idbeditinfo,ireccontrol)
  private
   fdatalink: teditwidgetdatalink;
   function getdatafield: string;
   procedure setdatafield(const avalue: string);
   function getdatasource: tdatasource; overload;
   function getdatasource(const aindex: integer): tdatasource; overload;
   procedure setdatasource(const avalue: tdatasource);
  protected

   procedure griddatasourcechanged; override;
   function getgriddatasource: tdatasource;
   function createdatalist(const sender: twidgetcol): tdatalist; override;
   function checkvalue(const quiet: boolean = false): boolean; reintroduce;
//   function docheckvalue(var avalue): boolean; override;
   procedure dochange; override;
   procedure modified; override;
   function getoptionsedit: optionseditty; override;

   function getrowdatapo(const info: cellinfoty): pointer; override;
   //idbeditfieldlink
   procedure valuetofield;
   procedure fieldtovalue;
   //idbeditinfo
   procedure getfieldtypes(out propertynames: stringarty;
                          out fieldtypes: fieldtypesarty);
   //ireccontrol
   procedure recchanged;                          
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   property datalink: teditwidgetdatalink read fdatalink;
  published
   property datafield: string read getdatafield write setdatafield;
   property datasource: tdatasource read getdatasource write setdatasource;
   property optionsdb;

   property onsetvalue;
   property bounds_cx  default defaultboxsize;
   property bounds_cy  default defaultboxsize;
   property group;
 end;

 tdbdataicon = class(tcustomdataicon,idbeditfieldlink,idbeditinfo,ireccontrol)
  private
   fdatalink: teditwidgetdatalink;
   function getdatafield: string;
   procedure setdatafield(const avalue: string);
   function getdatasource: tdatasource; overload;
   function getdatasource(const aindex: integer): tdatasource; overload;
   procedure setdatasource(const avalue: tdatasource);
  protected

   procedure griddatasourcechanged; override;
   function getgriddatasource: tdatasource;
   function createdatalist(const sender: twidgetcol): tdatalist; override;
   function checkvalue(const quiet: boolean = false): boolean; reintroduce;
//   function docheckvalue(var avalue): boolean; override;
   procedure modified; override;
   procedure dochange; override;
   function getoptionsedit: optionseditty; override;

   function getrowdatapo(const info: cellinfoty): pointer; override;
   //idbeditfieldlink
   procedure valuetofield;
   procedure fieldtovalue;
   //idbeditinfo
   procedure getfieldtypes(out propertynames: stringarty;
                          out fieldtypes: fieldtypesarty);
   //ireccontrol
   procedure recchanged;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   property datalink: teditwidgetdatalink read fdatalink;
  published
   property datafield: string read getdatafield write setdatafield;
   property datasource: tdatasource read getdatasource write setdatasource;
   property optionsdb;

   property onsetvalue;
   property min; 
   property max;
   property imagelist;
   property imageoffset;
   property imagenums;
 end;

 tdbdatabutton = class(tcustomdatabutton,idbeditfieldlink,idbeditinfo,ireccontrol)
  private
   fdatalink: teditwidgetdatalink;
   function getdatafield: string;
   procedure setdatafield(const avalue: string);
   function getdatasource: tdatasource; overload;
   function getdatasource(const aindex: integer): tdatasource; overload;
   procedure setdatasource(const avalue: tdatasource);
  protected

   procedure griddatasourcechanged; override;
   function getgriddatasource: tdatasource;
   function createdatalist(const sender: twidgetcol): tdatalist; override;
   function checkvalue(const quiet: boolean = false): boolean; reintroduce;
//   function docheckvalue(var avalue): boolean; override;
   procedure dochange; override;
   procedure modified; override;
   function getoptionsedit: optionseditty; override;

   function getrowdatapo(const info: cellinfoty): pointer; override;
   //idbeditfieldlink
   procedure valuetofield;
   procedure fieldtovalue;
   //idbeditinfo
   procedure getfieldtypes(out propertynames: stringarty;
                          out fieldtypes: fieldtypesarty);
   //ireccontrol
   procedure recchanged;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   property datalink: teditwidgetdatalink read fdatalink;
  published
   property datafield: string read getdatafield write setdatafield;
   property datasource: tdatasource read getdatasource write setdatasource;
   property optionsdb;
   property optionswidget;
   property optionsskin;
   property valuefaces;
   property font;


   property action;
   property caption;
   property shortcut;
   property shortcut1;
   property captionpos;
   property captiondist;
   property imagelist;
   property imagenr;
   property imagenrdisabled;
   property imagedist;
   property colorglyph;
   property options;
   property focusrectdist;
   property onexecute;

   property imageoffset;
   property imageoffsetdisabled;
   property imagenums;
   property onsetvalue;
//   property value;
   property valuedefault;
   property min; 
   property max;

 end;
 
 tdbbooleaneditradio = class(tcustombooleaneditradio,idbeditfieldlink,idbeditinfo,ireccontrol)
  private
   fdatalink: teditwidgetdatalink;
   function getdatafield: string;
   procedure setdatafield(const avalue: string);
   function getdatasource: tdatasource; overload;
   function getdatasource(const aindex: integer): tdatasource; overload;
   procedure setdatasource(const avalue: tdatasource);
  protected

   procedure griddatasourcechanged; override;
   function getgriddatasource: tdatasource;
   function createdatalist(const sender: twidgetcol): tdatalist; override;
   function checkvalue(const quiet: boolean = false): boolean; reintroduce;
   function docheckvalue(var avalue): boolean; override;
   procedure dochange; override;
   procedure modified; override;
   function getoptionsedit: optionseditty; override;

   function getrowdatapo(const info: cellinfoty): pointer; override;
   //idbeditfieldlink
   procedure valuetofield;
   procedure fieldtovalue;
   //idbeditinfo
   procedure getfieldtypes(out propertynames: stringarty;
                          out fieldtypes: fieldtypesarty);
   //ireccontrol
   procedure recchanged;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   property datalink: teditwidgetdatalink read fdatalink;
  published
   property datafield: string read getdatafield write setdatafield;
   property datasource: tdatasource read getdatasource write setdatasource;
   property optionsdb;

   property onsetvalue;
   property bounds_cx  default defaultboxsize;
   property bounds_cy  default defaultboxsize;
   property group;
 end;

 tdbrealedit = class(tcustomrealedit,idbeditfieldlink,idbeditinfo,ireccontrol)
  private
   fdatalink: teditwidgetdatalink;
   function getdatafield: string;
   procedure setdatafield(const avalue: string);
   function getdatasource: tdatasource; overload;
   function getdatasource(const aindex: integer): tdatasource; overload;
   procedure setdatasource(const avalue: tdatasource);
  protected

   function nullcheckneeded(const newfocus: twidget): boolean; override;
   procedure griddatasourcechanged; override;
   function getgriddatasource: tdatasource;
   function createdatalist(const sender: twidgetcol): tdatalist; override;
   procedure modified; override;
   function getoptionsedit: optionseditty; override;
   procedure dochange; override;

   function getrowdatapo(const info: cellinfoty): pointer; override;
   //idbeditfieldlink
   procedure valuetofield;
   procedure fieldtovalue;
   //idbeditinfo
   procedure getfieldtypes(out propertynames: stringarty;
                          out fieldtypes: fieldtypesarty);
   //ireccontrol
   procedure recchanged;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
//   function checkvalue(const quiet: boolean = false): boolean; override;
   property datalink: teditwidgetdatalink read fdatalink;
  published
   property datafield: string read getdatafield write setdatafield;
   property datasource: tdatasource read getdatasource write setdatasource;
   property optionsdb;

   property min stored false;
   property max stored false;
   property formatedit;
   property formatdisp;
   property valuescale;
   property onsetvalue;
   property onsetintvalue;
 end;

 tdbrealspinedit = class(tcustomrealspinedit,idbeditfieldlink,idbeditinfo,ireccontrol)
  private
   fdatalink: teditwidgetdatalink;
   function getdatafield: string;
   procedure setdatafield(const avalue: string);
   function getdatasource: tdatasource; overload;
   function getdatasource(const aindex: integer): tdatasource; overload;
   procedure setdatasource(const avalue: tdatasource);
  protected

   function nullcheckneeded(const newfocus: twidget): boolean; override;
   procedure griddatasourcechanged; override;
   function getgriddatasource: tdatasource;
   function createdatalist(const sender: twidgetcol): tdatalist; override;
   procedure modified; override;
   function getoptionsedit: optionseditty; override;
   procedure dochange; override;

   function getrowdatapo(const info: cellinfoty): pointer; override;
   //idbeditfieldlink
   procedure valuetofield;
   procedure fieldtovalue;
   //idbeditinfo
   procedure getfieldtypes(out propertynames: stringarty;
                          out fieldtypes: fieldtypesarty);
   //ireccontrol
   procedure recchanged;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
//   function checkvalue(const quiet: boolean = false): boolean; override;
   property datalink: teditwidgetdatalink read fdatalink;
  published
   property datafield: string read getdatafield write setdatafield;
   property datasource: tdatasource read getdatasource write setdatasource;
   property optionsdb;

   property min stored false;
   property max stored false;
   property formatedit;
   property formatdisp;
   property valuescale;
   property onsetvalue;
   property step;
 end;

 tdbslider = class(tcustomslider,idbeditfieldlink,idbeditinfo,ireccontrol)
  private
   fdatalink: teditwidgetdatalink;
   fvaluescale: real;
   function getdatafield: string;
   procedure setdatafield(const avalue: string);
   function getdatasource: tdatasource; overload;
   function getdatasource(const aindex: integer): tdatasource; overload;
   procedure setdatasource(const avalue: tdatasource);
  protected

   procedure griddatasourcechanged; override;
   function getgriddatasource: tdatasource;
   function createdatalist(const sender: twidgetcol): tdatalist; override;
   function getoptionsedit: optionseditty; override;

//   function docheckvalue(var avalue): boolean; override;
   procedure dochange; override;
   procedure modified; override;
   function getrowdatapo(const info: cellinfoty): pointer; override;
   //idbeditfieldlink
   procedure valuetofield;
   procedure fieldtovalue;
   //idbeditinfo
   procedure getfieldtypes(out propertynames: stringarty;
                          out fieldtypes: fieldtypesarty);
   //ireccontrol
   procedure recchanged;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   function checkvalue(const quiet: boolean = false): boolean; reintroduce;
   property datalink: teditwidgetdatalink read fdatalink;
  published
   property valuescale: real read fvaluescale write fvaluescale;
   property datafield: string read getdatafield write setdatafield;
   property datasource: tdatasource read getdatasource write setdatasource;
   property scrollbar;
   property onsetvalue;
   property direction;
   property optionsdb;

//   property min stored false;
//   property max stored false;
//   property formatedit;
//   property formatdisp;
//   property valuescale;
//   property onsetvalue;
 end;

 tdbprogressbar = class(tcustomprogressbar,idbeditfieldlink,idbeditinfo,ireccontrol)
  private
   fdatalink: teditwidgetdatalink;
   function getdatafield: string;
   procedure setdatafield(const avalue: string);
   function getdatasource: tdatasource; overload;
   function getdatasource(const aindex: integer): tdatasource; overload;
   procedure setdatasource(const avalue: tdatasource);
  protected
   function getrowdatapo(const info: cellinfoty): pointer; override;
   procedure griddatasourcechanged; override;
   //idbeditfieldlink
   procedure valuetofield;
   procedure fieldtovalue;
   //idbeditinfo
   procedure getfieldtypes(out propertynames: stringarty;
                          out fieldtypes: fieldtypesarty);
   //ireccontrol
   procedure recchanged;
   //idbeditfieldlink
   function getgriddatasource: tdatasource;
   function createdatalist(const sender: twidgetcol): tdatalist; override;
   function checkvalue(const quiet: boolean = false): boolean; reintroduce;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
  published
   property datafield: string read getdatafield write setdatafield;
   property datasource: tdatasource read getdatasource write setdatasource;
   property optionsdb;
 end;
 
 tdbdatetimeedit = class(tcustomdatetimeedit,idbeditfieldlink,idbeditinfo,ireccontrol)
  private
   fdatalink: teditwidgetdatalink;
   function getdatafield: string;
   procedure setdatafield(const avalue: string);
   function getdatasource: tdatasource; overload;
   function getdatasource(const aindex: integer): tdatasource; overload;
   procedure setdatasource(const avalue: tdatasource);
  protected

   function nullcheckneeded(const newfocus: twidget): boolean; override;
   procedure griddatasourcechanged; override;
   function getgriddatasource: tdatasource;
   function createdatalist(const sender: twidgetcol): tdatalist; override;
   procedure modified; override;
   function getoptionsedit: optionseditty; override;
   procedure dochange; override;

   function getrowdatapo(const info: cellinfoty): pointer; override;
   //idbeditfieldlink
   procedure valuetofield;
   procedure fieldtovalue;
   //idbeditinfo
   procedure getfieldtypes(out propertynames: stringarty;
                          out fieldtypes: fieldtypesarty);
   //ireccontrol
   procedure recchanged;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
//   function checkvalue(const quiet: boolean = false): boolean; override;
   property datalink: teditwidgetdatalink read fdatalink;
  published
   property datafield: string read getdatafield write setdatafield;
   property datasource: tdatasource read getdatasource write setdatasource;
   property optionsdb;

   property min stored false;
   property max stored false;
   property formatedit;
   property formatdisp;
   property kind;
   property onsetvalue;
 end;

 tdbcalendardatetimeedit = class(tcustomcalendardatetimeedit,idbeditfieldlink,idbeditinfo,ireccontrol)
  private
   fdatalink: teditwidgetdatalink;
   function getdatafield: string;
   procedure setdatafield(const avalue: string);
   function getdatasource: tdatasource; overload;
   function getdatasource(const aindex: integer): tdatasource; overload;
   procedure setdatasource(const avalue: tdatasource);
  protected

   function nullcheckneeded(const newfocus: twidget): boolean; override;
   procedure griddatasourcechanged; override;
   function getgriddatasource: tdatasource;
   function createdatalist(const sender: twidgetcol): tdatalist; override;
   procedure modified; override;
   function getoptionsedit: optionseditty; override;
   procedure dochange; override;

   function getrowdatapo(const info: cellinfoty): pointer; override;
   //idbeditfieldlink
   procedure valuetofield;
   procedure fieldtovalue;
   //idbeditinfo
   procedure getfieldtypes(out propertynames: stringarty;
                          out fieldtypes: fieldtypesarty);
   //ireccontrol
   procedure recchanged;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
//   function checkvalue(const quiet: boolean = false): boolean; override;
   property datalink: teditwidgetdatalink read fdatalink;
  published
   property datafield: string read getdatafield write setdatafield;
   property datasource: tdatasource read getdatasource write setdatasource;
   property optionsdb;

   property min stored false;
   property max stored false;
   property formatedit;
   property formatdisp;
   property kind;
   property onsetvalue;
   property dropdown;
 end;
 
 tcustomdbenumedit = class(tcustomenumedit,idbeditfieldlink,idbeditinfo,ireccontrol)
  private
   fdatalink: teditwidgetdatalink;
   function getdatafield: string;
   procedure setdatafield(const avalue: string);
   function getdatasource: tdatasource; overload;
   function getdatasource(const aindex: integer): tdatasource; overload;
   procedure setdatasource(const avalue: tdatasource);
  protected

   function nullcheckneeded(const newfocus: twidget): boolean; override;
   procedure griddatasourcechanged; override;
   function getgriddatasource: tdatasource;
   function createdatalist(const sender: twidgetcol): tdatalist; override;
   procedure modified; override;
   function getoptionsedit: optionseditty; override;
   procedure dochange; override;

   function getrowdatapo(const info: cellinfoty): pointer; override;
   //idbeditfieldlink
   procedure valuetofield; virtual;
   procedure fieldtovalue; virtual;
   //idbeditinfo
   procedure getfieldtypes(out propertynames: stringarty;
                          out fieldtypes: fieldtypesarty); virtual;
   //ireccontrol
   procedure recchanged;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   property datalink: teditwidgetdatalink read fdatalink;
   property datafield: string read getdatafield write setdatafield;
   property datasource: tdatasource read getdatasource write setdatasource;
 end;
 
 tdbenumedit = class(tcustomdbenumedit)
  published
   property datafield;
   property datasource;
   property optionsdb;
   property valuedefault;
   property base;
   property bitcount;
   property min;
   property max;
   property dropdown;
   property onsetvalue;
   property onbeforedropdown;
   property onafterclosedropdown;
   property oninit;
 end;

 tdbbooleantextedit = class(tcustomdbenumedit)
  private
   ftext_false: msestring;
   ftext_true: msestring;
   function getvalue: boolean;
   procedure setvalue(const avalue: boolean);
   procedure settext_false(const avalue: msestring);
   procedure settext_true(const avalue: msestring);
   procedure booltextchanged;
  protected
   function getrowdatapo(const info: cellinfoty): pointer; override;
   //idbeditfieldlink
   procedure valuetofield; override;
   procedure fieldtovalue; override;
   //idbeditinfo
   procedure getfieldtypes(out propertynames: stringarty;
                          out fieldtypes: fieldtypesarty); override;
  public
   constructor create(aowner: tcomponent); override;
   property value: boolean read getvalue write setvalue;
  published
   property text_false: msestring read ftext_false write settext_false;
   property text_true: msestring read ftext_true write settext_true;
   property datafield;
   property datasource;
   property optionsdb;
   property valuedefault;
   property onsetvalue;
 end;
 

 tnolistdropdowncol = class(tdropdowncol)
 end;
 
 tnolistdropdowncols = class(tdropdowncols)
 end;
 
 tdbdropdowncol = class(tnolistdropdowncol,idbeditinfo)
  private
   fdatafield: string;
   procedure setdatafield(const avalue: string);
   //idbeditinfo
//   function getdatasource: tdatasource; overload;
   function getdatasource(const aindex: integer): tdatasource;
   procedure getfieldtypes(out propertynames: stringarty;
                          out fieldtypes: fieldtypesarty);
  published
   property datafield: string read fdatafield write setdatafield;
 end;
 
 tdbdropdowncols = class(tnolistdropdowncols)
  private
   function getitems(const index: integer): tdbdropdowncol;
  protected
   function getcolclass: dropdowncolclassty; override;
  public
   property items[const index: integer]: tdbdropdowncol read getitems; default;
 end;

 tdbdropdownlistcontroller = class;
 
 tdropdowndatalink = class(tmsedatalink)
  private
   fowner: tdbdropdownlistcontroller;
   fvaluefield: tfield;
   fvaluefieldname: string;
   ftextfield: tfield;
   procedure setvaluefield(value: tfield);
   procedure setvaluefieldname(const value: string);
   procedure settextfield(value: tfield);
   procedure updatefields;
  protected
   procedure layoutchanged; override;
   procedure activechanged; override;
  public
   constructor create(const aowner: tdbdropdownlistcontroller);
   function getlookuptext(const key: integer): msestring; overload;
   function getlookuptext(const key: int64): msestring; overload;
   function getlookuptext(const key: msestring): msestring; overload;
   property valuefield: tfield read fvaluefield;
   property valuefieldName: string read fvaluefieldname write setvaluefieldname;
   property textfield: tfield read ftextfield;
 end;

 tdbdropdownstringcol = class(tdropdownstringcol)
  private
   fdatalink: tfielddatalink;
  protected
   function getrowtext(const arow: integer): msestring; override;
  public
   constructor create(const agrid: tcustomgrid; 
                                  const aowner: tgridarrayprop); override;
   destructor destroy; override;
 end;

 griddatalinkoptionty = (gdo_propscrollbar,gdo_thumbtrack,
           gdo_checkbrowsemodeonexit);
 griddatalinkoptionsty = set of griddatalinkoptionty;
 updaterowdataeventty = procedure(const sender: tcustomgrid; 
                        const arow: integer; const adataset: tdataset)of object;
 igriddatalink = interface(inullinterface)
  function getdbindicatorcol: integer;
 end;
 
 tgriddatalink = class(tfielddatalink,ievent,idbeditinfo)
  private
   fintf: igriddatalink;
   fgrid: tcustomgrid;
   factiverecordbefore: integer;
   fzebraoffset: integer;
   ffirstrecordbefore: integer;
   fdatasetstatebefore: tdatasetstate;
   fdummystringbuffer: ansistring;
   fansistringbuffer: ansistring;
   fstringbuffer: msestring;
   fintegerbuffer: integer;
   fint64buffer: int64;
   frealtybuffer: realty;
   fgridinvalidated: boolean;
   foptions: griddatalinkoptionsty;
   fonupdaterowdata: updaterowdataeventty;
   fnullchecking: integer;
   fdatasetchangedlock: integer;
   fobjectlinker: tobjectlinker;
   fcolordatalink: tfielddatalink;
   ffontdatalink: tfielddatalink;
   frowexited: integer;
   feditingbefore: boolean;
   finserting: boolean;
   finsertingbefore: boolean;
   procedure checkscroll;
   procedure checkscrollbar;
   function getfirstrecord: integer;
   procedure doupdaterowdata(const row: integer);
   procedure beginnullchecking;
   procedure endnullchecking;
   procedure setdatafield(const avalue: string);
   function getdatafield: string;
   procedure forcecalcrange;
   
   function getobjectlinker: tobjectlinker;
    //iobjectlink
   procedure link(const source,dest: iobjectlink; valuepo: pointer = nil;
               ainterfacetype: pointer = nil; once: boolean = false);
   procedure unlink(const source,dest: iobjectlink; valuepo: pointer = nil); virtual;
   procedure objevent(const sender: iobjectlink; const event: objecteventty); virtual;
   function getinstance: tobject;
     //ievent
   procedure receiveevent(const event: tobjectevent);
     //idbeditinfo
   function getdatasource(const aindex: integer): tdatasource;
   procedure getfieldtypes(out propertynames: stringarty;
                          out fieldtypes: fieldtypesarty);
  protected
   function checkvalue: boolean;
   procedure updatelayout;
   procedure updaterowcount;
   procedure datasetscrolled(distance: integer); override;
   procedure activechanged; override;
   procedure editingchanged; override;
   procedure updatedata; override;
   procedure focuscell(var cell: gridcoordty);
   procedure cellevent(var info: celleventinfoty);
   procedure invalidateindicator;
   function scrollevent(sender: tcustomscrollbar; event: scrolleventty): boolean;
             //true if processed
   procedure doinsertrow;
   procedure doappendrow;
   procedure dodeleterow;
   procedure rowdown;
   procedure lastrow;
   procedure firstrow;
   function getzebrastart: integer;
   procedure gridinvalidate;
   function arecord: integer;
   function hasdata: boolean;
  public
   constructor create(const aowner: tcustomgrid; const aintf: igriddatalink);
   destructor destroy; override;
   property firstrecord: integer read getfirstrecord;
   function getdummystringbuffer: pansistring;
   function getrowfieldisnull(const afield: tfield; const row: integer): boolean;
   function getansistringbuffer(const afield: tfield; const row: integer): pointer;
   function getstringbuffer(const afield: tfield; const row: integer): pointer;
   function getdisplaystringbuffer(const afield: tfield; const row: integer{;
                                       const aedit: boolean}): pointer;
   function getbooleanbuffer(const afield: tfield; const row: integer): pointer;
   function getintegerbuffer(const afield: tfield; const row: integer): pointer;
   function getint64buffer(const afield: tfield; const row: integer): pointer;
   function getrealtybuffer(const afield: tfield; const row: integer): pointer;
   function getdatetimebuffer(const afield: tfield; const row: integer): pointer;

   procedure recordchanged(afield: tfield); override;
   procedure datasetchanged; override;
   function canclose(const newfocus: twidget): boolean;

   procedure painted;
   procedure loaded;
   procedure beforefocuscell(const cell: gridcoordty;
                             const selectaction: focuscellactionty);
   function moveby(distance: integer): integer; override;
   function rowtorecnonullbased(const row: integer): integer;
  published
   property options: griddatalinkoptionsty read foptions write foptions default [];
   property onupdaterowdata: updaterowdataeventty read fonupdaterowdata 
                                write fonupdaterowdata;
   property datafield: string read getdatafield 
                                       write setdatafield;
             //integer field, selects grid rowcolor (field value and $7f),
             //readonlystate (field value and $80) and
             //grid rowfont ((fieldvalue shr 8) and $7f). 
             // $xx7f = default color, $7fxx = default font.
 end;

 tdropdownlistdatalink = class(tgriddatalink)
  protected
   procedure recordchanged(afield: tfield); override;
 end;
 
 tdbdropdownlist = class(tdropdownlist,igriddatalink)
  private
   fdatalink: tdropdownlistdatalink;
   function getdbindicatorcol: integer;
  protected
   procedure internalcreateframe; override;
   procedure createdatacol(const index: integer; out item: tdatacol); override;
   procedure initcols(const acols: tdropdowncols); override;
   procedure docellevent(var info: celleventinfoty); override;
   procedure scrollevent(sender: tcustomscrollbar; event: scrolleventty); override;
   function locate(const filter: msestring): boolean; override;
   procedure dopaint(const acanvas: tcanvas); override;
  public
   constructor create(const acontroller: tdbdropdownlistcontroller;
                             acols: tdropdowncols);
   destructor destroy; override;
   procedure rowup(const action: focuscellactionty = fca_focusin); override;
   procedure rowdown(const action: focuscellactionty = fca_focusin); override;
   procedure pageup(const action: focuscellactionty = fca_focusin); override;
   procedure pagedown(const action: focuscellactionty = fca_focusin); override;
   procedure wheelup(const action: focuscellactionty = fca_focusin); override;
   procedure wheeldown(const action: focuscellactionty = fca_focusin);  override;
 end;

 idbdropdownlist = interface(idropdownlist)
  procedure recordselected(const arecordnum: integer; const akey: keyty);
                     //-2 = empty row, -1 = none
 end;

const
 defaultdbdropdownoptions = [deo_selectonly,deo_autodropdown,deo_keydropdown];   
 defaultdropdowndatalinkoptions = [gdo_propscrollbar,gdo_thumbtrack];

type 
 optiondbty = (odb_copyitems);
 optionsdbty = set of optiondbty;
 
 tdbdropdownlistcontroller = class(tcustomdropdownlistcontroller,idbeditinfo)
  private
   fdatalink: tdropdowndatalink;
   fisstringkey: boolean;
   foptionsdatalink: griddatalinkoptionsty;
   foptionsdb: optionsdbty;
   fbookmarks: stringarty;
   function getdatasource: tdatasource; overload;
   function getdatasource(const aindex: integer): tdatasource; overload;
   procedure setdatasource(const avalue: tdatasource); overload;
   procedure setkeyfield(const avalue: string);
   function getkeyfield: string;
   function getcols: tdbdropdowncols;
   procedure setcols(const avalue: tdbdropdowncols);
  protected
   procedure valuecolchanged; override;
   function getbuttonframeclass: dropdownbuttonframeclassty; override;
   function getdropdowncolsclass: dropdowncolsclassty; override;
   function  createdropdownlist: tdropdownlist; override;
   function candropdown: boolean; override;
   procedure itemselected(const index: integer; const akey: keyty); override;
   //idbeditinfo
   procedure getfieldtypes(out propertynames: stringarty;
                          out fieldtypes: fieldtypesarty);
  public
   constructor create(const intf: idbdropdownlist; const aisstringkey: boolean);
   destructor destroy; override;
  published
   property datasource: tdatasource read getdatasource write setdatasource;
   property keyfield: string read getkeyfield write setkeyfield;
   property options default defaultdbdropdownoptions;
   property optionsdatalink: griddatalinkoptionsty read foptionsdatalink 
           write foptionsdatalink default defaultdropdowndatalinkoptions;
   property optionsdb: optionsdbty read foptionsdb write foptionsdb default [];
   
   property cols: tdbdropdowncols read getcols write setcols;
   property dropdownrowcount;
   property valuecol;
   property width;
   property datarowlinewidth;
   property datarowlinecolor;
   property buttonlength;
   property buttonminlength;
  end;

 tdbenumeditdb = class(tdbenumedit,idbdropdownlist,idbeditinfo,ireccontrol)
  private
   function getdropdown: tdbdropdownlistcontroller;
   procedure setdropdown(const avalue: tdbdropdownlistcontroller);
  protected
   function createdropdowncontroller: tcustomdropdowncontroller; override;
   procedure recordselected(const arecordnum: integer; const akey: keyty);
   function internaldatatotext(const data): msestring; override;
  published
   property dropdown: tdbdropdownlistcontroller read getdropdown write setdropdown;
 end;
 
 tenumeditdb = class(tenumedit,idbdropdownlist)
  private
   function getdropdown: tdbdropdownlistcontroller;
   procedure setdropdown(const avalue: tdbdropdownlistcontroller);
  protected
   function createdropdowncontroller: tcustomdropdowncontroller; override;
   procedure recordselected(const arecordnum: integer; const akey: keyty);
   function internaldatatotext(const data): msestring; override;
  published
   property dropdown: tdbdropdownlistcontroller read getdropdown write setdropdown;
 end;
 
 tdbkeystringeditdb = class(tdbkeystringedit,idbdropdownlist,idbeditinfo,ireccontrol)
  private
   fkeyvalue: msestring;
   function getdropdown: tdbdropdownlistcontroller;
   procedure setdropdown(const avalue: tdbdropdownlistcontroller);
  protected
   function createdropdowncontroller: tcustomdropdowncontroller; override;
   procedure recordselected(const arecordnum: integer; const akey: keyty);
   function internaldatatotext(const data): msestring; override;
  published
   property dropdown: tdbdropdownlistcontroller read getdropdown write setdropdown;
 end;
 
 tkeystringeditdb = class(tkeystringedit,idbdropdownlist)
  private
   function getdropdown: tdbdropdownlistcontroller;
   procedure setdropdown(const avalue: tdbdropdownlistcontroller);
  protected
   function createdropdowncontroller: tcustomdropdowncontroller; override;
   procedure recordselected(const arecordnum: integer; const akey: keyty);
   function internaldatatotext(const data): msestring; override;
  published
   property dropdown: tdbdropdownlistcontroller read getdropdown write setdropdown;
 end;

 tdbwidgetindicatorcol = class(twidgetfixcol)
  private
   fcolorindicator: colorty;
   procedure setcolorindicator(const avalue: colorty);
  protected
   procedure drawcell(const canvas: tcanvas); override;
  public
   constructor create(const agrid: tcustomgrid;
                       const aowner: tgridarrayprop); override;
  published
   property colorindicator: colorty read fcolorindicator 
                   write setcolorindicator default cl_glyph;
 end;

 tdbwidgetfixcols = class(twidgetfixcols)
  private
   fdbindicatorcol: integer;
   fdatalink: tgriddatalink;
   procedure setdbindicatorcol(const Value: integer);
   function getdbindicatorcol: integer;
  protected
   procedure createitem(const index: integer; var item: tpersistent); override;
   procedure setcount1(acount: integer; doinit: boolean); override;
  public
   constructor create(const aowner: tcustomwidgetgrid;
                       const adatalink: tgriddatalink);
  published
   property dbindicatorcol: integer read getdbindicatorcol 
                    write setdbindicatorcol default -1;
 end;

const
 defaultdbscrollbaroptions = 
    (defaultthumbtrackscrollbaroptions - [sbo_showauto])+ 
             [sbo_show,sbo_thumbtrack];
 
type
 tdbscrollbar = class(tthumbtrackscrollbar)
  protected
   procedure setoptions(const avalue: scrollbaroptionsty); override;
  public
   constructor create(intf: iscrollbar; org: originty = org_client;
              ondimchanged: objectprocty = nil); override;
  published
   property options default defaultdbscrollbaroptions;
   property buttonlength default -1;
 end;
 
 tdbgridframe = class(tgridframe)
  protected
   function getscrollbarclass(vert: boolean): framescrollbarclassty; override;
   procedure scrollevent(sender: tcustomscrollbar; event: scrolleventty); override;
  public
   constructor create(const intf: iscrollframe; const owner: twidget;
                             const autoscrollintf: iautoscrollframe);
 end;
 
 tcustomdbwidgetgrid = class(tcustomwidgetgrid,igriddatalink)
  private
   fdatalink: tgriddatalink;
   function getdatasource: tdatasource;
   procedure setdatasource(const Value: tdatasource);
   procedure setdatalink(const avalue: tgriddatalink);
   function getfixcols: tdbwidgetfixcols;
   procedure setfixcols(const avalue: tdbwidgetfixcols);
  protected
   function getdbindicatorcol: integer;
   function getgriddatalink: pointer; override;
   procedure setoptionsgrid(const avalue: optionsgridty); override;
   procedure internalcreateframe; override;
   function createfixcols: tfixcols; override;
   procedure updatelayout; override;
   procedure initcellinfo(var info: cellinfoty); override;
   procedure docellevent(var info: celleventinfoty); override;
   procedure scrollevent(sender: tcustomscrollbar; event: scrolleventty); override;
   function getzebrastart: integer; override;
   function getnumoffset: integer; override;
   procedure dopaint(const acanvas: tcanvas); override;
   procedure loaded; override;

   procedure doinsertrow(const sender: tobject); override;
   procedure doappendrow(const sender: tobject); override;
   procedure dodeleterow(const sender: tobject); override;
   procedure beforefocuscell(const cell: gridcoordty;
                             const selectaction: focuscellactionty); override;
   function focuscell(cell: gridcoordty;
           selectaction: focuscellactionty = fca_focusin;
         const selectmode: selectcellmodety = scm_cell;
         const noshowcell: boolean = false): boolean; override;
                                 //true if ok
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   function canclose(const newfocus: twidget): boolean; override;
   procedure rowup(const action: focuscellactionty = fca_focusin); override;
   procedure rowdown(const action: focuscellactionty = fca_focusin); override;
   procedure pageup(const action: focuscellactionty = fca_focusin); override;
   procedure pagedown(const action: focuscellactionty = fca_focusin); override;
   procedure wheelup(const action: focuscellactionty = fca_focusin); override;
   procedure wheeldown(const action: focuscellactionty = fca_focusin);  override;
   procedure lastrow(const action: focuscellactionty = fca_focusin); override;
   procedure firstrow(const action: focuscellactionty = fca_focusin); override;
   property datasource: tdatasource read getdatasource write setdatasource;
   property datalink: tgriddatalink read fdatalink write setdatalink;
   property zebra_step default 0;
   property fixcols: tdbwidgetfixcols read getfixcols write setfixcols;
 end;

 tdbwidgetgrid = class(tcustomdbwidgetgrid)
  published
   property datasource;
   property optionsgrid;
   property fixcols;
   property fixrows;
   property font;
   property gridframecolor;
   property gridframewidth;
   property rowcolors;
   property rowfonts;
   property zebra_color;
   property zebra_start;
   property zebra_height;
   property zebra_step;
   property datacols;
   property datalink;

   property datarowlinewidth;
   property datarowlinecolorfix;
   property datarowlinecolor;
   property datarowheight;

   property statfile;
   property statvarname;

   property onlayoutchanged;
   property onrowcountchanged;
   property onrowdatachanged;
   property onrowsdatachanged;
   property onrowsmoved;
   property onrowsinserting;
   property onrowsinserted;
   property onrowsdeleting;
   property onrowsdeleted;
   property oncellevent;
   property onsortchanged;
   property drag;
 end;

 tstringcoldatalink = class(teditwidgetdatalink)
  private
   fowner: tcustomstringcol;
  protected
   procedure updatedata; override;
   procedure layoutchanged; override;
 end;
 
 tdbstringcol = class(tcustomstringcol,idbeditfieldlink,idbeditinfo)
  private
   fdatalink: tstringcoldatalink;
   function getdatafield: string;
   procedure setdatafield(const avalue: string);
          //idbeditinfo
   procedure getfieldtypes(out propertynames: stringarty;
                          out fieldtypes: fieldtypesarty);
   function getdatasource(const aindex: integer): tdatasource;
  protected
   function getitems(aindex: integer): msestring; override;
   procedure modified; override;
   function getrowtext(const arow: integer): msestring; override;
          //idbeditfieldlink
   function getgriddatasource: tdatasource; virtual;
   function getgridintf: iwidgetgrid;
   function getwidget: twidget;
   function seteditfocus: boolean;
   function edited: boolean;
   procedure initeditfocus;
   function checkvalue(const quiet: boolean = false): boolean;
   procedure valuetofield;
   procedure fieldtovalue;
   procedure setnullvalue;
   procedure updatereadonlystate;
  public
   constructor create(const agrid: tcustomgrid; 
                         const aowner: tgridarrayprop); override;
   destructor destroy; override;
   property datalink: tstringcoldatalink read fdatalink;
  published
   property datafield: string read getdatafield write setdatafield;
   property optionsdb: optionseditdbty read foptionsdb write foptionsdb;
   property focusrectdist;
   property textflags;
   property textflagsactive;
   property optionsedit;
   property font;
   property colorselect;
   property fontselect;
   property onsetvalue;
   property ondataentered;
  end;

 tdbstringcols = class(tstringcols)
  private
   foptionsdb: optionseditdbty;
   function getcols(const index: integer): tdbstringcol;
   procedure setoptionsdb(const avalue: optionseditdbty);
  protected
   function getcolclass: stringcolclassty; override;
   procedure datasourcechanged;
  public
   class function getitemclasstype: persistentclassty; override;
   property cols[const index: integer]: tdbstringcol read getcols; default; //last!
  published
   property optionsdb: optionseditdbty read foptionsdb write setoptionsdb default [];
 end;
 
 tdbstringindicatorcol = class(tfixcol)
  private
   fcolorindicator: colorty;
   procedure setcolorindicator(const avalue: colorty);
  protected
   procedure drawcell(const canvas: tcanvas); override;
  public
   constructor create(const agrid: tcustomgrid;
                       const aowner: tgridarrayprop); override;
  published
   property colorindicator: colorty read fcolorindicator 
                write setcolorindicator default cl_glyph;
 end;

 tdbstringfixcols = class(tfixcols)
  private
   fdbindicatorcol: integer;
   fdatalink: tgriddatalink;
   procedure setdbindicatorcol(const Value: integer);
   function getdbindicatorcol: integer;
  protected
   procedure createitem(const index: integer; var item: tpersistent); override;
   procedure setcount1(acount: integer; doinit: boolean); override;
  public
   constructor create(const aowner: tcustomgrid;
                       const adatalink: tgriddatalink);
  published
   property dbindicatorcol: integer read getdbindicatorcol 
                                 write setdbindicatorcol default -1;
 end;

 dbstringgridoptionty = (dsgo_autofields);
 dbstringgridoptionsty = set of dbstringgridoptionty;

 tstringgriddatalink =  class(tgriddatalink)
  protected
   procedure activechanged; override;
 end;

const
 maxautodisplaywidth = 20;
 
type
 tcustomdbstringgrid = class(tcustomstringgrid,iwidgetgrid,igriddatalink)
  private
   fdatalink: tstringgriddatalink;
   foptions: dbstringgridoptionsty;
   ffieldnamedisplayfixrow: integer;
   function getdatasource: tdatasource;
   procedure setdatasource(const Value: tdatasource);
   function getdatacols: tdbstringcols;
   procedure setdatacols(const avalue: tdbstringcols);
      //iwidgetgrid (dummy)
   function getbrushorigin: pointty;
   function getcol: twidgetcol;
   procedure getdata(index: integer; var dest);
   procedure setdata(index: integer; const source; const noinvalidate: boolean = false);
   function getrow: integer;
   procedure setrow(arow: integer);
   procedure changed;
   function empty(index: integer): boolean;
   procedure updateeditoptions(var aoptions: optionseditty);
   procedure showrect(const arect: rectty; const aframe: tcustomframe);
   procedure widgetpainted(const canvas: tcanvas);
   function nullcheckneeded(const newfocus: twidget): boolean;
   function nonullcheck: boolean;
   function getgrid: tcustomwidgetgrid;
   
   procedure setoptions(const avalue: dbstringgridoptionsty);
   procedure checkautofields;
   procedure setfieldnamedisplayfixrow(const avalue: integer);
   procedure setdatalink(const avalue: tstringgriddatalink);
   function getfixcols: tdbstringfixcols;
   procedure setfixcols(const avalue: tdbstringfixcols);
  protected
   function getdbindicatorcol: integer;
   procedure updatelayout; override;
   procedure editnotification(var info: editnotificationinfoty); override;
   procedure setoptionsgrid(const avalue: optionsgridty); override;
   procedure doasyncevent(var atag: integer); override;
   procedure internalcreateframe; override;
   function getoptionsedit: optionseditty; override;
   function createfixcols: tfixcols; override;
   function createdatacols: tdatacols; override;
   procedure initcellinfo(var info: cellinfoty); override;
   function focuscell(cell: gridcoordty;
           selectaction: focuscellactionty = fca_focusin;
         const selectmode: selectcellmodety = scm_cell;
         const noshowcell: boolean = false): boolean; override;
                                 //true if ok
   procedure docellevent(var info: celleventinfoty); override;
   procedure scrollevent(sender: tcustomscrollbar; event: scrolleventty); override;
   function getzebrastart: integer; override;
   function getnumoffset: integer; override;
   procedure checkcellvalue(var accept: boolean); override;
   procedure dopaint(const acanvas: tcanvas); override;
   procedure loaded; override;
   function cangridcopy: boolean;

   procedure doinsertrow(const sender: tobject); override;
   procedure doappendrow(const sender: tobject); override;
   procedure dodeleterow(const sender: tobject); override;
   procedure beforefocuscell(const cell: gridcoordty;
                             const selectaction: focuscellactionty); override;
   procedure coloptionstoeditoptions(var dest: optionseditty);

  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   function canclose(const newfocus: twidget): boolean; override;
   procedure rowup(const action: focuscellactionty = fca_focusin); override;
   procedure rowdown(const action: focuscellactionty = fca_focusin); override;
   procedure pageup(const action: focuscellactionty = fca_focusin); override;
   procedure pagedown(const action: focuscellactionty = fca_focusin); override;
   procedure wheelup(const action: focuscellactionty = fca_focusin); override;
   procedure wheeldown(const action: focuscellactionty = fca_focusin); override;
   procedure lastrow(const action: focuscellactionty = fca_focusin); override;
   procedure firstrow(const action: focuscellactionty = fca_focusin); override;
   property datasource: tdatasource read getdatasource write setdatasource;
   property datacols: tdbstringcols read getdatacols write setdatacols;
   property datalink: tstringgriddatalink read fdatalink write setdatalink;
   property options: dbstringgridoptionsty read foptions 
                           write setoptions default [];
   property fieldnamedisplayfixrow: integer read ffieldnamedisplayfixrow write
                    setfieldnamedisplayfixrow default -1; 
                    //negative rowindex, 0-> none
   property zebra_step default 0;
   property fixcols: tdbstringfixcols read getfixcols write setfixcols;
 end;
 
 tdbstringgrid = class(tcustomdbstringgrid)
  published
   property datasource;
   property options;
   property fieldnamedisplayfixrow;
   
   property optionsgrid;
   property datacols;
   property datalink;
   property fixcols;
   property fixrows;
   property gridframecolor;
   property gridframewidth;
   property rowcolors;
   property rowfonts;
   property zebra_color;
   property zebra_start;
   property zebra_height;
   property zebra_step;

   property datarowlinewidth;
   property datarowlinecolorfix;
   property datarowlinecolor;
   property datarowheight;
   property caretwidth;

   property statfile;
   property statvarname;

   property onlayoutchanged;
   property onrowsmoved;
   property onrowsdatachanged;
   property onrowdatachanged;
   property onrowsinserting;
   property onrowsinserted;
   property onrowsdeleting;
   property onrowsdeleted;
   property onrowcountchanged;
   property oncellevent;
   property onsortchanged;
   property drag;
 end;

 tlbdropdownlistcontroller = class;

 tlbdropdownstringcol = class(tdropdownstringcol)
  private
   flookupbuffer: tcustomlookupbuffer;
   ffieldno: integer;
   fsortfieldno: integer;
  protected
   function getrowtext(const arow: integer): msestring; override;
  public
 end;

 tcopydropdownlist = class(tdropdownlist)
  private
  protected
   function locate(const filter: msestring): boolean; override;
 end;
 
 lbdstatety = (lbds_filtered,lbds_bof,lbds_eof);
 lbdstatesty = set of lbdstatety;
 
 tlbdropdownlist = class(tdropdownlist)
  private
   ffirstrecord: integer;
   frecnums: integerarty;
   fsortfieldno: integer;
   flbdstate: lbdstatesty;
   function getactiverecord: integer;
   procedure setactiverecord(const avalue: integer);
  protected
   procedure dokeydown(var info: keyeventinfoty); override;
   procedure findprev(var recno: integer);
   procedure findnext(var recno: integer);
   function getrecno(const aindex: integer): integer;
   procedure dorowcountchanged(const countbefore,newcount: integer); override;
   procedure internalcreateframe; override;
   procedure createdatacol(const index: integer; out item: tdatacol); override;
   procedure initcols(const acols: tdropdowncols); override;
   procedure docellevent(var info: celleventinfoty); override;
   procedure scrollevent(sender: tcustomscrollbar; event: scrolleventty); override;
   function locate(const filter: msestring): boolean; override;
   procedure dbscrolled(distance: integer);
   procedure moveby(distance: integer);
   property activerecord: integer read getactiverecord write setactiverecord;
  public
   constructor create(const acontroller: tlbdropdownlistcontroller;
                             acols: tdropdowncols);
   procedure rowup(const action: focuscellactionty = fca_focusin); override;
   procedure rowdown(const action: focuscellactionty = fca_focusin); override;
   procedure pageup(const action: focuscellactionty = fca_focusin); override;
   procedure pagedown(const action: focuscellactionty = fca_focusin); override;
   procedure wheelup(const action: focuscellactionty = fca_focusin); override;
   procedure wheeldown(const action: focuscellactionty = fca_focusin);  override;
 end;
  
 ilbdropdownlist = interface(idropdownlist)
  procedure recordselected(const arecordnum: integer; const akey: keyty);
                     //-2 = empty row, -1 = none
 end;
   
 tlbdropdowncol = class(tdropdowncol)
  private
   ffieldno: integer;
   procedure setfieldno(const avalue: integer);
  published
   property fieldno: integer read ffieldno write setfieldno default 0;
                    //colindex in lookupbuffer
 end;
 
 tlbdropdowncols = class(tnolistdropdowncols)
  private
   function getitems(const index: integer): tlbdropdowncol;
  protected
   function getcolclass: dropdowncolclassty; override;
  public
   property items[const index: integer]: tlbdropdowncol read getitems; default;
 end;

const
 defaultlbdropdownoptions = [deo_selectonly,deo_autodropdown,deo_keydropdown];
 
type

 optionlbty = (olb_copyitems);
 optionslbty = set of optionlbty;
                                   
 tlbdropdownlistcontroller = class(tcustomdropdownlistcontroller)
  private
   flookupbuffer: tcustomlookupbuffer;
   fkeyfieldno: integer;
   fonfilter: lbfiltereventty;
   foptionslb: optionslbty;
   flbrecnums: integerarty;
   procedure setlookupbuffer(const avalue: tcustomlookupbuffer);
   function getcols: tlbdropdowncols;
   procedure setcols(const avalue: tlbdropdowncols);
  protected
   procedure valuecolchanged; override;
   function getbuttonframeclass: dropdownbuttonframeclassty; override;
   function getdropdowncolsclass: dropdowncolsclassty; override;
   function createdropdownlist: tdropdownlist; override;
   function candropdown: boolean; override;
   procedure itemselected(const index: integer; const akey: keyty); override;
   procedure objectevent(const sender: tobject; const event: objecteventty); override;
  public
   constructor create(const intf: ilbdropdownlist);
   procedure dropdown; override;
  published
   property lookupbuffer: tcustomlookupbuffer read flookupbuffer write setlookupbuffer;
   property keyfieldno: integer read fkeyfieldno write fkeyfieldno;
   property optionslb: optionslbty read foptionslb write foptionslb default [];
   property options default defaultlbdropdownoptions;
   property cols: tlbdropdowncols read getcols write setcols;
   property dropdownrowcount;
   property valuecol;
   property width;
   property datarowlinewidth;
   property datarowlinecolor;
   property buttonlength;
   property buttonminlength;
   property onfilter: lbfiltereventty read fonfilter write fonfilter;
 end;
 
 tdbenumeditlb = class(tdbenumedit,ilbdropdownlist)
  private
   function getdropdown: tlbdropdownlistcontroller;
   procedure setdropdown(const avalue: tlbdropdownlistcontroller);
  protected
   function createdropdowncontroller: tcustomdropdowncontroller; override;
   function internaldatatotext(const data): msestring; override;
          //ilbdropdownlist
   procedure recordselected(const arecordnum: integer; const akey: keyty);
  published
   property dropdown: tlbdropdownlistcontroller read getdropdown write setdropdown;
 end;

 tenumeditlb = class(tenumedit,ilbdropdownlist)
  private
   function getdropdown: tlbdropdownlistcontroller;
   procedure setdropdown(const avalue: tlbdropdownlistcontroller);
  protected
   function createdropdowncontroller: tcustomdropdowncontroller; override;
   function internaldatatotext(const data): msestring; override;
          //ilbdropdownlist
   procedure recordselected(const arecordnum: integer; const akey: keyty);
  public
  published
   property dropdown: tlbdropdownlistcontroller read getdropdown write setdropdown;
 end;

 tcustomenum64edit = class(tcustomdropdownlistedit)
  private
   function getgridvalue(const index: integer): int64;
   procedure setgridvalue(const index: integer; aValue: int64);
   function getgridvalues: int64arty;
   procedure setgridvalues(const avalue: int64arty);
   procedure setvalue(const avalue: int64);
   fonsetvalue1: setint64eventty;
  protected
   fvalue1: int64;
   fvaluedefault: int64;
   
   function getdefaultvalue: pointer; override;
   procedure texttovalue(var accept: boolean; const quiet: boolean); override;
   procedure texttodata(const atext: msestring; var data); override;
   procedure valuetogrid(const arow: integer); override;
   procedure gridtovalue(const arow: integer); override;
   procedure readstatvalue(const reader: tstatreader); override;
   procedure writestatvalue(const writer: tstatwriter); override;

   function createdatalist(const sender: twidgetcol): tdatalist; override;
   function getdatatyp: datatypty; override;

  public
   constructor create(aowner: tcomponent); override;
   property gridvalue[const index: integer]: int64
        read getgridvalue write setgridvalue; default;
   property gridvalues: int64arty read getgridvalues write setgridvalues;
   property value: int64 read fvalue1 write setvalue default -1;
   property valuedefault: int64 read fvaluedefault write fvaluedefault default -1;
   property onsetvalue: setint64eventty read fonsetvalue1 write fonsetvalue1;
 end;

 tcustomenum64editlb = class(tcustomenum64edit,ilbdropdownlist)
  private
   function getdropdown: tlbdropdownlistcontroller;
   procedure setdropdown(const avalue: tlbdropdownlistcontroller);
  protected
   function createdropdowncontroller: tcustomdropdowncontroller; override;
   function internaldatatotext(const data): msestring; override;
          //ilbdropdownlist
   procedure recordselected(const arecordnum: integer; const akey: keyty);
  public
   property dropdown: tlbdropdownlistcontroller read getdropdown write setdropdown;
 end;

 tenum64editlb = class(tcustomenum64editlb)
  published
   property dropdown;
   property value;
   property valuedefault;
   property onsetvalue;
 end;
 
 tdbenum64editlb = class(tcustomenum64editlb,idbeditfieldlink,idbeditinfo,ireccontrol)
  private
   fdatalink: teditwidgetdatalink;
   function getdatafield: string;
   procedure setdatafield(const avalue: string);
   function getdatasource: tdatasource; overload;
   function getdatasource(const aindex: integer): tdatasource; overload;
   procedure setdatasource(const avalue: tdatasource);
  protected

   function nullcheckneeded(const newfocus: twidget): boolean; override;
   procedure griddatasourcechanged; override;
   function getgriddatasource: tdatasource;
   function createdatalist(const sender: twidgetcol): tdatalist; override;
   procedure modified; override;
   function getoptionsedit: optionseditty; override;
   procedure dochange; override;

   function getrowdatapo(const info: cellinfoty): pointer; override;
   //idbeditfieldlink
   procedure valuetofield; virtual;
   procedure fieldtovalue; virtual;
   //idbeditinfo
   procedure getfieldtypes(out propertynames: stringarty;
                          out fieldtypes: fieldtypesarty); virtual;
   //ireccontrol
   procedure recchanged;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   property datalink: teditwidgetdatalink read fdatalink;
  published
   property datafield: string read getdatafield write setdatafield;
   property datasource: tdatasource read getdatasource write setdatasource;
   property dropdown;
   property onsetvalue;
 end;
 
 tcustomenum64editdb = class(tcustomenum64edit,idbdropdownlist)
  private
   function getdropdown: tdbdropdownlistcontroller;
   procedure setdropdown(const avalue: tdbdropdownlistcontroller);
  protected
   function createdropdowncontroller: tcustomdropdowncontroller; override;
   function internaldatatotext(const data): msestring; override;
          //ilbdropdownlist
   procedure recordselected(const arecordnum: integer; const akey: keyty);
  public
   property dropdown: tdbdropdownlistcontroller read getdropdown write setdropdown;
 end;

 tenum64editdb = class(tcustomenum64editdb)
  published
   property dropdown;
   property value;
   property valuedefault;
   property onsetvalue;
 end;
 
 tdbenum64editdb = class(tcustomenum64editdb,idbeditfieldlink,idbeditinfo,ireccontrol)
  private
   fdatalink: teditwidgetdatalink;
   function getdatafield: string;
   procedure setdatafield(const avalue: string);
   function getdatasource: tdatasource; overload;
   function getdatasource(const aindex: integer): tdatasource; overload;
   procedure setdatasource(const avalue: tdatasource);
  protected

   function nullcheckneeded(const newfocus: twidget): boolean; override;
   procedure griddatasourcechanged; override;
   function getgriddatasource: tdatasource;
   function createdatalist(const sender: twidgetcol): tdatalist; override;
   procedure modified; override;
   function getoptionsedit: optionseditty; override;
   procedure dochange; override;

   function getrowdatapo(const info: cellinfoty): pointer; override;
   //idbeditfieldlink
   procedure valuetofield; virtual;
   procedure fieldtovalue; virtual;
   //idbeditinfo
   procedure getfieldtypes(out propertynames: stringarty;
                          out fieldtypes: fieldtypesarty); virtual;
   //ireccontrol
   procedure recchanged;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   property datalink: teditwidgetdatalink read fdatalink;
  published
   property datafield: string read getdatafield write setdatafield;
   property datasource: tdatasource read getdatasource write setdatasource;
   property dropdown;
   property onsetvalue;
 end;
 
 tdbkeystringeditlb = class(tdbkeystringedit,ilbdropdownlist)
  private
   function getdropdown: tlbdropdownlistcontroller;
   procedure setdropdown(const avalue: tlbdropdownlistcontroller);
  protected
   function createdropdowncontroller: tcustomdropdowncontroller; override;
   function internaldatatotext(const data): msestring; override;
          //ilbdropdownlist
   procedure recordselected(const arecordnum: integer; const akey: keyty);
  published
   property dropdown: tlbdropdownlistcontroller read getdropdown write setdropdown;
 end;
 
 tkeystringeditlb = class(tkeystringedit,ilbdropdownlist)
  private
   function getdropdown: tlbdropdownlistcontroller;
   procedure setdropdown(const avalue: tlbdropdownlistcontroller);
  protected
   function createdropdowncontroller: tcustomdropdowncontroller; override;
   function internaldatatotext(const data): msestring; override;
          //ilbdropdownlist
   procedure recordselected(const arecordnum: integer; const akey: keyty);
  published
   property dropdown: tlbdropdownlistcontroller read getdropdown write setdropdown;
 end;

function encoderowstate(const color: integer = -1; const font: integer = -1;
                            const readonly: boolean = false): integer;
                            
implementation
uses
 msestockobjects,mseshapes,msereal,msebits,
 mseactions,mseact,rtlconsts,msedrawtext,sysutils;

type
 tcomponent1 = class(tcomponent);
 twidget1 = class(twidget);
 tcustomgrid1 = class(tcustomgrid);
 tdropdowncols1 = class(tdropdowncols);
 tdataedit1 = class(tdataedit);
 tdataset1 = class(tdataset);
 tdatasource1 = class(tdatasource);
 ttoolbuttons1 = class(ttoolbuttons);

function encoderowstate(const color: integer = -1; const font: integer = -1;
                            const readonly: boolean = false): integer;
begin
 result:= (color and $7f) or ((font and $7f) shl 8);
 if readonly then begin
  result:= result or $80;
 end;
end;

procedure drawindicatorcell(const canvas: tcanvas; const datalink: tgriddatalink;
                             const acolor: colorty);
var
 glyph: stockglyphty;
begin
 with cellinfoty(canvas.drawinfopo^) do begin
  with datalink do begin
//   if active and (cell.row = activerecord) then begin
    case dataset.state of
     dsbrowse: glyph:= stg_dbindbrowse;
     dsedit: glyph:= stg_dbindedit;
     dsinsert: glyph:= stg_dbindinsert;
     else glyph:= stockglyphty(-1);
    end;
    if ord(glyph) >= 0 then begin
     stockobjects.glyphs.paint(canvas,ord(glyph),innerrect,
            [al_xcentered,al_ycentered],acolor);
    end;
//   end;
  end;
 end;
end;

function confirmdeleterecord: boolean;
begin
 with stockobjects do begin
  result:= askok(captions[sc_Delete_record],captions[sc_confirmation])
 end;
end;

{ tnavigdatalink }

constructor tnavigdatalink.Create(const intf: idbnaviglink);
begin
 fintf:= intf;
 inherited create;
 visualcontrol:= true;
 fintf.setactivebuttons([],false);
end;

procedure tnavigdatalink.updatebuttonstate;
var
 bu1: dbnavigbuttonsty;
 bo1: boolean;
begin
 bu1:= [];
 bo1:= false;
 if active then begin
  bu1:= [dbnb_first,dbnb_prior,dbnb_next,dbnb_last]+
                 filterdbnavigbuttons;
  if bof then begin
   bu1:= bu1 - [dbnb_first,dbnb_prior];
  end;
  if eof then begin
   bu1:= bu1 - [dbnb_next,dbnb_last];
  end;
  case datasource.state of
   dsfilter: begin
    case filtereditkind of
     fek_filter: bu1:= [dbnb_filter];
     fek_filtermin: bu1:= [dbnb_filtermin];
     fek_filtermax: bu1:= [dbnb_filtermax];
     fek_find: bu1:= [dbnb_find];
    end;
   end;
   dsedit,dsinsert: begin
    bu1:= bu1 + [dbnb_post,dbnb_cancel,dbnb_refresh,dbnb_insert,dbnb_delete];
   end;
   else begin
    bu1:= bu1 + [dbnb_refresh,dbnb_insert,dbnb_delete,dbnb_edit,
                 dbnb_filteronoff];
   end;
  end;
  if bof and eof then begin
   bu1:= bu1 - [dbnb_delete];
  end;
  if not datasource.dataset.canmodify then begin
   bu1:= bu1 - [dbnb_edit,dbnb_delete,dbnb_insert];
  end;
  if csdesigning in dataset.componentstate then begin
   bu1:= bu1 * designdbnavigbuttons;
  end;
  bo1:= datasource.dataset.filtered;
 end;
 fintf.setactivebuttons(bu1,bo1);
end;
 
procedure tnavigdatalink.activechanged;
var
 intf1: igetdscontroller;
begin
 fdscontroller:= nil;
 if active then begin
  if getcorbainterface(dataset,typeinfo(igetdscontroller),intf1) then begin
   fdscontroller:= intf1.getcontroller;
  end;
 end;
 inherited;
 updatebuttonstate;
end;

procedure tnavigdatalink.datasetchanged;
begin
 inherited;
 updatebuttonstate;
end;

procedure tnavigdatalink.editingchanged;
begin
 inherited;
 updatebuttonstate;
end;

procedure tnavigdatalink.recordchanged(field: tfield);
begin
 inherited;
 updatebuttonstate;
end;

procedure tnavigdatalink.execbutton(const abutton: dbnavigbuttonty);
var
 widget1: twidget;
begin
 if (datasource <> nil) and (datasource.State <> dsinactive) then begin
  if not (abutton in [dbnb_cancel,dbnb_delete]) then begin
   widget1:= fintf.getwidget;
   if (widget1.parentwidget <> nil) and
           not widget1.parentwidget.canparentclose then begin
    exit;
   end;
  end;
  with datasource.dataset do begin
   case abutton of
    dbnb_first: first;
    dbnb_prior: self.moveby(-1);
    dbnb_next: self.moveby(1);
    dbnb_last: last;
    dbnb_insert: begin
     if dno_append in fintf.getnavigoptions then begin
      append;
     end
     else begin
      insert;
     end;
    end;
    dbnb_delete: begin
     if not (dno_confirmdelete in fintf.getnavigoptions) or 
                        confirmdeleterecord then begin
      delete;
     end;
    end;
    dbnb_edit: edit;
    dbnb_post: post;
    dbnb_cancel: cancel;
    dbnb_refresh: refresh;
    dbnb_filteronoff: filtered:= not filtered;
   end;
   if fdscontroller <> nil then begin
    if state = dsfilter then begin
     fdscontroller.endfilteredit;
    end
    else begin
     case abutton of
      dbnb_filter: fdscontroller.beginfilteredit(fek_filter);
      dbnb_filtermin: fdscontroller.beginfilteredit(fek_filtermin);
      dbnb_filtermax: fdscontroller.beginfilteredit(fek_filtermax);
      dbnb_find: fdscontroller.beginfilteredit(fek_find);
     end;
    end;
   end;
  end;
 end;
end;

{ tdbnavigator }

constructor tdbnavigator.create(aowner: tcomponent);
var
 int1: integer;
begin
 foptions:= defaultdbnavigatoroptions;
// fvisiblebuttons:= defaultvisibledbnavigbuttons;
 fshortcuts[dbnb_first]:= key_modctrl + ord(key_pageup);
 fshortcuts[dbnb_prior]:= ord(key_pageup);
 fshortcuts[dbnb_next]:= ord(key_pagedown);
 fshortcuts[dbnb_last]:= key_modctrl + ord(key_pagedown);
 fshortcuts[dbnb_edit]:= ord(key_f2);
 inherited;
 include(fwidgetstate1,ws1_designactive);
 size:= makesize(defaultdbnavigatorwidth,defaultdbnavigatorheight);
 include(ttoolbuttons1(buttons).fbuttonstate,tbs_nocandefocus);
 buttons.count:= ord(high(dbnavigbuttonty))+1;
 for int1:= 0 to ord(high(dbnavigbuttonty)) do begin
  with buttons[int1] do begin
   imagelist:= stockobjects.glyphs;
   imagenr:= int1 + ord(stg_dbfirst);
   tag:= int1;
   onexecute:= {$ifdef FPC}@{$endif}doexecute;
  end;
 end;
 fdatalink:= tnavigdatalink.Create(idbnaviglink(self));
 visiblebuttons:= defaultvisibledbnavigbuttons;
end;

destructor tdbnavigator.destroy;
begin
 inherited;
 fdatalink.Free;
end;

procedure tdbnavigator.inithints;
var
 int1: integer;
begin
 for int1:= 0 to ord(high(dbnavigbuttonty)) do begin
  with buttons[int1] do begin
   hint:= stockobjects.captions[stockcaptionty(int1+ord(sc_first))];
   if (dno_shortcuthint in foptions) and 
             (fshortcuts[dbnavigbuttonty(int1)] <> 0) then begin
    hint:= hint + ' (' + 
                  encodeshortcutname(fshortcuts[dbnavigbuttonty(int1)])+')';
   end;
  end;
 end;
end;

procedure tdbnavigator.doasyncevent(var atag: integer);
begin
 if atag = 0 then begin
  application.mouseparkevent;
 end
 else begin
  inherited;
 end;
end;

procedure tdbnavigator.setactivebuttons(const abuttons: dbnavigbuttonsty;
                                        const afiltered: boolean);
var
 bu1: dbnavigbuttonty;
begin
 beginupdate;
 try
  with buttons[ord(dbnb_filteronoff)] do begin
   if afiltered then begin
    imagenr:= ord(stg_dbfilteroff);
    hint:= stockobjects.captions[sc_filter_off];
   end
   else begin
    imagenr:= ord(stg_dbfilteron);
    hint:= stockobjects.captions[sc_filter_on];
   end;
  end;
  for bu1:= low(dbnavigbuttonty) to high(dbnavigbuttonty) do begin
   with buttons[ord(bu1)] do begin
    if bu1 in abuttons then begin
     state:= state - [as_disabled];
    end
    else begin
     state:= state + [as_disabled];
    end;
   end;
  end;
 finally
  endupdate;
 end;
 if application.mousewidget = self then begin
  asyncevent(0);
 end;
end;

function tdbnavigator.getdatasource: tdatasource;
begin
 result:= fdatalink.DataSource;
end;

procedure tdbnavigator.setvisiblebuttons(const avalue: dbnavigbuttonsty);
var
 bu1: dbnavigbuttonty;
begin
 if fvisiblebuttons <> avalue then begin
  beginupdate;
  for bu1:= low(dbnavigbuttonty) to high(dbnavigbuttonty) do begin
   buttons[ord(bu1)].visible:= bu1 in avalue;
  end;
  fvisiblebuttons:= avalue;
  endupdate;
 end; 
end;

function tdbnavigator.getcolorglyph: colorty;
begin
 result:= buttons.colorglyph;
end;

procedure tdbnavigator.setcolorglyph(const avalue: colorty);
begin
 buttons.colorglyph:= avalue;
end;

function tdbnavigator.getbuttonface: tface;
begin
 result:= buttons.face;
end;

procedure tdbnavigator.setbuttonface(const avalue: tface);
begin
 buttons.face:= avalue;
end;

procedure tdbnavigator.loaded;
begin
 inherited;
 colorglyph:= colorglyph;
end;

procedure tdbnavigator.doshortcut(var info: keyeventinfoty; const sender: twidget);
var
 bu1: dbnavigbuttonty;
begin
 if not (csdesigning in componentstate) then begin
  for bu1:= low(dbnavigbuttonty) to high(dbnavigbuttonty) do begin
   if checkshortcutcode(fshortcuts[bu1],info) then begin
    if buttons[ord(bu1)].enabled then begin
     fdatalink.execbutton(bu1);
     include(info.eventstate,es_processed);
    end;
    break;
   end;
  end;
 end;
 if not (es_processed in info.eventstate) then begin;
  inherited;
 end;
end;

procedure tdbnavigator.setdatasource(const Value: tdatasource);
begin
 fdatalink.DataSource:= value;
end;

procedure tdbnavigator.doexecute(const sender: tobject);
begin
 with ttoolbutton(sender) do begin
  fdatalink.execbutton(dbnavigbuttonty(tag));
 end;
end;

function tdbnavigator.getnavigoptions: dbnavigatoroptionsty;
begin
 result:= foptions;
end;

procedure tdbnavigator.setoptions(const avalue: dbnavigatoroptionsty);
begin
 if avalue <> foptions then begin
  foptions:= avalue;
  with buttons[ord(dbnb_insert)] do begin
   if dno_append in self.options then begin
    hint:= stockobjects.captions[sc_append];
   end
   else begin
    hint:= stockobjects.captions[sc_insert];
   end;
  end;
  inithints;
 end;
end;

{ teditwidgetdatalink }

constructor teditwidgetdatalink.create(const intf: idbeditfieldlink);
begin
 fintf:= intf;
 inherited Create;
 visualcontrol:= true;
end;

procedure teditwidgetdatalink.setediting(avalue: boolean);
begin
 if (ewds_editing in fstate) <> avalue then begin
  if avalue then begin
   include(fstate,ewds_editing);
  end
  else begin
   exclude(fstate,ewds_editing);
  end;
//  fediting := avalue;
//  fmodified := False;
  exclude(fstate,ewds_modified);
 end;
end;

function teditwidgetdatalink.edit: Boolean;
begin
 if canmodify then begin
  inherited edit;
 end;
 result:= ewds_editing in fstate;
end;

function teditwidgetdatalink.canmodify: Boolean;
begin
 result:= (field <> nil) and 
           ((ewds_filterediting in fstate) or not readonly and 
                           not field.readonly);
end;

procedure teditwidgetdatalink.modified;
begin
 if not editing and (frecordchange = 0) and 
                not (ewds_filterediting in fstate) then begin
  inc(fbeginedit);
  try
   edit;
  finally
   dec(fbeginedit);
  end;
 end;
 include(fstate,ewds_modified);
end;

procedure teditwidgetdatalink.updateoptionsedit(var aoptions: optionseditty);
var
 state1: tcomponentstate;
begin
 state1:= fintf.getwidget.ComponentState;
 if state1 * [cswriting,csdesigning] = [] then begin
  if not (ewds_filterediting in fstate) and ((datasource = nil) or
          not editing and not (canmodify and datasource.AutoEdit)) then begin
   include(aoptions,oe_readonly);
  end;
 end;
end;

procedure teditwidgetdatalink.editingchanged;
begin
 setediting(inherited editing and canmodify);
 fintf.updatereadonlystate;
end;

procedure teditwidgetdatalink.dataevent(event: tdataevent; info: ptrint);
var
 bo1: boolean;
 bo2: boolean;
 aoptions: optionseditdbty;
begin
 bo1:= ewds_filterediting in fstate;
 if event = deupdatestate then begin
//  ffilterediting:= (dataset <> nil) and (dataset.state = dsfilter);
  if (dataset <> nil) and (dataset.state = dsfilter) then begin
   include(fstate,ewds_filterediting);
  end
  else begin
   exclude(fstate,ewds_filterediting);
  end;
 end;
 inherited;
 if bo1 <> (ewds_filterediting in fstate) then begin
  if bo1 then begin
   if ewds_filtereditdisabled in fstate then begin
    exclude(fstate,ewds_filtereditdisabled);
    fintf.setenabled(true);
   end;
  end
  else begin
   aoptions:= fintf.getoptionsdb;
   case filtereditkind of 
    fek_filtermin: bo2:= oed_nofilterminedit in aoptions;
    fek_filtermax: bo2:= oed_nofiltermaxedit in aoptions;
    fek_find: bo2:= oed_nofindedit in aoptions;
    else bo2:= oed_nofilteredit in aoptions; //fek_filter
   end;
   if bo2 then begin
    include(fstate,ewds_filtereditdisabled);
    fintf.setenabled(false);
   end;
  end;
  fintf.updatereadonlystate;
 end;
end;

procedure teditwidgetdatalink.activechanged;
begin
 if not active then begin
  fstate:= fstate - [ewds_filterediting,ewds_filtereditdisabled];
 end;
 fintf.updatereadonlystate;
 try
  inherited;
 except
  on e: exception do begin
   e.message:= fintf.getwidget.name + ': ' + e.message;
   raise
  end;
 end;
 if active and (field <> nil) and 
                    (field.datatype in [ftstring,ftfixedchar]) then begin
  fmaxlength:= 0;
//  fmaxlength:= field.size; //not used yet, problems with utf8 size
  if fmaxlength < 0 then begin
   fmaxlength:= 0;
  end;
 end
 else begin
  fmaxlength:= 0;
 end;
end;

procedure teditwidgetdatalink.focuscontrol(afield: tfieldref);
begin
 if (afield^ = field) and (field <> nil) then begin
  if fintf.seteditfocus then begin
   afield^:= nil;
  end;
 end;
end;
{
procedure teditwidgetdatalink.focuscontrol(afield: tfieldref);
var
 widget1: twidget;
begin
 if (afield^ = field) and (field <> nil) then begin
  widget1:= fintf.getwidget;
  if widget1.canfocus then begin
   afield^ := nil;
   widget1.setfocus;
  end;
 end;
end;
}
procedure teditwidgetdatalink.recordchanged(afield: tfield);
begin
 if (afield = nil) or (afield = field) then begin
  if (fbeginedit = 0) and (frecordchange = 0) then begin
   inc(frecordchange);
   try
    if (field <> nil) and active and 
      not (dataset.eof and dataset.bof and 
              not (dataset.state in [dsinsert,dsfilter])) then begin
     if field.isnull then begin
      fintf.setnullvalue;
     end
     else begin 
      fintf.fieldtovalue;
     end;
    end
    else begin
     fintf.setnullvalue;
    end;
    if fintf.getwidget.focused then begin
     fintf.initeditfocus;
    end;
   finally
    dec(frecordchange);
   end;
  end;
  exclude(fstate,ewds_modified);
 end;
end;

procedure teditwidgetdatalink.updatedata;
begin
 inc(fcanclosing);
 try
  if fintf.getwidget.canclose(nil) then begin
   exclude(fstate,ewds_modified);
  end
  else begin
   raise eabort.create('');
  end;
  if (field <> nil) then begin
   with field do begin
    if (defaultexpression <> '') and isnull and 
         (dataset.modified or 
           (fdscontroller <> nil) and fdscontroller.posting) then begin
     asstring:= defaultexpression;
    end;
   end;
  end;
  inherited;
 finally
  dec(fcanclosing);
 end;
end;

//function teditwidgetdatalink.dataentered: boolean;
procedure teditwidgetdatalink.dataentered;
var
 widget1: twidget;
 bo1,bo2: boolean;
begin
 if (frecordchange = 0) and (fposting = 0) then begin
  widget1:= fintf.getwidget;
  if not (ws_loadedproc in widget1.widgetstate) and (field <> nil) and 
               not ((oe_checkmrcancel in fintf.getoptionsedit) and
             (widget1.window.modalresult = mr_cancel)) then begin
   if ewds_filterediting in fstate then begin
    fintf.valuetofield;
   end
   else begin
    if editing then begin
     fintf.valuetofield;
     if (oed_autopost in fintf.getoptionsdb) and active then begin
      widget1:= widget1.parentwidget;
      try
       inc(fposting);
       if (widget1 <> nil) then begin
        if widget1.parentwidget is tcustomgrid then begin
         with tcustomgrid1(widget1.parentwidget) do begin
          bo1:= fnonullcheck > 0;
          if bo1 then begin
           dec(fnonullcheck);   //remove colchangelock
          end;
         end;
        end
        else begin
         bo1:= false;
        end;
        try
         bo2:= widget1.canparentclose;
        finally
         if bo1 then begin
          inc(tcustomgrid1(widget1.parentwidget).fnonullcheck);
         end;
        end;
       end;
       if bo2 then begin
        dataset.post;
       end;
      finally
       dec(fposting);
      end;
     end;
    end;
   end;
  end;
 end;
end;

procedure teditwidgetdatalink.setwidgetdatasource(const avalue: tdatasource);
begin
 if not ((csloading in fintf.getwidget.componentstate) and datasourcefixed or 
                  (fintf.getgridintf <> nil)) then begin
  datasource:= avalue;
 end;
end;

procedure teditwidgetdatalink.griddatasourcechanged;
var
 datasource1: tdatasource;
begin
 datasource1:= fintf.getgriddatasource;
 if datasource <> datasource1 then begin
  datasource:= datasource1;
 end;
end;

function teditwidgetdatalink.nullcheckneeded: boolean;
begin
 result:= editing and (dataset.modified or 
        (dataset.state <> dsinsert) or 
         (fdscontroller <> nil) and fdscontroller.posting);
end;

function teditwidgetdatalink.cuttext(const atext: msestring;
               out maxlength: integer): boolean;
begin
 maxlength:= fmaxlength;
 result:= (maxlength > 0) and (length(atext) > maxlength);
end;

{ tdbstringedit }

constructor tdbstringedit.create(aowner: tcomponent);
begin
 fdatalink:= teditwidgetdatalink.Create(idbeditfieldlink(self));
 inherited;
end;

destructor tdbstringedit.destroy;
begin
 inherited;
 fdatalink.free;
end;

function tdbstringedit.getdatafield: string;
begin
 result:= fdatalink.fieldname;
end;

procedure tdbstringedit.setdatafield(const avalue: string);
begin
 fdatalink.fieldname:= avalue;
end;

function tdbstringedit.getdatasource: tdatasource;
begin
 result:= fdatalink.datasource;
end;

procedure tdbstringedit.setdatasource(const avalue: tdatasource);
begin
 fdatalink.setwidgetdatasource(avalue);
end;

procedure tdbstringedit.modified;
begin
 fdatalink.modified;
 inherited;
end;

function tdbstringedit.getoptionsedit: optionseditty;
begin
 result:= inherited getoptionsedit;
 fdatalink.updateoptionsedit(result);
end;

procedure tdbstringedit.valuetofield;
begin
 if value = '' then begin
  fdatalink.field.clear;
 end
 else begin
  fdatalink.asmsestring:= value;
 end;
end;

procedure tdbstringedit.fieldtovalue;
begin
 value:= fdatalink.asmsestring;
end;

function tdbstringedit.getrowdatapo(const info: cellinfoty): pointer;
begin
 with info do begin
  if griddatalink <> nil then begin
   result:= tgriddatalink(griddatalink).getstringbuffer(fdatalink.field,cell.row);
  end
  else begin
   result:= nil;
  end;
 end;
end;

function tdbstringedit.createdatalist(const sender: twidgetcol): tdatalist;
begin
 result:= nil;
end;

procedure tdbstringedit.griddatasourcechanged;
begin
 fdatalink.griddatasourcechanged;
end;

function tdbstringedit.getgriddatasource: tdatasource;
begin
 result:= tcustomdbwidgetgrid(fgridintf.getcol.grid).datasource;
end;

procedure tdbstringedit.getfieldtypes(out propertynames: stringarty; 
                    out fieldtypes: fieldtypesarty);
begin
 propertynames:= nil;
 setlength(fieldtypes,1);
 fieldtypes[0]:= textfields;
end;

function tdbstringedit.nullcheckneeded(const newfocus: twidget): boolean;
begin
 result:= inherited nullcheckneeded(newfocus) and fdatalink.nullcheckneeded;
end;

function tdbstringedit.getdatasource(const aindex: integer): tdatasource;
begin
 result:= datasource;
end;

procedure tdbstringedit.editnotification(var info: editnotificationinfoty);
var
 int1: integer;
begin
 inherited;
 if info.action = ea_textedited then begin
  if fdatalink.cuttext(text,int1) then begin
   text:= copy(text,1,int1);
  end;
 end;
end;

procedure tdbstringedit.recchanged;
begin
 fdatalink.recordchanged(nil);
end;

{
function tdbstringedit.checkvalue(const quiet: boolean = false): boolean;
begin
 result:= inherited checkvalue(quiet) and fdatalink.dataentered;
end;
}

procedure tdbstringedit.dochange;
begin
 fdatalink.dataentered;
 inherited;
end;

{ tdbdialogstringedit }

constructor tdbdialogstringedit.create(aowner: tcomponent);
begin
 fdatalink:= teditwidgetdatalink.Create(idbeditfieldlink(self));
 inherited;
end;

destructor tdbdialogstringedit.destroy;
begin
 inherited;
 fdatalink.free;
end;

function tdbdialogstringedit.getdatafield: string;
begin
 result:= fdatalink.fieldname;
end;

procedure tdbdialogstringedit.setdatafield(const avalue: string);
begin
 fdatalink.fieldname:= avalue;
end;

function tdbdialogstringedit.getdatasource: tdatasource;
begin
 result:= fdatalink.datasource;
end;

procedure tdbdialogstringedit.setdatasource(const avalue: tdatasource);
begin
 fdatalink.setwidgetdatasource(avalue);
end;

procedure tdbdialogstringedit.modified;
begin
 fdatalink.Modified;
 inherited;
end;

function tdbdialogstringedit.getoptionsedit: optionseditty;
begin
 result:= inherited getoptionsedit;
 fdatalink.updateoptionsedit(result);
end;

procedure tdbdialogstringedit.valuetofield;
begin
 if value = '' then begin
  fdatalink.field.clear;
 end
 else begin
  fdatalink.asmsestring:= value;
 end;
end;

procedure tdbdialogstringedit.fieldtovalue;
begin
 value:= fdatalink.asmsestring;
end;

function tdbdialogstringedit.getrowdatapo(const info: cellinfoty): pointer;
begin
 with info do begin
  if griddatalink <> nil then begin
   result:= tgriddatalink(griddatalink).getstringbuffer(fdatalink.field,cell.row);
  end
  else begin
   result:= nil;
  end;
 end;
end;

function tdbdialogstringedit.createdatalist(const sender: twidgetcol): tdatalist;
begin
 result:= nil;
end;

procedure tdbdialogstringedit.griddatasourcechanged;
begin
 fdatalink.griddatasourcechanged;
end;

function tdbdialogstringedit.getgriddatasource: tdatasource;
begin
 result:= tcustomdbwidgetgrid(fgridintf.getcol.grid).datasource;
end;

procedure tdbdialogstringedit.getfieldtypes(out propertynames: stringarty; 
                    out fieldtypes: fieldtypesarty);
begin
 propertynames:= nil;
 setlength(fieldtypes,1);
 fieldtypes[0]:= textfields;
end;

function tdbdialogstringedit.nullcheckneeded(const newfocus: twidget): boolean;
begin
 result:= inherited nullcheckneeded(newfocus) and fdatalink.nullcheckneeded;
end;

function tdbdialogstringedit.getdatasource(const aindex: integer): tdatasource;
begin
 result:= datasource;
end;

procedure tdbdialogstringedit.recchanged;
begin
 fdatalink.recordchanged(nil);
end;

{
function tdbdialogstringedit.checkvalue(const quiet: boolean = false): boolean;
begin
 result:= inherited checkvalue(quiet) and fdatalink.dataentered;
end;
}

procedure tdbdialogstringedit.dochange;
begin
 fdatalink.dataentered;
 inherited;
end;

{ tcustomdbdropdownlistedit }

constructor tcustomdbdropdownlistedit.create(aowner: tcomponent);
begin
 fdatalink:= teditwidgetdatalink.Create(idbeditfieldlink(self));
 inherited;
end;

destructor tcustomdbdropdownlistedit.destroy;
begin
 inherited;
 fdatalink.free;
end;

function tcustomdbdropdownlistedit.getdatafield: string;
begin
 result:= fdatalink.fieldname;
end;

procedure tcustomdbdropdownlistedit.setdatafield(const avalue: string);
begin
 fdatalink.fieldname:= avalue;
end;

function tcustomdbdropdownlistedit.getdatasource: tdatasource;
begin
 result:= fdatalink.datasource;
end;

procedure tcustomdbdropdownlistedit.setdatasource(const avalue: tdatasource);
begin
 fdatalink.setwidgetdatasource(avalue);
end;

procedure tcustomdbdropdownlistedit.modified;
begin
 fdatalink.Modified;
 inherited;
end;

function tcustomdbdropdownlistedit.getoptionsedit: optionseditty;
begin
 result:= inherited getoptionsedit;
 fdatalink.updateoptionsedit(result);
end;

procedure tcustomdbdropdownlistedit.valuetofield;
begin
 if value = '' then begin
  fdatalink.field.clear;
 end
 else begin
  fdatalink.asmsestring:= value;
 end;
end;

procedure tcustomdbdropdownlistedit.fieldtovalue;
begin
 value:= fdatalink.asmsestring;
end;

function tcustomdbdropdownlistedit.getrowdatapo(const info: cellinfoty): pointer;
begin
 with info do begin
  if griddatalink <> nil then begin
   result:= tgriddatalink(griddatalink).getstringbuffer(fdatalink.field,cell.row);
  end
  else begin
   result:= nil;
  end;
 end;
end;

function tcustomdbdropdownlistedit.createdatalist(const sender: twidgetcol): tdatalist;
begin
 result:= nil;
end;

procedure tcustomdbdropdownlistedit.griddatasourcechanged;
begin
 fdatalink.griddatasourcechanged;
end;

function tcustomdbdropdownlistedit.getgriddatasource: tdatasource;
begin
 result:= tcustomdbwidgetgrid(fgridintf.getcol.grid).datasource;
end;

procedure tcustomdbdropdownlistedit.getfieldtypes(out propertynames: stringarty; 
                    out fieldtypes: fieldtypesarty);
begin
 propertynames:= nil;
 setlength(fieldtypes,1);
 fieldtypes[0]:= textfields;
end;

function tcustomdbdropdownlistedit.nullcheckneeded(const newfocus: twidget): boolean;
begin
 result:= inherited nullcheckneeded(newfocus) and fdatalink.nullcheckneeded;
end;

function tcustomdbdropdownlistedit.getdatasource(const aindex: integer): tdatasource;
begin
 result:= datasource;
end;

procedure tcustomdbdropdownlistedit.recchanged;
begin
 fdatalink.recordchanged(nil);
end;

{
function tcustomdbdropdownlistedit.checkvalue(const quiet: boolean = false): boolean;
begin
 result:= inherited checkvalue(quiet) and fdatalink.dataentered;
end;
}

procedure tcustomdbdropdownlistedit.dochange;
begin
 fdatalink.dataentered;
 inherited;
end;

{ tdbkeystringedit }

constructor tdbkeystringedit.create(aowner: tcomponent);
begin
 fdatalink:= teditwidgetdatalink.Create(idbeditfieldlink(self));
 inherited;
end;

destructor tdbkeystringedit.destroy;
begin
 inherited;
 fdatalink.free;
end;

function tdbkeystringedit.getdatafield: string;
begin
 result:= fdatalink.fieldname;
end;

procedure tdbkeystringedit.setdatafield(const avalue: string);
begin
 fdatalink.fieldname:= avalue;
end;

function tdbkeystringedit.getdatasource: tdatasource;
begin
 result:= fdatalink.datasource;
end;

procedure tdbkeystringedit.setdatasource(const avalue: tdatasource);
begin
 fdatalink.setwidgetdatasource(avalue);
end;

procedure tdbkeystringedit.modified;
begin
 fdatalink.modified;
 inherited;
end;

function tdbkeystringedit.getoptionsedit: optionseditty;
begin
 result:= inherited getoptionsedit;
 fdatalink.updateoptionsedit(result);
 frame.readonly:= oe_readonly in result;
end;

procedure tdbkeystringedit.valuetofield;
begin
 if value = '' then begin
  fdatalink.field.clear;
 end
 else begin
  fdatalink.asmsestring:= value;
 end;
end;

procedure tdbkeystringedit.fieldtovalue;
begin
 value:= fdatalink.asmsestring;
end;

function tdbkeystringedit.getrowdatapo(const info: cellinfoty): pointer;
begin
 with info do begin
  if griddatalink <> nil then begin
   result:= tgriddatalink(griddatalink).getstringbuffer(fdatalink.field,cell.row);
  end
  else begin
   result:= nil;
  end;
 end;
end;

function tdbkeystringedit.createdatalist(const sender: twidgetcol): tdatalist;
begin
 result:= nil;
end;

procedure tdbkeystringedit.griddatasourcechanged;
begin
 fdatalink.griddatasourcechanged;
end;

function tdbkeystringedit.getgriddatasource: tdatasource;
begin
 result:= tcustomdbwidgetgrid(fgridintf.getcol.grid).datasource;
end;

procedure tdbkeystringedit.getfieldtypes(out propertynames: stringarty; 
                    out fieldtypes: fieldtypesarty);
begin
 propertynames:= nil;
 setlength(fieldtypes,1);
 fieldtypes[0]:= textfields;
end;

function tdbkeystringedit.nullcheckneeded(const newfocus: twidget): boolean;
begin
 result:= inherited nullcheckneeded(newfocus) and fdatalink.nullcheckneeded;
end;

function tdbkeystringedit.getdatasource(const aindex: integer): tdatasource;
begin
 result:= datasource;
end;

procedure tdbkeystringedit.recchanged;
begin
 fdatalink.recordchanged(nil);
end;

{
function tdbkeystringedit.checkvalue(const quiet: boolean = false): boolean;
begin
 result:= inherited checkvalue(quiet) and fdatalink.dataentered;
end;
}

procedure tdbkeystringedit.dochange;
begin
 fdatalink.dataentered;
 inherited;
end;

{ tdbmemoedit }

constructor tdbmemoedit.create(aowner: tcomponent);
begin
 fdatalink:= teditwidgetdatalink.create(idbeditfieldlink(self));
 inherited;
end;

destructor tdbmemoedit.destroy;
begin
 inherited;
 fdatalink.free;
end;

function tdbmemoedit.getdatafield: string;
begin
 result:= fdatalink.fieldname;
end;

procedure tdbmemoedit.setdatafield(const avalue: string);
begin
 fdatalink.fieldname:= avalue;
end;

function tdbmemoedit.getdatasource: tdatasource;
begin
 result:= fdatalink.datasource;
end;

procedure tdbmemoedit.setdatasource(const avalue: tdatasource);
begin
 fdatalink.setwidgetdatasource(avalue);
end;

procedure tdbmemoedit.modified;
begin
 fdatalink.modified;
 inherited;
end;

function tdbmemoedit.getoptionsedit: optionseditty;
begin
 result:= inherited getoptionsedit;
 fdatalink.updateoptionsedit(result);
end;

procedure tdbmemoedit.valuetofield;
begin
 if value = '' then begin
  fdatalink.field.clear;
 end
 else begin
  fdatalink.asmsestring:= value;
 end;
end;

procedure tdbmemoedit.fieldtovalue;
begin
 value:= fdatalink.asmsestring;
end;

function tdbmemoedit.getrowdatapo(const info: cellinfoty): pointer;
begin
 with info do begin
  if griddatalink <> nil then begin
   result:= tgriddatalink(griddatalink).getstringbuffer(fdatalink.field,cell.row);
  end
  else begin
   result:= nil;
  end;
 end;
end;

function tdbmemoedit.createdatalist(const sender: twidgetcol): tdatalist;
begin
 result:= nil;
end;

procedure tdbmemoedit.griddatasourcechanged;
begin
 fdatalink.griddatasourcechanged;
end;

function tdbmemoedit.getgriddatasource: tdatasource;
begin
 result:= tcustomdbwidgetgrid(fgridintf.getcol.grid).datasource;
end;

procedure tdbmemoedit.getfieldtypes(out propertynames: stringarty; 
                    out fieldtypes: fieldtypesarty);
begin
 propertynames:= nil;
 setlength(fieldtypes,1);
 fieldtypes[0]:= memofields;
end;

function tdbmemoedit.nullcheckneeded(const newfocus: twidget): boolean;
begin
 result:= inherited nullcheckneeded(newfocus) and fdatalink.nullcheckneeded;
end;

function tdbmemoedit.getdatasource(const aindex: integer): tdatasource;
begin
 result:= datasource;
end;

procedure tdbmemoedit.recchanged;
begin
 fdatalink.recordchanged(nil);
end;

{
function tdbmemoedit.checkvalue(const quiet: boolean = false): boolean;
begin
 result:= inherited checkvalue(quiet) and fdatalink.dataentered;
end;
}

procedure tdbmemoedit.dochange;
begin
 fdatalink.dataentered;
 inherited;
end;

{ tdbintegeredit }

constructor tdbintegeredit.create(aowner: tcomponent);
begin
 fisnull:= true;
 fdatalink:= teditwidgetdatalink.Create(idbeditfieldlink(self));
 inherited;
end;

destructor tdbintegeredit.destroy;
begin
 inherited;
 fdatalink.free;
end;

function tdbintegeredit.getdatafield: string;
begin
 result:= fdatalink.fieldname;
end;

procedure tdbintegeredit.setdatafield(const avalue: string);
begin
 fdatalink.fieldname:= avalue;
end;

function tdbintegeredit.getdatasource: tdatasource;
begin
 result:= fdatalink.datasource;
end;

procedure tdbintegeredit.setdatasource(const avalue: tdatasource);
begin
 fdatalink.setwidgetdatasource(avalue);
end;

procedure tdbintegeredit.modified;
begin
 fdatalink.modified;
 inherited;
end;

function tdbintegeredit.getoptionsedit: optionseditty;
begin
 result:= inherited getoptionsedit;
 fdatalink.updateoptionsedit(result);
end;

procedure tdbintegeredit.setnullvalue;
begin
 inherited;
 fisnull:= true;
end;

function tdbintegeredit.internaldatatotext(const data): msestring;
begin
 if (@data = nil) and fisnull then begin
  result:= '';
 end
 else begin
  result:= inherited internaldatatotext(data);
 end;
end;

procedure tdbintegeredit.texttovalue(var accept: boolean; const quiet: boolean);
begin
 fisnull:= text = '';
 inherited;
end;

procedure tdbintegeredit.valuetofield;
begin
 if fisnull then begin
  fdatalink.field.clear;
 end
 else begin
  fdatalink.field.asinteger:= value;
 end;
end;

procedure tdbintegeredit.fieldtovalue;
begin
 fisnull:= false;
 value:= fdatalink.field.asinteger;
end;

function tdbintegeredit.getrowdatapo(const info: cellinfoty): pointer;
begin
 with info do begin
  if griddatalink <> nil then begin
   result:= tgriddatalink(griddatalink).getintegerbuffer(fdatalink.field,cell.row);
  end
  else begin
   result:= nil;
  end;
 end;
end;

procedure tdbintegeredit.griddatasourcechanged;
begin
 fdatalink.griddatasourcechanged;
end;

function tdbintegeredit.getgriddatasource: tdatasource;
begin
 result:= tcustomdbwidgetgrid(fgridintf.getcol.grid).datasource;
end;

function tdbintegeredit.createdatalist(const sender: twidgetcol): tdatalist;
begin
 result:= nil;
end;

procedure tdbintegeredit.getfieldtypes(out propertynames: stringarty; 
                    out fieldtypes: fieldtypesarty);
begin
 propertynames:= nil;
 setlength(fieldtypes,1);
 fieldtypes[0]:= integerfields;
end;

function tdbintegeredit.nullcheckneeded(const newfocus: twidget): boolean;
begin
 result:= inherited nullcheckneeded(newfocus) and fdatalink.nullcheckneeded;
end;

function tdbintegeredit.getdatasource(const aindex: integer): tdatasource;
begin
 result:= datasource;
end;

procedure tdbintegeredit.recchanged;
begin
 fdatalink.recordchanged(nil);
end;

{
function tdbintegeredit.checkvalue(const quiet: boolean = false): boolean;
begin
 result:= inherited checkvalue(quiet) and fdatalink.dataentered;
end;
}

procedure tdbintegeredit.dochange;
begin
 fdatalink.dataentered;
 inherited;
end;

{ tdbbooleanedit }

constructor tdbbooleanedit.create(aowner: tcomponent);
begin
 fdatalink:= teditwidgetdatalink.Create(idbeditfieldlink(self));
 inherited;
end;

destructor tdbbooleanedit.destroy;
begin
 inherited;
 fdatalink.free;
end;

function tdbbooleanedit.getdatafield: string;
begin
 result:= fdatalink.fieldname;
end;

procedure tdbbooleanedit.setdatafield(const avalue: string);
begin
 fdatalink.fieldname:= avalue;
end;

function tdbbooleanedit.getdatasource: tdatasource;
begin
 result:= fdatalink.datasource;
end;

procedure tdbbooleanedit.setdatasource(const avalue: tdatasource);
begin
 fdatalink.setwidgetdatasource(avalue);
end;

function tdbbooleanedit.checkvalue(const quiet: boolean = false): boolean;
begin
 result:= false;
 //dummy
end;

function tdbbooleanedit.getoptionsedit: optionseditty;
begin
 result:= inherited getoptionsedit;
 fdatalink.updateoptionsedit(result);
end;

procedure tdbbooleanedit.valuetofield;
begin
 fdatalink.field.asboolean:= value;
end;

procedure tdbbooleanedit.fieldtovalue;
begin
 value:= fdatalink.field.asboolean;
end;

function tdbbooleanedit.getrowdatapo(const info: cellinfoty): pointer;
begin
 with info do begin
  if griddatalink <> nil then begin
   result:= tgriddatalink(griddatalink).getbooleanbuffer(fdatalink.field,cell.row);
  end
  else begin
   result:= nil;
  end;
 end;
end;

function tdbbooleanedit.createdatalist(const sender: twidgetcol): tdatalist;
begin
 result:= nil;
end;

procedure tdbbooleanedit.griddatasourcechanged;
begin
 fdatalink.griddatasourcechanged;
end;

function tdbbooleanedit.getgriddatasource: tdatasource;
begin
 result:= tcustomdbwidgetgrid(fgridintf.getcol.grid).datasource;
end;

procedure tdbbooleanedit.getfieldtypes(out propertynames: stringarty; 
                    out fieldtypes: fieldtypesarty);
begin
 propertynames:= nil;
 setlength(fieldtypes,1);
 fieldtypes[0]:= booleanfields;
end;

function tdbbooleanedit.getdatasource(const aindex: integer): tdatasource;
begin
 result:= datasource;
end;

procedure tdbbooleanedit.recchanged;
begin
 fdatalink.recordchanged(nil);
end;

{
function tdbbooleanedit.docheckvalue(var avalue): boolean;
begin
 result:= inherited docheckvalue(avalue);
 if result then begin
  fdatalink.modified;
  result:= fdatalink.dataentered;
 end;
end;
}

procedure tdbbooleanedit.dochange;
begin
 fdatalink.dataentered;
 inherited;
end;

procedure tdbbooleanedit.modified;
begin
 fdatalink.modified;
 inherited;
end;

{ tdbdataicon }

constructor tdbdataicon.create(aowner: tcomponent);
begin
 fdatalink:= teditwidgetdatalink.Create(idbeditfieldlink(self));
 inherited;
end;

destructor tdbdataicon.destroy;
begin
 inherited;
 fdatalink.free;
end;

function tdbdataicon.getdatafield: string;
begin
 result:= fdatalink.fieldname;
end;

procedure tdbdataicon.setdatafield(const avalue: string);
begin
 fdatalink.fieldname:= avalue;
end;

function tdbdataicon.getdatasource: tdatasource;
begin
 result:= fdatalink.datasource;
end;

procedure tdbdataicon.setdatasource(const avalue: tdatasource);
begin
 fdatalink.setwidgetdatasource(avalue);
end;

function tdbdataicon.checkvalue(const quiet: boolean = false): boolean;
begin
 result:= false;
 //dummy
end;

function tdbdataicon.getoptionsedit: optionseditty;
begin
 result:= inherited getoptionsedit;
 fdatalink.updateoptionsedit(result);
end;

procedure tdbdataicon.valuetofield;
begin
 if value = -1 then begin
  fdatalink.field.clear;
 end
 else begin
  fdatalink.field.asinteger:= value;
 end;
end;

procedure tdbdataicon.fieldtovalue;
begin
 value:= fdatalink.field.asinteger;
end;

function tdbdataicon.getrowdatapo(const info: cellinfoty): pointer;
begin
 with info do begin
  if griddatalink <> nil then begin
   result:= tgriddatalink(griddatalink).getintegerbuffer(fdatalink.field,cell.row);
  end
  else begin
   result:= nil;
  end;
 end;
end;

function tdbdataicon.createdatalist(const sender: twidgetcol): tdatalist;
begin
 result:= nil;
end;

procedure tdbdataicon.griddatasourcechanged;
begin
 fdatalink.griddatasourcechanged;
end;

function tdbdataicon.getgriddatasource: tdatasource;
begin
 result:= tcustomdbwidgetgrid(fgridintf.getcol.grid).datasource;
end;

procedure tdbdataicon.getfieldtypes(out propertynames: stringarty; 
                    out fieldtypes: fieldtypesarty);
begin
 propertynames:= nil;
 setlength(fieldtypes,1);
 fieldtypes[0]:= integerfields;
end;

function tdbdataicon.getdatasource(const aindex: integer): tdatasource;
begin
 result:= datasource;
end;

procedure tdbdataicon.recchanged;
begin
 fdatalink.recordchanged(nil);
end;

{
function tdbdataicon.docheckvalue(var avalue): boolean;
var
 widget: twidget;
 int1: integer;
begin
 result:= inherited docheckvalue(avalue);
 if result then begin
  fdatalink.modified;
  result:= fdatalink.dataentered;
 end;
end;
}

procedure tdbdataicon.dochange;
begin
 fdatalink.dataentered;
 inherited;
end;

procedure tdbdataicon.modified;
begin
 fdatalink.modified;
 inherited;
end;

{ tdbdatabutton }

constructor tdbdatabutton.create(aowner: tcomponent);
begin
 fdatalink:= teditwidgetdatalink.Create(idbeditfieldlink(self));
 inherited;
end;

destructor tdbdatabutton.destroy;
begin
 inherited;
 fdatalink.free;
end;

function tdbdatabutton.getdatafield: string;
begin
 result:= fdatalink.fieldname;
end;

procedure tdbdatabutton.setdatafield(const avalue: string);
begin
 fdatalink.fieldname:= avalue;
end;

function tdbdatabutton.getdatasource: tdatasource;
begin
 result:= fdatalink.datasource;
end;

procedure tdbdatabutton.setdatasource(const avalue: tdatasource);
begin
 fdatalink.setwidgetdatasource(avalue);
end;

function tdbdatabutton.checkvalue(const quiet: boolean = false): boolean;
begin
 result:= false;
 //dummy
end;

function tdbdatabutton.getoptionsedit: optionseditty;
begin
 result:= inherited getoptionsedit;
 fdatalink.updateoptionsedit(result);
end;

procedure tdbdatabutton.valuetofield;
begin
 if value = -1 then begin
  fdatalink.field.clear;
 end
 else begin
  fdatalink.field.asinteger:= value;
 end;
end;

procedure tdbdatabutton.fieldtovalue;
begin
 value:= fdatalink.field.asinteger;
end;

function tdbdatabutton.getrowdatapo(const info: cellinfoty): pointer;
begin
 with info do begin
  if griddatalink <> nil then begin
   result:= tgriddatalink(griddatalink).getintegerbuffer(fdatalink.field,cell.row);
  end
  else begin
   result:= nil;
  end;
 end;
end;

function tdbdatabutton.createdatalist(const sender: twidgetcol): tdatalist;
begin
 result:= nil;
end;

procedure tdbdatabutton.griddatasourcechanged;
begin
 fdatalink.griddatasourcechanged;
end;

function tdbdatabutton.getgriddatasource: tdatasource;
begin
 result:= tcustomdbwidgetgrid(fgridintf.getcol.grid).datasource;
end;

procedure tdbdatabutton.getfieldtypes(out propertynames: stringarty; 
                    out fieldtypes: fieldtypesarty);
begin
 propertynames:= nil;
 setlength(fieldtypes,1);
 fieldtypes[0]:= integerfields;
end;

function tdbdatabutton.getdatasource(const aindex: integer): tdatasource;
begin
 result:= datasource;
end;

procedure tdbdatabutton.recchanged;
begin
 fdatalink.recordchanged(nil);
end;

{
function tdbdatabutton.docheckvalue(var avalue): boolean;
var
 widget: twidget;
 int1: integer;
begin
 result:= inherited docheckvalue(avalue);
 if result then begin
  fdatalink.modified;
  result:= fdatalink.dataentered;
 end;
end;
}

procedure tdbdatabutton.dochange;
begin
 fdatalink.dataentered;
 inherited;
end;

procedure tdbdatabutton.modified;
begin
 fdatalink.modified;
 inherited;
end;

{ tdbbooleaneditradio }

constructor tdbbooleaneditradio.create(aowner: tcomponent);
begin
 fdatalink:= teditwidgetdatalink.create(idbeditfieldlink(self));
 inherited;
end;

destructor tdbbooleaneditradio.destroy;
begin
 inherited;
 fdatalink.free;
end;

function tdbbooleaneditradio.getdatafield: string;
begin
 result:= fdatalink.fieldname;
end;

procedure tdbbooleaneditradio.setdatafield(const avalue: string);
begin
 fdatalink.FieldName:= avalue;
end;

function tdbbooleaneditradio.getdatasource: tdatasource;
begin
 result:= fdatalink.DataSource;
end;

procedure tdbbooleaneditradio.setdatasource(const avalue: tdatasource);
begin
 fdatalink.setwidgetdatasource(avalue);
end;

function tdbbooleaneditradio.checkvalue(const quiet: boolean = false): boolean;
begin
 result:= true;//dummy
end;

function tdbbooleaneditradio.docheckvalue(var avalue): boolean;
var
 widget: twidget;
 int1: integer;
 bo1: boolean;
begin
 if boolean(avalue) and (fparentwidget <> nil) then begin
  bo1:= false;
  for int1:= 0 to fparentwidget.widgetcount - 1 do begin
   widget:= fparentwidget.widgets[int1];
   if (widget is tdbbooleaneditradio) and (widget <> self) and
        (tcustombooleaneditradio(widget).group = group) then begin
    tdbbooleaneditradio(widget).docheckvalue(bo1);
   end;
  end;
 end;
 result:= inherited docheckvalue(avalue);
 {
 if result then begin
  fdatalink.modified;
  result:= fdatalink.dataentered;
 end;
 }
end;

procedure tdbbooleaneditradio.dochange;
begin
 fdatalink.dataentered;
 inherited;
end;

procedure tdbbooleaneditradio.modified;
begin
 fdatalink.modified;
 inherited;
end;

function tdbbooleaneditradio.getoptionsedit: optionseditty;
begin
 result:= inherited getoptionsedit;
 fdatalink.updateoptionsedit(result);
end;

procedure tdbbooleaneditradio.valuetofield;
begin
 fdatalink.field.asboolean:= value;
end;

procedure tdbbooleaneditradio.fieldtovalue;
begin
 value:= fdatalink.field.asboolean;
end;

function tdbbooleaneditradio.getrowdatapo(const info: cellinfoty): pointer;
begin
 with info do begin
  if griddatalink <> nil then begin
   result:= tgriddatalink(griddatalink).getbooleanbuffer(fdatalink.field,cell.row);
  end
  else begin
   result:= nil;
  end;
 end;
end;

function tdbbooleaneditradio.createdatalist(const sender: twidgetcol): tdatalist;
begin
 result:= nil;
end;

procedure tdbbooleaneditradio.griddatasourcechanged;
begin
 fdatalink.griddatasourcechanged;
end;

function tdbbooleaneditradio.getgriddatasource: tdatasource;
begin
 result:= tcustomdbwidgetgrid(fgridintf.getcol.grid).datasource;
end;

procedure tdbbooleaneditradio.getfieldtypes(out propertynames: stringarty; 
                    out fieldtypes: fieldtypesarty);
begin
 propertynames:= nil;
 setlength(fieldtypes,1);
 fieldtypes[0]:= booleanfields;
end;

function tdbbooleaneditradio.getdatasource(const aindex: integer): tdatasource;
begin
 result:= datasource;
end;

procedure tdbbooleaneditradio.recchanged;
begin
 fdatalink.recordchanged(nil);
end;

{ tdbrealedit }

constructor tdbrealedit.create(aowner: tcomponent);
begin
 fisdb:= true;
 fdatalink:= teditwidgetdatalink.Create(idbeditfieldlink(self));
 inherited;
end;

destructor tdbrealedit.destroy;
begin
 inherited;
 fdatalink.free;
end;

function tdbrealedit.getdatafield: string;
begin
 result:= fdatalink.fieldname;
end;

procedure tdbrealedit.setdatafield(const avalue: string);
begin
 fdatalink.fieldname:= avalue;
end;

function tdbrealedit.getdatasource: tdatasource;
begin
 result:= fdatalink.datasource;
end;

procedure tdbrealedit.setdatasource(const avalue: tdatasource);
begin
 fdatalink.setwidgetdatasource(avalue);
end;

procedure tdbrealedit.modified;
begin
 fdatalink.Modified;
 inherited;
end;

function tdbrealedit.getoptionsedit: optionseditty;
begin
 result:= inherited getoptionsedit;
 fdatalink.updateoptionsedit(result);
end;

procedure tdbrealedit.valuetofield;
begin
 if isemptyreal(value) then begin
  fdatalink.field.clear;
 end
 else begin
  fdatalink.field.asfloat:= value;
 end;
end;

procedure tdbrealedit.fieldtovalue;
begin
 if fdatalink.field.isnull then begin
  value:= emptyreal;
 end
 else begin
  value:= fdatalink.field.asfloat;
 end;
end;

function tdbrealedit.getrowdatapo(const info: cellinfoty): pointer;
begin
 with info do begin
  if griddatalink <> nil then begin
   result:= tgriddatalink(griddatalink).getrealtybuffer(fdatalink.field,cell.row);
  end
  else begin
   result:= nil;
  end;
 end;
end;

function tdbrealedit.createdatalist(const sender: twidgetcol): tdatalist;
begin
 result:= nil;
end;

procedure tdbrealedit.griddatasourcechanged;
begin
 fdatalink.griddatasourcechanged;
end;

function tdbrealedit.getgriddatasource: tdatasource;
begin
 result:= tcustomdbwidgetgrid(fgridintf.getcol.grid).datasource;
end;

procedure tdbrealedit.getfieldtypes(out propertynames: stringarty; 
                    out fieldtypes: fieldtypesarty);
begin
 propertynames:= nil;
 setlength(fieldtypes,1);
 fieldtypes[0]:= realfields + integerfields;
end;

function tdbrealedit.nullcheckneeded(const newfocus: twidget): boolean;
begin
 result:= inherited nullcheckneeded(newfocus) and fdatalink.nullcheckneeded;
end;

function tdbrealedit.getdatasource(const aindex: integer): tdatasource;
begin
 result:= datasource;
end;

procedure tdbrealedit.recchanged;
begin
 fdatalink.recordchanged(nil);
end;

{
function tdbrealedit.checkvalue(const quiet: boolean = false): boolean;
begin
 result:= inherited checkvalue(quiet) and fdatalink.dataentered;
end;
}

procedure tdbrealedit.dochange;
begin
 fdatalink.dataentered;
 inherited;
end;

{ tdbrealspinedit }

constructor tdbrealspinedit.create(aowner: tcomponent);
begin
 fisdb:= true;
 fdatalink:= teditwidgetdatalink.Create(idbeditfieldlink(self));
 inherited;
end;

destructor tdbrealspinedit.destroy;
begin
 inherited;
 fdatalink.free;
end;

function tdbrealspinedit.getdatafield: string;
begin
 result:= fdatalink.fieldname;
end;

procedure tdbrealspinedit.setdatafield(const avalue: string);
begin
 fdatalink.fieldname:= avalue;
end;

function tdbrealspinedit.getdatasource: tdatasource;
begin
 result:= fdatalink.datasource;
end;

procedure tdbrealspinedit.setdatasource(const avalue: tdatasource);
begin
 fdatalink.setwidgetdatasource(avalue);
end;

procedure tdbrealspinedit.modified;
begin
 fdatalink.Modified;
 inherited;
end;

function tdbrealspinedit.getoptionsedit: optionseditty;
begin
 result:= inherited getoptionsedit;
 fdatalink.updateoptionsedit(result);
end;

procedure tdbrealspinedit.valuetofield;
begin
 if isemptyreal(value) then begin
  fdatalink.field.clear;
 end
 else begin
  fdatalink.field.asfloat:= value;
 end;
end;

procedure tdbrealspinedit.fieldtovalue;
begin
 if fdatalink.field.isnull then begin
  value:= emptyreal;
 end
 else begin
  value:= fdatalink.field.asfloat;
 end;
end;

function tdbrealspinedit.getrowdatapo(const info: cellinfoty): pointer;
begin
 with info do begin
  if griddatalink <> nil then begin
   result:= tgriddatalink(griddatalink).getrealtybuffer(fdatalink.field,cell.row);
  end
  else begin
   result:= nil;
  end;
 end;
end;

function tdbrealspinedit.createdatalist(const sender: twidgetcol): tdatalist;
begin
 result:= nil;
end;

procedure tdbrealspinedit.griddatasourcechanged;
begin
 fdatalink.griddatasourcechanged;
end;

function tdbrealspinedit.getgriddatasource: tdatasource;
begin
 result:= tcustomdbwidgetgrid(fgridintf.getcol.grid).datasource;
end;

procedure tdbrealspinedit.getfieldtypes(out propertynames: stringarty; 
                    out fieldtypes: fieldtypesarty);
begin
 propertynames:= nil;
 setlength(fieldtypes,1);
 fieldtypes[0]:= realfields + integerfields;
end;

function tdbrealspinedit.nullcheckneeded(const newfocus: twidget): boolean;
begin
 result:= inherited nullcheckneeded(newfocus) and fdatalink.nullcheckneeded;
end;

function tdbrealspinedit.getdatasource(const aindex: integer): tdatasource;
begin
 result:= datasource;
end;

procedure tdbrealspinedit.recchanged;
begin
 fdatalink.recordchanged(nil);
end;

{
function tdbrealspinedit.checkvalue(const quiet: boolean = false): boolean;
begin
 result:= inherited checkvalue(quiet) and fdatalink.dataentered;
end;
}

procedure tdbrealspinedit.dochange;
begin
 fdatalink.dataentered;
 inherited;
end;

{ tdbslider }

constructor tdbslider.create(aowner: tcomponent);
begin
 fisdb:= true;
 fvaluescale:= 1;
 fdatalink:= teditwidgetdatalink.create(idbeditfieldlink(self));
 inherited;
end;

destructor tdbslider.destroy;
begin
 inherited;
 fdatalink.free;
end;

function tdbslider.getdatafield: string;
begin
 result:= fdatalink.fieldname;
end;

procedure tdbslider.setdatafield(const avalue: string);
begin
 fdatalink.fieldname:= avalue;
end;

function tdbslider.getdatasource: tdatasource;
begin
 result:= fdatalink.datasource;
end;

procedure tdbslider.setdatasource(const avalue: tdatasource);
begin
 fdatalink.setwidgetdatasource(avalue);
end;

function tdbslider.checkvalue(const quiet: boolean = false): boolean;
begin
 result:= false;
 //dummy
end;

function tdbslider.getoptionsedit: optionseditty;
begin
 result:= inherited getoptionsedit;
 fdatalink.updateoptionsedit(result);
end;

procedure tdbslider.valuetofield;
var
 rea1: real;
begin
 if isemptyreal(value) then begin
  fdatalink.field.clear;
 end
 else begin
  if valuescale <> 0 then begin
   rea1:= value / valuescale;
  end
  else begin
   rea1:= value;
  end;
  fdatalink.field.asfloat:= rea1;
 end;
end;

procedure tdbslider.fieldtovalue;
begin
 if fdatalink.field.isnull then begin
  value:= emptyreal;
 end
 else begin
  value:= fdatalink.field.asfloat * valuescale;
 end;
end;

function tdbslider.getrowdatapo(const info: cellinfoty): pointer;
begin
 with info do begin
  if griddatalink <> nil then begin
   result:= tgriddatalink(griddatalink).getrealtybuffer(fdatalink.field,cell.row);
   if result <> nil then begin
    preal(result)^:= preal(result)^ * valuescale;
   end;
  end
  else begin
   result:= nil;
  end;
 end;
end;

function tdbslider.createdatalist(const sender: twidgetcol): tdatalist;
begin
 result:= nil;
end;

procedure tdbslider.griddatasourcechanged;
begin
 fdatalink.griddatasourcechanged;
end;

function tdbslider.getgriddatasource: tdatasource;
begin
 result:= tcustomdbwidgetgrid(fgridintf.getcol.grid).datasource;
end;

procedure tdbslider.getfieldtypes(out propertynames: stringarty; 
                    out fieldtypes: fieldtypesarty);
begin
 propertynames:= nil;
 setlength(fieldtypes,1);
 fieldtypes[0]:= realfields + integerfields;
end;

function tdbslider.getdatasource(const aindex: integer): tdatasource;
begin
 result:= datasource;
end;

procedure tdbslider.recchanged;
begin
 fdatalink.recordchanged(nil);
end;

{
function tdbslider.docheckvalue(var avalue): boolean;
begin
 result:= inherited docheckvalue(avalue);
 if result then begin
  fdatalink.modified;
  result:= fdatalink.dataentered;
 end;
end;
}

procedure tdbslider.dochange;
begin
 fdatalink.dataentered;
 inherited;
end;

procedure tdbslider.modified;
begin
 fdatalink.modified;
 inherited;
end;

{ tdbprogressbar }

constructor tdbprogressbar.create(aowner: tcomponent);
begin
 fisdb:= true;
 fdatalink:= teditwidgetdatalink.Create(idbeditfieldlink(self));
 inherited;
end;

destructor tdbprogressbar.destroy;
begin
 inherited;
 fdatalink.free;
end;

function tdbprogressbar.getrowdatapo(const info: cellinfoty): pointer;
begin
 with info do begin
  if griddatalink <> nil then begin
   result:= tgriddatalink(griddatalink).getrealtybuffer(fdatalink.field,cell.row);
   if result <> nil then begin
    preal(result)^:= preal(result)^ * valuescale;
   end;
  end
  else begin
   result:= nil;
  end;
 end;
end;

procedure tdbprogressbar.valuetofield;
var
 rea1: real;
begin
 if isemptyreal(value) then begin
  fdatalink.field.clear;
 end
 else begin
  if valuescale <> 0 then begin
   rea1:= value / valuescale;
  end
  else begin
   rea1:= value;
  end;
  fdatalink.field.asfloat:= rea1;
 end;
end;

procedure tdbprogressbar.fieldtovalue;
begin
 if fdatalink.field.isnull then begin
  value:= emptyreal;
 end
 else begin
  value:= fdatalink.field.asfloat * valuescale;
 end;
end;

procedure tdbprogressbar.getfieldtypes(out propertynames: stringarty;
               out fieldtypes: fieldtypesarty);
begin
 propertynames:= nil;
 setlength(fieldtypes,1);
 fieldtypes[0]:= realfields + integerfields;
end;

procedure tdbprogressbar.recchanged;
begin
 fdatalink.recordchanged(nil);
end;

function tdbprogressbar.getgriddatasource: tdatasource;
begin
 result:= tcustomdbwidgetgrid(fgridintf.getcol.grid).datasource;
end;

function tdbprogressbar.createdatalist(const sender: twidgetcol): tdatalist;
begin
 result:= nil;
end;

function tdbprogressbar.getdatafield: string;
begin
 result:= fdatalink.fieldname;
end;

procedure tdbprogressbar.setdatafield(const avalue: string);
begin
 fdatalink.fieldname:= avalue;
end;

function tdbprogressbar.getdatasource: tdatasource;
begin
 result:= fdatalink.datasource;
end;

procedure tdbprogressbar.setdatasource(const avalue: tdatasource);
begin
 fdatalink.setwidgetdatasource(avalue);
end;

function tdbprogressbar.checkvalue(const quiet: boolean = false): boolean;
begin
 result:= false; //dummy
end;

function tdbprogressbar.getdatasource(const aindex: integer): tdatasource;
begin
 result:= datasource;
end;

procedure tdbprogressbar.griddatasourcechanged;
begin
 fdatalink.griddatasourcechanged;
end;

{ tdbdatetimeedit }

constructor tdbdatetimeedit.create(aowner: tcomponent);
begin
 fdatalink:= teditwidgetdatalink.Create(idbeditfieldlink(self));
 fisdb:= true;
 inherited;
end;

destructor tdbdatetimeedit.destroy;
begin
 inherited;
 fdatalink.free;
end;

function tdbdatetimeedit.getdatafield: string;
begin
 result:= fdatalink.fieldname;
end;

procedure tdbdatetimeedit.setdatafield(const avalue: string);
begin
 fdatalink.fieldname:= avalue;
end;

function tdbdatetimeedit.getdatasource: tdatasource;
begin
 result:= fdatalink.datasource;
end;

procedure tdbdatetimeedit.setdatasource(const avalue: tdatasource);
begin
 fdatalink.setwidgetdatasource(avalue);
end;

procedure tdbdatetimeedit.modified;
begin
 fdatalink.modified;
 inherited;
end;

function tdbdatetimeedit.getoptionsedit: optionseditty;
begin
 result:= inherited getoptionsedit;
 fdatalink.updateoptionsedit(result);
end;

procedure tdbdatetimeedit.valuetofield;
begin
 if value = emptydatetime then begin
  fdatalink.field.clear;
 end
 else begin
  fdatalink.field.asdatetime:= value;
 end;
end;

procedure tdbdatetimeedit.fieldtovalue;
var
 da1: tdatetime;
begin
 if fdatalink.field.isnull then begin
  value:= 0;
 end
 else begin
  da1:= fdatalink.field.asdatetime;
//  if da1 = 0 then begin
//   da1:= nulltime;
//  end;
  value:= da1;
 end;
end;
 
function tdbdatetimeedit.getrowdatapo(const info: cellinfoty): pointer;
begin
 with info do begin
  if griddatalink <> nil then begin
   result:= tgriddatalink(griddatalink).getdatetimebuffer(fdatalink.field,cell.row);
  end
  else begin
   result:= nil;
  end;
 end;
end;

function tdbdatetimeedit.createdatalist(const sender: twidgetcol): tdatalist;
begin
 result:= nil;
end;

procedure tdbdatetimeedit.griddatasourcechanged;
begin
 fdatalink.griddatasourcechanged;
end;

function tdbdatetimeedit.getgriddatasource: tdatasource;
begin
 result:= tcustomdbwidgetgrid(fgridintf.getcol.grid).datasource;
end;

procedure tdbdatetimeedit.getfieldtypes(out propertynames: stringarty; 
                    out fieldtypes: fieldtypesarty);
begin
 propertynames:= nil;
 setlength(fieldtypes,1);
 fieldtypes[0]:= datetimefields;
end;

function tdbdatetimeedit.nullcheckneeded(const newfocus: twidget): boolean;
begin
 result:= inherited nullcheckneeded(newfocus) and fdatalink.nullcheckneeded;
end;

function tdbdatetimeedit.getdatasource(const aindex: integer): tdatasource;
begin
 result:= datasource;
end;

procedure tdbdatetimeedit.recchanged;
begin
 fdatalink.recordchanged(nil);
end;

{
function tdbdatetimeedit.checkvalue(const quiet: boolean = false): boolean;
begin
 result:= inherited checkvalue(quiet) and fdatalink.dataentered;
end;
}

procedure tdbdatetimeedit.dochange;
begin
 fdatalink.dataentered;
 inherited;
end;

{ tdbcalendardatetimeedit }

constructor tdbcalendardatetimeedit.create(aowner: tcomponent);
begin
 fisdb:= true;
 fdatalink:= teditwidgetdatalink.Create(idbeditfieldlink(self));
 inherited;
end;

destructor tdbcalendardatetimeedit.destroy;
begin
 inherited;
 fdatalink.free;
end;

function tdbcalendardatetimeedit.getdatafield: string;
begin
 result:= fdatalink.fieldname;
end;

procedure tdbcalendardatetimeedit.setdatafield(const avalue: string);
begin
 fdatalink.fieldname:= avalue;
end;

function tdbcalendardatetimeedit.getdatasource: tdatasource;
begin
 result:= fdatalink.datasource;
end;

procedure tdbcalendardatetimeedit.setdatasource(const avalue: tdatasource);
begin
 fdatalink.setwidgetdatasource(avalue);
end;

procedure tdbcalendardatetimeedit.modified;
begin
 fdatalink.modified;
 inherited;
end;

function tdbcalendardatetimeedit.getoptionsedit: optionseditty;
begin
 result:= inherited getoptionsedit;
 fdatalink.updateoptionsedit(result);
end;

procedure tdbcalendardatetimeedit.valuetofield;
begin
 if value = emptydatetime then begin
  fdatalink.field.clear;
 end
 else begin
  fdatalink.field.asdatetime:= value;
 end;
end;

procedure tdbcalendardatetimeedit.fieldtovalue;
var
 da1: tdatetime;
begin
 if fdatalink.field.isnull then begin
  value:= 0;
 end
 else begin
  da1:= fdatalink.field.asdatetime;
//  if da1 = 0 then begin
//   da1:= nulltime;
//  end;
  value:= da1;
 end;
end;
 
function tdbcalendardatetimeedit.getrowdatapo(const info: cellinfoty): pointer;
begin
 with info do begin
  if griddatalink <> nil then begin
   result:= tgriddatalink(griddatalink).getdatetimebuffer(fdatalink.field,cell.row);
  end
  else begin
   result:= nil;
  end;
 end;
end;

function tdbcalendardatetimeedit.createdatalist(const sender: twidgetcol): tdatalist;
begin
 result:= nil;
end;

procedure tdbcalendardatetimeedit.griddatasourcechanged;
begin
 fdatalink.griddatasourcechanged;
end;

function tdbcalendardatetimeedit.getgriddatasource: tdatasource;
begin
 result:= tcustomdbwidgetgrid(fgridintf.getcol.grid).datasource;
end;

procedure tdbcalendardatetimeedit.getfieldtypes(out propertynames: stringarty; 
                    out fieldtypes: fieldtypesarty);
begin
 propertynames:= nil;
 setlength(fieldtypes,1);
 fieldtypes[0]:= datetimefields;
end;

function tdbcalendardatetimeedit.nullcheckneeded(const newfocus: twidget): boolean;
begin
 result:= inherited nullcheckneeded(newfocus) and fdatalink.nullcheckneeded;
end;

function tdbcalendardatetimeedit.getdatasource(const aindex: integer): tdatasource;
begin
 result:= datasource;
end;

procedure tdbcalendardatetimeedit.recchanged;
begin
 fdatalink.recordchanged(nil);
end;

{
function tdbcalendardatetimeedit.checkvalue(const quiet: boolean = false): boolean;
begin
 result:= inherited checkvalue(quiet) and fdatalink.dataentered;
end;
}

procedure tdbcalendardatetimeedit.dochange;
begin
 fdatalink.dataentered;
 inherited;
end;

{ tcustomdbenumedit }

constructor tcustomdbenumedit.create(aowner: tcomponent);
begin
 fisdb:= true;
 fdatalink:= teditwidgetdatalink.create(idbeditfieldlink(self));
 inherited;
end;

destructor tcustomdbenumedit.destroy;
begin
 inherited;
 fdatalink.free;
end;

function tcustomdbenumedit.getdatafield: string;
begin
 result:= fdatalink.fieldname;
end;

procedure tcustomdbenumedit.setdatafield(const avalue: string);
begin
 fdatalink.fieldname:= avalue;
end;

function tcustomdbenumedit.getdatasource: tdatasource;
begin
 result:= fdatalink.datasource;
end;

procedure tcustomdbenumedit.setdatasource(const avalue: tdatasource);
begin
 fdatalink.setwidgetdatasource(avalue);
end;

procedure tcustomdbenumedit.modified;
begin
 fdatalink.modified;
 inherited;
end;

function tcustomdbenumedit.getoptionsedit: optionseditty;
begin
 result:= inherited getoptionsedit;
 fdatalink.updateoptionsedit(result);
 frame.readonly:= oe_readonly in result;
end;

procedure tcustomdbenumedit.valuetofield;
begin
 if value = -1 then begin
  fdatalink.field.clear;
 end
 else begin
  fdatalink.field.asinteger:= value;
 end;
end;

procedure tcustomdbenumedit.fieldtovalue;
begin
 if fdatalink.field.isnull then begin
  value:= fvaluedefault;
 end
 else begin
  value:= fdatalink.field.asinteger;
 end;
end;

function tcustomdbenumedit.getrowdatapo(const info: cellinfoty): pointer;
begin
 with info do begin
  if griddatalink <> nil then begin
   result:= tgriddatalink(griddatalink).
                    getintegerbuffer(fdatalink.field,cell.row);
   if result = nil then begin
    result:= @fvaluedefault;
   end;
  end
  else begin
   result:= @fvaluedefault;
//   result:= nil;
  end;
 end;
end;

function tcustomdbenumedit.createdatalist(const sender: twidgetcol): tdatalist;
begin
 result:= nil;
end;

procedure tcustomdbenumedit.griddatasourcechanged;
begin
 fdatalink.griddatasourcechanged;
end;

function tcustomdbenumedit.getgriddatasource: tdatasource;
begin
 result:= tcustomdbwidgetgrid(fgridintf.getcol.grid).datasource;
end;

procedure tcustomdbenumedit.getfieldtypes(out propertynames: stringarty; 
                    out fieldtypes: fieldtypesarty);
begin
 propertynames:= nil;
 setlength(fieldtypes,1);
 fieldtypes[0]:= integerfields;
end;

function tcustomdbenumedit.nullcheckneeded(const newfocus: twidget): boolean;
begin
 result:= inherited nullcheckneeded(newfocus) and fdatalink.nullcheckneeded;
end;

function tcustomdbenumedit.getdatasource(const aindex: integer): tdatasource;
begin
 result:= datasource;
end;

procedure tcustomdbenumedit.recchanged;
begin
 fdatalink.recordchanged(nil);
end;

{
function tcustomdbenumedit.checkvalue(const quiet: boolean = false): boolean;
begin
 result:= inherited checkvalue(quiet) and fdatalink.dataentered;
end;
}

procedure tcustomdbenumedit.dochange;
begin
 fdatalink.dataentered;
 inherited;
end;

{ tdbbooleantextedit }

constructor tdbbooleantextedit.create(aowner: tcomponent);
begin
 ftext_false:= 'F';
 ftext_true:= 'T';
 inherited;
 booltextchanged;
end;

procedure tdbbooleantextedit.booltextchanged;
begin
 with tenumdropdowncontroller(fdropdown) do begin
  cols.count:= 1;
  cols[0].count:= 2;
  cols[0][0]:= ftext_false;
  cols[0][1]:= ftext_true;
 end;
 formatchanged;
end;

procedure tdbbooleantextedit.settext_false(const avalue: msestring);
begin
 ftext_false:= avalue;
 booltextchanged;
end;

procedure tdbbooleantextedit.settext_true(const avalue: msestring);
begin
 ftext_true:= avalue;
 booltextchanged;
end;

procedure tdbbooleantextedit.valuetofield;
begin
 case inherited value of
  -1: fdatalink.field.clear;
  0: fdatalink.field.asboolean:= false;
  else fdatalink.field.asboolean:= true;
 end;
end;

procedure tdbbooleantextedit.fieldtovalue;
begin
 if fdatalink.field.isnull then begin
  inherited value:= -1;
 end
 else begin
  value:= fdatalink.field.asboolean;
 end;
end;

procedure tdbbooleantextedit.getfieldtypes(out propertynames: stringarty;
               out fieldtypes: fieldtypesarty);
begin
 propertynames:= nil;
 setlength(fieldtypes,1);
 fieldtypes[0]:= booleanfields;
end;

function tdbbooleantextedit.getrowdatapo(const info: cellinfoty): pointer;
begin
 with info do begin
  if griddatalink <> nil then begin
   result:= tgriddatalink(griddatalink).getbooleanbuffer(fdatalink.field,cell.row);
  end
  else begin
   result:= nil;
  end;
 end;
end;

function tdbbooleantextedit.getvalue: boolean;
begin
 result:= inherited value <> 0;
end;

procedure tdbbooleantextedit.setvalue(const avalue: boolean);
begin
 if avalue then begin
  inherited value:= 1;
 end
 else begin
  inherited value:= 0;
 end;
end;

{ tdbdropdowncol }

procedure tdbdropdowncol.setdatafield(const avalue: string);
begin
 if fdatafield <> avalue then begin
  fdatafield:= avalue;
  tdbdropdownlistcontroller(fowner).fdatalink.updatefields;
 end;
end;

function tdbdropdowncol.getdatasource(const aindex: integer): tdatasource;
begin
 if fowner is tdbdropdownlistcontroller then begin
  result:= tdbdropdownlistcontroller(fowner).datasource;
 end
 else begin
  result:= nil;
 end;
end;

procedure tdbdropdowncol.getfieldtypes(out propertynames: stringarty; 
                  out fieldtypes: fieldtypesarty);
begin
 propertynames:= nil;
 setlength(fieldtypes,1);
 fieldtypes[0]:= textfields;
end;

{ tdbdropdowncols }

function tdbdropdowncols.getitems(const index: integer): tdbdropdowncol;
begin
 result:= tdbdropdowncol(inherited getitems(index));
end;

function tdbdropdowncols.getcolclass: dropdowncolclassty;
begin
 result:= tdbdropdowncol;
end;

{ tdropdowndatalink }

constructor tdropdowndatalink.create(const aowner: tdbdropdownlistcontroller);
begin
 fowner:= aowner;
end;

procedure tdropdowndatalink.setvaluefieldname(const value: string);
begin
 if fvaluefieldname <> value then begin
  fvaluefieldname :=  value;
  updatefields;
 end;
end;

procedure tdropdowndatalink.setvaluefield(value: tfield);
begin
 if fvaluefield <> value then begin
  fvaluefield:= value;
  EditingChanged;
  RecordChanged(nil);
 end;
end;

procedure tdropdowndatalink.settextfield(value: tfield);
begin
 if ftextfield <> value then begin
  ftextfield:= value;
 end;
end;

procedure tdropdowndatalink.updatefields;
begin
 if Active and (fvaluefieldname <> '') then begin
  setvaluefield(datasource.dataset.fieldbyname(fvaluefieldname));
 end
 else begin
  setvaluefield(nil);
 end;
 with fowner do begin
  if active and (valuecol >= 0) and (valuecol < cols.count) and
            (tdbdropdowncol(cols[valuecol]).datafield <> '') then begin
   settextfield(datasource.dataset.fieldbyname(
             tdbdropdowncol(cols[valuecol]).datafield));
  end
  else begin
   settextfield(nil);
  end;
 end;
end;

procedure tdropdowndatalink.activechanged;
begin
 updatefields;
 inherited;
 with tdataedit1(fowner.fintf.getwidget) do begin
  if fgridintf <> nil then begin
   fgridintf.getcol.changed;
  end
  else begin
   valuetotext;
  end;
 end;
end;

procedure tdropdowndatalink.LayoutChanged;
begin
 updatefields;
 inherited;
end;

function tdropdowndatalink.getlookuptext(const key: integer): msestring;
var
 str1: string;
begin
 result:= '';
 if active and (fdscontroller <> nil) and 
        (fvaluefield <> nil) and (ftextfield <> nil) then begin
  dataset.disablecontrols;
  try
   str1:= dataset.bookmark;
   if fdscontroller.locate(key,fvaluefield,[]) = loc_ok then begin
    result:= getasmsestring(ftextfield,utf8);
   end;
   dataset.bookmark:= str1;
  finally
   dataset.enablecontrols;
  end;
 end;
end;

function tdropdowndatalink.getlookuptext(const key: int64): msestring;
var
 str1: string;
begin
 result:= '';
 if active and (fdscontroller <> nil) and 
        (fvaluefield <> nil) and (ftextfield <> nil) then begin
  dataset.disablecontrols;
  try
   str1:= dataset.bookmark;
   if fdscontroller.locate(key,fvaluefield,[]) = loc_ok then begin
    result:= getasmsestring(ftextfield,utf8);
   end;
   dataset.bookmark:= str1;
  finally
   dataset.enablecontrols;
  end;
 end;
end;

function tdropdowndatalink.getlookuptext(const key: msestring): msestring;
var
 str1: string;
begin
 result:= '';
 if active and (fdscontroller <> nil) and 
        (fvaluefield <> nil) and (ftextfield <> nil) then begin
  dataset.disablecontrols;
  try
   str1:= dataset.bookmark;
   if fdscontroller.locate(key,fvaluefield,[]) = loc_ok then begin
    result:= getasmsestring(ftextfield,utf8);
   end;
   dataset.bookmark:= str1;
  finally
   dataset.enablecontrols;
  end;
 end;
end;

{ tdbdropdownstringcol }

constructor tdbdropdownstringcol.create(const agrid: tcustomgrid; 
                             const aowner: tgridarrayprop);
begin
 fdatalink:= tfielddatalink.create;
 inherited;
end;

destructor tdbdropdownstringcol.destroy;
begin
 inherited;
 fdatalink.free;
end;

function tdbdropdownstringcol.getrowtext(const arow: integer): msestring;
var
 int1: integer;
 griddatalink1: tgriddatalink;
begin
 with fdatalink do begin
  if active and (field <> nil) then begin
   griddatalink1:= tdbdropdownlist(fgrid).fdatalink;
   int1:= griddatalink1.activerecord;
   griddatalink1.activerecord:= arow;
   result:= asmsestring;
   griddatalink1.activerecord:= int1;
  end
  else begin
   result:= '';
  end;
 end;
end;

{ tdropdownlistdatalink }

procedure tdropdownlistdatalink.recordchanged(afield: tfield);
begin
 inherited;
 with tdbdropdownlist(fgrid) do begin
  if isdatacell(ffocusedcell) then begin
   feditor.text:= tdbdropdownstringcol(datacols[ffocusedcell.col]).
               getrowtext(ffocusedcell.row);
  end;
 end;
end;

{ tdbdropdownlist }

constructor tdbdropdownlist.create(const acontroller: tdbdropdownlistcontroller;
                             acols: tdropdowncols);
var
 int1: integer;
begin
 fdatalink:= tdropdownlistdatalink.create(self,igriddatalink(self));
 inherited;
 include(fstate,gs_isdb);
 fzebra_step:= 0;
 fdatalink.datasource:= acontroller.datasource;
 fdatalink.buffercount:= acontroller.dropdownrowcount;
 int1:= fdatalink.recordcount;
 if int1 < 0 then begin
  int1:= 0;
 end;
 rowcount:= int1;
end;

destructor tdbdropdownlist.destroy;
begin
 inherited;
 fdatalink.free;
end;

procedure tdbdropdownlist.pagedown(const action: focuscellactionty = fca_focusin);
begin
 fdatalink.MoveBy(rowcount-1);
end;

procedure tdbdropdownlist.pageup(const action: focuscellactionty = fca_focusin);
begin
 fdatalink.MoveBy(-rowcount+1);
end;

procedure tdbdropdownlist.wheeldown(const action: focuscellactionty = fca_focusin);
begin
 fdatalink.MoveBy(wheelheight);
end;

procedure tdbdropdownlist.wheelup(const action: focuscellactionty = fca_focusin);
begin
 fdatalink.MoveBy(-wheelheight);
end;

procedure tdbdropdownlist.rowdown(const action: focuscellactionty = fca_focusin);
begin
 fdatalink.MoveBy(1);
end;

procedure tdbdropdownlist.rowup(const action: focuscellactionty = fca_focusin);
begin
 fdatalink.MoveBy(-1);
end;

procedure tdbdropdownlist.internalcreateframe;
begin
 tdbgridframe.create(iscrollframe(self),self,iautoscrollframe(self));
end;

procedure tdbdropdownlist.createdatacol(const index: integer; out item: tdatacol);
begin
 item:= tdbdropdownstringcol.create(self,fdatacols);
end;

procedure tdbdropdownlist.initcols(const acols: tdropdowncols);
var
 int1: integer;
 dbstrcol1: tdbdropdownstringcol;
 datasource1: tdatasource;
begin
 inherited;
 datasource1:= tdbdropdownlistcontroller(fcontroller).datasource;
 for int1:= 0 to fdatacols.count - 1 do begin
  dbstrcol1:= tdbdropdownstringcol(fdatacols[int1]);
  with tdbdropdowncol(acols[int1]) do begin
   dbstrcol1.fdatalink.datasource:= datasource1;
   dbstrcol1.fdatalink.fieldname:= datafield;
  end;
 end;
end;

procedure tdbdropdownlist.docellevent(var info: celleventinfoty);
begin
 inherited;
 fdatalink.cellevent(info);
end;

procedure tdbdropdownlist.scrollevent(sender: tcustomscrollbar; event: scrolleventty);
begin
 if not fdatalink.scrollevent(sender,event) then begin
  inherited;
 end;
end;

function tdbdropdownlist.locate(const filter: msestring): boolean;
begin
 result:= false;
 if (datacols.count > 0) then begin
  with tdbdropdownstringcol(datacols[0]).fdatalink do begin
   if (dscontroller <> nil) and (field <> nil) then begin
    result:= dscontroller.locate(filter,field,[loo_caseinsensitive]) = loc_ok;
    if not result then begin
     result:= dscontroller.locate(filter,field,
                        [loo_caseinsensitive,loo_partialkey]) = loc_ok;
    end;
    if result then begin
     dataset.resync([rmcenter]);
    end;
   end;
  end;
 end;
 if not result then begin
  focuscell(makegridcoord(ffocusedcell.col,-1));
 end;
end;

procedure tdbdropdownlist.dopaint(const acanvas: tcanvas);
begin
 inherited;
 fdatalink.painted;
end;

function tdbdropdownlist.getdbindicatorcol: integer;
begin
 result:= 0; //none
end;

{ tdbdropdownlistcontroller }

constructor tdbdropdownlistcontroller.create(const intf: idbdropdownlist;
                      const aisstringkey: boolean);
begin
 fisstringkey:= aisstringkey;
 foptionsdatalink:= defaultdropdowndatalinkoptions;
 fdatalink:= tdropdowndatalink.create(self);
 inherited create(intf);
 options:= defaultdbdropdownoptions;
end;

destructor tdbdropdownlistcontroller.destroy;
begin
 inherited;
 fdatalink.free;
end;

function tdbdropdownlistcontroller.getdatasource: tdatasource;
begin
 result:= fdatalink.datasource;
end;

procedure tdbdropdownlistcontroller.setdatasource(const avalue: tdatasource);
begin
 fdatalink.datasource:= avalue;
end;

procedure tdbdropdownlistcontroller.setkeyfield(const avalue: string);
begin
 fdatalink.valuefieldname:= avalue;
end;

function tdbdropdownlistcontroller.getkeyfield: string;
begin
 result:= fdatalink.valuefieldname;
end;

function tdbdropdownlistcontroller.getcols: tdbdropdowncols;
begin
 result:= tdbdropdowncols(fcols);
end;

procedure tdbdropdownlistcontroller.setcols(const avalue: tdbdropdowncols);
begin
 fcols.assign(avalue);
end;

function tdbdropdownlistcontroller.getbuttonframeclass: dropdownbuttonframeclassty;
begin
 result:= tdropdownbuttonframe;
end;

procedure tdbdropdownlistcontroller.valuecolchanged;
begin
 inherited;
 fdatalink.updatefields;
end;

function tdbdropdownlistcontroller.getdropdowncolsclass: dropdowncolsclassty;
begin
 result:= tdbdropdowncols;
end;

function tdbdropdownlistcontroller.createdropdownlist: tdropdownlist;
type
 pmsestringaarty = array of pmsestringaty;
var
 int1,int2: integer;
 datas: tdataset;
 ar1: fieldarty;
 ar2: pmsestringaarty;
 bm: string;
begin
 if odb_copyitems in foptionsdb then begin
  fcols.clear;
  datas:= fdatalink.dataset;
  if (datas <> nil) and datas.active then begin
   setlength(ar1,fcols.count);
   setlength(ar2,fcols.count);
   for int1:= 0 to high(ar1) do begin
    setlength(fbookmarks,datas.recordcount);
    with cols[int1] do begin
     count:= length(fbookmarks);     //max
     ar2[int1]:= datapo;
     ar1[int1]:= datas.fieldbyname(datafield);
    end;
   end;
   datas.disablecontrols;
   try
    bm:= datas.bookmark;
    try
     int2:= 0;
     datas.first;
     while not datas.eof do begin
      fbookmarks[int2]:= datas.bookmark;
      for int1:= 0 to high(ar1) do begin
       ar2[int1]^[int2]:= getasmsestring(ar1[int1],fdatalink.utf8);
      end; 
      inc(int2);
      datas.next;
     end;
     for int1:= 0 to cols.count-1 do begin
      cols[int1].count:= int2;
     end;
     setlength(fbookmarks,int2);
    finally
     datas.bookmark:= bm;
    end;   
   finally
    datas.enablecontrols;
   end;
  end;
  result:= tdropdownlist.create(self,fcols);
 end
 else begin
  result:= tdbdropdownlist.create(self,fcols);
  with tdbdropdownlist(result) do begin
   fdatalink.options:= foptionsdatalink;
   if gdo_propscrollbar in fdatalink.options then begin
    with frame.sbvert do begin
     pagesize:= 1;
     {
     if rowcount > 0 then begin
      pagesize:= rowcount / rowcount; //???
     end
     else begin
      pagesize:= 1;
     end;
     }
    end;
   end;
  end;
 end;
end;

function tdbdropdownlistcontroller.candropdown: boolean;
begin
 result:= inherited candropdown and fdatalink.active;
end;

procedure tdbdropdownlistcontroller.itemselected(const index: integer;
                                                          const akey: keyty);
begin
 if index < 0 then begin
  if index = -2 then begin
   tdropdowncols1(fcols).fitemindex:= -1;
  end;
 end
 else begin
  if odb_copyitems in foptionsdb then begin
   fdatalink.dataset.bookmark:= fbookmarks[index];
  end;
  tdropdowncols1(fcols).fitemindex:= index;
 end;
 if odb_copyitems in foptionsdb then begin
  cols.clear;
  fbookmarks:= nil;
 end;
 idbdropdownlist(fintf).recordselected(index,akey);
end;

procedure tdbdropdownlistcontroller.getfieldtypes(out propertynames: stringarty; 
                    out fieldtypes: fieldtypesarty);
begin
 setlength(propertynames,1);
 propertynames[0]:= 'keyfield';
 setlength(fieldtypes,1);
 if fisstringkey then begin
  fieldtypes[0]:= textfields;
 end
 else begin
  fieldtypes[0]:= integerfields;
 end; 
end;

function tdbdropdownlistcontroller.getdatasource(const aindex: integer): tdatasource;
begin
 result:= datasource;
end;

{ not possible, dropdownlist must work
procedure tdbdropdownlistcontroller.dobeforedropdown;
begin
 if (datasource <> nil) and (datasource.dataset <> nil) then begin
  datasource.dataset.disablecontrols;
 end;
 inherited;
end;

procedure tdbdropdownlistcontroller.doafterclosedropdown;
begin
 try
  inherited;
 finally
  if (datasource <> nil) and (datasource.dataset <> nil) then begin
   datasource.dataset.enablecontrols;
  end;
 end;
end;
}
{ tdbenumeditdb }

function tdbenumeditdb.getdropdown: tdbdropdownlistcontroller;
begin
 result:= tdbdropdownlistcontroller(inherited dropdown);
end;

procedure tdbenumeditdb.setdropdown(const avalue: tdbdropdownlistcontroller);
begin
 inherited dropdown.assign(avalue);
end;

function tdbenumeditdb.createdropdowncontroller: tcustomdropdowncontroller;
begin
 result:= tdbdropdownlistcontroller.create(idbdropdownlist(self),false);
end;

procedure tdbenumeditdb.recordselected(const arecordnum: integer; const akey: keyty);
var
 bo1: boolean;
begin
 bo1:= false;
 if arecordnum >= 0 then begin
  with tdbdropdownlistcontroller(fdropdown) do begin
   text:= getasmsestring(fdatalink.textfield,fdatalink.utf8);
   tdropdowncols1(fcols).fitemindex:= fdatalink.valuefield.asinteger
  end; 
  bo1:= checkvalue;
 end
 else begin
  if arecordnum = -2 then begin
   bo1:= checkvalue; 
  end
  else begin
   feditor.undo;
  end;
 end;
 if bo1 and (akey = key_tab) then begin
  window.postkeyevent(akey);
 end;
end;

function tdbenumeditdb.internaldatatotext(const data): msestring;
var
 int1: integer;
begin
 if @data = nil then begin
  int1:= value;  
 end
 else begin
  int1:= integer(data);
 end;
 result:= tdbdropdownlistcontroller(fdropdown).fdatalink.getlookuptext(int1);
end;

{ tenumeditdb }

function tenumeditdb.getdropdown: tdbdropdownlistcontroller;
begin
 result:= tdbdropdownlistcontroller(inherited dropdown);
end;

procedure tenumeditdb.setdropdown(const avalue: tdbdropdownlistcontroller);
begin
 inherited dropdown.assign(avalue);
end;

function tenumeditdb.createdropdowncontroller: tcustomdropdowncontroller;
begin
 result:= tdbdropdownlistcontroller.create(idbdropdownlist(self),false);
end;

procedure tenumeditdb.recordselected(const arecordnum: integer; const akey: keyty);
var
 bo1: boolean;
begin
 bo1:= false;
 if arecordnum >= 0 then begin
  with tdbdropdownlistcontroller(fdropdown) do begin
   text:= getasmsestring(fdatalink.textfield,fdatalink.utf8);
   tdropdowncols1(fcols).fitemindex:= fdatalink.valuefield.asinteger
  end; 
  bo1:= checkvalue;
 end
 else begin
  if arecordnum = -2 then begin
   bo1:= checkvalue; 
  end
  else begin
   feditor.undo;
  end;
 end;
 if bo1 and (akey = key_tab) then begin
  window.postkeyevent(akey);
 end;
end;

function tenumeditdb.internaldatatotext(const data): msestring;
var
 int1: integer;
begin
 if @data = nil then begin
  int1:= value;  
 end
 else begin
  int1:= integer(data);
 end;
 result:= tdbdropdownlistcontroller(fdropdown).fdatalink.getlookuptext(int1);
end;

{ tdbkeystringeditdb }

function tdbkeystringeditdb.getdropdown: tdbdropdownlistcontroller;
begin
 result:= tdbdropdownlistcontroller(inherited dropdown);
end;

procedure tdbkeystringeditdb.setdropdown(const avalue: tdbdropdownlistcontroller);
begin
 inherited dropdown.assign(avalue);
end;

function tdbkeystringeditdb.createdropdowncontroller: tcustomdropdowncontroller;
begin
 result:= tdbdropdownlistcontroller.create(idbdropdownlist(self),true);
end;

procedure tdbkeystringeditdb.recordselected(const arecordnum: integer;
                                                            const akey: keyty);
var
 bo1: boolean;
begin
 bo1:= false;
 if arecordnum >= 0 then begin
  with tdbdropdownlistcontroller(fdropdown) do begin
   text:= getasmsestring(fdatalink.textfield,fdatalink.utf8);
   tdropdowncols1(fcols).fkeyvalue:= getasmsestring(fdatalink.valuefield,
                                                         fdatalink.utf8);
  end; 
  bo1:= checkvalue;
 end
 else begin
  if arecordnum = -2 then begin
   bo1:= checkvalue; 
  end
  else begin
   feditor.undo;
  end;
 end;
 if bo1 and (akey = key_tab) then begin
  window.postkeyevent(akey);
 end;
end;

function tdbkeystringeditdb.internaldatatotext(const data): msestring;
var
 mstr1: msestring;
begin
 if @data = nil then begin
  mstr1:= value;  
 end
 else begin
  mstr1:= msestring(data);
 end;
 result:= tdbdropdownlistcontroller(fdropdown).fdatalink.getlookuptext(mstr1);
end;

{ tkeystringeditdb }

function tkeystringeditdb.getdropdown: tdbdropdownlistcontroller;
begin
 result:= tdbdropdownlistcontroller(inherited dropdown);
end;

procedure tkeystringeditdb.setdropdown(const avalue: tdbdropdownlistcontroller);
begin
 inherited dropdown.assign(avalue);
end;

function tkeystringeditdb.createdropdowncontroller: tcustomdropdowncontroller;
begin
 result:= tdbdropdownlistcontroller.create(idbdropdownlist(self),true);
end;

procedure tkeystringeditdb.recordselected(const arecordnum: integer;
                                                    const akey: keyty);
var
 bo1: boolean;
begin
 if arecordnum >= 0 then begin
  with tdbdropdownlistcontroller(fdropdown) do begin
   text:= getasmsestring(fdatalink.textfield,fdatalink.utf8);
   tdropdowncols1(fcols).fkeyvalue:= getasmsestring(fdatalink.valuefield,
                                                      fdatalink.utf8);
  end; 
  bo1:= checkvalue;
 end
 else begin
  if arecordnum = -2 then begin
   bo1:= checkvalue; 
  end
  else begin
   feditor.undo;
  end;
 end;
 if bo1 and (akey = key_tab) then begin
  window.postkeyevent(akey);
 end;
end;

function tkeystringeditdb.internaldatatotext(const data): msestring;
var
 mstr1: msestring;
begin
 if @data = nil then begin
  mstr1:= value;  
 end
 else begin
  mstr1:= msestring(data);
 end;
 result:= tdbdropdownlistcontroller(fdropdown).fdatalink.getlookuptext(mstr1);
end;

{ tgriddatalink }

constructor tgriddatalink.create(const aowner: tcustomgrid; const aintf: igriddatalink);
begin
 fintf:= aintf;
 fgrid:= aowner;
 include(tcustomgrid1(fgrid).fstate,gs_isdb);
 inherited create;
 visualcontrol:= true;
end;

destructor tgriddatalink.destroy;
begin
 inherited;
 fobjectlinker.free;
end;

procedure tgriddatalink.setdatafield(const avalue: string);
begin
 fieldname:= avalue;
end;

function tgriddatalink.getdatafield: string;
begin
 result:= fieldname;
end;

function tgriddatalink.getfirstrecord: integer;
begin
 result:= inherited firstrecord;
end;

procedure tgriddatalink.doupdaterowdata(const row: integer);

 procedure fieldtorowstate(const arow: integer);
 var
  int1: integer;
 begin
  if field.isnull then begin
   fgrid.rowcolorstate[arow]:= -1;
   fgrid.rowfontstate[arow]:= -1;
   fgrid.rowreadonlystate[arow]:= false;
  end
  else begin
   int1:= field.asinteger;
   fgrid.rowcolorstate[arow]:= rowstatenumty(int1 and $7f);
   fgrid.rowreadonlystate[arow]:= rowstatenumty(int1 and $80) <> 0;
   fgrid.rowfontstate[arow]:= rowstatenumty((int1 shr 8) and $7f);
  end;
 end;
 
var
 int1,int2: integer;
 dataset1: tdataset;
begin
 if (fgrid.componentstate * [csloading,csdesigning,csdestroying] = []) and 
                 (row < fgrid.rowcount) then begin
  dataset1:= dataset;
  if dataset1 <> nil then begin
   if field <> nil then begin
    if row >= 0 then begin
     fieldtorowstate(row);
    end
    else begin
     int2:= activerecord;
     try
      for int1:= 0 to fgrid.rowhigh do begin
       activerecord:= int1;
       fieldtorowstate(int1);
      end;
     finally
      activerecord:= int2;
     end;
    end;
   end;
   if assigned(fonupdaterowdata) then begin
    if row >= 0 then begin
     fonupdaterowdata(fgrid,row,dataset1);
    end
    else begin
     int2:= activerecord;
     try
      for int1:= 0 to fgrid.rowhigh do begin
       activerecord:= int1;
       fonupdaterowdata(fgrid,int1,dataset1);
      end;
     finally
      activerecord:= int2;
     end;
    end;
   end; 
  end;
 end;
end;

function tgriddatalink.hasdata: boolean;
begin
 result:= active and (recordcount > 0);
end;

function tgriddatalink.getrowfieldisnull(const afield: tfield; 
                             const row: integer): boolean;
var
 int1: integer;
begin
 result:= true;
 if (afield <> nil) and hasdata then begin
  int1:= activerecord;
  activerecord:= row;
  result:= afield.isnull;
  activerecord:= int1;
 end;
end;

function tgriddatalink.getansistringbuffer(const afield: tfield;
                                                  const row: integer): pointer;
var
 int1: integer;
begin
 result:= nil;
 if (afield <> nil) and hasdata then begin
  int1:= activerecord;
  activerecord:= row;
  if not afield.isnull then begin
   result:= @fansistringbuffer;
   fansistringbuffer:= afield.asstring;
  end;
  activerecord:= int1;
 end;
end;

function tgriddatalink.getstringbuffer(const afield: tfield;
                      const row: integer): pointer;
var
 int1: integer;
begin
 result:= nil;
 if (afield <> nil) and hasdata then begin
  int1:= activerecord;
  activerecord:= row;
  if not afield.isnull then begin
   result:= @fstringbuffer;
   if afield is tmsestringfield then begin
    fstringbuffer:= tmsestringfield(afield).asmsestring;
   end
   else begin
    if utf8 and (afield.datatype in textfields) then begin
     fstringbuffer:= utf8tostring(afield.asstring);
    end
    else begin
     fstringbuffer:= afield.asstring;
    end;
   end;
  end;
  activerecord:= int1;
 end;
end;

function tgriddatalink.getdisplaystringbuffer(const afield: tfield;
                      const row: integer{; const aedit: boolean}): pointer;
var
 int1: integer;
// str1: ansistring;
begin
 result:= nil;
 if (afield <> nil) and hasdata then begin
  int1:= activerecord;
  activerecord:= row;
  if not afield.isnull then begin
   result:= @fstringbuffer;
   if afield is tmsestringfield then begin
    fstringbuffer:= tmsestringfield(afield).asmsestring;
   end
   else begin
    if afield is tmsememofield then begin
     fstringbuffer:= tmsememofield(afield).asmsestring;
    end
    else begin
    {
     if aedit then begin
      str1:= afield.text;
     end
     else begin
      str1:= afield.displaytext;
     end;
     }
     if utf8 and (afield.datatype in textfields) then begin
      fstringbuffer:= utf8tostring(afield.displaytext);
     end
     else begin
      fstringbuffer:= afield.displaytext;
     end;
    end;
   end;
  end;
  activerecord:= int1;
 end;
end;

function tgriddatalink.getbooleanbuffer(const afield: tfield; 
                                             const row: integer): pointer;
var
 int1: integer;
begin
 result:= nil;
 if (afield <> nil) and hasdata then begin
  int1:= activerecord;
  activerecord:= row;
  if not afield.isnull then begin
   result:= @fintegerbuffer;
   fintegerbuffer:= integer(afield.asboolean);
  end;
  activerecord:= int1;
 end;
end;

function tgriddatalink.getintegerbuffer(const afield: tfield;
                     const row: integer): pointer;
var
 int1: integer;
begin
 result:= nil;
 if (afield <> nil) and hasdata then begin
  int1:= activerecord;
  activerecord:= row;
  if not afield.isnull then begin
   result:= @fintegerbuffer;
   fintegerbuffer:= afield.asinteger;
  end;
  activerecord:= int1;
 end;
end;

function tgriddatalink.getint64buffer(const afield: tfield;
                     const row: integer): pointer;
var
 int1: integer;
begin
 result:= nil;
 if (afield <> nil) and hasdata then begin
  int1:= activerecord;
  activerecord:= row;
  if not afield.isnull then begin
   result:= @fint64buffer;
   fint64buffer:= afield.aslargeint;
  end;
  activerecord:= int1;
 end;
end;

function tgriddatalink.getrealtybuffer(const afield: tfield; 
                                             const row: integer): pointer;
var
 int1: integer;
begin
 result:= nil;
 if (afield <> nil) and hasdata then begin
  int1:= activerecord;
  activerecord:= row;
  if not afield.isnull then begin
   result:= @frealtybuffer;
   frealtybuffer:= afield.asfloat;
  end;
  activerecord:= int1;
 end;
end;

function tgriddatalink.getdatetimebuffer(const afield: tfield;
                                              const row: integer): pointer;
var
 int1: integer;
begin
 result:= nil;
 if (afield <> nil) and hasdata then begin
  int1:= activerecord;
  activerecord:= row;
  if not afield.isnull then begin
   result:= @frealtybuffer;
   frealtybuffer:= afield.asdatetime;
  end;
  activerecord:= int1;
 end;
end;

procedure tgriddatalink.updatelayout;
var
 int1: integer;
begin
 int1:= fgrid.rowsperpage;
 if int1 = 0 then begin
  int1:= 1;
 end;
 BufferCount:= int1;
 if active then begin
  forcecalcrange;
  checkscroll;
 end;
 updaterowcount;
 checkscrollbar;
end;

procedure tgriddatalink.updaterowcount;
var
 int1: integer;
begin
 if not (csdestroying in fgrid.componentstate) then begin
  if active then begin
   int1:= recordcount;
  end
  else begin
   int1:= 0;
  end;
  fgrid.rowcount:= int1;
 end;
end;

procedure tgriddatalink.datasetchanged;
var
// bo1: boolean;
 state1: tdatasetstate;
begin
 if fdatasetchangedlock = 0 then begin
  finserting:= (dataset <> nil) and (dataset.state = dsinsert);
  if recordcount > fgrid.rowcount then begin
   updaterowcount;  //for append
  end;
  inherited;
  gridinvalidate;
  if finserting and not finsertingbefore and (fgrid.datacols.newrowcol >= 0) then begin
   fgrid.col:= fgrid.datacols.newrowcol;
  end;
  finsertingbefore:= finserting;
 end;
end;

procedure tgriddatalink.datasetscrolled(distance: integer);
begin
 ffirstrecordbefore:= firstrecord - distance;
 recordchanged(nil);
end;

procedure tgriddatalink.forcecalcrange;
begin
 inc(fdatasetchangedlock);
 try
  dataevent(dedatasetchange,0); //force tdatalink.calcrange
 finally
  dec(fdatasetchangedlock);
 end;
end;

procedure tgriddatalink.activechanged;
begin
 inherited;
 if not active then begin
  fzebraoffset:= 0;
  factiverecordbefore:= 0;
  ffirstrecordbefore:= 0;
  fdatasetstatebefore:= dsinactive;
  fdscontroller:= nil;
  inherited firstrecord:= 0;
 end;
 updaterowcount;
 checkscroll;
 gridinvalidate;
 checkscrollbar;
 if active then begin
  forcecalcrange;
  if (fgrid.rowcount > 0) then begin
   if (fgrid.col < 0) and (fgrid.entered) then begin
    fgrid.focuscell(makegridcoord(fgrid.col,activerecord),fca_entergrid);
   end
   else begin
    fgrid.focuscell(makegridcoord(fgrid.col,activerecord));
   end;
  end;
  factiverecordbefore:= activerecord;
 end;
end;

procedure tgriddatalink.checkscroll;
var
 rect1: rectty;
 distance: integer;
 rowbefore: integer;
 
begin
 if active and (gs_needszebraoffset in tcustomgrid1(fgrid).fstate) then begin
  fzebraoffset:= -(arecord - activerecord);
 end
 else begin
  fzebraoffset:= 0;
 end;
 distance:= firstrecord - ffirstrecordbefore;
 ffirstrecordbefore:= firstrecord;
 with tcustomgrid1(fgrid) do begin
  rowbefore:= row;
  if distance <> 0 then begin
   inc(frowexited);
   row:= invalidaxis;
  end;
  if (abs(distance) >= rowcount) then begin
   gridinvalidate;
  end
  else begin
   if (distance <> 0) then begin
    if not fgridinvalidated then begin
     rect1:= fdatarecty;
     rect1.cy:= rowhigh*ystep;
     if rowbefore = 0 then begin
      inc(rect1.y,ystep);
     end;
     if testintersectrect(rect1,updaterect) then begin
      invalidaterect(rect1,org_client); //scrolling not possible
     end
     else begin
      dec(factiverecordbefore,distance);
      scrollrect(makepoint(0,-distance*ystep),rect1,true);
     end;
    end;
    doupdaterowdata(-1);
   end;
  end;
  if (activerecord < rowcount) and 
                 not (csdestroying in componentstate) then begin
   inc(fnocheckvalue);
   try
    row:= activerecord;
   finally
    dec(fnocheckvalue);
   end;
  end;
 end;
end;

procedure tgriddatalink.recordchanged(afield: tfield);
var
 int1: integer;
begin
 int1:= frowexited;
 if tcustomgrid1(fgrid).fcellvaluechecking = 0 then begin
  checkscroll;
 end;
 fgrid.invalidaterow(activerecord);
 tcustomgrid1(fgrid).beginnonullcheck;
 tcustomgrid1(fgrid).beginnocheckvalue;
 try
  if (afield = nil) and (frowexited = int1) and (feditingbefore = editing) then begin
   fgrid.row:= invalidaxis;
  end;
  int1:= activerecord;
  if (int1 < fgrid.rowcount) and active and  
                (tcustomgrid1(fgrid).fcellvaluechecking = 0) then begin
   fgrid.row:= int1; //else empty dataset
  end;
 finally
  tcustomgrid1(fgrid).endnonullcheck;
  tcustomgrid1(fgrid).endnocheckvalue;
  feditingbefore:= editing;
 end;
 fgrid.invalidaterow(factiverecordbefore);
 factiverecordbefore:= activerecord;
 if afield = nil then begin
  updaterowcount;
  checkscrollbar;
 end;
 doupdaterowdata(activerecord);
end;

function tgriddatalink.arecord: integer;
begin
 if fdscontroller <> nil then begin
  result:= fdscontroller.recnonullbased;
 end
 else begin
  result:= dataset.recno;
 end;
end;

function tgriddatalink.rowtorecnonullbased(const row: integer): integer;
begin
 if active then begin
  result:= recnonullbased + row - activerecord;
 end
 else begin
  result:= -1;
 end;
end;

procedure tgriddatalink.checkscrollbar;
var
 rea1: real;
 int1: integer;
begin 
 rea1:= 0.5;
 if active then begin
  int1:= dataset.recordcount - 1;
  if bof then begin
   rea1:= 0;
  end
  else begin
   if eof then begin
    rea1:= 1;
   end
   else begin
    if (gdo_propscrollbar in foptions) and (int1 > 0) then begin
     rea1:= arecord / int1;
    end;
   end;
  end;
  if int1 < 0 then begin
   int1:= 0
  end;
  fgrid.frame.sbvert.pagesize:= fgrid.rowcount / (int1+1+fgrid.rowcount);
 end
 else begin
  fgrid.frame.sbvert.pagesize:= 1;
 end;
 fgrid.frame.sbvert.value:= rea1;
end;

procedure tgriddatalink.cellevent(var info: celleventinfoty);
var
 int1: integer;
begin
 with info do begin
  if (eventkind = cek_enter) and active then begin
   int1:= newcell.row-activerecord;
   if int1 <> 0 then begin
    moveby(int1);
   end;
  end;
 end;
end;

procedure tgriddatalink.invalidateindicator;
var
 int1,int2: integer;
begin
 int1:= fintf.getdbindicatorcol;
 int2:= activerecord;
 if (int1 < 0) and (int2 >= 0) then begin
  fgrid.invalidatecell(makegridcoord(int1,int2));
 end;
end;

function tgriddatalink.scrollevent(sender: tcustomscrollbar;
                          event: scrolleventty): boolean;
             //true if processed
var
 int1,int2: integer;
begin
 result:= true;
 if sender.tag = 1 then begin
  with fgrid do begin
   case event of
    sbe_stepup: rowdown(fca_focusin);
    sbe_stepdown: rowup(fca_focusin);
    sbe_pageup: pagedown(fca_focusin);
    sbe_pagedown: pageup(fca_focusin);
    sbe_wheelup: wheeldown(fca_focusin);
    sbe_wheeldown: wheelup(fca_focusin);
    {sbe_thumbtrack,}sbe_valuechanged: begin end;
    sbe_thumbtrack,sbe_thumbposition: begin
     if (event <> sbe_thumbtrack) or (gdo_thumbtrack in foptions) then begin
      if self.active then begin
       if (sender.value = 0) then begin
        if not dataset.bof then begin
         dataset.first;
        end;
       end
       else begin
        if sender.value >= 1.0 then begin
         if not dataset.eof then begin
          dataset.last
         end;
        end
        else begin
         if not dataset.filtered and (gdo_propscrollbar in foptions) then begin
          int1:= dataset.recordcount;
          if int1 >= 0 then begin
           int2:= round(int1 * sender.value)+1;
                    //are recnos allways 1-based?
           if (int2 >= int1) then begin
            if not dataset.eof then begin
             dataset.last;
            end;
           end
           else begin
            if dscontroller = nil then begin
             dataset.recno:= int2;
            end
            else begin
             dscontroller.recno:= int2; //use cached recno
            end;
           end;
          end;
         end
         else begin
          if event <> sbe_thumbtrack then begin
           if sender.value < 0.5 then begin
            moveby(-fgrid.rowhigh);
           end
           else begin
            moveby(fgrid.rowhigh);
           end;
           sender.value:= 0.5;
          end;
         end;
        end;
       end;
      end
      else begin
       if event <> sbe_thumbtrack then begin
        sender.value:= 0.5;
       end;
      end;
     end
    end;
    else result:= false;
   end;
  end;
 end
 else begin
  result:= false;
 end;
end;

procedure tgriddatalink.doinsertrow;
begin
 if active and checkvalue then begin
  dataset.insert;
  with fgrid,datacols do begin
   if newrowcol >= 0 then begin
    focuscell(makegridcoord(newrowcol,row));
   end;
  end;
 end;
end;

procedure tgriddatalink.doappendrow;
begin
 if active and checkvalue then begin
  if not eof then begin
   moveby(1);
  end;
  if not eof then begin
   dataset.insert;
  end
  else begin
   dataset.append;
  end;
  with fgrid,datacols do begin
   if newrowcol >= 0 then begin
    focuscell(makegridcoord(newrowcol,row));
   end;
  end;
 end;
end;

procedure tgriddatalink.dodeleterow;
begin
 if active and confirmdeleterecord then begin
  dataset.delete;
 end;
end;

procedure tgriddatalink.rowdown;
begin
 if checkvalue then begin
  moveby(1);
  if (og_autoappend in tcustomgrid1(fgrid).foptionsgrid) and active and eof then begin
   dataset.append;
   with fgrid,datacols do begin
    if newrowcol >= 0 then begin
     focuscell(makegridcoord(newrowcol,row));
    end;
   end;
  end;
 end;
end;

procedure tgriddatalink.lastrow;
begin
 if active and checkvalue then begin
  dataset.last;
 end;
end;

procedure tgriddatalink.firstrow;
begin
 if active and checkvalue then begin
  dataset.first;
 end;
end;

function tgriddatalink.getzebrastart: integer;
begin
 result:= tcustomgrid1(fgrid).fzebra_start + fzebraoffset;
end;

procedure tgriddatalink.gridinvalidate;
begin
 if not fgridinvalidated then begin
  fgrid.invalidate;
  fgridinvalidated:= true;
  application.postevent(tobjectevent.create(ek_dbupdaterowdata,ievent(self)));
 end;
end;

procedure tgriddatalink.painted;
begin
 fgridinvalidated:= false;
end;

procedure tgriddatalink.loaded;
begin
 doupdaterowdata(-1);
end;

function tgriddatalink.checkvalue: boolean;
begin
 if editing then begin
  result:= fgrid.canparentclose;
 end
 else begin
  result:= true;
 end;
end;

procedure tgriddatalink.beginnullchecking;
begin
 inc(fnullchecking);
 tcustomgrid1(fgrid).beginnullchecking;
end;

procedure tgriddatalink.endnullchecking;
begin
 tcustomgrid1(fgrid).endnullchecking;
 dec(fnullchecking);
end;

function tgriddatalink.moveby(distance: integer): integer;
begin
 invalidateindicator; //grid can be defocused
 result:= 0;
 if fnullchecking = 0 then begin
  beginnullchecking;
  try
   if checkvalue then begin
    result:= inherited moveby(distance);
   end
   else begin
    tcustomgrid1(fgrid).beginnonullcheck;
    try
     fgrid.row:= activerecord;
    finally
     tcustomgrid1(fgrid).endnonullcheck;
    end;
   end;
  finally
   endnullchecking;
  end;
 end;
end;

function tgriddatalink.getobjectlinker: tobjectlinker;
begin
 if fobjectlinker = nil then begin
  createobjectlinker(ievent(self),nil,fobjectlinker);
 end;
 result:= fobjectlinker;
end;

procedure tgriddatalink.link(const source,dest: iobjectlink; valuepo: pointer = nil;
                            ainterfacetype: pointer = nil; once: boolean = false);
begin
 getobjectlinker.link(source,dest,valuepo,ainterfacetype,once);
end;

procedure tgriddatalink.unlink(const source,dest: iobjectlink; valuepo: pointer = nil);
begin
 getobjectlinker.unlink(source,dest,valuepo);
end;

procedure tgriddatalink.objevent(const sender: iobjectlink;
                 const event: objecteventty);
begin
 getobjectlinker.objevent(sender,event);
end;

function tgriddatalink.getinstance: tobject;
begin
 result:= self;
end;

procedure tgriddatalink.receiveevent(const event: tobjectevent);
begin
 case event.kind of
  ek_dbedit: begin
   edit;
  end;
  ek_dbupdaterowdata: begin
   doupdaterowdata(-1);
  end;
 end;
end;

procedure tgriddatalink.updatedata;
begin
 beginnullchecking;
 tcustomgrid1(fgrid).beginnonullcheck;
 try 
  if checkvalue then begin
   inherited;
  end
  else begin
   abort;
  end;
 finally
  tcustomgrid1(fgrid).endnonullcheck;
  endnullchecking;
 end;
end;

function tgriddatalink.getdatasource(const aindex: integer): tdatasource;
begin
 result:= datasource;
end;

procedure tgriddatalink.getfieldtypes(out propertynames: stringarty;
               out fieldtypes: fieldtypesarty);
begin
 propertynames:= nil;
 setlength(fieldtypes,1);
 fieldtypes[0]:= integerfields;
end;

procedure tgriddatalink.beforefocuscell(const cell: gridcoordty;
                             const selectaction: focuscellactionty);
begin
 if (selectaction = fca_entergrid) and active and (recordcount = 0) and
                (og_autofirstrow in fgrid.optionsgrid) then begin
  dataset.insert;
 end;
end;

function tgriddatalink.getdummystringbuffer: pansistring;
begin
 fdummystringbuffer:= '';
 result:= @fdummystringbuffer;
end;

function tgriddatalink.canclose(const newfocus: twidget): boolean;
begin
 result:= not (gdo_checkbrowsemodeonexit in foptions) or 
           (fgrid.widgetstate * [ws_entered,ws_exiting] = [])  or
           fgrid.checkdescendent(newfocus) or inherited canclose;
end;

procedure tgriddatalink.focuscell(var cell: gridcoordty);
var
 int1,int2,int3,int4: integer;
 ds1: tdataset;
begin
 if (cell.row >= 0) and (cell.row <> fgrid.row) then begin
  ds1:= dataset;
  if (ds1 <> nil) then begin
   int1:= rowtorecnonullbased(cell.row);
   if not (finserting and not finsertingbefore) then begin
    int3:= recnonullbased;
    if ds1.state <> dsfilter then begin
     ds1.checkbrowsemode;
    end;
    int4:= recnonullbased;
    if (int1 < int3) and (int1 >= int4) then begin
     inc(int1);
    end
    else begin
     if (int1 > int3) and (int1 <= int4) then begin
      dec(int1);
     end;
    end;
   end;
   int2:= ds1.recordcount;
   if (int1 >= 0) and (int1 < int2) and (ds1.state <> dsfilter) then begin
    invalidateindicator; //grid can be defocused
    dataset.moveby(int1-recnonullbased);
   end;
   cell.row:= activerecord;
  end;   
 end;
end;

procedure tgriddatalink.editingchanged;
begin
 invalidateindicator;
 inherited;
end;

{ tdbwidgetindicatorcol }

constructor tdbwidgetindicatorcol.create(const agrid: tcustomgrid;
                                            const aowner: tgridarrayprop);
begin
 fcolorindicator:= cl_glyph;
 inherited;
 width:= 15;
end;

procedure tdbwidgetindicatorcol.drawcell(const canvas: tcanvas);
begin
 with cellinfoty(canvas.drawinfopo^),tdbwidgetfixcols(prop) do begin
  if fdatalink.active and (cell.row = fdatalink.activerecord) then begin
   notext:= true;
   inherited;
   drawindicatorcell(canvas,fdatalink,fcolorindicator);
  end
  else begin
   inherited;
  end;
 end;
end;

procedure tdbwidgetindicatorcol.setcolorindicator(const avalue: colorty);
begin
 if fcolorindicator <> avalue then begin
  fcolorindicator:= avalue;
  changed;
 end;
end;

{ tdbwidgetfixcols }

constructor tdbwidgetfixcols.create(const aowner: tcustomwidgetgrid; 
                       const adatalink: tgriddatalink);
begin
 fdatalink:= adatalink;
 inherited create(aowner);
end;

procedure tdbwidgetfixcols.createitem(const index: integer; var item: tpersistent);
begin
 if index = fdbindicatorcol then begin
  item:= tdbwidgetindicatorcol.create(fgrid,self);
 end
 else begin
  inherited;
 end;
end;

procedure tdbwidgetfixcols.setcount1(acount: integer; doinit: boolean);
begin
 if (acount <= 0) and not (csdestroying in fgrid.componentstate) then begin
  acount:= 1;
 end;
 if fdbindicatorcol >= acount then begin
  fdbindicatorcol:= acount - 1;
 end;
 inherited;
end;

procedure tdbwidgetfixcols.setdbindicatorcol(const Value: integer);
var
 int1,int2: integer;
begin
 int1:= -1 - value;
 if int1 < 0 then begin
  int1:= 0;
 end;
 if int1 >= count then begin
  int1:= count-1;
 end;
 int2:= fdbindicatorcol;
 if int1 <> int2 then begin
  move(int2,int1);
  fdbindicatorcol := int1;
 end;
end;

function tdbwidgetfixcols.getdbindicatorcol: integer;
begin
 result:= -1-fdbindicatorcol;
end;

{ tdbscrollbar }

constructor tdbscrollbar.create(intf: iscrollbar; org: originty = org_client;
              ondimchanged: objectprocty = nil);
begin
 inherited;
 foptions:= defaultdbscrollbaroptions;
 buttonlength:= -1;
end;

procedure tdbscrollbar.setoptions(const avalue: scrollbaroptionsty);
begin
 inherited setoptions(avalue + [sbo_thumbtrack]);
end;

{ tdbgridframe }

constructor tdbgridframe.create(const intf: iscrollframe; const owner: twidget;
               const autoscrollintf: iautoscrollframe);
begin
 inherited;
 include(fstate,fs_sbvertfix);
end;

function tdbgridframe.getscrollbarclass(vert: boolean): framescrollbarclassty;
begin
 if vert then begin
  result:= tdbscrollbar;
 end
 else begin
  result:= inherited getscrollbarclass(vert);
 end;
end;

procedure tdbgridframe.scrollevent(sender: tcustomscrollbar; event: scrolleventty);
begin
 if sender.tag = 1 then begin
  fintf1.scrollevent(sender,event);
 end
 else begin
  inherited;
 end;
end;


{ tcustomdbwidgetgrid }

constructor tcustomdbwidgetgrid.create(aowner: tcomponent);
begin
 fdatalink:= tgriddatalink.create(self,igriddatalink(self));
 inherited;
 fzebra_step:= 0;
 ffixcols.count:= 1;
end;

destructor tcustomdbwidgetgrid.destroy;
begin
 inherited;
 fdatalink.free;
end;

procedure tcustomdbwidgetgrid.setoptionsgrid(const avalue: optionsgridty);
begin
 inherited setoptionsgrid(avalue - [og_sorted]);
end;

procedure tcustomdbwidgetgrid.internalcreateframe;
begin
 tdbgridframe.create(iscrollframe(self),self,iautoscrollframe(self));
end;

function tcustomdbwidgetgrid.createfixcols: tfixcols;
begin
 result:= tdbwidgetfixcols.create(self,fdatalink);
end;

function tcustomdbwidgetgrid.getdatasource: tdatasource;
begin
 result:= fdatalink.datasource;
end;

procedure tcustomdbwidgetgrid.setdatasource(const Value: tdatasource);
begin
 fdatalink.datasource:= value;
 datacols.datasourcechanged;
end;

procedure tcustomdbwidgetgrid.updatelayout;
begin
 inherited;
 fdatalink.updatelayout;
end;

procedure tcustomdbwidgetgrid.initcellinfo(var info: cellinfoty);
begin
 inherited;
 info.griddatalink:= fdatalink;
end;

procedure tcustomdbwidgetgrid.docellevent(var info: celleventinfoty);
begin
 inherited;
 fdatalink.cellevent(info);
end;

procedure tcustomdbwidgetgrid.scrollevent(sender: tcustomscrollbar; event: scrolleventty);
begin
 if not fdatalink.scrollevent(sender,event) then begin
  inherited;
 end;
end;

function tcustomdbwidgetgrid.getzebrastart: integer;
begin
 result:= fdatalink.getzebrastart;
end;

function tcustomdbwidgetgrid.getnumoffset: integer;
begin
 result:= -fdatalink.fzebraoffset;
end;

procedure tcustomdbwidgetgrid.dopaint(const acanvas: tcanvas);
begin
 inherited;
 fdatalink.painted;
end;

procedure tcustomdbwidgetgrid.pagedown(const action: focuscellactionty = fca_focusin);
begin
 fdatalink.MoveBy(rowcount-1);
end;

procedure tcustomdbwidgetgrid.pageup(const action: focuscellactionty = fca_focusin);
begin
 fdatalink.MoveBy(-rowcount+1);
end;

procedure tcustomdbwidgetgrid.wheeldown(const action: focuscellactionty = fca_focusin);
begin
 fdatalink.MoveBy(wheelheight);
end;

procedure tcustomdbwidgetgrid.wheelup(const action: focuscellactionty = fca_focusin);
begin
 fdatalink.MoveBy(-wheelheight);
end;

procedure tcustomdbwidgetgrid.rowdown(const action: focuscellactionty = fca_focusin);
begin
 fdatalink.rowdown;
end;

procedure tcustomdbwidgetgrid.rowup(const action: focuscellactionty = fca_focusin);
begin
 fdatalink.MoveBy(-1);
end;

procedure tcustomdbwidgetgrid.lastrow(const action: focuscellactionty = fca_focusin);
begin
 fdatalink.lastrow;
end;

procedure tcustomdbwidgetgrid.firstrow(const action: focuscellactionty = fca_focusin);
begin
 fdatalink.firstrow;
end;

procedure tcustomdbwidgetgrid.dodeleterow(const sender: tobject);
begin
 fdatalink.dodeleterow;
end;

procedure tcustomdbwidgetgrid.doinsertrow(const sender: tobject);
begin
 fdatalink.doinsertrow;
end;

procedure tcustomdbwidgetgrid.doappendrow(const sender: tobject);
begin
 fdatalink.doappendrow;
end;


procedure tcustomdbwidgetgrid.setdatalink(const avalue: tgriddatalink);
begin
 fdatalink.assign(avalue);
end;

procedure tcustomdbwidgetgrid.loaded;
begin
 inherited;
 fdatalink.loaded;
end;

function tcustomdbwidgetgrid.getgriddatalink: pointer;
begin
 result:= fdatalink;
end;

procedure tcustomdbwidgetgrid.beforefocuscell(const cell: gridcoordty;
                             const selectaction: focuscellactionty);
begin
 fdatalink.beforefocuscell(cell,selectaction);
end;

function tcustomdbwidgetgrid.canclose(const newfocus: twidget): boolean;
begin
 result:= inherited canclose(newfocus) and fdatalink.canclose(newfocus);
end;

function tcustomdbwidgetgrid.focuscell(cell: gridcoordty;
               selectaction: focuscellactionty = fca_focusin;
               const selectmode: selectcellmodety = scm_cell;
               const noshowcell: boolean = false): boolean;
begin
 fdatalink.focuscell(cell);
 result:= inherited focuscell(cell,selectaction,selectmode,noshowcell);
end;

function tcustomdbwidgetgrid.getdbindicatorcol: integer;
begin
 result:= fixcols.dbindicatorcol;
end;

function tcustomdbwidgetgrid.getfixcols: tdbwidgetfixcols;
begin
 result:= tdbwidgetfixcols(inherited fixcols);
end;

procedure tcustomdbwidgetgrid.setfixcols(const avalue: tdbwidgetfixcols);
begin
 inherited
end;

{ tstringcoldatalink }

procedure tstringcoldatalink.layoutchanged;
begin
 inherited;
 tcustomdbstringgrid(fintf.getwidget).checkautofields;
end;

procedure tstringcoldatalink.updatedata;
var
 grid1: tcustomdbstringgrid;
begin
 grid1:=  tcustomdbstringgrid(fintf.getwidget);
 inc(grid1.fdatalink.fcanclosing);
 try
  inherited;
 finally
  dec(grid1.fdatalink.fcanclosing);
 end;
end;

{ tdbstringcol }

constructor tdbstringcol.create(const agrid: tcustomgrid; 
                         const aowner: tgridarrayprop);
begin
 foptionsdb:= tdbstringcols(aowner).foptionsdb;
 fdatalink:= tstringcoldatalink.create(idbeditfieldlink(self));
 inherited;
 fdatalink.griddatasourcechanged;
end;

destructor tdbstringcol.destroy;
begin
 inherited;
 fdatalink.free;
end;

function tdbstringcol.getdatafield: string;
begin
 result:= fdatalink.fieldname;
end;

procedure tdbstringcol.setdatafield(const avalue: string);
begin
 fdatalink.fieldname:= avalue;
end;

procedure tdbstringcol.modified;
begin
 inherited;
 fdatalink.modified;
end;

function tdbstringcol.getrowtext(const arow: integer): msestring;
var
 po1: pmsestring;
begin
 po1:= pmsestring(tcustomdbstringgrid(fgrid).fdatalink.getdisplaystringbuffer(
                           fdatalink.field,arow{,(fgrid.row = arow) and 
                           (fgrid.col = index) and fgrid.active}));
 if po1 = nil then begin
  result:= '';
 end
 else begin
  result:= po1^;
 end;
end;

function tdbstringcol.getitems(aindex: integer): msestring;
begin
 if aindex = fgrid.row then begin
  result:= inherited getitems(aindex);
 end
 else begin
  result:= getrowtext(aindex);
 end;
end;

function tdbstringcol.getgriddatasource: tdatasource;
begin
 result:= tcustomdbstringgrid(fgrid).datasource;
end;

function tdbstringcol.getgridintf: iwidgetgrid;
begin
 result:= iwidgetgrid(tcustomdbstringgrid(fgrid));
end;

function tdbstringcol.getwidget: twidget;
begin
 result:= fgrid;
end;

function tdbstringcol.seteditfocus: boolean;
begin
 if not readonly then begin
  grid.col:= index;
  if not grid.focused then begin
   if grid.canfocus then begin
    grid.setfocus;
   end;
  end;
 end;
 result:= grid.entered and (grid.col = index);
end;

function tdbstringcol.edited: boolean;
begin
 result:= ewds_modified in fdatalink.fstate;
end;

procedure tdbstringcol.initeditfocus;
begin
 //dummy
end;

procedure tdbstringcol.updatereadonlystate;
begin
 //dummy
end;

function tdbstringcol.checkvalue(const quiet: boolean = false): boolean;
begin
 result:= true;
 tcustomdbstringgrid(fgrid).checkcellvalue(result);
end;

procedure tdbstringcol.valuetofield;
var
 int1: integer;
 mstr1: msestring;
begin
 int1:= tcustomdbstringgrid(fgrid).fdatalink.activerecord;
 if (int1 >= 0) and (int1 < fgrid.rowcount) then begin
  mstr1:= items[int1];
  if mstr1 = '' then begin
   fdatalink.field.clear;
  end
  else begin
   fdatalink.asmsestring:= mstr1;
  end;
 end;
end;

procedure tdbstringcol.fieldtovalue;
var
 int1: integer;
begin
 int1:= tcustomdbstringgrid(fgrid).fdatalink.activerecord;
 if (int1 >= 0) and (int1 < fgrid.rowcount) then begin
  items[int1]:= fdatalink.msedisplaytext('',true);
 end;
end;

procedure tdbstringcol.setnullvalue;
var
 int1: integer;
begin
 int1:= tcustomdbstringgrid(fgrid).fdatalink.activerecord;
 if (int1 >= 0) and (int1 < fgrid.rowcount) then begin
  items[int1]:= '';
 end;
end;

procedure tdbstringcol.getfieldtypes(out propertynames: stringarty; 
            out fieldtypes: fieldtypesarty);
begin
 propertynames:= nil;
 setlength(fieldtypes,1);
 fieldtypes[0]:= stringfields;
end;

function tdbstringcol.getdatasource(const aindex: integer): tdatasource;
begin
 result:= getgriddatasource;
end;

{ tdropdowndbstringcol }

{ tdbstringcols }

class function tdbstringcols.getitemclasstype: persistentclassty;
begin
 result:= tdbstringcol;
end;

function tdbstringcols.getcols(const index: integer): tdbstringcol;
begin
 result:= tdbstringcol(items[index]);
end;

function tdbstringcols.getcolclass: stringcolclassty;
begin
 result:= tdbstringcol;
end;

procedure tdbstringcols.datasourcechanged;
var
 int1: integer;
begin
 for int1:= 0 to count - 1 do begin
  cols[int1].fdatalink.griddatasourcechanged;
 end;
end;

procedure tdbstringcols.setoptionsdb(const avalue: optionseditdbty);
var
 int1: integer;
 mask: {$ifdef FPC}longword{$else}word{$endif};
begin
 if foptionsdb <> avalue then begin
  mask:= {$ifdef FPC}longword{$else}word{$endif}(avalue) xor
  {$ifdef FPC}longword{$else}word{$endif}(foptionsdb);
  foptionsdb := avalue;
  if not (csloading in fgrid.componentstate) then begin
   for int1:= 0 to count - 1 do begin
    tdbstringcol(items[int1]).optionsdb:= optionseditdbty(
        replacebits({$ifdef FPC}longword{$else}word{$endif}(avalue),
  {$ifdef FPC}longword{$else}word{$endif}(tdbstringcol(items[int1]).optionsdb),
                             mask));
   end;
  end;
 end;
end;

{ tdbstringindicatorcol }

constructor tdbstringindicatorcol.create(const agrid: tcustomgrid;
                                            const aowner: tgridarrayprop);
begin
 fcolorindicator:= cl_glyph;
 inherited;
 width:= 15;
end;

procedure tdbstringindicatorcol.drawcell(const canvas: tcanvas);
begin
 with cellinfoty(canvas.drawinfopo^),tdbstringfixcols(prop) do begin
  if fdatalink.active and (cell.row = fdatalink.activerecord) then begin
   notext:= true;
   inherited;
   drawindicatorcell(canvas,fdatalink,fcolorindicator);
  end
  else begin
   inherited;
  end;
 end;
end;

procedure tdbstringindicatorcol.setcolorindicator(const avalue: colorty);
begin
 if fcolorindicator <> avalue then begin
  fcolorindicator:= avalue;
  changed;
 end;
end;

{ tdbstringfixcols }

constructor tdbstringfixcols.create(const aowner: tcustomgrid; 
                       const adatalink: tgriddatalink);
begin
 fdatalink:= adatalink;
 inherited create(aowner);
end;

procedure tdbstringfixcols.createitem(const index: integer; var item: tpersistent);
begin
 if index = fdbindicatorcol then begin
  item:= tdbstringindicatorcol.create(fgrid,self);
 end
 else begin
  inherited;
 end;
end;

procedure tdbstringfixcols.setcount1(acount: integer; doinit: boolean);
begin
 if (acount <= 0) and not (csdestroying in fgrid.componentstate) then begin
  acount:= 1;
 end;
 if fdbindicatorcol >= acount then begin
  fdbindicatorcol:= acount - 1;
 end;
 inherited;
end;

procedure tdbstringfixcols.setdbindicatorcol(const Value: integer);
var
 int1,int2: integer;
begin
 int1:= -1 - value;
 if int1 < 0 then begin
  int1:= 0;
 end;
 if int1 >= count then begin
  int1:= count-1;
 end;
 int2:= fdbindicatorcol;
 if int1 <> int2 then begin
  move(int2,int1);
  fdbindicatorcol := int1;
 end;
end;

function tdbstringfixcols.getdbindicatorcol: integer;
begin
 result:= -1-fdbindicatorcol;
end;

{ tstringgriddatalink }

procedure tstringgriddatalink.activechanged;
begin
 if active then begin
  tcustomdbstringgrid(fgrid).checkautofields;
 end;
 inherited;
end;

{ tcustomdbstringgrid }

constructor tcustomdbstringgrid.create(aowner: tcomponent);
begin
 ffieldnamedisplayfixrow:= -1;
 fdatalink:= tstringgriddatalink.create(self,igriddatalink(self));
 inherited;
 fzebra_step:= 0;
 ffixcols.count:= 1;
end;

destructor tcustomdbstringgrid.destroy;
begin
 inherited;
 fdatalink.free;
end;

//iwidgetgrid (dummy)

function tcustomdbstringgrid.getbrushorigin: pointty;
begin
 result:= nullpoint;
end;

function tcustomdbstringgrid.getcol: twidgetcol;
begin
 result:= nil;
end;

procedure tcustomdbstringgrid.getdata(index: integer; var dest);
begin
end;

procedure tcustomdbstringgrid.setdata(index: integer; const source;
                  const noinvalidate: boolean = false);
begin
end;

function tcustomdbstringgrid.getrow: integer;
begin
 result:= ffocusedcell.row;
end;

procedure tcustomdbstringgrid.setrow(arow: integer);
begin
 row:= arow;
end;

procedure tcustomdbstringgrid.changed;
begin
 //dummy
end;

function tcustomdbstringgrid.empty(index: integer): boolean;
begin
 result:= false;
end;

procedure tcustomdbstringgrid.updateeditoptions(var aoptions: optionseditty);
begin
 //dummy
end;

procedure tcustomdbstringgrid.showrect(const arect: rectty;
                           const aframe: tcustomframe);
begin
 //dummy
end;

procedure tcustomdbstringgrid.widgetpainted(const canvas: tcanvas);
begin
 //dummy
end;

function tcustomdbstringgrid.nullcheckneeded(const newfocus: twidget): boolean;
begin
 result:= fnonullcheck = 0;
end;

function tcustomdbstringgrid.nonullcheck: boolean;
begin
 result:= fnonullcheck > 0;
end;

procedure tcustomdbstringgrid.internalcreateframe;
begin
 tdbgridframe.create(iscrollframe(self),self,iautoscrollframe(self));
end;

function tcustomdbstringgrid.getoptionsedit: optionseditty;
begin
 result:= inherited getoptionsedit;
 if ffocusedcell.col >= 0 then begin
  datacols[ffocusedcell.col].fdatalink.updateoptionsedit(result);
 end;
end;

function tcustomdbstringgrid.createfixcols: tfixcols;
begin
 result:= tdbstringfixcols.create(self,fdatalink);
end;

function tcustomdbstringgrid.createdatacols: tdatacols;
begin
 result:= tdbstringcols.create(self);
end;

function tcustomdbstringgrid.getdatasource: tdatasource;
begin
 result:= fdatalink.datasource;
end;

procedure tcustomdbstringgrid.setdatasource(const Value: tdatasource);
begin
 fdatalink.datasource:= value;
 datacols.datasourcechanged;
end;

function tcustomdbstringgrid.getdatacols: tdbstringcols;
begin
 result:= tdbstringcols(fdatacols);
end;

procedure tcustomdbstringgrid.setdatacols(const avalue: tdbstringcols);
begin
 fdatacols.assign(avalue);
end;

procedure tcustomdbstringgrid.updatelayout;
begin
 inherited;
 fdatalink.updatelayout;
end;

procedure tcustomdbstringgrid.initcellinfo(var info: cellinfoty);
begin
 inherited;
 info.griddatalink:= fdatalink;
end;

procedure tcustomdbstringgrid.docellevent(var info: celleventinfoty);
begin
 inherited;
 fdatalink.cellevent(info);
end;

procedure tcustomdbstringgrid.scrollevent(sender: tcustomscrollbar; event: scrolleventty);
begin
 if not fdatalink.scrollevent(sender,event) then begin
  inherited;
 end;
end;

function tcustomdbstringgrid.getzebrastart: integer;
begin
 result:= fdatalink.getzebrastart;
end;

function tcustomdbstringgrid.getnumoffset: integer;
begin
 result:= -fdatalink.fzebraoffset;
end;

procedure tcustomdbstringgrid.checkcellvalue(var accept: boolean);
begin
 inherited;
 if accept and (ffocusedcell.col >= 0) then begin
  with datacols[ffocusedcell.col] do begin;
   if (ewds_modified in fdatalink.fstate) and self.fdatalink.active then begin
    fdatalink.dataentered;
   end;
  end;
 end;
end;

function tcustomdbstringgrid.canclose(const newfocus: twidget): boolean;
begin
 result:= true;
 checkcellvalue(result);
 result:= result and fdatalink.canclose(newfocus);
end;

procedure tcustomdbstringgrid.dopaint(const acanvas: tcanvas);
begin
 inherited;
 fdatalink.painted;
end;

procedure tcustomdbstringgrid.pagedown(const action: focuscellactionty = fca_focusin);
begin
 fdatalink.MoveBy(rowcount-1);
end;

procedure tcustomdbstringgrid.pageup(const action: focuscellactionty = fca_focusin);
begin
 fdatalink.MoveBy(-rowcount+1);
end;

procedure tcustomdbstringgrid.wheeldown(const action: focuscellactionty = fca_focusin);
begin
 fdatalink.MoveBy(wheelheight);
end;

procedure tcustomdbstringgrid.wheelup(const action: focuscellactionty = fca_focusin);
begin
 fdatalink.MoveBy(-wheelheight);
end;

procedure tcustomdbstringgrid.rowdown(const action: focuscellactionty = fca_focusin);
begin
 fdatalink.rowdown;
end;

procedure tcustomdbstringgrid.rowup(const action: focuscellactionty = fca_focusin);
begin
 fdatalink.MoveBy(-1);
end;

procedure tcustomdbstringgrid.lastrow(const action: focuscellactionty = fca_focusin);
begin
 fdatalink.lastrow;
end;

procedure tcustomdbstringgrid.firstrow(const action: focuscellactionty = fca_focusin);
begin
 fdatalink.firstrow;
end;

procedure tcustomdbstringgrid.dodeleterow(const sender: tobject);
begin
 fdatalink.dodeleterow;
end;

procedure tcustomdbstringgrid.doinsertrow(const sender: tobject);
begin
 fdatalink.doinsertrow;
end;

procedure tcustomdbstringgrid.doappendrow(const sender: tobject);
begin
 fdatalink.doappendrow;
end;

procedure tcustomdbstringgrid.setoptions(const avalue: dbstringgridoptionsty);
begin
 if foptions <> avalue then begin
  foptions:= avalue;
  checkautofields;
 end;
end;

procedure tcustomdbstringgrid.setfieldnamedisplayfixrow(const avalue: integer);
begin
 if avalue <> ffieldnamedisplayfixrow then begin
  ffieldnamedisplayfixrow:= avalue;
  if ffieldnamedisplayfixrow > 0 then begin
   ffieldnamedisplayfixrow:= 0;
  end;
  checkautofields;
 end;
end;

procedure tcustomdbstringgrid.setoptionsgrid(const avalue: optionsgridty);
begin
 inherited setoptionsgrid(avalue - [og_sorted]);
end;

procedure tcustomdbstringgrid.doasyncevent(var atag: integer);
var
 int1,int2: integer;
 field1: tfield;
 charwi: integer;
 focusedcellbefore: gridcoordty;
begin
 if tag = 0 then begin
  beginupdate;
  try
   focusedcellbefore:= focusedcell;
   datacols.count:= 0;
   charwi:= getcanvas.getstringwidth('o');
   if fdatalink.dataset <> nil then begin
    for int1:= 0 to fdatalink.dataset.fields.count - 1 do begin
     field1:= fdatalink.dataset.fields[int1];
     with field1 do begin
      if (datatype in stringfields) and visible then begin
       datacols.count:= datacols.count + 1;
       with datacols[datacols.count-1] do begin
        if readonly then begin
         options:= options + [co_readonly];
        end;
        datafield:= fieldname;
        int2:= displaywidth;
        if (int2 = 0) or (int2 > maxautodisplaywidth) then begin
         int2:= maxautodisplaywidth;
        end;
        width:= charwi * int2;
        textflags:= textflags - [tf_xcentered,tf_right];
        case alignment of
         tacenter: begin
          textflags:= textflags + [tf_xcentered];
         end;
         tarightjustify: begin
          textflags:= textflags + [tf_right];
         end;
        end;
        if (ffieldnamedisplayfixrow < 0) and 
                      (-ffieldnamedisplayfixrow <= ffixrows.count) then begin
         with ffixrows[ffieldnamedisplayfixrow] do begin
          captions.count:= datacols.count;
          captions[datacols.count-1].caption:= displaylabel;
         end;
        end;
       end;
      end;
     end;
    end;
   end;
   focuscell(focusedcellbefore);
  finally
   endupdate;
  end;
 end;
end;

procedure tcustomdbstringgrid.checkautofields;
var
 int1: integer;
begin           
 if dsgo_autofields in foptions then begin
  for int1:= 0 to datacols.count - 1 do begin
   datacols[int1].datafield:= '';
  end;
  asyncevent(0); //datalinks can not be destroyed
 end;
end;

procedure tcustomdbstringgrid.setdatalink(const avalue: tstringgriddatalink);
begin
 fdatalink.assign(avalue);
end;

procedure tcustomdbstringgrid.loaded;
begin
 inherited;
 fdatalink.loaded;
end;

function tcustomdbstringgrid.cangridcopy: boolean;
begin
 result:= fdatacols.hasselection;
end;

function tcustomdbstringgrid.getgrid: tcustomwidgetgrid;
begin
 result:= nil;
end;

procedure tcustomdbstringgrid.beforefocuscell(const cell: gridcoordty;
                             const selectaction: focuscellactionty);
begin
 fdatalink.beforefocuscell(cell,selectaction);
end;

procedure tcustomdbstringgrid.editnotification(var info: editnotificationinfoty);
var
 int1: integer;
begin
 inherited;
 if isdatacell(ffocusedcell) and 
   datacols[ffocusedcell.col].fdatalink.cuttext(feditor.text,int1) then begin
  feditor.text:= copy(feditor.text,1,int1);
 end;
end;

function tcustomdbstringgrid.focuscell(cell: gridcoordty;
               selectaction: focuscellactionty = fca_focusin;
               const selectmode: selectcellmodety = scm_cell;
               const noshowcell: boolean = false): boolean;
begin
 fdatalink.focuscell(cell);
 result:= inherited focuscell(cell,selectaction,selectmode,noshowcell);
end;

function tcustomdbstringgrid.getfixcols: tdbstringfixcols;
begin
 result:= tdbstringfixcols(inherited fixcols);
end;

procedure tcustomdbstringgrid.setfixcols(const avalue: tdbstringfixcols);
begin
 inherited;
end;

function tcustomdbstringgrid.getdbindicatorcol: integer;
begin
 result:= fixcols.dbindicatorcol;
end;

procedure tcustomdbstringgrid.coloptionstoeditoptions(var dest: optionseditty);
begin
 //dummy
end;

{ tlbdropdowncol }

procedure tlbdropdowncol.setfieldno(const avalue: integer);
begin
 if avalue <> ffieldno then begin
  ffieldno:= avalue;
 end;
end;

{ tlbdropdowncols }

function tlbdropdowncols.getitems(const index: integer): tlbdropdowncol;
begin
 result:= tlbdropdowncol(inherited getitems(index));
end;

function tlbdropdowncols.getcolclass: dropdowncolclassty;
begin
 result:= tlbdropdowncol;
end;

{ tlbdropdownlistcontroller }

constructor tlbdropdownlistcontroller.create(const intf: ilbdropdownlist);
begin
 inherited;
 options:= defaultlbdropdownoptions;
end;

procedure tlbdropdownlistcontroller.valuecolchanged;
begin
end;

function tlbdropdownlistcontroller.getbuttonframeclass: dropdownbuttonframeclassty;
begin
 result:= tdropdownbuttonframe;
end;

function tlbdropdownlistcontroller.getdropdowncolsclass: dropdowncolsclassty;
begin
 result:= tlbdropdowncols;
end;

function  tlbdropdownlistcontroller.createdropdownlist: tdropdownlist;
var
 int1,int2,int3,int4: integer;
 sortfieldno: integer;
 bo1: boolean;
 po1: pmsestringaty;
 ar1: msestringarty;
begin
 if olb_copyitems in foptionslb then begin
  flookupbuffer.checkbuffer; //ev. load buffer
  sortfieldno:= cols[0].fieldno;
  setlength(flbrecnums,flookupbuffer.count);
  if assigned(fonfilter) then begin
   int3:= 0;
   for int1:= 0 to high(flbrecnums) do begin
    int4:= flookupbuffer.textindex(sortfieldno,int1,true);
    bo1:= true;
    fonfilter(flookupbuffer,int4,bo1);
    if bo1 then begin
     flbrecnums[int3]:= int4;
     inc(int3);
    end;
   end;
   setlength(flbrecnums,int3);
  end
  else begin
   flbrecnums:= flookupbuffer.textindexar(sortfieldno,true);
  end;
  for int1:= 0 to fcols.count - 1 do begin
   with cols[int1] do begin
    count:= length(flbrecnums);
    int2:= fieldno;
    po1:= datapo;
    ar1:= flookupbuffer.textar(int2);
    for int3:= 0 to high(flbrecnums) do begin
     po1^[int3]:= ar1[flbrecnums[int3]];
    end;
   end;
  end;
  result:= tcopydropdownlist.create(self,fcols);
 end
 else begin
  result:= tlbdropdownlist.create(self,fcols);
 end;
end;

function tlbdropdownlistcontroller.candropdown: boolean;
begin
 result:= (flookupbuffer <> nil) and (flookupbuffer.count > 0) and
                 (fcols.count > 0) and inherited candropdown;
end;

procedure tlbdropdownlistcontroller.itemselected(const index: integer;
                             const akey: keyty);
var
 int1: integer;
begin
 int1:= index;
 if index < 0 then begin
  if index = -2 then begin
   tdropdowncols1(fcols).fitemindex:= -1;
  end;
 end
 else begin
  if olb_copyitems in foptionslb then begin
   int1:= flbrecnums[int1];
   cols.clear;
   flbrecnums:= nil;
  end
  else begin
   int1:= tlbdropdownlist(fdropdownlist).getrecno(index);
   int1:= flookupbuffer.textindex(cols[0].fieldno,int1,true)
  end;
  tdropdowncols1(fcols).fitemindex:= int1;
 end;
 if olb_copyitems in foptionslb then begin
  cols.clear;
  flbrecnums:= nil;
 end;
 ilbdropdownlist(fintf).recordselected(int1,akey);
end;

procedure tlbdropdownlistcontroller.setlookupbuffer(
                   const avalue: tcustomlookupbuffer);
begin
 setlinkedvar(avalue,flookupbuffer);
end;

function tlbdropdownlistcontroller.getcols: tlbdropdowncols;
begin
 result:= tlbdropdowncols(fcols);
end;

procedure tlbdropdownlistcontroller.setcols(const avalue: tlbdropdowncols);
begin
 fcols.assign(avalue);
end;

procedure tlbdropdownlistcontroller.objectevent(const sender: tobject;
             const event: objecteventty);
begin
 inherited;
 if (event in [oe_changed,oe_connect]) and (sender = flookupbuffer) 
           and not (csloading in flookupbuffer.componentstate) then begin
// if (event = oe_changed) and (sender = flookupbuffer) then begin
  with tdataedit1(fintf.getwidget) do begin
   if fgridintf <> nil then begin
    fgridintf.getcol.changed;
//    if csdesigning in componentstate then begin
//  {$ifdef FPC} {$checkpointer off} {$endif}
//     feditor.text:= datatotext(nil^);
//  {$ifdef FPC} {$checkpointer default} {$endif}
//    end;
  {$ifdef FPC} {$checkpointer off} {$endif}
    feditor.text:= datatotext(nil^);
  {$ifdef FPC} {$checkpointer default} {$endif}
   end
   else begin
 {$ifdef FPC} {$checkpointer off} {$endif}
    feditor.text:= datatotext(nil^);
 {$ifdef FPC} {$checkpointer default} {$endif}
   end;
  end;
 end;

end;

procedure tlbdropdownlistcontroller.dropdown;
begin
 tdropdowncols1(fcols).fitemindex:= -1;
 inherited; 
end;

{ tdbenumeditlb }

function tdbenumeditlb.getdropdown: tlbdropdownlistcontroller;
begin
 result:= tlbdropdownlistcontroller(fdropdown);
end;

procedure tdbenumeditlb.setdropdown(const avalue: tlbdropdownlistcontroller);
begin
 fdropdown.assign(avalue);
end;

function tdbenumeditlb.createdropdowncontroller: tcustomdropdowncontroller;
begin
 result:= tlbdropdownlistcontroller.create(ilbdropdownlist(self));
end;

procedure tdbenumeditlb.recordselected(const arecordnum: integer; const akey: keyty);
var
 bo1: boolean;
begin
 if arecordnum >= 0 then begin
  with tlbdropdownlistcontroller(fdropdown) do begin
   text:= flookupbuffer.textvaluephys(cols[0].ffieldno,arecordnum);
   tdropdowncols1(fcols).fitemindex:= 
            flookupbuffer.integervaluephys(fkeyfieldno,arecordnum);
  end; 
  bo1:= checkvalue;
 end
 else begin
  if arecordnum = -2 then begin
   bo1:= checkvalue; 
  end
  else begin
   feditor.undo;
  end;
 end;
 if bo1 and (akey = key_tab) then begin
  window.postkeyevent(akey);
 end;
end;

function tdbenumeditlb.internaldatatotext(const data): msestring;
var
 int1,int2,int3,int4: integer;
begin
 if @data = nil then begin
  int1:= value;  
 end
 else begin
  int1:= integer(data);
 end;
 with tlbdropdownlistcontroller(fdropdown) do begin
  int3:= cols[valuecol].ffieldno;
  int4:= fkeyfieldno;
 end;
 with dropdown do begin
  if (flookupbuffer <> nil) and (int3 < flookupbuffer.fieldcounttext) and
           (int4 < flookupbuffer.fieldcountinteger) and
           flookupbuffer.find(int4,int1,int2) then begin
   result:= flookupbuffer.textvaluephys(int3,
                 flookupbuffer.integerindex(int4,int2));
  end
  else begin
   result:= '';
  end;
 end;
end;

{ tenumeditlb }

function tenumeditlb.getdropdown: tlbdropdownlistcontroller;
begin
 result:= tlbdropdownlistcontroller(fdropdown);
end;

procedure tenumeditlb.setdropdown(const avalue: tlbdropdownlistcontroller);
begin
 fdropdown.assign(avalue);
end;

function tenumeditlb.createdropdowncontroller: tcustomdropdowncontroller;
begin
 result:= tlbdropdownlistcontroller.create(ilbdropdownlist(self));
end;

procedure tenumeditlb.recordselected(const arecordnum: integer; const akey: keyty);
var
 bo1: boolean;
begin
 if arecordnum >= 0 then begin
  with tlbdropdownlistcontroller(fdropdown) do begin
   text:= flookupbuffer.textvaluephys(cols[0].ffieldno,arecordnum);
   tdropdowncols1(fcols).fitemindex:= 
            flookupbuffer.integervaluephys(fkeyfieldno,arecordnum);
  end; 
  bo1:= checkvalue;
 end
 else begin
  if arecordnum = -2 then begin //empty row selected
   bo1:= checkvalue; 
  end
  else begin
   feditor.undo;
  end;
 end;
 if bo1 and (akey = key_tab) then begin
  window.postkeyevent(akey);
 end;
end;

function tenumeditlb.internaldatatotext(const data): msestring;
var
 int1,int2,int3,int4: integer;
begin
 if @data = nil then begin
  int1:= value;  
 end
 else begin
  int1:= integer(data);
 end;
 with tlbdropdownlistcontroller(fdropdown) do begin
  int3:= cols[valuecol].ffieldno;
  int4:= fkeyfieldno;
 end;
 with dropdown do begin
  if (flookupbuffer <> nil) and (int3 < flookupbuffer.fieldcounttext) and
           (int4 < flookupbuffer.fieldcountinteger) and
           flookupbuffer.find(int4,int1,int2) then begin
   result:= flookupbuffer.textvaluephys(int3,
                 flookupbuffer.integerindex(int4,int2));
  end
  else begin
   result:= '';
  end;
 end;
end;

{ tcustomenum64edit }

constructor tcustomenum64edit.create(aowner: tcomponent);
begin
 fvalue1:= -1;
 fvaluedefault:= -1;
 inherited;
end;

function tcustomenum64edit.createdatalist(const sender: twidgetcol): tdatalist;
begin
 result:= tgridenum64datalist.create(sender);
end;

function tcustomenum64edit.getdatatyp: datatypty;
begin
 result:= dl_int64;
end;

function tcustomenum64edit.getgridvalue(const index: integer): int64;
begin
 internalgetgridvalue(index,result);
end;

procedure tcustomenum64edit.setgridvalue(const index: integer; aValue: int64);
begin
 internalsetgridvalue(index,avalue);
end;

function tcustomenum64edit.getgridvalues: int64arty;
begin
 result:= tint64datalist(fgridintf.getcol.datalist).asarray;
end;

procedure tcustomenum64edit.setgridvalues(const avalue: int64arty);
begin
 tint64datalist(fgridintf.getcol.datalist).asarray:= avalue;
end;

procedure tcustomenum64edit.setvalue(const avalue: int64);
begin
 tdropdowncols1(tlbdropdownlistcontroller(fdropdown).cols).fkeyvalue64:= 
                         avalue;
 fvalue1:= avalue;
 valuechanged;
end;

function tcustomenum64edit.getdefaultvalue: pointer;
begin
 result:= @fvaluedefault;
end;

procedure tcustomenum64edit.texttovalue(var accept: boolean; const quiet: boolean);
var
 lint1: int64;
begin
 if trim(text) = '' then begin
  lint1:= valuedefault;
 end
 else begin
  lint1:= tdropdowncols1(tlbdropdownlistcontroller(fdropdown).cols).fkeyvalue64;
 end;
   //no checktext call
 if accept then begin
  if not quiet and canevent(tmethod(fonsetvalue1)) then begin
   fonsetvalue1(self,lint1,accept);
  end;
  if accept then begin
   value:= lint1;
  end;
 end;
end;

procedure tcustomenum64edit.texttodata(const atext: msestring; var data);
begin
 //not supported
end;

procedure tcustomenum64edit.valuetogrid(const arow: integer);
begin
 fgridintf.setdata(arow,fvalue1);
end;

procedure tcustomenum64edit.gridtovalue(const arow: integer);
begin
 fgridintf.getdata(arow,fvalue1);
 valuetotext;
end;

procedure tcustomenum64edit.readstatvalue(const reader: tstatreader);
begin
 if fgridintf <> nil then begin
  fgridintf.getcol.dostatread(reader);
 end
 else begin
  value:= reader.readint64(valuevarname,value);
 end;
end;

procedure tcustomenum64edit.writestatvalue(const writer: tstatwriter);
begin
 writer.writeint64(valuevarname,value);
end;

 { tcustomenum64editlb }
 
function tcustomenum64editlb.getdropdown: tlbdropdownlistcontroller;
begin
 result:= tlbdropdownlistcontroller(fdropdown);
end;

procedure tcustomenum64editlb.setdropdown(const avalue: tlbdropdownlistcontroller);
begin
 fdropdown.assign(avalue);
end;

function tcustomenum64editlb.createdropdowncontroller: tcustomdropdowncontroller;
begin
 result:= tlbdropdownlistcontroller.create(ilbdropdownlist(self));
end;

procedure tcustomenum64editlb.recordselected(const arecordnum: integer; const akey: keyty);
var
 bo1: boolean;
begin
 if arecordnum >= 0 then begin
  with tlbdropdownlistcontroller(fdropdown) do begin
   text:= flookupbuffer.textvaluephys(cols[0].ffieldno,arecordnum);
   tdropdowncols1(fcols).fkeyvalue64:= 
            flookupbuffer.int64valuephys(fkeyfieldno,arecordnum);
  end; 
  bo1:= checkvalue;
 end
 else begin
  if arecordnum = -2 then begin //empty row selected
   bo1:= checkvalue; 
  end
  else begin
   feditor.undo;
  end;
 end;
 if bo1 and (akey = key_tab) then begin
  window.postkeyevent(akey);
 end;
end;

function tcustomenum64editlb.internaldatatotext(const data): msestring;
var
 lint1: int64;
 int2,int3,int4: integer;
begin
 if @data = nil then begin
  lint1:= value;  
 end
 else begin
  lint1:= int64(data);
 end;
 with tlbdropdownlistcontroller(fdropdown) do begin
  int3:= cols[valuecol].ffieldno;
  int4:= fkeyfieldno;
  if (flookupbuffer <> nil) and (int3 < flookupbuffer.fieldcounttext) and
           (int4 < flookupbuffer.fieldcountint64) and
           flookupbuffer.find(int4,lint1,int2) then begin
   result:= flookupbuffer.textvaluephys(int3,
                 flookupbuffer.int64index(int4,int2));
  end
  else begin
   result:= '';
  end;
 end;
end;

 { tcustomenum64editdb }
 
function tcustomenum64editdb.getdropdown: tdbdropdownlistcontroller;
begin
 result:= tdbdropdownlistcontroller(fdropdown);
end;

procedure tcustomenum64editdb.setdropdown(const avalue: tdbdropdownlistcontroller);
begin
 fdropdown.assign(avalue);
end;

function tcustomenum64editdb.createdropdowncontroller: tcustomdropdowncontroller;
begin
 result:= tdbdropdownlistcontroller.create(idbdropdownlist(self),false);
end;

procedure tcustomenum64editdb.recordselected(const arecordnum: integer; const akey: keyty);
var
 bo1: boolean;
begin
 bo1:= false;
 if arecordnum >= 0 then begin
  with tdbdropdownlistcontroller(fdropdown) do begin
   text:= getasmsestring(fdatalink.textfield,fdatalink.utf8);
   tdropdowncols1(fcols).fkeyvalue64:= fdatalink.valuefield.aslargeint
  end; 
  bo1:= checkvalue;
 end
 else begin
  if arecordnum = -2 then begin
   bo1:= checkvalue; 
  end
  else begin
   feditor.undo;
  end;
 end;
 if bo1 and (akey = key_tab) then begin
  window.postkeyevent(akey);
 end;
end;

function tcustomenum64editdb.internaldatatotext(const data): msestring;
var
 lint1: integer;
begin
 if @data = nil then begin
  lint1:= value;  
 end
 else begin
  lint1:= int64(data);
 end;
 result:= tdbdropdownlistcontroller(fdropdown).fdatalink.getlookuptext(lint1);
end;

{ tdbenum64editlb }

constructor tdbenum64editlb.create(aowner: tcomponent);
begin
// fisdb:= true;
 fdatalink:= teditwidgetdatalink.create(idbeditfieldlink(self));
 inherited;
end;

destructor tdbenum64editlb.destroy;
begin
 inherited;
 fdatalink.free;
end;

function tdbenum64editlb.getdatafield: string;
begin
 result:= fdatalink.fieldname;
end;

procedure tdbenum64editlb.setdatafield(const avalue: string);
begin
 fdatalink.fieldname:= avalue;
end;

function tdbenum64editlb.getdatasource: tdatasource;
begin
 result:= fdatalink.datasource;
end;

procedure tdbenum64editlb.setdatasource(const avalue: tdatasource);
begin
 fdatalink.setwidgetdatasource(avalue);
end;

procedure tdbenum64editlb.modified;
begin
 fdatalink.modified;
 inherited;
end;

function tdbenum64editlb.getoptionsedit: optionseditty;
begin
 result:= inherited getoptionsedit;
 fdatalink.updateoptionsedit(result);
 frame.readonly:= oe_readonly in result;
end;

procedure tdbenum64editlb.valuetofield;
begin
 if value = -1 then begin
  fdatalink.field.clear;
 end
 else begin
  fdatalink.field.aslargeint:= value;
 end;
end;

procedure tdbenum64editlb.fieldtovalue;
begin
 if fdatalink.field.isnull then begin
  value:= fvaluedefault;
 end
 else begin
  value:= fdatalink.field.aslargeint;
 end;
end;

function tdbenum64editlb.getrowdatapo(const info: cellinfoty): pointer;
begin
 with info do begin
  if griddatalink <> nil then begin
   result:= tgriddatalink(griddatalink).
                    getint64buffer(fdatalink.field,cell.row);
   if result = nil then begin
    result:= @fvaluedefault;
   end;
  end
  else begin
   result:= @fvaluedefault;
//   result:= nil;
  end;
 end;
end;

function tdbenum64editlb.createdatalist(const sender: twidgetcol): tdatalist;
begin
 result:= nil;
end;

procedure tdbenum64editlb.griddatasourcechanged;
begin
 fdatalink.griddatasourcechanged;
end;

function tdbenum64editlb.getgriddatasource: tdatasource;
begin
 result:= tcustomdbwidgetgrid(fgridintf.getcol.grid).datasource;
end;

procedure tdbenum64editlb.getfieldtypes(out propertynames: stringarty; 
                    out fieldtypes: fieldtypesarty);
begin
 propertynames:= nil;
 setlength(fieldtypes,1);
 fieldtypes[0]:= integerfields;
end;

function tdbenum64editlb.nullcheckneeded(const newfocus: twidget): boolean;
begin
 result:= inherited nullcheckneeded(newfocus) and fdatalink.nullcheckneeded;
end;

function tdbenum64editlb.getdatasource(const aindex: integer): tdatasource;
begin
 result:= datasource;
end;

procedure tdbenum64editlb.recchanged;
begin
 fdatalink.recordchanged(nil);
end;

{
function tdbenum64editlb.checkvalue(const quiet: boolean = false): boolean;
begin
 result:= inherited checkvalue(quiet) and fdatalink.dataentered;
end;
}

procedure tdbenum64editlb.dochange;
begin
 fdatalink.dataentered;
 inherited;
end;

{ tdbenum64editdb }

constructor tdbenum64editdb.create(aowner: tcomponent);
begin
// fisdb:= true;
 fdatalink:= teditwidgetdatalink.create(idbeditfieldlink(self));
 inherited;
end;

destructor tdbenum64editdb.destroy;
begin
 inherited;
 fdatalink.free;
end;

function tdbenum64editdb.getdatafield: string;
begin
 result:= fdatalink.fieldname;
end;

procedure tdbenum64editdb.setdatafield(const avalue: string);
begin
 fdatalink.fieldname:= avalue;
end;

function tdbenum64editdb.getdatasource: tdatasource;
begin
 result:= fdatalink.datasource;
end;

procedure tdbenum64editdb.setdatasource(const avalue: tdatasource);
begin
 fdatalink.setwidgetdatasource(avalue);
end;

procedure tdbenum64editdb.modified;
begin
 fdatalink.modified;
 inherited;
end;

function tdbenum64editdb.getoptionsedit: optionseditty;
begin
 result:= inherited getoptionsedit;
 fdatalink.updateoptionsedit(result);
 frame.readonly:= oe_readonly in result;
end;

procedure tdbenum64editdb.valuetofield;
begin
 if value = -1 then begin
  fdatalink.field.clear;
 end
 else begin
  fdatalink.field.aslargeint:= value;
 end;
end;

procedure tdbenum64editdb.fieldtovalue;
begin
 if fdatalink.field.isnull then begin
  value:= fvaluedefault;
 end
 else begin
  value:= fdatalink.field.aslargeint;
 end;
end;

function tdbenum64editdb.getrowdatapo(const info: cellinfoty): pointer;
begin
 with info do begin
  if griddatalink <> nil then begin
   result:= tgriddatalink(griddatalink).
                    getint64buffer(fdatalink.field,cell.row);
   if result = nil then begin
    result:= @fvaluedefault;
   end;
  end
  else begin
   result:= @fvaluedefault;
//   result:= nil;
  end;
 end;
end;

function tdbenum64editdb.createdatalist(const sender: twidgetcol): tdatalist;
begin
 result:= nil;
end;

procedure tdbenum64editdb.griddatasourcechanged;
begin
 fdatalink.griddatasourcechanged;
end;

function tdbenum64editdb.getgriddatasource: tdatasource;
begin
 result:= tcustomdbwidgetgrid(fgridintf.getcol.grid).datasource;
end;

procedure tdbenum64editdb.getfieldtypes(out propertynames: stringarty; 
                    out fieldtypes: fieldtypesarty);
begin
 propertynames:= nil;
 setlength(fieldtypes,1);
 fieldtypes[0]:= integerfields;
end;

function tdbenum64editdb.nullcheckneeded(const newfocus: twidget): boolean;
begin
 result:= inherited nullcheckneeded(newfocus) and fdatalink.nullcheckneeded;
end;

function tdbenum64editdb.getdatasource(const aindex: integer): tdatasource;
begin
 result:= datasource;
end;

procedure tdbenum64editdb.recchanged;
begin
 fdatalink.recordchanged(nil);
end;

{
function tdbenum64editdb.checkvalue(const quiet: boolean = false): boolean;
begin
 result:= inherited checkvalue(quiet) and fdatalink.dataentered;
end;
}

procedure tdbenum64editdb.dochange;
begin
 fdatalink.dataentered;
 inherited;
end;

{ tdbkeystringeditlb }

function tdbkeystringeditlb.getdropdown: tlbdropdownlistcontroller;
begin
 result:= tlbdropdownlistcontroller(fdropdown);
end;

procedure tdbkeystringeditlb.setdropdown(const avalue: tlbdropdownlistcontroller);
begin
 fdropdown.assign(avalue);
end;

function tdbkeystringeditlb.createdropdowncontroller: tcustomdropdowncontroller;
begin
 result:= tlbdropdownlistcontroller.create(ilbdropdownlist(self));
end;

procedure tdbkeystringeditlb.recordselected(const arecordnum: integer;
                                   const akey: keyty);
var
 bo1: boolean;
begin
 if arecordnum >= 0 then begin
  with tlbdropdownlistcontroller(fdropdown) do begin
   text:= flookupbuffer.textvaluephys(cols[0].ffieldno,arecordnum);
   tdropdowncols1(fcols).fitemindex:= arecordnum;
   tdropdowncols1(fcols).fkeyvalue:= 
                           flookupbuffer.textvaluephys(fkeyfieldno,arecordnum);
  end; 
  bo1:= checkvalue;
 end
 else begin
  if arecordnum = -2 then begin
   bo1:= checkvalue; 
  end
  else begin
   feditor.undo;
  end;
 end;
 if bo1 and (akey = key_tab) then begin
  window.postkeyevent(akey);
 end;
end;

function tdbkeystringeditlb.internaldatatotext(const data): msestring;
var
 mstr1: msestring;
 int2,int3,int4: integer;
begin
 if @data = nil then begin
  mstr1:= value;  
 end
 else begin
  mstr1:= msestring(data);
 end;
 with tlbdropdownlistcontroller(fdropdown) do begin
  int3:= cols[valuecol].ffieldno;
  int4:= fkeyfieldno;
 end;
 with dropdown do begin
  if (flookupbuffer <> nil) and (int3 < flookupbuffer.fieldcounttext) and
           (int4 < flookupbuffer.fieldcounttext) and
           flookupbuffer.find(int4,mstr1,int2,false) then begin
   result:= flookupbuffer.textvaluephys(int3,
                 flookupbuffer.textindex(int4,int2,false));
  end
  else begin
   result:= '';
  end;
 end;
end;

{ tkeystringeditlb }

function tkeystringeditlb.getdropdown: tlbdropdownlistcontroller;
begin
 result:= tlbdropdownlistcontroller(fdropdown);
end;

procedure tkeystringeditlb.setdropdown(const avalue: tlbdropdownlistcontroller);
begin
 fdropdown.assign(avalue);
end;

function tkeystringeditlb.createdropdowncontroller: tcustomdropdowncontroller;
begin
 result:= tlbdropdownlistcontroller.create(ilbdropdownlist(self));
end;

procedure tkeystringeditlb.recordselected(const arecordnum: integer; 
                       const akey: keyty);
var
 bo1: boolean;
begin
 if arecordnum >= 0 then begin
  with tlbdropdownlistcontroller(fdropdown) do begin
   text:= flookupbuffer.textvaluephys(cols[0].ffieldno,arecordnum);
   tdropdowncols1(fcols).fitemindex:= arecordnum;
   tdropdowncols1(fcols).fkeyvalue:= 
            flookupbuffer.textvaluephys(fkeyfieldno,arecordnum);
  end; 
  bo1:= checkvalue;
 end
 else begin
  if arecordnum = -2 then begin
   bo1:= checkvalue; 
  end
  else begin
   feditor.undo;
  end;
 end;
 if bo1 and (akey = key_tab) then begin
  window.postkeyevent(akey);
 end;
end;

function tkeystringeditlb.internaldatatotext(const data): msestring;
var
 mstr1: msestring;
 int2,int3,int4: integer;
begin
 if @data = nil then begin
  mstr1:= value;  
 end
 else begin
  mstr1:= msestring(data);
 end;
 with tlbdropdownlistcontroller(fdropdown) do begin
  int3:= cols[valuecol].ffieldno;
  int4:= fkeyfieldno;
 end;
 with dropdown do begin
  if (flookupbuffer <> nil) and (int3 < flookupbuffer.fieldcounttext) and
           (int4 < flookupbuffer.fieldcounttext) and
           flookupbuffer.find(int4,mstr1,int2,false) then begin
   result:= flookupbuffer.textvaluephys(int3,
                 flookupbuffer.textindex(int4,int2,false));
  end
  else begin
   result:= '';
  end;
 end;
end;

{ tcopydropdownlist }

function tcopydropdownlist.locate(const filter: msestring): boolean;
var
 int1: integer;
 po1: pointer;
 co1: gridcoordty;
begin
 po1:= cols[0].datalist.datapo; //workaround internal error 200304235 in 2.0.2
 result:= findarrayvalue(filter,po1,rowcount,
                @compareimsestring,sizeof(msestring),int1);
// result:= findarrayvalue(filter,cols[0].datalist.datapo,rowcount,
//                @compareimsestring,sizeof(msestring),int1);
 if not result then begin
  result:= (int1 < rowcount) and (msecomparetextlen(filter,cols[0][int1]) = 0);
 end;
 if not result then begin
  inc(int1);
  result:= (int1 < rowcount) and (msecomparetextlen(filter,cols[0][int1]) = 0);
 end;
 if result then begin
  co1:= makegridcoord(ffocusedcell.col,int1);
  showcell(co1,cep_top);
  focuscell(makegridcoord(ffocusedcell.col,int1));
 end
 else begin
  focuscell(makegridcoord(ffocusedcell.col,-1));
 end;
end;

{ tlbdropdownstringcol }

function tlbdropdownstringcol.getrowtext(const arow: integer): msestring;
var
 int1: integer;
begin
 int1:= tlbdropdownlist(fgrid).getrecno(arow);
 if int1 >= 0 then begin
  result:= flookupbuffer.textvaluephys(ffieldno,
          flookupbuffer.textindex(fsortfieldno,int1,true));
 end
 else begin
  result:= '';
 end; 
end;

{ tlbdropdownlist }

constructor tlbdropdownlist.create(const acontroller: tlbdropdownlistcontroller;
                             acols: tdropdowncols);
var
 int1,int2,int3: integer;
begin
 if assigned(acontroller.fonfilter) then begin
  include(flbdstate,lbds_filtered);
 end;
 inherited;
 include(fstate,gs_isdb);
 int1:= acontroller.dropdownrowcount;
 if (lbds_filtered in flbdstate) then begin
  rowcount:= int1; //init frecnums;
  int3:= -1;
  for int2:= 0 to int1 - 1 do begin
   findnext(int3);
   if int3 < 0 then begin
    int1:= int2;
    break;
   end;
   frecnums[int2]:= int3;
  end;
  ffirstrecord:= frecnums[0];
  if int1 < rowcount then begin
   frame.sbvert.options:= frame.sbvert.options-[sbo_show];
   rowcount:= int1;
  end;
 end
 else begin
  if int1 > acontroller.flookupbuffer.count then begin
   int1:= acontroller.flookupbuffer.count;
   frame.sbvert.options:= frame.sbvert.options-[sbo_show];
  end;
  rowcount:= int1;
 end;
 if rowcount > 0 then begin
  row:= 0;
 end;
 with frame.sbvert do begin
  buttonlength:= 0;
  if acontroller.flookupbuffer.count > 0 then begin
   pagesize:= rowcount / acontroller.flookupbuffer.count;
  end;
 end;
end;
 
procedure tlbdropdownlist.dbscrolled(distance: integer);
var
 rect1: rectty;
 int1: integer;
begin
 if abs(distance) >= rowcount then begin
  invalidate;
 end
 else begin
  if distance <> 0 then begin
   rect1:= fdatarecty;
   rect1.cy:= rowcount*ystep;
   scrollrect(makepoint(0,-distance*ystep),rect1,true);
  end;
 end;
end;

procedure tlbdropdownlist.moveby(distance: integer);
var
 int1,int2,int3,int4,int5,int6: integer;
 rowbefore: integer;
 rea1: real;
 ar1: integerarty;
begin
 if rowcount = 0 then begin
  exit;
 end;
 rowbefore:= row;
 int1:= row + distance;
 if int1 < 0 then begin
  if (lbds_filtered in flbdstate) then begin
   setlength(ar1,rowcount);
   int4:= 0;
   for int3:= -int1-1 downto 0 do begin
    int2:= ffirstrecord;
    findprev(ffirstrecord);
    if ffirstrecord < 0 then begin
     ffirstrecord:= int2;
     break;
    end;
    if int3 <= high(ar1) then begin
     ar1[int3]:= ffirstrecord;
    end;
    dec(int4);
   end;
   if int4 <> int1 then begin
    include(flbdstate,lbds_bof);
    int2:= ffirstrecord;
    frecnums[0]:= int2;
    for int3:= 1 to rowhigh do begin
     findnext(int2);
     if int2 < 0 then begin
      for int6:= int3 to high(frecnums) do begin
       frecnums[int6]:= -1;
      end;
      break;
     end;
     frecnums[int3]:= int2;
    end; 
   end
   else begin
    exclude(flbdstate,lbds_bof);
    if int4 <= - rowcount then begin
     frecnums:= ar1;
    end
    else begin
     move(frecnums[0],frecnums[-int4],(length(frecnums)+int4)*sizeof(integer));
     move(ar1[int1-int4],frecnums[0],-int4*sizeof(integer));
    end;
   end;
   int1:= int4;
  end
  else begin
   ffirstrecord:= ffirstrecord + int1;
   if ffirstrecord < 0 then begin
    int1:= int1 - ffirstrecord;
    ffirstrecord:= 0;
   end;
  end;
  dbscrolled(int1);
  dec(rowbefore,int1);
  row:= 0;
 end
 else begin
  if int1 >= rowcount then begin
   int1:= int1 - rowcount + 1;
   if (lbds_filtered in flbdstate) then begin
    setlength(ar1,rowcount);
    int5:= frecnums[rowcount-1];
    int4:= 0;
    for int3:= 0 to int1-1 do begin
     int2:= int5;
     findnext(int5);
     if int5 < 0 then begin
      int5:= int2;
      break;
     end;
     inc(int4);
     int6:= int1 - int4;
     if int6 <= high(ar1) then begin
      ar1[high(ar1)-int6]:= int5;
     end;
    end;
    if int4 <> int1 then begin
     include(flbdstate,lbds_eof);
     frecnums[rowhigh]:= int5;
     for int3:= rowhigh - 1 downto 0 do begin
      findprev(int5);
      if int5 < 0 then begin
       for int6:= int3 downto 0 do begin
        frecnums[int6]:= -1;
       end;
       break;
      end;
      frecnums[int3]:= int5;
     end;
    end
    else begin
     exclude(flbdstate,lbds_eof);
     if int4 >= rowcount then begin
      frecnums:= ar1;
     end
     else begin
      move(frecnums[int4],frecnums[0],(rowcount-int4)*sizeof(integer));
      move(ar1[rowcount-int1],frecnums[rowcount-int4],int4*sizeof(integer));
     end;
    end;
    ffirstrecord:= frecnums[0];
    int1:= int4;
   end
   else begin
    ffirstrecord:= ffirstrecord + int1;
    int2:= ffirstrecord + rowcount - 
             tlbdropdownlistcontroller(fcontroller).flookupbuffer.count;
    if int2 > 0 then begin
     int1:= int1 - int2;
     ffirstrecord:= ffirstrecord - int2;
    end;
   end;
   dbscrolled(int1);
   dec(rowbefore,int1);
   row:= rowcount - 1;
  end
  else begin
   row:= row + distance;
  end;
 end;
 invalidaterow(rowbefore);
 invalidaterow(row);
 if (col >= 0) and (row >= 0) then begin
  feditor.text:= tlbdropdownstringcol(fdatacols[col]).getrowtext(row);
 end
 else begin
  feditor.text:= '';
 end;
 int1:= tlbdropdownlistcontroller(fcontroller).flookupbuffer.count - 1;
 if int1 <= 0 then begin
  rea1:= 0.5;
 end
 else begin
  if (lbds_filtered in flbdstate) then begin
   if lbds_eof in flbdstate then begin
    rea1:= 1;
   end
   else begin
    if lbds_bof in flbdstate then begin
     rea1:= 0;
    end
    else begin
     rea1:= 0.5;
    end;
   end;
  end
  else begin
   rea1:= activerecord / int1;
  end;
 end;
 frame.sbvert.value:= rea1;
end;

procedure tlbdropdownlist.pagedown(const action: focuscellactionty = fca_focusin);
begin
 moveby(rowcount-1);
end;

procedure tlbdropdownlist.pageup(const action: focuscellactionty = fca_focusin);
begin
 moveby(-rowcount+1);
end;

procedure tlbdropdownlist.wheeldown(const action: focuscellactionty = fca_focusin);
begin
 MoveBy(wheelheight);
end;

procedure tlbdropdownlist.wheelup(const action: focuscellactionty = fca_focusin);
begin
 MoveBy(-wheelheight);
end;

procedure tlbdropdownlist.rowdown(const action: focuscellactionty = fca_focusin);
begin
 moveby(1);
end;

procedure tlbdropdownlist.rowup(const action: focuscellactionty = fca_focusin);
begin
 moveby(-1);
end;

function tlbdropdownlist.getactiverecord: integer;
begin
 if (lbds_filtered in flbdstate) then begin
  result:= frecnums[row];
 end
 else begin
  result:= ffirstrecord + row;
 end;
end;

procedure tlbdropdownlist.setactiverecord(const avalue: integer);
var
 int1,int2,int3: integer;
begin
 if rowcount > 0 then begin
//  if row < 0 then begin
//   row:= 0;
//  end;
  if (lbds_filtered in flbdstate) then begin
   if ffirstrecord >= 0 then begin
    for int1:= 0 to high(frecnums) do begin
     if frecnums[int1] = avalue then begin
      if int1 > 0 then begin
       exclude(flbdstate,lbds_bof);
      end; 
      if int1 < rowhigh then begin
       exclude(flbdstate,lbds_eof);
      end; 
      moveby(int1-row);
      exit;
     end;
    end;
   end;
   ffirstrecord:= avalue;
   int2:= avalue;
   frecnums[0]:= int2;
   for int1:= 1 to rowhigh do begin
    findnext(int2);
    if int2 < 0 then begin
     move(frecnums[0],frecnums[rowcount-int1],int1*sizeof(integer));
     int2:= avalue;
     for int3:= rowhigh - int1 downto 0 do begin
      findprev(int2);
      frecnums[int3]:= int2;
     end;
     ffirstrecord:= frecnums[0];
     invalidate;
     moveby((rowcount - int1)-row);
     exit;
    end;
    frecnums[int1]:= int2
   end;
   invalidate;
   moveby(-row);
  end
  else begin
   if ffirstrecord < 0 then begin
    ffirstrecord:= avalue;   
    int1:= tlbdropdownlistcontroller(fcontroller).flookupbuffer.count;
    if ffirstrecord + rowcount > int1 then begin
     ffirstrecord:= int1 - rowcount;
    end;
    moveby(avalue-ffirstrecord-row);
    invalidate;
   end
   else begin
    moveby(avalue-activerecord);
   end;
  end;
 end;
end;

procedure tlbdropdownlist.internalcreateframe;
begin
 tdbgridframe.create(iscrollframe(self),self,iautoscrollframe(self));
end;

procedure tlbdropdownlist.createdatacol(const index: integer; out item: tdatacol);
begin
 item:= tlbdropdownstringcol.create(self,fdatacols);
end;

procedure tlbdropdownlist.initcols(const acols: tdropdowncols);
var
 int1: integer;
 lookupbuffer1: tcustomlookupbuffer;
begin
 inherited;
 with tlbdropdownlistcontroller(fcontroller) do begin
  lookupbuffer1:= lookupbuffer;
  fsortfieldno:= cols[0].ffieldno;
 end;
 for int1:= 0 to fdatacols.count - 1 do begin
  with tlbdropdownstringcol(fdatacols[int1]) do begin
   flookupbuffer:= lookupbuffer1;
   fsortfieldno:= self.fsortfieldno;
   ffieldno:= tlbdropdowncol(acols[int1]).ffieldno;
  end;
 end;
end;

procedure tlbdropdownlist.docellevent(var info: celleventinfoty);
begin
 inherited;
 with info do begin
  if (eventkind = cek_enter) and active then begin
   if (lbds_filtered in flbdstate) then begin
    activerecord:= frecnums[newcell.row];
   end
   else begin
    activerecord:= ffirstrecord + newcell.row;
   end;
  end;
 end;
end;

procedure tlbdropdownlist.scrollevent(sender: tcustomscrollbar; event: scrolleventty);
var
 int1: integer;
 bo1: boolean;
begin
 bo1:= true;
 if sender.tag = 1 then begin
  case event of
   sbe_stepup: rowdown(fca_focusin);
   sbe_stepdown: rowup(fca_focusin);
   sbe_pageup: pagedown(fca_focusin);
   sbe_pagedown: pageup(fca_focusin);
   sbe_valuechanged: begin end;
   sbe_thumbtrack,sbe_thumbposition: begin
    int1:= tlbdropdownlistcontroller(fcontroller).lookupbuffer.count - 1;
    if int1 >= 0 then begin
     if (lbds_filtered in flbdstate) then begin
      if event <> sbe_thumbtrack then begin
       if sender.value <= 0 then begin
        moveby(minint);
       end
       else begin
        if sender. value >= 1 then begin
         moveby(maxint);
        end
        else begin
         if sender.value < 0.5 then begin
          moveby(-rowhigh);
         end
         else begin
          moveby(rowhigh);
         end;
        end;
       end;
      end;
     end
     else begin 
      activerecord:= round(int1 * sender.value);
     end;
    end
    else begin
     sender.value:= 0.5;
    end;
   end;
   else begin
    bo1:= false;
   end;
  end;
 end
 else begin
  bo1:= false;
 end;
 if not bo1 then begin
  inherited;
 end;
end;

function tlbdropdownlist.locate(const filter: msestring): boolean;
var
 int1: integer;
begin
 result:= false;
 if (datacols.count > 0) then begin
  with tlbdropdownstringcol(datacols[0]) do begin
   result:= flookupbuffer.find(ffieldno,filter,int1,true,
              tlbdropdownlistcontroller(fcontroller).fonfilter);
   if not result then begin
    result:= (int1 < flookupbuffer.count) and 
            (msecomparetextlen(filter,
             flookupbuffer.textvaluelog(ffieldno,int1,true)) = 0);
    if not result then begin
     inc(int1);
    end;
    result:= (int1 < flookupbuffer.count) and 
          (msecomparetextlen(filter,
            flookupbuffer.textvaluelog(ffieldno,int1,true)) = 0);
   end;
  end;
 end;
 if not result then begin
  focuscell(makegridcoord(ffocusedcell.col,-1));
 end
 else begin
  ffirstrecord:= -1;
  activerecord:= int1;
 end;
end;

procedure tlbdropdownlist.dorowcountchanged(const countbefore: integer;
                                      const newcount: integer);
var
 int1: integer;
begin
 inherited;
 setlength(frecnums,newcount);
 for int1:= countbefore to newcount - 1 do begin
  frecnums[int1]:= -1;
 end;
end;

procedure tlbdropdownlist.findnext(var recno: integer);
var
 bo1: boolean;
begin
 with tlbdropdownlistcontroller(fcontroller) do begin
  repeat
   inc(recno);
   if recno >= flookupbuffer.count then begin
    recno:= -1;
    break;
   end;
   bo1:= true;
   fonfilter(flookupbuffer,flookupbuffer.textindex(fsortfieldno,recno,true),bo1);
  until bo1;
 end;
end;

procedure tlbdropdownlist.findprev(var recno: integer);
var
 bo1: boolean;
begin
 with tlbdropdownlistcontroller(fcontroller) do begin
  repeat
   dec(recno);
   if recno < 0 then begin
    recno:= -1;
    break;
   end;
   bo1:= true;
   fonfilter(flookupbuffer,flookupbuffer.textindex(fsortfieldno,recno,true),bo1);
  until bo1;
 end;
end;

function tlbdropdownlist.getrecno(const aindex: integer): integer;
var
 int1,int2: integer;
begin
 if (lbds_filtered in flbdstate) then begin
  result:= frecnums[aindex];
 end
 else begin
  result:= ffirstrecord + aindex;
 end;
end;

procedure tlbdropdownlist.dokeydown(var info: keyeventinfoty);
begin
 with info do begin
  if shiftstate = [ss_ctrl] then begin
   include(info.eventstate,es_processed);
   case key of
    key_pageup: begin
     moveby(-bigint);
    end;
    key_pagedown: begin
     moveby(bigint);
    end
    else begin
     exclude(eventstate,es_processed);
    end;
   end;
  end;
  if not (es_processed in eventstate) then begin
   inherited;
  end;
 end;
end;

end.

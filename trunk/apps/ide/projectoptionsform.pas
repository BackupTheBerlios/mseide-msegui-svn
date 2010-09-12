{ MSEide Copyright (c) 1999-2010 by Martin Schreiber
   
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
}
unit projectoptionsform;

{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface
uses
 mseforms,msefiledialog,msegui,msestat,msestatfile,msetabs,msesimplewidgets,
 msetypes,msestrings,msedataedits,msetextedit,msegraphedits,msewidgetgrid,
 msegrids,msesplitter,msesysenv,msegdbutils,msedispwidgets,msesys,mseclasses,
 msegraphutils,mseevent,msetabsglob,msedatalist,msegraphics,msedropdownlist,
 mseformatstr,mseinplaceedit,msedatanodes,mselistbrowser,msebitmap,
 msecolordialog,msedrawtext,msewidgets,msepointer,mseguiglob,msepipestream,
 msemenus,sysutils,mseglob,mseedit,db,msedialog,msescrollbar,msememodialog;

const
 defaultsourceprintfont = 'Courier';
 defaulttitleprintfont = 'Helvetica';
 defaultprintfontsize = 35.2778; //10 point
 maxdefaultmake = $40-1;
 
type
 findinfoty = record
  text: msestring;
  options: searchoptionsty;
  selectedonly: boolean;
  history: msestringarty;
 end;
 
 replaceinfoty = record
  find: findinfoty;
  replacetext: msestring;
  prompt: boolean;
 end; 
 
 sigsetinfoty = record
  num: integer;
  numto: integer;
  flags: sigflagsty;
 end;
 sigsetinfoarty = array of sigsetinfoty;

 projecttextty = record
  mainfile: filenamety;
  targetfile: filenamety;
  messageoutputfile: filenamety;
  makecommand: filenamety;
  makedir: filenamety;
  debugcommand: filenamety;
  debugoptions: msestring;
  debugtarget: filenamety;
  runcommand: filenamety;
  remoteconnection: msestring;
  uploadcommand: filenamety;
  gdbprocessor: msestring;
  gdbservercommand: filenamety;
  gdbservercommandattach: filenamety;
  beforeload: filenamety;
  afterload: filenamety;
  beforerun: filenamety;
  sourcedirs: msestringarty;
  defines: msestringarty;
  unitdirs: msestringarty;
  unitpref: msestring;
  incpref: msestring;
  libpref: msestring;
  objpref: msestring;
  targpref: msestring;
  
  befcommand: msestringarty;
  aftcommand: msestringarty;
  makeoptions: msestringarty;
  sourcefilemasks: msestringarty;
  syntaxdeffiles: msestringarty;
  filemasknames: msestringarty;
  filemasks: msestringarty;

  toolmenus: msestringarty;
  toolfiles: msestringarty;
  toolparams: msestringarty;
    
  fontnames: msestringarty;
  scriptbeforecopy: msestring;
  scriptaftercopy: msestring;
  newprojectfiles: filenamearty;
  newprojectfilesdest: filenamearty;
  newfinames: msestringarty;
  newfifilters: msestringarty;
  newfiexts: msestringarty;
  newfisources: filenamearty;
  
  newfonames: msestringarty;
  newfonamebases: msestringarty;
  newfosources: msestringarty;
  newfoforms: msestringarty;

  progparameters: msestring;
  progworkingdirectory: filenamety;
  envvarnames: msestringarty;
  envvarvalues: msestringarty;
 end;
 
{$M+} //tprojectoptions needs RTTI
 tprojectoptions = class
  private
   fcopymessages: boolean;
   fcheckmethods: boolean;
   fshowgrid: boolean;
   fsnaptogrid: boolean;
   fmoveonfirstclick: boolean;
   fgridsizex: integer;
   fgridsizey: integer;
   fautoindent: boolean;
   fblockindent: integer;
   frightmarginon: boolean;
   frightmarginchars: integer;
   fscrollheight: integer;
   ftabstops: integer;
   fspacetabs: boolean;
   ftabindent: boolean;
   feditfontname: string;
   feditfontheight: integer;
   feditfontwidth: integer;
   feditfontextraspace: integer;
   feditfontcolor: integer;
   feditbkcolor: integer;
   fstatementcolor: integer;
   feditfontantialiased: boolean;
   feditmarkbrackets: boolean;
   fbackupfilecount: integer;
   fencoding: integer;
   fclosemessages: boolean;
   fusercolors: colorarty;
   fusercolorcomment: msestringarty;
   fstoponexception: boolean;
   fvaluehints: boolean;
   factivateonbreak: boolean;
   fshowconsole: boolean;
   fexternalconsole: boolean;
   fgdbdownload: boolean;
   fdownloadalways: boolean;
   fstartupbkpt: integer;
   fstartupbkpton: boolean;
   fgdbsimulator: boolean;
   fgdbserverwait: real;
   fexceptclassnames: msestringarty;
   fexceptignore: booleanarty;
   function limitgridsize(const avalue: integer): integer;
   procedure setgridsizex(const avalue: integer);
   procedure setgridsizey(const avalue: integer);
  public
   constructor create;
  published
   property copymessages: boolean read fcopymessages write fcopymessages;
   property closemessages: boolean read fclosemessages write fclosemessages;
   property checkmethods: boolean read fcheckmethods write fcheckmethods;

   property showgrid: boolean read fshowgrid write fshowgrid;
   property snaptogrid: boolean read fsnaptogrid write fsnaptogrid;
   property moveonfirstclick: boolean read fmoveonfirstclick 
                                         write fmoveonfirstclick;
   property gridsizex: integer read fgridsizex write setgridsizex;
   property gridsizey: integer read fgridsizey write setgridsizey;
   property autoindent: boolean read fautoindent write fautoindent;
   property blockindent: integer read fblockindent write fblockindent;
   property rightmarginon: boolean read frightmarginon write frightmarginon;
   property rightmarginchars: integer read frightmarginchars 
                                                    write frightmarginchars;
   property scrollheight: integer read fscrollheight write fscrollheight;
   property tabstops: integer read ftabstops write ftabstops;
   property spacetabs: boolean read fspacetabs write fspacetabs;
   property tabindent: boolean read ftabindent write ftabindent;
   property editfontname: string read feditfontname write feditfontname;
   property editfontheight: integer read feditfontheight write feditfontheight;
   property editfontwidth: integer read feditfontwidth write feditfontwidth;
   property editfontextraspace: integer read feditfontextraspace 
                                                      write feditfontextraspace;
   property editfontcolor: integer read feditfontcolor write feditfontcolor;
   property editbkcolor: integer read feditbkcolor write feditbkcolor;
   property statementcolor: integer read fstatementcolor write fstatementcolor;
   
   property editfontantialiased: boolean read feditfontantialiased 
                                              write feditfontantialiased;
   property editmarkbrackets: boolean read feditmarkbrackets 
                                              write feditmarkbrackets;
   property backupfilecount: integer read fbackupfilecount 
                                              write fbackupfilecount;
   property encoding: integer read fencoding write fencoding;

   property usercolors: colorarty read fusercolors write fusercolors;
   property usercolorcomment: msestringarty read fusercolorcomment 
                                                 write fusercolorcomment;

   property stoponexception: boolean read fstoponexception write fstoponexception;
   property valuehints: boolean read fvaluehints write fvaluehints;
   property activateonbreak: boolean read factivateonbreak write factivateonbreak;
   property showconsole: boolean read fshowconsole write fshowconsole;
   property externalconsole: boolean read fexternalconsole write fexternalconsole;
   property gdbdownload: boolean read fgdbdownload write fgdbdownload;
   property downloadalways: boolean read fdownloadalways write fdownloadalways;
   property startupbkpt: integer read fstartupbkpt write fstartupbkpt;
   property startupbkpton: boolean read fstartupbkpton write fstartupbkpton;
   property gdbsimulator: boolean read fgdbsimulator write fgdbsimulator;
   property gdbserverwait: real read fgdbserverwait write fgdbserverwait;

   property exceptclassnames: msestringarty read fexceptclassnames 
                                                 write fexceptclassnames;
   property exceptignore: booleanarty read fexceptignore 
                                                 write fexceptignore;
 end;
 
 projectoptionsty = record
  o: tprojectoptions;
  modified: boolean;
  savechecked: boolean;
  ignoreexceptionclasses: stringarty;
  t: projecttextty;
  texp: projecttextty;
  projectfilename: filenamety;
  projectdir: filenamety;
  fontalias: msestringarty;
  fontancestors: msestringarty;
  fontheights: integerarty;
  fontwidths: integerarty;
  fontoptions: msestringarty;
  fontxscales: realarty;
  
  defineson: longboolarty;
  
  modulenames: msestringarty;
  moduletypes: msestringarty;
  modulefilenames: filenamearty;

  defaultmake: integer;
  befcommandon: integerarty;
  makeoptionson: integerarty;
  aftcommandon: integerarty;
  unitdirson: integerarty;

  macroon: integerarty;
  macronames,macrovalues: msestringarty;
  macrogroup: integer;
  groupcomments: msestringarty;

  breakpointpaths: msestringarty;
  breakpointlines: integerarty;
  breakpointaddress: int64arty;
  addressbreakpoints: longboolarty;
  breakpointons: longboolarty;
  breakpointignore: integerarty;
  breakpointconditions: msestringarty;

  sigsettings: sigsetinfoarty;
  //programparameters
  propgparamhistory: msestringarty;
  envvarons: longboolarty;
  
  //editor
  findreplaceinfo: replaceinfoty;
  
  //templates
  expandprojectfilemacros: longboolarty;
  loadprojectfile: longboolarty;

  //newform  
  newinheritedforms: longboolarty;
  
  //tools
  toolsave: longboolarty;
  toolhide: longboolarty;
  toolparse: longboolarty;
 end;

 tprojectoptionsfo = class(tmseform)
   statfile1: tstatfile;
   tlayouter9: tlayouter;
   tlayouter8: tlayouter;
   cancel: tbutton;
   ok: tbutton;
   tabwidget: ttabwidget;
   editorpage: ttabpage;
   tgroupbox1: tgroupbox;
   showgrid: tbooleanedit;
   snaptogrid: tbooleanedit;
   gridsizex: tintegeredit;
   tintegeredit2: tintegeredit;
   gridsizey: tintegeredit;
   moveonfirstclick: tbooleanedit;
   debuggerpage: ttabpage;
   debugcommand: tfilenameedit;
   debugoptions: tstringedit;
   ttabwidget1: ttabwidget;
   ttabpage6: ttabpage;
   sourcedirgrid: twidgetgrid;
   sourcedirs: tfilenameedit;
   ttabpage9: ttabpage;
   twidgetgrid2: twidgetgrid;
   defon: tbooleanedit;
   def: tstringedit;
   ttabpage7: ttabpage;
   signalgrid: twidgetgrid;
   sigstop: tbooleanedit;
   sighandle: tbooleanedit;
   signum: tintegeredit;
   signumto: tintegeredit;
   signame: tselector;
   ttabpage8: ttabpage;
   exceptionsgrid: twidgetgrid;
   exceptignore: tbooleanedit;
   exceptclassnames: tstringedit;
   ttabpage16: ttabpage;
   remoteconnection: tstringedit;
   tlayouter3: tlayouter;
   gdbprocessor: tdropdownlistedit;
   gdbsimulator: tbooleanedit;
   gdbdownload: tbooleanedit;
   tlayouter4: tlayouter;
   gdbbeforeload: tfilenameedit;
   tsplitter7: tsplitter;
   gdbafterload: tfilenameedit;
   tlayouter5: tlayouter;
   gdbbeforerun: tfilenameedit;
   tsplitter8: tsplitter;
   tlayouter1: tlayouter;
   externalconsole: tbooleanedit;
   showconsole: tbooleanedit;
   stoponexception: tbooleanedit;
   activateonbreak: tbooleanedit;
   makepage: ttabpage;
   tspacer2: tspacer;
   defaultmake: tenumedit;
   mainfile: tfilenameedit;
   targetfile: tfilenameedit;
   makecommand: tfilenameedit;
   showcommandline: tbutton;
   messageoutputfile: tfilenameedit;
   copymessages: tbooleanedit;
   closemessages: tbooleanedit;
   checkmethods: tbooleanedit;
   makegroupbox: ttabwidget;
   ttabpage12: ttabpage;
   makeoptionsgrid: twidgetgrid;
   makeon: tbooleanedit;
   buildon: tbooleanedit;
   make1on: tbooleanedit;
   make2on: tbooleanedit;
   make3on: tbooleanedit;
   make4on: tbooleanedit;
   makeoptions: tmemodialogedit;
   ttabpage11: ttabpage;
   unitdirgrid: twidgetgrid;
   dmakeon: tbooleanedit;
   dbuildon: tbooleanedit;
   dmake1on: tbooleanedit;
   dmake2on: tbooleanedit;
   dmake3on: tbooleanedit;
   dmake4on: tbooleanedit;
   duniton: tbooleanedit;
   dincludeon: tbooleanedit;
   dlibon: tbooleanedit;
   dobjon: tbooleanedit;
   unitdirs: tfilenameedit;
   unitpref: tstringedit;
   incpref: tstringedit;
   libpref: tstringedit;
   objpref: tstringedit;
   tspacer1: tspacer;
   targpref: tstringedit;
   makedir: tfilenameedit;
   tsplitter1: tsplitter;
   tsplitter2: tsplitter;
   tsplitter3: tsplitter;
   tsplitter4: tsplitter;
   tsplitter5: tsplitter;
   ttabpage1: ttabpage;
   macrogrid: twidgetgrid;
   e0: tbooleanedit;
   e1: tbooleanedit;
   e2: tbooleanedit;
   e3: tbooleanedit;
   e4: tbooleanedit;
   e5: tbooleanedit;
   macronames: tstringedit;
   macrovalues: tmemodialogedit;
   selectactivegroupgrid: twidgetgrid;
   activemacroselect: tbooleaneditradio;
   groupcomment: tstringedit;
   macrosplitter: tsplitter;
   fontaliaspage: ttabpage;
   fontaliasgrid: twidgetgrid;
   fontalias: tstringedit;
   fontname: tstringedit;
   fontheight: tintegeredit;
   ttabpage10: ttabpage;
   tlayouter7: tlayouter;
   tbutton1: tbutton;
   colgrid: twidgetgrid;
   coldi: tpointeredit;
   usercolors: tcoloredit;
   usercolorcomment: tstringedit;
   ttabpage2: ttabpage;
   newfile: ttabwidget;
   ttabpage3: ttabpage;
   copygrid: twidgetgrid;
   loadprojectfile: tbooleanedit;
   expandprojectfilemacros: tbooleanedit;
   newprojectfiles: tfilenameedit;
   newprojectfilesdest: tstringedit;
   ttabpage4: ttabpage;
   ttabpage5: ttabpage;
   ttabpage15: ttabpage;
   twidgetgrid3: twidgetgrid;
   toolsave: tbooleanedit;
   toolparse: tbooleanedit;
   toolhide: tbooleanedit;
   toolmenu: tstringedit;
   toolfile: tfilenameedit;
   toolparam: tstringedit;
   tlayouter13: tlayouter;
   dispgrid: twidgetgrid;
   fontdisp: ttextedit;
   tlayouter12: tlayouter;
   editfontextraspace: tintegeredit;
   editfontwidth: tintegeredit;
   editfontheight: tintegeredit;
   editfontname: tstringedit;
   tlayouter11: tlayouter;
   encoding: tenumedit;
   scrollheight: tintegeredit;
   rightmarginchars: tintegeredit;
   rightmarginon: tbooleanedit;
   tlayouter10: tlayouter;
   backupfilecount: tintegeredit;
   spacetabs: tbooleanedit;
   tabstops: tintegeredit;
   blockindent: tintegeredit;
   autoindent: tbooleanedit;
   ttabwidget2: ttabwidget;
   ttabpage13: ttabpage;
   tspacer3: tspacer;
   filefiltergrid: tstringgrid;
   ttabpage14: ttabpage;
   grid: tstringgrid;
   serverla: tlayouter;
   uploadcommand: tfilenameedit;
   gdbservercommand: tfilenameedit;
   gdbserverwait: trealedit;
   downloadalways: tbooleanedit;
   startupbkpt: tintegeredit;
   startupbkpton: tbooleanedit;
   valuehints: tbooleanedit;
   debugtarget: tfilenameedit;
   runcommand: tfilenameedit;
   tsplitter6: tsplitter;
   fontwidth: tintegeredit;
   fontoptions: tstringedit;
   fontxscale: trealedit;
   twidgetgrid4: twidgetgrid;
   newformname: tstringedit;
   newformsourcefile: tfilenameedit;
   newformformfile: tfilenameedit;
   tlayouter2: tlayouter;
   gdbservercommandattach: tfilenameedit;
   scriptbeforecopy: tfilenameedit;
   scriptaftercopy: tfilenameedit;
   newinheritedform: tbooleanedit;
   newformnamebase: tstringedit;
   twidgetgrid1: twidgetgrid;
   newfiname: tstringedit;
   newfisource: tfilenameedit;
   newfifilter: tstringedit;
   newfiext: tstringedit;
   tabindent: tbooleanedit;
   fontancestors: tstringedit;
   editfontcolor: tcoloredit;
   editbkcolor: tcoloredit;
   editfontantialiased: tbooleanedit;
   editmarkbrackets: tbooleanedit;
   statementcolor: tcoloredit;
   ttabpage17: ttabpage;
   ttabpage18: ttabpage;
   befcommandgrid: twidgetgrid;
   befmakeon: tbooleanedit;
   befbuildon: tbooleanedit;
   befmake1on: tbooleanedit;
   befmake2on: tbooleanedit;
   befmake3on: tbooleanedit;
   befmake4on: tbooleanedit;
   befcommand: tmemodialogedit;
   aftcommandgrid: twidgetgrid;
   aftmakeon: tbooleanedit;
   aftbuildon: tbooleanedit;
   aftmake1on: tbooleanedit;
   aftmake2on: tbooleanedit;
   aftmake3on: tbooleanedit;
   aftmake4on: tbooleanedit;
   aftcommand: tmemodialogedit;
   procedure acttiveselectondataentered(const sender: TObject);
   procedure colonshowhint(const sender: tdatacol; const arow: Integer; 
                      var info: hintinfoty);
   procedure hintexpandedmacros(const sender: TObject; var info: hintinfoty);
   procedure selectactiveonrowsmoved(const sender: tcustomgrid; 
                const fromindex: Integer; const toindex: Integer;
                const acount: Integer);
   procedure expandfilename(const sender: TObject; var avalue: mseString; 
                var accept: Boolean);
   procedure showcommandlineonexecute(const sender: TObject);
   procedure signameonsetvalue(const sender: TObject; var avalue: integer;
                var accept: Boolean);
   procedure signumonsetvalue(const sender: TObject; var avalue: integer;
                var accept: Boolean);
   procedure signumtoonsetvalue(const sender: TObject; var avalue: Integer;
                var accept: Boolean);
   procedure fontondataentered(const sender: TObject);
   procedure makepageonchildscaled(const sender: TObject);
   procedure debuggeronchildscaled(const sender: TObject);
   procedure macronchildscaled(const sender: TObject);
   procedure formtemplateonchildscaled(const sender: TObject);
   procedure encodingsetvalue(const sender: TObject; var avalue: integer;
                   var accept: Boolean);
   procedure createexe(const sender: TObject);
   procedure drawcol(const sender: tpointeredit; const acanvas: tcanvas;
                   const avalue: Pointer; const arow: Integer);
   procedure colsetvalue(const sender: TObject; var avalue: colorty;
                   var accept: Boolean);
   procedure copycolorcode(const sender: TObject);
   procedure downloadchange(const sender: TObject);
   procedure processorchange(const sender: TObject);
   procedure copymessagechanged(const sender: TObject);
   procedure runcommandchange(const sender: TObject);
   procedure newprojectchildscaled(const sender: TObject);
  private
   procedure activegroupchanged;
 end;

function readprojectoptions(const filename: filenamety): boolean;
         //true if ok
procedure saveprojectoptions(filename: filenamety = '');
procedure initprojectoptions;
function editprojectoptions: boolean;
    //true if not aborted
function getprojectmacros: macroinfoarty;
procedure expandprojectmacros;
function expandprmacros(const atext: msestring): msestring;
procedure expandprmacros1(var atext: msestring);
function projecttemplatedir: filenamety;
function projectfiledialog(var aname: filenamety; save: boolean): modalresultty;
procedure projectoptionsmodified;
function checkprojectloadabort: boolean; //true on load abort

function getsigname(const anum: integer): string;
procedure projectoptionstofont(const afont: tfont);
function objpath(const aname: filenamety): filenamety;
function gettargetfile: filenamety;

var
 projectoptions: projectoptionsty;
 projecthistory: filenamearty;

implementation
uses
 projectoptionsform_mfm,breakpointsform,sourceform,mseact,msereal,
 objectinspector,msebits,msefileutils,msedesignintf,guitemplates,
 watchform,stackform,main,projecttreeform,findinfileform,
 selecteditpageform,programparametersform,sourceupdate,
 msedesigner,panelform,watchpointsform,commandlineform,msestream,
 componentpaletteform,mserichstring,msesettings,formdesigner,
 msestringlisteditor,msetexteditor,msepropertyeditors,mseshapes,mseactions,
 componentstore,cpuform
 {$ifndef mse_no_db}{$ifdef FPC},msedbfieldeditor{$endif}{$endif};

var
 projectoptionsfo: tprojectoptionsfo;
type

 signalinfoty = record
  num: integer;
  flags: sigflagsty;
  name: string;
  comment: string;
 end;

const
 findinfiledialogstatname =  'findinfiledialogfo.sta';
 finddialogstatname =        'finddialogfo.sta';
 replacedialogstatname =     'replacedialogfo.sta';
 optionsstatname =           'optionsfo.sta';
 settaborderstatname =       'settaborderfo.sta';
 setcreateorderstatname =    'setcreateorderfo.sta';
 programparametersstatname = 'programparametersfo.sta';
 settingsstatname =          'settingsfo.sta';
 printerstatname =           'printer.sta';
 imageselectorstatname =     'imageselector.sta';
 fadeeditorstatname =        'fadeeditor.sta';
 siginfocount = 30;
 siginfos: array[0..siginfocount-1] of signalinfoty = (
  (num:  1; flags: [sfl_stop]; name: 'SIGHUP'; comment: 'Hangup'),
  (num:  2; flags: [sfl_stop,sfl_internal,sfl_handle]; name: 'SIGINT'; comment: 'Interrupt'),
  (num:  3; flags: [sfl_stop]; name: 'SIGQUIT'; comment: 'Quit'),
  (num:  4; flags: [sfl_stop]; name: 'SIGILL'; comment: 'Illegal instruction'),
  (num:  5; flags: [sfl_stop,sfl_internal,sfl_handle]; name: 'SIGTRAP'; comment: 'Trace trap'),
  (num:  6; flags: [sfl_stop]; name: 'SIGABRT'; comment: 'Abort'),
  (num:  7; flags: [sfl_stop]; name: 'SIGBUS'; comment: 'BUS error'),
  (num:  8; flags: [sfl_stop]; name: 'SIGFPE'; comment: 'Floating-point exception'),
  (num:  9; flags: [sfl_stop]; name: 'SIGKILL'; comment: 'Kill, unblockable'),
  (num: 10; flags: [sfl_stop]; name: 'SIGUSR1'; comment: 'User-defined signal 1'),
  (num: 11; flags: [sfl_stop]; name: 'SIGSEGV'; comment: 'Segmentation violation'),
  (num: 12; flags: [sfl_stop]; name: 'SIGUSR2'; comment: 'User-defined signal 2'),
  (num: 13; flags: [sfl_stop]; name: 'SIGPIPE'; comment: 'Broken pipe'),
  (num: 14; flags: [sfl_internal]; name: 'SIGALRM'; comment: 'Alarm clock'),
  (num: 15; flags: [sfl_stop]; name: 'SIGTERM'; comment: 'Termination'),
  (num: 16; flags: [sfl_stop]; name: 'SIGSTKFLT'; comment: 'Stack fault'),
  (num: 17; flags: [{sfl_stop}]; name: 'SIGCHLD'; comment: 'Child status has changed'),
  (num: 18; flags: [sfl_stop]; name: 'SIGCONT'; comment: 'Continue'),
  (num: 19; flags: [sfl_stop]; name: 'SIGSTOP'; comment: 'Stop, unblockable'),
  (num: 20; flags: [sfl_stop]; name: 'SIGTSTP'; comment: 'Keyboard stop'),
  (num: 21; flags: [sfl_stop]; name: 'SIGTTIN'; comment: 'Background read from tty'),
  (num: 22; flags: [sfl_stop]; name: 'SIGTTOU'; comment: 'Background write to tty'),
  (num: 23; flags: [sfl_stop]; name: 'SIGURG'; comment: 'Urgent condition on socket'),
  (num: 24; flags: [sfl_stop]; name: 'SIGXCPU'; comment: 'CPU limit exceeded'),
  (num: 25; flags: [sfl_stop]; name: 'SIGXFSZ'; comment: 'File size limit exceeded'),
  (num: 26; flags: [sfl_stop]; name: 'SIGTALRM'; comment: 'Virtual alarm clock'),
  (num: 27; flags: [sfl_stop]; name: 'SIGPROF'; comment: 'Profiling alarm clock'),
  (num: 28; flags: [sfl_stop]; name: 'SIGWINCH'; comment: 'Window size change'),
  (num: 29; flags: [sfl_stop]; name: 'SIGIO'; comment: 'I/O now possible'),
  (num: 30; flags: [sfl_stop]; name: 'SIGPWR'; comment: 'Power failure restart')
  );

function getsigname(const anum: integer): string;
var
 int1: integer;
begin
 result:= '';
 for int1:= 0 to high(siginfos) do begin
  if siginfos[int1].num = anum then begin
   result:= siginfos[int1].name;
   break;
  end;
 end;
 if result = '' then begin
  result:= 'SIG'+inttostr(anum);
 end;
end;

function objpath(const aname: filenamety): filenamety;
begin
 result:= '';
 if aname <> '' then begin
  result:= filepath(projectoptions.texp.makedir,aname);
 end;
end;

function getprojectmacros: macroinfoarty;
begin
 setlength(result,4);
 with projectoptions do begin
  with result[0] do begin
   name:= 'PROJECTNAME';
   value:= removefileext(filename(projectfilename))
  end;
  with result[1] do begin
   name:= 'PROJECTDIR';
   value:= tosysfilepath(getcurrentdir)+pathdelim;
  end;
  with result[2] do begin
   name:= 'MAINFILE';
   if projectoptionsfo = nil then begin
    value:= t.mainfile;
   end
   else begin
    value:= projectoptionsfo.mainfile.value;
   end;
  end;
  with result[3] do begin
   name:= 'TARGETFILE';
   if projectoptionsfo = nil then begin
    value:= t.targetfile;
   end
   else begin
    value:= projectoptionsfo.targetfile.value;
   end;
  end;
 end;
end;

function gettargetfile: filenamety;
begin
 with projectoptions.texp do begin
  if trim(debugtarget) <> '' then begin
   result:= objpath(debugtarget);
  end
  else begin
   result:= objpath(targetfile);
  end;
 end;
end;

procedure projectoptionstofont(const afont: tfont);
begin
 with projectoptions,afont do begin
  name:= o.editfontname;
  height:= o.editfontheight;
  width:= o.editfontwidth;
  extraspace:= o.editfontextraspace;
  if o.editfontantialiased then begin
   options:= options + [foo_antialiased];
  end
  else begin
   options:= options + [foo_nonantialiased];
  end;
  color:= o.editfontcolor;
 end;
end;

function checkprojectloadabort: boolean;
begin
 result:= false;
 if exceptobject is exception then begin
  if showmessage(exception(exceptobject).Message,'ERROR',[mr_ok,mr_cancel]) <> 
                               mr_ok then begin
   result:= true;
  end;
 end
 else begin
  raise exception.create('Invalid exception');
 end;
end;

function projectfiledialog(var aname: filenamety; save: boolean): modalresultty;
begin
 aname:= projectoptions.projectfilename;
 if save then begin
  result:= filedialog(aname,[fdo_save,fdo_checkexist],'Save Project',
          ['Project files','All files'],['*.prj','*'],'prj',
          nil,nil,nil,[fa_all],[fa_hidden],@projecthistory);
 end
 else begin
  result:= filedialog(aname,[fdo_checkexist],'Open Project',
          ['Project files','All files'],['*.prj','*'],'prj',
          nil,nil,nil,[fa_all],[fa_hidden],@projecthistory);
 end;
end;

function getmacros: tmacrolist;
var
 ar1: macroinfoarty;
 int1,int2: integer;
 mask: integer;
 
begin
 with projectoptions do begin
  result:= tmacrolist.create([mao_caseinsensitive]);
  result.add(getsettingsmacros);
  result.add(getcommandlinemacros);
  result.add(getprojectmacros);
  mask:= bits[macrogroup];
  setlength(macrovalues,length(macronames));
  setlength(ar1,length(macronames)); //max
  int2:= 0;
  for int1:= 0 to high(ar1) do begin
   if macroon[int1] and mask <> 0 then begin
    ar1[int2].name:= macronames[int1];
    ar1[int2].value:= macrovalues[int1];
    inc(int2);
   end;
  end;
  setlength(ar1,int2);
  result.add(ar1);
 end;
end;

procedure expandprmacros1(var atext: msestring);
var
 li: tmacrolist;
begin
 li:= getmacros;
 li.expandmacros(atext);
 li.Free;
end;

function projecttemplatedir: filenamety;
begin
 result:= expandprmacros('${TEMPLATEDIR}');
end;

function expandprmacros(const atext: msestring): msestring;
begin
 result:= atext;
 expandprmacros1(result);
end;

var
 initfontaliascount: integer;
 
procedure expandprojectmacros;
var
 li: tmacrolist;
 int1,int2: integer;
 bo1: boolean;
 item1: tmenuitem;
begin
 li:= getmacros;
 with projectoptions do begin
  texp:= t;
  with texp do begin
   li.expandmacros(mainfile);
   li.expandmacros(targetfile);
   li.expandmacros(messageoutputfile);
   li.expandmacros(makecommand);
   li.expandmacros(makedir);
   li.expandmacros(debugcommand);
   li.expandmacros(debugoptions);
   li.expandmacros(debugtarget);
   li.expandmacros(runcommand);
   li.expandmacros(remoteconnection);
   li.expandmacros(uploadcommand);
   li.expandmacros(gdbservercommand);
   li.expandmacros(gdbservercommandattach);
   li.expandmacros(beforeload);
   li.expandmacros(afterload);
   li.expandmacros(beforerun);
   li.expandmacros(gdbprocessor);
   li.expandmacros(sourcedirs);
   li.expandmacros(defines);
   li.expandmacros(unitdirs);
   li.expandmacros(unitpref);
   li.expandmacros(incpref);
   li.expandmacros(libpref);
   li.expandmacros(objpref);
   li.expandmacros(targpref);
   li.expandmacros(befcommand);
   li.expandmacros(aftcommand);
   li.expandmacros(makeoptions);
   li.expandmacros(sourcefilemasks);
   li.expandmacros(syntaxdeffiles);
   li.expandmacros(filemasknames);
   li.expandmacros(filemasks);
   li.expandmacros(toolmenus);
   li.expandmacros(toolfiles);
   li.expandmacros(toolparams);
   li.expandmacros(fontnames);
   li.expandmacros(scriptbeforecopy);
   li.expandmacros(scriptaftercopy);
   li.expandmacros(newprojectfiles);
   li.expandmacros(newprojectfilesdest);

   li.expandmacros(newfinames);
   li.expandmacros(newfifilters);
   li.expandmacros(newfiexts);
   li.expandmacros(newfisources);
  
   li.expandmacros(newfonames);
   li.expandmacros(newfonamebases);
   li.expandmacros(newfosources);
   li.expandmacros(newfoforms);
   li.expandmacros(progparameters);
   li.expandmacros(progworkingdirectory);
   li.expandmacros(envvarnames);
   li.expandmacros(envvarvalues);

   if initfontaliascount = 0 then begin
    initfontaliascount:= fontaliascount;
   end;
   setfontaliascount(initfontaliascount);
//   clearfontalias;
   int2:= high(fontalias);
   int1:= high(fontancestors);
   setlength(fontancestors,int2+1); //additional field
   for int1:= int1+1 to int2 do begin
    fontancestors[int1]:= 'sft_default';
   end;
   if int2 > high(fontnames) then begin
    int2:= high(fontnames);
   end;
   if int2 > high(fontheights) then begin
    int2:= high(fontheights);
   end;
   if int2 > high(fontwidths) then begin
    int2:= high(fontwidths);
   end;
   if int2 > high(fontoptions) then begin
    int2:= high(fontoptions);
   end;
   if int2 > high(fontxscales) then begin
    int2:= high(fontxscales);
   end;
   for int1:= 0 to int2 do begin
    try
     registerfontalias(fontalias[int1],fontnames[int1],fam_overwrite,
                fontheights[int1],fontwidths[int1],
                fontoptioncharstooptions(fontoptions[int1]),
                fontxscales[int1],fontancestors[int1]);
    except
     application.handleexception;
    end;
   end;
   if sourceupdater <> nil then begin
    sourceupdater.maxlinelength:= o.rightmarginchars;
   end;
   fontaliasnames:= fontalias;
   with sourcefo.syntaxpainter do begin
    bo1:= not cmparray(defdefs.asarraya,texp.sourcefilemasks) or
       not cmparray(defdefs.asarrayb,texp.syntaxdeffiles);
    defdefs.asarraya:= texp.sourcefilemasks;
    defdefs.asarrayb:= texp.syntaxdeffiles;
    if bo1 then begin
     sourcefo.syntaxpainter.clear;
     for int1:= 0 to sourcefo.count - 1 do begin
      sourcefo.items[int1].edit.setsyntaxdef(sourcefo.items[int1].edit.filename);
     end;
    end;
   end;
   for int1:= 0 to sourcefo.count - 1 do begin
    sourcefo.items[int1].updatestatvalues;
   end;
   with mainfo.openfile.controller.filterlist do begin
    asarraya:= filemasknames;
    asarrayb:= filemasks;
   end;
   item1:= mainfo.mainmenu1.menu.itembynames(['file','new']);
   item1.submenu.count:= 1;
   item1.submenu.count:= length(newfinames)+1;
   for int1:= 0 to high(newfinames) do begin
    with item1.submenu[int1+1] do begin
     caption:= newfinames[int1];
     tag:= int1;
     onexecute:= {$ifdef FPC}@{$endif}mainfo.newfileonexecute;
    end;
   end;

   item1:= mainfo.mainmenu1.menu.itembynames(['file','new','form']);
   item1.submenu.count:= 0;
   item1.submenu.count:= length(newfonames)+1;
   int2:= 0;
   for int1:= 0 to high(newfonames) do begin
    if not newinheritedforms[int1] then begin
     with item1.submenu[int2] do begin
      caption:= newfonames[int1];
      tag:= int1;
      onexecute:= {$ifdef FPC}@{$endif}mainfo.newformonexecute;
     end;
     inc(int2);
    end;
   end;
   item1.submenu[int2].options:= [mao_separator];
   inc(int2);
   for int1:= 0 to high(newfonames) do begin
    if newinheritedforms[int1] then begin
     with item1.submenu[int2] do begin
      caption:= newfonames[int1];
      tag:= int1;
      onexecute:= {$ifdef FPC}@{$endif}mainfo.newformonexecute;
     end;
     inc(int2);
    end;
   end;
   with mainfo.mainmenu1.menu.submenu do begin
    item1:= itembyname('tools');
    if toolmenus <> nil then begin
     if item1 = nil then begin
      item1:= tmenuitem.create;
      item1.name:= 'tools';
      item1.caption:= 'T&ools';
      insert(itemindexbyname('settings'),item1);
     end;
     with item1.submenu do begin
      clear;
      for int1:= 0 to high(toolmenus) do begin
       if (int1 > high(toolfiles)) or (int1 > high(toolparams)) then begin
        break;
       end;
       insert(bigint,[toolmenus[int1]],[[mao_asyncexecute]],
                               [],[{$ifdef FPC}@{$endif}mainfo.runtool]);
      end;
     end;
    end
    else begin
     if item1 <> nil then begin
      delete(item1.index);
     end;
    end;
   end;
  end;
  ignoreexceptionclasses:= nil;
  for int1:= 0 to high(o.exceptignore) do begin
   if int1 > high(o.exceptclassnames) then begin
    break;
   end;
   if o.exceptignore[int1] then begin
    additem(ignoreexceptionclasses,o.exceptclassnames[int1]);
   end;
  end;
  for int1:= 0 to usercolorcount - 1 do begin
   if int1 > high(o.usercolors) then begin
    break;
   end;
   setcolormapvalue(cl_user + longword(int1),o.usercolors[int1]);
  end;
 end;
 li.free;
 mainfo.updatesigsettings;
end;

function defaultsigsettings: sigsetinfoarty;
var
 int1,int2: integer;
begin
 setlength(result,siginfocount);
 int2:= 0;
 for int1:= 0 to siginfocount - 1 do begin
  with result[int2] do begin
   if not (sfl_internal in siginfos[int1].flags) then begin
    num:= siginfos[int1].num;
    numto:= num;
    flags:= siginfos[int1].flags;
    inc(int2);
   end;
  end;
 end;
 setlength(result,int2);
end;

procedure initprojectoptions;
const 
 alloptionson = 1+2+4+8+16+32;
 unitson = 1+2+4+8+16+32+$10000;
 allon = unitson+$20000+$40000;
var
 int1: integer;
begin
 projectoptions.o.free;
 finalize(projectoptions);
 fillchar(projectoptions,sizeof(projectoptions),0);
 projectoptions.o:= tprojectoptions.create;
 with projectoptions,t do begin
  deletememorystatstream(findinfiledialogstatname);
  deletememorystatstream(finddialogstatname);
  deletememorystatstream(replacedialogstatname);
  deletememorystatstream(optionsstatname);
  deletememorystatstream(settaborderstatname);
  deletememorystatstream(setcreateorderstatname);
  deletememorystatstream(programparametersstatname);
  deletememorystatstream(printerstatname);
  deletememorystatstream(imageselectorstatname);
  deletememorystatstream(stringlisteditorstatname);
  deletememorystatstream(texteditorstatname);
  deletememorystatstream(colordialogstatname);
  deletememorystatstream(bmpfiledialogstatname);
  deletememorystatstream(fadeeditorstatname);
  {$ifndef mse_no_db}{$ifdef FPC}
  deletememorystatstream(dbfieldeditorstatname);
  {$endif}{$endif}
  modified:= false;
  savechecked:= false;
  sigsettings:= defaultsigsettings;
  ignoreexceptionclasses:= nil;

  befcommand:= nil;
  aftcommand:= nil;
  befcommandon:= nil;
  aftcommandon:= nil;
  
  makeoptions:= nil;
  additem(makeoptions,'-l -Mobjfpc -Sh');
  additem(makeoptions,'-gl');
  additem(makeoptions,'-B');
  additem(makeoptions,'-O2 -XX -CX -Xs');
  setlength(makeoptionson,length(makeoptions));
  for int1:= 0 to high(makeoptionson) do begin
   makeoptionson[int1]:= alloptionson;
  end;
  makeoptionson[1]:= alloptionson and not bits[5]; 
                     //all but make 4
  makeoptionson[2]:= bits[1] or bits[5]; //build + make 4
  makeoptionson[3]:= bits[5]; //make 4
  unitdirson:= nil;
  macroon:= nil;
  macronames:= nil;
  macrovalues:= nil;
  findreplaceinfo.find.options:= [so_caseinsensitive];
  mainfile:= '';
  targetfile:= '';
  messageoutputfile:= '';
  defaultmake:= 1; //make
  sourcedirs:= nil;
  additem(sourcedirs,'./');
  additem(sourcedirs,'${MSELIBDIR}*/');
  additem(sourcedirs,'${MSELIBDIR}kernel/$TARGET/');
  sourcedirs:= reversearray(sourcedirs);
  defines:= nil;
  defineson:= nil;
  unitdirs:= nil;
  additem(unitdirs,'${MSELIBDIR}*/');
  additem(unitdirs,'${MSELIBDIR}kernel/');
  additem(unitdirs,'${MSELIBDIR}kernel/$TARGET/');
  setlength(unitdirson,length(unitdirs));
  for int1:= 0 to high(unitdirson) do begin
   unitdirson[int1]:= unitson;
  end;
  unitdirson[1]:= unitson + $20000; //kernel include
  unitdirs:= reversearray(unitdirs);
  unitdirson:= reversearray(unitdirson);
  unitpref:= '-Fu';
  incpref:= '-Fi';
  libpref:= '-Fl';
  objpref:= '-Fo';
  targpref:= '-o';
  makecommand:= '${COMPILER}';
  makedir:= '';
  debugcommand:= '${DEBUGGER}';
  debugoptions:= '';
  debugtarget:= '';
  runcommand:= '';
  remoteconnection:= '';
  uploadcommand:= '';
  gdbprocessor:= 'auto';
  gdbservercommand:= '';
  gdbservercommandattach:= '';
  beforeload:= '';
  afterload:= '';
  beforerun:= '';
  sourcefilemasks:= nil;
  syntaxdeffiles:= nil;
  filemasknames:= nil;
  filemasks:= nil;
  toolsave:= nil;
  toolhide:= nil;
  toolparse:= nil;
  toolmenus:= nil;
  toolfiles:= nil;
  toolparams:= nil;
  fontalias:= nil;
  fontancestors:= nil;
  fontnames:= nil;
  fontheights:= nil;
  fontwidths:= nil;
  fontoptions:= nil;
  fontxscales:= nil;
  additem(sourcefilemasks,'"*.pas" "*.dpr" "*.pp" "*.inc"');
  additem(syntaxdeffiles,'${SYNTAXDEFDIR}pascal.sdef');
  additem(sourcefilemasks,'"*.c" "*.cc" "*.h"');
  additem(syntaxdeffiles,'${SYNTAXDEFDIR}cpp.sdef');
  additem(sourcefilemasks,'"*.mfm"');
  additem(syntaxdeffiles,'${SYNTAXDEFDIR}objecttext.sdef');

  additem(filemasknames,'Source');
  additem(filemasks,'"*.pp" "*.pas" "*.inc" "*.dpr"');
  additem(filemasknames,'Forms');
  additem(filemasks,'*.mfm');
  additem(filemasknames,'All Files');
  additem(filemasks,'*');

  scriptbeforecopy:= '';
  scriptaftercopy:= '';  
  newprojectfiles:= nil;
  newprojectfilesdest:= nil;
  expandprojectfilemacros:= nil;
  loadprojectfile:= nil;
  setlength(newfinames,3);
  setlength(newfifilters,3);
  setlength(newfiexts,3);
  setlength(newfisources,3);
  
  newfinames[0]:= 'Program';
  newfifilters[0]:= '"*.pas" "*.pp"';
  newfiexts[0]:= 'pas';
  newfisources[0]:= '${TEMPLATEDIR}default/program.pas';

  newfinames[1]:= 'Unit';
  newfifilters[1]:= '"*.pas" "*.pp"';
  newfiexts[1]:= 'pas';
  newfisources[1]:= '${TEMPLATEDIR}default/unit.pas';

  newfinames[2]:= 'Textfile';
  newfifilters[2]:= '';
  newfiexts[2]:= '';
  newfisources[2]:= '';
  
  setlength(newfonames,10);
  setlength(newfonamebases,10);
  setlength(newinheritedforms,10);
  setlength(newfosources,10);
  setlength(newfoforms,10);

  newfonames[0]:= 'Mainform';
  newfonamebases[0]:= 'form';
  newinheritedforms[0]:= false;
  newfosources[0]:= '${TEMPLATEDIR}default/mainform.pas';
  newfoforms[0]:= '${TEMPLATEDIR}default/mainform.mfm';
 
  newfonames[1]:= 'Simple Form';
  newfonamebases[1]:= 'form';
  newinheritedforms[1]:= false;
  newfosources[1]:= '${TEMPLATEDIR}default/simpleform.pas';
  newfoforms[1]:= '${TEMPLATEDIR}default/simpleform.mfm';
 
  newfonames[2]:= 'Docking Form';
  newfonamebases[2]:= 'form';
  newinheritedforms[2]:= false;
  newfosources[2]:= '${TEMPLATEDIR}default/dockingform.pas';
  newfoforms[2]:= '${TEMPLATEDIR}default/dockingform.mfm';
 
  newfonames[3]:= 'Datamodule';
  newfonamebases[3]:= 'module';
  newinheritedforms[3]:= false;
  newfosources[3]:= '${TEMPLATEDIR}default/datamodule.pas';
  newfoforms[3]:= '${TEMPLATEDIR}default/datamodule.mfm';
 
  newfonames[4]:= 'Subform';
  newfonamebases[4]:= 'form';
  newinheritedforms[4]:= false;
  newfosources[4]:= '${TEMPLATEDIR}default/subform.pas';
  newfoforms[4]:= '${TEMPLATEDIR}default/subform.mfm';

  newfonames[5]:= 'Scrollboxform';
  newfonamebases[5]:= 'form';
  newinheritedforms[5]:= false;
  newfosources[5]:= '${TEMPLATEDIR}default/scrollboxform.pas';
  newfoforms[5]:= '${TEMPLATEDIR}default/scrollboxform.mfm';

  newfonames[6]:= 'Tabform';
  newfonamebases[6]:= 'form';
  newinheritedforms[6]:= false;
  newfosources[6]:= '${TEMPLATEDIR}default/tabform.pas';
  newfoforms[6]:= '${TEMPLATEDIR}default/tabform.mfm';
 
  newfonames[7]:= 'Report';
  newfonamebases[7]:= 'report';
  newinheritedforms[7]:= false;
  newfosources[7]:= '${TEMPLATEDIR}default/report.pas';
  newfoforms[7]:= '${TEMPLATEDIR}default/report.mfm';
 
  newfonames[8]:= 'Scriptform';
  newfonamebases[8]:= 'script';
  newinheritedforms[8]:= false;
  newfosources[8]:= '${TEMPLATEDIR}default/pascform.pas';
  newfoforms[8]:= '${TEMPLATEDIR}default/pascform.mfm';

  newfonames[9]:= 'Inherited Form';
  newfonamebases[9]:= 'form';
  newinheritedforms[9]:= true;
  newfosources[9]:= '${TEMPLATEDIR}default/inheritedform.pas';
  newfoforms[9]:= '${TEMPLATEDIR}default/inheritedform.mfm';
 
 end;
 
 expandprojectmacros;
end;

procedure projectoptionsmodified;
begin
 projectoptions.modified:= true;
 projectoptions.savechecked:= false;
end;

procedure setsignalinfocount(const count: integer);
begin
 if count = 0 then begin
  projectoptions.sigsettings:= defaultsigsettings;
 end
 else begin
  setlength(projectoptions.sigsettings,count);
 end;
end;

procedure storesignalinforec(const index: integer;
          const avalue: msestring);
var
 stop,handle: boolean;
begin
 with projectoptions.sigsettings[index] do begin
  decoderecord(avalue,[@num,@numto,@stop,@handle],'iibb');
  updatebit({$ifdef FPC}longword{$else}byte{$endif}(flags),ord(sfl_stop),stop);
  updatebit({$ifdef FPC}longword{$else}byte{$endif}(flags),ord(sfl_handle),handle);
 end;
end;

function getsignalinforec(const index: integer): msestring;
var
 stop,handle: boolean;
begin
 with projectoptions.sigsettings[index] do begin
  stop:= sfl_stop in flags;
  handle:= sfl_handle in flags;
  result:= encoderecord([num,numto,stop,handle]);
 end;
end;

procedure updateprojectoptions(const statfiler: tstatfiler;
                  const afilename: filenamety);
var
 int1,int2,int3: integer;
begin
 with statfiler,projectoptions,t do begin
  if iswriter then begin
   projectdir:= msefileutils.getcurrentdir;
   with mainfo,mainmenu1.menu.itembyname('view') do begin
    int3:= formmenuitemstart;
    int2:= count - int3;
    setlength(modulenames,int2);
    setlength(moduletypes,int2);
    setlength(modulefilenames,int2);
    for int1:= 0 to high(modulenames) do begin
     with pmoduleinfoty(submenu[int1+int3].tagpointer)^ do begin
      modulenames[int1]:= struppercase(instance.name);
      moduletypes[int1]:= struppercase(string(moduleclassname));
      modulefilenames[int1]:= filename;
     end;
    end;
   end;
  end;
  registeredcomponents.updatestat(statfiler);
  setsection('projectoptions');
  updatevalue('projectdir',projectdir);
  updatevalue('projectfilename',projectfilename);
  projectfilename:= afilename;
  updatememorystatstream('findinfiledialog',findinfiledialogstatname);
  updatememorystatstream('finddialog',finddialogstatname);
  updatememorystatstream('replacedialog',replacedialogstatname);
  updatememorystatstream('options',optionsstatname);
  updatememorystatstream('settaborder',settaborderstatname);
  updatememorystatstream('setcreateorder',setcreateorderstatname);
  updatememorystatstream('programparameters',programparametersstatname);
  updatememorystatstream('settings',settingsstatname);
  updatememorystatstream('printer',printerstatname);
  updatememorystatstream('imageselector',imageselectorstatname);
  updatememorystatstream('fadeeditor',fadeeditorstatname);
  updatememorystatstream('stringlisteditor',stringlisteditorstatname);
  updatememorystatstream('texteditor',texteditorstatname);
  updatememorystatstream('colordialog',colordialogstatname);
  updatememorystatstream('bmpfiledialog',bmpfiledialogstatname);
{$ifndef mse_no_db}{$ifdef FPC}
  updatememorystatstream('dbfieldeditor',dbfieldeditorstatname);
{$endif}{$endif}
  if iswriter then begin
   mainfo.statoptions.writestat(tstatwriter(statfiler));
   with tstatwriter(statfiler) do begin
    writerecordarray('sigsettings',length(sigsettings),
                     {$ifdef FPC}@{$endif}getsignalinforec);
   end;
  end
  else begin
   mainfo.statoptions.readstat(tstatreader(statfiler));
   with tstatreader(statfiler) do begin
    readrecordarray('sigsettings',{$ifdef FPC}@{$endif}setsignalinfocount,
             {$ifdef FPC}@{$endif}storesignalinforec);
   end;
  end;
  updatevalue('modulenames',modulenames);
  updatevalue('moduletypes',moduletypes);
  updatevalue('modulefiles',modulefilenames);
  updatevalue('mainfile',mainfile);
  updatevalue('targetfile',targetfile);
  updatevalue('messageoutputfile',messageoutputfile);
  updatevalue('makecommand',makecommand);
  updatevalue('makedir',makedir);
  updatevalue('debugcommand',debugcommand);
  updatevalue('debugoptions',debugoptions);
  updatevalue('debugtarget',debugtarget);
  updatevalue('runcommand',runcommand);
  updatevalue('remoteconnection',remoteconnection);
  updatevalue('uploadcommand',uploadcommand);
  updatevalue('gdbprocessor',gdbprocessor);
  updatevalue('gdbservercommand',gdbservercommand);
  updatevalue('gdbservercommandattach',gdbservercommandattach);
  updatevalue('beforeload',beforeload);
  updatevalue('afterload',afterload);
  updatevalue('beforerun',beforerun);
  updatevalue('defaultmake',defaultmake,1,maxdefaultmake+1);
  updatevalue('befcommand',befcommand);
  updatevalue('befcommandon',befcommandon);
  updatevalue('aftcommand',aftcommand);
  updatevalue('aftcommandon',aftcommandon);
  updatevalue('makeoptions',makeoptions);
  updatevalue('makeoptionson',makeoptionson);
  updatevalue('macroon',macroon);
  updatevalue('macronames',macronames);
  updatevalue('macrovalues',macrovalues);
  updatevalue('macrogroup',macrogroup,0,5);
  updatevalue('groupcomments',groupcomments);
  updatevalue('sourcedirs',sourcedirs);
  updatevalue('defines',defines);
  updatevalue('defineson',defineson);
  updatevalue('unitdirs',unitdirs);
  updatevalue('unitdirson',unitdirson);
  updatevalue('unitpref',unitpref);
  updatevalue('incpref',incpref);
  updatevalue('libpref',libpref);
  updatevalue('objpref',objpref);
  updatevalue('targpref',targpref);
  updatevalue('sourcefilemasks',sourcefilemasks);
  updatevalue('syntaxdeffiles',syntaxdeffiles);
  updatevalue('filemasknames',filemasknames);
  updatevalue('filemasks',filemasks);
  updatevalue('toolsave',toolsave);
  updatevalue('toolhide',toolhide);
  updatevalue('toolparse',toolparse);
  updatevalue('toolmenus',toolmenus);
  updatevalue('toolfiles',toolfiles);
  updatevalue('toolparams',toolparams);
  updatevalue('fontalias',fontalias);
  updatevalue('fontancestors',fontancestors);
  updatevalue('fontnames',fontnames);
  updatevalue('fontheights',fontheights);
  updatevalue('fontwidths',fontwidths);
  updatevalue('fontoptions',fontoptions);
  updatevalue('fontxscales',fontxscales);
  
  updatevalue('scriptbeforecopy',scriptbeforecopy);
  updatevalue('scriptaftercopy',scriptaftercopy);
  updatevalue('newprojectfiles',newprojectfiles);
  updatevalue('newprojectfilesdest',newprojectfilesdest);
  updatevalue('expandprojectfilemacros',expandprojectfilemacros);
  updatevalue('loadprojectfile',loadprojectfile);
  
  updatevalue('newfinames',newfinames);
  updatevalue('newfinfilters',newfifilters);
  updatevalue('newfiexts',newfiexts);
  updatevalue('newfisources',newfisources);
  if not iswriter then begin
   int1:= length(newfinames);
   if int1 > length(newfifilters) then begin
    int1:= length(newfifilters);
   end;
   if int1 > length(newfiexts) then begin
    int1:= length(newfiexts);
   end;
   if int1 > length(newfisources) then begin
    int1:= length(newfisources);
   end;
   setlength(newfinames,int1);
   setlength(newfifilters,int1);
   setlength(newfiexts,int1);
   setlength(newfisources,int1);
  end;
    
  updatevalue('newfonames',newfonames);
  updatevalue('newfonamebases',newfonamebases);
  updatevalue('newinheritedforms',newinheritedforms);
  updatevalue('newfosources',newfosources);
  updatevalue('newfoforms',newfoforms);
  if not iswriter then begin
   int1:= length(newfonames);
   if int1 > length(newfonamebases) then begin
    int1:= length(newfonamebases);
   end;
   if int1 > length(newinheritedforms) then begin
    int1:= length(newinheritedforms);
   end;
   if int1 > length(newfosources) then begin
    int1:= length(newfosources);
   end;
   if int1 > length(newfoforms) then begin
    int1:= length(newfoforms);
   end;
   setlength(newfonames,int1);
   setlength(newfonamebases,int1);
   setlength(newinheritedforms,int1);
   setlength(newfosources,int1);
   setlength(newfoforms,int1);
  end;
  if not iswriter then begin
   if guitemplatesmo.sysenv.getintegervalue(int1,ord(env_vargroup),1,6) then begin
    macrogroup:= int1-1;
   end;
   expandprojectmacros;
  end;
  breakpointsfo.updatestat(statfiler);
  panelform.updatestat(statfiler);
  projecttree.updatestat(statfiler);
  componentstorefo.updatestat(statfiler);

  setsection('layout');
  mainfo.projectstatfile.updatestat('windowlayout',statfiler);
  sourcefo.updatestat(statfiler);
  setsection('components');
  selecteditpageform.updatestat(statfiler);
  programparametersform.updatestat(statfiler);
  projectoptionstofont(textpropertyfont);
  modified:= false;
  savechecked:= false;
 end;
end;

procedure projectoptionstoform(fo: tprojectoptionsfo);
var
 int1,int2: integer;
begin
 mainfo.statoptions.objtovalues(fo);
 fo.colgrid.rowcount:= usercolorcount;
 fo.colgrid.fixcols[-1].captions.count:= usercolorcount;
 with fo,projectoptions do begin
  for int1:= 0 to colgrid.rowhigh do begin
   colgrid.fixcols[-1].captions[int1]:= colortostring(cl_user+longword(int1));
  end;
 end;
 with fo.signame do begin
  setlength(enums,siginfocount);
  int2:= 0;
  for int1:= 0 to siginfocount - 1 do begin
   with siginfos[int1] do begin
    if not (sfl_internal in flags) then begin
     enums[int2]:= num;
     dropdownitems.addrow([name,comment]);
     dropdown.cols.addrow([comment+ ' ('+name+')']);
     inc(int2);
    end;
   end;
  end;
  setlength(enums,int2);
 end;
 with projectoptions,t do begin
  fo.signalgrid.rowcount:= length(sigsettings);
  for int1:= 0 to high(sigsettings) do begin
   with sigsettings[int1] do begin
    fo.signum[int1]:= num;
    fo.signumto[int1]:= numto;
    if num = numto then begin
     fo.signame[int1]:= num;
    end
    else begin
     fo.signame[int1]:= -1;
    end;
    fo.sigstop[int1]:= sfl_stop in flags;
    fo.sighandle[int1]:= sfl_handle in flags;
   end;
  end;
  fo.mainfile.value:= mainfile;
  fo.targetfile.value:= targetfile;
  fo.messageoutputfile.value:= messageoutputfile;
  fo.fontalias.gridvalues:= fontalias;
  fo.fontancestors.gridvalues:= fontancestors;
  fo.fontname.gridvalues:= fontnames;
  fo.fontheight.gridvalues:= fontheights;
  fo.fontwidth.gridvalues:= fontwidths;
  fo.fontoptions.gridvalues:= fontoptions;
  fo.fontxscale.gridvalues:= fontxscales;
  fo.fontondataentered(nil);

  fo.scriptbeforecopy.value:= scriptbeforecopy;
  fo.scriptaftercopy.value:= scriptaftercopy;
  fo.newprojectfiles.gridvalues:= newprojectfiles;
  fo.newprojectfilesdest.gridvalues:= newprojectfilesdest;
  fo.expandprojectfilemacros.gridvalues:= expandprojectfilemacros;
  fo.loadprojectfile.gridvalues:= loadprojectfile;
  
  fo.newfiname.gridvalues:= newfinames;
  fo.newfifilter.gridvalues:= newfifilters;
  fo.newfiext.gridvalues:= newfiexts;
  fo.newfisource.gridvalues:= newfisources;
  
  fo.newformname.gridvalues:= newfonames;
  fo.newinheritedform.gridvalues:= newinheritedforms;
  fo.newformnamebase.gridvalues:= newfonamebases;
  fo.newformsourcefile.gridvalues:= newfosources;
  fo.newformformfile.gridvalues:= newfoforms;
  fo.makecommand.value:= makecommand;
  fo.makedir.value:= makedir;
  fo.debugcommand.value:= debugcommand;
  fo.debugoptions.value:= debugoptions;
  fo.debugtarget.value:= debugtarget;
  fo.runcommand.value:= runcommand;
  fo.remoteconnection.value:= remoteconnection;
  fo.uploadcommand.value:= uploadcommand;
  fo.gdbprocessor.value:= gdbprocessor;
  fo.gdbservercommand.value:= gdbservercommand;
  fo.gdbservercommandattach.value:= gdbservercommandattach;
  fo.gdbbeforeload.value:= beforeload;
  fo.gdbafterload.value:= afterload;
  fo.gdbbeforerun.value:= beforerun;
  fo.defaultmake.value:= lowestbit(defaultmake);
  fo.makeoptions.gridvalues:= makeoptions;
  for int1:= 0 to fo.makeoptionsgrid.rowhigh do begin
   if int1 > high(makeoptionson) then begin
    break;
   end;
   fo.makeon.gridupdatetagvalue(int1,makeoptionson[int1]);
   fo.buildon.gridupdatetagvalue(int1,makeoptionson[int1]);
   fo.make1on.gridupdatetagvalue(int1,makeoptionson[int1]);
   fo.make2on.gridupdatetagvalue(int1,makeoptionson[int1]);
   fo.make3on.gridupdatetagvalue(int1,makeoptionson[int1]);
   fo.make4on.gridupdatetagvalue(int1,makeoptionson[int1]);
  end;

  fo.befcommand.gridvalues:= befcommand;
  for int1:= 0 to fo.befcommandgrid.rowhigh do begin
   if int1 > high(befcommandon) then begin
    break;
   end;
   fo.befmakeon.gridupdatetagvalue(int1,befcommandon[int1]);
   fo.befbuildon.gridupdatetagvalue(int1,befcommandon[int1]);
   fo.befmake1on.gridupdatetagvalue(int1,befcommandon[int1]);
   fo.befmake2on.gridupdatetagvalue(int1,befcommandon[int1]);
   fo.befmake3on.gridupdatetagvalue(int1,befcommandon[int1]);
   fo.befmake4on.gridupdatetagvalue(int1,befcommandon[int1]);
  end;

  fo.aftcommand.gridvalues:= aftcommand;
  for int1:= 0 to fo.aftcommandgrid.rowhigh do begin
   if int1 > high(aftcommandon) then begin
    break;
   end;
   fo.aftmakeon.gridupdatetagvalue(int1,aftcommandon[int1]);
   fo.aftbuildon.gridupdatetagvalue(int1,aftcommandon[int1]);
   fo.aftmake1on.gridupdatetagvalue(int1,aftcommandon[int1]);
   fo.aftmake2on.gridupdatetagvalue(int1,aftcommandon[int1]);
   fo.aftmake3on.gridupdatetagvalue(int1,aftcommandon[int1]);
   fo.aftmake4on.gridupdatetagvalue(int1,aftcommandon[int1]);
  end;

  fo.unitdirs.gridvalues:= reversearray(unitdirs);
  int2:= high(unitdirs);
  for int1:= 0 to int2 do begin
   if int1 > high(unitdirson) then begin
    break;
   end;
   fo.dmakeon.gridupdatetagvalue(int2,unitdirson[int1]);
   fo.dbuildon.gridupdatetagvalue(int2,unitdirson[int1]);
   fo.dmake1on.gridupdatetagvalue(int2,unitdirson[int1]);
   fo.dmake2on.gridupdatetagvalue(int2,unitdirson[int1]);
   fo.dmake3on.gridupdatetagvalue(int2,unitdirson[int1]);
   fo.dmake4on.gridupdatetagvalue(int2,unitdirson[int1]);
   fo.duniton.gridupdatetagvalue(int2,unitdirson[int1]);
   fo.dincludeon.gridupdatetagvalue(int2,unitdirson[int1]);
   fo.dlibon.gridupdatetagvalue(int2,unitdirson[int1]);
   fo.dobjon.gridupdatetagvalue(int2,unitdirson[int1]);
   dec(int2);
  end;
  fo.unitpref.value:= unitpref;
  fo.incpref.value:= incpref;
  fo.libpref.value:= libpref;
  fo.objpref.value:= objpref;
  fo.targpref.value:= targpref;
  fo.activemacroselect[macrogroup]:= true;
  fo.activegroupchanged;
  fo.macronames.gridvalues:= macronames;
  fo.macrovalues.gridvalues:= macrovalues;
  setlength(groupcomments,6);
  fo.groupcomment.gridvalues:= groupcomments;

  for int1:= 0 to fo.macrogrid.rowhigh do begin
   if int1 > high(macroon) then begin
    break;
   end;
   fo.e0.gridupdatetagvalue(int1,macroon[int1]);
   fo.e1.gridupdatetagvalue(int1,macroon[int1]);
   fo.e2.gridupdatetagvalue(int1,macroon[int1]);
   fo.e3.gridupdatetagvalue(int1,macroon[int1]);
   fo.e4.gridupdatetagvalue(int1,macroon[int1]);
   fo.e5.gridupdatetagvalue(int1,macroon[int1]);
  end;

  fo.sourcedirs.gridvalues:= reversearray(sourcedirs);
  fo.grid[0].datalist.asarray:= syntaxdeffiles;
  fo.grid[1].datalist.asarray:= sourcefilemasks;
  fo.filefiltergrid[0].datalist.asarray:= filemasknames;
  fo.filefiltergrid[1].datalist.asarray:= filemasks;
  fo.toolsave.gridvalues:= toolsave;
  fo.toolhide.gridvalues:= toolhide;
  fo.toolparse.gridvalues:= toolparse;
  fo.toolmenu.gridvalues:= toolmenus;
  fo.toolfile.gridvalues:= toolfiles;
  fo.toolparam.gridvalues:= toolparams;
  fo.def.gridvalues:= defines;
  fo.defon.gridvalues:= defineson;
 end;
end;

procedure storemacros(fo: tprojectoptionsfo);
var
 int1: integer;
begin
 with projectoptions,t do begin
  macronames:= fo.macronames.gridvalues;
  macrovalues:= fo.macrovalues.gridvalues;
  setlength(macroon,fo.macrogrid.rowcount);
  for int1:= 0 to high(macroon) do begin
   macroon[int1]:= fo.e0.gridvaluetag(int1,0) or fo.e1.gridvaluetag(int1,0) or
                    fo.e2.gridvaluetag(int1,0) or fo.e3.gridvaluetag(int1,0) or
                    fo.e4.gridvaluetag(int1,0) or fo.e5.gridvaluetag(int1,0);
  end;
  groupcomments:= fo.groupcomment.gridvalues;
 end;
end;

procedure formtoprojectoptions(fo: tprojectoptionsfo);
var
 int1: integer;
begin
 mainfo.statoptions.valuestoobj(fo);
 with projectoptions,t do begin
  setlength(sigsettings,fo.signalgrid.rowcount);
  for int1:= 0 to high(sigsettings) do begin
   with sigsettings[int1] do begin
    num:= fo.signum[int1];
    numto:= fo.signumto[int1];
    updatebit({$ifdef FPC}longword{$else}byte{$endif}(flags),ord(sfl_stop),
                                fo.sigstop[int1]);
    updatebit({$ifdef FPC}longword{$else}byte{$endif}(flags),ord(sfl_handle),
                                fo.sighandle[int1]);
   end;
  end;
  
  mainfile:= fo.mainfile.value;
  targetfile:= fo.targetfile.value;
  messageoutputfile:= fo.messageoutputfile.value;

  fontalias:= fo.fontalias.gridvalues;
  fontancestors:= fo.fontancestors.gridvalues;
  fontnames:= fo.fontname.gridvalues;
  fontheights:= fo.fontheight.gridvalues;
  fontwidths:= fo.fontwidth.gridvalues;
  fontoptions:= fo.fontoptions.gridvalues;
  fontxscales:= fo.fontxscale.gridvalues;
  for int1:= high(fontxscales) downto 0 do begin
   if isemptyreal(fontxscales[int1]) then begin
    fontxscales[int1]:= 1.0;
   end;   
  end;

  scriptbeforecopy:= fo.scriptbeforecopy.value;
  scriptaftercopy:= fo.scriptaftercopy.value;
  newprojectfiles:= fo.newprojectfiles.gridvalues;
  newprojectfilesdest:= fo.newprojectfilesdest.gridvalues;
  expandprojectfilemacros:= fo.expandprojectfilemacros.gridvalues;
  loadprojectfile:= fo.loadprojectfile.gridvalues;
  newfinames:= fo.newfiname.gridvalues;
  newfifilters:= fo.newfifilter.gridvalues;
  newfiexts:= fo.newfiext.gridvalues;
  newfisources:= fo.newfisource.gridvalues;

  newfonames:= fo.newformname.gridvalues;
  newinheritedforms:= fo.newinheritedform.gridvalues;
  newfonamebases:= fo.newformnamebase.gridvalues;
  newfosources:= fo.newformsourcefile.gridvalues;
  newfoforms:= fo.newformformfile.gridvalues;
  makecommand:= fo.makecommand.value;
  makedir:= fo.makedir.value;
  debugcommand:= fo.debugcommand.value;
  debugoptions:= fo.debugoptions.value;
  debugtarget:= fo.debugtarget.value;
  runcommand:= fo.runcommand.value;
  remoteconnection:= fo.remoteconnection.value;
  uploadcommand:= fo.uploadcommand.value;
  gdbprocessor:= fo.gdbprocessor.value;
  gdbservercommand:= fo.gdbservercommand.value;
  gdbservercommandattach:= fo.gdbservercommandattach.value;
  beforeload:= fo.gdbbeforeload.value;
  afterload:= fo.gdbafterload.value;
  beforerun:= fo.gdbbeforerun.value;
  defaultmake:= 1 shl fo.defaultmake.value;
  makeoptions:= fo.makeoptions.gridvalues;
  setlength(makeoptionson,fo.makeoptionsgrid.rowcount);
  for int1:= 0 to high(makeoptionson) do begin
   makeoptionson[int1]:=
      fo.makeon.gridvaluetag(int1,0) or fo.buildon.gridvaluetag(int1,0) or
      fo.make1on.gridvaluetag(int1,0) or fo.make2on.gridvaluetag(int1,0) or
      fo.make3on.gridvaluetag(int1,0) or fo.make4on.gridvaluetag(int1,0);
  end;

  befcommand:= fo.befcommand.gridvalues;
  setlength(befcommandon,fo.befcommandgrid.rowcount);
  for int1:= 0 to high(befcommandon) do begin
   befcommandon[int1]:=
      fo.befmakeon.gridvaluetag(int1,0) or fo.befbuildon.gridvaluetag(int1,0) or
      fo.befmake1on.gridvaluetag(int1,0) or fo.befmake2on.gridvaluetag(int1,0) or
      fo.befmake3on.gridvaluetag(int1,0) or fo.befmake4on.gridvaluetag(int1,0);
  end;
  aftcommand:= fo.aftcommand.gridvalues;
  setlength(aftcommandon,fo.aftcommandgrid.rowcount);
  for int1:= 0 to high(aftcommandon) do begin
   aftcommandon[int1]:=
      fo.aftmakeon.gridvaluetag(int1,0) or fo.aftbuildon.gridvaluetag(int1,0) or
      fo.aftmake1on.gridvaluetag(int1,0) or fo.aftmake2on.gridvaluetag(int1,0) or
      fo.aftmake3on.gridvaluetag(int1,0) or fo.aftmake4on.gridvaluetag(int1,0);
  end;

  unitdirs:= reversearray(fo.unitdirs.gridvalues);
  setlength(unitdirson,length(unitdirs));
  for int1:= 0 to high(unitdirson) do begin
   unitdirson[high(unitdirson)-int1]:=
      fo.dmakeon.gridvaluetag(int1,0) or fo.dbuildon.gridvaluetag(int1,0) or
      fo.dmake1on.gridvaluetag(int1,0) or fo.dmake2on.gridvaluetag(int1,0) or
      fo.dmake3on.gridvaluetag(int1,0) or fo.dmake4on.gridvaluetag(int1,0) or
      fo.duniton.gridvaluetag(int1,0) or fo.dincludeon.gridvaluetag(int1,0) or
      fo.dlibon.gridvaluetag(int1,0) or fo.dobjon.gridvaluetag(int1,0);
  end;
  unitpref:= fo.unitpref.value;
  incpref:= fo.incpref.value;
  libpref:= fo.libpref.value;
  objpref:= fo.objpref.value;
  targpref:= fo.targpref.value;
  storemacros(fo);
  sourcedirs:= reversearray(fo.sourcedirs.gridvalues);
  defines:= fo.def.gridvalues;
  defineson:= fo.defon.gridvalues;
  syntaxdeffiles:= fo.grid[0].datalist.asarray;
  sourcefilemasks:= fo.grid[1].datalist.asarray;
  filemasknames:= fo.filefiltergrid[0].datalist.asarray;
  filemasks:= fo.filefiltergrid[1].datalist.asarray;
  toolsave:= fo.toolsave.gridvalues;
  toolhide:= fo.toolhide.gridvalues;
  toolparse:= fo.toolparse.gridvalues;
  toolmenus:= fo.toolmenu.gridvalues;
  toolfiles:= fo.toolfile.gridvalues;
  toolparams:= fo.toolparam.gridvalues;  
 end;
 expandprojectmacros;
end;

procedure projectoptionschanged;
var
 int1: integer;
begin
 sourceupdater.unitchanged;
 for int1:= 0 to designer.modules.count - 1 do begin
  tdesignwindow(designer.modules[int1]^.designform.window).updateprojectoptions;
 end;
 createcpufo;
end;

function readprojectoptions(const filename: filenamety): boolean;
var
 statreader: tstatreader;
begin
 result:= false;
 try
  statreader:= tstatreader.create(filename,ce_utf8n);
  try
   application.beginwait;
   updateprojectoptions(statreader,filename);
  finally
   statreader.free;
   application.endwait;
   projectoptionschanged;
  end;
  result:= true;
 except
  on e: exception do begin
   showerror('Can not read project "'+filename+'".'+lineend+e.message,'ERROR');
  end;
 end;
end;

procedure saveprojectoptions(filename: filenamety = '');
var
 statwriter: tstatwriter;
begin
 if filename = '' then begin
  filename:= projectoptions.projectfilename;
 end;
 statwriter:= tstatwriter.create(filename,ce_utf8n);
 try
  updateprojectoptions(statwriter,filename);
 finally
  statwriter.free;
 end;
end;

function editprojectoptions: boolean;
var
 fo: tprojectoptionsfo;
begin
 fo:= tprojectoptionsfo.create(nil);
 projectoptionstoform(fo);
 try
  projectoptionsfo:= fo;
  result:= fo.show(true,nil) = mr_ok;
  projectoptionsfo:= nil;
  if result then begin
   with mainfo.gdb do begin
    if not started then begin
     closegdb;
    end;
   end;
   fo.window.nofocus; //remove empty grid lines
   formtoprojectoptions(fo);
   projectoptionsmodified;
   projectoptionschanged;
  end;
 finally
  projectoptionsfo:= nil;
  fo.Free;
 end;
end;

procedure tprojectoptionsfo.activegroupchanged;
var
 int1,int2: integer;
begin
 int2:= 0;
 for int1:= 0 to selectactivegroupgrid.rowcount-1 do begin
  if activemacroselect[int1] then begin
   int2:= int1;
   break;
  end;
 end;
 for int1:= 0 to 5 do begin
  if int1 = int2 then begin
   macrogrid.datacols[int1].color:= cl_infobackground;
  end
  else begin
   macrogrid.datacols[int1].color:= cl_default;
  end;
 end;
 projectoptions.macrogroup:= int2;
end;

procedure tprojectoptionsfo.acttiveselectondataentered(const sender: TObject);
var
 int1: integer;
begin
 for int1:= 0 to selectactivegroupgrid.rowcount-1 do begin
  activemacroselect[int1]:= false;
 end;
 tbooleaneditradio(sender).value:= true;
 activegroupchanged;
 projectoptions.macrogroup:= selectactivegroupgrid.row;
end;

procedure tprojectoptionsfo.colonshowhint(const sender: tdatacol; 
                const arow: Integer; var info: hintinfoty);
begin
 storemacros(self);
 if sender is twidgetcol then begin
  info.caption:= tcustomstringedit(twidgetcol(sender).editwidget).gridvalue[arow];
 end
 else begin
  info.caption:= tstringcol(sender)[arow];
 end;
 expandprmacros1(info.caption);
 include(info.flags,hfl_show); //show empty caption
end;

procedure tprojectoptionsfo.hintexpandedmacros(const sender: TObject;
                           var info: hintinfoty);
begin
 storemacros(self);
 info.caption:= tcustomedit(sender).text;
 expandprmacros1(info.caption);
 include(info.flags,hfl_show); //show empty caption
end;

procedure tprojectoptionsfo.selectactiveonrowsmoved(const sender: tcustomgrid;
       const fromindex: Integer; const toindex: Integer; const acount: Integer);
begin
 activegroupchanged;
end;

procedure tprojectoptionsfo.expandfilename(const sender: TObject;
                     var avalue: mseString; var accept: Boolean);
begin
 expandprmacros1(avalue);
end;

procedure tprojectoptionsfo.showcommandlineonexecute(const sender: TObject);
var
 info1: projectoptionsty;
begin
 info1:= projectoptions;
 formtoprojectoptions(self);
 commandlineform.showcommandline;
 projectoptions:= info1;
end;

procedure tprojectoptionsfo.signameonsetvalue(const sender: TObject; var avalue: LongInt; var accept: Boolean);
begin
 signum.value:= avalue;
 signumto.value:= avalue;
end;

procedure tprojectoptionsfo.signumonsetvalue(const sender: TObject; var avalue: LongInt; var accept: Boolean);
begin
 signame.value:= avalue;
 signumto.value:= avalue;
end;

procedure tprojectoptionsfo.signumtoonsetvalue(const sender: TObject; var avalue: Integer; var accept: Boolean);
begin
 if avalue <= signum.value then begin
  signum.value:= avalue;
  signame.value:= avalue;
 end
 else begin
  signame.value:= -1;
 end;
end;

procedure tprojectoptionsfo.fontondataentered(const sender: TObject);
const
 teststring = 'ABCDEFGabcdefgy0123WWWiii ';
var
 format1: formatinfoarty;
begin
 with fontdisp.font do begin
  name:= editfontname.value;
  height:= editfontheight.value;
  width:= editfontwidth.value;
  extraspace:= editfontextraspace.value;
  color:= editfontcolor.value;
  dispgrid.frame.colorclient:= editbkcolor.value;
  if editfontantialiased.value then begin
   options:= options + [foo_antialiased];
  end
  else begin
   options:= options + [foo_nonantialiased];
  end;
  dispgrid.datarowheight:= lineheight;
  fontdisp[0]:= teststring+teststring+teststring+teststring;
  format1:= nil;
  updatefontstyle(format1,length(teststring),length(teststring),fs_bold,true);
  updatefontstyle(format1,2*length(teststring),2*length(teststring),fs_italic,true);
  updatefontstyle(format1,3*length(teststring),length(teststring),fs_bold,true);
  fontdisp.richformats[0]:= format1;
  fontdisp[1]:= 
    'Ascent: '+inttostr(ascent)+' Descent: '+inttostr(descent)+
    ' Linespacing: '+inttostr(lineheight);
 end;
 dispgrid.rowcolorstate[1]:= 0;
 dispgrid.rowcolors[0]:= statementcolor.value;
end;

procedure tprojectoptionsfo.makepageonchildscaled(const sender: TObject);
var
 int1: integer;
begin
 placeyorder(0,[0,0,0,15],[mainfile,makecommand,messageoutputfile,
                    defaultmake,makegroupbox],0);
 aligny(wam_center,[mainfile,targetfile,targpref]);
 aligny(wam_center,[makecommand,makedir]);
 aligny(wam_center,[messageoutputfile,copymessages]);
 placexorder(defaultmake.bounds_x,[10-defaultmake.frame.outerframe.right,10],
             [defaultmake,showcommandline,checkmethods]);
 int1:= aligny(wam_center,[defaultmake,showcommandline]);
 with checkmethods do begin
  bounds_y:= int1 - bounds_cy - 2;
 end;
 with closemessages do begin
  pos:= makepoint(checkmethods.bounds_x,int1);
 end;
end;

procedure tprojectoptionsfo.debuggeronchildscaled(const sender: TObject);
begin
 placeyorder(0,[0,0,10],[debugcommand,debugoptions,debugtarget,tlayouter1]);
 aligny(wam_center,[debugtarget,runcommand]);
end;

procedure tprojectoptionsfo.macronchildscaled(const sender: TObject);
var
 int1: integer;
begin
 int1:= macrosplitter.bounds_y;
 placeyorder(0,[0],[selectactivegroupgrid,macrosplitter,macrogrid],0);
 macrosplitter.move(makepoint(0,int1-macrosplitter.bounds_y));
end;


procedure tprojectoptionsfo.formtemplateonchildscaled(const sender: TObject);
begin
{
 placeyorder(0,[0],[mainfosource,mainfoform,simplefosource,simplefoform,
       dockingfosource,dockingfoform,datamodsource,datamodform,
       subfosource,subfoform,reportsource,reportform,
       inheritedsource,inheritedform]);
}
end;

procedure tprojectoptionsfo.encodingsetvalue(const sender: TObject;
               var avalue: LongInt; var accept: Boolean);
var
 mstr1: msestring;
begin
 mstr1:= encoding.dropdown.valuelist[avalue];
 accept:= askyesno('Wrong encoding can damage your source files.'+lineend+
             'Do you wish to set encoding to '+mstr1+'?','*** WARNING ***');
end;

procedure tprojectoptionsfo.createexe(const sender: TObject);
begin
 {$ifdef mswindows}
 externalconsole.visible:= true;
 {$endif}
end;

procedure tprojectoptionsfo.drawcol(const sender: tpointeredit;
               const acanvas: tcanvas; const avalue: Pointer;
               const arow: Integer);
begin
 with pcellinfoty(acanvas.drawinfopo)^ do begin
  acanvas.fillrect(innerrect,usercolors[arow]);
 end;
end;

procedure tprojectoptionsfo.colsetvalue(const sender: TObject;
               var avalue: colorty; var accept: Boolean);
begin
 colgrid.invalidaterow(colgrid.row);
end;

procedure tprojectoptionsfo.copycolorcode(const sender: TObject);
var
 str1: msestring;
 int1: integer;
begin
 str1:= '';
 for int1:= 0 to colgrid.rowhigh do begin
  if usercolors[int1] <> 0 then begin
   str1:= str1 + ' setcolormapvalue('+colortostring(cl_user+longword(int1))+','+
               colortostring(usercolors[int1])+');';
   if usercolorcomment[int1] <> '' then begin
    str1:= str1 + ' //'+usercolorcomment[int1];
   end;
   str1:= str1+lineend;
  end;
 end;
 copytoclipboard(str1);
end;

procedure tprojectoptionsfo.downloadchange(const sender: TObject);
begin
 uploadcommand.enabled:= not gdbdownload.value and not gdbsimulator.value;
 gdbbeforeload.enabled:= gdbdownload.value and not gdbsimulator.value;
 gdbafterload.enabled:= gdbdownload.value and not gdbsimulator.value;
 gdbservercommand.enabled:= not gdbsimulator.value;
 gdbservercommandattach.enabled:= not gdbsimulator.value;
 gdbserverwait.enabled:= not gdbsimulator.value;
 remoteconnection.enabled:= not gdbsimulator.value;
 gdbdownload.enabled:= not gdbsimulator.value;
 downloadalways.enabled:= not gdbsimulator.value;
 startupbkpt.enabled:= startupbkpton.value;
end;

procedure tprojectoptionsfo.processorchange(const sender: TObject);
begin
 mainfo.gdb.processorname:= gdbprocessor.value;
 if not (mainfo.gdb.processor in simulatorprocessors) then begin
  gdbsimulator.value:= false;
  gdbsimulator.enabled:= false;
 end
 else begin
  gdbsimulator.enabled:= true;
 end;
end;

procedure tprojectoptionsfo.copymessagechanged(const sender: TObject);
begin
 messageoutputfile.enabled:= copymessages.value;
end;

procedure tprojectoptionsfo.runcommandchange(const sender: TObject);
begin
 debugtarget.enabled:= runcommand.value = '';
end;

procedure tprojectoptionsfo.newprojectchildscaled(const sender: TObject);
begin
 placeyorder(4,[4,4],[scriptbeforecopy,scriptaftercopy,copygrid],0);
end;

{ tprojectoptions }

constructor tprojectoptions.create;
begin
 closemessages:= true;
 checkmethods:= true;
 showgrid:= true;
 snaptogrid:= true;
 moveonfirstclick:= true;
 gridsizex:= defaultgridsizex;
 gridsizey:= defaultgridsizey;
 autoindent:= true;
 blockindent:= 1;
 rightmarginon:= true;
 rightmarginchars:= 80;
 tabstops:= 4;
 editfontname:= 'mseide_source';
 editfontcolor:= integer(cl_text);
 editbkcolor:= integer(cl_foreground);
 statementcolor:= $E0FFFF;
 editfontantialiased:= true;
 editmarkbrackets:= true;
 backupfilecount:= 2;
 valuehints:= true;
 activateonbreak:= true;
 additem(fexceptclassnames,'EconvertError');
 additem(fexceptignore,false);
end;

function tprojectoptions.limitgridsize(const avalue: integer): integer;
begin
 result:= avalue;
 if result < 1 then begin
  result:= 1;
 end;
 if result > 1000 then begin
  result:= 1000;
 end;
end;

procedure tprojectoptions.setgridsizex(const avalue: integer);
begin
 fgridsizex:= limitgridsize(avalue);
end;

procedure tprojectoptions.setgridsizey(const avalue: integer);
begin
 fgridsizey:= limitgridsize(avalue);
end;

initialization
finalization
 projectoptions.o.free;
end.

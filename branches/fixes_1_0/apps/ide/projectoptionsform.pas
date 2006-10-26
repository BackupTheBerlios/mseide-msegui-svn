{ MSEide Copyright (c) 1999-2006 by Martin Schreiber
   
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

{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface
uses
 mseforms,msefiledialog,msegui,msestat,msestatfile,msetabs,msesimplewidgets,
 msetypes,
 msestrings,msedataedits,msetextedit,msegraphedits,msewidgetgrid,msegrids,
 msesplitter,msesysenv,msegdbutils,msedispwidgets,msesys,mseclasses,
 msegraphutils;

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
  debugcommand: filenamety;
  debugoptions: filenamety;
  debugtarget: filenamety;
  sourcedirs: msestringarty;
  defines: msestringarty;
  unitdirs: msestringarty;
  makeoptions: msestringarty;
  syntaxdeffiles: msestringarty;
  fontnames: msestringarty;
  newprojectfiles: filenamearty;
  newprojectfilesdest: filenamearty;
  newprogramfile: filenamety;
  newunitfile: filenamety;
//  newtextfile: filenamety;
  newmainfosource: filenamety;
  newmainfoform: filenamety;
  newsimplefosource: filenamety;
  newsimplefoform: filenamety;
  newdockingfosource: filenamety;
  newdockingfoform: filenamety;
  newdatamodsource: filenamety;
  newdatamodform: filenamety;
  newsubfosource: filenamety;
  newsubfoform: filenamety;
 end;

 projectoptionsty = record
  modified: boolean;
  ignoreexceptionclasses: stringarty;
  t: projecttextty;
  texp: projecttextty;
  projectfilename: filenamety;
  projectdir: filenamety;
  fontalias: msestringarty;
  fontheights: integerarty;
  
  copymessages: boolean;
  closemessages: boolean;
  checkmethods: boolean;

  showgrid: boolean;
  snaptogrid: boolean;
  gridsizex: integer;
  gridsizey: integer;
  
  autoindent: boolean;
  blockindent: integer;
  rightmarginon: boolean;
  rightmarginchars: integer;
  tabstops: integer;
  editfontname: string;
  editfontheight: integer;
  editfontwidth: integer;
  editfontextraspace: integer;
  editfontantialiased: boolean;
  backupfilecount: integer;
  encoding: integer;

  defineson: longboolarty;
  exceptclassnames: msestringarty;
  exceptignore: longboolarty;
  
  modulenames: msestringarty;
  moduletypes: msestringarty;
  modulefilenames: filenamearty;

  defaultmake: integer;
  makeoptionson: integerarty;
  unitdirson: integerarty;

  macroon: integerarty;
  macronames,macrovalues: msestringarty;
  macrogroup: integer;
  groupcomments: msestringarty;

  breakpointons: longboolarty;
  breakpointlines: integerarty;
  breakpointignore: integerarty;
  breakpointpaths: msestringarty;
  breakpointconditions: msestringarty;

  sourcefilemasks: msestringarty;

  stoponexception: boolean;
  activateonbreak: boolean;
  showconsole: boolean;
  externalconsole: boolean;
  sigsettings: sigsetinfoarty;

  //programparameters
  progparameters: string;
  progworkingdirectory: filenamety;
  envvarons: longboolarty;
  envvarnames: msestringarty;
  envvarvalues: msestringarty;
  
  //editor
  findreplaceinfo: replaceinfoty;
  
  //templates
  expandprojectfilemacros: longboolarty;
  loadprojectfile: longboolarty;
 end;

 tprojectoptionsfo = class(tmseform)
   buildon: tbooleanedit;
   closemessages: tbooleanedit;
   dbuildon: tbooleanedit;
   dincludeon: tbooleanedit;
   dlibon: tbooleanedit;
   dmake1on: tbooleanedit;
   dmake2on: tbooleanedit;
   dmake3on: tbooleanedit;
   dmake4on: tbooleanedit;
   dmakeon: tbooleanedit;
   duniton: tbooleanedit;
   gridsizex: tintegeredit;
   gridsizey: tintegeredit;
   make1on: tbooleanedit;
   make2on: tbooleanedit;
   make3on: tbooleanedit;
   make4on: tbooleanedit;
   makeon: tbooleanedit;
   makeoptions: tstringedit;
   makeoptionsgrid: twidgetgrid;
   makesplitter: tsplitter;
   showgrid: tbooleanedit;
   sighandle: tbooleanedit;
   signalgrid: twidgetgrid;
   signame: tselector;
   signum: tintegeredit;
   signumto: tintegeredit;
   sigstop: tbooleanedit;
   snaptogrid: tbooleanedit;
   sourcedirgrid: twidgetgrid;
   sourcedirs: tfilenameedit;
   statfile1: tstatfile;
   tabwidget: ttabwidget;
   debugcommand: tfilenameedit;
   defaultmake: tenumedit;
   editorpage: ttabpage;
   grid: tstringgrid;
   mainfile: tfilenameedit;
   makecommand: tfilenameedit;
   debuggerpage: ttabpage;
   stoponexception: tbooleanedit;
   targetfile: tfilenameedit;
   autoindent: tbooleanedit;
   blockindent: tintegeredit;
   e0: tbooleanedit;
   e1: tbooleanedit;
   e2: tbooleanedit;
   e3: tbooleanedit;
   e4: tbooleanedit;
   e5: tbooleanedit;
   activemacroselect: tbooleaneditradio;
   showcommandline: tbutton;
   fontheight: tintegeredit;
   copymessages: tbooleanedit;
   messageoutputfile: tfilenameedit;
   rightmarginon: tbooleanedit;
   rightmarginchars: tintegeredit;
   editfontantialiased: tbooleanedit;
   tabstops: tintegeredit;
   editfontheight: tintegeredit;
   editfontwidth: tintegeredit;
   activateonbreak: tbooleanedit;
   editfontextraspace: tintegeredit;
   macronames: tstringedit;
   macrovalues: tstringedit;
   groupcomment: tstringedit;
   macrosplitter: tsplitter;
   fontalias: tstringedit;
   fontname: tstringedit;
   editfontname: tstringedit;
   makegroupbox: tgroupbox;
   expandprojectfilemacros: tbooleanedit;
   newprojectfiles: tfilenameedit;
   newprogf: tfilenameedit;
   newunitf: tfilenameedit;
   mainfosource: tfilenameedit;
   mainfoform: tfilenameedit;
   simplefosource: tfilenameedit;
   simplefoform: tfilenameedit;
   dockingfosource: tfilenameedit;
   dockingfoform: tfilenameedit;
   datamodsource: tfilenameedit;
   datamodform: tfilenameedit;
   subfosource: tfilenameedit;
   subfoform: tfilenameedit;
   newprojectfilesdest: tstringedit;
   loadprojectfile: tbooleanedit;
   dobjon: tbooleanedit;
   showconsole: tbooleanedit;
   exceptignore: tbooleanedit;
   debugtarget: tfilenameedit;
   encoding: tenumedit;
   checkmethods: tbooleanedit;
   externalconsole: tbooleanedit;
   defon: tbooleanedit;
   tgroupbox1: tgroupbox;
   backupfilecount: tintegeredit;
   debugoptions: tstringedit;
   exceptclassnames: tstringedit;
   tintegeredit2: tintegeredit;
   def: tstringedit;
   ttabpage1: ttabpage;
   macrogrid: twidgetgrid;
   selectactivegroupgrid: twidgetgrid;
   fontaliaspage: ttabpage;
   fontaliasgrid: twidgetgrid;
   fontdisp: ttextedit;
   dispgrid: twidgetgrid;
   ttabpage2: ttabpage;
   ttabpage3: ttabpage;
   ttabpage4: ttabpage;
   newfile: ttabwidget;
   ttabpage5: ttabpage;
   ttabpage6: ttabpage;
   ttabpage7: ttabpage;
   ttabpage8: ttabpage;
   ttabpage9: ttabpage;
   ttabwidget1: ttabwidget;
   twidgetgrid1: twidgetgrid;
   exceptionsgrid: twidgetgrid;
   twidgetgrid2: twidgetgrid;
   unitdirgrid: twidgetgrid;
   unitdirs: tfilenameedit;
   makepage: ttabpage;
   ok: tbutton;
   cancel: tbutton;
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
  private
   procedure activegroupchanged;
 end;

function readprojectoptions(const filename: filenamety): boolean;
         //true if ok
procedure saveprojectoptions(filename: filenamety = '');
procedure initprojectoptions;
function editprojectoptions: boolean;
    //true if not aborted
procedure expandprojectmacros;
function projectfiledialog(var aname: filenamety; save: boolean): modalresultty;
procedure projectoptionsmodified;
function checkprojectloadabort: boolean; //true on load abort

function getsigname(const anum: integer): string;

var
 projectoptions: projectoptionsty;
 projecthistory: filenamearty;

implementation
uses
 projectoptionsform_mfm,msedatalist,msewidgets,breakpointsform,sourceform,
 objectinspector,msebits,msefileutils,msedesignintf,
 watchform,stackform,main,projecttreeform,findinfileform,sysutils,
 selecteditpageform,programparametersform,sourceupdate,mseedit,msegraphics,
 msedesigner,panelform,watchpointsform,commandlineform,msestream,
 componentpaletteform,mserichstring,msesettings,formdesigner,
 msestringlisteditor,msetexteditor,msecolordialog,msepropertyeditors
 {$ifdef FPC}{$ifndef mse_withoutdb},msedbfieldeditor{$endif}{$endif};

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
 programparametersstatname = 'programparametersfo.sta';
 settingsstatname =          'settingsfo.sta';
 printerstatname =           'printer.sta';
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

function checkprojectloadabort: boolean;
begin
 result:= false;
 if exceptobject is exception then begin
  if showmessage(exception(exceptobject).Message,'ERROR',[mr_ok,mr_cancel]) <> 
                               mr_ok then begin
   result:= true;
//   raise exception.Create(exception(exceptobject).Message);
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

procedure expandmacros1(var atext: msestring); overload;
var
 li: tmacrolist;
begin
 li:= getmacros;
 li.expandmacros(atext);
 li.Free;
end;

function expandmacros(const atext: msestring): msestring;
begin
 result:= atext;
 expandmacros1(result);
end;

procedure expandprojectmacros;
var
 li: tmacrolist;
 int1: integer;
 bo1: boolean;
begin
 li:= getmacros;
 with projectoptions do begin
  texp:= t;
  with texp do begin
   li.expandmacros(mainfile);
   li.expandmacros(targetfile);
   li.expandmacros(messageoutputfile);
   li.expandmacros(makecommand);
   li.expandmacros(debugcommand);
   li.expandmacros(debugoptions);
   li.expandmacros(debugtarget);
   li.expandmacros(sourcedirs);
   li.expandmacros(defines);
   li.expandmacros(unitdirs);
   li.expandmacros(makeoptions);
   li.expandmacros(syntaxdeffiles);
   li.expandmacros(fontnames);
   li.expandmacros(newprojectfiles);
   li.expandmacros(newprojectfilesdest);
   li.expandmacros(newprogramfile);
   li.expandmacros(newunitfile);
//   li.expandmacros(newtextfile);
   li.expandmacros(newmainfosource);
   li.expandmacros(newmainfoform);
   li.expandmacros(newsimplefosource);
   li.expandmacros(newsimplefoform);
   li.expandmacros(newdockingfosource);
   li.expandmacros(newdockingfoform);
   li.expandmacros(newdatamodsource);
   li.expandmacros(newdatamodform);
   li.expandmacros(newsubfosource);
   li.expandmacros(newsubfoform);
   clearfontalias;
   for int1:= 0 to high(fontalias) do begin
    registerfontalias(fontalias[int1],fontnames[int1],fam_overwrite,fontheights[int1]);
   end;
   if sourceupdater <> nil then begin
    sourceupdater.maxlinelength:= rightmarginchars;
   end;
   for int1:= 0 to sourcefo.count - 1 do begin
    sourcefo.items[int1].updatestatvalues;
   end;
   fontaliasnames:= fontalias;
   with sourcefo.syntaxpainter do begin
    bo1:= not cmparray(defdefs.asarraya,sourcefilemasks) or
       not cmparray(defdefs.asarrayb,texp.syntaxdeffiles);
    defdefs.asarraya:= sourcefilemasks;
    defdefs.asarrayb:= texp.syntaxdeffiles;
    if bo1 then begin
     for int1:= 0 to sourcefo.count - 1 do begin
      sourcefo.items[int1].edit.setsyntaxdef(sourcefo.items[int1].edit.filename);
     end;
    end;
   end;
  end;
  ignoreexceptionclasses:= nil;
  for int1:= 0 to high(exceptignore) do begin
   if int1 > high(exceptclassnames) then begin
    break;
   end;
   if exceptignore[int1] then begin
    additem(ignoreexceptionclasses,exceptclassnames[int1]);
   end;
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
 finalize(projectoptions);
 fillchar(projectoptions,sizeof(projectoptions),0);
 with projectoptions,t do begin
  deletememorystatstream(findinfiledialogstatname);
  deletememorystatstream(finddialogstatname);
  deletememorystatstream(replacedialogstatname);
  deletememorystatstream(optionsstatname);
  deletememorystatstream(settaborderstatname);
  deletememorystatstream(programparametersstatname);
  deletememorystatstream(printerstatname);
  deletememorystatstream(stringlisteditorstatname);
  deletememorystatstream(texteditorstatname);
  deletememorystatstream(colordialogstatname);
  deletememorystatstream(bmpfiledialogstatname);
  {$ifdef FPC}{$ifndef mse_withoutdb}
  deletememorystatstream(dbfieldeditorstatname);
  {$endif}{$endif}
  modified:= false;
  sigsettings:= defaultsigsettings;
  exceptclassnames:= nil;
  exceptignore:= nil;
  additem(exceptclassnames,'EconvertError');
  additem(exceptignore,false);
  ignoreexceptionclasses:= nil;

  makeoptions:= nil;
  additem(makeoptions,'-l -Mobjfpc -Sh');
  additem(makeoptions,'-gl');
  additem(makeoptions,'-B');
  additem(makeoptions,'-OG2p3 -XX -Xs');
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
  copymessages:= false;
  closemessages:= true;
  checkmethods:= true;
  showgrid:= true;
  snaptogrid:= true;
  gridsizex:= defaultgridsizex;
  gridsizey:= defaultgridsizey;
  findreplaceinfo.find.options:= [so_caseinsensitive];
  autoindent:= true;
  blockindent:= 1;
  rightmarginon:= true;
  rightmarginchars:= 80;
  tabstops:= 4;
  editfontname:= 'mseide_source';
  editfontheight:= 0;
  editfontwidth:= 0;
  editfontextraspace:= 0;
  editfontantialiased:= true;
  backupfilecount:= 2;
  encoding:= 0;
  activateonbreak:= true;
  showconsole:= false;
  externalconsole:= false;
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
  makecommand:= '${COMPILER}';
  debugcommand:= '${DEBUGGER}';
  debugoptions:= '';
  debugtarget:= '';
  sourcefilemasks:= nil;
  syntaxdeffiles:= nil;
  fontalias:= nil;
  fontnames:= nil;
  fontheights:= nil;
  additem(sourcefilemasks,'"*.pas" "*.dpr" "*.pp" "*.inc"');
  additem(syntaxdeffiles,'${SYNTAXDEFDIR}pascal.sdef');
  additem(sourcefilemasks,'"*.c" "*.cc" "*.h"');
  additem(syntaxdeffiles,'${SYNTAXDEFDIR}cpp.sdef');
  additem(sourcefilemasks,'"*.mfm"');
  additem(syntaxdeffiles,'${SYNTAXDEFDIR}objecttext.sdef');

  newprojectfiles:= nil;
//  additem(newprojectfiles,'${TEMPLATEDIR}project1.pas');
//  additem(newprojectfiles,'${TEMPLATEDIR}main.pas');
//  additem(newprojectfiles,'${TEMPLATEDIR}main_mfm.pas');
  newprojectfilesdest:= nil;
  expandprojectfilemacros:= nil;
  loadprojectfile:= nil;
  newprogramfile:= '${TEMPLATEDIR}default/program.pas';
  newunitfile:= '${TEMPLATEDIR}default/unit.pas';
//  newtextfile:= '';
  newmainfosource:= '${TEMPLATEDIR}default/mainform.pas';
  newmainfoform:= '${TEMPLATEDIR}default/mainform.mfm';
  newsimplefosource:= '${TEMPLATEDIR}default/simpleform.pas';
  newsimplefoform:= '${TEMPLATEDIR}default/simpleform.mfm';
  newdockingfosource:= '${TEMPLATEDIR}default/dockingform.pas';
  newdockingfoform:= '${TEMPLATEDIR}default/dockingform.mfm';
  newdatamodsource:= '${TEMPLATEDIR}default/datamodule.pas';
  newdatamodform:= '${TEMPLATEDIR}default/datamodule.mfm';
  newsubfosource:= '${TEMPLATEDIR}default/subform.pas';
  newsubfoform:= '${TEMPLATEDIR}default/subform.mfm';
 end;
 expandprojectmacros;
end;

procedure projectoptionsmodified;
begin
 projectoptions.modified:= true;
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

procedure updateprojectoptions(const statfiler: tstatfiler);
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
//    setlength(modulefilenamesrel,int2);
    for int1:= 0 to high(modulenames) do begin
     with pmoduleinfoty(submenu[int1+int3].tag)^ do begin
      modulenames[int1]:= struppercase(instance.name);
      moduletypes[int1]:= struppercase(string(moduleclassname));
      modulefilenames[int1]:= filename;
//      modulefilenamesrel[int1]:= relativepath(filename);
     end;
    end;
   end;
  end;
  registeredcomponents.updatestat(statfiler);
  setsection('projectoptions');
  updatevalue('projectdir',projectdir);
//  updatevalue('projecthistory',projecthistory); stored in mainstat
//  updatevalue('titleprintfont',titleprintfont);
//  updatevalue('sourceprintfont',sourceprintfont);
//  updatevalue('printfontsize',printfontsize);
//  updatevalue('printlinenumbers',printlinenumbers);
//  updatevalue('printcolor',printcolor);
  updatememorystatstream('findinfiledialog',findinfiledialogstatname);
  updatememorystatstream('finddialog',finddialogstatname);
  updatememorystatstream('replacedialog',replacedialogstatname);
  updatememorystatstream('options',optionsstatname);
  updatememorystatstream('settaborder',settaborderstatname);
  updatememorystatstream('programparameters',programparametersstatname);
  updatememorystatstream('settings',settingsstatname);
  updatememorystatstream('printer',printerstatname);
  updatememorystatstream('stringlisteditor',stringlisteditorstatname);
  updatememorystatstream('texteditor',texteditorstatname);
  updatememorystatstream('colordialog',colordialogstatname);
  updatememorystatstream('bmpfiledialog',bmpfiledialogstatname);
{$ifdef FPC}{$ifndef mse_withoutdb}
  updatememorystatstream('dbfieldeditor',dbfieldeditorstatname);
{$endif}{$endif}
  if iswriter then begin
   with tstatwriter(statfiler) do begin
    writerecordarray('sigsettings',length(sigsettings),
                     {$ifdef FPC}@{$endif}getsignalinforec);
    writeinteger('gridsizex',gridsizex);
    writeinteger('gridsizey',gridsizey);
   end;
  end
  else begin
   with tstatreader(statfiler) do begin
    readrecordarray('sigsettings',{$ifdef FPC}@{$endif}setsignalinfocount,
             {$ifdef FPC}@{$endif}storesignalinforec);
    gridsizex:= readinteger('gridsizex',gridsizex,1,1000);
    gridsizey:= readinteger('gridsizey',gridsizey,1,1000);
   end;
  end;
  updatevalue('exceptclassnames',exceptclassnames);
  updatevalue('exceptignore',exceptignore);
  updatevalue('modulenames',modulenames);
  updatevalue('moduletypes',moduletypes);
  updatevalue('modulefiles',modulefilenames);
//  updatevalue('modulefilesrel',modulefilenamesrel);
  updatevalue('mainfile',mainfile);
  updatevalue('targetfile',targetfile);
  updatevalue('messageoutputfile',messageoutputfile);
  updatevalue('copymessages',copymessages);
  updatevalue('closemessages',closemessages);
  updatevalue('checkmethods',checkmethods);
  updatevalue('makecommand',makecommand);
  updatevalue('debugcommand',debugcommand);
  updatevalue('debugoptions',debugoptions);
  updatevalue('debugtarget',debugtarget);
  updatevalue('defaultmake',defaultmake,1,maxdefaultmake+1);
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
  updatevalue('sourcefilemasks',sourcefilemasks);
  updatevalue('syntaxdeffiles',syntaxdeffiles);
  updatevalue('fontalias',fontalias);
  updatevalue('fontnames',fontnames);
  updatevalue('fontheights',fontheights);
  updatevalue('showgrid',showgrid);
  updatevalue('snaptogrid',snaptogrid);
  updatevalue('autoindent',autoindent);
  updatevalue('blockindent',blockindent);
  updatevalue('rightmarginon',rightmarginon);
  updatevalue('rightmarginchars',rightmarginchars);
  updatevalue('tabstops',tabstops);
  updatevalue('editfontname',editfontname);
  updatevalue('editfontheight',editfontheight);
  updatevalue('editfontwidth',editfontwidth);
  updatevalue('editfontextraspace',editfontextraspace);
  updatevalue('editfontantialiased',editfontantialiased);
  updatevalue('backupfilecount',backupfilecount,0,10);
  updatevalue('encoding',encoding,0,1);
  
  updatevalue('newprojectfiles',newprojectfiles);
  updatevalue('newprojectfilesdest',newprojectfilesdest);
  updatevalue('expandprojectfilemacros',expandprojectfilemacros);
  updatevalue('loadprojectfile',loadprojectfile);
  
  updatevalue('newprogramfile',newprogramfile);
  updatevalue('newunitfile',newunitfile);
//  updatevalue('newtextfile',newtextfile);
  updatevalue('newmainfosource',newmainfosource);
  updatevalue('newmainfoform',newmainfoform);
  updatevalue('newsimplefosource',newsimplefosource);
  updatevalue('newsimplefoform',newsimplefoform);
  updatevalue('newdockingfosource',newdockingfosource);
  updatevalue('newdockingfoform',newdockingfoform);
  updatevalue('newdatamodsource',newdatamodsource);
  updatevalue('newdatamodform',newdatamodform);
  updatevalue('newsubfosource',newsubfosource);
  updatevalue('newsubfoform',newsubfoform);
  
  if not iswriter then begin
   if mainfo.sysenv.getintegervalue(int1,ord(env_vargroup),1,6) then begin
    macrogroup:= int1-1;
   end;
   expandprojectmacros;
  end;
  updatevalue('stoponexception',stoponexception);
  updatevalue('activateonbreak',activateonbreak);
  updatevalue('showconsole',showconsole);
  updatevalue('externalconsole',externalconsole);
  breakpointsfo.updatestat(statfiler);
  panelform.updatestat(statfiler);
  projecttree.updatestat(statfiler);

  setsection('layout');
  mainfo.projectstatfile.updatestat('windowlayout',statfiler);
//  updatestatfile('windowlayout',mainfo.projectstatfile);
  sourcefo.updatestat(statfiler);
  setsection('components');
  selecteditpageform.updatestat(statfiler);
  programparametersform.updatestat(statfiler);
  modified:= false;
 end;
end;

procedure projectoptionstoform(fo: tprojectoptionsfo);
var
 int1,int2: integer;
begin
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
  fo.exceptignore.gridvalues:= exceptignore;
  fo.exceptclassnames.gridvalues:= exceptclassnames;
  fo.mainfile.value:= mainfile;
  fo.targetfile.value:= targetfile;
  fo.messageoutputfile.value:= messageoutputfile;
  fo.copymessages.value:= copymessages;
  fo.closemessages.value:= closemessages;
  fo.checkmethods.value:= checkmethods;
  fo.showgrid.value:= showgrid;
  fo.snaptogrid.value:= snaptogrid;
  fo.gridsizex.value:= gridsizex;
  fo.gridsizey.value:= gridsizey;
  fo.autoindent.value:= autoindent;
  fo.blockindent.value:= blockindent;
  fo.tabstops.value:= tabstops;
  fo.rightmarginon.value:= rightmarginon;
  fo.rightmarginchars.value:= rightmarginchars;
  fo.editfontname.value:= editfontname;
  fo.editfontheight.value:= editfontheight;
  fo.editfontwidth.value:= editfontwidth;
  fo.editfontextraspace.value:= editfontextraspace;
  fo.editfontantialiased.value:= editfontantialiased;
  fo.backupfilecount.value:= backupfilecount;
  fo.encoding.value:= encoding;
  fo.fontalias.gridvalues:= fontalias;
  fo.fontname.gridvalues:= fontnames;
  fo.fontheight.gridvalues:= fontheights;
  fo.fontondataentered(nil);

  fo.newprojectfiles.gridvalues:= newprojectfiles;
  fo.newprojectfilesdest.gridvalues:= newprojectfilesdest;
  fo.expandprojectfilemacros.gridvalues:= expandprojectfilemacros;
  fo.loadprojectfile.gridvalues:= loadprojectfile;
  
  fo.newprogf.value:= newprogramfile;
  fo.newunitf.value:= newunitfile;
//  fo.newtextf.value:= newtextfile;
  fo.mainfosource.value:= newmainfosource;
  fo.mainfoform.value:= newmainfoform;
  fo.simplefosource.value:= newsimplefosource;
  fo.simplefoform.value:= newsimplefoform;
  fo.dockingfosource.value:= newdockingfosource;
  fo.dockingfoform.value:= newdockingfoform;
  fo.datamodsource.value:= newdatamodsource;
  fo.datamodform.value:= newdatamodform;
  fo.subfosource.value:= newsubfosource;
  fo.subfoform.value:= newsubfoform;

  fo.makecommand.value:= makecommand;
  fo.debugcommand.value:= debugcommand;
  fo.debugoptions.value:= debugoptions;
  fo.debugtarget.value:= debugtarget;
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
  fo.grid[0].datalist.asarray:= sourcefilemasks;
  fo.grid[1].datalist.asarray:= syntaxdeffiles;
  fo.def.gridvalues:= defines;
  fo.defon.gridvalues:= defineson;
  fo.stoponexception.value:= stoponexception;
  fo.activateonbreak.value:= activateonbreak;
  fo.showconsole.value:= showconsole;
  fo.externalconsole.value:= externalconsole;
 end;
end;

procedure storemacros(fo: tprojectoptionsfo);
var
 int1: integer;
begin
 with projectoptions,t do begin
//  macrogroup:= fo.activeenv.value;
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
  exceptignore:= fo.exceptignore.gridvalues;
  exceptclassnames:= fo.exceptclassnames.gridvalues;
  
  mainfile:= fo.mainfile.value;
  targetfile:= fo.targetfile.value;
  messageoutputfile:= fo.messageoutputfile.value;

  copymessages:= fo.copymessages.value;
  closemessages:= fo.closemessages.value;
  checkmethods:= fo.checkmethods.value;
  showgrid:= fo.showgrid.value;
  snaptogrid:= fo.snaptogrid.value;
  gridsizex:= fo.gridsizex.value;
  gridsizey:= fo.gridsizey.value;
  
  autoindent:= fo.autoindent.value;
  blockindent:= fo.blockindent.value;
  tabstops:= fo.tabstops.value;
  rightmarginon:= fo.rightmarginon.value;
  rightmarginchars:= fo.rightmarginchars.value;
  editfontname:= fo.editfontname.value;
  editfontheight:= fo.editfontheight.value;
  editfontwidth:= fo.editfontwidth.value;
  editfontextraspace:= fo.editfontextraspace.value;
  editfontantialiased:= fo.editfontantialiased.value;
  backupfilecount:= fo.backupfilecount.value;
  encoding:= fo.encoding.value;
  fontalias:= fo.fontalias.gridvalues;
  fontnames:= fo.fontname.gridvalues;
  fontheights:= fo.fontheight.gridvalues;

  newprojectfiles:= fo.newprojectfiles.gridvalues;
  newprojectfilesdest:= fo.newprojectfilesdest.gridvalues;
  expandprojectfilemacros:= fo.expandprojectfilemacros.gridvalues;
  loadprojectfile:= fo.loadprojectfile.gridvalues;
  newprogramfile:= fo.newprogf.value;
  newunitfile:= fo.newunitf.value;
//  newtextfile:= fo.newtextf.value;
  newmainfosource:= fo.mainfosource.value;
  newmainfoform:= fo.mainfoform.value;
  newsimplefosource:= fo.simplefosource.value;
  newsimplefoform:= fo.simplefoform.value;
  newdockingfosource:= fo.dockingfosource.value;
  newdockingfoform:= fo.dockingfoform.value;
  newdatamodsource:= fo.datamodsource.value;
  newdatamodform:= fo.datamodform.value;
  newsubfosource:= fo.subfosource.value;
  newsubfoform:= fo.subfoform.value;
  
  makecommand:= fo.makecommand.value;
  debugcommand:= fo.debugcommand.value;
  debugoptions:= fo.debugoptions.value;
  debugtarget:= fo.debugtarget.value;
  defaultmake:= 1 shl fo.defaultmake.value;
  makeoptions:= fo.makeoptions.gridvalues;
  setlength(makeoptionson,fo.makeoptionsgrid.rowcount);
  for int1:= 0 to high(makeoptionson) do begin
   makeoptionson[int1]:=
      fo.makeon.gridvaluetag(int1,0) or fo.buildon.gridvaluetag(int1,0) or
      fo.make1on.gridvaluetag(int1,0) or fo.make2on.gridvaluetag(int1,0) or
      fo.make3on.gridvaluetag(int1,0) or fo.make4on.gridvaluetag(int1,0);
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
  storemacros(fo);
  sourcedirs:= reversearray(fo.sourcedirs.gridvalues);
  defines:= fo.def.gridvalues;
  defineson:= fo.defon.gridvalues;
  sourcefilemasks:= fo.grid[0].datalist.asarray;
  syntaxdeffiles:= fo.grid[1].datalist.asarray;
  stoponexception:= fo.stoponexception.value;
  activateonbreak:= fo.activateonbreak.value;
  showconsole:= fo.showconsole.value;
  externalconsole:= fo.externalconsole.value;
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
end;

function readprojectoptions(const filename: filenamety): boolean;
var
 statreader: tstatreader;
begin
 result:= false;
 try
  statreader:= tstatreader.create(filename);
  try
   application.beginwait;
   updateprojectoptions(statreader);
   projectoptions.projectfilename:= filename;
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
 statwriter:= tstatwriter.create(filename);
 try
  updateprojectoptions(statwriter);
  projectoptions.projectfilename:= filename;
 finally
  statwriter.free;
 end;
end;

function editprojectoptions: boolean;
var
 fo: tprojectoptionsfo;
begin
 fo:= tprojectoptionsfo.create(nil);
// fo.debuggerpage.enabled:= not mainfo.gdb.running;
 projectoptionstoform(fo);
 try
  result:= fo.show(true,nil) = mr_ok;
  if result then begin
   formtoprojectoptions(fo);
   projectoptions.modified:= true;
   projectoptionschanged;
  end;
 finally
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
 expandmacros1(info.caption);
 include(info.flags,hfl_show); //show empty caption
end;

procedure tprojectoptionsfo.hintexpandedmacros(const sender: TObject;
                           var info: hintinfoty);
begin
 storemacros(self);
 info.caption:= tcustomedit(sender).text;
 expandmacros1(info.caption);
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
 expandmacros1(avalue);
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
 if avalue < signum.value then begin
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
end;

procedure tprojectoptionsfo.makepageonchildscaled(const sender: TObject);
var
 int1: integer;
begin
 placeyorder(0,[0],[mainfile,targetfile,makecommand,messageoutputfile,
                    defaultmake,makegroupbox],0);
 int1:= makesplitter.bounds_y;
 placeyorder(0,[0],[makeoptionsgrid,makesplitter,unitdirgrid],0);
 makesplitter.move(makepoint(0,int1-makesplitter.bounds_y)); //restore stat value
 int1:= aligny(wam_center,[defaultmake,showcommandline]);
 with copymessages do begin
  bounds_y:= int1 - bounds_cy - 2;
 end;
 checkmethods.bounds_y:= copymessages.bounds_y;
 with closemessages do begin
  bounds_y:= int1;
 end;
end;

procedure tprojectoptionsfo.debuggeronchildscaled(const sender: TObject);
begin
// placeyorder(sourcedirgrid.bounds_y,0,[sourcedirgrid,debuggersplitter,signalgrid],0);
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
 placeyorder(0,[0],[mainfosource,mainfoform,simplefosource,simplefoform,
       dockingfosource,dockingfoform,datamodsource,datamodform,
       subfosource,subfoform]);
end;

procedure tprojectoptionsfo.encodingsetvalue(const sender: TObject;
               var avalue: LongInt; var accept: Boolean);
var
 mstr1: msestring;
begin
 if avalue = 0 then begin
  mstr1:= 'Locale';
 end
 else begin
  mstr1:= 'utf8';
 end;
 accept:= askyesno('Wrong encoding can destroy your source files.'+lineend+
             'Do you wish to set encoding to '+mstr1+'?','*** WARNING ***');
end;

procedure tprojectoptionsfo.createexe(const sender: TObject);
begin
 {$ifdef mswindows}
 externalconsole.visible:= true;
 {$endif}
end;

end.

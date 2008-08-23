{ MSEide Copyright (c) 1999-2008 by Martin Schreiber
   
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
unit sourcepage;

{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

uses
 msetextedit,msewidgetgrid,mseforms,classes,msegdbutils,msegraphedits,mseevent,
 msehash,msebitmap,msetabs,msetypes,
 mseglob,mseguiglob,msegui,msesyntaxedit,mseeditglob,
 mseinplaceedit,msedispwidgets,msegraphutils,msegrids,breakpointsform,
 pascaldesignparser,msefilechange,msestrings,mserichstring,mseparser;


type
 sourcepageasynctagty = (spat_showasform,spat_checkbracket,spat_showsource);
 
 bookmarkty = record
  row: integer;
  bookmarknum: integer;
 end;
 bookmarkarty = array of bookmarkty;
 
 tsourcepage = class(ttabform)
   grid: twidgetgrid;
   edit: tsyntaxedit;
   dataicon: tdataicon;
   linedisp: tstringdisp;
   pathdisp: tstringdisp;
   procedure icononcellevent(const sender: tobject; var info: celleventinfoty);
   procedure sourcefooncreate(const sender: tobject);
   procedure sourcefoondestroy(const sender: tobject);
   procedure editoncellevent(const sender: TObject; var info: celleventinfoty);
   procedure editonmodifiedchanged(const sender: tobject; const value: boolean);
   procedure editontextmouseevent(const sender: tobject; var info: textmouseeventinfoty);
   procedure editoneditnotification(const sender: tobject; var info: editnotificationinfoty);
   procedure gridonrowsdeleted(const sender: tcustomgrid; const index,count: integer);
   procedure gridonrowsinserted(const sender: tcustomgrid; const index,count: integer);
   procedure sourcefoonloaded(const sender: TObject);
   procedure textchanged(const sender: TObject);
   procedure sourcefoonshow(const sender: TObject);
   procedure editonfontchanged(const sender: TObject);
   procedure sourcefoondeactivate(const sender: TObject);
   procedure gridoncellevent(const sender: TObject; var info: celleventinfoty);
   procedure editonkeydown(const sender: twidget; var info: keyeventinfoty);
  private
   factiverow: integer;
   flasthint: gridcoordty;
   flasthintlength: integer;
   fbackupcreated: boolean;
   ffindpos: gridcoordty;
   ffiletag: cardinal;
   fsavetime: tdatetime;
   fexecstamp: integer;
   fgotoline: integer;
   ffileloading: integer;
   ffileloaderror: boolean;
   frelpath: filenamety;
   fbracketsetting: integer;
   fbracketchecking: integer;
   fshowsourcepos: sourceposty;
   procedure setactiverow(const Value: integer);
   procedure setgdb(agdb: tgdbmi);
   procedure setfilepath(const value: filenamety);
   function getfilename: filenamety;
   function getfilepath: filenamety;
   function getrelpath: filenamety;
   procedure find;
   procedure replace(all: boolean);
   procedure showprocheaders(const apos: gridcoordty);
   procedure showsourceitems(const apos: gridcoordty);
   procedure showlink(const apos: gridcoordty);
   procedure showsourcehint(const apos: gridcoordty; const values: stringarty);
   procedure textnotfound;
   procedure setsyntaxdef(const value: filenamety);
  protected
   finitialfilepath: filenamety;
   finitialeditpos: gridcoordty;
   finitialbookmarks: bookmarkarty;
   fbracket1,fbracket2: gridcoordty;
   procedure doasyncevent(var atag: integer); override;
   procedure removebookmark(const bookmarknum: integer);
   procedure callcheckbrackets;
   procedure checkbrackets;
   procedure clearbrackets;
  public
   filechanged: boolean;
   ismoduletext: boolean;
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   procedure loadfile(const value: filenamety); overload;
   procedure loadfile; overload; //loads if needed
   function fileloaded: boolean;
   procedure setbackupcreated;
   procedure updatestatvalues;
   procedure updatecaption(const modified: boolean);
   procedure updatebreakpointicons;
   procedure updatebreakpointicon(const info: bkptlineinfoty);
   procedure togglebreakpoint(const arow: integer = -1);
   procedure togglebreakpointenabled(const arow: integer = -1);
   procedure cleardebuglines;
   procedure updatedebuglines;
   procedure hidehint;
   procedure save(newname: filenamety);
   function checksave(noconfirm,multiple: boolean): modalresultty;
   function modified: boolean;
   function source: trichstringdatalist;
   procedure doline;
   procedure dofind;
   procedure repeatfind;
   procedure doreplace;
   procedure reload;
   function canchangenotify(const info: filechangeinfoty): boolean;
   function getbreakpointstate(arow: integer = -1): bkptstatety;
                     //-1 -> actual row
   procedure setbreakpointstate(astate: bkptstatety; arow: integer = -1);
                     //-1 -> actual row
   function findbookmark(const bookmarknum: integer): integer;
                     //returns row, -1 if not found
   procedure setbookmark(arow: integer; const bookmarknum: integer);
                     //arow -1 -> current row, bookmarknum < 1 -> clear
   procedure clearbookmark(const bookmarknum: integer);
   function getbookmarks: bookmarkarty;
   
   property activerow: integer read factiverow write setactiverow;
   property gdb: tgdbmi write setgdb;
   property filename: filenamety read getfilename;
   property relpath: filenamety read getrelpath write frelpath;
   property filepath: filenamety read getfilepath write setfilepath;
   property filetag: cardinal read ffiletag;
 end;

function getpascalvarname(const edit: tsyntaxedit; pos: gridcoordty;
                                  out startpos: gridcoordty): msestring; overload;
function getpascalvarname(const edit: tsyntaxedit; const pos: pointty): msestring; overload;

implementation

uses
 sourcepage_mfm,msefileutils,sourceform,main,
 sysutils,msewidgets,finddialogform,replacedialogform,msekeyboard,
 sourceupdate,msefiledialog,mseintegerenter,msedesigner,
 projectoptionsform,msesys,make,actionsmodule,msegraphics,sourcehintform,
 mseedit,msedrawtext,msebits,msedatalist,msestream,msedesignintf,
 msesysutils,msedesignparser;

const
 pascaldelims = msestring(' :;+-*/(){},=<>' + c_linefeed + c_return + c_tab);
 nodelimstrings: array[0..0] of msestring = ('->'); //for c
 bmbitshift = 4;
 bmbitmask = integer($3ff0);

function getpascalvarname(const edit: tsyntaxedit; pos: gridcoordty;
                          out startpos: gridcoordty): msestring;
var
 int1: integer;
begin
 startpos:= edit.wordatpos(pos,result,pascaldelims,nodelimstrings);
 if (result = '') and (pos.col > 0) then begin
  dec(pos.col);
  startpos:= edit.wordatpos(pos,result,pascaldelims,nodelimstrings);
 end; 
 if result <> '' then begin
  for int1:= pos.col - startpos.col + 1 to length(result) do begin
   if (result[int1] = '.') or (result[int1] = '-') and (result[int1+1] = '>') then begin
    setlength(result,int1-1);
    break;
   end;
  end;
 end;
end;

function getpascalvarname(const edit: tsyntaxedit; const pos: pointty): msestring;
var
 po1,po2: gridcoordty;
begin
 if edit.mousepostotextpos(pos,po1,true) then begin
  result:= getpascalvarname(edit,po1,po2);
 end
 else begin
  result:= '';
 end;
end;

{ tsourcepage }

constructor tsourcepage.create(aowner: tcomponent);
begin
 factiverow:= -1;
 fgotoline:= 1;
 fbracket1:= invalidcell;
 fbracket2:= invalidcell;
 inherited create(aowner);
 updatestatvalues;
end;

destructor tsourcepage.destroy;
begin
 inherited;
end;

procedure tsourcepage.doasyncevent(var atag: integer);
var
 mstr1: filenamety;
 po1: pmoduleinfoty;
begin
 case sourcepageasynctagty(atag) of
  spat_showasform: begin
   mstr1:= filepath;
   if sourcefo.closepage(self) then begin
    po1:= mainfo.openformfile(mstr1,true,false,false,true);
    if po1 <> nil then begin
     po1^.backupcreated:= fbackupcreated;
     designer.modulechanged(po1);
    end;
   end;
  end;
  spat_checkbracket: begin
   dec(fbracketchecking);
   checkbrackets;
  end;
  spat_showsource: begin
   sourcefo.naviglist.showsource(fshowsourcepos,true);
  end;
 end;
end;

procedure tsourcepage.sourcefoonloaded(const sender: TObject);
begin
 updatestatvalues;
 grid.bottom:= linedisp.top - 1;
end;

procedure tsourcepage.textchanged(const sender: TObject);
begin
 sourcechanged(edit.filename);
end;

procedure tsourcepage.updatecaption(const modified: boolean);
var
 str1: filenamety;
begin
 if ffileloading > 0 then begin
  exit;
 end;
 pathdisp.value:= finitialfilepath;
 str1:= filename;
 if str1 = '' then begin
  str1:= '<new>';
 end;
 if modified then begin
  caption:= '*'+str1;
  sourcefo.textmodified(self);
 end
 else begin
  caption:= str1;
 end;
 if isactivepage then begin
  tsourcefo(tabwidget.parentofcontainer).updatecaption;
 end;
end;

procedure tsourcepage.updatebreakpointicon(const info: bkptlineinfoty);
var
 int1: integer;
begin
 with info do begin
  int1:= line-1;
  if (int1 >= 0) and (int1 <= grid.rowhigh) then begin
   setbreakpointstate(state,int1);
  end;
 end;
end;

procedure tsourcepage.updatebreakpointicons;
var
 int1: integer;
 ar1: bkptlineinfoarty;
begin
 ar1:= breakpointsfo.getbreakpointlines(edit.filename);
 for int1:= 0 to high(ar1) do begin
  updatebreakpointicon(ar1[int1]);
 end;
end;

procedure tsourcepage.setsyntaxdef(const value: filenamety);
begin
 try
  edit.setsyntaxdef(value);
 except
  on e: exception do begin
   handleerror(e,'Syntaxdeffile:');
  end;
 end;
end;

procedure tsourcepage.loadfile(const value: filenamety);
begin
 inc(ffileloading);
 try
  edit.loadfromfile(value);
  finitialfilepath:= edit.filename;
  setsyntaxdef(value);
  updatebreakpointicons;
  if mainfo.gdb.execloaded and actionsmo.bluedotsonact.checked then begin
   updatedebuglines;
  end;
 finally
  dec(ffileloading);
 end;
 updatecaption(false);
end;

function tsourcepage.fileloaded: boolean;
begin
 result:= (edit.filename = finitialfilepath) or (finitialfilepath = '');
end;

function tsourcepage.getfilepath: filenamety;
begin
 result:= finitialfilepath;
end;

function tsourcepage.getrelpath: filenamety;
begin
 if fileloaded or (frelpath = '') then begin
  result:= relativepath(finitialfilepath,projectoptions.projectdir);
 end
 else begin
  result:= frelpath;
 end;
end;

function tsourcepage.getfilename: filenamety;
begin
 result:= msefileutils.filename(finitialfilepath);
end;

procedure tsourcepage.loadfile; //loads if needed
var
 mstr1: filenamety;
 int1: integer;
begin
 if not fileloaded then begin
  mstr1:= relpath;
  if findfile(mstr1) then begin
   mstr1:= msefileutils.filepath(mstr1);
  end
  else begin
   mstr1:= finitialfilepath;
  end;
  setfilepath(mstr1);
  sourcefo.filechangenotifyer.addnotification(finitialfilepath,filetag);
  edit.editpos:= finitialeditpos;
  for int1:= 0 to high(finitialbookmarks) do begin
   with finitialbookmarks[int1] do begin
    if (row >= 0) and (bookmarknum >= 0) and (row < grid.rowcount) and 
             (bookmarknum < 10) then begin
     setbookmark(row,bookmarknum);
    end;
   end;
  end;
 end;
end;

procedure tsourcepage.setfilepath(const value: filenamety);
begin
 if edit.filename <> value then begin
  fbackupcreated:= false;
  ffiletag:= sourcefo.newfiletag;
  loadfile(value);
 end;
end;

procedure tsourcepage.reload;
begin
 loadfile(edit.filename);
end;

procedure tsourcepage.cleardebuglines;
var
 po1: pintegeraty;
 int1: integer;
begin
 if fexecstamp <> 0 then begin
  fexecstamp:= 0;
  po1:= dataicon.datalist.datapo;
  for int1:= 0 to dataicon.datalist.count - 1 do begin
   po1^[int1]:= po1^[int1] and (bmbitmask or integer($80000000));
  end;
  dataicon.datalist.change(-1);
//  dataicon.fillcol(integer($80000000));
  updatebreakpointicons;
 end;
end;

procedure tsourcepage.updatedebuglines;
var
 ar1: integerarty;
 ar2: ptruintarty;
 po1: pintegeraty;
 int1,int2: integer;
begin
 if mainfo.gdb.cancommand then begin
  if fexecstamp <> mainfo.execstamp then begin
   fexecstamp:= mainfo.execstamp;
   application.beginwait;
   if mainfo.gdb.listlines(edit.filename,ar1,ar2) = gdb_ok then begin
    po1:= pintegeraty(dataicon.datalist.datapo);
    for int1:= 0 to dataicon.datalist.count - 1 do begin
     po1^[int1]:= po1^[int1] and (bmbitmask or integer($80000000));
    end;
    int2:= dataicon.datalist.count;
    for int1:= 0 to high(ar1) do begin
     if (ar1[int1] > 0) and (ar1[int1] <= int2) then begin
      po1^[ar1[int1]-1]:= po1^[ar1[int1]-1] or integer($80000008);
     end;
    end;
    updatebreakpointicons;
    dataicon.datalist.change(-1);
   end
   else begin
    cleardebuglines;
   end;
   application.endwait;
  end;
 end;
end;

function tsourcepage.canchangenotify(const info: filechangeinfoty): boolean;
begin
 result:= info.info.extinfo1.modtime - fsavetime > 5.0/(24.0*3600); //> 5 sec
 with projectoptions,texp do begin
  if result and making and copymessages and
          (filepath = msefileutils.filepath(messageoutputfile)) then begin
   result:= false;
  end;
 end;
end;

procedure tsourcepage.showsourcehint(const apos: gridcoordty;
                const values: stringarty);
var
 rect1: rectty;
 int1: integer;
begin
 if high(values) >= 0 then begin
  sourcefo.sourcehintwidget:= tsourcehintfo.create(nil);
  with tsourcehintfo(sourcefo.sourcehintwidget) do begin
   if (sourcefo.hintsize.cx <= 0) or (sourcefo.hintsize.cy <= 0) then begin
    sourcefo.hintsize:= size;
   end;
   rect1:= edit.textpostomouserect(apos,true);
   dec(rect1.y,10);
   inc(rect1.cy,40);
   setlength(dispar,length(values));
   for int1:= 0 to high(values) do begin
    dispar[int1]:= tedit.create(sourcefo.sourcehintwidget);
    with dispar[int1] do begin
     initnewcomponent(1.0);
     frame.levelo:= 0;
     frame.framewidth:= 1;
     frame.colorframe:= cl_dkgray;
     
     optionsedit:= optionsedit + [oe_readonly];
     textflags:= [tf_wordbreak,tf_noselect];
     textflagsactive:= [tf_wordbreak];
     anchors:= [an_top];
     text:= values[high(values)-int1];
    end;
   end;
   for int1:= high(values) downto 0 do begin
    dispar[int1].parentwidget:= sourcefo.sourcehintwidget.container;
   end;
   size:= sourcefo.hintsize;
   formonresize(nil);
   widgetrect:= placepopuprect(self.window,rect1,
       cp_bottomleft,size);
   show(false,self.window);
  end;
 end
 else begin
  sourcefo.hidesourcehint;
 end;
 activate(false); //get focus back
end;

procedure tsourcepage.showprocheaders(const apos: gridcoordty);
var
 ar1: procedureinfoarty;
 ar2: stringarty;
 int1: integer;
 pos1: sourceposty;
begin
 pos1.pos:= apos;
 ar1:= listprocheaders(edit.filename,pos1);
 setlength(ar2,length(ar1));
 for int1:= 0 to high(ar1) do begin
  ar2[int1]:= sourceupdater.composeprocedureheader(@ar1[int1],true);
 end;
 showsourcehint(apos,ar2);
end;

procedure tsourcepage.showsourceitems(const apos: gridcoordty);
var
 scopes: deflistarty;
 defs: definfopoarty;
 pos1: sourceposty;
 ar1: stringarty;
 int1: integer;
begin
 pos1.pos:= apos;
 listsourceitems(edit.filename,pos1,scopes,defs,100);
 setlength(ar1,length(defs));
 for int1:= 0 to high(defs) do begin
  ar1[int1]:= defs[int1]^.name;
 end;
 if high(ar1) >= 99 then begin
  ar1[high(ar1)]:= '...';
 end;
 showsourcehint(apos,ar1);
end;

procedure tsourcepage.editoncellevent(const sender: TObject; 
                                                    var info: celleventinfoty);

 procedure checklink;
 var
  pos2: gridcoordty;
 begin
  if info.keyeventinfopo^.shiftstate = [ss_ctrl] then begin
   if edit.mousepostotextpos(translatewidgetpoint(application.mouse.pos,nil,edit),
                                            pos2,true) then begin
    showlink(pos2);
   end;
  end
  else begin
   edit.removelink;
  end;
 end;

var
 pos1,pos2: sourceposty;
 page1: tsourcepage;
 
begin
 if iscellclick(info,[ccr_nokeyreturn,ccr_dblclick]) and 
           (dataicon[info.cell.row] and integer($80000000) <> 0) and
           (info.mouseeventinfopo^.shiftstate = [ss_double]) then begin
  include(info.mouseeventinfopo^.eventstate,es_processed);
  breakpointsfo.showbreakpoint(filepath,info.cell.row + 1,true);
 end;
 case info.eventkind of
  cek_exit: begin
   edit.removelink;
  end;
  cek_keyup: begin
   checklink;
  end;
  cek_keydown: begin
   checklink;
   with info.keyeventinfopo^ do begin
    if not (es_processed in eventstate) then begin
     if ((shiftstate = [ss_shift,ss_ctrl]) or (shiftstate = [ss_ctrl])) then begin
      include(eventstate,es_processed);
      pos1.pos:= edit.editpos;
      if (shiftstate = [ss_shift,ss_ctrl]) then begin
       case key of
        key_up,key_down: begin
         if switchheaderimplementation(edit.filename,pos1,pos2) then begin
          page1:= sourcefo.showsourcepos(pos2,true);
          if page1 <> nil then begin
           page1.grid.showcell(makegridcoord(1,pos1.pos.row));
          end;
         end;
        end;
        key_space: begin
         showprocheaders(edit.editpos);
        end;
        else begin
         exclude(eventstate,es_processed);
        end;
       end;
      end
      else begin
       case key of
        key_space: begin
         showsourceitems(edit.editpos);
        end
        else begin
         exclude(eventstate,es_processed);
        end;
       end;
      end;
     end
     else begin
      if shiftstate = [] then begin
       include(eventstate,es_processed);
       case key of
        key_escape: begin
         if not sourcefo.hidesourcehint then begin
          exclude(eventstate,es_processed);
         end;
        end;
        else begin
         exclude(eventstate,es_processed);
        end;
       end;
      end;
     end;
    end;
   end;
  end;
 end;
end;

const
 convtab: array[0..7] of bkptstatety =
   //  000      001           010           011
  (bkpts_none,bkpts_normal,bkpts_disabled,bkpts_none,
   //  100      101           110           111
   bkpts_none,bkpts_error,bkpts_none,bkpts_none);

procedure tsourcepage.icononcellevent(const sender: tobject;
  var info: celleventinfoty);
var
 bpinfo: breakpointinfoty;
 astate: bkptstatety;
begin
 with dataicon do begin
  if iscellclick(info) then begin
   astate:= convtab[gridvalue[info.cell.row] and 7];
   fillchar(bpinfo,sizeof(bpinfo),0);
   bpinfo.line:= info.cell.row + 1;
   bpinfo.path:= edit.filename;
   bpinfo.bkpton:= astate in [bkpts_disabled,bkpts_none]; //for toggle
   case astate of
    bkpts_none: begin
     breakpointsfo.addbreakpoint(bpinfo);
    end;
    bkpts_normal,bkpts_disabled,bkpts_error: begin
     if iscellclick(info,[ccr_dblclick]) then begin
      breakpointsfo.deletebreakpoint(bpinfo);
     end
     else begin
      breakpointsfo.updatebreakpointon(bpinfo);
     end;
    end;
   end;
  end;
 end;
end;

function tsourcepage.getbreakpointstate(arow: integer = -1): bkptstatety;
begin
 if arow = -1 then begin
  arow:= grid.row;
 end;
 if (arow >= 0) and (arow < grid.rowcount) then begin
  result:= convtab[dataicon[arow] and 7];
 end
 else begin
  result:= bkpts_none;
 end;
end;

procedure tsourcepage.setbreakpointstate(astate: bkptstatety;
                                arow: integer = -1);
begin
 if arow = -1 then begin
  arow:= grid.row;
 end;
 if (arow >= 0) and (arow < grid.rowcount) then begin
  case astate of
   bkpts_none: dataicon[arow]:= dataicon[arow] and not integer($00000007);
   bkpts_normal: dataicon[arow]:= dataicon[arow] and not integer($00000007) or 
                                     integer($80000001);
   bkpts_disabled: dataicon[arow]:= dataicon[arow] and not integer($00000007) or 
                                     integer($80000002);
   bkpts_error: dataicon[arow]:= dataicon[arow] and not integer($00000007) or 
                                     integer($80000005);
  end;
 end;
end;

procedure tsourcepage.togglebreakpoint(const arow: integer = -1);
var
 bpinfo: breakpointinfoty;
 astate: bkptstatety;
begin
 astate:= getbreakpointstate(grid.row);
 fillchar(bpinfo,sizeof(bpinfo),0);
 if arow < 0 then begin
  bpinfo.line:= grid.row + 1;
 end
 else begin
  bpinfo.line:= arow + 1;
 end;
 bpinfo.path:= edit.filename;
 case astate of
  bkpts_none: begin
   bpinfo.bkpton:= true;
   breakpointsfo.addbreakpoint(bpinfo);
  end
  else begin
   breakpointsfo.deletebreakpoint(bpinfo);
   setbreakpointstate(bkpts_none,grid.row); 
         //if breakpointinfo is not synchronized
  end;
 end;
end;

procedure tsourcepage.togglebreakpointenabled(const arow: integer = -1);
var
 bpinfo: breakpointinfoty;
 astate: bkptstatety;
begin
 astate:= convtab[dataicon.value and 7];
 fillchar(bpinfo,sizeof(bpinfo),0);
 if arow < 0 then begin
  bpinfo.line:= grid.row + 1;
 end
 else begin
  bpinfo.line:= arow + 1;
 end;
 bpinfo.path:= edit.filename;
 bpinfo.bkpton:= astate in [bkpts_disabled{,bkpts_none}]; //for toggle
 if astate = bkpts_none then begin
  breakpointsfo.addbreakpoint(bpinfo);
 end
 else begin
  breakpointsfo.updatebreakpointon(bpinfo);
 end;
end;

procedure tsourcepage.setactiverow(const Value: integer);
begin
 if factiverow <> value then begin
  if (factiverow >= 0) and (factiverow < grid.rowcount) then begin
   grid.rowcolorstate[factiverow]:= -1;
  end;
  if (value >= 0) and (value < grid.rowcount) then begin
   grid.rowcolorstate[value]:= 0;
   grid.showcell(makegridcoord(0,value),cep_rowcenteredif);
   edit.editpos:= makegridcoord(0,value)
  end;
 end;
 factiverow := Value;
end;

procedure tsourcepage.setgdb(agdb: tgdbmi);
begin
// breakpoints.fgdb:= agdb;
end;

procedure tsourcepage.sourcefooncreate(const sender: tobject);
begin
// breakpoints:= tbreakpoints.create;
end;

procedure tsourcepage.sourcefoondestroy(const sender: tobject);
begin
// breakpoints.Free;
end;

procedure tsourcepage.editonmodifiedchanged(const sender: tobject; const value: boolean);
begin
 updatecaption(value);
end;

function tsourcepage.checksave(noconfirm,multiple: boolean): modalresultty;
begin
 result:= mr_none;
 if not sourcefo.allsaved then begin
  if edit.modified and (noconfirm or 
              confirmsavechangedfile(edit.filename,result,multiple)) then begin
   save('');
  end;
 end;
end;

procedure tsourcepage.save(newname: filenamety);
var
 info: fileinfoty;
begin
 if newname = '' then begin
  if (edit.filename = '') then begin
   if filedialog(newname,[fdo_save],'',[],[]) = mr_cancel then begin
    exit;
   end;
  end
  else begin
   newname:= edit.filename;
  end;
 end;
 createbackupfile(newname,edit.filename,fbackupcreated,
                            projectoptions.backupfilecount);
 finitialfilepath:= newname;
 try
  designnotifications.beforefilesave(idesigner(designer),newname);
 except
  application.handleexception(nil);
 end; 
 edit.savetofile(newname);
 setsyntaxdef(newname);
 if getfileinfo(newname,info) then begin
  fsavetime:= info.extinfo1.modtime;
 end;
 updatecaption(false);
end;

function tsourcepage.modified: boolean;
begin
 result:= edit.modified;
end;

procedure tsourcepage.textnotfound;
begin
 showmessage('Text '''+projectoptions.findreplaceinfo.find.text+''' not found.');
end;
 
procedure tsourcepage.find;
var
 pt1: gridcoordty;
begin
 with projectoptions.findreplaceinfo.find do begin
  if selectedonly then begin
   if edit.hasselection then begin
    normalizetextrect(edit.selectstart,edit.selectend,ffindpos,pt1);
    if not edit.find(text,options,ffindpos,pt1,true) then begin
     textnotfound;
    end
    else begin
     selectedonly:= false;
    end;
   end;
  end
  else begin
   ffindpos:= edit.editpos;
//   dec(ffindpos.col);
   if not edit.find(text,options,ffindpos,bigcoord,true) then begin
    if (ffindpos.row = 0) and (ffindpos.col = 0) then begin
     textnotfound;
    end
    else begin
     if askok('Text '''+text+
              ''' not found. Restart from begin of file?') then begin
      ffindpos:= nullcoord;
      if not edit.find(text,options,ffindpos,edit.editpos,true) then begin
       textnotfound;
      end;
     end;
    end;
   end;
  end;
 end;
end;

procedure tsourcepage.replace(all: boolean);
var
 pos1: gridcoordty;
 res1: modalresultty;
 rect1: rectty;
 
begin
 with projectoptions.findreplaceinfo,find do begin
  edit.editor.begingroup;
  try
   if selectedonly then begin
    if not edit.hasselection then begin
     exit;
    end
    else begin
     normalizetextrect(edit.selectstart,edit.selectend,ffindpos,pos1);
    end;
   end
   else begin
    ffindpos:= edit.editpos;
    pos1:= bigcoord;
   end;
   if not edit.find(text,options,ffindpos,pos1,true) then begin
    textnotfound;
   end
   else begin
    res1:= mr_yes;
    repeat
     rect1:= edit.textpostomouserect(ffindpos);
     if prompt then begin
      res1:= showmessage('Do you wish to to replace this occurence?','',
       [mr_yes,mr_all,mr_no,mr_cancel],rect1,grid,cp_bottomleft,res1);
     end
     else begin
      res1:= mr_yes;
     end;
     case res1 of
      mr_no: begin
       inc(ffindpos.col,length(text));
      end;
      mr_yes,mr_all: begin
       edit.deleteselection;
       edit.inserttext(ffindpos,replacetext);
       inc(ffindpos.col,length(replacetext));
       if res1 = mr_all then begin
        prompt:= false;
        all:= true;
       end;
      end;
      else begin
       exit;
      end;
     end;
    until not all or not edit.find(text,options,ffindpos,pos1,true);
   end;
  finally
   edit.editor.endgroup;
  end;
 end;
end;

procedure tsourcepage.doline;
begin
 if integerenter(fgotoline,1,grid.rowcount,'Go to line number:','Find line') = mr_ok then begin
  grid.row:= fgotoline-1;
 end;
end;

procedure tsourcepage.dofind;
var
 ainfo: findinfoty;
begin
 ainfo:= projectoptions.findreplaceinfo.find;
 if not edit.hasselection then begin
  ainfo.selectedonly:= false;
 end;
// ainfo.text:= edit.selectedtext;
 if finddialogexecute(ainfo) then begin
  projectoptions.findreplaceinfo.find:= ainfo;
  find;
 end;
end;

procedure tsourcepage.doreplace;
var
 ainfo: replaceinfoty;
 res1: modalresultty;
begin
 ainfo:= projectoptions.findreplaceinfo;
// ainfo.find.text:= edit.selectedtext;
 res1:= replacedialogexecute(ainfo);
 if res1 in [mr_ok,mr_all] then begin
  projectoptions.findreplaceinfo:= ainfo;
  replace(res1 = mr_all);
 end;
end;

procedure tsourcepage.repeatfind;
begin
 find;
end;

procedure tsourcepage.hidehint;
begin
 flasthint:= invalidcell;
 flasthintlength:= 0;
 application.hidehint;
end;

procedure tsourcepage.showlink(const apos: gridcoordty);
begin
 edit.showlink(apos,pascaldelims + '.[]');
end;

procedure tsourcepage.editontextmouseevent(const sender: tobject;
  var info: textmouseeventinfoty);

var
 po1: gridcoordty;
 str1,str2: msestring;
 pos1: sourceposty;
begin
 if mainfo.gdb.started and projectoptions.valuehints then begin
  if info.eventkind = cek_mousepark then begin
   str1:= getpascalvarname(edit,info.pos,po1);
   if (po1.row <> flasthint.row) or (po1.col <> flasthint.col) or
         (length(str1) <> flasthintlength) then begin
    if str1 <> '' then begin
     if mainfo.gdb.readpascalvariable(str1,str2) = gdb_ok then begin
      application.showhint(nil,str1 + ' = ' + str2,
       inflaterect(edit.textpostomouserect(po1,true),20),cp_bottomleft,0);
     end
     else begin
      hidehint;
     end;
     flasthint:= po1;
     flasthintlength:= length(str1);
    end
    else begin
     hidehint;
     flasthintlength:= -1;
    end;
   end;
  end;
 end;
 with info do begin
  case eventkind of
   cek_mousemove: begin
    if (mouseeventinfopo^.shiftstate = [ss_ctrl]) and active then begin
     showlink(info.pos);
    end;
   end;
   cek_mouseleave: begin
    edit.removelink;
   end;
   cek_buttonpress: begin
    if (mouseeventinfopo^.shiftstate = [ss_ctrl,ss_left]) {and active} then begin
//     include(info.mouseeventinfopo^.eventstate,es_processed);
     pos1.pos:= info.pos;
     pos1.filename:= designer.designfiles.find(edit.filename);
     if findlinkdest(edit,pos1,str1) then begin
      fshowsourcepos:= pos1;
      asyncevent(ord(spat_showsource));
//      sourcefo.naviglist.showsource(pos1,true);
     end;
    end
    else begin
     if edit.isdblclicked(info.mouseeventinfopo^) and 
                (mouseeventinfopo^.shiftstate = [ss_double,ss_shift,ss_left]) then begin
      edit.selectword(info.pos,pascaldelims+'.[]');
      include(info.mouseeventinfopo^.eventstate,es_processed);
     end;
    end;
   end;
  end;
 end;
end;

procedure tsourcepage.editoneditnotification(const sender: tobject;
  var info: editnotificationinfoty);
begin
 if (info.action = ea_beforechange) and not edit.syntaxchanging then begin
  clearbrackets;
 end
 else begin
  if info.action = ea_indexmoved then begin
   linedisp.value:= inttostr(edit.editpos.row+1) + ':'+inttostr(edit.editpos.col+1);
  end;
  if info.action in [ea_indexmoved,ea_delchar,ea_deleteselection,ea_pasteselection,
                     ea_textentered] then begin
   callcheckbrackets;
  end;
 end;
end;

procedure tsourcepage.gridonrowsdeleted(const sender: tcustomgrid;
  const index, count: integer);
begin
 breakpointsfo.sourcelinesdeleted(filepath,index+1,count);
end;

procedure tsourcepage.gridonrowsinserted(const sender: tcustomgrid;
  const index, count: integer);
begin
 breakpointsfo.sourcelinesinserted(filepath,index+1,count);
end;

procedure tsourcepage.sourcefoonshow(const sender: TObject);
begin
 if not ffileloaderror then begin
  try
   loadfile;
   mainfo.checkbluedots;
  except
   on e: exception do begin
    ffileloaderror:= true;
    application.showasyncexception(e,'');
    hide;
 //   parentwidget:= nil;
    release;
   end;
  end;
 end;
end;

procedure tsourcepage.updatestatvalues;
var
 int1: integer;
begin
 if edit <> nil then begin
  projectoptionstofont(edit.font);
  grid.datarowheight:= edit.font.lineheight;
  with projectoptions do begin
   int1:= edit.getcanvas.getstringwidth('oo') div 2;
   if rightmarginon then begin
    edit.marginlinecolor:= cl_gray;
    edit.marginlinepos:= int1 * rightmarginchars;
   end
   else begin
    edit.marginlinecolor:= cl_none;
   end;
   if tabstops < 1 then begin
    tabstops:= 1;
   end;
   edit.tabulators.clear;
   edit.tabulators.defaultdist:= int1 * tabstops / edit.tabulators.ppmm;
//   edit.tabulators.setdefaulttabs(int1 * tabstops / edit.tabulators.ppmm);
   edit.autoindent:= autoindent;
   if encoding = 1 then begin
    edit.encoding:= ce_utf8n;
   end
   else begin
    edit.encoding:= ce_ansi;
   end;
   grid.wheelscrollheight:= scrollheight;
  end;
 end;
end;

procedure tsourcepage.editonfontchanged(const sender: TObject);
begin
// updatestatvalues;
end;

procedure tsourcepage.sourcefoondeactivate(const sender: TObject);
begin
 sourcefo.hidesourcehint;
end;

procedure tsourcepage.gridoncellevent(const sender: TObject; 
             var info: celleventinfoty);
begin
 if (info.eventkind = cek_keydown) then begin
  with info.keyeventinfopo^ do begin
   if (shiftstate = [ss_ctrl]) and 
        (key >= key_0) and (key <= key_9) then begin
    if sourcefo.findbookmark(ord(key) - ord(key_0)) then begin 
     include(eventstate,es_processed);
    end;    
   end
   else begin
    if (shiftstate = [ss_ctrl,ss_shift]) and 
         (keynomod >= key_0) and (keynomod <= key_9) then begin
     sourcefo.setbookmark(self,info.cell.row,ord(keynomod) - ord(key_0));
     include(eventstate,es_processed);
    end;
   end;     
  end;
 end;
end;

function tsourcepage.findbookmark(const bookmarknum: integer): integer;
var
 int1,int2,int3: integer;
 po1: pintegeraty;
begin
 result:= -1;
 for int3:= 0 to high(finitialbookmarks) do begin
  if finitialbookmarks[int3].bookmarknum = bookmarknum then begin
   loadfile;
   po1:= dataicon.griddata.datapo;
   int2:= 1 shl (bookmarknum + bmbitshift);
   for int1:= 0 to grid.rowcount - 1 do begin
    if po1^[int1] and bmbitmask = int2 then begin
     result:= int1;
     break;
    end;
   end;
  end;
 end;
end;

procedure tsourcepage.removebookmark(const bookmarknum: integer);
var
 int1: integer;
begin
 for int1:= high(finitialbookmarks) downto 0 do begin
  if finitialbookmarks[int1].bookmarknum = bookmarknum then begin
   deleteitem(finitialbookmarks,typeinfo(bookmarkarty),int1);
  end;
 end;
end;

procedure tsourcepage.setbookmark(arow: integer; const bookmarknum: integer);
             //arow -1 -> current row, bookmarknum < 1 -> clear
begin
 if arow < 0 then begin
  arow:= grid.row;
 end;
 if arow >= 0 then begin
  if bookmarknum < 0 then begin
   dataicon[arow]:= dataicon[arow] and not bmbitmask;
   removebookmark(bookmarknum);
  end
  else begin   
   dataicon[arow]:= replacebits(cardinal(1 shl (bookmarknum + bmbitshift)),
                                cardinal(dataicon[arow]),cardinal(bmbitmask));
   setlength(finitialbookmarks,high(finitialbookmarks)+2);
   finitialbookmarks[high(finitialbookmarks)].bookmarknum:= bookmarknum;
  end;
 end;
end;

procedure tsourcepage.clearbookmark(const bookmarknum: integer);
var
 int1,int2: integer;
 po1: pintegeraty;
begin
 removebookmark(bookmarknum);
 po1:= dataicon.griddata.datapo;
 int2:= 1 shl (bookmarknum + bmbitshift);
 for int1:= 0 to grid.rowcount - 1 do begin
  if po1^[int1] and bmbitmask = int2 then begin
   dataicon[int1]:= po1^[int1] and not bmbitmask;
  end;
 end;
end;

function tsourcepage.getbookmarks: bookmarkarty;
var
 int1,int2: integer;
 po1: pintegeraty;
 lwo1: longword;
begin
 if not fileloaded then begin
  result:= copy(finitialbookmarks);
 end
 else begin
  po1:= dataicon.griddata.datapo;
  int2:= 0;
  result:= nil;
  for int1:= 0 to grid.rowcount - 1 do begin
   lwo1:= po1^[int1] and bmbitmask;
   if lwo1 <> 0 then begin
    additem(result,typeinfo(bookmarkarty),int2);
    with result[int2-1] do begin
     row:= int1;
     bookmarknum:= lowestbit(lwo1) - bmbitshift;
    end;
   end;
  end;
  setlength(result,int2);
 end;
end;

procedure tsourcepage.setbackupcreated;
begin
 fbackupcreated:= true;
end;

procedure tsourcepage.editonkeydown(const sender: twidget;
                                                   var info: keyeventinfoty);
begin
 with info,tsyntaxedit(sender).editor,projectoptions do begin
  if spacetabs and (tabstops > 0) and (shiftstate = []) and 
                                             (key = key_tab) then begin
   chars:= charstring(' ',(curindex div tabstops + 1) * tabstops - curindex);
  end;
 end;
end;

procedure tsourcepage.clearbrackets;
begin
 if (fbracket1.col >= 0) and (fbracketsetting = 0) then begin
  inc(fbracketsetting);
  try
   with edit do begin
    setfontstyle(fbracket1,makegridcoord(fbracket1.col+1,fbracket1.row),
                                   fs_bold,false);
    setfontstyle(fbracket2,makegridcoord(fbracket2.col+1,fbracket2.row),
                                   fs_bold,false);
    refreshsyntax(fbracket1.row,1);
    refreshsyntax(fbracket2.row,1);
    fbracket1:= invalidcell;
    fbracket2:= invalidcell;
    if syntaxpainterhandle >= 0 then begin
     syntaxpainter.boldchars[syntaxpainterhandle]:= nil;
    end;
   end;
  finally
   dec(fbracketsetting);
  end;
 end;  
end;

procedure tsourcepage.checkbrackets;
var
 mch1: msechar;
 br1: bracketkindty;
 open: boolean;
 pt1,pt2: gridcoordty;
 ar1: gridcoordarty;
begin
 clearbrackets;
 pt2:= invalidcell;
 with edit do begin
  pt1:= editpos;
  mch1:= charatpos(pt1);
  br1:= checkbracketkind(mch1,open);
  if br1 <> bki_none then begin
   pt2:= matchbracket(pt1,br1,open);
  end
  else begin
   dec(pt1.col);
   if pt1.col >= 0 then begin
    mch1:= charatpos(pt1);
    br1:= checkbracketkind(mch1,open);
    if br1 <> bki_none then begin
     pt2:= matchbracket(pt1,br1,open);
    end;
   end;
  end;
  if pt2.col >= 0 then begin
   fbracket1:= pt1;
   fbracket2:= pt2;
   inc(fbracketsetting);
   try
    setfontstyle(pt1,makegridcoord(pt1.col+1,pt1.row),fs_bold,true);
    setfontstyle(pt2,makegridcoord(pt2.col+1,pt2.row),fs_bold,true);
   finally
    dec(fbracketsetting);
   end;
   if syntaxpainterhandle >= 0 then begin
    setlength(ar1,2);
    ar1[0]:= fbracket1;
    ar1[1]:= fbracket2;
    syntaxpainter.boldchars[syntaxpainterhandle]:= ar1;
    refreshsyntax(fbracket1.row,1);
    refreshsyntax(fbracket2.row,1);
   end;
  end;
 end;
end;

procedure tsourcepage.callcheckbrackets;
begin
 if (fbracketchecking = 0) and (projectoptions.editmarkbrackets) then begin
  inc(fbracketchecking);
  asyncevent(ord(spat_checkbracket));
 end;
end;

function tsourcepage.source: trichstringdatalist;
begin
 result:= edit.datalist;
end;

end.

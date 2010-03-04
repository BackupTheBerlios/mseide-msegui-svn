{ MSEgui Copyright (c) 1999-2010 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit mseactions;
{$ifdef FPC}
 {$ifndef mse_no_ifi}
  {$define mse_with_ifi}
 {$endif}
 {$mode objfpc}{$h+}
{$endif}
interface
uses
 classes,mseact,mseglob,mseguiglob,msegui,mseevent,mseclasses,msebitmap,
 msekeyboard,msetypes,msestrings,msearrayprops,msestatfile,msestat;

type
 sysshortcutty = (sho_copy,sho_paste,sho_cut,
                  sho_rowinsert,sho_rowappend,sho_rowdelete);
 sysshortcutaty = array[sysshortcutty] of shortcutty;
 psysshortcutaty = ^sysshortcutaty;
 
 taction = class(tcustomaction,iimagelistinfo,iactionlink)
  private
//   fmultishortcut: integer; //0 = none, 1 = shortcut, 2 = shortcut1
//   fmultiindex: integer;   //index of current checked char
   procedure setimagelist(const Value: timagelist);
   function getshortcut: shortcutty;
   procedure setshortcut(const avalue: shortcutty);
   function getshortcut1: shortcutty;
   procedure setshortcut1(const avalue: shortcutty);
   procedure setshortcuts(const avalue: shortcutarty);
   procedure setshortcuts1(const avalue: shortcutarty);
   procedure readshortcut(reader: treader);
   procedure readshortcut1(reader: treader);
   procedure readsc(reader: treader);
   procedure writesc(writer: twriter);
   procedure readsc1(reader: treader);
   procedure writesc1(writer: twriter);
  //iimagelistinfo
   function getimagelist: timagelist;
  //iactionlink
   function getactioninfopo: pactioninfoty;
   procedure actionchanged;
   function shortcutseparator: msechar;
   procedure calccaptiontext(var ainfo: actioninfoty);
  protected
   procedure registeronshortcut(const avalue: boolean); override;
   procedure doshortcut(const sender: twidget; var keyinfo: keyeventinfoty);
   procedure doafterunlink; override;
   procedure defineproperties(filer: tfiler); override;
  public
//   destructor destroy; override;
   property shortcuts: shortcutarty read finfo.shortcut write setshortcuts;
   property shortcuts1: shortcutarty read finfo.shortcut1 write setshortcuts1;
  published
   property imagelist: timagelist read getimagelist write setimagelist;
   property shortcut: shortcutty read getshortcut write setshortcut
                                stored false default ord(key_none) ;
   property shortcut1: shortcutty read getshortcut1 write setshortcut1
                                 stored false default ord(key_none);
   property caption;
   property state;
   property group;
   property tagaction;
   property imagenr;
   property imagenrdisabled;
   property colorglyph;
   property color;
   property imagecheckedoffset;
   property hint;
   property statfile;
   property statvarname;
   property options;
   property onexecute;
   property onexecuteaction;
   property onupdate;
   property onchange;
   property onasyncevent;
{$ifdef mse_with_ifi}
   property ifilink;
{$endif}
 end;

 tshortcutaction = class(townedeventpersistent,iactionlink)
  private
   finfo: actioninfoty; //as interface to shortcut propertyeditor
   faction: taction;
//   fshortcutsdefault: shortcutarty;
//   fshortcuts1default: shortcutarty;
   fdispname: msestring;
//   fhint: msestring;
   procedure setaction(const avalue: taction);
   procedure readsc(reader: treader);
   procedure writesc(writer: twriter);
   procedure readsc1(reader: treader);
   procedure writesc1(writer: twriter);
   procedure readshortcut(reader: treader);
   procedure readshortcut1(reader: treader);
   procedure setshortcuts(const avalue: shortcutarty);
   procedure setshortcuts1(const avalue: shortcutarty);
  //iactionlink
   function getactioninfopo: pactioninfoty;
  procedure actionchanged;
  function loading: boolean;
  function shortcutseparator: msechar;
  procedure calccaptiontext(var ainfo: actioninfoty);

  protected
   function getshortcutdefault: shortcutty;
   procedure setshortcutdefault(const avalue: shortcutty);
   function getshortcut1default: shortcutty;
   procedure setshortcut1default(const avalue: shortcutty);
   procedure defineproperties(filer: tfiler); override;
  public
   property shortcutsdefault: shortcutarty read finfo.shortcut
                                           write setshortcuts;
   property shortcuts1default: shortcutarty read finfo.shortcut1 
                                           write setshortcuts1;
  published
   property action: taction read faction write setaction;
   property shortcutdefault: shortcutty read getshortcutdefault 
                                        write setshortcutdefault
                                                 stored false default 0;
   property shortcut1default: shortcutty read getshortcut1default 
                                        write setshortcut1default 
                                                 stored false default 0;
   property dispname: msestring read fdispname write fdispname;
   property hint: msestring read finfo.hint write finfo.hint;
 end;

 type
  shortcutrecarty = array of 
                     record 
                      name: string;
                      value: integer;
                     end;

 tshortcutcontroller = class;
 tshortcutactions = class(townedeventpersistentarrayprop)
  private
  protected
   function getitems(const index: integer): tshortcutaction;
  public
   constructor create(const aowner: tshortcutcontroller); reintroduce;
   class function getitemclasstype: persistentclassty; override;
  public
   property items[const index: integer]: tshortcutaction read getitems;
                                                   default;
 end;

 tsysshortcuts = class(tintegerarrayprop)
  private
   fowner: tcomponent;
   fdatapo: psysshortcutaty;
   fshortcuts: shortcutrecarty;
   function getitems(const index: sysshortcutty): shortcutty;
   procedure setitems(const index: sysshortcutty; const avalue: shortcutty);
   function getshortcutrecord(const index: integer): msestring;
   procedure setshortcutcount(const acount: integer);
   procedure setshortcutrecord(const index: integer; const avalue: msestring);
  protected
   procedure setfixcount(const avalue: integer); override;
   procedure dochange(const aindex: integer); override;
   procedure dostatread(const varname: string; const reader: tstatreader);
   procedure dostatwrite(const varname: string; const writer: tstatwriter);
  public
   constructor create(const aowner: tcomponent; const adatapo: psysshortcutaty);
   property items[const index: sysshortcutty]: shortcutty read getitems 
                       write setitems; default;
 end;
 
 shortcutstatinfoty = record
  name: ansistring;
  shortcut: shortcutarty;
  shortcut1: shortcutarty;
 end;
 shortcutstatinfoarty = array of shortcutstatinfoty;
 shortcutcontrollereventty = procedure(
                        const sender: tshortcutcontroller) of object;   
 tshortcutcontroller = class(tmsecomponent,istatfile)
  private
   factions: tshortcutactions;
   fstatfile: tstatfile;
   fstatvarname: msestring;
   fstatinfos: shortcutstatinfoarty;
   fsysshortcuts: tsysshortcuts;
   fsysshortcuts1: tsysshortcuts;
   fonafterupdate: shortcutcontrollereventty;
   procedure setactions(const avalue: tshortcutactions);
   procedure setstatfile(const avalue: tstatfile);
   function getactionrecord(const index: integer): msestring;
   procedure setactionreccount(const acount: integer);
   procedure setactionrecord(const index: integer; const avalue: msestring);
   procedure setsysshortcuts(const avalue: tsysshortcuts);
   procedure setsysshortcuts1(const avalue: tsysshortcuts);
  protected
   procedure updateaction(const aaction: taction); reintroduce;
   //istatfile
   procedure dostatread(const reader: tstatreader); virtual;
   procedure dostatwrite(const writer: tstatwriter); virtual;
   procedure statreading;
   procedure statread;
   function getstatvarname: msestring;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   procedure doafterupdate;
  published
   property actions: tshortcutactions read factions write setactions;
   property sysshortcuts: tsysshortcuts read fsysshortcuts write setsysshortcuts;
   property sysshortcuts1: tsysshortcuts read fsysshortcuts1 write setsysshortcuts1;
   property statfile: tstatfile read fstatfile write setstatfile;
   property statvarname: msestring read getstatvarname write fstatvarname;
   property onafterupdate: shortcutcontrollereventty read fonafterupdate 
                                write fonafterupdate;
 end;

 tcustomhelpcontroller = class;
 helpcontrollereventty = procedure(const sender: tcustomhelpcontroller;
          const helpsender: tmsecomponent; var handled: boolean) of object;
 helpcontrollerprocty = procedure(const sender: tcustomhelpcontroller;
          const helpsender: tmsecomponent; var handled: boolean);
                          
 tcustomhelpcontroller = class(tmsecomponent)
  private
   fonhelp: helpcontrollereventty;
   fonhelp1: helpcontrollerprocty;
  protected
   procedure dohelp(const sender: tmsecomponent; var handled: boolean); virtual;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   property onhelp: helpcontrollereventty read fonhelp write fonhelp;
   property onhelp1: helpcontrollerprocty read fonhelp1 write fonhelp1;
 end;

 thelpcontroller = class(tcustomhelpcontroller)
  published 
   property onhelp;
 end;

function issameshortcut(const a,b: shortcutarty): boolean;
function getsimpleshortcut(const asource: shortcutarty): shortcutty; overload;
function getsimpleshortcut(const asource: actioninfoty): shortcutty; overload;
function getsimpleshortcut1(const asource: actioninfoty): shortcutty;
function setsimpleshortcut(const avalue: shortcutty): shortcutarty; overload;
procedure setsimpleshortcut(const avalue: shortcutty;
                                          var adest: shortcutarty); overload;
procedure setsimpleshortcut(const avalue: shortcutty;
                                          var adest: actioninfoty); overload;
procedure setsimpleshortcut1(const avalue: shortcutty; var adest: actioninfoty);
function checkshortcutconflict(const a,b: shortcutarty): boolean;

procedure setactionshortcuts(const sender: iactionlink; const value: shortcutarty);
procedure setactionshortcuts1(const sender: iactionlink; const value: shortcutarty);
procedure setactionshortcut(const sender: iactionlink; const value: shortcutty);
procedure setactionshortcut1(const sender: iactionlink; const value: shortcutty);
function isactionshortcutstored(const info: actioninfoty): boolean;
function isactionshortcut1stored(const info: actioninfoty): boolean;
procedure setactionimagelist(const sender: iactionlink; const value: timagelist);
function isactionimageliststored(const info: actioninfoty): boolean;
 
procedure getshortcutlist(out keys: integerarty; out names: msestringarty);
//function getshortcutname(key: shortcutarty): msestring;
function getsysshortcutdispname(const aitem: sysshortcutty): msestring;

function isvalidshortcut(const ashortcut: shortcutty): boolean;
function encodeshortcutname(const key: shortcutarty): msestring; overload;
function encodeshortcutname(const key: shortcutty): msestring; overload;
function checkshortcutcode(const shortcut: shortcutty;
                    const info: keyeventinfoty;
                    const apreview: boolean = false): boolean; overload;
function checkshortcutcode(const shortcut: shortcutty;
          const info: keyinfoty): boolean; overload;
function doactionshortcut(const sender: tobject; var info: actioninfoty;
                        var keyinfo: keyeventinfoty): boolean; 
                        //true if executed
procedure calccaptiontext(var info: actioninfoty; const aseparator: msechar);
function issysshortcut(const ashortcut: sysshortcutty;
                                  const ainfo: keyeventinfoty): boolean;
const
 shift = ord(key_modshift);
 ctrl = ord(key_modctrl);
 alt = ord(key_modalt);
 modmask = shift or ctrl or alt;

 defaultsysshortcuts: sysshortcutaty = 
//sho_copy,            sho_paste,                 sho_cut,   
 (ctrl+ord(key_c),     ctrl+ord(key_v),           ctrl+ord(key_x),
//sho_rowinsert,       sho_rowappend,             sho_rowdelete
  ctrl+ord(key_insert),shift+ctrl+ord(key_insert),ctrl+ord(key_delete));

 defaultsysshortcuts1: sysshortcutaty = 
//sho_copy,            sho_paste,                 sho_cut,   
 (ord(key_none),       shift+ord(key_insert),     shift+ord(key_delete),
//sho_rowinsert,       sho_rowappend,             sho_rowdelete
  ord(key_none),       ord(key_none),             ord(key_none));
var
 sysshortcuts: sysshortcutaty;
 sysshortcuts1: sysshortcutaty;
implementation
uses
 sysutils,mserichstring,msestream,typinfo,mseformatstr,msestreaming;
 
const   
 letterkeycount = ord('z') - ord('a') + 1;
 cipherkeycount = ord('9') - ord('0') + 1;
 functionkeycount = 12;
 misckeycount = ord(key_sysreq) - ord(key_escape) + 1;
 cursorkeycount = ord(key_pagedown) - ord(key_home) + 1;
 specialshortcutcount = ord(high(specialshortcutty))+1;
 specialkeycount = misckeycount + specialshortcutcount + cursorkeycount;
{
 shortcutcount = (letterkeycount + cipherkeycount) * 2 + //ctrl,shiftctrl
                 3 + //space
                 functionkeycount * 4 +              //none,shift,ctrl,shiftctrl
                 specialkeycount * 4;                //none,shift,ctrl,shiftctrl
}
 baseshortcutcount = letterkeycount + cipherkeycount + 1 + //Space
                     functionkeycount + specialkeycount;
 shortcutcount = 4 * baseshortcutcount; //none,shift,ctrl,shift+ctrl

var
 shortcutkeys: integerarty;
 shortcutnames: msestringarty;
 baseshortcutkeys: integerarty;
 baseshortcutnames: msestringarty;

function issysshortcut(const ashortcut: sysshortcutty;
                                 const ainfo: keyeventinfoty): boolean;
begin
 result:= checkshortcutcode(sysshortcuts[ashortcut],ainfo) or
                           checkshortcutcode(sysshortcuts1[ashortcut],ainfo);
end;

procedure getvalues(var bottom: integer; prefix: msestring;
            const modvalue: integer; var keys: integerarty; 
            var names: msestringarty);
var
 int1: integer;
 akey: keyty;
begin
 keys[bottom]:= ord(key_space) + modvalue;
 names[bottom]:= prefix+spacekeyname;
 inc(bottom);
 for int1:= bottom to bottom+cipherkeycount-1 do begin
  keys[int1]:= ord(key_0) + int1-bottom + modvalue;
  names[int1]:= prefix+msestring(msechar(int1-bottom+ord('0')));
 end;
 bottom:= bottom + cipherkeycount;
 for int1:= bottom to bottom+letterkeycount-1 do begin
  keys[int1]:= ord(key_a) + int1-bottom + modvalue;
  names[int1]:= prefix+msestring(msechar(int1-bottom+ord('A')));
 end;
 bottom:= bottom + letterkeycount;
 for int1:= bottom to bottom + functionkeycount - 1 do begin
  keys[int1]:= (ord(key_f1) + int1-bottom) or modvalue;
  names[int1]:= prefix+'F'+inttostr(int1-bottom+1);
 end;
 bottom:= bottom+functionkeycount;
 for int1:= bottom to bottom+misckeycount-1 do begin
  akey:= keyty(ord(key_escape) + int1-bottom);
  keys[int1]:= ord(akey)or modvalue;
  names[int1]:= prefix+shortmisckeynames[akey];
 end;
 bottom:= bottom+misckeycount;
 for int1:= bottom to bottom+specialshortcutcount-1 do begin
  keys[int1]:= ord(specialkeys[specialshortcutty(int1-bottom)]) or modvalue;
  names[int1]:= prefix+specialkeynames[specialshortcutty(int1-bottom)];
 end;
 bottom:= bottom+specialshortcutcount;
 for int1:= bottom to bottom+cursorkeycount-1 do begin
  akey:= keyty(ord(key_home) + int1-bottom);
  keys[int1]:= ord(akey)or modvalue;
  names[int1]:= prefix+shortcursorkeynames[akey];
 end;
 bottom:= bottom+cursorkeycount;
end;

procedure getshortcutlist(out keys: integerarty; out names: msestringarty);
var
 int1: integer;
 bo1: boolean;
 bottom: integer;
 akey: keyty;
begin
 bo1:= false;
 if shortcutkeys = nil then begin
  setlength(shortcutkeys,shortcutcount);
  bo1:= true;
 end;
 if shortcutnames = nil then begin
  setlength(shortcutnames,shortcutcount);
  bo1:= true;
 end;
 keys:= shortcutkeys;
 names:= shortcutnames;
 if bo1 then begin
  bottom:= 0;
{
  for int1:= bottom to bottom + functionkeycount - 1 do begin
   keys[int1]:= ord(key_f1) + int1-bottom;
   names[int1]:= 'F'+inttostr(int1-bottom+1);
  end;
  bottom:= bottom+functionkeycount;
  for int1:= bottom to bottom+misckeycount-1 do begin
   akey:= keyty(ord(key_escape) + int1-bottom);
   keys[int1]:= ord(akey);
   names[int1]:= shortmisckeynames[akey];
  end;
  bottom:= bottom+misckeycount;
  for int1:= bottom to bottom+specialshortcutcount-1 do begin
   keys[int1]:= ord(specialkeys[specialshortcutty(int1-bottom)]);
   names[int1]:= specialkeynames[specialshortcutty(int1-bottom)];
  end;
  for int1:= bottom to bottom+cursorkeycount-1 do begin
   akey:= keyty(ord(key_home) + int1-bottom);
   keys[int1]:= ord(akey);
   names[int1]:= shortcursorkeynames[akey];
  end;
  bottom:= bottom+cursorkeycount;
  for int1:= bottom to bottom + functionkeycount - 1 do begin
   keys[int1]:= (ord(key_f1) + int1-bottom) or key_modshift;
   names[int1]:= 'Shift+F'+inttostr(int1-bottom+1);
  end;
  bottom:= bottom+functionkeycount;
  keys[bottom]:= ord(key_space) or key_modshift;
  names[bottom]:= 'Shift+'+spacekeyname;
  inc(bottom);
  for int1:= bottom to bottom+misckeycount-1 do begin
   akey:= keyty(ord(key_escape) + int1-bottom);
   keys[int1]:= ord(akey)or key_modshift;
   names[int1]:= 'Shift+'+shortmisckeynames[akey];
  end;
  bottom:= bottom+misckeycount;
  for int1:= bottom to bottom+specialshortcutcount-1 do begin
   keys[int1]:= ord(specialkeys[specialshortcutty(int1-bottom)]) or key_modshift;
   names[int1]:= 'Shift+'+specialkeynames[specialshortcutty(int1-bottom)];
  end;
  bottom:= bottom+specialshortcutcount;
  for int1:= bottom to bottom+cursorkeycount-1 do begin
   akey:= keyty(ord(key_home) + int1-bottom);
   keys[int1]:= ord(akey)or key_modshift;
   names[int1]:= 'Shift+'+shortcursorkeynames[akey];
  end;
  bottom:= bottom+cursorkeycount;
}
  getvalues(bottom,'',0,keys,names);
  getvalues(bottom,'Shift+',key_modshift,keys,names);
  getvalues(bottom,'Ctrl+',key_modctrl,keys,names);
  getvalues(bottom,'Shift+Ctrl+',key_modshiftctrl,keys,names);
 end;
end;
{
function getshortcutname(key: shortcutarty): msestring;
var
 keys: integerarty;
 names: msestringarty;
 int1,int2,int3: integer;
begin
 result:= '';
 if high(key) >= 0 then begin
  getshortcutlist(keys,names);
  for int3:= 0 to high(key) do begin
   int2:= key[int3];
   for int1:= 0 to high(keys) do begin
    if keys[int1] = int2 then begin
     result:= result + names[int1] + ' ';
     break;
    end;
   end;
  end;
  if result <> '' then begin
   setlength(result,length(result)-1);
  end;
 end;
end;
}
//todo: internationalize
function getsysshortcutdispname(const aitem: sysshortcutty): msestring;
const
 list: array[sysshortcutty] of msestring = (
        'Copy','Paste','Cut','Row insert','Row append','Row delete');
begin
 result:= list[aitem];
end;

function isnormalkey(const akey: shortcutty): boolean;
begin
 result:= (akey >= ord(key_0)) and (akey <= ord(key_9)) or
          (akey >= ord(key_a)) and (akey <= ord(key_z)) or
          (akey = ord(key_left)) or
          (akey = ord(key_right)) or
          (akey = ord(key_up)) or
          (akey = ord(key_down)) or
          (akey = ord(key_tab)) or
          (akey = ord(key_space)) or
          (akey = ord(key_return)) or
          (akey = ord(key_enter));
end;

function isnormalshiftkey(const akey: shortcutty): boolean;
begin
 result:= (akey >= ord(key_0)) and (akey <= ord(key_9)) or
          (akey >= ord(key_a)) and (akey <= ord(key_z)) or
          (akey = ord(key_tab));
end;

function isvalidshortcut(const ashortcut: shortcutty): boolean;
var
 key: word;
begin
 key:= ashortcut and not modmask;
 result:= key <> 0;
 if result then begin
  if ashortcut and modmask = 0 then begin
   result:= not isnormalkey(key);
  end
  else begin
   if ashortcut and modmask = shift then begin
    result:= not isnormalshiftkey(key);
   end;
  end;
 end;
end;

function encodeshortcutname(const key: shortcutty): msestring;
var
 bo1: boolean;
 int1: integer;
 k1: shortcutty;
 mstr1: msestring;
begin
 bo1:= false;
 if baseshortcutkeys = nil then begin
  setlength(baseshortcutkeys,baseshortcutcount);
  bo1:= true;
 end;
 if baseshortcutnames = nil then begin
  setlength(baseshortcutnames,baseshortcutcount);
  bo1:= true;
 end;
 if bo1 then begin
  int1:= 0;
  getvalues(int1,'',0,baseshortcutkeys,baseshortcutnames);
  {
  for int1:= 0 to high(baseshortcutnames) do begin
   baseshortcutnames[int1]:= copy(baseshortcutnames[int1],2,bigint);
           //remove '+'
  end;
  }
 end;
 k1:= key and not modmask;
 mstr1:= '';
 for int1:= 0 to high(baseshortcutkeys) do begin
  if baseshortcutkeys[int1] = k1 then begin
   mstr1:= baseshortcutnames[int1];
   break;
  end;
 end;
 if mstr1 = '' then begin
  if key = 0 then begin
   result:= '';
  end
  else begin
   result:= '$'+hextostr(key,4);
  end;
 end
 else begin
  result:= '';
  if (key and shift) <> 0 then begin
   result:= result + 'Shift+';
  end;
  if (key and alt) <> 0 then begin
   result:= result + 'Alt+';
  end;
  if (key and ctrl) <> 0 then begin
   result:= result + 'Ctrl+';
  end;
  result:= result + mstr1;
 end;
end;

function encodeshortcutname(const key: shortcutarty): msestring;
var
 int1: integer;
begin
 result:= '';
 if high(key) >= 0 then begin
  for int1:= 0 to high(key) do begin
   result:= result + encodeshortcutname(key[int1]) + ' ';
  end;
  setlength(result,length(result)-1);
 end;
end;

procedure calccaptiontext(var info: actioninfoty; const aseparator: msechar);
var
 str1: msestring;
begin
 str1:= info.captiontext;
 if (info.shortcut <> nil) and (mao_shortcutcaption in info.options) then begin
  str1:= str1 + aseparator + '('+encodeshortcutname(info.shortcut)+')';
 end;
 captiontorichstring(str1,info.caption1);
end;

function issameshortcut(const a,b: shortcutarty): boolean;
var
 int1: integer;
begin
 result:= (a = b);
 if not result then begin 
  result:=  high(a) = high(b);
  if result then begin
   for int1:= 0 to high(a) do begin
    if a[int1] <> b[int1] then begin
     result:= false;
     break;
    end;
   end;
  end;
 end;
end;

function getsimpleshortcut(const asource: shortcutarty): shortcutty;
begin
 result:= 0;
 if asource <> nil then begin
  result:= asource[0];
 end;
end;
   
function getsimpleshortcut(const asource: actioninfoty): shortcutty;
begin
 result:= 0;
 if asource.shortcut <> nil then begin
  result:= asource.shortcut[0];
 end;
end;

function getsimpleshortcut1(const asource: actioninfoty): shortcutty;
begin
 result:= 0;
 if asource.shortcut1 <> nil then begin
  result:= asource.shortcut1[0];
 end;
end;

procedure setsimpleshortcut(const avalue: shortcutty; var adest: shortcutarty);
begin
 if avalue = 0 then begin
  adest:= nil;
 end
 else begin
  setlength(adest,1);
  adest[0]:= avalue;
 end;
end;

function setsimpleshortcut(const avalue: shortcutty): shortcutarty;
begin
 setsimpleshortcut(avalue,result);
end;

procedure setsimpleshortcut(const avalue: shortcutty; var adest: actioninfoty);
begin
 if avalue = 0 then begin
  adest.shortcut:= nil;
 end
 else begin
  setlength(adest.shortcut,1);
  adest.shortcut[0]:= avalue;
 end;
end;

procedure setsimpleshortcut1(const avalue: shortcutty; var adest: actioninfoty);
begin
 if avalue = 0 then begin
  adest.shortcut1:= nil;
 end
 else begin
  setlength(adest.shortcut1,1);
  adest.shortcut1[0]:= avalue;
 end;
end;

function checkshortcutconflict(const a,b: shortcutarty): boolean;
 function pos1(const sub,checked:shortcutarty): boolean;
 var
  int1,int2: integer;
 begin
  result:= sub <> nil;
  if result then begin
   result:= sub = checked;
   if not result and (high(checked) >= high(sub)) then begin
    for int1:= 0 to high(checked) - high(sub) do begin
     if checked[int1] = sub[0] then begin
      result:= true;
      for int2:= 1 to high(sub) do begin
       if checked[int1+int2] <> sub[int2] then begin
        result:= false;
        break;
       end;
      end;
      if result then begin
       break;
      end;
     end;
    end;
   end;
  end;
 end; //pos1
begin
 result:= pos1(a,b) or pos1(b,a);
end;

procedure setactionshortcut(const sender: iactionlink; const value: shortcutty);
var
 po1: pactioninfoty;
begin
 po1:= sender.getactioninfopo;
 setsimpleshortcut(value,po1^);
 include(po1^.state,as_localshortcut);
 calccaptiontext(po1^,sender.shortcutseparator);
 sender.actionchanged;
end;

procedure setactionshortcut1(const sender: iactionlink; const value: shortcutty);
var
 po1: pactioninfoty;
begin
 po1:= sender.getactioninfopo;
 setsimpleshortcut1(value,po1^);
 include(po1^.state,as_localshortcut1);
 sender.actionchanged;
end;

procedure setactionshortcuts(const sender: iactionlink;
                                              const value: shortcutarty);
var
 po1: pactioninfoty;
begin
 po1:= sender.getactioninfopo;
 po1^.shortcut:= value;
 include(po1^.state,as_localshortcut);
 calccaptiontext(po1^,sender.shortcutseparator);
 sender.actionchanged;
end;

procedure setactionshortcuts1(const sender: iactionlink;
                                             const value: shortcutarty);
var
 po1: pactioninfoty;
begin
 po1:= sender.getactioninfopo;
 po1^.shortcut1:= value;
 include(po1^.state,as_localshortcut1);
 sender.actionchanged;
end;

function isactionshortcutstored(const info: actioninfoty): boolean;
begin
 with info do begin
  result:= (as_localshortcut in state) and
         not ((action = nil) and (shortcut = nil));
 end;
end;

function isactionshortcut1stored(const info: actioninfoty): boolean;
begin
 with info do begin
  result:= (as_localshortcut1 in state) and
         not ((action = nil) and (shortcut1 = nil));
 end;
end;

procedure setactionimagelist(const sender: iactionlink; const value: timagelist);
begin
 with sender.getactioninfopo^ do begin
  if not (as_localimagelist in state) then begin
   imagelist:= nil; //do not unink,imagelist is owned by action
  end;
  setlinkedcomponent(sender,value,tmsecomponent(imagelist));
  include(state,as_localimagelist);
 end;
 sender.actionchanged;
end;

function isactionimageliststored(const info: actioninfoty): boolean;
begin
 with info do begin
  result:= (as_localimagelist in state) and
         not ((action = nil) and (imagelist = nil));
 end;
end;

function checkshortcutcode(const shortcut: shortcutty;
          const info: keyeventinfoty; const apreview: boolean = false): boolean;
var
 acode: shortcutty;
begin
 result:= false;
 if (shortcut <> 0) and 
                   ((es_preview in info.eventstate) xor not apreview) then begin
  with info do begin
   acode:= 0;
   if ss_shift in shiftstate then begin
    acode:= acode or key_modshift;
   end;
   if ss_ctrl in shiftstate then begin
    acode:= acode or key_modctrl;
   end;
   if ss_alt in shiftstate then begin
    acode:= acode or key_modalt;
   end;
   result:= (acode or ord(key) = shortcut) or 
            (acode or ord(keynomod) = shortcut);
  end;
 end;
end;

function checkshortcutcode(const shortcut: shortcutty;
          const info: keyinfoty): boolean;
var
 acode: shortcutty;
begin
 result:= false;
 if (shortcut <> 0) then begin
  with info do begin
   acode:= 0;
   if ss_shift in shiftstate then begin
    acode:= acode or key_modshift;
   end;
   if ss_ctrl in shiftstate then begin
    acode:= acode or key_modctrl;
   end;
   if ss_alt in shiftstate then begin
    acode:= acode or key_modalt;
   end;
   result:= (acode or ord(key) = shortcut) or 
            (acode or ord(keynomod) = shortcut);
  end;
 end;
end;

function getshortcutcodenomod(const info: keyeventinfoty): shortcutty;
begin
 with info do begin
  result:= ord(info.keynomod);
  if ss_shift in info.shiftstate then begin
   result:= result or key_modshift;
  end;
  if ss_ctrl in info.shiftstate then begin
   result:= result or key_modctrl;
  end;
  if ss_alt in info.shiftstate then begin
   result:= result or key_modalt;
  end;
 end;
end;

{
function doactionshortcut(const sender: tobject; var info: actioninfoty;
                        var keyinfo: keyeventinfoty): boolean;
                          //true if done
var
 key: word;
begin
 result:= false;
 with info do begin
  if not (as_disabled in state) and not (es_processed in keyinfo.eventstate) and 
        (not (ss_repeat in keyinfo.shiftstate) or 
                (as_repeatshortcut in info.state)) then begin
   if high(shortcut) = 0 then begin
    if checkshortcutcode(shortcut[0],keyinfo) then begin
     doactionexecute(sender,info,false,false);
     result:= true;
    end;
   end;
   if not result then begin
    if high(shortcut1) = 0 then begin
     if checkshortcutcode(shortcut1[0],keyinfo) then begin
      doactionexecute(sender,info);
      result:= true;
     end;
    end;
   end;
   if result then begin
    include(keyinfo.eventstate,es_processed);
   end;
  end;
 end;
end;
}

function doactionshortcut(const sender: tobject; var info: actioninfoty;
                        var keyinfo: keyeventinfoty): boolean; //true if done
 function check(const anum: integer; out exec: boolean): boolean;
 var
  ar1: shortcutarty;
  int1,int2,int3: integer;
 begin
  if anum = 2 then begin
   ar1:= info.shortcut1;
  end
  else begin
   ar1:= info.shortcut;
  end;
  result:= false;
  exec:= false;
  if (high(ar1) > 0) and (es_preview in keyinfo.eventstate) then begin
   exec:= true;
   for int1:= high(ar1) downto 0 do begin
    if checkshortcutcode(ar1[int1],keyinfo,true) then begin
     result:= true;
     with application do begin
      if high(keyhistory) >= int1-1 then begin
       int3:= 0;
       if int1 > 0 then begin       
        for int2:= int1 - 1 downto 0 do begin
         if not checkshortcutcode(ar1[int2],keyhistory[int3]) then begin
          result:= false;
          exec:= false;
          break;
         end;
         inc(int3);
        end;
       end
       else begin
        exec:= false;
       end;      
      end
      else begin
       exec:= false;
       result:= false;
      end;
     end;
     if exec then begin
      break;
     end;
    end
    else begin
     exec:= false
    end;
   end;
   if exec then begin
    application.clearkeyhistory;
   end;
  end
  else begin
   if high(ar1) >= 0 then begin
    if checkshortcutcode(ar1[0],keyinfo,false) then begin
     result:= true;
     if high(ar1) = 0 then begin
      exec:= true;
     end;
    end;
   end;
  end;
 end; //check

var
 bo1,bo2: boolean;
begin
 bo1:= check(1,result);
 if not bo1 then begin
  bo1:= check(2,result);
 end;
 if bo1 then begin
  include(keyinfo.eventstate,es_processed);
  if result then begin
   doactionexecute(sender,info,false,false);
//   changed;
  end;
 end;
end;

{ taction }

function taction.getimagelist: timagelist;
begin
 result:= timagelist(finfo.imagelist);
end;

procedure taction.setimagelist(const Value: timagelist);
begin
 if value <> finfo.imagelist then begin
  setlinkedvar(value,tmsecomponent(finfo.imagelist));
  changed;
 end;
end;
{
function taction.getshortcut: shortcutty;
begin
 result:= shortcutty(finfo.shortcut);
end;
}
function taction.getshortcut: shortcutty;
begin
 result:= getsimpleshortcut(finfo);
end;

procedure taction.setshortcut(const avalue: shortcutty);
begin
 setsimpleshortcut(avalue,finfo);
 changed;
end;

function taction.getshortcut1: shortcutty;
begin
 result:= getsimpleshortcut1(finfo);
end;

procedure taction.setshortcut1(const avalue: shortcutty);
begin
 setsimpleshortcut1(avalue,finfo);
 changed;
end;

procedure taction.setshortcuts(const avalue: shortcutarty);
begin
 finfo.shortcut:= avalue;
 changed;
end;

procedure taction.setshortcuts1(const avalue: shortcutarty);
begin
 finfo.shortcut1:= avalue;
 changed;
end;

procedure taction.registeronshortcut(const avalue: boolean);
begin
 if avalue then begin
  application.registeronshortcut({$ifdef FPC}@{$endif}doshortcut);
 end
 else begin
  application.unregisteronshortcut({$ifdef FPC}@{$endif}doshortcut);
 end;
end;

procedure taction.doshortcut(const sender: twidget; var keyinfo: keyeventinfoty);
begin
 if not (es_local in keyinfo.eventstate) and (ao_globalshortcut in foptions) or 
        (es_local in keyinfo.eventstate) and (ao_localshortcut in foptions) and
                (owner <> nil) and issubcomponent(owner,sender) then begin
  doupdate;
  with finfo do begin
   if not (as_disabled in state) and 
            not (es_processed in keyinfo.eventstate) and 
            (not (ss_repeat in keyinfo.shiftstate) or 
                 (as_repeatshortcut in finfo.state)) then begin
    if doactionshortcut(sender,finfo,keyinfo) then begin
     changed;
    end;
   end;
  end;
 end;
end;

(*
procedure taction.doshortcut(const sender: twidget; var keyinfo: keyeventinfoty);

 function check(const anum: integer; out exec: boolean): boolean;
 var
  ar1: shortcutarty;
  int1,int2,int3: integer;
 begin
  if anum = 2 then begin
   ar1:= finfo.shortcut1;
  end
  else begin
   ar1:= finfo.shortcut;
  end;
  result:= false;
  exec:= false;
  if (high(ar1) > 0) and (es_preview in keyinfo.eventstate) then begin
   exec:= true;
   for int1:= high(ar1) downto 0 do begin
    if checkshortcutcode(ar1[int1],keyinfo,true) then begin
     result:= true;
     with application do begin
      if high(keyhistory) >= int1-1 then begin
       int3:= 0;
       if int1 > 0 then begin       
        for int2:= int1 - 1 downto 0 do begin
         if not checkshortcutcode(ar1[int2],keyhistory[int3]) then begin
          result:= false;
          exec:= false;
          break;
         end;
         inc(int3);
        end;
       end
       else begin
        exec:= false;
       end;      
      end
      else begin
       exec:= false;
       result:= false;
      end;
     end;
     if exec then begin
      break;
     end;
    end
    else begin
     exec:= false
    end;
   end;
   if exec then begin
    application.clearkeyhistory;
   end;
  end
  else begin
   if high(ar1) >= 0 then begin
    if checkshortcutcode(ar1[0],keyinfo,false) then begin
     result:= true;
     if high(ar1) = 0 then begin
      exec:= true;
     end;
    end;
   end;
  end;
 end; //check

var
 bo1,bo2: boolean;
begin
 bo1:= false;  
 if not (es_local in keyinfo.eventstate) and (ao_globalshortcut in foptions) or 
        (es_local in keyinfo.eventstate) and (ao_localshortcut in foptions) and
                (owner <> nil) and issubcomponent(owner,sender) then begin
  doupdate;
  with finfo do begin
   if not (as_disabled in state) and 
            not (es_processed in keyinfo.eventstate) and 
            (not (ss_repeat in keyinfo.shiftstate) or 
                 (as_repeatshortcut in finfo.state)) then begin
    bo1:= check(1,bo2);
    if not bo1 then begin
     bo1:= check(2,bo2);
    end;
   end;
  end;
 end;
 if bo1 then begin
  include(keyinfo.eventstate,es_processed);
  if bo2 then begin
   doactionexecute(sender,finfo,false,false);
   changed;
  end;
 end;
end;
*)
procedure taction.doafterunlink;
begin
 imagelist:= nil;
end;

procedure taction.readshortcut(reader: treader);
begin
 shortcut:= reader.readinteger;
end;

procedure taction.readshortcut1(reader: treader);
begin
 shortcut1:= reader.readinteger;
end;

procedure taction.readsc(reader: treader);
begin
 shortcuts:= readshortcutarty(reader);
end;

procedure taction.writesc(writer: twriter);
begin
 writeshortcutarty(writer,finfo.shortcut);
end;

procedure taction.readsc1(reader: treader);
begin
 shortcuts1:= readshortcutarty(reader);
end;

procedure taction.writesc1(writer: twriter);
begin
 writeshortcutarty(writer,finfo.shortcut1);
end;

procedure taction.defineproperties(filer: tfiler);
begin
 inherited;
 filer.defineproperty('shortcut',{$ifdef FPC}@{$endif}readshortcut,nil,false);
 filer.defineproperty('shortcut1',{$ifdef FPC}@{$endif}readshortcut1,nil,false);
 filer.defineproperty('sc',{$ifdef FPC}@{$endif}readsc,
                           {$ifdef FPC}@{$endif}writesc,
       (filer.ancestor = nil) and (shortcuts <> nil) or
       ((filer.ancestor <> nil) and 
         not issameshortcut(shortcuts,taction(filer.ancestor).shortcuts)));
 filer.defineproperty('sc1',{$ifdef FPC}@{$endif}readsc1,
                           {$ifdef FPC}@{$endif}writesc1,
       (filer.ancestor = nil) and (shortcuts1 <> nil) or
       ((filer.ancestor <> nil) and 
         not issameshortcut(shortcuts1,taction(filer.ancestor).shortcuts1)));
end;

function taction.getactioninfopo: pactioninfoty;
begin
 result:= @finfo;
end;

procedure taction.actionchanged;
begin
 changed;
end;

function taction.shortcutseparator: msechar;
begin
 result:= ' ';
end;

procedure taction.calccaptiontext(var ainfo: actioninfoty);
begin
 //dummy
end;

{ tshortcutactions }

constructor tshortcutactions.create(const aowner: tshortcutcontroller);
begin
 inherited create(aowner,tshortcutaction);
end;

class function tshortcutactions.getitemclasstype: persistentclassty;
begin
 result:= tshortcutaction;
end;

function tshortcutactions.getitems(const index: integer): tshortcutaction;
begin
 result:= tshortcutaction(inherited getitems(index));
end;

{ tshortcutcontroller }

constructor tshortcutcontroller.create(aowner: tcomponent);
begin
 factions:= tshortcutactions.create(self);
 fsysshortcuts:= tsysshortcuts.create(self,@mseactions.sysshortcuts);
 fsysshortcuts1:= tsysshortcuts.create(self,@mseactions.sysshortcuts1);
 inherited;
end;

destructor tshortcutcontroller.destroy;
begin
 inherited;
 factions.free;
 fsysshortcuts.free;
 fsysshortcuts1.free;
end;

procedure tshortcutcontroller.setactions(const avalue: tshortcutactions);
begin
 factions.assign(avalue);
end;

procedure tshortcutcontroller.setstatfile(const avalue: tstatfile);
begin
 setstatfilevar(istatfile(self),avalue,fstatfile);
end;

procedure tshortcutcontroller.setactionreccount(const acount: integer);
begin
 fstatinfos:= nil;
 setlength(fstatinfos,acount);
end;

procedure tshortcutcontroller.setactionrecord(const index: integer;
               const avalue: msestring);
var
 ar1: msestringarty;
 int1,int2: integer;
begin
 ar1:= splitstring(avalue, msechar(' '));
 with fstatinfos[index] do begin
  if high(ar1) >= 0 then begin
   name:= ar1[0];
   setlength(shortcut,high(ar1) div 2); 
   setlength(shortcut1,length(shortcut));
             //backward compatibilty with single shortcut
   int2:= 1;
   for int1:= 0 to high(shortcut) do begin
    shortcut[int1]:= strtoint(ar1[int2]);
    inc(int2);
    shortcut1[int1]:= strtoint(ar1[int2]);
   end;
   for int1:= 0 to high(shortcut) do begin
    if shortcut[int1] = 0 then begin
     setlength(shortcut,int1);
     break;
    end;
   end;
   for int1:= 0 to high(shortcut1) do begin
    if shortcut1[int1] = 0 then begin
     setlength(shortcut1,int1);
     break;
    end;
   end;
  end;
 end;
end;

procedure tshortcutcontroller.dostatread(const reader: tstatreader);
begin
 fsysshortcuts.dostatread('sysshortcuts',reader);
 fsysshortcuts1.dostatread('sysshortcuts1',reader);
 reader.readrecordarray('shortcuts',{$ifdef FPC}@{$endif}setactionreccount,
           {$ifdef FPC}@{$endif}setactionrecord);
end;

function tshortcutcontroller.getactionrecord(const index: integer): msestring;
var
 int1,int2: integer;
begin
 with tshortcutaction(factions[index]) do begin
  if action <> nil then begin
   result:= ownernamepath(action);
   with action do begin
    int2:= high(shortcuts);
    if high(shortcuts1) > int2 then begin
     int2:= high(shortcuts1)
    end;
    for int1:= 0 to int2 do begin
     if int1 <= high(shortcuts) then begin
      result:= result + ' '+inttostr(shortcuts[int1]);
     end
     else begin
      result:= result + ' 0';
     end;
     if int1 <= high(shortcuts1) then begin
      result:= result + ' '+inttostr(shortcuts1[int1]);
     end
     else begin
      result:= result + ' 0';
     end;
    end;
   end;
//   result:= encoderecord([ownernamepath(action),integer(action.shortcut),
//                       integer(action.shortcut1)]);
  end
  else begin
   result:= '';
  end;
 end;
end;

procedure tshortcutcontroller.dostatwrite(const writer: tstatwriter);
begin
 fsysshortcuts.dostatwrite('sysshortcuts',writer);
 fsysshortcuts1.dostatwrite('sysshortcuts1',writer);
 writer.writerecordarray('shortcuts',factions.count,
                               {$ifdef FPC}@{$endif}getactionrecord);
end;

procedure tshortcutcontroller.statreading;
begin
 //dummy
end;

procedure tshortcutcontroller.doafterupdate;
begin
 if canevent(tmethod(fonafterupdate)) then begin
  fonafterupdate(self);
 end;
end;

procedure tshortcutcontroller.statread;
var
 int1: integer;
begin
 for int1:= 0 to factions.count - 1 do begin
  with factions[int1] do begin
   if action <> nil then begin
    updateaction(action);
   end;
  end;
 end;
 doafterupdate;
end;

function tshortcutcontroller.getstatvarname: msestring;
begin
 result:= fstatvarname;
end;

procedure tshortcutcontroller.updateaction(const aaction: taction);
var
 int1: integer;
 str1: ansistring;
begin
 str1:= ownernamepath(aaction);
 for int1:= 0 to high(fstatinfos) do begin
  with fstatinfos[int1] do begin
   if str1 = name then begin
    aaction.shortcuts:= shortcut;
    aaction.shortcuts1:= shortcut1;
   end;
  end;
 end;
end;

procedure tshortcutcontroller.setsysshortcuts(const avalue: tsysshortcuts);
begin
 fsysshortcuts.assign(avalue);
end;

procedure tshortcutcontroller.setsysshortcuts1(const avalue: tsysshortcuts);
begin
 fsysshortcuts1.assign(avalue);
end;

{ tshortcutaction }

procedure tshortcutaction.setaction(const avalue: taction);
begin
 with tshortcutcontroller(fowner) do begin
  setlinkedvar(avalue,tmsecomponent(faction));
  if (avalue <> nil) then begin
   if csdesigning in componentstate then begin
    shortcutsdefault:= avalue.shortcuts;
    shortcuts1default:= avalue.shortcuts1;
   end
   else begin
    updateaction(avalue);
   end;
  end;
 end;  
end;

function tshortcutaction.getshortcutdefault: shortcutty;
begin
 result:= getsimpleshortcut(finfo.shortcut);
end;

procedure tshortcutaction.setshortcutdefault(const avalue: shortcutty);
begin
 setsimpleshortcut(avalue,finfo.shortcut);
end;

function tshortcutaction.getshortcut1default: shortcutty;
begin
 result:= getsimpleshortcut(finfo.shortcut1);
end;

procedure tshortcutaction.setshortcut1default(const avalue: shortcutty);
begin
 setsimpleshortcut(avalue,finfo.shortcut1);
end;

procedure tshortcutaction.readsc(reader: treader);
begin
 finfo.shortcut:= readshortcutarty(reader);
end;

procedure tshortcutaction.writesc(writer: twriter);
begin
 writeshortcutarty(writer,finfo.shortcut);
end;

procedure tshortcutaction.readsc1(reader: treader);
begin
 finfo.shortcut:= readshortcutarty(reader);
end;

procedure tshortcutaction.writesc1(writer: twriter);
begin
 writeshortcutarty(writer,finfo.shortcut);
end;

procedure tshortcutaction.readshortcut(reader: treader);
begin
 shortcutdefault:= reader.readinteger;
end;

procedure tshortcutaction.readshortcut1(reader: treader);
begin
 shortcut1default:= reader.readinteger;
end;

procedure tshortcutaction.defineproperties(filer: tfiler);
begin
 inherited;
 filer.defineproperty('shortcut',{$ifdef FPC}@{$endif}readshortcut,nil,false);
 filer.defineproperty('shortcut1',{$ifdef FPC}@{$endif}readshortcut1,nil,false);
 filer.defineproperty('sc',{$ifdef FPC}@{$endif}readsc,
                           {$ifdef FPC}@{$endif}writesc,
       (filer.ancestor = nil) and (finfo.shortcut <> nil) or
       ((filer.ancestor <> nil) and 
         not issameshortcut(finfo.shortcut,
                  tshortcutaction(filer.ancestor).shortcutsdefault)));
 filer.defineproperty('sc1',{$ifdef FPC}@{$endif}readsc1,
                           {$ifdef FPC}@{$endif}writesc1,
       (filer.ancestor = nil) and (finfo.shortcut1 <> nil) or
       ((filer.ancestor <> nil) and 
         not issameshortcut(finfo.shortcut1,
                  tshortcutaction(filer.ancestor).shortcuts1default)));
end;

procedure tshortcutaction.setshortcuts(const avalue: shortcutarty);
begin
 finfo.shortcut:= avalue;
end;

procedure tshortcutaction.setshortcuts1(const avalue: shortcutarty);
begin
 finfo.shortcut1:= avalue;
end;

function tshortcutaction.getactioninfopo: pactioninfoty;
begin
 result:= @finfo;
end;

procedure tshortcutaction.actionchanged;
begin
 //dummy
end;

function tshortcutaction.loading: boolean;
begin
 result:= csloading in tcomponent(fowner).componentstate;
end;

function tshortcutaction.shortcutseparator: msechar;
begin
end;

procedure tshortcutaction.calccaptiontext(var ainfo: actioninfoty);
begin
end;

{ tsysshortcuts }

constructor tsysshortcuts.create(const aowner: tcomponent;
            const adatapo: psysshortcutaty);
var
 sc1: sysshortcutty;
begin
 inherited create;
 inherited setfixcount(ord(high(sysshortcutty))+1);
 fowner:= aowner;
 fdatapo:= adatapo;
 for sc1:= low(sc1) to high(sc1) do begin
  fitems[ord(sc1)]:= ord(fdatapo^[sc1]); //init with current values
 end;
end;

function tsysshortcuts.getitems(const index: sysshortcutty): shortcutty;
begin
 result:= inherited getitems(ord(index));
end;

procedure tsysshortcuts.setitems(const index: sysshortcutty;
               const avalue: shortcutty);
begin
 inherited setitems(ord(index),ord(avalue));
end;

procedure tsysshortcuts.setfixcount(const avalue: integer);
begin
 //dummy
end;

procedure tsysshortcuts.dochange(const aindex: integer);
var
 sc1: sysshortcutty;
begin
 inherited;
 if (fowner <> nil) and not (csdesigning in fowner.componentstate) then begin
  if aindex < 0 then begin
   for sc1:= low(sc1) to high(sc1) do begin
    fdatapo^[sc1]:= fitems[ord(sc1)];
   end;
  end
  else begin
   fdatapo^[sysshortcutty(aindex)]:= fitems[aindex];
  end;
 end;
end;

procedure tsysshortcuts.setshortcutcount(const acount: integer);
begin
 setlength(fshortcuts,count);
end;

procedure tsysshortcuts.setshortcutrecord(const index: integer;
               const avalue: msestring);
begin
 with fshortcuts[index] do begin
  decoderecord(avalue,[@name,@value],'si');
 end;
end;

procedure tsysshortcuts.dostatread(const varname: string;
               const reader: tstatreader);
var
 int1,int2: integer;
begin
 fshortcuts:= nil;
 reader.readrecordarray(varname,{$ifdef FPC}@{$endif}setshortcutcount,
           {$ifdef FPC}@{$endif}setshortcutrecord);
 for int1:= 0 to high(fshortcuts) do begin
  with fshortcuts[int1] do begin
   int2:= getenumvalue(typeinfo(sysshortcutty),name);
   if int2 >= 0 then begin
    items[sysshortcutty(int2)]:= value;
   end;
  end;
 end;
 fshortcuts:= nil;
end;

function tsysshortcuts.getshortcutrecord(const index: integer): msestring;
begin
 result:= encoderecord([getenumname(typeinfo(sysshortcutty),index),fitems[index]]);
end;

procedure tsysshortcuts.dostatwrite(const varname: string;
               const writer: tstatwriter);
begin
 writer.writerecordarray(varname,count,
                               {$ifdef FPC}@{$endif}getshortcutrecord);
end;

{ tcustomhelpcontroller }

constructor tcustomhelpcontroller.create(aowner: tcomponent);
begin
 inherited;
 if not (csdesigning in componentstate) then begin
  application.registerhelphandler({$ifdef FPC}@{$endif}dohelp);
 end;
end;

destructor tcustomhelpcontroller.destroy;
begin
 if not (csdesigning in componentstate) then begin
  application.unregisterhelphandler({$ifdef FPC}@{$endif}dohelp);
 end;
 inherited;
end;

procedure tcustomhelpcontroller.dohelp(const sender: tmsecomponent;
               var handled: boolean);
begin
 if not handled and canevent(tmethod(fonhelp)) then begin
  fonhelp(self,sender,handled);
 end;
 if not handled and assigned(fonhelp1) then begin
  fonhelp1(self,sender,handled);
 end;
end;

initialization
 sysshortcuts:= defaultsysshortcuts; 
 sysshortcuts1:= defaultsysshortcuts1; 
finalization
end.

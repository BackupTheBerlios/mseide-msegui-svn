{ MSEgui Copyright (c) 1999-2007 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit msedrawtext;

{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

//todo: optimize speed

interface
uses
 Classes,msegraphics,mserichstring,msegraphutils,
  msearrayprops,mseclasses,msestrings,msetypes;

const
 defaultppmm = 3;      //3 pixel per mm
 defaulttabwidth = 20; //mm
 textellipse = msestring('...');

type
 textflagty = (tf_xcentered,tf_right,tf_ycentered,tf_bottom, 
                 //order fix, used in msepostscriptprinter
               tf_clipi,tf_clipo,
               tf_grayed,tf_wordbreak,tf_noselect,
               tf_ellipseleft,{tf_ellipsemid,}tf_ellipseright);
 textflagsty = set of textflagty;
const
 ellipsemask: textflagsty = [tf_ellipseleft,{tf_ellipsemid,}tf_ellipseright];
 
type

 tabulatorkindty = (tak_left,tak_right,tak_centered,tak_decimal);
 tabulatorty = record
  kind: tabulatorkindty;
  pos: integer;
 end;
 tabulatorarty = array of tabulatorty;

 ttabulatoritem = class(townedpersistent)
  private
   fkind: tabulatorkindty;
   fpos: real;
   procedure setkind(const avalue: tabulatorkindty);
   procedure setpos(const avalue: real);
  public
  published
   property kind: tabulatorkindty read fkind write setkind default tak_left;
   property pos: real read fpos write setpos;
 end;
 tabulatoritemclassty = class of ttabulatoritem;
 
 tcustomtabulators = class(townedpersistentarrayprop)
  private
   fppmm: real;
   fuptodate: boolean;
   fdefaultdist: real;
   procedure setppmm(const avalue: real);
   function gettabs: tabulatorarty;
   function getitems(const index: integer): ttabulatoritem;
   procedure setitems(const index: integer; const avalue: ttabulatoritem);
   procedure setdefaultdist(const avalue: real);
   function getpos(const index: integer): integer;
  protected
   ftabs: tabulatorarty;
   procedure checkuptodate;
   procedure dochange(const index: integer); override;
   procedure changed(const sender: ttabulatoritem);
   class function getitemclass: tabulatoritemclassty; virtual;
  public
   constructor create; reintroduce;
   procedure assign(source: tpersistent); override;
   procedure add(const pos: real; const kind: tabulatorkindty);
   procedure setdefaulttabs(const awidth: real = 20; const acount: integer = 20;
                         const akind: tabulatorkindty = tak_left);
   property tabs: tabulatorarty read gettabs;
   property ppmm: real read fppmm write setppmm;
      //pixel per millimeter
   property defaultdist: real read fdefaultdist write setdefaultdist; //0 -> none
   property items[const index: integer]: ttabulatoritem read getitems 
                       write setitems; default;
   property pos[const index: integer]: integer read getpos;
 end;

 ttabulators = class(tcustomtabulators)
  published
   property ppmm;
   property defaultdist;
 end;
 
 drawtextinfoty = record
  text: richstringty;
  dest,clip: rectty;
  flags: textflagsty;
  font: tfont;
  tabulators: tcustomtabulators;
  res: rectty;
 end;

 lineinfoty = record
  liindex,licount: integer;
  listartx: integer;
  liwidth: integer;
  tabchars: integerarty;
 end;
 lineinfoarty = array of lineinfoty;

 layoutinfoty = record
  charwidths: integerarty;
  lineinfos: lineinfoarty;
  ascent,descent,lineheight,
  underline,strikeout: integer;
  starty: integer;
  height: integer;
 end;
 
function checktextflags(old,new: textflagsty): textflagsty;

procedure drawtext(const canvas: tcanvas; var info: drawtextinfoty); overload;
procedure drawtext(const canvas: tcanvas; const text: richstringty;
                   const dest: rectty; flags: textflagsty = [];
                   font: tfont = nil; tabulators: tcustomtabulators = nil); overload;
procedure drawtext(const canvas: tcanvas; const text: richstringty;
                   const dest,clip: rectty; flags: textflagsty = [];
                   font: tfont = nil; tabulators: tcustomtabulators = nil); overload;
procedure drawtext(const canvas: tcanvas; const text: msestring;
                   const dest: rectty; flags: textflagsty = [];
                   font: tfont = nil; tabulators: tcustomtabulators = nil); overload;
procedure layouttext(const canvas: tcanvas; var info: drawtextinfoty;
                               out layoutinfo: layoutinfoty); overload;
function breaklines(const canvas: tcanvas; 
                         var info: drawtextinfoty): richstringarty; overload;
function breaklines(const canvas: tcanvas; const text: richstringty;
                   const width: integer; font: tfont = nil): richstringarty; overload;
function breaklines(const canvas: tcanvas; const text: msestring;
                   const width: integer; font: tfont = nil): msestringarty; overload;

procedure textrect(const canvas: tcanvas; var info: drawtextinfoty); overload;
                         //result in info.res
function textrect(const canvas: tcanvas; const text: richstringty;
                   const dest: rectty; flags: textflagsty = [];
                   font: tfont = nil; tabulators: tcustomtabulators = nil): rectty; overload;
function textrect(const canvas: tcanvas; const text: richstringty;
                   flags: textflagsty = []; font: tfont = nil;
                    tabulators: tcustomtabulators = nil): rectty; overload;
function textrect(const canvas: tcanvas; const text: msestring;
                   const dest: rectty; flags: textflagsty = [];
                   font: tfont = nil; tabulators: tcustomtabulators = nil): rectty; overload;
function textrect(const canvas: tcanvas; const text: msestring;
                   flags: textflagsty = []; font: tfont = nil;
                   tabulators: tcustomtabulators = nil): rectty; overload;
function textclipped(const canvas: tcanvas; var info: drawtextinfoty): boolean;

function postotextindex(const canvas: tcanvas; var info: drawtextinfoty;
                                 const pos: pointty; out aindex: integer): boolean;
    //false if out of text
function textindextopos(const canvas: tcanvas; var info: drawtextinfoty;
                                 aindex: integer): pointty;

implementation
uses
 mseguiintf,msebits,msedatalist,{$ifdef FPC}math{$else}Math{$endif},msereal,sysutils;

type
 tcanvas1 = class(tcanvas);

function checktextflags(old,new: textflagsty): textflagsty;
const
 xmask: textflagsty = [tf_xcentered,tf_right];
 ymask: textflagsty = [tf_ycentered,tf_bottom];
begin
 result:= new;
 result:= textflagsty(setsinglebit({$ifdef FPC}longword{$else}word{$endif}(result),
              {$ifdef FPC}longword{$else}word{$endif}(old),
              {$ifdef FPC}longword{$else}word{$endif}(ymask)));
 result:= textflagsty(setsinglebit({$ifdef FPC}longword{$else}word{$endif}(result),
              {$ifdef FPC}longword{$else}word{$endif}(old),
              {$ifdef FPC}longword{$else}word{$endif}(xmask)));
 result:= textflagsty(setsinglebit({$ifdef FPC}longword{$else}word{$endif}(result),
              {$ifdef FPC}longword{$else}word{$endif}(old),
              {$ifdef FPC}longword{$else}word{$endif}(ellipsemask)));
end;

procedure layouttext(const canvas: tcanvas; var info: drawtextinfoty; 
                              out layoutinfo: layoutinfoty);
var
 drawinfo: drawinfoty;
 awidth: integer;
 resultpo1: pinteger;
 text1: pmsechar;

 procedure getcharwidths(acount: integer);
 begin
  if acount <= 0 then begin
   exit;
  end;
  with drawinfo.getchar16widths do begin
   datapo:= getfontdata(canvas.font.handle);
   resultpo:= resultpo1;
   text:= text1;
   count:= acount;
   gdierror(gui_getchar16widths(drawinfo));
   inc(text1,acount);
   inc(resultpo1,acount);
  end;
 end;

 function checklinebreak(var aindex: integer): boolean;
 var
  ch1: msechar;
 begin
  ch1:= info.text.text[aindex];
  result:= (ch1 = c_return) or (ch1 = c_linefeed);
  if result then begin
   with layoutinfo do begin
    with lineinfos[high(lineinfos)] do begin
     licount:= aindex - liindex;
     liwidth:= awidth;
    end;
    inc(aindex);
    if (ch1 = c_return) and (aindex <= length(info.text.text)) and
            (info.text.text[aindex] = c_linefeed) then begin
     inc(aindex);
    end;
    setlength(lineinfos,high(lineinfos) + 2);
    with lineinfos[high(lineinfos)] do begin
     liindex:= aindex;
    end;
   end;
  end;
 end;

 function tabitemwidth(const charindex: integer;
                       const stopchar: msechar): integer;
 var
  po1: pinteger;
  po2: pmsechar;
 begin
  result:= 0;
  po1:= @pointer(layoutinfo.charwidths[charindex]);
  po2:= @info.text.text[charindex+1];
  while true do begin
   case po2^ of 
    ' ',c_tab,c_return,c_linefeed,#0: begin
     break;
    end;
    else begin
     if po2^ = stopchar then begin
      break;
     end;
     result:= result + po1^;
     inc(po1);
     inc(po2);
    end;
   end;
  end;
 end;
var
 int1,int2,int3,int4: integer;
 textlen: integer;
 style1: fontstylesty;
 nexttab: integer;
 rea1: real;
 tabs: tabulatorarty;

begin
 tabs:= nil; //compiler warning
 if info.font <> nil then begin
  canvas.font:= info.font;
 end;
 with info,canvas,layoutinfo do begin
  tcanvas1(canvas).checkgcstate([cs_gc]);
  canvas.initdrawinfo(drawinfo);
  ascent:= font.ascent;
  descent:= font.descent;
  lineheight:= font.lineheight;
  textlen:= length(text.text);
  setlength(charwidths,textlen);
  text1:= pointer(info.text.text);
  resultpo1:= pointer(charwidths);
  if text.format = nil then begin
   getcharwidths(textlen);
  end
  else begin
   int2:= 0;
   style1:= font.style;
   for int1:= 0 to high(text.format) do begin
    with text.format[int1] do begin
     if {$ifdef FPC}longword{$else}byte{$endif}(newinfos) and fontstylehandlemask <> 0 then begin
      if index > textlen then begin
       getcharwidths(textlen-int2);
      end
      else begin
       getcharwidths(index-int2);
      end;
      int2:= index;
      font.style:= style.fontstyle;
     end;
    end;
   end;
   if int2 < length(text.text) then begin
    getcharwidths(length(text.text)-int2);
   end;
   font.style:= style1;
  end;
  setlength(lineinfos,1);
  lineinfos[0].liindex:= 1;
  int1:= 1;
  awidth:= 0; //textwidth
  if tf_wordbreak in flags then begin
   while int1 <= textlen do begin
    int2:= 0; //index of last whitespace
    int3:= 0; //textwidth of last whitespace
    awidth:= 0; //textwidth
    while int1 <= textlen do begin
     if text.text[int1] = ' ' then begin
      int2:= int1;
      int3:= awidth;
     end
     else begin
      if checklinebreak(int1) then begin
       break;
      end;
     end;
     inc(awidth,charwidths[int1-1]);
     if (awidth > info.dest.cx) and (awidth > charwidths[int1-1]) then begin
                           //min one char on line
      with lineinfos[high(lineinfos)] do begin
       if int2 > 0 then begin //use last whitespace for break
        licount:= int2 - liindex;
        liwidth:= int3;
        int1:= int2 + 1;
       end
       else begin
        licount:= int1 - liindex; //no whitespace to break
        liwidth:= awidth - charwidths[int1];
       end;
      end;
      setlength(lineinfos,high(lineinfos) + 2);
      with lineinfos[high(lineinfos)] do begin
       liindex:= int1;
      end;
      break;
     end;
     inc(int1);
    end;
   end;
   with lineinfos[high(lineinfos)] do begin
    if textlen > 0 then begin
     licount:= textlen - liindex + 1;
    end;
    liwidth:= awidth;
   end;
  end
  else begin
   if (info.tabulators = nil) or 
     (info.tabulators.count = 0) and (info.tabulators.defaultdist = 0) then begin
    while int1 <= textlen do begin
     if not checklinebreak(int1) then begin
      inc(awidth,charwidths[int1-1]);
      inc(int1);
     end
     else begin
      awidth:= 0;
     end;
    end;
   end
   else begin
    tabs:= info.tabulators.tabs;
    rea1:= info.tabulators.defaultdist * info.tabulators.ppmm;
    nexttab:= -1;
    while int1 <= textlen do begin
     if not checklinebreak(int1) then begin 
      if info.text.text[int1] = c_tab then begin
       if tabs <> nil then begin
        inc(nexttab);
        {
        int4:= nexttab+1;
        nexttab:= bigint;
        for int4:= int4 to high(tabs) do begin
         if tabs[int4].pos > awidth then begin
          nexttab:= int4;
          break;
         end;
        end;
        }
        if nexttab < info.tabulators.count then begin
         case tabs[nexttab].kind of
          tak_right: begin
           charwidths[int1-1]:= tabs[nexttab].pos - awidth - 
                                   tabitemwidth(int1,#0);
          end;
          tak_centered: begin
           charwidths[int1-1]:= tabs[nexttab].pos - awidth - 
                                   tabitemwidth(int1,#0) div 2;
          end;
          tak_decimal: begin
           charwidths[int1-1]:= tabs[nexttab].pos - awidth - 
                                   tabitemwidth(int1,widechar(decimalseparator));
          end;
          else begin //tak_left
           charwidths[int1-1]:= tabs[nexttab].pos - awidth;
          end;
         end;
         additem(lineinfos[high(lineinfos)].tabchars,int1);
        end
        else begin
         if rea1 > 0 then begin
          charwidths[int1-1]:= round(ceil(awidth / rea1)*rea1) - awidth;
          additem(lineinfos[high(lineinfos)].tabchars,int1);
         end;
        end;
       end
       else begin
        if rea1 > 0 then begin
         charwidths[int1-1]:= round(floor((awidth+rea1+0.1)/rea1)*rea1) - awidth;
         additem(lineinfos[high(lineinfos)].tabchars,int1);
        end;
       end;
      end;
      inc(awidth,charwidths[int1-1]);
      inc(int1);
     end
     else begin
      awidth:= 0;
      nexttab:= -1;
     end;
    end;
   end;
   with lineinfos[high(lineinfos)] do begin
    liwidth:= awidth;
    licount:= int1-liindex;
   end;
  end;
  if high(lineinfos) >= 0 then begin
   height:= lineheight*high(lineinfos)+ascent+descent;
  end
  else begin
   height:= 0;
  end;
  res.y:= info.dest.y;
  if tf_ycentered in flags then begin
   res.y:= res.y + (info.dest.cy - height) div 2;
  end
  else begin
   if tf_bottom in flags then begin
    res.y:= res.y + info.dest.cy - height;
   end;
  end;
  starty:= res.y + ascent; //layoutinfo
  res.x:= bigint;
  res.cy:= height;
  res.cx:= 0;
  for int3:= 0 to high(lineinfos) do begin
   with layoutinfo.lineinfos[int3] do begin
    listartx:= info.dest.x;
    if tf_xcentered in flags then begin
     listartx:= listartx + (info.dest.cx - liwidth) div 2;
    end
    else begin
     if tf_right in flags then begin
      listartx:= listartx + info.dest.cx - liwidth;
     end;
    end;
    if res.x > listartx then begin
     res.x:= listartx;
    end;
    if res.cx < liwidth then begin
     res.cx:= liwidth;
    end;
   end;
  end;
 end;
end;

function breaklines(const canvas: tcanvas; 
                        var info: drawtextinfoty): richstringarty;
var
 la1: layoutinfoty;
 int1: integer;
begin
 layouttext(canvas,info,la1);
 setlength(result,length(la1.lineinfos)); 
 for int1:= 0 to high(result) do begin
  with la1.lineinfos[int1] do begin
   result[int1]:= richcopy(info.text,liindex,licount);
  end;
 end;
end;

function breaklines(const canvas: tcanvas; const text: richstringty;
                   const width: integer; font: tfont = nil): richstringarty;
var
 info: drawtextinfoty;
begin
 info.text:= text;
 info.dest.pos:= nullpoint;
 info.dest.cx:= width;
 info.dest.cy:= bigint;
 info.flags:= [tf_wordbreak];
 info.font:= font;
 info.tabulators:= nil;
 result:= breaklines(canvas,info);
end;

function breaklines(const canvas: tcanvas; const text: msestring;
                   const width: integer; font: tfont = nil): msestringarty;
var
 rstr1: richstringty;
 ar1: richstringarty;
 int1: integer;
begin
 rstr1.format:= nil;
 rstr1.text:= text;
 ar1:= breaklines(canvas,rstr1,width,font);
 setlength(result,length(ar1));
 for int1:= 0 to high(ar1) do begin
  result[int1]:= ar1[int1].text;
 end;
end;

function postotextindex(const canvas: tcanvas; var info: drawtextinfoty;
                                const pos: pointty; out aindex: integer): boolean;
    //false if out of text
var
 layoutinfo: layoutinfoty;
 int1,int2,int3: integer;
begin
 result:= true;
 with info,canvas,layoutinfo do begin
  if length(text.text) = 0 then begin
   result:= false;
   aindex:= 0;
   exit;
  end;
//  if info.font <> nil then begin
//   canvas.font:= info.font;
//  end;
  layouttext(canvas,info,layoutinfo);
  if pos.y < res.y then begin
   result:= false;
   aindex:= 0;
  end
  else begin
   if pos.y >= res.y + height then begin
    aindex:= length(text.text);
    result:= false;
   end
   else begin
    int1:= (pos.y-starty+ascent) div lineheight;
    if int1 > high(lineinfos) then begin
     int1:= high(lineinfos); //last line is ascent+descent
    end;
    with lineinfos[int1] do begin
     int2:= listartx;
     int3:= liindex + licount - 1;
     aindex:= int3;
     result:= false;
     for int1:= liindex-1 to liindex+licount-2 do begin
      inc(int2,charwidths[int1]);
      if int2 >= pos.x then begin
       aindex:= int1;
       result:= true;
       break;
      end;
     end;
     if aindex < int3 then begin
      if int2 - pos.x < charwidths[aindex] div 2 then begin
       inc(aindex);
      end;
     end;
    end;
   end;
  end;
 end;
end;

function textindextopos(const canvas: tcanvas; var info: drawtextinfoty;
                                aindex: integer): pointty;
var
 layoutinfo: layoutinfoty;
 int1,int2,int3: integer;
begin
 with info,layoutinfo do begin
//  if info.font <> nil then begin
//   canvas.font:= info.font;
//  end;
  layouttext(canvas,info,layoutinfo);
  if aindex > length(text.text) then begin
   aindex:= length(text.text);
  end
  else begin
   if aindex < 0 then begin
    aindex:= 0;
   end;
  end;
  int3:= 0; //compiler warning
  for int1:= 0 to high(lineinfos) do begin
   with lineinfos[int1] do begin
    if liindex + licount > aindex then begin
     int3:= int1;
     break;
    end;
   end;
  end;
  result.y:= starty + int3 * lineheight;
  with lineinfos[int3] do begin
   int2:= listartx;
   for int1:= liindex-1 to aindex-1 do begin
    inc(int2,charwidths[int1]);
   end;
   result.x:= int2;
  end;
 end;
end;

procedure drawtext(const canvas: tcanvas; var info: drawtextinfoty);
const
 stopmask = [ni_bold,ni_italic,ni_underline,ni_strikeout,ni_selected,
             ni_fontcolor,ni_colorbackground];
 fonthandlemask = [ni_bold,ni_italic];
 fontstylemask = [ni_bold,ni_italic,ni_underline,ni_strikeout];

var
 layoutinfo: layoutinfoty;
 pos: pointty;
 infoindexbefore,charindexbefore: integer;
 last: boolean;
 count: integer;
 defaultcolor,defaultcolorbackground: colorty;
 afontstyle,fontstylebefore: fontstylesty;
 grayed: boolean;
 formatactive: boolean;
 endindex: integer;
 ellipsewidthsum: integer;

 procedure drawsubstring(const row,astart,acount: integer);
 var
  int2,int3,int4: integer;
  xbefore: integer;
  x: integer;
 begin
  if acount > 0 then begin
   x:= pos.x;
   xbefore:= x;
   with info,canvas,layoutinfo,lineinfos[row] do begin
    if (tabulators = nil) or
             (tabchars = nil) then begin
     drawstring(@text.text[astart],acount,pos,nil,grayed);
     for int2:= astart - 1 to astart + acount - 2 do begin
      inc(x,charwidths[int2]);
     end;
    end
    else begin
     int2:= astart - 1;
     for int4:= 0 to high(tabchars) do begin
      if (tabchars[int4] >= astart) and (tabchars[int4] < astart + acount) then begin
       drawstring(@text.text[int2+1],tabchars[int4] - int2 - 1,pos,nil,grayed);
       for int2:= int2 to tabchars[int4] - 1 do begin
        inc(x,charwidths[int2]);
       end;
       if font.colorbackground <> cl_transparent then begin
        int3:= charwidths[tabchars[int4] - 1];
        fillrect(makerect(x - int3,pos.y-font.ascent,int3,
                      font.ascent+font.descent),font.colorbackground);
       end;
       int2:= tabchars[int4];
       pos.x:= x;
      end;
     end;
     int3:= acount - int2 + astart - 1;
     drawstring(@text.text[int2+1],int3,pos,nil,grayed);
     for int2:= int2 to int2 + int3 - 1 do begin
      inc(x,charwidths[int2]);
     end;
    end;
    if not grayed then begin
     if fs_underline in canvas.font.style then begin
      drawline(makepoint(xbefore,pos.y+underline),
                makepoint(x-1,pos.y+underline),font.color);
     end;
     if fs_strikeout in font.style then begin
      drawline(makepoint(xbefore,pos.y+layoutinfo.strikeout),
                makepoint(x-1,pos.y+layoutinfo.strikeout),font.color);
     end;
    end;
    pos.x:= x;
   end;
  end;
 end;

 procedure adjustellipsepos(delta: integer);
 begin
  if tf_right in info.flags then begin
   pos.x:= pos.x - delta;
  end
  else begin
   if tf_xcentered in info.flags then begin
    pos.x:= pos.x - delta div 2;
   end;
  end;
 end;

 procedure updatefont(const aformat: formatinfoty);
 begin
  with aformat,info,canvas do begin
   if newinfos * fontstylemask <> [] then begin
    afontstyle:= afontstyle * fontstylesty(
          not {$ifdef FPC}longword{$else}byte{$endif}(newinfos)) + style.fontstyle;
    font.style:= afontstyle;
   end;
   if (ni_selected in newinfos) then begin
    if (fs_selected in style.fontstyle) and not (tf_noselect in flags) then begin
     font.color:= cl_selectedtext;
     font.colorbackground:= cl_selectedtextbackground;
    end
    else begin
     if style.fontcolor = nil then begin
      font.color:= defaultcolor;
     end
     else begin
      font.color:= style.fontcolor^;
     end;
     if style.colorbackground = nil then begin
      font.colorbackground:= defaultcolorbackground;
     end
     else begin
      font.colorbackground:= style.colorbackground^;
     end;
    end;
   end;
   if not (fs_selected in style.fontstyle) then begin
    if ni_fontcolor in newinfos then begin
     if style.fontcolor = nil then begin
      font.color:= defaultcolor;
     end
     else begin
      font.color:= style.fontcolor^;
     end;
    end;
    if ni_colorbackground in newinfos then begin
     if style.colorbackground = nil then begin
      font.colorbackground:= defaultcolorbackground;
     end
     else begin
      font.colorbackground:= style.colorbackground^;
     end;
    end;
   end;
  end;
 end;

var
 row: integer;
 ellipsewidth: integer;
 int1,{int2,}int3{,int4}: integer;
 lastover: boolean;
label
 endlab;

begin                  //drawtext
 with info,canvas do begin
  save;
  if tf_clipi in flags then begin
   intersectcliprect(dest);
  end;
  if tf_clipo in flags then begin
   intersectcliprect(clip);
  end;
  if text.text = '' then begin
   info.res:= nullrect;
   goto endlab;
  end;
  layouttext(canvas,info,layoutinfo);
  defaultcolor:= font.color;
  defaultcolorbackground:= font.colorbackground;
  fontstylebefore:= font.style;
  afontstyle:= fontstylebefore;
//  layouttext(canvas,info,layoutinfo);
  grayed:= tf_grayed in flags;
  with layoutinfo do begin
   underline:= descent div 2 + 1;
   if underline = 0 then begin
    underline:= 1;
   end;
   if underline >= descent then begin
    underline:= descent - 1;
   end;
   strikeout:= - (ascent div 3);
  end;
  pos.y:= layoutinfo.starty;
  if info.text.format <> nil then begin
   infoindexbefore:= -1;
   int1:= 0; //format index
   row:= 0; //layoutinfo row index
   lastover:= false;
   while row <= high(layoutinfo.lineinfos) do begin
    with layoutinfo.lineinfos[row] do begin
     pos.x:= listartx;
     charindexbefore:= liindex-1;
     endindex:= charindexbefore + licount;
    end;
    while true do begin
     with text.format[int1] do begin
      formatactive:= (index < endindex);
      last:= (int1 >= high(text.format)) or not formatactive;
      if last or (newinfos * stopmask <> []) then begin
       if infoindexbefore >= 0 then begin
        updatefont(text.format[infoindexbefore]);
       end;
       if formatactive and not lastover then begin
        count:= text.format[int1].index - charindexbefore;
        if count > 0 then begin
         drawsubstring(row,charindexbefore+1,count);
         inc(charindexbefore,count);
        end;
        infoindexbefore:= int1;
        if last then begin
         updatefont(text.format[int1]);
         count:= endindex - charindexbefore;
         drawsubstring(row,charindexbefore+1,count);
         inc(charindexbefore,count);
         lastover:= true;
         break;
        end;
       end
       else begin
        drawsubstring(row,charindexbefore+1,endindex - charindexbefore);
        break;
       end;
      end;
     end;
     inc(int1);
    end;
    inc(row);
    inc(pos.y,layoutinfo.lineheight);
   end;
   font.color:= defaultcolor;
   font.colorbackground:= defaultcolorbackground;
   font.style:= fontstylebefore;
  end
  else begin
   pos.x:= layoutinfo.lineinfos[0].listartx;
   for row:= 0 to high(layoutinfo.lineinfos) do begin
    with layoutinfo.lineinfos[row] do begin
     pos.x:= listartx;
     if (liwidth > dest.cx) and (flags * ellipsemask <> []) then begin
      ellipsewidth:= getstringwidth(textellipse);
      ellipsewidthsum:= liwidth + ellipsewidth;
      int1:= liindex;
      if tf_ellipseleft in flags then begin
       int3:= liindex + licount;
       while int1 < int3 do begin
        dec(ellipsewidthsum,layoutinfo.charwidths[int1-1]);
        inc(int1);
        if ellipsewidthsum <= dest.cx then begin
         break;
        end;
       end;
       adjustellipsepos(ellipsewidthsum -liwidth);
       drawstring(textellipse,pos,nil,tf_grayed in flags);
       inc(pos.x,ellipsewidth);
       dec(licount,int1-liindex);
       liindex:= int1;
       drawsubstring(row,liindex,licount);
      end
      else begin
       if tf_ellipseright in flags then begin
        int1:= int1 + licount;
        while int1 > liindex do begin
         dec(int1);
         dec(ellipsewidthsum,layoutinfo.charwidths[int1-1]);
         if ellipsewidthsum <= dest.cx then begin
          break;
         end;
        end;
       end;
       licount:= int1 - liindex;
       adjustellipsepos(ellipsewidthsum -liwidth);
       drawsubstring(row,liindex,licount);
       drawstring(textellipse,pos,nil,tf_grayed in flags);
      end;
     end
     else begin
      drawsubstring(row,liindex,licount);
     end;
     inc(pos.y,layoutinfo.lineheight);
    end;
   end;
  end;
endlab:
  restore;
 end;
end;

procedure drawtext(const canvas: tcanvas; const text: richstringty;
                        const dest: rectty; flags: textflagsty = [];
                        font: tfont = nil; tabulators: tcustomtabulators = nil);
var
 info: drawtextinfoty;
begin
 info.text:= text;
 info.dest:= dest;
 info.flags:= flags - [tf_clipo];
 info.font:= font;
 info.tabulators:= tabulators;
 drawtext(canvas,info);
end;

procedure drawtext(const canvas: tcanvas; const text: richstringty;
                        const dest,clip: rectty; flags: textflagsty = [];
                        font: tfont = nil; tabulators: tcustomtabulators = nil);
var
 info: drawtextinfoty;
begin
// info.canvas:= canvas;
 info.text:= text;
 info.dest:= dest;
 info.clip:= clip;
 info.flags:= flags;
 info.font:= font;
 info.tabulators:= tabulators;
 drawtext(canvas,info);
end;

procedure drawtext(const canvas: tcanvas; const text: msestring;
                        const dest: rectty; flags: textflagsty = [];
                        font: tfont = nil; tabulators: tcustomtabulators = nil);
var
 ristr1: richstringty;
begin
 ristr1.text:= text;
 ristr1.format:= nil;
 drawtext(canvas,ristr1,dest,flags,font,tabulators);
end;

procedure textrect(const canvas: tcanvas; var info: drawtextinfoty);
var
 layoutinfo: layoutinfoty;
begin
// if info.font <> nil then begin
//  canvas.font:= info.font;
// end;
 layouttext(canvas,info,layoutinfo);
end;

function textclipped(const canvas: tcanvas; var info: drawtextinfoty): boolean;
begin
 textrect(canvas,info);
 result:= not rectinrect(info.res,info.dest);
end;

function textrect(const canvas: tcanvas; const text: richstringty;
                   const dest: rectty; flags: textflagsty = [];
                   font: tfont = nil; tabulators: tcustomtabulators = nil): rectty;
var
 info: drawtextinfoty;
begin
 info.text:= text;
 info.dest:= dest;
// info.clip:= dest;
 info.flags:= flags - [tf_clipo];
 info.font:= font;
 info.tabulators:= tabulators;
 textrect(canvas,info);
 result:= info.res;
end;

function textrect(const canvas: tcanvas; const text: richstringty;
                   flags: textflagsty = []; font: tfont = nil;
                   tabulators: tcustomtabulators = nil): rectty; overload;
begin
 flags:= flags - [tf_right,tf_bottom,tf_xcentered,tf_ycentered];
 result:= textrect(canvas,text,makerect(0,0,bigint,bigint),flags,font,tabulators);
end;

function textrect(const canvas: tcanvas; const text: msestring;
                   const dest: rectty; flags: textflagsty = [];
                   font: tfont = nil; tabulators: tcustomtabulators = nil): rectty;
var
 str1: richstringty;
begin
 str1.text:= text;
 result:= textrect(canvas,str1,dest,flags,font,tabulators);
end;

function textrect(const canvas: tcanvas; const text: msestring;
                   flags: textflagsty = []; font: tfont = nil;
                   tabulators: tcustomtabulators = nil): rectty;
var
 str1: richstringty;
begin
 str1.text:= text;
 result:= textrect(canvas,str1,flags,font,tabulators);
end;

{ ttabulatoritem }

procedure ttabulatoritem.setkind(const avalue: tabulatorkindty);
begin
 if fkind <> avalue then begin
  fkind:= avalue;
  tcustomtabulators(fowner).changed(self);
 end;
end;

procedure ttabulatoritem.setpos(const avalue: real);
begin
 if fpos <> avalue then begin
  fpos:= avalue;
  if isemptyreal(fpos) then begin
   fpos:= 0;
  end;
  tcustomtabulators(fowner).changed(self);
 end;
end;

{ tcustomtabulators }

constructor tcustomtabulators.create;
begin
 fppmm:= defaultppmm;
 inherited create(self,getitemclass);
end;

procedure tcustomtabulators.assign(source: tpersistent);
var
 int1: integer;
begin
 if source is tcustomtabulators then begin
  beginupdate;
  with tcustomtabulators(source) do begin
   self.count:= count;
   for int1:= 0 to high(fitems) do begin
    ttabulatoritem(self.fitems[int1]).fkind:= ttabulatoritem(fitems[int1]).fkind;
    ttabulatoritem(self.fitems[int1]).fpos:= ttabulatoritem(fitems[int1]).fpos;
   end;
   self.fdefaultdist:= fdefaultdist;
  end;
  endupdate;
 end
 else begin
  inherited;
 end;
end;

class function tcustomtabulators.getitemclass: tabulatoritemclassty;
begin
 result:= ttabulatoritem;
end;

procedure tcustomtabulators.changed(const sender: ttabulatoritem);
begin
 dochange(-1);
end;

procedure tcustomtabulators.dochange(const index: integer);
begin
 fuptodate:= false;
 inherited;
end;

procedure tcustomtabulators.add(const pos: real; const kind: tabulatorkindty);
begin
 beginupdate;
  count:= count + 1;
  with ttabulatoritem(fitems[high(fitems)]) do begin
   fpos:= pos;
   fkind:= kind;
  end;
 endupdate;
end;

procedure tcustomtabulators.setdefaulttabs(const awidth: real;
  const acount: integer; const akind: tabulatorkindty);
var
 int1: integer;
begin
 beginupdate;
 count:= acount;
 for int1:= 0 to high(fitems) do begin
  with ttabulatoritem(fitems[int1]) do begin
   fpos:= (int1+1)*awidth;
   fkind:= akind;
  end;
 end;
 endupdate;
end;

procedure tcustomtabulators.setppmm(const avalue: real);
begin
 if fppmm <> avalue then begin
  fppmm:= avalue;
  changed(nil);
 end;
end;

function cmptab(const l,r): integer;
begin
 result:= tabulatorty(l).pos - tabulatorty(r).pos;
end;

procedure tcustomtabulators.checkuptodate;
var
 int1: integer;
begin
 if not fuptodate then begin
  setlength(ftabs,count);
  for int1:= 0 to high(ftabs) do begin
   ftabs[int1].kind:= ttabulatoritem(fitems[int1]).fkind;
   ftabs[int1].pos:= round(ttabulatoritem(fitems[int1]).fpos*fppmm);
  end;
  sortarray(ftabs,{$ifdef FPC}@{$endif}cmptab,sizeof(ftabs[0]));
  fuptodate:= true;
 end;
end;

function tcustomtabulators.gettabs: tabulatorarty;
begin
 checkuptodate;
 result:= ftabs;
end;

function tcustomtabulators.getitems(const index: integer): ttabulatoritem;
begin
 result:= ttabulatoritem(inherited getitems(index));
end;

procedure tcustomtabulators.setitems(const index: integer; const avalue: ttabulatoritem);
begin
 getitems(index).assign(avalue);
end;

procedure tcustomtabulators.setdefaultdist(const avalue: real);
begin
 fdefaultdist:= avalue;
 if isemptyreal(fdefaultdist) or (fdefaultdist < 0) then begin
  fdefaultdist:= 0;
 end;
 dochange(-1);
end;

function tcustomtabulators.getpos(const index: integer): integer;
var
 int1: integer;
begin
 checkuptodate;
 if index <= high(ftabs) then begin
  result:= ftabs[index].pos;
 end
 else begin
  if length(ftabs) > 0 then begin
   if fdefaultdist > 0 then begin
    int1:= trunc(ftabs[high(ftabs)].pos/fdefaultdist);
   end
   else begin
    result:= ftabs[high(ftabs)].pos;
    exit;
   end;
  end
  else begin
   int1:= 0;
  end;
  result:= round((int1 + index - high(ftabs)) * fdefaultdist);
 end;
end;

end.

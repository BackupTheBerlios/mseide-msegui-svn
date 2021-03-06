{ MSEgui Copyright (c) 1999-2007 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit mseshapes;

{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface
uses
 msegraphics,msegraphutils,mseguiglob,msegui,mseevent,mserichstring,msebitmap,
  msetypes;

const
 menuarrowwidth = 8;
 menucheckboxwidth = 13;

type
 shapestatety = (ss_disabled,ss_invisible,ss_checked,ss_default, //actionstatesty
                 ss_separator,ss_checkbox,ss_radiobutton,        //menuactionoptionty

                 ss_clicked,ss_mouse,ss_moveclick,ss_focused,
                 ss_horz,ss_vert,ss_opposite,
                 ss_widgetorg,ss_showfocusrect,ss_showdefaultrect,ss_flat,
                 ss_checkbutton,
                 ss_submenu);
 shapestatesty = set of shapestatety;

 actionstatety = (as_disabled = ord(ss_disabled),as_invisible=ord(ss_invisible),
                  as_checked=ord(ss_checked),as_default=ord(ss_default),
//                  as_checkbox=ord(ss_checkbox),as_radiobutton=ord(ss_radiobutton),
                  {as_shortcutcaption,}
                  as_localdisabled,as_localinvisible,as_localchecked,as_localdefault,
                  as_localcaption,
                  as_localimagelist,as_localimagenr,as_localimagecheckedoffset,
                  as_localcolorglyph,as_localcolor,
                  as_localhint,as_localshortcut,as_localtag,
                  as_localgroup,as_localonexecute);
 actionstatesty = set of actionstatety;

 menuactionoptionty = (mao_separator,mao_checkbox,mao_radiobutton,mao_shortcutcaption,
                           mao_asyncexecute,mao_singleregion);
 menuactionoptionsty = set of menuactionoptionty;

const
 actionstatesmask: actionstatesty = [as_disabled,as_checked,as_invisible,as_default];
 actionshapestatesconst = [as_disabled,as_invisible,as_checked,as_default];
 actionshapestates: actionstatesty = actionshapestatesconst;
 actionoptionshapestates: menuactionoptionsty = [mao_separator,mao_checkbox,mao_radiobutton];
 actionoptionshapelshift = ord(ss_separator);

// styleactionstates: actionstatesty = [as_shortcutcaption,as_radiobutton];
 localactionstates: actionstatesty =
                  [as_localdisabled,as_localinvisible,as_localchecked,as_localdefault,
                  as_localcaption,
                  as_localimagelist,as_localimagenr,as_localimagecheckedoffset,
                  as_localcolorglyph,as_localcolor,
                  as_localhint,as_localshortcut,as_localtag,
                  as_localgroup,as_localonexecute];
 localactionlshift = ord(as_localdisabled);
 localactionstatestates: actionstatesty =
                  [as_localdisabled,as_localinvisible,as_localchecked,as_localdefault];
type
 tagmouseprocty = procedure (const tag: integer; const info: mouseeventinfoty) of object;

 shapeinfoty = record
  dim: rectty;
  state: shapestatesty;
  caption: richstringty;
  captionpos: captionposty;
  font: tfont;
  group: integer;
  color: colorty;
  colorglyph: colorty;
  imagenr: integer;
  imagecheckedoffset: integer;
  imagelist: timagelist;
  face: tcustomface;
  tag: integer;
  doexecute: tagmouseprocty;
 end;
 pshapeinfoty = ^shapeinfoty;

 shapeinfoarty = array of shapeinfoty;
 pshapeinfoarty = ^shapeinfoarty;

procedure draw3dframe(const canvas: tcanvas; const arect: rectty; level: integer;
                                 colorinfo: framecolorinfoty);
procedure drawfocusrect(const canvas: tcanvas; const arect: rectty);
procedure drawtoolbutton(const canvas: tcanvas; const info: shapeinfoty);
procedure drawbutton(const canvas: tcanvas; const info: shapeinfoty);
procedure drawmenubutton(const canvas: tcanvas; const info: shapeinfoty;
                           const innerframe: pframety = nil);
procedure drawtab(const canvas: tcanvas; const info: shapeinfoty);
function updatemouseshapestate(var info: shapeinfoty;
                 const mouseevent: mouseeventinfoty;
                 const widget: twidget;
                 const infoarpo: pshapeinfoarty = nil;
                 const canclick: boolean = true): boolean; overload;
function updatemouseshapestate(var infos: shapeinfoarty;
                 const mouseevent: mouseeventinfoty;
                 const widget: twidget): boolean; overload;
         //true on change, calls widget.invalidaterect
function getmouseshape(const infos: shapeinfoarty): integer;
         //returns shape index under mouse, -1 if none
function updatewidgetshapestate(var info: shapeinfoty; const widget: twidget;
                    const adisabled: boolean = false): boolean;
function findshapeatpos(const infoar: shapeinfoarty; const apos: pointty;
               const rejectstates: shapestatesty = [ss_disabled,ss_invisible]): integer;

var
 animatemouseenter: boolean = true;
 
implementation
uses
 classes,msedrawtext,msestockobjects,msebits;

procedure setchecked(var info: shapeinfoty; const value: boolean;
                      const widget: twidget);
begin
 with info do begin
  if value xor (ss_checked in state) then begin
   widget.invalidaterect(dim);
   updatebit({$ifdef FPC}longword{$else}longword{$endif}(info.state),ord(ss_checked),value);
  end;
 end;
end;

function updatewidgetshapestate(var info: shapeinfoty; const widget: twidget;
            const adisabled: boolean = false): boolean;
var
 statebefore: shapestatesty;
begin
 with info do begin
  statebefore:= state;
  updatebit(cardinal(state),ord(ss_disabled),not widget.isenabled or adisabled);
  updatebit(cardinal(state),ord(ss_focused),widget.active);
  result:= state <> statebefore;
  if result then begin
   if ss_widgetorg in state then begin
    widget.invalidaterect(dim,org_widget);
   end
   else begin
    widget.invalidaterect(dim);
   end;
  end;
 end;
end;

procedure updateshapemoveclick(const infoarpo: pshapeinfoarty; value: boolean);
var
 int1: integer;
begin
 if infoarpo <> nil then begin
  for int1:= 0 to high(infoarpo^) do begin
   updatebit({$ifdef FPC}longword{$else}longword{$endif}(infoarpo^[int1].state),
        ord(ss_moveclick),value);
  end;
 end;
end;

function updatemouseshapestate(var info: shapeinfoty;
                 const mouseevent: mouseeventinfoty;
                 const widget: twidget;
                 const infoarpo: pshapeinfoarty = nil;
                 const canclick: boolean = true): boolean;
         //true on change
var
 statebefore: shapestatesty;
 int1: integer;
 po1: pshapeinfoty;
 bo1: boolean;

begin
 result:= false;
 bo1:= (widget = nil) or widget.isenabled;
 with info,mouseevent do begin
  statebefore:= state;
  if es_drag in eventstate then begin
   state:= state - [ss_mouse,ss_clicked];
   updateshapemoveclick(infoarpo,false);
  end
  else begin
   if not (ss_invisible in state) and bo1 then begin
    case eventkind of
     ek_clientmouseleave,ek_mouseleave: begin
      if (eventkind = ek_mouseleave) or not (ss_widgetorg in state) then begin
       state:= state - [ss_mouse,ss_clicked];
       updateshapemoveclick(infoarpo,false);
      end;
     end;
     ek_mousemove,ek_mousepark: begin
      if pointinrect(pos,dim) then begin
       state:= state + [ss_mouse];
       if (ss_left in shiftstate) and
         (state * [ss_disabled,ss_moveclick] = [ss_moveclick]) then begin
        state:= state + [ss_clicked];
       end;
      end
      else begin
       state:= state - [ss_mouse,ss_clicked];
      end;
     end;
     ek_buttonrelease: begin
      if button = mb_left then begin
       updateshapemoveclick(infoarpo,false);
       if state * [ss_clicked,ss_checkbox,ss_radiobutton] = [ss_clicked,ss_checkbox] then begin
        setchecked(info,not (ss_checked in state),widget);
       end;
       if state * [ss_clicked,ss_radiobutton] = [ss_clicked,ss_radiobutton] then begin
        if [ss_checked,ss_checkbox] * state = [ss_checked,ss_checkbox] then begin
         setchecked(info,false,widget);
        end
        else begin
         setchecked(info,true,widget);
         if (infoarpo <> nil) then begin
          for int1:= 0 to high(infoarpo^) do begin
           po1:= @infoarpo^[int1];
           if (po1 <> @info) and (po1^.group = info.group) and
                          (ss_radiobutton in po1^.state) then begin
            setchecked(po1^,false,widget);
           end;
          end;
         end;
        end;
       end;
       if (eventkind = ek_buttonrelease) and (ss_clicked in state) and
            assigned(doexecute) then begin
        state:= state - [ss_clicked];
        result:= true; //state can be invalid after execute
        if widget <> nil then begin //info can be invalid after execute
         widget.invalidaterect(dim);
        end;
        doexecute(tag,mouseevent);
        exit;
       end
       else begin
        state:= state - [ss_clicked];
       end;
      end;
     end;
     ek_buttonpress: begin
      if canclick and (button = mb_left) and 
      (not(ss_disabled in state) or 
             (widget <> nil) and (csdesigning in widget.componentstate)) 
             and pointinrect(pos,dim) then begin
       state:= state + [ss_clicked];
       updateshapemoveclick(infoarpo,true);
      end;
     end;
    end;
   end
   else begin
    state:= state - [ss_mouse,ss_clicked];
   end;
  end;
  result:= result or (state <> statebefore);
  if result and (widget <> nil) then begin
   widget.invalidaterect(dim);
  end;
 end;
end;

function updatemouseshapestate(var infos: shapeinfoarty;
                 const mouseevent: mouseeventinfoty;
                 const widget: twidget): boolean;
var
 int1: integer;
begin
 result:= false;
 for int1:= 0 to high(infos) do begin
  result:= updatemouseshapestate(infos[int1],mouseevent,widget,@infos) or result;
 end;
end;

function getmouseshape(const infos: shapeinfoarty): integer;
         //returns shape index under mouse, -1 if none
var
 int1: integer;
begin
 result:= -1;
 for int1:= 0 to high(infos) do begin
  if ss_mouse in infos[int1].state then begin
   result:= int1;
   break;
  end;
 end;
end;

function findshapeatpos(const infoar: shapeinfoarty; const apos: pointty;
               const rejectstates: shapestatesty = [ss_disabled,ss_invisible]): integer;
var
 int1: integer;
begin
 result:= -1;
 for int1:= 0 to high(infoar) do begin
  with infoar[int1] do begin
   if (state * rejectstates = []) and pointinrect(apos,dim) then begin
    result:= int1;
    break;
   end;
  end;
 end;
end;

procedure draw3dframe(const canvas: tcanvas; const arect: rectty; level: integer;
                                 colorinfo: framecolorinfoty);

type
 cornerinfoty = record
  col1,col2: colorty;
  w1,w2: integer;
 end;

var
 poly: array[0..5] of pointty;

 procedure calculatepoly(w: integer);
 begin
  poly[3].x:= poly[2].x - w;
  poly[3].y:= poly[2].y + w;
  poly[4].x:= poly[1].x + w;
  poly[4].y:= poly[3].y;
  poly[5].x:= poly[4].x;
  poly[5].y:= poly[0].y - w;
 end;

 procedure drawcorner(const cornerinfo: cornerinfoty);
 begin
  with canvas,cornerinfo do begin
   calculatepoly(w1);
   if w1 > 0 then begin
    if w1 = 1 then begin
     drawlines(poly,false,col1,0,3);
    end
    else begin
     fillpolygon(poly,col1);
    end;
   end;
   if w2 > 0 then begin
    poly[0].x:= poly[5].x;
    poly[0].y:= poly[5].y;
    poly[1].x:= poly[0].x;
    poly[1].y:= poly[4].y;
    poly[2].x:= poly[3].x;
    poly[2].y:= poly[1].y;
    calculatepoly(w2);
    if w2 = 1 then begin
     drawlines(poly,false,col2,0,3);
    end
    else begin
     fillpolygon(poly,col2);
    end;
   end;
  end;
 end;

var
 lightcorner,shadowcorner: cornerinfoty;
 down: boolean;
 int1: integer;
begin
 if (level = 0) or (arect.cx = 0) or (arect.cy = 0) then begin
  exit;
 end;
 with colorinfo do begin
  if shadow.effectcolor = cl_default then begin
   shadow.effectcolor:= defaultframecolors.shadow.effectcolor;
  end;
  if shadow.color = cl_default then begin
   shadow.color:= defaultframecolors.shadow.color;
  end;
  if light.color = cl_default then begin
   light.color:= defaultframecolors.light.color;
  end;
  if light.effectcolor = cl_default then begin
   light.effectcolor:= defaultframecolors.light.effectcolor;
  end;
  if shadow.effectwidth < 0 then begin
   shadow.effectwidth:= defaultframecolors.shadow.effectwidth;
  end;
  if light.effectwidth < 0 then begin
   light.effectwidth:= defaultframecolors.light.effectwidth;
  end;
 end;
 if level < 0 then begin
  down:= true;
  level:= -level;
 end
 else begin
  down:= false;
 end;

 with lightcorner,colorinfo.light do begin
  int1:= abs(effectwidth);
  if int1 > level then begin
   col1:= effectcolor;
   w1:= level;
   w2:= 0;
  end
  else begin
   if (effectwidth < 0){ xor down} then begin
    col1:= effectcolor;
    col2:= color;
    w1:= int1;
    w2:= level - int1;
   end
   else begin
    col1:= color;
    col2:= effectcolor;
    w1:= level - int1;
    w2:= int1;
   end;
  end;
 end;
 with shadowcorner,colorinfo.shadow do begin
  int1:= abs(effectwidth);
  if int1 > level then begin
   col1:= color;
   w1:= level;
   w2:= 0;
  end
  else begin
   if level - int1 < int1 then begin //reduce dkshadow
    int1:= level - int1;
   end;
   if (effectwidth < 0){ xor down} then begin
    col1:= effectcolor;
    col2:= color;
    w1:= int1;
    w2:= level-int1;
   end
   else begin
    col1:= color;
    col2:= effectcolor;
    w1:= level-int1;
    w2:= int1;
   end;
  end;
 end;

 with arect do begin
  poly[0].x:= x;
  poly[0].y:= y+arect.cy-1;
  poly[1]:= pos;
  poly[2].x:= x+cx-1;
  poly[2].y:= y;

  if down then begin
   drawcorner(shadowcorner);
  end
  else begin
   drawcorner(lightcorner);
   if level > 2 then begin
    canvas.drawline(pos,makepoint(pos.x+level-1,pos.y+level-1),
                 colorinfo.light.effectcolor);
   end;
  end;
  poly[0].x:= x + cx - level;
  poly[0].y:= y + level-1;
  poly[1].x:= poly[0].x;
  poly[1].y:= y + cy - level;
  poly[2].x:= x + level;
  poly[2].y:= poly[1].y;

  if down then begin
   drawcorner(lightcorner);
  end
  else begin
   drawcorner(shadowcorner);
  end;
 end;
end;

procedure drawfocusrect(const canvas: tcanvas; const arect: rectty);
begin
 canvas.drawxorframe(arect,-1,stockobjects.bitmaps[stb_block1]);
end;

function drawbuttonframe(const canvas: tcanvas; const info: shapeinfoty;
        out clientrect: rectty): boolean; //true if clientrect > 0
var
 level: integer;
begin
 result:= false;
 with canvas,info do begin
  if ss_separator in state then begin
   draw3dframe(canvas,dim,-1,defaultframecolors);
  end
  else begin
   if ss_flat in state then begin
    level:= 0;
   end
   else begin
    level:= 1;
   end;
   if (ss_mouse in state) and not (ss_disabled in state) and 
           (animatemouseenter or (ss_flat in state)) then begin
    inc(level);
   end;
   if (ss_clicked in state) or
        (state * [ss_checked,ss_checkbutton] = [ss_checked,ss_checkbutton])  then begin
    level:= -1;
   end;
   clientrect:= dim;
   if (state * [ss_focused,ss_showdefaultrect] = [ss_focused,ss_showdefaultrect]) or
          (state * [ss_disabled,ss_default] = [ss_default]) then begin
    canvas.drawframe(clientrect,-1,cl_black);
    inflaterect1(clientrect,-1);
   end;
   draw3dframe(canvas,clientrect,level,defaultframecolors);
   inflaterect1(clientrect,-abs(level));
   if (clientrect.cx > 0) and (clientrect.cy > 0) then begin
    result:= true;
    if color <> cl_transparent then begin
     fillrect(clientrect,color);
    end;
    if face <> nil then begin
     face.paint(canvas,clientrect);
    end;
   end;
  end;
 end;
end;

function drawbuttonimage(const canvas: tcanvas; const info: shapeinfoty;
              var arect: rectty; const pos: captionposty): boolean;
var
 align1: alignmentsty;
 rect1: rectty;
 int1: integer;
begin
 with canvas,info do begin
  if (imagelist <> nil) then begin
   result:= true;
   rect1:= arect;
   case pos of
    cp_right: begin
     align1:= [al_right,al_ycentered];
    end;
    cp_left: begin
     align1:= [al_ycentered];
    end
    else begin
     align1:= [al_xcentered,al_ycentered];
    end;
   end;
   if ss_disabled in state then begin
    include(align1,al_grayed);
   end;
   int1:= imagenr;
   if ss_checked in state then begin
    inc(int1,imagecheckedoffset);
   end;
   if colorglyph <> cl_none then begin
    imagelist.paint(canvas,int1,rect1,align1,colorglyph);
   end;
   int1:= imagelist.width;
   case pos of
    cp_right: begin
     dec(arect.cx,int1);
    end;
    cp_left: begin
     inc(arect.x,int1);
     dec(arect.cx,int1);
    end;
   end;
  end
  else begin
   result:= false;
  end;
 end;
end;

procedure drawbuttoncaption(const canvas: tcanvas; const info: shapeinfoty;
        const arect: rectty; const pos: captionposty);
var
 textflags: textflagsty;
 rect1: rectty;
begin
 with canvas,info do begin
  if caption.text <> '' then begin
   rect1:= arect;
   case pos of
    cp_left: begin
     textflags:= [tf_ycentered,tf_clipo];
     inc(rect1.x,2);
     dec(rect1.cx,2);
    end;
    cp_right: begin
     textflags:= [tf_ycentered,tf_right,tf_clipo];
     dec(rect1.cx,2);
    end;
    else begin
     textflags:= [tf_ycentered,tf_xcentered,tf_clipo];
    end;
   end;
   if ss_disabled in state then begin
    include(textflags,tf_grayed);
   end;
   drawtext(canvas,caption,rect1,arect,textflags,font);
  end;
 end;
end;

procedure drawbutton(const canvas: tcanvas; const info: shapeinfoty);
var
 rect1,rect2: rectty;
 pos: captionposty;
begin
 if not (ss_invisible in info.state) and drawbuttonframe(canvas,info,rect1) then begin
  rect2:= rect1;
  case info.captionpos of
   cp_right: begin
    pos:= cp_left;
   end;
   cp_left: begin
    pos:= cp_right;
   end
   else begin
    pos:= cp_center;
   end;
  end;
  drawbuttonimage(canvas,info,rect1,pos);
  with canvas,info do begin
   if state * [ss_focused,ss_showfocusrect] = [ss_focused,ss_showfocusrect] then begin
    drawfocusrect(canvas,inflaterect(rect2,-1));
   end;
   if imagelist = nil then begin
    pos:= captionpos;
   end
   else begin
    if captionpos = cp_center then begin
     pos:= cp_center;
    end
    else begin
     pos:= cp_left;
    end;
   end;
   drawbuttoncaption(canvas,info,rect1,pos);
  end;
 end;
end;

procedure drawtoolbutton(const canvas: tcanvas; const info: shapeinfoty);
var
 rect1: rectty;
begin
 if not (ss_invisible in info.state) and drawbuttonframe(canvas,info,rect1) then begin
  drawbuttonimage(canvas,info,rect1,cp_center);
 end;
end;

function drawbuttoncheckbox(const canvas: tcanvas; const info: shapeinfoty;
              var arect: rectty; const pos: captionposty = cp_left): boolean;
var
 rect1: rectty;
 align1: alignmentsty;
 int1: integer;
begin
 result:= ss_checkbox in info.state;
 if result then begin
  rect1:= arect;
  rect1.cx:= menucheckboxwidth;
  if pos <> cp_left then begin
   inc(rect1.x,arect.cx-rect1.cx);
  end;
  draw3dframe(canvas,rect1,-1,defaultframecolors);
  if pos = cp_left then begin
   inc(arect.x,menucheckboxwidth);
  end;
  dec(arect.cx,menucheckboxwidth);
  if ss_checked in info.state then begin
   if ss_disabled in info.state then begin
    align1:= [al_xcentered,al_ycentered,al_grayed];
   end
   else begin
    align1:= [al_xcentered,al_ycentered];
   end;
   if ss_radiobutton in info.state then begin
    int1:= ord(stg_checkedradio);
   end
   else begin
    int1:= ord(stg_checked);
   end;
   stockobjects.glyphs.paint(canvas,int1,rect1,align1,info.colorglyph);
  end;
 end;
end;

procedure drawmenuarrow(const canvas: tcanvas; const info: shapeinfoty; rect: rectty);
var
 alignment: alignmentsty;
 int1: integer;
begin
 if not (ss_horz in info.state) then begin
  alignment:= [al_xcentered,al_ycentered];
  int1:= menuarrowwidth;
  if ss_disabled in info.state then begin
   include(alignment,al_grayed);
   inc(int1);
  end;
  with rect do begin
   x:= x + cx - int1;
   cx:= int1;
  end;
  stockobjects.glyphs.paint(canvas,ord(stg_arrowrightsmall),rect,alignment,
                                  info.colorglyph);
 end;
end;

procedure drawmenubutton(const canvas: tcanvas; const info: shapeinfoty;
                  const innerframe: pframety = nil);
var
 rect1: rectty;
begin
 if not (ss_invisible in info.state) and drawbuttonframe(canvas,info,rect1) then begin
  drawbuttonimage(canvas,info,rect1,cp_left);
  drawbuttoncheckbox(canvas,info,rect1,cp_right);
  if ss_submenu in info.state then begin
   drawmenuarrow(canvas,info,rect1);
  end;
  if innerframe <> nil then begin
   deflaterect1(rect1,innerframe^);
  end;
  drawbuttoncaption(canvas,info,rect1,cp_left);
 end;
end;

procedure drawtab(const canvas: tcanvas; const info: shapeinfoty);
var
 int1: integer;
 color1: colorty;
begin
 with canvas,info do begin
  drawmenubutton(canvas,info);
  if not (ss_checked in state) then begin
   if ss_opposite in state then begin
    color1:= defaultframecolors.shadow.color;
   end
   else begin
    color1:= defaultframecolors.light.effectcolor;
   end;
  end
  else begin
   color1:= color;
  end;
  if ss_vert in state then begin
   if ss_opposite in state then begin
    int1:= dim.x;
   end
   else begin
    int1:= dim.x+dim.cx-1;
   end;
   canvas.drawline(makepoint(int1,dim.y),makepoint(int1,dim.y+dim.cy-1),color1);
  end
  else begin
   if ss_opposite in state then begin
    int1:= dim.y;
   end
   else begin
    int1:= dim.y+dim.cy-1;
   end;
   canvas.drawline(makepoint(dim.x,int1),makepoint(dim.x+dim.cx-1,int1),color1);
  end;
 end;
end;

end.

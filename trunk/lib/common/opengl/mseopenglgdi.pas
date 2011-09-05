{ MSEgui Copyright (c) 2011 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit mseopenglgdi;
//
//under construction
//
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface
uses
 msegl,mseglext,mseglu,{$ifdef unix}mseglx,x,xlib,xutil,msectypes,{$else}windows,{$endif}
 msegraphics,msetypes,msegraphutils,mseguiglob,mseglextglob;
{
const
 GL_BGRA = GL_BGRA_EXT;
}
const
 glpixelshift = -0.5;
 gltopshift = -1;
 
type
 contextattributesty = record
  buffersize: integer;
  level: integer;
  doublebuffer: boolean;
  rgba: boolean;
  stereo: boolean;
  auxbuffers: integer;
  redsize: integer;
  greensize: integer;
  bluesize: integer;
  alphasize: integer;
  depthsize: integer;
  stencilsize: integer;
  accumredsize: integer;
  accumgreensize: integer;
  accumbluesize: integer;
  accumalphasize: integer;
 end;

 contextinfoty = record
//  viewport: rectty;
  attrib: contextattributesty;
 {$ifdef unix}
  visualattributes: integerarty;
 {$endif}
 end;
 pcontextinfoty = ^contextinfoty;
 
 oglgcdty = record
  {$ifdef unix}
  fcontext: glxcontext;
  fdpy: pdisplay;
  fcolormap: tcolormap;
  fscreen: integer;
  fkind: gckindty;
  fvisinfo: pxvisualinfo;
  {$else}
  fdc: hdc;
  fcontext: hglrc;
  {$endif}
  pd: paintdevicety;
  extensions: glextensionsty;
  gclineoptions: lineoptionsty;
  top: integer; //y 0 coord value
  glfont: fontty;
  tess: pglutesselator;
  glcolorforeground: rgbtriplety;
  glcolorbackground: rgbtriplety;
  gcrasterop: rasteropty;
 end;

 {$if sizeof(oglgcdty) > sizeof(gcpty)} {$error 'buffer overflow'}{$endif}

 oglgcty =  record
  case integer of
   0: (d: oglgcdty;);
   1: (_bufferspace: gcpty;);
 end;
{ 
function createrendercontext(const aparent: winidty; const windowrect: rectty;
                                   const ainfo: contextinfoty;
                                   var gc: gcty; out aid: winidty): guierrorty;
}
function openglgetgdifuncs: pgdifunctionaty;
//function openglgetgdinum: integer;

function gdi_choosevisual(var gc: gcty;
                                 const contextinfo: contextinfoty): gdierrorty;
procedure gdi_makecurrent(var drawinfo: drawinfoty);
procedure gdi_setviewport(var drawinfo: drawinfoty);
procedure gdi_swapbuffers(var drawinfo: drawinfoty);
procedure gdi_clear(var drawinfo: drawinfoty);

implementation
uses
 mseguiintf,{mseftgl,}msegenericgdi,msestrings,msehash,sysutils,
 mseformatstr,msefontcache,mseftfontcache,mseopengl;
type
 tcanvas1 = class(tcanvas);
 
 gluvertexty = packed record
  x: double;
  y: double;
  z: double;
 end;
 pgluvertexty = ^gluvertexty;
 ppgluvertexty = ^pgluvertexty;
{ 
 ftglfontty = record
  handle: pftglfont;
 end;
 pftglfontty = ^ftglfontty;
}
{
 cachefontty = record
 end;
 pcachefontty = ^cachefontty;
}
{
 fontcachehdataty = record
  height: integer;
  name: string;
 end;
}
 tglftfontcache = class(tftfontcache)
  protected
   procedure drawglyph(var drawinfo: drawinfoty; const pos: pointty;
                                      const bitmap: pbitmapdataty); override;
  public
   procedure drawstring16(var drawinfo: drawinfoty;
                                    const afont: fontty); override;
 end;
   
var
 ffontcache: tglftfontcache;
// gdinumber: integer;

function fontcache: tglftfontcache;
begin
 if ffontcache = nil then begin
  tglftfontcache.create(ffontcache);
 end;
 result:= ffontcache;
end;

type
 glcolorty = record
  r,g,b,a: glclampf;
 end;

procedure putboolean(var ar1: integerarty; var index: integer;
                             const atag: integer; const avalue: boolean);
begin
 if avalue then begin
  if index > high(ar1) then begin
   setlength(ar1,19+high(ar1)*2);
  end;
  ar1[index]:= atag;
  inc(index);
 end;
end; 

procedure putvalue(var ar1: integerarty; var index: integer;
                             const atag,avalue,defaultvalue: integer);
begin
 if avalue <> defaultvalue then begin
  if index > high(ar1) then begin
   setlength(ar1,19+high(ar1)*2);
  end;
  ar1[index]:= atag;
  inc(index);
  ar1[index]:= avalue;
  inc(index);
 end;
end;

procedure makecurrent(const gc: gcty);
begin
 with oglgcty(gc.platformdata).d do begin
{$ifdef unix}
  glxmakecurrent(fdpy,pd,fcontext);
{$else}
  wglmakecurrent(fdc,fcontext);
{$endif}
 end;
end;

procedure setviewport(const agc: gcty; const arect: rectty);
var
 int1: integer;
begin
 with arect do begin
  glviewport(x,oglgcty(agc.platformdata).d.top-gltopshift-y-cy,cx,cy);
  glloadidentity;
  if (cx > 0) and (cy > 0) then begin
   glortho(glpixelshift,cx+glpixelshift,glpixelshift,cy+glpixelshift,-1,1);
//   glortho(0,cx,0,cy,-1,1);
//   glortho(-0.5,cx-0.5,-0.5,cy-1,-1,1);
//   glortho(-1,cx-1,cy-1,-1,-1,1);
  end;
 end;
end;

procedure gdi_setviewport(var drawinfo: drawinfoty);
begin
 setviewport(drawinfo.gc,drawinfo.rect.rect^);
end;

procedure initcontext(const winid: winidty; var gc: gcty;
              const sourceviewport: rectty);
begin
 gc.gdifuncs:= openglgetgdifuncs; 
 if winid <> 0 then begin
  with oglgcty(gc.platformdata).d do begin
 //  pd:= winid;
   top:= sourceviewport.cy+gltopshift;
   tess:= glunewtess();
  end;
  makecurrent(gc);
  glclearstencil(0);
  glclear(gl_stencil_buffer_bit);
  setviewport(gc,sourceviewport);
  glpushattrib(gl_color_buffer_bit); //no mesa glflush until the first glpopattrib?
  glpopattrib();
 end;
end;
 
var
 gccount: integer;

function gdi_choosevisual(var gc: gcty;
                                 const contextinfo: contextinfoty): gdierrorty;
{$ifdef unix}
var
 index: integer;
 ar1: integerarty;
 int1,int2: integer;
{$endif}
begin
 result:= gde_ok;
{$ifdef unix}
 with oglgcty(gc.platformdata).d do begin
  fvisinfo:= nil;
  fdpy:= msedisplay;
  fscreen:= defaultscreen(fdpy);
  if not glxqueryextension(fdpy,int1,int2) then begin
   result:= gde_noglx;
   exit;
  end;
  index:= 0;
  with contextinfo.attrib do begin
   putvalue(ar1,index,glx_level,level,0);
   if df_canvasismonochrome in gc.drawingflags then begin
    putvalue(ar1,index,glx_buffer_size,1,-1);
   end
   else begin
    if not (df_canvasispixmap in gc.drawingflags) then begin
     if doublebuffer then begin
      include(gc.drawingflags,df_doublebuffer);
      putboolean(ar1,index,glx_doublebuffer,doublebuffer);
     end;
    end;
    putvalue(ar1,index,glx_buffer_size,buffersize,-1);
//    putvalue(ar1,index,glx_level,level,0);
    putboolean(ar1,index,glx_rgba,rgba);
    putboolean(ar1,index,glx_stereo,stereo);
    putvalue(ar1,index,glx_aux_buffers,auxbuffers,-1);
    putvalue(ar1,index,glx_red_size,redsize,-1);
    putvalue(ar1,index,glx_green_size,greensize,-1);
    putvalue(ar1,index,glx_blue_size,bluesize,-1);
    putvalue(ar1,index,glx_alpha_size,alphasize,-1);
    putvalue(ar1,index,glx_depth_size,depthsize,-1);
    putvalue(ar1,index,glx_stencil_size,stencilsize,-1);
    putvalue(ar1,index,glx_accum_red_size,accumredsize,-1);
    putvalue(ar1,index,glx_accum_green_size,accumgreensize,-1);
    putvalue(ar1,index,glx_accum_blue_size,accumbluesize,-1);
    putvalue(ar1,index,glx_accum_alpha_size,accumalphasize,-1);
   end;
  end;
  setlength(ar1,index+1); //none
  fvisinfo:= glxchoosevisual(fdpy,fscreen,pinteger(ar1));
//  fvisinfo:= glxchoosevisual(fdpy,fscreen,pinteger(ar1));
  if fvisinfo = nil then begin
   result:= gde_novisual;
   exit;
  end;
  fcolormap:= xcreatecolormap(fdpy,mserootwindow,fvisinfo^.visual,allocnone);
 end;
{$endif}
end;
(* 
{$ifdef unix}

function createrendercontext(const aparent: winidty; const windowrect: rectty;
                                   const ainfo: contextinfoty;
                                   var gc: gcty; out aid: winidty): guierrorty;
var
 attributes: txsetwindowattributes;
 err: gdierrorty;
 
begin
 result:= gue_ok;
 with oglgcty(gc.platformdata).d do begin
  err:= gdi_choosevisual(gc,ainfo);
  if err <> gde_ok then begin
   case err of
    gde_noglx: begin
     result:= gue_noglx;
    end;
   end;
   exit;
  end;
  if fvisinfo = nil then begin
   result:= gue_novisual;
   exit;
  end;
  try
   fcontext:= glxcreatecontext(fdpy,fvisinfo,nil,true);
   if fcontext = nil then begin
    result:= gue_rendercontext;
    exit;
   end;
   gc.handle:= ptruint(fcontext);
//   fcolormap:= xcreatecolormap(fdpy,mserootwindow,fvisinfo^.visual,allocnone);
   attributes.colormap:= fcolormap;
   with windowrect do begin
    aid:= xcreatewindow(fdpy,aparent,x,y,cx,cy,0,fvisinfo^.depth,
          inputoutput,fvisinfo^.visual,cwcolormap,@attributes);
    xselectinput(fdpy,aid,exposuremask); //will be mapped to parent
   end;
   if aid = 0 then begin
    result:= gue_createwindow;
    exit;
   end;
   pd:= aid;
  // fwin:= aid;
  finally
   xfree(fvisinfo);
   fvisinfo:= nil;
  end;
 end;
 initcontext(aid,gc,windowrect);
end;
{$endif}

{$ifdef mswindows}
function createrendercontext(const aparent: winidty; const windowrect: rectty;
                                   const ainfo: contextinfoty;
                                   var gc: gcty; out aid: winidty): guierrorty;
var
 pixeldesc: tpixelformatdescriptor;
 int1: integer; 
 options1: internalwindowoptionsty;
 wi1: windowty;
begin
 result:= gue_ok;
 fillchar(options1,sizeof(options1),0);
 options1.parent:= aparent;
 guierror(gui_createwindow(windowrect,options1,wi1));
 aid:= wi1.id;
 if aid = 0 then begin
  result:= gue_createwindow;
  exit;
 end;
 with oglgcty(gc.platformdata).d do begin
  pd:= aid;
  fdc:= getdc(aid);
  fillchar(pixeldesc,sizeof(pixeldesc),0);
  with pixeldesc do begin
   nsize:= sizeof(pixeldesc);
   nversion:= 1;
   dwflags:= pfd_draw_to_window or pfd_support_opengl or pfd_doublebuffer;
   ipixeltype:= pfd_type_rgba;
   ccolorbits:= 24;
   cdepthbits:= 32;
  end;
  int1:= choosepixelformat(fdc,@pixeldesc);
  setpixelformat(fdc,int1,@pixeldesc);
  fcontext:= wglcreatecontext(fdc);
  if fcontext = 0 then begin
   result:= gue_rendercontext;
   exit;
  end;
  gc.handle:= ptruint(fcontext);
 end;
 initcontext(aid,gc,windowrect);
end;
{$endif}
*)

procedure colortogl(const source: colorty; out dest: glcolorty);
var
 co1: rgbtriplety;
begin
 co1:= colortorgb(source);
 dest.r:= co1.red/255;
 dest.g:= co1.green/255;
 dest.b:= co1.blue/255;
 dest.a:= 0;
end;

procedure sendrect(const drawinfo: drawinfoty; const arect: rectty);
var
 startx,starty,endx,endy: real;
 
begin
 with drawinfo,oglgcty(gc.platformdata).d,arect do begin
  startx:= (x+origin.x)+glpixelshift;
  endx:= startx+cx;
  starty:= (top-gltopshift-(y+origin.y))+glpixelshift;
  endy:= starty-cy;
//  glvertex2iv(@pos);
  glvertex2f(startx,starty);
  glvertex2f(endx,starty);
  glvertex2f(endx,endy);
  glvertex2f(startx,endy);
 end;
end;

procedure gdi_makecurrent(var drawinfo: drawinfoty);
begin
 with oglgcty(drawinfo.gc.platformdata).d do begin
{$ifdef unix}
//  glxmakecurrent(fdpy,drawinfo.paintdevice,fcontext);
  glxmakecurrent(fdpy,pd,fcontext);
{$else}
  wglmakecurrent(fdc,fcontext);
{$endif}
 end;
end;

{$ifdef unix}
var
 linkgc: glxcontext;
{$endif}
var
 screenextensions: glextensionsty;
 screenextensionschecked: boolean;
 pixmapextensions: glextensionsty;
 pixmapextensionschecked: boolean;

procedure gdi_creategc(var drawinfo: drawinfoty); //gdifunc
var
 device1: ptruint; //used for extension query 
{$ifdef unix}
 attributes: txsetwindowattributes;
{$else}
 pixeldesc: tpixelformatdescriptor;
 int1: integer; 
 options1: internalwindowoptionsty;
 wi1: windowty;
{$endif}
begin
 if gccount = 0 then begin
  initializeopengl([]);
 end;
 with drawinfo.creategc,oglgcty(gcpo^.platformdata).d do begin
  error:= gdi_choosevisual(gcpo^,pcontextinfoty(contextinfopo)^);
  if error <> gde_ok then begin
   exit;
  end;
 {$ifdef unix}
  if fvisinfo = nil then begin
   error:= gde_novisual;
   exit;
  end;
  if linkgc = nil then begin
   linkgc:= glxcreatecontext(fdpy,fvisinfo,nil,true);
  end;
  try
   fcontext:= glxcreatecontext(fdpy,fvisinfo,nil,true);
  (*
   fcontext:= glxcreatecontext(fdpy,visinfo,linkgc,false{kind <> gck_pixmap}{true});
                      //crashes on suse 11.1 with true on pixmap
   *)
   if fcontext = nil then begin
    error:= gde_rendercontext;
    exit;
   end;
   device1:= 0; //not used
   inc(gccount);
   gcpo^.handle:= ptruint(fcontext);
   fkind:= kind;
   if kind = gck_pixmap then begin
    pd:= 0;
    pd:= glxcreateglxpixmap(fdpy,fvisinfo,paintdevice);
    if pd = 0 then begin
     error:= gde_glxpixmap;
    end;
   end
   else begin
    if paintdevice = 0 then begin
     if createpaintdevice then begin
      with windowrect^ do begin
       fcolormap:= xcreatecolormap(fdpy,mserootwindow,fvisinfo^.visual,
                                                                 allocnone);
       attributes.colormap:= fcolormap;
       paintdevice:= xcreatewindow(fdpy,parent,x,y,cx,cy,0,fvisinfo^.depth,
             inputoutput,fvisinfo^.visual,cwcolormap,@attributes);
       if paintdevice = 0 then begin
        error:= gde_createwindow;
        exit;
       end;
       xselectinput(fdpy,paintdevice,exposuremask); //will be mapped to parent
       gcpo^.paintdevicesize:= size;
      end;
     end;
    end
    else begin
     fcolormap:= xcreatecolormap(fdpy,mserootwindow,fvisinfo^.visual,allocnone);
     xsetwindowcolormap(fdpy,paintdevice,fcolormap);
    end;
    pd:= paintdevice;
   end;
  finally
   xfree(fvisinfo);
  end;
 {$else}
  error:= gde_ok;
//  fkind:= kind;
  if paintdevice = 0 then begin
   if createpaintdevice then begin
    fillchar(options1,sizeof(options1),0);
    options1.parent:= parent;
    if gui_createwindow(windowrect^,options1,wi1) <> gue_ok then begin
     error:= gde_createwindow;
     exit;
    end;
    paintdevice:= wi1.id;
    gcpo^.paintdevicesize:= windowrect^.size;
   end;
  end;
  pd:= paintdevice;
  fdc:= getdc(pd);
  device1:= fdc;
  fillchar(pixeldesc,sizeof(pixeldesc),0);
  with pixeldesc do begin
   nsize:= sizeof(pixeldesc);
   nversion:= 1;
   dwflags:= pfd_draw_to_window or pfd_support_opengl or pfd_doublebuffer;
   ipixeltype:= pfd_type_rgba;
   ccolorbits:= 24;
   cdepthbits:= 32;
  end;
  int1:= choosepixelformat(fdc,@pixeldesc);
  setpixelformat(fdc,int1,@pixeldesc);
  fcontext:= wglcreatecontext(fdc);
  if fcontext = 0 then begin
   error:= gde_rendercontext;
   exit;
  end;
  inc(gccount);
  gcpo^.handle:= ptruint(fcontext);
 {$endif}
  if error = gde_ok then begin
   initcontext(paintdevice,gcpo^,mr(nullpoint,gcpo^.paintdevicesize));
   if paintdevice <> 0 then begin
    if (kind = gck_pixmap) then begin
     if not pixmapextensionschecked then begin
      makecurrent(gcpo^);
      pixmapextensions:= gldeviceextensions(device1) +
                            mseglparseextensions(glgetstring(gl_extensions));
      pixmapextensionschecked:= true;
     end;
     extensions:= pixmapextensions;
    end
    else begin
     if not screenextensionschecked then begin
      makecurrent(gcpo^);
      screenextensions:= gldeviceextensions(device1) +
                        mseglparseextensions(glgetstring(gl_extensions));
      screenextensionschecked:= true;
     end;
     extensions:= screenextensions;
    end;
   end;
  end;
 end;
end;

procedure gdi_destroygc(var drawinfo: drawinfoty); //gdifunc
begin
 with oglgcty(drawinfo.gc.platformdata).d do begin
  if tess <> nil then begin
   gludeletetess(tess);
  end;
{$ifdef unix}
  glxmakecurrent(fdpy,0,nil);
  glxdestroycontext(fdpy,fcontext);
  if drawinfo.paintdevice <> 0 then begin
   if fkind = gck_pixmap then begin
    glxdestroyglxpixmap(fdpy,pd);
    pd:= 0;
   end
   else begin
    xfreecolormap(fdpy,fcolormap);
   end;
  end;
  dec(gccount);
  if (gccount = 0) and (linkgc <> nil) then begin
   glxdestroycontext(fdpy,linkgc);
   linkgc:= nil;
  end;
{$else}
  wglmakecurrent(0,0);
  wgldeletecontext(fcontext);
  releasedc(drawinfo.paintdevice,fdc);
  dec(gccount);
{$endif}
  if gccount = 0 then begin
   releaseopengl();
   screenextensionschecked:= false;
   pixmapextensionschecked:= false;
  end;
 end;
end;

procedure gdi_swapbuffers(var drawinfo: drawinfoty);
begin
 with oglgcty(drawinfo.gc.platformdata).d do begin
 {$ifdef unix}
  glxswapbuffers(fdpy,drawinfo.paintdevice);
 {$else}
  swapbuffers(fdc);
 {$endif}
 end;
end;

procedure gdi_clear(var drawinfo: drawinfoty);
var
 co1: glcolorty;
begin
 with oglgcty(drawinfo.gc.platformdata).d do begin
  colortogl(drawinfo.color.color,co1);
  glclearcolor(co1.r,co1.g,co1.b,co1.a);
  glclear(gl_color_buffer_bit);
  
 end;
end;

{***************}

const
 rops: array[rasteropty] of integer = (
 //rop_clear, rop_and, rop_andnot,     rop_copy,
   gl_clear,  gl_and,  gl_and_reverse, gl_copy,
 //rop_notand,      rop_nop, rop_xor, rop_or,
   gl_and_inverted, gl_noop, gl_xor,  gl_or,
 //rop_nor, rop_notxor, rop_not,   rop_ornot,
   gl_nor,  gl_equiv,   gl_invert, gl_or_reverse,
 //rop_notcopy,      rop_notor,      rop_nand, rop_set
   gl_copy_inverted, gl_or_inverted, gl_nand,   gl_set
 );
 
procedure setlogicop(const rasterop: rasteropty; const gc: gcty);
begin
 if rasterop = rop_copy then begin
  gllogicop(gl_copy);
  if df_canvasismonochrome in gc.drawingflags then begin
   gldisable(gl_index_logic_op);
  end
  else begin
   gldisable(gl_color_logic_op);
  end;
 end
 else begin
  if df_canvasismonochrome in gc.drawingflags then begin
   glenable(gl_index_logic_op);
  end
  else begin
   glenable(gl_color_logic_op);
  end;
  gllogicop(rops[rasterop]);
 end;
end;
 
procedure gdi_changegc(var drawinfo: drawinfoty);
var
 po1: pstripety;
 int1,int2,int3,int4: integer;
 y1,x1: integer;
begin
 with drawinfo.gcvalues^,oglgcty(drawinfo.gc.platformdata).d do begin
  if gvm_colorforeground in mask then begin
   glcolorforeground:= rgbtriplety(colorforeground);
   with glcolorforeground do begin
    glcolor3ub(red,green,blue);
   end;
  end;
  if gvm_colorbackground in mask then begin
   glcolorbackground:= rgbtriplety(colorbackground);
  end;
  if gvm_rasterop in mask then begin
   setlogicop(rasterop,drawinfo.gc);
   gcrasterop:= rasterop;
  end;
  if gvm_lineoptions in mask then begin
   if (lio_antialias in lineinfo.options) xor 
                (lio_antialias in gclineoptions) then begin
    if lio_antialias in lineinfo.options then begin
     glenable(gl_line_smooth);
     glenable(gl_blend);
     glblendfunc(gl_src_alpha,gl_one_minus_src_alpha);
    end
    else begin
     gldisable(gl_line_smooth);
     gldisable(gl_blend);
    end;
   end;
   gclineoptions:= lineinfo.options;
  end;
  if gvm_font in mask then begin
//   ftglfont:= pftglfontty(font)^;
   glfont:= font;
  end;
  if gvm_clipregion in mask then begin
   if clipregion = 0 then begin
    gldisable(gl_stencil_test);
   end
   else begin
    glclearstencil(0);
    glclear(gl_stencil_buffer_bit);
    glenable(gl_stencil_test);
    glstencilfunc(gl_never,1,1);
    glstencilop(gl_replace,gl_keep,gl_keep);
    with pregioninfoty(clipregion)^ do begin
     if rectcount > 0 then begin
      glbegin(gl_quads);
      y1:= top-stripestart;
      po1:= datapo;      
      for int1:= stripecount-1 downto 0 do begin
       int3:= y1;
       x1:= 0;
       y1:= y1 - po1^.header.height; //next stripe
       int2:= po1^.header.rectcount -1;
       po1:= @po1^.data;
       for int2:= int2 downto 0 do begin
        x1:= x1 + prectextentty(po1)^; //gap
        glvertex2i(x1,int3);
        inc(prectextentty(po1));
        int4:= x1;
        x1:= x1 + prectextentty(po1)^;
        glvertex2i(x1,int3);
        glvertex2i(x1,y1);
        glvertex2i(int4,y1);
        inc(prectextentty(po1));
       end;
      end;
      glend;
     end;
    end;
    glstencilop(gl_keep,gl_keep,gl_keep);
    glstencilfunc(gl_equal,1,1);
   end;
  end;
 end;
end;

procedure gdi_getcanvasclass(var drawinfo: drawinfoty); //gdifunc
begin
 with drawinfo.getcanvasclass do begin
  if not monochrome then begin
   canvasclass:= topenglwindowcanvas;
  end;
 end;
end;

procedure gdi_endpaint(var drawinfo: drawinfoty); //gdifunc
begin
 if df_doublebuffer in drawinfo.gc.drawingflags then begin
  gdi_swapbuffers(drawinfo);
 end
 else begin
  glflush();
 end;
end;

procedure gdi_flush(var drawinfo: drawinfoty); //gdifunc
begin
 glflush();
end;

procedure gdi_drawlines(var drawinfo: drawinfoty);
var
 po1: ppointty;
 int1,int2: integer;
begin
 int2:= oglgcty(drawinfo.gc.platformdata).d.top;
 with drawinfo,points do begin
  if closed then begin
   glbegin(gl_line_loop);
  end
  else begin
   glbegin(gl_line_strip);
  end;
  po1:= points;
  for int1:= count-1 downto 0 do begin
   glvertex2i(po1^.x+origin.x,int2-(po1^.y+origin.y));
   inc(po1);
  end;
 end;
 glend;
end;

procedure gdi_drawlinesegments(var drawinfo: drawinfoty);
var
 po1: ppointty;
 int1,int2: integer;
begin
 int2:= oglgcty(drawinfo.gc.platformdata).d.top;
 glbegin(gl_lines);
 with drawinfo,points do begin
  po1:= points;
  for int1:= count-1 downto 0 do begin
   glvertex2i(po1^.x+origin.x,int2-(po1^.y+origin.y));
   inc(po1);
  end;
 end;
 glend;
end;

procedure drawlines(const gc: gcty; const points: pfpointty;
                                 const count: integer; const close: boolean);
var
 po1: pfpointty;
 int1,int2: integer;
begin
 int2:= oglgcty(gc.platformdata).d.top;
 if close then begin
  int1:= gl_line_loop;
 end
 else begin
  int1:= gl_line;
 end;
 glbegin(int1);
 po1:= points;
 for int1:= count-1 downto 0 do begin
  glvertex2f(po1^.x,int2-po1^.y);
  inc(po1);
 end;
 glend;
end;

procedure gdi_drawellipse(var drawinfo: drawinfoty);
begin
 segmentellipsef(drawinfo,@drawlines);
end;

procedure gdi_drawarc(var drawinfo: drawinfoty);
begin
 gdinotimplemented;
end;

procedure gdi_fillrect(var drawinfo: drawinfoty);
begin 
 glbegin(gl_quads);
 sendrect(drawinfo,drawinfo.rect.rect^);
 glend;
end;

procedure gdi_fillelipse(var drawinfo: drawinfoty);
begin
 gdinotimplemented;
end;

procedure gdi_fillarc(var drawinfo: drawinfoty);
begin
 gdinotimplemented;
end;

procedure tesserror(err: glenum); {$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
begin
end;

type
 vertexpoar4ty = array[0..3] of pgluvertexty;
 pvertexpoar4ty = ^vertexpoar4ty;
 glfloatar4ty = array[0..3] of glfloat;
 pglfloatar4ty = ^glfloatar4ty;

var
 tessbuffer: array of pgluvertexty;
 tessbufferindex: integer;

function gettessbuffer: pgluvertexty;
var
 int1: integer;
begin
 if tessbufferindex > high(tessbuffer) then begin
  setlength(tessbuffer,high(tessbuffer)*2+32);
  for int1:= tessbufferindex to high(tessbuffer) do begin
   getmem(tessbuffer[int1],sizeof(gluvertexty));
  end;
  result:= tessbuffer[tessbufferindex];
 end;
 result:= tessbuffer[tessbufferindex];
 inc(tessbufferindex);
end;

procedure freetessbuffer;
var
 int1: integer;
begin
 for int1:= high(tessbuffer) downto 0 do begin
  freemem(tessbuffer[int1]);
 end;
end; 

procedure tesscombine(coords: pgluvertexty;
                      vertex_data: pvertexpoar4ty;
                      weight: pglfloatar4ty;
                      outdata: ppgluvertexty;
                      polygon_data: pointer);
                           {$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
//var
// po1: pgluvertexty;
begin
// po1:= gettessbuffer; //not used
// po1^:= coords^;
// outdata^:= po1;
 outdata^:= coords;
end;

procedure gdi_fillpolygon(var drawinfo: drawinfoty);
var
 int1: integer;
 do1: double;
// vertex: gluvertexty;
 po1: ppointty;
 po2: pgluvertexty;
begin
 with drawinfo,points,oglgcty(drawinfo.gc.platformdata).d do begin
  glutesscallback(tess, glu_tess_error, tcallback(@tesserror));
  glutesscallback(tess, glu_tess_begin, tcallback(glbegin));
  glutesscallback(tess, glu_tess_vertex, tcallback(glvertex3dv));
  glutesscallback(tess, glu_tess_combine_data, tcallback(@tesscombine));
  glutesscallback(tess, glu_tess_end, tcallback(glend));
  po1:= points;
  allocbuffer(drawinfo.buffer,count*sizeof(gluvertexty));
  tessbufferindex:= 0;
  po2:= drawinfo.buffer.buffer;
  do1:= top;
  glutessbeginpolygon(tess,@drawinfo.gc);
  glutessbegincontour(tess);
  for int1:= count-1 downto 0 do begin
   with po2^ do begin
    x:= po1^.x+origin.x;
    y:= do1-(po1^.y+origin.y);
    z:= 0;
   end;
   glutessvertex(tess,p3darray(po2)^,po2);
   inc(po1);
   inc(po2);
  end;
  glutessendcontour(tess);
  glutessendpolygon(tess);
 end;
end;

procedure gdi_drawstring16(var drawinfo: drawinfoty);
begin
 fontcache.drawstring16(drawinfo,
         oglgcty(drawinfo.gc.platformdata).d.glfont);
end;

procedure gdi_setcliporigin(var drawinfo: drawinfoty);
begin
end;

procedure copyareaself(var drawinfo: drawinfoty);
var
 xscale,yscale: real;
begin
 with drawinfo.copyarea,oglgcty(drawinfo.gc.platformdata).d do begin
  with destrect^ do begin
   glpushattrib(gl_pixel_mode_bit);
   xscale:= cx/sourcerect^.cx;
   yscale:= cy/sourcerect^.cy;
   glrasterpos2i(x,(top-y-cy));
   glpixelzoom(xscale,yscale);
   with sourcerect^ do begin
    glcopypixels(x,top-y-cy,cx,cy,gl_color);
   end;
   glpopattrib;
  end;
 end;
end;

procedure setrasterpos(const agc: gcty; const apos: pointty);
begin
 glrasterpos2f(0.999*glpixelshift,0.999*glpixelshift);
 glbitmap(0,0,0,0,apos.x,oglgcty(agc.platformdata).d.top-apos.y,nil);
end;
procedure copyareagl(var drawinfo: drawinfoty);
//todo: use persistent pixmap or texture buffer
//suse 11.4 crashes with dri shared buffers and does 
//not support non dri shared buffers...
//suse 11.1 crashes with dri pixmaps...

var
// buf: gluint;
 xscale,yscale: real;
 ar1: rgbtriplearty;
 l,t,r,b,w,h: integer;
 pt1: pointty;
 int1: integer;
 
begin
 with drawinfo.copyarea,oglgcty(drawinfo.gc.platformdata).d do begin
  makecurrent(tcanvas1(source).fdrawinfo.gc);
  with sourcerect^ do begin
   setlength(ar1,cx*cy);
   glreadpixels(x,
          oglgcty(tcanvas1(source).fdrawinfo.gc.platformdata).d.top-y-cy+1,
                                  cx,cy,gl_rgba,gl_unsigned_byte,pointer(ar1));
  end;
  makecurrent(drawinfo.gc);
  glpushattrib(gl_pixel_mode_bit);
  with destrect^ do begin
   xscale:= cx/sourcerect^.cx;
   yscale:= cy/sourcerect^.cy;
   glpixelzoom(xscale,yscale);
   setrasterpos(drawinfo.gc,mp(x,y+cy-1));
   gldrawpixels(sourcerect^.cx,sourcerect^.cy,gl_rgba,gl_unsigned_byte,
                                                                 pointer(ar1));
  end;
  glpopattrib;
 end;
(* buffer objects are unreliable
 with drawinfo.copyarea,oglgcty(drawinfo.gc.platformdata).d do begin
  makecurrent(tcanvas1(source).fdrawinfo.gc);
  glgenbuffers(1,@buf);
  glpushclientattrib(gl_client_pixel_store_bit);
  glpushattrib(gl_pixel_mode_bit);
  glpixeltransferf(gl_alpha_scale,0);
  glpixeltransferf(gl_alpha_bias,1);
  with sourcerect^ do begin
   glbufferdata(gl_pixel_pack_buffer,cx*cy*sizeof(rgbtriplety),nil,gl_stream_draw);
   glbindbuffer(gl_pixel_pack_buffer,buf);
   glreadpixels(x,sourceheight-y-cy,cx,cy,gl_bgra,gl_unsigned_byte,nil);
  end;
  glbindbuffer(gl_pixel_pack_buffer,0);
  makecurrent(drawinfo.gc);
  glbindbuffer(gl_pixel_unpack_buffer,buf);
  with destrect^ do begin
   xscale:= cx/sourcerect^.cx;
   yscale:= cy/sourcerect^.cy;
   glrasterpos2i(x,(sourceheight-y-cy));
   glpixelzoom(xscale,yscale);
  end;
  with sourcerect^ do begin
//glbindbuffer(gl_pixel_unpack_buffer,0);

   gldrawpixels(cx,cy,gl_bgra,gl_unsigned_byte,nil);
  end;
  glbindbuffer(gl_pixel_unpack_buffer,0);
  
  glpopclientattrib;
  glpopattrib;
  gldeletebuffers(1,@buf);
 end;
 *)
end;

procedure gdi_copyarea(var drawinfo: drawinfoty);
var
 im1: maskedimagety;
 mode: glenum;
begin
 with drawinfo.copyarea,oglgcty(drawinfo.gc.platformdata).d do begin
  if copymode <> gcrasterop then begin
   setlogicop(copymode,drawinfo.gc);
  end;
 end;
 
 if tcanvas1(drawinfo.copyarea.source).fdrawinfo.gc.handle = 
                                              drawinfo.gc.handle then begin
  copyareaself(drawinfo);
 end
 else begin
  if tcanvas1(drawinfo.copyarea.source).fdrawinfo.gc.gdifuncs =
                                           drawinfo.gc.gdifuncs then begin
   copyareagl(drawinfo);
  end
  else begin   //foreign gdi
   with drawinfo.copyarea,oglgcty(drawinfo.gc.platformdata).d do begin
    mode:= gl_rgba;
    if gle_gl_ext_bgra in extensions then begin
     mode:= gl_bgra;
    end;
    im1:= tcanvas1(source).getimage(mode = gl_rgba);
    if (im1.image.size.cx = 0) or (im1.image.size.cy = 0) then begin
     exit;
    end;
    glpushclientattrib(gl_client_pixel_store_bit);
    glpushattrib(gl_pixel_mode_bit);
    
    with destrect^ do begin
     glrasterpos2i(x,top-y);
    end;
    glpixeltransferf(gl_alpha_scale,0);
    glpixeltransferf(gl_alpha_bias,1);
    with sourcerect^ do begin
     glpixelzoom(destrect^.cx/cx,-destrect^.cy/cy);
     glpixelstorei(gl_unpack_row_length,im1.image.size.cx);
     glpixelstorei(gl_unpack_skip_rows,x);
     glpixelstorei(gl_unpack_skip_pixels,y);
     gldrawpixels(cx,cy,mode,gl_unsigned_byte,im1.image.pixels);
    end;
    glpopclientattrib;
    glpopattrib;
   end;
  end;
 end;
 with drawinfo.copyarea,oglgcty(drawinfo.gc.platformdata).d do begin
  if copymode <> gcrasterop then begin
   setlogicop(gcrasterop,drawinfo.gc);
  end;
 end;
end;
 
procedure gdi_getimage(var drawinfo: drawinfoty);
//todo: optimize
var
 int1,int2: integer;
 po1,ps1,pd1: pchar;
 mode: glenum;
begin
 with drawinfo,getimage,oglgcty(drawinfo.gc.platformdata).d do begin
  glpushattrib(gl_pixel_mode_bit);
  
  glpixeltransferf(gl_alpha_scale,0);
  glpixeltransferf(gl_alpha_bias,0);
  with image.image do begin
   if not bgr and (gle_GL_EXT_bgra in extensions) then begin
    mode:= gl_bgra;
   end
   else begin
    mode:= gl_rgba;
    bgr:= true;
   end;
   if gle_gl_mesa_pack_invert in extensions then begin
    glpushclientattrib(gl_client_pixel_store_bit);
    glpixelstorei(gl_pack_invert_mesa,1);
    glreadpixels(0,0,size.cx,size.cy,mode,gl_unsigned_byte,pixels);
    glpopclientattrib;    
   end
   else begin
    getmem(po1,length*sizeof(rgbtriplety));
    glreadpixels(0,0,size.cx,size.cy,mode,gl_unsigned_byte,po1);
    int2:= sizeof(rgbtriplety)*size.cx;
    ps1:= pointer(pchar(po1)+(size.cy-1)*int2); //top row
    pd1:= pointer(pixels);
    for int1:= size.cy-1 downto 0 do begin
     move(ps1^,pd1^,int2);
     dec(ps1,int2);
     inc(pd1,int2);
    end;
    freemem(po1);
   end;

   error:= gde_ok;
  end;
  glpopattrib;
 end;
end;

procedure gdi_fonthasglyph(var drawinfo: drawinfoty);
begin
 gdinotimplemented;
end;

procedure gdi_getfont(var drawinfo: drawinfoty);
begin
 fontcache.getfont(drawinfo);
end;

procedure gdi_getfonthighres(var drawinfo: drawinfoty);
begin
 gdinotimplemented;
end;

procedure gdi_freefontdata(var drawinfo: drawinfoty);
begin
 if ffontcache <> nil then begin
  fontcache.freefontdata(drawinfo);
 end;
end;

procedure gdi_gettext16width(var drawinfo: drawinfoty);
begin
 fontcache.gettext16width(drawinfo);
end;

procedure gdi_getchar16widths(var drawinfo: drawinfoty);
begin
 fontcache.getchar16widths(drawinfo);
end;

procedure gdi_getfontmetrics(var drawinfo: drawinfoty);
begin
 fontcache.getfontmetrics(drawinfo);
end;

const
 gdifunctions: gdifunctionaty = (
   {$ifdef FPC}@{$endif}gdi_creategc,
   {$ifdef FPC}@{$endif}gdi_destroygc,
   {$ifdef FPC}@{$endif}gdi_changegc,
   {$ifdef FPC}@{$endif}gdi_getcanvasclass,
   {$ifdef FPC}@{$endif}gdi_endpaint,
   {$ifdef FPC}@{$endif}gdi_flush,
   {$ifdef FPC}@{$endif}gdi_drawlines,
   {$ifdef FPC}@{$endif}gdi_drawlinesegments,
   {$ifdef FPC}@{$endif}gdi_drawellipse,
   {$ifdef FPC}@{$endif}gdi_drawarc,
   {$ifdef FPC}@{$endif}gdi_fillrect,
   {$ifdef FPC}@{$endif}gdi_fillelipse,
   {$ifdef FPC}@{$endif}gdi_fillarc,
   {$ifdef FPC}@{$endif}gdi_fillpolygon,
   {$ifdef FPC}@{$endif}gdi_drawstring16,
   {$ifdef FPC}@{$endif}gdi_setcliporigin,
   {$ifdef FPC}@{$endif}msegenericgdi.gdi_createemptyregion,
   {$ifdef FPC}@{$endif}msegenericgdi.gdi_createrectregion,
   {$ifdef FPC}@{$endif}msegenericgdi.gdi_createrectsregion,
   {$ifdef FPC}@{$endif}msegenericgdi.gdi_destroyregion,
   {$ifdef FPC}@{$endif}msegenericgdi.gdi_copyregion,
   {$ifdef FPC}@{$endif}msegenericgdi.gdi_moveregion,
   {$ifdef FPC}@{$endif}msegenericgdi.gdi_regionisempty,
   {$ifdef FPC}@{$endif}msegenericgdi.gdi_regionclipbox,
   {$ifdef FPC}@{$endif}msegenericgdi.gdi_regsubrect,
   {$ifdef FPC}@{$endif}msegenericgdi.gdi_regsubregion,
   {$ifdef FPC}@{$endif}msegenericgdi.gdi_regaddrect,
   {$ifdef FPC}@{$endif}msegenericgdi.gdi_regaddregion,
   {$ifdef FPC}@{$endif}msegenericgdi.gdi_regintersectrect,
   {$ifdef FPC}@{$endif}msegenericgdi.gdi_regintersectregion,
   {$ifdef FPC}@{$endif}gdi_copyarea,
   {$ifdef FPC}@{$endif}gdi_getimage,
   {$ifdef FPC}@{$endif}gdi_fonthasglyph,
   {$ifdef FPC}@{$endif}gdi_getfont,
   {$ifdef FPC}@{$endif}gdi_getfonthighres,
   {$ifdef FPC}@{$endif}gdi_freefontdata,
   {$ifdef FPC}@{$endif}gdi_gettext16width,
   {$ifdef FPC}@{$endif}gdi_getchar16widths,
   {$ifdef FPC}@{$endif}gdi_getfontmetrics
);

function openglgetgdifuncs: pgdifunctionaty;
begin
 result:= @gdifunctions;
end;

{ tglftfontcache }

procedure tglftfontcache.drawglyph(var drawinfo: drawinfoty; const pos: pointty;
               const bitmap: pbitmapdataty);
begin
 setrasterpos(drawinfo.gc,pos); 
 with bitmap^ do begin
  gldrawpixels(width,height,gl_alpha,gl_unsigned_byte,@data);
 end;
end;

procedure tglftfontcache.drawstring16(var drawinfo: drawinfoty;
               const afont: fontty);
var
 rect1: rectty;
begin
 with oglgcty(drawinfo.gc.platformdata).d do begin
  if df_opaque in drawinfo.gc.drawingflags then begin
   if textbackgroundrect(drawinfo,afont,rect1) then begin
    with glcolorbackground do begin
     glcolor3ub(red,green,blue);
    end;
    glbegin(gl_quads);
    sendrect(drawinfo,rect1);
    glend;
   end;
  end;
  glpushclientattrib(gl_client_pixel_store_bit);
  glpushattrib(gl_pixel_mode_bit or gl_color_buffer_bit);
  glpixelstorei(gl_unpack_row_length, 0);
  glpixelstorei(gl_unpack_alignment, 1);
  glenable(gl_blend);
  glblendfunc(gl_src_alpha,gl_one_minus_src_alpha);
  with glcolorforeground do begin
   glpixeltransferf(gl_red_scale,0);
   glpixeltransferf(gl_red_bias,red/255);
   glpixeltransferf(gl_green_scale,0);
   glpixeltransferf(gl_green_bias,green/255);
   glpixeltransferf(gl_blue_scale,0);
   glpixeltransferf(gl_blue_bias,blue/255);
  end;
 end;
 inherited;
 glpopattrib;
 glpopclientattrib;
end;
{
initialization
 gdinumber:= registergdi(openglgetgdifuncs);
}
finalization
 freetessbuffer;
end.

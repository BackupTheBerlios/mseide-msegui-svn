{ MSEgui Copyright (c) 2007 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit mseopenglwidget;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
interface
uses
 msewindowwidget,msegl,mseglx,mseguiintf,x,xlib,msetypes,mseguiglob,mseclasses,
 msegraphutils;
 
type
 tcustomopenglwidget = class;
 openglwidgeteventty = procedure(const sender: tcustomopenglwidget) of object;
 openglrendereventty = procedure(const sender: tcustomopenglwidget;
                 const aupdaterect: rectty) of object;
 
 tcustomopenglwidget = class(tcustomwindowwidget)
  private
   fcontext: glxcontext;
   fdpy: pdisplay;
   faspect: real;
   fscreen: integer;
   fwin: winidty;
   fcolormap: tcolormap;
   fonrender: openglrendereventty;
   procedure checkviewport;
  protected
   procedure docreatewinid(const aparent: winidty; const awidgetrect: rectty;
                  var aid: winidty); override;
   procedure dodestroywinid; override;
   procedure doclientpaint(const aupdaterect: rectty); override;
   procedure clientrectchanged; override;
  public
   property aspect: real read faspect;
  published
   property onrender: openglrendereventty read fonrender write fonrender;
   
 end;

 topenglwidget = class(tcustomopenglwidget)
  published
   property onrender;
   property optionswidget;
   property bounds_x;
   property bounds_y;
   property bounds_cx;
   property bounds_cy;
   property bounds_cxmin;
   property bounds_cymin;
   property bounds_cxmax;
   property bounds_cymax;
   property color;
   property cursor;
   property frame;
   property face;
   property anchors;
   property taborder;
   property hint;
   property popupmenu;
   property onpopup;
   property onshowhint;
   property enabled;
   property visible;
 end;
  
implementation
uses
 sysutils,xutil;
 
{ tcustomopenglwidget }

procedure tcustomopenglwidget.doclientpaint(const aupdaterect: rectty);
begin
 glxmakecurrent(fdpy,fwin,fcontext);
 if canevent(tmethod(fonrender)) then begin
  fonrender(self,aupdaterect);
 end;
// glflush;
 glxswapbuffers(fdpy,fwin);
end;

procedure tcustomopenglwidget.dodestroywinid;
begin
 if fcontext <> nil then begin
//  glxmakecurrent(fdpy,fwin,nil);
  glxdestroycontext(fdpy,fcontext);
  fcontext:= nil;
 end;
 inherited;
end;

procedure tcustomopenglwidget.checkviewport;
var
 rect1: rectty;
begin
 if fcontext <> nil then begin
  rect1:= innerclientrect;
  glxmakecurrent(fdpy,fwin,fcontext);
  glviewport(0,0,rect1.cx,rect1.cy);  
  if rect1.cy = 0 then begin
   faspect:= 1;
  end
  else begin
   faspect:= rect1.cx/rect1.cy;
  end;
 end;
end;

procedure tcustomopenglwidget.clientrectchanged;
begin
 inherited;
 checkviewport;
end;

procedure tcustomopenglwidget.docreatewinid(const aparent: winidty;
               const awidgetrect: rectty; var aid: winidty);
const
  attr: array[0..8] of integer = 
  (GLX_RGBA,GLX_RED_SIZE,8,GLX_GREEN_SIZE,8,GLX_BLUE_SIZE,8,
   GLX_DOUBLEBUFFER,none);
var
 int1,int2: integer;
 visinfo: pxvisualinfo;
 attributes: txsetwindowattributes;
begin
 if not glxinitialized then begin
  initGlx();
 end;
 fdpy:= msedisplay;
 fscreen:= defaultscreen(fdpy);
 if not glxqueryextension(fdpy,int1,int2) then begin
  raise exception.create('GLX extension not supported.');
 end;
 visinfo:= glxchoosevisual(fdpy,fscreen,attr);
 if visinfo = nil then begin
  raise exception.create('Could not find visual.');
 end;
 fcontext:= glxcreatecontext(fdpy,visinfo,nil,true);
 fcolormap:= xcreatecolormap(fdpy,mserootwindow,visinfo^.visual,allocnone);
 attributes.colormap:= fcolormap;
 with awidgetrect do begin
  aid:= xcreatewindow(fdpy,aparent,x,y,cx,cy,0,visinfo^.depth,
        inputoutput,visinfo^.visual,cwcolormap,@attributes);
 end;
 fwin:= aid;
 xfree(visinfo);
 if fcontext = nil then begin
  raise exception.create('Could not create an OpenGL rendering context.');
 end;
 checkviewport;
end;

end.

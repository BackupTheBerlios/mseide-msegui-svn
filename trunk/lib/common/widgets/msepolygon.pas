{ MSEgui Copyright (c) 2008 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit msepolygon;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msewidgets,msegraphutils,msegraphics,classes,msetypes;
 
type
 polygonstatety = (pos_geometryvalid);
 polygonstatesty = set of polygonstatety;
 
 polygoninfoty = record
  edgecount: integer;
  rotation: real; 
  vertex: pointarty;
  color: colorty;
  colorline: colorty;
 end;
 
 projvectty = array[0..1] of real;
 projmatrixty = array[0..2] of projvectty; //[row][col]
 
 tpolygon = class(tpublishedwidget)
  private
   finfo: polygoninfoty;
   procedure setpoly_edgecount(const avalue: integer);
   procedure setpoly_color(const avalue: colorty);
   procedure setpoly_colorline(const avalue: colorty);
   procedure setpoly_rotation(const avalue: real);
  protected
   fstate: polygonstatesty;
   procedure change;
   procedure dopaint(const canvas: tcanvas); override;
   procedure checkgeometry;
   procedure clientrectchanged; override;
  public
   constructor create(aowner: tcomponent); override;
  published
   property poly_edgecount: integer read finfo.edgecount 
                                  write setpoly_edgecount default 0;
                                 //0 -> circle                    
   property poly_rotation: real read finfo.rotation write setpoly_rotation;
                                 //0..1 -> 0..360° CCW
   property poly_color: colorty read finfo.color write setpoly_color 
                                                          default cl_white;
   property poly_colorline: colorty read finfo.colorline write setpoly_colorline 
                                                          default cl_black;
 end;

const
 unityprojmatrix: projmatrixty = ((1,0),(0,1),(0,0));

procedure projtranslate(var matrix: projmatrixty; const tx,ty: real);
procedure projscale(var matrix: projmatrixty; const sx,sy: real);
procedure projrotate(var matrix: projmatrixty; const angle: real); //radiant
procedure projconcat(const a,b: projmatrixty; out dest: projmatrixty);

procedure project(const matrix: projmatrixty; var point: pointty); overload;
procedure project(const matrix: projmatrixty; var point: complexty); overload;
procedure project(const matrix: projmatrixty; var points: complexarty); overload;
procedure realtointpoints(const source: complexarty; out dest: pointarty);
                         
implementation

const
 pi2 = 2*pi;
 
procedure realtointpoints(const source: complexarty; out dest: pointarty);
var
 int1: integer;
begin
 setlength(dest,length(source));
 for int1:= 0 to high(dest) do begin
  dest[int1].x:= round(source[int1].re);
  dest[int1].y:= round(source[int1].im);
 end;
end;

procedure project(const matrix: projmatrixty; var point: pointty); overload;
var
 int1,int2: integer;
begin
 int1:= round(matrix[0,0]*point.x + matrix[1,0]*point.y + matrix[2,0]);
 int2:= round(matrix[0,1]*point.x + matrix[1,1]*point.y + matrix[2,1]);
 point.x:= int1;
 point.y:= int2;
end;

procedure project(const matrix: projmatrixty; var point: complexty); overload;
var
 rea1,rea2: real;
begin
 rea1:= matrix[0,0]*point.re + matrix[1,0]*point.im + matrix[2,0];
 rea2:= matrix[0,1]*point.re + matrix[1,1]*point.im + matrix[2,1];
 point.re:= rea1;
 point.im:= rea2;
end;

procedure project(const matrix: projmatrixty; var points: complexarty); overload;
var
 int1: integer;
begin
 for int1:= 0 to high(points) do begin
  project(matrix,points[int1]);
 end;
end;

procedure projtranslate(var matrix: projmatrixty; const tx,ty: real);
begin
 if (tx <> 0) or (ty <> 0) then begin
  matrix[2,0]:= matrix[2,0] + tx;
  matrix[2,1]:= matrix[2,1] + ty;  
 end;
end;

procedure projscale(var matrix: projmatrixty; const sx,sy: real);
var
 ma: projmatrixty;
begin
 if (sx <> 1) or (sy <> 1) then begin
  ma[0,0]:= sx;
  ma[0,1]:= 0;
  ma[1,0]:= 0;
  ma[1,1]:= sy;
  ma[2,0]:= 0;
  ma[2,1]:= 0;
  projconcat(matrix,ma,matrix);
 end;
end;

procedure projrotate(var matrix: projmatrixty; const angle: real);
var
 si,co: real;
 ma: projmatrixty;
begin
 if angle <> 0 then begin
  si:= sin(angle);
  co:= cos(angle);
  ma[0,0]:= co;
  ma[0,1]:= -si; //for counterclockwise rotation of screeen coordinates
  ma[1,0]:= si;
  ma[1,1]:= co;
  ma[2,0]:= 0;
  ma[2,1]:= 0;
  projconcat(matrix,ma,matrix);
 end;
end;

procedure projconcat(const a,b: projmatrixty; out dest: projmatrixty);
var
 o00,o01,
 o10,o11,
 o20,o21: real;
 
begin
 o00:= a[0,0]*b[0,0] + a[0,1]*b[1,0] {+ a[0,2]*b[2,0]};
 o01:= a[0,0]*b[0,1] + a[0,1]*b[1,1] {+ a[0,2]*b[2,1]};
 o10:= a[1,0]*b[0,0] + a[1,1]*b[1,0] {+ a[1,2]*b[2,0]};
 o11:= a[1,0]*b[0,1] + a[1,1]*b[1,1] {+ a[1,2]*b[2,1]};
 o20:= a[2,0]*b[0,0] + a[2,1]*b[1,0] + {a[2,2]*}b[2,0];
 o21:= a[2,0]*b[0,1] + a[2,1]*b[1,1] + {a[2,2]*}b[2,1];
 dest[0,0]:= o00;
 dest[0,1]:= o01;
 dest[1,0]:= o10;
 dest[1,1]:= o11;
 dest[2,0]:= o20;
 dest[2,1]:= o21;
end;

{ tpolygon }

constructor tpolygon.create(aowner: tcomponent);
begin
 with finfo do begin
  color:= cl_white;
  colorline:= cl_black;
 end;
 inherited;
end;

procedure tpolygon.change;
begin
 exclude(fstate,pos_geometryvalid);
 invalidate;
end;

procedure tpolygon.dopaint(const canvas: tcanvas);
var
 rect1: rectty;
begin
 inherited;
 checkgeometry;
 with finfo do begin
  case edgecount of
   0: begin
    rect1.pos:= vertex[0];
    rect1.size:= sizety(vertex[1]);
    canvas.fillellipse(rect1,color,colorline);
   end;
   1: begin
    canvas.drawline(vertex[0],vertex[1],colorline);
   end;
   else begin
    canvas.fillpolygon(vertex,color,colorline);
   end;
  end;
 end;
end;

procedure tpolygon.setpoly_edgecount(const avalue: integer);
begin
 if finfo.edgecount <> avalue then begin
  finfo.edgecount:= avalue;
  change;
 end;
end;

procedure tpolygon.setpoly_rotation(const avalue: real);
begin
 if finfo.rotation <> avalue then begin
  finfo.rotation:= avalue;
  change;
 end;
end;

procedure tpolygon.checkgeometry;
var
 rect1: rectty;
 ar1: complexarty;
 rea1,rea2: real;
 int1: integer;
 ma: projmatrixty;
 minx,miny,maxx,maxy: real;
 si,co: real;
 
begin
 if not (pos_geometryvalid in fstate) then begin
  include(fstate,pos_geometryvalid);
  rect1:= innerclientrect;
  dec(rect1.cx);
  dec(rect1.cy);
  with finfo do begin
   case edgecount of
    0: begin
     setlength(vertex,2);
     with rect1 do begin
      vertex[0].x:= x + cx div 2;  //center
      vertex[0].y:= y + cy div 2;
      vertex[1].x:= cx;           //size
      vertex[1].y:= cy;
     end;
    end;
    1,2: begin
     setlength(ar1,2);
     si:= sin(rotation*pi2);
     co:= cos(rotation*pi2);
     if abs(si) > abs(co) then begin
      rea1:= co/si; //cotan
      ar1[0].re:= -1;
      ar1[0].im:= -rea1;
      ar1[1].re:= 1;
      ar1[1].im:= rea1;
     end
     else begin
      rea1:= si/co; //tan
      ar1[0].re:= -rea1;
      ar1[0].im:= -1;
      ar1[1].re:= rea1;
      ar1[1].im:= 1;
     end;
     ma:= unityprojmatrix;
     projtranslate(ma,1,1);
     projscale(ma,rect1.cx/2,rect1.cy/2);                 //scale to destination rect
     projtranslate(ma,rect1.x,rect1.y);               //move to destrect
     project(ma,ar1);
     realtointpoints(ar1,vertex);
    end;
    else begin
     setlength(ar1,edgecount);
     rea1:= 2*pi/(edgecount);
     for int1:= 0 to high(ar1) do begin
      rea2:= int1*rea1;
      ar1[int1].im:= -cos(rea2);          //start at top corner
      ar1[int1].re:= -sin(rea2);
     end;
     ma:= unityprojmatrix;
     projrotate(ma,rotation*pi2);
     project(ma,ar1);
     minx:= 0;
     miny:= 0;
     maxx:= 0;
     maxy:= 0;
     for int1:= 0 to high(ar1) do begin
      with ar1[int1] do begin
       if re < minx then begin
        minx:= re;
       end;
       if im < miny then begin
        miny:= im;
       end;
       if re > maxx then begin
        maxx:= re;
       end;
       if im > maxy then begin
        maxy:= im;
       end;
      end;
     end;
     ma:= unityprojmatrix;
     projtranslate(ma,-(minx+maxx)/2,-(miny+maxy)/2); //center polygon
     projscale(ma,1/(maxx-minx),1/(maxy-miny));       //norm to 1
     projtranslate(ma,0.5,0.5);                       //move to first quadrant
     projscale(ma,rect1.cx,rect1.cy);                 //scale to destination rect
     projtranslate(ma,rect1.x,rect1.y);               //move to destrect
     project(ma,ar1);
     realtointpoints(ar1,vertex);
    end;
   end;
  end;
 end;
end;

procedure tpolygon.setpoly_color(const avalue: colorty);
begin
 if avalue <> finfo.color then begin
  finfo.color:= avalue;
  invalidate;
 end;
end;

procedure tpolygon.setpoly_colorline(const avalue: colorty);
begin
 if avalue <> finfo.colorline then begin
  finfo.colorline:= avalue;
  invalidate;
 end;
end;

procedure tpolygon.clientrectchanged;
begin
 change;
 inherited;
end;


end.

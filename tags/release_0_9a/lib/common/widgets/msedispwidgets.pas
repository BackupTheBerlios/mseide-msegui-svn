{ MSEgui Copyright (c) 1999-2006 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit msedispwidgets;

{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface
uses
 classes,msegui,mseguiglob,msewidgets,msegraphics,msedrawtext,msegraphutils,
   msetypes,msestrings,mseformatstr;

const
 defaultdisptextflags = [tf_ycentered];
 defaultdispwidgetwidth = 100;
 defaultdispwidgetheight = 20;
 defaultdispwidgetoptions = (defaultoptionswidget -
                                 [ow_mousefocus,ow_tabfocus,ow_arrowfocus]) +
                                 [ow_fontglyphheight];

type

 changeansistringeventty = procedure(sender: tobject; 
                                    var avalue: ansistring) of object;
 changestringeventty = procedure(sender: tobject;
                                    var avalue: msestring) of object;
 changeintegereventty = procedure(sender: tobject;
                                    var avalue: integer) of object;
 changerealeventty = procedure(sender: tobject; var avalue: realty) of object;
 changedatetimeeventty = procedure(sender: tobject; 
                                    var avalue: tdatetime) of object;
 changebooleaneventty = procedure(sender: tobject;
                                    var avalue: boolean) of object;

 tdispframe = class(tcustomcaptionframe)
  public
   constructor create(const intf: iframe);
  published
   property levelo default -1;
   property leveli;
   property framewidth;
   property colorframe;
   property framei_left default 1;
   property framei_top default 1;
   property framei_right default 1;
   property framei_bottom default 1;
   property colorclient;
   property caption;
   property captionpos;
   property captiondist;
   property captiondistouter;
   property captionoffset;
   property font;
   property localprops; //before template
   property template;
 end;

 dispwidgetoptionty = (dwo_hintclippedtext);
 dispwidgetoptionsty = set of dispwidgetoptionty;
 
 tdispwidget = class(tpublishedwidget)
  private
   finfo: drawtextinfoty;
   foptions: dispwidgetoptionsty;
   procedure settextflags(const value: textflagsty);
  protected
   procedure valuechanged; virtual;
   procedure formatchanged;
   function getvaluetext: msestring; virtual; abstract;
   procedure dopaint(const canvas: tcanvas); override;
   procedure clientrectchanged; override;
   procedure fontchanged; override;
   procedure createframe; override;
   procedure loaded; override;
   procedure showhint(var info: hintinfoty); override;
  public
   constructor create(aowner: tcomponent); override;
   procedure initnewcomponent; override;
   procedure synctofontheight; override;
  published
   property bounds_cx default defaultdispwidgetwidth;
   property bounds_cy default defaultdispwidgetheight;
   property font: twidgetfont read getfont write setfont stored isfontstored;
   property textflags: textflagsty read finfo.flags write settextflags
                default defaultdisptextflags;
   property optionswidget default defaultdispwidgetoptions;
   property options: dispwidgetoptionsty read foptions write foptions default [];
 end;

 tcustomstringdisp = class(tdispwidget)
  private
   fvalue: msestring;
   fonchange: changestringeventty;
   procedure setvalue(const Value: msestring);
  protected
   function getvaluetext: msestring; override;
   procedure valuechanged; override;
  public
   property value: msestring read fvalue write setvalue;
  published
   property onchange: changestringeventty read fonchange write fonchange;
 end;

 tstringdisp = class(tcustomstringdisp)
  published
   property value;
 end;
 
 tbytestringdisp = class(tdispwidget)
  private
   fvalue: string;
   fonchange: changeansistringeventty;
   fbase: numbasety;
   procedure setvalue(const Value: string);
   procedure setbase(const Value: numbasety);
  protected
   function getvaluetext: msestring; override;
   procedure valuechanged; override;
  public
   constructor create(aowner: tcomponent); override;
  published
   property value: string read fvalue write setvalue;
   property onchange: changeansistringeventty read fonchange write fonchange;
   property base: numbasety read fbase write setbase default nb_hex;
 end;

const
 defaultnumdisptextflags = defaultdisptextflags + [tf_right];

type
 tnumdisp = class(tdispwidget)
  protected
  public
   constructor create(aowner: tcomponent); override;
  published
   property textflags default defaultnumdisptextflags;
 end;

 tcustomintegerdisp = class(tnumdisp)
  private
   fvalue: integer;
   fonchange: changeintegereventty;
   fbase: numbasety;
   fbitcount: integer;
   procedure setvalue(const Value: integer);
   procedure setbase(const Value: numbasety);
   procedure setbitcount(const Value: integer);
  protected
   function getvaluetext: msestring; override;
   procedure valuechanged; override;
  public
   constructor create(aowner: tcomponent); override;
   property value: integer read fvalue write setvalue default 0;
  published
   property base: numbasety read fbase write setbase default nb_dec;
   property bitcount: integer read fbitcount write setbitcount default 32;
   property onchange: changeintegereventty read fonchange write fonchange;
 end;

 tintegerdisp = class(tcustomintegerdisp)
  published
   property value;
 end;
 
 tcustomrealdisp = class(tnumdisp)
  private
   fvalue: realty;
   fonchange: changerealeventty;
   fformat: string;
   procedure setvalue(const avalue: realty);
   procedure readvalue(reader: treader);
   procedure writevalue(writer: twriter);
   procedure setformat(const avalue: string);
  protected
   procedure valuechanged; override;
   function getvaluetext: msestring; override;
   procedure defineproperties(filer: tfiler); override;
  public
   constructor create(aowner: tcomponent); override;
   property value: realty read fvalue write setvalue stored false;
  published
   property format: string read fformat write setformat;
   property onchange: changerealeventty read fonchange write fonchange;
 end;

 trealdisp = class(tcustomrealdisp)
  published
   property value stored false;
 end;
 
 tcustomdatetimedisp = class(tnumdisp)
  private
   fvalue: tdatetime;
   fonchange: changedatetimeeventty;
   fformat: string;
   fkind: datetimekindty;
   procedure setvalue(const avalue: tdatetime);
   procedure setformat(const avalue: string);
   procedure setkind(const avalue: datetimekindty);
   procedure readvalue(reader: treader);
   procedure writevalue(writer: twriter);
  protected
   procedure valuechanged; override;
   function getvaluetext: msestring; override;
   procedure defineproperties(filer: tfiler); override;
  public
   constructor create(aowner: tcomponent); override;
   property value: tdatetime read fvalue write setvalue;
  published
   property format: string read fformat write setformat;
   property onchange: changedatetimeeventty read fonchange write fonchange;
   property kind: datetimekindty read fkind write setkind default dtk_date;
 end;

 tdatetimedisp = class(tcustomdatetimedisp)
  published
   property value stored false;
 end;
  
 tcustombooleandisp = class(tdispwidget)
  private
   fvalue: boolean;
   fonchange: changebooleaneventty;
   ftext_false: msestring;
   ftext_true: msestring;
   procedure setvalue(const Value: boolean);
   procedure settext_false(const avalue: msestring);
   procedure settext_true(const avalue: msestring);
  protected
   procedure valuechanged; override;
   function getvaluetext: msestring; override;
  public
   constructor create(aowner: tcomponent); override;
   property value: boolean read fvalue write setvalue default false;
  published
   property textflags default defaultdisptextflags + [tf_xcentered];
   property onchange: changebooleaneventty read fonchange write fonchange;
   property text_false: msestring read ftext_false write settext_false;
   property text_true: msestring read ftext_true write settext_true;
 end;
 
 tbooleandisp = class(tcustombooleandisp)
  published
   property value;
 end;

implementation
uses
 sysutils,msereal,math,msestreaming,msedate;

{ tdispframe }

constructor tdispframe.create(const intf: iframe);
begin
 inherited;
// clientcolor:= cl_foreground;
 fi.levelo:= -1;
 inflateframe(fi.innerframe,1);
 internalupdatestate;
end;

{ tdispwidget }

constructor tdispwidget.create(aowner: tcomponent);
begin
 inherited;
 foptionswidget:= defaultdispwidgetoptions;
 fwidgetrect.cx:= defaultdispwidgetwidth;
 fwidgetrect.cy:= defaultdispwidgetheight;
 finfo.flags:= defaultdisptextflags;
end;

procedure tdispwidget.initnewcomponent;
begin
 inherited;
 createframe;
 synctofontheight;
end;

procedure tdispwidget.settextflags(const value: textflagsty);
begin
 if finfo.flags <> value then begin
  finfo.flags:= value;
  invalidate;
 end;
end;

procedure tdispwidget.clientrectchanged;
begin
 inherited;
 finfo.dest:= innerclientrect;
end;

procedure tdispwidget.dopaint(const canvas: tcanvas);
begin
 inherited;
 drawtext(canvas,finfo);
end;

procedure tdispwidget.fontchanged;
begin
 inherited;
 finfo.font:= getfont;
 invalidate;
end;

procedure tdispwidget.createframe;
begin
 tdispframe.create(iframe(self));
end;

procedure tdispwidget.valuechanged;
begin
 finfo.text.text:= getvaluetext;
 invalidate;
end;

procedure tdispwidget.formatchanged;
begin
 finfo.text.text:= getvaluetext;
 invalidate;
end;

procedure tdispwidget.loaded;
begin
 inherited;
 valuechanged;
end;

procedure tdispwidget.showhint(var info: hintinfoty);
begin
 if (dwo_hintclippedtext in foptions) and textclipped(getcanvas,finfo) then begin
  info.caption:= finfo.text.text;
  include(info.flags,hfl_show);
 end
 else begin
  inherited;
 end;
end;

procedure tdispwidget.synctofontheight;
begin
 syncsinglelinefontheight;
end;

{ tcustomstringdisp }

function tcustomstringdisp.getvaluetext: msestring;
begin
 result:= fvalue;
end;

procedure tcustomstringdisp.setvalue(const Value: msestring);
begin
 if fvalue <> value then begin
  fvalue := Value;
  valuechanged;
 end;
end;

procedure tcustomstringdisp.valuechanged;
begin
 if canevent(tmethod(fonchange)) then begin
  fonchange(self,fvalue);
 end;
 inherited;
end;

{ tbytestringdisp }

constructor tbytestringdisp.create(aowner: tcomponent);
begin
 fbase:= nb_hex; 
 inherited;
end;

function tbytestringdisp.getvaluetext: msestring;
begin
 result:= bytestrtostr(fvalue,fbase,true);
end;

procedure tbytestringdisp.setbase(const Value: numbasety);
begin
 if fbase <> value then begin
  fbase:= Value;
  formatchanged;
 end;
end;

procedure tbytestringdisp.setvalue(const Value: string);
begin
 if fvalue <> value then begin
  fvalue := Value;
  valuechanged;
 end;
end;

procedure tbytestringdisp.valuechanged;
begin
 if canevent(tmethod(fonchange)) then begin
  fonchange(self,fvalue);
 end;
 inherited;
end;

{ tnumdisp }

constructor tnumdisp.create(aowner: tcomponent);
begin
 inherited;
 finfo.flags:= defaultnumdisptextflags;
end;

{ tcustomintegerdisp }

constructor tcustomintegerdisp.create(aowner: tcomponent);
begin
 fbase:= nb_dec;
 fbitcount:= 32;
 inherited;
end;

function tcustomintegerdisp.getvaluetext: msestring;
begin
 result:= intvaluetostr(fvalue,fbase,fbitcount);
end;

procedure tcustomintegerdisp.setbase(const Value: numbasety);
begin
 if fbase <> value then begin
  fbase := Value;
  formatchanged;
 end;
end;

procedure tcustomintegerdisp.setbitcount(const Value: integer);
begin
 if fbitcount <> value then begin
  fbitcount := Value;
  formatchanged;
 end;
end;

procedure tcustomintegerdisp.setvalue(const Value: integer);
begin
// if fvalue <> value then begin
  fvalue := Value;
  valuechanged;
// end;
end;

procedure tcustomintegerdisp.valuechanged;
begin
 if canevent(tmethod(fonchange)) then begin
  fonchange(self,fvalue);
 end;
 inherited;
end;

{ tcustomrealdisp }

constructor tcustomrealdisp.create(aowner: tcomponent);
begin
 fvalue:= emptyreal;
 inherited;
end;

procedure tcustomrealdisp.readvalue(reader: treader);
begin
 value:= readrealty(reader);
end;

procedure tcustomrealdisp.writevalue(writer: twriter);
begin
 writerealty(writer,fvalue);
end;

procedure tcustomrealdisp.defineproperties(filer: tfiler);
var
 bo1: boolean;
begin
 inherited;
 if filer.ancestor <> nil then begin
  bo1:= tcustomrealdisp(filer.ancestor).fvalue <> fvalue;
 end
 else  begin
  bo1:= not isemptyreal(fvalue);
 end;
 filer.DefineProperty('val',{$ifdef FPC}@{$endif}readvalue,
          {$ifdef FPC}@{$endif}writevalue,bo1);
end;

function tcustomrealdisp.getvaluetext: msestring;
begin
 result:= realtytostr(fvalue,fformat);
end;

procedure tcustomrealdisp.setvalue(const avalue: realty);
begin
 if fvalue <> avalue then begin
  fvalue := avalue;
  valuechanged;
 end;
end;

procedure tcustomrealdisp.valuechanged;
begin
 if canevent(tmethod(fonchange)) then begin
  fonchange(self,fvalue);
 end;
 inherited;
end;

procedure tcustomrealdisp.setformat(const avalue: string);
begin
 fformat := avalue;
 formatchanged;
end;

{ tcustomdatetimedisp }

constructor tcustomdatetimedisp.create(aowner: tcomponent);
begin
 fvalue:= emptydatetime;
 inherited;
end;

procedure tcustomdatetimedisp.setvalue(const avalue: tdatetime);
begin
 if fvalue <> avalue then begin
  fvalue := avalue;
  valuechanged;
 end;
end;

procedure tcustomdatetimedisp.setformat(const avalue: string);
begin
 fformat := avalue;
 formatchanged;
end;

procedure tcustomdatetimedisp.valuechanged;
begin
 if canevent(tmethod(fonchange)) then begin
  fonchange(self,fvalue);
 end;
 inherited;
end;

function tcustomdatetimedisp.getvaluetext: msestring;
begin
 if fkind = dtk_time then begin
  result:= mseformatstr.timetostring(fvalue,fformat);
 end
 else begin
  result:= mseformatstr.datetimetostring(fvalue,fformat);
 end;
end;

procedure tcustomdatetimedisp.setkind(const avalue: datetimekindty);
begin
 if fkind <> avalue then begin
  fkind:= avalue;
  formatchanged;
 end;
end;

procedure tcustomdatetimedisp.readvalue(reader: treader);
begin
 value:= readrealty(reader);
end;

procedure tcustomdatetimedisp.writevalue(writer: twriter);
begin
 writerealty(writer,fvalue);
end;

procedure tcustomdatetimedisp.defineproperties(filer: tfiler);
var
 bo1: boolean;
begin
 inherited;
 if filer.ancestor <> nil then begin
  bo1:= tcustomdatetimedisp(filer.ancestor).fvalue <> fvalue;
 end
 else  begin
  bo1:= not isemptydatetime(fvalue);
 end;
 filer.DefineProperty('val',
             {$ifdef FPC}@{$endif}readvalue,
             {$ifdef FPC}@{$endif}writevalue,bo1);
end;

{ tcustombooleandisp }

constructor tcustombooleandisp.create(aowner: tcomponent);
begin
 ftext_true:= 'T';
 ftext_false:= 'F';
 inherited;
 finfo.flags:= finfo.flags + [tf_xcentered];
end;

function tcustombooleandisp.getvaluetext: msestring;
begin
 if fvalue then begin
  result:= ftext_true;
 end
 else begin
  result:= ftext_false;
 end;
end;

procedure tcustombooleandisp.setvalue(const Value: boolean);
begin
 if fvalue <> value then begin
  fvalue := Value;
  valuechanged;
 end;
end;

procedure tcustombooleandisp.valuechanged;
begin
 if canevent(tmethod(fonchange)) then begin
  fonchange(self,fvalue);
 end;
 inherited;
end;

procedure tcustombooleandisp.settext_false(const avalue: msestring);
begin
 ftext_false:= avalue;
 formatchanged;
end;

procedure tcustombooleandisp.settext_true(const avalue: msestring);
begin
 ftext_true:= avalue;
 formatchanged;
end;


end.

	{ MSEgui Copyright (c) 1999-2008 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit mseguiintf; //i386-linux

{$ifdef FPC}{$mode objfpc}{$h+}{$GOTO ON}{$endif}
{$ifndef FPC}{$ifdef linux} {$define UNIX} {$endif}{$endif}

interface

uses
 {$ifdef FPC}xlib{$else}Xlib{$endif},msetypes,mseapplication,msegui,msegraphics,
 msegraphutils,mseevent,msepointer,mseguiglob,msesys,
 msethread{$ifdef FPC},x,xutil,dynlibs{$endif},
 mselibc,msesysintf,msestockobjects,
 msestrings,xft,xrender;

{$ifdef FPC}
{$define xbooleanresult}
{$ifndef VER2_3} {$define xboolean} {$endif}
{$ifdef UNIX}
{$ifdef msedebug}
var
 _IO_stdin: P_IO_FILE; cvar;       
  //avoid link errors if rtl is compiled with stabs info
 _IO_stdout: P_IO_FILE; cvar;
 _IO_stderr: P_IO_FILE; cvar;
 __malloc_initialized : longint;cvar;
 h_errno : longint;cvar;
{$endif}
{$endif}
{$endif}

{ $define smdebug}

{$include ../mseguiintf.inc}

{$define with_sm}

{$ifndef with_sm}
 { $define with_saveyourself}
{$endif}

const
 {$ifdef FPC}
// threadslib = 'pthread';
 Xlibmodulename = 'X11';
 {$endif}
 sXlib = Xlibmodulename;
 pixel0 = $000000;
 pixel1 = $ffffff;
type
  Bool = integer;
  XID = type Cardinal;
  TXICCEncodingStyle = (XStringStyle,XCompoundTextStyle,XTextStyle,
     XStdICCTextStyle,XUTF8StringStyle);

function msedisplay: pdisplay;
function msevisual: pvisual;
function mserootwindow(id: winidty = 0): winidty;
function msedefaultscreen: pscreen;

type
 _XIM = record end;
 XIM = ^_XIM;
 _XIC = record end;
 XIC = ^_XIC;
 ppucs4char = ^pucs4char;
 dword = longword;
  VisualID = dword;
  Visual = record
    ext_data: PXExtData;  { hook for extension to hang data  }
    visualid: VisualID;   { visual id of this visual  }
    _class: Longint;
    red_mask: Cardinal;
    green_mask: Cardinal;
    blue_mask: Cardinal;
    bits_per_rgb: Longint;
    map_entries: Longint;
  end;
  msepvisual = ^visual;
  
  PXWMHints = ^XWMHints;
  XWMHints = record
    flags: Longint;  { marks which fields in this structure are defined  }
    input: Bool;     { does this application rely on the window manager to get keyboard input?  }
    initial_state: Longint;  { see below  }
    icon_pixmap: xid;     { pixmap to be used as icon  }
    icon_window: xid;     { window to be used as icon  }
    icon_x: Longint;         { initial position of icon  }
    icon_y: Longint;
    icon_mask: xid;       { icon mask bitmap  }
    window_group: XID;       { id of related window group }
    { this structure may be extended in the future  }
  end;

{ definition for flags of XWMHints  }
const
  InputHint = 1 shl 0;
  StateHint = 1 shl 1;
  IconPixmapHint = 1 shl 2;
  IconWindowHint = 1 shl 3;
  IconPositionHint = 1 shl 4;
  IconMaskHint = 1 shl 5;
  WindowGroupHint = 1 shl 6;
  AllHints = (((((InputHint or StateHint) or IconPixmapHint) or IconWindowHint)
    or IconPositionHint) or IconMaskHint) or WindowGroupHint;
  XUrgencyHint = 1 shl 8;
  {
type
   TXICCEncodingStyle = (XStringStyle,XCompoundTextStyle,XTextStyle,
     XStdICCTextStyle,XUTF8StringStyle);
  }
function XSetWMHints(Display: PDisplay; W: xid; WMHints: PXWMHints): Longint; cdecl;
                              external sXLib name 'XSetWMHints';
function XSetForeground(Display: PDisplay; GC: TGC; Foreground: Cardinal): longint; cdecl;
                              external sXLib name 'XSetForeground';
      //bug in borland Xlib.pas
procedure XDrawImageString(Display: PDisplay; D: TDrawable; GC: TGC;
  X, Y: Integer; S: PChar; Len: Integer); cdecl;
                              external sXLib name 'XDrawImageString';
procedure XDrawImageString16(Display: PDisplay; D: TDrawable; GC: TGC;
  X, Y: Integer; S: Pxchar2b; Len: Integer); cdecl;
                              external sXLib name 'XDrawImageString16';
procedure XDrawString16(Display: PDisplay; D: TDrawable; GC: TGC;
  X, Y: Integer; S: Pxchar2b; Len: Integer); cdecl;
                              external sXLib name 'XDrawString16';
function XOpenIM(Display: PDisplay; rdb: PXrmHashBucketRec;
             res_name: pchar; res_class: pchar): XIM; cdecl;
                              external sXLib name 'XOpenIM';
function XCloseIM(IM: XIM): TStatus; cdecl;
                              external sXLib name 'XCloseIM';
function XCreateIC(IM: XIM): XIC; cdecl; varargs;
                              external sXLib name 'XCreateIC';
procedure XDestroyIC(IC: XIC); cdecl;
                              external sXLib name 'XDestroyIC';
function XSetLocaleModifiers(modifier_list: pchar): pchar; cdecl;
                              external sXLib name 'XSetLocaleModifiers';
function XSetICValues(IC: XIC): PChar; cdecl; varargs;
                              external sXLib name 'XSetICValues';
function XSetIMValues(IC: XIM): PChar; cdecl; varargs;
                              external sXLib name 'XSetIMValues';
//function XSetICValues(para1:XIC; dotdotdot:array of const):Pchar;cdecl;
//                              external sXLib name 'XSetICValues';
function XGetICValues(IC: XIC): PChar; cdecl; varargs;
                              external sXLib name 'XGetICValues';
procedure XSetICFocus(IC: XIC); cdecl;
                              external sXLib name 'XSetICFocus';
procedure XUnsetICFocus(IC: XIC); cdecl;
                              external sXLib name 'XUnsetICFocus';
function XwcLookupString(IC: XIC; Event: PXKeyPressedEvent;
  BufferReturn: Pucs4char; WCharsBuffer: Longint; KeySymReturn: PKeySym;
  StatusReturn: PStatus): Longint; cdecl;
                              external sXLib name 'XwcLookupString';
function Xutf8LookupString(IC: XIC; Event: PXKeyPressedEvent;
  BufferReturn: Pchar; CharsBuffer: Longint; KeySymReturn: PKeySym;
  StatusReturn: PStatus): Longint; cdecl;
                              external sXLib name 'Xutf8LookupString';
function XwcTextListToTextProperty(para1:PDisplay; para2:PPucs4Char;
           para3: integer; para4: integer{TXICCEncodingStyle};
           para5:PXTextProperty): integer;cdecl;
                              external sXLib name 'XwcTextListToTextProperty';
function XCreateImage(Display: PDisplay; Visual: msePVisual; Depth: Cardinal;
  Format: Longint; Offset: Longint; Data: PChar; Width, Height: Cardinal;
  BitmapPad: Longint; BytesPerLine: Longint): PXImage; cdecl;
                              external sXLib name 'XCreateImage';
{ xwc function seems to be more stable
function Xutf8TextListToTextProperty(para1:PDisplay; para2:PPchar; para3: integer;
            para4:TXICCEncodingStyle; para5:PXTextProperty): integer; cdecl;
                     external sXLib name 'Xutf8TextListToTextProperty';
}
function Xutf8TextPropertyToTextList(para1:PDisplay; para2:PXTextProperty;
            para3:PPPchar; para4: pinteger): integer; cdecl;
                     external sXlib name 'Xutf8TextPropertyToTextList';

{$ifndef staticxft}
var //xft functions
 FcPatternDestroy: procedure(p:PFcPattern);cdecl;
 FcFontSetDestroy: procedure(s:PFcFontSet);cdecl;
 FcObjectSetCreate: function: PFcObjectSet;cdecl;
 FcObjectSetAdd: function(os: PFcObjectSet; aobject:Pchar):TFcBool;cdecl;
 FcObjectSetDestroy: procedure(os: PFcObjectSet);cdecl;
 FcFontList: function(config: PFcConfig; p:PFcPattern; 
                      os:PFcObjectSet): PFcFontSet;cdecl;
 FcCharSetCreate: function: PFcCharSet;cdecl;
 FcCharSetDestroy: procedure(fcs:PFcCharSet);cdecl;
 FcCharSetAddChar: function(fcs:PFcCharSet; ucs4:TFcChar32):TFcBool;cdecl;
 FcPatternAdd: function(p:PFcPattern; aobject:Pchar; value:TFcValue;
                           append:TFcBool):TFcBool;cdecl;
 FcPatternCreate: function: PFcPattern;cdecl;
 FcConfigSubstitute: function(config:PFcConfig; p:PFcPattern;
                   kind:TFcMatchKind):TFcBool;cdecl;
 FcDefaultSubstitute: procedure (pattern:PFcPattern);cdecl;
 FcFontSort: function (config:PFcConfig; p:PFcPattern; trim:TFcBool;
            csp:PPFcCharSet; result:PFcResult): PFcFontSet;cdecl;
 FcCharSetHasChar: function(fcs:PFcCharSet; ucs4:TFcChar32):TFcBool;cdecl;
 FcPatternDuplicate: function (p:PFcPattern): PFcPattern;cdecl;
 FcPatternGetCharSet: function (p:PFcPattern; aobject:Pchar; n:longint;
               c:PPFcCharSet):TFcResult;cdecl;
 FcFontRenderPrepare: function(config:PFcConfig; pat:PFcPattern;
                    font:PFcPattern): PFcPattern;cdecl;
 FcMatrixRotate: procedure(m:PFcMatrix; c:Tdouble; s:Tdouble);cdecl;
 FcMatrixScale: procedure(m:PFcMatrix; sx:Tdouble; sy:Tdouble);cdecl;
 FcPatternAddInteger: function(p:PFcPattern; aobject:Pchar; i:longint):TFcBool; cdecl;
 FcPatternAddDouble: function(p:PFcPattern; aobject:Pchar; d:Tdouble):TFcBool; cdecl;
 FcPatternAddString: function(p:PFcPattern; aobject:Pchar; s: pansichar):TFcBool; cdecl;
 FcPatternAddMatrix: function(p:PFcPattern; aobject:Pchar; s:PFcMatrix):TFcBool; cdecl;
 FcPatternAddCharSet: function(p:PFcPattern;
                       aobject:Pchar; c:PFcCharSet):TFcBool;cdecl;
 FcPatternAddBool: function(p:PFcPattern; aobject:Pchar; b:TFcBool):TFcBool; cdecl;
 FcPatternAddLangSet: function(p:PFcPattern; aobject:Pchar; 
                         ls:PFcLangSet):TFcBool;cdecl;
 
 FcPatternGetString: function(p: PFcPattern; aobject: Pchar; n: integer; 
                                s: ppchar): tfcresult; cdecl;
 XftDrawDestroy: procedure(draw:PXftDraw); cdecl;
 XftDrawSetClipRectangles: function (draw:PXftDraw; xOrigin:longint;
         yOrigin:longint; rects:PXRectangle; n:longint):TFcBool;cdecl;
 XftDrawCreate: function(dpy:PDisplay; drawable:TDrawable; visual:PVisual;
       colormap:TColormap): PXftDraw;cdecl;
 XftDrawSetClip: function(draw:PXftDraw; r:TRegion):TFcBool;cdecl;
 XftTextExtents16: procedure(dpy:PDisplay; pub:PXftFont;
  _string: pwidechar{PFcChar16}; len:longint; extents:PXGlyphInfo);cdecl;
 XftFontOpenName: function(dpy:PDisplay; screen:longint; name:Pchar):PXftFont;cdecl;
 XftFontClose: procedure(dpy:PDisplay; pub:PXftFont);cdecl;
 XftDrawString16: procedure(draw:PXftDraw; color:PXftColor; pub:PXftFont; 
           x:longint; y:longint; _string:pwidechar; len:longint);cdecl;
 XftDefaultHasRender: function(dpy:PDisplay):TFcBool;cdecl;
 XftGetVersion: function():longint;cdecl;
 XftInit: function(config:Pchar):TFcBool;cdecl;
 XftInitFtLibrary: function ():TFcBool;cdecl;

 XftCharExists: function(dpy:PDisplay; pub:PXftFont; ucs4:TFcChar32):TFcBool;cdecl;
 XftNameParse: function(name:Pchar): PFcPattern;cdecl;
 XftFontMatch: function(dpy:PDisplay; screen:longint; pattern:PFcPattern;
                                  result:PFcResult): PFcPattern;cdecl;
 XftFontOpenPattern: function(dpy:PDisplay; pattern:PFcPattern):PXftFont;cdecl;
 XftDefaultSubstitute: procedure(dpy:PDisplay; screen:longint;
                        pattern:PFcPattern);cdecl;
{$endif}
function hasxft: boolean;
//function fontdatatoxftname(const fontdata: fontdataty): string;
function fontdatatoxftpat(const fontdata: fontdataty; const highres: boolean): pfcpattern;
procedure getxftfontdata(po: pxftfont; var drawinfo: drawinfoty);

implementation

uses
 msebits,msekeyboard,sysutils,msesysutils,msefileutils,msedatalist
 {$ifdef with_sm},sm,ice{$endif};

const
 highresfontshift = 6;  //64
 highresfontfakt = 1 shl highresfontshift;
 highresfontmask = highresfontfakt - 1; 
 
var
 pixmapcount: integer;
 
type
 tsimplebitmap1 = class(tsimplebitmap);
 twindow1 = class(msegui.twindow);

{$ifdef FPC}
 {$macro on}
 {$define xchar2b:=txchar2b}
 {$define xcharstruct:=txcharstruct}
 {$define xfontstruct:=txfontstruct}
 {$define xfontprop:=txfontprop}
 {$define xpoint:=txpoint}
 {$define xgcvalues:=txgcvalues}
 {$define region:=tregion}
 {$define ximage:=tximage}
 {$define xwindowattributes:=txwindowattributes}
 {$define xclientmessageevent:=txclientmessageevent}
 {$define xtype:=_type}
 {$define xrectangle:=txrectangle}
 {$define keysym:=tkeysym}
 {$define xsetwindowattributes:=txsetwindowattributes}
 {$define xwindowchanges:=txwindowchanges}
 {$define xevent:=txevent}
 {$define xfunction:=_function}
 {$define xwindow:=window}
 {$define xlookupkeysym_:=xlookupkeysymval}
 {$define c_class:= _class}
 {$define xtextproperty:= txtextproperty}

{$else}
 txpointer = pointer;
   PXIM = ^TXIM;
   TXIM = record
     end;

   PXIC = ^TXIC;
   TXIC = record
     end;
   TXIMProc = procedure (para1:TXIM; para2:TXPointer; para3:TXPointer);cdecl;

   TXICProc = function (para1:TXIC; para2:TXPointer; para3:TXPointer):TBool;cdecl;
   PXIMCallback = ^TXIMCallback;
   TXIMCallback = record
        client_data : TXPointer;
        callback : TXIMProc;
     end;

   PXICCallback = ^TXICCallback;
   TXICCallback = record
        client_data : TXPointer;
        callback : TXICProc;
     end;
{$endif}

const
 x_copyarea = 62;
 IsUnmapped = 0;
 IsUnviewable = 1;
 IsViewable = 2;
 wholecircle = 360*64;

 defaultfontnames: defaultfontnamesty =
  //stf_default  stf_unicode stf_menu  stf_report   stf_prop      stf_fixed,
      ('',          '',        '',    'Arial',    'Helvetica',      'Courier',
  //stf_swiss    stf_roman          stf_courier
      'Arial', 'Times New Roman', 'Courier New');

 xftdefaultfontnames: defaultfontnamesty =
  //stf_default  stf_unicode stf_menu stf_report stf_prop      stf_fixed,
      ('',          '',         '',    'Arial',   'sans',      'monospace',
  //stf_swiss stf_roman   stf_courier
      'Arial', 'serif', 'Courier New');

 capstyles: array[capstylety] of integer = (capbutt,capround,capprojecting);
 joinstyles: array[joinstylety] of integer = (joinmiter,joinround,joinbevel);

{ definitions for initial window state  }
{ for windows that are not mapped  }
  WithdrawnState = 0;
  {$EXTERNALSYM WithdrawnState}
{ most applications want to start this way  }
  NormalState = 1;
  {$EXTERNALSYM NormalState}
{ application wants to start as an icon  }
  IconicState = 3;
  {$EXTERNALSYM IconicState}
{ Obsolete states no longer defined by ICCCM }
{ don't know or care  }
  DontCareState = 0;
  {$EXTERNALSYM DontCareState}
{ application wants to start zoomed  }
  ZoomState = 2;
  {$EXTERNALSYM ZoomState}
{ application believes it is seldom used;  }
  InactiveState = 4;
  {$EXTERNALSYM InactiveState}

type

 //from region.h
 box = record
  x1,x2,y1,y2: smallint
 end;
 pbox = ^box;
 XRegion = record
    size: integer;
    numRects: integer;
    rects: pbox;
    extents: box;
 end;
 pxregion = ^xregion;

 x11windowty = record
  ic: xic;
  platformdata: array[1..7] of pointer;
 end;
 
 xftstatety = (xfts_clipregionvalid{,xfts_colorvalid});
 xftstatesty = set of xftstatety;
 x11gcty = record
  gcdrawingflags: drawingflagsty;
  gcrasterop: rasteropty;
  gcclipregion: regionty;
  xftdraw: pxftdraw;
  xftcolor: txftcolor;
  xftcolorbackground: txftcolor;
  xftfont: pxftfont;
  xftstate: xftstatesty;
  platformdata: array[12..23] of cardinal; //platform dependent
 end;

 fontmatrixmodety = (fmm_fix,fmm_linear,fmm_matrix);
 x11fontdataty = record
  infopo: pxfontstruct;
  matrixmode: fontmatrixmodety;
  defaultwidth: integer;
  rowlength: word;
  platformdata: array[4..15] of cardinal; //plattform dependent
 end;
{$ifdef FPC}
 Colormap = TXID;
 Atom = type Cardinal;
 Cursor = TXID;
 wchar_t = longword;
 pwchar_t = ^wchar_t;
 ppwchar_t = ^pwchar_t;
{$endif}
 patom = ^atom;
 atomarty = array of atom;
 atomaty = array[0..0] of atom;
 patomaty = ^atomaty;

const
 mouseeventmask = buttonpressmask or buttonreleasemask or pointermotionmask;

 //from keysymdef.h
 XK_BackSpace =     $FF08; //* back space, back char */
 XK_Tab =           $FF09;
 XK_Linefeed =      $FF0A; //* Linefeed, LF */
 XK_Clear =         $FF0B;
 XK_Return =        $FF0D; //* Return, enter */
 XK_Pause =         $FF13; //* Pause, hold */
 XK_Scroll_Lock =   $FF14;
 XK_Sys_Req =       $FF15;
 XK_Escape =        $FF1B;
 XK_Delete =        $FFFF; //* Delete, rubout */

//* Cursor control & motion */
 XK_Home =          $FF50;
 XK_Left =          $FF51; //* Move left, left arrow */
 XK_Up =            $FF52; //* Move up, up arrow */
 XK_Right =         $FF53; //* Move right, right arrow */
 XK_Down =          $FF54; //* Move down, down arrow */
 XK_Prior =         $FF55; //* Prior, previous */
 XK_Page_Up =       $FF55;
 XK_Next =          $FF56; //* Next */
 XK_Page_Down =     $FF56;
 XK_End =           $FF57; //* EOL */
 XK_Begin =         $FF58; //* BOL */

//* Misc Functions */
 XK_Select =        $FF60; //* Select, mark */
 XK_Print =         $FF61;
 XK_Execute =       $FF62; //* Execute, run, do */
 XK_Insert =        $FF63; //* Insert, insert here */
 XK_Undo =          $FF65; //* Undo, oops */
 XK_Redo =          $FF66; //* redo, again */
 XK_Menu =          $FF67;
 XK_Find =          $FF68; //* Find, search */
 XK_Cancel =        $FF69; //* Cancel, stop, abort, exit */
 XK_Help =          $FF6A; //* Help */
 XK_Break =         $FF6B;
 XK_Mode_switch =   $FF7E; //* Character set switch */
 XK_script_switch = $FF7E; //* Alias for mode_switch */
 XK_Num_Lock =      $FF7F;

//* Keypad Functions, keypad numbers cleverly chosen to map to ascii */
 XK_KP_Space =      $FF80; //* space */
 XK_KP_Tab =        $FF89;
 XK_KP_Enter =      $FF8D; //* enter */
 XK_KP_F1 =         $FF91; //* PF1, KP_A, ... */
 XK_KP_F2 =         $FF92;
 XK_KP_F3 =         $FF93;
 XK_KP_F4 =         $FF94;
 XK_KP_Home =       $FF95;
 XK_KP_Left =       $FF96;
 XK_KP_Up =         $FF97;
 XK_KP_Right =      $FF98;
 XK_KP_Down =       $FF99;
 XK_KP_Prior =      $FF9A;
 XK_KP_Page_Up =    $FF9A;
 XK_KP_Next =       $FF9B;
 XK_KP_Page_Down =  $FF9B;
 XK_KP_End =        $FF9C;
 XK_KP_Begin =      $FF9D;
 XK_KP_Insert =     $FF9E;
 XK_KP_Delete =     $FF9F;
 XK_KP_Equal =      $FFBD; //* equals */
 XK_KP_Multiply =   $FFAA;
 XK_KP_Add =        $FFAB;
 XK_KP_Separator =  $FFAC; //* separator, often comma */
 XK_KP_Subtract =   $FFAD;
 XK_KP_Decimal =    $FFAE;
 XK_KP_Divide =     $FFAF;

 XK_KP_0 =          $FFB0;
 XK_KP_1 =          $FFB1;
 XK_KP_2 =          $FFB2;
 XK_KP_3 =          $FFB3;
 XK_KP_4 =          $FFB4;
 XK_KP_5 =          $FFB5;
 XK_KP_6 =          $FFB6;
 XK_KP_7 =          $FFB7;
 XK_KP_8 =          $FFB8;
 XK_KP_9 =          $FFB9;

 XK_F1 =            $FFBE;
 XK_F35 =           $FFE0;

//* Modifiers */
 XK_Shift_L =       $FFE1; //* Left shift */
 XK_Shift_R =       $FFE2; //* Right shift */
 XK_Control_L =     $FFE3; //* Left control */
 XK_Control_R =     $FFE4; //* Right control */
 XK_Caps_Lock =     $FFE5; //* Caps lock */
 XK_Shift_Lock =    $FFE6; //* Shift lock */

 XK_Meta_L =        $FFE7; //* Left meta */
 XK_Meta_R =        $FFE8; //* Right meta */
 XK_Alt_L =         $FFE9; //* Left alt */
 XK_Alt_R =         $FFEA; //* Right alt */
 XK_Super_L =       $FFEB; //* Left super */
 XK_Super_R =       $FFEC; //* Right super */
 XK_Hyper_L =       $FFED; //* Left hyper */
 XK_Hyper_R =       $FFEE; //* Right hyper */

 //ISO 9995 Function and Modifier Keys
 //Byte 3 = 0xFE

 XK_ISO_Left_Tab =                $FE20;
 XK_ISO_Move_Line_Up =            $FE21;
 XK_ISO_Move_Line_Down =          $FE22;
 XK_ISO_Partial_Line_Up =         $FE23;
 XK_ISO_Partial_Line_Down =       $FE24;
 XK_ISO_Partial_Space_Left =      $FE25;
 XK_ISO_Partial_Space_Right =     $FE26;
 XK_ISO_Set_Margin_Left =         $FE27;
 XK_ISO_Set_Margin_Right =        $FE28;
 XK_ISO_Release_Margin_Left =     $FE29;
 XK_ISO_Release_Margin_Right =    $FE2A;
 XK_ISO_Release_Both_Margins =    $FE2B;
 XK_ISO_Fast_Cursor_Left =        $FE2C;
 XK_ISO_Fast_Cursor_Right =       $FE2D;
 XK_ISO_Fast_Cursor_Up =          $FE2E;
 XK_ISO_Fast_Cursor_Down =        $FE2F;
 XK_ISO_Continuous_Underline =    $FE30;
 XK_ISO_Discontinuous_Underline = $FE31;
 XK_ISO_Emphasize =               $FE32;
 XK_ISO_Center_Object =           $FE33;
 XK_ISO_Enter =                   $FE34;

 //from cursorfont.h
 XC_num_glyphs =         154;
 XC_X_cursor =             0;
 XC_arrow =                2;
 XC_based_arrow_down =     4;
 XC_based_arrow_up =       6;
 XC_boat =                 8;
 XC_bogosity =            10;
 XC_bottom_left_corner =  12;
 XC_bottom_right_corner = 14;
 XC_bottom_side =         16;
 XC_bottom_tee =          18;
 XC_box_spiral =          20;
 XC_center_ptr =          22;
 XC_circle =              24;
 XC_clock =               26;
 XC_coffee_mug =          28;
 XC_cross =               30;
 XC_cross_reverse =       32;
 XC_crosshair =           34;
 XC_diamond_cross =       36;
 XC_dot =                 38;
 XC_dotbox =              40;
 XC_double_arrow =        42;
 XC_draft_large =         44;
 XC_draft_small =         46;
 XC_draped_box =          48;
 XC_exchange =            50;
 XC_fleur =               52;
 XC_gobbler =             54;
 XC_gumby =               56;
 XC_hand1 =               58;
 XC_hand2 =               60;
 XC_heart =               62;
 XC_icon =                64;
 XC_iron_cross =          66;
 XC_left_ptr =            68;
 XC_left_side =           70;
 XC_left_tee =            72;
 XC_leftbutton =          74;
 XC_ll_angle =            76;
 XC_lr_angle =            78;
 XC_man =                 80;
 XC_middlebutton =        82;
 XC_mouse =               84;
 XC_pencil =              86;
 XC_pirate =              88;
 XC_plus =                90;
 XC_question_arrow =      92;
 XC_right_ptr =           94;
 XC_right_side =          96;
 XC_right_tee =           98;
 XC_rightbutton =        100;
 XC_rtl_logo =           102;
 XC_sailboat =           104;
 XC_sb_down_arrow =      106;
 XC_sb_h_double_arrow =  108;
 XC_sb_left_arrow =      110;
 XC_sb_right_arrow =     112;
 XC_sb_up_arrow =        114;
 XC_sb_v_double_arrow =  116;
 XC_shuttle =            118;
 XC_sizing =             120;
 XC_spider =             122;
 XC_spraycan =           124;
 XC_star =               126;
 XC_target =             128;
 XC_tcross =             130;
 XC_top_left_arrow =     132;
 XC_top_left_corner =    134;
 XC_top_right_corner =   136;
 XC_top_side =           138;
 XC_top_tee =            140;
 XC_trek =               142;
 XC_ul_angle =           144;
 XC_umbrella =           146;
 XC_ur_angle =           148;
 XC_watch =              150;
 XC_xterm =              152;

 {
 cursorshapety = (cr_default,
             cr_none,cr_arrow,cr_cross,cr_wait,cr_ibeam,
             cr_sizever,cr_sizehor,cr_sizebdiag,cr_sizefdiag,cr_sizeall,
             cr_splitv,cr_splith,cr_pointinghand,cr_forbidden,cr_drag,
             cr_topleftcorner,cr_bottomleftcorner,
             cr_bottomrightcorner,cr_toprightcorner,
             cr_res0,cr_res1,cr_res2,cr_res3,cr_res4,cr_res5,cr_res6,cr_res7,
             cr_user);
  }
 defaultshape = xc_left_ptr;
 standardcursors: array[cursorshapety] of cardinal = (
      defaultshape,defaultshape,xc_left_ptr,xc_crosshair,xc_watch,xc_xterm,
      xc_sb_v_double_arrow,xc_sb_h_double_arrow,xc_top_right_corner,xc_bottom_right_corner,xc_fleur,
      xc_sb_v_double_arrow,xc_sb_h_double_arrow,xc_hand2,xc_circle,xc_sailboat,
      xc_top_left_corner,xc_bottom_left_corner,
      xc_bottom_right_corner,xc_top_right_corner,
      defaultshape,defaultshape,defaultshape,defaultshape,
      defaultshape,defaultshape,defaultshape,defaultshape,
      defaultshape);
type
 wmprotocolty = (wm_delete_window
  {$ifdef with_saveyourself},wm_save_yourself{$endif});
 XErrorHandler = function (Display: PDisplay; ErrorEvent: PXErrorEvent):
    Longint; cdecl;
 wmstatety = (wms_none,wms_withdrawn,wms_normal,wms_invalid,wms_iconic);

var
 xlockerror: integer; 
 appdisp: pdisplay;
 appid: winidty;
 defscreen: pscreen;
 defvisual: msepvisual;
 defdepth: integer;
 msecolormap: colormap;
 istruecolor: boolean;
 is8bitcolor: boolean;
 xredmask,xgreenmask,xbluemask: cardinal;
 xredshift,xgreenshift,xblueshift: integer;
 xredshiftleft,xgreenshiftleft,xblueshiftleft: boolean;
 defcolormap: colormap;
 hasxrender: boolean;
 fhasxft: boolean;
 hassm: boolean;
 toplevelraise: boolean;
 screenrenderpictformat,bitmaprenderpictformat,alpharenderpictformat: pxrenderpictformat;

 rootid: winidty;
 atomatom: atom;
 mseclientmessageatom,{timeratom,wakeupatom,}
 wmprotocolsatom,wmstateatom,wmnameatom,wmclassatom: atom;
 wmclientleaderatom: atom;
 wmprotocols: array[wmprotocolty] of atom;
 clipboardatom: atom;
 cardinalatom,windowatom,stringatom,utf8_stringatom,compound_textatom,textatom: atom;
 targetsatom: atom;
 convertselectionpropertyatom: atom;

 {$ifdef with_sm}
type
 sminfoty = record
  iceconnection: iceconn;
  smconnection: smcconn;
  fd: integer;
  shutdown: boolean;
  shutdownpending: boolean;
  interactstyle: integer;
  interactwaiting,interactgranted: boolean;
 end;
 psminfoty = ^sminfoty;
var
 sminfo: sminfoty;
 {$endif}
 
 {$ifdef with_saveyourself}
 wmcommandatom: atom;
 saveyourselfwindow: integer;
 {$endif}
 
type
 netatomty = 
      (net_supported,net_workarea,
       net_wm_state,
       net_wm_state_maximized_vert,net_wm_state_maximized_horz,
       //not needed below
       net_wm_state_fullscreen,
       net_frame_extents,
       net_request_frame_extents,
       net_wm_pid,
       net_none);
 netwmstateoperationty = (nso_remove,nso_add,nso_toggle);
const
 netatomnames: array[netatomty] of string = 
      ('_NET_SUPPORTED','_NET_WORKAREA',
       '_NET_WM_STATE',
       '_NET_WM_STATE_MAXIMIZED_VERT','_NET_WM_STATE_MAXIMIZED_HORZ',
       //not needed below
       '_NET_WM_STATE_FULLSCREEN',
       '_NET_FRAME_EXTENTS', 
       '_NET_REQUEST_FRAME_EXTENTS',
       '_NET_WM_PID', 
       ''); 
 needednetatom = netatomty(ord(high(netatomty))-4);
var
 netatoms: array[netatomty] of atom;
 netsupported: boolean;
 canfullscreen: boolean;
 canframeextents: boolean;
 netsupportedatom: atom;

 sigtimerbefore: sighandler_t;
 sigtermbefore: sighandler_t;
 sigchldbefore: sighandler_t;
 timerevent: boolean;
 terminated: boolean;
 childevent: boolean;
// cursorshape: cursorshapety;
 screencursor: cursor;
 im: xim;
 appic: xic;
 appicmask: longword;
 icwindow: windowty;
 imewinid: winidty;
 errorhandlerbefore: xerrorhandler;
 lasteventtime: cardinal;
// lastshiftstate: shiftstatesty;
 clipboard: msestring;

function gui_grouphideminimizedwindows: boolean;
begin
 result:= false;
end;

function hasxft: boolean;
begin
 result:= fhasxft;
end;

function gui_getdefaultfontnames: defaultfontnamesty;
begin
 if fhasxft then begin
  result:= xftdefaultfontnames;
 end
 else begin
  result:= defaultfontnames;
 end;
end;

function gui_canstackunder: boolean;
begin
 result:= false; //no solution found to restack windows in kde
//result:= true;
end;

function gui_copytoclipboard(const value: msestring): guierrorty;
begin
 clipboard:= value;
 xsetselectionowner(appdisp,clipboardatom,appid,lasteventtime);
 result:= gue_ok;
end;

function eventlater(const atime: cardinal): boolean;
begin
 result:= (atime = currenttime) or (lasteventtime = currenttime) or
                           laterorsame(lasteventtime,atime);
end;

function gui_pastefromclipboard(out value: msestring): guierrorty;
const
 transferbuffersize = 1024 div 4; //1kb
var 
 clipboardowner: cardinal;
 value1: string;
 nitems1: integer;
 acttype: atom;
 actformat: cardinal;
  
 function getdata(const target: atom; const resulttarget: atom): guierrorty;
 var
  event: xevent;
  po1: pchar;
  nitems: cardinal;
  bytesafter: cardinal;
  charoffset: integer;
  longoffset: integer;
  time1: cardinal;
  int1: integer;
  bo1,bo2: boolean;
 begin
  result:= gue_clipboard;
  charoffset:= 1;
  longoffset:= 0;
  xdeleteproperty(appdisp,appid,convertselectionpropertyatom);
  repeat      //remove pending notifications
  until not (xcheckwindowevent(appdisp,appid,propertychangemask,@event)
             {$ifndef xbooleanresult} <> 0{$endif});
  xconvertselection(appdisp,clipboardatom,target,convertselectionpropertyatom,
                       appid,lasteventtime);
  time1:= timestep(2000000); //2 sec
  bo1:= true;
  repeat
   bo1:= not (xcheckwindowevent(appdisp,appid,propertychangemask,@event)
             {$ifndef xbooleanresult} = 0 {$endif});
   if bo1 then begin
    with event.xproperty do begin
     bo1:= eventlater(time) and (atom = convertselectionpropertyatom) and
             (state = propertynewvalue);
    end;
   end;
//   if xcheckwindowevent(appdisp,appid,propertychangemask,@event)
//             {$ifndef FPC} = 0 {$endif} then begin
   if not bo1 then begin
    if timeout(time1) then begin
     exit;
    end;
    if bo1 then begin
     bo1:= false;
     sleep(0);
    end
    else begin
     sleep(20);
    end;
   end
   else begin
    with event.xproperty do begin
     nitems1:= 0;
     bytesafter:= 0;
     value1:= '';
     repeat
      if xgetwindowproperty(appdisp,appid,convertselectionpropertyatom,
           longoffset,transferbuffersize,{$ifdef xboolean} true{$else}1{$endif},
          anypropertytype,@acttype,@actformat,@nitems,@bytesafter,@po1) = success then begin
       if (resulttarget = 0) or (acttype = resulttarget) then begin
        int1:= (actformat div 8) * nitems; //bytecount
        if nitems > 0 then begin
         inc(nitems1,nitems);
         setlength(value1,length(value1) + int1 );
         move(po1^,value1[charoffset],int1);
         inc(charoffset,int1);
         inc(longoffset,int1 div 4); //32 bit
         result:= gue_ok;
        end;
       end
       else begin
        bytesafter:= 0;
        result:= gue_clipboard;
       end;
       xfree(po1);
      end
      else begin
       if timeout(time1) then begin
        exit;
       end;
      end;
     until bytesafter = 0;
     break;
    end;
   end;
  until false;
 end;

var
 int1,int2: integer; 
 po1: patomaty;
 atoms1: array[0..3] of atom;
 atom1: atom;
 po2: ppchar;
 prop1: xtextproperty;

begin
 clipboardowner:= xgetselectionowner(appdisp,clipboardatom);
 if clipboardowner = appid then begin
  value:= clipboard;
  result:= gue_ok;
 end
 else begin
  result:= gue_clipboard;
  value:= '';
  if clipboardowner <> none then begin
   result:= getdata(targetsatom,atomatom);
   if result = gue_ok then begin
    po1:= pointer(value1);
    atom1:= 0;
    atoms1[0]:= utf8_stringatom; //preferred
    atoms1[1]:= compound_textatom;
    atoms1[2]:= textatom;
    atoms1[3]:= stringatom;
    for int2:= low(atoms1) to high(atoms1) do begin
     for int1:= 0 to (length(value1) div sizeof(atom)) - 1 do begin
      if po1^[int1] = atoms1[int2] then begin
       atom1:= atoms1[int2];
       break;
      end;
     end;
     if atom1 <> 0 then begin
      break;
     end;
    end;
    if atom1 <> 0 then begin
     result:= getdata(atom1,0);
     if result = gue_ok then begin      
      if acttype = utf8_stringatom then begin
        value:= utf8tostring(value1);
      end
      else begin
       if acttype = textatom then begin
        value:= value1; //current locale
       end
       else begin
        if acttype = compound_textatom then begin
         with prop1 do begin
          value:= pointer(value1);
          encoding:= acttype;
          format:= actformat;
          nitems:= nitems1;
         end;
         xutf8textpropertytotextlist(appdisp,@prop1,@po2,@int1);
         if int1 >= 1 then begin
          value:= utf8tostring(string(po2^));
         end;
         xfreestringlist(po2);
        end
        else begin
         value:= latin1tostring(value1);
        end;
       end;
      end;
     end;
    end;
   end;
  end;
 end;
end;

function gui_canpastefromclipboard: boolean;
begin
 result:= xgetselectionowner(appdisp,clipboardatom) <> none;
end;

type
 ucs4string = array of wchar_t;

function msestringtoucs4string(const value: msestring): ucs4string;
var
 po1: pmsechar;
 po2: pwchar_t;
begin
 setlength(result,length(value)+1);
 po1:= pmsechar(value);
 po2:= pwchar_t(result);
 while true do begin
  {$ifdef FPC} {$checkpointer off} {$endif} //po1 can be in textsegment
  po2^:= ord(po1^);
  if po1^ = #0 then begin
   break;
  end;
  {$ifdef FPC} {$checkpointer default} {$endif}
  inc(po1);
  inc(po2);
 end;
end;

procedure setstringproperty(id: winidty; prop: atom; value: string);
begin
 xchangeproperty(appdisp,id,prop,stringatom,8,propmodereplace,pbyte(pchar(value)),length(value)+1);
end;

procedure setwinidproperty(id: winidty; prop: atom; value: winidty);
begin
 xchangeproperty(appdisp,id,prop,windowatom,32,propmodereplace,@value,1);
end;

procedure setcardinalproperty(id: winidty; prop: atom; value: cardinal);
begin
 xchangeproperty(appdisp,id,prop,cardinalatom,32,propmodereplace,@value,1);
end;

function readlongproperty(id: winidty; name: atom; count: cardinal; var value): boolean;
var
 actualtype: atom;
 actualformat: integer;
 nitems: cardinal;
 bytesafter: cardinal;
 prop: pchar;
begin
 result:= false;
 if xgetwindowproperty(appdisp,id,name,0,count,{$ifdef xboolean}false{$else}0{$endif},
        anypropertytype,@actualtype,@actualformat,@nitems,@bytesafter,@prop) = success then begin
  if nitems = count then begin
 {$ifdef FPC} {$checkpointer off} {$endif}
   move(prop^,value,integer(nitems)*actualformat div 8);
 {$ifdef FPC} {$checkpointer default} {$endif}
   result:= true;
  end;
  xfree(prop);
 end;
end;

function readatomproperty(id: winidty; name: atom; var value: atomarty): boolean;
var
 actualtype: atom;
 actualformat: integer;
 nitems: cardinal;
 bytesafter: cardinal;
 prop: pchar;
begin
 result:= false;
 if xgetwindowproperty(appdisp,id,name,0,10000,{$ifdef xboolean}false{$else}0{$endif},
   atomatom,@actualtype,@actualformat,@nitems,@bytesafter,@prop) = success then begin
  if actualtype = atomatom then begin
   setlength(value,nitems);
   if nitems > 0 then begin
 {$ifdef FPC} {$checkpointer off} {$endif}
    move(prop^,value[0],integer(nitems)*actualformat div 8);
 {$ifdef FPC} {$checkpointer default} {$endif}
   end;
   result:= true;
  end;
  xfree(prop);
 end;
end;

function stringtotextproperty(const value: msestring; const style: txiccencodingstyle;
                                  out textproperty: xtextproperty): boolean;
var
 list: array[0..0] of ucs4string;
begin
 list[0]:= msestringtoucs4string(value);
 result:= xwctextlisttotextproperty(appdisp,@list,1,ord(style),@textproperty) >= 0;
 if not result then begin
  fillchar(textproperty,0,sizeof(textproperty));
 end;
end;

{
function stringtotextproperty(const value: msestring; const style: txiccencodingstyle;
                               out textproperty: xtextproperty): boolean;
var
 list: array[0..0] of pchar;
 str1: utf8string;
begin
 str1:= stringtoutf8(value);
 list[0]:= pchar(str1);
 result:= xutf8textlisttotextproperty(appdisp,@list,1,style,@textproperty) >= 0;
 if not result then begin
  fillchar(textproperty,0,sizeof(textproperty));
 end;
end;
}
function getwmstate(id: winidty): wmstatety;
type
 wmstatety = record
  state: longword;
  icon: winidty;
 end;
 pwmstatety = ^wmstatety;

var
 typeatom: atom;
 format: longint;
 itemcount: longint;
 po1: pwmstatety;
 bytesafterreturn: longword;

begin
 result:= wms_none;
 if xgetwindowproperty(appdisp,id,wmstateatom,0,2,
      {$ifdef xboolean}false{$else}0{$endif},wmstateatom,@typeatom,@format,
      @itemcount,@bytesafterreturn,@po1) = success then begin
{$ifdef FPC} {$checkpointer off} {$endif}
  if (format = 32) and (itemcount = 2) then begin
   {$ifdef FPC}longword{$else}byte{$endif}(result):= po1^.state + longword(wms_withdrawn);
  end;
{$ifdef FPC} {$checkpointer default} {$endif}
  xfree(po1);
 end;
end;

function mserootwindow(id: winidty = 0): winidty;
var
 x,y: integer;
 width,height,border,depth: cardinal;
begin
 if id <> 0 then begin
  if xgetgeometry(appdisp,id,@result,@x,@y,@width,@height,@border,@depth) <> 0 then begin
   exit;
  end;
 end;
 result:= rootid;
end;

function gui_getwindowsize(id: winidty): windowsizety;
var
 state: wmstatety;
 atomar: atomarty;
 int1: integer;
 maxh,maxv: boolean;
begin
 state:= getwmstate(id);
 case state of
  wms_iconic: begin
   result:= wsi_minimized;
  end;
  else begin
   result:= wsi_normal;
   if netsupported and readatomproperty(id,netatoms[net_wm_state],atomar) then begin
    maxh:= false;
    maxv:= false;
    for int1:= 0 to high(atomar) do begin
     if atomar[int1] = netatoms[net_wm_state_fullscreen] then begin
      result:= wsi_fullscreen;
      break;
     end;
     if (atomar[int1] = netatoms[net_wm_state_maximized_vert]) then begin
      maxv:= true;
     end
     else begin
      if (atomar[int1] = netatoms[net_wm_state_maximized_horz]) then begin
       maxh:= true;
      end;
     end;
    end;
    if (result = wsi_normal) and maxh and maxv then begin
     result:= wsi_maximized;
    end;
   end;
  end;
 end;
end;

function changenetwmstate(id: winidty; const operation: netwmstateoperationty;
                  const value1: netatomty; const value2: netatomty = net_none): boolean;
var
 xevent: xclientmessageevent;
begin
 result:= false;
 if netsupported then begin
  fillchar(xevent,sizeof(xevent),0);
  with xevent do begin
   xtype:= clientmessage;
   display:= appdisp;
   xwindow:= id;
   format:= 32;
   message_type:= netatoms[net_wm_state];
   data.l[0]:= ord(operation);
   data.l[1]:= netatoms[value1];
   data.l[2]:= netatoms[value2];
   if xsendevent(appdisp,mserootwindow(id),{$ifdef xboolean}false{$else}0{$endif},
            substructurenotifymask or substructureredirectmask,@xevent) <> 0 then begin
    result:= true;
   end;
  end;
 end;
end;

function waitfordecoration(id: winidty; raiseexception: boolean = true): boolean;
var
 int1: integer;
begin
 int1:= 0;
 result:= false;
 repeat
  xflush(appdisp);    //windowmanager has to work
  if gui_windowvisible(id) then begin
   result:= true;
   break;
  end;
//  xflush(appdisp);    //windowmanager has to work
  sleep(5*int1);
  inc(int1);
 until (int1 > 45);
 if raiseexception and not result then begin
  raise exception.Create('not decorated');
 end;
end;

function gui_setwindowstate(id: winidty; size: windowsizety;
                                        visible: boolean): guierrorty;
 procedure fullscreen;
 begin
  gui_reposwindow(id,gui_getworkarea(id));
 end;

begin
 result:= gue_ok;
 if visible then begin
  xmapwindow(appdisp,id);
 end;
 if size = wsi_fullscreen then begin
  if not canfullscreen or not changenetwmstate(id,nso_add,net_wm_state_fullscreen) then begin
   fullscreen; //no windowmanager
  end;
 end
 else begin
  changenetwmstate(id,nso_remove,
                  net_wm_state_fullscreen);
  case size of
   wsi_minimized: begin
    if xiconifywindow(appdisp,id,0) = 0 then begin
     result:= gue_show;
    end;
    exit;
   end;
   wsi_maximized: begin
    if not changenetwmstate(id,nso_add,
           net_wm_state_maximized_horz,net_wm_state_maximized_vert) then begin
     fullscreen;
    end;
   end
   else begin
    changenetwmstate(id,nso_remove,
                  net_wm_state_maximized_horz,net_wm_state_maximized_vert);
   end;
  end;
 end;
end;

procedure freetextproperty(const value: xtextproperty);
begin
 xfree(value.value);
end;

function gui_setwindowcaption(id: winidty; const caption: msestring): guierrorty;
var
 textprop: xtextproperty;
begin
 if stringtotextproperty(caption,xstdicctextstyle,textprop) then begin
  xsetwmname(appdisp,id,@textprop);
  freetextproperty(textprop);
  result:= gue_ok;
 end
 else begin
  result:= gue_characterencoding;
 end;
end;

function gui_setwindowicon(id: winidty; const icon,mask: pixmapty): guierrorty;
var
 hints: pxwmhints;
begin
{$ifdef FPC}{$checkpointer off}{$endif}
 hints:= pxwmhints(xgetwmhints(appdisp,id));
 if hints = nil then begin
  hints:= pxwmhints(xallocwmhints);
 end;
 with hints^ do begin
  icon_pixmap:= icon;
  icon_mask:= mask;
  updatebit(cardinal(flags),2,icon <> 0); //iconpixmaphint
  updatebit(cardinal(flags),5,mask <> 0); //iconmaskhint
 end;
 xsetwmhints(appdisp,id,hints);
 xfree(hints);
{$ifdef FPC}{$checkpointer default}{$endif}
 result:= gue_ok;
end;

function gui_setapplicationicon(const icon,mask: pixmapty): guierrorty;
begin
 result:= gue_ok;
end;

function gui_pidtowinid(const pids: integerarty): winidty;

var
 level: integer;
 
 function scanchildren(const aparent: winidty): boolean;
 
  function checkpid(const apid: integer): boolean;
  var
   int1: integer;
  begin
   result:= false;
   for int1:= 0 to high(pids) do begin
    if pids[int1] = apid then begin
     result:= true;
     break;
    end;
   end;
  end;
  
 var
  parent,root: winidty;
  ca1: cardinal;
  children: pwindow;
  int1: integer;
//  id1: winidty;
  ar1: atomarty;
 begin
  result:= false;
  if (gui_windowvisible(aparent) or (getwmstate(aparent) = wms_iconic)) and
   readlongproperty(aparent,netatoms[net_wm_pid],1,int1) and checkpid(int1) then begin
   result:= true;
   gui_pidtowinid:= aparent;
  end
  else begin 
   if not netsupported or 
            not readatomproperty(aparent,netatoms[net_wm_state],ar1) then begin
     //no wm toplevel window
    if (xquerytree(appdisp,aparent,@root,@parent,@children,@ca1) <> 0) and 
        (children <> nil) then begin
     inc(level);
     for int1:= integer(ca1)-1 downto 0 do begin
      if scanchildren(pwinidaty(children)^[int1]) then begin
       result:= true;
       break;
      end;
     end;
     dec(level);
     xfree(children);
    end;
   end;
  end;
 end;
  
begin
 result:= 0;
 level:= 0;
 if (netatoms[net_wm_pid] <> 0) then begin
  scanchildren(mserootwindow);
 end;
end;

function XDestroyImage(Image: PXImage): Longint;
begin
{$ifdef FPC} {$checkpointer off} {$endif}
  Result := Image^.f.destroy_image(Image);
{$ifdef FPC} {$checkpointer default} {$endif}
end;

function getwindowstack(const id: winidty): winidarty;
var
 parent,root: winidty;
 ca1: cardinal;
 children: pwindow;
 count: integer;
begin
 result:= nil;
 count:= 0;
 additem(integerarty(result),id,count);
 parent:= id;
 repeat
  if (xquerytree(appdisp,parent,@root,@parent,@children,@ca1) <> 0) then begin
   if children <> nil then begin
    xfree(children);
   end;
  end
  else begin
   break;
  end;
  additem(integerarty(result),parent,count);
 until (parent = root);
 setlength(result,count);
end;

function toplevelwindow(const id: winidty): winidty;
var
 ar1: winidarty;
begin
 ar1:= getwindowstack(id);
 if high(ar1) > 0 then begin
  result:= ar1[high(ar1)-1];
 end
 else begin
  result:= 0;
 end;
end;

function gui_getzorder(const ids: winidarty; out zorders: integerarty): guierrorty;
var
 ar1: winidararty;
 int1,int2,int3: integer;
 bo1: boolean;
 parent,root: winidty;
 ca1: cardinal;
 children: pwindow;

begin
{$ifdef FPC} {$checkpointer off} {$endif}
 setlength(zorders,length(ids));
 if high(ids) > 0 then begin
  setlength(ar1,length(ids));
  for int1:= 0 to high(ids) do begin
   ar1[int1]:= getwindowstack(ids[int1]);
  end;
  if high(ar1[0]) > 0 then begin
   int2:= 0;
   bo1:= false;
   repeat                    //find common ancestor
    inc(int2);
    int3:= ar1[0][high(ar1[0])-int2];
    for int1:= 1 to high(ar1) do begin
     if (int2 > high(ar1[int1])) or (integer(ar1[int1][high(ar1[int1])-int2]) <> int3) then begin
      bo1:= true;
      break;
     end;
    end;
   until bo1;
   if (xquerytree(appdisp,ar1[0][high(ar1[0])-(int2-1)],@root,@parent,@children,@ca1) <> 0) then begin
    for int1:= 0 to ca1 - 1 do begin
     for int3:= 0 to high(ids) do begin
      if integer(ar1[int3][high(ar1[int3])-int2]) = pintegeraty(children)^[int1] then begin
       zorders[int3]:= int1;
       break;
      end;
     end;
    end;
    if children <> nil then begin
     xfree(children);
    end;
   end;
  end;
 end;
{$ifdef FPC} {$checkpointer default} {$endif}
 result:= gue_ok;
end;

function gui_raisewindow(id: winidty): guierrorty;
begin
 if toplevelraise then begin
//  waitfordecoration(id);
  xraisewindow(appdisp,toplevelwindow(id));
 end
 else begin
  xraisewindow(appdisp,id);
 end;
 result:= gue_ok;
end;

function gui_lowerwindow(id: winidty): guierrorty;
begin
 xlowerwindow(appdisp,id);
 result:= gue_ok;
end;

function stackwindow(id: winidty; predecessor: winidty; stackmode: integer): guierrorty;
var
 changes: xwindowchanges;
 ar1: winidarty;
 int1: integer;
 idindex,pindex: integer;

begin
 if predecessor = 0 then begin
  result:= gui_raisewindow(id);
 end
 else begin
  if id <> predecessor then begin
   if gui_canstackunder then begin
    changes.sibling:= toplevelwindow(predecessor);
    changes.stack_mode:= stackmode;
    xconfigurewindow(appdisp,toplevelwindow(id),cwsibling or cwstackmode,@changes);
   end
   else begin
    application.sortzorder;
    ar1:= application.winidar;
    idindex:= -1;
    pindex:= -1;
    for int1:= high(ar1) downto 0 do begin
     if ar1[int1] = id then begin
      idindex:= int1;
      break;
     end;
    end;
    for int1:= high(ar1) downto 0 do begin
     if ar1[int1] = predecessor then begin
      pindex:= int1;
      break;
     end;
    end;
    if (idindex >= 0) and (pindex >= 0) then begin
     if not (
      (stackmode = above) and (pindex < high(ar1)) and (ar1[pindex+1] = id) or
      (stackmode <> above) and (pindex > 0) and (ar1[pindex-1] = id)
       ) then begin
      deleteitem(integerarty(ar1),idindex);
      if idindex < pindex then begin
       dec(pindex);
      end;
      if stackmode = above then begin
       insertitem(integerarty(ar1),pindex+1,id);
      end
      else begin
       insertitem(integerarty(ar1),pindex,id);
       dec(pindex);
      end;
      if pindex < 0 then begin
       pindex:= 0;
      end;
      for int1:= pindex to high(ar1) do begin
       gui_raisewindow(ar1[int1]);
      end;
     end;
    end;
   { //code below does not work because wm takes no notice about the new stacking order
    if xgetwindowattributes(appdisp,changes.sibling,@attributes1) <> 0 then begin
     changes.sibling:= toplevelwindow(predecessor);
     changes.stack_mode:= stackmode;
     id1:= toplevelwindow(id);
     if xgetwindowattributes(appdisp,id1,@attributes2) <> 0 then begin
      attributes3.override_redirect:= 1;
      if attributes1.override_redirect = 0 then begin
       xchangewindowattributes(appdisp,changes.sibling,cwoverrideredirect,@attributes3);
      end;
      if attributes2.override_redirect = 0 then begin
       xchangewindowattributes(appdisp,id1,cwoverrideredirect,@attributes3);
      end;
      xconfigurewindow(appdisp,id1,cwsibling or cwstackmode,@changes);
      attributes3.override_redirect:= 0;
      if attributes1.override_redirect = 0 then begin
       xchangewindowattributes(appdisp,changes.sibling,cwoverrideredirect,@attributes3);
      end;
      if attributes2.override_redirect = 0 then begin
       xchangewindowattributes(appdisp,id1,cwoverrideredirect,@attributes3);
      end;
     end;
     application.sortzorder;
     ar1:= application.winidar;
     for int1:= 0 to high(ar1) do begin
      if (ar1[int1] = id) or (ar1[int1] = predecessor) then begin
       for int2:= int1 to high(ar1) do begin
        xraisewindow(appdisp,ar1[int1]);
       end;
       break;
      end;
     end;
    end;
    }
   end;
  end;
  result:= gue_ok;
 end;
end;

function gui_stackunderwindow(id: winidty; predecessor: winidty): guierrorty;
begin
 result:= stackwindow(id,predecessor,below);
end;

function gui_stackoverwindow(id: winidty; predecessor: winidty): guierrorty;
begin
 result:= stackwindow(id,predecessor,above);
end;

function gui_getscreensize: sizety;
begin
{$ifdef FPC} {$checkpointer off} {$endif}
 result.cx:= defscreen^.width;
 result.cy:= defscreen^ .height;
{$ifdef FPC} {$checkpointer default} {$endif}
end;

function gui_getworkarea(id: winidty): rectty;
var
 bo1: boolean;
begin
 bo1:= false;
 if netsupported then begin
  bo1:= readlongproperty(mserootwindow(id),netatoms[net_workarea],4,result);
 end;
 if not bo1 then begin
  result:= makerect(nullpoint,gui_getscreensize);
 end;
end;

function getwindowframe(id: winidty): framety;
var
 bo1: boolean;
 ar1: array[0..3] of integer;
 win1: winidty;
 root: winidty;
 rect1,rect2: rectty;
 int1: integer;
 pt1: pointty;
begin
 bo1:= false;
 if canframeextents then begin
  bo1:= readlongproperty(id,netatoms[net_frame_extents],4,ar1);
 end;
 if bo1 then begin
  with result do begin
   left:= ar1[0];
   top:= ar1[2];
   right:= ar1[1];
   bottom:= ar1[3];
  end;
 end
 else begin
  result:= nullframe;
  if (gui_getwindowrect(id,rect1) = gue_ok) and 
              (gui_getwindowrect(toplevelwindow(id),rect2) = gue_ok) then begin
   result.left:= rect1.x - rect2.x;
   result.top:= rect1.y - rect2.y;                                              
   result.right:= rect2.x + rect2.cx - rect1.x - rect1.cx;
   result.bottom:= rect2.y + rect2.cy - rect1.y - rect1.cy;
  end;  
 end;
end;

function gui_setmainthread: guierrorty; //set mainthread to currentthread
begin
 //not used in linux-x11
 result:= gue_ok;
end;

function gui_getpointerpos: pointty;
var
 ca1: cardinal;
begin
 xquerypointer(appdisp,rootid,@ca1,@ca1,@result.x,@result.y,@ca1,@ca1,@ca1);
end;

function gui_setpointerpos(const pos: pointty): guierrorty;
begin
 xwarppointer(appdisp,none,rootid,0,0,0,0,pos.x,pos.y);
 result:= gue_ok;
end;

function gui_movepointer(const dist: pointty): guierrorty;
begin
 xwarppointer(appdisp,rootid,none,0,0,0,0,dist.x,dist.y);
 result:= gue_ok;
end;

var
 pointergrabbed: boolean;
 grabwinid: winidty;
 
function gui_grabpointer(id: winidty): guierrorty;
begin
 xflush(appdisp);
 if xgrabpointer(appdisp,id,{$ifdef xboolean}false{$else}0{$endif},
           mouseeventmask,grabmodeasync,grabmodeasync,
           none,none,currenttime) = grabsuccess then begin
  result:= gue_ok;
  pointergrabbed:= true;
  grabwinid:= id;
 end
 else begin
  result:= gue_capturemouse;
 end;
end;

function gui_ungrabpointer: guierrorty;
begin
 xungrabpointer(appdisp,currenttime);
 result:= gue_ok;
 pointergrabbed:= false; 
end;

function gui_allocimagemem(length: integer): pcardinalaty;
begin
 if length = 0 then begin
  result:= nil;
 end
 else begin
  getmem(result,length * sizeof(cardinal));
 end;
end;

procedure gui_freeimagemem(data: pcardinalaty);
begin
 freemem(data);
end;

function gui_pixmaptoimage(pixmap: pixmapty; out image: imagety;
                                      gchandle: cardinal): gdierrorty;
var
 info: pixmapinfoty;
 ximage1: pximage;
 po1: pcardinal;
 po2: pbyte;
 int1,int2: integer;
 wordmax: integer;
begin
 info.handle:= pixmap;
 result:= gui_getpixmapinfo(info);
 if result = gde_ok then begin
  image.size:= info.size;
  image.pixels:= nil;
  if info.depth = 1 then begin //monochrome
   image.monochrome:= true;
   ximage1:= xgetimage(appdisp,pixmap,0,0,info.size.cx,info.size.cy,1,xypixmap);
   if ximage1 = nil then begin
    result:= gde_image;
    exit;
   end;
 {$ifdef FPC} {$checkpointer off} {$endif}
   with ximage1^ do begin
    wordmax:= (image.size.cx + 31) div 32;
    image.length:= wordmax * image.size.cy;
    image.pixels:= gui_allocimagemem(image.length);
    po1:= @image.pixels^[0];
    po2:= pbyte(data);
    if bitmap_pad = 32 then begin
     move(po2^,po1^,image.size.cy * bytes_per_line);
    end
    else begin
     for int1:= 0 to image.size.cy - 1 do begin
      move(po2^,po1^,bytes_per_line);
      inc(po2,bytes_per_line);
      inc(po1,wordmax);
     end;
    end;
    if byte_order <> lsbfirst then begin
     case bitmap_unit of
      32: begin
       for int1:= 0 to image.length - 1 do begin
        swapbytes1(image.pixels^[int1]);
       end;
      end;
      16: begin
       for int1:= 0 to image.length*2-1 do begin
        swapbytes1(pwordaty(image.pixels)^[int1]);
       end;
      end;
     end;
    end;
    if bitmap_bit_order <> lsbfirst then begin
     po2:= @image.pixels^[0];
     for int1:= 0 to image.length*4-1 do begin
      po2^:= bitreverse[po2^];
      inc(po2);
     end;
    end;
   end;
 {$ifdef FPC} {$checkpointer default} {$endif}
  end
  else begin
   image.monochrome:= false;
   image.length:= image.size.cx * image.size.cy;
   ximage1:= xgetimage(appdisp,pixmap,0,0,info.size.cx,info.size.cy,$ffffffff,zpixmap);
   if ximage1 = nil then begin
    result:= gde_image;
    exit;
   end;
   image.pixels:= gui_allocimagemem(image.length);

 //todo: optimize

   po1:= @image.pixels[0];
   for int1:= 0 to info.size.cy - 1 do begin
    for int2:= 0 to info.size.cx - 1 do begin
 {$ifdef FPC} {$checkpointer off} {$endif}
     po1^:= gui_pixeltorgb(ximage1^.f.get_pixel(ximage1,int2,int1));
 {$ifdef FPC} {$checkpointer default} {$endif}
     inc(po1);
    end;
   end;
  end;
  xdestroyimage(ximage1);
 end;
end;

function gui_imagetopixmap(const image: imagety; out pixmap: pixmapty;
                         gchandle: cardinal): gdierrorty;
var
 ximage: pximage;
 po1: prgbtriplety;
 po2: pchar;
 gc: tgc;
 int1,int2: integer;
begin
 result:= gde_ok;
 po2:= nil;
 if image.monochrome then begin
  ximage:= XCreateImage(appdisp,nil,1,xypixmap,0,nil,
                                 image.size.cx,image.size.cy,32,0);
  if ximage = nil then begin
   result:= gde_image;
   exit;
  end;
{$ifdef FPC} {$checkpointer off} {$endif}
  with ximage^ do begin
   bitmap_bit_order:= LSBFirst;
   byte_order:= lsbfirst;
   bitmap_unit:= 32;
   data:= @image.pixels[0];
  end;
{$ifdef FPC} {$checkpointer default} {$endif}
 end
 else begin
  ximage:= XCreateImage(appdisp,defvisual,defdepth,zpixmap,0,nil,
                 image.size.cx,image.size.cy,32,0);
  if ximage = nil then begin
   result:= gde_image;
   exit;
  end;
{$ifdef FPC} {$checkpointer off} {$endif}
  with ximage^ do begin
  {
   bitmap_bit_order:= LSBFirst;
   byte_order:= lsbfirst;
   bitmap_unit:= 32;
   red_mask:= redmask;
   green_mask:= greenmask;
   blue_mask:= bluemask;
   data:= @image.pixels[0];
   }
   getmem(po2,image.size.cy * bytes_per_line);
   data:= po2;
   po1:= @image.pixels^[0];
   for int1:= 0 to image.size.cy - 1 do begin
    for int2:= 0 to image.size.cx - 1 do begin
     f.put_pixel(ximage,int2,int1,gui_rgbtopixel(cardinal(po1^)));
     inc(po1);
    end;
   end;
  end;
{$ifdef FPC} {$checkpointer default} {$endif}
 end;
 pixmap:= gui_createpixmap(image.size,0,image.monochrome);
 gc:= xcreategc(appdisp,pixmap,0,nil);
 xsetgraphicsexposures(appdisp,gc,{$ifdef xboolean}false{$else}0{$endif});
 xputimage(appdisp,pixmap,gc,ximage,0,0,0,0,image.size.cx,image.size.cy);
 xfreegc(appdisp,gc);
{$ifdef FPC} {$checkpointer off} {$endif}
 ximage^.data:= nil;
{$ifdef FPC} {$checkpointer default} {$endif}
 xdestroyimage(ximage);
 if po2 <> nil then begin
  freemem(po2);
 end;
end;

function gui_createpixmap(const size: sizety; winid: winidty = 0;
                          monochrome: boolean = false; copyfrom: pixmapty = 0): pixmapty;
var
 gc: tgc;
begin
 inc(pixmapcount);
 if winid = 0 then begin
  winid:= rootid;
 end;
 if monochrome then begin
  result:= xcreatepixmap(appdisp,winid,size.cx,size.cy,1);
 end
 else begin
  result:= xcreatepixmap(appdisp,winid,size.cx,size.cy,defdepth);
 end;
 if copyfrom <> 0 then begin
  gc:= xcreategc(appdisp,result,0,nil);
  xcopyarea(appdisp,copyfrom,result,gc,0,0,size.cx,size.cy,0,0);
  xfreegc(appdisp,gc);
 end;
end;

function gui_freepixmap(pixmap: pixmapty): gdierrorty;
begin
 dec(pixmapcount);
 if xfreepixmap(appdisp,pixmap) <> success then begin
  result:= gde_pixmap;
 end
 else begin
  result:= gde_ok;
 end;
end;

function gui_createbitmapfromdata(const size: sizety; datapo: pbyte;
                   msbitfirst: boolean = false; dwordaligned: boolean = false;
                   bottomup: boolean = false): pixmapty;
var
 image: ximage;
 gc: tgc;
 po1,po2: pbyte;
 int1: integer;

begin
// result:= xcreatebitmapfromdata(appdisp,rootid,datapo,size.cx,size.cy);
 inc(pixmapcount);
 result:= XCreatePixmap(appdisp,rootid,size.cx,size.cy,1);
 if result <> 0 then begin
  gc:= XCreateGC(appdisp,result,0,nil);
  if gc = nil then begin
   xfreepixmap(appdisp,result);
   result:= 0;
  end
  else begin
   with image do begin
    width:= size.cx;
    height:= size.cy;
    depth:= 1;
    bits_per_pixel:= 1;
    xoffset:= 0;
    format:= XYPixmap;
    byte_order:= LSBFirst;
    bitmap_unit:= 8;
    if msbitfirst then begin
     bitmap_bit_order:= mSBFirst;
    end
    else begin
     bitmap_bit_order:= lSBFirst;
    end;
    if dwordaligned then begin
     bitmap_pad:= 32;
     bytes_per_line:= ((size.cx+31) div 32)*4;
    end
    else begin
     bitmap_pad:= 8;
     bytes_per_line:= (size.cx+7) div 8;
    end;
    if bottomup then begin
     getmem(po1,bytes_per_line*size.cy);
     data:= pchar(po1);
     po2:= pbyte(pchar(datapo)+bytes_per_line*(size.cy-1));
     for int1:= 0 to size.cy - 1 do begin
      move(po2^,po1^,bytes_per_line);
      inc(po1,bytes_per_line);
      dec(po2,bytes_per_line);
     end;
     XPutImage(appdisp,result,gc,@image,0,0,0,0,size.cx,size.cy);
     freemem(data);
    end
    else begin
     data:= pchar(datapo);
     XPutImage(appdisp,result,gc,@image,0,0,0,0,size.cx,size.cy);
    end;
   end;
   XFreeGC(appdisp, gc);
  end;
 end;
end;

function gui_getpixmapinfo(var info: pixmapinfoty): gdierrorty;
var
 ca1: cardinal;
begin
 with info do begin
  if xgetgeometry(appdisp,handle,@ca1,@ca1,@ca1,@size.cx,@size.cy,@ca1,@depth) = 0 then begin
   result:= gde_pixmap;
  end
  else begin
   result:= gde_ok;
  end;
 end;
end;

function gui_windowvisible(id: winidty): boolean;
var
 attributes: xwindowattributes;
begin
 xgetwindowattributes(appdisp,id,@attributes);
 result:= attributes.map_state = isviewable;
end;

function hasoverrideredirect(const id: winidty): boolean;
var
 attributes: xwindowattributes;
begin
 xgetwindowattributes(appdisp,id,@attributes);
 result:= (attributes.override_redirect {$ifndef xboolean}<> 0{$endif});
end;

function gui_showwindow(id: winidty): guierrorty;
var
 min,max: sizety;
 rect1: rectty;
 transientfor: winidty;
 bo1: boolean;
begin
 xmapwindow(appdisp,id);
 result:= gue_ok;
 rect1:= nullrect;
 application.checkwindowrect(id,rect1);
 min:= rect1.size;
 rect1.cx:= bigint;
 rect1.cy:= bigint;
 application.checkwindowrect(id,rect1);
 max:= rect1.size;
 if max.cx = bigint then begin
  max.cx:= 0;
 end;
 if max.cy = bigint then begin
  max.cy:= 0;
 end;
 if (max.cx <> 0) or (max.cy <> 0) or (min.cx <> 0) or (min.cy <> 0) then begin
  waitfordecoration(id);
  gui_setsizeconstraints(id,min,max);
 end;
 transientfor:= 0;
 bo1:= xgettransientforhint(appdisp,id,@transientfor) <> 0;
 if hasoverrideredirect(id) or bo1 then begin
  waitfordecoration(id);
  if (transientfor = 0) or (transientfor = mserootwindow) then begin
   gui_raisewindow(id);
  end
  else begin
   waitfordecoration(transientfor);
   gui_raisewindow(transientfor);
   gui_raisewindow(id);   
//   gui_stackunderwindow(transientfor,id);
  end;
 end;
end;
{
procedure printwindowname(aid: winidty; const atext: string);
var
 window1: twindow1;
begin
 if application.findwindow(aid,window1) then begin
  writeln(window1.fowner.name,' ',atext);
 end;
end;
}
function getic(const awindow: winidty): xic;
var
 window1: twindow1;
begin
 result:= appic;
 {$ifdef FPC}
 if application.findwindow(awindow,window1) then begin
 {$else}
 if application.findwindow(awindow,twindow(window1)) then begin
 {$endif}
  with x11windowty(window1.fwindow.platformdata) do begin
   if ic <> nil then begin
    result:= ic;
   end;
  end;
 end;
end;

function gui_setwindowfocus(id: winidty): guierrorty;
begin
// xseticfocus(getic(id));
 waitfordecoration(id);
 xsetinputfocus(appdisp,id,reverttoparent,currenttime);
 result:= gue_ok;
end;

function gui_setimefocus(var awindow: windowty): guierrorty;
begin
 result:= gue_ok;
 with awindow,x11windowty(platformdata) do begin
  if ic <> nil then begin
   xseticvalues(ic,pchar(xnfocuswindow),id,nil);
   xseticfocus(ic);
  end
  else begin
   xseticvalues(appic,pchar(xnfocuswindow),id,nil);
   imewinid:= id;
   xseticfocus(appic);
  end;
 end;
end;

procedure unsetime(const awindow: winidty);
begin
 if awindow = imewinid then begin
  xunseticfocus(appic);
  xseticvalues(appic,pchar(xnfocuswindow),appid,nil);
  imewinid:= 0;
 end;
end;

function gui_unsetimefocus(var awindow: windowty): guierrorty;
begin
 result:= gue_ok;
 with x11windowty(awindow.platformdata) do begin
  if ic <> nil then begin
   xunseticfocus(ic);
  end
  else begin
   unsetime(awindow.id);
  end;
 end;
end;

function gui_setappfocus(id: winidty): guierrorty;
begin
 result:= gui_setwindowfocus(id);
end;

function gui_minimizeapplication: guierrorty;
begin
 result:= gue_ok; //dummy
end;

function gui_setcursorshape(winid: winidty; shape: cursorshapety): guierrorty;
begin
 result:= gue_ok;
 if winid = 0 then begin
  winid:= mserootwindow;
 end;
// if cursorshape <> shape then begin
  if screencursor <> 0 then begin
   xfreecursor(appdisp,screencursor);
  end;
  screencursor:= xcreatefontcursor(appdisp,standardcursors[shape]);
  if screencursor <> 0 then begin
//   cursorshape:= shape;
   xdefinecursor(appdisp,winid,screencursor);
   xflush(appdisp);
  end
  else begin
   result:= gue_cursor;
  end;
// end;
end;

procedure sigtimer(SigNum: Integer); cdecl;
begin
 timerevent:= true;
end;

procedure sigterminate(SigNum: Integer); cdecl;
begin
 terminated:= true;
end;

procedure sigchild(SigNum: Integer); cdecl;
begin
 childevent:= true;
end;

function gui_postevent(event: tevent): guierrorty;
var
 xevent: xclientmessageevent;
begin
 fillchar(xevent,sizeof(xevent),0);
 with xevent do begin
  xtype:= clientmessage;
  format:= 32;
  message_type:= mseclientmessageatom;
  data.l[0]:= integer(event); //todo: 64bit
 end;
 gdi_lock;
 if xsendevent(appdisp,appid,{$ifdef xboolean}false{$else}0{$endif},0,@xevent) = 0 then begin
  result:= gue_postevent;
 end
 else begin
  xflush(appdisp);
  result:= gue_ok;
 end;
 gdi_unlock;
end;

function settimer1(us: cardinal): guierrorty;
               //send et_timer event after delay of us (micro seconds)
var
 timerval: itimerval;
begin
 fillchar(timerval,sizeof(timerval),0);
 timerval.it_value.tv_sec:= us div 1000000;
 timerval.it_value.tv_usec:= us mod 1000000;
 if mselibc.setitimer(itimer_real,{$ifdef FPC}@{$endif}timerval,nil) = 0 then begin
  result:= gue_ok;
 end
 else begin
  result:= gue_timer;
 end;
end;

function gui_settimer(us: cardinal): guierrorty;
begin
 if us = 0 then begin
  us:= 1;
 end;
 result:= settimer1(us);
end;

function recttoxrect(const rect: rectty): xrectangle;
begin
 with rect do begin
  result.x:= x;
  result.y:= y;
  result.width:= cx;
  result.height:= cy;
 end;
end;

function createregion: regionty; overload;
begin
 result:= regionty(xcreateregion());
end;

function createregion(const rect: rectty): regionty; overload;
var
 rect1: xrectangle;
begin
 result:= regionty(xcreateregion);
 rect1:= recttoxrect(rect);
 xunionrectwithregion(@rect1,region(result),region(result));
end;

procedure gui_createemptyregion(var drawinfo: drawinfoty);
begin
 with drawinfo.regionoperation do begin
  dest:= createregion;
 end;
end;

procedure gui_createrectregion(var drawinfo: drawinfoty);
begin
 with drawinfo.regionoperation do begin
  dest:= createregion(rect);
 end;
end;

procedure gui_createrectsregion(var drawinfo: drawinfoty);
var
 int1: integer;
 rect1: xrectangle;
begin
 with drawinfo.regionoperation do begin
  dest:= createregion;
  for int1:= 0 to rectscount - 1 do begin
   rect1:= recttoxrect(rectspo^[int1]);
   xunionrectwithregion(@rect1,region(dest),region(dest));
  end;
 end;
end;                           

procedure gui_destroyregion(var drawinfo: drawinfoty);
begin
 with drawinfo.regionoperation do begin
  if source <> 0 then begin
   xdestroyregion(region(source));
  end;
 end;
end;

procedure gui_regionisempty(var drawinfo: drawinfoty);
begin
 with drawinfo.regionoperation do begin
  dest:= xemptyregion(region(source));
  if dest <> 0 then begin
   dest:= 1;
  end;
 end;
end;

procedure gui_regionclipbox(var drawinfo: drawinfoty);
var
 rect1: xrectangle;
begin
 with drawinfo.regionoperation do begin
  xclipbox(region(source),@rect1);
  rect.x:= rect1.x;
  rect.y:= rect1.y;
  rect.cx:= rect1.width;
  rect.cy:= rect1.height;
 end;
end;

procedure gui_copyregion(var drawinfo: drawinfoty);
begin
 with drawinfo.regionoperation do begin
  if source = 0 then begin
   dest:= 0;
  end
  else begin
   dest:= cardinal(xcreateregion);
   xunionregion(region(dest),region(source),region(dest));
  end;
 end;
end;

procedure gui_moveregion(var drawinfo: drawinfoty);
begin
 with drawinfo.regionoperation do begin
  xoffsetregion(region(source),rect.x,rect.y);
 end;
end;

procedure gui_regsubrect(var drawinfo: drawinfoty);
var
 reg1: region;
begin
 with drawinfo.regionoperation do begin
  reg1:= region(createregion(rect));
  xsubtractregion(region(dest),reg1,region(dest));
  xdestroyregion(reg1);
 end;
end;

procedure gui_regintersectrect(var drawinfo: drawinfoty);
var
 reg1: region;
begin
 with drawinfo.regionoperation do begin
  reg1:= region(createregion(rect));
  xintersectregion(region(dest),reg1,region(dest));
  xdestroyregion(reg1);
 end;
end;

procedure gui_regintersectregion(var drawinfo: drawinfoty);
begin
 with drawinfo.regionoperation do begin
  xintersectregion(region(dest),region(source),region(dest));
 end;
end;

procedure gui_regaddrect(var drawinfo: drawinfoty);
var
 rect1: xrectangle;
begin
 with drawinfo.regionoperation do begin
  rect1:= recttoxrect(rect);
  xunionrectwithregion(@rect1,region(dest),region(dest));
 end;
end;

procedure gui_regaddregion(var drawinfo: drawinfoty);
begin
 with drawinfo.regionoperation do begin
  xunionregion(region(dest),region(source),region(dest));
 end;
end;

procedure gui_regsubregion(var drawinfo: drawinfoty);
begin
 with drawinfo.regionoperation do begin
  xsubtractregion(region(dest),region(source),region(dest));
 end;
end;

function gui_rgbtopixel(rgb: cardinal): pixelty;
begin                                           //todo: speedup
// if istruecolor then begin
  if xredshiftleft then begin
   result:= ((rgb and redmask) shl xredshift) and xredmask;
  end
  else begin
   result:= ((rgb and redmask) shr xredshift) and xredmask;
  end;
  if xgreenshiftleft then begin
   result:= result or (((rgb and greenmask) shl xgreenshift) and xgreenmask);
  end
  else begin
   result:= result or (((rgb and greenmask) shr xgreenshift) and xgreenmask);
  end;
  if xblueshiftleft then begin
   result:= result or (((rgb and bluemask) shl xblueshift) and xbluemask);
  end
  else begin
   result:= result or (((rgb and bluemask) shr xblueshift) and xbluemask);
  end;
// end;
end;
{
function gui_rgbtocolormappixel(rgb: cardinal): pixelty;
begin
 with rgbtriplety(rgb) do begin
  if is8bitcolor and (red = green) and (red = blue) and (red <> 255) then begin
   red:= red and xbluemask;
   green:= green and xbluemask;       //more neutral gray
  end;
 end;
 result:= gui_rgbtopixel(rgb);
end;
}
function gui_pixeltorgb(pixel: cardinal): cardinal;
begin
// if istruecolor then begin
  if xredshiftleft then begin
   result:= (pixel and xredmask) shr xredshift;
  end
  else begin
   result:= (pixel and xredmask) shl xredshift;
  end;
  if xgreenshiftleft then begin
   result:= result or ((pixel and xgreenmask) shr xgreenshift);
  end
  else begin
   result:= result or ((pixel and xgreenmask) shl xgreenshift);
  end;
  if xblueshiftleft then begin
   result:= result or ((pixel and xbluemask) shr xblueshift);
  end
  else begin
   result:= result or ((pixel and xbluemask) shl xblueshift);
  end;
// end;
end;

function xtomousebutton(button: cardinal): mousebuttonty;
begin
 case button of
  button1: result:= mb_left;
  button2: result:= mb_middle;
  button3: result:= mb_right;
  else result:= mb_none;
 end;
end;

function xtoshiftstate(const shiftstate: cardinal;
                       const key: keyty; const button: mousebuttonty;
                       const up: boolean): shiftstatesty;
begin
 result:= [];
 if shiftstate and button1mask <> 0 then include(result,ss_left);
 if shiftstate and button2mask <> 0 then include(result,ss_middle);
 if shiftstate and button3mask <> 0 then include(result,ss_right);
 if shiftstate and shiftmask <> 0 then include(result,ss_shift);
 if shiftstate and controlmask <> 0 then include(result,ss_ctrl);
 if shiftstate and mod1mask <> 0 then include(result,ss_alt);
 case key of
  key_shift: if up then exclude(result,ss_shift) else include(result,ss_shift);
  key_control: if up then exclude(result,ss_ctrl) else include(result,ss_ctrl);
  key_alt: if up then exclude(result,ss_alt) else include(result,ss_alt);
 end;
 case button of
  mb_left: if up then exclude(result,ss_left) else include(result,ss_left);
  mb_middle: if up then exclude(result,ss_middle) else include(result,ss_middle);
  mb_right: if up then exclude(result,ss_right) else include(result,ss_right);
 end;
end;

var
 messcount: integer;

procedure freeclientevents;
var
 xev: xevent;
begin
 while xpending(appdisp) > 0 do begin
  xnextevent(appdisp,@xev);
  with xev.xclient do begin
   if (xtype = clientmessage) and (display = appdisp) and
           (message_type = mseclientmessageatom) then begin
    tevent(data.l[0]).free1;
   end;
  end;
 end;
end;

function gui_hasevent: boolean;
begin
 gdi_lock;
 result:= xpending(appdisp) > 0;
 gdi_unlock;
end;

function xkeytokey(key: keysym): keyty;
begin
 if (key >= $61) and (key <= $7a) then begin //a..z
  result:= keyty(key - $20); //A..Z
 end
 else begin
  case key of
   xk_backspace: result:= key_backspace;
   xk_tab: result:= key_tab;
   xk_iso_left_tab: result:= key_backtab;
//   xk_linefeed: result:= key_linefeed;
//   xk_clear: result:= key_clear;
   xk_return: result:= key_return;
   xk_pause: result:= key_pause;
   xk_scroll_lock: result:= key_scrolllock;
   xk_sys_req: result:= key_sysreq;
   xk_escape: result:= key_escape;
   xk_delete: result:= key_delete;
   xk_home: result:= key_home;
   xk_left: result:= key_left;
   xk_up: result:= key_up;
   xk_right: result:= key_right;
   xk_down: result:= key_down;
//   xk_prior: result:= key_prior;
   xk_page_up: result:= key_pageup;
//   xk_next: result:= key_next;
   xk_page_down: result:= key_pagedown;
   xk_end: result:= key_end;
//   xk_begin: result:= key_begin;

//   xk_select: result:= key_select;
   xk_print: result:= key_print;
//   xk_execute: result:= key_execute;
   xk_insert: result:= key_insert;
//   xk_undo: result:= key_undo;
//   xk_redo: result:= key_redo;
   xk_menu: result:= key_menu;
//   xk_find: result:= key_find;
//   xk_cancel: result:= key_cancel;
   xk_help: result:= key_help;
   xk_break: result:= key_pause; //key_break;
//   xk_mode_switch: result:= key_modeswitch;
//   xk_script_switch: result:= key_scriptswitch;
   xk_num_lock: result:= key_numlock;

   xk_kp_space: result:= key_space;
   xk_kp_tab: result:= key_tab;
   xk_kp_enter: result:= key_enter;
   xk_kp_f1: result:= key_f1;
   xk_kp_f2: result:= key_f2;
   xk_kp_f3: result:= key_f3;
   xk_kp_f4: result:= key_f4;
   xk_kp_home: result:= key_home;
   xk_kp_left: result:= key_left;
   xk_kp_up: result:= key_up;
   xk_kp_right: result:= key_right;
   xk_kp_down: result:= key_down;
//   xk_kp_prior: result:= key_prior;
   xk_kp_page_up: result:= key_pageup;
//   xk_kp_next: result:= key_next;
   xk_kp_page_down: result:= key_pagedown;
   xk_kp_end: result:= key_end;
//   xk_kp_begin: result:= key_begin;
   xk_kp_insert: result:= key_insert;
   xk_kp_delete: result:= key_delete;
   xk_kp_equal: result:= key_equal;
   xk_kp_multiply: result:= key_asterisk;
   xk_kp_add: result:= key_plus;
   xk_kp_separator: result:= key_comma;
   xk_kp_subtract: result:= key_minus;
   xk_kp_decimal: result:= key_period;
   xk_kp_divide: result:= key_slash;
   xk_kp_0..xk_kp_9: result:= keyty(cardinal(key_0) + key - xk_kp_0);

   xk_f1..xk_f35: result:= keyty(cardinal(key_f1) + key - xk_f1);

   xk_shift_l: result:= key_shift;
   xk_shift_r: result:= key_shift;
   xk_control_l: result:= key_control;
   xk_control_r: result:= key_control;
   xk_caps_lock: result:= key_capslock;
//   xk_shift_lock: result:= key_shift_lock;

   xk_meta_l: result:= key_meta;
   xk_meta_r: result:= key_meta;
   xk_alt_l: result:= key_alt;
   xk_alt_r: result:= key_alt;
   xk_super_l: result:= key_super_l;
   xk_super_r: result:= key_super_r;
   xk_hyper_l: result:= key_hyper_l;
   xk_hyper_r: result:= key_hyper_r;

   else result:= keyty(key);
  end;
 end;
end;

function pchartomsestring(value: pchar; len: integer): msestring;
var
 int1: integer;
 buffer: cardinalarty;
begin
 setlength(buffer,len);
 int1:= mbsnrtowcs(pointer(buffer),@value,len,len,nil);
 if int1 > 0 then begin
  setlength(result,int1);
  for int1:= 0 to int1-1 do begin
   result[int1+1]:= msechar(buffer[int1]);
  end;
 end
 else begin
  setlength(result,0);
 end;
end;

function ucs4stringtomsestring(const source: cardinalarty): msestring;
var
 int1: integer;
begin
 setlength(result,length(source));
 for int1:= 0 to length(source)-1 do begin
  result[int1+1]:= msechar(source[int1]);
 end;
end;

function getrootpath(id: winidty; out rootpath: cardinalarty): boolean;
var
 root,parent: {$ifdef FPC}dword{$else}xlib.twindow{$endif};
 children: pwindow;
 count: integer;
 ca1: cardinal;

begin
 result:= false;
 setlength(rootpath,5);
 rootpath[0]:= id;
 count:= 1; //reserve for root
 repeat
  if xquerytree(appdisp,id,@root,@parent,@children,@ca1) = 0 then begin
   exit;
  end;
  if children <> nil then begin
   xfree(children);
  end;
  if count >= length(rootpath)  then begin
   setlength(rootpath,count+5);
  end;
  rootpath[count]:= parent;
  id:= parent;
  inc(count);
 until parent = root;
 setlength(rootpath,count);
 result:= true;
end;

function gui_getparentwindow(const awindow: winidty): winidty;
var
 root,parent: {$ifdef FPC}dword{$else}xlib.twindow{$endif};
 children: pwindow;
 count: integer;
 ca1: cardinal;
begin
 result:= 0;
 if xquerytree(appdisp,awindow,@root,@parent,@children,@ca1) = 0 then begin
  exit;
 end;
 if children <> nil then begin
  xfree(children);
 end;
 result:= parent;
end;

function getrootoffset(const id: winidty; out offset: pointty): boolean;
var
 int1: integer;
 rootpath: cardinalarty;
 ax,ay: integer;
 width,height,border: cardinal;
 ca1: cardinal;
begin
 result:= getrootpath(id,rootpath);
 if result then begin
  result:= false;
  offset:= nullpoint;
  for int1:= 1 to high(rootpath) - 1 do begin
   if xgetgeometry(appdisp,rootpath[int1],@ca1,@ax,@ay,@width,
                                         @height,@border,@ca1) = 0 then begin
    exit;
   end;
   with offset do begin
    inc(x,ax);
    inc(y,ay);
   end;
  end;
 end;
 result:= true;
end;

function settransientforhint(id,transientfor: winidty): guierrorty;
begin
 if transientfor = 0 then begin
  xsettransientforhint(appdisp,id,mserootwindow);
 end
 else begin
  xsettransientforhint(appdisp,id,transientfor);
 end;
 result:= gue_ok;
end;

function gui_settransientfor(id: winidty; transientfor: winidty): guierrorty;
var
 attributes: xwindowattributes;
begin
 result:= settransientforhint(id,transientfor);
 if result = gue_ok then begin
  if xgetwindowattributes(appdisp,id,@attributes) <> 0 then begin
   if attributes.override_redirect{$ifndef xboolean} <> 0 {$endif}then begin
    gui_stackunderwindow(transientfor,id);
   end;
  end;
 end;
end;

function gui_windowatpos(const pos: pointty): winidty;
var
 int1: integer;
 id: winidty;
begin
 id:= mserootwindow;
 repeat
  result:= id;
  if longint(xtranslatecoordinates(appdisp,mserootwindow,result,
         pos.x,pos.y,@int1,@int1,@id)) = 0 then begin
   result:= 0;
   exit;
  end;
 until id = none;
end;

function gui_setwindowgroup(id,group: winidty): guierrorty;
var
 wmhints: pxwmhints;
begin
{$ifdef FPC}{$checkpointer off}{$endif}
 wmhints:= pxwmhints(xgetwmhints(appdisp,id));
 if wmhints = nil then begin
  wmhints:= pxwmhints(xallocwmhints);
 end;
 with wmhints^ do begin
  window_group:= group;
  flags:= flags or windowgrouphint;
  xsetwmhints(appdisp,id,wmhints);
 end;
 xfree(wmhints);
{$ifdef FPC}{$checkpointer default}{$endif}
 setwinidproperty(id,wmclientleaderatom,group);
 result:= gue_ok;
end;

function gui_createwindow(const rect: rectty; const options: internalwindowoptionsty;
                               var awindow: windowty): guierrorty;
var
 attributes: xsetwindowattributes;
 valuemask: longword;
 width,height: integer;
 id1: winidty;
 icmask: longword;
begin
 with awindow,x11windowty(platformdata) do begin
  valuemask:= 0;
  if wo_popup in options.options then begin
   attributes.override_redirect:= {$ifdef xboolean}true{$else}1{$endif};
   valuemask:= valuemask or cwoverrideredirect;
  end;
  {
  if (wo_popup in options.options) and (options.transientfor <> 0) then begin
   xraisewindow(appdisp,options.transientfor);
     //transientforhint not used by overrideredirect
  end;
  }
  if rect.cx <= 0 then begin
   width:= 1;
  end
  else begin
   width:= rect.cx;
  end;
  if rect.cy <= 0 then begin
   height:= 1;
  end
  else begin
   height:= rect.cy;
  end;
  if msecolormap <> 0 then begin
   attributes.colormap:= msecolormap;
   valuemask:= valuemask or cwcolormap;
  end;
  if options.parent <> 0 then begin
   id1:= options.parent;
  end
  else begin
   id1:= rootid;
  end;
  id:= xcreatewindow(appdisp,id1,rect.x,rect.y,width,height,0,
      copyfromparent,copyfromparent,xlib.pvisual(copyfromparent),
      valuemask,@attributes);
  if id = 0 then begin
   result:= gue_createwindow;
   exit;
  end;
  result:= gue_ok;
  if options.parent <> 0 then begin //embedded window
//   xselectinput(appdisp,id,structurenotifymask); //do not send to parent
   xselectinput(appdisp,id,exposuremask); //will be mapped to parent
   exit;          
  end;
  if (options.transientfor <> 0) or
          (options.options * [wo_popup,wo_message] <> []) then begin
   settransientforhint(id,options.transientfor);
  end;
  with options do begin
   if icon <> 0 then begin
    gui_setwindowicon(id,icon,iconmask);
   end;
  end;
  if options.setgroup then begin
   if options.groupleader = 0 then begin
    gui_setwindowgroup(id,id);
   end
   else begin
    gui_setwindowgroup(id,options.groupleader);
   end;
  end;
  if options.pos <> wp_default then begin
   gui_reposwindow(id,rect);
  end;
{           //single ic for whole application
  ic:= xcreateic(im,pchar(xninputstyle),
          ximstatusnothing or ximpreeditnothing,
          pchar(xnclientwindow),id,nil);
}
  icmask:= appicmask;
  if ic <> nil then begin
   xgeticvalues(ic,pchar(xnfilterevents),@icmask,nil);
   xseticvalues(ic,pchar(xnresetstate),pchar(ximpreservestate),nil);
  end;
  xselectinput(appdisp,id,icmask or
              KeymapStateMask or
 		      KeyPressMask or KeyReleaseMask or
                       buttonpressmask or buttonreleasemask or
                       pointermotionmask or
 		      EnterWindowMask or LeaveWindowMask or
 		      FocusChangeMask or PropertyChangeMask or
                       exposuremask or structurenotifymask
                       );
  xsetwmprotocols(appdisp,id,@wmprotocols[low(wmprotocolty)],
              integer(high(wmprotocolty))+1);
  setstringproperty(id,wmclassatom,
       filename(sys_getapplicationpath)+#0+application.applicationname);
  if netatoms[net_wm_pid] <> 0 then begin
   setcardinalproperty(id,netatoms[net_wm_pid],getpid);
  end;
  if (wo_popup in options.options) and (options.transientfor <> 0) then begin
   gui_raisewindow(options.transientfor);
     //transientforhint not used by overrideredirect
  end;
  if (wo_popup in options.options) then begin
   gui_raisewindow(id);
  end;
 end;
end;

function gui_destroywindow(var awindow: windowty): guierrorty;
begin
 with awindow,x11windowty(platformdata) do begin
  if ic <> nil then begin
//   xunseticfocus(ic);
   xdestroyic(ic);
   ic:= nil;
  end;
  if id <> 0 then begin
  {$ifdef with_saveyourself}
   if id <> saveyourselfwindow then begin
  {$endif}
    unsetime(id);
    xdestroywindow(appdisp,id);
  {$ifdef with_saveyourself}
   end;
  {$endif}
  end;
 end;
 result:= gue_ok;
end;
{
function gui_windowgetfocus(var awindow: windowty): guierrorty;
begin
 result:= gue_ok;
 icwindow:= awindow;
 with awindow,x11windowty(platformdata) do begin
  if ic <> nil then begin
   xseticfocus(ic);
  end;
 end;
end;

function gui_windowloosefocus(var awindow: windowty): guierrorty;
begin
 result:= gue_ok;
 with awindow,x11windowty(platformdata) do begin
  if ic <> nil then begin
   xunseticfocus(ic);
  end;
 end;
 fillchar(icwindow,sizeof(icwindow),0);
end;
}
function gui_getwindowrect(id: winidty; out rect: rectty): guierrorty;
var
 int1: integer;
 po1: pointty;
begin
 result:= gue_error;
 with rect do begin
  if xgetgeometry(appdisp,id,@int1,@x,@y,@cx,@cy,@int1,@int1) <> 0 then begin
   if getrootoffset(id,po1) then begin
    addpoint1(rect.pos,po1);
    result:= gue_ok;
   end;
  end;
 end;
end;

function gui_getwindowpos(id: winidty; out pos: pointty): guierrorty;
var
 int1: integer;
 po1: pointty;
begin
 result:= gue_error;
 with pos do begin
  if xgetgeometry(appdisp,id,@int1,@x,@y,@int1,@int1,@int1,@int1) <> 0 then begin
   result:= gue_ok;
  end;
 end;
end;

function gui_reposwindow(id: winidty; const rect: rectty): guierrorty;
var
 changes: xwindowchanges;
 sizehints: pxsizehints;
 int1: integer;
begin
 fillchar(changes,sizeof(changes),0);
 with changes do begin
  x:= rect.x;
  y:= rect.y;
  width:= rect.cx;
  height:= rect.cy;
  if width <= 0 then begin
   width:= 1;
  end;
  if height <= 0 then begin
   height:= 1;
  end;
 end;
 if not hasoverrideredirect(id) then begin
  {$ifdef FPC} {$checkpointer off} {$endif}
  sizehints:= xallocsizehints;
  xgetwmnormalhints(appdisp,id,sizehints,@int1);
  with sizehints^ do begin
   flags:= flags or pposition or psize or usposition or ussize {or pbasesize} or
                                           pwingravity;
   x:= changes.x;
   y:= changes.y;
   width:= changes.width;
   height:= changes.height;
   base_width:= width;
   base_height:= height;
   win_gravity:= staticgravity;
  end;
  xsetwmnormalhints(appdisp,id,sizehints);
  xfree(sizehints);
 end;
 xconfigurewindow(appdisp,id,cwx or cwy or cwwidth or cwheight,@changes);
 {$ifdef FPC} {$checkpointer default} {$endif}
 result:= gue_ok;
end;

function gui_setdecoratedwindowrect(id: winidty; const rect: rectty; 
                                    out clientrect: rectty): guierrorty;
var
 frame1: framety;
begin
 frame1:= getwindowframe(id);
 with clientrect,frame1 do begin
  x:= rect.x + left;
  cx:= rect.cx - left - right;
  y:= rect.y + top;
  cy:= rect.cy - top - bottom;
 end;
 result:= gui_reposwindow(id,clientrect);
end;

function gui_setembeddedwindowrect(id: winidty; const rect: rectty): guierrorty;
begin
 result:= gui_reposwindow(id,rect);
end;

function gui_setsizeconstraints(id: winidty; const min,max: sizety): guierrorty;
var
 sizehints: pxsizehints;
 int1: integer;
begin
 sizehints:= xallocsizehints;
 {$ifdef FPC} {$checkpointer off} {$endif}
 xgetwmnormalhints(appdisp,id,sizehints,@int1);
 with sizehints^ do begin
  flags:= flags or pminsize or pmaxsize;
  min_width:= min.cx;
  min_height:= min.cy;
  if max.cx = 0 then begin
   max_width:= 30000;
  end
  else begin
   max_width:= max.cx;
  end;
  if max.cy = 0 then begin
   max_height:= 30000;
  end
  else begin
   max_height:= max.cy;
  end;
 end;
 {$ifdef FPC} {$checkpointer default} {$endif}
 xsetwmnormalhints(appdisp,id,sizehints);
 xfree(sizehints);
 result:= gue_ok;
end;

function gui_hidewindow(id: winidty): guierrorty;
begin
 unsetime(id);
 xunmapwindow(appdisp,id);
 result:= gue_ok;
end;

function gui_creategc(paintdevice: paintdevicety; const akind: gckindty;
     var gc: gcty; const aprintername: msestring = ''): guierrorty;
begin
 if paintdevice = 0 then begin
  paintdevice:= mserootwindow;
 end;
 gc.handle:= cardinal(xcreategc(appdisp,paintdevice,0,nil));
 if gc.handle = 0 then begin
  result:= gue_creategc;
 end
 else begin
  xsetgraphicsexposures(appdisp,tgc(gc.handle),{$ifdef xboolean}false{$else}0{$endif});
  with x11gcty(gc.platformdata) do begin
   //nothing to do, gc is nulled
  end;
  result:= gue_ok;
 end;
end;


{$ifndef FPC}
type
 tlibhandle = longword;
{$endif}

function getxftlib: boolean;
begin
{$ifndef staticxft}
 result:= false;
 try
  getprocaddresses(['libfontconfig.so','libfontconfig.so.1'],
     [
     'FcPatternDestroy',         //0
     'FcFontSetDestroy',         //1
     'FcObjectSetCreate',        //2
     'FcObjectSetAdd',           //3
     'FcObjectSetDestroy',       //4
     'FcFontList',               //5
     'FcCharSetCreate',          //6
     'FcCharSetDestroy',         //7
     'FcCharSetAddChar',         //8
     'FcPatternAdd',             //9
     'FcPatternCreate',          //10
     'FcConfigSubstitute',       //11
     'FcDefaultSubstitute',      //12
     'FcFontSort',               //13
     'FcCharSetHasChar',         //14
     'FcPatternDuplicate',       //15
     'FcPatternGetCharSet',      //16
     'FcFontRenderPrepare',      //17
     'FcMatrixRotate',           //18
     'FcMatrixScale',            //19
     'FcPatternAddInteger',      //20
     'FcPatternAddDouble',       //21
     'FcPatternAddString',       //22
     'FcPatternAddMatrix',       //23
     'FcPatternAddCharSet',      //24
     'FcPatternAddBool',         //25
     'FcPatternAddLangSet',      //26
     'FcPatternGetString'        //27
     ],
     [
     {$ifndef FPC}@{$endif}@FcPatternDestroy,          //0
     {$ifndef FPC}@{$endif}@FcFontSetDestroy,          //1
     {$ifndef FPC}@{$endif}@FcObjectSetCreate,         //2
     {$ifndef FPC}@{$endif}@FcObjectSetAdd,            //3
     {$ifndef FPC}@{$endif}@FcObjectSetDestroy,        //4
     {$ifndef FPC}@{$endif}@FcFontList,                //5
     {$ifndef FPC}@{$endif}@FcCharSetCreate,           //6
     {$ifndef FPC}@{$endif}@FcCharSetDestroy,          //7
     {$ifndef FPC}@{$endif}@FcCharSetAddChar,          //8
     {$ifndef FPC}@{$endif}@FcPatternAdd,              //9
     {$ifndef FPC}@{$endif}@FcPatternCreate,           //10
     {$ifndef FPC}@{$endif}@FcConfigSubstitute,        //11
     {$ifndef FPC}@{$endif}@FcDefaultSubstitute,       //12
     {$ifndef FPC}@{$endif}@FcFontSort,                //13
     {$ifndef FPC}@{$endif}@FcCharSetHasChar,          //14
     {$ifndef FPC}@{$endif}@FcPatternDuplicate,        //15
     {$ifndef FPC}@{$endif}@FcPatternGetCharSet,       //16
     {$ifndef FPC}@{$endif}@FcFontRenderPrepare,       //17
     {$ifndef FPC}@{$endif}@FcMatrixRotate,            //18
     {$ifndef FPC}@{$endif}@FcMatrixScale,             //19
     {$ifndef FPC}@{$endif}@FcPatternAddInteger,       //20
     {$ifndef FPC}@{$endif}@FcPatternAddDouble,        //21
     {$ifndef FPC}@{$endif}@FcPatternAddString,        //22
     {$ifndef FPC}@{$endif}@FcPatternAddMatrix,        //23
     {$ifndef FPC}@{$endif}@FcPatternAddCharSet,       //24
     {$ifndef FPC}@{$endif}@FcPatternAddBool,          //25
     {$ifndef FPC}@{$endif}@FcPatternAddLangSet,       //26
     {$ifndef FPC}@{$endif}@FcPatternGetString         //27
     ]);
  getprocaddresses(['libXft.so','libXft.so.2'],[
    'XftDrawDestroy',            //0
    'XftDrawSetClipRectangles',  //1
    'XftDrawCreate',             //2 
    'XftDrawSetClip',            //3
    'XftTextExtents16',          //4 
    'XftFontOpenName',           //5
    'XftFontClose',              //6
    'XftDrawString16',           //7
    'XftDefaultHasRender',       //8
    'XftGetVersion',             //9
    'XftInit',                   //10
    'XftInitFtLibrary',          //11
    'XftCharExists',             //12
    'XftNameParse',              //13  
    'XftFontMatch',              //14
    'XftFontOpenPattern',        //15
    'XftDefaultSubstitute'       //16
    ],
    [
    {$ifndef FPC}@{$endif}@XftDrawDestroy,              //0
    {$ifndef FPC}@{$endif}@XftDrawSetClipRectangles,    //1
    {$ifndef FPC}@{$endif}@XftDrawCreate,               //2
    {$ifndef FPC}@{$endif}@XftDrawSetClip,              //3
    {$ifndef FPC}@{$endif}@XftTextExtents16,            //4
    {$ifndef FPC}@{$endif}@XftFontOpenName,             //5
    {$ifndef FPC}@{$endif}@XftFontClose,                //6
    {$ifndef FPC}@{$endif}@XftDrawString16,             //7
    {$ifndef FPC}@{$endif}@XftDefaultHasRender,         //8
    {$ifndef FPC}@{$endif}@XftGetVersion,               //9
    {$ifndef FPC}@{$endif}@XftInit,                     //10
    {$ifndef FPC}@{$endif}@XftInitFtLibrary,            //11
    {$ifndef FPC}@{$endif}@XftCharExists,               //12
    {$ifndef FPC}@{$endif}@XftNameParse,                //13
    {$ifndef FPC}@{$endif}@XftFontMatch,                //14
    {$ifndef FPC}@{$endif}@XftFontOpenPattern,          //15
    {$ifndef FPC}@{$endif}@XftDefaultSubstitute         //16
    ]);
 except
  exit;
 end;

{$endif} //not staticxft
 result:= true;
end;

var
 XRenderSetPictureClipRectangles: procedure(dpy:PDisplay; picture:TPicture;
            xOrigin:longint; yOrigin:longint; rects:PXRectangle; n:longint);
           cdecl;
 XRenderCreatePicture: function(dpy:PDisplay; drawable:TDrawable;
      format:PXRenderPictFormat; valuemask:dword;
      attributes:PXRenderPictureAttributes):TPicture;cdecl;
 XRenderFillRectangle: procedure(dpy:PDisplay; op:longint; dst:TPicture;
              color:PXRenderColor; x:longint;
              y:longint; width:dword; height:dword);cdecl;
 XRenderSetPictureTransform: procedure(dpy:PDisplay; picture:TPicture;
                                        transform:PXTransform);
          cdecl;
 XRenderSetPictureFilter: procedure(dpy:PDisplay; picture:TPicture;
                      filter: pchar; params: pinteger; nparams: integer);
          cdecl;
 XRenderFreePicture: procedure(dpy:PDisplay; picture:TPicture);
                 cdecl;
 XRenderComposite: procedure(dpy:PDisplay; op:longint; src:TPicture; mask:TPicture; dst:TPicture;
              src_x:longint; src_y:longint; mask_x:longint; mask_y:longint; dst_x:longint;
              dst_y:longint; width:dword; height:dword);cdecl;
 XRenderQueryExtension: function(dpy: PDisplay; event_basep: Pinteger;
                  error_basep: Pinteger): TBool;cdecl;
 XRenderFindVisualFormat: function(dpy:PDisplay; visual:PVisual):PXRenderPictFormat;cdecl;
 XRenderFindStandardFormat:  function(dpy:PDisplay;
              format:longint):PXRenderPictFormat; cdecl;

function getxrenderlib: boolean;
begin
 result:= false;
 try
  getprocaddresses(['libXrender.so','libXrender.so.1'],[
    'XRenderSetPictureClipRectangles',  //0
    'XRenderCreatePicture',             //1
    'XRenderFillRectangle',             //2
    'XRenderSetPictureTransform',       //3
    'XRenderSetPictureFilter',          //4
    'XRenderFreePicture',               //5
    'XRenderComposite',                 //6
    'XRenderQueryExtension',            //7
    'XRenderFindVisualFormat',          //8
    'XRenderFindStandardFormat'         //9
    ],
    [
    {$ifndef FPC}@{$endif}@XRenderSetPictureClipRectangles,  //0
    {$ifndef FPC}@{$endif}@XRenderCreatePicture,             //1
    {$ifndef FPC}@{$endif}@XRenderFillRectangle,             //2
    {$ifndef FPC}@{$endif}@XRenderSetPictureTransform,       //3
    {$ifndef FPC}@{$endif}@XRenderSetPictureFilter,          //4
    {$ifndef FPC}@{$endif}@XRenderFreePicture,               //5
    {$ifndef FPC}@{$endif}@XRenderComposite,                 //6
    {$ifndef FPC}@{$endif}@XRenderQueryExtension,            //7
    {$ifndef FPC}@{$endif}@XRenderFindVisualFormat,          //8
    {$ifndef FPC}@{$endif}@XRenderFindStandardFormat         //9
    ]);
 except
  exit;
 end;  
 result:= true;
end;

//function gui_destroygc(winid: winidty; var gc: gcty): guierrorty;
procedure gui_destroygc(var drawinfo: drawinfoty);
begin
 with drawinfo do begin
  with x11gcty(gc.platformdata) do begin
   if xftdraw <> nil then begin
    xftdrawdestroy(xftdraw);
   end;
  end;
  xfreegc(appdisp,tgc(gc.handle));
 end;
end;

function gui_regiontorects(const aregion: regionty): rectarty;
var
 int1: integer;
 boxpo: pbox;
begin
 if aregion = 0 then begin
  result:= nil;
 end
 else begin
  with pxregion(aregion)^ do begin
   setlength(result,numrects);
   boxpo:= rects;
   for int1:= 0 to numrects-1 do begin
    with boxpo^,result[int1] do begin
     x:= x1;
     y:= y1;
     cx:= x2 - x1;
     cy:= y2 - y1;
    end;
    inc(boxpo);
   end;
  end;
 end;
end;

procedure setregion(var gc: gcty; const aregion: region;
                 const pic: tpicture = 0; const draw: pxftdraw = nil);
var
 po1,rectspo: pxrectangle;
 boxpo: pbox;
 int1: integer;
begin
 {$ifdef FPC} {$checkpointer off} {$endif}
 with pxregion(aregion)^ do begin
  if numrects > 0 then begin
   boxpo:= rects;
   getmem(rectspo,numrects*sizeof(xrectangle));
   po1:= rectspo;
   for int1:= numrects - 1 downto 0 do begin
    rectspo^.x:= boxpo^.x1;
    rectspo^.y:= boxpo^.y1;
    rectspo^.width:= boxpo^.x2-boxpo^.x1;
    rectspo^.height:= boxpo^.y2-boxpo^.y1;
    inc(boxpo);
    inc(rectspo);
   end;
   if pic <> 0 then begin
    xrendersetpicturecliprectangles(appdisp,pic,gc.cliporigin.x,
                            gc.cliporigin.y,po1,numrects);
   end
   else begin
    if draw <> nil then begin
     xftdrawsetcliprectangles(draw,gc.cliporigin.x,gc.cliporigin.y,po1,numrects);
    end
    else begin
     xsetcliprectangles(appdisp,tgc(gc.handle),gc.cliporigin.x,gc.cliporigin.y,po1,numrects,yxbanded);
    end;
   end;
   freemem(po1);
  end
  else begin
   if pic <> 0 then begin
    xrendersetpicturecliprectangles(appdisp,pic,gc.cliporigin.x,gc.cliporigin.y,nil,0);
   end
   else begin
    if draw <> nil then begin
     xftdrawsetcliprectangles(draw,gc.cliporigin.x,gc.cliporigin.y,nil,0);
    end
    else begin
     xsetcliprectangles(appdisp,tgc(gc.handle),gc.cliporigin.x,gc.cliporigin.y,nil,0,yxbanded);
    end;
   end;
  end;
 end;
 {$ifdef FPC} {$checkpointer default} {$endif}
end;

procedure checkxftdraw(var drawinfo: drawinfoty);
begin
 with x11gcty(drawinfo.gc.platformdata) do begin
  if xftdraw = nil then begin
   xftdraw:= xftdrawcreate(appdisp,drawinfo.paintdevice,xlib.pvisual(defvisual),0);
  end;
  if not (xfts_clipregionvalid in xftstate) then begin
   if gcclipregion = 0 then begin
    xftdrawsetclip(xftdraw,nil);
   end
   else begin
    setregion(drawinfo.gc,region(gcclipregion),0,xftdraw);
   end;
   include(xftstate,xfts_clipregionvalid);
  end;
 end;
end;

function colortorendercolor(const avalue: rgbtriplety): txrendercolor; overload;
begin
 with result do begin
  red:= avalue.red shl 8;
  green:= avalue.green shl 8;
  blue:= avalue.blue shl 8;
  alpha:= $ffff;
 end;
end;

function colortorendercolor(const avalue: colorty): txrendercolor; overload;
begin
 result:= colortorendercolor(colortorgb(avalue));
end;

procedure gui_changegc(var drawinfo: drawinfoty);
var
 xmask: cardinal;
 xvalues: xgcvalues;
 agc: tgc;
 int1: integer;

begin
 xmask:= 0;
 with drawinfo.gcvalues^,drawinfo.gc,x11gcty(platformdata) do begin
  agc:= tgc(handle);
  if gvm_rasterop in mask then begin
   xmask:= xmask or gcfunction;
   xvalues.xfunction:= integer(rasterop);
   gcrasterop:= rasterop;
  end;
  if gvm_linewidth in mask then begin
   xmask:= xmask or gclinewidth;
   xvalues.line_width:= (lineinfo.width + linewidthroundvalue) shr linewidthshift;
  end;
  if gvm_dashes in mask then begin
   with lineinfo do begin
    int1:= length(dashes);
    if int1 <> 0 then begin
     if dashes[int1] = #0 then begin
      dec(int1);
      xvalues.line_style:= linedoubledash;
     end
     else begin
      xvalues.line_style:= lineonoffdash;
     end;
     xsetdashes(appdisp,agc,0,@lineinfo.dashes[1],int1);
    end
    else begin
     xvalues.line_style:= linesolid;
    end;
   end;
   xmask:= xmask or gclinestyle;
  end;
  if gvm_capstyle in mask then begin
   xvalues.cap_style:= capstyles[lineinfo.capstyle];
   xmask:= xmask or gccapstyle;
  end;
  if gvm_joinstyle in mask then begin
   xvalues.join_style:= joinstyles[lineinfo.joinstyle];
   xmask:= xmask or gcjoinstyle;
  end;
  if gvm_font in mask then begin
   if fhasxft then begin
    xftfont:= pxftfont(font);
   end
   else begin
    xmask:= xmask or gcfont;
    xvalues.font:= font;
   end;
  end;
  if gvm_colorbackground in mask then begin
   xmask:= xmask or gcbackground;
   xvalues.background:= colorbackground;
   if fhasxft then begin
    xftcolorbackground.pixel:= colorbackground;
    xftcolorbackground.color:= colortorendercolor(drawinfo.acolorbackground);
   end;
  end;
  if gvm_colorforeground in mask then begin
   xmask:= xmask or gcforeground;
   xvalues.foreground:= colorforeground;
   xvalues.fill_style:= fillsolid;
   if fhasxft then begin
    xftcolor.pixel:= colorforeground;
    xftcolor.color:= colortorendercolor(drawinfo.acolorforeground);
   end;
  end;
  if gvm_brushorigin in mask then begin
   xmask:= xmask or gctilestipxorigin or gctilestipyorigin;
   xvalues.ts_x_origin:= brushorigin.x;
   xvalues.ts_y_origin:= brushorigin.y;
  end;

  if drawingflagsty((cardinal(drawingflags) xor cardinal(gcdrawingflags)))
           * fillmodeinfoflags <> [] then begin
   xmask:= xmask or gcfillstyle;
   if df_brush in drawingflags then begin
    if df_monochrome in drawingflags then begin
     if df_opaque in drawingflags then begin
      xvalues.fill_style:= fillopaquestippled;
     end
     else begin
      xvalues.fill_style:= fillstippled;
     end;
    end
    else begin
     xvalues.fill_style:= filltiled;
    end;
   end
   else begin
    xvalues.fill_style:= fillsolid;
   end;
  end;

  gcdrawingflags:= drawingflags;
  if gvm_brush in mask then begin
   if df_monochrome in drawingflags then begin
//    xvalues.stipple:= brush;
    xvalues.stipple:= tsimplebitmap1(brush).handle;
    xmask:= xmask or gcstipple;
   end
   else begin
    xvalues.tile:= tsimplebitmap1(brush).handle;
    xmask:= xmask or gctile;
   end;
  end;
  if xmask <> 0 then begin
   xchangegc(appdisp,agc,xmask,@xvalues);
  end;
  if gvm_clipregion in mask then begin
   exclude(xftstate,xfts_clipregionvalid);
   gcclipregion:= clipregion;
   if clipregion = 0 then begin
    xsetclipmask(appdisp,agc,none);
   end
   else begin
    setregion(drawinfo.gc,region(clipregion));
//    xsetregion(appdisp,agc,region(clipregion));
   end;
  end;
 end;
end;

function getmatrixcharstruct(char: msechar; const fontdata: x11fontdataty): pxcharstruct;
type
 xchar2b = record
  byte2: byte; //lsb
  byte1: byte; //msb
 end;

begin
{$ifdef FPC} {$checkpointer off} {$endif}
 with fontdata,infopo^ do begin
  if (xchar2b(char).byte1 >= min_byte1) and (xchar2b(char).byte1 <= max_byte1) and
   (xchar2b(char).byte2 >= min_char_or_byte2) and
   (xchar2b(char).byte2 <= max_char_or_byte2) then begin
   result:= pxcharstruct(pchar(per_char) +
             ((xchar2b(char).byte1 - min_byte1) * rowlength +
              (xchar2b(char).byte2 - min_char_or_byte2)
             ) * sizeof(xcharstruct));
  end
  else begin
   result:= nil;
  end;
 end;
{$ifdef FPC} {$checkpointer default} {$endif}
end;

function gui_getchar16widths(var drawinfo: drawinfoty): gdierrorty;
var
 int1,int2: integer;
 char: word;
 po1: pmsechar;
 po2: pinteger;
 charstructpo: pxcharstruct;
 glyphinfo: txglyphinfo;
 bo1: boolean;
 po3: pxftfont;

begin
 with drawinfo.getchar16widths do begin
  po1:= text;
  po2:= resultpo;
{$ifdef FPC} {$checkpointer off} {$endif}
  with datapo^,x11fontdataty(platformdata),infopo^ do begin
   if fhasxft then begin
    bo1:= (df_highresfont in drawinfo.gc.drawingflags) and 
           (fonthighres <> 0);
    if bo1 then begin
     po3:= pxftfont(fonthighres);
    end
    else begin
     po3:= pxftfont(font);
    end; 
    for int1:= 0 to count - 1 do begin //todo: optimize
     xfttextextents16(appdisp,po3,po1,1,@glyphinfo);
     po2^:= glyphinfo.xoff;
     inc(po1);
     inc(po2);
    end;
    if bo1 then begin
     po2:= resultpo;
     int2:= highresfontfakt div 2; //round up
     for int1:= 0 to count - 1 do begin
      int2:= int2 + po2^;
      po2^:= int2 shr highresfontshift;
      int2:= int2 and highresfontmask;
      inc(po2);
     end;
    end;
   end
   else begin
    case matrixmode of
     fmm_linear: begin
      for int1:= 0 to count - 1 do begin
       char:= word(po1^);
       if (char >= min_char_or_byte2) and (char <= max_char_or_byte2) then begin
        po2^:= pxcharstruct(pchar(per_char) +
                   (char - min_char_or_byte2)*sizeof(xcharstruct))^.width;
       end
       else begin
        po2^:= defaultwidth;
       end;
       inc(po1);
       inc(po2);
      end;
     end;
     fmm_matrix: begin
      for int1:= 0 to count -1 do begin
       charstructpo:= getmatrixcharstruct(po1^,x11fontdataty(datapo^.platformdata));
       if charstructpo <> nil then begin
        po2^:= charstructpo^.width;
        if po2^ = 0 then begin
         po2^:= defaultwidth;
        end;
       end
       else begin
        po2^:= defaultwidth;
       end;
       inc(po1);
       inc(po2);
      end;
     end;
     else begin //fm_fix
      int2:= max_bounds.width;
      for int1:= 0 to count - 1 do begin
       po2^:= int2;
       inc(po2);
      end;
     end;
    end;
   end;
  end;
{$ifdef FPC} {$checkpointer default} {$endif}
 end;
 result:= gde_ok;
end;

function gui_getfontmetrics(var drawinfo: drawinfoty): gdierrorty;
var
 po1: pxcharstruct;
 glyphinfo: txglyphinfo;
begin
 with drawinfo.getfontmetrics do begin
{$ifdef FPC} {$checkpointer off} {$endif}
  with datapo^,x11fontdataty(platformdata),infopo^ do begin
   if fhasxft then begin
    xfttextextents16(appdisp,pxftfont(font),@char,1,@glyphinfo);
    with resultpo^ do begin
     width:= glyphinfo.xoff;
     leftbearing:= glyphinfo.x;
     rightbearing:= glyphinfo.xoff-glyphinfo.width+glyphinfo.x;
    end;
   end
   else begin
    case matrixmode of
     fmm_linear: begin
      if (word(char) >= min_char_or_byte2) and (word(char) <= max_char_or_byte2) then begin
       po1:= pxcharstruct(pchar(per_char) +
                  (word(char) - min_char_or_byte2)*sizeof(xcharstruct));
      end
      else begin
       po1:= pxcharstruct(pchar(per_char) +
                  (default_char - min_char_or_byte2)*sizeof(xcharstruct));
      end;
     end;
     fmm_matrix: begin
      po1:= getmatrixcharstruct(char,x11fontdataty(datapo^.platformdata));
      if po1 = nil then begin
       po1:= getmatrixcharstruct(msechar(default_char),x11fontdataty(datapo^.platformdata));
       if po1 = nil then begin
        with resultpo^ do begin
         width:= 0;
         leftbearing:= 0;
         rightbearing:= 0;
        end;
       end;
      end;
     end;
     else begin //fm_fix
      po1:= @max_bounds;
     end;
    end;
    with resultpo^ do begin
     width:= po1^.width;
     leftbearing:= po1^.lbearing;
     rightbearing:= width - po1^.rbearing;
    end;
   end;
  end;
 end;
{$ifdef FPC} {$checkpointer default} {$endif}
 result:= gde_ok;
end;

function gui_gettext16width(var drawinfo: drawinfoty): integer;
var
 int1: integer;
 char: word;
 charstructpo: pxcharstruct;
 glyphinfo: txglyphinfo;
begin
 result:= 0;
{$ifdef FPC} {$checkpointer off} {$endif}
 with drawinfo.gettext16width do begin
  with datapo^,x11fontdataty(platformdata),infopo^ do begin
   if fhasxft then begin
    xfttextextents16(appdisp,pxftfont(font),text,count,@glyphinfo);
    result:= glyphinfo.xoff;
   end
   else begin
    case matrixmode of
     fmm_linear: begin
      for int1:= 0 to count - 1 do begin
       char:= word(text[int1]);
       if (char >= min_char_or_byte2) and (char <= max_char_or_byte2) then begin
        inc(result,pxcharstruct(pchar(per_char) +
                   (char - min_char_or_byte2)*sizeof(xcharstruct))^.width);
       end
       else begin
        inc(result,defaultwidth);
       end;
      end;
     end;
     fmm_matrix: begin
      for int1:= 0 to count - 1 do begin
       charstructpo:= getmatrixcharstruct(text[int1],x11fontdataty(datapo^.platformdata));
       if charstructpo <> nil then begin
        inc(result,charstructpo^.width);
       end
       else begin
        inc(result,defaultwidth);
       end;
      end;
     end;
     else begin //fm_fix
      result:= max_bounds.width * count;
     end;
    end;
   end;
  end;
 end;
{$ifdef FPC} {$checkpointer default} {$endif}
end;

function getcharstruct(const fontdata: fontdataty; char: msechar): pxcharstruct;
begin
{$ifdef FPC} {$checkpointer off} {$endif}
 result:= nil;
 with fontdata,x11fontdataty(platformdata),infopo^ do begin
  case matrixmode of
   fmm_linear: begin
    if (word(char) >= min_char_or_byte2) and (word(char) <= max_char_or_byte2) then begin
     result:= pxcharstruct(pchar(per_char) +
                 (word(char) - min_char_or_byte2)*sizeof(xcharstruct));
    end;
   end;
   fmm_matrix: begin
    result:= getmatrixcharstruct(char,x11fontdataty(fontdata.platformdata));
   end;
   else begin //fmm_fix
    result:= @infopo^.max_bounds;
   end;
  end;
 end;
{$ifdef FPC} {$checkpointer default} {$endif}
end;

type
 fontpropertiesty = (
     FOUNDRY,FAMILY_NAME,WEIGHT_NAME,SLANT,SETWIDTH_NAME,ADD_STYLE_NAME,
     PIXEL_SIZE,POINT_SIZE,RESOLUTION_X,RESOLUTION_Y,SPACING,AVERAGE_WIDTH,
     CHARSET_REGISTRY,CHARSET_ENCODING,{QUAD_WIDTH,RESOLUTION,}MIN_SPACE,
     NORM_SPACE,MAX_SPACE,END_SPACE,SUPERSCRIPT_X,SUPERSCRIPT_Y,SUBSCRIPT_X,
     SUBSCRIPT_Y,UNDERLINE_POSITION,UNDERLINE_THICKNESS,STRIKEOUT_ASCENT,
     STRIKEOUT_DESCENT,ITALIC_ANGLE,X_HEIGHT,WEIGHT,FACE_NAME,{FULL_NAME,}
     FONT,COPYRIGHT,AVG_CAPITAL_WIDTH,AVG_LOWERCASE_WIDTH,RELATIVE_SETWIDTH,
     RELATIVE_WEIGHT,CAP_HEIGHT,SUPERSCRIPT_SIZE,FIGURE_WIDTH,SUBSCRIPT_SIZE,
     SMALL_CAP_SIZE,NOTICE,DESTINATION,FONT_TYPE,FONT_VERSION,RASTERIZER_NAME,
     RASTERIZER_VERSION,RAW_ASCENT,RAW_DESCENT,AXIS_NAMES,AXIS_LIMITS,
     AXIS_TYPES,fpnone);

 fontpropty = record
  name: string; isstring: boolean;
 end;

 intfontproparty = array[fontpropertiesty] of integer;
 strfontproparty = array[fontpropertiesty] of string;

 const
 fontpropertynames: array[fontpropertiesty] of fontpropty = (
     (name: 'FOUNDRY'; isstring: true),
     (name: 'FAMILY_NAME'; isstring: true),
     (name: 'WEIGHT_NAME'; isstring: true),
     (name: 'SLANT'; isstring: true),
     (name: 'SETWIDTH_NAME'; isstring: true),
     (name: 'ADD_STYLE_NAME'; isstring: true),
     (name: 'PIXEL_SIZE'),
     (name: 'POINT_SIZE'),
     (name: 'RESOLUTION_X'),
     (name: 'RESOLUTION_Y'),
     (name: 'SPACING'; isstring: true),
     (name: 'AVERAGE_WIDTH'),
     (name: 'CHARSET_REGISTRY'; isstring: true),
     (name: 'CHARSET_ENCODING'; isstring: true),
     {'QUAD_WIDTH','RESOLUTION',}
     (name: 'MIN_SPACE'),
     (name: 'NORM_SPACE'),
     (name: 'MAX_SPACE'),
     (name: 'END_SPACE'),
     (name: 'SUPERSCRIPT_X'),
     (name: 'SUPERSCRIPT_Y'),
     (name: 'SUBSCRIPT_X'),
     (name: 'SUBSCRIPT_Y'),
     (name: 'UNDERLINE_POSITION'),
     (name: 'UNDERLINE_THICKNESS'),
     (name: 'STRIKEOUT_ASCENT'),
     (name: 'STRIKEOUT_DESCENT'),
     (name: 'ITALIC_ANGLE'),
     (name: 'X_HEIGHT'),
     (name: 'WEIGHT'),
     (name: 'FACE_NAME'; isstring: true),
     {'FULL_NAME',}
     (name: 'FONT'; isstring: true),
     (name: 'COPYRIGHT'; isstring: true),
     (name: 'AVG_CAPITAL_WIDTH'),
     (name: 'AVG_LOWERCASE_WIDTH'),
     (name: 'RELATIVE_SETWIDTH'),
     (name: 'RELATIVE_WEIGHT'),
     (name: 'CAP_HEIGHT'),
     (name: 'SUPERSCRIPT_SIZE'),
     (name: 'FIGURE_WIDTH'),
     (name: 'SUBSCRIPT_SIZE'),
     (name: 'SMALL_CAP_SIZE'),
     (name: 'NOTICE'; isstring: true),
     (name: 'DESTINATION'),
     (name: 'FONT_TYPE'; isstring: true),
     (name: 'FONT_VERSION'; isstring: true),
     (name: 'RASTERIZER_NAME'; isstring: true),
     (name: 'RASTERIZER_VERSION'; isstring: true),
     (name: 'RAW_ASCENT'),
     (name: 'RAW_DESCENT'),
     (name: 'AXIS_NAMES'; isstring: true),
     (name: 'AXIS_LIMITS'; isstring: true),
     (name: 'AXIS_TYPES'; isstring: true),
     (name: '')
     );

type
 fontpropinfoty = record
  foundry: string;
  family_name: string;
  weight_name: string;
  slant: string;
  setwidth_name: string;
  add_style_name: string;
  pixel_size: integer;
  point_size: integer;
  resolution_x: integer;
  resolution_y: integer;
  spacing: string;
  average_width: integer;
  charset_registry: string;
  charset_encodeing: string;
  min_space: integer;
  norm_space: integer;
  max_space: integer;
  end_space: integer;
  superscript_x: integer;
  superscript_y: integer;
  subscript_x: integer;
  subscript_y: integer;
  underline_position: integer;
  underline_thickness: integer;
  strikeout_ascent: integer;
  strikeout_descent: integer;
  italic_angle: integer;
  x_height: integer;
  weight: integer;
  face_name: string;
  font: string;
  copyright: string;
  avg_capital_width: integer;
  avg_lowercase_width: integer;
  relative_setwidth: integer;
  relative_weight: integer;
  cap_height: integer;
  superscript_size: integer;
  figure_width: integer;
  subscript_size: integer;
  small_cap_size: integer;
  notice: string;
  destination: integer;
  font_type: string;
  font_version: string;
  rasterizer_name: string;
  rasterizer_version: string;
  raw_ascent: integer;
  raw_descent: integer;
  axis_names: string;
  axis_limits: string;
  axis_types: string;
  dummy: integer;
 end;

var
 fontpropertyatoms: array[fontpropertiesty] of atom;
 
procedure getfontproperties(var fontstruct: xfontstruct; var propinfo: fontpropinfoty);

 procedure setproperty(const prop: xfontprop);

 var
  propnum: fontpropertiesty;
  po: pchar;

 begin //setproperty
   with prop do begin
    for propnum:= low(fontpropertiesty) to high(fontpropertiesty) do begin
     if name = fontpropertyatoms[propnum] then begin
      break;
     end;
    end;
    if propnum < fpnone then begin
     if fontpropertynames[propnum].isstring then begin
      if prop.card32 = 0 then begin
       strfontproparty(propinfo)[propnum]:= '';
      end
      else begin
       po:= xgetatomname(appdisp,prop.card32);
       strfontproparty(propinfo)[propnum]:= po;
       xfree(po);
      end;
     end
     else begin
      intfontproparty(propinfo)[propnum]:= prop.card32;
     end;
    end;
   end;
  end;
var
 int1: integer;
 po: pxfontprop;

begin //getfontproperties
 with fontstruct do begin
  po:= properties;
  for int1:= 0 to n_properties - 1 do begin
   setproperty(po^);
   inc(po);
  end;
 end;
end;

type
 fontnamety = (
      fn_foundry,fn_family_name,fn_weight_name,fn_slant,fn_setwidth_name,
      fn_addstyle_name,fn_pixel_size,fn_point_size,fn_resolution_x,
      fn_resolution_y,fn_spacing,fn_average_width,fn_charset_registry,
      fn_encoding);
 fontinfoty = array[fontnamety] of string;
var
 defaultfontinfo: fontinfoty;
 simpledefaultfont: boolean;
 hasdefaultfontarg: boolean;//true if -fn
 noxft: boolean; 

function fontinfotoxlfdname(const info: fontinfoty): string;
var
 en1: fontnamety;
begin
 result:= '';
 for en1:= low(fontnamety) to high(fontnamety) do begin
  result:= result + '-' + info[en1];
 end;
end;

procedure setfontinfoname(const aname: string; var ainfo: fontinfoty);
var
 ar1: stringarty;
begin
 ar1:= splitstring(aname,':');
 if (high(ar1) = 1) and (ar1[0] <> '') and (ar1[1] <> '') then begin
  ainfo[fn_foundry]:= ar1[0];
  ainfo[fn_family_name]:= ar1[1];
 end
 else begin
  ainfo[fn_family_name]:= aname;
 end;
end;

procedure initdefaultfont;
var
 int1,int2: integer;
 str1: string;
 av: pcharpoaty;
 ac: pinteger;
 ar1: stringarty;
 en1: fontnamety;
begin
 ar1:= nil; //compiler warning
 simpledefaultfont:= false;
 for en1:= low(fontnamety) to high(fontnamety) do begin
  defaultfontinfo[en1]:= '*';
 end;
 defaultfontinfo[fn_family_name]:= 'helvetica';
 defaultfontinfo[fn_weight_name]:= 'medium';
 defaultfontinfo[fn_slant]:= 'r';
 defaultfontinfo[fn_pixel_size]:= '12';
 defaultfontinfo[fn_charset_registry]:= 'iso10646';
 defaultfontinfo[fn_encoding]:= '1';
 ac:= {$ifdef FPC}@argc{$else}@argcount{$endif};
 av:= pcharpoaty({$ifdef FPC}argv{$else}argvalues{$endif});
 for int1:= ac^ - 1 downto 1 do begin
  if (av^[int1] = '-fn') or (av^[int1] = '-font') then begin
   hasdefaultfontarg:= true;
   if int1 < ac^ - 1 then begin
    str1:= av^[int1+1];
    if (length(str1) > 0) then begin
     if str1[1] = '-' then begin
      ar1:= splitstring(str1,'-');
      for int2:= 1 to high(ar1) do begin
       str1:= trim(ar1[int2]);
       if str1 <> '*' then begin
        defaultfontinfo[fontnamety(int2-1)]:= str1;
       end;
       if int2 = ord(high(fontnamety)) then begin
        break;
       end;
      end;
      noxft:=
       (high(ar1) > ord(high(fontnamety))+1) and
             (ar1[ord(high(fontnamety))+2] ='noxft');
     end
     else begin
      setfontinfoname(str1,defaultfontinfo);
//      defaultfontinfo[fn_family_name]:= str1;
      simpledefaultfont:= true;
     end;
     dec(ac^,2); //remove font arguments
     if int1 < ac^ then begin
      move(av^[int1+2],av^[int1],(ac^-int1)*sizeof(av^[0]));
     end;
     av^[ac^]:= nil;
    end;
   end;
   break;
  end;
 end;
end;

procedure getxftfontdata(po: pxftfont; var drawinfo: drawinfoty);
begin
 if po <> nil then begin
 {$ifdef FPC} {$checkpointer off} {$endif}
  with drawinfo.getfont.fontdata^,x11fontdataty(platformdata) do begin
   font:= cardinal(po);
   ascent:= po^.ascent;
   descent:= po^.descent;
 //   linespacing:= ascent + descent;
   linespacing:= po^.height;
   caretshift:= 0;
   infopo:= nil;
  end;
 {$ifdef FPC} {$checkpointer default} {$endif}
 end;
end;

procedure setupfontinfo(const fontdata: fontdataty;
                               var fontinfo: fontinfoty);
var
 ar1: stringarty;
 height1,width1: integer;
begin
 ar1:= nil; //compiler warning;
 fontinfo:= defaultfontinfo;
 with pfontdataty(@fontdata)^ do begin
  height1:= (height + fontsizeroundvalue) shr fontsizeshift;
  width1:= (width + fontsizeroundvalue) shr fontsizeshift;
  if height1 <> 0 then begin
   fontinfo[fn_pixel_size]:= inttostr(height1);
  end;
  if width1 <> 0 then begin
   fontinfo[fn_average_width]:= inttostr(width1);
  end;
  if charset <> '' then begin
   ar1:= splitstring(charset,'-');
   fontinfo[fn_charset_registry]:= ar1[0];
   if high(ar1) > 0 then begin
    fontinfo[fn_encoding]:= ar1[1];
   end;
  end;
  if name <> '' then begin
   setfontinfoname(name,fontinfo);
  end
  else begin
  end;
  if fs_bold in style then begin
   fontinfo[fn_weight_name]:= 'bold';
  end;
  if fs_italic in style then begin
   fontinfo[fn_slant]:= 'i';
  end;
 end;
end;
(*
function buildxftname(const fontdata: fontdataty; 
                                      const fontinfo: fontinfoty): ansistring;
var
 str1: ansistring;
 int1: integer;
begin
 with fontdata do begin
  str1:= '';
  if fontinfo[fn_foundry] <> '*' then begin
   str1:= str1+':foundry='+fontinfo[fn_foundry];
  end;
  if (familyoptions = []) then begin
   if (pitchoptions = []) and (fontinfo[fn_family_name] <> '*') then begin
    str1:= str1 + ':family=' + fontinfo[fn_family_name];
   end;
  end
  else begin
   if foo_helvetica in familyoptions then begin
    str1:= str1 + ':family=sans';
   end
   else begin
    if foo_roman in familyoptions then begin
     str1:= str1 + ':family=serif';
    end
    else begin
     if foo_decorative in familyoptions then begin
     end
     else begin
      if foo_script in familyoptions then begin
      end;
     end;
    end;
   end;
  end;
  if fs_bold in style then begin
   str1:= str1 + ':bold';
  end;
  if fs_italic in style then begin
   str1:= str1 + ':italic';
  end;
  if fontinfo[fn_pixel_size] <> '*' then begin
   str1:= str1 + ':pixelsize=' + fontinfo[fn_pixel_size];
  end;
  if fontinfo[fn_average_width] <> '*' then begin
   try
    int1:= (strtoint(fontinfo[fn_average_width]) + 5) div 10;
    str1:= str1 + ':charwidth='+inttostr(int1);
   except
   end;
  end;
  if foo_fixed in pitchoptions then begin
   str1:= str1 + ':mono';
  end;
  if foo_proportional in pitchoptions then begin
   str1:= str1 + ':proportional';
  end;
  if foo_antialiased in antialiasedoptions then begin
   str1:= str1 + ':antialias=1';
  end;
  if foo_nonantialiased in antialiasedoptions then begin
   str1:= str1 + ':antialias=0';
  end;
  {
  if foo_xcore in xcoreoptions then begin
   str1:= str1 + ':core=1';
  end;
  if foo_noxcore in xcoreoptions then begin
   str1:= str1 + ':core=0';
  end;
  }
  if fontinfo[fn_charset_registry] <> '*' then begin
   str1:= str1 + ':encoding=' + fontinfo[fn_charset_registry];
   if fontinfo[fn_encoding] <> '*' then begin
    str1:= str1 +'-'+fontinfo[fn_encoding];
   end;
  end;
 end;
 result:= str1;
end;
*)

function buildxftpat(const fontdata: fontdataty; 
                  const fontinfo: fontinfoty; const highres: boolean): pfcpattern;
var
 int1: integer;
 str1: ansistring;
 mat1: tfcmatrix;
 rea1: real;
begin
 with fontdata do begin
  if fontinfo[fn_charset_registry] <> '*' then begin
   str1:= fontinfo[fn_charset_registry];
   if fontinfo[fn_encoding] <> '*' then begin
    str1:= str1 +'-'+fontinfo[fn_encoding];
   end;
   result:= xftnameparse(pansichar(str1));
  end
  else begin
   result:= fcpatterncreate();
  end;
  if fontinfo[fn_foundry] <> '*' then begin
   fcpatternaddstring(result,fc_foundry,pansichar(fontinfo[fn_foundry]));
  end;
  if (familyoptions = []) then begin
   if (pitchoptions = []) and (fontinfo[fn_family_name] <> '*') then begin
    fcpatternaddstring(result,fc_family,pansichar(fontinfo[fn_family_name]));
   end;
  end
  else begin
   if foo_helvetica in familyoptions then begin
    fcpatternaddstring(result,fc_family,'sans');
   end
   else begin
    if foo_roman in familyoptions then begin
     fcpatternaddstring(result,fc_family,'serif');
    end
    else begin
     if foo_decorative in familyoptions then begin
     end
     else begin
      if foo_script in familyoptions then begin
      end;
     end;
    end;
   end;
  end;
  if fs_bold in style then begin
   fcpatternaddinteger(result,fc_weight,fc_weight_bold);
  end;
  if fs_italic in style then begin
   fcpatternaddinteger(result,fc_slant,fc_slant_italic);
  end;
  if fontinfo[fn_pixel_size] <> '*' then begin
   try
    rea1:= strtofloat(fontinfo[fn_pixel_size]);
    if highres then begin
     rea1:= rea1 * highresfontfakt;
    end;
    fcpatternadddouble(result,fc_pixel_size,rea1);
   except
   end;
  end;
  if fontinfo[fn_average_width] <> '*' then begin
   try
    int1:= (strtoint(fontinfo[fn_average_width]) + 5) div 10;
    fcpatternaddinteger(result,fc_char_width,int1);
   except
   end;
  end;
  if foo_fixed in pitchoptions then begin
   fcpatternaddinteger(result,fc_spacing,fc_mono);
  end;
  if foo_proportional in pitchoptions then begin
   fcpatternaddinteger(result,fc_spacing,fc_proportional);
  end;
  if foo_antialiased in antialiasedoptions then begin
   fcpatternaddbool(result,fc_antialias,true);
  end;
  if foo_nonantialiased in antialiasedoptions then begin
   fcpatternaddbool(result,fc_antialias,false);
  end;
  if (xscale <> 1.0) or (rotation <> 0) then begin
   fcmatrixinit(mat1);
   mat1.xx:= xscale;
   if rotation <> 0 then begin
    fcmatrixrotate(@mat1,cos(rotation),sin(rotation));
   end;
   fcpatternaddmatrix(result,fc_matrix,@mat1);
  end;
  {
  if foo_xcore in xcoreoptions then begin
   str1:= str1 + ':core=1';
  end;
  if foo_noxcore in xcoreoptions then begin
   str1:= str1 + ':core=0';
  end;
  }
 end;
end;
{
function fontdatatoxftname(const fontdata: fontdataty): ansistring;
var
 fontinfo: fontinfoty;
begin
 setupfontinfo(fontdata,fontinfo);
 result:= buildxftname(fontdata,fontinfo);
end;
}
function fontdatatoxftpat(const fontdata: fontdataty; const highres: boolean): pfcpattern;
var
 fontinfo: fontinfoty;
begin
 setupfontinfo(fontdata,fontinfo);
 result:= buildxftpat(fontdata,fontinfo,highres);
end;

procedure gui_getfonthighres(var drawinfo: drawinfoty);
var
 pat1,pat2: pfcpattern;
 res1: tfcresult;
 po1: pxftfont;
begin
 if fhasxft then begin
  with drawinfo.getfont do begin
   pat1:= fontdatatoxftpat(fontdata^,true);
   pat2:= xftfontmatch(appdisp,xdefaultscreen(appdisp),pat1,@res1);
   if pat2 <> nil then begin
    fontdata^.fonthighres:= ptruint(xftfontopenpattern(appdisp,pat2));
   end;
   fcpatterndestroy(pat1);
  end;
 end;
end;

function gui_getfont(var drawinfo: drawinfoty): boolean;

 procedure getfontdata(po: pxfontstruct);
 var
  charstructpo: pxcharstruct;
 begin
{$ifdef FPC} {$checkpointer off} {$endif}
  with drawinfo.getfont,fontdata^,x11fontdataty(platformdata) do begin
   font:= po^.fid;
   ascent:= po^.ascent;
   descent:= po^.descent;
   linespacing:= ascent + descent;
   caretshift:= 0;
   infopo:= po;
   with po^ do begin
    if per_char = nil then begin
     matrixmode:= fmm_fix;
    end
    else begin
     if (min_byte1 = 0) and (max_byte1 = 0) then begin
      matrixmode:= fmm_linear;
     end
     else begin
      matrixmode:= fmm_matrix;
      rowlength:= max_char_or_byte2 - min_char_or_byte2 + 1;
     end;
    end;
    charstructpo:= getcharstruct(fontdata^,msechar(default_char));
    if charstructpo <> nil then begin
     defaultwidth:= charstructpo^.width;
    end; //0 otherwise
   end;
{$ifdef FPC} {$checkpointer default} {$endif}
  end;
 end;

var
 po1: pxfontstruct;
 po2: pxftfont;
 fontinfo: fontinfoty;
// str1: string;
 int1: integer;
 po3,po4: pfcpattern;
 res1: tfcresult;
 {$ifdef mse_debugxft}
 po5: pchar;
 {$endif}
begin
 setupfontinfo(drawinfo.getfont.fontdata^,fontinfo);
{$ifdef FPC} {$checkpointer off} {$endif}
 with drawinfo.getfont.fontdata^ do begin
  if fhasxft then begin
   result:= false;
   po3:= buildxftpat(drawinfo.getfont.fontdata^,fontinfo,false);
   po4:= xftfontmatch(appdisp,xdefaultscreen(appdisp),po3,@res1);
   if po4 <> nil then begin
   {$ifdef mse_debugxft}
    if fcpatterngetstring(po4,fc_file,0,@po5) = fcresultmatch then begin
     writeln('Font found. Name: "'+name+'" Height: '+inttostr(height)+' File:');
     writeln('"'+string(po5)+'"');
    end;     
   {$endif}
    po2:= xftfontopenpattern(appdisp,po4);
    if po2 <> nil then begin
     result:= true;
     getxftfontdata(po2,drawinfo);
    end;
   end;
   fcpatterndestroy(po3);
  end
  else begin
   po1:=  xloadqueryfont(appdisp,pchar(fontinfotoxlfdname(fontinfo)));
   if po1 = nil then begin
    if fs_italic in style then begin
     fontinfo[fn_slant]:= 'o';
     po1:=  xloadqueryfont(appdisp,pchar(fontinfotoxlfdname(fontinfo)));
     fontinfo[fn_slant]:= 'i';
    end;
    if po1 = nil then begin
     if (name <> '') and (style * [fs_italic,fs_bold] = []) and (charset <> '') and
           (height = 0) then begin
      po1:= xloadqueryfont(appdisp,pchar(name));
     end;
     if po1 = nil then begin
      if simpledefaultfont then begin
       po1:= xloadqueryfont(appdisp,pchar(fontinfo[fn_family_name]));
      end;
      if po1 = nil then begin
       fontinfo[fn_family_name]:= 'fixed';
       po1:=  xloadqueryfont(appdisp,pchar(fontinfotoxlfdname(fontinfo)));
       if po1 = nil then begin
        po1:= xloadqueryfont(appdisp,'fixed');
       end;
      end;
     end;
    end;
   end;
   if po1 <> nil then begin
    getfontdata(po1);
    result:= true;
   end
   else begin
    result:= false;
   end;
  end;
 end;
  {$ifdef FPC} {$checkpointer default} {$endif}
end;

procedure gui_freefontdata(const data: fontdataty);
begin
 if fhasxft then begin
  xftfontclose(appdisp,pxftfont(data.font));
  if data.fonthighres <> 0 then begin
   xftfontclose(appdisp,pxftfont(data.fonthighres));
  end;
 end
 else begin
  with x11fontdataty(data.platformdata) do begin
   xfreefontinfo(nil,infopo,1);
 //  freemem(infopo);
   xunloadfont(appdisp,data.font);
  end;
 end;
end;

procedure transformpoints(var drawinfo: drawinfoty; const aclose: boolean);
var
 po1: ppointty;
 po2: pxpoint;
 int1: integer;
begin
 with drawinfo,drawinfo.points do begin
  int1:= count;
  if aclose then begin
   inc(int1);
  end;
  allocbuffer(buffer,int1*sizeof(xpoint));
  int1:= count;
  po1:= points;
  po2:= buffer.buffer;
  with origin do begin
   while int1 > 0 do begin
    po2^.x:= po1^.x + x;
    po2^.y:= po1^.y + y;
    inc(po1);
    inc(po2);
    dec(int1);
   end;
  end;
  if aclose then begin
   move(buffer.buffer^,(pchar(buffer.buffer)+count*sizeof(xpoint))^,sizeof(xpoint));
  end;
 end;
end;

procedure transformpos(var drawinfo: drawinfoty);
begin
 with drawinfo,drawinfo.pos do begin
  allocbuffer(buffer,sizeof(xpoint));
  with pxpoint(buffer.buffer)^ do begin
   x:= pos^.x + origin.x;
   y:= pos^.y + origin.y;
  end;
 end;
end;

function transformtext16pos(var drawinfo: drawinfoty): pxchar2b;
var
 po1: pword;
 po2: pword;
 int1: integer;
begin
 with drawinfo,drawinfo.text16pos do begin
  allocbuffer(buffer,sizeof(xpoint)+count*2);
  with pxpoint(buffer.buffer)^ do begin
   x:= pos^.x + origin.x;
   y:= pos^.y + origin.y;
  end;
  po1:= pword(text);
  result:= pxchar2b(pchar(buffer.buffer) + sizeof(xpoint));
  po2:= pword(result);
  for int1:= count-1 downto 0 do begin
   po2^:= (po1^ shl 8) or (po1^ shr 8); //simply swap bytes
   inc(po1);
   inc(po2);
  end;
 end;
end;

function gui_movewindowrect(id: winidty; const dist: pointty; const rect: rectty): guierrorty;
var
 gc: tgc;
begin
 gc:= xcreategc(appdisp,id,0,nil);
 if gc <> nil then begin
  xcopyarea(appdisp,id,id,gc,rect.x,rect.y,rect.cx,rect.cy,rect.x+dist.x,rect.y+dist.y);
  xfreegc(appdisp,gc);
  result:= gue_ok;
 end
 else begin
  result:= gue_scroll;
 end;
end;

const
 unitytransform: txtransform = ((65536,0,0),
                                (0,65536,0),
                                (0,0,65536));

function createalphapicture(const size: sizety): tpicture;
var
 attributes: txrenderpictureattributes;
 pixmap: pixmapty;
begin
 pixmap:= xcreatepixmap(appdisp,0,size.cx,size.cy,8);
 result:= xrendercreatepicture(appdisp,pixmap,alpharenderpictformat,0,@attributes);
 xfreepixmap(appdisp,pixmap);
end;

function createcolorpicture(const acolor: colorty): tpicture;
var
 attributes: txrenderpictureattributes;
 col: txrendercolor;
 pixmap: pixmapty;
begin
 pixmap:= gui_createpixmap(makesize(1,1));
 attributes._repeat:= 1;
 result:= xrendercreatepicture(appdisp,pixmap,screenrenderpictformat,cprepeat,@attributes);
 col:= colortorendercolor(acolor);
 xrenderfillrectangle(appdisp,pictopsrc,result,@col,0,0,1,1);
 xfreepixmap(appdisp,pixmap);
end;

function createmaskpicture(const acolor: rgbtriplety): tpicture; overload;
var
 attributes: txrenderpictureattributes;
 col: txrendercolor;
 pixmap: pixmapty;
begin
 pixmap:= gui_createpixmap(makesize(1,1));
 attributes._repeat:= 1;
 attributes.component_alpha:= 1;
 result:= xrendercreatepicture(appdisp,pixmap,screenrenderpictformat,
       cprepeat or cpcomponentalpha,@attributes);
 col:= colortorendercolor(acolor);
 xrenderfillrectangle(appdisp,pictopsrc,result,@col,0,0,1,1);
 gui_freepixmap(pixmap);
end;

function createmaskpicture(const amask: tsimplebitmap): tpicture; overload;
var
 attributes: txrenderpictureattributes;
 handle1: pixmapty;
begin
 result:= 0;
 if amask <> nil then begin
  handle1:= tsimplebitmap1(amask).handle;
  if handle1 <> 0 then begin
   attributes.component_alpha:= 1;
   result:= xrendercreatepicture(appdisp,tsimplebitmap1(amask).handle,
        screenrenderpictformat,cpcomponentalpha,@attributes);
  end;
 end;
end;

const
 rgbwhite: rgbtriplety = (blue: $ff; green: $ff; red: $ff; res: $00);

procedure gui_copyarea(var drawinfo: drawinfoty);

const
 sourceformats = cpclipmask or cpclipxorigin or cpclipyorigin;
 destformats = cpgraphicsexposure;

var
 amask: pixmapty;
 xvalues: xgcvalues;
 pixmap: pixmapty;
 pixmapgc: tgc;
 maskgc: gcty;
 bitmap: pixmapty;
 bitmapgc: tgc;
 int1: integer;
 spic,dpic,cpic,maskpic: tpicture;
 sattributes: txrenderpictureattributes;
 dattributes: txrenderpictureattributes;
 transform: txtransform;
 ax,ay: integer;
 aformat: pxrenderpictformat;
 color1: txrendercolor;
 pixmap1,pixmap2: pixmapty;
 areg: region;
 arect: xrectangle;
 needstransform: boolean;
 pictop: integer;
 colormask: boolean;
 bo1: boolean;
label
 endlab;
  
 procedure updatetransform(const apic: tpicture);
 begin
  if needstransform then begin
   xrendersetpicturetransform(appdisp,apic,@transform);
   if al_intpol in drawinfo.copyarea.alignment then begin
    xrendersetpicturefilter(appdisp,apic,'good',nil,0);
   end;
  end
 end;

begin
 with drawinfo,copyarea,sourcerect^,gc,x11gcty(platformdata) do begin
  needstransform:= (alignment * [al_stretchx,al_stretchy] <> []) and
            ((destrect^.cx <> sourcerect^.cx) or
            (destrect^.cy <> sourcerect^.cy)) and
            (destrect^.cx > 0) and (destrect^.cy > 0);
  colormask:= (mask <> nil) and not mask.monochrome;
//  inc(destrect^.cx);
  if hasxrender and (needstransform or (cardinal(transparency) <> 0) or
      colormask) then begin
   if needstransform then begin
//    pictop:= pictopover;
    pictop:= pictopsrc;
    transform:= unitytransform;
    if (cx > 1) and (cx <> destrect^.cx) then begin
     transform[0,0]:= ((cx - 1) * $10000) div destrect^.cx;
     //pixel center to pixel center
     if transform[0,0] > 0 then begin
      ax:= (x * $10000 + $8000) div transform[0,0]; 
     end
     else begin
      ax:= x * $10000; //very big
     end;
    end
    else begin
     transform[0,0]:= (cx * $10000) div destrect^.cx;
     if transform[0,0] > 0 then begin
      ax:= (x * $10000) div transform[0,0]; 
     end
     else begin
      ax:= x * $10000; //very big
     end;
    end;
    if (cy > 1) and (cy <> destrect^.cy) then begin
     transform[1,1]:= ((cy - 1) * $10000) div destrect^.cy;
     //pixel center to pixel center
     if transform[1,1] > 0 then begin
      ay:= (y * $10000 + $8000) div transform[1,1]; 
     end
     else begin
      ay:= y * $10000; //very big
     end;
    end
    else begin
     transform[1,1]:= (cy * $10000) div destrect^.cy;
     if transform[1,1] > 0 then begin
      ay:= (y * $10000) div transform[1,1]; 
     end
     else begin
      ay:= y * $10000; //very big
     end;
    end;
   end
   else begin
    pictop:= pictopsrc;
    ax:= x;
    ay:= y;
   end;
   if (cardinal(transparency) <> 0) and not colormask then begin
    maskpic:= createmaskpicture(rgbtriplety(cardinal(transparency) xor $ffffff));
    pictop:= pictopover;
   end
   else begin
    if colormask then begin
     maskpic:= createmaskpicture(mask);
     updatetransform(maskpic);
     {
     if needstransform then begin
      xrendersetpicturetransform(appdisp,maskpic,@transform);
     end;
     }
     pictop:= pictopover;
    end
    else begin
     maskpic:= 0;
     if (df_canvasismonochrome in gc.drawingflags) and (mask = nil) then begin
      pictop:= pictopsrc; 
     end
     else begin
      if mask <> nil then begin
       maskpic:= createmaskpicture(rgbwhite);
                 //does not work with none
      end;
      pictop:= pictopover; //pictopsrc is unreliable!?
     end;
    end;
   end;
   with sattributes do begin
    clip_x_origin:= ax;
    clip_y_origin:= ay;
    if (mask <> nil) and not colormask then begin
     clip_mask:= tsimplebitmap1(mask).handle;
//     clip_mask:= 0;
    end
    else begin
     clip_mask:= 0;
    end;
   end;
   with dattributes do begin
    graphics_exposures:= 0;
   end;
   if df_colorconvert in gc.drawingflags then begin
    if df_canvasismonochrome in gc.drawingflags then begin
     if maskpic <> 0 then begin
      xrenderfreepicture(appdisp,maskpic);
     end;
     exit; //not supported;         //todo !!!
    end
    else begin //monochrome -> color
     spic:= xrendercreatepicture(appdisp,source^.paintdevice,bitmaprenderpictformat,
                      sourceformats,@sattributes);
     dpic:= xrendercreatepicture(appdisp,paintdevice,screenrenderpictformat,
                      destformats,@dattributes);
     cpic:= createcolorpicture(acolorforeground);
     if gcclipregion <> 0 then begin
      setregion(gc,region(gcclipregion),dpic);
     end;
     updatetransform(spic);
     {
     if needstransform then begin
      xrendersetpicturetransform(appdisp,spic,@transform);
     end;
     }
     xrendercomposite(appdisp,pictop,cpic,spic,dpic,0,0,ax,ay,
                          destrect^.x,destrect^.y,destrect^.cx,destrect^.cy);
     xrenderfreepicture(appdisp,cpic);
     if df_opaque in gc.drawingflags then begin
      xvalues.xfunction:= gxxor;
      xvalues.foreground:= $ffffffff;
      bitmapgc:= xcreategc(appdisp,source^.paintdevice,gcforeground or gcfunction,@xvalues);
      xfillrectangle(appdisp,source^.paintdevice,bitmapgc,x,y,cx,cy);
      cpic:= createcolorpicture(acolorbackground);
      xrendercomposite(appdisp,pictop,cpic,spic,dpic,0,0,ax,ay,destrect^.x,destrect^.y,
                         destrect^.cx,destrect^.cy);
      xrenderfreepicture(appdisp,cpic);
      xfillrectangle(appdisp,source^.paintdevice,bitmapgc,x,y,cx,cy);
      xfreegc(appdisp,bitmapgc);
     end;
    end;
   end
   else begin
    if df_canvasismonochrome in gc.drawingflags then begin
     aformat:= bitmaprenderpictformat;
    end
    else begin
     aformat:= screenrenderpictformat;
    end;
    dpic:= xrendercreatepicture(appdisp,paintdevice,aformat,destformats,
               @dattributes);
    spic:= xrendercreatepicture(appdisp,source^.paintdevice,aformat,
               sourceformats,@sattributes);
    if gcclipregion <> 0 then begin
     setregion(gc,region(gcclipregion),dpic);
    end;
    updatetransform(spic);
    {
    if needstransform then begin
     xrendersetpicturetransform(appdisp,spic,@transform);
    end;
    }
    xrendercomposite(appdisp,pictop,spic,maskpic,dpic,ax,ay,ax,ay,destrect^.x,destrect^.y,
                       destrect^.cx,destrect^.cy);
//    xrendercomposite(appdisp,pictop,spic,maskpic,dpic,ax,ay,0,0,destrect^.x,destrect^.y,
//                       destrect^.cx,destrect^.cy);
   end;
   if maskpic <> 0 then begin
    xrenderfreepicture(appdisp,maskpic);
   end;
   xrenderfreepicture(appdisp,spic);
   xrenderfreepicture(appdisp,dpic);
  end
  else begin
   pixmap2:= 0;
   if copymode <> gcrasterop then begin
    xsetfunction(appdisp,tgc(gc.handle),integer(copymode));
   end;
   if mask <> nil then begin
    amask:= tsimplebitmap1(mask).handle;
    if gcclipregion <> 0 then begin
     pixmap2:= gui_createpixmap(size,0,true);
     maskgc.handle:= cardinal(xcreategc(appdisp,pixmap2,0,@xvalues));
//xsetforeground(appdisp,tgc(maskgc.handle),$1);
//xfillrectangle(appdisp,mask,tgc(maskgc.handle),0,0,100,100);
 //    pixmapgc:= xcreategc(appdisp,pixmap2,0,@xvalues);
     xfillrectangle(appdisp,pixmap2,tgc(maskgc.handle),0,0,cx,cy);
     maskgc.cliporigin:= subpoint(cliporigin,destrect^.pos);
     setregion(maskgc,region(gcclipregion));
 //    xsetregion(appdisp,pixmapgc,region(gcclipregion));    //??? cliporigin gc?
 //    xvalues.clip_x_origin:= -dest^.x+;
 //    xvalues.clip_y_origin:= -dest^.y;
 //    xchangegc(appdisp,pixmapgc,gcclipxorigin or gcclipyorigin,@xvalues);
     xcopyarea(appdisp,amask,pixmap2,tgc(maskgc.handle),x,y,cx,cy,0,0);
//     xsetclipmask(appdisp,tgc(gc.handle),pixmap2);
     xvalues.clip_x_origin:= destrect^.x;
     xvalues.clip_y_origin:= destrect^.y;
     xvalues.clip_mask:= pixmap2;
     xchangegc(appdisp,tgc(gc.handle),gcclipxorigin or gcclipyorigin or
                  gcclipmask,@xvalues);
     xfreegc(appdisp,tgc(maskgc.handle));
//     xflushgc(appdisp,tgc(gc.handle)); //aquire pixmap
//     xfreepixmap(appdisp,pixmap2);
         //xlib assertion error!
    end
    else begin
//     xsetclipmask(appdisp,tgc(gc.handle),mask);
     xvalues.clip_mask:= amask;
     xvalues.clip_x_origin:= destrect^.x - x;
     xvalues.clip_y_origin:= destrect^.y - y;
     xchangegc(appdisp,tgc(gc.handle),gcclipxorigin or gcclipyorigin or
                      gcclipmask,@xvalues);
    end;
   end;
   if df_colorconvert in gc.drawingflags then begin
    xvalues.graphics_exposures:= {$ifdef xboolean}false{$else}0{$endif};
    if df_canvasismonochrome in gc.drawingflags then begin
                        //convert to monochrome
     pixmap:= gui_createpixmap(size);
     if pixmap = 0 then begin
      goto endlab;
     end;
     pixmapgc:= xcreategc(appdisp,pixmap,gcgraphicsexposures,@xvalues);
     if pixmapgc <> nil then begin
      xcopyarea(appdisp,source^.paintdevice,pixmap,pixmapgc,x,y,cx,cy,0,0);
      xvalues.foreground:= transparentcolor;
      xvalues.xfunction:= integer(rop_xor);
      xchangegc(appdisp,pixmapgc,gcforeground or gcfunction,@xvalues);
      xfillrectangle(appdisp,pixmap,pixmapgc,0,0,cx,cy);
      bitmap:= gui_createpixmap(size,0,true);
      if bitmap <> 0 then begin
       xvalues.foreground:= pixel0;
       bitmapgc:= xcreategc(appdisp,bitmap,
                         gcforeground or gcgraphicsexposures,@xvalues);
       if bitmapgc <> nil then begin
        xfillrectangle(appdisp,bitmap,bitmapgc,0,0,cx,cy);
        xvalues.xfunction:= integer(rop_or);
        xvalues.background:= pixel0;
        xvalues.foreground:= pixel1;
        xchangegc(appdisp,bitmapgc,gcfunction or gcforeground or
                gcbackground,@xvalues);
        for int1:= 0 to defdepth - 1 do begin
         xcopyplane(appdisp,pixmap,bitmap,bitmapgc,0,0,cx,cy,
                        0,0,1 shl int1);
        end;
        xcopyarea(appdisp,bitmap,paintdevice,tgc(gc.handle),0,0,cx,cy,destrect^.x,destrect^.y);
        xfreegc(appdisp,bitmapgc);
       end;
       xfreepixmap(appdisp,bitmap)
      end;
      xfreegc(appdisp,pixmapgc);
     end;
     xfreepixmap(appdisp,pixmap);
    end
    else begin
            //convert from monochrome
     pixmapgc:= xcreategc(appdisp,paintdevice,0,nil);
     if pixmapgc <> nil then begin
      xcopygc(appdisp,tgc(gc.handle),gcfunction or gcplanemask or gcsubwindowmode or
                gcgraphicsexposures or gcclipxorigin or
                gcclipyorigin or gcclipmask or gcforeground or gcbackground,pixmapgc);
      with xvalues do begin
       stipple:= source^.paintdevice;
       ts_x_origin:= destrect^.x-x;
       ts_y_origin:= destrect^.y-y;
       if df_opaque in gc.drawingflags then begin
        fill_style:= fillopaquestippled;
       end
       else begin
        fill_style:= fillstippled;
       end;
      end;
      xchangegc(appdisp,pixmapgc,gcfillstyle or gcstipple or
                       gctilestipxorigin or gctilestipyorigin,@xvalues);
      xfillrectangle(appdisp,paintdevice,pixmapgc,destrect^.x,destrect^.y,cx,cy);
      xfreegc(appdisp,pixmapgc);
     end;
    end;
   end
   else begin
    xcopyarea(appdisp,source^.paintdevice,paintdevice,tgc(gc.handle),
                            x,y,cx,cy,destrect^.x,destrect^.y);
   end;
   if mask <> nil then begin
    xvalues.clip_x_origin:= 0;
    xvalues.clip_y_origin:= 0;
    xchangegc(appdisp,tgc(gc.handle),gcclipxorigin or gcclipyorigin,@xvalues);
   end;
   if copymode <> gcrasterop then begin
    xsetfunction(appdisp,tgc(gc.handle),integer(gcrasterop));
   end;
endlab:
   if pixmap2 <> 0 then begin
    xfreepixmap(appdisp,pixmap2);
   end;
  end;
 end;
end;

procedure gui_fonthasglyph(var drawinfo: drawinfoty);
begin
 with drawinfo,fonthasglyph do begin
  if fhasxft then begin
   hasglyph:= xftcharexists(appdisp,pxftfont(font),unichar);
  end
  else begin
   hasglyph:= true;
  end;
 end;
end;

procedure gui_drawlines(var drawinfo: drawinfoty);
var
 int1: integer;
begin
 with drawinfo,drawinfo.points do begin
  transformpoints(drawinfo,closed);
  int1:= count;
  if closed then begin
   inc(int1);
  end;
  xdrawlines(appdisp,paintdevice,tgc(gc.handle),buffer.buffer,int1,
                           coordmodeorigin);
 end;
end;

procedure gui_drawlinesegments(var drawinfo: drawinfoty);
begin
 transformpoints(drawinfo,false);
 with drawinfo,drawinfo.points do begin
  xdrawsegments(appdisp,paintdevice,tgc(gc.handle),buffer.buffer,count div 2);
 end;
end;

procedure gui_drawellipse(var drawinfo: drawinfoty);
begin
 with drawinfo,drawinfo.rect.rect^ do begin
  xdrawarc(appdisp,paintdevice,tgc(gc.handle),
   x+origin.x-cx div 2,y+origin.y - cy div 2,cx,cy,0,wholecircle);
 end;
end;

const
 angscale = 64*360/(2*pi);
 
procedure gui_drawarc(var drawinfo: drawinfoty);
begin
 with drawinfo,drawinfo.arc,rect^ do begin
  xdrawarc(appdisp,paintdevice,tgc(gc.handle),
   x+origin.x-cx div 2,y+origin.y - cy div 2,cx,cy,
   round(startang*angscale),round(extentang*angscale));
 end;
end;

procedure gui_drawstring16(var drawinfo: drawinfoty);
var
 po1: pxchar2b;
 xvalues: xgcvalues;
 glyphinfo: txglyphinfo;
begin
 with drawinfo,drawinfo.text16pos do begin
  if fhasxft then begin
 {$ifdef FPC}{$checkpointer off}{$endif}
   checkxftdraw(drawinfo);
   transformpos(drawinfo);
   with pxpoint(buffer.buffer)^ do begin
    with x11gcty(gc.platformdata) do begin
     if df_opaque in gc.drawingflags then begin
      xfttextextents16(appdisp,xftfont,text,count,@glyphinfo);
//      xftdrawrect(xftdraw,@xftcolorbackground,x-glyphinfo.x,y-xftfont^.ascent,
//              glyphinfo.width,xftfont^.ascent+xftfont^.descent);
                   //unreliable!?
      xvalues.foreground:= xftcolorbackground.pixel;
      xchangegc(appdisp,tgc(gc.handle),gcforeground,@xvalues);
      xfillrectangle(appdisp,paintdevice,tgc(gc.handle),x{-glyphinfo.x},y-xftfont^.ascent,
              glyphinfo.xoff,xftfont^.ascent+xftfont^.descent);
      xvalues.foreground:= xftcolor.pixel;
      xchangegc(appdisp,tgc(gc.handle),gcforeground,@xvalues);
     end;
     xftdrawstring16(xftdraw,@xftcolor,xftfont,x,y,text,count);
    end;
   end
{$ifdef FPC}{$checkpointer default}{$endif}
  end
  else begin
   po1:= transformtext16pos(drawinfo); //swap bytes
   with pxpoint(buffer.buffer)^ do begin
    if df_opaque in gc.drawingflags then begin
     xdrawimagestring16(appdisp,paintdevice,tgc(gc.handle),x,y,po1,count);
    end
    else begin
     xdrawstring16(appdisp,paintdevice,tgc(gc.handle),x,y,po1,count);
    end;
   end;
  end;
 end;
end;

procedure gui_setcliporigin(var drawinfo: drawinfoty);
begin
 with drawinfo,gc do begin
  xsetcliporigin(appdisp,tgc(handle),cliporigin.x,cliporigin.y);
 end;
end;

procedure gui_fillrect(var drawinfo: drawinfoty);
var
 points1: array[0..3] of xpoint;
 x1,y1: smallint;
begin
 with drawinfo,drawinfo.rect.rect^ do begin
  x1:= x+origin.x;
  y1:= y+origin.y;
  points1[0].x:= x1;
  points1[0].y:= y1;
  points1[1].y:= y1;
  points1[3].x:= x1;
  inc(x1,cx);
  inc(y1,cy);
  points1[1].x:= x1;
  points1[2].x:= x1;
  points1[2].y:= y1;
  points1[3].y:= y1;
  xfillpolygon(appdisp,paintdevice,tgc(gc.handle),@points1[0],4,complex,coordmodeorigin);
//  xfillrectangle(appdisp,paintdevice,tgc(gc.handle),
//   x+origin.x,y+origin.y,smallint(cx),smallint(cy)); //does not work with negative cx,cy
 end;
end;

procedure gui_fillelipse(var drawinfo: drawinfoty);
begin
 with drawinfo,drawinfo.rect.rect^ do begin
  xfillarc(appdisp,paintdevice,tgc(gc.handle),
   x+origin.x-cx div 2,y+origin.y - cy div 2,cx,cy,0,wholecircle);
 end;
end;

procedure gui_fillarc(var drawinfo: drawinfoty);
var
 xvalues: xgcvalues;
begin
 with drawinfo,drawinfo.arc,rect^ do begin
  if pieslice then begin
   xvalues.arc_mode:= arcpieslice;
  end
  else begin
   xvalues.arc_mode:= arcchord;
  end;
  xchangegc(appdisp,tgc(gc.handle),gcarcmode,@xvalues);
  xfillarc(appdisp,paintdevice,tgc(gc.handle),
   x+origin.x-cx div 2,y+origin.y - cy div 2,cx,cy,
   round(startang*angscale),round(extentang*angscale));
 end;
end;

procedure gui_fillpolygon(var drawinfo: drawinfoty);
begin
 transformpoints(drawinfo,false);
 with drawinfo,drawinfo.points do begin
  xfillpolygon(appdisp,paintdevice,tgc(gc.handle),buffer.buffer,
          count,complex,coordmodeorigin);
 end;
end;

procedure gui_beep;
begin
 gdi_lock;
 xbell(appdisp,0);
 gdi_unlock;
 xflush(appdisp); 
end;

function gui_flushgdi: guierrorty;
begin
 xflush(appdisp);
 result:= gue_ok;
end;

function msedisplay: pdisplay;
begin
 result:= appdisp;
end;

function msevisual: pvisual;
begin
 result:= pvisual(defvisual);
end;

function msedefaultscreen: pscreen;
begin
 result:= defscreen;
end;

{$ifdef with_sm}
//callbacks
procedure icewatch(_iceConn: IceConn; clientData: IcePointer;
                     opening: Bool; var watchData: IcePointer); cdecl;
begin
 with psminfoty(clientdata)^ do begin
  if iceconnection = nil then begin
   iceconnection:= _iceconn;
  end;
  if _iceconn = iceconnection then begin
   if (opening <> 0) then begin
    fd:= iceconnectionnumber(_iceconn);
   end
   else begin
    fd:= -1;
   end;
  end;
 end;
end;

procedure SmcSaveYourself(_smcConn: SmcConn; clientData: pointer;
                        saveType: integer; ashutdown: bool;
                        ainteractStyle: integer; fast: bool); cdecl;
begin
 with psminfoty(clientdata)^ do begin
  if (ashutdown <> 0) then begin
   shutdown:= true;
   interactstyle:= ainteractstyle;
  end
  else begin
   smcsaveyourselfdone(_smcconn,1);
  end;
 end;
end; 

procedure SmcDie(_smcConn: SmcConn; clientData: pointer); cdecl;
begin
end;

procedure SmcSaveComplete(_smcConn: SmcConn; clientData: pointer); cdecl;
begin
end;

procedure SmcShutdownCancelled(_smcConn: SmcConn;
                               clientData: pointer); cdecl;
begin
 with psminfoty(clientdata)^ do begin
  shutdown:= false;
  shutdownpending:= false;
 end;
end;

procedure interact(_smcConn: SmcConn; clientData: SmPointer); cdecl;
begin
 with psminfoty(clientdata)^ do begin
  interactgranted:= true;
 end;
end;

{$endif}

procedure gui_cancelshutdown;
begin
{$ifdef with_sm}
 if hassm then begin
  with sminfo do begin
 {$ifdef smdebug}
   writeln('gui_cancelshutdown ',shutdown,shutdownpending,
                   interactwaiting,interactgranted);
 {$endif}
   if shutdown and shutdownpending and interactgranted then begin
    smcinteractdone(smconnection,1);
 {$ifdef smdebug}
    writeln('gui_cancelshutdown smcinteractdone');
 {$endif}
    smcsaveyourselfdone(smconnection,1);
 {$ifdef smdebug}
    writeln('gui_cancelshutdown smcsaveyourselfdone');
 {$endif}
    interactwaiting:= false;
    interactgranted:= false;
   end;
  end;
 end;
{$endif}
end;

var
 escapepressed: boolean;
 
function gui_escapepressed: boolean;
begin
 result:= escapepressed;
end;

procedure gui_resetescapepressed;
begin
 escapepressed:= false;
end;

function getkeynomod(const xev: {$ifdef FPC}txkeyevent{$else}
                                                  xkeyevent{$endif}): keyty;
var
 keysym1: pkeysym;
 int1,int2: integer;
begin
 result:= key_none;
 {$ifdef fpc} {$checkpointer off} {$endif}
 inc(xlockerror);
 keysym1:= xgetkeyboardmapping(appdisp,xev.keycode,1,@int1);
 if keysym1 <> nil then begin
  result:= xkeytokey(keysym1^);
  xfree(keysym1);
 end;
 dec(xlockerror);
 {$ifdef fpc} {$checkpointer default} {$endif}
end;

function gui_getevent: tevent;

var
 xev,xev2: xevent;
 w: winidty;
 eventkind: eventkindty;
 akey: keysym;
 buffer: string;
 icstatus: tstatus;
 chars: msestring;
 int1: integer;
 event: xevent;
 pollinfo: array[0..1] of pollfd;
             //0 connection, 1 sessionmanagement
 pollcount: integer;
// fdsetr,fdsete: tfdset;
 str1: string;
 {$ifdef with_sm}
 int2: integer;
 {$endif}
 shiftstate1: shiftstatesty;
 key1,key2: keyty;
 button1: mousebuttonty;
 atomar: array[0..4] of atom;
 textprop: xtextproperty;
 bo1: boolean;
 rect1: rectty;
 aic: xic;

label
 eventrestart;
    
begin
 while true do begin
  if gui_hasevent then begin
   break;
  end;
  fillchar(pollinfo,sizeof(pollinfo),0);
  pollcount:= 1;
  with pollinfo[0] do begin
   fd:= xconnectionnumber(appdisp);
   events:= pollin or pollpri;
  end;
{$ifdef with_sm}
  if hassm then begin
   if sminfo.fd > 0 then begin
    with pollinfo[1] do begin
     fd:= sminfo.fd;
     events:= pollin or pollpri;
    end;
    inc(pollcount);
   end;
  end;
{$endif}
  if not timerevent and not terminated and not childevent then begin
   repeat
    if not application.unlock then begin
     guierror(gue_notlocked);
    end;
    int1:= poll(@pollinfo,pollcount,1000); 
     //wakeup clientmessages are sometimes missed with xcb ???
    application.lock;
   until (int1 <> -1) or timerevent or terminated;
 {$ifdef with_sm}
   if hassm then begin
    if (int1 > 0) and (pollinfo[1].revents <> 0) then begin
     iceprocessmessages(sminfo.iceconnection,nil,int2);
     with sminfo do begin
      if shutdown then begin
       if not shutdownpending then begin
        interactgranted:= false;
        shutdownpending:= true;
        if (interactstyle = sminteractstyleerrors) or 
             (interactstyle = sminteractstyleany) then begin
         if SmcInteractRequest(smconnection,smdialognormal,
                  {$ifdef FPC}@{$endif}interact,@sminfo) = 0 then begin
 {$ifdef smdebug}
          writeln('gui_getevent SmcInteractRequest');
 {$endif}
          terminated:= true;
         end
         else begin
          interactwaiting:= true;
         end;
        end
        else begin
         interactwaiting:= false;
         terminated:= true;
        end;
       end
       else begin
        if interactwaiting and interactgranted then begin
         terminated:= true;
         interactwaiting:= false;
        end;
       end;
      end;
     end;
    end;
   end;
{$endif}
  end;
  if timerevent then begin
   application.postevent(tevent.create(ek_timer));
   timerevent:= false;
  end;
  if terminated then begin
   application.postevent(tevent.create(ek_terminate));
   terminated:= false;
  end;
  if childevent then begin
   childevent:= false;
   handlesigchld;
  end;
 end;
 result:= nil;
 if not gui_hasevent then begin
  exit;
 end;

eventrestart:
 xnextevent(appdisp,@xev);
 if longint(xfilterevent(@xev,none)) <> 0 then begin
  exit;
 end;
 if xev.xany.xwindow = appid then begin
  if (xev.xtype = selectionclear) then begin
   if xev.xselectionclear.selection = clipboardatom then begin
    clipboard:= '';
    exit;
   end;
  end
  else begin
   if xev.xtype = selectionrequest then begin
    with xev.xselectionrequest do begin
     if selection = clipboardatom then begin
      event.xtype:= selectionnotify;
      event.xselection.requestor:= requestor;
      event.xselection.selection:= clipboardatom;
      if {$ifdef FPC}_property{$else}xproperty{$endif} = none then begin
       {$ifdef FPC}_property{$else}xproperty{$endif}:= target;
      end;
      event.xselection.target:= target;
      event.xselection.{$ifdef FPC}_property{$else}xproperty{$endif}:= 
                               {$ifdef FPC}_property{$else}xproperty{$endif};
      if target = targetsatom then begin
       atomar[0]:= utf8_stringatom;
       atomar[1]:= compound_textatom;
       atomar[2]:= stringatom;
       atomar[3]:= textatom;
       atomar[4]:= targetsatom;
       xchangeproperty(appdisp,requestor,
          {$ifdef FPC}_property{$else}xproperty{$endif},atomatom,32,
                  propmodereplace,@atomar[0],5);
      end
      else begin
       bo1:= true;
       if target = utf8_stringatom then begin
         str1:= stringtoutf8(clipboard);
       end
       else begin
        if target = stringatom then begin
         str1:= stringtolatin1(clipboard);
        end
        else begin
         if target =  textatom then begin
          str1:= clipboard; //current locale
         end
         else begin
          bo1:= false;
          if target = compound_textatom then begin
           if stringtotextproperty(clipboard,xcompoundtextstyle,textprop) then begin
            with textprop do begin
             xchangeproperty(appdisp,requestor,
                   {$ifdef FPC}_property{$else}xproperty{$endif},encoding,format,
                   propmodereplace,value,nitems);
             xfree(value);
            end;
           end
           else begin
            event.xselection.{$ifdef FPC}_property{$else}xproperty{$endif}:= none;
           end;
          end
          else begin
           event.xselection.{$ifdef FPC}_property{$else}xproperty{$endif}:= none;
          end;
         end;
        end;
       end;
       if bo1 then begin
        xchangeproperty(appdisp,requestor,
                 {$ifdef FPC}_property{$else}xproperty{$endif},target,8,
                  propmodereplace,pbyte(pchar(str1)),length(str1));
       end;
      end;
      xsendevent(appdisp,requestor,{$ifdef xboolean}false{$else}0{$endif},0,@event);
      exit;
     end;
    end;
   end;
  end;
 end;
 case xev.xtype of
  clientmessage: begin
   with xev.xclient do begin
    if display = appdisp then begin
     if message_type = mseclientmessageatom then begin
      result:= tevent(data.l[0]); //todo: 64bit
     end
     else begin
      if message_type = wmprotocolsatom then begin
       if cardinal(data.l[0]) = wmprotocols[wm_delete_window] then begin
        result:= twindowevent.create(ek_close,xwindow);
{$ifdef with_saveyourself}
       end
       else begin
        if cardinal(data.l[0]) = wmprotocols[wm_save_yourself] then begin
         result:= tevent.create(ek_terminate);
         saveyourselfwindow:= window;
        end;
       end;
{$else}
       end;
{$endif}
      end;
     end;
    end;
   end;
  end;
  enternotify: begin
   with xev.xcrossing do begin
    result:= tmouseenterevent.create(xwindow,
                makepoint(x,y),xtoshiftstate(state,key_none,mb_none,false),
                 time*1000);
   end;
  end;
  leavenotify: begin
   with xev.xcrossing do begin
    if mode = notifynormal then begin //??
     result:= twindowevent.create(ek_leavewindow,xwindow);
    end;
   end;
  end;
  motionnotify: begin
   with xev.xmotion do begin
    lasteventtime:= time;
    result:= tmouseevent.create(xwindow,false,mb_none,mw_none,
                makepoint(x,y),xtoshiftstate(state,key_none,mb_none,false),time*1000);
   end;
  end;
  keypress: begin
   with xev.xkey do begin
    {$ifdef FPC}
    aic:= getic(window);
    {$else}
    aic:= getic(xwindow);
    {$endif}
    lasteventtime:= time;
    setlength(buffer,20);
    int1:= xutf8lookupstring(aic,@xev.xkey,@buffer[1],length(buffer),@akey,@icstatus);
    setlength(buffer,int1);
    if icstatus = xbufferoverflow then begin
     xutf8lookupstring(aic,@xev.xkey,@buffer[1],length(buffer),@akey,@icstatus);
    end;
    chars:= utf8tostring(buffer);
    case icstatus of
     xlookupnone: exit;
     xlookupchars: akey:= 0;
     xlookupkeysym_: chars:= '';
    end;
    key1:= xkeytokey(akey);
    if key1 = key_escape then begin
     escapepressed:= true;
    end;
    shiftstate1:= xtoshiftstate(state,key1,mb_none,false);
    key2:= getkeynomod(xev.xkey);
    result:= tkeyevent.create(xwindow,false,key1,key2,
                                    shiftstate1,chars,time*1000);
   end;
  end;
  keyrelease: begin
   with xev.xkey do begin
    lasteventtime:= time;
    int1:= keycode;
    xlookupstring(@xev.xkey,nil,0,@akey,nil);
    key1:= xkeytokey(akey);
    key2:= getkeynomod(xev.xkey);
    shiftstate1:= xtoshiftstate(state,key1,mb_none,true);
    if xpending(appdisp) > 0 then begin
     xpeekevent(appdisp,@xev);
     if (xev.xtype = keypress) and (time - lasteventtime < 10) and 
                                                   (keycode = int1) then begin
       goto eventrestart;  //auto repeat key, don't send
      end;
     end;
    result:= tkeyevent.create(xwindow,true,key1,key2,shiftstate1,'',time*1000);
   end;
  end;
  buttonpress,buttonrelease: begin
   with xev.xbutton do begin
    lasteventtime:= time;
    button1:= xtomousebutton(button);
    shiftstate1:= xtoshiftstate(state,key_none,button1,xev.xtype=buttonrelease);
    if button = 4 then begin
     if xev.xtype = buttonpress then begin
      result:= tmouseevent.create(xwindow,false,mb_none,mw_up,
                makepoint(x,y),shiftstate1,time*1000);
     end;
    end
    else begin
     if button = 5 then begin
      if xev.xtype = buttonpress then begin
       result:= tmouseevent.create(xwindow,false,mb_none,mw_down,
                makepoint(x,y),shiftstate1,time*1000);
      end;
     end
     else begin
      result:= tmouseevent.create(xwindow,xtype = buttonrelease,button1,mw_none,
                makepoint(x,y),shiftstate1,time*1000);
     end;
    end;
   end;
  end;
  mappingnotify: begin
   xrefreshkeyboardmapping(@xev.xkeymap);
  end;
  mapnotify: begin
   with xev.xmap do begin
    result:= twindowevent.create(ek_show,xwindow);
   end;
  end;
  unmapnotify: begin
   with xev.xunmap do begin
    result:= twindowevent.create(ek_hide,xwindow);
   end;
  end;
  focusin,focusout: begin
   with xev.xfocus do begin
    if xtype = focusin then begin
     eventkind:= ek_focusin;
    end
    else begin
     eventkind:= ek_focusout;
    end;
    if mode <> notifypointer then begin
     result:= twindowevent.create(eventkind,window);
    end;
   end;
  end;
  expose: begin
   with xev.xexpose do begin
    result:= twindowrectevent.create(ek_expose,xwindow,makerect(x,y,width,height));
   end;
  end;
  graphicsexpose: begin
   with xev.xgraphicsexpose do begin
    result:= twindowrectevent.create(ek_expose,drawable,makerect(x,y,width,height));
   end;
  end;
  configurenotify: begin
   with xev.xconfigure do begin
    w:= xwindow;
    if longint(xchecktypedwindowevent(appdisp,w,destroynotify,@xev2)) <> 0 then begin
     result:= twindowevent.create(ek_destroy,xwindow);
    end
    else begin
      
     while longint(xchecktypedwindowevent(appdisp,w,configurenotify,@xev))
                   <> 0 do begin end;
      //gnome returns a different pos on window resizing than on window moving!
     if not application.deinitializing then begin //there can be an Xerror?
      gui_getwindowrect(w,rect1); 
     end;
     result:= twindowrectevent.create(ek_configure,xwindow,rect1);
    end;
   end;
  end;
  destroynotify: begin
   with xev.xdestroywindow do begin
    result:= twindowevent.create(ek_destroy,xwindow);
   end;
  end;
 end;
end;

function errorhandler(Display: PDisplay; ErrorEvent: PXErrorEvent):
    Longint; cdecl;
const
 buflen = 256;
var
 buffer: array[0..buflen] of char;
begin
 if xlockerror = 0 then begin
  xgeterrortext(display,errorevent^.error_code,@buffer,buflen);
   sys_errorout('X Error: '+ pchar(@buffer) + '  '+inttostr(errorevent^.error_code)+
        lineend +'  Major opcode:  '+inttostr(errorevent^.request_code)+lineend);
 end;
 result:= 0;
end;

function gui_initcolormap: guierrorty;
begin
 if is8bitcolor and istruecolor then begin
  setcolormapvalue(cl_background,$d0,$e0,$d0);
             //green instead of blue tint
 end;
 result:= gue_ok;
end;

procedure initcolormap;
const
 redm = $07;
 reds = 5;
 greenm = $38;
 greens = 2;
 bluem = $c0;
 blues = 0;
{
 redm = $e0;
 reds = 0;
 greenm = $1c;
 greens = 3;
 bluem = $03;
 blues = 6;
}
var
 map1: array[0..255] of {$ifdef FPC}txcolor{$else}xcolor{$endif};
 int1: integer;
begin
 msecolormap:= xcreatecolormap(appdisp,rootid,pointer(defvisual),allocall);
 if msecolormap <> 0 then begin
  xredshiftleft:= false;
  xredshift:= 16 + reds;
  xredmask:= redm;
  xgreenshiftleft:= false;
  xgreenshift:= 8 + greens;
  xgreenmask:= greenm;
  xblueshiftleft:= false;
  xblueshift:= 0 + blues;
  xbluemask:= bluem;
  for int1:= 0 to 255 do begin
   with map1[int1] do begin
    pixel:= int1;
    red:= ($ffff*(int1 and redm)) div redm ;
    green:= ($ffff*(int1 and greenm)) div greenm ;
    blue:= ($ffff*(int1 and bluem)) div bluem ;
    {$ifdef FPC}
    flags:= dored or dogreen or doblue;
    pad:= 0;
    {$else}
    flags:= char(dored or dogreen or doblue);
    pad:= #0;
    {$endif}
   end;
  end;
  with map1[$f6] do begin //value for cl_background
   red:= $d000;
   green:= $d000;
   blue:= $d000;
  end;
  xstorecolors(appdisp,msecolormap,@map1,256);
 end;
end;
{
function createappic: boolean; forward;
function icdestroyed(ic: txic; client_data: txpointer; 
                               call_data: txpointer): longbool; cdecl;
begin
 result:= false;
 appic:= nil;
 if not terminated then begin
  if not createappic then begin
   debugwriteln('Input context lost.');
   halt(1);
  end;
 end;
end;
}
function createappic: boolean;
var
 xiccallback: txiccallback;
begin
 appic:= xcreateic(im,pchar(xninputstyle),ximstatusnothing or ximpreeditnothing,nil);
 result:= appic <> nil;
 if result then begin
 {
  xiccallback.client_data:= nil;
  xiccallback.callback:= @icdestroyed;
  }
  xseticvalues(appic,pchar(xnclientwindow),appid,
                         {pchar(xndestroycallback)@,xiccallback,}nil);
  xgeticvalues(appic,pchar(xnfilterevents),@appicmask,nil);
 end;
end;

function createim: boolean; forward;

procedure imdestroyed(ic: txim; client_data: txpointer;
                                          call_data: txpointer); cdecl;
begin
 im:= nil;
 appic:= nil;
 if not terminated then begin
  if not createim or not createappic then begin
   debugwriteln('Input method lost.');
   halt(1);
  end;
 end;
end;

function createim: boolean;
var
 ximcallback: tximcallback;
begin
 xsetlocalemodifiers('');
 im:= xopenim(appdisp,nil,nil,nil);
 if im = nil then begin
  xsetlocalemodifiers('@im=local');
  im:= xopenim(appdisp,nil,nil,nil);
  if im = nil then begin
   xsetlocalemodifiers('@im=');
   im:= xopenim(appdisp,nil,nil,nil);
  end;
 end;
 result:= im <> nil;
 if result then begin
  ximcallback.client_data:= nil;
  ximcallback.callback:= @imdestroyed;
  xsetimvalues(im,pchar(xndestroycallback),@ximcallback,nil);
 end;
end;

function gui_init: guierrorty;
label
 error;
var
 fontpropnames: strfontproparty;
 propnum: fontpropertiesty;
 attrib: xsetwindowattributes;
 netnum: netatomty;
 int1,int2: integer;
 ar1: stringarty;
 po1: pchar;
 atomar: atomarty;
 rect1: rectty;
 sigset1,sigset2: sigset_t;
{$ifdef with_sm}
 smcb: smccallbacks;
 clientid: pchar;
 smerror: array[0..255] of char;
{$endif}
 
begin
 {$ifdef mse_flushgdi}
 xinitthreads;
 {$endif}
 ar1:= getcommandlinearguments;
 for int1:= 1 to high(ar1) do begin
  if ar1[int1] = '--TOPLEVELRAISE' then begin
   toplevelraise:= true;
   deletecommandlineargument(int1);
  end;
  if ar1[int1] = '--NOZORDERHANDLING' then begin
   nozorderhandling:= true;
   deletecommandlineargument(int1);
  end;
 end;
 {$ifdef with_sm} 
 if hassm then begin
   //todo: error handling
  if sminfo.smconnection = nil then begin
   if iceaddconnectionwatch({$ifdef FPC}@{$endif}icewatch,@sminfo) <> 0 then begin
    with smcb do begin
     save_yourself.callback:= {$ifdef FPC}@{$endif}SmcSaveYourself;
     save_yourself.client_data:= @sminfo;
     die.callback:= {$ifdef FPC}@{$endif}SmcDie;
     die.client_data:= @sminfo;
     save_complete.callback:= {$ifdef FPC}@{$endif}SmcSaveComplete;
     save_complete.client_data:= @sminfo;
     shutdown_cancelled.callback:= {$ifdef FPC}@{$endif}SmcShutdownCancelled;
     shutdown_cancelled.client_data:= @sminfo;
    end;
    
    sminfo.smconnection:= smcopenconnection(nil,nil,SmProtoMajor,SmProtoMinor,
        SmcSaveYourselfProcMask or SmcDieProcMask or SmcSaveCompleteProcMask or
        SmcShutdownCancelledProcMask,smcb,nil,clientid,sizeof(smerror),@smerror);
    if clientid <> nil then begin
     xfree(clientid);
    end;
   end;
  end;
 end;
 {$endif}
 {$ifdef with_saveyourself}
 saveyourselfwindow:= 0;
 {$endif}
 lasteventtime:= currenttime;
 setlocale(lc_all,'');
// xsetlocalemodifiers(pchar('@im=local'));
// cursorshape:= cursorshapety(-1);
 terminated:= false;
 result:= gue_nodisplay;
 timerevent:= false;
 sigtimerbefore:= signal(sigalrm,{$ifdef FPC}@{$endif}sigtimer);
 sigtermbefore:= signal(sigterm,{$ifdef FPC}@{$endif}sigterminate);
 sigchldbefore:= signal(sigchld,{$ifdef FPC}@{$endif}sigchild);
 sigemptyset(sigset1);
 sigaddset(sigset1,sigchld);
 m_sigprocmask(sig_unblock,sigset1,sigset2); 
 
 appdisp:= xopendisplay(nil);
 if appdisp = nil then begin
  goto error;
 end;
 if not createim then begin
  result:= gue_inputmanager;
  goto error;
 end; 
 defscreen:= xdefaultscreenofdisplay(appdisp);
 rootid:= xrootwindowofscreen(defscreen);
 defvisual:= msepvisual(xdefaultvisualofscreen(defscreen));
 defdepth:= xdefaultdepthofscreen(defscreen);
 attrib.event_mask:= propertychangemask;
 appid:= xcreatewindow(appdisp,rootid,0,0,200,200,0,
              0,inputonly,xlib.pvisual(copyfromparent),cweventmask,@attrib);
 if appid = 0 then begin
  result:= gue_createwindow;
  goto error;
 end;
 if not createappic then begin
  result:= gue_inputcontext;
  goto error;
 end;  
 {$ifdef FPC} {$checkpointer off} {$endif}
 {$ifdef FPC}
 is8bitcolor:= defaultdepthofscreen(defscreen) = 8;
 {$else}
 is8bitcolor:= defscreen^.root_depth = 8;
 {$endif}
 if (defvisual^._class = pseudocolor) and is8bitcolor then begin
  istruecolor:= false;
  initcolormap;
  if msecolormap = 0 then begin
   result:= gue_nocolormap;
   goto error;
  end;
 end
 else begin
  istruecolor:= (defvisual^._class = truecolor) or (defvisual^._class = directcolor);
 {$ifdef FPC} {$checkpointer default} {$endif}
  if istruecolor then begin
  {$ifdef FPC} {$checkpointer off} {$endif}
   xredmask:= defvisual^.red_mask;
   xgreenmask:= defvisual^.green_mask;
   xbluemask:= defvisual^.blue_mask;
  {$ifdef FPC} {$checkpointer default} {$endif}
   xredshift:= highestbit(xredmask)-(redshift+7);
   if xredshift < 0 then begin
    xredshiftleft:= false;
    xredshift:= -xredshift;
   end
   else begin
    xredshiftleft:= true;
   end;
   xgreenshift:= highestbit(xgreenmask)-(greenshift+7);
   if xgreenshift < 0 then begin
    xgreenshiftleft:= false;
    xgreenshift:= -xgreenshift;
   end
   else begin
    xgreenshiftleft:= true;
   end;
   xblueshift:= highestbit(xbluemask)-(blueshift+7);
   if xblueshift < 0 then begin
    xblueshiftleft:= false;
    xblueshift:= -xblueshift;
   end
   else begin
    xblueshiftleft:= true;
   end;
  end
  else begin
   result:= gue_notruecolor;
   goto error;
  end;
 end;
 
 hasxrender:= hasxrender and (xrenderqueryextension(msedisplay,@int1,@int2) <> 0);
 if hasxrender then begin
  screenrenderpictformat:= xrenderfindvisualformat(appdisp,pvisual(defvisual));
  bitmaprenderpictformat:= xrenderfindstandardformat(appdisp,pictstandarda1);
  alpharenderpictformat:= xrenderfindstandardformat(appdisp,pictstandarda8);
 end;
 if not noxft then begin
  fhasxft:= fhasxft and xftdefaulthasrender(appdisp) and (xftgetversion() >= 20000);
  if fhasxft then begin
   fhasxft:= xftinit(nil);
   if fhasxft then begin
    fhasxft:= xftinitftlibrary();
    if fhasxft and not hasdefaultfontarg then begin
     defaultfontinfo[fn_family_name]:= 'sans';
    end;
   end;
  end;
 end
 else begin
  fhasxft:= false;
 end;
 defcolormap:= xdefaultcolormapofscreen(defscreen);
 atomatom:= xinternatom(appdisp,'ATOM',
          {$ifdef xboolean}true{$else}1{$endif});
 mseclientmessageatom:= xinternatom(appdisp,'mseclientmessage',
          {$ifdef xboolean}false{$else}0{$endif});
 wmprotocolsatom:= xinternatom(appdisp,'WM_PROTOCOLS',
           {$ifdef xboolean}false{$else}0{$endif});
 wmnameatom:= xinternatom(appdisp,'WM_NAME',
           {$ifdef xboolean}false{$else}0{$endif});
 wmclassatom:= xinternatom(appdisp,'WM_CLASS',
           {$ifdef xboolean}false{$else}0{$endif});
 wmprotocols[wm_delete_window]:= xinternatom(appdisp,'WM_DELETE_WINDOW',
           {$ifdef xboolean}false{$else}0{$endif});
{$ifdef with_saveyourself}
 wmprotocols[wm_save_yourself]:= xinternatom(appdisp,'WM_SAVE_YOURSELF',
           {$ifdef FPC}false{$else}0{$endif});
 wmcommandatom:= xinternatom(appdisp,'WM_COMMAND',
           {$ifdef FPC}false{$else}0{$endif});
{$endif}
 wmstateatom:= xinternatom(appdisp,'WM_STATE',
           {$ifdef xboolean}false{$else}0{$endif});
 wmclientleaderatom:= xinternatom(appdisp,'WM_CLIENT_LEADER',
           {$ifdef xboolean}false{$else}0{$endif});
 clipboardatom:= xinternatom(appdisp,'CLIPBOARD',
           {$ifdef xboolean}false{$else}0{$endif});
 cardinalatom:= xinternatom(appdisp,'CARDINAL',
           {$ifdef xboolean}false{$else}0{$endif});
 windowatom:= xinternatom(appdisp,'WINDOW',
           {$ifdef xboolean}false{$else}0{$endif});
 stringatom:= xinternatom(appdisp,'STRING',
           {$ifdef xboolean}false{$else}0{$endif});
 textatom:= xinternatom(appdisp,'TEXT',
           {$ifdef xboolean}false{$else}0{$endif});
 compound_textatom:= xinternatom(appdisp,'COMPOUND_TEXT',
           {$ifdef xboolean}false{$else}0{$endif});
 utf8_stringatom:= xinternatom(appdisp,'UTF8_STRING',
           {$ifdef xboolean}false{$else}0{$endif});
 targetsatom:= xinternatom(appdisp,'TARGETS',
           {$ifdef xboolean}false{$else}0{$endif});
 convertselectionpropertyatom:= xinternatom(appdisp,'mseconvselprop',
           {$ifdef xboolean}false{$else}0{$endif});

 netsupportedatom:= xinternatom(appdisp,'_NET_SUPPORTED',
           {$ifdef xboolean}false{$else}0{$endif});

 for propnum:= low(fontpropertiesty) to high(fontpropertiesty) do begin
  fontpropnames[propnum]:= fontpropertynames[propnum].name;
 end;

 xinternatoms(appdisp,@fontpropnames[low(fontpropertiesty)],
          integer(high(fontpropertiesty)),{$ifdef xboolean}true{$else}1{$endif},
          @fontpropertyatoms[low(fontpropertiesty)]);

 fillchar(netatoms,sizeof(netatoms),0);               //check _net_
 xinternatoms(appdisp,@netatomnames[low(netatomty)],
          integer(high(netatomty)),{$ifdef xboolean}true{$else}1{$endif},
          @netatoms[low(netatomty)]);
 netsupported:= netsupportedatom <> 0;
 for netnum:= low(netatomty) to needednetatom do begin
  if netatoms[netnum] = 0 then begin
   netsupported:= false;
   break;
  end;
 end;

 canframeextents:= netatoms[net_frame_extents] <> 0;
 canfullscreen:= netsupported;
 if netsupported and (netatoms[net_wm_state_fullscreen] = 0) then begin
  netatoms[net_wm_state_fullscreen]:= xinternatom(appdisp,
          @netatomnames[net_wm_state_fullscreen],
           {$ifdef xboolean}false{$else}0{$endif});
           //fake
  canfullscreen:= false;
 end; 
 if readatomproperty(rootid,netsupportedatom,atomar) then begin
  if canfullscreen then begin
   canfullscreen:= false;
   for int1:= 0 to high(atomar) do begin
    if atomar[int1] = netatoms[net_wm_state_fullscreen] then begin
     canfullscreen:= true;
     break;
    end;
   end;
  end;
  {
  if canframeextents and (netatoms[net_request_frame_extents] <> 0) then begin
   canframeextents:= false;
   for int1:= 0 to high(atomar) do begin
    if (atomar[int1] = netatoms[net_request_frame_extents]) or 
        (atomar[int1] = netatoms[net_frame_extents]) then begin
     canframeextents:= true;
     break;
    end;
   end;
  end;
  }
 end;
 if netsupported then begin
  if not readlongproperty(rootid,netatoms[net_workarea],4,rect1) then begin
   netsupported:= false;
  end;
 end;
 result:= gue_ok;
 {$ifdef mse_flushgdi}
 xsynchronize(appdisp,{$ifdef xboolean}true{$else}1{$endif});
 {$endif}
 errorhandlerbefore:= xseterrorhandler({$ifdef FPC}@{$endif}errorhandler);
 exit;
error:
 deinit;
end;

function gui_deinit: guierrorty;
begin
 clipboard:= '';
 result:= gue_ok;
 settimer1(0); //kill timer
 terminated:= true;
 freeclientevents;
{$ifdef with_sm}
 if hassm then begin
  with sminfo do begin
   if smconnection <> nil then begin
    if shutdown and shutdownpending then begin
     if interactwaiting and interactgranted then begin
      smcinteractdone(smconnection,0);
 {$ifdef smdebug}
      writeln('gui_deinit smcinteractdone');
 {$endif}
     end;
     smcsaveyourselfdone(smconnection,1);
 {$ifdef smdebug}
     writeln('gui_deinit saveyourselfdone');
 {$endif}
    end;
    iceremoveconnectionwatch({$ifdef FPC}@{$endif}icewatch,@sminfo);
 {$ifdef smdebug}
    writeln('gui_deinit iceremoveconnectionwatch');
 {$endif}
    smccloseconnection(sminfo.smconnection,0,nil);
 {$ifdef smdebug}
    writeln('gui_deinit smccloseconnection');
 {$endif}
    fillchar(sminfo,sizeof(sminfo),0);
   end;
  end;
 end;
{$endif}
{$ifdef with_saveyourself}
 if saveyourselfwindow <> 0 then begin
  setstringproperty(saveyourselfwindow,wmcommandatom,'');
 end;
{$endif}
 if appic <> nil then begin
  xdestroyic(appic);
  appic:= nil;
 end;
 if im <> nil then begin
  xcloseim(im);
  im:= nil;
 end;
 if appid <> 0 then begin
  xdestroywindow(appdisp,appid);
  appid:= 0;
 end;
 if screencursor <> 0 then begin
  xfreecursor(appdisp,screencursor);
  screencursor:= 0;
 end;
 if appdisp <> nil then begin
  if msecolormap <> 0 then begin
   xfreecolormap(appdisp,msecolormap);
   msecolormap:= 0;
  end;
  xclosedisplay(appdisp);
  appdisp:= nil;
 end;
 signal(sigalrm,sigtimerbefore);
 xseterrorhandler(errorhandlerbefore);
end;

const
 gdifunctions: gdifunctionaty = (
   {$ifdef FPC}@{$endif}gui_destroygc,
   {$ifdef FPC}@{$endif}gui_changegc,
   {$ifdef FPC}@{$endif}gui_drawlines,
   {$ifdef FPC}@{$endif}gui_drawlinesegments,
   {$ifdef FPC}@{$endif}gui_drawellipse,
   {$ifdef FPC}@{$endif}gui_drawarc,
   {$ifdef FPC}@{$endif}gui_fillrect,
   {$ifdef FPC}@{$endif}gui_fillelipse,
   {$ifdef FPC}@{$endif}gui_fillarc,
   {$ifdef FPC}@{$endif}gui_fillpolygon,
//   {$ifdef FPC}@{$endif}gui_drawstring,
   {$ifdef FPC}@{$endif}gui_drawstring16,
   {$ifdef FPC}@{$endif}gui_setcliporigin,
   {$ifdef FPC}@{$endif}gui_createemptyregion,
   {$ifdef FPC}@{$endif}gui_createrectregion,
   {$ifdef FPC}@{$endif}gui_createrectsregion,
   {$ifdef FPC}@{$endif}gui_destroyregion,
   {$ifdef FPC}@{$endif}gui_copyregion,
   {$ifdef FPC}@{$endif}gui_moveregion,
   {$ifdef FPC}@{$endif}gui_regionisempty,
   {$ifdef FPC}@{$endif}gui_regionclipbox,
   {$ifdef FPC}@{$endif}gui_regsubrect,
   {$ifdef FPC}@{$endif}gui_regsubregion,
   {$ifdef FPC}@{$endif}gui_regaddrect,
   {$ifdef FPC}@{$endif}gui_regaddregion,
   {$ifdef FPC}@{$endif}gui_regintersectrect,
   {$ifdef FPC}@{$endif}gui_regintersectregion,
   {$ifdef FPC}@{$endif}gui_copyarea,
   {$ifdef FPC}@{$endif}gui_fonthasglyph
 );
{
procedure gui_gdifunc(const func: gdifuncty; var drawinfo: drawinfoty);
begin
 gdifunctions[func](drawinfo);
end; 
}
function gui_getgdifuncs: pgdifunctionaty;
begin
 result:= @gdifunctions;
end;
 
var
 debugungrabbed: boolean;
 
procedure GUI_DEBUGBEGIN;
var
 int1: integer;
begin
 int1:= sys_getlasterror;
 if pointergrabbed then begin
  debugungrabbed:= true;
  gui_ungrabpointer;
 end;
 if appdisp <> nil then begin
  xflush(appdisp);
 end;
 sys_setlasterror(int1);
end;

procedure GUI_DEBUGEND;
var
 int1: integer;
begin
 if debugungrabbed then begin
  int1:= sys_getlasterror;
  gui_grabpointer(grabwinid);
  sys_setlasterror(int1);
  debugungrabbed:= false;
 end;
end;

initialization
 fhasxft:= getxftlib;
 hasxrender:= getxrenderlib;
 hassm:= geticelib and getsmlib;
 initdefaultfont;
end.


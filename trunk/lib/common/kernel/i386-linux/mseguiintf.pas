{ MSEgui Copyright (c) 1999-2011 by Martin Schreiber

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
 {$ifdef FPC}xlib{$else}Xlib{$endif},msetypes,mseapplication,
 msegraphutils,mseevent,msepointer,mseguiglob,msesys,{msestockobjects,}
 msethread{$ifdef FPC},x,xutil,dynlibs{$endif},
 mselibc,msectypes,msesysintf,msegraphics,
 msestrings,xft,xrender{$ifdef mse_debugwindowfocus},mseformatstr{$endif};

{$ifdef FPC}
{$define xbooleanresult}
{$ifndef VER2_3}{$ifndef VER2_4}{$ifndef VER2_5} 
 {$define xboolean} 
{$endif}{$endif}{$endif}
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
type
 syseventty = type txevent;
const
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

 XK_ISO_Lock =                    $FE01;
 XK_ISO_Level2_Latch =            $FE02;
 XK_ISO_Level3_Shift =            $FE03;
 XK_ISO_Level3_Latch =            $FE04;
 XK_ISO_Level3_Lock =             $FE05;
 XK_ISO_Level5_Shift =            $FE11;
 XK_ISO_Level5_Latch =            $FE12;
 XK_ISO_Level5_Lock =             $FE13;
 XK_ISO_Group_Shift =             $FF7E;
 XK_ISO_Group_Latch =             $FE06;
 XK_ISO_Group_Lock =              $FE07;
 XK_ISO_Next_Group =              $FE08;
 XK_ISO_Next_Group_Lock =         $FE09;
 XK_ISO_Prev_Group =              $FE0A;
 XK_ISO_Prev_Group_Lock =         $FE0B;
 XK_ISO_First_Group =             $FE0C;
 XK_ISO_First_Group_Lock =        $FE0D;
 XK_ISO_Last_Group =              $FE0E;
 XK_ISO_Last_Group_Lock =         $FE0F;

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

 {$ifdef FPC}
// threadslib = 'pthread';
 Xlibmodulename = 'X11';
 {$endif}
 sXlib = Xlibmodulename;
 pixel0 = $000000;
 pixel1 = $ffffff;
type
  Bool = integer;
  XID = type culong;
  TXICCEncodingStyle = (XStringStyle,XCompoundTextStyle,XTextStyle,
     XStdICCTextStyle,XUTF8StringStyle);
{$ifdef FPC}
 Colormap = TXID;
 Atom = type culong;
// Atom = type longword;
 Cursor = TXID;
 wchar_t = longword;
 pwchar_t = ^wchar_t;
 ppwchar_t = ^pwchar_t;
{$endif}
 patom = ^atom;
 atomarty = array of atom;
 atomaty = array[0..0] of atom;
 patomaty = ^atomaty;

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
  
 VisualID = culong;
 Visual = record
  ext_data: PXExtData;  { hook for extension to hang data  }
  visualid: VisualID;   { visual id of this visual  }
  _class: cint;
  red_mask: culong;
  green_mask: culong;
  blue_mask: culong;
  bits_per_rgb: cint;
  map_entries: cint;
 end;
 msepvisual = ^visual;

(* 
 VisualID = dword;
 Visual = record
   ext_data: PXExtData;  { hook for extension to hang data  }
   visualid: VisualID;   { visual id of this visual  }
   _class: Longint;
   red_mask: longword;
   green_mask: longword;
   blue_mask: longword;
   bits_per_rgb: Longint;
   map_entries: Longint;
 end;
 msepvisual = ^visual;
*)  
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
function XSetForeground(Display: PDisplay; GC: TGC; Foreground: longword): longint; cdecl;
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
function XCreateImage(Display: PDisplay; Visual: msePVisual; Depth: longword;
  Format: Longint; Offset: Longint; Data: PChar; Width, Height: longword;
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

implementation

uses
 msebits,msekeyboard,sysutils,msesysutils,msefileutils,msedatalist
 {$ifdef with_sm},sm,ice{$endif},msesonames,msegui,mseactions,msex11gdi
 {$ifdef mse_debug},mseformatstr{$endif};

 
var
 pixmapcount: integer;
 
type
 twindow1 = class(msegui.twindow);
 tguiapplication1 = class(tguiapplication);
 tcanvas1 = class(tcanvas);

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

 x11windowdty = record
  ic: xic;
 end;
 x11windowty = record
  case integer of
   0: (d: x11windowdty;);
   1: (_bufferspace: windowpty;);
 end;
 
const
 atombits = sizeof(atom)*8;
 mouseeventmask = buttonpressmask or buttonreleasemask or pointermotionmask;


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
 standardcursors: array[cursorshapety] of longword = (
      defaultshape,defaultshape,defaultshape,
      xc_left_ptr,{xc_tcross}xc_crosshair,xc_watch,xc_xterm,
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
 xlockerror: integer = 0; 
 appdisp: pdisplay;
 appid: winidty;
 defscreen: pscreen;
 defvisual: msepvisual;
 defdepth: integer;
 msecolormap: colormap;
 istruecolor: boolean;
 is8bitcolor: boolean;
 xredmask,xgreenmask,xbluemask: longword;
 xredshift,xgreenshift,xblueshift: integer;
 xredshiftleft,xgreenshiftleft,xblueshiftleft: boolean;
 defcolormap: colormap;
 hassm: boolean;
 toplevelraise: boolean;

 numlockstate: cuint;
 rootid: winidty;
 atomatom: atom;
 mseclientmessageatom,{timeratom,wakeupatom,}
 wmprotocolsatom,wmstateatom,wmnameatom,wmclassatom: atom;
 wmclientleaderatom: atom;
 wmprotocols: array[wmprotocolty] of atom;
 clipboardatom: atom;
 cardinalatom,windowatom,stringatom,utf8_stringatom,compound_textatom,
 textatom,textplainatom: atom;
 timestampatom: atom;
 multipleatom: atom;
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
      (net_supported,
       //suports checked below
       net_workarea,
       net_wm_state,
       net_wm_state_maximized_vert,net_wm_state_maximized_horz,
       //not needed below
       net_wm_window_type,
       net_wm_state_fullscreen,
       net_wm_state_skip_taskbar,
       net_restack_window,net_close_window,
       //not supports checked below
       net_wm_pid,
       net_wm_window_type_normal,
       net_wm_window_type_dialog,
       net_wm_window_type_dropdown_menu,
       net_frame_extents,
       net_request_frame_extents,
       net_system_tray_s0,net_system_tray_opcode,net_system_tray_message_data,
       xembed_info,
       net_none);
 netwmstateoperationty = (nso_remove,nso_add,nso_toggle);
const
 needednetatom = net_wm_state_maximized_horz;
 firstcheckedatom = net_workarea;
 lastcheckedatom = net_close_window;
 netatomnames: array[netatomty] of string = 
      ('_NET_SUPPORTED','_NET_WORKAREA',
       '_NET_WM_STATE',
       '_NET_WM_STATE_MAXIMIZED_VERT','_NET_WM_STATE_MAXIMIZED_HORZ',
       //not needed below
       '_NET_WM_WINDOW_TYPE',
       '_NET_WM_STATE_FULLSCREEN',
       '_NET_WM_STATE_SKIP_TASKBAR',
       '_NET_RESTACK_WINDOW','_NET_CLOSE_WINDOW',
       '_NET_WM_PID', 
       '_NET_WM_WINDOW_TYPE_NORMAL',
       '_NET_WM_WINDOW_TYPE_DIALOG',
       '_NET_WM_WINDOW_TYPE_DROPDOWN_MENU',
       '_NET_FRAME_EXTENTS', 
       '_NET_REQUEST_FRAME_EXTENTS',
       '_NET_SYSTEM_TRAY_S0','_NET_SYSTEM_TRAY_OPCODE',
       '_NET_SYSTEM_TRAY_MESSAGE_DATA',
       '_XEMBED_INFO',
       ''); 
// needednetatom = netatomty(ord(high(netatomty))-4);
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
// screencursor: cursor;
 im: xim;
 appic: xic;
 appicmask: longword;
// icwindow: windowty;
 imewinid: winidty;
 errorhandlerbefore: xerrorhandler;
 lasteventtime: ttime;
// lastshiftstate: shiftstatesty;
 clipboard: msestring;
 clipboardtimestamp: ttime; 
 fidnum: integer;

procedure usevariables;
begin
 if (multipleatom = 0) and (wmnameatom = 0) and (defcolormap = 0) then begin
 end;
end;

function getidnum: longword;
begin
 result:= interlockedincrement(fidnum);
 if result = 0 then begin
  result:= interlockedincrement(fidnum);
 end;
end;

function gui_sethighrestimer(const avalue: boolean): guierrorty;
begin
 result:= gue_ok; //dummy
end;

function gui_grouphideminimizedwindows: boolean;
begin
 result:= false;
end;
{
function hasxft: boolean;
begin
 result:= fhasxft;
end;
}
function gui_getdefaultfontnames: defaultfontnamesty;
begin
 result:= x11getdefaultfontnames;
end;

function gui_canstackunder: boolean;
begin
//{$ifdef mse_userestackwindow}
// result:= netatoms[net_restack_window] <> 0;
       //does not work, WM does not stack windows contiguous
//{$else}
 result:= false; //no solution found to restack windows in kde
//{$endif}
end;

function gui_copytoclipboard(const value: msestring): guierrorty;
begin
 gdi_lock;
 clipboard:= value;
 clipboardtimestamp:= lasteventtime;
 clipboardtimestamp:= clipboardtimestamp; //no "not used" compiler message
 xsetselectionowner(appdisp,clipboardatom,appid,lasteventtime);
 result:= gue_ok;
 gdi_unlock;
end;

function eventlater(const atime: ttime): boolean;
begin
 result:= (atime = currenttime) or (lasteventtime = currenttime) or
                           laterorsame(lasteventtime,atime);
end;

function gui_pastefromclipboard(out value: msestring): guierrorty;
const
 transferbuffersize = 1024 div 4; //1kb
var 
 clipboardowner: longword;
 value1: string;
 nitems1: integer;
 acttype: atom;
 actformat: cint;
  
 function getdata(const target: atom; const resulttarget: atom): guierrorty;
 var
  event: xevent;
  po1: pchar;
  nitems: culong;
  bytesafter: culong;
  charoffset: integer;
  longoffset: clong;
  time1: longword;
  int1: integer;
  bo1{,bo2}: boolean;
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
//     sys_threadschedyield;
     sys_schedyield;
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
        if actformat = 32 then begin
         actformat:= atombits;
        end;
        int1:= (actformat div 8) * nitems; //bytecount
        if nitems > 0 then begin
         inc(nitems1,nitems);
         setlength(value1,length(value1) + int1 );
         move(po1^,value1[charoffset],int1);
         inc(charoffset,int1);
         inc(longoffset,int1 div sizeof(dword));
//         inc(longoffset,int1 div sizeof(atom)); //32/64 bit
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
 end; //getdata

var
 int1,int2: integer; 
 po1: patomaty;
 atoms1: array[0..4] of atom;
 atom1: atom;
 po2: ppchar;
 prop1: xtextproperty;

begin
 gdi_lock;
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
    atoms1[3]:= textplainatom;
    atoms1[4]:= stringatom;
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
       if (acttype = textatom) or (acttype = textplainatom) then begin
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
 gdi_unlock;
end;

function gui_canpastefromclipboard: boolean;
begin
 gdi_lock;
 result:= xgetselectionowner(appdisp,clipboardatom) <> none;
 gdi_unlock;
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
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
 xchangeproperty(appdisp,id,prop,stringatom,8,propmodereplace,pbyte(pchar(value)),length(value)+1);
end;

procedure setwinidproperty(id: winidty; prop: atom; value: winidty);
begin
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
 xchangeproperty(appdisp,id,prop,windowatom,32,propmodereplace,@value,1);
end;

procedure setlongproperty(id: winidty; prop: atom; value: culong); overload;
begin
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
 xchangeproperty(appdisp,id,prop,cardinalatom,32,propmodereplace,@value,1);
end;

procedure setlongproperty(id: winidty; prop: atom;
                            const value: array of culong); overload;
begin
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
 xchangeproperty(appdisp,id,prop,cardinalatom,32,propmodereplace,@value,
                                                length(value));
end;

procedure setatomproperty(id: winidty; prop: atom; value: atom);
begin
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
 xchangeproperty(appdisp,id,prop,atomatom,32,propmodereplace,@value,1);
end;

function readcardinalproperty(id: winidty; name: atom; count: longword;
                                    var value): boolean;
var
 actualtype: atom;
 actualformat: cint;
 nitems: clong;
 bytesafter: culong;
 prop: pchar;
 {$ifdef CPU64}
 int1: integer;
 po1: pculong;
 po2: plongword;
 {$endif}
begin
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
 result:= false;
 if xgetwindowproperty(appdisp,id,name,0,count,{$ifdef xboolean}false{$else}0{$endif},
        anypropertytype,@actualtype,@actualformat,@nitems,@bytesafter,@prop) = success then begin
  if (nitems = count) and (actualformat = 32) then begin
{$ifdef CPU64}
   po1:= pointer(prop);
   po2:= @value;
   for int1:= count-1 downto 0 do begin
    po2^:= po1^;
    inc(po1);
    inc(po2);
   end;
{$else}
 {$ifdef FPC} {$checkpointer off} {$endif}
   move(prop^,value,nitems*sizeof(longword));
 {$ifdef FPC} {$checkpointer default} {$endif}
{$endif}
   result:= true;
  end;
  xfree(prop);
 end;
end;

function readcardinallistproperty(const id: winidty; const name: atom;
                out value: longwordarty): boolean;
var
 actualtype: atom;
 actualformat: cint;
 nitems: clong;
 bytesafter: culong;
 prop: pchar;
 {$ifdef CPU64}
 int1: integer;
 po1: pculong;
 po2: plongword;
 {$endif}
begin
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
 result:= false;
 if xgetwindowproperty(appdisp,id,name,0,bigint,{$ifdef xboolean}false{$else}0{$endif},
        anypropertytype,@actualtype,@actualformat,
                        @nitems,@bytesafter,@prop) = success then begin
  if actualformat = 32 then begin
   setlength(value,nitems);
{$ifdef CPU64}
   po1:= pointer(prop);
   po2:= pointer(value);
   for int1:= nitems-1 downto 0 do begin
    po2^:= po1^;
    inc(po1);
    inc(po2);
   end;
{$else}
 {$ifdef FPC} {$checkpointer off} {$endif}
   move(prop^,value,nitems*sizeof(value[0]));
 {$ifdef FPC} {$checkpointer default} {$endif}
   result:= true;
{$endif}
  end;
  xfree(prop);
 end;
end;

function readatomproperty(id: winidty; name: atom; var value: atomarty): boolean;
var
 actualtype: atom;
 actualformat: cint;
 nitems: clong;
 bytesafter: culong;
 prop: pchar;
begin
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
 result:= false;
 if xgetwindowproperty(appdisp,id,name,0,10000,{$ifdef xboolean}false{$else}0{$endif},
   atomatom,@actualtype,@actualformat,@nitems,@bytesafter,@prop) = success then begin
  if (actualtype = atomatom) and (actualformat = 32) then begin
   setlength(value,nitems);
   if nitems > 0 then begin
 {$ifdef FPC} {$checkpointer off} {$endif}
    move(prop^,value[0],nitems*sizeof(value[0]));
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
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
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
 format: cint;
 itemcount: culong;
 po1: pwmstatety;
 bytesafterreturn: culong;

begin
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
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
 x,y: cint;
 width,height,border,depth: cuint;
begin
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
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
 gdi_lock;
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
 gdi_unlock;
end;

function changenetwmstate(id: winidty; const operation: netwmstateoperationty;
         const value1: netatomty; const value2: netatomty = net_none): boolean;
var
 xevent: xclientmessageevent;
begin
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
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

function sendnetcardinalmessage(const adest: winidty; const messagetype: atom;
         const aid: winidty; const adata: array of longword;
         const amask: longword = noeventmask): boolean;
                  //true if ok
var
 xevent: xclientmessageevent;
 int1: integer;
begin
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
 result:= netsupported and (messagetype <> 0);
 if result then begin
  fillchar(xevent,sizeof(xevent),0);
  with xevent do begin
   xtype:= clientmessage;
   display:= appdisp;
   xwindow:= aid;
   format:= 32;
   message_type:= messagetype;
   for int1:= 0 to high(adata) do begin
    data.l[int1]:= adata[int1];
   end;
   result:= xsendevent(appdisp,adest,
           {$ifdef xboolean}false{$else}0{$endif},amask,@xevent) <> 0;
  end;
 end;
end;

function sendnetrootcardinalmessage(const messagetype: atom;
         const aid: winidty; const adata: array of longword): boolean;
                  //true if ok
begin
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
 result:= sendnetcardinalmessage(rootid,messagetype,aid,adata,
               substructurenotifymask or substructureredirectmask);
end;

function waitfordecoration(id: winidty; raiseexception: boolean = true): boolean;
var
 int1: integer;
begin
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
 int1:= 0;
 result:= false;
 repeat
  xsync(appdisp,false);    //windowmanager has to work
//  xflush(appdisp);    //windowmanager has to work
  sys_schedyield;
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
  if size = wsi_fullscreenvirt then begin
   gui_reposwindow(id,gui_getscreenrect(0));
  end
  else begin
   gui_reposwindow(id,gui_getscreenrect(id));
  end
 end;

begin
 gdi_lock;
 result:= gue_ok;
 if visible then begin
  xmapwindow(appdisp,id);
 end;
 if size in [wsi_fullscreen,wsi_fullscreenvirt] then begin
  if not canfullscreen or not changenetwmstate(id,nso_add,net_wm_state_fullscreen) then begin
   fullscreen; //no windowmanager
  end;
 end
 else begin
  changenetwmstate(id,nso_remove,net_wm_state_fullscreen);
  case size of
   wsi_minimized: begin
    if xiconifywindow(appdisp,id,0) = 0 then begin
     result:= gue_show;
    end;
    gdi_unlock;
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
 gdi_unlock;
end;

procedure freetextproperty(const value: xtextproperty);
begin
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
 xfree(value.value);
end;

function gui_setwindowcaption(id: winidty; const caption: msestring): guierrorty;
var
 textprop: xtextproperty;
begin
 gdi_lock;
 if stringtotextproperty(caption,xstdicctextstyle,textprop) then begin
  xsetwmname(appdisp,id,@textprop);
  freetextproperty(textprop);
  result:= gue_ok;
 end
 else begin
  result:= gue_characterencoding;
 end;
 gdi_unlock;
end;

function gui_setwindowicon(id: winidty; const icon,mask: pixmapty): guierrorty;
var
 hints: pxwmhints;
begin
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
{$ifdef FPC}{$checkpointer off}{$endif}
 hints:= pxwmhints(xgetwmhints(appdisp,id));
 if hints = nil then begin
  hints:= pxwmhints(xallocwmhints);
 end;
 with hints^ do begin
  icon_pixmap:= icon;
  icon_mask:= mask;
  updatebit(longword(flags),2,icon <> 0); //iconpixmaphint
  updatebit(longword(flags),5,mask <> 0); //iconmaskhint
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

function gui_pidtowinid(const pids: procidarty): winidty;

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
  ca1: longword;
  children: pwindow;
  int1: integer;
//  id1: winidty;
  ar1: atomarty;
 begin
  result:= false;
  if (gui_windowvisible(aparent) or (getwmstate(aparent) = wms_iconic)) and
   readcardinalproperty(aparent,netatoms[net_wm_pid],1,int1) and checkpid(int1) then begin
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
 gdi_lock;
 result:= 0;
 level:= 0;
 if (netatoms[net_wm_pid] <> 0) then begin
  scanchildren(mserootwindow);
 end;
 gdi_unlock;
end;

function XDestroyImage(Image: PXImage): Longint;
begin
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
{$ifdef FPC} {$checkpointer off} {$endif}
  Result := Image^.f.destroy_image(Image);
{$ifdef FPC} {$checkpointer default} {$endif}
end;

function getwindowstack(const id: winidty): winidarty;
var
 parent,root: winidty;
 ca1: longword;
 children: pwindow;
 count: integer;
begin
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
 result:= nil;
 count:= 0;
 additem(result,id,count);
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
  additem(result,parent,count);
 until (parent = root);
 setlength(result,count);
end;

function toplevelwindow(const id: winidty): winidty;
var
 ar1: winidarty;
begin
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
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
 ca1: longword;
 children: pwindow;

begin
 gdi_lock;
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
      if integer(ar1[int3][high(ar1[int3])-int2]) = pwinidaty(children)^[int1] then begin
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
 gdi_unlock;
end;

function gui_raisewindow(id: winidty): guierrorty;
begin
 gdi_lock;
 if toplevelraise then begin
//  waitfordecoration(id);
  xraisewindow(appdisp,toplevelwindow(id));
 end
 else begin
  xraisewindow(appdisp,id);
 end;
 result:= gue_ok;
 gdi_unlock;
end;

function gui_lowerwindow(id: winidty): guierrorty;
begin
 gdi_lock;
 xlowerwindow(appdisp,id);
 result:= gue_ok;
 gdi_unlock;
end;

function stackwindow(id: winidty; predecessor: winidty;
                                   stackmode: integer): guierrorty;
var
// changes: xwindowchanges;
 ar1: winidarty;
 int1: integer;
 idindex,pindex: integer;
 topid,toppred: winidty;
 winar1: array[0..1] of winidty;
begin
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
 if predecessor = 0 then begin
  result:= gui_raisewindow(id);
 end
 else begin
  if id <> predecessor then begin
   if gui_canstackunder then begin
    if netatoms[net_restack_window] <> 0 then begin
     sendnetrootcardinalmessage(netatoms[net_restack_window],id,
                                     [1,predecessor,stackmode]);
    end
    else begin
     topid:= toplevelwindow(id);
     toppred:= toplevelwindow(predecessor);
     if stackmode = above then begin
      winar1[0]:= topid;
      winar1[1]:= toppred;
     end
     else begin
      winar1[0]:= toppred;
      winar1[1]:= topid;
     end;
     xrestackwindows(appdisp,@winar1,2);
    end;

   {
    changes.sibling:= toplevelwindow(predecessor);
    changes.stack_mode:= stackmode;
    xconfigurewindow(appdisp,toplevelwindow(id),cwsibling or cwstackmode,@changes);
   }
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
      deleteitem(ar1,idindex);
      if idindex < pindex then begin
       dec(pindex);
      end;
      if stackmode = above then begin
       insertitem(ar1,pindex+1,id);
      end
      else begin
       insertitem(ar1,pindex,id);
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
 gdi_lock;
 result:= stackwindow(id,predecessor,below);
 gdi_unlock;
end;

function gui_stackoverwindow(id: winidty; predecessor: winidty): guierrorty;
begin
 gdi_lock;
 result:= stackwindow(id,predecessor,above);
 gdi_unlock;
end;

function gui_getscreenrect(const id: winidty): rectty; //0 -> virtual screen
begin
 gdi_lock;
 result.pos:= nullpoint; //todo: multimonitor
{$ifdef FPC} {$checkpointer off} {$endif}
 result.cx:= defscreen^.width;
 result.cy:= defscreen^ .height;
{$ifdef FPC} {$checkpointer default} {$endif}
 gdi_unlock;
end;

function gui_getworkarea(id: winidty): rectty;
var
 bo1: boolean;
begin
 gdi_lock;
 bo1:= false;
 if netsupported then begin
  bo1:= readcardinalproperty(mserootwindow(id),netatoms[net_workarea],4,result);
 end;
 if not bo1 then begin
  result:= gui_getscreenrect(id);
 end;
 gdi_unlock;
end;

function getwindowframe(id: winidty): framety;
var
 bo1: boolean;
 ar1: array[0..3] of integer;
// win1: winidty;
// root: winidty;
 rect1,rect2: rectty;
// int1: integer;
// pt1: pointty;
begin
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
 bo1:= false;
 if canframeextents then begin
  bo1:= readcardinalproperty(id,netatoms[net_frame_extents],4,ar1);
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
 ca1: longword;
begin
 gdi_lock;
 xquerypointer(appdisp,rootid,@ca1,@ca1,@result.x,@result.y,@ca1,@ca1,@ca1);
 gdi_unlock;
end;

function gui_setpointerpos(const pos: pointty): guierrorty;
begin
 gdi_lock;
 xwarppointer(appdisp,none,rootid,0,0,0,0,pos.x,pos.y);
 result:= gue_ok;
 gdi_unlock;
end;

function gui_movepointer(const dist: pointty): guierrorty;
begin
 gdi_lock;
 xwarppointer(appdisp,rootid,none,0,0,0,0,dist.x,dist.y);
 result:= gue_ok;
 gdi_unlock;
end;

var
 pointergrabbed: boolean;
 grabwinid: winidty;
 
function gui_grabpointer(id: winidty): guierrorty;
begin
 gdi_lock;
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
 gdi_unlock;
end;

function gui_ungrabpointer: guierrorty;
begin
 gdi_lock;
 xungrabpointer(appdisp,currenttime);
 result:= gue_ok;
 pointergrabbed:= false; 
 gdi_unlock;
end;

function gui_allocimagemem(length: integer): plongwordaty;
begin
 if length = 0 then begin
  result:= nil;
 end
 else begin
  getmem(result,length * sizeof(longword));
 end;
end;

procedure gui_freeimagemem(data: plongwordaty);
begin
 freemem(data);
end;

function gui_pixmaptoimage(pixmap: pixmapty; out image: imagety;
                                      gchandle: longword): gdierrorty;
var
 info: pixmapinfoty;
 ximage1: pximage;
 po1: plongword;
 po2: pbyte;
 int1,int2: integer;
 wordmax: integer;
begin
 gdi_lock;
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
    gdi_unlock;
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
    gdi_unlock;
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
 gdi_unlock;
end;

function gui_imagetopixmap(const image: imagety; out pixmap: pixmapty;
                         gchandle: longword): gdierrorty;
var
 ximage: pximage;
 po1: prgbtriplety;
 po2: pchar;
 gc: tgc;
 int1,int2: integer;
begin
 gdi_lock;
 result:= gde_ok;
 po2:= nil;
 if image.monochrome then begin
  ximage:= XCreateImage(appdisp,nil,1,xypixmap,0,nil,
                                 image.size.cx,image.size.cy,32,0);
  if ximage = nil then begin
   result:= gde_image;
   gdi_unlock;
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
   gdi_unlock;
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
     f.put_pixel(ximage,int2,int1,gui_rgbtopixel(longword(po1^)));
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
 gdi_unlock;
end;

function gui_createpixmap(const size: sizety; winid: winidty = 0;
                          monochrome: boolean = false; copyfrom: pixmapty = 0): pixmapty;
var
 gc: tgc;
begin
 gdi_lock;
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
 gdi_unlock;
end;

function gui_freepixmap(pixmap: pixmapty): gdierrorty;
begin
 gdi_lock;
 dec(pixmapcount);
 if xfreepixmap(appdisp,pixmap) <> success then begin
  result:= gde_pixmap;
 end
 else begin
  result:= gde_ok;
 end;
 gdi_unlock;
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
 gdi_lock;
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
 gdi_unlock;
end;

function gui_getpixmapinfo(var info: pixmapinfoty): gdierrorty;
var
 ca1: longword;
begin
 gdi_lock;
 with info do begin
  if xgetgeometry(appdisp,handle,@ca1,@ca1,@ca1,@size.cx,@size.cy,@ca1,@depth) = 0 then begin
   result:= gde_pixmap;
  end
  else begin
   result:= gde_ok;
  end;
 end;
 gdi_unlock;
end;

function gui_windowvisible(id: winidty): boolean;
var
 attributes: xwindowattributes;
begin
 gdi_lock;
 xgetwindowattributes(appdisp,id,@attributes);
 result:= attributes.map_state = isviewable;
 gdi_unlock;
end;

function hasoverrideredirect(const id: winidty): boolean;
var
 attributes: xwindowattributes;
begin
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
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
 gdi_lock;
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
 gdi_unlock;
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
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
 result:= appic;
 {$ifdef FPC}
 if application.findwindow(awindow,twindow(window1)) then begin
 {$else}
 if application.findwindow(awindow,twindow(window1)) then begin
 {$endif}
  with x11windowty(window1.fwindow.platformdata).d do begin
   if ic <> nil then begin
    result:= ic;
   end;
  end;
 end;
end;

function gui_setwindowfocus(id: winidty): guierrorty;
begin
 gdi_lock;
{$ifdef mse_debugwindowfocus}
 debugwriteln('gui_setwindowfocus '+hextostr(id,8));
{$endif}

// xseticfocus(getic(id));
 waitfordecoration(id);
 xsetinputfocus(appdisp,id,reverttoparent,currenttime);
// xflush(appdisp);
 result:= gue_ok;
 gdi_unlock;
end;

function gui_setimefocus(var awindow: windowty): guierrorty;
begin
 gdi_lock;
 result:= gue_ok;
 with awindow,x11windowty(platformdata).d do begin
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
 gdi_unlock;
end;

procedure unsetime(const awindow: winidty);
begin
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
 if awindow = imewinid then begin
  xunseticfocus(appic);
  xseticvalues(appic,pchar(xnfocuswindow),appid,nil);
  imewinid:= 0;
 end;
end;

function gui_unsetimefocus(var awindow: windowty): guierrorty;
begin
 gdi_lock;
 result:= gue_ok;
 with x11windowty(awindow.platformdata).d do begin
  if ic <> nil then begin
   xunseticfocus(ic);
  end
  else begin
   unsetime(awindow.id);
  end;
 end;
 gdi_unlock;
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
var
 cursor1: cursor;
 bmp: pixmapty;
 color: txcolor;
begin 
 result:= gue_ok;
 if winid = 0 then begin
  exit; //do not modify root window cursor
 end;
 gdi_lock;
 if shape = cr_none then begin
  fillchar(color,sizeof(color),0);
  bmp:= xcreatebitmapfromdata(appdisp,winid,@color,1,1); //dummy data
  cursor1:= xcreatepixmapcursor(appdisp,bmp,bmp,@color,@color,0,0);
  xfreepixmap(appdisp,bmp);
 end
 else begin
  cursor1:= xcreatefontcursor(appdisp,standardcursors[shape]);
 end;
 if cursor1 <> 0 then begin
  xdefinecursor(appdisp,winid,cursor1);
  xflush(appdisp);
  xfreecursor(appdisp,cursor1);
 end
 else begin
  result:= gue_cursor;
 end;
 gdi_unlock;
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

function getclientpointer(const event: xclientmessageevent): pointer;
begin
 with event do begin
 {$ifdef CPU64}
  result:= pointer((data.l[0] and $ffffffff) + ((data.l[1] and $ffffffff) shl 32));
 {$else}
  result:= pointer(data.l[0]);
 {$endif}
 end;
end;

procedure setclientpointer(const ptr: pointer; out event: xclientmessageevent);
begin
 fillchar(event,sizeof(event),0);
 with event do begin
  xtype:= clientmessage;
  format:= 32;
  message_type:= mseclientmessageatom;
 {$ifdef CPU64}
  data.l[0]:= ptruint(ptr) and $ffffffff;
  data.l[1]:= (ptruint(ptr) shr 32) and $ffffffff;
 {$else}
  data.l[0]:= ptruint(ptr);
 {$endif}
 end;
end;

function gui_postevent(event: tmseevent): guierrorty;
var
 xevent1: xclientmessageevent;
begin
 gdi_lock;
 setclientpointer(event,xevent1);
 if xsendevent(appdisp,appid,{$ifdef xboolean}false{$else}0{$endif},0,
                                                   @xevent1) = 0 then begin
  result:= gue_postevent;
 end
 else begin
  xflush(appdisp);
  result:= gue_ok;
 end;
 gdi_unlock;
end;

function settimer1(us: longword): guierrorty;
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

function gui_settimer(us: longword): guierrorty;
begin
 if us = 0 then begin
  us:= 1;
 end;
 result:= settimer1(us);
end;

function gui_rgbtopixel(rgb: longword): pixelty;
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
function gui_rgbtocolormappixel(rgb: longword): pixelty;
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
function gui_pixeltorgb(pixel: longword): longword;
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

function xtomousebutton(button: longword): mousebuttonty;
begin
 case button of
  button1: result:= mb_left;
  button2: result:= mb_middle;
  button3: result:= mb_right;
  else result:= mb_none;
 end;
end;

function xtoshiftstate(const shiftstate: longword;
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

//var
// messcount: integer;

procedure freeclientevents;
var
 xev: xevent;
begin
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
 while xpending(appdisp) > 0 do begin
  xnextevent(appdisp,@xev);
  with xev.xclient do begin
   if (xtype = clientmessage) and (display = appdisp) and
           (message_type = mseclientmessageatom) then begin
    tmseevent(getclientpointer(xev.xclient)).free1;
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

function xkeytokey(key: keysym; var shiftstate: shiftstatesty): keyty;
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

   xk_kp_space: begin
    result:= key_space;
    include(shiftstate,ss_second);
   end;
   xk_kp_tab: begin
    result:= key_tab;
    include(shiftstate,ss_second);
   end;
   xk_kp_enter: begin
    result:= key_return;
    include(shiftstate,ss_second);
   end;
   xk_kp_f1: begin
    result:= key_f1;
    include(shiftstate,ss_second);
   end;
   xk_kp_f2: begin
    result:= key_f2;
    include(shiftstate,ss_second);
   end;
   xk_kp_f3: begin
    result:= key_f3;
    include(shiftstate,ss_second);
   end;
   xk_kp_f4: begin
    result:= key_f4;
    include(shiftstate,ss_second);
   end;
   xk_kp_home: begin
    result:= key_home;
    include(shiftstate,ss_second);
   end;
   xk_kp_left: begin
    result:= key_left;
    include(shiftstate,ss_second);
   end;
   xk_kp_up: begin
    result:= key_up;
    include(shiftstate,ss_second);
   end;
   xk_kp_right: begin
    result:= key_right;
    include(shiftstate,ss_second);
   end;
   xk_kp_down: begin
    result:= key_down;
    include(shiftstate,ss_second);
   end;
//   xk_kp_prior: result:= key_prior;
   xk_kp_page_up: begin
    result:= key_pageup;
    include(shiftstate,ss_second);
   end;
//   xk_kp_next: result:= key_next;
   xk_kp_page_down: begin
    result:= key_pagedown;
    include(shiftstate,ss_second);
   end;
   xk_kp_end: begin
    result:= key_end;
    include(shiftstate,ss_second);
   end;
//   xk_kp_begin: result:= key_begin;
   xk_kp_insert: begin
    result:= key_insert;
    include(shiftstate,ss_second);
   end;
   xk_kp_delete: begin
    result:= key_delete;
    include(shiftstate,ss_second);
   end;
   xk_kp_equal: begin
    result:= key_equal;
    include(shiftstate,ss_second);
   end;
   xk_kp_multiply: begin
    result:= key_asterisk;
    include(shiftstate,ss_second);
   end;
   xk_kp_add: begin
    result:= key_plus;
    include(shiftstate,ss_second);
   end;
   xk_kp_separator: begin
    result:= key_comma;
    include(shiftstate,ss_second);
   end;
   xk_kp_subtract: begin
    result:= key_minus;
    include(shiftstate,ss_second);
   end;
   xk_kp_decimal: begin
    result:= key_decimal;
    include(shiftstate,ss_second);
   end;
   xk_kp_divide: begin
    result:= key_slash;
    include(shiftstate,ss_second);
   end;
   xk_kp_0..xk_kp_9: begin
    result:= keyty(longword(key_0) + key - xk_kp_0);
    include(shiftstate,ss_second);
   end;

   xk_f1..xk_f35: result:= keyty(longword(key_f1) + key - xk_f1);

   xk_shift_l: result:= key_shift;
   xk_shift_r: begin
    result:= key_shift;
    include(shiftstate,ss_second);
   end;
   xk_control_l: result:= key_control;
   xk_control_r: begin
    result:= key_control;
    include(shiftstate,ss_second);
   end;
   xk_caps_lock: result:= key_capslock;
//   xk_shift_lock: result:= key_shift_lock;

   xk_meta_l: result:= key_meta;
   xk_meta_r: begin
    result:= key_meta;
    include(shiftstate,ss_second);
   end;
   xk_alt_l: result:= key_alt;
   xk_alt_r: begin
    result:= key_alt;
    include(shiftstate,ss_second);
   end;
   xk_super_l: result:= key_super;
   xk_super_r: begin
    result:= key_super;
    include(shiftstate,ss_second);
   end;
   xk_hyper_l: result:= key_hyper;
   xk_hyper_r: begin
    result:= key_hyper;
    include(shiftstate,ss_second);
   end;

   xk_iso_level3_shift: begin
    result:= key_altgr;
   end;

   else result:= keyty(key and not modmask);
  end;
 end;
end;

function pchartomsestring(value: pchar; len: integer): msestring;
var
 int1: integer;
 buffer: longwordarty;
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

function ucs4stringtomsestring(const source: longwordarty): msestring;
var
 int1: integer;
begin
 setlength(result,length(source));
 for int1:= 0 to length(source)-1 do begin
  result[int1+1]:= msechar(source[int1]);
 end;
end;

function getrootpath(id: winidty; out rootpath: longwordarty): boolean;
var
 root,parent: winidty;//{$ifdef FPC}dword{$else}xlib.twindow{$endif};
 children: pwindow;
 count: integer;
 ca1: longword;

begin
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
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

function gui_getchildren(const id: winidty; out children: winidarty): guierrorty;
var
 root,parent: winidty;//{$ifdef FPC}dword{$else}xlib.twindow{$endif};
 chi: pwindow;
// count: integer;
 ca1: longword;
 int1: integer;
begin
 gdi_lock;
 result:= gue_getchildren;
 children:= nil;
 if xquerytree(appdisp,id,@root,@parent,@chi,@ca1) = 0 then begin
  gdi_unlock;
  exit;
 end;
 if chi <> nil then begin
  setlength(children,ca1);
  for int1:= 0 to high(children) do begin
   children[int1]:= chi[int1];
  end;
  xfree(chi);
 end;
 result:= gue_ok;
 gdi_unlock;
end;

function getrootoffset(const id: winidty; out offset: pointty): boolean;
var
 int1: integer;
 rootpath: longwordarty;
 ax,ay: integer;
 width,height,border: longword;
 ca1: longword;
begin
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
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
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
 if transientfor = 0 then begin
  xsettransientforhint(appdisp,id,mserootwindow);
 end
 else begin
  xsettransientforhint(appdisp,id,transientfor);
 end;
 result:= gue_ok;
end;

function gui_settransientfor(var awindow: windowty;
                                     const transientfor: winidty): guierrorty;
var
 attributes: xwindowattributes;
begin
 gdi_lock;
 result:= settransientforhint(awindow.id,transientfor);
 if result = gue_ok then begin
  if xgetwindowattributes(appdisp,awindow.id,@attributes) <> 0 then begin
   if attributes.override_redirect{$ifndef xboolean} <> 0 {$endif}then begin
    gui_stackunderwindow(transientfor,awindow.id);
   end;
  end;
 end;
 gdi_unlock;
end;

function gui_windowatpos(const pos: pointty): winidty;
var
 int1: integer;
 id: winidty;
begin
 gdi_lock;
 id:= mserootwindow;
 repeat
  result:= id;
  if longint(xtranslatecoordinates(appdisp,mserootwindow,result,
         pos.x,pos.y,@int1,@int1,@id)) = 0 then begin
   result:= 0;
   gdi_unlock;
   exit;
  end;
 until id = none;
 gdi_unlock;
end;

function gui_setwindowgroup(id,group: winidty): guierrorty;
var
 wmhints: pxwmhints;
begin
 gdi_lock;
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
 gdi_unlock;
end;

function setnetcardinal(const id: winidty; const aproperty: netatomty;
                                         const avalue: longword): boolean;
begin
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
 result:= false;
 if netatoms[aproperty] <> 0 then begin
  setlongproperty(id,netatoms[aproperty],avalue);
  result:= true;
 end;
end;

function setnetatom(const id: winidty; const aproperty: netatomty;
                                         const avalue: netatomty): boolean;
begin
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
 result:= false;
 if (netatoms[aproperty] <> 0) and (netatoms[avalue] <> 0) then begin
  setatomproperty(id,netatoms[aproperty],netatoms[avalue]);
  result:= true;
 end;
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
 gdi_lock;
 with awindow,x11windowty(platformdata).d do begin
  valuemask:= 0;
  if wo_popup in options.options then begin
   attributes.override_redirect:= {$ifdef xboolean}true{$else}1{$endif};
   valuemask:= valuemask or cwoverrideredirect;
  end;
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
   gdi_unlock;
   exit;
  end;
  result:= gue_ok;
  if options.parent <> 0 then begin //embedded window
   xselectinput(appdisp,id,exposuremask); //will be mapped to parent
   gdi_unlock;
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
  setnetcardinal(id,net_wm_pid,getpid);
  if (wo_popup in options.options) and (options.transientfor <> 0) then begin
   gui_raisewindow(options.transientfor);
     //transientforhint not used by overrideredirect
  end;
  if (wo_popup in options.options) then begin
   setnetatom(id,net_wm_window_type,net_wm_window_type_dropdown_menu);
   gui_raisewindow(id);
  end
  else begin
   if wo_message in options.options then begin
    setnetatom(id,net_wm_window_type,net_wm_window_type_dialog);
   end
   else begin
    setnetatom(id,net_wm_window_type,net_wm_window_type_normal);
   end;
   if wo_notaskbar in options.options then begin
    setnetatom(id,net_wm_state,net_wm_state_skip_taskbar);
   end;
  end;
 end;
 gdi_unlock;
end;

function gui_destroywindow(var awindow: windowty): guierrorty;
begin
 gdi_lock;
 with awindow,x11windowty(platformdata).d do begin
  if ic <> nil then begin
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
 gdi_unlock;
end;

function getwindowrect(id: winidty; out rect: rectty; out origin: pointty): guierrorty;
var
 int1: integer;
begin
 result:= gue_error;
 with rect do begin
  if (xgetgeometry(appdisp,id,@int1,@x,@y,@cx,@cy,@int1,@int1) <> 0) and
                 getrootoffset(id,origin) then begin
   result:= gue_ok;
  end;
 end;
end;

function gui_getwindowrect(id: winidty; out rect: rectty): guierrorty;
var
// int1: integer;
 po1: pointty;
begin
 gdi_lock;
 result:= getwindowrect(id,rect,po1);
 if result = gue_ok then begin
  addpoint1(rect.pos,po1);
 end;
 gdi_unlock;
end;

function gui_getwindowpos(id: winidty; out pos: pointty): guierrorty;
var
 int1: integer;
// po1: pointty;
begin
 gdi_lock;
 result:= gue_error;
 with pos do begin
  if xgetgeometry(appdisp,id,@int1,@x,@y,@int1,@int1,@int1,@int1) <> 0 then begin
   result:= gue_ok;
  end;
 end;
 gdi_unlock;
end;

function gui_reposwindow(id: winidty; const rect: rectty): guierrorty;
var
 changes: xwindowchanges;
 sizehints: pxsizehints;
 int1: clong;
begin
 gdi_lock;
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
 gdi_unlock;
end;

function gui_getdecoratedwindowrect(id: winidty; out arect: rectty): guierrorty;
//var
// frame1: framety;
begin
 gdi_lock;
 result:= gui_getwindowrect(id,arect);
 if result = gue_ok then begin
  inflaterect1(arect,getwindowframe(id))
 end;
 gdi_unlock;
end;

function gui_setdecoratedwindowrect(id: winidty; const rect: rectty; 
                                    out clientrect: rectty): guierrorty;
var
 frame1: framety;
begin
 gdi_lock;
 frame1:= getwindowframe(id);
 with clientrect,frame1 do begin
  x:= rect.x + left;
  cx:= rect.cx - left - right;
  y:= rect.y + top;
  cy:= rect.cy - top - bottom;
 end;
 result:= gui_reposwindow(id,clientrect);
 gdi_unlock;
end;

function gui_setembeddedwindowrect(id: winidty; const rect: rectty): guierrorty;
begin
 result:= gui_reposwindow(id,rect);
end;

function gui_setsizeconstraints(id: winidty; const min,max: sizety): guierrorty;
var
 sizehints: pxsizehints;
 int1: clong;
begin
 gdi_lock;
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
 gdi_unlock;
end;

function gui_hidewindow(id: winidty): guierrorty;
begin
 gdi_lock;
 unsetime(id);
 xunmapwindow(appdisp,id);
 result:= gue_ok;
 gdi_unlock;
end;

function gui_getparentwindow(const awindow: winidty): winidty;
var
 root,parent: winidty;//{$ifdef FPC}dword{$else}xlib.twindow{$endif};
 children: pwindow;
// count: integer;
 ca1: longword;
begin
 gdi_lock;
 result:= 0;
 if xquerytree(appdisp,awindow,@root,@parent,@children,@ca1) = 0 then begin
  gdi_unlock;
  exit;
 end;
 if children <> nil then begin
  xfree(children);
 end;
 result:= parent;
 gdi_unlock;
end;

function gui_reparentwindow(const child: winidty; const parent: winidty;
                            const pos: pointty): guierrorty;
var
 wi1: winidty;
begin
 gdi_lock;
 result:= gue_ok;
 wi1:= parent;
 if wi1 = 0 then begin
  wi1:= rootid;
 end;
 xsync(appdisp,false);
 xreparentwindow(appdisp,child,wi1,pos.x,pos.y);
 xsync(appdisp,false);
 gdi_unlock;
end;

function getsyswin(const akind: syswindowty): winidty;
var
 at1: atom;
begin
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
 result:= 0;
 case akind of
  sywi_tray: begin
   at1:= netatoms[net_system_tray_s0];
   if at1 <> 0 then begin
    result:= xgetselectionowner(appdisp,at1);
   end;
  end;
 end;
end;

const
 xembedversion = 0;
 xembedflags = 0;

procedure initxembed(const id: winidty);
begin
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
 setlongproperty(id,netatoms[xembed_info],[xembedversion,xembedflags]);
end;

procedure finalizexembed(const id: winidty);
begin
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
 xdeleteproperty(appdisp,id,netatoms[xembed_info]);
end;

function gui_showsysdock(var awindow: windowty): guierrorty;
begin
 gdi_lock;
 setlongproperty(awindow.id,netatoms[xembed_info],[xembedversion,xembedflags or 1]);
 result:= gue_ok;
 gdi_unlock;
end;

function gui_hidesysdock(var awindow: windowty): guierrorty;
begin
 gdi_lock;
 setlongproperty(awindow.id,netatoms[xembed_info],[xembedversion,xembedflags]);
 result:= gui_hidewindow(awindow.id);
 gdi_unlock;
end;


const
 system_tray_request_dock = 0;
 system_tray_begin_message = 1;
 system_tray_cancel_message = 2;

function sendtraymessage(const dest: winidty; const awindow: winidty; 
         const opcode: integer;
         const data1: longword = 0; const data2: longword = 0;
         const data3: longword = 0): guierrorty;
var
 at1: atom;
begin
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
 result:= gue_notraywindow;
 if dest <> 0 then begin
  at1:= netatoms[net_system_tray_opcode];
  if (at1 <> 0) and sendnetcardinalmessage(dest,at1,awindow,
                [lasteventtime,opcode,data1,data2,data3]) then begin
   result:= gue_ok;
  end;
 end;
end;

function gui_docktosyswindow(var child: windowty;
                                   const akind: syswindowty): guierrorty;
var
 syswin: winidty;
 parentbefore: winidty;
 int1: integer;
 pt1: pointty;
 rect1: rectty;
begin
 gdi_lock;
 gui_hidewindow(child.id);
 if akind = sywi_none then begin
  result:= getwindowrect(child.id,rect1,pt1);
  if result = gue_ok then begin
   result:= gui_reparentwindow(child.id,0,rect1.pos);
  end;
  finalizexembed(child.id);
 end
 else begin
  result:= gue_windownotfound;
  syswin:= getsyswin(akind);
  if syswin <> 0 then begin
   result:= gue_docktosyswindow;
   initxembed(child.id);
   parentbefore:= gui_getparentwindow(child.id);
   case akind of
    sywi_tray: begin
     result:= sendtraymessage(syswin,syswin,system_tray_request_dock,child.id);
    end;
   end;
   int1:= 0;
   xsync(appdisp,false);
   sys_schedyield;
   while (gui_getparentwindow(child.id) = parentbefore) and (int1 < 40) do begin
    xsync(appdisp,false);
    sleep(5);
    inc(int1);
   end;
  end; 
 end;
 gdi_unlock;
end;

function gui_traymessage(var awindow: windowty; const message: msestring;
                          out messageid: longword;
                          const timeoutms: longword = 0): guierrorty;
var
 str1: ansistring;
 int1: integer;
 event1: xclientmessageevent;
 po1: pchar;
 win1: winidty;
 at1: atom;
begin
 gdi_lock;
 result:= gue_notraywindow;
 win1:= getsyswin(sywi_tray);
 at1:= netatoms[net_system_tray_message_data];
 if (win1 <> 0) and (at1 <> 0) then begin
  messageid:= getidnum;
  str1:= stringtoutf8(message);
  int1:= length(str1);
  str1:= str1 + #0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0;
  result:= sendtraymessage(win1,awindow.id,system_tray_begin_message,timeoutms,
                     int1,messageid);
  fillchar(event1,sizeof(event1),0);
  with event1 do begin
   xtype:= clientmessage;
   display:= appdisp;
   window:= awindow.id;
   format:= 8;
   message_type:= at1;
   po1:= pchar(str1);
   while (result = gue_ok) and (int1 > 0) do begin
    move(po1^,data.b[0],20);
    inc(po1,20);
    int1:= int1 - 20;
    if xsendevent(appdisp,win1,
            {$ifdef xboolean}false{$else}0{$endif},
            structurenotifymask or substructurenotifymask{noeventmask},@event1) = 0 then begin
     result:= gue_sendevent;
    end;
   end;
  end;
 end;
 gdi_unlock;
end;

function gui_canceltraymessage(var awindow: windowty;
                          const messageid: longword): guierrorty;
begin
 gdi_lock;
 result:= sendtraymessage(getsyswin(sywi_tray),awindow.id,
                                system_tray_cancel_message,messageid,0,0);
 gdi_unlock;
end;

function gui_settrayicon(var awindow: windowty;
                                     const icon,mask: pixmapty): guierrorty;
begin
 result:= gui_setwindowicon(awindow.id,icon,mask);
end;

function gui_settrayhint(var awindow: windowty;
                                     const hint: msestring): guierrorty;
begin
 result:= gue_ok; //dummy
end;
{
function gui_creategc(paintdevice: paintdevicety; const akind: gckindty;
     var gc: gcty; const aprintername: msestring = ''): guierrorty;
begin
 result:= x11creategc(paintdevice,akind,gc,aprintername);
end;
}
{$ifndef FPC}
type
 tlibhandle = longword;
{$endif}


function gui_regiontorects(const aregion: regionty): rectarty;
begin
 result:= x11regiontorects(aregion);
end;

function gui_movewindowrect(id: winidty; const dist: pointty;
                                          const rect: rectty): guierrorty;
var
 gc: tgc;
begin
 gdi_lock;
 gc:= xcreategc(appdisp,id,0,nil);
 if gc <> nil then begin
  xcopyarea(appdisp,id,id,gc,rect.x,rect.y,rect.cx,rect.cy,rect.x+dist.x,rect.y+dist.y);
  xfreegc(appdisp,gc);
  result:= gue_ok;
 end
 else begin
  result:= gue_scroll;
 end;
 gdi_unlock;
end;

procedure gui_beep;
begin
 gdi_lock;
 xbell(appdisp,0);
 xflush(appdisp); 
 gdi_unlock;
end;

function gui_flushgdi(const synchronize: boolean = false): guierrorty;
begin
 gdi_lock;
 if synchronize then begin
  xsync(appdisp,false);
 end
 else begin
  xflush(appdisp);
 end;
 result:= gue_ok;
 gdi_unlock;
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
 gdi_lock;
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
 gdi_unlock;
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

function getkeynomod(var xev: {$ifdef FPC}txkeyevent{$else}
                                                  xkeyevent{$endif}): keyty;
var
// keysym1: pkeysym;
// int1{,int2}: integer;
 ss1: shiftstatesty;
// po1: pcuint;
 statebefore: cuint;
 keysym1: cuint;
begin
{$ifdef mse_debuggdisync}
 checkgdilock;
{$endif} 
 result:= key_none;
 statebefore:= xev.state;
 xev.state:= numlockstate;
 xlookupstring(@xev,nil,0,@keysym1,nil);
 xev.state:= statebefore;
 ss1:= [];
 result:= xkeytokey(keysym1,ss1);
 (*
 {$ifdef fpc} {$checkpointer off} {$endif}
 inc(xlockerror);
 ss1:= [];
 keysym1:= xgetkeyboardmapping(appdisp,xev.keycode,1,@int1);
 if keysym1 <> nil then begin
  result:= xkeytokey(keysym1^,ss1);
  xfree(keysym1);
 end;
 dec(xlockerror);
 {$ifdef fpc} {$checkpointer default} {$endif}
*)
end;

var
 timeoutcount: integer; //for safety timertick
 repeatkey: integer;
 repeatkeytime: ttime;

procedure resetrepeatkey;
begin
 repeatkey:= 0;
 repeatkeytime:= 0;
end;

function gui_getevent: tmseevent;

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
 str1: string;
{$ifdef with_sm}
 int2: integer;
{$endif}
 shiftstate1: shiftstatesty;
 key1,key2: keyty;
 button1: mousebuttonty;
 atomar: array[0..7] of atom;
 textprop: xtextproperty;
 bo1: boolean;
 rect1: rectty;
 pt1: pointty;
 aic: xic;

label
 eventrestart;
    
begin
 while true do begin
  if timerevent then begin
   application.postevent(tmseevent.create(ek_timer));
   timerevent:= false;
  end;
  if terminated then begin
   application.postevent(tmseevent.create(ek_terminate));
   terminated:= false;
  end;
  if childevent then begin
   childevent:= false;
   handlesigchld;
  end;
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
    if int1 = 0 then begin  //timeout
     inc(timeoutcount);
     if timeoutcount mod 10 = 0 then begin
      timerevent:= true; //every 10 seconds without messages 
                         //in case of lost timer alarm
     end;
    end;
    application.lock;
   until (int1 <> -1) or timerevent or terminated or childevent;
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
  {
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
  } //moved out of loop
 end;
 result:= nil;
 if not gui_hasevent then begin
  exit;
 end;

eventrestart:
 xnextevent(appdisp,@xev);
{$ifdef mse_debugsysevent}
 writeln(xev.xany.xtype,' ',xev.xany.xwindow);
{$endif}
 if longint(xfilterevent(@xev,none)) <> 0 then begin
  exit;
 end;
 bo1:= false;
 tguiapplication1(application).sysevent(xev.xany.xwindow,syseventty(xev),bo1);
 if bo1 then begin
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
      event.xselection.time:= time;
      bo1:= false;
      if target = targetsatom then begin
       atomar[0]:= textplainatom;
       atomar[1]:= utf8_stringatom;
       atomar[2]:= compound_textatom;
       atomar[3]:= stringatom;
       atomar[4]:= textatom;
       atomar[5]:= targetsatom;
       atomar[6]:= timestampatom;
//       atomar[7]:= multipleatom; //not implemented
       xchangeproperty(appdisp,requestor,
          {$ifdef FPC}_property{$else}xproperty{$endif},atomatom,32,
                  propmodereplace,@atomar[0],7);
      end
      else begin
       if target = timestampatom then begin
        atomar[0]:=
        xchangeproperty(appdisp,requestor,
           {$ifdef FPC}_property{$else}xproperty{$endif},target,32,
                   propmodereplace,@atomar[0],1);
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
          if (target = textatom) or (target = textplainatom) then begin
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
//            str1:= clipboard;
//            bo1:= true;
//            target:= textplainatom;
//            exit;
            event.xselection.{$ifdef FPC}_property{$else}xproperty{$endif}:= none;
//            event.xselection.target:= none;
           end;
          end;
         end;
        end;
       end;
      end;
      if bo1 then begin
       xchangeproperty(appdisp,requestor,
                {$ifdef FPC}_property{$else}xproperty{$endif},target,8,
                 propmodereplace,pbyte(pchar(str1)),length(str1));
      end;
      xsendevent(appdisp,requestor,{$ifdef xboolean}false{$else}0{$endif},0,
                               @event);
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
      result:= tmseevent(getclientpointer(xev.xclient));
     end
     else begin
      if message_type = wmprotocolsatom then begin
       if longword(data.l[0]) = wmprotocols[wm_delete_window] then begin
        result:= twindowevent.create(ek_close,xwindow);
{$ifdef with_saveyourself}
       end
       else begin
        if longword(data.l[0]) = wmprotocols[wm_save_yourself] then begin
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
   {$ifdef mse_debugkey}
    debugwriteln('*X11keypress window '+hextostr(window,8)+'"'+chars+'" '+
                                                              inttostr(akey));
   {$endif}
    case icstatus of
     xlookupnone: exit;
     xlookupchars: akey:= 0;
     xlookupkeysym_: chars:= '';
    end;
   {$ifdef mse_debugkey}
    debugwriteln('after icstatuscheck');
   {$endif}
    shiftstate1:= [];
    key1:= xkeytokey(akey,shiftstate1);
    if key1 = key_escape then begin
     escapepressed:= true;
    end;
    shiftstate1:= shiftstate1 + xtoshiftstate(state,key1,mb_none,false);
    if (keycode = repeatkey) and (time = repeatkeytime) then begin
     include(shiftstate1,ss_repeat);
     resetrepeatkey;
    end;
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
   {$ifdef mse_debugkey}
    debugwriteln('*X11keyrelease window '+hextostr(window,8)+
                                            ' key '+inttostr(akey));
   {$endif}
    shiftstate1:= [];
    key1:= xkeytokey(akey,shiftstate1);
    key2:= getkeynomod(xev.xkey);
    shiftstate1:= shiftstate1 + xtoshiftstate(state,key1,mb_none,true);
    if xpending(appdisp) > 0 then begin
     xpeekevent(appdisp,@xev);
     if (xev.xtype = keypress) and (time - lasteventtime < 10) and 
                                                   (keycode = int1) then begin
      repeatkey:= int1;
      repeatkeytime:= time;
   {$ifdef mse_debugkey}
    debugwriteln('eventrestart');
   {$endif}
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
    result:= twindowrectevent.create(ek_expose,xwindow,
                          makerect(x,y,width,height),nullpoint);
   end;
  end;
  graphicsexpose: begin
   with xev.xgraphicsexpose do begin
    result:= twindowrectevent.create(ek_expose,drawable,
                          makerect(x,y,width,height),nullpoint);
   end;
  end;
  configurenotify: begin
   with xev.xconfigure do begin
    w:= xwindow;
    if xchecktypedwindowevent(appdisp,w,destroynotify,@xev2) then begin
     result:= twindowevent.create(ek_destroy,xwindow);
    end
    else begin
     while xchecktypedwindowevent(appdisp,w,configurenotify,@xev) do begin end;
      //gnome returns a different pos on window resizing than on window moving!
     if not application.deinitializing then begin //there can be an Xerror?
      getwindowrect(w,rect1,pt1);
     end;
     result:= twindowrectevent.create(ek_configure,w,rect1,pt1);
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
 gdi_lock;
 if is8bitcolor and istruecolor then begin
  setcolormapvalue(cl_background,$d0,$e0,$d0);
             //green instead of blue tint
 end;
 result:= gue_ok;
 gdi_unlock;
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
//var
// xiccallback: txiccallback;
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

function checklocale: pchar;
begin
 result:= setlocale(lc_all,'');
 if xsupportslocale() = 0 then begin
  setlocale(lc_all,'en_US.UTF-8');
  if xsupportslocale() = 0 then begin  
   setlocale(lc_all,'en_US.utf8');
   if xsupportslocale() = 0 then begin  
    setlocale(lc_all,'POSIX');
    xsupportslocale();
   end;
  end;
 end;
end;

procedure imdestroyed(ic: txim; client_data: txpointer;
                                          call_data: txpointer); cdecl;
var
 po1: pchar;
begin
 im:= nil;
 appic:= nil;
 if not terminated then begin
  po1:= checklocale;
  if not createim or not createappic then begin
   debugwriteln('Input method lost.');
   halt(1);
  end;
  setlocale(lc_all,po1); //restore original
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
// fontpropnames: strfontproparty;
// propnum: fontpropertiesty;
 attrib: xsetwindowattributes;
 netnum: netatomty;
 int1,int2: integer;
 ar1: stringarty;
 po1: pchar;
 atom1: atom;
 atomar: atomarty;
 rect1: rectty;
 sigset1,sigset2: sigset_t;
{$ifdef with_sm}
 smcb: smccallbacks;
 clientid: pchar;
 smerror: array[0..255] of char;
{$endif}
 po2: pkeycode;
 modmap: pxmodifierkeymap;
 numlockcode: cuint;
 
begin
 gdi_lock;
 try
  resetrepeatkey;
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

  po1:= checklocale;
  
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
  setlocale(lc_all,po1); //restore original
  
  defscreen:= xdefaultscreenofdisplay(appdisp);
  rootid:= xrootwindowofscreen(defscreen);
  defvisual:= msepvisual(xdefaultvisualofscreen(defscreen));
  defdepth:= xdefaultdepthofscreen(defscreen);
  msex11gdi.init(appdisp,defvisual,defdepth);
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
  textplainatom:= xinternatom(appdisp,'text/plain',
            {$ifdef xboolean}false{$else}0{$endif});
  compound_textatom:= xinternatom(appdisp,'COMPOUND_TEXT',
            {$ifdef xboolean}false{$else}0{$endif});
  utf8_stringatom:= xinternatom(appdisp,'UTF8_STRING',
            {$ifdef xboolean}false{$else}0{$endif});
  timestampatom:= xinternatom(appdisp,'TIMESTAMP',
            {$ifdef xboolean}false{$else}0{$endif});
  multipleatom:= xinternatom(appdisp,'MULTIPLE',
            {$ifdef xboolean}false{$else}0{$endif});
  targetsatom:= xinternatom(appdisp,'TARGETS',
            {$ifdef xboolean}false{$else}0{$endif});
  convertselectionpropertyatom:= xinternatom(appdisp,'mseconvselprop',
            {$ifdef xboolean}false{$else}0{$endif});
 
  netsupportedatom:= xinternatom(appdisp,'_NET_SUPPORTED',
            {$ifdef xboolean}false{$else}0{$endif});
 
  fillchar(netatoms,sizeof(netatoms),0);               //check _net_
 // xinternatoms(appdisp,@netatomnames[low(netatomty)],
 //          integer(high(netatomty)),{$ifdef xboolean}true{$else}1{$endif},
 //          @netatoms[low(netatomty)]);
  xinternatoms(appdisp,@netatomnames[low(netatomty)],
           integer(high(netatomty)),{$ifdef xboolean}false{$else}0{$endif},
           @netatoms[low(netatomty)]);
  netsupported:= netsupportedatom <> 0;
  if netsupported then begin
   netsupported:= readatomproperty(rootid,netsupportedatom,atomar);
   for netnum:= firstcheckedatom to lastcheckedatom do begin
    atom1:= netatoms[netnum];
    netatoms[netnum]:= 0;
    for int1:= 0 to high(atomar) do begin
     if atomar[int1] = atom1 then begin
      netatoms[netnum]:= atom1;
      break;
     end;     
    end;
   end;
  end;
  for netnum:= low(netatomty) to needednetatom do begin
   if netatoms[netnum] = 0 then begin
    netsupported:= false;
    break;
   end;
  end;
  
  netsupported:= netsupported and
                   readcardinalproperty(rootid,netatoms[net_workarea],4,rect1);
  canframeextents:= netatoms[net_frame_extents] <> 0;
  canfullscreen:= netatoms[net_wm_state_fullscreen] <> 0;
  if netsupported and not canfullscreen then begin
   netatoms[net_wm_state_fullscreen]:= xinternatom(appdisp,
           @netatomnames[net_wm_state_fullscreen],
            {$ifdef xboolean}false{$else}0{$endif});      //fake
  end; 
 
  numlockstate:= 0;
  numlockcode:= xkeysymtokeycode(appdisp,xk_num_lock);
  if numlockcode <> nosymbol then begin  //return numlock state
   modmap:= xgetmodifiermapping(appdisp);
 {$ifdef FPC} {$checkpointer off} {$endif}
   po2:= modmap^.modifiermap;
   for int1:= 0 to 7 do begin
    for int2:= 0 to modmap^.max_keypermod - 1 do begin
     if po2^ = numlockcode then begin
      numlockstate:= 1 shl int1;
      break;
     end;
     inc(po2);
    end;
    if numlockstate <> 0 then begin
     break;
    end;
   end;
   xfreemodifiermap(modmap);
 {$ifdef FPC} {$checkpointer default} {$endif}
  end;
 
  result:= gue_ok;
  {$ifdef mse_flushgdi}
  xsynchronize(appdisp,{$ifdef xboolean}true{$else}1{$endif});
  {$endif}
  errorhandlerbefore:= xseterrorhandler({$ifdef FPC}@{$endif}errorhandler);
  exit;
 error:
  deinit;
 finally
  gdi_unlock;
 end;
end;

function gui_deinit: guierrorty;
begin
 gdi_lock;
 try
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
 // if screencursor <> 0 then begin
 //  xfreecursor(appdisp,screencursor);
 //  screencursor:= 0;
 // end;
  if appdisp <> nil then begin
   if msecolormap <> 0 then begin
    xfreecolormap(appdisp,msecolormap);
    msecolormap:= 0;
   end;
   xclosedisplay(appdisp);
   appdisp:= nil;
  end;
  signal(sigalrm,sigtimerbefore);
  signal(sigterm,sigtermbefore);
  signal(sigchld,sigchldbefore);
  xseterrorhandler(errorhandlerbefore);
 finally
  gdi_unlock;
 end;
end;

{
procedure gui_gdifunc(const func: gdifuncty; var drawinfo: drawinfoty);
begin
 gdifunctions[func](drawinfo);
end; 
}
function gui_getgdifuncs: pgdifunctionaty;
begin
 result:= x11getgdifuncs;
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
 hassm:= geticelib and getsmlib;
// x11initdefaultfont;
end.


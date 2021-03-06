{ MSEgui Copyright (c) 1999-2006 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
function gui_init: guierrorty;
function gui_deinit: guierrorty;
procedure gui_cancelshutdown;
procedure GUI_DEBUGBEGIN; export;
procedure GUI_DEBUGEND; export;

function gui_setmainthread: guierrorty; //set mainthread to currentthread

//application has to be locked for all following calls
function gui_postevent(event: tevent): guierrorty;
function gui_settimer(us: cardinal): guierrorty;
               //send et_timer event after delay of us (micro seconds)

function gui_hasevent: boolean;         //false if no event pending
function gui_getevent: tevent;          //can be nil


function gui_createwindow(const rect: rectty; const options: internalwindowoptionsty;
                               out id: winidty): guierrorty;
function gui_destroywindow(id: winidty): guierrorty;

function gui_creategc(paintdevice: paintdevicety; ispixmap: boolean; var gc: gcty): guierrorty;
//function gui_destroygc(winid: winidty; var gc: gcty): guierrorty;
function gui_flushgdi: guierrorty;
function gui_showwindow(id: winidty): guierrorty;
function gui_hidewindow(id: winidty): guierrorty;
function gui_raisewindow(id: winidty): guierrorty;
function gui_lowerwindow(id: winidty): guierrorty;
function gui_stackunderwindow(id: winidty; predecessor: winidty): guierrorty;
function gui_stackoverwindow(id: winidty; predecessor: winidty): guierrorty;
function gui_canstackunder: boolean; //no way found to change stacking order in KDE
function gui_getzorder(const ids: winidarty; out zorders: integerarty): guierrorty;
    //topevel -> highest, numbers have not to be contiguous
function gui_getwindowrect(id: winidty; out rect: rectty): guierrorty;
function gui_setsizeconstraints(id: winidty; const min,max: sizety): guierrorty;
function gui_reposwindow(id: winidty; const rect: rectty): guierrorty;
function gui_setwindowfocus(id: winidty): guierrorty;
function gui_setappfocus(id: winidty): guierrorty;
function gui_setwindowgroup(id: winidty; group: winidty): guierrorty;
function gui_settransientfor(id: winidty; transientfor: winidty): guierrorty;
function gui_movewindowrect(id: winidty; const dist: pointty; const rect: rectty): guierrorty;
function gui_windowatpos(const pos: pointty): winidty;
function gui_getscreensize: sizety;
function gui_getworkarea(id: winidty): rectty;
function gui_getwindowsize(id: winidty): windowsizety;
function gui_windowvisible(id: winidty): boolean;
function gui_setwindowstate(id: winidty; size: windowsizety; visible: boolean): guierrorty;
function gui_setwindowcaption(id: winidty; const caption: widestring): guierrorty;
function gui_setwindowicon(id: winidty; const icon,mask: pixmapty): guierrorty;
function gui_setapplicationicon(const icon,mask: pixmapty): guierrorty;
function gui_pidtowinid(const pids: integerarty): winidty;

function gui_setcursorshape(winid: winidty; shape: cursorshapety): guierrorty;
function gui_getpointerpos: pointty;
function gui_setpointerpos(const pos: pointty): guierrorty;
function gui_movepointer(const dist: pointty): guierrorty;
function gui_grabpointer(id: winidty): guierrorty;
function gui_ungrabpointer: guierrorty;

function gui_rgbtopixel(rgb: cardinal): pixelty;
function gui_pixeltorgb(pixel: pixelty): cardinal;
//procedure gui_changegc(var drawinfo: drawinfoty; const values: gcvaluesty);

function gui_getdefaultfontnames: defaultfontnamesty;
function gui_getfont(var drawinfo: drawinfoty): boolean;
procedure gui_freefontdata(const data: fontdataty);
function gui_gettext16width(var drawinfo: drawinfoty): integer; //-1 on error
function gui_getchar16widths(var drawinfo: drawinfoty): gdierrorty;
function gui_getfontmetrics(var drawinfo: drawinfoty): gdierrorty;

//procedure gui_gdifunc(const func: gdifuncty; var drawinfo: drawinfoty);
function gui_getgdifuncs: pgdifunctionaty;

function gui_createpixmap(const size: sizety; winid: winidty = 0;
      monochrome: boolean = false; copyfrom: pixmapty = 0): pixmapty; overload;
function gui_freepixmap(pixmap: pixmapty): gdierrorty;
function gui_getpixmapinfo(var info: pixmapinfoty): gdierrorty;
function gui_createbitmapfromdata(const size: sizety; datapo: pbyte;
             msbitfirst: boolean = false; dwordaligned: boolean = false;
             bottomup: boolean = false): pixmapty;
function gui_pixmaptoimage(pixmap: pixmapty; out image: imagety; gchandle: cardinal): gdierrorty;
                    //gchandle is used on win32 to select bitmap out of devicecontext,
                    //can be 0
function gui_imagetopixmap(const image: imagety; out pixmap: pixmapty; gchandle: cardinal): gdierrorty;
                    //gchandle is used on win32 to select bitmap out of devicecontext,
                    //can be 0
function gui_allocimagemem(length: integer): pcardinalaty;
procedure gui_freeimagemem(data: pcardinalaty);

//procedure gui_copyarea(var drawinfo: drawinfoty);

procedure gui_beep;
function gui_copytoclipboard(const value: widestring): guierrorty;
function gui_pastefromclipboard(out value: widestring): guierrorty;
function gui_canpastefromclipboard: boolean;

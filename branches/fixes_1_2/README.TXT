MSEide+MSEgui Pascal Cross Platform GUI Development System.

2007-06-15 Version 1.2 
Copyright (c) 1999-2007 by Martin Schreiber

- Compiles with FPC 2.0.4
- Tested on i386-linux SuSE 9.0,10.2 and i386-win32 98 and 2000.
- Links to xlib and gdi32, no external widget library needed.
- Internal character encoding is UCS2.
- Uses anti aliased fonts on Linux (Xft).
- All screen drawing is double buffered.
- Has docking forms and MDI.
- Has embedded forms (similar to TFrame).
- Internationalization functionality with resource modules.
- Report generator.

IDE:
- Integrated debugging.
- Source code highlighting.
- Source code navigation with support for include files.
- Code completion for classes.
- Integrated visual form designer with source code update for components and 
  events.
- Flexible and handy build system with switchable macros.
- Visual form inheritance.
- Integrated report designer.

License:
IDE is under GPL, library under modified LGPL like FPC-RTL.

Installation:
*************
1. Download and install FPC 2.0.4, you can get it from 
   http://www.freepascal.org/download.var
2. Download src and bin zip's.
3. Extract them to a directory of your choice ('yourdirectory') .
4. Run 'yourdirectory/bin/i386-linux/mseide' on linux or 
   'yourdirectory\bin\i386-win32\mseide.exe' on windows.
5. In 'Settings'-'Configure MSEide'-'${MSEDIR}' select 'yourdirectory/msegui'.
5a. On windows you have to setup ${COMPILER} (ppc386.exe) and 
    ${DEBUGGER} (gdb.exe).
6. In 'Project'-'Open' select 'yourdirectory/msegui/apps/demo/demo.prj'.
7. 'Target'-'Continue'.

If you wish to to compile the IDE:

1. In 'Project'-'Open' select 'yourdirectory/msegui/apps/ide/mseide.prj'.
2. 'Target'-'Continue'.

FPC 2.0.5
*********
In patch_fpc_2_0_5 are some patched FPC files, see
http://www.mail-archive.com/fpc-devel%40lists.freepascal.org/msg07545.html
for more info.

FPC 2.2
*******
MSEide+MSEgui does not work with FPC 2.2, see
http://www.mail-archive.com/fpc-devel%40lists.freepascal.org/msg07520.html
for more info. It seems that there are widestring bugs in FPC 2.2 for Linux too.

Debugging
*********
Breakpoints don't work on win32 in units compiled with -CX 
(create smartlinked units).
String and dynamic array variables of units compiled with 
-gv (Valgrind debug info) are displayed incorrect.
gdb 6.5 has bugs with threads and forking on linux. Please update to gdb 6.6.

Popup widgets behind the forms
******************************
If the popup widgets are showed behind the forms, try to start the 
MSEgui program with the option '--TOPLEVELRAISE'. Do *not* use this option
if is not necessary (KDE, Gnome, IceWM... work well without).

Invalid inputmanager for Ubuntu
*******************************
The utf-8 setup in Ubuntu seems to be incomplete. If you get the exception
"egui : Invalid inputmanager tinternalapplication ." at program start, try to
replace your language locale in /usr/share/X11/locale/locale.dir
by en_US as a workaround. Example for ru_RU.UTF-8:
replace 
ru_RU.UTF-8/XLC_LOCALE ru_RU.UTF-8
with
en_US.UTF-8/XLC_LOCALE ru_RU.UTF-8

How to add custom components to MSEide
**************************************
There is a project 'apps/myide/mymseide.prj' as a demo.
Start MSEide, open project 'apps/myide/mymseide.prj', 'Project'-'Build',
'Target'-'Continue',
the IDE with the new component 'tmybutton' will be compiled and
started in the the debugger.
Binary name is 'mymseide' (linux) or 'mymseide.exe' (win32).

If you wish to do it from scratch:

- Create a register unit for your components 
  (see 'apps/myide/regmycomps.pas' for an example).
- Enter the unitname followed by a comma 
  ('myregunit,' if your regunitfile is 'myregunit.pas') in 
  a file named 'regcomponents.inc'.
- Build the IDE with -dmorecomponents as option.

If you want add custom icons to your components:

- Convert 24*24 pixel BMP files with tools/bmp2pas to
  an icon unit ('*_bmp.pas').
- Add the name of the icon unit to 'uses' in your register unit.
 
How to run i18ndemo
*******************
- Start MSEide.
- 'Project'-'Open'-'yourdirectory/msegui/apps/i18ndemo/i18ndemo.prj'.
- 'Project'-'Make' to create the rst files.
- 'Project'-'Open'-'yourdirectory/msegui/tools/i18n/msei18n.prj'.
- 'Target'-'Continue'.
In MSEi18n:
 - Adjust 'Settings'-'Configure MSEi18n'-'${MSEDIR}' and ${COMPILER}.
 - 'Open'-'yourdirectory/msegui/apps/i18ndemo/i18ndemo.trp'
 - 'Make'.
 - Close message window.
 - Close MSEi18n.
- 'Project'-'Open'-'yourdirectory/msegui/apps/i18ndemo/i18ndemo.prj'.
- 'Target'-'Continue'.

SQLite
******
To install tmsesqlite3dataset compile the IDE with -dmse_with_sqlite 
(experimental, needs installed libsqlite3.so (linux) or sqlite3.dll (win32) 
on your system).

tsqlite3connection is available without -dmse_with_sqlite. Field type mapping:

      Type name        SQLite storage class  Field type    Data type
+--------------------+---------------------+-------------+-------------+
| INTEGER or INT     | INTEGER 4           | ftinteger   | integer     |
| LARGEINT           | INTEGER 8           | ftlargeint  | largeint    |
| WORD               | INTEGER 2           | ftword      | word        |
| SMALLINT           | INTEGER 2           | ftsmallint  | smallint    |
| BOOLEAN            | INTEGER 2           | ftboolean   | wordbool    |
| FLOAT[...] or REAL | REAL                | ftfloat     | double      |
| or DOUBLE[...]     |                     |             |             |
| CURRENCY           | REAL                | ftcurrency  | double!     |
| DATETIME           | REAL                | ftdatetime  | tdatetime   |
| DATE               | REAL                | ftdate      | tdatetime   |
| TIME               | REAL                | fttime      | tdatetime   |
| NUMERIC[...]       | INTEGER 8           | ftbcd       | currency    |
| VARCHAR[(n)]       | TEXT                | ftstring    | msestring   |
| TEXT               | TEXT                | ftmemo      | utf8 string |
| BLOB               | BLOB                | ftblob      | string      |
+--------------------+---------------------+-------------+-------------+


{ MSEgui Copyright (c) 2008 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit msesonames;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msestrings;
const
{$ifdef mswindows}
 sqlite3libarray[0..0] of filenamety = ('sqlite3.dll');  
 sslnames: array[0..1] of filenamety = ('ssleay32.dll','libssl32.dll');
 sslutilnames: array[0..0] of filenamety = ('libeay32.dll');
 fbembedlib: array[0..0] of filenamety = ('fbembed.dll');
 fbcgdslib: array[0..1] of filenamety = ('fbclient.dll','gds32.dll');
{$else}
 xrendernames: array[0..1] of filenamety = ('libXrender.so.1','libXrender.so');
 fontconfignames: array[0..1] of filenamety = 
                                     ('libfontconfig.so.1','libfontconfig.so');
 xftnames: array[0..1] of filenamety = ('libXft.so.2','libXft.so');
 icenames: array[0..1] of filenamety = ('libICE.so.6','libICE.so');
 smnames: array[0..1] of filenamety = ('libSM.so6','libSM.so');
 
 sqlite3lib: array[0..1] of filenamety = ('libsqlite3.so.0','libsqlite3.so'); 
 sslnames: array[0..1] of filenamety = ('libssl.so.0.9.8','libssl.so');
 sslutilnames: array[0..1] of filenamety = ('libcrypto.so.0.9.8','libcrypto.so');  
 fbembedlib: array[0..1] of filenamety = ('libfbembed.so.2','libfbembed.so');
 fbcgdslib: array[0..2] of filenamety = ('libfbclient.so','libfbclient.so',
                                         'libgds.so');
{$endif}
{$IFDEF Unix}
  {$DEFINE extdecl:=cdecl}
  const
    gdslib = 'libgds.so';
    fbclib = 'libfbclient.so';
{$ENDIF}
{$IFDEF Win32}
  {$DEFINE extdecl:=stdcall}
  const
    gdslib = 'gds32.dll';
    fbclib = 'fbclient.dll';
    fbembedlib = 'fbembed.dll';
{$ENDIF}
{$IFDEF Wince}
  {$DEFINE extdecl:=stdcall}
  const
    gdslib = 'gds32.dll';
    fbclib = 'fbclient.dll';
{$ENDIF}

implementation
end.

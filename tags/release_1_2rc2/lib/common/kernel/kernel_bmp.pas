unit kernel_bmp;

{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface

implementation
uses
 mseclasses,msebitmap;

const
 objdata_taction: record size: integer; data: array[0..293] of byte end =
      (size: 294; data: (
  84,80,70,48,16,116,98,105,116,109,97,112,99,111,110,116,97,105,110,101,
  114,7,116,97,99,116,105,111,110,23,98,105,116,109,97,112,46,116,114,97,
  110,115,112,97,114,101,110,116,99,111,108,111,114,4,0,0,0,128,12,98,
  105,116,109,97,112,46,105,109,97,103,101,10,216,0,0,0,0,0,0,0,
  0,0,0,0,24,0,0,0,24,0,0,0,164,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,255,0,255,87,0,0,255,2,255,0,255,20,
  0,0,255,2,255,0,255,19,0,0,255,3,255,0,255,19,0,0,255,2,
  255,0,255,20,0,0,255,2,255,0,255,23,0,0,255,2,255,0,255,24,
  0,0,255,2,255,0,255,24,0,0,255,2,255,0,255,24,0,0,255,2,
  255,0,255,21,0,0,255,2,255,0,255,21,0,0,255,1,255,0,255,17,
  0,0,255,1,255,0,255,3,0,0,255,2,255,0,255,18,0,0,255,1,
  255,0,255,2,0,0,255,1,255,0,255,19,0,0,255,1,255,0,255,1,
  0,0,255,2,255,0,255,20,0,0,255,2,255,0,255,1,0,0,255,3,
  255,0,255,18,0,0,255,3,255,0,255,137,0,0)
 );

initialization
 registerobjectdata(@objdata_taction,tbitmapcontainer,'taction');
end.

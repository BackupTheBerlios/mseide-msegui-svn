unit msefiledialogres_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,msefiledialogres;

const
 objdata: record size: integer; data: array[0..1736] of byte end =
      (size: 1737; data: (
  84,80,70,48,14,116,102,105,108,101,100,105,97,108,111,103,114,101,115,13,
  102,105,108,101,100,105,97,108,111,103,114,101,115,4,108,101,102,116,2,93,
  3,116,111,112,3,140,1,15,109,111,100,117,108,101,99,108,97,115,115,110,
  97,109,101,6,14,116,109,115,101,100,97,116,97,109,111,100,117,108,101,4,
  115,105,122,101,1,3,235,0,2,117,0,0,10,116,105,109,97,103,101,108,
  105,115,116,6,105,109,97,103,101,115,5,99,111,117,110,116,2,4,4,108,
  101,102,116,2,32,3,116,111,112,2,32,5,105,109,97,103,101,10,56,6,
  0,0,0,0,0,0,2,0,0,0,32,0,0,0,32,0,0,0,132,5,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,0,128,82,127,127,
  127,1,0,0,0,4,127,127,127,1,128,0,128,11,127,127,127,1,0,0,
  0,4,127,127,127,1,128,0,128,9,0,0,0,1,0,255,255,1,255,255,
  255,1,0,255,255,1,255,255,255,1,0,0,0,1,128,0,128,11,0,0,
  0,1,255,255,255,1,0,255,255,1,255,255,255,1,0,255,255,1,0,0,
  0,1,128,0,128,8,0,0,0,1,0,255,255,1,255,255,255,1,0,255,
  255,1,255,255,255,1,0,255,255,1,255,255,255,1,0,0,0,3,128,0,
  128,7,0,0,0,10,128,0,128,5,0,0,0,1,255,255,255,1,0,255,
  255,1,255,255,255,1,0,255,255,1,255,255,255,1,0,255,255,1,255,255,
  255,1,0,255,255,1,255,255,255,1,0,0,0,1,128,0,128,6,0,0,
  0,1,255,255,255,1,0,255,255,1,255,255,255,1,0,255,255,1,255,255,
  255,1,0,255,255,1,255,255,255,1,0,255,255,1,255,255,255,1,0,0,
  0,1,128,0,128,4,0,0,0,1,0,255,255,1,255,255,255,1,0,255,
  255,1,255,255,255,1,0,255,255,1,255,255,255,1,0,255,255,1,255,255,
  255,1,0,255,255,1,0,0,0,1,128,0,128,6,0,0,0,1,0,255,
  255,1,255,255,255,1,0,255,255,1,255,255,255,1,0,255,255,1,255,255,
  255,1,0,255,255,1,255,255,255,1,0,255,255,1,0,0,0,1,128,0,
  128,4,0,0,0,1,255,255,255,1,0,255,255,1,255,255,255,1,0,0,
  0,10,128,0,128,3,0,0,0,1,255,255,255,1,0,255,255,1,255,255,
  255,1,0,255,255,1,255,255,255,1,0,255,255,1,255,255,255,1,0,255,
  255,1,255,255,255,1,0,0,0,1,128,0,128,4,0,0,0,1,0,255,
  255,1,255,255,255,1,0,0,0,1,0,255,255,1,191,191,191,1,0,255,
  255,1,191,191,191,1,0,255,255,1,191,191,191,1,0,255,255,1,191,191,
  191,1,0,255,255,1,0,0,0,1,128,0,128,3,0,0,0,1,0,255,
  255,1,255,255,255,1,0,255,255,1,255,255,255,1,0,255,255,1,255,255,
  255,1,0,255,255,1,255,255,255,1,0,255,255,1,0,0,0,1,128,0,
  128,4,0,0,0,1,255,255,255,1,0,0,0,1,0,255,255,1,191,191,
  191,1,0,255,255,1,191,191,191,1,0,255,255,1,191,191,191,1,0,255,
  255,1,191,191,191,1,0,255,255,1,0,0,0,1,128,0,128,4,0,0,
  0,1,255,255,255,1,0,255,255,1,255,255,255,1,0,255,255,1,255,255,
  255,1,0,255,255,1,255,255,255,1,0,255,255,1,255,255,255,1,0,0,
  0,1,128,0,128,4,0,0,0,2,0,255,255,1,191,191,191,1,0,255,
  255,1,191,191,191,1,0,255,255,1,191,191,191,1,0,255,255,1,191,191,
  191,1,0,255,255,1,0,0,0,1,128,0,128,5,0,0,0,1,0,255,
  255,1,255,255,255,1,0,255,255,1,255,255,255,1,0,255,255,1,255,255,
  255,1,0,255,255,1,255,255,255,1,0,255,255,1,0,0,0,1,128,0,
  128,5,0,0,0,10,128,0,128,7,0,0,0,10,128,0,128,115,255,0,
  0,16,224,224,224,16,255,0,0,16,224,224,224,16,255,0,0,3,0,0,
  0,6,255,0,0,7,224,224,224,16,255,0,0,3,0,0,0,1,255,255,
  255,4,0,0,0,2,255,0,0,6,224,224,224,3,127,127,127,1,0,0,
  0,4,127,127,127,1,224,224,224,7,255,0,0,3,0,0,0,1,255,255,
  255,4,0,0,0,1,255,255,255,1,0,0,0,1,255,0,0,5,224,224,
  224,3,0,0,0,1,255,255,255,1,0,255,255,1,255,255,255,1,0,255,
  255,1,0,0,0,1,224,224,224,7,255,0,0,3,0,0,0,1,255,255,
  255,4,0,0,0,1,255,255,255,2,0,0,0,1,255,0,0,4,224,224,
  224,2,0,0,0,10,224,224,224,4,255,0,0,3,0,0,0,1,255,255,
  255,4,0,0,0,5,255,0,0,3,224,224,224,2,0,0,0,1,255,255,
  255,1,0,255,255,1,255,255,255,1,0,255,255,1,255,255,255,1,0,255,
  255,1,255,255,255,1,0,255,255,1,255,255,255,1,0,0,0,1,224,224,
  224,3,255,0,0,3,0,0,0,1,255,255,255,8,0,0,0,1,128,128,
  128,1,255,0,0,2,224,224,224,2,0,0,0,1,0,255,255,1,255,255,
  255,1,0,255,255,1,255,255,255,1,127,127,127,1,255,255,255,1,0,255,
  255,1,255,255,255,1,0,255,255,1,0,0,0,1,224,224,224,3,255,0,
  0,3,0,0,0,1,255,255,255,8,0,0,0,1,128,128,128,1,255,0,
  0,2,224,224,224,2,0,0,0,1,255,255,255,1,0,255,255,1,255,255,
  255,1,0,255,255,1,127,127,127,1,0,255,255,1,255,255,255,1,0,255,
  255,1,255,255,255,1,0,0,0,1,224,224,224,3,255,0,0,3,0,0,
  0,1,255,255,255,8,0,0,0,1,128,128,128,1,255,0,0,2,224,224,
  224,2,0,0,0,1,0,255,255,1,255,255,255,1,127,127,127,5,255,255,
  255,1,0,255,255,1,0,0,0,1,224,224,224,3,255,0,0,3,0,0,
  0,1,255,255,255,8,0,0,0,1,128,128,128,1,255,0,0,2,224,224,
  224,2,0,0,0,1,255,255,255,1,0,255,255,1,255,255,255,1,0,255,
  255,1,127,127,127,1,0,255,255,1,255,255,255,1,0,255,255,1,255,255,
  255,1,0,0,0,1,224,224,224,3,255,0,0,3,0,0,0,1,255,255,
  255,8,0,0,0,1,128,128,128,1,255,0,0,2,224,224,224,2,0,0,
  0,1,0,255,255,1,255,255,255,1,0,255,255,1,255,255,255,1,127,127,
  127,1,255,255,255,1,0,255,255,1,255,255,255,1,0,255,255,1,0,0,
  0,1,224,224,224,3,255,0,0,3,0,0,0,1,255,255,255,8,0,0,
  0,1,128,128,128,1,255,0,0,2,224,224,224,3,0,0,0,10,224,224,
  224,3,255,0,0,3,0,0,0,10,128,128,128,1,255,0,0,2,224,224,
  224,16,255,0,0,4,128,128,128,10,255,0,0,2,224,224,224,16,255,0,
  0,16,224,224,224,16,0,0,0,0,0,0,0,0,0,0,252,0,248,1,
  252,0,248,1,254,7,252,15,254,15,252,31,254,15,252,31,254,127,252,31,
  254,127,252,31,254,63,252,31,254,31,252,31,252,15,248,31,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,248,1,
  0,0,248,3,248,1,248,7,248,1,248,15,252,15,248,31,252,31,248,63,
  252,31,248,63,252,31,248,63,252,31,248,63,252,31,248,63,252,31,248,63,
  248,31,248,63,0,0,240,63,0,0,0,0,0,0,0,0,0)
 );

initialization
 registerobjectdata(@objdata,tfiledialogres,'');
end.

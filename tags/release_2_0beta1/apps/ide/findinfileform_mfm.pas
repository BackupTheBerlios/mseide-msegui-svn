unit findinfileform_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,findinfileform;

const
 objdata: record size: integer; data: array[0..1566] of byte end =
      (size: 1567; data: (
  84,80,70,48,13,116,102,105,110,100,105,110,102,105,108,101,102,111,12,102,
  105,110,100,105,110,102,105,108,101,102,111,13,111,112,116,105,111,110,115,119,
  105,100,103,101,116,11,13,111,119,95,97,114,114,111,119,102,111,99,117,115,
  15,111,119,95,97,114,114,111,119,102,111,99,117,115,105,110,16,111,119,95,
  97,114,114,111,119,102,111,99,117,115,111,117,116,11,111,119,95,115,117,98,
  102,111,99,117,115,17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,
  101,116,115,9,111,119,95,104,105,110,116,111,110,12,111,119,95,97,117,116,
  111,115,99,97,108,101,0,8,98,111,117,110,100,115,95,120,3,36,2,8,
  98,111,117,110,100,115,95,121,2,115,9,98,111,117,110,100,115,95,99,120,
  3,113,1,9,98,111,117,110,100,115,95,99,121,3,198,0,15,102,114,97,
  109,101,46,103,114,105,112,95,115,105,122,101,2,10,18,102,114,97,109,101,
  46,103,114,105,112,95,111,112,116,105,111,110,115,11,14,103,111,95,99,108,
  111,115,101,98,117,116,116,111,110,16,103,111,95,102,105,120,115,105,122,101,
  98,117,116,116,111,110,12,103,111,95,116,111,112,98,117,116,116,111,110,0,
  11,102,114,97,109,101,46,100,117,109,109,121,2,0,8,116,97,98,111,114,
  100,101,114,2,1,7,118,105,115,105,98,108,101,8,23,99,111,110,116,97,
  105,110,101,114,46,111,112,116,105,111,110,115,119,105,100,103,101,116,11,13,
  111,119,95,109,111,117,115,101,102,111,99,117,115,11,111,119,95,116,97,98,
  102,111,99,117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,115,15,
  111,119,95,97,114,114,111,119,102,111,99,117,115,105,110,16,111,119,95,97,
  114,114,111,119,102,111,99,117,115,111,117,116,11,111,119,95,115,117,98,102,
  111,99,117,115,19,111,119,95,109,111,117,115,101,116,114,97,110,115,112,97,
  114,101,110,116,17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,
  116,115,12,111,119,95,97,117,116,111,115,99,97,108,101,0,18,99,111,110,
  116,97,105,110,101,114,46,98,111,117,110,100,115,95,120,2,0,18,99,111,
  110,116,97,105,110,101,114,46,98,111,117,110,100,115,95,121,2,0,19,99,
  111,110,116,97,105,110,101,114,46,98,111,117,110,100,115,95,99,120,3,103,
  1,19,99,111,110,116,97,105,110,101,114,46,98,111,117,110,100,115,95,99,
  121,3,198,0,21,99,111,110,116,97,105,110,101,114,46,102,114,97,109,101,
  46,100,117,109,109,121,2,0,22,100,114,97,103,100,111,99,107,46,115,112,
  108,105,116,116,101,114,95,115,105,122,101,2,0,16,100,114,97,103,100,111,
  99,107,46,99,97,112,116,105,111,110,6,11,70,105,110,100,114,101,115,117,
  108,116,115,20,100,114,97,103,100,111,99,107,46,111,112,116,105,111,110,115,
  100,111,99,107,11,10,111,100,95,115,97,118,101,112,111,115,10,111,100,95,
  99,97,110,109,111,118,101,11,111,100,95,99,97,110,102,108,111,97,116,10,
  111,100,95,99,97,110,100,111,99,107,11,111,100,95,112,114,111,112,115,105,
  122,101,0,7,111,112,116,105,111,110,115,11,10,102,111,95,115,97,118,101,
  112,111,115,13,102,111,95,115,97,118,101,122,111,114,100,101,114,0,8,115,
  116,97,116,102,105,108,101,7,22,109,97,105,110,102,111,46,112,114,111,106,
  101,99,116,115,116,97,116,102,105,108,101,7,99,97,112,116,105,111,110,6,
  20,70,105,110,100,32,105,110,32,102,105,108,101,32,114,101,115,117,108,116,
  115,21,105,99,111,110,46,116,114,97,110,115,112,97,114,101,110,116,99,111,
  108,111,114,4,6,0,0,128,12,105,99,111,110,46,111,112,116,105,111,110,
  115,11,10,98,109,111,95,109,97,115,107,101,100,0,10,105,99,111,110,46,
  105,109,97,103,101,10,224,1,0,0,0,0,0,0,2,0,0,0,16,0,
  0,0,16,0,0,0,108,1,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,208,208,208,20,104,104,104,1,64,64,64,1,128,128,128,2,64,64,
  64,1,104,104,104,1,208,208,208,8,156,156,156,1,64,64,64,1,191,191,
  191,1,255,255,227,4,191,191,191,1,64,64,64,1,156,156,156,1,208,208,
  208,6,52,52,52,1,255,255,227,8,52,52,52,1,208,208,208,5,104,104,
  104,1,191,191,191,1,255,255,227,2,135,135,120,1,68,68,61,1,53,53,
  47,1,158,158,141,1,255,255,227,2,191,191,191,1,104,104,104,1,208,208,
  208,4,52,52,52,1,255,255,227,5,248,248,221,1,43,43,38,1,255,255,
  227,3,52,52,52,1,208,208,208,4,128,128,128,1,255,255,227,5,153,153,
  136,1,86,86,77,1,255,255,227,3,125,125,125,1,208,208,208,4,128,128,
  128,1,255,255,227,4,79,79,70,1,112,112,100,1,244,244,217,1,255,255,
  227,3,125,125,125,1,208,208,208,4,64,64,64,1,255,255,227,4,67,67,
  60,1,255,255,227,5,58,58,58,1,208,208,208,4,104,104,104,1,255,255,
  227,4,96,96,85,1,255,255,227,5,104,104,104,1,208,208,208,4,156,156,
  156,1,64,64,64,1,255,255,227,8,64,64,64,1,156,156,156,1,208,208,
  208,5,104,104,104,1,191,191,191,1,255,255,227,6,175,175,175,1,78,90,
  99,1,208,208,208,7,104,104,104,1,64,64,64,1,187,187,187,1,255,255,
  227,2,184,184,184,1,59,59,59,1,78,90,99,1,106,150,187,2,208,208,
  208,8,104,104,104,4,208,208,208,2,106,150,187,3,208,208,208,14,106,150,
  187,2,208,208,208,18,0,0,255,191,240,3,160,3,252,15,0,0,252,15,
  0,0,254,31,255,191,254,31,11,8,254,31,0,0,254,31,160,3,254,31,
  0,64,254,31,0,0,254,31,238,8,252,15,1,9,248,31,255,191,224,57,
  14,8,0,48,0,0,0,0,0,0,15,109,111,100,117,108,101,99,108,97,
  115,115,110,97,109,101,6,9,116,100,111,99,107,102,111,114,109,0,10,116,
  116,97,98,119,105,100,103,101,116,4,116,97,98,115,8,98,111,117,110,100,
  115,95,120,2,0,8,98,111,117,110,100,115,95,121,2,0,9,98,111,117,
  110,100,115,95,99,120,3,103,1,9,98,111,117,110,100,115,95,99,121,3,
  198,0,7,97,110,99,104,111,114,115,11,0,7,111,112,116,105,111,110,115,
  11,13,116,97,98,111,95,111,112,112,111,115,105,116,101,0,21,116,97,98,
  95,102,114,97,109,101,46,98,117,116,116,111,110,115,108,97,115,116,9,15,
  116,97,98,95,102,114,97,109,101,46,100,117,109,109,121,2,0,8,116,97,
  98,95,115,105,122,101,2,18,13,114,101,102,102,111,110,116,104,101,105,103,
  104,116,2,14,0,0,0)
 );

initialization
 registerobjectdata(@objdata,tfindinfilefo,'');
end.
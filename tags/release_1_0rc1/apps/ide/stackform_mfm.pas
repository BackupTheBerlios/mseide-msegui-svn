unit stackform_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface

implementation
uses
 mseclasses,stackform;

const
 objdata: record size: integer; data: array[0..2513] of byte end =
      (size: 2514; data: (
  84,80,70,48,8,116,115,116,97,99,107,102,111,7,115,116,97,99,107,102,
  111,13,111,112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,
  97,114,114,111,119,102,111,99,117,115,15,111,119,95,97,114,114,111,119,102,
  111,99,117,115,105,110,16,111,119,95,97,114,114,111,119,102,111,99,117,115,
  111,117,116,11,111,119,95,115,117,98,102,111,99,117,115,17,111,119,95,100,
  101,115,116,114,111,121,119,105,100,103,101,116,115,9,111,119,95,104,105,110,
  116,111,110,12,111,119,95,97,117,116,111,115,99,97,108,101,0,8,98,111,
  117,110,100,115,95,120,3,151,1,8,98,111,117,110,100,115,95,121,3,93,
  1,9,98,111,117,110,100,115,95,99,120,3,254,0,9,98,111,117,110,100,
  115,95,99,121,3,180,0,15,102,114,97,109,101,46,103,114,105,112,95,115,
  105,122,101,2,10,18,102,114,97,109,101,46,103,114,105,112,95,111,112,116,
  105,111,110,115,11,14,103,111,95,99,108,111,115,101,98,117,116,116,111,110,
  16,103,111,95,102,105,120,115,105,122,101,98,117,116,116,111,110,12,103,111,
  95,116,111,112,98,117,116,116,111,110,0,11,102,114,97,109,101,46,100,117,
  109,109,121,2,0,9,112,111,112,117,112,109,101,110,117,7,11,116,112,111,
  112,117,112,109,101,110,117,49,7,118,105,115,105,98,108,101,8,23,99,111,
  110,116,97,105,110,101,114,46,111,112,116,105,111,110,115,119,105,100,103,101,
  116,11,13,111,119,95,109,111,117,115,101,102,111,99,117,115,11,111,119,95,
  116,97,98,102,111,99,117,115,13,111,119,95,97,114,114,111,119,102,111,99,
  117,115,15,111,119,95,97,114,114,111,119,102,111,99,117,115,105,110,16,111,
  119,95,97,114,114,111,119,102,111,99,117,115,111,117,116,11,111,119,95,115,
  117,98,102,111,99,117,115,19,111,119,95,109,111,117,115,101,116,114,97,110,
  115,112,97,114,101,110,116,17,111,119,95,100,101,115,116,114,111,121,119,105,
  100,103,101,116,115,12,111,119,95,97,117,116,111,115,99,97,108,101,0,19,
  99,111,110,116,97,105,110,101,114,46,98,111,117,110,100,115,95,99,120,3,
  244,0,19,99,111,110,116,97,105,110,101,114,46,98,111,117,110,100,115,95,
  99,121,3,180,0,28,99,111,110,116,97,105,110,101,114,46,102,114,97,109,
  101,46,102,114,97,109,101,105,95,114,105,103,104,116,2,0,26,99,111,110,
  116,97,105,110,101,114,46,102,114,97,109,101,46,108,111,99,97,108,112,114,
  111,112,115,11,11,102,114,108,95,102,105,114,105,103,104,116,0,21,99,111,
  110,116,97,105,110,101,114,46,102,114,97,109,101,46,100,117,109,109,121,2,
  0,22,100,114,97,103,100,111,99,107,46,115,112,108,105,116,116,101,114,95,
  115,105,122,101,2,0,16,100,114,97,103,100,111,99,107,46,99,97,112,116,
  105,111,110,6,5,83,116,97,99,107,20,100,114,97,103,100,111,99,107,46,
  111,112,116,105,111,110,115,100,111,99,107,11,10,111,100,95,115,97,118,101,
  112,111,115,10,111,100,95,99,97,110,109,111,118,101,11,111,100,95,99,97,
  110,102,108,111,97,116,10,111,100,95,99,97,110,100,111,99,107,11,111,100,
  95,112,114,111,112,115,105,122,101,0,7,111,112,116,105,111,110,115,11,10,
  102,111,95,115,97,118,101,112,111,115,12,102,111,95,115,97,118,101,115,116,
  97,116,101,0,8,115,116,97,116,102,105,108,101,7,22,109,97,105,110,102,
  111,46,112,114,111,106,101,99,116,115,116,97,116,102,105,108,101,7,99,97,
  112,116,105,111,110,6,5,83,116,97,99,107,21,105,99,111,110,46,116,114,
  97,110,115,112,97,114,101,110,116,99,111,108,111,114,4,0,0,0,128,12,
  105,99,111,110,46,111,112,116,105,111,110,115,11,10,98,109,111,95,109,97,
  115,107,101,100,0,10,105,99,111,110,46,105,109,97,103,101,10,80,1,0,
  0,0,0,0,0,2,0,0,0,24,0,0,0,24,0,0,0,188,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,224,224,224,55,0,0,248,
  1,224,224,224,23,0,0,248,2,224,224,224,20,0,0,248,5,0,0,0,
  8,224,224,224,10,0,0,248,1,224,224,224,2,0,0,248,2,224,224,224,
  19,0,0,248,1,224,224,224,2,0,0,248,1,224,224,224,5,0,0,0,
  7,224,224,224,8,0,0,248,1,224,224,224,23,0,0,248,1,224,224,224,
  5,0,0,0,8,224,224,224,10,0,0,248,1,224,224,224,23,0,0,248,
  1,224,224,224,24,0,0,248,14,224,224,224,24,0,0,248,1,224,224,224,
  23,0,0,248,1,224,224,224,14,0,0,0,6,224,224,224,3,0,0,248,
  1,224,224,224,23,0,0,248,1,224,224,224,16,0,0,0,6,0,0,248,
  1,224,224,224,41,0,0,0,4,224,224,224,42,0,0,0,6,224,224,224,
  80,0,0,0,255,0,0,0,255,128,0,0,255,128,1,0,255,224,255,3,
  255,144,1,0,255,144,224,15,255,16,0,0,255,16,252,3,255,16,0,0,
  255,16,0,0,255,224,255,7,255,0,0,8,255,0,0,8,255,0,252,8,
  255,0,0,8,255,0,240,7,255,0,0,0,255,0,240,0,255,0,0,0,
  255,0,252,0,255,0,0,0,255,0,0,0,255,0,0,0,255,6,111,110,
  115,104,111,119,7,13,115,116,97,99,107,102,111,111,110,115,104,111,119,13,
  111,110,99,104,105,108,100,115,99,97,108,101,100,7,17,102,111,114,109,111,
  110,99,104,105,108,100,115,99,97,108,101,100,15,109,111,100,117,108,101,99,
  108,97,115,115,110,97,109,101,6,9,116,100,111,99,107,102,111,114,109,0,
  11,116,115,116,114,105,110,103,103,114,105,100,4,103,114,105,100,13,111,112,
  116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,109,111,117,115,
  101,102,111,99,117,115,11,111,119,95,116,97,98,102,111,99,117,115,13,111,
  119,95,97,114,114,111,119,102,111,99,117,115,15,111,119,95,97,114,114,111,
  119,102,111,99,117,115,105,110,16,111,119,95,97,114,114,111,119,102,111,99,
  117,115,111,117,116,17,111,119,95,102,111,99,117,115,98,97,99,107,111,110,
  101,115,99,17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,
  115,18,111,119,95,102,111,110,116,103,108,121,112,104,104,101,105,103,104,116,
  12,111,119,95,97,117,116,111,115,99,97,108,101,0,8,98,111,117,110,100,
  115,95,121,2,20,9,98,111,117,110,100,115,95,99,120,3,244,0,9,98,
  111,117,110,100,115,95,99,121,3,160,0,16,102,114,97,109,101,46,108,111,
  99,97,108,112,114,111,112,115,11,10,102,114,108,95,108,101,118,101,108,111,
  15,102,114,108,95,99,111,108,111,114,99,108,105,101,110,116,0,11,102,114,
  97,109,101,46,100,117,109,109,121,2,0,7,97,110,99,104,111,114,115,11,
  6,97,110,95,116,111,112,9,97,110,95,98,111,116,116,111,109,0,8,116,
  97,98,111,114,100,101,114,2,2,14,100,97,116,97,99,111,108,115,46,99,
  111,117,110,116,2,5,14,100,97,116,97,99,111,108,115,46,105,116,101,109,
  115,14,1,5,99,111,108,111,114,4,2,0,0,128,5,119,105,100,116,104,
  2,31,7,111,112,116,105,111,110,115,11,11,99,111,95,114,101,97,100,111,
  110,108,121,10,99,111,95,110,111,102,111,99,117,115,14,99,111,95,102,111,
  99,117,115,115,101,108,101,99,116,12,99,111,95,114,111,119,115,101,108,101,
  99,116,12,99,111,95,115,97,118,101,115,116,97,116,101,0,9,116,101,120,
  116,102,108,97,103,115,11,12,116,102,95,120,99,101,110,116,101,114,101,100,
  8,116,102,95,114,105,103,104,116,12,116,102,95,121,99,101,110,116,101,114,
  101,100,0,0,1,5,119,105,100,116,104,2,54,7,111,112,116,105,111,110,
  115,11,11,99,111,95,114,101,97,100,111,110,108,121,14,99,111,95,102,111,
  99,117,115,115,101,108,101,99,116,12,99,111,95,114,111,119,115,101,108,101,
  99,116,7,99,111,95,102,105,108,108,0,11,99,111,108,111,114,115,101,108,
  101,99,116,4,7,0,0,144,11,111,112,116,105,111,110,115,101,100,105,116,
  11,14,115,99,111,101,95,101,97,116,114,101,116,117,114,110,16,115,99,111,
  101,95,104,111,109,101,111,110,101,110,116,101,114,0,0,1,7,111,112,116,
  105,111,110,115,11,12,99,111,95,105,110,118,105,115,105,98,108,101,12,99,
  111,95,115,97,118,101,115,116,97,116,101,0,11,111,112,116,105,111,110,115,
  101,100,105,116,11,14,115,99,111,101,95,101,97,116,114,101,116,117,114,110,
  0,0,1,7,111,112,116,105,111,110,115,11,12,99,111,95,105,110,118,105,
  115,105,98,108,101,12,99,111,95,115,97,118,101,115,116,97,116,101,0,0,
  1,7,111,112,116,105,111,110,115,11,12,99,111,95,105,110,118,105,115,105,
  98,108,101,12,99,111,95,115,97,118,101,115,116,97,116,101,0,0,0,13,
  100,97,116,97,114,111,119,104,101,105,103,104,116,2,18,11,111,110,99,101,
  108,108,101,118,101,110,116,7,15,103,114,105,100,111,110,99,101,108,108,101,
  118,101,110,116,13,114,101,102,102,111,110,116,104,101,105,103,104,116,2,16,
  0,0,11,116,115,116,114,105,110,103,100,105,115,112,8,102,105,108,101,100,
  105,115,112,8,98,111,117,110,100,115,95,120,2,71,9,98,111,117,110,100,
  115,95,99,120,3,172,0,11,102,114,97,109,101,46,100,117,109,109,121,2,
  0,7,97,110,99,104,111,114,115,11,7,97,110,95,108,101,102,116,6,97,
  110,95,116,111,112,8,97,110,95,114,105,103,104,116,0,8,116,97,98,111,
  114,100,101,114,2,1,13,114,101,102,102,111,110,116,104,101,105,103,104,116,
  2,16,0,0,11,116,115,116,114,105,110,103,100,105,115,112,7,97,100,100,
  114,101,115,115,8,98,111,117,110,100,115,95,120,2,1,9,98,111,117,110,
  100,115,95,99,120,2,70,11,102,114,97,109,101,46,100,117,109,109,121,2,
  0,9,116,101,120,116,102,108,97,103,115,11,12,116,102,95,120,99,101,110,
  116,101,114,101,100,12,116,102,95,121,99,101,110,116,101,114,101,100,0,13,
  114,101,102,102,111,110,116,104,101,105,103,104,116,2,16,0,0,10,116,112,
  111,112,117,112,109,101,110,117,11,116,112,111,112,117,112,109,101,110,117,49,
  18,109,101,110,117,46,115,117,98,109,101,110,117,46,99,111,117,110,116,2,
  1,18,109,101,110,117,46,115,117,98,109,101,110,117,46,105,116,101,109,115,
  14,1,7,99,97,112,116,105,111,110,6,17,67,111,112,121,32,116,111,32,
  99,108,105,112,98,111,97,114,100,9,111,110,101,120,101,99,117,116,101,7,
  15,99,111,112,121,116,111,99,108,105,112,98,111,97,114,100,0,0,4,108,
  101,102,116,2,48,3,116,111,112,2,56,0,0,0)
 );

initialization
 registerobjectdata(@objdata,tstackfo,'');
end.

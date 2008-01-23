unit objectinspector_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface

implementation
uses
 mseclasses,objectinspector;

const
 objdata: record size: integer; data: array[0..5744] of byte end =
      (size: 5745; data: (
  84,80,70,48,18,116,111,98,106,101,99,116,105,110,115,112,101,99,116,111,
  114,102,111,17,111,98,106,101,99,116,105,110,115,112,101,99,116,111,114,102,
  111,13,111,112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,
  97,114,114,111,119,102,111,99,117,115,15,111,119,95,97,114,114,111,119,102,
  111,99,117,115,105,110,16,111,119,95,97,114,114,111,119,102,111,99,117,115,
  111,117,116,11,111,119,95,115,117,98,102,111,99,117,115,17,111,119,95,100,
  101,115,116,114,111,121,119,105,100,103,101,116,115,9,111,119,95,104,105,110,
  116,111,110,12,111,119,95,97,117,116,111,115,99,97,108,101,0,8,98,111,
  117,110,100,115,95,120,3,98,1,8,98,111,117,110,100,115,95,121,3,147,
  1,9,98,111,117,110,100,115,95,99,120,3,254,0,9,98,111,117,110,100,
  115,95,99,121,3,248,0,15,102,114,97,109,101,46,103,114,105,112,95,115,
  105,122,101,2,10,18,102,114,97,109,101,46,103,114,105,112,95,111,112,116,
  105,111,110,115,11,14,103,111,95,99,108,111,115,101,98,117,116,116,111,110,
  16,103,111,95,102,105,120,115,105,122,101,98,117,116,116,111,110,12,103,111,
  95,116,111,112,98,117,116,116,111,110,19,103,111,95,98,97,99,107,103,114,
  111,117,110,100,98,117,116,116,111,110,0,11,102,114,97,109,101,46,100,117,
  109,109,121,2,0,8,116,97,98,111,114,100,101,114,2,1,7,118,105,115,
  105,98,108,101,8,23,99,111,110,116,97,105,110,101,114,46,111,112,116,105,
  111,110,115,119,105,100,103,101,116,11,13,111,119,95,109,111,117,115,101,102,
  111,99,117,115,11,111,119,95,116,97,98,102,111,99,117,115,13,111,119,95,
  97,114,114,111,119,102,111,99,117,115,15,111,119,95,97,114,114,111,119,102,
  111,99,117,115,105,110,16,111,119,95,97,114,114,111,119,102,111,99,117,115,
  111,117,116,11,111,119,95,115,117,98,102,111,99,117,115,19,111,119,95,109,
  111,117,115,101,116,114,97,110,115,112,97,114,101,110,116,17,111,119,95,100,
  101,115,116,114,111,121,119,105,100,103,101,116,115,12,111,119,95,97,117,116,
  111,115,99,97,108,101,0,18,99,111,110,116,97,105,110,101,114,46,98,111,
  117,110,100,115,95,120,2,0,18,99,111,110,116,97,105,110,101,114,46,98,
  111,117,110,100,115,95,121,2,0,19,99,111,110,116,97,105,110,101,114,46,
  98,111,117,110,100,115,95,99,120,3,244,0,19,99,111,110,116,97,105,110,
  101,114,46,98,111,117,110,100,115,95,99,121,3,248,0,21,99,111,110,116,
  97,105,110,101,114,46,102,114,97,109,101,46,100,117,109,109,121,2,0,23,
  99,111,110,116,97,105,110,101,114,46,111,110,99,104,105,108,100,115,99,97,
  108,101,100,7,28,111,98,106,101,99,116,105,110,115,112,101,99,116,111,114,
  111,110,99,104,105,108,100,115,99,97,108,101,100,22,100,114,97,103,100,111,
  99,107,46,115,112,108,105,116,116,101,114,95,115,105,122,101,2,0,16,100,
  114,97,103,100,111,99,107,46,99,97,112,116,105,111,110,6,15,79,98,106,
  101,99,116,105,110,115,112,101,99,116,111,114,20,100,114,97,103,100,111,99,
  107,46,111,112,116,105,111,110,115,100,111,99,107,11,10,111,100,95,115,97,
  118,101,112,111,115,10,111,100,95,99,97,110,109,111,118,101,11,111,100,95,
  99,97,110,102,108,111,97,116,10,111,100,95,99,97,110,100,111,99,107,11,
  111,100,95,112,114,111,112,115,105,122,101,0,7,111,112,116,105,111,110,115,
  11,10,102,111,95,115,97,118,101,112,111,115,12,102,111,95,115,97,118,101,
  115,116,97,116,101,0,8,115,116,97,116,102,105,108,101,7,22,109,97,105,
  110,102,111,46,112,114,111,106,101,99,116,115,116,97,116,102,105,108,101,7,
  99,97,112,116,105,111,110,6,16,79,98,106,101,99,116,32,73,110,115,112,
  101,99,116,111,114,21,105,99,111,110,46,116,114,97,110,115,112,97,114,101,
  110,116,99,111,108,111,114,4,6,0,0,128,12,105,99,111,110,46,111,112,
  116,105,111,110,115,11,10,98,109,111,95,109,97,115,107,101,100,0,10,105,
  99,111,110,46,105,109,97,103,101,10,96,1,0,0,0,0,0,0,2,0,
  0,0,24,0,0,0,24,0,0,0,204,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,192,192,192,52,0,252,248,4,192,192,192,19,0,252,
  248,6,192,192,192,17,0,252,248,8,192,192,192,16,0,252,248,8,192,192,
  192,16,0,252,248,8,192,192,192,16,0,252,248,8,192,192,192,17,0,252,
  248,6,192,192,192,8,0,0,248,1,192,192,192,10,0,252,248,4,192,192,
  192,8,0,0,248,3,192,192,192,21,0,0,248,3,192,192,192,20,0,0,
  248,5,192,192,192,18,0,0,248,7,192,192,192,16,0,0,248,9,192,192,
  192,15,0,0,248,9,192,192,192,4,248,0,0,8,192,192,192,2,0,0,
  248,11,192,192,192,3,248,0,0,8,192,192,192,2,0,0,248,11,192,192,
  192,3,248,0,0,8,192,192,192,16,248,0,0,8,192,192,192,16,248,0,
  0,8,192,192,192,16,248,0,0,8,192,192,192,16,248,0,0,8,192,192,
  192,16,248,0,0,8,192,192,192,38,0,0,0,0,0,0,0,0,240,0,
  0,191,248,1,0,8,252,3,0,0,252,3,0,0,252,3,0,0,252,3,
  0,0,248,1,2,0,240,0,7,0,0,0,7,0,0,128,15,3,0,192,
  31,0,0,224,63,0,0,224,63,191,252,243,127,8,252,243,127,0,252,3,
  0,3,252,3,0,64,252,3,0,0,252,3,0,0,252,3,0,0,252,3,
  0,0,0,0,0,0,8,111,110,99,114,101,97,116,101,7,14,116,109,115,
  101,102,111,114,109,99,114,101,97,116,101,16,111,110,101,118,101,110,116,108,
  111,111,112,115,116,97,114,116,7,25,111,98,106,101,99,116,105,110,115,112,
  101,99,116,111,114,102,111,111,110,108,111,97,100,101,100,13,111,110,99,104,
  105,108,100,115,99,97,108,101,100,7,28,111,98,106,101,99,116,105,110,115,
  112,101,99,116,111,114,111,110,99,104,105,108,100,115,99,97,108,101,100,4,
  108,101,102,116,3,239,0,3,116,111,112,3,180,0,15,109,111,100,117,108,
  101,99,108,97,115,115,110,97,109,101,6,9,116,100,111,99,107,102,111,114,
  109,0,17,116,100,114,111,112,100,111,119,110,108,105,115,116,101,100,105,116,
  12,99,111,109,112,115,101,108,101,99,116,111,114,13,111,112,116,105,111,110,
  115,119,105,100,103,101,116,11,13,111,119,95,109,111,117,115,101,102,111,99,
  117,115,11,111,119,95,116,97,98,102,111,99,117,115,13,111,119,95,97,114,
  114,111,119,102,111,99,117,115,15,111,119,95,97,114,114,111,119,102,111,99,
  117,115,105,110,16,111,119,95,97,114,114,111,119,102,111,99,117,115,111,117,
  116,17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,18,
  111,119,95,102,111,110,116,103,108,121,112,104,104,101,105,103,104,116,12,111,
  119,95,97,117,116,111,115,99,97,108,101,0,8,98,111,117,110,100,115,95,
  120,2,0,8,98,111,117,110,100,115,95,121,2,1,9,98,111,117,110,100,
  115,95,99,120,3,220,0,9,98,111,117,110,100,115,95,99,121,2,20,11,
  102,114,97,109,101,46,100,117,109,109,121,2,0,7,97,110,99,104,111,114,
  115,11,7,97,110,95,108,101,102,116,6,97,110,95,116,111,112,8,97,110,
  95,114,105,103,104,116,0,8,116,97,98,111,114,100,101,114,2,2,10,111,
  110,115,101,116,118,97,108,117,101,7,22,99,111,109,112,115,101,108,101,99,
  116,111,114,111,110,115,101,116,118,97,108,117,101,16,100,114,111,112,100,111,
  119,110,46,111,112,116,105,111,110,115,11,14,100,101,111,95,115,101,108,101,
  99,116,111,110,108,121,16,100,101,111,95,97,117,116,111,100,114,111,112,100,
  111,119,110,15,100,101,111,95,107,101,121,100,114,111,112,100,111,119,110,0,
  19,100,114,111,112,100,111,119,110,46,99,111,108,115,46,99,111,117,110,116,
  2,1,19,100,114,111,112,100,111,119,110,46,99,111,108,115,46,105,116,101,
  109,115,14,1,0,0,16,111,110,98,101,102,111,114,101,100,114,111,112,100,
  111,119,110,7,26,99,111,109,112,115,101,108,101,99,116,111,114,98,101,102,
  111,114,101,100,114,111,112,100,111,119,110,13,114,101,102,102,111,110,116,104,
  101,105,103,104,116,2,14,0,0,11,116,119,105,100,103,101,116,103,114,105,
  100,4,103,114,105,100,13,111,112,116,105,111,110,115,119,105,100,103,101,116,
  11,13,111,119,95,109,111,117,115,101,102,111,99,117,115,11,111,119,95,116,
  97,98,102,111,99,117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,
  115,15,111,119,95,97,114,114,111,119,102,111,99,117,115,105,110,16,111,119,
  95,97,114,114,111,119,102,111,99,117,115,111,117,116,17,111,119,95,102,111,
  99,117,115,98,97,99,107,111,110,101,115,99,13,111,119,95,109,111,117,115,
  101,119,104,101,101,108,17,111,119,95,100,101,115,116,114,111,121,119,105,100,
  103,101,116,115,18,111,119,95,102,111,110,116,103,108,121,112,104,104,101,105,
  103,104,116,12,111,119,95,97,117,116,111,115,99,97,108,101,0,8,98,111,
  117,110,100,115,95,120,2,0,8,98,111,117,110,100,115,95,121,2,24,9,
  98,111,117,110,100,115,95,99,120,3,244,0,9,98,111,117,110,100,115,95,
  99,121,3,224,0,16,102,114,97,109,101,46,108,111,99,97,108,112,114,111,
  112,115,11,10,102,114,108,95,108,101,118,101,108,111,15,102,114,108,95,99,
  111,108,111,114,99,108,105,101,110,116,0,11,102,114,97,109,101,46,100,117,
  109,109,121,2,0,7,97,110,99,104,111,114,115,11,6,97,110,95,116,111,
  112,9,97,110,95,98,111,116,116,111,109,0,8,116,97,98,111,114,100,101,
  114,2,1,9,112,111,112,117,112,109,101,110,117,7,11,116,112,111,112,117,
  112,109,101,110,117,49,11,111,112,116,105,111,110,115,103,114,105,100,11,12,
  111,103,95,99,111,108,115,105,122,105,110,103,12,111,103,95,99,111,108,109,
  111,118,105,110,103,19,111,103,95,102,111,99,117,115,99,101,108,108,111,110,
  101,110,116,101,114,20,111,103,95,99,111,108,99,104,97,110,103,101,111,110,
  116,97,98,107,101,121,0,15,114,111,119,99,111,108,111,114,115,46,99,111,
  117,110,116,2,1,15,114,111,119,99,111,108,111,114,115,46,105,116,101,109,
  115,1,4,242,255,255,0,0,14,114,111,119,102,111,110,116,115,46,99,111,
  117,110,116,2,6,14,114,111,119,102,111,110,116,115,46,105,116,101,109,115,
  14,1,4,110,97,109,101,6,11,115,116,102,95,100,101,102,97,117,108,116,
  6,120,115,99,97,108,101,5,0,0,0,0,0,0,0,128,255,63,5,100,
  117,109,109,121,2,0,0,1,5,99,111,108,111,114,4,0,128,0,0,4,
  110,97,109,101,6,11,115,116,102,95,100,101,102,97,117,108,116,6,120,115,
  99,97,108,101,5,0,0,0,0,0,0,0,128,255,63,5,100,117,109,109,
  121,2,0,0,1,5,99,111,108,111,114,4,0,128,0,0,4,110,97,109,
  101,6,11,115,116,102,95,100,101,102,97,117,108,116,6,120,115,99,97,108,
  101,5,0,0,0,0,0,0,0,128,255,63,5,100,117,109,109,121,2,0,
  0,1,5,99,111,108,111,114,4,13,0,0,160,4,110,97,109,101,6,11,
  115,116,102,95,100,101,102,97,117,108,116,6,120,115,99,97,108,101,5,0,
  0,0,0,0,0,0,128,255,63,5,100,117,109,109,121,2,0,0,1,5,
  115,116,121,108,101,11,7,102,115,95,98,111,108,100,0,4,110,97,109,101,
  6,11,115,116,102,95,100,101,102,97,117,108,116,6,120,115,99,97,108,101,
  5,0,0,0,0,0,0,0,128,255,63,5,100,117,109,109,121,2,0,0,
  1,5,115,116,121,108,101,11,7,102,115,95,98,111,108,100,0,4,110,97,
  109,101,6,11,115,116,102,95,100,101,102,97,117,108,116,6,120,115,99,97,
  108,101,5,0,0,0,0,0,0,0,128,255,63,5,100,117,109,109,121,2,
  0,0,0,14,100,97,116,97,99,111,108,115,46,99,111,117,110,116,2,2,
  14,100,97,116,97,99,111,108,115,46,105,116,101,109,115,14,1,9,108,105,
  110,101,99,111,108,111,114,4,5,0,0,160,12,108,105,110,101,99,111,108,
  111,114,102,105,120,4,3,0,0,160,5,119,105,100,116,104,2,90,7,111,
  112,116,105,111,110,115,11,11,99,111,95,114,101,97,100,111,110,108,121,12,
  99,111,95,100,114,97,119,102,111,99,117,115,15,99,111,95,112,114,111,112,
  111,114,116,105,111,110,97,108,12,99,111,95,115,97,118,101,115,116,97,116,
  101,10,99,111,95,114,111,119,102,111,110,116,11,99,111,95,114,111,119,99,
  111,108,111,114,13,99,111,95,122,101,98,114,97,99,111,108,111,114,0,10,
  111,110,115,104,111,119,104,105,110,116,7,14,99,111,108,48,111,110,115,104,
  111,119,104,105,110,116,10,119,105,100,103,101,116,110,97,109,101,6,5,112,
  114,111,112,115,0,1,12,108,105,110,101,99,111,108,111,114,102,105,120,4,
  3,0,0,160,5,119,105,100,116,104,3,148,0,13,114,111,119,102,111,110,
  116,111,102,102,115,101,116,2,4,7,111,112,116,105,111,110,115,11,7,99,
  111,95,102,105,108,108,12,99,111,95,115,97,118,101,115,116,97,116,101,10,
  99,111,95,114,111,119,102,111,110,116,13,99,111,95,122,101,98,114,97,99,
  111,108,111,114,0,10,111,110,115,104,111,119,104,105,110,116,7,14,99,111,
  108,49,111,110,115,104,111,119,104,105,110,116,10,119,105,100,103,101,116,110,
  97,109,101,6,6,118,97,108,117,101,115,0,0,16,100,97,116,97,114,111,
  119,108,105,110,101,99,111,108,111,114,4,5,0,0,160,13,100,97,116,97,
  114,111,119,104,101,105,103,104,116,2,16,8,115,116,97,116,102,105,108,101,
  7,22,109,97,105,110,102,111,46,112,114,111,106,101,99,116,115,116,97,116,
  102,105,108,101,17,111,110,114,111,119,115,100,97,116,97,99,104,97,110,103,
  101,100,7,19,103,114,105,100,114,111,119,115,100,97,116,97,99,104,97,110,
  103,101,100,11,111,110,99,101,108,108,101,118,101,110,116,7,13,103,114,105,
  100,99,101,108,108,101,118,101,110,116,22,100,114,97,103,46,111,110,98,101,
  102,111,114,101,100,114,97,103,98,101,103,105,110,7,15,103,114,105,100,111,
  110,100,114,97,103,98,101,103,105,110,21,100,114,97,103,46,111,110,98,101,
  102,111,114,101,100,114,97,103,111,118,101,114,7,14,103,114,105,100,111,110,
  100,114,97,103,111,118,101,114,21,100,114,97,103,46,111,110,98,101,102,111,
  114,101,100,114,97,103,100,114,111,112,7,14,103,114,105,100,111,110,100,114,
  97,103,100,114,111,112,13,114,101,102,102,111,110,116,104,101,105,103,104,116,
  2,14,0,13,116,116,114,101,101,105,116,101,109,101,100,105,116,5,112,114,
  111,112,115,13,111,112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,
  119,95,109,111,117,115,101,102,111,99,117,115,11,111,119,95,116,97,98,102,
  111,99,117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,115,15,111,
  119,95,97,114,114,111,119,102,111,99,117,115,105,110,16,111,119,95,97,114,
  114,111,119,102,111,99,117,115,111,117,116,17,111,119,95,100,101,115,116,114,
  111,121,119,105,100,103,101,116,115,18,111,119,95,102,111,110,116,103,108,121,
  112,104,104,101,105,103,104,116,12,111,119,95,97,117,116,111,115,99,97,108,
  101,0,8,98,111,117,110,100,115,95,120,2,0,8,98,111,117,110,100,115,
  95,121,2,0,9,98,111,117,110,100,115,95,99,120,2,90,9,98,111,117,
  110,100,115,95,99,121,2,16,5,99,111,108,111,114,4,7,0,0,144,12,
  102,114,97,109,101,46,108,101,118,101,108,111,2,0,17,102,114,97,109,101,
  46,99,111,108,111,114,99,108,105,101,110,116,4,2,0,0,128,16,102,114,
  97,109,101,46,108,111,99,97,108,112,114,111,112,115,11,10,102,114,108,95,
  108,101,118,101,108,111,15,102,114,108,95,99,111,108,111,114,99,108,105,101,
  110,116,0,11,102,114,97,109,101,46,100,117,109,109,121,2,0,8,116,97,
  98,111,114,100,101,114,2,1,7,111,110,112,111,112,117,112,7,12,112,114,
  111,112,115,111,110,112,111,112,117,112,7,118,105,115,105,98,108,101,8,11,
  111,112,116,105,111,110,115,101,100,105,116,11,11,111,101,95,114,101,97,100,
  111,110,108,121,12,111,101,95,117,110,100,111,111,110,101,115,99,13,111,101,
  95,99,108,111,115,101,113,117,101,114,121,16,111,101,95,99,104,101,99,107,
  109,114,99,97,110,99,101,108,15,111,101,95,101,120,105,116,111,110,99,117,
  114,115,111,114,20,111,101,95,114,101,115,101,116,115,101,108,101,99,116,111,
  110,101,120,105,116,9,111,101,95,108,111,99,97,116,101,12,111,101,95,115,
  97,118,101,115,116,97,116,101,0,17,111,110,117,112,100,97,116,101,114,111,
  119,118,97,108,117,101,115,7,18,112,114,111,112,117,112,100,97,116,101,114,
  111,119,118,97,108,117,101,7,111,112,116,105,111,110,115,11,16,116,101,111,
  95,116,114,101,101,99,111,108,110,97,118,105,103,16,116,101,111,95,107,101,
  121,114,111,119,109,111,118,105,110,103,0,14,111,110,99,104,101,99,107,114,
  111,119,109,111,118,101,7,19,112,114,111,112,115,111,110,99,104,101,99,107,
  114,111,119,109,111,118,101,13,114,101,102,102,111,110,116,104,101,105,103,104,
  116,2,14,0,0,19,116,109,98,100,114,111,112,100,111,119,110,105,116,101,
  109,101,100,105,116,6,118,97,108,117,101,115,13,111,112,116,105,111,110,115,
  119,105,100,103,101,116,11,13,111,119,95,109,111,117,115,101,102,111,99,117,
  115,11,111,119,95,116,97,98,102,111,99,117,115,13,111,119,95,97,114,114,
  111,119,102,111,99,117,115,15,111,119,95,97,114,114,111,119,102,111,99,117,
  115,105,110,16,111,119,95,97,114,114,111,119,102,111,99,117,115,111,117,116,
  17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,18,111,
  119,95,102,111,110,116,103,108,121,112,104,104,101,105,103,104,116,0,8,98,
  111,117,110,100,115,95,120,2,91,8,98,111,117,110,100,115,95,121,2,0,
  9,98,111,117,110,100,115,95,99,120,3,148,0,9,98,111,117,110,100,115,
  95,99,121,2,16,5,99,111,108,111,114,4,7,0,0,144,12,102,114,97,
  109,101,46,108,101,118,101,108,111,2,0,17,102,114,97,109,101,46,99,111,
  108,111,114,99,108,105,101,110,116,4,2,0,0,128,16,102,114,97,109,101,
  46,108,111,99,97,108,112,114,111,112,115,11,10,102,114,108,95,108,101,118,
  101,108,111,15,102,114,108,95,99,111,108,111,114,99,108,105,101,110,116,0,
  18,102,114,97,109,101,46,98,117,116,116,111,110,46,119,105,100,116,104,2,
  15,18,102,114,97,109,101,46,98,117,116,116,111,110,46,99,111,108,111,114,
  4,5,0,0,144,19,102,114,97,109,101,46,98,117,116,116,111,110,115,46,
  99,111,117,110,116,2,2,19,102,114,97,109,101,46,98,117,116,116,111,110,
  115,46,105,116,101,109,115,14,1,5,119,105,100,116,104,2,15,5,99,111,
  108,111,114,4,5,0,0,144,0,1,5,119,105,100,116,104,2,15,5,99,
  111,108,111,114,4,5,0,0,144,7,105,109,97,103,101,110,114,2,17,0,
  0,11,102,114,97,109,101,46,100,117,109,109,121,2,0,8,116,97,98,111,
  114,100,101,114,2,2,7,118,105,115,105,98,108,101,8,11,111,112,116,105,
  111,110,115,101,100,105,116,11,12,111,101,95,117,110,100,111,111,110,101,115,
  99,13,111,101,95,99,108,111,115,101,113,117,101,114,121,16,111,101,95,99,
  104,101,99,107,109,114,99,97,110,99,101,108,15,111,101,95,101,120,105,116,
  111,110,99,117,114,115,111,114,24,111,101,95,102,111,114,99,101,114,101,116,
  117,114,110,99,104,101,99,107,118,97,108,117,101,12,111,101,95,101,97,116,
  114,101,116,117,114,110,20,111,101,95,114,101,115,101,116,115,101,108,101,99,
  116,111,110,101,120,105,116,13,111,101,95,97,117,116,111,115,101,108,101,99,
  116,25,111,101,95,97,117,116,111,115,101,108,101,99,116,111,110,102,105,114,
  115,116,99,108,105,99,107,16,111,101,95,97,117,116,111,112,111,112,117,112,
  109,101,110,117,12,111,101,95,115,97,118,101,115,116,97,116,101,0,9,102,
  111,110,116,46,110,97,109,101,6,11,115,116,102,95,100,101,102,97,117,108,
  116,11,102,111,110,116,46,120,115,99,97,108,101,5,0,0,0,0,0,0,
  0,128,255,63,10,102,111,110,116,46,100,117,109,109,121,2,0,9,111,110,
  107,101,121,100,111,119,110,7,13,118,97,108,117,101,115,107,101,121,100,111,
  119,110,10,111,110,115,101,116,118,97,108,117,101,7,14,118,97,108,117,101,
  115,115,101,116,118,97,108,117,101,12,111,110,109,111,117,115,101,101,118,101,
  110,116,7,18,118,97,108,117,101,115,111,110,109,111,117,115,101,101,118,101,
  110,116,14,111,110,98,117,116,116,111,110,97,99,116,105,111,110,7,18,118,
  97,108,117,101,115,98,117,116,116,111,110,97,99,116,105,111,110,17,111,110,
  117,112,100,97,116,101,114,111,119,118,97,108,117,101,115,7,19,118,97,108,
  117,101,117,112,100,97,116,101,114,111,119,118,97,108,117,101,16,100,114,111,
  112,100,111,119,110,46,111,112,116,105,111,110,115,11,16,100,101,111,95,97,
  117,116,111,100,114,111,112,100,111,119,110,15,100,101,111,95,107,101,121,100,
  114,111,112,100,111,119,110,12,100,101,111,95,99,108,105,112,104,105,110,116,
  0,25,100,114,111,112,100,111,119,110,46,100,114,111,112,100,111,119,110,114,
  111,119,99,111,117,110,116,2,16,19,100,114,111,112,100,111,119,110,46,99,
  111,108,115,46,99,111,117,110,116,2,1,19,100,114,111,112,100,111,119,110,
  46,99,111,108,115,46,105,116,101,109,115,14,1,0,0,16,111,110,98,101,
  102,111,114,101,100,114,111,112,100,111,119,110,7,20,118,97,108,117,101,115,
  98,101,102,111,114,101,100,114,111,112,100,111,119,110,13,114,101,102,102,111,
  110,116,104,101,105,103,104,116,2,14,0,0,0,7,116,98,117,116,116,111,
  110,8,99,111,109,112,101,100,105,116,13,111,112,116,105,111,110,115,119,105,
  100,103,101,116,11,13,111,119,95,109,111,117,115,101,102,111,99,117,115,11,
  111,119,95,116,97,98,102,111,99,117,115,13,111,119,95,97,114,114,111,119,
  102,111,99,117,115,15,111,119,95,97,114,114,111,119,102,111,99,117,115,105,
  110,16,111,119,95,97,114,114,111,119,102,111,99,117,115,111,117,116,17,111,
  119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,18,111,119,95,
  102,111,110,116,103,108,121,112,104,104,101,105,103,104,116,12,111,119,95,97,
  117,116,111,115,99,97,108,101,0,8,98,111,117,110,100,115,95,120,3,223,
  0,8,98,111,117,110,100,115,95,121,2,2,9,98,111,117,110,100,115,95,
  99,120,2,19,9,98,111,117,110,100,115,95,99,121,2,18,7,97,110,99,
  104,111,114,115,11,6,97,110,95,116,111,112,8,97,110,95,114,105,103,104,
  116,0,4,104,105,110,116,6,22,83,104,111,119,32,99,111,109,112,111,110,
  101,110,116,32,101,100,105,116,111,114,46,5,115,116,97,116,101,11,11,97,
  115,95,100,105,115,97,98,108,101,100,16,97,115,95,108,111,99,97,108,100,
  105,115,97,98,108,101,100,15,97,115,95,108,111,99,97,108,99,97,112,116,
  105,111,110,12,97,115,95,108,111,99,97,108,104,105,110,116,17,97,115,95,
  108,111,99,97,108,111,110,101,120,101,99,117,116,101,0,7,99,97,112,116,
  105,111,110,6,2,69,68,9,111,110,101,120,101,99,117,116,101,7,17,99,
  111,109,112,101,100,105,116,111,110,101,120,101,99,117,116,101,13,114,101,102,
  102,111,110,116,104,101,105,103,104,116,2,14,0,0,10,116,112,111,112,117,
  112,109,101,110,117,11,116,112,111,112,117,112,109,101,110,117,49,18,109,101,
  110,117,46,115,117,98,109,101,110,117,46,99,111,117,110,116,2,1,18,109,
  101,110,117,46,115,117,98,109,101,110,117,46,105,116,101,109,115,14,1,7,
  99,97,112,116,105,111,110,6,13,67,111,108,108,97,112,115,101,32,116,114,
  101,101,5,115,116,97,116,101,11,15,97,115,95,108,111,99,97,108,99,97,
  112,116,105,111,110,17,97,115,95,108,111,99,97,108,111,110,101,120,101,99,
  117,116,101,0,9,111,110,101,120,101,99,117,116,101,7,11,99,111,108,108,
  97,112,115,101,101,120,101,0,0,4,108,101,102,116,2,112,3,116,111,112,
  2,80,0,0,0)
 );

initialization
 registerobjectdata(@objdata,tobjectinspectorfo,'');
end.

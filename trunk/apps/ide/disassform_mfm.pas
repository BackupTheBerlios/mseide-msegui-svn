unit disassform_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,disassform;

const
 objdata: record size: integer; data: array[0..2723] of byte end =
      (size: 2724; data: (
  84,80,70,48,9,116,100,105,115,97,115,115,102,111,8,100,105,115,97,115,
  115,102,111,13,111,112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,
  119,95,97,114,114,111,119,102,111,99,117,115,15,111,119,95,97,114,114,111,
  119,102,111,99,117,115,105,110,16,111,119,95,97,114,114,111,119,102,111,99,
  117,115,111,117,116,11,111,119,95,115,117,98,102,111,99,117,115,17,111,119,
  95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,9,111,119,95,104,
  105,110,116,111,110,12,111,119,95,97,117,116,111,115,99,97,108,101,0,8,
  98,111,117,110,100,115,95,120,3,162,0,8,98,111,117,110,100,115,95,121,
  3,246,1,9,98,111,117,110,100,115,95,99,120,3,52,2,9,98,111,117,
  110,100,115,95,99,121,3,210,0,15,102,114,97,109,101,46,103,114,105,112,
  95,115,105,122,101,2,10,18,102,114,97,109,101,46,103,114,105,112,95,111,
  112,116,105,111,110,115,11,14,103,111,95,99,108,111,115,101,98,117,116,116,
  111,110,16,103,111,95,102,105,120,115,105,122,101,98,117,116,116,111,110,12,
  103,111,95,116,111,112,98,117,116,116,111,110,0,11,102,114,97,109,101,46,
  100,117,109,109,121,2,0,8,116,97,98,111,114,100,101,114,2,1,7,118,
  105,115,105,98,108,101,8,23,99,111,110,116,97,105,110,101,114,46,111,112,
  116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,109,111,117,115,
  101,102,111,99,117,115,11,111,119,95,116,97,98,102,111,99,117,115,13,111,
  119,95,97,114,114,111,119,102,111,99,117,115,15,111,119,95,97,114,114,111,
  119,102,111,99,117,115,105,110,16,111,119,95,97,114,114,111,119,102,111,99,
  117,115,111,117,116,11,111,119,95,115,117,98,102,111,99,117,115,19,111,119,
  95,109,111,117,115,101,116,114,97,110,115,112,97,114,101,110,116,17,111,119,
  95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,12,111,119,95,97,
  117,116,111,115,99,97,108,101,0,18,99,111,110,116,97,105,110,101,114,46,
  98,111,117,110,100,115,95,120,2,0,18,99,111,110,116,97,105,110,101,114,
  46,98,111,117,110,100,115,95,121,2,0,19,99,111,110,116,97,105,110,101,
  114,46,98,111,117,110,100,115,95,99,120,3,42,2,19,99,111,110,116,97,
  105,110,101,114,46,98,111,117,110,100,115,95,99,121,3,210,0,21,99,111,
  110,116,97,105,110,101,114,46,102,114,97,109,101,46,100,117,109,109,121,2,
  0,22,100,114,97,103,100,111,99,107,46,115,112,108,105,116,116,101,114,95,
  115,105,122,101,2,0,16,100,114,97,103,100,111,99,107,46,99,97,112,116,
  105,111,110,6,9,65,115,115,101,109,98,108,101,114,20,100,114,97,103,100,
  111,99,107,46,111,112,116,105,111,110,115,100,111,99,107,11,10,111,100,95,
  115,97,118,101,112,111,115,10,111,100,95,99,97,110,109,111,118,101,11,111,
  100,95,99,97,110,102,108,111,97,116,10,111,100,95,99,97,110,100,111,99,
  107,11,111,100,95,112,114,111,112,115,105,122,101,0,7,111,112,116,105,111,
  110,115,11,10,102,111,95,115,97,118,101,112,111,115,12,102,111,95,115,97,
  118,101,115,116,97,116,101,0,8,115,116,97,116,102,105,108,101,7,22,109,
  97,105,110,102,111,46,112,114,111,106,101,99,116,115,116,97,116,102,105,108,
  101,7,99,97,112,116,105,111,110,6,9,65,115,115,101,109,98,108,101,114,
  21,105,99,111,110,46,116,114,97,110,115,112,97,114,101,110,116,99,111,108,
  111,114,4,6,0,0,128,12,105,99,111,110,46,111,112,116,105,111,110,115,
  11,10,98,109,111,95,109,97,115,107,101,100,0,10,105,99,111,110,46,105,
  109,97,103,101,10,212,3,0,0,0,0,0,0,2,0,0,0,24,0,0,
  0,24,0,0,0,64,3,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,128,76,240,26,224,224,224,15,128,76,240,9,224,224,224,1,168,236,232,
  13,224,224,224,1,168,236,232,1,128,76,240,8,224,224,224,1,168,236,232,
  13,224,224,224,1,168,236,232,2,128,76,240,7,224,224,224,1,168,236,232,
  13,224,224,224,1,168,236,232,3,128,76,240,6,224,224,224,1,168,236,232,
  13,224,224,224,1,168,236,232,4,128,76,240,5,224,224,224,1,168,236,232,
  13,128,128,128,6,128,76,240,4,224,224,224,1,168,236,232,18,128,128,128,
  1,128,76,240,4,224,224,224,1,168,236,232,2,168,232,232,1,128,180,176,
  1,104,148,144,1,136,184,184,1,168,236,232,6,152,208,208,1,136,188,184,
  1,160,216,216,1,168,236,232,3,128,128,128,1,128,76,240,4,224,224,224,
  1,168,236,232,1,168,228,232,1,48,68,64,1,8,16,16,1,40,60,56,
  1,8,8,8,1,64,84,80,1,168,232,232,1,168,236,232,2,112,152,152,
  1,16,20,16,1,0,0,0,2,104,148,144,1,168,236,232,3,128,128,128,
  1,128,76,240,4,224,224,224,1,168,236,232,1,96,128,128,1,8,16,16,
  1,152,208,208,1,168,236,232,1,144,196,192,1,0,4,0,1,112,152,152,
  1,168,236,232,2,128,180,176,1,112,152,152,1,144,200,200,1,0,0,0,
  1,104,148,144,1,168,236,232,3,128,128,128,1,128,76,240,4,224,224,224,
  1,168,236,232,1,32,44,40,1,72,96,96,1,168,236,232,3,56,76,72,
  1,48,68,64,1,168,236,232,5,0,0,0,1,104,148,144,1,168,236,232,
  3,128,128,128,1,128,76,240,4,224,224,224,1,168,232,232,1,0,4,0,
  1,104,140,144,1,168,236,232,3,88,120,120,1,16,24,24,1,168,236,232,
  5,0,0,0,1,104,148,144,1,168,236,232,3,128,128,128,1,128,76,240,
  4,224,224,224,1,160,220,216,1,0,0,0,1,112,156,160,1,168,236,232,
  3,96,136,136,1,0,8,8,1,168,236,232,5,0,0,0,1,104,148,144,
  1,168,236,232,3,128,128,128,1,128,76,240,4,224,224,224,1,160,224,224,
  1,0,0,0,1,112,156,152,1,168,236,232,3,96,132,136,1,8,8,8,
  1,168,236,232,5,0,0,0,1,104,148,144,1,168,236,232,3,128,128,128,
  1,128,76,240,4,224,224,224,1,168,232,232,1,0,8,8,1,96,136,136,
  1,168,236,232,3,80,112,112,1,16,28,32,1,168,236,232,5,0,0,0,
  1,104,148,144,1,168,236,232,3,128,128,128,1,128,76,240,4,224,224,224,
  1,168,236,232,1,40,56,56,1,56,84,80,1,168,236,232,3,40,60,56,
  1,56,80,80,1,168,236,232,5,0,0,0,1,104,148,144,1,168,236,232,
  3,128,128,128,1,128,76,240,4,224,224,224,1,168,236,232,1,112,152,152,
  1,0,4,0,1,128,180,176,1,168,236,232,1,120,164,160,1,0,0,0,
  1,128,176,176,1,168,236,232,2,160,224,224,1,144,196,200,2,0,0,0,
  1,88,128,128,1,144,196,200,1,152,212,208,1,168,236,232,1,128,128,128,
  1,128,76,240,4,224,224,224,1,168,236,232,2,80,108,104,1,0,4,0,
  1,8,16,16,1,0,4,0,1,96,128,128,1,168,236,232,3,128,172,168,
  1,0,0,0,5,64,92,88,1,168,236,232,1,128,128,128,1,128,76,240,
  4,224,224,224,1,168,236,232,3,160,216,216,1,136,192,192,1,160,220,224,
  1,168,236,232,12,128,128,128,1,128,76,240,4,224,224,224,1,168,236,232,
  18,128,128,128,1,128,76,240,4,224,224,224,1,168,236,232,18,128,128,128,
  1,128,76,240,4,128,128,128,20,128,76,240,26,0,0,0,8,252,255,1,
  0,252,255,3,191,252,255,7,8,252,255,15,8,252,255,31,0,252,255,63,
  8,252,255,63,8,252,255,63,8,252,255,63,8,252,255,63,191,252,255,63,
  8,252,255,63,3,252,255,63,8,252,255,63,191,252,255,63,8,252,255,63,
  0,252,255,63,3,252,255,63,64,252,255,63,0,252,255,63,191,252,255,63,
  0,252,255,63,0,0,0,0,0,6,111,110,115,104,111,119,7,14,100,105,
  115,97,115,115,102,111,111,110,115,104,111,119,15,109,111,100,117,108,101,99,
  108,97,115,115,110,97,109,101,6,9,116,100,111,99,107,102,111,114,109,0,
  11,116,115,116,114,105,110,103,103,114,105,100,4,103,114,105,100,13,111,112,
  116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,109,111,117,115,
  101,102,111,99,117,115,11,111,119,95,116,97,98,102,111,99,117,115,13,111,
  119,95,97,114,114,111,119,102,111,99,117,115,15,111,119,95,97,114,114,111,
  119,102,111,99,117,115,105,110,16,111,119,95,97,114,114,111,119,102,111,99,
  117,115,111,117,116,17,111,119,95,102,111,99,117,115,98,97,99,107,111,110,
  101,115,99,13,111,119,95,109,111,117,115,101,119,104,101,101,108,17,111,119,
  95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,18,111,119,95,102,
  111,110,116,103,108,121,112,104,104,101,105,103,104,116,12,111,119,95,97,117,
  116,111,115,99,97,108,101,0,8,98,111,117,110,100,115,95,120,2,0,8,
  98,111,117,110,100,115,95,121,2,0,9,98,111,117,110,100,115,95,99,120,
  3,42,2,9,98,111,117,110,100,115,95,99,121,3,210,0,5,99,111,108,
  111,114,4,5,0,0,144,11,102,114,97,109,101,46,100,117,109,109,121,2,
  0,7,97,110,99,104,111,114,115,11,0,9,111,110,107,101,121,100,111,119,
  110,7,5,107,101,121,100,111,11,111,112,116,105,111,110,115,103,114,105,100,
  11,12,111,103,95,99,111,108,115,105,122,105,110,103,20,111,103,95,99,111,
  108,99,104,97,110,103,101,111,110,116,97,98,107,101,121,12,111,103,95,97,
  117,116,111,112,111,112,117,112,0,14,100,97,116,97,99,111,108,115,46,99,
  111,117,110,116,2,2,16,100,97,116,97,99,111,108,115,46,111,112,116,105,
  111,110,115,11,11,99,111,95,114,101,97,100,111,110,108,121,12,99,111,95,
  100,114,97,119,102,111,99,117,115,12,99,111,95,115,97,118,101,115,116,97,
  116,101,0,14,100,97,116,97,99,111,108,115,46,105,116,101,109,115,14,1,
  5,119,105,100,116,104,2,76,7,111,112,116,105,111,110,115,11,11,99,111,
  95,114,101,97,100,111,110,108,121,12,99,111,95,100,114,97,119,102,111,99,
  117,115,12,99,111,95,115,97,118,101,115,116,97,116,101,11,99,111,95,114,
  111,119,99,111,108,111,114,0,11,111,112,116,105,111,110,115,101,100,105,116,
  11,14,115,99,111,101,95,101,97,116,114,101,116,117,114,110,0,0,1,5,
  119,105,100,116,104,3,216,1,7,111,112,116,105,111,110,115,11,11,99,111,
  95,114,101,97,100,111,110,108,121,12,99,111,95,100,114,97,119,102,111,99,
  117,115,7,99,111,95,102,105,108,108,12,99,111,95,115,97,118,101,115,116,
  97,116,101,11,99,111,95,114,111,119,99,111,108,111,114,0,9,116,101,120,
  116,102,108,97,103,115,11,12,116,102,95,121,99,101,110,116,101,114,101,100,
  11,116,102,95,110,111,115,101,108,101,99,116,13,116,102,95,116,97,98,116,
  111,115,112,97,99,101,0,15,116,101,120,116,102,108,97,103,115,97,99,116,
  105,118,101,11,12,116,102,95,121,99,101,110,116,101,114,101,100,13,116,102,
  95,116,97,98,116,111,115,112,97,99,101,0,11,111,112,116,105,111,110,115,
  101,100,105,116,11,14,115,99,111,101,95,101,97,116,114,101,116,117,114,110,
  0,0,0,15,114,111,119,99,111,108,111,114,115,46,99,111,117,110,116,2,
  2,15,114,111,119,99,111,108,111,114,115,46,105,116,101,109,115,1,4,255,
  255,224,0,4,224,255,255,0,0,13,100,97,116,97,114,111,119,104,101,105,
  103,104,116,2,16,13,114,101,102,102,111,110,116,104,101,105,103,104,116,2,
  14,0,0,0)
 );

initialization
 registerobjectdata(@objdata,tdisassfo,'');
end.

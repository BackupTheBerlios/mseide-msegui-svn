unit reportdesigner_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface

implementation
uses
 mseclasses,reportdesigner;

const
 objdata: record size: integer; data: array[0..3721] of byte end =
      (size: 3722; data: (
  84,80,70,48,241,17,116,114,101,112,111,114,116,100,101,115,105,103,110,101,
  114,102,111,16,114,101,112,111,114,116,100,101,115,105,103,110,101,114,102,111,
  8,98,111,117,110,100,115,95,120,3,161,1,8,98,111,117,110,100,115,95,
  121,2,127,9,98,111,117,110,100,115,95,99,120,3,205,0,9,98,111,117,
  110,100,115,95,99,121,3,203,1,5,99,111,108,111,114,4,1,0,0,128,
  19,99,111,110,116,97,105,110,101,114,46,98,111,117,110,100,115,95,99,120,
  3,205,0,19,99,111,110,116,97,105,110,101,114,46,98,111,117,110,100,115,
  95,99,121,3,203,1,15,99,111,110,116,97,105,110,101,114,46,99,111,108,
  111,114,4,7,0,0,144,21,99,111,110,116,97,105,110,101,114,46,102,114,
  97,109,101,46,100,117,109,109,121,2,0,23,99,111,110,116,97,105,110,101,
  114,46,111,110,99,104,105,108,100,115,99,97,108,101,100,7,14,114,101,112,
  99,104,105,108,100,115,99,97,108,101,100,29,99,111,110,116,97,105,110,101,
  114,46,111,110,99,97,108,99,109,105,110,115,99,114,111,108,108,115,105,122,
  101,13,27,99,111,110,116,97,105,110,101,114,46,111,110,99,104,105,108,100,
  109,111,117,115,101,101,118,101,110,116,7,21,114,101,112,111,114,116,99,104,
  105,108,100,109,111,117,115,101,101,118,101,110,116,21,105,99,111,110,46,116,
  114,97,110,115,112,97,114,101,110,116,99,111,108,111,114,4,0,0,0,128,
  17,105,99,111,110,46,116,114,97,110,115,112,97,114,101,110,99,121,4,0,
  0,0,128,10,105,99,111,110,46,105,109,97,103,101,10,12,2,0,0,0,
  0,0,0,2,0,0,0,24,0,0,0,24,0,0,0,120,1,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,128,76,240,25,248,252,248,22,128,
  76,240,2,248,252,248,1,248,0,0,16,248,252,248,1,192,192,192,3,128,
  128,128,1,128,76,240,2,248,252,248,1,248,0,0,16,248,252,248,1,192,
  192,192,1,0,0,0,1,192,192,192,1,128,128,128,1,128,76,240,2,248,
  252,248,1,248,0,0,16,248,252,248,1,192,192,192,3,128,128,128,1,128,
  76,240,2,248,252,248,1,128,128,128,16,248,252,248,1,128,128,128,4,128,
  76,240,2,248,252,248,1,192,192,192,20,128,128,128,1,128,76,240,2,248,
  252,248,1,192,192,192,20,128,128,128,1,128,76,240,2,248,252,248,1,192,
  192,192,20,128,128,128,1,128,76,240,2,248,252,248,1,192,192,192,20,128,
  128,128,1,128,76,240,2,248,252,248,1,192,192,192,20,128,128,128,1,128,
  76,240,2,248,252,248,1,192,192,192,20,128,128,128,1,128,76,240,2,248,
  252,248,1,192,192,192,20,128,128,128,1,128,76,240,2,248,252,248,1,192,
  192,192,20,128,128,128,1,128,76,240,2,248,252,248,1,192,192,192,20,128,
  128,128,1,128,76,240,2,248,252,248,1,192,192,192,20,128,128,128,1,128,
  76,240,2,248,252,248,1,192,192,192,20,128,128,128,1,128,76,240,2,248,
  252,248,1,192,192,192,20,128,128,128,1,128,76,240,2,248,252,248,1,192,
  192,192,20,128,128,128,1,128,76,240,2,248,252,248,1,192,192,192,20,128,
  128,128,1,128,76,240,2,248,252,248,1,192,192,192,20,128,128,128,1,128,
  76,240,2,248,252,248,1,192,192,192,20,128,128,128,1,128,76,240,2,128,
  128,128,22,128,76,240,25,0,0,0,9,254,255,127,8,254,255,127,191,254,
  255,127,8,254,255,127,191,254,255,127,0,254,255,127,191,254,255,127,183,254,
  255,127,0,254,255,127,191,254,255,127,0,254,255,127,3,254,255,127,0,254,
  255,127,0,254,255,127,191,254,255,127,8,254,255,127,0,254,255,127,3,254,
  255,127,64,254,255,127,0,254,255,127,0,254,255,127,183,254,255,127,191,0,
  0,0,8,7,111,110,99,108,111,115,101,13,8,111,110,114,101,115,105,122,
  101,7,11,102,111,114,109,114,101,115,105,122,101,100,13,111,110,99,104,105,
  108,100,115,99,97,108,101,100,7,14,114,101,112,99,104,105,108,100,115,99,
  97,108,101,100,15,109,111,100,117,108,101,99,108,97,115,115,110,97,109,101,
  6,15,84,102,111,114,109,100,101,115,105,103,110,101,114,102,111,0,242,2,
  0,5,116,100,105,97,108,5,100,105,97,108,104,8,98,111,117,110,100,115,
  95,120,2,7,8,98,111,117,110,100,115,95,121,2,18,9,98,111,117,110,
  100,115,95,99,120,3,194,0,9,98,111,117,110,100,115,95,99,121,2,7,
  5,99,111,108,111,114,4,7,0,0,144,16,102,114,97,109,101,46,108,111,
  99,97,108,112,114,111,112,115,11,10,102,114,108,95,102,105,108,101,102,116,
  0,11,102,114,97,109,101,46,100,117,109,109,121,2,0,7,97,110,99,104,
  111,114,115,11,7,97,110,95,108,101,102,116,6,97,110,95,116,111,112,8,
  97,110,95,114,105,103,104,116,0,8,116,97,98,111,114,100,101,114,2,4,
  12,100,105,97,108,46,119,105,100,116,104,109,109,5,0,152,153,153,153,153,
  153,153,253,63,10,100,105,97,108,46,114,97,110,103,101,5,0,0,0,0,
  0,0,0,200,5,64,18,100,105,97,108,46,109,97,114,107,101,114,115,46,
  99,111,117,110,116,2,1,18,100,105,97,108,46,109,97,114,107,101,114,115,
  46,105,116,101,109,115,14,1,5,99,111,108,111,114,4,7,0,0,160,3,
  118,97,108,1,5,0,0,0,0,0,0,0,0,0,0,9,0,0,0,16,
  100,105,97,108,46,116,105,99,107,115,46,99,111,117,110,116,2,3,16,100,
  105,97,108,46,116,105,99,107,115,46,105,116,101,109,115,14,1,13,105,110,
  116,101,114,118,97,108,99,111,117,110,116,5,0,0,0,0,0,0,0,160,
  2,64,0,1,5,99,111,108,111,114,4,3,0,0,160,6,108,101,110,103,
  116,104,2,6,13,105,110,116,101,114,118,97,108,99,111,117,110,116,5,0,
  0,0,0,0,0,0,160,3,64,0,1,5,99,111,108,111,114,4,3,0,
  0,160,6,108,101,110,103,116,104,2,3,13,105,110,116,101,114,118,97,108,
  99,111,117,110,116,5,0,0,0,0,0,0,0,200,5,64,0,0,0,0,
  242,2,1,7,116,116,97,98,98,97,114,6,116,97,98,98,97,114,13,111,
  112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,109,111,117,
  115,101,119,104,101,101,108,17,111,119,95,100,101,115,116,114,111,121,119,105,
  100,103,101,116,115,18,111,119,95,102,111,110,116,103,108,121,112,104,104,101,
  105,103,104,116,12,111,119,95,97,117,116,111,115,99,97,108,101,0,8,98,
  111,117,110,100,115,95,120,2,120,8,98,111,117,110,100,115,95,121,2,0,
  9,98,111,117,110,100,115,95,99,120,2,83,9,98,111,117,110,100,115,95,
  99,121,2,18,5,99,111,108,111,114,4,5,0,0,144,11,102,114,97,109,
  101,46,100,117,109,109,121,2,0,7,97,110,99,104,111,114,115,11,7,97,
  110,95,108,101,102,116,6,97,110,95,116,111,112,8,97,110,95,114,105,103,
  104,116,0,17,111,110,97,99,116,105,118,101,116,97,98,99,104,97,110,103,
  101,7,6,116,97,98,99,104,97,11,111,110,116,97,98,109,111,118,105,110,
  103,7,5,116,97,98,109,111,18,111,110,99,108,105,101,110,116,109,111,117,
  115,101,101,118,101,110,116,7,8,116,97,98,109,111,117,115,101,7,111,112,
  116,105,111,110,115,11,15,116,97,98,111,95,100,114,97,103,115,111,117,114,
  99,101,13,116,97,98,111,95,100,114,97,103,100,101,115,116,0,13,114,101,
  102,102,111,110,116,104,101,105,103,104,116,2,14,0,0,242,2,2,10,116,
  115,99,114,111,108,108,98,111,120,15,114,101,112,111,114,116,99,111,110,116,
  97,105,110,101,114,8,98,111,117,110,100,115,95,120,2,7,8,98,111,117,
  110,100,115,95,121,2,25,9,98,111,117,110,100,115,95,99,120,3,198,0,
  9,98,111,117,110,100,115,95,99,121,3,178,1,17,102,114,97,109,101,46,
  99,111,108,111,114,99,108,105,101,110,116,4,6,0,0,160,16,102,114,97,
  109,101,46,108,111,99,97,108,112,114,111,112,115,11,15,102,114,108,95,99,
  111,108,111,114,99,108,105,101,110,116,0,11,102,114,97,109,101,46,100,117,
  109,109,121,2,0,7,97,110,99,104,111,114,115,11,7,97,110,95,108,101,
  102,116,6,97,110,95,116,111,112,8,97,110,95,114,105,103,104,116,9,97,
  110,95,98,111,116,116,111,109,0,8,116,97,98,111,114,100,101,114,2,1,
  13,111,110,99,104,105,108,100,115,99,97,108,101,100,7,23,114,101,112,99,
  111,109,116,97,105,110,101,114,99,104,105,108,100,115,99,97,108,101,100,8,
  111,110,115,99,114,111,108,108,7,21,114,101,112,111,114,116,99,111,110,116,
  97,105,110,101,114,115,99,114,111,108,108,0,0,242,2,3,7,116,115,112,
  97,99,101,114,8,116,115,112,97,99,101,114,49,8,98,111,117,110,100,115,
  95,120,3,144,0,8,98,111,117,110,100,115,95,121,2,18,9,98,111,117,
  110,100,115,95,99,120,2,50,9,98,111,117,110,100,115,95,99,121,2,5,
  8,116,97,98,111,114,100,101,114,2,2,7,108,105,110,107,116,111,112,7,
  6,116,97,98,98,97,114,10,108,105,110,107,98,111,116,116,111,109,7,5,
  100,105,97,108,104,11,100,105,115,116,95,98,111,116,116,111,109,2,251,0,
  0,242,2,4,5,116,100,105,97,108,5,100,105,97,108,118,8,98,111,117,
  110,100,115,95,120,2,0,8,98,111,117,110,100,115,95,121,2,25,9,98,
  111,117,110,100,115,95,99,120,2,7,9,98,111,117,110,100,115,95,99,121,
  3,175,1,5,99,111,108,111,114,4,7,0,0,144,7,97,110,99,104,111,
  114,115,11,7,97,110,95,108,101,102,116,6,97,110,95,116,111,112,9,97,
  110,95,98,111,116,116,111,109,0,8,116,97,98,111,114,100,101,114,2,3,
  12,100,105,97,108,46,119,105,100,116,104,109,109,5,0,152,153,153,153,153,
  153,153,253,63,14,100,105,97,108,46,100,105,114,101,99,116,105,111,110,7,
  7,103,100,95,100,111,119,110,10,100,105,97,108,46,114,97,110,103,101,5,
  0,0,0,0,0,0,0,200,5,64,18,100,105,97,108,46,109,97,114,107,
  101,114,115,46,99,111,117,110,116,2,1,18,100,105,97,108,46,109,97,114,
  107,101,114,115,46,105,116,101,109,115,14,1,5,99,111,108,111,114,4,7,
  0,0,160,3,118,97,108,1,5,0,0,0,0,0,0,0,0,0,0,9,
  0,0,0,16,100,105,97,108,46,116,105,99,107,115,46,99,111,117,110,116,
  2,3,16,100,105,97,108,46,116,105,99,107,115,46,105,116,101,109,115,14,
  1,13,105,110,116,101,114,118,97,108,99,111,117,110,116,5,0,0,0,0,
  0,0,0,160,2,64,0,1,5,99,111,108,111,114,4,3,0,0,160,6,
  108,101,110,103,116,104,2,6,13,105,110,116,101,114,118,97,108,99,111,117,
  110,116,5,0,0,0,0,0,0,0,160,3,64,0,1,5,99,111,108,111,
  114,4,3,0,0,160,6,108,101,110,103,116,104,2,4,13,105,110,116,101,
  114,118,97,108,99,111,117,110,116,5,0,0,0,0,0,0,0,200,5,64,
  0,0,0,0,242,2,5,7,116,115,112,97,99,101,114,8,116,115,112,97,
  99,101,114,50,8,98,111,117,110,100,115,95,120,3,144,0,8,98,111,117,
  110,100,115,95,121,2,25,9,98,111,117,110,100,115,95,99,120,2,50,9,
  98,111,117,110,100,115,95,99,121,2,5,8,116,97,98,111,114,100,101,114,
  2,5,7,108,105,110,107,116,111,112,7,5,100,105,97,108,104,10,108,105,
  110,107,98,111,116,116,111,109,7,15,114,101,112,111,114,116,99,111,110,116,
  97,105,110,101,114,11,100,105,115,116,95,98,111,116,116,111,109,2,251,0,
  0,242,2,6,7,116,115,112,97,99,101,114,8,116,115,112,97,99,101,114,
  51,8,98,111,117,110,100,115,95,120,2,7,8,98,111,117,110,100,115,95,
  121,3,173,0,9,98,111,117,110,100,115,95,99,120,2,5,9,98,111,117,
  110,100,115,95,99,121,2,50,8,116,97,98,111,114,100,101,114,2,6,8,
  108,105,110,107,108,101,102,116,7,5,100,105,97,108,118,9,108,105,110,107,
  114,105,103,104,116,7,15,114,101,112,111,114,116,99,111,110,116,97,105,110,
  101,114,10,100,105,115,116,95,114,105,103,104,116,2,251,0,0,242,2,7,
  9,116,114,101,97,108,100,105,115,112,5,120,100,105,115,112,8,98,111,117,
  110,100,115,95,120,2,52,8,98,111,117,110,100,115,95,121,2,0,9,98,
  111,117,110,100,115,95,99,120,2,68,9,98,111,117,110,100,115,95,99,121,
  2,18,5,99,111,108,111,114,4,5,0,0,144,11,102,114,97,109,101,46,
  100,117,109,109,121,2,0,8,116,97,98,111,114,100,101,114,2,7,9,116,
  101,120,116,102,108,97,103,115,11,12,116,102,95,121,99,101,110,116,101,114,
  101,100,0,6,102,111,114,109,97,116,6,5,48,46,48,109,109,13,114,101,
  102,102,111,110,116,104,101,105,103,104,116,2,14,0,0,242,2,8,9,116,
  114,101,97,108,100,105,115,112,5,121,100,105,115,112,8,98,111,117,110,100,
  115,95,120,2,0,8,98,111,117,110,100,115,95,121,2,0,9,98,111,117,
  110,100,115,95,99,120,2,52,9,98,111,117,110,100,115,95,99,121,2,18,
  5,99,111,108,111,114,4,5,0,0,144,11,102,114,97,109,101,46,100,117,
  109,109,121,2,0,8,116,97,98,111,114,100,101,114,2,8,6,102,111,114,
  109,97,116,6,3,48,46,48,13,114,101,102,102,111,110,116,104,101,105,103,
  104,116,2,14,0,0,242,2,9,7,116,115,112,97,99,101,114,8,116,115,
  112,97,99,101,114,52,8,98,111,117,110,100,115,95,120,2,16,8,98,111,
  117,110,100,115,95,121,2,25,9,98,111,117,110,100,115,95,99,120,2,50,
  9,98,111,117,110,100,115,95,99,121,2,5,8,116,97,98,111,114,100,101,
  114,2,9,7,108,105,110,107,116,111,112,7,5,100,105,97,108,104,10,108,
  105,110,107,98,111,116,116,111,109,7,5,100,105,97,108,118,11,100,105,115,
  116,95,98,111,116,116,111,109,2,251,0,0,241,10,116,112,111,112,117,112,
  109,101,110,117,7,112,111,112,117,112,109,101,18,109,101,110,117,46,115,117,
  98,109,101,110,117,46,99,111,117,110,116,2,24,18,109,101,110,117,46,115,
  117,98,109,101,110,117,46,105,116,101,109,115,14,1,0,1,0,1,0,1,
  0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
  0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,7,111,112,116,
  105,111,110,115,11,13,109,97,111,95,115,101,112,97,114,97,116,111,114,19,
  109,97,111,95,115,104,111,114,116,99,117,116,99,97,112,116,105,111,110,0,
  0,1,7,99,97,112,116,105,111,110,6,15,65,100,100,32,114,101,112,111,
  114,116,32,112,97,103,101,4,110,97,109,101,6,7,97,100,100,112,97,103,
  101,5,115,116,97,116,101,11,15,97,115,95,108,111,99,97,108,99,97,112,
  116,105,111,110,17,97,115,95,108,111,99,97,108,111,110,101,120,101,99,117,
  116,101,0,9,111,110,101,120,101,99,117,116,101,7,7,97,100,100,112,97,
  103,101,0,1,7,99,97,112,116,105,111,110,6,18,68,101,108,101,116,101,
  32,114,101,112,111,114,116,32,112,97,103,101,4,110,97,109,101,6,7,100,
  101,108,112,97,103,101,5,115,116,97,116,101,11,15,97,115,95,108,111,99,
  97,108,99,97,112,116,105,111,110,17,97,115,95,108,111,99,97,108,111,110,
  101,120,101,99,117,116,101,0,7,111,112,116,105,111,110,115,11,19,109,97,
  111,95,115,104,111,114,116,99,117,116,99,97,112,116,105,111,110,16,109,97,
  111,95,97,115,121,110,99,101,120,101,99,117,116,101,0,9,111,110,101,120,
  101,99,117,116,101,7,10,100,101,108,101,116,101,112,97,103,101,0,0,8,
  111,110,117,112,100,97,116,101,7,9,112,111,112,117,112,117,112,100,97,0,
  0,0)
 );

initialization
 registerobjectdata(@objdata,treportdesignerfo,'');
end.

unit sourcepage_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface

implementation
uses
 mseclasses,sourcepage;

const
 objdata: record size: integer; data: array[0..2902] of byte end =
      (size: 2903; data: (
  84,80,70,48,11,116,115,111,117,114,99,101,112,97,103,101,10,115,111,117,
  114,99,101,112,97,103,101,13,111,112,116,105,111,110,115,119,105,100,103,101,
  116,11,13,111,119,95,97,114,114,111,119,102,111,99,117,115,11,111,119,95,
  115,117,98,102,111,99,117,115,17,111,119,95,100,101,115,116,114,111,121,119,
  105,100,103,101,116,115,9,111,119,95,104,105,110,116,111,110,12,111,119,95,
  97,117,116,111,115,99,97,108,101,0,8,98,111,117,110,100,115,95,120,3,
  192,0,8,98,111,117,110,100,115,95,121,3,245,0,9,98,111,117,110,100,
  115,95,99,120,3,55,1,9,98,111,117,110,100,115,95,99,121,3,228,0,
  5,99,111,108,111,114,4,1,0,0,128,8,116,97,98,111,114,100,101,114,
  2,1,7,118,105,115,105,98,108,101,8,23,99,111,110,116,97,105,110,101,
  114,46,111,112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,
  109,111,117,115,101,102,111,99,117,115,11,111,119,95,116,97,98,102,111,99,
  117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,115,11,111,119,95,
  115,117,98,102,111,99,117,115,19,111,119,95,109,111,117,115,101,116,114,97,
  110,115,112,97,114,101,110,116,17,111,119,95,100,101,115,116,114,111,121,119,
  105,100,103,101,116,115,12,111,119,95,97,117,116,111,115,99,97,108,101,0,
  18,99,111,110,116,97,105,110,101,114,46,98,111,117,110,100,115,95,120,2,
  0,18,99,111,110,116,97,105,110,101,114,46,98,111,117,110,100,115,95,121,
  2,0,19,99,111,110,116,97,105,110,101,114,46,98,111,117,110,100,115,95,
  99,120,3,55,1,19,99,111,110,116,97,105,110,101,114,46,98,111,117,110,
  100,115,95,99,121,3,228,0,21,99,111,110,116,97,105,110,101,114,46,102,
  114,97,109,101,46,100,117,109,109,121,2,0,21,105,99,111,110,46,116,114,
  97,110,115,112,97,114,101,110,116,99,111,108,111,114,4,0,0,0,128,8,
  111,110,99,114,101,97,116,101,7,16,115,111,117,114,99,101,102,111,111,110,
  99,114,101,97,116,101,16,111,110,101,118,101,110,116,108,111,111,112,115,116,
  97,114,116,7,16,115,111,117,114,99,101,102,111,111,110,108,111,97,100,101,
  100,9,111,110,100,101,115,116,114,111,121,7,17,115,111,117,114,99,101,102,
  111,111,110,100,101,115,116,114,111,121,6,111,110,115,104,111,119,7,14,115,
  111,117,114,99,101,102,111,111,110,115,104,111,119,6,111,110,104,105,100,101,
  7,20,115,111,117,114,99,101,102,111,111,110,100,101,97,99,116,105,118,97,
  116,101,15,109,111,100,117,108,101,99,108,97,115,115,110,97,109,101,6,8,
  116,109,115,101,102,111,114,109,0,11,116,119,105,100,103,101,116,103,114,105,
  100,4,103,114,105,100,13,111,112,116,105,111,110,115,119,105,100,103,101,116,
  11,13,111,119,95,109,111,117,115,101,102,111,99,117,115,11,111,119,95,116,
  97,98,102,111,99,117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,
  115,15,111,119,95,97,114,114,111,119,102,111,99,117,115,105,110,16,111,119,
  95,97,114,114,111,119,102,111,99,117,115,111,117,116,13,111,119,95,109,111,
  117,115,101,119,104,101,101,108,17,111,119,95,100,101,115,116,114,111,121,119,
  105,100,103,101,116,115,18,111,119,95,102,111,110,116,103,108,121,112,104,104,
  101,105,103,104,116,12,111,119,95,97,117,116,111,115,99,97,108,101,0,8,
  98,111,117,110,100,115,95,120,2,0,8,98,111,117,110,100,115,95,121,2,
  0,9,98,111,117,110,100,115,95,99,120,3,55,1,9,98,111,117,110,100,
  115,95,99,121,3,206,0,11,102,114,97,109,101,46,100,117,109,109,121,2,
  0,7,97,110,99,104,111,114,115,11,6,97,110,95,116,111,112,9,97,110,
  95,98,111,116,116,111,109,0,11,111,112,116,105,111,110,115,103,114,105,100,
  11,19,111,103,95,102,111,99,117,115,99,101,108,108,111,110,101,110,116,101,
  114,15,111,103,95,97,117,116,111,102,105,114,115,116,114,111,119,0,15,114,
  111,119,99,111,108,111,114,115,46,99,111,117,110,116,2,4,15,114,111,119,
  99,111,108,111,114,115,46,105,116,101,109,115,1,4,255,255,224,0,4,255,
  255,0,0,4,0,0,255,0,4,2,0,0,128,0,14,100,97,116,97,99,
  111,108,115,46,99,111,117,110,116,2,2,14,100,97,116,97,99,111,108,115,
  46,105,116,101,109,115,14,1,9,108,105,110,101,99,111,108,111,114,4,4,
  0,0,160,5,119,105,100,116,104,2,15,7,111,112,116,105,111,110,115,11,
  10,99,111,95,110,111,102,111,99,117,115,12,99,111,95,110,111,104,115,99,
  114,111,108,108,11,99,111,95,114,111,119,99,111,108,111,114,0,11,111,110,
  99,101,108,108,101,118,101,110,116,7,15,105,99,111,110,111,110,99,101,108,
  108,101,118,101,110,116,10,119,105,100,103,101,116,110,97,109,101,6,8,100,
  97,116,97,105,99,111,110,0,1,5,119,105,100,116,104,3,208,7,7,111,
  112,116,105,111,110,115,11,22,99,111,95,108,101,102,116,98,117,116,116,111,
  110,102,111,99,117,115,111,110,108,121,12,99,111,95,115,97,118,101,115,116,
  97,116,101,11,99,111,95,114,111,119,99,111,108,111,114,17,99,111,95,109,
  111,117,115,101,115,99,114,111,108,108,114,111,119,0,8,111,110,99,104,97,
  110,103,101,7,11,116,101,120,116,99,104,97,110,103,101,100,10,119,105,100,
  103,101,116,110,97,109,101,6,4,101,100,105,116,0,0,16,100,97,116,97,
  114,111,119,108,105,110,101,119,105,100,116,104,2,0,13,100,97,116,97,114,
  111,119,104,101,105,103,104,116,2,16,14,111,110,114,111,119,115,105,110,115,
  101,114,116,101,100,7,18,103,114,105,100,111,110,114,111,119,115,105,110,115,
  101,114,116,101,100,13,111,110,114,111,119,115,100,101,108,101,116,101,100,7,
  17,103,114,105,100,111,110,114,111,119,115,100,101,108,101,116,101,100,11,111,
  110,99,101,108,108,101,118,101,110,116,7,15,103,114,105,100,111,110,99,101,
  108,108,101,118,101,110,116,13,114,101,102,102,111,110,116,104,101,105,103,104,
  116,2,14,0,9,116,100,97,116,97,105,99,111,110,8,100,97,116,97,105,
  99,111,110,11,111,112,116,105,111,110,115,115,107,105,110,11,19,111,115,107,
  95,102,114,97,109,101,98,117,116,116,111,110,111,110,108,121,0,8,98,111,
  117,110,100,115,95,120,2,2,8,98,111,117,110,100,115,95,121,2,2,9,
  98,111,117,110,100,115,95,99,120,2,15,9,98,111,117,110,100,115,95,99,
  121,2,16,8,116,97,98,111,114,100,101,114,2,3,11,111,112,116,105,111,
  110,115,101,100,105,116,11,12,111,101,95,117,110,100,111,111,110,101,115,99,
  13,111,101,95,99,108,111,115,101,113,117,101,114,121,16,111,101,95,99,104,
  101,99,107,109,114,99,97,110,99,101,108,15,111,101,95,101,120,105,116,111,
  110,99,117,114,115,111,114,12,111,101,95,101,97,116,114,101,116,117,114,110,
  20,111,101,95,114,101,115,101,116,115,101,108,101,99,116,111,110,101,120,105,
  116,13,111,101,95,97,117,116,111,115,101,108,101,99,116,25,111,101,95,97,
  117,116,111,115,101,108,101,99,116,111,110,102,105,114,115,116,99,108,105,99,
  107,16,111,101,95,97,117,116,111,112,111,112,117,112,109,101,110,117,12,111,
  101,95,115,97,118,101,115,116,97,116,101,0,7,118,105,115,105,98,108,101,
  8,12,118,97,108,117,101,100,101,102,97,117,108,116,4,0,0,0,128,3,
  109,105,110,2,255,3,109,97,120,2,2,15,105,109,97,103,101,110,117,109,
  115,46,99,111,117,110,116,2,14,15,105,109,97,103,101,110,117,109,115,46,
  105,116,101,109,115,1,2,0,2,1,2,2,2,3,2,4,2,5,2,6,
  2,7,2,8,2,9,2,10,2,11,2,12,2,13,0,0,0,11,116,115,
  121,110,116,97,120,101,100,105,116,4,101,100,105,116,13,111,112,116,105,111,
  110,115,119,105,100,103,101,116,11,13,111,119,95,109,111,117,115,101,102,111,
  99,117,115,11,111,119,95,116,97,98,102,111,99,117,115,13,111,119,95,97,
  114,114,111,119,102,111,99,117,115,15,111,119,95,97,114,114,111,119,102,111,
  99,117,115,105,110,16,111,119,95,97,114,114,111,119,102,111,99,117,115,111,
  117,116,17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,
  17,111,119,95,102,111,110,116,108,105,110,101,104,101,105,103,104,116,0,11,
  111,112,116,105,111,110,115,115,107,105,110,11,19,111,115,107,95,102,114,97,
  109,101,98,117,116,116,111,110,111,110,108,121,0,8,98,111,117,110,100,115,
  95,120,2,0,8,98,111,117,110,100,115,95,121,2,0,9,98,111,117,110,
  100,115,95,99,120,3,208,7,9,98,111,117,110,100,115,95,99,121,2,16,
  8,116,97,98,111,114,100,101,114,2,1,7,118,105,115,105,98,108,101,8,
  9,102,111,110,116,46,110,97,109,101,6,13,109,115,101,105,100,101,95,115,
  111,117,114,99,101,11,102,111,110,116,46,120,115,99,97,108,101,5,0,0,
  0,0,0,0,0,128,255,63,10,102,111,110,116,46,100,117,109,109,121,2,
  0,11,111,112,116,105,111,110,115,101,100,105,116,11,13,111,101,95,99,108,
  111,115,101,113,117,101,114,121,16,111,101,95,99,104,101,99,107,109,114,99,
  97,110,99,101,108,15,111,101,95,101,120,105,116,111,110,99,117,114,115,111,
  114,12,111,101,95,108,105,110,101,98,114,101,97,107,12,111,101,95,101,97,
  116,114,101,116,117,114,110,13,111,101,95,107,101,121,101,120,101,99,117,116,
  101,12,111,101,95,115,97,118,101,115,116,97,116,101,0,9,111,110,107,101,
  121,100,111,119,110,7,13,101,100,105,116,111,110,107,101,121,100,111,119,110,
  15,116,97,98,117,108,97,116,111,114,115,46,112,112,109,109,5,0,0,0,
  0,0,0,0,192,0,64,13,111,110,102,111,110,116,99,104,97,110,103,101,
  100,7,17,101,100,105,116,111,110,102,111,110,116,99,104,97,110,103,101,100,
  17,111,110,109,111,100,105,102,105,101,100,99,104,97,110,103,101,100,7,21,
  101,100,105,116,111,110,109,111,100,105,102,105,101,100,99,104,97,110,103,101,
  100,16,111,110,116,101,120,116,109,111,117,115,101,101,118,101,110,116,7,20,
  101,100,105,116,111,110,116,101,120,116,109,111,117,115,101,101,118,101,110,116,
  17,111,110,101,100,105,116,110,111,116,105,102,99,97,116,105,111,110,7,22,
  101,100,105,116,111,110,101,100,105,116,110,111,116,105,102,105,99,97,116,105,
  111,110,11,111,110,99,101,108,108,101,118,101,110,116,7,15,101,100,105,116,
  111,110,99,101,108,108,101,118,101,110,116,12,109,97,120,117,110,100,111,99,
  111,117,110,116,3,16,39,13,114,101,102,102,111,110,116,104,101,105,103,104,
  116,2,19,0,0,0,11,116,115,116,114,105,110,103,100,105,115,112,8,108,
  105,110,101,100,105,115,112,8,98,111,117,110,100,115,95,120,2,0,8,98,
  111,117,110,100,115,95,121,3,209,0,9,98,111,117,110,100,115,95,99,120,
  2,68,9,98,111,117,110,100,115,95,99,121,2,18,11,102,114,97,109,101,
  46,100,117,109,109,121,2,0,7,97,110,99,104,111,114,115,11,7,97,110,
  95,108,101,102,116,9,97,110,95,98,111,116,116,111,109,0,8,116,97,98,
  111,114,100,101,114,2,2,9,116,101,120,116,102,108,97,103,115,11,12,116,
  102,95,120,99,101,110,116,101,114,101,100,12,116,102,95,121,99,101,110,116,
  101,114,101,100,0,13,114,101,102,102,111,110,116,104,101,105,103,104,116,2,
  14,0,0,11,116,115,116,114,105,110,103,100,105,115,112,8,112,97,116,104,
  100,105,115,112,8,98,111,117,110,100,115,95,120,2,68,8,98,111,117,110,
  100,115,95,121,3,209,0,9,98,111,117,110,100,115,95,99,120,3,243,0,
  9,98,111,117,110,100,115,95,99,121,2,18,11,102,114,97,109,101,46,100,
  117,109,109,121,2,0,7,97,110,99,104,111,114,115,11,7,97,110,95,108,
  101,102,116,8,97,110,95,114,105,103,104,116,9,97,110,95,98,111,116,116,
  111,109,0,8,116,97,98,111,114,100,101,114,2,1,9,116,101,120,116,102,
  108,97,103,115,11,12,116,102,95,121,99,101,110,116,101,114,101,100,14,116,
  102,95,101,108,108,105,112,115,101,108,101,102,116,0,7,111,112,116,105,111,
  110,115,11,19,100,119,111,95,104,105,110,116,99,108,105,112,112,101,100,116,
  101,120,116,0,13,114,101,102,102,111,110,116,104,101,105,103,104,116,2,14,
  0,0,0)
 );

initialization
 registerobjectdata(@objdata,tsourcepage,'');
end.

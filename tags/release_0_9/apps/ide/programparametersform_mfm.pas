unit programparametersform_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface

implementation
uses
 mseclasses,programparametersform;

const
 objdata: record size: integer; data: array[0..3803] of byte end =
      (size: 3804; data: (
  84,80,70,48,20,116,112,114,111,103,114,97,109,112,97,114,97,109,101,116,
  101,114,115,102,111,19,112,114,111,103,114,97,109,112,97,114,97,109,101,116,
  101,114,115,102,111,8,98,111,117,110,100,115,95,120,3,16,1,8,98,111,
  117,110,100,115,95,121,3,243,0,9,98,111,117,110,100,115,95,99,120,3,
  72,1,9,98,111,117,110,100,115,95,99,121,3,92,1,7,118,105,115,105,
  98,108,101,8,23,99,111,110,116,97,105,110,101,114,46,111,112,116,105,111,
  110,115,119,105,100,103,101,116,11,13,111,119,95,109,111,117,115,101,102,111,
  99,117,115,11,111,119,95,116,97,98,102,111,99,117,115,13,111,119,95,97,
  114,114,111,119,102,111,99,117,115,15,111,119,95,97,114,114,111,119,102,111,
  99,117,115,105,110,16,111,119,95,97,114,114,111,119,102,111,99,117,115,111,
  117,116,11,111,119,95,115,117,98,102,111,99,117,115,19,111,119,95,109,111,
  117,115,101,116,114,97,110,115,112,97,114,101,110,116,17,111,119,95,100,101,
  115,116,114,111,121,119,105,100,103,101,116,115,12,111,119,95,97,117,116,111,
  115,99,97,108,101,0,19,99,111,110,116,97,105,110,101,114,46,98,111,117,
  110,100,115,95,99,120,3,72,1,19,99,111,110,116,97,105,110,101,114,46,
  98,111,117,110,100,115,95,99,121,3,92,1,21,99,111,110,116,97,105,110,
  101,114,46,102,114,97,109,101,46,100,117,109,109,121,2,0,7,111,112,116,
  105,111,110,115,11,13,102,111,95,99,108,111,115,101,111,110,101,115,99,15,
  102,111,95,97,117,116,111,114,101,97,100,115,116,97,116,16,102,111,95,97,
  117,116,111,119,114,105,116,101,115,116,97,116,10,102,111,95,115,97,118,101,
  112,111,115,0,8,115,116,97,116,102,105,108,101,7,9,115,116,97,116,102,
  105,108,101,49,7,99,97,112,116,105,111,110,6,18,84,97,114,103,101,116,
  32,101,110,118,105,114,111,110,109,101,110,116,15,109,111,100,117,108,101,99,
  108,97,115,115,110,97,109,101,6,8,116,109,115,101,102,111,114,109,0,13,
  116,102,105,108,101,110,97,109,101,101,100,105,116,16,119,111,114,107,105,110,
  103,100,105,114,101,99,116,111,114,121,13,111,112,116,105,111,110,115,119,105,
  100,103,101,116,11,13,111,119,95,109,111,117,115,101,102,111,99,117,115,11,
  111,119,95,116,97,98,102,111,99,117,115,13,111,119,95,97,114,114,111,119,
  102,111,99,117,115,15,111,119,95,97,114,114,111,119,102,111,99,117,115,105,
  110,16,111,119,95,97,114,114,111,119,102,111,99,117,115,111,117,116,17,111,
  119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,18,111,119,95,
  102,111,110,116,103,108,121,112,104,104,101,105,103,104,116,12,111,119,95,97,
  117,116,111,115,99,97,108,101,0,8,98,111,117,110,100,115,95,120,2,2,
  8,98,111,117,110,100,115,95,121,2,8,9,98,111,117,110,100,115,95,99,
  120,3,68,1,9,98,111,117,110,100,115,95,99,121,2,40,13,102,114,97,
  109,101,46,99,97,112,116,105,111,110,6,18,38,87,111,114,107,105,110,103,
  32,100,105,114,101,99,116,111,114,121,20,102,114,97,109,101,46,98,117,116,
  116,111,110,46,105,109,97,103,101,110,114,2,17,11,102,114,97,109,101,46,
  100,117,109,109,121,2,0,16,102,114,97,109,101,46,111,117,116,101,114,102,
  114,97,109,101,1,2,0,2,18,2,0,2,0,0,7,97,110,99,104,111,
  114,115,11,7,97,110,95,108,101,102,116,6,97,110,95,116,111,112,8,97,
  110,95,114,105,103,104,116,0,8,116,97,98,111,114,100,101,114,2,1,18,
  99,111,110,116,114,111,108,108,101,114,46,111,112,116,105,111,110,115,11,13,
  102,100,111,95,100,105,114,101,99,116,111,114,121,0,22,99,111,110,116,114,
  111,108,108,101,114,46,99,97,112,116,105,111,110,111,112,101,110,6,32,83,
  101,108,101,99,116,32,112,114,111,103,114,97,109,32,119,111,114,107,105,110,
  103,32,100,105,114,101,99,116,111,114,121,13,114,101,102,102,111,110,116,104,
  101,105,103,104,116,2,16,0,0,7,116,98,117,116,116,111,110,2,111,107,
  8,98,111,117,110,100,115,95,120,3,216,0,8,98,111,117,110,100,115,95,
  121,3,64,1,9,98,111,117,110,100,115,95,99,120,2,50,9,98,111,117,
  110,100,115,95,99,121,2,20,7,97,110,99,104,111,114,115,11,8,97,110,
  95,114,105,103,104,116,9,97,110,95,98,111,116,116,111,109,0,8,116,97,
  98,111,114,100,101,114,2,4,5,115,116,97,116,101,11,10,97,115,95,100,
  101,102,97,117,108,116,15,97,115,95,108,111,99,97,108,100,101,102,97,117,
  108,116,15,97,115,95,108,111,99,97,108,99,97,112,116,105,111,110,0,7,
  99,97,112,116,105,111,110,6,2,79,75,11,109,111,100,97,108,114,101,115,
  117,108,116,7,5,109,114,95,111,107,0,0,7,116,98,117,116,116,111,110,
  8,116,98,117,116,116,111,110,50,8,98,111,117,110,100,115,95,120,3,16,
  1,8,98,111,117,110,100,115,95,121,3,64,1,9,98,111,117,110,100,115,
  95,99,120,2,50,9,98,111,117,110,100,115,95,99,121,2,20,7,97,110,
  99,104,111,114,115,11,8,97,110,95,114,105,103,104,116,9,97,110,95,98,
  111,116,116,111,109,0,7,99,97,112,116,105,111,110,6,6,67,97,110,99,
  101,108,11,109,111,100,97,108,114,101,115,117,108,116,7,9,109,114,95,99,
  97,110,99,101,108,0,0,12,116,104,105,115,116,111,114,121,101,100,105,116,
  10,112,97,114,97,109,101,116,101,114,115,13,111,112,116,105,111,110,115,119,
  105,100,103,101,116,11,13,111,119,95,109,111,117,115,101,102,111,99,117,115,
  11,111,119,95,116,97,98,102,111,99,117,115,13,111,119,95,97,114,114,111,
  119,102,111,99,117,115,15,111,119,95,97,114,114,111,119,102,111,99,117,115,
  105,110,16,111,119,95,97,114,114,111,119,102,111,99,117,115,111,117,116,17,
  111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,18,111,119,
  95,102,111,110,116,103,108,121,112,104,104,101,105,103,104,116,12,111,119,95,
  97,117,116,111,115,99,97,108,101,0,8,98,111,117,110,100,115,95,120,2,
  2,8,98,111,117,110,100,115,95,121,2,56,9,98,111,117,110,100,115,95,
  99,120,3,68,1,9,98,111,117,110,100,115,95,99,121,2,40,13,102,114,
  97,109,101,46,99,97,112,116,105,111,110,6,11,38,80,97,114,97,109,101,
  116,101,114,115,11,102,114,97,109,101,46,100,117,109,109,121,2,0,16,102,
  114,97,109,101,46,111,117,116,101,114,102,114,97,109,101,1,2,0,2,18,
  2,0,2,0,0,7,97,110,99,104,111,114,115,11,7,97,110,95,108,101,
  102,116,6,97,110,95,116,111,112,8,97,110,95,114,105,103,104,116,0,8,
  116,97,98,111,114,100,101,114,2,2,16,100,114,111,112,100,111,119,110,46,
  111,112,116,105,111,110,115,11,19,100,101,111,95,97,117,116,111,115,97,118,
  101,104,105,115,116,111,114,121,0,19,100,114,111,112,100,111,119,110,46,99,
  111,108,115,46,99,111,117,110,116,2,1,19,100,114,111,112,100,111,119,110,
  46,99,111,108,115,46,105,116,101,109,115,14,1,0,0,13,114,101,102,102,
  111,110,116,104,101,105,103,104,116,2,16,0,0,11,116,119,105,100,103,101,
  116,103,114,105,100,12,116,119,105,100,103,101,116,103,114,105,100,49,13,111,
  112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,109,111,117,
  115,101,102,111,99,117,115,11,111,119,95,116,97,98,102,111,99,117,115,13,
  111,119,95,97,114,114,111,119,102,111,99,117,115,17,111,119,95,102,111,99,
  117,115,98,97,99,107,111,110,101,115,99,17,111,119,95,100,101,115,116,114,
  111,121,119,105,100,103,101,116,115,18,111,119,95,102,111,110,116,103,108,121,
  112,104,104,101,105,103,104,116,12,111,119,95,97,117,116,111,115,99,97,108,
  101,0,8,98,111,117,110,100,115,95,120,2,2,8,98,111,117,110,100,115,
  95,121,2,110,9,98,111,117,110,100,115,95,99,120,3,68,1,9,98,111,
  117,110,100,115,95,99,121,3,196,0,13,102,114,97,109,101,46,99,97,112,
  116,105,111,110,6,21,69,110,118,105,114,111,110,109,101,110,116,32,118,97,
  114,105,97,98,108,101,115,11,102,114,97,109,101,46,100,117,109,109,121,2,
  0,16,102,114,97,109,101,46,111,117,116,101,114,102,114,97,109,101,1,2,
  0,2,18,2,0,2,0,0,7,97,110,99,104,111,114,115,11,7,97,110,
  95,108,101,102,116,6,97,110,95,116,111,112,8,97,110,95,114,105,103,104,
  116,9,97,110,95,98,111,116,116,111,109,0,8,116,97,98,111,114,100,101,
  114,2,3,11,111,112,116,105,111,110,115,103,114,105,100,11,12,111,103,95,
  99,111,108,115,105,122,105,110,103,15,111,103,95,107,101,121,114,111,119,109,
  111,118,105,110,103,15,111,103,95,114,111,119,105,110,115,101,114,116,105,110,
  103,14,111,103,95,114,111,119,100,101,108,101,116,105,110,103,19,111,103,95,
  102,111,99,117,115,99,101,108,108,111,110,101,110,116,101,114,15,111,103,95,
  97,117,116,111,102,105,114,115,116,114,111,119,13,111,103,95,97,117,116,111,
  97,112,112,101,110,100,12,111,103,95,115,97,118,101,115,116,97,116,101,20,
  111,103,95,99,111,108,99,104,97,110,103,101,111,110,116,97,98,107,101,121,
  12,111,103,95,97,117,116,111,112,111,112,117,112,0,13,102,105,120,114,111,
  119,115,46,99,111,117,110,116,2,1,13,102,105,120,114,111,119,115,46,105,
  116,101,109,115,14,1,6,104,101,105,103,104,116,2,18,14,99,97,112,116,
  105,111,110,115,46,99,111,117,110,116,2,3,14,99,97,112,116,105,111,110,
  115,46,105,116,101,109,115,14,1,7,99,97,112,116,105,111,110,6,2,111,
  110,0,1,7,99,97,112,116,105,111,110,6,4,78,97,109,101,0,1,7,
  99,97,112,116,105,111,110,6,5,86,97,108,117,101,0,0,0,0,14,100,
  97,116,97,99,111,108,115,46,99,111,117,110,116,2,3,14,100,97,116,97,
  99,111,108,115,46,105,116,101,109,115,14,1,5,119,105,100,116,104,2,20,
  7,111,112,116,105,111,110,115,11,12,99,111,95,100,114,97,119,102,111,99,
  117,115,12,99,111,95,115,97,118,101,115,116,97,116,101,10,99,111,95,114,
  111,119,102,111,110,116,11,99,111,95,114,111,119,99,111,108,111,114,13,99,
  111,95,122,101,98,114,97,99,111,108,111,114,0,10,119,105,100,103,101,116,
  110,97,109,101,6,8,101,110,118,118,97,114,111,110,0,1,5,119,105,100,
  116,104,2,103,7,111,112,116,105,111,110,115,11,15,99,111,95,112,114,111,
  112,111,114,116,105,111,110,97,108,12,99,111,95,115,97,118,101,118,97,108,
  117,101,12,99,111,95,115,97,118,101,115,116,97,116,101,10,99,111,95,114,
  111,119,102,111,110,116,11,99,111,95,114,111,119,99,111,108,111,114,13,99,
  111,95,122,101,98,114,97,99,111,108,111,114,0,10,119,105,100,103,101,116,
  110,97,109,101,6,10,101,110,118,118,97,114,110,97,109,101,0,1,5,119,
  105,100,116,104,3,194,0,7,111,112,116,105,111,110,115,11,7,99,111,95,
  102,105,108,108,12,99,111,95,115,97,118,101,118,97,108,117,101,12,99,111,
  95,115,97,118,101,115,116,97,116,101,10,99,111,95,114,111,119,102,111,110,
  116,11,99,111,95,114,111,119,99,111,108,111,114,13,99,111,95,122,101,98,
  114,97,99,111,108,111,114,0,10,119,105,100,103,101,116,110,97,109,101,6,
  11,101,110,118,118,97,114,118,97,108,117,101,0,0,13,100,97,116,97,114,
  111,119,104,101,105,103,104,116,2,18,8,115,116,97,116,102,105,108,101,7,
  9,115,116,97,116,102,105,108,101,49,13,114,101,102,102,111,110,116,104,101,
  105,103,104,116,2,16,0,12,116,98,111,111,108,101,97,110,101,100,105,116,
  8,101,110,118,118,97,114,111,110,9,98,111,117,110,100,115,95,99,120,2,
  20,9,98,111,117,110,100,115,95,99,121,2,18,12,102,114,97,109,101,46,
  108,101,118,101,108,111,2,0,17,102,114,97,109,101,46,99,111,108,111,114,
  99,108,105,101,110,116,4,3,0,0,128,16,102,114,97,109,101,46,108,111,
  99,97,108,112,114,111,112,115,11,10,102,114,108,95,108,101,118,101,108,111,
  15,102,114,108,95,99,111,108,111,114,99,108,105,101,110,116,0,11,102,114,
  97,109,101,46,100,117,109,109,121,2,0,8,116,97,98,111,114,100,101,114,
  2,1,7,118,105,115,105,98,108,101,8,11,111,112,116,105,111,110,115,101,
  100,105,116,11,12,111,101,95,117,110,100,111,111,110,101,115,99,13,111,101,
  95,99,108,111,115,101,113,117,101,114,121,16,111,101,95,99,104,101,99,107,
  109,114,99,97,110,99,101,108,15,111,101,95,101,120,105,116,111,110,99,117,
  114,115,111,114,12,111,101,95,101,97,116,114,101,116,117,114,110,20,111,101,
  95,114,101,115,101,116,115,101,108,101,99,116,111,110,101,120,105,116,13,111,
  101,95,101,110,100,111,110,101,110,116,101,114,13,111,101,95,97,117,116,111,
  115,101,108,101,99,116,25,111,101,95,97,117,116,111,115,101,108,101,99,116,
  111,110,102,105,114,115,116,99,108,105,99,107,16,111,101,95,97,117,116,111,
  112,111,112,117,112,109,101,110,117,13,111,101,95,107,101,121,101,120,101,99,
  117,116,101,12,111,101,95,115,97,118,101,115,116,97,116,101,0,12,118,97,
  108,117,101,100,101,102,97,117,108,116,9,0,0,11,116,115,116,114,105,110,
  103,101,100,105,116,10,101,110,118,118,97,114,110,97,109,101,13,111,112,116,
  105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,109,111,117,115,101,
  102,111,99,117,115,11,111,119,95,116,97,98,102,111,99,117,115,13,111,119,
  95,97,114,114,111,119,102,111,99,117,115,17,111,119,95,100,101,115,116,114,
  111,121,119,105,100,103,101,116,115,18,111,119,95,102,111,110,116,103,108,121,
  112,104,104,101,105,103,104,116,12,111,119,95,97,117,116,111,115,99,97,108,
  101,0,8,98,111,117,110,100,115,95,120,2,21,9,98,111,117,110,100,115,
  95,99,120,2,103,9,98,111,117,110,100,115,95,99,121,2,18,12,102,114,
  97,109,101,46,108,101,118,101,108,111,2,0,17,102,114,97,109,101,46,99,
  111,108,111,114,99,108,105,101,110,116,4,3,0,0,128,16,102,114,97,109,
  101,46,108,111,99,97,108,112,114,111,112,115,11,10,102,114,108,95,108,101,
  118,101,108,111,15,102,114,108,95,99,111,108,111,114,99,108,105,101,110,116,
  0,11,102,114,97,109,101,46,100,117,109,109,121,2,0,8,116,97,98,111,
  114,100,101,114,2,2,7,118,105,115,105,98,108,101,8,13,114,101,102,102,
  111,110,116,104,101,105,103,104,116,2,16,0,0,11,116,115,116,114,105,110,
  103,101,100,105,116,11,101,110,118,118,97,114,118,97,108,117,101,13,111,112,
  116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,109,111,117,115,
  101,102,111,99,117,115,11,111,119,95,116,97,98,102,111,99,117,115,13,111,
  119,95,97,114,114,111,119,102,111,99,117,115,17,111,119,95,100,101,115,116,
  114,111,121,119,105,100,103,101,116,115,18,111,119,95,102,111,110,116,103,108,
  121,112,104,104,101,105,103,104,116,0,8,98,111,117,110,100,115,95,120,2,
  125,9,98,111,117,110,100,115,95,99,120,3,194,0,9,98,111,117,110,100,
  115,95,99,121,2,18,12,102,114,97,109,101,46,108,101,118,101,108,111,2,
  0,17,102,114,97,109,101,46,99,111,108,111,114,99,108,105,101,110,116,4,
  3,0,0,128,16,102,114,97,109,101,46,108,111,99,97,108,112,114,111,112,
  115,11,10,102,114,108,95,108,101,118,101,108,111,15,102,114,108,95,99,111,
  108,111,114,99,108,105,101,110,116,0,11,102,114,97,109,101,46,100,117,109,
  109,121,2,0,7,118,105,115,105,98,108,101,8,13,114,101,102,102,111,110,
  116,104,101,105,103,104,116,2,16,0,0,0,9,116,115,116,97,116,102,105,
  108,101,9,115,116,97,116,102,105,108,101,49,8,102,105,108,101,110,97,109,
  101,6,23,112,114,111,103,114,97,109,112,97,114,97,109,101,116,101,114,115,
  102,111,46,115,116,97,7,111,112,116,105,111,110,115,11,10,115,102,111,95,
  109,101,109,111,114,121,0,4,108,101,102,116,3,176,0,3,116,111,112,2,
  96,0,0,0)
 );

initialization
 registerobjectdata(@objdata,tprogramparametersfo,'');
end.

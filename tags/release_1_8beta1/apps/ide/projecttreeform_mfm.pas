unit projecttreeform_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface

implementation
uses
 mseclasses,projecttreeform;

const
 objdata: record size: integer; data: array[0..3264] of byte end =
      (size: 3265; data: (
  84,80,70,48,14,116,112,114,111,106,101,99,116,116,114,101,101,102,111,13,
  112,114,111,106,101,99,116,116,114,101,101,102,111,13,111,112,116,105,111,110,
  115,119,105,100,103,101,116,11,13,111,119,95,97,114,114,111,119,102,111,99,
  117,115,15,111,119,95,97,114,114,111,119,102,111,99,117,115,105,110,16,111,
  119,95,97,114,114,111,119,102,111,99,117,115,111,117,116,11,111,119,95,115,
  117,98,102,111,99,117,115,17,111,119,95,100,101,115,116,114,111,121,119,105,
  100,103,101,116,115,9,111,119,95,104,105,110,116,111,110,12,111,119,95,97,
  117,116,111,115,99,97,108,101,0,8,98,111,117,110,100,115,95,120,3,7,
  1,8,98,111,117,110,100,115,95,121,3,175,1,9,98,111,117,110,100,115,
  95,99,120,3,30,1,9,98,111,117,110,100,115,95,99,121,3,201,0,15,
  102,114,97,109,101,46,103,114,105,112,95,115,105,122,101,2,10,18,102,114,
  97,109,101,46,103,114,105,112,95,111,112,116,105,111,110,115,11,14,103,111,
  95,99,108,111,115,101,98,117,116,116,111,110,16,103,111,95,102,105,120,115,
  105,122,101,98,117,116,116,111,110,12,103,111,95,116,111,112,98,117,116,116,
  111,110,19,103,111,95,98,97,99,107,103,114,111,117,110,100,98,117,116,116,
  111,110,0,11,102,114,97,109,101,46,100,117,109,109,121,2,0,8,116,97,
  98,111,114,100,101,114,2,1,7,118,105,115,105,98,108,101,8,23,99,111,
  110,116,97,105,110,101,114,46,111,112,116,105,111,110,115,119,105,100,103,101,
  116,11,13,111,119,95,109,111,117,115,101,102,111,99,117,115,11,111,119,95,
  116,97,98,102,111,99,117,115,13,111,119,95,97,114,114,111,119,102,111,99,
  117,115,15,111,119,95,97,114,114,111,119,102,111,99,117,115,105,110,16,111,
  119,95,97,114,114,111,119,102,111,99,117,115,111,117,116,11,111,119,95,115,
  117,98,102,111,99,117,115,19,111,119,95,109,111,117,115,101,116,114,97,110,
  115,112,97,114,101,110,116,17,111,119,95,100,101,115,116,114,111,121,119,105,
  100,103,101,116,115,12,111,119,95,97,117,116,111,115,99,97,108,101,0,18,
  99,111,110,116,97,105,110,101,114,46,98,111,117,110,100,115,95,120,2,0,
  18,99,111,110,116,97,105,110,101,114,46,98,111,117,110,100,115,95,121,2,
  0,19,99,111,110,116,97,105,110,101,114,46,98,111,117,110,100,115,95,99,
  120,3,20,1,19,99,111,110,116,97,105,110,101,114,46,98,111,117,110,100,
  115,95,99,121,3,201,0,21,99,111,110,116,97,105,110,101,114,46,102,114,
  97,109,101,46,100,117,109,109,121,2,0,22,100,114,97,103,100,111,99,107,
  46,115,112,108,105,116,116,101,114,95,115,105,122,101,2,0,20,100,114,97,
  103,100,111,99,107,46,111,112,116,105,111,110,115,100,111,99,107,11,10,111,
  100,95,115,97,118,101,112,111,115,10,111,100,95,99,97,110,109,111,118,101,
  11,111,100,95,99,97,110,102,108,111,97,116,10,111,100,95,99,97,110,100,
  111,99,107,0,7,111,112,116,105,111,110,115,11,10,102,111,95,115,97,118,
  101,112,111,115,12,102,111,95,115,97,118,101,115,116,97,116,101,0,8,115,
  116,97,116,102,105,108,101,7,22,109,97,105,110,102,111,46,112,114,111,106,
  101,99,116,115,116,97,116,102,105,108,101,7,99,97,112,116,105,111,110,6,
  7,112,114,111,106,101,99,116,8,111,110,99,114,101,97,116,101,7,21,112,
  114,111,106,101,99,116,116,114,101,101,102,111,111,110,99,114,101,97,116,101,
  16,111,110,101,118,101,110,116,108,111,111,112,115,116,97,114,116,7,21,112,
  114,111,106,101,99,116,116,114,101,101,102,111,111,110,108,111,97,100,101,100,
  9,111,110,100,101,115,116,114,111,121,7,22,112,114,111,106,101,99,116,116,
  114,101,101,102,111,111,110,100,101,115,116,114,111,121,12,111,110,115,116,97,
  116,117,112,100,97,116,101,7,23,112,114,111,106,101,99,116,116,114,101,101,
  111,110,117,112,100,97,116,101,115,116,97,116,15,109,111,100,117,108,101,99,
  108,97,115,115,110,97,109,101,6,9,116,100,111,99,107,102,111,114,109,0,
  11,116,119,105,100,103,101,116,103,114,105,100,4,103,114,105,100,13,111,112,
  116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,109,111,117,115,
  101,102,111,99,117,115,11,111,119,95,116,97,98,102,111,99,117,115,13,111,
  119,95,97,114,114,111,119,102,111,99,117,115,15,111,119,95,97,114,114,111,
  119,102,111,99,117,115,105,110,16,111,119,95,97,114,114,111,119,102,111,99,
  117,115,111,117,116,17,111,119,95,102,111,99,117,115,98,97,99,107,111,110,
  101,115,99,17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,
  115,18,111,119,95,102,111,110,116,103,108,121,112,104,104,101,105,103,104,116,
  12,111,119,95,97,117,116,111,115,99,97,108,101,0,8,98,111,117,110,100,
  115,95,120,2,0,8,98,111,117,110,100,115,95,121,2,0,9,98,111,117,
  110,100,115,95,99,120,3,20,1,9,98,111,117,110,100,115,95,99,121,3,
  201,0,11,102,114,97,109,101,46,100,117,109,109,121,2,0,7,97,110,99,
  104,111,114,115,11,0,11,111,112,116,105,111,110,115,103,114,105,100,11,12,
  111,103,95,99,111,108,115,105,122,105,110,103,19,111,103,95,102,111,99,117,
  115,99,101,108,108,111,110,101,110,116,101,114,20,111,103,95,99,111,108,99,
  104,97,110,103,101,111,110,116,97,98,107,101,121,12,111,103,95,97,117,116,
  111,112,111,112,117,112,0,14,100,97,116,97,99,111,108,115,46,99,111,117,
  110,116,2,2,14,100,97,116,97,99,111,108,115,46,105,116,101,109,115,14,
  1,12,108,105,110,101,99,111,108,111,114,102,105,120,4,3,0,0,160,5,
  119,105,100,116,104,3,141,0,7,111,112,116,105,111,110,115,11,11,99,111,
  95,114,101,97,100,111,110,108,121,12,99,111,95,115,97,118,101,118,97,108,
  117,101,0,11,111,110,99,101,108,108,101,118,101,110,116,7,22,112,114,111,
  106,101,99,116,101,100,105,116,111,110,99,101,108,108,101,118,101,110,116,10,
  119,105,100,103,101,116,110,97,109,101,6,11,112,114,111,106,101,99,116,101,
  100,105,116,0,1,12,108,105,110,101,99,111,108,111,114,102,105,120,4,3,
  0,0,160,5,119,105,100,116,104,3,129,0,7,111,112,116,105,111,110,115,
  11,7,99,111,95,102,105,108,108,12,99,111,95,115,97,118,101,118,97,108,
  117,101,12,99,111,95,115,97,118,101,115,116,97,116,101,10,99,111,95,114,
  111,119,102,111,110,116,11,99,111,95,114,111,119,99,111,108,111,114,13,99,
  111,95,122,101,98,114,97,99,111,108,111,114,0,10,119,105,100,103,101,116,
  110,97,109,101,6,4,101,100,105,116,0,0,13,100,97,116,97,114,111,119,
  104,101,105,103,104,116,2,16,22,100,114,97,103,46,111,110,98,101,102,111,
  114,101,100,114,97,103,98,101,103,105,110,7,15,103,114,105,100,111,110,100,
  114,97,103,98,101,103,105,110,21,100,114,97,103,46,111,110,98,101,102,111,
  114,101,100,114,97,103,100,114,111,112,7,15,103,114,105,100,111,110,100,101,
  114,97,103,100,114,111,112,20,100,114,97,103,46,111,110,97,102,116,101,114,
  100,114,97,103,111,118,101,114,7,14,103,114,105,100,111,110,100,114,97,103,
  111,118,101,114,13,114,101,102,102,111,110,116,104,101,105,103,104,116,2,14,
  0,13,116,116,114,101,101,105,116,101,109,101,100,105,116,11,112,114,111,106,
  101,99,116,101,100,105,116,13,111,112,116,105,111,110,115,119,105,100,103,101,
  116,11,13,111,119,95,109,111,117,115,101,102,111,99,117,115,11,111,119,95,
  116,97,98,102,111,99,117,115,13,111,119,95,97,114,114,111,119,102,111,99,
  117,115,15,111,119,95,97,114,114,111,119,102,111,99,117,115,105,110,16,111,
  119,95,97,114,114,111,119,102,111,99,117,115,111,117,116,17,111,119,95,100,
  101,115,116,114,111,121,119,105,100,103,101,116,115,18,111,119,95,102,111,110,
  116,103,108,121,112,104,104,101,105,103,104,116,12,111,119,95,97,117,116,111,
  115,99,97,108,101,0,8,98,111,117,110,100,115,95,120,2,0,8,98,111,
  117,110,100,115,95,121,2,0,9,98,111,117,110,100,115,95,99,120,3,141,
  0,9,98,111,117,110,100,115,95,99,121,2,16,5,99,111,108,111,114,4,
  7,0,0,144,12,102,114,97,109,101,46,108,101,118,101,108,111,2,0,17,
  102,114,97,109,101,46,99,111,108,111,114,99,108,105,101,110,116,4,2,0,
  0,128,16,102,114,97,109,101,46,108,111,99,97,108,112,114,111,112,115,11,
  10,102,114,108,95,108,101,118,101,108,111,15,102,114,108,95,99,111,108,111,
  114,99,108,105,101,110,116,0,11,102,114,97,109,101,46,100,117,109,109,121,
  2,0,8,116,97,98,111,114,100,101,114,2,1,7,111,110,112,111,112,117,
  112,7,18,112,114,111,106,101,99,116,101,100,105,116,111,110,112,111,112,117,
  112,7,118,105,115,105,98,108,101,8,11,111,112,116,105,111,110,115,101,100,
  105,116,11,11,111,101,95,114,101,97,100,111,110,108,121,12,111,101,95,117,
  110,100,111,111,110,101,115,99,16,111,101,95,99,104,101,99,107,109,114,99,
  97,110,99,101,108,15,111,101,95,101,120,105,116,111,110,99,117,114,115,111,
  114,9,111,101,95,108,111,99,97,116,101,12,111,101,95,115,97,118,101,118,
  97,108,117,101,12,111,101,95,115,97,118,101,115,116,97,116,101,0,8,111,
  110,99,104,97,110,103,101,7,19,112,114,111,106,101,99,116,101,100,105,116,
  111,110,99,104,97,110,103,101,23,105,116,101,109,108,105,115,116,46,111,110,
  115,116,97,116,114,101,97,100,105,116,101,109,7,25,112,114,111,106,101,99,
  116,101,100,105,116,111,110,115,116,97,116,114,101,97,100,105,116,101,109,17,
  111,110,117,112,100,97,116,101,114,111,119,118,97,108,117,101,115,7,28,112,
  114,111,106,101,99,116,101,100,105,116,111,110,117,112,100,97,116,101,114,111,
  119,118,97,108,117,101,115,9,102,105,101,108,100,101,100,105,116,7,4,101,
  100,105,116,7,111,112,116,105,111,110,115,11,16,116,101,111,95,116,114,101,
  101,99,111,108,110,97,118,105,103,16,116,101,111,95,107,101,121,114,111,119,
  109,111,118,105,110,103,0,14,111,110,99,104,101,99,107,114,111,119,109,111,
  118,101,7,18,105,116,101,109,111,110,99,104,101,99,107,114,111,119,109,111,
  118,101,13,114,101,102,102,111,110,116,104,101,105,103,104,116,2,14,0,0,
  16,116,114,101,99,111,114,100,102,105,101,108,100,101,100,105,116,4,101,100,
  105,116,13,111,112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,
  95,109,111,117,115,101,102,111,99,117,115,11,111,119,95,116,97,98,102,111,
  99,117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,115,15,111,119,
  95,97,114,114,111,119,102,111,99,117,115,105,110,16,111,119,95,97,114,114,
  111,119,102,111,99,117,115,111,117,116,17,111,119,95,100,101,115,116,114,111,
  121,119,105,100,103,101,116,115,18,111,119,95,102,111,110,116,103,108,121,112,
  104,104,101,105,103,104,116,12,111,119,95,97,117,116,111,115,99,97,108,101,
  0,8,98,111,117,110,100,115,95,120,3,142,0,8,98,111,117,110,100,115,
  95,121,2,0,9,98,111,117,110,100,115,95,99,120,3,129,0,9,98,111,
  117,110,100,115,95,99,121,2,16,5,99,111,108,111,114,4,7,0,0,144,
  12,102,114,97,109,101,46,108,101,118,101,108,111,2,0,17,102,114,97,109,
  101,46,99,111,108,111,114,99,108,105,101,110,116,4,3,0,0,128,16,102,
  114,97,109,101,46,108,111,99,97,108,112,114,111,112,115,11,10,102,114,108,
  95,108,101,118,101,108,111,15,102,114,108,95,99,111,108,111,114,99,108,105,
  101,110,116,0,11,102,114,97,109,101,46,100,117,109,109,121,2,0,8,116,
  97,98,111,114,100,101,114,2,2,7,118,105,115,105,98,108,101,8,13,114,
  101,102,102,111,110,116,104,101,105,103,104,116,2,14,0,0,0,10,116,112,
  111,112,117,112,109,101,110,117,9,117,110,105,116,112,111,112,117,112,8,111,
  110,117,112,100,97,116,101,7,17,117,110,105,116,112,111,112,117,112,111,110,
  117,112,100,97,116,101,11,109,101,110,117,46,97,99,116,105,111,110,7,14,
  97,100,100,117,110,105,116,102,105,108,101,97,99,116,18,109,101,110,117,46,
  115,117,98,109,101,110,117,46,99,111,117,110,116,2,2,18,109,101,110,117,
  46,115,117,98,109,101,110,117,46,105,116,101,109,115,14,1,6,97,99,116,
  105,111,110,7,14,97,100,100,117,110,105,116,102,105,108,101,97,99,116,0,
  1,6,97,99,116,105,111,110,7,17,114,101,109,111,118,101,117,110,105,116,
  102,105,108,101,97,99,116,0,0,4,108,101,102,116,2,32,3,116,111,112,
  2,40,0,0,7,116,97,99,116,105,111,110,14,97,100,100,117,110,105,116,
  102,105,108,101,97,99,116,7,99,97,112,116,105,111,110,6,9,38,65,100,
  100,32,85,110,105,116,9,111,110,101,120,101,99,117,116,101,7,20,97,100,
  100,117,110,105,116,102,105,108,101,111,110,101,120,101,99,117,116,101,4,108,
  101,102,116,2,32,3,116,111,112,2,72,0,0,11,116,102,105,108,101,100,
  105,97,108,111,103,14,117,110,105,116,102,105,108,101,100,105,97,108,111,103,
  26,99,111,110,116,114,111,108,108,101,114,46,104,105,115,116,111,114,121,109,
  97,120,99,111,117,110,116,2,0,10,100,105,97,108,111,103,107,105,110,100,
  7,8,102,100,107,95,110,111,110,101,4,108,101,102,116,3,144,0,3,116,
  111,112,2,40,0,0,7,116,97,99,116,105,111,110,17,114,101,109,111,118,
  101,117,110,105,116,102,105,108,101,97,99,116,7,99,97,112,116,105,111,110,
  6,12,38,82,101,109,111,118,101,32,85,110,105,116,9,111,110,101,120,101,
  99,117,116,101,7,23,114,101,109,111,118,101,117,110,105,116,102,105,108,101,
  111,110,101,120,101,99,117,116,101,4,108,101,102,116,2,32,3,116,111,112,
  2,96,0,0,0)
 );

initialization
 registerobjectdata(@objdata,tprojecttreefo,'');
end.
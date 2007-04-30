unit msetexteditor_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface

implementation
uses
 mseclasses,msetexteditor;

const
 objdata: record size: integer; data: array[0..3388] of byte end =
      (size: 3389; data: (
  84,80,70,48,16,116,109,115,101,116,101,120,116,101,100,105,116,111,114,102,
  111,15,109,115,101,116,101,120,116,101,100,105,116,111,114,102,111,13,111,112,
  116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,97,114,114,111,
  119,102,111,99,117,115,11,111,119,95,115,117,98,102,111,99,117,115,17,111,
  119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,9,111,119,95,
  104,105,110,116,111,110,12,111,119,95,97,117,116,111,115,99,97,108,101,0,
  8,98,111,117,110,100,115,95,120,2,79,8,98,111,117,110,100,115,95,121,
  3,219,0,9,98,111,117,110,100,115,95,99,120,3,113,1,9,98,111,117,
  110,100,115,95,99,121,3,12,1,8,116,97,98,111,114,100,101,114,2,1,
  7,118,105,115,105,98,108,101,8,23,99,111,110,116,97,105,110,101,114,46,
  111,112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,109,111,
  117,115,101,102,111,99,117,115,11,111,119,95,116,97,98,102,111,99,117,115,
  13,111,119,95,97,114,114,111,119,102,111,99,117,115,11,111,119,95,115,117,
  98,102,111,99,117,115,19,111,119,95,109,111,117,115,101,116,114,97,110,115,
  112,97,114,101,110,116,17,111,119,95,100,101,115,116,114,111,121,119,105,100,
  103,101,116,115,12,111,119,95,97,117,116,111,115,99,97,108,101,0,18,99,
  111,110,116,97,105,110,101,114,46,98,111,117,110,100,115,95,120,2,0,18,
  99,111,110,116,97,105,110,101,114,46,98,111,117,110,100,115,95,121,2,0,
  19,99,111,110,116,97,105,110,101,114,46,98,111,117,110,100,115,95,99,120,
  3,113,1,19,99,111,110,116,97,105,110,101,114,46,98,111,117,110,100,115,
  95,99,121,3,12,1,21,99,111,110,116,97,105,110,101,114,46,102,114,97,
  109,101,46,100,117,109,109,121,2,0,8,115,116,97,116,102,105,108,101,7,
  10,116,115,116,97,116,102,105,108,101,49,7,99,97,112,116,105,111,110,6,
  10,84,101,120,116,101,100,105,116,111,114,17,105,99,111,110,46,116,114,97,
  110,115,112,97,114,101,110,99,121,4,0,0,0,128,15,109,111,100,117,108,
  101,99,108,97,115,115,110,97,109,101,6,8,116,109,115,101,102,111,114,109,
  0,7,116,98,117,116,116,111,110,2,111,107,8,98,111,117,110,100,115,95,
  120,3,248,0,8,98,111,117,110,100,115,95,121,3,240,0,9,98,111,117,
  110,100,115,95,99,120,2,50,9,98,111,117,110,100,115,95,99,121,2,22,
  7,97,110,99,104,111,114,115,11,8,97,110,95,114,105,103,104,116,9,97,
  110,95,98,111,116,116,111,109,0,5,115,116,97,116,101,11,15,97,115,95,
  108,111,99,97,108,99,97,112,116,105,111,110,0,7,99,97,112,116,105,111,
  110,6,3,38,79,75,11,109,111,100,97,108,114,101,115,117,108,116,7,5,
  109,114,95,111,107,0,0,7,116,98,117,116,116,111,110,6,99,97,110,99,
  101,108,8,98,111,117,110,100,115,95,120,3,56,1,8,98,111,117,110,100,
  115,95,121,3,240,0,9,98,111,117,110,100,115,95,99,120,2,50,9,98,
  111,117,110,100,115,95,99,121,2,22,7,97,110,99,104,111,114,115,11,8,
  97,110,95,114,105,103,104,116,9,97,110,95,98,111,116,116,111,109,0,8,
  116,97,98,111,114,100,101,114,2,1,5,115,116,97,116,101,11,15,97,115,
  95,108,111,99,97,108,99,97,112,116,105,111,110,0,7,99,97,112,116,105,
  111,110,6,7,38,67,97,110,99,101,108,11,109,111,100,97,108,114,101,115,
  117,108,116,7,9,109,114,95,99,97,110,99,101,108,0,0,11,116,119,105,
  100,103,101,116,103,114,105,100,4,103,114,105,100,13,111,112,116,105,111,110,
  115,119,105,100,103,101,116,11,13,111,119,95,109,111,117,115,101,102,111,99,
  117,115,11,111,119,95,116,97,98,102,111,99,117,115,13,111,119,95,97,114,
  114,111,119,102,111,99,117,115,17,111,119,95,102,111,99,117,115,98,97,99,
  107,111,110,101,115,99,17,111,119,95,100,101,115,116,114,111,121,119,105,100,
  103,101,116,115,18,111,119,95,102,111,110,116,103,108,121,112,104,104,101,105,
  103,104,116,12,111,119,95,97,117,116,111,115,99,97,108,101,0,8,98,111,
  117,110,100,115,95,120,2,0,8,98,111,117,110,100,115,95,121,2,0,9,
  98,111,117,110,100,115,95,99,120,3,113,1,9,98,111,117,110,100,115,95,
  99,121,3,234,0,11,102,114,97,109,101,46,100,117,109,109,121,2,0,7,
  97,110,99,104,111,114,115,11,6,97,110,95,116,111,112,9,97,110,95,98,
  111,116,116,111,109,0,8,116,97,98,111,114,100,101,114,2,2,9,112,111,
  112,117,112,109,101,110,117,7,11,116,112,111,112,117,112,109,101,110,117,49,
  11,111,112,116,105,111,110,115,103,114,105,100,11,19,111,103,95,102,111,99,
  117,115,99,101,108,108,111,110,101,110,116,101,114,15,111,103,95,97,117,116,
  111,102,105,114,115,116,114,111,119,13,111,103,95,97,117,116,111,97,112,112,
  101,110,100,20,111,103,95,99,111,108,99,104,97,110,103,101,111,110,116,97,
  98,107,101,121,12,111,103,95,97,117,116,111,112,111,112,117,112,0,13,102,
  105,120,99,111,108,115,46,99,111,117,110,116,2,1,13,102,105,120,99,111,
  108,115,46,105,116,101,109,115,14,1,9,108,105,110,101,119,105,100,116,104,
  2,0,5,119,105,100,116,104,2,20,8,110,117,109,115,116,97,114,116,2,
  1,7,110,117,109,115,116,101,112,2,1,0,0,14,100,97,116,97,99,111,
  108,115,46,99,111,117,110,116,2,1,14,100,97,116,97,99,111,108,115,46,
  105,116,101,109,115,14,1,5,119,105,100,116,104,3,208,7,7,111,112,116,
  105,111,110,115,11,22,99,111,95,108,101,102,116,98,117,116,116,111,110,102,
  111,99,117,115,111,110,108,121,12,99,111,95,115,97,118,101,118,97,108,117,
  101,12,99,111,95,115,97,118,101,115,116,97,116,101,10,99,111,95,114,111,
  119,102,111,110,116,11,99,111,95,114,111,119,99,111,108,111,114,13,99,111,
  95,122,101,98,114,97,99,111,108,111,114,17,99,111,95,109,111,117,115,101,
  115,99,114,111,108,108,114,111,119,0,10,119,105,100,103,101,116,110,97,109,
  101,6,8,116,101,120,116,101,100,105,116,0,0,16,100,97,116,97,114,111,
  119,108,105,110,101,119,105,100,116,104,2,0,13,100,97,116,97,114,111,119,
  104,101,105,103,104,116,2,16,13,114,101,102,102,111,110,116,104,101,105,103,
  104,116,2,14,0,11,116,115,121,110,116,97,120,101,100,105,116,8,116,101,
  120,116,101,100,105,116,13,111,112,116,105,111,110,115,119,105,100,103,101,116,
  11,13,111,119,95,109,111,117,115,101,102,111,99,117,115,11,111,119,95,116,
  97,98,102,111,99,117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,
  115,17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,17,
  111,119,95,102,111,110,116,108,105,110,101,104,101,105,103,104,116,12,111,119,
  95,97,117,116,111,115,99,97,108,101,0,8,98,111,117,110,100,115,95,120,
  2,0,8,98,111,117,110,100,115,95,121,2,0,9,98,111,117,110,100,115,
  95,99,120,3,208,7,9,98,111,117,110,100,115,95,99,121,2,16,8,116,
  97,98,111,114,100,101,114,2,1,7,118,105,115,105,98,108,101,8,11,111,
  112,116,105,111,110,115,101,100,105,116,11,13,111,101,95,99,108,111,115,101,
  113,117,101,114,121,16,111,101,95,99,104,101,99,107,109,114,99,97,110,99,
  101,108,15,111,101,95,101,120,105,116,111,110,99,117,114,115,111,114,12,111,
  101,95,108,105,110,101,98,114,101,97,107,12,111,101,95,101,97,116,114,101,
  116,117,114,110,13,111,101,95,107,101,121,101,120,101,99,117,116,101,12,111,
  101,95,115,97,118,101,118,97,108,117,101,12,111,101,95,115,97,118,101,115,
  116,97,116,101,0,15,109,97,114,103,105,110,108,105,110,101,99,111,108,111,
  114,4,0,0,0,128,17,111,110,101,100,105,116,110,111,116,105,102,99,97,
  116,105,111,110,7,10,101,100,105,116,110,111,116,105,102,121,13,114,101,102,
  102,111,110,116,104,101,105,103,104,116,2,14,0,0,0,11,116,115,116,114,
  105,110,103,100,105,115,112,8,108,105,110,101,100,105,115,112,8,98,111,117,
  110,100,115,95,120,2,8,8,98,111,117,110,100,115,95,121,3,242,0,9,
  98,111,117,110,100,115,95,99,120,2,76,11,102,114,97,109,101,46,100,117,
  109,109,121,2,0,7,97,110,99,104,111,114,115,11,7,97,110,95,108,101,
  102,116,9,97,110,95,98,111,116,116,111,109,0,8,116,97,98,111,114,100,
  101,114,2,4,9,116,101,120,116,102,108,97,103,115,11,12,116,102,95,120,
  99,101,110,116,101,114,101,100,12,116,102,95,121,99,101,110,116,101,114,101,
  100,0,13,114,101,102,102,111,110,116,104,101,105,103,104,116,2,14,0,0,
  7,116,98,117,116,116,111,110,4,116,101,115,116,8,98,111,117,110,100,115,
  95,120,3,184,0,8,98,111,117,110,100,115,95,121,3,240,0,9,98,111,
  117,110,100,115,95,99,120,2,50,9,98,111,117,110,100,115,95,99,121,2,
  22,7,97,110,99,104,111,114,115,11,8,97,110,95,114,105,103,104,116,9,
  97,110,95,98,111,116,116,111,109,0,8,116,97,98,111,114,100,101,114,2,
  3,5,115,116,97,116,101,11,11,97,115,95,100,105,115,97,98,108,101,100,
  12,97,115,95,105,110,118,105,115,105,98,108,101,16,97,115,95,108,111,99,
  97,108,100,105,115,97,98,108,101,100,17,97,115,95,108,111,99,97,108,105,
  110,118,105,115,105,98,108,101,15,97,115,95,108,111,99,97,108,99,97,112,
  116,105,111,110,17,97,115,95,108,111,99,97,108,111,110,101,120,101,99,117,
  116,101,0,7,99,97,112,116,105,111,110,6,5,38,84,101,115,116,9,111,
  110,101,120,101,99,117,116,101,7,7,116,101,115,116,101,120,101,0,0,10,
  116,112,111,112,117,112,109,101,110,117,11,116,112,111,112,117,112,109,101,110,
  117,49,18,109,101,110,117,46,115,117,98,109,101,110,117,46,99,111,117,110,
  116,2,8,18,109,101,110,117,46,115,117,98,109,101,110,117,46,105,116,101,
  109,115,14,1,7,99,97,112,116,105,111,110,6,5,38,85,110,100,111,4,
  110,97,109,101,6,4,117,110,100,111,5,115,116,97,116,101,11,15,97,115,
  95,108,111,99,97,108,99,97,112,116,105,111,110,17,97,115,95,108,111,99,
  97,108,111,110,101,120,101,99,117,116,101,0,9,111,110,101,120,101,99,117,
  116,101,7,7,117,110,100,111,101,120,101,0,1,7,99,97,112,116,105,111,
  110,6,5,38,82,101,100,111,4,110,97,109,101,6,4,114,101,100,111,5,
  115,116,97,116,101,11,15,97,115,95,108,111,99,97,108,99,97,112,116,105,
  111,110,17,97,115,95,108,111,99,97,108,111,110,101,120,101,99,117,116,101,
  0,9,111,110,101,120,101,99,117,116,101,7,7,114,101,100,111,101,120,101,
  0,1,7,99,97,112,116,105,111,110,6,5,38,67,111,112,121,4,110,97,
  109,101,6,4,99,111,112,121,5,115,116,97,116,101,11,15,97,115,95,108,
  111,99,97,108,99,97,112,116,105,111,110,16,97,115,95,108,111,99,97,108,
  115,104,111,114,116,99,117,116,17,97,115,95,108,111,99,97,108,111,110,101,
  120,101,99,117,116,101,0,8,115,104,111,114,116,99,117,116,3,67,64,9,
  111,110,101,120,101,99,117,116,101,7,7,99,111,112,121,101,120,101,0,1,
  7,99,97,112,116,105,111,110,6,4,67,117,38,116,4,110,97,109,101,6,
  3,99,117,116,5,115,116,97,116,101,11,15,97,115,95,108,111,99,97,108,
  99,97,112,116,105,111,110,16,97,115,95,108,111,99,97,108,115,104,111,114,
  116,99,117,116,17,97,115,95,108,111,99,97,108,111,110,101,120,101,99,117,
  116,101,0,8,115,104,111,114,116,99,117,116,3,88,64,9,111,110,101,120,
  101,99,117,116,101,7,6,99,117,116,101,120,101,0,1,7,99,97,112,116,
  105,111,110,6,6,38,80,97,115,116,101,4,110,97,109,101,6,5,112,97,
  115,116,101,5,115,116,97,116,101,11,15,97,115,95,108,111,99,97,108,99,
  97,112,116,105,111,110,16,97,115,95,108,111,99,97,108,115,104,111,114,116,
  99,117,116,17,97,115,95,108,111,99,97,108,111,110,101,120,101,99,117,116,
  101,0,8,115,104,111,114,116,99,117,116,3,86,64,9,111,110,101,120,101,
  99,117,116,101,7,8,112,97,115,116,101,101,120,101,0,1,7,111,112,116,
  105,111,110,115,11,13,109,97,111,95,115,101,112,97,114,97,116,111,114,19,
  109,97,111,95,115,104,111,114,116,99,117,116,99,97,112,116,105,111,110,0,
  0,1,7,99,97,112,116,105,111,110,6,10,38,76,111,97,100,32,102,105,
  108,101,5,115,116,97,116,101,11,15,97,115,95,108,111,99,97,108,99,97,
  112,116,105,111,110,17,97,115,95,108,111,99,97,108,111,110,101,120,101,99,
  117,116,101,0,9,111,110,101,120,101,99,117,116,101,7,11,108,111,97,100,
  102,105,108,101,101,120,101,0,1,7,99,97,112,116,105,111,110,6,10,38,
  83,97,118,101,32,102,105,108,101,5,115,116,97,116,101,11,15,97,115,95,
  108,111,99,97,108,99,97,112,116,105,111,110,17,97,115,95,108,111,99,97,
  108,111,110,101,120,101,99,117,116,101,0,9,111,110,101,120,101,99,117,116,
  101,7,11,115,97,118,101,102,105,108,101,101,120,101,0,0,8,111,110,117,
  112,100,97,116,101,7,15,112,111,112,117,112,117,112,111,110,117,112,100,97,
  116,101,4,108,101,102,116,2,80,3,116,111,112,2,64,0,0,11,116,102,
  105,108,101,100,105,97,108,111,103,10,102,105,108,101,100,105,97,108,111,103,
  8,115,116,97,116,102,105,108,101,7,10,116,115,116,97,116,102,105,108,101,
  49,22,99,111,110,116,114,111,108,108,101,114,46,99,97,112,116,105,111,110,
  111,112,101,110,6,9,76,111,97,100,32,102,105,108,101,22,99,111,110,116,
  114,111,108,108,101,114,46,99,97,112,116,105,111,110,115,97,118,101,6,9,
  83,97,118,101,32,102,105,108,101,10,100,105,97,108,111,103,107,105,110,100,
  7,8,102,100,107,95,110,111,110,101,4,108,101,102,116,2,80,3,116,111,
  112,2,104,0,0,9,116,115,116,97,116,102,105,108,101,10,116,115,116,97,
  116,102,105,108,101,49,8,102,105,108,101,110,97,109,101,6,14,116,101,120,
  116,101,100,105,116,111,114,46,115,116,97,7,111,112,116,105,111,110,115,11,
  10,115,102,111,95,109,101,109,111,114,121,0,4,108,101,102,116,2,80,3,
  116,111,112,3,152,0,0,0,0)
 );

initialization
 registerobjectdata(@objdata,tmsetexteditorfo,'');
end.

unit replacedialogform_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface

implementation
uses
 mseclasses,replacedialogform;

const
 objdata: record size: integer; data: array[0..2546] of byte end =
      (size: 2547; data: (
  84,80,70,48,16,116,114,101,112,108,97,99,101,100,105,97,108,111,103,102,
  111,15,114,101,112,108,97,99,101,100,105,97,108,111,103,102,111,13,111,112,
  116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,97,114,114,111,
  119,102,111,99,117,115,11,111,119,95,115,117,98,102,111,99,117,115,17,111,
  119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,9,111,119,95,
  104,105,110,116,111,110,12,111,119,95,97,117,116,111,115,99,97,108,101,0,
  8,98,111,117,110,100,115,95,120,3,142,0,8,98,111,117,110,100,115,95,
  121,3,46,1,9,98,111,117,110,100,115,95,99,120,3,165,1,9,98,111,
  117,110,100,115,95,99,121,3,163,0,23,99,111,110,116,97,105,110,101,114,
  46,111,112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,109,
  111,117,115,101,102,111,99,117,115,11,111,119,95,116,97,98,102,111,99,117,
  115,13,111,119,95,97,114,114,111,119,102,111,99,117,115,11,111,119,95,115,
  117,98,102,111,99,117,115,19,111,119,95,109,111,117,115,101,116,114,97,110,
  115,112,97,114,101,110,116,17,111,119,95,100,101,115,116,114,111,121,119,105,
  100,103,101,116,115,12,111,119,95,97,117,116,111,115,99,97,108,101,0,19,
  99,111,110,116,97,105,110,101,114,46,98,111,117,110,100,115,95,99,120,3,
  165,1,19,99,111,110,116,97,105,110,101,114,46,98,111,117,110,100,115,95,
  99,121,3,163,0,21,99,111,110,116,97,105,110,101,114,46,102,114,97,109,
  101,46,100,117,109,109,121,2,0,7,111,112,116,105,111,110,115,11,14,102,
  111,95,102,114,101,101,111,110,99,108,111,115,101,13,102,111,95,99,108,111,
  115,101,111,110,101,115,99,17,102,111,95,108,111,99,97,108,115,104,111,114,
  116,99,117,116,115,15,102,111,95,97,117,116,111,114,101,97,100,115,116,97,
  116,16,102,111,95,97,117,116,111,119,114,105,116,101,115,116,97,116,10,102,
  111,95,115,97,118,101,112,111,115,0,8,115,116,97,116,102,105,108,101,7,
  9,115,116,97,116,102,105,108,101,49,17,105,99,111,110,46,116,114,97,110,
  115,112,97,114,101,110,99,121,4,0,0,0,128,15,109,111,100,117,108,101,
  99,108,97,115,115,110,97,109,101,6,8,116,109,115,101,102,111,114,109,0,
  12,116,104,105,115,116,111,114,121,101,100,105,116,8,102,105,110,100,116,101,
  120,116,13,111,112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,
  95,109,111,117,115,101,102,111,99,117,115,11,111,119,95,116,97,98,102,111,
  99,117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,115,15,111,119,
  95,97,114,114,111,119,102,111,99,117,115,105,110,16,111,119,95,97,114,114,
  111,119,102,111,99,117,115,111,117,116,17,111,119,95,100,101,115,116,114,111,
  121,119,105,100,103,101,116,115,18,111,119,95,102,111,110,116,103,108,121,112,
  104,104,101,105,103,104,116,12,111,119,95,97,117,116,111,115,99,97,108,101,
  0,8,98,111,117,110,100,115,95,120,2,8,8,98,111,117,110,100,115,95,
  121,2,7,9,98,111,117,110,100,115,95,99,120,3,148,1,9,98,111,117,
  110,100,115,95,99,121,2,37,13,102,114,97,109,101,46,99,97,112,116,105,
  111,110,6,13,84,101,120,116,32,116,111,32,38,102,105,110,100,11,102,114,
  97,109,101,46,100,117,109,109,121,2,0,16,102,114,97,109,101,46,111,117,
  116,101,114,102,114,97,109,101,1,2,0,2,17,2,0,2,0,0,7,97,
  110,99,104,111,114,115,11,7,97,110,95,108,101,102,116,6,97,110,95,116,
  111,112,8,97,110,95,114,105,103,104,116,0,19,100,114,111,112,100,111,119,
  110,46,99,111,108,115,46,99,111,117,110,116,2,1,19,100,114,111,112,100,
  111,119,110,46,99,111,108,115,46,105,116,101,109,115,14,1,0,0,13,114,
  101,102,102,111,110,116,104,101,105,103,104,116,2,14,0,0,12,116,104,105,
  115,116,111,114,121,101,100,105,116,11,114,101,112,108,97,99,101,116,101,120,
  116,13,111,112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,
  109,111,117,115,101,102,111,99,117,115,11,111,119,95,116,97,98,102,111,99,
  117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,115,15,111,119,95,
  97,114,114,111,119,102,111,99,117,115,105,110,16,111,119,95,97,114,114,111,
  119,102,111,99,117,115,111,117,116,17,111,119,95,100,101,115,116,114,111,121,
  119,105,100,103,101,116,115,18,111,119,95,102,111,110,116,103,108,121,112,104,
  104,101,105,103,104,116,12,111,119,95,97,117,116,111,115,99,97,108,101,0,
  8,98,111,117,110,100,115,95,120,2,8,8,98,111,117,110,100,115,95,121,
  2,47,9,98,111,117,110,100,115,95,99,120,3,148,1,9,98,111,117,110,
  100,115,95,99,121,2,37,13,102,114,97,109,101,46,99,97,112,116,105,111,
  110,6,13,38,82,101,112,108,97,99,101,32,119,105,116,104,11,102,114,97,
  109,101,46,100,117,109,109,121,2,0,16,102,114,97,109,101,46,111,117,116,
  101,114,102,114,97,109,101,1,2,0,2,17,2,0,2,0,0,7,97,110,
  99,104,111,114,115,11,7,97,110,95,108,101,102,116,6,97,110,95,116,111,
  112,8,97,110,95,114,105,103,104,116,0,8,116,97,98,111,114,100,101,114,
  2,1,8,115,116,97,116,102,105,108,101,7,9,115,116,97,116,102,105,108,
  101,49,19,100,114,111,112,100,111,119,110,46,99,111,108,115,46,99,111,117,
  110,116,2,1,19,100,114,111,112,100,111,119,110,46,99,111,108,115,46,105,
  116,101,109,115,14,1,0,0,13,114,101,102,102,111,110,116,104,101,105,103,
  104,116,2,14,0,0,12,116,98,111,111,108,101,97,110,101,100,105,116,13,
  99,97,115,101,115,101,110,115,105,116,105,118,101,8,98,111,117,110,100,115,
  95,120,2,8,8,98,111,117,110,100,115,95,121,2,96,9,98,111,117,110,
  100,115,95,99,120,2,90,9,98,111,117,110,100,115,95,99,121,2,16,13,
  102,114,97,109,101,46,99,97,112,116,105,111,110,6,14,38,99,97,115,101,
  115,101,110,115,105,116,105,118,101,11,102,114,97,109,101,46,100,117,109,109,
  121,2,0,16,102,114,97,109,101,46,111,117,116,101,114,102,114,97,109,101,
  1,2,0,2,1,2,77,2,2,0,8,116,97,98,111,114,100,101,114,2,
  2,0,0,12,116,98,111,111,108,101,97,110,101,100,105,116,9,119,104,111,
  108,101,119,111,114,100,8,98,111,117,110,100,115,95,120,2,112,8,98,111,
  117,110,100,115,95,121,2,96,9,98,111,117,110,100,115,95,99,120,2,79,
  9,98,111,117,110,100,115,95,99,121,2,16,13,102,114,97,109,101,46,99,
  97,112,116,105,111,110,6,11,38,119,104,111,108,101,32,119,111,114,100,11,
  102,114,97,109,101,46,100,117,109,109,121,2,0,16,102,114,97,109,101,46,
  111,117,116,101,114,102,114,97,109,101,1,2,0,2,1,2,66,2,2,0,
  8,116,97,98,111,114,100,101,114,2,3,0,0,7,116,98,117,116,116,111,
  110,15,116,105,110,116,101,103,101,114,98,117,116,116,111,110,49,8,98,111,
  117,110,100,115,95,120,2,8,8,98,111,117,110,100,115,95,121,2,123,9,
  98,111,117,110,100,115,95,99,120,2,74,9,98,111,117,110,100,115,95,99,
  121,2,20,8,116,97,98,111,114,100,101,114,2,6,5,115,116,97,116,101,
  11,15,97,115,95,108,111,99,97,108,99,97,112,116,105,111,110,0,7,99,
  97,112,116,105,111,110,6,8,38,82,101,112,108,97,99,101,11,109,111,100,
  97,108,114,101,115,117,108,116,7,5,109,114,95,111,107,0,0,7,116,98,
  117,116,116,111,110,15,116,105,110,116,101,103,101,114,98,117,116,116,111,110,
  50,8,98,111,117,110,100,115,95,120,2,88,8,98,111,117,110,100,115,95,
  121,2,123,9,98,111,117,110,100,115,95,99,120,2,74,9,98,111,117,110,
  100,115,95,99,121,2,20,8,116,97,98,111,114,100,101,114,2,7,5,115,
  116,97,116,101,11,15,97,115,95,108,111,99,97,108,99,97,112,116,105,111,
  110,0,7,99,97,112,116,105,111,110,6,12,82,101,112,108,97,99,101,32,
  38,97,108,108,11,109,111,100,97,108,114,101,115,117,108,116,7,6,109,114,
  95,97,108,108,0,0,12,116,98,111,111,108,101,97,110,101,100,105,116,12,
  115,101,108,101,99,116,101,100,111,110,108,121,8,98,111,117,110,100,115,95,
  120,3,208,0,8,98,111,117,110,100,115,95,121,2,96,9,98,111,117,110,
  100,115,95,99,120,2,88,9,98,111,117,110,100,115,95,99,121,2,16,13,
  102,114,97,109,101,46,99,97,112,116,105,111,110,6,14,115,101,108,101,99,
  116,38,101,100,32,111,110,108,121,11,102,114,97,109,101,46,100,117,109,109,
  121,2,0,16,102,114,97,109,101,46,111,117,116,101,114,102,114,97,109,101,
  1,2,0,2,1,2,75,2,2,0,8,116,97,98,111,114,100,101,114,2,
  4,8,115,116,97,116,102,105,108,101,7,9,115,116,97,116,102,105,108,101,
  49,0,0,7,116,98,117,116,116,111,110,15,116,105,110,116,101,103,101,114,
  98,117,116,116,111,110,51,8,98,111,117,110,100,115,95,120,3,168,0,8,
  98,111,117,110,100,115,95,121,2,123,9,98,111,117,110,100,115,95,99,120,
  2,74,9,98,111,117,110,100,115,95,99,121,2,20,8,116,97,98,111,114,
  100,101,114,2,8,5,115,116,97,116,101,11,10,97,115,95,100,101,102,97,
  117,108,116,15,97,115,95,108,111,99,97,108,100,101,102,97,117,108,116,15,
  97,115,95,108,111,99,97,108,99,97,112,116,105,111,110,0,7,99,97,112,
  116,105,111,110,6,7,38,67,97,110,99,101,108,11,109,111,100,97,108,114,
  101,115,117,108,116,7,9,109,114,95,99,97,110,99,101,108,0,0,12,116,
  98,111,111,108,101,97,110,101,100,105,116,15,112,114,111,109,112,116,111,110,
  114,101,112,108,97,99,101,8,98,111,117,110,100,115,95,120,3,56,1,8,
  98,111,117,110,100,115,95,121,2,96,9,98,111,117,110,100,115,95,99,120,
  2,93,9,98,111,117,110,100,115,95,99,121,2,16,13,102,114,97,109,101,
  46,99,97,112,116,105,111,110,6,15,38,112,114,111,109,112,116,32,111,110,
  32,114,101,112,46,11,102,114,97,109,101,46,100,117,109,109,121,2,0,16,
  102,114,97,109,101,46,111,117,116,101,114,102,114,97,109,101,1,2,0,2,
  1,2,80,2,2,0,8,116,97,98,111,114,100,101,114,2,5,8,115,116,
  97,116,102,105,108,101,7,9,115,116,97,116,102,105,108,101,49,5,118,97,
  108,117,101,9,0,0,9,116,115,116,97,116,102,105,108,101,9,115,116,97,
  116,102,105,108,101,49,8,102,105,108,101,110,97,109,101,6,19,114,101,112,
  108,97,99,101,100,105,97,108,111,103,102,111,46,115,116,97,7,111,112,116,
  105,111,110,115,11,10,115,102,111,95,109,101,109,111,114,121,0,4,108,101,
  102,116,2,112,0,0,0)
 );

initialization
 registerobjectdata(@objdata,treplacedialogfo,'');
end.
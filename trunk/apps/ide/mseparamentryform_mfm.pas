unit mseparamentryform_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,mseparamentryform;

const
 objdata: record size: integer; data: array[0..2835] of byte end =
      (size: 2836; data: (
  84,80,70,48,16,116,109,115,101,112,97,114,97,109,101,110,116,114,121,102,
  111,15,109,115,101,112,97,114,97,109,101,110,116,114,121,102,111,7,118,105,
  115,105,98,108,101,8,8,98,111,117,110,100,115,95,120,3,222,0,8,98,
  111,117,110,100,115,95,121,3,6,1,9,98,111,117,110,100,115,95,99,120,
  3,115,1,9,98,111,117,110,100,115,95,99,121,3,4,1,16,99,111,110,
  116,97,105,110,101,114,46,98,111,117,110,100,115,1,2,0,2,0,3,115,
  1,3,4,1,0,7,111,112,116,105,111,110,115,11,17,102,111,95,115,99,
  114,101,101,110,99,101,110,116,101,114,101,100,14,102,111,95,99,97,110,99,
  101,108,111,110,101,115,99,15,102,111,95,97,117,116,111,114,101,97,100,115,
  116,97,116,16,102,111,95,97,117,116,111,119,114,105,116,101,115,116,97,116,
  10,102,111,95,115,97,118,101,112,111,115,13,102,111,95,115,97,118,101,122,
  111,114,100,101,114,12,102,111,95,115,97,118,101,115,116,97,116,101,0,8,
  115,116,97,116,102,105,108,101,7,10,116,115,116,97,116,102,105,108,101,49,
  15,109,111,100,117,108,101,99,108,97,115,115,110,97,109,101,6,8,116,109,
  115,101,102,111,114,109,0,11,116,119,105,100,103,101,116,103,114,105,100,12,
  116,119,105,100,103,101,116,103,114,105,100,49,8,98,111,117,110,100,115,95,
  120,2,0,8,98,111,117,110,100,115,95,121,2,0,9,98,111,117,110,100,
  115,95,99,120,3,115,1,9,98,111,117,110,100,115,95,99,121,3,231,0,
  7,97,110,99,104,111,114,115,11,6,97,110,95,116,111,112,0,11,111,112,
  116,105,111,110,115,103,114,105,100,11,12,111,103,95,99,111,108,115,105,122,
  105,110,103,19,111,103,95,102,111,99,117,115,99,101,108,108,111,110,101,110,
  116,101,114,20,111,103,95,99,111,108,99,104,97,110,103,101,111,110,116,97,
  98,107,101,121,10,111,103,95,119,114,97,112,99,111,108,12,111,103,95,97,
  117,116,111,112,111,112,117,112,17,111,103,95,109,111,117,115,101,115,99,114,
  111,108,108,99,111,108,0,13,102,105,120,114,111,119,115,46,99,111,117,110,
  116,2,1,13,102,105,120,114,111,119,115,46,105,116,101,109,115,14,1,6,
  104,101,105,103,104,116,2,16,14,99,97,112,116,105,111,110,115,46,99,111,
  117,110,116,2,2,14,99,97,112,116,105,111,110,115,46,105,116,101,109,115,
  14,1,7,99,97,112,116,105,111,110,6,5,77,97,99,114,111,0,1,7,
  99,97,112,116,105,111,110,6,5,86,97,108,117,101,0,0,0,0,14,100,
  97,116,97,99,111,108,115,46,99,111,117,110,116,2,2,16,100,97,116,97,
  99,111,108,115,46,111,112,116,105,111,110,115,11,15,99,111,95,112,114,111,
  112,111,114,116,105,111,110,97,108,12,99,111,95,115,97,118,101,115,116,97,
  116,101,17,99,111,95,109,111,117,115,101,115,99,114,111,108,108,114,111,119,
  0,14,100,97,116,97,99,111,108,115,46,105,116,101,109,115,14,1,5,119,
  105,100,116,104,2,89,7,111,112,116,105,111,110,115,11,11,99,111,95,114,
  101,97,100,111,110,108,121,10,99,111,95,110,111,102,111,99,117,115,15,99,
  111,95,112,114,111,112,111,114,116,105,111,110,97,108,12,99,111,95,115,97,
  118,101,115,116,97,116,101,17,99,111,95,109,111,117,115,101,115,99,114,111,
  108,108,114,111,119,0,10,119,105,100,103,101,116,110,97,109,101,6,9,109,
  97,99,114,111,110,97,109,101,9,100,97,116,97,99,108,97,115,115,7,22,
  116,103,114,105,100,109,115,101,115,116,114,105,110,103,100,97,116,97,108,105,
  115,116,0,1,5,119,105,100,116,104,3,20,1,7,111,112,116,105,111,110,
  115,11,7,99,111,95,102,105,108,108,12,99,111,95,115,97,118,101,115,116,
  97,116,101,17,99,111,95,109,111,117,115,101,115,99,114,111,108,108,114,111,
  119,0,10,119,105,100,103,101,116,110,97,109,101,6,10,109,97,99,114,111,
  118,97,108,117,101,9,100,97,116,97,99,108,97,115,115,7,22,116,103,114,
  105,100,109,115,101,115,116,114,105,110,103,100,97,116,97,108,105,115,116,0,
  0,13,100,97,116,97,114,111,119,104,101,105,103,104,116,2,16,8,115,116,
  97,116,102,105,108,101,7,10,116,115,116,97,116,102,105,108,101,49,13,114,
  101,102,102,111,110,116,104,101,105,103,104,116,2,14,0,11,116,115,116,114,
  105,110,103,101,100,105,116,9,109,97,99,114,111,110,97,109,101,8,116,97,
  98,111,114,100,101,114,2,1,7,118,105,115,105,98,108,101,8,8,98,111,
  117,110,100,115,95,120,2,0,8,98,111,117,110,100,115,95,121,2,0,9,
  98,111,117,110,100,115,95,99,120,2,89,9,98,111,117,110,100,115,95,99,
  121,2,16,11,111,112,116,105,111,110,115,101,100,105,116,11,11,111,101,95,
  114,101,97,100,111,110,108,121,12,111,101,95,117,110,100,111,111,110,101,115,
  99,13,111,101,95,99,108,111,115,101,113,117,101,114,121,16,111,101,95,99,
  104,101,99,107,109,114,99,97,110,99,101,108,14,111,101,95,115,104,105,102,
  116,114,101,116,117,114,110,12,111,101,95,101,97,116,114,101,116,117,114,110,
  20,111,101,95,114,101,115,101,116,115,101,108,101,99,116,111,110,101,120,105,
  116,15,111,101,95,101,120,105,116,111,110,99,117,114,115,111,114,13,111,101,
  95,101,110,100,111,110,101,110,116,101,114,13,111,101,95,97,117,116,111,115,
  101,108,101,99,116,25,111,101,95,97,117,116,111,115,101,108,101,99,116,111,
  110,102,105,114,115,116,99,108,105,99,107,16,111,101,95,97,117,116,111,112,
  111,112,117,112,109,101,110,117,13,111,101,95,107,101,121,101,120,101,99,117,
  116,101,25,111,101,95,99,104,101,99,107,118,97,108,117,101,112,97,115,116,
  115,116,97,116,114,101,97,100,12,111,101,95,115,97,118,101,115,116,97,116,
  101,0,13,114,101,102,102,111,110,116,104,101,105,103,104,116,2,14,0,0,
  15,116,109,101,109,111,100,105,97,108,111,103,101,100,105,116,10,109,97,99,
  114,111,118,97,108,117,101,13,111,112,116,105,111,110,115,119,105,100,103,101,
  116,11,13,111,119,95,109,111,117,115,101,102,111,99,117,115,11,111,119,95,
  116,97,98,102,111,99,117,115,13,111,119,95,97,114,114,111,119,102,111,99,
  117,115,17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,
  18,111,119,95,102,111,110,116,103,108,121,112,104,104,101,105,103,104,116,0,
  11,111,112,116,105,111,110,115,115,107,105,110,11,19,111,115,107,95,102,114,
  97,109,101,98,117,116,116,111,110,111,110,108,121,0,12,102,114,97,109,101,
  46,108,101,118,101,108,111,2,0,16,102,114,97,109,101,46,108,111,99,97,
  108,112,114,111,112,115,11,10,102,114,108,95,108,101,118,101,108,111,0,18,
  102,114,97,109,101,46,98,117,116,116,111,110,46,99,111,108,111,114,4,2,
  0,0,128,20,102,114,97,109,101,46,98,117,116,116,111,110,46,105,109,97,
  103,101,110,114,2,17,8,116,97,98,111,114,100,101,114,2,2,7,118,105,
  115,105,98,108,101,8,8,98,111,117,110,100,115,95,120,2,90,8,98,111,
  117,110,100,115,95,121,2,0,9,98,111,117,110,100,115,95,99,120,3,20,
  1,9,98,111,117,110,100,115,95,99,121,2,16,11,111,112,116,105,111,110,
  115,101,100,105,116,11,12,111,101,95,117,110,100,111,111,110,101,115,99,13,
  111,101,95,99,108,111,115,101,113,117,101,114,121,16,111,101,95,99,104,101,
  99,107,109,114,99,97,110,99,101,108,14,111,101,95,115,104,105,102,116,114,
  101,116,117,114,110,12,111,101,95,101,97,116,114,101,116,117,114,110,20,111,
  101,95,114,101,115,101,116,115,101,108,101,99,116,111,110,101,120,105,116,15,
  111,101,95,101,120,105,116,111,110,99,117,114,115,111,114,13,111,101,95,101,
  110,100,111,110,101,110,116,101,114,13,111,101,95,97,117,116,111,115,101,108,
  101,99,116,25,111,101,95,97,117,116,111,115,101,108,101,99,116,111,110,102,
  105,114,115,116,99,108,105,99,107,16,111,101,95,97,117,116,111,112,111,112,
  117,112,109,101,110,117,13,111,101,95,107,101,121,101,120,101,99,117,116,101,
  25,111,101,95,99,104,101,99,107,118,97,108,117,101,112,97,115,116,115,116,
  97,116,114,101,97,100,12,111,101,95,115,97,118,101,115,116,97,116,101,0,
  13,114,101,102,102,111,110,116,104,101,105,103,104,116,2,14,0,0,0,9,
  116,115,112,108,105,116,116,101,114,10,116,115,112,108,105,116,116,101,114,49,
  5,99,111,108,111,114,4,1,0,0,128,8,116,97,98,111,114,100,101,114,
  2,1,8,98,111,117,110,100,115,95,120,2,0,8,98,111,117,110,100,115,
  95,121,3,231,0,9,98,111,117,110,100,115,95,99,120,3,115,1,9,98,
  111,117,110,100,115,95,99,121,2,25,7,97,110,99,104,111,114,115,11,9,
  97,110,95,98,111,116,116,111,109,0,12,111,112,116,105,111,110,115,115,99,
  97,108,101,11,11,111,115,99,95,101,120,112,97,110,100,121,11,111,115,99,
  95,115,104,114,105,110,107,121,0,7,108,105,110,107,116,111,112,7,12,116,
  119,105,100,103,101,116,103,114,105,100,49,4,103,114,105,112,7,8,115,116,
  98,95,110,111,110,101,0,7,116,98,117,116,116,111,110,8,116,98,117,116,
  116,111,110,50,8,98,111,117,110,100,115,95,120,3,56,1,8,98,111,117,
  110,100,115,95,121,2,5,9,98,111,117,110,100,115,95,99,120,2,50,9,
  98,111,117,110,100,115,95,99,121,2,20,7,97,110,99,104,111,114,115,11,
  6,97,110,95,116,111,112,8,97,110,95,114,105,103,104,116,0,5,115,116,
  97,116,101,11,15,97,115,95,108,111,99,97,108,99,97,112,116,105,111,110,
  0,7,99,97,112,116,105,111,110,6,6,67,97,110,99,101,108,11,109,111,
  100,97,108,114,101,115,117,108,116,7,9,109,114,95,99,97,110,99,101,108,
  0,0,7,116,98,117,116,116,111,110,8,116,98,117,116,116,111,110,49,8,
  116,97,98,111,114,100,101,114,2,1,8,98,111,117,110,100,115,95,120,3,
  0,1,8,98,111,117,110,100,115,95,121,2,5,9,98,111,117,110,100,115,
  95,99,120,2,50,9,98,111,117,110,100,115,95,99,121,2,20,7,97,110,
  99,104,111,114,115,11,6,97,110,95,116,111,112,8,97,110,95,114,105,103,
  104,116,0,5,115,116,97,116,101,11,10,97,115,95,100,101,102,97,117,108,
  116,15,97,115,95,108,111,99,97,108,100,101,102,97,117,108,116,15,97,115,
  95,108,111,99,97,108,99,97,112,116,105,111,110,0,7,99,97,112,116,105,
  111,110,6,2,79,75,11,109,111,100,97,108,114,101,115,117,108,116,7,5,
  109,114,95,111,107,0,0,6,116,108,97,98,101,108,7,99,111,109,109,101,
  110,116,14,111,112,116,105,111,110,115,119,105,100,103,101,116,49,11,14,111,
  119,49,95,97,117,116,111,104,101,105,103,104,116,0,8,116,97,98,111,114,
  100,101,114,2,2,8,98,111,117,110,100,115,95,120,2,2,8,98,111,117,
  110,100,115,95,121,2,2,9,98,111,117,110,100,115,95,99,120,3,252,0,
  9,98,111,117,110,100,115,95,99,121,2,14,7,97,110,99,104,111,114,115,
  11,7,97,110,95,108,101,102,116,6,97,110,95,116,111,112,8,97,110,95,
  114,105,103,104,116,0,7,99,97,112,116,105,111,110,6,7,99,111,109,109,
  101,110,116,9,116,101,120,116,102,108,97,103,115,11,12,116,102,95,121,99,
  101,110,116,101,114,101,100,12,116,102,95,119,111,114,100,98,114,101,97,107,
  0,13,114,101,102,102,111,110,116,104,101,105,103,104,116,2,14,0,0,0,
  9,116,115,116,97,116,102,105,108,101,10,116,115,116,97,116,102,105,108,101,
  49,8,102,105,108,101,110,97,109,101,6,14,116,101,109,112,108,112,97,114,
  97,109,46,115,116,97,7,111,112,116,105,111,110,115,11,10,115,102,111,95,
  109,101,109,111,114,121,15,115,102,111,95,116,114,97,110,115,97,99,116,105,
  111,110,17,115,102,111,95,97,99,116,105,118,97,116,111,114,114,101,97,100,
  18,115,102,111,95,97,99,116,105,118,97,116,111,114,119,114,105,116,101,0,
  4,108,101,102,116,2,40,3,116,111,112,2,80,0,0,0)
 );

initialization
 registerobjectdata(@objdata,tmseparamentryfo,'');
end.

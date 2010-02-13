unit msedoublestringlisteditor_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,msedoublestringlisteditor;

const
 objdata: record size: integer; data: array[0..3008] of byte end =
      (size: 3009; data: (
  84,80,70,48,23,116,100,111,117,98,108,101,115,116,114,105,110,103,108,105,
  115,116,101,100,105,116,111,114,22,100,111,117,98,108,101,115,116,114,105,110,
  103,108,105,115,116,101,100,105,116,111,114,13,111,112,116,105,111,110,115,119,
  105,100,103,101,116,11,13,111,119,95,97,114,114,111,119,102,111,99,117,115,
  11,111,119,95,115,117,98,102,111,99,117,115,17,111,119,95,100,101,115,116,
  114,111,121,119,105,100,103,101,116,115,9,111,119,95,104,105,110,116,111,110,
  12,111,119,95,97,117,116,111,115,99,97,108,101,0,8,98,111,117,110,100,
  115,95,120,3,130,0,8,98,111,117,110,100,115,95,121,3,203,0,9,98,
  111,117,110,100,115,95,99,120,3,82,1,9,98,111,117,110,100,115,95,99,
  121,3,194,0,8,116,97,98,111,114,100,101,114,2,1,23,99,111,110,116,
  97,105,110,101,114,46,111,112,116,105,111,110,115,119,105,100,103,101,116,11,
  13,111,119,95,109,111,117,115,101,102,111,99,117,115,11,111,119,95,116,97,
  98,102,111,99,117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,115,
  11,111,119,95,115,117,98,102,111,99,117,115,19,111,119,95,109,111,117,115,
  101,116,114,97,110,115,112,97,114,101,110,116,17,111,119,95,100,101,115,116,
  114,111,121,119,105,100,103,101,116,115,12,111,119,95,97,117,116,111,115,99,
  97,108,101,0,18,99,111,110,116,97,105,110,101,114,46,98,111,117,110,100,
  115,95,120,2,0,18,99,111,110,116,97,105,110,101,114,46,98,111,117,110,
  100,115,95,121,2,0,19,99,111,110,116,97,105,110,101,114,46,98,111,117,
  110,100,115,95,99,120,3,82,1,19,99,111,110,116,97,105,110,101,114,46,
  98,111,117,110,100,115,95,99,121,3,194,0,21,99,111,110,116,97,105,110,
  101,114,46,102,114,97,109,101,46,100,117,109,109,121,2,0,7,111,112,116,
  105,111,110,115,11,13,102,111,95,99,108,111,115,101,111,110,101,115,99,15,
  102,111,95,97,117,116,111,114,101,97,100,115,116,97,116,16,102,111,95,97,
  117,116,111,119,114,105,116,101,115,116,97,116,0,7,99,97,112,116,105,111,
  110,6,16,83,116,114,105,110,103,108,105,115,116,101,100,105,116,111,114,15,
  109,111,100,117,108,101,99,108,97,115,115,110,97,109,101,6,8,116,109,115,
  101,102,111,114,109,0,7,116,98,117,116,116,111,110,2,111,107,13,111,112,
  116,105,111,110,115,119,105,100,103,101,116,11,11,111,119,95,116,97,98,102,
  111,99,117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,115,17,111,
  119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,18,111,119,95,
  102,111,110,116,103,108,121,112,104,104,101,105,103,104,116,12,111,119,95,97,
  117,116,111,115,99,97,108,101,0,8,98,111,117,110,100,115,95,120,3,212,
  0,8,98,111,117,110,100,115,95,121,3,160,0,9,98,111,117,110,100,115,
  95,99,120,2,50,9,98,111,117,110,100,115,95,99,121,2,20,8,116,97,
  98,111,114,100,101,114,2,3,5,115,116,97,116,101,11,10,97,115,95,100,
  101,102,97,117,108,116,15,97,115,95,108,111,99,97,108,100,101,102,97,117,
  108,116,15,97,115,95,108,111,99,97,108,99,97,112,116,105,111,110,0,11,
  97,117,116,111,115,105,122,101,95,99,120,2,0,11,97,117,116,111,115,105,
  122,101,95,99,121,2,0,7,99,97,112,116,105,111,110,6,3,38,79,75,
  11,109,111,100,97,108,114,101,115,117,108,116,7,5,109,114,95,111,107,13,
  114,101,102,102,111,110,116,104,101,105,103,104,116,2,14,0,0,7,116,98,
  117,116,116,111,110,6,99,97,110,99,101,108,13,111,112,116,105,111,110,115,
  119,105,100,103,101,116,11,11,111,119,95,116,97,98,102,111,99,117,115,13,
  111,119,95,97,114,114,111,119,102,111,99,117,115,17,111,119,95,100,101,115,
  116,114,111,121,119,105,100,103,101,116,115,18,111,119,95,102,111,110,116,103,
  108,121,112,104,104,101,105,103,104,116,12,111,119,95,97,117,116,111,115,99,
  97,108,101,0,8,98,111,117,110,100,115,95,120,3,20,1,8,98,111,117,
  110,100,115,95,121,3,160,0,9,98,111,117,110,100,115,95,99,120,2,50,
  9,98,111,117,110,100,115,95,99,121,2,20,5,115,116,97,116,101,11,15,
  97,115,95,108,111,99,97,108,99,97,112,116,105,111,110,0,11,97,117,116,
  111,115,105,122,101,95,99,120,2,0,11,97,117,116,111,115,105,122,101,95,
  99,121,2,0,7,99,97,112,116,105,111,110,6,7,38,67,97,110,99,101,
  108,11,109,111,100,97,108,114,101,115,117,108,116,7,9,109,114,95,99,97,
  110,99,101,108,13,114,101,102,102,111,110,116,104,101,105,103,104,116,2,14,
  0,0,11,116,119,105,100,103,101,116,103,114,105,100,4,103,114,105,100,13,
  111,112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,109,111,
  117,115,101,102,111,99,117,115,11,111,119,95,116,97,98,102,111,99,117,115,
  13,111,119,95,97,114,114,111,119,102,111,99,117,115,17,111,119,95,102,111,
  99,117,115,98,97,99,107,111,110,101,115,99,13,111,119,95,109,111,117,115,
  101,119,104,101,101,108,17,111,119,95,100,101,115,116,114,111,121,119,105,100,
  103,101,116,115,18,111,119,95,102,111,110,116,103,108,121,112,104,104,101,105,
  103,104,116,12,111,119,95,97,117,116,111,115,99,97,108,101,0,8,98,111,
  117,110,100,115,95,120,2,8,8,98,111,117,110,100,115,95,121,2,8,9,
  98,111,117,110,100,115,95,99,120,3,64,1,9,98,111,117,110,100,115,95,
  99,121,3,140,0,11,102,114,97,109,101,46,100,117,109,109,121,2,0,7,
  97,110,99,104,111,114,115,11,7,97,110,95,108,101,102,116,6,97,110,95,
  116,111,112,8,97,110,95,114,105,103,104,116,9,97,110,95,98,111,116,116,
  111,109,0,8,116,97,98,111,114,100,101,114,2,2,11,111,112,116,105,111,
  110,115,103,114,105,100,11,12,111,103,95,99,111,108,115,105,122,105,110,103,
  12,111,103,95,114,111,119,109,111,118,105,110,103,15,111,103,95,107,101,121,
  114,111,119,109,111,118,105,110,103,15,111,103,95,114,111,119,105,110,115,101,
  114,116,105,110,103,14,111,103,95,114,111,119,100,101,108,101,116,105,110,103,
  19,111,103,95,102,111,99,117,115,99,101,108,108,111,110,101,110,116,101,114,
  15,111,103,95,97,117,116,111,102,105,114,115,116,114,111,119,13,111,103,95,
  97,117,116,111,97,112,112,101,110,100,10,111,103,95,119,114,97,112,99,111,
  108,0,13,102,105,120,99,111,108,115,46,99,111,117,110,116,2,1,13,102,
  105,120,99,111,108,115,46,105,116,101,109,115,14,1,5,119,105,100,116,104,
  2,31,7,110,117,109,115,116,101,112,2,1,0,0,13,102,105,120,114,111,
  119,115,46,99,111,117,110,116,2,1,13,102,105,120,114,111,119,115,46,105,
  116,101,109,115,14,1,6,104,101,105,103,104,116,2,16,14,99,97,112,116,
  105,111,110,115,46,99,111,117,110,116,2,2,14,99,97,112,116,105,111,110,
  115,46,105,116,101,109,115,14,1,7,99,97,112,116,105,111,110,6,1,97,
  9,116,101,120,116,102,108,97,103,115,11,0,0,1,7,99,97,112,116,105,
  111,110,6,1,98,9,116,101,120,116,102,108,97,103,115,11,0,0,0,0,
  0,14,100,97,116,97,99,111,108,115,46,99,111,117,110,116,2,2,14,100,
  97,116,97,99,111,108,115,46,105,116,101,109,115,14,1,5,119,105,100,116,
  104,3,142,0,10,119,105,100,103,101,116,110,97,109,101,6,5,116,101,120,
  116,97,0,1,5,119,105,100,116,104,3,140,0,7,111,112,116,105,111,110,
  115,11,7,99,111,95,102,105,108,108,12,99,111,95,115,97,118,101,118,97,
  108,117,101,0,10,119,105,100,103,101,116,110,97,109,101,6,5,116,101,120,
  116,98,0,0,13,100,97,116,97,114,111,119,104,101,105,103,104,116,2,16,
  17,111,110,114,111,119,99,111,117,110,116,99,104,97,110,103,101,100,7,21,
  103,114,105,100,111,110,114,111,119,99,111,117,110,116,99,104,97,110,103,101,
  100,13,114,101,102,102,111,110,116,104,101,105,103,104,116,2,14,0,11,116,
  115,116,114,105,110,103,101,100,105,116,5,116,101,120,116,97,13,111,112,116,
  105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,109,111,117,115,101,
  102,111,99,117,115,11,111,119,95,116,97,98,102,111,99,117,115,13,111,119,
  95,97,114,114,111,119,102,111,99,117,115,15,111,119,95,97,114,114,111,119,
  102,111,99,117,115,105,110,16,111,119,95,97,114,114,111,119,102,111,99,117,
  115,111,117,116,17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,
  116,115,18,111,119,95,102,111,110,116,103,108,121,112,104,104,101,105,103,104,
  116,12,111,119,95,97,117,116,111,115,99,97,108,101,0,11,111,112,116,105,
  111,110,115,115,107,105,110,11,19,111,115,107,95,102,114,97,109,101,98,117,
  116,116,111,110,111,110,108,121,0,8,98,111,117,110,100,115,95,120,2,0,
  8,98,111,117,110,100,115,95,121,2,0,9,98,111,117,110,100,115,95,99,
  120,3,142,0,9,98,111,117,110,100,115,95,99,121,2,16,12,102,114,97,
  109,101,46,108,101,118,101,108,111,2,0,17,102,114,97,109,101,46,99,111,
  108,111,114,99,108,105,101,110,116,4,2,0,0,128,16,102,114,97,109,101,
  46,108,111,99,97,108,112,114,111,112,115,11,10,102,114,108,95,108,101,118,
  101,108,111,15,102,114,108,95,99,111,108,111,114,99,108,105,101,110,116,0,
  11,102,114,97,109,101,46,100,117,109,109,121,2,0,8,116,97,98,111,114,
  100,101,114,2,1,7,118,105,115,105,98,108,101,8,13,114,101,102,102,111,
  110,116,104,101,105,103,104,116,2,14,0,0,11,116,115,116,114,105,110,103,
  101,100,105,116,5,116,101,120,116,98,13,111,112,116,105,111,110,115,119,105,
  100,103,101,116,11,13,111,119,95,109,111,117,115,101,102,111,99,117,115,11,
  111,119,95,116,97,98,102,111,99,117,115,13,111,119,95,97,114,114,111,119,
  102,111,99,117,115,15,111,119,95,97,114,114,111,119,102,111,99,117,115,105,
  110,16,111,119,95,97,114,114,111,119,102,111,99,117,115,111,117,116,17,111,
  119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,18,111,119,95,
  102,111,110,116,103,108,121,112,104,104,101,105,103,104,116,12,111,119,95,97,
  117,116,111,115,99,97,108,101,0,11,111,112,116,105,111,110,115,115,107,105,
  110,11,19,111,115,107,95,102,114,97,109,101,98,117,116,116,111,110,111,110,
  108,121,0,8,98,111,117,110,100,115,95,120,3,143,0,8,98,111,117,110,
  100,115,95,121,2,0,9,98,111,117,110,100,115,95,99,120,3,140,0,9,
  98,111,117,110,100,115,95,99,121,2,16,12,102,114,97,109,101,46,108,101,
  118,101,108,111,2,0,17,102,114,97,109,101,46,99,111,108,111,114,99,108,
  105,101,110,116,4,2,0,0,128,16,102,114,97,109,101,46,108,111,99,97,
  108,112,114,111,112,115,11,10,102,114,108,95,108,101,118,101,108,111,15,102,
  114,108,95,99,111,108,111,114,99,108,105,101,110,116,0,11,102,114,97,109,
  101,46,100,117,109,109,121,2,0,8,116,97,98,111,114,100,101,114,2,2,
  7,118,105,115,105,98,108,101,8,13,114,101,102,102,111,110,116,104,101,105,
  103,104,116,2,14,0,0,0,12,116,105,110,116,101,103,101,114,101,100,105,
  116,8,114,111,119,99,111,117,110,116,13,111,112,116,105,111,110,115,119,105,
  100,103,101,116,11,13,111,119,95,109,111,117,115,101,102,111,99,117,115,11,
  111,119,95,116,97,98,102,111,99,117,115,13,111,119,95,97,114,114,111,119,
  102,111,99,117,115,15,111,119,95,97,114,114,111,119,102,111,99,117,115,105,
  110,16,111,119,95,97,114,114,111,119,102,111,99,117,115,111,117,116,17,111,
  119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,18,111,119,95,
  102,111,110,116,103,108,121,112,104,104,101,105,103,104,116,12,111,119,95,97,
  117,116,111,115,99,97,108,101,0,8,98,111,117,110,100,115,95,120,2,36,
  8,98,111,117,110,100,115,95,121,3,160,0,9,98,111,117,110,100,115,95,
  99,120,2,108,9,98,111,117,110,100,115,95,99,121,2,20,13,102,114,97,
  109,101,46,99,97,112,116,105,111,110,6,8,82,111,119,99,111,117,110,116,
  16,102,114,97,109,101,46,99,97,112,116,105,111,110,112,111,115,7,8,99,
  112,95,114,105,103,104,116,11,102,114,97,109,101,46,100,117,109,109,121,2,
  0,16,102,114,97,109,101,46,111,117,116,101,114,102,114,97,109,101,1,2,
  0,2,0,2,58,2,0,0,8,116,97,98,111,114,100,101,114,2,1,10,
  111,110,115,101,116,118,97,108,117,101,7,18,114,111,119,99,111,117,110,116,
  111,110,115,101,116,118,97,108,117,101,13,114,101,102,102,111,110,116,104,101,
  105,103,104,116,2,14,0,0,0)
 );

initialization
 registerobjectdata(@objdata,tdoublestringlisteditor,'');
end.
unit main_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,main;

const
 objdata: record size: integer; data: array[0..1519] of byte end =
      (size: 1520; data: (
  84,80,70,48,7,116,109,97,105,110,102,111,6,109,97,105,110,102,111,8,
  98,111,117,110,100,115,95,120,3,35,1,8,98,111,117,110,100,115,95,121,
  3,247,0,9,98,111,117,110,100,115,95,99,120,3,147,1,9,98,111,117,
  110,100,115,95,99,121,3,196,0,23,99,111,110,116,97,105,110,101,114,46,
  111,112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,109,111,
  117,115,101,102,111,99,117,115,11,111,119,95,116,97,98,102,111,99,117,115,
  13,111,119,95,97,114,114,111,119,102,111,99,117,115,11,111,119,95,115,117,
  98,102,111,99,117,115,19,111,119,95,109,111,117,115,101,116,114,97,110,115,
  112,97,114,101,110,116,17,111,119,95,100,101,115,116,114,111,121,119,105,100,
  103,101,116,115,12,111,119,95,97,117,116,111,115,99,97,108,101,0,19,99,
  111,110,116,97,105,110,101,114,46,98,111,117,110,100,115,95,99,120,3,147,
  1,19,99,111,110,116,97,105,110,101,114,46,98,111,117,110,100,115,95,99,
  121,3,196,0,21,99,111,110,116,97,105,110,101,114,46,102,114,97,109,101,
  46,100,117,109,109,121,2,0,13,111,112,116,105,111,110,115,119,105,110,100,
  111,119,11,14,119,111,95,103,114,111,117,112,108,101,97,100,101,114,0,7,
  111,112,116,105,111,110,115,11,7,102,111,95,109,97,105,110,19,102,111,95,
  116,101,114,109,105,110,97,116,101,111,110,99,108,111,115,101,15,102,111,95,
  97,117,116,111,114,101,97,100,115,116,97,116,16,102,111,95,97,117,116,111,
  119,114,105,116,101,115,116,97,116,10,102,111,95,115,97,118,101,112,111,115,
  12,102,111,95,115,97,118,101,115,116,97,116,101,0,16,111,110,101,118,101,
  110,116,108,111,111,112,115,116,97,114,116,7,12,102,111,114,109,111,110,108,
  111,97,100,101,100,15,109,111,100,117,108,101,99,108,97,115,115,110,97,109,
  101,6,8,116,109,115,101,102,111,114,109,0,11,116,115,116,114,105,110,103,
  100,105,115,112,5,100,105,115,112,49,8,98,111,117,110,100,115,95,120,2,
  16,8,98,111,117,110,100,115,95,121,2,70,9,98,111,117,110,100,115,95,
  99,120,3,116,1,9,98,111,117,110,100,115,95,99,121,2,38,13,102,114,
  97,109,101,46,99,97,112,116,105,111,110,6,25,84,101,120,116,32,111,102,
  32,114,101,115,111,117,114,99,101,32,115,116,114,105,110,103,32,49,11,102,
  114,97,109,101,46,100,117,109,109,121,2,0,16,102,114,97,109,101,46,111,
  117,116,101,114,102,114,97,109,101,1,2,0,2,18,2,0,2,0,0,8,
  116,97,98,111,114,100,101,114,2,4,0,0,11,116,115,116,114,105,110,103,
  100,105,115,112,5,100,105,115,112,50,8,98,111,117,110,100,115,95,120,2,
  16,8,98,111,117,110,100,115,95,121,2,126,9,98,111,117,110,100,115,95,
  99,120,3,116,1,9,98,111,117,110,100,115,95,99,121,2,38,13,102,114,
  97,109,101,46,99,97,112,116,105,111,110,6,25,84,101,120,116,32,111,102,
  32,114,101,115,111,117,114,99,101,32,115,116,114,105,110,103,32,50,11,102,
  114,97,109,101,46,100,117,109,109,121,2,0,16,102,114,97,109,101,46,111,
  117,116,101,114,102,114,97,109,101,1,2,0,2,18,2,0,2,0,0,8,
  116,97,98,111,114,100,101,114,2,3,0,0,7,116,98,117,116,116,111,110,
  7,100,101,102,97,117,108,116,13,111,112,116,105,111,110,115,119,105,100,103,
  101,116,11,13,111,119,95,109,111,117,115,101,102,111,99,117,115,11,111,119,
  95,116,97,98,102,111,99,117,115,13,111,119,95,97,114,114,111,119,102,111,
  99,117,115,17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,
  115,12,111,119,95,97,117,116,111,115,99,97,108,101,0,8,98,111,117,110,
  100,115,95,120,2,16,8,98,111,117,110,100,115,95,121,2,24,9,98,111,
  117,110,100,115,95,99,120,2,114,9,98,111,117,110,100,115,95,99,121,2,
  30,7,99,97,112,116,105,111,110,6,7,68,101,102,97,117,108,116,11,102,
  111,110,116,46,104,101,105,103,104,116,2,18,9,102,111,110,116,46,110,97,
  109,101,6,11,115,116,102,95,100,101,102,97,117,108,116,10,102,111,110,116,
  46,100,117,109,109,121,2,0,9,111,110,101,120,101,99,117,116,101,7,10,
  100,101,102,97,117,108,116,101,120,101,0,0,7,116,98,117,116,116,111,110,
  7,100,101,117,116,115,99,104,13,111,112,116,105,111,110,115,119,105,100,103,
  101,116,11,13,111,119,95,109,111,117,115,101,102,111,99,117,115,11,111,119,
  95,116,97,98,102,111,99,117,115,13,111,119,95,97,114,114,111,119,102,111,
  99,117,115,17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,
  115,12,111,119,95,97,117,116,111,115,99,97,108,101,0,8,98,111,117,110,
  100,115,95,120,3,144,0,8,98,111,117,110,100,115,95,121,2,24,9,98,
  111,117,110,100,115,95,99,120,2,114,9,98,111,117,110,100,115,95,99,121,
  2,30,8,116,97,98,111,114,100,101,114,2,1,7,99,97,112,116,105,111,
  110,6,7,68,101,117,116,115,99,104,11,102,111,110,116,46,104,101,105,103,
  104,116,2,14,9,102,111,110,116,46,110,97,109,101,6,11,115,116,102,95,
  100,101,102,97,117,108,116,10,102,111,110,116,46,100,117,109,109,121,2,0,
  9,111,110,101,120,101,99,117,116,101,7,10,100,101,117,116,115,99,104,101,
  120,101,0,0,7,116,98,117,116,116,111,110,8,102,114,97,110,99,97,105,
  115,13,111,112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,
  109,111,117,115,101,102,111,99,117,115,11,111,119,95,116,97,98,102,111,99,
  117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,115,17,111,119,95,
  100,101,115,116,114,111,121,119,105,100,103,101,116,115,12,111,119,95,97,117,
  116,111,115,99,97,108,101,0,8,98,111,117,110,100,115,95,120,3,16,1,
  8,98,111,117,110,100,115,95,121,2,24,9,98,111,117,110,100,115,95,99,
  120,2,114,9,98,111,117,110,100,115,95,99,121,2,30,8,116,97,98,111,
  114,100,101,114,2,2,7,99,97,112,116,105,111,110,6,8,70,114,97,110,
  231,97,105,115,11,102,111,110,116,46,104,101,105,103,104,116,2,14,9,102,
  111,110,116,46,110,97,109,101,6,11,115,116,102,95,100,101,102,97,117,108,
  116,10,102,111,110,116,46,100,117,109,109,121,2,0,9,111,110,101,120,101,
  99,117,116,101,7,11,102,114,97,110,99,97,105,115,101,120,101,0,0,0)
 );

initialization
 registerobjectdata(@objdata,tmainfo,'');
end.

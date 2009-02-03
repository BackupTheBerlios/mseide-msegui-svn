unit msecolordialog_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,msecolordialog;

const
 objdata: record size: integer; data: array[0..9321] of byte end =
      (size: 9322; data: (
  84,80,70,48,14,116,99,111,108,111,114,100,105,97,108,111,103,102,111,13,
  99,111,108,111,114,100,105,97,108,111,103,102,111,13,111,112,116,105,111,110,
  115,119,105,100,103,101,116,11,13,111,119,95,97,114,114,111,119,102,111,99,
  117,115,15,111,119,95,97,114,114,111,119,102,111,99,117,115,105,110,16,111,
  119,95,97,114,114,111,119,102,111,99,117,115,111,117,116,11,111,119,95,115,
  117,98,102,111,99,117,115,17,111,119,95,100,101,115,116,114,111,121,119,105,
  100,103,101,116,115,9,111,119,95,104,105,110,116,111,110,12,111,119,95,97,
  117,116,111,115,99,97,108,101,0,8,98,111,117,110,100,115,95,120,3,140,
  0,8,98,111,117,110,100,115,95,121,3,234,0,9,98,111,117,110,100,115,
  95,99,120,3,86,1,9,98,111,117,110,100,115,95,99,121,3,47,1,8,
  116,97,98,111,114,100,101,114,2,1,7,118,105,115,105,98,108,101,8,23,
  99,111,110,116,97,105,110,101,114,46,111,112,116,105,111,110,115,119,105,100,
  103,101,116,11,13,111,119,95,109,111,117,115,101,102,111,99,117,115,11,111,
  119,95,116,97,98,102,111,99,117,115,13,111,119,95,97,114,114,111,119,102,
  111,99,117,115,15,111,119,95,97,114,114,111,119,102,111,99,117,115,105,110,
  16,111,119,95,97,114,114,111,119,102,111,99,117,115,111,117,116,11,111,119,
  95,115,117,98,102,111,99,117,115,19,111,119,95,109,111,117,115,101,116,114,
  97,110,115,112,97,114,101,110,116,17,111,119,95,100,101,115,116,114,111,121,
  119,105,100,103,101,116,115,12,111,119,95,97,117,116,111,115,99,97,108,101,
  0,18,99,111,110,116,97,105,110,101,114,46,98,111,117,110,100,115,95,120,
  2,0,18,99,111,110,116,97,105,110,101,114,46,98,111,117,110,100,115,95,
  121,2,0,19,99,111,110,116,97,105,110,101,114,46,98,111,117,110,100,115,
  95,99,120,3,86,1,19,99,111,110,116,97,105,110,101,114,46,98,111,117,
  110,100,115,95,99,121,3,47,1,21,99,111,110,116,97,105,110,101,114,46,
  102,114,97,109,101,46,100,117,109,109,121,2,0,7,111,112,116,105,111,110,
  115,11,13,102,111,95,99,108,111,115,101,111,110,101,115,99,17,102,111,95,
  108,111,99,97,108,115,104,111,114,116,99,117,116,115,15,102,111,95,97,117,
  116,111,114,101,97,100,115,116,97,116,16,102,111,95,97,117,116,111,119,114,
  105,116,101,115,116,97,116,10,102,111,95,115,97,118,101,112,111,115,0,8,
  115,116,97,116,102,105,108,101,7,10,116,115,116,97,116,102,105,108,101,49,
  7,99,97,112,116,105,111,110,6,12,83,101,108,101,99,116,32,99,111,108,
  111,114,15,109,111,100,117,108,101,99,108,97,115,115,110,97,109,101,6,8,
  116,109,115,101,102,111,114,109,0,7,116,115,108,105,100,101,114,9,115,108,
  105,100,101,114,114,101,100,13,111,112,116,105,111,110,115,119,105,100,103,101,
  116,11,15,111,119,95,97,114,114,111,119,102,111,99,117,115,105,110,16,111,
  119,95,97,114,114,111,119,102,111,99,117,115,111,117,116,17,111,119,95,100,
  101,115,116,114,111,121,119,105,100,103,101,116,115,0,8,98,111,117,110,100,
  115,95,120,3,232,0,8,98,111,117,110,100,115,95,121,2,8,9,98,111,
  117,110,100,115,95,99,120,2,15,9,98,111,117,110,100,115,95,99,121,3,
  218,0,5,99,111,108,111,114,4,2,0,0,128,12,102,114,97,109,101,46,
  108,101,118,101,108,111,2,255,17,102,114,97,109,101,46,99,111,108,111,114,
  99,108,105,101,110,116,4,1,0,0,128,16,102,114,97,109,101,46,108,111,
  99,97,108,112,114,111,112,115,11,10,102,114,108,95,108,101,118,101,108,111,
  10,102,114,108,95,102,105,108,101,102,116,9,102,114,108,95,102,105,116,111,
  112,11,102,114,108,95,102,105,114,105,103,104,116,12,102,114,108,95,102,105,
  98,111,116,116,111,109,15,102,114,108,95,99,111,108,111,114,99,108,105,101,
  110,116,0,11,102,114,97,109,101,46,100,117,109,109,121,2,0,7,97,110,
  99,104,111,114,115,11,7,97,110,95,108,101,102,116,6,97,110,95,116,111,
  112,9,97,110,95,98,111,116,116,111,109,0,8,116,97,98,111,114,100,101,
  114,2,11,17,115,99,114,111,108,108,98,97,114,46,111,112,116,105,111,110,
  115,11,12,115,98,111,95,109,111,118,101,97,117,116,111,0,15,115,99,114,
  111,108,108,98,97,114,46,99,111,108,111,114,4,3,0,0,128,22,115,99,
  114,111,108,108,98,97,114,46,99,111,108,111,114,112,97,116,116,101,114,110,
  4,6,0,0,128,37,115,99,114,111,108,108,98,97,114,46,102,97,99,101,
  46,105,109,97,103,101,46,116,114,97,110,115,112,97,114,101,110,116,99,111,
  108,111,114,4,0,0,0,128,29,115,99,114,111,108,108,98,97,114,46,102,
  97,99,101,46,102,97,100,101,95,112,111,115,46,99,111,117,110,116,2,2,
  29,115,99,114,111,108,108,98,97,114,46,102,97,99,101,46,102,97,100,101,
  95,112,111,115,46,105,116,101,109,115,1,5,0,0,0,0,0,0,0,0,
  0,0,5,0,0,0,0,0,0,0,128,255,63,0,31,115,99,114,111,108,
  108,98,97,114,46,102,97,99,101,46,102,97,100,101,95,99,111,108,111,114,
  46,99,111,117,110,116,2,2,31,115,99,114,111,108,108,98,97,114,46,102,
  97,99,101,46,102,97,100,101,95,99,111,108,111,114,46,105,116,101,109,115,
  1,4,2,0,0,160,4,7,0,0,160,0,29,115,99,114,111,108,108,98,
  97,114,46,102,97,99,101,46,102,97,100,101,95,100,105,114,101,99,116,105,
  111,110,7,5,103,100,95,117,112,25,115,99,114,111,108,108,98,97,114,46,
  102,97,99,101,46,108,111,99,97,108,112,114,111,112,115,11,15,102,97,108,
  95,102,97,100,105,114,101,99,116,105,111,110,18,102,97,108,95,102,97,116,
  114,97,110,115,112,97,114,101,110,99,121,0,20,115,99,114,111,108,108,98,
  97,114,46,102,97,99,101,46,100,117,109,109,121,2,0,10,111,110,115,101,
  116,118,97,108,117,101,7,13,114,101,100,111,110,115,101,116,118,97,108,117,
  101,9,100,105,114,101,99,116,105,111,110,7,5,103,100,95,117,112,0,0,
  7,116,115,108,105,100,101,114,11,115,108,105,100,101,114,103,114,101,101,110,
  13,111,112,116,105,111,110,115,119,105,100,103,101,116,11,15,111,119,95,97,
  114,114,111,119,102,111,99,117,115,105,110,16,111,119,95,97,114,114,111,119,
  102,111,99,117,115,111,117,116,17,111,119,95,100,101,115,116,114,111,121,119,
  105,100,103,101,116,115,0,8,98,111,117,110,100,115,95,120,3,12,1,8,
  98,111,117,110,100,115,95,121,2,8,9,98,111,117,110,100,115,95,99,120,
  2,15,9,98,111,117,110,100,115,95,99,121,3,218,0,5,99,111,108,111,
  114,4,2,0,0,128,12,102,114,97,109,101,46,108,101,118,101,108,111,2,
  255,17,102,114,97,109,101,46,99,111,108,111,114,99,108,105,101,110,116,4,
  1,0,0,128,16,102,114,97,109,101,46,108,111,99,97,108,112,114,111,112,
  115,11,10,102,114,108,95,108,101,118,101,108,111,10,102,114,108,95,102,105,
  108,101,102,116,9,102,114,108,95,102,105,116,111,112,11,102,114,108,95,102,
  105,114,105,103,104,116,12,102,114,108,95,102,105,98,111,116,116,111,109,15,
  102,114,108,95,99,111,108,111,114,99,108,105,101,110,116,0,11,102,114,97,
  109,101,46,100,117,109,109,121,2,0,7,97,110,99,104,111,114,115,11,7,
  97,110,95,108,101,102,116,6,97,110,95,116,111,112,9,97,110,95,98,111,
  116,116,111,109,0,8,116,97,98,111,114,100,101,114,2,12,17,115,99,114,
  111,108,108,98,97,114,46,111,112,116,105,111,110,115,11,12,115,98,111,95,
  109,111,118,101,97,117,116,111,0,15,115,99,114,111,108,108,98,97,114,46,
  99,111,108,111,114,4,3,0,0,128,22,115,99,114,111,108,108,98,97,114,
  46,99,111,108,111,114,112,97,116,116,101,114,110,4,6,0,0,128,37,115,
  99,114,111,108,108,98,97,114,46,102,97,99,101,46,105,109,97,103,101,46,
  116,114,97,110,115,112,97,114,101,110,116,99,111,108,111,114,4,0,0,0,
  128,29,115,99,114,111,108,108,98,97,114,46,102,97,99,101,46,102,97,100,
  101,95,112,111,115,46,99,111,117,110,116,2,2,29,115,99,114,111,108,108,
  98,97,114,46,102,97,99,101,46,102,97,100,101,95,112,111,115,46,105,116,
  101,109,115,1,5,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,
  0,0,0,128,255,63,0,31,115,99,114,111,108,108,98,97,114,46,102,97,
  99,101,46,102,97,100,101,95,99,111,108,111,114,46,99,111,117,110,116,2,
  2,31,115,99,114,111,108,108,98,97,114,46,102,97,99,101,46,102,97,100,
  101,95,99,111,108,111,114,46,105,116,101,109,115,1,4,2,0,0,160,4,
  8,0,0,160,0,29,115,99,114,111,108,108,98,97,114,46,102,97,99,101,
  46,102,97,100,101,95,100,105,114,101,99,116,105,111,110,7,5,103,100,95,
  117,112,25,115,99,114,111,108,108,98,97,114,46,102,97,99,101,46,108,111,
  99,97,108,112,114,111,112,115,11,15,102,97,108,95,102,97,100,105,114,101,
  99,116,105,111,110,18,102,97,108,95,102,97,116,114,97,110,115,112,97,114,
  101,110,99,121,0,20,115,99,114,111,108,108,98,97,114,46,102,97,99,101,
  46,100,117,109,109,121,2,0,10,111,110,115,101,116,118,97,108,117,101,7,
  15,103,114,101,101,110,111,110,115,101,116,118,97,108,117,101,9,100,105,114,
  101,99,116,105,111,110,7,5,103,100,95,117,112,0,0,7,116,115,108,105,
  100,101,114,10,115,108,105,100,101,114,98,108,117,101,13,111,112,116,105,111,
  110,115,119,105,100,103,101,116,11,15,111,119,95,97,114,114,111,119,102,111,
  99,117,115,105,110,16,111,119,95,97,114,114,111,119,102,111,99,117,115,111,
  117,116,17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,
  0,8,98,111,117,110,100,115,95,120,3,48,1,8,98,111,117,110,100,115,
  95,121,2,8,9,98,111,117,110,100,115,95,99,120,2,15,9,98,111,117,
  110,100,115,95,99,121,3,218,0,5,99,111,108,111,114,4,2,0,0,128,
  12,102,114,97,109,101,46,108,101,118,101,108,111,2,255,17,102,114,97,109,
  101,46,99,111,108,111,114,99,108,105,101,110,116,4,1,0,0,128,16,102,
  114,97,109,101,46,108,111,99,97,108,112,114,111,112,115,11,10,102,114,108,
  95,108,101,118,101,108,111,10,102,114,108,95,102,105,108,101,102,116,9,102,
  114,108,95,102,105,116,111,112,11,102,114,108,95,102,105,114,105,103,104,116,
  12,102,114,108,95,102,105,98,111,116,116,111,109,15,102,114,108,95,99,111,
  108,111,114,99,108,105,101,110,116,0,11,102,114,97,109,101,46,100,117,109,
  109,121,2,0,7,97,110,99,104,111,114,115,11,7,97,110,95,108,101,102,
  116,6,97,110,95,116,111,112,9,97,110,95,98,111,116,116,111,109,0,8,
  116,97,98,111,114,100,101,114,2,13,17,115,99,114,111,108,108,98,97,114,
  46,111,112,116,105,111,110,115,11,12,115,98,111,95,109,111,118,101,97,117,
  116,111,0,15,115,99,114,111,108,108,98,97,114,46,99,111,108,111,114,4,
  3,0,0,128,22,115,99,114,111,108,108,98,97,114,46,99,111,108,111,114,
  112,97,116,116,101,114,110,4,6,0,0,128,37,115,99,114,111,108,108,98,
  97,114,46,102,97,99,101,46,105,109,97,103,101,46,116,114,97,110,115,112,
  97,114,101,110,116,99,111,108,111,114,4,0,0,0,128,29,115,99,114,111,
  108,108,98,97,114,46,102,97,99,101,46,102,97,100,101,95,112,111,115,46,
  99,111,117,110,116,2,2,29,115,99,114,111,108,108,98,97,114,46,102,97,
  99,101,46,102,97,100,101,95,112,111,115,46,105,116,101,109,115,1,5,0,
  0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,128,255,63,
  0,31,115,99,114,111,108,108,98,97,114,46,102,97,99,101,46,102,97,100,
  101,95,99,111,108,111,114,46,99,111,117,110,116,2,2,31,115,99,114,111,
  108,108,98,97,114,46,102,97,99,101,46,102,97,100,101,95,99,111,108,111,
  114,46,105,116,101,109,115,1,4,2,0,0,160,4,9,0,0,160,0,29,
  115,99,114,111,108,108,98,97,114,46,102,97,99,101,46,102,97,100,101,95,
  100,105,114,101,99,116,105,111,110,7,5,103,100,95,117,112,25,115,99,114,
  111,108,108,98,97,114,46,102,97,99,101,46,108,111,99,97,108,112,114,111,
  112,115,11,15,102,97,108,95,102,97,100,105,114,101,99,116,105,111,110,18,
  102,97,108,95,102,97,116,114,97,110,115,112,97,114,101,110,99,121,0,20,
  115,99,114,111,108,108,98,97,114,46,102,97,99,101,46,100,117,109,109,121,
  2,0,10,111,110,115,101,116,118,97,108,117,101,7,14,98,108,117,101,111,
  110,115,101,116,118,97,108,117,101,9,100,105,114,101,99,116,105,111,110,7,
  5,103,100,95,117,112,0,0,12,116,105,110,116,101,103,101,114,101,100,105,
  116,3,114,101,100,13,111,112,116,105,111,110,115,119,105,100,103,101,116,11,
  13,111,119,95,109,111,117,115,101,102,111,99,117,115,11,111,119,95,116,97,
  98,102,111,99,117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,115,
  15,111,119,95,97,114,114,111,119,102,111,99,117,115,105,110,16,111,119,95,
  97,114,114,111,119,102,111,99,117,115,111,117,116,17,111,119,95,100,101,115,
  116,114,111,121,119,105,100,103,101,116,115,18,111,119,95,102,111,110,116,103,
  108,121,112,104,104,101,105,103,104,116,12,111,119,95,97,117,116,111,115,99,
  97,108,101,0,8,98,111,117,110,100,115,95,120,3,220,0,8,98,111,117,
  110,100,115,95,121,3,227,0,9,98,111,117,110,100,115,95,99,120,2,36,
  9,98,111,117,110,100,115,95,99,121,2,39,5,99,111,108,111,114,4,3,
  0,0,128,13,102,114,97,109,101,46,99,97,112,116,105,111,110,6,3,114,
  101,100,16,102,114,97,109,101,46,99,97,112,116,105,111,110,112,111,115,7,
  6,99,112,95,116,111,112,11,102,114,97,109,101,46,100,117,109,109,121,2,
  0,16,102,114,97,109,101,46,111,117,116,101,114,102,114,97,109,101,1,2,
  0,2,18,2,0,2,0,0,7,97,110,99,104,111,114,115,11,7,97,110,
  95,108,101,102,116,9,97,110,95,98,111,116,116,111,109,0,8,116,97,98,
  111,114,100,101,114,2,5,8,111,110,99,104,97,110,103,101,7,9,114,103,
  98,99,104,97,110,103,101,3,109,97,120,3,255,0,13,114,101,102,102,111,
  110,116,104,101,105,103,104,116,2,15,0,0,12,116,105,110,116,101,103,101,
  114,101,100,105,116,5,103,114,101,101,110,13,111,112,116,105,111,110,115,119,
  105,100,103,101,116,11,13,111,119,95,109,111,117,115,101,102,111,99,117,115,
  11,111,119,95,116,97,98,102,111,99,117,115,13,111,119,95,97,114,114,111,
  119,102,111,99,117,115,15,111,119,95,97,114,114,111,119,102,111,99,117,115,
  105,110,16,111,119,95,97,114,114,111,119,102,111,99,117,115,111,117,116,17,
  111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,18,111,119,
  95,102,111,110,116,103,108,121,112,104,104,101,105,103,104,116,12,111,119,95,
  97,117,116,111,115,99,97,108,101,0,8,98,111,117,110,100,115,95,120,3,
  0,1,8,98,111,117,110,100,115,95,121,3,227,0,9,98,111,117,110,100,
  115,95,99,120,2,39,9,98,111,117,110,100,115,95,99,121,2,39,5,99,
  111,108,111,114,4,3,0,0,128,13,102,114,97,109,101,46,99,97,112,116,
  105,111,110,6,5,103,114,101,101,110,16,102,114,97,109,101,46,99,97,112,
  116,105,111,110,112,111,115,7,6,99,112,95,116,111,112,11,102,114,97,109,
  101,46,100,117,109,109,121,2,0,16,102,114,97,109,101,46,111,117,116,101,
  114,102,114,97,109,101,1,2,1,2,18,2,2,2,0,0,7,97,110,99,
  104,111,114,115,11,7,97,110,95,108,101,102,116,9,97,110,95,98,111,116,
  116,111,109,0,8,116,97,98,111,114,100,101,114,2,6,8,111,110,99,104,
  97,110,103,101,7,9,114,103,98,99,104,97,110,103,101,3,109,97,120,3,
  255,0,13,114,101,102,102,111,110,116,104,101,105,103,104,116,2,15,0,0,
  12,116,105,110,116,101,103,101,114,101,100,105,116,4,98,108,117,101,13,111,
  112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,109,111,117,
  115,101,102,111,99,117,115,11,111,119,95,116,97,98,102,111,99,117,115,13,
  111,119,95,97,114,114,111,119,102,111,99,117,115,15,111,119,95,97,114,114,
  111,119,102,111,99,117,115,105,110,16,111,119,95,97,114,114,111,119,102,111,
  99,117,115,111,117,116,17,111,119,95,100,101,115,116,114,111,121,119,105,100,
  103,101,116,115,18,111,119,95,102,111,110,116,103,108,121,112,104,104,101,105,
  103,104,116,12,111,119,95,97,117,116,111,115,99,97,108,101,0,8,98,111,
  117,110,100,115,95,120,3,38,1,8,98,111,117,110,100,115,95,121,3,227,
  0,9,98,111,117,110,100,115,95,99,120,2,36,9,98,111,117,110,100,115,
  95,99,121,2,39,5,99,111,108,111,114,4,3,0,0,128,13,102,114,97,
  109,101,46,99,97,112,116,105,111,110,6,4,98,108,117,101,16,102,114,97,
  109,101,46,99,97,112,116,105,111,110,112,111,115,7,6,99,112,95,116,111,
  112,11,102,114,97,109,101,46,100,117,109,109,121,2,0,16,102,114,97,109,
  101,46,111,117,116,101,114,102,114,97,109,101,1,2,0,2,18,2,0,2,
  0,0,7,97,110,99,104,111,114,115,11,7,97,110,95,108,101,102,116,9,
  97,110,95,98,111,116,116,111,109,0,8,116,97,98,111,114,100,101,114,2,
  7,8,111,110,99,104,97,110,103,101,7,9,114,103,98,99,104,97,110,103,
  101,3,109,97,120,3,255,0,13,114,101,102,102,111,110,116,104,101,105,103,
  104,116,2,15,0,0,7,116,115,108,105,100,101,114,9,115,108,105,100,101,
  114,104,117,101,13,111,112,116,105,111,110,115,119,105,100,103,101,116,11,15,
  111,119,95,97,114,114,111,119,102,111,99,117,115,105,110,16,111,119,95,97,
  114,114,111,119,102,111,99,117,115,111,117,116,17,111,119,95,100,101,115,116,
  114,111,121,119,105,100,103,101,116,115,0,8,98,111,117,110,100,115,95,120,
  2,120,8,98,111,117,110,100,115,95,121,2,8,9,98,111,117,110,100,115,
  95,99,120,2,15,9,98,111,117,110,100,115,95,99,121,3,218,0,5,99,
  111,108,111,114,4,2,0,0,128,12,102,114,97,109,101,46,108,101,118,101,
  108,111,2,255,17,102,114,97,109,101,46,99,111,108,111,114,99,108,105,101,
  110,116,4,1,0,0,128,16,102,114,97,109,101,46,108,111,99,97,108,112,
  114,111,112,115,11,10,102,114,108,95,108,101,118,101,108,111,10,102,114,108,
  95,102,105,108,101,102,116,9,102,114,108,95,102,105,116,111,112,11,102,114,
  108,95,102,105,114,105,103,104,116,12,102,114,108,95,102,105,98,111,116,116,
  111,109,15,102,114,108,95,99,111,108,111,114,99,108,105,101,110,116,0,11,
  102,114,97,109,101,46,100,117,109,109,121,2,0,7,97,110,99,104,111,114,
  115,11,7,97,110,95,108,101,102,116,6,97,110,95,116,111,112,9,97,110,
  95,98,111,116,116,111,109,0,8,116,97,98,111,114,100,101,114,2,8,17,
  115,99,114,111,108,108,98,97,114,46,111,112,116,105,111,110,115,11,12,115,
  98,111,95,109,111,118,101,97,117,116,111,0,15,115,99,114,111,108,108,98,
  97,114,46,99,111,108,111,114,4,3,0,0,128,22,115,99,114,111,108,108,
  98,97,114,46,99,111,108,111,114,112,97,116,116,101,114,110,4,6,0,0,
  128,37,115,99,114,111,108,108,98,97,114,46,102,97,99,101,46,105,109,97,
  103,101,46,116,114,97,110,115,112,97,114,101,110,116,99,111,108,111,114,4,
  0,0,0,128,29,115,99,114,111,108,108,98,97,114,46,102,97,99,101,46,
  102,97,100,101,95,112,111,115,46,99,111,117,110,116,2,7,29,115,99,114,
  111,108,108,98,97,114,46,102,97,99,101,46,102,97,100,101,95,112,111,115,
  46,105,116,101,109,115,1,5,0,0,0,0,0,0,0,0,0,0,5,0,
  184,162,54,159,170,170,170,252,63,5,0,176,168,205,167,170,170,170,253,63,
  5,0,0,0,0,0,0,0,128,254,63,5,0,208,150,8,142,170,170,170,
  254,63,5,0,104,75,4,71,85,85,213,254,63,5,0,0,0,0,0,0,
  0,128,255,63,0,31,115,99,114,111,108,108,98,97,114,46,102,97,99,101,
  46,102,97,100,101,95,99,111,108,111,114,46,99,111,117,110,116,2,7,31,
  115,99,114,111,108,108,98,97,114,46,102,97,99,101,46,102,97,100,101,95,
  99,111,108,111,114,46,105,116,101,109,115,1,4,7,0,0,160,4,12,0,
  0,160,4,8,0,0,160,4,10,0,0,160,4,9,0,0,160,4,11,0,
  0,160,4,7,0,0,160,0,29,115,99,114,111,108,108,98,97,114,46,102,
  97,99,101,46,102,97,100,101,95,100,105,114,101,99,116,105,111,110,7,5,
  103,100,95,117,112,25,115,99,114,111,108,108,98,97,114,46,102,97,99,101,
  46,108,111,99,97,108,112,114,111,112,115,11,15,102,97,108,95,102,97,100,
  105,114,101,99,116,105,111,110,18,102,97,108,95,102,97,116,114,97,110,115,
  112,97,114,101,110,99,121,0,20,115,99,114,111,108,108,98,97,114,46,102,
  97,99,101,46,100,117,109,109,121,2,0,10,111,110,115,101,116,118,97,108,
  117,101,7,13,104,117,101,111,110,115,101,116,118,97,108,117,101,9,100,105,
  114,101,99,116,105,111,110,7,5,103,100,95,117,112,0,0,7,116,115,108,
  105,100,101,114,9,115,108,105,100,101,114,115,97,116,13,111,112,116,105,111,
  110,115,119,105,100,103,101,116,11,15,111,119,95,97,114,114,111,119,102,111,
  99,117,115,105,110,16,111,119,95,97,114,114,111,119,102,111,99,117,115,111,
  117,116,17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,
  0,8,98,111,117,110,100,115,95,120,3,156,0,8,98,111,117,110,100,115,
  95,121,2,8,9,98,111,117,110,100,115,95,99,120,2,15,9,98,111,117,
  110,100,115,95,99,121,3,218,0,5,99,111,108,111,114,4,2,0,0,128,
  12,102,114,97,109,101,46,108,101,118,101,108,111,2,255,17,102,114,97,109,
  101,46,99,111,108,111,114,99,108,105,101,110,116,4,1,0,0,128,16,102,
  114,97,109,101,46,108,111,99,97,108,112,114,111,112,115,11,10,102,114,108,
  95,108,101,118,101,108,111,10,102,114,108,95,102,105,108,101,102,116,9,102,
  114,108,95,102,105,116,111,112,11,102,114,108,95,102,105,114,105,103,104,116,
  12,102,114,108,95,102,105,98,111,116,116,111,109,15,102,114,108,95,99,111,
  108,111,114,99,108,105,101,110,116,0,11,102,114,97,109,101,46,100,117,109,
  109,121,2,0,7,97,110,99,104,111,114,115,11,7,97,110,95,108,101,102,
  116,6,97,110,95,116,111,112,9,97,110,95,98,111,116,116,111,109,0,8,
  116,97,98,111,114,100,101,114,2,9,17,115,99,114,111,108,108,98,97,114,
  46,111,112,116,105,111,110,115,11,12,115,98,111,95,109,111,118,101,97,117,
  116,111,0,15,115,99,114,111,108,108,98,97,114,46,99,111,108,111,114,4,
  3,0,0,128,22,115,99,114,111,108,108,98,97,114,46,99,111,108,111,114,
  112,97,116,116,101,114,110,4,6,0,0,128,37,115,99,114,111,108,108,98,
  97,114,46,102,97,99,101,46,105,109,97,103,101,46,116,114,97,110,115,112,
  97,114,101,110,116,99,111,108,111,114,4,0,0,0,128,29,115,99,114,111,
  108,108,98,97,114,46,102,97,99,101,46,102,97,100,101,95,112,111,115,46,
  99,111,117,110,116,2,2,29,115,99,114,111,108,108,98,97,114,46,102,97,
  99,101,46,102,97,100,101,95,112,111,115,46,105,116,101,109,115,1,5,0,
  0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,128,255,63,
  0,31,115,99,114,111,108,108,98,97,114,46,102,97,99,101,46,102,97,100,
  101,95,99,111,108,111,114,46,99,111,117,110,116,2,2,31,115,99,114,111,
  108,108,98,97,114,46,102,97,99,101,46,102,97,100,101,95,99,111,108,111,
  114,46,105,116,101,109,115,1,4,6,0,0,160,4,6,0,0,160,0,29,
  115,99,114,111,108,108,98,97,114,46,102,97,99,101,46,102,97,100,101,95,
  100,105,114,101,99,116,105,111,110,7,5,103,100,95,117,112,25,115,99,114,
  111,108,108,98,97,114,46,102,97,99,101,46,108,111,99,97,108,112,114,111,
  112,115,11,15,102,97,108,95,102,97,100,105,114,101,99,116,105,111,110,18,
  102,97,108,95,102,97,116,114,97,110,115,112,97,114,101,110,99,121,0,20,
  115,99,114,111,108,108,98,97,114,46,102,97,99,101,46,100,117,109,109,121,
  2,0,10,111,110,115,101,116,118,97,108,117,101,7,13,115,97,116,111,110,
  115,101,116,118,97,108,117,101,9,100,105,114,101,99,116,105,111,110,7,5,
  103,100,95,117,112,0,0,7,116,115,108,105,100,101,114,12,115,108,105,100,
  101,114,98,114,105,103,104,116,13,111,112,116,105,111,110,115,119,105,100,103,
  101,116,11,15,111,119,95,97,114,114,111,119,102,111,99,117,115,105,110,16,
  111,119,95,97,114,114,111,119,102,111,99,117,115,111,117,116,17,111,119,95,
  100,101,115,116,114,111,121,119,105,100,103,101,116,115,0,8,98,111,117,110,
  100,115,95,120,3,191,0,8,98,111,117,110,100,115,95,121,2,8,9,98,
  111,117,110,100,115,95,99,120,2,15,9,98,111,117,110,100,115,95,99,121,
  3,218,0,5,99,111,108,111,114,4,2,0,0,128,12,102,114,97,109,101,
  46,108,101,118,101,108,111,2,255,17,102,114,97,109,101,46,99,111,108,111,
  114,99,108,105,101,110,116,4,1,0,0,128,16,102,114,97,109,101,46,108,
  111,99,97,108,112,114,111,112,115,11,10,102,114,108,95,108,101,118,101,108,
  111,10,102,114,108,95,102,105,108,101,102,116,9,102,114,108,95,102,105,116,
  111,112,11,102,114,108,95,102,105,114,105,103,104,116,12,102,114,108,95,102,
  105,98,111,116,116,111,109,15,102,114,108,95,99,111,108,111,114,99,108,105,
  101,110,116,0,11,102,114,97,109,101,46,100,117,109,109,121,2,0,7,97,
  110,99,104,111,114,115,11,7,97,110,95,108,101,102,116,6,97,110,95,116,
  111,112,9,97,110,95,98,111,116,116,111,109,0,8,116,97,98,111,114,100,
  101,114,2,10,17,115,99,114,111,108,108,98,97,114,46,111,112,116,105,111,
  110,115,11,12,115,98,111,95,109,111,118,101,97,117,116,111,0,15,115,99,
  114,111,108,108,98,97,114,46,99,111,108,111,114,4,3,0,0,128,22,115,
  99,114,111,108,108,98,97,114,46,99,111,108,111,114,112,97,116,116,101,114,
  110,4,6,0,0,128,37,115,99,114,111,108,108,98,97,114,46,102,97,99,
  101,46,105,109,97,103,101,46,116,114,97,110,115,112,97,114,101,110,116,99,
  111,108,111,114,4,0,0,0,128,29,115,99,114,111,108,108,98,97,114,46,
  102,97,99,101,46,102,97,100,101,95,112,111,115,46,99,111,117,110,116,2,
  2,29,115,99,114,111,108,108,98,97,114,46,102,97,99,101,46,102,97,100,
  101,95,112,111,115,46,105,116,101,109,115,1,5,0,0,0,0,0,0,0,
  0,0,0,5,0,0,0,0,0,0,0,128,255,63,0,31,115,99,114,111,
  108,108,98,97,114,46,102,97,99,101,46,102,97,100,101,95,99,111,108,111,
  114,46,99,111,117,110,116,2,2,31,115,99,114,111,108,108,98,97,114,46,
  102,97,99,101,46,102,97,100,101,95,99,111,108,111,114,46,105,116,101,109,
  115,1,4,2,0,0,160,4,6,0,0,160,0,29,115,99,114,111,108,108,
  98,97,114,46,102,97,99,101,46,102,97,100,101,95,100,105,114,101,99,116,
  105,111,110,7,5,103,100,95,117,112,25,115,99,114,111,108,108,98,97,114,
  46,102,97,99,101,46,108,111,99,97,108,112,114,111,112,115,11,15,102,97,
  108,95,102,97,100,105,114,101,99,116,105,111,110,18,102,97,108,95,102,97,
  116,114,97,110,115,112,97,114,101,110,99,121,0,20,115,99,114,111,108,108,
  98,97,114,46,102,97,99,101,46,100,117,109,109,121,2,0,10,111,110,115,
  101,116,118,97,108,117,101,7,16,98,114,105,103,104,116,111,110,115,101,116,
  118,97,108,117,101,9,100,105,114,101,99,116,105,111,110,7,5,103,100,95,
  117,112,0,0,12,116,105,110,116,101,103,101,114,101,100,105,116,3,104,117,
  101,13,111,112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,
  109,111,117,115,101,102,111,99,117,115,11,111,119,95,116,97,98,102,111,99,
  117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,115,15,111,119,95,
  97,114,114,111,119,102,111,99,117,115,105,110,16,111,119,95,97,114,114,111,
  119,102,111,99,117,115,111,117,116,17,111,119,95,100,101,115,116,114,111,121,
  119,105,100,103,101,116,115,18,111,119,95,102,111,110,116,103,108,121,112,104,
  104,101,105,103,104,116,12,111,119,95,97,117,116,111,115,99,97,108,101,0,
  8,98,111,117,110,100,115,95,120,2,109,8,98,111,117,110,100,115,95,121,
  3,227,0,9,98,111,117,110,100,115,95,99,120,2,36,9,98,111,117,110,
  100,115,95,99,121,2,39,5,99,111,108,111,114,4,3,0,0,128,13,102,
  114,97,109,101,46,99,97,112,116,105,111,110,6,3,72,85,69,16,102,114,
  97,109,101,46,99,97,112,116,105,111,110,112,111,115,7,6,99,112,95,116,
  111,112,11,102,114,97,109,101,46,100,117,109,109,121,2,0,16,102,114,97,
  109,101,46,111,117,116,101,114,102,114,97,109,101,1,2,0,2,18,2,0,
  2,0,0,7,97,110,99,104,111,114,115,11,7,97,110,95,108,101,102,116,
  9,97,110,95,98,111,116,116,111,109,0,8,116,97,98,111,114,100,101,114,
  2,2,8,111,110,99,104,97,110,103,101,7,9,104,115,98,99,104,97,110,
  103,101,3,109,97,120,3,103,1,13,114,101,102,102,111,110,116,104,101,105,
  103,104,116,2,15,0,0,12,116,105,110,116,101,103,101,114,101,100,105,116,
  3,115,97,116,13,111,112,116,105,111,110,115,119,105,100,103,101,116,11,13,
  111,119,95,109,111,117,115,101,102,111,99,117,115,11,111,119,95,116,97,98,
  102,111,99,117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,115,15,
  111,119,95,97,114,114,111,119,102,111,99,117,115,105,110,16,111,119,95,97,
  114,114,111,119,102,111,99,117,115,111,117,116,17,111,119,95,100,101,115,116,
  114,111,121,119,105,100,103,101,116,115,18,111,119,95,102,111,110,116,103,108,
  121,112,104,104,101,105,103,104,116,12,111,119,95,97,117,116,111,115,99,97,
  108,101,0,8,98,111,117,110,100,115,95,120,3,145,0,8,98,111,117,110,
  100,115,95,121,3,227,0,9,98,111,117,110,100,115,95,99,120,2,36,9,
  98,111,117,110,100,115,95,99,121,2,39,5,99,111,108,111,114,4,3,0,
  0,128,13,102,114,97,109,101,46,99,97,112,116,105,111,110,6,3,83,65,
  84,16,102,114,97,109,101,46,99,97,112,116,105,111,110,112,111,115,7,6,
  99,112,95,116,111,112,11,102,114,97,109,101,46,100,117,109,109,121,2,0,
  16,102,114,97,109,101,46,111,117,116,101,114,102,114,97,109,101,1,2,0,
  2,18,2,0,2,0,0,7,97,110,99,104,111,114,115,11,7,97,110,95,
  108,101,102,116,9,97,110,95,98,111,116,116,111,109,0,8,116,97,98,111,
  114,100,101,114,2,3,8,111,110,99,104,97,110,103,101,7,9,104,115,98,
  99,104,97,110,103,101,3,109,97,120,2,100,13,114,101,102,102,111,110,116,
  104,101,105,103,104,116,2,15,0,0,12,116,105,110,116,101,103,101,114,101,
  100,105,116,6,98,114,105,103,104,116,13,111,112,116,105,111,110,115,119,105,
  100,103,101,116,11,13,111,119,95,109,111,117,115,101,102,111,99,117,115,11,
  111,119,95,116,97,98,102,111,99,117,115,13,111,119,95,97,114,114,111,119,
  102,111,99,117,115,15,111,119,95,97,114,114,111,119,102,111,99,117,115,105,
  110,16,111,119,95,97,114,114,111,119,102,111,99,117,115,111,117,116,17,111,
  119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,18,111,119,95,
  102,111,110,116,103,108,121,112,104,104,101,105,103,104,116,12,111,119,95,97,
  117,116,111,115,99,97,108,101,0,8,98,111,117,110,100,115,95,120,3,181,
  0,8,98,111,117,110,100,115,95,121,3,227,0,9,98,111,117,110,100,115,
  95,99,120,2,36,9,98,111,117,110,100,115,95,99,121,2,39,5,99,111,
  108,111,114,4,3,0,0,128,13,102,114,97,109,101,46,99,97,112,116,105,
  111,110,6,3,66,82,73,16,102,114,97,109,101,46,99,97,112,116,105,111,
  110,112,111,115,7,6,99,112,95,116,111,112,11,102,114,97,109,101,46,100,
  117,109,109,121,2,0,16,102,114,97,109,101,46,111,117,116,101,114,102,114,
  97,109,101,1,2,0,2,18,2,0,2,0,0,7,97,110,99,104,111,114,
  115,11,7,97,110,95,108,101,102,116,9,97,110,95,98,111,116,116,111,109,
  0,8,116,97,98,111,114,100,101,114,2,4,8,111,110,99,104,97,110,103,
  101,7,9,104,115,98,99,104,97,110,103,101,3,109,97,120,2,100,13,114,
  101,102,102,111,110,116,104,101,105,103,104,116,2,15,0,0,9,116,112,97,
  105,110,116,98,111,120,9,99,111,108,111,114,97,114,101,97,13,111,112,116,
  105,111,110,115,119,105,100,103,101,116,11,15,111,119,95,97,114,114,111,119,
  102,111,99,117,115,105,110,16,111,119,95,97,114,114,111,119,102,111,99,117,
  115,111,117,116,17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,
  116,115,0,8,98,111,117,110,100,115,95,120,2,56,8,98,111,117,110,100,
  115,95,121,2,8,9,98,111,117,110,100,115,95,99,120,2,50,9,98,111,
  117,110,100,115,95,99,121,3,236,0,5,99,111,108,111,114,4,3,0,0,
  128,16,102,114,97,109,101,46,99,111,108,111,114,102,114,97,109,101,4,2,
  0,0,160,13,102,114,97,109,101,46,99,97,112,116,105,111,110,6,3,110,
  101,119,16,102,114,97,109,101,46,99,97,112,116,105,111,110,112,111,115,7,
  9,99,112,95,98,111,116,116,111,109,16,102,114,97,109,101,46,108,111,99,
  97,108,112,114,111,112,115,11,14,102,114,108,95,99,111,108,111,114,102,114,
  97,109,101,0,11,102,114,97,109,101,46,100,117,109,109,121,2,0,16,102,
  114,97,109,101,46,111,117,116,101,114,102,114,97,109,101,1,2,0,2,0,
  2,0,2,18,0,7,97,110,99,104,111,114,115,11,7,97,110,95,108,101,
  102,116,6,97,110,95,116,111,112,9,97,110,95,98,111,116,116,111,109,0,
  8,116,97,98,111,114,100,101,114,2,15,0,0,7,116,98,117,116,116,111,
  110,2,111,107,13,111,112,116,105,111,110,115,119,105,100,103,101,116,11,11,
  111,119,95,116,97,98,102,111,99,117,115,13,111,119,95,97,114,114,111,119,
  102,111,99,117,115,17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,
  101,116,115,18,111,119,95,102,111,110,116,103,108,121,112,104,104,101,105,103,
  104,116,12,111,119,95,97,117,116,111,115,99,97,108,101,0,8,98,111,117,
  110,100,115,95,120,3,223,0,8,98,111,117,110,100,115,95,121,3,17,1,
  9,98,111,117,110,100,115,95,99,120,2,50,9,98,111,117,110,100,115,95,
  99,121,2,21,7,97,110,99,104,111,114,115,11,7,97,110,95,108,101,102,
  116,9,97,110,95,98,111,116,116,111,109,0,8,116,97,98,111,114,100,101,
  114,2,16,5,115,116,97,116,101,11,10,97,115,95,100,101,102,97,117,108,
  116,15,97,115,95,108,111,99,97,108,100,101,102,97,117,108,116,15,97,115,
  95,108,111,99,97,108,99,97,112,116,105,111,110,0,7,99,97,112,116,105,
  111,110,6,2,79,107,11,109,111,100,97,108,114,101,115,117,108,116,7,5,
  109,114,95,111,107,13,114,101,102,102,111,110,116,104,101,105,103,104,116,2,
  15,0,0,7,116,98,117,116,116,111,110,6,99,97,110,99,101,108,13,111,
  112,116,105,111,110,115,119,105,100,103,101,116,11,11,111,119,95,116,97,98,
  102,111,99,117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,115,17,
  111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,18,111,119,
  95,102,111,110,116,103,108,121,112,104,104,101,105,103,104,116,12,111,119,95,
  97,117,116,111,115,99,97,108,101,0,8,98,111,117,110,100,115,95,120,3,
  23,1,8,98,111,117,110,100,115,95,121,3,17,1,9,98,111,117,110,100,
  115,95,99,120,2,50,9,98,111,117,110,100,115,95,99,121,2,21,7,97,
  110,99,104,111,114,115,11,7,97,110,95,108,101,102,116,9,97,110,95,98,
  111,116,116,111,109,0,8,116,97,98,111,114,100,101,114,2,1,5,115,116,
  97,116,101,11,15,97,115,95,108,111,99,97,108,99,97,112,116,105,111,110,
  0,7,99,97,112,116,105,111,110,6,6,67,97,110,99,101,108,11,109,111,
  100,97,108,114,101,115,117,108,116,7,9,109,114,95,99,97,110,99,101,108,
  13,114,101,102,102,111,110,116,104,101,105,103,104,116,2,15,0,0,9,116,
  112,97,105,110,116,98,111,120,15,99,111,108,111,114,97,114,101,97,98,101,
  102,111,114,101,13,111,112,116,105,111,110,115,119,105,100,103,101,116,11,15,
  111,119,95,97,114,114,111,119,102,111,99,117,115,105,110,16,111,119,95,97,
  114,114,111,119,102,111,99,117,115,111,117,116,17,111,119,95,100,101,115,116,
  114,111,121,119,105,100,103,101,116,115,0,8,98,111,117,110,100,115,95,120,
  2,6,8,98,111,117,110,100,115,95,121,2,8,9,98,111,117,110,100,115,
  95,99,120,2,50,9,98,111,117,110,100,115,95,99,121,3,236,0,5,99,
  111,108,111,114,4,3,0,0,128,16,102,114,97,109,101,46,99,111,108,111,
  114,102,114,97,109,101,4,2,0,0,160,13,102,114,97,109,101,46,99,97,
  112,116,105,111,110,6,3,111,108,100,16,102,114,97,109,101,46,99,97,112,
  116,105,111,110,112,111,115,7,9,99,112,95,98,111,116,116,111,109,16,102,
  114,97,109,101,46,108,111,99,97,108,112,114,111,112,115,11,14,102,114,108,
  95,99,111,108,111,114,102,114,97,109,101,0,11,102,114,97,109,101,46,100,
  117,109,109,121,2,0,16,102,114,97,109,101,46,111,117,116,101,114,102,114,
  97,109,101,1,2,0,2,0,2,0,2,18,0,7,97,110,99,104,111,114,
  115,11,7,97,110,95,108,101,102,116,6,97,110,95,116,111,112,9,97,110,
  95,98,111,116,116,111,109,0,8,116,97,98,111,114,100,101,114,2,14,0,
  0,9,116,103,114,111,117,112,98,111,120,10,116,103,114,111,117,112,98,111,
  120,49,11,111,112,116,105,111,110,115,115,107,105,110,11,10,111,115,107,95,
  110,111,115,107,105,110,0,8,98,111,117,110,100,115,95,120,2,6,8,98,
  111,117,110,100,115,95,121,2,8,9,98,111,117,110,100,115,95,99,120,2,
  100,9,98,111,117,110,100,115,95,99,121,3,218,0,5,99,111,108,111,114,
  4,3,0,0,128,16,102,114,97,109,101,46,108,111,99,97,108,112,114,111,
  112,115,11,10,102,114,108,95,108,101,118,101,108,111,10,102,114,108,95,108,
  101,118,101,108,105,0,11,102,114,97,109,101,46,100,117,109,109,121,2,0,
  7,97,110,99,104,111,114,115,11,7,97,110,95,108,101,102,116,6,97,110,
  95,116,111,112,9,97,110,95,98,111,116,116,111,109,0,0,0,9,116,115,
  116,97,116,102,105,108,101,10,116,115,116,97,116,102,105,108,101,49,8,102,
  105,108,101,110,97,109,101,6,15,99,111,108,111,114,100,105,97,108,111,103,
  46,115,116,97,7,111,112,116,105,111,110,115,11,10,115,102,111,95,109,101,
  109,111,114,121,0,4,108,101,102,116,2,24,3,116,111,112,3,16,1,0,
  0,0)
 );

initialization
 registerobjectdata(@objdata,tcolordialogfo,'');
end.

unit msefiledialog_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface

implementation
uses
 mseclasses,msefiledialog;

const
 objdata: record size: integer; data: array[0..6106] of byte end =
      (size: 6107; data: (
  84,80,70,48,13,84,102,105,108,101,100,105,97,108,111,103,102,111,12,102,
  105,108,101,100,105,97,108,111,103,102,111,13,111,112,116,105,111,110,115,119,
  105,100,103,101,116,11,13,111,119,95,97,114,114,111,119,102,111,99,117,115,
  15,111,119,95,97,114,114,111,119,102,111,99,117,115,105,110,16,111,119,95,
  97,114,114,111,119,102,111,99,117,115,111,117,116,11,111,119,95,115,117,98,
  102,111,99,117,115,17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,
  101,116,115,9,111,119,95,104,105,110,116,111,110,0,7,111,112,116,105,111,
  110,115,11,17,102,111,95,115,99,114,101,101,110,99,101,110,116,101,114,101,
  100,13,102,111,95,99,108,111,115,101,111,110,101,115,99,15,102,111,95,97,
  117,116,111,114,101,97,100,115,116,97,116,16,102,111,95,97,117,116,111,119,
  114,105,116,101,115,116,97,116,0,13,111,110,97,102,116,101,114,99,114,101,
  97,116,101,7,11,97,102,116,101,114,99,114,101,97,116,101,9,111,110,107,
  101,121,100,111,119,110,7,17,108,105,115,116,118,105,101,119,111,110,107,101,
  121,100,111,119,110,13,111,110,99,104,105,108,100,115,99,97,108,101,100,7,
  15,102,111,111,110,99,104,105,108,100,115,99,97,108,101,100,23,99,111,110,
  116,97,105,110,101,114,46,111,110,99,104,105,108,100,115,99,97,108,101,100,
  7,15,102,111,111,110,99,104,105,108,100,115,99,97,108,101,100,21,99,111,
  110,116,97,105,110,101,114,46,102,114,97,109,101,46,100,117,109,109,121,2,
  0,23,99,111,110,116,97,105,110,101,114,46,111,112,116,105,111,110,115,119,
  105,100,103,101,116,11,13,111,119,95,109,111,117,115,101,102,111,99,117,115,
  11,111,119,95,116,97,98,102,111,99,117,115,13,111,119,95,97,114,114,111,
  119,102,111,99,117,115,15,111,119,95,97,114,114,111,119,102,111,99,117,115,
  105,110,16,111,119,95,97,114,114,111,119,102,111,99,117,115,111,117,116,11,
  111,119,95,115,117,98,102,111,99,117,115,19,111,119,95,109,111,117,115,101,
  116,114,97,110,115,112,97,114,101,110,116,17,111,119,95,100,101,115,116,114,
  111,121,119,105,100,103,101,116,115,12,111,119,95,97,117,116,111,115,99,97,
  108,101,0,19,99,111,110,116,97,105,110,101,114,46,98,111,117,110,100,115,
  95,99,120,3,68,2,19,99,111,110,116,97,105,110,101,114,46,98,111,117,
  110,100,115,95,99,121,3,51,1,21,99,111,110,116,97,105,110,101,114,46,
  102,114,97,109,101,46,100,117,109,109,121,2,0,7,118,105,115,105,98,108,
  101,8,13,111,112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,
  95,97,114,114,111,119,102,111,99,117,115,15,111,119,95,97,114,114,111,119,
  102,111,99,117,115,105,110,16,111,119,95,97,114,114,111,119,102,111,99,117,
  115,111,117,116,11,111,119,95,115,117,98,102,111,99,117,115,17,111,119,95,
  100,101,115,116,114,111,121,119,105,100,103,101,116,115,9,111,119,95,104,105,
  110,116,111,110,0,8,98,111,117,110,100,115,95,120,3,241,0,8,98,111,
  117,110,100,115,95,121,2,20,9,98,111,117,110,100,115,95,99,120,3,68,
  2,9,98,111,117,110,100,115,95,99,121,3,51,1,12,98,111,117,110,100,
  115,95,99,120,109,105,110,3,104,1,12,98,111,117,110,100,115,95,99,121,
  109,105,110,3,150,0,5,99,111,108,111,114,4,5,0,0,144,4,108,101,
  102,116,3,239,0,3,116,111,112,3,138,0,15,109,111,100,117,108,101,99,
  108,97,115,115,110,97,109,101,6,8,116,109,115,101,102,111,114,109,0,13,
  116,102,105,108,101,108,105,115,116,118,105,101,119,8,108,105,115,116,118,105,
  101,119,16,102,105,108,101,108,105,115,116,46,111,112,116,105,111,110,115,11,
  12,102,108,111,95,115,111,114,116,110,97,109,101,12,102,108,111,95,115,111,
  114,116,116,121,112,101,0,10,111,110,108,105,115,116,114,101,97,100,7,18,
  108,105,115,116,118,105,101,119,111,110,108,105,115,116,114,101,97,100,16,100,
  97,116,97,114,111,119,108,105,110,101,99,111,108,111,114,4,5,0,0,160,
  16,100,97,116,97,99,111,108,108,105,110,101,99,111,108,111,114,4,5,0,
  0,160,9,99,101,108,108,119,105,100,116,104,3,174,0,10,99,101,108,108,
  104,101,105,103,104,116,2,15,17,102,105,120,99,111,108,115,46,108,105,110,
  101,99,111,108,111,114,4,2,0,0,160,17,102,105,120,114,111,119,115,46,
  108,105,110,101,99,111,108,111,114,4,2,0,0,160,11,111,112,116,105,111,
  110,115,103,114,105,100,11,12,111,103,95,99,111,108,115,105,122,105,110,103,
  19,111,103,95,102,111,99,117,115,99,101,108,108,111,110,101,110,116,101,114,
  0,7,111,112,116,105,111,110,115,11,12,108,118,111,95,114,101,97,100,111,
  110,108,121,13,108,118,111,95,100,114,97,119,102,111,99,117,115,15,108,118,
  111,95,109,111,117,115,101,115,101,108,101,99,116,13,108,118,111,95,107,101,
  121,115,101,108,101,99,116,15,108,118,111,95,109,117,108,116,105,115,101,108,
  101,99,116,17,108,118,111,95,99,97,115,101,115,101,110,115,105,116,105,118,
  101,0,19,105,116,101,109,108,105,115,116,46,105,109,97,103,101,119,105,100,
  116,104,2,16,20,105,116,101,109,108,105,115,116,46,105,109,97,103,101,104,
  101,105,103,104,116,2,16,12,99,101,108,108,119,105,100,116,104,109,105,110,
  2,50,18,111,110,115,101,108,101,99,116,105,111,110,99,104,97,110,103,101,
  100,7,24,108,105,115,116,118,105,101,119,115,101,108,101,99,116,105,111,110,
  99,104,97,110,103,101,100,11,111,110,105,116,101,109,101,118,101,110,116,7,
  17,108,105,115,116,118,105,101,119,105,116,101,109,101,118,101,110,116,11,102,
  114,97,109,101,46,100,117,109,109,121,2,0,9,111,110,107,101,121,100,111,
  119,110,7,17,108,105,115,116,118,105,101,119,111,110,107,101,121,100,111,119,
  110,13,111,112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,
  109,111,117,115,101,102,111,99,117,115,13,111,119,95,97,114,114,111,119,102,
  111,99,117,115,17,111,119,95,102,111,99,117,115,98,97,99,107,111,110,101,
  115,99,17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,
  18,111,119,95,102,111,110,116,103,108,121,112,104,104,101,105,103,104,116,12,
  111,119,95,97,117,116,111,115,99,97,108,101,0,8,98,111,117,110,100,115,
  95,121,2,26,9,98,111,117,110,100,115,95,99,120,3,68,2,9,98,111,
  117,110,100,115,95,99,121,3,226,0,11,102,114,97,109,101,46,100,117,109,
  109,121,2,0,7,97,110,99,104,111,114,115,11,6,97,110,95,116,111,112,
  9,97,110,95,98,111,116,116,111,109,0,8,116,97,98,111,114,100,101,114,
  2,8,13,114,101,102,102,111,110,116,104,101,105,103,104,116,2,16,0,0,
  7,116,98,117,116,116,111,110,2,111,107,7,99,97,112,116,105,111,110,6,
  3,38,79,107,9,111,110,101,120,101,99,117,116,101,7,11,111,107,111,110,
  101,120,101,99,117,116,101,5,115,116,97,116,101,11,10,97,115,95,100,101,
  102,97,117,108,116,15,97,115,95,108,111,99,97,108,100,101,102,97,117,108,
  116,15,97,115,95,108,111,99,97,108,99,97,112,116,105,111,110,17,97,115,
  95,108,111,99,97,108,111,110,101,120,101,99,117,116,101,0,13,111,112,116,
  105,111,110,115,119,105,100,103,101,116,11,11,111,119,95,116,97,98,102,111,
  99,117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,115,15,111,119,
  95,97,114,114,111,119,102,111,99,117,115,105,110,16,111,119,95,97,114,114,
  111,119,102,111,99,117,115,111,117,116,17,111,119,95,100,101,115,116,114,111,
  121,119,105,100,103,101,116,115,18,111,119,95,102,111,110,116,103,108,121,112,
  104,104,101,105,103,104,116,12,111,119,95,97,117,116,111,115,99,97,108,101,
  0,13,111,112,116,105,111,110,115,119,105,100,103,101,116,11,11,111,119,95,
  116,97,98,102,111,99,117,115,13,111,119,95,97,114,114,111,119,102,111,99,
  117,115,15,111,119,95,97,114,114,111,119,102,111,99,117,115,105,110,16,111,
  119,95,97,114,114,111,119,102,111,99,117,115,111,117,116,17,111,119,95,100,
  101,115,116,114,111,121,119,105,100,103,101,116,115,18,111,119,95,102,111,110,
  116,103,108,121,112,104,104,101,105,103,104,116,12,111,119,95,97,117,116,111,
  115,99,97,108,101,0,8,98,111,117,110,100,115,95,120,3,183,1,8,98,
  111,117,110,100,115,95,121,3,27,1,9,98,111,117,110,100,115,95,99,120,
  2,67,9,98,111,117,110,100,115,95,99,121,2,22,7,97,110,99,104,111,
  114,115,11,8,97,110,95,114,105,103,104,116,9,97,110,95,98,111,116,116,
  111,109,0,8,116,97,98,111,114,100,101,114,2,3,13,114,101,102,102,111,
  110,116,104,101,105,103,104,116,2,16,0,0,7,116,98,117,116,116,111,110,
  6,99,97,110,99,101,108,7,99,97,112,116,105,111,110,6,7,38,67,97,
  110,99,101,108,11,109,111,100,97,108,114,101,115,117,108,116,7,9,109,114,
  95,99,97,110,99,101,108,5,115,116,97,116,101,11,15,97,115,95,108,111,
  99,97,108,99,97,112,116,105,111,110,0,13,111,112,116,105,111,110,115,119,
  105,100,103,101,116,11,11,111,119,95,116,97,98,102,111,99,117,115,13,111,
  119,95,97,114,114,111,119,102,111,99,117,115,15,111,119,95,97,114,114,111,
  119,102,111,99,117,115,105,110,16,111,119,95,97,114,114,111,119,102,111,99,
  117,115,111,117,116,17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,
  101,116,115,18,111,119,95,102,111,110,116,103,108,121,112,104,104,101,105,103,
  104,116,12,111,119,95,97,117,116,111,115,99,97,108,101,0,13,111,112,116,
  105,111,110,115,119,105,100,103,101,116,11,11,111,119,95,116,97,98,102,111,
  99,117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,115,15,111,119,
  95,97,114,114,111,119,102,111,99,117,115,105,110,16,111,119,95,97,114,114,
  111,119,102,111,99,117,115,111,117,116,17,111,119,95,100,101,115,116,114,111,
  121,119,105,100,103,101,116,115,18,111,119,95,102,111,110,116,103,108,121,112,
  104,104,101,105,103,104,116,12,111,119,95,97,117,116,111,115,99,97,108,101,
  0,8,98,111,117,110,100,115,95,120,3,0,2,8,98,111,117,110,100,115,
  95,121,3,27,1,9,98,111,117,110,100,115,95,99,120,2,66,9,98,111,
  117,110,100,115,95,99,121,2,22,7,97,110,99,104,111,114,115,11,8,97,
  110,95,114,105,103,104,116,9,97,110,95,98,111,116,116,111,109,0,8,116,
  97,98,111,114,100,101,114,2,4,13,114,101,102,102,111,110,116,104,101,105,
  103,104,116,2,16,0,0,7,116,98,117,116,116,111,110,9,99,114,101,97,
  116,101,100,105,114,7,99,97,112,116,105,111,110,6,8,38,78,101,119,32,
  100,105,114,9,111,110,101,120,101,99,117,116,101,7,18,99,114,101,97,116,
  101,100,105,114,111,110,101,120,101,99,117,116,101,5,115,116,97,116,101,11,
  15,97,115,95,108,111,99,97,108,99,97,112,116,105,111,110,17,97,115,95,
  108,111,99,97,108,111,110,101,120,101,99,117,116,101,0,13,111,112,116,105,
  111,110,115,119,105,100,103,101,116,11,11,111,119,95,116,97,98,102,111,99,
  117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,115,15,111,119,95,
  97,114,114,111,119,102,111,99,117,115,105,110,16,111,119,95,97,114,114,111,
  119,102,111,99,117,115,111,117,116,17,111,119,95,100,101,115,116,114,111,121,
  119,105,100,103,101,116,115,18,111,119,95,102,111,110,116,103,108,121,112,104,
  104,101,105,103,104,116,12,111,119,95,97,117,116,111,115,99,97,108,101,0,
  13,111,112,116,105,111,110,115,119,105,100,103,101,116,11,11,111,119,95,116,
  97,98,102,111,99,117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,
  115,15,111,119,95,97,114,114,111,119,102,111,99,117,115,105,110,16,111,119,
  95,97,114,114,111,119,102,111,99,117,115,111,117,116,17,111,119,95,100,101,
  115,116,114,111,121,119,105,100,103,101,116,115,18,111,119,95,102,111,110,116,
  103,108,121,112,104,104,101,105,103,104,116,12,111,119,95,97,117,116,111,115,
  99,97,108,101,0,8,98,111,117,110,100,115,95,120,3,255,1,8,98,111,
  117,110,100,115,95,121,2,3,9,98,111,117,110,100,115,95,99,120,2,66,
  9,98,111,117,110,100,115,95,99,121,2,22,7,97,110,99,104,111,114,115,
  11,6,97,110,95,116,111,112,8,97,110,95,114,105,103,104,116,0,8,116,
  97,98,111,114,100,101,114,2,7,13,114,101,102,102,111,110,116,104,101,105,
  103,104,116,2,16,0,0,7,116,98,117,116,116,111,110,2,117,112,7,99,
  97,112,116,105,111,110,6,3,38,85,112,9,111,110,101,120,101,99,117,116,
  101,7,8,117,112,97,99,116,105,111,110,5,115,116,97,116,101,11,15,97,
  115,95,108,111,99,97,108,99,97,112,116,105,111,110,17,97,115,95,108,111,
  99,97,108,111,110,101,120,101,99,117,116,101,0,13,111,112,116,105,111,110,
  115,119,105,100,103,101,116,11,11,111,119,95,116,97,98,102,111,99,117,115,
  13,111,119,95,97,114,114,111,119,102,111,99,117,115,15,111,119,95,97,114,
  114,111,119,102,111,99,117,115,105,110,16,111,119,95,97,114,114,111,119,102,
  111,99,117,115,111,117,116,17,111,119,95,100,101,115,116,114,111,121,119,105,
  100,103,101,116,115,18,111,119,95,102,111,110,116,103,108,121,112,104,104,101,
  105,103,104,116,12,111,119,95,97,117,116,111,115,99,97,108,101,0,13,111,
  112,116,105,111,110,115,119,105,100,103,101,116,11,11,111,119,95,116,97,98,
  102,111,99,117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,115,15,
  111,119,95,97,114,114,111,119,102,111,99,117,115,105,110,16,111,119,95,97,
  114,114,111,119,102,111,99,117,115,111,117,116,17,111,119,95,100,101,115,116,
  114,111,121,119,105,100,103,101,116,115,18,111,119,95,102,111,110,116,103,108,
  121,112,104,104,101,105,103,104,116,12,111,119,95,97,117,116,111,115,99,97,
  108,101,0,8,98,111,117,110,100,115,95,120,3,183,1,8,98,111,117,110,
  100,115,95,121,2,3,9,98,111,117,110,100,115,95,99,120,2,66,9,98,
  111,117,110,100,115,95,99,121,2,22,7,97,110,99,104,111,114,115,11,6,
  97,110,95,116,111,112,8,97,110,95,114,105,103,104,116,0,8,116,97,98,
  111,114,100,101,114,2,6,13,114,101,102,102,111,110,116,104,101,105,103,104,
  116,2,16,0,0,12,116,104,105,115,116,111,114,121,101,100,105,116,8,102,
  105,108,101,110,97,109,101,10,111,110,115,101,116,118,97,108,117,101,7,16,
  102,105,108,101,110,97,109,101,115,101,116,118,97,108,117,101,25,100,114,111,
  112,100,111,119,110,46,100,114,111,112,100,111,119,110,114,111,119,99,111,117,
  110,116,2,10,16,100,114,111,112,100,111,119,110,46,111,112,116,105,111,110,
  115,11,15,100,101,111,95,107,101,121,100,114,111,112,100,111,119,110,0,19,
  100,114,111,112,100,111,119,110,46,99,111,108,115,46,99,111,117,110,116,2,
  1,19,100,114,111,112,100,111,119,110,46,99,111,108,115,46,105,116,101,109,
  115,14,1,9,116,101,120,116,102,108,97,103,115,11,12,116,102,95,121,99,
  101,110,116,101,114,101,100,11,116,102,95,110,111,115,101,108,101,99,116,14,
  116,102,95,101,108,108,105,112,115,101,108,101,102,116,0,0,0,13,102,114,
  97,109,101,46,99,97,112,116,105,111,110,6,5,38,78,97,109,101,16,102,
  114,97,109,101,46,99,97,112,116,105,111,110,112,111,115,7,8,99,112,95,
  114,105,103,104,116,11,102,114,97,109,101,46,100,117,109,109,121,2,0,16,
  102,114,97,109,101,46,111,117,116,101,114,102,114,97,109,101,1,2,0,2,
  0,2,38,2,0,0,11,111,112,116,105,111,110,115,101,100,105,116,11,12,
  111,101,95,117,110,100,111,111,110,101,115,99,13,111,101,95,99,108,111,115,
  101,113,117,101,114,121,16,111,101,95,99,104,101,99,107,109,114,99,97,110,
  99,101,108,15,111,101,95,101,120,105,116,111,110,99,117,114,115,111,114,20,
  111,101,95,114,101,115,101,116,115,101,108,101,99,116,111,110,101,120,105,116,
  13,111,101,95,97,117,116,111,115,101,108,101,99,116,25,111,101,95,97,117,
  116,111,115,101,108,101,99,116,111,110,102,105,114,115,116,99,108,105,99,107,
  16,111,101,95,97,117,116,111,112,111,112,117,112,109,101,110,117,13,111,101,
  95,107,101,121,101,120,101,99,117,116,101,12,111,101,95,115,97,118,101,118,
  97,108,117,101,12,111,101,95,115,97,118,101,115,116,97,116,101,0,13,111,
  112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,109,111,117,
  115,101,102,111,99,117,115,11,111,119,95,116,97,98,102,111,99,117,115,13,
  111,119,95,97,114,114,111,119,102,111,99,117,115,15,111,119,95,97,114,114,
  111,119,102,111,99,117,115,105,110,16,111,119,95,97,114,114,111,119,102,111,
  99,117,115,111,117,116,17,111,119,95,100,101,115,116,114,111,121,119,105,100,
  103,101,116,115,18,111,119,95,102,111,110,116,103,108,121,112,104,104,101,105,
  103,104,116,12,111,119,95,97,117,116,111,115,99,97,108,101,0,8,98,111,
  117,110,100,115,95,120,2,1,8,98,111,117,110,100,115,95,121,3,1,1,
  9,98,111,117,110,100,115,95,99,120,3,152,1,9,98,111,117,110,100,115,
  95,99,121,2,22,6,99,117,114,115,111,114,7,8,99,114,95,105,98,101,
  97,109,13,102,114,97,109,101,46,99,97,112,116,105,111,110,6,5,38,78,
  97,109,101,16,102,114,97,109,101,46,99,97,112,116,105,111,110,112,111,115,
  7,8,99,112,95,114,105,103,104,116,11,102,114,97,109,101,46,100,117,109,
  109,121,2,0,16,102,114,97,109,101,46,111,117,116,101,114,102,114,97,109,
  101,1,2,0,2,0,2,38,2,0,0,7,97,110,99,104,111,114,115,11,
  7,97,110,95,108,101,102,116,8,97,110,95,114,105,103,104,116,9,97,110,
  95,98,111,116,116,111,109,0,13,114,101,102,102,111,110,116,104,101,105,103,
  104,116,2,16,0,0,17,116,100,114,111,112,100,111,119,110,108,105,115,116,
  101,100,105,116,6,102,105,108,116,101,114,10,111,110,115,101,116,118,97,108,
  117,101,7,16,102,105,108,116,101,114,111,110,115,101,116,118,97,108,117,101,
  19,100,114,111,112,100,111,119,110,46,99,111,108,115,46,99,111,117,110,116,
  2,2,19,100,114,111,112,100,111,119,110,46,99,111,108,115,46,105,116,101,
  109,115,14,1,0,1,7,111,112,116,105,111,110,115,11,11,99,111,95,114,
  101,97,100,111,110,108,121,12,99,111,95,105,110,118,105,115,105,98,108,101,
  14,99,111,95,102,111,99,117,115,115,101,108,101,99,116,7,99,111,95,102,
  105,108,108,0,0,0,17,100,114,111,112,100,111,119,110,46,118,97,108,117,
  101,99,111,108,2,1,20,111,110,97,102,116,101,114,99,108,111,115,101,100,
  114,111,112,100,111,119,110,7,26,102,105,108,116,101,114,111,110,97,102,116,
  101,114,99,108,111,115,101,100,114,111,112,100,111,119,110,22,102,114,97,109,
  101,46,98,117,116,116,111,110,46,105,109,97,103,101,108,105,115,116,7,16,
  115,116,111,99,107,100,97,116,97,46,103,108,121,112,104,115,20,102,114,97,
  109,101,46,98,117,116,116,111,110,46,105,109,97,103,101,110,114,2,14,13,
  102,114,97,109,101,46,99,97,112,116,105,111,110,6,7,38,70,105,108,116,
  101,114,16,102,114,97,109,101,46,99,97,112,116,105,111,110,112,111,115,7,
  8,99,112,95,114,105,103,104,116,11,102,114,97,109,101,46,100,117,109,109,
  121,2,0,16,102,114,97,109,101,46,111,117,116,101,114,102,114,97,109,101,
  1,2,0,2,0,2,33,2,0,0,13,111,110,100,97,116,97,101,110,116,
  101,114,101,100,7,15,102,105,108,101,112,97,116,104,101,110,116,101,114,101,
  100,13,111,112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,
  109,111,117,115,101,102,111,99,117,115,11,111,119,95,116,97,98,102,111,99,
  117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,115,15,111,119,95,
  97,114,114,111,119,102,111,99,117,115,105,110,16,111,119,95,97,114,114,111,
  119,102,111,99,117,115,111,117,116,17,111,119,95,100,101,115,116,114,111,121,
  119,105,100,103,101,116,115,18,111,119,95,102,111,110,116,103,108,121,112,104,
  104,101,105,103,104,116,12,111,119,95,97,117,116,111,115,99,97,108,101,0,
  8,98,111,117,110,100,115,95,120,2,1,8,98,111,117,110,100,115,95,121,
  3,26,1,9,98,111,117,110,100,115,95,99,120,3,147,1,9,98,111,117,
  110,100,115,95,99,121,2,22,6,99,117,114,115,111,114,7,8,99,114,95,
  105,98,101,97,109,22,102,114,97,109,101,46,98,117,116,116,111,110,46,105,
  109,97,103,101,108,105,115,116,7,16,115,116,111,99,107,100,97,116,97,46,
  103,108,121,112,104,115,20,102,114,97,109,101,46,98,117,116,116,111,110,46,
  105,109,97,103,101,110,114,2,14,13,102,114,97,109,101,46,99,97,112,116,
  105,111,110,6,7,38,70,105,108,116,101,114,16,102,114,97,109,101,46,99,
  97,112,116,105,111,110,112,111,115,7,8,99,112,95,114,105,103,104,116,11,
  102,114,97,109,101,46,100,117,109,109,121,2,0,16,102,114,97,109,101,46,
  111,117,116,101,114,102,114,97,109,101,1,2,0,2,0,2,33,2,0,0,
  7,97,110,99,104,111,114,115,11,7,97,110,95,108,101,102,116,8,97,110,
  95,114,105,103,104,116,9,97,110,95,98,111,116,116,111,109,0,8,116,97,
  98,111,114,100,101,114,2,2,13,114,101,102,102,111,110,116,104,101,105,103,
  104,116,2,16,0,0,16,116,100,105,114,100,114,111,112,100,111,119,110,101,
  100,105,116,3,100,105,114,16,100,114,111,112,100,111,119,110,46,111,112,116,
  105,111,110,115,11,14,100,101,111,95,115,101,108,101,99,116,111,110,108,121,
  15,100,101,111,95,107,101,121,100,114,111,112,100,111,119,110,0,10,111,110,
  115,101,116,118,97,108,117,101,7,13,100,105,114,111,110,115,101,116,118,97,
  108,117,101,22,102,114,97,109,101,46,98,117,116,116,111,110,46,105,109,97,
  103,101,108,105,115,116,7,16,115,116,111,99,107,100,97,116,97,46,103,108,
  121,112,104,115,20,102,114,97,109,101,46,98,117,116,116,111,110,46,105,109,
  97,103,101,110,114,2,14,13,102,114,97,109,101,46,99,97,112,116,105,111,
  110,6,4,38,68,105,114,16,102,114,97,109,101,46,99,97,112,116,105,111,
  110,112,111,115,7,8,99,112,95,114,105,103,104,116,11,102,114,97,109,101,
  46,100,117,109,109,121,2,0,16,102,114,97,109,101,46,111,117,116,101,114,
  102,114,97,109,101,1,2,0,2,0,2,20,2,0,0,9,116,101,120,116,
  102,108,97,103,115,11,12,116,102,95,121,99,101,110,116,101,114,101,100,11,
  116,102,95,110,111,115,101,108,101,99,116,14,116,102,95,101,108,108,105,112,
  115,101,108,101,102,116,0,13,111,110,100,97,116,97,101,110,116,101,114,101,
  100,7,15,102,105,108,101,112,97,116,104,101,110,116,101,114,101,100,13,111,
  112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,109,111,117,
  115,101,102,111,99,117,115,11,111,119,95,116,97,98,102,111,99,117,115,13,
  111,119,95,97,114,114,111,119,102,111,99,117,115,15,111,119,95,97,114,114,
  111,119,102,111,99,117,115,105,110,16,111,119,95,97,114,114,111,119,102,111,
  99,117,115,111,117,116,17,111,119,95,100,101,115,116,114,111,121,119,105,100,
  103,101,116,115,18,111,119,95,102,111,110,116,103,108,121,112,104,104,101,105,
  103,104,116,12,111,119,95,97,117,116,111,115,99,97,108,101,0,8,98,111,
  117,110,100,115,95,120,2,1,8,98,111,117,110,100,115,95,121,2,2,9,
  98,111,117,110,100,115,95,99,120,3,135,1,9,98,111,117,110,100,115,95,
  99,121,2,22,6,99,117,114,115,111,114,7,8,99,114,95,105,98,101,97,
  109,22,102,114,97,109,101,46,98,117,116,116,111,110,46,105,109,97,103,101,
  108,105,115,116,7,16,115,116,111,99,107,100,97,116,97,46,103,108,121,112,
  104,115,20,102,114,97,109,101,46,98,117,116,116,111,110,46,105,109,97,103,
  101,110,114,2,14,13,102,114,97,109,101,46,99,97,112,116,105,111,110,6,
  4,38,68,105,114,16,102,114,97,109,101,46,99,97,112,116,105,111,110,112,
  111,115,7,8,99,112,95,114,105,103,104,116,11,102,114,97,109,101,46,100,
  117,109,109,121,2,0,16,102,114,97,109,101,46,111,117,116,101,114,102,114,
  97,109,101,1,2,0,2,0,2,20,2,0,0,7,97,110,99,104,111,114,
  115,11,7,97,110,95,108,101,102,116,6,97,110,95,116,111,112,8,97,110,
  95,114,105,103,104,116,0,8,116,97,98,111,114,100,101,114,2,5,10,111,
  110,115,104,111,119,104,105,110,116,7,11,100,105,114,115,104,111,119,104,105,
  110,116,13,114,101,102,102,111,110,116,104,101,105,103,104,116,2,16,0,0,
  12,116,98,111,111,108,101,97,110,101,100,105,116,10,115,104,111,119,104,105,
  100,100,101,110,9,98,111,117,110,100,115,95,99,120,2,123,9,98,111,117,
  110,100,115,95,99,121,2,18,10,111,110,115,101,116,118,97,108,117,101,7,
  20,115,104,111,119,104,105,100,100,101,110,111,110,115,101,116,118,97,108,117,
  101,8,98,111,117,110,100,115,95,120,3,184,1,8,98,111,117,110,100,115,
  95,121,3,3,1,9,98,111,117,110,100,115,95,99,120,2,123,9,98,111,
  117,110,100,115,95,99,121,2,18,13,102,114,97,109,101,46,99,97,112,116,
  105,111,110,6,18,38,83,104,111,119,32,104,105,100,100,101,110,32,102,105,
  108,101,115,11,102,114,97,109,101,46,100,117,109,109,121,2,0,16,102,114,
  97,109,101,46,111,117,116,101,114,102,114,97,109,101,1,2,0,2,2,2,
  110,2,3,0,7,97,110,99,104,111,114,115,11,8,97,110,95,114,105,103,
  104,116,9,97,110,95,98,111,116,116,111,109,0,8,116,97,98,111,114,100,
  101,114,2,1,0,0,0)
 );

initialization
 registerobjectdata(@objdata,Tfiledialogfo,'');
end.

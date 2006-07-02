unit msedbfieldeditor_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface

implementation
uses
 mseclasses,msedbfieldeditor;

const
 objdata: record size: integer; data: array[0..6972] of byte end =
      (size: 6973; data: (
  84,80,70,48,19,116,109,115,101,100,98,102,105,101,108,100,101,100,105,116,
  111,114,102,111,18,109,115,101,100,98,102,105,101,108,100,101,100,105,116,111,
  114,102,111,8,98,111,117,110,100,115,95,120,2,29,8,98,111,117,110,100,
  115,95,121,3,248,0,9,98,111,117,110,100,115,95,99,120,3,89,2,9,
  98,111,117,110,100,115,95,99,121,3,216,0,7,118,105,115,105,98,108,101,
  8,23,99,111,110,116,97,105,110,101,114,46,111,112,116,105,111,110,115,119,
  105,100,103,101,116,11,13,111,119,95,109,111,117,115,101,102,111,99,117,115,
  11,111,119,95,116,97,98,102,111,99,117,115,13,111,119,95,97,114,114,111,
  119,102,111,99,117,115,11,111,119,95,115,117,98,102,111,99,117,115,19,111,
  119,95,109,111,117,115,101,116,114,97,110,115,112,97,114,101,110,116,17,111,
  119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,12,111,119,95,
  97,117,116,111,115,99,97,108,101,0,19,99,111,110,116,97,105,110,101,114,
  46,98,111,117,110,100,115,95,99,120,3,89,2,19,99,111,110,116,97,105,
  110,101,114,46,98,111,117,110,100,115,95,99,121,3,216,0,21,99,111,110,
  116,97,105,110,101,114,46,102,114,97,109,101,46,100,117,109,109,121,2,0,
  7,111,112,116,105,111,110,115,11,13,102,111,95,99,108,111,115,101,111,110,
  101,115,99,15,102,111,95,97,117,116,111,114,101,97,100,115,116,97,116,16,
  102,111,95,97,117,116,111,119,114,105,116,101,115,116,97,116,10,102,111,95,
  115,97,118,101,112,111,115,12,102,111,95,115,97,118,101,115,116,97,116,101,
  0,8,115,116,97,116,102,105,108,101,7,10,116,115,116,97,116,102,105,108,
  101,49,8,111,110,108,111,97,100,101,100,7,10,102,111,114,109,108,111,97,
  100,101,100,15,109,111,100,117,108,101,99,108,97,115,115,110,97,109,101,6,
  8,116,109,115,101,102,111,114,109,0,7,116,98,117,116,116,111,110,8,116,
  98,117,116,116,111,110,49,8,98,111,117,110,100,115,95,120,3,216,1,8,
  98,111,117,110,100,115,95,121,3,184,0,9,98,111,117,110,100,115,95,99,
  120,2,50,9,98,111,117,110,100,115,95,99,121,2,22,7,97,110,99,104,
  111,114,115,11,8,97,110,95,114,105,103,104,116,9,97,110,95,98,111,116,
  116,111,109,0,8,116,97,98,111,114,100,101,114,2,3,5,115,116,97,116,
  101,11,10,97,115,95,100,101,102,97,117,108,116,15,97,115,95,108,111,99,
  97,108,100,101,102,97,117,108,116,15,97,115,95,108,111,99,97,108,99,97,
  112,116,105,111,110,0,7,99,97,112,116,105,111,110,6,2,79,75,11,109,
  111,100,97,108,114,101,115,117,108,116,7,5,109,114,95,111,107,0,0,7,
  116,98,117,116,116,111,110,8,116,98,117,116,116,111,110,50,8,98,111,117,
  110,100,115,95,120,3,24,2,8,98,111,117,110,100,115,95,121,3,184,0,
  9,98,111,117,110,100,115,95,99,120,2,50,9,98,111,117,110,100,115,95,
  99,121,2,22,7,97,110,99,104,111,114,115,11,8,97,110,95,114,105,103,
  104,116,9,97,110,95,98,111,116,116,111,109,0,5,115,116,97,116,101,11,
  15,97,115,95,108,111,99,97,108,99,97,112,116,105,111,110,0,7,99,97,
  112,116,105,111,110,6,6,67,97,110,99,101,108,11,109,111,100,97,108,114,
  101,115,117,108,116,7,9,109,114,95,99,97,110,99,101,108,0,0,11,116,
  115,116,114,105,110,103,103,114,105,100,10,102,105,101,108,100,100,101,102,108,
  105,13,111,112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,
  109,111,117,115,101,102,111,99,117,115,11,111,119,95,116,97,98,102,111,99,
  117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,115,17,111,119,95,
  102,111,99,117,115,98,97,99,107,111,110,101,115,99,17,111,119,95,100,101,
  115,116,114,111,121,119,105,100,103,101,116,115,18,111,119,95,102,111,110,116,
  103,108,121,112,104,104,101,105,103,104,116,12,111,119,95,97,117,116,111,115,
  99,97,108,101,0,8,98,111,117,110,100,115,95,120,3,80,1,8,98,111,
  117,110,100,115,95,121,2,8,9,98,111,117,110,100,115,95,99,120,3,2,
  1,9,98,111,117,110,100,115,95,99,121,3,170,0,13,102,114,97,109,101,
  46,99,97,112,116,105,111,110,6,9,70,105,101,108,100,100,101,102,115,16,
  102,114,97,109,101,46,99,97,112,116,105,111,110,112,111,115,7,6,99,112,
  95,116,111,112,11,102,114,97,109,101,46,100,117,109,109,121,2,0,16,102,
  114,97,109,101,46,111,117,116,101,114,102,114,97,109,101,1,2,0,2,16,
  2,0,2,0,0,7,97,110,99,104,111,114,115,11,7,97,110,95,108,101,
  102,116,6,97,110,95,116,111,112,8,97,110,95,114,105,103,104,116,9,97,
  110,95,98,111,116,116,111,109,0,8,116,97,98,111,114,100,101,114,2,1,
  11,111,112,116,105,111,110,115,103,114,105,100,11,12,111,103,95,99,111,108,
  115,105,122,105,110,103,19,111,103,95,102,111,99,117,115,99,101,108,108,111,
  110,101,110,116,101,114,20,111,103,95,99,111,108,99,104,97,110,103,101,111,
  110,116,97,98,107,101,121,12,111,103,95,97,117,116,111,112,111,112,117,112,
  0,14,100,97,116,97,99,111,108,115,46,99,111,117,110,116,2,2,16,100,
  97,116,97,99,111,108,115,46,111,112,116,105,111,110,115,11,11,99,111,95,
  114,101,97,100,111,110,108,121,14,99,111,95,102,111,99,117,115,115,101,108,
  101,99,116,14,99,111,95,109,111,117,115,101,115,101,108,101,99,116,12,99,
  111,95,107,101,121,115,101,108,101,99,116,14,99,111,95,109,117,108,116,105,
  115,101,108,101,99,116,12,99,111,95,114,111,119,115,101,108,101,99,116,12,
  99,111,95,115,97,118,101,115,116,97,116,101,10,99,111,95,114,111,119,102,
  111,110,116,11,99,111,95,114,111,119,99,111,108,111,114,13,99,111,95,122,
  101,98,114,97,99,111,108,111,114,0,14,100,97,116,97,99,111,108,115,46,
  105,116,101,109,115,14,1,5,119,105,100,116,104,2,123,7,111,112,116,105,
  111,110,115,11,11,99,111,95,114,101,97,100,111,110,108,121,14,99,111,95,
  102,111,99,117,115,115,101,108,101,99,116,14,99,111,95,109,111,117,115,101,
  115,101,108,101,99,116,12,99,111,95,107,101,121,115,101,108,101,99,116,14,
  99,111,95,109,117,108,116,105,115,101,108,101,99,116,12,99,111,95,114,111,
  119,115,101,108,101,99,116,7,99,111,95,102,105,108,108,12,99,111,95,115,
  97,118,101,115,116,97,116,101,10,99,111,95,114,111,119,102,111,110,116,11,
  99,111,95,114,111,119,99,111,108,111,114,13,99,111,95,122,101,98,114,97,
  99,111,108,111,114,0,11,111,112,116,105,111,110,115,101,100,105,116,11,14,
  115,99,111,101,95,101,97,116,114,101,116,117,114,110,0,0,1,5,119,105,
  100,116,104,3,129,0,7,111,112,116,105,111,110,115,11,11,99,111,95,114,
  101,97,100,111,110,108,121,14,99,111,95,102,111,99,117,115,115,101,108,101,
  99,116,14,99,111,95,109,111,117,115,101,115,101,108,101,99,116,12,99,111,
  95,107,101,121,115,101,108,101,99,116,14,99,111,95,109,117,108,116,105,115,
  101,108,101,99,116,12,99,111,95,114,111,119,115,101,108,101,99,116,15,99,
  111,95,112,114,111,112,111,114,116,105,111,110,97,108,12,99,111,95,115,97,
  118,101,115,116,97,116,101,10,99,111,95,114,111,119,102,111,110,116,11,99,
  111,95,114,111,119,99,111,108,111,114,13,99,111,95,122,101,98,114,97,99,
  111,108,111,114,0,11,111,112,116,105,111,110,115,101,100,105,116,11,14,115,
  99,111,101,95,101,97,116,114,101,116,117,114,110,0,0,0,13,102,105,120,
  114,111,119,115,46,99,111,117,110,116,2,1,13,102,105,120,114,111,119,115,
  46,105,116,101,109,115,14,1,6,104,101,105,103,104,116,2,16,14,99,97,
  112,116,105,111,110,115,46,99,111,117,110,116,2,2,14,99,97,112,116,105,
  111,110,115,46,105,116,101,109,115,14,1,7,99,97,112,116,105,111,110,6,
  4,78,97,109,101,0,1,7,99,97,112,116,105,111,110,6,4,84,121,112,
  101,0,0,0,0,14,114,111,119,102,111,110,116,115,46,99,111,117,110,116,
  2,1,14,114,111,119,102,111,110,116,115,46,105,116,101,109,115,14,1,5,
  99,111,108,111,114,4,4,0,0,160,4,110,97,109,101,6,11,115,116,102,
  95,100,101,102,97,117,108,116,5,100,117,109,109,121,2,0,0,0,13,100,
  97,116,97,114,111,119,104,101,105,103,104,116,2,16,11,111,110,99,101,108,
  108,101,118,101,110,116,7,13,100,101,102,115,99,101,108,108,101,118,101,110,
  116,18,111,110,115,101,108,101,99,116,105,111,110,99,104,97,110,103,101,100,
  7,16,100,101,102,115,115,101,108,101,99,116,105,111,110,99,104,97,13,114,
  101,102,102,111,110,116,104,101,105,103,104,116,2,14,0,0,11,116,119,105,
  100,103,101,116,103,114,105,100,6,102,105,101,108,100,115,13,111,112,116,105,
  111,110,115,119,105,100,103,101,116,11,13,111,119,95,109,111,117,115,101,102,
  111,99,117,115,11,111,119,95,116,97,98,102,111,99,117,115,13,111,119,95,
  97,114,114,111,119,102,111,99,117,115,17,111,119,95,102,111,99,117,115,98,
  97,99,107,111,110,101,115,99,17,111,119,95,100,101,115,116,114,111,121,119,
  105,100,103,101,116,115,18,111,119,95,102,111,110,116,103,108,121,112,104,104,
  101,105,103,104,116,12,111,119,95,97,117,116,111,115,99,97,108,101,0,8,
  98,111,117,110,100,115,95,120,2,8,8,98,111,117,110,100,115,95,121,2,
  8,9,98,111,117,110,100,115,95,99,120,3,67,1,9,98,111,117,110,100,
  115,95,99,121,3,170,0,13,102,114,97,109,101,46,99,97,112,116,105,111,
  110,6,6,70,105,101,108,100,115,16,102,114,97,109,101,46,99,97,112,116,
  105,111,110,112,111,115,7,6,99,112,95,116,111,112,11,102,114,97,109,101,
  46,100,117,109,109,121,2,0,16,102,114,97,109,101,46,111,117,116,101,114,
  102,114,97,109,101,1,2,0,2,16,2,0,2,0,0,7,97,110,99,104,
  111,114,115,11,7,97,110,95,108,101,102,116,6,97,110,95,116,111,112,9,
  97,110,95,98,111,116,116,111,109,0,8,116,97,98,111,114,100,101,114,2,
  2,11,111,112,116,105,111,110,115,103,114,105,100,11,12,111,103,95,99,111,
  108,115,105,122,105,110,103,12,111,103,95,114,111,119,109,111,118,105,110,103,
  15,111,103,95,107,101,121,114,111,119,109,111,118,105,110,103,15,111,103,95,
  114,111,119,105,110,115,101,114,116,105,110,103,14,111,103,95,114,111,119,100,
  101,108,101,116,105,110,103,19,111,103,95,102,111,99,117,115,99,101,108,108,
  111,110,101,110,116,101,114,15,111,103,95,97,117,116,111,102,105,114,115,116,
  114,111,119,13,111,103,95,97,117,116,111,97,112,112,101,110,100,9,111,103,
  95,115,111,114,116,101,100,20,111,103,95,99,111,108,99,104,97,110,103,101,
  111,110,116,97,98,107,101,121,12,111,103,95,97,117,116,111,112,111,112,117,
  112,0,13,102,105,120,99,111,108,115,46,99,111,117,110,116,2,1,13,102,
  105,120,99,111,108,115,46,105,116,101,109,115,14,1,5,119,105,100,116,104,
  2,15,7,110,117,109,115,116,101,112,2,1,0,0,13,102,105,120,114,111,
  119,115,46,99,111,117,110,116,2,1,13,102,105,120,114,111,119,115,46,105,
  116,101,109,115,14,1,6,104,101,105,103,104,116,2,16,14,99,97,112,116,
  105,111,110,115,46,99,111,117,110,116,2,5,14,99,97,112,116,105,111,110,
  115,46,105,116,101,109,115,14,1,0,1,0,1,7,99,97,112,116,105,111,
  110,6,4,78,97,109,101,0,1,7,99,97,112,116,105,111,110,6,10,67,
  108,97,115,115,32,116,121,112,101,0,1,7,99,97,112,116,105,111,110,6,
  10,70,105,101,108,100,32,107,105,110,100,0,0,0,0,14,114,111,119,102,
  111,110,116,115,46,99,111,117,110,116,2,1,14,114,111,119,102,111,110,116,
  115,46,105,116,101,109,115,14,1,5,99,111,108,111,114,4,4,0,0,160,
  4,110,97,109,101,6,11,115,116,102,95,100,101,102,97,117,108,116,5,100,
  117,109,109,121,2,0,0,0,14,100,97,116,97,99,111,108,115,46,99,111,
  117,110,116,2,5,16,100,97,116,97,99,111,108,115,46,111,112,116,105,111,
  110,115,11,14,99,111,95,102,111,99,117,115,115,101,108,101,99,116,14,99,
  111,95,109,111,117,115,101,115,101,108,101,99,116,12,99,111,95,107,101,121,
  115,101,108,101,99,116,14,99,111,95,109,117,108,116,105,115,101,108,101,99,
  116,12,99,111,95,114,111,119,115,101,108,101,99,116,12,99,111,95,115,97,
  118,101,115,116,97,116,101,10,99,111,95,114,111,119,102,111,110,116,11,99,
  111,95,114,111,119,99,111,108,111,114,13,99,111,95,122,101,98,114,97,99,
  111,108,111,114,0,14,100,97,116,97,99,111,108,115,46,105,116,101,109,115,
  14,1,5,119,105,100,116,104,2,13,7,111,112,116,105,111,110,115,11,12,
  99,111,95,105,110,118,105,115,105,98,108,101,14,99,111,95,102,111,99,117,
  115,115,101,108,101,99,116,14,99,111,95,109,111,117,115,101,115,101,108,101,
  99,116,12,99,111,95,107,101,121,115,101,108,101,99,116,14,99,111,95,109,
  117,108,116,105,115,101,108,101,99,116,12,99,111,95,114,111,119,115,101,108,
  101,99,116,12,99,111,95,115,97,118,101,118,97,108,117,101,12,99,111,95,
  115,97,118,101,115,116,97,116,101,10,99,111,95,114,111,119,102,111,110,116,
  11,99,111,95,114,111,119,99,111,108,111,114,13,99,111,95,122,101,98,114,
  97,99,111,108,111,114,0,10,119,105,100,103,101,116,110,97,109,101,6,5,
  105,110,100,101,120,0,1,5,119,105,100,116,104,2,12,7,111,112,116,105,
  111,110,115,11,12,99,111,95,105,110,118,105,115,105,98,108,101,12,99,111,
  95,100,114,97,119,102,111,99,117,115,14,99,111,95,102,111,99,117,115,115,
  101,108,101,99,116,14,99,111,95,109,111,117,115,101,115,101,108,101,99,116,
  12,99,111,95,107,101,121,115,101,108,101,99,116,14,99,111,95,109,117,108,
  116,105,115,101,108,101,99,116,12,99,111,95,114,111,119,115,101,108,101,99,
  116,12,99,111,95,115,97,118,101,115,116,97,116,101,10,99,111,95,114,111,
  119,102,111,110,116,11,99,111,95,114,111,119,99,111,108,111,114,13,99,111,
  95,122,101,98,114,97,99,111,108,111,114,0,10,119,105,100,103,101,116,110,
  97,109,101,6,7,102,105,101,108,100,112,111,0,1,5,119,105,100,116,104,
  2,97,7,111,112,116,105,111,110,115,11,14,99,111,95,102,111,99,117,115,
  115,101,108,101,99,116,14,99,111,95,109,111,117,115,101,115,101,108,101,99,
  116,12,99,111,95,107,101,121,115,101,108,101,99,116,14,99,111,95,109,117,
  108,116,105,115,101,108,101,99,116,12,99,111,95,114,111,119,115,101,108,101,
  99,116,7,99,111,95,102,105,108,108,12,99,111,95,115,97,118,101,118,97,
  108,117,101,12,99,111,95,115,97,118,101,115,116,97,116,101,10,99,111,95,
  114,111,119,102,111,110,116,11,99,111,95,114,111,119,99,111,108,111,114,13,
  99,111,95,122,101,98,114,97,99,111,108,111,114,0,10,119,105,100,103,101,
  116,110,97,109,101,6,9,102,105,101,108,100,110,97,109,101,0,1,5,119,
  105,100,116,104,2,92,7,111,112,116,105,111,110,115,11,14,99,111,95,102,
  111,99,117,115,115,101,108,101,99,116,14,99,111,95,109,111,117,115,101,115,
  101,108,101,99,116,12,99,111,95,107,101,121,115,101,108,101,99,116,14,99,
  111,95,109,117,108,116,105,115,101,108,101,99,116,12,99,111,95,114,111,119,
  115,101,108,101,99,116,15,99,111,95,112,114,111,112,111,114,116,105,111,110,
  97,108,12,99,111,95,115,97,118,101,118,97,108,117,101,12,99,111,95,115,
  97,118,101,115,116,97,116,101,10,99,111,95,114,111,119,102,111,110,116,11,
  99,111,95,114,111,119,99,111,108,111,114,13,99,111,95,122,101,98,114,97,
  99,111,108,111,114,0,10,119,105,100,103,101,116,110,97,109,101,6,7,99,
  108,97,115,115,116,121,0,1,5,119,105,100,116,104,2,84,7,111,112,116,
  105,111,110,115,11,14,99,111,95,102,111,99,117,115,115,101,108,101,99,116,
  14,99,111,95,109,111,117,115,101,115,101,108,101,99,116,12,99,111,95,107,
  101,121,115,101,108,101,99,116,14,99,111,95,109,117,108,116,105,115,101,108,
  101,99,116,12,99,111,95,114,111,119,115,101,108,101,99,116,15,99,111,95,
  112,114,111,112,111,114,116,105,111,110,97,108,12,99,111,95,115,97,118,101,
  118,97,108,117,101,12,99,111,95,115,97,118,101,115,116,97,116,101,10,99,
  111,95,114,111,119,102,111,110,116,11,99,111,95,114,111,119,99,111,108,111,
  114,13,99,111,95,122,101,98,114,97,99,111,108,111,114,0,10,119,105,100,
  103,101,116,110,97,109,101,6,9,102,105,101,108,100,107,105,110,100,0,0,
  13,100,97,116,97,114,111,119,104,101,105,103,104,116,2,16,14,111,110,114,
  111,119,115,100,101,108,101,116,105,110,103,7,17,102,105,101,108,100,114,111,
  119,115,100,101,108,101,116,105,110,103,13,111,110,114,111,119,115,100,101,108,
  101,116,101,100,7,12,102,105,101,108,100,115,114,111,119,100,101,108,11,111,
  110,99,101,108,108,101,118,101,110,116,7,14,102,105,101,108,100,99,101,108,
  108,101,118,101,110,116,18,111,110,115,101,108,101,99,116,105,111,110,99,104,
  97,110,103,101,100,7,17,102,105,101,108,100,115,101,108,101,99,116,105,111,
  110,99,104,97,6,111,110,115,111,114,116,7,10,102,105,101,108,100,115,115,
  111,114,116,13,114,101,102,102,111,110,116,104,101,105,103,104,116,2,14,0,
  12,116,105,110,116,101,103,101,114,101,100,105,116,5,105,110,100,101,120,13,
  111,112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,109,111,
  117,115,101,102,111,99,117,115,11,111,119,95,116,97,98,102,111,99,117,115,
  13,111,119,95,97,114,114,111,119,102,111,99,117,115,17,111,119,95,100,101,
  115,116,114,111,121,119,105,100,103,101,116,115,18,111,119,95,102,111,110,116,
  103,108,121,112,104,104,101,105,103,104,116,0,9,98,111,117,110,100,115,95,
  99,120,2,13,9,98,111,117,110,100,115,95,99,121,2,16,12,102,114,97,
  109,101,46,108,101,118,101,108,111,2,0,17,102,114,97,109,101,46,99,111,
  108,111,114,99,108,105,101,110,116,4,3,0,0,128,16,102,114,97,109,101,
  46,108,111,99,97,108,112,114,111,112,115,11,10,102,114,108,95,108,101,118,
  101,108,111,15,102,114,108,95,99,111,108,111,114,99,108,105,101,110,116,0,
  11,102,114,97,109,101,46,100,117,109,109,121,2,0,8,116,97,98,111,114,
  100,101,114,2,1,7,118,105,115,105,98,108,101,8,13,114,101,102,102,111,
  110,116,104,101,105,103,104,116,2,14,0,0,12,116,112,111,105,110,116,101,
  114,101,100,105,116,7,102,105,101,108,100,112,111,13,111,112,116,105,111,110,
  115,119,105,100,103,101,116,11,13,111,119,95,109,111,117,115,101,102,111,99,
  117,115,11,111,119,95,116,97,98,102,111,99,117,115,13,111,119,95,97,114,
  114,111,119,102,111,99,117,115,17,111,119,95,100,101,115,116,114,111,121,119,
  105,100,103,101,116,115,0,8,98,111,117,110,100,115,95,120,2,14,9,98,
  111,117,110,100,115,95,99,120,2,12,9,98,111,117,110,100,115,95,99,121,
  2,16,12,102,114,97,109,101,46,108,101,118,101,108,111,2,0,17,102,114,
  97,109,101,46,99,111,108,111,114,99,108,105,101,110,116,4,3,0,0,128,
  16,102,114,97,109,101,46,108,111,99,97,108,112,114,111,112,115,11,10,102,
  114,108,95,108,101,118,101,108,111,15,102,114,108,95,99,111,108,111,114,99,
  108,105,101,110,116,0,11,102,114,97,109,101,46,100,117,109,109,121,2,0,
  8,116,97,98,111,114,100,101,114,2,3,7,118,105,115,105,98,108,101,8,
  11,111,112,116,105,111,110,115,101,100,105,116,11,12,111,101,95,117,110,100,
  111,111,110,101,115,99,13,111,101,95,99,108,111,115,101,113,117,101,114,121,
  16,111,101,95,99,104,101,99,107,109,114,99,97,110,99,101,108,15,111,101,
  95,101,120,105,116,111,110,99,117,114,115,111,114,14,111,101,95,115,104,105,
  102,116,114,101,116,117,114,110,12,111,101,95,101,97,116,114,101,116,117,114,
  110,20,111,101,95,114,101,115,101,116,115,101,108,101,99,116,111,110,101,120,
  105,116,13,111,101,95,101,110,100,111,110,101,110,116,101,114,13,111,101,95,
  97,117,116,111,115,101,108,101,99,116,25,111,101,95,97,117,116,111,115,101,
  108,101,99,116,111,110,102,105,114,115,116,99,108,105,99,107,16,111,101,95,
  97,117,116,111,112,111,112,117,112,109,101,110,117,13,111,101,95,107,101,121,
  101,120,101,99,117,116,101,12,111,101,95,115,97,118,101,115,116,97,116,101,
  0,0,0,11,116,115,116,114,105,110,103,101,100,105,116,9,102,105,101,108,
  100,110,97,109,101,13,111,112,116,105,111,110,115,119,105,100,103,101,116,11,
  13,111,119,95,109,111,117,115,101,102,111,99,117,115,11,111,119,95,116,97,
  98,102,111,99,117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,115,
  17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,18,111,
  119,95,102,111,110,116,103,108,121,112,104,104,101,105,103,104,116,12,111,119,
  95,97,117,116,111,115,99,97,108,101,0,8,98,111,117,110,100,115,95,120,
  2,27,9,98,111,117,110,100,115,95,99,120,2,97,9,98,111,117,110,100,
  115,95,99,121,2,16,12,102,114,97,109,101,46,108,101,118,101,108,111,2,
  0,17,102,114,97,109,101,46,99,111,108,111,114,99,108,105,101,110,116,4,
  3,0,0,128,16,102,114,97,109,101,46,108,111,99,97,108,112,114,111,112,
  115,11,10,102,114,108,95,108,101,118,101,108,111,15,102,114,108,95,99,111,
  108,111,114,99,108,105,101,110,116,0,11,102,114,97,109,101,46,100,117,109,
  109,121,2,0,8,116,97,98,111,114,100,101,114,2,4,7,118,105,115,105,
  98,108,101,8,13,111,110,100,97,116,97,101,110,116,101,114,101,100,7,17,
  102,105,101,108,100,115,100,97,116,97,101,110,116,101,114,101,100,10,111,110,
  115,101,116,118,97,108,117,101,7,17,102,105,101,108,100,110,97,109,101,115,
  101,116,118,97,108,117,101,13,114,101,102,102,111,110,116,104,101,105,103,104,
  116,2,14,0,0,13,116,101,110,117,109,116,121,112,101,101,100,105,116,7,
  99,108,97,115,115,116,121,13,111,112,116,105,111,110,115,119,105,100,103,101,
  116,11,13,111,119,95,109,111,117,115,101,102,111,99,117,115,11,111,119,95,
  116,97,98,102,111,99,117,115,13,111,119,95,97,114,114,111,119,102,111,99,
  117,115,17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,
  18,111,119,95,102,111,110,116,103,108,121,112,104,104,101,105,103,104,116,0,
  8,98,111,117,110,100,115,95,120,2,125,9,98,111,117,110,100,115,95,99,
  120,2,92,9,98,111,117,110,100,115,95,99,121,2,16,12,102,114,97,109,
  101,46,108,101,118,101,108,111,2,0,17,102,114,97,109,101,46,99,111,108,
  111,114,99,108,105,101,110,116,4,3,0,0,128,16,102,114,97,109,101,46,
  108,111,99,97,108,112,114,111,112,115,11,10,102,114,108,95,108,101,118,101,
  108,111,15,102,114,108,95,99,111,108,111,114,99,108,105,101,110,116,0,18,
  102,114,97,109,101,46,98,117,116,116,111,110,46,99,111,108,111,114,4,5,
  0,0,144,11,102,114,97,109,101,46,100,117,109,109,121,2,0,7,118,105,
  115,105,98,108,101,8,5,118,97,108,117,101,2,0,12,118,97,108,117,101,
  100,101,102,97,117,108,116,2,0,3,109,105,110,2,0,19,100,114,111,112,
  100,111,119,110,46,99,111,108,115,46,99,111,117,110,116,2,1,19,100,114,
  111,112,100,111,119,110,46,99,111,108,115,46,105,116,101,109,115,14,1,0,
  0,18,100,114,111,112,100,111,119,110,46,105,116,101,109,105,110,100,101,120,
  2,0,6,111,110,105,110,105,116,7,7,105,110,105,116,99,108,97,13,114,
  101,102,102,111,110,116,104,101,105,103,104,116,2,14,0,0,13,116,101,110,
  117,109,116,121,112,101,101,100,105,116,9,102,105,101,108,100,107,105,110,100,
  13,111,112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,109,
  111,117,115,101,102,111,99,117,115,11,111,119,95,116,97,98,102,111,99,117,
  115,13,111,119,95,97,114,114,111,119,102,111,99,117,115,17,111,119,95,100,
  101,115,116,114,111,121,119,105,100,103,101,116,115,18,111,119,95,102,111,110,
  116,103,108,121,112,104,104,101,105,103,104,116,0,8,98,111,117,110,100,115,
  95,120,3,218,0,9,98,111,117,110,100,115,95,99,120,2,84,9,98,111,
  117,110,100,115,95,99,121,2,16,12,102,114,97,109,101,46,108,101,118,101,
  108,111,2,0,17,102,114,97,109,101,46,99,111,108,111,114,99,108,105,101,
  110,116,4,3,0,0,128,16,102,114,97,109,101,46,108,111,99,97,108,112,
  114,111,112,115,11,10,102,114,108,95,108,101,118,101,108,111,15,102,114,108,
  95,99,111,108,111,114,99,108,105,101,110,116,0,18,102,114,97,109,101,46,
  98,117,116,116,111,110,46,119,105,100,116,104,2,15,18,102,114,97,109,101,
  46,98,117,116,116,111,110,46,99,111,108,111,114,4,5,0,0,144,11,102,
  114,97,109,101,46,100,117,109,109,121,2,0,8,116,97,98,111,114,100,101,
  114,2,2,7,118,105,115,105,98,108,101,8,5,118,97,108,117,101,2,0,
  12,118,97,108,117,101,100,101,102,97,117,108,116,2,0,3,109,105,110,2,
  0,19,100,114,111,112,100,111,119,110,46,99,111,108,115,46,99,111,117,110,
  116,2,1,19,100,114,111,112,100,111,119,110,46,99,111,108,115,46,105,116,
  101,109,115,14,1,0,0,18,100,114,111,112,100,111,119,110,46,105,116,101,
  109,105,110,100,101,120,2,0,6,111,110,105,110,105,116,7,13,105,110,105,
  116,102,105,101,108,100,107,105,110,100,13,114,101,102,102,111,110,116,104,101,
  105,103,104,116,2,14,0,0,0,9,116,115,112,108,105,116,116,101,114,8,
  115,112,108,105,116,116,101,114,8,98,111,117,110,100,115,95,120,3,75,1,
  8,98,111,117,110,100,115,95,121,2,24,9,98,111,117,110,100,115,95,99,
  120,2,5,9,98,111,117,110,100,115,95,99,121,3,154,0,7,97,110,99,
  104,111,114,115,11,7,97,110,95,108,101,102,116,6,97,110,95,116,111,112,
  9,97,110,95,98,111,116,116,111,109,0,8,116,97,98,111,114,100,101,114,
  2,6,7,111,112,116,105,111,110,115,11,9,115,112,111,95,104,109,111,118,
  101,9,115,112,111,95,104,112,114,111,112,0,8,108,105,110,107,108,101,102,
  116,7,6,102,105,101,108,100,115,9,108,105,110,107,114,105,103,104,116,7,
  10,102,105,101,108,100,100,101,102,108,105,8,115,116,97,116,102,105,108,101,
  7,10,116,115,116,97,116,102,105,108,101,49,14,111,110,117,112,100,97,116,
  101,108,97,121,111,117,116,7,12,115,112,108,105,116,116,101,114,117,112,100,
  97,0,0,17,116,115,116,111,99,107,103,108,121,112,104,98,117,116,116,111,
  110,10,100,101,102,116,111,102,105,101,108,100,13,111,112,116,105,111,110,115,
  119,105,100,103,101,116,11,17,111,119,95,100,101,115,116,114,111,121,119,105,
  100,103,101,116,115,12,111,119,95,97,117,116,111,115,99,97,108,101,0,8,
  98,111,117,110,100,115,95,120,3,82,1,8,98,111,117,110,100,115,95,121,
  2,5,9,98,111,117,110,100,115,95,99,120,2,28,9,98,111,117,110,100,
  115,95,99,121,2,15,8,116,97,98,111,114,100,101,114,2,5,5,115,116,
  97,116,101,11,11,97,115,95,100,105,115,97,98,108,101,100,16,97,115,95,
  108,111,99,97,108,100,105,115,97,98,108,101,100,17,97,115,95,108,111,99,
  97,108,105,109,97,103,101,108,105,115,116,15,97,115,95,108,111,99,97,108,
  105,109,97,103,101,110,114,17,97,115,95,108,111,99,97,108,111,110,101,120,
  101,99,117,116,101,0,5,103,108,121,112,104,7,13,115,116,103,95,97,114,
  114,111,119,108,101,102,116,9,111,110,101,120,101,99,117,116,101,7,14,116,
  114,97,110,115,102,101,114,102,105,101,108,100,115,0,0,17,116,115,116,111,
  99,107,103,108,121,112,104,98,117,116,116,111,110,10,102,105,101,108,100,116,
  111,100,101,102,13,111,112,116,105,111,110,115,119,105,100,103,101,116,11,17,
  111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,12,111,119,
  95,97,117,116,111,115,99,97,108,101,0,8,98,111,117,110,100,115,95,120,
  3,47,1,8,98,111,117,110,100,115,95,121,2,5,9,98,111,117,110,100,
  115,95,99,120,2,28,9,98,111,117,110,100,115,95,99,121,2,15,8,116,
  97,98,111,114,100,101,114,2,4,5,115,116,97,116,101,11,11,97,115,95,
  100,105,115,97,98,108,101,100,16,97,115,95,108,111,99,97,108,100,105,115,
  97,98,108,101,100,17,97,115,95,108,111,99,97,108,105,109,97,103,101,108,
  105,115,116,15,97,115,95,108,111,99,97,108,105,109,97,103,101,110,114,17,
  97,115,95,108,111,99,97,108,111,110,101,120,101,99,117,116,101,0,5,103,
  108,121,112,104,7,14,115,116,103,95,97,114,114,111,119,114,105,103,104,116,
  9,111,110,101,120,101,99,117,116,101,7,12,100,101,108,101,116,101,102,105,
  101,108,100,115,0,0,9,116,115,116,97,116,102,105,108,101,10,116,115,116,
  97,116,102,105,108,101,49,8,102,105,108,101,110,97,109,101,6,17,100,98,
  102,105,101,108,100,101,100,105,116,111,114,46,115,116,97,7,111,112,116,105,
  111,110,115,11,10,115,102,111,95,109,101,109,111,114,121,0,4,108,101,102,
  116,2,24,3,116,111,112,3,152,0,0,0,0)
 );

initialization
 registerobjectdata(@objdata,tmsedbfieldeditorfo,'');
end.

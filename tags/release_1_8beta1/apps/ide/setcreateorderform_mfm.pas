unit setcreateorderform_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface

implementation
uses
 mseclasses,setcreateorderform;

const
 objdata: record size: integer; data: array[0..2404] of byte end =
      (size: 2405; data: (
  84,80,70,48,17,116,115,101,116,99,114,101,97,116,101,111,114,100,101,114,
  102,111,16,115,101,116,99,114,101,97,116,101,111,114,100,101,114,102,111,8,
  98,111,117,110,100,115,95,120,3,223,0,8,98,111,117,110,100,115,95,121,
  3,8,1,9,98,111,117,110,100,115,95,99,120,3,125,1,9,98,111,117,
  110,100,115,95,99,121,3,84,1,8,116,97,98,111,114,100,101,114,2,1,
  23,99,111,110,116,97,105,110,101,114,46,111,112,116,105,111,110,115,119,105,
  100,103,101,116,11,13,111,119,95,109,111,117,115,101,102,111,99,117,115,11,
  111,119,95,116,97,98,102,111,99,117,115,13,111,119,95,97,114,114,111,119,
  102,111,99,117,115,11,111,119,95,115,117,98,102,111,99,117,115,19,111,119,
  95,109,111,117,115,101,116,114,97,110,115,112,97,114,101,110,116,13,111,119,
  95,109,111,117,115,101,119,104,101,101,108,17,111,119,95,100,101,115,116,114,
  111,121,119,105,100,103,101,116,115,12,111,119,95,97,117,116,111,115,99,97,
  108,101,0,18,99,111,110,116,97,105,110,101,114,46,98,111,117,110,100,115,
  95,120,2,0,18,99,111,110,116,97,105,110,101,114,46,98,111,117,110,100,
  115,95,121,2,0,19,99,111,110,116,97,105,110,101,114,46,98,111,117,110,
  100,115,95,99,120,3,125,1,19,99,111,110,116,97,105,110,101,114,46,98,
  111,117,110,100,115,95,99,121,3,84,1,21,99,111,110,116,97,105,110,101,
  114,46,102,114,97,109,101,46,100,117,109,109,121,2,0,7,111,112,116,105,
  111,110,115,11,13,102,111,95,99,108,111,115,101,111,110,101,115,99,15,102,
  111,95,97,117,116,111,114,101,97,100,115,116,97,116,16,102,111,95,97,117,
  116,111,119,114,105,116,101,115,116,97,116,10,102,111,95,115,97,118,101,112,
  111,115,12,102,111,95,115,97,118,101,115,116,97,116,101,0,8,115,116,97,
  116,102,105,108,101,7,9,115,116,97,116,102,105,108,101,49,17,105,99,111,
  110,46,116,114,97,110,115,112,97,114,101,110,99,121,4,0,0,0,128,12,
  111,110,99,108,111,115,101,113,117,101,114,121,7,16,102,111,114,109,111,110,
  99,108,111,115,101,113,117,101,114,121,15,109,111,100,117,108,101,99,108,97,
  115,115,110,97,109,101,6,8,116,109,115,101,102,111,114,109,0,11,116,115,
  116,114,105,110,103,103,114,105,100,4,103,114,105,100,13,111,112,116,105,111,
  110,115,119,105,100,103,101,116,11,13,111,119,95,109,111,117,115,101,102,111,
  99,117,115,11,111,119,95,116,97,98,102,111,99,117,115,13,111,119,95,97,
  114,114,111,119,102,111,99,117,115,17,111,119,95,102,111,99,117,115,98,97,
  99,107,111,110,101,115,99,13,111,119,95,109,111,117,115,101,119,104,101,101,
  108,17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,18,
  111,119,95,102,111,110,116,103,108,121,112,104,104,101,105,103,104,116,12,111,
  119,95,97,117,116,111,115,99,97,108,101,0,8,98,111,117,110,100,115,95,
  120,2,0,8,98,111,117,110,100,115,95,121,2,0,9,98,111,117,110,100,
  115,95,99,120,3,125,1,9,98,111,117,110,100,115,95,99,121,3,50,1,
  11,102,114,97,109,101,46,100,117,109,109,121,2,0,7,97,110,99,104,111,
  114,115,11,6,97,110,95,116,111,112,9,97,110,95,98,111,116,116,111,109,
  0,11,111,112,116,105,111,110,115,103,114,105,100,11,12,111,103,95,99,111,
  108,115,105,122,105,110,103,12,111,103,95,114,111,119,109,111,118,105,110,103,
  15,111,103,95,107,101,121,114,111,119,109,111,118,105,110,103,19,111,103,95,
  102,111,99,117,115,99,101,108,108,111,110,101,110,116,101,114,20,111,103,95,
  99,111,108,99,104,97,110,103,101,111,110,116,97,98,107,101,121,12,111,103,
  95,97,117,116,111,112,111,112,117,112,17,111,103,95,109,111,117,115,101,115,
  99,114,111,108,108,99,111,108,0,14,100,97,116,97,99,111,108,115,46,99,
  111,117,110,116,2,2,16,100,97,116,97,99,111,108,115,46,111,112,116,105,
  111,110,115,11,11,99,111,95,114,101,97,100,111,110,108,121,14,99,111,95,
  102,111,99,117,115,115,101,108,101,99,116,12,99,111,95,114,111,119,115,101,
  108,101,99,116,15,99,111,95,112,114,111,112,111,114,116,105,111,110,97,108,
  12,99,111,95,115,97,118,101,115,116,97,116,101,10,99,111,95,114,111,119,
  102,111,110,116,11,99,111,95,114,111,119,99,111,108,111,114,13,99,111,95,
  122,101,98,114,97,99,111,108,111,114,17,99,111,95,109,111,117,115,101,115,
  99,114,111,108,108,114,111,119,0,14,100,97,116,97,99,111,108,115,46,105,
  116,101,109,115,14,1,5,119,105,100,116,104,3,165,0,7,111,112,116,105,
  111,110,115,11,11,99,111,95,114,101,97,100,111,110,108,121,14,99,111,95,
  102,111,99,117,115,115,101,108,101,99,116,12,99,111,95,114,111,119,115,101,
  108,101,99,116,15,99,111,95,112,114,111,112,111,114,116,105,111,110,97,108,
  12,99,111,95,115,97,118,101,115,116,97,116,101,10,99,111,95,114,111,119,
  102,111,110,116,11,99,111,95,114,111,119,99,111,108,111,114,13,99,111,95,
  122,101,98,114,97,99,111,108,111,114,17,99,111,95,109,111,117,115,101,115,
  99,114,111,108,108,114,111,119,0,0,1,5,119,105,100,116,104,3,159,0,
  7,111,112,116,105,111,110,115,11,11,99,111,95,114,101,97,100,111,110,108,
  121,14,99,111,95,102,111,99,117,115,115,101,108,101,99,116,12,99,111,95,
  114,111,119,115,101,108,101,99,116,7,99,111,95,102,105,108,108,12,99,111,
  95,115,97,118,101,115,116,97,116,101,10,99,111,95,114,111,119,102,111,110,
  116,11,99,111,95,114,111,119,99,111,108,111,114,13,99,111,95,122,101,98,
  114,97,99,111,108,111,114,17,99,111,95,109,111,117,115,101,115,99,114,111,
  108,108,114,111,119,0,11,111,112,116,105,111,110,115,101,100,105,116,11,14,
  115,99,111,101,95,117,110,100,111,111,110,101,115,99,14,115,99,111,101,95,
  101,97,116,114,101,116,117,114,110,15,115,99,111,101,95,97,117,116,111,115,
  101,108,101,99,116,27,115,99,111,101,95,97,117,116,111,115,101,108,101,99,
  116,111,110,102,105,114,115,116,99,108,105,99,107,20,115,99,111,101,95,104,
  105,110,116,99,108,105,112,112,101,100,116,101,120,116,0,0,0,13,102,105,
  120,99,111,108,115,46,99,111,117,110,116,2,1,13,102,105,120,99,111,108,
  115,46,105,116,101,109,115,14,1,7,110,117,109,115,116,101,112,2,1,0,
  0,13,102,105,120,114,111,119,115,46,99,111,117,110,116,2,1,13,102,105,
  120,114,111,119,115,46,105,116,101,109,115,14,1,6,104,101,105,103,104,116,
  2,16,14,99,97,112,116,105,111,110,115,46,99,111,117,110,116,2,2,14,
  99,97,112,116,105,111,110,115,46,105,116,101,109,115,14,1,7,99,97,112,
  116,105,111,110,6,4,78,97,109,101,0,1,7,99,97,112,116,105,111,110,
  6,5,67,108,97,115,115,0,0,17,99,97,112,116,105,111,110,115,102,105,
  120,46,99,111,117,110,116,2,1,17,99,97,112,116,105,111,110,115,102,105,
  120,46,105,116,101,109,115,14,1,7,99,97,112,116,105,111,110,6,5,79,
  114,100,101,114,0,0,0,0,13,100,97,116,97,114,111,119,104,101,105,103,
  104,116,2,16,8,115,116,97,116,102,105,108,101,7,9,115,116,97,116,102,
  105,108,101,49,13,114,101,102,102,111,110,116,104,101,105,103,104,116,2,14,
  0,0,7,116,98,117,116,116,111,110,8,116,98,117,116,116,111,110,49,13,
  111,112,116,105,111,110,115,119,105,100,103,101,116,11,11,111,119,95,116,97,
  98,102,111,99,117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,115,
  17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,18,111,
  119,95,102,111,110,116,103,108,121,112,104,104,101,105,103,104,116,12,111,119,
  95,97,117,116,111,115,99,97,108,101,0,8,98,111,117,110,100,115,95,120,
  3,254,0,8,98,111,117,110,100,115,95,121,3,56,1,9,98,111,117,110,
  100,115,95,99,120,2,58,9,98,111,117,110,100,115,95,99,121,2,20,7,
  97,110,99,104,111,114,115,11,8,97,110,95,114,105,103,104,116,9,97,110,
  95,98,111,116,116,111,109,0,8,116,97,98,111,114,100,101,114,2,1,5,
  115,116,97,116,101,11,15,97,115,95,108,111,99,97,108,99,97,112,116,105,
  111,110,0,7,99,97,112,116,105,111,110,6,3,38,79,75,11,109,111,100,
  97,108,114,101,115,117,108,116,7,5,109,114,95,111,107,13,114,101,102,102,
  111,110,116,104,101,105,103,104,116,2,14,0,0,7,116,98,117,116,116,111,
  110,8,116,98,117,116,116,111,110,50,13,111,112,116,105,111,110,115,119,105,
  100,103,101,116,11,11,111,119,95,116,97,98,102,111,99,117,115,13,111,119,
  95,97,114,114,111,119,102,111,99,117,115,17,111,119,95,100,101,115,116,114,
  111,121,119,105,100,103,101,116,115,18,111,119,95,102,111,110,116,103,108,121,
  112,104,104,101,105,103,104,116,12,111,119,95,97,117,116,111,115,99,97,108,
  101,0,8,98,111,117,110,100,115,95,120,3,62,1,8,98,111,117,110,100,
  115,95,121,3,56,1,9,98,111,117,110,100,115,95,99,120,2,58,9,98,
  111,117,110,100,115,95,99,121,2,20,7,97,110,99,104,111,114,115,11,8,
  97,110,95,114,105,103,104,116,9,97,110,95,98,111,116,116,111,109,0,8,
  116,97,98,111,114,100,101,114,2,2,5,115,116,97,116,101,11,10,97,115,
  95,100,101,102,97,117,108,116,15,97,115,95,108,111,99,97,108,100,101,102,
  97,117,108,116,15,97,115,95,108,111,99,97,108,99,97,112,116,105,111,110,
  0,7,99,97,112,116,105,111,110,6,7,38,67,97,110,99,101,108,11,109,
  111,100,97,108,114,101,115,117,108,116,7,9,109,114,95,99,97,110,99,101,
  108,13,114,101,102,102,111,110,116,104,101,105,103,104,116,2,14,0,0,9,
  116,115,116,97,116,102,105,108,101,9,115,116,97,116,102,105,108,101,49,8,
  102,105,108,101,110,97,109,101,6,17,115,101,116,116,97,98,111,114,100,101,
  114,102,111,46,115,116,97,7,111,112,116,105,111,110,115,11,10,115,102,111,
  95,109,101,109,111,114,121,0,4,108,101,102,116,2,104,3,116,111,112,3,
  136,0,0,0,0)
 );

initialization
 registerobjectdata(@objdata,tsetcreateorderfo,'');
end.
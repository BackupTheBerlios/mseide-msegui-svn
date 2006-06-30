unit mseimagelisteditor_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface

implementation
uses
 mseclasses,mseimagelisteditor;

const
 objdata: record size: integer; data: array[0..3825] of byte end =
      (size: 3826; data: (
  84,80,70,48,18,116,105,109,97,103,101,108,105,115,116,101,100,105,116,111,
  114,102,111,17,105,109,97,103,101,108,105,115,116,101,100,105,116,111,114,102,
  111,8,98,111,117,110,100,115,95,120,3,220,0,8,98,111,117,110,100,115,
  95,121,3,69,1,9,98,111,117,110,100,115,95,99,120,3,48,1,9,98,
  111,117,110,100,115,95,99,121,3,91,1,23,99,111,110,116,97,105,110,101,
  114,46,111,112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,
  109,111,117,115,101,102,111,99,117,115,11,111,119,95,116,97,98,102,111,99,
  117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,115,15,111,119,95,
  97,114,114,111,119,102,111,99,117,115,105,110,16,111,119,95,97,114,114,111,
  119,102,111,99,117,115,111,117,116,11,111,119,95,115,117,98,102,111,99,117,
  115,19,111,119,95,109,111,117,115,101,116,114,97,110,115,112,97,114,101,110,
  116,17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,12,
  111,119,95,97,117,116,111,115,99,97,108,101,0,19,99,111,110,116,97,105,
  110,101,114,46,98,111,117,110,100,115,95,99,120,3,48,1,19,99,111,110,
  116,97,105,110,101,114,46,98,111,117,110,100,115,95,99,121,3,91,1,21,
  99,111,110,116,97,105,110,101,114,46,102,114,97,109,101,46,100,117,109,109,
  121,2,0,7,111,112,116,105,111,110,115,11,13,102,111,95,99,108,111,115,
  101,111,110,101,115,99,15,102,111,95,97,117,116,111,114,101,97,100,115,116,
  97,116,16,102,111,95,97,117,116,111,119,114,105,116,101,115,116,97,116,10,
  102,111,95,115,97,118,101,112,111,115,12,102,111,95,115,97,118,101,115,116,
  97,116,101,0,8,115,116,97,116,102,105,108,101,7,9,115,116,97,116,102,
  105,108,101,49,7,99,97,112,116,105,111,110,6,15,73,109,97,103,101,108,
  105,115,116,101,100,105,116,111,114,17,105,99,111,110,46,116,114,97,110,115,
  112,97,114,101,110,99,121,4,0,0,0,128,15,109,111,100,117,108,101,99,
  108,97,115,115,110,97,109,101,6,8,116,109,115,101,102,111,114,109,0,7,
  116,98,117,116,116,111,110,3,97,100,100,13,111,112,116,105,111,110,115,119,
  105,100,103,101,116,11,13,111,119,95,109,111,117,115,101,102,111,99,117,115,
  11,111,119,95,116,97,98,102,111,99,117,115,13,111,119,95,97,114,114,111,
  119,102,111,99,117,115,15,111,119,95,97,114,114,111,119,102,111,99,117,115,
  105,110,16,111,119,95,97,114,114,111,119,102,111,99,117,115,111,117,116,17,
  111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,0,8,98,
  111,117,110,100,115,95,120,2,80,8,98,111,117,110,100,115,95,121,3,66,
  1,9,98,111,117,110,100,115,95,99,120,2,50,9,98,111,117,110,100,115,
  95,99,121,2,20,7,97,110,99,104,111,114,115,11,7,97,110,95,108,101,
  102,116,9,97,110,95,98,111,116,116,111,109,0,7,99,97,112,116,105,111,
  110,6,3,97,100,100,9,111,110,101,120,101,99,117,116,101,7,12,97,100,
  100,111,110,101,120,101,99,117,116,101,0,0,7,116,98,117,116,116,111,110,
  6,99,97,110,99,101,108,13,111,112,116,105,111,110,115,119,105,100,103,101,
  116,11,13,111,119,95,109,111,117,115,101,102,111,99,117,115,11,111,119,95,
  116,97,98,102,111,99,117,115,13,111,119,95,97,114,114,111,119,102,111,99,
  117,115,15,111,119,95,97,114,114,111,119,102,111,99,117,115,105,110,16,111,
  119,95,97,114,114,111,119,102,111,99,117,115,111,117,116,17,111,119,95,100,
  101,115,116,114,111,121,119,105,100,103,101,116,115,0,8,98,111,117,110,100,
  115,95,120,3,192,0,8,98,111,117,110,100,115,95,121,3,66,1,9,98,
  111,117,110,100,115,95,99,120,2,50,9,98,111,117,110,100,115,95,99,121,
  2,20,7,97,110,99,104,111,114,115,11,7,97,110,95,108,101,102,116,9,
  97,110,95,98,111,116,116,111,109,0,8,116,97,98,111,114,100,101,114,2,
  2,7,99,97,112,116,105,111,110,6,6,99,97,110,99,101,108,11,109,111,
  100,97,108,114,101,115,117,108,116,7,9,109,114,95,99,97,110,99,101,108,
  0,0,7,116,98,117,116,116,111,110,2,111,107,13,111,112,116,105,111,110,
  115,119,105,100,103,101,116,11,13,111,119,95,109,111,117,115,101,102,111,99,
  117,115,11,111,119,95,116,97,98,102,111,99,117,115,13,111,119,95,97,114,
  114,111,119,102,111,99,117,115,15,111,119,95,97,114,114,111,119,102,111,99,
  117,115,105,110,16,111,119,95,97,114,114,111,119,102,111,99,117,115,111,117,
  116,17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,0,
  8,98,111,117,110,100,115,95,120,3,248,0,8,98,111,117,110,100,115,95,
  121,3,66,1,9,98,111,117,110,100,115,95,99,120,2,50,9,98,111,117,
  110,100,115,95,99,121,2,20,7,97,110,99,104,111,114,115,11,7,97,110,
  95,108,101,102,116,9,97,110,95,98,111,116,116,111,109,0,8,116,97,98,
  111,114,100,101,114,2,3,7,99,97,112,116,105,111,110,6,2,79,75,11,
  109,111,100,97,108,114,101,115,117,108,116,7,5,109,114,95,111,107,0,0,
  7,116,98,117,116,116,111,110,5,99,108,101,97,114,13,111,112,116,105,111,
  110,115,119,105,100,103,101,116,11,13,111,119,95,109,111,117,115,101,102,111,
  99,117,115,11,111,119,95,116,97,98,102,111,99,117,115,13,111,119,95,97,
  114,114,111,119,102,111,99,117,115,15,111,119,95,97,114,114,111,119,102,111,
  99,117,115,105,110,16,111,119,95,97,114,114,111,119,102,111,99,117,115,111,
  117,116,17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,
  0,8,98,111,117,110,100,115,95,120,3,136,0,8,98,111,117,110,100,115,
  95,121,3,66,1,9,98,111,117,110,100,115,95,99,120,2,50,9,98,111,
  117,110,100,115,95,99,121,2,20,7,97,110,99,104,111,114,115,11,7,97,
  110,95,108,101,102,116,9,97,110,95,98,111,116,116,111,109,0,8,116,97,
  98,111,114,100,101,114,2,1,7,99,97,112,116,105,111,110,6,5,99,108,
  101,97,114,9,111,110,101,120,101,99,117,116,101,7,14,99,108,101,97,114,
  111,110,101,120,101,99,117,116,101,0,0,9,116,108,105,115,116,118,105,101,
  119,4,100,105,115,112,13,111,112,116,105,111,110,115,119,105,100,103,101,116,
  11,13,111,119,95,109,111,117,115,101,102,111,99,117,115,13,111,119,95,97,
  114,114,111,119,102,111,99,117,115,15,111,119,95,97,114,114,111,119,102,111,
  99,117,115,105,110,16,111,119,95,97,114,114,111,119,102,111,99,117,115,111,
  117,116,17,111,119,95,102,111,99,117,115,98,97,99,107,111,110,101,115,99,
  17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,18,111,
  119,95,102,111,110,116,103,108,121,112,104,104,101,105,103,104,116,0,9,98,
  111,117,110,100,115,95,99,120,3,48,1,9,98,111,117,110,100,115,95,99,
  121,3,28,1,11,102,114,97,109,101,46,100,117,109,109,121,2,0,7,97,
  110,99,104,111,114,115,11,6,97,110,95,116,111,112,9,97,110,95,98,111,
  116,116,111,109,0,8,116,97,98,111,114,100,101,114,2,7,10,99,101,108,
  108,104,101,105,103,104,116,2,54,11,111,112,116,105,111,110,115,103,114,105,
  100,11,19,111,103,95,102,111,99,117,115,99,101,108,108,111,110,101,110,116,
  101,114,12,111,103,95,114,111,116,97,116,101,114,111,119,12,111,103,95,97,
  117,116,111,112,111,112,117,112,0,7,111,112,116,105,111,110,115,11,15,108,
  118,111,95,109,111,117,115,101,109,111,118,105,110,103,13,108,118,111,95,107,
  101,121,109,111,118,105,110,103,8,108,118,111,95,104,111,114,122,13,108,118,
  111,95,100,114,97,119,102,111,99,117,115,15,108,118,111,95,102,111,99,117,
  115,115,101,108,101,99,116,15,108,118,111,95,109,111,117,115,101,115,101,108,
  101,99,116,13,108,118,111,95,107,101,121,115,101,108,101,99,116,15,108,118,
  111,95,109,117,108,116,105,115,101,108,101,99,116,0,19,105,116,101,109,108,
  105,115,116,46,99,97,112,116,105,111,110,112,111,115,7,9,99,112,95,98,
  111,116,116,111,109,18,105,116,101,109,108,105,115,116,46,105,109,97,103,101,
  108,105,115,116,7,9,105,109,97,103,101,108,105,115,116,19,105,116,101,109,
  108,105,115,116,46,105,109,97,103,101,119,105,100,116,104,2,16,20,105,116,
  101,109,108,105,115,116,46,105,109,97,103,101,104,101,105,103,104,116,2,16,
  11,111,110,105,116,101,109,101,118,101,110,116,7,15,100,105,115,112,111,110,
  105,116,101,109,101,118,101,110,116,12,111,110,105,116,101,109,115,109,111,118,
  101,100,7,16,100,105,115,112,111,110,105,116,101,109,115,109,111,118,101,100,
  13,114,101,102,102,111,110,116,104,101,105,103,104,116,2,16,0,0,12,116,
  98,111,111,108,101,97,110,101,100,105,116,7,115,116,114,101,116,99,104,8,
  98,111,117,110,100,115,95,120,2,8,8,98,111,117,110,100,115,95,121,3,
  67,1,9,98,111,117,110,100,115,95,99,120,2,55,9,98,111,117,110,100,
  115,95,99,121,2,18,13,102,114,97,109,101,46,99,97,112,116,105,111,110,
  6,7,115,116,114,101,116,99,104,11,102,114,97,109,101,46,100,117,109,109,
  121,2,0,16,102,114,97,109,101,46,111,117,116,101,114,102,114,97,109,101,
  1,2,0,2,2,2,42,2,3,0,7,97,110,99,104,111,114,115,11,7,
  97,110,95,108,101,102,116,9,97,110,95,98,111,116,116,111,109,0,8,116,
  97,98,111,114,100,101,114,2,6,8,115,116,97,116,102,105,108,101,7,9,
  115,116,97,116,102,105,108,101,49,5,118,97,108,117,101,9,0,0,12,116,
  98,111,111,108,101,97,110,101,100,105,116,6,109,97,115,107,101,100,8,98,
  111,117,110,100,115,95,120,2,8,8,98,111,117,110,100,115,95,121,3,38,
  1,9,98,111,117,110,100,115,95,99,120,2,62,9,98,111,117,110,100,115,
  95,99,121,2,18,13,102,114,97,109,101,46,99,97,112,116,105,111,110,6,
  6,109,97,115,107,101,100,11,102,114,97,109,101,46,100,117,109,109,121,2,
  0,16,102,114,97,109,101,46,111,117,116,101,114,102,114,97,109,101,1,2,
  0,2,2,2,49,2,3,0,7,97,110,99,104,111,114,115,11,7,97,110,
  95,108,101,102,116,9,97,110,95,98,111,116,116,111,109,0,8,116,97,98,
  111,114,100,101,114,2,4,5,118,97,108,117,101,9,0,0,10,116,99,111,
  108,111,114,101,100,105,116,16,116,114,97,110,115,112,97,114,101,110,116,99,
  111,108,111,114,13,111,112,116,105,111,110,115,119,105,100,103,101,116,11,13,
  111,119,95,109,111,117,115,101,102,111,99,117,115,11,111,119,95,116,97,98,
  102,111,99,117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,115,17,
  111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,18,111,119,
  95,102,111,110,116,103,108,121,112,104,104,101,105,103,104,116,12,111,119,95,
  97,117,116,111,115,99,97,108,101,0,8,98,111,117,110,100,115,95,120,2,
  80,8,98,111,117,110,100,115,95,121,3,35,1,9,98,111,117,110,100,115,
  95,99,120,3,213,0,9,98,111,117,110,100,115,95,99,121,2,22,13,102,
  114,97,109,101,46,99,97,112,116,105,111,110,6,17,84,114,97,110,115,112,
  97,114,101,110,116,32,99,111,108,111,114,16,102,114,97,109,101,46,99,97,
  112,116,105,111,110,112,111,115,7,8,99,112,95,114,105,103,104,116,18,102,
  114,97,109,101,46,98,117,116,116,111,110,46,119,105,100,116,104,2,13,11,
  102,114,97,109,101,46,100,117,109,109,121,2,0,16,102,114,97,109,101,46,
  111,117,116,101,114,102,114,97,109,101,1,2,0,2,0,2,107,2,0,0,
  7,97,110,99,104,111,114,115,11,7,97,110,95,108,101,102,116,9,97,110,
  95,98,111,116,116,111,109,0,8,116,97,98,111,114,100,101,114,2,5,8,
  115,116,97,116,102,105,108,101,7,9,115,116,97,116,102,105,108,101,49,5,
  118,97,108,117,101,4,1,0,0,128,12,118,97,108,117,101,100,101,102,97,
  117,108,116,4,0,0,0,128,19,98,117,116,116,111,110,101,108,108,105,112,
  115,101,46,119,105,100,116,104,2,13,21,98,117,116,116,111,110,101,108,108,
  105,112,115,101,46,105,109,97,103,101,110,114,2,17,16,100,114,111,112,100,
  111,119,110,46,111,112,116,105,111,110,115,11,16,100,101,111,95,97,117,116,
  111,100,114,111,112,100,111,119,110,15,100,101,111,95,107,101,121,100,114,111,
  112,100,111,119,110,0,19,100,114,111,112,100,111,119,110,46,99,111,108,115,
  46,99,111,117,110,116,2,1,19,100,114,111,112,100,111,119,110,46,99,111,
  108,115,46,105,116,101,109,115,14,1,4,100,97,116,97,1,6,4,99,108,
  95,48,6,4,99,108,95,49,6,8,99,108,95,98,108,97,99,107,6,9,
  99,108,95,100,107,103,114,97,121,6,7,99,108,95,103,114,97,121,6,9,
  99,108,95,108,116,103,114,97,121,6,8,99,108,95,119,104,105,116,101,6,
  6,99,108,95,114,101,100,6,8,99,108,95,103,114,101,101,110,6,7,99,
  108,95,98,108,117,101,6,7,99,108,95,99,121,97,110,6,10,99,108,95,
  109,97,103,101,110,116,97,6,9,99,108,95,121,101,108,108,111,119,6,8,
  99,108,95,100,107,114,101,100,6,10,99,108,95,100,107,103,114,101,101,110,
  6,9,99,108,95,100,107,98,108,117,101,6,9,99,108,95,100,107,99,121,
  97,110,6,12,99,108,95,100,107,109,97,103,101,110,116,97,6,11,99,108,
  95,100,107,121,101,108,108,111,119,6,8,99,108,95,108,116,114,101,100,6,
  10,99,108,95,108,116,103,114,101,101,110,6,9,99,108,95,108,116,98,108,
  117,101,6,9,99,108,95,108,116,99,121,97,110,6,12,99,108,95,108,116,
  109,97,103,101,110,116,97,6,11,99,108,95,108,116,121,101,108,108,111,119,
  6,11,99,108,95,100,107,115,104,97,100,111,119,6,9,99,108,95,115,104,
  97,100,111,119,6,6,99,108,95,109,105,100,6,8,99,108,95,108,105,103,
  104,116,6,12,99,108,95,104,105,103,104,108,105,103,104,116,6,13,99,108,
  95,98,97,99,107,103,114,111,117,110,100,6,13,99,108,95,102,111,114,101,
  103,114,111,117,110,100,6,9,99,108,95,97,99,116,105,118,101,6,9,99,
  108,95,110,111,101,100,105,116,6,7,99,108,95,116,101,120,116,6,15,99,
  108,95,115,101,108,101,99,116,101,100,116,101,120,116,6,25,99,108,95,115,
  101,108,101,99,116,101,100,116,101,120,116,98,97,99,107,103,114,111,117,110,
  100,6,17,99,108,95,105,110,102,111,98,97,99,107,103,114,111,117,110,100,
  6,8,99,108,95,103,108,121,112,104,6,7,99,108,95,110,111,110,101,6,
  10,99,108,95,100,101,102,97,117,108,116,6,9,99,108,95,112,97,114,101,
  110,116,6,14,99,108,95,116,114,97,110,115,112,97,114,101,110,116,6,8,
  99,108,95,98,114,117,115,104,6,14,99,108,95,98,114,117,115,104,99,97,
  110,118,97,115,0,0,0,18,100,114,111,112,100,111,119,110,46,105,116,101,
  109,105,110,100,101,120,2,40,13,114,101,102,102,111,110,116,104,101,105,103,
  104,116,2,16,0,0,10,116,105,109,97,103,101,108,105,115,116,9,105,109,
  97,103,101,108,105,115,116,16,116,114,97,110,115,112,97,114,101,110,116,99,
  111,108,111,114,4,1,0,0,128,4,76,101,102,116,2,24,3,84,111,112,
  3,176,0,0,0,11,116,102,105,108,101,100,105,97,108,111,103,10,102,105,
  108,101,100,105,97,108,111,103,8,115,116,97,116,102,105,108,101,7,9,115,
  116,97,116,102,105,108,101,49,26,99,111,110,116,114,111,108,108,101,114,46,
  102,105,108,116,101,114,108,105,115,116,46,100,97,116,97,1,1,6,7,66,
  105,116,109,97,112,115,6,5,42,46,98,109,112,0,1,6,3,97,108,108,
  6,1,42,0,0,4,76,101,102,116,2,112,3,84,111,112,3,176,0,0,
  0,9,116,115,116,97,116,102,105,108,101,9,115,116,97,116,102,105,108,101,
  49,8,102,105,108,101,110,97,109,101,6,15,105,109,97,103,101,108,105,115,
  116,101,100,105,116,111,114,7,111,112,116,105,111,110,115,11,10,115,102,111,
  95,109,101,109,111,114,121,0,4,76,101,102,116,3,200,0,3,84,111,112,
  3,176,0,0,0,0)
 );

initialization
 registerobjectdata(@objdata,timagelisteditorfo,'');
end.

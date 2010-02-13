unit mseimagelisteditor_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,mseimagelisteditor;

const
 objdata: record size: integer; data: array[0..3650] of byte end =
      (size: 3651; data: (
  84,80,70,48,18,116,105,109,97,103,101,108,105,115,116,101,100,105,116,111,
  114,102,111,17,105,109,97,103,101,108,105,115,116,101,100,105,116,111,114,102,
  111,13,111,112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,
  97,114,114,111,119,102,111,99,117,115,15,111,119,95,97,114,114,111,119,102,
  111,99,117,115,105,110,16,111,119,95,97,114,114,111,119,102,111,99,117,115,
  111,117,116,11,111,119,95,115,117,98,102,111,99,117,115,17,111,119,95,100,
  101,115,116,114,111,121,119,105,100,103,101,116,115,9,111,119,95,104,105,110,
  116,111,110,12,111,119,95,97,117,116,111,115,99,97,108,101,0,8,98,111,
  117,110,100,115,95,120,3,220,0,8,98,111,117,110,100,115,95,121,3,69,
  1,9,98,111,117,110,100,115,95,99,120,3,48,1,9,98,111,117,110,100,
  115,95,99,121,3,91,1,8,116,97,98,111,114,100,101,114,2,1,23,99,
  111,110,116,97,105,110,101,114,46,111,112,116,105,111,110,115,119,105,100,103,
  101,116,11,13,111,119,95,109,111,117,115,101,102,111,99,117,115,11,111,119,
  95,116,97,98,102,111,99,117,115,13,111,119,95,97,114,114,111,119,102,111,
  99,117,115,15,111,119,95,97,114,114,111,119,102,111,99,117,115,105,110,16,
  111,119,95,97,114,114,111,119,102,111,99,117,115,111,117,116,11,111,119,95,
  115,117,98,102,111,99,117,115,19,111,119,95,109,111,117,115,101,116,114,97,
  110,115,112,97,114,101,110,116,17,111,119,95,100,101,115,116,114,111,121,119,
  105,100,103,101,116,115,12,111,119,95,97,117,116,111,115,99,97,108,101,0,
  18,99,111,110,116,97,105,110,101,114,46,98,111,117,110,100,115,95,120,2,
  0,18,99,111,110,116,97,105,110,101,114,46,98,111,117,110,100,115,95,121,
  2,0,19,99,111,110,116,97,105,110,101,114,46,98,111,117,110,100,115,95,
  99,120,3,48,1,19,99,111,110,116,97,105,110,101,114,46,98,111,117,110,
  100,115,95,99,121,3,91,1,21,99,111,110,116,97,105,110,101,114,46,102,
  114,97,109,101,46,100,117,109,109,121,2,0,7,111,112,116,105,111,110,115,
  11,13,102,111,95,99,108,111,115,101,111,110,101,115,99,17,102,111,95,108,
  111,99,97,108,115,104,111,114,116,99,117,116,115,15,102,111,95,97,117,116,
  111,114,101,97,100,115,116,97,116,16,102,111,95,97,117,116,111,119,114,105,
  116,101,115,116,97,116,10,102,111,95,115,97,118,101,112,111,115,12,102,111,
  95,115,97,118,101,115,116,97,116,101,0,8,115,116,97,116,102,105,108,101,
  7,9,115,116,97,116,102,105,108,101,49,7,99,97,112,116,105,111,110,6,
  15,73,109,97,103,101,108,105,115,116,101,100,105,116,111,114,15,109,111,100,
  117,108,101,99,108,97,115,115,110,97,109,101,6,8,116,109,115,101,102,111,
  114,109,0,7,116,98,117,116,116,111,110,3,97,100,100,13,111,112,116,105,
  111,110,115,119,105,100,103,101,116,11,13,111,119,95,109,111,117,115,101,102,
  111,99,117,115,11,111,119,95,116,97,98,102,111,99,117,115,13,111,119,95,
  97,114,114,111,119,102,111,99,117,115,15,111,119,95,97,114,114,111,119,102,
  111,99,117,115,105,110,16,111,119,95,97,114,114,111,119,102,111,99,117,115,
  111,117,116,17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,
  115,0,8,98,111,117,110,100,115,95,120,2,80,8,98,111,117,110,100,115,
  95,121,3,66,1,9,98,111,117,110,100,115,95,99,120,2,50,9,98,111,
  117,110,100,115,95,99,121,2,20,7,97,110,99,104,111,114,115,11,7,97,
  110,95,108,101,102,116,9,97,110,95,98,111,116,116,111,109,0,5,115,116,
  97,116,101,11,15,97,115,95,108,111,99,97,108,99,97,112,116,105,111,110,
  17,97,115,95,108,111,99,97,108,111,110,101,120,101,99,117,116,101,0,11,
  97,117,116,111,115,105,122,101,95,99,120,2,0,11,97,117,116,111,115,105,
  122,101,95,99,121,2,0,7,99,97,112,116,105,111,110,6,3,97,100,100,
  9,111,110,101,120,101,99,117,116,101,7,12,97,100,100,111,110,101,120,101,
  99,117,116,101,0,0,7,116,98,117,116,116,111,110,6,99,97,110,99,101,
  108,13,111,112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,
  109,111,117,115,101,102,111,99,117,115,11,111,119,95,116,97,98,102,111,99,
  117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,115,15,111,119,95,
  97,114,114,111,119,102,111,99,117,115,105,110,16,111,119,95,97,114,114,111,
  119,102,111,99,117,115,111,117,116,17,111,119,95,100,101,115,116,114,111,121,
  119,105,100,103,101,116,115,0,8,98,111,117,110,100,115,95,120,3,192,0,
  8,98,111,117,110,100,115,95,121,3,66,1,9,98,111,117,110,100,115,95,
  99,120,2,50,9,98,111,117,110,100,115,95,99,121,2,20,7,97,110,99,
  104,111,114,115,11,7,97,110,95,108,101,102,116,9,97,110,95,98,111,116,
  116,111,109,0,8,116,97,98,111,114,100,101,114,2,2,5,115,116,97,116,
  101,11,15,97,115,95,108,111,99,97,108,99,97,112,116,105,111,110,0,11,
  97,117,116,111,115,105,122,101,95,99,120,2,0,11,97,117,116,111,115,105,
  122,101,95,99,121,2,0,7,99,97,112,116,105,111,110,6,6,99,97,110,
  99,101,108,11,109,111,100,97,108,114,101,115,117,108,116,7,9,109,114,95,
  99,97,110,99,101,108,0,0,7,116,98,117,116,116,111,110,2,111,107,13,
  111,112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,109,111,
  117,115,101,102,111,99,117,115,11,111,119,95,116,97,98,102,111,99,117,115,
  13,111,119,95,97,114,114,111,119,102,111,99,117,115,15,111,119,95,97,114,
  114,111,119,102,111,99,117,115,105,110,16,111,119,95,97,114,114,111,119,102,
  111,99,117,115,111,117,116,17,111,119,95,100,101,115,116,114,111,121,119,105,
  100,103,101,116,115,0,8,98,111,117,110,100,115,95,120,3,248,0,8,98,
  111,117,110,100,115,95,121,3,66,1,9,98,111,117,110,100,115,95,99,120,
  2,50,9,98,111,117,110,100,115,95,99,121,2,20,7,97,110,99,104,111,
  114,115,11,7,97,110,95,108,101,102,116,9,97,110,95,98,111,116,116,111,
  109,0,8,116,97,98,111,114,100,101,114,2,3,5,115,116,97,116,101,11,
  15,97,115,95,108,111,99,97,108,99,97,112,116,105,111,110,0,11,97,117,
  116,111,115,105,122,101,95,99,120,2,0,11,97,117,116,111,115,105,122,101,
  95,99,121,2,0,7,99,97,112,116,105,111,110,6,2,79,75,11,109,111,
  100,97,108,114,101,115,117,108,116,7,5,109,114,95,111,107,0,0,7,116,
  98,117,116,116,111,110,5,99,108,101,97,114,13,111,112,116,105,111,110,115,
  119,105,100,103,101,116,11,13,111,119,95,109,111,117,115,101,102,111,99,117,
  115,11,111,119,95,116,97,98,102,111,99,117,115,13,111,119,95,97,114,114,
  111,119,102,111,99,117,115,15,111,119,95,97,114,114,111,119,102,111,99,117,
  115,105,110,16,111,119,95,97,114,114,111,119,102,111,99,117,115,111,117,116,
  17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,0,8,
  98,111,117,110,100,115,95,120,3,136,0,8,98,111,117,110,100,115,95,121,
  3,66,1,9,98,111,117,110,100,115,95,99,120,2,50,9,98,111,117,110,
  100,115,95,99,121,2,20,7,97,110,99,104,111,114,115,11,7,97,110,95,
  108,101,102,116,9,97,110,95,98,111,116,116,111,109,0,8,116,97,98,111,
  114,100,101,114,2,1,5,115,116,97,116,101,11,15,97,115,95,108,111,99,
  97,108,99,97,112,116,105,111,110,17,97,115,95,108,111,99,97,108,111,110,
  101,120,101,99,117,116,101,0,11,97,117,116,111,115,105,122,101,95,99,120,
  2,0,11,97,117,116,111,115,105,122,101,95,99,121,2,0,7,99,97,112,
  116,105,111,110,6,5,99,108,101,97,114,9,111,110,101,120,101,99,117,116,
  101,7,14,99,108,101,97,114,111,110,101,120,101,99,117,116,101,0,0,9,
  116,108,105,115,116,118,105,101,119,4,100,105,115,112,13,111,112,116,105,111,
  110,115,119,105,100,103,101,116,11,13,111,119,95,109,111,117,115,101,102,111,
  99,117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,115,15,111,119,
  95,97,114,114,111,119,102,111,99,117,115,105,110,16,111,119,95,97,114,114,
  111,119,102,111,99,117,115,111,117,116,17,111,119,95,102,111,99,117,115,98,
  97,99,107,111,110,101,115,99,17,111,119,95,100,101,115,116,114,111,121,119,
  105,100,103,101,116,115,18,111,119,95,102,111,110,116,103,108,121,112,104,104,
  101,105,103,104,116,0,8,98,111,117,110,100,115,95,120,2,0,8,98,111,
  117,110,100,115,95,121,2,0,9,98,111,117,110,100,115,95,99,120,3,48,
  1,9,98,111,117,110,100,115,95,99,121,3,28,1,11,102,114,97,109,101,
  46,100,117,109,109,121,2,0,7,97,110,99,104,111,114,115,11,6,97,110,
  95,116,111,112,9,97,110,95,98,111,116,116,111,109,0,8,116,97,98,111,
  114,100,101,114,2,7,10,99,101,108,108,104,101,105,103,104,116,2,62,11,
  111,112,116,105,111,110,115,103,114,105,100,11,12,111,103,95,99,111,108,115,
  105,122,105,110,103,12,111,103,95,114,111,119,115,105,122,105,110,103,19,111,
  103,95,102,111,99,117,115,99,101,108,108,111,110,101,110,116,101,114,10,111,
  103,95,119,114,97,112,114,111,119,10,111,103,95,119,114,97,112,99,111,108,
  12,111,103,95,97,117,116,111,112,111,112,117,112,0,7,111,112,116,105,111,
  110,115,11,12,108,118,111,95,114,101,97,100,111,110,108,121,15,108,118,111,
  95,109,111,117,115,101,109,111,118,105,110,103,13,108,118,111,95,107,101,121,
  109,111,118,105,110,103,8,108,118,111,95,104,111,114,122,13,108,118,111,95,
  100,114,97,119,102,111,99,117,115,15,108,118,111,95,102,111,99,117,115,115,
  101,108,101,99,116,15,108,118,111,95,109,111,117,115,101,115,101,108,101,99,
  116,13,108,118,111,95,107,101,121,115,101,108,101,99,116,15,108,118,111,95,
  109,117,108,116,105,115,101,108,101,99,116,10,108,118,111,95,108,111,99,97,
  116,101,0,19,105,116,101,109,108,105,115,116,46,99,97,112,116,105,111,110,
  112,111,115,7,9,99,112,95,98,111,116,116,111,109,18,105,116,101,109,108,
  105,115,116,46,105,109,97,103,101,108,105,115,116,7,9,105,109,97,103,101,
  108,105,115,116,19,105,116,101,109,108,105,115,116,46,105,109,97,103,101,119,
  105,100,116,104,2,16,20,105,116,101,109,108,105,115,116,46,105,109,97,103,
  101,104,101,105,103,104,116,2,16,15,111,110,108,97,121,111,117,116,99,104,
  97,110,103,101,100,7,13,108,97,121,111,117,116,99,104,97,110,103,101,100,
  11,111,110,105,116,101,109,101,118,101,110,116,7,15,100,105,115,112,111,110,
  105,116,101,109,101,118,101,110,116,12,111,110,105,116,101,109,115,109,111,118,
  101,100,7,16,100,105,115,112,111,110,105,116,101,109,115,109,111,118,101,100,
  13,114,101,102,102,111,110,116,104,101,105,103,104,116,2,14,0,0,12,116,
  98,111,111,108,101,97,110,101,100,105,116,7,115,116,114,101,116,99,104,8,
  98,111,117,110,100,115,95,120,2,8,8,98,111,117,110,100,115,95,121,3,
  68,1,9,98,111,117,110,100,115,95,99,120,2,53,9,98,111,117,110,100,
  115,95,99,121,2,16,13,102,114,97,109,101,46,99,97,112,116,105,111,110,
  6,7,115,116,114,101,116,99,104,11,102,114,97,109,101,46,100,117,109,109,
  121,2,0,16,102,114,97,109,101,46,111,117,116,101,114,102,114,97,109,101,
  1,2,0,2,1,2,40,2,2,0,7,97,110,99,104,111,114,115,11,7,
  97,110,95,108,101,102,116,9,97,110,95,98,111,116,116,111,109,0,8,116,
  97,98,111,114,100,101,114,2,6,8,115,116,97,116,102,105,108,101,7,9,
  115,116,97,116,102,105,108,101,49,5,118,97,108,117,101,9,0,0,12,116,
  98,111,111,108,101,97,110,101,100,105,116,6,109,97,115,107,101,100,8,98,
  111,117,110,100,115,95,120,2,8,8,98,111,117,110,100,115,95,121,3,39,
  1,9,98,111,117,110,100,115,95,99,120,2,61,9,98,111,117,110,100,115,
  95,99,121,2,16,13,102,114,97,109,101,46,99,97,112,116,105,111,110,6,
  6,109,97,115,107,101,100,11,102,114,97,109,101,46,100,117,109,109,121,2,
  0,16,102,114,97,109,101,46,111,117,116,101,114,102,114,97,109,101,1,2,
  0,2,1,2,48,2,2,0,7,97,110,99,104,111,114,115,11,7,97,110,
  95,108,101,102,116,9,97,110,95,98,111,116,116,111,109,0,8,116,97,98,
  111,114,100,101,114,2,4,5,118,97,108,117,101,9,0,0,10,116,99,111,
  108,111,114,101,100,105,116,16,116,114,97,110,115,112,97,114,101,110,116,99,
  111,108,111,114,8,98,111,117,110,100,115,95,120,2,80,8,98,111,117,110,
  100,115,95,121,3,37,1,9,98,111,117,110,100,115,95,99,120,3,206,0,
  9,98,111,117,110,100,115,95,99,121,2,20,13,102,114,97,109,101,46,99,
  97,112,116,105,111,110,6,17,84,114,97,110,115,112,97,114,101,110,116,32,
  99,111,108,111,114,16,102,114,97,109,101,46,99,97,112,116,105,111,110,112,
  111,115,7,8,99,112,95,114,105,103,104,116,18,102,114,97,109,101,46,98,
  117,116,116,111,110,46,119,105,100,116,104,2,13,18,102,114,97,109,101,46,
  98,117,116,116,111,110,46,99,111,108,111,114,4,2,0,0,128,25,102,114,
  97,109,101,46,98,117,116,116,111,110,101,108,108,105,112,115,101,46,119,105,
  100,116,104,2,13,25,102,114,97,109,101,46,98,117,116,116,111,110,101,108,
  108,105,112,115,101,46,99,111,108,111,114,4,2,0,0,128,27,102,114,97,
  109,101,46,98,117,116,116,111,110,101,108,108,105,112,115,101,46,105,109,97,
  103,101,110,114,2,17,11,102,114,97,109,101,46,100,117,109,109,121,2,0,
  16,102,114,97,109,101,46,111,117,116,101,114,102,114,97,109,101,1,2,0,
  2,0,2,100,2,0,0,7,97,110,99,104,111,114,115,11,7,97,110,95,
  108,101,102,116,9,97,110,95,98,111,116,116,111,109,0,8,116,97,98,111,
  114,100,101,114,2,5,8,115,116,97,116,102,105,108,101,7,9,115,116,97,
  116,102,105,108,101,49,5,118,97,108,117,101,4,1,0,0,128,16,100,114,
  111,112,100,111,119,110,46,111,112,116,105,111,110,115,11,16,100,101,111,95,
  97,117,116,111,100,114,111,112,100,111,119,110,15,100,101,111,95,107,101,121,
  100,114,111,112,100,111,119,110,0,13,114,101,102,102,111,110,116,104,101,105,
  103,104,116,2,14,0,0,10,116,105,109,97,103,101,108,105,115,116,9,105,
  109,97,103,101,108,105,115,116,16,116,114,97,110,115,112,97,114,101,110,116,
  99,111,108,111,114,4,1,0,0,128,4,108,101,102,116,2,24,3,116,111,
  112,3,176,0,0,0,11,116,102,105,108,101,100,105,97,108,111,103,10,102,
  105,108,101,100,105,97,108,111,103,8,115,116,97,116,102,105,108,101,7,9,
  115,116,97,116,102,105,108,101,49,10,100,105,97,108,111,103,107,105,110,100,
  7,8,102,100,107,95,110,111,110,101,4,108,101,102,116,2,112,3,116,111,
  112,3,176,0,0,0,9,116,115,116,97,116,102,105,108,101,9,115,116,97,
  116,102,105,108,101,49,8,102,105,108,101,110,97,109,101,6,15,105,109,97,
  103,101,108,105,115,116,101,100,105,116,111,114,7,111,112,116,105,111,110,115,
  11,10,115,102,111,95,109,101,109,111,114,121,0,4,108,101,102,116,3,200,
  0,3,116,111,112,3,176,0,0,0,0)
 );

initialization
 registerobjectdata(@objdata,timagelisteditorfo,'');
end.
unit guitemplates_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface

implementation
uses
 mseclasses,guitemplates;

const
 objdata: record size: integer; data: array[0..1688] of byte end =
      (size: 1689; data: (
  84,80,70,48,15,116,103,117,105,116,101,109,112,108,97,116,101,115,109,111,
  14,103,117,105,116,101,109,112,108,97,116,101,115,109,111,8,111,110,99,114,
  101,97,116,101,7,3,99,114,101,4,108,101,102,116,2,100,3,116,111,112,
  2,100,15,109,111,100,117,108,101,99,108,97,115,115,110,97,109,101,6,14,
  116,109,115,101,100,97,116,97,109,111,100,117,108,101,4,115,105,122,101,1,
  3,227,1,3,132,0,0,0,9,116,102,97,99,101,99,111,109,112,14,102,
  97,100,101,118,101,114,116,107,111,110,118,101,120,23,116,101,109,112,108,97,
  116,101,46,102,97,100,101,95,112,111,115,46,99,111,117,110,116,2,2,23,
  116,101,109,112,108,97,116,101,46,102,97,100,101,95,112,111,115,46,105,116,
  101,109,115,1,5,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,
  0,0,0,128,255,63,0,25,116,101,109,112,108,97,116,101,46,102,97,100,
  101,95,99,111,108,111,114,46,99,111,117,110,116,2,2,25,116,101,109,112,
  108,97,116,101,46,102,97,100,101,95,99,111,108,111,114,46,105,116,101,109,
  115,1,4,219,219,219,0,4,200,200,200,0,0,23,116,101,109,112,108,97,
  116,101,46,102,97,100,101,95,100,105,114,101,99,116,105,111,110,7,7,103,
  100,95,100,111,119,110,4,108,101,102,116,2,24,3,116,111,112,2,16,0,
  0,9,116,102,97,99,101,99,111,109,112,14,102,97,100,101,104,111,114,122,
  99,111,110,118,101,120,23,116,101,109,112,108,97,116,101,46,102,97,100,101,
  95,112,111,115,46,99,111,117,110,116,2,2,23,116,101,109,112,108,97,116,
  101,46,102,97,100,101,95,112,111,115,46,105,116,101,109,115,1,5,0,0,
  0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,128,255,63,0,
  25,116,101,109,112,108,97,116,101,46,102,97,100,101,95,99,111,108,111,114,
  46,99,111,117,110,116,2,2,25,116,101,109,112,108,97,116,101,46,102,97,
  100,101,95,99,111,108,111,114,46,105,116,101,109,115,1,4,219,219,219,0,
  4,200,200,200,0,0,4,108,101,102,116,2,24,3,116,111,112,2,40,0,
  0,9,116,102,97,99,101,99,111,109,112,15,102,97,100,101,104,111,114,122,
  99,111,110,99,97,118,101,23,116,101,109,112,108,97,116,101,46,102,97,100,
  101,95,112,111,115,46,99,111,117,110,116,2,2,23,116,101,109,112,108,97,
  116,101,46,102,97,100,101,95,112,111,115,46,105,116,101,109,115,1,5,0,
  0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,128,255,63,
  0,25,116,101,109,112,108,97,116,101,46,102,97,100,101,95,99,111,108,111,
  114,46,99,111,117,110,116,2,2,25,116,101,109,112,108,97,116,101,46,102,
  97,100,101,95,99,111,108,111,114,46,105,116,101,109,115,1,4,219,219,219,
  0,4,200,200,200,0,0,23,116,101,109,112,108,97,116,101,46,102,97,100,
  101,95,100,105,114,101,99,116,105,111,110,7,7,103,100,95,108,101,102,116,
  4,108,101,102,116,3,144,0,3,116,111,112,2,40,0,0,9,116,102,97,
  99,101,99,111,109,112,15,102,97,100,101,118,101,114,116,99,111,110,99,97,
  118,101,23,116,101,109,112,108,97,116,101,46,102,97,100,101,95,112,111,115,
  46,99,111,117,110,116,2,2,23,116,101,109,112,108,97,116,101,46,102,97,
  100,101,95,112,111,115,46,105,116,101,109,115,1,5,0,0,0,0,0,0,
  0,0,0,0,5,0,0,0,0,0,0,0,128,255,63,0,25,116,101,109,
  112,108,97,116,101,46,102,97,100,101,95,99,111,108,111,114,46,99,111,117,
  110,116,2,2,25,116,101,109,112,108,97,116,101,46,102,97,100,101,95,99,
  111,108,111,114,46,105,116,101,109,115,1,4,219,219,219,0,4,200,200,200,
  0,0,23,116,101,109,112,108,97,116,101,46,102,97,100,101,95,100,105,114,
  101,99,116,105,111,110,7,5,103,100,95,117,112,4,108,101,102,116,3,144,
  0,3,116,111,112,2,16,0,0,15,116,115,107,105,110,99,111,110,116,114,
  111,108,108,101,114,4,115,107,105,110,6,97,99,116,105,118,101,9,18,115,
  98,95,104,111,114,122,95,102,97,99,101,98,117,116,116,111,110,7,14,102,
  97,100,101,118,101,114,116,107,111,110,118,101,120,21,115,98,95,104,111,114,
  122,95,102,97,99,101,101,110,100,98,117,116,116,111,110,7,14,102,97,100,
  101,118,101,114,116,107,111,110,118,101,120,18,115,98,95,118,101,114,116,95,
  102,97,99,101,98,117,116,116,111,110,7,14,102,97,100,101,104,111,114,122,
  99,111,110,118,101,120,21,115,98,95,118,101,114,116,95,102,97,99,101,101,
  110,100,98,117,116,116,111,110,7,14,102,97,100,101,104,111,114,122,99,111,
  110,118,101,120,12,119,105,100,103,101,116,95,99,111,108,111,114,4,3,0,
  0,128,14,99,111,110,116,97,105,110,101,114,95,102,97,99,101,7,14,102,
  97,100,101,104,111,114,122,99,111,110,118,101,120,17,103,114,105,100,95,102,
  105,120,114,111,119,115,95,102,97,99,101,7,14,102,97,100,101,118,101,114,
  116,107,111,110,118,101,120,11,98,117,116,116,111,110,95,102,97,99,101,7,
  14,102,97,100,101,118,101,114,116,107,111,110,118,101,120,16,102,114,97,109,
  101,98,117,116,116,111,110,95,102,97,99,101,7,14,102,97,100,101,104,111,
  114,122,99,111,110,118,101,120,16,116,97,98,98,97,114,95,104,111,114,122,
  95,102,97,99,101,7,15,102,97,100,101,118,101,114,116,99,111,110,99,97,
  118,101,20,116,97,98,98,97,114,95,104,111,114,122,95,116,97,98,95,102,
  97,99,101,7,14,102,97,100,101,118,101,114,116,107,111,110,118,101,120,16,
  116,97,98,98,97,114,95,118,101,114,116,95,102,97,99,101,7,15,102,97,
  100,101,104,111,114,122,99,111,110,99,97,118,101,20,116,97,98,98,97,114,
  95,118,101,114,116,95,116,97,98,95,102,97,99,101,7,14,102,97,100,101,
  118,101,114,116,107,111,110,118,101,120,13,109,97,105,110,109,101,110,117,95,
  102,97,99,101,7,15,102,97,100,101,118,101,114,116,99,111,110,99,97,118,
  101,4,108,101,102,116,2,24,3,116,111,112,2,72,0,0,9,116,102,97,
  99,101,99,111,109,112,13,102,97,100,101,99,111,110,116,97,105,110,101,114,
  23,116,101,109,112,108,97,116,101,46,102,97,100,101,95,112,111,115,46,99,
  111,117,110,116,2,2,23,116,101,109,112,108,97,116,101,46,102,97,100,101,
  95,112,111,115,46,105,116,101,109,115,1,5,0,0,0,0,0,0,0,0,
  0,0,5,0,0,0,0,0,0,0,128,255,63,0,25,116,101,109,112,108,
  97,116,101,46,102,97,100,101,95,99,111,108,111,114,46,99,111,117,110,116,
  2,2,25,116,101,109,112,108,97,116,101,46,102,97,100,101,95,99,111,108,
  111,114,46,105,116,101,109,115,1,4,5,0,0,160,4,204,204,204,0,0,
  4,108,101,102,116,3,144,0,3,116,111,112,2,72,0,0,9,116,102,97,
  99,101,99,111,109,112,8,110,117,108,108,102,97,99,101,4,108,101,102,116,
  3,16,1,3,116,111,112,2,16,0,0,14,116,115,121,115,101,110,118,109,
  97,110,97,103,101,114,6,115,121,115,101,110,118,4,108,101,102,116,2,24,
  3,116,111,112,2,96,0,0,0)
 );

initialization
 registerobjectdata(@objdata,tguitemplatesmo,'');
end.

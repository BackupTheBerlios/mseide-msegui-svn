unit actionsmodule_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface

implementation
uses
 mseclasses,actionsmodule;

const
 objdata: record size: integer; data: array[0..9625] of byte end =
      (size: 9626; data: (
  84,80,70,48,10,116,97,99,116,105,111,110,115,109,111,9,97,99,116,105,
  111,110,115,109,111,4,108,101,102,116,2,100,3,116,111,112,2,100,15,109,
  111,100,117,108,101,99,108,97,115,115,110,97,109,101,6,14,116,109,115,101,
  100,97,116,97,109,111,100,117,108,101,4,115,105,122,101,1,3,218,1,3,
  156,1,0,0,7,116,97,99,116,105,111,110,7,109,97,107,101,97,99,116,
  3,84,97,103,2,1,7,99,97,112,116,105,111,110,6,5,38,77,97,107,
  101,9,111,110,101,120,101,99,117,116,101,7,16,109,97,107,101,97,99,116,
  111,110,101,120,101,99,117,116,101,4,108,101,102,116,3,96,1,3,116,111,
  112,2,4,0,0,7,116,97,99,116,105,111,110,3,114,117,110,7,99,97,
  112,116,105,111,110,6,4,38,82,117,110,7,105,109,97,103,101,110,114,2,
  0,4,104,105,110,116,6,3,82,117,110,4,108,101,102,116,3,64,1,3,
  116,111,112,3,12,1,0,0,7,116,97,99,116,105,111,110,4,115,116,101,
  112,7,99,97,112,116,105,111,110,6,5,38,83,116,101,112,9,105,109,97,
  103,101,108,105,115,116,7,11,98,117,116,116,111,110,105,99,111,110,115,7,
  105,109,97,103,101,110,114,2,1,4,104,105,110,116,6,4,83,116,101,112,
  8,115,104,111,114,116,99,117,116,3,54,16,9,111,110,101,120,101,99,117,
  116,101,7,16,115,116,101,112,97,99,116,111,110,101,120,101,99,117,116,101,
  4,108,101,102,116,2,16,3,116,111,112,3,52,1,0,0,7,116,97,99,
  116,105,111,110,4,110,101,120,116,7,99,97,112,116,105,111,110,6,5,38,
  78,101,120,116,9,105,109,97,103,101,108,105,115,116,7,11,98,117,116,116,
  111,110,105,99,111,110,115,7,105,109,97,103,101,110,114,2,2,4,104,105,
  110,116,6,4,78,101,120,116,8,115,104,111,114,116,99,117,116,3,55,16,
  9,111,110,101,120,101,99,117,116,101,7,16,110,101,120,116,97,99,116,111,
  110,101,120,101,99,117,116,101,4,108,101,102,116,2,16,3,116,111,112,3,
  28,1,0,0,7,116,97,99,116,105,111,110,8,99,111,110,116,105,110,117,
  101,7,99,97,112,116,105,111,110,6,9,38,67,111,110,116,105,110,117,101,
  9,105,109,97,103,101,108,105,115,116,7,11,98,117,116,116,111,110,105,99,
  111,110,115,7,105,109,97,103,101,110,114,2,4,4,104,105,110,116,6,8,
  67,111,110,116,105,110,117,101,8,115,104,111,114,116,99,117,116,3,56,16,
  9,111,110,101,120,101,99,117,116,101,7,20,99,111,110,116,105,110,117,101,
  97,99,116,111,110,101,120,101,99,117,116,101,4,108,101,102,116,2,16,3,
  116,111,112,3,100,1,0,0,7,116,97,99,116,105,111,110,9,105,110,116,
  101,114,114,117,112,116,7,99,97,112,116,105,111,110,6,10,38,73,110,116,
  101,114,114,117,112,116,9,105,109,97,103,101,108,105,115,116,7,11,98,117,
  116,116,111,110,105,99,111,110,115,7,105,109,97,103,101,110,114,2,5,4,
  104,105,110,116,6,9,73,110,116,101,114,114,117,112,116,9,111,110,101,120,
  101,99,117,116,101,7,21,105,110,116,101,114,114,117,112,116,97,99,116,111,
  110,101,120,101,99,117,116,101,4,108,101,102,116,2,14,3,116,111,112,3,
  2,1,0,0,7,116,97,99,116,105,111,110,5,114,101,115,101,116,7,99,
  97,112,116,105,111,110,6,6,38,82,101,115,101,116,9,105,109,97,103,101,
  108,105,115,116,7,11,98,117,116,116,111,110,105,99,111,110,115,7,105,109,
  97,103,101,110,114,2,6,4,104,105,110,116,6,5,82,101,115,101,116,9,
  111,110,101,120,101,99,117,116,101,7,17,114,101,115,101,116,97,99,116,111,
  110,101,120,101,99,117,116,101,4,108,101,102,116,2,9,3,116,111,112,3,
  234,0,0,0,7,116,97,99,116,105,111,110,10,111,112,101,110,115,111,117,
  114,99,101,7,99,97,112,116,105,111,110,6,5,38,79,112,101,110,9,111,
  110,101,120,101,99,117,116,101,7,22,111,112,101,110,115,111,117,114,99,101,
  97,99,116,111,110,101,120,101,99,117,116,101,4,108,101,102,116,2,8,3,
  116,111,112,2,4,0,0,7,116,97,99,116,105,111,110,6,102,105,110,105,
  115,104,7,99,97,112,116,105,111,110,6,7,38,70,105,110,105,115,104,9,
  105,109,97,103,101,108,105,115,116,7,11,98,117,116,116,111,110,105,99,111,
  110,115,7,105,109,97,103,101,110,114,2,3,4,104,105,110,116,6,6,70,
  105,110,105,115,104,8,115,104,111,114,116,99,117,116,3,54,48,9,111,110,
  101,120,101,99,117,116,101,7,18,102,105,110,105,115,104,97,99,116,111,110,
  101,120,101,99,117,116,101,4,108,101,102,116,2,16,3,116,111,112,3,76,
  1,0,0,7,116,97,99,116,105,111,110,4,115,97,118,101,7,99,97,112,
  116,105,111,110,6,5,38,83,97,118,101,9,111,110,101,120,101,99,117,116,
  101,7,16,115,97,118,101,97,99,116,111,110,101,120,101,99,117,116,101,4,
  108,101,102,116,2,8,3,116,111,112,2,28,0,0,7,116,97,99,116,105,
  111,110,5,99,108,111,115,101,7,99,97,112,116,105,111,110,6,6,38,67,
  108,111,115,101,8,115,104,111,114,116,99,117,116,3,51,80,9,111,110,101,
  120,101,99,117,116,101,7,17,99,108,111,115,101,97,99,116,111,110,101,120,
  101,99,117,116,101,4,108,101,102,116,2,8,3,116,111,112,2,100,0,0,
  7,116,97,99,116,105,111,110,9,97,98,111,114,116,109,97,107,101,7,99,
  97,112,116,105,111,110,6,11,38,65,98,111,114,116,32,77,97,107,101,9,
  111,110,101,120,101,99,117,116,101,7,21,97,98,111,114,116,109,97,107,101,
  97,99,116,111,110,101,120,101,99,117,116,101,4,108,101,102,116,3,101,1,
  3,116,111,112,2,34,0,0,7,116,97,99,116,105,111,110,4,117,110,100,
  111,7,99,97,112,116,105,111,110,6,5,38,85,110,100,111,9,111,110,101,
  120,101,99,117,116,101,7,16,117,110,100,111,97,99,116,111,110,101,120,101,
  99,117,116,101,4,108,101,102,116,3,24,1,3,116,111,112,2,4,0,0,
  7,116,97,99,116,105,111,110,4,114,101,100,111,7,99,97,112,116,105,111,
  110,6,5,38,82,101,100,111,9,111,110,101,120,101,99,117,116,101,7,16,
  114,101,100,111,97,99,116,111,110,101,120,101,99,117,116,101,4,108,101,102,
  116,3,24,1,3,116,111,112,2,28,0,0,7,116,97,99,116,105,111,110,
  3,99,117,116,7,99,97,112,116,105,111,110,6,4,67,117,38,116,8,115,
  104,111,114,116,99,117,116,3,88,64,9,111,110,101,120,101,99,117,116,101,
  7,15,99,117,116,97,99,116,111,110,101,120,101,99,117,116,101,4,108,101,
  102,116,3,24,1,3,116,111,112,2,52,0,0,7,116,97,99,116,105,111,
  110,4,99,111,112,121,7,99,97,112,116,105,111,110,6,5,38,67,111,112,
  121,8,115,104,111,114,116,99,117,116,3,67,64,9,111,110,101,120,101,99,
  117,116,101,7,16,99,111,112,121,97,99,116,111,110,101,120,101,99,117,116,
  101,4,108,101,102,116,3,24,1,3,116,111,112,2,76,0,0,7,116,97,
  99,116,105,111,110,5,112,97,115,116,101,7,99,97,112,116,105,111,110,6,
  6,38,80,97,115,116,101,8,115,104,111,114,116,99,117,116,3,86,64,9,
  111,110,101,120,101,99,117,116,101,7,17,112,97,115,116,101,97,99,116,111,
  110,101,120,101,99,117,116,101,4,108,101,102,116,3,24,1,3,116,111,112,
  2,100,0,0,7,116,97,99,116,105,111,110,6,100,101,108,101,116,101,7,
  99,97,112,116,105,111,110,6,7,38,68,101,108,101,116,101,9,111,110,101,
  120,101,99,117,116,101,7,18,100,101,108,101,116,101,97,99,116,111,110,101,
  120,101,99,117,116,101,4,108,101,102,116,3,24,1,3,116,111,112,2,124,
  0,0,7,116,97,99,116,105,111,110,7,115,97,118,101,97,108,108,7,99,
  97,112,116,105,111,110,6,9,83,97,38,118,101,32,97,108,108,9,111,110,
  101,120,101,99,117,116,101,7,19,115,97,118,101,97,108,108,97,99,116,111,
  110,101,120,101,99,117,116,101,4,108,101,102,116,2,8,3,116,111,112,2,
  52,0,0,7,116,97,99,116,105,111,110,4,102,105,110,100,7,99,97,112,
  116,105,111,110,6,5,38,70,105,110,100,8,115,104,111,114,116,99,117,116,
  3,70,64,9,111,110,101,120,101,99,117,116,101,7,16,102,105,110,100,97,
  99,116,111,110,101,120,101,99,117,116,101,4,108,101,102,116,3,152,0,3,
  116,111,112,2,36,0,0,7,116,97,99,116,105,111,110,10,114,101,112,101,
  97,116,102,105,110,100,7,99,97,112,116,105,111,110,6,13,38,83,101,97,
  114,99,104,32,97,103,97,105,110,8,115,104,111,114,116,99,117,116,3,50,
  16,9,111,110,101,120,101,99,117,116,101,7,22,114,101,112,101,97,116,102,
  105,110,100,97,99,116,111,110,101,120,101,99,117,116,101,4,108,101,102,116,
  3,152,0,3,116,111,112,2,60,0,0,7,116,97,99,116,105,111,110,10,
  102,105,110,100,105,110,102,105,108,101,7,99,97,112,116,105,111,110,6,14,
  70,105,110,100,32,105,110,32,70,38,105,108,101,115,9,111,110,101,120,101,
  99,117,116,101,7,19,102,105,110,100,105,110,102,105,108,101,111,110,101,120,
  101,99,117,116,101,4,108,101,102,116,3,152,0,3,116,111,112,2,84,0,
  0,7,116,97,99,116,105,111,110,8,99,108,111,115,101,97,108,108,7,99,
  97,112,116,105,111,110,6,10,67,38,108,111,115,101,32,97,108,108,9,111,
  110,101,120,101,99,117,116,101,7,20,99,108,111,115,101,97,108,108,97,99,
  116,111,110,101,120,101,99,117,116,101,4,108,101,102,116,2,8,3,116,111,
  112,2,124,0,0,7,116,97,99,116,105,111,110,6,115,97,118,101,97,115,
  7,99,97,112,116,105,111,110,6,8,83,97,118,101,32,38,97,115,9,111,
  110,101,120,101,99,117,116,101,7,18,115,97,118,101,97,115,97,99,116,111,
  110,101,120,101,99,117,116,101,4,108,101,102,116,2,8,3,116,111,112,2,
  76,0,0,7,116,97,99,116,105,111,110,10,98,107,112,116,115,111,110,97,
  99,116,7,99,97,112,116,105,111,110,6,15,38,66,114,101,97,107,112,111,
  105,110,116,115,32,111,110,5,115,116,97,116,101,11,10,97,115,95,99,104,
  101,99,107,101,100,0,9,105,109,97,103,101,108,105,115,116,7,11,98,117,
  116,116,111,110,105,99,111,110,115,7,105,109,97,103,101,110,114,2,7,4,
  104,105,110,116,6,18,66,114,101,97,107,112,111,105,110,116,115,32,111,110,
  47,111,102,102,8,115,104,111,114,116,99,117,116,3,66,64,9,111,110,101,
  120,101,99,117,116,101,7,16,98,107,112,116,115,111,110,111,110,101,120,101,
  99,117,116,101,4,108,101,102,116,3,168,0,3,116,111,112,3,236,0,0,
  0,7,116,97,99,116,105,111,110,12,119,97,116,99,104,101,115,111,110,97,
  99,116,7,99,97,112,116,105,111,110,6,11,38,87,97,116,99,104,101,115,
  32,111,110,5,115,116,97,116,101,11,10,97,115,95,99,104,101,99,107,101,
  100,0,9,105,109,97,103,101,108,105,115,116,7,11,98,117,116,116,111,110,
  105,99,111,110,115,7,105,109,97,103,101,110,114,2,9,4,104,105,110,116,
  6,14,87,97,116,99,104,101,115,32,111,110,47,111,102,102,8,115,104,111,
  114,116,99,117,116,3,87,64,8,115,116,97,116,102,105,108,101,7,22,109,
  97,105,110,102,111,46,112,114,111,106,101,99,116,115,116,97,116,102,105,108,
  101,9,111,110,101,120,101,99,117,116,101,7,18,119,97,116,99,104,101,115,
  111,110,111,110,101,120,101,99,117,116,101,4,108,101,102,116,3,168,0,3,
  116,111,112,3,4,1,0,0,7,116,97,99,116,105,111,110,4,108,105,110,
  101,7,99,97,112,116,105,111,110,6,5,38,76,105,110,101,8,115,104,111,
  114,116,99,117,116,3,76,64,9,111,110,101,120,101,99,117,116,101,7,16,
  108,105,110,101,97,99,116,111,110,101,120,101,99,117,116,101,4,108,101,102,
  116,3,152,0,3,116,111,112,2,12,0,0,7,116,97,99,116,105,111,110,
  10,116,111,103,103,108,101,98,107,112,116,7,99,97,112,116,105,111,110,6,
  18,38,84,111,103,103,108,101,32,66,114,101,97,107,112,111,105,110,116,8,
  115,104,111,114,116,99,117,116,3,52,16,9,111,110,101,120,101,99,117,116,
  101,7,19,116,111,103,103,108,101,98,114,101,97,107,112,111,105,110,116,101,
  120,101,4,108,101,102,116,3,168,0,3,116,111,112,3,188,0,0,0,7,
  116,97,99,116,105,111,110,16,116,111,103,103,108,101,98,107,112,116,101,110,
  97,98,108,101,7,99,97,112,116,105,111,110,6,21,84,111,103,103,108,101,
  32,66,107,112,116,46,32,38,101,110,97,98,108,101,100,8,115,104,111,114,
  116,99,117,116,3,52,48,9,111,110,101,120,101,99,117,116,101,7,28,116,
  111,103,103,108,101,98,107,112,116,101,110,97,98,108,101,97,99,116,111,110,
  101,120,101,99,117,116,101,4,108,101,102,116,3,168,0,3,116,111,112,3,
  212,0,0,0,10,116,105,109,97,103,101,108,105,115,116,11,98,117,116,116,
  111,110,105,99,111,110,115,5,99,111,117,110,116,2,15,5,119,105,100,116,
  104,2,24,6,104,101,105,103,104,116,2,24,16,116,114,97,110,115,112,97,
  114,101,110,116,99,111,108,111,114,4,0,0,0,128,4,108,101,102,116,3,
  160,0,3,116,111,112,3,136,0,5,105,109,97,103,101,10,168,19,0,0,
  0,0,0,0,2,0,0,0,96,0,0,0,96,0,0,0,244,14,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,192,192,192,24,248,252,248,72,
  192,192,192,24,248,252,248,72,192,192,192,24,248,252,248,5,0,0,248,1,
  248,252,248,66,192,192,192,13,128,0,0,2,192,192,192,9,248,252,248,5,
  0,0,248,2,248,252,248,48,0,0,0,8,248,252,248,9,192,192,192,13,
  128,0,0,2,192,192,192,9,248,252,248,3,0,0,248,5,0,0,0,8,
  248,252,248,56,192,192,192,5,128,128,128,6,128,0,0,3,128,128,128,1,
  192,192,192,9,248,252,248,2,0,0,248,1,248,252,248,2,0,0,248,2,
  248,252,248,51,0,0,0,7,0,0,248,1,248,252,248,6,192,192,192,8,
  128,128,128,1,128,0,0,5,192,192,192,10,248,252,248,2,0,0,248,1,
  248,252,248,2,0,0,248,1,248,252,248,5,0,0,0,7,248,252,248,11,
  0,0,0,9,248,252,248,28,0,0,248,1,248,252,248,5,192,192,192,4,
  128,128,128,4,128,0,0,6,192,192,192,10,248,252,248,2,0,0,248,1,
  248,252,248,52,0,0,0,8,248,252,248,3,0,0,248,1,248,252,248,5,
  192,192,192,8,128,0,0,1,128,128,128,1,128,0,0,5,192,192,192,9,
  248,252,248,2,0,0,248,1,248,252,248,5,0,0,0,8,248,252,248,50,
  0,0,248,1,248,252,248,5,192,192,192,5,128,128,128,5,128,0,0,6,
  192,192,192,8,248,252,248,2,0,0,248,1,248,252,248,63,0,0,248,1,
  248,252,248,5,192,192,192,9,128,0,0,4,128,128,128,1,192,192,192,1,
  128,0,0,2,192,192,192,7,248,252,248,2,0,0,248,1,248,252,248,24,
  0,0,248,5,0,0,0,11,248,252,248,9,0,0,248,14,248,252,248,6,
  192,192,192,5,128,0,0,2,192,192,192,2,128,0,0,5,128,128,128,1,
  192,192,192,1,128,128,128,1,192,192,192,7,248,252,248,3,0,0,248,14,
  248,252,248,9,0,0,248,1,248,252,248,24,0,0,248,1,248,252,248,20,
  192,192,192,4,128,128,128,1,128,0,0,3,128,128,128,1,128,0,0,2,
  128,128,128,1,128,0,0,3,192,192,192,9,248,252,248,17,0,0,248,1,
  248,252,248,8,0,0,248,1,248,252,248,2,0,0,248,1,248,252,248,21,
  0,0,248,1,248,252,248,20,192,192,192,4,128,0,0,1,128,128,128,1,
  128,0,0,5,192,192,192,1,128,128,128,1,128,0,0,2,192,192,192,9,
  248,252,248,17,0,0,248,1,248,252,248,8,0,0,248,1,248,252,248,2,
  0,0,248,2,248,252,248,20,0,0,248,1,248,252,248,3,0,0,0,6,
  248,252,248,11,192,192,192,7,128,128,128,1,128,0,0,2,192,192,192,2,
  128,128,128,1,128,0,0,2,192,192,192,9,248,252,248,8,0,0,0,6,
  248,252,248,3,0,0,248,1,248,252,248,9,0,0,248,5,0,0,0,9,
  248,252,248,10,0,0,248,1,248,252,248,20,192,192,192,12,128,0,0,2,
  128,128,128,1,192,192,192,9,248,252,248,17,0,0,248,1,248,252,248,11,
  0,0,248,2,248,252,248,20,0,0,248,1,248,252,248,1,0,0,248,1,
  248,252,248,3,0,0,0,6,248,252,248,9,192,192,192,11,128,128,128,1,
  128,0,0,1,128,128,128,1,192,192,192,10,248,252,248,10,0,0,0,6,
  0,0,248,1,248,252,248,12,0,0,248,1,248,252,248,21,0,0,248,1,
  248,252,248,1,0,0,248,2,248,252,248,17,192,192,192,11,128,0,0,2,
  128,128,128,2,192,192,192,9,248,252,248,52,0,0,248,4,248,252,248,1,
  0,0,0,4,248,252,248,11,192,192,192,11,128,0,0,4,192,192,192,9,
  248,252,248,10,0,0,0,4,248,252,248,15,0,0,0,9,248,252,248,15,
  0,0,248,2,248,252,248,17,192,192,192,24,248,252,248,53,0,0,248,1,
  248,252,248,1,0,0,0,6,248,252,248,11,192,192,192,24,248,252,248,8,
  0,0,0,6,248,252,248,58,192,192,192,24,248,252,248,72,192,192,192,24,
  248,252,248,72,192,192,192,24,248,252,248,120,255,255,255,24,248,252,248,72,
  255,255,255,24,248,252,248,72,255,255,255,24,248,252,248,72,255,255,255,9,
  0,0,255,5,255,255,255,10,248,252,248,55,248,0,0,3,248,252,248,3,
  248,0,0,3,248,252,248,8,255,255,255,7,0,0,255,9,255,255,255,8,
  248,252,248,32,0,252,0,1,248,252,248,22,248,0,0,3,248,252,248,3,
  248,0,0,3,248,252,248,8,255,255,255,6,0,0,255,11,255,255,255,7,
  248,252,248,32,0,252,0,2,248,252,248,21,248,0,0,3,248,252,248,3,
  248,0,0,3,248,252,248,8,255,255,255,5,0,0,255,13,255,255,255,6,
  248,252,248,32,0,252,0,3,248,252,248,20,248,0,0,3,248,252,248,3,
  248,0,0,3,248,252,248,8,255,255,255,4,0,0,255,3,0,0,0,2,
  0,0,255,5,0,0,0,2,0,0,255,3,255,255,255,5,248,252,248,32,
  0,252,0,4,248,252,248,19,248,0,0,3,248,252,248,3,248,0,0,3,
  248,252,248,8,255,255,255,4,0,0,255,3,0,0,0,3,0,0,255,3,
  0,0,0,3,0,0,255,3,255,255,255,5,248,252,248,10,0,0,248,4,
  248,252,248,18,0,252,0,5,248,252,248,18,248,0,0,3,248,252,248,3,
  248,0,0,3,248,252,248,8,255,255,255,3,0,0,255,5,0,0,0,3,
  0,0,255,1,0,0,0,3,0,0,255,5,255,255,255,4,248,252,248,9,
  0,0,248,6,248,252,248,17,0,252,0,6,248,252,248,17,248,0,0,3,
  248,252,248,3,248,0,0,3,248,252,248,8,255,255,255,3,0,0,255,6,
  0,0,0,5,0,0,255,6,255,255,255,4,248,252,248,8,0,0,248,8,
  248,252,248,16,0,252,0,7,248,252,248,16,248,0,0,3,248,252,248,3,
  248,0,0,3,248,252,248,8,255,255,255,3,0,0,255,7,0,0,0,3,
  0,0,255,7,255,255,255,4,248,252,248,8,0,0,248,8,248,252,248,16,
  0,252,0,8,248,252,248,15,248,0,0,3,248,252,248,3,248,0,0,3,
  248,252,248,8,255,255,255,3,0,0,255,6,0,0,0,5,0,0,255,6,
  255,255,255,4,248,252,248,8,0,0,248,8,248,252,248,16,0,252,0,7,
  0,128,0,1,248,252,248,15,248,0,0,3,248,252,248,3,248,0,0,3,
  248,252,248,8,255,255,255,3,0,0,255,5,0,0,0,3,0,0,255,1,
  0,0,0,3,0,0,255,4,0,0,128,1,255,255,255,4,248,252,248,8,
  0,0,248,8,248,252,248,16,0,252,0,6,0,128,0,1,248,252,248,16,
  248,0,0,3,248,252,248,3,248,0,0,3,248,252,248,8,255,255,255,4,
  0,0,255,3,0,0,0,3,0,0,255,3,0,0,0,3,0,0,255,3,
  0,0,128,1,255,255,255,4,248,252,248,9,0,0,248,6,248,252,248,17,
  0,252,0,5,0,128,0,1,248,252,248,17,248,0,0,3,248,252,248,3,
  248,0,0,3,248,252,248,8,255,255,255,4,0,0,255,3,0,0,0,2,
  0,0,255,5,0,0,0,2,0,0,255,2,0,0,128,1,255,255,255,5,
  248,252,248,10,0,0,248,4,248,252,248,18,0,252,0,4,0,128,0,1,
  248,252,248,18,248,0,0,3,248,252,248,3,248,0,0,3,248,252,248,8,
  255,255,255,5,0,0,255,13,0,0,128,1,255,255,255,5,248,252,248,32,
  0,252,0,3,0,128,0,1,248,252,248,19,248,0,0,3,248,252,248,3,
  248,0,0,3,248,252,248,8,255,255,255,6,0,0,255,11,0,0,128,1,
  255,255,255,6,248,252,248,32,0,252,0,2,0,128,0,1,248,252,248,20,
  248,0,0,3,248,252,248,3,248,0,0,3,248,252,248,8,255,255,255,7,
  0,0,255,8,0,0,128,2,255,255,255,7,248,252,248,32,0,252,0,1,
  0,128,0,1,248,252,248,38,255,255,255,9,0,0,255,4,0,0,128,2,
  255,255,255,9,248,252,248,32,0,128,0,1,248,252,248,39,255,255,255,24,
  248,252,248,72,255,255,255,24,248,252,248,72,255,255,255,24,248,252,248,72,
  255,255,255,24,248,252,248,48,255,0,255,24,192,192,192,48,248,252,248,24,
  255,0,255,24,192,192,192,48,248,252,248,2,0,0,0,2,248,252,248,16,
  0,0,0,2,248,252,248,2,255,0,255,24,192,192,192,48,248,252,248,2,
  0,0,0,3,248,252,248,14,0,0,0,3,248,252,248,2,255,0,255,24,
  192,192,192,48,248,252,248,3,0,0,0,3,248,252,248,12,0,0,0,3,
  248,252,248,3,255,0,255,24,192,192,192,48,248,252,248,4,0,0,0,3,
  248,252,248,10,0,0,0,3,248,252,248,4,255,0,255,24,192,192,192,48,
  248,252,248,5,0,0,0,3,248,252,248,3,0,0,248,2,248,252,248,3,
  0,0,0,3,248,252,248,5,255,0,255,24,192,192,192,48,248,252,248,6,
  0,0,0,3,0,0,248,6,0,0,0,3,248,252,248,6,255,0,255,5,
  0,0,0,3,255,0,255,3,0,0,0,3,255,0,255,3,0,0,0,3,
  255,0,255,4,192,192,192,11,0,0,248,2,192,192,192,23,0,0,248,1,
  192,192,192,11,248,252,248,7,0,0,0,3,0,0,248,4,0,0,0,3,
  248,252,248,7,255,0,255,4,0,0,0,1,255,0,255,3,0,0,0,1,
  255,0,255,1,0,0,0,1,255,0,255,3,0,0,0,1,255,0,255,1,
  0,0,0,1,255,0,255,3,0,0,0,1,255,0,255,3,192,192,192,11,
  0,0,248,2,192,192,192,23,0,0,248,1,192,192,192,11,248,252,248,7,
  0,0,248,1,0,0,0,3,0,0,248,2,0,0,0,3,0,0,248,1,
  248,252,248,7,255,0,255,4,0,0,0,1,255,0,255,3,0,0,0,1,
  255,0,255,1,0,0,0,1,255,0,255,3,0,0,0,1,255,0,255,1,
  0,0,0,1,255,0,255,3,0,0,0,1,255,0,255,3,192,192,192,11,
  0,0,248,2,192,192,192,23,0,0,248,1,192,192,192,11,248,252,248,7,
  0,0,248,2,0,0,0,6,0,0,248,2,248,252,248,7,255,0,255,8,
  0,0,0,1,255,0,255,5,0,0,0,1,255,0,255,5,0,0,0,1,
  255,0,255,3,192,192,192,11,0,0,248,2,192,192,192,23,0,0,248,1,
  192,192,192,11,248,252,248,6,0,0,248,4,0,0,0,4,0,0,248,4,
  248,252,248,6,255,0,255,7,0,0,0,1,255,0,255,5,0,0,0,1,
  255,0,255,5,0,0,0,1,255,0,255,4,192,192,192,11,0,0,248,2,
  192,192,192,23,0,0,248,1,192,192,192,11,248,252,248,6,0,0,248,4,
  0,0,0,4,0,0,248,4,248,252,248,6,255,0,255,6,0,0,0,1,
  255,0,255,5,0,0,0,1,255,0,255,5,0,0,0,1,255,0,255,5,
  192,192,192,11,0,0,248,2,192,192,192,23,0,0,248,1,192,192,192,11,
  248,252,248,7,0,0,248,2,0,0,0,6,0,0,248,2,248,252,248,7,
  255,0,255,5,0,0,0,1,255,0,255,5,0,0,0,1,255,0,255,5,
  0,0,0,1,255,0,255,6,192,192,192,11,0,0,248,2,192,192,192,23,
  0,0,248,1,192,192,192,11,248,252,248,7,0,0,248,1,0,0,0,3,
  0,0,248,2,0,0,0,3,0,0,248,1,248,252,248,7,255,0,255,5,
  0,0,0,1,255,0,255,5,0,0,0,1,255,0,255,5,0,0,0,1,
  255,0,255,6,192,192,192,36,0,0,248,1,192,192,192,11,248,252,248,7,
  0,0,0,3,0,0,248,4,0,0,0,3,248,252,248,7,255,0,255,24,
  192,192,192,48,248,252,248,6,0,0,0,3,0,0,248,6,0,0,0,3,
  248,252,248,6,255,0,255,5,0,0,0,1,255,0,255,5,0,0,0,1,
  255,0,255,5,0,0,0,1,255,0,255,6,192,192,192,11,0,0,248,2,
  192,192,192,23,0,0,248,1,192,192,192,11,248,252,248,5,0,0,0,3,
  248,252,248,3,0,0,248,2,248,252,248,3,0,0,0,3,248,252,248,5,
  255,0,255,24,192,192,192,11,0,0,248,2,192,192,192,35,248,252,248,4,
  0,0,0,3,248,252,248,10,0,0,0,3,248,252,248,4,255,0,255,24,
  192,192,192,48,248,252,248,3,0,0,0,3,248,252,248,12,0,0,0,3,
  248,252,248,3,255,0,255,24,192,192,192,48,248,252,248,2,0,0,0,3,
  248,252,248,14,0,0,0,3,248,252,248,2,255,0,255,24,192,192,192,48,
  248,252,248,2,0,0,0,2,248,252,248,16,0,0,0,2,248,252,248,2,
  255,0,255,24,192,192,192,48,248,252,248,24,255,0,255,24,192,192,192,48,
  248,252,248,24,255,0,255,24,192,192,192,48,248,252,248,72,255,0,255,24,
  248,252,248,72,255,0,255,24,248,252,248,5,0,0,248,1,248,252,248,66,
  255,0,255,24,248,252,248,5,0,0,248,2,248,252,248,65,255,0,255,24,
  248,252,248,3,0,0,248,5,0,0,0,8,248,252,248,56,255,0,255,24,
  248,252,248,2,0,0,248,1,248,252,248,2,0,0,248,2,248,252,248,65,
  255,0,255,24,248,252,248,2,0,0,248,1,248,252,248,2,0,0,248,1,
  248,252,248,5,0,0,0,7,248,252,248,11,0,0,0,9,248,252,248,34,
  255,0,255,5,0,0,0,3,255,0,255,3,0,0,0,3,255,0,255,3,
  0,0,0,3,255,0,255,4,248,252,248,2,0,0,248,1,248,252,248,69,
  255,0,255,4,0,0,0,1,255,0,255,3,0,0,0,1,255,0,255,1,
  0,0,0,1,255,0,255,3,0,0,0,1,255,0,255,1,0,0,0,1,
  255,0,255,3,0,0,0,1,255,0,255,3,248,252,248,2,0,0,248,1,
  248,252,248,5,0,0,0,8,248,252,248,56,255,0,255,4,0,0,0,1,
  255,0,255,3,0,0,0,1,255,0,255,1,0,0,0,1,255,0,255,3,
  0,0,0,1,255,0,255,1,0,0,0,1,255,0,255,3,0,0,0,1,
  255,0,255,3,248,252,248,2,0,0,248,1,248,252,248,55,248,0,0,4,
  248,252,248,10,255,0,255,8,0,0,0,1,255,0,255,5,0,0,0,1,
  255,0,255,5,0,0,0,1,255,0,255,3,248,252,248,2,0,0,248,1,
  248,252,248,24,0,0,248,5,0,0,0,11,248,252,248,14,248,0,0,2,
  248,252,0,1,248,0,0,3,248,252,248,9,255,0,255,7,0,0,0,1,
  255,0,255,5,0,0,0,1,255,0,255,5,0,0,0,1,255,0,255,4,
  248,252,248,3,0,0,248,14,248,252,248,9,0,0,248,1,248,252,248,30,
  248,0,0,1,248,252,0,2,248,0,0,3,248,252,248,9,255,0,255,6,
  0,0,0,1,255,0,255,5,0,0,0,1,255,0,255,5,0,0,0,1,
  255,0,255,5,248,252,248,17,0,0,248,1,248,252,248,3,0,0,248,1,
  248,252,248,4,0,0,248,1,248,252,248,2,0,0,248,1,248,252,248,15,
  0,0,248,1,248,252,248,11,248,0,0,6,248,252,248,9,255,0,255,5,
  0,0,0,1,255,0,255,5,0,0,0,1,255,0,255,5,0,0,0,1,
  255,0,255,6,248,252,248,17,0,0,248,1,248,252,248,8,0,0,248,1,
  248,252,248,2,0,0,248,2,248,252,248,26,248,0,0,6,248,252,248,9,
  255,0,255,5,0,0,0,1,255,0,255,5,0,0,0,1,255,0,255,5,
  0,0,0,1,255,0,255,6,248,252,248,8,0,0,0,6,248,252,248,3,
  0,0,248,1,248,252,248,9,0,0,248,5,0,0,0,9,248,252,248,17,
  248,0,0,4,248,252,248,10,255,0,255,24,248,252,248,17,0,0,248,1,
  248,252,248,3,0,0,248,1,248,252,248,7,0,0,248,2,248,252,248,14,
  0,0,248,1,248,252,248,26,255,0,255,5,0,0,0,1,255,0,255,5,
  0,0,0,1,255,0,255,5,0,0,0,1,255,0,255,6,248,252,248,10,
  0,0,0,6,0,0,248,1,248,252,248,4,0,0,248,1,248,252,248,7,
  0,0,248,1,248,252,248,15,0,0,248,1,248,252,248,26,255,0,255,24,
  248,252,248,21,0,0,248,1,248,252,248,23,0,0,248,1,248,252,248,26,
  255,0,255,24,248,252,248,10,0,0,0,4,248,252,248,7,0,0,248,1,
  248,252,248,7,0,0,0,9,248,252,248,7,0,0,248,1,248,252,248,26,
  255,0,255,24,248,252,248,21,0,0,248,1,248,252,248,23,0,0,248,1,
  248,252,248,26,255,0,255,24,248,252,248,8,0,0,0,6,248,252,248,7,
  0,0,248,1,248,252,248,23,0,0,248,1,248,252,248,26,255,0,255,24,
  248,252,248,21,0,0,248,1,248,252,248,23,0,0,248,1,248,252,248,26,
  255,0,255,24,248,252,248,72,255,0,255,24,248,252,248,72,255,0,255,24,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,32,0,0,0,0,0,0,0,0,0,96,0,96,
  0,0,0,0,0,128,127,0,0,96,0,248,255,0,0,0,0,0,0,0,
  224,127,0,100,0,0,0,0,0,0,252,3,0,63,0,36,248,3,224,63,
  0,0,0,4,240,63,0,4,0,0,0,0,0,128,127,4,0,127,0,4,
  255,0,0,0,0,0,0,4,224,255,0,4,0,0,0,0,0,0,0,4,
  0,190,1,4,0,0,248,255,7,240,255,3,96,126,1,248,255,1,4,0,
  0,8,0,0,240,127,0,0,0,2,36,0,0,8,0,0,240,119,0,0,
  0,2,100,0,0,136,31,0,128,115,0,0,63,2,248,255,1,8,0,0,
  0,112,0,0,0,2,96,0,0,40,126,0,0,56,0,0,252,1,32,0,
  0,104,0,0,0,120,0,0,0,0,0,0,0,240,30,0,0,120,0,0,
  60,0,224,63,0,96,0,0,0,0,0,0,0,0,0,0,0,160,31,0,
  0,0,0,0,63,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,62,0,0,0,0,0,0,0,128,
  227,0,128,255,0,0,0,0,0,1,0,128,227,0,192,255,1,0,0,0,
  0,3,0,128,227,0,224,255,3,0,0,0,0,7,0,128,227,0,240,255,
  7,0,0,0,0,15,0,128,227,0,240,255,7,0,60,0,0,31,0,128,
  227,0,248,255,15,0,126,0,0,63,0,128,227,0,248,255,15,0,255,0,
  0,127,0,128,227,0,248,255,15,0,255,0,0,255,0,128,227,0,248,255,
  15,0,255,0,0,255,0,128,227,0,248,255,15,0,255,0,0,127,0,128,
  227,0,240,255,15,0,126,0,0,63,0,128,227,0,240,255,7,0,60,0,
  0,31,0,128,227,0,224,255,7,0,0,0,0,15,0,128,227,0,192,255,
  3,0,0,0,0,7,0,128,227,0,128,255,1,0,0,0,0,3,0,0,
  0,0,0,126,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  12,0,48,0,0,0,0,0,0,0,0,0,28,0,56,0,0,0,0,0,
  0,0,0,0,56,0,28,0,0,0,0,0,0,0,0,0,112,0,14,0,
  0,0,0,0,0,0,0,0,224,24,7,0,0,0,0,0,0,0,0,0,
  192,255,3,224,56,14,0,24,0,0,16,0,128,255,1,16,69,17,0,24,
  0,0,16,0,128,255,1,16,69,17,0,24,0,0,16,0,128,255,1,0,
  65,16,0,24,0,0,16,0,192,255,3,128,32,8,0,24,0,0,16,0,
  192,255,3,64,16,4,0,24,0,0,16,0,128,255,1,32,8,2,0,24,
  0,0,16,0,128,255,1,32,8,2,0,0,0,0,16,0,128,255,1,0,
  0,0,0,0,0,0,0,0,192,255,3,32,8,2,0,24,0,0,16,0,
  224,24,7,0,0,0,0,24,0,0,0,0,112,0,14,0,0,0,0,0,
  0,0,0,0,56,0,28,0,0,0,0,0,0,0,0,0,28,0,56,0,
  0,0,0,0,0,0,0,0,12,0,48,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,32,0,0,0,0,0,0,0,0,0,0,0,
  96,0,0,0,0,0,0,0,0,0,0,0,248,255,0,0,0,0,0,0,
  0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,36,248,3,224,
  63,0,0,0,0,224,56,14,4,0,0,0,0,0,0,0,0,16,69,17,
  4,255,0,0,0,0,0,0,0,16,69,17,4,0,0,0,0,0,0,60,
  0,0,65,16,4,0,0,248,255,7,0,126,0,128,32,8,248,255,1,4,
  0,0,0,126,0,64,16,4,0,0,34,36,0,32,0,126,0,32,8,2,
  0,0,2,100,0,0,0,126,0,32,8,2,0,63,2,248,255,1,0,60,
  0,0,0,0,0,0,34,96,0,32,0,0,0,32,8,2,0,252,33,32,
  0,32,0,0,0,0,0,0,0,0,32,0,0,32,0,0,0,0,0,0,
  0,60,32,224,63,32,0,0,0,0,0,0,0,0,32,0,0,32,0,0,
  0,0,0,0,0,63,32,0,0,32,0,0,0,0,0,0,0,0,32,0,
  0,32,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,116,97,99,116,105,
  111,110,14,115,101,108,101,99,116,101,100,105,116,112,97,103,101,7,99,97,
  112,116,105,111,110,6,11,83,101,108,101,99,116,32,80,97,103,101,8,115,
  104,111,114,116,99,117,116,3,83,64,7,111,112,116,105,111,110,115,11,17,
  97,111,95,103,108,111,98,97,108,115,104,111,114,116,99,117,116,0,9,111,
  110,101,120,101,99,117,116,101,7,23,115,101,108,101,99,116,101,100,105,116,
  112,97,103,101,111,110,101,120,101,99,117,116,101,4,108,101,102,116,3,152,
  0,3,116,111,112,3,160,0,0,0,7,116,97,99,116,105,111,110,6,105,
  110,100,101,110,116,7,99,97,112,116,105,111,110,6,7,38,73,110,100,101,
  110,116,8,115,104,111,114,116,99,117,116,3,73,64,9,111,110,101,120,101,
  99,117,116,101,7,15,105,110,100,101,110,116,111,110,101,120,101,99,117,116,
  101,4,108,101,102,116,3,24,1,3,116,111,112,3,176,0,0,0,7,116,
  97,99,116,105,111,110,8,117,110,105,110,100,101,110,116,7,99,97,112,116,
  105,111,110,6,9,85,38,110,105,110,100,101,110,116,8,115,104,111,114,116,
  99,117,116,3,85,64,9,111,110,101,120,101,99,117,116,101,7,17,117,110,
  105,110,100,101,110,116,111,110,101,120,101,99,117,116,101,4,108,101,102,116,
  3,24,1,3,116,111,112,3,200,0,0,0,7,116,97,99,116,105,111,110,
  14,116,111,103,103,108,101,102,111,114,109,117,110,105,116,7,99,97,112,116,
  105,111,110,6,17,84,111,103,103,108,101,32,70,111,114,109,47,38,85,110,
  105,116,8,115,104,111,114,116,99,117,116,3,59,16,9,111,110,101,120,101,
  99,117,116,101,7,23,116,111,103,103,108,101,102,111,114,109,117,110,105,116,
  111,110,101,120,101,99,117,116,101,4,108,101,102,116,3,152,0,3,116,111,
  112,2,112,0,0,7,116,97,99,116,105,111,110,5,110,101,120,116,105,7,
  99,97,112,116,105,111,110,6,16,78,101,120,116,32,105,110,115,116,114,117,
  99,116,105,111,110,9,105,109,97,103,101,108,105,115,116,7,11,98,117,116,
  116,111,110,105,99,111,110,115,7,105,109,97,103,101,110,114,2,13,8,115,
  104,111,114,116,99,117,116,3,55,112,9,111,110,101,120,101,99,117,116,101,
  7,17,110,101,120,116,105,97,99,116,111,110,101,120,101,99,117,116,101,4,
  108,101,102,116,2,72,3,116,111,112,3,24,1,0,0,7,116,97,99,116,
  105,111,110,5,115,116,101,112,105,7,99,97,112,116,105,111,110,6,16,83,
  116,101,112,32,105,110,115,116,114,117,99,116,105,111,110,9,105,109,97,103,
  101,108,105,115,116,7,11,98,117,116,116,111,110,105,99,111,110,115,7,105,
  109,97,103,101,110,114,2,12,8,115,104,111,114,116,99,117,116,3,54,112,
  9,111,110,101,120,101,99,117,116,101,7,17,115,116,101,112,105,97,99,116,
  111,110,101,120,101,99,117,116,101,4,108,101,102,116,2,72,3,116,111,112,
  3,48,1,0,0,7,116,97,99,116,105,111,110,13,98,108,117,101,100,111,
  116,115,111,110,97,99,116,7,99,97,112,116,105,111,110,6,17,69,120,101,
  99,32,108,105,110,101,32,104,105,110,116,32,111,110,5,115,116,97,116,101,
  11,10,97,115,95,99,104,101,99,107,101,100,0,9,105,109,97,103,101,108,
  105,115,116,7,11,98,117,116,116,111,110,105,99,111,110,115,7,105,109,97,
  103,101,110,114,2,14,4,104,105,110,116,6,28,69,120,101,99,117,116,97,
  98,108,101,32,108,105,110,101,115,32,104,105,110,116,32,111,110,47,111,102,
  102,8,115,116,97,116,102,105,108,101,7,22,109,97,105,110,102,111,46,112,
  114,111,106,101,99,116,115,116,97,116,102,105,108,101,8,111,110,99,104,97,
  110,103,101,7,18,98,108,117,101,100,111,116,115,111,110,111,110,99,104,97,
  110,103,101,4,108,101,102,116,3,168,0,3,116,111,112,3,24,1,0,0,
  7,116,97,99,116,105,111,110,7,114,101,112,108,97,99,101,7,99,97,112,
  116,105,111,110,6,16,70,105,110,100,32,38,38,32,38,114,101,112,108,97,
  99,101,9,111,110,101,120,101,99,117,116,101,7,19,114,101,112,108,97,99,
  101,97,99,116,111,110,101,120,101,99,117,116,101,4,108,101,102,116,3,208,
  0,3,116,111,112,2,32,0,0,7,116,97,99,116,105,111,110,5,112,114,
  105,110,116,7,99,97,112,116,105,111,110,6,6,38,80,114,105,110,116,9,
  111,110,101,120,101,99,117,116,101,7,17,112,114,105,110,116,97,99,116,111,
  110,101,120,101,99,117,116,101,4,108,101,102,116,2,80,3,116,111,112,2,
  40,0,0,7,116,97,99,116,105,111,110,12,100,101,116,97,99,104,116,97,
  114,103,101,116,7,99,97,112,116,105,111,110,6,6,68,101,116,97,99,104,
  9,111,110,101,120,101,99,117,116,101,7,14,111,110,100,101,116,97,99,104,
  116,97,114,103,101,116,4,108,101,102,116,2,8,3,116,111,112,3,168,0,
  0,0,7,116,97,99,116,105,111,110,13,97,116,116,97,99,104,112,114,111,
  99,101,115,115,7,99,97,112,116,105,111,110,6,14,65,116,116,97,99,104,
  32,80,114,111,99,101,115,115,9,111,110,101,120,101,99,117,116,101,7,15,
  111,110,97,116,116,97,99,104,112,114,111,99,101,115,115,4,108,101,102,116,
  2,8,3,116,111,112,3,192,0,0,0,7,116,97,99,116,105,111,110,9,
  108,111,119,101,114,99,97,115,101,7,99,97,112,116,105,111,110,6,9,76,
  111,119,101,114,99,97,115,101,9,111,110,101,120,101,99,117,116,101,7,16,
  108,111,119,101,114,99,97,115,101,101,120,101,99,117,116,101,8,111,110,117,
  112,100,97,116,101,7,14,101,110,97,98,108,101,111,110,115,101,108,101,99,
  116,4,108,101,102,116,3,104,1,3,116,111,112,3,176,0,0,0,7,116,
  97,99,116,105,111,110,9,117,112,112,101,114,99,97,115,101,7,99,97,112,
  116,105,111,110,6,9,85,112,112,101,114,99,97,115,101,9,111,110,101,120,
  101,99,117,116,101,7,16,117,112,112,101,114,99,97,115,101,101,120,101,99,
  117,116,101,8,111,110,117,112,100,97,116,101,7,14,101,110,97,98,108,101,
  111,110,115,101,108,101,99,116,4,108,101,102,116,3,104,1,3,116,111,112,
  3,200,0,0,0,0)
 );

initialization
 registerobjectdata(@objdata,tactionsmo,'');
end.

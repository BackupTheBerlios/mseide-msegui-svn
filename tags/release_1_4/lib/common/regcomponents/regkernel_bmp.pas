unit regkernel_bmp;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface

implementation
uses
 mseclasses,msebitmap;

const
 objdata_taction: record size: integer; data: array[0..259] of byte end =
      (size: 260; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,7,116,97,99,
  116,105,111,110,12,98,105,116,109,97,112,46,105,109,97,103,101,10,216,0,
  0,0,0,0,0,0,0,0,0,0,24,0,0,0,24,0,0,0,164,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,0,255,87,0,0,
  255,2,255,0,255,20,0,0,255,2,255,0,255,19,0,0,255,3,255,0,
  255,19,0,0,255,2,255,0,255,20,0,0,255,2,255,0,255,23,0,0,
  255,2,255,0,255,24,0,0,255,2,255,0,255,24,0,0,255,2,255,0,
  255,24,0,0,255,2,255,0,255,21,0,0,255,2,255,0,255,21,0,0,
  255,1,255,0,255,17,0,0,255,1,255,0,255,3,0,0,255,2,255,0,
  255,18,0,0,255,1,255,0,255,2,0,0,255,1,255,0,255,19,0,0,
  255,1,255,0,255,1,0,0,255,2,255,0,255,20,0,0,255,2,255,0,
  255,1,0,0,255,3,255,0,255,18,0,0,255,3,255,0,255,137,0,0)
 );

const
 objdata_timagelist: record size: integer; data: array[0..762] of byte end =
      (size: 763; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,10,116,105,109,
  97,103,101,108,105,115,116,12,98,105,116,109,97,112,46,105,109,97,103,101,
  10,204,2,0,0,0,0,0,0,0,0,0,0,24,0,0,0,24,0,0,
  0,152,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,0,255,
  5,128,128,128,19,255,0,255,5,128,128,128,1,255,255,0,17,0,0,0,
  1,255,0,255,3,128,128,128,19,255,255,0,1,0,0,0,1,255,0,255,
  3,128,128,128,1,255,255,0,17,0,0,0,1,255,255,0,1,0,0,0,
  1,255,0,255,1,128,128,128,19,255,255,0,1,0,0,0,1,255,255,0,
  1,0,0,0,1,255,0,255,1,128,128,128,1,255,255,0,17,0,0,0,
  1,255,255,0,1,0,0,0,1,255,255,0,1,0,0,0,1,255,0,255,
  1,128,128,128,1,255,255,0,17,0,0,0,1,255,255,0,1,0,0,0,
  1,255,255,0,1,0,0,0,1,255,0,255,1,128,128,128,1,255,255,0,
  17,0,0,0,1,255,255,0,1,0,0,0,1,255,255,0,1,0,0,0,
  1,255,0,255,1,128,128,128,1,255,255,0,4,0,255,255,2,255,255,0,
  11,0,0,0,1,255,255,0,1,0,0,0,1,0,128,0,1,0,0,0,
  1,255,0,255,1,128,128,128,1,255,255,0,3,0,255,255,4,255,255,0,
  10,0,0,0,1,255,255,0,1,0,0,0,1,0,128,0,1,0,0,0,
  1,255,0,255,1,128,128,128,1,255,255,0,3,0,255,255,4,255,255,0,
  10,0,0,0,1,0,128,0,1,0,0,0,1,0,128,0,1,0,0,0,
  1,255,0,255,1,128,128,128,1,255,255,0,4,0,255,255,2,255,255,0,
  11,0,0,0,1,0,128,0,1,0,0,0,1,0,128,0,1,0,0,0,
  1,255,0,255,1,128,128,128,1,255,255,0,16,0,128,0,1,0,0,0,
  1,0,128,0,1,0,0,0,1,0,128,0,1,0,0,0,1,255,0,255,
  1,128,128,128,1,255,255,0,14,0,128,0,3,0,0,0,1,0,128,0,
  1,0,0,0,1,0,128,0,1,0,0,0,1,255,0,255,1,128,128,128,
  1,255,255,0,13,0,128,0,4,0,0,0,1,0,128,0,1,0,0,0,
  1,0,128,0,1,0,0,0,1,255,0,255,1,128,128,128,1,255,255,0,
  11,0,128,0,6,0,0,0,1,0,128,0,1,0,0,0,1,0,128,0,
  1,0,0,0,1,255,0,255,1,128,128,128,1,255,255,0,10,0,128,0,
  7,0,0,0,1,0,128,0,1,0,0,0,1,0,128,0,1,0,0,0,
  1,255,0,255,1,128,128,128,1,255,0,0,11,0,128,0,6,0,0,0,
  1,0,128,0,1,0,0,0,1,255,0,0,1,0,0,0,1,255,0,255,
  1,128,128,128,1,255,0,0,13,0,128,0,4,0,0,0,1,0,128,0,
  1,0,0,0,3,255,0,255,1,128,128,128,1,255,0,0,14,0,128,0,
  3,0,0,0,1,255,0,0,1,0,0,0,1,255,0,255,3,128,128,128,
  1,255,0,0,16,0,128,0,1,0,0,0,3,255,0,255,3,128,128,128,
  1,255,0,0,17,0,0,0,1,255,0,255,5,0,0,0,19,255,0,255,
  28,0,0)
 );

const
 objdata_tstatfile: record size: integer; data: array[0..357] of byte end =
      (size: 358; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,9,116,115,116,
  97,116,102,105,108,101,12,98,105,116,109,97,112,46,105,109,97,103,101,10,
  56,1,0,0,0,0,0,0,0,0,0,0,24,0,0,0,24,0,0,0,
  4,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,0,255,230,
  0,0,0,1,255,0,255,23,0,0,0,1,255,0,255,11,0,0,0,1,
  255,0,255,6,0,0,0,3,255,0,255,1,0,0,0,3,255,0,255,2,
  0,0,0,3,255,0,255,4,0,0,0,3,255,0,255,4,0,0,0,1,
  255,0,255,3,0,0,0,1,255,0,255,1,0,0,0,1,255,0,255,2,
  0,0,0,1,255,0,255,3,0,0,0,1,255,0,255,4,0,0,0,1,
  255,0,255,6,0,0,0,2,255,0,255,3,0,0,0,1,255,0,255,3,
  0,0,0,4,255,0,255,3,0,0,0,1,255,0,255,1,0,0,0,1,
  255,0,255,7,0,0,0,1,255,0,255,2,0,0,0,1,255,0,255,2,
  0,0,0,1,255,0,255,3,0,0,0,1,255,0,255,10,0,0,0,1,
  255,0,255,3,0,0,0,1,255,0,255,1,0,0,0,1,255,0,255,2,
  0,0,0,1,255,0,255,2,0,0,0,2,255,0,255,8,0,0,0,1,
  255,0,255,2,0,0,0,3,255,0,255,2,0,0,0,2,255,0,255,2,
  0,0,0,2,255,0,255,1,0,0,0,1,255,0,255,170,0,0)
 );

const
 objdata_tbitmapcomp: record size: integer; data: array[0..691] of byte end =
      (size: 692; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,11,116,98,105,
  116,109,97,112,99,111,109,112,12,98,105,116,109,97,112,46,105,109,97,103,
  101,10,132,2,0,0,0,0,0,0,0,0,0,0,24,0,0,0,24,0,
  0,0,80,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,192,192,
  192,25,0,0,0,1,192,192,192,2,0,0,0,2,192,192,192,2,0,0,
  0,2,192,192,192,2,0,0,0,2,192,192,192,2,0,0,0,2,192,192,
  192,2,0,0,0,2,192,192,192,29,128,128,128,18,192,192,192,1,0,0,
  0,1,192,192,192,2,0,0,0,1,192,192,192,1,128,128,128,1,255,255,
  0,16,0,0,0,1,192,192,192,1,0,0,0,1,192,192,192,2,0,0,
  0,1,192,192,192,1,128,128,128,1,255,255,0,16,0,0,0,1,192,192,
  192,6,128,128,128,1,255,255,0,3,0,255,255,2,255,255,0,11,0,0,
  0,1,192,192,192,6,128,128,128,1,255,255,0,2,0,255,255,4,255,255,
  0,10,0,0,0,1,192,192,192,1,0,0,0,1,192,192,192,4,128,128,
  128,1,255,255,0,2,0,255,255,4,255,255,0,10,0,0,0,1,192,192,
  192,1,0,0,0,1,192,192,192,2,0,0,0,1,192,192,192,1,128,128,
  128,1,255,255,0,3,0,255,255,2,255,255,0,11,0,0,0,1,192,192,
  192,4,0,0,0,1,192,192,192,1,128,128,128,1,255,255,0,15,0,128,
  0,1,0,0,0,1,192,192,192,6,128,128,128,1,255,255,0,13,0,128,
  0,3,0,0,0,1,192,192,192,1,0,0,0,1,192,192,192,4,128,128,
  128,1,255,255,0,12,0,128,0,4,0,0,0,1,192,192,192,1,0,0,
  0,1,192,192,192,2,0,0,0,1,192,192,192,1,128,128,128,1,255,255,
  0,10,0,128,0,6,0,0,0,1,192,192,192,4,0,0,0,1,192,192,
  192,1,128,128,128,1,255,255,0,9,0,128,0,7,0,0,0,1,192,192,
  192,6,128,128,128,1,255,0,0,10,0,128,0,6,0,0,0,1,192,192,
  192,1,0,0,0,1,192,192,192,4,128,128,128,1,255,0,0,12,0,128,
  0,4,0,0,0,1,192,192,192,1,0,0,0,1,192,192,192,2,0,0,
  0,1,192,192,192,1,128,128,128,1,255,0,0,13,0,128,0,3,0,0,
  0,1,192,192,192,4,0,0,0,1,192,192,192,1,128,128,128,1,255,0,
  0,15,0,128,0,1,0,0,0,1,192,192,192,6,128,128,128,1,255,0,
  0,16,0,0,0,1,192,192,192,1,0,0,0,1,192,192,192,4,0,0,
  0,18,192,192,192,1,0,0,0,1,192,192,192,2,0,0,0,1,192,192,
  192,23,0,0,0,1,192,192,192,2,0,0,0,2,192,192,192,2,0,0,
  0,2,192,192,192,2,0,0,0,2,192,192,192,2,0,0,0,2,192,192,
  192,2,0,0,0,2,192,192,192,26,0,0)
 );

const
 objdata_ttimer: record size: integer; data: array[0..594] of byte end =
      (size: 595; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,6,116,116,105,
  109,101,114,12,98,105,116,109,97,112,46,105,109,97,103,101,10,40,2,0,
  0,0,0,0,0,0,0,0,0,24,0,0,0,24,0,0,0,244,1,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,255,0,255,35,0,128,128,
  2,255,0,255,15,0,255,255,4,255,0,255,2,0,128,128,3,255,0,255,
  3,0,255,255,4,255,0,255,6,0,255,255,3,255,255,255,1,0,255,255,
  1,255,0,255,3,0,128,128,2,255,0,255,5,0,255,255,2,255,255,255,
  1,0,255,255,2,255,0,255,4,0,255,255,4,255,0,255,6,0,128,128,
  1,255,0,255,5,0,255,255,4,255,0,255,3,0,255,255,4,255,0,255,
  7,0,128,128,1,255,0,255,6,0,255,255,2,255,255,255,1,0,255,255,
  1,255,0,255,2,0,255,255,3,255,0,255,1,0,128,128,1,255,0,255,
  3,0,0,255,6,255,0,255,3,0,128,128,1,255,0,255,1,0,255,255,
  3,255,0,255,2,0,255,255,2,255,0,255,3,0,128,128,1,255,0,255,
  1,0,0,255,1,128,128,0,2,0,0,0,2,128,128,0,2,0,0,255,
  1,255,0,255,1,0,128,128,1,255,0,255,3,0,255,255,2,255,0,255,
  2,0,255,255,1,255,0,255,4,0,0,255,2,128,128,0,8,0,0,255,
  2,255,0,255,4,0,255,255,1,255,0,255,7,0,0,255,1,128,128,0,
  10,0,0,255,1,255,0,255,11,0,0,255,1,128,128,0,12,0,0,255,
  1,255,0,255,9,0,0,255,1,128,128,0,14,0,0,255,1,255,0,255,
  8,0,0,255,1,128,128,0,10,0,0,0,3,128,128,0,1,0,0,255,
  1,255,0,255,8,0,0,255,1,0,0,0,1,128,128,0,5,0,0,0,
  4,128,128,0,3,0,0,0,1,0,0,255,1,255,0,255,8,0,0,255,
  1,128,128,0,5,0,0,0,2,128,128,0,7,0,0,255,1,255,0,255,
  8,0,0,255,1,128,128,0,4,0,0,0,2,128,128,0,8,0,0,255,
  1,255,0,255,9,0,0,255,1,128,128,0,3,0,0,0,1,128,128,0,
  8,0,0,255,1,255,0,255,11,0,0,255,1,128,128,0,10,0,0,255,
  1,255,0,255,12,0,0,255,2,128,128,0,8,0,0,255,2,255,0,255,
  14,0,0,255,1,128,128,0,2,0,0,0,2,128,128,0,2,0,0,255,
  1,255,0,255,17,0,0,255,6,255,0,255,81,0,0)
 );

const
 objdata_tpipereadercomp: record size: integer; data: array[0..603] of byte end =
      (size: 604; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,15,116,112,105,
  112,101,114,101,97,100,101,114,99,111,109,112,12,98,105,116,109,97,112,46,
  105,109,97,103,101,10,40,2,0,0,0,0,0,0,0,0,0,0,24,0,
  0,0,24,0,0,0,244,1,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,255,0,255,112,0,128,128,3,255,0,255,8,0,0,0,5,255,0,
  255,7,0,128,128,5,255,0,255,6,0,0,0,1,128,128,128,1,0,0,
  0,1,192,192,192,3,0,0,0,1,255,0,255,5,0,128,128,5,0,128,
  0,1,0,128,128,1,255,0,255,5,0,0,0,1,128,128,128,1,0,0,
  0,1,192,192,192,3,0,0,0,1,255,0,255,5,0,128,128,5,0,128,
  0,2,0,128,128,1,255,0,255,3,0,0,0,1,128,128,128,3,0,0,
  0,1,192,192,192,3,0,0,0,1,255,0,255,4,0,128,128,6,0,128,
  0,1,0,128,128,1,255,0,255,3,0,0,0,1,128,128,128,3,0,0,
  0,1,192,192,192,3,0,0,0,1,255,0,255,1,0,0,0,1,255,0,
  255,3,0,128,128,7,255,0,255,3,0,0,0,1,128,128,128,3,0,0,
  0,1,192,192,192,3,0,0,0,1,255,0,255,1,0,0,0,2,255,0,
  255,2,0,128,128,1,0,0,0,1,0,128,128,3,0,128,0,1,0,128,
  128,1,255,0,255,3,0,0,0,1,128,128,128,3,0,0,0,1,192,192,
  192,3,0,0,0,5,255,0,255,1,0,128,128,2,0,0,0,1,0,128,
  128,3,255,0,255,4,0,0,0,1,128,128,128,3,0,0,0,1,192,192,
  192,3,0,0,0,1,255,0,255,1,0,0,0,2,255,0,255,2,0,128,
  128,1,0,0,0,1,0,128,128,4,255,0,255,4,0,0,0,1,128,128,
  128,3,0,0,0,1,192,192,192,3,0,0,0,1,255,0,255,1,0,0,
  0,1,255,0,255,3,0,128,128,5,255,0,255,5,0,0,0,1,128,128,
  128,3,0,0,0,1,192,192,192,3,0,0,0,1,255,0,255,4,0,128,
  128,6,255,0,255,6,0,0,0,1,128,128,128,1,0,0,0,1,192,192,
  192,3,0,0,0,1,255,0,255,5,0,128,128,5,255,0,255,7,0,0,
  0,1,128,128,128,1,0,0,0,1,192,192,192,3,0,0,0,1,255,0,
  255,5,0,128,128,4,255,0,255,9,0,0,0,5,255,0,255,6,0,128,
  128,4,255,0,255,21,0,128,128,3,255,0,255,21,0,128,128,2,255,0,
  255,103,0,0)
 );

const
 objdata_tthreadcomp: record size: integer; data: array[0..663] of byte end =
      (size: 664; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,11,116,116,104,
  114,101,97,100,99,111,109,112,12,98,105,116,109,97,112,46,105,109,97,103,
  101,10,104,2,0,0,0,0,0,0,0,0,0,0,24,0,0,0,24,0,
  0,0,52,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,0,
  255,34,255,0,0,1,255,0,255,24,255,0,0,1,255,0,255,24,255,0,
  0,1,255,0,255,24,255,0,0,1,255,0,255,13,128,128,128,1,255,0,
  255,10,255,0,0,1,255,0,255,5,128,128,128,1,255,0,255,6,128,128,
  128,1,255,0,255,11,255,0,0,1,255,0,255,4,128,128,128,1,255,0,
  255,6,128,128,128,2,255,0,255,11,255,0,0,1,255,0,255,2,128,128,
  128,2,255,0,255,6,128,128,128,2,255,0,255,12,255,0,0,1,255,0,
  255,1,128,128,128,2,255,0,255,6,128,128,128,1,255,255,255,1,128,128,
  128,1,255,0,0,1,255,0,255,1,255,0,0,1,255,0,255,1,255,0,
  0,1,255,0,255,1,255,0,0,1,255,0,255,1,255,0,0,1,255,0,
  255,1,255,0,0,2,128,128,128,3,255,0,255,6,128,128,128,3,255,0,
  0,1,255,0,255,1,255,0,0,1,255,0,255,1,255,0,0,1,255,0,
  255,1,255,0,0,1,255,0,255,1,255,0,0,1,255,0,255,1,255,0,
  0,2,128,128,128,1,255,255,255,1,128,128,128,1,255,0,255,6,128,128,
  128,3,255,0,0,1,128,128,128,1,255,0,0,1,128,128,128,1,255,0,
  0,1,128,128,128,1,255,0,0,1,128,128,128,1,255,0,0,1,128,128,
  128,1,255,0,0,2,128,128,128,3,255,0,255,6,128,128,128,3,255,0,
  0,1,128,128,128,1,255,0,0,1,128,128,128,1,255,0,0,1,128,128,
  128,1,255,0,0,1,128,128,128,1,255,0,0,1,128,128,128,1,255,0,
  0,2,128,128,128,3,255,0,255,6,128,128,128,1,0,0,0,1,128,128,
  128,1,255,0,0,1,255,0,255,1,255,0,0,1,255,0,255,1,255,0,
  0,1,255,0,255,1,255,0,0,1,255,0,255,1,255,0,0,1,255,0,
  255,1,255,0,0,2,128,128,128,3,255,0,255,6,128,128,128,3,255,0,
  0,1,255,0,255,1,255,0,0,1,255,0,255,1,255,0,0,1,255,0,
  255,1,255,0,0,1,255,0,255,1,255,0,0,1,255,0,255,1,255,0,
  0,2,128,128,128,1,0,0,0,1,128,128,128,1,255,0,255,6,128,128,
  128,2,255,0,255,14,128,128,128,2,255,0,255,6,128,128,128,2,255,0,
  255,14,128,128,128,2,255,0,255,6,128,128,128,1,255,0,255,16,128,128,
  128,1,255,0,255,6,128,128,128,1,255,0,255,16,128,128,128,1,255,0,
  255,123,0,0)
 );

const
 objdata_tframecomp: record size: integer; data: array[0..726] of byte end =
      (size: 727; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,10,116,102,114,
  97,109,101,99,111,109,112,12,98,105,116,109,97,112,46,105,109,97,103,101,
  10,168,2,0,0,0,0,0,0,0,0,0,0,24,0,0,0,24,0,0,
  0,116,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,192,192,192,
  25,0,0,0,1,192,192,192,2,0,0,0,2,192,192,192,2,0,0,0,
  2,192,192,192,2,0,0,0,2,192,192,192,2,0,0,0,2,192,192,192,
  2,0,0,0,2,192,192,192,29,255,255,255,18,192,192,192,1,0,0,0,
  1,192,192,192,2,0,0,0,1,192,192,192,1,255,255,255,1,128,128,128,
  17,192,192,192,1,0,0,0,1,192,192,192,2,0,0,0,1,192,192,192,
  1,255,255,255,1,128,128,128,1,192,192,192,14,255,255,255,1,128,128,128,
  1,192,192,192,6,255,255,255,1,128,128,128,1,192,192,192,14,255,255,255,
  1,128,128,128,1,192,192,192,6,255,255,255,1,128,128,128,1,192,192,192,
  14,255,255,255,1,128,128,128,1,192,192,192,1,0,0,0,1,192,192,192,
  4,255,255,255,1,128,128,128,1,192,192,192,14,255,255,255,1,128,128,128,
  1,192,192,192,1,0,0,0,1,192,192,192,2,0,0,0,1,192,192,192,
  1,255,255,255,1,128,128,128,1,192,192,192,14,255,255,255,1,128,128,128,
  1,192,192,192,4,0,0,0,1,192,192,192,1,255,255,255,1,128,128,128,
  1,192,192,192,14,255,255,255,1,128,128,128,1,192,192,192,6,255,255,255,
  1,128,128,128,1,192,192,192,14,255,255,255,1,128,128,128,1,192,192,192,
  1,0,0,0,1,192,192,192,4,255,255,255,1,128,128,128,1,192,192,192,
  14,255,255,255,1,128,128,128,1,192,192,192,1,0,0,0,1,192,192,192,
  2,0,0,0,1,192,192,192,1,255,255,255,1,128,128,128,1,192,192,192,
  14,255,255,255,1,128,128,128,1,192,192,192,4,0,0,0,1,192,192,192,
  1,255,255,255,1,128,128,128,1,192,192,192,14,255,255,255,1,128,128,128,
  1,192,192,192,6,255,255,255,1,128,128,128,1,192,192,192,14,255,255,255,
  1,128,128,128,1,192,192,192,1,0,0,0,1,192,192,192,4,255,255,255,
  1,128,128,128,1,192,192,192,14,255,255,255,1,128,128,128,1,192,192,192,
  1,0,0,0,1,192,192,192,2,0,0,0,1,192,192,192,1,255,255,255,
  1,128,128,128,1,192,192,192,14,255,255,255,1,128,128,128,1,192,192,192,
  4,0,0,0,1,192,192,192,1,255,255,255,1,128,128,128,1,192,192,192,
  14,255,255,255,1,128,128,128,1,192,192,192,6,255,255,255,17,128,128,128,
  1,192,192,192,1,0,0,0,1,192,192,192,4,128,128,128,18,192,192,192,
  1,0,0,0,1,192,192,192,2,0,0,0,1,192,192,192,23,0,0,0,
  1,192,192,192,2,0,0,0,2,192,192,192,2,0,0,0,2,192,192,192,
  2,0,0,0,2,192,192,192,2,0,0,0,2,192,192,192,2,0,0,0,
  2,192,192,192,26,0,0)
 );

const
 objdata_tfacecomp: record size: integer; data: array[0..1953] of byte end =
      (size: 1954; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,9,116,102,97,
  99,101,99,111,109,112,12,98,105,116,109,97,112,46,105,109,97,103,101,10,
  116,7,0,0,0,0,0,0,0,0,0,0,24,0,0,0,24,0,0,0,
  64,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,192,192,192,25,
  0,0,0,1,192,192,192,2,0,0,0,2,192,192,192,2,0,0,0,2,
  192,192,192,2,0,0,0,2,192,192,192,2,0,0,0,2,192,192,192,2,
  0,0,0,2,192,192,192,4,0,227,255,1,0,210,255,1,0,192,255,1,
  0,180,255,1,0,174,255,1,0,168,255,1,0,163,255,1,0,157,255,1,
  0,151,255,1,0,146,255,1,0,140,255,1,1,136,255,1,3,134,253,1,
  4,132,251,1,6,131,250,1,8,128,248,1,11,127,246,1,13,124,244,1,
  15,123,243,1,29,109,230,1,192,192,192,4,0,228,255,1,0,210,255,1,
  0,192,255,1,0,180,255,1,0,174,255,1,0,169,255,1,0,163,255,1,
  0,157,255,1,0,152,255,1,0,147,255,1,0,141,255,1,0,136,254,1,
  3,134,253,1,5,132,252,1,6,130,249,1,8,129,248,1,11,127,246,1,
  13,125,244,1,15,122,243,1,29,109,230,1,0,0,0,1,192,192,192,2,
  0,0,0,1,0,228,255,1,0,210,255,1,0,192,255,1,0,180,255,1,
  0,174,255,1,0,169,255,1,0,163,255,1,0,157,255,1,0,151,255,1,
  0,146,255,1,0,141,255,1,0,136,255,1,3,134,253,1,4,132,251,1,
  6,130,249,1,9,129,247,1,10,127,246,1,13,124,244,1,14,123,242,1,
  29,110,230,1,0,0,0,1,192,192,192,2,0,0,0,1,0,227,255,1,
  0,210,255,1,0,192,255,1,0,180,255,1,0,174,255,1,0,168,255,1,
  0,163,255,1,0,157,255,1,0,151,255,1,0,146,255,1,0,141,255,1,
  0,136,255,1,2,134,252,1,4,132,251,1,6,130,249,1,8,129,248,1,
  10,126,245,1,12,125,244,1,15,123,243,1,29,109,230,1,192,192,192,4,
  0,227,255,1,0,210,255,1,0,192,255,1,0,179,255,1,0,174,255,1,
  0,168,255,1,0,162,255,1,0,157,255,1,0,152,255,1,0,146,255,1,
  0,141,255,1,0,136,255,1,3,134,253,1,5,132,251,1,7,130,250,1,
  8,129,247,1,11,127,246,1,13,125,244,1,14,123,243,1,30,109,230,1,
  192,192,192,4,0,227,255,1,0,210,255,1,0,192,255,1,0,180,255,1,
  0,174,255,1,0,168,255,1,0,162,255,1,0,157,255,1,0,152,255,1,
  0,146,255,1,0,141,255,1,1,136,255,1,2,134,253,1,5,133,252,1,
  6,131,250,1,9,128,247,1,10,127,246,1,13,125,244,1,15,123,242,1,
  29,110,230,1,0,0,0,1,192,192,192,3,0,227,255,1,0,210,255,1,
  0,192,255,1,0,179,255,1,0,174,255,1,0,169,255,1,0,163,255,1,
  0,157,255,1,0,152,255,1,0,146,255,1,0,140,255,1,0,136,254,1,
  2,134,253,1,5,132,251,1,7,130,250,1,8,129,247,1,10,127,246,1,
  12,125,244,1,15,123,243,1,29,109,230,1,0,0,0,1,192,192,192,2,
  0,0,0,1,0,228,255,1,0,210,255,1,0,192,255,1,0,179,255,1,
  0,174,255,1,0,169,255,1,0,163,255,1,0,158,255,1,0,152,255,1,
  0,146,255,1,0,140,255,1,1,136,255,1,3,134,253,1,5,133,251,1,
  7,131,249,1,9,128,247,1,11,126,246,1,13,125,244,1,14,123,242,1,
  30,109,230,1,192,192,192,3,0,0,0,1,0,228,255,1,0,210,255,1,
  0,192,255,1,0,179,255,1,0,174,255,1,0,168,255,1,0,163,255,1,
  0,158,255,1,0,152,255,1,0,147,255,1,0,141,255,1,0,136,255,1,
  2,134,253,1,4,133,251,1,6,131,249,1,9,128,248,1,11,127,246,1,
  12,125,244,1,15,123,242,1,29,109,230,1,192,192,192,4,0,227,255,1,
  0,210,255,1,0,192,255,1,0,179,255,1,0,174,255,1,0,168,255,1,
  0,163,255,1,0,157,255,1,0,151,255,1,0,146,255,1,0,140,255,1,
  1,136,255,1,3,134,253,1,4,132,251,1,6,130,250,1,8,129,248,1,
  10,127,246,1,13,125,244,1,14,123,242,1,30,109,230,1,0,0,0,1,
  192,192,192,3,0,227,255,1,0,210,255,1,0,192,255,1,0,180,255,1,
  0,174,255,1,0,168,255,1,0,163,255,1,0,157,255,1,0,152,255,1,
  0,146,255,1,0,140,255,1,0,136,255,1,3,134,253,1,4,133,251,1,
  6,130,250,1,9,129,248,1,10,126,246,1,12,125,244,1,15,123,242,1,
  29,110,230,1,0,0,0,1,192,192,192,2,0,0,0,1,0,228,255,1,
  0,210,255,1,0,192,255,1,0,180,255,1,0,174,255,1,0,169,255,1,
  0,162,255,1,0,157,255,1,0,151,255,1,0,146,255,1,0,141,255,1,
  0,136,254,1,3,134,253,1,4,132,251,1,6,130,250,1,8,129,247,1,
  11,127,246,1,13,125,244,1,15,123,243,1,29,109,229,1,192,192,192,3,
  0,0,0,1,0,228,255,1,0,210,255,1,0,192,255,1,0,180,255,1,
  0,174,255,1,0,168,255,1,0,163,255,1,0,157,255,1,0,152,255,1,
  0,146,255,1,0,141,255,1,0,136,255,1,2,134,253,1,5,132,251,1,
  6,130,249,1,9,129,248,1,11,126,246,1,12,124,245,1,15,123,242,1,
  29,110,230,1,192,192,192,4,0,228,255,1,0,210,255,1,0,192,255,1,
  0,180,255,1,0,174,255,1,0,168,255,1,0,163,255,1,0,158,255,1,
  0,152,255,1,0,146,255,1,0,140,255,1,1,135,255,1,3,134,253,1,
  4,132,252,1,7,131,249,1,8,129,248,1,10,126,246,1,12,124,244,1,
  15,122,242,1,29,109,230,1,0,0,0,1,192,192,192,3,0,228,255,1,
  0,210,255,1,0,192,255,1,0,180,255,1,0,174,255,1,0,169,255,1,
  0,163,255,1,0,157,255,1,0,151,255,1,0,146,255,1,0,141,255,1,
  0,135,255,1,2,134,252,1,4,132,251,1,6,131,249,1,9,129,248,1,
  10,126,246,1,13,125,244,1,15,123,243,1,29,109,230,1,0,0,0,1,
  192,192,192,2,0,0,0,1,0,227,255,1,0,210,255,1,0,192,255,1,
  0,179,255,1,0,174,255,1,0,168,255,1,0,163,255,1,0,158,255,1,
  0,152,255,1,0,146,255,1,0,141,255,1,0,136,255,1,2,134,253,1,
  4,132,251,1,7,131,250,1,9,128,248,1,11,127,246,1,13,125,244,1,
  15,123,243,1,29,109,230,1,192,192,192,3,0,0,0,1,0,228,255,1,
  0,210,255,1,0,192,255,1,0,179,255,1,0,174,255,1,0,169,255,1,
  0,163,255,1,0,157,255,1,0,152,255,1,0,146,255,1,0,140,255,1,
  1,136,254,1,2,134,253,1,4,132,251,1,6,130,250,1,9,129,248,1,
  11,126,246,1,13,125,244,1,14,123,243,1,29,110,230,1,192,192,192,4,
  0,228,255,1,0,210,255,1,0,192,255,1,0,180,255,1,0,174,255,1,
  0,168,255,1,0,163,255,1,0,157,255,1,0,152,255,1,0,146,255,1,
  0,140,255,1,0,136,254,1,2,134,253,1,5,132,251,1,7,130,250,1,
  9,128,248,1,11,127,246,1,13,125,244,1,14,123,243,1,29,109,229,1,
  0,0,0,1,192,192,192,3,0,228,255,1,0,210,255,1,0,192,255,1,
  0,180,255,1,0,174,255,1,0,169,255,1,0,162,255,1,0,157,255,1,
  0,151,255,1,0,146,255,1,0,141,255,1,1,136,255,1,3,134,252,1,
  4,132,251,1,7,131,250,1,8,128,248,1,10,126,246,1,12,125,244,1,
  15,123,242,1,30,109,230,1,0,0,0,1,192,192,192,2,0,0,0,1,
  0,228,255,1,0,210,255,1,0,192,255,1,0,180,255,1,0,174,255,1,
  0,169,255,1,0,163,255,1,0,157,255,1,0,152,255,1,0,146,255,1,
  0,141,255,1,0,136,255,1,2,134,253,1,5,133,251,1,6,130,249,1,
  8,128,248,1,11,126,246,1,12,125,244,1,14,123,242,1,29,109,230,1,
  192,192,192,3,0,0,0,1,192,192,192,2,0,0,0,2,192,192,192,2,
  0,0,0,2,192,192,192,2,0,0,0,2,192,192,192,2,0,0,0,2,
  192,192,192,2,0,0,0,2,192,192,192,26,0,0)
 );

const
 objdata_tactivator: record size: integer; data: array[0..390] of byte end =
      (size: 391; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,10,116,97,99,
  116,105,118,97,116,111,114,12,98,105,116,109,97,112,46,105,109,97,103,101,
  10,88,1,0,0,0,0,0,0,0,0,0,0,24,0,0,0,24,0,0,
  0,36,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,
  128,252,255,252,1,182,255,182,1,80,255,80,1,10,255,10,2,80,255,80,
  1,182,255,182,1,252,255,252,1,255,255,255,15,216,255,216,1,10,255,10,
  1,0,255,0,6,10,255,10,1,216,255,216,1,255,255,255,13,216,255,216,
  1,0,255,0,10,216,255,216,1,255,255,255,11,252,255,252,1,10,255,10,
  1,0,255,0,10,10,255,10,1,252,255,252,1,255,255,255,10,182,255,182,
  1,0,255,0,12,182,255,182,1,255,255,255,10,80,255,80,1,0,255,0,
  12,80,255,80,1,255,255,255,10,10,255,10,1,0,255,0,12,10,255,10,
  1,255,255,255,10,10,255,10,1,0,255,0,12,10,255,10,1,255,255,255,
  10,80,255,80,1,0,255,0,12,80,255,80,1,255,255,255,10,182,255,182,
  1,0,255,0,12,182,255,182,1,255,255,255,10,252,255,252,1,10,255,10,
  1,0,255,0,10,10,255,10,1,252,255,252,1,255,255,255,11,216,255,216,
  1,0,255,0,10,216,255,216,1,255,255,255,13,216,255,216,1,10,255,10,
  1,0,255,0,6,10,255,10,1,216,255,216,1,255,255,255,15,252,255,252,
  1,182,255,182,1,80,255,80,1,10,255,10,2,80,255,80,1,182,255,182,
  1,252,255,252,1,255,255,255,128,0,0)
 );

const
 objdata_tpostscriptprinter: record size: integer; data: array[0..722] of byte end =
      (size: 723; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,18,116,112,111,
  115,116,115,99,114,105,112,116,112,114,105,110,116,101,114,12,98,105,116,109,
  97,112,46,105,109,97,103,101,10,156,2,0,0,0,0,0,0,0,0,0,
  0,24,0,0,0,24,0,0,0,104,2,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,255,25,0,0,34,1,0,0,63,1,0,0,49,
  1,0,0,183,1,0,0,255,2,0,0,176,1,0,0,56,1,0,0,63,
  1,0,0,165,1,0,0,255,14,0,0,55,1,0,0,255,1,0,0,235,
  1,0,0,53,1,0,0,255,2,0,0,51,1,0,0,243,1,0,0,255,
  16,0,0,55,1,0,0,255,1,0,0,229,1,0,0,61,1,0,0,255,
  2,0,0,87,1,0,0,155,1,0,0,253,1,0,0,255,15,0,0,34,
  1,0,0,63,1,0,0,65,1,0,0,203,1,0,0,255,2,0,0,248,
  1,0,0,143,1,0,0,64,1,0,0,205,1,0,0,255,14,0,0,55,
  1,0,0,255,7,0,0,231,1,0,0,60,1,0,0,255,14,0,0,55,
  1,0,0,255,5,0,0,252,1,0,0,255,1,0,0,233,1,0,0,59,
  1,0,0,255,14,0,0,55,1,0,0,255,5,0,0,106,1,0,0,61,
  1,0,0,58,1,0,0,199,1,0,0,255,26,160,147,143,8,119,102,98,
  1,0,0,255,14,160,147,143,1,255,255,255,8,119,102,98,1,0,0,255,
  14,160,147,143,1,255,255,255,8,119,102,98,1,0,0,255,13,160,147,143,
  1,255,255,255,1,247,148,130,1,191,79,89,1,155,45,76,1,191,79,89,
  1,155,45,76,1,191,79,89,1,255,255,255,1,119,102,98,1,0,0,255,
  14,160,147,143,1,255,255,255,8,119,102,98,1,0,0,255,13,160,147,143,
  1,255,255,255,1,247,148,130,1,191,79,89,1,155,45,76,1,191,79,89,
  1,155,45,76,1,191,79,89,1,255,255,255,1,119,102,98,1,0,0,0,
  2,0,0,255,11,160,147,143,1,119,102,98,1,255,255,255,8,119,102,98,
  1,160,147,143,1,227,222,221,1,0,0,0,1,0,0,255,9,160,147,143,
  1,227,222,221,1,92,75,70,8,119,102,98,1,160,147,143,1,227,222,221,
  1,160,147,143,1,0,0,0,1,0,0,255,8,160,147,143,1,227,222,221,
  12,160,147,143,2,0,0,0,1,0,0,255,8,141,126,122,1,174,163,160,
  12,160,147,143,2,0,0,0,1,0,0,255,8,141,126,122,1,227,222,221,
  7,0,255,0,2,227,222,221,2,174,163,160,1,160,147,143,1,119,102,98,
  1,0,0,0,1,0,0,255,8,141,126,122,1,227,222,221,7,78,126,0,
  2,227,222,221,2,174,163,160,1,119,102,98,1,92,75,70,1,0,0,0,
  1,0,0,255,8,141,126,122,1,227,222,221,11,119,102,98,1,92,75,70,
  1,0,0,0,1,0,0,255,9,92,75,70,1,207,199,196,11,0,0,0,
  2,0,0,255,10,207,199,196,1,0,0,0,11,92,75,70,1,0,0,255,
  28,0,0)
 );

const
 objdata_tgdiprinter: record size: integer; data: array[0..831] of byte end =
      (size: 832; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,11,116,103,100,
  105,112,114,105,110,116,101,114,12,98,105,116,109,97,112,46,105,109,97,103,
  101,10,16,3,0,0,0,0,0,0,0,0,0,0,24,0,0,0,24,0,
  0,0,220,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  255,24,0,0,246,1,0,0,93,1,0,0,59,1,0,0,58,1,0,0,
  126,1,0,0,255,2,0,0,34,1,0,0,62,1,0,0,95,1,0,0,
  248,1,0,0,255,2,0,0,63,1,0,0,13,1,0,0,63,1,0,0,
  255,8,0,0,125,1,0,0,152,1,0,0,255,2,0,0,244,1,0,0,
  255,2,0,0,55,1,0,0,255,1,0,0,152,1,0,0,132,1,0,0,
  255,3,0,0,55,1,0,0,255,9,0,0,58,1,0,0,251,1,0,0,
  255,5,0,0,55,1,0,0,255,1,0,0,249,1,0,0,59,1,0,0,
  255,3,0,0,55,1,0,0,255,9,0,0,56,1,0,0,255,6,0,0,
  55,1,0,0,255,2,0,0,56,1,0,0,255,3,0,0,55,1,0,0,
  255,9,0,0,57,1,0,0,250,1,0,0,234,1,0,0,63,1,0,0,
  59,1,0,0,255,2,0,0,55,1,0,0,255,1,0,0,250,1,0,0,
  59,1,0,0,255,3,0,0,55,1,0,0,255,9,0,0,125,1,0,0,
  150,1,0,0,255,2,0,0,55,1,0,0,255,2,0,0,55,1,0,0,
  255,1,0,0,157,1,0,0,131,1,0,0,255,3,0,0,55,1,0,0,
  255,9,0,0,246,1,0,0,94,1,0,0,59,1,0,0,65,1,0,0,
  119,1,0,0,255,2,0,0,34,1,0,0,62,1,0,0,94,1,0,0,
  248,1,0,0,255,2,0,0,63,1,0,0,13,1,0,0,63,1,0,0,
  255,21,160,147,143,8,119,102,98,1,0,0,255,14,160,147,143,1,255,255,
  255,8,119,102,98,1,0,0,255,14,160,147,143,1,255,255,255,8,119,102,
  98,1,0,0,255,13,160,147,143,1,255,255,255,1,247,148,130,1,191,79,
  89,1,155,45,76,1,191,79,89,1,155,45,76,1,191,79,89,1,255,255,
  255,1,119,102,98,1,0,0,255,14,160,147,143,1,255,255,255,8,119,102,
  98,1,0,0,255,13,160,147,143,1,255,255,255,1,247,148,130,1,191,79,
  89,1,155,45,76,1,191,79,89,1,155,45,76,1,191,79,89,1,255,255,
  255,1,119,102,98,1,0,0,0,2,0,0,255,11,160,147,143,1,119,102,
  98,1,255,255,255,8,119,102,98,1,160,147,143,1,227,222,221,1,0,0,
  0,1,0,0,255,9,160,147,143,1,227,222,221,1,92,75,70,8,119,102,
  98,1,160,147,143,1,227,222,221,1,160,147,143,1,0,0,0,1,0,0,
  255,8,160,147,143,1,227,222,221,12,160,147,143,2,0,0,0,1,0,0,
  255,8,141,126,122,1,174,163,160,12,160,147,143,2,0,0,0,1,0,0,
  255,8,141,126,122,1,227,222,221,7,0,255,0,2,227,222,221,2,174,163,
  160,1,160,147,143,1,119,102,98,1,0,0,0,1,0,0,255,8,141,126,
  122,1,227,222,221,7,78,126,0,2,227,222,221,2,174,163,160,1,119,102,
  98,1,92,75,70,1,0,0,0,1,0,0,255,8,141,126,122,1,227,222,
  221,11,119,102,98,1,92,75,70,1,0,0,0,1,0,0,255,9,92,75,
  70,1,207,199,196,11,0,0,0,2,0,0,255,10,207,199,196,1,0,0,
  0,11,92,75,70,1,0,0,255,28,0,0)
 );

const
 objdata_tmainmenu: record size: integer; data: array[0..709] of byte end =
      (size: 710; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,9,116,109,97,
  105,110,109,101,110,117,12,98,105,116,109,97,112,46,105,109,97,103,101,10,
  152,2,0,0,0,0,0,0,0,0,0,0,24,0,0,0,24,0,0,0,
  100,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,0,255,25,
  0,0,0,1,255,0,255,2,0,0,0,2,255,0,255,2,0,0,0,2,
  255,0,255,2,0,0,0,2,255,0,255,2,0,0,0,2,255,0,255,2,
  0,0,0,2,255,0,255,29,255,255,255,8,128,128,128,11,0,0,0,1,
  255,0,255,2,0,0,0,1,255,0,255,1,255,255,255,1,192,192,192,6,
  128,128,128,1,192,192,192,10,128,128,128,1,0,0,0,1,255,0,255,2,
  0,0,0,1,255,0,255,1,255,255,255,1,192,192,192,1,0,0,0,4,
  192,192,192,1,128,128,128,1,192,192,192,1,0,0,0,8,192,192,192,1,
  128,128,128,1,255,0,255,5,255,255,255,1,192,192,192,6,128,128,128,1,
  192,192,192,10,128,128,128,1,255,0,255,5,255,255,255,1,192,192,192,1,
  128,128,128,14,192,192,192,2,128,128,128,1,0,0,0,1,255,0,255,4,
  255,255,255,1,128,128,128,2,255,255,255,12,128,128,128,4,0,0,0,1,
  255,0,255,2,0,0,0,1,255,0,255,3,128,128,128,1,255,255,255,1,
  192,192,192,11,128,128,128,1,255,0,255,6,0,0,0,1,255,0,255,3,
  128,128,128,1,255,255,255,1,192,192,192,11,128,128,128,1,255,0,255,10,
  128,128,128,1,255,255,255,1,192,192,192,1,0,0,0,8,192,192,192,2,
  128,128,128,1,255,0,255,3,0,0,0,1,255,0,255,6,128,128,128,1,
  255,255,255,1,192,192,192,11,128,128,128,1,255,0,255,3,0,0,0,1,
  255,0,255,2,0,0,0,1,255,0,255,3,128,128,128,14,255,0,255,6,
  0,0,0,1,255,0,255,3,128,128,128,1,192,192,192,12,128,128,128,1,
  255,0,255,10,128,128,128,1,192,192,192,2,0,0,0,6,192,192,192,4,
  128,128,128,1,255,0,255,3,0,0,0,1,255,0,255,6,128,128,128,1,
  192,192,192,12,128,128,128,1,255,0,255,3,0,0,0,1,255,0,255,2,
  0,0,0,1,255,0,255,3,128,128,128,1,192,192,192,12,128,128,128,1,
  255,0,255,6,0,0,0,1,255,0,255,3,128,128,128,1,192,192,192,2,
  0,0,0,8,192,192,192,2,128,128,128,1,255,0,255,10,128,128,128,1,
  192,192,192,12,128,128,128,1,255,0,255,3,0,0,0,1,255,0,255,6,
  128,128,128,1,192,192,192,12,128,128,128,1,255,0,255,3,0,0,0,1,
  255,0,255,2,0,0,0,1,255,0,255,3,128,128,128,14,255,0,255,6,
  0,0,0,1,255,0,255,2,0,0,0,2,255,0,255,2,0,0,0,2,
  255,0,255,2,0,0,0,2,255,0,255,2,0,0,0,2,255,0,255,2,
  0,0,0,2,255,0,255,26,0,0)
 );

const
 objdata_tpopupmenu: record size: integer; data: array[0..738] of byte end =
      (size: 739; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,10,116,112,111,
  112,117,112,109,101,110,117,12,98,105,116,109,97,112,46,105,109,97,103,101,
  10,180,2,0,0,0,0,0,0,0,0,0,0,24,0,0,0,24,0,0,
  0,128,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,0,255,
  25,0,0,0,1,255,0,255,2,0,0,0,2,255,0,255,2,0,0,0,
  2,255,0,255,2,0,0,0,2,255,0,255,2,0,0,0,2,255,0,255,
  2,0,0,0,2,255,0,255,29,128,128,128,15,255,0,255,4,0,0,0,
  1,255,0,255,2,0,0,0,1,255,0,255,1,128,128,128,1,255,255,255,
  13,128,128,128,1,255,0,255,4,0,0,0,1,255,0,255,2,0,0,0,
  1,255,0,255,1,128,128,128,1,255,255,255,1,192,192,192,11,0,0,0,
  1,128,128,128,1,255,0,255,9,128,128,128,1,255,255,255,1,192,192,192,
  1,0,0,0,9,192,192,192,1,0,0,0,2,255,0,255,9,128,128,128,
  1,255,255,255,1,192,192,192,11,0,0,0,1,255,255,255,1,0,0,0,
  1,255,0,255,3,0,0,0,1,255,0,255,4,128,128,128,13,0,0,0,
  1,255,255,255,2,0,0,0,1,255,0,255,2,0,0,0,1,255,0,255,
  2,0,0,0,1,255,0,255,1,128,128,128,1,192,192,192,12,0,0,0,
  1,255,255,255,3,0,0,0,1,255,0,255,4,0,0,0,1,255,0,255,
  1,128,128,128,1,192,192,192,12,0,0,0,1,255,255,255,4,0,0,0,
  1,255,0,255,5,128,128,128,1,192,192,192,2,0,0,0,7,192,192,192,
  3,0,0,0,1,255,255,255,5,0,0,0,1,255,0,255,4,128,128,128,
  1,192,192,192,12,0,0,0,1,255,255,255,3,0,0,0,1,255,0,255,
  1,0,0,0,1,255,0,255,2,0,0,0,1,255,0,255,1,128,128,128,
  1,192,192,192,12,0,0,0,1,255,255,255,1,0,0,0,1,255,255,255,
  2,0,0,0,1,255,0,255,3,0,0,0,1,255,0,255,1,128,128,128,
  1,192,192,192,12,0,0,0,2,255,0,255,1,0,0,0,1,255,255,255,
  2,255,0,255,5,128,128,128,1,192,192,192,2,0,0,0,9,192,192,192,
  1,0,0,0,1,128,128,128,1,255,0,255,2,0,0,0,1,255,255,255,
  1,0,0,0,1,255,0,255,4,128,128,128,1,192,192,192,13,128,128,128,
  1,255,0,255,2,0,0,0,3,255,0,255,2,0,0,0,1,255,0,255,
  1,128,128,128,1,192,192,192,13,128,128,128,1,255,0,255,7,0,0,0,
  1,255,0,255,1,128,128,128,1,192,192,192,13,128,128,128,1,255,0,255,
  9,128,128,128,1,192,192,192,13,128,128,128,1,255,0,255,4,0,0,0,
  1,255,0,255,4,128,128,128,15,255,0,255,4,0,0,0,1,255,0,255,
  2,0,0,0,1,255,0,255,23,0,0,0,1,255,0,255,2,0,0,0,
  2,255,0,255,2,0,0,0,2,255,0,255,2,0,0,0,2,255,0,255,
  2,0,0,0,2,255,0,255,2,0,0,0,2,255,0,255,26,0,0)
 );

initialization
 registerobjectdata(@objdata_taction,tbitmapcomp,'taction');
 registerobjectdata(@objdata_timagelist,tbitmapcomp,'timagelist');
 registerobjectdata(@objdata_tstatfile,tbitmapcomp,'tstatfile');
 registerobjectdata(@objdata_tbitmapcomp,tbitmapcomp,'tbitmapcomp');
 registerobjectdata(@objdata_ttimer,tbitmapcomp,'ttimer');
 registerobjectdata(@objdata_tpipereadercomp,tbitmapcomp,'tpipereadercomp');
 registerobjectdata(@objdata_tthreadcomp,tbitmapcomp,'tthreadcomp');
 registerobjectdata(@objdata_tframecomp,tbitmapcomp,'tframecomp');
 registerobjectdata(@objdata_tfacecomp,tbitmapcomp,'tfacecomp');
 registerobjectdata(@objdata_tactivator,tbitmapcomp,'tactivator');
 registerobjectdata(@objdata_tpostscriptprinter,tbitmapcomp,'tpostscriptprinter');
 registerobjectdata(@objdata_tgdiprinter,tbitmapcomp,'tgdiprinter');
 registerobjectdata(@objdata_tmainmenu,tbitmapcomp,'tmainmenu');
 registerobjectdata(@objdata_tpopupmenu,tbitmapcomp,'tpopupmenu');
end.

unit regifi_bmp;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface

implementation
uses
 mseclasses,msebitmap;

const
 objdata_tsocketclient: record size: integer; data: array[0..221] of byte end =
      (size: 222; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,13,116,115,111,
  99,107,101,116,99,108,105,101,110,116,12,98,105,116,109,97,112,46,105,109,
  97,103,101,10,172,0,0,0,0,0,0,0,0,0,0,0,24,0,0,0,
  24,0,0,0,120,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  192,192,192,38,99,99,99,3,192,192,192,20,99,99,99,1,192,192,192,2,
  99,99,99,1,192,192,192,19,99,99,99,1,192,192,192,3,0,0,0,4,
  192,192,192,13,99,99,99,4,192,192,192,3,99,99,99,1,192,192,192,16,
  99,99,99,4,192,192,192,3,99,99,99,1,192,192,192,19,99,99,99,1,
  192,192,192,3,0,0,0,4,192,192,192,17,99,99,99,1,192,192,192,2,
  99,99,99,1,192,192,192,21,99,99,99,3,192,192,192,255,192,192,192,112,
  0,0)
 );

const
 objdata_tsocketserver: record size: integer; data: array[0..237] of byte end =
      (size: 238; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,13,116,115,111,
  99,107,101,116,115,101,114,118,101,114,12,98,105,116,109,97,112,46,105,109,
  97,103,101,10,188,0,0,0,0,0,0,0,0,0,0,0,24,0,0,0,
  24,0,0,0,136,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  192,192,192,42,99,99,99,3,192,192,192,20,99,99,99,1,192,192,192,3,
  99,99,99,1,192,192,192,18,99,99,99,1,192,192,192,2,0,0,0,1,
  192,192,192,2,99,99,99,1,192,192,192,17,99,99,99,1,192,192,192,5,
  99,99,99,1,192,192,192,17,99,99,99,1,192,192,192,5,99,99,99,1,
  192,192,192,17,99,99,99,1,192,192,192,2,0,0,0,1,192,192,192,2,
  99,99,99,1,192,192,192,18,99,99,99,1,192,192,192,3,99,99,99,1,
  192,192,192,20,99,99,99,3,192,192,192,255,192,192,192,108,0,0)
 );

const
 objdata_tsocketstdio: record size: integer; data: array[0..656] of byte end =
      (size: 657; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,12,116,115,111,
  99,107,101,116,115,116,100,105,111,12,98,105,116,109,97,112,46,105,109,97,
  103,101,10,96,2,0,0,0,0,0,0,0,0,0,0,24,0,0,0,24,
  0,0,0,44,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,192,
  192,192,33,99,99,99,3,192,192,192,6,99,99,99,3,192,192,192,11,99,
  99,99,1,192,192,192,2,99,99,99,1,192,192,192,5,99,99,99,1,192,
  192,192,3,99,99,99,1,192,192,192,9,99,99,99,1,192,192,192,3,0,
  0,0,3,192,192,192,2,99,99,99,1,192,192,192,2,0,0,0,1,192,
  192,192,2,99,99,99,1,192,192,192,5,99,99,99,4,192,192,192,3,99,
  99,99,1,192,192,192,4,99,99,99,1,192,192,192,5,99,99,99,1,192,
  192,192,5,99,99,99,4,192,192,192,3,99,99,99,1,192,192,192,4,99,
  99,99,1,192,192,192,5,99,99,99,1,192,192,192,8,99,99,99,1,192,
  192,192,3,0,0,0,3,192,192,192,2,99,99,99,1,192,192,192,2,0,
  0,0,1,192,192,192,2,99,99,99,1,192,192,192,9,99,99,99,1,192,
  192,192,2,99,99,99,1,192,192,192,5,99,99,99,1,192,192,192,3,99,
  99,99,1,192,192,192,11,99,99,99,3,192,192,192,6,99,99,99,3,192,
  192,192,83,0,0,0,1,192,192,192,4,0,0,0,1,192,192,192,13,0,
  0,0,3,192,192,192,2,0,0,0,1,192,192,192,4,0,0,0,1,192,
  192,192,1,0,0,0,1,192,192,192,2,0,0,0,3,192,192,192,5,0,
  0,0,1,192,192,192,4,0,0,0,3,192,192,192,1,0,0,0,3,192,
  192,192,1,0,0,0,1,192,192,192,1,0,0,0,1,192,192,192,3,0,
  0,0,1,192,192,192,4,0,0,0,3,192,192,192,3,0,0,0,1,192,
  192,192,1,0,0,0,1,192,192,192,2,0,0,0,1,192,192,192,1,0,
  0,0,1,192,192,192,1,0,0,0,1,192,192,192,3,0,0,0,1,192,
  192,192,7,0,0,0,1,192,192,192,2,0,0,0,1,192,192,192,1,0,
  0,0,1,192,192,192,2,0,0,0,1,192,192,192,1,0,0,0,1,192,
  192,192,1,0,0,0,1,192,192,192,3,0,0,0,1,192,192,192,7,0,
  0,0,1,192,192,192,2,0,0,0,1,192,192,192,1,0,0,0,1,192,
  192,192,2,0,0,0,1,192,192,192,1,0,0,0,1,192,192,192,1,0,
  0,0,1,192,192,192,3,0,0,0,1,192,192,192,4,0,0,0,3,192,
  192,192,3,0,0,0,1,192,192,192,2,0,0,0,3,192,192,192,1,0,
  0,0,1,192,192,192,2,0,0,0,3,192,192,192,123,0,0)
 );

const
 objdata_tsocketserverstdio: record size: integer; data: array[0..550] of byte end =
      (size: 551; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,18,116,115,111,
  99,107,101,116,115,101,114,118,101,114,115,116,100,105,111,12,98,105,116,109,
  97,112,46,105,109,97,103,101,10,240,1,0,0,0,0,0,0,0,0,0,
  0,24,0,0,0,24,0,0,0,188,1,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,192,192,192,42,99,99,99,3,192,192,192,20,99,99,99,
  1,192,192,192,3,99,99,99,1,192,192,192,18,99,99,99,1,192,192,192,
  2,0,0,0,1,192,192,192,2,99,99,99,1,192,192,192,17,99,99,99,
  1,192,192,192,5,99,99,99,1,192,192,192,17,99,99,99,1,192,192,192,
  5,99,99,99,1,192,192,192,17,99,99,99,1,192,192,192,2,0,0,0,
  1,192,192,192,2,99,99,99,1,192,192,192,18,99,99,99,1,192,192,192,
  3,99,99,99,1,192,192,192,20,99,99,99,3,192,192,192,83,0,0,0,
  1,192,192,192,4,0,0,0,1,192,192,192,13,0,0,0,3,192,192,192,
  2,0,0,0,1,192,192,192,4,0,0,0,1,192,192,192,1,0,0,0,
  1,192,192,192,2,0,0,0,3,192,192,192,5,0,0,0,1,192,192,192,
  4,0,0,0,3,192,192,192,1,0,0,0,3,192,192,192,1,0,0,0,
  1,192,192,192,1,0,0,0,1,192,192,192,3,0,0,0,1,192,192,192,
  4,0,0,0,3,192,192,192,3,0,0,0,1,192,192,192,1,0,0,0,
  1,192,192,192,2,0,0,0,1,192,192,192,1,0,0,0,1,192,192,192,
  1,0,0,0,1,192,192,192,3,0,0,0,1,192,192,192,7,0,0,0,
  1,192,192,192,2,0,0,0,1,192,192,192,1,0,0,0,1,192,192,192,
  2,0,0,0,1,192,192,192,1,0,0,0,1,192,192,192,1,0,0,0,
  1,192,192,192,3,0,0,0,1,192,192,192,7,0,0,0,1,192,192,192,
  2,0,0,0,1,192,192,192,1,0,0,0,1,192,192,192,2,0,0,0,
  1,192,192,192,1,0,0,0,1,192,192,192,1,0,0,0,1,192,192,192,
  3,0,0,0,1,192,192,192,4,0,0,0,3,192,192,192,3,0,0,0,
  1,192,192,192,2,0,0,0,3,192,192,192,1,0,0,0,1,192,192,192,
  2,0,0,0,3,192,192,192,123,0,0)
 );

const
 objdata_tpipeiochannel: record size: integer; data: array[0..886] of byte end =
      (size: 887; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,14,116,112,105,
  112,101,105,111,99,104,97,110,110,101,108,12,98,105,116,109,97,112,46,105,
  109,97,103,101,10,68,3,0,0,0,0,0,0,0,0,0,0,24,0,0,
  0,24,0,0,0,16,3,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,192,192,192,25,153,227,172,22,192,192,192,2,153,227,172,3,0,0,0,
  2,147,147,147,16,153,227,172,1,192,192,192,2,153,227,172,2,0,0,0,
  1,118,119,118,2,0,0,0,1,252,252,252,13,252,253,252,2,153,227,172,
  1,192,192,192,2,153,227,172,1,0,0,0,1,166,165,166,4,0,0,0,
  1,210,214,210,1,201,216,205,1,210,214,211,1,209,215,211,1,210,215,210,
  2,210,215,211,2,209,215,211,1,210,215,211,5,153,227,172,1,192,192,192,
  2,153,227,172,1,0,0,0,1,214,214,214,4,0,0,0,1,166,165,166,
  1,166,166,166,1,166,166,165,1,166,165,165,1,165,165,165,1,166,165,165,
  1,165,165,166,1,165,166,166,1,166,166,166,1,166,165,165,5,153,227,172,
  1,192,192,192,2,153,227,172,2,0,0,0,1,252,252,252,1,255,255,255,
  1,0,0,0,1,118,119,118,1,118,118,118,1,119,118,118,1,118,118,118,
  2,118,119,118,1,118,118,118,1,118,119,118,1,119,118,119,1,118,118,118,
  1,119,118,118,5,153,227,172,1,192,192,192,2,153,227,172,3,0,0,0,
  2,90,89,90,2,89,89,89,1,90,90,90,1,90,89,90,2,89,89,90,
  2,90,90,89,1,90,89,90,7,153,227,172,1,192,192,192,2,153,227,172,
  22,192,192,192,2,153,227,172,1,147,147,146,1,147,147,147,1,146,146,147,
  1,147,147,147,1,147,146,147,2,147,147,147,1,146,147,147,1,147,147,147,
  2,147,147,146,2,146,147,146,2,147,147,147,2,0,0,0,2,153,227,172,
  3,192,192,192,2,153,227,172,1,252,252,252,8,253,252,252,1,252,252,252,
  1,252,252,253,1,252,252,252,1,252,253,252,2,252,252,252,1,0,0,0,
  1,118,119,118,2,0,0,0,1,153,227,172,2,192,192,192,2,153,227,172,
  1,210,215,210,1,210,214,211,1,210,215,210,1,210,215,211,1,209,215,211,
  1,210,214,210,2,201,216,205,1,210,214,211,1,209,215,211,1,210,215,210,
  2,210,215,211,2,0,0,0,1,166,165,166,4,0,0,0,1,153,227,172,
  1,192,192,192,2,153,227,172,1,166,166,166,1,165,166,166,1,165,166,165,
  1,166,165,166,1,165,165,165,1,166,165,165,1,166,165,166,1,166,166,166,
  1,166,166,165,1,166,165,165,1,165,165,165,1,166,165,165,1,165,165,166,
  1,165,166,166,1,0,0,0,1,214,214,214,4,0,0,0,1,153,227,172,
  1,192,192,192,2,153,227,172,1,118,118,118,2,119,118,119,1,118,119,118,
  1,118,118,118,1,118,118,119,1,118,118,118,1,119,118,118,1,118,118,118,
  2,118,119,118,1,118,118,118,1,118,119,118,1,119,118,119,1,118,118,119,
  1,0,0,0,1,252,252,252,1,255,255,255,1,0,0,0,1,153,227,172,
  2,192,192,192,2,153,227,172,1,90,89,89,1,89,90,90,1,90,89,90,
  1,90,90,89,1,90,89,90,1,90,89,89,1,90,90,90,1,89,89,89,
  1,90,90,90,1,90,89,90,2,89,89,90,2,90,90,89,1,90,89,90,
  1,90,90,90,1,90,89,89,1,0,0,0,1,153,227,172,3,192,192,192,
  2,153,227,172,22,192,192,192,2,153,227,172,22,192,192,192,2,153,227,172,
  22,192,192,192,2,153,227,172,22,192,192,192,2,153,227,172,22,192,192,192,
  2,153,227,172,22,192,192,192,2,153,227,172,22,192,192,192,2,153,227,172,
  22,192,192,192,25,0,0)
 );

const
 objdata_tsocketstdiochannel: record size: integer; data: array[0..823] of byte end =
      (size: 824; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,19,116,115,111,
  99,107,101,116,115,116,100,105,111,99,104,97,110,110,101,108,12,98,105,116,
  109,97,112,46,105,109,97,103,101,10,0,3,0,0,0,0,0,0,0,0,
  0,0,24,0,0,0,24,0,0,0,204,2,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,192,192,192,25,153,227,172,8,99,99,99,3,153,227,
  172,6,99,99,99,3,153,227,172,2,192,192,192,2,153,227,172,7,99,99,
  99,1,192,192,192,2,99,99,99,1,153,227,172,5,99,99,99,1,192,192,
  192,3,99,99,99,1,153,227,172,1,192,192,192,2,153,227,172,6,99,99,
  99,1,192,192,192,3,0,0,0,3,153,227,172,2,99,99,99,1,192,192,
  192,2,0,0,0,1,192,192,192,2,99,99,99,1,192,192,192,2,153,227,
  172,3,99,99,99,4,192,192,192,3,99,99,99,1,153,227,172,4,99,99,
  99,1,192,192,192,5,99,99,99,1,192,192,192,2,153,227,172,3,99,99,
  99,4,192,192,192,3,99,99,99,1,153,227,172,4,99,99,99,1,192,192,
  192,5,99,99,99,1,192,192,192,2,153,227,172,6,99,99,99,1,192,192,
  192,3,0,0,0,3,153,227,172,2,99,99,99,1,192,192,192,2,0,0,
  0,1,192,192,192,2,99,99,99,1,192,192,192,2,153,227,172,7,99,99,
  99,1,192,192,192,2,99,99,99,1,153,227,172,5,99,99,99,1,192,192,
  192,3,99,99,99,1,153,227,172,1,192,192,192,2,153,227,172,8,99,99,
  99,3,153,227,172,6,99,99,99,3,153,227,172,2,192,192,192,2,153,227,
  172,22,192,192,192,2,153,227,172,22,192,192,192,2,153,227,172,22,192,192,
  192,2,153,227,172,7,0,0,0,1,153,227,172,4,0,0,0,1,153,227,
  172,9,192,192,192,2,153,227,172,2,0,0,0,3,153,227,172,2,0,0,
  0,1,153,227,172,4,0,0,0,1,153,227,172,1,0,0,0,1,153,227,
  172,2,0,0,0,3,153,227,172,2,192,192,192,2,153,227,172,1,0,0,
  0,1,153,227,172,4,0,0,0,3,153,227,172,1,0,0,0,3,153,227,
  172,1,0,0,0,1,153,227,172,1,0,0,0,1,153,227,172,3,0,0,
  0,1,153,227,172,1,192,192,192,2,153,227,172,1,0,0,0,3,153,227,
  172,3,0,0,0,1,153,227,172,1,0,0,0,1,153,227,172,2,0,0,
  0,1,153,227,172,1,0,0,0,1,153,227,172,1,0,0,0,1,153,227,
  172,3,0,0,0,1,153,227,172,1,192,192,192,2,153,227,172,4,0,0,
  0,1,153,227,172,2,0,0,0,1,153,227,172,1,0,0,0,1,153,227,
  172,2,0,0,0,1,153,227,172,1,0,0,0,1,153,227,172,1,0,0,
  0,1,153,227,172,3,0,0,0,1,153,227,172,1,192,192,192,2,153,227,
  172,4,0,0,0,1,153,227,172,2,0,0,0,1,153,227,172,1,0,0,
  0,1,153,227,172,2,0,0,0,1,153,227,172,1,0,0,0,1,153,227,
  172,1,0,0,0,1,153,227,172,3,0,0,0,1,153,227,172,1,192,192,
  192,2,153,227,172,1,0,0,0,3,153,227,172,3,0,0,0,1,153,227,
  172,2,0,0,0,3,153,227,172,1,0,0,0,1,153,227,172,2,0,0,
  0,3,153,227,172,2,192,192,192,2,153,227,172,22,192,192,192,2,153,227,
  172,22,192,192,192,2,153,227,172,22,192,192,192,2,153,227,172,22,192,192,
  192,25,0,0)
 );

const
 objdata_tsocketserveriochannel: record size: integer; data: array[0..402] of byte end =
      (size: 403; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,22,116,115,111,
  99,107,101,116,115,101,114,118,101,114,105,111,99,104,97,110,110,101,108,12,
  98,105,116,109,97,112,46,105,109,97,103,101,10,88,1,0,0,0,0,0,
  0,0,0,0,0,24,0,0,0,24,0,0,0,36,1,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,192,192,192,25,153,227,172,17,99,99,99,
  3,153,227,172,2,192,192,192,2,153,227,172,16,99,99,99,1,192,192,192,
  3,99,99,99,1,153,227,172,1,192,192,192,2,153,227,172,15,99,99,99,
  1,192,192,192,2,0,0,0,1,192,192,192,2,99,99,99,1,192,192,192,
  2,153,227,172,15,99,99,99,1,192,192,192,5,99,99,99,1,192,192,192,
  2,153,227,172,15,99,99,99,1,192,192,192,5,99,99,99,1,192,192,192,
  2,153,227,172,15,99,99,99,1,192,192,192,2,0,0,0,1,192,192,192,
  2,99,99,99,1,192,192,192,2,153,227,172,16,99,99,99,1,192,192,192,
  3,99,99,99,1,153,227,172,1,192,192,192,2,153,227,172,17,99,99,99,
  3,153,227,172,2,192,192,192,2,153,227,172,22,192,192,192,2,153,227,172,
  22,192,192,192,2,153,227,172,22,192,192,192,2,153,227,172,22,192,192,192,
  2,153,227,172,22,192,192,192,2,153,227,172,22,192,192,192,2,153,227,172,
  22,192,192,192,2,153,227,172,22,192,192,192,2,153,227,172,22,192,192,192,
  2,153,227,172,22,192,192,192,2,153,227,172,22,192,192,192,2,153,227,172,
  22,192,192,192,2,153,227,172,22,192,192,192,2,153,227,172,22,192,192,192,
  25,0,0)
 );

const
 objdata_tsocketclientiochannel: record size: integer; data: array[0..402] of byte end =
      (size: 403; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,22,116,115,111,
  99,107,101,116,99,108,105,101,110,116,105,111,99,104,97,110,110,101,108,12,
  98,105,116,109,97,112,46,105,109,97,103,101,10,88,1,0,0,0,0,0,
  0,0,0,0,0,24,0,0,0,24,0,0,0,36,1,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,192,192,192,25,153,227,172,13,99,99,99,
  3,153,227,172,6,192,192,192,2,153,227,172,12,99,99,99,1,192,192,192,
  2,99,99,99,1,153,227,172,6,192,192,192,2,153,227,172,11,99,99,99,
  1,192,192,192,3,0,0,0,4,153,227,172,3,192,192,192,2,153,227,172,
  8,99,99,99,4,192,192,192,3,99,99,99,1,153,227,172,6,192,192,192,
  2,153,227,172,8,99,99,99,4,192,192,192,3,99,99,99,1,153,227,172,
  6,192,192,192,2,153,227,172,11,99,99,99,1,192,192,192,3,0,0,0,
  4,153,227,172,3,192,192,192,2,153,227,172,12,99,99,99,1,192,192,192,
  2,99,99,99,1,153,227,172,6,192,192,192,2,153,227,172,13,99,99,99,
  3,153,227,172,6,192,192,192,2,153,227,172,22,192,192,192,2,153,227,172,
  22,192,192,192,2,153,227,172,22,192,192,192,2,153,227,172,22,192,192,192,
  2,153,227,172,22,192,192,192,2,153,227,172,22,192,192,192,2,153,227,172,
  22,192,192,192,2,153,227,172,22,192,192,192,2,153,227,172,22,192,192,192,
  2,153,227,172,22,192,192,192,2,153,227,172,22,192,192,192,2,153,227,172,
  22,192,192,192,2,153,227,172,22,192,192,192,2,153,227,172,22,192,192,192,
  25,0,0)
 );

const
 objdata_tformlink: record size: integer; data: array[0..733] of byte end =
      (size: 734; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,9,116,102,111,
  114,109,108,105,110,107,12,98,105,116,109,97,112,46,105,109,97,103,101,10,
  176,2,0,0,0,0,0,0,0,0,0,0,24,0,0,0,24,0,0,0,
  124,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,192,192,192,25,
  0,0,0,1,153,227,172,2,0,0,0,2,153,227,172,2,0,0,0,2,
  153,227,172,2,0,0,0,2,153,227,172,2,0,0,0,2,153,227,172,2,
  0,0,0,2,153,227,172,1,192,192,192,2,153,227,172,22,192,192,192,2,
  153,227,172,2,255,255,255,18,153,227,172,1,0,0,0,1,192,192,192,2,
  0,0,0,1,153,227,172,1,255,255,255,1,255,0,0,13,255,255,255,1,
  0,0,0,1,192,192,192,1,128,128,128,1,153,227,172,1,0,0,0,1,
  192,192,192,2,0,0,0,1,153,227,172,1,255,255,255,1,255,0,0,13,
  255,255,255,1,192,192,192,1,0,0,0,1,128,128,128,1,153,227,172,2,
  192,192,192,2,153,227,172,2,255,255,255,1,128,128,128,17,153,227,172,2,
  192,192,192,2,153,227,172,2,255,255,255,1,192,192,192,16,128,128,128,1,
  153,227,172,1,0,0,0,1,192,192,192,2,153,227,172,2,255,255,255,1,
  192,192,192,16,128,128,128,1,153,227,172,1,0,0,0,1,192,192,192,2,
  0,0,0,1,153,227,172,1,255,255,255,1,192,192,192,16,128,128,128,1,
  153,227,172,2,192,192,192,2,0,0,0,1,153,227,172,1,255,255,255,1,
  192,192,192,16,128,128,128,1,153,227,172,2,192,192,192,2,153,227,172,2,
  255,255,255,1,192,192,192,16,128,128,128,1,153,227,172,1,0,0,0,1,
  192,192,192,2,153,227,172,2,255,255,255,1,192,192,192,16,128,128,128,1,
  153,227,172,1,0,0,0,1,192,192,192,2,0,0,0,1,153,227,172,1,
  255,255,255,1,192,192,192,16,128,128,128,1,153,227,172,2,192,192,192,2,
  0,0,0,1,153,227,172,1,255,255,255,1,192,192,192,16,128,128,128,1,
  153,227,172,2,192,192,192,2,153,227,172,2,255,255,255,1,192,192,192,16,
  128,128,128,1,153,227,172,1,0,0,0,1,192,192,192,2,153,227,172,2,
  255,255,255,1,192,192,192,16,128,128,128,1,153,227,172,1,0,0,0,1,
  192,192,192,2,0,0,0,1,153,227,172,1,255,255,255,1,192,192,192,16,
  128,128,128,1,153,227,172,2,192,192,192,2,0,0,0,1,153,227,172,1,
  255,255,255,1,192,192,192,16,128,128,128,1,153,227,172,2,192,192,192,2,
  153,227,172,2,255,255,255,1,192,192,192,16,128,128,128,1,153,227,172,1,
  0,0,0,1,192,192,192,2,153,227,172,2,128,128,128,18,153,227,172,1,
  0,0,0,1,192,192,192,2,0,0,0,1,153,227,172,21,192,192,192,2,
  0,0,0,1,153,227,172,2,0,0,0,2,153,227,172,2,0,0,0,2,
  153,227,172,2,0,0,0,2,153,227,172,2,0,0,0,2,153,227,172,2,
  0,0,0,2,153,227,172,1,192,192,192,25,0,0)
 );

const
 objdata_tmodulelink: record size: integer; data: array[0..619] of byte end =
      (size: 620; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,11,116,109,111,
  100,117,108,101,108,105,110,107,12,98,105,116,109,97,112,46,105,109,97,103,
  101,10,60,2,0,0,0,0,0,0,0,0,0,0,24,0,0,0,24,0,
  0,0,8,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,192,192,
  192,25,0,0,0,1,153,227,172,2,0,0,0,2,153,227,172,2,0,0,
  0,2,153,227,172,2,0,0,0,2,153,227,172,2,0,0,0,2,153,227,
  172,2,0,0,0,2,153,227,172,1,192,192,192,2,153,227,172,22,192,192,
  192,2,153,227,172,21,0,0,0,1,192,192,192,2,0,0,0,1,153,227,
  172,2,0,0,0,2,153,227,172,2,0,0,0,2,153,227,172,2,0,0,
  0,2,153,227,172,2,0,0,0,2,153,227,172,4,0,0,0,1,192,192,
  192,2,0,0,0,1,153,227,172,17,0,0,0,1,153,227,172,3,192,192,
  192,2,153,227,172,18,0,0,0,1,153,227,172,3,192,192,192,2,153,227,
  172,3,0,0,0,1,153,227,172,17,0,0,0,1,192,192,192,2,153,227,
  172,3,0,0,0,1,153,227,172,17,0,0,0,1,192,192,192,2,0,0,
  0,1,153,227,172,17,0,0,0,1,153,227,172,3,192,192,192,2,0,0,
  0,1,153,227,172,17,0,0,0,1,153,227,172,3,192,192,192,2,153,227,
  172,3,0,0,0,1,153,227,172,17,0,0,0,1,192,192,192,2,153,227,
  172,3,0,0,0,1,153,227,172,17,0,0,0,1,192,192,192,2,0,0,
  0,1,153,227,172,17,0,0,0,1,153,227,172,3,192,192,192,2,0,0,
  0,1,153,227,172,17,0,0,0,1,153,227,172,3,192,192,192,2,153,227,
  172,3,0,0,0,1,153,227,172,17,0,0,0,1,192,192,192,2,153,227,
  172,3,0,0,0,1,153,227,172,17,0,0,0,1,192,192,192,2,0,0,
  0,1,153,227,172,17,0,0,0,1,153,227,172,3,192,192,192,2,0,0,
  0,1,153,227,172,17,0,0,0,1,153,227,172,3,192,192,192,2,153,227,
  172,3,0,0,0,2,153,227,172,2,0,0,0,2,153,227,172,2,0,0,
  0,2,153,227,172,2,0,0,0,2,153,227,172,4,0,0,0,1,192,192,
  192,2,153,227,172,21,0,0,0,1,192,192,192,2,0,0,0,1,153,227,
  172,21,192,192,192,2,0,0,0,1,153,227,172,2,0,0,0,2,153,227,
  172,2,0,0,0,2,153,227,172,2,0,0,0,2,153,227,172,2,0,0,
  0,2,153,227,172,2,0,0,0,2,153,227,172,1,192,192,192,25,0,0)
 );

const
 objdata_trxwidgetgrid: record size: integer; data: array[0..869] of byte end =
      (size: 870; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,13,116,114,120,
  119,105,100,103,101,116,103,114,105,100,12,98,105,116,109,97,112,46,105,109,
  97,103,101,10,52,3,0,0,0,0,0,0,0,0,0,0,24,0,0,0,
  24,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  255,0,255,50,128,128,128,20,255,0,255,4,128,128,128,1,192,192,192,1,
  128,128,128,1,192,192,192,7,255,255,255,1,192,192,192,8,128,128,128,1,
  255,0,255,4,128,128,128,20,255,0,255,4,128,128,128,1,192,192,192,1,
  128,128,128,1,153,227,172,6,192,192,192,1,153,227,172,9,128,128,128,1,
  255,0,255,4,128,128,128,1,192,192,192,1,128,128,128,1,153,227,172,1,
  167,167,167,4,153,227,172,1,192,192,192,1,153,227,172,1,167,167,167,3,
  153,227,172,5,128,128,128,1,255,0,255,4,128,128,128,1,192,192,192,1,
  128,128,128,1,0,0,255,5,153,227,172,1,192,192,192,1,153,227,172,1,
  0,0,255,1,153,227,172,5,0,0,255,1,153,227,172,1,128,128,128,1,
  255,0,255,4,128,128,128,1,192,192,192,1,128,128,128,1,0,0,255,1,
  167,167,167,4,0,0,255,1,192,192,192,1,153,227,172,1,167,167,167,1,
  0,0,255,1,167,167,167,3,0,0,255,1,153,227,172,2,128,128,128,1,
  255,0,255,4,128,128,128,1,192,192,192,1,128,128,128,1,0,0,255,1,
  153,227,172,4,0,0,255,1,192,192,192,1,153,227,172,2,0,0,255,1,
  153,227,172,3,0,0,255,1,153,227,172,2,128,128,128,1,255,0,255,4,
  128,128,128,1,192,192,192,1,128,128,128,1,0,0,255,1,167,167,167,3,
  153,227,172,1,0,0,255,1,192,192,192,1,153,227,172,1,167,167,167,2,
  0,0,255,1,167,167,167,1,0,0,255,1,167,167,167,2,153,227,172,1,
  128,128,128,1,255,0,255,4,128,128,128,1,192,192,192,1,128,128,128,1,
  0,0,255,5,153,227,172,1,192,192,192,1,153,227,172,4,0,0,255,1,
  153,227,172,4,128,128,128,1,255,0,255,4,128,128,128,1,192,192,192,1,
  128,128,128,1,0,0,255,1,167,167,167,3,0,0,255,1,153,227,172,1,
  192,192,192,1,153,227,172,1,167,167,167,2,0,0,255,1,167,167,167,1,
  0,0,255,1,153,227,172,3,128,128,128,1,255,0,255,4,128,128,128,1,
  192,192,192,1,128,128,128,1,0,0,255,1,153,227,172,4,0,0,255,1,
  192,192,192,1,153,227,172,2,0,0,255,1,153,227,172,3,0,0,255,1,
  153,227,172,2,128,128,128,1,255,0,255,4,128,128,128,1,192,192,192,1,
  128,128,128,1,0,0,255,1,167,167,167,3,153,227,172,1,0,0,255,1,
  192,192,192,1,153,227,172,1,167,167,167,1,0,0,255,1,167,167,167,1,
  153,227,172,2,0,0,255,1,153,227,172,2,128,128,128,1,255,0,255,4,
  128,128,128,1,192,192,192,1,128,128,128,1,0,0,255,1,153,227,172,4,
  0,0,255,1,192,192,192,1,153,227,172,1,0,0,255,1,153,227,172,5,
  0,0,255,1,153,227,172,1,128,128,128,1,255,0,255,4,128,128,128,1,
  192,192,192,1,128,128,128,1,153,227,172,1,167,167,167,3,153,227,172,2,
  192,192,192,1,153,227,172,9,128,128,128,1,255,0,255,4,128,128,128,1,
  192,192,192,1,128,128,128,1,153,227,172,6,192,192,192,1,153,227,172,9,
  128,128,128,1,255,0,255,4,128,128,128,1,192,192,192,1,128,128,128,1,
  153,227,172,6,192,192,192,1,153,227,172,9,128,128,128,1,255,0,255,4,
  128,128,128,20,255,0,255,98,0,0)
 );

const
 objdata_ttxdatagrid: record size: integer; data: array[0..871] of byte end =
      (size: 872; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,11,116,116,120,
  100,97,116,97,103,114,105,100,12,98,105,116,109,97,112,46,105,109,97,103,
  101,10,56,3,0,0,0,0,0,0,0,0,0,0,24,0,0,0,24,0,
  0,0,4,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,0,
  255,50,128,128,128,20,255,0,255,4,128,128,128,1,192,192,192,1,128,128,
  128,1,192,192,192,7,255,255,255,1,192,192,192,8,128,128,128,1,255,0,
  255,4,128,128,128,20,255,0,255,4,128,128,128,1,192,192,192,1,128,128,
  128,1,153,227,172,6,192,192,192,1,153,227,172,9,128,128,128,1,255,0,
  255,4,128,128,128,1,192,192,192,1,128,128,128,1,153,227,172,1,167,167,
  167,4,153,227,172,1,192,192,192,1,153,227,172,1,167,167,167,3,153,227,
  172,5,128,128,128,1,255,0,255,4,128,128,128,1,192,192,192,1,0,0,
  255,7,192,192,192,1,0,0,255,1,153,227,172,5,0,0,255,1,153,227,
  172,2,128,128,128,1,255,0,255,4,128,128,128,1,192,192,192,1,128,128,
  128,1,153,227,172,1,167,167,167,1,0,0,255,1,167,167,167,2,153,227,
  172,1,192,192,192,1,153,227,172,1,0,0,255,1,167,167,167,3,0,0,
  255,1,167,167,167,1,153,227,172,2,128,128,128,1,255,0,255,4,128,128,
  128,1,192,192,192,1,128,128,128,1,153,227,172,2,0,0,255,1,153,227,
  172,3,192,192,192,1,153,227,172,1,0,0,255,1,153,227,172,3,0,0,
  255,1,153,227,172,3,128,128,128,1,255,0,255,4,128,128,128,1,192,192,
  192,1,128,128,128,1,153,227,172,1,167,167,167,1,0,0,255,1,167,167,
  167,1,153,227,172,2,192,192,192,1,153,227,172,1,167,167,167,1,0,0,
  255,1,167,167,167,1,0,0,255,1,167,167,167,3,153,227,172,1,128,128,
  128,1,255,0,255,4,128,128,128,1,192,192,192,1,128,128,128,1,153,227,
  172,2,0,0,255,1,153,227,172,3,192,192,192,1,153,227,172,3,0,0,
  255,1,153,227,172,5,128,128,128,1,255,0,255,4,128,128,128,1,192,192,
  192,1,128,128,128,1,153,227,172,1,167,167,167,1,0,0,255,1,167,167,
  167,2,153,227,172,1,192,192,192,1,153,227,172,1,167,167,167,1,0,0,
  255,1,167,167,167,1,0,0,255,1,153,227,172,4,128,128,128,1,255,0,
  255,4,128,128,128,1,192,192,192,1,128,128,128,1,153,227,172,2,0,0,
  255,1,153,227,172,3,192,192,192,1,153,227,172,1,0,0,255,1,153,227,
  172,3,0,0,255,1,153,227,172,3,128,128,128,1,255,0,255,4,128,128,
  128,1,192,192,192,1,128,128,128,1,153,227,172,1,167,167,167,1,0,0,
  255,1,167,167,167,1,153,227,172,2,192,192,192,1,153,227,172,1,0,0,
  255,1,167,167,167,2,153,227,172,1,0,0,255,1,153,227,172,3,128,128,
  128,1,255,0,255,4,128,128,128,1,192,192,192,1,128,128,128,1,153,227,
  172,2,0,0,255,1,153,227,172,3,192,192,192,1,0,0,255,1,153,227,
  172,5,0,0,255,1,153,227,172,2,128,128,128,1,255,0,255,4,128,128,
  128,1,192,192,192,1,128,128,128,1,153,227,172,1,167,167,167,3,153,227,
  172,2,192,192,192,1,153,227,172,9,128,128,128,1,255,0,255,4,128,128,
  128,1,192,192,192,1,128,128,128,1,153,227,172,6,192,192,192,1,153,227,
  172,9,128,128,128,1,255,0,255,4,128,128,128,1,192,192,192,1,128,128,
  128,1,153,227,172,6,192,192,192,1,153,227,172,9,128,128,128,1,255,0,
  255,4,128,128,128,20,255,0,255,98,0,0)
 );

const
 objdata_trxdataset: record size: integer; data: array[0..1290] of byte end =
      (size: 1291; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,10,116,114,120,
  100,97,116,97,115,101,116,12,98,105,116,109,97,112,46,105,109,97,103,101,
  10,220,4,0,0,0,0,0,0,0,0,0,0,24,0,0,0,24,0,0,
  0,168,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,0,255,
  25,153,227,172,1,8,4,8,1,0,0,0,7,0,4,0,1,0,0,0,
  3,0,4,0,1,0,0,0,1,8,4,0,1,0,0,0,2,0,4,0,
  1,0,0,0,2,153,227,172,1,255,0,255,2,153,227,172,1,0,0,0,
  1,197,198,197,1,0,4,0,1,205,206,205,1,197,194,197,1,213,202,205,
  1,205,198,197,2,189,190,189,1,205,206,205,1,205,198,205,1,205,202,205,
  1,180,206,205,1,180,206,197,1,197,190,189,1,205,194,197,1,189,202,197,
  1,180,206,205,1,189,194,197,1,0,0,0,1,153,227,172,1,255,0,255,
  2,153,227,172,1,0,4,0,1,0,12,8,1,0,0,0,2,16,0,0,
  3,8,0,0,1,0,0,0,1,0,4,0,1,0,0,0,3,0,4,0,
  1,16,4,0,1,16,8,0,1,8,0,0,1,0,0,0,1,0,4,0,
  2,153,227,172,1,255,0,255,2,153,227,172,1,0,0,0,1,197,206,197,
  1,0,0,0,1,153,227,172,6,205,202,205,1,153,227,172,9,0,0,0,
  1,153,227,172,1,255,0,255,2,153,227,172,1,0,0,0,1,238,246,246,
  1,0,4,0,1,153,227,172,6,197,198,197,1,153,227,172,2,0,0,0,
  5,153,227,172,2,0,4,0,1,153,227,172,1,255,0,255,2,153,227,172,
  1,0,0,0,1,197,206,205,1,0,4,0,1,153,227,172,1,41,105,41,
  1,0,0,0,1,41,105,41,1,0,0,0,1,153,227,172,1,197,194,189,
  1,153,227,172,1,0,0,0,1,16,28,222,5,0,0,0,1,153,227,172,
  1,0,0,0,1,153,227,172,1,255,0,255,2,153,227,172,1,0,8,0,
  1,238,246,246,1,0,12,0,1,153,227,172,6,205,194,189,1,153,227,172,
  1,0,0,0,1,16,28,222,1,153,227,172,3,16,28,222,1,0,0,0,
  1,153,227,172,1,0,0,0,1,153,227,172,1,255,0,255,2,153,227,172,
  1,0,0,0,1,197,206,197,1,0,0,0,1,153,227,172,1,41,105,41,
  1,0,0,0,2,41,105,41,1,153,227,172,1,205,190,189,1,153,227,172,
  5,16,28,222,2,0,0,0,1,153,227,172,1,0,8,0,1,153,227,172,
  1,255,0,255,2,153,227,172,1,0,0,0,1,255,255,255,1,8,4,0,
  1,153,227,172,4,180,230,190,1,153,227,172,1,213,198,197,1,153,227,172,
  4,16,28,222,2,0,0,0,1,153,227,172,2,0,0,0,1,153,227,172,
  1,255,0,255,2,153,227,172,1,8,8,8,1,197,198,197,1,0,0,0,
  1,153,227,172,1,41,105,41,1,0,0,0,3,153,227,172,1,213,202,197,
  1,153,227,172,3,16,28,222,2,0,0,0,1,153,227,172,3,0,0,0,
  1,153,227,172,1,255,0,255,2,153,227,172,1,0,0,0,1,255,255,255,
  1,8,4,0,1,153,227,172,3,180,230,190,1,153,227,172,2,205,194,197,
  1,153,227,172,3,16,28,222,1,0,0,0,1,153,227,172,4,0,0,0,
  1,153,227,172,1,255,0,255,2,153,227,172,1,0,8,8,1,197,198,197,
  1,0,0,0,1,153,227,172,1,41,105,41,1,0,0,0,2,41,105,41,
  1,153,227,172,1,205,198,197,1,153,227,172,3,16,28,222,1,0,0,0,
  1,153,227,172,4,0,0,0,1,153,227,172,1,255,0,255,2,153,227,172,
  1,0,0,0,1,255,250,246,1,8,4,0,1,153,227,172,6,197,190,189,
  1,153,227,172,9,0,0,0,1,153,227,172,1,255,0,255,2,153,227,172,
  1,0,0,0,1,205,206,205,1,0,0,0,1,153,227,172,6,205,202,205,
  1,153,227,172,3,16,28,222,1,0,0,0,1,153,227,172,4,8,4,0,
  1,153,227,172,1,255,0,255,2,153,227,172,1,0,0,255,4,153,227,172,
  1,0,0,0,1,153,227,172,1,0,0,255,1,153,227,172,1,0,0,0,
  1,153,227,172,1,0,0,255,1,153,227,172,1,16,28,222,1,0,0,0,
  1,153,227,172,1,8,4,0,1,0,0,0,2,8,4,0,1,153,227,172,
  1,255,0,255,2,153,227,172,1,0,0,255,1,153,227,172,3,0,0,255,
  1,153,227,172,2,0,0,255,1,153,227,172,3,0,0,255,1,153,227,172,
  9,255,0,255,2,153,227,172,1,0,0,255,1,153,227,172,3,0,0,255,
  1,153,227,172,3,0,0,255,1,153,227,172,1,0,0,255,1,153,227,172,
  10,255,0,255,2,153,227,172,1,0,0,255,4,153,227,172,5,0,0,255,
  1,153,227,172,11,255,0,255,2,153,227,172,1,0,0,255,1,153,227,172,
  3,0,0,255,1,153,227,172,3,0,0,255,1,153,227,172,1,0,0,255,
  1,153,227,172,10,255,0,255,2,153,227,172,1,0,0,255,1,153,227,172,
  3,0,0,255,1,153,227,172,3,0,0,255,1,153,227,172,1,0,0,255,
  1,153,227,172,10,255,0,255,2,153,227,172,1,0,0,255,1,153,227,172,
  3,0,0,255,1,153,227,172,2,0,0,255,1,153,227,172,3,0,0,255,
  1,153,227,172,9,255,0,255,2,153,227,172,1,0,0,255,1,153,227,172,
  3,0,0,255,1,153,227,172,2,0,0,255,1,153,227,172,3,0,0,255,
  1,153,227,172,9,255,0,255,25,0,0)
 );

const
 objdata_ttxdataset: record size: integer; data: array[0..1234] of byte end =
      (size: 1235; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,10,116,116,120,
  100,97,116,97,115,101,116,12,98,105,116,109,97,112,46,105,109,97,103,101,
  10,164,4,0,0,0,0,0,0,0,0,0,0,24,0,0,0,24,0,0,
  0,112,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,0,255,
  25,153,227,172,1,8,4,8,1,0,0,0,7,0,4,0,1,0,0,0,
  3,0,4,0,1,0,0,0,1,8,4,0,1,0,0,0,2,0,4,0,
  1,0,0,0,2,153,227,172,1,255,0,255,2,153,227,172,1,0,0,0,
  1,197,198,197,1,0,4,0,1,205,206,205,1,197,194,197,1,213,202,205,
  1,205,198,197,2,189,190,189,1,205,206,205,1,205,198,205,1,205,202,205,
  1,180,206,205,1,180,206,197,1,197,190,189,1,205,194,197,1,189,202,197,
  1,180,206,205,1,189,194,197,1,0,0,0,1,153,227,172,1,255,0,255,
  2,153,227,172,1,0,4,0,1,0,12,8,1,0,0,0,2,16,0,0,
  3,8,0,0,1,0,0,0,1,0,4,0,1,0,0,0,3,0,4,0,
  1,16,4,0,1,16,8,0,1,8,0,0,1,0,0,0,1,0,4,0,
  2,153,227,172,1,255,0,255,2,153,227,172,1,0,0,0,1,197,206,197,
  1,0,0,0,1,153,227,172,6,205,202,205,1,153,227,172,9,0,0,0,
  1,153,227,172,1,255,0,255,2,153,227,172,1,0,0,0,1,238,246,246,
  1,0,4,0,1,153,227,172,6,197,198,197,1,153,227,172,2,0,0,0,
  5,153,227,172,2,0,4,0,1,153,227,172,1,255,0,255,2,153,227,172,
  1,0,0,0,1,197,206,205,1,0,4,0,1,153,227,172,1,41,105,41,
  1,0,0,0,1,41,105,41,1,0,0,0,1,153,227,172,1,197,194,189,
  1,153,227,172,1,0,0,0,1,16,28,222,5,0,0,0,1,153,227,172,
  1,0,0,0,1,153,227,172,1,255,0,255,2,153,227,172,1,0,8,0,
  1,238,246,246,1,0,12,0,1,153,227,172,6,205,194,189,1,153,227,172,
  1,0,0,0,1,16,28,222,1,153,227,172,3,16,28,222,1,0,0,0,
  1,153,227,172,1,0,0,0,1,153,227,172,1,255,0,255,2,153,227,172,
  1,0,0,0,1,197,206,197,1,0,0,0,1,153,227,172,1,41,105,41,
  1,0,0,0,2,41,105,41,1,153,227,172,1,205,190,189,1,153,227,172,
  5,16,28,222,2,0,0,0,1,153,227,172,1,0,8,0,1,153,227,172,
  1,255,0,255,2,153,227,172,1,0,0,0,1,255,255,255,1,8,4,0,
  1,153,227,172,4,180,230,190,1,153,227,172,1,213,198,197,1,153,227,172,
  4,16,28,222,2,0,0,0,1,153,227,172,2,0,0,0,1,153,227,172,
  1,255,0,255,2,153,227,172,1,8,8,8,1,197,198,197,1,0,0,0,
  1,153,227,172,1,41,105,41,1,0,0,0,3,153,227,172,1,213,202,197,
  1,153,227,172,3,16,28,222,2,0,0,0,1,153,227,172,3,0,0,0,
  1,153,227,172,1,255,0,255,2,153,227,172,1,0,0,0,1,255,255,255,
  1,8,4,0,1,153,227,172,3,180,230,190,1,153,227,172,2,205,194,197,
  1,153,227,172,3,16,28,222,1,0,0,0,1,153,227,172,4,0,0,0,
  1,153,227,172,1,255,0,255,2,153,227,172,1,0,8,8,1,197,198,197,
  1,0,0,0,1,153,227,172,1,41,105,41,1,0,0,0,2,41,105,41,
  1,153,227,172,1,205,198,197,1,153,227,172,3,16,28,222,1,0,0,0,
  1,153,227,172,4,0,0,0,1,153,227,172,1,255,0,255,2,153,227,172,
  1,0,0,0,1,255,250,246,1,8,4,0,1,153,227,172,6,197,190,189,
  1,153,227,172,9,0,0,0,1,153,227,172,1,255,0,255,2,153,227,172,
  1,0,0,0,1,205,206,205,1,0,0,0,1,153,227,172,6,205,202,205,
  1,153,227,172,3,16,28,222,1,0,0,0,1,153,227,172,4,8,4,0,
  1,153,227,172,1,255,0,255,2,153,227,172,1,0,0,255,5,153,227,172,
  1,0,0,255,1,153,227,172,1,0,0,0,1,153,227,172,1,0,0,255,
  1,153,227,172,2,16,28,222,1,0,0,0,1,153,227,172,1,8,4,0,
  1,0,0,0,2,8,4,0,1,153,227,172,1,255,0,255,2,153,227,172,
  3,0,0,255,1,153,227,172,3,0,0,255,1,153,227,172,3,0,0,255,
  1,153,227,172,10,255,0,255,2,153,227,172,3,0,0,255,1,153,227,172,
  4,0,0,255,1,153,227,172,1,0,0,255,1,153,227,172,11,255,0,255,
  2,153,227,172,3,0,0,255,1,153,227,172,5,0,0,255,1,153,227,172,
  12,255,0,255,2,153,227,172,3,0,0,255,1,153,227,172,4,0,0,255,
  1,153,227,172,1,0,0,255,1,153,227,172,11,255,0,255,2,153,227,172,
  3,0,0,255,1,153,227,172,4,0,0,255,1,153,227,172,1,0,0,255,
  1,153,227,172,11,255,0,255,2,153,227,172,3,0,0,255,1,153,227,172,
  3,0,0,255,1,153,227,172,3,0,0,255,1,153,227,172,10,255,0,255,
  2,153,227,172,3,0,0,255,1,153,227,172,3,0,0,255,1,153,227,172,
  3,0,0,255,1,153,227,172,10,255,0,255,25,0,0)
 );

const
 objdata_tssl: record size: integer; data: array[0..584] of byte end =
      (size: 585; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,4,116,115,115,
  108,12,98,105,116,109,97,112,46,105,109,97,103,101,10,32,2,0,0,0,
  0,0,0,0,0,0,0,24,0,0,0,24,0,0,0,236,1,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,192,192,192,25,0,0,0,1,192,
  192,192,2,0,0,0,2,192,192,192,2,0,0,0,2,192,192,192,2,0,
  0,0,2,192,192,192,2,0,0,0,2,192,192,192,2,0,0,0,2,192,
  192,192,48,0,0,0,1,192,192,192,2,0,0,0,1,192,192,192,20,0,
  0,0,1,192,192,192,2,0,0,0,1,192,192,192,68,0,0,0,1,192,
  192,192,5,0,0,0,3,192,192,192,4,0,0,0,3,192,192,192,3,0,
  0,0,1,192,192,192,4,0,0,0,1,192,192,192,2,0,0,0,1,192,
  192,192,1,0,0,0,1,192,192,192,3,0,0,0,1,192,192,192,2,0,
  0,0,1,192,192,192,3,0,0,0,1,192,192,192,2,0,0,0,1,192,
  192,192,7,0,0,0,1,192,192,192,1,0,0,0,1,192,192,192,6,0,
  0,0,1,192,192,192,6,0,0,0,1,192,192,192,10,0,0,0,3,192,
  192,192,4,0,0,0,3,192,192,192,3,0,0,0,1,192,192,192,4,0,
  0,0,1,192,192,192,8,0,0,0,1,192,192,192,6,0,0,0,1,192,
  192,192,2,0,0,0,1,192,192,192,4,0,0,0,1,192,192,192,2,0,
  0,0,1,192,192,192,1,0,0,0,1,192,192,192,3,0,0,0,1,192,
  192,192,2,0,0,0,1,192,192,192,3,0,0,0,1,192,192,192,2,0,
  0,0,1,192,192,192,7,0,0,0,1,192,192,192,1,0,0,0,1,192,
  192,192,3,0,0,0,1,192,192,192,2,0,0,0,1,192,192,192,3,0,
  0,0,1,192,192,192,2,0,0,0,1,192,192,192,10,0,0,0,3,192,
  192,192,4,0,0,0,3,192,192,192,3,0,0,0,4,192,192,192,1,0,
  0,0,1,192,192,192,23,0,0,0,1,192,192,192,2,0,0,0,1,192,
  192,192,23,0,0,0,1,192,192,192,44,0,0,0,1,192,192,192,23,0,
  0,0,1,192,192,192,2,0,0,0,1,192,192,192,23,0,0,0,1,192,
  192,192,2,0,0,0,2,192,192,192,2,0,0,0,2,192,192,192,2,0,
  0,0,2,192,192,192,2,0,0,0,2,192,192,192,2,0,0,0,2,192,
  192,192,26,0,0)
 );

const
 objdata_ttxsqlquery: record size: integer; data: array[0..1135] of byte end =
      (size: 1136; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,11,116,116,120,
  115,113,108,113,117,101,114,121,12,98,105,116,109,97,112,46,105,109,97,103,
  101,10,64,4,0,0,0,0,0,0,0,0,0,0,24,0,0,0,24,0,
  0,0,12,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,220,220,
  220,25,153,227,172,2,0,0,0,3,153,227,172,2,0,0,0,3,153,227,
  172,2,0,0,0,1,153,227,172,4,0,0,0,1,153,227,172,4,220,220,
  220,2,153,227,172,1,0,0,0,1,255,214,0,3,0,0,0,2,255,214,
  0,3,0,0,0,2,255,214,0,1,0,0,0,1,153,227,172,2,0,0,
  0,1,255,214,0,1,0,0,0,1,153,227,172,3,220,220,220,2,0,0,
  0,1,255,214,0,1,0,0,0,4,255,214,0,1,0,0,0,3,255,214,
  0,1,0,0,0,1,255,214,0,1,0,0,0,1,153,227,172,3,0,0,
  0,1,255,214,0,1,0,0,0,1,153,227,172,2,220,220,220,2,0,0,
  0,1,255,214,0,1,0,0,0,1,153,227,172,2,0,0,0,1,255,214,
  0,1,0,0,0,1,153,227,172,1,0,0,0,1,255,214,0,1,0,0,
  0,1,255,214,0,1,0,0,0,1,153,227,172,4,0,0,0,1,255,214,
  0,1,0,0,0,1,153,227,172,1,220,220,220,2,0,0,0,1,255,214,
  0,1,0,0,0,2,153,227,172,1,0,0,0,1,255,214,0,1,0,0,
  0,1,153,227,172,1,0,0,0,1,255,214,0,1,0,0,0,1,255,214,
  0,1,0,0,0,1,153,227,172,5,0,0,0,1,255,214,0,1,0,0,
  0,1,220,220,220,2,153,227,172,1,0,0,0,1,255,214,0,2,0,0,
  0,2,255,214,0,1,0,0,0,1,153,227,172,1,0,0,0,1,255,214,
  0,1,0,0,0,1,255,214,0,1,0,0,0,1,153,227,172,6,0,0,
  0,1,255,214,0,1,0,0,0,1,220,220,220,1,153,227,172,2,0,0,
  0,2,255,214,0,1,0,0,0,1,255,214,0,1,0,0,0,3,255,214,
  0,1,0,0,0,1,255,214,0,1,0,0,0,1,153,227,172,5,0,0,
  0,1,255,214,0,1,0,0,0,1,220,220,220,2,153,227,172,3,0,0,
  0,1,255,214,0,1,0,0,0,1,255,214,0,1,0,0,0,1,255,214,
  0,1,0,0,0,1,255,214,0,1,0,0,0,1,255,214,0,1,0,0,
  0,1,153,227,172,4,0,0,0,1,255,214,0,1,0,0,0,1,153,227,
  172,1,220,220,220,2,153,227,172,1,0,0,0,3,255,214,0,1,0,0,
  0,1,255,214,0,1,0,0,0,2,255,214,0,1,0,0,0,2,255,214,
  0,1,0,0,0,3,153,227,172,1,0,0,0,1,255,214,0,1,0,0,
  0,1,153,227,172,2,220,220,220,2,0,0,0,1,255,214,0,3,0,0,
  0,1,153,227,172,1,0,0,0,8,255,214,0,2,0,0,0,1,255,214,
  0,1,0,0,0,1,153,227,172,3,220,220,220,2,153,227,172,1,0,0,
  0,3,153,227,172,2,0,0,0,1,99,218,94,7,0,0,0,2,153,227,
  172,1,0,0,0,1,153,227,172,4,220,220,220,2,153,227,172,6,0,0,
  0,1,99,218,94,7,0,0,0,1,153,227,172,7,220,220,220,2,153,227,
  172,7,0,0,0,4,99,218,94,3,0,0,0,1,153,227,172,7,220,220,
  220,2,153,227,172,11,99,218,94,3,0,0,0,1,153,227,172,7,220,220,
  220,2,0,0,255,5,153,227,172,1,0,0,255,1,153,227,172,3,0,0,
  255,1,99,218,94,3,0,0,0,1,153,227,172,7,220,220,220,2,153,227,
  172,2,0,0,255,1,153,227,172,3,0,0,255,1,153,227,172,2,99,218,
  94,1,0,0,255,1,99,218,94,2,0,0,0,1,153,227,172,8,220,220,
  220,2,153,227,172,2,0,0,255,1,153,227,172,4,0,0,255,1,153,227,
  172,1,0,0,255,1,99,218,94,2,0,0,0,1,153,227,172,9,220,220,
  220,2,153,227,172,2,0,0,255,1,153,227,172,5,0,0,255,1,99,218,
  94,3,0,0,0,1,153,227,172,9,220,220,220,2,153,227,172,2,0,0,
  255,1,153,227,172,4,0,0,255,1,153,227,172,1,0,0,255,1,99,218,
  94,1,0,0,0,1,153,227,172,10,220,220,220,2,153,227,172,2,0,0,
  255,1,153,227,172,4,0,0,255,1,153,227,172,1,0,0,255,1,153,227,
  172,12,220,220,220,2,153,227,172,2,0,0,255,1,153,227,172,3,0,0,
  255,1,153,227,172,2,99,218,94,1,0,0,255,1,153,227,172,11,220,220,
  220,2,153,227,172,2,0,0,255,1,153,227,172,3,0,0,255,1,153,227,
  172,1,0,0,0,1,99,218,94,1,0,0,255,1,153,227,172,11,220,220,
  220,11,0,0,0,1,153,227,172,1,220,220,220,12,0,0)
 );

initialization
 registerobjectdata(@objdata_tsocketclient,tbitmapcomp,'tsocketclient');
 registerobjectdata(@objdata_tsocketserver,tbitmapcomp,'tsocketserver');
 registerobjectdata(@objdata_tsocketstdio,tbitmapcomp,'tsocketstdio');
 registerobjectdata(@objdata_tsocketserverstdio,tbitmapcomp,'tsocketserverstdio');
 registerobjectdata(@objdata_tpipeiochannel,tbitmapcomp,'tpipeiochannel');
 registerobjectdata(@objdata_tsocketstdiochannel,tbitmapcomp,'tsocketstdiochannel');
 registerobjectdata(@objdata_tsocketserveriochannel,tbitmapcomp,'tsocketserveriochannel');
 registerobjectdata(@objdata_tsocketclientiochannel,tbitmapcomp,'tsocketclientiochannel');
 registerobjectdata(@objdata_tformlink,tbitmapcomp,'tformlink');
 registerobjectdata(@objdata_tmodulelink,tbitmapcomp,'tmodulelink');
 registerobjectdata(@objdata_trxwidgetgrid,tbitmapcomp,'trxwidgetgrid');
 registerobjectdata(@objdata_ttxdatagrid,tbitmapcomp,'ttxdatagrid');
 registerobjectdata(@objdata_trxdataset,tbitmapcomp,'trxdataset');
 registerobjectdata(@objdata_ttxdataset,tbitmapcomp,'ttxdataset');
 registerobjectdata(@objdata_tssl,tbitmapcomp,'tssl');
 registerobjectdata(@objdata_ttxsqlquery,tbitmapcomp,'ttxsqlquery');
end.
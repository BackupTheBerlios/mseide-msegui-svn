unit regdialogs_bmp;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,msebitmap;

const
 objdata_tfilelistview: record size: integer; data: array[0..868] of byte end =
      (size: 869; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,13,116,102,105,
  108,101,108,105,115,116,118,105,101,119,23,98,105,116,109,97,112,46,116,114,
  97,110,115,112,97,114,101,110,116,99,111,108,111,114,4,6,0,0,128,14,
  98,105,116,109,97,112,46,111,112,116,105,111,110,115,11,10,98,109,111,95,
  109,97,115,107,101,100,13,98,109,111,95,99,111,108,111,114,109,97,115,107,
  0,12,98,105,116,109,97,112,46,105,109,97,103,101,10,236,2,0,0,0,
  0,0,0,6,0,0,0,24,0,0,0,24,0,0,0,160,2,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,128,128,128,25,0,0,0,22,255,
  255,255,1,128,128,128,1,0,0,0,1,255,255,255,20,224,224,224,1,255,
  255,255,1,128,128,128,1,0,0,0,1,255,255,255,20,224,224,224,1,255,
  255,255,1,128,128,128,1,0,0,0,1,255,255,255,20,224,224,224,1,255,
  255,255,1,128,128,128,1,0,0,0,1,255,255,255,20,224,224,224,1,255,
  255,255,1,128,128,128,1,0,0,0,1,255,255,255,20,224,224,224,1,255,
  255,255,1,128,128,128,1,0,0,0,1,255,255,255,20,224,224,224,1,255,
  255,255,1,128,128,128,1,0,0,0,1,255,255,255,2,0,0,0,4,255,
  255,255,2,0,0,0,1,255,255,255,2,0,0,0,1,255,255,255,8,224,
  224,224,1,255,255,255,1,128,128,128,1,0,0,0,1,255,255,255,2,0,
  0,0,1,255,255,255,8,0,0,0,1,255,255,255,8,224,224,224,1,255,
  255,255,1,128,128,128,1,0,0,0,1,255,255,255,2,0,0,0,1,255,
  255,255,5,0,0,0,1,255,255,255,2,0,0,0,1,255,255,255,2,186,
  186,186,1,25,25,25,2,195,195,195,1,255,255,255,2,224,224,224,1,255,
  255,255,1,128,128,128,1,0,0,0,1,255,255,255,2,0,0,0,3,255,
  255,255,3,0,0,0,1,255,255,255,2,0,0,0,1,255,255,255,2,39,
  39,39,1,194,194,194,1,197,197,197,1,50,50,50,1,255,255,255,2,224,
  224,224,1,255,255,255,1,128,128,128,1,0,0,0,1,255,255,255,2,0,
  0,0,1,255,255,255,5,0,0,0,1,255,255,255,2,0,0,0,1,255,
  255,255,2,3,3,3,1,0,0,0,2,4,4,4,1,255,255,255,2,224,
  224,224,1,255,255,255,1,128,128,128,1,0,0,0,1,255,255,255,2,0,
  0,0,1,255,255,255,5,0,0,0,1,255,255,255,2,0,0,0,1,255,
  255,255,2,34,34,34,1,195,195,195,1,220,220,220,1,255,255,255,3,224,
  224,224,1,255,255,255,1,128,128,128,1,0,0,0,1,255,255,255,2,0,
  0,0,1,255,255,255,5,0,0,0,1,255,255,255,2,0,0,0,1,255,
  255,255,2,179,179,179,1,23,23,23,1,0,0,0,1,58,58,58,1,255,
  255,255,2,224,224,224,1,255,255,255,1,128,128,128,1,0,0,0,1,255,
  255,255,20,224,224,224,1,255,255,255,1,128,128,128,1,0,0,0,1,255,
  255,255,20,224,224,224,1,255,255,255,1,128,128,128,1,0,0,0,1,255,
  255,255,20,224,224,224,1,255,255,255,1,128,128,128,1,0,0,0,1,255,
  255,255,20,224,224,224,1,255,255,255,1,128,128,128,1,0,0,0,1,255,
  255,255,20,224,224,224,1,255,255,255,1,128,128,128,1,0,0,0,1,255,
  255,255,20,224,224,224,1,255,255,255,1,128,128,128,1,0,0,0,1,255,
  255,255,20,224,224,224,1,255,255,255,1,128,128,128,1,224,224,224,22,255,
  255,255,25,20,0,0,0,255,255,255,255,255,255,255,255,255,255,255,42,128,
  128,128,1,255,255,255,23,0,0)
 );

const
 objdata_tfiledialog: record size: integer; data: array[0..2114] of byte end =
      (size: 2115; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,11,116,102,105,
  108,101,100,105,97,108,111,103,23,98,105,116,109,97,112,46,116,114,97,110,
  115,112,97,114,101,110,116,99,111,108,111,114,4,6,0,0,128,14,98,105,
  116,109,97,112,46,111,112,116,105,111,110,115,11,10,98,109,111,95,109,97,
  115,107,101,100,13,98,109,111,95,99,111,108,111,114,109,97,115,107,0,12,
  98,105,116,109,97,112,46,105,109,97,103,101,10,204,7,0,0,0,0,0,
  0,6,0,0,0,24,0,0,0,24,0,0,0,136,7,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,255,255,255,25,242,166,149,1,221,216,211,
  1,242,166,149,1,255,134,109,2,121,64,52,1,157,83,67,1,187,98,80,
  1,208,109,89,2,247,130,106,1,212,111,91,1,255,134,109,4,160,160,160,
  6,128,128,128,1,255,255,255,1,221,216,211,1,7,239,255,1,221,216,211,
  1,255,134,109,2,120,63,51,1,201,106,86,1,181,95,77,1,135,71,58,
  1,214,112,91,1,139,73,59,1,163,86,70,1,242,127,103,1,255,134,109,
  3,160,160,160,1,212,212,212,1,128,128,128,1,160,160,160,1,209,209,209,
  1,128,128,128,2,255,255,255,1,242,166,149,1,221,216,211,1,242,166,149,
  1,255,134,109,2,212,111,91,1,255,134,109,1,218,115,93,1,204,107,87,
  1,180,95,77,1,222,117,95,1,184,97,79,1,253,133,108,1,255,134,109,
  3,160,160,160,1,212,212,212,1,128,128,128,1,160,160,160,1,209,209,209,
  1,128,128,128,2,255,255,255,1,151,24,0,16,128,128,128,7,255,255,255,
  1,230,230,230,1,229,229,229,1,228,228,228,1,227,227,227,1,226,226,226,
  1,225,225,225,1,224,224,224,1,223,223,223,1,222,222,222,1,221,221,221,
  1,220,220,220,1,219,219,219,1,218,218,218,1,217,217,217,1,215,215,215,
  1,214,214,214,1,213,213,213,1,212,212,212,1,211,211,211,1,210,210,210,
  1,209,209,209,1,208,208,208,1,128,128,128,1,255,255,255,1,230,230,230,
  1,229,229,229,1,228,228,228,1,227,227,227,1,226,226,226,1,225,225,225,
  1,224,224,224,1,223,223,223,1,222,222,222,1,221,221,221,1,220,220,220,
  1,219,219,219,1,218,218,218,1,217,217,217,1,215,215,215,1,214,214,214,
  1,213,213,213,1,212,212,212,1,211,211,211,1,210,210,210,1,209,209,209,
  1,208,208,208,1,128,128,128,1,255,255,255,1,230,230,230,1,229,229,229,
  1,228,228,228,1,227,227,227,1,226,226,226,1,225,225,225,1,224,224,224,
  1,223,223,223,1,222,222,222,1,221,221,221,1,220,220,220,1,219,219,219,
  1,218,218,218,1,217,217,217,1,215,215,215,1,214,214,214,1,213,213,213,
  1,212,212,212,1,211,211,211,1,210,210,210,1,209,209,209,1,208,208,208,
  1,128,128,128,1,255,255,255,1,230,230,230,1,229,229,229,1,228,228,228,
  1,227,227,227,1,226,226,226,1,225,225,225,1,224,224,224,1,223,223,223,
  1,222,222,222,1,221,221,221,1,220,220,220,1,219,219,219,1,218,218,218,
  1,217,217,217,1,215,215,215,1,214,214,214,1,213,213,213,1,212,212,212,
  1,211,211,211,1,210,210,210,1,209,209,209,1,208,208,208,1,128,128,128,
  1,255,255,255,1,230,230,230,1,229,229,229,1,228,228,228,1,227,227,227,
  1,226,226,226,1,225,225,225,1,224,224,224,1,223,223,223,1,222,222,222,
  1,221,221,221,1,220,220,220,1,219,219,219,1,218,218,218,1,217,217,217,
  1,215,215,215,1,214,214,214,1,213,213,213,1,212,212,212,1,211,211,211,
  1,210,210,210,1,209,209,209,1,208,208,208,1,128,128,128,1,255,255,255,
  1,230,230,230,1,229,229,229,1,228,228,228,1,0,0,0,4,223,223,223,
  1,222,222,222,1,0,0,0,1,220,220,220,1,219,219,219,1,0,0,0,
  1,217,217,217,1,215,215,215,1,214,214,214,1,213,213,213,1,212,212,212,
  1,211,211,211,1,210,210,210,1,209,209,209,1,208,208,208,1,128,128,128,
  1,255,255,255,1,230,230,230,1,229,229,229,1,228,228,228,1,0,0,0,
  1,226,226,226,1,225,225,225,1,224,224,224,1,223,223,223,1,222,222,222,
  1,221,221,221,1,220,220,220,1,219,219,219,1,0,0,0,1,217,217,217,
  1,215,215,215,1,214,214,214,1,213,213,213,1,212,212,212,1,211,211,211,
  1,210,210,210,1,209,209,209,1,208,208,208,1,128,128,128,1,255,255,255,
  1,230,230,230,1,229,229,229,1,228,228,228,1,0,0,0,1,226,226,226,
  1,225,225,225,1,224,224,224,1,223,223,223,1,222,222,222,1,0,0,0,
  1,220,220,220,1,219,219,219,1,0,0,0,1,217,217,217,1,215,215,215,
  1,156,156,156,1,21,21,21,2,161,161,161,1,210,210,210,1,209,209,209,
  1,208,208,208,1,128,128,128,1,255,255,255,1,230,230,230,1,229,229,229,
  1,228,228,228,1,0,0,0,3,224,224,224,1,223,223,223,1,222,222,222,
  1,0,0,0,1,220,220,220,1,219,219,219,1,0,0,0,1,217,217,217,
  1,215,215,215,1,33,33,33,1,162,162,162,1,164,164,164,1,41,41,41,
  1,210,210,210,1,209,209,209,1,208,208,208,1,128,128,128,1,255,255,255,
  1,230,230,230,1,229,229,229,1,228,228,228,1,0,0,0,1,226,226,226,
  1,225,225,225,1,224,224,224,1,223,223,223,1,222,222,222,1,0,0,0,
  1,220,220,220,1,219,219,219,1,0,0,0,1,217,217,217,1,215,215,215,
  1,3,3,3,1,0,0,0,2,3,3,3,1,210,210,210,1,209,209,209,
  1,208,208,208,1,128,128,128,1,255,255,255,1,230,230,230,1,229,229,229,
  1,228,228,228,1,0,0,0,1,226,226,226,1,225,225,225,1,224,224,224,
  1,223,223,223,1,222,222,222,1,0,0,0,1,220,220,220,1,219,219,219,
  1,0,0,0,1,217,217,217,1,215,215,215,1,29,29,29,1,163,163,163,
  1,183,183,183,1,211,211,211,1,210,210,210,1,209,209,209,1,208,208,208,
  1,128,128,128,1,255,255,255,1,230,230,230,1,229,229,229,1,228,228,228,
  1,0,0,0,1,226,226,226,1,225,225,225,1,224,224,224,1,223,223,223,
  1,222,222,222,1,0,0,0,1,220,220,220,1,219,219,219,1,0,0,0,
  1,217,217,217,1,215,215,215,1,150,150,150,1,19,19,19,1,0,0,0,
  1,48,48,48,1,210,210,210,1,209,209,209,1,208,208,208,1,128,128,128,
  1,255,255,255,1,230,230,230,1,229,229,229,1,228,228,228,1,227,227,227,
  1,226,226,226,1,225,225,225,1,224,224,224,1,223,223,223,1,222,222,222,
  1,221,221,221,1,220,220,220,1,219,219,219,1,218,218,218,1,217,217,217,
  1,215,215,215,1,214,214,214,1,213,213,213,1,212,212,212,1,211,211,211,
  1,210,210,210,1,209,209,209,1,208,208,208,1,128,128,128,1,255,255,255,
  1,230,230,230,1,229,229,229,1,228,228,228,1,227,227,227,1,226,226,226,
  1,225,225,225,1,224,224,224,1,223,223,223,1,222,222,222,1,221,221,221,
  1,220,220,220,1,219,219,219,1,218,218,218,1,217,217,217,1,215,215,215,
  1,214,214,214,1,213,213,213,1,212,212,212,1,211,211,211,1,210,210,210,
  1,209,209,209,1,208,208,208,1,128,128,128,1,255,255,255,1,230,230,230,
  1,229,229,229,1,228,228,228,1,227,227,227,1,226,226,226,1,225,225,225,
  1,224,224,224,1,223,223,223,1,222,222,222,1,221,221,221,1,220,220,220,
  1,219,219,219,1,218,218,218,1,217,217,217,1,215,215,215,1,214,214,214,
  1,213,213,213,1,212,212,212,1,211,211,211,1,210,210,210,1,209,209,209,
  1,208,208,208,1,128,128,128,1,255,255,255,1,230,230,230,1,229,229,229,
  1,228,228,228,1,227,227,227,1,226,226,226,1,225,225,225,1,224,224,224,
  1,223,223,223,1,222,222,222,1,221,221,221,1,220,220,220,1,219,219,219,
  1,218,218,218,1,217,217,217,1,215,215,215,1,214,214,214,1,213,213,213,
  1,212,212,212,1,211,211,211,1,210,210,210,1,209,209,209,1,208,208,208,
  1,128,128,128,1,255,255,255,1,230,230,230,1,229,229,229,1,228,228,228,
  1,227,227,227,1,226,226,226,1,225,225,225,1,224,224,224,1,223,223,223,
  1,222,222,222,1,221,221,221,1,220,220,220,1,219,219,219,1,218,218,218,
  1,217,217,217,1,215,215,215,1,214,214,214,1,213,213,213,1,212,212,212,
  1,211,211,211,1,210,210,210,1,209,209,209,1,208,208,208,1,128,128,128,
  1,255,255,255,1,230,230,230,1,229,229,229,1,228,228,228,1,227,227,227,
  1,226,226,226,1,225,225,225,1,224,224,224,1,223,223,223,1,222,222,222,
  1,221,221,221,1,220,220,220,1,219,219,219,1,218,218,218,1,217,217,217,
  1,215,215,215,1,214,214,214,1,213,213,213,1,212,212,212,1,211,211,211,
  1,210,210,210,1,209,209,209,1,208,208,208,1,128,128,128,25,12,0,0,
  0,255,255,255,255,255,255,255,255,255,255,255,66,0,0)
 );

const
 objdata_tfilenameedit: record size: integer; data: array[0..740] of byte end =
      (size: 741; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,13,116,102,105,
  108,101,110,97,109,101,101,100,105,116,23,98,105,116,109,97,112,46,116,114,
  97,110,115,112,97,114,101,110,116,99,111,108,111,114,4,6,0,0,128,14,
  98,105,116,109,97,112,46,111,112,116,105,111,110,115,11,10,98,109,111,95,
  109,97,115,107,101,100,13,98,109,111,95,99,111,108,111,114,109,97,115,107,
  0,12,98,105,116,109,97,112,46,105,109,97,103,101,10,108,2,0,0,0,
  0,0,0,6,0,0,0,24,0,0,0,24,0,0,0,36,2,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,255,255,255,120,128,128,128,25,0,
  0,0,22,255,255,255,1,128,128,128,1,0,0,0,1,255,255,255,20,224,
  224,224,1,255,255,255,1,128,128,128,1,0,0,0,1,255,255,255,1,0,
  0,0,4,255,255,255,2,0,0,0,1,255,255,255,2,0,0,0,1,255,
  255,255,6,0,0,0,1,255,255,255,1,0,0,0,1,224,224,224,1,255,
  255,255,1,128,128,128,1,0,0,0,1,255,255,255,1,0,0,0,1,255,
  255,255,8,0,0,0,1,255,255,255,7,0,0,0,1,255,255,255,1,224,
  224,224,1,255,255,255,1,128,128,128,1,0,0,0,1,255,255,255,1,0,
  0,0,1,255,255,255,5,0,0,0,1,255,255,255,2,0,0,0,1,255,
  255,255,2,186,186,186,1,25,25,25,2,195,195,195,1,255,255,255,1,0,
  0,0,1,255,255,255,1,224,224,224,1,255,255,255,1,128,128,128,1,0,
  0,0,1,255,255,255,1,0,0,0,3,255,255,255,3,0,0,0,1,255,
  255,255,2,0,0,0,1,255,255,255,2,39,39,39,1,194,194,194,1,197,
  197,197,1,50,50,50,1,255,255,255,1,0,0,0,1,255,255,255,1,224,
  224,224,1,255,255,255,1,128,128,128,1,0,0,0,1,255,255,255,1,0,
  0,0,1,255,255,255,5,0,0,0,1,255,255,255,2,0,0,0,1,255,
  255,255,2,3,3,3,1,0,0,0,2,4,4,4,1,255,255,255,1,0,
  0,0,1,255,255,255,1,224,224,224,1,255,255,255,1,128,128,128,1,0,
  0,0,1,255,255,255,1,0,0,0,1,255,255,255,5,0,0,0,1,255,
  255,255,2,0,0,0,1,255,255,255,2,34,34,34,1,195,195,195,1,220,
  220,220,1,255,255,255,2,0,0,0,1,255,255,255,1,224,224,224,1,255,
  255,255,1,128,128,128,1,0,0,0,1,255,255,255,1,0,0,0,1,255,
  255,255,5,0,0,0,1,255,255,255,2,0,0,0,1,255,255,255,2,179,
  179,179,1,23,23,23,1,0,0,0,1,58,58,58,1,255,255,255,1,0,
  0,0,1,255,255,255,1,224,224,224,1,255,255,255,1,128,128,128,1,0,
  0,0,1,255,255,255,17,0,0,0,1,255,255,255,1,0,0,0,1,224,
  224,224,1,255,255,255,1,128,128,128,1,0,0,0,1,255,255,255,20,224,
  224,224,1,255,255,255,1,128,128,128,1,224,224,224,22,255,255,255,145,16,
  0,0,0,0,0,0,120,255,255,255,255,255,255,255,81,0,0,0,120,0,
  0)
 );

const
 objdata_tdirdropdownedit: record size: integer; data: array[0..1243] of byte end =
      (size: 1244; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,16,116,100,105,
  114,100,114,111,112,100,111,119,110,101,100,105,116,23,98,105,116,109,97,112,
  46,116,114,97,110,115,112,97,114,101,110,116,99,111,108,111,114,4,6,0,
  0,128,14,98,105,116,109,97,112,46,111,112,116,105,111,110,115,11,10,98,
  109,111,95,109,97,115,107,101,100,13,98,109,111,95,99,111,108,111,114,109,
  97,115,107,0,12,98,105,116,109,97,112,46,105,109,97,103,101,10,96,4,
  0,0,0,0,0,0,6,0,0,0,24,0,0,0,24,0,0,0,28,4,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,128,128,25,255,255,
  255,1,0,0,0,2,5,5,5,1,174,174,174,1,255,255,255,2,0,0,
  0,1,255,255,255,6,0,0,0,1,255,255,255,1,0,0,0,1,255,255,
  255,6,128,128,128,1,255,255,255,1,0,0,0,1,255,255,255,1,174,174,
  174,1,5,5,5,1,255,255,255,2,0,0,0,1,255,255,255,1,0,0,
  0,1,71,71,71,1,255,255,255,4,0,0,0,1,255,255,255,2,208,208,
  208,3,128,128,128,1,255,255,255,1,128,128,128,1,255,255,255,1,0,0,
  0,1,255,255,255,2,0,0,0,1,255,255,255,2,0,0,0,1,255,255,
  255,1,0,0,0,1,213,213,213,1,255,255,255,4,0,0,0,1,255,255,
  255,2,0,0,0,3,128,128,128,1,255,255,255,1,128,128,128,1,255,255,
  255,1,0,0,0,1,255,255,255,2,0,0,0,1,255,255,255,2,0,0,
  0,1,255,255,255,1,0,0,0,1,254,254,254,1,255,255,255,4,0,0,
  0,1,255,255,255,2,208,208,208,1,0,0,0,1,208,208,208,1,128,128,
  128,1,255,255,255,1,128,128,128,1,255,255,255,1,0,0,0,1,255,255,
  255,1,174,174,174,1,5,5,5,1,255,255,255,2,0,0,0,1,255,255,
  255,1,0,0,0,1,255,255,255,3,252,252,252,1,231,231,231,1,0,0,
  0,1,247,247,247,1,255,255,255,1,208,208,208,3,128,128,128,1,255,255,
  255,1,128,128,128,1,255,255,255,1,0,0,0,2,5,5,5,1,174,174,
  174,1,255,255,255,2,0,0,0,1,255,255,255,1,0,0,0,1,255,255,
  255,3,223,223,223,1,0,0,0,1,223,223,223,1,0,0,0,1,128,128,
  128,5,255,255,255,25,0,0,0,25,255,255,255,22,0,0,0,2,255,255,
  255,1,0,0,0,3,255,255,255,1,238,238,238,1,167,167,167,1,171,171,
  171,1,220,220,220,1,203,203,203,1,175,175,175,1,204,204,204,1,219,219,
  219,1,241,241,241,1,200,200,200,1,243,243,243,1,255,255,255,6,0,0,
  0,2,255,255,255,1,0,0,0,1,255,255,255,1,0,0,0,1,255,255,
  255,1,226,226,226,1,147,147,147,1,164,164,164,1,173,173,173,1,175,175,
  175,1,178,178,178,1,172,172,172,1,182,182,182,1,172,172,172,1,166,166,
  166,1,173,173,173,1,255,255,255,6,0,0,0,2,255,255,255,1,0,0,
  0,3,255,255,255,1,241,241,241,1,198,198,198,1,197,197,197,1,202,202,
  202,1,215,215,215,1,198,198,198,1,219,219,219,1,195,195,195,1,211,211,
  211,1,128,128,128,1,223,223,223,1,255,255,255,6,0,0,0,2,255,255,
  255,2,0,0,0,1,255,255,255,19,0,0,0,2,255,255,255,6,0,0,
  0,3,255,255,255,2,249,249,249,1,181,181,181,1,254,254,254,2,243,243,
  243,1,213,213,213,1,248,248,248,1,255,255,255,4,0,0,0,2,255,255,
  255,2,0,0,0,1,255,255,255,1,0,0,0,1,255,255,255,1,0,0,
  0,1,255,255,255,1,0,0,0,1,255,255,255,1,160,160,160,1,168,168,
  168,1,140,140,140,1,170,170,170,1,140,140,140,1,157,157,157,1,149,149,
  149,1,234,234,234,1,255,255,255,4,0,0,0,2,255,255,255,6,0,0,
  0,3,255,255,255,1,144,144,144,1,209,209,209,1,179,179,179,1,219,219,
  219,1,132,132,132,1,193,193,193,1,164,164,164,1,239,239,239,1,255,255,
  255,4,0,0,0,2,255,255,255,2,0,0,0,1,255,255,255,10,250,250,
  250,1,226,226,226,1,255,255,255,7,0,0,0,2,255,255,255,6,0,0,
  0,3,255,255,255,3,175,175,175,1,200,200,200,1,255,255,255,3,206,206,
  206,1,175,175,175,1,255,255,255,3,0,0,0,2,255,255,255,2,0,0,
  0,1,255,255,255,1,0,0,0,1,255,255,255,1,0,0,0,1,255,255,
  255,1,0,0,0,1,255,255,255,1,141,141,141,1,152,152,152,1,146,146,
  146,1,98,98,98,1,170,170,170,1,137,137,137,1,173,173,173,1,174,174,
  174,1,137,137,137,1,166,166,166,1,175,175,175,1,255,255,255,1,0,0,
  0,2,255,255,255,6,0,0,0,3,255,255,255,1,186,186,186,1,203,203,
  203,1,195,195,195,1,173,173,173,1,202,202,202,1,171,171,171,1,169,169,
  169,1,201,201,201,1,184,184,184,1,172,172,172,1,176,176,176,1,255,255,
  255,1,0,0,0,2,255,255,255,2,0,0,0,1,255,255,255,15,252,252,
  252,1,183,183,183,1,241,241,241,1,255,255,255,1,0,0,0,2,255,255,
  255,22,0,0,0,25,12,0,0,0,255,255,255,255,255,255,255,255,255,255,
  255,66,0,0)
 );

const
 objdata_tcoloredit: record size: integer; data: array[0..1177] of byte end =
      (size: 1178; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,10,116,99,111,
  108,111,114,101,100,105,116,23,98,105,116,109,97,112,46,116,114,97,110,115,
  112,97,114,101,110,116,99,111,108,111,114,4,6,0,0,128,14,98,105,116,
  109,97,112,46,111,112,116,105,111,110,115,11,10,98,109,111,95,109,97,115,
  107,101,100,13,98,109,111,95,99,111,108,111,114,109,97,115,107,0,12,98,
  105,116,109,97,112,46,105,109,97,103,101,10,36,4,0,0,0,0,0,0,
  6,0,0,0,24,0,0,0,24,0,0,0,220,3,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,255,255,255,120,128,128,128,25,0,0,0,22,
  255,255,255,1,128,128,128,1,0,0,0,1,0,36,255,1,0,111,255,1,
  0,187,255,1,0,255,247,1,0,255,167,1,0,255,87,1,0,255,7,1,
  68,255,0,1,143,255,0,1,218,255,0,1,255,217,0,1,255,142,0,1,
  255,67,0,1,255,0,7,1,255,0,82,1,255,0,156,1,255,0,231,1,
  198,0,255,1,118,0,255,1,39,0,255,1,224,224,224,1,255,255,255,1,
  128,128,128,1,0,0,0,1,0,36,255,1,0,111,255,1,0,187,255,1,
  0,255,247,1,0,255,167,1,0,255,87,1,0,255,7,1,68,255,0,1,
  143,255,0,1,218,255,0,1,255,217,0,1,255,142,0,1,255,67,0,1,
  255,0,7,1,255,0,82,1,255,0,156,1,255,0,231,1,0,0,0,1,
  118,0,255,1,0,0,0,1,224,224,224,1,255,255,255,1,128,128,128,1,
  0,0,0,1,0,36,255,1,0,111,255,1,0,187,255,1,0,255,247,1,
  0,255,167,1,0,255,87,1,0,255,7,1,68,255,0,1,143,255,0,1,
  218,255,0,1,255,217,0,1,255,142,0,1,255,67,0,1,255,0,7,1,
  255,0,82,1,255,0,156,1,255,0,231,1,198,0,255,1,0,0,0,1,
  39,0,255,1,224,224,224,1,255,255,255,1,128,128,128,1,0,0,0,1,
  0,36,255,1,0,111,255,1,0,187,255,1,0,255,247,1,0,255,167,1,
  0,255,87,1,0,255,7,1,68,255,0,1,143,255,0,1,218,255,0,1,
  255,217,0,1,255,142,0,1,255,67,0,1,255,0,7,1,255,0,82,1,
  255,0,156,1,255,0,231,1,198,0,255,1,0,0,0,1,39,0,255,1,
  224,224,224,1,255,255,255,1,128,128,128,1,0,0,0,1,0,36,255,1,
  0,111,255,1,0,187,255,1,0,255,247,1,0,255,167,1,0,255,87,1,
  0,255,7,1,68,255,0,1,143,255,0,1,218,255,0,1,255,217,0,1,
  255,142,0,1,255,67,0,1,255,0,7,1,255,0,82,1,255,0,156,1,
  255,0,231,1,198,0,255,1,0,0,0,1,39,0,255,1,224,224,224,1,
  255,255,255,1,128,128,128,1,0,0,0,1,0,36,255,1,0,111,255,1,
  0,187,255,1,0,255,247,1,0,255,167,1,0,255,87,1,0,255,7,1,
  68,255,0,1,143,255,0,1,218,255,0,1,255,217,0,1,255,142,0,1,
  255,67,0,1,255,0,7,1,255,0,82,1,255,0,156,1,255,0,231,1,
  198,0,255,1,0,0,0,1,39,0,255,1,224,224,224,1,255,255,255,1,
  128,128,128,1,0,0,0,1,0,36,255,1,0,111,255,1,0,187,255,1,
  0,255,247,1,0,255,167,1,0,255,87,1,0,255,7,1,68,255,0,1,
  143,255,0,1,218,255,0,1,255,217,0,1,255,142,0,1,255,67,0,1,
  255,0,7,1,255,0,82,1,255,0,156,1,255,0,231,1,198,0,255,1,
  0,0,0,1,39,0,255,1,224,224,224,1,255,255,255,1,128,128,128,1,
  0,0,0,1,0,36,255,1,0,111,255,1,0,187,255,1,0,255,247,1,
  0,255,167,1,0,255,87,1,0,255,7,1,68,255,0,1,143,255,0,1,
  218,255,0,1,255,217,0,1,255,142,0,1,255,67,0,1,255,0,7,1,
  255,0,82,1,255,0,156,1,255,0,231,1,198,0,255,1,0,0,0,1,
  39,0,255,1,224,224,224,1,255,255,255,1,128,128,128,1,0,0,0,1,
  0,36,255,1,0,111,255,1,0,187,255,1,0,255,247,1,0,255,167,1,
  0,255,87,1,0,255,7,1,68,255,0,1,143,255,0,1,218,255,0,1,
  255,217,0,1,255,142,0,1,255,67,0,1,255,0,7,1,255,0,82,1,
  255,0,156,1,255,0,231,1,0,0,0,1,118,0,255,1,0,0,0,1,
  224,224,224,1,255,255,255,1,128,128,128,1,0,0,0,1,0,36,255,1,
  0,111,255,1,0,187,255,1,0,255,247,1,0,255,167,1,0,255,87,1,
  0,255,7,1,68,255,0,1,143,255,0,1,218,255,0,1,255,217,0,1,
  255,142,0,1,255,67,0,1,255,0,7,1,255,0,82,1,255,0,156,1,
  255,0,231,1,198,0,255,1,118,0,255,1,39,0,255,1,224,224,224,1,
  255,255,255,1,128,128,128,1,224,224,224,22,255,255,255,145,16,0,0,0,
  0,0,0,120,255,255,255,255,255,255,255,81,0,0,0,120,0,0)
 );

const
 objdata_tmemodialogedit: record size: integer; data: array[0..826] of byte end =
      (size: 827; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,15,116,109,101,
  109,111,100,105,97,108,111,103,101,100,105,116,23,98,105,116,109,97,112,46,
  116,114,97,110,115,112,97,114,101,110,116,99,111,108,111,114,4,6,0,0,
  128,14,98,105,116,109,97,112,46,111,112,116,105,111,110,115,11,10,98,109,
  111,95,109,97,115,107,101,100,13,98,109,111,95,99,111,108,111,114,109,97,
  115,107,0,12,98,105,116,109,97,112,46,105,109,97,103,101,10,192,2,0,
  0,0,0,0,0,6,0,0,0,24,0,0,0,24,0,0,0,120,2,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,120,128,128,128,
  25,0,0,0,22,255,255,255,1,128,128,128,1,0,0,0,1,255,255,255,
  13,243,243,243,7,224,224,224,1,255,255,255,1,128,128,128,1,0,0,0,
  2,127,127,127,1,255,255,255,2,131,131,131,1,0,0,0,1,255,255,255,
  4,0,0,0,1,255,255,255,1,0,0,0,1,243,243,243,1,232,232,232,
  5,128,128,128,1,224,224,224,1,255,255,255,1,128,128,128,1,0,0,0,
  2,86,86,86,1,255,255,255,2,91,91,91,1,0,0,0,1,255,255,255,
  5,0,0,0,1,255,255,255,1,243,243,243,1,226,226,226,5,128,128,128,
  1,224,224,224,1,255,255,255,1,128,128,128,1,0,0,0,2,101,101,101,
  1,238,238,238,1,241,241,241,1,104,104,104,1,0,0,0,1,255,255,255,
  1,238,238,238,1,73,73,73,1,57,57,57,1,150,150,150,1,0,0,0,
  1,255,255,255,1,243,243,243,1,215,215,215,5,128,128,128,1,224,224,224,
  1,255,255,255,1,128,128,128,1,0,0,0,2,169,169,169,1,170,170,170,
  1,175,175,175,1,170,170,170,1,0,0,0,1,255,255,255,1,131,131,131,
  1,196,196,196,1,255,255,255,1,86,86,86,1,0,0,0,1,255,255,255,
  1,243,243,243,1,0,0,0,1,204,204,204,1,0,0,0,1,204,204,204,
  1,0,0,0,1,128,128,128,1,224,224,224,1,255,255,255,1,128,128,128,
  1,0,0,0,2,236,236,236,1,101,101,101,1,107,107,107,1,237,237,237,
  1,0,0,0,1,255,255,255,1,87,87,87,1,0,0,0,4,255,255,255,
  1,243,243,243,1,0,0,0,1,194,194,194,1,0,0,0,1,194,194,194,
  1,0,0,0,1,128,128,128,1,224,224,224,1,255,255,255,1,128,128,128,
  1,0,0,0,2,255,255,255,1,81,81,81,1,89,89,89,1,255,255,255,
  1,0,0,0,1,255,255,255,1,109,109,109,1,208,208,208,1,255,255,255,
  1,165,165,165,1,0,0,0,1,255,255,255,1,243,243,243,1,183,183,183,
  5,128,128,128,1,224,224,224,1,255,255,255,1,128,128,128,1,0,0,0,
  2,255,255,255,1,123,123,123,1,124,124,124,1,255,255,255,1,0,0,0,
  1,255,255,255,1,222,222,222,1,63,63,63,2,124,124,124,1,0,0,0,
  1,255,255,255,1,243,243,243,1,172,172,172,5,128,128,128,1,224,224,224,
  1,255,255,255,1,128,128,128,1,0,0,0,1,255,255,255,10,0,0,0,
  1,255,255,255,1,0,0,0,1,243,243,243,1,167,167,167,5,128,128,128,
  1,224,224,224,1,255,255,255,1,128,128,128,1,0,0,0,1,255,255,255,
  13,128,128,128,7,224,224,224,1,255,255,255,1,128,128,128,1,224,224,224,
  22,255,255,255,145,16,0,0,0,0,0,0,120,255,255,255,255,255,255,255,
  81,0,0,0,120,0,0)
 );

initialization
 registerobjectdata(@objdata_tfilelistview,tbitmapcomp,'tfilelistview');
 registerobjectdata(@objdata_tfiledialog,tbitmapcomp,'tfiledialog');
 registerobjectdata(@objdata_tfilenameedit,tbitmapcomp,'tfilenameedit');
 registerobjectdata(@objdata_tdirdropdownedit,tbitmapcomp,'tdirdropdownedit');
 registerobjectdata(@objdata_tcoloredit,tbitmapcomp,'tcoloredit');
 registerobjectdata(@objdata_tmemodialogedit,tbitmapcomp,'tmemodialogedit');
end.

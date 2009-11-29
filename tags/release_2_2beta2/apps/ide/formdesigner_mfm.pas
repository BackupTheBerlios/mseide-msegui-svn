unit formdesigner_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,formdesigner;

const
 objdata: record size: integer; data: array[0..5027] of byte end =
      (size: 5028; data: (
  84,80,70,48,15,116,102,111,114,109,100,101,115,105,103,110,101,114,102,111,
  14,102,111,114,109,100,101,115,105,103,110,101,114,102,111,13,111,112,116,105,
  111,110,115,119,105,100,103,101,116,11,13,111,119,95,97,114,114,111,119,102,
  111,99,117,115,15,111,119,95,97,114,114,111,119,102,111,99,117,115,105,110,
  16,111,119,95,97,114,114,111,119,102,111,99,117,115,111,117,116,11,111,119,
  95,115,117,98,102,111,99,117,115,17,111,119,95,100,101,115,116,114,111,121,
  119,105,100,103,101,116,115,9,111,119,95,104,105,110,116,111,110,12,111,119,
  95,97,117,116,111,115,99,97,108,101,0,7,118,105,115,105,98,108,101,8,
  8,98,111,117,110,100,115,95,120,3,196,0,8,98,111,117,110,100,115,95,
  121,3,202,0,9,98,111,117,110,100,115,95,99,120,3,31,1,9,98,111,
  117,110,100,115,95,99,121,3,44,1,23,99,111,110,116,97,105,110,101,114,
  46,111,112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,109,
  111,117,115,101,102,111,99,117,115,11,111,119,95,116,97,98,102,111,99,117,
  115,13,111,119,95,97,114,114,111,119,102,111,99,117,115,15,111,119,95,97,
  114,114,111,119,102,111,99,117,115,105,110,16,111,119,95,97,114,114,111,119,
  102,111,99,117,115,111,117,116,11,111,119,95,115,117,98,102,111,99,117,115,
  19,111,119,95,109,111,117,115,101,116,114,97,110,115,112,97,114,101,110,116,
  17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,12,111,
  119,95,97,117,116,111,115,99,97,108,101,0,29,99,111,110,116,97,105,110,
  101,114,46,111,110,99,97,108,99,109,105,110,115,99,114,111,108,108,115,105,
  122,101,7,14,99,97,108,99,115,99,114,111,108,108,115,105,122,101,21,105,
  99,111,110,46,116,114,97,110,115,112,97,114,101,110,116,99,111,108,111,114,
  4,6,0,0,128,10,105,99,111,110,46,105,109,97,103,101,10,216,7,0,
  0,0,0,0,0,0,0,0,0,24,0,0,0,24,0,0,0,164,7,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,25,242,166,149,
  1,221,216,211,1,242,166,149,1,255,134,109,2,121,64,52,1,157,83,67,
  1,187,98,80,1,208,109,89,2,247,130,106,1,212,111,91,1,255,134,109,
  4,160,160,160,6,128,128,128,1,255,255,255,1,221,216,211,1,7,239,255,
  1,221,216,211,1,255,134,109,2,120,63,51,1,201,106,86,1,181,95,77,
  1,135,71,58,1,214,112,91,1,139,73,59,1,163,86,70,1,242,127,103,
  1,255,134,109,3,160,160,160,1,212,212,212,1,128,128,128,1,160,160,160,
  1,209,209,209,1,128,128,128,2,255,255,255,1,242,166,149,1,221,216,211,
  1,242,166,149,1,255,134,109,2,212,111,91,1,255,134,109,1,218,115,93,
  1,204,107,87,1,180,95,77,1,222,117,95,1,184,97,79,1,253,133,108,
  1,255,134,109,3,160,160,160,1,212,212,212,1,128,128,128,1,160,160,160,
  1,209,209,209,1,128,128,128,2,255,255,255,1,151,24,0,16,128,128,128,
  7,255,255,255,1,230,230,230,1,229,229,229,1,228,228,228,1,227,227,227,
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
  1,208,208,208,1,128,128,128,25,7,111,110,99,108,111,115,101,7,13,102,
  111,114,109,100,101,111,110,99,108,111,115,101,4,108,101,102,116,3,239,0,
  3,116,111,112,3,180,0,15,109,111,100,117,108,101,99,108,97,115,115,110,
  97,109,101,6,8,116,109,115,101,102,111,114,109,0,10,116,112,111,112,117,
  112,109,101,110,117,7,112,111,112,117,112,109,101,18,109,101,110,117,46,115,
  117,98,109,101,110,117,46,99,111,117,110,116,2,22,18,109,101,110,117,46,
  115,117,98,109,101,110,117,46,105,116,101,109,115,14,1,7,99,97,112,116,
  105,111,110,6,20,83,104,111,119,32,111,98,106,101,99,116,105,110,115,112,
  101,99,116,111,114,5,115,116,97,116,101,11,15,97,115,95,108,111,99,97,
  108,99,97,112,116,105,111,110,17,97,115,95,108,111,99,97,108,111,110,101,
  120,101,99,117,116,101,0,9,111,110,101,120,101,99,117,116,101,7,21,100,
  111,115,104,111,119,111,98,106,101,99,116,105,110,115,112,101,99,116,111,114,
  0,1,7,99,97,112,116,105,111,110,6,21,83,104,111,119,32,99,111,109,
  112,111,110,101,110,116,112,97,108,101,116,116,101,5,115,116,97,116,101,11,
  15,97,115,95,108,111,99,97,108,99,97,112,116,105,111,110,17,97,115,95,
  108,111,99,97,108,111,110,101,120,101,99,117,116,101,0,9,111,110,101,120,
  101,99,117,116,101,7,22,100,111,115,104,111,119,99,111,109,112,111,110,101,
  110,116,112,97,108,101,116,116,101,0,1,7,99,97,112,116,105,111,110,6,
  12,83,104,111,119,32,97,115,32,84,101,120,116,5,115,116,97,116,101,11,
  15,97,115,95,108,111,99,97,108,99,97,112,116,105,111,110,17,97,115,95,
  108,111,99,97,108,111,110,101,120,101,99,117,116,101,0,7,111,112,116,105,
  111,110,115,11,19,109,97,111,95,115,104,111,114,116,99,117,116,99,97,112,
  116,105,111,110,16,109,97,111,95,97,115,121,110,99,101,120,101,99,117,116,
  101,0,9,111,110,101,120,101,99,117,116,101,7,12,100,111,115,104,111,119,
  97,115,116,101,120,116,0,1,7,111,112,116,105,111,110,115,11,13,109,97,
  111,95,115,101,112,97,114,97,116,111,114,19,109,97,111,95,115,104,111,114,
  116,99,117,116,99,97,112,116,105,111,110,0,0,1,7,99,97,112,116,105,
  111,110,6,17,67,111,112,121,32,67,111,109,112,111,110,101,110,116,40,115,
  41,4,110,97,109,101,6,4,99,111,112,121,5,115,116,97,116,101,11,15,
  97,115,95,108,111,99,97,108,99,97,112,116,105,111,110,16,97,115,95,108,
  111,99,97,108,115,104,111,114,116,99,117,116,17,97,115,95,108,111,99,97,
  108,111,110,101,120,101,99,117,116,101,0,8,115,104,111,114,116,99,117,116,
  3,67,64,9,111,110,101,120,101,99,117,116,101,7,7,99,111,112,121,101,
  120,101,0,1,7,99,97,112,116,105,111,110,6,16,67,117,116,32,67,111,
  109,112,111,110,101,110,116,40,115,41,4,110,97,109,101,6,3,99,117,116,
  5,115,116,97,116,101,11,15,97,115,95,108,111,99,97,108,99,97,112,116,
  105,111,110,16,97,115,95,108,111,99,97,108,115,104,111,114,116,99,117,116,
  17,97,115,95,108,111,99,97,108,111,110,101,120,101,99,117,116,101,0,7,
  111,112,116,105,111,110,115,11,19,109,97,111,95,115,104,111,114,116,99,117,
  116,99,97,112,116,105,111,110,16,109,97,111,95,97,115,121,110,99,101,120,
  101,99,117,116,101,0,8,115,104,111,114,116,99,117,116,3,88,64,9,111,
  110,101,120,101,99,117,116,101,7,6,99,117,116,101,120,101,0,1,7,99,
  97,112,116,105,111,110,6,18,80,97,115,116,101,32,67,111,109,112,111,110,
  101,110,116,40,115,41,4,110,97,109,101,6,5,112,97,115,116,101,5,115,
  116,97,116,101,11,15,97,115,95,108,111,99,97,108,99,97,112,116,105,111,
  110,16,97,115,95,108,111,99,97,108,115,104,111,114,116,99,117,116,17,97,
  115,95,108,111,99,97,108,111,110,101,120,101,99,117,116,101,0,8,115,104,
  111,114,116,99,117,116,3,86,64,9,111,110,101,120,101,99,117,116,101,7,
  8,112,97,115,116,101,101,120,101,0,1,7,99,97,112,116,105,111,110,6,
  19,68,101,108,101,116,101,32,67,111,109,112,111,110,101,110,116,40,115,41,
  4,110,97,109,101,6,6,100,101,108,101,116,101,5,115,116,97,116,101,11,
  15,97,115,95,108,111,99,97,108,99,97,112,116,105,111,110,16,97,115,95,
  108,111,99,97,108,115,104,111,114,116,99,117,116,17,97,115,95,108,111,99,
  97,108,111,110,101,120,101,99,117,116,101,0,7,111,112,116,105,111,110,115,
  11,19,109,97,111,95,115,104,111,114,116,99,117,116,99,97,112,116,105,111,
  110,16,109,97,111,95,97,115,121,110,99,101,120,101,99,117,116,101,0,8,
  115,104,111,114,116,99,117,116,3,7,16,9,111,110,101,120,101,99,117,116,
  101,7,9,100,101,108,101,116,101,101,120,101,0,1,7,99,97,112,116,105,
  111,110,6,21,85,110,100,101,108,101,116,101,32,67,111,109,112,111,110,101,
  110,116,40,115,41,4,110,97,109,101,6,8,117,110,100,101,108,101,116,101,
  5,115,116,97,116,101,11,15,97,115,95,108,111,99,97,108,99,97,112,116,
  105,111,110,17,97,115,95,108,111,99,97,108,111,110,101,120,101,99,117,116,
  101,0,9,111,110,101,120,101,99,117,116,101,7,11,117,110,100,101,108,101,
  116,101,101,120,101,0,1,7,111,112,116,105,111,110,115,11,13,109,97,111,
  95,115,101,112,97,114,97,116,111,114,19,109,97,111,95,115,104,111,114,116,
  99,117,116,99,97,112,116,105,111,110,0,0,1,7,99,97,112,116,105,111,
  110,6,18,83,101,108,101,99,116,32,67,104,105,108,100,119,105,100,103,101,
  116,4,110,97,109,101,6,11,115,101,108,101,99,116,99,104,105,108,100,5,
  115,116,97,116,101,11,15,97,115,95,108,111,99,97,108,99,97,112,116,105,
  111,110,0,0,1,7,99,97,112,116,105,111,110,6,14,69,100,105,116,32,
  67,111,109,112,111,110,101,110,116,4,110,97,109,101,6,8,101,100,105,116,
  99,111,109,112,5,115,116,97,116,101,11,15,97,115,95,108,111,99,97,108,
  99,97,112,116,105,111,110,17,97,115,95,108,111,99,97,108,111,110,101,120,
  101,99,117,116,101,0,9,111,110,101,120,101,99,117,116,101,7,15,100,111,
  101,100,105,116,99,111,109,112,111,110,101,110,116,0,1,7,99,97,112,116,
  105,111,110,6,14,66,114,105,110,103,32,116,111,32,70,114,111,110,116,4,
  110,97,109,101,6,10,98,114,105,110,103,116,111,102,114,111,5,115,116,97,
  116,101,11,15,97,115,95,108,111,99,97,108,99,97,112,116,105,111,110,17,
  97,115,95,108,111,99,97,108,111,110,101,120,101,99,117,116,101,0,9,111,
  110,101,120,101,99,117,116,101,7,14,100,111,98,114,105,110,103,116,111,102,
  114,111,110,116,0,1,7,99,97,112,116,105,111,110,6,12,83,101,110,100,
  32,116,111,32,66,97,99,107,4,110,97,109,101,6,8,115,101,110,100,116,
  111,98,97,5,115,116,97,116,101,11,15,97,115,95,108,111,99,97,108,99,
  97,112,116,105,111,110,17,97,115,95,108,111,99,97,108,111,110,101,120,101,
  99,117,116,101,0,9,111,110,101,120,101,99,117,116,101,7,12,100,111,115,
  101,110,100,116,111,98,97,99,107,0,1,7,99,97,112,116,105,111,110,6,
  13,83,101,116,32,84,97,98,32,79,114,100,101,114,4,110,97,109,101,6,
  9,115,101,116,116,97,98,111,114,100,5,115,116,97,116,101,11,15,97,115,
  95,108,111,99,97,108,99,97,112,116,105,111,110,17,97,115,95,108,111,99,
  97,108,111,110,101,120,101,99,117,116,101,0,9,111,110,101,120,101,99,117,
  116,101,7,13,100,111,115,101,116,116,97,98,111,114,100,101,114,0,1,7,
  99,97,112,116,105,111,110,6,18,83,101,116,32,67,114,101,97,116,105,111,
  110,32,79,114,100,101,114,5,115,116,97,116,101,11,15,97,115,95,108,111,
  99,97,108,99,97,112,116,105,111,110,17,97,115,95,108,111,99,97,108,111,
  110,101,120,101,99,117,116,101,0,9,111,110,101,120,101,99,117,116,101,7,
  18,100,111,115,101,116,99,114,101,97,116,105,111,110,111,114,100,101,114,0,
  1,7,99,97,112,116,105,111,110,6,20,83,121,110,99,46,32,116,111,32,
  70,111,110,116,32,72,101,105,103,104,116,4,110,97,109,101,6,8,115,121,
  110,99,116,111,102,111,5,115,116,97,116,101,11,15,97,115,95,108,111,99,
  97,108,99,97,112,116,105,111,110,17,97,115,95,108,111,99,97,108,111,110,
  101,120,101,99,117,116,101,0,9,111,110,101,120,101,99,117,116,101,7,16,
  100,111,115,121,110,99,102,111,110,116,104,101,105,103,104,116,0,1,7,111,
  112,116,105,111,110,115,11,13,109,97,111,95,115,101,112,97,114,97,116,111,
  114,19,109,97,111,95,115,104,111,114,116,99,117,116,99,97,112,116,105,111,
  110,0,0,1,7,99,97,112,116,105,111,110,6,10,84,111,117,99,104,32,
  70,111,114,109,5,115,116,97,116,101,11,15,97,115,95,108,111,99,97,108,
  99,97,112,116,105,111,110,17,97,115,95,108,111,99,97,108,111,110,101,120,
  101,99,117,116,101,0,9,111,110,101,120,101,99,117,116,101,7,7,100,111,
  116,111,117,99,104,0,1,7,99,97,112,116,105,111,110,6,19,82,101,118,
  101,114,116,32,116,111,32,105,110,104,101,114,105,116,101,100,4,110,97,109,
  101,6,6,114,101,118,101,114,116,5,115,116,97,116,101,11,15,97,115,95,
  108,111,99,97,108,99,97,112,116,105,111,110,17,97,115,95,108,111,99,97,
  108,111,110,101,120,101,99,117,116,101,0,7,111,112,116,105,111,110,115,11,
  19,109,97,111,95,115,104,111,114,116,99,117,116,99,97,112,116,105,111,110,
  16,109,97,111,95,97,115,121,110,99,101,120,101,99,117,116,101,0,9,111,
  110,101,120,101,99,117,116,101,7,9,114,101,118,101,114,116,101,120,101,0,
  1,7,99,97,112,116,105,111,110,6,16,73,110,115,101,114,116,32,83,117,
  98,109,111,100,117,108,101,4,110,97,109,101,6,9,105,110,115,101,114,116,
  115,117,98,5,115,116,97,116,101,11,15,97,115,95,108,111,99,97,108,99,
  97,112,116,105,111,110,17,97,115,95,108,111,99,97,108,111,110,101,120,101,
  99,117,116,101,0,9,111,110,101,120,101,99,117,116,101,7,17,100,111,105,
  110,115,101,114,116,115,117,98,109,111,100,117,108,101,0,1,7,99,97,112,
  116,105,111,110,6,16,73,110,115,101,114,116,32,99,111,109,112,111,110,101,
  110,116,4,110,97,109,101,6,10,105,110,115,101,114,116,99,111,109,112,5,
  115,116,97,116,101,11,15,97,115,95,108,111,99,97,108,99,97,112,116,105,
  111,110,17,97,115,95,108,111,99,97,108,111,110,101,120,101,99,117,116,101,
  0,9,111,110,101,120,101,99,117,116,101,7,17,100,111,105,110,115,101,114,
  116,99,111,109,112,111,110,101,110,116,0,0,4,108,101,102,116,2,48,3,
  116,111,112,2,40,0,0,0)
 );

initialization
 registerobjectdata(@objdata,tformdesignerfo,'');
end.
unit watchpointsform_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,watchpointsform;

const
 objdata: record size: integer; data: array[0..9420] of byte end =
      (size: 9421; data: (
  84,80,70,48,14,116,119,97,116,99,104,112,111,105,110,116,115,102,111,13,
  119,97,116,99,104,112,111,105,110,116,115,102,111,13,111,112,116,105,111,110,
  115,119,105,100,103,101,116,11,13,111,119,95,97,114,114,111,119,102,111,99,
  117,115,15,111,119,95,97,114,114,111,119,102,111,99,117,115,105,110,16,111,
  119,95,97,114,114,111,119,102,111,99,117,115,111,117,116,11,111,119,95,115,
  117,98,102,111,99,117,115,17,111,119,95,100,101,115,116,114,111,121,119,105,
  100,103,101,116,115,9,111,119,95,104,105,110,116,111,110,12,111,119,95,97,
  117,116,111,115,99,97,108,101,0,16,102,114,97,109,101,46,108,111,99,97,
  108,112,114,111,112,115,11,18,102,114,108,95,102,114,97,109,101,105,109,97,
  103,101,108,101,102,116,17,102,114,108,95,102,114,97,109,101,105,109,97,103,
  101,116,111,112,19,102,114,108,95,102,114,97,109,101,105,109,97,103,101,114,
  105,103,104,116,20,102,114,108,95,102,114,97,109,101,105,109,97,103,101,98,
  111,116,116,111,109,20,102,114,108,95,102,114,97,109,101,105,109,97,103,101,
  111,102,102,115,101,116,28,102,114,108,95,102,114,97,109,101,105,109,97,103,
  101,111,102,102,115,101,116,100,105,115,97,98,108,101,100,25,102,114,108,95,
  102,114,97,109,101,105,109,97,103,101,111,102,102,115,101,116,109,111,117,115,
  101,27,102,114,108,95,102,114,97,109,101,105,109,97,103,101,111,102,102,115,
  101,116,99,108,105,99,107,101,100,26,102,114,108,95,102,114,97,109,101,105,
  109,97,103,101,111,102,102,115,101,116,97,99,116,105,118,101,31,102,114,108,
  95,102,114,97,109,101,105,109,97,103,101,111,102,102,115,101,116,97,99,116,
  105,118,101,109,111,117,115,101,33,102,114,108,95,102,114,97,109,101,105,109,
  97,103,101,111,102,102,115,101,116,97,99,116,105,118,101,99,108,105,99,107,
  101,100,15,102,114,108,95,111,112,116,105,111,110,115,115,107,105,110,0,15,
  102,114,97,109,101,46,103,114,105,112,95,115,105,122,101,2,10,18,102,114,
  97,109,101,46,103,114,105,112,95,111,112,116,105,111,110,115,11,14,103,111,
  95,99,108,111,115,101,98,117,116,116,111,110,16,103,111,95,102,105,120,115,
  105,122,101,98,117,116,116,111,110,12,103,111,95,116,111,112,98,117,116,116,
  111,110,0,11,102,114,97,109,101,46,100,117,109,109,121,2,0,7,118,105,
  115,105,98,108,101,8,8,98,111,117,110,100,115,95,120,2,120,8,98,111,
  117,110,100,115,95,121,3,112,1,9,98,111,117,110,100,115,95,99,120,3,
  227,1,9,98,111,117,110,100,115,95,99,121,3,210,0,23,99,111,110,116,
  97,105,110,101,114,46,111,112,116,105,111,110,115,119,105,100,103,101,116,11,
  13,111,119,95,109,111,117,115,101,102,111,99,117,115,11,111,119,95,116,97,
  98,102,111,99,117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,115,
  15,111,119,95,97,114,114,111,119,102,111,99,117,115,105,110,16,111,119,95,
  97,114,114,111,119,102,111,99,117,115,111,117,116,11,111,119,95,115,117,98,
  102,111,99,117,115,19,111,119,95,109,111,117,115,101,116,114,97,110,115,112,
  97,114,101,110,116,17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,
  101,116,115,12,111,119,95,97,117,116,111,115,99,97,108,101,0,26,99,111,
  110,116,97,105,110,101,114,46,102,114,97,109,101,46,108,111,99,97,108,112,
  114,111,112,115,11,18,102,114,108,95,102,114,97,109,101,105,109,97,103,101,
  108,101,102,116,17,102,114,108,95,102,114,97,109,101,105,109,97,103,101,116,
  111,112,19,102,114,108,95,102,114,97,109,101,105,109,97,103,101,114,105,103,
  104,116,20,102,114,108,95,102,114,97,109,101,105,109,97,103,101,98,111,116,
  116,111,109,20,102,114,108,95,102,114,97,109,101,105,109,97,103,101,111,102,
  102,115,101,116,28,102,114,108,95,102,114,97,109,101,105,109,97,103,101,111,
  102,102,115,101,116,100,105,115,97,98,108,101,100,25,102,114,108,95,102,114,
  97,109,101,105,109,97,103,101,111,102,102,115,101,116,109,111,117,115,101,27,
  102,114,108,95,102,114,97,109,101,105,109,97,103,101,111,102,102,115,101,116,
  99,108,105,99,107,101,100,26,102,114,108,95,102,114,97,109,101,105,109,97,
  103,101,111,102,102,115,101,116,97,99,116,105,118,101,31,102,114,108,95,102,
  114,97,109,101,105,109,97,103,101,111,102,102,115,101,116,97,99,116,105,118,
  101,109,111,117,115,101,33,102,114,108,95,102,114,97,109,101,105,109,97,103,
  101,111,102,102,115,101,116,97,99,116,105,118,101,99,108,105,99,107,101,100,
  15,102,114,108,95,111,112,116,105,111,110,115,115,107,105,110,0,16,99,111,
  110,116,97,105,110,101,114,46,98,111,117,110,100,115,1,2,0,2,0,3,
  217,1,3,210,0,0,16,100,114,97,103,100,111,99,107,46,99,97,112,116,
  105,111,110,6,11,87,97,116,99,104,112,111,105,110,116,115,20,100,114,97,
  103,100,111,99,107,46,111,112,116,105,111,110,115,100,111,99,107,11,10,111,
  100,95,115,97,118,101,112,111,115,10,111,100,95,99,97,110,109,111,118,101,
  11,111,100,95,99,97,110,102,108,111,97,116,10,111,100,95,99,97,110,100,
  111,99,107,11,111,100,95,112,114,111,112,115,105,122,101,0,7,111,112,116,
  105,111,110,115,11,10,102,111,95,115,97,118,101,112,111,115,12,102,111,95,
  115,97,118,101,115,116,97,116,101,0,8,115,116,97,116,102,105,108,101,7,
  22,109,97,105,110,102,111,46,112,114,111,106,101,99,116,115,116,97,116,102,
  105,108,101,7,99,97,112,116,105,111,110,6,11,87,97,116,99,104,112,111,
  105,110,116,115,21,105,99,111,110,46,116,114,97,110,115,112,97,114,101,110,
  116,99,111,108,111,114,4,6,0,0,128,10,105,99,111,110,46,105,109,97,
  103,101,10,172,7,0,0,0,0,0,0,0,0,0,0,24,0,0,0,24,
  0,0,0,120,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,245,
  245,245,1,243,243,243,1,242,242,242,1,240,240,240,1,238,238,238,1,237,
  237,237,1,235,235,235,1,234,234,234,1,232,232,232,1,230,230,230,1,229,
  229,229,1,227,227,227,1,226,226,226,1,224,224,224,1,223,223,223,1,221,
  221,221,1,219,219,219,1,218,218,218,1,216,216,216,1,215,215,215,1,213,
  213,213,1,211,211,211,1,210,210,210,1,208,208,208,1,245,245,245,1,243,
  243,243,1,242,242,242,1,240,240,240,1,238,238,238,1,237,237,237,1,235,
  235,235,1,234,234,234,1,232,232,232,1,230,230,230,1,229,229,229,1,227,
  227,227,1,226,226,226,1,224,224,224,1,223,223,223,1,221,221,221,1,219,
  219,219,1,218,218,218,1,216,216,216,1,215,215,215,1,213,213,213,1,211,
  211,211,1,210,210,210,1,208,208,208,1,245,245,245,1,243,243,243,1,242,
  242,242,1,240,240,240,1,238,238,238,1,237,237,237,1,235,235,235,1,234,
  234,234,1,214,214,214,1,104,104,104,1,55,55,55,1,22,22,22,1,24,
  24,24,1,57,57,57,1,101,101,101,1,202,202,202,1,219,219,219,1,218,
  218,218,1,216,216,216,1,215,215,215,1,213,213,213,1,211,211,211,1,210,
  210,210,1,208,208,208,1,245,245,245,1,243,243,243,1,242,242,242,1,240,
  240,240,1,238,238,238,1,237,237,237,1,235,235,235,1,159,159,159,1,15,
  15,15,1,0,0,0,6,13,13,13,1,139,139,139,1,218,218,218,1,216,
  216,216,1,215,215,215,1,213,213,213,1,211,211,211,1,210,210,210,1,208,
  208,208,1,245,245,245,1,243,243,243,1,242,242,242,1,240,240,240,1,238,
  238,238,1,237,237,237,1,197,197,197,1,10,10,10,1,0,0,0,1,27,
  27,28,1,125,125,158,1,129,129,224,1,127,127,221,1,124,124,157,1,28,
  28,29,1,0,0,0,1,4,4,4,1,170,170,170,1,216,216,216,1,215,
  215,215,1,213,213,213,1,211,211,211,1,210,210,210,1,208,208,208,1,245,
  245,245,1,243,243,243,1,242,242,242,1,240,240,240,1,238,238,238,1,237,
  237,237,1,65,65,65,1,0,0,0,1,6,6,12,1,6,6,221,1,0,
  0,255,4,6,6,234,1,10,10,22,1,0,0,0,1,42,42,42,1,216,
  216,216,1,215,215,215,1,213,213,213,1,211,211,211,1,210,210,210,1,208,
  208,208,1,245,245,245,1,243,243,243,1,242,242,242,1,240,240,240,1,238,
  238,238,1,229,229,229,1,6,6,7,1,0,0,0,1,0,0,119,1,0,
  0,255,6,0,0,141,1,0,0,0,1,1,1,2,1,204,204,204,1,215,
  215,215,1,213,213,213,1,211,211,211,1,210,210,210,1,208,208,208,1,245,
  245,245,1,243,243,243,1,242,242,242,1,240,240,240,1,238,238,238,1,197,
  197,203,1,11,11,70,1,0,0,42,1,0,0,197,1,0,0,255,6,0,
  0,177,1,0,0,0,2,168,168,174,1,214,214,214,1,213,213,213,1,211,
  211,211,1,210,210,210,1,208,208,208,1,245,245,245,1,243,243,243,1,242,
  242,242,1,240,240,240,1,238,238,238,1,115,115,246,1,0,0,255,9,0,
  0,122,1,0,0,0,1,0,0,22,1,54,54,184,1,201,201,201,1,212,
  212,212,1,211,211,211,1,210,210,210,1,208,208,208,1,245,245,245,1,243,
  243,243,1,242,242,242,1,240,240,240,1,233,233,238,1,7,7,254,1,0,
  0,255,8,0,0,199,1,0,0,11,1,0,0,0,1,0,0,95,1,3,
  3,250,1,134,134,139,1,210,210,210,1,211,211,211,1,210,210,210,1,208,
  208,208,1,245,245,245,1,243,243,243,1,242,242,242,1,240,240,240,1,192,
  192,241,1,0,0,255,8,0,0,209,1,0,0,17,1,0,0,0,1,0,
  0,49,1,0,0,241,1,0,0,255,1,81,81,130,1,176,176,176,1,210,
  210,210,2,208,208,208,1,245,245,245,1,243,243,243,1,242,242,242,1,240,
  240,240,1,144,144,245,1,0,0,255,7,0,0,204,1,0,0,18,1,0,
  0,0,1,0,0,34,1,0,0,232,1,0,0,255,2,60,60,161,1,145,
  145,145,1,209,209,209,1,210,210,210,1,208,208,208,1,245,245,245,1,243,
  243,243,1,242,242,242,1,240,240,240,1,144,144,245,1,0,0,255,6,0,
  0,226,1,0,0,15,1,0,0,0,1,0,0,28,1,0,0,220,1,0,
  0,255,3,59,59,160,1,122,122,122,1,209,209,209,1,210,210,210,1,208,
  208,208,1,245,245,245,1,243,243,243,1,242,242,242,1,240,240,240,1,192,
  192,241,1,0,0,255,6,0,0,86,1,0,0,0,1,0,0,24,1,0,
  0,219,1,0,0,255,4,78,78,127,1,106,106,106,1,208,208,208,1,210,
  210,210,1,208,208,208,1,245,245,245,1,243,243,243,1,242,242,242,1,240,
  240,240,1,233,233,238,1,7,7,254,1,0,0,255,4,0,0,252,1,0,
  0,7,1,0,0,0,1,0,0,150,1,0,0,255,4,3,3,250,1,96,
  96,101,1,122,122,122,1,209,209,209,1,210,210,210,1,208,208,208,1,245,
  245,245,1,243,243,243,1,242,242,242,1,240,240,240,1,238,238,238,1,114,
  114,245,1,0,0,255,4,0,0,216,1,0,0,0,2,0,0,213,1,0,
  0,255,4,47,47,178,1,99,99,99,1,145,145,145,1,209,209,209,1,210,
  210,210,1,208,208,208,1,245,245,245,1,243,243,243,1,242,242,242,1,240,
  240,240,1,238,238,238,1,230,230,236,1,33,33,244,1,0,0,255,3,0,
  0,190,1,0,0,8,2,0,0,237,1,0,0,255,3,17,17,228,1,95,
  95,101,1,100,100,100,1,176,176,176,1,210,210,210,2,208,208,208,1,245,
  245,245,1,243,243,243,1,242,242,242,1,240,240,240,1,238,238,238,1,237,
  237,237,1,194,194,235,1,26,26,237,1,0,0,255,8,17,17,228,1,82,
  82,123,1,99,99,99,1,137,137,137,1,210,210,210,1,211,211,211,1,210,
  210,210,1,208,208,208,1,245,245,245,1,243,243,243,1,242,242,242,1,240,
  240,240,1,238,238,238,1,237,237,237,1,234,234,234,1,213,213,219,1,58,
  58,189,1,3,3,250,1,0,0,255,4,3,3,250,1,49,49,180,1,97,
  97,103,1,100,100,100,1,112,112,112,1,201,201,201,1,212,212,212,1,211,
  211,211,1,210,210,210,1,208,208,208,1,245,245,245,1,243,243,243,1,242,
  242,242,1,240,240,240,1,238,238,238,1,237,237,237,1,235,235,235,1,233,
  233,233,1,217,217,217,1,143,143,148,1,52,52,82,1,2,2,5,1,2,
  2,4,1,57,57,91,1,99,99,104,1,101,101,101,2,138,138,138,1,202,
  202,202,1,214,214,214,1,213,213,213,1,211,211,211,1,210,210,210,1,208,
  208,208,1,245,245,245,1,243,243,243,1,242,242,242,1,240,240,240,1,238,
  238,238,1,237,237,237,1,235,235,235,1,234,234,234,1,231,231,231,1,227,
  227,227,1,112,112,112,1,0,0,0,2,77,77,77,1,128,128,128,1,150,
  150,150,1,181,181,181,1,215,215,215,3,213,213,213,1,211,211,211,1,210,
  210,210,1,208,208,208,1,245,245,245,1,243,243,243,1,242,242,242,1,240,
  240,240,1,238,238,238,1,237,237,237,1,235,235,235,1,234,234,234,1,232,
  232,232,1,230,230,230,1,158,158,158,1,56,56,56,1,55,55,55,1,169,
  169,169,1,220,220,220,1,219,219,219,1,218,218,218,2,216,216,216,1,215,
  215,215,1,213,213,213,1,211,211,211,1,210,210,210,1,208,208,208,1,245,
  245,245,1,243,243,243,1,242,242,242,1,240,240,240,1,238,238,238,1,237,
  237,237,1,235,235,235,1,234,234,234,1,232,232,232,1,230,230,230,1,229,
  229,229,1,227,227,227,1,226,226,226,1,224,224,224,1,223,223,223,1,221,
  221,221,1,219,219,219,1,218,218,218,1,216,216,216,1,215,215,215,1,213,
  213,213,1,211,211,211,1,210,210,210,1,208,208,208,1,245,245,245,1,243,
  243,243,1,242,242,242,1,240,240,240,1,238,238,238,1,237,237,237,1,235,
  235,235,1,234,234,234,1,232,232,232,1,230,230,230,1,229,229,229,1,227,
  227,227,1,226,226,226,1,224,224,224,1,223,223,223,1,221,221,221,1,219,
  219,219,1,218,218,218,1,216,216,216,1,215,215,215,1,213,213,213,1,211,
  211,211,1,210,210,210,1,208,208,208,1,6,111,110,115,104,111,119,7,17,
  119,97,116,99,104,112,111,105,110,116,115,111,110,115,104,111,119,15,109,111,
  100,117,108,101,99,108,97,115,115,110,97,109,101,6,9,116,100,111,99,107,
  102,111,114,109,0,11,116,119,105,100,103,101,116,103,114,105,100,4,103,114,
  105,100,13,111,112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,
  95,109,111,117,115,101,102,111,99,117,115,11,111,119,95,116,97,98,102,111,
  99,117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,115,15,111,119,
  95,97,114,114,111,119,102,111,99,117,115,105,110,16,111,119,95,97,114,114,
  111,119,102,111,99,117,115,111,117,116,17,111,119,95,102,111,99,117,115,98,
  97,99,107,111,110,101,115,99,13,111,119,95,109,111,117,115,101,119,104,101,
  101,108,17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,
  18,111,119,95,102,111,110,116,103,108,121,112,104,104,101,105,103,104,116,12,
  111,119,95,97,117,116,111,115,99,97,108,101,0,16,102,114,97,109,101,46,
  108,111,99,97,108,112,114,111,112,115,11,18,102,114,108,95,102,114,97,109,
  101,105,109,97,103,101,108,101,102,116,17,102,114,108,95,102,114,97,109,101,
  105,109,97,103,101,116,111,112,19,102,114,108,95,102,114,97,109,101,105,109,
  97,103,101,114,105,103,104,116,20,102,114,108,95,102,114,97,109,101,105,109,
  97,103,101,98,111,116,116,111,109,20,102,114,108,95,102,114,97,109,101,105,
  109,97,103,101,111,102,102,115,101,116,28,102,114,108,95,102,114,97,109,101,
  105,109,97,103,101,111,102,102,115,101,116,100,105,115,97,98,108,101,100,25,
  102,114,108,95,102,114,97,109,101,105,109,97,103,101,111,102,102,115,101,116,
  109,111,117,115,101,27,102,114,108,95,102,114,97,109,101,105,109,97,103,101,
  111,102,102,115,101,116,99,108,105,99,107,101,100,26,102,114,108,95,102,114,
  97,109,101,105,109,97,103,101,111,102,102,115,101,116,97,99,116,105,118,101,
  31,102,114,108,95,102,114,97,109,101,105,109,97,103,101,111,102,102,115,101,
  116,97,99,116,105,118,101,109,111,117,115,101,33,102,114,108,95,102,114,97,
  109,101,105,109,97,103,101,111,102,102,115,101,116,97,99,116,105,118,101,99,
  108,105,99,107,101,100,15,102,114,108,95,111,112,116,105,111,110,115,115,107,
  105,110,0,8,116,97,98,111,114,100,101,114,2,1,9,112,111,112,117,112,
  109,101,110,117,7,8,103,114,105,112,111,112,117,112,8,98,111,117,110,100,
  115,95,120,2,0,8,98,111,117,110,100,115,95,121,2,25,9,98,111,117,
  110,100,115,95,99,120,3,217,1,9,98,111,117,110,100,115,95,99,121,3,
  185,0,7,97,110,99,104,111,114,115,11,6,97,110,95,116,111,112,9,97,
  110,95,98,111,116,116,111,109,0,11,111,112,116,105,111,110,115,103,114,105,
  100,11,12,111,103,95,99,111,108,115,105,122,105,110,103,12,111,103,95,114,
  111,119,109,111,118,105,110,103,15,111,103,95,114,111,119,105,110,115,101,114,
  116,105,110,103,14,111,103,95,114,111,119,100,101,108,101,116,105,110,103,19,
  111,103,95,102,111,99,117,115,99,101,108,108,111,110,101,110,116,101,114,15,
  111,103,95,97,117,116,111,102,105,114,115,116,114,111,119,13,111,103,95,97,
  117,116,111,97,112,112,101,110,100,20,111,103,95,99,111,108,99,104,97,110,
  103,101,111,110,116,97,98,107,101,121,10,111,103,95,119,114,97,112,99,111,
  108,12,111,103,95,97,117,116,111,112,111,112,117,112,0,13,102,105,120,114,
  111,119,115,46,99,111,117,110,116,2,1,13,102,105,120,114,111,119,115,46,
  105,116,101,109,115,14,1,6,104,101,105,103,104,116,2,16,14,99,97,112,
  116,105,111,110,115,46,99,111,117,110,116,2,7,14,99,97,112,116,105,111,
  110,115,46,105,116,101,109,115,14,1,7,99,97,112,116,105,111,110,6,2,
  111,110,0,1,7,99,97,112,116,105,111,110,6,4,75,105,110,100,0,1,
  7,99,97,112,116,105,111,110,6,11,69,120,112,114,101,115,115,115,105,111,
  110,0,1,0,1,7,99,97,112,116,105,111,110,6,5,67,111,117,110,116,
  0,1,7,99,97,112,116,105,111,110,6,6,73,103,110,111,114,101,0,1,
  7,99,97,112,116,105,111,110,6,9,67,111,110,100,105,116,105,111,110,0,
  0,0,0,14,100,97,116,97,99,111,108,115,46,99,111,117,110,116,2,7,
  14,100,97,116,97,99,111,108,115,46,105,116,101,109,115,14,1,5,119,105,
  100,116,104,2,16,7,111,112,116,105,111,110,115,11,12,99,111,95,100,114,
  97,119,102,111,99,117,115,12,99,111,95,115,97,118,101,115,116,97,116,101,
  10,99,111,95,114,111,119,102,111,110,116,11,99,111,95,114,111,119,99,111,
  108,111,114,13,99,111,95,122,101,98,114,97,99,111,108,111,114,0,10,119,
  105,100,103,101,116,110,97,109,101,6,5,119,112,116,111,110,9,100,97,116,
  97,99,108,97,115,115,7,20,116,103,114,105,100,105,110,116,101,103,101,114,
  100,97,116,97,108,105,115,116,0,1,5,119,105,100,116,104,2,33,7,111,
  112,116,105,111,110,115,11,12,99,111,95,115,97,118,101,118,97,108,117,101,
  12,99,111,95,115,97,118,101,115,116,97,116,101,10,99,111,95,114,111,119,
  102,111,110,116,11,99,111,95,114,111,119,99,111,108,111,114,13,99,111,95,
  122,101,98,114,97,99,111,108,111,114,0,10,119,105,100,103,101,116,110,97,
  109,101,6,7,119,112,116,107,105,110,100,9,100,97,116,97,99,108,97,115,
  115,7,17,116,103,114,105,100,101,110,117,109,100,97,116,97,108,105,115,116,
  0,1,5,119,105,100,116,104,3,158,0,7,111,112,116,105,111,110,115,11,
  15,99,111,95,112,114,111,112,111,114,116,105,111,110,97,108,12,99,111,95,
  115,97,118,101,118,97,108,117,101,12,99,111,95,115,97,118,101,115,116,97,
  116,101,10,99,111,95,114,111,119,102,111,110,116,11,99,111,95,114,111,119,
  99,111,108,111,114,13,99,111,95,122,101,98,114,97,99,111,108,111,114,0,
  10,119,105,100,103,101,116,110,97,109,101,6,13,119,112,116,101,120,112,114,
  101,115,115,105,111,110,9,100,97,116,97,99,108,97,115,115,7,22,116,103,
  114,105,100,109,115,101,115,116,114,105,110,103,100,97,116,97,108,105,115,116,
  0,1,5,119,105,100,116,104,2,9,7,111,112,116,105,111,110,115,11,12,
  99,111,95,105,110,118,105,115,105,98,108,101,10,99,111,95,114,111,119,102,
  111,110,116,11,99,111,95,114,111,119,99,111,108,111,114,13,99,111,95,122,
  101,98,114,97,99,111,108,111,114,0,10,119,105,100,103,101,116,110,97,109,
  101,6,5,119,112,116,110,111,9,100,97,116,97,99,108,97,115,115,7,20,
  116,103,114,105,100,105,110,116,101,103,101,114,100,97,116,97,108,105,115,116,
  0,1,5,99,111,108,111,114,4,7,0,0,144,5,119,105,100,116,104,2,
  34,7,111,112,116,105,111,110,115,11,11,99,111,95,114,101,97,100,111,110,
  108,121,10,99,111,95,110,111,102,111,99,117,115,12,99,111,95,115,97,118,
  101,115,116,97,116,101,10,99,111,95,114,111,119,102,111,110,116,11,99,111,
  95,114,111,119,99,111,108,111,114,13,99,111,95,122,101,98,114,97,99,111,
  108,111,114,0,10,119,105,100,103,101,116,110,97,109,101,6,8,119,112,116,
  99,111,117,110,116,9,100,97,116,97,99,108,97,115,115,7,20,116,103,114,
  105,100,105,110,116,101,103,101,114,100,97,116,97,108,105,115,116,0,1,5,
  119,105,100,116,104,2,38,7,111,112,116,105,111,110,115,11,12,99,111,95,
  115,97,118,101,118,97,108,117,101,12,99,111,95,115,97,118,101,115,116,97,
  116,101,10,99,111,95,114,111,119,102,111,110,116,11,99,111,95,114,111,119,
  99,111,108,111,114,13,99,111,95,122,101,98,114,97,99,111,108,111,114,0,
  10,119,105,100,103,101,116,110,97,109,101,6,9,119,112,116,105,103,110,111,
  114,101,9,100,97,116,97,99,108,97,115,115,7,20,116,103,114,105,100,105,
  110,116,101,103,101,114,100,97,116,97,108,105,115,116,0,1,5,119,105,100,
  116,104,3,174,0,7,111,112,116,105,111,110,115,11,7,99,111,95,102,105,
  108,108,12,99,111,95,115,97,118,101,118,97,108,117,101,12,99,111,95,115,
  97,118,101,115,116,97,116,101,10,99,111,95,114,111,119,102,111,110,116,11,
  99,111,95,114,111,119,99,111,108,111,114,13,99,111,95,122,101,98,114,97,
  99,111,108,111,114,0,10,119,105,100,103,101,116,110,97,109,101,6,12,119,
  112,116,99,111,110,100,105,116,105,111,110,9,100,97,116,97,99,108,97,115,
  115,7,22,116,103,114,105,100,109,115,101,115,116,114,105,110,103,100,97,116,
  97,108,105,115,116,0,0,13,100,97,116,97,114,111,119,104,101,105,103,104,
  116,2,16,8,115,116,97,116,102,105,108,101,7,22,109,97,105,110,102,111,
  46,112,114,111,106,101,99,116,115,116,97,116,102,105,108,101,14,111,110,114,
  111,119,115,100,101,108,101,116,105,110,103,7,9,100,101,108,101,116,101,114,
  111,119,13,114,101,102,102,111,110,116,104,101,105,103,104,116,2,14,0,12,
  116,98,111,111,108,101,97,110,101,100,105,116,5,119,112,116,111,110,11,111,
  112,116,105,111,110,115,115,107,105,110,11,19,111,115,107,95,102,114,97,109,
  101,98,117,116,116,111,110,111,110,108,121,0,12,102,114,97,109,101,46,108,
  101,118,101,108,111,2,0,17,102,114,97,109,101,46,99,111,108,111,114,99,
  108,105,101,110,116,4,3,0,0,128,16,102,114,97,109,101,46,108,111,99,
  97,108,112,114,111,112,115,11,10,102,114,108,95,108,101,118,101,108,111,15,
  102,114,108,95,99,111,108,111,114,99,108,105,101,110,116,0,11,102,114,97,
  109,101,46,100,117,109,109,121,2,0,8,116,97,98,111,114,100,101,114,2,
  1,8,98,111,117,110,100,115,95,120,2,0,8,98,111,117,110,100,115,95,
  121,2,0,9,98,111,117,110,100,115,95,99,120,2,16,9,98,111,117,110,
  100,115,95,99,121,2,16,11,111,112,116,105,111,110,115,101,100,105,116,11,
  12,111,101,95,117,110,100,111,111,110,101,115,99,13,111,101,95,99,108,111,
  115,101,113,117,101,114,121,16,111,101,95,99,104,101,99,107,109,114,99,97,
  110,99,101,108,15,111,101,95,101,120,105,116,111,110,99,117,114,115,111,114,
  12,111,101,95,101,97,116,114,101,116,117,114,110,20,111,101,95,114,101,115,
  101,116,115,101,108,101,99,116,111,110,101,120,105,116,13,111,101,95,97,117,
  116,111,115,101,108,101,99,116,25,111,101,95,97,117,116,111,115,101,108,101,
  99,116,111,110,102,105,114,115,116,99,108,105,99,107,16,111,101,95,97,117,
  116,111,112,111,112,117,112,109,101,110,117,12,111,101,95,115,97,118,101,115,
  116,97,116,101,0,7,118,105,115,105,98,108,101,8,10,111,110,115,101,116,
  118,97,108,117,101,7,15,119,112,116,111,110,111,110,115,101,116,118,97,108,
  117,101,0,0,9,116,101,110,117,109,101,100,105,116,7,119,112,116,107,105,
  110,100,13,111,112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,
  95,109,111,117,115,101,102,111,99,117,115,11,111,119,95,116,97,98,102,111,
  99,117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,115,15,111,119,
  95,97,114,114,111,119,102,111,99,117,115,105,110,16,111,119,95,97,114,114,
  111,119,102,111,99,117,115,111,117,116,17,111,119,95,100,101,115,116,114,111,
  121,119,105,100,103,101,116,115,18,111,119,95,102,111,110,116,103,108,121,112,
  104,104,101,105,103,104,116,12,111,119,95,97,117,116,111,115,99,97,108,101,
  0,11,111,112,116,105,111,110,115,115,107,105,110,11,19,111,115,107,95,102,
  114,97,109,101,98,117,116,116,111,110,111,110,108,121,0,12,102,114,97,109,
  101,46,108,101,118,101,108,111,2,0,17,102,114,97,109,101,46,99,111,108,
  111,114,99,108,105,101,110,116,4,3,0,0,128,16,102,114,97,109,101,46,
  108,111,99,97,108,112,114,111,112,115,11,10,102,114,108,95,108,101,118,101,
  108,111,15,102,114,108,95,99,111,108,111,114,99,108,105,101,110,116,0,18,
  102,114,97,109,101,46,98,117,116,116,111,110,46,99,111,108,111,114,4,2,
  0,0,128,8,116,97,98,111,114,100,101,114,2,2,7,118,105,115,105,98,
  108,101,8,8,98,111,117,110,100,115,95,120,2,17,8,98,111,117,110,100,
  115,95,121,2,0,9,98,111,117,110,100,115,95,99,120,2,33,9,98,111,
  117,110,100,115,95,99,121,2,16,9,116,101,120,116,102,108,97,103,115,11,
  12,116,102,95,120,99,101,110,116,101,114,101,100,12,116,102,95,121,99,101,
  110,116,101,114,101,100,11,116,102,95,110,111,115,101,108,101,99,116,0,13,
  111,110,100,97,116,97,101,110,116,101,114,101,100,7,16,119,112,116,111,110,
  100,97,116,97,101,110,116,101,114,101,100,5,118,97,108,117,101,2,0,12,
  118,97,108,117,101,100,101,102,97,117,108,116,2,0,3,109,105,110,2,0,
  3,109,97,120,2,2,19,100,114,111,112,100,111,119,110,46,99,111,108,115,
  46,99,111,117,110,116,2,1,19,100,114,111,112,100,111,119,110,46,99,111,
  108,115,46,105,116,101,109,115,14,1,4,100,97,116,97,1,6,1,87,6,
  3,82,47,87,6,1,82,0,0,0,18,100,114,111,112,100,111,119,110,46,
  105,116,101,109,105,110,100,101,120,2,0,13,114,101,102,102,111,110,116,104,
  101,105,103,104,116,2,14,0,0,11,116,115,116,114,105,110,103,101,100,105,
  116,13,119,112,116,101,120,112,114,101,115,115,105,111,110,13,111,112,116,105,
  111,110,115,119,105,100,103,101,116,11,13,111,119,95,109,111,117,115,101,102,
  111,99,117,115,11,111,119,95,116,97,98,102,111,99,117,115,13,111,119,95,
  97,114,114,111,119,102,111,99,117,115,15,111,119,95,97,114,114,111,119,102,
  111,99,117,115,105,110,16,111,119,95,97,114,114,111,119,102,111,99,117,115,
  111,117,116,17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,
  115,18,111,119,95,102,111,110,116,103,108,121,112,104,104,101,105,103,104,116,
  0,11,111,112,116,105,111,110,115,115,107,105,110,11,19,111,115,107,95,102,
  114,97,109,101,98,117,116,116,111,110,111,110,108,121,0,12,102,114,97,109,
  101,46,108,101,118,101,108,111,2,0,17,102,114,97,109,101,46,99,111,108,
  111,114,99,108,105,101,110,116,4,3,0,0,128,16,102,114,97,109,101,46,
  108,111,99,97,108,112,114,111,112,115,11,10,102,114,108,95,108,101,118,101,
  108,111,15,102,114,108,95,99,111,108,111,114,99,108,105,101,110,116,0,11,
  102,114,97,109,101,46,100,117,109,109,121,2,0,8,116,97,98,111,114,100,
  101,114,2,3,7,118,105,115,105,98,108,101,8,8,98,111,117,110,100,115,
  95,120,2,51,8,98,111,117,110,100,115,95,121,2,0,9,98,111,117,110,
  100,115,95,99,120,3,158,0,9,98,111,117,110,100,115,95,99,121,2,16,
  13,111,110,100,97,116,97,101,110,116,101,114,101,100,7,16,119,112,116,111,
  110,100,97,116,97,101,110,116,101,114,101,100,13,114,101,102,102,111,110,116,
  104,101,105,103,104,116,2,14,0,0,12,116,105,110,116,101,103,101,114,101,
  100,105,116,5,119,112,116,110,111,13,111,112,116,105,111,110,115,119,105,100,
  103,101,116,11,13,111,119,95,109,111,117,115,101,102,111,99,117,115,11,111,
  119,95,116,97,98,102,111,99,117,115,13,111,119,95,97,114,114,111,119,102,
  111,99,117,115,15,111,119,95,97,114,114,111,119,102,111,99,117,115,105,110,
  16,111,119,95,97,114,114,111,119,102,111,99,117,115,111,117,116,17,111,119,
  95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,18,111,119,95,102,
  111,110,116,103,108,121,112,104,104,101,105,103,104,116,0,11,111,112,116,105,
  111,110,115,115,107,105,110,11,19,111,115,107,95,102,114,97,109,101,98,117,
  116,116,111,110,111,110,108,121,0,12,102,114,97,109,101,46,108,101,118,101,
  108,111,2,0,17,102,114,97,109,101,46,99,111,108,111,114,99,108,105,101,
  110,116,4,3,0,0,128,16,102,114,97,109,101,46,108,111,99,97,108,112,
  114,111,112,115,11,10,102,114,108,95,108,101,118,101,108,111,15,102,114,108,
  95,99,111,108,111,114,99,108,105,101,110,116,0,11,102,114,97,109,101,46,
  100,117,109,109,121,2,0,8,116,97,98,111,114,100,101,114,2,4,7,118,
  105,115,105,98,108,101,8,8,98,111,117,110,100,115,95,120,3,210,0,8,
  98,111,117,110,100,115,95,121,2,0,9,98,111,117,110,100,115,95,99,120,
  2,9,9,98,111,117,110,100,115,95,99,121,2,16,11,111,112,116,105,111,
  110,115,101,100,105,116,11,12,111,101,95,117,110,100,111,111,110,101,115,99,
  13,111,101,95,99,108,111,115,101,113,117,101,114,121,16,111,101,95,99,104,
  101,99,107,109,114,99,97,110,99,101,108,15,111,101,95,101,120,105,116,111,
  110,99,117,114,115,111,114,12,111,101,95,101,97,116,114,101,116,117,114,110,
  20,111,101,95,114,101,115,101,116,115,101,108,101,99,116,111,110,101,120,105,
  116,13,111,101,95,97,117,116,111,115,101,108,101,99,116,25,111,101,95,97,
  117,116,111,115,101,108,101,99,116,111,110,102,105,114,115,116,99,108,105,99,
  107,16,111,101,95,97,117,116,111,112,111,112,117,112,109,101,110,117,12,111,
  101,95,115,97,118,101,115,116,97,116,101,0,13,114,101,102,102,111,110,116,
  104,101,105,103,104,116,2,14,0,0,12,116,105,110,116,101,103,101,114,101,
  100,105,116,8,119,112,116,99,111,117,110,116,13,111,112,116,105,111,110,115,
  119,105,100,103,101,116,11,13,111,119,95,109,111,117,115,101,102,111,99,117,
  115,11,111,119,95,116,97,98,102,111,99,117,115,13,111,119,95,97,114,114,
  111,119,102,111,99,117,115,15,111,119,95,97,114,114,111,119,102,111,99,117,
  115,105,110,16,111,119,95,97,114,114,111,119,102,111,99,117,115,111,117,116,
  17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,18,111,
  119,95,102,111,110,116,103,108,121,112,104,104,101,105,103,104,116,0,11,111,
  112,116,105,111,110,115,115,107,105,110,11,19,111,115,107,95,102,114,97,109,
  101,98,117,116,116,111,110,111,110,108,121,0,12,102,114,97,109,101,46,108,
  101,118,101,108,111,2,0,17,102,114,97,109,101,46,99,111,108,111,114,99,
  108,105,101,110,116,4,3,0,0,128,16,102,114,97,109,101,46,108,111,99,
  97,108,112,114,111,112,115,11,10,102,114,108,95,108,101,118,101,108,111,15,
  102,114,108,95,99,111,108,111,114,99,108,105,101,110,116,0,11,102,114,97,
  109,101,46,100,117,109,109,121,2,0,8,116,97,98,111,114,100,101,114,2,
  5,7,118,105,115,105,98,108,101,8,8,98,111,117,110,100,115,95,120,3,
  220,0,8,98,111,117,110,100,115,95,121,2,0,9,98,111,117,110,100,115,
  95,99,120,2,34,9,98,111,117,110,100,115,95,99,121,2,16,11,111,112,
  116,105,111,110,115,101,100,105,116,11,11,111,101,95,114,101,97,100,111,110,
  108,121,12,111,101,95,117,110,100,111,111,110,101,115,99,13,111,101,95,99,
  108,111,115,101,113,117,101,114,121,16,111,101,95,99,104,101,99,107,109,114,
  99,97,110,99,101,108,15,111,101,95,101,120,105,116,111,110,99,117,114,115,
  111,114,12,111,101,95,101,97,116,114,101,116,117,114,110,20,111,101,95,114,
  101,115,101,116,115,101,108,101,99,116,111,110,101,120,105,116,13,111,101,95,
  97,117,116,111,115,101,108,101,99,116,25,111,101,95,97,117,116,111,115,101,
  108,101,99,116,111,110,102,105,114,115,116,99,108,105,99,107,16,111,101,95,
  97,117,116,111,112,111,112,117,112,109,101,110,117,12,111,101,95,115,97,118,
  101,115,116,97,116,101,0,13,114,101,102,102,111,110,116,104,101,105,103,104,
  116,2,14,0,0,12,116,105,110,116,101,103,101,114,101,100,105,116,9,119,
  112,116,105,103,110,111,114,101,13,111,112,116,105,111,110,115,119,105,100,103,
  101,116,11,13,111,119,95,109,111,117,115,101,102,111,99,117,115,11,111,119,
  95,116,97,98,102,111,99,117,115,13,111,119,95,97,114,114,111,119,102,111,
  99,117,115,15,111,119,95,97,114,114,111,119,102,111,99,117,115,105,110,16,
  111,119,95,97,114,114,111,119,102,111,99,117,115,111,117,116,17,111,119,95,
  100,101,115,116,114,111,121,119,105,100,103,101,116,115,18,111,119,95,102,111,
  110,116,103,108,121,112,104,104,101,105,103,104,116,0,11,111,112,116,105,111,
  110,115,115,107,105,110,11,19,111,115,107,95,102,114,97,109,101,98,117,116,
  116,111,110,111,110,108,121,0,12,102,114,97,109,101,46,108,101,118,101,108,
  111,2,0,17,102,114,97,109,101,46,99,111,108,111,114,99,108,105,101,110,
  116,4,3,0,0,128,16,102,114,97,109,101,46,108,111,99,97,108,112,114,
  111,112,115,11,10,102,114,108,95,108,101,118,101,108,111,15,102,114,108,95,
  99,111,108,111,114,99,108,105,101,110,116,0,11,102,114,97,109,101,46,100,
  117,109,109,121,2,0,8,116,97,98,111,114,100,101,114,2,6,7,118,105,
  115,105,98,108,101,8,8,98,111,117,110,100,115,95,120,3,255,0,8,98,
  111,117,110,100,115,95,121,2,0,9,98,111,117,110,100,115,95,99,120,2,
  38,9,98,111,117,110,100,115,95,99,121,2,16,11,111,112,116,105,111,110,
  115,101,100,105,116,11,12,111,101,95,117,110,100,111,111,110,101,115,99,13,
  111,101,95,99,108,111,115,101,113,117,101,114,121,16,111,101,95,99,104,101,
  99,107,109,114,99,97,110,99,101,108,15,111,101,95,101,120,105,116,111,110,
  99,117,114,115,111,114,14,111,101,95,115,104,105,102,116,114,101,116,117,114,
  110,24,111,101,95,102,111,114,99,101,114,101,116,117,114,110,99,104,101,99,
  107,118,97,108,117,101,12,111,101,95,101,97,116,114,101,116,117,114,110,20,
  111,101,95,114,101,115,101,116,115,101,108,101,99,116,111,110,101,120,105,116,
  13,111,101,95,101,110,100,111,110,101,110,116,101,114,13,111,101,95,97,117,
  116,111,115,101,108,101,99,116,25,111,101,95,97,117,116,111,115,101,108,101,
  99,116,111,110,102,105,114,115,116,99,108,105,99,107,16,111,101,95,97,117,
  116,111,112,111,112,117,112,109,101,110,117,13,111,101,95,107,101,121,101,120,
  101,99,117,116,101,12,111,101,95,115,97,118,101,118,97,108,117,101,12,111,
  101,95,115,97,118,101,115,116,97,116,101,0,13,111,110,100,97,116,97,101,
  110,116,101,114,101,100,7,16,119,112,116,111,110,100,97,116,97,101,110,116,
  101,114,101,100,13,114,101,102,102,111,110,116,104,101,105,103,104,116,2,14,
  0,0,11,116,115,116,114,105,110,103,101,100,105,116,12,119,112,116,99,111,
  110,100,105,116,105,111,110,13,111,112,116,105,111,110,115,119,105,100,103,101,
  116,11,13,111,119,95,109,111,117,115,101,102,111,99,117,115,11,111,119,95,
  116,97,98,102,111,99,117,115,13,111,119,95,97,114,114,111,119,102,111,99,
  117,115,15,111,119,95,97,114,114,111,119,102,111,99,117,115,105,110,16,111,
  119,95,97,114,114,111,119,102,111,99,117,115,111,117,116,17,111,119,95,100,
  101,115,116,114,111,121,119,105,100,103,101,116,115,18,111,119,95,102,111,110,
  116,103,108,121,112,104,104,101,105,103,104,116,0,11,111,112,116,105,111,110,
  115,115,107,105,110,11,19,111,115,107,95,102,114,97,109,101,98,117,116,116,
  111,110,111,110,108,121,0,12,102,114,97,109,101,46,108,101,118,101,108,111,
  2,0,17,102,114,97,109,101,46,99,111,108,111,114,99,108,105,101,110,116,
  4,3,0,0,128,16,102,114,97,109,101,46,108,111,99,97,108,112,114,111,
  112,115,11,10,102,114,108,95,108,101,118,101,108,111,15,102,114,108,95,99,
  111,108,111,114,99,108,105,101,110,116,0,11,102,114,97,109,101,46,100,117,
  109,109,121,2,0,8,116,97,98,111,114,100,101,114,2,7,7,118,105,115,
  105,98,108,101,8,8,98,111,117,110,100,115,95,120,3,38,1,8,98,111,
  117,110,100,115,95,121,2,0,9,98,111,117,110,100,115,95,99,120,3,174,
  0,9,98,111,117,110,100,115,95,99,121,2,16,13,111,110,100,97,116,97,
  101,110,116,101,114,101,100,7,16,119,112,116,111,110,100,97,116,97,101,110,
  116,101,114,101,100,13,114,101,102,102,111,110,116,104,101,105,103,104,116,2,
  14,0,0,0,6,116,108,97,98,101,108,7,116,108,97,98,101,108,49,13,
  111,112,116,105,111,110,115,119,105,100,103,101,116,11,17,111,119,95,100,101,
  115,116,114,111,121,119,105,100,103,101,116,115,12,111,119,95,97,117,116,111,
  115,99,97,108,101,0,8,98,111,117,110,100,115,95,120,2,0,8,98,111,
  117,110,100,115,95,121,2,0,9,98,111,117,110,100,115,95,99,120,3,89,
  1,9,98,111,117,110,100,115,95,99,121,2,14,7,97,110,99,104,111,114,
  115,11,6,97,110,95,116,111,112,0,7,99,97,112,116,105,111,110,6,66,
  72,105,110,116,58,32,39,67,111,117,110,116,39,44,32,39,73,103,110,111,
  114,101,39,32,97,110,100,32,39,67,111,110,100,105,116,105,111,110,39,32,
  100,111,110,39,116,32,119,111,114,107,32,119,105,116,104,32,119,105,110,51,
  50,32,71,68,66,46,0,0,10,116,112,111,112,117,112,109,101,110,117,8,
  103,114,105,112,111,112,117,112,18,109,101,110,117,46,115,117,98,109,101,110,
  117,46,99,111,117,110,116,2,1,18,109,101,110,117,46,115,117,98,109,101,
  110,117,46,105,116,101,109,115,14,1,7,99,97,112,116,105,111,110,6,10,
  68,101,108,101,116,101,32,97,108,108,5,115,116,97,116,101,11,15,97,115,
  95,108,111,99,97,108,99,97,112,116,105,111,110,17,97,115,95,108,111,99,
  97,108,111,110,101,120,101,99,117,116,101,0,9,111,110,101,120,101,99,117,
  116,101,7,18,100,101,108,101,116,101,97,108,108,111,110,101,120,101,99,117,
  116,101,0,0,9,109,101,110,117,46,110,97,109,101,6,9,103,114,105,100,
  112,111,112,117,112,4,108,101,102,116,2,112,3,116,111,112,2,88,0,0,
  0)
 );

initialization
 registerobjectdata(@objdata,twatchpointsfo,'');
end.
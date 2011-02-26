unit disassform_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,disassform;

const
 objdata: record size: integer; data: array[0..3905] of byte end =
      (size: 3906; data: (
  84,80,70,48,9,116,100,105,115,97,115,115,102,111,8,100,105,115,97,115,
  115,102,111,13,111,112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,
  119,95,97,114,114,111,119,102,111,99,117,115,15,111,119,95,97,114,114,111,
  119,102,111,99,117,115,105,110,16,111,119,95,97,114,114,111,119,102,111,99,
  117,115,111,117,116,11,111,119,95,115,117,98,102,111,99,117,115,17,111,119,
  95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,9,111,119,95,104,
  105,110,116,111,110,12,111,119,95,97,117,116,111,115,99,97,108,101,0,15,
  102,114,97,109,101,46,103,114,105,112,95,115,105,122,101,2,10,18,102,114,
  97,109,101,46,103,114,105,112,95,111,112,116,105,111,110,115,11,14,103,111,
  95,99,108,111,115,101,98,117,116,116,111,110,16,103,111,95,102,105,120,115,
  105,122,101,98,117,116,116,111,110,12,103,111,95,116,111,112,98,117,116,116,
  111,110,0,11,102,114,97,109,101,46,100,117,109,109,121,2,0,10,111,110,
  97,99,116,105,118,97,116,101,7,3,97,99,116,12,111,110,100,101,97,99,
  116,105,118,97,116,101,7,5,100,101,97,99,116,7,118,105,115,105,98,108,
  101,8,8,98,111,117,110,100,115,95,120,3,162,0,8,98,111,117,110,100,
  115,95,121,3,246,1,9,98,111,117,110,100,115,95,99,120,3,52,2,9,
  98,111,117,110,100,115,95,99,121,3,210,0,23,99,111,110,116,97,105,110,
  101,114,46,111,112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,
  95,109,111,117,115,101,102,111,99,117,115,11,111,119,95,116,97,98,102,111,
  99,117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,115,15,111,119,
  95,97,114,114,111,119,102,111,99,117,115,105,110,16,111,119,95,97,114,114,
  111,119,102,111,99,117,115,111,117,116,11,111,119,95,115,117,98,102,111,99,
  117,115,19,111,119,95,109,111,117,115,101,116,114,97,110,115,112,97,114,101,
  110,116,17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,
  12,111,119,95,97,117,116,111,115,99,97,108,101,0,16,99,111,110,116,97,
  105,110,101,114,46,98,111,117,110,100,115,1,2,0,2,0,3,42,2,3,
  210,0,0,22,100,114,97,103,100,111,99,107,46,115,112,108,105,116,116,101,
  114,95,115,105,122,101,2,0,16,100,114,97,103,100,111,99,107,46,99,97,
  112,116,105,111,110,6,9,65,115,115,101,109,98,108,101,114,20,100,114,97,
  103,100,111,99,107,46,111,112,116,105,111,110,115,100,111,99,107,11,10,111,
  100,95,115,97,118,101,112,111,115,13,111,100,95,115,97,118,101,122,111,114,
  100,101,114,10,111,100,95,99,97,110,109,111,118,101,11,111,100,95,99,97,
  110,102,108,111,97,116,10,111,100,95,99,97,110,100,111,99,107,11,111,100,
  95,112,114,111,112,115,105,122,101,0,7,111,112,116,105,111,110,115,11,10,
  102,111,95,115,97,118,101,112,111,115,13,102,111,95,115,97,118,101,122,111,
  114,100,101,114,12,102,111,95,115,97,118,101,115,116,97,116,101,0,8,115,
  116,97,116,102,105,108,101,7,22,109,97,105,110,102,111,46,112,114,111,106,
  101,99,116,115,116,97,116,102,105,108,101,7,99,97,112,116,105,111,110,6,
  9,65,115,115,101,109,98,108,101,114,21,105,99,111,110,46,116,114,97,110,
  115,112,97,114,101,110,116,99,111,108,111,114,4,6,0,0,128,12,105,99,
  111,110,46,111,112,116,105,111,110,115,11,10,98,109,111,95,109,97,115,107,
  101,100,0,10,105,99,111,110,46,105,109,97,103,101,10,136,7,0,0,0,
  0,0,0,2,0,0,0,24,0,0,0,24,0,0,0,244,6,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,208,208,208,25,136,136,136,13,130,
  136,136,1,136,136,136,1,208,208,208,9,136,136,136,1,179,248,254,1,182,
  248,254,1,185,249,254,1,188,250,254,1,191,250,254,1,194,251,254,1,198,
  251,254,1,201,252,254,1,204,253,254,1,207,253,254,1,210,254,254,1,213,
  254,254,1,127,135,135,1,159,197,200,1,136,136,136,1,208,208,208,8,136,
  136,136,1,179,248,254,1,182,248,254,1,185,249,254,1,188,250,254,1,191,
  250,254,1,194,251,254,1,198,251,254,1,201,252,254,1,204,253,254,1,207,
  253,254,1,210,254,254,1,213,254,254,1,131,137,138,1,198,249,255,1,158,
  197,200,1,136,136,136,1,208,208,208,7,136,136,136,1,179,248,254,1,182,
  248,254,1,185,249,254,1,188,250,254,1,191,250,254,1,194,251,254,1,198,
  251,254,1,201,252,254,1,204,253,254,1,207,253,254,1,210,254,254,1,213,
  254,254,1,133,138,138,1,226,252,255,1,197,249,255,1,158,197,200,1,136,
  136,136,1,208,208,208,6,136,136,136,1,179,248,254,1,182,248,254,1,185,
  249,254,1,188,250,254,1,191,250,254,1,194,251,254,1,198,251,254,1,201,
  252,254,1,204,253,254,1,207,253,254,1,210,254,254,1,213,254,254,1,130,
  137,138,1,254,254,255,1,225,252,255,1,195,249,255,1,158,197,200,1,136,
  136,136,1,208,208,208,5,136,136,136,1,179,248,254,1,182,248,254,1,185,
  249,254,1,188,250,254,1,191,250,254,1,194,251,254,1,198,251,254,1,201,
  252,254,1,204,253,254,1,207,253,254,1,210,254,254,1,213,254,254,1,127,
  137,138,1,223,252,255,1,252,254,255,1,223,252,255,1,194,249,255,1,157,
  196,200,1,136,136,136,1,208,208,208,4,136,136,136,1,179,248,254,1,182,
  248,254,1,185,249,254,1,188,250,254,1,191,250,254,1,194,251,254,1,198,
  251,254,1,201,252,254,1,204,253,254,1,207,253,254,1,210,254,254,1,213,
  254,254,1,124,137,138,1,190,249,255,1,225,252,255,1,250,254,255,1,221,
  252,255,1,192,249,255,1,157,196,200,1,136,136,136,1,208,208,208,3,136,
  136,136,1,179,248,254,1,182,248,254,1,185,249,254,1,188,250,254,1,191,
  250,254,1,194,251,254,1,198,251,254,1,201,252,254,1,204,253,254,1,207,
  253,254,1,210,254,254,1,213,254,254,1,121,137,138,1,158,246,255,1,192,
  249,255,1,227,252,255,1,249,254,255,1,220,251,255,1,190,249,255,1,157,
  196,200,1,136,136,136,1,208,208,208,2,136,136,136,1,179,248,254,1,182,
  248,254,1,185,249,254,1,188,250,254,1,191,250,254,1,194,251,254,1,198,
  251,254,1,201,252,254,1,204,253,254,1,207,253,254,1,210,254,254,1,213,
  254,254,1,130,150,151,1,120,137,138,1,122,137,138,1,124,137,138,1,126,
  137,138,2,122,137,138,1,119,134,135,1,129,136,136,1,208,208,208,2,136,
  136,136,1,179,248,254,1,182,248,254,1,185,249,254,1,188,250,254,1,191,
  250,254,1,194,251,254,1,198,251,254,1,201,252,254,1,204,253,254,1,207,
  253,254,1,210,254,254,1,213,254,254,1,206,253,254,1,191,252,254,1,176,
  250,254,1,162,248,254,1,147,246,254,1,132,244,254,1,117,243,254,1,102,
  241,254,1,136,136,136,1,208,208,208,2,136,136,136,1,179,248,254,1,182,
  248,254,1,185,249,254,1,188,250,254,1,191,250,254,1,194,251,254,1,198,
  251,254,1,201,252,254,1,204,253,254,1,207,253,254,1,210,254,254,1,213,
  254,254,1,206,253,254,1,191,252,254,1,176,250,254,1,162,248,254,1,147,
  246,254,1,132,244,254,1,117,243,254,1,102,241,254,1,136,136,136,1,208,
  208,208,2,136,136,136,1,179,248,254,1,182,248,254,1,175,235,240,1,87,
  116,118,1,55,73,74,1,125,161,163,1,198,251,254,1,201,252,254,1,204,
  253,254,1,198,242,243,1,73,89,89,1,213,254,254,1,206,253,254,1,191,
  252,254,1,109,155,157,1,49,75,77,1,66,111,115,1,128,237,247,1,117,
  243,254,1,102,241,254,1,136,136,136,1,208,208,208,2,136,136,136,1,179,
  248,254,1,182,248,254,1,77,104,106,1,98,130,132,1,170,223,226,1,42,
  54,55,1,157,199,201,1,201,252,254,1,173,214,215,1,50,61,61,1,13,
  16,16,1,213,254,254,1,206,253,254,1,142,188,189,1,44,63,64,1,148,
  227,232,1,68,114,118,1,61,113,118,1,117,243,254,1,102,241,254,1,136,
  136,136,1,208,208,208,2,136,136,136,1,179,248,254,1,182,248,254,1,20,
  26,27,1,167,222,225,1,191,250,254,1,99,128,129,1,94,119,121,1,201,
  252,254,1,94,117,118,1,157,192,193,1,26,31,31,1,213,254,254,1,206,
  253,254,1,84,111,112,1,97,138,140,1,162,248,254,1,124,207,214,1,19,
  34,36,1,117,243,254,1,102,241,254,1,136,136,136,1,208,208,208,2,136,
  136,136,1,179,248,254,1,178,243,249,1,16,21,22,1,188,250,254,1,191,
  250,254,1,132,170,172,1,71,90,91,1,201,252,254,1,204,253,254,1,207,
  253,254,1,26,31,31,1,213,254,254,1,206,253,254,1,61,80,81,1,131,
  186,189,1,162,248,254,1,145,242,250,1,7,13,14,1,117,243,254,1,102,
  241,254,1,136,136,136,1,208,208,208,2,136,136,136,1,179,248,254,1,179,
  244,250,1,12,16,16,1,188,250,254,1,191,250,254,1,126,162,164,1,78,
  98,100,1,201,252,254,1,204,253,254,1,207,253,254,1,26,31,31,1,213,
  254,254,1,206,253,254,1,61,81,82,1,128,181,184,1,162,248,254,1,142,
  238,246,1,9,17,18,1,117,243,254,1,102,241,254,1,136,136,136,1,208,
  208,208,2,136,136,136,1,179,248,254,1,182,248,254,1,17,23,24,1,167,
  223,226,1,191,250,254,1,93,120,122,1,104,132,133,1,201,252,254,1,204,
  253,254,1,207,253,254,1,26,31,31,1,213,254,254,1,206,253,254,1,82,
  108,109,1,98,139,141,1,162,248,254,1,119,200,206,1,25,47,49,1,117,
  243,254,1,102,241,254,1,136,136,136,1,208,208,208,2,136,136,136,1,179,
  248,254,1,182,248,254,1,91,122,125,1,75,100,102,1,141,184,187,1,36,
  46,47,1,173,220,222,1,201,252,254,1,204,253,254,1,207,253,254,1,26,
  31,31,1,213,254,254,1,206,253,254,1,154,204,205,1,36,51,52,1,122,
  187,191,1,49,82,85,1,78,144,150,1,117,243,254,1,102,241,254,1,136,
  136,136,1,208,208,208,2,136,136,136,1,179,248,254,1,182,248,254,1,185,
  249,254,1,140,186,189,1,91,119,121,1,157,203,205,1,198,251,254,1,201,
  252,254,1,204,253,254,1,207,253,254,1,118,142,142,1,213,254,254,1,206,
  253,254,1,191,252,254,1,155,220,223,1,79,122,125,1,97,163,168,1,131,
  243,253,1,117,243,254,1,102,241,254,1,136,136,136,1,208,208,208,2,136,
  136,136,1,179,248,254,1,182,248,254,1,185,249,254,1,188,250,254,1,191,
  250,254,1,194,251,254,1,198,251,254,1,201,252,254,1,204,253,254,1,207,
  253,254,1,210,254,254,1,213,254,254,1,206,253,254,1,191,252,254,1,176,
  250,254,1,162,248,254,1,147,246,254,1,132,244,254,1,117,243,254,1,102,
  241,254,1,136,136,136,1,208,208,208,2,136,136,136,1,179,248,254,1,182,
  248,254,1,185,249,254,1,188,250,254,1,191,250,254,1,194,251,254,1,198,
  251,254,1,201,252,254,1,204,253,254,1,207,253,254,1,210,254,254,1,213,
  254,254,1,206,253,254,1,191,252,254,1,176,250,254,1,162,248,254,1,147,
  246,254,1,132,244,254,1,117,243,254,1,102,241,254,1,136,136,136,1,208,
  208,208,2,136,136,136,22,208,208,208,25,0,0,0,8,254,255,0,8,254,
  255,1,191,254,255,3,8,254,255,7,0,254,255,15,8,254,255,31,2,254,
  255,63,192,254,255,127,0,254,255,127,8,254,255,127,0,254,255,127,8,254,
  255,127,8,254,255,127,8,254,255,127,191,254,255,127,8,254,255,127,0,254,
  255,127,2,254,255,127,8,254,255,127,0,254,255,127,0,254,255,127,191,254,
  255,127,0,0,0,0,8,6,111,110,115,104,111,119,7,14,100,105,115,97,
  115,115,102,111,111,110,115,104,111,119,15,109,111,100,117,108,101,99,108,97,
  115,115,110,97,109,101,6,9,116,100,111,99,107,102,111,114,109,0,11,116,
  115,116,114,105,110,103,103,114,105,100,4,103,114,105,100,13,111,112,116,105,
  111,110,115,119,105,100,103,101,116,11,13,111,119,95,109,111,117,115,101,102,
  111,99,117,115,11,111,119,95,116,97,98,102,111,99,117,115,13,111,119,95,
  97,114,114,111,119,102,111,99,117,115,15,111,119,95,97,114,114,111,119,102,
  111,99,117,115,105,110,16,111,119,95,97,114,114,111,119,102,111,99,117,115,
  111,117,116,17,111,119,95,102,111,99,117,115,98,97,99,107,111,110,101,115,
  99,13,111,119,95,109,111,117,115,101,119,104,101,101,108,17,111,119,95,100,
  101,115,116,114,111,121,119,105,100,103,101,116,115,18,111,119,95,102,111,110,
  116,103,108,121,112,104,104,101,105,103,104,116,12,111,119,95,97,117,116,111,
  115,99,97,108,101,0,5,99,111,108,111,114,4,5,0,0,144,8,98,111,
  117,110,100,115,95,120,2,0,8,98,111,117,110,100,115,95,121,2,0,9,
  98,111,117,110,100,115,95,99,120,3,42,2,9,98,111,117,110,100,115,95,
  99,121,3,210,0,7,97,110,99,104,111,114,115,11,0,9,111,110,107,101,
  121,100,111,119,110,7,5,107,101,121,100,111,11,111,112,116,105,111,110,115,
  103,114,105,100,11,12,111,103,95,99,111,108,115,105,122,105,110,103,20,111,
  103,95,99,111,108,99,104,97,110,103,101,111,110,116,97,98,107,101,121,10,
  111,103,95,119,114,97,112,99,111,108,12,111,103,95,97,117,116,111,112,111,
  112,117,112,0,14,100,97,116,97,99,111,108,115,46,99,111,117,110,116,2,
  2,16,100,97,116,97,99,111,108,115,46,111,112,116,105,111,110,115,11,11,
  99,111,95,114,101,97,100,111,110,108,121,12,99,111,95,100,114,97,119,102,
  111,99,117,115,12,99,111,95,115,97,118,101,115,116,97,116,101,0,14,100,
  97,116,97,99,111,108,115,46,105,116,101,109,115,14,1,5,119,105,100,116,
  104,2,76,16,111,110,98,101,102,111,114,101,100,114,97,119,99,101,108,108,
  7,11,98,101,102,100,114,97,119,99,101,108,108,7,111,112,116,105,111,110,
  115,11,11,99,111,95,114,101,97,100,111,110,108,121,12,99,111,95,100,114,
  97,119,102,111,99,117,115,12,99,111,95,115,97,118,101,115,116,97,116,101,
  11,99,111,95,114,111,119,99,111,108,111,114,0,11,111,110,99,101,108,108,
  101,118,101,110,116,7,13,97,100,100,114,99,101,108,108,101,118,101,110,116,
  9,116,101,120,116,102,108,97,103,115,11,8,116,102,95,114,105,103,104,116,
  12,116,102,95,121,99,101,110,116,101,114,101,100,11,116,102,95,110,111,115,
  101,108,101,99,116,0,15,116,101,120,116,102,108,97,103,115,97,99,116,105,
  118,101,11,8,116,102,95,114,105,103,104,116,12,116,102,95,121,99,101,110,
  116,101,114,101,100,0,11,111,112,116,105,111,110,115,101,100,105,116,11,14,
  115,99,111,101,95,101,97,116,114,101,116,117,114,110,20,115,99,111,101,95,
  104,105,110,116,99,108,105,112,112,101,100,116,101,120,116,0,9,102,111,110,
  116,46,110,97,109,101,6,9,115,116,102,95,102,105,120,101,100,11,102,111,
  110,116,46,120,115,99,97,108,101,5,0,0,0,0,0,0,0,128,255,63,
  10,102,111,110,116,46,100,117,109,109,121,2,0,0,1,5,119,105,100,116,
  104,3,216,1,7,111,112,116,105,111,110,115,11,11,99,111,95,114,101,97,
  100,111,110,108,121,12,99,111,95,100,114,97,119,102,111,99,117,115,7,99,
  111,95,102,105,108,108,12,99,111,95,115,97,118,101,115,116,97,116,101,11,
  99,111,95,114,111,119,99,111,108,111,114,0,9,116,101,120,116,102,108,97,
  103,115,11,12,116,102,95,121,99,101,110,116,101,114,101,100,11,116,102,95,
  110,111,115,101,108,101,99,116,13,116,102,95,116,97,98,116,111,115,112,97,
  99,101,0,15,116,101,120,116,102,108,97,103,115,97,99,116,105,118,101,11,
  12,116,102,95,121,99,101,110,116,101,114,101,100,13,116,102,95,116,97,98,
  116,111,115,112,97,99,101,0,11,111,112,116,105,111,110,115,101,100,105,116,
  11,14,115,99,111,101,95,101,97,116,114,101,116,117,114,110,20,115,99,111,
  101,95,104,105,110,116,99,108,105,112,112,101,100,116,101,120,116,0,0,0,
  15,114,111,119,99,111,108,111,114,115,46,99,111,117,110,116,2,2,15,114,
  111,119,99,111,108,111,114,115,46,105,116,101,109,115,1,4,255,255,224,0,
  4,224,255,255,0,0,13,100,97,116,97,114,111,119,104,101,105,103,104,116,
  2,16,12,111,110,115,99,114,111,108,108,114,111,119,115,7,10,115,99,114,
  111,108,108,114,111,119,115,13,114,101,102,102,111,110,116,104,101,105,103,104,
  116,2,14,0,0,0)
 );

initialization
 registerobjectdata(@objdata,tdisassfo,'');
end.

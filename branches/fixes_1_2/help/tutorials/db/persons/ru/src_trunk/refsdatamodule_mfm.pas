unit refsdatamodule_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface

implementation
uses
 mseclasses,refsdatamodule;

const
 objdata: record size: integer; data: array[0..4414] of byte end =
      (size: 4415; data: (
  84,80,70,48,11,116,114,101,102,115,100,97,116,97,109,111,10,114,101,102,
  115,100,97,116,97,109,111,4,108,101,102,116,3,162,0,3,116,111,112,3,
  223,0,15,109,111,100,117,108,101,99,108,97,115,115,110,97,109,101,6,14,
  116,109,115,101,100,97,116,97,109,111,100,117,108,101,4,115,105,122,101,1,
  3,161,1,3,186,0,0,0,12,116,109,115,101,115,113,108,113,117,101,114,
  121,10,113,114,121,80,108,97,110,101,116,115,6,65,99,116,105,118,101,9,
  8,100,97,116,97,98,97,115,101,7,11,109,97,105,110,102,111,46,99,111,
  110,110,11,84,114,97,110,115,97,99,116,105,111,110,7,12,109,97,105,110,
  102,111,46,116,114,97,110,115,6,112,97,114,97,109,115,14,0,11,83,81,
  76,46,83,116,114,105,110,103,115,1,6,34,115,101,108,101,99,116,32,42,
  32,102,114,111,109,32,112,108,97,110,101,116,115,32,111,114,100,101,114,32,
  98,121,32,105,100,59,0,9,73,110,100,101,120,68,101,102,115,14,0,18,
  85,115,101,80,114,105,109,97,114,121,75,101,121,65,115,75,101,121,8,13,
  83,116,97,116,101,109,101,110,116,84,121,112,101,7,8,115,116,83,101,108,
  101,99,116,9,70,105,101,108,100,68,101,102,115,14,1,4,78,97,109,101,
  6,2,105,100,8,68,97,116,97,84,121,112,101,7,9,102,116,73,110,116,
  101,103,101,114,9,80,114,101,99,105,115,105,111,110,2,255,4,83,105,122,
  101,2,4,0,1,4,78,97,109,101,6,5,100,101,115,99,114,8,68,97,
  116,97,84,121,112,101,7,6,102,116,77,101,109,111,9,80,114,101,99,105,
  115,105,111,110,2,255,4,83,105,122,101,2,4,0,0,23,99,111,110,116,
  114,111,108,108,101,114,46,102,105,101,108,100,115,46,99,111,117,110,116,2,
  2,24,99,111,110,116,114,111,108,108,101,114,46,102,105,101,108,100,115,46,
  102,105,101,108,100,115,1,1,7,10,102,116,95,108,111,110,103,105,110,116,
  7,7,102,116,95,109,101,109,111,0,14,1,9,65,108,105,103,110,77,101,
  110,116,7,14,116,97,82,105,103,104,116,74,117,115,116,105,102,121,12,68,
  105,115,112,108,97,121,87,105,100,116,104,2,10,9,70,105,101,108,100,78,
  97,109,101,6,2,105,100,13,80,114,111,118,105,100,101,114,70,108,97,103,
  115,11,7,112,102,73,110,75,101,121,0,0,1,12,68,105,115,112,108,97,
  121,87,105,100,116,104,2,10,9,70,105,101,108,100,78,97,109,101,6,5,
  100,101,115,99,114,5,73,110,100,101,120,2,1,4,83,105,122,101,2,4,
  13,84,114,97,110,115,108,105,116,101,114,97,116,101,8,0,0,0,4,108,
  101,102,116,2,16,3,116,111,112,2,16,0,0,12,116,109,115,101,115,113,
  108,113,117,101,114,121,13,113,114,121,67,111,110,116,105,110,101,110,116,115,
  6,65,99,116,105,118,101,9,10,66,101,102,111,114,101,79,112,101,110,7,
  23,113,114,121,99,111,110,116,105,110,101,110,116,115,98,101,102,111,114,101,
  111,112,101,110,8,100,97,116,97,98,97,115,101,7,11,109,97,105,110,102,
  111,46,99,111,110,110,11,84,114,97,110,115,97,99,116,105,111,110,7,12,
  109,97,105,110,102,111,46,116,114,97,110,115,6,112,97,114,97,109,115,14,
  0,11,83,81,76,46,83,116,114,105,110,103,115,1,6,37,115,101,108,101,
  99,116,32,42,32,102,114,111,109,32,99,111,110,116,105,110,101,110,116,115,
  32,111,114,100,101,114,32,98,121,32,105,100,59,0,9,73,110,100,101,120,
  68,101,102,115,14,0,18,85,115,101,80,114,105,109,97,114,121,75,101,121,
  65,115,75,101,121,8,13,83,116,97,116,101,109,101,110,116,84,121,112,101,
  7,8,115,116,83,101,108,101,99,116,9,70,105,101,108,100,68,101,102,115,
  14,1,4,78,97,109,101,6,2,105,100,8,68,97,116,97,84,121,112,101,
  7,9,102,116,73,110,116,101,103,101,114,9,80,114,101,99,105,115,105,111,
  110,2,255,4,83,105,122,101,2,4,0,1,4,78,97,109,101,6,9,112,
  108,97,110,101,116,95,105,100,8,68,97,116,97,84,121,112,101,7,9,102,
  116,73,110,116,101,103,101,114,9,80,114,101,99,105,115,105,111,110,2,255,
  4,83,105,122,101,2,4,0,1,4,78,97,109,101,6,5,100,101,115,99,
  114,8,68,97,116,97,84,121,112,101,7,6,102,116,77,101,109,111,9,80,
  114,101,99,105,115,105,111,110,2,255,4,83,105,122,101,2,4,0,0,23,
  99,111,110,116,114,111,108,108,101,114,46,102,105,101,108,100,115,46,99,111,
  117,110,116,2,3,24,99,111,110,116,114,111,108,108,101,114,46,102,105,101,
  108,100,115,46,102,105,101,108,100,115,1,1,7,10,102,116,95,108,111,110,
  103,105,110,116,7,10,102,116,95,108,111,110,103,105,110,116,7,7,102,116,
  95,109,101,109,111,0,14,1,9,65,108,105,103,110,77,101,110,116,7,14,
  116,97,82,105,103,104,116,74,117,115,116,105,102,121,12,68,105,115,112,108,
  97,121,87,105,100,116,104,2,10,9,70,105,101,108,100,78,97,109,101,6,
  2,105,100,13,80,114,111,118,105,100,101,114,70,108,97,103,115,11,7,112,
  102,73,110,75,101,121,0,0,1,9,65,108,105,103,110,77,101,110,116,7,
  14,116,97,82,105,103,104,116,74,117,115,116,105,102,121,12,68,105,115,112,
  108,97,121,87,105,100,116,104,2,10,9,70,105,101,108,100,78,97,109,101,
  6,9,112,108,97,110,101,116,95,105,100,5,73,110,100,101,120,2,1,13,
  80,114,111,118,105,100,101,114,70,108,97,103,115,11,10,112,102,73,110,85,
  112,100,97,116,101,0,0,1,12,68,105,115,112,108,97,121,87,105,100,116,
  104,2,10,9,70,105,101,108,100,78,97,109,101,6,5,100,101,115,99,114,
  5,73,110,100,101,120,2,2,4,83,105,122,101,2,4,13,84,114,97,110,
  115,108,105,116,101,114,97,116,101,8,0,0,0,4,108,101,102,116,2,16,
  3,116,111,112,2,48,0,0,12,116,109,115,101,115,113,108,113,117,101,114,
  121,12,113,114,121,67,111,117,110,116,114,105,101,115,6,65,99,116,105,118,
  101,9,10,66,101,102,111,114,101,79,112,101,110,7,22,113,114,121,99,111,
  117,110,116,114,105,101,115,98,101,102,111,114,101,111,112,101,110,8,100,97,
  116,97,98,97,115,101,7,11,109,97,105,110,102,111,46,99,111,110,110,11,
  84,114,97,110,115,97,99,116,105,111,110,7,12,109,97,105,110,102,111,46,
  116,114,97,110,115,6,112,97,114,97,109,115,14,0,11,83,81,76,46,83,
  116,114,105,110,103,115,1,6,36,115,101,108,101,99,116,32,42,32,102,114,
  111,109,32,99,111,117,110,116,114,105,101,115,32,111,114,100,101,114,32,98,
  121,32,105,100,59,0,9,73,110,100,101,120,68,101,102,115,14,0,18,85,
  115,101,80,114,105,109,97,114,121,75,101,121,65,115,75,101,121,8,13,83,
  116,97,116,101,109,101,110,116,84,121,112,101,7,8,115,116,83,101,108,101,
  99,116,9,70,105,101,108,100,68,101,102,115,14,1,4,78,97,109,101,6,
  2,105,100,8,68,97,116,97,84,121,112,101,7,9,102,116,73,110,116,101,
  103,101,114,9,80,114,101,99,105,115,105,111,110,2,255,4,83,105,122,101,
  2,4,0,1,4,78,97,109,101,6,12,99,111,110,116,105,110,101,110,116,
  95,105,100,8,68,97,116,97,84,121,112,101,7,9,102,116,73,110,116,101,
  103,101,114,9,80,114,101,99,105,115,105,111,110,2,255,4,83,105,122,101,
  2,4,0,1,4,78,97,109,101,6,5,100,101,115,99,114,8,68,97,116,
  97,84,121,112,101,7,6,102,116,77,101,109,111,9,80,114,101,99,105,115,
  105,111,110,2,255,4,83,105,122,101,2,4,0,0,23,99,111,110,116,114,
  111,108,108,101,114,46,102,105,101,108,100,115,46,99,111,117,110,116,2,3,
  24,99,111,110,116,114,111,108,108,101,114,46,102,105,101,108,100,115,46,102,
  105,101,108,100,115,1,1,7,10,102,116,95,108,111,110,103,105,110,116,7,
  10,102,116,95,108,111,110,103,105,110,116,7,7,102,116,95,109,101,109,111,
  0,14,1,9,65,108,105,103,110,77,101,110,116,7,14,116,97,82,105,103,
  104,116,74,117,115,116,105,102,121,12,68,105,115,112,108,97,121,87,105,100,
  116,104,2,10,9,70,105,101,108,100,78,97,109,101,6,2,105,100,13,80,
  114,111,118,105,100,101,114,70,108,97,103,115,11,7,112,102,73,110,75,101,
  121,0,0,1,9,65,108,105,103,110,77,101,110,116,7,14,116,97,82,105,
  103,104,116,74,117,115,116,105,102,121,12,68,105,115,112,108,97,121,87,105,
  100,116,104,2,10,9,70,105,101,108,100,78,97,109,101,6,12,99,111,110,
  116,105,110,101,110,116,95,105,100,5,73,110,100,101,120,2,1,13,80,114,
  111,118,105,100,101,114,70,108,97,103,115,11,10,112,102,73,110,85,112,100,
  97,116,101,0,0,1,12,68,105,115,112,108,97,121,87,105,100,116,104,2,
  10,9,70,105,101,108,100,78,97,109,101,6,5,100,101,115,99,114,5,73,
  110,100,101,120,2,2,4,83,105,122,101,2,4,13,84,114,97,110,115,108,
  105,116,101,114,97,116,101,8,0,0,0,4,108,101,102,116,2,16,3,116,
  111,112,2,80,0,0,12,116,109,115,101,115,113,108,113,117,101,114,121,14,
  113,114,121,79,99,99,117,112,97,116,105,111,110,115,6,65,99,116,105,118,
  101,9,8,100,97,116,97,98,97,115,101,7,11,109,97,105,110,102,111,46,
  99,111,110,110,11,84,114,97,110,115,97,99,116,105,111,110,7,12,109,97,
  105,110,102,111,46,116,114,97,110,115,6,112,97,114,97,109,115,14,0,11,
  83,81,76,46,83,116,114,105,110,103,115,1,6,38,115,101,108,101,99,116,
  32,42,32,102,114,111,109,32,111,99,99,117,112,97,116,105,111,110,115,32,
  111,114,100,101,114,32,98,121,32,105,100,59,0,9,73,110,100,101,120,68,
  101,102,115,14,0,18,85,115,101,80,114,105,109,97,114,121,75,101,121,65,
  115,75,101,121,8,13,83,116,97,116,101,109,101,110,116,84,121,112,101,7,
  8,115,116,83,101,108,101,99,116,9,70,105,101,108,100,68,101,102,115,14,
  1,4,78,97,109,101,6,2,105,100,8,68,97,116,97,84,121,112,101,7,
  9,102,116,73,110,116,101,103,101,114,9,80,114,101,99,105,115,105,111,110,
  2,255,4,83,105,122,101,2,4,0,1,4,78,97,109,101,6,5,100,101,
  115,99,114,8,68,97,116,97,84,121,112,101,7,6,102,116,77,101,109,111,
  9,80,114,101,99,105,115,105,111,110,2,255,4,83,105,122,101,2,4,0,
  0,23,99,111,110,116,114,111,108,108,101,114,46,102,105,101,108,100,115,46,
  99,111,117,110,116,2,2,24,99,111,110,116,114,111,108,108,101,114,46,102,
  105,101,108,100,115,46,102,105,101,108,100,115,1,1,7,10,102,116,95,108,
  111,110,103,105,110,116,7,7,102,116,95,109,101,109,111,0,14,1,9,65,
  108,105,103,110,77,101,110,116,7,14,116,97,82,105,103,104,116,74,117,115,
  116,105,102,121,12,68,105,115,112,108,97,121,87,105,100,116,104,2,10,9,
  70,105,101,108,100,78,97,109,101,6,2,105,100,13,80,114,111,118,105,100,
  101,114,70,108,97,103,115,11,7,112,102,73,110,75,101,121,0,0,1,12,
  68,105,115,112,108,97,121,87,105,100,116,104,2,10,9,70,105,101,108,100,
  78,97,109,101,6,5,100,101,115,99,114,5,73,110,100,101,120,2,1,4,
  83,105,122,101,2,4,13,84,114,97,110,115,108,105,116,101,114,97,116,101,
  8,0,0,0,4,108,101,102,116,2,16,3,116,111,112,2,112,0,0,12,
  116,109,115,101,115,113,108,113,117,101,114,121,11,113,114,121,70,101,97,116,
  117,114,101,115,6,65,99,116,105,118,101,9,8,100,97,116,97,98,97,115,
  101,7,11,109,97,105,110,102,111,46,99,111,110,110,11,84,114,97,110,115,
  97,99,116,105,111,110,7,12,109,97,105,110,102,111,46,116,114,97,110,115,
  6,112,97,114,97,109,115,14,0,11,83,81,76,46,83,116,114,105,110,103,
  115,1,6,35,115,101,108,101,99,116,32,42,32,102,114,111,109,32,102,101,
  97,116,117,114,101,115,32,111,114,100,101,114,32,98,121,32,105,100,59,0,
  9,73,110,100,101,120,68,101,102,115,14,0,18,85,115,101,80,114,105,109,
  97,114,121,75,101,121,65,115,75,101,121,8,13,83,116,97,116,101,109,101,
  110,116,84,121,112,101,7,8,115,116,83,101,108,101,99,116,9,70,105,101,
  108,100,68,101,102,115,14,1,4,78,97,109,101,6,2,105,100,8,68,97,
  116,97,84,121,112,101,7,9,102,116,73,110,116,101,103,101,114,9,80,114,
  101,99,105,115,105,111,110,2,255,4,83,105,122,101,2,4,0,1,4,78,
  97,109,101,6,5,100,101,115,99,114,8,68,97,116,97,84,121,112,101,7,
  6,102,116,77,101,109,111,9,80,114,101,99,105,115,105,111,110,2,255,4,
  83,105,122,101,2,4,0,0,23,99,111,110,116,114,111,108,108,101,114,46,
  102,105,101,108,100,115,46,99,111,117,110,116,2,2,24,99,111,110,116,114,
  111,108,108,101,114,46,102,105,101,108,100,115,46,102,105,101,108,100,115,1,
  1,7,10,102,116,95,108,111,110,103,105,110,116,7,7,102,116,95,109,101,
  109,111,0,14,1,9,65,108,105,103,110,77,101,110,116,7,14,116,97,82,
  105,103,104,116,74,117,115,116,105,102,121,12,68,105,115,112,108,97,121,87,
  105,100,116,104,2,10,9,70,105,101,108,100,78,97,109,101,6,2,105,100,
  13,80,114,111,118,105,100,101,114,70,108,97,103,115,11,7,112,102,73,110,
  75,101,121,0,0,1,12,68,105,115,112,108,97,121,87,105,100,116,104,2,
  10,9,70,105,101,108,100,78,97,109,101,6,5,100,101,115,99,114,5,73,
  110,100,101,120,2,1,4,83,105,122,101,2,4,13,84,114,97,110,115,108,
  105,116,101,114,97,116,101,8,0,0,0,4,108,101,102,116,2,16,3,116,
  111,112,3,144,0,0,0,14,116,109,115,101,100,97,116,97,115,111,117,114,
  99,101,9,100,115,80,108,97,110,101,116,115,7,68,97,116,97,83,101,116,
  7,10,113,114,121,80,108,97,110,101,116,115,4,108,101,102,116,3,144,0,
  3,116,111,112,2,16,0,0,14,116,109,115,101,100,97,116,97,115,111,117,
  114,99,101,12,100,115,67,111,110,116,105,110,101,110,116,115,7,68,97,116,
  97,83,101,116,7,13,113,114,121,67,111,110,116,105,110,101,110,116,115,4,
  108,101,102,116,3,144,0,3,116,111,112,2,48,0,0,14,116,109,115,101,
  100,97,116,97,115,111,117,114,99,101,13,100,115,79,99,99,117,112,97,116,
  105,111,110,115,7,68,97,116,97,83,101,116,7,14,113,114,121,79,99,99,
  117,112,97,116,105,111,110,115,4,108,101,102,116,3,144,0,3,116,111,112,
  2,112,0,0,14,116,109,115,101,100,97,116,97,115,111,117,114,99,101,10,
  100,115,70,101,97,116,117,114,101,115,7,68,97,116,97,83,101,116,7,11,
  113,114,121,70,101,97,116,117,114,101,115,4,108,101,102,116,3,144,0,3,
  116,111,112,3,144,0,0,0,14,116,109,115,101,100,97,116,97,115,111,117,
  114,99,101,11,100,115,67,111,117,110,116,114,105,101,115,7,68,97,116,97,
  83,101,116,7,12,113,114,121,67,111,117,110,116,114,105,101,115,4,108,101,
  102,116,3,144,0,3,116,111,112,2,80,0,0,15,116,100,98,108,111,111,
  107,117,112,98,117,102,102,101,114,11,108,98,117,102,80,108,97,110,101,116,
  115,10,100,97,116,97,115,111,117,114,99,101,7,9,100,115,80,108,97,110,
  101,116,115,16,116,101,120,116,102,105,101,108,100,115,46,99,111,117,110,116,
  2,1,16,116,101,120,116,102,105,101,108,100,115,46,105,116,101,109,115,1,
  6,5,100,101,115,99,114,0,19,105,110,116,101,103,101,114,102,105,101,108,
  100,115,46,99,111,117,110,116,2,1,19,105,110,116,101,103,101,114,102,105,
  101,108,100,115,46,105,116,101,109,115,1,6,2,105,100,0,4,108,101,102,
  116,3,16,1,3,116,111,112,2,16,0,0,15,116,100,98,108,111,111,107,
  117,112,98,117,102,102,101,114,14,108,98,117,102,67,111,110,116,105,110,101,
  110,116,115,10,100,97,116,97,115,111,117,114,99,101,7,12,100,115,67,111,
  110,116,105,110,101,110,116,115,16,116,101,120,116,102,105,101,108,100,115,46,
  99,111,117,110,116,2,1,16,116,101,120,116,102,105,101,108,100,115,46,105,
  116,101,109,115,1,6,5,100,101,115,99,114,0,19,105,110,116,101,103,101,
  114,102,105,101,108,100,115,46,99,111,117,110,116,2,2,19,105,110,116,101,
  103,101,114,102,105,101,108,100,115,46,105,116,101,109,115,1,6,2,105,100,
  6,9,112,108,97,110,101,116,95,105,100,0,4,108,101,102,116,3,16,1,
  3,116,111,112,2,48,0,0,15,116,100,98,108,111,111,107,117,112,98,117,
  102,102,101,114,13,108,98,117,102,67,111,117,110,116,114,105,101,115,10,100,
  97,116,97,115,111,117,114,99,101,7,11,100,115,67,111,117,110,116,114,105,
  101,115,16,116,101,120,116,102,105,101,108,100,115,46,99,111,117,110,116,2,
  1,16,116,101,120,116,102,105,101,108,100,115,46,105,116,101,109,115,1,6,
  5,100,101,115,99,114,0,19,105,110,116,101,103,101,114,102,105,101,108,100,
  115,46,99,111,117,110,116,2,2,19,105,110,116,101,103,101,114,102,105,101,
  108,100,115,46,105,116,101,109,115,1,6,2,105,100,6,12,99,111,110,116,
  105,110,101,110,116,95,105,100,0,4,108,101,102,116,3,16,1,3,116,111,
  112,2,80,0,0,15,116,100,98,108,111,111,107,117,112,98,117,102,102,101,
  114,15,108,98,117,102,79,99,99,117,112,97,116,105,111,110,115,10,100,97,
  116,97,115,111,117,114,99,101,7,13,100,115,79,99,99,117,112,97,116,105,
  111,110,115,16,116,101,120,116,102,105,101,108,100,115,46,99,111,117,110,116,
  2,1,16,116,101,120,116,102,105,101,108,100,115,46,105,116,101,109,115,1,
  6,5,100,101,115,99,114,0,19,105,110,116,101,103,101,114,102,105,101,108,
  100,115,46,99,111,117,110,116,2,1,19,105,110,116,101,103,101,114,102,105,
  101,108,100,115,46,105,116,101,109,115,1,6,2,105,100,0,4,108,101,102,
  116,3,16,1,3,116,111,112,2,112,0,0,15,116,100,98,108,111,111,107,
  117,112,98,117,102,102,101,114,12,108,98,117,102,70,101,97,116,117,114,101,
  115,10,100,97,116,97,115,111,117,114,99,101,7,10,100,115,70,101,97,116,
  117,114,101,115,16,116,101,120,116,102,105,101,108,100,115,46,99,111,117,110,
  116,2,1,16,116,101,120,116,102,105,101,108,100,115,46,105,116,101,109,115,
  1,6,5,100,101,115,99,114,0,19,105,110,116,101,103,101,114,102,105,101,
  108,100,115,46,99,111,117,110,116,2,1,19,105,110,116,101,103,101,114,102,
  105,101,108,100,115,46,105,116,101,109,115,1,6,2,105,100,0,4,108,101,
  102,116,3,16,1,3,116,111,112,3,144,0,0,0,0)
 );

initialization
 registerobjectdata(@objdata,trefsdatamo,'');
end.

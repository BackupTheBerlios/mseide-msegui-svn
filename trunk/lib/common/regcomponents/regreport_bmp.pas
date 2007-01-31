unit regreport_bmp;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface

implementation
uses
 mseclasses,msebitmap;

const
 objdata_tbandarea: record size: integer; data: array[0..605] of byte end =
      (size: 606; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,9,116,98,97,
  110,100,97,114,101,97,12,98,105,116,109,97,112,46,105,109,97,103,101,10,
  48,2,0,0,0,0,0,0,0,0,0,0,24,0,0,0,24,0,0,0,
  252,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,0,255,50,
  0,0,0,2,255,255,255,2,0,0,0,2,255,255,255,2,0,0,0,2,
  255,255,255,2,0,0,0,2,255,255,255,2,0,0,0,2,255,255,255,1,
  0,0,0,1,255,0,255,4,0,0,0,1,255,255,255,18,0,0,0,1,
  255,0,255,4,255,255,255,20,255,0,255,4,255,255,255,6,0,0,0,7,
  255,255,255,7,255,0,255,4,0,0,0,1,255,255,255,5,0,0,0,2,
  255,255,255,3,0,0,0,3,255,255,255,5,0,0,0,1,255,0,255,4,
  0,0,0,1,255,255,255,5,0,0,0,2,255,255,255,5,0,0,0,1,
  255,255,255,5,0,0,0,1,255,0,255,4,255,255,255,6,0,0,0,2,
  255,255,255,5,0,0,0,2,255,255,255,5,255,0,255,4,255,255,255,6,
  0,0,0,2,255,255,255,5,0,0,0,2,255,255,255,5,255,0,255,4,
  0,0,0,1,255,255,255,5,0,0,0,2,255,255,255,5,0,0,0,1,
  255,255,255,5,0,0,0,1,255,0,255,4,0,0,0,1,255,255,255,5,
  0,0,0,2,255,255,255,4,0,0,0,2,255,255,255,5,0,0,0,1,
  255,0,255,4,255,255,255,6,0,0,0,7,255,255,255,7,255,0,255,4,
  255,255,255,6,0,0,0,2,255,255,255,2,0,0,0,3,255,255,255,7,
  255,0,255,4,0,0,0,1,255,255,255,5,0,0,0,2,255,255,255,3,
  0,0,0,3,255,255,255,5,0,0,0,1,255,0,255,4,0,0,0,1,
  255,255,255,5,0,0,0,2,255,255,255,4,0,0,0,3,255,255,255,4,
  0,0,0,1,255,0,255,4,255,255,255,6,0,0,0,2,255,255,255,5,
  0,0,0,2,255,255,255,5,255,0,255,4,255,255,255,6,0,0,0,2,
  255,255,255,6,0,0,0,2,255,255,255,4,255,0,255,4,0,0,0,1,
  255,255,255,18,0,0,0,1,255,0,255,4,0,0,0,1,255,255,255,18,
  0,0,0,1,255,0,255,4,255,255,255,20,255,0,255,4,255,255,255,1,
  0,0,0,2,255,255,255,2,0,0,0,2,255,255,255,2,0,0,0,2,
  255,255,255,2,0,0,0,2,255,255,255,2,0,0,0,2,255,255,255,1,
  255,0,255,50,0,0)
 );

const
 objdata_tbandgroup: record size: integer; data: array[0..338] of byte end =
      (size: 339; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,10,116,98,97,
  110,100,103,114,111,117,112,12,98,105,116,109,97,112,46,105,109,97,103,101,
  10,36,1,0,0,0,0,0,0,0,0,0,0,24,0,0,0,24,0,0,
  0,240,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,0,255,
  50,0,0,0,2,255,255,255,2,0,0,0,2,255,255,255,2,0,0,0,
  2,255,255,255,2,0,0,0,2,255,255,255,2,0,0,0,2,255,255,255,
  1,0,0,0,1,255,0,255,4,0,0,0,1,255,255,255,18,0,0,0,
  1,255,0,255,4,255,255,255,20,255,0,255,4,255,255,255,20,255,0,255,
  4,0,0,0,1,255,255,255,18,0,0,0,1,255,0,255,4,0,0,0,
  3,255,255,255,2,0,0,0,2,255,255,255,2,0,0,0,2,255,255,255,
  2,0,0,0,2,255,255,255,2,0,0,0,3,255,0,255,4,255,255,255,
  20,255,0,255,4,255,255,255,20,255,0,255,4,0,0,0,1,255,255,255,
  18,0,0,0,1,255,0,255,4,0,0,0,1,255,255,255,18,0,0,0,
  1,255,0,255,4,255,255,255,1,0,0,0,2,255,255,255,2,0,0,0,
  2,255,255,255,2,0,0,0,2,255,255,255,2,0,0,0,2,255,255,255,
  2,0,0,0,2,255,255,255,1,255,0,255,255,255,0,255,11,0,0)
 );

const
 objdata_trecordband: record size: integer; data: array[0..243] of byte end =
      (size: 244; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,11,116,114,101,
  99,111,114,100,98,97,110,100,12,98,105,116,109,97,112,46,105,109,97,103,
  101,10,196,0,0,0,0,0,0,0,0,0,0,0,24,0,0,0,24,0,
  0,0,144,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,0,
  255,50,0,0,0,2,255,255,255,2,0,0,0,2,255,255,255,2,0,0,
  0,2,255,255,255,2,0,0,0,2,255,255,255,2,0,0,0,2,255,255,
  255,1,0,0,0,1,255,0,255,4,0,0,0,1,255,255,255,18,0,0,
  0,1,255,0,255,4,255,255,255,20,255,0,255,4,255,255,255,20,255,0,
  255,4,0,0,0,1,255,255,255,18,0,0,0,1,255,0,255,4,0,0,
  0,3,255,255,255,2,0,0,0,2,255,255,255,2,0,0,0,2,255,255,
  255,2,0,0,0,2,255,255,255,2,0,0,0,3,255,0,255,255,255,0,
  255,131,0,0)
 );

const
 objdata_treppagenumdisp: record size: integer; data: array[0..595] of byte end =
      (size: 596; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,15,116,114,101,
  112,112,97,103,101,110,117,109,100,105,115,112,12,98,105,116,109,97,112,46,
  105,109,97,103,101,10,32,2,0,0,0,0,0,0,0,0,0,0,24,0,
  0,0,24,0,0,0,236,1,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,255,0,255,146,255,255,255,20,255,0,255,4,255,255,255,2,215,215,
  215,1,0,0,0,1,3,3,3,1,4,4,4,1,24,24,24,1,106,106,
  106,1,244,244,244,1,255,255,255,4,105,105,105,1,218,218,218,1,173,173,
  173,1,149,149,149,1,255,255,255,3,255,0,255,4,255,255,255,2,215,215,
  215,1,3,3,3,1,255,255,255,2,222,222,222,1,68,68,68,1,94,94,
  94,1,255,255,255,4,68,68,68,1,255,255,255,1,98,98,98,1,225,225,
  225,1,255,255,255,3,255,0,255,4,255,255,255,2,215,215,215,1,3,3,
  3,1,255,255,255,3,199,199,199,1,18,18,18,1,255,255,255,2,3,3,
  3,1,2,2,2,2,3,3,3,1,1,1,1,1,3,3,3,2,255,255,
  255,2,255,0,255,4,255,255,255,2,215,215,215,1,3,3,3,1,255,255,
  255,3,190,190,190,1,28,28,28,1,255,255,255,3,168,168,168,1,155,155,
  155,1,243,243,243,1,84,84,84,1,255,255,255,4,255,0,255,4,255,255,
  255,2,215,215,215,1,3,3,3,1,255,255,255,1,253,253,253,1,210,210,
  210,1,50,50,50,1,127,127,127,1,255,255,255,3,125,125,125,1,200,200,
  200,1,199,199,199,1,126,126,126,1,255,255,255,4,255,0,255,4,255,255,
  255,2,215,215,215,1,0,0,0,1,7,7,7,1,8,8,8,1,35,35,
  35,1,132,132,132,1,253,253,253,1,255,255,255,3,83,83,83,1,243,243,
  243,1,154,154,154,1,169,169,169,1,255,255,255,4,255,0,255,4,255,255,
  255,2,215,215,215,1,3,3,3,1,255,255,255,6,7,7,7,2,2,2,
  2,1,7,7,7,1,3,3,3,1,6,6,6,1,7,7,7,1,255,255,
  255,3,255,0,255,4,255,255,255,2,215,215,215,1,3,3,3,1,255,255,
  255,7,224,224,224,1,99,99,99,1,255,255,255,1,68,68,68,1,255,255,
  255,5,255,0,255,4,255,255,255,2,215,215,215,1,3,3,3,1,255,255,
  255,7,149,149,149,1,174,174,174,1,221,221,221,1,102,102,102,1,255,255,
  255,5,255,0,255,4,255,255,255,20,255,0,255,170,0,0)
 );

const
 objdata_trepprintdatedisp: record size: integer; data: array[0..565] of byte end =
      (size: 566; data: (
  84,80,70,48,11,116,98,105,116,109,97,112,99,111,109,112,17,116,114,101,
  112,112,114,105,110,116,100,97,116,101,100,105,115,112,12,98,105,116,109,97,
  112,46,105,109,97,103,101,10,0,2,0,0,0,0,0,0,0,0,0,0,
  24,0,0,0,24,0,0,0,204,1,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,255,0,255,146,255,255,255,20,255,0,255,4,255,255,255,2,
  215,215,215,1,0,0,0,1,4,4,4,1,5,5,5,1,27,27,27,1,
  96,96,96,1,224,224,224,1,255,255,255,2,3,3,3,3,0,0,0,1,
  3,3,3,3,255,255,255,2,255,0,255,4,255,255,255,2,215,215,215,1,
  3,3,3,1,255,255,255,1,253,253,253,1,217,217,217,1,103,103,103,1,
  25,25,25,1,231,231,231,1,255,255,255,3,215,215,215,1,7,7,7,1,
  255,255,255,5,255,0,255,4,255,255,255,2,215,215,215,1,3,3,3,1,
  255,255,255,4,89,89,89,1,105,105,105,1,255,255,255,3,215,215,215,1,
  7,7,7,1,255,255,255,5,255,0,255,4,255,255,255,2,215,215,215,1,
  3,3,3,1,255,255,255,4,184,184,184,1,34,34,34,1,255,255,255,3,
  215,215,215,1,7,7,7,1,255,255,255,5,255,0,255,4,255,255,255,2,
  215,215,215,1,3,3,3,1,255,255,255,4,210,210,210,1,12,12,12,1,
  255,255,255,3,215,215,215,1,7,7,7,1,255,255,255,5,255,0,255,4,
  255,255,255,2,215,215,215,1,3,3,3,1,255,255,255,4,187,187,187,1,
  36,36,36,1,255,255,255,3,215,215,215,1,7,7,7,1,255,255,255,5,
  255,0,255,4,255,255,255,2,215,215,215,1,3,3,3,1,255,255,255,4,
  95,95,95,1,117,117,117,1,255,255,255,3,215,215,215,1,7,7,7,1,
  255,255,255,5,255,0,255,4,255,255,255,2,215,215,215,1,3,3,3,1,
  255,255,255,1,253,253,253,1,220,220,220,1,107,107,107,1,37,37,37,1,
  241,241,241,1,255,255,255,3,215,215,215,1,7,7,7,1,255,255,255,5,
  255,0,255,4,255,255,255,2,215,215,215,1,0,0,0,1,3,3,3,1,
  5,5,5,1,30,30,30,1,105,105,105,1,234,234,234,1,255,255,255,4,
  215,215,215,1,7,7,7,1,255,255,255,5,255,0,255,4,255,255,255,20,
  255,0,255,170,0,0)
 );

initialization
 registerobjectdata(@objdata_tbandarea,tbitmapcomp,'tbandarea');
 registerobjectdata(@objdata_tbandgroup,tbitmapcomp,'tbandgroup');
 registerobjectdata(@objdata_trecordband,tbitmapcomp,'trecordband');
 registerobjectdata(@objdata_treppagenumdisp,tbitmapcomp,'treppagenumdisp');
 registerobjectdata(@objdata_trepprintdatedisp,tbitmapcomp,'trepprintdatedisp');
end.

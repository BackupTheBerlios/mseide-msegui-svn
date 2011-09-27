{ MSEgui Copyright (c) 1999-2011 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit msearrayutils;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,msestrings;
type
 stringsortmodety = (sms_none,sms_upascii,sms_up,sms_upi);
 pointercomparemethodty = function(l,r:pointer): integer of object; 

 arraysortcomparety = function (const l,r): integer;
 sortcomparemethodty = function (const l,r): integer of object;
 sortcomparemethodarty = array of sortcomparemethodty;
 indexsortcomparemethodty = function (const l,r: integer): integer of object;

function firstitem(const source: stringarty): string; overload;
function firstitem(const source: msestringarty): msestring; overload;

procedure additem(var dest: stringarty; const value: string;
                             var count: integer; step: integer = 32); overload;
procedure additem(var dest: msestringarty; const value: msestring;
                             var count: integer; step: integer = 32); overload;
procedure additem(var dest: lstringarty; const value: lstringty;
                             var count: integer; step: integer = 32); overload;
procedure additem(var dest: lmsestringarty; const value: lmsestringty;
                             var count: integer; step: integer = 32); overload;
procedure additem(var dest: integerarty; const value: integer;
                             var count: integer; step: integer = 32); overload;
procedure additem(var dest: realarty; const value: real;
                             var count: integer; step: integer = 32); overload;
procedure additem(var dest: pointerarty; const value: pointer;
                             var count: integer; step: integer = 32); overload;
{$ifndef FPC}
procedure addpointeritem(var dest: pointerarty; const value: pointer;
                             var count: integer; step: integer = 32);
{$endif}
procedure additem(var dest: winidarty; const value: winidty;
                             var count: integer; step: integer = 32); overload;

function incrementarraylength(var value: pointer; typeinfo: pdynarraytypeinfo;
                             increment: integer = 1): sizeint; overload;
  //returns new length
function additem(var value; const typeinfo: pdynarraytypeinfo; 
                                  //typeinfo of dynarray
                var count: integer; step: integer = 32): integer; overload;
  //value = array of type, returns index of new item
procedure deleteitem(var value; const typeinfo: pdynarraytypeinfo;
                          const aindex: integer); overload;
  //value = array of type which needs no finalize
procedure arrayaddref(var dynamicarray);
procedure arraydecref(var dynamicarray); 
                 //no finalize and freemem if refcount = 0
procedure allocuninitedarray(count,itemsize: integer; out dynamicarray);
                 //does not init memory, dynamicarray must be nil!
function arrayrefcount(var dynamicarray): sizeint;

procedure additem(var dest: stringarty; const value: string); overload;
procedure additem(var dest: msestringarty; const value: msestring); overload;
procedure additem(var dest: integerarty; const value: integer); overload;
procedure additem(var dest: longboolarty; const value: longbool); overload;
procedure additem(var dest: booleanarty; const value: boolean); overload;
procedure additem(var dest: realarty; const value: real); overload;
procedure additem(var dest: pointerarty; const value: pointer); overload;
procedure additem(var dest: winidarty; const value: winidty); overload;
procedure deleteitem(var dest: stringarty; index: integer); overload;
procedure deleteitem(var dest: msestringarty; index: integer); overload;
procedure deleteitem(var dest: integerarty; index: integer); overload;
procedure deleteitem(var dest: booleanarty; index: integer); overload;
procedure deleteitem(var dest: realarty; index: integer); overload;
procedure deleteitem(var dest: complexarty; index: integer); overload;
procedure deleteitem(var dest: pointerarty; index: integer); overload;
procedure deleteitem(var dest: winidarty; index: integer); overload;
procedure insertitem(var dest: integerarty; index: integer; value: integer); overload;
procedure insertitem(var dest: realarty; index: integer; value: realty); overload;
procedure insertitem(var dest: complexarty; index: integer;
                                                value: complexty); overload;
procedure insertitem(var dest: pointerarty; index: integer; value: pointer); overload;
procedure insertitem(var dest: winidarty; index: integer; value: winidty); overload;
procedure insertitem(var dest: stringarty; index: integer; value: string); overload;
procedure insertitem(var dest: msestringarty; index: integer; value: msestring); overload;

procedure removeitems(var dest: pointerarty; const aitem: pointer);
                            //removes all matching items
function removeitem(var dest: pointerarty; const aitem: pointer): integer;
                                                overload;
                            //returns removed index, -1 if none
                            
function finditem(const ar: pointerarty; const aitem: pointer): integer;
                                                overload;
                           //-1 if none
procedure moveitem(var dest: pointerarty; const sourceindex: integer;
                       destindex: integer); overload;

function removeitem(var dest: stringarty; const aitem: string): integer;
                                            overload;
                        //returns removed index, -1 if none
function finditem(const ar: stringarty; const aitem: string): integer;
                                                overload;
                           //-1 if none
procedure moveitem(var dest: stringarty; const sourceindex: integer;
                       destindex: integer); overload;

function removeitem(var dest: msestringarty; const aitem: msestring): integer;
                                            overload;
                        //returns removed index, -1 if none
function finditem(const ar: msestringarty; const aitem: msestring): integer;
                                                overload;
                           //-1 if none
procedure moveitem(var dest: msestringarty; const sourceindex: integer;
                       destindex: integer); overload;


function removeitem(var dest: integerarty; const aitem: integer): integer;
                                            overload;
                        //returns removed index, -1 if none
function finditem(const ar: integerarty; const aitem: integer): integer;
                                            overload; //-1 if none  
procedure moveitem(var dest: integerarty; const sourceindex: integer;
                       destindex: integer); overload;

function adduniqueitem(var dest: pointerarty; const value: pointer): integer;
                        //returns index

function isequalarray(const a: integerarty; const b: integerarty): boolean;

procedure minmax(const ar: realarty; out minval,maxval: realty);

function stackarfunc(const ar1,ar2: integerarty): integerarty;
procedure stackarray(const source: stringarty; var dest: stringarty); overload;
procedure stackarray(const source: msestringarty; var dest: msestringarty); overload;
procedure stackarray(const source: integerarty; var dest: integerarty); overload;
procedure stackarray(const source: pointerarty; var dest: pointerarty); overload;
procedure stackarray(const source: winidarty; var dest: winidarty); overload;
procedure stackarray(const source: realarty; var dest: realarty); overload;
procedure insertarray(const source: integerarty; var dest: integerarty); overload;
procedure insertarray(const source: realarty; var dest: realarty); overload;
function reversearray(const source: msestringarty): msestringarty; overload;
function reversearray(const source: integerarty): integerarty; overload;
function reversearray(const source: pointerarty): pointerarty; overload;
procedure removearrayduplicates(var value: pointerarty);
function packarray(source: pointerarty): pointerarty; overload;
               //remove nil items
function packarray(source: msestringarty): msestringarty; overload;
               //remove '' items

procedure checkarrayindex(const value; const index: integer);
          //value = dynamic array, exception bei ungueltigem index

function comparepointer(const l,r): integer;
function compareinteger(const l,r): integer;
function compareint64(const l,r): integer;
function comparerealty(const l,r): integer;
function compareasciistring(const l,r): integer;
function compareiasciistring(const l,r): integer;
function compareansistring(const l,r): integer;
function compareiansistring(const l,r): integer;
function comparemsestring(const l,r): integer;
function compareimsestring(const l,r): integer;

function findarrayvalue(const item; const items; const size: integer;
               const count: integer; const compare: arraysortcomparety;
               out foundindex: integer): boolean; overload;
function findarrayvalue(const item; const items; const size: integer; 
               const index: integerarty; const compare: arraysortcomparety;
               out foundindex: integer): boolean; overload;
           //true if exact else next bigger
           //for compare: l is item, r are tablevalues
           //array must be sorted
{
procedure quicksortarray(var asortlist; const asize,alength: integer;
                            const acompare: arraysortcomparety;
                            out aindexlist: integerarty; const order: boolean);
                            //asortlist = array of type
}
procedure mergesortarray(var asortlist; const asize,alength: integer;
                            const acompare: arraysortcomparety;
                            out aindexlist: integerarty; const order: boolean);
                            //asortlist = array of type
procedure mergesort(var adata: pointerarty; const acount: integer;
                                const compare: pointercomparemethodty); overload;
procedure mergesort(const adata: pointer; const asize,acount: integer;
                            const acompare: sortcomparemethodty;
                            out aindexlist: integerarty); overload;
procedure mergesort(const adata: pointer; const asize,acount: integer; 
                          const acompare: sortcomparemethodty;
                          out aindexlist: integerarty;
                        var refindex: integer; out moved: boolean); overload;
procedure mergesort(const acount: integer; 
          const acompare: indexsortcomparemethodty;
                          out aindexlist: integerarty); overload;
procedure mergesort(const acount: integer; 
          const acompare: indexsortcomparemethodty; out aindexlist: integerarty;
          var refindex: integer; out moved: boolean); overload;
procedure mergesortoffset(const adata: pointer; const asize,acount: integer;
                            const acompare: sortcomparemethodty;
                            out aoffsetlist: integerarty); overload;
procedure mergesortpointer(const adata: pointer; const asize,acount: integer;
                            const acompare: sortcomparemethodty;
                            out apointerlist: pointerarty); overload;

function findarrayitem(const item; const ar; const size: integer;
                            const compare: arraysortcomparety;
                                 out foundindex: integer): boolean; overload;
           //ar = sorted array of type
           //true if exact else next bigger
           //for compare: l is item, r are tablevalues
function findarrayitem(const item; const ar: pointerarty;
                            const compare: sortcomparemethodty;
                                 out foundindex: integer): boolean; overload;
           //ar = sorted array of type
           //true if exact else next bigger
           //for compare: l is item, r are tablevalues

procedure sortarray(var sortlist; const size: integer;
           const compare: arraysortcomparety); overload;
         //sortlist = array of type
procedure sortarray(var sortlist; const size: integer; 
                  const compare: arraysortcomparety;
                  out indexlist: integerarty); overload;
         //sortlist = array of type
procedure sortarray(var dest: pointerarty; const compare: arraysortcomparety); overload;
procedure sortarray(var dest: pointerarty; const compare: arraysortcomparety;
                    out indexlist: integerarty); overload;
procedure sortarray(var dest: pointerarty); overload; //compares adresses
procedure sortarray(var dest: integerarty); overload;
procedure sortarray(var dest: integerarty; out indexlist: integerarty); overload;
procedure sortarray(var dest: longwordarty); overload;
procedure sortarray(var dest: longwordarty; out indexlist: integerarty); overload;
procedure sortarray(var dest: realarty); overload;
procedure sortarray(var dest: realarty; out indexlist: integerarty); overload;

procedure sortarray(var dest: msestringarty; const compare: arraysortcomparety); overload;
procedure sortarray(var dest: msestringarty; const compare: arraysortcomparety;
                    out indexlist: integerarty); overload;
procedure sortarray(var dest: stringarty; const compare: arraysortcomparety); overload;
procedure sortarray(var dest: stringarty; const compare: arraysortcomparety;
                    out indexlist: integerarty); overload;

procedure sortarray(var dest: msestringarty; 
                       const sortmode: stringsortmodety = sms_up); overload;
procedure sortarray(var dest: msestringarty; const sortmode: stringsortmodety; 
                                          out indexlist: integerarty); overload;
procedure sortarray(var dest: stringarty;
                    const sortmode: stringsortmodety = sms_upascii); overload;
procedure sortarray(var dest: stringarty;
         const sortmode: stringsortmodety; out indexlist: integerarty); overload;

procedure orderarray(const sourceorderlist: integerarty; var sortlist; size: integer); overload;
         //sortlist = array of type
procedure orderarray(const sourceorderlist: integerarty; 
                             var sortlist: pointerarty); overload;
procedure orderarray(const sourceorderlist: integerarty; 
                             var sortlist: integerarty); overload;
procedure orderarray(const sourceorderlist: integerarty;
                             var sortlist: msestringarty); overload;
procedure orderarray(const sourceorderlist: integerarty;
                             var sortlist: stringarty); overload;
                             
procedure reorderarray(const destorderlist: integerarty; 
                             var sortlist; size: integer); overload;
         //sortlist = array of type
procedure reorderarray(const destorderlist: integerarty; 
                             var sortlist: pointerarty); overload;
procedure reorderarray(const destorderlist: integerarty; 
                             var sortlist: integerarty); overload;
procedure reorderarray(const destorderlist: integerarty; 
                             var sortlist: msestringarty); overload;
procedure reorderarray(const destorderlist: integerarty; 
                             var sortlist: stringarty); overload;

function cmparray(const a,b: msestringarty): boolean;
               //true if equal

function opentodynarraym(const items: array of msestring): msestringarty;
function opentodynarrays(const items: array of string): stringarty;
function opentodynarrayi(const items: array of integer): integerarty;
function opentodynarrayr(const items: array of realty): realarty;
function opentodynarraybo(const items: array of boolean): booleanarty;
function opentodynarrayby(const items: array of byte): bytearty;

implementation
uses
 rtlconsts,classes,sysutils,msereal;
 
function DynArraySize(a: Pointer): sizeint;
{$ifdef FPC}
begin
 result:= length(bytearty(a));
end;
{$else}
asm
        TEST EAX, EAX
        JZ   @@exit
        MOV  EAX, [EAX-4]
@@exit:
end;
{$endif}

function incrementarraylength(var value: pointer; typeinfo: pdynarraytypeinfo;
                  increment: integer = 1): sizeint;
  //returns new length
begin
 result:= dynarraysize(value) + increment;
 dynarraysetlength(value,typeinfo,1,@result);
end;

function dynarrayelesize(const typinfo: pdynarraytypeinfo): sizeint;
var
 ti: pdynarraytypeinfo;
begin
 ti:= typinfo;
{$ifdef FPC}
 inc(pchar(ti),ord(ti^.namelen));
 result:= ti^.elesize;
{$else}
 inc(pchar(ti),length(ti^.name));
 result:= ti^.elsize;
{$endif}
end;

function decrementarraylength(var value: pointer; const typeinfo: pdynarraytypeinfo;
                      decrement: integer = 1): sizeint;
  //returns new length
begin
 result:= dynarraysize(value) - decrement;
 dynarraysetlength(value,typeinfo,1,@result);
end;

function additem(var value; const typeinfo: pdynarraytypeinfo;
                             var count: integer; step: integer = 32): integer;
var
 int1: integer;
begin
 int1:= high(pointerarty(value)) + 1;
 if int1 <= count then begin
  incrementarraylength(pointer(value),typeinfo,2*count+step);
//  incrementarraylength(pointer(value),typeinfo,count-int1+step);
 end;
 result:= count;
 inc(count);
end;

procedure deleteitem(var value; const typeinfo: pdynarraytypeinfo;
                         const aindex: integer);
  //value = array of type which needs no finalize
var
 int1: integer;
begin
 int1:= dynarrayelesize(pdynarraytypeinfo(typeinfo));
 move((pchar(value)+int1*(aindex+1))^,(pchar(value)+int1*aindex)^,
             int1*(high(bytearty(value))-aindex));
 decrementarraylength(pointer(value),typeinfo);
end;

procedure arrayaddref(var dynamicarray);
var
 refpo: psizeint;
begin
 if pointer(dynamicarray) <> nil then begin
  refpo:= psizeint(pchar(dynamicarray)-2*sizeof(sizeint));
  if refpo^ >= 0 then begin
   {$ifdef CPU64}
   interlockedincrement64(refpo^);
   {$else}
   interlockedincrement(refpo^);
   {$endif}
  end;
 end;
end;

function arrayrefcount(var dynamicarray): sizeint;
begin
 result:= 0;
 if pointer(dynamicarray) <> nil then begin
  result:= psizeint(pchar(dynamicarray)-2*sizeof(sizeint))^;
 end;
end;

procedure arraydecref(var dynamicarray);
var
 refpo: psizeint;
begin
 if pointer(dynamicarray) <> nil then begin
  refpo:= psizeint(pchar(dynamicarray)-2*sizeof(sizeint));
  if refpo^ > 0 then begin
  {$ifdef CPU64}
   interlockeddecrement64(refpo^);
  {$else}
   interlockeddecrement(refpo^);
  {$endif}
  end;
 end;
end;

procedure allocuninitedarray(count,itemsize: integer; out dynamicarray);
                 //does not init memory, dynamicarray must be nil!
var
 po1: psizeint;
begin
{$warnings off}
 if pointer(dynamicarray) <> nil then begin
{$warnings on}
  raise exception.Create('allocunitedarray: dynamicarray not nil');
 end;
 getmem(po1,count * itemsize + 2 * sizeof(sizeint));
 po1^:= 1; //refcount
 {$ifdef FPC}
 psizeint(pchar(po1)+sizeof(sizeint))^:= count - 1; //high
 {$else}
 psizeint(pchar(po1)+sizeof(sizeint))^:= count;     //count
 {$endif}
 pointer(dynamicarray):= pointer(pchar(po1) + 2 * sizeof(sizeint));
end;

function firstitem(const source: stringarty): string; overload;
begin
 if length(source) > 0 then begin
  result:= source[0];
 end
 else begin
  result:= '';
 end;
end;

function firstitem(const source: msestringarty): msestring; overload;
begin
 if length(source) > 0 then begin
  result:= source[0];
 end
 else begin
  result:= '';
 end;
end;

procedure additem(var dest: stringarty; const value: string;
                             var count: integer; step: integer = 32);
begin
 if length(dest) <= count then begin
  setlength(dest,count+step+2*length(dest));
 end;
 dest[count]:= value;
 inc(count);
end;

procedure additem(var dest: msestringarty; const value: msestring;
                             var count: integer; step: integer = 32);
begin
 if length(dest) <= count then begin
  setlength(dest,count+step+2*length(dest));
 end;
 dest[count]:= value;
 inc(count);
end;

procedure additem(var dest: lstringarty; const value: lstringty;
                             var count: integer; step: integer = 32);
begin
 if length(dest) <= count then begin
  setlength(dest,count+step+2*length(dest));
 end;
 dest[count]:= value;
 inc(count);
end;

procedure additem(var dest: lmsestringarty; const value: lmsestringty;
                             var count: integer; step: integer = 32);
begin
 if length(dest) <= count then begin
  setlength(dest,count+step+2*length(dest));
 end;
 dest[count]:= value;
 inc(count);
end;

procedure additem(var dest: integerarty; const value: integer;
                             var count: integer; step: integer = 32);
begin
 if length(dest) <= count then begin
  setlength(dest,count+step+2*length(dest));
 end;
 dest[count]:= value;
 inc(count);
end;

procedure additem(var dest: realarty; const value: real;
                             var count: integer; step: integer = 32);
begin
 if length(dest) <= count then begin
  setlength(dest,count+step+2*length(dest));
 end;
 dest[count]:= value;
 inc(count);
end;

procedure additem(var dest: pointerarty; const value: pointer;
                             var count: integer; step: integer = 32);
begin
 if length(dest) <= count then begin
  setlength(dest,count+step+2*length(dest));
 end;
 dest[count]:= value;
 inc(count);
end;

{$ifndef FPC}
procedure addpointeritem(var dest: pointerarty; const value: pointer;
                             var count: integer; step: integer = 32);
begin
 if length(dest) <= count then begin
  setlength(dest,count+step+2*length(dest));
 end;
 dest[count]:= value;
 inc(count);
end;
{$endif}

procedure additem(var dest: winidarty; const value: winidty;
                             var count: integer; step: integer = 32);
begin
 if length(dest) <= count then begin
  setlength(dest,count+step+2*length(dest));
 end;
 dest[count]:= value;
 inc(count);
end;

procedure additem(var dest: stringarty; const value: string);
begin
 setlength(dest,high(dest)+2);
 dest[high(dest)]:= value;
end;

procedure additem(var dest: msestringarty; const value: msestring);
begin
 setlength(dest,high(dest)+2);
 dest[high(dest)]:= value;
end;

procedure additem(var dest: integerarty; const value: integer);
begin
 setlength(dest,high(dest)+2);
 dest[high(dest)]:= value;
end;

procedure additem(var dest: longboolarty; const value: longbool);
begin
 setlength(dest,high(dest)+2);
 dest[high(dest)]:= value;
end;

procedure additem(var dest: booleanarty; const value: boolean);
begin
 setlength(dest,high(dest)+2);
 dest[high(dest)]:= value;
end;

procedure additem(var dest: realarty; const value: real);
begin
 setlength(dest,high(dest)+2);
 dest[high(dest)]:= value;
end;

procedure additem(var dest: pointerarty; const value: pointer);
begin
 setlength(dest,high(dest)+2);
 dest[high(dest)]:= value;
end;

procedure additem(var dest: winidarty; const value: winidty);
begin
 setlength(dest,high(dest)+2);
 dest[high(dest)]:= value;
end;

procedure deleteitem(var dest: stringarty; index: integer);
begin
 if (index < 0) or (index > high(dest)) then begin
  tlist.Error(SListIndexError, Index);
 end;
 dest[index]:= '';
 move(dest[index+1],dest[index],sizeof(dest[0])*(high(dest)-index));
 pointer(dest[high(dest)]):= nil;
 setlength(dest,high(dest));
end;

procedure deleteitem(var dest: msestringarty; index: integer);
begin
 if (index < 0) or (index > high(dest)) then begin
  tlist.Error(SListIndexError, Index);
 end;
 dest[index]:= '';
 move(dest[index+1],dest[index],sizeof(dest[0])*(high(dest)-index));
 pointer(dest[high(dest)]):= nil;
 setlength(dest,high(dest));
end;

procedure deleteitem(var dest: integerarty; index: integer);
begin
 if (index < 0) or (index > high(dest)) then begin
  tlist.Error(SListIndexError, Index);
 end;
 move(dest[index+1],dest[index],sizeof(dest[0])*(high(dest)-index));
 setlength(dest,high(dest));
end;

procedure deleteitem(var dest: booleanarty; index: integer);
begin
 if (index < 0) or (index > high(dest)) then begin
  tlist.Error(SListIndexError, Index);
 end;
 move(dest[index+1],dest[index],sizeof(dest[0])*(high(dest)-index));
 setlength(dest,high(dest));
end;

procedure deleteitem(var dest: realarty; index: integer);
begin
 if (index < 0) or (index > high(dest)) then begin
  tlist.Error(SListIndexError, Index);
 end;
 move(dest[index+1],dest[index],sizeof(dest[0])*(high(dest)-index));
 setlength(dest,high(dest));
end;

procedure deleteitem(var dest: complexarty; index: integer);
begin
 if (index < 0) or (index > high(dest)) then begin
  tlist.Error(SListIndexError, Index);
 end;
 move(dest[index+1],dest[index],sizeof(dest[0])*(high(dest)-index));
 setlength(dest,high(dest));
end;

procedure deleteitem(var dest: pointerarty; index: integer);
begin
 if (index < 0) or (index > high(dest)) then begin
  tlist.Error(SListIndexError, Index);
 end;
 move(dest[index+1],dest[index],sizeof(dest[0])*(high(dest)-index));
 setlength(dest,high(dest));
end;

procedure deleteitem(var dest: winidarty; index: integer);
begin
 if (index < 0) or (index > high(dest)) then begin
  tlist.Error(SListIndexError, Index);
 end;
 move(dest[index+1],dest[index],sizeof(dest[0])*(high(dest)-index));
 setlength(dest,high(dest));
end;

procedure insertitem(var dest: integerarty; index: integer; value: integer);
begin
 setlength(dest,high(dest) + 2);
 move(dest[index],dest[index+1],(high(dest)-index) * sizeof(dest[0]));
 dest[index]:= value;
end;

procedure insertitem(var dest: realarty; index: integer; value: realty);
begin
 setlength(dest,high(dest) + 2);
 move(dest[index],dest[index+1],(high(dest)-index) * sizeof(dest[0]));
 dest[index]:= value;
end;

procedure insertitem(var dest: complexarty; index: integer; value: complexty);
begin
 setlength(dest,high(dest) + 2);
 move(dest[index],dest[index+1],(high(dest)-index) * sizeof(dest[0]));
 dest[index]:= value;
end;

procedure insertitem(var dest: pointerarty; index: integer; value: pointer);
begin
 setlength(dest,high(dest) + 2);
 move(dest[index],dest[index+1],(high(dest)-index) * sizeof(dest[0]));
 dest[index]:= value;
end;

procedure insertitem(var dest: winidarty; index: integer; value: winidty);
begin
 setlength(dest,high(dest) + 2);
 move(dest[index],dest[index+1],(high(dest)-index) * sizeof(dest[0]));
 dest[index]:= value;
end;

procedure insertitem(var dest: stringarty; index: integer; value: string);
begin
 setlength(dest,high(dest) + 2);
 move(dest[index],dest[index+1],(high(dest)-index) * sizeof(dest[0]));
 pointer(dest[index]):= nil;
 dest[index]:= value;
end;

procedure insertitem(var dest: msestringarty; index: integer; value: msestring);
begin
 setlength(dest,high(dest) + 2);
 move(dest[index],dest[index+1],(high(dest)-index) * sizeof(dest[0]));
 pointer(dest[index]):= nil;
 dest[index]:= value;
end;

procedure removeitems(var dest: pointerarty; const aitem: pointer);
                            //removes all matching items
var
 int1,int2: integer;
 ar1: pointerarty;
begin
 setlength(ar1,length(dest));
 int2:= 0;
 for int1:= 0 to high(dest) do begin
  if dest[int1] <> aitem then begin
   ar1[int2]:= dest[int1];
   inc(int2);
  end;
 end;
 setlength(ar1,int2);
 dest:= ar1;
end;

function removeitem(var dest: pointerarty; const aitem: pointer): integer;
var
 int1: integer;
begin
 result:= -1;
 for int1:= 0 to high(dest) do begin
  if dest[int1] = aitem then begin
   result:= int1;
   deleteitem(dest,int1);
   break;
  end;
 end;
end;

function isequalarray(const a: integerarty; const b: integerarty): boolean;
var
 int1: integer;
 po1,po2: pintegeraty;
begin
 result:= pointer(a) = pointer(b);
 if not result and (high(a) = high(b)) then begin
  po1:= pointer(a);
  po2:= pointer(b);
  for int1:= high(a) downto 0 do begin
   if po1^[int1] <> po2^[int1] then begin
    exit;
   end;
  end;
  result:= true;
 end;
end;

function finditem(const ar: pointerarty; const aitem: pointer): integer;
                           //-1 if none
var
 int1: integer;
begin
 result:= -1;
 for int1:= 0 to high(ar) do begin
  if ar[int1] = aitem then begin
   result:= int1;
   break;
  end;
 end;
end;

procedure moveitem(var dest: pointerarty; const sourceindex: integer;
                              destindex: integer);
var
 po1: pointer;
begin
 po1:= dest[sourceindex];
 deleteitem(dest,sourceindex);
 insertitem(dest,destindex,po1);
end;


function removeitem(var dest: stringarty; const aitem: string): integer;
var
 int1: integer;
begin
 result:= -1;
 for int1:= 0 to high(dest) do begin
  if dest[int1] = aitem then begin
   result:= int1;
   deleteitem(dest,int1);
   break;
  end;
 end;
end;

function finditem(const ar: stringarty; const aitem: string): integer;
                           //-1 if none
var
 int1: integer;
begin
 result:= -1;
 for int1:= 0 to high(ar) do begin
  if ar[int1] = aitem then begin
   result:= int1;
   break;
  end;
 end;
end;

procedure moveitem(var dest: stringarty; const sourceindex: integer;
                              destindex: integer);
var
 po1: string;
begin
 po1:= dest[sourceindex];
 deleteitem(dest,sourceindex);
 insertitem(dest,destindex,po1);
end;

function removeitem(var dest: msestringarty; const aitem: msestring): integer;
var
 int1: integer;
begin
 result:= -1;
 for int1:= 0 to high(dest) do begin
  if dest[int1] = aitem then begin
   result:= int1;
   deleteitem(dest,int1);
   break;
  end;
 end;
end;

function finditem(const ar: msestringarty; const aitem: msestring): integer;
                           //-1 if none
var
 int1: integer;
begin
 result:= -1;
 for int1:= 0 to high(ar) do begin
  if ar[int1] = aitem then begin
   result:= int1;
   break;
  end;
 end;
end;

procedure moveitem(var dest: msestringarty; const sourceindex: integer;
                              destindex: integer);
var
 po1: msestring;
begin
 po1:= dest[sourceindex];
 deleteitem(dest,sourceindex);
 insertitem(dest,destindex,po1);
end;

function removeitem(var dest: integerarty; const aitem: integer): integer;
var
 int1: integer;
begin
 result:= -1;
 for int1:= 0 to high(dest) do begin
  if dest[int1] = aitem then begin
   result:= int1;
   deleteitem(dest,int1);
   break;
  end;
 end;
end;

function finditem(const ar: integerarty; const aitem: integer): integer;
                           //-1 if none
var
 int1: integer;
begin
 result:= -1;
 for int1:= 0 to high(ar) do begin
  if ar[int1] = aitem then begin
   result:= int1;
   break;
  end;
 end;
end;

procedure moveitem(var dest: integerarty; const sourceindex: integer;
                              destindex: integer);
var
 int1: integer;
begin
 int1:= dest[sourceindex];
 deleteitem(dest,sourceindex);
 insertitem(dest,destindex,int1);
end;

function adduniqueitem(var dest: pointerarty; const value: pointer): integer;
                        //returns index
var
 int1: integer;
begin
 for int1:= 0 to high(dest) do begin
  if dest[int1] = value then begin
   result:= int1;
   exit;
  end;
 end;
 result:= high(dest) + 1;
 setlength(dest,result+1);
 dest[result]:= value;
end;

procedure minmax(const ar: realarty; out minval,maxval: realty);
var
 int1: integer;
 min1,max1: realty;
begin
 min1:= bigreal;
 max1:= emptyreal;
 for int1:= high(ar) downto 0 do begin
  if ar[int1] = emptyreal then begin
   min1:= ar[int1];
  end
  else begin
   if (max1 = emptyreal) or (ar[int1] > max1) then begin
    max1:= ar[int1];
   end;
   if not (min1 = emptyreal) and (min1 > ar[int1]) then begin
    min1:= ar[int1];
   end;
  end;
 end;
 minval:= min1;
 maxval:= max1;
end;

function stackarfunc(const ar1,ar2: integerarty): integerarty;
begin
 setlength(result,length(ar1) + length(ar2));
 move(ar1[0],result[0],length(ar1)*sizeof(ar1[0]));
 move(ar2[0],result[length(ar1)],length(ar2)*sizeof(ar2[0]));
end;

procedure stackarray(const source: stringarty; var dest: stringarty);
var
 laengevorher: integer;
 int1: integer;
begin
 laengevorher:= length(dest);
 setlength(dest,laengevorher+length(source));
 for int1:= 0 to high(source) do begin
  dest[laengevorher]:= source[int1];
  inc(laengevorher);
 end;
end;

procedure stackarray(const source: msestringarty; var dest: msestringarty);
var
 laengevorher: integer;
 int1: integer;
begin
 laengevorher:= length(dest);
 setlength(dest,laengevorher+length(source));
 for int1:= 0 to high(source) do begin
  dest[laengevorher]:= source[int1];
  inc(laengevorher);
 end;
end;

procedure stackarray(const source: integerarty; var dest: integerarty);
var
 laengevorher: integer;
begin
 laengevorher:= length(dest);
 setlength(dest,laengevorher+length(source));
 move(source[0],dest[laengevorher],length(source)*sizeof(source[0]));
end;

procedure stackarray(const source: pointerarty; var dest: pointerarty);
var
 laengevorher: integer;
begin
 laengevorher:= length(dest);
 setlength(dest,laengevorher+length(source));
 move(source[0],dest[laengevorher],length(source)*sizeof(source[0]));
end;

procedure stackarray(const source: winidarty; var dest: winidarty);
var
 laengevorher: integer;
begin
 laengevorher:= length(dest);
 setlength(dest,laengevorher+length(source));
 move(source[0],dest[laengevorher],length(source)*sizeof(source[0]));
end;

procedure insertarray(const source: integerarty; var dest: integerarty);
var
 laengevorher: integer;
begin
 laengevorher:= length(dest);
 setlength(dest,laengevorher+length(source));
 move(dest[0],dest[length(source)],laengevorher*sizeof(dest[0]));
 move(source[0],dest[0],length(source)*sizeof(source[0]));
end;

procedure stackarray(const source: realarty; var dest: realarty);
var
 laengevorher: integer;
begin
 laengevorher:= length(dest);
 setlength(dest,laengevorher+length(source));
 move(source[0],dest[laengevorher],length(source)*sizeof(source[0]));
end;

procedure insertarray(const source: realarty; var dest: realarty);
var
 laengevorher: integer;
begin
 laengevorher:= length(dest);
 setlength(dest,laengevorher+length(source));
 move(dest[0],dest[length(source)],laengevorher*sizeof(dest[0]));
 move(source[0],dest[0],length(source)*sizeof(source[0]));
end;

function reversearray(const source: msestringarty): msestringarty;
var
 ar1: msestringarty;
 int1,int2: integer;
begin
{$warnings off}
 if pointer(source) = pointer(result) then begin
{$warnings on}
  ar1:= copy(source);
 end
 else begin
  ar1:= source;
 end;
 int2:= high(ar1);
 setlength(result,int2+1);
 for int1:= 0 to int2 do begin
  result[int1]:= ar1[int2];
  dec(int2);
 end;
end;

function reversearray(const source: integerarty): integerarty; overload;
var
 ar1: integerarty;
 int1,int2: integer;
begin
{$warnings off}
 if pointer(source) = pointer(result) then begin
{$warnings on}
  ar1:= copy(source);
 end
 else begin
  ar1:= source;
 end;
 int2:= high(ar1);
 setlength(result,int2+1);
 for int1:= 0 to int2 do begin
  result[int1]:= ar1[int2];
  dec(int2);
 end;
end;

function reversearray(const source: pointerarty): pointerarty; overload;
var
 ar1: pointerarty;
 int1,int2: integer;
begin
{$warnings off}
 if pointer(source) = pointer(result) then begin
{$warnings on}
  ar1:= copy(source);
 end
 else begin
  ar1:= source;
 end;
 int2:= high(ar1);
 setlength(result,int2+1);
 for int1:= 0 to int2 do begin
  result[int1]:= ar1[int2];
  dec(int2);
 end;
end;

procedure removearrayduplicates(var value: pointerarty);
var
 int1,int2: integer;
begin
 for int1:= 0 to high(value) do begin //remove duplicates
  if value[int1] <> nil then begin
   for int2:= int1 + 1 to high(value) do begin
    if value[int2] = value[int1] then begin
     value[int2]:= nil
    end;
   end;
  end;
 end;
 int2:= 0;
 for int1:= 0 to high(value) do begin
  if value[int1] <> nil then begin
   value[int2]:= value[int1];
   inc(int2);
  end;
 end;
 setlength(value,int2);
end;

function packarray(source: pointerarty): pointerarty; //removes nil items
var
 int1,int2: integer;
begin
 setlength(result,length(source));
 int2:= 0;
 for int1:= 0 to high(source) do begin
  result[int2]:= source[int1];
  if source[int1] <> nil then begin
   inc(int2);
  end;
 end;
 setlength(result,int2);
end;

function packarray(source: msestringarty): msestringarty;
var
 int1,int2: integer;
begin
 setlength(result,length(source));
 int2:= 0;
 for int1:= 0 to high(source) do begin
  result[int2]:= source[int1];
  if source[int1] <> '' then begin
   inc(int2);
  end;
 end;
 setlength(result,int2);
end;

procedure checkarrayindex(const value; const index: integer);
          //value = dynamic array, exception bei ungueltigem index
begin
 if (index < 0) or (index > high(bytearty(value))) then begin
  raise exception.Create('Invalid arrayindex: '+inttostr(index)+ ' max: ' + 
                   inttostr(high(bytearty(value)))+'.');
 end;
end;

type
 sortinfoty = record
  indexlist: integerarty;
  sortlist: pchar;
  compare: arraysortcomparety;
  size: integer;
 end;
 
function findarrayvalue(const item; const items; 
               const size: integer; const count: integer;
               const compare: arraysortcomparety;
               out foundindex: integer): boolean;
           //true if exact else next bigger
           //for compare: l is item, r are tablevalues
var
 ilo,ihi:integer;
 int1,int2: integer;
// bo1: boolean;
begin
 foundindex:= count;
 result:= false;
 if foundindex > 0 then begin
  ilo:= 0;
  ihi:= foundindex - 1;
//  bo1:= false;
  while true do begin
   int1:= (ilo + ihi) div 2;
   int2:= compare(item,(pchar(items)+int1*size)^);
    if int2 >= 0 then begin //item <= pivot
     if int2 = 0 then begin
      result:= true; //found
     end;
     if ihi = ilo then begin
      foundindex:= ihi + 1;
      break;
     end;
     if ilo = int1 then begin
      inc(ilo);
     end
     else begin
      ilo:= int1;
     end;
    end
    else begin            //item > pivot
     if ihi = ilo then begin
      foundindex:= ihi;
      break;
     end;
     ihi:= int1;
   end;
  end;
  if result then begin
   dec(foundindex);
  end;
 end;
end;

function findarrayitem(const item; const ar; const size: integer;
               const compare: arraysortcomparety;
               out foundindex: integer): boolean;
           //ar = array of type
           //true if exact else next bigger
           //for compare: l is item, r are tablevalues
begin
 result:= findarrayvalue(item,ar,size,length(pointerarty(ar)),
                                                     compare,foundindex);
end;

function findarrayvalue(const item; const items; const size: integer;
               const index: integerarty;
               const compare: arraysortcomparety; 
               out foundindex: integer): boolean;
           //true if exact else next bigger
           //for compare: l is item, r are tablevalues
var
 ilo,ihi:integer;
 int1,int2: integer;
// bo1: boolean;
begin
 foundindex:= length(index);
 result:= false;
 if foundindex > 0 then begin
  ilo:= 0;
  ihi:= foundindex - 1;
//  bo1:= false;
  while true do begin
   int1:= (ilo + ihi) div 2;
   int2:= compare(item,(pchar(items)+index[int1]*size)^);
   if int2 >= 0 then begin //item <= pivot
    if int2 = 0 then begin
     result:= true; //found
    end;
    if ihi = ilo then begin
     foundindex:= ihi + 1;
     break;
    end;
    if ilo = int1 then begin
     inc(ilo);
    end
    else begin
     ilo:= int1;
    end;
   end
   else begin            //item > pivot
    if ihi = ilo then begin
     foundindex:= ihi;
     break;
    end;
    ihi:= int1;
   end;
  end;
  if result then begin
   dec(foundindex);
  end;
 end;
end;

function findarrayitem(const item; const ar: pointerarty;
                            const compare: sortcomparemethodty;
                                 out foundindex: integer): boolean; overload;
           //ar = sorted array of type
           //true if exact else next bigger
           //for compare: l is item, r are tablevalues
var
 ilo,ihi:integer;
 int1,int2: integer;
// bo1: boolean;
begin
 foundindex:= length(ar);
 result:= false;
 if foundindex > 0 then begin
  ilo:= 0;
  ihi:= foundindex - 1;
//  bo1:= false;
  while true do begin
   int1:= (ilo + ihi) div 2;
   int2:= compare(item,ar[int1]^);
   if int2 >= 0 then begin //item <= pivot
    if int2 = 0 then begin
     result:= true; //found
    end;
    if ihi = ilo then begin
     foundindex:= ihi + 1;
     break;
    end;
    if ilo = int1 then begin
     inc(ilo);
    end
    else begin
     ilo:= int1;
    end;
   end
   else begin            //item > pivot
    if ihi = ilo then begin
     foundindex:= ihi;
     break;
    end;
    ihi:= int1;
   end;
  end;
  if result then begin
   dec(foundindex);
  end;
 end;
end;

function comparepointer(const l,r): integer;
var
 pint1: ptrint;
begin
 result:= 1;
 pint1:= ptrint(l) - ptrint(r);
 if pint1 < 0 then begin
  result:= -1
 end
 else begin
  if pint1 = 0 then begin
   result:= 0;
  end;
 end;
end;

function compareinteger(const l,r): integer;
begin
 result:= integer(l) - integer(r);
end;

function compareint64(const l,r): integer;
begin
 result:= int64(l) - int64(r);
end;

procedure mergesortarray(var asortlist; const asize,alength: integer;
              const acompare: arraysortcomparety;
                      out aindexlist: integerarty; const order: boolean);
                            //asortlist = array of type
        //todo: optimize
var
 ar1: integerarty;
 step: integer;
 l,r,d: pinteger;
 stopl,stopr,stops: pinteger;
 source,dest: pinteger;
 int1: integer;
 po1: pchar;
label
 endstep;
begin
 if alength = 0 then begin
  aindexlist:= nil;
  exit;
 end;
 po1:= pointer(asortlist);
 allocuninitedarray(alength,sizeof(integer),ar1);
 allocuninitedarray(alength,sizeof(integer),aindexlist);
 for int1:= alength-1 downto 0 do begin
  aindexlist[int1]:= int1;
 end;
 source:= pointer(aindexlist);
 dest:= pointer(ar1);
 step:= 1;
 while step < alength do begin
  d:= dest;
  l:= source;
 {$ifdef FPC}
  r:= source+step;
 {$else}
  r:= pointer(pchar(source)+step*sizeof(source^));
 {$endif}
  stopl:= r;
 {$ifdef FPC}
  stopr:= r+step;
 {$else}
  stopr:= pointer(pchar(r)+step*sizeof(r^));
 {$endif}
 {$ifdef FPC}
  stops:= source + alength;
 {$else}
  stops:= pointer(pchar(source) + alength*sizeof(source^));
 {$endif}
  if pchar(stopr) > pchar(stops) then begin
   stopr:= stops;
  end;
  while true do begin //runs
   while true do begin //steps
    while acompare((po1+l^*asize)^,(po1+r^*asize)^) <= 0 do begin
                                                           //merge from left
     d^:= l^;
     inc(l);
     inc(d);
     if l = stopl then begin
      while r <> stopr do begin
       d^:= r^;   //copy rest
       inc(d);
       inc(r);
      end;
      goto endstep;
     end;
    end;
    while acompare((po1+l^*asize)^,(po1+r^*asize)^) > 0 do begin
                                                         //merge from right;
     d^:= r^;
     inc(r);
     inc(d);
     if r = stopr then begin
      while l <> stopl do begin
       d^:= l^;   //copy rest
       inc(d);
       inc(l);
      end;
      goto endstep;
     end; 
    end;
   end;
endstep:
   if stopr = stops then begin
    break;  //run finished
   end;
   l:= stopr; //next step
  {$ifdef FPC}
   r:= l + step;
  {$else}
   r:= pointer(pchar(l) + step*sizeof(l^));
  {$endif}
   if pchar(r) >= pchar(stops) then begin
  {$ifdef FPC}
    r:= stops-1;
  {$else}
    r:= pointer(pchar(stops)-1*sizeof(stops^));
  {$endif}
   end;
   if r = l then begin
    d^:= l^;
    break;
   end;
   stopl:= r;
  {$ifdef FPC}
   stopr:= r + step;
  {$else}
   stopr:= pointer(pchar(r) + step*sizeof(r^));
  {$endif}
   if pchar(stopr) > pchar(stops) then begin
    stopr:= stops;
   end;
  end;
  d:= source;     //swap buffer
  source:= dest;
  dest:= d;
  step:= step*2;
 end;

 if source <> pointer(aindexlist) then begin
  aindexlist:= ar1;
 end;
 if order then begin
  orderarray(aindexlist,asortlist,asize);
 end;
end;


(*
procedure mergesort(var adata: pointerarty; const acount: integer;
                                   const compare: pointercomparemethodty);
        //todo: optimize
var
 ar1: pointerarty;
 step: integer;
 l,r,d: ppointer;
 stopl,stopr,stops: ppointer;
 source,dest: ppointer;
label
 endstep;
begin
 allocuninitedarray(length(adata),sizeof(pointer),ar1);
 source:= pointer(adata);
 dest:= pointer(ar1);
 step:= 1;
 while step < acount do begin
  d:= dest;
  l:= source;
  r:= source + step;
  stopl:= r;
  stopr:= r+step;
  stops:= source + acount;
  if stopr > stops then begin
   stopr:= stops;
  end;
  while true do begin //runs
   while true do begin //steps
    while compare(l^,r^) <= 0 do begin //merge from left
     d^:= l^;
     inc(l);
     inc(d);
     if l = stopl then begin
      while r <> stopr do begin
       d^:= r^;   //copy rest
       inc(d);
       inc(r);
      end;
      goto endstep;
     end;
    end;
    while compare(l^,r^) > 0 do begin //merge from right;
     d^:= r^;
     inc(r);
     inc(d);
     if r = stopr then begin
      while l <> stopl do begin
       d^:= l^;   //copy rest
       inc(d);
       inc(l);
      end;
      goto endstep;
     end; 
    end;
   end;
endstep:
   if stopr = stops then begin
    break;  //run finished
   end;
   l:= stopr; //next step
   r:= l + step;
   if r >= stops then begin
    r:= stops-1;
   end;
   if r = l then begin
    d^:= l^;
    break;
   end;
   stopl:= r;
   stopr:= r + step;
   if stopr > stops then begin
    stopr:= stops;
   end;
  end;
  d:= source;     //swap buffer
  source:= dest;
  dest:= d;
  step:= step*2;
 end;

 if source <> pointer(adata) then begin
  adata:= ar1;
 end;
end;
*)

procedure mergesort(const adata: pointer; const asize,acount: integer;
                            const acompare: sortcomparemethodty;
                            out aindexlist: integerarty);
        //todo: optimize
var
 ar1: integerarty;
 step: integer;
 l,r,d: pinteger;
 stopl,stopr,stops: pinteger;
 source,dest: pinteger;
 int1: integer;
 po1: pchar;
label
 endstep;
begin
 if acount = 0 then begin
  aindexlist:= nil;
  exit;
 end;
 po1:= pointer(adata);
 allocuninitedarray(acount,sizeof(integer),ar1);
 allocuninitedarray(acount,sizeof(integer),aindexlist);
 for int1:= acount-1 downto 0 do begin
  aindexlist[int1]:= int1;
 end;
 source:= pointer(aindexlist);
 dest:= pointer(ar1);
 step:= 1;
 while step < acount do begin
  d:= dest;
  l:= source;
 {$ifdef FPC}
  r:= source+step;
 {$else}
  r:= pointer(pchar(source)+step*sizeof(source^));
 {$endif}
  stopl:= r;
 {$ifdef FPC}
  stopr:= r+step;
 {$else}
  stopr:= pointer(pchar(r)+step*sizeof(r^));
 {$endif}
 {$ifdef FPC}
  stops:= source + acount;
 {$else}
  stops:= pointer(pchar(source) + alength*sizeof(source^));
 {$endif}
  if pchar(stopr) > pchar(stops) then begin
   stopr:= stops;
  end;
  while true do begin //runs
   while true do begin //steps
    while acompare((po1+l^*asize)^,(po1+r^*asize)^) <= 0 do begin
                                                           //merge from left
     d^:= l^;
     inc(l);
     inc(d);
     if l = stopl then begin
      while r <> stopr do begin
       d^:= r^;   //copy rest
       inc(d);
       inc(r);
      end;
      goto endstep;
     end;
    end;
    while acompare((po1+l^*asize)^,(po1+r^*asize)^) > 0 do begin
                                                         //merge from right;
     d^:= r^;
     inc(r);
     inc(d);
     if r = stopr then begin
      while l <> stopl do begin
       d^:= l^;   //copy rest
       inc(d);
       inc(l);
      end;
      goto endstep;
     end; 
    end;
   end;
endstep:
   if stopr = stops then begin
    break;  //run finished
   end;
   l:= stopr; //next step
  {$ifdef FPC}
   r:= l + step;
  {$else}
   r:= pointer(pchar(l) + step*sizeof(l^));
  {$endif}
   if pchar(r) >= pchar(stops) then begin
  {$ifdef FPC}
    r:= stops-1;
  {$else}
    r:= pointer(pchar(stops)-1*sizeof(stops^));
  {$endif}
   end;
   if r = l then begin
    d^:= l^;
    break;
   end;
   stopl:= r;
  {$ifdef FPC}
   stopr:= r + step;
  {$else}
   stopr:= pointer(pchar(r) + step*sizeof(r^));
  {$endif}
   if pchar(stopr) > pchar(stops) then begin
    stopr:= stops;
   end;
  end;
  d:= source;     //swap buffer
  source:= dest;
  dest:= d;
  step:= step*2;
 end;

 if source <> pointer(aindexlist) then begin
  aindexlist:= ar1;
 end;
end;

procedure mergesortoffset(const adata: pointer; const asize,acount: integer;
                            const acompare: sortcomparemethodty;
                            out aoffsetlist: integerarty);
        //todo: optimize
var
 ar1: integerarty;
 step: integer;
 l,r,d: pinteger;
 stopl,stopr,stops: pinteger;
 source,dest: pinteger;
 int1: integer;
 po1: pchar;
label
 endstep;
begin
 if acount = 0 then begin
  aoffsetlist:= nil;
  exit;
 end;
 po1:= pointer(adata);
 allocuninitedarray(acount,sizeof(integer),ar1);
 allocuninitedarray(acount,sizeof(integer),aoffsetlist);
 for int1:= acount-1 downto 0 do begin
  aoffsetlist[int1]:= int1*asize;
 end;
 source:= pointer(aoffsetlist);
 dest:= pointer(ar1);
 step:= 1;
 while step < acount do begin
  d:= dest;
  l:= source;
 {$ifdef FPC}
  r:= source+step;
 {$else}
  r:= pointer(pchar(source)+step*sizeof(source^));
 {$endif}
  stopl:= r;
 {$ifdef FPC}
  stopr:= r+step;
 {$else}
  stopr:= pointer(pchar(r)+step*sizeof(r^));
 {$endif}
 {$ifdef FPC}
  stops:= source + acount;
 {$else}
  stops:= pointer(pchar(source) + alength*sizeof(source^));
 {$endif}
  if pchar(stopr) > pchar(stops) then begin
   stopr:= stops;
  end;
  while true do begin //runs
   while true do begin //steps
    while acompare((po1+l^{*asize})^,(po1+r^{*asize})^) <= 0 do begin
                                                           //merge from left
     d^:= l^;
     inc(l);
     inc(d);
     if l = stopl then begin
      while r <> stopr do begin
       d^:= r^;   //copy rest
       inc(d);
       inc(r);
      end;
      goto endstep;
     end;
    end;
    while acompare((po1+l^{*asize})^,(po1+r^{*asize})^) > 0 do begin
                                                         //merge from right;
     d^:= r^;
     inc(r);
     inc(d);
     if r = stopr then begin
      while l <> stopl do begin
       d^:= l^;   //copy rest
       inc(d);
       inc(l);
      end;
      goto endstep;
     end; 
    end;
   end;
endstep:
   if stopr = stops then begin
    break;  //run finished
   end;
   l:= stopr; //next step
  {$ifdef FPC}
   r:= l + step;
  {$else}
   r:= pointer(pchar(l) + step*sizeof(l^));
  {$endif}
   if pchar(r) >= pchar(stops) then begin
  {$ifdef FPC}
    r:= stops-1;
  {$else}
    r:= pointer(pchar(stops)-1*sizeof(stops^));
  {$endif}
   end;
   if r = l then begin
    d^:= l^;
    break;
   end;
   stopl:= r;
  {$ifdef FPC}
   stopr:= r + step;
  {$else}
   stopr:= pointer(pchar(r) + step*sizeof(r^));
  {$endif}
   if pchar(stopr) > pchar(stops) then begin
    stopr:= stops;
   end;
  end;
  d:= source;     //swap buffer
  source:= dest;
  dest:= d;
  step:= step*2;
 end;

 if source <> pointer(aoffsetlist) then begin
  aoffsetlist:= ar1;
 end;
end;

procedure mergesortpointer(const adata: pointer; const asize,acount: integer;
                            const acompare: sortcomparemethodty;
                            out apointerlist: pointerarty);
        //todo: optimize
var
 ar1: pointerarty;
 step: integer;
 l,r,d: ppointer;
 stopl,stopr,stops: ppointer;
 source,dest: ppointer;
 int1: integer;
// po1: pchar;
label
 endstep;
begin
 if acount = 0 then begin
  apointerlist:= nil;
  exit;
 end;
// po1:= pointer(adata);
 allocuninitedarray(acount,sizeof(pointer),ar1);
 allocuninitedarray(acount,sizeof(pointer),apointerlist);
 for int1:= acount-1 downto 0 do begin
  apointerlist[int1]:= pchar(adata)+int1*asize;
 end;
 source:= pointer(apointerlist);
 dest:= pointer(ar1);
 step:= 1;
 while step < acount do begin
  d:= dest;
  l:= source;
 {$ifdef FPC}
  r:= source+step;
 {$else}
  r:= pointer(pchar(source)+step*sizeof(source^));
 {$endif}
  stopl:= r;
 {$ifdef FPC}
  stopr:= r+step;
 {$else}
  stopr:= pointer(pchar(r)+step*sizeof(r^));
 {$endif}
 {$ifdef FPC}
  stops:= source + acount;
 {$else}
  stops:= pointer(pchar(source) + alength*sizeof(source^));
 {$endif}
  if pchar(stopr) > pchar(stops) then begin
   stopr:= stops;
  end;
  while true do begin //runs
   while true do begin //steps
    while acompare(({po1+}l^{*asize})^,({po1+}r^{*asize})^) <= 0 do begin
                                                           //merge from left
     d^:= l^;
     inc(l);
     inc(d);
     if l = stopl then begin
      while r <> stopr do begin
       d^:= r^;   //copy rest
       inc(d);
       inc(r);
      end;
      goto endstep;
     end;
    end;
    while acompare(({po1+}l^{*asize})^,({po1+}r^{*asize})^) > 0 do begin
                                                         //merge from right;
     d^:= r^;
     inc(r);
     inc(d);
     if r = stopr then begin
      while l <> stopl do begin
       d^:= l^;   //copy rest
       inc(d);
       inc(l);
      end;
      goto endstep;
     end; 
    end;
   end;
endstep:
   if stopr = stops then begin
    break;  //run finished
   end;
   l:= stopr; //next step
  {$ifdef FPC}
   r:= l + step;
  {$else}
   r:= pointer(pchar(l) + step*sizeof(l^));
  {$endif}
   if pchar(r) >= pchar(stops) then begin
  {$ifdef FPC}
    r:= stops-1;
  {$else}
    r:= pointer(pchar(stops)-1*sizeof(stops^));
  {$endif}
   end;
   if r = l then begin
    d^:= l^;
    break;
   end;
   stopl:= r;
  {$ifdef FPC}
   stopr:= r + step;
  {$else}
   stopr:= pointer(pchar(r) + step*sizeof(r^));
  {$endif}
   if pchar(stopr) > pchar(stops) then begin
    stopr:= stops;
   end;
  end;
  d:= source;     //swap buffer
  source:= dest;
  dest:= d;
  step:= step*2;
 end;

 if source <> pointer(apointerlist) then begin
  apointerlist:= ar1;
 end;
end;

procedure checkrefmoved(const aindexlist: integerarty; var refindex: integer;
                                                            out moved: boolean);
var
 int1,int2,int3: integer;
 bo1: boolean;
begin
 int2:= refindex;
 bo1:= false;
 for int1:= high(aindexlist) downto 0 do begin
  int3:= aindexlist[int1];
  if not bo1 then begin
   bo1:= int3 <> int1;
  end;
  if int3 = int2 then begin
   refindex:= int1;
   if bo1 then begin
    break;
   end;
  end;
 end;
 moved:= bo1;
end;

procedure mergesort(const adata: pointer; const asize,acount: integer;
                        const acompare: sortcomparemethodty;
                        out aindexlist: integerarty;
                        var refindex: integer; out moved: boolean);
begin
 mergesort(adata,asize,acount,acompare,aindexlist);
 checkrefmoved(aindexlist,refindex,moved);
end;

procedure mergesort(const acount: integer;
          const acompare: indexsortcomparemethodty; out aindexlist: integerarty);
        //todo: optimize
var
 ar1: integerarty;
 step: integer;
 l,r,d: pinteger;
 stopl,stopr,stops: pinteger;
 source,dest: pinteger;
 int1: integer;
label
 endstep;
begin
 if acount = 0 then begin
  aindexlist:= nil;
  exit;
 end;
 allocuninitedarray(acount,sizeof(integer),ar1);
 allocuninitedarray(acount,sizeof(integer),aindexlist);
 for int1:= acount-1 downto 0 do begin
  aindexlist[int1]:= int1;
 end;
 source:= pointer(aindexlist);
 dest:= pointer(ar1);
 step:= 1;
 while step < acount do begin
  d:= dest;
  l:= source;
 {$ifdef FPC}
  r:= source+step;
 {$else}
  r:= pointer(pchar(source)+step*sizeof(source^));
 {$endif}
  stopl:= r;
 {$ifdef FPC}
  stopr:= r+step;
 {$else}
  stopr:= pointer(pchar(r)+step*sizeof(r^));
 {$endif}
 {$ifdef FPC}
  stops:= source + acount;
 {$else}
  stops:= pointer(pchar(source) + alength*sizeof(source^));
 {$endif}
  if pchar(stopr) > pchar(stops) then begin
   stopr:= stops;
  end;
  while true do begin //runs
   while true do begin //steps
    while acompare(l^,r^) <= 0 do begin
                                                           //merge from left
     d^:= l^;
     inc(l);
     inc(d);
     if l = stopl then begin
      while r <> stopr do begin
       d^:= r^;   //copy rest
       inc(d);
       inc(r);
      end;
      goto endstep;
     end;
    end;
    while acompare(l^,r^) > 0 do begin
                                                         //merge from right;
     d^:= r^;
     inc(r);
     inc(d);
     if r = stopr then begin
      while l <> stopl do begin
       d^:= l^;   //copy rest
       inc(d);
       inc(l);
      end;
      goto endstep;
     end; 
    end;
   end;
endstep:
   if stopr = stops then begin
    break;  //run finished
   end;
   l:= stopr; //next step
  {$ifdef FPC}
   r:= l + step;
  {$else}
   r:= pointer(pchar(l) + step*sizeof(l^));
  {$endif}
   if pchar(r) >= pchar(stops) then begin
  {$ifdef FPC}
    r:= stops-1;
  {$else}
    r:= pointer(pchar(stops)-1*sizeof(stops^));
  {$endif}
   end;
   if r = l then begin
    d^:= l^;
    break;
   end;
   stopl:= r;
  {$ifdef FPC}
   stopr:= r + step;
  {$else}
   stopr:= pointer(pchar(r) + step*sizeof(r^));
  {$endif}
   if pchar(stopr) > pchar(stops) then begin
    stopr:= stops;
   end;
  end;
  d:= source;     //swap buffer
  source:= dest;
  dest:= d;
  step:= step*2;
 end;

 if source <> pointer(aindexlist) then begin
  aindexlist:= ar1;
 end;
end;

procedure mergesort(const acount: integer; 
          const acompare: indexsortcomparemethodty; out aindexlist: integerarty;
          var refindex: integer; out moved: boolean); overload;
begin
 mergesort(acount,acompare,aindexlist);
 checkrefmoved(aindexlist,refindex,moved);
end;

procedure mergesort(var adata: pointerarty; const acount: integer;
                                  const compare: pointercomparemethodty);
var
 ar1: pointerarty;
 step: integer;
 l,r,d: ppointer;
 stopl,stopr,stops: ppointer;
 source,dest: ppointer;
label
 endstep;
begin
 allocuninitedarray(length(adata),sizeof(pointer),ar1);
 source:= pointer(adata);
 dest:= pointer(ar1);
 step:= 1;
 while step < acount do begin
  d:= dest;
  l:= source;
 {$ifdef FPC}
  r:= source + step;
 {$else}
  r:= pointer(pchar(source) + step*sizeof(source^));
 {$endif}
  stopl:= r;
 {$ifdef FPC}
  stopr:= r+step;
 {$else}
  stopr:= pointer(pchar(r)+step*sizeof(r^));
 {$endif}
 {$ifdef FPC}
  stops:= source + acount;
 {$else}
  stops:= pointer(pchar(source) + acount*sizeof(source^));
 {$endif}
  if pchar(stopr) > pchar(stops) then begin
   stopr:= stops;
  end;
  while true do begin //runs
   while true do begin //steps
    while compare(l^,r^) <= 0 do begin //merge from left
     d^:= l^;
     inc(l);
     inc(d);
     if l = stopl then begin
      while r <> stopr do begin
       d^:= r^;   //copy rest
       inc(d);
       inc(r);
      end;
      goto endstep;
     end;
    end;
    while compare(l^,r^) > 0 do begin //merge from right;
     d^:= r^;
     inc(r);
     inc(d);
     if r = stopr then begin
      while l <> stopl do begin
       d^:= l^;   //copy rest
       inc(d);
       inc(l);
      end;
      goto endstep;
     end; 
    end;
   end;
endstep:
   if stopr = stops then begin
    break;  //run finished
   end;
   l:= stopr; //next step
  {$ifdef FPC}
   r:= l + step;
  {$else}
   r:= pointer(pchar(l) + step*sizeof(l^));
  {$endif}
   if pchar(r) >= pchar(stops) then begin
  {$ifdef FPC}
    r:= stops-1;
  {$else}
    r:= pointer(pchar(stops)-1*sizeof(stops^));
  {$endif}
   end;
   if r = l then begin
    d^:= l^;
    break;
   end;
   stopl:= r;
  {$ifdef FPC}
   stopr:= r + step;
  {$else}
   stopr:= pointer(pchar(r) + step*sizeof(r^));
  {$endif}
   if pchar(stopr) > pchar(stops) then begin
    stopr:= stops;
   end;
  end;
  d:= source;     //swap buffer
  source:= dest;
  dest:= d;
  step:= step*2;
 end;
 if source <> pointer(adata) then begin
  adata:= ar1;
 end;
end;
(*
procedure doquicksortarray(var info: sortinfoty; l, r: Integer);
var
  i, j: Integer;
  p: integer;
  int1: integer;
begin
 with info do begin
  repeat
   i := l;
   j := r;
   p := (l + r) shr 1;
   repeat
    repeat
     int1:= compare((sortlist + indexlist[i] *size)^,(sortlist + indexlist[p] *size)^);
     if int1 = 0 then begin
      int1:= indexlist[i]-indexlist[p];
     end;
     if int1 >= 0 then break;
     inc(i);
    until false;
    repeat
     int1:= compare((sortlist + indexlist[j] *size)^,(sortlist + indexlist[p] *size)^);
     if int1 = 0 then begin
      int1:= indexlist[j]-indexlist[p];
     end;
     if int1 <= 0 then break;
     dec(j);
    until false;
    if i <= j then  begin
     int1:= indexlist[i];
     indexlist[i]:= indexlist[j];
     indexlist[j]:= int1;
     if p = i then begin
      p := j
     end
     else begin
      if p = j then begin
       p := i;
      end;
     end;
     Inc(i);
     Dec(j);
    end;
   until i > j;
   if l < j then begin
    doquickSortarray(info,l, j);
   end;
   l := i;
  until i >= r;
 end;
end;
*)
(*
procedure quicksortarray(var asortlist; const acompare: arraysortcomparety;
                            const asize,alength: integer; const order: boolean;
                            out aindexlist: integerarty);
                            //asortlist = array of type
var
 info: sortinfoty;
 int1: integer;
 
begin
 if alength > 0 then begin
  setlength(aindexlist,alength);
  dec(alength);
  for int1:= 0 to alength do begin
   aindexlist[int1]:= int1;
  end;
  with info do begin
   indexlist:= aindexlist;
   sortlist:= pointer(asortlist);
   compare:= acompare;
   size:= asize;
  end;
  doquicksortarray(info,0,alength);
  if order then begin
   orderarray(aindexlist,asortlist,asize);
  end;
 end;
end;
*)

const
 adsize = 2*sizeof(sizeint);

function initorderbuffer(var sortlist; const size: integer; clear: boolean;
                             out destpo: pchar): boolean;
begin
 if pointer(sortlist) = nil then begin
  result:= false;
 end
 else begin
  getmem(destpo,size*length(bytearty(sortlist))+adsize);
  psizeint(destpo)^:= 1; //refcount
  inc(destpo,sizeof(sizeint));
  psizeint(destpo)^:= pinteger(pchar(sortlist)-sizeof(sizeint))^; //length or high
  inc(destpo,sizeof(sizeint));
  result:= true;
  if clear then begin
   fillchar(destpo^,size*length(bytearty(sortlist)),0);
  end;
 end;
end;

procedure storebuffer(const asource: pchar; var sortlist);
var
 po1: psizeint;
begin
 po1:= psizeint(pchar(sortlist) - 2*sizeof(sizeint));
 dec(po1^);
 if po1^ >= 0 then begin
  if po1^ = 0 then begin
   freemem(po1);
  end
 end
 else begin
  inc(po1^) //constant
 end;
 pointer(sortlist):= asource;
end;

procedure orderarray(const sourceorderlist: integerarty; var sortlist; size: integer);
         //sortlist = array of type
var
 po2: pchar;
 po3: pchar;
 int1: integer;
begin
 if initorderbuffer(sortlist,size,false,po2) then begin
  po3:= po2;
  for int1:= 0 to high(sourceorderlist) do begin
   move((pchar(sortlist)+sourceorderlist[int1] * size)^,po3^,size);
   inc(po3,size);
  end;
  storebuffer(po2,sortlist);
 end;
end;

procedure reorderarray(const destorderlist: integerarty; var sortlist; size: integer);
         //sortlist = array of type
var
 po2: pchar;
 po3: pchar;
 int1: integer;
begin
 if initorderbuffer(sortlist,size,false,po2) then begin
  po3:= pchar(sortlist);
  for int1:= 0 to high(destorderlist) do begin
   move(po3^,(po2+destorderlist[int1] * size)^,size);
   inc(po3,size);
  end;
  storebuffer(po2,sortlist);
 end;
end;

procedure orderarray(const sourceorderlist: integerarty; var sortlist: pointerarty);
var
 po2: pchar;
 int1: integer;
begin
 if initorderbuffer(sortlist,sizeof(pointer),false,po2) then begin
  for int1:= 0 to high(sourceorderlist) do begin
   pointerarty(pointer(po2))[int1]:= sortlist[sourceorderlist[int1]];
  end;
  storebuffer(po2,sortlist);
 end;
end;

procedure orderarray(const sourceorderlist: integerarty;
                                   var sortlist: integerarty);
var
 po2: pchar;
 int1: integer;
begin
 if initorderbuffer(sortlist,sizeof(integer),false,po2) then begin
  for int1:= 0 to high(sourceorderlist) do begin
   integerarty(pointer(po2))[int1]:= sortlist[sourceorderlist[int1]];
  end;
  storebuffer(po2,sortlist);
 end;
end;

procedure reorderarray(const destorderlist: integerarty; var sortlist: pointerarty);
var
 po2: pchar;
 int1: integer;
begin
 if initorderbuffer(sortlist,sizeof(pointer),false,po2) then begin
  for int1:= 0 to high(destorderlist) do begin
   pointerarty(pointer(po2))[destorderlist[int1]]:= sortlist[int1];
  end;
  storebuffer(po2,sortlist);
 end;
end;

procedure reorderarray(const destorderlist: integerarty;
                                              var sortlist: integerarty);
var
 po2: pchar;
 int1: integer;
begin
 if initorderbuffer(sortlist,sizeof(integer),false,po2) then begin
  for int1:= 0 to high(destorderlist) do begin
   integerarty(pointer(po2))[destorderlist[int1]]:= sortlist[int1];
  end;
  storebuffer(po2,sortlist);
 end;
end;

procedure orderarray(const sourceorderlist: integerarty; var sortlist: stringarty);
var
 ar1: stringarty;
 int1: integer;
begin
 setlength(ar1,length(sourceorderlist));
 for int1:= 0 to high(sourceorderlist) do begin
  ar1[int1]:= sortlist[sourceorderlist[int1]];
 end;
 sortlist:= ar1;
end;

procedure reorderarray(const destorderlist: integerarty; var sortlist: stringarty);
var
 ar1: stringarty;
 int1: integer;
begin
 setlength(ar1,length(destorderlist));
 for int1:= 0 to high(destorderlist) do begin
  ar1[destorderlist[int1]]:= sortlist[int1];
 end;
 sortlist:= ar1;
end;

procedure orderarray(const sourceorderlist: integerarty; var sortlist: msestringarty);
var
 ar1: msestringarty;
 int1: integer;
begin
 setlength(ar1,length(sourceorderlist));
 for int1:= 0 to high(sourceorderlist) do begin
  ar1[int1]:= sortlist[sourceorderlist[int1]];
 end;
 sortlist:= ar1;
end;

procedure reorderarray(const destorderlist: integerarty; var sortlist: msestringarty);
var
 ar1: msestringarty;
 int1: integer;
begin
 setlength(ar1,length(destorderlist));
 for int1:= 0 to high(destorderlist) do begin
  ar1[destorderlist[int1]]:= sortlist[int1];
 end;
 sortlist:= ar1;
end;

procedure sortarray(var sortlist; const size: integer;
                       const compare: arraysortcomparety;
                       out indexlist: integerarty);
begin
 mergesortarray(sortlist,size,length(bytearty(sortlist)),compare,indexlist,true);
end;

procedure sortarray(var sortlist; const size: integer;
                            const compare: arraysortcomparety);
var
 indexlist: integerarty;
begin
 sortarray(sortlist,size,compare,indexlist);
end;

procedure sortarray(var dest: pointerarty; const compare: arraysortcomparety;
                    out indexlist: integerarty);
begin
 mergesortarray(dest,sizeof(pointer),length(dest),compare,indexlist,false);
 orderarray(indexlist,dest);
end;

procedure sortarray(var dest: pointerarty; const compare: arraysortcomparety);
var
 indexlist: integerarty;
begin
 sortarray(dest,compare,indexlist);
end;

procedure sortarray(var dest: msestringarty; const compare: arraysortcomparety;
                    out indexlist: integerarty);
begin
 mergesortarray(dest,sizeof(pointer),length(dest),compare,indexlist,false);
 orderarray(indexlist,dest);
end;

procedure sortarray(var dest: msestringarty; const compare: arraysortcomparety);
var
 indexlist: integerarty;
begin
 sortarray(dest,compare,indexlist);
end;

procedure sortarray(var dest: stringarty; const compare: arraysortcomparety;
                    out indexlist: integerarty);
begin
 mergesortarray(dest,sizeof(pointer),length(dest),compare,indexlist,false);
 orderarray(indexlist,dest);
end;

procedure sortarray(var dest: stringarty; const compare: arraysortcomparety);
var
 indexlist: integerarty;
begin
 sortarray(dest,compare,indexlist);
end;
                    
procedure sortarray(var dest: pointerarty);
begin
 sortarray(dest,sizeof(pointer),{$ifdef FPC}@{$endif}comparepointer);
end;

procedure sortarray(var dest: integerarty);
begin
 sortarray(dest,sizeof(integer),{$ifdef FPC}@{$endif}compareinteger);
end;

procedure sortarray(var dest: integerarty; out indexlist: integerarty);
begin
 sortarray(dest,sizeof(integer),{$ifdef FPC}@{$endif}compareinteger,indexlist);
end;

function comparelongword(const l,r): integer;
begin
 if longword(l) > longword(r) then begin
  result:= 1;
 end
 else begin
  if longword(l) < longword(r) then begin
   result:= -1;
  end
  else begin
   result:= 0;
  end;
 end;
end;

procedure sortarray(var dest: longwordarty);
begin
 sortarray(dest,sizeof(longword),{$ifdef FPC}@{$endif}comparelongword);
end;

procedure sortarray(var dest: longwordarty; out indexlist: integerarty);
begin
 sortarray(dest,sizeof(longword),{$ifdef FPC}@{$endif}comparelongword,indexlist);
end;

function comparereal(const l,r): integer;
var
 rea1: real;
begin
 rea1:= real(l) - real(r);
 if rea1 < 0 then begin
  result:= -1;
 end
 else begin
  if rea1 > 0 then begin
   result:= 1;
  end
  else begin
   result:= 0;
  end;
 end;
end;

function comparerealty(const l,r): integer;
begin
 result:= cmprealty(realty(l),realty(r));
end;

procedure sortarray(var dest: realarty); overload;
begin
 sortarray(dest,sizeof(realty),{$ifdef FPC}@{$endif}comparerealty);
end;

procedure sortarray(var dest: realarty; out indexlist: integerarty); overload;
begin
 sortarray(dest,sizeof(realty),{$ifdef FPC}@{$endif}comparerealty,indexlist);
end;

function comparemsestring(const l,r): integer;
begin
// {$ifdef FPC}
// result:= comparestr(msestring(l),msestring(r)); //!!!todo optimize
// {$else}
 result:= msecomparestr(msestring(l),msestring(r));
// {$endif}
end;

function compareimsestring(const l,r): integer;
begin
// {$ifdef FPC}
// result:= comparetext(msestring(l),msestring(r));
// {$else}
 result:= msecomparetext(msestring(l),msestring(r));
// {$endif}
end;

function compareasciistring(const l,r): integer;
begin
 result:= comparestr(ansistring(l),ansistring(r));
end;

function compareiasciistring(const l,r): integer;
begin
 result:= comparetext(ansistring(l),ansistring(r));
end;

function compareansistring(const l,r): integer;
begin
 result:= ansicomparestr(ansistring(l),ansistring(r));
end;

function compareiansistring(const l,r): integer;
begin
 result:= ansicomparetext(ansistring(l),ansistring(r));
end;

procedure sortarray(var dest: msestringarty;
                             const sortmode: stringsortmodety = sms_up);
begin
 setlength(dest,length(dest)); //refcount1
 case sortmode of
  sms_up: sortarray(dest,sizeof(msestring),
                                  {$ifdef FPC}@{$endif}comparemsestring);
  sms_upi: sortarray(dest,sizeof(msestring),
                                  {$ifdef FPC}@{$endif}compareimsestring);
 end;
end;

procedure sortarray(var dest: msestringarty; const sortmode: stringsortmodety;
                            out indexlist: integerarty);
begin
 setlength(dest,length(dest)); //refcount1
 case sortmode of
  sms_up: sortarray(dest,sizeof(msestring),
                          {$ifdef FPC}@{$endif}comparemsestring,indexlist);
  sms_upi: sortarray(dest,sizeof(msestring),
                          {$ifdef FPC}@{$endif}compareimsestring,indexlist);
//   sms_upi: mergesortarray(ziel,0,length(ziel)-1,compareimsestring,sizeof(msestring));
 end;
end;

procedure sortarray(var dest: stringarty; 
                         const sortmode: stringsortmodety = sms_upascii);
begin
 setlength(dest,length(dest)); //refcount1
 case sortmode of
  sms_up: sortarray(dest,sizeof(string),{$ifdef FPC}@{$endif}compareansistring);
  sms_upi: sortarray(dest,sizeof(string),{$ifdef FPC}@{$endif}compareiansistring);
//   sms_upi: mergesortarray(ziel,0,length(ziel)-1,compareistringansi,sizeof(string));
  sms_upascii: sortarray(dest,sizeof(string),
                              {$ifdef FPC}@{$endif}compareasciistring);
//   sms_upiascii: mergesortarray(ziel,0,length(ziel)-1,compareistringascii,sizeof(string));
 end;
end;

procedure sortarray(var dest: stringarty; const sortmode: stringsortmodety;
                                                    out indexlist: integerarty);
begin
 setlength(dest,length(dest)); //refcount1
 case sortmode of
  sms_up: sortarray(dest,sizeof(string),
               {$ifdef FPC}@{$endif}compareansistring,indexlist);
  sms_upi: sortarray(dest,sizeof(string),
               {$ifdef FPC}@{$endif}compareiansistring,indexlist);
//   sms_upi: mergesortarray(ziel,0,length(ziel)-1,compareistringansi,sizeof(string));
  sms_upascii: sortarray(dest,sizeof(string),
                        {$ifdef FPC}@{$endif}compareasciistring,indexlist);
//   sms_upiascii: mergesortarray(ziel,0,length(ziel)-1,compareistringascii,sizeof(string));
 end;
end;

function cmparray(const a,b: msestringarty): boolean;
               //true if equal
var
 int1: integer;
begin
 result:= a = b;
 if not result and (high(a) = high(b)) then begin
  for int1:= 0 to high(a) do begin
   if a[int1] <> b[int1] then begin
    exit;
   end;
  end;
  result:= true;
 end;
end;

function opentodynarraym(const items: array of msestring): msestringarty;
var
 int1: integer;
begin
 setlength(result,length(items));
 for int1:= 0 to high(items) do begin
  result[int1]:= items[int1];
 end;
end;

function opentodynarrays(const items: array of string): stringarty;
var
 int1: integer;
begin
 setlength(result,length(items));
 for int1:= 0 to high(items) do begin
  result[int1]:= items[int1];
 end;
end;

function opentodynarrayi(const items: array of integer): integerarty;
var
 int1: integer;
begin
 setlength(result,length(items));
 for int1:= 0 to high(items) do begin
  result[int1]:= items[int1];
 end;
end;

function opentodynarrayr(const items: array of realty): realarty;
var
 int1: integer;
begin
 setlength(result,length(items));
 for int1:= 0 to high(items) do begin
  result[int1]:= items[int1];
 end;
end;

function opentodynarraybo(const items: array of boolean): booleanarty;
var
 int1: integer;
begin
 setlength(result,length(items));
 for int1:= 0 to high(items) do begin
  result[int1]:= items[int1];
 end;
end;

function opentodynarrayby(const items: array of byte): bytearty;
var
 int1: integer;
begin
 setlength(result,length(items));
 for int1:= 0 to high(items) do begin
  result[int1]:= items[int1];
 end;
end;

end.

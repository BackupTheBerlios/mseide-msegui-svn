{ MSEide Copyright (c) 2008 by Martin Schreiber
   
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
}
unit cdesignparser;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseparser,msedesignparser,mselist,msestrings;
 
type

 tcdesignparser = class(tcparser,idesignparser)
  private
   funitinfopo: punitinfoty;
   fimplementation: boolean;
   finterface: boolean;
   finterfaceonly: boolean;
   fnoautoparse: boolean;
   ffunctionlevel: integer;
  protected
   function parsefunction: boolean;
   function parsefunctionparams: boolean;
   function parseblock: boolean;
   function parsetypedef: boolean;
   function parsevardef: boolean;
   function parsestatement: boolean;
  public
   constructor create(unitinfopo: punitinfoty;
              const afilelist: tmseindexednamelist;
              const getincludefile: getincludefileeventty;
              const ainterfaceonly: boolean); overload;
   constructor create(const afilelist: tmseindexednamelist; 
                 const atext: string); overload;
   procedure parse; override;  
   procedure clear; override;
 end;
 
procedure parsecdef(const adef: pdefinfoty; out atext: string; out scope: tdeflist);

implementation
uses
 sourceupdate;

procedure parsecdef(const adef: pdefinfoty; out atext: string; out scope: tdeflist);
begin
 scope:= tdeflist.create(adef^.kind);
 atext:= sourceupdater.getdefinfotext(adef);
 if atext <> '' then begin
 end;
end;
 
{ tcdesignparser }

constructor tcdesignparser.create(unitinfopo: punitinfoty;
               const afilelist: tmseindexednamelist;
               const getincludefile: getincludefileeventty;
               const ainterfaceonly: boolean);
begin
 finterfaceonly:= ainterfaceonly;
 inherited create(afilelist);
 funitinfopo:= unitinfopo;
 funitinfopo^.interfacecompiled:= false;
 funitinfopo^.implementationcompiled:= false;
 ongetincludefile:= getincludefile;
end;

constructor tcdesignparser.create(const afilelist: tmseindexednamelist; 
                 const atext: string);
begin
 fnoautoparse:= true;
 inherited create(afilelist,atext);
end;

{
constructor tcdesignparser.create(unitinfopo: punitinfoty;
              const afilelist: tmseindexednamelist;
              const getincludefile: getincludefileeventty;
              const ainterfaceonly: boolean; const atext: ansistring);
begin
 create(unitinfopo,afilelist,getincludefile,ainterfaceonly);
 create(afilelist,atext);
end;
}
function tcdesignparser.parsetypedef: boolean;
begin
 result:= false;
end;

function tcdesignparser.parsevardef: boolean;
begin
 result:= false;
end;

function tcdesignparser.parsefunctionparams: boolean;
begin
 result:= false;
 mark;
 if checkoperator('(') then begin
  result:= findoperator(')');
 end;
 if result then begin
  pop;
 end
 else begin
  back;
 end;
end;

function tcdesignparser.parseblock: boolean;
var
 ch1: char;
begin
 result:= true;
 mark;
 if checkoperator('{') then begin
  while not eof do begin
   ch1:= getoperator;
   case ch1 of
    '}': begin
     break;
    end;
    '{': begin
     parseblock();
    end;
    else begin
     parsestatement;
    end;
   end;
  end;
 end;
 if result then begin
  pop;
 end
 else begin
  back;
 end;
end;

function tcdesignparser.parsefunction: boolean;
var
 lstr1,lstr2: lstringty;
 ch1: char;
 pos1: sourceposty;
 po1: pfunctioninfoty;
begin
 inc(ffunctionlevel);
 result:= false;
 mark;
 pos1:= sourcepos;
 with funitinfopo^ do begin
  if getorigname(lstr1) and getorigname(lstr2) then begin
   if parsefunctionparams then begin
    if checkoperator(';') then begin
     result:= true;  //header
    end
    else begin
     if testoperator('{') then begin
      po1:= c.functions.newitem;
      if parseblock then begin
       result:= true;
       po1^.name:= lstringtostring(lstr2);
       deflist.add(pos1,sourcepos,po1);
      end;
      if not result then begin
       c.functions.deletelast;
      end;
     end;
    end;    
   end;
  end;
 end;
 if result then begin
  pop;
 end
 else begin
  back;
 end;
 dec(ffunctionlevel);
end;

function tcdesignparser.parsestatement: boolean;
var
 lstr1,lstr2: lstringty;
 ch1: char;
 bo1: boolean;
begin
 result:= true;
 bo1:= ffunctionlevel = 0;
 mark;
 if not bo1 and checknamenoident then begin
  repeat
   ch1:= getoperator;
   case ch1 of
    '(': begin
     findclosingbracket; //function call
    end;
    '=': begin
     skipstatement;      //assignment
     break;
    end;
    ';': begin
     break;
    end;
    else begin
     bo1:= true;
     break;
    end;
   end;
  until ch1 = #0;
 end;
 if bo1 then begin
  back;
  if not parsefunction then begin
   if not parsetypedef then begin
    if not parsevardef then begin
     skipstatement;
    end;
   end;
  end;
 end
 else begin
  pop;
 end;
end;

procedure tcdesignparser.parse;
begin
 inherited;
 if fnoautoparse then begin
  exit;
 end;
 initcompinfo(funitinfopo^);
 while not eof do begin
  parsestatement;
 end;
 afterparse(self,funitinfopo^,true);
end;

procedure tcdesignparser.clear;
begin
 inherited;
 ffunctionlevel:= 0;
end;

end.

{ MSEgui Copyright (c) 1999-2008 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit mseformatstr;     //stringwandelroutinen 31.5.99 mse

{$ifdef FPC}{$mode objfpc}{$h+}{$interfaces corba}{$endif}

interface
uses
 Classes, msetypes,msestrings,SysUtils,msesys;
const
// noformatsettings = 14.5;    //rtlversion
 noformatsettings = 15;    //rtlversion
 fc_keinplatzchar = '*';
 nullen = '000000000000000000000000000000';
 msenullen = msestring('000000000000000000000000000000');
 msespace = msestring('                              ');

type
 numbasety = (nb_bin,nb_oct,nb_dec,nb_hex);
 
function formatdatetimemse(const formatstr: msestring; const datetime: tdatetime;
            const formatsettings: tformatsettingsmse): msestring; overload;
function formatdatetimemse(const formatstr: msestring;
                          const datetime: tdatetime): msestring; overload;

function formatfloatmse(const value: double; const format: msestring; 
                         const formatsettings: tformatsettingsmse;
                         const dot: boolean = false): msestring; overload;
   //dot = true -> always '.' as decimal separator
   //formatstring:
   // formats for positive, negative and zero value can be separated by ;
   // ' and " qoted text as is
   // c -> currencyformat
   //
   // + 0 or number digit
   // |+ show defaultformatsettingsmse.thousandseparator
   // ||+ defaultformatsettingsmse.decimalseparator or '.' if dot = true
   // ||| removed if there are no fract digits
   // |||+ 0 or number digit
   // 0,.0
   //
   // + space or number digit
   // | + removed or number digit
   // #.#
   //
   //    + scientific notation with 'e'
   //    |+ remove '+' from positive exponent
   //    ||+++ 0 or exponent digit
   // 0.0e-000
   //
   //     + show '+' of positive exponent
   // 0.0e+
   //
   //    + scientific notation with 'E'
   // 0.0E
   //
   //    + engeneering notation with 'e', exponent = n*3
   //    |++ fract digits
   // 0.0f00
   //
   //     +++++ mantissa - 1 digits
   // 0.0f#####
   //
   //    + engeneering notation with 'E', exponent = n*3
   // 0.0F
   //
   //    + engeneering notation with metric system prefixes, exponent = n*3
   // 0.0g   
   //
   //    + engeneering notation with metric system prefixes, exponent = n*3
   // 0.0G   
   //
   // examples for value = 12345.678
   // '0.0'    ->  '12345.7'
   // '0.000e   ->  '1.235e4'
   // '0.000f   ->  '12.346e3'
   // '0.000g   ->  '12.346k'
   // '0.###f   ->  '12.35e3'

function formatfloatmse(const value: double; const format: msestring; 
                         const dot: boolean = false): msestring; overload;
   
function realtostr(const value: double): string;     //immer'.' als separator
function strtoreal(const s: string): double;   //immer'.' als separator

function bytetohex(const inp: byte): string;
 //wandelt byte in zwei ascii hexzeichen
function wordtohex(const inp: word; lsbfirst: boolean = false): string;
 //wandelt word in vier ascii hexzeichen


function dectostr(const inp: integer; digits: integer): string;
          //leading zeroes if digits < 0
function bintostr(inp: longword; digits: integer): string;
   //convert longword to binstring, digits = bit count
function octtostr(inp: longword; digits: integer): string;
   //convert longword to octaltring, digits = octet count
function hextostr(inp: longword; digits: integer): string;
   //convert longword to hexstring, digits = nibble count
function hextocstr(const inp: longword; stellen: integer): string;
   //convert longword to 0x..., digits = nibble count
function ptruinttocstr(inp: ptruint): string;
   //convert ptruint to 0x...
function intvaluetostr(const value: integer; const base: numbasety = nb_dec;
                          const bitcount: integer = 32): string;

function trystrtoptruint(const inp: string; out value: ptruint): boolean;
function strtoptruint(const inp: string): ptruint;

 //todo: 64bit
function trystrtobin(const inp: string; out value: longword): boolean;
function strtobin(const inp: string): longword;
function trystrtooct(const inp: string; out value: longword): boolean;
function strtooct(const inp: string): longword;
function trystrtodec(const inp: string; out value: longword): boolean;
function strtodec(const inp: string): longword;
function trystrtohex(const inp: string; out value: longword): boolean;
function strtohex(const inp: string): longword;

function trystrtointvalue(const inp: string;
                            out value: longword): boolean; overload;
   //% prefix -> bin, & -> oct, # -> dez, $ -> hex 0x -> hex
function strtointvalue(const inp: string): longword; overload;
function trystrtointvalue(const text: msestring; base: numbasety;
                            out value: longword): boolean; overload;
function strtointvalue(const text: msestring; base: numbasety): longword; overload;


function bytestrtostr(const inp: ansistring; base: numbasety; abstand: boolean): string;
   //wandelt bytefolge in ascii hexstring
function bytestrtobin(const inp: ansistring; abstand: boolean): string;
   //wandelt bytefolge in ascii binstring,
   // letztes zeichen = anzahl gueltige bits in letztem byte
function bitmaske(const data: ansistring): integer; //anzahl gueltige bits in vorletztem byte
function bitcount(const data: ansistring): integer; //anzahl gueltige bits

function bcdtostr(inp: byte): string;
 //wandelt bcdwert in zwei ascii zeichen
function bytetobcd(inp: byte): word;
 //wandelt byte in bcdwert
function bcdtobyte(inp: byte): byte;
 //wandelt bcdbyte in byte
function strtobytestr(inp: string): ansistring;
 //wandelt hex asciistring in bytefolge
function strtobinstr(inp: string): ansistring;
 //wandelt bin asciistring in bytefolge
function strtobytes(const inp: string; out dest: bytearty): boolean;
//msb first, true if ok

function inttostrlen(inp: integer; len: integer;
     rechtsbuendig: boolean = true; fillchar: char = ' '): ansistring;
 //wandelt integer in string fester laenge
{
function filename(inp: string): string;
//bringt filenamen ohne pfad und extension
function replaceext(inp,ext: string): string;
//ersetzt fileextension
}
function bcdtoint(inp: byte): integer;
function inttobcd(inp: integer): byte;

function stringtotime(const avalue: msestring): tdatetime;
function timetostring(const avalue: tdatetime; 
                          const format: msestring = 't'): msestring;
function datetostring(const avalue: tdatetime; 
                          const format: msestring = 'c'): msestring;
function datetimetostring(const avalue: tdatetime; 
                          const format: msestring = 'c'): msestring;
function stringtodatetime(const avalue: msestring): tdatetime;

//function strtotime(ein: string; var resultat: tdatetime): boolean;
 //true bei fehler
{wandelt string in zeit, 0.0 -> leer,
                         friss -> 0.000001 ca. 1/10 sek, 0:0:0 -> 0.000002,}
//function strtodat(ein: string; var resultat: tdatetime): boolean;
 //true bei fehler
{wandelt string in datum year = 0 -> leer, bereich 1950..2049}

function timemse(const value: tdatetime): tdatetime;
  //bringt timeanteil im mseformat

function cstringtostring(inp: pchar): string; overload;
function cstringtostring(const inp: string): string; overload;
function cstringtostringvar(var inp: pchar): string;
function stringtocstring(const inp: msestring): string;
function stringtopascalstring(const value: msestring): string;
function pascalstringtostring(const value: string): msestring;
                                    //increments inputpointer

//{$ifdef FPC}
 {$undef withformatsettings}
//{$else}
// {$if rtlversion > noformatsettings}
//  {$define withformatsettings}
// {$ifend}
//{$endif}

{$ifdef withformatsettings}
var
 defaultformatsettings: tformatsettings; //mit '.' als dezitrenner
{$endif}

const
 charhex: array[0..15] of char = 
          ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');
 hexchars: array[char] of byte = (
  $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80, //0
  $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80, //1
  $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80, //2
  $00,$01,$02,$03,$04,$05,$06,$07,$30,$09,$80,$80,$80,$80,$80,$80, //3
  $80,$0A,$0B,$0C,$0D,$0E,$0F,$80,$80,$80,$80,$80,$80,$80,$80,$80, //4
  $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80, //5
  $80,$0a,$0b,$0c,$0d,$0e,$0f,$80,$80,$80,$80,$80,$80,$80,$80,$80, //6
  $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80, //7
  $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80, //8
  $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80, //9
  $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80, //a
  $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80, //b
  $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80, //c
  $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80, //d
  $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80, //e
  $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80);//f
  
implementation

uses
 sysconst,msedate,msereal,Math,msefloattostr;
 
//copied from FPC dati.inc todo: use threadsave formatsettings
function formatdatetimemse(const formatstr: msestring; const datetime: tdatetime;
                  const formatsettings: tformatsettingsmse): msestring;
var
   ResultLen: integer;
   ResultBuffer: array[0..255] of msechar;
   ResultCurrent: pmsechar;

   procedure StoreStr(Str: pmsechar; Len: integer);
   begin
   if ResultLen + Len < SizeOf(ResultBuffer) div 2 then begin
      Move(Str^, ResultCurrent^, Len*sizeof(msechar));
      ResultCurrent := ResultCurrent + Len;
      ResultLen := ResultLen + Len;
      end ;
   end ;

   procedure StoreString(const Str: msestring);
   var Len: integer;
   begin
   Len := Length(Str);
   if ResultLen + Len < SizeOf(ResultBuffer) div 2 then begin // strmove not safe
      Move( pointer(Str)^,ResultCurrent^,Len*sizeof(msechar));
      ResultCurrent := ResultCurrent + Len;
      ResultLen := ResultLen + Len;
      end;
   end;

   procedure StoreInt(Value, Digits: integer);
   var S: msestring; Len: integer;
   begin
   S := IntToStr(Value);
   Len := Length(S);
   if Len < Digits then begin
      S := copy('0000', 1, Digits - Len) + S;
      Len := Digits;
      end ;
   StoreStr(pmsechar(pointer(S)), Len);
   end ;

var
   Year, Month, Day, DayOfWeek, Hour, Minute, Second, MilliSecond: word;

   procedure StoreFormat(const FormatStr: msestring);
   var
      Token,lastformattoken: msechar;
      FormatCurrent: pmsechar;
      FormatEnd: pmsechar;
      Count: integer;
      Clock12: boolean;
      P: pmsechar;
      tmp:integer;

   begin
   with formatsettings do begin
    FormatCurrent := Pmsechar(pointer(FormatStr));
    FormatEnd := FormatCurrent + Length(FormatStr);
    Clock12 := false;
    P := FormatCurrent;
    while P < FormatEnd do begin
       Token := charUpperCase(P^);
       if (Token = '"') or (token =  '''') then begin
          P := P + 1;
          while (P < FormatEnd) and (P^ <> Token) do
             P := P + 1;
          end
       else if Token = 'A' then begin
          if (mseStrLIComp(P, 'A/P', 3) = 0) or
             (mseStrLIComp(P, 'AMPM', 4) = 0) or
             (mseStrLIComp(P, 'AM/PM', 5) = 0) then begin
             Clock12 := true;
             break;
             end ;
          end ;
       P := P + 1;
       end ;
    token:=#255;
    lastformattoken:=' ';
    while FormatCurrent < FormatEnd do
      begin
       Token := charUpperCase(FormatCurrent^);
       Count := 1;
       P := FormatCurrent + 1;
          case Token of
             '''', '"': begin
                while (P < FormatEnd) and (p^ <> Token) do
                   P := P + 1;
                P := P + 1;
                Count := P - FormatCurrent;
                StoreStr(FormatCurrent + 1, Count - 2);
                end ;
             'A': begin
                if mseStrLIComp(FormatCurrent, pmsechar(msestring('AMPM')), 4) = 0 then begin
                   Count := 4;
                   if Hour < 12 then StoreString(TimeAMString)
                   else StoreString(TimePMString);
                   end
                else if mseStrLIComp(FormatCurrent, 'AM/PM', 5) = 0 then begin
                   Count := 5;
                   if Hour < 12 then StoreStr('am', 2)
                   else StoreStr('pm', 2);
                   end
                else if mseStrLIComp(FormatCurrent, 'A/P', 3) = 0 then begin
                   Count := 3;
                   if Hour < 12 then StoreStr('a', 1)
                   else StoreStr('p', 1);
                   end
                else
//                  Raise EConvertError.Create('Illegal character in format string');
                end ;
             '/': StoreStr(@DateSeparator, 1);
             ':': StoreStr(@TimeSeparator, 1);
             ' ', 'C', 'D', 'H', 'M', 'N', 'S', 'T', 'Y','Z' :
               begin
                 while (P < FormatEnd) and (charUpperCase(P^) = Token) do
                   P := P + 1;
                 Count := P - FormatCurrent;
                 case Token of
                    ' ': StoreStr(FormatCurrent, Count);
                    'Y': begin
                          if Count>2 then
                            StoreInt(Year, 4)
                          else
                            StoreInt(Year mod 100, 2);
                         end;
                    'M': begin
                          if lastformattoken='H' then
                            begin
                              if Count = 1 then
                                StoreInt(Minute, 0)
                              else
                                StoreInt(Minute, 2);
 
                            end
                          else
                            begin
                              case Count of
                                 1: StoreInt(Month, 0);
                                 2: StoreInt(Month, 2);
                                 3: StoreString(ShortMonthNames[Month]);
                                 4: StoreString(LongMonthNames[Month]);
                              end;
                            end;
                       end;
                    'D': begin
                          case Count of
                             1: StoreInt(Day, 0);
                             2: StoreInt(Day, 2);
                             3: StoreString(ShortDayNames[DayOfWeek]);
                             4: StoreString(LongDayNames[DayOfWeek]);
                             5: StoreFormat(ShortDateFormat);
                             6: StoreFormat(LongDateFormat);
                          end ;
                       end ;
                    'H': begin
                       if Clock12 then begin
                          tmp:=hour mod 12;
                          if tmp=0 then tmp:=12;
                          if Count = 1 then StoreInt(tmp, 0)
                          else StoreInt(tmp, 2);
                          end
                       else begin
                          if Count = 1 then StoreInt(Hour, 0)
                          else StoreInt(Hour, 2);
                          end ;
                       end ;
                    'N': begin
                       if Count = 1 then StoreInt(Minute, 0)
                       else StoreInt(Minute, 2);
                       end ;
                    'S': begin
                       if Count = 1 then StoreInt(Second, 0)
                       else StoreInt(Second, 2);
                       end ;
                    'Z': begin
                       if Count = 1 then StoreInt(MilliSecond, 0)
                       else StoreInt(MilliSecond, 3);
                       end ;
                    'T': begin
                       if Count = 1 then StoreFormat(ShortTimeFormat)
                       else StoreFormat(LongTimeFormat);
                       end ;
                    'C':
                      begin
                        StoreFormat(ShortDateFormat);
                        if (Hour<>0) or (Minute<>0) or (Second<>0) then
                         begin
                           StoreString(' ');
                           StoreFormat(LongTimeFormat);
                         end;
                      end;
                 end;
                 lastformattoken:=token;
               end;
             else
               StoreStr(@Token, 1);
          end ;
       FormatCurrent := FormatCurrent + Count;
       end ;
     end;
   end ;

begin
  DecodeDateFully(DateTime, Year, Month, Day, DayOfWeek);
  DecodeTime(DateTime, Hour, Minute, Second, MilliSecond);
  ResultLen := 0;
  ResultCurrent := @ResultBuffer[0];
  StoreFormat(FormatStr);
//  ResultBuffer[ResultLen] := #0;
//  result := StrPas(@ResultBuffer[0]);
  setlength(result,resultlen);
  move(resultbuffer,pointer(result)^,resultlen*sizeof(msechar));
end ;

function formatdatetimemse(const formatstr: msestring;
                          const datetime: tdatetime): msestring;
begin
 result:= formatdatetimemse(formatstr,datetime,defaultformatsettingsmse);
end;

(* 
//copied from FPC sysstr.inc
//todo: optimize, use threadsave formatsettings

Function FloatToTextFmt(Buffer: PmseChar; Value: Extended; format: PmseChar;
                         const formatsettings: tformatsettingsmse): Integer;

Var
  Digits: String[40];                         { String Of Digits                 }
  Exponent: String[8];                        { Exponent strin                   }
  FmtStart, FmtStop: PmseChar;                { Start And End Of relevant part   }
                                              { Of format String                 }
  ExpFmt, ExpSize: Integer;                   { Type And Length Of               }
                                              { exponential format chosen        }
  Placehold: Array[1..4] Of Integer;          { Number Of placeholders In All    }
                                              { four Sections                    }
  thousand: Boolean;                          { thousand separators?             }
  UnexpectedDigits: Integer;                  { Number Of unexpected Digits that }
                                              { have To be inserted before the   }
                                              { First placeholder.               }
  DigitExponent: Integer;                     { Exponent Of First digit In       }
                                              { Digits Array.                    }

  { Find end of format section starting at P. False, if empty }

  Function GetSectionEnd(Var P: PmseChar): Boolean;
  Var
    C: mseChar;
    SQ, DQ: Boolean;
  Begin
    Result := False;
    SQ := False;
    DQ := False;
    C := P[0];
    While (C<>#0) And ((C<>';') Or SQ Or DQ) Do
      Begin
      Result := True;
      Case C Of
        #34: If Not SQ Then DQ := Not DQ;
        #39: If Not DQ Then SQ := Not SQ;
      End;
      Inc(P);
      C := P[0];
      End;
  End;

  { Find start and end of format section to apply. If section doesn't exist,
    use section 1. If section 2 is used, the sign of value is ignored.       }

  Procedure GetSectionRange(section: Integer);
  Var
    Sec: Array[1..3] Of PmseChar;
    SecOk: Array[1..3] Of Boolean;
  Begin
    Sec[1] := format;
    SecOk[1] := GetSectionEnd(Sec[1]);
    If section > 1 Then
      Begin
      Sec[2] := Sec[1];
      If Sec[2][0] <> #0 Then
        Inc(Sec[2]);
      SecOk[2] := GetSectionEnd(Sec[2]);
      If section > 2 Then
        Begin
        Sec[3] := Sec[2];
        If Sec[3][0] <> #0 Then
          Inc(Sec[3]);
        SecOk[3] := GetSectionEnd(Sec[3]);
        End;
      End;
    If Not SecOk[1] Then
      FmtStart := Nil
    Else
      Begin
      If Not SecOk[section] Then
        section := 1
      Else If section = 2 Then
        Value := -Value;   { Remove sign }
      If section = 1 Then FmtStart := format Else
        Begin
        FmtStart := Sec[section - 1];
        Inc(FmtStart);
        End;
      FmtStop := Sec[section];
      End;
  End;

  { Find format section ranging from FmtStart to FmtStop. }

  Procedure GetFormatOptions;
  Var
    Fmt: PmseChar;
    SQ, DQ: Boolean;
    area: Integer;
  Begin
    SQ := False;
    DQ := False;
    Fmt := FmtStart;
    ExpFmt := 0;
    area := 1;
    thousand := False;
    Placehold[1] := 0;
    Placehold[2] := 0;
    Placehold[3] := 0;
    Placehold[4] := 0;
    While Fmt < FmtStop Do
      Begin
      Case Fmt[0] Of
        #34:
          Begin
          If Not SQ Then
            DQ := Not DQ;
          Inc(Fmt);
          End;
        #39:
          Begin
          If Not DQ Then
            SQ := Not SQ;
          Inc(Fmt);
          End;
      Else
        { This was 'if not SQ or DQ'. Looked wrong... }
        If Not (SQ Or DQ) Then
          Begin
          Case Fmt[0] Of
            '0':
              Begin
              Case area Of
                1:
                  area := 2;
                4:
                  Begin
                  area := 3;
                  Inc(Placehold[3], Placehold[4]);
                  Placehold[4] := 0;
                  End;
              End;
              Inc(Placehold[area]);
              Inc(Fmt);
              End;

            '#':
              Begin
              If area=3 Then
                area:=4;
              Inc(Placehold[area]);
              Inc(Fmt);
              End;
            '.':
              Begin
              If area<3 Then
                area:=3;
              Inc(Fmt);
              End;
            ',':
              Begin
              thousand := True;
              Inc(Fmt);
              End;
            'e', 'E':
              If ExpFmt = 0 Then
                Begin
                If (Fmt[0]='E') Then
                  ExpFmt:=1
                Else
                  ExpFmt := 3;
                Inc(Fmt);
                If (Fmt<FmtStop) Then
                  Begin
                  Case Fmt[0] Of
                    '+':
                      Begin
                      End;
                    '-':
                      Inc(ExpFmt);
                  Else
                    ExpFmt := 0;
                  End;
                  If ExpFmt <> 0 Then
                    Begin
                    Inc(Fmt);
                    ExpSize := 0;
                    While (Fmt<FmtStop) And
                          (ExpSize<4) And
                          (fmt^ >= '0') and (fmt^ <= '9') do
//                          (Fmt[0] In ['0'..'9']) Do
                      Begin
                      Inc(ExpSize);
                      Inc(Fmt);
                      End;
                    End;
                  End;
                End
              Else
                Inc(Fmt);
          Else { Case }
            Inc(Fmt);
          End; { Case }
          End { Begin }
        Else 
          Begin
          Inc(Fmt)
          End;
      End; { Case }
      End; { While .. Begin }
  End;

  Procedure FloatToStr;

  Var
    I, J, Exp, Width, Decimals, DecimalPoint, len: Integer;

  Begin
    If ExpFmt = 0 Then
      Begin
      { Fixpoint }
      Decimals:=Placehold[3]+Placehold[4];
      Width:=Placehold[1]+Placehold[2]+Decimals;
      If (Decimals=0) Then
        Str(Value:Width:0,Digits)
      Else
        Str(Value:Width+1:Decimals,Digits);
      len:=Length(Digits);
      { Find the decimal point }
      If (Decimals=0) Then
        DecimalPoint:=len+1
      Else
        DecimalPoint:=len-Decimals;
      { If value is very small, and no decimal places
        are desired, remove the leading 0.            }
      If (Abs(Value) < 1) And (Placehold[2] = 0) Then
        Begin
        If (Placehold[1]=0) Then
          Delete(Digits,DecimalPoint-1,1)
        Else
          Digits[DecimalPoint-1]:=' ';
        End;

      { Convert optional zeroes to spaces. }
      I:=len;
      J:=DecimalPoint+Placehold[3];
      While (I>J) And (Digits[I]='0') Do
        Begin
        Digits[I] := ' ';
        Dec(I);
        End;
      { If integer value and no obligatory decimal
        places, remove decimal point. }
      If (DecimalPoint < len) And (Digits[DecimalPoint + 1] = ' ') Then
          Digits[DecimalPoint] := ' ';
      { Convert spaces left from obligatory decimal point to zeroes. }
      I:=DecimalPoint-Placehold[2];
      While (I<DecimalPoint) And (Digits[I]=' ') Do
        Begin
        Digits[I] := '0';
        Inc(I);
        End;
      Exp := 0;
      End
    Else
      Begin
      { Scientific: exactly <Width> Digits With <Precision> Decimals
        And adjusted Exponent. }
      If Placehold[1]+Placehold[2]=0 Then
        Placehold[1]:=1;
      Decimals := Placehold[3] + Placehold[4];
      Width:=Placehold[1]+Placehold[2]+Decimals;
      Str(Value:Width+8,Digits);
      { Find and cut out exponent. Always the
        last 6 characters in the string.
        -> 0000E+0000                         }
      I:=Length(Digits)-5;
      Val(Copy(Digits,I+1,5),Exp,J);
      Exp:=Exp+1-(Placehold[1]+Placehold[2]);
      Delete(Digits, I, 6);
      { Str() always returns at least one digit after the decimal point.
        If we don't want it, we have to remove it. }
      If (Decimals=0) And (Placehold[1]+Placehold[2]<= 1) Then
        Begin
        If (Digits[4]>='5') Then
          Begin
          Inc(Digits[2]);
          If (Digits[2]>'9') Then
            Begin
            Digits[2] := '1';
            Inc(Exp);
            End;
          End;
        Delete(Digits, 3, 2);
        DecimalPoint := Length(Digits) + 1;
        End
      Else
        Begin
        { Move decimal point at the desired position }
        Delete(Digits, 3, 1);
        DecimalPoint:=2+Placehold[1]+Placehold[2];
        If (Decimals<>0) Then
          Insert('.',Digits,DecimalPoint);
        End;

      { Convert optional zeroes to spaces. }
      I := Length(Digits);
      J := DecimalPoint + Placehold[3];
      While (I > J) And (Digits[I] = '0') Do
        Begin
        Digits[I] := ' ';
        Dec(I);
        End;

      { If integer number and no obligatory decimal paces, remove decimal point }

      If (DecimalPoint<Length(Digits)) And
         (Digits[DecimalPoint+1]=' ') Then
          Digits[DecimalPoint]:=' ';
      If (Digits[1]=' ') Then
        Begin
        Delete(Digits, 1, 1);
        Dec(DecimalPoint);
        End;
      { Calculate exponent string }
      Str(Abs(Exp), Exponent);
      While Length(Exponent)<ExpSize Do
        Insert('0',Exponent,1);
      If Exp >= 0 Then
        Begin
        If (ExpFmt In [1,3]) Then
          Insert('+', Exponent, 1);
        End
      Else
        Insert('-',Exponent,1);
      If (ExpFmt<3) Then
        Insert('E',Exponent,1)
      Else
        Insert('e',Exponent,1);
      End;
    DigitExponent:=DecimalPoint-2;
    If (Digits[1]='-') Then
      Dec(DigitExponent);
    UnexpectedDigits:=DecimalPoint-1-(Placehold[1]+Placehold[2]);
  End;

  Function PutResult: LongInt;

  Var
    SQ, DQ: Boolean;
    Fmt, Buf: PmseChar;
    Dig, N: Integer;

  Begin
   with formatsettings do begin
    SQ := False;
    DQ := False;
    Fmt := FmtStart;
    Buf := Buffer;
    Dig := 1;
    While (Fmt<FmtStop) Do
      Begin
      //Write(Fmt[0]);
      Case Fmt[0] Of
        #34:
          Begin
          If Not SQ Then
            DQ := Not DQ;
          Inc(Fmt);
          End;
        #39:
          Begin
          If Not DQ Then
            SQ := Not SQ;
          Inc(Fmt);
          End;
      Else
        If Not (SQ Or DQ) Then
          Begin
          Case Fmt[0] Of
            '0', '#', '.':
              Begin
              If (Dig=1) And (UnexpectedDigits>0) Then
                Begin
                { Everything unexpected is written before the first digit }
                For N := 1 To UnexpectedDigits Do
                  Begin
                  Buf[0] := widechar(Digits[N]);
                  Inc(Buf);
                  If thousand And (Digits[N]<>'-') Then
                    Begin
                    If (DigitExponent Mod 3 = 0) And (DigitExponent>0) Then
                      Begin
//                      Buf[0] := widechar(ThousandSeparator);
                      Buf[0] := ThousandSeparator;
                      Inc(Buf);
                      End;
                    Dec(DigitExponent);
                    End;
                  End;
                Inc(Dig, UnexpectedDigits);
                End;
              If (Digits[Dig]<>' ') Then
                Begin
                If (Digits[Dig]='.') Then
                  Buf[0] := DecimalSeparator
//                  Buf[0] := widechar(DecimalSeparator)
                Else
                  Buf[0] := widechar(Digits[Dig]);
                Inc(Buf);
                If thousand And (DigitExponent Mod 3 = 0) And (DigitExponent > 0) Then
                  Begin
//                  Buf[0] := widechar(ThousandSeparator);
                  Buf[0] := ThousandSeparator;
                  Inc(Buf);
                  End;
                End;
              Inc(Dig);
              Dec(DigitExponent);
              Inc(Fmt);
              End;
            'e', 'E':
              Begin
              If ExpFmt <> 0 Then
                Begin
                Inc(Fmt);
                If Fmt < FmtStop Then
                  Begin
//                  If Fmt[0] In ['+', '-'] Then
                  If (Fmt[0] = '+') or (fmt[0] = '-') Then
                    Begin
                    Inc(Fmt, ExpSize);
                    For N:=1 To Length(Exponent) Do
                      Buf[N-1] := widechar(Exponent[N]);
                    Inc(Buf,Length(Exponent));
                    ExpFmt:=0;
                    End;
                  Inc(Fmt);
                  End;
                End
              Else
                Begin
                { No legal exponential format.
                  Simply write the 'E' to the result. }
                Buf[0] := Fmt[0];
                Inc(Buf);
                Inc(Fmt);
                End;
              End;
          Else { Case }
            { Usual character }
            If (Fmt[0]<>',') Then
              Begin
              Buf[0] := Fmt[0];
              Inc(Buf);
              End;
            Inc(Fmt);
          End; { Case }
          End
        Else { IF }
          Begin
          { Character inside single or double quotes }
          Buf[0] := Fmt[0];
          Inc(Buf);
          Inc(Fmt);
          End;
      End; { Case }
    End; { While .. Begin }
//    Result:=PtrInt(Buf)-PtrInt(Buffer);
    result:= buf - buffer;
   end;
  End;

var
 int1: integer;
begin
 if value > 0 then begin
  getsectionrange(1);
 end
 else begin
  if (value < 0) then begin
   getsectionrange(2)
  end
  else begin
   getsectionrange(3);
  end;
 end;
 if fmtstart = nil then begin
 {$ifdef FPC}
  result:= floattotext(pchar(buffer),value,ffgeneral,15,4);
 {$else}
  result:= floattotext(pchar(buffer),value,fvextended,ffgeneral,15,4);
 {$endif}
 end
 else begin
  getformatoptions;
  if (expfmt = 0) and (abs(value) >= 1e18) then begin
 {$ifdef FPC}
   result:= floattotext(pchar(buffer),value,ffgeneral,15,4);
 {$else}
   result:= floattotext(pchar(buffer),value,fvextended,ffgeneral,15,4);
 {$endif}
  end
  else begin
   floattostr;
   result:= putresult;
   exit;
  end;
 end;
 for int1:= result - 1 downto 0 do begin
  pmsecharaty(buffer)^[int1]:= widechar(pcharaty(buffer)^[int1]);
             //convert to msestring
 end;
end;
*)

function cstringtostringvar(var inp: pchar): string;

const
 quotechar = '"';
 escapechar = '\';

var
 po1,po2: pchar;
 int1,int2: integer;
 ch1: char;

begin
 result:= '';
 if inp <> nil then begin
  po1:= inp;
  while true do begin
   while (po1^ = ' ') do begin //first quote
    inc(po1);
   end;
   if (po1^ <> quotechar) then begin
    break;  //end or no start quote
   end;
   inc(po1);
   po2:= po1;  //text
   while true do begin
    while (po1^ <> quotechar) and (po1^ <> escapechar) do begin
     if (po1^ = #0) then begin
      result:= '';
      inp:= nil;
      exit; //error: no end quote
     end;
     inc(po1);
    end;
    int1:= po1-po2; //text length
    int2:= length(result)+1;
    setlength(result,length(result) + int1);
    move(po2^,result[int2],int1); //add text
    if po1^ = escapechar then begin
     inc(po1);
     case po1^ of
      'a': ch1:= #$07;
      'b': ch1:= #$08;
      'f': ch1:= #$0c;
      'n': ch1:= #$0a;
      'r': ch1:= #$0d;
      't': ch1:= #$09;
      'v': ch1:= #$0b;
      '\': ch1:= '\';
      '''': ch1:= '''';
      '"': ch1:= '"';
      '?': ch1:= '?';
      '0'..'7': begin
       po2:= po1;
       for int1:= 0 to 2 do begin
        if (po1^ < '0') or (po1^ > '7') then begin
         break;
        end;
        inc(po1);
       end;
       ch1:= char(strtooct(psubstr(po2,po1)));
       dec(po1);
      end;
      'x','X': begin
       inc(po1);
       po2:= po1;
       while (po1^ >= '0') and (po1^ <= '9') or
             (po1^ >= 'a') and (po1^ <= 'f') or
             (po1^ >= 'A') and (po1^ <= 'F') do begin
        inc(po1);
       end;
       ch1:= char(strtohex(psubstr(po2,po1)));
       dec(po1);
      end;
      else begin
       ch1:= ' ';
      end;
     end;
     result:= result + ch1;
     inc(po1);
    end
    else begin
     inc(po1);
     break;
    end;
    po2:= po1; //past quote
   end;
  end;
  inp:= po1;
 end;
end;

function cstringtostring(inp: pchar): string;
begin
 result:= cstringtostringvar(inp);
end;

function cstringtostring(const inp: string): string;
var
 po1: pchar;
begin
 po1:= pchar(inp);
 result:= cstringtostringvar(po1);
end;

function stringtocstring(const inp: msestring): string;
var
 po1: pmsechar;
 innum: boolean;
begin
 result:= '"';
 po1:= pmsechar(inp);
 innum:= false;
 while po1^ <> #0 do begin
  if (po1^ < #$20) or (po1^ > #$ff) or (po1^ = #$7f) then begin
   innum:= true;
   if po1^ < #$100 then begin
    result:= result + '\x'+hextostr(ord(po1^),2);
   end
   else begin
    result:= result + '\x'+hextostr(ord(po1^),4);
   end;
  end
  else begin
   if po1^ = '"' then begin
    result:= result + '\"';
    innum:= false;
   end
   else begin
    if innum then begin
     result:= result + '" "'+po1^;
     innum:= false;
    end
    else begin
     result:= result + po1^;
    end;
   end;
  end;
  inc(po1);
 end;
 result:= result + '"';
end;

function stringtopascalstring(const value: msestring): string;
var
 int1,int2: integer;
 po1: pchar;
 str1: string;
 asciimode: boolean;
begin
 if length(value) = 0 then begin
  result:= '''''';
 end
 else begin
  asciimode:= false;
  setlength(result,2+6*length(value)); // maxlength for single char: '#65535' = 2 + 6
  po1:= pchar(pointer(result));
//  int2:= 1;
  for int1:= 1 to length(value) do begin
   int2:= ord(value[int1]);
   if (int2 >= 32) and (int2 < 127) then begin
    if not asciimode then begin
     asciimode:= true;
     po1^:= '''';
     inc(po1);
    end;
    if char(int2) = '''' then begin
     po1^:= ''''; //double quote
     inc(po1);
    end;
    po1^:= char(int2);
    inc(po1);
   end
   else begin
    if asciimode then begin
     asciimode:= false;
     po1^:= '''';
     inc(po1);
    end;
    po1^:= '#';
    inc(po1);
    str1:= inttostr(int2);
    move(pchar(pointer(str1))^,po1^,length(str1));
    inc(po1,length(str1));
   end;
  end;
  if asciimode then begin
   po1^:= '''';
   inc(po1);
  end;
  setlength(result,po1-pchar(pointer(result)));
 end;
end;

function pascalstringtostring(const value: string): msestring;

 procedure doerror;
 begin
  raise exception.Create('Invalid pascalstring: "'+value+'".');
 end;

var
 po1: pmsechar;
 po2,po3: pchar;
 int1: integer;
 str1: string;
begin
 setlength(result,length(value)); //max length
 po1:= pmsechar(pointer(result));
 po2:= pchar(value);
 while po2^ <> #0 do begin
  case po2^ of
   '#': begin
    inc(po2);
    po3:= po2;
    while (po2^ >= '0') and (po2^ <= '9') do begin
     inc(po2);
    end;
    setstring(str1,po3,po2-po3);
    po1^:= msechar(strtoint(str1));
    inc(po1);
   end;
   '''': begin               
    inc(po2);                  //'.....
    po3:= po2;
    while (po2^ <> '''') and (po2^ <> #0) do begin
     inc(po2)
    end;
    if po2^ <> #0 then begin   
     for int1:= 0 to po2 - po3 - 1 do begin //'abcd'......
      po1^:= msechar((po3+int1)^);
      inc(po1);
     end;
     inc(po2);
     if po2^ = '''' then begin //'abcd'?
      po1^:= '''';             //'abcd''
      inc(po1);                
     end;
    end
    else begin
     doerror;
    end;
   end;
   ' ',c_tab: begin
    inc(po2)
   end
   else begin
    doerror;
   end;
  end;
 end;
 setlength(result,po1-pmsechar(pointer(result)));
end;

function stringtotime(const avalue: msestring): tdatetime;
begin
 if avalue = ' ' then begin
  result:= frac(now);
 end
 else begin
  if avalue = '' then begin
   result:= emptydatetime;
  end
  else begin
   result:= sysutils.strtotime(avalue);
  end;
 end;
end;

function timetostring(const avalue: tdatetime; const format: msestring = 't'): msestring;
begin
 if isemptydatetime(avalue) then begin
  result:= '';
 end
 else begin
  if format = '' then begin
   result:= formatdatetimemse('t',avalue,defaultformatsettingsmse);
  end
  else begin
   result:= formatdatetimemse(format,avalue,defaultformatsettingsmse);
  end;
 end;
end;

function datetimetostring(const avalue: tdatetime; const format: msestring = 'c'): msestring;
begin
 if isemptydatetime(avalue) then begin
  result:= '';
 end
 else begin
  if format = '' then begin
   result:= formatdatetimemse('c',avalue,defaultformatsettingsmse);
  end
  else begin
   result:= formatdatetimemse(format,avalue,defaultformatsettingsmse);
  end;
 end;
end;

function datetostring(const avalue: tdatetime; const format: msestring = 'c'): msestring;
begin
 if isemptydatetime(avalue) then begin
  result:= '';
 end
 else begin
  result:= datetimetostring(trunc(avalue),format);
 end;
end;

function stringtodatetime(const avalue: msestring): tdatetime;
begin
 if avalue = ' ' then begin
  result:= now;
 end
 else begin
  if avalue = '' then begin
   result:= emptydatetime;
  end
  else begin
   result:= strtodatetime(avalue);
  end;
 end;
end;

function timemse(const value: tdatetime): tdatetime;
  //bringt timeanteil im mseformat
begin
 result:= frac(value);
// if result = 0 then begin
//  result:= nulltime;
// end;
end;

function bcdtoint(inp: byte): integer;
begin
 result:= ((inp and $f0) shr 4) * 10 + (inp and $0f);
end;

function inttobcd(inp: integer): byte;
begin
 result:= byte(((inp div 10) shl 4) + (inp mod 10))
end;

function formatfloatmse(const value: double; const format: msestring;
                              const formatsettings: tformatsettingsmse;
                              const dot: boolean = false): msestring;

var
 po1,po2: pmsechar;
 expsign,noexpsign: boolean;

 procedure quote;
 begin
  case po2^ of
   '''': begin                    //'quoted string
    inc(po2);
    while po2^ <> #0 do begin
     if po2^ = '''' then begin
      inc(po2);
      if po2^ <> '''' then begin
       break;
      end;
     end;
     po1^:= po2^;
     inc(po1);
     inc(po2);
    end; 
   end;
   '"': begin                    //"quoted string
    inc(po2);
    while po2^ <> #0 do begin
     if po2^ = '"' then begin
      inc(po2);
      if po2^ <> '"' then begin
       break;
      end;
     end;
     po1^:= po2^;
     inc(po1);
     inc(po2);
    end; 
   end;
  end;
 end;
 
 procedure checkexp;
 begin
  if (po2+1)^ = '+' then begin
   expsign:= true;
   inc(po2);
  end
  else begin
   if (po2+1)^ = '-' then begin
    noexpsign:= true;
    inc(po2);
   end;
  end;
 end;
   
var
 int1,int2,int3: integer;
 decimalsep,thousandsep: msechar;
 mch1: msechar;
 intopt,intmust,fracmust,fracopt,expopt,expmust: integer;
 decifound,thousandfound,numberprinted,expofound,engfound,engsymfound: boolean;
 mstr1: msestring;
 format1: msestring;
 mantissaend: integer;
 ar1: array[0..2] of integer;    //indexes positive, negative, zero
 expchar: msechar;
 
begin
 with formatsettings do begin
  if dot then begin
   decimalsep:= '.';
  end
  else begin
   decimalsep:= decimalseparator;
  end;
  if format = 'c' then begin
   if value < 0 then begin
    case negcurrformat of
     0: begin
      result:= '('+currencystring;
     end;
     1: begin
      result:= '-'+currencystring;
     end;
     2: begin
      result:= currencystring+'-';
     end;
     3: begin
      result:= currencystring;
     end;
     4,15: begin
      result:= '(';
     end;
     5,8: begin
      result:= '-';
     end;
     9: begin
      result:= '-'+currencystring+' ';
     end;
     11: begin
      result:= currencystring+' ';
     end;
     12: begin
      result:= currencystring+' -';
     end;
     14: begin
      result:= '('+currencystring+' ';
     end;
    end;
   end
   else begin
    case currencyformat of
     0: begin
      result:= currencystring;
     end;
     2: begin
      result:= currencystring + ' ';
     end;
    end;
   end;
   result:= result+doubletostring(abs(value),currencydecimals,
                                fsm_fix,decimalsep,thousandseparator);
   if value < 0 then begin
    case negcurrformat of
     0,14: begin
      result:= result + ')';
     end;
     3,11: begin
      result:= result + '-';
     end;
     4: begin
      result:= result + currencystring + ')';
     end;
     5: begin
      result:= result + currencystring;
     end;
     6: begin
      result:= result + '-' + currencystring;
     end;
     7: begin
      result:= result + currencystring + '-';
     end;
     8: begin
      result:= result + ' ' + currencystring;
     end;
     10: begin
      result:= result + ' ' + currencystring + '-';
     end;
     13: begin
      result:= result + '- ' + currencystring;
     end;
     15: begin
      result:= result + ' ' + currencystring + ')'
     end;
    end;
   end
   else begin
    case currencyformat of
     1: begin
      result:= result + formatsettings.currencystring;
     end;
     3: begin
      result:= result + ' ' + formatsettings.currencystring;
     end;
    end;
   end;
   exit;
  end;
 end;
 expchar:= 'E';
 setlength(result,length(format)+50); //max
 numberprinted:= false;
 po1:= pmsechar(result);
 po2:= pmsechar(format);
 int1:= 0;                            //arrayindex
 while po2^ <> #0 do begin
  quote;
  if po2^ = ';' then begin
   ar1[int1]:= po2 - pmsechar(pointer(format));
   inc(int1);
   if int1 = 3 then begin
    break;
   end;
  end;
  inc(po2);
 end;
 if int1 < 3 then begin
  ar1[int1]:= length(format);
 end;  
 if (value = 0) and (int1 >= 2) then begin
  setlength(format1,ar1[2]-ar1[1]-1);
  move((pmsechar(pointer(format))+ar1[1]+1)^,pmsechar(pointer(format1))^,
                             (ar1[2]-ar1[1]-1)*sizeof(msechar));
  po2:= pmsechar(format1);
 end
 else begin
  if (value < 0) and (int1 >= 1) then begin
   setlength(format1,ar1[1]-ar1[0]-1);
   move((pmsechar(pointer(format))+ar1[0]+1)^,pmsechar(pointer(format1))^,
                              (ar1[1]-ar1[0]-1)*sizeof(msechar));
   po2:= pmsechar(format1);     
  end
  else begin
   setlength(format1,ar1[0]);
   move((pmsechar(pointer(format)))^,pmsechar(pointer(format1))^,
                              (ar1[0])*sizeof(msechar));
   po2:= pmsechar(format1);     
  end;
 end;
 if format1 = '' then begin
  result:= doubletostring(value,0,fsm_default,decimalsep);
 end
 else begin 
  po1:= pmsechar(result);
  while po2^ <> #0 do begin
   quote;
   case po2^ of
    #0: begin    //was terminating quote
    end;
    ',','.','0','#': begin
     intopt:= 0;
     intmust:= 0;
     fracopt:= 0;
     fracmust:= 0;
     expopt:= 0;
     expmust:= 0;
     decifound:= false;
     thousandfound:= false;
     expofound:= false;
     engfound:= false;
     engsymfound:= false;
     expsign:= false;
     noexpsign:= false;
     while po2^ <> #0 do begin
      case po2^ of
       '.': begin
        decifound:= true;
       end;
       ',': begin
        thousandfound:= true;
       end;
       'e','E': begin
        expofound:= true;
        expchar:= po2^;
        checkexp;
       end;
       'f','F': begin
        engfound:= true;
        expchar:= msechar(ord(po2^)-1);
        checkexp;
       end;
       'g','G': begin
        engsymfound:= true;
        engfound:= true;
        expchar:= msechar(ord(po2^)-2);
        checkexp;
       end;
       '0': begin
        if expofound or engfound then begin
         inc(expmust);
        end
        else begin
         if decifound then begin
          inc(fracmust);
         end
         else begin
          inc(intmust);
         end;
        end;
       end;
       '#': begin
        if expofound or engfound then begin
         inc(expopt);
        end
        else begin
         if decifound then begin
          inc(fracopt);
         end
         else begin
          inc(intopt);
         end;
        end;
       end
       else begin
        break;
       end;
      end;
      inc(po2);
     end;
     if not numberprinted then begin
      numberprinted:= true;
      if thousandfound then begin
       thousandsep:= formatsettings.thousandseparator;
      end
      else begin
       thousandsep:= #0;
      end;
      if expofound then begin
       mstr1:= doubletostring(value,fracmust+fracopt,fsm_sci,decimalsep,
                                                                thousandsep);
      end
      else begin
       if engfound then begin
        if engsymfound then begin
         int1:= ord(fsm_engsymfix) - ord(fsm_engfix);
        end
        else begin
         int1:= 0;
        end;
        if fracmust = 0 then begin
         fracmust:= fracopt;
         fracopt:= 0;
         mstr1:= doubletostring(value,fracmust,
            floatstringmodety(ord(fsm_engflo)+int1),decimalsep,thousandsep);
        end
        else begin
         mstr1:= doubletostring(value,fracmust+fracopt,
            floatstringmodety(ord(fsm_engfix)+int1),decimalsep,thousandsep);
        end;
       end
       else begin
        if intopt+intmust+fracmust+fracopt = 0 then begin
         mstr1:= doubletostring(value,0,fsm_default,decimalsep,thousandsep);
        end
        else begin
         mstr1:= doubletostring(value,fracmust+fracopt,fsm_fix,
                                                        decimalsep,thousandsep);
        end;
       end;       
      end;
      if expofound or engfound then begin     //format exponent
       if (length(mstr1) > 5) and (mstr1[length(mstr1)-4] = expochar) then begin
        if {noexpsign or} not expsign then begin   
         int1:= length(mstr1)-3;
         if mstr1[int1] = '+' then begin
          delete(mstr1,int1,1);                //remove exp sign
         end;
        end;
        expmust:= expmust+expopt;
        if expmust = 0 then begin
         expmust:= 1;
        end;
        int2:= length(mstr1)-expmust+1; //last zero
        int3:= length(mstr1)-2;         //firstzero
        for int1:= int3 to int2 do begin
         if mstr1[int1] <> '0' then begin
          int2:= int1;
          break;
         end;
        end;
        delete(mstr1,int3,int2-int3); //remove leading zeros      end;      
       end;
      end;
      
      int1:= findlastchar(mstr1,decimalsep)-1;  //format mantissa
      if int1 <= 0 then begin
       int1:= length(mstr1);
      end;
      int2:= 1;
      if mstr1[1] = '-' then begin
       inc(int2);                   //firstnumber
      end;
      if (intmust = 0) and (mstr1[int2] = '0') then begin
       delete(mstr1,int2,1);     //remove first 0
       dec(int1);
      end;
      int3:= intmust - int1 + int2 - 1;
      if int3 > 0 then begin
       insert(copy(msenullen,1,int3),mstr1,int2); //insert zeros
       inc(int1,int3);
      end;
      int3:= intmust + intopt - int1 + int2 - 1;
      if int3 > 0 then begin
       insert(copy(msespace,1,int3),mstr1,1);  //insert spaces
       inc(int1,int3);
      end;
      int2:= int1 + fracmust+1;
      mantissaend:= findchar(mstr1,expochar);     //ok for exa
      if (mantissaend > 0) and (mantissaend < length(mstr1)) then begin
                                             //not exa
       mstr1[mantissaend]:= expchar;
      end
      else begin
       if (mantissaend = 0) and engsymfound then begin
        mantissaend:= length(mstr1);
       end;
      end;
      dec(mantissaend);
      if mantissaend <= 0 then begin
       mantissaend:= length(mstr1);
      end;
      for int3:= mantissaend downto int2 do begin
       if (mstr1[int3] <> '0') then begin      //remove traling zeros   
        int2:= int3;
        break;
       end;
      end;
      if int2 < length(mstr1) then begin
       if mstr1[int2] = decimalsep then begin
        dec(int2);
       end;
       delete(mstr1,int2+1,mantissaend-int2);
      end;
      move(pointer(mstr1)^,po1^,length(mstr1)*sizeof(msechar));
      inc(po1,length(mstr1));
     end;
    end
    else begin
     po1^:= po2^;
     inc(po1);
     inc(po2);
    end;
   end;
  end;
  setlength(result,po1-pmsechar(result));
 end;
end;

function formatfloatmse(const value: double; const format: msestring; 
                         const dot: boolean = false): msestring; overload;
begin
 result:= formatfloatmse(value,format,defaultformatsettingsmse,dot);
end;

{
function formatfloatmse(const value: double; const format: msestring;
                                 const dot: boolean = false): msestring;
var
 int1: integer;
begin
 setlength(result,length(format)+200); //max
 int1:= floattotextfmt(pmsechar(result),value,pmsechar(format),
                                 defaultformatsettingsmse);
 setlength(result,int1);
 if dot then begin
//  replacechar1(result,widechar(decimalseparator),widechar('.'));
  replacechar1(result,defaultformatsettingsmse.decimalseparator,widechar('.'));
 end;
end;
}
function realToStr(const value: double): string;     //immer'.' als separator
begin
 {$ifdef withformatsettings}
 result:= floattostr(value,defaultformatsettings)
 {$else}
 result:= replacechar(floattostr(value),decimalseparator,'.');
 {$endif}
end;

function StrToreal(const S: string): double;   //immer'.' als separator
begin
 {$ifdef withformatsettings}
 result:= strtofloat(s,defaultformatsettings);
 {$else}
 result:= strtofloat(replacechar(s,'.',decimalseparator));
 {$endif}
end;

function bcdtostr(inp: byte): string;
 //wandelt bcdwert in zwei ascii zeichen
begin
 result:= char(byte(inp shr byte(4)) + ord('0'))+
          char(byte(inp and $0f) + ord('0'));
end;

function bytetobcd(inp: byte): word;
 //wandelt byte in bcdwert
begin
 result:= (inp div 100 shl 8) or ((inp div 10) mod 10 shl 4) or (inp mod 10)
end;

function bcdtobyte(inp: byte): byte;
 //wandelt bcdbyte in byte
begin
 result:= (inp shr 4)*10 + inp and $0f;
end;

function bytetohex(const inp: byte): string;
 //wandelt byte in zwei ascii hexzeichen
var
 ch1,ch2: char;
begin
 ch1:= char((inp shr 4) + byte('0'));
 if ch1 > '9' then begin
  ch1:= char(byte(ch1) + byte('A')-byte('0')-10);
 end;
 ch2:= char((inp and $0f) + byte('0'));
 if ch2 > '9' then begin
  ch2:= char(byte(ch2) + byte('A')-byte('0')-10);
 end;
 result:= ch1 + ch2;
end;

function wordtohex(const inp: word; lsbfirst: boolean = false): string;
 //wandelt word in vier ascii hexzeichen
begin
 if lsbfirst then begin
  result:= bytetohex(inp) + bytetohex(inp shr 8);
 end
 else begin
  result:=  bytetohex(inp shr 8) + bytetohex(inp);
 end;
end;

function bytestrtostr(const inp: ansistring; base: numbasety; abstand: boolean): string;
   //wandelt bytefolge in ascii hexstring
var
 int1: integer;
begin
 result:= '';
 for int1:= 1 to length(inp) do begin
  result:= result + intvaluetostr(byte(inp[int1]),base,8);
  if abstand and (int1 <> length(inp)) then begin
    result:= result + ' ';
  end;
 end;
end;

function strtobytestr(inp: string): ansistring;
 //wandelt hex asciistring in bytefolge
var
 int1,int2, int3: integer;
 str1: string;
begin
 result:= '';
 removechar(inp,' ');
 int2:= length(inp);
 if int2 > 0 then begin
  setlength(result,(int2+1) div 2);
  setlength(str1,2);
  int1:= 1;
  int3:= 1;
  while int1 <= int2 do begin
   str1[1]:= inp[int1];
   inc(int1);
   if int1 > int2 then begin
    setlength(str1,1);
   end
   else begin
    str1[2]:= inp[int1];
   end;
   result[int3]:= char(strtoint('$'+str1));
   inc(int1);
   inc(int3);
  end;
 end;
end;

function strtobytes(const inp: string; out dest: bytearty): boolean;
var
 po1,po2: pchar;
 int1: integer;
 by1: shortint;
begin
 result:= false;
 int1:= length(inp)+1;
 setlength(dest,int1 div 2);
 po1:= @inp[int1];
 po2:= pchar(inp);
 int1:= high(dest);
 while po1 > po2 do begin
  dec(po1);
  by1:= hexchars[po1^];
  if by1 < 0 then begin
   exit;
  end;
  dest[int1]:= by1;

  if po1 = po2 then begin
   break;
  end;
  dec(po1);
  by1:= hexchars[po1^];
  if by1 < 0 then begin
   exit;
  end;
  dest[int1]:= dest[int1] or (by1 shl 4);
  dec(int1);
 end;
 result:= true;
end;

function bytestrtobin(const inp: ansistring; abstand: boolean): string;
   //wandelt bytefolge in ascii binstring,
   // letztes zeichen = anzahl gueltige bits in letztem byte
var
 int1,int2,int3,int4: integer;
// str1: string;
 by1,by2: byte;

begin
 result:= '';
 int2:= bitcount(inp)-1;
 int3:= 1;
 int4:= 0;
 while int2 >= 0 do begin
  by1:= byte(inp[int3]);
  by2:= $01;
  for int1:= 0 to 7 do begin
   if by1 and by2 <> 0 then begin
    result:= result + '1';
   end
   else begin
    result:= result + '0';
   end;
   if int4+int1 >= int2 then begin
    break;
   end;
   by2:= by2 shl 1;
  end;
  if int4+(int1 and $07) >= int2 then begin
   break;
  end;
  if abstand then begin
   result:= result + ' ';
  end;
  inc(int3);
  inc(int4,8);
 end;
end;

function strtobinstr(inp: string): ansistring;
 //wandelt bin asciistring in bytefolge,
 // letztes byte = anzahl gueltige bits in vorletztem byte
var
 int1,int2,int3: integer;
 by1,by2: byte;
 ch1: char;
begin
 result:= '';
 removechar(inp,' ');
 int1:= length(inp);
 int3:= 1;
 int2:= 0;
 while int3 <= int1 do begin
  by1:= 1;
  by2:= 0;
  for int2:= 0 to 7 do begin
   if int3 + int2 > int1 then begin
    break;
   end;
   ch1:= inp[int3+int2];
   if ch1 = '1' then begin
    by2:= by2 or by1;
   end
   else begin
    if ch1 <> '0' then begin
     raise EConvertError.CreateFmt(SInvalidInteger,[inp]);
    end;
   end;
   by1:= by1 shl 1;
  end;
  int3:= int3 + 8;
  result:= result + char(by2);
 end;
 if length(result) > 0 then begin
  result:= result + char(int2);
 end;
end;

function bitmaske(const data: ansistring): integer;
begin
 if length(data) > 1 then begin
  result:= byte(data[length(data)]);
  if result > 8 then begin
   result:= 8
  end;
 end
 else begin
  result:= 0;
 end;
end;

function bitcount(const data: ansistring): integer; //anzahl gueltige bits
var
 int1: integer;
begin
 int1:= length(data);
 if int1 > 1 then begin
  result:= 8*(int1-2) + bitmaske(data);
 end
 else begin
  result:= 0;
 end;
end;

function bintostr(inp: longword; digits: integer): string;
   //convert longword to binstring, digits = bit count
var
 int1: integer;
begin
 setlength(result,digits);
 for int1:= digits downto 1  do begin
  result[int1]:= char(ord('0') + (inp and $1));
  inp:= inp shr 1;
 end;
end;

function octtostr(inp: longword; digits: integer): string;
   //convert longword to octaltring, digits = octet count
var
 int1: integer;
begin
 setlength(result,digits);
 for int1:= digits downto 1  do begin
  result[int1]:= char(ord('0') + (inp and $7));
  inp:= inp shr 3;
 end;
end;

function dectostr(const inp: integer; digits: integer): string;
          //leading zeroes if digits < 0
begin
 result:= inttostr(abs(inp));
 if digits < 0 then begin
  digits:= -digits;
  if digits > length(nullen) then begin
   digits:= length(nullen);
  end;
  result:= copy(nullen,1,digits-length(result)) + result;
 end;
 result:= copy(result,length(result)-digits+1,bigint);
 if inp < 0 then begin
  result:= '-' + result;
 end;
end;

function hextostr(inp: longword; digits: integer): string;
   //wandelt longword in hexstring, stellen = anzahl nibbles
var
 int1: integer;
begin
 setlength(result,digits);
 for int1:= digits downto 1  do begin
  result[int1]:= char(ord('0') + (inp and $f));
  if result[int1] > '9' then begin
   inc(result[int1],ord('A')-ord('9')-1);
  end;
  inp:= inp shr 4;
 end;
end;

function hextocstr(const inp: longword; stellen: integer): string;
begin
 result:= '0x' + hextostr(inp, stellen);
end;

function ptruinttocstr(inp: ptruint): string;
   //convert ptrint to 0x...
var
 int1: integer;
begin
 result:= '0x';
 setlength(result,2+sizeof(ptrint)*2);
 for int1:= length(result) downto 3  do begin
  result[int1]:= char(ord('0') + (inp and $f));
  if result[int1] > '9' then begin
   inc(result[int1],ord('A')-ord('9')-1);
  end;
  inp:= inp shr 4;
 end;
end;

procedure formaterror(const value: string);
begin
 raise exception.Create('Invalid number '''+value+'''.');
end;

function trystrtointvalue(const text: msestring; base: numbasety;
                     out value: longword): boolean;
var
 str1: string;
begin
 str1:= trim(text);
 case base of
  nb_bin: begin
   result:= trystrtobin(str1,value);
  end;
  nb_oct: begin
   result:= trystrtooct(str1,value);
  end;
  nb_hex: begin
   result:= trystrtohex(str1,value);
  end
  else begin //nb_dec
   result:= trystrtodec(str1,value);
  end;
 end;
end;

function strtointvalue(const text: msestring; base: numbasety): longword;
begin
 if not trystrtointvalue(text,base,result) then begin
  formaterror(text);
 end;
end;

function intvaluetostr(const value: integer; const base: numbasety = nb_dec;
                          const bitcount: integer = 32): string;
begin
 case base of
  nb_bin: begin
   result:= bintostr(value,abs(bitcount));
  end;
  nb_oct: begin
   result:= octtostr(value,(abs(bitcount)+2) div 3);
  end;
  nb_hex: begin
   result:= hextostr(value,(abs(bitcount)+3) div 4);
  end;
  else begin //nb_dec
   result:= dectostr(value,sign(bitcount)*(abs(bitcount)*100+331) div 332);
  end;
 end;
end;

function strtobin1(const inp: string; out value: longword): boolean;
   //wandelt 1..0-string in longword)
var
 int1: integer;
 lwo1: longword;
begin
 result:= false;
 if inp <> '' then begin
  value:= 0;
  lwo1:= 1;
  for int1:= length(inp) downto 1 do begin
   if inp[int1] = '1' then begin
    value:= value + lwo1;
   end
   else begin
    if inp[int1] <> '0' then begin
     exit;
    end;
   end;
   lwo1:= lwo1 shl 1;
  end;
  result:= true;
 end;
end;

function trystrtobin(const inp: string; out value: longword): boolean;
begin
 result:= strtobin1(inp,value);
 if not result then begin
  result:= trystrtointvalue(inp,value);
 end;
end;

function strtobin(const inp: string): longword;
   //wandelt 0..1-string in longword)
begin
 if not trystrtobin(inp,result) then begin
  formaterror(inp);
 end;
end; 

function strtooct1(const inp: string; out value: longword): boolean;
var
 int1: integer;
 ca1: cardinal;
 ch1: char;
begin
 result:= false;
 if inp <> '' then begin
  value:= 0;
  ca1:= 0;
  for int1:= length(inp) downto 1 do begin
   ch1:= inp[int1];
   if (ch1 < '0') or (ch1 > '7') then begin
    exit;
   end;
   value:= value + cardinal(((ord(ch1) - ord('0'))) shl ca1);
   inc(ca1,3);
  end;
  result:= true;
 end;
end;

function trystrtooct(const inp: string; out value: longword): boolean;
begin
 result:= strtooct1(inp,value);
 if not result then begin
  result:= trystrtointvalue(inp,value);
 end;
end;

function strtooct(const inp: string): longword;
   //wandelt 1..0-string in longword)
begin
 if not trystrtooct(inp,result) then begin
  formaterror(inp);
 end;
end;

function strtodec1(const inp: string; out value: longword): boolean;
begin
 result:= trystrtoint(inp,integer(value));
end;

function trystrtodec(const inp: string; out value: longword): boolean;
begin
 result:= strtodec1(inp,value);
 if not result then begin
  result:= trystrtointvalue(inp,value);
 end; 
end;

function strtodec(const inp: string): longword;
   //wandelt 0..9-string in longword)
begin
 if not trystrtodec(inp,result) then begin
  formaterror(inp);
 end;
end;

function strtohex1(const inp: string; out value: longword): boolean;
begin
 result:= trystrtoint('$'+inp,integer(value));
end;

function trystrtohex(const inp: string; out value: longword): boolean;
begin
 result:= strtohex1(inp,value);
 if not result then begin
  result:= trystrtointvalue(inp,value);
 end;
end;

function strtohex(const inp: string): longword;
begin
 if not trystrtohex(inp,result) then begin
  formaterror(inp);
 end;
end;

function trystrtointvalue(const inp: string; out value: longword): boolean;
var
 lint1: int64;
begin
 result:= false;
 if length(inp) > 0 then begin
  case inp[1] of
  '%': result:= strtobin1(copy(inp,2,length(inp)-1),value);
  '&': result:= strtooct1(copy(inp,2,length(inp)-1),value);
  '#': result:= strtodec1(copy(inp,2,length(inp)-1),value);
  '$': result:= strtohex1(copy(inp,2,length(inp)-1),value);
   else begin
    if (length(inp) > 2) and
           ((inp[2] = 'x') or (inp[2] = 'X')) and (inp[1] = '0') then begin
     result:= strtohex1(copy(inp,3,length(inp)-2),value);
    end
    else begin
     result:= trystrtoint64(inp,lint1);
     if result then begin
      value:= lint1;
     end;
    end;
   end;
  end;
 end;
end;

function strtointvalue(const inp: string): longword;
begin
 if not trystrtointvalue(inp,result) then begin
  formaterror(inp);
 end;
end;

//todo: 64bit

function strtoptruint(const inp: string): ptruint;
begin
 result:= strtointvalue(inp);
end;

function trystrtoptruint(const inp: string; out value: ptruint): boolean;
begin
 result:= trystrtointvalue(inp,longword(value));
end;

function inttostrlen(inp: integer; len: integer;
     rechtsbuendig: boolean = true; fillchar: char = ' '): ansistring;
 //wandelt integer in string fester laenge
var
 int1: integer;
begin
 result:= inttostr(inp);
 int1:= length(result);
 setlength(result,len);
 if int1 < len then begin
  if rechtsbuendig then begin
   move(result[1],result[len-int1+1],int1);
   system.fillchar(result[1],len-int1,fillchar);
  end
  else begin
   system.fillchar(result[int1+1],len-int1,fillchar);
  end;
 end
 else begin
  if int1 > len then begin
   system.fillchar(result[1],len,fc_keinplatzchar);
  end;
 end;
end;

{$ifdef withformatsettings}
initialization
 getlocaleformatsettings(0,defaultformatsettings);
 defaultformatsettings.DecimalSeparator:= '.';
{$endif}
end.

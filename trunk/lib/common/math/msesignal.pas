{ MSEgui Copyright (c) 2010 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}

//
// todo: optimize for realtime, remove the OOP approach where
// it degrades performance. Implement recursive systems
//

unit msesignal;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msedatalist,mseclasses,classes,msetypes,msearrayprops;
type
 tcustomsigcomp = class;

 tdoublesigcomp = class;
 
 tdoubleconn = class(tmsecomponent) 
        //no solution found to link to streamed tpersistent or tobject,
        //fork of classes.pp necessary. :-(
  protected
   fowner: tdoublesigcomp;
  public
   constructor create(const aowner: tdoublesigcomp); reintroduce; virtual;
 end;
 
 tdoubleinputconn = class;
 doubleinputconnarty = array of tdoubleinputconn;
 
 tdoubleoutputconn = class(tdoubleconn)
  protected
   fdestinations: doubleinputconnarty;
  public
   constructor create(const aowner: tdoublesigcomp); override;

    //for systems without recursion
   procedure setsig1(var asource: doublearty); //asource is invalid afterwards
   procedure setsig(const asource: doublearty);
 end; 

 tdoubleinputconn = class(tdoubleconn)
  private
   fsource: tdoubleoutputconn;
   procedure setsource(const avalue: tdoubleoutputconn);
  protected
   fbuffer: doublearty;
   fhasdata: boolean;
  public
   constructor create(const aowner: tdoublesigcomp); override;
   destructor destroy; override;
   
    //for systems without recursion
   procedure setsig1(var asource: doublearty); virtual; 
                       //asource is invalid afterwards
   procedure setsig(const asource: doublearty); virtual;
   
  published
   property source: tdoubleoutputconn read fsource write setsource;
 end;

 tcustomsigcomp = class(tmsecomponent)
  protected
   procedure coeffchanged(const sender: tdatalist;
                                 const aindex: integer); virtual;
 end;

 tsigcomp = class(tcustomsigcomp)
 end;

 tdoublesigcomp = class(tsigcomp)
  private
  protected
   procedure setsig1(const sender: tdoubleinputconn;
                                    var asource: doublearty); virtual;
   procedure setsig(const sender: tdoubleinputconn;
                                    const asource: doublearty); virtual;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   procedure clear; virtual;
  published
 end;
 
 tsigconnection = class(tdoublesigcomp)
 end;
 
 tsigin = class(tsigconnection)
  private
   foutput: tdoubleoutputconn;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy;
   procedure setsig1(var asource: doublearty); //asource is invalid afterwards
   procedure setsig(const asource: doublearty);
  published
 end;

 sigouteventty = procedure(const sender: tobject;
                               const sig: doublearty) of object; 
                              
 tsigout = class(tsigconnection)
  private
   finput: tdoubleinputconn;
   foutp: doublearty;
   fonoutput: sigouteventty;
   procedure setinput(const avalue: tdoubleinputconn);
   function getinput: tdoubleinputconn;
  protected
   procedure setsig1(const sender: tdoubleinputconn;
                                 var asource: doublearty); override;
   procedure setsig(const sender: tdoubleinputconn;
                                 const asource: doublearty); override;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   property outp: doublearty read foutp;
  published
   property input: tdoubleinputconn read getinput write setinput;
   property onoutput: sigouteventty read fonoutput write fonoutput;
 end;
 
 trealcoeff = class(trealdatalist)
  protected
   fowner: tcustomsigcomp;
   procedure change(const aindex: integer); override;
  public
   constructor create(const aowner: tcustomsigcomp);
 end; 

 tcomplexcoeff = class(tcomplexdatalist)
  protected
   fowner: tcustomsigcomp;
   procedure change(const aindex: integer); override;
  public
   constructor create(const aowner: tcustomsigcomp);
 end; 

 tdoublezcomp = class(tdoublesigcomp) //single input, single output
  private
   procedure setinput(const avalue: tdoubleinputconn);
   procedure setoutput(const avalue: tdoubleoutputconn);
  protected
   fzcount: integer;
   fzhigh: integer;
   fdoublez: doublearty;
   fzindex: integer;
   finputindex: integer;
   fdoubleinputdata: doubleararty;
   finput: tdoubleinputconn;
   foutput: tdoubleoutputconn;
   procedure setzcount(const avalue: integer);
   procedure processinout(const acount: integer;
                    var ainp,aoutp: pdouble); virtual; abstract;
   procedure zcountchanged; virtual;
   procedure setsig1(const sender: tdoubleinputconn;
                                    var asource: doublearty); overload; override;
   procedure setsig(const sender: tdoubleinputconn;
                                    const asource: doublearty); overload; override;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   procedure clear; override;
   procedure setsig(const source: doublearty); overload;
   procedure getsig1(var dest: doublearty); overload;
   function getsig: doublearty;
   procedure updatesig(var inout: doublearty);
   property zcount: integer read fzcount default 0;
   property output: tdoubleoutputconn read foutput write setoutput;
  published
   property input: tdoubleinputconn read finput write setinput;
 end;
{                           
 tdoubleinpconnitem = class(tsubcomponentitem)
  private
   function getitem: tdoubleinputconn;
   procedure setitem(const avalue: tdoubleinputconn);
  protected
   function createitem: tcomponent; override;
  published
   property item: tdoubleinputconn read getitem write setitem;
 end;
 }
 tdoubleinpconnarrayprop = class(tpersistentarrayprop)
  private
   fowner: tdoublesigcomp;
   function getitems(const index: integer): tdoubleinputconn;
  protected
   procedure createitem(const index: integer; var item: tpersistent); override;
  public
   constructor create(const aowner: tdoublesigcomp); reintroduce;
   property items[const index: integer]: tdoubleinputconn read getitems; default;
 end;
 
 tsigmultiinp = class(tdoublesigcomp)
  private
   finputs: tdoubleinpconnarrayprop;
   foutput: tdoubleoutputconn;
    //local variables
   dar: doublearty;
   pdar: doublepoarty;
   procedure setinputs(const avalue: tdoubleinpconnarrayprop);
   procedure setoutput(const avalue: tdoubleoutputconn);
  protected
   finpdatacount: integer;
   procedure processinout(const acount: integer;
             var ainp: doublepoarty; var aoutp: pdouble); virtual; abstract;
    //for systems without recursion
   procedure setsig1(const sender: tdoubleinputconn;
                                    var asource: doublearty); override;
   procedure setsig(const sender: tdoubleinputconn;
                                    const asource: doublearty); override;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   procedure clear; override;
   property output: tdoubleoutputconn read foutput write setoutput;
  published
   property inputs: tdoubleinpconnarrayprop read finputs write setinputs;
 end;
 
 tsigadd = class(tsigmultiinp)
  protected
   procedure processinout(const acount: integer;
             var ainp: doublepoarty; var aoutp: pdouble); override;
 end;
 
 tsigmult = class(tsigmultiinp)
  protected
   procedure processinout(const acount: integer;
             var ainp: doublepoarty; var aoutp: pdouble); override;
 end;
 
procedure createsigbuffer(var abuffer: doublearty; const asize: integer);
procedure createsigarray(out abuffer: doublearty; const asize: integer);
procedure setsourceconn(const sender: tmsecomponent;
              const avalue: tdoubleoutputconn; var dest: tdoubleoutputconn);
 
implementation
uses
 sysutils;
type
 tmsecomponent1 = class(tmsecomponent);
  
procedure createsigbuffer(var abuffer: doublearty; const asize: integer);
begin
 if (length(abuffer) < asize) or 
         (psizeint(pchar(pointer(abuffer))-2*sizeof(sizeint))^ > 1) then begin
  abuffer:= nil;
  allocuninitedarray(asize,sizeof(double),abuffer);
 end
 else begin
  setlength(abuffer,asize);
 end;
end;

procedure createsigarray(out abuffer: doublearty; const asize: integer);
begin
 abuffer:= nil;
 allocuninitedarray(asize,sizeof(double),abuffer);
end;

procedure setsourceconn(const sender: tmsecomponent;
              const avalue: tdoubleoutputconn; var dest: tdoubleoutputconn);
begin
 if dest <> nil then begin
  if csdestroying in dest.componentstate then begin
   dest.fdestinations:= nil;
  end
  else begin
   removeitem(pointerarty(dest.fdestinations),sender);
  end;
 end;
 tmsecomponent1(sender).setlinkedvar(avalue,tmsecomponent(dest));
 if dest <> nil then begin
  additem(pointerarty(dest.fdestinations),sender);
 end;
end;

{ trealcoeff }

constructor trealcoeff.create(const aowner: tcustomsigcomp);
begin
 fowner:= aowner;
 inherited create;
end;

procedure trealcoeff.change(const aindex: integer);
begin
 fowner.coeffchanged(self,aindex);
 inherited;
end;

{ tcomplexcoeff }

constructor tcomplexcoeff.create(const aowner: tcustomsigcomp);
begin
 fowner:= aowner;
 inherited create;
end;

procedure tcomplexcoeff.change(const aindex: integer);
begin
 fowner.coeffchanged(self,aindex);
 inherited;
end;

{ tcustomsigcomp }

procedure tcustomsigcomp.coeffchanged(const sender: tdatalist;
               const aindex: integer);
begin
 //dummy
end;

{ tdoublconn }

constructor tdoubleconn.create(const aowner: tdoublesigcomp);
begin
 fowner:= aowner;
 inherited create(aowner);
 setsubcomponent(true);
end;

{ tdoubleoutputconn }

constructor tdoubleoutputconn.create(const aowner: tdoublesigcomp);
begin
 inherited;
 include (fmsecomponentstate,cs_subcompref);
 name:= 'output';
end;

procedure tdoubleoutputconn.setsig1(var asource: doublearty);
var
 int1: integer;
begin
 int1:= high(fdestinations);
 if int1 = 0 then begin
  fdestinations[0].setsig1(asource);
 end
 else begin
  for int1:= 0 to int1 do begin
   fdestinations[int1].setsig(asource);
  end;
 end;
end;

procedure tdoubleoutputconn.setsig(const asource: doublearty);
var
 int1: integer;
begin
 for int1:= 0 to high(fdestinations) do begin
  fdestinations[int1].setsig(asource);
 end;
end;

{ tdoubleinputconn }

constructor tdoubleinputconn.create(const aowner: tdoublesigcomp);
begin
 inherited;
 name:= 'input';
end;

destructor tdoubleinputconn.destroy;
begin
 source:= nil;
 inherited;
end;

procedure tdoubleinputconn.setsource(const avalue: tdoubleoutputconn);
begin
 setsourceconn(self,avalue,fsource);
end;

procedure tdoubleinputconn.setsig1(var asource: doublearty);
begin
 fowner.setsig1(self,asource);
end;

procedure tdoubleinputconn.setsig(const asource: doublearty);
begin
 fowner.setsig(self,asource);
end;

{ tdoublesigcomp }

constructor tdoublesigcomp.create(aowner: tcomponent);
begin
 inherited;
end;
 
destructor tdoublesigcomp.destroy;
begin
 clear;
 inherited;
end;

procedure tdoublesigcomp.clear;
begin
 //dummy
end;

procedure tdoublesigcomp.setsig1(const sender: tdoubleinputconn;
               var asource: doublearty);
begin
 //dummy
end;

procedure tdoublesigcomp.setsig(const sender: tdoubleinputconn;
               const asource: doublearty);
begin
 //dummy
end;

{ tdoublezcomp }

constructor tdoublezcomp.create(aowner: tcomponent);
begin
 fzhigh:= -1;
 finput:= tdoubleinputconn.create(self);
 foutput:= tdoubleoutputconn.create(self);
 inherited;
end;

destructor tdoublezcomp.destroy;
begin
 inherited;
end;

procedure tdoublezcomp.zcountchanged;
begin
 //dummy
end;

procedure tdoublezcomp.clear;
begin
 inherited;
 fdoubleinputdata:= nil;
 finputindex:= 0;
 fillchar(pointer(fdoublez)^,fzcount*sizeof(double),0);
 fzindex:= 0; 
end;

procedure tdoublezcomp.setsig(const source: doublearty);
begin
 if finputindex > high(fdoubleinputdata) then begin
  setlength(fdoubleinputdata,finputindex+1);
 end;
 fdoubleinputdata[finputindex]:= source;
 inc(finputindex);
end;

procedure tdoublezcomp.updatesig(var inout: doublearty);
var
 po1,po2: pdouble;
begin
 po1:= pointer(inout);
 po2:= po1;
 processinout(length(inout),po1,po2);
end;

procedure tdoublezcomp.getsig1(var dest: doublearty);
var
 int1,int3: integer;
 po1,po2: pdouble;
begin
 int3:= 0;
 for int1:= 0 to finputindex-1 do begin
  int3:= int3 + high(fdoubleinputdata[int1]);
 end;
 int3:= int3 + finputindex;
 createsigbuffer(dest,int3);
 po2:= pointer(dest);
 for int1:= 0 to finputindex-1 do begin
  po1:= pointer(fdoubleinputdata[int1]);
  processinout(length(fdoubleinputdata[int1]),po1,po2);
 end;  
 for int1:= 0 to finputindex-1 do begin
  fdoubleinputdata[int1]:= nil;
 end;
 finputindex:= 0;
end;

function tdoublezcomp.getsig: doublearty;
begin
 getsig1(result);
end;

procedure tdoublezcomp.setsig1(const sender: tdoubleinputconn;
               var asource: doublearty);
var
 po1,po2: pdouble;
begin
 po1:= pointer(asource);
 po2:= po1;
 processinout(length(asource),po1,po2);
 foutput.setsig1(asource);
end;

procedure tdoublezcomp.setsig(const sender: tdoubleinputconn;
               const asource: doublearty);
var
 int1: integer;
 ar1: doublearty;
 po1,po2: pdouble;
begin
 int1:= length(asource);
 createsigarray(ar1,int1);
 po1:= pointer(asource);
 po2:= pointer(ar1);
 processinout(int1,po1,po2);
 foutput.setsig1(ar1);
end;

procedure tdoublezcomp.setzcount(const avalue: integer);
begin
 if fzcount <> avalue then begin
  if avalue < 0 then begin
   raise exception.create('Invalid coeffcount.');
  end;
  clear;
  fzcount:= avalue;
  fzhigh:= avalue - 1;
  setlength(fdoublez,avalue);
  zcountchanged;
 end;
end;

procedure tdoublezcomp.setinput(const avalue: tdoubleinputconn);
begin
 finput.assign(avalue);
end;

procedure tdoublezcomp.setoutput(const avalue: tdoubleoutputconn);
begin
 foutput.assign(avalue);
end;

{ tsigout }

constructor tsigout.create(aowner: tcomponent);
begin
 finput:= tdoubleinputconn.create(self);
 inherited;
end;

destructor tsigout.destroy;
begin
 inherited;
end;

procedure tsigout.setinput(const avalue: tdoubleinputconn);
begin
 finput.assign(avalue);
end;

function tsigout.getinput: tdoubleinputconn;
begin
 result:= finput;
end;

procedure tsigout.setsig1(const sender: tdoubleinputconn;
               var asource: doublearty);
begin
 foutp:= asource;
 if assigned(fonoutput) then begin
  fonoutput(self,foutp);
 end;
end;

procedure tsigout.setsig(const sender: tdoubleinputconn;
               const asource: doublearty);
begin
 foutp:= asource;
 if assigned(fonoutput) then begin
  fonoutput(self,foutp);
 end;
end;

{ tsigin }

constructor tsigin.create(aowner: tcomponent);
begin
 foutput:= tdoubleoutputconn.create(self);
 inherited;
end;

destructor tsigin.destroy;
begin
 inherited;
end;

procedure tsigin.setsig(const asource: doublearty);
begin
 foutput.setsig(asource);
end;

procedure tsigin.setsig1(var asource: doublearty);
begin
 foutput.setsig1(asource);
end;

{ tsigmultiinp }

constructor tsigmultiinp.create(aowner: tcomponent);
begin
 foutput:= tdoubleoutputconn.create(self);
 inherited;
 finputs:= tdoubleinpconnarrayprop.create(self);
end;

destructor tsigmultiinp.destroy;
begin
 inherited;
 finputs.free;
end;

procedure tsigmultiinp.clear;
var
 int1: integer;
begin
 dar:= nil;
 pdar:= nil;
 finpdatacount:= 0;
 inherited;
 for int1:= 0 to high(finputs.fitems) do begin
  tdoubleinputconn(finputs.fitems[int1]).fbuffer:= nil;
 end;
end;

procedure tsigmultiinp.setinputs(const avalue: tdoubleinpconnarrayprop);
begin
 finputs.assign(avalue);
end;

procedure tsigmultiinp.setoutput(const avalue: tdoubleoutputconn);
begin
 foutput.assign(avalue);
end;

procedure tsigmultiinp.setsig(const sender: tdoubleinputconn;
               const asource: doublearty);
begin
 dar:= copy(asource);
 setsig1(sender,dar);
end;

procedure tsigmultiinp.setsig1(const sender: tdoubleinputconn;
               var asource: doublearty);
var
 int1,int2,int3: integer;
 po1: pdouble;
begin
//todo: optimize
 stackarray(realarty(asource),realarty(sender.fbuffer));
 if not sender.fhasdata then begin
  sender.fhasdata:= true;
  inc(finpdatacount);
  if finpdatacount >= finputs.count then begin
   int2:= bigint;
   setlength(pdar,finputs.count);
   for int1:= 0 to high(finputs.fitems) do begin
    with tdoubleinputconn(finputs.fitems[int1]) do begin
     int3:= high(fbuffer);
     if int3 < int2 then begin
      int2:= int3;
     end;
     pdar[int1]:= pointer(fbuffer);
    end;
   end;
   inc(int2);
//   createsigbuffer(asource,int2);
   po1:= pointer(asource);
   processinout(int2,pdar,po1);
   for int1:= 0 to high(finputs.fitems) do begin
    with tdoubleinputconn(finputs.fitems[int1]) do begin
     if length(fbuffer) <= int2 then begin
      fbuffer:= nil;
      fhasdata:= false;
      dec(finpdatacount);
     end
     else begin
      move(fbuffer[int2],fbuffer[0],(length(fbuffer)-int2)*sizeof(double));
     end;
    end;
   end;
   foutput.setsig1(asource);
  end;
 end;
end;

{ tdoubleinpconnarrayprop }

constructor tdoubleinpconnarrayprop.create(const aowner: tdoublesigcomp);
begin
 fowner:= aowner;
 inherited create(nil);
end;

procedure tdoubleinpconnarrayprop.createitem(const index: integer;
               var item: tpersistent);
begin
 item:= tdoubleinputconn.create(nil);
 tdoubleinputconn(item).fowner:= fowner;
end;

function tdoubleinpconnarrayprop.getitems(const index: integer): tdoubleinputconn;
begin
 result:= tdoubleinputconn(inherited getitems(index));
end;

(*
{ tdoubleinpconnitem }

function tdoubleinpconnitem.createitem: tcomponent;
begin
 result:= tdoubleinputconn.create(tdoublesigcomp(fowner));
end;

function tdoubleinpconnitem.getitem: tdoubleinputconn;
begin
 result:= tdoubleinputconn(fitem);
end;

procedure tdoubleinpconnitem.setitem(const avalue: tdoubleinputconn);
begin
 fitem.assign(avalue);
end;
*)
{ tsigadd }

procedure tsigadd.processinout(const acount: integer; var ainp: doublepoarty;
               var aoutp: pdouble);
var
 int1,int2: integer;
 rea1: real;
begin
 for int1:= 0 to acount - 1 do begin
  rea1:= 0;
  for int2:= 0 to high(ainp) do begin
   rea1:= rea1 + ainp[int2]^;
   inc(ainp[int2]);
  end;
  aoutp^:= rea1;
  inc(aoutp);
 end;
end;

{ tsigmult }

procedure tsigmult.processinout(const acount: integer; var ainp: doublepoarty;
               var aoutp: pdouble);
var
 int1,int2: integer;
 rea1: real;
begin
 for int1:= 0 to acount - 1 do begin
  rea1:= 1;
  for int2:= 0 to high(ainp) do begin
   rea1:= rea1 * ainp[int2]^;
   inc(ainp[int2]);
  end;
  aoutp^:= rea1;
  inc(aoutp);
 end;
end;

end.

{ MSEgui Copyright (c) 2010 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit mserttistat;

{$ifdef FPC}
 {$ifndef mse_no_ifi}
  {$define mse_with_ifi}
 {$endif}
 {$mode objfpc}{$h+}
{$endif}

interface
uses
 classes,mseclasses,msestat,msestatfile,msestrings,typinfo,msetypes;
 
type
 getobjecteventty = procedure(const sender: tobject;
                                   var avalue: tobject) of object;

// setter procedures for dynymic array properties must have  ???
// const param modifier!                                     ???
                                   
 tcustomrttistat = class(tmsecomponent,istatfile)
  private
   fstatfile: tstatfile;
   fstatvarname: msestring;
   fongetobject: getobjecteventty;
   fonstatupdate: statupdateeventty;
   fonstatread: statreadeventty;
   fonstatwrite: statwriteeventty;
   fonstatbeforeread: notifyeventty;
   fonstatafterread: notifyeventty;
   procedure setstatfile(const avalue: tstatfile);
  protected
    //istatfile
   procedure dostatread(const reader: tstatreader); virtual;
   procedure dostatwrite(const writer: tstatwriter); virtual;
   procedure statreading;
   procedure statread;
   function getstatvarname: msestring;
   function getobj(out aobj: tobject): boolean;
  public
  {$ifdef mse_with_ifi}
   procedure valuestoobj(const sourceroot: tcomponent);
     //reads values from components with matching property-component names
   procedure objtovalues(const destroot: tcomponent);
     //writes values to components with matching property-component names
  {$endif}   
   property statfile: tstatfile read fstatfile write setstatfile;
   property statvarname: msestring read fstatvarname write fstatvarname;
   property ongetobject: getobjecteventty read fongetobject write fongetobject;
   property onstatupdate: statupdateeventty read fonstatupdate 
                                                        write fonstatupdate;
   property onstatread: statreadeventty read fonstatread 
                                                        write fonstatread;
   property onstatwrite: statwriteeventty read fonstatwrite 
                                                        write fonstatwrite;
   property onstatbeforeread: notifyeventty read fonstatbeforeread
                                                        write fonstatbeforeread;
   property onstatafterread: notifyeventty read fonstatafterread 
                                                        write fonstatafterread;   
 end;

 trttistat = class(tcustomrttistat)
  protected
  published
   property statfile;
   property statvarname;
   property ongetobject;
   property onstatupdate;
   property onstatread;
   property onstatwrite;
   property onstatbeforeread;
   property onstatafterread;   
 end;

implementation
uses
 {$ifdef mse_with_ifi}mseificompglob,{$endif}msedatalist;

type
 dynarraysetter = procedure(const avalue: pointerarty) of object;
                                     //dummy type
 dynarraygetter = function: pointerarty of object;
                                     //dummy type

function getdynarray(const aobj: tobject; const aprop: ppropinfo): pointer;
var
 getterkind: integer;
 meth1: tmethod;
begin
 getterkind:= (aprop^.propprocs) and 3;
 case getterkind of
  ptfield: begin
   result:= ppointer(pointer(aobj) + ptruint(aprop^.getproc))^;
  end;
  ptstatic: begin
   meth1.code:= aprop^.getproc;
  end
  else begin //ptvirtual
   meth1.code:= ppointer(pointer(aobj.classtype) + 
                                 ptruint(aprop^.getproc))^;
  end;
 end;
 if getterkind <> ptfield then begin
  meth1.data:= aobj;
  result:= pointer(dynarraygetter(meth1)());
 end;
end;

function setdynarray(const aobj: tobject; const aprop: ppropinfo;
             const avalue: pointer): pointer; 
                   // returns valuebefore for finalize
var
 setterkind: integer;
 meth1: tmethod;
begin
 setterkind:= (aprop^.propprocs shr 2) and 3;
 result:= nil;
 case setterkind of
  ptfield: begin
   arrayaddref((@avalue)^);
   result:= getdynarray(aobj,aprop);
   ppointer(pointer(aobj) + ptruint(aprop^.setproc))^:= avalue;
   exit;
  end;
  ptstatic: begin
   meth1.code:= aprop^.setproc;
  end
  else begin //ptvirtual
   meth1.code:= ppointer(pointer(aobj.classtype) + 
                                 ptruint(aprop^.setproc))^;
  end;
 end;
 meth1.data:= aobj;
 dynarraysetter(meth1)(avalue);
end;

function getintegerar(const aobj: tobject; const aprop: ppropinfo): integerarty;
begin
 result:= integerarty(getdynarray(aobj,aprop));
end;

procedure setintegerar(const aobj: tobject; const aprop: ppropinfo;
                                                  const avalue: integerarty);
var
 ar1: integerarty;
begin
 pointer(ar1):= setdynarray(aobj,aprop,pointer(avalue));
 ar1:= nil; //finalize
end;

function getrealar(const aobj: tobject; const aprop: ppropinfo): realarty;
begin
 result:= realarty(getdynarray(aobj,aprop));
end;

procedure setrealar(const aobj: tobject; const aprop: ppropinfo;
                                                 const avalue: realarty);
var
 ar1: realarty;
begin
 pointer(ar1):= setdynarray(aobj,aprop,pointer(avalue));
 ar1:= nil; //finalize
end;

function getmsestringar(const aobj: tobject;
                           const aprop: ppropinfo): msestringarty;
begin
 result:= msestringarty(getdynarray(aobj,aprop));
end;

procedure setmsestringar(const aobj: tobject; const aprop: ppropinfo;
                                                 const avalue: msestringarty);
var
 ar1: msestringarty;
begin
 pointer(ar1):= setdynarray(aobj,aprop,pointer(avalue));
 ar1:= nil; //finalize
end;

function getstringar(const aobj: tobject;
                           const aprop: ppropinfo): stringarty;
begin
 result:= stringarty(getdynarray(aobj,aprop));
end;

procedure setstringar(const aobj: tobject; const aprop: ppropinfo;
                                                 const avalue: stringarty);
var
 ar1: stringarty;
begin
 pointer(ar1):= setdynarray(aobj,aprop,pointer(avalue));
 ar1:= nil; //finalize
end;

function getbooleanar(const aobj: tobject;
                           const aprop: ppropinfo): booleanarty;
begin
 result:= booleanarty(getdynarray(aobj,aprop));
end;

procedure setbooleanar(const aobj: tobject; const aprop: ppropinfo;
                                                 const avalue: booleanarty);
var
 ar1: booleanarty;
begin
 pointer(ar1):= setdynarray(aobj,aprop,pointer(avalue));
 ar1:= nil; //finalize
end;

procedure readobjectstat(const reader: tstatreader; const aobj: tobject);
var
 ar1: propinfopoarty; 
 po1: ppropinfo;
 po2: ptypeinfo;
 po3: ptypedata;
 int1: integer;
 obj1: tobject;
 intf1: istatfile;
 intar: integerarty;
 realar: realarty;
begin
 ar1:= getpropinfoar(aobj);
 for int1 := 0 to high(ar1) do begin
  po1:= ar1[int1];
  with po1^ do begin
   case proptype^.kind of
    tkInteger,tkChar,tkEnumeration,tkWChar,tkSet: begin
     setordprop(aobj,po1,reader.readinteger(name,getordprop(aobj,po1)));
    end;
    tkint64: begin
     setordprop(aobj,po1,reader.readint64(name,getordprop(aobj,po1)));
    end;
    tkfloat: begin
     setfloatprop(aobj,po1,reader.readreal(name,getfloatprop(aobj,po1)));
    end;
    tkwstring: begin
     setwidestrprop(aobj,po1,reader.readmsestring(
                                         name,getwidestrprop(aobj,po1)));
    end;
    tkustring: begin
     setunicodestrprop(aobj,po1,reader.readmsestring(
                                         name,getunicodestrprop(aobj,po1)));
    end;
    tkastring,tklstring,tkstring: begin
     setstrprop(aobj,po1,reader.readstring(name,getstrprop(aobj,po1)));
    end;
     //how to reach fpc_DecRef?
    tkdynarray: begin
     po2:= pointer(gettypedata(proptype)^.eltype2); 
                         //wrong define in ttypedata
     po3:= gettypedata(po2);
     case po2^.kind of
      tkinteger: begin
       setintegerar(aobj,po1,reader.readarray(name,getintegerar(aobj,po1)));
      end;
      tkfloat: begin
       if po3^.floattype = ftdouble then begin
        setrealar(aobj,po1,reader.readarray(name,getrealar(aobj,po1)));
       end;
      end;
      tkustring: begin
       setmsestringar(aobj,po1,reader.readarray(name,getmsestringar(aobj,po1)));
      end;
      tkastring: begin
       setstringar(aobj,po1,reader.readarray(name,getstringar(aobj,po1)));
      end;
      tkbool: begin
       setbooleanar(aobj,po1,reader.readarray(name,getbooleanar(aobj,po1)));
      end;
     end;
    end;
    tkclass: begin
     obj1:= tobject(ptruint(getordprop(aobj,po1)));
     if obj1 is tdatalist then begin
      reader.readdatalist(name,tdatalist(obj1));
     end;
    end;
   end;
  end;
 end;
end;

procedure writeobjectstat(const writer: tstatwriter; const aobj: tobject);
var
 ar1: propinfopoarty; 
// ar2: array of istatfile;
 po1: ppropinfo;
 po2: ptypeinfo;
 po3: ptypedata;
 int1: integer;
 obj1: tobject;
 intf1: istatfile;
begin
 ar1:= getpropinfoar(aobj);
 for int1 := 0 to high(ar1) do begin
  po1:= ar1[int1];
  with po1^ do begin
   case proptype^.kind of
    tkInteger,tkChar,tkEnumeration,tkWChar,tkSet,tkbool: begin
     writer.writeinteger(name,getordprop(aobj,po1));
    end;
    tkint64: begin
     writer.writeint64(name,getordprop(aobj,po1));
    end;
    tkfloat: begin
     writer.writereal(name,getfloatprop(aobj,po1));
    end;
    tkustring: begin
     writer.writemsestring(name,getunicodestrprop(aobj,po1));
    end;
    tkwstring: begin
     writer.writemsestring(name,getwidestrprop(aobj,po1));
    end;
    tkastring,tklstring,tkstring: begin
     writer.writestring(name,getstrprop(aobj,po1));
    end;
    tkdynarray: begin
     po2:= pointer(gettypedata(proptype)^.eltype2); 
                         //wrong define in ttypedata
     po3:= gettypedata(po2);
     case po2^.kind of
      tkinteger: begin
       writer.writearray(name,getintegerar(aobj,po1));
      end;
      tkfloat: begin
       if po3^.floattype = ftdouble then begin
        writer.writearray(name,getrealar(aobj,po1));
       end;
      end;
      tkustring: begin
       writer.writearray(name,getmsestringar(aobj,po1));
      end;
      tkastring: begin
       writer.writearray(name,getstringar(aobj,po1));
      end;
      tkbool: begin
       writer.writearray(name,getbooleanar(aobj,po1));
      end;
     end;
    end;
    tkclass: begin
     obj1:= tobject(ptruint(getordprop(aobj,po1)));
     if obj1 is tdatalist then begin
      writer.writedatalist(name,tdatalist(obj1));
     end;
    end;
   end;
  end;
 end;
end;

{$ifdef mse_with_ifi}
procedure valuestoobject(const sourceroot: tcomponent; const dest: tobject);
var
 comp1: tcomponent;
 ar1: propinfopoarty; 
 po1,po4: ppropinfo;
 po2: ptypeinfo;
 po3: ptypedata;
 int1: integer;
 intf1: iifidatalink;
 obj1: tobject;
 list1: tdatalist;
 arpo: pointer;
begin
 ar1:= getpropinfoar(dest);
 for int1 := 0 to high(ar1) do begin
  po1:= ar1[int1];
  with po1^ do begin
   comp1:= sourceroot.findcomponent(name);
   if (comp1 <> nil) and 
     mseclasses.getcorbainterface(comp1,typeinfo(iifidatalink),
                                                      intf1)  then begin
    po4:= intf1.getvalueprop;
    if po4 <> nil then begin
     case proptype^.kind of
      tkInteger,tkChar,tkEnumeration,tkWChar,tkSet,tkbool: begin
       if po4^.proptype^.kind in 
             [tkInteger,tkChar,tkEnumeration,tkWChar,tkSet,tkbool] then begin
        setordprop(dest,po1,getordprop(comp1,po4));
       end;
      end;
      tkint64: begin
       if po4^.proptype^.kind in 
             [tkint64] then begin
        setordprop(dest,po1,getordprop(comp1,po4));
       end;
      end;
      tkfloat: begin
       if po4^.proptype^.kind in 
             [tkfloat] then begin
        setfloatprop(dest,po1,getfloatprop(comp1,po4));
       end;
      end;
      tkustring: begin
       if po4^.proptype^.kind in [tkustring] then begin
        setunicodestrprop(dest,po1,getunicodestrprop(comp1,po4));
       end;
      end;
      tkwstring: begin
       if po4^.proptype^.kind in [tkustring] then begin
        setwidestrprop(dest,po1,getunicodestrprop(comp1,po4));
       end;
      end;
      tkastring,tklstring,tkstring: begin
       if po4^.proptype^.kind in [tkustring] then begin
        setstrprop(dest,po1,getunicodestrprop(comp1,po4));
       end;
      end;
      tkclass: begin
       obj1:= tobject(ptruint(getordprop(dest,po1)));
       if (obj1 is tdatalist) then begin
        list1:= intf1.getgriddata;
        if list1 <> nil then begin
         tdatalist(obj1).assign(list1);
        end;
       end;
      end;
      tkdynarray: begin
       list1:= intf1.getgriddata;
       if list1 <> nil then begin
        arpo:= pointer(ptruint(getordprop(dest,po1)));
        po2:= pointer(gettypedata(proptype)^.eltype2); 
                            //wrong define in ttypedata
        po3:= gettypedata(po2);
        case po2^.kind of
         tkinteger: begin
          if list1 is tintegerdatalist then begin
           setintegerar(dest,po1,tintegerdatalist(list1).asarray);
          end;
         end;
         tkfloat: begin
          if list1 is trealdatalist then begin
           setrealar(dest,po1,trealdatalist(list1).asarray);
          end;
         end;
         tkustring: begin
          if list1 is tpoorstringdatalist then begin
           setmsestringar(dest,po1,tpoorstringdatalist(list1).asarray);
          end;
         end;
         tkastring: begin
          if list1 is tansistringdatalist then begin
           setstringar(dest,po1,tansistringdatalist(list1).asarray);
          end;
         end;
         tkbool: begin
          if list1 is tintegerdatalist then begin
           setbooleanar(dest,po1,tintegerdatalist(list1).asbooleanarray);
          end;
         end;
        end;
       end;
      end;
     end;
    end;
   end;
  end;
 end;
end;

procedure objecttovalues(const source: tobject; const destroot: tcomponent);
var
 comp1: tcomponent;
 ar1: propinfopoarty; 
 po1,po4: ppropinfo;
 po2: ptypeinfo;
 po3: ptypedata;
 int1: integer;
 intf1: iifidatalink;
 obj1: tobject;
 list1: tdatalist;
begin
 ar1:= getpropinfoar(source);
 for int1 := 0 to high(ar1) do begin
  po1:= ar1[int1];
  with po1^ do begin
   comp1:= destroot.findcomponent(name);
   if (comp1 <> nil) and 
     mseclasses.getcorbainterface(comp1,typeinfo(iifidatalink),
                                                      intf1)  then begin
    po4:= intf1.getvalueprop;
    if po4 <> nil then begin
     case proptype^.kind of
      tkInteger,tkChar,tkEnumeration,tkWChar,tkSet,tkbool: begin
       if po4^.proptype^.kind in 
             [tkInteger,tkChar,tkEnumeration,tkWChar,tkSet,tkbool] then begin
        setordprop(comp1,po4,getordprop(source,po1));
       end;
      end;
      tkint64: begin
       if po4^.proptype^.kind in 
             [tkint64] then begin
        setordprop(comp1,po4,getordprop(source,po1));
       end;
      end;
      tkfloat: begin
       if po4^.proptype^.kind in 
             [tkfloat] then begin
        setfloatprop(comp1,po4,getfloatprop(source,po1));
       end;
      end;
      tkustring: begin
       if po4^.proptype^.kind in [tkustring] then begin
        setunicodestrprop(comp1,po4,getunicodestrprop(source,po1));
       end;
      end;
      tkwstring: begin
       if po4^.proptype^.kind in [tkustring] then begin
        setunicodestrprop(comp1,po4,getwidestrprop(source,po1));
       end;
      end;
      tkastring,tklstring,tkstring: begin
       if po4^.proptype^.kind in [tkustring] then begin
        setunicodestrprop(comp1,po4,getstrprop(source,po1));
       end;
      end;
      tkdynarray: begin
       list1:= intf1.getgriddata;
       if list1 <> nil then begin
        po2:= pointer(gettypedata(proptype)^.eltype2); 
                            //wrong define in ttypedata
        po3:= gettypedata(po2);
        case po2^.kind of
         tkinteger: begin
          if list1 is tintegerdatalist then begin
           tintegerdatalist(list1).asarray:= getintegerar(source,po1);
          end;
         end;
         tkfloat: begin
          if (po3^.floattype = ftdouble) and (list1 is trealdatalist) then begin
           trealdatalist(list1).asarray:=  getrealar(source,po1);
          end;
         end;
         tkustring: begin
          if list1 is tpoorstringdatalist then begin
           tpoorstringdatalist(list1).asarray:= getmsestringar(source,po1);
          end;
         end;
         tkastring: begin
          if list1 is tansistringdatalist then begin
           tansistringdatalist(list1).asarray:= getstringar(source,po1);
          end;
         end;
         tkbool: begin
          if list1 is tintegerdatalist then begin
           tintegerdatalist(list1).asbooleanarray:= getbooleanar(source,po1);
          end;
         end;
        end;
       end;
      end;
      tkclass: begin
       obj1:= tobject(ptruint(getordprop(source,po1)));
       if (obj1 is tdatalist) then begin
        list1:= intf1.getgriddata;
        if list1 <> nil then begin
         list1.assign(tdatalist(obj1));
        end;
       end;
      end;
     end;
    end;
   end;
  end;
 end;
end;

{$endif}

{ tcustomrttistat }

procedure tcustomrttistat.statreading;
begin
 if assigned(fonstatbeforeread) then begin
  fonstatbeforeread(self);
 end;
end;

procedure tcustomrttistat.statread;
begin
 if assigned(fonstatafterread) then begin
  fonstatafterread(self);
 end;
end;

function tcustomrttistat.getstatvarname: msestring;
begin
 result:= fstatvarname;
end;

function tcustomrttistat.getobj(out aobj: tobject): boolean;
begin
 aobj:= nil;
 if assigned(fongetobject) then begin
  fongetobject(self,aobj);
 end;
 result:= aobj <> nil; 
end;

procedure tcustomrttistat.setstatfile(const avalue: tstatfile);
begin
 setstatfilevar(istatfile(self),avalue,fstatfile);
end;

procedure tcustomrttistat.dostatread(const reader: tstatreader);
var
 obj1: tobject;
begin
 if getobj(obj1) then begin
  readobjectstat(reader,obj1);
 end;
 if assigned(fonstatupdate) then begin
  fonstatupdate(self,reader);
 end;
 if assigned(fonstatread) then begin
  fonstatread(self,reader);
 end;
end;

procedure tcustomrttistat.dostatwrite(const writer: tstatwriter);
var
 obj1: tobject;
begin
 if getobj(obj1) then begin
  writeobjectstat(writer,obj1);
 end;
 if assigned(fonstatupdate) then begin
  fonstatupdate(self,writer);
 end;
 if assigned(fonstatwrite) then begin
  fonstatwrite(self,writer);
 end;
end;


{$ifdef mse_with_ifi}

procedure tcustomrttistat.valuestoobj(const sourceroot: tcomponent);
var
 obj1: tobject;
begin
 if getobj(obj1) then begin
  valuestoobject(sourceroot,obj1);
 end;
end;

procedure tcustomrttistat.objtovalues(const destroot: tcomponent);
var
 obj1: tobject;
begin
 if getobj(obj1) then begin
  objecttovalues(obj1,destroot);
 end;
end;

{$endif}

{ trttistat }

end.

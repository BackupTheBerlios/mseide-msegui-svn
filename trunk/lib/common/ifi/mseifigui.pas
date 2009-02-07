{ MSEgui Copyright (c) 2007-2009 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit mseifigui;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 classes,mseclasses,mseguiglob,mseifiglob,mseifi,mseact,msegui,typinfo,
 msestrings,
 msearrayprops,mseglob,msetypes,mseifilink,msewidgetgrid,msemenus,
 mseevent,msegrids,msegraphutils;
 
type
 
 ifiwidgetlinkoptionty = (iwlo_sendvalue,iwlo_sendmodalresult,
      iwlo_sendhide,iwlo_sendshow,
      iwlo_sendfocus,iwlo_senddefocus,iwlo_sendactivate,iwlo_senddeactivate);
 ifiwidgetlinkoptionsty = set of ifiwidgetlinkoptionty;
const
 widgetstateoptionsty = [iwlo_sendhide,iwlo_sendshow,iwlo_sendfocus,
      iwlo_senddefocus,iwlo_sendactivate,iwlo_senddeactivate];
type  

 tvaluewidgetlink = class(tcustomvaluecomponentlink)
  private
   foptions: ifiwidgetlinkoptionsty;
   fwidgetstatebefore: ifiwidgetstatesty;
   function getwidget: twidget;
   procedure setwidget(const avalue: twidget);
  published
   property widget: twidget read getwidget write setwidget;
   property options: ifiwidgetlinkoptionsty read foptions write foptions;
 end;
 
 tvaluewidgetlinks = class(tvaluelinks) 
  private
   function getitems(const index: integer): tvaluewidgetlink;
  protected
   function getitemclass: modulelinkpropclassty; override;  
  public
   class function getitemclasstype: persistentclassty; override;
   function byname(const aname: string): tvaluewidgetlink;
   property items[const index: integer]: tvaluewidgetlink read getitems; default;   
 end;

 tformlink = class(tcustommodulelink)
  private
   function getvaluewidgets: tvaluewidgetlinks;
   procedure setvaluewidgets(const avalue: tvaluewidgetlinks);
  protected
   function widgetcommandreceived(const atag: integer; const aname: string;
                      const acommand: ifiwidgetcommandty): boolean;
   function widgetpropertiesreceived(const atag: integer; const aname: string;
                      const adata: pifibytesty): boolean;
   function processdataitem(const adata: pifirecty; var adatapo: pchar;
                  const atag: integer; const aname: string): boolean; override;
   procedure valuechanged(const sender: iifiwidget); override;
   procedure statechanged(const sender: iifiwidget;
                             const astate: ifiwidgetstatesty); override;
   procedure sendmodalresult(const sender: iifiwidget; 
                              const amodalresult: modalresultty); override;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
  published
   property valuewidgets: tvaluewidgetlinks read getvaluewidgets 
                                                      write setvaluewidgets;
   property valuecomponents;
   property linkname;
   property actionsrx;
   property actionstx;
   property modulesrx;
   property modulestx;
   property channel;
   property options;
 end;

 trxwidgetgrid = class;
 
 tifiwidgetgridcontroller = class(tifirxcontroller)
  protected
   fdatasequence: sequencety;
   procedure processdata(const adata: pifirecty; var adatapo: pchar); 
                                    override;
   procedure setowneractive(const avalue: boolean); override;
   function getifireckinds: ifireckindsty; override;
   function encodegriddata(const asequence: sequencety): ansistring;
  public
   constructor create(const aowner: trxwidgetgrid);
 end;

 rxwidgetstatety = (rws_openpending,rws_datareceived); 
 rxwidgetstatesty = set of rxwidgetstatety;
 trxwidgetgrid = class(twidgetgrid)
  private
   fifi: tifiwidgetgridcontroller;
   factive: boolean;
   fistate: rxwidgetstatesty;
   procedure setifi(const avalue: tifiwidgetgridcontroller);
   procedure setactive(const avalue: boolean);
  protected
   procedure loaded; override;
   procedure internalopen;
   procedure internalclose;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   procedure post;
  published
   property ifi: tifiwidgetgridcontroller read fifi write setifi;
   property active: boolean read factive write setactive default false;
 end;
 
implementation
uses
 sysutils,msestream,msesysutils,msetmpmodules,msedatalist;
type
 tcustommodulelink1 = class(tcustommodulelink);
// tlinkdata1 = class(tlinkdata);
  
{ tvaluewidgetlink }

function tvaluewidgetlink.getwidget: twidget;
begin
 result:= twidget(fcomponent);
end;

procedure tvaluewidgetlink.setwidget(const avalue: twidget);
var
 intf1: iifiwidget;
begin
 intf1:= nil;
 fwidgetstatebefore:= [];
 fvalueproperty:= nil;
 if (avalue <> nil) and 
    not getcorbainterface(avalue,typeinfo(iifiwidget),intf1) then begin
  raise exception.create(avalue.name+': No ifiwidget.');
 end;
 if fintf <> nil then begin
  fintf.setifiserverintf(nil);
 end;
 fintf:= intf1;
 if fintf <> nil then begin
  fintf.setifiserverintf(iifiserver(tcustommodulelink(fowner)));
 end;
 inherited component:= avalue;
end;

{ tvaluewidgetlinks }

class function tvaluewidgetlinks.getitemclasstype: persistentclassty;
begin
 result:= tvaluewidgetlink;
end;

function tvaluewidgetlinks.getitems(const index: integer): tvaluewidgetlink;
begin
 result:= tvaluewidgetlink(inherited getitems(index));
end;

function tvaluewidgetlinks.byname(const aname: string): tvaluewidgetlink;
begin
 result:= tvaluewidgetlink(inherited byname(aname));
end;

function tvaluewidgetlinks.getitemclass: modulelinkpropclassty;
begin
 result:= tvaluewidgetlink;
end;

{ tformlink }

constructor tformlink.create(aowner: tcomponent);
begin
 if fvalues = nil then begin
  fvalues:= tvaluewidgetlinks.create(self);
 end;
 inherited;
end;

destructor tformlink.destroy;
begin
// fdatas.free;
 inherited;
end;

function tformlink.getvaluewidgets: tvaluewidgetlinks;
begin
 result:= tvaluewidgetlinks(fvalues);
end;

procedure tformlink.setvaluewidgets(const avalue: tvaluewidgetlinks);
begin
 fvalues.assign(avalue);
end;

function tformlink.processdataitem(const adata: pifirecty; 
           var adatapo: pchar; const atag: integer; const aname: string): boolean;
var
 command1: ifiwidgetcommandty;
 str2: string;
begin
 with adata^ do begin
  case header.kind of
   ik_widgetcommand: begin
    command1:= pifiwidgetcommandty(adatapo)^;
    result:= widgetcommandreceived(atag,aname,command1);
   end;
   ik_widgetproperties: begin
    result:= widgetpropertiesreceived(atag,aname,pifibytesty(adatapo));     
   end;
   else begin
    result:= inherited processdataitem(adata,adatapo,atag,aname);
   end;
  end;
 end;
end;

function tformlink.widgetcommandreceived(const atag: integer;
             const aname: string; const acommand: ifiwidgetcommandty): boolean;
var
 wi1: tvaluewidgetlink;
begin
 wi1:= tvaluewidgetlink(fvalues.finditem(aname));
 result:= wi1 <> nil;
 if result and (wi1.fcomponent <> nil) then begin
  with wi1.widget do begin
   case acommand of
    iwc_enable: begin
     enabled:= true;
    end;
    iwc_disable: begin
     enabled:= false;
    end;
    iwc_show: begin
     visible:= true;
    end;
    iwc_hide: begin
     visible:= false;
    end;
   end;
  end;
 end;    
end;

function tformlink.widgetpropertiesreceived(const atag: integer;
                     const aname: string; const adata: pifibytesty): boolean;
var
 wi1: tvaluewidgetlink;
 stream1: tmemorystream;
begin
 wi1:= tvaluewidgetlink(fvalues.finditem(aname));
 result:= wi1 <> nil;
 if result and (wi1.fcomponent <> nil) then begin
  stream1:= tmemorycopystream.create(@adata^.data,adata^.length);
  try
   stream1.readcomponent(wi1.fcomponent);
  finally
   stream1.free;
  end;
 end;
end;

procedure tformlink.valuechanged(const sender: iifiwidget);
var
 int1: integer;
begin
 if hasconnection then begin
  with tvaluewidgetlinks(fvalues ) do begin
   for int1:= 0 to high(fitems) do begin
    with tvaluewidgetlink(fitems[int1]) do begin
     if fupdatelock = 0 then begin
      if (fintf = sender) then begin
       if iwlo_sendvalue in options then begin
        sendvalue(fvalueproperty);
       end;
       break;
      end;
     end;
    end;
   end;
  end;
 end;
end;

procedure tformlink.sendmodalresult(const sender: iifiwidget; 
                                         const amodalresult: modalresultty);
var
 int1: integer;
begin
 if hasconnection then begin
  with tvaluewidgetlinks(fvalues ) do begin
   for int1:= 0 to high(fitems) do begin
    with tvaluewidgetlink(fitems[int1]) do begin
     if fupdatelock = 0 then begin
      if (fintf = sender) then begin
       if iwlo_sendmodalresult in options then begin
        sendmodalresult(amodalresult);
       end;
       break;
      end;
     end;
    end;
   end;
  end;
 end;
end;

procedure tformlink.statechanged(const sender: iifiwidget;
                             const astate: ifiwidgetstatesty);
var
 int1: integer;
 states1: ifiwidgetstatesty;
begin
 if hasconnection then begin
  with tvaluewidgetlinks(fvalues ) do begin
   for int1:= 0 to high(fitems) do begin
    with tvaluewidgetlink(fitems[int1]) do begin
     if (fintf = sender) then begin
      if options * widgetstateoptionsty <> [] then begin
       states1:= ifiwidgetstatesty(longword(fwidgetstatebefore) xor 
                                 longword(astate));
       if (iws_visible in states1) and 
           ((iwlo_sendshow in options) and (iws_visible in astate) or
             (iwlo_sendhide in options) and not (iws_visible in astate)) or
          (iws_focused in states1) and 
           ((iwlo_sendfocus in options) and (iws_focused in astate) or
             (iwlo_senddefocus in options) and not(iws_focused in astate)) or           
          (iws_active in states1) and 
           ((iwlo_sendactivate in options) and (iws_active in astate) or
             (iwlo_senddeactivate in options) and not(iws_active in astate))
                                                                     then begin
        sendstate(astate);
       end;
      end;
      fwidgetstatebefore:= astate;
      break;
     end;
    end;
   end;
  end;
 end;
end;

{ tifiwidgetgridcontroller }

constructor tifiwidgetgridcontroller.create(const aowner: trxwidgetgrid);
begin
 inherited create(aowner);
end;

procedure tifiwidgetgridcontroller.setowneractive(const avalue: boolean);
begin
 trxwidgetgrid(fowner).active:= avalue;
end;

function tifiwidgetgridcontroller.encodegriddata(
                     const asequence: sequencety): ansistring;
var
 po1,po4: pchar;
 int1,int2,int3,int4: integer;
 po2: pmsestring;
 po3: pansistring;
 ar1: booleanarty;
begin
 with trxwidgetgrid(fowner) do begin
  setlength(ar1,datacols.count);
  int2:= 0;
  for int1:= 0 to datacols.count - 1 do begin
   with datacols[int1] do begin
    ar1[int1]:= (name <> '') and (datalist <> nil) and 
                               (datalist.datatyp in ifidatatypes);
    if ar1[int1] then begin
     int2:= int2 + (sizeof(datatypty)+1) + length(name) + 
                       datalisttoifidata(datalist);
    end;
   end;
  end;
  inititemheader(result,ik_griddata,asequence,int2,po1);
  with pgriddatadataty(po1)^ do begin
   rows:= rowcount;
   cols:= datacols.count;
   po1:= @data;
   for int1:= 0 to high(ar1) do begin
    if ar1[int1] then begin
     with datacols[int1] do begin
      with pcoldataty(po1)^ do begin
       kind:= datalist.datatyp;
       po1:= @name;   
      end;
      inc(po1,stringtoifiname(name,pifinamety(po1)));
      datalisttoifidata(datalist,po1);
     end;
    end;
   end;
  end;
 end;
end;

procedure tifiwidgetgridcontroller.processdata(const adata: pifirecty;
               var adatapo: pchar);
var
 int1: integer;
 rows1,cols1: integer;
 kind1: datatypty;
 po1: pchar;
 str1: ansistring;
 po2: pointer;
 col1: tdatacol;
 list1: tdatalist;
begin
 with adata^.header do begin
  case kind of
   ik_griddata: begin
    if answersequence = fdatasequence then begin
     with trxwidgetgrid(fowner) do begin
      beginupdate;
      try
       with pgriddatadataty(adatapo)^ do begin
        rows1:= rows;
        rowcount:= rows1;
        cols1:= cols;
        po1:= @data;
       end;
       for int1:= 0 to cols1 - 1 do begin
        with pcoldataty(po1)^ do begin
         kind1:= kind;
         po1:= @name;
         inc(po1,ifinametostring(pifinamety(po1),str1));
         col1:= datacols.colbyname(str1);
         if col1 <> nil then begin
          list1:= col1.datalist;
         end
         else begin
          list1:= nil;
         end;
         inc(po1,ifidatatodatalist(kind1,rows1,po1,list1));
        end;
       end;
       include(fistate,rws_datareceived);
      finally
       endupdate;
      end;
     end;
    end;
   end;
  end;
 end;
end;

function tifiwidgetgridcontroller.getifireckinds: ifireckindsty;
begin
 result:= [ik_griddata];
end;

{ trxwidgetgrid }

constructor trxwidgetgrid.create(aowner: tcomponent);
begin
 fifi:= tifiwidgetgridcontroller.create(self);
 inherited;
end;

destructor trxwidgetgrid.destroy;
begin
 inherited;
 fifi.free;
end;

procedure trxwidgetgrid.setifi(const avalue: tifiwidgetgridcontroller);
begin
 fifi.assign(avalue);
end;

procedure trxwidgetgrid.setactive(const avalue: boolean);
begin
 if avalue <> factive then begin
  if avalue then begin
   if csloading in componentstate then begin
    include(fistate,rws_openpending);
   end
   else begin
    try
     internalopen;
    except
     active:= false;
     raise;
    end;
    factive:= true;
   end;
  end
  else begin
   exclude(fistate,rws_openpending);
   internalclose;
   factive:= false;
  end;
 end;
end;

procedure trxwidgetgrid.loaded;
begin
 inherited;
 if rws_openpending in fistate then begin
  exclude(fistate,rws_openpending);
  active:= true;
 end;
 fifi.loaded;
end;

procedure trxwidgetgrid.internalopen;
var
 str1: string;
 po1: pchar;
begin
 with fifi do begin
  if (channel <> nil) or 
    not ((csdesigning in componentstate) and 
         (irxo_useclientchannel in foptions)) then begin
   inititemheader(str1,ik_requestopen,0,0,po1);
   include(fistate,rws_openpending);
   if senddataandwait(str1,fdatasequence) and 
              (rws_datareceived in fistate) then begin
   end
   else begin
    sysutils.abort;
   end;
  end;
 end;
end;

procedure trxwidgetgrid.post;
begin
 with fifi do begin
  if (channel <> nil) or 
    not ((csdesigning in componentstate) and 
         (irxo_useclientchannel in foptions)) then begin
   senddata(encodegriddata(0));
  end;
 end;
end;

procedure trxwidgetgrid.internalclose;
begin
 rowcount:= 0;
end;

end.

unit msedockpanelform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 classes,mselist,msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,
 msemenus,msegui,msedatalist,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedock,
 msestrings,msestatfile;

type
 tdockpanelcontroller = class;
 
 tdockpanelform = class(tdockformwidget)
  private
   fmenuitem: tmenuitem;
   fnameindex: integer; //0 for unnumbered
   fcontroller: tdockpanelcontroller;
   procedure showexecute(const sender: tobject);
  protected
   procedure updatecaption(acaption: msestring);
   procedure doonclose; override;
   procedure dolayoutchanged(const sender: tdockcontroller); override;
   class function hasresource: boolean; override;
   class function getmoduleclassname: string; override;
   constructor docreate(aowner: tcomponent); override;
  public
   constructor create(aowner: tcomponent; load: boolean); override;
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   function canclose(const newfocus: twidget): boolean; override;
 end;

 panelfoclassty = class of tdockpanelform;
 
 dockpanelupdatecaptioneventty = 
     procedure(const sender: tdockpanelcontroller; const apanel: tdockpanelform;
                                  var avalue: msestring) of object;
 dockpanelupdatemenueventty = 
     procedure(const sender: tdockpanelcontroller; const apanel: tdockpanelform;
                                  const avalue: tmenuitem) of object;
 createpaneleventty =
     procedure(const sender: tdockpanelcontroller; 
                                  const apanel: tdockpanelform) of object;
 getpanelclasseventty =
     procedure(const sender: tdockpanelcontroller; 
                                  var aclass: panelfoclassty) of object;

 tdockpanelcontroller = class(tmsecomponent,istatfile)
  private
   fpanellist: tpointerlist;
   fmenu: tcustommenu;
   fstatfile: tstatfile;
   fstatvarname: msestring;
   fmenunamepath: string;
   fonupdatecaption: dockpanelupdatecaptioneventty;
   fonupdatemenu: dockpanelupdatemenueventty;
   fstatfileclient: tstatfile;
   foncreatepanel: createpaneleventty;
   fongetpanelclass: getpanelclasseventty;
   procedure updatestat(const filer: tstatfiler);
   procedure setmenu(const avalue: tcustommenu);
   procedure setstatfile(const avalue: tstatfile);
   procedure setstatfileclient(const avalue: tstatfile);
  protected
    //istatfile
   procedure dostatread(const reader: tstatreader); virtual;
   procedure dostatwrite(const writer: tstatwriter); virtual;
   procedure statreading;
   procedure statread;
   function getstatvarname: msestring;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   function newpanel(aname: string = ''): tdockpanelform;
  published
   property menu: tcustommenu read fmenu write setmenu;
   property statfile: tstatfile read fstatfile write setstatfile;
   property statvarname: msestring read getstatvarname write fstatvarname;
   property statfileclient: tstatfile read fstatfileclient 
                                                     write setstatfileclient;
   property menunamepath: string read fmenunamepath write fmenunamepath;
                      //delimiter = '.'
   property onupdatecaption: dockpanelupdatecaptioneventty 
                     read fonupdatecaption write fonupdatecaption;
   property onupdatemenu: dockpanelupdatemenueventty 
                     read fonupdatemenu write fonupdatemenu;
   property oncreatepanel: createpaneleventty read foncreatepanel 
                                                      write foncreatepanel;
   property ongetpanelclass: getpanelclasseventty read fongetpanelclass 
                                                     write fongetpanelclass;
 end;
 
function createdockpanelform(const aclass: tclass; 
                    const aclassname: pshortstring): tmsecomponent;

implementation
uses
 {msedockpanelform_mfm,}sysutils,msekeyboard,mseactions;
type
 tcomponent1 = class(tcomponent);
 tmsecomponent1 = class(tmsecomponent);
 
function createdockpanelform(const aclass: tclass; 
                    const aclassname: pshortstring): tmsecomponent;

begin
 result:= tmsecomponent(aclass.newinstance);
 tcomponent1(result).setdesigning(true); //used for wo_groupleader
 tdockpanelform(result).create(nil,false);
 tmsecomponent1(result).factualclassname:= aclassname;
end;

{ tdockpanelcontroller }
constructor tdockpanelcontroller.create(aowner: tcomponent);
begin
 fpanellist:= tpointerlist.create;
 inherited;
end;

destructor tdockpanelcontroller.destroy;
begin
 inherited;
 freeandnil(fpanellist);
end;

procedure tdockpanelcontroller.updatestat(const filer: tstatfiler);
var
 ar1: msestringarty;
 int1: integer;
begin
 ar1:= nil;
 if filer.iswriter then begin
  setlength(ar1,fpanellist.count);
  for int1:= 0 to high(ar1) do begin
   ar1[int1]:= tdockpanelform(fpanellist[int1]).name;
  end;
 end;
 filer.updatevalue('panels',ar1);
 if not filer.iswriter then begin
  for int1:= fpanellist.count - 1 downto 0 do begin
   tdockpanelform(fpanellist[int1]).free;
  end;
  for int1:= 0 to high(ar1) do begin
   try
    newpanel(ar1[int1]);
   except
   end;
  end;
 end;
 if fstatfileclient <> nil then begin
  fstatfileclient.updatestat('clients',filer);
 end;
end;

function tdockpanelcontroller.newpanel(aname: string = ''): tdockpanelform;
var
 item1: tmenuitem;
 int1,int2: integer;
 ar1: integerarty;
 pacla1: panelfoclassty;
begin
 item1:= nil;
 int2:= 0;
 if fmenu <> nil then begin
  if fmenunamepath <> '' then begin
   item1:= fmenu.menu.itembynames(splitstring(fmenunamepath,'.'));
  end;
  if aname = '' then begin
   setlength(ar1,fpanellist.count);
   for int1:= 0 to high(ar1) do begin
    ar1[int1]:= tdockpanelform(fpanellist[int1]).fnameindex;
   end;
   sortarray(ar1);
   int2:= length(ar1);
   for int1:= 0 to high(ar1) do begin //find first gap
    if ar1[int1] <> int1 then begin
     int2:= int1;
     break;
    end;
   end;
  end
  else begin
   int2:= strtoint(copy(aname,6,bigint))-1;
  end;
 end;
 pacla1:= tdockpanelform;
 if canevent(tmethod(fongetpanelclass)) then begin
  fongetpanelclass(self,pacla1);
 end;
 result:= pacla1.create(self);
 int1:= int2 + 1;
 if aname = '' then begin
  aname:= 'panel'+inttostr(int1);
 end;
 with result do begin
  name:= aname;
  fnameindex:= int2;
  if item1 <> nil then begin
   fmenuitem:= tmenuitem.create(nil,nil);
  end;
  updatecaption('');
 end;
 if int2 > item1.count - 2 then begin
  int2:= item1.count - 2;
 end;
 if item1 <> nil then begin
  item1.submenu.insert(int2,result.fmenuitem);
 end;
 if canevent(tmethod(foncreatepanel)) then begin
  foncreatepanel(self,result);
 end;
end;

procedure tdockpanelcontroller.setmenu(const avalue: tcustommenu);
begin
 setlinkedvar(avalue,tmsecomponent(fmenu));
end;

procedure tdockpanelcontroller.setstatfile(const avalue: tstatfile);
begin
 setstatfilevar(istatfile(self),avalue,fstatfile);
end;

procedure tdockpanelcontroller.dostatread(const reader: tstatreader);
begin
 updatestat(reader);
end;

procedure tdockpanelcontroller.dostatwrite(const writer: tstatwriter);
begin
 updatestat(writer);
end;

procedure tdockpanelcontroller.statreading;
begin
end;

procedure tdockpanelcontroller.statread;
begin
end;

function tdockpanelcontroller.getstatvarname: msestring;
begin
 result:= fstatvarname;
end;

procedure tdockpanelcontroller.setstatfileclient(const avalue: tstatfile);
begin
 setlinkedvar(avalue,tmsecomponent(fstatfileclient));
end;

{ tdockpanelform }

constructor tdockpanelform.create(aowner: tcomponent);
begin
 if aowner is tdockpanelcontroller then begin
  setlinkedvar(tmsecomponent(aowner),tmsecomponent(fcontroller));
 end;
 inherited;
end;

constructor tdockpanelform.create(aowner: tcomponent; load: boolean);
begin
 include(fmsecomponentstate,cs_ismodule);
 inherited;
end;

constructor tdockpanelform.docreate(aowner: tcomponent);
begin
 inherited;
 visible:= false;
 createframe;
 dragdock.optionsdock:= dragdock.optionsdock + 
       [od_canmove,od_canfloat,od_candock,od_acceptsdock,od_dockparent,
        od_splitvert,od_splithorz,od_tabed,od_proportional,od_propsize];
 options:= (options - [fo_autoreadstat,fo_autowritestat]) + 
                      [fo_globalshortcuts,fo_screencentered];
 optionswidget:= (optionswidget - [ow_destroywidgets]) + 
                  [ow_mousefocus,ow_arrowfocusin,ow_arrowfocusout];
 frame.grip_options:= frame.grip_options + 
     [go_fixsizebutton,go_topbutton,go_backgroundbutton,go_lockbutton];
 size:= makesize(350,200);
 if fcontroller <> nil then begin
  statfile:= fcontroller.statfileclient;
  fcontroller.fpanellist.add(self);
 end;
end;

destructor tdockpanelform.destroy;
begin
 if fcontroller <> nil then begin
  with fcontroller do begin
   if fpanellist <> nil then begin
    fpanellist.remove(self);
   end;
   if (fmenuitem <> nil) and (fmenuitem.owner <> nil) and 
             not (csdestroying in fmenuitem.owner.componentstate) then begin
    fmenuitem.parentmenu.submenu.delete(fmenuitem.index);
   end;
  end;
 end;
 inherited;
end;

procedure tdockpanelform.updatecaption(acaption: msestring);
begin
 if acaption = '' then begin
  acaption:= 'Panel';
 end;
 with fmenuitem do begin
  onexecute:= {$ifdef FPC}@{$endif}showexecute;
  if fnameindex < 9 then begin
   shortcut:= (ord(key_f1) or key_modctrl) + fnameindex;
   acaption:= acaption + ' &' + inttostr(fnameindex+1);
  end
  else begin
   shortcut:= 0;
  end;
  caption:= acaption;
  if (fcontroller <> nil) and 
                 fcontroller.canevent(tmethod(fcontroller.fonupdatemenu)) then begin
   fcontroller.fonupdatemenu(fcontroller,self,fmenuitem);
  end;
  if shortcut <> 0 then begin
   acaption:= acaption + ' ('+encodeshortcutname(shortcut)+')';
//   acaption:= acaption + ' (Ctrl+F' + inttostr(fnameindex+1)+')';
  end;
  if (fcontroller <> nil) and 
            fcontroller.canevent(tmethod(fcontroller.fonupdatecaption)) then begin
   fcontroller.fonupdatecaption(fcontroller,self,acaption);
  end;
  self.caption:= acaption;
 end;
end;

procedure tdockpanelform.showexecute(const sender: tobject);
begin
 activate;
end;

function tdockpanelform.canclose(const newfocus: twidget): boolean;

 function containerempty: boolean;
 var
  int1: integer;
 begin
  result:= container.widgetcount = 0;
  if not result then begin
   for int1:= 0 to container.widgetcount - 1 do begin
    if container.widgets[int1].visible then begin
     exit;
    end;
   end;
  end;
  result:= true;
 end;
 
begin
 result:= inherited canclose(newfocus);
 {
 if result and (newfocus = nil) and containerempty then begin
  release;
 end;
 }
end;

procedure tdockpanelform.doonclose;
 function containerempty: boolean;
 var
  int1: integer;
 begin
  result:= container.widgetcount = 0;
  if not result then begin
   for int1:= 0 to container.widgetcount - 1 do begin
    if container.widgets[int1].visible then begin
     exit;
    end;
   end;
  end;
  result:= true;
 end;
begin
 inherited;
 if containerempty then begin
  release;
 end;
end;

procedure tdockpanelform.dolayoutchanged(const sender: tdockcontroller);
var
 intf1: idocktarget;
 mstr1: msestring;
 int1: integer;
 ar1: widgetarty;
begin
 mstr1:= '';
 ar1:= sender.getitems;
 for int1:= 0 to high(ar1) do begin
  if ar1[int1].getcorbainterface(typeinfo(idocktarget),intf1) then begin
   mstr1:= mstr1 + intf1.getdockcontroller.getdockcaption+',';
  end;
 end;
 updatecaption(copy(mstr1,1,length(mstr1)-1)); //remove last comma
end;

class function tdockpanelform.hasresource: boolean;
begin
 result:= self <> tdockpanelform;
end;

class function tdockpanelform.getmoduleclassname: string;
begin
 result:= 'tdockpanelform';
end;

end.

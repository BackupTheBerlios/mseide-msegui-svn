{ MSEgui Copyright (c) 2010 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit msemidi;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msestream,classes,mseclasses,sysutils,msestrings,msetimer;

const 
 defaultmidimaxdatasize = 1000000;
 defaulttimescaleus = 1000000/(120);
 endoftrack = 47;
 
type
 midierrorty = (em_ok,em_nostream,em_fileformat,em_notrack);

 emidiexception = class(exception);
 
 idstringty = array[0..3] of char;
 midichunkheaderty = record
  id: idstringty;
  size: longword;
 end;

 midichunkty = record
  header: midichunkheaderty;
  data: record //variable
  end;
 end;
  
 midifileheaderty = record
  formattype: word;
  numberoftracks: word;
  timedivision: word;
 end;

 midimessagekindty = (mmk_none,mmk_noteoff,mmk_noteon,mmk_noteaftertouch,
                      mmk_controller,mmk_programchange,mmk_channelaftertouch,
                      mmk_pitchbend,mmk_system);
type
 trackeventinfoty = record
  delta: longword; //microseconds
  kind: midimessagekindty;
  channel: byte;
  par1: byte;
  par2: byte;
 end;
  
 tmidistream = class(tbufstream)
  private
   ftrackcount: integer;
   fticktime : integer;
   ftracksize: longword;
//   ftrackpo: longword;
   fmetadata: string;
   fstatus: byte;
   fmaxdatasize: longword;
   ftimescaleus: real;
   ftimesum: real;
  protected
   function readtrackbyte(out adata: byte): boolean;
   function readtrackdatabyte(out adata: byte): boolean; //check bit 7
   function readtrackword(out adata: word): boolean;
   function readtracklongword(out adata: word): boolean;
   function readtrackdata(out adata; const acount: integer): boolean;
   function readtrackvarlength(out adata: longword): boolean;

   function readbyte(out adata: byte): boolean;
   function readword(out adata: word): boolean;
   function readlongword(out adata: word): boolean;
//   function readvarlength(out adata: longword): boolean;
   function readchunkheader(out adata: midichunkheaderty): boolean;

   function checkchunkheader(const aid: idstringty;
                                         const asize: integer): boolean;
   function readfileheader(out adata: midifileheaderty): boolean;
   function skip(const adist: longword): boolean;
  public
   constructor create(ahandle: integer); override;
   function initfile: boolean;
   function starttrack: boolean;
   function skiptrack: boolean;
   function readtrackevent(out adata: trackeventinfoty): boolean;
   property metadata: string read fmetadata;
   property maxdatasize: longword read fmaxdatasize write fmaxdatasize 
                         default defaultmidimaxdatasize;
   property timescaleus: real read ftimescaleus; //miditicks to microseconds
 end;

 trackeventty = procedure(const sender: tobject;
                         var ainfo: trackeventinfoty) of object;

 midisourcestatety = (mss_inited,mss_endoftrack);
 midisourcestatesty = set of midisourcestatety;
                          
 tmidisource = class(tmsecomponent)
  private
   fstream: tmidistream;
   factive: boolean;
   fontrackevent: trackeventty;
   fstarttime: longword;
   feventtime: longword;
   ftimer: tsimpletimer;
   procedure setstream(const avalue: tmidistream);
   procedure setactive(const avalue: boolean);
  protected
   fstate: midisourcestatesty;
   ftrackevent: trackeventinfoty;
   procedure error(const aerror: midierrorty);
   procedure start;
   procedure stop;
   function checkresult(const aresult: boolean;
                       const aerror: midierrorty): boolean; inline;
   procedure processevent;
   procedure dotrackevent;
   procedure dotimer(const sender: tobject);
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   property active: boolean read factive write setactive;
   property stream: tmidistream read fstream write setstream;
                                //owns the stream
  published
   property ontrackevent: trackeventty read fontrackevent write fontrackevent;
 end;
  
implementation
uses
 msesysutils,msegui; 
const
 errormessages: array[midierrorty] of msestring = (
  '',
  'No midi stream',
  'No midi file.',
  'No track found.'
  );
  
 messagetable: array[0..7] of midimessagekindty = (
  mmk_noteoff,              //8c
  mmk_noteon,               //9c
  mmk_noteaftertouch,       //ac
  mmk_controller,           //bc
  mmk_programchange,        //cc
  mmk_channelaftertouch,    //dc
  mmk_pitchbend,            //ec
  mmk_system);              //fx

 parcount: array[midimessagekindty] of integer = (
 // mmk_none,mmk_noteoff,mmk_noteon,mmk_noteaftertouch,
    0,       2,          2,         2,
 // mmk_controller,mmk_programchange,mmk_channelaftertouch,
    2,             1,                1,
 // mmk_pitchbend,mmk_system
    2,            0);

function swap(const avalue: word): word; inline;
begin
 result:= (avalue shl 8) or (avalue shr 8);
end;

procedure swap1(var avalue: word); inline;
begin
 avalue:= (avalue shl 8) or (avalue shr 8);
end;

function swap(const avalue: longword): longword; inline;
begin
 result:= (swap(word(avalue)) shl 16) or swap(word(avalue shr 16));
end;

procedure swap1(var avalue: longword); inline;
begin
 avalue:= (swap(word(avalue)) shl 16) or swap(word(avalue shr 16));
end;
 
{ tmidistream }

constructor tmidistream.create(ahandle: integer);
begin
 fmaxdatasize:= defaultmidimaxdatasize;
 ftimescaleus:= defaulttimescaleus;
 inherited;
end;

function tmidistream.readbyte(out adata: byte): boolean;
begin
 result:= read(adata,sizeof(adata)) = sizeof(adata);
end;

function tmidistream.readword(out adata: word): boolean;
begin
 result:= read(adata,sizeof(adata)) = sizeof(adata);
 swap1(adata);
end;

function tmidistream.readlongword(out adata: word): boolean;
begin
 result:= read(adata,sizeof(adata)) = sizeof(adata);
 swap1(adata);
end;

function tmidistream.readtrackbyte(out adata: byte): boolean;
var
 int1: integer;
begin
 result:= ftrackcount >= sizeof(adata);
 if result then begin
  int1:= read(adata,sizeof(adata));
  ftrackcount:= ftrackcount - int1;
  result:= int1 = sizeof(adata);
 end;
end;

function tmidistream.readtrackdatabyte(out adata: byte): boolean;
begin
 result:= readtrackbyte(adata);
 if result and (adata and $80 <> 0) then begin
  result:= false;
  fstatus:= adata; //try to resync
 end;
end;

function tmidistream.readtrackword(out adata: word): boolean;
var
 int1: integer;
begin
 result:= ftrackcount >= sizeof(adata);
 if result then begin
  int1:= read(adata,sizeof(adata));
  ftrackcount:= ftrackcount - int1;
  result:= int1 = sizeof(adata);
  if result then begin
   swap1(adata);
  end;
 end;
end;

function tmidistream.readtracklongword(out adata: word): boolean;
var
 int1: integer;
begin
 result:= ftrackcount >= sizeof(adata);
 if result then begin
  int1:= read(adata,sizeof(adata));
  ftrackcount:= ftrackcount - int1;
  result:= int1 = sizeof(adata);
  if result then begin
   swap1(adata);
  end;
 end;
end;

function tmidistream.readtrackdata(out adata; const acount: integer): boolean;
var
 int1: integer;
begin
 result:= ftrackcount >= acount;
 if result then begin
  int1:= read(adata,acount);
  ftrackcount:= ftrackcount - int1;
  result:= int1 = acount;
 end;
end;

function tmidistream.readchunkheader(out adata: midichunkheaderty): boolean;
begin
 result:= read(adata,sizeof(adata)) = sizeof(adata);
 swap1(adata.size);
end;

function tmidistream.checkchunkheader(const aid: idstringty;
               const asize: integer): boolean;
var
 header1: midichunkheaderty;
begin
 result:= readchunkheader(header1) and (header1.size = asize) and
                     (header1.id = aid);
end;

function tmidistream.readfileheader(out adata: midifileheaderty): boolean;
begin
 result:= checkchunkheader('MThd',6);
 if result then begin
  result:= read(adata,sizeof(adata)) = sizeof(adata);
  if result then begin
   with adata do begin
    swap1(formattype);
    swap1(numberoftracks);
    swap1(timedivision);
   end;
  end;
 end;
end;

function tmidistream.initfile: boolean;
var
 header: midifileheaderty;
begin
 result:= readfileheader(header);
 if result then begin
  with header do begin
   ftrackcount:= numberoftracks;
   fticktime:= timedivision;
  end;
 end;
end;

function tmidistream.starttrack: boolean;
var
 header: midichunkheaderty;
begin
 repeat
  result:= readchunkheader(header);
  if result then begin
   with header do begin
    ftracksize:= header.size;
    if id = 'MTrk' then begin
     ftrackcount:= ftracksize;
     break;
    end;
    result:= skip(ftracksize);
   end;
  end;
 until not result;
end;

function tmidistream.skiptrack: boolean;
var
 header: midichunkheaderty;
begin
 repeat
  result:= readchunkheader(header);
  if result then begin
   with header do begin
    ftracksize:= header.size;
    if id = 'MTrk' then begin
     result:= skip(ftracksize);
     break;
    end;
    result:= skip(ftracksize);
   end;
  end;
 until not result;
end;


function tmidistream.skip(const adist: longword): boolean;
var
 lint1: int64;
begin
 lint1:= position;
 result:= seek(adist,socurrent)-lint1 = adist;
end;

function tmidistream.readtrackvarlength(out adata: longword): boolean;
var
 by1: byte;  
begin
 result:= true;
 adata:= 0;
 while result and (ftrackcount > 0) do begin
  dec(ftrackcount);
  result:= read(by1,1) = 1;
  adata:= (adata shl 7) or by1 and $7f;
  if by1 and $80 = 0 then begin
   break;
  end;
 end;
end;

function tmidistream.readtrackevent(out adata: trackeventinfoty): boolean;
var
 stat1: byte;
 lwo1: longword;
 rea1: real;
begin
 fillchar(adata,sizeof(adata),0);
 result:= readtrackvarlength(adata.delta);
 if not result then exit;

 if adata.delta <> 0 then begin
  ftimesum:= ftimesum + adata.delta*ftimescaleus;
  adata.delta:= round(ftimesum);
  ftimesum:= ftimesum - adata.delta;
 end;
   
 result:= readtrackbyte(stat1);
 if not result then exit;
 if (stat1 and $80) <> 0 then begin
  fstatus:= stat1;
  result:= readtrackdatabyte(adata.par1);
  if not result then exit;
 end
 else begin
  adata.par1:= stat1;
  stat1:= fstatus;
 end;
 adata.kind:= messagetable[(stat1 shr 4) and $7];
 if adata.kind = mmk_system then begin
  result:= readtrackvarlength(lwo1) and (lwo1 <= fmaxdatasize);
  if not result then exit;
  setlength(fmetadata,lwo1); 
  if lwo1 > 0 then begin
   result:= readtrackdata(pointer(fmetadata)^,lwo1);
  end;
 end
 else begin
  adata.channel:= stat1 and $0f;
  if parcount[adata.kind] > 1 then begin
   result:= readtrackdatabyte(adata.par2);
  end;
 end;
end;

{ tmidisource }

constructor tmidisource.create(aowner: tcomponent);
begin
 inherited;
 ftimer:= tsimpletimer.create(0,@dotimer,false,
                     [to_single,to_absolute,to_autostart]);
end;

destructor tmidisource.destroy;
begin
 stream:= nil;
 ftimer.free;
 inherited;
end;

function tmidisource.checkresult(const aresult: boolean;
               const aerror: midierrorty): boolean;
begin
 result:= aresult;
 if not aresult then begin
  error(aerror);
 end;
end;

procedure tmidisource.setstream(const avalue: tmidistream);
begin
 active:= false;
 fstream.free;
 fstream:= avalue;
end;

procedure tmidisource.setactive(const avalue: boolean);
begin
 if factive <> avalue then begin
  factive:= avalue;
  if avalue then begin
   start;
  end
  else begin
   stop;
  end;
 end;
end;

procedure tmidisource.error(const aerror: midierrorty);
begin
 raise emidiexception.create(self.name+': '+errormessages[aerror]);
end;

procedure tmidisource.dotrackevent;
begin
end;

procedure tmidisource.dotimer(const sender: tobject);
begin
 dotrackevent;
 processevent;
msegui.beep;
end;

procedure tmidisource.processevent;
begin
 repeat
  if fstream.readtrackevent(ftrackevent) then begin
   with ftrackevent do begin
    case kind of
     mmk_noteoff,mmk_noteon: begin     
      if delta = 0 then begin
       dotrackevent;
      end
      else begin
       feventtime:= feventtime + delta;
       ftimer.interval:= feventtime;
       break;
      end;
     end;
     mmk_system: begin
      if par1 = endoftrack then begin
       include(fstate,mss_endoftrack);
       break;
      end;
     end;
    end;
   end;
  end;
 until fstream.eof;
end;

procedure tmidisource.start;
begin
 if fstream = nil then begin
  error(em_nostream);
 end;
 if checkresult(fstream.initfile,em_fileformat) then begin
  if checkresult(fstream.skiptrack,em_notrack) and
//     checkresult(fstream.skiptrack,em_notrack) and
           checkresult(fstream.starttrack,em_notrack)then begin
   fstarttime:= timestamp;
   feventtime:= fstarttime;
   processevent;
  end;
 end;
end;

procedure tmidisource.stop;
begin
 ftimer.enabled:= false;
end;

end.

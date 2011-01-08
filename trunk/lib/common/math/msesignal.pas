{ MSEgui Copyright (c) 2010-2011 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}

//
// todo: optimize for realtime, remove the OOP approach where
// it degrades performance.
//

unit msesignal;
{$ifdef FPC}{$mode objfpc}{$h+}{$interfaces corba}{$endif}
interface
uses
 msedatalist,mseclasses,classes,msetypes,msearrayprops,mseevent,msehash,
 msesys,msereal,msetimer,mseglob;
 
const
 defaultsamplefrequ = 44100; //Hz
 defaulttickdiv = 200;
 defaultsamplecount = 4096;
 defaultharmonicscount = 16;
 functionsegmentcount = 32;

const
 semitoneln = ln(2)/12;
 chromaticscale: array[0..12] of double =
    (1.0,exp(1*semitoneln),exp(2*semitoneln),exp(3*semitoneln),exp(4*semitoneln),
     exp(5*semitoneln),exp(6*semitoneln),exp(7*semitoneln),exp(8*semitoneln),
     exp(9*semitoneln),exp(10*semitoneln),exp(11*semitoneln),2.0);

type
 tcustomsigcomp = class;
 tdoublesigcomp = class;
 tsigcontroller = class;
 
 tcustomsigcomp = class(tmsecomponent)  
  protected
   fupdating: integer;
   procedure coeffchanged(const sender: tdatalist;
                                 const aindex: integer); virtual;
   procedure update; virtual;
  public
   procedure beginupdate;
   procedure endupdate;
 end;

 tsigcomp = class(tcustomsigcomp)
  
 end;

 tdoubleinputconn = class;
 tdoubleoutputconn = class;
 
 inputconnarty = array of tdoubleinputconn;
 outputconnarty = array of tdoubleoutputconn;
 
 psighandlerinfoty = ^sighandlerinfoty;
 sighandlerprocty = procedure(const ainfo: psighandlerinfoty) of object;

 psiginfoty = ^siginfoty;
 sigclientinfoty = record
  infopo: psiginfoty;
 end;
 psigclientinfoty = ^sigclientinfoty;

 sigclientoptionty = (sco_tick);
 sigclientoptionsty = set of sigclientoptionty;
   
 isigclient = interface(ievent)
  procedure initmodel;
  procedure clear;
  function getinputar: inputconnarty;
  function getoutputar: outputconnarty;
  function gethandler: sighandlerprocty;
  function getzcount: integer;
  function getcomponent: tcomponent;
  procedure modelchange;
  function getsigcontroller: tsigcontroller;
  function getsigclientinfopo: psigclientinfoty;
  function getsigoptions: sigclientoptionsty;
  procedure sigtick;
 end;
 sigclientintfarty = array of isigclient;

 tdoublesigcomp = class(tsigcomp,isigclient)
  private
   fsigclientinfo: sigclientinfoty;
   procedure setcontroller(const avalue: tsigcontroller);
  protected
   fcontroller: tsigcontroller;
   procedure modelchange;
   procedure loaded; override;
   procedure lock;
   procedure unlock;
   
    //isigclient  
   procedure initmodel; virtual;
   procedure sigtick; virtual;
   function getinputar: inputconnarty; virtual;
   function getoutputar: outputconnarty; virtual;
   function gethandler: sighandlerprocty; virtual; abstract;
   function getzcount: integer; virtual;
   function getsigcontroller: tsigcontroller;
   function getsigclientinfopo: psigclientinfoty;
   function getsigoptions: sigclientoptionsty; virtual;
   procedure lockapplication;  //releases controller lock, can not be nested,
                               //call from locked signal thread only
   procedure unlockapplication;//acquires controller lock
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   procedure clear; virtual;
  published
   property controller: tsigcontroller read fcontroller write setcontroller;
 end;
 
 tsigconn = class(tmsecomponent)
        //no solution found to link to streamed tpersistent or tobject,
        //fork of classes.pp necessary. :-(
 end;
 
 tdoubleconn = class(tsigconn) 
  protected
   fsigintf: isigclient;
   function getcontroller: tsigcontroller;
   procedure lock;
   procedure unlock;
  public
   constructor create(const aowner: tcomponent;
                     const asigintf: isigclient); reintroduce; virtual;
   property controller: tsigcontroller read getcontroller;
 end;

 valuescaleoptionty = (vso_exp,vso_null); //out:= 0 for inp <= 0
 valuescaleoptionsty = set of valuescaleoptionty;
 doublescaleinfoty = record
  value: double;
  min: double;
  max: double;
  options: valuescaleoptionsty;
  gain,offset: double;
 end;
 
 doubleinputconnarty = array of tdoubleinputconn;

 outputconnstatety = (ocs_eventdriven);
 outputconnstatesty = set of outputconnstatety;
  
 tdoubleoutputconn = class(tdoubleconn)
  protected
   fstate: outputconnstatesty;
   fdestinations: doubleinputconnarty;
   fvalue: double;
  public
   constructor create(const aowner: tcomponent;
         const asigintf: isigclient; const aeventdriven: boolean); 
                                                       reintroduce; virtual;
   property value: double read fvalue write fvalue;
 end; 

 tdoubleinputconn = class(tdoubleconn)
  private
   fsource: tdoubleoutputconn;
   foffset: double;
   fgain: double;
   procedure setsource(const avalue: tdoubleoutputconn);
   procedure setoffset(const avalue: double);
   procedure setgain(const avalue: double);
   procedure setvalue(const avalue: double); virtual;
  protected
   fvalue: double;
  public
   constructor create(const aowner: tcomponent;
                     const asigintf: isigclient); override;
   destructor destroy; override;
  published
   property source: tdoubleoutputconn read fsource write setsource;
   property offset: double read foffset write setoffset;
   property gain: double read fgain write setgain;
   property value: double read fvalue write setvalue;  
 end;

 tchangedoubleinputconn = class(tdoubleinputconn)
  private
   fonchange: notifyeventty;
  protected
   procedure setvalue(const avalue: double); override;
  public
   constructor create(const aowner: tcomponent; const asigintf: isigclient;
                      const aonchange: notifyeventty); reintroduce;
 end;
 
 sighandlerinfoty = record
  dest: pdouble;
 end;

 siginfopoarty = array of psiginfoty;
 signahdlerprocty = procedure(siginfo: psiginfoty);
 
 siginfostatety = (sis_checked,sis_eventchecked,sis_touched,
                   sis_input,sis_output{,sis_recursive});
 siginfostatesty = set of siginfostatety;
 
 inputstatety = (ins_checked,ins_recursive);
 inputstatesty = set of inputstatety;
 
 inputinfoty = record
  input: tdoubleinputconn;
  source: psiginfoty;
  state: inputstatesty;
 end;
 inputinfoarty = array of inputinfoty;
 
 sigdestinfoty = record
  outputindex: integer;
  destinput: tdoubleinputconn;
 end;
 sigdestinfoarty = array of sigdestinfoty;
 
 siginfoty = record
  intf: isigclient;
  handler: sighandlerprocty;
  zcount: integer;
  inputs: inputinfoarty;
  outputs: outputconnarty;
  destinations: sigdestinfoarty;
  eventdestinations: siginfopoarty;
  state: siginfostatesty;
  prev: siginfopoarty;
  connectedcount: integer;
  next: siginfopoarty;
 end;
 siginfoarty = array of siginfoty;
 
 destinfoty = record
  source: pdouble;
  dest: pdouble;
  offset: double;
  gain: double;
  hasscale: boolean;
 end;
 destinfoarty = array of destinfoty;
 
 sighandlernodeinfoty = record
  handlerinfo: sighandlerinfoty;
  handler: sighandlerprocty;
  firstdest: destinfoty;
  dest: destinfoarty;
  desthigh: integer;
 end;
 psighandlernodeinfoty = ^sighandlernodeinfoty;
 sighandlernodeinfoarty = array of sighandlernodeinfoty;
   
 tsigconnection = class(tdoublesigcomp)
 end;
 
 sigineventty = procedure(const sender: tobject;
                               var sig: real) of object; 
 siginbursteventty = procedure(const sender: tobject;
                               var sig: realarty) of object; 
 sigincomplexeventty = procedure(const sender: tobject;
                               var sig: complexty) of object; 
 sigincomplexbursteventty = procedure(const sender: tobject;
                               var sig: complexarty) of object; 

 tsigin = class(tsigconnection)
  private
   foutput: tdoubleoutputconn;
   fvalue: double;
   finp: doublearty;
   foninput: sigineventty;
   foninputburst: siginbursteventty;
   finpindex: integer;
   procedure setvalue(const avalue: double);
  protected
   function getoutputar: outputconnarty; override;
    //isigclient
   function gethandler: sighandlerprocty; override;
   procedure sighandler(const ainfo: psighandlerinfoty);
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy;
   procedure siginput(const asource: doublearty);
   procedure clear; override;
   property output: tdoubleoutputconn read foutput;
  published
   property value: double read fvalue write setvalue;
   property oninput: sigineventty read foninput write foninput;
   property oninputburst: siginbursteventty read foninputburst write foninputburst;
 end;

 sigouteventty = procedure(const sender: tobject;
                               const sig: real) of object; 
 sigoutbursteventty = procedure(const sender: tobject;
                               const sig: realarty) of object; 
                              
 tsigout = class(tsigconnection)
  private
   finput: tdoubleinputconn;
   finputpo: pdouble;
   fonoutput: sigouteventty;
   fvalue: double;
   fonoutputburst: sigoutbursteventty;
   foutp: doublearty;
   foutpindex: integer;
   fbuffersize: integer;
   procedure setinput(const avalue: tdoubleinputconn);
   function getinput: tdoubleinputconn;
   procedure setbuffersize(const avalue: integer);
   function getvalue: double;
  protected
   function getinputar: inputconnarty; override;
    //isigclient
   function gethandler: sighandlerprocty; override;
   procedure sighandler(const ainfo: psighandlerinfoty);
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   procedure clear; override;
   procedure sigoutput1(var adest: doublearty); //returns a data copy
   function sigoutput: doublearty;
   property value: double read getvalue;
  published
   property input: tdoubleinputconn read getinput write setinput;
   property buffersize: integer read fbuffersize 
                                              write setbuffersize default 0;
   property onoutput: sigouteventty read fonoutput write fonoutput;
   property onoutputburst: sigoutbursteventty read fonoutputburst 
                                              write fonoutputburst;
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
   constructor create(const aowner: tcustomsigcomp); reintroduce;
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
   function getinputar: inputconnarty; override;
   function getoutputar: outputconnarty; override;
   procedure setzcount(const avalue: integer);
   procedure zcountchanged; virtual;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   procedure clear; override;
   property zcount: integer read getzcount default 0;
   property output: tdoubleoutputconn read foutput write setoutput;
  published
   property input: tdoubleinputconn read finput write setinput;
 end;

 tdoubleinpconnarrayprop = class(tpersistentarrayprop)
  private
   fsigintf: isigclient;
   function getitems(const index: integer): tdoubleinputconn;
  protected
   procedure createitem(const index: integer; var item: tpersistent); override;
   procedure dosizechanged; override;
  public
   constructor create(const asigintf: isigclient); reintroduce;
   property items[const index: integer]: tdoubleinputconn read getitems; default;
 end;

 tdoubleoutconnarrayprop = class(tpersistentarrayprop)
  private
   function getitems(const index: integer): tdoubleoutputconn;
  protected
   fsigintf: isigclient;
   fname: string;
   fowner: tcomponent;
   feventdriven: boolean;
   procedure createitem(const index: integer; var item: tpersistent); override;
   procedure dosizechanged; override;
  public
   constructor create(const aowner: tcomponent; const aname: string;
           const asigintf: isigclient; const aeventdriven: boolean); reintroduce;
   property items[const index: integer]: tdoubleoutputconn read getitems; default;
 end;

 tsigmultiinp = class(tdoublesigcomp)
  private
   finputs: tdoubleinpconnarrayprop;
   procedure setinputs(const avalue: tdoubleinpconnarrayprop);
  protected
   finps: doublepoarty;
   finphigh: integer;
   function getinputar: inputconnarty; override;
   procedure initmodel; override;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
  published
   property inputs: tdoubleinpconnarrayprop read finputs write setinputs;
 end;

 tsigsampler = class;
 samplerbufferty = array of doublearty;
 samplerbufferfulleventty = procedure(const sender: tsigsampler;
                              const abuffer: samplerbufferty) of object;

 sigsampleroptionty = (sso_negtrig,
                       sso_fftmag); //used by tsigsamplerfft
 sigsampleroptionsty = set of sigsampleroptionty;

 tsigsampler = class(tsigmultiinp)
  private
   fbufferlength: integer;
   fbufpo: integer;
   ftrigger: tchangedoubleinputconn;
   ftriggerlevel: tchangedoubleinputconn;
   fonbufferfull: samplerbufferfulleventty;
   foptions: sigsampleroptionsty;
   ftimer: tsimpletimer;
   frefreshus: integer;
   procedure setbufferlength(const avalue: integer);
   procedure settrigger(const avalue: tchangedoubleinputconn);
   procedure settriggerlevel(const avalue: tchangedoubleinputconn);
   procedure setoptions(const avalue: sigsampleroptionsty);
   procedure setrefreshus(const avalue: integer);
  protected
   fnegtrig: boolean;
   fstarted: boolean;
   fstartpending: boolean;
   fpretrigger: boolean;
   frunning: boolean;
   fsigbuffer: samplerbufferty;
   procedure updateoptions(var avalue: sigsampleroptionsty); virtual;
   procedure dotimer(const sender: tobject);
   function gethandler: sighandlerprocty; override;
   procedure sighandler(const ainfo: psighandlerinfoty);
   procedure initmodel; override;
   function getinputar: inputconnarty; override;
   procedure dotriggerchange(const sender: tobject);
   procedure dobufferfull; virtual;
   procedure loaded; override;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   procedure clear; override;
   procedure start;
  published
   property bufferlength: integer read fbufferlength 
                          write setbufferlength default defaultsamplecount;
   property trigger: tchangedoubleinputconn read ftrigger write settrigger;
   property triggerlevel: tchangedoubleinputconn read ftriggerlevel 
                                              write settriggerlevel;
   property options: sigsampleroptionsty read foptions 
                                         write setoptions default [];
   property onbufferfull: samplerbufferfulleventty read fonbufferfull 
                                                         write fonbufferfull;
   property refreshus: integer read frefreshus write setrefreshus default -1;
                          //micro seconds, -1 -> off, 0 -> on idle
 end;
 
 tsigmultiinpout = class(tsigmultiinp)
  private
   foutput: tdoubleoutputconn;
    //local variables
//   dar: doublearty;
//   pdar: doublepoarty;
   procedure setoutput(const avalue: tdoubleoutputconn);
  protected
   function getoutputar: outputconnarty; override;
  public
   constructor create(aowner: tcomponent); override;
//   destructor destroy; override;
   property output: tdoubleoutputconn read foutput write setoutput;
 end;
 
 tsigadd = class(tsigmultiinpout)
  protected
//   procedure processinout(const acount: integer;
//             var ainp: doublepoarty; var aoutp: pdouble); override;
    //isigclient
   function gethandler: sighandlerprocty; override;
   procedure sighandler(const ainfo: psighandlerinfoty);
 end;

 tsigdelay = class(tsigadd)
  private
  protected
   fz: double;
   function getzcount: integer; override;
    //isigclient
   function gethandler: sighandlerprocty; override;
   procedure sighandler(const ainfo: psighandlerinfoty);
  public
   procedure clear; override;
 end;

 tsigdelayn = class(tsigadd)
  private
   fdelay: integer;
   finppo: integer;
   procedure setdelay(const avalue: integer);
  protected
   fz: doublearty;
   procedure initmodel; override;
   function getzcount: integer; override;
    //isigclient
   function gethandler: sighandlerprocty; override;
   procedure sighandler(const ainfo: psighandlerinfoty);
  public
   constructor create(aowner: tcomponent); override;
   procedure clear; override;
  published
   property delay: integer read fdelay write setdelay default 1;
 end;
  
 tdoublesigoutcomp = class(tdoublesigcomp)
  private
   foutput: tdoubleoutputconn;
   procedure setoutput(const avalue: tdoubleoutputconn);
  protected
   function getoutputar: outputconnarty; override;
  public
   constructor create(aowner: tcomponent); override;
   property output: tdoubleoutputconn read foutput write setoutput;
  published
 end;

 tdoublesiginoutcomp = class(tdoublesigoutcomp)
  private
   procedure setinput(const avalue: tdoubleinputconn);
  protected
   finput: tdoubleinputconn;
   finputpo: pdouble;
   function getinputar: inputconnarty; override;
  public
   constructor create(aowner: tcomponent); override;
  published
   property input: tdoubleinputconn read finput write setinput;
 end;

 tsigconnector = class(tdoublesiginoutcomp)
  protected
   function gethandler: sighandlerprocty; override;
   procedure sighandler(const ainfo: psighandlerinfoty);
 end;

 ttrigconnector = class(tsigconnector)
  public
   constructor create(aowner: tcomponent); override;
 end;

 tsigeventconnector = class(tdoublesigcomp)
 end;
 
 sigwavetableoptionty = (siwto_intpol);
 sigwavetableoptionsty = set of sigwavetableoptionty;
 
 tsigwavetable = class(tdoublesigoutcomp)
  private
   ffrequency: tdoubleinputconn;
   ffrequfact: tdoubleinputconn;
   fphase: tdoubleinputconn;
   famplitude: tdoubleinputconn;
   ftable: doublearty;
   ftablelength: integer;
   ftime: double;
   ffrequencypo: pdouble;
   ffrequfactpo: pdouble;
   fphasepo: pdouble;
   famplitudepo: pdouble;
   foninittable: siginbursteventty;
   foptions: sigwavetableoptionsty;
   fmaster: tsigwavetable;
   procedure setfrequency(const avalue: tdoubleinputconn);
   procedure setfrequfact(const avalue: tdoubleinputconn);
   procedure setphase(const avalue: tdoubleinputconn);
   procedure setamplitude(const avalue: tdoubleinputconn);
   procedure settable(const avalue: doublearty);
   procedure setoptions(const avalue: sigwavetableoptionsty);
   procedure setmaster(const avalue: tsigwavetable);
  protected
   procedure checktable;
   procedure sighandler(const ainfo: psighandlerinfoty);
   procedure sighandlerintpol(const ainfo: psighandlerinfoty);
   procedure objectevent(const sender: tobject; const event: objecteventty); override;
    //isigclient
   function gethandler: sighandlerprocty; override;
   procedure initmodel; override;
   function getinputar: inputconnarty; override;
   function getzcount: integer; override;
  public
   constructor create(aowner: tcomponent); override;
   procedure clear; override;
   property table: doublearty read ftable write settable;
  published
   property master: tsigwavetable read fmaster write setmaster;
   property frequency: tdoubleinputconn read ffrequency write setfrequency;
   property freqfact: tdoubleinputconn read ffrequfact write setfrequfact;
   property phase: tdoubleinputconn read fphase write setphase;
   property amplitude: tdoubleinputconn read famplitude write setamplitude;
   property oninittable: siginbursteventty read foninittable write foninittable;
   property options: sigwavetableoptionsty read foptions 
                                           write setoptions default [];
 end;

 functionnodety = record
  xend: double;
  offs: double;
  ramp: double;
 end;
 functionnodearty = array of functionnodety;
 functionsegmentty = record
  defaultnode: functionnodety;
  nodes: functionnodearty;
 end;
 pfunctionsegmentty = ^functionsegmentty;
 functionsegmentsty = array[0..functionsegmentcount-1] of functionsegmentty;
 
 tsigfuncttable = class(tsigmultiinpout)
  private
   famplitude: tdoubleinputconn;
   foninittable: sigincomplexbursteventty;
   ftable: complexarty;
   fsegments: functionsegmentsty;
   finpmin: double;
   finpmax: double;
   finpfact: double; //map input value to segmentindex
   famplitudepo: pdouble;
   fmaster: tsigfuncttable;
   procedure setamplitude(const avalue: tdoubleinputconn);
   procedure settable(const avalue: complexarty);
   procedure setmaster(const avalue: tsigfuncttable);
  protected
   procedure checktable;
   procedure sighandler(const ainfo: psighandlerinfoty);
   procedure objectevent(const sender: tobject; const event: objecteventty); override;
    //isigclient
   function gethandler: sighandlerprocty; override;
   procedure initmodel; override;
   function getinputar: inputconnarty; override;
   function getzcount: integer; override;
  public
   constructor create(aowner: tcomponent); override;
   procedure clear; override;
   property table: complexarty read ftable write settable;
                 //must be ordered by re values
  published
   property master: tsigfuncttable read fmaster write setmaster;
   property amplitude: tdoubleinputconn read famplitude write setamplitude;
   property oninittable: sigincomplexbursteventty read foninittable 
                                                        write foninittable;
 end;
 
 tsigmult = class(tsigmultiinpout)
  protected
//   procedure processinout(const acount: integer;
//             var ainp: doublepoarty; var aoutp: pdouble); override;
    //isigclient
   function gethandler: sighandlerprocty; override;
   procedure sighandler(const ainfo: psighandlerinfoty);
 end;

 sigenveloperangeoptionty = (sero_exp);
 sigenveloperangeoptionsty = set of sigenveloperangeoptionty;
 
 sigenvelopeoptionty = (seo_negtrig,seo_nozero);
 sigenvelopeoptionsty = set of sigenvelopeoptionty;
 envproginfoty = record
  startval: double;
  ramp: double;
  starttime: integer;
  endtime: integer;
  offset,scale: double;
  isexp: boolean;
 end;
 envproginfoarty = array of envproginfoty;
 
 tsigenvelope = class(tdoublesigoutcomp)
  private
   fattack_values: complexarty;
   fdecay_values: complexarty;
   frelease_values: complexarty;
   ftrigger: tchangedoubleinputconn;
   fprog: envproginfoarty;
   findex: integer;
   
   fcurrval: double;
   fcurrisexp: boolean;
   fattackval: double;
   fattackramp: double;
   freleaseindex: integer;
   freleaseval: double;
   freleaseramp: double;
   floopindex: integer;
   floopval: double;
   floopramp: double;
   famplitudepo: pdouble;
   
   ftime: integer;
   foptions: sigenvelopeoptionsty;
   ftimescale: real;
   fscale: real;
   foffset: real;
   fmin: real;
   fmax: real;
   floopstart: real;
   floopstartindex: integer;
   floopendindex: integer;
   freleasestart: real;
   fattack_options: sigenveloperangeoptionsty;
   fdecay_options: sigenveloperangeoptionsty;
   frelease_options: sigenveloperangeoptionsty;
   fmaster: tsigenvelope;
   famplitude: tdoubleinputconn;
   procedure setattack_values(const avalue: complexarty);
   procedure setdecay_values(const avalue: complexarty);
   procedure setrelease_values(const avalue: complexarty);
   procedure settrigger(const avalue: tchangedoubleinputconn);
   procedure setmin(const avalue: real);
   procedure setmax(const avalue: real);
   procedure setloopstart(const avalue: real);
   procedure setoptions(const avalue: sigenvelopeoptionsty);
   procedure setattack_options(const avalue: sigenveloperangeoptionsty);
   procedure setdecay_options(const avalue: sigenveloperangeoptionsty);
   procedure setrelease_options(const avalue: sigenveloperangeoptionsty);
   procedure setmaster(const avalue: tsigenvelope);
   procedure setamplitude(const avalue: tdoubleinputconn);
   procedure dosync;
  protected
   fattackpending: boolean;
   freleasepending: boolean;
   procedure sighandler(const ainfo: psighandlerinfoty);   
   procedure updatevalues;

   procedure objectevent(const sender: tobject; const event: objecteventty); override;
   procedure initmodel; override;
   function getinputar: inputconnarty; override;
   function getzcount: integer; override;
   function gethandler: sighandlerprocty; override;
   procedure dotriggerchange(const sender: tobject);
   procedure update; override;
   procedure lintoexp(var avalue: double);
   procedure exptolin(var avalue: double);
  public
   constructor create(aowner: tcomponent); override;
   procedure start;
   procedure stop;
   property attack_values: complexarty read fattack_values
                                                     write setattack_values;
   property decay_values: complexarty read fdecay_values
                                                     write setdecay_values;
   property release_values: complexarty read frelease_values 
                                                     write setrelease_values;
   property loopstart: real read floopstart write setloopstart;
                     //<0 -> inactive
  published
   property master: tsigenvelope read fmaster write setmaster;
   property trigger: tchangedoubleinputconn read ftrigger write settrigger;
                         //1 -> start, -1 -> stop
   property amplitude: tdoubleinputconn read famplitude write setamplitude;
   property options: sigenvelopeoptionsty read foptions 
                                                write setoptions default [];
   property timescale: real read ftimescale write ftimescale; //default 1s
   property min: real read fmin write setmin;
   property max: real read fmax write setmax;
   property attack_options: sigenveloperangeoptionsty read fattack_options 
                                         write setattack_options default [];
   property decay_options: sigenveloperangeoptionsty read fdecay_options 
                                 write setdecay_options default [sero_exp];
   property release_options: sigenveloperangeoptionsty read frelease_options 
                                 write setrelease_options default [sero_exp];
 end;
 
 sigcontrollerstatety = (scs_modelvalid,scs_hastick);
 sigcontrollerstatesty = set of sigcontrollerstatety;
 
 tsiginfohash = class(tpointerptruinthashdatalist)
 end;

 beforestepeventty = procedure(const sender: tsigcontroller;
                        var acount: integer; var handled: boolean) of object;
 afterstepeventty = procedure(const sender: tsigcontroller;
                               const acount: integer) of object;
 
 tsigcontroller = class(tmsecomponent)
  private
   finphash: tsiginfohash;
   foutphash: tsiginfohash;
   fvaluedummy: double;
   fmutex: mutexty;
   flockcount: integer;
   flockapplocks: integer;
   fticktime: integer;
   ftickdiv: integer;
   fonbeforetick: notifyeventty;
   fonaftertick: notifyeventty;
   fonbeforestep: beforestepeventty;
   fonbeforeupdatemodel: notifyeventty;
   fonafterupdatemodel: notifyeventty;
   fonafterstep: afterstepeventty;
   fsamplefrequ: real;
   procedure settickdiv(const avalue: integer);
   procedure setonbeforetick(const avalue: notifyeventty);
   procedure setonaftertick(const avalue: notifyeventty);
  protected
   fstate: sigcontrollerstatesty;
   fclients: sigclientintfarty;
   fticks: proceventarty;
   finfos: siginfoarty;
   finputnodes: siginfopoarty;
//   foutputnodes: siginfopoarty;
   fexecinfo: sighandlernodeinfoarty;
   fexechigh: integer;
  {$ifdef mse_debugsignal}
   procedure debugnodeinfo(const atext: string; const anode: psiginfoty);
   procedure debugpointer(const atext: string; const apointer: pointer);
  {$endif}
   procedure addclient(const aintf: isigclient);
   procedure removeclient(const aintf: isigclient);
   procedure updatemodel;
   function findinplink(const dest,source: psiginfoty): integer;
   procedure internalstep;
   procedure loaded; override;
   function findinp(const aconn: tsigconn): psiginfoty;
   function findoutp(const aconn: tsigconn): psiginfoty;
   procedure internalexecevent(const ainfopo: psiginfoty);
   procedure execevent(const aintf: isigclient); //must be locked
   procedure checktick;
   procedure dotick;
   function getnodenamepath(const aintf: isigclient): string;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   procedure lockapplication;  //releases controller lock, can not be nested
                               //call from locked signal thread only
   procedure unlockapplication;//acquires controller lock
   procedure modelchange;
   procedure checkmodel;
   procedure step(acount: integer=1);
   procedure clear;
   procedure lock;
   procedure unlock;
  published
   property samplefrequ: real read fsamplefrequ write fsamplefrequ;
                                //default 44100
   property tickdiv: integer read ftickdiv write settickdiv 
                                            default defaulttickdiv;
   property onbeforetick: notifyeventty read fonbeforetick 
                                                      write setonbeforetick;
   property onaftertick: notifyeventty read fonaftertick 
                                                      write setonaftertick;
   property onbeforestep: beforestepeventty read fonbeforestep 
                                                         write fonbeforestep;
   property onafterstep: afterstepeventty read fonafterstep 
                                                         write fonafterstep;

   property onbeforeupdatemodel: notifyeventty read fonbeforeupdatemodel 
                               write fonbeforeupdatemodel; //application.locked
   property onafterupdatemodel: notifyeventty read fonafterupdatemodel 
                               write fonafterupdatemodel;  //application.locked
 end;
 
procedure createsigbuffer(var abuffer: doublearty; const asize: integer);
procedure createsigarray(out abuffer: doublearty; const asize: integer);
procedure setsourceconn(const sender: tmsecomponent;
              const avalue: tdoubleoutputconn; var dest: tdoubleoutputconn);
procedure setsigcontroller(const linker: tobjectlinker; 
          const intf: isigclient; 
          const source: tsigcontroller; var dest: tsigcontroller);
procedure initscale(const amin,amax: double; const aoptions: valuescaleoptionsty;
                                            out ainfo: doublescaleinfoty);
procedure updatescale(var ainfo: doublescaleinfoty);
function scalevalue(const ainfo: doublescaleinfoty): double;
 
implementation
uses
 sysutils,mseformatstr,msesysutils,msesysintf,mseapplication;
type
 tmsecomponent1 = class(tmsecomponent);

procedure initscale(const amin,amax: double; const aoptions: valuescaleoptionsty;
                                            out ainfo: doublescaleinfoty);
begin
 with ainfo do begin
  min:= amin;
  max:= amax;
  options:= aoptions;
  updatescale(ainfo);
 end;
end;

procedure updatescale(var ainfo: doublescaleinfoty);
begin
 with ainfo do begin
  if (vso_exp in options) and (min > 0) and (max > 0) then begin
   offset:= ln(min);
   gain:= ln(max)-ln(min);
  end
  else begin
   offset:= min;
   gain:= max-min;
  end;
 end;
end;

function scalevalue(const ainfo: doublescaleinfoty): double;
begin
 with ainfo do begin
  if (vso_null in options) and (value <= 0) then begin
   result:= 0;
  end
  else begin
   result:= value*gain+offset;
   if vso_exp in options then begin
    result:= exp(result);
   end;
  end;
 end;
end;
  
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

procedure tcustomsigcomp.update;
begin
 //dummy
end;

procedure tcustomsigcomp.beginupdate;
begin
 inc(fupdating);
end;

procedure tcustomsigcomp.endupdate;
begin
 dec(fupdating);
 if fupdating = 0 then begin
  update;
 end;
end;

{ tdoublconn }

constructor tdoubleconn.create(const aowner: tcomponent;
                     const asigintf: isigclient);
begin
 fsigintf:= asigintf;
 inherited create(aowner);
 setsubcomponent(true);
end;

//{$ifndef FPC}
function tdoubleconn.getcontroller: tsigcontroller;
begin
 result:= fsigintf.getsigcontroller;
end;

procedure tdoubleconn.lock;
var
 cont1: tsigcontroller;
begin
 cont1:= fsigintf.getsigcontroller;
 if cont1 <> nil then begin
  cont1.lock;
 end;
end;

procedure tdoubleconn.unlock;
var
 cont1: tsigcontroller;
begin
 cont1:= fsigintf.getsigcontroller;
 if cont1 <> nil then begin
  cont1.unlock;
 end;
end;
//{$endif}

{ tdoubleoutputconn }

constructor tdoubleoutputconn.create(const aowner: tcomponent;
                     const asigintf: isigclient; const aeventdriven: boolean);
begin
 inherited create(aowner,asigintf);
 if aeventdriven then begin 
  include(fstate,ocs_eventdriven);
 end;
 include (fmsecomponentstate,cs_subcompref);
 name:= 'output';
end;
{
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
}
{ tdoubleinputconn }

constructor tdoubleinputconn.create(const aowner: tcomponent;
                     const asigintf: isigclient);
begin
 fgain:= 1;
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
 if fsource <> avalue then begin
  setsourceconn(self,avalue,fsource);
  fsigintf.modelchange;
 end;
end;

procedure tdoubleinputconn.setoffset(const avalue: double);
begin
 lock;
 foffset:= avalue;
 unlock;
end;

procedure tdoubleinputconn.setgain(const avalue: double);
begin
 lock;
 fgain:= avalue;
 unlock;
end;

procedure tdoubleinputconn.setvalue(const avalue: double);
begin
 lock;
 fvalue:= avalue;
 unlock;
end;

{
procedure tdoubleinputconn.setsig1(var asource: doublearty);
begin
 fowner.setsig1(self,asource);
end;

procedure tdoubleinputconn.setsig(const asource: doublearty);
begin
 fowner.setsig(self,asource);
end;
}
{ tdoublesigcomp }

constructor tdoublesigcomp.create(aowner: tcomponent);
begin
 inherited;
end;
 
destructor tdoublesigcomp.destroy;
begin
 controller:= nil;
 clear;
 inherited;
end;

procedure tdoublesigcomp.clear;
begin
 //dummy
end;
(*
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
*)
procedure setsigcontroller(const linker: tobjectlinker; 
          const intf: isigclient; 
          const source: tsigcontroller; var dest: tsigcontroller);
begin
 if dest <> nil then begin
  dest.removeclient(intf);
 end;
 linker.setlinkedvar(intf,source,tmsecomponent(dest));
 if dest <> nil then begin
  dest.addclient(intf);
 end;
end;

procedure tdoublesigcomp.setcontroller(const avalue: tsigcontroller);
begin
 setsigcontroller(getobjectlinker,isigclient(self),avalue,fcontroller);
end;

procedure tdoublesigcomp.modelchange;
begin
 if ([csdestroying,csloading]*componentstate = []) then begin
  if (fcontroller <> nil) then begin
   if ([csdestroying,csloading]*fcontroller.componentstate = []) then begin
    fcontroller.lock;
    fcontroller.modelchange;
    fcontroller.unlock;
   end;
  end
 end;
end;

function tdoublesigcomp.getinputar: inputconnarty;
begin
 result:= nil;
end;

function tdoublesigcomp.getoutputar: outputconnarty;
begin
 result:= nil;
end;

procedure tdoublesigcomp.loaded;
begin
 inherited;
 modelchange;
 update;
end;

procedure tdoublesigcomp.initmodel;
begin
 //dummy
end;

function tdoublesigcomp.getzcount: integer;
begin
 result:= 0;
end;

function tdoublesigcomp.getsigcontroller: tsigcontroller;
begin
 result:= fcontroller;
end;

procedure tdoublesigcomp.lock;
begin
 if fcontroller <> nil then begin
  fcontroller.lock;
 end;
end;

procedure tdoublesigcomp.unlock;
begin
 if fcontroller <> nil then begin
  fcontroller.unlock;
 end;
end;

function tdoublesigcomp.getsigclientinfopo: psigclientinfoty;
begin
 result:= @fsigclientinfo;
end;

procedure tdoublesigcomp.sigtick;
begin
 //dummy
end;

function tdoublesigcomp.getsigoptions: sigclientoptionsty;
begin
 result:= [];
end;

procedure tdoublesigcomp.lockapplication;
begin
 if fcontroller <> nil then begin
  fcontroller.lockapplication;
 end;
end;

procedure tdoublesigcomp.unlockapplication;
begin
 if fcontroller <> nil then begin
  fcontroller.unlockapplication;
 end;
end;

{ tdoublezcomp }

constructor tdoublezcomp.create(aowner: tcomponent);
begin
 fzhigh:= -1;
 finput:= tdoubleinputconn.create(self,isigclient(self));
 foutput:= tdoubleoutputconn.create(self,isigclient(self),false);
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
{
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
}
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

function tdoublezcomp.getinputar: inputconnarty;
begin
 setlength(result,1);
 result[0]:= finput;
end;

function tdoublezcomp.getoutputar: outputconnarty;
begin
 setlength(result,1);
 result[0]:= foutput;
end;

{ tsigout }

constructor tsigout.create(aowner: tcomponent);
begin
 finput:= tdoubleinputconn.create(self,isigclient(self));
 finputpo:= @finput.fvalue;
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
{
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
}
function tsigout.getinputar: inputconnarty;
begin
 setlength(result,1);
 result[0]:= finput;
end;

function tsigout.gethandler: sighandlerprocty;
begin
 result:= {$ifdef FPC}@{$endif}sighandler;
end;

procedure tsigout.sighandler(const ainfo: psighandlerinfoty);
var
 po1: psizeint;
begin
 fvalue:= finputpo^;
 if assigned(fonoutput) then begin
  fonoutput(self,fvalue);
 end;
 if fbuffersize > 0 then begin
  if foutpindex = fbuffersize then begin
   foutpindex:= 0;
  end;
  po1:= psizeint(pchar(foutp)-2*sizeof(sizeint));
  if po1^ > 1 then begin //new buffer necessary
   dec(po1^); //no thread safety
  (*
  {$ifdef CPU64}
   interlockeddecrement64(po1^);
  {$else}
   interlockeddecrement(po1^);
  {$endif}
   if po1^ = 0 then begin
    freemem(po1);
   end;
  *)
   getmem(po1,fbuffersize * sizeof(double) + 2 * sizeof(sizeint));
   po1^:= 1; //refcount
   inc(po1);
   {$ifdef FPC}
   po1^:= fbuffersize - 1; //high
   {$else}
   po1^:= fbuffersize;     //count
   {$endif}
   inc(po1);
   if foutpindex > 0 then begin
    move(foutp[0],po1^,foutpindex*sizeof(double));
   end;
   pointer(foutp):= po1;
  end;
  foutp[foutpindex]:= fvalue;
  inc(foutpindex);
  if foutpindex = fbuffersize then begin
//   foutpindex:= 0;
   if assigned(fonoutputburst) then begin
    fonoutputburst(self,realarty(foutp));
   end;
  end;
 end;
end;

procedure tsigout.sigoutput1(var adest: doublearty);
var
 po1: psizeint;
begin
 if foutpindex > 0 then begin
  if adest = nil then begin
   getmem(po1,foutpindex * sizeof(double) + 2 * sizeof(sizeint));
   po1^:= 1; //referencount;
   inc(po1);
  {$ifdef FPC}
   po1^:= foutpindex-1; //high
  {$else}
   po1^:= foutpindex;   //length
  {$endif}
   inc(po1);
   pointer(adest):= po1;
  end
  else begin
   po1:= psizeint(pchar(adest)-2*sizeof(sizeint));
   if po1^ = 1 then begin
   {$ifdef FPC}
    if psizeint(pchar(po1)+1*sizeof(sizeint))^ < foutpindex - 1 then begin
   {$else}
    if psizeint(pchar(po1)+1*sizeof(sizeint))^ < foutpindex then begin
   {$endif}
     freemem(po1);  //new buffer
     getmem(po1,foutpindex * sizeof(double) + 2 * sizeof(sizeint)); 
     po1^:= 1; //referencount;
     inc(po1);
    {$ifdef FPC}
     po1^:= foutpindex-1; //high
    {$else}
     po1^:= foutpindex;   //length
    {$endif}
     inc(po1);
     pointer(adest):= po1;
    end
    else begin           //reduce buffer
    {$ifdef FPC}
     if psizeint(pchar(po1)+1*sizeof(sizeint))^ > foutpindex - 1 then begin
    {$else}
     if psizeint(pchar(po1)+1*sizeof(sizeint))^ > foutpindex then begin
    {$endif}
      reallocmem(po1,foutpindex * sizeof(double) + 2 * sizeof(sizeint));
      pointer(adest):= pchar(po1)+2*sizeof(sizeint);
     end;
    end;
   end
   else begin 
    getmem(po1,foutpindex * sizeof(double) + 2 * sizeof(sizeint)); //new buffer
    po1^:= 1; //referencount;
    inc(po1);
   {$ifdef FPC}
    po1^:= foutpindex-1; //high
   {$else}
    po1^:= foutpindex;   //length
   {$endif}
    inc(po1);
    pointer(adest):= po1;
   end;
  end;
  move(foutp[0],adest[0],foutpindex*sizeof(double));
 end
 else begin
  adest:= nil;
 end;
end;

function tsigout.sigoutput: doublearty;
begin
 sigoutput1(result);
end;

procedure tsigout.setbuffersize(const avalue: integer);
begin
 if fbuffersize <> avalue then begin
  fbuffersize:= avalue;
  clear;
 end;
end;

procedure tsigout.clear;
begin
 inherited;
 setlength(foutp,fbuffersize);
 foutpindex:= 0;
end;

function tsigout.getvalue: double;
begin
 lock;
 result:= fvalue;
 unlock;
end;

{ tsigin }

constructor tsigin.create(aowner: tcomponent);
begin
 foutput:= tdoubleoutputconn.create(self,isigclient(self),false);
 inherited;
end;

destructor tsigin.destroy;
begin
 inherited;
end;

procedure tsigin.siginput(const asource: doublearty);
var
 int1,int2,int3: integer;
 po1: psizeint;
begin
 int1:= length(finp);
 if int1 = 0 then begin
  finp:= asource;
 end
 else begin
  int1:= int1 - finpindex;
  if int1 > 0 then begin
   setlength(finp,length(finp)); //unique reference
   move(finp[finpindex],finp[0],int1*sizeof(double));
  end;
  finpindex:= 0;
  if asource <> finp then begin
   int2:= length(asource);
   int3:= int1+int2;
   po1:= psizeint(pchar(finp)-2*sizeof(sizeint));
   if po1^ <> 1 then begin
    dec(po1^); //no thread safety
    getmem(po1,int3*sizeof(double)+2*sizeof(sizeint));
    po1^:= 1;
    move(finp[0],(pchar(po1)+2*sizeof(sizeint))^,int1*sizeof(double));
   end
   else begin
   {$ifdef FPC}
    if psizeint(pchar(po1)+sizeof(sizeint))^ <> int3-1 then begin
   {$else}
    if psizeint(pchar(po1)+sizeof(sizeint))^ <> int3 then begin
   {$endif}
     reallocmem(po1,int3*sizeof(double)+2*sizeof(sizeint));
    end;
   end;
   inc(po1);
   {$ifdef FPC}
   po1^:= int3-1;   //high
   {$else}
   po1^:= int3; //length
   {$endif}
   inc(po1);
   pointer(finp):= po1;
   move(asource[0],finp[int1],int2*sizeof(double));
  end;
 end;
// foutput.setsig(asource);
end;
{
procedure tsigin.setsig1(var asource: doublearty);
begin
 foutput.setsig1(asource);
end;
}
function tsigin.getoutputar: outputconnarty;
begin
 setlength(result,1);
 result[0]:= foutput;
end;

function tsigin.gethandler: sighandlerprocty;
begin
 result:= {$ifdef FPC}@{$endif}sighandler;
end;

procedure tsigin.sighandler(const ainfo: psighandlerinfoty);
begin
 if finpindex <= high(finp) then begin
  fvalue:= finp[finpindex];
  inc(finpindex);
 end
 else begin
  if assigned(foninputburst) then begin
   foninputburst(self,realarty(finp));
   finpindex:= 0;
   if finp <> nil then begin
    fvalue:= finp[0];
    inc(finpindex);
   end;
  end;
 end;
 if assigned(foninput) then begin
  foninput(self,real(fvalue));
 end;
 ainfo^.dest^:= fvalue;
end;

procedure tsigin.clear;
begin
 inherited;
 finp:= nil;
 finpindex:= 0;
end;

procedure tsigin.setvalue(const avalue: double);
begin
 lock;
 fvalue:= avalue;
 unlock;
end;

{ tsigmultiinp }

constructor tsigmultiinp.create(aowner: tcomponent);
begin
// foutput:= tdoubleoutputconn.create(self);
 inherited;
 finputs:= tdoubleinpconnarrayprop.create(self);
end;

destructor tsigmultiinp.destroy;
begin
 inherited;
 finputs.free;
end;
(*
procedure tsigmultiinp.clear;
//var
// int1: integer;
begin
 dar:= nil;
 pdar:= nil;
// finpdatacount:= 0;
 inherited;
 {
 for int1:= 0 to high(finputs.fitems) do begin
  tdoubleinputconn(finputs.fitems[int1]).fbuffer:= nil;
 end;
 }
end;
*)

procedure tsigmultiinp.setinputs(const avalue: tdoubleinpconnarrayprop);
begin
 finputs.assign(avalue);
end;

{
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
}
function tsigmultiinp.getinputar: inputconnarty;
begin
 result:= inputconnarty(finputs.fitems);
end;

procedure tsigmultiinp.initmodel;
var
 int1: integer;
begin
 finphigh:= finputs.count-1;
 setlength(finps,finphigh+1);
 for int1:= 0 to finphigh do begin
  finps[int1]:= @tdoubleinputconn(finputs.fitems[int1]).fvalue;
 end;
end;

{ tsigmultiinpout }

constructor tsigmultiinpout.create(aowner: tcomponent);
begin
 foutput:= tdoubleoutputconn.create(self,isigclient(self),false);
 inherited;
end;

procedure tsigmultiinpout.setoutput(const avalue: tdoubleoutputconn);
begin
 foutput.assign(avalue);
end;

function tsigmultiinpout.getoutputar: outputconnarty;
begin
 setlength(result,1);
 result[0]:= foutput;
end;

{ tdoublesigoutcomp }

constructor tdoublesigoutcomp.create(aowner: tcomponent);
begin
 foutput:= tdoubleoutputconn.create(self,isigclient(self),false);
 inherited;
end;

procedure tdoublesigoutcomp.setoutput(const avalue: tdoubleoutputconn);
begin
 foutput.assign(avalue);
end;

function tdoublesigoutcomp.getoutputar: outputconnarty;
begin
 setlength(result,1);
 result[0]:= foutput;
end;

{ tdoubleinpconnarrayprop }

constructor tdoubleinpconnarrayprop.create(const asigintf: isigclient);
begin
 fsigintf:= asigintf;
 inherited create(nil);
end;

procedure tdoubleinpconnarrayprop.createitem(const index: integer;
               var item: tpersistent);
begin
 item:= tdoubleinputconn.create(nil,fsigintf);
end;

function tdoubleinpconnarrayprop.getitems(const index: integer): tdoubleinputconn;
begin
 result:= tdoubleinputconn(inherited getitems(index));
end;

procedure tdoubleinpconnarrayprop.dosizechanged;
begin
 inherited;
 fsigintf.modelchange;
end;

{ tdoubleoutconnarrayprop }

constructor tdoubleoutconnarrayprop.create(const aowner: tcomponent;
                              const aname: string; const asigintf: isigclient;
                              const aeventdriven: boolean);
begin
 fsigintf:= asigintf;
 fowner:= aowner;
 fname:= aname;
 feventdriven:= aeventdriven;
 inherited create(nil);
end;

procedure tdoubleoutconnarrayprop.createitem(const index: integer;
               var item: tpersistent);
begin
 item:= tdoubleoutputconn.create(fowner,fsigintf,feventdriven);
 tdoubleoutputconn(item).name:= fname+inttostr(index);
end;

function tdoubleoutconnarrayprop.getitems(
                           const index: integer): tdoubleoutputconn;
begin
 result:= tdoubleoutputconn(inherited getitems(index));
end;

procedure tdoubleoutconnarrayprop.dosizechanged;
begin
 inherited;
 fsigintf.modelchange;
end;

{ tsigadd }

function tsigadd.gethandler: sighandlerprocty;
begin
 result:= {$ifdef FPC}@{$endif}sighandler;
end;

procedure tsigadd.sighandler(const ainfo: psighandlerinfoty);
var
 int1: integer;
begin
 ainfo^.dest^:= 0;
 for int1:= 0 to finphigh do begin
  ainfo^.dest^:= ainfo^.dest^ + finps[int1]^;
 end;
end;

{ tsigdelay }

function tsigdelay.getzcount: integer;
begin
 result:= 1;
end;

function tsigdelay.gethandler: sighandlerprocty;
begin
 result:= {$ifdef FPC}@{$endif}sighandler;
end;

procedure tsigdelay.sighandler(const ainfo: psighandlerinfoty);
var
 int1: integer;
begin
 ainfo^.dest^:= fz;
 fz:= 0;
 for int1:= 0 to finphigh do begin
  fz:= fz + finps[int1]^;
 end;
end;

procedure tsigdelay.clear;
begin
 fz:= 0;
end;

{ tsigdelayn }

constructor tsigdelayn.create(aowner: tcomponent);
begin
 fdelay:= 1;
 inherited;
end;

procedure tsigdelayn.initmodel;
begin
 inherited;
 finppo:= 0;
 setlength(fz,fdelay);
end;

procedure tsigdelayn.clear;
begin
 inherited;
 fillchar(fz[0],sizeof(fz[0])*length(fz),0);
end;

function tsigdelayn.getzcount: integer;
begin
 result:= fdelay;
end;

function tsigdelayn.gethandler: sighandlerprocty;
begin
 result:= {$ifdef FPC}@{$endif}sighandler;
end;

procedure tsigdelayn.sighandler(const ainfo: psighandlerinfoty);
var
 int1: integer;
 po1: pdouble;
begin
 if fdelay = 0 then begin
  ainfo^.dest^:= 0;
  for int1:= 0 to finphigh do begin
   ainfo^.dest^:= ainfo^.dest^ + finps[int1]^;
  end;
 end
 else begin
  po1:= @fz[finppo];
  po1^:= 0;
  for int1:= 0 to finphigh do begin
   po1^:= po1^ + finps[int1]^;
  end;
  inc(finppo);
  if finppo = fdelay then begin
   finppo:= 0;
  end;
 end;
end;

procedure tsigdelayn.setdelay(const avalue: integer);
begin
 if fdelay <> avalue then begin
  lock;
  modelchange;
  fdelay:= avalue;
  unlock;
 end;
end;

{ tsigmult }
{
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
}
function tsigmult.gethandler: sighandlerprocty;
begin
 result:= {$ifdef FPC}@{$endif}sighandler;
end;

procedure tsigmult.sighandler(const ainfo: psighandlerinfoty);
var
 int1: integer;
begin
 ainfo^.dest^:= 1;
 for int1:= 0 to finphigh do begin
  ainfo^.dest^:= ainfo^.dest^ * finps[int1]^;
 end;
end;

{ tsigcontroller }

constructor tsigcontroller.create(aowner: tcomponent);
begin
 fsamplefrequ:= defaultsamplefrequ;
 ftickdiv:= defaulttickdiv;
 syserror(sys_mutexcreate(fmutex),self);
 finphash:= tsiginfohash.create;
 foutphash:= tsiginfohash.create;
 inherited;
end;

destructor tsigcontroller.destroy;
begin
 inherited;
 finphash.free;
 foutphash.free;
 sys_mutexdestroy(fmutex);
end;

procedure tsigcontroller.addclient(const aintf: isigclient);
begin
 lock;
 adduniqueitem(pointerarty(fclients),pointer(aintf));
 modelchange;
 unlock;
end;

procedure tsigcontroller.removeclient(const aintf: isigclient);
begin
 lock;
 removeitem(pointerarty(fclients),pointer(aintf));
 modelchange;
 unlock;
end;

procedure tsigcontroller.modelchange;
begin
 exclude(fstate,scs_modelvalid);
end;

function tsigcontroller.findinp(const aconn: tsigconn): psiginfoty;
begin
 result:= finphash.find(ptruint(aconn));
end;

function tsigcontroller.findoutp(const aconn: tsigconn): psiginfoty;
begin
 result:= foutphash.find(ptruint(aconn));
end;

 {$ifdef mse_debugsignal}
procedure tsigcontroller.debugnodeinfo(const atext: string;
                                                   const anode: psiginfoty);
var
 str1: string;
begin
 if anode = nil then begin
  str1:= '<NIL>';
 end
 else begin
  str1:= getnodenamepath(anode^.intf) + 
             ' conncount: '+inttostr(anode^.connectedcount);
 end; 
 debugwriteln(atext+str1);
end;

procedure tsigcontroller.debugpointer(const atext: string;
                                                   const apointer: pointer);
begin
 debugwriteln(atext+hextostr(apointer));
end;
{$endif}

function tsigcontroller.findinplink(const dest,source: psiginfoty): integer;
var
 int1: integer;
begin
 result:= -1;
 for int1:= 0 to high(dest^.inputs) do begin
  if dest^.inputs[int1].source = source then begin
   result:= int1;
   break;
  end;
 end;
end;

procedure tsigcontroller.updatemodel;
{$ifdef mse_debugsignal}
var
 indent: string;
{$endif}

 procedure resetchecked;
 var 
  int1,int2: integer;
 begin
  for int1:= 0 to high(finfos) do begin
   with finfos[int1] do begin
    exclude(state,sis_checked);
    for int2:= 0 to high(inputs) do begin
     exclude(inputs[int2].state,ins_checked);
    end;
   end;
  end;
 end; //resetchecked

var
 visited: pointerarty;
 
 procedure checkrecursion(const anode: psiginfoty);
 var
  int1,int2: integer;
  po1: psiginfoty;
  visitedbefore: pointerarty;
 {$ifdef mse_debugsignal}
  indentbefore: string;
 {$endif}
 begin
 {$ifdef mse_debugsignal}
  indentbefore:= indent;
  indent:= indent+' ';
  debugnodeinfo(indent+'node ',anode);
 {$endif}  
  additem(visited,anode);
  visitedbefore:= visited;
  with anode^ do begin
   for int1:= 0 to high(destinations) do begin
    visited:= visitedbefore;
    po1:= findinp(destinations[int1].destinput);
    int2:= findinplink(po1,anode);
    if finditem(visited,po1) >= 0 then begin
     if zcount = 0 then begin
      raise exception.create('No Z-delay in recursion node '+
                getnodenamepath(intf)+
             ' -> '+getnodenamepath(po1^.intf)+'.');
     end
     else begin
      include(po1^.inputs[int2].state,ins_recursive);
      dec(po1^.connectedcount);
     end;
    end
    else begin
     include(po1^.inputs[int2].state,ins_checked);
     checkrecursion(po1);
    end;
   end;
  end;
  visited:= visitedbefore;
 {$ifdef mse_debugsignal}
  indent:= indentbefore;
 {$endif}  
 end; //checkrecursion

var
 execorder: siginfopoarty;
 execindex: integer;
 
 procedure processcalcorder(const anode: psiginfoty);
 var
  int1: integer;
  po1,po2: psiginfoty;
 {$ifdef mse_debugsignal}
  indentbefore: string;
 {$endif}
 begin
 {$ifdef mse_debugsignal}
  indentbefore:= indent;
  indent:= indent+' ';
  debugnodeinfo(inttostr(execindex)+indent+'calcnode ',anode);
 {$endif}   
  if execindex > high(execorder) then begin
   internalerror('SIG20100916-0');
  end;
  execorder[execindex]:= anode;
  inc(execindex);
  with anode^ do begin
   include(state,sis_checked);
   for int1:= 0 to high(next) do begin
    po1:= next[int1];
   {$ifdef mse_debugsignal}
    debugnodeinfo(indent+' dest '+booltostr(sis_checked in po1^.state)+' ',po1);
   {$endif}   
    if not (sis_checked in po1^.state) then begin
     if not (ins_recursive in po1^.inputs[findinplink(po1,anode)].state) then begin
      dec(po1^.connectedcount);
      if po1^.connectedcount <= 0 then begin
       processcalcorder(po1);
      end;
     end;
    end;
   end;
  end;
 {$ifdef mse_debugsignal}
  indent:= indentbefore;
 {$endif}  
 end; //processcalcorder

 procedure updatedestinfo(const ainput: tdoubleinputconn;
                                 const source: pdouble; var ainfo: destinfoty);
 begin
  ainfo.source:= source;
  ainfo.dest:= @ainput.fvalue;
  ainfo.offset:= ainput.offset;
  ainfo.gain:= ainput.gain;
  ainfo.hasscale:= (ainfo.offset <> 0) or (ainfo.gain <> 1);
 end; //updatedestinfo

 function isopeninput(const ainputs: inputinfoarty): boolean;
 var
  int1: integer;
 begin
  result:= true;
  for int1:= 0 to high(ainputs) do begin
   with ainputs[int1] do begin
    if (source <> nil) then begin
     result:= false;
     break;
    end;
   end;
  end;
 end;

 procedure touchnode(const anode: psiginfoty);
 var
  int1: integer;
 begin
  with anode^ do begin
   include(state,sis_touched);
   for int1:= 0 to high(next) do begin
    if not (sis_touched in next[int1]^.state) then begin
     touchnode(next[int1]);
    end;
   end;
  end;
 end;
 
 function isopenoutput(const aoutputs: outputconnarty): boolean;
 var
  int1: integer;
 begin
  result:= true;
  for int1:= 0 to high(aoutputs) do begin
   with aoutputs[int1] do begin
    if not (ocs_eventdriven in fstate) and (fdestinations <> nil) then begin
     result:= false;
     break;
    end;
   end;
  end;
 end;
  
var
 int1,int2,int3,int4: integer;
 po1,po2: psiginfoty;
 inputnodecount: integer;
 notconnectedcount: integer;
// outputnodecount: integer;
 recursivenodecount: integer;
 ar1,ar2: siginfopoarty;
 ar3: inputconnarty;
begin
 if assigned(fonbeforeupdatemodel) then begin
  application.lock;
  try
   fonbeforeupdatemodel(self);
  finally
   application.unlock;
  end;
 end;
 finfos:= nil;
 finphash.clear;
 foutphash.clear;
 fticks:= nil;
 finputnodes:= nil;
// foutputnodes:= nil;
 fexecinfo:= nil;
// outputnodecount:= 0;
 inputnodecount:= 0;
 notconnectedcount:= 0;
 setlength(finfos,length(fclients));
{$ifdef mse_debugsignal}
 debugwriteln('**updatemodel '+name);
 debugwriteln('*get info');
{$endif}

 for int1:= 0 to high(fclients) do begin //get basic info
  po1:= @finfos[int1];
  if sco_tick in fclients[int1].getsigoptions then begin
   setlength(fticks,high(fticks)+2);
   fticks[high(fticks)]:= @fclients[int1].sigtick;
  end;
  fclients[int1].getsigclientinfopo^.infopo:= po1;
  with po1^ do begin
   intf:= fclients[int1];
   handler:= intf.gethandler;
   intf.initmodel;
   intf.clear;
   zcount:= intf.getzcount;
  {$ifdef mse_debugsignal}
   debugwriteln('client '+getnodenamepath(intf));
  {$endif}
   ar3:= fclients[int1].getinputar;
   setlength(inputs,length(ar3));
   for int2:= 0 to high(ar3) do begin
    inputs[int2].input:= ar3[int2];
   end;
   outputs:= fclients[int1].getoutputar;
   destinations:= nil;
   for int2:= 0 to high(inputs) do begin
  {$ifdef mse_debugsignal}
    debugpointer(' inp ',inputs[int2].input);
  {$endif}
    finphash.add(ptruint(inputs[int2].input),po1);
   end;
   for int2:= 0 to high(outputs) do begin
  {$ifdef mse_debugsignal}
    debugpointer(' outp ',outputs[int2]);
  {$endif}
    foutphash.add(ptruint(outputs[int2]),po1);
    with outputs[int2] do begin
     int3:= length(po1^.destinations);
     setlength(po1^.destinations,int3+length(fdestinations));
     for int4:= 0 to high(fdestinations) do begin
      with po1^.destinations[int3+int4] do begin
       outputindex:= int2;
       destinput:= fdestinations[int4];       
      end;
     end;
//     stackarray(pointerarty(fdestinations),pointerarty(po1^.destinations));
   {$ifdef mse_debugsignal}
     for int3:= 0 to high(fdestinations) do begin
      debugpointer('  dest ',fdestinations[int3]);
     end;
   {$endif}
    end;
   end;
  end;
 end;
  
{$ifdef mse_debugsignal}
  debugwriteln('*link items');
{$endif}
 for int1:= 0 to high(fclients) do begin //link the items
  po1:= @finfos[int1];
  with po1^ do begin
   if not (sis_checked in state) then begin
   {$ifdef mse_debugsignal}
    debugnodeinfo('node ',po1);
   {$endif}
    include(state,sis_checked);
    for int2:= 0 to high(outputs) do begin
     with outputs[int2] do begin
      for int3:= 0 to high(fdestinations) do begin
      {$ifdef mse_debugsignal}
       debugpointer('lookup inp ',fdestinations[int3]);
      {$endif}
       po2:= findinp(fdestinations[int3]);
      {$ifdef mse_debugsignal}
       debugnodeinfo(' ',po2);
      {$endif}
       if po2 = nil then begin
        raise exception.create(
         'Destination not found. Controller: '+self.name+ ', Node: '+
                     getnodenamepath(fclients[int1]) +
                 ', Dest: '+fdestinations[int3].fsigintf.getcomponent.name+'.');
       end;
       if not (ocs_eventdriven in fstate) then begin
        if finditem(pointerarty(po2^.prev),po1) < 0 then begin
         inc(po2^.connectedcount);
        {$ifdef mse_debugsignal}
         debugnodeinfo(' new link ',po2);
        {$endif}
         additem(pointerarty(po2^.prev),po1);
         additem(pointerarty(po1^.next),po2);
        end;
        for int4:= 0 to high(po2^.inputs) do begin
         if po2^.inputs[int4].input = fdestinations[int3] then begin
          po2^.inputs[int4].source:= po1;
          break;
         end;
        end;
       end;
      end;
     end;
    end;      
   end;
  end;
 end; 

{$ifdef mse_debugsignal}
 debugwriteln('*check input/output');
{$endif}
 for int1:= 0 to high(fclients) do begin
  po1:= @finfos[int1];
  with po1^ do begin
   state:= [];
   if not isopenoutput(outputs) then begin
    include(state,sis_output);
   end
   else begin
   {$ifdef mse_debugsignal}
    debugnodeinfo(' output node ',po1);
   {$endif}
   end;
   if not isopeninput(inputs) then begin
    include(state,sis_input);
   end
   else begin
    if sis_output in state then begin
     additem(pointerarty(finputnodes),po1,inputnodecount);
     touchnode(po1);
    {$ifdef mse_debugsignal}
     debugnodeinfo(' input node ',po1);
    {$endif}
    end
    else begin
     inc(notconnectedcount);
    {$ifdef mse_debugsignal}
     debugnodeinfo(' not connected node ',po1);
    {$endif}     
    end;
   end;
  end;
 end;

{$ifdef mse_debugsignal}
 debugwriteln('*check event connections');
{$endif}
 for int1:= 0 to high(finfos) do begin
  with finfos[int1] do begin
   if not (sis_eventchecked in state) then begin
    for int2:= 0 to high(outputs) do begin
     with outputs[int2] do begin
      for int3:= 0 to high(fdestinations) do begin
       po2:= findinp(fdestinations[int3]);
       if not (sis_input in po2^.state) then begin
       {$ifdef mse_debugsignal}
        debugnodeinfo('event source ',@finfos[int1]);
        debugpointer(' lookup inp ',fdestinations[int3]);
        debugnodeinfo('  event ',po2);
       {$endif}
        if sis_eventchecked in po2^.state then begin
         raise exception.create(
          'Recursive event connection: '+self.name+ ', Node: '+
                      getnodenamepath(finfos[int1].intf) +
                  ', Dest: '+getnodenamepath(po2^.intf)+'.');
        end; 
        adduniqueitem(pointerarty(eventdestinations),po2);
        include(state,sis_eventchecked);
       end;
      end;
     end;
    end;
   end;
  end;
 end;
  
{$ifdef mse_debugsignal}
 debugwriteln('*check recursive without inputs');
{$endif}
 for int1:= 0 to high(fclients) do begin
  po1:= @finfos[int1];
  with po1^ do begin
   if state * [sis_input,sis_output,sis_touched,sis_eventchecked] = 
                                                [sis_output] then begin
    additem(pointerarty(finputnodes),po1,inputnodecount);
   {$ifdef mse_debugsignal}
    debugnodeinfo(' recursive circle start ',po1);
    touchnode(po1);
   {$endif}
   end;
  end;
 end;
 
 setlength(finputnodes,inputnodecount);

{$ifdef mse_debugsignal}
  debugwriteln('*check recursion');
{$endif}

 for int1:= 0 to high(finputnodes) do begin //check recursion
 {$ifdef mse_debugsignal}
  debugnodeinfo('input ',finputnodes[int1]);
 {$endif}
  visited:= nil;
  checkrecursion(finputnodes[int1]);
 end;

{$ifdef mse_debugsignal}
 debugwriteln('*processcalcorder');  
{$endif}
 setlength(execorder,length(finfos));
 execindex:= 0;
// resetchecked;
 for int1:= 0 to high(finputnodes) do begin
 {$ifdef mse_debugsignal}
  debugnodeinfo('input ',finputnodes[int1]);  
 {$endif}
  resetchecked;
  processcalcorder(finputnodes[int1]);
 end;

{$ifdef mse_debugsignal}
 debugwriteln('*execorder '+inttostr(length(execorder))+' '+inttostr(execindex));
 for int1:= 0 to high(execorder) do begin
  debugnodeinfo(' ',execorder[int1]);
 end;
 for int1:= 0 to high(finfos) do begin
  po1:= @finfos[int1];
  with po1^ do begin
   if connectedcount <> 0 then begin
    debugnodeinfo('! '+inttostr(connectedcount)+ ' ',po1);
   end;
  end;
 end;
{$endif}
 if execindex+notconnectedcount <> length(execorder) then begin
  internalerror('SIG20100916-2'); //unprocessed nodes
 end;
 setlength(fexecinfo,execindex);
 fexechigh:= execindex-1;
 for int1:= 0 to high(fexecinfo) do begin
  po1:= execorder[int1];
  with fexecinfo[int1] do begin
   handler:= po1^.handler;
   desthigh:= high(po1^.destinations)-1;
   handlerinfo.dest:= @fvaluedummy;
   if length(po1^.destinations) > 0 then begin
    int3:= po1^.destinations[0].outputindex;
    updatedestinfo(po1^.destinations[0].destinput,handlerinfo.dest,firstdest);
                      //setup hasscale
    if (int3 = 0) and (desthigh < 0) or not firstdest.hasscale then begin
     handlerinfo.dest:= @po1^.destinations[0].destinput.fvalue;
    end;    
    if int3 = 0 then begin                //setup again with correct dest
     updatedestinfo(po1^.destinations[0].destinput,handlerinfo.dest,firstdest);
    end
    else begin
     updatedestinfo(po1^.destinations[0].destinput,
                                         @po1^.outputs[int3].fvalue,firstdest);
    end;
       
    setlength(dest,desthigh+1);
    for int2:= 0 to desthigh do begin
     int3:= po1^.destinations[int2+1].outputindex;
     if int3 > 0 then begin //additional output
      updatedestinfo(po1^.destinations[int2+1].destinput,
                                @po1^.outputs[int3].fvalue,dest[int2]);
     end
     else begin
      updatedestinfo(po1^.destinations[int2+1].destinput,handlerinfo.dest,
                                                                   dest[int2]);
     end;
    end;
   end;
  end;
 end;
 include(fstate,scs_modelvalid);
 clear;
 checktick;
 if assigned(fonafterupdatemodel) then begin
  application.lock;
  try
   fonafterupdatemodel(self);
  finally
   application.unlock;
  end;
 end;
end;

procedure tsigcontroller.internalstep;
var
 int1,int2: integer;
 po1: psighandlernodeinfoty;
begin
 po1:= pointer(fexecinfo);
 for int1:= 0 to fexechigh do begin
  po1^.handler(psighandlerinfoty(po1));
  with po1^.firstdest do begin
   if hasscale then begin
    dest^:= source^*gain+offset;
   end;
  end;
  for int2:= 0 to po1^.desthigh do begin //multi inputs on output
   with po1^.dest[int2] do begin
    dest^:= source^;
    if hasscale then begin
     dest^:= dest^*gain+offset;
    end;
   end;    
  end;
  inc(po1);
 end;
end;

procedure tsigcontroller.step(acount: integer);    
var
 int1: integer;
 bo1: boolean;
begin
 if not (scs_modelvalid in fstate) then begin
  updatemodel;
 end;
 bo1:= false;
 if assigned(fonbeforestep) then begin
  fonbeforestep(self,acount,bo1);
 end;
 if not bo1 then begin
  if scs_hastick in fstate then begin
   fticktime:= fticktime + acount;
   while fticktime > 0 do begin
    dotick;
    dec(fticktime,ftickdiv);
   end;
  end;
  lock;
  try
   for int1:= acount-1 downto 0 do begin
    internalstep;
   end;
  finally
   unlock;
  end;
  if assigned(fonafterstep) then begin
   fonafterstep(self,acount);
  end;
 end;
end;

procedure tsigcontroller.checkmodel;
begin
 if not (scs_modelvalid in fstate) then begin
  updatemodel;
 end;
end;

procedure tsigcontroller.loaded;
begin
 inherited;
 modelchange;
end;

procedure tsigcontroller.clear;
var
 int1: integer;
begin
 for int1:= 0 to high(fclients) do begin
  fclients[int1].clear;
 end;
end;

procedure tsigcontroller.lock;
begin
 sys_mutexlock(fmutex);
 inc(flockcount);
end;

procedure tsigcontroller.unlock;
begin
 dec(flockcount);
 sys_mutexunlock(fmutex);
end;

procedure tsigcontroller.internalexecevent(const ainfopo: psiginfoty);
var
 po1: psiginfoty;
 handlerinfo: sighandlerinfoty;
 do1: double;
 int1: integer;
begin
 handlerinfo.dest:= @do1;
 with ainfopo^ do begin
  handler(@handlerinfo);
  for int1:= 0 to high(destinations) do begin
   with destinations[int1] do begin
    with destinput do begin
     if outputindex = 0 then begin
      fvalue:= do1*fgain+foffset;
     end
     else begin
      fvalue:= outputs[outputindex].fvalue*fgain+foffset;
     end;
    end;
   end;
  end;
  for int1:= 0 to high(eventdestinations) do begin
   internalexecevent(eventdestinations[int1]);
  end;
 end;
end;

procedure tsigcontroller.execevent(const aintf: isigclient);
begin
// lock;
 checkmodel;
// try
  internalexecevent(aintf.getsigclientinfopo^.infopo);
// finally
//  unlock;
// end;
end;

procedure tsigcontroller.settickdiv(const avalue: integer);
begin
 ftickdiv:= avalue;
 if ftickdiv <= 0 then begin
  ftickdiv:= 0;
 end;
end;

procedure tsigcontroller.checktick;
begin
 if (fticks <> nil) or assigned(fonbeforetick) or assigned(fonaftertick) then begin
  include(fstate,scs_hastick);
 end
 else begin
  exclude(fstate,scs_hastick);
 end;
end;

procedure tsigcontroller.dotick;
var
 int1: integer;
begin
 if assigned(fonbeforetick) then begin
  fonbeforetick(self);
 end;
 for int1:= high(fticks) downto 0 do begin
  fticks[int1];
 end;
 if assigned(fonaftertick) then begin
  fonaftertick(self);
 end;
end;

procedure tsigcontroller.setonbeforetick(const avalue: notifyeventty);
begin
 fonbeforetick:= avalue;
 checktick;
end;

procedure tsigcontroller.setonaftertick(const avalue: notifyeventty);
begin
 fonaftertick:= avalue;
 checktick;
end;

procedure tsigcontroller.lockapplication;
var
 int1: integer;
begin
 flockapplocks:= flockcount;
 for int1:= flockcount - 1 downto 0 do begin
  unlock;
 end;
 application.lock;
end;

procedure tsigcontroller.unlockapplication;
var
 int1: integer;
begin
 application.unlock;
 for int1:= flockapplocks - 1 downto 0 do begin
  lock;
 end;
end;

function tsigcontroller.getnodenamepath(const aintf: isigclient): string;
begin
 result:= ownernamepath(aintf.getcomponent);
end;

{ tsigwavetable }

constructor tsigwavetable.create(aowner: tcomponent);
begin
 inherited;
 ffrequency:= tdoubleinputconn.create(self,isigclient(self));
 ffrequency.name:= 'frequency';
 ffrequfact:= tdoubleinputconn.create(self,isigclient(self));
 ffrequfact.name:= 'frequfact';
 ffrequfact.fvalue:= 1;
 fphase:= tdoubleinputconn.create(self,isigclient(self));
 fphase.name:= 'phase';
 famplitude:= tdoubleinputconn.create(self,isigclient(self));
 famplitude.name:= 'amplitude';
end;

procedure tsigwavetable.setfrequency(const avalue: tdoubleinputconn);
begin
 ffrequency.assign(avalue);
end;

procedure tsigwavetable.setfrequfact(const avalue: tdoubleinputconn);
begin
 ffrequfact.assign(avalue);
end;

procedure tsigwavetable.setphase(const avalue: tdoubleinputconn);
begin
 fphase.assign(avalue);
end;

procedure tsigwavetable.setamplitude(const avalue: tdoubleinputconn);
begin
 famplitude.assign(avalue);
end;

function tsigwavetable.gethandler: sighandlerprocty;
begin
 if siwto_intpol in foptions then begin
  result:= {$ifdef FPC}@{$endif}sighandlerintpol;
 end
 else begin
  result:= {$ifdef FPC}@{$endif}sighandler;
 end;
end;

procedure tsigwavetable.sighandler(const ainfo: psighandlerinfoty);
var
 int1: integer;
begin
 int1:= trunc((ftime+fphasepo^)*ftablelength) mod ftablelength;
 if int1 < 0 then begin
  int1:= int1 + ftablelength;
 end;
 ainfo^.dest^:= ftable[int1] * famplitudepo^;
 ftime:= frac(ftime+ffrequencypo^*ffrequfactpo^);
end;

procedure tsigwavetable.sighandlerintpol(const ainfo: psighandlerinfoty);
var
 int1: integer;
 do1: double;
begin
 do1:= (ftime+fphasepo^)*ftablelength;
 int1:= trunc(do1) mod ftablelength;
 if int1 < 0 then begin
  int1:= int1 + ftablelength;
 end;
 ainfo^.dest^:= (ftable[int1] + 
                 (ftable[(int1+1) mod ftablelength] - ftable[int1]) * 
                 ((do1-int1)/ftablelength)
                ) * famplitudepo^;
 ftime:= frac(ftime+ffrequencypo^*ffrequfactpo^);
end;


procedure tsigwavetable.settable(const avalue: doublearty);
begin
 ftable:= avalue;
 checktable;
end;

procedure tsigwavetable.clear;
begin
 inherited;
 lock;
 try
  if canevent(tmethod(foninittable)) then begin
   foninittable(self,realarty(ftable));
  end;
  checktable;
 finally
  unlock;
 end;
end;

procedure tsigwavetable.checktable;
begin
 lock;
 try
  ftime:= 0;
  if ftable = nil then begin
   setlength(ftable,1);
  end;
  ftablelength:= length(ftable);
  sendchangeevent;
 finally
  unlock;
 end;
end;

procedure tsigwavetable.initmodel;
begin
 ffrequencypo:= @ffrequency.fvalue;
 ffrequfactpo:= @ffrequfact.fvalue;
 fphasepo:= @fphase.fvalue;
 famplitudepo:= @famplitude.fvalue;
 inherited;
end;

function tsigwavetable.getinputar: inputconnarty;
begin
 setlength(result,4);
 result[0]:= ffrequency;
 result[1]:= ffrequfact;
 result[2]:= fphase;
 result[3]:= famplitude;
end;

function tsigwavetable.getzcount: integer;
begin
 result:= 1;
end;

procedure tsigwavetable.setoptions(const avalue: sigwavetableoptionsty);
begin
 if avalue <> foptions then begin
  foptions:= avalue;
  if fcontroller <> nil then begin
   fcontroller.modelchange;
  end;
 end;
end;

procedure tsigwavetable.setmaster(const avalue: tsigwavetable);
var
 tab1: tsigwavetable;
begin
 if avalue <> fmaster then begin
  tab1:= avalue;
  while tab1 <> nil do begin
   if tab1 = self then begin
    raise exception.create('Recursive master.');
   end;
   tab1:= tab1.master;
  end;
  setlinkedvar(avalue,fmaster);
  if avalue <> nil then begin
   table:= avalue.table;
  end;
 end;
end;

procedure tsigwavetable.objectevent(const sender: tobject;
               const event: objecteventty);
begin
 if (event = oe_changed) and (sender <> nil) and (sender = master) then begin
  table:= master.table;
 end;
end;

{ tsigfuncttable }

constructor tsigfuncttable.create(aowner: tcomponent);
begin
 inherited;
 famplitude:= tdoubleinputconn.create(self,isigclient(self));
 famplitude.name:= 'amplitude';
 famplitudepo:= @famplitude.fvalue;
// finput:= tdoubleinputconn.create(self,isigclient(self));
// finput.name:= 'input';
end;
{
procedure tsigfuncttable.setinput(const avalue: tdoubleinputconn);
begin
 finput.assign(avalue);
end;
}
procedure tsigfuncttable.setamplitude(const avalue: tdoubleinputconn);
begin
 famplitude.assign(avalue);
end;

function tsigfuncttable.gethandler: sighandlerprocty;
begin
 result:= @sighandler;
end;

procedure tsigfuncttable.initmodel;
begin
 inherited;
end;

function tsigfuncttable.getinputar: inputconnarty;
begin
 setlength(result,1);
// result[0]:= finput;
 result[0]:= famplitude;
 stackarray(pointerarty(inherited getinputar),pointerarty(result));
end;

function tsigfuncttable.getzcount: integer;
begin
 result:= 1;
end;

procedure tsigfuncttable.clear;
begin
 inherited;
 lock;
 try
  if canevent(tmethod(foninittable)) then begin
   foninittable(self,ftable);
  end;
  checktable;
 finally
  unlock;
 end;
end;

procedure tsigfuncttable.settable(const avalue: complexarty);
begin
 ftable:= avalue;
 checktable;
end;

procedure tsigfuncttable.sighandler(const ainfo: psighandlerinfoty);
var
 int1,int2: integer;
 do1: double;
begin
 do1:= 0;
 for int1:= 0 to finphigh do begin
  do1:= do1 + finps[int1]^;
 end;
 if do1 <= finpmin then begin
  with fsegments[0].defaultnode do begin
   ainfo^.dest^:= (offs + do1 * ramp)*famplitudepo^;
  end;
  exit;
 end
 else begin
  if do1 >= finpmax then begin
   with fsegments[functionsegmentcount-1] do begin
    if nodes <> nil then begin
     with nodes[high(nodes)] do begin
      ainfo^.dest^:= (offs + do1 * ramp)*famplitudepo^;
     end;
    end
    else begin   
     with defaultnode do begin
      ainfo^.dest^:= (offs + do1 * ramp)*famplitudepo^;
     end;
    end;
   end;
   exit;
  end
  else begin
   int1:= trunc((do1-finpmin)*finpfact);
  end;
 end;
 with fsegments[int1] do begin
  if do1 <= defaultnode.xend  then begin
   with defaultnode do begin
    ainfo^.dest^:= (offs + do1 * ramp)*famplitudepo^;
   end;
  end
  else begin
   for int2:= 0 to high(nodes) do begin
    with nodes[int2] do begin
     if do1 <= xend then begin
      ainfo^.dest^:= (offs + do1 * ramp)*famplitudepo^;
      break;
     end;
    end;
   end;
  end;
 end;
end;

procedure tsigfuncttable.checktable;
 procedure calc(const index: integer; out node: functionnodety);
 var 
 den1: double;
 begin
  if index = high(ftable) then begin
   if index = 0 then begin
    den1:= 0;
   end
   else begin
    den1:= ftable[index].re - ftable[index-1].re;
   end;
  end
  else begin
   den1:= ftable[index+1].re - ftable[index].re;
  end;
  with node do begin
   if index >= high(ftable) then begin
    xend:= bigreal;
   end
   else begin
    xend:= ftable[index+1].re;
   end;
   if den1 = 0 then begin
    offs:= ftable[index].im;
    ramp:= 0;
   end
   else begin
    if index = high(ftable) then begin
     ramp:= (ftable[index].im - ftable[index-1].im)/den1;
    end
    else begin
     ramp:= (ftable[index+1].im - ftable[index].im)/den1;
    end;
    offs:= ftable[index].im - ftable[index].re*ramp;
   end;
  end;
 end;
var
 int1,int2: integer;
 ar1: booleanarty;
 po1: pfunctionsegmentty;
begin
 lock;
 try
  finalize(fsegments);
  fillchar(fsegments,sizeof(fsegments),0);
  finpmin:= 0;
  finpmax:= 0;
  finpfact:= 0;
  if high(ftable) >= 0 then begin
   finpmin:= bigreal;
   finpmax:= -bigreal;
   for int1:= 0 to high(ftable) do begin
    with ftable[int1] do begin
     if (int1 > 0) and (re < ftable[int1-1].re) then begin
      raise exception.create('Invalid table order');
     end;
     if re < finpmin then begin
      finpmin:= re;
     end;
     if re > finpmax then begin
      finpmax:= re;
     end;
    end;
   end;
   finpfact:= finpmax-finpmin;
   if finpfact > 0 then begin
    finpfact:= functionsegmentcount/finpfact;
   end
   else begin
    finpfact:= 0;
   end;
   setlength(ar1,functionsegmentcount);
   for int1:= 0 to high(ftable) do begin
    int2:= trunc((ftable[int1].re-finpmin)*finpfact);
    if int2 >= functionsegmentcount then begin
     int2:= functionsegmentcount-1;
    end;
    if int2 < 0 then begin
     int2:= 0;
    end;
    with fsegments[int2] do begin
     if ar1[int2] or (int2 > 0) then begin //multiple nodes
      setlength(nodes,high(nodes)+2);
      calc(int1,nodes[high(nodes)]);
     end
     else begin
      calc(int1,defaultnode);
     end;
     ar1[int2]:= true;
    end;
   end;
   po1:= @fsegments[0];
   for int1:= 1 to high(fsegments) do begin
    if po1^.nodes = nil then begin
     fsegments[int1].defaultnode:= po1^.defaultnode;
    end
    else begin
     fsegments[int1].defaultnode:= po1^.nodes[high(po1^.nodes)];
    end;
    inc(po1);
   end;
  end;
  sendchangeevent;
 finally
  unlock;
 end;
end;

procedure tsigfuncttable.setmaster(const avalue: tsigfuncttable);
var
 tab1: tsigfuncttable;
begin
 if avalue <> fmaster then begin
  tab1:= avalue;
  while tab1 <> nil do begin
   if tab1 = self then begin
    raise exception.create('Recursive master.');
   end;
   tab1:= tab1.master;
  end;
  setlinkedvar(avalue,fmaster);
  if avalue <> nil then begin
   table:= avalue.table;
  end;
 end;
end;

procedure tsigfuncttable.objectevent(const sender: tobject;
               const event: objecteventty);
begin
 if (event = oe_changed) and (sender <> nil) and (sender = master) then begin
  table:= master.table;
 end;
end;

{ tsigenvelope }

constructor tsigenvelope.create(aowner: tcomponent);
begin
 fmin:= 0.001;
 fmax:= 1;
 freleasestart:= 1;
 ftimescale:= 1;
 floopstart:= -1;
 fdecay_options:= [sero_exp];
 frelease_options:= [sero_exp];
 inherited;
 ftrigger:= tchangedoubleinputconn.create(self,isigclient(self),
                                                             @dotriggerchange);
 ftrigger.name:= 'trigger';
 famplitude:= tdoubleinputconn.create(self,isigclient(self));
 famplitude.name:= 'amplitude';
 famplitude.value:= 1;
end;

procedure tsigenvelope.lintoexp(var avalue: double);
var
 scale,offset: double;
 do1: double;
begin
 if (fmin > 0) and (fmax > 0) then begin
  offset:= ln(fmin);
  scale:= ln(fmax)-offset;
  if scale <> 0 then begin
   do1:= avalue*(fmax-fmin)+fmin;
   if do1 > 0 then begin
    avalue:= (ln(do1) - offset)/scale;
   end;
  end;
 end;
end;

procedure tsigenvelope.exptolin(var avalue: double);
var
 scale,offset: double;
 do1: double;
begin
 if (fmin > 0) and (fmax > 0) then begin
  offset:= ln(fmin);
  scale:= ln(fmax)-offset;
  do1:= fmax-fmin;
  if do1 <> 0 then begin
   avalue:= (exp(avalue*scale+offset)-fmin)/do1;
  end;
 end;
end;

procedure tsigenvelope.updatevalues;
var
 timsca: double;
 timoffs: double;
 isexpbefore: boolean;
 isexpbeforeset: boolean;

 procedure setscale(const options: sigenveloperangeoptionsty;
                        const progindex: integer; var sta: double);
 var
  do1: double;
 begin
  with fprog[progindex] do begin   
   isexp:= sero_exp in options;
   if isexp then begin
    if (fmin > 0) and (fmax > 0) then begin
     offset:= ln(fmin);
     scale:= ln(fmax)-offset;
    end
    else begin
     scale:= 1; //invalid
     offset:= 0;
    end;
    if isexpbeforeset and not isexpbefore then begin
     lintoexp(sta);
    end;
   end
   else begin
    offset:= fmin;
    scale:= fmax-fmin;
    if isexpbeforeset and isexpbefore then begin
     exptolin(sta);
    end;
   end;
   isexpbefore:= isexp;
   isexpbeforeset:= true;
  end;
 end; //setscale
 
 procedure setend(const options: sigenveloperangeoptionsty;
                      var progindex: integer; var ti: integer; var sta: real);
 begin
  setscale(options,progindex,sta);
  with fprog[progindex] do begin //end item
   startval:= sta;
   ramp:= 0;
   starttime:= ti;
   endtime:= -1;
   inc(progindex);
  end;
 end; //setend

 procedure calc(const options: sigenveloperangeoptionsty;
                   const valueitem: complexty; var progindex: integer;
                                            var ti: integer; var sta: real);
 var
  int3: integer;
 begin
  setscale(options,progindex,sta);
  with fprog[progindex] do begin
   starttime:= ti;
   startval:= sta;
   int3:= ti;
   ti:= round((valueitem.re+timoffs)*timsca);
   endtime:= ti;
   if int3 >= ti then begin
    int3:= ti-1;
   end;
   ramp:= (valueitem.im - sta)/(ti-int3);
   sta:= valueitem.im;
  end;
  inc(progindex);
 end; //calc

 
var
 int1,int2,int3: integer;
 ti: integer;
 sta: double;
 do1: double;
 aftertrigvalues: complexarty;
 decaystart: double;
 opt1: sigenveloperangeoptionsty;
  
begin
 if fupdating > 0 then begin
  exit;
 end;
 lock;
 try
  isexpbefore:= false;
  isexpbeforeset:= false;
  int1:= high(fattack_values);
  allocuninitedarray(int1+high(fdecay_values)+2,sizeof(complexty),
                                                       aftertrigvalues);
  for int2:= 0 to int1 do begin
   aftertrigvalues[int2]:= fattack_values[int2];
  end;
  if int1 >= 0 then begin
   decaystart:= fattack_values[int1].re;
  end
  else begin
   decaystart:= 0;
  end;
  inc(int1);
  for int2:= 0 to high(fdecay_values) do begin
   with aftertrigvalues[int2+int1] do begin
    re:= fdecay_values[int2].re + decaystart;
    im:= fdecay_values[int2].im;
   end;
  end;
  fprog:= nil;
  timoffs:= 0;
  timsca:= 1;
  if fcontroller <> nil then begin
   timsca:= timsca * fcontroller.samplefrequ;
  end;
  ftime:= 0;
  fattackval:= 0;
  fattackramp:= 0;
  floopstartindex:= -1;
  floopendindex:= -1;
  floopval:= 0;
  floopramp:= 1;
  freleaseindex:= -1;
  freleaseval:= 0;
  freleaseramp:= 0;
  
  int1:= high(aftertrigvalues) + 2; //+ enditem
  if floopstart >= 0 then begin
   for int2:= 0 to high(fdecay_values) do begin
    if fdecay_values[int2].re >= floopstart then begin
     floopstartindex:= int2+length(fattack_values); //fvaluestrig index
     floopendindex:= length(aftertrigvalues);
     break;
    end;
   end;
  end;
  if high(aftertrigvalues) >= 0 then begin
   fattackval:= aftertrigvalues[0].im;
   freleasestart:= aftertrigvalues[high(aftertrigvalues)].re;
  end;
 
  if high(frelease_values) >= 0 then begin
   int1:= int1 + high(frelease_values) + 2; //+enditem
   freleaseval:= frelease_values[0].im;
   freleaseramp:= frelease_values[0].re;
   if freleaseramp > 0 then begin
    freleaseramp:= 1/(freleaseramp*timsca);
   end;
  end;
  setlength(fprog,int1);
  findex:= high(fprog); //init inactive
  ti:= 0;
  sta:= fattackval;
  int1:= 0;
  int3:= high(aftertrigvalues);
  for int2:= 0 to high(fattack_values) do begin
   calc(fattack_options,aftertrigvalues[int2],int1,ti,sta);
  end;
  for int2:= length(fattack_values) to int3 do begin
   calc(fdecay_options,aftertrigvalues[int2],int1,ti,sta);
  end;
  if floopstartindex >= 0 then begin
   do1:= sta;
   calc(fdecay_options,makecomplex(
        aftertrigvalues[int3].re+aftertrigvalues[floopstartindex].re-floopstart,
        aftertrigvalues[floopstartindex].im),int1,ti,sta);
   sta:= do1;
   inc(floopstartindex); //fprog index
  end
  else begin
   opt1:= fdecay_options;
   if (fdecay_values = nil) and (fattack_values <> nil) then begin
    opt1:= fattack_options;
   end;
   setend(opt1,int1,ti,sta);
  end;
  if high(frelease_values) >= 0 then begin  
   ti:= 0;
   freleaseindex:= int1; //prog index
   for int2:= 0 to high(frelease_values) do begin
    calc(frelease_options,frelease_values[int2],int1,ti,sta);
   end;
   setend(frelease_options,int1,ti,sta);
  end;
  if fprog[0].endtime > 0 then begin
   fattackramp:= 1/fprog[0].endtime;
  end;
  sendchangeevent;
 finally
  unlock;
 end;
end;

{
function tsigenvelope.getsigoptions: sigclientoptionsty;
begin
 result:= [sco_tick];
end;

procedure tsigenvelope.sigtick;
begin
 fcontroller.execevent(isigclient(self));
end;
}
procedure tsigenvelope.sighandler(const ainfo: psighandlerinfoty);
 
begin
 if fattackpending or (ftrigger.fvalue = 1) then begin
  ftrigger.fvalue:= 0;
  fattackpending:= false;
  ftime:= 0;
  findex:= 0;
  with fprog[0] do begin
   if fcurrisexp and not isexp then begin
    exptolin(fcurrval);
   end;
   if not fcurrisexp and isexp then begin
    lintoexp(fcurrval);
   end;
   ramp:= (fattackval-fcurrval)*fattackramp;
   if ramp = 0 then begin
    startval:= fattackval;
   end
   else begin
    startval:= fcurrval;
   end;
  end;
 end;
 if freleasepending or (ftrigger.fvalue = -1) then begin
  ftrigger.fvalue:= 0;
  freleasepending:= false;
  if freleaseindex >= 0 then begin
   ftime:= 0;
   findex:= freleaseindex;
   with fprog[findex] do begin
    if fcurrisexp and not isexp then begin
     exptolin(fcurrval);
    end;
    if not fcurrisexp and isexp then begin
     lintoexp(fcurrval);
    end;
    ramp:= (freleaseval-fcurrval)*freleaseramp;
    if ramp = 0 then begin
     startval:= freleaseval;
    end
    else begin
     startval:= fcurrval;
    end;
   end;
  end;
 end;
 with fprog[findex] do begin
  fcurrisexp:= isexp;
  fcurrval:= startval+ramp*(ftime-starttime);
  if isexp then begin
   if (fcurrval <= 0) and not (seo_nozero in foptions) then begin
    ainfo^.dest^:= 0;
   end
   else begin
    ainfo^.dest^:= exp(fcurrval*scale + offset)*famplitudepo^;
   end;
  end
  else begin
   ainfo^.dest^:= (fcurrval*scale + offset)*famplitudepo^;
  end;
  if endtime >= 0 then begin
   inc(ftime);
   if (ftime > endtime) then begin
    if findex = floopendindex then begin
     findex:= floopstartindex;
     ftime:= fprog[floopstartindex].starttime;
    end
    else begin
     inc(findex);
    end;
   end;
  end;
 end;
end;

function tsigenvelope.gethandler: sighandlerprocty;
begin
 result:= @sighandler;
end;

procedure tsigenvelope.setattack_values(const avalue: complexarty);
begin
 fattack_values:= avalue;
 updatevalues;
end;

procedure tsigenvelope.setdecay_values(const avalue: complexarty);
begin
 fdecay_values:= avalue;
 updatevalues;
end;

procedure tsigenvelope.setrelease_values(const avalue: complexarty);
begin
 frelease_values:= avalue;
 updatevalues;
end;

procedure tsigenvelope.setloopstart(const avalue: real);
begin
 floopstart:= avalue;
 updatevalues;
end;
{
procedure tsigenvelope.setdecaystart(const avalue: real);
begin
 fdecaystart:= avalue;
 updatevalues;
end;
}
{
procedure tsigenvelope.setaftertrigvalues(const avalue: complexarty);
begin
 faftertrigvalues:= avalue;
 updatevalues;
end;
}

procedure tsigenvelope.settrigger(const avalue: tchangedoubleinputconn);
begin
 ftrigger.assign(avalue);
end;

function tsigenvelope.getinputar: inputconnarty;
begin
 setlength(result,2);
 result[0]:= ftrigger;
 result[1]:= famplitude;
end;

function tsigenvelope.getzcount: integer;
begin
 result:= 1;
end;

procedure tsigenvelope.initmodel;
begin
 inherited;
 famplitudepo:= @famplitude.fvalue;
 updatevalues;
end;

procedure tsigenvelope.setmin(const avalue: real);
begin
 fmin:= avalue;
 updatevalues;
end;

procedure tsigenvelope.setmax(const avalue: real);
begin
 fmax:= avalue;
 updatevalues;
end;

procedure tsigenvelope.setoptions(const avalue: sigenvelopeoptionsty);
begin
 if avalue <> foptions then begin
  foptions:= avalue;
  updatevalues;
 end;
end;

procedure tsigenvelope.dotriggerchange(const sender: tobject);
begin
 if ftrigger.fvalue = 1 then begin
  fattackpending:= true;
 end;
 if ftrigger.fvalue = -1 then begin
  freleasepending:= true;
 end;
 ftrigger.fvalue:= 0;
end;

procedure tsigenvelope.start;
begin
 lock;
 fattackpending:= true;
 unlock;
end;

procedure tsigenvelope.stop;
begin
 lock;
 freleasepending:= true;
 unlock;
end;

procedure tsigenvelope.update;
begin
 inherited;
 updatevalues;
end;

procedure tsigenvelope.setattack_options(const avalue: sigenveloperangeoptionsty);
begin
 if fattack_options <> avalue then begin
  fattack_options:= avalue;
  updatevalues;
 end;
end;

procedure tsigenvelope.setdecay_options(const avalue: sigenveloperangeoptionsty);
begin
 if fdecay_options <> avalue then begin
  fdecay_options:= avalue;
  updatevalues;
 end;
end;

procedure tsigenvelope.setrelease_options(const avalue: sigenveloperangeoptionsty);
begin
 if frelease_options <> avalue then begin
  frelease_options:= avalue;
  updatevalues;
 end;
end;

procedure tsigenvelope.dosync;
begin
 attack_values:= master.attack_values;
 decay_values:= master.decay_values;
 release_values:= master.release_values;
 loopstart:= master.loopstart;
end;

procedure tsigenvelope.setmaster(const avalue: tsigenvelope);
var
 env1: tsigenvelope;
begin
 if avalue <> fmaster then begin
  env1:= avalue;
  while env1 <> nil do begin
   if env1 = self then begin
    raise exception.create('Recursive master.');
   end;
   env1:= env1.master;
  end;
  setlinkedvar(avalue,fmaster);
  if avalue <> nil then begin
   dosync;
  end;
 end;
end;

procedure tsigenvelope.objectevent(const sender: tobject;
               const event: objecteventty);
begin
 if (event = oe_changed) and (sender <> nil) and (sender = master) then begin
  dosync;
 end;
end;

procedure tsigenvelope.setamplitude(const avalue: tdoubleinputconn);
begin
 famplitude.assign(avalue);
end;

{ tchangedoubleinputconn }

constructor tchangedoubleinputconn.create(const aowner: tcomponent;
               const asigintf: isigclient; const aonchange: notifyeventty);
begin
 fonchange:= aonchange;
 inherited create(aowner,asigintf);
end;

procedure tchangedoubleinputconn.setvalue(const avalue: double);
begin
 lock;
 inherited;
 if tmsecomponent(owner).canevent(tmethod(fonchange)) then begin
  try
   fonchange(self);
  finally
   unlock
  end;
 end
 else begin
  unlock;
 end;
end;

{ tsigsampler }

constructor tsigsampler.create(aowner: tcomponent);
begin
 fbufferlength:= defaultsamplecount;
 frefreshus:= -1;
 inherited;
 ftrigger:= tchangedoubleinputconn.create(self,isigclient(self),
                                                             @dotriggerchange);
 ftrigger.name:= 'trigger';
 ftriggerlevel:= tchangedoubleinputconn.create(self,isigclient(self),
                                                             @dotriggerchange);
 ftriggerlevel.name:= 'triggerlevel';
 ftimer:= tsimpletimer.create(0,@dotimer,false,[to_leak]);
end;

destructor tsigsampler.destroy;
begin
 ftimer.free;
 inherited;
end;

function tsigsampler.gethandler: sighandlerprocty;
begin
 result:= @sighandler;
end;

procedure tsigsampler.sighandler(const ainfo: psighandlerinfoty);
var
 int1: integer;
 do1: double;
begin
 if not frunning and fstarted then begin
  if fnegtrig then begin
   do1:= ftrigger.value-ftriggerlevel.value;
  end
  else begin
   do1:= ftriggerlevel.value-ftrigger.value;
  end;
  if do1 >= 0 then begin
//   if do1 = 0 then begin
//    fpretrigger:= true;
//   end;
   if fpretrigger then begin
    fbufpo:= 0;
    frunning:= true;
    fstarted:= false;
   end;
  end
  else begin
   fpretrigger:= true;
  end;
 end;
 if frunning then begin
  for int1:= 0 to high(fsigbuffer) do begin
   fsigbuffer[int1][fbufpo]:= finps[int1]^;
  end;
  inc(fbufpo);
  if fbufpo = fbufferlength then begin
   frunning:= false;
   dobufferfull;
  end;
 end
 else begin
  if fstartpending then begin
   fstartpending:= false;
   start;
  end;
 end;
end;

procedure tsigsampler.clear;
begin
// fstarted:= false;
 frunning:= false;
 inherited;
end;

procedure tsigsampler.setbufferlength(const avalue: integer);
begin
 if fbufferlength <> avalue then begin
  lock;
  if avalue = 0 then begin
   fbufferlength:= 1;
  end
  else begin
   fbufferlength:= avalue;
  end;
  modelchange;
  unlock;
 end;
end;

procedure tsigsampler.initmodel;
var
 int1: integer;
begin
 inherited;
 fsigbuffer:= nil;
 setlength(fsigbuffer,finputs.count);
 for int1:= 0 to high(fsigbuffer) do begin
  setlength(fsigbuffer[int1],fbufferlength);
 end;
end;

procedure tsigsampler.settrigger(const avalue: tchangedoubleinputconn);
begin
 ftrigger.assign(avalue);
end;

procedure tsigsampler.settriggerlevel(const avalue: tchangedoubleinputconn);
begin
 ftriggerlevel.assign(avalue);
end;

procedure tsigsampler.dotriggerchange(const sender: tobject);
begin
 //dummy
end;

procedure tsigsampler.start;
begin
 lock;
 fstarted:= true;
 frunning:= false;
 fpretrigger:= false;
 unlock;
end;

procedure tsigsampler.dobufferfull;
begin
 if assigned(fonbufferfull) then begin
  fonbufferfull(self,fsigbuffer);
 end;
end;

function tsigsampler.getinputar: inputconnarty;
begin
 setlength(result,2);
 result[0]:= ftrigger;
 result[1]:= ftriggerlevel;
 stackarray(pointerarty(inherited getinputar),pointerarty(result));
end;

procedure tsigsampler.setoptions(const avalue: sigsampleroptionsty);
begin
 if foptions <> avalue then begin
  foptions:= avalue;
  updateoptions(foptions);
  fnegtrig:= sso_negtrig in foptions;
 end;
end;

procedure tsigsampler.setrefreshus(const avalue: integer);
begin
 if frefreshus <> avalue then begin
  frefreshus:= avalue;
  if avalue < 0 then begin
   ftimer.enabled:= false;
  end
  else begin
   ftimer.interval:= avalue;
   if componentstate * [csloading,csdesigning] = [] then begin
    ftimer.enabled:= true;
   end;
  end;
 end;
end;

procedure tsigsampler.dotimer(const sender: tobject);
begin
 lock;
 if not fstarted and not frunning then begin
  start;
 end
 else begin
  fstartpending:= true;
 end;
 unlock;
end;

procedure tsigsampler.loaded;
begin
 inherited;
 if (frefreshus >= 0) and not (csdesigning in componentstate) then begin
  ftimer.enabled:= true;
 end;
end;

procedure tsigsampler.updateoptions(var avalue: sigsampleroptionsty);
begin
 exclude(avalue,sso_fftmag);
end;

{ tdoublesiginoutcomp }

constructor tdoublesiginoutcomp.create(aowner: tcomponent);
begin
 finput:= tdoubleinputconn.create(self,isigclient(self));
 finputpo:= @finput.fvalue;
 inherited;
end;

procedure tdoublesiginoutcomp.setinput(const avalue: tdoubleinputconn);
begin
 finput.assign(avalue);
end;

function tdoublesiginoutcomp.getinputar: inputconnarty;
begin
 setlength(result,1);
 result[0]:= finput;
end;

{ tsigconnector }

function tsigconnector.gethandler: sighandlerprocty;
begin
 result:= @sighandler;
end;

procedure tsigconnector.sighandler(const ainfo: psighandlerinfoty);
begin
 ainfo^.dest^:= finputpo^;
end;

{ ttrigconnector }

constructor ttrigconnector.create(aowner: tcomponent);
begin
 inherited;
 include(foutput.fstate,ocs_eventdriven);
end;

end.

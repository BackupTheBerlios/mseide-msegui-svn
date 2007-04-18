{
    Copyright (c) 2004 by Joost van der Sluis
    Modified 2006-2007 by Martin Schreiber
    
    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
 
unit mpqconnection;

{$mode objfpc}{$H+}

{$Define LinkDynamically}

interface

uses
  Classes, SysUtils, msqldb, db, dbconst,msedbevents,
{$IfDef LinkDynamically}
  postgres3dyn;
{$Else}
  postgres3;
{$EndIf}

type
  TPQTrans = Class(TSQLHandle)
    protected
    PGConn        : PPGConn;
    ErrorOccured  : boolean;
  end;

  TPQCursor = Class(TSQLCursor)
    protected
    Statement : string;
    tr        : TPQTrans;
    res       : PPGresult;
    CurTuple  : integer;
    Nr        : string;
  end;

 dbeventarty = array of tdbevent;
 
 TPQConnection = class (TSQLConnection,iblobconnection,idbevent,idbeventcontroller)
  private
   FCursorCount         : word;
   FConnectString       : string;
   FSQLDatabaseHandle   : pointer;
   FIntegerDateTimes    : boolean;
   feventcontroller: tdbeventcontroller;
   function TranslateFldType(Type_Oid : integer) : TFieldType;
   function geteventinterval: integer;
   procedure seteventinterval(const avalue: integer);
  protected
   procedure DoInternalConnect; override;
   procedure DoInternalDisconnect; override;
   function GetHandle : pointer; override;

   Function AllocateCursorHandle(const aquery: tsqlquery) : TSQLCursor; override;
   Procedure DeAllocateCursorHandle(var cursor : TSQLCursor); override;
   Function AllocateTransactionHandle : TSQLHandle; override;

   procedure PrepareStatement(cursor: TSQLCursor;ATransaction : TSQLTransaction;buf : string; AParams : TParams); override;
   procedure FreeFldBuffers(cursor : TSQLCursor); override;
   procedure Execute(const cursor: TSQLCursor; const atransaction: tsqltransaction;
                                   const AParams : TParams); override;
   procedure AddFieldDefs(cursor: TSQLCursor; FieldDefs : TfieldDefs); override;
   function Fetch(cursor : TSQLCursor) : boolean; override;
   procedure UnPrepareStatement(cursor : TSQLCursor); override;
   function loadfield(const cursor: tsqlcursor; const afield: tfield;
              const buffer: pointer; var bufsize: integer): boolean; override;
           //if bufsize < 0 -> buffer was to small, should be -bufsize
   function GetTransactionHandle(trans : TSQLHandle): pointer; override;
   function RollBack(trans : TSQLHandle) : boolean; override;
   function Commit(trans : TSQLHandle) : boolean; override;
   procedure CommitRetaining(trans : TSQLHandle); override;
   function StartdbTransaction(trans : TSQLHandle; AParams : string) : boolean; override;
   procedure RollBackRetaining(trans : TSQLHandle); override;
   procedure UpdateIndexDefs(var IndexDefs : TIndexDefs;
                                 const TableName : string); override;
   function GetSchemaInfoSQL(SchemaType : TSchemaType; SchemaObjectName, SchemaPattern : string) : string; override;
   procedure dopqexec(const asql: string);

   function CreateBlobStream(const Field: TField; const Mode: TBlobStreamMode;
                      const acursor: tsqlcursor): TStream; override;
   function getblobdatasize: integer; override;

          //iblobconnection
   procedure writeblobdata(const atransaction: tsqltransaction;
             const tablename: string; const acursor: tsqlcursor;
             const adata: pointer; const alength: integer;
             const afield: tfield; const aparam: tparam;
             out newid: string);
   procedure setupblobdata(const afield: tfield; const acursor: tsqlcursor;
                                   const aparam: tparam);
   function blobscached: boolean;

          //idbevent
   procedure listen(const sender: tdbevent);
   procedure unlisten(const sender: tdbevent);
   procedure fire(const sender: tdbevent);
          //idbeventcontroller
   function getdbevent(var aname: string; var aid: int64): boolean;
               //false if none
   procedure dolisten(const sender: tdbevent);
   procedure dounlisten(const sender: tdbevent);
  public
   constructor Create(AOwner : TComponent); override;
   destructor destroy; override;
   function backendpid: int64; //0 if not connected
   property eventcontroller: tdbeventcontroller read feventcontroller;
  published
    property DatabaseName;
    property KeepConnection;
    property LoginPrompt;
    property Params;
    property OnLogin;
    property eventinterval: integer read geteventinterval 
                     write seteventinterval default defaultdbeventinterval;
  end;

implementation

uses 
 math,msestrings,msestream,msetypes,msedatalist,mseformatstr;

ResourceString
  SErrRollbackFailed = 'Rollback transaction failed';
  SErrCommitFailed = 'Commit transaction failed';
  SErrConnectionFailed = 'Connection to database failed';
  SErrTransactionFailed = 'Start of transacion failed';
  SErrClearSelection = 'Clear of selection failed';
  SErrExecuteFailed = 'Execution of query failed';
  SErrFieldDefsFailed = 'Can not extract field information from query';
  SErrFetchFailed = 'Fetch of data failed';
  SErrPrepareFailed = 'Preparation of query failed.';

const Oid_Bool     = 16;
      Oid_Text     = 25;
      Oid_bytea = 17;
      Oid_Oid      = 26;
      Oid_Name     = 19;
      Oid_Int8     = 20;
      Oid_int2     = 21;
      Oid_Int4     = 23;
      Oid_Float4   = 700;
      Oid_Float8   = 701;
      Oid_Unknown  = 705;
      Oid_bpchar   = 1042;
      Oid_varchar  = 1043;
      Oid_timestamp = 1114;
      oid_date      = 1082;
      oid_time      = 1083;
      oid_numeric   = 1700;
      
 inv_read =  $40000;
 inv_write = $20000;
 invalidoid = 0;

type 
  TDatabasecracker = class(TComponent)
  private
    FConnected : Boolean;
  end;
  
{ tpqconnection }
  
constructor tpqconnection.create(aowner: tcomponent);
begin
 feventcontroller:= tdbeventcontroller.create(idbeventcontroller(self));
 inherited;
 fconnoptions:= fconnoptions + [sqsupportparams];
end;

destructor TPQConnection.destroy;
begin
 inherited;
 feventcontroller.free;
end;

function TPQConnection.GetTransactionHandle(trans : TSQLHandle): pointer;
begin
  Result := trans;
end;

function TPQConnection.RollBack(trans : TSQLHandle) : boolean;
var
  res : PPGresult;
  tr  : TPQTrans;
begin
  result := false;

  tr := trans as TPQTrans;

  res := PQexec(tr.PGConn, 'ROLLBACK');
  if (PQresultStatus(res) <> PGRES_COMMAND_OK) then
    begin
    PQclear(res);
    result := false;
    DatabaseError(SErrRollbackFailed + ' (PostgreSQL: ' + PQerrorMessage(tr.PGConn) + ')',self);
    end
  else
    begin
    PQclear(res);
    PQFinish(tr.PGConn);
    result := true;
    end;
end;

function TPQConnection.Commit(trans : TSQLHandle) : boolean;
var
  res : PPGresult;
  tr  : TPQTrans;
begin
  result := false;

  tr := trans as TPQTrans;

  res := PQexec(tr.PGConn, 'COMMIT');
  if (PQresultStatus(res) <> PGRES_COMMAND_OK) then
    begin
    PQclear(res);
    result := false;
    DatabaseError(SErrCommitFailed + ' (PostgreSQL: ' + PQerrorMessage(tr.PGConn) + ')',self);
    end
  else
    begin
    PQclear(res);
    PQFinish(tr.PGConn);
    result := true;
    end;
end;

function TPQConnection.StartdbTransaction(trans : TSQLHandle; AParams : string) : boolean;
var
  res : PPGresult;
  tr  : TPQTrans;
  msg : string;
begin
  result := false;

  tr := trans as TPQTrans;

  tr.PGConn := PQconnectdb(pchar(FConnectString));

  if (PQstatus(tr.PGConn) = CONNECTION_BAD) then
    begin
    result := false;
    PQFinish(tr.PGConn);
    DatabaseError(SErrConnectionFailed + ' (PostgreSQL: ' + PQerrorMessage(tr.PGConn) + ')',self);
    end
  else
    begin
    tr.ErrorOccured := False;
    res := PQexec(tr.PGConn, 'BEGIN');
    if (PQresultStatus(res) <> PGRES_COMMAND_OK) then
      begin
      result := false;
      PQclear(res);
      msg := PQerrorMessage(tr.PGConn);
      PQFinish(tr.PGConn);
      DatabaseError(sErrTransactionFailed + ' (PostgreSQL: ' + msg + ')',self);
      end
    else
      begin
      PQclear(res);
      result := true;
      end;
    end;
end;

procedure TPQConnection.RollBackRetaining(trans : TSQLHandle);
var
  res : PPGresult;
  tr  : TPQTrans;
  msg : string;
begin
  tr := trans as TPQTrans;
  res := PQexec(tr.PGConn, 'ROLLBACK');
  if (PQresultStatus(res) <> PGRES_COMMAND_OK) then
    begin
    PQclear(res);
    DatabaseError(SErrRollbackFailed + ' (PostgreSQL: ' + PQerrorMessage(tr.PGConn) + ')',self);
    end
  else
    begin
    PQclear(res);
    res := PQexec(tr.PGConn, 'BEGIN');
    if (PQresultStatus(res) <> PGRES_COMMAND_OK) then
      begin
      PQclear(res);
      msg := PQerrorMessage(tr.PGConn);
      PQFinish(tr.PGConn);
      DatabaseError(sErrTransactionFailed + ' (PostgreSQL: ' + msg + ')',self);
      end
    else
      PQclear(res);
    end;
end;

procedure TPQConnection.CommitRetaining(trans : TSQLHandle);
var
  res : PPGresult;
  tr  : TPQTrans;
  msg : string;
begin
  tr := trans as TPQTrans;
  res := PQexec(tr.PGConn, 'COMMIT');
  if (PQresultStatus(res) <> PGRES_COMMAND_OK) then
    begin
    PQclear(res);
    DatabaseError(SErrCommitFailed + ' (PostgreSQL: ' + PQerrorMessage(tr.PGConn) + ')',self);
    end
  else
    begin
    PQclear(res);
    res := PQexec(tr.PGConn, 'BEGIN');
    if (PQresultStatus(res) <> PGRES_COMMAND_OK) then
      begin
      PQclear(res);
      msg := PQerrorMessage(tr.PGConn);
      PQFinish(tr.PGConn);
      DatabaseError(sErrTransactionFailed + ' (PostgreSQL: ' + msg + ')',self);
      end
    else
      PQclear(res);
    end;
end;


procedure TPQConnection.DoInternalConnect;
var 
 msg: string;
 bo1: boolean;
 int1: integer;
begin
{$IfDef LinkDynamically}
 InitialisePostgres3;
{$EndIf}

 inherited dointernalconnect;

 FConnectString := '';
 if (UserName <> '') then FConnectString := FConnectString + ' user=''' + UserName + '''';
 if (Password <> '') then FConnectString := FConnectString + ' password=''' + Password + '''';
 if (HostName <> '') then FConnectString := FConnectString + ' host=''' + HostName + '''';
 if (DatabaseName <> '') then FConnectString := FConnectString + ' dbname=''' + DatabaseName + '''';
 if (Params.Text <> '') then FConnectString := FConnectString + ' '+Params.Text;

 FSQLDatabaseHandle := PQconnectdb(pchar(FConnectString));

 if (PQstatus(FSQLDatabaseHandle) = CONNECTION_BAD) then begin
  msg := PQerrorMessage(FSQLDatabaseHandle);
  dointernaldisconnect;
  DatabaseError(sErrConnectionFailed + ' (PostgreSQL: ' + msg + ')',self);
 end;
// This does only work for pg>=8.0, so timestamps won't work with earlier versions of pg which are compiled with integer_datetimes on
 FIntegerDatetimes := pqparameterstatus(FSQLDatabaseHandle,'integer_datetimes') = 'on';
 with tdatabasecracker(self) do begin
  bo1:= fconnected;
  fconnected:= true;
  feventcontroller.connect;
  fconnected:= bo1;
 end;
end;

procedure TPQConnection.DoInternalDisconnect;
var
 int1: integer;
begin
 feventcontroller.disconnect;
 PQfinish(FSQLDatabaseHandle);
{$IfDef LinkDynamically}
 ReleasePostgres3;
{$EndIf}
end;

function TPQConnection.TranslateFldType(Type_Oid : integer) : TFieldType;

begin
  case Type_Oid of
    Oid_varchar,Oid_bpchar,
    Oid_name               : Result := ftstring;
    Oid_text               : Result := ftstring;
    Oid_bytea              : result := ftBlob;
    Oid_oid                : Result := ftInteger;
    Oid_int8               : Result := ftLargeInt;
    Oid_int4               : Result := ftInteger;
    Oid_int2               : Result := ftSmallInt;
    Oid_Float4             : Result := ftFloat;
    Oid_Float8             : Result := ftFloat;
    Oid_TimeStamp          : Result := ftDateTime;
    Oid_Date               : Result := ftDate;
    Oid_Time               : Result := ftTime;
    Oid_Bool               : Result := ftBoolean;
    Oid_Numeric            : Result := ftBCD;
    Oid_Unknown            : Result := ftUnknown;
  else
    Result := ftUnknown;
  end;
end;

Function TPQConnection.AllocateCursorHandle(const aquery: tsqlquery): TSQLCursor;
begin
 result:= TPQCursor.create(aquery);
end;

Procedure TPQConnection.DeAllocateCursorHandle(var cursor : TSQLCursor);

begin
  FreeAndNil(cursor);
end;

Function TPQConnection.AllocateTransactionHandle : TSQLHandle;

begin
  result := TPQTrans.create;
end;

procedure TPQConnection.PrepareStatement(cursor: TSQLCursor;
            ATransaction : TSQLTransaction;buf : string; AParams : TParams);

const TypeStrings : array[TFieldType] of string =
    (
      'Unknown',  //ftUnknown
      'text',     //ftString 
      'int',      //ftSmallint
      'int',      //ftInteger
      'int',      //ftWord
      'bool',     //ftBoolean
      'float',    //ftFloat
      'numeric',  //ftCurrency
      'numeric',  //ftBCD
      'date',     //ftDate
      'time',     //ftTime
      'timestamp',//ftDateTime
      'Unknown',  //ftBytes
      'Unknown',  //ftVarBytes
      'Unknown',  //ftAutoInc
      'bytea',    //ftBlob
      'text',     //ftMemo
      'bytea',    //ftGraphic
      'Unknown',  //ftFmtMemo
      'Unknown',  //ftParadoxOle
      'Unknown',  //ftDBaseOle
      'Unknown',  //ftTypedBinary
      'Unknown',  //ftCursor
      'Unknown',  //ftFixedChar
      'Unknown',  //ftWideString
      'int',      //ftLargeint
      'Unknown',  //ftADT
      'Unknown',  //ftArray
      'Unknown',  //ftReference
      'Unknown',  //ftDataSet
      'Unknown',  //ftOraBlob
      'Unknown',  //ftOraClob
      'Unknown',  //ftVariant
      'Unknown',  //ftInterface
      'Unknown',  //ftIDispatch
      'Unknown',  //ftGuid
      'Unknown',  //ftTimeStamp
      'Unknown'   //ftFMTBcd
    );


var s : string;
    i : integer;

begin
  with (cursor as TPQCursor) do
    begin
    FPrepared := False;
    nr := inttostr(FCursorcount);
    inc(FCursorCount);
    // Prior to v8 there is no support for cursors and parameters.
    // So that's not supported.
    if FStatementType in [stInsert,stUpdate,stDelete, stSelect] then
      begin
      tr := TPQTrans(aTransaction.Handle);
      // Only available for pq 8.0, so don't use it...
      // Res := pqprepare(tr,'prepst'+name+nr,pchar(buf),params.Count,pchar(''));
      s := 'prepare prepst'+nr+' ';
      if Assigned(AParams) and (AParams.count > 0) then begin
       s:= s + '(';
       for i := 0 to AParams.count-1 do begin
        if TypeStrings[AParams[i].DataType] <> 'Unknown' then begin
         s:= s + TypeStrings[AParams[i].DataType] + ','
        end
        else begin
         if AParams[i].DataType = ftUnknown then begin
          DatabaseErrorFmt(SUnknownParamFieldType,[AParams[i].Name],self);
         end
         else begin
          DatabaseErrorFmt(SUnsupportedParameter,
                       [Fieldtypenames[AParams[i].DataType]],self);
         end;
        end;
       end;
       s[length(s)]:= ')';
       {$ifdef FPC_2_2}
       buf := AParams.ParseSQL(buf,false,false,false,psPostgreSQL);
       {$else}
       buf := AParams.ParseSQL(buf,false,psPostgreSQL);
       {$endif}
      end;
      s:= s + ' as ' + buf;
      res := pqexec(tr.PGConn,pchar(s));
      if (PQresultStatus(res) <> PGRES_COMMAND_OK) then
        begin
        pqclear(res);
        DatabaseError(SErrPrepareFailed + ' (PostgreSQL: ' + PQerrorMessage(tr.PGConn) + ')',self)
        end;
      FPrepared := True;
      end
    else
      statement := buf;
    end;
end;

procedure TPQConnection.UnPrepareStatement(cursor : TSQLCursor);

begin
  with (cursor as TPQCursor) do if FPrepared then
    begin
    if not tr.ErrorOccured then
      begin
      res := pqexec(tr.PGConn,pchar('deallocate prepst'+nr));
      if (PQresultStatus(res) <> PGRES_COMMAND_OK) then
        begin
        pqclear(res);
        DatabaseError(SErrPrepareFailed + ' (PostgreSQL: ' + PQerrorMessage(tr.PGConn) + ')',self)
        end;
      pqclear(res);
      end;
    FPrepared := False;
    end;
end;

procedure TPQConnection.FreeFldBuffers(cursor : TSQLCursor);

begin
// Do nothing
end;

procedure TPQConnection.Execute(const cursor: TSQLCursor; 
           const atransaction: tsqltransaction; const AParams : TParams);

var
 ar: array of pointer;
 i: integer;
 s: string;
 lengths,formats: integerarty;

begin
 with cursor as TPQCursor do begin
  if FStatementType in [stInsert,stUpdate,stDelete,stSelect] then begin
   if Assigned(AParams) and (AParams.count > 0) then begin
    setlength(ar,Aparams.count);
    setlength(lengths,length(ar));
    setlength(formats,length(ar));
    for i := 0 to AParams.count -1 do begin
     with AParams[i] do begin
      if not IsNull then begin
       case DataType of
        ftdatetime: s:= formatdatetime('YYYY-MM-DD',AsDateTime);
        ftdate: s:= formatdatetime('YYYY-MM-DD',AsDateTime);
        ftfloat,ftcurrency: s:= realtostr(asfloat);
        ftbcd: s:= realtostr(ascurrency);
        else begin
         s:= AParams[i].asstring;
         if datatype = ftblob then begin
          lengths[i]:= length(s);
          formats[i]:= 1; //binary
         end;
        end;
       end; {case}
       GetMem(ar[i],length(s)+1);
       StrMove(PChar(ar[i]),Pchar(s),Length(S)+1);
      end
      else begin
       FreeAndNil(ar[i]);
      end;
     end;
    end;
    res := PQexecPrepared(tr.PGConn,pchar('prepst'+nr),Aparams.count,@Ar[0],
             pointer(lengths),pointer(formats),1);
    for i := 0 to AParams.count -1 do begin
     FreeMem(ar[i]);
    end;
   end
   else begin
    res := PQexecPrepared(tr.PGConn,pchar('prepst'+nr),0,nil,nil,nil,1);
   end;
  end
  else begin
    tr := TPQTrans(cursor.ftrans);

    s := statement;
    //Should be altered, just like in TSQLQuery.ApplyRecUpdate
    if assigned(AParams) then for i := 0 to AParams.count-1 do
      s := stringreplace(s,':'+AParams[i].Name,AParams[i].asstring,[rfReplaceAll,rfIgnoreCase]);
    res := pqexec(tr.PGConn,pchar(s));
  end;
  if not (PQresultStatus(res) in [PGRES_COMMAND_OK,PGRES_TUPLES_OK]) then begin
      s := PQerrorMessage(tr.PGConn);
      pqclear(res);

      tr.ErrorOccured := True;
// Don't perform the rollback, only make it possible to do a rollback.
// The other databases also don't do this.
//      atransaction.Rollback;
      DatabaseError(SErrExecuteFailed + ' (PostgreSQL: ' + s + ')',self);
  end;
 end;
end;


procedure TPQConnection.AddFieldDefs(cursor: TSQLCursor; FieldDefs : TfieldDefs);
var
  i         : integer;
  size      : integer;
  st        : string;
  fieldtype : tfieldtype;
  nFields   : integer;

begin
 with tpqcursor(cursor) do begin
  nFields:= PQnfields(Res);
  for i:= 0 to nFields-1 do begin
   size:= PQfsize(Res,i);
   fieldtype:= TranslateFldType(PQftype(Res,i));
   case fieldtype of
    ftstring: begin
     if size = -1 then begin
      size:= pqfmod(res,i)-4;
// WARNING string length is actual bigger for multi byte encodings (utf8!) 
// 5.11.2006 MSE
      if size = -5 then begin
       fieldtype:= ftmemo;
       size:= blobidsize;
//       size:= dsMaxStringSize;
      end;
     end;
    end;
    ftdate: begin
     size:= sizeof(double);
    end;
    ftblob,ftmemo: begin
     size:= blobidsize;
    end;
   end;
   TFieldDef.Create(FieldDefs,PQfname(Res,i),fieldtype,size,False,(i+1));
  end;
  CurTuple:= -1;
 end;
end;

function TPQConnection.GetHandle: pointer;
begin
  Result := FSQLDatabaseHandle;
end;

function TPQConnection.Fetch(cursor : TSQLCursor) : boolean;

var st : string;

begin
  with cursor as TPQCursor do
    begin
    inc(CurTuple);
    Result := (PQntuples(res)>CurTuple);
    end;
end;

function tpqconnection.loadfield(const cursor: tsqlcursor;
      const afield: tfield;
      const buffer: pointer; var bufsize: integer): boolean;
           //if bufsize < 0 -> buffer was to small, should be -bufsize

type TNumericRecord = record
       Digits : SmallInt;
       Weight : SmallInt;
       Sign   : SmallInt;
       Scale  : Smallint;
     end;
const
 numericpos = $0000;
 numericneg = $4000;
 numericnan = $8000;
 numericsigmask = $c000;
 
var
  x,i           : integer;
  li            : Longint;
  CurrBuff      : pchar;
  tel           : byte;
  dbl           : pdouble;
  cur           : currency;
  NumericRecord : ^TNumericRecord;
 int1: integer;
 sint1: smallint;
 
begin
{$ifdef FPC}{$checkpointer off}{$endif}
 with TPQCursor(cursor) do begin
  {
    for x := 0 to PQnfields(res)-1 do
      if PQfname(Res, x) = FieldDef.Name then break;

    if PQfname(Res, x) <> FieldDef.Name then
      DatabaseErrorFmt(SFieldNotFound,[FieldDef.Name],self);
}
  x:= afield.fieldno - 1;
  if pqgetisnull(res,CurTuple,x)=1 then begin
   result := false
  end
  else begin
   i:= PQfsize(res, x);
   CurrBuff := pqgetvalue(res,CurTuple,x);
   result := true;
   case afield.DataType of
    ftInteger, ftSmallint, ftLargeInt,ftfloat: begin
     case i of               // postgres returns big-endian numbers
      sizeof(int64) : pint64(buffer)^ := BEtoN(pint64(CurrBuff)^);
      sizeof(integer) : pinteger(buffer)^ := BEtoN(pinteger(CurrBuff)^);
      sizeof(smallint) : psmallint(buffer)^ := BEtoN(psmallint(CurrBuff)^);
      else begin
       if i > bufsize then begin
        bufsize:= -bufsize;
       end
       else begin
        for tel:= 1 to i do begin
         pchar(Buffer)[tel-1] := CurrBuff[i-tel];
        end;
       end;
      end;
     end;
    end;
    ftString: begin
     li:= pqgetlength(res,curtuple,x);
     if bufsize < li then begin
      bufsize:= -li;
     end
     else begin
      bufsize:= li;
      Move(CurrBuff^,Buffer^,li);
     end;
//         pchar(Buffer + li)^ := #0;
//         i := pqfmod(res,x)-3;
    end;
    ftblob,ftmemo: begin
     li := pqgetlength(res,curtuple,x);
     int1:= addblobdata(currbuff,li);
     move(int1,buffer^,sizeof(int1));
      //save id
    end;
    ftdate: begin
     dbl:= pointer(buffer);
     dbl^:= BEtoN(plongint(CurrBuff)^) + 36526;
     i:= sizeof(double);
    end;
    ftDateTime,fttime: begin
     pint64(buffer)^ := BEtoN(pint64(CurrBuff)^);
     dbl := pointer(buffer);
     if FIntegerDatetimes then begin
      dbl^ := pint64(buffer)^/1000000;
     end;
     dbl^ := (dbl^+3.1558464E+009)/86400;  // postgres counts seconds elapsed since 1-1-2000
     // Now convert the mathematically-correct datetime to the
     // illogical windows/delphi/fpc TDateTime:
     if (dbl^ <= 0) and (frac(dbl^)<0) then begin
       dbl^ := trunc(dbl^)-2-frac(dbl^);
     end;
    end;
    ftBCD: begin
     NumericRecord := pointer(CurrBuff);
     NumericRecord^.Digits := BEtoN(NumericRecord^.Digits);
     NumericRecord^.Scale := BEtoN(NumericRecord^.Scale);
     NumericRecord^.Weight := BEtoN(NumericRecord^.Weight);
     numericrecord^.sign:= beton(numericrecord^.sign);
     inc(pointer(currbuff),sizeof(TNumericRecord));
     cur := 0;
     if numericrecord^.sign and numericnan <> 0 then begin 
//          if (NumericRecord^.Digits = 0) and (NumericRecord^.Scale = 0) then 
// = NaN, which is not supported by Currency-type, so we return NULL 
        //???? 0 in database seems to return digits and scale 0. mse
      result := false;            //nan
     end
     else begin
      for tel := 1 to NumericRecord^.Digits  do begin
        cur := cur + beton(pword(currbuff)^) * intpower(10000,-(tel-1)+
                                     NumericRecord^.weight);
        inc(pointer(currbuff),2);
      end;
      if BEtoN(NumericRecord^.Sign) <> 0 then begin
       cur := -cur;
      end;
      Move(Cur, Buffer^, sizeof(currency));
     end;
    end;
    ftBoolean: begin
     pchar(buffer)[0] := CurrBuff[0]
    end;
    else begin
      result := false;
    end;
   end;
  end;
 end;
{$ifdef FPC}{$checkpointer default}{$endif}
end;

procedure TPQConnection.UpdateIndexDefs(var IndexDefs : TIndexDefs;
                          const TableName : string);

var qry : TSQLQuery;

begin
  if not assigned(Transaction) then
    DatabaseError(SErrConnTransactionnSet);

  qry := tsqlquery.Create(nil);
  qry.transaction := Transaction;
  qry.database := Self;
  with qry do
    begin
    ReadOnly := True;
    sql.clear;

    sql.add('select '+
              'ic.relname as indexname,  '+
              'tc.relname as tablename, '+
              'ia.attname, '+
              'i.indisprimary, '+
              'i.indisunique '+
            'from '+
              'pg_attribute ta, '+
              'pg_attribute ia, '+
              'pg_class tc, '+
              'pg_class ic, '+
              'pg_index i '+
            'where '+
              '(i.indrelid = tc.oid) and '+
              '(ta.attrelid = tc.oid) and '+
              '(ia.attrelid = i.indexrelid) and '+
              '(ic.oid = i.indexrelid) and '+
              '(ta.attnum = i.indkey[ia.attnum-1]) and '+
              '(upper(tc.relname)=''' +  UpperCase(TableName) +''') '+
            'order by '+
              'ic.relname;');
    open;
    end;

  while not qry.eof do with IndexDefs.AddIndexDef do
    begin
    Name := trim(qry.fields[0].asstring);
    Fields := trim(qry.Fields[2].asstring);
    If qry.fields[3].asboolean then options := options + [ixPrimary];
    If qry.fields[4].asboolean then options := options + [ixUnique];
    qry.next;
    while (name = qry.fields[0].asstring) and (not qry.eof) do
      begin
      Fields := Fields + ';' + trim(qry.Fields[2].asstring);
      qry.next;
      end;
    end;
  qry.close;
  qry.free;
end;

function TPQConnection.GetSchemaInfoSQL(SchemaType: TSchemaType;
  SchemaObjectName, SchemaPattern: string): string;

var s : string;

begin
  case SchemaType of
    stTables     : s := 'select '+
                          'relfilenode              as recno, '+
                          '''' + DatabaseName + ''' as catalog_name, '+
                          '''''                     as schema_name, '+
                          'relname                  as table_name, '+
                          '0                        as table_type '+
                        'from '+
                          'pg_class '+
                        'where '+
                          '(relowner > 1) and relkind=''r''' +
                        'order by relname';

    stSysTables  : s := 'select '+
                          'relfilenode              as recno, '+
                          '''' + DatabaseName + ''' as catalog_name, '+
                          '''''                     as schema_name, '+
                          'relname                  as table_name, '+
                          '0                        as table_type '+
                        'from '+
                          'pg_class '+
                        'where '+
                          'relkind=''r''' +
                        'order by relname';
  else
    DatabaseError(SMetadataUnavailable)
  end; {case}
  result := s;
end;

function TPQConnection.CreateBlobStream(const Field: TField;
        const Mode: TBlobStreamMode; const acursor: tsqlcursor): TStream;
var
 blobid: integer;
 int1,int2: integer;
 str1: string;
 bo1: boolean;
begin
 result:= nil;
 if mode = bmread then begin
  if field.getData(@blobId) then begin
   result:= acursor.getcachedblob(blobid);
  end;
 end;
end;

procedure TPQConnection.writeblobdata(const atransaction: tsqltransaction;
               const tablename: string; const acursor: tsqlcursor;
               const adata: pointer; const alength: integer;
               const afield: tfield; const aparam: tparam;
               out newid: string);
var
 str1: string;
 int1: integer;
begin
 setlength(str1,alength);
 move(adata^,str1[1],alength);
 if afield.datatype = ftmemo then begin
  aparam.asstring:= str1;
 end
 else begin
  aparam.asblob:= str1;
 end;
 int1:= acursor.addblobdata(str1);
 setlength(newid,sizeof(int1));
 move(int1,newid[1],sizeof(int1));
end;

procedure TPQConnection.setupblobdata(const afield: tfield; 
                      const acursor: tsqlcursor; const aparam: tparam);
begin
 acursor.blobfieldtoparam(afield,aparam,afield.datatype = ftmemo);
end;

function TPQConnection.getblobdatasize: integer;
begin
 result:= sizeof(integer);
end;

function TPQConnection.blobscached: boolean;
begin
 result:= true;
end;

procedure TPQConnection.dolisten(const sender: tdbevent);
begin
 dopqexec('LISTEN '+sender.eventname+';');
end;

procedure TPQConnection.dounlisten(const sender: tdbevent);
begin
 dopqexec('UNLISTEN '+sender.eventname+';');
end;

procedure TPQConnection.listen(const sender: tdbevent);
begin
 feventcontroller.register(sender);
 if connected then begin
  dolisten(sender);
 end;
end;

procedure TPQConnection.unlisten(const sender: tdbevent);
begin
 if connected then begin
  dounlisten(sender);
 end;
 feventcontroller.unregister(sender);
end;

procedure TPQConnection.fire(const sender: tdbevent);
begin
 dopqexec('NOTIFY '+sender.eventname+';');
end;

function TPQConnection.getdbevent(var aname: string; var aid: int64): boolean;
var
 info: ppgnotify;
begin
 pqconsumeinput(fsqldatabasehandle);
 info:= pqnotifies(fsqldatabasehandle);
 result:= info <> nil;
 if result then begin
  aname:= info^.relname;
  aid:= info^.be_pid;
  pqfreemem(info);
 end;
end;

function TPQConnection.geteventinterval: integer;
begin
 result:= feventcontroller.eventinterval;
end;

procedure TPQConnection.seteventinterval(const avalue: integer);
begin
 feventcontroller.eventinterval:= avalue;
end;

procedure tpqconnection.dopqexec(const asql: string);
var
 res: ppgresult;

begin
 res:= pqexec(fsqldatabasehandle,pchar(asql));
 if pqresultstatus(res) <> pgres_command_ok then begin
  pqclear(res);
  databaseerror('PQExecerror'+ ' (postgresql: ' + 
                        pqerrormessage(fsqldatabasehandle) + ')',self);
 end
 else begin
  pqclear(res);
 end;
end;

function TPQConnection.backendpid: int64;
begin
 if not connected then begin
  result:= 0;
 end
 else begin
  result:= cardinal(pqbackendpid(fsqldatabasehandle));
 end;
end;

{
procedure TPQConnection.writeblobdata(const atransaction: tsqltransaction;
               const tablename: string; const adata: pointer;
               const alength: integer; const aparam: tparam);
               
var
 started: boolean;
 
 procedure endtrans;
 var
  res: ppgresult;
 begin
  res:= pqexec(fsqldatabasehandle,'END');
  pqclear(res);
 end;
 
 procedure doerror;
 begin
  if started then begin
   endtrans;
  end;
  databaseerror('TPQConnection blob write error.');
 end;

 procedure checkerror(const aresult: ppgresult);
 begin
  if PQresultStatus(aresult) <> PGRES_COMMAND_OK then begin
   pqclear(aresult);
   doerror;
  end; 
  pqclear(aresult);
 end;
  
var
 blobid: oid;
 fd: integer;
 int1,int2: integer;
begin
 if alength = 0 then begin
  aparam.clear;
 end
 else begin
  started:= false;
  checkerror(pqexec(fsqldatabasehandle,'BEGIN'));
  started:= true;
  blobid:= lo_creat(fsqldatabasehandle,inv_read or inv_write);
  if blobid = invalidoid then begin
   doerror;
  end;
  fd:= lo_open(fsqldatabasehandle,blobid,inv_write);
  if fd = -1 then begin
   doerror;
  end;
  int1:= alength;
  while int1 > 0 do begin
   int2:= lo_write(fsqldatabasehandle,fd,adata,int1);
   if int2 < 0 then begin
    doerror;
   end;
   dec(int1,int2);
  end; 
  lo_close(fsqldatabasehandle,fd);
  endtrans;
  aparam.asinteger:= blobid;
 end;
end;
}

end.

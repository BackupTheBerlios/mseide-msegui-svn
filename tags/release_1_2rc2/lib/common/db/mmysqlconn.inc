{Modified 2006-2007 by Martin Schreiber}

{$mode objfpc}{$H+}
{$MACRO on}

interface

uses
  Classes, SysUtils,msqldb,db,dynlibs,
{$IfDef mysql50}
  mysql50dyn;
  {$DEFINE TConnectionName:=TMySQL50Connection}
  {$DEFINE TTransactionName:=TMySQL50Transaction}
  {$DEFINE TCursorName:=TMySQL50Cursor}
{$ELSE}
  {$IfDef mysql41}
    mysql41dyn;
    {$DEFINE TConnectionName:=TMySQL41Connection}
    {$DEFINE TTransactionName:=TMySQL41Transaction}
    {$DEFINE TCursorName:=TMySQL41Cursor}
  {$ELSE}
    {$IFDEF mysql4} // temporary backwards compatibility for Lazarus
      mysql40dyn;
      {$DEFINE TConnectionName:=TMySQLConnection}
      {$DEFINE TTransactionName:=TMySQLTransaction}
      {$DEFINE TCursorName:=TMySQLCursor}
    {$ELSE}
      mysql40dyn;
      {$DEFINE TConnectionName:=TMySQL40Connection}
      {$DEFINE TTransactionName:=TMySQL40Transaction}
      {$DEFINE TCursorName:=TMySQL40Cursor}
    {$EndIf}
  {$EndIf}
{$EndIf}

Type
  TTransactionName = Class(TSQLHandle)
  protected
  end;

  TCursorName = Class(TSQLCursor)
  protected
//    FQMySQL : PMySQL;
    FRes: PMYSQL_RES;                   { Record pointer }
    FNeedData : Boolean;
    FStatement : String;
    Row : MYSQL_ROW;
    RowsAffected : QWord;
    LastInsertID : QWord;
    ParamBinding : TParamBinding;
    ParamReplaceString : String;
    MapDSRowToMSQLRow  : array of integer;
    fprimarykeyfieldname: string;
  end;

  TConnectionName = class (TSQLConnection,iblobconnection)
  private
    FDialect: integer;
    FHostInfo: String;
    FServerInfo: String;
    FMySQL : PMySQL;
    FDidConnect : Boolean;
   fport: cardinal;
    function GetClientInfo: string;
    function GetServerStatus: String;
    procedure ConnectMySQL(var HMySQL : PMySQL;H,U,P : pchar);
  protected
//   function stringtosqltext(const afeildtype: tfieldtype; const avalue: string): string;
    function StrToStatementType(s : string) : TStatementType; override;
    Procedure ConnectToServer; virtual;
    Procedure SelectDatabase; virtual;
//    function MySQLDataType(AType: enum_field_types; ASize, ADecimals: Integer; var NewType: TFieldType; var NewSize: Integer): Boolean;
    function MySQLDataType(const afield: mysql_field; var NewType: TFieldType; var NewSize: Integer): Boolean;
    function MySQLWriteData(const acursor: tsqlcursor; AType: enum_field_types;
                        ASize: Integer;
                        AFieldType: TFieldType;Source, Dest: PChar): Boolean;
    // SQLConnection methods
    procedure DoInternalConnect; override;
    procedure DoInternalDisconnect; override;
    function GetHandle : pointer; override;

//    function GetAsSQLText(Field : TField) : string; overload; override;
//    function GetAsSQLText(Param : TParam) : string; overload; override;

    Function AllocateCursorHandle(const aquery: tsqlquery): TSQLCursor; override;
    Procedure DeAllocateCursorHandle(var cursor : TSQLCursor); override;
    Function AllocateTransactionHandle : TSQLHandle; override;

    procedure PrepareStatement(cursor: TSQLCursor;ATransaction : TSQLTransaction;buf : string; AParams : TParams); override;
    procedure UnPrepareStatement(cursor:TSQLCursor); override;
    procedure FreeFldBuffers(cursor : TSQLCursor); override;
    procedure Execute(const cursor: TSQLCursor;
             const atransaction:tSQLtransaction; const AParams : TParams); override;
    procedure AddFieldDefs(cursor: TSQLCursor; FieldDefs : TfieldDefs); override;
    function Fetch(cursor : TSQLCursor) : boolean; override;
    function loadfield(const cursor: tsqlcursor; const afield: tfield;
      const buffer: pointer; var bufsize: integer): boolean; override;
           //if bufsize < 0 -> buffer was to small, should be -bufsize
    function GetTransactionHandle(trans : TSQLHandle): pointer; override;
    function Commit(trans : TSQLHandle) : boolean; override;
    function RollBack(trans : TSQLHandle) : boolean; override;
    function StartdbTransaction(trans : TSQLHandle; AParams : string) : boolean; override;
    procedure internalCommitRetaining(trans : TSQLHandle); override;
    procedure internalRollBackRetaining(trans : TSQLHandle); override;
    procedure UpdateIndexDefs(var IndexDefs : TIndexDefs;
                                          const TableName : string); override;

   function getprimarykeyfield(const atablename: string;
                                 const acursor: tsqlcursor): string; override;
   procedure updateprimarykeyfield(const afield: tfield); override;
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
   
  Public
    function getinsertid: int64; override;
    Property ServerInfo : String Read FServerInfo;
    Property HostInfo : String Read FHostInfo;
    property ClientInfo: string read GetClientInfo;
    property ServerStatus : String read GetServerStatus;
  published
    property Dialect  : integer read FDialect write FDialect;
    property port: cardinal read fport write fport default 0;
    property DatabaseName;
    property HostName;
    property KeepConnection;
    property LoginPrompt;
    property Params;
    property OnLogin;
  end;

  EMySQLError = Class(Exception);

implementation

uses dbconst,msebufdataset;
type
 tmsebufdataset1 = class(tmsebufdataset);
 
{ TConnectionName }

Resourcestring
  SErrServerConnectFailed = 'Server connect failed.';
  SErrDatabaseSelectFailed = 'failed to select database: %s';
  SErrDatabaseCreate = 'Failed to create database: %s';
  SErrDatabaseDrop = 'Failed to drop database: %s';
  SErrNoData = 'No data for record';
  SErrExecuting = 'Error executing query: %s';
  SErrFetchingdata = 'Error fetching row data: %s';
  SErrGettingResult = 'Error getting result set: %s';
  SErrNoQueryResult = 'No result from query.';
  SErrNotversion50 = 'TMySQL50Connection can not work with the installed MySQL client version (%s).';
  SErrNotversion41 = 'TMySQL41Connection can not work with the installed MySQL client version (%s).';
  SErrNotversion40 = 'TMySQL40Connection can not work with the installed MySQL client version (%s).';

Procedure MySQlError(R : PMySQL;Msg: String;Comp : TComponent);

Var
  MySQLMsg : String;

begin
 If (R<>Nil) then
   begin
   MySQLMsg:=Strpas(mysql_error(R));
   DatabaseErrorFmt(Msg,[MySQLMsg],Comp);
   end
 else
   DatabaseError(Msg,Comp);
end;

function TConnectionName.StrToStatementType(s : string) : TStatementType;

begin
  S:=Lowercase(s);
  if s = 'show' then exit(stSelect);
  result := inherited StrToStatementType(s);
end;


function TConnectionName.GetClientInfo: string;

Var
  B : Boolean;

begin
  // To make it possible to call this if there's no connection yet
  B:=(MysqlLibraryHandle=Nilhandle);
  If B then
    InitialiseMysql;
  Try  
    Result:=strpas(mysql_get_client_info());
  Finally  
    if B then
      ReleaseMysql;
  end;  
end;

function TConnectionName.GetServerStatus: String;
begin
  CheckConnected;
  Result := mysql_stat(FMYSQL);
end;

procedure TConnectionName.ConnectMySQL(var HMySQL : PMySQL;H,U,P : pchar);

begin
  HMySQL := mysql_init(HMySQL);
  HMySQL:=mysql_real_connect(HMySQL,PChar(H),PChar(U),Pchar(P),Nil,fport,Nil,0);
  If (HMySQL=Nil) then
    MySQlError(Nil,SErrServerConnectFailed,Self);
end;
{
function tconnectionname.stringtosqltext(const afieldtype: tfieldtype;
                                                const avalue: string): string;
var 
 esc_str : pchar;
begin
 Getmem(esc_str,length(avalue)*2+1);
 mysql_real_escape_string(FMySQL,esc_str,pchar(str1),length(str1));
 Result := '''' + esc_str + '''';
 Freemem(esc_str);
end;

function TConnectionName.GetAsSQLText(Field : TField) : string;
var 
 esc_str : pchar;
 str1: string;
begin
 if (not assigned(field)) or field.IsNull then begin
  Result := 'Null'
 end
 else begin
  if field.DataType in [ftString,ftmemo,ftblob,ftgraphic] then begin
   result:= stringtosqltext(field.datatype,field.asstring);
  end
  else begin
   Result := inherited GetAsSqlText(field);
  end;
 end;
end;

function TConnectionName.GetAsSQLText(Param: TParam) : string;
var 
 esc_str : pchar;
 str1: string;
begin
 if (not assigned(param)) or param.IsNull then begin
  Result:= 'Null'
 end
 else begin
  if param.DataType in [ftString,ftmemo,ftblob,ftgraphic] then begin
   str1:= param.asstring;
   Getmem(esc_str,length(str1)*4+1);
   mysql_real_escape_string(FMySQL,esc_str,pchar(str1),length(str1));
   Result:= '''' + esc_str + '''';
   Freemem(esc_str);
  end
  else begin
   Result:= inherited GetAsSqlText(Param);
  end;
 end;
end;
}

procedure TConnectionName.ConnectToServer;

Var
  H,U,P : String;

begin
  H:=HostName;
  U:=UserName;
  P:=Password;
  ConnectMySQL(FMySQL,pchar(H),pchar(U),pchar(P));
  FServerInfo := strpas(mysql_get_server_info(FMYSQL));
  FHostInfo := strpas(mysql_get_host_info(FMYSQL));
end;

procedure TConnectionName.SelectDatabase;
begin
  if mysql_select_db(FMySQL,pchar(DatabaseName))<>0 then
    MySQLError(FMySQL,SErrDatabaseSelectFailed,Self);
end;

procedure TConnectionName.DoInternalConnect;
begin
  FDidConnect:=(MySQLLibraryHandle=NilHandle);
  if FDidConnect then
    InitialiseMysql;
{$IFDEF mysql50}
  if copy(strpas(mysql_get_client_info()),1,3)<>'5.0' then
    Raise EInOutError.CreateFmt(SErrNotversion50,[strpas(mysql_get_client_info())]);
{$ELSE}
  {$IFDEF mysql41}
  if copy(strpas(mysql_get_client_info()),1,3)<>'4.1' then
    Raise EInOutError.CreateFmt(SErrNotversion41,[strpas(mysql_get_client_info())]);
  {$ELSE}
  if copy(strpas(mysql_get_client_info()),1,3)<>'4.0' then
    Raise EInOutError.CreateFmt(SErrNotversion40,[strpas(mysql_get_client_info())]);
  {$ENDIF}
{$ENDIF}
  inherited DoInternalConnect;
  ConnectToServer;
  SelectDatabase;
end;

procedure TConnectionName.DoInternalDisconnect;
begin
  inherited DoInternalDisconnect;
  mysql_close(FMySQL);
  FMySQL:=Nil;
  if FDidConnect then
    ReleaseMysql;
end;

function TConnectionName.GetHandle: pointer;
begin
  Result:=FMySQL;
end;

function TConnectionName.AllocateCursorHandle(const aquery: tsqlquery): TSQLCursor;
begin
  Result:=TCursorName.Create(aquery);
end;

Procedure TConnectionName.DeAllocateCursorHandle(var cursor : TSQLCursor);

begin
  FreeAndNil(cursor);
end;

function TConnectionName.AllocateTransactionHandle: TSQLHandle;
begin
//  Result:=TTransactionName.Create;
  Result := nil;
end;

procedure TConnectionName.PrepareStatement(cursor: TSQLCursor;
  ATransaction: TSQLTransaction; buf: string;AParams : TParams);
begin
//  if assigned(AParams) and (AParams.count > 0) then
//    DatabaseError('Parameters (not) yet supported for the MySQL SqlDB connection.',self);
  With Cursor as TCursorName do
    begin
    FStatement:=Buf;
    if assigned(AParams) and (AParams.count > 0) then
    {$ifdef FPC_2_2}
      FStatement := AParams.ParseSQL(FStatement,false,false,false,psSimulated,
                       paramBinding,ParamReplaceString);
    {$else}
      FStatement := AParams.ParseSQL(FStatement,false,psSimulated,
                       paramBinding,ParamReplaceString);
    {$endif}
    if FStatementType=stSelect then
      FNeedData:=True;
   {
    ConnectMySQL(FQMySQL,FMySQL^.host,FMySQL^.user,FMySQL^.passwd);
    if mysql_select_db(FQMySQL,pchar(DatabaseName))<>0 then
      MySQLError(FQMySQL,SErrDatabaseSelectFailed,Self);
   }
    end
end;

procedure TConnectionName.UnPrepareStatement(cursor: TSQLCursor);
begin
{
  With Cursor as TCursorName do
    begin
    mysql_close(FQMySQL);
    FQMysql := nil;
    end;
}
end;

procedure TConnectionName.FreeFldBuffers(cursor: TSQLCursor);

Var
  C : TCursorName;

begin
  C:=Cursor as TCursorName;
  if c.FStatementType=stSelect then
    c.FNeedData:=False;
//  if (c.FQMySQL <> Nil) then
//    begin
//    mysql_close(c.FQMySQL);
//    c.FQMySQL:=Nil;
//    end;
  If (C.FRes<>Nil) then
    begin
    Mysql_free_result(C.FRes);
    C.FRes:=Nil;
    end;
  SetLength(c.MapDSRowToMSQLRow,0);
end;

procedure TConnectionName.Execute(const  cursor: TSQLCursor;
               const atransaction: tSQLtransaction; const AParams : TParams);

Var
  C : TCursorName;
  i : integer;

begin
  C:=Cursor as TCursorName;
  If (C.FRes=Nil) then
    begin
    if Assigned(AParams) and (AParams.count > 0) then
      for i := 0 to AParams.count -1 do
        C.FStatement := stringreplace(C.FStatement,C.ParamReplaceString+inttostr(AParams[i].Index+1),GetAsSQLText(AParams[i]),[rfReplaceAll,rfIgnoreCase]);
    if mysql_query(FMySQL,Pchar(C.FStatement))<>0 then
      MySQLError(FMYSQL,Format(SErrExecuting,[StrPas(mysql_error(FMySQL))]),Self)
    else
      begin
      C.RowsAffected := mysql_affected_rows(FMYSQL);
      C.LastInsertID := mysql_insert_id(FMYSQL);
      if C.FNeedData then
        C.FRes:=mysql_store_result(FMySQL);
      end;
    end;
end;

//function TConnectionName.MySQLDataType(AType: enum_field_types; ASize, ADecimals: Integer;
//   var NewType: TFieldType; var NewSize: Integer): Boolean;
function TConnectionName.MySQLDataType(const afield: mysql_field; var NewType: TFieldType;
                            var NewSize: Integer): Boolean;
begin
  Result := True;
  NewSize:= 0;
  with afield do begin
   case ftype of
    FIELD_TYPE_TINY,FIELD_TYPE_SHORT,FIELD_TYPE_LONG: begin
     NewType:= ftInteger;
    end;
    FIELD_TYPE_LONGLONG,FIELD_TYPE_INT24: begin
     newtype:= ftlargeint;
    end;     
 {$ifdef mysql50}
    FIELD_TYPE_NEWDECIMAL,
 {$endif}
    FIELD_TYPE_DECIMAL: begin
     if Decimals < 5 then begin
      NewType:= ftBCD;
     end
     else begin
      NewType:= ftFloat;
     end;
    end;
    FIELD_TYPE_FLOAT,FIELD_TYPE_DOUBLE: begin
     NewType:= ftFloat;
    end;
    FIELD_TYPE_TIMESTAMP,FIELD_TYPE_DATETIME: begin
     NewType:= ftDateTime;
    end;
    FIELD_TYPE_DATE: begin
     NewType:= ftDate;
    end;
    FIELD_TYPE_TIME: begin
     NewType:= ftTime;
    end;
    FIELD_TYPE_VAR_STRING,FIELD_TYPE_STRING,FIELD_TYPE_ENUM,
                            FIELD_TYPE_SET: begin
     NewType:= ftString;
     NewSize:= length;
    end;
    {$ifdef mysql41}     
    field_type_blob: begin
     if charsetnr = 63 then begin //binary
      newtype:= ftblob;
     end
     else begin 
      newtype:= ftmemo;
     end;
     newsize:= sizeof(integer);
    end;
    {$endif}
   else begin
    Result:= False;
   end;
  end;
 end;
end;

procedure TConnectionName.AddFieldDefs(cursor: TSQLCursor;
  FieldDefs: TfieldDefs);

var
  C : TCursorName;
  I, TF, FC: Integer;
  field: PMYSQL_FIELD;
  DFT: TFieldType;
  DFS: Integer;

begin
//  Writeln('MySQL: Adding fielddefs');
  C:=(Cursor as TCursorName);
  If (C.FRes=Nil) then
    begin
//    Writeln('res is nil');
    MySQLError(FMySQL,SErrNoQueryResult,Self);
    end;
//  Writeln('MySQL: have result');
  FC:=mysql_num_fields(C.FRes);
  SetLength(c.MapDSRowToMSQLRow,FC);

  TF := 1;
  For I:= 0 to FC-1 do begin
   field := mysql_fetch_field_direct(C.FRES, I);
   with field^ do begin
    if (flags and (pri_key_flag or auto_increment_flag) = 
              (pri_key_flag or auto_increment_flag)) then begin
     c.fprimarykeyfieldname:= name;
    end;
   end;
//    Writeln('MySQL: creating fielddef ',I+1);

//    if MySQLDataType(field^.ftype, field^.length, field^.decimals, DFT, DFS) then
   if MySQLDataType(field^,DFT,DFS) then begin
    TFieldDef.Create(FieldDefs,field^.name,DFT,DFS,False,TF);
    c.MapDSRowToMSQLRow[TF-1] := I;
    inc(TF);
   end
  end;
//  Writeln('MySQL: Finished adding fielddefs');
end;

function TConnectionName.Fetch(cursor: TSQLCursor): boolean;

Var
  C : TCursorName;

begin
  C:=Cursor as TCursorName;
  C.Row:=MySQL_Fetch_row(C.FRes);
  Result:=(C.Row<>Nil);
end;

function tconnectionname.loadfield(const cursor: tsqlcursor;
              const afield: tfield;
      const buffer: pointer; var bufsize: integer): boolean;
           //if bufsize < 0 -> buffer was to small, should be -bufsize
//todo: implement blobs 2006-11-14 MSE

var
  field: PMYSQL_FIELD;
  row : MYSQL_ROW;
  C : TCursorName;
  fno: integer;
  alen: integer;
begin
//  Writeln('LoadFieldsFromBuffer');
 result:= false;
 C:= tcursorname(Cursor);
 fno:= afield.fieldno - 1;
 if C.Row=nil then
    begin
 //   Writeln('LoadFieldsFromBuffer: row=nil');
    MySQLError(FMySQL,SErrFetchingData,Self);
    end;
 Row:=C.Row;
 
 inc(Row,c.MapDSRowToMSQLRow[fno]);
 if row^ <> nil then begin
  field:= mysql_fetch_field_direct(C.FRES,c.MapDSRowToMSQLRow[fno]);
  if afield.datatype = ftstring then begin
//   alen:= strlen(row^);
   alen:= mysql_fetch_lengths(c.fres)[c.MapDSRowToMSQLRow[fno]];
   if bufsize < alen then begin 
    bufsize:= -alen;
    exit;
   end
   else begin
    bufsize:= alen;
   end;
  end
  else begin
   if afield.datatype in [ftmemo,ftgraphic,ftblob] then begin
    alen:= mysql_fetch_lengths(c.fres)[c.MapDSRowToMSQLRow[fno]];
   end
   else begin
    alen:= field^.length;
   end;
  end;
  Result:= MySQLWriteData(cursor, field^.ftype,alen,
       aField.DataType,Row^,Buffer);
 end;
end;

function InternalStrToFloat(S: string): Extended;

var
  I: Integer;
  Tmp: string;

begin
  Tmp := '';
  for I := 1 to Length(S) do
    begin
    if not (S[I] in ['0'..'9', '+', '-', 'E', 'e']) then
      Tmp := Tmp + DecimalSeparator
    else
      Tmp := Tmp + S[I];
    end;
  Result := StrToFloat(Tmp);
end;

function InternalStrToCurrency(S: string): Extended;

var
  I: Integer;
  Tmp: string;

begin
  Tmp := '';
  for I := 1 to Length(S) do
    begin
    if not (S[I] in ['0'..'9', '+', '-', 'E', 'e']) then
      Tmp := Tmp + DecimalSeparator
    else
      Tmp := Tmp + S[I];
    end;
  Result := StrToCurr(Tmp);
end;

function InternalStrToDate(S: string): TDateTime;

var
  EY, EM, ED: Word;

begin
  EY := StrToInt(Copy(S,1,4));
  EM := StrToInt(Copy(S,6,2));
  ED := StrToInt(Copy(S,9,2));
  if (EY = 0) or (EM = 0) or (ED = 0) then
    Result:=0
  else
    Result:=EncodeDate(EY, EM, ED);
end;

function InternalStrToDateTime(S: string): TDateTime;

var
  EY, EM, ED: Word;
  EH, EN, ES: Word;

begin
  EY := StrToInt(Copy(S, 1, 4));
  EM := StrToInt(Copy(S, 6, 2));
  ED := StrToInt(Copy(S, 9, 2));
  EH := StrToInt(Copy(S, 12, 2));
  EN := StrToInt(Copy(S, 15, 2));
  ES := StrToInt(Copy(S, 18, 2));
  if (EY = 0) or (EM = 0) or (ED = 0) then
    Result := 0
  else
    Result := EncodeDate(EY, EM, ED);
  Result := Result + EncodeTime(EH, EN, ES, 0);
end;

function InternalStrToTime(S: string): TDateTime;

var
  EH, EM, ES: Word;

begin
  EH := StrToInt(Copy(S, 1, 2));
  EM := StrToInt(Copy(S, 4, 2));
  ES := StrToInt(Copy(S, 7, 2));
  Result := EncodeTime(EH, EM, ES, 0);
end;

function InternalStrToTimeStamp(S: string): TDateTime;

var
  EY, EM, ED: Word;
  EH, EN, ES: Word;

begin
{$IFNDEF mysql40}
  EY := StrToInt(Copy(S, 1, 4));
  EM := StrToInt(Copy(S, 6, 2));
  ED := StrToInt(Copy(S, 9, 2));
  EH := StrToInt(Copy(S, 12, 2));
  EN := StrToInt(Copy(S, 15, 2));
  ES := StrToInt(Copy(S, 18, 2));
{$ELSE}
  EY := StrToInt(Copy(S, 1, 4));
  EM := StrToInt(Copy(S, 5, 2));
  ED := StrToInt(Copy(S, 7, 2));
  EH := StrToInt(Copy(S, 9, 2));
  EN := StrToInt(Copy(S, 11, 2));
  ES := StrToInt(Copy(S, 13, 2));
{$ENDIF}
  if (EY = 0) or (EM = 0) or (ED = 0) then
    Result := 0
  else
    Result := EncodeDate(EY, EM, ED);
  Result := Result + EncodeTime(EH, EN, ES, 0);;
end;

function TConnectionName.MySQLWriteData(const acursor: tsqlcursor; 
                     AType: enum_field_types;ASize: Integer;
                     AFieldType: TFieldType;Source, Dest: PChar): Boolean;

var
  VI: Integer;
  VF: Double;
  VC: Currency;
  VD: TDateTime;
  Src : String;
  int1: integer;
begin
  Result := False;
  if Source = Nil then
    exit;
  Src:=StrPas(Source);
  case AType of
    FIELD_TYPE_TINY, FIELD_TYPE_SHORT, FIELD_TYPE_LONG,
    FIELD_TYPE_INT24:
      begin
      if (Src<>'') then
        VI := StrToInt(Src)
      else
        VI := 0;
      Move(VI, Dest^, SizeOf(Integer));
      end;
    FIELD_TYPE_LONGLONG:
      begin
      if (Src<>'') then
        VI := StrToInt64(Src)
      else
        VI := 0;
      Move(VI, Dest^, SizeOf(LargeInt));
      end;
{$ifdef mysql50}
    FIELD_TYPE_NEWDECIMAL,
{$endif}      
    FIELD_TYPE_DECIMAL, FIELD_TYPE_FLOAT, FIELD_TYPE_DOUBLE:
      if AFieldType = ftBCD then
        begin
        VC := InternalStrToCurrency(Src);
        Move(VC, Dest^, SizeOf(Currency));
        end
      else
        begin
        if Src <> '' then
          VF := InternalStrToFloat(Src)
        else
          VF := 0;
        Move(VF, Dest^, SizeOf(Double));
        end;
    FIELD_TYPE_TIMESTAMP:
      begin
      if Src <> '' then
        VD := InternalStrToTimeStamp(Src)
      else
        VD := 0;
      Move(VD, Dest^, SizeOf(TDateTime));
      end;
    FIELD_TYPE_DATETIME:
      begin
      if Src <> '' then
        VD := InternalStrToDateTime(Src)
      else
        VD := 0;
      Move(VD, Dest^, SizeOf(TDateTime));
      end;
    FIELD_TYPE_DATE:
      begin
      if Src <> '' then
        VD := InternalStrToDate(Src)
      else
        VD := 0;
      Move(VD, Dest^, SizeOf(TDateTime));
      end;
    FIELD_TYPE_TIME:
      begin
      if Src <> '' then
        VD := InternalStrToTime(Src)
      else
        VD := 0;
      Move(VD, Dest^, SizeOf(TDateTime));
      end;
    FIELD_TYPE_VAR_STRING, FIELD_TYPE_STRING, FIELD_TYPE_ENUM, FIELD_TYPE_SET:
      begin
//      if Src<> '' then
        Move(Source^, Dest^, ASize)
//      else
//        Dest^ := #0;
     end;
    field_type_blob: begin
     int1:= acursor.addblobdata(source,asize);
     move(int1,dest^,sizeof(int1));
      //save id
    end;
    
  end;
  Result := True;
end;

procedure TConnectionName.UpdateIndexDefs(var IndexDefs : TIndexDefs;
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
    sql.add('show index from ' +  TableName);
    open;
    end;

  while not qry.eof do with IndexDefs.AddIndexDef do
    begin
    Name := trim(qry.fieldbyname('Key_name').asstring);
    Fields := trim(qry.fieldbyname('Column_name').asstring);
    If Name = 'PRIMARY' then options := options + [ixPrimary];
    If qry.fieldbyname('Non_unique').asinteger = 0 then options := options + [ixUnique];
    qry.next;
{    while (name = qry.fields[0].asstring) and (not qry.eof) do
      begin
      Fields := Fields + ';' + trim(qry.Fields[2].asstring);
      qry.next;
      end;}
    end;
  qry.close;
  qry.free;
end;


function TConnectionName.GetTransactionHandle(trans: TSQLHandle): pointer;
begin
  Result:=Nil;
end;

function TConnectionName.Commit(trans: TSQLHandle): boolean;
begin
  // Do nothing.
end;

function TConnectionName.RollBack(trans: TSQLHandle): boolean;
begin
  // Do nothing
end;

function TConnectionName.StartdbTransaction(trans: TSQLHandle; AParams : string): boolean;
begin
  // Do nothing
end;

procedure TConnectionName.internalCommitRetaining(trans: TSQLHandle);
begin
  // Do nothing
end;

procedure TConnectionName.internalRollBackRetaining(trans: TSQLHandle);
begin
  // Do nothing
end;

function TConnectionName.CreateBlobStream(const Field: TField;
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

function TConnectionName.getblobdatasize: integer;
begin
 result:= sizeof(integer);
end;

procedure TConnectionName.writeblobdata(const atransaction: tsqltransaction;
               const tablename: string; const acursor: tsqlcursor;
               const adata: pointer; const alength: integer;
               const afield: tfield; const aparam: tparam; out newid: string);
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

procedure TConnectionName.setupblobdata(const afield: tfield;
               const acursor: tsqlcursor; const aparam: tparam);
begin
 acursor.blobfieldtoparam(afield,aparam,afield.datatype = ftmemo);
end;

function TConnectionName.blobscached: boolean;
begin
 result:= true;
end;

function TConnectionName.getprimarykeyfield(const atablename: string;
                        const acursor: tsqlcursor): string;
begin
 result:= tcursorname(acursor).fprimarykeyfieldname;
end;

function TConnectionName.getinsertid: int64;
begin
 result:= mysql_insert_id(fmysql);
end;

procedure TConnectionName.updateprimarykeyfield(const afield: tfield);
begin
 with tmsebufdataset1(afield.dataset) do begin
  setcurvalue(afield,getinsertid);
 end;
end;

end.

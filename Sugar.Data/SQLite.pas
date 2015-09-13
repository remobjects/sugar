namespace Sugar.Data;
{
  On .NET this requires sqlite3.dll from the sqlite website
  On OSX/iOS this uses the system sqlite
  On Android it uses the standard Android sqlite support
  On Java it uses JDBC and requires https://bitbucket.org/xerial/sqlite-jdbc/ to be installed.
}
interface
{$IFDEF PUREJAVA}
uses
  java.sql, Sugar;
{$ELSEIF COCOA}
uses
  libsqlite3, Foundation, Sugar;
{$ELSE}
uses
  Sugar;
{$ENDIF}

type
  SQLiteConnection = public {$IFDEF PUREJAVA}interface{$ELSE}class{$ENDIF} {$IFDEF ANDROID}mapped to android.database.sqlite.SQLiteDatabase{$ENDIF}
  {$IFDEF PUREJAVA}mapped to java.sql.Connection{$ENDIF}
  private
    {$IFDEF ECHOES or COCOA}
    fHandle: IntPtr;
    fInTrans: Boolean;
    method Prepare(aSQL: String; aArgs: array of Object): Int64;
    {$ENDIF}
    method get_InTransaction: Boolean;
  protected
  public
    constructor(aFilename: String; aReadOnly: Boolean := false; aCreateIfNeeded: Boolean := true);

    property InTransaction: Boolean read get_InTransaction;
    method BegInTransaction; 
    method Commit;
    method Rollback;

    // insert and return the last insert id
    method ExecuteInsert(aSQL: String; params aArgValues: array of Object): Int64;
    // execute and return the number of affected rows
    method Execute(aSQL: String; params aArgValues: array of Object): Int64;
    // select
    method ExecuteQuery(aSQL: String; params aArgValues: array of Object): SQLiteQueryResult;
  end;

  SQLiteQueryResult = public {$IFDEF JAVA}interface{$ELSE}class{$ENDIF}
  {$IFDEF PUREJAVA}mapped to ResultSet{$ENDIF}
  {$IFDEF ANDROID}mapped to android.database.Cursor{$ENDIF}
  private
    {$IFDEF ECHOES or COCOA}
    fDB: IntPtr;
    fRes: IntPtr;
    {$IFDEF ECHOES}
    fNames: System.Collections.Generic.Dictionary<String, Integer>;
    {$ELSE}
    fNames: NSMutableDictionary;
    {$ENDIF}
    {$ENDIF}
    method get_IsNull(aIndex: Integer): Boolean;
    method get_ColumnCount: Integer;
    method get_ColumnName(aIndex: Integer): String;
    method get_ColumnIndex(aName: String): Integer;
  public
    {$IFDEF ECHOES or COCOA}
    constructor(aDB, aRes: Int64);
    {$ENDIF}
    property ColumnCount: Integer read get_ColumnCount;
    property ColumnName[aIndex: Integer]: String read get_ColumnName;
    property ColumnIndex[aName: String]: Integer read get_ColumnIndex;
    // starts before the first record:
    method MoveNext: Boolean;

    property IsNull[aIndex: Integer]: Boolean read get_IsNull;
    method GetInt(aIndex: Integer): nullable Integer;
    method GetInt64(aIndex: Integer): nullable Int64;
    method GetDouble(aIndex: Integer): nullable Double;
    method GetBytes(aIndex: Integer): array of {$IFDEF JAVA}SByte{$ELSE}Byte{$ENDIF};
    method GetString(aIndex: Integer): String;
  end;
  {$IFDEF ANDROID}
  SQLiteHelpers = public static class
  public
    class method ArgsToString(arr: array of Object): array of String;
    class method BindArgs(st: android.database.sqlite.SQLiteStatement; aArgs: array of Object);
  end;
  {$ENDIF}
  {$IFDEF PUREJAVA}
  SQLiteHelpers = public class
  public
    class method SetParameters(st: java.sql.PreparedStatement; aValues: array of Object);
    class method ExecuteAndGetLastInsertId(st: java.sql.PreparedStatement): Int64;
  end;
  {$ENDIF}
  {$IFDEF ECHOES or COCOA}
  SQLiteHelpers = class
  public
    {$IFDEF ECHOES}
    class const DLLName : String = 'sqlite3.dll';
    class const SQLITE_INTEGER: Integer = 1;
    class const SQLITE_FLOAT: Integer = 2;
    class const SQLITE_BLOB: Integer = 4;
    class const SQLITE_NULL: Integer = 5;
    class const SQLITE3_TEXT: Integer = 3;
    /// SQLITE_OK -> 0
    class const SQLITE_OK: Integer = 0;
    /// SQLITE_ERROR -> 1
    class const SQLITE_ERROR: Integer = 1;
    /// SQLITE_INTERNAL -> 2
    class const SQLITE_INTERNAL: Integer = 2;
    /// SQLITE_PERM -> 3
    class const SQLITE_PERM: Integer = 3;
    /// SQLITE_ABORT -> 4
    class const SQLITE_ABORT: Integer = 4;
    /// SQLITE_BUSY -> 5
    class const SQLITE_BUSY: Integer = 5;
    /// SQLITE_LOCKED -> 6
    class const SQLITE_LOCKED: Integer = 6;
    /// SQLITE_NOMEM -> 7
    class const SQLITE_NOMEM: Integer = 7;
    /// SQLITE_READONLY -> 8
    class const SQLITE_READONLY: Integer = 8;
    /// SQLITE_INTERRUPT -> 9
    class const SQLITE_INTERRUPT: Integer = 9;
    /// SQLITE_IOERR -> 10
    class const SQLITE_IOERR: Integer = 10;
    /// SQLITE_CORRUPT -> 11
    class const SQLITE_CORRUPT: Integer = 11;
    /// SQLITE_NOTFOUND -> 12
    class const SQLITE_NOTFOUND: Integer = 12;
    /// SQLITE_FULL -> 13
    class const SQLITE_FULL: Integer = 13;
    /// SQLITE_CANTOPEN -> 14
    class const SQLITE_CANTOPEN: Integer = 14;
    /// SQLITE_PROTOCOL -> 15
    class const SQLITE_PROTOCOL: Integer = 15;
    /// SQLITE_EMPTY -> 16
    class const SQLITE_EMPTY: Integer = 16;
    /// SQLITE_SCHEMA -> 17
    class const SQLITE_SCHEMA: Integer = 17;
    /// SQLITE_TOOBIG -> 18
    class const SQLITE_TOOBIG: Integer = 18;
    /// SQLITE_CONSTRAINT -> 19
    class const SQLITE_CONSTRAINT: Integer = 19;
    /// SQLITE_MISMATCH -> 20
    class const SQLITE_MISMATCH: Integer = 20;
    /// SQLITE_MISUSE -> 21
    class const SQLITE_MISUSE: Integer = 21;
    /// SQLITE_NOLFS -> 22
    class const SQLITE_NOLFS: Integer = 22;
    /// SQLITE_AUTH -> 23
    class const SQLITE_AUTH: Integer = 23;
    /// SQLITE_FORMAT -> 24
    class const SQLITE_FORMAT: Integer = 24;
    /// SQLITE_RANGE -> 25
    class const SQLITE_RANGE: Integer = 25;
    /// SQLITE_NOTADB -> 26
    class const SQLITE_NOTADB: Integer = 26;
    /// SQLITE_NOTICE -> 27
    class const SQLITE_NOTICE: Integer = 27;
    /// SQLITE_WARNING -> 28
    class const SQLITE_WARNING: Integer = 28;
    /// SQLITE_ROW -> 100
    class const SQLITE_ROW: Integer = 100;
    /// SQLITE_DONE -> 101
    class const SQLITE_DONE: Integer = 101;
    /// SQLITE_OPEN_READONLY -> 0x00000001
    class const SQLITE_OPEN_READONLY: Integer = 1;
    /// SQLITE_OPEN_READWRITE -> 0x00000002
    class const SQLITE_OPEN_READWRITE: Integer = 2;
    /// SQLITE_OPEN_CREATE -> 0x00000004
    class const SQLITE_OPEN_CREATE: Integer = 4;
    /// SQLITE_OPEN_DELETEONCLOSE -> 0x00000008
    class const SQLITE_OPEN_DELETEONCLOSE: Integer = 8;
    /// SQLITE_OPEN_EXCLUSIVE -> 0x00000010
    class const SQLITE_OPEN_EXCLUSIVE: Integer = 16;
    /// SQLITE_OPEN_AUTOPROXY -> 0x00000020
    class const SQLITE_OPEN_AUTOPROXY: Integer = 32;
    /// SQLITE_OPEN_URI -> 0x00000040
    class const SQLITE_OPEN_URI: Integer = 64;
    /// SQLITE_OPEN_MEMORY -> 0x00000080
    class const SQLITE_OPEN_MEMORY: Integer = 128;
    /// SQLITE_OPEN_MAIN_DB -> 0x00000100
    class const SQLITE_OPEN_MAIN_DB: Integer = 256;
    /// SQLITE_OPEN_TEMP_DB -> 0x00000200
    class const SQLITE_OPEN_TEMP_DB: Integer = 512;
    /// SQLITE_OPEN_TRANSIENT_DB -> 0x00000400
    class const SQLITE_OPEN_TRANSIENT_DB: Integer = 1024;
    /// SQLITE_OPEN_MAIN_JOURNAL -> 0x00000800
    class const SQLITE_OPEN_MAIN_JOURNAL: Integer = 2048;
    /// SQLITE_OPEN_TEMP_JOURNAL -> 0x00001000
    class const SQLITE_OPEN_TEMP_JOURNAL: Integer = 4096;
    /// SQLITE_OPEN_SUBJOURNAL -> 0x00002000
    class const SQLITE_OPEN_SUBJOURNAL: Integer = 8192;
    /// SQLITE_OPEN_MASTER_JOURNAL -> 0x00004000
    class const SQLITE_OPEN_MASTER_JOURNAL: Integer = 16384;
    /// SQLITE_OPEN_NOMUTEX -> 0x00008000
    class const SQLITE_OPEN_NOMUTEX: Integer = 32768;
    /// SQLITE_OPEN_FULLMUTEX -> 0x00010000
    class const SQLITE_OPEN_FULLMUTEX: Integer = 65536;
    /// SQLITE_OPEN_SHAREDCACHE -> 0x00020000
    class const SQLITE_OPEN_SHAREDCACHE: Integer = 131072;
    /// SQLITE_OPEN_PRIVATECACHE -> 0x00040000
    class const SQLITE_OPEN_PRIVATECACHE: Integer = 262144;
    /// SQLITE_OPEN_WAL -> 0x00080000
    class const SQLITE_OPEN_WAL: Integer = 524288;
    /// SQLITE_IOCAP_ATOMIC -> 0x00000001

    [System.Runtime.InteropServices.DllImport(DLLName,CallingConvention := System.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := System.Runtime.InteropServices.CharSet.Ansi)]
    class method sqlite3_close_v2(handle: IntPtr); external;
    [System.Runtime.InteropServices.DllImport(DLLName,CallingConvention := System.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := System.Runtime.InteropServices.CharSet.Ansi)]
    class method sqlite3_last_insert_rowid(handle: IntPtr): Int64; external;
    [System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := System.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := System.Runtime.InteropServices.CharSet.Ansi)]
    class method sqlite3_changes(handle: IntPtr): Integer; external;
    [System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := System.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := System.Runtime.InteropServices.CharSet.Ansi)]
    class method sqlite3_open_v2(filename: String; var handle: IntPtr; &flags: Integer; zVfs: String): Integer; external;
    [System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := System.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := System.Runtime.InteropServices.CharSet.Unicode)]
    class method sqlite3_prepare_v2(db: IntPtr; zSql: array of Byte; nByte: Integer; var ppStmt: IntPtr; pzTail: IntPtr): Integer; external;
    [System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := System.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := System.Runtime.InteropServices.CharSet.Ansi)]
    class method sqlite3_column_count(pStmt: IntPtr): Integer; external;
    [System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := System.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := System.Runtime.InteropServices.CharSet.Unicode)]
    class method sqlite3_column_name16(stmt: IntPtr; N: Integer): IntPtr; external;
    [System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := System.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := System.Runtime.InteropServices.CharSet.Ansi)]
    class method sqlite3_bind_blob(st: IntPtr; idx: Integer; data: array of Byte; len: Integer; free: IntPtr): Integer; external;
    [System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := System.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := System.Runtime.InteropServices.CharSet.Ansi)]
    class method sqlite3_bind_double(st: IntPtr; idx: Integer; val: Double): Integer; external;
    [System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := System.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := System.Runtime.InteropServices.CharSet.Ansi)]
    class method sqlite3_bind_int(st: IntPtr; idx: Integer; val: Integer): Integer; external;
    [System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := System.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := System.Runtime.InteropServices.CharSet.Ansi)]
    class method sqlite3_bind_int64(st: IntPtr; idx: Integer; val: Int64): Integer; external;
    [System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := System.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := System.Runtime.InteropServices.CharSet.Ansi)]
    class method sqlite3_bind_null(st: IntPtr; idx: Integer): Integer; external;
    [System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := System.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := System.Runtime.InteropServices.CharSet.Unicode)]
    class method sqlite3_bind_text16(st: IntPtr; idx: Integer; val: String; len: Integer; free: IntPtr): Integer; external;
    [System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := System.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := System.Runtime.InteropServices.CharSet.Ansi)]
    class method sqlite3_bind_parameter_count(st: IntPtr): Integer; external;
    [System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := System.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := System.Runtime.InteropServices.CharSet.Ansi)]
    class method sqlite3_bind_parameter_name(st: IntPtr; idx: Integer): IntPtr; external;
    [System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := System.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := System.Runtime.InteropServices.CharSet.Ansi)]
    class method sqlite3_bind_parameter_index(st: IntPtr; zName: String): Integer; external;
    [System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := System.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := System.Runtime.InteropServices.CharSet.Ansi)]
    class method sqlite3_step(st: IntPtr): Integer; external;
    [System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := System.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := System.Runtime.InteropServices.CharSet.Ansi)]
    class method sqlite3_column_blob(st: IntPtr; iCol: Integer): IntPtr; external;
    [System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := System.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := System.Runtime.InteropServices.CharSet.Ansi)]
    class method sqlite3_column_bytes(st: IntPtr; iCol: Integer): Integer; external;
    [System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := System.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := System.Runtime.InteropServices.CharSet.Unicode)]
    class method sqlite3_column_bytes16(st: IntPtr; iCol: Integer): Integer; external;
    [System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := System.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := System.Runtime.InteropServices.CharSet.Ansi)]
    class method sqlite3_column_double(st: IntPtr; iCol: Integer): Double; external;
    [System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := System.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := System.Runtime.InteropServices.CharSet.Ansi)]
    class method sqlite3_column_int(st: IntPtr; iCol: Integer): Integer; external;
    [System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := System.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := System.Runtime.InteropServices.CharSet.Ansi)]
    class method sqlite3_column_int64(st: IntPtr; iCol: Integer): Int64; external;
    [System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := System.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := System.Runtime.InteropServices.CharSet.Unicode)]
    class method sqlite3_column_text16(st: IntPtr; iCol: Integer): IntPtr; external;
    [System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := System.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := System.Runtime.InteropServices.CharSet.Ansi)]
    class method sqlite3_column_type(st: IntPtr; iCol: Integer): Integer; external;
    [System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := System.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := System.Runtime.InteropServices.CharSet.Ansi)]
    class method sqlite3_finalize(pStmt: IntPtr): Integer; external;
    [System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := System.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := System.Runtime.InteropServices.CharSet.Ansi)]
    class method sqlite3_reset(pStmt: IntPtr): Integer; external;
    [System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := System.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := System.Runtime.InteropServices.CharSet.Unicode)]
    class method sqlite3_errmsg16(handle: IntPtr): IntPtr; external;
    {$ENDIF}
    class method Throw(handle: IntPtr; res: Integer);
  end;

  SQLiteException = public class(Exception)
  public
    constructor(s: String);
  end;
  {$ENDIF}
  {$IFDEF ANDROID}
  SQLiteException = public android.database.sqlite.SQLiteException;
  {$ENDIF}
  {$IFDEF PUREJAVA}
  SQLiteException = public java.sql.SQLException;
  {$ENDIF}

implementation

constructor SQLiteConnection(aFilename: String; aReadOnly: Boolean := false; aCreateIfNeeded: Boolean := true);
begin
  {$IFDEF PUREJAVA}
  &Class.forName('org.sqlite.JDBC');
  var config := new java.util.Properties;
  if aReadonly then
    config.setProperty('open_mode', '1');
  exit DriverManager.getConnection('jdbc:sqlite:' + aFilename, config);
  {$ELSEIF ANDROID}
  exit android.database.sqlite.SQLiteDatabase.openDatabase(aFilename, nil, 
    ((if aReadOnly then android.database.sqlite.SQLiteDatabase.OPEN_READONLY else android.database.sqlite.SQLiteDatabase.OPEN_READWRITE) or
    (if aCreateIfNeeded then android.database.sqlite.SQLiteDatabase.CREATE_IF_NECESSARY else 0)));
  {$ELSEIF ECHOES}
  var lRes:= SQLiteHelpers.sqlite3_open_v2(aFilename, var fHandle,
    (if aReadOnly then SQLiteHelpers.SQLITE_OPEN_READONLY else SQLiteHelpers.SQLITE_OPEN_READWRITE) or
    (if aCreateIfNeeded then SQLiteHelpers.SQLITE_OPEN_CREATE else 0), nil);
  SQLiteHelpers.Throw(fHandle, lRes);
  {$ELSEIF COCOA}
  var lRes:= sqlite3_open_v2(NSString(aFilename), ^^sqlite3_(@fHandle),
    (if aReadOnly then SQLITE_OPEN_READONLY else SQLITE_OPEN_READWRITE) or
    (if aCreateIfNeeded then SQLITE_OPEN_CREATE else 0), nil);
  SQLiteHelpers.Throw(fHandle, lRes);
{$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;

method SQLiteConnection.BegInTransaction;
begin
  {$IFDEF PUREJAVA}
  mapped.setAutoCommit(false);
  {$ELSEIF ECHOES or COCOA}
  if fInTrans then raise new SQLiteException('Already in transaction');
  fInTrans := true;
  Execute('begin transaction');
  {$ELSEIF ANDROID}
  mapped.begInTransaction;
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;

method SQLiteConnection.Commit;
begin
  {$IFDEF PUREJAVA}
  mapped.commit;
  {$ELSEIF ECHOES or COCOA}
  if fInTrans then raise new SQLiteException('Not in an transaction');
  Execute('commit');
  fInTrans := false;
  {$ELSEIF ANDROID}
  mapped.setTransactionSuccessful;
  mapped.endTransaction;
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;

method SQLiteConnection.Rollback;
begin
  {$IFDEF PUREJAVA}
  mapped.rollback;
  {$ELSEIF ECHOES or COCOA}
  if fInTrans then raise new SQLiteException('Not in an transaction');
  Execute('rollback');
  fInTrans := false;
  {$ELSEIF ANDROID}
  mapped.endTransaction;
    {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}

end;

{$IFDEF ECHOES or COCOA}
method SQLiteConnection.Prepare(aSQL: String; aArgs: array of Object): Int64;
begin
  {$IFDEF COCOA}
  var res: IntPtr := nil;
  var data := NSString(aSQL).UTF8String;
  SQLiteHelpers.Throw(fHandle, sqlite3_prepare_v2(^sqlite3_(fHandle), data, strlen(data), ^^sqlite3_stmt(@res), nil));
  for i: Integer := 0 to length(aArgs) -1 do begin
    var o := aArgs[i];
    if o = nil then
      sqlite3_bind_null(^sqlite3_stmt(res), i)
    else if o is NSNumber then begin
      var r := NSNumber(o);
      case r.objCType of
        'f': sqlite3_bind_double(^sqlite3_stmt(res), i, r.floatValue);
        'd': sqlite3_bind_double(^sqlite3_stmt(res), i, r.doubleValue);
      else
        sqlite3_bind_int64(^sqlite3_stmt(res), i, r.longLongValue);
      end;
    end else begin
      sqlite3_bind_text16(^sqlite3_stmt(res), i, coalesce(NSString(o), o.description), -1, nil);
    end;
  end;
  result := res;
  {$ELSE}
  var res := IntPtr.Zero;
  var data := System.Text.Encoding.UTF8.GetBytes(aSQL);
  SQLiteHelpers.Throw(fHandle, SQLiteHelpers.sqlite3_prepare_v2(fHandle, data, data.Length, var res, IntPtr.Zero));
  for i: Integer := 0 to length(aArgs) -1 do begin
    var o := aArgs[i];
    if o = nil then
      SQLiteHelpers.sqlite3_bind_null(res, i)
    else if o is array of Byte then
      SQLiteHelpers.sqlite3_bind_blob(res, i, array of Byte(o), length(array of Byte(o)), IntPtr.Zero)
    else if o is Double then 
      SQLiteHelpers.sqlite3_bind_double(res, i, Double(o))
    else if o is Int64 then 
      SQLiteHelpers.sqlite3_bind_int64(res, i, Int64(o))
    else if o is Integer then 
      SQLiteHelpers.sqlite3_bind_int(res, i, Integer(o))
    else 
      SQLiteHelpers.sqlite3_bind_text16(res, i, String(o), -1, IntPtr.Zero);
  end;
  result := res;
  {$ENDIF}
end;
{$ENDIF}

method SQLiteConnection.ExecuteQuery(aSQL: String; params aArgValues: array of Object): SQLiteQueryResult;
begin
  {$IFDEF PUREJAVA}
  var st := mapped.prepareStatement(aSQL);
  SQLiteHelpers.SetParameters(st, aArgValues);
  exit st.executeQuery();
  {$ELSEIF ECHOES or COCOA}
  exit new SQLiteQueryResult(fHandle, Prepare(aSQL, aArgValues));
  {$ELSEIF ANDROID}
  exit mapped.rawQuery(aSQL, SQLiteHelpers.ArgsToString(aArgValues));
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;

method SQLiteConnection.ExecuteInsert(aSQL: String; params aArgValues: array of Object): Int64;
begin
  {$IFDEF PUREJAVA}
  var st := mapped.prepareStatement(aSQL);
  SQLiteHelpers.SetParameters(st, aArgValues);
  exit  SQLiteHelpers.ExecuteAndGetLastInsertID(st);
  {$ELSEIF ECHOES or COCOA}
  var res: IntPtr := Prepare(aSQL, aArgValues);
  var &step := {$IFDEF ECHOES}SQLiteHelpers.sqlite3_step(res){$ELSE}sqlite3_step(^sqlite3_stmt(res));{$ENDIF};
  if &step <> {$IFDEF ECHOES}SQLiteHelpers.{$ENDIF}SQLITE_DONE then begin
    {$IFDEF ECHOES}SQLiteHelpers.sqlite3_finalize(res){$ELSE} sqlite3_finalize(^sqlite3_stmt(res)){$ENDIF};
    SQLiteHelpers.Throw(fHandle, &step);
    exit 0;
  end;
  var revs := {$IFDEF ECHOES}SQLiteHelpers.sqlite3_last_insert_rowid(fHandle){$ELSE}sqlite3_last_insert_rowid(^sqlite3_(fHandle)){$ENDIF};
  {$IFDEF ECHOES}SQLiteHelpers.sqlite3_finalize(res){$ELSE} sqlite3_finalize(^sqlite3_stmt(res)){$ENDIF};
  exit revs;
  {$ELSEIF ANDROID}
  using st := mapped.compileStatement(aSQL) do begin
   SQLiteHelpers.BindArgs(st, aArgValues);
    exit st.executeInsert();
  end;
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;

method SQLiteConnection.Execute(aSQL: String; params aArgValues: array of Object): Int64;
begin
  {$IFDEF PUREJAVA}
  var st := mapped.prepareStatement(aSQL);
  SQLiteHelpers.SetParameters(st, aArgValues);
  exit st.executeUpdate;
  {$ELSEIF ECHOES or COCOA}
  var res: IntPtr := Prepare(aSQL, aArgValues);
  var &step := {$IFDEF ECHOES}SQLiteHelpers.sqlite3_step(res){$ELSE}sqlite3_step(^sqlite3_stmt(res));{$ENDIF};
  if &step <> {$IFDEF ECHOES}SQLiteHelpers.{$ENDIF}SQLITE_DONE then begin
    {$IFDEF ECHOES}SQLiteHelpers.sqlite3_finalize(res){$ELSE} sqlite3_finalize(^sqlite3_stmt(res)){$ENDIF};
    SQLiteHelpers.Throw(fHandle, &step);
    exit 0;
  end;
  var revs := {$IFDEF ECHOES}SQLiteHelpers.sqlite3_changes(fHandle){$ELSE}sqlite3_changes(^sqlite3_(fHandle)){$ENDIF};
  {$IFDEF ECHOES}SQLiteHelpers.sqlite3_finalize(res){$ELSE} sqlite3_finalize(^sqlite3_stmt(res)){$ENDIF};
  exit revs;

  {$ELSEIF ANDROID}
  using st := mapped.compileStatement(aSQL) do begin
   SQLiteHelpers.BindArgs(st, aArgValues);
    exit st.executeUpdateDelete();
  end;
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;

method SQLiteConnection.get_InTransaction: Boolean;
begin
  {$IFDEF PUREJAVA}
  exit not mapped.AutoCommit;
  {$ELSEIF ECHOES or COCOA}
  exit fInTrans;
  {$ELSEIF ANDROID}
  exit mapped.InTransaction;
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;

{$IFDEF ANDROID}
method SQLiteHelpers.ArgsToString(arr: array of Object): array of String;
begin
  if length(arr) = 0 then exit [];
  result := new String[arr.length];
  for i: Integer := 0 to arr.length -1 do begin
    result[i] := arr[i]:toString(); 
  end;
end;

method SQLiteHelpers.BindArgs(st: android.database.sqlite.SQLiteStatement; aArgs: array of Object);
begin
  for i: Integer := 0 to length(aArgs) -1 do begin
    var val := aArgs[i];
    if val = nil then
      st.bindNull(i)
    else if val is Double then
      st.bindDouble(i, Double(val))
    else if val is Single then
      st.bindDouble(i, Single(val))
    else if val is Int64 then
      st.bindLong(i, Int64(val))
    else if val is Int64 then
      st.bindLong(i, Int64(val))
    else if val is array of SByte then 
      st.bindBlob(i, array of SByte(val))
    else 
      st.bindString(i, val.toString);
  end;
end;
{$ENDIF}

{$IFDEF ECHOES or COCOA}
constructor SQLiteQueryResult(aDB, aRes: Int64);
begin
  fDB := aDB;
  fRes := aRes;
end;
{$ENDIF}
    

method SQLiteQueryResult.MoveNext: Boolean;
begin
  {$IFDEF PUREJAVA}
  exit mapped.next;
  {$ELSEIF ECHOES}
  var res := SQLiteHelpers.sqlite3_step(fRes);
  if res = SQLiteHelpers.SQLITE_ROW then exit true;
  if res = SQLiteHelpers.SQLITE_DONE then exit false;

  SQLiteHelpers.Throw(fDB, fRes);
  exit false; // unreachable
  {$ELSEIF COCOA}
  
  var res := sqlite3_step(^sqlite3_stmt(fRes));
  if res = SQLITE_ROW then exit true;
  if res = SQLITE_DONE then exit false;

  SQLiteHelpers.Throw(fDB, fRes);
  exit false; // unreachable
  {$ELSEIF ANDROID}
  exit mapped.moveToNext;
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;

method SQLiteQueryResult.GetInt(aIndex: Integer): nullable Integer;
begin
  {$IFDEF PUREJAVA}
  exit if mapped.getObject(1 + aIndex) = nil then nil else nullable Integer(mapped.getInt(1 + aIndex));
  {$ELSEIF ECHOES}
  if SQLiteHelpers.sqlite3_column_type(fRes, aIndex) = SQLiteHelpers.SQLITE_NULL then exit nil;
  exit SQLiteHelpers.sqlite3_column_int(fRes, aIndex);
  {$ELSEIF COCOA}
  if sqlite3_column_type(^sqlite3_stmt(fRes), aIndex) = SQLITE_NULL then exit nil;
  exit sqlite3_column_int(^sqlite3_stmt(fRes), aIndex);
  {$ELSEIF ANDROID}
  exit if mapped.isNull(aIndex) then nil else nullable Integer(mapped.getInt(aIndex));
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;

method SQLiteQueryResult.GetInt64(aIndex: Integer): nullable Int64;
begin
  {$IFDEF PUREJAVA}
  exit if mapped.getObject(1 + aIndex) = nil then nil else nullable Int64(mapped.getLong(1 + aIndex));
  {$ELSEIF ECHOES}
  if SQLiteHelpers.sqlite3_column_type(fRes, aIndex) = SQLiteHelpers.SQLITE_NULL then exit nil;
  exit SQLiteHelpers.sqlite3_column_int64(fRes, aIndex);
  {$ELSEIF COCOA}
  if sqlite3_column_type(^sqlite3_stmt(fRes), aIndex) = SQLITE_NULL then exit nil;
  exit sqlite3_column_int64(^sqlite3_stmt(fRes), aIndex);
  {$ELSEIF ANDROID}
  exit if mapped.isNull(aIndex) then nil else nullable Int64(mapped.getLong(aIndex));
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;

method SQLiteQueryResult.GetDouble(aIndex: Integer): nullable Double;
begin
  {$IFDEF PUREJAVA}
  exit if mapped.getObject(1 + aIndex) = nil then nil else nullable Double(mapped.getDouble(1 + aIndex));
  {$ELSEIF ECHOES}
  if SQLiteHelpers.sqlite3_column_type(fRes, aIndex) = SQLiteHelpers.SQLITE_NULL then exit nil;
  exit SQLiteHelpers.sqlite3_column_double(fRes, aIndex);
  {$ELSEIF COCOA}
  if sqlite3_column_type(^sqlite3_stmt(fRes), aIndex) = SQLITE_NULL then exit nil;
  exit sqlite3_column_double(^sqlite3_stmt(fRes), aIndex);
  {$ELSEIF ANDROID}
  exit if mapped.isNull(aIndex) then nil else nullable Double(mapped.getDouble(aIndex));
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;

method SQLiteQueryResult.GetBytes(aIndex: Integer): array of {$IFDEF JAVA}SByte{$ELSE}Byte{$ENDIF};
begin
  {$IFDEF PUREJAVA}
  exit mapped.getBytes(1 + aIndex);
  {$ELSEIF ECHOES}
  var data: IntPtr := SQLiteHelpers.sqlite3_column_blob(fRes, aIndex);
  if data = IntPtr.Zero then exit nil;
  var n: array of Byte := new Byte[SQLiteHelpers.sqlite3_column_bytes(fRes, aIndex)];
  System.Runtime.InteropServices.Marshal.&Copy(data, n, 0, n.Length);
  exit n;
  {$ELSEIF COCOA}
  var data := sqlite3_column_blob(^sqlite3_stmt(fRes), aIndex);
  if data = nil then exit nil;
  var n: array of Byte := new Byte[sqlite3_column_bytes(^sqlite3_stmt(fRes), aIndex)];
  memcpy(@n[0], data, length(n));
  exit n;
  {$ELSEIF ANDROID}
  exit mapped.getBlob(aIndex);
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;

method SQLiteQueryResult.GetString(aIndex: Integer): String;
begin
  {$IFDEF PUREJAVA}
  exit mapped.getString(1 + aIndex);
  {$ELSEIF ECHOES}
  if SQLiteHelpers.sqlite3_column_type(fRes, aIndex) = SQLiteHelpers.SQLITE_NULL then exit nil;

  exit System.Runtime.InteropServices.Marshal.PtrToStringUni(SQLiteHelpers.sqlite3_column_text16(fRes, aIndex));
  {$ELSEIF COCOA}
  if sqlite3_column_type(^sqlite3_stmt(fRes), aIndex) = SQLITE_NULL then exit nil;
  
  var p: ^unichar := ^unichar(sqlite3_column_text16(^sqlite3_stmt(fRes), aIndex));
  var plen := 0;
  while p[plen] <> #0 do inc(plen);
  exit new NSString withCharacters(p) length(plen);
  {$ELSEIF ANDROID}
  exit mapped.getString(aIndex);
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;

method SQLiteQueryResult.get_IsNull(aIndex: Integer): Boolean;
begin
  {$IFDEF PUREJAVA}
  exit mapped.getObject(aIndex) = nil;
  {$ELSEIF ECHOES}
  exit SQLiteHelpers.sqlite3_column_type(fRes, aIndex) = SQLiteHelpers.SQLITE_NULL;
  {$ELSEIF COCOA}
  exit sqlite3_column_type(^sqlite3_stmt(fRes), aIndex) = SQLITE_NULL;
  {$ELSEIF ANDROID}
  exit mapped.isNull(aIndex);
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;


method SQLiteQueryResult.get_ColumnCount: Integer;
begin
  {$IFDEF PUREJAVA}
  exit mapped.getMetaData().ColumnCount;
  {$ELSEIF ECHOES}
  exit SQLiteHelpers.sqlite3_column_count(fRes)
  {$ELSEIF COCOA}
  exit sqlite3_column_count(^sqlite3_stmt(fRes))
  {$ELSEIF ANDROID}
  exit mapped.ColumnCount;
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;

method SQLiteQueryResult.get_ColumnName(aIndex: Integer): String;
begin
  {$IFDEF PUREJAVA}
  exit mapped.getMetaData().getColumnName(1 + aIndex);
  {$ELSEIF ECHOES}
  exit System.Runtime.InteropServices.Marshal.PtrToStringUni(SQLiteHelpers.sqlite3_column_name16(fRes, aIndex));
  {$ELSEIF COCOA}
  exit NSString.stringWithCString(^AnsiChar(sqlite3_column_name16(^sqlite3_stmt(fRes), aIndex)) ) encoding(NSStringEncoding.NSUTF16StringEncoding);
  {$ELSEIF ANDROID}
  exit mapped.ColumnName[aIndex];
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;

method SQLiteQueryResult.get_ColumnIndex(aName: String): Integer;
begin
  {$IFDEF PUREJAVA}
  raise new SQLException('Column index not supported');
  {$ELSEIF ECHOES}
  if fNames = nil then begin
    fNames := new System.Collections.Generic.Dictionary<String, Integer>;
    for i: Integer := 0 to ColumnCount -1 do
      fNames[ColumnName[i]] := i;
  end;
  fNames.TryGetValue(aName, out result);
  {$ELSEIF COCOA}
  if fNames = nil then begin
    fNames := new NSMutableDictionary;
    for i: Integer := 0 to ColumnCount -1 do
      fNames[ColumnName[i]] := i;
  end;
  var lVal := fNames[aName];
  if lVal = nil then exit -1;
  exit Integer(lVal);
  {$ELSEIF ANDROID}
  exit mapped.ColumnIndex[aName];
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;




{$IFDEF ECHOES or COCOA}
class method SQLiteHelpers.Throw(handle: IntPtr; res: Integer);
begin
  case res of
    0: begin
    end;
    SQLITE_ERROR: begin
      {$IFDEF ECHOES}
      if handle = IntPtr.Zero then
        raise new SQLiteException('SQL error or missing database ');
      raise new SQLiteException(System.Runtime.InteropServices.Marshal.PtrToStringUni(SQLiteHelpers.sqlite3_errmsg16(handle)));
      {$ELSE}
      if handle = IntPtr(nil) then 
        raise new SQLiteException('SQL error or missing database ');
      raise new SQLiteException(NSString.stringWithCString(^AnsiChar(sqlite3_errmsg16(^sqlite3_(handle)))) encoding(NSStringEncoding.NSUTF16StringEncoding) );
      {$ENDIF}
    end;
    SQLITE_INTERNAL: begin
      raise new SQLiteException('Internal logic error in SQLite ');
    end;
    SQLITE_PERM: begin
      raise new SQLiteException('Access permission denied ');
    end;
    SQLITE_ABORT: begin
      raise new SQLiteException('Callback routine requested an abort ');
    end;
    SQLITE_BUSY: begin
      raise new SQLiteException('The database file is locked ');
    end;
    SQLITE_LOCKED: begin
      raise new SQLiteException('A table in the database is locked ');
    end;
    SQLITE_NOMEM: begin
      raise new SQLiteException('A malloc() failed ');
    end;
    SQLITE_READONLY: begin
      raise new SQLiteException('Attempt to write a readonly database ');
    end;
    SQLITE_INTERRUPT: begin
      raise new SQLiteException('Operation terminated by sqlite3_interrupt()');
    end;
    SQLITE_IOERR: begin
      raise new SQLiteException('Some kind of disk I/O error occurred ');
    end;
    SQLITE_CORRUPT: begin
      raise new SQLiteException('The database disk image is malformed ');
    end;
    SQLITE_NOTFOUND: begin
      raise new SQLiteException('Unknown opcode in sqlite3_file_control() ');
    end;
    SQLITE_FULL: begin
      raise new SQLiteException('Insertion failed because database is full ');
    end;
    SQLITE_CANTOPEN: begin
      raise new SQLiteException('Unable to open the database file ');
    end;
    SQLITE_PROTOCOL: begin
      raise new SQLiteException('Database lock protocol error ');
    end;
    SQLITE_EMPTY: begin
      raise new SQLiteException('Database is empty ');
    end;
    SQLITE_SCHEMA: begin
      raise new SQLiteException('The database schema changed ');
    end;
    SQLITE_TOOBIG: begin
      raise new SQLiteException('String or BLOB exceeds size limit ');
    end;
    SQLITE_CONSTRAINT: begin
      raise new SQLiteException('Abort due to constraint violation ');
    end;
    SQLITE_MISMATCH: begin
      raise new SQLiteException('Data type mismatch ');
    end;
    SQLITE_MISUSE: begin
      raise new SQLiteException('Library used incorrectly ');
    end;
    SQLITE_NOLFS: begin
      raise new SQLiteException('Uses OS features not supported on host ');
    end;
    SQLITE_AUTH: begin
      raise new SQLiteException('Authorization denied ');
    end;
    SQLITE_FORMAT: begin
      raise new SQLiteException('Auxiliary database format error ');
    end;
    SQLITE_RANGE: begin
      raise new SQLiteException('2nd parameter to sqlite3_bind out of range ');
    end;
    SQLITE_NOTADB: begin
      raise new SQLiteException('File opened that is not a database file ');
    end;
    27: begin
      raise new SQLiteException('Notifications from sqlite3_log() ');
    end;
    28: begin
      raise new SQLiteException('Warnings from sqlite3_log() ');
    end;
    SQLITE_ROW: begin
      raise new SQLiteException('sqlite3_step() has another row ready ');
    end;
    SQLITE_DONE: begin
      raise new SQLiteException('sqlite3_step() has finished executing ');
    end;
    else begin
      raise new SQLiteException('unknown error');
    end;
  end;
end;

constructor SQLiteException(s: String);
begin
  {$IFDEF COCOA}
  exit inherited initWithName('SQLite') reason(s) userInfo(nil);
  {$ELSE}
  inherited constructor(s);
  {$ENDIF}
end;
{$ENDIF}

{$IFDEF PUREJAVA}
class method SQLiteHelpers.SetParameters(st: PreparedStatement; aValues: array of Object);
begin
  for i: Integer := 0 to length(aValues) -1 do
    st.setObject(i+1, aValues[i])
end;

class method SQLiteHelpers.ExecuteAndGetLastInsertId(st: PreparedStatement): Int64;
begin
  st.executeUpdate;
  var key := st.getGeneratedKeys;
  if (key = nil) or (key.getMetaData.ColumnCount <> 1) then exit ;
  exit  key.getLong(1)
end;
{$ENDIF}
end.
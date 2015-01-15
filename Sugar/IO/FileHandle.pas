namespace Sugar.IO;

interface

uses
  {$IF WINDOWS_PHONE OR NETFX_CORE}
  System.Runtime.InteropServices.WindowsRuntime,
  System.IO,
  {$ENDIF}
  Sugar;

type
  FileOpenMode = public (&ReadOnly, &Create, ReadWrite);
  SeekOrigin = public (&Begin, Current, &End);

  FileHandle = public class mapped to {$IF COOPER}java.io.RandomAccessFile{$ELSEIF WINDOWS_PHONE OR NETFX_CORE}Stream{$ELSEIF ECHOES}System.IO.FileStream{$ELSEIF NOUGAT}NSFileHandle{$ENDIF}
  private
    method GetLength: Int64;
    method SetLength(value: Int64);
    method GetPosition: Int64;
    method SetPosition(value: Int64);
    method ValidateBuffer(Buffer: array of Byte; Offset: Integer; Count: Integer);
  public
    constructor(FileName: String; Mode: FileOpenMode);
    
    class method FromFile(aFile: File; Mode: FileOpenMode): FileHandle;

    method Close;
    method Flush;
    method &Read(Buffer: array of Byte; Offset: Integer; Count: Integer): Integer;
    method &Read(Buffer: array of Byte; Count: Integer): Integer;
    method &Read(Count: Integer): Binary;
    method &Write(Buffer: array of Byte; Offset: Integer; Count: Integer);
    method &Write(Buffer: array of Byte; Count: Integer);
    method &Write(Buffer: array of Byte);
    method &Write(Data: Binary);
    method Seek(Offset: Int64; Origin: SeekOrigin);

    property Length: Int64 read GetLength write SetLength;
    property Position: Int64 read GetPosition write SetPosition;
  end;

implementation

constructor FileHandle(FileName: String; Mode: FileOpenMode);
begin
  if not FileUtils.Exists(FileName) then
    raise new SugarFileNotFoundException(FileName);

  {$IF COOPER}
  var lMode: String := if Mode = FileOpenMode.ReadOnly then "r" else "rw";
  exit new java.io.RandomAccessFile(FileName, lMode);
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  var lFile: Windows.Storage.StorageFile := Windows.Storage.StorageFile.GetFileFromPathAsync(FileName).Await;
  var lMode: Windows.Storage.FileAccessMode := if Mode = FileOpenMode.ReadOnly then Windows.Storage.FileAccessMode.Read else Windows.Storage.FileAccessMode.ReadWrite;
  exit lFile.OpenAsync(lMode).Await.AsStream;
  {$ELSEIF ECHOES}
  var lAccess: System.IO.FileAccess := case Mode of
                                         FileOpenMode.ReadOnly: System.IO.FileAccess.Read;
                                         FileOpenMode.Create: System.IO.FileAccess.Write;
                                         else System.IO.FileAccess.ReadWrite;
                                       end;
  var lMode: System.IO.FileMode := case Mode of
                                         FileOpenMode.ReadOnly: System.IO.FileMode.Open;
                                         FileOpenMode.Create: System.IO.FileMode.Create;
                                         else System.IO.FileMode.OpenOrCreate;
                                       end;
  exit new System.IO.FileStream(FileName, lMode, lAccess);
  {$ELSEIF NOUGAT}
  case Mode of
    FileOpenMode.ReadOnly: exit NSFileHandle.fileHandleForReadingAtPath(FileName);
    FileOpenMode.ReadWrite: exit NSFileHandle.fileHandleForUpdatingAtPath(FileName);
  end;
  {$ENDIF}
end;

class method FileHandle.FromFile(aFile: File; Mode: FileOpenMode): FileHandle;
begin
  {$IF COOPER}
  var lMode: String := if Mode = FileOpenMode.ReadOnly then "r" else "rw";
  exit new java.io.RandomAccessFile(aFile, lMode);
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}  
  var lMode: Windows.Storage.FileAccessMode := if Mode = FileOpenMode.ReadOnly then Windows.Storage.FileAccessMode.Read else Windows.Storage.FileAccessMode.ReadWrite;
  exit Windows.Storage.StorageFile(aFile).OpenAsync(lMode).Await.AsStream;
  {$ELSEIF ECHOES}
  var lMode: System.IO.FileAccess := if Mode = FileOpenMode.ReadOnly then System.IO.FileAccess.Read else System.IO.FileAccess.ReadWrite;
  exit new System.IO.FileStream(System.String(aFile), System.IO.FileMode.Open, lMode);
  {$ELSEIF NOUGAT}
  case Mode of
    FileOpenMode.ReadOnly: exit NSFileHandle.fileHandleForReadingAtPath(aFile);
    FileOpenMode.ReadWrite: exit NSFileHandle.fileHandleForUpdatingAtPath(aFile);
  end;
  {$ENDIF}
end;

method FileHandle.Close;
begin
  {$IF COOPER}
  mapped.close;
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}  
  mapped.Dispose;
  {$ELSEIF ECHOES}
  mapped.Close;
  {$ELSEIF NOUGAT}
  mapped.closeFile;
  {$ENDIF}
end;

method FileHandle.Flush;
begin
  {$IF COOPER}
  mapped.Channel.force(false);
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  mapped.Flush;
  {$ELSEIF ECHOES}
  mapped.Flush;
  {$ELSEIF NOUGAT}
  mapped.synchronizeFile;
  {$ENDIF}
end;

method FileHandle.ValidateBuffer(Buffer: array of Byte; Offset: Integer; Count: Integer);
begin
  if Buffer = nil then
    raise new SugarArgumentNullException("Buffer");

  if Offset < 0 then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.NEGATIVE_VALUE_ERROR, "Offset");

  if Count < 0 then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.NEGATIVE_VALUE_ERROR, "Count");

  if Count = 0 then
    exit;

  var BufferLength := RemObjects.Oxygene.System.length(Buffer); 

  if Offset >= BufferLength then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.ARG_OUT_OF_RANGE_ERROR, "Offset");

  if Count > BufferLength then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.ARG_OUT_OF_RANGE_ERROR, "Count");

  if Offset + Count > BufferLength then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.OUT_OF_RANGE_ERROR, Offset, Count, BufferLength);
end;

method FileHandle.Read(Buffer: array of Byte; Offset: Integer; Count: Integer): Integer;
begin
  ValidateBuffer(Buffer, Offset, Count);
  
  if Count = 0 then
    exit 0;

  {$IF COOPER}
  exit mapped.read(Buffer, Offset, Count);
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  exit mapped.Read(Buffer, Offset, Count);
  {$ELSEIF ECHOES}
  exit mapped.Read(Buffer, Offset, Count);
  {$ELSEIF NOUGAT}
  var Bin := mapped.readDataOfLength(Count);
  Bin.getBytes(@Buffer[Offset]) length(Bin.length);

  exit Bin.length;
  {$ENDIF}
end;

method FileHandle.&Read(Buffer: array of Byte; Count: Integer): Integer;
begin
  exit &Read(Buffer, 0, Count);
end;

method FileHandle.&Read(Count: Integer): Binary;
begin
  var Buffer := new Byte[Count];
  var Readed := &Read(Buffer, 0, Count);
  result := new Binary;
  result.Write(Buffer, Readed);
end;

method FileHandle.Write(Buffer: array of Byte; Offset: Integer; Count: Integer);
begin
  ValidateBuffer(Buffer, Offset, Count);

  if Count = 0 then
    exit;

  {$IF COOPER}
  mapped.write(Buffer, Offset, Count);
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  mapped.Write(Buffer, Offset, Count);
  {$ELSEIF ECHOES}
  mapped.Write(Buffer, Offset, Count);
  {$ELSEIF NOUGAT}
  var Bin := new NSData withBytes(@Buffer[Offset]) length(Count);
  mapped.writeData(Bin);
  {$ENDIF}
end;

method FileHandle.&Write(Buffer: array of Byte; Count: Integer);
begin
  &Write(Buffer, 0, Count);
end;

method FileHandle.&Write(Buffer: array of Byte);
begin
  &Write(Buffer, 0, RemObjects.Oxygene.System.length(Buffer));
end;

method FileHandle.&Write(Data: Binary);
begin
  SugarArgumentNullException.RaiseIfNil(Data, "Data");
  &Write(Data.ToArray, 0, Data.Length);
end;

method FileHandle.Seek(Offset: Int64; Origin: SeekOrigin);
begin
  {$IF COOPER}
  case Origin of
    SeekOrigin.Begin: mapped.seek(Offset);
    SeekOrigin.Current: mapped.seek(Position + Offset);
    SeekOrigin.End: mapped.seek(Length + Offset);
  end;
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  mapped.Seek(Offset, System.IO.SeekOrigin(Origin));
  {$ELSEIF ECHOES}
  mapped.Seek(Offset, System.IO.SeekOrigin(Origin));
  {$ELSEIF NOUGAT}  
  case Origin of
    SeekOrigin.Begin: mapped.seekToFileOffset(Offset);
    SeekOrigin.Current: mapped.seekToFileOffset(Position + Offset);
    SeekOrigin.End: mapped.seekToFileOffset(Length + Offset);
  end;
  {$ENDIF}
end;

method FileHandle.GetLength: Int64;
begin
  {$IF COOPER}
  exit mapped.length;
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  exit mapped.Length;
  {$ELSEIF ECHOES}
  exit mapped.Length;
  {$ELSEIF NOUGAT}
  var Origin := mapped.offsetInFile;
  result := mapped.seekToEndOfFile;
  mapped.seekToFileOffset(Origin);
  {$ENDIF}
end;

method FileHandle.SetLength(value: Int64);
begin
  {$IF COOPER}
  mapped.setLength(Value);
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  var Origin := mapped.Position;
  mapped.SetLength(value);
  if Origin > value then
    Seek(0, SeekOrigin.Begin)
  else
    Seek(Origin, SeekOrigin.Begin);
  {$ELSEIF ECHOES}
  mapped.SetLength(Value);
  {$ELSEIF NOUGAT}
  var Origin := mapped.offsetInFile;
  mapped.truncateFileAtOffset(value);
  if Origin > value then
    Seek(0, SeekOrigin.Begin)
  else
    Seek(Origin, SeekOrigin.Begin);
  {$ENDIF}
end;

method FileHandle.GetPosition: Int64;
begin
  {$IF COOPER}
  exit mapped.FilePointer;
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  exit mapped.Position;
  {$ELSEIF ECHOES}
  exit mapped.Position;
  {$ELSEIF NOUGAT}
  exit mapped.offsetInFile;
  {$ENDIF}
end;

method FileHandle.SetPosition(value: Int64);
begin
  {$IF COOPER}
  Seek(value, SeekOrigin.Begin);
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  mapped.Position := value;
  {$ELSEIF ECHOES}
  mapped.Position := value;
  {$ELSEIF NOUGAT}
  Seek(value, SeekOrigin.Begin);
  {$ENDIF}
end;

end.
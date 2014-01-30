namespace Sugar.IO;

interface

uses
  {$IF WINDOWS_PHONE OR NETFX_CORE}
  System.Runtime.InteropServices.WindowsRuntime,
  System.IO,
  {$ENDIF}
  Sugar;

type
  FileOpenMode = public (&Read, ReadWrite, &Write);
  SeekOrigin = public (&Begin, Current, &End);

  FileHandle = public class
  private
    {$IF COOPER}
    Data: java.io.RandomAccessFile;
    {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
    Data: Stream;
    {$ELSEIF ECHOES}
    Data: System.IO.FileStream;
    {$ELSEIF NOUGAT}
    Data: NSFileHandle;
    {$ENDIF}

    method GetLength: Int64;
    method SetLength(value: Int64);
    method GetPosition: Int64;
    method SetPosition(value: Int64);
    method ValidateBuffer(Buffer: array of Byte; Offset: Integer; Count: Integer);
  public
    constructor(aFileName: String; aMode: FileOpenMode);

    method Close;
    method Flush;
    method &Read(Buffer: array of Byte; Offset: Integer; Count: Integer): Integer;
    method &Write(Buffer: array of Byte; Offset: Integer; Count: Integer);
    method Seek(Offset: Int64; Origin: SeekOrigin);

    property FileName: String read write; readonly;
    property Mode: FileOpenMode read write; readonly;
    property Length: Int64 read GetLength write SetLength;
    property Position: Int64 read GetPosition write SetPosition;
  end;

implementation

constructor FileHandle(aFileName: String; aMode: FileOpenMode);
begin
  FileName := aFileName;
  Mode := aMode;
  {$IF COOPER}
  var lMode: String := case aMode of
      FileOpenMode.Read: "r";
      FileOpenMode.ReadWrite: "rw";
      FileOpenMode.Write: "rw";
  end;
  Data := new java.io.RandomAccessFile(aFileName, lMode);
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  var lFile: Windows.Storage.StorageFile := Windows.Storage.StorageFile.GetFileFromPathAsync(aFileName).Await;
  var lMode: Windows.Storage.FileAccessMode := case aMode of
      FileOpenMode.Read: Windows.Storage.FileAccessMode.Read;
      FileOpenMode.ReadWrite: Windows.Storage.FileAccessMode.ReadWrite;
      FileOpenMode.Write: Windows.Storage.FileAccessMode.ReadWrite;
  end;
  Data := lFile.OpenAsync(lMode).Await.AsStream;
  {$ELSEIF ECHOES}
  var lMode: System.IO.FileAccess := case aMode of
      FileOpenMode.Read: System.IO.FileAccess.Read;
      FileOpenMode.ReadWrite: System.IO.FileAccess.ReadWrite;
      FileOpenMode.Write: System.IO.FileAccess.Write;
  end;
  Data := new System.IO.FileStream(aFileName, System.IO.FileMode.Open, lMode, System.IO.FileShare.Read);
  {$ELSEIF NOUGAT}
  case aMode of
    FileOpenMode.Read: Data := NSFileHandle.fileHandleForReadingAtPath(aFileName);
    FileOpenMode.ReadWrite: Data := NSFileHandle.fileHandleForUpdatingAtPath(aFileName);
    FileOpenMode.Write: Data := NSFileHandle.fileHandleForWritingAtPath(aFileName);
  end;
  {$ENDIF}
end;

method FileHandle.Close;
begin
  {$IF COOPER}
  Data.close;
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}  
  Data.Dispose;
  {$ELSEIF ECHOES}
  Data.Close;
  {$ELSEIF NOUGAT}
  Data.closeFile;
  {$ENDIF}
end;

method FileHandle.Flush;
begin
  {$IF COOPER}
  Data.Channel.force(false);
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  Data.Flush;
  {$ELSEIF ECHOES}
  Data.Flush;
  {$ELSEIF NOUGAT}
  Data.synchronizeFile;
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
  if Mode = FileOpenMode.Write then
    raise new SugarIOException(ErrorMessage.FILE_WRITE_ERROR, FileName);

  ValidateBuffer(Buffer, Offset, Count);
  {$IF COOPER}
  exit Data.read(Buffer, Offset, Count);
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  exit Data.Read(Buffer, Offset, Count);
  {$ELSEIF ECHOES}
  exit Data.Read(Buffer, Offset, Count);
  {$ELSEIF NOUGAT}
  var Bin := Data.readDataOfLength(Count);
  Bin.getBytes(@Buffer[Offset]) length(Bin.length);

  exit Bin.length;
  {$ENDIF}
end;

method FileHandle.Write(Buffer: array of Byte; Offset: Integer; Count: Integer);
begin
  if Mode = FileOpenMode.Read then
    raise new SugarIOException(ErrorMessage.FILE_READ_ERROR, FileName);

  ValidateBuffer(Buffer, Offset, Count);
  {$IF COOPER}
  Data.write(Buffer, Offset, Count);
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  Data.Write(Buffer, Offset, Count);
  {$ELSEIF ECHOES}
  Data.Write(Buffer, Offset, Count);
  {$ELSEIF NOUGAT}
  var Bin := new NSData withBytes(@Buffer[Offset]) length(Count);
  Data.writeData(Bin);
  {$ENDIF}
end;

method FileHandle.Seek(Offset: Int64; Origin: SeekOrigin);
begin
  {$IF COOPER}
  case Origin of
    SeekOrigin.Begin: Data.seek(Offset);
    SeekOrigin.Current: Data.seek(Position + Offset);
    SeekOrigin.End: Data.seek(Length + Offset);
  end;
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  Data.Seek(Offset, System.IO.SeekOrigin(Origin));
  {$ELSEIF ECHOES}
  Data.Seek(Offset, System.IO.SeekOrigin(Origin));
  {$ELSEIF NOUGAT}  
  case Origin of
    SeekOrigin.Begin: Data.seekToFileOffset(Offset);
    SeekOrigin.Current: Data.seekToFileOffset(Position + Offset);
    SeekOrigin.End: Data.seekToFileOffset(Length + Offset);
  end;
  {$ENDIF}
end;

method FileHandle.GetLength: Int64;
begin
  {$IF COOPER}
  exit Data.length;
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  exit Data.Length;
  {$ELSEIF ECHOES}
  exit Data.Length;
  {$ELSEIF NOUGAT}
  var Origin := Data.offsetInFile;
  result := Data.seekToEndOfFile;
  Data.seekToFileOffset(Origin);
  {$ENDIF}
end;

method FileHandle.SetLength(value: Int64);
begin
  {$IF COOPER}
  Data.setLength(Value);
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  var Origin := Data.Position;
  Data.SetLength(value);
  if Origin > value then
    Seek(0, SeekOrigin.Begin)
  else
    Seek(Origin, SeekOrigin.Begin);
  {$ELSEIF ECHOES}
  Data.SetLength(Value);
  {$ELSEIF NOUGAT}
  var Origin := Data.offsetInFile;
  Data.truncateFileAtOffset(value);
  if Origin > value then
    Seek(0, SeekOrigin.Begin)
  else
    Seek(Origin, SeekOrigin.Begin);
  {$ENDIF}
end;

method FileHandle.GetPosition: Int64;
begin
  {$IF COOPER}
  exit Data.FilePointer;
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  exit Data.Position;
  {$ELSEIF ECHOES}
  exit Data.Position;
  {$ELSEIF NOUGAT}
  exit Data.offsetInFile;
  {$ENDIF}
end;

method FileHandle.SetPosition(value: Int64);
begin
  {$IF COOPER}
  Seek(value, SeekOrigin.Begin);
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  Data.Position := value;
  {$ELSEIF ECHOES}
  Data.Position := value;
  {$ELSEIF NOUGAT}
  Seek(value, SeekOrigin.Begin);
  {$ENDIF}
end;

end.
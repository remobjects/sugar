namespace Sugar.IO;

interface

uses
  Sugar;

type
  FileOpenMode = public (&Read, ReadWrite, &Write);
  SeekOrigin = public (&Begin, Current, &End);

  FileHandle = public class
  private
    {$IF COOPER}
    Data: java.io.RandomAccessFile;
    {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
    {$ELSEIF ECHOES}
    {$ELSEIF NOUGAT}
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
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method FileHandle.Close;
begin
  {$IF COOPER}
  Data.close;
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}  
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method FileHandle.Flush;
begin
  {$IF COOPER}
  Data.Channel.force(false);
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
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
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
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
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
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
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}  
  {$ENDIF}
end;

method FileHandle.GetLength: Int64;
begin
  {$IF COOPER}
  exit Data.length;
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method FileHandle.SetLength(value: Int64);
begin
  {$IF COOPER}
  Data.setLength(Value);
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method FileHandle.GetPosition: Int64;
begin
  {$IF COOPER}
  exit Data.FilePointer;
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method FileHandle.SetPosition(value: Int64);
begin
  {$IF COOPER}
  Seek(value, SeekOrigin.Begin);
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

end.
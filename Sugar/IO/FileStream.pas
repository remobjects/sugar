namespace RemObjects.Oxygene.Sugar.IO;
{$HIDE W0} //supress case-mismatch errors
interface

uses
  RemObjects.Oxygene.Sugar;

type
  FileAccess = public enum(&Read, &Write, ReadWrite);
  SeekOrigin = public enum(&Begin, Current, &End);

  FileStream = public class
  private  
    Stream: {$IF COOPER}java.io.RandomAccessFile{$ELSEIF ECHOES}System.IO.FileStream{$ELSEIF NOUGAT}Foundation.NSFileHandle{$ENDIF};
    fAccess: FileAccess;

    method GetLength: Int64;
    method GetPosition: Int64;
    method SetPosition(Value: Int64);
  public
    constructor(FileName: String; Access: FileAccess);

    method Close;
    method Flush;

    method &Read(Buffer: array of Byte; Offset, Count: Integer): Integer;
    method &Write(Buffer: array of Byte; Offset, Count: Integer);
    method Seek(Offset: Int64; Origin: SeekOrigin);

    property Length: Int64 read GetLength;
    property Position: Int64 read GetPosition write SetPosition;
  end;

implementation

method FileStream.Close;
begin
  {$IF COOPER OR ECHOES}
  Stream.Close;
  {$ELSE}
  Stream.closeFile;
  {$ENDIF}
end;

method FileStream.Flush;
begin
  {$IF COOPER}
  Stream.Channel.force(true);
  {$ELSEIF ECHOES}
  Stream.Flush;
  {$ELSEIF NOUGAT}
  Stream.synchronizeFile;
  {$ENDIF}
end;

method FileStream.GetLength: Int64;
begin
  {$IF COOPER}
  exit Stream.length;
  {$ELSEIF ECHOES}
  exit Stream.Length;
  {$ELSEIF NOUGAT}
  var lPosition := Position;
  result := Stream.seekToEndOfFile;
  Seek(lPosition, SeekOrigin.Begin);
  {$ENDIF}
end;

method FileStream.&Read(Buffer: array of Byte; Offset: Integer; Count: Integer): Integer;
begin
  if fAccess = FileAccess.Write then
    raise new SugarException();

  {$IF COOPER}
  exit Stream.read(Buffer, Offset, Count);
  {$ELSEIF ECHOES}
  exit Stream.Read(Buffer, Offset, Count);
  {$ELSEIF NOUGAT}
  var Data := Stream.readDataOfLength(Count);
  var Bytes: array of Byte := new Byte[Data.length];
  Data.getBytes(Bytes) length(Data.length);
  memcpy(@Buffer[Offset], Bytes, Count);
  exit Data.length;
  {$ENDIF}
end;

method FileStream.&Write(Buffer: array of Byte; Offset: Integer; Count: Integer);
begin
  if fAccess = FileAccess.Read then
    raise new SugarException();

  {$IF COOPER}
  Stream.write(Buffer, Offset, Count);
  {$ELSEIF ECHOES}  
  Stream.Write(Buffer, Offset, Count);
  {$ELSEIF NOUGAT}
  var Data := Foundation.NSData.dataWithBytes(@Buffer[Offset]) length(Count);
  Stream.writeData(Data);
  {$ENDIF}
end;

constructor FileStream(FileName: String; Access: FileAccess);
begin
  if (Access = FileAccess.Read) and (not File.Exists(FileName)) then
    raise new SugarException();

  fAccess := Access;

  {$IF COOPER}
  Stream := new java.io.RandomAccessFile(FileName, iif(Access = FileAccess.Read, "r", "rw"));
  {$ELSEIF ECHOES}
  var Mode: System.IO.FileAccess := case Access of
                                      FileAccess.Read: System.IO.FileAccess.Read;
                                      FileAccess.Write: System.IO.FileAccess.Write;
                                      FileAccess.ReadWrite: System.IO.FileAccess.ReadWrite;
                                    end;
  Stream := new System.IO.FileStream(FileName, System.IO.FileMode.OpenOrCreate, Mode);
  {$ELSEIF NOUGAT}
  case Access of
    FileAccess.Read: Stream := Foundation.NSFileHandle.fileHandleForReadingAtPath(FileName);
    FileAccess.ReadWrite: Stream := Foundation.NSFileHandle.fileHandleForUpdatingAtPath(FileName);
    FileAccess.Write: Stream := Foundation.NSFileHandle.fileHandleForWritingAtPath(FileName);
  end;
  {$ENDIF}  
end;

method FileStream.GetPosition: Int64;
begin
  {$IF COOPER}
  exit Stream.FilePointer;
  {$ELSEIF ECHOES}  
  exit Stream.Position;
  {$ELSEIF NOUGAT}
  exit Stream.offsetInFile;
  {$ENDIF}
end;

method FileStream.SetPosition(Value: Int64);
begin
  Seek(Value, SeekOrigin.Begin);
end;

method FileStream.Seek(Offset: Int64; Origin: SeekOrigin);
begin
  {$IF COOPER}
  case Origin of
    SeekOrigin.Begin: Stream.seek(Offset);
    SeekOrigin.Current: Stream.seek(Offset + Stream.FilePointer);
    SeekOrigin.End: Stream.seek(Length+Offset);
  end;
  {$ELSEIF ECHOES}  
  Stream.Seek(Offset, System.IO.SeekOrigin(Origin));
  {$ELSEIF NOUGAT}
  case Origin of
    SeekOrigin.Begin: Stream.seekToFileOffset(Offset);
    SeekOrigin.Current: Stream.seekToFileOffset(Offset + Stream.offsetInFile);
    SeekOrigin.End: Stream.seekToFileOffset(Length+Offset);
  end;
  {$ENDIF}
end;

end.

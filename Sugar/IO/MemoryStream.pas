namespace RemObjects.Oxygene.Sugar.IO;
{$HIDE W0} //supress case-mismatch errors
interface

type
  {$IF ECHOES}
  MemoryStream = public class mapped to System.IO.MemoryStream
  public
    method &Read(Offset: Integer; Count: Integer): array of byte;
    method &Write(Data: array of byte; Offset: Integer; Count: Integer); mapped to &Write(Data, Offset, Count);
    method ToArray: array of byte; mapped to ToArray;

    method CopyTo(Target: MemoryStream);
    property Length: Int64 read mapped.Length;
  end;
  {$ELSEIF NOUGAT}
  MemoryStream = public class mapped to Foundation.NSMutableData
    //method &Read(Data: array of byte; Offset: Integer; Count: Integer); mapped to getBytes(Data) range(new Foundation.NSRange(length := Count, location := Offset));
    method &Read(Offset: Integer; Count: Integer): array of byte;
    method &Write(Data: array of byte; Offset: Integer; Count: Integer);
    method ToArray: array of byte;

    method CopyTo(Target: MemoryStream); 
    property Length: Int64 read mapped.Length;
  end;
  {$ELSEIF COOPER}
  MemoryStream = public class
  private
    fStream: java.io.ByteArrayOutputStream := new java.io.ByteArrayOutputStream();

    method GetLength: Int64;
  public
    method &Read(Offset: Integer; Count: Integer): array of byte;
    method &Write(Data: array of byte; Offset: Integer; Count: Integer);
    method ToArray: array of byte;

    method CopyTo(Target: MemoryStream); 
    property Length: Int64 read GetLength;
  end;
  {$ENDIF}

implementation

{$IF NOUGAT}
method MemoryStream.Write(Data: array of byte; Offset: Integer; Count: Integer);
begin
  var lData: array of byte := new byte[Count];
  memcpy(lData, @Data[Offset], Count);
  mapped.appendBytes(lData) length(Count);
end;

method MemoryStream.ToArray: array of byte;
begin
  result := new byte[mapped.Length];
  mapped.getBytes(Result);
end;

{$ELSEIF COOPER}
method MemoryStream.&Write(Data: array of byte; Offset: Integer; Count: Integer);
begin
  fStream.write(Data, Offset, Count);
end;

method MemoryStream.ToArray: array of byte;
begin
  result := fStream.toByteArray;
end;

method MemoryStream.GetLength: Int64;
begin
  exit fStream.size;
end;
{$ENDIF}

method MemoryStream.&Read(Offset: Integer; Count: Integer): array of byte;
begin
  {$IF ECHOES}
  result := new byte[Count];
  Array.Copy(mapped.ToArray, Offset, result, 0, Count);
  {$ELSEIF COOPER}
  exit java.util.Arrays.copyOfRange(ToArray, Offset, Offset+Count);
  {$ELSEIF NOUGAT} 
  result := new byte[Count];
  mapped.getBytes(result) range(new Foundation.NSRange(length := Count, location := Offset));
  {$ENDIF}
end;

method MemoryStream.CopyTo(Target: MemoryStream); 
begin
  {$IF ECHOES}
  Target.Write(mapped.ToArray, 0, mapped.Length);
  {$ELSEIF COOPER}
  Target.Write(self.ToArray, 0, self.Length);
  {$ELSEIF NOUGAT} 
  Foundation.NSMutableData(Target).appendData(mapped);
  {$ENDIF}
end;

end.

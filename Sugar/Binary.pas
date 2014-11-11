namespace Sugar;

interface

type
  Range = public record {$IF NOUGAT}mapped to Foundation.NSRange{$ENDIF}
  public
    class method MakeRange(aLocation, aLength: Integer): Range;

    property Location: Integer {$IF NOUGAT}read mapped.location write mapped.location{$ENDIF};
    property Length: Integer {$IF NOUGAT} read mapped.length write mapped.length{$ENDIF};
  end;

  RangeHelper = public static class
  public
    method Validate(aRange: Range; BufferSize: Integer);
  end;

  Binary = public class {$IF ECHOES}mapped to System.IO.MemoryStream{$ELSEIF NOUGAT}mapped to Foundation.NSMutableData{$ENDIF}
  {$IF COOPER}
  private
    fData: java.io.ByteArrayOutputStream := new java.io.ByteArrayOutputStream();
  {$ENDIF}
  public
    constructor; {$IF NOUGAT OR ECHOES}mapped to constructor();{$ELSE}empty;{$ENDIF}
    constructor(anArray: array of Byte);
    constructor(Bin: Binary);    

    method Assign(Bin: Binary);
    method Clear;

    method &Read(Range: Range): array of Byte;
    method &Read(Count: Integer): array of Byte;
    
    method Subdata(Range: Range): Binary;

    method &Write(Buffer: array of Byte; Offset: Integer; Count: Integer);
    method &Write(Buffer: array of Byte; Count: Integer);
    method &Write(Buffer: array of Byte);
    method &Write(Bin: Binary);

    method ToArray: array of Byte;
    property Length: Integer read {$IF COOPER}fData.size{$ELSEIF ECHOES}mapped.Length{$ELSEIF NOUGAT}mapped.length{$ENDIF};
  end;

implementation

{ Range }

class method Range.MakeRange(aLocation: Integer; aLength: Integer): Range;
begin  
  exit new Range(Location := aLocation, Length := aLength);
end;

{ RangeHelper }

class method RangeHelper.Validate(aRange: Range; BufferSize: Integer);
begin
  if aRange.Location < 0 then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.NEGATIVE_VALUE_ERROR, "Location");

  if aRange.Length < 0 then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.NEGATIVE_VALUE_ERROR, "Length");

  if aRange.Location >= BufferSize then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.ARG_OUT_OF_RANGE_ERROR, "Location");

  if aRange.Length > BufferSize then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.ARG_OUT_OF_RANGE_ERROR, "Length");

  if aRange.Location + aRange.Length > BufferSize then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.OUT_OF_RANGE_ERROR, aRange.Location, aRange.Length, BufferSize);
end;

{ Binary }
constructor Binary(anArray: array of Byte);
begin
  if anArray = nil then
    raise new SugarArgumentNullException("Array");

  {$IF COOPER}
  &Write(anArray, anArray.length);
  {$ELSEIF ECHOES}
  var ms := new System.IO.MemoryStream;
  ms.Write(anArray, 0, anArray.Length);
  exit ms;
  {$ELSEIF NOUGAT}
  exit NSMutableData.dataWithBytes(anArray) length(length(anArray)); 
  {$ENDIF}  
end;

constructor Binary(Bin: Binary);
begin
  SugarArgumentNullException.RaiseIfNil(Bin, "Bin");
  {$IF COOPER}
  Assign(Bin);
  {$ELSEIF ECHOES}
  var ms := new System.IO.MemoryStream;
  System.IO.MemoryStream(Bin).WriteTo(ms);
  exit ms;
  {$ELSEIF NOUGAT}
  exit NSMutableData.dataWithData(Bin);
  {$ENDIF} 
end;

method Binary.Assign(Bin: Binary);
begin
  {$IF COOPER}
  Clear;
  if Bin <> nil then
    fData.Write(Bin.ToArray, 0, Bin.Length);
  {$ELSEIF ECHOES}
  Clear;
  if Bin <> nil then
    System.IO.MemoryStream(Bin).WriteTo(System.IO.MemoryStream(self));
  {$ELSEIF NOUGAT}
  mapped.setData(Bin);
  {$ENDIF}
end;

method Binary.Read(Range: Range): array of Byte;
begin
  if Range.Length = 0 then
    exit [];

  RangeHelper.Validate(Range, self.Length);

  result := new Byte[Range.Length];
  {$IF COOPER}  
  System.arraycopy(fData.toByteArray, Range.Location, result, 0, Range.Length);
  {$ELSEIF ECHOES}
  mapped.Position := Range.Location;
  mapped.Read(result, 0, Range.Length);
  {$ELSEIF NOUGAT}
  mapped.getBytes(result) range(Range);
  {$ENDIF}
end;

method Binary.Read(Count: Integer): array of Byte;
begin
  exit &Read(Range.MakeRange(0, Math.Min(Count, self.Length)));
end;

method Binary.Subdata(Range: Range): Binary;
begin
  exit new Binary(&Read(Range));
end;

method Binary.&Write(Buffer: array of Byte; Offset: Integer; Count: Integer);
begin
  if Buffer = nil then
    raise new SugarArgumentNullException("Buffer");

  if Count = 0 then
    exit;

  RangeHelper.Validate(Range.MakeRange(Offset, Count), Buffer.Length);
  {$IF COOPER}
  fData.write(Buffer, Offset, Count);
  {$ELSEIF ECHOES}
  mapped.Seek(0, System.IO.SeekOrigin.End);
  mapped.Write(Buffer, Offset, Count);
  {$ELSEIF NOUGAT}
  mapped.appendBytes(@Buffer[Offset]) length(Count);
  {$ENDIF}  
end;

method Binary.Write(Buffer: array of Byte; Count: Integer);
begin
  &Write(Buffer, 0, Count);
end;

method Binary.&Write(Buffer: array of Byte);
begin
  &Write(Buffer, RemObjects.Oxygene.System.length(Buffer));
end;

method Binary.Write(Bin: Binary);
begin
  SugarArgumentNullException.RaiseIfNil(Bin, "Bin");
  {$IF COOPER OR ECHOES}
  &Write(Bin.ToArray, Bin.Length);
  {$ELSEIF NOUGAT}
  mapped.appendData(Bin);
  {$ENDIF}  
end;

method Binary.ToArray: array of Byte;
begin
  {$IF COOPER}
  exit fData.toByteArray;
  {$ELSEIF ECHOES}
  exit mapped.ToArray;
  {$ELSEIF NOUGAT}
  result := new Byte[mapped.length];
  mapped.getBytes(result) length(mapped.length);
  {$ENDIF}  
end;

method Binary.Clear;
begin
  {$IF COOPER}
  fData.reset;
  {$ELSEIF ECHOES}
  mapped.SetLength(0);
  mapped.Position := 0;
  {$ELSEIF NOUGAT}
  mapped.setLength(0);
  {$ENDIF}  
end;

end.

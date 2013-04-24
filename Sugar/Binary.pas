namespace RemObjects.Oxygene.Sugar;

{$HIDE W0} //supress case-mismatch errors

interface

type
  Range = public record {$IF NOUGAT}mapped to Foundation.NSRange{$ENDIF}
  public
    class method MakeRange(aLocation, aLength: Integer): Range;

    property Location: Integer {$IF NOUGAT}read mapped.location write mapped.location{$ENDIF};
    property Length: Integer {$IF NOUGAT} read mapped.length write mapped.length{$ENDIF};
  end;

  {$IF COOPER}
  Binary = public class
  private
    fData: java.io.ByteArrayOutputStream := new java.io.ByteArrayOutputStream();
  public
    method Assign(Data: Binary);
    method Clear;

    method ReadRangeOfBytes(Range: Range): array of Byte;
    method ReadBytes(aLength: Integer): array of Byte; 
    
    method Subdata(Range: Range): Binary;

    method WriteBytes(Data: array of Byte; aLength: Integer);
    method WriteData(Data: Binary);

    method ToArray: array of Byte;
    property Length: Integer read fData.size;
  end;
  {$ELSEIF ECHOES}
  Binary = public class
  private
    fData: System.IO.MemoryStream := new System.IO.MemoryStream();
  public
    method Assign(Data: Binary);
    method Clear;

    method ReadRangeOfBytes(Range: Range): array of Byte;
    method ReadBytes(aLength: Integer): array of Byte; 
    
    method Subdata(Range: Range): Binary;

    method WriteBytes(Data: array of Byte; aLength: Integer);
    method WriteData(Data: Binary);

    method ToArray: array of Byte;
    property Length: Integer read fData.Length;
  end;
  {$ELSEIF NOUGAT}
  Binary = public class mapped to Foundation.NSMutableData
  private
    method ConvertRange(Range: Range): Foundation.NSRange;
  public
    method Assign(Data: Binary); mapped to setData(Data);
    method Clear; mapped to setLength(0);

    method ReadRangeOfBytes(Range: Range): array of Byte;
    method ReadBytes(aLength: Integer): array of Byte; 
    
    method Subdata(Range: Range): Binary;

    method WriteBytes(Data: array of Byte; aLength: Integer); mapped to appendBytes(Data) length(aLength);
    method WriteData(Data: Binary); mapped to appendData(Data);

    method ToArray: array of Byte;
    property Length: Integer read mapped.length;
  end;
  {$ENDIF}


implementation

class method Range.MakeRange(aLocation: Integer; aLength: Integer): Range;
begin
  exit new Range(Location := aLocation, Length := aLength);
end;
{$IF COOPER}
method Binary.Assign(Data: Binary);
begin
  Clear;
  fData.write(Data.ToArray, 0, Data.Length);
end;

method Binary.ReadRangeOfBytes(Range: Range): array of Byte;
begin
  result := new Byte[Range.Length];
  System.arraycopy(fData.toByteArray, Range.Location, result, 0, Range.Length);
end;

method Binary.ReadBytes(aLength: Integer): array of Byte;
begin
  result := ReadRangeOfBytes(Range.MakeRange(0, aLength));
end;

method Binary.Subdata(Range: Range): Binary;
begin
  var Data := ReadRangeOfBytes(Range);
  result := new Binary();
  result.WriteBytes(Data, Data.length);
end;

method Binary.WriteBytes(Data: array of Byte; aLength: Integer);
begin
  fData.write(Data, 0, aLength);
end;

method Binary.WriteData(Data: Binary);
begin
  WriteBytes(Data.ToArray, Data.Length);
end;

method Binary.ToArray: array of Byte;
begin
  exit fData.toByteArray;
end;

method Binary.Clear;
begin
  fData.reset;
end;
{$ELSEIF ECHOES}
method Binary.Assign(Data: Binary);
begin
  Clear;
  fData.Write(Data.ToArray, 0, Data.Length);
end;

method Binary.ReadRangeOfBytes(Range: Range): array of Byte;
begin
  result := new Byte[Range.Length];
  var lPosition := fData.Position;
  fData.Position := Range.Location;
  try
    fData.Read(result, 0, Range.Length);
  finally
    fData.Position := lPosition;
  end;
end;

method Binary.ReadBytes(aLength: Integer): array of Byte;
begin
  result := ReadRangeOfBytes(Range.MakeRange(0, aLength));
end;

method Binary.Subdata(Range: Range): Binary;
begin
  var Data := ReadRangeOfBytes(Range);
  result := new Binary();
  result.WriteBytes(Data, Data.Length);
end;

method Binary.WriteBytes(Data: array of Byte; aLength: Integer);
begin
  fData.Write(Data, 0, aLength);
end;

method Binary.WriteData(Data: Binary);
begin
  WriteBytes(Data.ToArray, Data.Length);
end;

method Binary.ToArray: array of Byte;
begin
  exit fData.ToArray;
end;

method Binary.Clear;
begin
  fData.SetLength(0);
end;
{$ELSEIF NOUGAT}
method Binary.ToArray: array of Byte;
begin
  result := new Byte[mapped.length];
  mapped.getBytes(result) length(mapped.length);
end;

method Binary.ConvertRange(Range: Range): Foundation.NSRange;
begin
  result.length := Range.Length;
  result.location := Range.Location;
end;

method Binary.Subdata(Range: Range): Binary;
begin
  exit Foundation.NSMutableData.dataWithData(mapped.subdataWithRange(ConvertRange(Range)));
end;

method Binary.ReadBytes(aLength: Integer): array of Byte;
begin
  result := new Byte[aLength];
  mapped.getBytes(result) length(aLength);
end;

method Binary.ReadRangeOfBytes(Range: Range): array of Byte;
begin
  result := new Byte[Range.Length];
  mapped.getBytes(result) range(ConvertRange(Range));
end;
{$ENDIF}

end.

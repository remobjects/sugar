namespace RemObjects.Oxygene.Sugar;

{$HIDE W0} //supress case-mismatch errors

interface

{$IF COOPER}
uses
  RemObjects.Oxygene.Sugar.Cooper;
{$ENDIF}

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
    method Assign(aData: Binary);
    method Clear;

    method ReadRangeOfBytes(Range: Range): array of Byte;
    method ReadBytes(aLength: Integer): array of Byte; 
    
    method Subdata(Range: Range): Binary;

    method WriteBytes(aData: array of Byte; aLength: Integer);
    method WriteData(aData: Binary);

    method ToArray: array of Byte;
    property Length: Integer read fData.size;

    class method FromArray(aArray: array of Byte): Binary;
  end;
  {$ELSEIF ECHOES}
  Binary = public class
  private
    fData: System.IO.MemoryStream := new System.IO.MemoryStream();
  assembly
    property Data: System.IO.MemoryStream read fData;
  public
    method Assign(aData: Binary);
    method Clear;

    method ReadRangeOfBytes(Range: Range): array of Byte;
    method ReadBytes(aLength: Integer): array of Byte; 
    
    method Subdata(Range: Range): Binary;

    method WriteBytes(aData: array of Byte; aLength: Integer);
    method WriteData(aData: Binary);

    method ToArray: array of Byte;
    property Length: Integer read fData.Length;

    class method FromArray(aArray: array of Byte): Binary;
  end;
  {$ELSEIF NOUGAT}
  Binary = public class mapped to Foundation.NSMutableData
  public
    method Assign(aData: Binary); mapped to setData(aData);
    method Clear; mapped to setLength(0);

    method ReadRangeOfBytes(Range: Range): array of Byte;
    method ReadBytes(aLength: Integer): array of Byte; 
    
    method Subdata(Range: Range): Binary;

    method WriteBytes(aData: array of Byte; aLength: Integer);
    method WriteData(aData: Binary);

    method ToArray: array of Byte;
    property Length: Integer read mapped.length;

    class method FromArray(aArray: array of Byte): Binary;
  end;
  {$ENDIF}


implementation

class method Range.MakeRange(aLocation: Integer; aLength: Integer): Range;
begin
  exit new Range(Location := aLocation, Length := aLength);
end;

{$IF COOPER}
method Binary.Assign(aData: Binary);
begin
  Clear;
  if aData <> nil then
    fData.write(ArrayUtils.ToSignedArray(aData.ToArray), 0, aData.Length);
end;

method Binary.ReadRangeOfBytes(Range: Range): array of Byte;
begin
  if Range.Length = 0 then
    exit [];

  if Range.Location + Range.Length > fData.size then
    raise new SugarArgumentOutOfRangeException(String.Format(ErrorMessage.OUT_OF_RANGE_ERROR, Range.Location, Range.Length, fData.size));

  result := new Byte[Range.Length];
  System.arraycopy(fData.toByteArray, Range.Location, result, 0, Range.Length);
end;

method Binary.ReadBytes(aLength: Integer): array of Byte;
begin
  result := ReadRangeOfBytes(Range.MakeRange(0, Math.MinInt(aLength, fData.size)));
end;

method Binary.Subdata(Range: Range): Binary;
begin
  var lData := ReadRangeOfBytes(Range);
  exit Binary.FromArray(lData);
end;

method Binary.WriteBytes(aData: array of Byte; aLength: Integer);
begin
  fData.write(ArrayUtils.ToSignedArray(aData), 0, aLength);
end;

method Binary.WriteData(aData: Binary);
begin
  WriteBytes(aData.ToArray, aData.Length);
end;

method Binary.ToArray: array of Byte;
begin
  exit ArrayUtils.ToUnsignedArray(fData.toByteArray);
end;

method Binary.Clear;
begin
  fData.reset;
end;

class method Binary.FromArray(aArray: array of Byte): Binary;
begin
  result := new Binary;
  result.WriteBytes(aArray, aArray.length);
end;
{$ELSEIF ECHOES}
method Binary.Assign(aData: Binary);
begin
  Clear;
  if aData <> nil then
    fData.Write(aData.ToArray, 0, aData.Length);
end;

method Binary.ReadRangeOfBytes(Range: Range): array of Byte;
begin
  if Range.Length = 0 then
    exit [];

  if Range.Location + Range.Length > fData.Length then
    raise new SugarArgumentOutOfRangeException(String.Format(ErrorMessage.OUT_OF_RANGE_ERROR, Range.Location, Range.Length, fData.Length));

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
  result := ReadRangeOfBytes(Range.MakeRange(0, Math.MinInt(aLength, fData.Length)));
end;

method Binary.Subdata(Range: Range): Binary;
begin
  var lData := ReadRangeOfBytes(Range);
  exit Binary.FromArray(lData);
end;

method Binary.WriteBytes(aData: array of Byte; aLength: Integer);
begin
  fData.Write(aData, 0, aLength);
end;

method Binary.WriteData(aData: Binary);
begin
  WriteBytes(aData.ToArray, aData.Length);
end;

method Binary.ToArray: array of Byte;
begin
  exit fData.ToArray;
end;

method Binary.Clear;
begin
  fData.SetLength(0);
end;

class method Binary.FromArray(aArray: array of Byte): Binary;
begin
  result := new Binary;
  result.WriteBytes(aArray, aArray.Length);
end;

{$ELSEIF NOUGAT}

method Binary.ToArray: array of Byte;
begin
  result := new Byte[mapped.length];
  mapped.getBytes(result) length(mapped.length);
end;

method Binary.Subdata(Range: Range): Binary;
begin
  exit Foundation.NSMutableData.dataWithData(mapped.subdataWithRange(Range));
end;

method Binary.ReadBytes(aLength: Integer): array of Byte;
begin
  result := ReadRangeOfBytes(Range.MakeRange(0, Math.MinInt(aLength, mapped.Length)));
end;

method Binary.WriteBytes(aData: array of Byte; aLength: Integer);
begin
  if aData = nil then
    raise new SugarArgumentNullException("aData");

  if aLength = 0 then
    exit;

  if aLength > RemObjects.Oxygene.System.length(aData) then
    raise new SugarArgumentOutOfRangeException(String.Format("Length {0} exceeds data length {1}", aLength, RemObjects.Oxygene.System.length(aData)));

  mapped.appendBytes(aData) length(aLength);
end;

method Binary.ReadRangeOfBytes(Range: Range): array of Byte;
begin
  if Range.Length = 0 then
    exit [];

  if Range.Location + Range.Length > mapped.length then
    raise new SugarArgumentOutOfRangeException(String.Format(ErrorMessage.OUT_OF_RANGE_ERROR, Range.Location, Range.Length, mapped.length));

  result := new Byte[Range.Length];
  mapped.getBytes(result) range(Range);
end;

method Binary.WriteData(aData: Binary);
begin
  if aData = nil then
    raise new SugarArgumentNullException("aData");

  mapped.appendData(aData);
end;

class method Binary.FromArray(aArray: array of Byte): Binary;
begin
  if aArray = nil then
    raise new SugarArgumentNullException("aArray");

  exit NSMutableData.dataWithBytes(aArray) length(length(aArray)); 
end;
{$ENDIF}

end.

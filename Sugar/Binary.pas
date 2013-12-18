namespace Sugar;

{$HIDE W0} //supress case-mismatch errors

interface

{$IF COOPER}
uses
  Sugar.Cooper;
{$ENDIF}

type
  Range = public record {$IF NOUGAT}mapped to Foundation.NSRange{$ENDIF}
  public
    class method MakeRange(aLocation, aLength: Integer): Range;

    property Location: Integer {$IF NOUGAT}read mapped.location write mapped.location{$ENDIF};
    property Length: Integer {$IF NOUGAT} read mapped.length write mapped.length{$ENDIF};
  end;

  Binary = public class {$IF NOUGAT}mapped to Foundation.NSMutableData{$ENDIF}
  {$IF COOPER}
  private
    fData: java.io.ByteArrayOutputStream := new java.io.ByteArrayOutputStream();
  {$ELSEIF ECHOES}
  private
    fData: System.IO.MemoryStream := new System.IO.MemoryStream();
  assembly
    property Data: System.IO.MemoryStream read fData;
  {$ENDIF}
  public
    constructor; {$IF NOUGAT}mapped to constructor();{$ELSE}empty;{$ENDIF}
    constructor(anArray: array of Byte);
    constructor(Bin: Binary);    

    method Assign(aData: Binary);
    method Clear;

    method &Read(Range: Range): array of Byte;
    method &Read(aLength: Integer): array of Byte;
    
    method Subdata(Range: Range): Binary;

    method &Write(aData: array of Byte; aLength: Integer);
    method &Write(aData: Binary);

    method ToArray: array of Byte;
    property Length: Integer read {$IF COOPER}fData.size{$ELSEIF ECHOES}fData.Length{$ELSEIF NOUGAT}mapped.length{$ENDIF};
  end;

implementation

{ Range }

class method Range.MakeRange(aLocation: Integer; aLength: Integer): Range;
begin  
  exit new Range(Location := aLocation, Length := aLength);
end;

{ Binary }
constructor Binary(anArray: array of Byte);
begin
  if anArray = nil then
    raise new SugarArgumentNullException("Array");

  {$IF COOPER OR ECHOES}
  &Write(anArray, anArray.length);
  {$ELSEIF NOUGAT}
  exit NSMutableData.dataWithBytes(anArray) length(length(anArray)); 
  {$ENDIF}  
end;

constructor Binary(Bin: Binary);
begin
  SugarArgumentNullException.RaiseIfNil(Bin, "Bin");
  {$IF COOPER OR ECHOES}
  Assign(Bin);
  {$ELSEIF NOUGAT}
  exit NSMutableData.dataWithData(Bin);
  {$ENDIF} 
end;

method Binary.Assign(aData: Binary);
begin
  {$IF COOPER OR ECHOES}
  Clear;
  if aData <> nil then
    fData.write(aData.ToArray, 0, aData.Length);
  {$ELSEIF NOUGAT}
  mapped.setData(aData);
  {$ENDIF}
end;

method Binary.Read(Range: Range): array of Byte;
begin
  if Range.Length = 0 then
    exit [];

  if Range.Location + Range.Length > self.Length then
    raise new SugarArgumentOutOfRangeException(String.Format(ErrorMessage.OUT_OF_RANGE_ERROR, Range.Location, Range.Length, self.Length));

  result := new Byte[Range.Length];
  {$IF COOPER}  
  System.arraycopy(fData.toByteArray, Range.Location, result, 0, Range.Length);
  {$ELSEIF ECHOES}
  var lPosition := fData.Position;
  fData.Position := Range.Location;
  try
    fData.Read(result, 0, Range.Length);
  finally
    fData.Position := lPosition;
  end;
  {$ELSEIF NOUGAT}
  mapped.getBytes(result) range(Range);
  {$ENDIF}
end;

method Binary.Read(aLength: Integer): array of Byte;
begin
  exit &Read(Range.MakeRange(0, Math.Min(aLength, self.Length)));
end;

method Binary.Subdata(Range: Range): Binary;
begin
  exit new Binary(&Read(Range));
end;

method Binary.Write(aData: array of Byte; aLength: Integer);
begin
  if aData = nil then
    raise new SugarArgumentNullException("Data");

  if aLength = 0 then
    exit;

  if aLength > RemObjects.Oxygene.System.length(aData) then
    raise new SugarArgumentOutOfRangeException("Length {0} exceeds data length {1}", aLength, RemObjects.Oxygene.System.length(aData));

  {$IF COOPER}
  fData.write(aData, 0, aLength);
  {$ELSEIF ECHOES}
  fData.Write(aData, 0, aLength);
  {$ELSEIF NOUGAT}
  mapped.appendBytes(aData) length(aLength);
  {$ENDIF}  
end;

method Binary.Write(aData: Binary);
begin
  SugarArgumentNullException.RaiseIfNil(aData, "Data");
  {$IF COOPER OR ECHOES}
  &Write(aData.ToArray, aData.Length);
  {$ELSEIF NOUGAT}
  mapped.appendData(aData);
  {$ENDIF}  
end;

method Binary.ToArray: array of Byte;
begin
  {$IF COOPER}
  exit fData.toByteArray;
  {$ELSEIF ECHOES}
  exit fData.ToArray;
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
  fData.SetLength(0);
  {$ELSEIF NOUGAT}
  mapped.setLength(0);
  {$ENDIF}  
end;

end.

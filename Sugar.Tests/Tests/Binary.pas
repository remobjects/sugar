namespace Sugar.Test;

interface

{$HIDE W0} //supress case-mismatch errors

uses
  RemObjects.Oxygene.Sugar,
  RemObjects.Oxygene.Sugar.TestFramework;

type
  BinaryTest = public class (Testcase)
  private
    Data: Binary;
    DataBytes: array of Byte := [72, 101, 108, 108, 111];
    method AreEquals(Expected, Actual: array of Byte);
  public
    method Setup; override;
    method TestAssign;
    method TestClear;
    method TestReadRangeOfBytes;
    method TestReadBytes;
    method TestSubdata;
    method TestWriteBytes;
    method TestWriteData;
    method TestToByteArray;
    method TestLength;
    method TestFromArray;
  end;

implementation

method BinaryTest.Setup;
begin
  Data := Binary.FromArray(DataBytes);
end;

method BinaryTest.AreEquals(Expected: array of Byte; Actual: array of Byte);
begin
  Assert.CheckInt(length(Expected), length(Actual));
  for i: Int32 := 0 to length(Expected) - 1 do
    Assert.CheckInt(Expected[i], Actual[i]);
end;

method BinaryTest.TestAssign;
begin
  var Value := new Binary;
  Value.Assign(Data);
  Assert.CheckInt(Data.Length, Value.Length);
  Value.Assign(nil);
  Assert.CheckInt(0, Value.Length);
end;

method BinaryTest.TestClear;
begin
  Data.Clear;
  Assert.CheckInt(0, Data.Length);
end;

method BinaryTest.TestReadRangeOfBytes;
begin
  var Expected: array of Byte := [101, 108, 108];
  AreEquals(Expected, Data.ReadRangeOfBytes(Range.MakeRange(1, 3)));
  AreEquals(DataBytes, Data.ReadRangeOfBytes(Range.MakeRange(0, 5)));

  AreEquals([], Data.ReadRangeOfBytes(Range.MakeRange(5555, 0))); //empty

  //out of range
  Assert.IsException(->Data.ReadRangeOfBytes(Range.MakeRange(32, 1))); 
  Assert.IsException(->Data.ReadRangeOfBytes(Range.MakeRange(0, 32)));
end;

method BinaryTest.TestReadBytes;
begin
  var Expected: array of Byte := [72, 101, 108];
  AreEquals(Expected, Data.ReadBytes(3));
  AreEquals([], Data.ReadBytes(0));
  AreEquals(DataBytes, Data.ReadBytes(88888)); //number of bytes copied is the Min(length, Data.Length)
end;

method BinaryTest.TestSubdata;
begin
  var Expected: array of Byte := [101, 108, 108];
  var Value := Data.Subdata(Range.MakeRange(1, 3));
  Assert.IsNotNull(Value);
  Assert.CheckInt(3, Value.Length);
  AreEquals(Expected, Value.ToArray);
  AreEquals(DataBytes, Data.Subdata(Range.MakeRange(0, Data.Length)).ToArray);

  AreEquals([], Data.Subdata(Range.MakeRange(0,0)).ToArray);
  Assert.IsException(->Data.Subdata(Range.MakeRange(0, 50)));
end;

method BinaryTest.TestWriteBytes;
begin
  Data.WriteBytes([], 0); //empty write
  Assert.CheckInt(5, Data.Length);

  var BytesToWrite: array of Byte := [1, 2, 3];
  Data.WriteBytes(BytesToWrite, 3);
  Assert.CheckInt(8, Data.Length);
  {$WARNING Disable due to compiler bug #63959}
  //AreEquals(BytesToWrite, Data.ReadRangeOfBytes(Range.MakeRange(5, 3)));

  Assert.IsException(->Data.WriteBytes(nil, 0)); //null
  Assert.IsException(->Data.WriteBytes(BytesToWrite, 4)); //out of range
end;

method BinaryTest.TestWriteData;
begin  
  var Expected: Binary := Binary.FromArray([1,2,3]);
  Data.WriteData(Expected);
  Assert.CheckInt(8, Data.Length);
  {$WARNING Disable due to compiler bug #63959}
  //AreEquals(Expected.ToArray, Data.ReadRangeOfBytes(Range.MakeRange(5, 3)));

  Assert.IsException(->Data.WriteData(nil));
  Data.WriteData(Binary.FromArray([]));
  Assert.CheckInt(8, Data.Length);
end;

method BinaryTest.TestToByteArray;
begin
  AreEquals(DataBytes, Data.ToArray);
  AreEquals([], Binary.FromArray([]).ToArray);
end;

method BinaryTest.TestLength;
begin
  Assert.CheckInt(5, Data.Length);
  Assert.CheckInt(0, Binary.FromArray([]).Length);
end;

method BinaryTest.TestFromArray;
begin
  var Value := Binary.FromArray(DataBytes);
  Assert.IsNotNull(Value);
  Assert.CheckInt(5, Value.Length);
  AreEquals(DataBytes, Value.ToArray);

  Assert.IsException(->Binary.FromArray(nil));
  Assert.CheckInt(0, Binary.FromArray([]).Length);
end;

end.

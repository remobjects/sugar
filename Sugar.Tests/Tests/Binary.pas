namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.TestFramework;

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
    method TestFromBinary;
    method &Empty;
  end;

implementation

method BinaryTest.Setup;
begin
  Data := new Binary(DataBytes);
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
  AreEquals(Expected, Data.Read(Range.MakeRange(1, 3)));
  AreEquals(DataBytes, Data.Read(Range.MakeRange(0, 5)));

  AreEquals([], Data.Read(Range.MakeRange(5555, 0))); //empty

  //out of range
  Assert.IsException(->Data.Read(Range.MakeRange(32, 1))); 
  Assert.IsException(->Data.Read(Range.MakeRange(0, 32)));
end;

method BinaryTest.TestReadBytes;
begin
  var Expected: array of Byte := [72, 101, 108];
  AreEquals(Expected, Data.Read(3));
  AreEquals([], Data.Read(0));
  AreEquals(DataBytes, Data.Read(88888)); //number of bytes copied is the Min(length, Data.Length)
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
  Data.Write([], 0); //empty write
  Assert.CheckInt(5, Data.Length);

  var BytesToWrite: array of Byte := [1, 2, 3];
  Data.Write(BytesToWrite, 3);
  Assert.CheckInt(8, Data.Length);
  AreEquals(BytesToWrite, Data.Read(Range.MakeRange(5, 3)));

  Assert.IsException(->Data.Write(nil, 0)); //null
  Assert.IsException(->Data.Write(BytesToWrite, 4)); //out of range
end;

method BinaryTest.TestWriteData;
begin  
  var Expected: Binary := new Binary([1,2,3]);
  Data.Write(Expected);
  Assert.CheckInt(8, Data.Length);
  AreEquals(Expected.ToArray, Data.Read(Range.MakeRange(5, 3)));

  Expected := nil;
  Assert.IsException(->Data.Write(Expected));
  Data.Write(new Binary([]));
  Assert.CheckInt(8, Data.Length);
end;

method BinaryTest.TestToByteArray;
begin
  AreEquals(DataBytes, Data.ToArray);
  AreEquals([], new Binary([]).ToArray);
end;

method BinaryTest.TestLength;
begin
  Assert.CheckInt(5, Data.Length);
  Assert.CheckInt(0, new Binary([]).Length);
end;

method BinaryTest.TestFromArray;
begin
  var Value := new Binary(DataBytes);
  Assert.IsNotNull(Value);
  Assert.CheckInt(5, Value.Length);
  AreEquals(DataBytes, Value.ToArray);

  //Assert.IsException(->new Binary(nil));
  Assert.CheckInt(0, new Binary([]).Length);
end;

method BinaryTest.TestFromBinary;
begin
  var Value := new Binary(Data);
  Assert.IsNotNull(Value);
  Assert.CheckInt(5, Value.Length);
  AreEquals(DataBytes, Value.ToArray);
end;

method BinaryTest.&Empty;
begin
  var Value := new Binary;
  Assert.IsNotNull(Value);
  Assert.CheckInt(0, Value.Length);  
end;

end.

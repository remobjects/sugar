namespace Sugar.Test;

interface

uses
  Sugar,
  RemObjects.Elements.EUnit;

type
  BinaryTest = public class (Test)
  private
    Data: Binary;
    DataBytes: array of Byte := [72, 101, 108, 108, 111];
    //method AreEquals(Expected, Actual: array of Byte);
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

{method BinaryTest.AreEquals(Expected: array of Byte; Actual: array of Byte);
begin
  Assert.CheckInt(length(Expected), length(Actual));
  for i: Int32 := 0 to length(Expected) - 1 do
    Assert.CheckInt(Expected[i], Actual[i]);
end;}

method BinaryTest.TestAssign;
begin
  var Value := new Binary;
  Value.Assign(Data);
  Assert.AreEqual(Value.Length, Data.Length);
  Value.Assign(nil);
  Assert.AreEqual(Value.Length, 0);
end;

method BinaryTest.TestClear;
begin
  Data.Clear;
  Assert.AreEqual(Data.Length, 0);
end;

method BinaryTest.TestReadRangeOfBytes;
begin
  var Expected: array of Byte := [101, 108, 108];
  Assert.AreEqual(Data.Read(Range.MakeRange(1, 3)), Expected);
  Assert.AreEqual(Data.Read(Range.MakeRange(0, 5)), DataBytes);

  Assert.AreEqual(Data.Read(Range.MakeRange(5555, 0)), []); //empty

  //out of range
  Assert.Throws(->Data.Read(Range.MakeRange(32, 1))); 
  Assert.Throws(->Data.Read(Range.MakeRange(0, 32)));
end;

method BinaryTest.TestReadBytes;
begin
  var Expected: array of Byte := [72, 101, 108];
  Assert.AreEqual(Data.Read(3), Expected);
  Assert.AreEqual(Data.Read(0), []);
  Assert.AreEqual(Data.Read(88888), DataBytes); //number of bytes copied is the Min(length, Data.Length)
end;

method BinaryTest.TestSubdata;
begin
  var Expected: array of Byte := [101, 108, 108];
  var Value := Data.Subdata(Range.MakeRange(1, 3));
  Assert.IsNotNil(Value);
  Assert.AreEqual(Value.Length, 3);
  Assert.AreEqual(Value.ToArray, Expected);
  Assert.AreEqual(Data.Subdata(Range.MakeRange(0, Data.Length)).ToArray, DataBytes);

  Assert.AreEqual(Data.Subdata(Range.MakeRange(0,0)).ToArray, []);
  Assert.Throws(->Data.Subdata(Range.MakeRange(0, 50)));
end;

method BinaryTest.TestWriteBytes;
begin
  Data.Write([], 0); //empty write
  Assert.AreEqual(Data.Length, 5);

  var BytesToWrite: array of Byte := [1, 2, 3];
  Data.Write(BytesToWrite, 3);
  Assert.AreEqual(Data.Length, 8);
  Assert.AreEqual(Data.Read(Range.MakeRange(5, 3)), BytesToWrite);

  Assert.Throws(->Data.Write(nil, 0)); //null
  Assert.Throws(->Data.Write(BytesToWrite, 4)); //out of range
end;

method BinaryTest.TestWriteData;
begin  
  var Expected: Binary := new Binary([1,2,3]);
  Data.Write(Expected);
  Assert.AreEqual(Data.Length, 8);
  Assert.AreEqual(Data.Read(Range.MakeRange(5, 3)), Expected.ToArray);

  Expected := nil;
  Assert.Throws(->Data.Write(Expected));
  Data.Write(new Binary([]));
  Assert.AreEqual(Data.Length, 8);
end;

method BinaryTest.TestToByteArray;
begin
  Assert.AreEqual(Data.ToArray, DataBytes);
  Assert.AreEqual(new Binary([]).ToArray, []);
end;

method BinaryTest.TestLength;
begin
  Assert.AreEqual(Data.Length, 5);
  Data.Clear;
  Assert.AreEqual(Data.Length, 0);
  Assert.AreEqual(new Binary([]).Length, 0);
end;

method BinaryTest.TestFromArray;
begin
  var Value := new Binary(DataBytes);
  Assert.IsNotNil(Value);
  Assert.AreEqual(Value.Length, 5);
  Assert.AreEqual(Value.ToArray, DataBytes);

  //Assert.Throws(->new Binary(nil));
  Assert.AreEqual(new Binary([]).Length, 0);
end;

method BinaryTest.TestFromBinary;
begin
  var Value := new Binary(Data);
  Assert.IsNotNil(Value);
  Assert.AreEqual(Value.Length, 5);
  Assert.AreEqual(Value.ToArray, DataBytes);
end;

method BinaryTest.&Empty;
begin
  var Value := new Binary;
  Assert.IsNotNil(Value);
  Assert.AreEqual(Value.Length, 0);
end;

end.

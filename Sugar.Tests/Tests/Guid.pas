namespace Sugar.Test;

interface

uses
  Sugar,
  RemObjects.Elements.EUnit;

type
  GuidTest = public class (Test)
  private
    Data: Guid;
    GuidString: String := "{5EB4BEC4-5509-4434-9D33-2A9C74CC54EE}";
    method AreEqual(Expected, Actual: Guid);
    method AreNotEqual(Expected, Actual: Guid);
  public
    method Setup; override;
    method CompareTo;
    method TestEquals;
    method NewGuid;
    method Parse;
    method ParseExceptions;
    method EmptyGuid;
    method ToByteArray;
    method TestToString;
    method ToStringFormat;
    method Constructors;
  end;

implementation

method GuidTest.Setup;
begin
  Data := Guid.Parse(GuidString);
end;

method GuidTest.AreEqual(Expected: Guid; Actual: Guid);
begin
  Assert.IsTrue(Expected.Equals(Actual));
end;

method GuidTest.AreNotEqual(Expected: Guid; Actual: Guid);
begin
  Assert.IsFalse(Expected.Equals(Actual));
end;

method GuidTest.CompareTo;
begin
  Assert.AreEqual(Data.CompareTo(Data), 0);
  var Value := Guid.Parse(GuidString);
  Assert.AreEqual(Data.CompareTo(Value), 0);
  Assert.IsTrue(Data.CompareTo(Guid.EmptyGuid) <> 0);
  Value := Guid.Parse("{5EB4BEC4-5509-4434-9D44-2A9C74CC54EE}");
  Assert.IsTrue(Data.CompareTo(Value) <> 0);
  Assert.AreEqual(Guid.EmptyGuid.CompareTo(Guid.EmptyGuid), 0);
end;

method GuidTest.TestEquals;
begin
  Assert.IsTrue(Data.Equals(Data));
  var Value := Guid.Parse(GuidString);
  Assert.IsTrue(Data.Equals(Value));
  Assert.IsFalse(Data.Equals(Guid.EmptyGuid));
  Value := Guid.Parse("{5EB4BEC4-5509-4434-9D44-2A9C74CC54EE}");
  Assert.IsFalse(Data.Equals(Value));
  Assert.IsTrue(Guid.EmptyGuid.Equals(Guid.EmptyGuid));
end;

method GuidTest.NewGuid;
begin
  var Value := Guid.NewGuid;
  Assert.IsFalse(Value.Equals(Guid.EmptyGuid));
end;

method GuidTest.Parse;
begin
  AreEqual(Guid.EmptyGuid, Guid.Parse("00000000-0000-0000-0000-000000000000"));
  AreEqual(Guid.EmptyGuid, Guid.Parse("{00000000-0000-0000-0000-000000000000}"));
  AreEqual(Guid.EmptyGuid, Guid.Parse("(00000000-0000-0000-0000-000000000000)"));  

  AreEqual(Data, Guid.Parse(GuidString));
  AreNotEqual(Guid.EmptyGuid, Guid.Parse(GuidString));
  AreEqual(Data, Guid.Parse("5EB4BEC4-5509-4434-9D33-2A9C74CC54EE"));
  AreEqual(Data, Guid.Parse("(5EB4BEC4-5509-4434-9D33-2A9C74CC54EE)"));
end;

method GuidTest.ParseExceptions;
begin
  Assert.Throws(->Guid.Parse(""));
  Assert.Throws(->Guid.Parse(nil));
  Assert.Throws(->Guid.Parse("String"));
  Assert.Throws(->Guid.Parse("{5EB4BEC4-5509-4434-9D44-2A9C74CC54EE"));
  Assert.Throws(->Guid.Parse("5EB4BEC4-5509-4434-9D44-2A9C74CC54EE}"));
  Assert.Throws(->Guid.Parse("(5EB4BEC4-5509-4434-9D44-2A9C74CC54EE}"));
  Assert.Throws(->Guid.Parse("{5EB4BEC-5509-4434-9D44-2A9C74CC54EE}"));
  Assert.Throws(->Guid.Parse("{5EB4BEC4-55109-4434-9D44-2A9C74CC54EE}"));
  Assert.Throws(->Guid.Parse("{5EB4BEC4-5509-44314-9D44-2A9C74CC54EE}"));
  Assert.Throws(->Guid.Parse("{5EB4BEC4-5509-4434-9D414-2A9C74CC54EE}"));
  Assert.Throws(->Guid.Parse("{5EB4BEC4-5509-4434-9D44-2A9C744CC54EE}"));
  Assert.Throws(->Guid.Parse("{5EB4BEC4-5509-4434-9D44-2A9C4CC54EE}"));
  Assert.Throws(->Guid.Parse("{5EB4BECJ-5509-4434-9D44-2A9C74CC54EE}"));
  Assert.Throws(->Guid.Parse("{5EB4BEC4 5509 4434 9D44 2A9C74CC54EE}"));
  Assert.Throws(->Guid.Parse("{5EB4BEC4550944349D442A9C74CC54EE}"));  
  Assert.Throws(->Guid.Parse("00000000000000000000000000000000"));
  Assert.Throws(->Guid.Parse("0"));
end;

method GuidTest.EmptyGuid;
begin
  AreEqual(Guid.Parse("{00000000-0000-0000-0000-000000000000}"), Guid.EmptyGuid);
  var Value := Guid.EmptyGuid.ToByteArray;
  for i: Int32 := 0 to length(Value)-1 do 
    Assert.AreEqual(Value[i], 0);
end;

method GuidTest.ToByteArray;
begin
  var Expected: array of Byte := [94, 180, 190, 196, 85, 9, 68, 52, 157, 51, 42, 156, 116, 204, 84, 238];
  var Actual := Data.ToByteArray;
  Assert.AreEqual(length(Actual), 16);
  for i: Int32 := 0 to length(Expected)-1 do 
    Assert.AreEqual(Actual[i], Expected[i]);

  Actual := Guid.EmptyGuid.ToByteArray;
  Assert.AreEqual(length(Actual), 16);
  for i: Int32 := 0 to length(Expected)-1 do 
    Assert.AreEqual(Actual[i], 0);
end;

method GuidTest.TestToString;
begin
  //ToString should return string in "default" format
  Assert.AreEqual(Data.ToString, "5EB4BEC4-5509-4434-9D33-2A9C74CC54EE");
  Assert.AreEqual(Data.ToString, Data.ToString(GuidFormat.Default));
end;

method GuidTest.ToStringFormat;
begin
  Assert.AreEqual(Data.ToString(GuidFormat.Braces), GuidString);
  Assert.AreEqual(Data.ToString(GuidFormat.Parentheses), "(5EB4BEC4-5509-4434-9D33-2A9C74CC54EE)");
  Assert.AreEqual(Data.ToString(GuidFormat.Default), "5EB4BEC4-5509-4434-9D33-2A9C74CC54EE");
end;

method GuidTest.Constructors;
begin
  var Value := new Guid().ToByteArray;
  for i: Int32 := 0 to length(Value)-1 do 
    Assert.AreEqual(Value[i], 0);

  var Expected: array of Byte := [94, 180, 190, 196, 85, 9, 68, 52, 157, 51, 42, 156, 116, 204, 84, 238];
  var Actual := new Guid(Expected);
  Assert.IsNotNil(Actual);
  Assert.IsTrue(Data.Equals(Actual));
end;

end.

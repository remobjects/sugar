namespace Sugar.Test;

interface

uses
  Sugar,
  RemObjects.Elements.EUnit;

type
  UserSettingsTest = public class (Test)
  var
    Data: UserSettings := UserSettings.Default;
  public
    method TearDown; override;

    method ReadString;
    method ReadInteger;
    method ReadBoolean;
    method ReadDouble;
    method WriteString;
    method WriteInteger;
    method WriteBoolean;
    method WriteDouble;
    method Clear;
    method &Remove;
    method Keys;
    method &Default;
  end;
  
implementation

method UserSettingsTest.TearDown;
begin  
  Data.Clear;
  Data.Save;
end;

method UserSettingsTest.ReadString;
begin  
  Data.Write("String", "One");
  var Actual := Data.Read("String", nil);
  Assert.IsNotNil(Actual);
  Assert.AreEqual(Actual, "One");
  Assert.AreEqual(Data.Read("StringX", "Default"), "Default");
  Data.Clear;
  Assert.AreEqual(Data.Read("String", "Default"), "Default");
  Assert.Throws(->Data.Read(nil, "Default"));
end;

method UserSettingsTest.ReadInteger;
begin
  Data.Write("Integer", 42);
  var Actual := Data.Read("Integer", -1);  
  Assert.AreEqual(Actual, 42);
  Assert.AreEqual(Data.Read("IntegerX", -1), -1);
  Data.Clear;
  Assert.AreEqual(Data.Read("Integer", -1), -1);
  Assert.Throws(->Data.Read(nil, 1));
end;

method UserSettingsTest.ReadBoolean;
begin
  Data.Write("Boolean", true);
  Assert.IsTrue(Data.Read("Boolean", false));
  Assert.IsTrue(Data.Read("BooleanX", true));
  Data.Clear;
  Assert.IsFalse(Data.Read("Boolean", false));
  Assert.Throws(->Data.Read(nil, true));
end;

method UserSettingsTest.ReadDouble;
begin
  Data.Write("Double", 4.2);
  var Actual := Data.Read("Double", -1.0);  
  Assert.AreEqual(Actual, 4.2);
  Assert.AreEqual(Data.Read("DoubleX", -1), -1);
  Data.Clear;
  Assert.AreEqual(Data.Read("Double", -1), -1);
  Assert.Throws(->Data.Read(nil, 1.1));
end;

method UserSettingsTest.WriteString;
begin
  Assert.AreEqual(length(Data.Keys), 0);
  Data.Write("String", "One");
  Assert.AreEqual(length(Data.Keys), 1);
  Assert.AreEqual(Data.Read("String", nil), "One");
  
  Data.Write("String", "Two"); //override
  Assert.AreEqual(length(Data.Keys), 1);
  Assert.AreEqual(Data.Read("String", nil), "Two");

  Assert.Throws(->Data.Write(nil, "One"));
end;

method UserSettingsTest.WriteInteger;
begin
  Assert.AreEqual(length(Data.Keys), 0);
  Data.Write("Integer", 42);
  Assert.AreEqual(length(Data.Keys), 1);
  Assert.AreEqual(Data.Read("Integer", -1), 42);
  
  Data.Write("Integer", 5);
  Assert.AreEqual(length(Data.Keys), 1);
  Assert.AreEqual(Data.Read("Integer", -1), 5);

  Assert.Throws(->Data.Write(nil, 1));
end;

method UserSettingsTest.WriteBoolean;
begin
  Assert.AreEqual(length(Data.Keys), 0);
  Data.Write("Boolean", true);
  Assert.AreEqual(length(Data.Keys), 1);
  Assert.IsTrue(Data.Read("Boolean", false));
  
  Data.Write("Boolean", false);
  Assert.AreEqual(length(Data.Keys), 1);
  Assert.IsFalse(Data.Read("Boolean", true));

  Assert.Throws(->Data.Write(nil, true)); 
end;

method UserSettingsTest.WriteDouble;
begin
  Assert.AreEqual(length(Data.Keys), 0);
  Data.Write("Double", 4.2);
  Assert.AreEqual(length(Data.Keys), 1);
  Assert.AreEqual(Data.Read("Double", -1.0), 4.2);
  
  Data.Write("Double", 5.5);
  Assert.AreEqual(length(Data.Keys), 1);
  Assert.AreEqual(Data.Read("Double", -1.0), 5.5);

  Assert.Throws(->Data.Write(nil, 1.0));
end;

method UserSettingsTest.Clear;
begin
  Assert.AreEqual(length(Data.Keys), 0);
  Data.Write("Boolean", true);
  Assert.AreEqual(length(Data.Keys), 1);
  Data.Clear;
  Assert.AreEqual(length(Data.Keys), 0);
end;

method UserSettingsTest.&Remove;
begin
  Assert.AreEqual(length(Data.Keys), 0);
  Data.Write("String", "One");
  Assert.AreEqual(length(Data.Keys), 1);
  Data.Remove("String");
  Assert.AreEqual(length(Data.Keys), 0);
  Data.Remove("A");
  Assert.Throws(->Data.Remove(nil));
end;

method UserSettingsTest.Keys;
begin
  var Expected := new Sugar.Collections.List<String>;
  Expected.Add("String");
  Expected.Add("Integer");
  Expected.Add("Double");

  Data.Write("String", "");
  Data.Write("Integer", 0);
  Data.Write("Double", 2.2);

  var Actual := Data.Keys;
  Assert.AreEqual(length(Actual), 3);

  for i: Integer := 0 to length(Actual) - 1 do
    Assert.IsTrue(Expected.Contains(Actual[i]));
end;

method UserSettingsTest.&Default;
begin
  Assert.IsNotNil(UserSettings.Default);
  Assert.AreEqual(length(UserSettings.Default.Keys), 0);
  Assert.AreEqual(length(Data.Keys), 0);
  UserSettings.Default.Write("Boolean", true);
  Assert.AreEqual(length(UserSettings.Default.Keys), 1);
  Assert.AreEqual(length(Data.Keys), 1);
end;

end.
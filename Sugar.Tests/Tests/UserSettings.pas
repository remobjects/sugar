namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.TestFramework;

type
  UserSettingsTest = public class (Testcase)
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
  Assert.IsNotNull(Actual);
  Assert.CheckString("One", Actual);
  Assert.CheckString("Default", Data.Read("StringX", "Default"));
  Data.Clear;
  Assert.CheckString("Default", Data.Read("String", "Default"));  
  Assert.IsException(->Data.Read(nil, "Default"));
end;

method UserSettingsTest.ReadInteger;
begin
  Data.Write("Integer", 42);
  var Actual := Data.Read("Integer", -1);  
  Assert.CheckInt(42, Actual);
  Assert.CheckInt(-1, Data.Read("IntegerX", -1));
  Data.Clear;
  Assert.CheckInt(-1, Data.Read("Integer", -1));
  Assert.IsException(->Data.Read(nil, 1));
end;

method UserSettingsTest.ReadBoolean;
begin
  Data.Write("Boolean", true);
  Assert.CheckBool(true, Data.Read("Boolean", false));
  Assert.CheckBool(true, Data.Read("BooleanX", true));
  Data.Clear;
  Assert.CheckBool(false, Data.Read("Boolean", false));
  Assert.IsException(->Data.Read(nil, true));
end;

method UserSettingsTest.ReadDouble;
begin
  Data.Write("Double", 4.2);
  var Actual := Data.Read("Double", -1.0);  
  Assert.CheckDouble(4.2, Actual);
  Assert.CheckDouble(-1, Data.Read("DoubleX", -1));
  Data.Clear;
  Assert.CheckDouble(-1, Data.Read("Double", -1));
  Assert.IsException(->Data.Read(nil, 1.1));
end;

method UserSettingsTest.WriteString;
begin
  Assert.CheckInt(0, length(Data.Keys));
  Data.Write("String", "One");
  Assert.CheckInt(1, length(Data.Keys));
  Assert.CheckString("One", Data.Read("String", nil));
  
  Data.Write("String", "Two"); //override
  Assert.CheckInt(1, length(Data.Keys));
  Assert.CheckString("Two", Data.Read("String", nil));

  Assert.IsException(->Data.Write(nil, "One"));
end;

method UserSettingsTest.WriteInteger;
begin
  Assert.CheckInt(0, length(Data.Keys));
  Data.Write("Integer", 42);
  Assert.CheckInt(1, length(Data.Keys));
  Assert.CheckInt(42, Data.Read("Integer", -1));
  
  Data.Write("Integer", 5);
  Assert.CheckInt(1, length(Data.Keys));
  Assert.CheckInt(5, Data.Read("Integer", -1));

  Assert.IsException(->Data.Write(nil, 1));
end;

method UserSettingsTest.WriteBoolean;
begin
  Assert.CheckInt(0, length(Data.Keys));
  Data.Write("Boolean", true);
  Assert.CheckInt(1, length(Data.Keys));
  Assert.CheckBool(true, Data.Read("Boolean", false));
  
  Data.Write("Boolean", false);
  Assert.CheckInt(1, length(Data.Keys));
  Assert.CheckBool(false, Data.Read("Boolean", true));

  Assert.IsException(->Data.Write(nil, true)); 
end;

method UserSettingsTest.WriteDouble;
begin
  Assert.CheckInt(0, length(Data.Keys));
  Data.Write("Double", 4.2);
  Assert.CheckInt(1, length(Data.Keys));
  Assert.CheckDouble(4.2, Data.Read("Double", -1.0));
  
  Data.Write("Double", 5.5);
  Assert.CheckInt(1, length(Data.Keys));
  Assert.CheckDouble(5.5, Data.Read("Double", -1.0));

  Assert.IsException(->Data.Write(nil, 1.0));
end;

method UserSettingsTest.Clear;
begin
  Assert.CheckInt(0, length(Data.Keys));
  Data.Write("Boolean", true);
  Assert.CheckInt(1, length(Data.Keys));
  Data.Clear;
  Assert.CheckInt(0, length(Data.Keys));
end;

method UserSettingsTest.&Remove;
begin
  Assert.CheckInt(0, length(Data.Keys));
  Data.Write("String", "One");
  Assert.CheckInt(1, length(Data.Keys));
  Data.Remove("String");
  Assert.CheckInt(0, length(Data.Keys));
  Data.Remove("A");
  Assert.IsException(->Data.Remove(nil));
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
  Assert.CheckInt(3, length(Actual));

  for i: Integer := 0 to length(Actual) - 1 do
    Assert.CheckBool(true, Expected.Contains(Actual[i]));
end;

method UserSettingsTest.&Default;
begin
  Assert.IsNotNull(UserSettings.Default);
  Assert.CheckInt(0, length(UserSettings.Default.Keys));
  Assert.CheckInt(0, length(Data.Keys));
  UserSettings.Default.Write("Boolean", true);
  Assert.CheckInt(1, length(UserSettings.Default.Keys));
  Assert.CheckInt(1, length(Data.Keys));
end;

end.
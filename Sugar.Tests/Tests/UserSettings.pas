namespace Sugar.Test;

interface

{$HIDE W0} //supress case-mismatch errors

uses
  RemObjects.Oxygene.Sugar,
  RemObjects.Oxygene.Sugar.TestFramework;

type
  UserSettingsTest = public class (Testcase)
  var
    Data: UserSettings := UserSettings.Default{$IF ANDROID}(sugar.cooper.android.test.MainActivity.CurrentContext){$ENDIF};
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
  Data.WriteString("String", "One");
  var Actual := Data.ReadString("String", nil);
  Assert.IsNotNull(Actual);
  Assert.CheckString("One", Actual);
  Assert.CheckString("Default", Data.ReadString("StringX", "Default"));
  Data.Clear;
  Assert.CheckString("Default", Data.ReadString("String", "Default"));  
  Assert.IsException(->Data.ReadString(nil, "Default"));
end;

method UserSettingsTest.ReadInteger;
begin
  Data.WriteInteger("Integer", 42);
  var Actual := Data.ReadInteger("Integer", -1);  
  Assert.CheckInt(42, Actual);
  Assert.CheckInt(-1, Data.ReadInteger("IntegerX", -1));
  Data.Clear;
  Assert.CheckInt(-1, Data.ReadInteger("Integer", -1));
  Assert.IsException(->Data.ReadInteger(nil, 1));
end;

method UserSettingsTest.ReadBoolean;
begin
  Data.WriteBoolean("Boolean", true);
  Assert.CheckBool(true, Data.ReadBoolean("Boolean", false));
  Assert.CheckBool(true, Data.ReadBoolean("BooleanX", true));
  Data.Clear;
  Assert.CheckBool(false, Data.ReadBoolean("Boolean", false));
  Assert.IsException(->Data.ReadBoolean(nil, true));
end;

method UserSettingsTest.ReadDouble;
begin
  Data.WriteDouble("Double", 4.2);
  var Actual := Data.ReadDouble("Double", -1);  
  Assert.CheckDouble(4.2, Actual);
  Assert.CheckDouble(-1, Data.ReadDouble("DoubleX", -1));
  Data.Clear;
  Assert.CheckDouble(-1, Data.ReadDouble("Double", -1));
  Assert.IsException(->Data.ReadDouble(nil, 1.1));
end;

method UserSettingsTest.WriteString;
begin
  Assert.CheckInt(0, length(Data.Keys));
  Data.WriteString("String", "One");
  Assert.CheckInt(1, length(Data.Keys));
  Assert.CheckString("One", Data.ReadString("String", nil));
  
  Data.WriteString("String", "Two"); //override
  Assert.CheckInt(1, length(Data.Keys));
  Assert.CheckString("Two", Data.ReadString("String", nil));

  Assert.IsException(->Data.WriteString(nil, "One"));
end;

method UserSettingsTest.WriteInteger;
begin
  Assert.CheckInt(0, length(Data.Keys));
  Data.WriteInteger("Integer", 42);
  Assert.CheckInt(1, length(Data.Keys));
  Assert.CheckInt(42, Data.ReadInteger("Integer", -1));
  
  Data.WriteInteger("Integer", 5);
  Assert.CheckInt(1, length(Data.Keys));
  Assert.CheckInt(5, Data.ReadInteger("Integer", -1));

  Assert.IsException(->Data.WriteInteger(nil, 1));
end;

method UserSettingsTest.WriteBoolean;
begin
  Assert.CheckInt(0, length(Data.Keys));
  Data.WriteBoolean("Boolean", true);
  Assert.CheckInt(1, length(Data.Keys));
  Assert.CheckBool(true, Data.ReadBoolean("Boolean", false));
  
  Data.WriteBoolean("Boolean", false);
  Assert.CheckInt(1, length(Data.Keys));
  Assert.CheckBool(false, Data.ReadBoolean("Boolean", true));

  Assert.IsException(->Data.WriteBoolean(nil, true)); 
end;

method UserSettingsTest.WriteDouble;
begin
  Assert.CheckInt(0, length(Data.Keys));
  Data.WriteDouble("Double", 4.2);
  Assert.CheckInt(1, length(Data.Keys));
  Assert.CheckDouble(4.2, Data.ReadDouble("Double", -1));
  
  Data.WriteDouble("Double", 5.5);
  Assert.CheckInt(1, length(Data.Keys));
  Assert.CheckDouble(5.5, Data.ReadDouble("Double", -1));

  Assert.IsException(->Data.WriteDouble(nil, 1));
end;

method UserSettingsTest.Clear;
begin
  Assert.CheckInt(0, length(Data.Keys));
  Data.WriteBoolean("Boolean", true);
  Assert.CheckInt(1, length(Data.Keys));
  Data.Clear;
  Assert.CheckInt(0, length(Data.Keys));
end;

method UserSettingsTest.&Remove;
begin
  Assert.CheckInt(0, length(Data.Keys));
  Data.WriteString("String", "One");
  Assert.CheckInt(1, length(Data.Keys));
  Data.Remove("String");
  Assert.CheckInt(0, length(Data.Keys));
  Data.Remove("A");
  Assert.IsException(->Data.Remove(nil));
end;

method UserSettingsTest.Keys;
begin
  var Expected := new RemObjects.Oxygene.Sugar.Collections.List<String>;
  Expected.Add("String");
  Expected.Add("Integer");
  Expected.Add("Double");

  Data.WriteString("String", "");
  Data.WriteInteger("Integer", 0);
  Data.WriteDouble("Double", 2.2);

  var Actual := Data.Keys;
  Assert.CheckInt(3, length(Actual));

  for i: Integer := 0 to length(Actual) - 1 do
    Assert.CheckBool(true, Expected.Contains(Actual[i]));
end;

method UserSettingsTest.&Default;
begin
  var Def := UserSettings.Default{$IF ANDROID}(sugar.cooper.android.test.MainActivity.CurrentContext){$ENDIF};
  Assert.IsNotNull(Def);
  Assert.CheckInt(0, length(Def.Keys));
  Assert.CheckInt(0, length(Data.Keys));
  Def.WriteBoolean("Boolean", true);
  Assert.CheckInt(1, length(Def.Keys));
  Assert.CheckInt(1, length(Data.Keys));
end;

end.
namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.Collections,
  Sugar.TestFramework;

type
  DictionaryTest = public class (Testcase)
  private
    Data: Dictionary<CodeClass, String>;
  public
    method Setup; override;
    method &Add;
    method Clear;
    method ContainsKey;
    method ContainsValue;
    method &Remove;
    method Item;
    method Keys;
    method Values;
    method Count;
    method ForEach;
  end;

implementation

method DictionaryTest.Setup;
begin
  Data := new Dictionary<CodeClass, String>;
  Data.Add(new CodeClass(1), "One");
  Data.Add(new CodeClass(2), "Two");
  Data.Add(new CodeClass(3), "Three");
end;

method DictionaryTest.&Add;
begin
  Assert.CheckInt(3, Data.Count);
  Data.Add(new CodeClass(4), "Four");
  Assert.CheckInt(4, Data.Count);
  Assert.CheckBool(true, Data.ContainsKey(new CodeClass(4)));
  Assert.CheckBool(true, Data.ContainsValue("Four"));
  
  Assert.IsException(->Data.Add(new CodeClass(4), "")); //no duplicates
  Assert.IsException(->Data.Add(new CodeClass(55), nil)); //no nil's
  Assert.IsException(->Data.Add(nil, ""));
end;

method DictionaryTest.Clear;
begin
  Assert.CheckInt(3, Data.Count);
  Data.Clear;
  Assert.CheckInt(0, Data.Count);
end;

method DictionaryTest.ContainsKey;
begin
  Assert.CheckBool(true, Data.ContainsKey(new CodeClass(1)));
  Assert.CheckBool(true, Data.ContainsKey(new CodeClass(2)));
  Assert.CheckBool(true, Data.ContainsKey(new CodeClass(3)));
  Assert.CheckBool(false, Data.ContainsKey(new CodeClass(4)));
  Assert.IsException(->Data.ContainsKey(nil));
end;

method DictionaryTest.ContainsValue;
begin
  Assert.CheckBool(true, Data.ContainsValue("One"));
  Assert.CheckBool(true, Data.ContainsValue("Two"));
  Assert.CheckBool(true, Data.ContainsValue("Three"));
  Assert.CheckBool(false, Data.ContainsValue("Four"));
  Assert.CheckBool(false, Data.ContainsValue("one"));  
  Assert.IsException(->Data.ContainsValue(nil));
end;

method DictionaryTest.&Remove;
begin
  Assert.CheckBool(true, Data.Remove(new CodeClass(1)));
  Assert.CheckBool(false, Data.ContainsKey(new CodeClass(1)));
  Assert.CheckBool(false, Data.ContainsValue("One"));
  Assert.CheckBool(false, Data.Remove(new CodeClass(1)));
  Assert.IsException(->Data.Remove(nil));
end;

method DictionaryTest.Item;
begin  
  var C := new CodeClass(1);
  Assert.IsNotNull(Data.Item[C]);
  Assert.IsNotNull(Data[C]);
  Assert.CheckString("One", Data.Item[C]);
  Assert.CheckString("One", Data[C]);
  Assert.IsException(->Data.Item[new CodeClass(55)]);
  Assert.IsException(->Data.Item[nil]);

  Data[C] := "First";
  Assert.CheckString("First", Data.Item[C]);

  //if key doesn't exists it should be added
  Assert.CheckInt(3, Data.Count);
  Data[new CodeClass(4)] := "Four";
  Assert.CheckInt(4, Data.Count);
  Assert.CheckBool(true, Data.ContainsKey(new CodeClass(4)));
  Assert.CheckBool(true, Data.ContainsValue("Four"));
  Assert.IsException(->begin Data[nil] := ""; end);
  Assert.IsException(->begin Data[C] := nil; end);
end;

method DictionaryTest.Keys;
begin
  var Expected := new Sugar.Collections.List<CodeClass>;
  Expected.Add(new CodeClass(1));
  Expected.Add(new CodeClass(2));
  Expected.Add(new CodeClass(3));
  var Actual := Data.Keys;

  Assert.CheckInt(3, length(Actual));
  //elements order is not defined
  for i: Integer := 0 to length(Actual) - 1 do
    Assert.CheckBool(true, Expected.Contains(Actual[i]));
end;

method DictionaryTest.Values;
begin
  var Expected := new Sugar.Collections.List<String>;
  Expected.Add("One");
  Expected.Add("Two");
  Expected.Add("Three");
  var Actual := Data.Values;

  Assert.CheckInt(3, length(Actual));
  for i: Integer := 0 to length(Actual) - 1 do
    Assert.CheckBool(true, Expected.Contains(Actual[i]));
end;

method DictionaryTest.Count;
begin
  Assert.CheckInt(3, Data.Count);
  Assert.CheckBool(true, Data.Remove(new CodeClass(1)));
  Assert.CheckInt(2, Data.Count);
  Data.Add(new CodeClass(1), "One");
  Assert.CheckInt(3, Data.Count);
  Data.Clear;
  Assert.CheckInt(0, Data.Count);
end;

method DictionaryTest.ForEach;
begin
  var Item1 := new KeyValue<String, String>("Key", "Value");
  var Item2 := new KeyValue<String, String>("Key", "Value");
  Assert.CheckBool(true, Item1.Equals(Item2));

  var Expected := new Sugar.Collections.List<KeyValue<CodeClass, String>>;
  Expected.Add(new KeyValue<CodeClass, String>(new CodeClass(1),"One"));
  Expected.Add(new KeyValue<CodeClass, String>(new CodeClass(2),"Two"));
  Expected.Add(new KeyValue<CodeClass, String>(new CodeClass(3),"Three"));

  var &Index: Integer := 0;

  Data.ForEach(x -> begin
    Assert.CheckBool(true, Expected.Contains(x));
    &Index := &Index + 1;
  end);

  Assert.CheckInt(3, &Index);
end;

end.
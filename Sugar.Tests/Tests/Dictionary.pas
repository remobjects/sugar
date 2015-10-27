namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.Collections,
  RemObjects.Elements.EUnit;

type
  DictionaryTest = public class (Test)
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
    method NilValue;
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
  Assert.AreEqual(Data.Count, 3);
  Data.Add(new CodeClass(4), "Four");
  Assert.AreEqual(Data.Count, 4);
  Assert.IsTrue(Data.ContainsKey(new CodeClass(4)));
  Assert.IsTrue(Data.ContainsValue("Four"));

  Data.Add(new CodeClass(-1), nil);
  Assert.AreEqual(Data.Count, 5);
  Assert.IsTrue(Data.ContainsKey(new CodeClass(-1)));
  Assert.IsTrue(Data.ContainsValue(nil));
  
  Assert.Throws(->Data.Add(new CodeClass(4), "")); //no duplicates
  Assert.Throws(->Data.Add(nil, ""));
end;

method DictionaryTest.Clear;
begin
  Assert.AreEqual(Data.Count, 3);
  Data.Clear;
  Assert.AreEqual(Data.Count, 0);
end;

method DictionaryTest.ContainsKey;
begin
  Assert.IsTrue(Data.ContainsKey(new CodeClass(1)));
  Assert.IsTrue(Data.ContainsKey(new CodeClass(2)));
  Assert.IsTrue(Data.ContainsKey(new CodeClass(3)));
  Assert.IsFalse(Data.ContainsKey(new CodeClass(4)));
  Assert.Throws(->Data.ContainsKey(nil));
end;

method DictionaryTest.ContainsValue;
begin
  Assert.IsTrue(Data.ContainsValue("One"));
  Assert.IsTrue(Data.ContainsValue("Two"));
  Assert.IsTrue(Data.ContainsValue("Three"));
  Assert.IsFalse(Data.ContainsValue("Four"));
  Assert.IsFalse(Data.ContainsValue("one"));
  Assert.IsFalse(Data.ContainsValue(nil));
end;

method DictionaryTest.&Remove;
begin
  Assert.IsTrue(Data.Remove(new CodeClass(1)));
  Assert.IsFalse(Data.ContainsKey(new CodeClass(1)));
  Assert.IsFalse(Data.ContainsValue("One"));
  Assert.IsFalse(Data.Remove(new CodeClass(1)));
  Assert.Throws(->Data.Remove(nil));
end;

method DictionaryTest.Item;
begin  
  var C := new CodeClass(1);
  Assert.IsNotNil(Data.Item[C]);
  Assert.IsNotNil(Data[C]);
  Assert.AreEqual(Data.Item[C], "One");
  Assert.AreEqual(Data[C], "One");
  Assert.Throws(->Data.Item[new CodeClass(55)]);
  Assert.Throws(->Data.Item[nil]);

  Data[C] := "First";
  Assert.AreEqual(Data.Item[C], "First");

  //if key doesn't exists it should be added
  Assert.AreEqual(Data.Count, 3);
  Data[new CodeClass(4)] := "Four";
  Assert.AreEqual(Data.Count, 4);
  Assert.IsTrue(Data.ContainsKey(new CodeClass(4)));
  Assert.IsTrue(Data.ContainsValue("Four"));
  Assert.Throws(->begin Data[nil] := ""; end);  
end;

method DictionaryTest.Keys;
begin
  var Expected := new Sugar.Collections.List<CodeClass>;
  Expected.Add(new CodeClass(1));
  Expected.Add(new CodeClass(2));
  Expected.Add(new CodeClass(3));
  var Actual := Data.Keys;

  Assert.AreEqual(length(Actual), 3);
  //elements order is not defined
  for i: Integer := 0 to length(Actual) - 1 do
    Assert.IsTrue(Expected.Contains(Actual[i]));
end;

method DictionaryTest.Values;
begin
  var Expected := new Sugar.Collections.List<String>;
  Expected.Add("One");
  Expected.Add("Two");
  Expected.Add("Three");
  var Actual := Data.Values;

  Assert.AreEqual(length(Actual), 3);
  for i: Integer := 0 to length(Actual) - 1 do
    Assert.IsTrue(Expected.Contains(Actual[i]));
end;

method DictionaryTest.Count;
begin
  Assert.AreEqual(Data.Count, 3);
  Assert.IsTrue(Data.Remove(new CodeClass(1)));
  Assert.AreEqual(Data.Count, 2);
  Data.Add(new CodeClass(1), "One");
  Assert.AreEqual(Data.Count, 3);
  Data.Clear;
  Assert.AreEqual(Data.Count, 0);
end;

method DictionaryTest.ForEach;
begin
  var Item1 := new KeyValuePair<String, String>("Key", "Value");
  var Item2 := new KeyValuePair<String, String>("Key", "Value");
  Assert.IsTrue(Item1.Equals(Item2));

  Data.Add(new CodeClass(-1), nil);
  var Expected := new Sugar.Collections.List<KeyValuePair<CodeClass, String>>;
  Expected.Add(new KeyValuePair<CodeClass, String>(new CodeClass(1),"One"));
  Expected.Add(new KeyValuePair<CodeClass, String>(new CodeClass(2),"Two"));
  Expected.Add(new KeyValuePair<CodeClass, String>(new CodeClass(3),"Three"));
  Expected.Add(new KeyValuePair<CodeClass, String>(new CodeClass(-1), nil));

  var &Index: Integer := 0;

  Data.ForEach(x -> begin
    Assert.IsTrue(Expected.Contains(x));
    &Index := &Index + 1;
  end);

  Assert.AreEqual(&Index, 4);
end;

method DictionaryTest.NilValue;
begin
  Data.Add(new CodeClass(-1), nil);
  Assert.IsTrue(Data.ContainsValue(nil));
  Assert.IsNil(Data[new CodeClass(-1)]);
  Assert.AreEqual(Data[new CodeClass(1)], "One");
  Data[new CodeClass(1)] := nil;
  Assert.AreEqual(Data.Item[new CodeClass(1)], nil);
end;

end.
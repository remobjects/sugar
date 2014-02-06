namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.Collections,
  Sugar.TestFramework;

type
  ListTest = public class (Testcase)
  private
    Data: Sugar.Collections.List<String>;
  public
    method Setup; override;  
    method Constructors;
    method &Add;
    method AddRange;
    method Clear;
    method Contains;

    method Exists;
    method FindIndex;
    method Find;
    method FindAll;
    method TrueForAll;

    method IndexOf;
    method Insert;
    method LastIndexOf;
    method &Remove;
    method RemoveAt;
    method RemoveRange;
    method ToArray;
    method Count;
    method Item;
    method Enumerator;
    method ForEach;
  end;

implementation

method ListTest.Setup;
begin
  Data := new Sugar.Collections.List<String>;
  Data.Add("One");
  Data.Add("Two");
  Data.Add("Three");
end;

method ListTest.Constructors;
begin
  var Actual := new Sugar.Collections.List<String>(Data);
  Assert.IsNotNull(Actual);
  Assert.CheckInt(3, Actual.Count);
  Assert.CheckString("One", Actual[0]);

  var Expected: array of String := ["A", "B", "C"];
  Actual := new Sugar.Collections.List<String>(Expected);
  Assert.IsNotNull(Actual);
  Assert.CheckInt(3, Actual.Count);
  for i: Integer := 0 to Actual.Count - 1 do
    Assert.CheckString(Expected[i], Actual[i]);
end;

method ListTest.&Add;
begin
  Assert.CheckInt(3, Data.Count);
  Data.Add("Four");
  Assert.CheckInt(4, Data.Count);
  Assert.CheckBool(true, Data.Contains("Four"));

  Data.Add("Four");
  Assert.CheckInt(5, Data.Count);

  Assert.IsException(->Data.Add(nil));
end;

method ListTest.AddRange;
begin
  var Value := new Sugar.Collections.List<String>;
  Value.Add("Item1");
  Value.Add("Item2");

  Data.AddRange(Value);
  Assert.CheckInt(5, Data.Count);
  Assert.CheckBool(true, Data.Contains("Item1"));
  Assert.CheckBool(true, Data.Contains("Item2"));

  Data.AddRange(new Sugar.Collections.List<String>);
  Assert.CheckInt(5, Data.Count);

  Value := nil;
  Assert.IsException(->Data.AddRange(Value));
end;

method ListTest.Clear;
begin
  Assert.CheckInt(3, Data.Count);
  Data.Clear;
end;

method ListTest.Contains;
begin
  Assert.CheckBool(true, Data.Contains("One"));
  Assert.CheckBool(true, Data.Contains("Two"));
  Assert.CheckBool(true, Data.Contains("Three"));

  Assert.CheckBool(false, Data.Contains("one"));
  Assert.CheckBool(false, Data.Contains(nil));
end;

method ListTest.Exists;
begin
  Assert.CheckBool(true, Data.Exists(x -> x = "Two"));
  Assert.CheckBool(false, Data.Exists(x -> x = "tWo"));
  Assert.CheckBool(true, Data.Exists(x -> x.EqualsIngoreCase("tWo")));
end;

method ListTest.FindIndex;
begin
  Assert.CheckInt(1, Data.FindIndex(x -> x = "Two"));
  Assert.CheckInt(-1, Data.FindIndex(x -> x = "two"));

  Assert.CheckInt(1, Data.FindIndex(1, x -> x = "Two"));
  Assert.CheckInt(-1, Data.FindIndex(1, x -> x = "two"));
  Assert.CheckInt(-1, Data.FindIndex(2, x -> x = "Two"));

  Assert.CheckInt(1, Data.FindIndex(1, 2, x -> x = "Two"));
  Assert.CheckInt(-1, Data.FindIndex(1, 2, x -> x = "two"));
  Assert.CheckInt(-1, Data.FindIndex(0, 1, x -> x = "Two"));

  Assert.IsException(->Data.FindIndex(-1, x -> x = "Two"));
  Assert.IsException(->Data.FindIndex(55, x -> x = "Two"));
  Assert.IsException(->Data.FindIndex(-1, 3, x -> x = "Two"));
  Assert.IsException(->Data.FindIndex(55, 3, x -> x = "Two"));
  Assert.IsException(->Data.FindIndex(0, 55, x -> x = "Two"));
  Assert.IsException(->Data.FindIndex(0, -1, x -> x = "Two"));
end;

method ListTest.Find;
begin
  Assert.CheckString("Two", Data.Find(x -> x = "Two"));
  Assert.IsNull(Data.Find(x -> x = "!Two!"));
end;

method ListTest.FindAll;
begin
  Data.Add("Two");
  Assert.CheckInt(4, Data.Count);

  var Actual := Data.FindAll(x -> x = "Two");
  Assert.IsNotNull(Actual);
  Assert.CheckInt(2, Actual.Count);

  for Item: String in Actual do
    Assert.CheckString("Two", Item);

  Actual := Data.FindAll(x -> x = "!Two!");
  Assert.IsNotNull(Actual);
  Assert.CheckInt(0, Actual.Count);
end;

method ListTest.TrueForAll;
begin
  Assert.CheckBool(true, Data.TrueForAll(x -> x <> ""));
  Assert.CheckBool(false, Data.TrueForAll(x -> x = ""));
end;

method ListTest.IndexOf;
begin
  Assert.CheckInt(0, Data.IndexOf("One"));
  Assert.CheckInt(1, Data.IndexOf("Two"));
  Assert.CheckInt(2, Data.IndexOf("Three"));
  Assert.CheckInt(-1, Data.IndexOf("one"));
  Assert.CheckInt(-1, Data.IndexOf(nil));
end;

method ListTest.Insert;
begin
  Assert.CheckInt(1, Data.IndexOf("Two"));
  Data.Insert(1, "Item");
  Assert.CheckInt(4, Data.Count);
  Assert.CheckInt(1, Data.IndexOf("Item"));
  Assert.CheckInt(2, Data.IndexOf("Two"));

  //added to end of list
  Data.Insert(Data.Count, "Item2");
  Assert.CheckInt(4, Data.IndexOf("Item2"));

  Assert.IsException(->Data.Insert(1, nil));
  Assert.IsException(->Data.Insert(-1, "item"));
  Assert.IsException(->Data.Insert(555, "item"));
end;

method ListTest.LastIndexOf;
begin
  Assert.CheckInt(1, Data.LastIndexOf("Two"));
  Data.Add("Two");
  Assert.CheckInt(3, Data.LastIndexOf("Two"));
  
  Assert.CheckInt(-1, Data.LastIndexOf("two"));
  Assert.CheckInt(-1, Data.LastIndexOf(nil));
end;

method ListTest.&Remove;
begin
  Assert.CheckBool(true, Data.Remove("One"));
  Assert.CheckInt(2, Data.Count);
  Assert.CheckBool(false, Data.Contains("One"));
  Assert.CheckBool(false, Data.Remove("qwerty"));
  Assert.CheckBool(false, Data.Remove(nil));

  Data.Clear;
  Data.Add("Item");
  Data.Add("Item");
  Assert.CheckInt(2, Data.Count);

  Assert.CheckBool(true, Data.Remove("Item")); //removes first occurense
  Assert.CheckInt(1, Data.Count);
  Assert.CheckBool(true, Data.Remove("Item"));
  Assert.CheckInt(0, Data.Count);
  Assert.CheckBool(false, Data.Remove("Item"));
end;

method ListTest.RemoveAt;
begin
  Data.RemoveAt(1);
  Assert.CheckInt(2, Data.Count);
  Assert.CheckBool(false, Data.Contains("Two"));

  Assert.IsException(->Data.RemoveAt(-1));
  Assert.IsException(->Data.RemoveAt(Data.Count));
end;

method ListTest.RemoveRange;
begin
  Data.RemoveRange(1, 2);
  Assert.CheckInt(1, Data.Count);
  Assert.CheckBool(false, Data.Contains("Two"));
  Assert.CheckBool(false, Data.Contains("Three"));

  Data.Add("Item");
  Data.RemoveRange(1, 0);
  Assert.CheckInt(2, Data.Count);
  Assert.CheckBool(true, Data.Contains("Item"));
  Data.RemoveRange(1, 1);
  Assert.CheckInt(1, Data.Count);
  Assert.CheckBool(false, Data.Contains("Item"));

  Assert.IsException(->Data.RemoveRange(-1, 1));
  Assert.IsException(->Data.RemoveRange(1, -1));
  Assert.IsException(->Data.RemoveRange(1, 55));
  Assert.IsException(->Data.RemoveRange(55, 1));
end;

method ListTest.ToArray;
begin
  var Expected: array of String := ["One", "Two", "Three"];
  var Actual := Data.ToArray;
  Assert.CheckInt(3, length(Actual));
  for i: Integer := 0 to length(Expected) -1 do
    Assert.CheckString(Expected[i], Actual[i]);
end;

method ListTest.Count;
begin
  Assert.CheckInt(3, Data.Count);
  Data.RemoveAt(0);
  Assert.CheckInt(2, Data.Count);
  Data.Add("Item");
  Assert.CheckInt(3, Data.Count);
  Data.Clear;
  Assert.CheckInt(0, Data.Count);
end;

method ListTest.Item;
begin
  Assert.CheckString("One", Data.Item[0]);
  Assert.CheckString("One", Data[0]);
  
  Assert.CheckString("Two", Data.Item[1]);
  Data.Insert(1, "Item");
  Assert.CheckString("Item", Data.Item[1]);

  Data[1] := "Item1";
  Assert.CheckString("Item1", Data.Item[1]);

  Assert.IsException(->Data[-1]);
  Assert.IsException(->Data[55]);
  Assert.IsException(->begin Data[0] := nil; end);
end;

method ListTest.Enumerator;
begin
  var Expected: array of String := ["One", "Two", "Three"];
  var &Index: Integer := 0;

  for Item: String in Data do begin
    Assert.CheckString(Expected[&Index], Item);
    inc(&Index);
  end;

  Assert.CheckInt(3, &Index);
end;

method ListTest.ForEach;
begin
  var Expected: array of String := ["One", "Two", "Three"];
  var &Index: Integer := 0;

  Data.ForEach(x -> begin
    Assert.CheckString(Expected[&Index], x);
    &Index := &Index + 1;
  end);

  Assert.CheckInt(3, &Index);
end;

end.
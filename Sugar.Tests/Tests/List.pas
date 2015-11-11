namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.Collections,
  RemObjects.Elements.EUnit;

type
  ListTest = public class (Test)
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
    method Sort;
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
  Assert.IsNotNil(Actual);
  Assert.AreEqual(Actual.Count, 3);
  Assert.AreEqual(Actual[0], "One");

  var Expected: array of String := ["A", "B", "C"];
  Actual := new Sugar.Collections.List<String>(Expected);
  Assert.IsNotNil(Actual);
  Assert.AreEqual(Actual.Count, 3);
  Assert.AreEqual(Actual, Expected, true);
end;

method ListTest.&Add;
begin
  Assert.AreEqual(Data.Count, 3);
  Data.Add("Four");
  Assert.AreEqual(Data.Count, 4);
  Assert.Contains<String>("Four", Data);

  Data.Add("Four");
  Assert.AreEqual(Data.Count, 5);

  Data.Add(nil);
  Assert.AreEqual(Data.Count, 6);
  Assert.IsNil(Data[5]);
end;

method ListTest.AddRange;
begin
  var Value := new Sugar.Collections.List<String>;
  Value.Add("Item1");
  Value.Add("Item2");

  Data.AddRange(Value);
  Assert.AreEqual(Data.Count, 5);
  Assert.Contains("Item1", Data);
  Assert.Contains("Item2", Data);

  Data.AddRange(new Sugar.Collections.List<String>);
  Assert.AreEqual(Data.Count, 5);

  Value := nil;
  Assert.Throws(->Data.AddRange(Value));
end;

method ListTest.Clear;
begin
  Assert.AreEqual(Data.Count, 3);
  Data.Clear;
  Assert.AreEqual(Data.Count, 0);
end;

method ListTest.Contains;
begin
  Assert.IsTrue(Data.Contains("One"));
  Assert.IsTrue(Data.Contains("Two"));
  Assert.IsTrue(Data.Contains("Three"));

  Assert.IsFalse(Data.Contains("one"));
  Assert.IsFalse(Data.Contains(nil));
  Data.Add(nil);
  Assert.IsTrue(Data.Contains(nil));
end;

method ListTest.Exists;
begin
  Assert.IsTrue(Data.Exists(x -> x = "Two"));
  Assert.IsFalse(Data.Exists(x -> x = "tWo"));
  Assert.IsTrue(Data.Exists(x -> x.EqualsIgnoreCase("tWo")));
end;

method ListTest.FindIndex;
begin
  Assert.AreEqual(Data.FindIndex(x -> x = "Two"), 1);
  Assert.AreEqual(Data.FindIndex(x -> x = "two"), -1);

  Assert.AreEqual(Data.FindIndex(1, x -> x = "Two"), 1);
  Assert.AreEqual(Data.FindIndex(1, x -> x = "two"), -1);
  Assert.AreEqual(Data.FindIndex(2, x -> x = "Two"), -1);

  Assert.AreEqual(Data.FindIndex(1, 2, x -> x = "Two"), 1);
  Assert.AreEqual(Data.FindIndex(1, 2, x -> x = "two"), -1);
  Assert.AreEqual(Data.FindIndex(0, 1, x -> x = "Two"), -1);

  Assert.Throws(->Data.FindIndex(-1, x -> x = "Two"));
  Assert.Throws(->Data.FindIndex(55, x -> x = "Two"));
  Assert.Throws(->Data.FindIndex(-1, 3, x -> x = "Two"));
  Assert.Throws(->Data.FindIndex(55, 3, x -> x = "Two"));
  Assert.Throws(->Data.FindIndex(0, 55, x -> x = "Two"));
  Assert.Throws(->Data.FindIndex(0, -1, x -> x = "Two"));
end;

method ListTest.Find;
begin
  Assert.AreEqual(Data.Find(x -> x = "Two"), "Two");
  Assert.IsNil(Data.Find(x -> x = "!Two!"));
end;

method ListTest.FindAll;
begin
  Data.Add("Two");
  Assert.AreEqual(Data.Count, 4);

  var Actual := Data.FindAll(x -> x = "Two");
  Assert.IsNotNil(Actual);
  Assert.AreEqual(Actual.Count, 2);

  for Item: String in Actual do
    Assert.AreEqual(Item, "Two");

  Actual := Data.FindAll(x -> x = "!Two!");
  Assert.IsNotNil(Actual);
  Assert.AreEqual(Actual.Count, 0);
end;

method ListTest.TrueForAll;
begin
  Assert.IsTrue(Data.TrueForAll(x -> x <> ""));
  Assert.IsFalse(Data.TrueForAll(x -> x = ""));
end;

method ListTest.IndexOf;
begin
  Assert.AreEqual(Data.IndexOf("One"), 0);
  Assert.AreEqual(Data.IndexOf("Two"), 1);
  Assert.AreEqual(Data.IndexOf("Three"), 2);
  Assert.AreEqual(Data.IndexOf("one"), -1);
  Assert.AreEqual(Data.IndexOf(nil), -1);
end;

method ListTest.Insert;
begin
  Assert.AreEqual(Data.IndexOf("Two"), 1);
  Data.Insert(1, "Item");
  Assert.AreEqual(Data.Count, 4);
  Assert.AreEqual(Data.IndexOf("Item"), 1);
  Assert.AreEqual(Data.IndexOf("Two"), 2);

  //added to end of list
  Data.Insert(Data.Count, "Item2");
  Assert.AreEqual(Data.IndexOf("Item2"), 4);

  Data.Insert(1, nil);
  Assert.AreEqual(Data.IndexOf(nil), 1);
  
  Assert.Throws(->Data.Insert(-1, "item"));
  Assert.Throws(->Data.Insert(555, "item"));
end;

method ListTest.LastIndexOf;
begin
  Assert.AreEqual(Data.LastIndexOf("Two"), 1);
  Data.Add("Two");
  Assert.AreEqual(Data.LastIndexOf("Two"), 3);
  
  Assert.AreEqual(Data.LastIndexOf("two"), -1);
  Assert.AreEqual(Data.LastIndexOf(nil), -1);
end;

method ListTest.&Remove;
begin
  Assert.IsTrue(Data.Remove("One"));
  Assert.AreEqual(Data.Count, 2);
  Assert.IsFalse(Data.Contains("One"));
  Assert.IsFalse(Data.Remove("qwerty"));
  Assert.IsFalse(Data.Remove(nil));

  Data.Clear;
  Data.Add("Item");
  Data.Add("Item");
  Assert.AreEqual(Data.Count, 2);

  Assert.IsTrue(Data.Remove("Item")); //removes first occurense
  Assert.AreEqual(Data.Count, 1);
  Assert.IsTrue( Data.Remove("Item"));
  Assert.AreEqual(Data.Count, 0);
  Assert.IsFalse( Data.Remove("Item"));
end;

method ListTest.RemoveAt;
begin
  Data.RemoveAt(1);
  Assert.AreEqual(Data.Count, 2);
  Assert.IsFalse(Data.Contains("Two"));

  Assert.Throws(->Data.RemoveAt(-1));
  Assert.Throws(->Data.RemoveAt(Data.Count));
end;

method ListTest.RemoveRange;
begin
  Data.RemoveRange(1, 2);
  Assert.AreEqual(Data.Count, 1);
  Assert.IsFalse(Data.Contains("Two"));
  Assert.IsFalse(Data.Contains("Three"));

  Data.Add("Item");
  Data.RemoveRange(1, 0);
  Assert.AreEqual(Data.Count, 2);
  Assert.IsTrue(Data.Contains("Item"));
  Data.RemoveRange(1, 1);
  Assert.AreEqual(Data.Count, 1);
  Assert.IsFalse(Data.Contains("Item"));

  Assert.Throws(->Data.RemoveRange(-1, 1));
  Assert.Throws(->Data.RemoveRange(1, -1));
  Assert.Throws(->Data.RemoveRange(1, 55));
  Assert.Throws(->Data.RemoveRange(55, 1));
end;

method ListTest.ToArray;
begin
  var Expected: array of String := ["One", "Two", "Three"];
  var Actual := Data.ToArray;
  Assert.AreEqual(length(Actual), 3);
  Assert.AreEqual(Actual, Expected, true);
end;

method ListTest.Count;
begin
  Assert.AreEqual(Data.Count,3 );
  Data.RemoveAt(0);
  Assert.AreEqual(Data.Count, 2);
  Data.Add("Item");
  Assert.AreEqual(Data.Count, 3);
  Data.Clear;
  Assert.AreEqual(Data.Count, 0);
end;

method ListTest.Item;
begin
  Assert.AreEqual(Data.Item[0], "One");
  Assert.AreEqual(Data[0], "One");
  
  Assert.AreEqual(Data.Item[1], "Two");
  Data.Insert(1, "Item");
  Assert.AreEqual(Data.Item[1], "Item");

  Data[1] := "Item1";
  Assert.AreEqual(Data.Item[1], "Item1");

  Data[1] := nil;
  Assert.IsNil(Data.Item[1]);

  Assert.Throws(->Data[-1]);
  Assert.Throws(->Data[55]);  
end;

method ListTest.Enumerator;
begin
  var Expected: array of String := ["One", "Two", "Three"];
  var &Index: Integer := 0;

  for Item: String in Data do begin
    Assert.AreEqual(Item, Expected[&Index]);
    inc(&Index);
  end;

  Assert.AreEqual(&Index, 3);
end;

method ListTest.ForEach;
begin
  var Expected: array of String := ["One", "Two", "Three"];
  var &Index: Integer := 0;

  Data.ForEach(x -> begin
    Assert.AreEqual(x, Expected[&Index]);
    &Index := &Index + 1;
  end);

  Assert.AreEqual(&Index, 3);
end;

method ListTest.Sort;
begin
  var Expected: array of String := ["A", "C", "b"];
  Data.Clear;
  Data.Add("C");
  Data.Add("A");
  Data.Add("b");

  Assert.AreEqual(Data.Count, 3);
  Data.Sort((x, y) -> x.CompareTo(y));

  for i: Integer := 0 to Data.Count - 1 do
    Assert.AreEqual(Data[i], Expected[i]);

  Expected := ["A", "b", "C"];

  Data.Sort((x, y) -> x.CompareToIgnoreCase(y));
  for i: Integer := 0 to Data.Count - 1 do
    Assert.AreEqual(Data[i], Expected[i]);
end;

end.

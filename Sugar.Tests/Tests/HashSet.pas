namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.Collections,
  RemObjects.Elements.EUnit;

type
  HashSetTest = public class (Test)
  private  
    Data: HashSet<String>;
  public
    method Setup; override;
    method &Add;
    method Clear;
    method Contains;
    method &Remove;
    method Count;
    method Enumerator;
    method Intersect;
    method ForEach;
    method Constructors;
    method &Union;
    method IsSubsetOf;
    method IsSupersetOf;
    method SetEquals;
  end;

implementation

method HashSetTest.Setup;
begin
  Data := new HashSet<String>;
  Data.Add("One");
  Data.Add("Two");
  Data.Add("Three");
end;

method HashSetTest.Constructors;
begin
  var Actual := new HashSet<String>(Data);
  Assert.AreEqual(Actual.Count, 3);
  Assert.AreEqual(Data.Count, 3);

  Actual.ForEach(item -> Assert.IsTrue(Data.Contains(item)));
end;

method HashSetTest.&Add;
begin
  Assert.IsTrue(Data.Add("Four"));
  Assert.AreEqual(Data.Count, 4);
  Assert.IsTrue(Data.Contains("Four"));
  
  //no duplicates allowed
  Assert.IsFalse(Data.Add("Four"));
  Assert.AreEqual(Data.Count, 4);

  Assert.IsTrue(Data.Add(nil));
  Assert.AreEqual(Data.Count, 5);
end;

method HashSetTest.Clear;
begin
  Assert.AreEqual(Data.Count, 3);
  Data.Clear;
  Assert.AreEqual(Data.Count, 0);
end;

method HashSetTest.Contains;
begin
  Assert.IsTrue(Data.Contains("One"));
  Assert.IsTrue(Data.Contains("Two"));
  Assert.IsTrue(Data.Contains("Three"));
  Assert.IsFalse(Data.Contains("one")); 
  Assert.IsFalse(Data.Contains(nil));
end;

method HashSetTest.&Remove;
begin
  Assert.IsTrue(Data.Remove("One"));
  Assert.AreEqual(Data.Count, 2);
  Assert.IsFalse(Data.Contains("One")); 

  Assert.IsFalse(Data.Remove("One"));
  Assert.IsFalse(Data.Remove(nil));

  Assert.IsFalse(Data.Remove("two"));
  Assert.AreEqual(Data.Count, 2);
  Assert.IsTrue(Data.Contains("Two")); 
end;

method HashSetTest.Count;
begin
  Assert.AreEqual(Data.Count, 3);
  Assert.IsTrue(Data.Remove("One"));
  Assert.AreEqual(Data.Count, 2);
  Data.Clear;
  Assert.AreEqual(Data.Count, 0);
end;

method HashSetTest.Enumerator;
begin
  var Expected: HashSet<String> := new HashSet<String>;
  Expected.Add("One");
  Expected.Add("Two");
  Expected.Add("Three");

  var lCount: Integer := 0;
  for Item: String in Data do begin
    inc(lCount);
    Assert.IsTrue(Expected.Contains(Item));
  end;
  Assert.AreEqual(lCount, 3);
end;

method HashSetTest.ForEach;
begin
  var Expected: HashSet<String> := new HashSet<String>;
  Expected.Add("One");
  Expected.Add("Two");
  Expected.Add("Three");

  var lCount: Integer := 0;
  Data.ForEach(x -> begin
                 inc(lCount);
                 Assert.IsTrue(Expected.Contains(x));
                 end);
  Assert.AreEqual(lCount, 3);  
end;

method HashSetTest.Intersect;
begin
  var Value: HashSet<String> := new HashSet<String>;
  Value.Add("Zero");
  Value.Add("Two");
  Value.Add("Three");

  Data.Intersect(Value);
  Assert.AreEqual(Data.Count, 2);
  Assert.IsTrue(Data.Contains("Two"));  
  Assert.IsTrue(Data.Contains("Three"));
  Assert.AreEqual(Value.Count, 3);

  Data.Intersect(new HashSet<String>);
  Assert.AreEqual(Data.Count, 0);

  Assert.Throws(->Data.Intersect(nil));
end;

method HashSetTest.&Union;
begin
  var Value: HashSet<String> := new HashSet<String>;
  Value.Add("Zero");
  Value.Add("Two");
  Value.Add("Three");

  var Expected: HashSet<String> := new HashSet<String>;
  Expected.Add("One");
  Expected.Add("Two");
  Expected.Add("Three");
  Expected.Add("Zero");

  Data.Union(Value);
  Assert.AreEqual(Data.Count, 4);
  Assert.AreEqual(Value.Count, 3);

  Data.ForEach(item -> Assert.IsTrue(Expected.Contains(item)));
end;

method HashSetTest.IsSupersetOf;
begin
  var Value: HashSet<String> := new HashSet<String>;
  Value.Add("Two");
  Value.Add("Three");

  Assert.IsTrue(Data.IsSupersetOf(Value));

  Value.Add("One");
  Assert.IsTrue(Data.IsSupersetOf(Value));

  Value.Remove("One");
  Value.Add("Zero");
  Assert.IsFalse(Data.IsSupersetOf(Value));

  Assert.IsTrue(Data.IsSupersetOf(new HashSet<String>));

  Assert.Throws(->Data.IsSupersetOf(nil));
end;

method HashSetTest.IsSubsetOf;
begin
  var Value: HashSet<String> := new HashSet<String>;
  Value.Add("Two");
  Value.Add("Three");

  Assert.IsTrue(Value.IsSubsetOf(Data));

  Value.Add("One");
  Assert.IsTrue(Value.IsSubsetOf(Data));

  Value.Remove("One");
  Value.Add("Zero");
  Assert.IsFalse(Value.IsSubsetOf(Data));

  Assert.IsTrue(new HashSet<String>().IsSubsetOf(Data));
  Assert.IsFalse(Data.IsSubsetOf(new HashSet<String>));

  Assert.Throws(->Data.IsSubsetOf(nil));
end;

method HashSetTest.SetEquals;
begin
  var Value: HashSet<String> := new HashSet<String>;
  Value.Add("Two");
  Value.Add("Three");

  Assert.IsFalse(Data.SetEquals(Value));

  Value.Add("One");
  Assert.IsTrue(Data.SetEquals(Value));
  Value.Clear;
  Data.Clear;
  Assert.IsTrue(Data.SetEquals(Value));
  
  Assert.Throws(->Data.SetEquals(nil));
end;

end.
namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.Collections,
  Sugar.TestFramework;

type
  HashSetTest = public class (Testcase)
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
  Assert.CheckInt(3, Actual.Count);
  Assert.CheckInt(3, Data.Count);

  Actual.ForEach(item -> Assert.CheckBool(true, Data.Contains(item)));
end;

method HashSetTest.&Add;
begin
  Assert.CheckBool(true,Data.Add("Four"));
  Assert.CheckInt(4, Data.Count);
  Assert.CheckBool(true, Data.Contains("Four"));
  
  //no duplicates allowed
  Assert.CheckBool(false, Data.Add("Four"));
  Assert.CheckInt(4, Data.Count);

  Assert.CheckBool(true, Data.Add(nil));
  Assert.CheckInt(5, Data.Count);
end;

method HashSetTest.Clear;
begin
  Assert.CheckInt(3, Data.Count);
  Data.Clear;
  Assert.CheckInt(0, Data.Count);
end;

method HashSetTest.Contains;
begin
  Assert.CheckBool(true, Data.Contains("One"));
  Assert.CheckBool(true, Data.Contains("Two"));
  Assert.CheckBool(true, Data.Contains("Three"));
  Assert.CheckBool(false, Data.Contains("one")); 
  Assert.CheckBool(false, Data.Contains(nil));
end;

method HashSetTest.&Remove;
begin
  Assert.CheckBool(true, Data.Remove("One"));
  Assert.CheckInt(2, Data.Count);
  Assert.CheckBool(false, Data.Contains("One")); 

  Assert.CheckBool(false, Data.Remove("One"));
  Assert.CheckBool(false, Data.Remove(nil));

  Assert.CheckBool(false, Data.Remove("two"));
  Assert.CheckInt(2, Data.Count);
  Assert.CheckBool(true, Data.Contains("Two")); 
end;

method HashSetTest.Count;
begin
  Assert.CheckInt(3, Data.Count);
  Assert.CheckBool(true, Data.Remove("One"));
  Assert.CheckInt(2, Data.Count);
  Data.Clear;
  Assert.CheckInt(0, Data.Count);
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
    Assert.CheckBool(true, Expected.Contains(Item));
  end;
  Assert.CheckInt(3, lCount);    
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
                 Assert.CheckBool(true, Expected.Contains(x));
                 end);
  Assert.CheckInt(3, lCount);   
end;

method HashSetTest.Intersect;
begin
  var Value: HashSet<String> := new HashSet<String>;
  Value.Add("Zero");
  Value.Add("Two");
  Value.Add("Three");

  Data.Intersect(Value);
  Assert.CheckInt(2, Data.Count);
  Assert.CheckBool(true, Data.Contains("Two"));  
  Assert.CheckBool(true, Data.Contains("Three"));
  Assert.CheckInt(3, Value.Count);

  Data.Intersect(new HashSet<String>);
  Assert.CheckInt(0, Data.Count);

  Assert.IsException(->Data.Intersect(nil));
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
  Assert.CheckInt(4, Data.Count);
  Assert.CheckInt(3, Value.Count);

  Data.ForEach(item -> Assert.CheckBool(true, Expected.Contains(item)));
end;

method HashSetTest.IsSupersetOf;
begin
  var Value: HashSet<String> := new HashSet<String>;
  Value.Add("Two");
  Value.Add("Three");

  Assert.CheckBool(true, Data.IsSupersetOf(Value));

  Value.Add("One");
  Assert.CheckBool(true, Data.IsSupersetOf(Value));

  Value.Remove("One");
  Value.Add("Zero");
  Assert.CheckBool(false, Data.IsSupersetOf(Value));

  Assert.CheckBool(true, Data.IsSupersetOf(new HashSet<String>));

  Assert.IsException(->Data.IsSupersetOf(nil));
end;

method HashSetTest.IsSubsetOf;
begin
  var Value: HashSet<String> := new HashSet<String>;
  Value.Add("Two");
  Value.Add("Three");

  Assert.CheckBool(true, Value.IsSubsetOf(Data));

  Value.Add("One");
  Assert.CheckBool(true, Value.IsSubsetOf(Data));

  Value.Remove("One");
  Value.Add("Zero");
  Assert.CheckBool(false, Value.IsSubsetOf(Data));

  Assert.CheckBool(true, new HashSet<String>().IsSubsetOf(Data));
  Assert.CheckBool(false, Data.IsSubsetOf(new HashSet<String>));

  Assert.IsException(->Data.IsSubsetOf(nil));
end;

method HashSetTest.SetEquals;
begin
  var Value: HashSet<String> := new HashSet<String>;
  Value.Add("Two");
  Value.Add("Three");

  Assert.CheckBool(false, Data.SetEquals(Value));

  Value.Add("One");
  Assert.CheckBool(true, Data.SetEquals(Value));
  Value.Clear;
  Data.Clear;
  Assert.CheckBool(true, Data.SetEquals(Value));
  
  Assert.IsException(->Data.SetEquals(nil));
end;

end.
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
  end;

implementation

method HashSetTest.Setup;
begin
  Data := new HashSet<String>;
  Data.Add("One");
  Data.Add("Two");
  Data.Add("Three");
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

end.
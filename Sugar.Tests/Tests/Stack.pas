namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.Collections,
  RemObjects.Elements.EUnit;

type
  StackTest = public class (Test)
  private
    Data: Stack<String>;
  public
    method Setup; override;
    method Count;
    method Contains;
    method Clear;
    method Peek;
    method Pop;
    method Push;
    method ToArray;
    method ForEach;
  end;

implementation

method StackTest.Setup;
begin
  Data := new Stack<String>;
  Data.Push("One");
  Data.Push("Two");
  Data.Push("Three");  
end;

method StackTest.Count;
begin
  Assert.AreEqual(Data.Count, 3);
  Data.Pop;
  Assert.AreEqual(Data.Count, 2);
  Assert.AreEqual(new Stack<Integer>().Count, 0);
end;

method StackTest.Contains;
begin
  Assert.IsTrue(Data.Contains("One"));
  Assert.IsTrue(Data.Contains("Two"));
  Assert.IsTrue(Data.Contains("Three"));
  Assert.IsFalse(Data.Contains("one")); //case sensetive
  Assert.IsFalse(Data.Contains("xxx"));
  Assert.IsFalse(Data.Contains(nil));
end;

method StackTest.Clear;
begin
  Assert.AreEqual(Data.Count, 3);
  Data.Clear;
  Assert.AreEqual(Data.Count, 0);
end;

method StackTest.Peek;
begin
  Assert.AreEqual(Data.Peek, "Three");
  Assert.AreEqual(Data.Peek, "Three"); //peek shouldn't remove item from stack
  Data.Push("Four");
  Assert.AreEqual(Data.Peek, "Four");
  Data.Clear;
  Assert.Throws(->Data.Peek); //empty stack
end;

method StackTest.Pop;
begin
  //pop removes item from stack
  Assert.AreEqual(Data.Pop, "Three");
  Assert.AreEqual(Data.Pop, "Two");
  Assert.AreEqual(Data.Pop, "One");
  Assert.AreEqual(Data.Count, 0);
  Assert.Throws(->Data.Pop);
end;

method StackTest.Push;
begin
  Data.Push("Four");
  Assert.AreEqual(Data.Count, 4);
  Assert.AreEqual(Data.Peek, "Four");
  
  Data.Push(nil);
  Assert.AreEqual(Data.Count, 5);
  Assert.IsNil(Data.Peek);

  //duplicates allowed
  Assert.AreEqual(Data.Count, 5);
  Data.Push("x");
  Data.Push("x");
  Assert.AreEqual(Data.Count, 7);
end;

method StackTest.ToArray;
begin
  var Expected: array of String := ["Three", "Two", "One"];
  var Values: array of String := Data.ToArray;
  Assert.AreEqual(Values, Expected);
end;

method StackTest.ForEach;
begin
  var Expected: array of String := ["Three", "Two", "One"];
  var &Index: Integer := 0;

  Data.ForEach(x -> begin
    Assert.AreEqual(x, Expected[&Index]);
    &Index := &Index + 1;
  end);

  Assert.AreEqual(&Index, 3);
end;

end.

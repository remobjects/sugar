namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.Collections,
  Sugar.TestFramework;

type
  StackTest = public class (Testcase)
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
  Assert.CheckInt(3, Data.Count);
  Assert.CheckInt(0, new Stack<Integer>().Count);
end;

method StackTest.Contains;
begin
  Assert.CheckBool(true, Data.Contains("One"));
  Assert.CheckBool(true, Data.Contains("Two"));
  Assert.CheckBool(true, Data.Contains("Three"));
  Assert.CheckBool(false, Data.Contains("one")); //case sensetive
  Assert.CheckBool(false, Data.Contains("xxx"));
  Assert.CheckBool(false, Data.Contains(nil));
end;

method StackTest.Clear;
begin
  Assert.CheckInt(3, Data.Count);
  Data.Clear;
  Assert.CheckInt(0, Data.Count);
end;

method StackTest.Peek;
begin
  Assert.CheckString("Three", Data.Peek);
  Assert.CheckString("Three", Data.Peek); //peek shouldn't remove item from stack
  Data.Push("Four");
  Assert.CheckString("Four", Data.Peek);
  Data.Clear;
  Assert.IsException(->Data.Peek); //empty stack
end;

method StackTest.Pop;
begin
  //pop removes item from stack
  Assert.CheckString("Three", Data.Pop);
  Assert.CheckString("Two", Data.Pop);
  Assert.CheckString("One", Data.Pop);
  Assert.CheckInt(0, Data.Count);
  Assert.IsException(->Data.Pop);
end;

method StackTest.Push;
begin
  Data.Push("Four");
  Assert.CheckInt(4, Data.Count);
  Assert.CheckString("Four", Data.Peek);
  //nil's not allowed
  Assert.IsException(->Data.Push(nil));

  //duplicates allowed
  Data.Push("x");
  Data.Push("x");
end;

method StackTest.ToArray;
begin
  var Expected: array of String := ["Three", "Two", "One"];
  var Values: array of String := Data.ToArray;
  for i: Integer := 0 to length(Expected) - 1 do
    Assert.CheckString(Expected[i], Values[i]);
end;

method StackTest.ForEach;
begin
  var Expected: array of String := ["Three", "Two", "One"];
  var &Index: Integer := 0;

  Data.ForEach(x -> begin
    Assert.CheckString(Expected[&Index], x);
    &Index := &Index + 1;
  end);

  Assert.CheckInt(3, &Index);
end;

end.

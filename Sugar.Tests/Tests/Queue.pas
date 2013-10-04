namespace Sugar.Test;

interface

{$HIDE W0} //supress case-mismatch errors

uses
  RemObjects.Oxygene.Sugar,
  RemObjects.Oxygene.Sugar.Collections,
  RemObjects.Oxygene.Sugar.TestFramework;

type
  QueueTest = public class (Testcase)
  private
    Data: Queue<Message>;
  public
    method Setup; override;
    method Contains;
    method Clear;
    method Peek;
    method Enqueue;
    method Dequeue;
    method ToArray;
    method Count;
    method Enumerator;
  end;

  Message = public class
  public
    constructor(aData: String; aCode: Integer);    
    method {$IF NOUGAT}isEqual(obj: id){$ELSE}&Equals(Obj: Object){$ENDIF}: Boolean; override;

    property Data: String read write;
    property Code: Integer read write;
  end;

implementation

{ Message }
constructor Message(aData: String; aCode: Integer);
begin
  Data := aData;
  Code := aCode;
end;

method Message.{$IF NOUGAT}isEqual(obj: id){$ELSE}&Equals(Obj: Object){$ENDIF}: Boolean;
begin
  if obj = nil then
    exit false;

  if not (obj is Message) then
    exit false;

  var Msg := (obj as Message);
  exit (Data = Msg.Data) and (Code = Msg.Code);
end;

{ QueueTest }

method QueueTest.Setup;
begin
  Data := new Queue<Message>;
  Data.Enqueue(new Message("One", 1));
  Data.Enqueue(new Message("Two", 2));
  Data.Enqueue(new Message("Three", 3));
end;

method QueueTest.Contains;
begin
  Assert.CheckBool(true, Data.Contains(Data.Peek));
  Assert.CheckBool(true, Data.Contains(new Message("Two", 2)));
  Assert.CheckBool(false, Data.Contains(new Message("Two", 3)));
  Assert.CheckBool(false, Data.Contains(nil));
end;

method QueueTest.Clear;
begin
  Assert.CheckInt(3, Data.Count);
  Data.Clear;
  Assert.CheckInt(0, Data.Count);
end;

method QueueTest.Peek;
begin
  Assert.CheckInt(3, Data.Count);
  var Actual := Data.Peek;
  Assert.CheckInt(3, Data.Count);
  Assert.CheckBool(true, new Message("One", 1).Equals(Actual));
  Data.Clear;
  Assert.IsException(->Data.Peek);
end;

method QueueTest.Enqueue;
begin
  Assert.CheckInt(3, Data.Count);
  var Msg := new Message("Four", 4);
  Data.Enqueue(Msg);
  Assert.CheckInt(4, Data.Count);
  Assert.CheckBool(true, Data.Contains(Msg));
  //must be last
  Data.Dequeue;
  Data.Dequeue;
  Data.Dequeue;
  Assert.CheckBool(true, Data.Peek.Equals(Msg));
  
  //allow duplicates
  Data.Enqueue(Msg);
  Data.Enqueue(Msg);
  Assert.CheckInt(3, Data.Count);

  Assert.IsException(->Data.Enqueue(nil));
end;

method QueueTest.Dequeue;
begin
  var Actual := Data.Dequeue;
  Assert.IsNotNull(Actual);
  Assert.CheckBool(true, Actual.Equals(new Message("One", 1)));
  Assert.CheckInt(2, Data.Count);

  Actual := Data.Dequeue;
  Assert.IsNotNull(Actual);
  Assert.CheckInt(1, Data.Count);
  Assert.CheckBool(true, Actual.Equals(new Message("Two", 2)));

  Actual := Data.Dequeue;
  Assert.IsNotNull(Actual);
  Assert.CheckInt(0, Data.Count);
  Assert.CheckBool(true, Actual.Equals(new Message("Three", 3)));

  Assert.IsException(->Data.Dequeue);
end;

method QueueTest.Count;
begin
  Assert.CheckInt(3, Data.Count);
  Data.Dequeue;
  Assert.CheckInt(2, Data.Count);
  Data.Enqueue(new Message("", 0));
  Assert.CheckInt(3, Data.Count);
  Data.Clear;
  Assert.CheckInt(0, Data.Count);
end;

method QueueTest.ToArray;
begin
  var Expected: array of Message := [new Message("One", 1), new Message("Two", 2), new Message("Three", 3)];
  var Actual: array of Message := Data.ToArray;
  Assert.CheckInt(3, length(Actual));
  for i: Integer := 0 to length(Expected) - 1 do
    Assert.CheckBool(true, Expected[i].Equals(Actual[i]));
end;

method QueueTest.Enumerator;
begin
  var Expected: array of Message := [new Message("One", 1), new Message("Two", 2), new Message("Three", 3)];
  var &Index: Integer := 0;

  for Item: Message in Data do begin
    Assert.CheckBool(true, Expected[&Index].Equals(Item));
    inc(&Index);
  end;

  Assert.CheckInt(3, &Index);
end;

end.
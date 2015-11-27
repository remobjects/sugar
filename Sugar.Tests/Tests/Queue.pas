namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.Collections,
  RemObjects.Elements.EUnit;

type
  QueueTest = public class (Test)
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
  Assert.IsTrue(Data.Contains(Data.Peek));
  Assert.IsTrue(Data.Contains(new Message("Two", 2)));
  Assert.IsFalse(Data.Contains(new Message("Two", 3)));
  Assert.IsFalse(Data.Contains(nil));
end;

method QueueTest.Clear;
begin
  Assert.AreEqual(Data.Count, 3);
  Data.Clear;
  Assert.AreEqual(Data.Count, 0);
end;

method QueueTest.Peek;
begin
  Assert.AreEqual(Data.Count, 3);
  var Actual := Data.Peek;
  Assert.AreEqual(Data.Count, 3);
  Assert.IsTrue(new Message("One", 1).Equals(Actual));
  Data.Clear;
  Assert.Throws(->Data.Peek);
end;

method QueueTest.Enqueue;
begin
  Assert.AreEqual(Data.Count, 3);
  var Msg := new Message("Four", 4);
  Data.Enqueue(Msg);
  Assert.AreEqual(Data.Count, 4);
  Assert.IsTrue(Data.Contains(Msg));
  //must be last
  Data.Dequeue;
  Data.Dequeue;
  Data.Dequeue;
  Assert.IsTrue(Data.Peek.Equals(Msg));
  
  //allow duplicates
  Data.Enqueue(Msg);
  Data.Enqueue(Msg);
  Assert.AreEqual(Data.Count, 3);

  Data.Enqueue(nil);
  Assert.AreEqual(Data.Count, 4);
end;

method QueueTest.Dequeue;
begin
  var Actual := Data.Dequeue;
  Assert.IsNotNil(Actual);
  Assert.IsTrue(Actual.Equals(new Message("One", 1)));
  Assert.AreEqual(Data.Count, 2);

  Actual := Data.Dequeue;
  Assert.IsNotNil(Actual);
  Assert.AreEqual(Data.Count, 1);
  Assert.IsTrue(Actual.Equals(new Message("Two", 2)));

  Actual := Data.Dequeue;
  Assert.IsNotNil(Actual);
  Assert.AreEqual(Data.Count, 0);
  Assert.IsTrue(Actual.Equals(new Message("Three", 3)));

  Assert.Throws(->Data.Dequeue);

  Data.Enqueue(nil);
  Assert.AreEqual(Data.Count, 1);
  Actual := Data.Dequeue;
  Assert.IsNil(Actual);
  Assert.AreEqual(Data.Count, 0);
end;

method QueueTest.Count;
begin
  Assert.AreEqual(Data.Count, 3);
  Data.Dequeue;
  Assert.AreEqual(Data.Count, 2);
  Data.Enqueue(new Message("", 0));
  Assert.AreEqual(Data.Count, 3);
  Data.Clear;
  Assert.AreEqual(Data.Count, 0);
end;

method QueueTest.ToArray;
begin
  var Expected: array of Message := [new Message("One", 1), new Message("Two", 2), new Message("Three", 3)];
  var Actual: array of Message := Data.ToArray;
  Assert.AreEqual(length(Actual), 3);
  for i: Integer := 0 to length(Expected) - 1 do
    Assert.IsTrue(Expected[i].Equals(Actual[i]));
end;

method QueueTest.Enumerator;
begin
  var Expected: array of Message := [new Message("One", 1), new Message("Two", 2), new Message("Three", 3)];
  var &Index: Integer := 0;

  for Item: Message in Data do begin
    Assert.IsTrue(Expected[&Index].Equals(Item));
    inc(&Index);
  end;

  Assert.AreEqual(&Index, 3);
end;

end.
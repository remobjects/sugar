namespace Sugar.Collections;

interface

uses
  Sugar;

type
  Queue<T> = public class mapped to {$IF COOPER}java.util.LinkedList<T>{$ELSEIF ECHOES}System.Collections.Generic.Queue<T>{$ELSEIF NOUGAT}Foundation.NSMutableArray{$ENDIF}
  public
    constructor; mapped to constructor();

    method Contains(Item: T): Boolean;
    method Clear;

    method Peek: T;
    method Enqueue(Item: T);
    method Dequeue: T;
    method ToArray: array of T;

    method ForEach(Action: Action<T>);
    property Count: Integer read {$IF COOPER}mapped.size{$ELSEIF ECHOES OR NOUGAT}mapped.Count{$ENDIF};
  end;

implementation

method Queue<T>.Contains(Item: T): Boolean;
begin
  {$IF COOPER OR ECHOES}
  exit mapped.Contains(Item);
  {$ELSEIF NOUGAT}
  exit mapped.containsObject(Item);
  {$ENDIF}
end;

method Queue<T>.Clear;
begin
  {$IF COOPER OR ECHOES}
  mapped.Clear;
  {$ELSEIF NOUGAT}
  mapped.removeAllObjects;
  {$ENDIF}
end;

method Queue<T>.Dequeue: T;
begin
  if self.Count = 0 then
    raise new SugarInvalidOperationException("Queue is empty");

  {$IF COOPER}
  exit mapped.poll;
  {$ELSEIF ECHOES}
  exit mapped.Dequeue;
  {$ELSEIF NOUGAT}
  result := mapped.objectAtIndex(0);
  mapped.removeObjectAtIndex(0);
  {$ENDIF}
end;

method Queue<T>.Enqueue(Item: T);
begin
  if Item = nil then
    raise new SugarArgumentNullException("Item");

  {$IF COOPER}
  mapped.add(Item);
  {$ELSEIF ECHOES}
  mapped.Enqueue(Item);
  {$ELSEIF NOUGAT}
  mapped.addObject(Item);
  {$ENDIF}
end;

method Queue<T>.ForEach(Action: Action<T>);
begin
  if Action = nil then
    raise new SugarArgumentNullException("Action");

  var Items := ToArray;
  for i: Integer := 0 to length(Items) - 1 do
    Action(Items[i]);
end;

method Queue<T>.Peek: T;
begin
  if self.Count = 0 then
    raise new SugarInvalidOperationException("Queue is empty");

  {$IF COOPER OR ECHOES}
  exit mapped.Peek;
  {$ELSEIF NOUGAT}
  exit mapped.objectAtIndex(0);
  {$ENDIF}
end;

method Queue<T>.ToArray: array of T;
begin
  {$IF COOPER}
  exit mapped.toArray(new T[0]);
  {$ELSEIF ECHOES}
  exit mapped.ToArray;
  {$ELSEIF NOUGAT}
  result := new T[mapped.count];
  for i: Integer := 0 to mapped.count - 1 do
    result[i] := mapped.objectAtIndex(i);
  {$ENDIF}
end;

end.

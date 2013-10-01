namespace RemObjects.Oxygene.Sugar.Collections;

{$HIDE W0} //supress case-mismatch errors

interface

type
  {$IF ECHOES OR COOPER}
  Queue<T> = public class mapped to {$IF ECHOES}System.Collections.Generic.Queue<T>{$ELSE}java.util.LinkedList<T>{$ENDIF}
  public
    method Contains(Item: T): Boolean; mapped to Contains(Item);
    method Clear; mapped to Clear;

    method Peek: T; {$IF ECHOES}mapped to Peek;{$ENDIF}    
    method Enqueue(Item: T);
    method Dequeue: T; {$IF ECHOES}mapped to Dequeue;{$ENDIF}
    method ToArray: array of T; {$IF ECHOES}mapped to ToArray;{$ENDIF}

    property Count: Integer read {$IF ECHOES}mapped.Count{$ELSE}mapped.size{$ENDIF};
  end;
  {$ELSEIF NOUGAT}  
  Queue<T> = public class mapped to Foundation.NSMutableArray
  public
    method Contains(Item: T): Boolean; mapped to containsObject(Item);
    method Clear; mapped to removeAllObjects;

    method Peek: T; mapped to objectAtIndex(0);
    method Enqueue(Item: T); mapped to addObject(Item);
    method Dequeue: T;
    method ToArray: array of T;

    property Count: Integer read mapped.count;
  end;
  {$ENDIF}

implementation

{$IF COOPER}
method Queue<T>.ToArray: array of T;
begin
  exit mapped.toArray(new T[0]);
end;

method Queue<T>.Enqueue(Item: T);
begin
  if Item = nil then
    raise new RemObjects.Oxygene.Sugar.SugarArgumentNullException("Item");

  mapped.add(Item);
end;

method Queue<T>.Dequeue: T;
begin
  if mapped.size = 0 then
    raise new RemObjects.Oxygene.Sugar.SugarInvalidOperationException("Queue is empty");

  exit mapped.poll;
end;

method Queue<T>.Peek: T;
begin
  if mapped.size = 0 then
    raise new RemObjects.Oxygene.Sugar.SugarInvalidOperationException("Queue is empty");

  exit mapped.peek;
end;
{$ELSEIF ECHOES}
method Queue<T>.Enqueue(Item: T);
begin
  if Item = nil then
    raise new RemObjects.Oxygene.Sugar.SugarArgumentNullException("Item");

  mapped.Enqueue(Item);
end;
{$ELSEIF NOUGAT}
method Queue<T>.Dequeue: T;
begin
  result := mapped.objectAtIndex(0);
  mapped.removeObjectAtIndex(0);
end;

method Queue<T>.ToArray: array of T;
begin
  result := new T[mapped.count];
  for i: Integer := 0 to mapped.count - 1 do
    result[i] := mapped.objectAtIndex(i);
end;
{$ENDIF}

end.

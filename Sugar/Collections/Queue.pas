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

    property Count: Integer read {$IF COOPER}mapped.size{$ELSEIF ECHOES OR NOUGAT}mapped.Count{$ENDIF};
  end;

implementation

method Queue<T>.Contains(Item: T): Boolean;
begin
  {$IF COOPER OR ECHOES}
  exit mapped.Contains(Item);
  {$ELSEIF NOUGAT}
  exit mapped.containsObject(NullHelper.ValueOf(Item));
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
  {$IF COOPER}
  if self.Count = 0 then
    raise new SugarInvalidOperationException(ErrorMessage.COLLECTION_EMPTY);
  exit mapped.poll;
  {$ELSEIF ECHOES}
  exit mapped.Dequeue;
  {$ELSEIF NOUGAT}
  if self.Count = 0 then
    raise new SugarInvalidOperationException(ErrorMessage.COLLECTION_EMPTY);
  result := NullHelper.ValueOf(mapped.objectAtIndex(0));
  mapped.removeObjectAtIndex(0);
  {$ENDIF}
end;

method Queue<T>.Enqueue(Item: T);
begin
  {$IF COOPER}
  mapped.add(Item);
  {$ELSEIF ECHOES}
  mapped.Enqueue(Item);
  {$ELSEIF NOUGAT}
  mapped.addObject(NullHelper.ValueOf(Item));
  {$ENDIF}
end;

method Queue<T>.Peek: T;
begin
  {$IF COOPER OR ECHOES}
  {$IFDEF COOPER}
  if self.Count = 0 then
    raise new SugarInvalidOperationException(ErrorMessage.COLLECTION_EMPTY);
    {$ENDIF}
  exit mapped.Peek;
  {$ELSEIF NOUGAT}
  if self.Count = 0 then
    raise new SugarInvalidOperationException(ErrorMessage.COLLECTION_EMPTY);
  exit NullHelper.ValueOf(mapped.objectAtIndex(0));
  {$ENDIF}
end;

method Queue<T>.ToArray: array of T;
begin
  {$IF COOPER}
  exit mapped.toArray(new T[0]);
  {$ELSEIF ECHOES}
  exit mapped.ToArray;
  {$ELSEIF NOUGAT}
  exit ListHelpers.ToArray<T>(self);
  {$ENDIF}
end;

end.

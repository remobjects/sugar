namespace Sugar.Collections;

interface

uses
  Sugar;

type
  Stack<T> = public class mapped to {$IF COOPER}java.util.Stack<T>{$ELSEIF ECHOES}System.Collections.Generic.Stack<T>{$ELSEIF NOUGAT}Foundation.NSMutableArray{$ENDIF}
  public
    constructor; mapped to constructor();

    method Contains(Item: T): Boolean;
    method Clear;
    method Peek: T;
    method Pop: T;
    method Push(Item: T);
    method ToArray: array of T;

    property Count: Integer read {$IF COOPER}mapped.size{$ELSEIF ECHOES OR NOUGAT}mapped.Count{$ENDIF};
  end;

implementation

method Stack<T>.Contains(Item: T): Boolean;
begin
  {$IF COOPER OR ECHOES}
  exit mapped.Contains(Item);
  {$ELSE}
  exit mapped.containsObject(NullHelper.ValueOf(Item));
  {$ENDIF}
end;

method Stack<T>.Clear;
begin
  {$IF COOPER OR ECHOES}
  mapped.Clear;
  {$ELSE}
  mapped.removeAllObjects;
  {$ENDIF}
end;


method Stack<T>.Peek: T;
begin
  {$IF COOPER OR ECHOES}
  exit mapped.Peek;
  {$ELSE}
  exit NullHelper.ValueOf(mapped.lastObject);
  {$ENDIF}
end;

method Stack<T>.Pop: T;
begin
  {$IF COOPER OR ECHOES}
  exit mapped.Pop;
  {$ELSE}
  result := NullHelper.ValueOf(mapped.lastObject);
  mapped.removeLastObject;
  {$ENDIF}
end;

method Stack<T>.Push(Item: T);
begin
  {$IF COOPER OR ECHOES}
  mapped.Push(Item);
  {$ELSE}
  mapped.addObject(NullHelper.ValueOf(Item));
  {$ENDIF}
end;

method Stack<T>.ToArray: array of T;
begin
  {$IF COOPER}
  exit ListHelpers.ToArrayReverse<T>(self, new T[Count]);
  {$ELSEIF ECHOES}
  exit mapped.ToArray;
  {$ELSEIF NOUGAT}
  exit ListHelpers.ToArrayReverse<T>(self);
  {$ENDIF}
end;

end.

namespace Sugar.Collections;

interface

uses
  Sugar;

type
  Stack<T> = public class mapped to {$IF COOPER}java.util.Stack<T>{$ELSEIF ECHOES}System.Collections.Generic.Stack<T>{$ELSEIF TOFFEE}Foundation.NSMutableArray{$ENDIF}
  public
    constructor; mapped to constructor();

    method Contains(Item: T): Boolean;
    method Clear;
    method Peek: T;
    method Pop: T;
    method Push(Item: T);
    method ToArray: array of T;

    property Count: Integer read {$IF COOPER}mapped.size{$ELSEIF ECHOES OR TOFFEE}mapped.Count{$ENDIF};
  end;
  {$IFDEF TOFFEE}
  StackHelpers = public static class
  private
  public
    method Peek<T>(aStack: Foundation.NSMutableArray): T;
    method Pop<T>(aStack: Foundation.NSMutableArray): T;
  end;
  {$ENDIF}

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
  exit StackHelpers.Peek<T>(mapped);
  {$ENDIF}
end;

method Stack<T>.Pop: T;
begin
  {$IF COOPER OR ECHOES}
  exit mapped.Pop;
  {$ELSE}
  exit StackHelpers.Pop<T>(mapped);
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
  {$ELSEIF TOFFEE}
  exit ListHelpers.ToArrayReverse<T>(self);
  {$ENDIF}
end;

{$IFDEF TOFFEE}
method StackHelpers.Peek<T>(aStack: Foundation.NSMutableArray): T;
begin
  var n := aStack.lastObject;
  if n = nil then raise new SugarInvalidOperationException(ErrorMessage.COLLECTION_EMPTY);
  exit NullHelper.ValueOf(n);
end;

method StackHelpers.Pop<T>(aStack: Foundation.NSMutableArray): T;
begin
  var n := aStack.lastObject;
  if n = nil then raise new SugarInvalidOperationException(ErrorMessage.COLLECTION_EMPTY);
  n := NullHelper.ValueOf(n);
  aStack.removeLastObject;
  exit n;
end;
{$ENDIF}

end.

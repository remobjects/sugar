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
    method ForEach(Action: Action<T>);

    property Count: Integer read {$IF COOPER}mapped.size{$ELSEIF ECHOES OR NOUGAT}mapped.Count{$ENDIF};
  end;

implementation

method Stack<T>.Contains(Item: T): Boolean;
begin
  {$IF COOPER OR ECHOES}
  exit mapped.Contains(Item);
  {$ELSE}
  exit mapped.containsObject(Item);
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

method Stack<T>.ForEach(Action: Action<T>);
begin
  if Action = nil then
    raise new SugarArgumentNullException("Action");

  var Items := ToArray;
  for i: Integer := 0 to length(Items) - 1 do
    Action(Items[i]);
end;

method Stack<T>.Peek: T;
begin
  if self.Count = 0 then
    raise new SugarStackEmptyException("Stack is empty");
  
  {$IF COOPER OR ECHOES}
  exit mapped.Peek;
  {$ELSE}
  exit mapped.lastObject;
  {$ENDIF}
end;

method Stack<T>.Pop: T;
begin
  if self.Count = 0 then
    raise new SugarStackEmptyException("Stack is empty");

  {$IF COOPER OR ECHOES}
  exit mapped.Pop;
  {$ELSE}
  result := mapped.lastObject;
  mapped.removeLastObject;
  {$ENDIF}
end;

method Stack<T>.Push(Item: T);
begin
  if Item = nil then
    raise new SugarArgumentNullException("Item");

  {$IF COOPER OR ECHOES}
  mapped.Push(Item);
  {$ELSE}
  mapped.addObject(Item);
  {$ENDIF}
end;

method Stack<T>.ToArray: array of T;
begin
  {$IF COOPER}
  result := mapped.toArray(new T[0]);

  for i: Integer := 0 to result.length div 2 do begin
    var temp := result[i];
    result[i] := result[result.length - 1 - i];
    result[result.length - 1 - i] := temp;
  end;
  {$ELSEIF ECHOES}
  exit mapped.ToArray;
  {$ELSEIF NOUGAT}
  result := new T[mapped.count];
  for i: Integer := mapped.Count - 1 downto 0 do
    result[mapped.count - i - 1] := mapped.objectAtIndex(i);
  {$ENDIF}
end;

end.

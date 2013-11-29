namespace RemObjects.Oxygene.Sugar.Collections;

{$HIDE W0} //supress case-mismatch errors

interface

uses
  RemObjects.Oxygene.Sugar;

type
  {$IF ECHOES OR COOPER}
  Stack<T> = public class mapped to {$IF ECHOES}System.Collections.Generic.Stack<T>{$ELSE}java.util.Stack<T>{$ENDIF}
  public
    constructor; mapped to constructor();

    method Contains(Item: T): Boolean; mapped to Contains(Item);
    method Clear; mapped to Clear;
    method Peek: T; mapped to Peek;
    method Pop: T; mapped to Pop;
    method Push(Item: T);
    method ToArray: array of T; {$IF ECHOES}mapped to ToArray;{$ENDIF}
    method ForEach(Action: Action<T>);

    property Count: Integer read {$IF ECHOES}mapped.Count{$ELSE}mapped.size{$ENDIF};
  end;
  {$ELSEIF NOUGAT}
  Stack<T> = public class mapped to Foundation.NSMutableArray
  public
    constructor; mapped to constructor();

    method Contains(Item: T): Boolean; mapped to containsObject(Item);
    method Clear; mapped to removeAllObjects;
    method Peek: T; 
    method Pop: T;
    method Push(Item: T); mapped to addObject(Item);
    method ToArray: array of T;
    method ForEach(Action: Action<T>);

    property Count: Integer read mapped.count;
  end;
  {$ENDIF}

implementation

{$IF COOPER OR ECHOES}
method Stack<T>.Push(Item: T);
begin
  if Item = nil then
    raise new RemObjects.Oxygene.Sugar.SugarArgumentNullException("Item");

  mapped.Push(Item);
end;
{$ENDIF}

{$IF COOPER}
method Stack<T>.ToArray: array of T;
begin  
  result := mapped.toArray(new T[0]);
  //reverse
  for i: Integer := 0 to result.length div 2 do begin
    var temp := result[i];
    result[i] := result[result.length - 1 - i];
    result[result.length - 1 - i] := temp;
  end;
end;
{$ELSEIF NOUGAT}
method Stack<T>.Pop: T;
begin
  if mapped.count = 0 then
    raise new SugarStackEmptyException("Stack is empty");

  result := mapped.lastObject;
  mapped.removeLastObject;
end;

method Stack<T>.Peek: T;
begin
  if mapped.count = 0 then
    raise new SugarStackEmptyException("Stack is empty");

  exit mapped.lastObject;
end;

method Stack<T>.ToArray: array of T;
begin
  result := new T[mapped.count];
  for i: Integer := mapped.Count - 1 downto 0 do
    result[mapped.count - i - 1] := mapped.objectAtIndex(i);
end;
{$ENDIF}

method Stack<T>.ForEach(Action: Action<T>);
begin
  if Action = nil then
    raise new SugarArgumentNullException("Action");

  var Items := ToArray;
  for i: Integer := 0 to length(Items) - 1 do
    Action(Items[i]);
end;

end.

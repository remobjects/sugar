namespace RemObjects.Oxygene.Sugar.Collections;

{$HIDE W0} //supress case-mismatch errors

interface

type
  HashSet<T> = public class mapped to {$IFDEF ECHOES}System.Collections.Generic.HashSet<T>{$ENDIF}{$IFDEF COOPER}java.util.HashSet<T>{$ENDIF}{$IFDEF NOUGAT}Foundation.NSMutableSet{$ENDIF}
  public
    constructor; mapped to constructor();

    method &Add(Item: T): Boolean;
    method Clear; mapped to {$IFNDEF NOUGAT}Clear{$ELSE}removeAllObjects{$ENDIF};
    method Contains(Item: T): Boolean; mapped to {$IFNDEF NOUGAT}Contains(Item){$ELSE}containsObject(Item){$ENDIF};
    method &Remove(Item: T): Boolean; {$IFNDEF NOUGAT}mapped to &Remove(Item);{$ENDIF} 

    property Count: Integer read {$IFNDEF COOPER}mapped.Count{$ELSE}mapped.size{$ENDIF};
  end;

implementation

{$IF COOPER OR ECHOES}
method HashSet<T>.Add(Item: T): Boolean;
begin
  if Item = nil then
    raise new RemObjects.Oxygene.Sugar.SugarArgumentNullException("Item");

  exit mapped.Add(Item);
end;
{$ELSEIF NOUGAT}
method HashSet<T>.Add(Item: T): Boolean;
begin
  var lSize := mapped.Count;
  mapped.addObject(Item);
  exit lSize < mapped.Count;
end;

method HashSet<T>.Remove(Item: T): Boolean;
begin
  if Item = nil then
    exit false;

  var lSize := mapped.Count;
  mapped.removeObject(Item);
  exit lSize > mapped.Count;  
end;
{$ENDIF}

end.

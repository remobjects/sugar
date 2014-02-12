namespace Sugar.Collections;

interface

type
  HashSet<T> = public class mapped to {$IF COOPER}java.util.HashSet<T>{$ELSEIF ECHOES}System.Collections.Generic.HashSet<T>{$ELSEIF NOUGAT}Foundation.NSMutableSet{$ENDIF}
  public
    constructor; mapped to constructor();

    method &Add(Item: T): Boolean;
    method Clear; mapped to {$IF COOPER OR ECHOES}Clear{$ELSE}removeAllObjects{$ENDIF};
    method Contains(Item: T): Boolean;
    method &Remove(Item: T): Boolean;

    property Count: Integer read {$IF ECHOES OR NOUGAT}mapped.Count{$ELSE}mapped.size{$ENDIF};
  end;

implementation

method HashSet<T>.&Add(Item: T): Boolean;
begin
  {$IF COOPER OR ECHOES}
  exit mapped.Add(Item);
  {$ELSEIF NOUGAT}
  var lSize := mapped.count;
  mapped.addObject(NullHelper.ValueOf(Item));
  exit lSize < mapped.count;
  {$ENDIF}
end;

method HashSet<T>.Contains(Item: T): Boolean;
begin
  {$IF COOPER OR ECHOES}
  exit mapped.Contains(Item);
  {$ELSEIF NOUGAT}
  exit mapped.containsObject(NullHelper.ValueOf(Item));
  {$ENDIF}
end;

method HashSet<T>.&Remove(Item: T): Boolean;
begin
  {$IF COOPER OR ECHOES}
  exit mapped.Remove(Item);
  {$ELSEIF NOUGAT}
  var lSize := mapped.count;
  mapped.removeObject(NullHelper.ValueOf(Item));
  exit lSize > mapped.count;
  {$ENDIF}
end;

end.

namespace RemObjects.Oxygene.Sugar.Collections;

{$HIDE W0} //supress case-mismatch errors

interface

type
  HashSet<T> = public class mapped to {$IFDEF ECHOES}System.Collections.Generic.HashSet<T>{$ENDIF}{$IFDEF COOPER}java.util.HashSet<T>{$ENDIF}{$IFDEF NOUGAT}Foundation.NSMutableSet{$ENDIF}
  public
    method &Add(Item: T); mapped to {$IFNDEF NOUGAT}&Add(Item){$ELSE}addObject(Item){$ENDIF};
    method Clear; mapped to {$IFNDEF NOUGAT}Clear{$ELSE}removeAllObjects{$ENDIF};
    method Contains(Item: T): Boolean; mapped to {$IFNDEF NOUGAT}Contains(Item){$ELSE}containsObject(Item){$ENDIF};
    method &Remove(Item: T); mapped to {$IFNDEF NOUGAT}&Remove(Item){$ELSE}removeObject(Item){$ENDIF}; 

    property Count: Integer read {$IFNDEF COOPER}mapped.Count{$ELSE}mapped.size{$ENDIF};
  end;

implementation

end.

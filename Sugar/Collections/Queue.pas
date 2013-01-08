namespace RemObjects.Oxygene.Sugar.Collections;

{$HIDE W0} //supress case-mismatch errors

interface

type
  {$IF ECHOES OR COOPER}
  Queue<T> = public class mapped to {$IF ECHOES}System.Collections.Generic.Queue<T>{$ELSE}java.util.LinkedList<T>{$ENDIF}
  public
    method Contains(Item: T): Boolean; mapped to Contains(Item);
    method Clear; mapped to Clear;

    method Peek: T; mapped to Peek;    
    method Enqueue(Item: T); mapped to {$IF ECHOES}Enqueue(Item){$ELSE}add(Item){$ENDIF};
    method Dequeue: T; mapped to {$IF ECHOES}Dequeue{$ELSE}poll{$ENDIF};    

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

    property Count: Integer read mapped.count;
  end;
  {$ENDIF}

implementation

{$IF NOUGAT}
method Queue<T>.Dequeue: T;
begin
  result := mapped.objectAtIndex(0);
  mapped.removeObjectAtIndex(0);
end;
{$ENDIF}

end.

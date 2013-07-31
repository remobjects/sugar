namespace RemObjects.Oxygene.Sugar.Test;

interface

type
  {$IF ECHOES}
  List<T> = public class mapped to System.Collections.Generic.List<T>
  public
    method &Add(Item: T); mapped to &Add(Item);
    method AddRange(Items: List<T>); mapped to AddRange(Items);
    method ToArray: array of T; mapped to ToArray;
    property Count: Integer read mapped.Count;
    property Item[i: Integer]: T read mapped[i] write mapped[i]; default;
  end;
  {$ELSEIF COOPER}
  List<T> = public class mapped to java.util.ArrayList<T>
  public
    method &Add(Item: T); mapped to &add(Item);
    method AddRange(Items: List<T>); mapped to addAll(Items);
    method ToArray: array of T; mapped to toArray;
    property Count: Integer read mapped.size;
    property Item[i: Integer]: T read mapped[i] write mapped[i]; default;
  end;
  {$ELSEIF NOUGAT}
  List<T> = public class mapped to Foundation.NSMutableArray
    where T is class;
  public
    method &Add(Item: T); mapped to addObject(Item);
    method AddRange(Items: List<T>); mapped to addObjectsFromArray(Items);
    method ToArray: array of T;
    property Count: Integer read mapped.count;
    property Item[i: Integer]: T read mapped[i] write mapped[i]; default;
  end;
  {$ENDIF}

implementation

{$IF NOUGAT}
method List<T>.ToArray: array of T;
begin
  result := new T[mapped.count];
  for i: Integer := 0 to mapped.count - 1 do
    result := mapped.objectAtIndex(i);
end;
{$ENDIF}

end.

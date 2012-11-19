namespace RemObjects.Oxygene.Sugar;

{$HIDE W0} //supress case-mismatch errors
{$HIDE W27}

interface

{$IF NOT NOUGAT}

type
  Dictionary<T, U> = public class mapped to {$IF ECHOES}System.Collections.Generic.Dictionary<T,U>{$ENDIF}{$IF COOPER}java.util.HashMap<T,U>{$ENDIF}{$IF NOUGAT}Foundation.NSMutableDictionary{$ENDIF}
  public
    method &Add(Key: T; Value: U); mapped to {$IF ECHOES}Add(Key, Value){$ENDIF}{$IF COOPER}Put(Key, Value){$ENDIF}{$IF NOUGAT}setObject(Key, Value){$ENDIF};
    method Clear; mapped to {$IFNDEF NOUGAT}Clear{$ELSE}removeAllObjects{$ENDIF};
    method ContainsKey(Key: T): Boolean; mapped to {$IFNDEF NOUGAT}ContainsKey(Key){$ENDIF};
    method ContainsValue(Value: U): Boolean; mapped to {$IFNDEF NOUGAT}ContainsValue(Value){$ENDIF};
    method &Remove(Key: T); mapped to {$IFNDEF NOUGAT}&Remove(Key){$ENDIF};

    property Item[Key: T]: U {$IFNDEF NOUGAT}read mapped[Key] write mapped[Key]{$ELSE}{$ENDIF}; default;
    property Keys: sequence of T read {$IF ECHOES}mapped.Keys{$ENDIF}{$IF COOPER}mapped.keySet{$ENDIF};
    property Values: sequence of U read {$IFNDEF NOUGAT}mapped.Values{$ELSE}{$ENDIF};
    property Count: Integer read {$IF ECHOES OR NOUGAT}mapped.Count{$ENDIF}{$IF COOPER}mapped.size{$ENDIF};
  end;
{$ENDIF}  
implementation
end.

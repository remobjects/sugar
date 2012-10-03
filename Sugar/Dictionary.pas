namespace RemObjects.Oxygene.Sugar;

interface

type
  {$IFDEF COOPER}
  Dictionary<T, U> = public class mapped to java.util.Dictionary<T, U>
    //method __getKeys: sequence of T; iterator;
    property Values[aKey: T]: U read mapped.get(aKey) write mapped.put;
    property AllKeys: sequence of T read new EnumerationSequence<T>(mapped.keys);
    method ContainsKey(aKey: T): Boolean;
  end;
  {$ENDIF}

  {$IFDEF ECHOES}
  Dictionary<T, U> = public class mapped to System.Collections.Generic.Dictionary<T, U>
    property Values[aKey: T]: U read mapped[aKey] write mapped[aKey];
    property AllKeys: sequence of T read mapped.Keys;
    method ContainsKey(aKey: T): Boolean; mapped to ContainsKey(aKey);
  end;
  {$ENDIF}

  {$IFDEF NOUGAT}
  Dictionary<T,U> = public class mapped to Foundation.NSMutableDictionary
    method getValue(aKey: dynamic): dynamic; mapped to objectForKey(aKey);
    method setValue(aKey: dynamic; aValue: dynamic): dynamic; mapped to setObject(aValue)forKey(aKey);
    property Values[aKey: T]: U read getValue write setValue;
  end;
  {$ENDIF}
  
implementation

{$IFDEF COOPER}
method Dictionary.ContainsKey(aKey: T): Boolean;
begin
  result := assigned(mapped.get(aKey));
end;

{method Dictionary.__getKeys: sequence of T;
begin
  var k := mapped.keys;
  while k.hasMoreElements() do
    yield k.nextElement();
end;}
{$ENDIF}

end.

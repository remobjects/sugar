namespace RemObjects.Sugar;

interface

type
  {$IFDEF COOPER}
  Dictionary<T, U> = public class mapped to java.util.Dictionary<T, U>
  {$ENDIF}
  {$IFDEF ECHOES}
  Dictionary<T, U> = public class mapped to System.Collections.Generic.Dictionary<T, U>
  {$ENDIF}
  {$IFDEF NOUGAT}
  Dictionary<T,U> = public class mapped to Foundation.NSDictionary
  {$ENDIF}
    {$IFDEF COOPER}
    //method __getKeys: sequence of T; iterator;
    property Values[aKey: T]: U read mapped.get(aKey) write mapped.put;
    property AllKeys: sequence of T read new EnumerationSequence<T>(mapped.keys);
    method ContainsKey(aKey: T): Boolean;
    {$ENDIF}
    {$IFDEF ECHOES}
    property Values[aKey: T]: U read mapped[aKey] write mapped[aKey];
    property AllKeys: sequence of T read mapped.Keys;
    method ContainsKey(aKey: T): Boolean; mapped to ContainsKey(aKey);
    {$ENDIF}
    {$IFDEF NOUGAT}
    method getValue(aKey: dynamic): dynamic; mapped to valueForKey;
    method setValue(aKey: dynamic; aValue: dynamic): dynamic; mapped to setValue(aValue)forKey(aKey);
    property Values[aKey: T]: U read getValue write setValue;
    {$ENDIF}
 end;
  
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

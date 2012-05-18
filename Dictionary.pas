namespace RemObjects.Sugar;

interface

type
  {$IFDEF COOPER}
  List<T> = public class mapped to java.util.ArrayList
  {$ENDIF}
  {$IFDEF ECHOES}
  List<T> = public class mapped to System.Collections.Generic.List<T>
  {$ENDIF}
  {$IFDEF NOUGAT}
  List<T> = public class mapped to NSArray
  {$ENDIF}
  end;

  {$IFDEF COOPER}
  EnumerationSequence<T> = public class(sequence of T)
  private
    fEnumeration: java.util.Enumeration<T>;
  assembly
    constructor(aEnumeration: java.util.Enumeration<T>);
  public
     method &iterator: java.util.&Iterator<T>; iterator;
  end;
  {$ENDIF}

  {$IFDEF COOPER}
  Dictionary<T, U> = public class mapped to java.util.Dictionary<T, U>
  {$ENDIF}
  {$IFDEF ECHOES}
  Dictionary<T, U> = public class mapped to System.Collections.Generic.Dictionary<T, U>
  {$ENDIF}
  {$IFDEF NOUGAT}
  Dictionary<T,U> = public class mapped to NSDictionary
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

constructor EnumerationSequence<T>(aEnumeration: java.util.Enumeration<T>);
begin
  fEnumeration := aEnumeration;
end;

method EnumerationSequence<T>.&iterator: java.util.&Iterator<T>;
begin
  while fEnumeration.hasMoreElements do yield fEnumeration.nextElement;
end;

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

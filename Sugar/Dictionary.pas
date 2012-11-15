namespace RemObjects.Oxygene.Sugar;

interface

type
  {$IF COOPER}
  Dictionary<T, U> = public class mapped to java.util.Dictionary<T, U>
    //method __getKeys: sequence of T; iterator;
    property Values[aKey: T]: U read mapped.get(aKey) write mapped.put;
    property AllKeys: sequence of T read new EnumerationSequence<T>(mapped.keys);
    method ContainsKey(aKey: T): Boolean;
  end;
  {$ENDIF}

  {$IF ECHOES}
  Dictionary<T, U> = public class mapped to System.Collections.Generic.Dictionary<T, U>
    property Values[aKey: T]: U read mapped[aKey] write mapped[aKey];
    property AllKeys: sequence of T read mapped.Keys;
    method ContainsKey(aKey: T): Boolean; mapped to ContainsKey(aKey);
  end;
  {$ENDIF}

  {$IF NOUGAT}
  Dictionary<T,U> = public class mapped to Foundation.NSMutableDictionary
  //where T is class, U is class
  private
    method getValue(aKey: dynamic): dynamic; mapped to objectForKey(aKey);
    method setValue(aKey: dynamic; aValue: dynamic); mapped to setObject(aValue)forKey(aKey);
  public
    //property Values[aKey: dynamic{T}]: dynamic{U} read getValue write setValue;
    method ContainsKey(aKey: T): Boolean; 
  end;
  {$ENDIF}
  
implementation

{$IF COOPER}
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

{$IF NOUGAT}
method Dictionary.ContainsKey(aKey: T): Boolean; 
begin
  //result := assigned(mapped.objectForKey(T));
end;
{$ENDIF}

end.

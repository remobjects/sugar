namespace RemObjects.Oxygene.Sugar.Collections;

{$HIDE W0} //supress case-mismatch errors

interface

uses
  {$IF ECHOES}System.Linq,{$ENDIF}
  RemObjects.Oxygene.Sugar;

type
  KeyValue<T, U> = public class {$IF NOUGAT}mapped to KeyValue where T is class, T is INSCopying, U is class;{$ENDIF}
  public
    {$IF NOT NOUGAT}
    constructor(aKey: T; aValue: U);
    method &Equals(Obj: Object): Boolean; override;    
    method {$IF COOPER}ToString: java.lang.String{$ELSEIF ECHOES}ToString: System.String{$ENDIF}; override;
    method {$IF COOPER}hashCode: Integer{$ELSEIF ECHOES}GetHashCode: Integer{$ENDIF}; override;
    {$ENDIF}

    property Key: T {$IF NOUGAT}read mapped.Key;{$ELSE}read write; readonly;{$ENDIF}
    property Value: U {$IF NOUGAT}read mapped.Value;{$ELSE}read write; readonly;{$ENDIF}
  end;

  {$IF NOUGAT}
  KeyValue = public class
  public
    constructor(aKey: id; aValue: id);
    method isEqual(obj: id): Boolean; override;
    method description: Foundation.NSString; override;
    method hash: Foundation.NSUInteger; override;

    property Key: id read write; readonly;
    property Value: id read write; readonly;
  end;
  {$ENDIF}

{$IF ECHOES}
  Dictionary<T, U> = public class mapped to System.Collections.Generic.Dictionary<T,U>
  private
    method GetKeys: array of T;
    method GetValues: array of U;
    method SetItem(Key: T; Value: U);
  public
    method &Add(Key: T; Value: U);
    method Clear; mapped to Clear;
    method ContainsKey(Key: T): Boolean; mapped to ContainsKey(Key);
    method ContainsValue(Value: U): Boolean;
    method &Remove(Key: T): Boolean; mapped to &Remove(Key);

    method ForEach(Action: Action<KeyValue<T,U>>);

    property Item[Key: T]: U read mapped[Key] write SetItem; default;
    property Keys: array of T read GetKeys;
    property Values: array of U read GetValues;
    property Count: Integer read mapped.Count;
  end;

  ArrayHelper = public static class
  public
    method ToArray<T>(Value: System.Collections.Generic.IEnumerable<T>): array of T;
  end;
{$ELSEIF COOPER}
  Dictionary<T, U> = public class mapped to java.util.HashMap<T,U>
  private
    method GetKeys: array of T;
    method GetValues: array of U;
    method GetItem(Key: T): U;
    method SetItem(Key: T; Value: U);
  public
    method &Add(Key: T; Value: U);
    method Clear; mapped to clear;
    method ContainsKey(Key: T): Boolean;
    method ContainsValue(Value: U): Boolean;
    method &Remove(Key: T): Boolean;

    method ForEach(Action: Action<KeyValue<T,U>>);

    property Item[Key: T]: U read GetItem write SetItem; default;
    property Keys: array of T read GetKeys;
    property Values: array of U read GetValues;
    property Count: Integer read mapped.size;
  end;
{$ELSEIF NOUGAT}
  Dictionary<T, U> = public class mapped to Foundation.NSMutableDictionary
    where T is class, T is INSCopying, U is class;
  private
    method GetItem(Key: T): U;   
    method SetItem(Key: T; Value: U);
    method GetKeys: array of T;
    method GetValues: array of U;
  public
    method &Add(Key: T; Value: U);
    method Clear; mapped to removeAllObjects;
    method ContainsKey(Key: T): Boolean;
    method ContainsValue(Value: U): Boolean;
    method &Remove(Key: T): Boolean;

    method ForEach(Action: Action<KeyValue<T,U>>);

    property Item[Key: T]: U read GetItem write SetItem; default;
    // 61584: Nougat: Support for "sequence of"
    property Keys: array of T read GetKeys;
    property Values: array of U read GetValues;
    property Count: Integer read mapped.count;
  end;
{$ENDIF}

implementation

{$IF NOT NOUGAT}
constructor KeyValue<T,U>(aKey: T; aValue: U);
begin
  if aKey = nil then
    raise new SugarArgumentNullException("Key");

  if aValue = nil then
    raise new SugarArgumentNullException("Value");

  Key := aKey;
  Value := aValue;  
end;

method KeyValue<T, U>.&Equals(Obj: Object): Boolean;
begin
  if Obj = nil then
    exit false;

  if not (Obj is KeyValue<T,U>) then
    exit false;

  var Item := KeyValue<T, U>(Obj);
  exit Key.Equals(Item.Key) and Value.Equals(Item.Value);
end;

method KeyValue<T, U>.{$IF COOPER}hashCode: Integer{$ELSEIF ECHOES}GetHashCode: Integer{$ENDIF};
begin
  exit Key.GetHashCode + Value.GetHashCode;
end;

method KeyValue<T, U>.ToString: {$IF COOPER}java.lang.String{$ELSEIF ECHOES}System.String{$ENDIF};
begin
  exit String.Format("Key: {0} Value: {1}", Key, Value);
end;
{$ENDIF}

{$IF COOPER}
method Dictionary<T, U>.&Add(Key: T; Value: U);
begin
  if Key = nil then
    raise new SugarArgumentNullException("Key");

  if Value = nil then
    raise new SugarArgumentNullException("Value");

  if mapped.containsKey(Key) then
    raise new SugarArgumentException("An element with the same key already exists in the dictionary");

  mapped.put(Key, Value);
end;

method Dictionary<T, U>.&Remove(Key: T): Boolean;
begin
  if Key = nil then
    raise new SugarArgumentNullException("Key");

  exit mapped.remove(Key) <> nil;
end;

method Dictionary<T, U>.GetKeys: array of T;
begin
  exit mapped.keySet.toArray(new T[0]);
end;

method Dictionary<T, U>.GetValues: array of U;
begin
  exit mapped.values.toArray(new U[0]);
end;

method Dictionary<T, U>.GetItem(Key: T): U;
begin
  result := mapped[Key];

  if result = nil then
    raise new SugarKeyNotFoundException("Entry with specified key does not exist");
end;

method Dictionary<T, U>.SetItem(Key: T; Value: U);
begin
  if Key = nil then
    raise new SugarArgumentNullException("Key");

  if Value = nil then
    raise new SugarArgumentNullException("Value");

  mapped[Key] := Value;
end;

method Dictionary<T, U>.ContainsKey(Key: T): Boolean;
begin
  if Key = nil then
    raise new SugarArgumentNullException("Key");

  exit mapped.containsKey(Key);
end;

method Dictionary<T, U>.ContainsValue(Value: U): Boolean;
begin
  if Value = nil then
    raise new SugarArgumentNullException("Value");

  exit mapped.containsValue(Value);
end;
{$ELSEIF ECHOES}
method Dictionary<T, U>.GetKeys: array of T;
begin
  exit ArrayHelper.ToArray<T>(mapped.Keys);
end;

method Dictionary<T, U>.GetValues: array of U;
begin
  exit ArrayHelper.ToArray<U>(mapped.Values);
end;

method Dictionary<T, U>.&Add(Key: T; Value: U);
begin
  if Key = nil then
    raise new SugarArgumentNullException("Key");

  if Value = nil then
    raise new SugarArgumentNullException("Value");

  mapped.Add(Key, Value);
end;

method Dictionary<T, U>.ContainsValue(Value: U): Boolean;
begin
  if Value = nil then
    raise new SugarArgumentNullException("Value");

  exit mapped.ContainsValue(Value);
end;

method Dictionary<T, U>.SetItem(Key: T; Value: U);
begin
  if Key = nil then
    raise new SugarArgumentNullException("Key");

  if Value = nil then
    raise new SugarArgumentNullException("Value");

  mapped[Key] := Value;
end;

method ArrayHelper.ToArray<T>(Value: System.Collections.Generic.IEnumerable<T>): array of T;
begin
  exit Value.ToArray;
end;
{$ELSEIF NOUGAT}

{ KeyValue }

constructor KeyValue(aKey: id; aValue: id);
begin
  if aKey = nil then
    raise new SugarArgumentNullException("Key");

  if aValue = nil then
    raise new SugarArgumentNullException("Value");

  Key := aKey;
  Value := aValue;
end;

method KeyValue.isEqual(obj: id): Boolean;
begin
  if Obj = nil then
    exit false;

  if not (Obj is KeyValue) then
    exit false;

  var Item := KeyValue(Obj);
  exit Key.Equals(Item.Key) and Value.Equals(Item.Value);
end;

method KeyValue.description: Foundation.NSString;
begin
  exit String.Format("Key: {0} Value: {1}", Key.description, Value.description);
end;

method KeyValue.hash: Foundation.NSUInteger;
begin
  exit Key.hash + Value.hash;  
end;

{ Dictionary }

method Dictionary<T, U>.ContainsKey(Key: T): Boolean;
begin
  if Key = nil then
    raise new SugarArgumentNullException("Key");

  exit mapped.objectForKey(Key) <> nil;
end;

method Dictionary<T, U>.ContainsValue(Value: U): Boolean;
begin
  if Value = nil then
    raise new SugarArgumentNullException("Value");

  exit mapped.allValues.containsObject(Value);
end;

method Dictionary<T, U>.Remove(Key: T): Boolean;
begin
  result := ContainsKey(Key);
  if result then
    mapped.removeObjectForKey(Key);
end;

method Dictionary<T, U>.GetItem(Key: T): U;
begin
  result := mapped.objectForKey(Key);

  if result = nil then
    raise new SugarKeyNotFoundException("Entry with specified key does not exist");
end;

method Dictionary<T, U>.Add(Key: T; Value: U);
begin
  if Key = nil then
    raise new SugarArgumentNullException("Key");

  if Value = nil then
    raise new SugarArgumentNullException("Value");

  if mapped.objectForKey(Key) <> nil then
    raise new SugarArgumentException("An element with the same key already exists in the dictionary");

  mapped.setObject(Value) forKey(Key);
end;

method Dictionary<T, U>.SetItem(Key: T; Value: U);
begin
  mapped.setObject(Value) forKey(Key);
end;

method Dictionary<T,U>.GetKeys: array of T;
begin
  result := new T[mapped.allKeys.count];
  for i: Integer := 0 to mapped.allKeys.count - 1 do begin
    result[i] := mapped.allKeys.objectAtIndex(i);
  end;
end;

method Dictionary<T,U>.GetValues: array of U;
begin
  result := new U[mapped.allValues.count];
  for i: Integer := 0 to mapped.allValues.count - 1 do
    result[i] := mapped.allValues.objectAtIndex(i);
end;
{$ENDIF}

method Dictionary<T, U>.ForEach(Action: Action<KeyValue<T, U>>);
begin
  if Action = nil then
    raise new SugarArgumentNullException("Action");

  var lKeys := self.Keys;
  for i: Integer := 0 to length(lKeys) - 1 do
    Action(new KeyValue<T,U>(lKeys[i], self.Item[lKeys[i]]));
end;

end.

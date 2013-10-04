namespace RemObjects.Oxygene.Sugar.Collections;

{$HIDE W0} //supress case-mismatch errors

interface

uses
  {$IF ECHOES}System.Linq,{$ENDIF}
  RemObjects.Oxygene.Sugar;

type
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

    property Item[Key: T]: U read GetItem write SetItem; default;
    // 61584: Nougat: Support for "sequence of"
    property Keys: array of T read GetKeys;
    property Values: array of U read GetValues;
    property Count: Integer read mapped.count;
  end;
{$ENDIF}

implementation

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
end.

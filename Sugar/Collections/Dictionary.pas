namespace Sugar.Collections;

interface

uses
  {$IF ECHOES}System.Linq,{$ENDIF}
  Sugar;

type
  Dictionary<T, U> = public class mapped to {$IF COOPER}java.util.HashMap<T,U>{$ELSEIF ECHOES}System.Collections.Generic.Dictionary<T,U>{$ELSEIF NOUGAT}Foundation.NSMutableDictionary where T is class, U is class;{$ENDIF}
  private
    method GetKeys: array of T;
    method GetValues: array of U;
    method GetItem(Key: T): U;
    method SetItem(Key: T; Value: U);
  public
    constructor; mapped to constructor();
    {$IFNDEF ECHOES}
    method GetSequence: sequence of KeyValuePair<T,U>;
    {$ENDIF}
    method &Add(Key: T; Value: U);
    method Clear;
    method TryGetValue(aKey: T; out aValue: U): Boolean;
    method ContainsKey(Key: T): Boolean;
    method ContainsValue(Value: U): Boolean;
    method &Remove(Key: T): Boolean;

    method ForEach(Action: Action<KeyValuePair<T, U>>);

    property Item[Key: T]: U read GetItem write SetItem; default;
    property Keys: array of T read GetKeys;
    property Values: array of U read GetValues;
    property Count: Integer read {$IF COOPER}mapped.size{$ELSEIF ECHOES OR NOUGAT}mapped.Count{$ENDIF};
  end;

  DictionaryHelpers = public static class
  public
  {$IF ECHOES}
    method ToArray<T>(Value: System.Collections.Generic.IEnumerable<T>): array of T;
  {$ENDIF}
    {$IFDEF NOUGAT}
    method ToArray<T>(val: NSArray): array of T;
    {$ENDIF}
    {$IFDEF COOPER}
    method GetSequence<T, U>(aSelf: java.util.HashMap<T,U>) : sequence of KeyValuePair<T,U>; iterator;
    {$ELSEIF NOUGAT}
    method GetSequence<T, U>(aSelf: NSDictionary) : sequence of KeyValuePair<T,U>; iterator;
    {$ENDIF}
    method Foreach<T, U>(aSelf: Dictionary<T, U>; aAction: Action<KeyValuePair<T, U>>);
  end;

  

implementation

method Dictionary<T, U>.Add(Key: T; Value: U);
begin
  {$IF COOPER}
  mapped.put(Key, Value);
  {$ELSEIF ECHOES}
  mapped.Add(Key, Value);
  {$ELSEIF NOUGAT}
  mapped.setObject(NullHelper.ValueOf(Value)) forKey(Key);
  {$ENDIF}
end;

method Dictionary<T, U>.Clear;
begin
  {$IF COOPER OR ECHOES}
  mapped.Clear;
  {$ELSEIF NOUGAT}
  mapped.removeAllObjects;
  {$ENDIF}
end;

method Dictionary<T, U>.ContainsKey(Key: T): Boolean;
begin
  {$IF COOPER OR ECHOES}
  exit mapped.ContainsKey(Key);
  {$ELSEIF NOUGAT}
  exit mapped.objectForKey(Key) <> nil;
  {$ENDIF}
end;

method Dictionary<T, U>.ContainsValue(Value: U): Boolean;
begin
  {$IF COOPER OR ECHOES}
  exit mapped.ContainsValue(Value);
  {$ELSEIF NOUGAT}
  exit mapped.allValues.containsObject(NullHelper.ValueOf(Value));
  {$ENDIF}
end;

method Dictionary<T, U>.ForEach(Action: Action<KeyValuePair<T, U>>);
begin
  DictionaryHelpers.Foreach(self, Action);
end;

method Dictionary<T, U>.GetItem(Key: T): U;
begin
  {$IF COOPER}
  result := mapped[Key];
  {$ELSEIF ECHOES}
  result := mapped[Key];
  {$ELSEIF NOUGAT}
  exit NullHelper.ValueOf(mapped.objectForKey(Key));
  {$ENDIF}
end;

method Dictionary<T, U>.GetKeys: array of T;
begin
  {$IF COOPER}
  exit mapped.keySet.toArray(new T[0]);
  {$ELSEIF ECHOES}
  exit DictionaryHelpers.ToArray<T>(mapped.Keys);
  {$ELSEIF NOUGAT}
  exit DictionaryHelpers.ToArray<T>(mapped.allKeys);
  {$ENDIF}
end;

method Dictionary<T, U>.GetValues: array of U;
begin
  {$IF COOPER}
  exit mapped.values.toArray(new U[0]);
  {$ELSEIF ECHOES}
  exit DictionaryHelpers.ToArray<U>(mapped.Values);
  {$ELSEIF NOUGAT}
  exit DictionaryHelpers.ToArray<U>(mapped.allValues);
  {$ENDIF}
end;

method Dictionary<T, U>.&Remove(Key: T): Boolean;
begin
  {$IF COOPER}
  exit mapped.remove(Key) <> nil;
  {$ELSEIF ECHOES}
  exit mapped.Remove(Key);
  {$ELSEIF NOUGAT}
  result := ContainsKey(Key);
  if result then
    mapped.removeObjectForKey(Key);
  {$ENDIF}
end;

method Dictionary<T, U>.SetItem(Key: T; Value: U);
begin
  {$IF COOPER OR ECHOES}
  mapped[Key] := Value;
  {$ELSEIF NOUGAT}
  mapped.setObject(NullHelper.ValueOf(Value)) forKey(Key);
  {$ENDIF}
end;

{$IF ECHOES}
method DictionaryHelpers.ToArray<T>(Value: System.Collections.Generic.IEnumerable<T>): array of T;
begin
  exit Value.ToArray;
end;
{$ENDIF}

{$IFDEF NOUGAT}
method DictionaryHelpers.ToArray<T>(val: NSArray): array of T;
begin
  result := new T[val.count];
  for i: Integer := 0 to val.count - 1 do begin
    result[i] := val.objectAtIndex(i);
  end;
end;

method DictionaryHelpers.GetSequence<T, U>(aSelf: NSDictionary) : sequence of KeyValuePair<T,U>;
begin
   for each el in aSelf.allKeys do
    yield new KeyValuePair<T,U>(el, aSelf[el]);
end;
{$ENDIF}
{$IFDEF COOPER}
method DictionaryHelpers.GetSequence<T, U>(aSelf: java.util.HashMap<T,U>) : sequence of KeyValuePair<T,U>;
begin
  for each el in aSelf.entrySet do begin
    yield new KeyValue<T,U>(el.Key, el.Value);
  end;
end;
{$ENDIF}

method DictionaryHelpers.Foreach<T, U>(aSelf: Dictionary<T, U>; aAction: Action<KeyValuePair<T, U>>);
begin
  var lKeys := aself.Keys;
  for i: Integer := 0 to length(lKeys) - 1 do
    aAction(new KeyValuePair<T,U>(T(lKeys[i]), U(aSelf.Item[lKeys[i]])));
end;

method Dictionary<T, U>.TryGetValue(aKey: T; out aValue: U): Boolean;
begin
  {$IF ECHOES}
  exit mapped.TryGetValue(aKey, out aValue);
  {$ELSEIF COOPER}
  aValue := mapped[aKey];
  exit aValue <> nil;
  {$ELSEIF NOUGAT}
  aValue := mapped.objectForKey(aKey);
  exit aValue <> nil;
  {$ENDIF}
end;

{$IFNDEF ECHOES}
method Dictionary<T,U>.GetSequence: sequence of KeyValuePair<T,U>;
begin
  exit DictionaryHelpers.GetSequence<T, U>(self);
end;
{$ENDIF}
    


end.
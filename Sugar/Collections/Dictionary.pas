namespace Sugar.Collections;

interface

uses
  {$IF ECHOES}System.Linq,{$ENDIF}
  Sugar;

type
  Dictionary<T, U> = public class mapped to {$IF COOPER}java.util.HashMap<T,U>{$ELSEIF ECHOES}System.Collections.Generic.Dictionary<T,U>{$ELSEIF TOFFEE}Foundation.NSMutableDictionary where T is class, U is class;{$ENDIF}
  private
  public
    method GetKeys: sequence of T;
    method GetValues: sequence of U;
    method GetItem(Key: T): U;
    method SetItem(Key: T; Value: U);
    constructor; mapped to constructor();
    constructor(aCapacity: Integer);
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
    property Keys: sequence of T read GetKeys;
    property Values: sequence of U read GetValues;
    property Count: Integer read {$IF COOPER}mapped.size{$ELSEIF ECHOES OR TOFFEE}mapped.Count{$ENDIF};

    {$IF TOFFEE}
    operator Implicit(aDictionary: NSDictionary<T,U>): Dictionary<T,U>;
    {$ENDIF}
  end;

  DictionaryHelpers = public static class
  public
    {$IFDEF COOPER}
    method GetSequence<T, U>(aSelf: java.util.HashMap<T,U>) : sequence of KeyValuePair<T,U>; iterator;
    method GetItem<T, U>(aSelf: java.util.HashMap<T,U>; aKey: T): U;
    method Add<T, U>(aSelf: java.util.HashMap<T,U>; aKey: T; aVal: U);
    {$ELSEIF TOFFEE}
    method Add<T, U>(aSelf: NSMutableDictionary; aKey: T; aVal: U);
    method GetItem<T, U>(aSelf: NSDictionary; aKey: T): U;
    method GetSequence<T, U>(aSelf: NSDictionary) : sequence of KeyValuePair<T,U>; iterator;
    {$ENDIF}
    method Foreach<T, U>(aSelf: Dictionary<T, U>; aAction: Action<KeyValuePair<T, U>>);
  end;

  

implementation

constructor Dictionary<T,U>(aCapacity: Integer);
begin
  {$IF COOPER}
  result := new java.util.HashMap<T,U>(aCapacity);
  {$ELSEIF ECHOES}
  result := new System.Collections.Generic.Dictionary<T,U>(aCapacity); 
  {$ELSEIF TOFFEE}
  result := new Foundation.NSMutableDictionary withCapacity(aCapacity);
  {$ENDIF}
end;

method Dictionary<T, U>.Add(Key: T; Value: U);
begin
  {$IF COOPER}
  DictionaryHelpers.Add(mapped, Key, Value);
  {$ELSEIF ECHOES}
  mapped.Add(Key, Value);
  {$ELSEIF TOFFEE}
  DictionaryHelpers.Add(mapped, Key, Value);
  {$ENDIF}
end;

method Dictionary<T, U>.Clear;
begin
  {$IF COOPER OR ECHOES}
  mapped.Clear;
  {$ELSEIF TOFFEE}
  mapped.removeAllObjects;
  {$ENDIF}
end;

method Dictionary<T, U>.ContainsKey(Key: T): Boolean;
begin
  {$IF COOPER OR ECHOES}
  exit mapped.ContainsKey(Key);
  {$ELSEIF TOFFEE}
  exit mapped.objectForKey(Key) <> nil;
  {$ENDIF}
end;

method Dictionary<T, U>.ContainsValue(Value: U): Boolean;
begin
  {$IF COOPER OR ECHOES}
  exit mapped.ContainsValue(Value);
  {$ELSEIF TOFFEE}
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
  result := DictionaryHelpers.GetItem(mapped, Key);
  {$ELSEIF ECHOES}
  result := mapped[Key];
  {$ELSEIF TOFFEE}
  result := DictionaryHelpers.GetItem<T, U>(mapped, Key);
  {$ENDIF}
end;

method Dictionary<T, U>.GetKeys: sequence of T;
begin
  {$IF COOPER}
  exit mapped.keySet;
  {$ELSEIF ECHOES}
  exit mapped.Keys;
  {$ELSEIF TOFFEE}
  exit mapped.allKeys;
  {$ENDIF}
end;

method Dictionary<T, U>.GetValues: sequence of U;
begin
  {$IF COOPER}
  exit mapped.values;
  {$ELSEIF ECHOES}
  exit mapped.Values;
  {$ELSEIF TOFFEE}
  exit mapped.allValues;
  {$ENDIF}
end;

method Dictionary<T, U>.&Remove(Key: T): Boolean;
begin
  {$IF COOPER}
  exit mapped.remove(Key) <> nil;
  {$ELSEIF ECHOES}
  exit mapped.Remove(Key);
  {$ELSEIF TOFFEE}
  result := ContainsKey(Key);
  if result then
    mapped.removeObjectForKey(Key);
  {$ENDIF}
end;

method Dictionary<T, U>.SetItem(Key: T; Value: U);
begin
  {$IF COOPER OR ECHOES}
  mapped[Key] := Value;
  {$ELSEIF TOFFEE}
  mapped.setObject(NullHelper.ValueOf(Value)) forKey(Key);
  {$ENDIF}
end;

{$IFDEF TOFFEE}

method DictionaryHelpers.Add<T, U>(aSelf: NSMutableDictionary; aKey: T; aVal: U);
begin
  if aSelf.objectForKey(aKey) <> nil then raise new SugarArgumentException(ErrorMessage.KEY_EXISTS);
  aSelf.setObject(NullHelper.ValueOf(aVal)) forKey(aKey);
end;

method DictionaryHelpers.GetItem<T, U>(aSelf: NSDictionary; aKey: T): U;
begin
  var o := aSelf.objectForKey(aKey);
  if o = nil then raise new SugarKeyNotFoundException();
  exit NullHelper.ValueOf(o);
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

method DictionaryHelpers.GetItem<T, U>(aSelf: java.util.HashMap<T,U>; aKey: T): U;
begin 
  if not aSelf.containsKey(aKey) then raise new SugarKeyNotFoundException();
  exit aSelf[aKey];
end;
method DictionaryHelpers.Add<T, U>(aSelf: java.util.HashMap<T,U>; aKey: T; aVal: U);
begin
  if aSelf.containsKey(aKey) then raise new SugarArgumentException(ErrorMessage.KEY_EXISTS);
  aSelf.put(aKey, aVal)
end;

{$ENDIF}

method DictionaryHelpers.Foreach<T, U>(aSelf: Dictionary<T, U>; aAction: Action<KeyValuePair<T, U>>);
begin
  for each el in aSelf.Keys do 
    aAction(new KeyValuePair<T,U>(T(el), U(aSelf.Item[el])));
end;

method Dictionary<T, U>.TryGetValue(aKey: T; out aValue: U): Boolean;
begin
  {$IF ECHOES}
  exit mapped.TryGetValue(aKey, out aValue);
  {$ELSEIF COOPER}
  aValue := mapped[aKey];
  exit aValue <> nil;
  {$ELSEIF TOFFEE}
  aValue := mapped.objectForKey(aKey);
  result := aValue <> nil;
  aValue := NullHelper.ValueOf(aValue);
  {$ENDIF}
end;

{$IFNDEF ECHOES}
method Dictionary<T,U>.GetSequence: sequence of KeyValuePair<T,U>;
begin
  exit DictionaryHelpers.GetSequence<T, U>(self);
end;
{$ENDIF}
    
{$IF TOFFEE}
operator Dictionary<T,U>.Implicit(aDictionary: NSDictionary<T,U>): Dictionary<T,U>;
begin
  if aDictionary is NSMutableDictionary then
    result := Dictionary<T,U>(aDictionary)
  else
    result := Dictionary<T,U>(aDictionary:mutableCopy);
end;
{$ENDIF}

end.
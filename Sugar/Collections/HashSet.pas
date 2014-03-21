namespace Sugar.Collections;

interface

type
  HashSet<T> = public class mapped to {$IF COOPER}java.util.HashSet<T>{$ELSEIF ECHOES}System.Collections.Generic.HashSet<T>{$ELSEIF NOUGAT}Foundation.NSMutableSet{$ENDIF}
  public
    constructor; mapped to constructor();
    constructor(&Set: HashSet<T>);

    method &Add(Item: T): Boolean;
    method Clear; mapped to {$IF COOPER OR ECHOES}Clear{$ELSE}removeAllObjects{$ENDIF};
    method Contains(Item: T): Boolean;
    method &Remove(Item: T): Boolean;
    method ForEach(Action: Action<T>);

    method Intersect(&Set: HashSet<T>);
    method &Union(&Set: HashSet<T>);
    method IsSubsetOf(&Set: HashSet<T>): Boolean;
    method IsSupersetOf(&Set: HashSet<T>): Boolean;

    property Count: Integer read {$IF ECHOES OR NOUGAT}mapped.Count{$ELSE}mapped.size{$ENDIF};
  end;

  EnumeratorHelper<T> = public class
  private
    {$IF COOPER}
    fEnumerator: java.util.&Iterator<T>;
    fCurrent: T;
    {$ELSEIF ECHOES}
    fEnumerator: System.Collections.Generic.IEnumerator<T>;
    {$ELSEIF NOUGAT}  
    fEnumerator: NSEnumerator;
    fCurrent: T;
    {$ENDIF}
    method GetCurrent: T;
  public
    {$IF COOPER}
    constructor (Enumerator: Iterable<T>);
    {$ELSEIF ECHOES}
    constructor (Enumerator: System.Collections.Generic.IEnumerable<T>);
    {$ELSEIF NOUGAT}  
    constructor withEnumerator(Enumerator: NSEnumerator);
    constructor (Obj: id);
    {$ENDIF}

    method MoveNext: Boolean;
    property Current: T read GetCurrent;
  end;

implementation

{ EnumeratorHelper }

{$IF COOPER}
constructor EnumeratorHelper<T>(Enumerator: Iterable<T>);
begin
  Sugar.SugarArgumentNullException.RaiseIfNil(Enumerator, "Enumerator");
  fEnumerator := Enumerator.iterator;
end;
{$ELSEIF ECHOES}
constructor EnumeratorHelper<T>(Enumerator:System.Collections.Generic.IEnumerable<T>);
begin
  Sugar.SugarArgumentNullException.RaiseIfNil(Enumerator, "Enumerator");
  fEnumerator := Enumerator.GetEnumerator;
end;
{$ELSEIF NOUGAT}  
constructor EnumeratorHelper<T> withEnumerator(Enumerator: NSEnumerator);
begin
  Sugar.SugarArgumentNullException.RaiseIfNil(Enumerator, "Enumerator");
  fEnumerator := Enumerator;
end;

constructor EnumeratorHelper<T>(Obj: id);
begin
  Sugar.SugarArgumentNullException.RaiseIfNil(Obj, "Obj");  
  if Obj.respondsToSelector(selector(objectEnumerator)) then
    fEnumerator := Obj.objectEnumerator;
end;
{$ENDIF}

method EnumeratorHelper<T>.MoveNext: Boolean;
begin
  {$IF COOPER}
  if not fEnumerator.hasNext then
    exit false;

  fCurrent := fEnumerator.next;
  exit true;
  {$ELSEIF ECHOES}  
  exit fEnumerator.MoveNext;
  {$ELSEIF NOUGAT}  
  fCurrent := fEnumerator.nextObject;
  exit assigned(fCurrent);
  {$ENDIF}
end;

method EnumeratorHelper<T>.GetCurrent: T;
begin
  {$IF COOPER}
  exit fCurrent;
  {$ELSEIF ECHOES}
  exit fEnumerator.Current;
  {$ELSEIF NOUGAT}  
  if fCurrent = nil then
    exit nil;

  exit NullHelper.ValueOf(Item);
  {$ENDIF}
end;

{ HashSet }

constructor HashSet<T>(&Set: HashSet<T>);
begin
  if &Set = nil then
    raise new Sugar.SugarArgumentNullException("Set");
  
  {$IF COOPER}
  exit new java.util.HashSet<T>(&Set);
  {$ELSEIF ECHOES}
  exit new System.Collections.Generic.HashSet<T>(&Set);
  {$ELSEIF NOUGAT}  
  var NewSet := new Foundation.NSMutableSet();
  NewSet.setSet(&Set);
  exit NewSet;
  {$ENDIF}
end;

method HashSet<T>.&Add(Item: T): Boolean;
begin
  {$IF COOPER OR ECHOES}
  exit mapped.Add(Item);
  {$ELSEIF NOUGAT}
  var lSize := mapped.count;
  mapped.addObject(NullHelper.ValueOf(Item));
  exit lSize < mapped.count;
  {$ENDIF}
end;

method HashSet<T>.Contains(Item: T): Boolean;
begin
  {$IF COOPER OR ECHOES}
  exit mapped.Contains(Item);
  {$ELSEIF NOUGAT}
  exit mapped.containsObject(NullHelper.ValueOf(Item));
  {$ENDIF}
end;

method HashSet<T>.&Remove(Item: T): Boolean;
begin
  {$IF COOPER OR ECHOES}
  exit mapped.Remove(Item);
  {$ELSEIF NOUGAT}
  var lSize := mapped.count;
  mapped.removeObject(NullHelper.ValueOf(Item));
  exit lSize > mapped.count;
  {$ENDIF}
end;

method HashSet<T>.ForEach(Action: Action<T>);
begin
  if Action = nil then
    raise new Sugar.SugarArgumentNullException("Action");
  
  var Helper := new EnumeratorHelper<T>(mapped);

  while Helper.MoveNext do
    Action(Helper.Current);
end;

method HashSet<T>.Intersect(&Set: HashSet<T>);
begin
  if &Set = nil then
    raise new Sugar.SugarArgumentNullException("Set");
  
  {$IF COOPER}
  mapped.retainAll(&Set);
  {$ELSEIF ECHOES}
  mapped.IntersectWith(&Set);
  {$ELSEIF NOUGAT}  
  mapped.intersectSet(&Set);
  {$ENDIF}
end;

method HashSet<T>.&Union(&Set: HashSet<T>);
begin
  if &Set = nil then
    raise new Sugar.SugarArgumentNullException("Set");
  
  {$IF COOPER}
  mapped.addAll(&Set);
  {$ELSEIF ECHOES}
  mapped.UnionWith(&Set);
  {$ELSEIF NOUGAT}  
  mapped.unionSet(&Set);
  {$ENDIF}
end;

method HashSet<T>.IsSupersetOf(&Set: HashSet<T>): Boolean;
begin
  Sugar.SugarArgumentNullException.RaiseIfNil(&Set, "Set");
  
  if &Set.Count = 0 then
    exit true;

  if self.Count < &Set.Count then
    exit false;
  
  var Helper := new EnumeratorHelper<T>(&Set);

  while Helper.MoveNext do
    if not self.Contains(Helper.Current) then
      exit false;

  exit true;  
end;

method HashSet<T>.IsSubsetOf(&Set: HashSet<T>): Boolean;
begin
  Sugar.SugarArgumentNullException.RaiseIfNil(&Set, "Set");

  if self.Count = 0 then
    exit true;

  if self.Count > &Set.Count then
    exit false;

  var Helper := new EnumeratorHelper<T>(mapped);

  while Helper.MoveNext do
    if not &Set.Contains(Helper.Current) then
      exit false;

  exit true; 
end;

end.

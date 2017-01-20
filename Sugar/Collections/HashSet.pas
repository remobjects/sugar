namespace Sugar.Collections;

interface

type
  HashSet<T> = public class mapped to {$IF COOPER}java.util.HashSet<T>{$ELSEIF ECHOES}System.Collections.Generic.HashSet<T>{$ELSEIF TOFFEE}Foundation.NSMutableSet{$ENDIF}
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
    method SetEquals(&Set: HashSet<T>): Boolean;

    property Count: Integer read {$IF ECHOES OR TOFFEE}mapped.Count{$ELSE}mapped.size{$ENDIF};

    {$IF TOFFEE}
    operator Implicit(aSet: NSSet<T>): HashSet<T>;
    {$ENDIF}
  end;

  HashsetHelpers = public class
  private
  public
    class method Foreach<T>(aSelf: HashSet<T>; aAction: Action<T>);
    class method IsSubsetOf<T>(aSelf, aSet: HashSet<T>): Boolean;
  end;

implementation


{ HashSet }

constructor HashSet<T>(&Set: HashSet<T>);
begin
  {$IF COOPER}
  exit new java.util.HashSet<T>(&Set);
  {$ELSEIF ECHOES}
  exit new System.Collections.Generic.HashSet<T>(&Set);
  {$ELSEIF TOFFEE}
  var NewSet := new Foundation.NSMutableSet();
  NewSet.setSet(&Set);
  exit NewSet;
  {$ENDIF}
end;

method HashSet<T>.&Add(Item: T): Boolean;
begin
  {$IF COOPER OR ECHOES}
  exit mapped.Add(Item);
  {$ELSEIF TOFFEE}
  var lSize := mapped.count;
  mapped.addObject(NullHelper.ValueOf(Item));
  exit lSize < mapped.count;
  {$ENDIF}
end;

method HashSet<T>.Contains(Item: T): Boolean;
begin
  {$IF COOPER OR ECHOES}
  exit mapped.Contains(Item);
  {$ELSEIF TOFFEE}
  exit mapped.containsObject(NullHelper.ValueOf(Item));
  {$ENDIF}
end;

method HashSet<T>.&Remove(Item: T): Boolean;
begin
  {$IF COOPER OR ECHOES}
  exit mapped.Remove(Item);
  {$ELSEIF TOFFEE}
  var lSize := mapped.count;
  mapped.removeObject(NullHelper.ValueOf(Item));
  exit lSize > mapped.count;
  {$ENDIF}
end;

method HashSet<T>.ForEach(Action: Action<T>);
begin
  HashsetHelpers.Foreach(self, Action);
end;

method HashSet<T>.Intersect(&Set: HashSet<T>);
begin
  {$IF COOPER}
  mapped.retainAll(&Set);
  {$ELSEIF ECHOES}
  mapped.IntersectWith(&Set);
  {$ELSEIF TOFFEE}
  mapped.intersectSet(&Set);
  {$ENDIF}
end;

method HashSet<T>.&Union(&Set: HashSet<T>);
begin
  {$IF COOPER}
  mapped.addAll(&Set);
  {$ELSEIF ECHOES}
  mapped.UnionWith(&Set);
  {$ELSEIF TOFFEE}
  mapped.unionSet(&Set);
  {$ENDIF}
end;

method HashSet<T>.SetEquals(&Set: HashSet<T>): Boolean;
begin
  {$IF COOPER}
  exit mapped.equals(&Set);
  {$ELSEIF ECHOES}
  exit mapped.SetEquals(&Set);
  {$ELSEIF TOFFEE}
  exit mapped.isEqualToSet(&Set);
  {$ENDIF}
end;

method HashSet<T>.IsSupersetOf(&Set: HashSet<T>): Boolean;
begin
  exit HashsetHelpers.IsSubsetOf(&Set, self);
end;

method HashSet<T>.IsSubsetOf(&Set: HashSet<T>): Boolean;
begin
  exit HashsetHelpers.IsSubsetOf(self, &Set);
end;

{$IF TOFFEE}
operator HashSet<T>.Implicit(aSet: NSSet<T>): HashSet<T>;
begin
  if aSet is NSMutableArray then
    result := HashSet<T>(aSet)
  else
    result := HashSet<T>(aSet:mutableCopy);
end;
{$ENDIF}

{ HashsetHelpers }

class method HashsetHelpers.Foreach<T>(aSelf: HashSet<T>; aAction: Action<T>);
begin
  for each el in aSelf do
    aAction(el);
end;

class method HashsetHelpers.IsSubsetOf<T>(aSelf, aSet: HashSet<T>): Boolean;
begin
  if aSelf.Count = 0 then
    exit true;

  if aSelf.Count > aSet.Count then
    exit false;

  for each el in aSelf do
    if not aSet.Contains(el) then
      exit false;

  exit true;
end;

end.
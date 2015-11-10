namespace Sugar.Collections;

interface

uses
  {$IF ECHOES}
  System.Linq,
  {$ELSEIF COOPER}
  com.remobjects.elements.linq,
  {$ELSEIF NOUGAT}
  RemObjects.Elements.Linq,
  {$ENDIF}
  Sugar;

type  
  List<T> = public class (sequence of T) mapped to {$IF COOPER}java.util.ArrayList<T>{$ELSEIF ECHOES}System.Collections.Generic.List<T>{$ELSEIF NOUGAT}Foundation.NSMutableArray where T is class;{$ENDIF}
  private
    method SetItem(&Index: Integer; Value: T);
    method GetItem(&Index: Integer): T;
  public
    constructor; mapped to constructor();
    constructor(Items: List<T>);
    constructor(anArray: array of T);

    method &Add(anItem: T);
    method AddRange(Items: List<T>);
    method AddRange(Items: array of T);
    method Clear;
    method Contains(anItem: T): Boolean;

    method Exists(Match: Predicate<T>): Boolean;
    method FindIndex(Match: Predicate<T>): Integer;
    method FindIndex(StartIndex: Integer; Match: Predicate<T>): Integer;
    method FindIndex(StartIndex: Integer; aCount: Integer; Match: Predicate<T>): Integer;

    method Find(Match: Predicate<T>): T;
    method FindAll(Match: Predicate<T>): List<T>;
    method TrueForAll(Match: Predicate<T>): Boolean;
    method ForEach(Action: Action<T>);

    method IndexOf(anItem: T): Integer; 
    method Insert(&Index: Integer; anItem: T);
    method InsertRange(&Index: Integer; Items: List<T>);
    method InsertRange(&Index: Integer; Items: array of T);
    method LastIndexOf(anItem: T): Integer;

    method &Remove(anItem: T): Boolean;
    method RemoveAt(&Index: Integer);
    method RemoveRange(&Index: Integer; aCount: Integer);

    method Sort(Comparison: Comparison<T>);

    method ToArray: array of T;
    
    property Count: Integer read {$IF COOPER}mapped.Size{$ELSEIF ECHOES}mapped.Count{$ELSEIF NOUGAT}mapped.count{$ENDIF};
    property Item[i: Integer]: T read GetItem write SetItem; default;
  end;
  
  Predicate<T> = public block (Obj: T): Boolean;
  Action<T> = public block (Obj: T);
  Comparison<T> = public block (x: T; y: T): Integer;

  {$IF NOUGAT}
  NullHelper = public static class
  public
    method ValueOf(Value: id): id;
  end;
  {$ENDIF}

  ListHelpers = public static class
  public
    method AddRange<T>(aSelf: List<T>; aArr: array of T);
    method FindIndex<T>(aSelf: List<T>;StartIndex: Integer; aCount: Integer; Match: Predicate<T>): Integer;
    method Find<T>(aSelf: List<T>;Match: Predicate<T>): T;
    method ForEach<T>(aSelf: List<T>;Action: Action<T>);
    method TrueForAll<T>(aSelf: List<T>;Match: Predicate<T>): Boolean;
    method FindAll<T>(aSelf: List<T>;Match: Predicate<T>): List<T>;
    method InsertRange<T>(aSelf: List<T>; &Index: Integer; Items: array oF T);
    {$IFDEF NOUGAT}
    method LastIndexOf<T>(aSelf: NSArray; aItem: T): Integer;
    method ToArray<T>(aSelf: NSArray): array of T;
    method ToArrayReverse<T>(aSelf: NSArray): array of T;
    {$ENDIF}
    {$IFDEF COOPER}
    method ToArrayReverse<T>(aSelf: java.util.Vector<T>; aDest: array of T): array of T;

    {$ENDIF}
  end;

implementation

constructor List<T>(Items: List<T>);
begin
  {$IF COOPER}
  result := new java.util.ArrayList<T>(Items);
  {$ELSEIF ECHOES}
  exit new System.Collections.Generic.List<T>(Items);
  {$ELSEIF NOUGAT}
  result := new Foundation.NSMutableArray withArray(Items);
  {$ENDIF}
end;

constructor List<T>(anArray: array of T);
begin
  {$IF COOPER}
  result := new java.util.ArrayList<T>(java.util.Arrays.asList(anArray));
  {$ELSEIF ECHOES}
  exit new System.Collections.Generic.List<T>(anArray);
  {$ELSEIF NOUGAT}
  result := Foundation.NSMutableArray.arrayWithObjects(^id(@anArray[0])) count(length(anArray));
  {$ENDIF}
end;

method List<T>.Add(anItem: T);
begin
  {$IF COOPER OR ECHOES}
  mapped.Add(anItem);
  {$ELSEIF NOUGAT}
  mapped.addObject(NullHelper.ValueOf(anItem));
  {$ENDIF}
end;

method List<T>.SetItem(&Index: Integer; Value: T);
begin
  {$IF NOUGAT}
  mapped[&Index] := NullHelper.ValueOf(Value);
  {$ELSE}  
  mapped[&Index] := Value;
  {$ENDIF}
end;

method List<T>.GetItem(&Index: Integer): T;
begin
  {$IF NOUGAT}
  exit NullHelper.ValueOf(mapped.objectAtIndex(&Index));
  {$ELSE}  
  exit mapped[&Index];
  {$ENDIF}
end;

method List<T>.AddRange(Items: List<T>);
begin
  {$IF COOPER}
  mapped.AddAll(Items);
  {$ELSEIF ECHOES}
  mapped.AddRange(Items);
  {$ELSEIF NOUGAT}
  mapped.addObjectsFromArray(Items);
  {$ENDIF}
end;

method List<T>.AddRange(Items: array of T);
begin
  ListHelpers.AddRange(self, Items);
end;

method List<T>.Clear;
begin
  {$IF COOPER}
  mapped.Clear;
  {$ELSEIF ECHOES}
  mapped.Clear;
  {$ELSEIF NOUGAT}
  mapped.RemoveAllObjects;
  {$ENDIF}
end;

method List<T>.Contains(anItem: T): Boolean;
begin
  {$IF COOPER}
  exit mapped.Contains(anItem);
  {$ELSEIF ECHOES}
  exit mapped.Contains(anItem);
  {$ELSEIF NOUGAT}
  exit mapped.ContainsObject(NullHelper.ValueOf(anItem));
  {$ENDIF}
end;

method List<T>.Exists(Match: Predicate<T>): Boolean;
begin
  exit self.FindIndex(Match) <> -1;
end;

method List<T>.FindIndex(Match: Predicate<T>): Integer;
begin
  exit self.FindIndex(0, Count, Match);
end;

method List<T>.FindIndex(StartIndex: Integer; Match: Predicate<T>): Integer;
begin
  exit self.FindIndex(StartIndex, Count - StartIndex, Match);
end;

method List<T>.FindIndex(StartIndex: Integer; aCount: Integer; Match: Predicate<T>): Integer;
begin
  exit ListHelpers.FindIndex(self, StartIndex, aCount, Match);
end;

method List<T>.Find(Match: Predicate<T>): T;
begin
  exit ListHelpers.Find(self, Match);
end;

method List<T>.FindAll(Match: Predicate<T>): List<T>;
begin
  exit ListHelpers.FindAll(self, Match);
end;

method List<T>.TrueForAll(Match: Predicate<T>): Boolean;
begin
  exit ListHelpers.TrueForAll(self, Match);
end;

method List<T>.ForEach(Action: Action<T>);
begin
  ListHelpers.ForEach(self, Action);
end;

method List<T>.IndexOf(anItem: T): Integer;
begin
  {$IF COOPER}
  exit mapped.IndexOf(anItem);
  {$ELSEIF ECHOES}
  exit mapped.IndexOf(anItem);
  {$ELSEIF NOUGAT}
  var lIndex := mapped.indexOfObject(NullHelper.ValueOf(anItem));
  exit if lIndex = NSNotFound then -1 else Integer(lIndex);
  {$ENDIF}
end;

method List<T>.Insert(&Index: Integer; anItem: T);
begin
  {$IF COOPER}
  mapped.Add(&Index, anItem);
  {$ELSEIF ECHOES}
  mapped.Insert(&Index, anItem);
  {$ELSEIF NOUGAT}
  mapped.insertObject(NullHelper.ValueOf(anItem)) atIndex(&Index);
  {$ENDIF}
end;

method List<T>.InsertRange(&Index: Integer; Items: List<T>);
begin
  {$IF COOPER}
  mapped.AddAll(&Index, Items);
  {$ELSEIF ECHOES}
  mapped.InsertRange(&Index, Items);
  {$ELSEIF NOUGAT}
  mapped.insertObjects(Items) atIndexes(new NSIndexSet withIndexesInRange(NSMakeRange(&Index, Items.Count)));
  {$ENDIF}
end;

method List<T>.InsertRange(&Index: Integer; Items: array of T);
begin
  ListHelpers.InsertRange(self, &Index, Items);
end;

method List<T>.LastIndexOf(anItem: T): Integer;
begin  
  {$IF COOPER}
  exit mapped.LastIndexOf(anItem);
  {$ELSEIF ECHOES}
  exit mapped.LastIndexOf(anItem);
  {$ELSEIF NOUGAT}
  exit ListHelpers.LastIndexOf(self, anItem);
  {$ENDIF}
end;

method List<T>.Remove(anItem: T): Boolean;
begin
  {$IF COOPER}
  exit mapped.Remove(Object(anItem));
  {$ELSEIF ECHOES}
  exit mapped.Remove(anItem);
  {$ELSEIF NOUGAT}
  var lIndex := IndexOf(anItem);
  if lIndex <> -1 then begin
    RemoveAt(lIndex);
    exit true;
  end;
  
  exit false;
  {$ENDIF}
end;

method List<T>.RemoveAt(&Index: Integer);
begin
  {$IF COOPER}
  mapped.remove(&Index);
  {$ELSEIF ECHOES}
  mapped.RemoveAt(&Index);
  {$ELSEIF NOUGAT}
  mapped.removeObjectAtIndex(&Index);
  {$ENDIF}
end;

method List<T>.RemoveRange(&Index: Integer; aCount: Integer);
begin
  {$IF COOPER}
  mapped.subList(&Index, &Index+aCount).clear;
  {$ELSEIF ECHOES}
  mapped.RemoveRange(&Index, aCount);
  {$ELSEIF NOUGAT}
  mapped.removeObjectsInRange(Foundation.NSMakeRange(&Index, aCount));
  {$ENDIF}
end;

method List<T>.Sort(Comparison: Comparison<T>);
begin
  {$IF COOPER}  
  java.util.Collections.sort(mapped, new class java.util.Comparator<T>(compare := (x, y) -> Comparison(x, y)));
  {$ELSEIF ECHOES} 
  mapped.Sort((x, y) -> Comparison(x, y));
  {$ELSEIF NOUGAT}
  mapped.sortUsingComparator((x, y) -> begin
                                         var lResult := Comparison(x, y);
                                         exit if lResult < 0 then NSComparisonResult.NSOrderedAscending else if lResult = 0 then NSComparisonResult.NSOrderedSame else NSComparisonResult.NSOrderedDescending;
                                       end);
  {$ENDIF}
end;

method List<T>.ToArray: array of T;
begin
  {$IF COOPER}
  exit mapped.toArray(new T[0]);
  {$ELSEIF ECHOES}
  exit mapped.ToArray;
  {$ELSEIF NOUGAT}
  exit ListHelpers.ToArray<T>(self);
  {$ENDIF}
end;

{$IF NOUGAT}
class method NullHelper.ValueOf(Value: id): id;
begin
  exit if Value = NSNull.null then nil else if Value = nil then NSNull.null else Value;
end;
{$ENDIF}

method ListHelpers.AddRange<T>(aSelf: List<T>; aArr: array of T);
begin
  for i: Integer := 0 to length(aArr) - 1 do
    aself.Add(aArr[i]);
end;


method ListHelpers.FindIndex<T>(aSelf: List<T>;StartIndex: Integer; aCount: Integer; Match: Predicate<T>): Integer;
begin
  if StartIndex > aSelf.Count then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.ARG_OUT_OF_RANGE_ERROR, "StartIndex");

  if (aCount < 0) or (StartIndex > aSelf.Count - aCount) then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.ARG_OUT_OF_RANGE_ERROR, "Count");

  if Match = nil then
    raise new SugarArgumentNullException("Match");

  var Length := StartIndex + aCount; 

  for i: Int32 := StartIndex to Length - 1 do
    if Match(aSelf[i]) then
      exit i;

  exit -1;
end;


method ListHelpers.Find<T>(aSelf: List<T>; Match: Predicate<T>): T;
begin
  if Match = nil then
    raise new SugarArgumentNullException("Match");

  for i: Integer := 0 to aSelf.Count-1 do begin
    if Match(aSelf[i]) then
      exit aSelf[i];
  end;

  exit &default(T);
end;


method ListHelpers.FindAll<T>(aSelf: List<T>; Match: Predicate<T>): List<T>;
begin
  if Match = nil then
    raise new SugarArgumentNullException("Match");

  result := new List<T>();
  for i: Integer := 0 to aSelf.Count-1 do begin
    if Match(aSelf[i]) then
      result.Add(aSelf[i]);
  end;
end;

method ListHelpers.TrueForAll<T>(aSelf: List<T>; Match: Predicate<T>): Boolean;
begin
  if Match = nil then
    raise new SugarArgumentNullException("Match");

  for i: Integer := 0 to aSelf.Count-1 do begin
    if not Match(aSelf[i]) then
      exit false;
  end;

  exit true;
end;

method ListHelpers.ForEach<T>(aSelf: List<T>; Action: Action<T>);
begin
  if Action = nil then
    raise new SugarArgumentNullException("Action");

  for i: Integer := 0 to aSelf.Count-1 do
    Action(aSelf[i]);
end;

method ListHelpers.InsertRange<T>(aSelf: List<T>; &Index: Integer; Items: array oF T);
begin

  for i: Integer := length(Items) - 1 downto 0 do
    aSelf.Insert(&Index, Items[i]);
end;

{$IFDEF NOUGAT}

method ListHelpers.LastIndexOf<T>(aSelf: NSArray; aItem: T): Integer;
begin
  var o := NullHelper.ValueOf(aItem);
  for i: Integer := aSelf.count -1 downto 0 do 
    if aSelf[i] = o then exit i;
  exit -1;
end;

method ListHelpers.ToArray<T>(aSelf: NSArray): array of T;
begin
  result := new T[aSelf.count];
  for i: Integer := 0 to aSelf.count - 1 do
    result[i] := aSelf[i];
end;

method ListHelpers.ToArrayReverse<T>(aSelf: NSArray): array of T;
begin
  result := new T[aSelf.count];
  for i: Integer := aSelf.count - 1 downto 0 do
    result[aSelf.count - i - 1] := NullHelper.ValueOf(aSelf.objectAtIndex(i));

end;

{$ENDIF}
{$IFDEF COOPER}
method ListHelpers.ToArrayReverse<T>(aSelf: java.util.Vector<T>; aDest: array of T): array of T;
begin
  result := aDest;
  for i: Integer := aSelf.Count - 1 downto 0 do
    result[aSelf.count - i - 1] := aSelf[i];

end;
{$ENDIF}

end.

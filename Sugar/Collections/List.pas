namespace RemObjects.Oxygene.Sugar.Collections;

{$HIDE W0} //supress case-mismatch errors

interface

uses
  RemObjects.Oxygene.Sugar;

type
  {$IF ECHOES}
  List<T> = public class mapped to System.Collections.Generic.List<T>
  private
    method SetItem(&Index: Integer; Value: T);
  public
    method &Add(anItem: T);
    method AddRange(Items: List<T>); mapped to AddRange(Items);
    method Clear; mapped to Clear;
    method Contains(Item: T): Boolean; mapped to Contains(Item);

    method Exists(Match: Predicate<T>): Boolean;
    method FindIndex(Match: Predicate<T>): Integer;
    method FindIndex(StartIndex: Integer; Match: Predicate<T>): Integer;
    method FindIndex(StartIndex: Integer; aCount: Integer; Match: Predicate<T>): Integer;

    method Find(Match: Predicate<T>): T;
    method FindAll(Match: Predicate<T>): List<T>;
    method TrueForAll(Match: Predicate<T>): Boolean;

    method IndexOf(Item: T): Integer; mapped to IndexOf(Item);
    method Insert(&Index: Integer; anItem: T);
    method LastIndexOf(Item: T): Integer; mapped to LastIndexOf(Item);

    method &Remove(Item: T): Boolean; mapped to &Remove(&Item);
    method RemoveAt(&Index: Integer); mapped to RemoveAt(&Index);
    method RemoveRange(&Index: Integer; aCount: Integer); mapped to RemoveRange(&Index, aCount);

    method ToArray: array of T; mapped to ToArray;

    property Count: Integer read mapped.Count;
    property Item[i: Integer]: T read mapped[i] write SetItem; default;
  end;
  {$ELSEIF COOPER}
  List<T> = public class mapped to java.util.ArrayList<T>
  private
    method SetItem(&Index: Integer; Value: T);
  public
    method &Add(anItem: T);
    method AddRange(Items: List<T>); mapped to addAll(Items);
    method Clear; mapped to clear;
    method Contains(Item: T): Boolean; mapped to contains(Item);

    method Exists(Match: Predicate<T>): Boolean;
    method FindIndex(Match: Predicate<T>): Integer;
    method FindIndex(StartIndex: Integer; Match: Predicate<T>): Integer;
    method FindIndex(StartIndex: Integer; aCount: Integer; Match: Predicate<T>): Integer;

    method Find(Match: Predicate<T>): T;
    method FindAll(Match: Predicate<T>): List<T>;
    method TrueForAll(Match: Predicate<T>): Boolean;

    method IndexOf(Item: T): Integer; mapped to indexOf(Item);
    method Insert(&Index: Integer; anItem: T);
    method LastIndexOf(Item: T): Integer; mapped to lastIndexOf(Item);

    method &Remove(Item: T): Boolean; mapped to &remove(Object(Item));
    method RemoveAt(&Index: Integer); mapped to &remove(&Index);
    method RemoveRange(&Index: Integer; aCount: Integer);

    method ToArray: array of T;

    property Count: Integer read mapped.size;
    property Item[i: Integer]: T read mapped[i] write SetItem; default;
  end;
  {$ELSEIF NOUGAT}
  List<T> = public class mapped to Foundation.NSMutableArray
    where T is class;
  public
    method &Add(Item: T); mapped to addObject(Item);
    method AddRange(Items: List<T>);
    method Clear; mapped to removeAllObjects;
    method Contains(Item: T): Boolean; mapped to containsObject(Item);

    method Exists(Match: Predicate<T>): Boolean;
    method FindIndex(Match: Predicate<T>): Integer;
    method FindIndex(StartIndex: Integer; Match: Predicate<T>): Integer;
    method FindIndex(StartIndex: Integer; aCount: Integer; Match: Predicate<T>): Integer;

    method Find(Match: Predicate<T>): T;
    method FindAll(Match: Predicate<T>): List<T>;
    method TrueForAll(Match: Predicate<T>): Boolean;
    method LastIndexOf(anItem: T): Integer;

    method IndexOf(anItem: T): Integer;
    method Insert(&Index: Integer; Item: T); mapped to insertObject(Item) atIndex(&Index);

    method &Remove(anItem: T): Boolean;
    method RemoveAt(&Index: Integer); mapped to removeObjectAtIndex(&Index);
    method RemoveRange(&Index: Integer; aCount: Integer);

    method ToArray: array of T;

    property Count: Integer read mapped.count;
    property Item[i: Integer]: T read mapped[i] write mapped[i]; default;
  end;
  {$ENDIF}  

  Predicate<T> = public block (Obj: T): Boolean;


implementation

{$IF COOPER OR ECHOES}
method List<T>.&Add(anItem: T);
begin
  if anItem = nil then
    raise new RemObjects.Oxygene.Sugar.SugarArgumentNullException("Item");

  mapped.Add(anItem);
end;

method List<T>.Insert(&Index: Integer; anItem: T);
begin
  if anItem = nil then
    raise new RemObjects.Oxygene.Sugar.SugarArgumentNullException("Item");

  {$IF COOPER}
  mapped.Add(&Index, anItem);
  {$ELSE}
  mapped.Insert(&Index, anItem);
  {$ENDIF} 
end;

method List<T>.SetItem(&Index: Integer; Value: T);
begin
  if Value = nil then
    raise new RemObjects.Oxygene.Sugar.SugarArgumentNullException("Value");

  mapped[&Index] := Value;
end;
{$ENDIF}

{$IF COOPER}
method List<T>.ToArray: array of T;
begin
  exit mapped.toArray(new T[0]);
end;
{$ENDIF}

{$IF COOPER OR NOUGAT}
method List<T>.RemoveRange(&Index: Integer; aCount: Integer);
begin
 {$IF COOPER}
 mapped.subList(&Index, &Index+aCount).clear;
 {$ELSEIF NOUGAT}
 mapped.removeObjectsInRange(Foundation.NSMakeRange(&Index, aCount));
 {$ENDIF}
end;
{$ENDIF}

{$IF NOUGAT}
method List<T>.Remove(anItem: T): Boolean;
begin
  var lIndex := IndexOf(anItem);
  if lIndex <> -1 then begin
    RemoveAt(lIndex);
    exit true;
  end;
  
  exit false;
end;

method List<T>.IndexOf(anItem: T): Integer;
begin
  var lIndex := mapped.indexOfObject(anItem);
  exit if lIndex = NSNotFound then -1 else lIndex;
end;

method List<T>.LastIndexOf(anItem: T): Integer;
begin
  var lIndex := mapped.indexOfObjectWithOptions(Foundation.NSEnumerationReverse) passingTest((x,y,z) -> x = id(anItem));
  exit if lIndex = NSNotFound then -1 else lIndex;
end;

method List<T>.ToArray: array of T;
begin
  result := new T[mapped.count];
  for i: Integer := 0 to mapped.count - 1 do
    result := mapped.objectAtIndex(i);
end;

method List<T>.AddRange(Items: List<T>);
begin
  if Items = nil then
    raise new RemObjects.Oxygene.Sugar.SugarArgumentNullException("Items");

   mapped.addObjectsFromArray(Items);
end;
{$ENDIF}

method List<T>.TrueForAll(Match: Predicate<T>): Boolean;
begin
  if Match = nil then
    raise new SugarArgumentNullException("Match");

  for i: Integer := 0 to self.Count-1 do begin
    if not Match(mapped[i]) then
      exit false;
  end;

  exit true;
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
    if StartIndex > Count then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.ARG_OUT_OF_RANGE_ERROR, "StartIndex");

  if (aCount < 0) or (StartIndex > Count - aCount) then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.ARG_OUT_OF_RANGE_ERROR, "Count");

  if Match = nil then
    raise new SugarArgumentNullException("Match");

  var Length := StartIndex + aCount; 

  for i: Int32 := StartIndex to Length - 1 do
    if Match(mapped[i]) then
      exit i;

  exit -1;
end;

method List<T>.Find(Match: Predicate<T>): T;
begin
  if Match = nil then
    raise new SugarArgumentNullException("Match");

  for i: Integer := 0 to Count-1 do begin
    if Match(mapped[i]) then
      exit mapped[i];
  end;

  exit &default(T);
end;

method List<T>.FindAll(Match: Predicate<T>): List<T>;
begin
  if Match = nil then
    raise new SugarArgumentNullException("Match");

  var lList := new List<T>();
  for i: Integer := 0 to Count-1 do begin
    if Match(mapped[i]) then
      lList.Add(mapped[i]);
  end;
end;

end.

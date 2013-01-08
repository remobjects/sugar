namespace RemObjects.Oxygene.Sugar.Collections;

{$HIDE W0} //supress case-mismatch errors

interface

type
  {$IF ECHOES}
  List<T> = public class mapped to System.Collections.Generic.List<T>
  public
    method &Add(Item: T); mapped to &Add(Item);
    method Clear; mapped to Clear;
    method Contains(Item: T): boolean; mapped to Contains(Item);

    method Exists(Match: Predicate<T>): Boolean;
    method FindIndex(Match: Predicate<T>): Integer;
    method FindIndex(StartIndex: Integer; Match: Predicate<T>): Integer;
    method FindIndex(StartIndex: Integer; aCount: Integer; Match: Predicate<T>): Integer;

    method Find(Match: Predicate<T>): T;
    method FindAll(Match: Predicate<T>): List<T>;
    method TrueForAll(Match: Predicate<T>): Boolean;

    method IndexOf(Item: T): Integer; mapped to IndexOf(Item);
    method Insert(&Index: Integer; Item: T); mapped to Insert(&Index, Item);
    method LastIndexOf(Item: T): Integer; mapped to LastIndexOf(Item);

    method &Remove(Item: T): Boolean; mapped to &Remove(&Item);
    method RemoveAt(&Index: Integer); mapped to RemoveAt(&Index);
    method RemoveRange(&Index: Integer; aCount: Integer); mapped to RemoveRange(&Index, aCount);

    property Count: Integer read mapped.Count;
    property Item[i: Integer]: T read mapped[i] write mapped[i]; default;
  end;
  {$ELSEIF COOPER}
  List<T> = public class mapped to java.util.ArrayList<T>
  public
    method &Add(Item: T); mapped to &Add(Item);
    method Clear; mapped to Clear;
    method Contains(Item: T): boolean; mapped to Contains(Item);

    method Exists(Match: Predicate<T>): Boolean;
    method FindIndex(Match: Predicate<T>): Integer;
    method FindIndex(StartIndex: Integer; Match: Predicate<T>): Integer;
    method FindIndex(StartIndex: Integer; aCount: Integer; Match: Predicate<T>): Integer;

    method Find(Match: Predicate<T>): T;
    method FindAll(Match: Predicate<T>): List<T>;
    method TrueForAll(Match: Predicate<T>): Boolean;

    method IndexOf(Item: T): Integer; mapped to IndexOf(Item);
    method Insert(&Index: Integer; Item: T); mapped to &Add(&Index, Item);
    method LastIndexOf(Item: T): Integer; mapped to LastIndexOf(Item);

    method &Remove(Item: T): Boolean; mapped to &Remove(Object(Item));
    method RemoveAt(&Index: Integer); mapped to &Remove(&Index);
    method RemoveRange(&Index: Integer; aCount: Integer);

    property Count: Integer read mapped.size;
    property Item[i: Integer]: T read mapped[i] write mapped[i]; default;
  end;
  {$ELSEIF NOUGAT}
  List<T> = public class mapped to Foundation.NSMutableArray
  public
    method &Add(Item: T); mapped to addObject(Item);
    method Clear; mapped to removeAllObjects;
    method Contains(Item: T): boolean; mapped to containsObject(Item);

    {$IF NOT NOUGAT}
    method Exists(Match: Predicate<T>): Boolean;
    method FindIndex(Match: Predicate<T>): Integer;
    method FindIndex(StartIndex: Integer; Match: Predicate<T>): Integer;
    method FindIndex(StartIndex: Integer; aCount: Integer; Match: Predicate<T>): Integer;

    method Find(Match: Predicate<T>): T;
    method FindAll(Match: Predicate<T>): List<T>;
    method TrueForAll(Match: Predicate<T>): Boolean;
    method LastIndexOf(Item: T): Integer;
    {$ENDIF}

    method IndexOf(Item: T): Integer; mapped to indexOfObject(Item);
    method Insert(&Index: Integer; Item: T); mapped to insertObject(Item) atIndex(&Index);
   

    method &Remove(anItem: T): Boolean;
    method RemoveAt(&Index: Integer); mapped to removeObjectAtIndex(&Index);
    method RemoveRange(&Index: Integer; aCount: Integer);

    property Count: Integer read mapped.Count;
    property Item[i: Integer]: T read mapped[i] write mapped[i]; default;
  end;
  {$ENDIF}  

  {$IF NOT NOUGAT}
  Predicate<T> = public interface
    method Check(Obj: T): Boolean;
  end;
  {$ENDIF}


implementation


{$IFNDEF ECHOES}
method List<T>.RemoveRange(&Index: Integer; aCount: Integer);
begin
 {$IF COOPER}
 mapped.subList(&Index, aCount).clear;
 {$ELSEIF NOUGAT}
 mapped.removeObjectsInRange(new Foundation.NSRange(length := aCount, location := &Index));
 {$ENDIF}
end;
{$ENDIF}

{$IF NOUGAT}
method List<T>.Remove(anItem: T): Boolean;
begin
  result := mapped.containsObject(anItem);
  mapped.removeObject(anItem);
end;
{$ENDIF}

{$IF NOT NOUGAT}
method List<T>.TrueForAll(Match: Predicate<T>): Boolean;
begin
  for i: Integer := 0 to self.Count-1 do begin
    if not Match(mapped[i]) then  //Item[i] causes crash in Cooper
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
  var Num := StartIndex + aCount;
  for i: Int32 := StartIndex to Num-1 do begin
    if Match(mapped[i]) then
      exit i;
  end;
  exit -1;
end;

method List<T>.Find(Match: Predicate<T>): T;
begin
  for i: Integer := 0 to Count-1 do begin
    if Match(mapped[i]) then
      exit mapped[i];
  end;
  exit &default(T);
end;

method List<T>.FindAll(Match: Predicate<T>): List<T>;
begin
  var lList := new List<T>();
  for i: Integer := 0 to Count-1 do begin
    if Match(mapped[i]) then
      lList.Add(mapped[i]);
  end;
end;
{$ENDIF}

end.

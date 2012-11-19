namespace RemObjects.Oxygene.Sugar;

{$HIDE W0} //supress case-mismatch errors
{$HIDE W27}

interface

{$IF NOT NOUGAT}
type
  List<T> = public class mapped to {$IF ECHOES}System.Collections.Generic.List<T>{$ENDIF}{$IF COOPER}java.util.ArrayList<T>{$ENDIF}{$IF NOUGAT}Foundation.NSMutableArray{$ENDIF}
  public
    method &Add(Item: T); mapped to {$IFNDEF NOUGAT}&Add(Item){$ELSE}addObject(Item){$ENDIF};
    method Clear; mapped to {$IFNDEF NOUGAT}Clear{$ELSE}{$ENDIF};
    method Contains(Item: T): boolean; mapped to {$IFNDEF NOUGAT}Contains(Item){$ELSE}{$ENDIF};

    method Exists(Match: Predicate<T>): Boolean;
    method FindIndex(Match: Predicate<T>): Integer;
    method FindIndex(StartIndex: Integer; Match: Predicate<T>): Integer;
    method FindIndex(StartIndex: Integer; Count: Integer; Match: Predicate<T>): Integer;
    method Find(Match: Predicate<T>): T;
    method FindAll(Match: Predicate<T>): List<T>;

    method IndexOf(Item: T): Integer; mapped to {$IFNDEF NOUGAT}IndexOf(Item){$ELSE}{$ENDIF};
    method Insert(&Index: Integer; Item: T); mapped to {$IF ECHOES}Insert(&Index, Item){$ENDIF}{$IF COOPER}&Add(&Index, Item){$ENDIF}{$IF NOUGAT}{$ENDIF};
    method LastIndexOf(Item: T): Integer; mapped to {$IFNDEF NOUGAT}LastIndexOf(Item){$ELSE}{$ENDIF};

    method &Remove(Item: T): Boolean; mapped to {$IF ECHOES}Remove(&Item){$ENDIF}{$IF COOPER}&Remove(Object(Item)){$ENDIF};
    method RemoveAt(&Index: Integer); mapped to {$IF ECHOES}RemoveAt(&Index){$ENDIF}{$IF COOPER}&Remove(&Index){$ENDIF};
    method RemoveRange(&Index: Integer; Count: Integer); {$IF ECHOES}mapped to RemoveRange(&Index, Count);{$ENDIF}

    method TrueForAll(Match: Predicate<T>): Boolean;

    property Count: Integer read {$IFNDEF COOPER}mapped.Count{$ELSE}mapped.size{$ENDIF};
    property Item[i: Integer]: T {$IFNDEF NOUGAT}read mapped[i] write mapped[i]{$ELSE}{$ENDIF}; default;
  end;

  Predicate<T> = public interface
    method Check(Obj: T): Boolean;
  end;
{$ENDIF}

implementation
{$IF NOT NOUGAT}

{$IFNDEF ECHOES}
method List<T>.RemoveRange(&Index: Integer; Count: Integer);
begin
 mapped.subList(&Index, Count).clear;
end;
{$ENDIF}

method List<T>.TrueForAll(Match: Predicate<T>): Boolean;
begin
  for i: Integer := 0 to self.Count-1 do begin
    if not Match({$IF COOPER}mapped[i]{$ELSE}Item[i]{$ENDIF}) then  //Item[i] causes crash in Cooper
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

method List<T>.FindIndex(StartIndex: Integer; Count: Integer; Match: Predicate<T>): Integer;
begin
  var Num := StartIndex + Count;
  for i: Int32 := StartIndex to Num-1 do begin
    if Match({$IF COOPER}mapped[i]{$ELSE}Item[i]{$ENDIF}) then
      exit i;
  end;
  exit -1;
end;

method List<T>.Find(Match: Predicate<T>): T;
begin
  for i: Integer := 0 to Count-1 do begin
    if Match({$IF COOPER}mapped[i]{$ELSE}Item[i]{$ENDIF}) then
      exit Item[i];
  end;
  exit &default(T);
end;

method List<T>.FindAll(Match: Predicate<T>): List<T>;
begin
  var lList := new List<T>();
  for i: Integer := 0 to Count-1 do begin
    if Match({$IF COOPER}mapped[i]{$ELSE}Item[i]{$ENDIF}) then
      lList.Add(Item[i]);
  end;
end;
{$ENDIF}
end.

namespace RemObjects.Oxygene.Sugar.Collections;

{$HIDE W0} //supress case-mismatch errors

interface

uses
  RemObjects.Oxygene.Sugar;

type
  {$IF COOPER OR ECHOES}
  KeyValue<T, U> = public class
  public
    constructor(aKey: T; aValue: U);
    method &Equals(Obj: Object): Boolean; override;    
    method {$IF COOPER}ToString: java.lang.String{$ELSEIF ECHOES}ToString: System.String{$ENDIF}; override;
    method {$IF COOPER}hashCode: Integer{$ELSEIF ECHOES}GetHashCode: Integer{$ENDIF}; override;

    property Key: T read write; readonly;
    property Value: U read write; readonly;
  end;
  {$ELSEIF NOUGAT}
  KeyValue = public class
  public
    constructor(aKey: id; aValue: id);
    method isEqual(obj: id): Boolean; override;
    method description: Foundation.NSString; override;
    method hash: Foundation.NSUInteger; override;

    property Key: id read write; readonly;
    property Value: id read write; readonly;
  end;

  KeyValue<T, U> = public class mapped to KeyValue where T is class, U is class;
  public
    property Key: T read mapped.Key;
    property Value: U read mapped.Value;
  end;
  {$ENDIF}

implementation

{$IF COOPER OR ECHOES}
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
{$ELSEIF NOUGAT}
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
{$ENDIF}

end.

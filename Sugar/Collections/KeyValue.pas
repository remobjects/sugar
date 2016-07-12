namespace Sugar.Collections;

interface

uses
  Sugar;

type  
  KeyValuePair<T, U> = public class
  public
    constructor(aKey: T; aValue: U);
    method {$IF TOFFEE}isEqual(obj: id){$ELSE}&Equals(Obj: Object){$ENDIF}: Boolean; override;    
    method {$IF COOPER}ToString: java.lang.String{$ELSEIF ECHOES}ToString: System.String{$ELSEIF TOFFEE}description: Foundation.NSString{$ENDIF}; override;
    method {$IF COOPER}hashCode: Integer{$ELSEIF ECHOES}GetHashCode: Integer{$ELSEIF TOFFEE}hash: Foundation.NSUInteger{$ENDIF}; override;

    property Key: T read write; readonly;
    property Value: U read write; readonly;
    
    method GetTuple: tuple of (T,U);
  end;

  {$IF Cooper}
  {$ELSE}
  [Obsolete('Use KeyValuePair<T, U> class instead.')]
  {$ENDIF}
  KeyValue<T, U> = public class(KeyValuePair<T,U>);

implementation

constructor KeyValuePair<T,U>(aKey: T; aValue: U);
begin
  if aKey = nil then
    raise new SugarArgumentNullException("Key");

  Key := aKey;
  Value := aValue;  
end;

method KeyValuePair<T, U>.{$IF TOFFEE}isEqual(obj: id){$ELSE}&Equals(Obj: Object){$ENDIF}: Boolean;
begin
  if Obj = nil then
    exit false;

  if not (Obj is KeyValuePair<T,U>) then
    exit false;

  var Item := KeyValuePair<T, U>(Obj);
  result := Key.Equals(Item.Key) and ( ((Value = nil) and (Item.Value = nil)) or ((Value <> nil) and Value.Equals(Item.Value)));
end;

method KeyValuePair<T, U>.{$IF COOPER}hashCode: Integer{$ELSEIF ECHOES}GetHashCode: Integer{$ELSEIF TOFFEE}hash: Foundation.NSUInteger{$ENDIF};
begin
  result := Key.GetHashCode + Value:GetHashCode;
end;

method KeyValuePair<T, U>.{$IF COOPER}ToString: java.lang.String{$ELSEIF ECHOES}ToString: System.String{$ELSEIF TOFFEE}description: Foundation.NSString{$ENDIF};
begin
  result := String.Format("Key: {0} Value: {1}", Key, Value);
end;

method KeyValuePair<T, U>.GetTuple: tuple of (T,U);
begin
  result := (Key, Value);
end;

end.

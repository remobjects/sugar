namespace Sugar.Collections;

interface

uses
  Sugar;

type  
  KeyValue<T, U> = public class
  public
    constructor(aKey: T; aValue: U);
    method {$IF NOUGAT}isEqual(obj: id){$ELSE}&Equals(Obj: Object){$ENDIF}: Boolean; override;    
    method {$IF COOPER}ToString: java.lang.String{$ELSEIF ECHOES}ToString: System.String{$ELSEIF NOUGAT}description: Foundation.NSString{$ENDIF}; override;
    method {$IF COOPER}hashCode: Integer{$ELSEIF ECHOES}GetHashCode: Integer{$ELSEIF NOUGAT}hash: Foundation.NSUInteger{$ENDIF}; override;

    property Key: T read write; readonly;
    property Value: U read write; readonly;
  end;

implementation

constructor KeyValue<T,U>(aKey: T; aValue: U);
begin
  if aKey = nil then
    raise new SugarArgumentNullException("Key");

  Key := aKey;
  Value := aValue;  
end;

method KeyValue<T, U>.{$IF NOUGAT}isEqual(obj: id){$ELSE}&Equals(Obj: Object){$ENDIF}: Boolean;
begin
  if Obj = nil then
    exit false;

  if not (Obj is KeyValue<T,U>) then
    exit false;

  var Item := KeyValue<T, U>(Obj);
  exit Key.Equals(Item.Key) and ( ((Value = nil) and (Item.Value = nil)) or ((Value <> nil) and Value.Equals(Item.Value)));
end;

method KeyValue<T, U>.{$IF COOPER}hashCode: Integer{$ELSEIF ECHOES}GetHashCode: Integer{$ELSEIF NOUGAT}hash: Foundation.NSUInteger{$ENDIF};
begin
  exit Key.GetHashCode + Value:GetHashCode;
end;

method KeyValue<T, U>.{$IF COOPER}ToString: java.lang.String{$ELSEIF ECHOES}ToString: System.String{$ELSEIF NOUGAT}description: Foundation.NSString{$ENDIF};
begin
  exit String.Format("Key: {0} Value: {1}", Key, Value);
end;

end.

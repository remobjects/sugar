namespace Sugar.Data.JSON;

interface

uses
  Sugar;

type
  JsonValue = public class
  private
    method Validate(InvalidTokens: sequence of JsonValueKind);
    class method GetValueKind(Value: Object): tuple of (Object, JsonValueKind);
  public
    constructor(Value: Object);
    constructor(Value: Object; ValueKind: JsonValueKind);

    method ToInteger: Int64;
    method ToDouble: Double;
    method ToStr: String;
    method {$IF NOUGAT}description: Foundation.NSString{$ELSEIF COOPER}ToString: java.lang.String{$ELSEIF ECHOES}ToString: System.String{$ENDIF}; override;
    method ToObject: JsonObject;
    method ToArray: JsonArray;
    method ToBoolean: Boolean;  
  
    method {$IF NOUGAT}isEqual(obj: id){$ELSE}&Equals(Obj: Object){$ENDIF}: Boolean; override;
    method {$IF NOUGAT}hash: Foundation.NSUInteger{$ELSEIF COOPER}hashCode: Integer{$ELSEIF ECHOES}GetHashCode: Integer{$ENDIF}; override;

    property Object: Object read write; readonly;
    property Kind: JsonValueKind read write; readonly;
    property IsNull: Boolean read Kind = JsonValueKind.Null;
  end;

  JsonValueKind = public enum (Null, String, Integer, Double, Boolean, Object, Array);

implementation

constructor JsonValue(Value: Object);
begin
  var item := GetValueKind(Value);
  constructor(item.Item1, item.Item2);
end;

constructor JsonValue(Value: Object; ValueKind: JsonValueKind);
begin
  self.Object := Value;
  self.Kind := ValueKind;
end;

method JsonValue.ToInteger: Int64;
begin
  Validate([JsonValueKind.Null, JsonValueKind.Array, JsonValueKind.Object]);

  case Kind of
    JsonValueKind.String: exit Convert.ToInt64(String(Object));
    JsonValueKind.Integer: exit Int64(Object);
    JsonValueKind.Double: exit Convert.ToInt64(Double(Object));
    JsonValueKind.Boolean: exit Convert.ToInt64(Boolean(Object));
  end;
end;

method JsonValue.ToDouble: Double;
begin
  Validate([JsonValueKind.Null, JsonValueKind.Array, JsonValueKind.Object]);

  case Kind of
    JsonValueKind.String: exit Convert.ToDouble(String(Object));
    JsonValueKind.Integer: exit Convert.ToDouble(Int64(Object));
    JsonValueKind.Double: exit Double(Object);
    JsonValueKind.Boolean: exit Convert.ToDouble(Boolean(Object));
  end;
end;

method JsonValue.ToStr: String;
begin
  case Kind of
    JsonValueKind.Object: exit Object.ToString;
    JsonValueKind.Array: exit Object.ToString;
    JsonValueKind.Null: exit nil;
    JsonValueKind.String: exit String(Object);
    JsonValueKind.Integer: exit Convert.ToString(Int64(Object));
    JsonValueKind.Double: exit Convert.ToString(Double(Object));
    JsonValueKind.Boolean: exit Convert.ToString(Boolean(Object));
  end;
end;

method JsonValue.{$IF NOUGAT}description: Foundation.NSString{$ELSEIF COOPER}ToString: java.lang.String{$ELSEIF ECHOES}ToString: System.String{$ENDIF};
begin
  if Kind = JsonValueKind.Null then
    exit "(null)"
  else
    exit ToStr;
end;

method JsonValue.{$IF NOUGAT}isEqual(obj: id){$ELSE}&Equals(Obj: Object){$ENDIF}: Boolean;
begin
  if (obj = nil) or (not (obj is JsonValue)) then
    exit false;
  
  exit self.Object.Equals(JsonValue(obj).Object);
end;

method JsonValue.{$IF NOUGAT}hash: Foundation.NSUInteger{$ELSEIF COOPER}hashCode: Integer{$ELSEIF ECHOES}GetHashCode: Integer{$ENDIF};
begin
  exit if self.Object = nil then -1 else self.Object.GetHashCode;
end;

method JsonValue.ToObject: JsonObject;
begin
  Validate([JsonValueKind.Array, JsonValueKind.Boolean, JsonValueKind.Double, JsonValueKind.Integer, JsonValueKind.String]);

  if Kind = JsonValueKind.Object then
    exit JsonObject(Object)
  else
    exit nil;
end;

method JsonValue.ToArray: JsonArray;
begin
  Validate([JsonValueKind.Object, JsonValueKind.Boolean, JsonValueKind.Double, JsonValueKind.Integer, JsonValueKind.String]);

  if Kind = JsonValueKind.Array then
    exit JsonArray(Object)
  else
    exit nil;
end;

method JsonValue.ToBoolean: Boolean;
begin
  Validate([JsonValueKind.Null, JsonValueKind.Array, JsonValueKind.Object]);

  case Kind of
    JsonValueKind.String: exit Convert.ToBoolean(String(Object));
    JsonValueKind.Integer: exit Convert.ToBoolean(Int64(Object));
    JsonValueKind.Double: exit Convert.ToBoolean(Double(Object));
    JsonValueKind.Boolean: exit Boolean(Object);
  end;
end;

method JsonValue.Validate(InvalidTokens: sequence of JsonValueKind);
begin
  for Item: JsonValueKind in InvalidTokens do
    if Kind = Item then
      raise new SugarInvalidOperationException("Unable to convert <{0}>.", coalesce(Object, "null"));
end;

class method JsonValue.GetValueKind(Value: Object): tuple of (Object, JsonValueKind);
begin
  if Value = nil then
    exit (nil, JsonValueKind.Null);

  {$IF NOUGAT}
  if Value is JsonArray then
    exit (Value, JsonValueKind.Array);
  if Value is JsonObject then
    exit (Value, JsonValueKind.Object);
  if Value is NSNumber then begin
      var Number := NSNumber(Value);

      if (Number.objCType^ = 'd') or (Number.objCType^ = 'f') then
        exit (Number.doubleValue, JsonValueKind.Double);

      if (Number.objCType^ = 'c') and (NSStringFromClass(Number.class) = "__NSCFBoolean") then
        exit (Number.boolValue, JsonValueKind.Boolean);

      exit (Number.longLongValue, JsonValueKind.Integer);
    end;
  if Value is String then
    exit (Value, JsonValueKind.String);
  {$ELSE}
  case Value type of
    JsonArray: exit (Value, JsonValueKind.Array);
    JsonObject: exit (Value, JsonValueKind.Object);
    Boolean: exit (Value, JsonValueKind.Boolean);
    Double: exit (Value, JsonValueKind.Double);
    Single: exit (Double(Single(Value)), JsonValueKind.Double);
    String: exit (Value, JsonValueKind.String);
    Char: exit (String(Char(Value)), JsonValueKind.String);
    Byte: exit (Int64(Byte(Value)), JsonValueKind.Integer);
    SByte: exit (Int64(SByte(Value)), JsonValueKind.Integer);
    Int16: exit (Int64(Int16(Value)), JsonValueKind.Integer);
    UInt16: exit (Int64(UInt16(Value)), JsonValueKind.Integer); 
    Int32: exit (Int64(Int32(Value)), JsonValueKind.Integer);
    UInt32: exit (Int64(UInt32(Value)), JsonValueKind.Integer);
    Int64: exit (Value, JsonValueKind.Integer);
    UInt64: exit (Int64(UInt64(Value)), JsonValueKind.Integer);    
  end;
  {$ENDIF}

  raise new SugarInvalidValueException("Can not convert value of type {0} to a JsonValue", [typeOf(Value)]);
end;

end.
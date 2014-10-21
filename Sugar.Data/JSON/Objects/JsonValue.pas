namespace Sugar.Data.JSON;

interface

uses
  Sugar;

type
  JsonValue = public class
  private
    method Validate(InvalidTokens: sequence of JsonValueKind);
  public
    constructor(Value: Object; ValueKind: JsonValueKind);

    method ToInteger: Int64;
    method ToDouble: Double;
    method ToStr: String;
    method {$IF NOUGAT}description: Foundation.NSString{$ELSEIF COOPER}ToString: java.lang.String{$ELSEIF ECHOES}ToString: System.String{$ENDIF}; override;
    method ToObject: JsonObject;
    method ToArray: JsonArray;
    method ToBoolean: Boolean;    

    property Object: Object read write; readonly;
    property Kind: JsonValueKind read write; readonly;
    property IsNull: Boolean read Kind = JsonValueKind.Null;
  end;

  JsonValueKind = public enum (Null, String, Integer, Double, Boolean, Object, Array);

implementation

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
    JsonValueKind.Boolean: exit Int64(Object);
  end;
end;

method JsonValue.ToDouble: Double;
begin
  Validate([JsonValueKind.Null, JsonValueKind.Array, JsonValueKind.Object]);

  case Kind of
    JsonValueKind.String: exit Convert.ToDouble(String(Object));
    JsonValueKind.Integer: exit Convert.ToDouble(Int64(Object));
    JsonValueKind.Double: exit Double(Object);
    JsonValueKind.Boolean: exit Double(Object);
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
      raise new SugarInvalidOperationException("Unable to convert <{0}> value.", Object);
end;

end.
namespace Sugar.Data.JSON;

interface

uses
  Sugar;

type
  JsonProperty = public class
  public
    constructor (aKey: String; aValue: JsonValue);
    constructor (aKey: String; aValue: Object; Kind: JsonValueKind);

    method ToInteger: Int64;
    method ToDouble: Double;
    method ToStr: String;
    method {$IF NOUGAT}description: Foundation.NSString{$ELSEIF COOPER}ToString: java.lang.String{$ELSEIF ECHOES}ToString: System.String{$ENDIF}; override;
    method ToObject: JsonObject;
    method ToArray: JsonArray;
    method ToBoolean: Boolean;

    property Key: String read write; readonly;
    property Value: JsonValue read write; readonly;
    property IsNull: Boolean read Value.Kind = JsonValueKind.Null;
  end;

implementation

constructor JsonProperty(aKey: String; aValue: JsonValue);
begin
  SugarArgumentNullException.RaiseIfNil(aKey, "Key");
  SugarArgumentNullException.RaiseIfNil(aValue, "Value");

  self.Key := aKey;
  self.Value := aValue;
end;

constructor JsonProperty(aKey: String; aValue: Object; Kind: JsonValueKind);
begin
  SugarArgumentNullException.RaiseIfNil(aKey, "Key");
  SugarArgumentNullException.RaiseIfNil(aValue, "Value");

  self.Key := aKey;
  self.Value := new JsonValue(aValue, Kind);
end;

method JsonProperty.ToInteger: Int64;
begin
  exit Value.ToInteger;
end;

method JsonProperty.ToDouble: Double;
begin
  exit Value.ToDouble;
end;

method JsonProperty.ToStr: String;
begin
  exit Value.ToString;
end;

method JsonProperty.{$IF NOUGAT}description: Foundation.NSString{$ELSEIF COOPER}ToString: java.lang.String{$ELSEIF ECHOES}ToString: System.String{$ENDIF};
begin
  exit String.Format("{0}: {1}", Key, Value.ToString);
end;

method JsonProperty.ToObject: JsonObject;
begin
  exit Value.ToObject;
end;

method JsonProperty.ToArray: JsonArray;
begin
  exit Value.ToArray;
end;

method JsonProperty.ToBoolean: Boolean;
begin
  exit Value.ToBoolean;
end;

end.

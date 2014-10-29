namespace Sugar.Data.JSON;

interface

uses
  Sugar,
  Sugar.Collections;

type
  JsonSerializer = assembly class
  private
    Builder: StringBuilder := new StringBuilder();
    JValue: JsonValue;
    Offset: Integer;

    method IncOffset;
    method DecOffset;
    method AppendOffset;

    method VisitObject(Value: JsonObject);
    method VisitArray(Value: JsonArray);
    method VisitString(Value: String);
    method VisitNumber(Value: JsonValue);
    method VisitBoolean(Value: Boolean);
    method VisitNull(Value: JsonValue);
    method VisitName(Value: String);
    method Visit(Value: JsonValue);
  public
    constructor (Value: JsonValue);
    
    method Serialize: String;    
  end;

implementation

constructor JsonSerializer(Value: JsonValue);
begin
  SugarArgumentNullException.RaiseIfNil(Value, "Value");
  JValue := Value;
end;

method JsonSerializer.Serialize: String;
begin
  Builder.Clear;
  Offset := 0;
  Visit(JValue);
  exit Builder.ToString;
end;

method JsonSerializer.VisitObject(Value: JsonObject);
begin
  Builder.AppendLine(JsonConsts.OBJECT_START);
  IncOffset;

  var lCount := 0;

  for Key: String in Value.Keys do begin
    inc(lCount);
    VisitName(Key);
    Visit(Value[Key]);
    if lCount = Value.Count then
      Builder.AppendLine
    else
      Builder.AppendLine(JsonConsts.VALUE_SEPARATOR);
  end;
  DecOffset;
  AppendOffset;
  Builder.Append(JsonConsts.OBJECT_END);
end;

method JsonSerializer.VisitArray(Value: JsonArray);
begin
  Builder.AppendLine(JsonConsts.ARRAY_START);
  IncOffset;
  
  for i: Int32 := 0 to Value.Count-1 do begin
    AppendOffset;
    Visit(Value[i]);
    if i < Value.Count - 1 then
      Builder.AppendLine(JsonConsts.VALUE_SEPARATOR)
    else
      Builder.AppendLine;
  end;

  DecOffset;
  AppendOffset;
  Builder.Append(JsonConsts.ARRAY_END);
end;

method JsonSerializer.VisitString(Value: String);
begin
  Builder.Append(JsonConsts.STRING_QUOTE).Append(Value).Append(JsonConsts.STRING_QUOTE);
end;

method JsonSerializer.VisitNumber(Value: JsonValue);
begin
  Builder.Append(Value.ToStr);
end;

method JsonSerializer.VisitBoolean(Value: Boolean);
begin
  Builder.Append(if Value then JsonConsts.TRUE_VALUE else JsonConsts.FALSE_VALUE);
end;

method JsonSerializer.VisitNull(Value: JsonValue);
begin
  Builder.Append(JsonConsts.NULL_VALUE);
end;

method JsonSerializer.VisitName(Value: String);
begin
  AppendOffset;
  VisitString(Value);
  Builder.Append(JsonConsts.NAME_SEPARATOR).Append(" ");
end;

method JsonSerializer.Visit(Value: JsonValue);
begin
  case Value.Kind of
    JsonValueKind.Null: VisitNull(Value);
    JsonValueKind.String: VisitString(Value.ToStr);
    JsonValueKind.Integer: VisitNumber(Value);
    JsonValueKind.Double: VisitNumber(Value);
    JsonValueKind.Boolean: VisitBoolean(Value.ToBoolean);
    JsonValueKind.Object: VisitObject(Value.ToObject);
    JsonValueKind.Array: VisitArray(Value.ToArray);
  end;
end;

method JsonSerializer.IncOffset;
begin
  Offset := Offset + 2;
end;

method JsonSerializer.DecOffset;
begin
  Offset := Offset - 2;
end;

method JsonSerializer.AppendOffset;
begin
  Builder.Append(' ', Offset);
end;

end.
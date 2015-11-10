namespace Sugar.Json;

interface

uses
  Sugar,
  Sugar.Collections;

type
  JsonSerializer = assembly class
  private
    Builder: StringBuilder := new StringBuilder();
    JValue: JsonNode;
    Offset: Integer;

    method IncOffset;
    method DecOffset;
    method AppendOffset;

    method VisitObject(Value: JsonObject);
    method VisitArray(Value: JsonArray);
    method VisitString(Value: JsonStringValue);
    method VisitInteger(Value: JsonIntegerValue);
    method VisitFloat(Value: JsonFloatValue);
    method VisitBoolean(Value: JsonBooleanValue);
    method VisitNull(Value: JsonNode);
    method VisitName(Value: String);
    method Visit(Value: JsonNode);
  public
    constructor (Value: JsonNode);
    
    method Serialize: String;    
  end;

implementation

constructor JsonSerializer(Value: JsonNode);
begin
  SugarArgumentNullException.RaiseIfNil(Value, "Value");
  JValue := Value;
end;

method JsonSerializer.Serialize: String;
begin
  Builder.Clear;
  Offset := 0;
  Visit(JValue);
  result := Builder.ToString;
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

method JsonSerializer.VisitString(Value: JsonStringValue);
begin
  Builder.Append(Value.ToJson);
end;

method JsonSerializer.VisitInteger(Value: JsonIntegerValue);
begin
  Builder.Append(Value.ToJson);
end;

method JsonSerializer.VisitFloat(Value: JsonFLoatValue);
begin
  Builder.Append(Value.ToJson);
end;

method JsonSerializer.VisitBoolean(Value: JsonBooleanValue);
begin
  Builder.Append(Value.ToJson);
end;

method JsonSerializer.VisitNull(Value: JsonNode);
begin
  Builder.Append(JsonConsts.NULL_VALUE);
end;

method JsonSerializer.VisitName(Value: String);
begin
  AppendOffset;
  Builder.Append(JsonConsts.STRING_QUOTE).Append(Value).Append(JsonConsts.STRING_QUOTE);
  Builder.Append(JsonConsts.NAME_SEPARATOR).Append(" ");
end;

method JsonSerializer.Visit(Value: JsonNode);
begin
  if assigned(Value) then begin
    case Value type of
      JsonStringValue: VisitString(Value as JsonStringValue);
      JsonIntegerValue: VisitInteger(Value as JsonIntegerValue);
      JsonFloatValue: VisitFloat(Value as JsonFLoatValue);
      JsonBooleanValue: VisitBoolean(Value as JsonBooleanValue);
      JsonArray: VisitArray(Value as JsonArray);
      JsonObject: VisitObject(Value as JsonObject);
    end;
  end
  else
    VisitNull(Value);
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
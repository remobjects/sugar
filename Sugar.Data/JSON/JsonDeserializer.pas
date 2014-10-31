namespace Sugar.Data.JSON;

interface

uses
  Sugar,
  Sugar.Collections;

type
  JsonDeserializer = assembly class
  private
    Tokenizer: JsonTokenizer;
    method Expected(params Values: array of JsonTokenKind);

    method ReadObject: JsonObject;
    method ReadArray: JsonArray;
    method ReadProperties: sequence of KeyValue<String, JsonValue>;
    method ReadPropery: KeyValue<String, JsonValue>;
    method ReadKey: String;
    method ReadValues: sequence of JsonValue;
    method ReadValue: JsonValue;
  public
    constructor (JsonString: String);
    
    method Deserialize: JsonValue;    
  end;

implementation

constructor JsonDeserializer(JsonString: String);
begin
  Tokenizer := new JsonTokenizer(JsonString, true);
end;

method JsonDeserializer.Deserialize: JsonValue;
begin
  Tokenizer.Next;
  Expected(JsonTokenKind.ObjectStart, JsonTokenKind.ArrayStart);
  case Tokenizer.Token of
    JsonTokenKind.ObjectStart: exit new JsonValue(ReadObject, JsonValueKind.Object);
    JsonTokenKind.ArrayStart: exit new JsonValue(ReadArray, JsonValueKind.Array);
  end;
end;

method JsonDeserializer.Expected(params Values: array of JsonTokenKind);
begin
  for Item in Values do
    if Tokenizer.Token = Item then
      exit;

  raise new SugarInvalidOperationException("Unexpected token");
end;

method JsonDeserializer.ReadObject: JsonObject;
begin
  Expected(JsonTokenKind.ObjectStart);
  
  result := new JsonObject;
  Tokenizer.Next;
  
  if Tokenizer.Token = JsonTokenKind.ObjectEnd then
    exit;

  var Properties := ReadProperties;

  Expected(JsonTokenKind.ObjectEnd);
  
  for Item in Properties do
    result.AddValue(Item.Key, Item.Value);
end;

method JsonDeserializer.ReadProperties: sequence of KeyValue<String, JsonValue>;
begin  
  var List := new List<KeyValue<String, JsonValue>>;

  repeat
    List.Add(ReadPropery);

    if Tokenizer.Token = JsonTokenKind.ValueSeperator then begin
      Tokenizer.Next;
      continue;
    end;
  until (Tokenizer.Token = JsonTokenKind.EOF) or (Tokenizer.Token = JsonTokenKind.ObjectEnd);

  exit List;
end;

method JsonDeserializer.ReadPropery: KeyValue<String, JsonValue>;
begin
  var lKey := ReadKey;
  Expected(JsonTokenKind.NameSeperator);
  Tokenizer.Next;
  result := new KeyValue<String,JsonValue>(lKey, ReadValue);
end;

method JsonDeserializer.ReadKey: String;
begin
  Expected(JsonTokenKind.String, JsonTokenKind.Identifier);

  if String.IsNullOrEmpty(Tokenizer.Value) then
    raise new SugarException("Invalid key");

  result := Tokenizer.Value;
  Tokenizer.Next;
end;

method JsonDeserializer.ReadValues: sequence of JsonValue;
begin
  var List := new List<JsonValue>;

  repeat
    List.Add(ReadValue);

    if Tokenizer.Token = JsonTokenKind.ValueSeperator then begin
      Tokenizer.Next;
      continue;
    end;
  until (Tokenizer.Token = JsonTokenKind.EOF) or (Tokenizer.Token = JsonTokenKind.ArrayEnd);

  exit List;
end;

method JsonDeserializer.ReadValue: JsonValue;
begin
  Expected(JsonTokenKind.String, JsonTokenKind.Number, JsonTokenKind.Null, JsonTokenKind.True, JsonTokenKind.False, JsonTokenKind.ArrayStart, JsonTokenKind.ObjectStart, JsonTokenKind.Identifier);

  case Tokenizer.Token of
    JsonTokenKind.String: result := new JsonValue(Tokenizer.Value, JsonValueKind.String);
    JsonTokenKind.Number: begin
      var lValue := Convert.ToDouble(Tokenizer.Value);
    
      if (not Consts.IsInfinity(lValue)) and (not Consts.IsNaN(lValue)) and (Math.Floor(lValue) = lValue) then begin
        if lValue > Consts.MaxInt64 then
          result := new JsonValue(lValue, JsonValueKind.Double)
        else if lValue > Consts.MinInteger then
          result := new JsonValue(Convert.ToInt64(lValue), JsonValueKind.Integer)
        else
          result := new JsonValue(Convert.ToInt64(lValue), JsonValueKind.Integer)
      end
      else 
        result := new JsonValue(lValue, JsonValueKind.Double);
    end;
    JsonTokenKind.Null: result := new JsonValue(nil, JsonValueKind.Null);
    JsonTokenKind.True: result := new JsonValue(true, JsonValueKind.Boolean);
    JsonTokenKind.False: result := new JsonValue(false, JsonValueKind.Boolean);
    JsonTokenKind.ArrayStart: result := new JsonValue(ReadArray, JsonValueKind.Array);
    JsonTokenKind.ObjectStart: result := new JsonValue(ReadObject, JsonValueKind.Object);
    JsonTokenKind.Identifier: result := new JsonValue(Tokenizer.Value, JsonValueKind.String);
  end;

  Tokenizer.Next;
end;

method JsonDeserializer.ReadArray: JsonArray;
begin
  Expected(JsonTokenKind.ArrayStart);
  
  result := new JsonArray;
  Tokenizer.Next;
  
  if Tokenizer.Token = JsonTokenKind.ArrayEnd then
    exit;

  var Values := ReadValues;

  Expected(JsonTokenKind.ArrayEnd);
  
  for Item in Values do
    result.AddValue(Item);
end;

end.

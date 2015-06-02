namespace Sugar.Json;

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
    method ReadProperties: sequence of KeyValue<String, JsonNode>;
    method ReadPropery: KeyValue<String, JsonNode>;
    method ReadKey: String;
    method ReadValues: sequence of JsonNode;
    method ReadValue: JsonNode;
  public
    constructor (JsonString: String);
    
    method Deserialize: JsonNode;    
  end;

implementation

constructor JsonDeserializer(JsonString: String);
begin
  Tokenizer := new JsonTokenizer(JsonString, true);
end;

method JsonDeserializer.Deserialize: JsonNode;
begin
  Tokenizer.Next;
  Expected(JsonTokenKind.ObjectStart, JsonTokenKind.ArrayStart);
  case Tokenizer.Token of
    JsonTokenKind.ObjectStart: exit ReadObject();
    JsonTokenKind.ArrayStart: exit ReadArray();
  end;
end;

method JsonDeserializer.Expected(params Values: array of JsonTokenKind);
begin
  for Item in Values do
    if Tokenizer.Token = Item then
      exit;

  raise new SugarUnexpectedTokenException("Unexpected token");
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
    result.Add(Item.Key, Item.Value);
end;

method JsonDeserializer.ReadProperties: sequence of KeyValue<String, JsonNode>;
begin  
  var List := new List<KeyValue<String, JsonNode>>;

  repeat
    List.Add(ReadPropery);

    if Tokenizer.Token = JsonTokenKind.ValueSeperator then begin
      Tokenizer.Next;
      continue;
    end;
  until (Tokenizer.Token = JsonTokenKind.EOF) or (Tokenizer.Token = JsonTokenKind.ObjectEnd);

  exit List;
end;

method JsonDeserializer.ReadPropery: KeyValue<String, JsonNode>;
begin
  var lKey := ReadKey;
  Expected(JsonTokenKind.NameSeperator);
  Tokenizer.Next;
  result := new KeyValue<String,JsonNode>(lKey, ReadValue);
end;

method JsonDeserializer.ReadKey: String;
begin
  Expected(JsonTokenKind.String, JsonTokenKind.Identifier);

  if String.IsNullOrEmpty(Tokenizer.Value) then
    raise new SugarInvalidTokenException("Invalid propery key. Key can not be empty.");

  result := Tokenizer.Value;
  Tokenizer.Next;
end;

method JsonDeserializer.ReadValues: sequence of JsonNode;
begin
  var List := new List<JsonNode>;

  repeat
    List.Add(ReadValue);

    if Tokenizer.Token = JsonTokenKind.ValueSeperator then begin
      Tokenizer.Next;
      continue;
    end;
  until (Tokenizer.Token = JsonTokenKind.EOF) or (Tokenizer.Token = JsonTokenKind.ArrayEnd);

  exit List;
end;

method JsonDeserializer.ReadValue: JsonNode;
begin
  Expected(JsonTokenKind.String, JsonTokenKind.Number, JsonTokenKind.Null, JsonTokenKind.True, JsonTokenKind.False, JsonTokenKind.ArrayStart, JsonTokenKind.ObjectStart, JsonTokenKind.Identifier);

  case Tokenizer.Token of
    JsonTokenKind.String: result := new JsonStringValue(Tokenizer.Value);
    JsonTokenKind.Number: begin
      var lValue := Convert.ToDouble(Tokenizer.Value);
    
      if (not Consts.IsInfinity(lValue)) and (not Consts.IsNaN(lValue)) and (Math.Floor(lValue) = lValue) then begin
        if lValue > Consts.MaxInt64 then
          result := new JsonFloatValue(lValue)
        else if lValue > Consts.MinInteger then
          result := new JsonIntegerValue(Convert.ToInt64(lValue))
        else
          result := new JsonIntegerValue(Convert.ToInt64(lValue))
      end
      else 
        result := new JsonFloatValue(lValue);
    end;
    JsonTokenKind.Null: result := nil;
    JsonTokenKind.True: result := new JsonBooleanValue(true);
    JsonTokenKind.False: result := new JsonBooleanValue(false);
    JsonTokenKind.ArrayStart: result := ReadArray();
    JsonTokenKind.ObjectStart: result := ReadObject();
    JsonTokenKind.Identifier: result := new JsonStringValue(Tokenizer.Value);
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
    result.Add(Item);
end;

end.

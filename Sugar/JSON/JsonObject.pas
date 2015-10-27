namespace Sugar.Json;

interface

uses  
  Sugar,
  Sugar.Collections;

type
  JsonObject = public class (JsonNode, ISequence<KeyValuePair<String, JsonNode>>)
  private
    Items: Dictionary<String, JsonNode> := new Dictionary<String, JsonNode>;

    method GetItem(Key: String): JsonNode;
    method SetItem(Key: String; Value: JsonNode);
    method GetKeys: sequence of String;
    method GetProperties: sequence of KeyValuePair<String, JsonNode>; iterator;
  public
    method &Add(Key: String; Value: JsonNode);
    method Clear;
    method ContainsKey(Key: String): Boolean;
    method &Remove(Key: String): Boolean;

    method ToJson: String; override;
    
    {$IF COOPER}
    method &iterator: java.util.&Iterator<KeyValuePair<String, JsonNode>>;
    {$ELSEIF ECHOES}
    method GetNonGenericEnumerator: System.Collections.IEnumerator; implements System.Collections.IEnumerable.GetEnumerator;
    method GetEnumerator: System.Collections.Generic.IEnumerator<KeyValuePair<String, JsonNode>>;
    {$ELSEIF NOUGAT}
    method countByEnumeratingWithState(aState: ^NSFastEnumerationState) objects(stackbuf: ^KeyValuePair<String,JsonNode>) count(len: NSUInteger): NSUInteger;
    {$ENDIF}

    class method Load(JsonString: String): JsonObject;

    property Count: Integer read Items.Count;
    property Item[Key: String]: JsonNode read GetItem write SetItem; default;
    property Keys: sequence of String read GetKeys;
    property Properties: sequence of KeyValuePair<String, JsonNode> read GetProperties; 
  end;

implementation

method JsonObject.GetItem(Key: String): JsonNode;
begin
  exit Items[Key];
end;

method JsonObject.SetItem(Key: String; Value: JsonNode);
begin
  SugarArgumentNullException.RaiseIfNil(Value, "Value");
  Items[Key] := Value;
end;

method JsonObject.Add(Key: String; Value: JsonNode);
begin
  Items.Add(Key, Value);  
end;

method JsonObject.Clear;
begin
  Items.Clear;
end;

method JsonObject.ContainsKey(Key: String): Boolean;
begin
  exit Items.ContainsKey(Key);
end;

method JsonObject.Remove(Key: String): Boolean;
begin
  exit Items.Remove(Key);
end;

class method JsonObject.Load(JsonString: String): JsonObject;
begin
  var Serializer := new JsonDeserializer(JsonString);
  var lValue := Serializer.Deserialize;

  if not (lValue is JsonObject) then
    raise new SugarInvalidOperationException("String does not contains valid Json object");

  result := lValue as JsonObject;
end;

method JsonObject.GetKeys: sequence of String;
begin
  exit Items.Keys;
end;

method JsonObject.ToJson: String;
begin
  var Serializer := new JsonSerializer(self);
  result := Serializer.Serialize;
end;

method JsonObject.GetProperties: sequence of KeyValuePair<String, JsonNode>;
begin
  for Key in Keys do
    yield new KeyValuePair<String, JsonNode>(Key, Item[Key]);
end;

{$IF COOPER}
method JsonObject.iterator: java.util.&Iterator<KeyValuePair<String, JsonNode>>;
begin
  exit Properties.iterator;
end;
{$ELSEIF ECHOES}
method JsonObject.GetNonGenericEnumerator: System.Collections.IEnumerator;
begin
  exit GetEnumerator;
end;

method JsonObject.GetEnumerator: System.Collections.Generic.IEnumerator<KeyValuePair<String, JsonNode>>;
begin
  var props := GetProperties;
  exit props.GetEnumerator;
end;
{$ELSEIF NOUGAT}
method JsonObject.countByEnumeratingWithState(aState: ^NSFastEnumerationState) objects(stackbuf: ^KeyValuePair<String,JsonNode>) count(len: NSUInteger): NSUInteger;
begin
  if aState^.state <> 0 then
    exit 0;

  exit GetProperties.countByEnumeratingWithState(aState) objects(stackbuf) count(len);
end;
{$ENDIF}

end.
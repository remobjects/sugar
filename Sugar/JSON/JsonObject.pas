namespace Sugar.Json;

interface

uses  
  Sugar,
  Sugar.Collections;

type
  JsonObject = public class (JsonNode, ISequence<KeyValue<String, JsonNode>>)
  private
    Items: Dictionary<String, JsonNode> := new Dictionary<String, JsonNode>;

    method GetItem(Key: String): nullable JsonNode;
    method SetItem(Key: String; Value: JsonNode);
    method GetKeys: not nullable sequence of String;
    method GetProperties: sequence of KeyValue<String, JsonNode>; iterator;
  public
    method &Add(Key: String; Value: JsonNode);
    method Clear;
    method ContainsKey(Key: String): Boolean;
    method &Remove(Key: String): Boolean;

    method ToJson: String; override;
    
    {$IF COOPER}
    method &iterator: java.util.&Iterator<KeyValue<String, JsonNode>>;
    {$ELSEIF ECHOES}
    method GetNonGenericEnumerator: System.Collections.IEnumerator; implements System.Collections.IEnumerable.GetEnumerator;
    method GetEnumerator: System.Collections.Generic.IEnumerator<KeyValue<String, JsonNode>>;
    {$ELSEIF NOUGAT}
    method countByEnumeratingWithState(aState: ^NSFastEnumerationState) objects(stackbuf: ^KeyValue<String,JsonNode>) count(len: NSUInteger): NSUInteger;
    {$ENDIF}

    class method Load(JsonString: String): JsonObject;

    property Count: Integer read Items.Count;
    property Item[Key: String]: nullable JsonNode read GetItem write SetItem; default;
    property Keys: not nullable sequence of String read GetKeys;
    property Properties: sequence of KeyValue<String, JsonNode> read GetProperties; 
  end;

implementation

method JsonObject.GetItem(Key: String): nullable JsonNode;
begin
  if Items.ContainsKey(Key) then
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

method JsonObject.GetKeys: not nullable sequence of String;
begin
  exit Items.Keys as not nullable;
end;

method JsonObject.ToJson: String;
begin
  var Serializer := new JsonSerializer(self);
  result := Serializer.Serialize;
end;

method JsonObject.GetProperties: sequence of KeyValue<String, JsonNode>;
begin
  for Key in Keys do
    yield new KeyValue<String, JsonNode>(Key, Item[Key]);
end;

{$IF COOPER}
method JsonObject.iterator: java.util.&Iterator<KeyValue<String, JsonNode>>;
begin
  exit Properties.iterator;
end;
{$ELSEIF ECHOES}
method JsonObject.GetNonGenericEnumerator: System.Collections.IEnumerator;
begin
  exit GetEnumerator;
end;

method JsonObject.GetEnumerator: System.Collections.Generic.IEnumerator<KeyValue<String, JsonNode>>;
begin
  var props := GetProperties;
  exit props.GetEnumerator;
end;
{$ELSEIF NOUGAT}
method JsonObject.countByEnumeratingWithState(aState: ^NSFastEnumerationState) objects(stackbuf: ^KeyValue<String,JsonNode>) count(len: NSUInteger): NSUInteger;
begin
  if aState^.state <> 0 then
    exit 0;

  exit GetProperties.countByEnumeratingWithState(aState) objects(stackbuf) count(len);
end;
{$ENDIF}

end.
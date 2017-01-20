namespace Sugar.Json;

interface

uses
  Sugar,
  Sugar.Collections;

type
  JsonObject = public class (JsonNode, ISequence<KeyValuePair<String, JsonNode>>)
  private
    fItems: Dictionary<String, JsonNode>;

    method GetItem(Key: String): nullable JsonNode;
    method GetKeys: not nullable sequence of String;
    method GetProperties: sequence of KeyValuePair<String, JsonNode>; iterator;
  public
    constructor;
    constructor(aItems: Dictionary<String, JsonNode>);

    method &Add(Key: String; Value: nullable JsonNode);
    method Clear;
    method ContainsKey(Key: String): Boolean;
    method &Remove(Key: String): Boolean;

    method ToJson: String; override;

    {$IF COOPER}
    method &iterator: java.util.&Iterator<KeyValuePair<String, JsonNode>>;
    {$ELSEIF ECHOES}
    method GetNonGenericEnumerator: System.Collections.IEnumerator; implements System.Collections.IEnumerable.GetEnumerator;
    method GetEnumerator: System.Collections.Generic.IEnumerator<KeyValuePair<String, JsonNode>>;
    {$ELSEIF TOFFEE}
    method countByEnumeratingWithState(aState: ^NSFastEnumerationState) objects(stackbuf: ^KeyValuePair<String,JsonNode>) count(len: NSUInteger): NSUInteger;
    {$ENDIF}

    class method Load(JsonString: String): JsonObject;

    property Count: Integer read fItems.Count; override;
    property Item[Key: String]: nullable JsonNode read GetItem write Add; default; override;
    property Keys: not nullable sequence of String read GetKeys; override;
    property Properties: sequence of KeyValuePair<String, JsonNode> read GetProperties;
  end;

implementation

constructor JsonObject;
begin
  fItems := new Dictionary<String, JsonNode>();
end;

constructor JsonObject(aItems: Dictionary<String,JsonNode>);
begin
  fItems := aItems;
end;

method JsonObject.GetItem(Key: String): nullable JsonNode;
begin
  if fItems.ContainsKey(Key) then
    exit fItems[Key];
end;

method JsonObject.Add(Key: String; Value: nullable JsonNode);
begin
  fItems[Key] := Value;
end;

method JsonObject.Clear;
begin
  fItems.Clear;
end;

method JsonObject.ContainsKey(Key: String): Boolean;
begin
  exit fItems.ContainsKey(Key);
end;

method JsonObject.Remove(Key: String): Boolean;
begin
  exit fItems.Remove(Key);
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
  exit fItems.Keys as not nullable;
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
{$ELSEIF TOFFEE}
method JsonObject.countByEnumeratingWithState(aState: ^NSFastEnumerationState) objects(stackbuf: ^KeyValuePair<String,JsonNode>) count(len: NSUInteger): NSUInteger;
begin
  if aState^.state <> 0 then
    exit 0;

  exit GetProperties.countByEnumeratingWithState(aState) objects(stackbuf) count(len);
end;
{$ENDIF}

end.
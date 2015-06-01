namespace Sugar.Json;

interface

uses
  Sugar,
  Sugar.Json,
  Sugar.Collections;

type
  JsonArray = public class (JsonNode, ISequence<JsonNode>)
  private
    Items: List<JsonNode> := new List<JsonNode>;

    method GetItem(&Index: Integer): JsonNode;
    method SetItem(&Index: Integer; Value: JsonNode);
  public
    method &Add(Value: JsonNode);
    method Insert(&Index: Integer; Value: JsonNode);
    method Clear;
    method &RemoveAt(&Index: Integer);

    method ToJson: String; override;
     
    {$IF COOPER}
    method &iterator: java.util.&Iterator<JsonNode>;
    {$ELSEIF ECHOES}
    method GetNonGenericEnumerator: System.Collections.IEnumerator; implements System.Collections.IEnumerable.GetEnumerator;
    method GetEnumerator: System.Collections.Generic.IEnumerator<JsonNode>;
    {$ELSEIF NOUGAT}
    method countByEnumeratingWithState(aState: ^NSFastEnumerationState) objects(stackbuf: ^JsonNode) count(len: NSUInteger): NSUInteger;
    {$ENDIF}

    class method Load(JsonString: String): JsonArray;

    property Count: Integer read Items.Count;
    property Item[&Index: Integer]: JsonNode read GetItem write SetItem; default;
  end;

implementation

method JsonArray.GetItem(&Index: Integer): JsonNode;
begin
  exit Items[&Index];
end;

method JsonArray.SetItem(&Index: Integer; Value: JsonNode);
begin
  SugarArgumentNullException.RaiseIfNil(Value, "Value");
  Items[&Index] := Value;
end;

method JsonArray.Add(Value: JsonNode);
begin
  Items.Add(Value);
end;

method JsonArray.Insert(&Index: Integer; Value: JsonNode);
begin
  Items.Insert(&Index, Value);  
end;

method JsonArray.Clear;
begin
  Items.Clear;
end;

method JsonArray.RemoveAt(&Index: Integer);
begin
  Items.RemoveAt(&Index);
end;

class method JsonArray.Load(JsonString: String): JsonArray;
begin
  var Serializer := new JsonDeserializer(JsonString);
  var lValue := Serializer.Deserialize;

  if not (lValue is JsonArray) then
    raise new SugarInvalidOperationException("String does not contains valid Json array");

  result := lValue as JsonArray;
end;

method JsonArray.ToJson: String;
begin
  var Serializer := new JsonSerializer(self);
  exit Serializer.Serialize;
end;

{$IF COOPER}
method JsonArray.&iterator: java.util.Iterator<JsonNode>;
begin
  exit Iterable<JsonNode>(Items).iterator;
end;
{$ELSEIF ECHOES}
method JsonArray.GetNonGenericEnumerator: System.Collections.IEnumerator;
begin
  exit GetEnumerator;
end;

method JsonArray.GetEnumerator: System.Collections.Generic.IEnumerator<JsonNode>;
begin  
  exit System.Collections.Generic.IEnumerable<JsonNode>(Items).GetEnumerator;
end;
{$ELSEIF NOUGAT}
method JsonArray.countByEnumeratingWithState(aState: ^NSFastEnumerationState) objects(stackbuf: ^JsonNode) count(len: NSUInteger): NSUInteger;
begin
  exit NSArray(Items).countByEnumeratingWithState(aState) objects(^id(stackbuf)) count(len);
end;
{$ENDIF}

end.

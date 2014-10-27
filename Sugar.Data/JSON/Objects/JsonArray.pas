namespace Sugar.Data.JSON;

interface

uses
  Sugar,
  Sugar.Collections;

type
  JsonArray = public class (ISequence<JsonValue>)
  private
    Items: List<JsonValue> := new List<JsonValue>;

    method GetItem(&Index: Integer): JsonValue;
    method SetItem(&Index: Integer; Value: JsonValue);
  public
    method &Add(Value: Object);
    method AddValue(Value: JsonValue);
    method Insert(&Index: Integer; Value: Object);
    method InsertValue(&Index: Integer; Value: JsonValue);
    method Clear;
    method &RemoveAt(&Index: Integer);

    method ToJson: String;
    method {$IF NOUGAT}description: Foundation.NSString{$ELSEIF COOPER}ToString: java.lang.String{$ELSEIF ECHOES}ToString: System.String{$ENDIF}; override;

    {$IF COOPER}
    {$ELSEIF ECHOES}
    method GetNonGenericEnumerator: System.Collections.IEnumerator; implements System.Collections.IEnumerable.GetEnumerator;
    method GetEnumerator: System.Collections.Generic.IEnumerator<JsonValue>;
    {$ELSEIF NOUGAT}
    {$ENDIF}

    class method Load(JsonString: String): JsonArray;

    property Count: Integer read Items.Count;
    property Item[&Index: Integer]: JsonValue read GetItem write SetItem; default;
  end;

implementation

method JsonArray.GetItem(&Index: Integer): JsonValue;
begin
  exit Items[&Index];
end;

method JsonArray.SetItem(&Index: Integer; Value: JsonValue);
begin
  SugarArgumentNullException.RaiseIfNil(Value, "Value");
  Items[&Index] := Value;
end;

method JsonArray.Add(Value: Object);
begin
  AddValue(new JsonValue(Value));
end;

method JsonArray.AddValue(Value: JsonValue);
begin
  SugarArgumentNullException.RaiseIfNil(Value, "Value");
  Items.Add(Value);
end;

method JsonArray.Insert(&Index: Integer; Value: Object);
begin
  InsertValue(&Index, new JsonValue(Value));  
end;

method JsonArray.InsertValue(&Index: Integer; Value: JsonValue);
begin
  SugarArgumentNullException.RaiseIfNil(Value, "Value");
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

method JsonArray.{$IF NOUGAT}description: Foundation.NSString{$ELSEIF COOPER}ToString: java.lang.String{$ELSEIF ECHOES}ToString: System.String{$ENDIF};
begin
  exit String.Format("[array]: {0} items", Items.Count);
end;

class method JsonArray.Load(JsonString: String): JsonArray;
begin
  var Serializer := new JsonDeserializer(JsonString);
  var Value := Serializer.Deserialize;

  if Value.Kind <> JsonValueKind.Array then
    raise new Exception("Not an object");

  exit Value.ToArray;
end;

method JsonArray.ToJson: String;
begin
  var Serializer := new JsonSerializer(new JsonValue(self));
  exit Serializer.Serialize;
end;

{$IF COOPER}
{$ELSEIF ECHOES}
method JsonArray.GetNonGenericEnumerator: System.Collections.IEnumerator;
begin
  exit GetEnumerator;
end;

method JsonArray.GetEnumerator: System.Collections.Generic.IEnumerator<JsonValue>;
begin  
  exit System.Collections.Generic.IEnumerable<JsonValue>(Items).GetEnumerator;
end;
{$ELSEIF NOUGAT}
{$ENDIF}

end.

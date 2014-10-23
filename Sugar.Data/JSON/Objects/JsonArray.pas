namespace Sugar.Data.JSON;

interface

uses
  Sugar,
  Sugar.Collections;

type
  JsonArray = public class
  private
    Items: List<JsonValue> := new List<JsonValue>;

    method GetItem(&Index: Integer): JsonValue;
    method SetItem(&Index: Integer; Value: JsonValue);
  public
    method &Add(Value: JsonValue);
    method AddObject(Value: Object);
    method Insert(&Index: Integer; Value: JsonValue);
    method InsertObject(&Index: Integer; Value: Object);
    method Clear;
    method &RemoveAt(&Index: Integer);

    method ToJsonString: String; empty;
    method {$IF NOUGAT}description: Foundation.NSString{$ELSEIF COOPER}ToString: java.lang.String{$ELSEIF ECHOES}ToString: System.String{$ENDIF}; override;

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
  Items[&Index] := Value;
end;

method JsonArray.Add(Value: JsonValue);
begin
  Items.Add(Value);
end;

method JsonArray.AddObject(Value: Object);
begin
  &Add(new JsonValue(Value));
end;

method JsonArray.Insert(&Index: Integer; Value: JsonValue);
begin
  Items.Insert(&Index, Value);
end;

method JsonArray.InsertObject(&Index: Integer; Value: Object);
begin
  Insert(&Index, new JsonValue(Value));
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

end.

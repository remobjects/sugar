namespace Sugar.Data.JSON;

interface

uses
  Sugar,
  Sugar.Collections;

type
  JsonObject = public class
  private
    Items: Dictionary<String, JsonValue> := new Dictionary<String, JsonValue>;

    method GetItem(Key: String): JsonValue;
  public
    method &Add(Key: String; Value: JsonValue);
    method AddObject(Key: String; Value: Object);
    method Clear;
    method ContainsKey(Key: String): Boolean;
    method &Remove(Key: String): Boolean;

    method ToJsonString: String; empty;
    method {$IF NOUGAT}description: Foundation.NSString{$ELSEIF COOPER}ToString: java.lang.String{$ELSEIF ECHOES}ToString: System.String{$ENDIF}; override;

    class method Load(JsonString: String): JsonObject;

    property Count: Integer read Items.Count;
    property Item[Key: String]: JsonValue read GetItem write &Add; default;
  end;

implementation

method JsonObject.GetItem(Key: String): JsonValue;
begin
  exit Items[Key];
end;

method JsonObject.Add(Key: String; Value: JsonValue);
begin
  Items.Add(Key, Value);
end;

method JsonObject.AddObject(Key: String; Value: Object);
begin
  &Add(Key, new JsonValue(Value));
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

method JsonObject.{$IF NOUGAT}description: Foundation.NSString{$ELSEIF COOPER}ToString: java.lang.String{$ELSEIF ECHOES}ToString: System.String{$ENDIF};
begin
  exit String.Format("[object]: {0} items", Items.Count);
end;

class method JsonObject.Load(JsonString: String): JsonObject;
begin
  var Serializer := new JsonDeserializer(JsonString);
  var Value := Serializer.Deserialize;

  if Value.Kind <> JsonValueKind.Object then
    raise new Exception("Not an object");

  exit Value.ToObject;
end;

end.
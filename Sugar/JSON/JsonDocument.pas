namespace Sugar.Json;

interface

uses
  Sugar,
  Sugar.Collections,
  Sugar.IO;

type
  JsonDocument = public class
  private
    fRootObject: JsonObject;

    method GetRootObjectItem(Key: String): nullable JsonNode;
    method SetRootObjectItem(Key: String; Value: JsonNode);
    method GetRootObjectKeys: not nullable sequence of String;

    constructor(aRootObject: not nullable JsonObject);
  protected
  public
    property RootObject: JsonObject read fRootObject;

    class method FromFile(aFile: not nullable File): not nullable JsonDocument;
    class method FromBinary(aBinary: not nullable Binary; aEncoding: Encoding := nil): not nullable JsonDocument;
    class method FromString(aString: not nullable String): not nullable JsonDocument;
    class method CreateDocument: not nullable JsonDocument;

    constructor();
    
    {method Save(aFile: File);
    method Save(aFile: File; XmlDeclaration: XmlDocumentDeclaration);
    method Save(aFile: File; Version: String; Encoding: String; Standalone: Boolean);}
    method {$IF NOUGAT}description: Foundation.NSString{$ELSEIF COOPER}ToString: java.lang.String{$ELSEIF ECHOES}ToString: System.String{$ENDIF}; override;
    method ToJson: String;

    property Item[Key: String]: nullable JsonNode read GetRootObjectItem write SetRootObjectItem; default; virtual;
    property Keys: not nullable sequence of String read GetRootObjectKeys; virtual;
  end;

  JsonNode = public abstract class
  private
    method CantGetItem(Key: String): nullable JsonNode;
    method CantSetItem(Key: String; Value: JsonNode);
    method CantGetItem(aIndex: Integer): nullable JsonNode;
    method CantSetItem(aIndex: Integer; Value: JsonNode);
    method CantGetKeys: not nullable sequence of String;
    method GetIntegerValue: Int64;
    method GetFloatValue: Double;
    method GetBooleanValue: Boolean;
    method GetStringValue: String;
    method SetIntegerValue(aValue: Int64);
    method SetFloatValue(aValue: Double);
    method SetBooleanValue(aValue: Boolean);
    method SetStringValue(aValue: String);
  protected
  public
    method ToJson: String; virtual; abstract;
    method {$IF NOUGAT}description: Foundation.NSString{$ELSEIF COOPER}ToString: java.lang.String{$ELSEIF ECHOES}ToString: System.String{$ENDIF}; override;

    property Count: Integer read 1; virtual;
    property Item[Key: String]: nullable JsonNode read CantGetItem write CantSetItem; default; virtual;
    property Item[&Index: Integer]: JsonNode read CantGetItem write CantSetItem; default; virtual;
    property Keys: not nullable sequence of String read CantGetKeys; virtual;
    property IntegerValue: Int64 read GetIntegerValue write SetIntegerValue; virtual;
    property FloatValue: Double read GetFloatValue write SetFloatValue; virtual;
    property BooleanValue: Boolean read GetBooleanValue write SetBooleanValue; virtual;
    property StringValue: String read GetStringValue write SetStringValue; virtual;
  end;

implementation

{ JsonDocument }

constructor JsonDocument;
begin
  fRootObject := new JsonObject();
end;

constructor JsonDocument(aRootObject: not nullable JsonObject);
begin
  fRootObject := aRootObject;
end;

class method JsonDocument.FromFile(aFile: not nullable File): not nullable JsonDocument;
begin
  result := new JsonDocument(new JsonDeserializer(aFile.ReadText(Encoding.Default)).Deserialize as JsonObject)
end;

class method JsonDocument.FromBinary(aBinary: not nullable Binary; aEncoding: Encoding := nil): not nullable JsonDocument;
begin
  if aEncoding = nil then aEncoding := Encoding.Default;
  result := new JsonDocument(new JsonDeserializer(new String(aBinary.ToArray, aEncoding)).Deserialize as JsonObject);
end;

class method JsonDocument.FromString(aString: not nullable String): not nullable JsonDocument;
begin
  result := new JsonDocument(new JsonDeserializer(aString).Deserialize as JsonObject)
end;

class method JsonDocument.CreateDocument: not nullable JsonDocument;
begin
  result := new JsonDocument(new JsonObject());
end;

method JsonDocument.{$IF NOUGAT}description: Foundation.NSString{$ELSEIF COOPER}ToString: java.lang.String{$ELSEIF ECHOES}ToString: System.String{$ENDIF};
begin
  result := fRootObject.ToJson();
end;

method JsonDocument.ToJson: String;
begin
  result := fRootObject.ToJson();
end;

method JsonDocument.GetRootObjectItem(Key: String): nullable JsonNode;
begin
  result := fRootObject[Key];
end;

method JsonDocument.SetRootObjectItem(Key: String; Value: JsonNode);
begin
  fRootObject[Key] := Value;
end;

method JsonDocument.GetRootObjectKeys: not nullable sequence of String;
begin
  result := fRootObject.Keys;
end;

{ JsonNode }

method JsonNode.{$IF NOUGAT}description: Foundation.NSString{$ELSEIF COOPER}ToString: java.lang.String{$ELSEIF ECHOES}ToString: System.String{$ENDIF};
begin
  result := ToJson();
end;

method JsonNode.CantGetItem(Key: String): nullable JsonNode;
begin
  raise new SugarException("JSON Node is not a dictionary.")
end;

method JsonNode.CantSetItem(Key: String; Value: JsonNode);
begin
  raise new SugarException("JSON Node is not a dictionary.")
end;

method JsonNode.CantGetKeys: not nullable sequence of String;
begin
  raise new SugarException("JSON Node is not a dictionary.")
end;

method JsonNode.CantGetItem(aIndex: Integer): nullable JsonNode;
begin
  raise new SugarException("JSON Node is not an array.")
end;

method JsonNode.CantSetItem(aIndex: Integer; Value: JsonNode);
begin
  raise new SugarException("JSON Node is not an array.")
end;

method JsonNode.GetIntegerValue: Int64;
begin
  if self is JsonIntegerValue then
    result := (self as JsonIntegerValue).Value
  else if self is JsonFloatValue then
    result := Int64((self as JsonFloatValue).Value)
  else
    raise new SugarException("JSON Node is not an integer.")
end;

method JsonNode.GetFloatValue: Double;
begin
  if self is JsonIntegerValue then
    result := (self as JsonIntegerValue).Value
  else if self is JsonFloatValue then
    result := (self as JsonFloatValue).Value
  else
    raise new SugarException("JSON Node is not a float.")
end;

method JsonNode.GetBooleanValue: Boolean;
begin
  if self is JsonBooleanValue then
    result := (self as JsonBooleanValue).Value
  else
    raise new SugarException("JSON Node is not a boolean.")
end;

method JsonNode.GetStringValue: String;
begin
  if self is JsonStringValue then
    result := (self as JsonStringValue).Value
  else if self is JsonIntegerValue then
    result := (self as JsonIntegerValue).ToJson()
  else if self is JsonFloatValue then
    result := (self as JsonFloatValue).ToJson()
  else if self is JsonBooleanValue then
    result := (self as JsonBooleanValue).ToJson()
  else
    raise new SugarException("JSON Node is not a string.")
end;

method JsonNode.SetIntegerValue(aValue: Int64);
begin
  if self is JsonIntegerValue then
    (self as JsonIntegerValue).Value := aValue
  else if self is JsonFloatValue then
    (self as JsonFloatValue).Value := aValue
  else
    raise new SugarException("JSON Node is not an integer.")
end;

method JsonNode.SetFloatValue(aValue: Double);
begin
  if self is JsonFloatValue then
    (self as JsonFloatValue).Value := aValue
  else
    raise new SugarException("JSON Node is not a float.")
end;

method JsonNode.SetBooleanValue(aValue: Boolean);
begin
  if self is JsonBooleanValue then
    (self as JsonBooleanValue).Value := aValue
  else
    raise new SugarException("JSON Node is not a boolean.")
end;

method JsonNode.SetStringValue(aValue: String);
begin
  if self is JsonStringValue then
    (self as JsonStringValue).Value := aValue
  else
    raise new SugarException("JSON Node is not a string.")
end;

end.

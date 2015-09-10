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
    constructor(aRootObject: JsonObject);
  protected
  public
    property RootObject: JsonObject read fRootObject;

    class method FromFile(aFile: File): not nullable JsonDocument;
    class method FromBinary(aBinary: Binary; aEncoding: Encoding := nil): not nullable JsonDocument;
    class method FromString(aString: String): not nullable JsonDocument;
    class method CreateDocument: not nullable JsonDocument;
    
    {method Save(aFile: File);
    method Save(aFile: File; XmlDeclaration: XmlDocumentDeclaration);
    method Save(aFile: File; Version: String; Encoding: String; Standalone: Boolean);}
    method {$IF NOUGAT}description: Foundation.NSString{$ELSEIF COOPER}ToString: java.lang.String{$ELSEIF ECHOES}ToString: System.String{$ENDIF}; override;
    method ToJson: String;
  end;

  JsonNode = public abstract class
  private
  protected
  public
    method ToJson: String; virtual; abstract;
    method {$IF NOUGAT}description: Foundation.NSString{$ELSEIF COOPER}ToString: java.lang.String{$ELSEIF ECHOES}ToString: System.String{$ENDIF}; override;
  end;

implementation

{ JsonDocument }

constructor JsonDocument(aRootObject: JsonObject);
begin
  fRootObject := aRootObject;
end;

class method JsonDocument.FromFile(aFile: File): not nullable JsonDocument;
begin
  result := new JsonDocument(new JsonDeserializer(aFile.Path).Deserialize as JsonObject)
end;

class method JsonDocument.FromBinary(aBinary: Binary; aEncoding: Encoding := nil): not nullable JsonDocument;
begin
  if aEncoding = nil then aEncoding := Encoding.Default;
  result := new JsonDocument(new JsonDeserializer(new String(aBinary.ToArray, aEncoding)).Deserialize as JsonObject);
end;

class method JsonDocument.FromString(aString: String): not nullable JsonDocument;
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

{ JsonNode }

method JsonNode.{$IF NOUGAT}description: Foundation.NSString{$ELSEIF COOPER}ToString: java.lang.String{$ELSEIF ECHOES}ToString: System.String{$ENDIF};
begin
  result := ToJson();
end;

end.

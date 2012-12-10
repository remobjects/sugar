namespace RemObjects.Oxygene.Sugar;
{$HIDE W0} //supress case-mismatch errors
interface

uses
  RemObjects.Oxygene.Sugar.IO;

type
  {$IF COOPER}
  Properties = public class mapped to java.util.Properties
  public
    method Put(Key: String; Value: String); mapped to setProperty(Key, Value);
    method Get(Key: String; DefaultValue: String): String; mapped to getProperty(Key, DefaultValue);

    method Clear; mapped to clear;
    method Contains(Key: String): Boolean; mapped to containsKey(Key);
    method &Remove(Key: String); mapped to &remove(Key);

    method SaveToFile(Path: String);
    method LoadFromFile(Path: String);

    property Count: Integer read mapped.size;
  end;
  {$ELSEIF ECHOES} 
  Properties = public class
  private
    Items: System.Collections.Generic.Dictionary<String, String> := new System.Collections.Generic.Dictionary<String, String>;
  public
    method Put(Key: String; Value: String);
    method Get(Key: String; DefaultValue: String): String;

    method Clear;
    method Contains(Key: String): Boolean;
    method &Remove(Key: String);

    method SaveToFile(Path: String);
    method LoadFromFile(Path: String);

    property Count: Integer read Items.Count;
  end;
  {$ELSEIF NOUGAT}
  Properties = public class
  private
    Items: Foundation.NSMutableDictionary := new Foundation.NSMutableDictionary();
  public
    method Put(Key: String; Value: String);
    method Get(Key: String; DefaultValue: String): String;

    method Clear;
    method Contains(Key: String): Boolean;
    method &Remove(Key: String);

    method SaveToFile(Path: String);
    method LoadFromFile(Path: String);

    property Count: Integer read Items.Count;
  end;
  {$ENDIF}

implementation

{$IF ECHOES}
method Properties.Clear;
begin
  Items.Clear;
end;

method Properties.Contains(Key: String): Boolean;
begin
  exit Items.ContainsKey(Key);
end;

method Properties.Get(Key: String; DefaultValue: String): String;
begin
  exit iif(Items.ContainsKey(Key), Items[Key], DefaultValue);
end;

method Properties.Put(Key: String; Value: String);
begin
  if not Items.ContainsKey(Key) then
    Items.Add(Key, Value)
  else
    Items[Key] := Value;
end;

method Properties.Remove(Key: String);
begin
  Items.Remove(Key);
end;
{$ELSEIF NOUGAT} 
method Properties.Clear;
begin
  Items.removeAllObjects();
end;

method Properties.Contains(Key: String): Boolean;
begin
  exit Items.objectForKey(Key) <> nil;
end;

method Properties.Get(Key: String; DefaultValue: String): String;
begin
  result := Items.objectForKey(Key);
  if result = nil then
    exit DefaultValue;
end;

method Properties.Put(Key: String; Value: String);
begin  
  Items.setObject(Value) forKey(Key);
end;

method Properties.Remove(Key: String);
begin
  Items.removeObjectForKey(Key);
end;
{$ENDIF}

method Properties.SaveToFile(Path: String);
begin
  {$IF COOPER}
  var lFileStream := new java.io.FileOutputStream(Path);
  mapped.storeToXML(lFileStream, nil, "UTF-8");
  lFileStream.flush();
  lFileStream.close();
  {$ELSEIF ECHOES} 
  var Document := new System.Xml.XmlDocument;
  Document.AppendChild(Document.CreateXmlDeclaration("1.0", "UTF-8", nil));
  var Root := Document.AppendChild(Document.CreateElement("properties"));
  for each item in Items do begin
    var Element := System.Xml.XmlElement(Root.AppendChild(Document.CreateElement("entry")));
    Element.SetAttribute("key", item.Key);
    Element.InnerText := item.Value;
  end;

  Document.Save(Path);
  {$ELSEIF NOUGAT}
  Items.writeToFile(Path) atomically(true);
  {$ENDIF}
end;

method Properties.LoadFromFile(Path: String);
begin
  if not File.Exists(Path) then
    raise new SugarException();

  {$IF COOPER}
  var lFileStream := new java.io.FileInputStream(Path);
  mapped.loadFromXML(lFileStream);
  lFileStream.close();
  {$ELSEIF ECHOES} 
  var Document := new System.Xml.XmlDocument;
  Document.Load(Path);

  Clear;
  var Root := Document["properties"];
  for each Element: System.Xml.XmlElement in Root.ChildNodes do begin
    Items.Add(Element.GetAttribute("key"), Element.InnerText);
  end;
  {$ELSEIF NOUGAT}
  Clear;
  var lDictionary: Foundation.NSDictionary := Foundation.NSDictionary.dictionaryWithContentsOfFile(Path);
  Items.addEntriesFromDictionary(lDictionary);
  {$ENDIF}
end;

end.

namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.Xml,
  RemObjects.Elements.EUnit;

type
  DocumentTest = public class (Test)
  private
    Data: XmlDocument;
  public
    method Setup; override;
    method DocumentElement;
    method DocumentType;
    method NodeType;
    method Element;
    method AddChild;
    method RemoveChild;
    method ReplaceChild;
    method CreateAttribute;
    method CreateXmlNs;
    method CreateCDataSection;
    method CreateComment;
    method CreateElement;
    method CreateProcessingInstruction;
    method CreateTextNode;
    method GetElementsByTagName;
    method FromFile;
    method FromBinary;
    method FromString;
    method CreateDocument;
    method Save;
  end;

implementation

method DocumentTest.Setup;
begin
  Data := XmlDocument.CreateDocument;
  Assert.IsNotNil(Data);
end;

method DocumentTest.AddChild;
begin
  Assert.IsNil(Data.DocumentElement);
  Assert.AreEqual(Data.ChildCount, 0);
  Data.AddChild(Data.CreateElement("root"));
  Assert.IsNotNil(Data.DocumentElement);
  Assert.AreEqual(Data.ChildCount, 1);
  Assert.Throws(->Data.AddChild(Data.CreateElement("root"))); //only one root element
  Assert.Throws(->Data.AddChild(nil));
  Assert.Throws(->Data.AddChild(Data.CreateAttribute("id")));
  Assert.Throws(->Data.AddChild(Data.CreateTextNode("Test")));
  Data.AddChild(Data.CreateComment("Comment"));
  Assert.AreEqual(Data.ChildCount, 2);
  Data.AddChild(Data.CreateProcessingInstruction("xml-stylesheet", "type=""text/xsl"" href=""style.xsl"""));
end;

method DocumentTest.CreateAttribute;
begin
  var Item := Data.CreateElement("root");
  Assert.IsNotNil(Item);
  Data.AddChild(Item);
  Item.AddChild(Data.CreateXmlNs("cfg", "http://example.com/config/"));
  Assert.AreEqual(length(Item.GetAttributes), 1);
  Item := Data.CreateElement("item");
  Data.DocumentElement.AddChild(Item);  

  var Value := Data.CreateAttribute("id");
  Value.Value := "0";
  Assert.IsNotNil(Value);
  Item.SetAttributeNode(Value);
  Assert.AreEqual(length(Item.GetAttributes), 1);
  Assert.AreEqual(Item.GetAttribute("id"), "0");

  Value := Data.CreateAttribute("cfg:Saved", "http://example.com/config/");
  Value.Value := "true";
  Assert.IsNotNil(Value);
  Item.SetAttributeNode(Value);
  Assert.AreEqual(length(Item.GetAttributes), 2);
  Assert.AreEqual(Item.GetAttribute("Saved", "http://example.com/config/"), "true");

  Assert.Throws(->Data.CreateAttribute(nil));
  Assert.Throws(->Data.CreateAttribute("<xml>"));
  Assert.Throws(->Data.CreateAttribute(nil, "http://example.com/config/"));
  Assert.Throws(->Data.CreateAttribute("cfg:Saved", nil));
  Assert.Throws(->Data.CreateAttribute("<abc>", "http://example.com/config/"));
end;

method DocumentTest.CreateXmlNs;
begin
  var Item := Data.CreateElement("root");
  Assert.IsNotNil(Item);
  Data.AddChild(Item);
  Item.AddChild(Data.CreateXmlNs("cfg", "http://example.com/config/"));
  Assert.AreEqual(length(Item.GetAttributes), 1);
  Assert.Throws(->Data.CreateXmlNs(nil, "http://example.com/config/"));
  Assert.Throws(->Data.CreateXmlNs("cfg", nil));
  Assert.Throws(->Data.CreateXmlNs("<xml>", "http://example.com/config/"));
end;

method DocumentTest.CreateCDataSection;
begin
  var Item := Data.CreateElement("root");
  Assert.IsNotNil(Item);
  Data.AddChild(Item);

  var Value := Data.CreateCDataSection("Text");
  Assert.IsNotNil(Value);
  Item.AddChild(Value);
  Assert.AreEqual(Item.ChildCount, 1);
  Assert.AreEqual(Item[0].NodeType, XmlNodeType.CDATA);
  Assert.AreEqual(Item.ChildNodes[0].Value, "Text");
end;

method DocumentTest.CreateComment;
begin
  var Item := Data.CreateElement("root");
  Assert.IsNotNil(Item);
  Data.AddChild(Item);

  var Value := Data.CreateComment("Comment");
  Assert.IsNotNil(Value);
  Item.AddChild(Value);
  Assert.AreEqual(Item.ChildCount, 1);
  Assert.AreEqual(Item[0].NodeType, XmlNodeType.Comment);
  Assert.AreEqual(Item.ChildNodes[0].Value, "Comment");
end;

method DocumentTest.CreateDocument;
begin
  var Item := XmlDocument.CreateDocument;
  Assert.IsNotNil(Item);  
end;

method DocumentTest.CreateElement;
begin
  var Item := Data.CreateElement("root");
  Assert.IsNotNil(Item);
  Data.AddChild(Item);
  Assert.AreEqual(Data.ChildCount, 1);
  Assert.AreEqual(Data.Item[0].NodeType, XmlNodeType.Element);
  Assert.AreEqual(Data.Item[0].LocalName, "root");
end;

method DocumentTest.CreateProcessingInstruction;
begin
  var Item := Data.CreateElement("root");
  Assert.IsNotNil(Item);
  Data.AddChild(Item);

  var Value := Data.CreateProcessingInstruction("Custom", "Save=""true""");
  Assert.IsNotNil(Value);
  Item.AddChild(Value);
  Assert.AreEqual(Item.ChildCount, 1);
  Assert.AreEqual(Item[0].NodeType, XmlNodeType.ProcessingInstruction);
  Value := Item[0] as XmlProcessingInstruction;
  Assert.AreEqual(Value.Target, "Custom");
  Assert.AreEqual(Value.Data, "Save=""true""");
end;

method DocumentTest.CreateTextNode;
begin
 var Item := Data.CreateElement("root");
  Assert.IsNotNil(Item);
  Data.AddChild(Item);

  var Value := Data.CreateTextNode("Text");
  Assert.IsNotNil(Value);
  Item.AddChild(Value);
  Assert.AreEqual(Item.ChildCount, 1);
  Assert.AreEqual(Item[0].NodeType, XmlNodeType.Text);
  Assert.AreEqual(Item.ChildNodes[0].Value, "Text");
end;

method DocumentTest.DocumentElement;
begin
  Assert.IsNil(Data.DocumentElement);
  Assert.AreEqual(Data.ChildCount, 0);
  var Value := Data.CreateElement("root");
  Assert.IsNotNil(Value);
  Data.AddChild(Value);
  Assert.IsNotNil(Data.DocumentElement);
  Assert.AreEqual(Data.ChildCount, 1);
  Assert.IsTrue(Data.DocumentElement.Equals(Value));
end;

method DocumentTest.DocumentType;
begin
  Assert.IsNil(Data.DocumentType);
  Data := XmlDocument.FromString(XmlTestData.CharXml);
  Assert.IsNotNil(Data.DocumentType);
  Assert.AreEqual(Data.DocumentType.PublicId, "-//W3C//DTD XHTML 1.0 Transitional//EN");
  Assert.AreEqual(Data.DocumentType.SystemId, "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd");
end;

method DocumentTest.Element;
begin
  Data := XmlDocument.FromString(XmlTestData.PIXml);
  Assert.IsNotNil(Data.Element["Root"]);
  Assert.IsNotNil(Data["Readers"]);
  var Value := Data["User"];
  Assert.IsNotNil(Value);
  Assert.AreEqual(Value.GetAttribute("Name"), "First");
  Assert.IsNil(Data[nil]);
end;

method DocumentTest.FromBinary;
begin
  var Bin := new Binary(XmlTestData.PIXml.ToByteArray);
  Data := XmlDocument.FromBinary(Bin);
  Assert.IsNotNil(Data);
  Assert.AreEqual(Data.ChildCount, 3);
  Assert.IsNotNil(Data.Element["Root"]);
  Assert.IsNotNil(Data["Readers"]);
end;

method DocumentTest.FromFile;
begin
  var File := Sugar.IO.Folder.UserLocal.CreateFile("sugartest.xml", false);
  try
    //File.WriteText(XmlTestData.PIXml);
    Sugar.IO.FileUtils.WriteText(File.Path, XmlTestData.PIXml);
    Data := XmlDocument.FromFile(File);
    Assert.IsNotNil(Data);
    Assert.AreEqual(Data.ChildCount, 3);
    Assert.IsNotNil(Data.Element["Root"]);
    Assert.IsNotNil(Data["Readers"]);
  finally
    File.Delete;
  end;
end;

method DocumentTest.FromString;
begin
  Data := XmlDocument.FromString(XmlTestData.PIXml);
  Assert.IsNotNil(Data);
  Assert.AreEqual(Data.ChildCount, 3);
  Assert.IsNotNil(Data.Element["Root"]);
  Assert.IsNotNil(Data["Readers"]);
end;

method DocumentTest.GetElementsByTagName;
begin
  Data := XmlDocument.FromString(XmlTestData.PIXml);

  var Actual := Data.GetElementsByTagName("User");
  var Expected := new Sugar.Collections.List<String>;
  Expected.Add("First");
  Expected.Add("Second");
  Expected.Add("Third");
  Expected.Add("Admin");

  Assert.AreEqual(length(Actual), 4);
  for i: Integer := 0 to length(Actual) - 1 do begin
    Assert.AreEqual(Actual[i].NodeType, XmlNodeType.Element);
    Assert.IsTrue(Expected.Contains(Actual[i].GetAttribute("Name")));
  end;

  Actual := Data.GetElementsByTagName("mail", "http://example.com/config/");
  Assert.AreEqual(length(Actual), 1);
  Assert.AreEqual(Actual[0].NodeType, XmlNodeType.Element);
  Assert.AreEqual(Actual[0].Value, "first@example.com");
end;

method DocumentTest.NodeType;
begin
  Assert.AreEqual(Data.NodeType, XmlNodeType.Document);
end;

method DocumentTest.RemoveChild;
begin
  Assert.IsNil(Data.DocumentElement);
  Assert.AreEqual(Data.ChildCount, 0);
  Data.AddChild(Data.CreateElement("root"));
  Assert.IsNotNil(Data.DocumentElement);
  Assert.AreEqual(Data.ChildCount, 1);
  Data.RemoveChild(Data.DocumentElement);
  Assert.IsNil(Data.DocumentElement);
  Assert.AreEqual(Data.ChildCount, 0);
  Assert.Throws(->Data.RemoveChild(nil));
end;

method DocumentTest.ReplaceChild;
begin
  Assert.IsNil(Data.DocumentElement);
  Assert.AreEqual(Data.ChildCount, 0);
  Data.AddChild(Data.CreateElement("root"));
  Assert.IsNotNil(Data.DocumentElement);
  Assert.AreEqual(Data.ChildCount, 1);
  Assert.AreEqual(Data.DocumentElement.LocalName, "root");
  var Value := Data.CreateElement("items");
  Data.ReplaceChild(Data.DocumentElement, Value);
  Assert.AreEqual(Data.ChildCount, 1);
  Assert.AreEqual(Data.DocumentElement.LocalName, "items");
  Assert.Throws(->Data.ReplaceChild(nil, Data.DocumentElement));
  Assert.Throws(->Data.ReplaceChild(Data.DocumentElement, nil));
  Assert.Throws(->Data.ReplaceChild(Data.CreateElement("NotExisting"), Data.DocumentElement));
end;

method DocumentTest.Save;
begin
  var File := Sugar.IO.Folder.UserLocal.CreateFile("sugartest.xml", false);
  try
    Data := XmlDocument.FromString(XmlTestData.CharXml);
    Assert.IsNotNil(Data);
    Data.Save(File);

    Data := XmlDocument.FromFile(File);
    Assert.IsNotNil(Data);
    Assert.IsNotNil(Data.DocumentType);
    Assert.AreEqual(Data.DocumentType.PublicId, "-//W3C//DTD XHTML 1.0 Transitional//EN");
    Assert.AreEqual(Data.DocumentType.SystemId, "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd");
    Assert.IsNotNil(Data["Book"]);

    Data := XmlDocument.CreateDocument;
    Data.AddChild(Data.CreateElement("items"));
    Data.DocumentElement.AddChild(Data.CreateElement("item"));
    Data.DocumentElement.AddChild(Data.CreateElement("item"));
    Data.DocumentElement.AddChild(Data.CreateElement("item"));
    Data.Save(File, new XmlDocumentDeclaration("1.0", "UTF-8", true));
    
    Data := XmlDocument.FromFile(File);
    Assert.IsNotNil(Data);
    Assert.IsNil(Data.DocumentType);
    Assert.IsNotNil(Data.DocumentElement);
    Assert.AreEqual(Data.DocumentElement.LocalName, "items");
    Assert.AreEqual(Data.DocumentElement.ChildCount, 3);
  finally
    File.Delete;
  end;
end;

end.


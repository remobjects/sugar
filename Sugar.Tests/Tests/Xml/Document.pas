namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.Xml,
  Sugar.TestFramework;

type
  DocumentTest = public class (Testcase)
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
  Assert.IsNotNull(Data);
end;

method DocumentTest.AddChild;
begin
  Assert.IsNull(Data.DocumentElement);
  Assert.CheckInt(0, Data.ChildCount);
  Data.AddChild(Data.CreateElement("root"));
  Assert.IsNotNull(Data.DocumentElement);
  Assert.CheckInt(1, Data.ChildCount);
  Assert.IsException(->Data.AddChild(Data.CreateElement("root"))); //only one root element
  Assert.IsException(->Data.AddChild(nil));
  Assert.IsException(->Data.AddChild(Data.CreateAttribute("id")));
  Assert.IsException(->Data.AddChild(Data.CreateTextNode("Test")));
  Data.AddChild(Data.CreateComment("Comment"));
  Assert.CheckInt(2, Data.ChildCount);
  Data.AddChild(Data.CreateProcessingInstruction("xml-stylesheet", "type=""text/xsl"" href=""style.xsl"""));
end;

method DocumentTest.CreateAttribute;
begin
  var Item := Data.CreateElement("root");
  Assert.IsNotNull(Item);
  Data.AddChild(Item);
  Item.AddChild(Data.CreateXmlNs("cfg", "http://example.com/config/"));
  Assert.CheckInt(1, length(Item.Attributes));
  Item := Data.CreateElement("item");
  Data.DocumentElement.AddChild(Item);  

  var Value := Data.CreateAttribute("id");
  Value.Value := "0";
  Assert.IsNotNull(Value);
  Item.SetAttributeNode(Value);
  Assert.CheckInt(1, length(Item.Attributes));
  Assert.CheckString("0", Item.GetAttribute("id"));

  Value := Data.CreateAttribute("cfg:Saved", "http://example.com/config/");
  Value.Value := "true";
  Assert.IsNotNull(Value);
  Item.SetAttributeNode(Value);
  Assert.CheckInt(2, length(Item.Attributes));
  Assert.CheckString("true", Item.GetAttribute("Saved", "http://example.com/config/"));

  Assert.IsException(->Data.CreateAttribute(nil));
  Assert.IsException(->Data.CreateAttribute("<xml>"));
  Assert.IsException(->Data.CreateAttribute(nil, "http://example.com/config/"));
  Assert.IsException(->Data.CreateAttribute("cfg:Saved", nil));
  Assert.IsException(->Data.CreateAttribute("<abc>", "http://example.com/config/"));
end;

method DocumentTest.CreateXmlNs;
begin
  var Item := Data.CreateElement("root");
  Assert.IsNotNull(Item);
  Data.AddChild(Item);
  Item.AddChild(Data.CreateXmlNs("cfg", "http://example.com/config/"));
  Assert.CheckInt(1, length(Item.Attributes));
  Assert.IsException(->Data.CreateXmlNs(nil, "http://example.com/config/"));
  Assert.IsException(->Data.CreateXmlNs("cfg", nil));
  Assert.IsException(->Data.CreateXmlNs("<xml>", "http://example.com/config/"));
end;

method DocumentTest.CreateCDataSection;
begin
  var Item := Data.CreateElement("root");
  Assert.IsNotNull(Item);
  Data.AddChild(Item);

  var Value := Data.CreateCDataSection("Text");
  Assert.IsNotNull(Value);
  Item.AddChild(Value);
  Assert.CheckInt(1, Item.ChildCount);
  Assert.CheckBool(true, Item[0].NodeType = XmlNodeType.CDATA);
  Assert.CheckString("Text", Item.ChildNodes[0].Value);  
end;

method DocumentTest.CreateComment;
begin
  var Item := Data.CreateElement("root");
  Assert.IsNotNull(Item);
  Data.AddChild(Item);

  var Value := Data.CreateComment("Comment");
  Assert.IsNotNull(Value);
  Item.AddChild(Value);
  Assert.CheckInt(1, Item.ChildCount);
  Assert.CheckBool(true, Item[0].NodeType = XmlNodeType.Comment);
  Assert.CheckString("Comment", Item.ChildNodes[0].Value);
end;

method DocumentTest.CreateDocument;
begin
  var Item := XmlDocument.CreateDocument;
  Assert.IsNotNull(Item);  
end;

method DocumentTest.CreateElement;
begin
  var Item := Data.CreateElement("root");
  Assert.IsNotNull(Item);
  Data.AddChild(Item);
  Assert.CheckInt(1, Data.ChildCount);
  Assert.CheckBool(true, Data.Item[0].NodeType = XmlNodeType.Element);
  Assert.CheckString("root", Data.Item[0].LocalName);
end;

method DocumentTest.CreateProcessingInstruction;
begin
  var Item := Data.CreateElement("root");
  Assert.IsNotNull(Item);
  Data.AddChild(Item);

  var Value := Data.CreateProcessingInstruction("Custom", "Save=""true""");
  Assert.IsNotNull(Value);
  Item.AddChild(Value);
  Assert.CheckInt(1, Item.ChildCount);
  Assert.CheckBool(true, Item[0].NodeType = XmlNodeType.ProcessingInstruction);
  Value := Item[0] as XmlProcessingInstruction;
  Assert.CheckString("Custom", Value.Target);
  Assert.CheckString("Save=""true""", Value.Data);  
end;

method DocumentTest.CreateTextNode;
begin
 var Item := Data.CreateElement("root");
  Assert.IsNotNull(Item);
  Data.AddChild(Item);

  var Value := Data.CreateTextNode("Text");
  Assert.IsNotNull(Value);
  Item.AddChild(Value);
  Assert.CheckInt(1, Item.ChildCount);
  Assert.CheckBool(true, Item[0].NodeType = XmlNodeType.Text);
  Assert.CheckString("Text", Item.ChildNodes[0].Value);
end;

method DocumentTest.DocumentElement;
begin
  Assert.IsNull(Data.DocumentElement);
  Assert.CheckInt(0, Data.ChildCount);
  var Value := Data.CreateElement("root");
  Assert.IsNotNull(Value);
  Data.AddChild(Value);
  Assert.IsNotNull(Data.DocumentElement);
  Assert.CheckInt(1, Data.ChildCount);
  Assert.CheckBool(true, Data.DocumentElement.Equals(Value));
end;

method DocumentTest.DocumentType;
begin
  Assert.IsNull(Data.DocumentType);
  Data := XmlDocument.FromString(XmlTestData.CharXml);
  Assert.IsNotNull(Data.DocumentType);
  Assert.CheckString("-//W3C//DTD XHTML 1.0 Transitional//EN", Data.DocumentType.PublicId);
  Assert.CheckString("http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd", Data.DocumentType.SystemId);
end;

method DocumentTest.Element;
begin
  Data := XmlDocument.FromString(XmlTestData.PIXml);
  Assert.IsNotNull(Data.Element["Root"]);
  Assert.IsNotNull(Data["Readers"]);
  var Value := Data["User"];
  Assert.IsNotNull(Value);
  Assert.CheckString("First", Value.GetAttribute("Name"));
  Assert.IsNull(Data[nil]);
end;

method DocumentTest.FromBinary;
begin
  var Bin := new Binary(XmlTestData.PIXml.ToByteArray);
  Data := XmlDocument.FromBinary(Bin);
  Assert.IsNotNull(Data);
  Assert.CheckInt(3, Data.ChildCount);
  Assert.IsNotNull(Data.Element["Root"]);
  Assert.IsNotNull(Data["Readers"]);
end;

method DocumentTest.FromFile;
begin
  var File := Sugar.IO.Folder.UserLocal.CreateFile("sugartest.xml", false);
  try
    File.WriteText(XmlTestData.PIXml);
    Data := XmlDocument.FromFile(File);
    Assert.IsNotNull(Data);
    Assert.CheckInt(3, Data.ChildCount);
    Assert.IsNotNull(Data.Element["Root"]);
    Assert.IsNotNull(Data["Readers"]);
  finally
    File.Delete;
  end;
end;

method DocumentTest.FromString;
begin
  Data := XmlDocument.FromString(XmlTestData.PIXml);
  Assert.IsNotNull(Data);
  Assert.CheckInt(3, Data.ChildCount);
  Assert.IsNotNull(Data.Element["Root"]);
  Assert.IsNotNull(Data["Readers"]);
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

  Assert.CheckInt(4, length(Actual));
  for i: Integer := 0 to length(Actual) - 1 do begin
    Assert.CheckBool(true, Actual[i].NodeType = XmlNodeType.Element);
    Assert.CheckBool(true, Expected.Contains(Actual[i].GetAttribute("Name")));
  end;

  Actual := Data.GetElementsByTagName("mail", "http://example.com/config/");
  Assert.CheckInt(1, length(Actual));
  Assert.CheckBool(true, Actual[0].NodeType = XmlNodeType.Element);
  Assert.CheckString("first@example.com", Actual[0].Value);  
end;

method DocumentTest.NodeType;
begin
  Assert.CheckBool(true, Data.NodeType = XmlNodeType.Document);
end;

method DocumentTest.RemoveChild;
begin
  Assert.IsNull(Data.DocumentElement);
  Assert.CheckInt(0, Data.ChildCount);
  Data.AddChild(Data.CreateElement("root"));
  Assert.IsNotNull(Data.DocumentElement);
  Assert.CheckInt(1, Data.ChildCount);
  Data.RemoveChild(Data.DocumentElement);
  Assert.IsNull(Data.DocumentElement);
  Assert.CheckInt(0, Data.ChildCount);
  Assert.IsException(->Data.RemoveChild(nil));
end;

method DocumentTest.ReplaceChild;
begin
  Assert.IsNull(Data.DocumentElement);
  Assert.CheckInt(0, Data.ChildCount);
  Data.AddChild(Data.CreateElement("root"));
  Assert.IsNotNull(Data.DocumentElement);
  Assert.CheckInt(1, Data.ChildCount);
  Assert.CheckString("root", Data.DocumentElement.LocalName);
  var Value := Data.CreateElement("items");
  Data.ReplaceChild(Data.DocumentElement, Value);
  Assert.CheckInt(1, Data.ChildCount);
  Assert.CheckString("items", Data.DocumentElement.LocalName);
  Assert.IsException(->Data.ReplaceChild(nil, Data.DocumentElement));
  Assert.IsException(->Data.ReplaceChild(Data.DocumentElement, nil));
  Assert.IsException(->Data.ReplaceChild(Data.CreateElement("NotExisting"), Data.DocumentElement));
end;

method DocumentTest.Save;
begin
  var File := Sugar.IO.Folder.UserLocal.CreateFile("sugartest.xml", false);
  try
    Data := XmlDocument.FromString(XmlTestData.CharXml);
    Assert.IsNotNull(Data);
    Data.Save(File);

    Data := XmlDocument.FromFile(File);
    Assert.IsNotNull(Data);
    Assert.IsNotNull(Data.DocumentType);
    Assert.CheckString("-//W3C//DTD XHTML 1.0 Transitional//EN", Data.DocumentType.PublicId);
    Assert.CheckString("http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd", Data.DocumentType.SystemId);
    Assert.IsNotNull(Data["Book"]);

    Data := XmlDocument.CreateDocument;
    Data.AddChild(Data.CreateElement("items"));
    Data.DocumentElement.AddChild(Data.CreateElement("item"));
    Data.DocumentElement.AddChild(Data.CreateElement("item"));
    Data.DocumentElement.AddChild(Data.CreateElement("item"));
    Data.Save(File, new XmlDocumentDeclaration("1.0", "UTF-8", true));
    
    Data := XmlDocument.FromFile(File);
    Assert.IsNotNull(Data);
    Assert.IsNull(Data.DocumentType);
    Assert.IsNotNull(Data.DocumentElement);
    Assert.CheckString("items", Data.DocumentElement.LocalName);
    Assert.CheckInt(3, Data.DocumentElement.ChildCount);
  finally
    File.Delete;
  end;
end;

end.


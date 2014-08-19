namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.Xml,
  RemObjects.Elements.EUnit;

type
  ElementTest = public class (Test)
  private
    Doc: XmlDocument;
    Data: XmlElement;
  public
    method Setup; override;

    method AddChild;
    method RemoveChild;
    method ReplaceChild;
    method GetAttribute;
    method GetAttributeNode;
    method SetAttribute;
    method SetAttirubteNS;
    method SetAttributeNode;
    method SetAttributeNodeNS;
    method RemoveAttribute;
    method RemoveAttributeNode;
    method HasAttribute;    
    method Attributes;
    method NodeType;
    method GetElementsByTagName;
    method Inserting;
  end;

implementation

method ElementTest.Setup;
begin
  Doc := XmlDocument.FromString(XmlTestData.PIXml);
  Assert.IsNotNil(Doc);
  Data := Doc["Root"];
  Assert.IsNotNil(Doc);
end;

method ElementTest.AddChild;
begin
  var Node := Data.FirstChild as XmlElement;
  Assert.IsNotNil(Node);

  Assert.AreEqual(Node.ChildCount, 3);
  var lValue := Doc.CreateElement("User");
  Node.AddChild(lValue);
  Assert.AreEqual(Node.ChildCount, 4);

  Assert.AreEqual(Data.LastChild.ChildCount, 1);
  lValue := Data.LastChild.FirstChild as XmlElement;  
  Node.AddChild(lValue);
  Assert.AreEqual(Node.ChildCount, 5);
  Assert.AreEqual(Data.LastChild.ChildCount, 0);

  Assert.Throws(->Node.AddChild(nil));
end;

method ElementTest.RemoveChild;
begin
  var Node := Data.FirstChild as XmlElement;
  Assert.IsNotNil(Node);

  Assert.AreEqual(Node.ChildCount, 3);
  var lValue := Node.FirstChild;
  Node.RemoveChild(lValue);
  Assert.AreEqual(Node.ChildCount, 2);
  Node.AddChild(lValue);
  Assert.AreEqual(Node.ChildCount, 3);

  Assert.Throws(->Node.RemoveChild(nil));
end;

method ElementTest.ReplaceChild;
begin
  var Node := Data.FirstChild as XmlElement;
  Assert.IsNotNil(Node);

  Assert.AreEqual(Node.ChildCount, 3);
  var lValue := Doc.CreateElement("Test");
  var lExisting := Node.FirstChild;
  Node.ReplaceChild(lExisting, lValue);
  Assert.AreEqual(Node.ChildCount, 3);
  Assert.AreEqual(Node.FirstChild.LocalName, "Test");

  Assert.Throws(->Node.ReplaceChild(nil, lValue));
  Assert.Throws(->Node.ReplaceChild(lValue, nil));
  Assert.Throws(->Node.ReplaceChild(lExisting, lValue)); //not exists

  lExisting := Node.FirstChild;
  lValue := Data.LastChild.FirstChild as XmlElement;
  Node.ReplaceChild(lExisting, lValue);
  Assert.AreEqual(XmlElement(Node.FirstChild).GetAttribute("Name"), "Admin");
  Assert.AreEqual(Data.LastChild.ChildCount, 0);
end;

method ElementTest.GetAttribute;
begin
  var Node := Data.FirstChild.FirstChild as XmlElement;
  Assert.IsNotNil(Node);

  Assert.AreEqual(Node.GetAttribute("Name"), "First");
  Assert.AreEqual(Node.GetAttribute("Id"), "1");
  Assert.IsNil(Node.GetAttribute(nil));
  Assert.IsNil(Node.GetAttribute("NotExisting"));

  Node := Node.FirstChild.FirstChild as XmlElement;
  Assert.AreEqual(Node.GetAttribute("verified", "http://example.com/config/"), "true");
  Assert.IsNil(Node.GetAttribute("verified", "http://example.com/cfg/"));
  Assert.IsNil(Node.GetAttribute("x", "http://example.com/config/"));
  Assert.Throws(->Node.GetAttribute("verified", nil));
  Assert.Throws(->Node.GetAttribute(nil, "http://example.com/config/"));
end;

method ElementTest.GetAttributeNode;
begin
  var Node := Data.FirstChild.FirstChild as XmlElement;
  Assert.IsNotNil(Node);

  Assert.AreEqual(Node.GetAttributeNode("Name"):Value, "First");
  Assert.AreEqual(Node.GetAttributeNode("Id"):Value, "1");
  Assert.IsNil(Node.GetAttributeNode(nil));
  Assert.IsNil(Node.GetAttributeNode("NotExisting"));

  Node := Node.FirstChild.FirstChild as XmlElement;
  Assert.AreEqual(Node.GetAttributeNode("verified", "http://example.com/config/"):Value, "true");
  Assert.IsNil(Node.GetAttributeNode("verified", "http://example.com/cfg/"));
  Assert.IsNil(Node.GetAttributeNode("x", "http://example.com/config/"));
  Assert.Throws(->Node.GetAttributeNode("verified", nil));
  Assert.Throws(->Node.GetAttributeNode(nil, "http://example.com/config/"));
end;

method ElementTest.SetAttribute;
begin
  var Node := Data.FirstChild.FirstChild as XmlElement;
  Assert.IsNotNil(Node);

  Assert.AreEqual(length(Node.GetAttributes), 2);
  Node.SetAttribute("Logged", "YES");
  Assert.AreEqual(length(Node.GetAttributes), 3);
  Assert.AreEqual(Node.GetAttribute("Logged"), "YES");

  //replace existing
  Node.SetAttribute("Logged", "NO");
  Assert.AreEqual(length(Node.GetAttributes), 3);
  Assert.AreEqual(Node.GetAttribute("Logged"), "NO");

  Node.SetAttribute("Logged", "");
  Assert.AreEqual(length(Node.GetAttributes), 3);
  Assert.AreEqual(Node.GetAttribute("Logged"), "");

  //Remove
  Node.SetAttribute("Logged", nil);
  Assert.AreEqual(length(Node.GetAttributes), 2);

  Assert.Throws(->Node.SetAttribute(nil, "true"));  
end;

method ElementTest.SetAttirubteNS;
begin
  var Node := Data.FirstChild.FirstChild.FirstChild.FirstChild as XmlElement;
  Assert.IsNotNil(Node);

  Assert.AreEqual(length(Node.GetAttributes), 1);
  Node.SetAttribute("Logged", "http://example.com/config/","YES");
  Assert.AreEqual(length(Node.GetAttributes), 2);
  Assert.AreEqual(Node.GetAttribute("Logged", "http://example.com/config/"), "YES");

  //replace existing
  Node.SetAttribute("Logged", "http://example.com/config/" ,"NO");
  Assert.AreEqual(length(Node.GetAttributes), 2);
  Assert.AreEqual(Node.GetAttribute("Logged", "http://example.com/config/"), "NO");

  Node.SetAttribute("Logged", "http://example.com/config/", "");
  Assert.AreEqual(length(Node.GetAttributes), 2);
  Assert.AreEqual(Node.GetAttribute("Logged", "http://example.com/config/"), "");

  //Remove
  Node.SetAttribute("Logged", "http://example.com/config/", nil);
  Assert.AreEqual(length(Node.GetAttributes), 1);

  Assert.Throws(->Node.SetAttribute(nil, "http://example.com/config/", "true"));  
  Assert.Throws(->Node.SetAttribute("Logged", nil, "true"));
end;

method ElementTest.SetAttributeNode;
begin
  var Node := Data.FirstChild.FirstChild as XmlElement;
  var Attr := Doc.CreateAttribute("Logged");
  Attr.Value := "YES";
  Assert.IsNotNil(Attr);

  Assert.AreEqual(length(Node.GetAttributes), 2);
  Node.SetAttributeNode(Attr);
  Assert.AreEqual(length(Node.GetAttributes), 3);
  Assert.AreEqual(Node.GetAttribute("Logged"), "YES");
  Attr.Value := "TEST"; // changing value
  Assert.AreEqual(Node.GetAttribute("Logged"), "TEST");

  //replace existing
  Attr := Doc.CreateAttribute("Logged");
  Attr.Value := "NO";
  Node.SetAttributeNode(Attr);
  Assert.AreEqual(length(Node.GetAttributes), 3);
  Assert.AreEqual(Node.GetAttribute("Logged"), "NO");

  Assert.Throws(->Node.SetAttributeNode(nil));  
end;

method ElementTest.SetAttributeNodeNS;
begin
  var Node := Data.FirstChild.FirstChild.FirstChild.FirstChild as XmlElement;
  var Attr := Doc.CreateAttribute("cfg:Logged", "http://example.com/config/");
  Attr.Value := "YES";
  Assert.IsNotNil(Node);

  Assert.AreEqual(length(Node.GetAttributes), 1);
  Node.SetAttributeNode(Attr);
  Assert.AreEqual(length(Node.GetAttributes), 2);
  Assert.AreEqual(Node.GetAttribute("Logged", "http://example.com/config/"), "YES");
  Attr.Value := "TEST";
  Assert.AreEqual(Node.GetAttribute("Logged", "http://example.com/config/"), "TEST");

  //replace existing
  Attr := Doc.CreateAttribute("cfg:Logged", "http://example.com/config/");
  Attr.Value := "NO";
  Node.SetAttributeNode(Attr);
  Assert.AreEqual(length(Node.GetAttributes), 2);
  Assert.AreEqual(Node.GetAttribute("Logged", "http://example.com/config/"), "NO");
end;

method ElementTest.RemoveAttribute;
begin
  var Node := Data.FirstChild.FirstChild as XmlElement;

  Assert.AreEqual(length(Node.GetAttributes), 2);
  Node.RemoveAttribute("Id");
  Assert.AreEqual(length(Node.GetAttributes), 1);
  Assert.IsNil(Node.GetAttribute("Id"));

  Node.RemoveAttribute(nil);
  Assert.AreEqual(length(Node.GetAttributes), 1);
  Node.RemoveAttribute("NotExisting");
  Assert.AreEqual(length(Node.GetAttributes), 1);

  Node := Node.FirstChild.FirstChild as XmlElement;
  Assert.AreEqual(length(Node.GetAttributes), 1);
  Node.RemoveAttribute("verified", "http://example.com/config/");
  Assert.AreEqual(length(Node.GetAttributes), 0);

  Assert.Throws(->Node.RemoveAttribute(nil, "http://example.com/config/"));
  Assert.Throws(->Node.RemoveAttribute("verified", nil));
end;

method ElementTest.RemoveAttributeNode;
begin
  var Node := Data.FirstChild.FirstChild as XmlElement;

  Assert.AreEqual(length(Node.GetAttributes), 2);
  Node.RemoveAttributeNode(Node.GetAttributeNode("Id"));
  Assert.AreEqual(length(Node.GetAttributes), 1);
  Assert.IsNil(Node.GetAttribute("Id"));

  Assert.Throws(->Node.RemoveAttributeNode(nil));
  Assert.Throws(->Node.RemoveAttributeNode(Doc.CreateAttribute("NotExists")));

  Node := Node.FirstChild.FirstChild as XmlElement;
  Assert.AreEqual(length(Node.GetAttributes), 1);
  Node.RemoveAttributeNode(Node.GetAttributeNode("verified", "http://example.com/config/"));
  Assert.AreEqual(length(Node.GetAttributes), 0);
end;

method ElementTest.HasAttribute;
begin
  var Node := Data.FirstChild.FirstChild as XmlElement;

  Assert.IsTrue(Node.HasAttribute("Name"));
  Assert.IsTrue(Node.HasAttribute("Id"));
  Assert.IsFalse(Node.HasAttribute("NameX"));
  Assert.IsFalse(Node.HasAttribute(nil));

  Node := Node.FirstChild.FirstChild as XmlElement;
  Assert.IsTrue(Node.HasAttribute("verified", "http://example.com/config/"));
  Assert.IsFalse(Node.HasAttribute("verified", ""));
  Assert.IsFalse(Node.HasAttribute("verifiedX", "http://example.com/config/"));
  Assert.Throws(->Node.HasAttribute("verifiedX", nil));
  Assert.Throws(->Node.HasAttribute(nil, "http://example.com/config/"));
end;

method ElementTest.Attributes;
begin
  var Node := Data.FirstChild.FirstChild as XmlElement;
  var Expected := new Sugar.Collections.List<String>;
  Expected.Add("Name");
  Expected.Add("Id");
  
  Assert.AreEqual(length(Node.GetAttributes), 2);
  for i: Integer := 0 to length(Node.GetAttributes) - 1 do
    Assert.IsTrue(Expected.Contains(Node.GetAttributes[i].Name));

  Node := Doc.CreateElement("Sample");
  Assert.AreEqual(length(Node.GetAttributes), 0);
end;

method ElementTest.NodeType;
begin
  Assert.IsTrue(Data.NodeType = XmlNodeType.Element);
end;

method ElementTest.GetElementsByTagName;
begin
  //Must retrieve elements with specified tag name from all descendants
  var Actual := Data.GetElementsByTagName("User");
  var Expected := new Sugar.Collections.List<String>;
  Expected.Add("First");
  Expected.Add("Second");
  Expected.Add("Third");
  Expected.Add("Admin");

  Assert.AreEqual(length(Actual), 4);
  for i: Integer := 0 to length(Actual) - 1 do begin
    Assert.AreEqual(Actual[i].NodeType, XmlNodeType.Element);
    var Element := Actual[i] as XmlElement;
    Assert.IsTrue(Expected.Contains(Element.GetAttribute("Name")));
  end;

  Actual := Data.GetElementsByTagName("mail", "http://example.com/config/");
  Assert.AreEqual(length(Actual), 1);
  Assert.IsTrue(Actual[0].NodeType = XmlNodeType.Element);
  Assert.AreEqual(Actual[0].Value, "first@example.com");
end;

method ElementTest.Inserting;
begin
  var Root := Doc.CreateElement("Test");
  Assert.IsNotNil(Root);
  //Attribute
  var Element: XmlNode := Doc.CreateAttribute("Id");
  Assert.IsNotNil(Element);
  Root.AddChild(Element);
  Assert.AreEqual(Root.ChildCount, 0);
  Assert.AreEqual(length(Root.GetAttributes), 1);
  //Element
  Element := Doc.CreateElement("SubNode");
  Assert.IsNotNil(Element);
  Root.AddChild(Element);
  Assert.AreEqual(Root.ChildCount, 1);
  //cdata
  XmlElement(Element).AddChild(Doc.CreateCDataSection("String"));
  Assert.AreEqual(Element.ChildCount, 1);
  Assert.AreEqual(Element.ChildNodes[0].NodeType, XmlNodeType.CDATA);
  //text
  Element := Doc.CreateElement("SubNode");
  Root.AddChild(Element);
  Assert.AreEqual(Root.ChildCount, 2);
  XmlElement(Element).AddChild(Doc.CreateTextNode("String"));
  Assert.AreEqual(Element.ChildCount, 1);
  Assert.AreEqual(Element.ChildNodes[0].NodeType, XmlNodeType.Text);
  //comment
  Element := Doc.CreateComment("Comment");
  Assert.IsNotNil(Element);
  Root.AddChild(Element);
  Assert.AreEqual(Root.ChildCount, 3);
  //PI
  Element := Doc.CreateProcessingInstruction("custom", "");
  Assert.IsNotNil(Element);
  Root.AddChild(Element);
  Assert.AreEqual(Root.ChildCount, 4);
end;

end.


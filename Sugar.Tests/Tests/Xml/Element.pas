namespace Sugar.Test;

interface

{$HIDE W0} //supress case-mismatch errors

uses
  Sugar,
  Sugar.Xml,
  Sugar.TestFramework;

type
  ElementTest = public class (Testcase)
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
  Assert.IsNotNull(Doc);
  Data := Doc["Root"];
  Assert.IsNotNull(Doc);
end;

method ElementTest.AddChild;
begin
  var Node := Data.FirstChild as XmlElement;
  Assert.IsNotNull(Node);

  Assert.CheckInt(3, Node.ChildCount);
  var lValue := Doc.CreateElement("User");
  Node.AddChild(lValue);
  Assert.CheckInt(4, Node.ChildCount);

  Assert.CheckInt(1, Data.LastChild.ChildCount);
  lValue := Data.LastChild.FirstChild as XmlElement;  
  Node.AddChild(lValue);
  Assert.CheckInt(5, Node.ChildCount);
  Assert.CheckInt(0, Data.LastChild.ChildCount);

  Assert.IsException(->Node.AddChild(nil));
end;

method ElementTest.RemoveChild;
begin
  var Node := Data.FirstChild as XmlElement;
  Assert.IsNotNull(Node);

  Assert.CheckInt(3, Node.ChildCount);
  var lValue := Node.FirstChild;
  Node.RemoveChild(lValue);
  Assert.CheckInt(2, Node.ChildCount);
  Node.AddChild(lValue);
  Assert.CheckInt(3, Node.ChildCount);

  Assert.IsException(->Node.RemoveChild(nil));
end;

method ElementTest.ReplaceChild;
begin
  var Node := Data.FirstChild as XmlElement;
  Assert.IsNotNull(Node);

  Assert.CheckInt(3, Node.ChildCount);
  var lValue := Doc.CreateElement("Test");
  var lExisting := Node.FirstChild;
  Node.ReplaceChild(lExisting, lValue);
  Assert.CheckInt(3, Node.ChildCount);
  Assert.CheckString("Test", Node.FirstChild.LocalName);

  Assert.IsException(->Node.ReplaceChild(nil, lValue));
  Assert.IsException(->Node.ReplaceChild(lValue, nil));
  Assert.IsException(->Node.ReplaceChild(lExisting, lValue)); //not exists

  lExisting := Node.FirstChild;
  lValue := Data.LastChild.FirstChild as XmlElement;
  Node.ReplaceChild(lExisting, lValue);
  Assert.CheckString("Admin", XmlElement(Node.FirstChild).GetAttribute("Name"));
  Assert.CheckInt(0, Data.LastChild.ChildCount);
end;

method ElementTest.GetAttribute;
begin
  var Node := Data.FirstChild.FirstChild as XmlElement;
  Assert.IsNotNull(Node);

  Assert.CheckString("First", Node.GetAttribute("Name"));
  Assert.CheckString("1", Node.GetAttribute("Id"));
  Assert.IsNull(Node.GetAttribute(nil));
  Assert.IsNull(Node.GetAttribute("NotExisting"));

  Node := Node.FirstChild.FirstChild as XmlElement;
  Assert.CheckString("true", Node.GetAttribute("verified", "http://example.com/config/"));
  Assert.IsNull(Node.GetAttribute("verified", "http://example.com/cfg/"));
  Assert.IsNull(Node.GetAttribute("x", "http://example.com/config/"));
  Assert.IsException(->Node.GetAttribute("verified", nil));
  Assert.IsException(->Node.GetAttribute(nil, "http://example.com/config/"));
end;

method ElementTest.GetAttributeNode;
begin
  var Node := Data.FirstChild.FirstChild as XmlElement;
  Assert.IsNotNull(Node);

  Assert.CheckString("First", Node.GetAttributeNode("Name"):Value);
  Assert.CheckString("1", Node.GetAttributeNode("Id"):Value);
  Assert.IsNull(Node.GetAttributeNode(nil));
  Assert.IsNull(Node.GetAttributeNode("NotExisting"));

  Node := Node.FirstChild.FirstChild as XmlElement;
  Assert.CheckString("true", Node.GetAttributeNode("verified", "http://example.com/config/"):Value);
  Assert.IsNull(Node.GetAttributeNode("verified", "http://example.com/cfg/"));
  Assert.IsNull(Node.GetAttributeNode("x", "http://example.com/config/"));
  Assert.IsException(->Node.GetAttributeNode("verified", nil));
  Assert.IsException(->Node.GetAttributeNode(nil, "http://example.com/config/"));
end;

method ElementTest.SetAttribute;
begin
  var Node := Data.FirstChild.FirstChild as XmlElement;
  Assert.IsNotNull(Node);

  Assert.CheckInt(2, length(Node.Attributes));
  Node.SetAttribute("Logged", "YES");
  Assert.CheckInt(3, length(Node.Attributes));
  Assert.CheckString("YES", Node.GetAttribute("Logged"));

  //replace existing
  Node.SetAttribute("Logged", "NO");
  Assert.CheckInt(3, length(Node.Attributes));
  Assert.CheckString("NO", Node.GetAttribute("Logged"));

  Node.SetAttribute("Logged", "");
  Assert.CheckInt(3, length(Node.Attributes));
  Assert.CheckString("", Node.GetAttribute("Logged"));

  //Remove
  Node.SetAttribute("Logged", nil);
  Assert.CheckInt(2, length(Node.Attributes));

  Assert.IsException(->Node.SetAttribute(nil, "true"));  
end;

method ElementTest.SetAttirubteNS;
begin
  var Node := Data.FirstChild.FirstChild.FirstChild.FirstChild as XmlElement;
  Assert.IsNotNull(Node);

  Assert.CheckInt(1, length(Node.Attributes));
  Node.SetAttribute("Logged", "http://example.com/config/","YES");
  Assert.CheckInt(2, length(Node.Attributes));
  Assert.CheckString("YES", Node.GetAttribute("Logged", "http://example.com/config/"));

  //replace existing
  Node.SetAttribute("Logged", "http://example.com/config/" ,"NO");
  Assert.CheckInt(2, length(Node.Attributes));
  Assert.CheckString("NO", Node.GetAttribute("Logged", "http://example.com/config/"));

  Node.SetAttribute("Logged", "http://example.com/config/", "");
  Assert.CheckInt(2, length(Node.Attributes));
  Assert.CheckString("", Node.GetAttribute("Logged", "http://example.com/config/"));

  //Remove
  Node.SetAttribute("Logged", "http://example.com/config/", nil);
  Assert.CheckInt(1, length(Node.Attributes));

  Assert.IsException(->Node.SetAttribute(nil, "http://example.com/config/", "true"));  
  Assert.IsException(->Node.SetAttribute("Logged", nil, "true"));
end;

method ElementTest.SetAttributeNode;
begin
  var Node := Data.FirstChild.FirstChild as XmlElement;
  var Attr := Doc.CreateAttribute("Logged");
  Attr.Value := "YES";
  Assert.IsNotNull(Attr);

  Assert.CheckInt(2, length(Node.Attributes));
  Node.SetAttributeNode(Attr);
  Assert.CheckInt(3, length(Node.Attributes));
  Assert.CheckString("YES", Node.GetAttribute("Logged"));
  Attr.Value := "TEST"; // changing value
  Assert.CheckString("TEST", Node.GetAttribute("Logged"));

  //replace existing
  Attr := Doc.CreateAttribute("Logged");
  Attr.Value := "NO";
  Node.SetAttributeNode(Attr);
  Assert.CheckInt(3, length(Node.Attributes));
  Assert.CheckString("NO", Node.GetAttribute("Logged"));

  Assert.IsException(->Node.SetAttributeNode(nil));  
end;

method ElementTest.SetAttributeNodeNS;
begin
  var Node := Data.FirstChild.FirstChild.FirstChild.FirstChild as XmlElement;
  var Attr := Doc.CreateAttribute("cfg:Logged", "http://example.com/config/");
  Attr.Value := "YES";
  Assert.IsNotNull(Node);

  Assert.CheckInt(1, length(Node.Attributes));
  Node.SetAttributeNode(Attr);
  Assert.CheckInt(2, length(Node.Attributes));
  Assert.CheckString("YES", Node.GetAttribute("Logged", "http://example.com/config/"));
  Attr.Value := "TEST";
  Assert.CheckString("TEST", Node.GetAttribute("Logged", "http://example.com/config/"));

  //replace existing
  Attr := Doc.CreateAttribute("cfg:Logged", "http://example.com/config/");
  Attr.Value := "NO";
  Node.SetAttributeNode(Attr);
  Assert.CheckInt(2, length(Node.Attributes));
  Assert.CheckString("NO", Node.GetAttribute("Logged", "http://example.com/config/"));  
end;

method ElementTest.RemoveAttribute;
begin
  var Node := Data.FirstChild.FirstChild as XmlElement;

  Assert.CheckInt(2, length(Node.Attributes));
  Node.RemoveAttribute("Id");
  Assert.CheckInt(1, length(Node.Attributes));
  Assert.IsNull(Node.GetAttribute("Id"));

  Node.RemoveAttribute(nil);
  Assert.CheckInt(1, length(Node.Attributes));
  Node.RemoveAttribute("NotExisting");
  Assert.CheckInt(1, length(Node.Attributes));

  Node := Node.FirstChild.FirstChild as XmlElement;
  Assert.CheckInt(1, length(Node.Attributes));
  Node.RemoveAttribute("verified", "http://example.com/config/");
  Assert.CheckInt(0, length(Node.Attributes));

  Assert.IsException(->Node.RemoveAttribute(nil, "http://example.com/config/"));
  Assert.IsException(->Node.RemoveAttribute("verified", nil));
end;

method ElementTest.RemoveAttributeNode;
begin
  var Node := Data.FirstChild.FirstChild as XmlElement;

  Assert.CheckInt(2, length(Node.Attributes));
  Node.RemoveAttributeNode(Node.GetAttributeNode("Id"));
  Assert.CheckInt(1, length(Node.Attributes));
  Assert.IsNull(Node.GetAttribute("Id"));

  Assert.IsException(->Node.RemoveAttributeNode(nil));
  Assert.IsException(->Node.RemoveAttributeNode(Doc.CreateAttribute("NotExists")));

  Node := Node.FirstChild.FirstChild as XmlElement;
  Assert.CheckInt(1, length(Node.Attributes));
  Node.RemoveAttributeNode(Node.GetAttributeNode("verified", "http://example.com/config/"));
  Assert.CheckInt(0, length(Node.Attributes));
end;

method ElementTest.HasAttribute;
begin
  var Node := Data.FirstChild.FirstChild as XmlElement;

  Assert.CheckBool(true, Node.HasAttribute("Name"));
  Assert.CheckBool(true, Node.HasAttribute("Id"));
  Assert.CheckBool(false, Node.HasAttribute("NameX"));
  Assert.CheckBool(false, Node.HasAttribute(nil));

  Node := Node.FirstChild.FirstChild as XmlElement;
  Assert.CheckBool(true, Node.HasAttribute("verified", "http://example.com/config/"));
  Assert.CheckBool(false, Node.HasAttribute("verified", ""));
  Assert.CheckBool(false, Node.HasAttribute("verifiedX", "http://example.com/config/"));
  Assert.IsException(->Node.HasAttribute("verifiedX", nil));
  Assert.IsException(->Node.HasAttribute(nil, "http://example.com/config/"));
end;

method ElementTest.Attributes;
begin
  var Node := Data.FirstChild.FirstChild as XmlElement;
  var Expected := new Sugar.Collections.List<String>;
  Expected.Add("Name");
  Expected.Add("Id");
  
  Assert.CheckInt(2, length(Node.Attributes));
  for i: Integer := 0 to length(Node.Attributes) - 1 do
    Assert.CheckBool(true, Expected.Contains(Node.Attributes[i].Name));

  Node := Doc.CreateElement("Sample");
  Assert.CheckInt(0, length(Node.Attributes));
end;

method ElementTest.NodeType;
begin
  Assert.CheckBool(true, Data.NodeType = XmlNodeType.Element);
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

  Assert.CheckInt(4, length(Actual));
  for i: Integer := 0 to length(Actual) - 1 do begin
    Assert.CheckBool(true, Actual[i].NodeType = XmlNodeType.Element);
    var Element := Actual[i] as XmlElement;
    Assert.CheckBool(true, Expected.Contains(Element.GetAttribute("Name")));
  end;

  Actual := Data.GetElementsByTagName("mail", "http://example.com/config/");
  Assert.CheckInt(1, length(Actual));
  Assert.CheckBool(true, Actual[0].NodeType = XmlNodeType.Element);
  Assert.CheckString("first@example.com", Actual[0].Value);
end;

method ElementTest.Inserting;
begin
  var Root := Doc.CreateElement("Test");
  Assert.IsNotNull(Root);
  //Attribute
  var Element: XmlNode := Doc.CreateAttribute("Id");
  Assert.IsNotNull(Element);
  Root.AddChild(Element);
  Assert.CheckInt(0, Root.ChildCount);
  Assert.CheckInt(1, length(Root.Attributes));
  //Element
  Element := Doc.CreateElement("SubNode");
  Assert.IsNotNull(Element);
  Root.AddChild(Element);
  Assert.CheckInt(1, Root.ChildCount);
  //cdata
  XmlElement(Element).AddChild(Doc.CreateCDataSection("String"));
  Assert.CheckInt(1, Element.ChildCount);
  Assert.CheckBool(true, Element.ChildNodes[0].NodeType = XmlNodeType.CDATA);
  //text
  Element := Doc.CreateElement("SubNode");
  Root.AddChild(Element);
  Assert.CheckInt(2, Root.ChildCount);
  XmlElement(Element).AddChild(Doc.CreateTextNode("String"));
  Assert.CheckInt(1, Element.ChildCount);
  Assert.CheckBool(true, Element.ChildNodes[0].NodeType = XmlNodeType.Text);
  //comment
  Element := Doc.CreateComment("Comment");
  Assert.IsNotNull(Element);
  Root.AddChild(Element);
  Assert.CheckInt(3, Root.ChildCount);
  //PI
  Element := Doc.CreateProcessingInstruction("custom", "");
  Assert.IsNotNull(Element);
  Root.AddChild(Element);
  Assert.CheckInt(4, Root.ChildCount);
end;

end.


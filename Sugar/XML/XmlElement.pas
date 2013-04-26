namespace RemObjects.Oxygene.Sugar.Xml;

{$HIDE W0} //supress case-mismatch errors

interface

uses
  {$IF COOPER}
  org.w3c.dom,
  {$ELSEIF ECHOES}
  System.Xml.Linq,
  System.Linq,
  {$ELSEIF NOUGAT}
  Foundation,
  {$ENDIF}
  RemObjects.Oxygene.Sugar;

type
  XmlElement = public class (XmlNode)
  private
    property Element: {$IF COOPER}Element{$ELSEIF ECHOES}XElement{$ELSEIF NOUGAT}NSXMLElement{$ENDIF} 
                      read Node as{$IF COOPER}Element{$ELSEIF ECHOES}XElement{$ELSEIF NOUGAT}NSXMLElement{$ENDIF};
    method GetAttributes: array of XmlAttribute;
  public
    {$IF ECHOES}
    property Name: String read Element.Name.ToString; override;
    property LocalName: String read Element.Name.LocalName; override;
    property Value: String read Element.Value write Element.Value; override;
    property InnerText: String read Element.Value write Element.Value; override;
    {$ENDIF}

    method AddChild(Node: XmlNode);
    method RemoveChild(Node: XmlNode);
    method ReplaceChild(Node: XmlNode; WithNode: XmlNode);

    method GetAttribute(aName: String): String;
    method GetAttribute(aLocalName, NamespaceUri: String): String;
    method GetAttributeNode(aName: String): XmlAttribute;
    method GetAttributeNode(aLocalName, NamespaceUri: String): XmlAttribute;

    method SetAttribute(aName, aValue: String);
    method SetAttribute(aLocalName, NamespaceUri, aValue: String);
    method SetAttributeNode(Node: XmlAttribute): XmlAttribute;

    method RemoveAttribute(aName: String);
    method RemoveAttribute(aLocalName, NamespaceUri: String);
    method RemoveAttributeNode(Node: XmlAttribute): XmlAttribute;

    method HasAttribute(aName: String): Boolean;
    method HasAttribute(aLocalName, NamespaceUri: String): Boolean;
    
    property Attributes: array of XmlAttribute read GetAttributes;
  end;
implementation

{$IF ECHOES}
method XmlElement.GetAttributes: array of XmlAttribute;
begin
  var items := Element.Attributes:ToArray;
  if items = nil then
    exit new XmlAttribute[0];

  result := new XmlAttribute[items.Length];
  for i: Integer := 0 to items.Length-1 do
    result[i] := new XmlAttribute(items[i]);
end;

method XmlElement.AddChild(Node: XmlNode);
begin
  Element.Add(Node.Node);
end;

method XmlElement.RemoveChild(Node: XmlNode);
begin
  (Node.Node as XNode):&Remove;
end;

method XmlElement.ReplaceChild(Node: XmlNode; WithNode: XmlNode);
begin
  (Node.Node as XNode):ReplaceWith(WithNode.Node);
end;

method XmlElement.GetAttribute(aName: String): String;
begin
  exit GetAttributeNode(aName):Value;
end;

method XmlElement.GetAttribute(aLocalName: String; NamespaceUri: String): String;
begin
  exit GetAttributeNode(aLocalName, NamespaceUri):Value;
end;

method XmlElement.GetAttributeNode(aName: String): XmlAttribute;
begin
  var attr := Element.Attribute(System.String(aName));
  if attr = nil then
    exit nil;
  exit new XmlAttribute(attr);
end;

method XmlElement.GetAttributeNode(aLocalName: String; NamespaceUri: String): XmlAttribute;
begin
  var attr := Element.Attribute(XNamespace(NamespaceUri) + aLocalName);
  if attr = nil then
    exit nil;
  exit new XmlAttribute(attr);
end;

method XmlElement.SetAttribute(aName: String; aValue: String);
begin
  Element.SetAttributeValue(aName, aValue);
end;

method XmlElement.SetAttribute(aLocalName: String; NamespaceUri: String; aValue: String);
begin
  Element.SetAttributeValue(XNamespace(NamespaceUri) + aLocalName, aValue);
end;

method XmlElement.SetAttributeNode(Node: XmlAttribute): XmlAttribute;
begin
  var existing := GetAttributeNode(Node.Name);
  SetAttribute(Node.Name, Node.Value);
  exit existing;
end;

method XmlElement.RemoveAttribute(aName: String);
begin
  Element.SetAttributeValue(aName, nil);
end;

method XmlElement.RemoveAttribute(aLocalName: String; NamespaceUri: String);
begin
  Element.SetAttributeValue(XNamespace(NamespaceUri) + aLocalName, nil);
end;

method XmlElement.RemoveAttributeNode(Node: XmlAttribute): XmlAttribute;
begin
  var existing := GetAttributeNode(Node.Name);
  RemoveAttribute(Node.Name);
  exit existing;
end;

method XmlElement.HasAttribute(aName: String): Boolean;
begin
  exit GetAttributeNode(aName) <> nil;
end;

method XmlElement.HasAttribute(aLocalName: String; NamespaceUri: String): Boolean;
begin
  exit GetAttributeNode(aLocalName, NamespaceUri) <> nil;
end;
{$ELSEIF COOPER}
method XmlElement.AddChild(Node: XmlNode);
begin
  Element.appendChild(Node.Node);
end;

method XmlElement.RemoveChild(Node: XmlNode);
begin
  Element.removeChild(Node.Node);
end;

method XmlElement.ReplaceChild(Node: XmlNode; WithNode: XmlNode);
begin
  Element.replaceChild(WithNode.Node, Node.Node);
end;

method XmlElement.GetAttributes: array of XmlAttribute;
begin
  var ItemsCount: Integer := Element.Attributes.Length;
  var lItems: array of XmlAttribute := new XmlAttribute[ItemsCount];
  for i: Integer := 0 to ItemsCount-1 do
    lItems[i] := new XmlAttribute(Element.Attributes.Item(i));

  exit lItems;
end;

method XmlElement.GetAttribute(aName: String): String;
begin
  exit Element.GetAttribute(aName);
end;

method XmlElement.GetAttribute(aLocalName: String; NamespaceUri: String): String;
begin
  exit Element.getAttributeNS(NamespaceUri, aLocalName);
end;

method XmlElement.GetAttributeNode(aName: String): XmlAttribute;
begin
  var lResult := Element.GetAttributeNode(aName);
  if lResult <> nil then
    exit new XmlAttribute(lResult);
end;

method XmlElement.GetAttributeNode(aLocalName: String; NamespaceUri: String): XmlAttribute;
begin
  var lResult := Element.getAttributeNodeNS(NamespaceUri, aLocalName);
  if lResult <> nil then
    exit new XmlAttribute(lResult);
end;

method XmlElement.SetAttribute(aName: String; aValue: String);
begin
  Element.SetAttribute(aName, aValue);
end;

method XmlElement.SetAttribute(aLocalName: String; NamespaceUri: String; aValue: String);
begin
  Element.setAttributeNS(NamespaceUri, aLocalName, aValue); 
end;

method XmlElement.SetAttributeNode(Node: XmlAttribute): XmlAttribute;
begin
  exit new XmlAttribute(Element.setAttributeNode(Node.Node as Attr));
end;

method XmlElement.RemoveAttribute(aName: String);
begin
  Element.RemoveAttribute(aName);
end;

method XmlElement.RemoveAttribute(aLocalName: String; NamespaceUri: String);
begin
  Element.removeAttributeNS(NamespaceUri, aLocalName);
end;

method XmlElement.RemoveAttributeNode(Node: XmlAttribute): XmlAttribute;
begin
  exit new XmlAttribute(Element.removeAttributeNode(Node.Node as Attr));
end;

method XmlElement.HasAttribute(aName: String): Boolean;
begin
  exit Element.HasAttribute(aName);
end;

method XmlElement.HasAttribute(aLocalName: String; NamespaceUri: String): Boolean;
begin
  exit Element.hasAttributeNS(NamespaceUri, aLocalName);
end;

{$ELSEIF NOUGAT}

method XmlElement.AddChild(Node: XmlNode);
begin
  Element.addChild(Node.Node);
end;

method XmlElement.GetAttribute(aLocalName: String; NamespaceUri: String): String;
begin
  var Node := Element.attributeForLocalName(aLocalName) URI(NamespaceUri);
  exit Node:stringValue;
end;

method XmlElement.GetAttribute(aName: String): String;
begin
  exit Element.attributeForName(aName):stringValue;
end;

method XmlElement.GetAttributeNode(aLocalName: String; NamespaceUri: String): XmlAttribute;
begin
  var Node := Element.attributeForLocalName(aLocalName) URI(NamespaceUri);
  if Node <> nil then
    exit new XmlAttribute withNode(Node);
end;

method XmlElement.GetAttributeNode(aName: String): XmlAttribute;
begin
  var Node := Element.attributeForName(aName);
  if Node <> nil then
    exit new XmlAttribute withNode(Node);
end;

method XmlElement.GetAttributes: array of XmlAttribute;
begin
  var lAttributes := Element.attributes;
  if lAttributes = nil then
    exit nil;

  result := new XmlAttribute[lAttributes.count];
  for i: Integer := 0 to lAttributes.count-1 do
    result[i] := new XmlAttribute withNode(lAttributes.objectAtIndex(i));
end;

method XmlElement.HasAttribute(aLocalName: String; NamespaceUri: String): Boolean;
begin
  exit Element.attributeForLocalName(aLocalName) URI(NamespaceUri) <> nil;
end;

method XmlElement.HasAttribute(aName: String): Boolean;
begin
  exit Element.attributeForName(aName) <> nil;
end;

method XmlElement.RemoveAttribute(aLocalName: String; NamespaceUri: String);
begin
  var lAttribute := GetAttributeNode(aLocalName, NamespaceUri);
  RemoveAttributeNode(lAttribute);
end;

method XmlElement.RemoveAttribute(aName: String);
begin
  Element.removeAttributeForName(aName);
end;

method XmlElement.RemoveAttributeNode(Node: XmlAttribute): XmlAttribute;
begin
  if not HasAttribute(Node.Name) then
    exit nil;

  Element.removeAttributeForName(Node.Name);
  exit Node;
end;

method XmlElement.RemoveChild(Node: XmlNode);
begin
  Element.removeChildAtIndex(Node.Node.index);
end;

method XmlElement.ReplaceChild(Node: XmlNode; WithNode: XmlNode);
begin
  Element.replaceChildAtIndex(Node.Node.index) withNode(WithNode.Node);
end;

method XmlElement.SetAttribute(aLocalName: String; NamespaceUri: String; aValue: String);
begin
  var lNode := NSXMLNode.attributeWithName(aLocalName) URI(NamespaceUri) stringValue(aValue);
  Element.addAttribute(lNode);
end;

method XmlElement.SetAttribute(aName: String; aValue: String);
begin
  var lNode := NSXMLNode.attributeWithName(Name) stringValue(aValue);
  Element.addAttribute(lNode);
end;

method XmlElement.SetAttributeNode(Node: XmlAttribute): XmlAttribute;
begin
  Element.addAttribute(Node.Node);
end;
{$ENDIF}

end.

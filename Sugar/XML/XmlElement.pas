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
    {$IF NOT NOUGAT}
    property Element: {$IF COOPER}Element{$ELSEIF ECHOES}XElement{$ENDIF} 
                      read Node as{$IF COOPER}Element{$ELSEIF ECHOES}XElement{$ENDIF};
    {$ENDIF}
    method GetAttributes: array of XmlAttribute;
    {$IF NOUGAT}
    method CopyNS(aNode: XmlAttribute);
    {$ENDIF}
  public
    {$IF ECHOES}
    property Name: String read Element.Name.ToString; override;
    property LocalName: String read Element.Name.LocalName; override;
    property Value: String read Element.Value write Element.Value; override;
    {$ENDIF}

    method AddChild(aNode: XmlNode);
    method RemoveChild(aNode: XmlNode);
    method ReplaceChild(aNode: XmlNode; WithNode: XmlNode);

    method GetAttribute(aName: String): String;
    method GetAttribute(aLocalName, NamespaceUri: String): String;
    method GetAttributeNode(aName: String): XmlAttribute;
    method GetAttributeNode(aLocalName, NamespaceUri: String): XmlAttribute;

    method SetAttribute(aName, aValue: String);
    method SetAttribute(aLocalName, NamespaceUri, aValue: String);
    method SetAttributeNode(Node: XmlAttribute);

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

method XmlElement.AddChild(aNode: XmlNode);
begin
  if aNode.Node.Parent <> nil then
    RemoveChild(aNode);

  Element.Add(aNode.Node);
end;

method XmlElement.RemoveChild(aNode: XmlNode);
begin
  (aNode.Node as XNode):&Remove;
end;

method XmlElement.ReplaceChild(aNode: XmlNode; WithNode: XmlNode);
begin
  if WithNode.Node.Parent <> nil then
    RemoveChild(WithNode);

  (aNode.Node as XNode):ReplaceWith(WithNode.Node);
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

method XmlElement.SetAttributeNode(Node: XmlAttribute);
begin
  var Existing := Element.Attribute(XAttribute(Node.Node).Name);
  if Existing <> nil then
    Existing.Remove;

  Element.Add(Node.Node);
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
method XmlElement.AddChild(aNode: XmlNode);
begin
  Element.appendChild(aNode.Node);
end;

method XmlElement.RemoveChild(aNode: XmlNode);
begin
  Element.removeChild(aNode.Node);
end;

method XmlElement.ReplaceChild(aNode: XmlNode; WithNode: XmlNode);
begin
  Element.replaceChild(WithNode.Node, aNode.Node);
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
  exit GetAttributeNode(aName):Value;
end;

method XmlElement.GetAttribute(aLocalName: String; NamespaceUri: String): String;
begin
  exit GetAttributeNode(aLocalName, NamespaceUri):Value;
end;

method XmlElement.GetAttributeNode(aName: String): XmlAttribute;
begin
  if aName = nil then
    exit nil;

  var lResult := Element.GetAttributeNode(aName);
  if lResult <> nil then
    exit new XmlAttribute(lResult);
end;

method XmlElement.GetAttributeNode(aLocalName: String; NamespaceUri: String): XmlAttribute;
begin
  SugarArgumentNullException.RaiseIfNil(aLocalName, "LocalName");
  SugarArgumentNullException.RaiseIfNil(NamespaceUri, "NamespaceUri");

  var lResult := Element.getAttributeNodeNS(NamespaceUri, aLocalName);
  if lResult <> nil then
    exit new XmlAttribute(lResult);
end;

method XmlElement.SetAttribute(aName: String; aValue: String);
begin
  SugarArgumentNullException.RaiseIfNil(aName, "Name");

  if aValue = nil then begin
    RemoveAttribute(aName);
    exit;
  end;

  Element.SetAttribute(aName, aValue);
end;

method XmlElement.SetAttribute(aLocalName: String; NamespaceUri: String; aValue: String);
begin
  SugarArgumentNullException.RaiseIfNil(aLocalName, "LocalName");
  SugarArgumentNullException.RaiseIfNil(NamespaceUri, "NamespaceUri");

  if aValue = nil then begin
    RemoveAttribute(aLocalName, NamespaceUri);
    exit;
  end;

  Element.setAttributeNS(NamespaceUri, aLocalName, aValue); 
end;

method XmlElement.SetAttributeNode(Node: XmlAttribute);
begin
 Element.setAttributeNode(Node.Node as Attr);
end;

method XmlElement.RemoveAttribute(aName: String);
begin
  if aName = nil then
    exit;

  Element.RemoveAttribute(aName);
end;

method XmlElement.RemoveAttribute(aLocalName: String; NamespaceUri: String);
begin
  SugarArgumentNullException.RaiseIfNil(aLocalName, "LocalName");
  SugarArgumentNullException.RaiseIfNil(NamespaceUri, "NamespaceUri");

  Element.removeAttributeNS(NamespaceUri, aLocalName);
end;

method XmlElement.RemoveAttributeNode(Node: XmlAttribute): XmlAttribute;
begin
  SugarArgumentNullException.RaiseIfNil(Node, "Node");
  try
    exit new XmlAttribute(Element.removeAttributeNode(Node.Node as Attr));
  except
    exit nil;
  end;  
end;

method XmlElement.HasAttribute(aName: String): Boolean;
begin
  if aName = nil then
    exit false;

  exit Element.HasAttribute(aName);
end;

method XmlElement.HasAttribute(aLocalName: String; NamespaceUri: String): Boolean;
begin
  SugarArgumentNullException.RaiseIfNil(aLocalName, "LocalName");
  SugarArgumentNullException.RaiseIfNil(NamespaceUri, "NamespaceUri");

  exit Element.hasAttributeNS(NamespaceUri, aLocalName);
end;

{$ELSEIF NOUGAT}
method XmlElement.GetAttributes: array of XmlAttribute;
begin
  var List := new RemObjects.Oxygene.Sugar.Collections.List<XmlAttribute>;
  var ChildPtr := Node^.properties;
  while ChildPtr <> nil do begin
    List.Add(new XmlAttribute(^libxml.__struct__xmlNode(ChildPtr), Document));    
    ChildPtr := ^libxml.__struct__xmlAttr(ChildPtr^.next);
  end;
  
  result := List.ToArray;
end;

method XmlElement.AddChild(aNode: XmlNode);
begin
  if aNode.Node^.parent <> nil then
    libxml.xmlUnlinkNode(libxml.xmlNodePtr(aNode.Node));

  var NewNode := libxml.xmlAddChild(libxml.xmlNodePtr(Node), libxml.xmlNodePtr(aNode.Node));
  aNode.Node := ^libxml.__struct__xmlNode(NewNode);
end;

method XmlElement.RemoveChild(aNode: XmlNode);
begin
  libxml.xmlUnlinkNode(libxml.xmlNodePtr(aNode.Node));
  //libxml.xmlFreeNode(libxml.xmlNodePtr(aNode.Node));
end;

method XmlElement.ReplaceChild(aNode: XmlNode; WithNode: XmlNode);
begin
  if aNode.Node^.parent = nil then
    raise new SugarInvalidOperationException("Unable to replace element without parent");

  libxml.xmlReplaceNode(libxml.xmlNodePtr(aNode.Node), libxml.xmlNodePtr(WithNode.Node));
end;

method XmlElement.GetAttribute(aName: String): String;
begin
  if aName = nil then
    exit nil;

  var Value := libxml.xmlGetProp(libxml.xmlNodePtr(Node), XmlChar.FromString(aName));
  if Value = nil then
    exit nil;

  exit XmlChar.ToString(Value, true);
end;

method XmlElement.GetAttribute(aLocalName: String; NamespaceUri: String): String;
begin
  SugarArgumentNullException.RaiseIfNil(aLocalName, "LocalName");
  SugarArgumentNullException.RaiseIfNil(NamespaceUri, "NamespaceUri");

  var Value := libxml.xmlGetNsProp(libxml.xmlNodePtr(Node), XmlChar.FromString(aLocalName), XmlChar.FromString(NamespaceUri));
  if Value = nil then
    exit nil;

  exit XmlChar.ToString(Value, true);
end;

method XmlElement.GetAttributeNode(aName: String): XmlAttribute;
begin
  if aName = nil then
    exit nil;

  var Attr := libxml.xmlHasProp(libxml.xmlNodePtr(Node), XmlChar.FromString(aName));
  if Attr = nil then
    exit nil;

  exit new XmlAttribute(^libxml.__struct__xmlNode(Attr), Document);
end;

method XmlElement.GetAttributeNode(aLocalName: String; NamespaceUri: String): XmlAttribute;
begin
  SugarArgumentNullException.RaiseIfNil(aLocalName, "LocalName");
  SugarArgumentNullException.RaiseIfNil(NamespaceUri, "NamespaceUri");

  var Attr := libxml.xmlHasNsProp(libxml.xmlNodePtr(Node), XmlChar.FromString(aLocalName), XmlChar.FromString(NamespaceUri));
  if Attr = nil then
    exit nil;

  exit new XmlAttribute(^libxml.__struct__xmlNode(Attr), Document);
end;

method XmlElement.SetAttribute(aName: String; aValue: String);
begin
  if aValue = nil then begin
    RemoveAttribute(aName);
    exit;
  end;

  libxml.xmlSetProp(libxml.xmlNodePtr(Node), XmlChar.FromString(aName), XmlChar.FromString(aValue));
end;

method XmlElement.SetAttribute(aLocalName: String; NamespaceUri: String; aValue: String);
begin
  SugarArgumentNullException.RaiseIfNil(aLocalName, "LocalName");
  SugarArgumentNullException.RaiseIfNil(NamespaceUri, "NamespaceUri");

  if aValue = nil then begin
    RemoveAttribute(aLocalName, NamespaceUri);
    exit;
  end;

  var ns := libxml.xmlSearchNsByHref(libxml.xmlDocPtr(Node^.doc), libxml.xmlNodePtr(Node), XmlChar.FromString(NamespaceUri));

  //no namespace with specified uri
  if ns = nil then
    raise new SugarException("Namespace with specified URI not found");

  libxml.xmlSetNsProp(libxml.xmlNodePtr(Node), ns, XmlChar.FromString(aLocalName), XmlChar.FromString(aValue));
end;

method XmlElement.SetAttributeNode(Node: XmlAttribute);
begin
  if Node.Node^.parent <> nil then
    raise new SugarException("Unable to insert attribute that is already owned by other element");

  AddChild(Node);
  CopyNS(Node);
end;

method XmlElement.RemoveAttribute(aName: String);
begin
  if aName = nil then
    exit;

  libxml.xmlUnsetProp(libxml.xmlNodePtr(Node), XmlChar.FromString(aName));
end;

method XmlElement.RemoveAttribute(aLocalName: String; NamespaceUri: String);
begin
  SugarArgumentNullException.RaiseIfNil(aLocalName, "LocalName");
  SugarArgumentNullException.RaiseIfNil(NamespaceUri, "NamespaceUri");

  var Attr := libxml.xmlHasNsProp(libxml.xmlNodePtr(Node), XmlChar.FromString(aLocalName), XmlChar.FromString(NamespaceUri));
  if Attr = nil then
    exit;

  libxml.xmlRemoveProp(Attr);
end;

method XmlElement.RemoveAttributeNode(Node: XmlAttribute): XmlAttribute;
begin
  var Existing := GetAttributeNode(Node.Name);
  libxml.xmlRemoveProp(libxml.xmlAttrPtr(Node.Node));
  exit Existing;
end;

method XmlElement.HasAttribute(aName: String): Boolean;
begin
  exit GetAttributeNode(aName) <> nil;
end;

method XmlElement.HasAttribute(aLocalName: String; NamespaceUri: String): Boolean;
begin
  exit GetAttributeNode(aLocalName, NamespaceUri) <> nil;
end;

method XmlElement.CopyNS(aNode: XmlAttribute);
begin
  //nothing to copy
  if aNode.Node^.ns = nil then
    exit;

  //if nodes ns list is empty
  if Node^.nsDef = nil then begin
    Node^.nsDef := aNode.Node^.ns; //this ns will be our first element
    exit;
  end;

  var curr := ^libxml.__struct__xmlNs(aNode.Node^.ns);
  var prev := ^libxml.__struct__xmlNs(Node^.nsDef);

  while prev <> nil do begin
    //check if same ns already exists
    if ((prev^.prefix = nil) and (curr^.prefix = nil)) or (libxml.xmlStrEqual(prev^.prefix, curr^.prefix) = 1) then begin
      //if its a same ns
      if libxml.xmlStrEqual(prev^.href, curr^.href) = 1 then
        aNode.Node^.ns := libxml.xmlNsPtr(prev) //use existing
      else
        aNode.Node^.ns := nil; //else this ns is wrong
        //maybe should be exception here
      
      //we must release this ns
      libxml.xmlFreeNs(libxml.xmlNsPtr(curr));
      exit;
    end;

    prev := ^libxml.__struct__xmlNs(prev^.next);
  end;

  //set new ns as a last element in the list
  prev^.next := curr;
end;
{$ENDIF}

end.

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

{$IF ECHOES}
  XmlNode = public class
  private
    fNode: XObject;

    method GetNextSibling: XmlNode;
    method GetPreviousSibling: XmlNode;    
    method SetInnerText(Value: String); empty;
    method GetFirstChild: XmlNode;
    method GetLastChild: XmlNode;
    method GetItem(&Index: Integer): XmlNode;
    method GetChildCount: Integer;
    method GetChildNodes: array of XmlNode;
    method SetValue(Value: String); empty;
  protected
    class method CreateCompatibleNode(Node: XNode): XmlNode;
  assembly or protected 
    property Node: XObject read fNode;
    constructor(aNode: XObject);
  public
    property Name: String read Node.GetType.Name; virtual;
    property URI: String read Node.BaseUri; 
    property Value: String read nil write SetValue; virtual;
    property LocalName: String read Name; virtual;
    
    property Document: XmlDocument read iif(Node.Document = nil, nil, new XmlDocument(Node.Document));
    property Parent: XmlNode read CreateCompatibleNode(Node.Parent);
    property NextSibling: XmlNode read GetNextSibling;
    property PreviousSibling: XmlNode read GetPreviousSibling;

    property FirstChild: XmlNode read GetFirstChild;
    property LastChild: XmlNode read GetLastChild;
    property Item[&Index: Integer]: XmlNode read GetItem; default;
    property ChildCount: Integer read GetChildCount;
    property ChildNodes: array of XmlNode read GetChildNodes;

    method &Equals(obj: Object): Boolean; override;
    method ToString: System.String; override;
  end;
{$ELSEIF COOPER}
  XmlNode = public class
  private
    fNode: Node;
  protected
    method ConvertNodeList(List: NodeList): array of XmlNode;
    class method CreateCompatibleNode(Node: Node): XmlNode;
  assembly or protected 
    property Node: Node read fNode;
    constructor(aNode: Node);
  public
    property Name: String read Node.NodeName;
    property URI: String read Node.BaseUri;
    property Value: String read Node.NodeValue write Node.NodeValue;
    property LocalName: String read Node.LocalName;
    
    property Document: XmlDocument read iif(Node.OwnerDocument = nil, nil, new XmlDocument(Node.OwnerDocument));
    property Parent: XmlNode read CreateCompatibleNode(Node.ParentNode);
    property NextSibling: XmlNode read CreateCompatibleNode(Node.NextSibling);
    property PreviousSibling: XmlNode read CreateCompatibleNode(Node.PreviousSibling);

    property FirstChild: XmlNode read CreateCompatibleNode(Node.FirstChild);
    property LastChild: XmlNode read CreateCompatibleNode(Node.LastChild);
    property Item[&Index: Integer]: XmlNode read CreateCompatibleNode(Node.ChildNodes.Item(&Index));
    property ChildCount: Integer read Node.ChildNodes.length;
    property ChildNodes: array of XmlNode read ConvertNodeList(Node.ChildNodes);

    method SelectNodes(XPath: String): array of XmlNode;
    method SelectSingleNode(XPath: String): XmlNode;
    method ToString: java.lang.String; override;
  end;  
{$ELSEIF NOUGAT}
{$IF OSX}
XmlNode = public class
  private
    fNode: NSXMLNode;

    method SetName(aValue: String);
    method GetFirstChild: XmlNode;
    method GetLastChild: XmlNode;
    method SetValue(aValue: String);
  protected
    method ConvertNodeList(List: NSArray): array of XmlNode;
    class method CreateCompatibleNode(Node: NSXMLNode): XmlNode;
  assembly or protected 
    property Node: NSXMLNode read fNode;
    method initWithNode(aNode: NSXMLNode): dynamic;
  public
    property Name: String read Node.name write SetName;
    property URI: String read Node.URI;
    property Value: String read Node.stringValue write SetValue;
    property LocalName: String read Node.LocalName;

    property Document: XmlDocument read iif(Node.rootDocument = nil, nil, new XmlDocument withNode(Node.rootDocument));
    property Parent: XmlNode read CreateCompatibleNode(Node.parent);
    property NextSibling: XmlNode read CreateCompatibleNode(Node.nextSibling);
    property PreviousSibling: XmlNode read CreateCompatibleNode(Node.previousSibling);

    property FirstChild: XmlNode read GetFirstChild;
    property LastChild: XmlNode read GetLastChild;
    property Item[&Index: Integer]: XmlNode read CreateCompatibleNode(Node.childAtIndex(&Index));
    property ChildCount: Integer read Node.childCount;

    method SelectNodes(XPath: String): array of XmlNode;
    method SelectSingleNode(XPath: String): XmlNode;
    method description: NSString; override;
  end;
{$ELSEIF IOS}
  XmlNode = public class
  private
    fNode: ^libxml.__struct__xmlNode;
    fDocument: XmlDocument;

    method GetName: String;
    method GetURI: String;
    method GetValue: String;
    method SetValue(aValue: String);
    method GetLocalName: String;

    method GetItem(&Index: Integer): XmlNode;
    method GetChildCount: Integer;
    method GetChildNodes: array of XmlNode;
  protected
    class method CreateCompatibleNode(Node: ^libxml.__struct__xmlNode; Doc: XmlDocument): XmlNode;
    class method IsNode(Node: ^libxml.__struct__xmlNode): Boolean;
  assembly or protected 
    property Node: ^libxml.__struct__xmlNode read fNode write fNode;
    constructor(aNode: ^libxml.__struct__xmlNode; aDocument: XmlDocument);
  public
    property Name: String read GetName; virtual;
    property URI: String read GetURI; virtual;
    property Value: String read GetValue write SetValue; virtual;
    property LocalName: String read GetLocalName; virtual;
    
    property Document: XmlDocument read fDocument;
    property Parent: XmlNode read CreateCompatibleNode(^libxml.__struct__xmlNode(Node^.parent), Document);
    property NextSibling: XmlNode read CreateCompatibleNode(^libxml.__struct__xmlNode(Node^.next), Document);
    property PreviousSibling: XmlNode read CreateCompatibleNode(^libxml.__struct__xmlNode(Node^.prev), Document);

    property FirstChild: XmlNode read CreateCompatibleNode(^libxml.__struct__xmlNode(Node^.children), Document);
    property LastChild: XmlNode read CreateCompatibleNode(^libxml.__struct__xmlNode(Node^.last), Document);
    property Item[&Index: Integer]: XmlNode read GetItem;
    property ChildCount: Integer read GetChildCount;
    property ChildNodes: array of XmlNode read GetChildNodes;
    
    method description: NSString; override;
  end;

  XmlNamespace nested in XmlNode = public class
  private
    fNode: ^libxml.__struct__xmlNode;
    method GetLocalName: String;
    method GetName: String;
    method GetUri: String;
  public
    constructor(Node: ^libxml.__struct__xmlNode);
    property LocalName: String read GetLocalName;
    property Name: String read GetName;
    property Uri: String read GetUri;
  end;

  XmlChar nested in XmlNode = public static class
  public
    method ToString(Value: ^libxml.xmlChar; FreeWhenDone: Boolean := false): String;
    method FromString(Value: String): ^libxml.xmlChar;
  end;

  XmlNodeList nested in XmlNode = public class
  private
    Root: XmlNode;
    method Match(Element: XmlNode; LocalName: String; NamespaceUri: String): Boolean;
    method ListElementsByName(Element: XmlNode; LocalName: String; NamespaceUri: String): RemObjects.Oxygene.Sugar.Collections.List<XmlElement>;
  public
    constructor(RootElement: XmlNode); 
    method ElementsByName(Name: String): array of XmlElement;
    method ElementsByName(LocalName: String; NamespaceUri: String): array of XmlElement;
  end;
{$ENDIF}
{$ENDIF}

implementation

{$IF ECHOES}
class method XmlNode.CreateCompatibleNode(Node: XNode): XmlNode;
begin
  if Node = nil then
    exit nil;

  case Node.NodeType of
    System.Xml.XmlNodeType.None: exit nil;
    System.Xml.XmlNodeType.Element: exit new XmlElement(Node);
    System.Xml.XmlNodeType.Attribute: exit new XmlAttribute(Node);
    System.Xml.XmlNodeType.Text: exit new XmlText(Node);
    System.Xml.XmlNodeType.CDATA: exit new XmlCDataSection(Node);
    System.Xml.XmlNodeType.ProcessingInstruction: exit new XmlProcessingInstruction(Node);
    System.Xml.XmlNodeType.Comment: exit new XmlComment(Node);
    System.Xml.XmlNodeType.Document: exit new XmlDocument(Node);
    System.Xml.XmlNodeType.DocumentType: exit new XmlDocumentType(Node);
    System.Xml.XmlNodeType.Whitespace: exit new XmlText(Node);
    System.Xml.XmlNodeType.SignificantWhitespace: exit new XmlText(Node);
    else
      exit new XmlNode(Node);
  end;
end;

constructor XmlNode(aNode: XObject);
begin
  fNode := aNode;
end;

method XmlNode.GetNextSibling: XmlNode;
begin
  exit CreateCompatibleNode((Node as XNode):NextNode);
end;

method XmlNode.GetPreviousSibling: XmlNode;
begin
  exit CreateCompatibleNode((Node as XNode):PreviousNode)
end;

method XmlNode.GetFirstChild: XmlNode;
begin
  var Container := XContainer(Node);
  if Container = nil then
    exit nil;

  exit CreateCompatibleNode(Container.Nodes.FirstOrDefault);
end;

method XmlNode.GetLastChild: XmlNode;
begin
  var Container := XContainer(Node);
  if Container = nil then
    exit nil;

  exit CreateCompatibleNode(Container.Nodes.LastOrDefault);
end;

method XmlNode.GetItem(&Index: Integer): XmlNode;
begin
  exit GetChildNodes[&Index];
end;

method XmlNode.GetChildCount: Integer;
begin
  var Container := XContainer(Node);
  if Container = nil then
    exit 0;

  exit Container.Nodes.Count;
end;

method XmlNode.GetChildNodes: array of XmlNode;
begin
  var Container := XContainer(Node);
  if Container = nil then
    exit nil;

  var descendants := Container.Nodes.ToArray;
  result := new XmlNode[descendants.Length];
  for i: Integer := 0 to descendants.Length-1 do
    result[i] := CreateCompatibleNode(descendants[i]);
end;

method XmlNode.ToString: {$IF ECHOES}System.{$ENDIF}String;
begin
  exit fNode.ToString;
end;

method XmlNode.&Equals(obj: Object): Boolean;
begin
  if obj = nil then
    exit false;

  if obj is not XmlNode then 
    exit false;

  exit fNode.Equals(XmlNode(obj).Node);
end;
{$ELSEIF COOPER}
constructor XmlNode(aNode: Node);
begin
  fNode := aNode;
end;

method XmlNode.ConvertNodeList(List: NodeList): array of XmlNode;
begin  
  if List = nil then
    exit nil;

  var ItemsCount: Integer := List.Length;
  var lItems: array of XmlNode := new XmlNode[ItemsCount];
  for i: Integer := 0 to ItemsCount-1 do
    lItems[i] := CreateCompatibleNode(List.Item(i));

  exit lItems;
end;

method XmlNode.SelectNodes(XPath: String): array of XmlNode;
begin
  var Path := javax.xml.xpath.XPathFactory.newInstance().newXPath();
  var Nodes := NodeList(Path.evaluate(XPath, Node, javax.xml.xpath.XPathConstants.NODESET));
  exit ConvertNodeList(Nodes);
end;

method XmlNode.SelectSingleNode(XPath: String): XmlNode;
begin
  var Nodes := SelectNodes(XPath);
  if (Nodes <> nil) and (Nodes.length > 0) then
    exit Nodes[0];
end;

method XmlNode.ToString: java.lang.String;
begin
  exit fNode.ToString;
end;

class method XmlNode.CreateCompatibleNode(Node: Node): XmlNode;
begin
  if Node = nil then
    exit nil;

  case Node.NodeType of
    Node.ATTRIBUTE_NODE: exit new XmlAttribute(Node);
    Node.CDATA_SECTION_NODE: exit new XmlCDataSection(Node);
    Node.COMMENT_NODE: exit new XmlComment(Node);
    Node.DOCUMENT_TYPE_NODE: exit new XmlDocumentType(Node);
    Node.ELEMENT_NODE: exit new XmlElement(Node);
    Node.PROCESSING_INSTRUCTION_NODE: exit new XmlProcessingInstruction(Node);
    Node.TEXT_NODE: exit new XmlText(Node);
    else
      exit new XmlNode(Node);
  end;
end;
{$ELSEIF NOUGAT}
{$IF OSX}
method XmlNode.SetName(aValue: String);
begin
  Node.setName(Value);
end;

method XmlNode.initWithNode(aNode: NSXMLNode): dynamic;
begin
  fNode := aNode;
  result := self;
end;

class method XmlNode.CreateCompatibleNode(Node: NSXMLNode): XmlNode;
begin
  if Node = nil then
    exit nil;

  case Node.kind of
    NSXMLNodeKind.NSXMLInvalidKind: exit nil;
    NSXMLNodeKind.NSXMLAttributeKind: exit new XmlAttribute(Node);
    NSXMLNodeKind.NSXMLCommentKind: exit new XmlComment(Node);
    NSXMLNodeKind.NSXMLDocumentKind: exit new XmlDocument(Node);
    NSXMLNodeKind.NSXMLDTDKind: exit new XmlDocumentType(Node);
    NSXMLNodeKind.NSXMLElementKind: exit new XmlElement(Node);
    NSXMLNodeKind.NSXMLProcessingInstructionKind: exit new XmlProcessingInstruction(Node);
    NSXMLNodeKind.NSXMLTextKind: exit new XmlText(Node);
    else
      exit new XmlNode(Node);
  end;
end;

method XmlNode.GetLastChild: XmlNode;
begin
  if Node.childCount = 0 then
    exit nil;

  exit CreateCompatibleNode(Node.children.objectAtIndex(Node.childCount-1));
end;

method XmlNode.GetFirstChild: XmlNode;
begin
  if Node.childCount = 0 then
    exit nil;

  exit CreateCompatibleNode(Node.children.objectAtIndex(0));
end;

method XmlNode.SetValue(aValue: String);
begin
  Node.setStringValue(aValue);
end;

method XmlNode.SelectNodes(XPath: String): array of XmlNode;
begin
  var lError: NSError := nil;
  var lNodes := Node.nodesForXPath(XPath) error(var lError);
  exit ConvertNodeList(lNodes);
end;

method XmlNode.SelectSingleNode(XPath: String): XmlNode;
begin
  exit SelectNodes(XPath)[0];
end;

method XmlNode.ConvertNodeList(List: NSArray): array of XmlNode;
begin
  if List = nil then
    exit nil;

  result := new XmlNode[List.count];
  for i: Integer := 0 to List.count-1 do
    result[i] := CreateCompatibleNode(List.objectAtIndex(i));
end;

method XmlNode.description: NSString;
begin
  exit fNode.description;
end;
{$ELSEIF IOS}
constructor XmlNode(aNode: ^libxml.__struct__xmlNode; aDocument: XmlDocument);
begin
  fNode := aNode;
  fDocument := aDocument;
end;

method XmlNode.GetName: String;
begin
  exit new XmlNamespace(fNode).Name;
end;

method XmlNode.GetURI: String;
begin
  exit XmlChar.ToString(libxml.xmlNodeGetBase(fNode^.doc, libxml.xmlNodePtr(fNode)), true);
end;

method XmlNode.GetValue: String;
begin
  var content := libxml.xmlNodeGetContent(libxml.xmlNodePtr(fNode));
  if content = nil then
    exit nil;

  exit XmlChar.ToString(content, true);
end;

method XmlNode.SetValue(aValue: String);
begin
  libxml.xmlNodeSetContent(libxml.xmlNodePtr(fNode), XmlChar.FromString(aValue));
end;

method XmlNode.GetLocalName: String;
begin
  exit new XmlNamespace(fNode).LocalName;
end;

class method XmlNode.CreateCompatibleNode(Node: ^libxml.__struct__xmlNode; Doc: XmlDocument): XmlNode;
begin
  if Node = nil then
    exit nil;

  case Node^.type of
    libxml.xmlElementType.XML_ATTRIBUTE_NODE : exit new XmlAttribute(Node, Doc);
    libxml.xmlElementType.XML_CDATA_SECTION_NODE : exit new XmlCDataSection(Node, Doc);
    libxml.xmlElementType.XML_COMMENT_NODE : exit new XmlComment(Node, Doc);
    libxml.xmlElementType.XML_DOCUMENT_NODE : exit new XmlNode(Node, Doc);
    libxml.xmlElementType.XML_DOCUMENT_TYPE_NODE : exit new XmlNode(Node, Doc);
    libxml.xmlElementType.XML_DTD_NODE : exit new XmlNode(Node, Doc);
    libxml.xmlElementType.XML_ELEMENT_NODE : exit new XmlElement(Node, Doc);
    libxml.xmlElementType.XML_PI_NODE : exit new XmlProcessingInstruction(Node, Doc);
    libxml.xmlElementType.XML_TEXT_NODE : exit new XmlText(Node, Doc);
    else
      exit new XmlNode(Node, Doc);
  end;
end;

method XmlNode.description: NSString;
begin
  var bufferPtr := libxml.xmlBufferCreate;
  try
    if libxml.xmlNodeDump(bufferPtr, libxml.xmlDocPtr(fNode^.doc), libxml.xmlNodePtr(fNode), 1, 1) = 0 then
      exit "";

    exit XmlChar.ToString(libxml.xmlBufferContent(bufferPtr));
  finally
    libxml.xmlBufferFree(bufferPtr);
  end;
end;

method XmlNode.GetItem(&Index: Integer): XmlNode;
begin
  exit GetChildNodes[&Index];
end;

method XmlNode.GetChildCount: Integer;
begin
  result := 0;
  var ChildPtr := fNode^.children;
  while ChildPtr <> nil do begin
    inc(result);
    ChildPtr := ^libxml.__struct__xmlNode(ChildPtr)^.next;
  end;
end;

method XmlNode.GetChildNodes: array of XmlNode;
begin
  var List := new RemObjects.Oxygene.Sugar.Collections.List<XmlNode>;
  var ChildPtr := fNode^.children;
  while ChildPtr <> nil do begin
    List.Add(CreateCompatibleNode( ^libxml.__struct__xmlNode(ChildPtr), Document));
    ChildPtr := ^libxml.__struct__xmlNode(ChildPtr)^.next;
  end;

  exit List.ToArray;
end;

class method XmlNode.IsNode(Node: ^libxml.__struct__xmlNode): Boolean;
begin
  if Node = nil then
    exit false;

  exit not (Node^.type in [libxml.xmlElementType.XML_ATTRIBUTE_DECL, libxml.xmlElementType.XML_ELEMENT_DECL, libxml.xmlElementType.XML_ENTITY_DECL, 
  libxml.xmlElementType.XML_NAMESPACE_DECL, libxml.xmlElementType.XML_XINCLUDE_END, libxml.xmlElementType.XML_XINCLUDE_START]);
end;

constructor XmlNode.XmlNamespace(Node: ^libxml.__struct__xmlNode);
begin
  fNode := Node;
end;

method XmlNode.XmlNamespace.GetLocalName: String;
begin
  exit XmlChar.ToString(fNode^.name);
end;

method XmlNode.XmlNamespace.GetName: String;
begin
  if (not XmlNode.IsNode(fNode)) or (fNode^.ns = nil) then
    exit LocalName;

  exit new String withFormat("{%@}%@", Uri, LocalName);
end;

method XmlNode.XmlNamespace.GetUri: String;
begin
  if (not XmlNode.IsNode(fNode)) or (fNode^.ns = nil) then
    exit "";

  var ns := ^libxml.__struct__xmlNs(fNode^.ns);
  exit XmlChar.ToString(ns^.href);
end;

method XmlNode.XmlChar.FromString(Value: String): ^libxml.xmlChar;
begin
  exit ^libxml.xmlChar(NSString(Value).UTF8String);
end;

method XmlNode.XmlChar.ToString(Value: ^libxml.xmlChar; FreeWhenDone: Boolean := false): String;
begin
  if Value = nil then
    exit "";

  result := new String withUTF8String(^AnsiChar(Value));
  if FreeWhenDone then
    libxml.xmlFree(Value);
end;

constructor XmlNode.XmlNodeList(RootElement: XmlNode);
begin
  Root := RootElement;
end;

method XmlNode.XmlNodeList.Match(Element: XmlNode; LocalName: String; NamespaceUri: String): Boolean;
begin
  if Element.Node^.type <> libxml.xmlElementType.XML_ELEMENT_NODE then
    exit false;

  var Ns := new XmlNamespace(Element.Node);
  if NamespaceUri = nil then 
    exit LocalName = Ns.LocalName
  else
    exit (LocalName = Ns.LocalName) and (NamespaceUri = Ns.Uri);
end;

method XmlNode.XmlNodeList.ListElementsByName(Element: XmlNode; LocalName: String; NamespaceUri: String): RemObjects.Oxygene.Sugar.Collections.List<XmlElement>;
begin
  result := new RemObjects.Oxygene.Sugar.Collections.List<XmlElement>;

  if Element = nil then
    exit;

  if Match(Element, LocalName, NamespaceUri) then
    result.Add(XmlElement(Element));

  result.AddRange(ListElementsByName(Element.FirstChild, LocalName, NamespaceUri));

  while Element.NextSibling <> nil do begin
    result.AddRange(ListElementsByName(Element.NextSibling, LocalName, NamespaceUri));
    Element := Element.NextSibling;
  end;
end;

method XmlNode.XmlNodeList.ElementsByName(LocalName: String; NamespaceUri: String): array of XmlElement;
begin
  if (NamespaceUri <> nil) and (NamespaceUri = "*") then
    NamespaceUri := nil;

  var Elements := ListElementsByName(Root, LocalName, NamespaceUri);
  exit Elements.ToArray;
end;

method XmlNode.XmlNodeList.ElementsByName(Name: String): array of XmlElement;
begin
  exit ElementsByName(Name, nil);
end;
{$ENDIF}
{$ENDIF}

end.

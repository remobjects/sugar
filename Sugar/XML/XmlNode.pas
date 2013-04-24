namespace RemObjects.Oxygene.Sugar.Xml;

{$HIDE W0} //supress case-mismatch errors

interface

uses
  {$IF COOPER}
  org.w3c.dom,
  {$ELSEIF WINDOWS_PHONE}
  System.Xml.Linq,
  System.Linq,
  System.Xml.XPath,
  {$ELSEIF NOUGAT}
  Foundation,
  {$ENDIF}
  RemObjects.Oxygene.Sugar;

type

{$IF WINDOWS_PHONE}
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
    property InnerText: String read "" write SetInnerText; virtual;
    property LocalName: String read Name; virtual;
    
    property Document: XmlDocument read iif(Node.Document = nil, nil, new XmlDocument(Node.Document));
    property Parent: XmlNode read CreateCompatibleNode(Node.Parent);
    property NextSibling: XmlNode read GetNextSibling;
    property PreviousSibling: XmlNode read GetPreviousSibling;

    property FirstChild: XmlNode read GetFirstChild;
    property LastChild: XmlNode read GetLastChild;
    property Item[&Index: Integer]: XmlNode read GetItem;
    property ChildCount: Integer read GetChildCount;
    property ChildNodes: array of XmlNode read GetChildNodes;

    method SelectNodes(XPath: String): array of XmlNode;
    method SelectSingleNode(XPath: String): XmlNode;
    method ToString: System.String; override;
  end;
{$ELSEIF COOPER OR ECHOES}
  XmlNode = public class
  private
    fNode: {$IF COOPER}Node{$ELSE}System.Xml.XmlNode{$ENDIF};
  protected
    method ConvertNodeList(List: {$IF COOPER}NodeList{$ELSE}System.Xml.XmlNodeList{$ENDIF}): array of XmlNode;
    class method CreateCompatibleNode(Node: {$IF COOPER}Node{$ELSE}System.Xml.XmlNode{$ENDIF}): XmlNode;
  assembly or protected 
    property Node: {$IF COOPER}Node{$ELSE}System.Xml.XmlNode{$ENDIF} read fNode;
    constructor(aNode: {$IF COOPER}Node{$ELSE}System.Xml.XmlNode{$ENDIF});
  public
    property Name: String read {$IF COOPER}Node.NodeName{$ELSE}Node.Name{$ENDIF};
    property URI: String read Node.BaseURI;
    property Value: String read {$IF COOPER}Node.NodeValue{$ELSE}Node.Value{$ENDIF} write {$IF COOPER}Node.NodeValue{$ELSE}Node.Value{$ENDIF};
    property InnerText: String read {$IF COOPER}Node.TextContent{$ELSE}Node.InnerText{$ENDIF} write {$IF COOPER}Node.TextContent{$ELSE}Node.InnerText{$ENDIF};
    property LocalName: String read Node.LocalName;
    
    property Document: XmlDocument read iif(Node.OwnerDocument = nil, nil, new XmlDocument(Node.OwnerDocument));
    property Parent: XmlNode read CreateCompatibleNode(Node.ParentNode);
    property NextSibling: XmlNode read CreateCompatibleNode(Node.NextSibling);
    property PreviousSibling: XmlNode read CreateCompatibleNode(Node.PreviousSibling);

    property FirstChild: XmlNode read CreateCompatibleNode(Node.FirstChild);
    property LastChild: XmlNode read CreateCompatibleNode(Node.LastChild);
    property Item[&Index: Integer]: XmlNode read CreateCompatibleNode(Node.ChildNodes.Item(&Index));
    property ChildCount: Integer read {$IF COOPER}Node.ChildNodes.Length{$ELSE}Node.ChildNodes.Count{$ENDIF};
    property ChildNodes: array of XmlNode read ConvertNodeList(Node.ChildNodes);

    method SelectNodes(XPath: String): array of XmlNode;
    method SelectSingleNode(XPath: String): XmlNode;
    method ToString: {$IF ECHOES}System.{$ENDIF}String; override;
  end;  
{$ELSEIF NOUGAT}
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
    property InnerText: String read Node.stringValue write setValue;
    property LocalName: String read Node.localName;

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
{$ENDIF}

implementation

{$IF WINDOWS_PHONE}
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

  exit CreateCompatibleNode(Container.Nodes.First);
end;

method XmlNode.GetLastChild: XmlNode;
begin
  var Container := XContainer(Node);
  if Container = nil then
    exit nil;

  exit CreateCompatibleNode(Container.Nodes.Last);
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

method XmlNode.SelectNodes(XPath: String): array of XmlNode;
begin
  var elements := (Node as XNode):XPathSelectElements(XPath):ToArray;
  if elements = nil then
    exit nil;

  result := new XmlNode[elements.Length];
  for i: Integer := 0 to elements.Length-1 do
    result[i] := CreateCompatibleNode(elements[i]);
end;

method XmlNode.SelectSingleNode(XPath: String): XmlNode;
begin
  var element := (Node as XNode):XPathSelectElement(XPath);
  exit CreateCompatibleNode(element);
end;

method XmlNode.ToString: {$IF ECHOES}System.{$ENDIF}String;
begin
  exit fNode.ToString;
end;
{$ELSEIF COOPER OR ECHOES}
constructor XmlNode(aNode: {$IF COOPER}Node{$ELSE}System.Xml.XmlNode{$ENDIF});
begin
  fNode := aNode;
end;

method XmlNode.ConvertNodeList(List: {$IF COOPER}NodeList{$ELSE}System.Xml.XmlNodeList{$ENDIF}): array of XmlNode;
begin  
  if List = nil then
    exit nil;

  var ItemsCount: Integer := {$IF COOPER}List.Length{$ELSE}List.Count{$ENDIF};
  var lItems: array of XmlNode := new XmlNode[ItemsCount];
  for i: Integer := 0 to ItemsCount-1 do
    lItems[i] := CreateCompatibleNode(List.Item(i));

  exit lItems;
end;

method XmlNode.SelectNodes(XPath: String): array of XmlNode;
begin
  {$IF COOPER}
  var Path := javax.xml.xpath.XPathFactory.newInstance().newXPath();
  var Nodes := NodeList(Path.evaluate(XPath, Node, javax.xml.xpath.XPathConstants.NODESET));
  exit ConvertNodeList(Nodes);
  {$ELSE}
  exit ConvertNodeList(Node.SelectNodes(XPath));
  {$ENDIF}
end;

method XmlNode.SelectSingleNode(XPath: String): XmlNode;
begin
  {$IF COOPER}
  var Nodes := SelectNodes(XPath);
  if (Nodes <> nil) and (Nodes.length > 0) then
    exit Nodes[0];
  {$ELSE}
  exit CreateCompatibleNode(Node.SelectSingleNode(XPath));
  {$ENDIF}
end;

method XmlNode.ToString: {$IF ECHOES}System.{$ENDIF}String;
begin
  exit fNode.ToString;
end;

{$IF COOPER}
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
{$ELSE}
class method XmlNode.CreateCompatibleNode(Node: System.Xml.XmlNode): XmlNode;
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
{$ENDIF}
{$ELSEIF NOUGAT}
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
{$ENDIF}

end.

namespace RemObjects.Oxygene.Sugar.Xml;

{$HIDE W0} //supress case-mismatch errors

interface

uses
  {$IF COOPER}
  org.w3c.dom,
  {$ELSEIF NOUGAT}
  Foundation,
  {$ENDIF}
  RemObjects.Oxygene.Sugar;

type
  {$IF COOPER OR ECHOES}
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
    property URI: String read Node.BaseUri;
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
    property ChildCount: Integer read {$IF COOPER}Node.ChildNodes.length{$ELSE}Node.ChildNodes.Count{$ENDIF};
    property ChildNodes: array of XmlNode read ConvertNodeList(Node.ChildNodes);

    method SelectNodes(XPath: String): array of XmlNode;
    method SelectSingleNode(XPath: String): XmlNode;
  end;

  XmlElement = public class (XmlNode)
  private
    property Element: {$IF COOPER}Element{$ELSE}System.Xml.XmlElement{$ENDIF} read Node as {$IF COOPER}Element{$ELSE}System.Xml.XmlElement{$ENDIF};
    method GetAttributes: array of XmlAttribute;
  public
    method AddChild(Node: XmlNode);
    method RemoveChild(Node: XmlNode);
    method ReplaceChild(Node: XmlNode; WithNode: XmlNode);

    method GetAttribute(Name: String): String;
    method GetAttribute(LocalName, NamespaceUri: String): String;
    method GetAttributeNode(Name: String): XmlAttribute;
    method GetAttributeNode(LocalName, NamespaceUri: String): XmlAttribute;

    method SetAttribute(Name, Value: String);
    method SetAttribute(LocalName, NamespaceUri, Value: String);
    method SetAttributeNode(Node: XmlAttribute): XmlAttribute;

    method RemoveAttribute(Name: String);
    method RemoveAttribute(LocalName, NamespaceUri: String);
    method RemoveAttributeNode(Node: XmlAttribute): XmlAttribute;

    method HasAttribute(Name: String): Boolean;
    method HasAttribute(LocalName, NamespaceUri: String): Boolean;
    
    property Attributes: array of XmlAttribute read GetAttributes;
  end;

  XmlCharacterData = public class (XmlNode)
  private
    property CharacterData: {$IF COOPER}CharacterData{$ELSE}System.Xml.XmlCharacterData{$ENDIF} read Node as {$IF COOPER}CharacterData{$ELSE}System.Xml.XmlCharacterData{$ENDIF};
  public
    property Data: String read CharacterData.Data write CharacterData.Data;
    property Length: Integer read CharacterData.Length;

    method AppendData(Value: String);
    method DeleteData(Offset, Count: Integer);
    method InsertData(Offset: Integer; Value: String);
    method ReplaceData(Offset, Count: Integer; WithValue: String);
    method Substring(Offset, Count: Integer): String;
  end;

  XmlCDataSection = public class (XmlCharacterData)
  end;

  XmlComment = public class (XmlCharacterData)
  end;

  XmlText = public class (XmlCharacterData)
  end;

  XmlProcessingInstruction = public class (XmlNode)
  private
    property ProcessingInstruction: {$IF COOPER}ProcessingInstruction{$ELSE}System.Xml.XmlProcessingInstruction{$ENDIF} read Node as {$IF COOPER}ProcessingInstruction{$ELSE}System.Xml.XmlProcessingInstruction{$ENDIF};
  public
    property Data: String read ProcessingInstruction.Data write ProcessingInstruction.Data;
    property Target: String read ProcessingInstruction.Target;
  end;

  XmlDocumentType = public class (XmlNode)
  private
    property DocumentType: {$IF COOPER}DocumentType{$ELSE}System.Xml.XmlDocumentType{$ENDIF} read Node as {$IF COOPER}DocumentType{$ELSE}System.Xml.XmlDocumentType{$ENDIF};

    method GetEntities: array of XmlNode;
    method GetNotations: array of XmlNode;
  public
    property Entities: array of XmlNode read GetEntities;
    property InternalSubset: String read DocumentType.InternalSubset;
    property PublicId: String read DocumentType.PublicId;
    property SystemId: String read DocumentType.SystemId;
    property Notations: array of XmlNode read GetNotations;
  end;

  XmlAttribute = public class (XmlNode)
  private
    property &Attribute: {$IF COOPER}Attr{$ELSE}System.Xml.XmlAttribute{$ENDIF} read Node as {$IF COOPER}Attr{$ELSE}System.Xml.XmlAttribute{$ENDIF};
  public
    property OwnerElement: XmlElement read iif(Attribute.OwnerElement = nil, nil, new XmlElement(Attribute.OwnerElement));
    property Specified: Boolean read Attribute.Specified;
  end;

  XmlEntity = public class (XmlNode)
  private
    property Entity: {$IF COOPER}Entity{$ELSE}System.Xml.XmlEntity{$ENDIF} read Node as {$IF COOPER}Entity{$ELSE}System.Xml.XmlEntity{$ENDIF};
  public
    property NontationName: String read Entity.NotationName;
    property PublicId: String read Entity.PublicId;
    property SystemId: String read Entity.SystemId;
  end;

  XmlNotation = public class (XmlNode)
  private
    property Notation: {$IF COOPER}Notation{$ELSE}System.Xml.XmlNotation{$ENDIF} read Node as {$IF COOPER}Notation{$ELSE}System.Xml.XmlNotation{$ENDIF};
  public
    property PublicId: String read Notation.PublicId;
    property SystemId: String read Notation.SystemId;
  end;

  {$IF ECHOES} //only for .net
  XmlDeclaration = public class (XmlNode)
  private
    property Declaration: System.Xml.XmlDeclaration read Node as System.Xml.XmlDeclaration;
  public
    property Encoding: String read Declaration.Encoding write Declaration.Encoding;
    property Standalone: String read Declaration.Standalone write Declaration.Standalone;
    property Version: String read Declaration.Version;
  end;
  {$ENDIF}

  XmlDocument = public class (XmlNode)
  private
    property Doc: {$IF COOPER}Document{$ELSE}System.Xml.XmlDocument{$ENDIF} read Node as {$IF COOPER}Document{$ELSE}System.Xml.XmlDocument{$ENDIF};
    method GetElement(Name: String): XmlElement;
  public
    property DocumentElement: XmlElement read iif(Doc.DocumentElement = nil, nil, new XmlElement(Doc.DocumentElement));
    {$IF COOPER}
    property DocumentType: XmlDocumentType read iif(Doc.Doctype = nil, nil, new XmlDocumentType(Doc.Doctype));
    {$ELSE}
    property DocumentType: XmlDocumentType read iif(Doc.DocumentType = nil, nil, new XmlDocumentType(Doc.DocumentType));
    {$ENDIF}
    property &Implementation: Object read Doc.Implementation; {Change to XmlImplementation}
    property Element[Name: String]: XmlElement read GetElement; default;

    method AddChild(Node: XmlNode);
    method RemoveChild(Node: XmlNode);
    method ReplaceChild(Node: XmlNode; WithNode: XmlNode);

    method CreateAttribute(Name: String): XmlAttribute;
    method CreateAttribute(QualifiedName: String; NamespaceUri: String): XmlAttribute;
    method CreateCDataSection(Data: String): XmlCDataSection;
    method CreateComment(Data: String): XmlComment;
    method CreateElement(Name: String): XmlElement;
    method CreateElement(QualifiedName: String; NamespaceUri: String): XmlElement;
    method CreateProcessingInstruction(Target, Data: String): XmlProcessingInstruction;
    method CreateTextNode(Data: String): XmlText;    

    method GetElementById(ElementId: String): XmlElement;
    method GetElementsByTagName(Name: String): array of XmlNode;
    method GetElementsByTagName(LocalName, NamespaceUri: String): array of XmlNode;

    class method LoadDocument(FileName: String): XmlDocument;
    class method CreateDocument: XmlDocument;

    method Save(FileName: String);
    method Save(FileName: String; XmlDeclaration: XmlDocumentDeclaration);
    method Save(FileName: String; Version: String; Encoding: String; Standalone: Boolean);
  end;

  {$ELSEIF NOUGAT}

  XmlNode = public class
  private
    fNode: NSXMLNode;

    method SetName(aValue: String);
    method GetFirstChild: XmlNode;
    method GetLastChild: XmlNode;
    method SetValue(aValue: String);
    method SetInnerText(aValue: String);
  protected
    method ConvertNodeList(List: NSArray): array of XmlNode;
    class method CreateCompatibleNode(Node: NSXMLNode): XmlNode;
  assembly or protected 
    property Node: NSXMLNode read fNode;
    method initWithNode(aNode: NSXMLNode): dynamic;
  public
    property Name: String read Node.name write SetName;
    property URI: String read Node.URI;
    property Value: String read Node.objectValue write SetValue;
    property InnerText: String read Node.stringValue write SetInnerText;
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
  end;

  XmlElement = public class (XmlNode)
  private
    property Element: NSXMLElement read Node as NSXMLElement;
    method GetAttributes: array of XmlAttribute;
  public
    method AddChild(Node: XmlNode);
    method RemoveChild(Node: XmlNode);
    method ReplaceChild(Node: XmlNode; WithNode: XmlNode);

    method GetAttribute(Name: String): String;
    method GetAttribute(LocalName, NamespaceUri: String): String;
    method GetAttributeNode(Name: String): XmlAttribute;
    method GetAttributeNode(LocalName, NamespaceUri: String): XmlAttribute;

    method SetAttribute(Name, Value: String);
    method SetAttribute(LocalName, NamespaceUri, Value: String);
    method SetAttributeNode(Node: XmlAttribute): XmlAttribute;

    method RemoveAttribute(Name: String);
    method RemoveAttribute(LocalName, NamespaceUri: String);
    method RemoveAttributeNode(Node: XmlAttribute): XmlAttribute;

    method HasAttribute(Name: String): Boolean;
    method HasAttribute(LocalName, NamespaceUri: String): Boolean;
    
    property Attributes: array of XmlAttribute read GetAttributes;
  end;

  XmlCharacterData = public class (XmlNode)  
  private
    method GetData: String;
    method SetData(aValue: String);
    method GetLength: Integer;

    method NSMakeRange(loc: Int32; len: Int32): Foundation.NSRange;
  public
    property Data: String read GetData write SetData;
    property Length: Integer read GetLength;

    method AppendData(Value: String);
    method DeleteData(Offset, Count: Integer);
    method InsertData(Offset: Integer; Value: String);
    method ReplaceData(Offset, Count: Integer; WithValue: String);
    method Substring(Offset, Count: Integer): String;
  end;

  XmlCDataSection = public class (XmlCharacterData)
  end;

  XmlComment = public class (XmlCharacterData)
  end;

  XmlText = public class (XmlCharacterData)
  end;

  XmlProcessingInstruction = public class (XmlNode)
  private
    method GetData: String;
    method SetData(aValue: String);
  public
    property Data: String read GetData write SetData;
    property Target: String read Node.Name;
  end;

  XmlDocumentType = public class (XmlNode)
  private
    property DocumentType: NSXMLDTD read Node as NSXMLDTD;
    method GetEntities: array of XmlNode;
    method GetNotations: array of XmlNode;
  public
    property Entities: array of XmlNode read GetEntities;
    //property InternalSubset: String read DocumentType.InternalSubset;
    property PublicId: String read DocumentType.publicID;
    property SystemId: String read DocumentType.systemID;
    property Notations: array of XmlNode read GetNotations;
  end;

  XmlAttribute = public class (XmlNode)
  public
    property OwnerElement: XmlElement read iif(Node.parent = nil, nil, new XmlElement(Node.parent));
    property Specified: Boolean read true;
  end;

  XmlEntity = public class (XmlNode)
  private
    property Entity: NSXMLDTDNode read Node as NSXMLDTDNode;
  public
    property NontationName: String read Entity.notationName;
    property PublicId: String read Entity.PublicId;
    property SystemId: String read Entity.SystemId;
  end;

  XmlNotation = public class (XmlNode)
  private
    property Entity: NSXMLDTDNode read Node as NSXMLDTDNode;
  public
    property PublicId: String read Entity.PublicId;
    property SystemId: String read Entity.SystemId;
  end;

  XmlDocument = public class (XmlNode)
  private
    property Doc: NSXMLDocument read Node as NSXMLDocument;
    method GetElement(Name: String): XmlElement;
  public
    property DocumentElement: XmlElement read iif(Doc.rootElement = nil, nil, new XmlElement(Doc.rootElement));
    property DocumentType: XmlDocumentType read iif(Doc.DTD = nil, nil, new XmlDocumentType(Doc.DTD));
    property Element[Name: String]: XmlElement read GetElement; default;

    method AddChild(Node: XmlNode);
    method RemoveChild(Node: XmlNode);
    method ReplaceChild(Node: XmlNode; WithNode: XmlNode);

    method CreateAttribute(Name: String): XmlAttribute;
    method CreateAttribute(QualifiedName: String; NamespaceUri: String): XmlAttribute;
    method CreateCDataSection(Data: String): XmlCDataSection;
    method CreateComment(Data: String): XmlComment;
    method CreateElement(Name: String): XmlElement;
    method CreateElement(QualifiedName: String; NamespaceUri: String): XmlElement;
    method CreateProcessingInstruction(Target, Data: String): XmlProcessingInstruction;
    method CreateTextNode(Data: String): XmlText;    

    method GetElementById(ElementId: String): XmlElement;
    method GetElementsByTagName(Name: String): array of XmlNode;
    method GetElementsByTagName(LocalName, NamespaceUri: String): array of XmlNode;

    class method LoadDocument(FileName: String): XmlDocument;
    class method CreateDocument: XmlDocument;

    method Save(FileName: String);
    method Save(FileName: String; XmlDeclaration: XmlDocumentDeclaration);
    method Save(FileName: String; Version: String; Encoding: String; Standalone: Boolean);
  end;
  {$ENDIF}

  XmlDocumentDeclaration = public class
  public
    constructor; empty;
    constructor(aVersion: String; anEncoding: String; aStandalone: Boolean);

    property Encoding: String read write;
    property Standalone: Boolean read write;
    property StandaloneString: String read iif(Standalone, "yes", "no");
    property Version: String read write;
  end;

implementation

{$IF COOPER OR ECHOES}

{ XmlNode }

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

{$IF COOPER}
class method XmlNode.CreateCompatibleNode(Node: Node): XmlNode;
begin
  if Node = nil then
    exit nil;

  case Node.NodeType of
    Node.ATTRIBUTE_NODE: exit new XmlAttribute(Node);
    Node.CDATA_SECTION_NODE: exit new XmlCDataSection(Node);
    Node.COMMENT_NODE: exit new XmlComment(Node);
    Node.DOCUMENT_NODE: exit nil;
    Node.DOCUMENT_TYPE_NODE: exit new XmlDocumentType(Node);
    Node.ELEMENT_NODE: exit new XmlElement(Node);
    Node.ENTITY_NODE: exit new XmlEntity(Node);
    Node.NOTATION_NODE: exit new XmlNotation(Node);
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
		System.Xml.XmlNodeType.Whitespace: exit new XmlText(Node); //whitespaces
		System.Xml.XmlNodeType.SignificantWhitespace: exit new XmlText(Node);
    System.Xml.XmlNodeType.Entity: exit new XmlEntity(Node);
    System.Xml.XmlNodeType.Notation: exit new XmlNotation(Node);
    System.Xml.XmlNodeType.XmlDeclaration: exit new XmlDeclaration(Node);
    else
      exit new XmlNode(Node);
  end;
end;
{$ENDIF}

{ XmlElement }

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
  var ItemsCount: Integer := {$IF COOPER}Element.Attributes.Length{$ELSE}Element.Attributes.Count{$ENDIF};
  var lItems: array of XmlAttribute := new XmlAttribute[ItemsCount];
  for i: Integer := 0 to ItemsCount-1 do
    lItems[i] := new XmlAttribute(Element.Attributes.Item(i));

  exit lItems;
end;

method XmlElement.GetAttribute(Name: String): String;
begin
  exit Element.GetAttribute(Name);
end;

method XmlElement.GetAttribute(LocalName: String; NamespaceUri: String): String;
begin
  {$IF COOPER}
  exit Element.GetAttributeNs(NamespaceUri, LocalName);
  {$ELSE}
  exit Element.GetAttribute(LocalName, NamespaceUri);
  {$ENDIF}
end;

method XmlElement.GetAttributeNode(Name: String): XmlAttribute;
begin
  var lResult := Element.GetAttributeNode(Name);
  if lResult <> nil then
    exit new XmlAttribute(lResult);
end;

method XmlElement.GetAttributeNode(LocalName: String; NamespaceUri: String): XmlAttribute;
begin
  {$IF COOPER}
  var lResult := Element.GetAttributeNodeNs(NamespaceUri, LocalName);
  {$ELSE}
  var lResult := Element.GetAttributeNode(Name);
  {$ENDIF}  
  if lResult <> nil then
    exit new XmlAttribute(lResult);
end;

method XmlElement.SetAttribute(Name: String; Value: String);
begin
  Element.SetAttribute(Name, Value);
end;

method XmlElement.SetAttribute(LocalName: String; NamespaceUri: String; Value: String);
begin
  {$IF COOPER}
  Element.SetAttributeNS(NamespaceUri, LocalName, Value);
  {$ELSE}
  Element.SetAttribute(LocalName, NamespaceUri, Value);
  {$ENDIF}    
end;

method XmlElement.SetAttributeNode(Node: XmlAttribute): XmlAttribute;
begin
  {$IF COOPER}
  exit new XmlAttribute(Element.SetAttributeNode(Node.Node as Attr));
  {$ELSE}
  exit new XmlAttribute(Element.SetAttributeNode(Node.Node as System.Xml.XmlAttribute));
  {$ENDIF}
end;

method XmlElement.RemoveAttribute(Name: String);
begin
  Element.RemoveAttribute(Name);
end;

method XmlElement.RemoveAttribute(LocalName: String; NamespaceUri: String);
begin
  {$IF COOPER}
  Element.RemoveAttributeNs(NamespaceUri, LocalName);
  {$ELSE}
  Element.RemoveAttribute(LocalName, NamespaceUri);
  {$ENDIF}
end;

method XmlElement.RemoveAttributeNode(Node: XmlAttribute): XmlAttribute;
begin
  {$IF COOPER}
  exit new XmlAttribute(Element.RemoveAttributeNode(Node.Node as Attr));
  {$ELSE}
  exit new XmlAttribute(Element.RemoveAttributeNode(Node.Node as System.Xml.XmlAttribute));
  {$ENDIF}
end;

method XmlElement.HasAttribute(Name: String): Boolean;
begin
  exit Element.HasAttribute(Name);
end;

method XmlElement.HasAttribute(LocalName: String; NamespaceUri: String): Boolean;
begin
  {$IF COOPER}
  exit Element.HasAttributeNs(NamespaceUri, LocalName);
  {$ELSE}
  exit Element.HasAttribute(LocalName, NamespaceUri);
  {$ENDIF}
end;

{ XmlCharacterData }

method XmlCharacterData.AppendData(Value: String);
begin
  CharacterData.AppendData(Value);
end;

method XmlCharacterData.DeleteData(Offset: Integer; Count: Integer);
begin
  CharacterData.DeleteData(Offset, Count);
end;

method XmlCharacterData.InsertData(Offset: Integer; Value: String);
begin
  CharacterData.InsertData(Offset, Value);
end;

method XmlCharacterData.ReplaceData(Offset: Integer; Count: Integer; WithValue: String);
begin
  CharacterData.ReplaceData(Offset, Count, WithValue);
end;

method XmlCharacterData.Substring(Offset: Integer; Count: Integer): String;
begin
  {$IF COOPER}
  exit CharacterData.substringData(Offset, Count);
  {$ELSE}
  exit CharacterData.Substring(Offset, Count);
  {$ENDIF}
end;

{ XmlDocumentType }

method XmlDocumentType.GetEntities: array of XmlNode;
begin
  var ItemsCount: Integer := DocumentType.Entities.{$IF COOPER}length{$ELSEIF ECHOES}Count{$ENDIF};
  var lEntitites: array of XmlNode := new XmlNode[ItemsCount];
  for i: Integer := 0 to ItemsCount-1 do
    lEntitites[i] := CreateCompatibleNode(DocumentType.Entities.Item(i));

  exit lEntitites;
end;

method XmlDocumentType.GetNotations: array of XmlNode;
begin
  var ItemsCount: Integer := DocumentType.Notations.{$IF COOPER}length{$ELSEIF ECHOES}Count{$ENDIF};
  var lNotations: array of XmlNode := new XmlNode[ItemsCount];
  for i: Integer := 0 to ItemsCount-1 do
    lNotations[i] := CreateCompatibleNode(DocumentType.Notations.Item(i));

  exit lNotations;
end;

{ XmlDocument }

method XmlDocument.GetElement(Name: String): XmlElement;
begin
  {$IF COOPER}
  var Item := Doc.FirstChild;

  while (Item <> nil) do begin
    if (Item.NodeType = org.w3c.dom.Node.ELEMENT_NODE) and (Item.NodeName = Name) then
      exit new XmlElement(Item);

    Item := Item.NextSibling;
  end;

  exit nil;
  {$ELSE}
  var lResult := Doc[Name];
  if lResult <> nil then
    exit new XmlElement(lResult)
  else
    exit nil;
  {$ENDIF}
end;

method XmlDocument.CreateAttribute(Name: String): XmlAttribute;
begin
  exit new XmlAttribute(Doc.CreateAttribute(Name));
end;

method XmlDocument.CreateAttribute(QualifiedName: String; NamespaceUri: String): XmlAttribute;
begin
  {$IF COOPER}
  exit new XmlAttribute(Doc.CreateAttributeNs(NamespaceUri, QualifiedName));
  {$ELSE}
  exit new XmlAttribute(Doc.CreateAttribute(QualifiedName, NamespaceUri));
  {$ENDIF}
end;

method XmlDocument.CreateCDataSection(Data: String): XmlCDataSection;
begin
  exit new XmlCDataSection(Doc.CreateCDataSection(Data));
end;

method XmlDocument.CreateComment(Data: String): XmlComment;
begin
  exit new XmlComment(Doc.CreateComment(Data));
end;

method XmlDocument.CreateElement(Name: String): XmlElement;
begin
  exit new XmlElement(Doc.CreateElement(Name));
end;

method XmlDocument.CreateElement(QualifiedName: String; NamespaceUri: String): XmlElement;
begin
  {$IF COOPER}
  exit new XmlElement(Doc.CreateElementNs(NamespaceUri, QualifiedName));
  {$ELSE}
  exit new XmlElement(Doc.CreateElement(QualifiedName, NamespaceUri));
  {$ENDIF}
end;

method XmlDocument.CreateProcessingInstruction(Target: String; Data: String): XmlProcessingInstruction;
begin
  exit new XmlProcessingInstruction(Doc.CreateProcessingInstruction(Target, Data));
end;

method XmlDocument.CreateTextNode(Data: String): XmlText;
begin
  exit new XmlText(Doc.CreateTextNode(Data));
end;

method XmlDocument.GetElementById(ElementId: String): XmlElement;
begin
  var lResult := Doc.GetElementById(ElementId);
  if lResult <> nil then
    exit new XmlElement(lResult)
  else
    exit nil;
end;

method XmlDocument.GetElementsByTagName(Name: String): array of XmlNode;
begin
  exit ConvertNodeList(Doc.GetElementsByTagName(Name));
end;

method XmlDocument.GetElementsByTagName(LocalName: String; NamespaceUri: String): array of XmlNode;
begin
  {$IF COOPER}
  exit ConvertNodeList(Doc.GetElementsByTagNameNs(NamespaceUri, LocalName));
  {$ELSE}
  exit ConvertNodeList(Doc.GetElementsByTagName(LocalName, NamespaceUri));
  {$ENDIF}
end;

class method XmlDocument.LoadDocument(FileName: String): XmlDocument;
begin
  {$IF COOPER}
  var Factory := javax.xml.parsers.DocumentBuilderFactory.newInstance;
  var Builder := Factory.newDocumentBuilder();  
  var Document := Builder.parse(new java.io.File(FileName));
  exit new XmlDocument(Document);
  {$ELSE}
  var Document := new System.Xml.XmlDocument();
  Document.PreserveWhitespace := true;
  Document.Load(FileName);
  exit new XmlDocument(Document);
  {$ENDIF}
end;

class method XmlDocument.CreateDocument: XmlDocument;
begin
  {$IF COOPER}
  var Factory := javax.xml.parsers.DocumentBuilderFactory.newInstance;
  var Builder := Factory.newDocumentBuilder();  
  exit new XmlDocument(Builder.newDocument());
  {$ELSE}
  exit new XmlDocument(new System.Xml.XmlDocument());
  {$ENDIF}
end;

method XmlDocument.Save(FileName: String);
begin
  Save(FileName, nil);
end;

method XmlDocument.Save(FileName: String; Version: String; Encoding: String; Standalone: Boolean);
begin
  Save(FileName, new XmlDocumentDeclaration(Version, Encoding, Standalone));
end;

method XmlDocument.Save(FileName: String; XmlDeclaration: XmlDocumentDeclaration);
begin
  {$IF COOPER}
  var Factory := javax.xml.transform.TransformerFactory.newInstance();
  var Transformer := Factory.newTransformer();
  var Source: javax.xml.transform.dom.DOMSource := new javax.xml.transform.dom.DOMSource(Doc);
  
  Transformer.setOutputProperty(javax.xml.transform.OutputKeys.INDENT, "yes");
  Transformer.setOutputProperty(javax.xml.transform.OutputKeys.METHOD, "xml");

  if XmlDeclaration <> nil then begin
    Transformer.setOutputProperty(javax.xml.transform.OutputKeys.ENCODING, XmlDeclaration.Encoding);
    Transformer.setOutputProperty(javax.xml.transform.OutputKeys.VERSION, XmlDeclaration.Version);
    Transformer.setOutputProperty(javax.xml.transform.OutputKeys.STANDALONE, XmlDeclaration.StandaloneString);
  end;

  var Stream := new javax.xml.transform.stream.StreamResult(new java.io.File(FileName));
  Transformer.transform(Source, Stream);
  {$ELSE}
  var lDeclaration: System.Xml.XmlDeclaration := System.Xml.XmlDeclaration(Doc.FirstChild);
  
  if XmlDeclaration <> nil then begin
    if lDeclaration <> nil then
      Doc.RemoveChild(lDeclaration);
    
    lDeclaration := Doc.CreateXmlDeclaration(XmlDeclaration.Version, XmlDeclaration.Encoding, XmlDeclaration.StandaloneString);
    Doc.InsertBefore(lDeclaration, Doc.FirstChild);
  end;
  
  Doc.Save(FileName);
  {$ENDIF}
end;

method XmlDocument.AddChild(Node: XmlNode);
begin
  Doc.appendChild(Node.Node);
end;

method XmlDocument.RemoveChild(Node: XmlNode);
begin
  Doc.removeChild(Node.Node);
end;

method XmlDocument.ReplaceChild(Node: XmlNode; WithNode: XmlNode);
begin
  Doc.replaceChild(WithNode.Node, Node.Node);
end;

{$ELSEIF NOUGAT}

{ XmlNode }

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
    NSXMLNodeKind.NSXMLEntityDeclarationKind: exit new XmlEntity(Node);
    NSXMLNodeKind.NSXMLNotationDeclarationKind: exit new XmlNotation(Node);
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

method XmlNode.SetInnerText(aValue: String);
begin
  Node.setStringValue(aValue);
end;

method XmlNode.SetValue(aValue: String);
begin
  Node.setObjectValue(aValue);
end;

method XmlNode.SelectNodes(XPath: String): array of XmlNode;
begin
  var Error: NSError := nil;
  var Nodes := Node.nodesForXPath(XPath) error(@Error);
  exit ConvertNodeList(Nodes);
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

{ XmlElement }

method XmlElement.AddChild(Node: XmlNode);
begin
  Element.addChild(Node.Node);
end;

method XmlElement.GetAttribute(LocalName: String; NamespaceUri: String): String;
begin
  var Node := Element.attributeForLocalName(LocalName) URI(NamespaceUri);
  exit Node:stringValue;
end;

method XmlElement.GetAttribute(Name: String): String;
begin
  exit Element.attributeForName(Name):stringValue;
end;

method XmlElement.GetAttributeNode(LocalName: String; NamespaceUri: String): XmlAttribute;
begin
  var Node := Element.attributeForLocalName(LocalName) URI(NamespaceUri);
  if Node <> nil then
    exit new XmlAttribute withNode(Node);
end;

method XmlElement.GetAttributeNode(Name: String): XmlAttribute;
begin
  var Node := Element.attributeForName(Name);
  if Node <> nil then
    exit new XmlAttribute withNode(Node);
end;

method XmlElement.GetAttributes: array of XmlAttribute;
begin
  var lAttributes := Element.attributes;
  if lAttributes = nil then
    exit nil;

  result := new XmlAttribute[lAttributes.count];
  for i: Integer := 0 to lAttributes.Count-1 do
    result[i] := new XmlAttribute withNode(lAttributes.objectAtIndex(i));
end;

method XmlElement.HasAttribute(LocalName: String; NamespaceUri: String): Boolean;
begin
  exit Element.attributeForLocalName(LocalName) URI(NamespaceUri) <> nil;
end;

method XmlElement.HasAttribute(Name: String): Boolean;
begin
  exit Element.attributeForName(Name) <> nil;
end;

method XmlElement.RemoveAttribute(LocalName: String; NamespaceUri: String);
begin
  var lAttribute := GetAttributeNode(LocalName, NamespaceUri);
  RemoveAttributeNode(lAttribute);
end;

method XmlElement.RemoveAttribute(Name: String);
begin
  Element.removeAttributeForName(Name);
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

method XmlElement.SetAttribute(LocalName: String; NamespaceUri: String; Value: String);
begin
  var lNode := NSXMLNode.attributeWithName(LocalName) URI(NamespaceUri) stringValue(Value);
  Element.addAttribute(lNode);
end;

method XmlElement.SetAttribute(Name: String; Value: String);
begin
  var lNode := NSXMLNode.attributeWithName(Name) stringValue(Value);
  Element.addAttribute(lNode);
end;

method XmlElement.SetAttributeNode(Node: XmlAttribute): XmlAttribute;
begin
  Element.addAttribute(Node.Node);
end;

{ XmlCharacterData }

method XmlCharacterData.AppendData(Value: String);
begin
  var lData: NSMutableString := NSMutableString.stringWithString(Node.stringValue);
  lData.appendString(Value);
  Node.setStringValue(lData);
end;

method XmlCharacterData.DeleteData(Offset: Integer; Count: Integer);
begin
  var lData: NSMutableString := NSMutableString.stringWithString(Node.stringValue);
  lData.deleteCharactersInRange(NSMakeRange(Offset, Count));
  Node.setStringValue(lData);
end;

method XmlCharacterData.GetData: String;
begin
  exit Node.stringValue;
end;

method XmlCharacterData.GetLength: Integer;
begin
  exit Node.stringValue.length;
end;

method XmlCharacterData.InsertData(Offset: Integer; Value: String);
begin
  var lData: NSMutableString := NSMutableString.stringWithString(Node.stringValue);
  lData.insertString(Value) atIndex(Offset);
  Node.setStringValue(lData);
end;

method XmlCharacterData.ReplaceData(Offset: Integer; Count: Integer; WithValue: String);
begin
  var lData: NSMutableString := NSMutableString.stringWithString(Node.stringValue);
  lData.replaceCharactersInRange(NSMakeRange(Offset, Count)) withString(WithValue);
  Node.setStringValue(lData);
end;

method XmlCharacterData.SetData(aValue: String);
begin
  Node.setStringValue(aValue);
end;

method XmlCharacterData.Substring(Offset: Integer; Count: Integer): String;
begin
  exit Node.stringValue.substringWithRange(NSMakeRange(Offset, Count));
end;

method XmlCharacterData.NSMakeRange(loc: Int32; len: Int32): NSRange;
begin 
  result.location := loc;
  result.length := len;
end;

{ XmlProcessingInstruction }

method XmlProcessingInstruction.GetData: String;
begin
  exit Node.stringValue;
end;

method XmlProcessingInstruction.SetData(aValue: String);
begin
  Node.setStringValue(aValue);
end;

{ XmlDocumentType }

method XmlDocumentType.GetEntities: array of XmlNode;
begin
  var Items: NSMutableArray := new NSMutableArray();

  for i: Integer := 0 to DocumentType.ChildCount-1 do begin
    var Item := DocumentType.childAtIndex(i);
    if Item.kind = NSXMLNodeKind.NSXMLEntityDeclarationKind then
      Items.addObject(Item);
  end;

  exit ConvertNodeList(Items);
end;

method XmlDocumentType.GetNotations: array of XmlNode;
begin
  var Items: NSMutableArray := new NSMutableArray();

  for i: Integer := 0 to DocumentType.ChildCount-1 do begin
    var Item := DocumentType.childAtIndex(i);
    if Item.kind = NSXMLNodeKind.NSXMLNotationDeclarationKind then
      Items.addObject(Item);
  end;

  exit ConvertNodeList(Items);
end;

{ XmlDocument }

method XmlDocument.AddChild(Node: XmlNode);
begin
  Doc.addChild(Node.Node);
end;

method XmlDocument.CreateAttribute(Name: String): XmlAttribute;
begin
  var lNode := NSXMLNode.attributeWithName(Name) stringValue(nil);
  exit new XmlAttribute(lNode);
end;

method XmlDocument.CreateAttribute(QualifiedName: String; NamespaceUri: String): XmlAttribute;
begin
  var lNode := NSXMLNode.attributeWithName(QualifiedName) URI(NamespaceUri) stringValue(nil);
  exit new XmlAttribute(lNode);
end;

method XmlDocument.CreateCDataSection(Data: String): XmlCDataSection;
begin
  var lNode := new NSXMLNode withKind(NSXMLNodeKind.NSXMLTextKind) options(NSXMLNodeIsCDATA);
  lNode.setStringValue(Data);
  exit new XmlCDataSection(lNode);
end;

method XmlDocument.CreateComment(Data: String): XmlComment;
begin
  var lNode := NSXMLNode.commentWithStringValue(Data);
  exit new XmlComment(lNode);
end;

class method XmlDocument.CreateDocument: XmlDocument;
begin
  var lNode := new NSXMLDocument();
  exit new XmlDocument(lNode);
end;

method XmlDocument.CreateElement(Name: String): XmlElement;
begin
  var lNode := NSXMLNode.elementWithName(Name);
  exit new XmlElement(lNode);
end;

method XmlDocument.CreateElement(QualifiedName: String; NamespaceUri: String): XmlElement;
begin
  var lNode := NSXMLNode.elementWithName(QualifiedName) URI(NamespaceUri);
  exit new XmlElement(lNode);
end;

method XmlDocument.CreateProcessingInstruction(Target: String; Data: String): XmlProcessingInstruction;
begin
  var lNode := NSXMLNode.processingInstructionWithName(Target) stringValue(Data);
  exit new XmlProcessingInstruction(lNode);
end;

method XmlDocument.CreateTextNode(Data: String): XmlText;
begin
  var lNode := NSXMLNode.textWithStringValue(Data);
  exit new XmlText(lNode);
end;

method XmlDocument.GetElement(Name: String): XmlElement;
begin
  var Item: NSXMLNode := Doc.children.objectAtIndex(0);

  while (Item <> nil) do begin
    if (Item.kind = NSXMLNodeKind.NSXMLElementKind) and (Item.name = Name) then
      exit new XmlElement(Item);

    Item := Item.nextSibling;
  end;

  exit nil;
end;

method XmlDocument.GetElementById(ElementId: String): XmlElement;
begin
  var Item := FirstChild;

  if Item = nil then
    exit nil;

  while Item <> nil do begin
    if Item.Node.kind = NSXMLNodeKind.NSXMLElementKind then begin
      var Attr := XmlElement(Item).GetAttributeNode("id");
      if (Attr <> nil) and (Attr.Value = ElementId) then
        exit Item as XmlElement;
    end;

    Item := Item.NextSibling;
  end;
end;

method XmlDocument.GetElementsByTagName(LocalName: String; NamespaceUri: String): array of XmlNode;
begin
  var Nodes := Doc.rootElement.elementsForLocalName(LocalName) URI(NamespaceUri);
  exit ConvertNodeList(Nodes);
end;

method XmlDocument.GetElementsByTagName(Name: String): array of XmlNode;
begin
  var Nodes := Doc.rootElement.elementsForName(Name);
  exit ConvertNodeList(Nodes);
end;

class method XmlDocument.LoadDocument(FileName: String): XmlDocument;
begin
  var Url := new NSURL fileURLWithPath(FileName);
  var lNode := new NSXMLDocument withContentsOfURL(Url) options(NSXMLDocumentTidyXML) error(nil);
  exit new XmlDocument(lNode);
end;

method XmlDocument.RemoveChild(Node: XmlNode);
begin
  Doc.removeChildAtIndex(Node.Node.index);
end;

method XmlDocument.ReplaceChild(Node: XmlNode; WithNode: XmlNode);
begin
  Doc.replaceChildAtIndex(Node.Node.index) withNode(WithNode.Node);
end;

method XmlDocument.Save(FileName: String);
begin
  Save(FileName, nil);  
end;

method XmlDocument.Save(FileName: String; Version: String; Encoding: String; Standalone: Boolean);
begin
  Save(FileName, new XmlDocumentDeclaration(Version := Version, Encoding := Encoding, Standalone := Standalone));
end;

method XmlDocument.Save(FileName: String; XmlDeclaration: XmlDocumentDeclaration);
begin
  if XmlDeclaration <> nil then begin
    Doc.setCharacterEncoding(XmlDeclaration.Encoding);
    Doc.setVersion(XmlDeclaration.Version);
    Doc.setStandalone(XmlDeclaration.Standalone);
  end;

  var Data: NSData := Doc.XMLData;
  Data.writeToFile(FileName) atomically(true);
end;
{$ENDIF}

{ XmlDocumentDeclaration }

constructor XmlDocumentDeclaration(aVersion: String; anEncoding: String; aStandalone: Boolean);
begin
  Version := aVersion;
  Encoding := anEncoding;
  Standalone := aStandalone;
end;

end.
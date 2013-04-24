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
  System.IO.IsolatedStorage,
  {$ELSEIF NOUGAT}
  Foundation,
  {$ENDIF}
  RemObjects.Oxygene.Sugar;

type
  XmlDocument = public class (XmlNode)
  private
    property Doc: {$IF COOPER}Document{$ELSEIF WINDOWS_PHONE}XDocument{$ELSEIF NOUGAT}NSXMLDocument{$ELSE}System.Xml.XmlDocument{$ENDIF} 
                  read Node as {$IF COOPER}Document{$ELSEIF WINDOWS_PHONE}XDocument{$ELSEIF NOUGAT}NSXMLDocument{$ELSE}System.Xml.XmlDocument{$ENDIF};
    method GetElement(Name: String): XmlElement;
  public
    {$IF WINDOWS_PHONE}
    property DocumentElement: XmlElement read iif(Doc.Root = nil, nil, new XmlElement(Doc.Root));
    property DocumentType: XmlDocumentType read iif(Doc.DocumentType = nil, nil, new XmlDocumentType(Doc.DocumentType));
    {$ELSEIF COOPER}
    property DocumentElement: XmlElement read iif(Doc.DocumentElement = nil, nil, new XmlElement(Doc.DocumentElement));
    property DocumentType: XmlDocumentType read iif(Doc.Doctype = nil, nil, new XmlDocumentType(Doc.Doctype));
    {$ELSEIF ECHOES}
    property DocumentElement: XmlElement read iif(Doc.DocumentElement = nil, nil, new XmlElement(Doc.DocumentElement));
    property DocumentType: XmlDocumentType read iif(Doc.DocumentType = nil, nil, new XmlDocumentType(Doc.DocumentType));
    {$ELSEIF NOUGAT}
    property DocumentElement: XmlElement read iif(Doc.rootElement = nil, nil, new XmlElement(Doc.rootElement));
    property DocumentType: XmlDocumentType read iif(Doc.DTD = nil, nil, new XmlDocumentType(Doc.DTD));
    {$ENDIF}

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

{$IF COOPER}
method XmlDocument.GetElement(Name: String): XmlElement;
begin
  var Item := Doc.FirstChild;

  while (Item <> nil) do begin
    if (Item.NodeType = org.w3c.dom.Node.ELEMENT_NODE) and (Item.NodeName = Name) then
      exit new XmlElement(Item);

    Item := Item.NextSibling;
  end;

  exit nil;
end;

method XmlDocument.CreateAttribute(Name: String): XmlAttribute;
begin
  exit new XmlAttribute(Doc.createAttribute(Name));
end;

method XmlDocument.CreateAttribute(QualifiedName: String; NamespaceUri: String): XmlAttribute;
begin
  exit new XmlAttribute(Doc.createAttributeNS(NamespaceUri, QualifiedName));
end;

method XmlDocument.CreateCDataSection(Data: String): XmlCDataSection;
begin
  exit new XmlCDataSection(Doc.createCDATASection(Data));
end;

method XmlDocument.CreateComment(Data: String): XmlComment;
begin
  exit new XmlComment(Doc.createComment(Data));
end;

method XmlDocument.CreateElement(Name: String): XmlElement;
begin
  exit new XmlElement(Doc.createElement(Name));
end;

method XmlDocument.CreateElement(QualifiedName: String; NamespaceUri: String): XmlElement;
begin
  exit new XmlElement(Doc.createElementNS(NamespaceUri, QualifiedName));
end;

method XmlDocument.CreateProcessingInstruction(Target: String; Data: String): XmlProcessingInstruction;
begin
  exit new XmlProcessingInstruction(Doc.createProcessingInstruction(Target, Data));
end;

method XmlDocument.CreateTextNode(Data: String): XmlText;
begin
  exit new XmlText(Doc.createTextNode(Data));
end;

method XmlDocument.GetElementById(ElementId: String): XmlElement;
begin
  var lResult := Doc.getElementById(ElementId);
  if lResult <> nil then
    exit new XmlElement(lResult)
  else
    exit nil;
end;

method XmlDocument.GetElementsByTagName(Name: String): array of XmlNode;
begin
  exit ConvertNodeList(Doc.getElementsByTagName(Name));
end;

method XmlDocument.GetElementsByTagName(LocalName: String; NamespaceUri: String): array of XmlNode;
begin
  exit ConvertNodeList(Doc.getElementsByTagNameNS(NamespaceUri, LocalName));
end;

class method XmlDocument.LoadDocument(FileName: String): XmlDocument;
begin
  var Factory := javax.xml.parsers.DocumentBuilderFactory.newInstance;
  var Builder := Factory.newDocumentBuilder();  
  var Document := Builder.parse(new java.io.File(FileName));
  exit new XmlDocument(Document);
end;

class method XmlDocument.CreateDocument: XmlDocument;
begin
  var Factory := javax.xml.parsers.DocumentBuilderFactory.newInstance;
  var Builder := Factory.newDocumentBuilder();  
  exit new XmlDocument(Builder.newDocument());
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
{$ELSEIF ECHOES}
  {$IF WINDOWS_PHONE}
  method XmlDocument.AddChild(Node: XmlNode);
  begin
    Doc.Add(Node.Node);
  end;

  method XmlDocument.CreateAttribute(Name: String): XmlAttribute;
  begin
    var Attr := new XAttribute(System.String(Name), "");
    exit new XmlAttribute(Attr);
  end;

  method XmlDocument.CreateAttribute(QualifiedName: String; NamespaceUri: String): XmlAttribute;
  begin
    var ns: XNamespace := System.String(NamespaceUri);
    var Attr := new XAttribute(ns + QualifiedName, "");
    exit new XmlAttribute(Attr);
  end;

  method XmlDocument.CreateCDataSection(Data: String): XmlCDataSection;
  begin
    var CData := new XCData(Data);
    exit new XmlCDataSection(CData);
  end;

  method XmlDocument.CreateComment(Data: String): XmlComment;
  begin
    var Comment := new XComment(Data);
    exit new XmlComment(Comment);
  end;

  class method XmlDocument.CreateDocument: XmlDocument;
  begin
    var Doc := new XDocument;
    exit new XmlDocument(Doc);
  end;

  method XmlDocument.CreateElement(Name: String): XmlElement;
  begin
    var el := new XElement(System.String(Name));
    exit new XmlElement(el);
  end;

  method XmlDocument.CreateElement(QualifiedName: String; NamespaceUri: String): XmlElement;
  begin
    var ns: XNamespace := System.String(NamespaceUri);
    var el := new XElement(ns + QualifiedName);
    exit new XmlElement(el);
  end;

  method XmlDocument.CreateProcessingInstruction(Target: String; Data: String): XmlProcessingInstruction;
  begin
    var pi := new XProcessingInstruction(Target, Data);
    exit new XmlProcessingInstruction(pi);
  end;

  method XmlDocument.CreateTextNode(Data: String): XmlText;
  begin
    var text := new XText(Data);
    exit new XmlText(text);
  end;

  method XmlDocument.GetElement(Name: String): XmlElement;
  begin
    var el := Doc.Element(System.String(Name));
    if el <> nil then
      exit new XmlElement(el);
  end;

  method XmlDocument.GetElementById(ElementId: String): XmlElement;
  begin
    var Item := FirstChild;

    if Item = nil then
      exit nil;

    while Item <> nil do begin
      if Item.Node.NodeType = System.Xml.XmlNodeType.Element then begin
        var Attr := XmlElement(Item).GetAttributeNode("id");
        if (Attr <> nil) and (Attr.Value = ElementId) then
          exit Item as XmlElement;
      end;

      Item := Item.NextSibling;
    end;
  end;

  method XmlDocument.GetElementsByTagName(LocalName: String; NamespaceUri: String): array of XmlNode;
  begin
    var ns: XNamespace := System.String(NamespaceUri);
    var items := Doc.Elements(ns + LocalName):ToArray;
    result := new XmlNode[items.Length];
    for I: Integer := 0 to items.Length - 1 do
      result[I] := CreateCompatibleNode(items[I]);
  end;

  method XmlDocument.GetElementsByTagName(Name: String): array of XmlNode;
  begin  
    var items := Doc.Elements(System.String(Name)):ToArray;
    result := new XmlNode[items.Length];
    for I: Integer := 0 to items.Length - 1 do
      result[I] := CreateCompatibleNode(items[I]);
  end;

  class method XmlDocument.LoadDocument(FileName: String): XmlDocument;
  begin
    var document := XDocument.Load(FileName, LoadOptions.SetBaseUri);
    exit new XmlDocument(document);
  end;

  method XmlDocument.RemoveChild(Node: XmlNode);
  begin
    (Node.Node as XNode):&Remove;
  end;

  method XmlDocument.ReplaceChild(Node: XmlNode; WithNode: XmlNode);
  begin
    (Node.Node as XNode):ReplaceWith(WithNode.Node);
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
    if XmlDeclaration <> nil then
      Doc.Declaration := new XDeclaration(XmlDeclaration.Version, XmlDeclaration.Encoding, XmlDeclaration.StandaloneString);

    using isoStore: IsolatedStorageFile := IsolatedStorageFile.GetUserStoreForApplication do
      using isoStream: IsolatedStorageFileStream := new IsolatedStorageFileStream(FileName, System.IO.FileMode.Create, isoStore) do
        Doc.Save(isoStream);
  end;
  {$ELSE}
  method XmlDocument.GetElement(Name: String): XmlElement;
  begin
    var lResult := Doc[Name];
    if lResult <> nil then
      exit new XmlElement(lResult)
    else
      exit nil;
  end;

  method XmlDocument.CreateAttribute(Name: String): XmlAttribute;
  begin
    exit new XmlAttribute(Doc.CreateAttribute(Name));
  end;

  method XmlDocument.CreateAttribute(QualifiedName: String; NamespaceUri: String): XmlAttribute;
  begin
    exit new XmlAttribute(Doc.CreateAttribute(QualifiedName, NamespaceUri));
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
    exit new XmlElement(Doc.CreateElement(QualifiedName, NamespaceUri));
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
    exit ConvertNodeList(Doc.GetElementsByTagName(LocalName, NamespaceUri));
  end;

  class method XmlDocument.LoadDocument(FileName: String): XmlDocument;
  begin
    var Document := new System.Xml.XmlDocument();
    Document.PreserveWhitespace := false;
    Document.Load(FileName);
    exit new XmlDocument(Document);
  end;

  class method XmlDocument.CreateDocument: XmlDocument;
  begin
    exit new XmlDocument(new System.Xml.XmlDocument());
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
    var lDeclaration: System.Xml.XmlDeclaration := System.Xml.XmlDeclaration(Doc.FirstChild);
  
    if XmlDeclaration <> nil then begin
      if lDeclaration <> nil then
        Doc.RemoveChild(lDeclaration);
    
      lDeclaration := Doc.CreateXmlDeclaration(XmlDeclaration.Version, XmlDeclaration.Encoding, XmlDeclaration.StandaloneString);
      Doc.InsertBefore(lDeclaration, Doc.FirstChild);
    end;
  
    Doc.Save(FileName);
  end;

  method XmlDocument.AddChild(Node: XmlNode);
  begin
    Doc.AppendChild(Node.Node);
  end;

  method XmlDocument.RemoveChild(Node: XmlNode);
  begin
    Doc.RemoveChild(Node.Node);
  end;

  method XmlDocument.ReplaceChild(Node: XmlNode; WithNode: XmlNode);
  begin
    Doc.ReplaceChild(WithNode.Node, Node.Node);
  end;
  {$ENDIF}
{$ELSEIF NOUGAT}
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
  var lError: NSError;
  var lNode := new NSXMLDocument withContentsOfURL(Url) options(NSXMLDocumentTidyXML) error(var lError);
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

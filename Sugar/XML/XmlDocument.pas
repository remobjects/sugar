﻿namespace RemObjects.Oxygene.Sugar.Xml;

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
  RemObjects.Oxygene.Sugar,
  RemObjects.Oxygene.Sugar.IO;

{$IF NOUGAT}
  {$WARNING XmlDocument for Nougat should be re-written based on libxml2, for iOS support. }
{$ENDIF}

type
  XmlDocument = public class (XmlNode)
  private
    {$IF COOPER}
    property Doc: Document read Node as Document;
    {$ELSEIF ECHOES}
    property Doc: XDocument read Node as XDocument;
    {$ELSEIF NOUGAT}
    property Doc: NSXMLDocument read Node as NSXMLDocument;
    {$ENDIF}
    method GetElement(Name: String): XmlElement;
  public
    {$IF ECHOES}
    property DocumentElement: XmlElement read iif(Doc.Root = nil, nil, new XmlElement(Doc.Root));
    property DocumentType: XmlDocumentType read iif(Doc.DocumentType = nil, nil, new XmlDocumentType(Doc.DocumentType));
    {$ELSEIF COOPER}
    property DocumentElement: XmlElement read iif(Doc.DocumentElement = nil, nil, new XmlElement(Doc.DocumentElement));
    property DocumentType: XmlDocumentType read iif(Doc.Doctype = nil, nil, new XmlDocumentType(Doc.Doctype));
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

    class method FromFile(FileName: String): XmlDocument;
    class method FromBinary(aBinary: Binary): XmlDocument;
    class method FromString(aString: String): XmlDocument;
    class method CreateDocument: XmlDocument;

    method Save(aFile: File);
    method Save(aFile: File; XmlDeclaration: XmlDocumentDeclaration);
    method Save(aFile: File; Version: String; Encoding: String; Standalone: Boolean);
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
  exit new XmlAttribute(Doc.CreateAttribute(Name));
end;

method XmlDocument.CreateAttribute(QualifiedName: String; NamespaceUri: String): XmlAttribute;
begin
  exit new XmlAttribute(Doc.CreateAttributeNs(NamespaceUri, QualifiedName));
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
  exit new XmlElement(Doc.CreateElementNs(NamespaceUri, QualifiedName));
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
  exit ConvertNodeList(Doc.GetElementsByTagNameNs(NamespaceUri, LocalName));
end;

class method XmlDocument.FromFile(FileName: String): XmlDocument;
begin
  var Factory := javax.xml.parsers.DocumentBuilderFactory.newInstance;
  var Builder := Factory.newDocumentBuilder();  
  var Document := Builder.parse(new java.io.File(FileName));
  exit new XmlDocument(Document);
end;

class method XmlDocument.FromBinary(aBinary: Binary): XmlDocument;
begin
  var Factory := javax.xml.parsers.DocumentBuilderFactory.newInstance;
  var Builder := Factory.newDocumentBuilder();  
  var Document := Builder.parse(new java.io.ByteArrayInputStream(aBinary.ToArray));
  exit new XmlDocument(Document);
end;

class method XmlDocument.FromString(aString: String): XmlDocument;
begin
  var Factory := javax.xml.parsers.DocumentBuilderFactory.newInstance;
  var Builder := Factory.newDocumentBuilder();  
  var Document := Builder.parse(aString);
  exit new XmlDocument(Document);
end;

class method XmlDocument.CreateDocument: XmlDocument;
begin
  var Factory := javax.xml.parsers.DocumentBuilderFactory.newInstance;
  var Builder := Factory.newDocumentBuilder();  
  exit new XmlDocument(Builder.newDocument());
end;

method XmlDocument.Save(aFile: File);
begin
  Save(aFile, nil);
end;

method XmlDocument.Save(aFile: File; Version: String; Encoding: String; Standalone: Boolean);
begin
  Save(aFile, new XmlDocumentDeclaration(Version, Encoding, Standalone));
end;

method XmlDocument.Save(aFile: File; XmlDeclaration: XmlDocumentDeclaration);
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

  var Stream := new javax.xml.transform.stream.StreamResult(aFile);
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

class method XmlDocument.FromFile(FileName: String): XmlDocument;
begin
  var document := XDocument.Load(FileName, LoadOptions.SetBaseUri);
  result := new XmlDocument(document);
end;

class method XmlDocument.FromBinary(aBinary: Binary): XmlDocument;
begin
  var document := Xdocument.Load(aBinary.Data);
  result := new XmlDocument(document);
end;

class method XmlDocument.FromString(aString: String): XmlDocument;
begin
  var document := XDocument.Parse(aString);
  result := new XmlDocument(document);
end;

method XmlDocument.RemoveChild(Node: XmlNode);
begin
  (Node.Node as XNode):&Remove;
end;

method XmlDocument.ReplaceChild(Node: XmlNode; WithNode: XmlNode);
begin
  (Node.Node as XNode):ReplaceWith(WithNode.Node);
end;

method XmlDocument.Save(aFile: File);
begin
  Save(aFile, nil);
end;

method XmlDocument.Save(aFile: File; Version: String; Encoding: String; Standalone: Boolean);
begin
  Save(aFile, new XmlDocumentDeclaration(Version, Encoding, Standalone));
end;

method XmlDocument.Save(aFile: File; XmlDeclaration: XmlDocumentDeclaration);
begin
  if XmlDeclaration <> nil then
    Doc.Declaration := new XDeclaration(XmlDeclaration.Version, XmlDeclaration.Encoding, XmlDeclaration.StandaloneString);

  {$IF WINDOWS_PHONE OR NETFX_CORE}
  var sb := new StringBuilder;
  var writer := new System.IO.StringWriter(sb);
  Doc.Save(writer);
  aFile.WriteText(sb.ToString);
  {$ELSEIF ECHOES}
  Doc.Save(aFile);
  {$ENDIF}
end;
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

class method XmlDocument.FromFile(FileName: String): XmlDocument;
begin
  var Url := new NSURL fileURLWithPath(FileName);
  var lError: NSError;
  var lNode := new NSXMLDocument withContentsOfURL(Url) options(NSXMLDocumentTidyXML) error(var lError);
  if not assigned(lNode) then raise new SugarNSErrorException withError(lError);
  result := new XmlDocument(lNode);
end;

class method XmlDocument.FromBinary(aBinary: Binary): XmlDocument;
begin
  var lError: NSError;
  var lNode := new NSXMLDocument withData(aBinary) options(NSXMLDocumentTidyXML) error(var lError);
  if not assigned(lNode) then raise new SugarNSErrorException withError(lError);
  result := new XmlDocument(lNode);
end;

class method XmlDocument.FromString(aString: String): XmlDocument;
begin
  var lError: NSError;
  var lNode := new NSXMLDocument withXMLString(aString) options(NSXMLDocumentTidyXML) error(var lError);
  if not assigned(lNode) then raise new SugarNSErrorException withError(lError);
  result := new XmlDocument(lNode);
end;

method XmlDocument.RemoveChild(Node: XmlNode);
begin
  Doc.removeChildAtIndex(Node.Node.index);
end;

method XmlDocument.ReplaceChild(Node: XmlNode; WithNode: XmlNode);
begin
  Doc.replaceChildAtIndex(Node.Node.index) withNode(WithNode.Node);
end;

method XmlDocument.Save(aFile: File);
begin
  Save(aFile, nil);  
end;

method XmlDocument.Save(aFile: File; Version: String; Encoding: String; Standalone: Boolean);
begin
  Save(aFile, new XmlDocumentDeclaration(Version := Version, Encoding := Encoding, Standalone := Standalone));
end;

method XmlDocument.Save(aFile: File; XmlDeclaration: XmlDocumentDeclaration);
begin
  if XmlDeclaration <> nil then begin
    Doc.setCharacterEncoding(XmlDeclaration.Encoding);
    Doc.setVersion(XmlDeclaration.Version);
    Doc.setStandalone(XmlDeclaration.Standalone);
  end;

  var Data: NSData := Doc.XMLData;
  Data.writeToFile(aFile) atomically(true);
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
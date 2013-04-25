namespace RemObjects.Oxygene.Sugar.Xml;

{$HIDE W0} //supress case-mismatch errors

interface

uses
  {$IF COOPER}
  org.w3c.dom,
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  System.Xml.Linq,
  {$ELSEIF NOUGAT}
  Foundation,
  {$ENDIF}
  RemObjects.Oxygene.Sugar;

type
  XmlDocumentType = public class (XmlNode)
  private
    property DocumentType: {$IF COOPER}DocumentType{$ELSEIF WINDOWS_PHONE OR NETFX_CORE}XDocumentType{$ELSEIF NOUGAT}NSXMLDTD{$ELSEIF ECHOES}System.Xml.XmlDocumentType{$ENDIF}
                            read Node as {$IF COOPER}DocumentType{$ELSEIF WINDOWS_PHONE OR NETFX_CORE}XDocumentType{$ELSEIF NOUGAT}NSXMLDTD{$ELSEIF ECHOES}System.Xml.XmlDocumentType{$ENDIF};

    method GetEntities: array of XmlNode;
    method GetNotations: array of XmlNode;
  public
    property Entities: array of XmlNode read GetEntities;
    property InternalSubset: String read {$IF NOUGAT}DocumentType.description{$ELSE}DocumentType.InternalSubset{$ENDIF};
    property PublicId: String read DocumentType.PublicId;
    property SystemId: String read DocumentType.SystemId;
    property Notations: array of XmlNode read GetNotations;
  end;
implementation

{$IF WINDOWS_PHONE OR NETFX_CORE}
method XmlDocumentType.GetEntities: array of XmlNode;
begin
  exit new XmlNode[0];
end;

method XmlDocumentType.GetNotations: array of XmlNode;
begin
  exit new XmlNode[0];
end;
{$ELSEIF COOPER OR ECHOES}
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
{$ELSEIF NOUGAT}
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
{$ENDIF}

end.

namespace RemObjects.Oxygene.Sugar.Xml;

{$HIDE W0} //supress case-mismatch errors

interface

uses
  {$IF COOPER}
  org.w3c.dom,
  {$ELSEIF ECHOES}
  System.Xml.Linq,
  {$ELSEIF NOUGAT}
  Foundation,
  {$ENDIF}
  RemObjects.Oxygene.Sugar;

type
  XmlDocumentType = public class (XmlNode)
  private
    property DocumentType: {$IF COOPER}DocumentType{$ELSEIF ECHOES}XDocumentType{$ELSEIF NOUGAT}{$IF IOS}^libxml.__struct__xmlDtd{$ELSEIF OSX}NSXMLDTD{$ENDIF}{$ENDIF}
                            read {$IF IOS}^libxml.__struct__xmlDtd(Node){$ELSE}Node as {$IF COOPER}DocumentType{$ELSEIF ECHOES}XDocumentType{$ELSEIF NOUGAT}NSXMLDTD{$ENDIF}{$ENDIF};
  public
    property InternalSubset: String read {$IF NOUGAT}{$IF IOS}ToString{$ELSEIF OSX}DocumentType.description{$ENDIF}{$ELSE}DocumentType.InternalSubset{$ENDIF};
    property PublicId: String read {$IF IOS}XmlChar.ToString(DocumentType^.ExternalID){$ELSE}DocumentType.PublicId{$ENDIF};
    property SystemId: String read {$IF IOS}XmlChar.ToString(DocumentType^.SystemID){$ELSE}DocumentType.SystemId{$ENDIF};
  end;
implementation

(*
{$IF ECHOES}
method XmlDocumentType.GetEntities: array of XmlNode;
begin
  exit new XmlNode[0];
end;

method XmlDocumentType.GetNotations: array of XmlNode;
begin
  exit new XmlNode[0];
end;
{$ELSEIF COOPER}
method XmlDocumentType.GetEntities: array of XmlNode;
begin
  var ItemsCount: Integer := DocumentType.Entities.length;
  var lEntitites: array of XmlNode := new XmlNode[ItemsCount];
  for i: Integer := 0 to ItemsCount-1 do
    lEntitites[i] := CreateCompatibleNode(DocumentType.Entities.Item(i));

  exit lEntitites;
end;

method XmlDocumentType.GetNotations: array of XmlNode;
begin
  var ItemsCount: Integer := DocumentType.Notations.length;
  var lNotations: array of XmlNode := new XmlNode[ItemsCount];
  for i: Integer := 0 to ItemsCount-1 do
    lNotations[i] := CreateCompatibleNode(DocumentType.Notations.Item(i));

  exit lNotations;
end;
{$ELSEIF NOUGAT}
method XmlDocumentType.GetEntities: array of XmlNode;
begin
  {$IF IOS}
  exit new XmlNode[0];
  {$ELSEIF OSX}
  var Items: NSMutableArray := new NSMutableArray();

  for i: Integer := 0 to DocumentType.ChildCount-1 do begin
    var Item := DocumentType.childAtIndex(i);
    if Item.kind = NSXMLNodeKind.NSXMLEntityDeclarationKind then
      Items.addObject(Item);
  end;

  exit ConvertNodeList(Items);
  {$ENDIF}
end;

method XmlDocumentType.GetNotations: array of XmlNode;
begin
  {$IF IOS}
  exit new XmlNode[0];
  {$ELSEIF OSX}
  var Items: NSMutableArray := new NSMutableArray();

  for i: Integer := 0 to DocumentType.ChildCount-1 do begin
    var Item := DocumentType.childAtIndex(i);
    if Item.kind = NSXMLNodeKind.NSXMLNotationDeclarationKind then
      Items.addObject(Item);
  end;

  exit ConvertNodeList(Items);
  {$ENDIF}
end;
{$ENDIF}
*)

end.

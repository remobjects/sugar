namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.Xml,
  RemObjects.Elements.EUnit;

type
  DocumentTypeTest = public class (Test)
  private
    Doc: XmlDocument;
    Data: XmlDocumentType;
  public
    method Setup; override;
    method Name;
    method LocalName;
    method PublicId;
    method SystemId;
    method NodeType;
    method AccessFromDocument;
    method Childs;
    method Value;
  end;

implementation

method DocumentTypeTest.Setup;
begin
  Doc := XmlDocument.FromString(XmlTestData.DTDXml);
  Assert.IsNotNil(Doc);
  Data := Doc.FirstChild as XmlDocumentType;
  Assert.IsNotNil(Data);
end;

method DocumentTypeTest.PublicId;
begin
  Assert.IsNotNil(Data.PublicId);
  Assert.AreEqual(Data.PublicId, "");

  Doc := XmlDocument.FromString(XmlTestData.CharXml);
  Assert.IsNotNil(Doc);
  Assert.IsNotNil(Doc.DocumentType);
  Assert.IsNotNil(Doc.DocumentType.PublicId);
  Assert.AreEqual(Doc.DocumentType.PublicId, "-//W3C//DTD XHTML 1.0 Transitional//EN");
end;

method DocumentTypeTest.SystemId;
begin
  Assert.IsNotNil(Data.SystemId);
  Assert.AreEqual(Data.SystemId, "");

  Doc := XmlDocument.FromString(XmlTestData.CharXml);
  Assert.IsNotNil(Doc);
  Assert.IsNotNil(Doc.DocumentType);
  Assert.IsNotNil(Doc.DocumentType.SystemId);
  Assert.AreEqual(Doc.DocumentType.SystemId, "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd");
end;

method DocumentTypeTest.NodeType;
begin
  Assert.AreEqual(Data.NodeType, XmlNodeType.DocumentType);
end;

method DocumentTypeTest.AccessFromDocument;
begin
  Assert.IsNotNil(Doc.DocumentType);
  Assert.IsTrue(Doc.DocumentType.Equals(Data));
end;

method DocumentTypeTest.Name;
begin
  Assert.IsNotNil(Data.Name);
  Assert.AreEqual(Data.Name, "note");
end;

method DocumentTypeTest.LocalName;
begin
  Assert.IsNotNil(Data.LocalName);
  Assert.AreEqual(Data.LocalName, "note");
end;

method DocumentTypeTest.Childs;
begin
  Assert.AreEqual(Data.ChildCount, 0);
  Assert.IsNil(Data.FirstChild);
  Assert.IsNil(Data.LastChild);
  Assert.AreEqual(length(Data.ChildNodes), 0);
end;

method DocumentTypeTest.Value;
begin
  Assert.IsNil(Data.Value);
end;

end.

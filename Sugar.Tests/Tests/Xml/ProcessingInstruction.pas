namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.Xml,
  RemObjects.Elements.EUnit;

type
  ProcessingInstructionTest = public class (Test)
  private
    Doc: XmlDocument;
    Data: XmlProcessingInstruction;
  public
    method Setup; override;
    method Value;
    method TestData;
    method Target;
    method NodeType;
  end;

implementation

method ProcessingInstructionTest.Setup;
begin
  Doc := XmlDocument.FromString(XmlTestData.PIXml);
  Assert.IsNotNil(Doc);
  Data := Doc.ChildNodes[0] as XmlProcessingInstruction;
  Assert.IsNotNil(Data);
end;

method ProcessingInstructionTest.Value;
begin
  Assert.IsNotNil(Data.Value);
  Assert.AreEqual(Data.Value, "type=""text/xsl"" href=""test""");
  Data.Value := "type=""text/xsl""";
  Assert.AreEqual(Data.Value, "type=""text/xsl""");
  Assert.Throws(->begin Data.Value := nil; end);

  Data := Doc.ChildNodes[1] as XmlProcessingInstruction;
  Assert.AreEqual(Data.Value, "");
end;

method ProcessingInstructionTest.Target;
begin
  Assert.IsNotNil(Data.Target);
  Assert.AreEqual(Data.Target, "xml-stylesheet");
  Data := Doc.ChildNodes[1] as XmlProcessingInstruction;
  Assert.AreEqual(Data.Target, "custom");
end;

method ProcessingInstructionTest.TestData;
begin
  //Data is the same thing as Value
  Assert.IsNotNil(Data.Data);
  Assert.AreEqual(Data.Data, "type=""text/xsl"" href=""test""");
  Data.Data := "type=""text/xsl""";
  Assert.AreEqual(Data.Data, "type=""text/xsl""");
  Assert.Throws(->begin Data.Data := nil; end);

  Data := Doc.ChildNodes[1] as XmlProcessingInstruction;
  Assert.AreEqual(Data.Data, "");
end;

method ProcessingInstructionTest.NodeType;
begin
  Assert.IsTrue(Data.NodeType = XmlNodeType.ProcessingInstruction);
end;

end.
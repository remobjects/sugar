namespace Sugar.Test;

interface

{$HIDE W0} //supress case-mismatch errors

uses
  Sugar,
  Sugar.Xml,
  Sugar.TestFramework;

type
  ProcessingInstructionTest = public class (Testcase)
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
  Assert.IsNotNull(Doc);
  Data := Doc.ChildNodes[0] as XmlProcessingInstruction;
  Assert.IsNotNull(Data);
end;

method ProcessingInstructionTest.Value;
begin
  Assert.IsNotNull(Data.Value);
  Assert.CheckString("type=""text/xsl"" href=""test""", Data.Value);
  Data.Value := "type=""text/xsl""";
  Assert.CheckString("type=""text/xsl""", Data.Value);
  Assert.IsException(->begin Data.Value := nil; end);

  Data := Doc.ChildNodes[1] as XmlProcessingInstruction;
  Assert.CheckString("", Data.Value);
end;

method ProcessingInstructionTest.Target;
begin
  Assert.IsNotNull(Data.Target);
  Assert.CheckString("xml-stylesheet", Data.Target);
  Data := Doc.ChildNodes[1] as XmlProcessingInstruction;
  Assert.CheckString("custom", Data.Target);
end;

method ProcessingInstructionTest.TestData;
begin
  //Data is the same thing as Value
  Assert.IsNotNull(Data.Data);
  Assert.CheckString("type=""text/xsl"" href=""test""", Data.Data);
  Data.Data := "type=""text/xsl""";
  Assert.CheckString("type=""text/xsl""", Data.Data);
  Assert.IsException(->begin Data.Data := nil; end);

  Data := Doc.ChildNodes[1] as XmlProcessingInstruction;
  Assert.CheckString("", Data.Data);
end;

method ProcessingInstructionTest.NodeType;
begin
  Assert.CheckBool(true, Data.NodeType = XmlNodeType.ProcessingInstruction);
end;

end.
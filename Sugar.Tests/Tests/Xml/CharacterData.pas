namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.Xml,
  RemObjects.Elements.EUnit;

type
  CharacterDataTest = public class (Test)
  private
    Doc: XmlDocument;
    Text: XmlText;
    CData: XmlCDataSection;
    Comment: XmlComment;

    method Data(Node: XmlCharacterData; Content: String);
    method Length(Node: XmlCharacterData; Content: String);
    method Value(Node: XmlCharacterData; Content: String);
    method AppendData(Node: XmlCharacterData; Content: String);
    method DeleteData(Node: XmlCharacterData; Content: String);
    method InsertData(Node: XmlCharacterData; Content: String);
    method ReplaceData(Node: XmlCharacterData; Content: String);
    method Substring(Node: XmlCharacterData; Content: String);
  public
    method Setup; override;
    method Data;
    method Length;
    method Value;
    method AppendData;
    method DeleteData;
    method InsertData;
    method ReplaceData;
    method Substring;
    method NodeType;
  end;

implementation

method CharacterDataTest.Setup;
begin
  Doc := XmlDocument.FromString(XmlTestData.CharXml);
  Assert.IsNotNil(Doc);
  var Node := Doc["Book"];
  Assert.IsNotNil(Node);
  Text := Node[0].FirstChild as XmlText;
  Assert.IsNotNil(Text);
  var X := Node[1].FirstChild;
  CData := X as XmlCDataSection;
  Assert.IsNotNil(CData);
  Comment := Node[2] as XmlComment;
  Assert.IsNotNil(Comment);
end;

method CharacterDataTest.AppendData;
begin
  AppendData(Text, "Text");
  AppendData(CData, "Description");
  AppendData(Comment, "Comment");
end;

method CharacterDataTest.DeleteData;
begin
  DeleteData(Text, "Text");
  DeleteData(CData, "Description");
  DeleteData(Comment, "Comment");
end;

method CharacterDataTest.InsertData;
begin
  InsertData(Text, "Text");
  InsertData(CData, "Description");
  InsertData(Comment, "Comment");
end;

method CharacterDataTest.ReplaceData;
begin
  ReplaceData(Text, "Text");
  ReplaceData(CData, "Description");
  ReplaceData(Comment, "Comment");
end;

method CharacterDataTest.Substring;
begin
  Substring(Text, "Text");
  Substring(CData, "Description");
  Substring(Comment, "Comment");
end;

method CharacterDataTest.Data;
begin
  Data(Text, "Text");
  Data(CData, "Description");
  Data(Comment, "Comment");
end;

method CharacterDataTest.Length;
begin
  Length(Text, "Text");
  Length(CData, "Description");
  Length(Comment, "Comment");
end;

method CharacterDataTest.Value;
begin
  Value(Text, "Text");
  Value(CData, "Description");
  Value(Comment, "Comment");
end;

method CharacterDataTest.AppendData(Node: XmlCharacterData; Content: String);
begin
  Assert.IsNotNil(Node);
  Assert.AreEqual(Node.Data, Content);
  Node.AppendData("Test");
  Assert.AreEqual(Node.Data, Content+"Test");
  Node.AppendData(nil);
  Assert.AreEqual(Node.Data, Content+"Test");
end;

method CharacterDataTest.Data(Node: XmlCharacterData; Content: String);
begin
  Assert.IsNotNil(Node);
  Assert.IsNotNil(Node.Data);
  Assert.AreEqual(Node.Data, Content);
  Node.Data := "Test";
  Assert.AreEqual(Node.Data, "Test");
  Assert.Throws(->begin Node.Data := nil; end);
end;

method CharacterDataTest.DeleteData(Node: XmlCharacterData; Content: String);
begin
  Assert.IsNotNil(Node);
  Assert.AreEqual(Node.Data, Content);
  Node.Data := "Test";
  Assert.AreEqual(Node.Data, "Test");
  Node.DeleteData(1, 2);
  Assert.AreEqual(Node.Data, "Tt");
  Assert.Throws(->Node.DeleteData(-1, 1));
  Assert.Throws(->Node.DeleteData(1, -1));
  Assert.Throws(->Node.DeleteData(25, 1));
  Assert.Throws(->Node.DeleteData(1, 25));
end;

method CharacterDataTest.InsertData(Node: XmlCharacterData; Content: String);
begin
  Assert.IsNotNil(Node);
  Assert.AreEqual(Node.Data, Content);
  Node.Data := "Tt";
  Assert.AreEqual(Node.Data, "Tt");
  Node.InsertData(1, "es");
  Assert.AreEqual(Node.Data, "Test");
  Assert.Throws(->Node.InsertData(-1, "x"));
  Assert.Throws(->Node.InsertData(55, "x"));
  Assert.Throws(->Node.InsertData(1, nil));
end;

method CharacterDataTest.Length(Node: XmlCharacterData; Content: String);
begin
  Assert.IsNotNil(Node);
  Assert.AreEqual(Node.Data, Content);
  Assert.AreEqual(Node.Length, Content.Length);
  Assert.AreEqual(Node.Length, Node.Data.Length);
  Node.Data := "Test";
  Assert.AreEqual(Node.Data, "Test");
  Assert.AreEqual(Node.Length, 4);
end;

method CharacterDataTest.ReplaceData(Node: XmlCharacterData; Content: String);
begin
  Assert.IsNotNil(Node);
  Assert.AreEqual(Node.Data, Content);
  Node.Data := "Test";
  Assert.AreEqual(Node.Data, "Test");
  Node.ReplaceData(1, 2, "arge");
  Assert.AreEqual(Node.Data, "Target");
  Node.ReplaceData(1, 4, "");
  Assert.AreEqual(Node.Data, "Tt");
  Node.ReplaceData(0, Node.Length, "Test");
  Assert.AreEqual(Node.Data, "Test");
  Assert.Throws(->Node.ReplaceData(-1, 1, "x"));
  Assert.Throws(->Node.ReplaceData(1, -1, "x"));
  Assert.Throws(->Node.ReplaceData(55, 1, "x"));
  Assert.Throws(->Node.ReplaceData(1, 55, "x"));
  Assert.Throws(->Node.ReplaceData(1, 1, nil));
end;

method CharacterDataTest.Substring(Node: XmlCharacterData; Content: String);
begin
  Assert.IsNotNil(Node);
  Assert.AreEqual(Node.Data, Content);
  Node.Data := "Test";
  Assert.AreEqual(Node.Data, "Test");
  Assert.AreEqual(Node.Substring(1, 2), "es");
  Assert.AreEqual(Node.Substring(0, Node.Length), "Test");
  Assert.Throws(->Node.Substring(-1, 1));
  Assert.Throws(->Node.Substring(1, -1));
  Assert.Throws(->Node.Substring(55, 1));
  Assert.Throws(->Node.Substring(1, 55));
end;

method CharacterDataTest.Value(Node: XmlCharacterData; Content: String);
begin
  Assert.IsNotNil(Node);
  Assert.IsNotNil(Node.Value);
  Assert.AreEqual(Node.Value, Content);
  Node.Value := "Test";
  Assert.AreEqual(Node.Value, "Test");
  Assert.Throws(->begin Node.Value := nil; end);
end;

method CharacterDataTest.NodeType;
begin
  Assert.AreEqual(Text.NodeType, XmlNodeType.Text);
  Assert.AreEqual(Comment.NodeType, XmlNodeType.Comment);
  Assert.AreEqual(CData.NodeType, XmlNodeType.CDATA);
end;

end.
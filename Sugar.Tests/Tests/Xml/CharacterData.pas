namespace Sugar.Test;

interface

{$HIDE W0} //supress case-mismatch errors

uses
  Sugar,
  Sugar.Xml,
  Sugar.TestFramework;

type
  CharacterDataTest = public class (Testcase)
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
  Assert.IsNotNull(Doc);
  var Node := Doc["Book"];
  Assert.IsNotNull(Node);
  Text := Node[0].FirstChild as XmlText;
  Assert.IsNotNull(Text);
  var X := Node[1].FirstChild;
  CData := X as XmlCDataSection;
  Assert.IsNotNull(CData);
  Comment := Node[2] as XmlComment;
  Assert.IsNotNull(Comment);
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
  Assert.IsNotNull(Node);
  Assert.CheckString(Content, Node.Data);
  Node.AppendData("Test");
  Assert.CheckString(Content+"Test", Node.Data);
  Node.AppendData(nil);
  Assert.CheckString(Content+"Test", Node.Data);
end;

method CharacterDataTest.Data(Node: XmlCharacterData; Content: String);
begin
  Assert.IsNotNull(Node);
  Assert.IsNotNull(Node.Data);
  Assert.CheckString(Content, Node.Data);
  Node.Data := "Test";
  Assert.CheckString("Test", Node.Data);
  Assert.IsException(->begin Node.Data := nil; end);
end;

method CharacterDataTest.DeleteData(Node: XmlCharacterData; Content: String);
begin
  Assert.IsNotNull(Node);
  Assert.CheckString(Content, Node.Data);
  Node.Data := "Test";
  Assert.CheckString("Test", Node.Data);
  Node.DeleteData(1, 2);
  Assert.CheckString("Tt", Node.Data);
  Assert.IsException(->Node.DeleteData(-1, 1));
  Assert.IsException(->Node.DeleteData(1, -1));
  Assert.IsException(->Node.DeleteData(25, 1));
  Assert.IsException(->Node.DeleteData(1, 25));
end;

method CharacterDataTest.InsertData(Node: XmlCharacterData; Content: String);
begin
  Assert.IsNotNull(Node);
  Assert.CheckString(Content, Node.Data);
  Node.Data := "Tt";
  Assert.CheckString("Tt", Node.Data);
  Node.InsertData(1, "es");
  Assert.CheckString("Test", Node.Data);
  Assert.IsException(->Node.InsertData(-1, "x"));
  Assert.IsException(->Node.InsertData(55, "x"));
  Assert.IsException(->Node.InsertData(1, nil));
end;

method CharacterDataTest.Length(Node: XmlCharacterData; Content: String);
begin
  Assert.IsNotNull(Node);
  Assert.CheckString(Content, Node.Data);
  Assert.CheckInt(Content.Length, Node.Length);
  Assert.CheckInt(Node.Data.Length, Node.Length);
  Node.Data := "Test";
  Assert.CheckString("Test", Node.Data);
  Assert.CheckInt(4, Node.Length);
end;

method CharacterDataTest.ReplaceData(Node: XmlCharacterData; Content: String);
begin
  Assert.IsNotNull(Node);
  Assert.CheckString(Content, Node.Data);
  Node.Data := "Test";
  Assert.CheckString("Test", Node.Data);
  Node.ReplaceData(1, 2, "arge");
  Assert.CheckString("Target", Node.Data);  
  Node.ReplaceData(1, 4, "");
  Assert.CheckString("Tt", Node.Data);
  Node.ReplaceData(0, Node.Length, "Test");
  Assert.CheckString("Test", Node.Data);
  Assert.IsException(->Node.ReplaceData(-1, 1, "x"));
  Assert.IsException(->Node.ReplaceData(1, -1, "x"));
  Assert.IsException(->Node.ReplaceData(55, 1, "x"));
  Assert.IsException(->Node.ReplaceData(1, 55, "x"));
  Assert.IsException(->Node.ReplaceData(1, 1, nil));
end;

method CharacterDataTest.Substring(Node: XmlCharacterData; Content: String);
begin
  Assert.IsNotNull(Node);
  Assert.CheckString(Content, Node.Data);
  Node.Data := "Test";
  Assert.CheckString("Test", Node.Data);
  Assert.CheckString("es", Node.Substring(1, 2));
  Assert.CheckString("Test", Node.Substring(0, Node.Length));
  Assert.IsException(->Node.Substring(-1, 1));
  Assert.IsException(->Node.Substring(1, -1));
  Assert.IsException(->Node.Substring(55, 1));
  Assert.IsException(->Node.Substring(1, 55));
end;

method CharacterDataTest.Value(Node: XmlCharacterData; Content: String);
begin
  Assert.IsNotNull(Node);
  Assert.IsNotNull(Node.Value);
  Assert.CheckString(Content, Node.Value);
  Node.Value := "Test";
  Assert.CheckString("Test", Node.Value);
  Assert.IsException(->begin Node.Value := nil; end);
end;

method CharacterDataTest.NodeType;
begin
  Assert.CheckBool(true, Text.NodeType = XmlNodeType.Text);
  Assert.CheckBool(true, Comment.NodeType = XmlNodeType.Comment);
  Assert.CheckBool(true, CData.NodeType = XmlNodeType.CDATA);
end;

end.
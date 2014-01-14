namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.Xml,
  Sugar.TestFramework;

type
  NodeTest = public class (Testcase)
  private
    Doc: XmlDocument;
    Data: XmlNode;
  public
    method Setup; override;

    method Name;
    method Value;
    method LocalName;
    method Document;
    method Parent;
    method NextSibling;
    method PreviousSibling;
    method FirstChild;
    method LastChild;
    method Item;
    method ChildCount;
    method ChildNodes;
  end;

implementation


method NodeTest.Setup;
begin
  Doc := XmlDocument.FromString(XmlTestData.RssXml);
  Assert.IsNotNull(Doc);
  Data := Doc.FirstChild;
  Assert.IsNotNull(Data);
end;

method NodeTest.Name;
begin
  Assert.CheckString("rss", Data.Name);
  var lValue := Data.FirstChild.FirstChild.NextSibling;
  Assert.IsNotNull(lValue);
  Assert.CheckString("{http://www.w3.org/2005/Atom}link", lValue.Name);
  lValue := lValue.NextSibling.FirstChild;
  Assert.IsNotNull(lValue);
  Assert.CheckString("#text", lValue.Name);
end;

method NodeTest.Value;
begin
  var lValue := Data.FirstChild.ChildNodes[2];
  Assert.IsNotNull(lValue);
  Assert.CheckString("http://blogs.remobjects.com", lValue.Value);
  lValue.Value := "http://test.com";
  Assert.CheckString("http://test.com", lValue.Value);

  lValue := Data.FirstChild.ChildNodes[10];
  Assert.IsNotNull(lValue);
  Assert.CheckInt(13, lValue.ChildCount);  
  lValue.Value := "Test"; //replaces all content with text node
  Assert.CheckInt(1, lValue.ChildCount);
  Assert.CheckString("Test", lValue.Value);

  lValue.Value := "";
  Assert.CheckInt(0, lValue.ChildCount);
  Assert.CheckString("", lValue.Value);

  Assert.IsException(->begin lValue.Value := nil; end);
end;

method NodeTest.LocalName;
begin
  Assert.CheckString("rss", Data.LocalName);
  var lValue := Data.FirstChild.FirstChild.NextSibling;
  Assert.IsNotNull(lValue);
  Assert.CheckString("link", lValue.LocalName);
  lValue := lValue.NextSibling.FirstChild;
  Assert.IsNotNull(lValue);
  Assert.CheckString("#text", lValue.LocalName);
end;

method NodeTest.Document;
begin
  Assert.IsNotNull(Data.Document);
  Assert.IsNotNull(Data.FirstChild.Document);
  Assert.CheckBool(true, Data.Document.Equals(Doc));
end;

method NodeTest.Parent;
begin
  Assert.IsNull(Data.Parent);
  Assert.IsNotNull(Data.FirstChild.Parent);
  Assert.CheckBool(true, Data.FirstChild.Parent.Equals(Data));
end;

method NodeTest.NextSibling;
begin
  Assert.IsNull(Data.NextSibling);
  var lValue := Data.FirstChild.FirstChild;
  Assert.CheckBool(true, lValue.Equals(Data.FirstChild.ChildNodes[0]));
  Assert.IsNotNull(lValue.NextSibling);
  Assert.CheckBool(true, lValue.NextSibling.Equals(Data.FirstChild.ChildNodes[1]));
end;

method NodeTest.PreviousSibling;
begin
  Assert.IsNull(Data.PreviousSibling);
  var lValue := Data.FirstChild.LastChild;
  Assert.CheckBool(true, lValue.Equals(Data.FirstChild.ChildNodes[10]));
  Assert.IsNotNull(lValue.PreviousSibling);
  Assert.CheckBool(true, lValue.PreviousSibling.Equals(Data.FirstChild.ChildNodes[9]));
end;

method NodeTest.FirstChild;
begin
  Assert.IsNotNull(Data.FirstChild);
  Assert.CheckString("channel", Data.FirstChild.LocalName);

  var lValue := Data.FirstChild.FirstChild;
  Assert.IsNotNull(lValue);
  Assert.CheckString("title", lValue.LocalName);
end;

method NodeTest.LastChild;
begin
  var lValue := Data.FirstChild.LastChild;
  Assert.IsNotNull(lValue);
  Assert.CheckString("item", lValue.LocalName);
end;

method NodeTest.Item;
begin
  Assert.IsNotNull(Data.Item[0]);
  Assert.CheckString("channel", Data.Item[0].LocalName);
  Assert.IsNotNull(Data[0]);
  Assert.CheckString("channel", Data[0].LocalName);
  Assert.CheckBool(true, Data[0].Equals(Data.FirstChild));
  Assert.IsException(->Data.Item[-1]);
  Assert.IsException(->Data.Item[555]);
end;

method NodeTest.ChildCount;
begin
  Assert.CheckInt(1, Data.ChildCount);
  Assert.CheckInt(11, Data.FirstChild.ChildCount);
end;

method NodeTest.ChildNodes;
begin
  var Expected: array of String := ["title", "link", "link", "description", "lastBuildDate", "#comment", "language", "updatePeriod", "updateFrequency", "generator", "item"];
  var Actual := Data.FirstChild.ChildNodes;
  Assert.CheckInt(11, length(Actual));
  for i: Integer := 0 to length(Actual) - 1 do
    Assert.CheckString(Expected[i], Actual[i].LocalName);
end;

end.
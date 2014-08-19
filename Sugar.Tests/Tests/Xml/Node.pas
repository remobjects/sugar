namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.Xml,
  RemObjects.Elements.EUnit;

type
  NodeTest = public class (Test)
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
  Assert.IsNotNil(Doc);
  Data := Doc.FirstChild;
  Assert.IsNotNil(Data);
end;

method NodeTest.Name;
begin
  Assert.AreEqual(Data.Name, "rss");
  var lValue := Data.FirstChild.FirstChild.NextSibling;
  Assert.IsNotNil(lValue);
  Assert.AreEqual(lValue.Name, "{http://www.w3.org/2005/Atom}link");
  lValue := lValue.NextSibling.FirstChild;
  Assert.IsNotNil(lValue);
  Assert.AreEqual(lValue.Name, "#text");
end;

method NodeTest.Value;
begin
  var lValue := Data.FirstChild.ChildNodes[2];
  Assert.IsNotNil(lValue);
  Assert.AreEqual(lValue.Value, "http://blogs.remobjects.com");
  lValue.Value := "http://test.com";
  Assert.AreEqual(lValue.Value, "http://test.com");

  lValue := Data.FirstChild.ChildNodes[10];
  Assert.IsNotNil(lValue);
  Assert.AreEqual(lValue.ChildCount, 13);
  lValue.Value := "Test"; //replaces all content with text node
  Assert.AreEqual(lValue.ChildCount, 1);
  Assert.AreEqual(lValue.Value, "Test");

  lValue.Value := "";
  Assert.AreEqual(lValue.ChildCount, 0);
  Assert.AreEqual(lValue.Value, "");

  Assert.Throws(->begin lValue.Value := nil; end);
end;

method NodeTest.LocalName;
begin
  Assert.AreEqual(Data.LocalName, "rss");
  var lValue := Data.FirstChild.FirstChild.NextSibling;
  Assert.IsNotNil(lValue);
  Assert.AreEqual(lValue.LocalName, "link");
  lValue := lValue.NextSibling.FirstChild;
  Assert.IsNotNil(lValue);
  Assert.AreEqual(lValue.LocalName, "#text");
end;

method NodeTest.Document;
begin
  Assert.IsNotNil(Data.Document);
  Assert.IsNotNil(Data.FirstChild.Document);
  Assert.IsTrue(Data.Document.Equals(Doc));
end;

method NodeTest.Parent;
begin
  Assert.IsNil(Data.Parent);
  Assert.IsNotNil(Data.FirstChild.Parent);
  Assert.IsTrue(Data.FirstChild.Parent.Equals(Data));
end;

method NodeTest.NextSibling;
begin
  Assert.IsNil(Data.NextSibling);
  var lValue := Data.FirstChild.FirstChild;
  Assert.IsTrue(lValue.Equals(Data.FirstChild.ChildNodes[0]));
  Assert.IsNotNil(lValue.NextSibling);
  Assert.IsTrue(lValue.NextSibling.Equals(Data.FirstChild.ChildNodes[1]));
end;

method NodeTest.PreviousSibling;
begin
  Assert.IsNil(Data.PreviousSibling);
  var lValue := Data.FirstChild.LastChild;
  Assert.IsTrue(lValue.Equals(Data.FirstChild.ChildNodes[10]));
  Assert.IsNotNil(lValue.PreviousSibling);
  Assert.IsTrue(lValue.PreviousSibling.Equals(Data.FirstChild.ChildNodes[9]));
end;

method NodeTest.FirstChild;
begin
  Assert.IsNotNil(Data.FirstChild);
  Assert.AreEqual(Data.FirstChild.LocalName, "channel");

  var lValue := Data.FirstChild.FirstChild;
  Assert.IsNotNil(lValue);
  Assert.AreEqual(lValue.LocalName, "title");
end;

method NodeTest.LastChild;
begin
  var lValue := Data.FirstChild.LastChild;
  Assert.IsNotNil(lValue);
  Assert.AreEqual(lValue.LocalName, "item");
end;

method NodeTest.Item;
begin
  Assert.IsNotNil(Data.Item[0]);
  Assert.AreEqual(Data.Item[0].LocalName, "channel");
  Assert.IsNotNil(Data[0]);
  Assert.AreEqual(Data[0].LocalName, "channel");
  Assert.IsTrue(Data[0].Equals(Data.FirstChild));
  Assert.Throws(->Data.Item[-1]);
  Assert.Throws(->Data.Item[555]);
end;

method NodeTest.ChildCount;
begin
  Assert.AreEqual(Data.ChildCount, 1);
  Assert.AreEqual(Data.FirstChild.ChildCount, 11);
end;

method NodeTest.ChildNodes;
begin
  var Expected: array of String := ["title", "link", "link", "description", "lastBuildDate", "#comment", "language", "updatePeriod", "updateFrequency", "generator", "item"];
  var Actual := Data.FirstChild.ChildNodes;
  Assert.AreEqual(length(Actual), 11);
  for i: Integer := 0 to length(Actual) - 1 do
    Assert.AreEqual(Actual[i].LocalName, Expected[i]);
end;

end.
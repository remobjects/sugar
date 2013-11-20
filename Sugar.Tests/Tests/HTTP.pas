namespace Sugar.Test;

interface

{$HIDE W0} //supress case-mismatch errors

uses
  RemObjects.Oxygene.Sugar,
  RemObjects.Oxygene.Sugar.TestFramework;

type
  HTTPTest = public class (Testcase)
  public
    method BeginDownloadAsString;
    method BeginDownloadAsBinary;
    method BeginDownloadAsXml;
  end;

implementation

method HTTPTest.BeginDownloadAsString;
begin
  {$WARNING Disabled due to bug #65088}
  {var U := Url.FromString("http://example.com");
  var Data := HTTP.BeginDownloadAsString(U);
  Assert.IsNotNull(Data);
  Assert.CheckBool(true, Data.StartsWith("<!doctype html>"));
  Assert.IsException(->assigned(HTTP.BeginDownloadAsString(nil)));
  Assert.IsException(->assigned(HTTP.BeginDownloadAsString(Url.FromString("http://example.com/notexists"))));}
end;

method HTTPTest.BeginDownloadAsBinary;
begin
 { var U := Url.FromString("http://example.com");
  var Data := HTTP.BeginDownloadAsBinary(U);
  Assert.IsNotNull(Data);
  var Line := String.FromByteArray(Data.Read(15));
  Assert.CheckBool(true, Line.StartsWith("<!doctype html>"));
  Assert.IsException(->assigned(HTTP.BeginDownloadAsBinary(nil)));
  Assert.IsException(->assigned(HTTP.BeginDownloadAsBinary(Url.FromString("http://example.com/notexists"))));}
end;

method HTTPTest.BeginDownloadAsXml;
begin
 { var U := Url.FromString("http://blogs.remobjects.com/feed");
  var Doc := HTTP.BeginDownloadAsXml(U);
  Assert.IsNotNull(Doc);
  var Root := Doc.Element["channel"];
  Assert.IsNotNull(Root);
  Assert.CheckString("RemObjects Blogs", Root.ChildNodes[0].Value);
  
  Assert.IsException(->assigned(HTTP.BeginDownloadAsXml(nil)));
  Assert.IsException(->assigned(HTTP.BeginDownloadAsXml(Url.FromString("http://example.com/notexists"))));}
end;

end.
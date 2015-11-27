namespace Sugar.Test;

interface

uses
  Sugar,
  RemObjects.Elements.EUnit;

type
  HTTPTest = public class (Test)
  public
    method DownloadAsString;
    method DownloadAsBinary;
    method DownloadAsXml;
  end;

implementation

method HTTPTest.DownloadAsString;
begin
  var Token := TokenProvider.CreateAwaitToken;
  Http.ExecuteRequestAsString(Encoding.UTF8, new HttpRequest(new Url("http://example.com")), Responce -> begin
      Token.Run(->begin
        Assert.IsNotNil(Responce);
        Assert.IsTrue(Responce.Success);
        Assert.IsNil(Responce.Exception);
        Assert.IsNotNil(Responce.Content);
        Assert.IsTrue(Responce.Content.StartsWith("<!doctype html>"));
      end)
    end);

  Token.WaitFor;
  Token := TokenProvider.CreateAwaitToken;

  Http.ExecuteRequestAsString(Encoding.UTF8, new HttpRequest(new Url("http://example.com/notexists")), Responce -> begin
      Token.Run(->begin
        Assert.IsNotNil(Responce);
        Assert.IsFalse(Responce.Success);
        Assert.IsNotNil(Responce.Exception);
        Assert.IsNil(Responce.Content);
      end)
    end);

  Token.WaitFor;
end;

method HTTPTest.DownloadAsBinary;
begin
  var Token := TokenProvider.CreateAwaitToken;
  Http.ExecuteRequestAsBinary(new HttpRequest(new Url("http://example.com")), Responce -> begin
      Token.Run(->begin
        Assert.IsNotNil(Responce);
        Assert.IsTrue(Responce.Success);
        Assert.IsNil(Responce.Exception);
        Assert.IsNotNil(Responce.Content);
        var Line := new String(Responce.Content.Read(15), Encoding.UTF8);
        Assert.IsTrue(Line.StartsWith("<!doctype html>"));        
      end)
    end);

  Token.WaitFor;
end;

method HTTPTest.DownloadAsXml;
begin
  var Token := TokenProvider.CreateAwaitToken;
  Http.ExecuteRequestAsXml(new HttpRequest(new Url("http://images.apple.com/main/rss/hotnews/hotnews.rss")), Responce -> begin
      Token.Run(->begin
        Assert.IsNotNil(Responce);
        Assert.IsTrue(Responce.Success);
        Assert.IsNil(Responce.Exception);
        Assert.IsNotNil(Responce.Content);
        var Root := Responce.Content.Element["channel"];
        Assert.IsNotNil(Root);
        Assert.AreEqual(Root.ChildNodes[0].Value, "Apple Hot News");        
      end)
    end);

  Token.WaitFor;
end;

end.
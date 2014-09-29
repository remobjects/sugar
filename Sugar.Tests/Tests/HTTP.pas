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
  Http.DownloadStringAsync(new Url("http://example.com"), Encoding.UTF8, Responce -> begin
      Token.Run(->begin
        Assert.IsNotNil(Responce);
        Assert.IsFalse(Responce.IsFailed);
        Assert.IsNil(Responce.Exception);
        Assert.IsNotNil(Responce.Content);
        Assert.IsTrue(Responce.Content.StartsWith("<!doctype html>"));
      end)
    end);

  Token.WaitFor;
  Token := TokenProvider.CreateAwaitToken;

  Http.DownloadStringAsync(new Url("http://example.com/notexists"), Encoding.UTF8, Responce -> begin
      Token.Run(->begin
        Assert.IsNotNil(Responce);
        Assert.IsTrue(Responce.IsFailed);
        Assert.IsNotNil(Responce.Exception);
        Assert.IsNil(Responce.Content);
      end)
    end);

  Token.WaitFor;
  Assert.Throws(->Http.DownloadStringAsync(nil, Encoding.UTF8, x -> begin end));
  Assert.Throws(->Http.DownloadStringAsync(new Url("http://example.com"), Encoding.UTF8, nil));
end;

method HTTPTest.DownloadAsBinary;
begin
  var Token := TokenProvider.CreateAwaitToken;
  Http.DownloadBinaryAsync(new Url("http://example.com"), Responce -> begin
      Token.Run(->begin
        Assert.IsNotNil(Responce);
        Assert.IsFalse(Responce.IsFailed);
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
  Http.DownloadXmlAsync(new Url("http://images.apple.com/main/rss/hotnews/hotnews.rss"), Responce -> begin
      Token.Run(->begin
        Assert.IsNotNil(Responce);
        Assert.IsFalse(Responce.IsFailed);
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
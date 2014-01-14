namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.TestFramework;

type
  HTTPTest = public class (Testcase)
  public
    method DownloadAsString;
    method DownloadAsBinary;
    method DownloadAsXml;
  end;

implementation

method HTTPTest.DownloadAsString;
begin
  var Token: IAsyncToken := NewAsyncToken;
  Http.DownloadStringAsync(new Url("http://example.com"), Responce -> begin
      try
        Assert.IsNotNull(Responce);
        Assert.CheckBool(false, Responce.IsFailed);
        Assert.IsNull(Responce.Exception);
        Assert.IsNotNull(Responce.Content);
        Assert.CheckBool(true, Responce.Content.StartsWith("<!doctype html>"));
        Token.Done;
      except 
        on E: Exception do
          Token.Done(E);
      end;
    end);

  Token.Wait;
  Token := NewAsyncToken;

  Http.DownloadStringAsync(new Url("http://example.com/notexists"), Responce -> begin
      try
        Assert.IsNotNull(Responce);
        Assert.CheckBool(true, Responce.IsFailed);
        Assert.IsNotNull(Responce.Exception);
        Assert.IsNull(Responce.Content);
        Token.Done;
      except 
        on E: Exception do
          Token.Done(E);
      end;
    end);

  Token.Wait;
  Assert.IsException(->Http.DownloadStringAsync(nil, x -> begin end));
  Assert.IsException(->Http.DownloadStringAsync(new Url("http://example.com"), nil));
end;

method HTTPTest.DownloadAsBinary;
begin
  var Token: IAsyncToken := NewAsyncToken;
  Http.DownloadBinaryAsync(new Url("http://example.com"), Responce -> begin
      try
        Assert.IsNotNull(Responce);
        Assert.CheckBool(false, Responce.IsFailed);
        Assert.IsNull(Responce.Exception);
        Assert.IsNotNull(Responce.Content);
        var Line := new String(Responce.Content.Read(15));
        Assert.CheckBool(true, Line.StartsWith("<!doctype html>"));
        Token.Done;
      except
        on E: Exception do
          Token.Done(E);
      end;
    end);

  Token.Wait;
end;

method HTTPTest.DownloadAsXml;
begin
  var Token: IAsyncToken := NewAsyncToken;
  Http.DownloadXmlAsync(new Url("http://images.apple.com/main/rss/hotnews/hotnews.rss"), Responce -> begin
      try
        Assert.IsNotNull(Responce);
        Assert.CheckBool(false, Responce.IsFailed);
        Assert.IsNull(Responce.Exception);
        Assert.IsNotNull(Responce.Content);
        var Root := Responce.Content.Element["channel"];
        Assert.IsNotNull(Root);
        Assert.CheckString("Apple Hot News", Root.ChildNodes[0].Value);
        Token.Done;
      except 
        on E: Exception do
          Token.Done(E);
      end;
    end);

  Token.Wait;
end;

end.
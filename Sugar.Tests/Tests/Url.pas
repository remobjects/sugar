namespace Sugar.Test;

interface

uses
  Sugar,
  RemObjects.Elements.EUnit;

type
  UrlTest = public class (Test)
  private
    Data: Url;
  public
    method Setup; override;
    method FromString;
    method Scheme;
    method Host;
    method Port;
    method Path;
    method QueryString;
    method UserInfo;
    method Fragment;
    method TestToString;
  end;

implementation

method UrlTest.Setup;
begin
  Data := new Url("https://username:password@example.com:8080/users?user_id=42#phone");
end;

method UrlTest.Scheme;
begin
  Assert.AreEqual(Data.Scheme, "https");
  Assert.AreEqual(new Url("ftp://1.1.1.1/").Scheme, "ftp");
end;

method UrlTest.Host;
begin
  Assert.AreEqual(Data.Host, "example.com");
  Assert.AreEqual(new Url("ftp://1.1.1.1/").Host, "1.1.1.1");
end;

method UrlTest.Port;
begin
  Assert.AreEqual(Data.Port, 8080);
  Assert.AreEqual(new Url("ftp://1.1.1.1/").Port, -1);
end;

method UrlTest.Path;
begin
  Assert.AreEqual(Data.Path, "/users");
  Assert.AreEqual(new Url("ftp://1.1.1.1/").Path, "/");
  Assert.AreEqual(new Url("http://1.1.1.1/?id=1").Path, "/");
  Assert.AreEqual(new Url("http://1.1.1.1/page.html").Path, "/page.html");
end;

method UrlTest.QueryString;
begin
  Assert.AreEqual(Data.QueryString, "user_id=42");
  Assert.IsNil(new Url("ftp://1.1.1.1/").QueryString);
end;

method UrlTest.Fragment;
begin
  Assert.AreEqual(Data.Fragment, "phone");
  Assert.IsNil(new Url("ftp://1.1.1.1/").Fragment);
end;

method UrlTest.FromString;
begin
  Assert.AreEqual(new Url("http://example.com/").ToString, "http://example.com/");

  Assert.Throws(->new Url(nil), "Nil");
  Assert.Throws(->new Url(""), "Empty");
  Assert.Throws(->new Url("1http://example.com"), "1http");
  Assert.Throws(->new Url("http_ex://example.com"), "http_ex");
  Assert.Throws(->new Url("http://%$444;"), "url");
end;

method UrlTest.TestToString;
begin
  Assert.AreEqual(Data.ToString, "https://username:password@example.com:8080/users?user_id=42#phone");
  Assert.AreEqual(new Url("ftp://1.1.1.1/").ToString, "ftp://1.1.1.1/");
end;

method UrlTest.UserInfo;
begin
  Assert.AreEqual(Data.UserInfo, "username:password");
  Assert.IsNil(new Url("ftp://1.1.1.1/").UserInfo);
  Assert.AreEqual(new Url("ftp://user@1.1.1.1/").UserInfo, "user");
end;

end.
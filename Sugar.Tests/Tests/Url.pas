namespace Sugar.Test;

interface

{$HIDE W0} //supress case-mismatch errors

uses
  RemObjects.Oxygene.Sugar,
  RemObjects.Oxygene.Sugar.TestFramework;

type
  UrlTest = public class (Testcase)
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
  Data := Url.FromString("https://username:password@example.com:8080/users?user_id=42#phone");
end;

method UrlTest.Scheme;
begin
  Assert.CheckString("https", Data.Scheme);
  Assert.CheckString("ftp", Url.FromString("ftp://1.1.1.1/").Scheme);
end;

method UrlTest.Host;
begin
  Assert.CheckString("example.com", Data.Host);
  Assert.CheckString("1.1.1.1", Url.FromString("ftp://1.1.1.1/").Host);
end;

method UrlTest.Port;
begin
  Assert.CheckInt(8080, Data.Port);
  Assert.CheckInt(-1, Url.FromString("ftp://1.1.1.1/").Port);
end;

method UrlTest.Path;
begin
  Assert.CheckString("/users", Data.Path);
  Assert.CheckString("/", Url.FromString("ftp://1.1.1.1/").Path);
  Assert.CheckString("/", Url.FromString("http://1.1.1.1/?id=1").Path);
  Assert.CheckString("/page.html", Url.FromString("http://1.1.1.1/page.html").Path);
end;

method UrlTest.QueryString;
begin
  Assert.CheckString("user_id=42", Data.QueryString);
  Assert.IsNull(Url.FromString("ftp://1.1.1.1/").QueryString);
end;

method UrlTest.Fragment;
begin
  Assert.CheckString("phone", Data.Fragment);
  Assert.IsNull(Url.FromString("ftp://1.1.1.1/").Fragment);
end;

method UrlTest.FromString;
begin
  Assert.CheckString("http://example.com/", Url.FromString("http://example.com/").ToString);

  Assert.IsException(->Url.FromString(nil), "Nil");
  Assert.IsException(->Url.FromString(""), "Empty");
  Assert.IsException(->Url.FromString("1http://example.com"), "1http");
  Assert.IsException(->Url.FromString("http_ex://example.com"), "http_ex");
  Assert.IsException(->Url.FromString("http://%$444;"), "url");
end;

method UrlTest.TestToString;
begin
  Assert.CheckString("https://username:password@example.com:8080/users?user_id=42#phone", Data.ToString);
  Assert.CheckString("ftp://1.1.1.1/", Url.FromString("ftp://1.1.1.1/").ToString);
end;

method UrlTest.UserInfo;
begin
  Assert.CheckString("username:password", Data.UserInfo);
  Assert.IsNull(Url.FromString("ftp://1.1.1.1/").UserInfo);
  Assert.CheckString("user", Url.FromString("ftp://user@1.1.1.1/").UserInfo);
end;

end.
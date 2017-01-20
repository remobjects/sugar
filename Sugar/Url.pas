namespace Sugar;

interface

type
  {$IF COOPER}
  Url = public class mapped to java.net.URL
  public
    constructor(UriString: String);

    property Scheme: String read mapped.Protocol;
    property Host: String read mapped.Host;
    property Port: Int32 read mapped.Port;
    property Path: String read mapped.Path;
    property QueryString: String read mapped.Query;
    property Fragment: String read mapped.toURI.Fragment;
    property UserInfo: String read mapped.UserInfo;
  {$ELSEIF ECHOES}
  Url = public class mapped to System.Uri
  private
    method GetPort: Integer;
    method GetFragment: String;
    method GetUserInfo: String;
    method GetQueryString: String;
  public
    constructor(UriString: String);

    property Scheme: String read mapped.Scheme;
    property Host: String read mapped.Host;
    property Port: Int32 read GetPort;
    property Path: String read mapped.AbsolutePath;
    property QueryString: String read GetQueryString;
    property Fragment: String read GetFragment;
    property UserInfo: String read GetUserInfo;
  {$ELSEIF TOFFEE}
  Url = public class mapped to Foundation.NSURL
  private
    method GetUserInfo: String;
    method GetPort: Integer;
  public
    constructor(UriString: String);

    property Scheme: String read mapped.scheme;
    property Host: String read mapped.host;
    property Port: Int32 read GetPort;
    property Path: String read mapped.path;
    property QueryString: String read mapped.query;
    property Fragment: String read mapped.fragment;
    property UserInfo: String read GetUserInfo;

    method description: NSString; override; inline;
  {$ENDIF}

    class method UrlEncodeString(aString: String): String;

    method GetParentUrl(): Url;
    method GetSubUrl(aName: String): Url;
  end;

implementation

{$IF TOFFEE}
method Url.description: NSString;
begin
  exit mapped.absoluteString;
end;

method Url.GetUserInfo: String;
begin
  if mapped.user = nil then
    exit nil;

  if mapped.password <> nil then
    exit mapped.user + ":" + mapped.password
  else
    exit mapped.user;
end;

method Url.GetPort: Integer;
begin
  exit if mapped.port = nil then -1 else mapped.port.intValue;
end;
{$ENDIF}

{$IF ECHOES}
method Url.GetPort: Integer;
begin
  if mapped.IsDefaultPort then
    exit -1;

  exit mapped.Port;
end;

method Url.GetFragment: String;
begin
  if mapped.Fragment.Length = 0 then
    exit nil;

  if mapped.Fragment.StartsWith("#") then
    exit mapped.Fragment.Substring(1);

  exit mapped.Fragment;
end;

method Url.GetQueryString: String;
begin
  if mapped.Query.Length = 0 then
    exit nil;

  if mapped.Query.StartsWith("?") then
    exit mapped.Query.Substring(1);

  exit mapped.Query;
end;

method Url.GetUserInfo: String;
begin
  if mapped.UserInfo.Length = 0 then
    exit nil;

  exit mapped.UserInfo;
end;
{$ENDIF}

constructor Url(UriString: String);
begin
  if String.IsNullOrEmpty(UriString) then
    raise new SugarArgumentNullException("UriString");

  {$IF COOPER}
  exit new java.net.URI(UriString).toURL; //URI performs validation
  {$ELSEIF ECHOES}
  exit new System.Uri(UriString);
  {$ELSEIF TOFFEE}
  var Value := Foundation.NSURL.URLWithString(UriString);
  if Value = nil then
    raise new SugarArgumentException("Url was not in correct format");

  var Req := Foundation.NSURLRequest.requestWithURL(Value);
  if not Foundation.NSURLConnection.canHandleRequest(Req) then
    raise new SugarArgumentException("Url was not in correct format");

  exit Value as not nullable;
  {$ENDIF}
end;

class method Url.UrlEncodeString(aString: String): String;
begin
  {$IF COOPER}
  exit java.net.URLEncoder.Encode(aString, 'utf-8');
  {$ELSEIF ECHOES}
  {$IF WINDOWS_PHONE}
  result := System.Net.HttpUtility.UrlEncode(aString);
  {$ELSEIF NETFX_CORE}
  result := System.Net.WebUtility.UrlEncode(aString);
  {$ELSE}
  result := System.Web.HttpUtility.UrlEncode(aString);
  {$ENDIF}
  {$ELSEIF TOFFEE}
  result := NSString(aString).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet);
  {$ENDIF}
end;

method Url.GetParentUrl(): nullable Url;
begin
  if Path = '/' then
    result := nil
  {$IF COOPER}
  else if Path.EndsWith('/') then
    result := mapped.toURI.resolve('..').toURL
  else
    result := mapped.toURI.resolve('.').toURL;
  {$ELSEIF ECHOES}
  else if Path.EndsWith('/') then
    result := new Uri(mapped, '..')
  else
    result := new Uri(mapped, '.');
  {$ELSEIF TOFFEE}
  else
    result := mapped.URLByDeletingLastPathComponent;
  {$ENDIF}
end;

method Url.GetSubUrl(aName: String): Url;
begin
  {$IF COOPER}
  result := mapped.toURI.resolve(aName).toURL
  {$ELSEIF ECHOES}
  result := new Uri(mapped, aName);
  {$ELSEIF TOFFEE}
  result := mapped.URLByAppendingPathComponent(aName);
  {$ENDIF}
end;

end.
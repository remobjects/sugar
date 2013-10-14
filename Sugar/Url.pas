namespace RemObjects.Oxygene.Sugar;

interface

type
  {$IF COOPER}
  Url = public class mapped to java.net.URL
  public
    property Scheme: String read mapped.Protocol;
    property Host: String read mapped.Host;
    property Port: Int32 read mapped.Port;
    property Path: String read mapped.Path;
    property QueryString: String read mapped.Query;
    property Fragment: String read mapped.toURI.Fragment;
    property ToString: String read mapped.toString;

    class method FromString(UriString: String): Url;
  end;
  {$ELSEIF ECHOES}
  Url = public class mapped to System.Uri
  public
    property Scheme: String read mapped.Scheme;
    property Host: String read mapped.Host;
    property Port: Int32 read mapped.Port;
    property Path: String read mapped.AbsolutePath;
    property QueryString: String read mapped.Query;
    property Fragment: String read mapped.Fragment;
    property ToString: String read mapped.ToString;

    class method FromString(UriString: String): Url;
  end;
  {$ELSEIF NOUGAT}
  Url = public class mapped to Foundation.NSURL
  public
    property Scheme: String read mapped.scheme;
    property Host: String read mapped.host;
    property Port: Int32 read mapped.port:intValue;
    property Path: String read mapped.path;
    property QueryString: String read mapped.query;
    property Fragment: String read mapped.fragment;
    property ToString: String read mapped.absoluteString;    
    
    class method FromString(UriString: String): Url;
  end;
  {$ENDIF}

implementation

class method Url.FromString(UriString: String): Url;
begin
  if String.IsNullOrEmpty(UriString) then
    raise new SugarArgumentNullException("UriString");

  {$IF COOPER}
  exit new java.net.URI(UriString).toURL; //URI performs validation
  {$ELSEIF ECHOES}
  exit new System.Uri(UriString);
  {$ELSEIF NOUGAT}
  var Value := Foundation.NSURL.URLWithString(UriString);
  if Value = nil then
    raise new SugarArgumentException("Url was not in correct format");

  var Req := Foundation.NSURLRequest.requestWithURL(Value);
  if not Foundation.NSURLConnection.canHandleRequest(Req) then
    raise new SugarArgumentException("Url was not in correct format");

  exit Value;
  {$ENDIF}
end;

end.

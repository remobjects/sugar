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
   // property Fragment: String read mapped;
    property ToString: String read mapped.toString;
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
  end;
  {$ENDIF}

implementation

end.

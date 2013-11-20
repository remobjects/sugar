namespace RemObjects.Oxygene.Sugar;

interface

uses
  RemObjects.Oxygene.Sugar.IO,
  RemObjects.Oxygene.Sugar.Xml;

type
  HTTP = public static class
  private
  protected
  public
    method BeginDownloadAsString(aURL: Url): future String;
    method BeginDownloadAsBinary(aURL: Url): future Binary;
    method BeginDownloadAsXml(aURL: Url): future XmlDocument;
  end;

implementation

class method HTTP.BeginDownloadAsString(aURL: Url): future String;
begin  
  exit async method: String begin
    SugarArgumentNullException.RaiseIfNil(aURL, "Url");
    {$IF COOPER}
    var Connection := java.net.URL(aURL).openConnection;
    Connection.addRequestProperty("User-Agent", "Mozilla/4.76");
    var Reader := new java.io.BufferedReader(new java.io.InputStreamReader(Connection.InputStream));
    var sb := new StringBuilder;
    var line: String := Reader.readLine;

    while line <> nil do begin
      sb.AppendLine(line);
      line := Reader.readLine;
    end;

    exit sb.toString;
    {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
    var Client := new System.Net.Http.HttpClient();
    exit Client.GetStringAsync(aURL).Result;
    {$ELSEIF ECHOES}
    using lClient: System.Net.WebClient := new System.Net.WebClient() do 
      exit lClient.DownloadString(aURL);  
    {$ELSEIF NOUGAT}
    exit new NSString withContentsOfURL(aURL);
    {$ENDIF}
  end;
end;

class method HTTP.BeginDownloadAsBinary(aURL: Url): future Binary;
begin
  exit async method: Binary begin
    SugarArgumentNullException.RaiseIfNil(aURL, "Url");
    {$IF COOPER}
    result := new Binary;
    var Connection := java.net.URL(aURL).openConnection;
    Connection.addRequestProperty("User-Agent", "Mozilla/4.76");
    var stream := Connection.InputStream;
    var data := new SByte[4096]; 
    var len := stream.read(data);

    while len > 0 do begin
      result.Write(data, len);
      len := stream.read(data);
    end;
    {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
    var Client := new System.Net.Http.HttpClient();
    exit  Binary.FromArray(Client.GetByteArrayAsync(aURL).Result);
    {$ELSEIF ECHOES}
    using lClient: System.Net.WebClient := new System.Net.WebClient() do 
      exit Binary.FromArray(lClient.DownloadData(aURL)); 
    {$ELSEIF NOUGAT}
    var lRequest := NSURLRequest.requestWithURL(aURL);
    var lResponse: NSURLResponse;
    var lError: NSError;
    var lData := NSURLConnection.sendSynchronousRequest(lRequest) returningResponse(var lResponse) error(var lError);

    if not assigned(lData) then  
      raise SugarNSErrorException.exceptionWithError(lError);

    result := lData.mutableCopy;
    {$ENDIF}
  end;
end;

class method HTTP.BeginDownloadAsXml(aURL: Url): future XmlDocument;
begin
  exit async method: XmlDocument begin
    SugarArgumentNullException.RaiseIfNil(aURL, "Url");
    var Bin := BeginDownloadAsBinary(aURL);
    exit XmlDocument.FromBinary(Bin);
  end;
end;

end.

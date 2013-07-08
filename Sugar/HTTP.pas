namespace RemObjects.Oxygene.Sugar;

interface

uses
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
  {$IF COOPER}
  exit async method: String begin
    var Reader := new java.io.BufferedReader(new java.io.InputStreamReader(java.net.URL(aURL).openStream));
    var sb := new StringBuilder;
    var line: String := Reader.readLine;
    while line <> nil do begin
      sb.AppendLine(line);
      line := Reader.readLine;
    end;

    exit sb.toString;
  end;
  {$ELSEIF ECHOES}
  using lClient: System.Net.WebClient := new System.Net.WebClient() do 
    result := lClient.DownloadString(aURL);  
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method HTTP.BeginDownloadAsBinary(aURL: Url): future Binary;
begin
  {$IF COOPER}
  exit async method: Binary begin
    result := new Binary;
    var stream := java.net.URL(aURL).openStream;
    var data := new SByte[4096]; 
    var len := stream.read(data);

    while len > 0 do begin
      result.WriteBytes(RemObjects.Oxygene.Sugar.Cooper.ArrayUtils.ToUnsignedArray(data), len);
      len := stream.read(data);
    end;
  end;
  {$ELSEIF ECHOES}
  using lClient: System.Net.WebClient := new System.Net.WebClient() do 
    result := Binary.FromArray(lClient.DownloadData(aURL));  
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

class method HTTP.BeginDownloadAsXml(aURL: Url): future XmlDocument;
begin
  {$IF COOPER}
  exit async method: XmlDocument begin
    var Bin := BeginDownloadAsBinary(aURL);
    exit XmlDocument.FromBinary(Bin);
  end;
  {$ELSEIF ECHOES}
  result := async method: XmlDocument begin
    using lClient: System.Net.WebClient := new System.Net.WebClient() do begin
      var lData := lClient.DownloadData(aURL);
      using lBinary := Binary.FromArray(lData) do
        result := XmlDocument.FromBinary(lBinary);
    end;
  end;
  {$ELSEIF NOUGAT}

  {$ENDIF}
end;

end.

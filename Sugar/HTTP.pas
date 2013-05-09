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
  {$ELSEIF ECHOES}
  using lClient: System.Net.WebClient := new System.Net.WebClient() do 
    result := lClient.DownloadString(aURL);  
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method HTTP.BeginDownloadAsBinary(aURL: Url): future Binary;
begin
  {$IF COOPER}
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

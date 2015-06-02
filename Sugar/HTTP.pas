namespace Sugar;

interface

uses
  Sugar.Collections,
  Sugar.IO,
  Sugar.Json,
  Sugar.Xml;

type
  HttpRequest = public class
  public
    property Mode: HttpRequestMode := HttpRequestMode.Get; 
    property Headers: not nullable Dictionary<String,String> := new Dictionary<String,String>; readonly;
    property Content: IHttpRequestContent;
    property Url: Url;
    
    constructor(aUrl: Url; aMode: HttpRequestMode := HttpRequestMode.Get);
  end;
  
  HttpRequestMode = public enum (Get, Post);
  
  IHttpRequestContent = public interface
    //method ContentStream();
  end;

  HttpResponse = public class
  unit
    //constructor;
    constructor withException(anException: Exception);

    {$IF NOUGAT}
    var Data: NSData?
    constructor(aData: NSData, aResponse: NSHTTPURLResponse);{
      Code = response.statusCode
      Headers = response.allHeaderFields as! Dictionary<String,String> // why is this cast needed?
      Data = data;
    }
    {$ENDIF}

  public
    property Headers: not nullable Dictionary<String,String>; readonly; //todo: list itself should be read-only
    property Code: Int32; readonly;
    property Success: Boolean read self.Exception = nil;
    property Exception: Exception read write; readonly;
    
    method GetContentAsString(contentCallback: HttpContentResponseBlock<String>);
    method GetContentAsBinary(contentCallback: HttpContentResponseBlock<Binary>);
    method GetContentAsXml(contentCallback: HttpContentResponseBlock<XmlDocument>);
    method GetContentAsJson(contentCallback: HttpContentResponseBlock<JsonDocument>);
  end;
  
  HttpResponseContent<T> = public class
  public
    property Content: T;
    property Success: Boolean read self.Exception = nil;
    property Exception: Exception read write; readonly;
  end;
  
  HttpResponseBlock = public block (Response: HttpResponse);
  HttpContentResponseBlock<T> = public block (ResponseContent: HttpResponseContent<T>);

  Http = public static class
  public
    method ExecuteRequest(aUrl: Url; ResponseCallback: HttpResponseBlock);
    method ExecuteRequest(aRequest: HttpRequest; ResponseCallback: HttpResponseBlock);
  end;

implementation

{ HttpRequest }

constructor HttpRequest(aUrl: Url; aMode: HttpRequestMode := HttpRequestMode.Get);
begin
  Url := aUrl;
  Mode := aMode;
end;

{ HttpResponse }

{constructor HttpResponse;
begin
end;}

constructor HttpResponse withException(anException: Exception);
begin
  self.Exception := anException;
end;

{ Http }

method Http.ExecuteRequest(aUrl: Url; ResponseCallback: HttpResponseBlock);
begin
  ExecuteRequest(new HttpRequest(aUrl, HttpRequestMode.Get), responseCallback);
end;

method Http.ExecuteRequest(aRequest: HttpRequest; ResponseCallback: HttpResponseBlock);
begin
  {$IF NOUGAT}
  var nsUrlRequest := NSURLRequest withURL(request.Url) cachePolicy(0) timeoutInterval(30);
  NSURLConnection.sendAsynchronousRequest(nsUrlRequest queue(nil) callback( (nsUrlResponse, data, error) => begin

    var nsHttpUrlResponse := NSHTTPURLResponse(nsUrlResponse)
    if assigned(data) and assigned(nsHttpUrlResponse) and not assigned(error) then begin
      
      var response := HttpResponse(data, nsHttpUrlResponse);
      responseCallback(response);

    end else if assigned(error) then begin
      
      var response := HttpResponse(new SugarException withError(error));
      responseCallback(response);
      
    end else begin
      var response := HttpResponse(new SugarException("Request failed without providing an error."));
      responseCallback(response);
    end;
    
  end);
  
 {$ENDIF}
end;


{$IF WINDOWS_PHONE}
class method Http.InternalDownload(anUrl: Url): System.Threading.Tasks.Task<System.Net.HttpWebResponse>;
begin
  var Request: System.Net.HttpWebRequest := System.Net.WebRequest.CreateHttp(anUrl);
  Request.Method := "GET";
  Request.UserAgent := "Mozilla/4.76";
  Request.AllowReadStreamBuffering := true;

  var TaskComplete := new System.Threading.Tasks.TaskCompletionSource<System.Net.HttpWebResponse>;

  Request.BeginGetResponse(x -> begin
                             try
                              var ResponseRequest := System.Net.HttpWebRequest(x.AsyncState);
                              var Response := System.Net.HttpWebResponse(ResponseRequest.EndGetResponse(x));
                              TaskComplete.TrySetResult(Response);
                             except
                               on E: Exception do
                                TaskComplete.TrySetException(E);
                             end;
                           end, Request);
  exit TaskComplete.Task;
end;
{$ENDIF}


class method Http.Download(anUrl: Url): HttpResponse<Binary>;
begin
  try
  {$IF COOPER}
    var Content := new Binary;
    var Connection := java.net.URL(anUrl).openConnection;
    Connection.addRequestProperty("User-Agent", "Mozilla/4.76");
    var stream := Connection.InputStream;
    var data := new SByte[4096]; 
    var len := stream.read(data);

    while len > 0 do begin
      Content.Write(data, len);
      len := stream.read(data);
    end;

    if Content.Length = 0 then
      exit new HttpResponse<Binary> withException(new SugarException("Content is empty"));

    exit new HttpResponse<Binary>(Content); 
  {$ELSEIF WINDOWS_PHONE}
    var Response := InternalDownload(anUrl).Result;
    
    if Response.StatusCode <> System.Net.HttpStatusCode.OK then
      exit new HttpResponse<Binary> withException(new SugarException("Unable to download data, Response: " + Response.StatusDescription));

    var Stream := Response.GetResponseStream;
    
    if Stream = nil then
      exit new HttpResponse<Binary> withException(new SugarException("Content is empty"));

    var Content := new Binary;
    var Buffer := new Byte[16 * 1024];
    var Readed: Integer := Stream.Read(Buffer, 0, Buffer.Length);

    while Readed > 0 do begin
      Content.Write(Buffer, Readed);
      Readed := Stream.Read(Buffer, 0, Buffer.Length);
    end;

    if Content.Length = 0 then
      exit new HttpResponse<Binary> withException(new SugarException("Content is empty"));

    exit new HttpResponse<Binary>(Content);
  {$ELSEIF NETFX_CORE}
    var Client := new System.Net.Http.HttpClient;

    var Content := Client.GetByteArrayAsync(anUrl).Result;

    if Content = nil then
      exit new HttpResponse<Binary> withException(new SugarException("Content is empty"));

    if Content.Length = 0 then
      exit new HttpResponse<Binary> withException(new SugarException("Content is empty"));


    exit new HttpResponse<Binary>(new Binary(Content));
  {$ELSEIF ECHOES}
  using lClient: System.Net.WebClient := new System.Net.WebClient() do begin
    var Content := lClient.DownloadData(anUrl);
    
    if Content = nil then
      exit new HttpResponse<Binary> withException(new SugarException("Content is empty"));

    if Content.Length = 0 then
      exit new HttpResponse<Binary> withException(new SugarException("Content is empty"));

    exit new HttpResponse<Binary>(new Binary(Content));
  end;
  {$ELSEIF NOUGAT}
  var lError: NSError := nil;
  var lRequest := new NSURLRequest withURL(anUrl) cachePolicy(0) timeoutInterval(30);
  var lResponse: NSURLResponse;
  
  var lData := NSURLConnection.sendSynchronousRequest(lRequest) returningResponse(var lResponse) error(var lError);

  if lError <> nil then
    exit new HttpResponse<Binary> withException(Exception(new SugarNSErrorException(lError)));

  if NSHTTPURLResponse(lResponse).statusCode <> 200 then
    exit new HttpResponse<Binary> withException(Exception(new SugarIOException("Unable to complete request. Error code: {0}", NSHTTPURLResponse(lResponse).statusCode)));

  exit new HttpResponse<Binary>(Binary(NSMutableData.dataWithData(lData)));
  {$ENDIF}
  except
    on E: Exception do begin
      var Actual := E;

      {$IF WINDOWS_PHONE OR NETFX_CORE}
      if E is AggregateException then
        Actual := AggregateException(E).InnerException;
      {$ENDIF}

      exit new HttpResponse<Binary> withException(Actual);
    end;
  end;
end;

class method Http.DownloadStringAsync(anUrl: Url; Encoding: Encoding; ResponseCallback: HttpResponseBlock<String>);
begin
  SugarArgumentNullException.RaiseIfNil(anUrl, "Url");
  if ResponseCallback = nil then
    raise new SugarArgumentNullException("ResponseCallback");
  async begin
    var Data := Download(anUrl);
    if Data.IsFailed then
      ResponseCallback(new HttpResponse<String> withException(Data.Exception))
    else
      ResponseCallback(new HttpResponse<String>(new String(Data.Content.ToArray, Encoding)));
  end;
end;

class method Http.DownloadBinaryAsync(anUrl: Url; ResponseCallback: HttpResponseBlock<Binary>);
begin
  SugarArgumentNullException.RaiseIfNil(anUrl, "Url");
  if ResponseCallback = nil then
    raise new SugarArgumentNullException("ResponseCallback");
  async begin
    ResponseCallback(Download(anUrl));
  end;
end;

class method Http.DownloadXmlAsync(anUrl: Url; ResponseCallback: HttpResponseBlock<XmlDocument>);
begin
  SugarArgumentNullException.RaiseIfNil(anUrl, "Url");
  if ResponseCallback = nil then
    raise new SugarArgumentNullException("ResponseCallback");
  async begin
    var Data := Download(anUrl);
    if Data.IsFailed then
      ResponseCallback(new HttpResponse<XmlDocument> withException(Data.Exception))
    else
      ResponseCallback(new HttpResponse<XmlDocument>(XmlDocument.FromBinary(Data.Content)));
  end;
end;

end.

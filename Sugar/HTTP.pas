namespace Sugar;

interface

uses
  Sugar.Collections,
  Sugar.IO,
  Sugar.Json,
  Sugar.Xml;
  
{ Handy test URLs: http://httpbin.org, http://requestb.in }

type
  HttpRequest = public class
  public
    property Mode: HttpRequestMode := HttpRequestMode.Get; 
    property Headers: not nullable Dictionary<String,String> := new Dictionary<String,String>; readonly;
    property Content: HttpRequestContent;
    property Url: Url;
    property FollowRedirects: Boolean := true;
    
    constructor(aUrl: Url); // log
    constructor(aUrl: Url; aMode: HttpRequestMode); // log  := HttpRequestMode.Ge
    operator Implicit(aUrl: Url): HttpRequest;
  end;
  
  HttpRequestMode = public enum (Get, Post);
  
  IHttpRequestContent = assembly interface
    method GetContentAsBinary(): Binary;
  end;

  HttpRequestContent = public class
  public
    operator Implicit(aBinary: Binary): HttpRequestContent;
    operator Implicit(aString: String): HttpRequestContent;
  end;
  
  HttpBinaryRequestContent = public class(HttpRequestContent, IHttpRequestContent)
  unit
    property Binary: Binary; readonly;
    method GetContentAsBinary: Binary;
  public
    constructor(aBinary: Binary);
    constructor(aString: String; aEncoding: Encoding);
  end;

  HttpResponse = public class
  unit
    constructor withException(anException: Exception);

    {$IF COOPER}
    var Connection: java.net.HttpURLConnection;
    constructor(aConnection: java.net.HttpURLConnection);
    {$ELSEIF ECHOES}
    var Response: HttpWebResponse;
    constructor(aResponse: HttpWebResponse);
    {$ELSEIF NOUGAT}
    var Data: NSData;
    constructor(aData: NSData; aResponse: NSHTTPURLResponse);
    {$ENDIF}

  public
    property Headers: not nullable Dictionary<String,String>; readonly; //todo: list itself should be read-only
    property Code: Int32; readonly;
    property Success: Boolean read self.Exception = nil;
    property Exception: Exception public read assembly write; // should be "unit
    
    method GetContentAsString(aEncoding: Encoding := nil; contentCallback: HttpContentResponseBlock<String>);
    method GetContentAsBinary(contentCallback: HttpContentResponseBlock<Binary>);
    method GetContentAsXml(contentCallback: HttpContentResponseBlock<XmlDocument>);
    method GetContentAsJson(contentCallback: HttpContentResponseBlock<JsonDocument>);
    method SaveContentAsFile(aTargetFile: File; contentCallback: HttpContentResponseBlock<File>);
  end;
  
  HttpResponseContent<T> = public class
  public
    property Content: T public read assembly write; // should be "unit"
    property Success: Boolean read self.Exception = nil;
    property Exception: Exception public read assembly write; // should be "unit
  end;
  
  HttpResponseBlock = public block (Response: HttpResponse);
  HttpContentResponseBlock<T> = public block (ResponseContent: HttpResponseContent<T>);

  Http = public static class
  private
    const SUGAR_USER_AGENT = "RemObjects Sugar/8.0 http://www.elementscompiler.com/elements/sugar";
  public
    method ExecuteRequest(aUrl: Url; ResponseCallback: HttpResponseBlock);
    method ExecuteRequest(aRequest: HttpRequest; ResponseCallback: HttpResponseBlock);

    method ExecuteRequestAsString(aRequest: HttpRequest; contentCallback: HttpContentResponseBlock<String>);
    //method ExecuteRequestAsBinary(aRequest: HttpRequest; contentCallback: HttpContentResponseBlock<Binary>);
    //method ExecuteRequestAsXml(aRequest: HttpRequest; contentCallback: HttpContentResponseBlock<XmlDocument>);
    method ExecuteRequestAsJson(aRequest: HttpRequest; contentCallback: HttpContentResponseBlock<JsonDocument>);
    method ExecuteRequestAndSaveAsFile(aRequest: HttpRequest; aTargetFile: File; contentCallback: HttpContentResponseBlock<File>);
  end;

implementation

{$IF ECHOES}
uses System.Net;
{$ENDIF}

{ HttpRequest }

constructor HttpRequest(aUrl: Url);
begin
  Url := aUrl;
  Mode := HttpRequestMode.Get;
end;

constructor HttpRequest(aUrl: Url; aMode: HttpRequestMode);
begin
  Url := aUrl;
  Mode := aMode;
end;

operator HttpRequest.Implicit(aUrl: Url): HttpRequest;
begin
  result := new HttpRequest(aUrl, HttpRequestMode.Get);
end;

{ HttpRequestContent }

operator HttpRequestContent.Implicit(aBinary: Binary): HttpRequestContent;
begin
  result := new HttpBinaryRequestContent(aBinary);
end;

operator HttpRequestContent.Implicit(aString: String): HttpRequestContent;
begin
  result := new HttpBinaryRequestContent(aString, Encoding.UTF8);
end;

{ HttpBinaryRequestContent }

constructor HttpBinaryRequestContent(aBinary: Binary);
begin
  Binary := aBinary;
end;

constructor HttpBinaryRequestContent(aString: String; aEncoding: Encoding);
begin
  if aEncoding = nil then aEncoding := Encoding.Default;
  Binary := new Binary(aString.ToByteArray(aEncoding));
end;

method HttpBinaryRequestContent.GetContentAsBinary(): Binary;
begin
  result := Binary;
end;

{ HttpResponse }

constructor HttpResponse withException(anException: Exception);
begin
  self.Exception := anException;
  Headers := new Dictionary<String,String>();
end;

{$IF COOPER}
constructor HttpResponse(aConnection: java.net.HttpURLConnection);
begin
  Connection := aConnection;
  Code := Connection.getResponseCode;
  Headers := new Dictionary<String,String>();
  var i := 0;
  loop begin
    var lKey := Connection.getHeaderFieldKey(i);
    if not assigned(lKey) then break;
    var lValue := Connection.getHeaderField(i);
    Headers[lKey] := lValue;
    inc(i);
  end;
end;
{$ELSEIF ECHOES}
constructor HttpResponse(aResponse: HttpWebResponse);
begin
  Response := aResponse;
  Code := aResponse.StatusCode;
  Headers := new Dictionary<String,String>();
  for each k: String in aResponse.Headers.Keys do
    Headers[k.ToString] := aResponse.Headers[k];
end;
{$ELSEIF NOUGAT}
constructor HttpResponse(aData: NSData; aResponse: NSHTTPURLResponse);
begin
  Data := aData;
  Code := aResponse.statusCode;
  Headers := aResponse.allHeaderFields as Dictionary<String,String>; // why is this cast needed?
end;
{$ENDIF}

method HttpResponse.GetContentAsString(aEncoding: Encoding := nil; contentCallback: HttpContentResponseBlock<String>);
begin
  if aEncoding = nil then aEncoding := Encoding.Default;
  {$IF COOPER}
  GetContentAsBinary( (content) -> begin
    if content.Success then
      contentCallback(new HttpResponseContent<String>(Content := new String(content.Content.ToArray, aEncoding)))
    else
      contentCallback(new HttpResponseContent<String>(Exception := content.Exception))
  end);
  {$ELSEIF ECHOES}
  async begin
    var responseString := new System.IO.StreamReader(Response.GetResponseStream(), aEncoding).ReadToEnd();
    contentCallback(new HttpResponseContent<String>(Content := responseString))
  end;
  {$ELSEIF NOUGAT}
  var s := new Foundation.NSString withData(Data) encoding(aEncoding as NSStringEncoding); // todo: test this
  if assigned(s) then
    contentCallback(new HttpResponseContent<String>(Content := s))
  else
    contentCallback(new HttpResponseContent<String>(Exception := new SugarException("Invalid Encoding")));
  {$ENDIF}
end;

method HttpResponse.GetContentAsBinary(contentCallback: HttpContentResponseBlock<Binary>);
begin
  {$IF COOPER}
  async begin
    var allData := new Binary;
    var stream := Connection.InputStream;
    var data := new Byte[4096]; 
    var len := stream.read(data);
    while len > 0 do begin
      allData.Write(data, len);
      len := stream.read(data);
    end;
    contentCallback(new HttpResponseContent<Binary>(Content := allData));
  end;
  {$ELSEIF ECHOES}
  async begin
    var allData := new System.IO.MemoryStream();
    Response.GetResponseStream().CopyTo(allData);
    contentCallback(new HttpResponseContent<Binary>(Content := allData));
  end;
  {$ELSEIF NOUGAT}
  contentCallback(new HttpResponseContent<Binary>(Content := Data.mutableCopy));
  {$ENDIF}
end;

method HttpResponse.GetContentAsXml(contentCallback: HttpContentResponseBlock<XmlDocument>);
begin
  GetContentAsBinary((content) -> begin
    if content.Success then begin
      try
        var document := XmlDocument.FromBinary(content.Content);
        contentCallback(new HttpResponseContent<XmlDocument>(Content := document));
      except
        on E: Exception do
          contentCallback(new HttpResponseContent<XmlDocument>(Exception := E));
      end;
    end else begin
      contentCallback(new HttpResponseContent<XmlDocument>(Exception := content.Exception));
    end;
  end);
end;

method HttpResponse.GetContentAsJson(contentCallback: HttpContentResponseBlock<JsonDocument>);
begin
  GetContentAsBinary((content) -> begin
    if content.Success then begin
      try
        var document := JsonDocument.FromBinary(content.Content);
        contentCallback(new HttpResponseContent<JsonDocument>(Content := document));
      except
        on E: Exception do
          contentCallback(new HttpResponseContent<JsonDocument>(Exception := E));
      end;
    end else begin
      writeln("D");
      contentCallback(new HttpResponseContent<JsonDocument>(Exception := content.Exception));
    end;
  end);
end;

method HttpResponse.SaveContentAsFile(aTargetFile: File; contentCallback: HttpContentResponseBlock<File>);
begin
  {$IF COOPER}
  async begin
    var allData := new java.io.FileOutputStream(aTargetFile);
    var stream := Connection.InputStream;
    var data := new Byte[4096]; 
    var len := stream.read(data);
    while len > 0 do begin
      allData.write(data, 0, len);
      len := stream.read(data);
    end;
    contentCallback(new HttpResponseContent<File>(Content := aTargetFile));
  end;
  {$ELSEIF ECHOES}
  async begin
    try
      using responseStream := Response.GetResponseStream() do
        using fileStream := System.IO.File.OpenWrite(aTargetFile) do
          responseStream.CopyTo(fileStream);
      contentCallback(new HttpResponseContent<File>(Content := aTargetFile));
    except
      on E: Exception do
        contentCallback(new HttpResponseContent<File>(Exception := E));
    end;
  end;
  {$ELSEIF NOUGAT}
  async begin
    var error: NSError;
    if Data.writeToFile(aTargetFile) options(NSDataWritingOptions.NSDataWritingAtomic) error(var error) then
      contentCallback(new HttpResponseContent<File>(Content := aTargetFile))
    else
      contentCallback(new HttpResponseContent<File>(Exception := new SugarException withError(error)));
  end;
  {$ENDIF}
end;

{ Http }

method Http.ExecuteRequest(aRequest: HttpRequest; ResponseCallback: HttpResponseBlock);
begin
  
  {$IF COOPER}
  async begin
    var lConnection := java.net.URL(aRequest.URL).openConnection as java.net.HttpURLConnection;
    lConnection.addRequestProperty("User-Agent", SUGAR_USER_AGENT);
    var lResponse := new HttpResponse(lConnection);
    responseCallback(lResponse);
  end;
  {$ELSEIF ECHOES}
  using webRequest := System.Net.WebRequest.Create(aRequest.Url) as HttpWebRequest do begin
    
    webRequest.AllowAutoRedirect := aRequest.FollowRedirects;
    webRequest.UserAgent := SUGAR_USER_AGENT;
    
    case aRequest.Mode of
      HttpRequestMode.Get: webRequest.Method := "GET";
      HttpRequestMode.Post: webRequest.Method := "POST";
    end;
    
    if assigned(aRequest.Content) then begin
      using stream := webRequest.GetRequestStream() do begin
        var data := (aRequest.Content as IHttpRequestContent).GetContentAsBinary().ToArray();
        stream.Write(data, 0, data.Length);
        stream.Flush();
        //webRequest.ContentLength := data.Length;
      end;
    end;
    
    webRequest.BeginGetResponse( (ar) -> begin

      try
        var webResponse := webRequest.EndGetResponse(ar) as HttpWebResponse;
        var response := new HttpResponse(webResponse);
        responseCallback(response);
      except
        on E: Exception do
          responseCallback(new HttpResponse(E));
      end;
    
    end, nil);
  end;
  {$ELSEIF NOUGAT}
  var nsUrlRequest := new NSURLRequest withURL(aRequest.Url) cachePolicy(0) timeoutInterval(30);
  //nsUrlRequest.AllowAutoRedirect := aRequest.FollowRedirects;
  NSURLConnection.sendAsynchronousRequest(nsUrlRequest) queue(nil) completionHandler( (nsUrlResponse, data, error) -> begin

    var nsHttpUrlResponse := NSHTTPURLResponse(nsUrlResponse);
    if assigned(data) and assigned(nsHttpUrlResponse) and not assigned(error) then begin
      
      var response := new HttpResponse(data, nsHttpUrlResponse);
      responseCallback(response);

    end else if assigned(error) then begin
      
      var response := new HttpResponse(new SugarException withError(error));
      responseCallback(response);
      
    end else begin
      var response := new HttpResponse(new SugarException("Request failed without providing an error."));
      responseCallback(response);
    end;
    
  end);
  {$ENDIF}
end;

method Http.ExecuteRequest(aUrl: Url; ResponseCallback: HttpResponseBlock);
begin
  ExecuteRequest(new HttpRequest(aUrl, HttpRequestMode.Get), responseCallback);
end;

method Http.ExecuteRequestAsString(aRequest: HttpRequest; contentCallback: HttpContentResponseBlock<String>);
begin
  Http.ExecuteRequest(aRequest, (response) -> begin
    if response.Success then begin
      response.GetContentAsString( (content) -> begin
        contentCallback(content)
      end);
    end else begin
      contentCallback(new HttpResponseContent<String>(Exception := response.Exception));
    end;
  end);
end;

method Http.ExecuteRequestAsJson(aRequest: HttpRequest; contentCallback: HttpContentResponseBlock<JsonDocument>);
begin
  Http.ExecuteRequest(aRequest, (response) -> begin
    if response.Success then begin
      response.GetContentAsJson( (content) -> begin
        contentCallback(content)
      end);
    end else begin
      contentCallback(new HttpResponseContent<JsonDocument>(Exception := response.Exception));
    end;
  end);
end;

method Http.ExecuteRequestAndSaveAsFile(aRequest: HttpRequest; aTargetFile: File; contentCallback: HttpContentResponseBlock<File>);
begin
  Http.ExecuteRequest(aRequest, (response) -> begin
    if response.Success then begin
      response.SaveContentAsFile(aTargetFile, (content) -> begin
        contentCallback(content)
      end);
    end else begin
      contentCallback(new HttpResponseContent<File>(Exception := response.Exception));
    end;
  end);
end;

(*

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
*)

end.

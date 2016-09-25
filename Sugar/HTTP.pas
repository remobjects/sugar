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
    property Content: nullable HttpRequestContent;
    property Url: not nullable Url;
    property FollowRedirects: Boolean := true;
    property AllowCellularAccess: Boolean := true;
    
    constructor(aUrl: not nullable Url); // log
    constructor(aUrl: not nullable Url; aMode: HttpRequestMode); // log  := HttpRequestMode.Ge
    operator Implicit(aUrl: not nullable Url): HttpRequest;
    
    [ToString]
    method ToString: String;
  end;
  
  HttpRequestMode = public enum (Get, Post, Head, Put, Delete, Patch, Options, Trace);
  
  IHttpRequestContent = assembly interface
    method GetContentAsBinary(): Binary;
    method GetContentAsArray(): array of Byte;
  end;

  HttpRequestContent = public class
  public
    operator Implicit(aBinary: not nullable Binary): HttpRequestContent;
    operator Implicit(aString: not nullable String): HttpRequestContent;
  end;
  
  HttpBinaryRequestContent = public class(HttpRequestContent, IHttpRequestContent)
  unit
    property Binary: Binary unit read private write;
    property &Array: array of Byte unit read private write;
    method GetContentAsBinary: Binary;
    method GetContentAsArray(): array of Byte;
  public
    constructor(aBinary: not nullable Binary);
    constructor(aArray: not nullable array of Byte);
    constructor(aString: not nullable String; aEncoding: Encoding);
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
    {$ELSEIF TOFFEE}
    var Data: NSData;
    constructor(aData: NSData; aResponse: NSHTTPURLResponse);
    {$ENDIF}

  public
    property Headers: not nullable Dictionary<String,String>; readonly; //todo: list itself should be read-only
    property Code: Int32; readonly;
    property Success: Boolean read self.Exception = nil;
    property Exception: Exception public read unit write;
    
    method GetContentAsString(aEncoding: Encoding := nil; contentCallback: not nullable HttpContentResponseBlock<String>);
    method GetContentAsBinary(contentCallback: not nullable HttpContentResponseBlock<Binary>);
    method GetContentAsXml(contentCallback: not nullable HttpContentResponseBlock<XmlDocument>);
    method GetContentAsJson(contentCallback: not nullable HttpContentResponseBlock<JsonDocument>);
    method SaveContentAsFile(aTargetFile: File; contentCallback: not nullable HttpContentResponseBlock<File>);

    {$IF NOT ECHOES OR (NOT WINDOWS_PHONE AND NOT NETFX_CORE)}
    method GetContentAsStringSynchronous(aEncoding: Encoding := nil): not nullable String;
    method GetContentAsBinarySynchronous: not nullable Binary;
    method GetContentAsXmlSynchronous: not nullable XmlDocument;
    method GetContentAsJsonSynchronous: not nullable JsonDocument;
    {$ENDIF}
  end;
  
  HttpResponseContent<T> = public class
  public
    property Content: T public read unit write;
    property Success: Boolean read self.Exception = nil;
    property Exception: Exception public read unit write;
  end;
 
  HttpResponseBlock = public block (Response: HttpResponse);
  HttpContentResponseBlock<T> = public block (ResponseContent: HttpResponseContent<T>);

  Http = public static class
  private
    {$IF TOFFEE}
    property Session := NSURLSession.sessionWithConfiguration(NSURLSessionConfiguration.defaultSessionConfiguration); lazy;
    {$ENDIF}

  public
    //method ExecuteRequest(aUrl: not nullable Url; ResponseCallback: not nullable HttpResponseBlock);
    method ExecuteRequest(aRequest: not nullable HttpRequest; ResponseCallback: not nullable HttpResponseBlock);
    {$IF NOT ECHOES OR (NOT WINDOWS_PHONE AND NOT NETFX_CORE)}
    method ExecuteRequestSynchronous(aRequest: not nullable HttpRequest): not nullable HttpResponse;
    {$ENDIF}

    method ExecuteRequestAsString(aEncoding: Encoding := nil; aRequest: not nullable HttpRequest; contentCallback: not nullable HttpContentResponseBlock<String>);
    method ExecuteRequestAsBinary(aRequest: not nullable HttpRequest; contentCallback: not nullable HttpContentResponseBlock<Binary>);
    method ExecuteRequestAsXml(aRequest: not nullable HttpRequest; contentCallback: not nullable HttpContentResponseBlock<XmlDocument>);
    method ExecuteRequestAsJson(aRequest: not nullable HttpRequest; contentCallback: not nullable HttpContentResponseBlock<JsonDocument>);
    method ExecuteRequestAndSaveAsFile(aRequest: not nullable HttpRequest; aTargetFile: not nullable File; contentCallback: not nullable HttpContentResponseBlock<File>);

    {$IF NOT ECHOES OR (NOT WINDOWS_PHONE AND NOT NETFX_CORE)}
    method GetString(aEncoding: Encoding := nil; aRequest: not nullable HttpRequest): not nullable String;
    method GetBinary(aRequest: not nullable HttpRequest): not nullable Binary;
    method GetXml(aRequest: not nullable HttpRequest): not nullable XmlDocument;
    method GetJson(aRequest: not nullable HttpRequest): not nullable JsonDocument;
    //todo: method GetAndSaveAsFile(...);
    {$ENDIF}
  end;

implementation

{$IF ECHOES}
uses System.Net;
{$ENDIF}

{ HttpRequest }

constructor HttpRequest(aUrl: not nullable Url);
begin
  Url := aUrl;
  Mode := HttpRequestMode.Get;
end;

constructor HttpRequest(aUrl: not nullable Url; aMode: HttpRequestMode);
begin
  Url := aUrl;
  Mode := aMode;
end;

operator HttpRequest.Implicit(aUrl: not nullable Url): HttpRequest;
begin
  result := new HttpRequest(aUrl, HttpRequestMode.Get);
end;

method HttpRequest.ToString: String;
begin
  result := Url.ToString();
end;

{ HttpRequestContent }

operator HttpRequestContent.Implicit(aBinary: not nullable Binary): HttpRequestContent;
begin
  result := new HttpBinaryRequestContent(aBinary);
end;

operator HttpRequestContent.Implicit(aString: not nullable String): HttpRequestContent;
begin
  result := new HttpBinaryRequestContent(aString, Encoding.UTF8);
end;

{ HttpBinaryRequestContent }

constructor HttpBinaryRequestContent(aBinary: not nullable Binary);
begin
  Binary := aBinary;
end;

constructor HttpBinaryRequestContent(aArray: not nullable array of Byte);
begin
  &Array := aArray;
end;

constructor HttpBinaryRequestContent(aString: not nullable String; aEncoding: Encoding);
begin
  if aEncoding = nil then aEncoding := Encoding.Default;
  &Array := aString.ToByteArray(aEncoding);
end;

method HttpBinaryRequestContent.GetContentAsBinary(): Binary;
begin
  if assigned(Binary) then begin
    result := Binary;
  end
  else if assigned(&Array) then begin
    Binary := new Binary(&Array);
    result := Binary;
  end;
end;

method HttpBinaryRequestContent.GetContentAsArray: array of Byte;
begin
  if assigned(&Array) then 
    result := &Array
  else if assigned(Binary) then
    result := Binary.ToArray();
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
  Code := Int32(aResponse.StatusCode);
  Headers := new Dictionary<String,String>();
  {$IF WINDOWS_PHONE OR NETFX_CORE}
  for each k: String in aResponse.Headers.AllKeys do
    Headers[k.ToString] := aResponse.Headers[k];
  {$ELSE}
  for each k: String in aResponse.Headers.Keys do
    Headers[k.ToString] := aResponse.Headers[k];
  {$ENDIF}
end;
{$ELSEIF TOFFEE}
constructor HttpResponse(aData: NSData; aResponse: NSHTTPURLResponse);
begin
  Data := aData;
  Code := aResponse.statusCode;
  Headers := aResponse.allHeaderFields as not nullable Dictionary<String,String>; // why is this cast needed?
end;
{$ENDIF}

method HttpResponse.GetContentAsString(aEncoding: Encoding := nil; contentCallback: not nullable HttpContentResponseBlock<String>);
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
  {$ELSEIF TOFFEE}
  var s := new Foundation.NSString withData(Data) encoding(aEncoding.AsNSStringEncoding); // todo: test this
  if assigned(s) then
    contentCallback(new HttpResponseContent<String>(Content := s))
  else
    contentCallback(new HttpResponseContent<String>(Exception := new SugarException("Invalid Encoding")));
  {$ENDIF}
end;

method HttpResponse.GetContentAsBinary(contentCallback: not nullable HttpContentResponseBlock<Binary>);
begin
  // maybe delegsate to GetContentAsBinarySynchronous?
  {$IF COOPER}
  async begin
    var allData := new Binary;
    var stream := if connection.getResponseCode > 400 then Connection.ErrorStream else Connection.InputStream;
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
  {$ELSEIF TOFFEE}
  contentCallback(new HttpResponseContent<Binary>(Content := Data.mutableCopy));
  {$ENDIF}
end;

method HttpResponse.GetContentAsXml(contentCallback: not nullable HttpContentResponseBlock<XmlDocument>);
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

method HttpResponse.GetContentAsJson(contentCallback: not nullable HttpContentResponseBlock<JsonDocument>);
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
      contentCallback(new HttpResponseContent<JsonDocument>(Exception := content.Exception));
    end;
  end);
end;

method HttpResponse.SaveContentAsFile(aTargetFile: File; contentCallback: not nullable HttpContentResponseBlock<File>);
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
  {$IF WINDOWS_PHONE OR NETFX_CORE}
  try
    using responseStream := Response.GetResponseStream() do begin
      var storageFile := Windows.Storage.ApplicationData.Current.LocalFolder.CreateFileAsync(aTargetFile.Name, Windows.Storage.CreationCollisionOption.ReplaceExisting).Await();

      using fileStream := await System.IO.WindowsRuntimeStorageExtensions.OpenStreamForWriteAsync(storageFile) do begin
        await responseStream.CopyToAsync(fileStream);
      end;
    end;
    contentCallback(new HttpResponseContent<File>(Content := aTargetFile));
  except
    on E: Exception do
      contentCallback(new HttpResponseContent<File>(Exception := E));
  end;
  {$ELSE}
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
  {$ENDIF}
  {$ELSEIF TOFFEE}
  async begin
    var error: NSError;
    if Data.writeToFile(aTargetFile) options(NSDataWritingOptions.NSDataWritingAtomic) error(var error) then
      contentCallback(new HttpResponseContent<File>(Content := aTargetFile))
    else
      contentCallback(new HttpResponseContent<File>(Exception := new SugarException withError(error)));
  end;
  {$ENDIF}
end;

{$IF NOT ECHOES OR (NOT WINDOWS_PHONE AND NOT NETFX_CORE)}
method HttpResponse.GetContentAsStringSynchronous(aEncoding: Encoding := nil): not nullable String;
begin
  if aEncoding = nil then aEncoding := Encoding.Default;
  {$IF COOPER}
  result := new String(GetContentAsBinarySynchronous().ToArray, aEncoding);
  {$ELSEIF ECHOES}
  result := new System.IO.StreamReader(Response.GetResponseStream(), aEncoding).ReadToEnd() as not nullable;
  {$ELSEIF TOFFEE}
  var s := new Foundation.NSString withData(Data) encoding(aEncoding.AsNSStringEncoding); // todo: test this
  if assigned(s) then
    exit s as not nullable
  else
    raise new SugarException("Invalid Encoding");
  {$ENDIF}
end;

method HttpResponse.GetContentAsBinarySynchronous: not nullable Binary;
begin
  {$IF COOPER}
  var allData := new Binary;
  var stream := Connection.InputStream;
  var data := new Byte[4096]; 
  var len := stream.read(data);
  while len > 0 do begin
    allData.Write(data, len);
    len := stream.read(data);
  end;
  result := allData as not nullable;
  {$ELSEIF ECHOES}
  var allData := new System.IO.MemoryStream();
  Response.GetResponseStream().CopyTo(allData);
  result := allData as not nullable;
  {$ELSEIF TOFFEE}
  result := Data.mutableCopy as not nullable;
  {$ENDIF}
end;

method HttpResponse.GetContentAsXmlSynchronous: not nullable XmlDocument;
begin
  result := XmlDocument.FromBinary(GetContentAsBinarySynchronous());
end;

method HttpResponse.GetContentAsJsonSynchronous: not nullable JsonDocument;
begin
  result := JsonDocument.FromBinary(GetContentAsBinarySynchronous());
end;
{$ENDIF}

{ Http }

method Http.ExecuteRequest(aRequest: not nullable HttpRequest; ResponseCallback: not nullable HttpResponseBlock);
begin
  {$IF COOPER}
  async try
    var lConnection := java.net.URL(aRequest.Url).openConnection as java.net.HttpURLConnection;

    for each k in aRequest.Headers.Keys do
      lConnection.setRequestProperty(k, aRequest.Headers[k]);
    
    if assigned(aRequest.Content) then begin
      lConnection.getOutputStream().write((aRequest.Content as IHttpRequestContent).GetContentAsArray());
      lConnection.getOutputStream().flush();
    end;

    try
      var lResponse := if lConnection.ResponseCode >= 300 then new HttpResponse withException(new SugarIOException("Unable to complete request. Error code: {0}", lConnection.responseCode)) else new HttpResponse(lConnection);
      responseCallback(lResponse);
    except
      on E: Exception do
        responseCallback(new HttpResponse withException(E));
    end;

  except
    on E: Exception do
      ResponseCallback(new HttpResponse withException(E));
  end;
  {$ELSEIF ECHOES}
  using webRequest := System.Net.WebRequest.Create(aRequest.Url) as HttpWebRequest do try
    {$IF NOT NETFX_CORE}
    webRequest.AllowAutoRedirect := aRequest.FollowRedirects;
    {$ENDIF}
    case aRequest.Mode of
      HttpRequestMode.Get: webRequest.Method := 'GET';
      HttpRequestMode.Post: webRequest.Method := 'POST';
      HttpRequestMode.Head: webRequest.Method := 'HEAD';
      HttpRequestMode.Put: webRequest.Method := 'PUT';
      HttpRequestMode.Delete: webRequest.Method := 'DELETE';
      HttpRequestMode.Patch: webRequest.Method := 'PATCH';
      HttpRequestMode.Options: webRequest.Method := 'OPTIONS';
      HttpRequestMode.Trace: webRequest.Method := 'TRACE';
    end;

    for each k in aRequest.Headers.Keys do
      webRequest.Headers[k] := aRequest.Headers[k];

    if assigned(aRequest.Content) then begin
    {$IF WINDOWS_PHONE}
      // I don't want to mess with BeginGetRequestStream/EndGetRequestStream methods here
      // HttpWebRequest.GetRequestStreamAsync() is not available in WP 8.0
      var getRequestStreamTask := System.Threading.Tasks.Task<System.IO.Stream>.Factory.FromAsync(@webRequest.BeginGetRequestStream, @webRequest.EndGetRequestStream, nil);
      using stream := await getRequestStreamTask do begin
    {$ELSEIF NETFX_CORE}
      using stream := await webRequest.GetRequestStreamAsync() do begin
    {$ELSE}
      using stream := webRequest.GetRequestStream() do begin
    {$ENDIF}
        var data := (aRequest.Content as IHttpRequestContent).GetContentAsArray();
        stream.Write(data, 0, data.Length);
        stream.Flush();
        //webRequest.ContentLength := data.Length;
      end;
    end;

    webRequest.BeginGetResponse( (ar) -> begin

      try
        var webResponse := webRequest.EndGetResponse(ar) as HttpWebResponse;
        var response := if webResponse.StatusCode >= 300 then new HttpResponse withException(new SugarIOException("Unable to complete request. Error code: {0}", webResponse.StatusCode)) else new HttpResponse(webResponse);
        ResponseCallback(response);
      except
        on E: Exception do
          ResponseCallback(new HttpResponse withException(E));
      end;
    
    end, nil);
  except
    on E: Exception do
      ResponseCallback(new HttpResponse withException(E));
  end;
  {$ELSEIF TOFFEE}
  try
    var nsUrlRequest := new NSMutableURLRequest withURL(aRequest.Url) cachePolicy(NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData) timeoutInterval(30);
  
    //nsUrlRequest.AllowAutoRedirect := aRequest.FollowRedirects;
    nsUrlRequest.allowsCellularAccess := aRequest.AllowCellularAccess;
    
    case aRequest.Mode of
      HttpRequestMode.Get: nsUrlRequest.HTTPMethod := 'GET';
      HttpRequestMode.Post: nsUrlRequest.HTTPMethod := 'POST';
      HttpRequestMode.Head: nsUrlRequest.HTTPMethod := 'HEAD';
      HttpRequestMode.Put: nsUrlRequest.HTTPMethod := 'PUT';
      HttpRequestMode.Delete: nsUrlRequest.HTTPMethod := 'DELETE';
      HttpRequestMode.Patch: nsUrlRequest.HTTPMethod := 'PATCH';
      HttpRequestMode.Options: nsUrlRequest.HTTPMethod := 'OPTIONS';
      HttpRequestMode.Trace: nsUrlRequest.HTTPMethod := 'TRACE';
    end;
  
    if assigned(aRequest.Content) then
      nsUrlRequest.HTTPBody := (aRequest.Content as IHttpRequestContent).GetContentAsBinary();
    
    for each k in aRequest.Headers.Keys do
      nsUrlRequest.setValue(aRequest.Headers[k]) forHTTPHeaderField(k);

    var lRequest := Session.dataTaskWithRequest(nsUrlRequest) completionHandler((data, nsUrlResponse, error) -> begin
  
      var nsHttpUrlResponse := NSHTTPURLResponse(nsUrlResponse);
      if assigned(data) and assigned(nsHttpUrlResponse) and not assigned(error) then begin
        var response := if nsHttpUrlResponse.statusCode >= 300 then new HttpResponse withException(new SugarIOException("Unable to complete request. Error code: {0}", nsHttpUrlResponse.statusCode)) else new HttpResponse(data, nsHttpUrlResponse);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), () -> responseCallback(response));
      end else if assigned(error) then begin
        var response := new HttpResponse(new SugarException withError(error));
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), () -> responseCallback(response));
      end else begin
        var response := new HttpResponse(new SugarException("Request failed without providing an error."));
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), () -> responseCallback(response));
      end;
        
    end);
    lRequest.resume();
  except
    on E: Exception do
      ResponseCallback(new HttpResponse withException(E));
  end;
  {$ENDIF}
end;

{$IF NOT ECHOES OR (NOT WINDOWS_PHONE AND NOT NETFX_CORE)}
method Http.ExecuteRequestSynchronous(aRequest: not nullable HttpRequest): not nullable HttpResponse;
begin
  {$IF COOPER}
  var lConnection := java.net.URL(aRequest.Url).openConnection as java.net.HttpURLConnection;
  
  for each k in aRequest.Headers.Keys do
    lConnection.setRequestProperty(k, aRequest.Headers[k]);
    
  if assigned(aRequest.Content) then begin
    lConnection.getOutputStream().write((aRequest.Content as IHttpRequestContent).GetContentAsArray());
    lConnection.getOutputStream().flush();
  end;
  
  if lConnection.ResponseCode >= 300 then
    raise new SugarIOException("Unable to complete request. Error code: {0}", lConnection.responseCode);
  result := new HttpResponse(lConnection);
  {$ELSEIF ECHOES}
  using webRequest := System.Net.WebRequest.Create(aRequest.Url) as HttpWebRequest do begin
    {$IF NOT NETFX_CORE}
    webRequest.AllowAutoRedirect := aRequest.FollowRedirects;
    {$ENDIF}
    case aRequest.Mode of
      HttpRequestMode.Get: webRequest.Method := 'GET';
      HttpRequestMode.Post: webRequest.Method := 'POST';
      HttpRequestMode.Head: webRequest.Method := 'HEAD';
      HttpRequestMode.Put: webRequest.Method := 'PUT';
      HttpRequestMode.Delete: webRequest.Method := 'DELETE';
      HttpRequestMode.Patch: webRequest.Method := 'PATCH';
      HttpRequestMode.Options: webRequest.Method := 'OPTIONS';
      HttpRequestMode.Trace: webRequest.Method := 'TRACE';
    end;
    
    for each k in aRequest.Headers.Keys do
      webRequest.Headers[k] := aRequest.Headers[k];

    if assigned(aRequest.Content) then begin
      using stream := webRequest.GetRequestStream() do begin
        var data := (aRequest.Content as IHttpRequestContent).GetContentAsArray();
        stream.Write(data, 0, data.Length);
        stream.Flush();
      end;
    end;

    var webResponse := webRequest.GetResponse() as HttpWebResponse;

    if webResponse.StatusCode >= 300 then
      raise new SugarIOException("Unable to complete request. Error code: {0}", webResponse.StatusCode);
    result := new HttpResponse(webResponse);
  end;
  {$ELSEIF TOFFEE}
  var nsUrlRequest := new NSMutableURLRequest withURL(aRequest.Url) cachePolicy(NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData) timeoutInterval(30);

  //nsUrlRequest.AllowAutoRedirect := aRequest.FollowRedirects;
  nsUrlRequest.allowsCellularAccess := aRequest.AllowCellularAccess;
  
  case aRequest.Mode of
    HttpRequestMode.Get: nsUrlRequest.HTTPMethod := 'GET';
    HttpRequestMode.Post: nsUrlRequest.HTTPMethod := 'POST';
    HttpRequestMode.Head: nsUrlRequest.HTTPMethod := 'HEAD';
    HttpRequestMode.Put: nsUrlRequest.HTTPMethod := 'PUT';
    HttpRequestMode.Delete: nsUrlRequest.HTTPMethod := 'DELETE';
    HttpRequestMode.Patch: nsUrlRequest.HTTPMethod := 'PATCH';
    HttpRequestMode.Options: nsUrlRequest.HTTPMethod := 'OPTIONS';
    HttpRequestMode.Trace: nsUrlRequest.HTTPMethod := 'TRACE';
  end;

  if assigned(aRequest.Content) then
    nsUrlRequest.HTTPBody := (aRequest.Content as IHttpRequestContent).GetContentAsBinary();

  for each k in aRequest.Headers.Keys do
    nsUrlRequest.setValue(aRequest.Headers[k]) forHTTPHeaderField(k);

  var nsUrlResponse : NSURLResponse;
  var error: NSError;
  {$HIDE W28}
  // we're aware it's deprecated. but async calls do have their use in console apps.
  var data := NSURLConnection.sendSynchronousRequest(nsUrlRequest) returningResponse(var nsUrlResponse) error(var error);
  {$SHOW W28}
(*
  var data : NSData;
  
  var outerExecutionBlock: NSBlockOperation := NSBlockOperation.blockOperationWithBlock(method begin
      
    var semaphore := dispatch_semaphore_create(0);
    var session := NSURLSession.sharedSession; 
      
    var task := session. dataTaskWithRequest(nsUrlRequest) completionHandler(method (internalData:NSData; internalResponse:NSURLResponse; internalError:NSError)begin
    
      nsUrlResponse := internalResponse;
      error := internalError;
      data := internalData;
        
      dispatch_semaphore_signal(semaphore);
    end);
        
    task.resume;

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);      

  end);
    
  var workerQueue := new NSOperationQueue();
  workerQueue.addOperations([outerExecutionBlock]) waitUntilFinished(true);
  
*)
  var nsHttpUrlResponse := NSHTTPURLResponse(nsUrlResponse);
  if assigned(data) and assigned(nsHttpUrlResponse) and not assigned(error) then begin
    if nsHttpUrlResponse.statusCode >= 300 then
      raise new SugarIOException("Unable to complete request. Error code: {0}", nsHttpUrlResponse.statusCode);
    result := new HttpResponse(data, nsHttpUrlResponse);
  end
  else if assigned(error) then
    raise new SugarException withError(error)
  else
    raise new SugarException("Request failed without providing an error.");
  {$ENDIF}
end;
{$ENDIF}

{method Http.ExecuteRequest(aUrl: not nullable Url; ResponseCallback: not nullable HttpResponseBlock);
begin
  ExecuteRequest(new HttpRequest(aUrl, HttpRequestMode.Get), responseCallback);
end;}

method Http.ExecuteRequestAsString(aEncoding: Encoding := nil; aRequest: not nullable HttpRequest; contentCallback: not nullable HttpContentResponseBlock<String>);
begin
  Http.ExecuteRequest(aRequest, (response) -> begin
    if response.Success then begin
      response.GetContentAsString(aEncoding, (content) -> begin
        contentCallback(content)
      end);
    end else begin
      contentCallback(new HttpResponseContent<String>(Exception := response.Exception));
    end;
  end);
end;

method Http.ExecuteRequestAsBinary(aRequest: not nullable HttpRequest; contentCallback: not nullable HttpContentResponseBlock<Binary>);
begin
  Http.ExecuteRequest(aRequest, (response) -> begin
    if response.Success then begin
      response.GetContentAsBinary( (content) -> begin
        contentCallback(content)
      end);
    end else begin
      contentCallback(new HttpResponseContent<Binary>(Exception := response.Exception));
    end;
  end);
end;

method Http.ExecuteRequestAsXml(aRequest: not nullable HttpRequest; contentCallback: not nullable HttpContentResponseBlock<XmlDocument>);
begin
  Http.ExecuteRequest(aRequest, (response) -> begin
    if response.Success then begin
      response.GetContentAsXml( (content) -> begin
        contentCallback(content)
      end);
    end else begin
      contentCallback(new HttpResponseContent<XmlDocument>(Exception := response.Exception));
    end;
  end);
end;

method Http.ExecuteRequestAsJson(aRequest: not nullable HttpRequest; contentCallback: not nullable HttpContentResponseBlock<JsonDocument>);
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

method Http.ExecuteRequestAndSaveAsFile(aRequest: not nullable HttpRequest; aTargetFile: not nullable File; contentCallback: not nullable HttpContentResponseBlock<File>);
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

{$IF NOT ECHOES OR (NOT WINDOWS_PHONE AND NOT NETFX_CORE)}
method Http.GetString(aEncoding: Encoding := nil; aRequest: not nullable HttpRequest): not nullable String;
begin
  result := ExecuteRequestSynchronous(aRequest).GetContentAsStringSynchronous(aEncoding);
end;

method Http.GetBinary(aRequest: not nullable HttpRequest): not nullable Binary;
begin
  result := ExecuteRequestSynchronous(aRequest).GetContentAsBinarySynchronous;
end;

method Http.GetXml(aRequest: not nullable HttpRequest): not nullable XmlDocument;
begin
  result := ExecuteRequestSynchronous(aRequest).GetContentAsXmlSynchronous;
end;

method Http.GetJson(aRequest: not nullable HttpRequest): not nullable JsonDocument;
begin
  result := ExecuteRequestSynchronous(aRequest).GetContentAsJsonSynchronous;
end;
{$ENDIF}

(*

{$IF WINDOWS_PHONE}
class method Http.InternalDownload(anUrl: Url): System.Threading.Tasks.Task<System.Net.HttpWebResponse>;
begin
  var Request: System.Net.HttpWebRequest := System.Net.WebRequest.CreateHttp(anUrl);
  Request.Method := "GET";
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
  {$ELSEIF TOFFEE}
  var lError: NSError := nil;
  var lRequest := new NSURLRequest withURL(anUrl) cachePolicy(NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData) timeoutInterval(30);
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

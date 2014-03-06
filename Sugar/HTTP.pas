namespace Sugar;

interface

uses
  Sugar.IO,
  Sugar.Xml;

type

  HttpResponse<T> = public class
  unit
    constructor (aContent: T);
    constructor withException(anException: Exception);

  public
    property Exception: Exception read write; readonly;
    property Content: T read write; readonly;
    property IsFailed: Boolean read self.Exception <> nil;
  end;

  HttpResponseBlock<T> = public block (Response: HttpResponse<T>);

  Http = public static class
  private
    {$IF WINDOWS_PHONE}
    method InternalDownload(anUrl: Url): System.Threading.Tasks.Task<System.Net.HttpWebResponse>;
    {$ENDIF}
    method Download(anUrl: Url): HttpResponse<Binary>;
  public
    method DownloadStringAsync(anUrl: Url; ResponseCallback: HttpResponseBlock<String>);
    method DownloadBinaryAsync(anUrl: Url; ResponseCallback: HttpResponseBlock<Binary>);
    method DownloadXmlAsync(anUrl: Url; ResponseCallback: HttpResponseBlock<XmlDocument>);
  end;

implementation


{ HttpResponse }

constructor HttpResponse<T>(aContent: T);
begin
  self.Content := aContent;
end;

constructor HttpResponse<T> withException(anException: Exception);
begin
  self.Exception := anException;
end;

{ Http }

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
  
  var lData := new NSMutableData withContentsOfURL(anUrl) options(NSDataReadingOptions.NSDataReadingUncached) error(var lError);

  if not assigned(lData) then
    exit new HttpResponse<Binary>(Exception(new SugarNSErrorException(lError)));

  exit new HttpResponse<Binary>(lData);
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

class method Http.DownloadStringAsync(anUrl: Url; ResponseCallback: HttpResponseBlock<String>);
begin
  SugarArgumentNullException.RaiseIfNil(anUrl, "Url");
  if ResponseCallback = nil then
    raise new SugarArgumentNullException("ResponseCallback");
  async begin
    var Data := Download(anUrl);
    if Data.IsFailed then
      ResponseCallback(new HttpResponse<String> withException(Data.Exception))
    else
      ResponseCallback(new HttpResponse<String>(new String(Data.Content.ToArray)));
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

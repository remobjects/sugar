namespace RemObjects.Oxygene.Sugar;

interface

uses
  RemObjects.Oxygene.Sugar.IO,
  RemObjects.Oxygene.Sugar.Xml;

type
  {$IF NOUGAT}
  HttpResponce = public class
  public
    method initWithContent(aContent: id): id;
    method initWithException(anException: Exception): id;

    property Exception: Exception read private write;
    property Content: id read private write;
    property IsFailed: Boolean read self.Exception <> nil;
  end;
  {$ENDIF}

  HttpResponce<T> = public class {$IF NOUGAT}mapped to HttpResponce{$ENDIF}
  public
    {$IF NOT NOUGAT}
    constructor(aContent: T);
    constructor(anException: Exception);
    {$ENDIF}

    property Exception: Exception {$IF NOUGAT}read mapped.Exception;{$ELSE}read write; readonly;{$ENDIF}
    property Content: T {$IF NOUGAT}read mapped.Content;{$ELSE}read write; readonly;{$ENDIF}
    property IsFailed: Boolean read self.Exception <> nil;
  end;

  HttpResponceBlock<T> = public block (Responce: HttpResponce<T>);

  Http = public static class
  private
    {$IF WINDOWS_PHONE}
    method InternalDownload(anUrl: Url): System.Threading.Tasks.Task<System.Net.HttpWebResponse>;
    {$ENDIF}
    method Download(anUrl: Url): HttpResponce<Binary>;
  public
    method DownloadStringAsync(anUrl: Url; ResponceCallback: HttpResponceBlock<String>);
    method DownloadBinaryAsync(anUrl: Url; ResponceCallback: HttpResponceBlock<Binary>);
    method DownloadXmlAsync(anUrl: Url; ResponceCallback: HttpResponceBlock<XmlDocument>);
  end;

implementation


{ HttpResponce }

{$IF NOUGAT}
method  HttpResponce.initWithContent(aContent: id): id;
begin
  self.Content := aContent;
end;

method HttpResponce.initWithException(anException: Exception): id;
begin
  self.Exception := anException;
end;
{$ELSE}
constructor HttpResponce<T>(anException: Exception);
begin
  self.Exception := anException;
end;

constructor HttpResponce<T>(aContent: T);
begin
  self.Content := aContent;
end;
{$ENDIF}

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
                              var ResponceRequest := System.Net.HttpWebRequest(x.AsyncState);
                              var Responce := System.Net.HttpWebResponse(ResponceRequest.EndGetResponse(x));
                              TaskComplete.TrySetResult(Responce);
                             except
                               on E: Exception do
                                TaskComplete.TrySetException(E);
                             end;
                           end, Request);
  exit TaskComplete.Task;
end;
{$ENDIF}

class method Http.Download(anUrl: Url): HttpResponce<Binary>;
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
      exit new HttpResponce<Binary>(new SugarException("Content is empty"));

    exit new HttpResponce<Binary>(Content); 
  {$ELSEIF WINDOWS_PHONE}
    var Responce := InternalDownload(anUrl).Result;
    
    if Responce.StatusCode <> System.Net.HttpStatusCode.OK then
      exit new HttpResponce<Binary>(new SugarException("Unable to download data, responce: " + Responce.StatusDescription));

    var Stream := Responce.GetResponseStream;
    
    if Stream = nil then
      exit new HttpResponce<Binary>(new SugarException("Content is empty"));

    var Content := Binary.Empty;
    var Buffer := new Byte[16 * 1024];
    var Readed: Integer := Stream.Read(Buffer, 0, Buffer.Length);

    while Readed > 0 do begin
      Content.Write(Buffer, Readed);
      Readed := Stream.Read(Buffer, 0, Buffer.Length);
    end;

    if Content.Length = 0 then
      exit new HttpResponce<Binary>(new SugarException("Content is empty"));

    exit new HttpResponce<Binary>(Content);
  {$ELSEIF NETFX_CORE}
    var Client := new System.Net.Http.HttpClient;

    var Content := Client.GetByteArrayAsync(anUrl).Result;

    if Content = nil then
      exit new HttpResponce<Binary>(new SugarException("Content is empty"));

    if Content.Length = 0 then
      exit new HttpResponce<Binary>(new SugarException("Content is empty"));


    exit new HttpResponce<Binary>(Binary.FromArray(Content));
  {$ELSEIF ECHOES}
  using lClient: System.Net.WebClient := new System.Net.WebClient() do begin
    var Content := lClient.DownloadData(anUrl);
    
    if Content = nil then
      exit new HttpResponce<Binary>(new SugarException("Content is empty"));

    if Content.Length = 0 then
      exit new HttpResponce<Binary>(new SugarException("Content is empty"));

    exit new HttpResponce<Binary>(Binary.FromArray(Content));
  end;
  {$ELSEIF NOUGAT}
  var lError: NSError := nil;
  
  var lData := new NSMutableData withContentsOfURL(anUrl) options(NSDataReadingOptions.NSDataReadingUncached) error(var lError);

  if not assigned(lData) then
    exit new HttpResponce<Binary>(Exception(new SugarNSErrorException(lError)));

  exit new HttpResponce<Binary>(lData);
  {$ENDIF}
  except
    on E: Exception do begin
      var Actual := E;

      {$IF WINDOWS_PHONE OR NETFX_CORE}
      if E is AggregateException then
        Actual := AggregateException(E).InnerException;
      {$ENDIF}

      exit new HttpResponce<Binary>(Actual);
    end;
  end;
end;

class method Http.DownloadStringAsync(anUrl: Url; ResponceCallback: HttpResponceBlock<String>);
begin
  SugarArgumentNullException.RaiseIfNil(anUrl, "Url");
  if ResponceCallback = nil then
    raise new SugarArgumentNullException("ResponceCallback");
  async begin
    var Data := Download(anUrl);
    if Data.IsFailed then
      ResponceCallback(new HttpResponce<String>(Data.Exception))
    else
      ResponceCallback(new HttpResponce<String>(String.FromByteArray(Data.Content.ToArray)));
  end;
end;

class method Http.DownloadBinaryAsync(anUrl: Url; ResponceCallback: HttpResponceBlock<Binary>);
begin
  SugarArgumentNullException.RaiseIfNil(anUrl, "Url");
  if ResponceCallback = nil then
    raise new SugarArgumentNullException("ResponceCallback");
  async begin
    ResponceCallback(Download(anUrl));
  end;
end;

class method Http.DownloadXmlAsync(anUrl: Url; ResponceCallback: HttpResponceBlock<XmlDocument>);
begin
  SugarArgumentNullException.RaiseIfNil(anUrl, "Url");
  if ResponceCallback = nil then
    raise new SugarArgumentNullException("ResponceCallback");
  async begin
    var Data := Download(anUrl);
    if Data.IsFailed then
      ResponceCallback(new HttpResponce<XmlDocument>(Data.Exception))
    else
      ResponceCallback(new HttpResponce<XmlDocument>(XmlDocument.FromBinary(Data.Content)));
  end;
end;

end.

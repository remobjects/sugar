namespace RemObjects.Oxygene.Sugar.IO;

interface

uses
  {$IF WINDOWS_PHONE OR NETFX_CORE}  
  System.IO,
  {$ELSEIF COOPER}
  RemObjects.Oxygene.Sugar.Cooper,
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
  RemObjects.Oxygene.Sugar,
  RemObjects.Oxygene.Sugar.Collections;

type
  File = public class mapped to {$IF WINDOWS_PHONE OR NETFX_CORE}Windows.Storage.StorageFile{$ELSEIF ECHOES}System.String{$ELSEIF COOPER}java.io.File{$ELSEIF NOUGAT}NSString{$ENDIF}
  private    
    {$IF ECHOES}
      {$IF NOT (WINDOWS_PHONE OR NETFX_CORE)}
      method GetName: String;
      {$ENDIF}
    {$ELSEIF NOUGAT}
    method Combine(BasePath: String; SubPath: String): String;
    {$ENDIF}
  public
    method &Copy(Destination: Folder): File;
    method &Copy(Destination: Folder; NewName: String): File;
    method Delete;
    method Move(Destination: Folder): File;
    method Move(Destination: Folder; NewName: String): File;
    method Rename(NewName: String): File;

    method AppendText(Content: String);
    method ReadBytes: array of Byte;
    method ReadText: String;
    method WriteBytes(Data: array of Byte);
    method WriteText(Content: String);

    class method FromPath(Value: String): File;

    {$IF WINDOWS_PHONE OR NETFX_CORE}
    property Path: String read mapped.Path;
    property Name: String read mapped.Name;
    {$ELSEIF ECHOES}
    property Path: String read mapped;
    property Name: String read GetName;
    {$ELSEIF COOPER}
    property Path: String read mapped.AbsolutePath;
    property Name: String read mapped.Name;
    {$ELSEIF NOUGAT}
    property Path: String read mapped;
    property Name: String read NSFileManager.defaultManager.displayNameAtPath(mapped);
    {$ENDIF}
  end;

  {$IF COOPER}
  FileUtils = public static class
  public
    method WriteString(File: java.io.File; Content: String; Append: Boolean);
    method WriteBytes(File: java.io.File; Data: array of Byte; Append: Boolean);
    method ReadBytes(File: java.io.File): array of Byte;
    method ReadString(File: java.io.File): String;
  end;
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  FileUtils = public static class
  public
    method WriteString(File: Windows.Storage.StorageFile; Content: String; Append: Boolean);
    method WriteBytes(File: Windows.Storage.StorageFile; Data: array of Byte; Append: Boolean);
    method ReadBytes(File: Windows.Storage.StorageFile): array of Byte;
    method ReadString(File: Windows.Storage.StorageFile): String;
    method Move(File: Windows.Storage.StorageFile; Destination: Windows.Storage.StorageFolder; NewName: String): Windows.Storage.StorageFile;
  end;
  {$ENDIF}

implementation

{$IF WINDOWS_PHONE OR NETFX_CORE}
class method FileUtils.ReadBytes(File: Windows.Storage.StorageFile): array of Byte;
begin
  using Stream := File.OpenStreamForReadAsync.Result do begin
    result := new Byte[stream.Length];
    Stream.Read(result, 0, stream.Length);    
  end;  
end;

class method FileUtils.ReadString(File: Windows.Storage.StorageFile): String;
begin
  var Data := ReadBytes(File);
  exit System.Text.Encoding.UTF8.GetString(Data, 0, Data.Length);
end;

class method FileUtils.WriteBytes(File: Windows.Storage.StorageFile; Data: array of Byte; Append: Boolean);
begin
  using Stream := File.OpenStreamForWriteAsync.Result do begin
    
    if Append then
      Stream.Seek(0, SeekOrigin.End)
    else
      Stream.SetLength(0);

    Stream.Write(Data, 0, Data.Length);
    Stream.Flush;    
  end;  
end;

class method FileUtils.WriteString(File: Windows.Storage.StorageFile; Content: String; Append: Boolean);
begin
  var Data := System.Text.Encoding.UTF8.GetBytes(Content);
  WriteBytes(File, Data, Append);
end;

class method FileUtils.Move(File: Windows.Storage.StorageFile; Destination: Windows.Storage.StorageFolder; NewName: String): Windows.Storage.StorageFile;
begin
  SugarArgumentNullException.RaiseIfNil(File, "File");
  SugarArgumentNullException.RaiseIfNil(File, "Folder");
  SugarArgumentNullException.RaiseIfNil(File, "NewName");

  result := File.CopyAsync(Destination, NewName, Windows.Storage.NameCollisionOption.FailIfExists).Await;

  if result = nil then
    exit;

  File.DeleteAsync.AsTask.Wait;
end;

method File.&Copy(Destination: Folder): File;
begin
  exit &Copy(Destination, mapped.Name);
end;

method File.&Copy(Destination: Folder; NewName: String): File;
begin
  exit mapped.CopyAsync(Destination, NewName, Windows.Storage.NameCollisionOption.FailIfExists).Await;
end;

method File.Delete;
begin
  mapped.DeleteAsync.AsTask.Wait;
end;

method File.Move(Destination: Folder): File;
begin
  exit Move(Destination, mapped.Name);
end;

method File.Move(Destination: Folder; NewName: String): File;
begin
  exit FileUtils.Move(mapped, Destination, NewName);
end;

method File.Rename(NewName: String): File;
begin
  var BaseDir := System.IO.Path.GetDirectoryName(mapped.Path);
  var Dir := Folder.FromPath(BaseDir);
  mapped.RenameAsync(NewName, Windows.Storage.NameCollisionOption.FailIfExists).AsTask.Wait;
  exit Dir.GetFile(NewName);
end;

method File.AppendText(Content: String);
begin
  FileUtils.WriteString(mapped, Content, true);
end;

method File.ReadBytes: array of Byte;
begin
  exit FileUtils.ReadBytes(mapped);
end;

method File.ReadText: String;
begin
  exit FileUtils.ReadString(mapped);
end;

method File.WriteBytes(Data: array of Byte);
begin
  FileUtils.WriteBytes(mapped, Data, false);
end;

method File.WriteText(Content: String);
begin
  FileUtils.WriteString(mapped, Content, false);
end;

class method File.FromPath(Value: String): File;
begin
  exit Windows.Storage.StorageFile.GetFileFromPathAsync(Value).Await;
end;
{$ELSEIF ECHOES}
method File.GetName: String;
begin
  exit System.IO.Path.GetFileName(mapped);
end;

method File.&Copy(Destination: Folder): File;
begin
  exit &Copy(Destination, GetName);
end;

method File.&Copy(Destination: Folder; NewName: String): File;
begin
  var NewFile := System.IO.Path.Combine(Destination, NewName);
  if System.IO.File.Exists(NewFile) then
    raise new SugarIOException("File "+NewName+" already exists");

  System.IO.File.Copy(mapped, NewFile);
  exit NewFile;
end;

method File.Delete;
begin
  if not System.IO.File.Exists(mapped) then
    raise new SugarIOException("File {0} not found", mapped);

  System.IO.File.Delete(mapped);
end;

method File.Move(Destination: Folder): File;
begin
  exit Move(Destination, GetName);
end;

method File.Move(Destination: Folder; NewName: String): File;
begin
  var NewFile := System.IO.Path.Combine(Destination, NewName);

  if System.IO.File.Exists(NewFile) then
    raise new SugarIOException("File "+NewName+" already exists");

  System.IO.File.Move(mapped, NewFile);
  exit NewFile;
end;

method File.Rename(NewName: String): File;
begin
  exit Move(System.IO.Path.GetDirectoryName(mapped), NewName);
end;

method File.AppendText(Content: String);
begin
  SugarArgumentNullException.RaiseIfNil(Content, "Content");
  System.IO.File.AppendAllText(mapped, Content);
end;

method File.ReadBytes: array of Byte;
begin
  exit System.IO.File.ReadAllBytes(mapped);
end;

method File.ReadText: String;
begin
  exit System.IO.File.ReadAllText(mapped);
end;

method File.WriteBytes(Data: array of Byte);
begin
  System.IO.File.WriteAllBytes(mapped, Data);
end;

method File.WriteText(Content: String);
begin
  SugarArgumentNullException.RaiseIfNil(Content, "Content");
  System.IO.File.WriteAllText(mapped, Content);
end;

class method File.FromPath(Value: String): File;
begin
  if not System.IO.File.Exists(Value) then
    raise new SugarIOException(String.Format("File {0} not found", Value));
 
  exit File(Value);
end;
{$ELSEIF COOPER}
class method FileUtils.WriteString(File: java.io.File; Content: String; Append: Boolean);
begin
  WriteBytes(File, Content.ToByteArray, Append);
end;

class method FileUtils.WriteBytes(File: java.io.File; Data: array of Byte; Append: Boolean);
begin
  if not File.exists then
    raise new SugarIOException("File {0} does not exists", File.Name);

  if not File.canWrite then
    raise new SugarIOException("File {0} can not be written", File.Name);

  var Writer := new java.io.FileOutputStream(File, Append);
  try
    Writer.write(Data);
  finally
    Writer.close;
  end;
end;

class method FileUtils.ReadString(File: java.io.File): String;
begin
  var Data := ReadBytes(File);

  if Data = nil then
    raise new SugarIOException("Unable to read string from file {0}", File.Name);

  exit String.FromByteArray(Data);
end;

class method FileUtils.ReadBytes(File: java.io.File): array of Byte;
begin
  if not File.exists then
    raise new SugarIOException("File {0} does not exists", File.Name);

  if not File.canRead then
    raise new SugarIOException("File {0} can not be read", File.Name);

  if File.length = 0 then
    exit [];

  var Reader := new java.io.FileInputStream(File);
  try
    var Data := new SByte[Integer(File.length)];
    Reader.read(Data);
    exit Data;
  finally
    Reader.close;
  end;
end;

method File.&Copy(Destination: Folder): File;
begin
  exit &Copy(Destination, mapped.Name);
end;

method File.&Copy(Destination: Folder; NewName: String): File;
begin
  SugarArgumentNullException.RaiseIfNil(Destination, "Destination");
  SugarArgumentNullException.RaiseIfNil(NewName, "NewName");

  var NewFile := new java.io.File(Destination, NewName);
  if NewFile.exists then
    raise new SugarIOException(String.Format("File {0} already exists", NewName));

  NewFile.createNewFile;
  var source := new java.io.FileInputStream(mapped).Channel;
  var dest := new java.io.FileOutputStream(NewFile).Channel;
  dest.transferFrom(source, 0, source.size);

  source.close;
  dest.close;
  exit NewFile;
end;

method File.Delete;
begin
  if not mapped.exists then
    raise new SugarIOException("File {0} not found", mapped.Name);

  mapped.delete;
end;

method File.Move(Destination: Folder): File;
begin
  exit Move(Destination, mapped.Name);  
end;

method File.Move(Destination: Folder; NewName: String): File;
begin
  var NewFile := &Copy(Destination, NewName);
  mapped.delete;
  exit NewFile;
end;

method File.Rename(NewName: String): File;
begin
  var NewFile := new java.io.File(mapped.ParentFile, NewName);
  
  if NewFile.exists then
    raise new SugarIOException("File {0} already exists", NewName);

  if not mapped.renameTo(NewFile) then
    raise new SugarIOException("Unable to reanme file {0} to {1}", mapped.Name, NewName);

  exit NewFile;
end;

method File.AppendText(Content: String);
begin
  FileUtils.WriteString(mapped, Content, true);
end;

method File.ReadBytes: array of Byte;
begin
  exit FileUtils.ReadBytes(mapped);
end;

method File.ReadText: String;
begin
  exit FileUtils.ReadString(mapped);
end;

method File.WriteBytes(Data: array of Byte);
begin
  FileUtils.WriteBytes(mapped, Data, false);
end;

method File.WriteText(Content: String);
begin
  FileUtils.WriteString(mapped, Content, false);
end;

class method File.FromPath(Value: String): File;
begin
  var lFile := new java.io.File(Value);
  
  if not lFile.exists then
    raise new SugarIOException(String.Format("File {0} not found", Value));

  exit File(lFile);
end;
{$ELSEIF NOUGAT}
method File.Combine(BasePath: String; SubPath: String): String;
begin
  result := NSString(BasePath):stringByAppendingPathComponent(SubPath);
end;

method File.&Copy(Destination: Folder): File;
begin
  exit &Copy(Destination, Name);
end;

method File.&Copy(Destination: Folder; NewName: String): File;
begin
  var NewFile := Combine(String(Destination), NewName);
  var Manager := NSFileManager.defaultManager;

  if Manager.fileExistsAtPath(NewFile) then
    raise new SugarIOException(String.Format(ErrorMessage.FILE_EXISTS, NewName));

  var lError: Foundation.NSError := nil;
  if not Manager.copyItemAtPath(mapped) toPath(NewFile) error(var lError) then
    raise new SugarNSErrorException(lError);

  exit File(NewFile);
end;

method File.Delete;
begin
  var lError: NSError := nil;
  if not NSFileManager.defaultManager.removeItemAtPath(mapped) error(var lError) then
    raise new SugarNSErrorException(lError);
end;

method File.Move(Destination: Folder): File;
begin
  exit Move(Destination, Name);
end;

method File.Move(Destination: Folder; NewName: String): File;
begin
  var NewFile := Combine(String(Destination), NewName);
  var Manager := NSFileManager.defaultManager;

  if Manager.fileExistsAtPath(NewFile) then
    raise new SugarIOException(String.Format(ErrorMessage.FILE_EXISTS, NewName));

  var lError: Foundation.NSError := nil;
  if not Manager.moveItemAtPath(mapped) toPath(NewFile) error(var lError) then
    raise new SugarNSErrorException(lError);

  exit File(NewFile);
end;

method File.Rename(NewName: String): File;
begin
  var CurrentFolder := NSString(mapped).stringByDeletingLastPathComponent;
  exit Move(Folder(CurrentFolder), NewName);
end;

method File.AppendText(Content: String);
begin
  SugarArgumentNullException.RaiseIfNil(Content, "Data");

  var lData := NSString(Content).dataUsingEncoding(NSStringEncoding.NSUTF8StringEncoding);
  var fileHandle := NSFileHandle.fileHandleForWritingAtPath(mapped) as NSFileHandle;
  fileHandle.seekToEndOfFile;
  fileHandle.writeData(lData);
  fileHandle.closeFile;
end;

method File.ReadBytes: array of Byte;
begin
  var lError: Foundation.NSError := nil;
  var lData: NSData := NSData.dataWithContentsOfFile(mapped) options(NSDataReadingOptions.NSDataReadingMappedIfSafe) error(var lError);
  if not assigned(lData) then 
    raise new SugarNSErrorException(lError);

  result := new Byte[lData.length];
  lData.getBytes(result) length(lData.length);
end;

method File.ReadText: String;
begin
  var lError: Foundation.NSError := nil;
  result := Foundation.NSString.stringWithContentsOfFile(mapped) encoding(NSStringEncoding.NSUTF8StringEncoding) error(var lError);
  if not assigned(result) then 
    raise new SugarNSErrorException(lError);
end;

method File.WriteBytes(Data: array of Byte);
begin
  if Data = nil then
    raise new SugarArgumentNullException(Name);

  var lData := NSData.dataWithBytesNoCopy(^Void(Data)) length(length(Data));
  if not lData:writeToFile(mapped) atomically(true) then
    raise new SugarIOException("Failed to write data to a file");
end;

method File.WriteText(Content: String);
begin
  SugarArgumentNullException.RaiseIfNil(Content, "Content");

  var lError: Foundation.NSError := nil;
  if not NSString(Content):writeToFile(mapped) atomically(true) encoding(NSStringEncoding.NSUTF8StringEncoding) error(var lError) then
    raise new SugarNSErrorException(lError);
end;

class method File.FromPath(Value: String): File;
begin
  if not NSFileManager.defaultManager.fileExistsAtPath(Value) then
    raise new SugarIOException(String.Format("File {0} not found", Value));
 
  exit File(Value);
end;
{$ENDIF}

end.

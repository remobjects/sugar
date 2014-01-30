namespace Sugar.IO;

interface

uses
  {$IF WINDOWS_PHONE OR NETFX_CORE}  
  System.IO,
  {$ELSEIF COOPER}
  Sugar.Cooper,
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
  Sugar,
  Sugar.Collections;

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
    constructor(aPath: String);

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
  FileHelper = public static class
  public
    method WriteString(File: java.io.File; Content: String; Append: Boolean);
    method WriteBytes(File: java.io.File; Data: array of Byte; Append: Boolean);
    method ReadBytes(File: java.io.File): array of Byte;
    method ReadString(File: java.io.File): String;
  end;
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  FileHelper = public static class
  public
    method WriteString(File: Windows.Storage.StorageFile; Content: String; Append: Boolean);
    method WriteBytes(File: Windows.Storage.StorageFile; Data: array of Byte; Append: Boolean);
    method ReadBytes(File: Windows.Storage.StorageFile): array of Byte;
    method ReadString(File: Windows.Storage.StorageFile): String;
    method Move(File: Windows.Storage.StorageFile; Destination: Windows.Storage.StorageFolder; NewName: String): Windows.Storage.StorageFile;
  end;
  {$ENDIF}

implementation

constructor File(aPath: String);
begin
  SugarArgumentNullException.RaiseIfNil(aPath, "Path");
  {$IF COOPER}  
  var lFile := new java.io.File(aPath);
  
  if not lFile.exists then
    raise new SugarIOException(ErrorMessage.FILE_NOTFOUND, aPath);

  exit lFile;
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  exit Windows.Storage.StorageFile.GetFileFromPathAsync(aPath).Await;
  {$ELSEIF ECHOES}
  if not System.IO.File.Exists(aPath) then
    raise new SugarIOException(ErrorMessage.FILE_NOTFOUND, aPath);
 
  exit File(aPath);
  {$ELSEIF NOUGAT} 
  if not NSFileManager.defaultManager.fileExistsAtPath(aPath) then
    raise new SugarIOException(ErrorMessage.FILE_NOTFOUND, aPath);
 
  exit File(aPath);
  {$ENDIF}
end;

{$IF WINDOWS_PHONE OR NETFX_CORE}
class method FileHelper.ReadBytes(File: Windows.Storage.StorageFile): array of Byte;
begin
  using Stream := File.OpenStreamForReadAsync.Result do begin
    result := new Byte[stream.Length];
    Stream.Read(result, 0, stream.Length);    
  end;  
end;

class method FileHelper.ReadString(File: Windows.Storage.StorageFile): String;
begin
  var Data := ReadBytes(File);
  exit System.Text.Encoding.UTF8.GetString(Data, 0, Data.Length);
end;

class method FileHelper.WriteBytes(File: Windows.Storage.StorageFile; Data: array of Byte; Append: Boolean);
begin
  using Stream := File.OpenStreamForWriteAsync.Result do begin
    
    if Append then
      Stream.Seek(0, System.IO.SeekOrigin.End)
    else
      Stream.SetLength(0);

    Stream.Write(Data, 0, Data.Length);
    Stream.Flush;    
  end;  
end;

class method FileHelper.WriteString(File: Windows.Storage.StorageFile; Content: String; Append: Boolean);
begin
  var Data := System.Text.Encoding.UTF8.GetBytes(Content);
  WriteBytes(File, Data, Append);
end;

class method FileHelper.Move(File: Windows.Storage.StorageFile; Destination: Windows.Storage.StorageFolder; NewName: String): Windows.Storage.StorageFile;
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
  exit FileHelper.Move(mapped, Destination, NewName);
end;

method File.Rename(NewName: String): File;
begin
  var BaseDir := System.IO.Path.GetDirectoryName(mapped.Path);
  var Dir := new Folder(BaseDir);
  mapped.RenameAsync(NewName, Windows.Storage.NameCollisionOption.FailIfExists).AsTask.Wait;
  exit Dir.GetFile(NewName);
end;

method File.AppendText(Content: String);
begin
  FileHelper.WriteString(mapped, Content, true);
end;

method File.ReadBytes: array of Byte;
begin
  exit FileHelper.ReadBytes(mapped);
end;

method File.ReadText: String;
begin
  exit FileHelper.ReadString(mapped);
end;

method File.WriteBytes(Data: array of Byte);
begin
  FileHelper.WriteBytes(mapped, Data, false);
end;

method File.WriteText(Content: String);
begin
  FileHelper.WriteString(mapped, Content, false);
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
    raise new SugarIOException(ErrorMessage.FILE_EXISTS, NewName);

  System.IO.File.Copy(mapped, NewFile);
  exit NewFile;
end;

method File.Delete;
begin
  if not System.IO.File.Exists(mapped) then
    raise new SugarIOException(ErrorMessage.FILE_NOTFOUND, mapped);

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
    raise new SugarIOException(ErrorMessage.FILE_EXISTS, NewFile);

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
{$ELSEIF COOPER}
class method FileHelper.WriteString(File: java.io.File; Content: String; Append: Boolean);
begin
  WriteBytes(File, Content.ToByteArray, Append);
end;

class method FileHelper.WriteBytes(File: java.io.File; Data: array of Byte; Append: Boolean);
begin
  if not File.exists then
    raise new SugarIOException(ErrorMessage.FILE_NOTFOUND, File.Name);

  if not File.canWrite then
    raise new SugarIOException(ErrorMessage.FILE_WRITE_ERROR, File.Name);

  var Writer := new java.io.FileOutputStream(File, Append);
  try
    Writer.write(Data);
  finally
    Writer.close;
  end;
end;

class method FileHelper.ReadString(File: java.io.File): String;
begin
  var Data := ReadBytes(File);

  if Data = nil then
    raise new SugarIOException(ErrorMessage.FILE_READ_ERROR, File.Name);

  exit new String(Data);
end;

class method FileHelper.ReadBytes(File: java.io.File): array of Byte;
begin
  if not File.exists then
    raise new SugarIOException(ErrorMessage.FILE_NOTFOUND, File.Name);

  if not File.canRead then
    raise new SugarIOException(ErrorMessage.FILE_READ_ERROR, File.Name);

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
    raise new SugarIOException(ErrorMessage.FILE_EXISTS, NewName);

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
    raise new SugarIOException(ErrorMessage.FILE_NOTFOUND, mapped.Name);

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
    raise new SugarIOException(ErrorMessage.FILE_EXISTS, NewName);

  if not mapped.renameTo(NewFile) then
    raise new SugarIOException(ErrorMessage.IO_RENAME_ERROR, mapped.Name, NewName);

  exit NewFile;
end;

method File.AppendText(Content: String);
begin
  FileHelper.WriteString(mapped, Content, true);
end;

method File.ReadBytes: array of Byte;
begin
  exit FileHelper.ReadBytes(mapped);
end;

method File.ReadText: String;
begin
  exit FileHelper.ReadString(mapped);
end;

method File.WriteBytes(Data: array of Byte);
begin
  FileHelper.WriteBytes(mapped, Data, false);
end;

method File.WriteText(Content: String);
begin
  FileHelper.WriteString(mapped, Content, false);
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
    raise new SugarIOException(ErrorMessage.FILE_WRITE_ERROR, mapped);
end;

method File.WriteText(Content: String);
begin
  SugarArgumentNullException.RaiseIfNil(Content, "Content");

  var lError: Foundation.NSError := nil;
  if not NSString(Content):writeToFile(mapped) atomically(true) encoding(NSStringEncoding.NSUTF8StringEncoding) error(var lError) then
    raise new SugarNSErrorException(lError);
end;
{$ENDIF}

end.

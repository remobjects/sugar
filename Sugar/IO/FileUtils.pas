namespace Sugar.IO;

interface

uses
  {$IF WINDOWS_PHONE OR NETFX_CORE}
  Windows.Storage,
  System.IO,
  {$ENDIF}
  Sugar;

type
  FileUtils = public static class
  {$IF WINDOWS_PHONE OR NETFX_CORE}
  private
    method GetFolder(FileName: String): StorageFolder;
    method GetFile(FileName: String): StorageFile;
  public
    method Exists(aFile: File): Boolean;
  {$ENDIF}
  public    
    method &Copy(SourceFileName: String; DestFileName: String);
    method &Create(FileName: String);
    method Delete(FileName: String);
    method Exists(FileName: String): Boolean;
    method Move(SourceFileName: String; DestFileName: String);

    method AppendText(FileName: String; Content: String);
    method AppendBytes(FileName: String; Content: array of Byte);
    method AppendBinary(FileName: String; Content: Binary);
    method ReadText(FileName: String; Encoding: Encoding := nil): String;
    method ReadBytes(FileName: String): array of Byte;
    method ReadBinary(FileName: String): Binary;
    method WriteBytes(FileName: String; Content: array of Byte);
    method WriteText(FileName: String; Content: String);
    method WriteBinary(FileName: String; Content: Binary);
  end;

implementation

{$IF WINDOWS_PHONE OR NETFX_CORE}
class method FileUtils.GetFolder(FileName: String): StorageFolder;
begin
  exit StorageFolder.GetFolderFromPathAsync(Path.GetParentDirectory(FileName)).Await;
end;

class method FileUtils.GetFile(FileName: String): StorageFile;
begin
  exit StorageFile.GetFileFromPathAsync(FileName).Await;
end;

class method FileUtils.Exists(aFile: File): Boolean;
begin
  try
    StorageFile(aFile).OpenReadAsync.Await.Dispose;
    exit true;
  except
    exit false;
  end;
end;
{$ENDIF}

class method FileUtils.Copy(SourceFileName: String; DestFileName: String);
begin
  if not Exists(SourceFileName) then
    raise new SugarFileNotFoundException(SourceFileName);

  if Exists(DestFileName) then
    raise new SugarIOException(ErrorMessage.FILE_EXISTS, DestFileName);

  {$IF COOPER}
  using Origin := new java.io.File(SourceFileName) do begin
    using NewFile := new java.io.File(DestFileName) do begin

      NewFile.createNewFile;
      var source := new java.io.FileInputStream(Origin).Channel;
      var dest := new java.io.FileOutputStream(NewFile).Channel;
      dest.transferFrom(source, 0, source.size);
      source.close;
      dest.close;
    end;
  end;
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  var Origin: StorageFile := GetFile(SourceFileName);
  Origin.CopyAsync(GetFolder(DestFileName), Path.GetFileName(DestFileName), NameCollisionOption.FailIfExists).Await;
  {$ELSEIF ECHOES}
  System.IO.File.Copy(SourceFileName, DestFileName);
  {$ELSEIF NOUGAT}
  var lError: Foundation.NSError := nil;
  if not NSFileManager.defaultManager.copyItemAtPath(SourceFileName) toPath(DestFileName) error(var lError) then
    raise new SugarNSErrorException(lError);
  {$ENDIF}
end;

class method FileUtils.Create(FileName: String);
begin
  if Exists(FileName) then
    raise new SugarIOException(ErrorMessage.FILE_EXISTS, FileName);

  {$IF COOPER}
  new java.io.File(FileName).createNewFile;
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  GetFolder(FileName).CreateFileAsync(Path.GetFileName(FileName), CreationCollisionOption.FailIfExists).Await;
  {$ELSEIF ECHOES}
  using fs := System.IO.File.Create(FileName) do
    fs.Close;
  {$ELSEIF NOUGAT}
  NSFileManager.defaultManager.createFileAtPath(FileName) contents(nil) attributes(nil);
  {$ENDIF}
end;

class method FileUtils.Delete(FileName: String);
begin
  if not Exists(FileName) then
    raise new SugarFileNotFoundException(FileName);

  {$IF COOPER}
  new java.io.File(FileName).delete;
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  GetFile(FileName).DeleteAsync.AsTask.Wait;
  {$ELSEIF ECHOES}
  System.IO.File.Delete(FileName);
  {$ELSEIF NOUGAT}
  var lError: NSError := nil;
  if not NSFileManager.defaultManager.removeItemAtPath(FileName) error(var lError) then
    raise new SugarNSErrorException(lError);
  {$ENDIF}
end;

class method FileUtils.Exists(FileName: String): Boolean;
begin
  SugarArgumentNullException.RaiseIfNil(FileName, "FileName");
  {$IF COOPER}
  exit new java.io.File(FileName).exists;
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  try
    exit GetFile(FileName) <> nil;
  except
    exit false;
  end;
  {$ELSEIF ECHOES}
  exit System.IO.File.Exists(FileName);
  {$ELSEIF NOUGAT}
  exit NSFileManager.defaultManager.fileExistsAtPath(FileName);
  {$ENDIF}
end;

class method FileUtils.Move(SourceFileName: String; DestFileName: String);
begin
  if not Exists(SourceFileName) then
    raise new SugarFileNotFoundException(SourceFileName);

  if Exists(DestFileName) then
    raise new SugarIOException(ErrorMessage.FILE_EXISTS, DestFileName);

  {$IF COOPER}
  &Copy(SourceFileName, DestFileName);
  Delete(SourceFileName);
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  &Copy(SourceFileName, DestFileName);
  Delete(SourceFileName);
  {$ELSEIF ECHOES}
  System.IO.File.Move(SourceFileName, DestFileName);
  {$ELSEIF NOUGAT}
  var lError: Foundation.NSError := nil;
  if not NSFileManager.defaultManager.moveItemAtPath(SourceFileName) toPath(DestFileName) error(var lError) then
    raise new SugarNSErrorException(lError);
  {$ENDIF}
end;

class method FileUtils.AppendText(FileName: String; Content: String);
begin
  AppendBytes(FileName, Content.ToByteArray);
end;

class method FileUtils.AppendBytes(FileName: String; Content: array of Byte);
begin
  var Handle := new FileHandle(FileName, FileOpenMode.ReadWrite);
  try
    Handle.Seek(0, SeekOrigin.End);
    Handle.Write(Content);
  finally
    Handle.Close;
  end;
end;

class method FileUtils.AppendBinary(FileName: String; Content: Binary);
begin
  var Handle := new FileHandle(FileName, FileOpenMode.ReadWrite);
  try
    Handle.Seek(0, SeekOrigin.End);
    Handle.Write(Content);
  finally
    Handle.Close;
  end;
end;

class method FileUtils.ReadText(FileName: String; Encoding: Encoding := nil): String;
begin
  exit new String(ReadBytes(FileName), Encoding);
end;

class method FileUtils.ReadBytes(FileName: String): array of Byte;
begin
  exit ReadBinary(FileName).ToArray;
end;

class method FileUtils.ReadBinary(FileName: String): Binary;
begin
  var Handle := new FileHandle(FileName, FileOpenMode.ReadOnly);
  try
    Handle.Seek(0, SeekOrigin.Begin);
    exit Handle.Read(Handle.Length);
  finally
    Handle.Close;
  end;
end;

class method FileUtils.WriteBytes(FileName: String; Content: array of Byte);
begin
  var Handle := new FileHandle(FileName, FileOpenMode.Create);
  try
    Handle.Length := 0;
    Handle.Write(Content);
  finally
    Handle.Close;
  end;
end;

class method FileUtils.WriteText(FileName: String; Content: String);
begin
  WriteBytes(FileName, Content.ToByteArray);
end;

class method FileUtils.WriteBinary(FileName: String; Content: Binary);
begin
  var Handle := new FileHandle(FileName, FileOpenMode.Create);
  try
    Handle.Length := 0;
    Handle.Write(Content);
  finally
    Handle.Close;
  end;
end;

end.
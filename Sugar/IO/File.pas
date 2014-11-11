namespace Sugar.IO;

interface

uses
  {$IF WINDOWS_PHONE OR NETFX_CORE}  
  System.IO,
  Windows.Storage,
  {$ELSEIF COOPER}
  {$ENDIF}
  Sugar,
  Sugar.Collections;

type
  File = public class mapped to {$IF WINDOWS_PHONE OR NETFX_CORE}Windows.Storage.StorageFile{$ELSEIF ECHOES}System.String{$ELSEIF COOPER}java.io.File{$ELSEIF NOUGAT}NSString{$ENDIF}
  private    
    method GetPath: String;
    method GetName: String;
  public
    constructor(aPath: String);

    method &Copy(Destination: Folder): File;
    method &Copy(Destination: Folder; NewName: String): File;
    method Delete;
    method Exists: Boolean;
    method Move(Destination: Folder): File;
    method Move(Destination: Folder; NewName: String): File;
    method Open(Mode: FileOpenMode): FileHandle;
    method Rename(NewName: String): File;

    property Path: String read GetPath;
    property Name: String read GetName;
  end;

implementation

constructor File(aPath: String);
begin
  SugarArgumentNullException.RaiseIfNil(aPath, "Path");

  if not FileUtils.Exists(aPath) then
    raise new SugarFileNotFoundException(aPath);

  {$IF COOPER}  
  exit new java.io.File(aPath);
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  exit StorageFile.GetFileFromPathAsync(aPath).Await;
  {$ELSEIF ECHOES OR NOUGAT}
  exit File(aPath);
  {$ENDIF}
end;

method File.&Copy(Destination: Folder): File;
begin
  exit &Copy(Destination, Name);
end;

method File.&Copy(Destination: Folder; NewName: String): File;
begin
  SugarArgumentNullException.RaiseIfNil(Destination, "Destination");
  SugarArgumentNullException.RaiseIfNil(NewName, "NewName");

  {$IF COOPER}  
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
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  exit mapped.CopyAsync(Destination, NewName, NameCollisionOption.FailIfExists).Await;
  {$ELSEIF ECHOES}
  var NewFile := System.IO.Path.Combine(Destination, NewName);
  if System.IO.File.Exists(NewFile) then
    raise new SugarIOException(ErrorMessage.FILE_EXISTS, NewName);

  System.IO.File.Copy(mapped, NewFile);
  exit NewFile;
  {$ELSEIF NOUGAT}
  var NewFile := NSString(Destination).stringByAppendingPathComponent(NewName);
  var Manager := NSFileManager.defaultManager;

  if Manager.fileExistsAtPath(NewFile) then
    raise new SugarIOException(String.Format(ErrorMessage.FILE_EXISTS, NewName));

  var lError: Foundation.NSError := nil;
  if not Manager.copyItemAtPath(mapped) toPath(NewFile) error(var lError) then
    raise new SugarNSErrorException(lError);

  exit File(NewFile);
  {$ENDIF}
end;

method File.Delete;
begin
  {$IF COOPER}  
  if not mapped.exists then
    raise new SugarFileNotFoundException(self.Path);

  mapped.delete;
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  mapped.DeleteAsync.AsTask.Wait;
  {$ELSEIF ECHOES}
  if not System.IO.File.Exists(mapped) then
    raise new SugarFileNotFoundException(self.Path);

  System.IO.File.Delete(mapped);
  {$ELSEIF NOUGAT}
  var lError: NSError := nil;
  if not NSFileManager.defaultManager.removeItemAtPath(mapped) error(var lError) then
    raise new SugarNSErrorException(lError);
  {$ENDIF}
end;

method File.Exists: Boolean;
begin
  {$IF COOPER}  
  exit mapped.exists;
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  exit FileUtils.Exists(mapped);
  {$ELSEIF ECHOES}
  exit FileUtils.Exists(mapped);
  {$ELSEIF NOUGAT}
  exit FileUtils.Exists(mapped);
  {$ENDIF}
end;

method File.GetName: String;
begin
  {$IF COOPER}  
  exit mapped.Name;
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  exit mapped.Name;
  {$ELSEIF ECHOES}
  exit System.IO.Path.GetFileName(mapped);
  {$ELSEIF NOUGAT}
  exit NSFileManager.defaultManager.displayNameAtPath(mapped);
  {$ENDIF}
end;

method File.GetPath: String;
begin
  {$IF COOPER}  
  exit mapped.AbsolutePath;
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  exit mapped.Path;
  {$ELSEIF ECHOES}
  exit mapped;
  {$ELSEIF NOUGAT}
  exit mapped;
  {$ENDIF}
end;

method File.Move(Destination: Folder): File;
begin
  exit Move(Destination, Name);
end;

method File.Move(Destination: Folder; NewName: String): File;
begin
  {$IF COOPER}  
  var NewFile := &Copy(Destination, NewName);
  mapped.delete;
  exit NewFile;
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  result := mapped.CopyAsync(Destination, NewName, NameCollisionOption.FailIfExists).Await;
  mapped.DeleteAsync.AsTask.Wait;
  {$ELSEIF ECHOES}
  var NewFile := System.IO.Path.Combine(Destination, NewName);

  if System.IO.File.Exists(NewFile) then
    raise new SugarIOException(ErrorMessage.FILE_EXISTS, NewFile);

  System.IO.File.Move(mapped, NewFile);
  exit NewFile;
  {$ELSEIF NOUGAT}
  var NewFile := NSString(Destination).stringByAppendingPathComponent(NewName);
  var Manager := NSFileManager.defaultManager;

  if Manager.fileExistsAtPath(NewFile) then
    raise new SugarIOException(String.Format(ErrorMessage.FILE_EXISTS, NewName));

  var lError: Foundation.NSError := nil;
  if not Manager.moveItemAtPath(mapped) toPath(NewFile) error(var lError) then
    raise new SugarNSErrorException(lError);

  exit File(NewFile);
  {$ENDIF}
end;

method File.Open(Mode: FileOpenMode): FileHandle;
begin
  if not Exists then
    raise new SugarFileNotFoundException(self.Path);

  exit FileHandle.FromFile(mapped, Mode);
end;

method File.Rename(NewName: String): File;
begin  
  {$IF COOPER}  
  var NewFile := new java.io.File(mapped.ParentFile, NewName);
  
  if NewFile.exists then
    raise new SugarIOException(ErrorMessage.FILE_EXISTS, NewName);

  if not mapped.renameTo(NewFile) then
    raise new SugarIOException(ErrorMessage.IO_RENAME_ERROR, mapped.Name, NewName);

  exit NewFile;
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  mapped.RenameAsync(NewName, Windows.Storage.NameCollisionOption.FailIfExists).AsTask.Wait;
  exit mapped;
  {$ELSEIF ECHOES}
  exit Move(System.IO.Path.GetDirectoryName(mapped), NewName);
  {$ELSEIF NOUGAT}
  var CurrentFolder := NSString(mapped).stringByDeletingLastPathComponent;
  exit Move(Folder(CurrentFolder), NewName);
  {$ENDIF}
end;

end.

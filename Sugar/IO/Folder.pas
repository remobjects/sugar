namespace Sugar.IO;

interface

uses
  {$IF WINDOWS_PHONE OR NETFX_CORE}  
  System.IO,
  {$ELSEIF COOPER}
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
  Sugar,
  Sugar.Collections;

type
  Folder = public class mapped to {$IF WINDOWS_PHONE OR NETFX_CORE}Windows.Storage.StorageFolder{$ELSEIF ECHOES}System.String{$ELSEIF COOPER}java.io.File{$ELSEIF NOUGAT}Foundation.NSString{$ENDIF}
  private
    class method GetSeparator: String;
  {$IF ECHOES}
    method GetName: String;
  {$ELSEIF NOUGAT}
    method Combine(BasePath: String; SubPath: String): String;
  {$ENDIF}
  public
    constructor(aPath: String);

    method CreateFile(FileName: String; FailIfExists: Boolean): File;
    method CreateFolder(FolderName: String; FailIfExists: Boolean): Folder;
    method Delete;
    method GetFile(FileName: String): File;
    method GetFiles: array of File;
    method GetFolder(FolderName: String): Folder;
    method GetFolders: array of Folder;
    method Rename(NewName: String);

    class method UserLocal: Folder;

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

    class property Separator: String read GetSeparator;
  end;

  {$IF WINDOWS_PHONE OR NETFX_CORE}
  extension method Windows.Foundation.IAsyncOperation<TResult>.Await<TResult>: TResult;  
  {$ENDIF}

  {$IF COOPER OR NOUGAT}
  FolderHelper = public static class
  public
    {$IF COOPER}method DeleteFolder(Value: java.io.File);{$ENDIF}
    {$IF NOUGAT}method IsDirectory(Value: String): Boolean;{$ENDIF}
  end;
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  type
  FolderHelper = public static class
  public
    method GetFile(Folder: Windows.Storage.StorageFolder; FileName: String): Windows.Storage.StorageFile;
    method GetFolder(Folder: Windows.Storage.StorageFolder; FolderName: String): Windows.Storage.StorageFolder;
  end;
  {$ENDIF}

implementation

constructor Folder(aPath: String);
begin
  SugarArgumentNullException.RaiseIfNil(aPath, "Path");
  {$IF COOPER}  
  var lFile := new java.io.File(aPath);

  if not lFile.exists then
    raise new SugarIOException(ErrorMessage.FOLDER_NOTFOUND, aPath);

  exit Folder(lFile);
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  exit Windows.Storage.StorageFolder.GetFolderFromPathAsync(aPath).Await;
  {$ELSEIF ECHOES}
  if not System.IO.Directory.Exists(aPath) then
    raise new SugarIOException(ErrorMessage.FOLDER_NOTFOUND, aPath);
 
  exit Folder(aPath);
  {$ELSEIF NOUGAT} 
  if not NSFileManager.defaultManager.fileExistsAtPath(aPath) then
    raise new SugarIOException(ErrorMessage.FOLDER_NOTFOUND, aPath);
 
  exit Folder(aPath);
  {$ENDIF}
end;

{$IF WINDOWS_PHONE OR NETFX_CORE}
class method FolderHelper.GetFile(Folder: Windows.Storage.StorageFolder; FileName: String): Windows.Storage.StorageFile;
begin
  SugarArgumentNullException.RaiseIfNil(Folder, "Folder");
  SugarArgumentNullException.RaiseIfNil(FileName, "FileName");
  try
    exit Folder.GetFileAsync(FileName).Await;
  except
    exit nil;
  end;
end;

class method FolderHelper.GetFolder(Folder: Windows.Storage.StorageFolder; FolderName: String): Windows.Storage.StorageFolder;
begin
  SugarArgumentNullException.RaiseIfNil(Folder, "Folder");
  SugarArgumentNullException.RaiseIfNil(FolderName, "FolderName");
  try
    exit Folder.GetFolderAsync(FolderName).Await;
  except
    exit nil;
  end;
end;

method Folder.GetName: String;
begin
  exit mapped.Name;
end;

class method Folder.GetSeparator: String;
begin
  exit "\";
end;

class method Folder.UserLocal: Folder;
begin
  exit Windows.Storage.ApplicationData.Current.LocalFolder;
end;

method Folder.CreateFile(FileName: String; FailIfExists: Boolean): File;
begin
  exit mapped.CreateFileAsync(FileName, iif(FailIfExists, Windows.Storage.CreationCollisionOption.FailIfExists, Windows.Storage.CreationCollisionOption.OpenIfExists)).Await;
end;

method Folder.CreateFolder(FolderName: String; FailIfExists: Boolean): Folder;
begin
  exit mapped.CreateFolderAsync(FolderName, iif(FailIfExists, Windows.Storage.CreationCollisionOption.FailIfExists, Windows.Storage.CreationCollisionOption.OpenIfExists)).Await;
end;

method Folder.Delete;
begin
  mapped.DeleteAsync.AsTask.Wait;
end;

method Folder.GetFile(FileName: String): File;
begin
  exit FolderHelper.GetFile(mapped, FileName);
end;

method Folder.GetFiles: array of File;
begin
  var files := mapped.GetFilesAsync.Await;
  result := new File[files.Count];
  for i: Integer := 0 to files.Count-1 do
    result[i] := File(files.Item[i]);
end;

method Folder.GetFolder(FolderName: String): Folder;
begin
  exit FolderHelper.GetFolder(mapped, FolderName);
end;

method Folder.GetFolders: array of Folder;
begin
  var folders := mapped.GetFoldersAsync.Await;
  result := new Folder[folders.Count];
  for i: Integer := 0 to folders.Count-1 do
    result[i] := Folder(folders.Item[i]);
end;

method Folder.Rename(NewName: String);
begin
  mapped.RenameAsync(NewName, Windows.Storage.NameCollisionOption.FailIfExists).AsTask.Wait;
end;

extension method Windows.Foundation.IAsyncOperation<TResult>.&Await<TResult>: TResult;
begin
  exit self.AsTask.Result;
end;
{$ELSEIF ECHOES}
method Folder.GetName: String;
begin
  exit new System.IO.DirectoryInfo(mapped).Name;
end;

class method Folder.GetSeparator: String;
begin
  exit System.IO.Path.DirectorySeparatorChar;
end;

class method Folder.UserLocal: Folder;
begin
  exit Folder(System.Environment.GetFolderPath(System.Environment.SpecialFolder.UserProfile));
end;

method Folder.CreateFile(FileName: String; FailIfExists: Boolean): File;
begin
  var NewFileName := System.IO.Path.Combine(mapped, FileName);

  if System.IO.File.Exists(NewFileName) then begin
    if FailIfExists then
      raise new SugarIOException(ErrorMessage.FILE_EXISTS, FileName);

    exit NewFileName;
  end;

  var fs := System.IO.File.Create(NewFileName);
  fs.Close;
  exit NewFileName;
end;

method Folder.CreateFolder(FolderName: String; FailIfExists: Boolean): Folder;
begin
  var NewFolderName := System.IO.Path.Combine(mapped, FolderName);

  if System.IO.Directory.Exists(NewFolderName) then begin
    if FailIfExists then
      raise new SugarIOException(ErrorMessage.FOLDER_EXISTS, FolderName);

    exit NewFolderName;
  end;

  System.IO.Directory.CreateDirectory(NewFolderName);
  exit NewFolderName;
end;

method Folder.Delete;
begin
  System.IO.Directory.Delete(mapped, true);
end;

method Folder.GetFile(FileName: String): File;
begin
  var ExistingFileName := System.IO.Path.Combine(mapped, FileName);
  if System.IO.File.Exists(ExistingFileName) then
    exit ExistingFileName;

  exit nil;
end;

method Folder.GetFiles: array of File;
begin
  exit System.IO.Directory.GetFiles(mapped);
end;

method Folder.GetFolder(FolderName: String): Folder;
begin
  var ExistingFolderName := System.IO.Path.Combine(mapped, FolderName);
  if System.IO.Directory.Exists(ExistingFolderName) then
    exit ExistingFolderName;

  exit nil;
end;

method Folder.GetFolders: array of Folder;
begin
  exit System.IO.Directory.GetDirectories(mapped);
end;

method Folder.Rename(NewName: String);
begin
  var TopLevel := System.IO.Path.GetDirectoryName(mapped);
  var FolderName := System.IO.Path.Combine(TopLevel, NewName);
  if System.IO.Directory.Exists(FolderName) then
    raise new SugarIOException(ErrorMessage.FOLDER_EXISTS, NewName);

  System.IO.Directory.Move(mapped, FolderName);
  mapped := FolderName;
end;
{$ELSEIF COOPER}
method Folder.CreateFile(FileName: String; FailIfExists: Boolean): File;
begin
  var NewFile := new java.io.File(mapped, FileName);
  if NewFile.exists then begin
    if FailIfExists then
      raise new SugarIOException(ErrorMessage.FILE_EXISTS, FileName);

    exit NewFile;
  end;

  NewFile.createNewFile;
  exit NewFile;
end;

class method Folder.GetSeparator: String;
begin
  exit java.io.File.separator;
end;

class method Folder.UserLocal: Folder;
begin
  {$IF ANDROID}
  exit Environment.AppContext.FilesDir;
  {$ELSE}
  exit new java.io.File(System.getProperty("user.home"));
  {$ENDIF}
end;

method Folder.CreateFolder(FolderName: String; FailIfExists: Boolean): Folder;
begin
  var NewFolder := new java.io.File(mapped, FolderName);
  if NewFolder.exists then begin
    if FailIfExists then
      raise new SugarIOException(ErrorMessage.FOLDER_EXISTS, FolderName);

    exit NewFolder;
  end;

  if not NewFolder.mkdir then
    raise new SugarIOException(ErrorMessage.FOLDER_CREATE_ERROR, FolderName);

  exit NewFolder;
end;

class method FolderHelper.DeleteFolder(Value: java.io.File);
begin
  if Value.isDirectory then begin
    var Items := Value.list;
    for Item in Items do
      DeleteFolder(new java.io.File(Value, Item));

    if not Value.delete then
      raise new SugarIOException(ErrorMessage.FOLDER_DELETE_ERROR, Value.Name);
  end
  else
    if not Value.delete then
      raise new SugarIOException(ErrorMessage.FOLDER_DELETE_ERROR, Value.Name);
end;

method Folder.Delete;
begin
  if not mapped.exists then
    raise new SugarIOException(ErrorMessage.FOLDER_NOTFOUND, mapped.Name);

  FolderHelper.DeleteFolder(mapped);
end;

method Folder.GetFile(FileName: String): File;
begin
  var ExistingFile := new java.io.File(mapped, FileName);
  if not ExistingFile.exists then
    exit nil;

  exit ExistingFile;
end;

method Folder.GetFiles: array of File;
begin
  exit mapped.listFiles((f,n)->new java.io.File(f, n).isFile);
end;

method Folder.GetFolder(FolderName: String): Folder;
begin
  var ExistingFolder := new java.io.File(mapped, FolderName);
  if not ExistingFolder.exists then
    exit nil;

  exit ExistingFolder;
end;

method Folder.GetFolders: array of Folder;
begin
  exit mapped.listFiles((f,n)->new java.io.File(f, n).isDirectory);
end;

method Folder.Rename(NewName: String);
begin
  var NewFolder := new java.io.File(mapped.ParentFile, NewName);
  if NewFolder.exists then
    raise new SugarIOException(ErrorMessage.FOLDER_EXISTS, NewName);

  if not mapped.renameTo(NewFolder) then
    raise new SugarIOException(ErrorMessage.IO_RENAME_ERROR, mapped.Name, NewName);

  mapped := NewFolder;
end;
{$ELSEIF NOUGAT}
method Folder.CreateFile(FileName: String; FailIfExists: Boolean): File;
begin
  var NewFileName := Combine(mapped, FileName);
  var Manager := NSFileManager.defaultManager;
  if Manager.fileExistsAtPath(NewFileName) then begin
    if FailIfExists then
      raise new SugarIOException(ErrorMessage.FILE_EXISTS, FileName);

    exit File(NewFileName);
  end;

  Manager.createFileAtPath(NewFileName) contents(nil) attributes(nil);
  exit File(NewFileName);
end;

class method Folder.GetSeparator: String;
begin
  exit "/";
end;

class method Folder.UserLocal: Folder;
begin
  exit Folder(Foundation.NSHomeDirectory);
end;

method Folder.CreateFolder(FolderName: String; FailIfExists: Boolean): Folder;
begin
  var NewFolderName := Combine(mapped, FolderName);
  var Manager := NSFileManager.defaultManager;
  if Manager.fileExistsAtPath(NewFolderName) then begin
    if FailIfExists then
      raise new SugarIOException(ErrorMessage.FOLDER_EXISTS, FolderName);

    exit Folder(NewFolderName);
  end;

  Manager.createDirectoryAtPath(NewFolderName) withIntermediateDirectories(false) attributes(nil) error(nil);
  exit Folder(NewFolderName);
end;

method Folder.Delete;
begin
  var lError: NSError := nil;
  if not NSFileManager.defaultManager.removeItemAtPath(mapped) error(var lError) then
    raise new SugarNSErrorException(lError);
end;

method Folder.GetFile(FileName: String): File;
begin
  SugarArgumentNullException.RaiseIfNil(FileName, "FileName");
  var ExistingFileName := Combine(mapped, FileName);
  if not NSFileManager.defaultManager.fileExistsAtPath(ExistingFileName) then
    exit nil;

  exit File(ExistingFileName);
end;

class method FolderHelper.IsDirectory(Value: String): Boolean;
begin  
  Foundation.NSFileManager.defaultManager.fileExistsAtPath(Value) isDirectory(@Result);
end;

method Folder.GetFiles: array of File;
begin
  var Items := NSFileManager.defaultManager.contentsOfDirectoryAtPath(mapped) error(nil);
  if Items = nil then
    exit new File[0];

  var Files := new List<File>;
  for i: Integer := 0 to Items.count - 1 do begin
    var item := Combine(mapped, Items.objectAtIndex(i));
    if not FolderHelper.IsDirectory(item) then
      Files.Add(File(item));
  end;

  exit Files.ToArray;
end;

method Folder.GetFolder(FolderName: String): Folder;
begin
  SugarArgumentNullException.RaiseIfNil(FolderName, "FolderName");
  var ExistingFolderName := Combine(mapped, FolderName);
  if not NSFileManager.defaultManager.fileExistsAtPath(ExistingFolderName) then
    exit nil;

  exit Folder(ExistingFolderName);
end;

method Folder.GetFolders: array of Folder;
begin
  var Items := NSFileManager.defaultManager.contentsOfDirectoryAtPath(mapped) error(nil);
  if Items = nil then
    exit new Folder[0];

  var Folders := new List<Folder>;
  for i: Integer := 0 to Items.count - 1 do begin
    var item := Combine(mapped, Items.objectAtIndex(i));
    if FolderHelper.IsDirectory(item) then
      Folders.Add(Folder(item));
  end;

  exit Folders.ToArray;
end;

method Folder.Rename(NewName: String);
begin
  var RootFolder := mapped.stringByDeletingLastPathComponent;
  var NewFolderName := Combine(RootFolder, NewName);
  var Manager := NSFileManager.defaultManager;

  if Manager.fileExistsAtPath(NewFolderName) then
    raise new SugarIOException(ErrorMessage.FOLDER_EXISTS, NewName);

  var lError: NSError := nil; 
  if not Manager.moveItemAtPath(mapped) toPath(NewFolderName) error(var lError) then
    raise new SugarNSErrorException(lError);

  mapped := NewFolderName;
end;

method Folder.Combine(BasePath: String; SubPath: String): String;
begin
  result := NSString(BasePath):stringByAppendingPathComponent(SubPath);
end;
{$ENDIF}

end.
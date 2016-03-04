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
  {$IF COOPER}
  com.remobjects.elements.linq,
  {$ENDIF}
  Sugar.Collections;

type
  Folder = public class mapped to {$IF WINDOWS_PHONE OR NETFX_CORE}Windows.Storage.StorageFolder{$ELSEIF ECHOES}System.String{$ELSEIF COOPER}java.lang.String{$ELSEIF NOUGAT}Foundation.NSString{$ENDIF}
  private
    class method GetSeparator: Char;
    {$IF COOPER}
    property JavaFile: java.io.File read new java.io.File(mapped);
    {$ELSEIF NOUGAT}
    method Combine(BasePath: String; SubPath: String): String;
    {$ENDIF}
    
    method __Exists: Boolean; // Workaround for 74547: Mapped types: static methods can be called with class type as parameter
  public
    constructor(aPath: not nullable String);

    method CreateFile(FileName: String; FailIfExists: Boolean := false): File;
    method CreateFolder(FailIfExists: Boolean := false);
    method CreateSubfolder(SubfolderName: String; FailIfExists: Boolean := false): Folder;
    method Delete;
    method Rename(NewName: String): Folder;

    method GetFile(FileName: String): File;
    method GetFiles: not nullable List<File>;
    method GetSubfolders: not nullable List<Folder>;

    class method CreateFolder(FolderName: Folder; FailIfExists: Boolean := false): Folder;
    class method Exists(FolderName: Folder): Boolean;

    class method UserHomeFolder: Folder;

    class property Separator: Char read GetSeparator;

    {$IF WINDOWS_PHONE OR NETFX_CORE}
    property FullPath: not nullable String read mapped.Path;
    property Name: not nullable String read mapped.Name;
    {$ELSE}
    property FullPath: not nullable String read mapped;
    property Name: not nullable String read Sugar.IO.Path.GetFileName(mapped);
    {$ENDIF}
    property &Extension: not nullable String read Sugar.IO.Path.GetExtension(FullPath);
  end;

  {$IF COOPER OR NOUGAT}
  FolderHelper = public static class
  public
    {$IF COOPER}method DeleteFolder(Value: java.io.File);{$ENDIF}
    {$IF NOUGAT}method IsDirectory(Value: String): Boolean;{$ENDIF}
  end;
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  FolderHelper = public static class
  public
    method GetFile(Folder: Windows.Storage.StorageFolder; FileName: String): Windows.Storage.StorageFile;
    method GetFolder(Folder: Windows.Storage.StorageFolder; FolderName: String): Windows.Storage.StorageFolder;
  end;
  {$ENDIF}

  {$IF WINDOWS_PHONE OR NETFX_CORE}
  extension method Windows.Foundation.IAsyncOperation<TResult>.Await<TResult>: TResult;  
  {$ENDIF}


implementation

constructor Folder(aPath: not nullable String);
begin
  {$IF WINDOWS_PHONE OR NETFX_CORE}
  exit Windows.Storage.StorageFolder.GetFolderFromPathAsync(aPath).Await;
  {$ELSE}
  exit Folder(aPath);
  {$ENDIF}
end;

class method Folder.Exists(FolderName: Folder): Boolean;
begin
  result := FolderName.__Exists;
end;

method Folder.CreateSubfolder(SubfolderName: String; FailIfExists: Boolean := false): Folder;
begin
  result := new Folder(Sugar.IO.Path.Combine(self.FullPath, SubfolderName));
  result.CreateFolder(FailIfExists);
end;

class method Folder.CreateFolder(FolderName: Folder; FailIfExists: Boolean := false): Folder;
begin
  result := Folder(FolderName);
  result.CreateFolder(FailIfExists);
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

class method Folder.GetSeparator: Char;
begin
  exit '\';
end;

class method Folder.UserHomeFolder: Folder;
begin
  exit Windows.Storage.ApplicationData.Current.LocalFolder;
end;

method Folder.CreateFile(FileName: String; FailIfExists: Boolean := false): File;
begin
  exit mapped.CreateFileAsync(FileName, iif(FailIfExists, Windows.Storage.CreationCollisionOption.FailIfExists, Windows.Storage.CreationCollisionOption.OpenIfExists)).Await;
end;

method Folder.__Exists(): Boolean;
begin
  // WP8 API - best API
  try
    var item := Windows.Storage.ApplicationData.Current.LocalFolder.GetItemAsync(mapped.Name).Await();
    exit assigned(item);
  except
    exit false;
  end;
end;

method Folder.CreateFolder(FailIfExists: Boolean := false);
begin
  mapped.CreateFolderAsync(self.FullPath, iif(FailIfExists, Windows.Storage.CreationCollisionOption.FailIfExists, Windows.Storage.CreationCollisionOption.OpenIfExists)).Await();
end;

method Folder.Delete;
begin
  mapped.DeleteAsync.AsTask.Wait;
end;

method Folder.GetFile(FileName: String): File;
begin
  exit FolderHelper.GetFile(mapped, FileName);
end;

method Folder.GetFiles: not nullable List<File>;
begin
  var files := mapped.GetFilesAsync.Await;
  result := new List<File>();
  for i: Integer := 0 to files.Count-1 do
    result.Add(File(files.Item[i]));
end;

method Folder.GetSubfolders: not nullable List<Folder>;
begin
  var folders := mapped.GetFoldersAsync.Await;
  result := new List<Folder>();
  for i: Integer := 0 to folders.Count-1 do
    result.Add(Folder(folders.Item[i]));
end;

method Folder.Rename(NewName: String): Folder;
begin
  mapped.RenameAsync(NewName, Windows.Storage.NameCollisionOption.FailIfExists).AsTask().Wait();
end;

extension method Windows.Foundation.IAsyncOperation<TResult>.&Await<TResult>: TResult;
begin
  exit self.AsTask.Result;
end;
{$ELSEIF ECHOES}
class method Folder.GetSeparator: Char;
begin
  exit System.IO.Path.DirectorySeparatorChar;
end;

class method Folder.UserHomeFolder: Folder;
begin
  exit Folder(System.Environment.GetFolderPath(System.Environment.SpecialFolder.UserProfile));
end;

method Folder.CreateFile(FileName: String; FailIfExists: Boolean := false): File;
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

method Folder.__Exists: Boolean;
begin
  result := System.IO.Directory.Exists(mapped);
end;

method Folder.CreateFolder(FailIfExists: Boolean := false);
begin
  if System.IO.Directory.Exists(mapped) then begin
    if FailIfExists then
      raise new SugarIOException(ErrorMessage.FOLDER_EXISTS, mapped);
  end
  else begin
    System.IO.Directory.CreateDirectory(mapped);
  end;
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

method Folder.GetFiles: not nullable List<File>;
begin
  result := new List<File>(System.IO.Directory.GetFiles(mapped));
end;

method Folder.GetSubfolders: not nullable List<Folder>;
begin
  result := new List<Folder>(System.IO.Directory.GetDirectories(mapped));
end;

method Folder.Rename(NewName: String): Folder;
begin
  var TopLevel := System.IO.Path.GetDirectoryName(mapped);
  var FolderName := System.IO.Path.Combine(TopLevel, NewName);
  if System.IO.Directory.Exists(FolderName) then
    raise new SugarIOException(ErrorMessage.FOLDER_EXISTS, NewName);

  System.IO.Directory.Move(mapped, FolderName);
  result := FolderName;
end;
{$ELSEIF COOPER}
method Folder.CreateFile(FileName: String; FailIfExists: Boolean := false): File;
begin
  var lNewFile := new java.io.File(mapped, FileName);
  if lNewFile.exists then begin
    if FailIfExists then
      raise new SugarIOException(ErrorMessage.FILE_EXISTS, FileName);

    exit lNewFile.path;
  end
  else begin
    lNewFile.createNewFile;
  end;
  result := lNewFile.path;
end;

class method Folder.GetSeparator: Char;
begin
  exit java.io.File.separatorChar;
end;

class method Folder.UserHomeFolder: Folder;
begin
  {$IF ANDROID}
  SugarAppContextMissingException.RaiseIfMissing;
  exit Environment.ApplicationContext.FilesDir.AbsolutePath;
  {$ELSE}
  exit System.getProperty("user.home");
  {$ENDIF}
end;

method Folder.__Exists: Boolean;
begin
  result := JavaFile.exists;
end;

method Folder.CreateFolder(FailIfExists: Boolean := false);
begin
  var lFile := JavaFile;
  if lFile.exists then begin
    if FailIfExists then
      raise new SugarIOException(ErrorMessage.FOLDER_EXISTS, mapped);
    exit;
  end
  else begin
    if not lFile.mkdir then
      raise new SugarIOException(ErrorMessage.FOLDER_CREATE_ERROR, mapped);
  end;
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
  var lFile := JavaFile;
  if not lFile.exists then
    raise new SugarIOException(ErrorMessage.FOLDER_NOTFOUND, mapped);

  FolderHelper.DeleteFolder(lFile);
end;

method Folder.GetFile(FileName: String): File;
begin
  var ExistingFile := new java.io.File(mapped, FileName);
  if not ExistingFile.exists then
    exit nil;

  exit ExistingFile.path;
end;

method Folder.GetFiles: not nullable List<File>;
begin
  result := JavaFile.listFiles((f,n)->new java.io.File(f, n).isFile).Select(f->f.path).ToList() as not nullable;
end;

method Folder.GetSubfolders: not nullable List<Folder>;
begin
  result := JavaFile.listFiles( (f,n) -> new java.io.File(f, n).isDirectory).Select(f -> f.Path).ToList() as not nullable;
end;

method Folder.Rename(NewName: String): Folder;
begin
  var lFile := JavaFile;
  var NewFolder := new java.io.File(lFile.ParentFile, NewName);
  if NewFolder.exists then
    raise new SugarIOException(ErrorMessage.FOLDER_EXISTS, NewName);

  if not lFile.renameTo(NewFolder) then
    raise new SugarIOException(ErrorMessage.IO_RENAME_ERROR, mapped, NewName);

  result := NewName;
end;
{$ELSEIF NOUGAT}
method Folder.CreateFile(FileName: String; FailIfExists: Boolean := false): File;
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

class method Folder.GetSeparator: Char;
begin
  exit '/';
end;

class method Folder.UserHomeFolder: Folder;
begin
  result := NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.NSApplicationSupportDirectory, NSSearchPathDomainMask.NSUserDomainMask, true).objectAtIndex(0);

  if not NSFileManager.defaultManager.fileExistsAtPath(result) then begin
    var lError: NSError := nil;
    if not NSFileManager.defaultManager.createDirectoryAtPath(result) withIntermediateDirectories(false) attributes(nil) error(var lError) then
      raise new SugarNSErrorException(lError);
  end;
end;

method Folder.__Exists: Boolean;
begin
  var isDirectory := false;
  result := NSFileManager.defaultManager.fileExistsAtPath(self) isDirectory(var isDirectory) and isDirectory;
end;

method Folder.CreateFolder(FailIfExists: Boolean := false);
begin
  var isDirectory := false;
  if NSFileManager.defaultManager.fileExistsAtPath(mapped) isDirectory(var isDirectory) then begin
    if isDirectory and FailIfExists then
      raise new SugarIOException(ErrorMessage.FOLDER_EXISTS, mapped);
    if not isDirectory then
      raise new SugarIOException(ErrorMessage.FILE_EXISTS, mapped);
  end
  else begin
    var lError: NSError := nil;
    if not NSFileManager.defaultManager.createDirectoryAtPath(mapped) withIntermediateDirectories(false) attributes(nil) error(var lError) then
      raise new SugarNSErrorException(lError);
  end;
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

method Folder.GetFiles: not nullable List<File>;
begin
  result := new List<File>;
  var Items := NSFileManager.defaultManager.contentsOfDirectoryAtPath(mapped) error(nil);
  if Items = nil then
    exit;

  for i: Integer := 0 to Items.count - 1 do begin
    var item := Combine(mapped, Items.objectAtIndex(i));
    if not FolderHelper.IsDirectory(item) then
      result.Add(File(item));
  end;
end;

method Folder.GetSubfolders: not nullable List<Folder>;
begin
  result := new List<Folder>();

  var Items := NSFileManager.defaultManager.contentsOfDirectoryAtPath(mapped) error(nil);
  if Items = nil then
    exit;

  for i: Integer := 0 to Items.count - 1 do begin
    var item := Combine(mapped, Items.objectAtIndex(i));
    if FolderHelper.IsDirectory(item) then
      result.Add(Folder(item));
  end;
end;

method Folder.Rename(NewName: String): Folder;
begin
  var RootFolder := mapped.stringByDeletingLastPathComponent;
  var NewFolderName := Combine(RootFolder, NewName);
  var Manager := NSFileManager.defaultManager;

  if Manager.fileExistsAtPath(NewFolderName) then
    raise new SugarIOException(ErrorMessage.FOLDER_EXISTS, NewName);

  var lError: NSError := nil; 
  if not Manager.moveItemAtPath(mapped) toPath(NewFolderName) error(var lError) then
    raise new SugarNSErrorException(lError);

  result := NewFolderName;
end;

method Folder.Combine(BasePath: String; SubPath: String): String;
begin
  result := NSString(BasePath):stringByAppendingPathComponent(SubPath);
end;
{$ENDIF}

end.
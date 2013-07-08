namespace RemObjects.Oxygene.Sugar.IO;

interface

{$HIDE W0} //supress case-mismatch errors

uses
  {$IF WINDOWS_PHONE OR NETFX_CORE}  
  System.IO,
  {$ELSEIF COOPER}
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
  RemObjects.Oxygene.Sugar,
  RemObjects.Oxygene.Sugar.Collections;

type
  Folder = public class mapped to {$IF WINDOWS_PHONE OR NETFX_CORE}Windows.Storage.StorageFolder{$ELSEIF ECHOES}System.String{$ELSEIF COOPER}java.io.File{$ELSEIF NOUGAT}NSMutableString{$ENDIF}
  private
  {$IF ECHOES}
    method GetName: String;
  {$ELSEIF NOUGAT}
    method IsDirectory(aPath: String): Boolean;
    method Combine(BasePath: String; SubPath: String): String;
  {$ENDIF}
  public
    method CreateFile(FileName: String; FailIfExists: Boolean): File;
    method CreateFolder(FolderName: String; FailIfExists: Boolean): Folder;
    method Delete;
    method GetFile(FileName: String): File;
    method GetFiles: array of File;
    method GetFolder(FolderName: String): Folder;
    method GetFolders: array of Folder;
    method Rename(NewName: String);

    class method FromPath(Value: String): Folder;

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

  {$IF WINDOWS_PHONE OR NETFX_CORE}
  extension method Windows.Foundation.IAsyncOperation<TResult>.Await<TResult>: TResult;  
  {$ENDIF}

implementation

{$IF WINDOWS_PHONE OR NETFX_CORE}
method Folder.GetName: String;
begin

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
  exit mapped.GetFileAsync(FileName).Await;
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
  exit mapped.GetFolderAsync(FolderName).Await;
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

class method Folder.FromPath(Value: String): Folder;
begin
  exit Windows.Storage.StorageFolder.GetFolderFromPathAsync(Value).Await;
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

method Folder.CreateFile(FileName: String; FailIfExists: Boolean): File;
begin
  var NewFileName := System.IO.Path.Combine(mapped, FileName);

  if System.IO.File.Exists(NewFileName) then begin
    if FailIfExists then
      raise new SugarIOException(String.Format(ErrorMessage.FILE_EXISTS, FileName));

    exit NewFileName;
  end;

  var fs := System.IO.File.Create(NewFileName);
  fs.Close;
  exit NewFileName;
end;

method Folder.CreateFolder(FolderName: String; FailIfExists: Boolean): Folder;
begin
  var NewFolderName := System.IO.Path.Combine(mapped, FolderName);

  if System.IO.File.Exists(NewFolderName) then begin
    if FailIfExists then
      raise new SugarIOException(String.Format(ErrorMessage.FOLDER_EXISTS, FolderName));

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
    raise new SugarIOException("Folder "+NewName+" already exists");

  System.IO.Directory.Move(mapped, FolderName);
  mapped := FolderName;
end;

class method Folder.FromPath(Value: String): Folder;
begin
  if not System.IO.Directory.Exists(Value) then
    raise new SugarIOException(String.Format("Folder {0} not found", Value));
 
  exit Folder(Value);
end;
{$ELSEIF COOPER}
method Folder.CreateFile(FileName: String; FailIfExists: Boolean): File;
begin
  var NewFile := new java.io.File(mapped, FileName);
  if NewFile.exists then begin
    if FailIfExists then
      raise new SugarIOException(String.Format("File {0} already exists", FileName));

    exit NewFile;
  end;

  NewFile.createNewFile;
  exit NewFile;
end;

method Folder.CreateFolder(FolderName: String; FailIfExists: Boolean): Folder;
begin
  var NewFolder := new java.io.File(mapped, FolderName);
  if NewFolder.exists then begin
    if FailIfExists then
      raise new SugarIOException(String.Format("Folder {0} already exists", FolderName));

    exit NewFolder;
  end;

  NewFolder.mkdir;
  exit NewFolder;
end;

method Folder.Delete;
begin
  mapped.delete;
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
  exit mapped.listFiles;
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
  var Folders := mapped.list((f,n)->new java.io.File(f, n).isDirectory);
  result := new Folder[Folders.length];
  for i: Integer := 0 to Folders.length-1 do begin
    result[i] := new java.io.File(mapped, Folders[i]);
  end;
end;

method Folder.Rename(NewName: String);
begin
  var NewFolder := new java.io.File(mapped, NewName);
  if NewFolder.exists then
    raise new SugarIOException(String.Format("Folder {0} already exists", NewName));

  mapped.renameTo(NewFolder);
end;

class method Folder.FromPath(Value: String): Folder;
begin
  var lFile := new java.io.File(Value);
  if not lFile.exists then
    raise new SugarIOException(String.Format("Folder {0} not found", Value));
  exit Folder(lFile);
end;
{$ELSEIF NOUGAT}
method Folder.CreateFile(FileName: String; FailIfExists: Boolean): File;
begin
  var NewFileName := Combine(mapped, FileName);
  var Manager := NSFileManager.defaultManager;
  if Manager.fileExistsAtPath(NewFileName) then begin
    if FailIfExists then
      raise new SugarIOException(String.Format(ErrorMessage.FILE_EXISTS, FileName));

    exit File(NewFileName);
  end;

  Manager.createFileAtPath(NewFileName) contents(nil) attributes(nil);
  exit File(NewFileName);
end;

method Folder.CreateFolder(FolderName: String; FailIfExists: Boolean): Folder;
begin
  var NewFolderName := Combine(mapped, FolderName);
  var Manager := NSFileManager.defaultManager;
  if Manager.fileExistsAtPath(NewFolderName) then begin
    if FailIfExists then
      raise new SugarIOException(String.Format(ErrorMessage.FOLDER_EXISTS, FolderName));

    exit Folder(NewFolderName);
  end;

  Manager.createDirectoryAtPath(NewFolderName) attributes(nil);
  exit Folder(NewFolderName);
end;

method Folder.Delete;
begin
  var lError: NSError := nil;
  if not NSFileManager.defaultManager.removeItemAtPath(mapped) error(var lError) then
    raise SugarNSErrorException.exceptionWithError(lError);
end;

method Folder.GetFile(FileName: String): File;
begin
  var ExistingFileName := Combine(mapped, FileName);
  if not NSFileManager.defaultManager.fileExistsAtPath(ExistingFileName) then
    exit nil;

  exit File(ExistingFileName);
end;

method Folder.IsDirectory(aPath: String): Boolean;
begin
  Foundation.NSFileManager.defaultManager.fileExistsAtPath(aPath) isDirectory(@Result);
end;

method Folder.GetFiles: array of File;
begin
  var Items := NSFileManager.defaultManager.contentsOfDirectoryAtPath(mapped) error(nil);
  if Items = nil then
    exit new File[0];

  var Files := new List<File>;
  for i: Integer := 0 to Items.count - 1 do begin
    var item := Items.objectAtIndex(i);
    if not IsDirectory(item) then
      Files.Add(item);
  end;

  exit Files.ToArray;
end;

method Folder.GetFolder(FolderName: String): Folder;
begin
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
    var item := Items.objectAtIndex(i);
    if IsDirectory(item) then
      Folders.Add(item);
  end;

  exit Folders.ToArray;
end;

method Folder.Rename(NewName: String);
begin
  var RootFolder := mapped.stringByDeletingLastPathComponent;
  var NewFolderName := Combine(RootFolder, NewName);
  var Manager := NSFileManager.defaultManager;

  if Manager.fileExistsAtPath(NewFolderName) then
    raise new SugarIOException(String.Format(ErrorMessage.FOLDER_EXISTS, NewName));

  var lError: NSError := nil; 
  if not Manager.moveItemAtPath(mapped) toPath(NewFolderName) error(var lError) then
    raise SugarNSErrorException.exceptionWithError(lError);
end;

method Folder.Combine(BasePath: String; SubPath: String): String;
begin
  result := NSString(BasePath):stringByAppendingPathComponent(SubPath);
end;

class method Folder.FromPath(Value: String): Folder;
begin
  if not NSFileManager.defaultManager.fileExistsAtPath(Value) then
    raise new SugarIOException(String.Format("Folder {0} not found", Value));
 
  exit Folder(Value);
end;
{$ENDIF}

end.

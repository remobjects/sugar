namespace Sugar.IO;

interface

uses
  {$IF WINDOWS_PHONE OR NETFX_CORE}
  Windows.Storage,
  {$ENDIF}
  Sugar;

{$HIDE W37}

type
  [Obsolete("Use Folder instead")]
  FolderUtils = public static class
  private
    {$IF COOPER}
    method RecursiveDelete(Item: java.io.File);
    method ListItems(FolderName: java.io.File; AllFolders: Boolean; FilesOnly: Boolean): array of String;
    {$ELSEIF NOUGAT}
    method ListItems(FolderName: String; AllFolders: Boolean; FilesOnly: Boolean): array of String;
    {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
    method GetFolder(FolderName: String): StorageFolder;
    {$ENDIF}
  public
    method &Create(FolderName: String);
    method Delete(FolderName: String);
    method Exists(FolderName: String): Boolean;
    method GetFiles(FolderName: String; AllFolders: Boolean := false): array of String;
    method GetFolders(FolderName: String; AllFolders: Boolean := false): array of String;
  end;

implementation

{$IF WINDOWS_PHONE OR NETFX_CORE}
class method FolderUtils.GetFolder(FolderName: String): StorageFolder;
begin
  exit StorageFolder.GetFolderFromPathAsync(FolderName).Await;
end;
{$ENDIF}

class method FolderUtils.Create(FolderName: String);
begin
  if Exists(FolderName) then
    raise new SugarIOException(ErrorMessage.FOLDER_EXISTS, FolderName);

  {$IF COOPER}  
  if not (new java.io.File(FolderName).mkdir) then
    raise new SugarIOException(ErrorMessage.FOLDER_CREATE_ERROR, FolderName);
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  var ParentFolder := GetFolder(Path.GetParentDirectory(FolderName));
  FolderName := Path.GetFileName(FolderName);
  ParentFolder.CreateFolderAsync(FolderName, CreationCollisionOption.FailIfExists).Await;
  {$ELSEIF ECHOES}
  System.IO.Directory.CreateDirectory(FolderName);
  {$ELSEIF NOUGAT}
  var lError: NSError := nil;
  if not NSFileManager.defaultManager.createDirectoryAtPath(FolderName) withIntermediateDirectories(false) attributes(nil) error(var lError) then
    raise new SugarNSErrorException(lError);
  {$ENDIF}
end;

{$IF COOPER}
class method FolderUtils.RecursiveDelete(Item: java.io.File);
begin
  if Item.isDirectory then begin
    var Items := Item.list;
    for Element in Items do
      RecursiveDelete(new java.io.File(Item, Element));
  end;

  if not Item.delete then
    raise new SugarIOException(ErrorMessage.FOLDER_DELETE_ERROR, Item.Name);  
end;
{$ENDIF}

class method FolderUtils.Delete(FolderName: String);
begin
  if not Exists(FolderName) then
    raise new SugarIOException(ErrorMessage.FOLDER_NOTFOUND, FolderName);

  {$IF COOPER}  
  RecursiveDelete(new java.io.File(FolderName));
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE} 
  GetFolder(FolderName).DeleteAsync.AsTask.Wait;  
  {$ELSEIF ECHOES}
  System.IO.Directory.Delete(FolderName, true);
  {$ELSEIF NOUGAT}
  var lError: NSError := nil;
  if not NSFileManager.defaultManager.removeItemAtPath(FolderName) error(var lError) then
    raise new SugarNSErrorException(lError);
  {$ENDIF}
end;

class method FolderUtils.Exists(FolderName: String): Boolean;
begin
  SugarArgumentNullException.RaiseIfNil(FolderName, "FolderName");

  {$IF COOPER}  
  var lFile := new java.io.File(FolderName);
  exit lFile.exists and lFile.isDirectory;
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}  
  try
    exit GetFolder(FolderName) <> nil;
  except
    exit false;
  end;
  {$ELSEIF ECHOES}
  exit System.IO.Directory.Exists(FolderName);
  {$ELSEIF NOUGAT}
  var RetVal: Boolean := false;
  result := NSFileManager.defaultManager.fileExistsAtPath(FolderName) isDirectory(@RetVal) and RetVal;
  {$ENDIF}
end;

{$IF COOPER}
class method FolderUtils.ListItems(FolderName: java.io.File; AllFolders: Boolean; FilesOnly: Boolean): array of String;
begin
  var Elements := FolderName.listFiles;
  var Items := new Sugar.Collections.List<String>;

  for Element in Elements do begin
    if (FilesOnly and Element.isFile) or ((not FilesOnly) and Element.isDirectory) then
      Items.Add(Element.AbsolutePath);

    if AllFolders then
      Items.AddRange(ListItems(Element, AllFolders, FilesOnly));
  end;

  exit Items.ToArray;
end;
{$ELSEIF NOUGAT}
class method FolderUtils.ListItems(FolderName: String; AllFolders: Boolean; FilesOnly: Boolean): array of String;
begin
  var Enumerator := NSFileManager.defaultManager.enumeratorAtPath(FolderName);
  var Item: NSString := Enumerator.nextObject;
  var Items := new Sugar.Collections.List<String>;

  while Item <> nil do begin

    if (not AllFolders) and (Enumerator.level <> 1) then
      break;

    var IsDir: Boolean := false;
    Item := Path.Combine(FolderName, Item);
    NSFileManager.defaultManager.fileExistsAtPath(Item) isDirectory(@IsDir);

    if (FilesOnly and (not IsDir)) or ((not FilesOnly) and IsDir) then
      Items.Add(Item);

    Item := Enumerator.nextObject;
  end;

  exit Items.ToArray;
end;
{$ENDIF}

class method FolderUtils.GetFiles(FolderName: String; AllFolders: Boolean): array of String;
begin
  if not Exists(FolderName) then
    raise new SugarIOException(ErrorMessage.FOLDER_NOTFOUND, FolderName);

  {$IF COOPER}
  exit ListItems(new java.io.File(FolderName), AllFolders, true);
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  var Items := new Sugar.Collections.List<String>;

  if AllFolders then begin
    Items.AddRange(GetFiles(FolderName, false));
    var Folders := GetFolders(FolderName, true);
    for i: Integer := 0 to Folders.Length - 1 do
      Items.AddRange(GetFiles(Folders[i], false));
  end
  else begin
    var Files := GetFolder(FolderName).GetFilesAsync.Await;
    for i: Integer := 0 to Files.Count - 1 do
      Items.Add(Files.Item[i].Path);
  end;

  exit Items.ToArray;
  {$ELSEIF ECHOES}
  exit System.IO.Directory.GetFiles(FolderName, "*", iif(AllFolders, System.IO.SearchOption.AllDirectories, System.IO.SearchOption.TopDirectoryOnly));
  {$ELSEIF NOUGAT}
  exit ListItems(FolderName, AllFolders, true);
  {$ENDIF}
end;

class method FolderUtils.GetFolders(FolderName: String; AllFolders: Boolean): array of String;
begin
  if not Exists(FolderName) then
    raise new SugarIOException(ErrorMessage.FOLDER_NOTFOUND, FolderName);

  {$IF COOPER}
  exit ListItems(new java.io.File(FolderName), AllFolders, false);
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  var lFolder := GetFolder(FolderName);
  var Folders := lFolder.GetFoldersAsync.Await;
  var Items := new Sugar.Collections.List<String>;

  for i: Integer := 0 to Folders.Count - 1 do begin
    Items.Add(Folders.Item[i].Path);
    if AllFolders then
      Items.AddRange(GetFolders(Folders.Item[i].Path, AllFolders));
  end;

  exit Items.ToArray;  
  {$ELSEIF ECHOES}
  exit System.IO.Directory.GetDirectories(FolderName, "*", iif(AllFolders, System.IO.SearchOption.AllDirectories, System.IO.SearchOption.TopDirectoryOnly));
  {$ELSEIF NOUGAT}
  exit ListItems(FolderName, AllFolders, false);
  {$ENDIF}
end;

end.

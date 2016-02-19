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
  File = public class mapped to {$IF WINDOWS_PHONE OR NETFX_CORE}Windows.Storage.StorageFile{$ELSEIF ECHOES}System.String{$ELSEIF COOPER}java.lang.String{$ELSEIF NOUGAT}NSString{$ENDIF}
  private    
    {$IF COOPER}
    property JavaFile: java.io.File read new java.io.File(mapped);
    {$ENDIF}
  public
    constructor(aPath: String);

    method &Copy(NewPathAndName: File): File;
    method &Copy(Destination: Folder; NewName: String): File;
    method Delete;
    method Exists: Boolean; inline;
    method Move(NewPathAndName: File): File;
    method Move(DestinationFolder: Folder; NewName: String): File;
    method Open(Mode: FileOpenMode): FileHandle;
    method Rename(NewName: String): File;

    class method Exists(FileName: File): Boolean; inline;

    {$IF WINDOWS_PHONE OR NETFX_CORE}
    property FullPath: String read mapped.Path;
    property Name: String read mapped.Name;
    {$ELSE}
    property FullPath: String read mapped;
    property Name: String read Sugar.IO.Path.GetFileName(mapped);
    {$ENDIF}
    property &Extension: String read Sugar.IO.Path.GetExtension(FullPath);
    
    method ReadText(Encoding: Encoding := nil): String;
    method ReadBytes: array of Byte;
    method ReadBinary: Binary;
  end;

implementation

constructor File(aPath: String);
begin
  SugarArgumentNullException.RaiseIfNil(aPath, "Path");

  if not FileUtils.Exists(aPath) then
    raise new SugarFileNotFoundException(aPath);

  {$IF WINDOWS_PHONE OR NETFX_CORE}
  exit StorageFile.GetFileFromPathAsync(aPath).Await;
  {$ELSE}
  exit File(aPath);
  {$ENDIF}
end;

method File.&Copy(NewPathAndName: File): File;
begin
  exit &Copy(Sugar.IO.Path.GetParentDirectory(NewPathAndName), Sugar.IO.Path.GetFileName(NewPathAndName));
end;

method File.&Copy(Destination: Folder; NewName: String): File;
begin
  SugarArgumentNullException.RaiseIfNil(Destination, "Destination");
  SugarArgumentNullException.RaiseIfNil(NewName, "NewName");

  {$IF WINDOWS_PHONE OR NETFX_CORE}
  result := mapped.CopyAsync(Destination, NewName, NameCollisionOption.FailIfExists).Await;
  {$ELSE}
  var lNewFile := File(Sugar.IO.Path.Combine(Destination, NewName));
  if lNewFile.Exists then
    raise new SugarIOException(ErrorMessage.FILE_EXISTS, NewName);

  {$IF COOPER}  
  new java.io.File(lNewFile).createNewFile;
  var source := new java.io.FileInputStream(mapped).Channel;
  var dest := new java.io.FileOutputStream(lNewFile).Channel;
  dest.transferFrom(source, 0, source.size);

  source.close;
  dest.close;
  {$ELSEIF ECHOES}
  System.IO.File.Copy(mapped, lNewFile);
  {$ELSEIF NOUGAT}
  var lError: Foundation.NSError := nil;
  if not NSFileManager.defaultManager.copyItemAtPath(mapped) toPath(lNewFile) error(var lError) then
    raise new SugarNSErrorException(lError);
  {$ENDIF}
  result := lNewFile;
  {$ENDIF}
end;

method File.Delete;
begin
  if not Exists then
    raise new SugarFileNotFoundException(self.FullPath);
  {$IF COOPER}  
  JavaFile.delete;
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  mapped.DeleteAsync.AsTask.Wait;
  {$ELSEIF ECHOES}
  System.IO.File.Delete(mapped);
  {$ELSEIF NOUGAT}
  var lError: NSError := nil;
  if not NSFileManager.defaultManager.removeItemAtPath(mapped) error(var lError) then
    raise new SugarNSErrorException(lError);
  {$ENDIF}
end;

method File.Exists: Boolean;
begin
  result := FileUtils.Exists(mapped);
end;

class method File.Exists(FileName: File): Boolean;
begin
  result := FileUtils.Exists(FileName);
end;

method File.Move(NewPathAndName: File): File;
begin
  if NewPathAndName.Exists then
    raise new SugarIOException(ErrorMessage.FILE_EXISTS, NewPathAndName);
  {$IF COOPER}  
  var lNewFile := &Copy(NewPathAndName);
  JavaFile.delete;
  exit lNewFile;
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  result := mapped.CopyAsync(Destination, NewPathAndName, NameCollisionOption.FailIfExists).Await;
  {$ELSEIF ECHOES}
  System.IO.File.Move(mapped, NewPathAndName);
  result :=  NewPathAndName;
  {$ELSEIF NOUGAT}
  var lError: Foundation.NSError := nil;
  if not NSFileManager.defaultManager.moveItemAtPath(mapped) toPath(NewPathAndName) error(var lError) then
    raise new SugarNSErrorException(lError);
  result := NewPathAndName
  {$ENDIF}
end;

method File.Move(DestinationFolder: Folder; NewName: String): File;
begin
  result := Move(Sugar.IO.Path.Combine(DestinationFolder, NewName));
end;

method File.Rename(NewName: String): File;
begin  
  var lNewFile := Path.Combine(Path.GetParentDirectory(mapped), NewName);
  result := Move(lNewFile);
end;

method File.Open(Mode: FileOpenMode): FileHandle;
begin
  if not Exists then
    raise new SugarFileNotFoundException(self.FullPath);

  exit FileHandle.FromFile(mapped, Mode);
end;

method File.ReadText(Encoding: Encoding := nil): String;
begin
  result := FileUtils.ReadText(mapped, Encoding);
end;

method File.ReadBytes: array of Byte;
begin
  result := FileUtils.ReadBytes(mapped);
end;

method File.ReadBinary: Binary;
begin
  result := FileUtils.ReadBinary(mapped);
end;

end.

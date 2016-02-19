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
    constructor(aPath: not nullable String);

    method &Copy(NewPathAndName: not nullable File): not nullable File;
    method &Copy(Destination: not nullable Folder; NewName: not nullable String): not nullable File;
    method Delete;
    method Exists: Boolean; inline;
    method Move(NewPathAndName: not nullable File): not nullable File;
    method Move(DestinationFolder: not nullable Folder; NewName: not nullable String): not nullable File;
    method Open(Mode: FileOpenMode): not nullable FileHandle;
    method Rename(NewName: not nullable String): not nullable File;

    class method Exists(FileName: not nullable File): Boolean; inline;

    {$IF WINDOWS_PHONE OR NETFX_CORE}
    property FullPath: not nullable String read mapped.Path;
    property Name: not nullable String read mapped.Name;
    {$ELSE}
    property FullPath: not nullable String read mapped;
    property Name: not nullable String read Sugar.IO.Path.GetFileName(mapped);
    {$ENDIF}
    property &Extension: not nullable String read Sugar.IO.Path.GetExtension(FullPath);
    
    method ReadText(Encoding: Encoding := nil): String;
    method ReadBytes: array of Byte;
    method ReadBinary: Binary;
  end;

implementation

constructor File(aPath: not nullable String);
begin
  {$IF WINDOWS_PHONE OR NETFX_CORE}
  exit StorageFile.GetFileFromPathAsync(aPath).Await;
  {$ELSE}
  exit File(aPath);
  {$ENDIF}
end;

method File.&Copy(NewPathAndName: not nullable File): not nullable File;
begin
  exit &Copy(Sugar.IO.Path.GetParentDirectory(NewPathAndName), Sugar.IO.Path.GetFileName(NewPathAndName));
end;

method File.&Copy(Destination: not nullable Folder; NewName: not nullable String): not nullable File;
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
  result := lNewFile as not nullable;
  {$ENDIF}
end;

method File.Delete;
begin
  if not Exists then
    raise new SugarFileNotFoundException(FullPath);
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

class method File.Exists(FileName: not nullable File): Boolean;
begin
  result := FileUtils.Exists(FileName);
end;

method File.Move(NewPathAndName: not nullable File): not nullable File;
begin
  if NewPathAndName.Exists then
    raise new SugarIOException(ErrorMessage.FILE_EXISTS, NewPathAndName);
  {$IF COOPER}  
  result := &Copy(NewPathAndName) as not nullable;
  JavaFile.delete;
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

method File.Move(DestinationFolder: not nullable Folder; NewName: not nullable String): not nullable File;
begin
  result := Move(Sugar.IO.Path.Combine(DestinationFolder, NewName));
end;

method File.Rename(NewName: not nullable String): not nullable File;
begin  
  var lNewFile := Path.Combine(Path.GetParentDirectory(mapped), NewName);
  result := Move(lNewFile);
end;

method File.Open(Mode: FileOpenMode): not nullable FileHandle;
begin
  if not Exists then
    raise new SugarFileNotFoundException(FullPath);

  exit FileHandle.FromFile(mapped, Mode) as not nullable;
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

namespace RemObjects.Oxygene.Sugar.IO;

interface

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
  File = public class mapped to {$IF WINDOWS_PHONE OR NETFX_CORE}Windows.Storage.StorageFile{$ELSEIF ECHOES}System.String{$ELSEIF COOPER}java.io.File{$ELSEIF NOUGAT}NSMutableString{$ENDIF}
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
    method Move(Destination: Folder);
    method Move(Destination: Folder; NewName: String);
    method Rename(NewName: String);

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

implementation

{$IF WINDOWS_PHONE OR NETFX_CORE}
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

method File.Move(Destination: Folder);
begin
  Move(Destination, mapped.Name);
end;

method File.Move(Destination: Folder; NewName: String);
begin
  mapped.MoveAsync(Destination, NewName, Windows.Storage.NameCollisionOption.FailIfExists).AsTask.Wait;
end;

method File.Rename(NewName: String);
begin
  mapped.RenameAsync(NewName, Windows.Storage.NameCollisionOption.FailIfExists).AsTask.Wait;
end;

method File.AppendText(Content: String);
begin
  var Stream := mapped.OpenStreamForWriteAsync.Result;
  var data := System.Text.Encoding.UTF8.GetBytes(Content);
  Stream.Seek(0, SeekOrigin.End);
  Stream.Write(data, 0, data.Length);
  Stream.Flush;
  Stream.Dispose;
end;

method File.ReadBytes: array of Byte;
begin
  var stream := mapped.OpenStreamForReadAsync.Result;
  result := new Byte[stream.Length];
  stream.Read(result, 0, stream.Length);
  stream.Dispose;
end;

method File.ReadText: String;
begin
  var data := ReadBytes;
  exit System.Text.Encoding.UTF8.GetString(data, 0, data.Length);
end;

method File.WriteBytes(Data: array of Byte);
begin
  var Stream := mapped.OpenStreamForWriteAsync.Result;
  Stream.SetLength(0);
  Stream.Write(Data, 0, Data.Length);
  Stream.Flush;
  Stream.Dispose;
end;

method File.WriteText(Content: String);
begin
  var data := System.Text.Encoding.UTF8.GetBytes(Content);
  WriteBytes(data);
end;
{$ELSEIF ECHOES}
method File.GetName: String;
begin
  exit System.IO.Path.GetFileName(mapped);
end;

method File.&Copy(Destination: Folder): File;
begin
  &Copy(Destination, GetName);
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
  System.IO.File.Delete(mapped);
end;

method File.Move(Destination: Folder);
begin
  Move(Destination, GetName);
end;

method File.Move(Destination: Folder; NewName: String);
begin
  var NewFile := System.IO.Path.Combine(Destination, NewName);
  if System.IO.File.Exists(NewFile) then
    raise new SugarIOException("File "+NewName+" already exists");

  System.IO.File.Move(mapped, NewFile);
  mapped := NewFile;
end;

method File.Rename(NewName: String);
begin
  Move(System.IO.Path.GetDirectoryName(mapped), NewName);
end;

method File.AppendText(Content: String);
begin
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
  System.IO.File.WriteAllText(mapped, Content);
end;
{$ELSEIF COOPER}
method File.&Copy(Destination: Folder): File;
begin
  exit &Copy(Destination, mapped.Name);
end;

method File.&Copy(Destination: Folder; NewName: String): File;
begin
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
  mapped.delete;
end;

method File.Move(Destination: Folder);
begin
  Move(Destination, mapped.Name);  
end;

method File.Move(Destination: Folder; NewName: String);
begin
  var NewFile := &Copy(Destination, NewName);
  mapped.delete;
  mapped := NewFile;
end;

method File.Rename(NewName: String);
begin
  var NewFile := new java.io.File(mapped, NewName);
  if NewFile.exists then
    raise new SugarIOException(String.Format("File {0} already exists", NewName));

  mapped.renameTo(NewFile);
end;

method File.AppendText(Content: String);
begin
  var writer := new java.io.FileWriter(mapped, true);
  writer.write(Content);
  writer.close;
end;

method File.ReadBytes: array of Byte;
begin
  result := new Byte[Integer(mapped.length)];
  var stream := new java.io.DataInputStream(new java.io.FileInputStream(mapped));
  stream.readFully(result);
  stream.close;
end;

method File.ReadText: String;
begin
  var fileContents := new java.lang.StringBuilder(Integer(mapped.length));
  var scanner := new java.util.Scanner(mapped);
  var lineSeparator := System.getProperty('line.separator');

  while scanner.hasNextLine do 
  begin  
    fileContents.append(scanner.nextLine);
    fileContents.append(lineSeparator);
  end;
  scanner.close;
  exit fileContents.toString;
end;

method File.WriteBytes(Data: array of Byte);
begin
  var stream := new java.io.FileOutputStream(mapped);
  stream.write(Data);
  stream.close;
end;

method File.WriteText(Content: String);
begin
  var writer := new java.io.FileWriter(mapped, false);
  writer.write(Content);
  writer.close;  
end;
{$ELSEIF NOUGAT}
method File.Combine(BasePath: String; SubPath: String): String;
begin
  result := NSString(BasePath):stringByAppendingPathComponent(SubPath);
end;

method File.&Copy(Destination: Folder): File;
begin
  &Copy(Destination, Name);
end;

method File.&Copy(Destination: Folder; NewName: String): File;
begin
  var NewFile := Combine(String(Destination), NewName);
  var Manager := NSFileManager.defaultManager;

  if Manager.fileExistsAtPath(NewFile) then
    raise new SugarIOException(String.Format(ErrorMessage.FILE_EXISTS, NewName));

  var lError: Foundation.NSError := nil;
  if not Manager.copyItemAtPath(mapped) toPath(NewFile) error(var lError) then
    raise SugarNSErrorException.exceptionWithError(lError); 

  exit File(NewFile);
end;

method File.Delete;
begin
  var lError: NSError := nil;
  if not NSFileManager.defaultManager.removeItemAtPath(mapped) error(var lError) then
    raise SugarNSErrorException.exceptionWithError(lError);
end;

method File.Move(Destination: Folder);
begin
  Move(Destination, Name);
end;

method File.Move(Destination: Folder; NewName: String);
begin
  var NewFile := Combine(String(Destination), NewName);
  var Manager := NSFileManager.defaultManager;

  if Manager.fileExistsAtPath(NewFile) then
    raise new SugarIOException(String.Format(ErrorMessage.FILE_EXISTS, NewName));

  var lError: Foundation.NSError := nil;
  if not Manager.moveItemAtPath(mapped) toPath(NewFile) error(var lError) then
    raise SugarNSErrorException.exceptionWithError(lError); 

  mapped := File(NewFile);
end;

method File.Rename(NewName: String);
begin
  var CurrentFolder := NSString(mapped).stringByDeletingLastPathComponent;
  Move(Folder(CurrentFolder), NewName);
end;

method File.AppendText(Content: String);
begin
  var lData := NSString(Content).dataUsingEncoding(NSStringEncoding.NSUTF8StringEncoding);
  var fileHandle := NSFileHandle.fileHandleForWritingAtPath(mapped);
  fileHandle.seekToEndOfFile;
  fileHandle.writeData(lData);
  fileHandle.closeFile;
end;

method File.ReadBytes: array of Byte;
begin
  var lError: Foundation.NSError := nil;
  var lData := NSData.dataWithContentsOfFile(mapped) options(NSDataReadingOptions.NSDataReadingMappedIfSafe) error(var lError);
  if not assigned(lData) then 
    raise SugarNSErrorException.exceptionWithError(lError); 

  result := new Byte[lData.length];
  lData.getBytes(result) length(lData.length);
end;

method File.ReadText: String;
begin
  var lError: Foundation.NSError := nil;
  result := Foundation.NSString.stringWithContentsOfFile(mapped) encoding(NSStringEncoding.NSUTF8StringEncoding) error(var lError);
  if not assigned(result) then 
    raise SugarNSErrorException.exceptionWithError(lError); 
end;

method File.WriteBytes(Data: array of Byte);
begin
  var lData := NSData.dataWithBytesNoCopy(^Void(Data)) length(length(Data));
  if not lData:writeToFile(mapped) atomically(true) then
    raise new SugarIOException("Failed to write data to a file");
end;

method File.WriteText(Content: String);
begin
  var lError: Foundation.NSError := nil;
  if not NSString(Content):writeToFile(mapped) atomically(true) encoding(NSStringEncoding.NSUTF8StringEncoding) error(var lError) then
    raise SugarNSErrorException.exceptionWithError(lError); 
end;
{$ENDIF}

end.

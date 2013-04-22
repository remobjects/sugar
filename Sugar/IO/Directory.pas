namespace RemObjects.Oxygene.Sugar.IO;

interface

uses
  RemObjects.Oxygene.Sugar;

type
{$IF ECHOES}
  Directory = public class mapped to System.IO.Directory
  {$IF WINDOWS_PHONE}
    class method GetFilesRecursive(Path: String; List: System.Collections.Generic.List<String>);
  {$ENDIF}
  public
    class method CreateDirectory(Path: String); mapped to CreateDirectory(Path);
    class method Delete(Path: String); mapped to Delete(Path);
    class method Delete(Path: String; Recursive: Boolean); mapped to Delete(Path, Recursive);
    class method Exists(Path: String): Boolean; mapped to Exists(Path);
    class method GetCurrentDirectory: String; mapped to GetCurrentDirectory;    
    class method GetFiles(Path: String; Recursive: Boolean): array of String;
    class method Move(SourceDirName: String; DestDirName: String); mapped to Move(SourceDirName, DestDirName);
  end;
{$ELSEIF COOPER}
  Directory = public class
  private
    class method RecursiveDelete(Dir: java.io.File);
    class method CopyDirectory(Source, Dest: java.io.File);
  public
    class method CreateDirectory(Path: String);
    class method Delete(Path: String);
    class method Delete(Path: String; Recursive: Boolean);
    class method Exists(Path: String): Boolean;
    class method GetCurrentDirectory: String;
    class method GetFiles(Path: String; Recursive: Boolean): array of String;
    class method Move(SourceDirName: String; DestDirName: String);
  end;
{$ELSEIF NOUGAT}
  Directory = public class
  private
    class method IsDirectory(Path: String): Boolean;
    class method GetFilesRecursive(Path: String; List: Foundation.NSMutableArray);
  public
    class method CreateDirectory(Path: String);
    class method Delete(Path: String);
    class method Delete(Path: String; Recursive: Boolean);
    class method Exists(Path: String): Boolean;
    class method GetCurrentDirectory: String;
    class method GetFiles(Path: String; Recursive: Boolean): array of String;
    class method Move(SourceDirName: String; DestDirName: String);
  end;
{$ENDIF}

implementation

{$IF ECHOES}
class method Directory.GetFiles(Path: String; Recursive: Boolean): array of String;
begin
  if Recursive then
    {$IF WINDOWS_PHONE}
    begin
      var list := new System.Collections.Generic.List<String>;    
      GetFilesRecursive(Path, list);
      exit list.ToArray;
    end
    {$ELSE}
    exit mapped.GetFiles(Path, "*", System.IO.SearchOption.AllDirectories)
    {$ENDIF}
  else
    exit mapped.GetFiles(Path);
end;

{$IF WINDOWS_PHONE}
class method Directory.GetFilesRecursive(Path: String; List: System.Collections.Generic.List<String>);
begin
  var files := mapped.GetFiles(Path);
  List.AddRange(files);
  var folders := mapped.GetDirectories(Path);
  {for i: Integer := 0 to folders.Length-1 do //STACK OVERFLOW
    GetFilesRecursive(Path+System.IO.Path.DirectorySeparatorChar+folders[i], List);}
end;
{$ENDIF}

{$ELSEIF COOPER}
class method Directory.Delete(Path: String);
begin
  Delete(Path, false);
end;

class method Directory.CreateDirectory(Path: String);
begin
  var Dir := new java.io.File(Path);
  Dir.mkdir;
end;

class method Directory.Delete(Path: String; Recursive: Boolean);
begin
  var Dir := new java.io.File(Path);
  if Recursive then
    RecursiveDelete(Dir)
  else
    Dir.delete;
end;

class method Directory.Exists(Path: String): Boolean;
begin
  var Dir := new java.io.File(Path);
  exit Dir.exists;
end;

class method Directory.RecursiveDelete(Dir: java.io.File);
begin
  if Dir.isDirectory then begin
    var Files := Dir.listFiles;
    for each file in Files do
      RecursiveDelete(file);
  end;

  Dir.delete;
end;

class method Directory.GetCurrentDirectory: String;
begin
  exit System.getProperty("user.dir");
end;

class method Directory.GetFiles(Path: String; Recursive: Boolean): array of String;
begin
  var Dir := new java.io.File(Path);
  var List := new java.util.ArrayList<String>;
 
  if Dir.isDirectory then begin
    var Files := Dir.listFiles;    

    for each file in Files do begin
      if file.isFile then
        List.add(file.AbsolutePath)
      else
        if file.isDirectory and Recursive then
          List.addAll(java.util.Arrays.asList(GetFiles(file.AbsolutePath, Recursive)));
    end;    
  end
  else
    List.add(Path);

  result := List.toArray(new String[List.size]);
end;

class method Directory.Move(SourceDirName: String; DestDirName: String);
begin
  var SourceDir := new java.io.File(SourceDirName);
  var DestDir := new java.io.File(DestDirName);

  CopyDirectory(SourceDir, DestDir);
  Delete(SourceDirName, true);
end;

class method Directory.CopyDirectory(Source: java.io.File; Dest: java.io.File);
begin
  if not Dest.exists then
    Dest.mkdir;

  var Files := Source.listFiles;
  for each file in Files do begin
    var DestFile := new java.io.File(Dest, file.getName);
    if file.isDirectory then
      CopyDirectory(file, DestFile)
    else
      java.nio.file.Files.move(file.toPath, DestFile.toPath);
  end;
end;

{$ELSEIF NOUGAT}
class method Directory.Delete(Path: String);
begin
  Delete(Path, false);
end;

class method Directory.CreateDirectory(Path: String);
begin
  var lError: Foundation.NSError := nil;
  if not Foundation.NSFileManager.defaultManager.createDirectoryAtPath(Path) withIntermediateDirectories(False) attributes(nil) error(var lError) then
    raise SugarNSErrorException.exceptionWithError(lError);
end;

class method Directory.Delete(Path: String; Recursive: Boolean); 
begin
 //TODO: Currently always deletes files recursively
  var lError: Foundation.NSError := nil;
  if not Foundation.NSFileManager.defaultManager.removeItemAtPath(Path) error(var lError) then
    raise SugarNSErrorException.exceptionWithError(lError);
end;

class method Directory.Exists(Path: String): Boolean;
begin
  exit Foundation.NSFileManager.defaultManager.fileExistsAtPath(Path);
end;

class method Directory.GetCurrentDirectory: String;
begin
  exit Foundation.NSFileManager.defaultManager.currentDirectoryPath;
end;

class method Directory.GetFiles(Path: String; Recursive: Boolean): array of String;
begin  
  var List := new Foundation.NSMutableArray();
  
  if Recursive then
    GetFilesRecursive(Path, List)
  else begin
    var lError: Foundation.NSError;
    List.addObjectsFromArray(Foundation.NSFileManager.defaultManager.contentsOfDirectoryAtPath(Path) error(var lError));
  end;

  result := new String[List.count];
  for i: Integer := 0 to List.count-1 do
    result[i] := List.objectAtIndex(i);
end;

class method Directory.GetFilesRecursive(Path: String; List: Foundation.NSMutableArray);
begin
  var lError: Foundation.NSError;
  var Files := Foundation.NSFileManager.defaultManager.contentsOfDirectoryAtPath(Path) error(var lError);
  for i: Integer := 0 to Files.count-1 do begin
    var lFilePath: String := Files.objectAtIndex(i);
    if not IsDirectory(lFilePath) then
      List.addObject(lFilePath)
    else
      GetFilesRecursive(lFilePath, List);
  end;
end;

class method Directory.IsDirectory(Path: String): Boolean;
begin
  Foundation.NSFileManager.defaultManager.fileExistsAtPath(Path) isDirectory(@Result);
end;

class method Directory.Move(SourceDirName: String; DestDirName: String);
begin
  var lError: Foundation.NSError := nil;
  if not Foundation.NSFileManager.defaultManager.moveItemAtPath(SourceDirName) toPath(DestDirName) error(var lError) then
    raise SugarNSErrorException.exceptionWithError(lError);
end;
{$ENDIF}

end.

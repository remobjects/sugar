namespace RemObjects.Oxygene.Sugar.IO;

interface

{$IF ECHOES}
type
  Directory = public class mapped to System.IO.Directory
  public
    class method CreateDirectory(Path: String); mapped to CreateDirectory(Path);
    class method Delete(Path: String); mapped to Delete(Path);
    class method Delete(Path: String; Recursive: Boolean); mapped to Delete(Path, Recursive);
    class method Exists(Path: String): Boolean; mapped to Exists(Path);
    class method GetCurrentDirectory: String; mapped to GetCurrentDirectory;
    class method GetFiles(Path: String): array of String; mapped to GetFiles(Path);
    class method Move(SourceDirName: String; DestDirName: String); mapped to Move(SourceDirName, DestDirName);
  end;
{$ELSEIF COOPER}
type
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
    class method GetFiles(Path: String): array of String;
    class method Move(SourceDirName: String; DestDirName: String);
  end;
{$ENDIF}

implementation

{$IF COOPER}
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

class method Directory.GetFiles(Path: String): array of String;
begin
  var Dir := new java.io.File(Path);
  var Files := Dir.listFiles;
  result := new String[Files.length];
  for i: Integer := 0 to Files.length-1 do
    result[i] := Files[i].AbsolutePath;
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
{$ENDIF}

end.

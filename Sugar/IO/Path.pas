namespace RemObjects.Oxygene.Sugar.IO;
{$HIDE W0} //supress case-mismatch errors
interface

type
  Path = public static class
  private
    class method get_PathSeparator: String;
    class method get_FolderSeparator: String;
  public
    method GetFilename(aPath: String): String;
    method GetFilenameWithoutExtension(aPath: String): String; 
    method GetFilenameExtension(aPath: String): String; 
    method GetFolderName(aPath: String): String;
 
    method Combine(aBasePath: String; aSubPath: String): String; 
    method Combine(aBasePath: String; aSubPath, aSubPath2: String): String; 
    method Combine(aBasePath: String; aSubPath, aSubPath2, SubPath3: String): String; 

    method GetTempFolder: String;
    method GetTempFilename: String;

    property PathSeparator: String read get_PathSeparator;
    property FolderSeparator: String read get_FolderSeparator;
  end;

implementation

{$IF ECHOES}
class method Path.GetFilename(aPath: String): String;
begin
  result := System.IO.Path.GetFileName(aPath);
end;

class method Path.GetFilenameWithoutExtension(aPath: String): String;
begin
  result := System.IO.Path.GetFileNameWithoutExtension(aPath);
end;

class method Path.GetFilenameExtension(aPath: String): String;
begin
  result := System.IO.Path.GetExtension(aPath);
end;

class method Path.GetFolderName(aPath: String): String;
begin
  result := System.IO.Path.GetDirectoryName(aPath);
end;

class method Path.Combine(aBasePath: String; aSubPath: String): String;
begin
  result := System.IO.Path.Combine(aBasePath, aSubPath);
end;

class method Path.get_PathSeparator: String;
begin
  result := String(System.IO.Path.PathSeparator);
end;

class method Path.get_FolderSeparator: String;
begin
  result := String(System.IO.Path.DirectorySeparatorChar);
end;

class method Path.GetTempFolder: String;
begin
  result := System.IO.Path.GetTempPath;
end;

class method Path.GetTempFilename: String;
begin
  result := System.IO.Path.GetTempFileName;
end;
{$ENDIF}

{$IF COOPER}
class method Path.GetFilename(aPath: String): String;
begin
  var lFile := new java.io.File(aPath);
  exit lFile.Name;
end;

class method Path.GetFilenameWithoutExtension(aPath: String): String;
begin
  result := GetFilename(aPath);
  var lIndex := result.LastIndexOf(".");
  if lIndex <> -1 then
    exit result.Substring(0, lIndex);
end;

class method Path.GetFilenameExtension(aPath: String): String;
begin
  result := GetFilename(aPath);
  var lIndex := result.LastIndexOf(".");
  if lIndex <> -1 then
    exit result.Substring(lIndex);  
end;

class method Path.GetFolderName(aPath: String): String;
begin
  var lFile := new java.io.File(aPath);
  exit lFile.ParentFile.AbsolutePath;
end;

class method Path.Combine(aBasePath: String; aSubPath: String): String;
begin
  var File1 := new java.io.File(aBasePath);
  var File2 := new java.io.File(File1, aSubPath);
  exit File2.Path;
end;

class method Path.get_PathSeparator: String;
begin
  exit java.io.File.pathSeparator;
end;

class method Path.get_FolderSeparator: String;
begin
  exit java.io.File.separator;
end;

class method Path.GetTempFolder: String;
begin
  exit System.getProperty("java.io.tmpdir");
end;

class method Path.GetTempFilename: String;
begin
  exit java.io.File.createTempFile('tmp', '.TMP').AbsolutePath;
end;
{$ENDIF}

{$IF NOUGAT}
class method Path.GetFilename(aPath: String): String;
begin
  result := Foundation.NSString(aPath):lastPathComponent;
end;

class method Path.GetFilenameWithoutExtension(aPath: String): String;
begin
  result := Foundation.NSString(aPath):lastPathComponent:stringByDeletingPathExtension;
end;

class method Path.GetFilenameExtension(aPath: String): String;
begin
  result := Foundation.NSString(aPath):pathExtension;
end;

class method Path.GetFolderName(aPath: String): String;
begin
  result := Foundation.NSString(aPath):stringByDeletingLastPathComponent;
end;

class method Path.Combine(aBasePath: String; aSubPath: String): String;
begin
  result :=Foundation. NSString(aBasePath):stringByAppendingPathComponent(aSubPath);
end;

class method Path.get_PathSeparator: String;
begin
  result := ":";
end;

class method Path.get_FolderSeparator: String;
begin
  result := "/";
end;

class method Path.GetTempFolder: String;
begin
	result := Foundation.NSTemporaryDirectory();
end;

class method Path.GetTempFilename: String;
begin
  //var lGuid := CoreFoundation.CFUUIDCreate(nil);
  //var lGuidStr := CoreFoundation.CFUUIDCreateString(nil, lGuid) as Foundation.NSString;  //59450: Nougat: can't cast from CFStringRef (^IntPtr??) to NSString
  //result := FOundation.NSTemporaryDirectory().stringByAppendingPathComponent(lGuidStr);
end;
{$ENDIF}

class method Path.Combine(aBasePath: String; aSubPath: String; aSubPath2: String): String;
begin
  result := Combine(Combine(aBasePath, aSubPath), aSubPath2);
end;

class method Path.Combine(aBasePath: String; aSubPath: String; aSubPath2: String; SubPath3: String): String;
begin
  result := Combine(Combine(aBasePath, aSubPath, aSubPath2), SubPath3);
end;

end.

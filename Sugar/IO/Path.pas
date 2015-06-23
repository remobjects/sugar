namespace Sugar.IO;

interface

uses
  Sugar;

type
  Path = public static class
  public
    method ChangeExtension(FileName: String; NewExtension: String): String;
    method Combine(BasePath: String; Path: String): String;
    method Combine(BasePath: String; Path1: String; Path2: String): String;
    method GetParentDirectory(FileName: String): String;
    method GetExtension(FileName: String): String;
    method GetFileName(FileName: String): String;
    method GetFileNameWithoutExtension(FileName: String): String;
    method RemoveExtension(FileName: String): String;
    method GetFullPath(RelativePath: String): String;
  end;

implementation

class method Path.ChangeExtension(FileName: String; NewExtension: String): String;
begin
  SugarArgumentNullException.RaiseIfNil(FileName, "FileName");

  if NewExtension = nil then
    exit RemoveExtension(FileName);

  var lIndex := FileName.LastIndexOf(".");

  if NewExtension.Length = 0 then
    exit FileName;

  if lIndex <> -1 then
    FileName := FileName.Substring(0, lIndex);

  if NewExtension[0] = '.' then
    exit FileName + NewExtension;


  exit FileName + "." + NewExtension;
end;

class method Path.Combine(BasePath: String; Path: String): String;
begin
  if String.IsNullOrEmpty(BasePath) and String.IsNullOrEmpty(Path) then
    raise new SugarArgumentException("Invalid arguments");

  if String.IsNullOrEmpty(BasePath) then
    exit Path;

  if String.IsNullOrEmpty(Path) then
    exit BasePath;

  var LastChar: Char := BasePath[BasePath.Length - 1];

  if LastChar = Folder.Separator then
    exit BasePath + Path;

  exit BasePath + Folder.Separator + Path;
end;

class method Path.Combine(BasePath: String; Path1: String; Path2: String): String;
begin
  exit Combine(Combine(BasePath, Path1), Path2);
end;

class method Path.GetParentDirectory(FileName: String): String;
begin
  SugarArgumentNullException.RaiseIfNil(FileName, "FileName");

  if FileName.Length = 0 then
    exit nil;

  var LastChar: Char := FileName[FileName.Length - 1];

  if LastChar = Folder.Separator then
    FileName := FileName.Substring(0, FileName.Length - 1);

  var lIndex := FileName.LastIndexOf(Folder.Separator);
  
  if lIndex <> -1 then
    exit FileName.Substring(0, lIndex);

  exit nil;
end;

class method Path.GetExtension(FileName: String): String;
begin
  SugarArgumentNullException.RaiseIfNil(FileName, "FileName");

  var lIndex := FileName.LastIndexOf(".");
  
  if (lIndex <> -1) and (lIndex < FileName.Length - 1) then
    exit FileName.Substring(lIndex);

  exit "";
end;

class method Path.GetFileName(FileName: String): String;
begin
  SugarArgumentNullException.RaiseIfNil(FileName, "FileName");

  if FileName.Length = 0 then
    exit "";

  var LastChar: Char := FileName[FileName.Length - 1];

  if LastChar = Folder.Separator then
    FileName := FileName.Substring(0, FileName.Length - 1);

  var lIndex := FileName.LastIndexOf(Folder.Separator);
  
  if (lIndex <> -1) and (lIndex < FileName.Length - 1) then
    exit FileName.Substring(lIndex + 1);
  
  exit FileName;
end;

class method Path.GetFileNameWithoutExtension(FileName: String): String;
begin
  exit RemoveExtension(GetFileName(FileName));
end;

class method Path.RemoveExtension(FileName: String): String;
begin
  SugarArgumentNullException.RaiseIfNil(FileName, "FileName");

  var lIndex := FileName.LastIndexOf(".");
  
  if lIndex <> -1 then
    exit FileName.Substring(0, lIndex);

  exit FileName;
end;

class method Path.GetFullPath(RelativePath: String): String;
begin
  {$IF COOPER}
  exit new java.io.File(RelativePath).getAbsolutePath();  
  {$ELSEIF NETFX_CORE}
  exit RelativePath; //api has no such function
  {$ELSEIF WINDOWS_PHONE}
  exit System.IO.Path.GetFullPath(RelativePath);
  {$ELSEIF ECHOES}
  exit System.IO.Path.GetFullPath(RelativePath);
  {$ELSEIF NOUGAT}
  exit RelativePath.stringByStandardizingPath;
  {$ENDIF}
end;

end.

namespace RemObjects.Oxygene.Sugar.IO;

interface

uses
  {$IFDEF NOUGAT}Foundation,{$ENDIF}
  RemObjects.Oxygene.Sugar;

type

  {$IF ECHOES}
  File = public class mapped to System.IO.File
  public
    class method AppendText(aFileName, aContents: String);  mapped to AppendAllText(aFileName, aContents);
    class method &Copy(aOldFileName, aNewFileName: String; aOverwriteFile: Boolean); mapped to &Copy(aOldFileName, aNewFileName, aOverwriteFile);
    class method Delete(aFileName: String); mapped to Delete(aFileName);
    class method Exists(aFileName: String): Boolean; mapped to Exists(aFileName);
    class method Move(aOldFileName, aNewFileName: String); mapped to Move(aOldFileName, aNewFileName);
    class method ReadBytes(aFileName: String): array of Byte; mapped to ReadAllBytes(aFileName);
    class method ReadText(aFileName: String): String; mapped to ReadAllText(aFileName);
    class method WriteBytes(aFileName: String; aData:array of Byte); mapped to WriteAllBytes(aFileName, aData);
    class method WriteText(aFileName: String; aText: String); mapped to WriteAllText(aFileName, aText);
  {$ENDIF}
  {$IF COOPER or NOUGAT}
  File = public class
    class method AppendText(aFileName, aContents: String); 
    class method &Copy(aOldFileName, aNewFileName: String; aOverwriteFile: Boolean);
    class method Delete(aFileName: String);
    class method Exists(aFileName: String): Boolean; 
    class method Move(aOldFileName, aNewFileName: String);
    class method ReadBytes(aFileName: String): array of Byte;
    class method ReadText(aFileName: String): String;
    class method WriteBytes(aFileName: String; aData: array of Byte);
    class method WriteText(aFileName: String; aText: String); 
  {$ENDIF}
  end;

implementation

{$IF COOPER}
class method File.AppendText(aFileName, aContents: String); 
begin
  var textFile: java.io.FileWriter;
  try
    textFile := new java.io.FileWriter(aFileName, true);
    textFile.write(aContents);
  finally
    textFile.close();
  end;
end;

class method File.Copy(aOldFileName, aNewFileName: String; aOverwriteFile: Boolean);
begin
  var source := new java.io.File(aOldFileName);
  var dest := new java.io.File(aNewFileName);
  if aOverwriteFile then
    java.nio.file.Files.copy(source.toPath(), dest.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING)
  else
    java.nio.file.Files.copy(source.toPath(), dest.toPath());
end;

class method File.Delete(aFileName: String);
begin
  var f := new java.io.File(aFileName);
  f.delete();
end;

class method File.Exists(aFileName: String): Boolean; 
begin
  var f := new java.io.File(aFileName);
  exit f.exists();
end;

class method File.Move(aOldFileName, aNewFileName: String);
begin

end;

class method File.ReadBytes(aFileName: String): array of Byte;
begin

end;

class method File.ReadText(aFileName: String): String;
begin

end;

class method File.WriteBytes(aFileName: String; aData: array of Byte);
begin

end;

class method File.WriteText(aFileName: String; aText: String); 
begin
  var textFile: java.io.FileWriter;
  try
    textFile := new java.io.FileWriter(aFileName, false);
    textFile.write(aText);
  finally
    textFile.close();
  end;
end;
{$ENDIF}

{$IF NOUGAT}
class method File.AppendText(aFileName, aContents: String); 
begin
end;

class method File.Copy(aOldFileName, aNewFileName: String; aOverwriteFile: Boolean);
begin
  var lError: Foundation.NSError := nil;
  //ToDo: handle aOverwriteFile
  NSFileManager.defaultManager.copyItemAtPath(aOldFileName) toPath(aNewFileName) error(@lError);
  if not assigned(lData) then 
    raise SugarNSErrorException.exceptionWithError(lError); 
end;

class method File.Delete(aFileName: String);
begin
  var lError: Foundation.NSError := nil;
  if not NSFileManager.defaultManager.removeItemAtPath(aFileName) error(@lError) then
    raise SugarNSErrorException.exceptionWithError(lError); 
end;

class method File.Exists(aFileName: String): Boolean; 
begin
  var lIsDirectory := false;
  result := NSFileManager.defaultManager.fileExistsAtPath(aFileName) isDirectory(@lIsDirectory) and not lIsDirectory
end;

class method File.Move(aOldFileName, aNewFileName: String);
begin
  var lError: Foundation.NSError := nil;
  NSFileManager.defaultManager.moveItemAtPath(aOldFileName) toPath(aNewFileName) error(@lError);
  if not assigned(lData) then 
    raise SugarNSErrorException.exceptionWithError(lError); 
end;

class method File.ReadBytes(aFileName: String): array of Byte;
begin
  var lError: Foundation.NSError := nil;
  var lData := NSData.dataWithContentsOfFile(aFileName) options(NSDataReadingOptions.NSDataReadingMappedIfSafe) error(@lError);
  if not assigned(lData) then 
    raise SugarNSErrorException.exceptionWithError(lError); 

  result := new Byte[lData.length];
  lData.getBytes(^Void(result)) length(lData.length);
end;

class method File.ReadText(aFileName: String): String;
begin
  var lError: Foundation.NSError := nil;
  result := Foundation.NSString.stringWithContentsOfFile(aFileName) encoding(NSStringEncoding.NSUTF8StringEncoding) error(@lError);
  if not assigned(result) then 
    raise SugarNSErrorException.exceptionWithError(lError); 
end;

class method File.WriteBytes(aFileName: String; aData: array of Byte);
begin
  var lData := NSData.dataWithBytesNoCopy(^Void(aData)) length({length(aData)}1); // length(aData) doesnt compile yet
  // ToDo: should use colon once NRE issue is fixed
  if not lData{:}.writeToFile(aFileName) atomically(true) then
    raise NSException.exceptionWithName('NSData') reason('Failed to write NSData to file.') userInfo(nil); 
end;

class method File.WriteText(aFileName: String; aText: String); 
begin
  var lError: Foundation.NSError := nil;
  // ToDo: should use colon once NRE issue is fixed
  if not NSString(aText){:}.writeToFile(aFileName) atomically(true) encoding(NSStringEncoding.NSUTF8StringEncoding) error(@lError) then
    raise SugarNSErrorException.exceptionWithError(lError); 
end;
{$ENDIF}


end.

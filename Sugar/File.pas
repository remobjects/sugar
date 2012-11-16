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
    //class method ReadBytes(aFileName: String): Binary; mapped to ReadAllBytes(aFileName);
    class method ReadText(aFileName: String): String; mapped to ReadAllText(aFileName);
    //class method WriteBytes(aFileName: String; aData:Binary); mapped to WriteAllBytes(aFileName, aData);
    class method WriteText(aFileName: String; aText: String); mapped to WriteAllText(aFileName, aText);
  {$ENDIF}
  {$IF COOPER or NOUGAT}
  File = public class
    class method AppendText(aFileName, aContents: String); 
    class method &Copy(aOldFileName, aNewFileName: String; aOverwriteFile: Boolean);
    class method Delete(aFileName: String);
    class method Exists(aFileName: String): Boolean; 
    class method Move(aOldFileName, aNewFileName: String);
    class method ReadBytes(aFileName: String): Binary;
    class method ReadText(aFileName: String): String;
    class method WriteBytes(aFileName: String; aData: Binary);
    class method WriteText(aFileName: String; aText: String); 
  {$ENDIF}
  end;

implementation

{$IF COOPER}
class method File.AppendText(aFileName, aContents: String); 
begin
  var textFile := new java.io.FileWriter(aFileName, true);
  textFile.write(aContents);
  textFile.close();
end;

class method File.Copy(aOldFileName, aNewFileName: String; aOverwriteFile: Boolean);
begin

end;

class method File.Delete(aFileName: String);
begin

end;

class method File.Exists(aFileName: String): Boolean; 
begin

end;

class method File.Move(aOldFileName, aNewFileName: String);
begin

end;

class method File.ReadBytes(aFileName: String): Binary;
begin

end;

class method File.ReadText(aFileName: String): String;
begin

end;

class method File.WriteBytes(aFileName: String; aData: Binary);
begin

end;

class method File.WriteText(aFileName: String; aText: String); 
begin

end;
{$ENDIF}

{$IF NOUGAT}
class method File.AppendText(aFileName, aContents: String); 
begin

end;

class method File.Copy(aOldFileName, aNewFileName: String; aOverwriteFile: Boolean);
begin

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

end;

class method File.ReadBytes(aFileName: String): Binary;
begin
  var lError: Foundation.NSError := nil;
  result := NSData.dataWithContentsOfFile(aFileName) options(NSDataReadingOptions.NSDataReadingMappedIfSafe) error(@lError);
  if not assigned(result) then 
    raise SugarNSErrorException.exceptionWithError(lError); 
end;

class method File.ReadText(aFileName: String): String;
begin
  var lError: Foundation.NSError := nil;
  result := Foundation.NSString.stringWithContentsOfFile(aFileName) encoding(NSStringEncoding.NSUTF8StringEncoding) error(@lError);
  if not assigned(result) then 
    raise SugarNSErrorException.exceptionWithError(lError); 
end;

class method File.WriteBytes(aFileName: String; aData: Binary);
begin
  // ToDo: should use colon once NRE issue is fixed
  if not NSData(aData){:}.writeToFile(aFileName) atomically(true) then
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

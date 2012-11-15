namespace RemObjects.Oxygene.Sugar.IO;

interface

uses
  RemObjects.Oxygene.Sugar;

type

  {$IF ECHOES}
  File = public class mapped to System.IO.File
  public
    class method AppendText(aFileName, aContents: String);  mapped to AppendAllText(aFileName, aContents);
    class method &Copy(aOldFileName, aNewFileName: String; aOverwriteFile: Boolean); mapped to &Copy(aOldFileName, aNewFileName, aOverwriteFile);
    class method Delete(aFileName: String); mapped to Delete(aFileName);
    class method Exists(aFileName: String); mapped to Exists(aFileName);
    class method Move(aOldFileName, aNewFileName: String); mapped to Move(aOldFileName, aNewFileName);
    class method ReadBytes(aFileName: String): array of Byte; mapped to ReadAllBytes(aFileName);
    class method ReadText(aFileName: String): String; mapped to ReadAllText(aFileName);
    class method WriteBytes(aFileName: String; aData: array of Byte); mapped to WriteAllBytes(aFileName, aData);
    class method WriteText(aFileName: String; aText: String); mapped to WriteAllText(aFileName, aText);
  {$ENDIF}
  {$IF COOPER or NOUGAT}
  File = public class
    class method AppendText(aFileName, aContents: String); 
    class method &Copy(aOldFileName, aNewFileName: String; aOverwriteFile: Boolean);
    class method Delete(aFileName: String);
    class method Exists(aFileName: String); 
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
  var out := new java.io.FileWriter(aFileName, true);
  out.write(aContents);
  out.close();
end;

class method File.Copy(aOldFileName, aNewFileName: String; aOverwriteFile: Boolean);
begin

end;

class method File.Delete(aFileName: String);
begin

end;

class method File.Exists(aFileName: String); 
begin

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

end;

class method File.Exists(aFileName: String); 
begin

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

end;
{$ENDIF}


end.

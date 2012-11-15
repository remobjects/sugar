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
  {$IF COOPER or Nougat}
  File = public class
  {$ENDIF}
  end;

implementation

end.

namespace RemObjects.Oxygene.Sugar.IO;

interface

type

  {$IF ECHOES}
  File = public class mapped to System.IO.File
  public
    class method AppendText(aFileName, aContents: String);  mapped to AppendAllText(aFileName, aContents);
    class method &Copy(aOldFileName, aNewFileName: String; aOverwriteFile: Boolean); mapped to &Copy(aOldFileName, aNewFileName, aOverwriteFile);
    class method Delete(aFileName: String); mapped to Delete(aFileName);
  {$ENDIF}
  {$IF COOPER or Nougat}
  File = public class
  {$ENDIF}
  end;

implementation

end.

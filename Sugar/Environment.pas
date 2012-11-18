namespace RemObjects.Oxygene.Sugar;

interface

type
 
  {$IF COOPER}
  Environment = public class
  public 
    class property NewLine: String := System.getProperty("line.separator");
  {$ENDIF}
  {$IF ECHOES}
  Environment = public class mapped to System.Environment
  public
    class property NewLine: String read mapped.NewLine;
  {$ENDIF}
  {$IF NOUGAT}
  Environment = public class
  public 
    class property NewLine: String read RemObjects.Oxygene.Sugar.String(#10);
  {$ENDIF}
  end;

implementation

end.

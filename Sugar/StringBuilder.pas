namespace RemObjects.Oxygene.Sugar;

interface

type

  {$IF COOPER}
  StringBuilder = public class mapped to java.lang.StringBuilder
  public
  {$ENDIF}
  {$IF ECHOES}
  StringBuilder = public class mapped to System.Text.StringBuilder
  public
    method Append(value: String): StringBuilder; mapped to Append(value);
    method Append(value: String; startIndex, count: Integer): StringBuilder; mapped to Append(value, startIndex, count);
    method Append(value: Char; repeatCount: Integer): StringBuilder; mapped to Append(value, repeatCount);
  {$ENDIF}
  {$IF NOUGAT}
  StringBuilder = public class mapped to NSMutableString
  public
  {$ENDIF}
  end;

implementation

end.

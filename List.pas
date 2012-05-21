namespace RemObjects.Sugar;

interface

type
  {$IFDEF COOPER}
  List<T> = public class mapped to java.util.ArrayList
  {$ENDIF}
  {$IFDEF ECHOES}
  List<T> = public class mapped to System.Collections.Generic.List<T>
  {$ENDIF}
  {$IFDEF NOUGAT}
  List<T> = public class mapped to Foundation.NSArray
  {$ENDIF}
  end;

implementation

end.

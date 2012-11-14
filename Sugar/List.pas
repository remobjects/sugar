namespace RemObjects.Oxygene.Sugar;

interface

type
  {$IF COOPER}
  List<T> = public class mapped to java.util.ArrayList
  {$ENDIF}
  {$IF ECHOES}
  List<T> = public class mapped to System.Collections.Generic.List<T>
  {$ENDIF}
  {$IF NOUGAT}
  List<T> = public class mapped to Foundation.NSArray
  {$ENDIF}
  end;

implementation

end.

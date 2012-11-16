namespace RemObjects.Oxygene.Sugar;

interface

type
  {$IFDEF COOPER}
  Binary = public class mapped to Object
  {$ENDIF}
  {$IFDEF ECHOES}
  Binary = public class mapped to Object
  {$ENDIF}
  {$IFDEF NOUGAT}
  Binary = public class mapped to Foundation.NSData
  {$ENDIF}
  private
  protected
  public
  end;


implementation

end.

namespace RemObjects.Oxygene.Sugar;

interface

type

  {$IF NOUGAT}
  Object = public class mapped to Foundation.NSObject
  public 
    method ToString: String; mapped to description;
  end;
  {$ENDIF}

implementation

{$IF NOUGAT}

{$ENDIF}

end.

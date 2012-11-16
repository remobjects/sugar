namespace RemObjects.Oxygene.Sugar;

interface

type

  {$IF NOUGAT}
  Object = public class mapped to Foundation.NSObject
  public 
    method ToString: String;
  end;
  {$ENDIF}

implementation

{$IF NOUGAT}
method Object.ToString: String;
begin
  exit mapped.description;
end;
{$ENDIF}

end.

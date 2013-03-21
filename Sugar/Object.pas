namespace RemObjects.Oxygene.Sugar;

interface

{$IF NOUGAT}
extension method Foundation.NSObject.ToString: String;
{$ENDIF}
  
implementation

{$IF NOUGAT}
extension method Foundation.NSObject.ToString: String;
begin
  result := description;
end;
{$ENDIF}

end.

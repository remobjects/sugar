namespace RemObjects.Oxygene.Sugar;

interface

{$IF NOUGAT}
extension method Foundation.NSObject.ToString: String;
extension method Foundation.NSObject.Equals(Obj: Object): Boolean;
{$ENDIF}
  
implementation

{$IF NOUGAT}
extension method Foundation.NSObject.ToString: String;
begin
  result := description;
end;

extension method Foundation.NSObject.Equals(Obj: Object): Boolean;
begin
  result := isEqual(Obj);
end;
{$ENDIF}

end.

namespace Sugar;

interface

{$IF COOPER}
extension method java.lang.Object.GetHashCode: Integer;
{$ELSEIF NOUGAT}
extension method Foundation.NSObject.ToString: String;
extension method Foundation.NSObject.Equals(Obj: Object): Boolean;
extension method Foundation.NSObject.GetHashCode: Integer;
{$ENDIF}
  
implementation

{$IF COOPER}
extension method java.lang.Object.GetHashCode: Integer;
begin
  result := hashCode;
end;
{$ELSEIF NOUGAT}
extension method Foundation.NSObject.ToString: String;
begin
  result := description;
end;

extension method Foundation.NSObject.Equals(Obj: Object): Boolean;
begin
  result := isEqual(Obj);
end;

extension method Foundation.NSObject.GetHashCode: Integer;
begin
  result := hash;
end;
{$ENDIF}

end.

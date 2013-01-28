namespace RemObjects.Oxygene.Sugar;

interface

{$IF NOUGAT}
//60445: Nougat: support for extension methods (ie Categories)
//extension method Foundation.NSObject.ToString: String;
{$ENDIF}
  
implementation

{$IF NOUGAT}
{extension method Foundation.NSObject.ToString: String;
begin
  result := description;
end;}
{$ENDIF}

end.

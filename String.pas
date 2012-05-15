namespace RemObjects.Sugar.Echoes;

interface

extension method String.Format(aFormat: String; params aParams: array of Object): String;

implementation

extension method String.Format(aFormat: String; params aParams: array of Object): String;
begin
  {$IFDEF COOPER}
  //...
  {$ENDIF}
  {$IFDEF ECHOES}
  //...
  {$ENDIF}
  {$IFDEF NOUGAT}
  result := NSString.stringWithFormat(aFormat, aParams);
  {$ENDIF}
end;

end.

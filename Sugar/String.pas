namespace RemObjects.Sugar;

interface

type
  {$IFDEF COOPER}
  String = public class mapped to java.lang.String
  {$ENDIF}
  {$IFDEF ECHOES}
  String = public class mapped to System.String
  {$ENDIF}
  {$IFDEF NOUGAT}
  String = public class mapped to Foundation.NSString
  {$ENDIF}
    class method FormatDotNet(aFormat: String; params aParams: array of Object): String;
    class method FormatC(aFormat: String; params aParams: array of Object): String;
  end;

implementation

class method String.FormatDotNet(aFormat: String; params aParams: array of Object): String;
begin
  {$IFDEF ECHOES}
  result := System.String.Format(System.String(aFormat), aParams);
  {$ELSE}
  raise new SugarNotImplementedException();
  {$ENDIF}
end;

class method String.FormatC(aFormat: String; params aParams: array of Object): String;
begin
  {$IFDEF NOUGAT}
  result := Foundation.NSString.stringWithFormat(aFormat, aParams);
  {$ELSE}
  raise new SugarNotImplementedException();
  {$ENDIF}
end;

end.

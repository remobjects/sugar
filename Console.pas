namespace RemObjects.Sugar.Echoes;

interface

type
  {$IFDEF ECHOES}
  Console = public class mapped to System.Console
    property NewLine: String read Environment.NewLine;
    method &Write(aString: String); mapped to &Write(aString);
    method &Write(aString: String; params aParams: array of String);
    method WriteLine(aString: String); mapped to WriteLine(aString);
  end;
  {$ENDIF}

  {$IFDEF COOPER}
  Console = public class mapped to java.lang.System
    property NewLine: String read System.getProperty("line.separator");
    method &Write(aString: String);
    method &Write(aString: String; params aParams: array of String);
    method WriteLine(aString: String);
  end;
  {$ENDIF}

implementation

{$IFDEF COOPER}
method Console.&Write(aString: String);
begin
  System.out.print(aString);
end;

method Console.WriteLine(aString: String);
begin
  &Write(aString+NewLine);
end;
{$ENDIF}

method Console.&Write(aString: String; params aParams: array of String);
begin
  {$HIDE W0}
  &Write(String.Format(aString, aParams));
  {$SHOW W0}
end;

end.

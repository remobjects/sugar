namespace RemObjects.Sugar;

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

  {$IFDEF NOUGAT}
  Console = public class
  public
    property NewLine: String read RemObjects.Sugar.String(#10); // for now
    method &Write(aString: String);
    method &Write(aString: String; params aParams: array of String);
    method WriteLine(aString: String);
  end;
  {$ENDIF}

implementation

{$IFNDEF ECHOES}
method Console.&Write(aString: String);
begin
  {$IFDEF COOPER}
  System.out.print(aString);
  {$ENDIF}
  {$IFDEF NOUGAT}
  NSLog('%@', aString);
  {$ENDIF}
end;

method Console.WriteLine(aString: String);
begin
  {$IFDEF COOPER}
  //&Write(java.lang.String(aString)+java.lang.String(NewLine));
  {$ELSE}
  &Write(aString+NewLine);
  {$ENDIF}
end;
{$ENDIF}

method Console.&Write(aString: String; params aParams: array of String);
begin
  {$HIDE W0}
  &Write(String.FormatDotNet(aString, aParams));
  {$SHOW W0}
end;

end.

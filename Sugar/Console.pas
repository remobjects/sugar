namespace RemObjects.Oxygene.Sugar;

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
  Console = public static class
  public
    property NewLine: String read RemObjects.Oxygene.Sugar.String(#10); // for now
    method &Write(aString: String);
    method &Write(aString: String; params aParams: array of String);
    method WriteLine(aString: String);
    method ReadKey: Char;
  end;
  {$ENDIF}

implementation

{$IFDEF NOUGAT}
uses Foundation;
{$ENDIF}


{$IFNDEF ECHOES}
method Console.&Write(aString: String);
begin
  {$IFDEF COOPER}
  System.out.print(aString);
  {$ENDIF}
  {$IFDEF NOUGAT}
  printf('%s', Foundation.NSString(aString).cStringUsingEncoding(NSStringEncoding.NSUTF8StringEncoding));
  {$ENDIF}
end;

method Console.WriteLine(aString: String);
begin
  {$IFDEF COOPER}
  //58668: Cant use operators on Mapped types in Cooper
  //&Write(aString+NewLine);

  {$ENDIF}
  {$IFDEF ECHOES}
  &Write(aString+NewLine);
  {$ENDIF}
  {$IFDEF NOUGAT}
  printf('%s', Foundation.NSString(aString).cStringUsingEncoding(NSStringEncoding.NSUTF8StringEncoding));
  printf(#10);
  {$ENDIF}
end;
{$ENDIF}

method Console.ReadKey: Char;
begin
  {$IFDEF NOUGAT}
  //result := Char(getchar());
  {$ENDIF}
end;

method Console.&Write(aString: String; params aParams: array of String);
begin
  {$HIDE W0}
  &Write(String.FormatDotNet(aString, aParams));
  {$SHOW W0}
end;

end.

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
  Console = public class
  public
    property NewLine: String read RemObjects.Oxygene.Sugar.String(#10); // for now
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
  Foundation.NSLog('%@', aString);
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
  //&Write(aString+NewLine);
  
  // bugs://58667: NRE in Nougat compiler on mapped types
  // &Write(Foundation.NSString(aString).stringByAppendingString(Foundation.NSString(NewLine)));
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

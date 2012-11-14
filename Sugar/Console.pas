namespace RemObjects.Oxygene.Sugar;

interface

type
  Console = public static class
  private
    class method getNewLine: String;
  public
    property NewLine: String read getNewLine;

    method &Write(aString: String);
    method &Write(aString: String; params aParams: array of String);
    method WriteLine(aString: String);
    method WriteLine(aString: String; params aParams: array of String);

    method ReadLine: String;
    //method ReadKey: Char;
  end;

implementation

{$IFDEF NOUGAT}
uses Foundation;
{$ENDIF}

method Console.&Write(aString: String);
begin
  {$IFDEF COOPER}
  System.out.print(aString);
  {$ENDIF}
  {$IFDEF ECHOES}
  Console.WriteLine(aString);
  {$ENDIF}
  {$IFDEF NOUGAT}
  printf('%s', Foundation.NSString(aString).cStringUsingEncoding(NSStringEncoding.NSUTF8StringEncoding));
  {$ENDIF}
end;

method Console.WriteLine(aString: String);
begin
  &Write(aString);
  &Write(NewLine);
end;

method Console.&Write(aString: String; params aParams: array of String);
begin
  &Write(String.FormatDotNet(aString, aParams));
end;

class method Console.WriteLine(aString: String; params aParams: array of String);
begin
  &Write(String.FormatDotNet(aString, aParams));
  &Write(NewLine);
end;

method Console.ReadLine: String;
const MAX = 1024;
begin
  {$IFDEF COOPER}
  using br := new java.io.BufferedReader(new java.io.InputStreamReader(System.in)) do
    result := br.readLine();
  {$ENDIF}
  {$IFDEF ECHOES}
  result := Console.ReadLine;
  {$ENDIF}
  {$IF NOUGAT}
  //const MAX = 1024;
  var lBuffer: array[0..MAX] of Byte;
  //rtl.
  //fgets(lBuffer, MAX, stdin);
  {$ENDIF}
end;

(*method Console.ReadKey: Char;
begin
  {$IFDEF COOPER}
  var lBuffer: array[0..0] of Byte;
  if System.in.read(lBuffer, 0, 1) = 1 then
    result := Char(lBuffer[0]);
  {$ENDIF}
  {$IFDEF ECHOES}
  result := Console.ReadKey;
  {$ENDIF}
  {$IFDEF NOUGAT}
  //result := Char(getchar());
  {$ENDIF}
end;*)

class method Console.getNewLine: String;
begin
  {$IFDEF COOPER}
  result := System.getProperty("line.separator");
  {$ENDIF}
  {$IFDEF ECHOES}
  result := Environment.NewLine;
  {$ENDIF}
  {$IFDEF NOUGAT}
  result := RemObjects.Oxygene.Sugar.String(#10); // always constant on Mac and iOS anyways.
  {$ENDIF}
end;

end.

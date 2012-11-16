namespace RemObjects.Oxygene.Sugar;

interface

type
  Console = public static class
  private
    class method getNewLine: String;
  public
    property NewLine: String read getNewLine;
    method &Write(aString: String);
    method &Write(aString: String; params aParams: array of Object);
    method WriteLine(aString: String);
    method WriteLine(aString: String; params aParams: array of Object);
    method ReadLine: String;
    //method ReadKey: Char;
  end;

implementation

{$IF NOUGAT}
uses Foundation;
{$ENDIF}

method Console.&Write(aString: String);
begin
  {$IF COOPER}
  System.out.print(aString);
  {$ENDIF}
  {$IF ECHOES}
  System.Console.Write(aString);
  {$ENDIF}
  {$IF NOUGAT}
  printf('%s', Foundation.NSString(aString).cStringUsingEncoding(NSStringEncoding.NSUTF8StringEncoding));
  {$ENDIF}
end;

method Console.WriteLine(aString: String);
begin
  {$IF COOPER}
  System.out.println(aString);
  {$ENDIF}
  {$IF ECHOES}
  System.Console.WriteLine(aString);
  {$ENDIF}
  {$IF NOUGAT}
  self.Write(aString);
  self.Write(NewLine);
  {$ENDIF}
end;

method Console.Write(aString: String; params aParams: array of Object);
begin 
  {$IF ECHOES}
  self.Write(StringFormatter.FormatString(aString, aParams));
  {$ELSE}
  raise new SugarNotImplementedException();
  {$ENDIF}
end;

class method Console.WriteLine(aString: String; params aParams: array of Object);
begin 
  {$IF ECHOES}
  self.WriteLine(StringFormatter.FormatString(aString, aParams));
  {$ELSE}
  raise new SugarNotImplementedException();
  {$ENDIF}
end;

method Console.ReadLine: String;
const MAX = 1024;
begin
  {$IF COOPER}
  using br := new java.io.BufferedReader(new java.io.InputStreamReader(System.in)) do
    result := br.readLine();
  {$ENDIF}
  {$IF ECHOES}
  result := System.Console.ReadLine;
  {$ENDIF}
  {$IF NOUGAT}
  raise new SugarNotImplementedException();
  //const MAX = 1024;
  //var lBuffer: array[0..MAX] of Byte;
  //rtl.
  //fgets(lBuffer, MAX, stdin);
  {$ENDIF}
end;

(*method Console.ReadKey: Char;
begin
  {$IF COOPER}
  var lBuffer: array[0..0] of Byte;
  if System.in.read(lBuffer, 0, 1) = 1 then
    result := Char(lBuffer[0]);
  {$ENDIF}
  {$IF ECHOES}
  result := Console.ReadKey;
  {$ENDIF}
  {$IF NOUGAT}
  //result := Char(getchar());
  {$ENDIF}
end;*)

class method Console.getNewLine: String;
begin
  {$IF COOPER}
  result := System.getProperty("line.separator");
  {$ENDIF}
  {$IF ECHOES}
  result := Environment.NewLine;
  {$ENDIF}
  {$IF NOUGAT}
  result := RemObjects.Oxygene.Sugar.String(#10); // always constant on Mac and iOS anyways.
  {$ENDIF}
end;

end.

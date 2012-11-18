namespace RemObjects.Oxygene.Sugar;

interface

type
 
  {$IF COOPER}
  Environment = public class mapped to System
  public 
    class property NewLine: String read mapped.getProperty("line.separator");
    class property UserName: String read mapped.getProperty("user.name");
    class property OperatingSystemName: String read  mapped.getProperty("os.name");
    class property OperatingSystemVersion: String read mapped.getProperty("os.version");
    class method GetEnvironmentVariable(aVariableName: String): String; mapped to getenv(aVariableName);
  {$ENDIF}
  {$IF ECHOES}
  Environment = public class mapped to System.Environment
  public
    class property NewLine: String read mapped.NewLine;
    class property UserName: String read mapped.UserName;
    class property OperatingSystemName: String read  mapped.OSVersion.Platform.ToString();
    class property OperatingSystemVersion: String read mapped.OSVersion.Version.ToString();
    class method GetEnvironmentVariable(aVariableName: String): String; mapped to GetEnvironmentVariable(aVariableName);
  {$ENDIF}
  {$IF NOUGAT}
  Environment = public class
  public 
    class property NewLine: String read RemObjects.Oxygene.Sugar.String(#10);
    class property UserName: String read Foundation.NSUserName();
    class property OperatingSystemName: String read ""; //todo
    class property OperatingSystemVersion: String read ""; //todo
    class method GetEnvironmentVariable(aVariableName: String): String;
  {$ENDIF}
  end;

implementation

{$IF NOUGAT}
class method Environment.GetEnvironmentVariable(aVariableName: String): String;
begin
// [[[NSProcessInfo processInfo] environment] objectForKey:@"MY_SRC_DIR"] //todo translate to Oxygene
end;
{$ENDIF}

end.

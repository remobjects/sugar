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
    class property TargetPlatform: TargetPlatform read TargetPlatform.JVM;
    class property TargetPlatformAsString: String read 'Java VM';
    class method GetEnvironmentVariable(aVariableName: String): String; mapped to getenv(aVariableName);
  {$ENDIF}
  {$IF ECHOES}
  Environment = public class mapped to System.Environment
  public
    class property NewLine: String read mapped.NewLine;
    class property UserName: String read mapped.UserName;
    class property OperatingSystemName: String read  mapped.OSVersion.Platform.ToString();
    class property OperatingSystemVersion: String read mapped.OSVersion.Version.ToString();
    class property TargetPlatform: TargetPlatform read TargetPlatform.DotNet;
    class property TargetPlatformAsString: String read '.NET/MONO';
    class method GetEnvironmentVariable(aVariableName: String): String; mapped to GetEnvironmentVariable(aVariableName);
  {$ENDIF}
  {$IF NOUGAT}
  Environment = public class
  public 
    class property NewLine: String read RemObjects.Oxygene.Sugar.String(#10);
    class property UserName: String read Foundation.NSUserName();
    class property OperatingSystemName: String read ""; //todo
    class property OperatingSystemVersion: String read ""; //todo
    class property TargetPlatform: TargetPlatform read TargetPlatform.Apple;
    class property TargetPlatformAsString: String read 'Apple';
    class method GetEnvironmentVariable(aVariableName: String): String;
  {$ENDIF}
  end;

  TargetPlatform = public enum(DotNet, JVM, Apple);

implementation

{$IF NOUGAT}
class method Environment.GetEnvironmentVariable(aVariableName: String): String;
begin
  Foundation.NSProcessInfo.processInfo:environment:objectForKey(aVariableName);
end;
{$ENDIF}

end.

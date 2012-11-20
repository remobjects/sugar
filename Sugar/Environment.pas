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
    class property TargetPlatform: TargetPlatform read TargetPlatform.Java;
    class property TargetPlatforName: String read 'Java';
    class method GetEnvironmentVariable(aVariableName: String): String; mapped to getenv(aVariableName);
  {$ELSEIF ECHOES}
  Environment = public class mapped to System.Environment
  public
    class property NewLine: String read mapped.NewLine;
    class property UserName: String read mapped.UserName;
    class property OperatingSystemName: String read  mapped.OSVersion.Platform.ToString();
    class property OperatingSystemVersion: String read mapped.OSVersion.Version.ToString();
    class property TargetPlatform: TargetPlatform read TargetPlatform.Net;
    class property TargetPlatforName: String read '.NET';
    class property IsMono: Boolean read assigned(&Type.GetType('Mono.Runtime'));
    class method GetEnvironmentVariable(aVariableName: String): String; mapped to GetEnvironmentVariable(aVariableName);
  {$ELSEIF NOUGAT}
  Environment = public class
  private
    class method getOperatingSystemVersion: String;
    class method getOperatingSystemName: String;
  public 
    class property NewLine: String read RemObjects.Oxygene.Sugar.String(#10);
    class property UserName: String read Foundation.NSUserName();
    class property OperatingSystemName: String read getOperatingSystemName;
    class property OperatingSystemVersion: String read getOperatingSystemVersion; //todo
    class property TargetPlatform: TargetPlatform read TargetPlatform.Cocoa;
    class property TargetPlatforName: String read 'Cocoa';
    class method GetEnvironmentVariable(aVariableName: String): String;
  {$ENDIF}
  end;

  TargetPlatform = public enum(Net, Java, Cocoa);

implementation

{$IF NOUGAT}
class method Environment.getOperatingSystemName: String;
begin
  {$HIDE H0}
  if rtl.TargetConditionals.TARGET_OS_MAC = 1 then result := ('OS X')
  else if rtl.TargetConditionals.TARGET_OS_IPHONE = 1 then begin
    if rtl.TargetConditionals.TARGET_IPHONE_SIMULATOR = 1 then result := 'iOS Simulator'
    else result := 'iOS';
  end;
  {$SHOW H0}
end;

class method Environment.getOperatingSystemVersion: String;
begin
  var mib: array of Integer := [rtl.sys.CTL_KERN, rtl.sys.KERN_OSVERSION];
  var namelen: UInt32 {u_int} := sizeOf(mib) / sizeOf(mib[0]);
  var bufferSize: UIntPtr{size_t} := 0; // ToDo: why is size_t missing, and we MUSt use it, for 32/64 compatibility!

  rtl.sys.sysctl(@mib, namelen, nil, @bufferSize, nil, 0);
  var buildBuffer := new Char{u_char}[bufferSize];
  if rtl.sys.sysctl(mib, namelen, buildBuffer, @bufferSize, nil, 0) > 0 then
    result := Foundation.NSString.alloc.initWithBytes(buildBuffer) length(bufferSize) encoding(Foundation.NSStringEncoding.NSUTF8StringEncoding);
 end;

class method Environment.GetEnvironmentVariable(aVariableName: String): String;
begin
  result := Foundation.NSProcessInfo.processInfo:environment:objectForKey(aVariableName);
end;
{$ENDIF}

end.

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
    class property UserName: String read {$IF WINDOWS_PHONE}""{$ELSE}mapped.UserName{$ENDIF};
    class property OperatingSystemName: String read  mapped.OSVersion.Platform.ToString();
    class property OperatingSystemVersion: String read mapped.OSVersion.Version.ToString();
    class property TargetPlatform: TargetPlatform read TargetPlatform.Net;
    class property TargetPlatforName: String read '.NET';
    class property IsMono: Boolean read assigned(&Type.GetType('Mono.Runtime'));
    {$IF NOT WINDOWS_PHONE}class method GetEnvironmentVariable(aVariableName: String): String; mapped to GetEnvironmentVariable(aVariableName);{$ENDIF}
  {$ELSEIF NOUGAT}
  Environment = public class
  private
    class method getOperatingSystemVersion: String;
    class method getOperatingSystemName: String;
  public 
    {$REGION OS-specific Helper APIs}
    class method SysCtl(aLevel: Int32; aValue: Int32): String;
    {$ENDREGION}

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
  {$IF TARGET_OS_MAC}
  result := ('OS X');
  {$ELSEIF TARGET_OS_IPHONE}
    {$IF TARGET_IPHONE_SIMULATOR}
    result := 'iOS Simulator';
    {$ELSE}
    result := 'iOS';
    {$ENDIF}
  {$ELSE}
    {$ERROR Unknown Nougat target platform}
  {$ENDIF}
end;

class method Environment.SysCtl(aLevel: Int32; aValue: Int32): String;
begin
  var mib: array of Integer := [aLevel, aValue];
  var namelen: rtl.sys.u_int := sizeOf(mib) / sizeOf(mib[0]);
  var bufferSize: rtl.stdio.size_t := 0;

  rtl.sys.sysctl(@mib, namelen, nil, @bufferSize, nil, 0);
  var buildBuffer := new rtl.sys.u_char[bufferSize];
  if rtl.sys.sysctl(mib, namelen, buildBuffer, @bufferSize, nil, 0) = 0 then
    result := Foundation.NSString.alloc.initWithBytes(buildBuffer) length(bufferSize) encoding(Foundation.NSStringEncoding.NSUTF8StringEncoding);
 end;

class method Environment.getOperatingSystemVersion: String;
begin
  result := Foundation.NSString.stringWithFormat('%@ %@ (%@)',
                                                 SysCtl(rtl.sys.CTL_KERN, rtl.sys.KERN_OSTYPE),
                                                 SysCtl(rtl.sys.CTL_KERN, rtl.sys.KERN_OSRELEASE),
                                                 SysCtl(rtl.sys.CTL_KERN, rtl.sys.KERN_OSVERSION));
 end;

class method Environment.GetEnvironmentVariable(aVariableName: String): String;
begin
  result := Foundation.NSProcessInfo.processInfo:environment:objectForKey(aVariableName);
end;
{$ENDIF}

end.

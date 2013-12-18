namespace Sugar;

interface

type
  {$IF COOPER}
  Environment = public class
  public 
    class property NewLine: String read System.getProperty("line.separator");
    class property UserName: String read System.getProperty("user.name");
    class property OperatingSystemName: String read System.getProperty("os.name");
    class property OperatingSystemVersion: String read System.getProperty("os.version");
    class property TargetPlatform: TargetPlatform read TargetPlatform.Java;
    class property TargetPlatforName: String read 'Java';
    class method GetEnvironmentVariable(aVariableName: String): String;
    {$IF ANDROID}
    class property AppContext: android.content.Context read write;
    {$ENDIF}
  {$ELSEIF ECHOES}
  Environment = public class mapped to System.Environment
  private
    {$IF NETFX_CORE}class method GetUserName: String;{$ENDIF}
  public
    class property NewLine: String read mapped.NewLine;
    class property UserName: String read {$IF WINDOWS_PHONE}""{$ELSEIF NETFX_CORE}GetUserName{$ELSE}mapped.UserName{$ENDIF};
    class property OperatingSystemName: String read {$IF NETFX_CORE}"Microsoft Windows NT 6.2"{$ELSE}mapped.OSVersion.Platform.ToString(){$ENDIF};
    class property OperatingSystemVersion: String read {$IF NETFX_CORE}"6.2"{$ELSE}mapped.OSVersion.Version.ToString(){$ENDIF};
    class property TargetPlatform: TargetPlatform read TargetPlatform.Net;
    class property TargetPlatforName: String read '.NET';
    class property IsMono: Boolean read assigned(&Type.GetType('Mono.Runtime'));
    {$IF NOT (WINDOWS_PHONE OR NETFX_CORE)}class method GetEnvironmentVariable(aVariableName: String): String; mapped to GetEnvironmentVariable(aVariableName);{$ENDIF}
  {$ELSEIF NOUGAT}
  Environment = public class
  private
    class method getOperatingSystemVersion: String;
    class method getOperatingSystemName: String;
  public 
    {$REGION OS-specific Helper APIs}
    class method SysCtl(aLevel: Int32; aValue: Int32): String;
    {$ENDREGION}

    class property NewLine: String read Sugar.String(#10);
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

{$IF COOPER}
class method Environment.GetEnvironmentVariable(aVariableName: String): String;
begin
  exit System.getenv(aVariableName);
end;
{$ENDIF}

{$IF NETFX_CORE}
class method Environment.GetUserName: String;
begin
  //var task := await Windows.System.UserProfile.UserInformation.GetDisplayNameAsync;
  //exit task;
  exit "";
end;
{$ENDIF}

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
  var namelen: rtl.u_int := sizeOf(mib) / sizeOf(mib[0]);
  
  var bufferSize: size_t := 0;

  rtl.sysctl(@mib, namelen, nil, @bufferSize, nil, 0);
  var buildBuffer := new rtl.u_char[bufferSize];
  if rtl.sysctl(mib, namelen, buildBuffer, @bufferSize, nil, 0) = 0 then
    result := Foundation.NSString.alloc.initWithBytes(buildBuffer) length(bufferSize) encoding(Foundation.NSStringEncoding.NSUTF8StringEncoding);
 end;

class method Environment.getOperatingSystemVersion: String;
begin
  result := Foundation.NSString.stringWithFormat('%@ %@ (%@)',
                                                 SysCtl(rtl.CTL_KERN, rtl.KERN_OSTYPE),
                                                 SysCtl(rtl.CTL_KERN, rtl.KERN_OSRELEASE),
                                                 SysCtl(rtl.CTL_KERN, rtl.KERN_OSVERSION));
end;

class method Environment.GetEnvironmentVariable(aVariableName: String): String;
begin
  result := Foundation.NSProcessInfo.processInfo:environment:objectForKey(aVariableName);
end;
{$ENDIF}

end.

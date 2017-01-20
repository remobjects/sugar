namespace Sugar;

interface

uses
  Sugar.IO;

type
  TargetPlatform = public enum(Net, Java, macOS, OSX = macOS, iOS, tvOS, watchOS, Android, WinRT, WindowsPhone);
  CompilerMode = public enum(Echoes, Toffee, Cooper, Island);
  CompilerSubMode = public enum(NetFull, NetCore, WinRT, WindowsPhone, macOS, iOS, tvOS, watchOS, PlainJava, Android, Windows, Linux);
  OperatingSystem = public enum(Unknown, Windows, Linux, macOS, iOS, tvOS, watchOS, Android, WindowsPhone, Xbox);

  Environment = public static class
  private
    class method GetNewLine: Sugar.String;
    class method GetUserName: Sugar.String;
    class method GetOS: OperatingSystem;
    class method GetOSName: Sugar.String;
    class method GetOSVersion: Sugar.String;
    class method GetTargetPlatform: Sugar.TargetPlatform;
    class method GetTargetPlatformName: Sugar.String;
    class method GetCompilerSubMode: CompilerSubMode;

    {$IF ECHOES}
    [System.Runtime.InteropServices.DllImport("libc")]
    class method uname(buf: IntPtr): Integer; external;
    class method unameWrapper: String;
    class var unameResult: String;
    {$ENDIF}
  public
    property NewLine: String read GetNewLine;
    property UserName: String read GetUserName;
    property OS: OperatingSystem read GetOS;
    property OSName: String read GetOSName;
    property OSVersion: String read GetOSVersion;
    property TargetPlatform: TargetPlatform read GetTargetPlatform;
    property TargetPlatformName: String read GetTargetPlatformName;
    property CompilerMode: CompilerMode read {$IF ECHOES}CompilerMode.Echoes{$ELSEIF TOFFEE}CompilerMode.Toffee{$ELSEIF COOPER}CompilerMode.Cooper{$ELSEIF ISLAND}CompilerMode.Island{$ENDIF};
    property CompilerSubMode: CompilerSubMode read GetCompilerSubMode;
    property ApplicationContext: {$IF ANDROID}android.content.Context{$ELSE}Object{$ENDIF} read write;

    method GetEnvironmentVariable(Name: String): String;
    method CurrentDirectory: String;
  end;

implementation

class method Environment.GetEnvironmentVariable(Name: String): String;
begin
  {$IF COOPER}
  exit System.getenv(Name);
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  raise new SugarNotSupportedException("GetEnvironmentVariable not supported on this platfrom");
  {$ELSEIF ECHOES}
  exit System.Environment.GetEnvironmentVariable(Name);
  {$ELSEIF TOFFEE}
  exit Foundation.NSProcessInfo.processInfo:environment:objectForKey(Name);
  {$ENDIF}
end;

class method Environment.GetNewLine: String;
begin
  {$IF COOPER}
  exit System.getProperty("line.separator");
  {$ELSEIF ECHOES}
  exit System.Environment.NewLine;
  {$ELSEIF TOFFEE}
  exit Sugar.String(#10);
  {$ENDIF}
end;

class method Environment.GetUserName: String;
begin
  {$IF ANDROID}
  SugarAppContextMissingException.RaiseIfMissing;

  var Manager := android.accounts.AccountManager.get(ApplicationContext);
  var Accounts := Manager.Accounts;

  if Accounts.length = 0 then
    exit "";

  exit Accounts[0].name;
  {$ELSEIF COOPER}
  exit System.getProperty("user.name");
  {$ELSEIF WINDOWS_PHONE}
  exit Windows.Networking.Proximity.PeerFinder.DisplayName;
  {$ELSEIF NETFX_CORE}
  exit Windows.System.UserProfile.UserInformation.GetDisplayNameAsync.Await;
  {$ELSEIF ECHOES}
  exit System.Environment.UserName;
  {$ELSEIF OSX}
  exit Foundation.NSUserName;
  {$ELSEIF IOS}
  exit UIKit.UIDevice.currentDevice.name;
  {$ELSEIF WATCHOS}
  exit "Apple Watch";
  {$ELSEIF tvOS}
  exit "Apple TV";
  {$ENDIF}
end;

class method Environment.GetOS: OperatingSystem;
begin
  {$IF ANDROID}
  exit OperatingSystem.Android
  {$ELSEIF COOPER}
  var lOSName := Sugar.String(System.getProperty("os.name")):ToLowerInvariant;
  if lOSName.Contains("windows") then exit OperatingSystem.Windows
  else if lOSName.Contains("linux") then exit OperatingSystem.Linux
  else if lOSName.Contains("mac") then exit OperatingSystem.macOS
  else exit OperatingSystem.Unknown;
  {$ELSEIF WINDOWS_PHONE}
  exit OperatingSystem.WindowsPhone;
  {$ELSEIF NETFX_CORE}
  exit OperatingSystem.Windows
  {$ELSEIF ECHOES}
  case System.Environment.OSVersion.Platform of
    PlatformID.WinCE,
    PlatformID.Win32NT,
    PlatformID.Win32S,
    PlatformID.Win32Windows: exit OperatingSystem.Windows;
    PlatformID.Xbox: exit OperatingSystem.Xbox;
    else begin
      case unameWrapper() of
        "Linux": exit OperatingSystem.Linux;
        "Darwin": exit OperatingSystem.macOS;
        else exit OperatingSystem.Unknown;
      end;
    end;
  end;
  {$ELSEIF TOFFEE}
    {$IF OSX}
    exit OperatingSystem.macOS;
    {$ELSEIF IOS}
    exit OperatingSystem.iOS;
    {$ELSEIF WATCHOS}
    exit OperatingSystem.watchOS;
    {$ELSEIF TVOS}
    exit OperatingSystem.tvOS;
    {$ENDIF}
  {$ELSEIF ISLAND}
    {$IF WINDOWS}
    exit OperatingSystem.Windows;
    {$ELSEIF IOS}
    exit OperatingSystem.Linux;
    {$ENDIF}
  {$ENDIF}
end;

{$IF ECHOES}
class method Environment.unameWrapper: String;
begin
  if not assigned(unameResult) then begin
    var lBuffer := IntPtr.Zero;
    try
      lBuffer := System.Runtime.InteropServices.Marshal.AllocHGlobal(8192);
      if uname(lBuffer) = 0 then
        unameResult := System.Runtime.InteropServices.Marshal.PtrToStringAnsi(lBuffer);
    except
    finally
      if lBuffer ≠ IntPtr.Zero then
        System.Runtime.InteropServices.Marshal.FreeHGlobal(lBuffer);
    end;
  end;
  result := unameResult;
end;
{$ENDIF}

class method Environment.GetOSName: String;
begin
  {$IF COOPER}
  exit System.getProperty("os.name");
  {$ELSEIF WINDOWS_PHONE}
  exit System.Environment.OSVersion.Platform.ToString();
  {$ELSEIF NETFX_CORE}
  exit "Microsoft Windows NT 6.2";
  {$ELSEIF ECHOES}
  exit System.Environment.OSVersion.Platform.ToString();
  {$ELSEIF TOFFEE}
    {$IF OSX}
    exit "macOS";
    {$ELSEIF IOS}
    exit "iOS";
    {$ELSEIF WATCHOS}
    exit "watchOS";
    {$ELSEIF TVOS}
    exit "tvOS";
    {$ENDIF}
  {$ELSEIF ISLAND}
    {$IF WINDOWS}
    exit "Windows";
    {$ELSEIF IOS}
    exit "Linux";
    {$ENDIF}
  {$ENDIF}
end;

class method Environment.GetOSVersion: String;
begin
  {$IF COOPER}
  System.getProperty("os.version");
  {$ELSEIF WINDOWS_PHONE}
  exit System.Environment.OSVersion.Version.ToString;
  {$ELSEIF NETFX_CORE}
  exit "6.2";
  {$ELSEIF ECHOES}
  exit System.Environment.OSVersion.Version.ToString;
  {$ELSEIF TOFFEE}
  exit NSProcessInfo.processInfo.operatingSystemVersionString;
  {$ENDIF}
end;

class method Environment.GetTargetPlatform: TargetPlatform;
begin
  exit{$IF ANDROID}
  TargetPlatform.Android
  {$ELSEIF COOPER}
  TargetPlatform.Java
  {$ELSEIF WINDOWS_PHONE}
  TargetPlatform.WindowsPhone
  {$ELSEIF NETFX_CORE}
  TargetPlatform.WinRT
  {$ELSEIF ECHOES}
  TargetPlatform.Net
  {$ELSEIF OSX}
  TargetPlatform.OSX
  {$ELSEIF IOS}
  TargetPlatform.iOS
  {$ELSEIF WATCHOS}
  TargetPlatform.watchOS
  {$ELSEIF TVOS}
  TargetPlatform.tvOS
  {$ENDIF};
end;

class method Environment.GetTargetPlatformName: String;
begin
  exit{$IF ANDROID}
  "Android"
  {$ELSEIF COOPER}
  "Java"
  {$ELSEIF WINDOWS_PHONE}
  "Windows Phone Runtime"
  {$ELSEIF NETFX_CORE}
  "Windows Runtime"
  {$ELSEIF ECHOES}
  ".NET"
  {$ELSEIF OSX}
  "Cocoa"
  {$ELSEIF IOS or WATCHIOS or TVOS}
  "Cocoa Touch"
  {$ENDIF};
end;

class method Environment.GetCompilerSubMode: CompilerSubMode;
begin
  {$IF COOPER}
    {$IF ANDROID}
    exit CompilerSubMode.Android
    {$ELSE}
    exit CompilerSubMode.PlainJava;
    {$ENDIF}
  {$ELSEIF ECHOES}
    {$IF WINDOWS_PHONE}
    exit CompilerSubMode.WindowsPhone;
    {$ELSEIF NETFX_CORE}
    exit CompilerSubMode.WinRT;
    {$ELSE}
    exit CompilerSubMode.NetFull;
    {$ENDIF}
  {$ELSEIF TOFFEE}
    {$IF OSX}
    exit CompilerSubMode.macOS;
    {$ELSEIF IOS}
    exit CompilerSubMode.iOS;
    {$ELSEIF WATCHOS}
    exit CompilerSubMode.watchOS;
    {$ELSEIF TVOS}
    exit CompilerSubMode.tvOS;
    {$ENDIF}
  {$ELSEIF ISLAND}
    {$IF WINDOWS}
    exit CompilerSubMode.Windows;
    {$ELSEIF LINUX}
    exit CompilerSubMode.Linux;
    {$ELSE}
      {$ERROR Unsupported CompilerSubMode}
    {$ENDIF}
  {$ELSE}
    {$ERROR Unsupported CompilerMode}
  {$ENDIF}
end;

class method Environment.CurrentDirectory(): String;
begin
  {$IF COOPER}
  exit System.getProperty("user.dir");
  {$ELSEIF NETFX_CORE}
  exit Windows.Storage.ApplicationData.Current.LocalFolder.Path;
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  exit System.Environment.CurrentDirectory;
  {$ELSEIF ECHOES}
  exit System.Environment.CurrentDirectory;
  {$ELSEIF TOFFEE}
  exit Foundation.NSFileManager.defaultManager().currentDirectoryPath;
  {$ENDIF}
end;

end.
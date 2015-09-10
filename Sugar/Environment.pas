namespace Sugar;

interface

uses
  Sugar.IO;

type
  TargetPlatform = public enum(Net, Java, OSX, iOS, watchOS, Android, WinRT, WindowsPhone);

  Environment = public static class
  private
    class method GetNewLine: Sugar.String;
    class method GetUserName: Sugar.String;
    class method GetOSName: Sugar.String;
    class method GetOSVersion: Sugar.String;
    class method GetTargetPlatform: Sugar.TargetPlatform;
    class method GetTargetPlatformName: Sugar.String;
  public
    property NewLine: String read GetNewLine;
    property UserName: String read GetUserName;
    property OSName: String read GetOSName;
    property OSVersion: String read GetOSVersion;
    property TargetPlatform: TargetPlatform read GetTargetPlatform;
    property TargetPlatformName: String read GetTargetPlatformName;
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
  {$ELSEIF NOUGAT}
  exit Foundation.NSProcessInfo.processInfo:environment:objectForKey(Name);
  {$ENDIF}
end;

class method Environment.GetNewLine: String;
begin
  {$IF COOPER}
  exit System.getProperty("line.separator");
  {$ELSEIF ECHOES}
  exit System.Environment.NewLine;
  {$ELSEIF NOUGAT}
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
  {$ELSEIF OSX}
  exit "OS X";
  {$ELSEIF IOS}
  exit "iOS";
  {$ELSEIF WATCHOS}
  exit "watchOS";
  {$ELSEIF TVOS}
  exit "tvOS";
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
  {$ELSEIF NOUGAT}
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
  {$ELSEIF NOUGAT}
  exit Foundation.NSFileManager.defaultManager().currentDirectoryPath;
  {$ENDIF}
end;

end.
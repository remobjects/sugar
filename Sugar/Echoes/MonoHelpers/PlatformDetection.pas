namespace RemObjects.Sugar.MonoHelpers;

// Parts based on code by MJ Hutchinson http://mjhutchinson.com/journal/2010/01/25/integrating_gtk_application_mac
// This code has been converted from C# from https://github.com/remobjects/monohelpers

{$IF NOT ECHOES}
  {ERROR This units is intended for Echoes (Mono) only}
{$ENDIF}

interface

uses
  System.Collections.Generic,
  System.IO,
  System.Linq,
  System.Text,
  System.Runtime.InteropServices;

type
  PlatformType = assembly enum(
    Windows, 
    WinCE, 
    XBox, 
    Mac, 
    Linux, 
    UnixUnknown, 
    Unknown
  );

  PlatformSupport = assembly static class
  private
    [DllImport('libc')]
    method uname(buf: IntPtr): System.Int32; external;
    method intuname: System.String;
    constructor;

  assembly
    property Platform: PlatformType; readonly;
    property UNameResult: System.String; readonly;
  end;

implementation

method PlatformSupport.intuname: System.String;
begin
  var buf: IntPtr := IntPtr.Zero;
  try
    buf := System.Runtime.InteropServices.Marshal.AllocHGlobal(8192);
// This is a hacktastic way of getting sysname from uname ()
    if uname(buf) = 0 then begin
      exit System.Runtime.InteropServices.Marshal.PtrToStringAnsi(buf)
    end
  finally
    if buf <> IntPtr.Zero then      System.Runtime.InteropServices.Marshal.FreeHGlobal(buf)
  
  except begin
    end;
  end;
  exit nil
end;

constructor PlatformSupport;
begin
  case Environment.OSVersion.Platform of 
    PlatformID.WinCE: begin
        Platform := PlatformType.WinCE;
      end;
    PlatformID.Win32NT: begin
        Platform := PlatformType.Windows;
      end;
    PlatformID.Win32S: begin
        Platform := PlatformType.Windows;
      end;
    PlatformID.Win32Windows: begin
        Platform := PlatformType.Windows;
      end;
    PlatformID.Xbox: begin
        Platform := PlatformType.XBox;
      end
    else begin
      UNameResult := intuname();
      if UNameResult = nil then Platform := PlatformType.Unknown
      else if UNameResult = 'Linux' then
        Platform := PlatformType.Linux
      else if UNameResult = 'Darwin' then
        Platform := PlatformType.Mac
      else Platform := PlatformType.UnixUnknown;
    end;
  end;
end;

end.

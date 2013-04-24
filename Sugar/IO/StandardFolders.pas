namespace RemObjects.Oxygene.Sugar.IO;

interface

{ToDo: The Echoes implementations need platform checks and call proper APIs on Linux and Mac}

type
  Folder = public class mapped to {$IF WINDOWS_PHONE}Windows.Storage.StorageFolder{$ELSE}String{$ENDIF}
  end;

  StandardFolders = public static class
  private
    {$IF ECHOES AND NOT WINDOWS_PHONE}
    [System.Runtime.InteropServices.DllImport("shell32.dll", CharSet := System.Runtime.InteropServices.CharSet.Unicode)]
    class method SHGetKnownFolderPath([System.Runtime.InteropServices.MarshalAs(System.Runtime.InteropServices.UnmanagedType.LPStruct)] rfid: Guid; dwFlags: UInt32; hToken: IntPtr; out pszPath: String): Int32; external;
    {$ENDIF}

    {$IF NOUGAT}
    method GetSystemPath(aDirectory: Foundation.NSSearchPathDirectory; aDomainMask: Foundation.NSSearchPathDomainMask): Folder;
    {$ENDIF}
  protected
  public
    method UserLocal: Folder;
    method UserRoaming: Folder;
    method UserApplicationData: Folder;
    method UserDesktop: Folder;
    method UserDocuments: Folder;
    method UserDownloads: Folder; 
  end;

implementation


{$IF NOUGAT}
class method StandardFolders.GetSystemPath(aDirectory: Foundation.NSSearchPathDirectory; aDomainMask: Foundation.NSSearchPathDomainMask): Folder;
begin
  var lPaths := Foundation.NSSearchPathForDirectoriesInDomains(aDirectory, aDomainMask, true);
  if lPaths.count > 0 then result := lPaths[0];
end;
{$ENDIF}

method StandardFolders.UserLocal: Folder;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  result := GetSystemPath(NSSearchPathDirectory.NSUserDirectory, NSSearchPathDomainMask.NSUserDomainMask);
  {$ENDIF}
end;

method StandardFolders.UserRoaming: Folder;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
    {$IF WINDOWS_PHONE}
    //result := Windows.Storage.KnownFolders.
    {$ELSE}
    result := Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData);
    {$ENDIF}
  {$ELSEIF NOUGAT}
  //result := GetSystemPath(NSSearchPathDirectory.NSApplicationSupportDirectory, NSSearchPathDomainMask.NSUserDomainMask);
  {$ENDIF}
end;

method StandardFolders.UserApplicationData: Folder;
begin

  {$IF COOPER}
  {$ELSEIF ECHOES}
    {$IF WINDOWS_PHONE}
    //result := Windows.Storage.KnownFolders.
    {$ELSE}
    result := Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
    {$ENDIF}
  {$ELSEIF NOUGAT}
  result := GetSystemPath(NSSearchPathDirectory.NSApplicationSupportDirectory, NSSearchPathDomainMask.NSUserDomainMask);
  {$ENDIF}
end;

method StandardFolders.UserDesktop: Folder;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
    {$IF WINDOWS_PHONE}
    //result := Windows.Storage.KnownFolders.
    {$ELSE}
    result := Environment.GetFolderPath(Environment.SpecialFolder.DesktopDirectory);
    {$ENDIF}
  {$ELSEIF NOUGAT}
  result := GetSystemPath(NSSearchPathDirectory.NSDesktopDirectory, NSSearchPathDomainMask.NSUserDomainMask);
  {$ENDIF}
end;

method StandardFolders.UserDocuments: Folder;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
    {$IF WINDOWS_PHONE}
    result := Windows.Storage.KnownFolders.DocumentsLibrary
    {$ELSE}
    result := Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments);
    {$ENDIF}
  {$ELSEIF NOUGAT}
  result := GetSystemPath(NSSearchPathDirectory.NSDocumentDirectory, NSSearchPathDomainMask.NSUserDomainMask);
  {$ENDIF}
end;

method StandardFolders.UserDownloads: Folder;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES AND NOT WINDOWS_PHONE}
  var KNOWN_FOLDER_DOWNLOADS := new Guid("374DE290-123F-4565-9164-39C4925E467B");
  var lResult: String;
  SHGetKnownFolderPath(KNOWN_FOLDER_DOWNLOADS, 0, IntPtr.Zero, out lResult);
  result := lResult;
  {$ELSEIF NOUGAT}
  result := GetSystemPath(NSSearchPathDirectory.NSDownloadsDirectory, NSSearchPathDomainMask.NSUserDomainMask);
  {$ENDIF}
end;

end.

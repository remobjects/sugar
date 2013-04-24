namespace RemObjects.Sugar.MonoHelpers;

// This code has been converted from C# from https://github.com/remobjects/monohelpers

{$IF NOT ECHOES}
  {ERROR This units is intended for Echoes (Mono) only}
{$ENDIF}

interface

uses
  System.Collections.Generic,
  System.Linq,
  System.Text,
  System.Runtime.InteropServices;

type
  MacDomains = assembly enum(
    kSystemDomain = -32766, // Usually the root (like /Library/Application Support)
    kLocalDomain = -32765, 
    kNetworkDomain = -32764, 
    kUserDomain = -32763, // Inside the user directory (/Users/username/Library/Application Support)
    kClassicDomain = -32762
  );

  MacFolderTypes = assembly static class
  assembly
    var kUsersFolderType: System.UInt32 := FourCharCode('usrs'); readonly; // "Users" folder, usually contains one folder for each user. 
    var kDesktopFolderType: System.UInt32 := FourCharCode('desk'); readonly; // the desktop folder; objects in this folder show on the desktop. 
    var kApplicationSupportFolderType: System.UInt32 := FourCharCode('asup'); readonly;
    var kDocumentationFolderType: System.UInt32 := FourCharCode('info'); readonly;
    var kDownloadsFolderType: System.UInt32 := FourCharCode('down'); readonly;
   {var kTrashFolderType: System.UInt32 := FourCharCode('trsh'); readonly; // the trash folder; objects in this folder show up in the trash 
    var kWhereToEmptyTrashFolderType: System.UInt32 := FourCharCode('empt'); readonly; // the "empty trash" folder; Finder starts empty from here down 
    var kFontsFolderType: System.UInt32 := FourCharCode('font'); readonly; // Fonts go here 
    var kPreferencesFolderType: System.UInt32 := FourCharCode('pref'); readonly; // preferences for applications go here 
    var kSystemPreferencesFolderType: System.UInt32 := FourCharCode('sprf'); readonly; // the PreferencePanes folder, where Mac OS X Preference Panes go 
    var kTemporaryFolderType: System.UInt32 := FourCharCode('temp'); readonly;

    var kTemporaryItemsInCacheDataFolderType: System.UInt32 := FourCharCode('vtmp'); readonly; // A folder inside the kCachedDataFolderType for the given domain which can be used for transient data
    var kApplicationsFolderType: System.UInt32 := FourCharCode('apps'); readonly; //    Applications on Mac OS X are typically put in this folder ( or a subfolder ).
    var kVolumeRootFolderType: System.UInt32 := FourCharCode('root'); readonly; // root folder of a volume or domain 
    var kDomainTopLevelFolderType: System.UInt32 := FourCharCode('dtop'); readonly; // The top-level of a Folder domain, e.g. "/System"
    var kDomainLibraryFolderType: System.UInt32 := FourCharCode('dlib'); readonly; // the Library subfolder of a particular domain
    var kCurrentUserFolderType: System.UInt32 := FourCharCode('cusr'); readonly; // The folder for the currently logged on user; domain passed in is ignored. 
    var kSharedUserDataFolderType: System.UInt32 := FourCharCode('sdat'); readonly; // A Shared folder, readable & writeable by all users 

    var kDocumentsFolderType: System.UInt32 := FourCharCode('docs'); readonly;
    var kFavoritesFolderType: System.UInt32 := FourCharCode('favs'); readonly;
    var kInstallerLogsFolderType: System.UInt32 := FourCharCode('ilgf'); readonly;
    var kFolderActionsFolderType: System.UInt32 := FourCharCode('fasf'); readonly;
    var kKeychainFolderType: System.UInt32 := FourCharCode('kchn'); readonly;
    var kColorSyncFolderType: System.UInt32 := FourCharCode('sync'); readonly;
    var kPrintersFolderType: System.UInt32 := FourCharCode('impr'); readonly;
    var kSpeechFolderType: System.UInt32 := FourCharCode('spch'); readonly;
    var kUserSpecificTmpFolderType: System.UInt32 := FourCharCode('utmp'); readonly;
    var kCachedDataFolderType: System.UInt32 := FourCharCode('cach'); readonly;
    var kFrameworksFolderType: System.UInt32 := FourCharCode('fram'); readonly;
    var kDeveloperFolderType: System.UInt32 := FourCharCode('devf'); readonly;
    var kSystemSoundsFolderType: System.UInt32 := FourCharCode('ssnd'); readonly;
    var kComponentsFolderType: System.UInt32 := FourCharCode('cmpd'); readonly;
    var kQuickTimeComponentsFolderType: System.UInt32 := FourCharCode('wcmp'); readonly;
    var kPictureDocumentsFolderType: System.UInt32 := FourCharCode('pdoc'); readonly;
    var kMovieDocumentsFolderType: System.UInt32 := FourCharCode('mdoc'); readonly;
    var kMusicDocumentsFolderType: System.UInt32 := FourCharCode(#181'doc'); readonly;
    var kInternetSitesFolderType: System.UInt32 := FourCharCode('site'); readonly;
    var kPublicFolderType: System.UInt32 := FourCharCode('pubb'); readonly;
    var kAudioSupportFolderType: System.UInt32 := FourCharCode('adio'); readonly;
    var kAudioSoundsFolderType: System.UInt32 := FourCharCode('asnd'); readonly;
    var kAudioSoundBanksFolderType: System.UInt32 := FourCharCode('bank'); readonly;
    var kAudioAlertSoundsFolderType: System.UInt32 := FourCharCode('alrt'); readonly;
    var kAudioPlugInsFolderType: System.UInt32 := FourCharCode('aplg'); readonly;
    var kAudioComponentsFolderType: System.UInt32 := FourCharCode('acmp'); readonly;
    var kKernelExtensionsFolderType: System.UInt32 := FourCharCode('kext'); readonly;
    var kInstallerReceiptsFolderType: System.UInt32 := FourCharCode('rcpt'); readonly;
    var kFileSystemSupportFolderType: System.UInt32 := FourCharCode('fsys'); readonly;
    var kMIDIDriversFolderType: System.UInt32 := FourCharCode('midi'); readonly;}
    
    method FourCharCode(p: System.String): System.UInt32;
  end;

  MacFolders = assembly static class
  private
    const kCFURLPOSIXPathStyle: Int32 = 0;
    const CoreServices: System.String = '/System/Library/Frameworks/CoreServices.framework/Versions/A/CoreServices';

    [DllImport(CoreServices, EntryPoint := 'FSFindFolder')]
    method FSFindFolder(vRefNum: MacDomains; folderType: System.UInt32; createFolder: System.Boolean; out foundRef: FSRef): System.Int16; external;

    [DllImport(CoreFoundation.CFLib, EntryPoint := 'CFURLCreateFromFSRef')]
    method CFURLCreateFromFSRef(allocator: IntPtr; var fsRef: FSRef): IntPtr; external;

    [DllImport(CoreFoundation.CFLib, EntryPoint := 'CFURLCopyFileSystemPath')]
    method CFURLCopyFileSystemPath(anURL: IntPtr; pathStyle: System.Int32): IntPtr; external;

    [DllImport(CoreFoundation.CFLib, EntryPoint := 'CFStringGetLength')]
    method CFStringGetLength(theString: IntPtr): System.Int32; external;

    [DllImport(CoreFoundation.CFLib, EntryPoint := 'CFStringGetCharacters')]
    method CFStringGetCharacters(theString: IntPtr; range: CFRange;     [&Out()]buffer: array of System.Char); external;

  assembly
    method GetFolder(domain: MacDomains; folderType: System.UInt32): System.String;
  end;

type
  [StructLayout(LayoutKind.Sequential, Pack := 1)]
  CFRange nested in MacFolders = private record
  assembly
    var location: System.Int32;
    var length: System.Int32;
  end;

  [StructLayout(LayoutKind.Explicit, Size := 80)]
  FSRef nested in MacFolders = private record
  end;

implementation

method MacFolderTypes.FourCharCode(p: System.String): System.UInt32;
begin
  {$OVERFLOW OFF} 
  begin
    exit System.Byte(p[3]) or (System.UInt32(p[2])) shl 8 or (System.UInt32(p[1])) shl 16 or (System.UInt32(p[0])) shl 24
  end
  {$OVERFLOW DEFAULT}
end;

method MacFolders.GetFolder(domain: MacDomains; folderType: System.UInt32): System.String;
begin
  var reference: FSRef;
  var no: System.Int32 := FSFindFolder(domain, folderType, false, out reference);

  if no <> 0 then raise new Exception(System.String.Format('domain: {0} type: {1} return: {2}', domain, folderType, no));
  if no <> 0 then exit nil;

  var url: IntPtr := IntPtr.Zero;
  var str: IntPtr := IntPtr.Zero;
  try
    url := CFURLCreateFromFSRef(IntPtr.Zero, var reference);
    str := CFURLCopyFileSystemPath(url, kCFURLPOSIXPathStyle);

    var range: CFRange := new CFRange();
    range.location := 0;
    range.length := CFStringGetLength(str);

    var strdata: array of System.Char := new System.Char[range.length];
    CFStringGetCharacters(str, range, strdata);
    exit new String(strdata)
  finally
    if url <> IntPtr.Zero then CoreFoundation.Release(url);
    if str <> IntPtr.Zero then CoreFoundation.Release(str)
  end
end;

end.

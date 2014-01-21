namespace Sugar;

interface

{$IF NETFX_CORE}
uses
  System.Linq;
{$ENDIF}

type
  UserSettings = public class {$IF COOPER}{$IF NOT ANDROID}mapped to java.util.prefs.Preferences{$ENDIF}
  {$ELSEIF ECHOES}
  mapped to {$IF WINDOWS_PHONE}System.IO.IsolatedStorage.IsolatedStorageSettings{$ELSEIF NETFX_CORE}Windows.Storage.ApplicationDataContainer{$ELSE}System.Configuration.Configuration{$ENDIF}
  {$ELSEIF NOUGAT}
  mapped to Foundation.NSUserDefaults
  {$ENDIF}
  private
    method GetKeys: array of String;
    {$IF ANDROID}
    property Instance: android.content.SharedPreferences read write;
    constructor;
    constructor(anInstance: android.content.SharedPreferences);
    {$ELSEIF NOUGAT}
    method Exists(Key: String): Boolean;
    {$ENDIF}
  public
    method &Read(Key: String; DefaultValue: String): String;
    method &Read(Key: String; DefaultValue: Integer): Integer;
    method &Read(Key: String; DefaultValue: Boolean): Boolean;
    method &Read(Key: String; DefaultValue: Double): Double;

    method &Write(Key: String; Value: String);
    method &Write(Key: String; Value: Integer);
    method &Write(Key: String; Value: Boolean);
    method &Write(Key: String; Value: Double);

    method Save;
    method Clear;
    method &Remove(Key: String);
    property Keys: array of String read GetKeys;

    class method &Default: UserSettings;
  end;

  {$IF ECHOES AND NOT (WINDOWS_PHONE OR NETFX_CORE)}
  UserSettingsHelper = public static class
  private
    class property Instance: System.Configuration.Configuration read write;
  public
      method GetConfiguration: System.Configuration.Configuration;
  end;
  {$ELSEIF NOUGAT}
  UserSettingsHelper = public static class
  public
    method GetBundleIdentifier: String;
  end;
  {$ENDIF}

implementation

method UserSettings.Clear;
begin
  {$IF ANDROID}
  Instance.edit.clear.apply;
  {$ELSEIF COOPER}
  mapped.clear;
  {$ELSEIF WINDOWS_PHONE}
  mapped.Clear;
  {$ELSEIF NETFX_CORE}
  mapped.Values.Clear;
  {$ELSEIF ECHOES}
  mapped.AppSettings.Settings.Clear;
  {$ELSEIF NOUGAT}
  mapped.removePersistentDomainForName(UserSettingsHelper.GetBundleIdentifier);
  mapped.synchronize;
  {$ENDIF}
end;

class method UserSettings.&Default: UserSettings;
begin
  {$IF ANDROID}
  SugarArgumentNullException.RaiseIfNil(Environment.AppContext, "Environment.AppContext");
  exit new UserSettings(Environment.AppContext.getSharedPreferences("Sugar", android.content.Context.MODE_PRIVATE));
  {$ELSEIF COOPER}
  exit mapped.userRoot;
  {$ELSEIF WINDOWS_PHONE}
  exit mapped.ApplicationSettings;
  {$ELSEIF NETFX_CORE}
  exit Windows.Storage.ApplicationData.Current.LocalSettings;
  {$ELSEIF ECHOES}
  exit UserSettingsHelper.GetConfiguration;
  {$ELSEIF NOUGAT}
  exit mapped.standardUserDefaults;
  {$ENDIF}
end;

method UserSettings.GetKeys: array of String;
begin
  {$IF ANDROID}
  exit Instance.All.keySet.toArray(new String[0]);
  {$ELSEIF COOPER}
  exit mapped.keys;
  {$ELSEIF WINDOWS_PHONE}
  result := new String[mapped.ApplicationSettings.Keys.Count];
  var Count := 0;
  var Enumerator := mapped.ApplicationSettings.Keys.GetEnumerator;
  while Enumerator.MoveNext do begin
    result[Count] := String(Enumerator.Current);
    inc(Count);
  end;
  {$ELSEIF NETFX_CORE}
  exit mapped.Values.Keys.ToArray;
  {$ELSEIF ECHOES}
  exit mapped.AppSettings.Settings.AllKeys;
  {$ELSEIF NOUGAT}
  mapped.synchronize;
  var lValues := mapped.persistentDomainForName(UserSettingsHelper.GetBundleIdentifier):allKeys;
  if lValues = nil then
    exit [];

  result := new String[lValues.count];
  for i: Integer := 0 to lValues.count - 1 do
    result[i] := lValues.objectAtIndex(i);
  {$ENDIF}
end;

method UserSettings.&Read(Key: String; DefaultValue: Boolean): Boolean;
begin
  SugarArgumentNullException.RaiseIfNil(Key, "Key");
  {$IF ANDROID}  
  exit Instance.getBoolean(Key, DefaultValue);
  {$ELSEIF COOPER}
  exit mapped.getBoolean(Key, DefaultValue);
  {$ELSEIF WINDOWS_PHONE}
  if not mapped.TryGetValue<Boolean>(Key, out result) then
    exit DefaultValue;
  {$ELSEIF NETFX_CORE}
  if not mapped.Values.ContainsKey(Key) then 
    exit DefaultValue;

  exit Boolean(mapped.Values[Key]);
  {$ELSEIF ECHOES}
  if not Boolean.TryParse(mapped.AppSettings.Settings[Key]:Value, out Result) then
    exit DefaultValue;
  {$ELSEIF NOUGAT}
  result := iif(Exists(Key), mapped.boolForKey(Key), DefaultValue);
  {$ENDIF}
end;

method UserSettings.&Read(Key: String; DefaultValue: Double): Double;
begin
  SugarArgumentNullException.RaiseIfNil(Key, "Key");
  {$IF ANDROID}  
  exit Double.longBitsToDouble(Instance.getLong(Key, Double.doubleToRawLongBits(DefaultValue)));
  {$ELSEIF COOPER}
  exit mapped.getDouble(Key, DefaultValue);
  {$ELSEIF WINDOWS_PHONE}
  if not mapped.TryGetValue<Double>(Key, out result) then
    exit DefaultValue;
  {$ELSEIF NETFX_CORE}
  if not mapped.Values.ContainsKey(Key) then 
    exit DefaultValue;

  exit Double(mapped.Values[Key]);
  {$ELSEIF ECHOES}
  if not Double.TryParse(mapped.AppSettings.Settings[Key]:Value, out Result) then
    exit DefaultValue;
  {$ELSEIF NOUGAT}
  result := iif(Exists(Key), mapped.doubleForKey(Key), DefaultValue);
  {$ENDIF}
end;

method UserSettings.&Read(Key: String; DefaultValue: Integer): Integer;
begin
  SugarArgumentNullException.RaiseIfNil(Key, "Key");
  {$IF ANDROID}  
  exit Instance.getInt(Key, DefaultValue);
  {$ELSEIF COOPER}
  exit mapped.getInt(Key, DefaultValue);
  {$ELSEIF WINDOWS_PHONE}
  if not mapped.TryGetValue<Integer>(Key, out result) then
    exit DefaultValue;
  {$ELSEIF NETFX_CORE}
  if not mapped.Values.ContainsKey(Key) then 
    exit DefaultValue;

  exit Integer(mapped.Values[Key]);
  {$ELSEIF ECHOES}  
  if not Integer.TryParse(mapped.AppSettings.Settings[Key]:Value, out Result) then
    exit DefaultValue;
  {$ELSEIF NOUGAT}
  result := iif(Exists(Key), mapped.integerForKey(Key), DefaultValue);
  {$ENDIF}
end;

method UserSettings.&Read(Key: String; DefaultValue: String): String;
begin
  SugarArgumentNullException.RaiseIfNil(Key, "Key");
  {$IF ANDROID}  
  exit Instance.getString(Key, DefaultValue);
  {$ELSEIF COOPER}
  exit mapped.get(Key, DefaultValue);
  {$ELSEIF WINDOWS_PHONE}
  if not mapped.TryGetValue<String>(Key, out result) then
    exit DefaultValue;
  {$ELSEIF NETFX_CORE}
  if not mapped.Values.ContainsKey(Key) then 
    exit DefaultValue;

  exit String(mapped.Values[Key]);
  {$ELSEIF ECHOES}
  if mapped.AppSettings.Settings[Key] = nil then
    exit DefaultValue;

  exit mapped.AppSettings.Settings[Key].Value;
  {$ELSEIF NOUGAT}
  if Exists(Key) then
    exit mapped.stringForKey(Key)
  else
    exit DefaultValue;
  {$ENDIF}
end;

method UserSettings.&Remove(Key: String);
begin
  SugarArgumentNullException.RaiseIfNil(Key, "Key");
  {$IF ANDROID}  
  Instance.edit.remove(Key).apply;
  {$ELSEIF COOPER}
  mapped.remove(Key);
  {$ELSEIF WINDOWS_PHONE}
  mapped.Remove(Key);
  {$ELSEIF NETFX_CORE}
  mapped.Values.Remove(key);
  {$ELSEIF ECHOES}
  mapped.AppSettings.Settings.Remove(Key);
  {$ELSEIF NOUGAT}
  mapped.removeObjectForKey(Key);
  {$ENDIF}
end;

method UserSettings.Save;
begin
  {$IF ANDROID}
  {$ELSEIF COOPER}
  mapped.flush;
  {$ELSEIF WINDOWS_PHONE}
  mapped.Save;
  {$ELSEIF NETFX_CORE}
  {$ELSEIF ECHOES}
  mapped.Save(System.Configuration.ConfigurationSaveMode.Modified);
  {$ELSEIF NOUGAT}
  mapped.synchronize;
  {$ENDIF}
end;

method UserSettings.&Write(Key: String; Value: Boolean);
begin
  SugarArgumentNullException.RaiseIfNil(Key, "Key");
  {$IF ANDROID}  
  Instance.edit.putBoolean(Key, Value).apply;
  {$ELSEIF COOPER}
  mapped.putBoolean(Key, Value);
  {$ELSEIF WINDOWS_PHONE}
  mapped[Key] := Value;
  {$ELSEIF NETFX_CORE}
  mapped.Values[Key] := Value;
  {$ELSEIF ECHOES}
  &Write(Key, Value.ToString);
  {$ELSEIF NOUGAT}
  mapped.setBool(Value) forKey(Key);
  {$ENDIF}
end;

method UserSettings.&Write(Key: String; Value: Double);
begin
  SugarArgumentNullException.RaiseIfNil(Key, "Key");
  {$IF ANDROID}
  Instance.edit.putLong(Key, Double.doubleToRawLongBits(Value)).apply;
  {$ELSEIF COOPER}
  mapped.putDouble(Key, Value);
  {$ELSEIF WINDOWS_PHONE}
  mapped[Key] := Value;
  {$ELSEIF NETFX_CORE}
  mapped.Values[Key] := Value;
  {$ELSEIF ECHOES}
  &Write(Key, Value.ToString);
  {$ELSEIF NOUGAT}
  mapped.setDouble(Value) forKey(Key);
  {$ENDIF}
end;

method UserSettings.&Write(Key: String; Value: Integer);
begin
  SugarArgumentNullException.RaiseIfNil(Key, "Key");
  {$IF ANDROID}  
  Instance.edit.putInt(Key, Value).apply;
  {$ELSEIF COOPER}
  mapped.putInt(Key, Value);
  {$ELSEIF WINDOWS_PHONE}
  mapped[Key] := Value;
  {$ELSEIF NETFX_CORE}
  mapped.Values[Key] := Value;
  {$ELSEIF ECHOES}
  &Write(Key, Value.ToString);
  {$ELSEIF NOUGAT}  
  mapped.setInteger(Value) forKey(Key);
  {$ENDIF}
end;

method UserSettings.&Write(Key: String; Value: String);
begin
  SugarArgumentNullException.RaiseIfNil(Key, "Key");
  {$IF ANDROID}  
  Instance.edit.putString(Key, Value).apply;
  {$ELSEIF COOPER}
  mapped.put(Key, Value);
  {$ELSEIF WINDOWS_PHONE}
  mapped[Key] := Value;
  {$ELSEIF NETFX_CORE}
  mapped.Values[Key] := Value;
  {$ELSEIF ECHOES}
  if mapped.AppSettings.Settings[Key] = nil then
    mapped.AppSettings.Settings.Add(Key, Value)
  else
    mapped.AppSettings.Settings[Key].Value := Value.ToString;
  {$ELSEIF NOUGAT}
  mapped.setObject(Value) forKey(Key);
  {$ENDIF}
end;

{$IF ECHOES AND NOT (WINDOWS_PHONE OR NETFX_CORE)}
class method UserSettingsHelper.GetConfiguration: System.Configuration.Configuration;
begin
  if Instance = nil then
    Instance := System.Configuration.ConfigurationManager.OpenExeConfiguration(System.Configuration.ConfigurationUserLevel.None);

  exit Instance;
end;
{$ELSEIF NOUGAT}
method UserSettings.Exists(Key: String): Boolean;
begin
  SugarArgumentNullException.RaiseIfNil(Key, "Key");
  exit mapped.objectForKey(Key) <> nil;
end;

class method UserSettingsHelper.GetBundleIdentifier: String;
begin
  result := Foundation.NSBundle.mainBundle.bundleIdentifier;
  if result = nil then
    result := Foundation.NSBundle.mainBundle.executablePath.lastPathComponent.stringByDeletingPathExtension;
end;
{$ELSEIF ANDROID}
constructor UserSettings;
begin
  constructor(nil);
end;

constructor UserSettings(anInstance: android.content.SharedPreferences);
begin
  SugarArgumentNullException.RaiseIfNil(anInstance, "Instance");
  Instance := anInstance;
end;
{$ENDIF}

end.

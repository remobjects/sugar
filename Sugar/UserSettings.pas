namespace Sugar;
{$HIDE W0} //supress case-mismatch errors
interface

{$IF NETFX_CORE}
uses
  System.Linq;
{$ENDIF}

type
  {$IF COOPER}
  {$IF ANDROID}
  UserSettings = public class //interface mapped to android.content.SharedPreferences
  private    
    method get_Keys: array of String;
    property Instance: android.content.SharedPreferences read write;
    constructor;
    constructor(anInstance: android.content.SharedPreferences);
  public
    method ReadString(Key: String; DefaultValue: String): String;
    method ReadInteger(Key: String; DefaultValue: Integer): Integer;
    method ReadBoolean(Key: String; DefaultValue: Boolean): Boolean;
    method ReadDouble(Key: String; DefaultValue: Double): Double;

    method WriteString(Key: String; Value: String);
    method WriteInteger(Key: String; Value: Integer);
    method WriteBoolean(Key: String; Value: Boolean);
    method WriteDouble(Key: String; Value: Double);

    method Save; empty;
    method Clear;
    method &Remove(Key: String);
    property Keys: array of String read get_Keys;

    class method &Default: UserSettings;
  end;
  {$ELSE}
  UserSettings = public class mapped to java.util.prefs.Preferences
  public
    method ReadString(Key: String; DefaultValue: String): String; mapped to get(Key, DefaultValue);
    method ReadInteger(Key: String; DefaultValue: Integer): Integer; mapped to getInt(Key, DefaultValue);
    method ReadBoolean(Key: String; DefaultValue: Boolean): Boolean; mapped to getBoolean(Key, DefaultValue);
    method ReadDouble(Key: String; DefaultValue: Double): Double; mapped to getDouble(Key, DefaultValue);

    method WriteString(Key: String; Value: String); mapped to put(Key, Value);
    method WriteInteger(Key: String; Value: Integer); mapped to putInt(Key, Value);
    method WriteBoolean(Key: String; Value: Boolean); mapped to putBoolean(Key, Value);
    method WriteDouble(Key: String; Value: Double); mapped to putDouble(Key, Value);

    method Save; mapped to flush;
    method Clear; mapped to clear;
    method &Remove(Key: String); mapped to remove(Key);
    property Keys: array of String read mapped.keys;

    class method &Default: UserSettings; mapped to userRoot;
  end;
  {$ENDIF}
  {$ELSEIF ECHOES}    
    {$IF WINDOWS_PHONE}
    UserSettings = public class mapped to System.IO.IsolatedStorage.IsolatedStorageSettings
    private
      method get_Keys: array of String;
    public
      method ReadString(Key: String; DefaultValue: String): String;
      method ReadInteger(Key: String; DefaultValue: Integer): Integer;
      method ReadBoolean(Key: String; DefaultValue: Boolean): Boolean;
      method ReadDouble(Key: String; DefaultValue: Double): Double;

      method WriteString(Key: String; Value: String);
      method WriteInteger(Key: String; Value: Integer);
      method WriteBoolean(Key: String; Value: Boolean);
      method WriteDouble(Key: String; Value: Double);

      method Save; mapped to Save;
      method Clear; mapped to Clear;
      method &Remove(Key: String); mapped to &Remove(Key);
      property Keys: array of String read get_Keys;

      class method &Default: UserSettings;
    end;
    {$ELSEIF NETFX_CORE}
    UserSettings = public class mapped to Windows.Storage.ApplicationDataContainer
    public
      method ReadString(Key: String; DefaultValue: String): String;
      method ReadInteger(Key: String; DefaultValue: Integer): Integer;
      method ReadBoolean(Key: String; DefaultValue: Boolean): Boolean;
      method ReadDouble(Key: String; DefaultValue: Double): Double;

      method WriteString(Key: String; Value: String);
      method WriteInteger(Key: String; Value: Integer);
      method WriteBoolean(Key: String; Value: Boolean);
      method WriteDouble(Key: String; Value: Double);

      method Save; empty;
      method Clear;
      method &Remove(Key: String);
      property Keys: array of String read mapped.Values.Keys.ToArray;

      class method &Default: UserSettings;
    end;
    {$ELSE}
    UserSettings = public class mapped to System.Configuration.Configuration
    public
      method ReadString(Key: String; DefaultValue: String): String;
      method ReadInteger(Key: String; DefaultValue: Integer): Integer;
      method ReadBoolean(Key: String; DefaultValue: Boolean): Boolean;
      method ReadDouble(Key: String; DefaultValue: Double): Double;

      method WriteString(Key: String; Value: String);
      method WriteInteger(Key: String; Value: Integer);
      method WriteBoolean(Key: String; Value: Boolean);
      method WriteDouble(Key: String; Value: Double);

      method Save; mapped to Save(System.Configuration.ConfigurationSaveMode.Modified);
      method Clear;
      method &Remove(Key: String);
      property Keys: array of String read mapped.AppSettings.Settings.AllKeys;

      class method &Default: UserSettings;
    end;

    UserSettingsHelper = public static class
    private
      class property Instance: System.Configuration.Configuration read write;
    public
      method GetConfiguration: System.Configuration.Configuration;
    end;
    {$ENDIF}
  {$ELSEIF NOUGAT}
  UserSettings = public class mapped to Foundation.NSUserDefaults
  private
    method Exists(Key: String): Boolean;
    method GetKeys: array of String;
  public
    method ReadString(Key: String; DefaultValue: String): String;
    method ReadInteger(Key: String; DefaultValue: Integer): Integer;
    method ReadBoolean(Key: String; DefaultValue: Boolean): Boolean;
    method ReadDouble(Key: String; DefaultValue: Double): Double;

    method WriteString(Key: String; Value: String);
    method WriteInteger(Key: String; Value: Integer);
    method WriteBoolean(Key: String; Value: Boolean);
    method WriteDouble(Key: String; Value: Double);

    method Save; mapped to synchronize;
    method Clear;
    method &Remove(Key: String);
    property Keys: array of String read GetKeys;

    class method &Default: UserSettings; mapped to standardUserDefaults;
  end;

  UserSettingsHelper = public static class
  public
    method GetBundleIdentifier: String;
  end;
  {$ENDIF}

implementation

{$IF ANDROID}
constructor UserSettings;
begin
  constructor(nil);
end;

constructor UserSettings(anInstance: android.content.SharedPreferences);
begin
  SugarArgumentNullException.RaiseIfNil(anInstance, "Instance");
  Instance := anInstance;
end;

method UserSettings.Clear;
begin
  Instance.edit.clear.apply;
end;

class method UserSettings.&Default: UserSettings;
begin  
  SugarArgumentNullException.RaiseIfNil(Environment.AppContext, "Environment.AppContext");
  exit new UserSettings(Environment.AppContext.getSharedPreferences("Sugar", android.content.Context.MODE_PRIVATE));
end;

method UserSettings.get_Keys: array of String;
begin
  exit Instance.All.keySet.toArray(new String[0]);
end;

method UserSettings.ReadBoolean(Key: String; DefaultValue: Boolean): Boolean;
begin
  SugarArgumentNullException.RaiseIfNil(Key, "Key");
  exit Instance.getBoolean(Key, DefaultValue);
end;

method UserSettings.ReadDouble(Key: String; DefaultValue: Double): Double;
begin
  SugarArgumentNullException.RaiseIfNil(Key, "Key");
  exit Double.longBitsToDouble(Instance.getLong(Key, Double.doubleToRawLongBits(DefaultValue)));
end;

method UserSettings.ReadInteger(Key: String; DefaultValue: Integer): Integer;
begin
  SugarArgumentNullException.RaiseIfNil(Key, "Key");
  exit Instance.getInt(Key, DefaultValue);
end;

method UserSettings.ReadString(Key: String; DefaultValue: String): String;
begin
  SugarArgumentNullException.RaiseIfNil(Key, "Key");
  exit Instance.getString(Key, DefaultValue);
end;

method UserSettings.&Remove(Key: String);
begin
  SugarArgumentNullException.RaiseIfNil(Key, "Key");
  Instance.edit.remove(Key).apply;
end;

method UserSettings.WriteBoolean(Key: String; Value: Boolean);
begin
  SugarArgumentNullException.RaiseIfNil(Key, "Key");
  Instance.edit.putBoolean(Key, Value).apply;
end;

method UserSettings.WriteDouble(Key: String; Value: Double);
begin
  SugarArgumentNullException.RaiseIfNil(Key, "Key");
  Instance.edit.putLong(Key, Double.doubleToRawLongBits(Value)).apply;
end;

method UserSettings.WriteInteger(Key: String; Value: Integer);
begin
  SugarArgumentNullException.RaiseIfNil(Key, "Key");
  Instance.edit.putInt(Key, Value).apply;
end;

method UserSettings.WriteString(Key: String; Value: String);
begin
  SugarArgumentNullException.RaiseIfNil(Key, "Key");
  Instance.edit.putString(Key, Value).apply;
end;
{$ELSEIF ECHOES}
  {$IF WINDOWS_PHONE}
method UserSettings.ReadBoolean(Key: String; DefaultValue: Boolean): Boolean;
begin
  if not mapped.TryGetValue<Boolean>(Key, out result) then
    exit DefaultValue;
end;

method UserSettings.ReadDouble(Key: String; DefaultValue: Double): Double;
begin
  if not mapped.TryGetValue<Double>(Key, out result) then
    exit DefaultValue;
end;

method UserSettings.ReadInteger(Key: String; DefaultValue: Integer): Integer;
begin
  if not mapped.TryGetValue<Integer>(Key, out result) then
    exit DefaultValue;
end;

method UserSettings.ReadString(Key: String; DefaultValue: String): String;
begin
  if not mapped.TryGetValue<String>(Key, out result) then
    exit DefaultValue;
end;

class method UserSettings.&Default: UserSettings;
begin
  exit mapped.ApplicationSettings;
end;

method UserSettings.WriteBoolean(Key: String; Value: Boolean);
begin
  mapped[Key] := Value;
end;

method UserSettings.WriteDouble(Key: String; Value: Double);
begin
  mapped[Key] := Value;
end;

method UserSettings.WriteInteger(Key: String; Value: Integer);
begin
  mapped[Key] := Value;
end;

method UserSettings.WriteString(Key: String; Value: String);
begin
  mapped[Key] := Value;
end;

method UserSettings.get_Keys: array of String;
begin  
  result := new String[mapped.ApplicationSettings.Keys.Count];
  var Count := 0;
  var Enumerator := mapped.ApplicationSettings.Keys.GetEnumerator;
  while Enumerator.MoveNext do begin
    result[Count] := String(Enumerator.Current);
    inc(Count);
  end;
end;
  {$ELSEIF NETFX_CORE}
method UserSettings.ReadBoolean(Key: String; DefaultValue: Boolean): Boolean;
begin
  if not mapped.Values.ContainsKey(Key) then 
    exit DefaultValue;

  exit Boolean(mapped.Values[Key]);
end;

method UserSettings.ReadDouble(Key: String; DefaultValue: Double): Double;
begin
  if not mapped.Values.ContainsKey(Key) then 
    exit DefaultValue;

  exit Double(mapped.Values[Key]);
end;

method UserSettings.ReadInteger(Key: String; DefaultValue: Integer): Integer;
begin
  if not mapped.Values.ContainsKey(Key) then 
    exit DefaultValue;

  exit Integer(mapped.Values[Key]);
end;

method UserSettings.ReadString(Key: String; DefaultValue: String): String;
begin
  if not mapped.Values.ContainsKey(Key) then 
    exit DefaultValue;

  exit String(mapped.Values[Key]);
end;

class method UserSettings.&Default: UserSettings;
begin
  exit Windows.Storage.ApplicationData.Current.LocalSettings;
end;

method UserSettings.Clear;
begin
  mapped.Values.Clear;
end;

method UserSettings.&Remove(Key: String);
begin
  mapped.Values.Remove(key);
end;

method UserSettings.WriteBoolean(Key: String; Value: Boolean);
begin
  mapped.Values[Key] := Value;
end;

method UserSettings.WriteDouble(Key: String; Value: Double);
begin
  mapped.Values[Key] := Value;
end;

method UserSettings.WriteInteger(Key: String; Value: Integer);
begin
  mapped.Values[Key] := Value;
end;

method UserSettings.WriteString(Key: String; Value: String);
begin
  mapped.Values[Key] := Value;
end;
  {$ELSE}
class method UserSettingsHelper.GetConfiguration: System.Configuration.Configuration;
begin
  if Instance = nil then
    Instance := System.Configuration.ConfigurationManager.OpenExeConfiguration(System.Configuration.ConfigurationUserLevel.None);

  exit Instance;
end;

method UserSettings.ReadString(Key: String; DefaultValue: String): String;
begin
  SugarArgumentNullException.RaiseIfNil(Key, "Key");

  if mapped.AppSettings.Settings[Key] = nil then
    exit DefaultValue;

  exit mapped.AppSettings.Settings[Key].Value;
end;

method UserSettings.ReadInteger(Key: String; DefaultValue: Integer): Integer;
begin
  SugarArgumentNullException.RaiseIfNil(Key, "Key");
  if not Integer.TryParse(mapped.AppSettings.Settings[Key]:Value, out Result) then
    exit DefaultValue;
end;

method UserSettings.ReadBoolean(Key: String; DefaultValue: Boolean): Boolean;
begin
  SugarArgumentNullException.RaiseIfNil(Key, "Key");
  if not Boolean.TryParse(mapped.AppSettings.Settings[Key]:Value, out Result) then
    exit DefaultValue;
end;

method UserSettings.ReadDouble(Key: String; DefaultValue: Double): Double;
begin
  SugarArgumentNullException.RaiseIfNil(Key, "Key");
  if not Double.TryParse(mapped.AppSettings.Settings[Key]:Value, out Result) then
    exit DefaultValue;
end;

method UserSettings.WriteString(Key: String; Value: String);
begin
  if mapped.AppSettings.Settings[Key] = nil then
    mapped.AppSettings.Settings.Add(Key, Value)
  else
    mapped.AppSettings.Settings[Key].Value := Value.ToString;
end;

method UserSettings.WriteInteger(Key: String; Value: Integer);
begin
  WriteString(Key, Value.ToString);
end;

method UserSettings.WriteBoolean(Key: String; Value: Boolean);
begin
  WriteString(Key, Value.ToString);
end;

method UserSettings.WriteDouble(Key: String; Value: Double);
begin
  WriteString(Key, Value.ToString);
end;

method UserSettings.Clear;
begin
  mapped.AppSettings.Settings.Clear;
end;

method UserSettings.Remove(Key: String);
begin
  if Key = nil then
    raise new SugarArgumentNullException("Key");

  mapped.AppSettings.Settings.Remove(Key);
end;

class method UserSettings.&Default: UserSettings;
begin  
  exit UserSettingsHelper.GetConfiguration;
end;
  {$ENDIF}
{$ELSEIF NOUGAT}
method UserSettings.Exists(Key: String): Boolean;
begin
  SugarArgumentNullException.RaiseIfNil(Key, "Key");
  exit mapped.objectForKey(Key) <> nil;
end;

method UserSettings.Clear;
begin
  mapped.removePersistentDomainForName(UserSettingsHelper.GetBundleIdentifier);
  mapped.synchronize;
end;

method UserSettings.ReadString(Key: String; DefaultValue: String): String;
begin
  if Exists(Key) then
    exit mapped.stringForKey(Key)
  else
    exit DefaultValue;
end;

method UserSettings.ReadInteger(Key: String; DefaultValue: Integer): Integer;
begin
  result := iif(Exists(Key), mapped.integerForKey(Key), DefaultValue);
end;

method UserSettings.ReadBoolean(Key: String; DefaultValue: Boolean): Boolean;
begin
  result := iif(Exists(Key), mapped.boolForKey(Key), DefaultValue);
end;

method UserSettings.ReadDouble(Key: String; DefaultValue: Double): Double;
begin
  result := iif(Exists(Key), mapped.doubleForKey(Key), DefaultValue);
end;

method UserSettings.WriteString(Key: String; Value: String);
begin
  SugarArgumentNullException.RaiseIfNil(Key, "Key");
  mapped.setObject(Value) forKey(Key);
end;

method UserSettings.WriteInteger(Key: String; Value: Integer);
begin
  SugarArgumentNullException.RaiseIfNil(Key, "Key");
  mapped.setInteger(Value) forKey(Key);
end;

method UserSettings.WriteBoolean(Key: String; Value: Boolean);
begin
  SugarArgumentNullException.RaiseIfNil(Key, "Key");
  mapped.setBool(Value) forKey(Key);
end;

method UserSettings.WriteDouble(Key: String; Value: Double);
begin
  SugarArgumentNullException.RaiseIfNil(Key, "Key");
  mapped.setDouble(Value) forKey(Key);
end;

method UserSettings.&Remove(Key: String);
begin
  SugarArgumentNullException.RaiseIfNil(Key, "Key");
  mapped.removeObjectForKey(Key);
end;

method UserSettings.GetKeys: array of String;
begin
  mapped.synchronize;
  var lValues := mapped.persistentDomainForName(UserSettingsHelper.GetBundleIdentifier):allKeys;
  if lValues = nil then
    exit [];

  result := new String[lValues.count];
  for i: Integer := 0 to lValues.count - 1 do
    result[i] := lValues.objectAtIndex(i);
end;

class method UserSettingsHelper.GetBundleIdentifier: String;
begin
  result := Foundation.NSBundle.mainBundle.bundleIdentifier;
  if result = nil then
    result := Foundation.NSBundle.mainBundle.executablePath.lastPathComponent.stringByDeletingPathExtension;  
end;
{$ENDIF}

end.

namespace Sugar.Data.Json;

interface

uses  
  Sugar,
  Sugar.Collections;

type
  JsonObject = public class mapped to {$IF COOPER}org.json.JSONObject{$ELSEIF ECHOES}Newtonsoft.Json.Linq.JObject{$ELSEIF NOUGAT}Foundation.NSMutableDictionary{$ENDIF}
  private
    method GetCount: Integer;
    method GetKeys: sequence of String;
  public
    constructor; mapped to constructor();
    constructor(Json: String);

    method GetBoolean(Key: String): Boolean;
    method GetDouble(Key: String): Double;
    method GetInt32(Key: String): Int32;
    method GetInt64(Key: String): Int64;
    method GetJsonArray(Key: String): JsonArray;
    method GetJsonObject(Key: String): JsonObject;
    method GetString(Key: String): String;

    method Contains(Key: String): Boolean;
    method Clear;
    method &Remove(Key: String): Boolean;

    method SetBoolean(Key: String; Value: Boolean);
    method SetDouble(Key: String; Value: Double);
    method SetInt32(Key: String; Value: Int32);
    method SetInt64(Key: String; Value: Int64);
    method SetJsonArray(Key: String; Value: JsonArray);
    method SetJsonObject(Key: String; Value: JsonObject);
    method SetString(Key: String; Value: String);

    property Keys: sequence of String read GetKeys;
    property Count: Integer read GetCount;    
  end;

implementation

constructor JsonObject(Json: String);
begin  
  {$IF COOPER}
  exit new org.json.JSONObject(json);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonObject.GetCount: Integer;
begin
  {$IF COOPER}
  exit mapped.length;
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonObject.GetKeys: sequence of String;
begin  
  {$IF COOPER}
  exit org.json.JSONObject.getNames(mapped);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonObject.GetBoolean(Key: String): Boolean;
begin  
  {$IF COOPER}
  exit mapped.getBoolean(Key);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonObject.GetDouble(Key: String): Double;
begin
  {$IF COOPER}
  exit mapped.getDouble(Key);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonObject.GetInt32(Key: String): Integer;
begin
  {$IF COOPER}
  exit mapped.getInt(Key);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonObject.GetInt64(Key: String): Int64;
begin
  {$IF COOPER}
  exit mapped.getLong(Key);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonObject.GetJsonArray(Key: String): JsonArray;
begin
  {$IF COOPER}
  exit mapped.getJSONArray(Key);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonObject.GetJsonObject(Key: String): JsonObject;
begin
  {$IF COOPER}
  exit mapped.getJSONObject(Key);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonObject.GetString(Key: String): String;
begin
  {$IF COOPER}
  exit mapped.getString(Key);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonObject.Contains(Key: String): Boolean;
begin  
  //SugarArgumentNullException.RaiseIfNil(Key, "Key");
  {$IF COOPER}
  exit mapped.has(Key);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonObject.Clear;
begin  
  {$IF COOPER}
  mapped.keySet.clear;
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonObject.Remove(Key: String): Boolean;
begin
  {$IF COOPER}
  exit mapped.remove(Key) <> nil;
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonObject.SetBoolean(Key: String; Value: Boolean);
begin  
  {$IF COOPER}
  mapped.put(Key, Value);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonObject.SetDouble(Key: String; Value: Double);
begin
  {$IF COOPER}
  mapped.put(Key, Value);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonObject.SetInt32(Key: String; Value: Integer);
begin
  {$IF COOPER}
  mapped.put(Key, Value);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonObject.SetInt64(Key: String; Value: Int64);
begin
  {$IF COOPER}
  mapped.put(Key, Value);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonObject.SetJsonArray(Key: String; Value: JsonArray);
begin
  {$IF COOPER}
  mapped.put(Key, Value);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonObject.SetJsonObject(Key: String; Value: JsonObject);
begin
  {$IF COOPER}
  mapped.put(Key, Value);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonObject.SetString(Key: String; Value: String);
begin
  {$IF COOPER}
  mapped.put(Key, Value);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

end.
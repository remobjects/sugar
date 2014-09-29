namespace Sugar.Data.Json;

interface

type
  JsonArray = public class mapped to {$IF COOPER}org.json.JSONArray{$ELSEIF ECHOES}Newtonsoft.Json.Linq.JArray{$ELSEIF NOUGAT}Foundation.NSMutableArray{$ENDIF}
  private
    method GetCount: Integer;
  public
    constructor; mapped to constructor();
    constructor(Json: String);

    method GetBoolean(&Index: Integer): Boolean;
    method GetDouble(&Index: Integer): Double;
    method GetInt32(&Index: Integer): Int32;
    method GetInt64(&Index: Integer): Int64;
    method GetJsonArray(&Index: Integer): JsonArray;
    method GetJsonObject(&Index: Integer): JsonObject;
    method GetString(&Index: Integer): String;

    method Clear;
    method &Remove(&Index: Integer): Boolean;

    method SetBoolean(&Index: Integer; Value: Boolean);
    method SetDouble(&Index: Integer; Value: Double);
    method SetInt32(&Index: Integer; Value: Int32);
    method SetInt64(&Index: Integer; Value: Int64);
    method SetJsonArray(&Index: Integer; Value: JsonArray);
    method SetJsonObject(&Index: Integer; Value: JsonObject);
    method SetString(&Index: Integer; Value: String);

    method AddBoolean(Value: Boolean);
    method AddDouble(Value: Double);
    method AddInt32(Value: Int32);
    method AddInt64(Value: Int64);
    method AddJsonArray(Value: JsonArray);
    method AddJsonObject(Value: JsonObject);
    method AddString(Value: String);

    property Count: Integer read GetCount;    
  end;

implementation

method JsonArray.GetCount: Integer;
begin
  {$IF COOPER}
  exit mapped.length;
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class constructor JsonArray(Json: String);
begin
  {$IF COOPER}
  exit new org.json.JSONArray(Json);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonArray.GetBoolean(&Index: Integer): Boolean;
begin
  {$IF COOPER}
  exit mapped.getBoolean(&Index);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonArray.GetDouble(&Index: Integer): Double;
begin
  {$IF COOPER}
  exit mapped.getDouble(&Index);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonArray.GetInt32(&Index: Integer): Integer;
begin
  {$IF COOPER}
  exit mapped.getInt(&Index);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonArray.GetInt64(&Index: Integer): Int64;
begin
  {$IF COOPER}
  exit mapped.getLong(&Index);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonArray.GetJsonArray(&Index: Integer): JsonArray;
begin
  {$IF COOPER}
  exit mapped.getJSONArray(&Index);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonArray.GetJsonObject(&Index: Integer): JsonObject;
begin
  {$IF COOPER}
  exit mapped.getJSONObject(&Index);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonArray.GetString(&Index: Integer): String;
begin
  {$IF COOPER}
  exit mapped.getString(&Index);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonArray.Clear;
begin
  {$IF COOPER}
  for i: Int32 := mapped.length - 1 downto 0 do
    mapped.remove(i);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonArray.Remove(&Index: Integer): Boolean;
begin
  {$IF COOPER}
  exit mapped.remove(&Index) <> nil;
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonArray.SetBoolean(&Index: Integer; Value: Boolean);
begin
  {$IF COOPER}
  mapped.put(&Index, Value);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonArray.SetDouble(&Index: Integer; Value: Double);
begin
  {$IF COOPER}
  mapped.put(&Index, Value);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonArray.SetInt32(&Index: Integer; Value: Integer);
begin
  {$IF COOPER}
  mapped.put(&Index, Value);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonArray.SetInt64(&Index: Integer; Value: Int64);
begin
  {$IF COOPER}
  mapped.put(&Index, Value);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonArray.SetJsonArray(&Index: Integer; Value: JsonArray);
begin
  {$IF COOPER}
  mapped.put(&Index, Value);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonArray.SetJsonObject(&Index: Integer; Value: JsonObject);
begin
  {$IF COOPER}
  mapped.put(&Index, Value);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonArray.SetString(&Index: Integer; Value: String);
begin
  {$IF COOPER}
  mapped.put(&Index, Value);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonArray.AddBoolean(Value: Boolean);
begin
  {$IF COOPER}
  mapped.put(Value);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonArray.AddDouble(Value: Double);
begin
  {$IF COOPER}
  mapped.put(Value);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonArray.AddInt32(Value: Integer);
begin
  {$IF COOPER}
  mapped.put(Value);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonArray.AddInt64(Value: Int64);
begin
  {$IF COOPER}
  mapped.put(Value);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonArray.AddJsonArray(Value: JsonArray);
begin
  {$IF COOPER}
  mapped.put(Value);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonArray.AddJsonObject(Value: JsonObject);
begin
  {$IF COOPER}
  mapped.put(Value);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method JsonArray.AddString(Value: String);
begin
  {$IF COOPER}
  mapped.put(Value);
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

end.
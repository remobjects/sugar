namespace Sugar.Json;

interface

uses
  Sugar;

type
  JsonValue<T> = public abstract class(JsonNode)
  public
    constructor(aValue: not nullable T);

    method {$IF NOUGAT}description: Foundation.NSString{$ELSEIF COOPER}ToString: java.lang.String{$ELSEIF ECHOES}ToString: System.String{$ENDIF}; override;
    method {$IF NOUGAT}isEqual(Obj: id){$ELSE}&Equals(Obj: Object){$ENDIF}: Boolean; override;
    method {$IF NOUGAT}hash: Foundation.NSUInteger{$ELSEIF COOPER}hashCode: Integer{$ELSEIF ECHOES}GetHashCode: Integer{$ENDIF}; override;

    property Value: not nullable T;
    operator Implicit(aValue: JsonValue<T>): not nullable T;
  end;
  
  JsonStringValue = public class(JsonValue<not nullable String>)
  public
    method ToJson: String; override;
    operator Implicit(aValue: not nullable String): JsonStringValue;
    //property StringValue: String read Value write Value; override;
  end;

  JsonIntegerValue = public class(JsonValue<Int64>)
  public
    method ToJson: String; override;
    operator Implicit(aValue: Int64): JsonIntegerValue;
    operator Implicit(aValue: Int32): JsonIntegerValue;
    operator Implicit(aValue: JsonIntegerValue): JsonFloatValue;

    {$IF NOT COOPER}
    //75131: Can't declare multiple cast operators on Java
    operator Implicit(aValue: JsonIntegerValue): not nullable Int32;
    operator Implicit(aValue: JsonIntegerValue): not nullable Double;
    operator Implicit(aValue: JsonIntegerValue): not nullable Single;
    {$ENDIF}
    //operator Explicit(aValue: JsonIntegerValue): JsonFloatValue;
    //property IntegerValue: Integer read Value write Value; override;
    //property FloatValue: Double read Value write inherited IntegerValue; override;
    //property StringValue: String read ToJson write ToJson; override;
  end;

  JsonFloatValue = public class(JsonValue<Double>)
  public
    method ToJson: String; override;
    operator Implicit(aValue: Double): JsonFloatValue;
    operator Implicit(aValue: Single): JsonFloatValue;
    operator Implicit(aValue: JsonFloatValue): Single;
    //property FloatValue: Double read Value write Value; override;
    //property IntegerValue: Int64 read Value write Value; override;
    //property StringValue: String read ToJson write ToJson; override;
  end;

  JsonBooleanValue = public class(JsonValue<Boolean>)
  public
    method ToJson: String; override;
    operator Implicit(aValue: Boolean): JsonBooleanValue;
    //property BooleanValue: Boolean read Value write Value; override;
    //property StringValue: String read ToJson write ToJson; override;
  end;

implementation

{ JsonValue<T> }

constructor JsonValue<T>(aValue: not nullable T);
begin
  Value := aValue;
end;

method JsonValue<T>.{$IF NOUGAT}description: Foundation.NSString{$ELSEIF COOPER}ToString: java.lang.String{$ELSEIF ECHOES}ToString: System.String{$ENDIF};
begin
  result := Value.{$IF NOUGAT}description{$ELSEIF COOPER}ToString{$ELSEIF ECHOES}ToString{$ENDIF};
end;

method JsonValue<T>.{$IF NOUGAT}isEqual(Obj: id){$ELSE}&Equals(Obj: Object){$ENDIF}: Boolean;
begin
  if (Obj = nil) or (not (Obj is JsonValue<T>)) then
    exit false;
  
  exit self.Value.Equals(JsonValue<T>(Obj).Value);
end;

method JsonValue<T>.{$IF NOUGAT}hash: Foundation.NSUInteger{$ELSEIF COOPER}hashCode: Integer{$ELSEIF ECHOES}GetHashCode: Integer{$ENDIF};
begin
  exit if self.Value = nil then -1 else self.Value.GetHashCode;
end;

operator JsonValue<T>.Implicit(aValue: JsonValue<T>): not nullable T;
begin
  result := aValue:Value;
end;

{operator JsonValue<T>.Explicit(aValue: JsonValue<T>): T;
begin
  result := aValue:Value;
end;}

{ JsonStringValue }

method JsonStringValue.ToJson: String;
begin
  var sb := new StringBuilder;
  
  for i: Int32 := 0 to Value.Length-1 do begin
    var c := Value[i];
    case c of
      '\': sb.Append("\\");
      '"': sb.Append('\"');
      '/': sb.Append('\/');
      #9: sb.Append('\t');
      #8: sb.Append('\b');
      #12: sb.Append('\f');
      #13: sb.Append('\r');
      #10: sb.Append('\n');
      #32..#33,
      #35..#46,
      #48..#91,
      #93..#127: sb.Append(c);
      else sb.Append('\u'+Sugar.Convert.ToHexString(Int32(c), 4));
    end;
  end;
  
  result := JsonConsts.STRING_QUOTE+sb.ToString()+JsonConsts.STRING_QUOTE;
end;

operator JsonStringValue.Implicit(aValue: not nullable String): JsonStringValue;
begin
  result := new JsonStringValue(aValue);
end;

{ JsonIntegerValue }

method JsonIntegerValue.ToJson: String;
begin
  result := Convert.ToString(Value);
end;

operator JsonIntegerValue.Implicit(aValue: Int64): JsonIntegerValue;
begin
  result := new JsonIntegerValue(aValue);
end;

operator JsonIntegerValue.Implicit(aValue: Int32): JsonIntegerValue;
begin
  result := new JsonIntegerValue(aValue);
end;

operator JsonIntegerValue.Implicit(aValue: JsonIntegerValue): JsonFloatValue;
begin
  result := new JsonFloatValue(aValue.Value);
end;

{$IF NOT COOPER}
operator JsonIntegerValue.Implicit(aValue: JsonIntegerValue): not nullable Int32;
begin
  result := aValue.Value;
end;

operator JsonIntegerValue.Implicit(aValue: JsonIntegerValue): not nullable Double;
begin
  result := aValue.Value;
end;

operator JsonIntegerValue.Implicit(aValue: JsonIntegerValue): not nullable Single;
begin
  result := aValue.Value;
end;
{$ENDIF}

{operator JsonIntegerValue.Explicit(aValue: JsonIntegerValue): JsonFloatValue;
begin
  result := new JsonFloatValue(aValue.Value);
end;}

{ JsonFloatValue }

method JsonFloatValue.ToJson: String;
begin
  result := Convert.ToStringInvariant(Value).Replace(",","");
  if not result.Contains(".") and not result.Contains("E") and not result.Contains("N") and not result.Contains("I") then result := result+".0";
end;

operator JsonFloatValue.Implicit(aValue: Double): JsonFloatValue;
begin
  result := new JsonFloatValue(aValue);
end;

operator JsonFloatValue.Implicit(aValue: Single): JsonFloatValue;
begin
  result := new JsonFloatValue(aValue);
end;

operator JsonFloatValue.Implicit(aValue: JsonFloatValue): Single;
begin
  result := aValue.Value;
end;

{ JsonBooleanValue }

method JsonBooleanValue.ToJson: String;
begin
  result := if Value as Boolean then JsonConsts.TRUE_VALUE else JsonConsts.FALSE_VALUE;
end;

operator JsonBooleanValue.Implicit(aValue: Boolean): JsonBooleanValue;
begin
  result := new JsonBooleanValue(aValue);
end;

end.
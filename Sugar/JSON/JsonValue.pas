namespace Sugar.Json;

interface

uses
  Sugar;

type
  JsonValue<T> = public abstract class(JsonNode)
  public
    constructor(aValue: T);

    method {$IF NOUGAT}description: Foundation.NSString{$ELSEIF COOPER}ToString: java.lang.String{$ELSEIF ECHOES}ToString: System.String{$ENDIF}; override;
    method {$IF NOUGAT}isEqual(obj: id){$ELSE}&Equals(Obj: Object){$ENDIF}: Boolean; override;
    method {$IF NOUGAT}hash: Foundation.NSUInteger{$ELSEIF COOPER}hashCode: Integer{$ELSEIF ECHOES}GetHashCode: Integer{$ENDIF}; override;

    property Value: T;
    operator Implicit(aValue: JsonValue<T>): T;
  end;
  
  JsonStringValue = public class(JsonValue<not nullable String>)
  public
    method ToJson: String; override;
    operator Implicit(aValue: not nullable String): JsonStringValue;
  end;

  JsonIntegerValue = public class(JsonValue<Int64>)
  public
    method ToJson: String; override;
    operator Implicit(aValue: Int64): JsonIntegerValue;
  end;

  JsonFloatValue = public class(JsonValue<Double>)
  public
    method ToJson: String; override;
    operator Implicit(aValue: Double): JsonFloatValue;
  end;

  JsonBooleanValue = public class(JsonValue<Boolean>)
  public
    method ToJson: String; override;
    operator Implicit(aValue: Boolean): JsonBooleanValue;
  end;

implementation

{ JsonValue<T> }

constructor JsonValue<T>(aValue: T);
begin
  Value := aValue;
end;

method JsonValue<T>.{$IF NOUGAT}description: Foundation.NSString{$ELSEIF COOPER}ToString: java.lang.String{$ELSEIF ECHOES}ToString: System.String{$ENDIF};
begin
  result := Value.{$IF NOUGAT}description{$ELSEIF COOPER}ToString{$ELSEIF ECHOES}ToString{$ENDIF};
end;

method JsonValue<T>.{$IF NOUGAT}isEqual(obj: id){$ELSE}&Equals(Obj: Object){$ENDIF}: Boolean;
begin
  if (obj = nil) or (not (obj is JsonValue<T>)) then
    exit false;
  
  exit self.Value.Equals(JsonValue<T>(obj).Value);
end;

method JsonValue<T>.{$IF NOUGAT}hash: Foundation.NSUInteger{$ELSEIF COOPER}hashCode: Integer{$ELSEIF ECHOES}GetHashCode: Integer{$ENDIF};
begin
  exit if self.Value = nil then -1 else self.Value.GetHashCode;
end;

operator JsonValue<T>.Implicit(aValue: JsonValue<T>): T;
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
      #93..#128: sb.Append(c);
      else sb.Append('\u'+Sugar.String.Format("{0:x4}", Int32(c)));
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
  result := String.Format("{0}", Value);
end;

operator JsonIntegerValue.Implicit(aValue: Int64): JsonIntegerValue;
begin
  result := new JsonIntegerValue(aValue);
end;

{ JsonFloatValue }

method JsonFloatValue.ToJson: String;
begin
  {$WARNING ensure proper float format?}
  result := String.Format("{0}", Value);
end;

operator JsonFloatValue.Implicit(aValue: Double): JsonFloatValue;
begin
  result := new JsonFloatValue(aValue);
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
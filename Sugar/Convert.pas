namespace Sugar;

{$HIDE W0} //supress case-mismatch errors

interface

type
  Convert = public class {$IF COOPER}{$ELSEIF ECHOES}mapped to System.Convert{$ELSEIF NOUGAT}{$ENDIF}
  public
    class method ToString(Value: Byte): String;
    class method ToString(Value: Int32): String;
    class method ToString(Value: Int64): String;
    class method ToString(Value: Double): String;
    class method ToString(Value: Char): String;
    class method ToString(Value: Object): String;

    class method ToInt32(Value: Byte): Int32;
    class method ToInt32(Value: Int64): Int32;
    class method ToInt32(Value: Double): Int32;
    class method ToInt32(Value: Char): Int32;
    class method ToInt32(Value: String): Int32;

    class method ToInt64(Value: Byte): Int64;
    class method ToInt64(Value: Int32): Int64;
    class method ToInt64(Value: Double): Int64;
    class method ToInt64(Value: Char): Int64;
    class method ToInt64(Value: String): Int64;

    class method ToDouble(Value: Byte): Double;
    class method ToDouble(Value: Int32): Double;
    class method ToDouble(Value: Int64): Double;
    class method ToDouble(Value: String): Double;

    class method ToByte(Value: Double): Byte;
    class method ToByte(Value: Int32): Byte;
    class method ToByte(Value: Int64): Byte;
    class method ToByte(Value: Char): Byte;
    class method ToByte(Value: String): Byte;

    class method ToChar(Value: Int32): Char;
    class method ToChar(Value: Int64): Char;
    class method ToChar(Value: Byte): Char;
    class method ToChar(Value: String): Char;

    class method ToBoolean(Value: Double): Boolean;
    class method ToBoolean(Value: Int32): Boolean;
    class method ToBoolean(Value: Int64): Boolean;
    class method ToBoolean(Value: Byte): Boolean;
    class method ToBoolean(Value: String): Boolean;
  end;

implementation

class method Convert.ToString(Value: Byte): String;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.ToString(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Convert.ToString(Value: Int32): String;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.ToString(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Convert.ToString(Value: Int64): String;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.ToString(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Convert.ToString(Value: Double): String;
begin
  if Consts.IsNegativeInfinity(Value) then
    exit "-Infinity";

  if Consts.IsPositiveInfinity(Value) then
    exit "Infinity";

  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.ToString(Value, System.Globalization.CultureInfo.InvariantCulture);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Convert.ToString(Value: Char): String;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.ToString(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Convert.ToString(Value: Object): String;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.ToString(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Convert.ToInt32(Value: Byte): Int32;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.ToInt32(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Convert.ToInt32(Value: Int64): Int32;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.ToInt32(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Convert.ToInt32(Value: Double): Int32;
begin
  if (Value > Consts.MaxInteger) or (Value < Consts.MinInteger) then
    raise new SugarArgumentOutOfRangeException("Specified value exceeds range of integer");

  exit Math.RoundToInt(Value);
  {$IF COOPER}
  {$ELSEIF ECHOES}
  //exit mapped.ToInt32(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Convert.ToInt32(Value: Char): Int32;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.ToInt32(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Convert.ToInt32(Value: String): Int32;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.ToInt32(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Convert.ToInt64(Value: Byte): Int64;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.ToInt64(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Convert.ToInt64(Value: Int32): Int64;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.ToInt64(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Convert.ToInt64(Value: Double): Int64;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.ToInt64(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Convert.ToInt64(Value: Char): Int64;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.ToInt64(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Convert.ToInt64(Value: String): Int64;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.ToInt64(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Convert.ToDouble(Value: Byte): Double;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.ToDouble(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Convert.ToDouble(Value: Int32): Double;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.ToDouble(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Convert.ToDouble(Value: Int64): Double;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.ToDouble(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Convert.ToDouble(Value: String): Double;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.ToDouble(Value, System.Globalization.CultureInfo.InvariantCulture);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Convert.ToByte(Value: Double): Byte;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.ToByte(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Convert.ToByte(Value: Int32): Byte;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.ToByte(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Convert.ToByte(Value: Int64): Byte;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.ToByte(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Convert.ToByte(Value: Char): Byte;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.ToByte(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Convert.ToByte(Value: String): Byte;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.ToByte(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Convert.ToChar(Value: Int32): Char;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.ToChar(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Convert.ToChar(Value: Int64): Char;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.ToChar(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Convert.ToChar(Value: Byte): Char;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.ToChar(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Convert.ToChar(Value: String): Char;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.ToChar(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Convert.ToBoolean(Value: Double): Boolean;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.ToBoolean(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Convert.ToBoolean(Value: Int32): Boolean;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.ToBoolean(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Convert.ToBoolean(Value: Int64): Boolean;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.ToBoolean(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Convert.ToBoolean(Value: Byte): Boolean;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.ToBoolean(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Convert.ToBoolean(Value: String): Boolean;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.ToBoolean(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

end.

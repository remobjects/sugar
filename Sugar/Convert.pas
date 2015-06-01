namespace Sugar;

interface

type
  Convert = public class {$IF COOPER}{$ELSEIF ECHOES}mapped to System.Convert{$ELSEIF NOUGAT}mapped to Object{$ENDIF}
  public
    class method ToString(Value: Boolean): String;
    class method ToString(Value: Byte): String;
    class method ToString(Value: Int32): String;
    class method ToString(Value: Int64): String;
    class method ToString(Value: Double): String;
    class method ToString(Value: Char): String;
    class method ToString(Value: Object): String;

    class method ToInt32(Value: Boolean): Int32;
    class method ToInt32(Value: Byte): Int32;
    class method ToInt32(Value: Int64): Int32;
    class method ToInt32(Value: Double): Int32;
    class method ToInt32(Value: Char): Int32;
    class method ToInt32(Value: String): Int32;

    class method HexToInt32(Value: String): UInt32;

    class method ToInt64(Value: Boolean): Int64;
    class method ToInt64(Value: Byte): Int64;
    class method ToInt64(Value: Int32): Int64;
    class method ToInt64(Value: Double): Int64;
    class method ToInt64(Value: Char): Int64;
    class method ToInt64(Value: String): Int64;

    class method ToDouble(Value: Boolean): Double;
    class method ToDouble(Value: Byte): Double;
    class method ToDouble(Value: Int32): Double;
    class method ToDouble(Value: Int64): Double;
    class method ToDouble(Value: String): Double;

    class method ToByte(Value: Boolean): Byte;
    class method ToByte(Value: Double): Byte;
    class method ToByte(Value: Int32): Byte;
    class method ToByte(Value: Int64): Byte;
    class method ToByte(Value: Char): Byte;
    class method ToByte(Value: String): Byte;

    class method ToChar(Value: Boolean): Char;
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

  {$IF NOUGAT}
  ConvertHelper = public class
  public
    class method ParseNumber(Value: String): NSNumber;
    class method ParseInt32(Value: String): Int32;  
    class method ParseInt64(Value: String): Int64; 
    class method ParseDouble(Value: String): Double;
  end;
  {$ENDIF}

implementation

class method Convert.ToString(Value: Boolean): String;
begin
  result := if Value then Consts.TrueString else Consts.FalseString;
end;

class method Convert.ToString(Value: Byte): String;
begin
  {$IF COOPER OR NOUGAT}
  exit Value.ToString;
  {$ELSEIF ECHOES}
  exit mapped.ToString(Value);
  {$ENDIF}
end;

class method Convert.ToString(Value: Int32): String;
begin
  {$IF COOPER OR NOUGAT}
  exit Value.ToString;
  {$ELSEIF ECHOES}
  exit mapped.ToString(Value);
  {$ENDIF}
end;

class method Convert.ToString(Value: Int64): String;
begin
  {$IF COOPER OR NOUGAT}
  exit Value.ToString;
  {$ELSEIF ECHOES}
  exit mapped.ToString(Value);
  {$ENDIF}
end;

class method Convert.ToString(Value: Double): String;
begin
  if Consts.IsNegativeInfinity(Value) then
    exit "-Infinity";

  if Consts.IsPositiveInfinity(Value) then
    exit "Infinity";

  if Consts.IsNaN(Value) then
    exit "NaN";

  {$IF COOPER}
  var DecFormat: java.text.DecimalFormat := java.text.DecimalFormat(java.text.DecimalFormat.getInstance(Sugar.Cooper.LocaleUtils.ForLanguageTag("en-US")));
  var X := Math.Log10(Math.Abs(Value));
  var FloatPattern := "#.###############";
  var ScientificPattern := "#.###############E00";

  if Math.Sign(X) > 0 then
    DecFormat.applyPattern(if Math.Abs(X) >= 15 then ScientificPattern else FloatPattern)
  else
    DecFormat.applyPattern(if Math.Abs(X) >= 5 then ScientificPattern else FloatPattern);

  result := DecFormat.format(Value);
  var Pos := result.IndexOf("E-");

  if Pos = - 1 then
    exit result.Replace("E", "E+");
  {$ELSEIF ECHOES}
  exit mapped.ToString(Value, System.Globalization.CultureInfo.InvariantCulture);
  {$ELSEIF NOUGAT}
  exit Value.ToString.ToUpper;
  {$ENDIF}
end;

class method Convert.ToString(Value: Char): String;
begin
  {$IF COOPER OR NOUGAT}
  exit Sugar.String(Value);
  {$ELSEIF ECHOES}
  exit mapped.ToString(Value);
  {$ENDIF}
end;

class method Convert.ToString(Value: Object): String;
begin
  exit Value.ToString;
end;

class method Convert.ToInt32(Value: Boolean): Int32;
begin
  result := if Value then 1 else 0; 
end;

class method Convert.ToInt32(Value: Byte): Int32;
begin
  {$IF COOPER OR NOUGAT}
  exit Int32(Value);
  {$ELSEIF ECHOES}
  exit mapped.ToInt32(Value);
  {$ENDIF}
end;

class method Convert.ToInt32(Value: Int64): Int32;
begin
  if (Value > Consts.MaxInteger) or (Value < Consts.MinInteger) then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.TYPE_RANGE_ERROR, "Int32");

  {$IF COOPER OR NOUGAT}
  exit Int32(Value);
  {$ELSEIF ECHOES}
  exit mapped.ToInt32(Value);
  {$ENDIF}
end;

class method Convert.ToInt32(Value: Double): Int32;
begin
  var Number := Math.Round(Value);

  if (Number > Consts.MaxInteger) or (Number < Consts.MinInteger) then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.TYPE_RANGE_ERROR, "Int32");

  exit Int32(Number);
end;

class method Convert.ToInt32(Value: Char): Int32;
begin
  {$IF COOPER OR NOUGAT}
  exit ord(Value);
  {$ELSEIF ECHOES}
  exit mapped.ToInt32(Value);
  {$ENDIF}
end;

class method Convert.ToInt32(Value: String): Int32;
begin
  {$IF COOPER}
  exit Integer.parseInt(Value);
  {$ELSEIF ECHOES}
  exit mapped.ToInt32(Value);
  {$ELSEIF NOUGAT}
  exit ConvertHelper.ParseInt32(Value);
  {$ENDIF}
end;

class method Convert.HexToInt32(Value: String): UInt32;
begin
  {$IF COOPER}
  exit Integer.parseInt(Value, 16);
  {$ELSEIF ECHOES}
  exit Int32.Parse(Value, System.Globalization.NumberStyles.HexNumber);
  {$ELSEIF NOUGAT}
  var scanner: NSScanner := NSScanner.scannerWithString(Value);
  scanner.scanHexInt(var result);
  {$ENDIF}
end;

class method Convert.ToInt64(Value: Boolean): Int64;
begin
  result := if Value then 1 else 0;
end;

class method Convert.ToInt64(Value: Byte): Int64;
begin
  {$IF COOPER OR NOUGAT}
  exit Int64(Value);
  {$ELSEIF ECHOES}
  exit mapped.ToInt64(Value);
  {$ENDIF}
end;

class method Convert.ToInt64(Value: Int32): Int64;
begin
  {$IF COOPER OR NOUGAT}
  exit Int64(Value);
  {$ELSEIF ECHOES}
  exit mapped.ToInt64(Value);
  {$ENDIF}
end;

class method Convert.ToInt64(Value: Double): Int64;
begin
  if (Value > Consts.MaxInt64) or (Value < Consts.MinInt64) then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.TYPE_RANGE_ERROR, "Int64");

  exit Math.Round(Value);
end;

class method Convert.ToInt64(Value: Char): Int64;
begin
  {$IF COOPER OR NOUGAT}
  exit ord(Value);
  {$ELSEIF ECHOES}
  exit mapped.ToInt64(Value);
  {$ENDIF}
end;

class method Convert.ToInt64(Value: String): Int64;
begin
  if Value = nil then
    exit 0;

  if String.IsNullOrWhiteSpace(Value) then
    raise new SugarFormatException("Unable to convert string '{0}' to int64.", Value);

  {$IF COOPER}
  exit Long.parseLong(Value);
  {$ELSEIF ECHOES}
  exit mapped.ToInt64(Value);
  {$ELSEIF NOUGAT}
  exit ConvertHelper.ParseInt64(Value);
  {$ENDIF}
end;

class method Convert.ToDouble(Value: Boolean): Double;
begin
  result := if Value then 1 else 0;
end;

class method Convert.ToDouble(Value: Byte): Double;
begin
  {$IF COOPER OR NOUGAT}
  exit Double(Value);
  {$ELSEIF ECHOES}
  exit mapped.ToDouble(Value);
  {$ENDIF}
end;

class method Convert.ToDouble(Value: Int32): Double;
begin
  {$IF COOPER OR NOUGAT}
  exit Double(Value);
  {$ELSEIF ECHOES}
  exit mapped.ToDouble(Value);
  {$ENDIF}
end;

class method Convert.ToDouble(Value: Int64): Double;
begin
  {$IF COOPER OR NOUGAT}
  exit Double(Value);
  {$ELSEIF ECHOES}
  exit mapped.ToDouble(Value);
  {$ENDIF}
end;

class method Convert.ToDouble(Value: String): Double;
begin
  if Value = nil then
    exit 0.0;

  if String.IsNullOrWhiteSpace(Value) then
    raise new SugarFormatException("Unable to convert string '{0}' to double.", Value);

  {$IF COOPER}
  var DecFormat: java.text.DecimalFormat := java.text.DecimalFormat(java.text.DecimalFormat.getInstance(Sugar.Cooper.LocaleUtils.ForLanguageTag("en-US")));
  var Symbols: java.text.DecimalFormatSymbols := java.text.DecimalFormatSymbols.getInstance(Sugar.Cooper.LocaleUtils.ForLanguageTag("en-US"));

  Symbols.DecimalSeparator := '.';
  Symbols.GroupingSeparator := ',';
  Symbols.ExponentSeparator := 'E';
  DecFormat.setParseIntegerOnly(false);
  var Position := new java.text.ParsePosition(0);
  
  Value := Value.Trim.ToUpper;
  {$IF ANDROID}
  if Value.Length > 1 then begin
    var DecimalIndex := Value.IndexOf(".");
    if DecimalIndex = -1 then
      DecimalIndex := Value.Length;

    Value := Value[0] + Value.Substring(1, DecimalIndex - 1).Replace(",", "") + Value.Substring(DecimalIndex);    
  end;
  {$ENDIF}

  result := DecFormat.parse(Value, Position).doubleValue;

  if Position.Index < Value.Length then
    raise new SugarFormatException("Unable to convert string '{0}' to double.", Value);

  if Consts.IsInfinity(result) or Consts.IsNaN(result) then
    raise new SugarFormatException("Unable to convert string '{0}' to double.", Value);
  {$ELSEIF ECHOES}
  exit mapped.ToDouble(Value, System.Globalization.CultureInfo.InvariantCulture);
  {$ELSEIF NOUGAT}
  exit ConvertHelper.ParseDouble(Value);
  {$ENDIF}
end;

class method Convert.ToByte(Value: Boolean): Byte;
begin
  result := if Value then 1 else 0;
end;

class method Convert.ToByte(Value: Double): Byte;
begin
  var Number := Math.Round(Value);

  if (Number > 255) or (Number < 0) then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.TYPE_RANGE_ERROR, "Byte");

  exit Byte(Number);
end;

class method Convert.ToByte(Value: Int32): Byte;
begin
  if (Value > 255) or (Value < 0) then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.TYPE_RANGE_ERROR, "Byte");

  exit Byte(Value);
end;

class method Convert.ToByte(Value: Int64): Byte;
begin
  if (Value > 255) or (Value < 0) then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.TYPE_RANGE_ERROR, "Byte");

  exit Byte(Value);
end;

class method Convert.ToByte(Value: Char): Byte;
begin
  var Number := Convert.ToInt32(Value);

  if (Number > 255) or (Number < 0) then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.TYPE_RANGE_ERROR, "Byte");

  {$IF COOPER OR NOUGAT}
  exit ord(Value);
  {$ELSEIF ECHOES}
  exit mapped.ToByte(Value);
  {$ENDIF}
end;

class method Convert.ToByte(Value: String): Byte;
begin
  if Value = nil then
    exit 0;

  if String.IsNullOrWhiteSpace(Value) then
    raise new SugarFormatException("Unable to convert string '{0}' to byte.", Value);

  {$IF COOPER}
  exit Byte.parseByte(Value);
  {$ELSEIF ECHOES}
  exit mapped.ToByte(Value);
  {$ELSEIF NOUGAT}
  var Number: Int32 := ConvertHelper.ParseInt32(Value);
  exit ToByte(Number);
  {$ENDIF}
end;

class method Convert.ToChar(Value: Boolean): Char;
begin
  exit ToChar(ToInt32(Value));
end;

class method Convert.ToChar(Value: Int32): Char;
begin
  if (Value > Consts.MaxChar) or (Value < Consts.MinChar) then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.TYPE_RANGE_ERROR, "Char");

  {$IF COOPER OR NOUGAT}
  exit chr(Value);
  {$ELSEIF ECHOES}
  exit mapped.ToChar(Value);
  {$ENDIF}
end;

class method Convert.ToChar(Value: Int64): Char;
begin
  if (Value > Consts.MaxChar) or (Value < Consts.MinChar) then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.TYPE_RANGE_ERROR, "Char");

  {$IF COOPER OR NOUGAT}
  exit chr(Value);
  {$ELSEIF ECHOES}
  exit mapped.ToChar(Value);
  {$ENDIF}
end;

class method Convert.ToChar(Value: Byte): Char;
begin
  {$IF COOPER}
  exit chr(Integer(Value));
  {$ELSEIF ECHOES}
  exit mapped.ToChar(Value);
  {$ELSEIF NOUGAT}
  exit chr(Value);
  {$ENDIF}
end;

class method Convert.ToChar(Value: String): Char;
begin
  SugarArgumentNullException.RaiseIfNil(Value, "Value");

  if Value.Length <> 1 then
    raise new SugarFormatException("Unable to convert string '{0}' to char.", Value);

  exit Value[0];
end;

class method Convert.ToBoolean(Value: Double): Boolean;
begin
  exit if Value = 0 then false else true;
end;

class method Convert.ToBoolean(Value: Int32): Boolean;
begin
  exit if Value = 0 then false else true;
end;

class method Convert.ToBoolean(Value: Int64): Boolean;
begin
  exit if Value = 0 then false else true;
end;

class method Convert.ToBoolean(Value: Byte): Boolean;
begin
  exit if Value = 0 then false else true;
end;

class method Convert.ToBoolean(Value: String): Boolean;
begin  
  if (Value = nil) or (Value.EqualsIgnoreCase(Consts.FalseString)) then 
    exit false;

  if Value.EqualsIgnoreCase(Consts.TrueString) then
    exit true;  
  
  raise new SugarFormatException(ErrorMessage.FORMAT_ERROR);
end;

{$IF NOUGAT}
class method ConvertHelper.ParseNumber(Value: String): NSNumber;
begin
  if String.IsNullOrEmpty(Value) then
    exit nil;

  var Formatter := new NSNumberFormatter;
  Formatter.numberStyle := NSNumberFormatterStyle.NSNumberFormatterDecimalStyle;
  Formatter.decimalSeparator := ".";
  Formatter.exponentSymbol := "E";
  Formatter.usesGroupingSeparator := false;

  //clear grouping
  if Value.Length > 1 then begin
    var DecimalIndex := Value.IndexOf(".");
    if DecimalIndex = -1 then
      DecimalIndex := Value.Length;

    Value := NSString(Value).stringByReplacingOccurrencesOfString(",") withString("") options(0) range(NSMakeRange(1, DecimalIndex - 1));   
  end;

  exit Formatter.numberFromString(Value);
end;

class method ConvertHelper.ParseInt32(Value: String): Int32;
begin
  var Number := ParseInt64(Value);

  if (Number > Consts.MaxInteger) or (Number < Consts.MinInteger) then
    raise new SugarFormatException(ErrorMessage.FORMAT_ERROR);

  exit Int32(Number);
end;

class method ConvertHelper.ParseInt64(Value: String): Int64;
begin
  if Value = nil then
    exit 0;

  var Number := ParseNumber(Value);

  if Number = nil then
    raise new SugarFormatException(ErrorMessage.FORMAT_ERROR);

  var obj: id := Number;
  var NumberType := CFNumberGetType(CFNumberRef(obj));

  if NumberType in [CFNumberType.kCFNumberIntType, CFNumberType.kCFNumberNSIntegerType, CFNumberType.kCFNumberSInt8Type, CFNumberType.kCFNumberSInt32Type,
                    CFNumberType.kCFNumberSInt16Type, CFNumberType.kCFNumberShortType, CFNumberType.kCFNumberSInt64Type, CFNumberType.kCFNumberCharType] then
    exit Number.longLongValue;

  raise new SugarFormatException(ErrorMessage.FORMAT_ERROR);
end;

class method ConvertHelper.ParseDouble(Value: String): Double;
begin
  if Value = nil then
    exit 0.0;

  var Number := ParseNumber(Value);

  if Number = nil then
    raise new SugarFormatException(ErrorMessage.FORMAT_ERROR);

  exit Number.doubleValue;
end;
{$ENDIF}

end.

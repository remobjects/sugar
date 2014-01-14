namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.TestFramework;

type
  ConvertTest = public class (Testcase)
  public
    method ToStringByte;
    method ToStringInt32;
    method ToStringInt64;
    method ToStringDouble;
    method ToStringChar;
    method ToStringObject;

    method ToInt32Byte;
    method ToInt32Int64;
    method ToInt32Double;
    method ToInt32Char;
    method ToInt32String;

    method ToInt64Byte;
    method ToInt64Int32;
    method ToInt64Double;
    method ToInt64Char;
    method ToInt64String;

    method ToDoubleByte;
    method ToDoubleInt32;
    method ToDoubleInt64;
    method ToDoubleString;

    method ToByteDouble;
    method ToByteInt32;
    method ToByteInt64;
    method ToByteChar;
    method ToByteString;

    method ToCharInt32;
    method ToCharInt64;
    method ToCharByte;
    method ToCharString;

    method ToBooleanDouble;
    method ToBooleanInt32;
    method ToBooleanInt64;
    method ToBooleanByte;
    method ToBooleanString;
  end;

implementation

method ConvertTest.ToStringByte;
begin
  Assert.CheckString("0", Convert.ToString(Byte(0)));
  Assert.CheckString("255", Convert.ToString(Byte(255)));
end;

method ConvertTest.ToStringInt32;
begin
  Assert.CheckString("2147483647", Convert.ToString(Consts.MaxInteger));
  Assert.CheckString("-2147483648", Convert.ToString(Consts.MinInteger));
  Assert.CheckString("0", Convert.ToString(Int32(0)));
end;

method ConvertTest.ToStringInt64;
begin
  Assert.CheckString("9223372036854775807", Convert.ToString(Consts.MaxInt64));
  Assert.CheckString("-9223372036854775808", Convert.ToString(Consts.MinInt64));
  Assert.CheckString("0", Convert.ToString(Int64(0)));
end;

method ConvertTest.ToStringDouble;
begin
  Assert.CheckString("1.797693134862E+308", Convert.ToString(Double(1.797693134862E+308)));
  Assert.CheckString("-1.797693134862E+308", Convert.ToString(Double(-1.797693134862E+308)));
  Assert.CheckString("1E-09", Convert.ToString(Double(0.000000001)));
  Assert.CheckString("NaN", Convert.ToString(Consts.NaN));
  Assert.CheckString("-Infinity", Convert.ToString(Consts.NegativeInfinity));
  Assert.CheckString("Infinity", Convert.ToString(Consts.PositiveInfinity));
  Assert.CheckString("0.1", Convert.ToString(Double(0.1)));
  Assert.CheckString("-4.2", Convert.ToString(Double(-4.2)));
end;

method ConvertTest.ToStringChar;
begin
  Assert.CheckString("x", Convert.ToString(Char('x')));
  Assert.CheckString(#0, Convert.ToString(Char(0)));
end;

method ConvertTest.ToStringObject;
begin
  Assert.CheckString("42", Convert.ToString(new CodeClass(42)));
end;

method ConvertTest.ToInt32Byte;
begin
  Assert.CheckInt(0, Convert.ToInt32(Byte(0)));
  Assert.CheckInt(255, Convert.ToInt32(Byte(255)));
end;

method ConvertTest.ToInt32Int64;
begin
  Assert.CheckInt(0, Convert.ToInt32(Int64(0)));
  Assert.CheckInt(45678942, Convert.ToInt32(Int64(45678942)));

  Assert.IsException(->Convert.ToInt32(Consts.MaxInt64));
  Assert.IsException(->Convert.ToInt32(Consts.MinInt64));
end;

method ConvertTest.ToInt32Double;
begin
  Assert.CheckInt(1, Convert.ToInt32(Double(1.0)));
  Assert.CheckInt(1, Convert.ToInt32(Double(1.1)));
  Assert.CheckInt(1, Convert.ToInt32(Double(1.2)));
  Assert.CheckInt(1, Convert.ToInt32(Double(1.3)));
  Assert.CheckInt(1, Convert.ToInt32(Double(1.4)));
  Assert.CheckInt(1, Convert.ToInt32(Double(1.5)));
  Assert.CheckInt(2, Convert.ToInt32(Double(1.6)));
  Assert.CheckInt(2, Convert.ToInt32(Double(1.7)));
  Assert.CheckInt(2, Convert.ToInt32(Double(1.8)));
  Assert.CheckInt(2, Convert.ToInt32(Double(1.9)));

  Assert.CheckInt(2, Convert.ToInt32(Double(2.0)));
  Assert.CheckInt(2, Convert.ToInt32(Double(2.1)));
  Assert.CheckInt(2, Convert.ToInt32(Double(2.2)));
  Assert.CheckInt(2, Convert.ToInt32(Double(2.3)));
  Assert.CheckInt(2, Convert.ToInt32(Double(2.4)));
  Assert.CheckInt(2, Convert.ToInt32(Double(2.5)));
  Assert.CheckInt(3, Convert.ToInt32(Double(2.6)));
  Assert.CheckInt(3, Convert.ToInt32(Double(2.7)));
  Assert.CheckInt(3, Convert.ToInt32(Double(2.8)));
  Assert.CheckInt(3, Convert.ToInt32(Double(2.9)));

  Assert.IsException(->Convert.ToInt32(Double(21474836483.15)));
  Assert.IsException(->Convert.ToInt32(Double(-21474836483.15)));
  Assert.IsException(->Convert.ToInt32(Consts.NaN));
  Assert.IsException(->Convert.ToInt32(Consts.PositiveInfinity));
  Assert.IsException(->Convert.ToInt32(Consts.NegativeInfinity));
end;

method ConvertTest.ToInt32Char;
begin
  Assert.CheckInt(13, Convert.ToInt32(Char(#13)));
  Assert.CheckInt(0, Convert.ToInt32(Char(#0)));
end;

method ConvertTest.ToInt32String;
begin
  Assert.CheckInt(42, Convert.ToInt32("42"));
  Assert.CheckInt(-42, Convert.ToInt32("-42"));
  Assert.CheckInt(0, Convert.ToInt32(nil));

  Assert.IsException(->Convert.ToInt32("9223372036854775807"));
  Assert.IsException(->Convert.ToInt32("4.2"));
  Assert.IsException(->Convert.ToInt32("1F"));
end;

method ConvertTest.ToInt64Byte;
begin
  Assert.CheckInt64(0, Convert.ToInt64(Byte(0)));
  Assert.CheckInt64(255, Convert.ToInt64(Byte(255)));
end;

method ConvertTest.ToInt64Int32;
begin
  Assert.CheckInt64(2147483647, Convert.ToInt64(Consts.MaxInteger));
  Assert.CheckInt64(-2147483648, Convert.ToInt64(Consts.MinInteger));
end;

method ConvertTest.ToInt64Double;
begin
  Assert.CheckInt64(1, Convert.ToInt64(Double(1.0)));
  Assert.CheckInt64(1, Convert.ToInt64(Double(1.1)));
  Assert.CheckInt64(1, Convert.ToInt64(Double(1.2)));
  Assert.CheckInt64(1, Convert.ToInt64(Double(1.3)));
  Assert.CheckInt64(1, Convert.ToInt64(Double(1.4)));
  Assert.CheckInt64(1, Convert.ToInt64(Double(1.5)));
  Assert.CheckInt64(2, Convert.ToInt64(Double(1.6)));
  Assert.CheckInt64(2, Convert.ToInt64(Double(1.7)));
  Assert.CheckInt64(2, Convert.ToInt64(Double(1.8)));
  Assert.CheckInt64(2, Convert.ToInt64(Double(1.9)));

  Assert.CheckInt64(2, Convert.ToInt64(Double(2.0)));
  Assert.CheckInt64(2, Convert.ToInt64(Double(2.1)));
  Assert.CheckInt64(2, Convert.ToInt64(Double(2.2)));
  Assert.CheckInt64(2, Convert.ToInt64(Double(2.3)));
  Assert.CheckInt64(2, Convert.ToInt64(Double(2.4)));
  Assert.CheckInt64(2, Convert.ToInt64(Double(2.5)));
  Assert.CheckInt64(3, Convert.ToInt64(Double(2.6)));
  Assert.CheckInt64(3, Convert.ToInt64(Double(2.7)));
  Assert.CheckInt64(3, Convert.ToInt64(Double(2.8)));
  Assert.CheckInt64(3, Convert.ToInt64(Double(2.9)));

  Assert.IsException(->Convert.ToInt64(Double(Consts.MaxDouble)));
  Assert.IsException(->Convert.ToInt64(Double(Consts.MinDouble)));
  Assert.IsException(->Convert.ToInt64(Consts.NaN));
  Assert.IsException(->Convert.ToInt64(Consts.PositiveInfinity));
  Assert.IsException(->Convert.ToInt64(Consts.NegativeInfinity));
end;

method ConvertTest.ToInt64Char;
begin
  Assert.CheckInt64(13, Convert.ToInt64(Char(#13)));
  Assert.CheckInt64(0, Convert.ToInt64(Char(#0)));
end;

method ConvertTest.ToInt64String;
begin
  Assert.CheckInt64(42, Convert.ToInt64("42"));
  Assert.CheckInt64(-42, Convert.ToInt64("-42"));
  Assert.CheckInt64(Consts.MaxInt64, Convert.ToInt64("9223372036854775807"));
  Assert.CheckInt64(Consts.MinInt64, Convert.ToInt64("-9223372036854775808"));
  Assert.CheckInt(0, Convert.ToInt64(nil));

  Assert.IsException(->Convert.ToInt64("92233720368547758071"));
  Assert.IsException(->Convert.ToInt64("4.2"));
  Assert.IsException(->Convert.ToInt64("1F"));
end;

method ConvertTest.ToDoubleByte;
begin
  Assert.CheckDouble(1.0, Convert.ToDouble(Byte(1)));
  Assert.CheckDouble(255.0, Convert.ToDouble(Byte(255)));
end;

method ConvertTest.ToDoubleInt32;
begin
  Assert.CheckDouble(2147483647.0, Convert.ToDouble(Consts.MaxInteger));
  Assert.CheckDouble(-2147483648.0, Convert.ToDouble(Consts.MinInteger));
end;

method ConvertTest.ToDoubleInt64;
begin
  Assert.CheckDouble(9223372036854775807.0, Convert.ToDouble(Consts.MaxInt64));
  Assert.CheckDouble(Double(-9223372036854775808.0), Convert.ToDouble(Consts.MinInt64));
end;

method ConvertTest.ToDoubleString;
begin
  Assert.CheckDouble(1.1, Convert.ToDouble("1.1")); // '.' - decimal separator
  Assert.CheckDouble(11, Convert.ToDouble("1,1")); // ',' - group separator
  Assert.CheckDouble(10241.5, Convert.ToDouble("1024,1.5"));  
  Assert.CheckDouble(-1.38e10, Convert.ToDouble("-1.38e10"));
  Assert.CheckDouble(0.0, Convert.ToDouble(nil));
  
  Assert.IsException(->Convert.ToDouble("1.29e325"));
  Assert.IsException(->Convert.ToDouble("1F"));
  Assert.IsException(->Convert.ToDouble("1024.1,5"));
end;

method ConvertTest.ToByteDouble;
begin
  Assert.CheckInt(1, Convert.ToByte(Double(1.0)));
  Assert.CheckInt(1, Convert.ToByte(Double(1.1)));
  Assert.CheckInt(1, Convert.ToByte(Double(1.2)));
  Assert.CheckInt(1, Convert.ToByte(Double(1.3)));
  Assert.CheckInt(1, Convert.ToByte(Double(1.4)));
  Assert.CheckInt(1, Convert.ToByte(Double(1.5)));
  Assert.CheckInt(2, Convert.ToByte(Double(1.6)));
  Assert.CheckInt(2, Convert.ToByte(Double(1.7)));
  Assert.CheckInt(2, Convert.ToByte(Double(1.8)));
  Assert.CheckInt(2, Convert.ToByte(Double(1.9)));

  Assert.CheckInt(2, Convert.ToByte(Double(2.0)));
  Assert.CheckInt(2, Convert.ToByte(Double(2.1)));
  Assert.CheckInt(2, Convert.ToByte(Double(2.2)));
  Assert.CheckInt(2, Convert.ToByte(Double(2.3)));
  Assert.CheckInt(2, Convert.ToByte(Double(2.4)));
  Assert.CheckInt(2, Convert.ToByte(Double(2.5)));
  Assert.CheckInt(3, Convert.ToByte(Double(2.6)));
  Assert.CheckInt(3, Convert.ToByte(Double(2.7)));
  Assert.CheckInt(3, Convert.ToByte(Double(2.8)));
  Assert.CheckInt(3, Convert.ToByte(Double(2.9)));

  Assert.IsException(->Convert.ToByte(Double(Consts.MaxDouble)));
  Assert.IsException(->Convert.ToByte(Double(Consts.MinDouble)));
  Assert.IsException(->Convert.ToByte(Consts.NaN));
  Assert.IsException(->Convert.ToByte(Consts.PositiveInfinity));
  Assert.IsException(->Convert.ToByte(Consts.NegativeInfinity));
end;

method ConvertTest.ToByteInt32;
begin
  Assert.CheckInt(0, Convert.ToByte(Int32(0)));
  Assert.CheckInt(42, Convert.ToByte(Int32(42)));  
  
  Assert.IsException(->Convert.ToByte(Int32(259)));
  Assert.IsException(->Convert.ToByte(Int32(-1)));
end;

method ConvertTest.ToByteInt64;
begin
  Assert.CheckInt(0, Convert.ToByte(Int64(0)));
  Assert.CheckInt(42, Convert.ToByte(Int64(42)));  
  
  Assert.IsException(->Convert.ToByte(Int64(259)));
  Assert.IsException(->Convert.ToByte(Int64(-1)));
end;

method ConvertTest.ToByteChar;
begin
  Assert.CheckInt(0, Convert.ToByte(Char(#0)));
  Assert.CheckInt(13, Convert.ToByte(Char(#13)));  
  
  Assert.IsException(->Convert.ToByte(Char(#388)));  
end;

method ConvertTest.ToByteString;
begin
  Assert.CheckInt(0, Convert.ToByte("0"));
  Assert.CheckInt(255, Convert.ToByte("255"));
  
  Assert.IsException(->Convert.ToByte("-1"));
  Assert.IsException(->Convert.ToByte("5.25"));
  Assert.IsException(->Convert.ToByte("FF"));
end;

method ConvertTest.ToCharInt32;
begin
  Assert.CheckString(#13, Convert.ToChar(Int32(13)));
  Assert.CheckString(#0, Convert.ToChar(Int32(0)));

  Assert.IsException(->Convert.ToChar(Consts.MaxInteger));
  Assert.IsException(->Convert.ToChar(Consts.MinInteger));
end;

method ConvertTest.ToCharInt64;
begin
  Assert.CheckString(#13, Convert.ToChar(Int64(13)));
  Assert.CheckString(#0, Convert.ToChar(Int64(0)));

  Assert.IsException(->Convert.ToChar(Consts.MaxInt64));
  Assert.IsException(->Convert.ToChar(Consts.MinInt64));
end;

method ConvertTest.ToCharByte;
begin
  Assert.CheckString(#13, Convert.ToChar(Byte(13)));
  Assert.CheckString(#0, Convert.ToChar(Byte(0)));
  Assert.CheckString(#255, Convert.ToChar(Byte(255)));
end;

method ConvertTest.ToCharString;
begin
  Assert.CheckString(#32, Convert.ToChar(" "));

  Assert.IsException(->Convert.ToChar(""));
  Assert.IsException(->Convert.ToChar(nil));
  Assert.IsException(->Convert.ToChar("xx"));
end;

method ConvertTest.ToBooleanDouble;
begin
  Assert.CheckBool(false, Convert.ToBoolean(Double(0.0)));
  Assert.CheckBool(true, Convert.ToBoolean(Double(0.1)));
  Assert.CheckBool(true, Convert.ToBoolean(Double(-1.1)));
  Assert.CheckBool(true, Convert.ToBoolean(Consts.NaN));
  Assert.CheckBool(true, Convert.ToBoolean(Consts.NegativeInfinity));
  Assert.CheckBool(true, Convert.ToBoolean(Consts.PositiveInfinity));
end;

method ConvertTest.ToBooleanInt32;
begin
  Assert.CheckBool(false, Convert.ToBoolean(Int32(0)));
  Assert.CheckBool(true, Convert.ToBoolean(Int32(1)));
  Assert.CheckBool(true, Convert.ToBoolean(Int32(-1)));
end;

method ConvertTest.ToBooleanInt64;
begin
  Assert.CheckBool(false, Convert.ToBoolean(Int64(0)));
  Assert.CheckBool(true, Convert.ToBoolean(Int64(1)));
  Assert.CheckBool(true, Convert.ToBoolean(Int64(-1)));
end;

method ConvertTest.ToBooleanByte;
begin
  Assert.CheckBool(false, Convert.ToBoolean(Byte(0)));
  Assert.CheckBool(true, Convert.ToBoolean(Byte(1)));
  Assert.CheckBool(true, Convert.ToBoolean(Byte(-1)));
end;

method ConvertTest.ToBooleanString;
begin
  Assert.CheckBool(true, Convert.ToBoolean(Consts.TrueString));
  Assert.CheckBool(false, Convert.ToBoolean(Consts.FalseString));
  Assert.CheckBool(false, Convert.ToBoolean(nil));

  Assert.IsException(->Convert.ToBoolean(""));
  Assert.IsException(->Convert.ToBoolean("a"));
  Assert.IsException(->Convert.ToBoolean("yes"));
  Assert.IsException(->Convert.ToBoolean("no"));
end;

end.

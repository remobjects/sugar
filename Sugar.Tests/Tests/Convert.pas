namespace Sugar.Test;

interface

uses
  Sugar,
  RemObjects.Elements.EUnit;

type
  ConvertTest = public class (Test)
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
  Assert.AreEqual(Convert.ToString(Byte(0)), "0");
  Assert.AreEqual(Convert.ToString(Byte(255)), "255");
end;

method ConvertTest.ToStringInt32;
begin
  Assert.AreEqual(Convert.ToString(Consts.MaxInteger), "2147483647");
  Assert.AreEqual(Convert.ToString(Consts.MinInteger), "-2147483648");
  Assert.AreEqual(Convert.ToString(Int32(0)), "0");
end;

method ConvertTest.ToStringInt64;
begin
  Assert.AreEqual(Convert.ToString(Consts.MaxInt64), "9223372036854775807");
  Assert.AreEqual(Convert.ToString(Consts.MinInt64), "-9223372036854775808");
  Assert.AreEqual(Convert.ToString(Int64(0)), "0");
end;

method ConvertTest.ToStringDouble;
begin
  Assert.AreEqual(Convert.ToString(Double(1.797693134862E+308)), "1.797693134862E+308");
  Assert.AreEqual(Convert.ToString(Double(-1.797693134862E+308)), "-1.797693134862E+308");
  Assert.AreEqual(Convert.ToString(Double(0.000000001)), "1E-09");
  Assert.AreEqual(Convert.ToString(Consts.NaN), "NaN");
  Assert.AreEqual(Convert.ToString(Consts.NegativeInfinity), "-Infinity");
  Assert.AreEqual(Convert.ToString(Consts.PositiveInfinity), "Infinity");
  Assert.AreEqual(Convert.ToString(Double(0.1)), "0.1");
  Assert.AreEqual(Convert.ToString(Double(-4.2)), "-4.2");
end;

method ConvertTest.ToStringChar;
begin
  Assert.AreEqual(Convert.ToString(Char('x')), "x");
  Assert.AreEqual(Convert.ToString(Char(0)), #0);
end;

method ConvertTest.ToStringObject;
begin
  Assert.AreEqual(Convert.ToString(new CodeClass(42)), "42");
end;

method ConvertTest.ToInt32Byte;
begin
  Assert.AreEqual(Convert.ToInt32(Byte(0)), 0);
  Assert.AreEqual(Convert.ToInt32(Byte(255)), 255);
end;

method ConvertTest.ToInt32Int64;
begin
  Assert.AreEqual(Convert.ToInt32(Int64(0)), 0);
  Assert.AreEqual(Convert.ToInt32(Int64(45678942)), 45678942);

  Assert.Throws(->Convert.ToInt32(Consts.MaxInt64));
  Assert.Throws(->Convert.ToInt32(Consts.MinInt64));
end;

method ConvertTest.ToInt32Double;
begin
  Assert.AreEqual(Convert.ToInt32(Double(1.0)), 1);
  Assert.AreEqual(Convert.ToInt32(Double(1.1)), 1);
  Assert.AreEqual(Convert.ToInt32(Double(1.2)), 1);
  Assert.AreEqual(Convert.ToInt32(Double(1.3)), 1);
  Assert.AreEqual(Convert.ToInt32(Double(1.4)), 1);
  Assert.AreEqual(Convert.ToInt32(Double(1.5)), 2);
  Assert.AreEqual(Convert.ToInt32(Double(1.6)), 2);
  Assert.AreEqual(Convert.ToInt32(Double(1.7)), 2);
  Assert.AreEqual(Convert.ToInt32(Double(1.8)), 2);
  Assert.AreEqual(Convert.ToInt32(Double(1.9)), 2);

  Assert.AreEqual(Convert.ToInt32(Double(2.0)), 2);
  Assert.AreEqual(Convert.ToInt32(Double(2.1)), 2);
  Assert.AreEqual(Convert.ToInt32(Double(2.2)), 2);
  Assert.AreEqual(Convert.ToInt32(Double(2.3)), 2);
  Assert.AreEqual(Convert.ToInt32(Double(2.4)), 2);
  Assert.AreEqual(Convert.ToInt32(Double(2.5)), 3);
  Assert.AreEqual(Convert.ToInt32(Double(2.6)), 3);
  Assert.AreEqual(Convert.ToInt32(Double(2.7)), 3);
  Assert.AreEqual(Convert.ToInt32(Double(2.8)), 3);
  Assert.AreEqual(Convert.ToInt32(Double(2.9)), 3);

  Assert.Throws(->Convert.ToInt32(Double(21474836483.15)));
  Assert.Throws(->Convert.ToInt32(Double(-21474836483.15)));
  Assert.Throws(->Convert.ToInt32(Consts.NaN));
  Assert.Throws(->Convert.ToInt32(Consts.PositiveInfinity));
  Assert.Throws(->Convert.ToInt32(Consts.NegativeInfinity));
end;

method ConvertTest.ToInt32Char;
begin
  Assert.AreEqual(Convert.ToInt32(Char(#13)), 13);
  Assert.AreEqual(Convert.ToInt32(Char(#0)), 0);
end;

method ConvertTest.ToInt32String;
begin
  Assert.AreEqual(Convert.ToInt32("42"), 42);
  Assert.AreEqual(Convert.ToInt32("-42"), -42);
  Assert.AreEqual(Convert.ToInt32(nil), 0);

  Assert.Throws(->Convert.ToInt32(""));
  Assert.Throws(->Convert.ToInt32("9223372036854775807"));
  Assert.Throws(->Convert.ToInt32("4.2"));
  Assert.Throws(->Convert.ToInt32("1F"));
end;

method ConvertTest.ToInt64Byte;
begin
  Assert.AreEqual(Convert.ToInt64(Byte(0)), 0);
  Assert.AreEqual(Convert.ToInt64(Byte(255)), 255);
end;

method ConvertTest.ToInt64Int32;
begin
  Assert.AreEqual(Convert.ToInt64(Consts.MaxInteger), 2147483647);
  Assert.AreEqual(Convert.ToInt64(Consts.MinInteger), -2147483648);
end;

method ConvertTest.ToInt64Double;
begin
  Assert.AreEqual(Convert.ToInt64(Double(1.0)), 1);
  Assert.AreEqual(Convert.ToInt64(Double(1.1)), 1);
  Assert.AreEqual(Convert.ToInt64(Double(1.2)), 1);
  Assert.AreEqual(Convert.ToInt64(Double(1.3)), 1);
  Assert.AreEqual(Convert.ToInt64(Double(1.4)), 1);
  Assert.AreEqual(Convert.ToInt64(Double(1.5)), 2);
  Assert.AreEqual(Convert.ToInt64(Double(1.6)), 2);
  Assert.AreEqual(Convert.ToInt64(Double(1.7)), 2);
  Assert.AreEqual(Convert.ToInt64(Double(1.8)), 2);
  Assert.AreEqual(Convert.ToInt64(Double(1.9)), 2);

  Assert.AreEqual(Convert.ToInt64(Double(2.0)), 2);
  Assert.AreEqual(Convert.ToInt64(Double(2.1)), 2);
  Assert.AreEqual(Convert.ToInt64(Double(2.2)), 2);
  Assert.AreEqual(Convert.ToInt64(Double(2.3)), 2);
  Assert.AreEqual(Convert.ToInt64(Double(2.4)), 2);
  Assert.AreEqual(Convert.ToInt64(Double(2.5)), 3);
  Assert.AreEqual(Convert.ToInt64(Double(2.6)), 3);
  Assert.AreEqual(Convert.ToInt64(Double(2.7)), 3);
  Assert.AreEqual(Convert.ToInt64(Double(2.8)), 3);
  Assert.AreEqual(Convert.ToInt64(Double(2.9)), 3);

  Assert.Throws(->Convert.ToInt64(Double(Consts.MaxDouble)));
  Assert.Throws(->Convert.ToInt64(Double(Consts.MinDouble)));
  Assert.Throws(->Convert.ToInt64(Consts.NaN));
  Assert.Throws(->Convert.ToInt64(Consts.PositiveInfinity));
  Assert.Throws(->Convert.ToInt64(Consts.NegativeInfinity));
end;

method ConvertTest.ToInt64Char;
begin
  Assert.AreEqual(Convert.ToInt64(Char(#13)), 13);
  Assert.AreEqual(Convert.ToInt64(Char(#0)), 0);
end;

method ConvertTest.ToInt64String;
begin
  Assert.AreEqual(Convert.ToInt64("42"), 42);
  Assert.AreEqual(Convert.ToInt64("-42"), -42);
  Assert.AreEqual(Convert.ToInt64("9223372036854775807"), Consts.MaxInt64);
  Assert.AreEqual(Convert.ToInt64("-9223372036854775808"), Consts.MinInt64);
  Assert.AreEqual(Convert.ToInt64(nil), 0);

  Assert.Throws(->Convert.ToInt64(""), typeOf(SugarFormatException));
  Assert.Throws(->Convert.ToInt64("92233720368547758071"));
  Assert.Throws(->Convert.ToInt64("4.2"));
  Assert.Throws(->Convert.ToInt64("1F"));
end;

method ConvertTest.ToDoubleByte;
begin
  Assert.AreEqual(Convert.ToDouble(Byte(1)), 1.0);
  Assert.AreEqual(Convert.ToDouble(Byte(255)), 255.0);
end;

method ConvertTest.ToDoubleInt32;
begin
  Assert.AreEqual(Convert.ToDouble(Consts.MaxInteger), 2147483647.0);
  Assert.AreEqual(Convert.ToDouble(Consts.MinInteger), -2147483648.0);
end;

method ConvertTest.ToDoubleInt64;
begin
  Assert.AreEqual(Convert.ToDouble(Consts.MaxInt64), 9223372036854775807.0);
  Assert.AreEqual(Convert.ToDouble(Consts.MinInt64), Double(-9223372036854775808.0));
end;

method ConvertTest.ToDoubleString;
begin
  Assert.AreEqual(Convert.ToDouble("1.1"), 1.1); // '.' - decimal separator
  Assert.AreEqual(Convert.ToDouble("1,1"), 11); // ',' - group separator
  Assert.AreEqual(Convert.ToDouble("1024,1.5"), 10241.5);
  Assert.AreEqual(Convert.ToDouble("-1.38e10"), -1.38e10);
  Assert.AreEqual(Convert.ToDouble(nil), 0.0);
  
  Assert.Throws(->Convert.ToDouble(""), typeOf(SugarFormatException));
  Assert.Throws(->Convert.ToDouble("1.29e325"));
  Assert.Throws(->Convert.ToDouble("1F"));
  Assert.Throws(->Convert.ToDouble("1024.1,5"));
end;

method ConvertTest.ToByteDouble;
begin
  Assert.AreEqual(Convert.ToByte(Double(1.0)), 1);
  Assert.AreEqual(Convert.ToByte(Double(1.1)), 1);
  Assert.AreEqual(Convert.ToByte(Double(1.2)), 1);
  Assert.AreEqual(Convert.ToByte(Double(1.3)), 1);
  Assert.AreEqual(Convert.ToByte(Double(1.4)), 1);
  Assert.AreEqual(Convert.ToByte(Double(1.5)), 2);
  Assert.AreEqual(Convert.ToByte(Double(1.6)), 2);
  Assert.AreEqual(Convert.ToByte(Double(1.7)), 2);
  Assert.AreEqual(Convert.ToByte(Double(1.8)), 2);
  Assert.AreEqual(Convert.ToByte(Double(1.9)), 2);

  Assert.AreEqual(Convert.ToByte(Double(2.0)), 2);
  Assert.AreEqual(Convert.ToByte(Double(2.1)), 2);
  Assert.AreEqual(Convert.ToByte(Double(2.2)), 2);
  Assert.AreEqual(Convert.ToByte(Double(2.3)), 2);
  Assert.AreEqual(Convert.ToByte(Double(2.4)), 2);
  Assert.AreEqual(Convert.ToByte(Double(2.5)), 3);
  Assert.AreEqual(Convert.ToByte(Double(2.6)), 3);
  Assert.AreEqual(Convert.ToByte(Double(2.7)), 3);
  Assert.AreEqual(Convert.ToByte(Double(2.8)), 3);
  Assert.AreEqual(Convert.ToByte(Double(2.9)), 3);

  Assert.Throws(->Convert.ToByte(Double(Consts.MaxDouble)));
  Assert.Throws(->Convert.ToByte(Double(Consts.MinDouble)));
  Assert.Throws(->Convert.ToByte(Consts.NaN));
  Assert.Throws(->Convert.ToByte(Consts.PositiveInfinity));
  Assert.Throws(->Convert.ToByte(Consts.NegativeInfinity));
end;

method ConvertTest.ToByteInt32;
begin
  Assert.AreEqual(Convert.ToByte(Int32(0)), 0);
  Assert.AreEqual(Convert.ToByte(Int32(42)), 42);  
  
  Assert.Throws(->Convert.ToByte(Int32(259)));
  Assert.Throws(->Convert.ToByte(Int32(-1)));
end;

method ConvertTest.ToByteInt64;
begin
  Assert.AreEqual(Convert.ToByte(Int64(0)), 0);
  Assert.AreEqual(Convert.ToByte(Int64(42)), 42);  
  
  Assert.Throws(->Convert.ToByte(Int64(259)));
  Assert.Throws(->Convert.ToByte(Int64(-1)));
end;

method ConvertTest.ToByteChar;
begin
  Assert.AreEqual(Convert.ToByte(Char(#0)), 0);
  Assert.AreEqual(Convert.ToByte(Char(#13)), 13);  
  
  Assert.Throws(->Convert.ToByte(Char(#388)));  
end;

method ConvertTest.ToByteString;
begin
  Assert.AreEqual(Convert.ToByte(nil), 0);
  Assert.AreEqual(Convert.ToByte("0"), 0);
  Assert.AreEqual(Convert.ToByte("255"), 255);
  
  Assert.Throws(->Convert.ToByte(""), typeOf(SugarFormatException));
  Assert.Throws(->Convert.ToByte("-1"));
  Assert.Throws(->Convert.ToByte("5.25"));
  Assert.Throws(->Convert.ToByte("FF"));
end;

method ConvertTest.ToCharInt32;
begin
  Assert.AreEqual(Convert.ToChar(Int32(13)), #13);
  Assert.AreEqual(Convert.ToChar(Int32(0)), #0);

  Assert.Throws(->Convert.ToChar(Consts.MaxInteger));
  Assert.Throws(->Convert.ToChar(Consts.MinInteger));
end;

method ConvertTest.ToCharInt64;
begin
  Assert.AreEqual(Convert.ToChar(Int64(13)), #13);
  Assert.AreEqual(Convert.ToChar(Int64(0)), #0);

  Assert.Throws(->Convert.ToChar(Consts.MaxInt64));
  Assert.Throws(->Convert.ToChar(Consts.MinInt64));
end;

method ConvertTest.ToCharByte;
begin
  Assert.AreEqual(Convert.ToChar(Byte(13)), #13);
  Assert.AreEqual(Convert.ToChar(Byte(0)), #0);
  Assert.AreEqual(Convert.ToChar(Byte(255)), #255);
end;

method ConvertTest.ToCharString;
begin
  Assert.AreEqual(Convert.ToChar(" "), #32);

  Assert.Throws(->Convert.ToChar(""));
  Assert.Throws(->Convert.ToChar(nil));
  Assert.Throws(->Convert.ToChar("xx"));
end;

method ConvertTest.ToBooleanDouble;
begin
  Assert.IsFalse(Convert.ToBoolean(Double(0.0)));
  Assert.IsTrue(Convert.ToBoolean(Double(0.1)));
  Assert.IsTrue(Convert.ToBoolean(Double(-1.1)));
  Assert.IsTrue(Convert.ToBoolean(Consts.NaN));
  Assert.IsTrue(Convert.ToBoolean(Consts.NegativeInfinity));
  Assert.IsTrue(Convert.ToBoolean(Consts.PositiveInfinity));
end;

method ConvertTest.ToBooleanInt32;
begin
  Assert.IsFalse(Convert.ToBoolean(Int32(0)));
  Assert.IsTrue(Convert.ToBoolean(Int32(1)));
  Assert.IsTrue(Convert.ToBoolean(Int32(-1)));
end;

method ConvertTest.ToBooleanInt64;
begin
  Assert.IsFalse(Convert.ToBoolean(Int64(0)));
  Assert.IsTrue(Convert.ToBoolean(Int64(1)));
  Assert.IsTrue(Convert.ToBoolean(Int64(-1)));
end;

method ConvertTest.ToBooleanByte;
begin
  Assert.IsFalse(Convert.ToBoolean(Byte(0)));
  Assert.IsTrue(Convert.ToBoolean(Byte(1)));
  Assert.IsTrue(Convert.ToBoolean(Byte(-1)));
end;

method ConvertTest.ToBooleanString;
begin
  Assert.IsTrue(Convert.ToBoolean(Consts.TrueString));
  Assert.IsFalse(Convert.ToBoolean(Consts.FalseString));
  Assert.IsFalse(Convert.ToBoolean(nil));

  Assert.Throws(->Convert.ToBoolean(""));
  Assert.Throws(->Convert.ToBoolean("a"));
  Assert.Throws(->Convert.ToBoolean("yes"));
  Assert.Throws(->Convert.ToBoolean("no"));
end;

end.

namespace Sugar.Test;

interface

{$HIDE W0} //supress case-mismatch errors

uses
  Sugar,
  Sugar.TestFramework;

type
  MathTest = public class (Testcase)
  private
    const Deg: Integer = 30;
    const Rad: Double = Deg * (Consts.PI / 180);
  public
    method AbsDouble;
    method AbsInt64;
    method AbsInt;
    method Acos;
    method Asin;
    method Atan;
    method Atan2;
    method Ceiling;
    method Cos;
    method Cosh;
    method Exp;
    method Floor;
    method IEEERemainder;
    method Log;
    method Log10;
    method MaxDouble;
    method MaxInt;
    method MaxInt64;
    method MinDouble;
    method MinInt;
    method MinInt64;
    method Pow;
    method Round;
    method RoundToInt;
    method Sign;
    method Sin;
    method Sinh;
    method Sqrt;
    method Tan;
    method Tanh;
    method Truncate;
  end;

implementation

method MathTest.AbsDouble;
begin
  Assert.CheckDouble(1.1, Math.Abs(1.1));
  Assert.CheckDouble(1.1, Math.Abs(-1.1));
  Assert.CheckDouble(0, Math.Abs(0));
  Assert.CheckDouble(Consts.MaxDouble, Math.Abs(Consts.MaxDouble));
  Assert.CheckDouble(Consts.MaxDouble, Math.Abs(Consts.MinDouble));
  Assert.CheckBool(true, Consts.IsInfinity(Math.Abs(Consts.PositiveInfinity)));
  Assert.CheckBool(true, Consts.IsInfinity(Math.Abs(Consts.NegativeInfinity)));
  Assert.CheckBool(true, Consts.IsNaN(Math.Abs(Consts.NaN)));
end;

method MathTest.AbsInt64;
begin
  {$WARNING Disable due to iOS 7 bug}
  //Assert.CheckInt64(42, Math.Abs(42));
  //Assert.CheckInt64(42, Math.Abs(-42));
  //Assert.CheckInt64(0, Math.Abs(0));
  //Assert.CheckInt64(Consts.MaxInt64, Math.Abs(Consts.MaxInt64));
  //Assert.IsException(->Math.Abs(Consts.MinInt64));  
end;

method MathTest.AbsInt;
begin
  Assert.CheckInt(42, Math.Abs(42));
  Assert.CheckInt(42, Math.Abs(-42));
  Assert.CheckInt(0, Math.Abs(0));
  Assert.CheckInt(Consts.MaxInteger, Math.Abs(Consts.MaxInteger));
  Assert.IsException(->Math.Abs(Consts.MinInteger));
end;

method MathTest.Acos;
begin
  Assert.CheckDouble(0.722734247813416, Math.Acos(0.75));
  Assert.CheckDouble(0, Math.Acos(1));
  Assert.CheckDouble(Consts.PI, Math.Acos(-1));
  var Value := Math.Acos(1.1);
  Assert.CheckBool(true, Consts.IsNaN(Value));
  Value := Math.Acos(-1.1);
  Assert.CheckBool(true, Consts.IsNaN(Value));
  Assert.CheckBool(true, Consts.IsNaN(Math.Acos(Consts.NaN)));
end;

method MathTest.Asin;
begin
  Assert.CheckDouble(0.848062078981481, Math.Asin(0.75));
  Assert.CheckDouble(Consts.PI/2, Math.Asin(1));
  Assert.CheckDouble(-(Consts.PI/2), Math.Asin(-1));
  var Value := Math.Asin(1.1);
  Assert.CheckBool(true, Consts.IsNaN(Value));
  Value := Math.Asin(-1.1);
  Assert.CheckBool(true, Consts.IsNaN(Value));
  Assert.CheckBool(true, Consts.IsNaN(Math.Asin(Consts.NaN)));
end;

method MathTest.Atan;
begin
  var Tan30 := Math.Tan(Rad);
  Assert.CheckInt(Deg, Math.RoundToInt(Math.Atan(Tan30) * (180 / Consts.PI)));
  Assert.CheckBool(true, Consts.IsNaN(Math.Atan(Consts.NaN)));
  Assert.CheckDouble(Consts.PI / 2, Math.Atan(Consts.PositiveInfinity));
  Assert.CheckDouble(-(Consts.PI / 2), Math.Atan(Consts.NegativeInfinity));
end;

method MathTest.Atan2;
begin
  Assert.CheckDouble(1.10714871779409, Math.Atan2(2, 1));
  Assert.CheckBool(true, Consts.IsNaN(Math.Atan2(1, Consts.NaN)));
  Assert.CheckBool(true, Consts.IsNaN(Math.Atan2(Consts.NaN, 1)));
  Assert.CheckBool(true, Consts.IsNaN(Math.Atan2(Consts.PositiveInfinity, Consts.NegativeInfinity)));
end;

method MathTest.Ceiling;
begin
  Assert.CheckDouble(8, Math.Ceiling(7.1));
  Assert.CheckDouble(-7, Math.Ceiling(-7.1));
  Assert.CheckBool(true, Consts.IsNaN(Math.Ceiling(Consts.NaN)));
  Assert.CheckBool(true, Consts.IsNegativeInfinity(Math.Ceiling(Consts.NegativeInfinity)));
  Assert.CheckBool(true, Consts.IsPositiveInfinity(Math.Ceiling(Consts.PositiveInfinity)));
end;

method MathTest.Cos;
begin
  Assert.CheckDouble(Math.Sin(Rad * 2), Math.Cos(Rad));
  Assert.CheckDouble(Math.Sqrt(3) / 2, Math.Cos(Rad));
  Assert.CheckBool(true, Consts.IsNaN(Math.Cos(Consts.NaN)));
  Assert.CheckBool(true, Consts.IsNaN(Math.Cos(Consts.NegativeInfinity)));
  Assert.CheckBool(true, Consts.IsNaN(Math.Cos(Consts.PositiveInfinity)));
end;

method MathTest.Cosh;
begin
  var Value := Math.Cosh(Rad);
  Assert.CheckDouble(Math.Cosh(-Rad), Value);
  //cosh(x)^2 - sinh(x)^2 = 1
  Assert.CheckDouble(1, (Value * Value) - (Math.Sinh(Rad) * Math.Sinh(Rad)));
  Assert.CheckBool(true, Consts.IsNaN(Math.Cosh(Consts.NaN)));
  Assert.CheckBool(true, Consts.IsPositiveInfinity(Math.Cosh(Consts.NegativeInfinity)));
  Assert.CheckBool(true, Consts.IsPositiveInfinity(Math.Cosh(Consts.PositiveInfinity)));
end;

method MathTest.Exp;
begin
  Assert.CheckDouble(Consts.E * Consts.E, Math.Exp(2));
  Assert.CheckDouble(1, Math.Exp(0));  

  Assert.CheckBool(true, Consts.IsNaN(Math.Exp(Consts.NaN)));  
  Assert.CheckBool(true, Consts.IsPositiveInfinity(Math.Exp(Consts.PositiveInfinity)));
  Assert.CheckDouble(0, Math.Exp(Consts.NegativeInfinity));
end;

method MathTest.Floor;
begin
  Assert.CheckDouble(7, Math.Floor(7.1));
  Assert.CheckDouble(-8, Math.Floor(-7.1));
  Assert.CheckBool(true, Consts.IsNaN(Math.Floor(Consts.NaN)));
  Assert.CheckBool(true, Consts.IsNegativeInfinity(Math.Floor(Consts.NegativeInfinity)));
  Assert.CheckBool(true, Consts.IsPositiveInfinity(Math.Floor(Consts.PositiveInfinity)));
end;

method MathTest.IEEERemainder;
begin
  Assert.CheckDouble(-1, Math.IEEERemainder(11, 3));
  Assert.CheckDouble(0, Math.IEEERemainder(0, 3));
  var Value := Math.IEEERemainder(11, 0);
  Assert.CheckBool(true, Consts.IsNaN(Value));
end;

method MathTest.Log;
begin
  Assert.CheckDouble(0, Math.Log(1));
  Assert.CheckBool(true, Consts.IsNaN(Math.Log(-1)));
  Assert.CheckBool(true, Consts.IsNegativeInfinity(Math.Log(0)));

  Assert.CheckBool(true, Consts.IsNaN(Math.Log(Consts.NaN)));
  Assert.CheckBool(true, Consts.IsNaN(Math.Log(Consts.NegativeInfinity)));
  Assert.CheckBool(true, Consts.IsPositiveInfinity(Math.Log(Consts.PositiveInfinity)));
end;

method MathTest.Log10;
begin
  Assert.CheckDouble(0, Math.Log10(1));
  Assert.CheckDouble(1, Math.Log10(10));
  Assert.CheckDouble(2, Math.Log10(100));
  Assert.CheckDouble(Math.Log10(4) - Math.Log10(2), Math.Log10(4 / 2));
  Assert.CheckBool(true, Consts.IsNaN(Math.Log10(-1)));
  Assert.CheckBool(true, Consts.IsNegativeInfinity(Math.Log10(0)));
  Assert.CheckBool(true, Consts.IsNaN(Math.Log10(Consts.NaN)));
  Assert.CheckBool(true, Consts.IsNaN(Math.Log10(Consts.NegativeInfinity)));
  Assert.CheckBool(true, Consts.IsPositiveInfinity(Math.Log10(Consts.PositiveInfinity)));
end;

method MathTest.MaxDouble;
begin
  Assert.CheckDouble(1.19, Math.Max(1.11, 1.19));
  Assert.CheckDouble(0, Math.Max(0, -1));
  Assert.CheckDouble(-1.11, Math.Max(-1.11, -1.19));
  Assert.CheckDouble(Consts.MaxDouble, Math.Max(Consts.MaxDouble, Consts.MinDouble));
  Assert.CheckBool(true, Consts.IsPositiveInfinity(Math.Max(Consts.PositiveInfinity, Consts.NegativeInfinity)));
  Assert.CheckBool(true, Consts.IsNaN(Math.Max(Consts.NaN, 1)));
  Assert.CheckBool(true, Consts.IsNaN(Math.Max(1, Consts.NaN)));
end;

method MathTest.MaxInt;
begin
  Assert.CheckInt(5, Math.Max(5, 4));
  Assert.CheckInt(-4, Math.Max(-5, -4));
  Assert.CheckInt(Consts.MaxInteger, Math.Max(Consts.MaxInteger, Consts.MinInteger));
end;

method MathTest.MaxInt64;
begin
  Assert.CheckInt64(5, Math.Max(5, 4));
  Assert.CheckInt64(-4, Math.Max(-5, -4));
  Assert.CheckInt64(Consts.MaxInt64, Math.Max(Consts.MaxInt64, Consts.MinInt64));
end;

method MathTest.MinDouble;
begin
  Assert.CheckDouble(1.1, Math.Min(1.1, 1.11));
  Assert.CheckDouble(-1.11, Math.Min(-1.1, -1.11));
  Assert.CheckDouble(Consts.MinDouble, Math.Min(Consts.MinDouble, Consts.MaxDouble));
  Assert.CheckBool(true, Consts.IsNegativeInfinity(Math.Min(Consts.PositiveInfinity, Consts.NegativeInfinity)));
  Assert.CheckBool(true, Consts.IsNaN(Math.Min(Consts.NaN, 1)));
  Assert.CheckBool(true, Consts.IsNaN(Math.Min(1, Consts.NaN)));
end;

method MathTest.MinInt;
begin
  Assert.CheckInt(5, Math.Min(5,6));
  Assert.CheckInt(-6, Math.Min(-5, -6));
  Assert.CheckInt(Consts.MinInteger, Math.Min(Consts.MinInteger, Consts.MaxInteger));
end;

method MathTest.MinInt64;
begin
  Assert.CheckInt64(5, Math.Min(5,6));
  Assert.CheckInt64(-6, Math.Min(-5, -6));
  Assert.CheckInt64(Consts.MinInt64, Math.Min(Consts.MinInt64, Consts.MaxInt64));
end;

method MathTest.Pow;
begin
  Assert.CheckDouble(2 * 2, Math.Pow(2, 2));
  Assert.CheckDouble(0.25, Math.Pow(2, -2));
  var Value := Math.Pow(0, 55);
  Assert.CheckDouble(0, Value);
  Value := Math.Pow(0, -4);
  Assert.CheckBool(true, Consts.IsPositiveInfinity(Value));
  Assert.CheckDouble(1, Math.Pow(1, 5));
  Assert.CheckDouble(1, Math.Pow(1, 555));

  Assert.CheckBool(true, Consts.IsNaN(Math.Pow(2, Consts.NaN))); //x or y = NaN
  Assert.CheckBool(true, Consts.IsNaN(Math.Pow(Consts.NaN, 2))); 
  Assert.CheckDouble(0, Math.Pow(Consts.NegativeInfinity, -2)); //x = NegativeInfinity; y < 0.
  Assert.CheckBool(true, Consts.IsNegativeInfinity(Math.Pow(Consts.NegativeInfinity, 3))); //-inf if y is odd integer
  Assert.CheckBool(true, Consts.IsPositiveInfinity(Math.Pow(Consts.NegativeInfinity, 2))); //+inf if y is not an odd integer
  Assert.CheckBool(true, Consts.IsNaN(Math.Pow(-2, 2.2))); //x < 0 but not NegativeInfinity; y is not an integer, NegativeInfinity, or PositiveInfinity.
  Assert.CheckBool(true, Consts.IsNaN(Math.Pow(-1, Consts.PositiveInfinity))); //x = -1; y = NegativeInfinity or PositiveInfinity.
  Assert.CheckBool(true, Consts.IsPositiveInfinity(Math.Pow(0.5, Consts.NegativeInfinity))); //-1 < x < 1; y = NegativeInfinity.
  Assert.CheckDouble(0, Math.Pow(0.5, Consts.PositiveInfinity)); //-1 < x < 1; y = PositiveInfinity.
  Assert.CheckDouble(0, Math.Pow(2, Consts.NegativeInfinity)); //x < -1 or x > 1; y = NegativeInfinity.
  Assert.CheckDouble(0, Math.Pow(Consts.PositiveInfinity, -2)); //x = PositiveInfinity; y < 0.
  Assert.CheckBool(true, Consts.IsPositiveInfinity(Math.Pow(2, Consts.PositiveInfinity))); //x < -1 or x > 1; y = PositiveInfinity.
  Assert.CheckBool(true, Consts.IsPositiveInfinity(Math.Pow(0, -2))); //x = 0; y < 0.
  Assert.CheckBool(true, Consts.IsPositiveInfinity(Math.Pow(Consts.PositiveInfinity, 2))); //x = PositiveInfinity; y > 0.
end;

method MathTest.Round;
begin
  Assert.CheckDouble(3, Math.Round(Consts.PI));
  //
  Assert.CheckDouble(10, Math.Round(10.0));
  Assert.CheckDouble(10, Math.Round(10.1));
  Assert.CheckDouble(10, Math.Round(10.2));
  Assert.CheckDouble(10, Math.Round(10.3));
  Assert.CheckDouble(10, Math.Round(10.4));
  Assert.CheckDouble(10, Math.Round(10.5));
  Assert.CheckDouble(11, Math.Round(10.6));
  Assert.CheckDouble(11, Math.Round(10.7));
  Assert.CheckDouble(11, Math.Round(10.8));
  Assert.CheckDouble(11, Math.Round(10.9));

  Assert.CheckBool(true, Consts.IsNaN(Math.Round(Consts.NaN)));
  Assert.CheckBool(true, Consts.IsNegativeInfinity(Math.Round(Consts.NegativeInfinity)));
  Assert.CheckBool(true, Consts.IsPositiveInfinity(Math.Round(Consts.PositiveInfinity)));
end;

method MathTest.RoundToInt;
begin
  Assert.CheckInt(3, Math.RoundToInt(Consts.PI));
  Assert.CheckInt(10, Math.RoundToInt(10.5));
  Assert.CheckInt(11, Math.RoundToInt(10.6));  
end;

method MathTest.Sign;
begin
  Assert.CheckInt(-1, Math.Sign(-5));
  Assert.CheckInt(1, Math.Sign(5));
  Assert.CheckInt(0, Math.Sign(0));
  Assert.IsException(->Math.Sign(Consts.NaN));
end;

method MathTest.Sin;
begin
  Assert.CheckDouble(0.5, Math.Sin(Rad));
  Assert.CheckDouble(Math.Cos(Rad * 2), Math.Sin(Rad));
  Assert.CheckBool(true, Consts.IsNaN(Math.Sin(Consts.NaN)));
  Assert.CheckBool(true, Consts.IsNaN(Math.Sin(Consts.NegativeInfinity)));
  Assert.CheckBool(true, Consts.IsNaN(Math.Sin(Consts.PositiveInfinity)));
end;

method MathTest.Sinh;
begin
  var Value := Math.Sinh(Rad);
  Assert.CheckDouble(1, (Math.Cosh(Rad) * Math.CosH(Rad)) - (Value * Value));
  Assert.CheckDouble(Math.Sinh(Consts.PI / 6), Value);

  Assert.CheckBool(true, Consts.IsNaN(Math.Sinh(Consts.NaN)));
  Assert.CheckBool(true, Consts.IsNegativeInfinity(Math.Sinh(Consts.NegativeInfinity)));
  Assert.CheckBool(true, Consts.IsPositiveInfinity(Math.Sinh(Consts.PositiveInfinity)));
end;

method MathTest.Sqrt;
begin
  Assert.CheckDouble(2, Math.Sqrt(4));
  Assert.CheckDouble(0, Math.Sqrt(0));
  Assert.CheckBool(true, Consts.IsNaN(Math.Sqrt(-2)));
  Assert.CheckBool(true, Consts.IsNaN(Math.Sqrt(Consts.NaN)));  
  Assert.CheckBool(true, Consts.IsPositiveInfinity(Math.Sqrt(Consts.PositiveInfinity)));
end;

method MathTest.Tan;
begin
  Assert.CheckDouble(1 / Math.Sqrt(3), Math.Tan(Rad));
  Assert.CheckDouble(1, Math.Tan(45 * (Consts.PI / 180)));
  Assert.CheckBool(true, Consts.IsNaN(Math.Tan(Consts.NaN)));
  Assert.CheckBool(true, Consts.IsNaN(Math.Tan(Consts.NegativeInfinity)));
  Assert.CheckBool(true, Consts.IsNaN(Math.Tan(Consts.PositiveInfinity)));
end;

method MathTest.Tanh;
begin
  Assert.CheckDouble(Math.Tanh(Consts.PI / 6), Math.Tanh(Rad));
  Assert.CheckDouble(1, Math.Tanh(Consts.PositiveInfinity));
  Assert.CheckDouble(-1, Math.Tanh(Consts.NegativeInfinity));
  Assert.CheckBool(true, Consts.IsNaN(Math.Tanh(Consts.NaN)));
end;

method MathTest.Truncate;
begin
  Assert.CheckDouble(42, Math.Truncate(42.464646));
  Assert.CheckDouble(-42, Math.Truncate(-42.464646));
  Assert.CheckBool(true, Consts.IsNaN(Math.Truncate(Consts.NaN)));
  Assert.CheckBool(true, Consts.IsNegativeInfinity(Math.Truncate(Consts.NegativeInfinity)));
  Assert.CheckBool(true, Consts.IsPositiveInfinity(Math.Truncate(Consts.PositiveInfinity)));
end;



end.
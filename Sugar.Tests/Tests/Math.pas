namespace Sugar.Test;

interface

uses
  Sugar,
  RemObjects.Elements.EUnit;

type
  MathTest = public class (Test)
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
  Assert.AreEqual(Math.Abs(1.1), 1.1);
  Assert.AreEqual(Math.Abs(-1.1), 1.1);
  Assert.AreEqual(Math.Abs(0), 0);
  Assert.AreEqual(Math.Abs(Consts.MaxDouble), Consts.MaxDouble);
  Assert.AreEqual(Math.Abs(Consts.MinDouble), Consts.MaxDouble);
  Assert.IsTrue(Consts.IsInfinity(Math.Abs(Consts.PositiveInfinity)));
  Assert.IsTrue(Consts.IsInfinity(Math.Abs(Consts.NegativeInfinity)));
  Assert.IsTrue(Consts.IsNaN(Math.Abs(Consts.NaN)));
end;

method MathTest.AbsInt64;
begin
  Assert.AreEqual(Math.Abs(42), 42);
  Assert.AreEqual(Math.Abs(-42), 42);
  Assert.AreEqual(Math.Abs(0), 0);
  Assert.AreEqual(Math.Abs(Consts.MaxInt64), Consts.MaxInt64);
  Assert.Throws(->Math.Abs(Consts.MinInt64));  
end;

method MathTest.AbsInt;
begin
  Assert.AreEqual(Math.Abs(42), 42);
  Assert.AreEqual(Math.Abs(-42), 42);
  Assert.AreEqual(Math.Abs(0), 0);
  Assert.AreEqual(Math.Abs(Consts.MaxInteger), Consts.MaxInteger);
  Assert.Throws(->Math.Abs(Consts.MinInteger));
end;

method MathTest.Acos;
begin
  Assert.AreEqual(Math.Acos(0.75), 0.722734247813416, 0.00000000001);
  Assert.AreEqual(Math.Acos(1), 0);
  Assert.AreEqual(Math.Acos(-1), Consts.PI);
  var Value := Math.Acos(1.1);
  Assert.IsTrue(Consts.IsNaN(Value));
  Value := Math.Acos(-1.1);
  Assert.IsTrue(Consts.IsNaN(Value));
  Assert.IsTrue(Consts.IsNaN(Math.Acos(Consts.NaN)));
end;

method MathTest.Asin;
begin
  Assert.AreEqual(Math.Asin(0.75), 0.848062078981481, 0.00000000001);
  Assert.AreEqual(Math.Asin(1), Consts.PI/2);
  Assert.AreEqual(Math.Asin(-1), -(Consts.PI/2));
  var Value := Math.Asin(1.1);
  Assert.IsTrue(Consts.IsNaN(Value));
  Value := Math.Asin(-1.1);
  Assert.IsTrue(Consts.IsNaN(Value));
  Assert.IsTrue(Consts.IsNaN(Math.Asin(Consts.NaN)));
end;

method MathTest.Atan;
begin
  var Tan30 := Math.Tan(Rad);
  Assert.AreEqual(Math.Round(Math.Atan(Tan30) * (180 / Consts.PI)), Deg);
  Assert.IsTrue(Consts.IsNaN(Math.Atan(Consts.NaN)));
  Assert.AreEqual(Math.Atan(Consts.PositiveInfinity), Consts.PI / 2);
  Assert.AreEqual(Math.Atan(Consts.NegativeInfinity), -(Consts.PI / 2));
end;

method MathTest.Atan2;
begin
  Assert.AreEqual(Math.Atan2(2, 1), 1.10714871779409, 0.00000000001);
  Assert.IsTrue(Consts.IsNaN(Math.Atan2(1, Consts.NaN)));
  Assert.IsTrue(Consts.IsNaN(Math.Atan2(Consts.NaN, 1)));
  Assert.IsTrue(Consts.IsNaN(Math.Atan2(Consts.PositiveInfinity, Consts.NegativeInfinity)));
end;

method MathTest.Ceiling;
begin
  Assert.AreEqual(Math.Ceiling(7.1), 8);
  Assert.AreEqual(Math.Ceiling(-7.1), -7);
  Assert.IsTrue(Consts.IsNaN(Math.Ceiling(Consts.NaN)));
  Assert.IsTrue(Consts.IsNegativeInfinity(Math.Ceiling(Consts.NegativeInfinity)));
  Assert.IsTrue(Consts.IsPositiveInfinity(Math.Ceiling(Consts.PositiveInfinity)));
end;

method MathTest.Cos;
begin
  Assert.AreEqual(Math.Cos(Rad), Math.Sin(Rad * 2), 0.000000000001);
  Assert.AreEqual(Math.Cos(Rad), Math.Sqrt(3) / 2, 0.000000000001);
  Assert.IsTrue(Consts.IsNaN(Math.Cos(Consts.NaN)));
  Assert.IsTrue(Consts.IsNaN(Math.Cos(Consts.NegativeInfinity)));
  Assert.IsTrue(Consts.IsNaN(Math.Cos(Consts.PositiveInfinity)));
end;

method MathTest.Cosh;
begin
  var Value := Math.Cosh(Rad);
  Assert.AreEqual(Value, Math.Cosh(-Rad));
  //cosh(x)^2 - sinh(x)^2 = 1
  Assert.AreEqual((Value * Value) - (Math.Sinh(Rad) * Math.Sinh(Rad)), 1, 0.1);
  Assert.IsTrue(Consts.IsNaN(Math.Cosh(Consts.NaN)));
  Assert.IsTrue(Consts.IsPositiveInfinity(Math.Cosh(Consts.NegativeInfinity)));
  Assert.IsTrue(Consts.IsPositiveInfinity(Math.Cosh(Consts.PositiveInfinity)));
end;

method MathTest.Exp;
begin
  Assert.AreEqual(Math.Exp(2), Consts.E * Consts.E, 0.0000000000001);
  Assert.AreEqual(Math.Exp(0), 1);

  Assert.IsTrue(Consts.IsNaN(Math.Exp(Consts.NaN)));  
  Assert.IsTrue(Consts.IsPositiveInfinity(Math.Exp(Consts.PositiveInfinity)));
  Assert.AreEqual(Math.Exp(Consts.NegativeInfinity), 0);
end;

method MathTest.Floor;
begin
  Assert.AreEqual(Math.Floor(7.1), 7);
  Assert.AreEqual(Math.Floor(-7.1), -8);
  Assert.IsTrue(Consts.IsNaN(Math.Floor(Consts.NaN)));
  Assert.IsTrue(Consts.IsNegativeInfinity(Math.Floor(Consts.NegativeInfinity)));
  Assert.IsTrue(Consts.IsPositiveInfinity(Math.Floor(Consts.PositiveInfinity)));
end;

method MathTest.IEEERemainder;
begin
  Assert.AreEqual(Math.IEEERemainder(11, 3), -1);
  Assert.AreEqual(Math.IEEERemainder(0, 3), 0);
  var Value := Math.IEEERemainder(11, 0);
  Assert.IsTrue(Consts.IsNaN(Value));
end;

method MathTest.Log;
begin
  Assert.AreEqual(Math.Log(1), 0);
  Assert.IsTrue(Consts.IsNaN(Math.Log(-1)));
  Assert.IsTrue(Consts.IsNegativeInfinity(Math.Log(0)));

  Assert.IsTrue(Consts.IsNaN(Math.Log(Consts.NaN)));
  Assert.IsTrue(Consts.IsNaN(Math.Log(Consts.NegativeInfinity)));
  Assert.IsTrue(Consts.IsPositiveInfinity(Math.Log(Consts.PositiveInfinity)));
end;

method MathTest.Log10;
begin
  Assert.AreEqual(Math.Log10(1), 0);
  Assert.AreEqual(Math.Log10(10), 1);
  Assert.AreEqual(Math.Log10(100), 2);
  Assert.AreEqual(Math.Log10(4 / 2), Math.Log10(4) - Math.Log10(2));
  Assert.IsTrue(Consts.IsNaN(Math.Log10(-1)));
  Assert.IsTrue(Consts.IsNegativeInfinity(Math.Log10(0)));
  Assert.IsTrue(Consts.IsNaN(Math.Log10(Consts.NaN)));
  Assert.IsTrue(Consts.IsNaN(Math.Log10(Consts.NegativeInfinity)));
  Assert.IsTrue(Consts.IsPositiveInfinity(Math.Log10(Consts.PositiveInfinity)));
end;

method MathTest.MaxDouble;
begin
  Assert.AreEqual(Math.Max(1.11, 1.19), 1.19);
  Assert.AreEqual(Math.Max(0, -1), 0);
  Assert.AreEqual(Math.Max(-1.11, -1.19), -1.11);
  Assert.AreEqual(Math.Max(Consts.MaxDouble, Consts.MinDouble), Consts.MaxDouble);
  Assert.IsTrue(Consts.IsPositiveInfinity(Math.Max(Consts.PositiveInfinity, Consts.NegativeInfinity)));
  Assert.IsTrue(Consts.IsNaN(Math.Max(Consts.NaN, 1)));
  Assert.IsTrue(Consts.IsNaN(Math.Max(1, Consts.NaN)));
end;

method MathTest.MaxInt;
begin
  Assert.AreEqual(Math.Max(5, 4), 5);
  Assert.AreEqual(Math.Max(-5, -4), -4);
  Assert.AreEqual(Math.Max(Consts.MaxInteger, Consts.MinInteger), Consts.MaxInteger);
end;

method MathTest.MaxInt64;
begin
  Assert.AreEqual(Math.Max(Int64(5), Int64(4)), 5);
  Assert.AreEqual(Math.Max(Int64(-5), Int64(-4)), -4);
  Assert.AreEqual(Math.Max(Consts.MaxInt64, Consts.MinInt64), Consts.MaxInt64);
end;

method MathTest.MinDouble;
begin
  Assert.AreEqual(Math.Min(1.1, 1.11), 1.1);
  Assert.AreEqual(Math.Min(-1.1, -1.11), -1.11);
  Assert.AreEqual(Math.Min(Consts.MinDouble, Consts.MaxDouble), Consts.MinDouble);
  Assert.IsTrue(Consts.IsNegativeInfinity(Math.Min(Consts.PositiveInfinity, Consts.NegativeInfinity)));
  Assert.IsTrue(Consts.IsNaN(Math.Min(Consts.NaN, 1)));
  Assert.IsTrue(Consts.IsNaN(Math.Min(1, Consts.NaN)));
end;

method MathTest.MinInt;
begin
  Assert.AreEqual(Math.Min(5,6), 5);
  Assert.AreEqual(Math.Min(-5, -6), -6);
  Assert.AreEqual(Math.Min(Consts.MinInteger, Consts.MaxInteger), Consts.MinInteger);
end;

method MathTest.MinInt64;
begin
  Assert.AreEqual(Math.Min(Int64(5), Int64(6)), 5);
  Assert.AreEqual(Math.Min(Int64(-5), Int64(-6)), -6);
  Assert.AreEqual(Math.Min(Consts.MinInt64, Consts.MaxInt64), Consts.MinInt64);
end;

method MathTest.Pow;
begin
  Assert.AreEqual(Math.Pow(2, 2), 2 * 2);
  Assert.AreEqual(Math.Pow(2, -2), 0.25);
  var Value := Math.Pow(0, 55);
  Assert.AreEqual(Value, 0);
  Value := Math.Pow(0, -4);
  Assert.IsTrue(Consts.IsPositiveInfinity(Value));
  Assert.AreEqual(Math.Pow(1, 5), 1);
  Assert.AreEqual(Math.Pow(1, 555), 1);

  Assert.IsTrue(Consts.IsNaN(Math.Pow(2, Consts.NaN))); //x or y = NaN
  Assert.IsTrue(Consts.IsNaN(Math.Pow(Consts.NaN, 2))); 
  Assert.AreEqual(Math.Pow(Consts.NegativeInfinity, -2), 0); //x = NegativeInfinity; y < 0.
  Assert.IsTrue(Consts.IsNegativeInfinity(Math.Pow(Consts.NegativeInfinity, 3))); //-inf if y is odd integer
  Assert.IsTrue(Consts.IsPositiveInfinity(Math.Pow(Consts.NegativeInfinity, 2))); //+inf if y is not an odd integer
  Assert.IsTrue(Consts.IsNaN(Math.Pow(-2, 2.2))); //x < 0 but not NegativeInfinity; y is not an integer, NegativeInfinity, or PositiveInfinity.
  Assert.IsTrue(Consts.IsNaN(Math.Pow(-1, Consts.PositiveInfinity))); //x = -1; y = NegativeInfinity or PositiveInfinity.
  Assert.IsTrue(Consts.IsPositiveInfinity(Math.Pow(0.5, Consts.NegativeInfinity))); //-1 < x < 1; y = NegativeInfinity.
  Assert.AreEqual(Math.Pow(0.5, Consts.PositiveInfinity), 0); //-1 < x < 1; y = PositiveInfinity.
  Assert.AreEqual(Math.Pow(2, Consts.NegativeInfinity), 0); //x < -1 or x > 1; y = NegativeInfinity.
  Assert.AreEqual(Math.Pow(Consts.PositiveInfinity, -2), 0); //x = PositiveInfinity; y < 0.
  Assert.IsTrue(Consts.IsPositiveInfinity(Math.Pow(2, Consts.PositiveInfinity))); //x < -1 or x > 1; y = PositiveInfinity.
  Assert.IsTrue(Consts.IsPositiveInfinity(Math.Pow(0, -2))); //x = 0; y < 0.
  Assert.IsTrue(Consts.IsPositiveInfinity(Math.Pow(Consts.PositiveInfinity, 2))); //x = PositiveInfinity; y > 0.
end;

method MathTest.Round;
begin
  Assert.AreEqual(3, Math.Round(Consts.PI), 3);
  //
  Assert.AreEqual(Math.Round(10.0), 10);
  Assert.AreEqual(Math.Round(10.1), 10);
  Assert.AreEqual(Math.Round(10.2), 10);
  Assert.AreEqual(Math.Round(10.3), 10);
  Assert.AreEqual(Math.Round(10.4), 10);
  Assert.AreEqual(Math.Round(10.5), 11);
  Assert.AreEqual(Math.Round(10.6), 11);
  Assert.AreEqual(Math.Round(10.7), 11);
  Assert.AreEqual(Math.Round(10.8), 11);
  Assert.AreEqual(Math.Round(10.9), 11);

  Assert.AreEqual(Math.Round(11.0), 11);
  Assert.AreEqual(Math.Round(11.1), 11);
  Assert.AreEqual(Math.Round(11.2), 11);
  Assert.AreEqual(Math.Round(11.3), 11);
  Assert.AreEqual(Math.Round(11.4), 11);
  Assert.AreEqual(Math.Round(11.5), 12);
  Assert.AreEqual(Math.Round(11.6), 12);
  Assert.AreEqual(Math.Round(11.7), 12);
  Assert.AreEqual(Math.Round(11.8), 12);
  Assert.AreEqual(Math.Round(11.9), 12);

  Assert.Throws(->Math.Round(Consts.NaN));
  Assert.Throws(->Math.Round(Consts.PositiveInfinity));
  Assert.Throws(->Math.Round(Consts.NegativeInfinity));
end;

method MathTest.Sign;
begin
  Assert.AreEqual(Math.Sign(-5), -1);
  Assert.AreEqual(Math.Sign(5), 1);
  Assert.AreEqual(Math.Sign(0), 0);
  Assert.Throws(->Math.Sign(Consts.NaN));
end;

method MathTest.Sin;
begin
  Assert.AreEqual(Math.Sin(Rad), 0.5, 0.01);
  Assert.AreEqual(Math.Sin(Rad), Math.Cos(Rad * 2), 0.01);
  Assert.IsTrue(Consts.IsNaN(Math.Sin(Consts.NaN)));
  Assert.IsTrue(Consts.IsNaN(Math.Sin(Consts.NegativeInfinity)));
  Assert.IsTrue(Consts.IsNaN(Math.Sin(Consts.PositiveInfinity)));
end;

method MathTest.Sinh;
begin
  var Value := Math.Sinh(Rad);
  Assert.AreEqual((Math.Cosh(Rad) * Math.CosH(Rad)) - (Value * Value), 1, 0.1);
  Assert.AreEqual(Value, Math.Sinh(Consts.PI / 6));

  Assert.IsTrue(Consts.IsNaN(Math.Sinh(Consts.NaN)));
  Assert.IsTrue(Consts.IsNegativeInfinity(Math.Sinh(Consts.NegativeInfinity)));
  Assert.IsTrue(Consts.IsPositiveInfinity(Math.Sinh(Consts.PositiveInfinity)));
end;

method MathTest.Sqrt;
begin
  Assert.AreEqual(Math.Sqrt(4), 2);
  Assert.AreEqual(Math.Sqrt(0), 0);
  Assert.IsTrue(Consts.IsNaN(Math.Sqrt(-2)));
  Assert.IsTrue(Consts.IsNaN(Math.Sqrt(Consts.NaN)));  
  Assert.IsTrue(Consts.IsPositiveInfinity(Math.Sqrt(Consts.PositiveInfinity)));
end;

method MathTest.Tan;
begin
  Assert.AreEqual(Math.Tan(Rad), 1 / Math.Sqrt(3), 0.00000000001);
  Assert.AreEqual(Math.Tan(45 * (Consts.PI / 180)), 1, 0.1);
  Assert.IsTrue(Consts.IsNaN(Math.Tan(Consts.NaN)));
  Assert.IsTrue(Consts.IsNaN(Math.Tan(Consts.NegativeInfinity)));
  Assert.IsTrue(Consts.IsNaN(Math.Tan(Consts.PositiveInfinity)));
end;

method MathTest.Tanh;
begin
  Assert.AreEqual(Math.Tanh(Rad), Math.Tanh(Consts.PI / 6));
  Assert.AreEqual(Math.Tanh(Consts.PositiveInfinity), 1);
  Assert.AreEqual(Math.Tanh(Consts.NegativeInfinity), -1);
  Assert.IsTrue(Consts.IsNaN(Math.Tanh(Consts.NaN)));
end;

method MathTest.Truncate;
begin
  Assert.AreEqual(Math.Truncate(42.464646), 42);
  Assert.AreEqual(Math.Truncate(-42.464646), -42);
  Assert.IsTrue(Consts.IsNaN(Math.Truncate(Consts.NaN)));
  Assert.IsTrue(Consts.IsNegativeInfinity(Math.Truncate(Consts.NegativeInfinity)));
  Assert.IsTrue(Consts.IsPositiveInfinity(Math.Truncate(Consts.PositiveInfinity)));
end;

end.
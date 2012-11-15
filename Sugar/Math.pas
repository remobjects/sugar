namespace RemObjects.Oxygene.Sugar;

interface

type

  {$IF COOPER}
  Math = public class mapped to java.lang.Math
  public
    method Abs(d: Double): Double; mapped to abs(d);
    method Acos(d: Double): Double; mapped to acos(d);
    method Asin(d: Double): Double; mapped to asin(d);
    method Atan(d: Double): Double; mapped to atan(d);
    method Atan2(x,y: Double): Double; mapped to atan2(x,y);
    method Ceiling(a: Double): Double; mapped to ceil(a);
    method Cos(d: Double): Double; mapped to cos(d);
    method Cosh(d: Double): Double; mapped to cosh(d);
    method Exp(d: Double): Double; mapped to exp(d);
    method Floor(d: Double): Double; mapped to floor(d);   
    method IEEERemainder(x, y: Double): Double; mapped to IEEEremainder(x, y); 
    method Log(d: Double): Double; mapped to log(d);
    method Log10(d: Double): Double; mapped to log10(d);
    method Max(a,b: Double): Double; mapped to max(a,b);   
    method Min(a,b: Double): Double; mapped to min(a,b);
    method Pow(x, y: Double): Double; mapped to pow(x,y);
    method Round(a: Double): Double; mapped to round(a);
    method RoundToInt(a: Double): Integer;
    method Sign(d: Double): Integer;
    method Sin(d: Double): Double; mapped to sin(d);
    method Sinh(d: Double): Double; mapped to sinh(d);
    method Sqrt(d: Double): Double; mapped to sqrt(d);
    method Tan(d: Double): Double; mapped to tan(d);
    method Tanh(d: Double): Double; mapped to tanh(d);
    method Truncate(d: Double): Double;
  {$ENDIF}
  {$IF ECHOES}
  Math = public class mapped to System.Math
  public
    method Abs(d: Double): Double; mapped to Abs(d);
    method Acos(d: Double): Double; mapped to Acos(d);
    method Asin(d: Double): Double; mapped to Asin(d);
    method Atan(d: Double): Double; mapped to Atan(d);
    method Atan2(x,y: Double): Double; mapped to Atan2(x,y);
    method Ceiling(d: Double): Double; mapped to Ceiling(d);
    method Cos(d: Double): Double; mapped to Cos(d);
    method Cosh(d: Double): Double; mapped to Cosh(d);
    method Exp(d: Double): Double; mapped to Exp(d);
    method Floor(d: Double): Double; mapped to Floor(d);
    method IEEERemainder(x, y: Double): Double; mapped to IEEERemainder(x, y); 
    method Log(d: Double): Double; mapped to Log(d);
    method Log10(d: Double): Double; mapped to Log10(d);
    method Max(a,b: Double): Double; mapped to Max(a,b);   
    method Min(a,b: Double): Double; mapped to Min(a,b);
    method Pow(x, y: Double): Double; mapped to Pow(x,y);
    method Round(a: Double): Double; mapped to Round(a);
    method RoundToInt(a: Double): Integer;
    method Sign(d: Double): Integer; mapped to Sign(d);
    method Sin(d: Double): Double; mapped to Sin(d);
    method Sinh(d: Double): Double; mapped to Sinh(d);
    method Sqrt(d: Double): Double; mapped to Sqrt(d);
    method Tan(d: Double): Double; mapped to Tan(d);
    method Tanh(d: Double): Double; mapped to Tanh(d);
    method Truncate(d: Double): Double; mapped to Truncate(d);
  {$ENDIF}
  {$IF NOUGAT}
  Math = public class
  public
    const PI: Double = 3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679;
    const E: Double =  2.7182818284590452353602874713526624977572470936999595749669676277240766303535475945713821785251664274;
    method Abs(value: Double): Double;
    method Acos(d: Double): Double;
    method Asin(d: Double): Double;
    method Atan(d: Double): Double;
    method Atan2(x,y: Double): Double;
    method Ceiling(d: Double): Double;
    method Cos(d: Double): Double;
    method Cosh(d: Double): Double;
    method Exp(d: Double): Double;
    method Floor(d: Double): Double;
    method IEEERemainder(x, y: Double): Double; 
    method Log(a: Double): Double;
    method Log10(a: Double): Double;
    method Max(a,b: Double): Double;    
    method Min(a,b: Double): Double;
    method Pow(x, y: Double): Double;
    method Round(a: Double): Double;
    method RoundToInt(a: Double): Integer;
    method Sign(d: Double): Integer;
    method Sin(x: Double): Double;
    method Sinh(x: Double): Double;
    method Sqrt(d: Double): Double;
    method Tan(d: Double): Double;
    method Tanh(d: Double): Double;
    method Truncate(d: Double): Double;
  {$ENDIF}
  end;

implementation

{$IF COOPER}
method Math.Truncate(d: Double): Double;
begin
  exit iif(d < 0, mapped.ceil(d), mapped.floor(d));
end;
{$ENDIF}

{$IF COOPER or ECHOES}
method Math.RoundToInt(a: Double): Integer;
begin
  exit Integer(mapped.round(a));
end;
{$ENDIF}

{$IF COOPER or NOUGAT}
method Math.Sign(d: Double): Integer;
begin
  if d > 0 then exit 1;
  if d < 0 then exit -1;
  exit 0;
end;
{$ENDIF}

{$IF NOUGAT}
method Math.Pow(x, y: Double): Double;
begin
  exit rtl.Math.pow(x,y);  
end;

method Math.Acos(d: Double): Double;
begin
  exit rtl.Math.acos(d);   
end;

method Math.Cos(d: Double): Double;
begin
  exit rtl.Math.cos(d);   
end;

method Math.Ceiling(d: Double): Double;
begin
  exit rtl.Math.ceil(d);   
end;

method Math.Cosh(d: Double): Double;
begin
  exit rtl.Math.cosh(d);   
end;

method Math.Asin(d: Double): Double;
begin
  exit rtl.Math.asin(d);   
end;

method Math.Atan(d: Double): Double;
begin
  exit rtl.Math.atan(d);   
end;

method Math.Atan2(x,y: Double): Double;
begin
  exit rtl.Math.atan2(x,y);   
end;

method Math.Abs(value: Double): Double;
begin
  exit rtl.Math.fabs(value);   
end;

method Math.Exp(d: Double): Double;
begin
  exit rtl.Math.exp(d);   
end;

method Math.Floor(d: Double): Double;
begin
  exit rtl.Math.floor(d);   
end;

method Math.IEEERemainder(x,y: Double): Double;
begin
  exit rtl.Math.remainder(x,y);   
end;

method Math.Log(a: Double): Double;
begin
  exit rtl.Math.log(a);   
end;

method Math.Log10(a: Double): Double;
begin
  exit rtl.Math.log10(a);   
end;

method Math.Max(a,b: Double): Double;
begin
  exit iif(a > b, a, b);   
end;

method Math.Min(a,b: Double): Double;
begin
  exit iif(a < b, a, b);   
end;

method Math.Round(a: Double): Double;
begin
  exit rtl.Math.round(a);   
end;

method Math.RoundToInt(a: Double): Integer;
begin
  exit Integer(rtl.Math.round(a));   
end;

method Math.Sin(x: Double): Double;
begin
  exit rtl.Math.sin(x);  
end;

method Math.Sinh(x: Double): Double;
begin
  exit rtl.Math.sinh(x);  
end;

method Math.Sqrt(d: Double): Double;
begin
  exit rtl.Math.sqrt(d);  
end;

method Math.Tan(d: Double): Double;
begin
  exit rtl.Math.tan(d);  
end;

method Math.Tanh(d: Double): Double;
begin
  exit rtl.Math.tanh(d);  
end;

method Math.Truncate(d: Double): Double;
begin
  exit rtl.Math.trunc(d);  
end;
{$ENDIF}

end.

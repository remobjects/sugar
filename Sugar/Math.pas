namespace RemObjects.Oxygene.Sugar;

interface

type

  {$IF COOPER}
  Math = public class mapped to java.lang.Math
  public
    method Ceiling(a: Double): Double; mapped to ceil(a);
    method Sign(d: Double): Integer;
    method Truncate(d: Double): Double;
  {$ENDIF}
  {$IF ECHOES}
  Math = public class mapped to System.Math
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
  exit iif(d < 0, Mapped.ceil(d), Mapped.floor(d));
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

{$IF COOPER or NOUGAT}
method Math.Sign(d: Double): Integer;
begin
  if d > 0 then exit 1;
  if d < 0 then exit -1;
  exit 0;
end;
{$ENDIF}

end.

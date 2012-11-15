namespace RemObjects.Oxygene.Sugar;

interface

type

  {$IF COOPER}
  Math = public class mapped to java.lang.Math
  {$ENDIF}
  {$IF ECHOES}
  Math = public class mapped to System.Math
  {$ENDIF}
  {$IF NOUGAT}
  Math = public class
  public
    const PI: Double = 3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679;
    const E: Double =  2.7182818284590452353602874713526624977572470936999595749669676277240766303535475945713821785251664274;
    method Pow(x, y: Double): Double;
    method Sin(x: Double): Double;
  {$ENDIF}
  end;

implementation

{$IF NOUGAT}
method Math.Pow(x, y: Double): Double;
begin
  exit rtl.Math.pow(x,y);  
end;

method Math.Sin(x: Double): Double;
begin
  exit rtl.Math.sin(x);  
end;

{$ENDIF}

end.

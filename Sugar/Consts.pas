namespace Sugar;

interface

type
  Consts = public static class
  public
    const PI: Double = 3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679;
    const E: Double =  2.7182818284590452353602874713526624977572470936999595749669676277240766303535475945713821785251664274;

    property MaxInteger: Integer read {$IF COOPER}Int32.MAX_VALUE{$ELSEIF ECHOES}Int32.MaxValue{$ELSEIF TOFFEE}rtl.INT32_MAX{$ENDIF};
    property MinInteger: Integer read {$IF COOPER}Int32.MIN_VALUE{$ELSEIF ECHOES}Int32.MinValue{$ELSEIF TOFFEE}rtl.INT32_MIN{$ENDIF};

    property MaxInt64: Int64 read {$IF COOPER}Int64.MAX_VALUE{$ELSEIF ECHOES}Int64.MaxValue{$ELSEIF TOFFEE}rtl.INT64_MAX{$ENDIF};
    property MinInt64: Int64 read {$IF COOPER}Int64.MIN_VALUE{$ELSEIF ECHOES}Int64.MinValue{$ELSEIF TOFFEE}rtl.INT64_MIN{$ENDIF};

    property MaxChar: Integer read $FFFF;
    property MinChar: Integer read 0;

    property MaxByte: Byte read $FF;
    property MinByte: Byte read 0;

    property MaxDouble: Double read {$IF COOPER}Double.MAX_VALUE{$ELSEIF ECHOES}Double.MaxValue{$ELSEIF TOFFEE}1.7976931348623157E+308{$ENDIF};
    property MinDouble: Double read {$IF COOPER}-Double.MAX_VALUE{$ELSEIF ECHOES}Double.MinValue{$ELSEIF TOFFEE}-1.7976931348623157E+308{$ENDIF};
    property PositiveInfinity: Double read {$IF COOPER}Double.POSITIVE_INFINITY{$ELSEIF ECHOES}Double.PositiveInfinity{$ELSEIF TOFFEE}INFINITY{$ENDIF};
    property NegativeInfinity: Double read {$IF COOPER}Double.NEGATIVE_INFINITY{$ELSEIF ECHOES}Double.NegativeInfinity{$ELSEIF TOFFEE}-INFINITY{$ENDIF};
    property NaN: Double read {$IF COOPER}Double.NaN{$ELSEIF ECHOES}Double.NaN{$ELSEIF TOFFEE}rtl.nan{$ENDIF};

    property TrueString: not nullable String read "True";
    property FalseString: not nullable String read "False";

    method IsNaN(Value: Double): Boolean;
    method IsInfinity(Value: Double): Boolean;
    method IsPositiveInfinity(Value: Double): Boolean;
    method IsNegativeInfinity(Value: Double): Boolean;
  end;

implementation

class method Consts.IsNaN(Value: Double): Boolean;
begin
  {$IF COOPER}
  exit Double.isNaN(Value);
  {$ELSEIF ECHOES}
  exit Double.IsNaN(Value);
  {$ELSEIF TOFFEE}
  exit __inline_isnand(Value) <> 0;
  {$ENDIF}
end;

class method Consts.IsInfinity(Value: Double): Boolean;
begin
  {$IF COOPER}
  exit Double.isInfinite(Value);
  {$ELSEIF ECHOES}
  exit Double.IsInfinity(Value);
  {$ELSEIF TOFFEE}
  exit __inline_isinfd(Value) <> 0;
  {$ENDIF}
end;

class method Consts.IsNegativeInfinity(Value: Double): Boolean;
begin
  {$IF COOPER}
  exit Value = NegativeInfinity;
  {$ELSEIF ECHOES}
  exit Double.IsNegativeInfinity(Value);
  {$ELSEIF TOFFEE}
  exit (Value = NegativeInfinity) and (not Consts.IsNaN(Value));
  {$ENDIF}
end;

class method Consts.IsPositiveInfinity(Value: Double): Boolean;
begin
  {$IF COOPER}
  exit Value = PositiveInfinity;
  {$ELSEIF ECHOES}
  exit Double.IsPositiveInfinity(Value);
  {$ELSEIF TOFFEE}
  exit (Value = PositiveInfinity) and (not Consts.IsNaN(Value));
  {$ENDIF}
end;

end.

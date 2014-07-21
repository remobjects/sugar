namespace Sugar;

interface

type
  {$IF COOPER}
  Random = public class mapped to java.util.Random
  public
    method NextInt: Integer; mapped to nextInt;
    method NextInt(MaxValue: Integer): Integer; mapped to nextInt(MaxValue);
    method NextDouble: Double; mapped to nextDouble;
  end;
  {$ELSE}
  Random = public class 
  private
    const Multiplier: UInt64 = $5DEECE66D;
    const Temp: Uint64 = 1;
    const Mask: UInt64 = (Temp shl 48) - 1;
  private
    Seed: UInt64 := 0;
    method Next(Bits: Integer): UInt32;
  public
    constructor;
    constructor(aSeed: UInt64);

    method NextInt: Integer;
    method NextInt(MaxValue: Integer): Integer;
    method NextDouble: Double;
  end;
  {$ENDIF}

implementation

{$IF NOT COOPER}
method Random.Next(Bits: Integer): UInt32;
begin
  Seed := (Seed * Multiplier + $B) and Mask;
  exit UInt32(Seed shr (48 - Bits));
end;

constructor Random;
begin
  {$IF ECHOES}
  constructor(System.DateTime.Now.Ticks);
  {$ELSEIF NOUGAT}
  var interval: rtl.__struct_timeval;
  gettimeofday(@interval, nil);  
  constructor(interval.tv_usec * interval.tv_sec);
  {$ENDIF}
end;

constructor Random(aSeed: UInt64);
begin
  Seed := (aSeed xor Multiplier) and Mask;
end;

method Random.NextInt: Integer;
begin
  exit Integer(Next(32))
end;

method Random.NextInt(MaxValue: Integer): Integer;
begin
  if MaxValue <= 0 then
    raise new SugarArgumentException("MaxValue must be positive");

  if (MaxValue and -MaxValue) = MaxValue then
    exit Integer((MaxValue * Int64(Next(31))) shr 31);

  var Bits: Int64;
  var Val: Int64;

  repeat
    Bits := Next(31);
    Val := Bits mod UInt32(MaxValue);
  until not (Bits - Val + (MaxValue - 1) < 0);

  exit Integer(Val);
end;

method Random.NextDouble: Double;
begin
  exit ((Int64(Next(26)) shl 27) + Next(27)) / Double((Int64(1) shl 53));
end;
{$ENDIF}

end.

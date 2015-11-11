namespace Sugar;

interface


type
  TimeSpan = public record mapped to {$IFDEF ECHOES}System.Timespan{$ELSEIF NOUGAT}NSTimeInterval{$ELSE}Int64{$ENDIF}
  private
    method get_Days: Integer;
    method get_Hours: Integer;
    method get_Minutes: Integer;
    method get_Seconds: Integer;
    method get_Miliseconds: Integer;
    method get_Ticks: Int64;
    method get_TotalDays: Double;
    method get_TotalHours: Double;
    method get_TotalMinutes: Double;
    method get_TotalSeconds: Double;
  protected
  public
    const
    TicksPerMilisecond: Int64 = 10000;
    TicksPerSecond: Int64 = TicksPerMilisecond * 1000;
    TicksPerMinute: Int64 = TicksPerSecond * 60;
    TicksPerHour: Int64 = TicksPerMinute * 60;
    TicksPerDay: Int64 = TicksPerHour * 24;
    

    property Days: Integer read get_Days;
    property Hours: Integer read get_Hours;
    property Minutes: Integer read get_Minutes;
    property Seconds: Integer read get_Seconds;
    property Miliseconds: Integer read get_Miliseconds;
    property Ticks: Int64 read get_Ticks;

    property TotalDays: Double read get_TotalDays;
    property TotalHours: Double read get_TotalHours;
    property TotalMinutes: Double read get_TotalMinutes;
    property TotalSeconds: Double read get_TotalSeconds;

    constructor(aTicks: Int64);
    constructor(h,m,s: Int32);
    constructor(d,h,m,s: Int32; ms: Int32 := 0);

    method Add(ts: Timespan): Timespan;
    method Subtract(ts: Timespan): TimeSpan;
    method Negate: TimeSpan;

    class method FromDays(d: Double): TimeSpan;
    class method FromHours(d: Double): TimeSpan;
    class method FromMinutes(d: Double): TimeSpan;
    class method FromSeconds(d: Double): TimeSpan;
    class method FromMiliseconds(d: Double): TimeSpan;
    class method FromTicks(d: Int64): TimeSpan;
    
    class operator Equal(a,b: Timespan): Boolean;
    class operator NotEqual(a,b: TimeSpan): Boolean;

    class operator &Add(a,b: Timespan): Timespan;
    class operator Subtract(a,b: TimeSpan): Timespan;
    class operator Plus(a: Timespan): TimeSpan;
    class operator Minus(a: Timespan): TimeSpan;

    class operator Less(a,b: TimeSpan): Boolean;
    class operator LessOrEqual(a,b: TimeSpan): Boolean;
    class operator Greater(a,b: Timespan): Boolean;
    class operator greaterOrEqual(a,b: Timespan): Boolean;
  end;

implementation

constructor TimeSpan(aTicks: Int64);
begin
  {$IFDEF ECHOES}
  exit new System.TimeSpan(aTicks);
  {$ELSEIF COOPER}
  exit aTicks / 1000;
  {$ELSEIF NOUGAT}
  exit aTicks / Double(TicksPerSecond);
  {$ELSE}
  {$ERROR Unknown platform}
  {$ENDIF}
end;

constructor TimeSpan(h: Int32; m: Int32; s: Int32);
begin
  exit new Timespan(((((h * 60) + m) * 60) + s) * TicksPerSecond);
end;

constructor TimeSpan(d: Int32; h: Int32; m: Int32; s: Int32; ms: Int32);
begin
  exit new Timespan(((((((((d * 24) + h) * 60) + m) * 60) + s) * 1000) + ms) * TicksPerMilisecond);
end;

method TimeSpan.get_TotalSeconds: Double;
begin
  exit Double(Ticks) / TicksPerSecond; 
end;

method TimeSpan.get_TotalMinutes: Double;
begin
  exit Double(Ticks) / TicksPerMinute;
end;

method TimeSpan.get_TotalHours: Double;
begin
  exit Double(Ticks) / TicksPerHour;
end;

method TimeSpan.get_TotalDays: Double;
begin
  exit Double(Ticks) / TicksPerDay;
end;

method TimeSpan.get_Ticks: Int64;
begin
  {$IFDEF ECHOES}
  exit mapped.Ticks;
  {$ELSEIF COOPER}
  exit mapped * 1000;
  {$ELSEIF NOUGAT}
  exit Int64(mapped * TicksPerSecond);
  {$ELSE}
  {$ERROR Unknown platform}
  {$ENDIF}
end;

method TimeSpan.get_Seconds: Integer;
begin
  exit (Ticks / TicksPerSecond) mod 60;
end;

method TimeSpan.get_Minutes: Integer;
begin
  exit (Ticks / TicksPerMinute) mod 60;
end;

method TimeSpan.get_Hours: Integer;
begin
  exit (Ticks / TicksPerHour) mod 24;
end;

method TimeSpan.get_Days: Integer;
begin
  exit (Ticks / TicksPerDay) mod 24;
end;

method TimeSpan.get_Miliseconds: Integer;
begin
  exit (Ticks / TicksPerSecond) mod 1000;
end;

method TimeSpan.Add(ts: TimeSpan): TimeSpan;
begin
  {$IFDEF ECHOES}
  exit mapped + System.TimeSpan(ts);
  {$ELSEIF COOPER}
  exit mapped + Int64(ts);
  {$ELSEIF NOUGAT}
  exit mapped + NSTimeInterval(ts);
  {$ELSE}
  {$ERROR Unknown platform}
  {$ENDIF}
end;

method TimeSpan.Subtract(ts: TimeSpan): TimeSpan;
begin
  {$IFDEF ECHOES}
  exit mapped - System.TimeSpan(Ts);
  {$ELSEIF COOPER}
  exit mapped - Int64(ts);
  {$ELSEIF NOUGAT}
  exit mapped - NSTimeInterval(ts);
  {$ELSE}
  {$ERROR Unknown platform}
  {$ENDIF}
end;

method TimeSpan.Negate: TimeSpan;
begin
  {$IFDEF ECHOES}
  exit - mapped;
  {$ELSEIF COOPER}
  exit - mapped;
  {$ELSEIF NOUGAT}
  exit - mapped;
  {$ELSE}
  {$ERROR Unknown platform}
  {$ENDIF}
end;

class method TimeSpan.FromDays(d: Double): TimeSpan;
begin
  exit FromTicks(Int64(d * TicksPerDay));
end;

class method TimeSpan.FromHours(d: Double): TimeSpan;
begin
  exit FromTicks(Int64(d * TicksPerHour));
end;

class method TimeSpan.FromMinutes(d: Double): TimeSpan;
begin
  exit FromTicks(Int64(d * TicksPerMinute));
end;

class method TimeSpan.FromSeconds(d: Double): TimeSpan;
begin  
  exit FromTicks(Int64(d * TicksPerSecond));
end;

class method TimeSpan.FromMiliseconds(d: Double): TimeSpan;
begin
  exit FromTicks(Int64(d * TicksPerMilisecond));
end;

class method TimeSpan.FromTicks(d: Int64): TimeSpan;
begin
  {$IFDEF ECHOES}
  exit System.TimeSpan.FromTicks(d);
  {$ELSEIF COOPER}
  exit d / 1000;
  {$ELSEIF NOUGAT}
  exit double(d) / TicksPerSecond;
  {$ELSE}
  {$ERROR Unknown platform}
  {$ENDIF}
end;

operator TimeSpan.Equal(a: TimeSpan; b: TimeSpan): Boolean;
begin
  {$IFDEF ECHOES}
  exit System.TimeSpan(a) = System.TimeSpan(b);
  {$ELSEIF COOPER}
  exit Int64(a) = Int64(b);
  {$ELSEIF NOUGAT}
  exit NSTimeInterval(a) = NSTimeInterval(b);
  {$ELSE}
  {$ERROR Unknown platform}
  {$ENDIF}
end;

operator TimeSpan.NotEqual(a: TimeSpan; b: TimeSpan): Boolean;
begin
  {$IFDEF ECHOES}
  exit System.TimeSpan(a) <> System.TimeSpan(b);
  {$ELSEIF COOPER}
  exit Int64(a) <> Int64(b);
  {$ELSEIF NOUGAT}
  exit NSTimeInterval(a) <> NSTimeInterval(b);
  {$ELSE}
  {$ERROR Unknown platform}
  {$ENDIF}
end;

operator TimeSpan.Add(a: TimeSpan; b: TimeSpan): TimeSpan;
begin
{$IFDEF ECHOES}
  exit System.TimeSpan(a) + System.TimeSpan(b);
  {$ELSEIF COOPER}
  exit Int64(a) + Int64(b);
  {$ELSEIF NOUGAT}
  exit NSTimeInterval(a) + NSTimeInterval(b);
  {$ELSE}
  {$ERROR Unknown platform}
  {$ENDIF}
end;

operator TimeSpan.Subtract(a: TimeSpan; b: TimeSpan): TimeSpan;
begin
  {$IFDEF ECHOES}
  exit System.TimeSpan(a) - System.TimeSpan(b);
  {$ELSEIF COOPER}
  exit Int64(a) - Int64(b);
  {$ELSEIF NOUGAT}
  exit NSTimeInterval(a) - NSTimeInterval(b);
  {$ELSE}
  {$ERROR Unknown platform}
  {$ENDIF}
end;

operator TimeSpan.Plus(a: TimeSpan): TimeSpan;
begin
  exit a;
end;

operator TimeSpan.Minus(a: TimeSpan): TimeSpan;
begin
  {$IFDEF ECHOES}
  exit -System.TimeSpan(a);
  {$ELSEIF COOPER}
  exit -Int64(a);
  {$ELSEIF NOUGAT}
  exit -NSTimeInterval(a);
  {$ELSE}
  {$ERROR Unknown platform}
  {$ENDIF}
end;

operator TimeSpan.Less(a: TimeSpan; b: TimeSpan): Boolean;
begin
  {$IFDEF ECHOES}
  exit System.TimeSpan(a) < System.TimeSpan(b);
  {$ELSEIF COOPER}
  exit Int64(a) < Int64(b);
  {$ELSEIF NOUGAT}
  exit NSTimeInterval(a) < NSTimeInterval(b);
  {$ELSE}
  {$ERROR Unknown platform}
  {$ENDIF}
end;

operator TimeSpan.LessOrEqual(a: TimeSpan; b: TimeSpan): Boolean;
begin
  {$IFDEF ECHOES}
  exit System.TimeSpan(a) <= System.TimeSpan(b);
  {$ELSEIF COOPER}
  exit Int64(a) <= Int64(b);
  {$ELSEIF NOUGAT}
  exit NSTimeInterval(a) <= NSTimeInterval(b);
  {$ELSE}
  {$ERROR Unknown platform}
  {$ENDIF}
end;

operator TimeSpan.Greater(a: TimeSpan; b: TimeSpan): Boolean;
begin
  {$IFDEF ECHOES}
  exit System.TimeSpan(a) > System.TimeSpan(b);
  {$ELSEIF COOPER}
  exit Int64(a) > Int64(b);
  {$ELSEIF NOUGAT}
  exit NSTimeInterval(a) > NSTimeInterval(b);
  {$ELSE}
  {$ERROR Unknown platform}
  {$ENDIF}
end;

operator TimeSpan.GreaterOrEqual(a: TimeSpan; b: TimeSpan): Boolean;
begin
  {$IFDEF ECHOES}
  exit System.TimeSpan(a) >= System.TimeSpan(b);
  {$ELSEIF COOPER}
  exit Int64(a) >= Int64(b);
  {$ELSEIF NOUGAT}
  exit NSTimeInterval(a) >= NSTimeInterval(b);
  {$ELSE}
  {$ERROR Unknown platform}
  {$ENDIF}
end;

end.

namespace RemObjects.Oxygene.Sugar;
{$HIDE W0} //supress case-mismatch errors
interface

type
  {$IF COOPER}
  Random = public class mapped to java.util.Random
  public
    method NextInt: Integer; mapped to nextInt;
    method NextInt(MaxValue: Integer): Integer; mapped to nextInt(MaxValue);
    method NextDouble: Double; mapped to nextDouble;
  end;
  {$ELSEIF ECHOES}
  Random = public class mapped to System.Random
  public
    method NextInt: Integer; mapped to Next;
    method NextInt(MaxValue: Integer): Integer; mapped to Next(MaxValue);
    method NextDouble: Double; mapped to NextDouble;
  end;
  {$ELSEIF NOUGAT}
  Random = public class
  public
    method init: id; override;
    method initWithSeed(Seed: Integer): id;

    method NextInt: Integer;
    method NextInt(MaxValue: Integer): Integer;
    method NextDouble: Double;
  end;
  {$ENDIF}

implementation

{$IF NOUGAT}
method Random.init: id;
begin
  var interval: rtl.sys.__struct_timeval;
  gettimeofday(@interval, nil);
  srand(interval.tv_usec * interval.tv_sec);
  result := inherited;
end;

method Random.initWithSeed(Seed: Integer): id;
begin
  srand(Seed);
  result := self;
end;

method Random.NextInt: Integer;
begin
  exit rand;
end;

method Random.NextInt(MaxValue: Integer): Integer;
begin
  exit rand mod MaxValue;
end;

method Random.NextDouble: Double;
begin
  result := Double(rand) / Double(RAND_MAX);
end;
{$ENDIF}

end.

namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.TestFramework;

type
  RandomTest = public class (Testcase)
  private
    Rnd: Random;
    const Seed: Integer = 42;
  public
    method Setup; override;
    method NextInt;
    method NextIntRange;
    method NextDouble;
    method TestSeed;
  end;

implementation

method RandomTest.Setup;
begin
  Rnd := new Random(Seed);
end;

method RandomTest.NextInt;
begin
  Assert.CheckInt(-1170105035, Rnd.NextInt);
  Assert.CheckInt(234785527, Rnd.NextInt);
  Assert.CheckInt(-1360544799, Rnd.NextInt);
end;

method RandomTest.NextIntRange;
begin
  Assert.CheckInt(30, Rnd.NextInt(50));
  Assert.CheckInt(13, Rnd.NextInt(50));
  Assert.CheckInt(48, Rnd.NextInt(50));

  for i: Integer := 1 to 1000 do 
    Assert.CheckBool(true, Rnd.NextInt(10) < 10);
end;

method RandomTest.NextDouble;
begin
  Assert.CheckDouble(0.7275636800328681, Rnd.NextDouble);
  Assert.CheckDouble(0.6832234717598454, Rnd.NextDouble);
  Assert.CheckDouble(0.30871945533265976, Rnd.NextDouble);
end;

method RandomTest.TestSeed;
begin
  Rnd := new Random(Seed + 1);
  Assert.CheckBool(false, Rnd.NextInt = -1170105035);
  Assert.CheckBool(false, Rnd.NextInt = 234785527);
  Assert.CheckBool(false, Rnd.NextInt = -1360544799);
end;

end.
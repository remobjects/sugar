namespace Sugar.Test;

interface

uses
  Sugar,
  RemObjects.Elements.EUnit;

type
  RandomTest = public class (Test)
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
  Assert.AreEqual(Rnd.NextInt, -1170105035);
  Assert.AreEqual(Rnd.NextInt, 234785527);
  Assert.AreEqual(Rnd.NextInt, -1360544799);
end;

method RandomTest.NextIntRange;
begin
  Assert.AreEqual(Rnd.NextInt(50), 30);
  Assert.AreEqual(Rnd.NextInt(50), 13);
  Assert.AreEqual(Rnd.NextInt(50), 48);

  for i: Integer := 1 to 1000 do 
    Assert.Less(Rnd.NextInt(10), 10);
    //Assert.CheckBool(true, Rnd.NextInt(10) < 10);
end;

method RandomTest.NextDouble;
begin
  Assert.AreEqual(Rnd.NextDouble, 0.7275636800328681);
  Assert.AreEqual(Rnd.NextDouble, 0.6832234717598454);
  Assert.AreEqual(Rnd.NextDouble, 0.30871945533265976);
end;

method RandomTest.TestSeed;
begin
  Rnd := new Random(Seed + 1);
  Assert.AreNotEqual(-1170105035, Rnd.NextInt);
  Assert.AreNotEqual(234785527, Rnd.NextInt);
  Assert.AreNotEqual(-1360544799, Rnd.NextInt);
  //Assert.CheckBool(false, Rnd.NextInt = -1170105035);
  //Assert.CheckBool(false, Rnd.NextInt = 234785527);
  //Assert.CheckBool(false, Rnd.NextInt = -1360544799);
end;

end.
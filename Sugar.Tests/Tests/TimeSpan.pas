namespace Sugar.Shared.Test.Tests;

interface

uses
  Sugar,
  RemObjects.Elements.EUnit;


type
  TimeSpanTest = public class(Test)
  private
  protected
  public
    method Operators;
    method FromToDateTime;
    method &From;
    method Values;
  end;

implementation

method TimeSpanTest.Operators;
begin
  var lTS := new TimeSpan(1,0,0);
  var lTS2 := lTS + new TimeSpan(2,0,0);
  Assert.AreEqual(lTS2.Hours, 3);
  Assert.IsFalse(lTS2 = lTS);
  Assert.IsTrue(lTS2 <> lTS);
  Assert.IsTrue(lTS2 > lTS);
  Assert.IsTrue(lTS2 >= lTS);
  Assert.IsFalse(lTS2 < lTS);
  Assert.IsFalse(lTS2 <= lTS);
end;

method TimeSpanTest.FromToDateTime;
begin
  var lDateTime := new DateTime(2015, 1, 2, 3, 4, 5);
  Assert.AreEqual(lDateTime.Hour, 3);
  var lDT2 := lDateTime + new TimeSpan(1,0,0);
  Assert.AreEqual(lDateTime.Hour, 3); // old should NOT change
  Assert.AreEqual(lDT2.Hour, 4);
  var lDT3 := lDT2 - new TimeSpan(1,0,0);
  Assert.AreEqual(lDT3.Hour, 3);
  Assert.AreEqual(ldt3.Ticks, lDateTime.Ticks);
end;

method TimeSpanTest.From;
begin
  Assert.AreEqual(TimeSpan.FromDays(2).Ticks, 1728000000000);
  Assert.AreEqual(TimeSpan.FromHours(2).Ticks, 72000000000);
  Assert.AreEqual(TimeSpan.FromMinutes(2).Ticks, 1200000000);
  Assert.AreEqual(TimeSpan.FromSeconds(2).Ticks, 20000000);
  Assert.AreEqual(TimeSpan.FromMilliseconds(2).Ticks, 20000);
end;

method TimeSpanTest.Values;
begin
  Assert.AreEqual(new TimeSpan(15 * TimeSpan.TicksPerSecond).Ticks, 15 * TimeSpan.TicksPerSecond);
  Assert.AreEqual(new TimeSpan(3,4,5).Ticks, 110450000000);
  Assert.AreEqual(new TimeSpan(3,4,5).Days, 0);
  Assert.AreEqual(new TimeSpan(3,4,5).Hours, 3);
  Assert.AreEqual(new TimeSpan(3,4,5).Minutes, 4);
  Assert.AreEqual(new TimeSpan(3,4,5).Seconds, 5);
  Assert.AreEqual(Int64(new TimeSpan(3,4,5).TotalHours), 3);
  Assert.AreEqual(Int64(new TimeSpan(3,4,5).TotalMinutes), 3 * 60 + 4);
  Assert.AreEqual(Int64(new TimeSpan(3,4,5).TotalSeconds), (3 * 60 + 4) * 60 + 5);
  Assert.AreEqual(new TimeSpan(1,2,3,4,5).Ticks, 937840050000);
  Assert.AreEqual(new TimeSpan(1,2,3,4,5).Days, 1);
  Assert.AreEqual(new TimeSpan(1,2,3,4,5).hours, 2);
  Assert.AreEqual(new TimeSpan(1,2,3,4,5).Minutes, 3);
  Assert.AreEqual(new TimeSpan(1,2,3,4,5).Seconds, 4);
  Assert.AreEqual(new TimeSpan(1,2,3,4,5).Milliseconds, 5);
end;

end.

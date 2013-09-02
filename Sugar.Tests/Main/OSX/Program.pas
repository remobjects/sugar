namespace Sugar.Test;

interface

uses
  RemObjects.Oxygene.Sugar.TestFramework,
  Foundation;

type
  Program = public static class
  public
    method Main(aArguments: array of String): Int32;
  end;

implementation

method Program.Main(aArguments: array of String): Int32;
begin
  {$WARNING Unable to run due to compiler bug #63851}
  //var results := TestRunner.RunAll(new StringTest, new BinaryTest, new DateTimeTest, new GuidTest);
  //var output := new StringPrinter(results);
  //NSLog("%@", output.Result);
end;

end.

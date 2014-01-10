namespace Sugar.Test;

interface

uses
  Sugar.TestFramework,
  Foundation;

type
  Program = public static class
  public
    method Main(aArguments: array of String): Int32;
  end;

implementation

method Program.Main(aArguments: array of String): Int32;
begin
  var results := TestRunner.RunAll;
  var output := new StringPrinter(results);  
  NSLog("%@", output.Result);
  //giving time for output to catch our log
  NSThread.sleepForTimeInterval(0.2);
end;

end.

namespace Sugar.Test;

interface

uses
  RemObjects.Elements.EUnit,
  Foundation;

type
  Program = public static class
  public
    method Main(aArguments: array of String): Int32;   
  end;

implementation

method Program.Main(aArguments: array of String): Int32;
begin
  var Tested := Runner.Run(Discovery.FromModule);
  var Writer := new StringWriter(Tested);

  Writer.WriteFull;
  Writer.WriteLine("====================================");
  Writer.WriteSummary;
  NSLog("%@", Writer.Output);
  //giving time for output to catch our log
  NSThread.sleepForTimeInterval(0.2);
end;

end.

namespace Sugar.Test;

interface

uses
  RemObjects.Elements.EUnit,
  UIKit;

type
  Program = public static class
  public
    method Main(argc: Integer; argv: ^^AnsiChar): Int32;
  end;

implementation

method Program.Main(argc: Integer; argv: ^^AnsiChar): Int32;
begin
  using autoreleasepool do begin
    var Tested := Runner.RunTests(Discovery.FromModule);
    var Writer := new StringWriter(Tested);

    Writer.WriteFull;
    Writer.WriteLine("====================================");
    Writer.WriteSummary;
    NSLog("%@", Writer.Output);
    //giving time for output to catch our log
    NSThread.sleepForTimeInterval(0.2);
    result := 0;
  end;
end;

end.

namespace Sugar.Test;

interface

uses
  RemObjects.Elements.eunit,
  java.util;

type
  ConsoleApp =  public static class
  public
    class method Main(args: array of String);
  end;

implementation

class method ConsoleApp.Main(args: array of String);
begin
  var Tested := Runner.Run(Discovery.FromPackage(Package.Package["sugar.test"]));
  var Writer := new StringWriter(Tested);

  Writer.WriteFull;
  Writer.WriteLine("====================================");
  Writer.WriteSummary;
  System.out.println(Writer.Output);

  System.out.println("Press any key to continue");
  System.in.read();
end;

end.

namespace Sugar.Test;

interface

uses
  RemObjects.Elements.EUnit,
  System;

type
  ConsoleApp = public static class
  public
    class method Main(args: array of System.String);
  end;

implementation

class method ConsoleApp.Main(args: array of System.String);
begin  
  var Tested := Runner.RunTests(Discovery.FromAppDomain(AppDomain.CurrentDomain));
  var Writer := new StringWriter(Tested);

  Writer.WriteFull;
  Writer.WriteLine("====================================");
  Writer.WriteSummary;
  System.Diagnostics.Debug.WriteLine(Writer.Output);
end;

end.

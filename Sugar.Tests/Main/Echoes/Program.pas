namespace Sugar.Test;

interface

uses
  RemObjects.Oxygene.Sugar.TestFramework,
  System;

type
  ConsoleApp = public static class
  public
    class method Main(args: array of System.String);
  end;

implementation

class method ConsoleApp.Main(args: array of System.String);
begin
  var results := TestRunner.RunAll;
  var output := new StringPrinter(results);
  Console.WriteLine(output.Result);

  Console.WriteLine("Press any key to continue");
  Console.ReadKey;  
end;

end.

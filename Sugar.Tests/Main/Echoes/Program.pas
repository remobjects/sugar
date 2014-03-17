namespace Sugar.Test;

interface

uses
  Sugar.TestFramework,
  System;

type
  ConsoleApp = public static class
  public
    class method Main(args: array of System.String);
  end;

implementation

class method ConsoleApp.Main(args: array of System.String);
begin  
  var results := TestRunner.RunAll();
  var output := new StringPrinter(results);
  System.Diagnostics.Debug.WriteLine(output.Result);
end;

end.

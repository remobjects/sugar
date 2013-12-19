namespace Sugar.Test;

interface

uses
  sugar.testframework,
  java.util;

type
  ConsoleApp =  public static class
  public
    class method Main(args: array of String);
  end;

implementation

class method ConsoleApp.Main(args: array of String);
begin
  var results := TestRunner.RunAll("sugar.test");
  var output := new StringPrinter(results);
  System.out.println(output.Result);

  System.out.println("Press any key to continue");
  System.in.read();
end;

end.

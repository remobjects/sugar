namespace Sugar.Test;
{$HIDE W0} //supress case-mismatch errors
interface

uses
  RemObjects.Oxygene.Sugar.TestFramework,
  System;

type
  ConsoleApp = public static class
  private
    method AlignString(Value: String; Length: Integer): String;
    method PrintTest(Test: TestResult): String;
    method PrintTestcase(Test: TestcaseResult): String;
    method PrintTestcase(Test: List<TestcaseResult>): String;
  public
    class method Main(args: array of System.String);
  end;

implementation


class method ConsoleApp.Main(args: array of System.String);
begin
  var results := TestRunner.RunAll(new StringTest);
  var output := PrintTestcase(results);
  Console.WriteLine(output);

  Console.WriteLine("Press any key to continue");
  Console.ReadKey;  
end;

method ConsoleApp.PrintTest(Test: TestResult): String;
begin
  var sb := new System.Text.StringBuilder();
  var offset := "  ";
  sb.Append(offset).Append(iif(Test.Failed, "-", "+")).Append(offset).Append(AlignString(Test.Name, 30));
  sb.Append(offset).Append("Result: ").Append(iif(Test.Failed, "Failed", "Succeed"));
  if Test.Failed then
    sb.Append(offset).AppendFormat("Error: {0}", Test.Message);
  exit sb.ToString;
end;

method ConsoleApp.PrintTestcase(Test: TestcaseResult): String;
begin
  var sb := new System.Text.StringBuilder;
  sb.AppendFormat("Testcase: {0}", Test.Name).AppendLine;
  var failed := 0;
  for t in Test.TestResults do begin
    sb.AppendLine(PrintTest(t));
    if t.Failed then
      inc(failed);
  end;
  sb.AppendLine("----------------------------------------");
  sb.AppendFormat("Total: {0} Succeed: {1} Failed: {2}", Test.TestResults.Count, Test.TestResults.Count - failed, failed).AppendLine;
  sb.AppendLine("----------------------------------------");
  exit sb.ToString;
end;

method ConsoleApp.PrintTestcase(Test: List<TestcaseResult>): String;
begin
  var sb := new System.Text.StringBuilder;
  for t: TestcaseResult in Test do
    sb.AppendLine(PrintTestcase(t));
  exit sb.ToString;
end;

class method ConsoleApp.AlignString(Value: String; Length: Integer): String;
begin
  if String.IsNullOrEmpty(Value) then
    exit new String(' ', Length);

  if Value.Length >= Length then
    exit Value;

  exit Value + new String(' ', Length - Value.Length);
end;

end.

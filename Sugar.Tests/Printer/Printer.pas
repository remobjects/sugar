namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.TestFramework;

type
  BasePrinter = public abstract class
  protected
    method PrintTest(Item: TestResult); virtual; abstract;
    method PrintTestcase(Item: TestcaseResult); virtual; abstract;
    method PrintTestcases(anItems: List<TestcaseResult>); virtual;
  public
    constructor(anItems: List<TestcaseResult>);

    method Print;
    method Print(anItems: List<TestcaseResult>);

    property Items: List<TestcaseResult> read private write;

    property Total: Integer read protected write;
    property Failed: Integer read protected write;
    property Succeed: Integer read Total - Failed;
  end;

  StringPrinter = public class (BasePrinter)
  private
    Builder: StringBuilder := new StringBuilder;
    method AlignString(Value: String; Length: Integer): String;
  protected
    method PrintTest(Item: TestResult); override;
    method PrintTestcase(Item: TestcaseResult); override;
    method PrintTestcases(anItems: List<TestcaseResult>); override;
  public
    property &Result: String read Builder.ToString;
  end;


implementation

{ BasePrinter }

method BasePrinter.PrintTestcases(anItems: List<TestcaseResult>);
begin
  for Item: TestcaseResult in anItems do begin
    inc(Total, Item.TestResults.Count);
    PrintTestcase(Item);
  end;
end;

constructor BasePrinter(anItems: List<TestcaseResult>);
begin
  Print(anItems);
end;

method BasePrinter.Print;
begin
  PrintTestcases(Items);
end;

method BasePrinter.Print(anItems: List<TestcaseResult>);
begin
  if anItems = nil then
    raise new SugarArgumentNullException("anItems");

  Items := anItems;
  Print;
end;

{ StringPrinter }

method StringPrinter.PrintTest(Item: TestResult);
begin
  var offset := "  ";
  Builder.Append(offset).Append(iif(Item.Failed, "-", "+")).Append(offset).Append(AlignString(Item.Name, 30));
  Builder.Append(offset).Append("Result: ").Append(iif(Item.Failed, "Failed", "Succeed"));
  if Item.Failed then
    Builder.Append(offset).Append(String.Format("Error: {0}", Item.Message));
  Builder.AppendLine;
end;

method StringPrinter.PrintTestcase(Item: TestcaseResult);
begin
  Builder.Append(String.Format("Testcase: {0}", Item.Name)).AppendLine;
  var lFailed := 0;
  for t: TestResult in Item.TestResults do begin
    PrintTest(t);
    if t.Failed then
      inc(lFailed);
  end;
  Failed := Failed + lFailed;

  Builder.Append('-', 20).AppendLine;
  Builder.Append(String.format("Total: {0} Succeed: {1} Failed: {2}", Item.TestResults.Count, Item.TestResults.Count - lFailed, lFailed)).AppendLine;
  Builder.Append('-', 20).AppendLine;
end;

method StringPrinter.PrintTestcases(anItems: List<TestcaseResult>);
begin
  Builder.Clear;
  inherited;

  Builder.Append('=', 15).Append("Test run completed").Append('=', 15).AppendLine;
  Builder.Append(String.format("Total: {0} Succeed: {1} Failed: {2}", Total, Succeed, Failed));  
end;

method StringPrinter.AlignString(Value: String; Length: Integer): String;
begin
  var sb := new StringBuilder;

  if String.IsNullOrEmpty(Value) then
    exit sb.Append(' ', Length).ToString;

  if Value.Length >= Length then
    exit Value;

  sb.Append(Value);
  exit sb.Append(' ', Length - Value.Length).ToString;
end;

end.

namespace RemObjects.Oxygene.Sugar.TestFramework;

interface

type
  TestResult = public class
  public
    property Name: String read private write;
    property Failed: Boolean read private write;
    property Message: String read private write;
    constructor(aName: String; aFailed: Boolean; aMessage: String);
  end;

  TestcaseResult = public class
  public
    property Name: String read private write;
    property TestResults: List<TestResult> read private write;
    constructor (aName: String);
  end;

implementation

constructor TestResult(aName: String; aFailed: Boolean; aMessage: String);
begin
  Name := aName;
  Failed := aFailed;
  Message := aMessage;
end;

constructor TestcaseResult(aName: String);
begin
  Name := aName;
  TestResults := new List<TestResult>;
end;

end.

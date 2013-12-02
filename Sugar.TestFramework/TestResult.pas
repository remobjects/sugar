namespace RemObjects.Oxygene.Sugar.TestFramework;

interface

type
  TestResult = public class
  public
    property Name: String read private write;
    property Failed: Boolean read private write;
    property Message: String read private write;

    method {$IF NOUGAT}description{$ELSEIF COOPER}ToString{$ELSEIF ECHOES}ToString{$ENDIF}: String; override;

    constructor(aName: String; aFailed: Boolean; aMessage: String);
  end;

  TestcaseResult = public class
  public
    property Name: String read private write;
    property TestResults: List<TestResult> read private write;

    method {$IF NOUGAT}description{$ELSEIF COOPER}ToString{$ELSEIF ECHOES}ToString{$ENDIF}: String; override;

    constructor (aName: String);
  end;

implementation

constructor TestResult(aName: String; aFailed: Boolean; aMessage: String);
begin
  Name := aName;
  Failed := aFailed;
  Message := aMessage;
end;

method TestResult.{$IF NOUGAT}description{$ELSEIF COOPER}ToString{$ELSEIF ECHOES}ToString{$ENDIF}: String;
begin
  if Failed then
    exit Name+" Result: Failed Error: "+Message
  else
    exit Name+" Result: Succeed";
end;

constructor TestcaseResult(aName: String);
begin
  Name := aName;
  TestResults := new List<TestResult>;
end;

method TestcaseResult.{$IF NOUGAT}description{$ELSEIF COOPER}ToString{$ELSEIF ECHOES}ToString{$ENDIF}: String;
begin
  exit Name+" Count: "+TestResults.Count.{$IF NOUGAT}description{$ELSE}ToString{$ENDIF};
end;

end.

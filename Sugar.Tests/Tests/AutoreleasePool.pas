namespace Sugar.Test;

interface

{$HIDE W0} //supress case-mismatch errors

uses
  RemObjects.Oxygene.Sugar,
  RemObjects.Oxygene.Sugar.TestFramework;

type
  AutoreleasepoolTest = public class (Testcase)
  public
    method Test;
  end;

implementation

method AutoreleasepoolTest.Test;
begin
  using autoreleasepool do begin
    Assert.CheckBool(true, true);
  end;
end;

end.

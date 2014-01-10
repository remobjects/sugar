namespace Sugar.Test;

interface

{$HIDE W0} //supress case-mismatch errors

uses
  Sugar,
  Sugar.TestFramework;

type
  AutoreleasepoolTest = public class (Testcase)
  public
    method Test;
  end;

implementation

method AutoreleasepoolTest.Test;
begin
  using {$IF NOUGAT}autoreleasepool{$ELSE}&autoreleasepool{$ENDIF} do begin
    Assert.CheckBool(true, true);
  end;
end;

end.

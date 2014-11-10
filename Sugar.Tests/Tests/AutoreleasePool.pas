namespace Sugar.Test;

interface

uses
  Sugar,
  RemObjects.Elements.EUnit;

type
  AutoreleasepoolTest = public class (Test)
  public
    method Test;
  end;

implementation

method AutoreleasepoolTest.Test;
begin
  using {$IF NOUGAT}autoreleasepool{$ELSE}&autoreleasepool{$ENDIF} do begin
    Assert.IsTrue(true);
  end;
end;

end.

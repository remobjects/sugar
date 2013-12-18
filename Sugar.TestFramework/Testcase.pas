namespace RemObjects.Sugar.TestFramework;

interface

type
  Testcase = public class
  protected
    class method NewAsyncToken: IAsyncToken;
  public
    method Setup; virtual; empty;
    method TearDown; virtual; empty;
  end;

implementation

class method Testcase.NewAsyncToken: IAsyncToken;
begin
  exit new AsyncToken;
end;

end.

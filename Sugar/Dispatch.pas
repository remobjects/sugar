namespace Sugar;

interface

type
  Dispatch = public static class
  private
  protected
  public
    method &Async(aBlock: block);
  end;

implementation

method Dispatch.Async(aBlock: block);
begin
  async aBlock();
end;

end.

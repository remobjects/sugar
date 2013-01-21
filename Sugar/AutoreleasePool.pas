namespace RemObjects.Oxygene.Sugar;

interface

{$IFDEF NOUGAT}
  {ERROR This units is intentded for Echoes and Cooper only}
{$ENDIF}

method autoreleasepool: IDisposable;

{$IF COOPER}
type 
  IDisposable = public interface mapped to java.io.Closeable
    method Dispose; mapped to close;
  end;
{$ENDIF}

implementation

type
  DummyAutoreleasePool = class(IDisposable)
  assembly
    class property Instance: DummyAutoreleasePool := new DummyAutoreleasePool();
  public
    method Dispose;
  end;

method autoreleasepool: IDisposable;
begin
  result := DummyAutoreleasePool.Instance;
end;

method DummyAutoreleasePool.Dispose;
begin
end;

end.

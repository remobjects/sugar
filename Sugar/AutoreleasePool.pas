namespace Sugar;

interface

{$IFNDEF NOUGAT}
method autoreleasepool: {$IF COOPER}java.io.Closeable{$ELSEIF ECHOES}IDisposable{$ENDIF};
{$ENDIF}

implementation

{$IFNDEF NOUGAT}
type
  DummyAutoreleasePool = class({$IF COOPER}java.io.Closeable{$ELSEIF ECHOES}IDisposable{$ENDIF})
  assembly
    class property Instance: DummyAutoreleasePool := new DummyAutoreleasePool();
  public
    method {$IF COOPER}close{$ELSEIF ECHOES}Dispose{$ENDIF};
  end;

method autoreleasepool: {$IF COOPER}java.io.Closeable{$ELSEIF ECHOES}IDisposable{$ENDIF};
begin
  result := DummyAutoreleasePool.Instance;
end;

method DummyAutoreleasePool.{$IF COOPER}close{$ELSEIF ECHOES}Dispose{$ENDIF};
begin
end;
{$ENDIF}

end.

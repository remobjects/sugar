namespace RemObjects.Oxygene.Sugar.Threading;
{$HIDE W0} //supress case-mismatch errors
interface

type
  {$IF COOPER}
  Semaphore = public class mapped to java.util.concurrent.Semaphore
  public
    method Release; mapped to release;
    method Release(ReleaseCount: Integer); mapped to release(ReleaseCount);
    method WaitOne; mapped to acquire;
    method WaitOne(Timeout: Integer); mapped to tryAcquire(Timeout, java.util.concurrent.TimeUnit.MILLISECONDS);
  end;
  {$ELSEIF ECHOES}
  Semaphore = public class mapped to System.Threading.Semaphore
  public
    method Release; mapped to Release;
    method Release(ReleaseCount: Integer); mapped to Release(ReleaseCount);
    method WaitOne; mapped to WaitOne;
    method WaitOne(Timeout: Integer); mapped to WaitOne(Timeout);
  end;
  {$ELSEIF NOUGAT}
  Semaphore = public class
  end;
  {$ENDIF}

implementation

end.

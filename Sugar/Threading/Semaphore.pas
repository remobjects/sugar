namespace RemObjects.Oxygene.Sugar.Threading;
{$HIDE W0} //supress case-mismatch errors
interface

type
  {$IF COOPER}
  Semaphore = public class mapped to java.util.concurrent.Semaphore
  public
    method Release; mapped to release;
    method Release(aReleaseCount: Integer); mapped to release(aReleaseCount);
    method WaitOne; mapped to acquire;
    method WaitOne(aTimeout: Integer); mapped to tryAcquire(aTimeout, java.util.concurrent.TimeUnit.MILLISECONDS);
  end;
  {$ELSEIF ECHOES}
  Semaphore = public class mapped to System.Threading.Semaphore
  public
    method Release; mapped to Release;
    method Release(aReleaseCount: Integer); mapped to Release(aReleaseCount);
    method WaitOne; mapped to WaitOne;
    method WaitOne(aTimeout: Integer); mapped to WaitOne(aTimeout);
  end;
  {$ELSEIF NOUGAT}
  Semaphore = public class mapped to Foundation.NSRecursiveLock
    method Release; mapped to unlock;
    method Release(aReleaseCount: Integer);
    method WaitOne; mapped to lock;
    method WaitOne(aTimeout: Integer);
  end;
  {$ENDIF}

implementation

{$IF NOUGAT}
method Semaphore.Release(aReleaseCount: Integer);
begin
  for i: Int32 := 0 to aReleaseCount-1 do mapped.unlock;
end;

method Semaphore.WaitOne(aTimeout: Integer);
begin
  mapped.lockBeforeDate(Foundation.NSDate.dateWithTimeIntervalSinceNow(aTimeout*1000)); // ms to s
end;
{$ENDIF}

end.

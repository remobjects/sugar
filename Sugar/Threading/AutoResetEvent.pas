namespace RemObjects.Oxygene.Sugar;
{$HIDE W0} //supress case-mismatch errors
interface

type
  {$IF ECHOES}
  AutoResetEvent = public class mapped to System.Threading.AutoResetEvent
  public
    method &Set; mapped to &Set;
    method Reset; mapped to Reset;
    method WaitOne; mapped to WaitOne;
    method WaitOne(Timeout: Integer): Boolean; mapped to WaitOne(Timeout);
  end;
  {$ELSEIF COOPER}
  AutoResetEvent = public class mapped to java.util.concurrent.Semaphore
  public
    method &Set; mapped to release;
    method Reset; mapped to drainPermits;
    method WaitOne; mapped to acquire;
    method WaitOne(Timeout: Integer): Boolean; mapped to tryAcquire(Timeout, java.util.concurrent.TimeUnit.MILLISECONDS);
  end;
  {$ENDIF}

implementation

end.

namespace Sugar.Threading;

interface

type
  {$IF COOPER}
  AutoResetEvent = public class mapped to java.util.concurrent.Semaphore
  public
    method &Set; mapped to release;
    method Reset; mapped to drainPermits;
    method WaitOne; mapped to acquire;
    method WaitOne(Timeout: Integer): Boolean; mapped to tryAcquire(Timeout, java.util.concurrent.TimeUnit.MILLISECONDS);
  end;
  {$ELSEIF ECHOES}
  AutoResetEvent = public class mapped to System.Threading.AutoResetEvent
  public
    method &Set; mapped to &Set;
    method Reset; mapped to Reset;
    method WaitOne; mapped to WaitOne;
    method WaitOne(Timeout: Integer): Boolean; mapped to WaitOne(Timeout);
  end;
  {$ELSEIF TOFFEE}
  AutoResetEvent = public class 
  end;
  {$ENDIF}

implementation

end.

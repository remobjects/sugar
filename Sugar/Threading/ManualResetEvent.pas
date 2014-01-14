namespace Sugar.Threading;

interface

type
  {$IF COOPER}
  ManualResetEvent = public class
  private
    fEvent: java.util.concurrent.CountDownLatch;
  public
    constructor(InitialState: Boolean);

    method &Set;
    method Reset; locked;
    method WaitOne;
    method WaitOne(Timeout: Integer): Boolean;
  end;
  {$ELSEIF ECHOES}
  ManualResetEvent = public class mapped to System.Threading.ManualResetEvent
  public
    method &Set; mapped to &Set;
    method Reset; mapped to Reset;
    method WaitOne; mapped to WaitOne;
    method WaitOne(Timeout: Integer): Boolean; mapped to WaitOne(Timeout);
  end;
  {$ELSEIF NOUGAT}
  ManualResetEvent = public class
  end;
  {$ENDIF}

implementation

{$IF COOPER}
method ManualResetEvent.&Set;
begin
  fEvent.countDown;
end;

constructor ManualResetEvent(InitialState: Boolean);
begin
  fEvent := new java.util.concurrent.CountDownLatch(iif(InitialState, 0, 1));
end;

method ManualResetEvent.Reset;
begin
  if fEvent.Count = 0 then
    fEvent := new java.util.concurrent.CountDownLatch(1);
end;

method ManualResetEvent.WaitOne;
begin
  fEvent.await;
end;

method ManualResetEvent.WaitOne(Timeout: Integer): Boolean;
begin
  exit fEvent.await(Timeout, java.util.concurrent.TimeUnit.MILLISECONDS);
end;
{$ENDIF}

end.

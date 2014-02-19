namespace Sugar.TestFramework;

interface

type
  IAsyncToken = public interface
    method Done;
    method Done(Ex: Exception);
    method Wait;
  end;

  {$IF COOPER}
  AsyncToken = assembly class (IAsyncToken)
  private
    fEvent: Object := new Object; readonly;
    fOpen: Boolean := false;
    fException: Exception := nil;
  public
    method Done;
    method Done(Ex: Exception);
    {$HIDE W8}
    method Wait;
  end;
  {$ELSEIF WINDOWS_PHONE}
  AsyncToken = assembly class (IAsyncToken)
  public
    method Done; empty;
    method Done(Ex: Exception); empty;
    method Wait; empty;
  end;
  {$ELSEIF ECHOES}
  AsyncToken = assembly class (IAsyncToken)
  private
    fEvent: System.Threading.AutoResetEvent := new System.Threading.AutoResetEvent(false);
    fException: Exception := nil;
  public
    method Done;
    method Done(Ex: Exception);
    method Wait;
  end;
  {$ELSEIF NOUGAT}
  AsyncToken = assembly class (IAsyncToken)
  private
    fEvent: Foundation.NSCondition := new Foundation.NSCondition;
    fOpen: Boolean := false;
    fException: Exception := nil;
  public
    method Done;
    method Done(Ex: Exception);
    method Wait;
  end;
  {$ENDIF}

implementation

{$IF COOPER}
method AsyncToken.Done;
begin
  locking fEvent do begin
    fOpen := true;
    fEvent.notify;
  end;
end;

method AsyncToken.Done(Ex: Exception);
begin
  locking fEvent do begin
    fOpen := true;
    fException := Ex;
    fEvent.notify;
  end;
end;

method AsyncToken.Wait;
begin
  locking fEvent do
    while not fOpen do
      fEvent.wait;

  if assigned(fException) then
    raise fException;
end;
{$ELSEIF WINDOWS_PHONE}
{$ELSEIF ECHOES}
method AsyncToken.Done;
begin
  locking fEvent do
    fEvent.Set;
end;

method AsyncToken.Done(Ex: Exception);
begin
  locking fEvent do begin
    fException := Ex;
    fEvent.Set;
  end;
end;

method AsyncToken.Wait;
begin
  if fEvent.WaitOne then
    if assigned(fException) then
      raise fException;
end;
{$ELSEIF NOUGAT}
method AsyncToken.Done;
begin
  locking fEvent do begin
    fOpen := true;
    fEvent.broadcast;
  end;
end;

method AsyncToken.Done(Ex: Exception);
begin
  locking fEvent do begin
    fOpen := true;
    fException := Ex;
    fEvent.broadcast;
  end;
end;

method AsyncToken.Wait;
begin
  fEvent.lock;
  fOpen := false;

  while not fOpen do
    fEvent.wait;

  fEvent.unlock;

  if assigned(fException) then
    raise fException;
end;
{$ENDIF}

end.

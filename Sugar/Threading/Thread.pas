namespace Sugar.Threading;

interface

uses
  Sugar,
  Sugar.Collections;

type
  {$IF COOPER}
  Thread = public class mapped to java.lang.Thread
  {$ELSEIF ECHOES}
  Thread = public class mapped to System.Threading.Thread
  {$ELSEIF NOUGAT}
  Thread = public class mapped to Foundation.NSThread
  {$ENDIF}
  private   
    method GetPriority: ThreadPriority;
    method SetPriority(Value: ThreadPriority);
    method GetCallStack: List<String>;
    {$IF NOUGAT}method GetThreadID: IntPtr;{$ENDIF}
  public
    method Start; mapped to Start;
    method &Join; {$IF COOPER OR ECHOES} mapped to &Join;{$ENDIF}
    method &Join(Timeout: Integer);  {$IF COOPER OR ECHOES}mapped to &Join(Timeout);{$ENDIF}
    {$HIDE W28}
    method Abort; mapped to {$IF ECHOES}Abort{$ELSEIF COOPER}stop{$ELSEIF NOUGAT}cancel{$ENDIF};
    {$SHOW W28}
    class method Sleep(aTimeout: Integer); mapped to {$IF COOPER OR ECHOES}Sleep(aTimeout){$ELSEIF NOUGAT}sleepForTimeInterval(aTimeout / 1000){$ENDIF};

    //property State: ThreadState read GetState write SetState;
    property IsAlive: Boolean read {$IF COOPER OR ECHOES}mapped.IsAlive{$ELSEIF NOUGAT}mapped.isExecuting{$ENDIF};
    property Name: String read mapped.Name write {$IF COOPER OR ECHOES}mapped.Name{$ELSEIF NOUGAT}mapped.setName{$ENDIF};

    {$IF COOPER OR ECHOES}
    property ThreadId: Int64 read {$IF COOPER}mapped.Id{$ELSEIF ECHOES}mapped.ManagedThreadId{$ENDIF};
    {$ELSEIF NOUGAT}    
    property ThreadId: IntPtr read GetThreadID;
    {$ENDIF}

    property Priority: ThreadPriority read GetPriority write SetPriority;
    property CallStack: List<String> read GetCallStack;

    {$IF NOUGAT}class property MainThread: Thread read mapped.mainThread;{$ENDIF}
    class property CurrentThread: Thread read mapped.currentThread; 

  end;

  ThreadState = public enum(
    Unstarted,
    Running,
    Waiting,
    Stopped
  );

  ThreadPriority = public enum(
    Lowest,
    BelowNormal,
    Normal,
    AboveNormal,
    Highest
  );

implementation

method Thread.GetPriority: ThreadPriority;
begin
  {$IF ECHOES}
    {$IF WINDOWS_PHONE}
    exit ThreadPriority.Normal;
    {$ELSE}
    exit ThreadPriority(mapped.Priority);
    {$ENDIF}
  {$ELSEIF COOPER} 
  case mapped.Priority of
    1,2: exit ThreadPriority.Lowest;
    3,4: exit ThreadPriority.BelowNormal;
    5: exit ThreadPriority.Normal;
    6,7: exit ThreadPriority.AboveNormal;
    8,9,10: exit ThreadPriority.Highest;
  end;
  {$ENDIF}
end;

method Thread.SetPriority(Value: ThreadPriority);
begin
  {$IF ECHOES}
    {$IF WINDOWS_PHONE}
    raise new SugarException("Changing thread priority is not supported on Windows Phone");
    {$ELSE}
    mapped.Priority := System.Threading.ThreadPriority(Value);
    {$ENDIF}
  {$ELSEIF COOPER} 
  case Value of
    ThreadPriority.Lowest: mapped.Priority := 2;
    ThreadPriority.BelowNormal: mapped.Priority := 4;
    ThreadPriority.Normal: mapped.Priority := 5;
    ThreadPriority.AboveNormal: mapped.Priority := 7;
    ThreadPriority.Highest: mapped.Priority := 9;
  end;
  {$ENDIF}
end;

{$IF NOUGAT}
method Thread.GetThreadID: IntPtr;
begin
  // Todo
end;

method Thread.&Join;
begin

end;

method Thread.&Join(Timeout: Integer);
begin

end;
{$ENDIF}

method Thread.GetCallStack: List<String>;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  result := mapped.callStackSymbols as List<String>;
  {$ENDIF}
end;

end.

namespace RemObjects.Oxygene.Sugar;

{$HIDE W0} //supress case-mismatch errors
interface

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
    method GetThreadID: IntPtr;
  public
    method Start; mapped to Start;
    method &Join; {$IF COOPER OR ECHOES} mapped to &Join;{$ENDIF}
    method &Join(Timeout: Integer);  {$IF COOPER OR ECHOES}mapped to &Join(Timeout);{$ENDIF}
    
    method Abort; mapped to {$IF ECHOES}Aborty{$ELSEIF COOPER}Stop{$ELSEIF NOUGAT}cancel{$ENDIF};

    class method Sleep(aTimeout: Integer); mapped to {$IF COOPER OR ECHOES}Sleep(aTimeout){$ELSEIF NOUGAT}sleepForTimeInterval(aTimeout){$ENDIF};

    //property State: ThreadState read GetState write SetState;
    property IsAlive: Boolean read {$IF COOPER OR ECHOES}mapped.IsAlive{$ELSEIF NOUGAT}mapped.isExecuting{$ENDIF};
    property Name: String read mapped.Name write {$IF COOPER OR ECHOES}mapped.Name{$ELSEIF NOUGAT}mapped.setName{$ENDIF};
    property ThreadId: IntPtr read {$IF COOPER}mapped.id{$ELSEIF ECHOES}mapped.ManagedThreadId{$ELSEIF NOUGAT}GetThreadID{$ENDIF};
    property Priority: ThreadPriority read GetPriority write SetPriority;

    //Error	6	(E62) Type mismatch, cannot assign "RemObjects.Oxygene.Sugar.List<RemObjects.Oxygene.Sugar.String>" to "RemObjects.Oxygene.Sugar.List<RemObjects.Oxygene.Sugar.String>"	Z:\Code\Sugar\Sugar\Thread.pas	33	5	RemObjects.Oxygene.Sugar.Nougat.OSX
    //property CallStack: List<String> read GetCallStack;

    class property MainThread: Thread read mapped.mainThread;
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
  exit ThreadPriority(mapped.Priority);
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
  mapped.Priority := System.Threading.ThreadPriority(Value);
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

method Thread.&Join;
begin

end;

method Thread.&Join(Timeout: Integer);
begin

end;

{$IF NOUGAT}
method Thread.GetThreadID: IntPtr;
begin
  // Todo
end;
{$ENDIF}

method Thread.GetCallStack: List<String>;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  //Error	6	(E62) Type mismatch, cannot assign "RemObjects.Oxygene.Sugar.List<RemObjects.Oxygene.Sugar.String>" to "RemObjects.Oxygene.Sugar.List<RemObjects.Oxygene.Sugar.String>"	Z:\Code\Sugar\Sugar\Thread.pas	33	5	RemObjects.Oxygene.Sugar.Nougat.OSX
  //result := mapped.callStackSymbols as List<String>;
  {$ENDIF}
end;

end.

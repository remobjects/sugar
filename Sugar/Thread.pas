namespace RemObjects.Oxygene.Sugar;

{$HIDE W0} //supress case-mismatch errors
interface

type
  Thread = public class mapped to {$IF ECHOES}System.Threading.Thread{$ELSEIF COOPER}java.lang.Thread{$ENDIF}
  private   
    method GetPriority: ThreadPriority;
    method SetPriority(Value: ThreadPriority);
  public
    method Start; mapped to Start;
    method &Join; mapped to &Join;
    method &Join(Timeout: Integer); mapped to &Join(Timeout);
    
    method Abort; mapped to {$IF ECHOES}Abort{$ELSEIF COOPER}Stop{$ENDIF};

    class method Sleep(Timeout: Integer); mapped to Sleep(Timeout);
    class property CurrentThread: Thread read mapped.CurrentThread; 

    //property State: ThreadState read GetState write SetState;
    property IsAlive: Boolean read mapped.IsAlive;
    property Name: {$IF ECHOES}System.String{$ELSEIF COOPER}java.lang.String{$ENDIF} read mapped.Name write mapped.Name;
    property Id: Integer read {$IF ECHOES}mapped.ManagedThreadId{$ELSEIF COOPER}mapped.id{$ENDIF};
    property Priority: ThreadPriority read GetPriority write SetPriority;
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

end.

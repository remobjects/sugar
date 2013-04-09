namespace RemObjects.Oxygene.Sugar;

interface

type
  Dispatch = public class
  private
  protected
  public
    method DispatchToBackgroundThread(aAction: DispatchAction; aPriority: DispatchPriority {$IF NOT COOPER} := DispatchPriority.Normal{$ENDIF});
    method DispatchToMainThread(aAction: DispatchAction);
  end;

  DispatchAction = public delegate; { block }
  DispatchPriority = public enum (High, Normal, Low, Idle);

implementation

method Dispatch.DispatchToBackgroundThread(aAction: DispatchAction; aPriority: DispatchPriority {$IF NOT COOPER} := DispatchPriority.Normal{$ENDIF});
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  async aAction();
  {$ELSEIF NOUGAT}
  dispatch_async(dispatch_get_global_queue(case aPriority of
                                             DispatchPriority.High:DISPATCH_QUEUE_PRIORITY_HIGH;
                                             DispatchPriority.Normal:DISPATCH_QUEUE_PRIORITY_DEFAULT;
                                             DispatchPriority.Low:DISPATCH_QUEUE_PRIORITY_LOW;
                                             DispatchPriority.Idle:DISPATCH_QUEUE_PRIORITY_BACKGROUND;
                                             else DISPATCH_QUEUE_PRIORITY_DEFAULT;
                                           end, 0), aAction);
  {$ENDIF}
end;

method Dispatch.DispatchToMainThread(aAction: DispatchAction);
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  dispatch_async(dispatch_get_main_queue(), aAction);
  {$ENDIF}
end;

end.

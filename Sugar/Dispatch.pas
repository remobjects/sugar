namespace RemObjects.Oxygene.Sugar;

interface

uses
  Foundation;

type
  Dispatch = public class
  private
  protected
  public
    method DispatchToBackgroundThread(aAction: DispatchAction; aPriority: DispatchPriority := DispatchPriority.Normal);
    method DispatchToMainThread(aAction: DispatchAction);
  end;

  {$IF COOPER}
  DispatchAction = public delegate;
  {$ELSEIF ECHOES}
  DispatchAction = public delegate;
  {$ELSEIF NOUGAT}
  DispatchAction = dispatch_block_t; // why
  {$ENDIF}

  DispatchPriority = public enum (High, Normal, Low, Idle);

implementation

method Dispatch.DispatchToBackgroundThread(aAction: DispatchAction; aPriority: DispatchPriority := DispatchPriority.Normal);
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  dispatch_async(dispatch_get_global_queue(case aPriority of
                                             DispatchPriority.High:DISPATCH_QUEUE_PRIORITY_HIGH;
                                             DispatchPriority.Normal:DISPATCH_QUEUE_PRIORITY_DEFAULT;
                                             DispatchPriority.Low:DISPATCH_QUEUE_PRIORITY_LOW;
                                             DispatchPriority.Idle:INT16_MIN{DISPATCH_QUEUE_PRIORITY_BACKGROUND};
                                             else DISPATCH_QUEUE_PRIORITY_DEFAULT; // why needed?
                                           end, 0), aAction);
  {$ENDIF}
end;

method Dispatch.DispatchToMainThread(aAction: DispatchAction);
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  //dispatch_async(dispatch_get_main_queue(), aAction);
  {$ENDIF}
end;

end.

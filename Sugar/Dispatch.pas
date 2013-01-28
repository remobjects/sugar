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
  DispatchAction = Action;   // 59866: allow "delegate" as inline type and map it to Action on Echoes
  {$ELSEIF NOUGAT}
  DispatchAction = {public block}dispatch_block_t; // 59867: Nougat: blocks/delegates not assignment compatible with dispatch_block_t
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
                                             DispatchPriority.Idle:INT16_MIN {DISPATCH_QUEUE_PRIORITY_BACKGROUND missing};
                                             else DISPATCH_QUEUE_PRIORITY_DEFAULT; // why needed?
                                           end, 0), aAction);
  {$ENDIF}
end;

method Dispatch.DispatchToMainThread(aAction: DispatchAction);
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  {$ELSEIF NOUGAT}
  dispatch_async({dispatch_get_main_queue()}dispatch_queue_t(@_dispatch_main_q), aAction);
  {$ENDIF}
end;

end.

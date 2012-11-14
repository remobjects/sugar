namespace RemObjects.Oxygene.Sugar;

interface

type 
  SugarException = public class({$IF NOUGAT}Foundation.NSException{$ELSE}Exception{$ENDIF})
  end;

  SugarNotImplementedException = public class(SugarException)
  private
  protected
  public
    {$IF NOUGATx}
    method init: id; override;
    {$ENDIF}
  end;

implementation

{$IF NOUGATx}
method SugarNotImplementedException.init: id;
begin
  result := inherited init;
end;
{$ENDIF}
end.

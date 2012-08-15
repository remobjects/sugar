namespace RemObjects.Oxygene.Sugar;

interface

type 
  SugarException = class({$IFDEF NOUGAT}Foundation.NSException{$ELSE}Exception{$ENDIF})
  end;

  SugarNotImplementedException = public class(SugarException)
  private
  protected
  public
    {$IFDEF NOUGATx}
    method init: id; override;
    {$ENDIF}
  end;

implementation

{$IFDEF NOUGATx}
method SugarNotImplementedException.init: id;
begin
  result := inherited init;
end;
{$ENDIF}
end.

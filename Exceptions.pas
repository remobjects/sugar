namespace RemObjects.Sugar;

interface

type 
  SugarException = class({$IFDEF NOUGAT}Foundation.NSException{$ELSE}Exception{$ENDIF})
  end;

  SugarNotImplementedException = public class(SugarException)
  private
  protected
  public
  end;

implementation

end.

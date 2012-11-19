namespace RemObjects.Oxygene.Sugar;

interface

type 
  SugarException = public class({$IF NOUGAT}Foundation.NSException{$ELSE}Exception{$ENDIF})
  {$IF NOUGAT}
  public
    method init(aMessage String): RemObjects.Oxygene.System.id; override;
  {$ENDIF}
  end;

  SugarNotImplementedException = public class(SugarException)
  private
  protected
  public
    {$IF NOUGATx}
    method init: id; override;
    {$ENDIF}
  end;

  SugarArgumentNullException = public class(SugarException);

  SugarFormatException = public class(SugarException);

  {$IF NOUGAT}
  SugarNSErrorException = public class(SugarException)
  public
    class method exceptionWithError(aError: Foundation.NSError): id;
  end;
  {$ENDIF}

implementation

{$IF NOUGAT}
method SugarException.init(aMessage String): RemObjects.Oxygene.System.id; override;
begin
  result := inherited initWithName('SugarException') reason(aMessage) userInfo(nil);
end;
{$ENDIF}

{$IF NOUGATx}
method SugarNotImplementedException.init: id;
begin
  result := inherited init;
end;
{$ENDIF}

{$IF NOUGAT}
class method SugarNSErrorException.exceptionWithError(aError: Foundation.NSError): id;
begin
  result := inherited exceptionWithName('NSError') reason(aError.description) userInfo(aError.userInfo);
end;
{$ENDIF}

end.

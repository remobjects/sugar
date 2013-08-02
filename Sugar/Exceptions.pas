namespace RemObjects.Oxygene.Sugar;

interface

type 
  SugarException = public class({$IF NOUGAT}Foundation.NSException{$ELSE}Exception{$ENDIF})
  {$IF NOUGAT}
  public
    method init(aMessage: String): RemObjects.Oxygene.System.id;
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

  SugarNotSupportedException = public class (SugarException);

  SugarArgumentNullException = public class(SugarException);
  
  SugarArgumentOutOfRangeException = public class (SugarException);

  SugarFormatException = public class(SugarException);

  SugarIOException = public class(SugarException);

  {$IF NOUGAT}
  SugarNSErrorException = public class(SugarException)
  public
    method initWithError(aError: Foundation.NSError): id;
    class method exceptionWithError(aError: Foundation.NSError): id;
  end;
  {$ENDIF}

  ErrorMessage = assembly static class
  public
    class const FORMAT_ERROR = "Input string was not in a correct format";
    class const FILE_EXISTS = "File {0} already exists";
    class const FOLDER_EXISTS = "Folder {0} already exists";
    class const OUT_OF_RANGE_ERROR = "Range ({0},{1}) exceeds data length {2}";
  end;

implementation

{$IF NOUGAT}
method SugarException.init(aMessage: String): RemObjects.Oxygene.System.id;
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
method SugarNSErrorException.initWithError(aError: Foundation.NSError): id;
begin
  result := inherited initWithName('NSError') reason(aError.description) userInfo(aError.userInfo);
end;

class method SugarNSErrorException.exceptionWithError(aError: Foundation.NSError): id;
begin
  result := inherited exceptionWithName('NSError') reason(aError.description) userInfo(aError.userInfo);
end;
{$ENDIF}

end.

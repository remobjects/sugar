namespace Sugar;

interface

type 
  SugarException = public class({$IF NOUGAT}Foundation.NSException{$ELSE}Exception{$ENDIF})
  public
    constructor;
    constructor(aMessage: String);
    constructor(aFormat: String; params aParams: array of Object);
  {$IF NOUGAT}
    property Message: String read reason;
  {$ENDIF}
  end;

  SugarNotImplementedException = public class(SugarException);

  SugarNotSupportedException = public class (SugarException);

  SugarArgumentException = public class (SugarException);

  SugarArgumentNullException = public class(SugarException)
  public
    constructor(aMessage: String);
    class method RaiseIfNil(Value: Object; Name: String);
  end;
  
  SugarArgumentOutOfRangeException = public class (SugarException);

  SugarFormatException = public class(SugarException);

  SugarIOException = public class(SugarException);

  SugarStackEmptyException = public class (SugarException);

  SugarInvalidOperationException = public class (SugarException);

  SugarKeyNotFoundException = public class (SugarException);

  {$IF NOUGAT}
  SugarNSErrorException = public class(SugarException)
  public
    constructor(Error: Foundation.NSError);
  end;
  {$ENDIF}

  ErrorMessage = public static class
  public
    class const FORMAT_ERROR = "Input string was not in a correct format";
    class const FILE_EXISTS = "File {0} already exists";
    class const FOLDER_EXISTS = "Folder {0} already exists";
    class const OUT_OF_RANGE_ERROR = "Range ({0},{1}) exceeds data length {2}";
    class const NEGATIVE_VALUE_ERROR = "{0} can not be negative";
    class const ARG_OUT_OF_RANGE_ERROR = "{0} argument was out of range of valid values.";
    class const ARG_NULL_ERROR = "Argument {0} can not be nil";
  end;

implementation

{$IF NOUGAT}
constructor SugarNSErrorException(Error: Foundation.NSError);
begin
  inherited constructor(Error.localizedDescription);
end;
{$ENDIF}

constructor SugarException;
begin
  constructor("SugarException");
end;

constructor SugarException(aMessage: String);
begin
  {$IF NOUGAT}
  inherited initWithName('SugarException') reason(aMessage) userInfo(nil);
  {$ELSE}
  inherited constructor(aMessage);
  {$ENDIF}
end;

constructor SugarException(aFormat: String; params aParams: array of Object);
begin
  constructor(String.Format(aFormat, aParams));
end;

constructor SugarArgumentNullException(aMessage: String);
begin
  inherited constructor(ErrorMessage.ARG_NULL_ERROR, aMessage)
end;

class method SugarArgumentNullException.RaiseIfNil(Value: Object; Name: String);
begin
  if Value = nil then
    raise new SugarArgumentNullException(Name);
end;

end.

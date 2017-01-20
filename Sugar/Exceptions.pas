namespace Sugar;

interface

type
  SugarException = public class({$IF TOFFEE}Foundation.NSException{$ELSE}Exception{$ENDIF})
  public
    constructor;
    constructor(aMessage: String);
    constructor(aFormat: String; params aParams: array of Object);
  {$IF TOFFEE}
    constructor withError(aError: NSError);
    property Message: String read reason;
  {$ENDIF}
  end;

  SugarNotImplementedException = public class(SugarException);

  SugarNotSupportedException = public class (SugarException);

  SugarArgumentException = public class (SugarException);

  SugarArgumentNullException = public class(SugarArgumentException)
  public
    constructor(aMessage: String);
    class method RaiseIfNil(Value: Object; Name: String);
  end;

  SugarArgumentOutOfRangeException = public class (SugarArgumentException);

  SugarFormatException = public class(SugarException);

  SugarIOException = public class(SugarException);

  HttpException = public class(SugarException)
  assembly
    constructor(aMessage: String; aResponse: nullable HttpResponse := nil);
    begin
      inherited constructor(aMessage);
      Response := aResponse;
    end;

  public
    property Response: nullable HttpResponse; readonly;
  end;

  SugarFileNotFoundException = public class (SugarException)
  public
    property FileName: String read write; readonly;
    constructor (aFileName: String);
  end;

  SugarStackEmptyException = public class (SugarException);

  SugarInvalidOperationException = public class (SugarException);

  SugarKeyNotFoundException = public class (SugarException)
  public
    constructor;
  end;

  SugarAppContextMissingException = public class (SugarException)
  public
    class method RaiseIfMissing;
  end;

  {$IF TOFFEE}
  SugarNSErrorException = public class(SugarException)
  public
    constructor(Error: Foundation.NSError);
  end;
  {$ENDIF}

  ErrorMessage = public static class
  public
    class const FORMAT_ERROR = "Input string was not in a correct format";
    class const OUT_OF_RANGE_ERROR = "Range ({0},{1}) exceeds data length {2}";
    class const NEGATIVE_VALUE_ERROR = "{0} can not be negative";
    class const ARG_OUT_OF_RANGE_ERROR = "{0} argument was out of range of valid values.";
    class const ARG_NULL_ERROR = "Argument {0} can not be nil";
    class const TYPE_RANGE_ERROR = "Specified value exceeds range of {0}";
    class const COLLECTION_EMPTY = "Collection is empty";
    class const KEY_NOTFOUND = "Entry with specified key does not exist";
    class const KEY_EXISTS = "An element with the same key already exists in the dictionary";

    class const FILE_EXISTS = "File {0} already exists";
    class const FILE_NOTFOUND = "File {0} not found";
    class const FILE_WRITE_ERROR = "File {0} can not be written";
    class const FILE_READ_ERROR = "File {0} can not be read";
    class const FOLDER_EXISTS = "Folder {0} already exists";
    class const FOLDER_NOTFOUND = "Folder {0} not found";
    class const FOLDER_CREATE_ERROR = "Unable to create folder {0}";
    class const FOLDER_DELETE_ERROR = "Unable to delete folder {0}";
    class const IO_RENAME_ERROR = "Unable to reanme {0} to {1}";

    class const APP_CONTEXT_MISSING = "Environment.ApplicationContext is not set.";
    class const NOTSUPPORTED_ERROR = "{0} is not supported on current platform";
  end;

implementation

{$IF TOFFEE}
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
  {$IF TOFFEE}
  inherited initWithName('SugarException') reason(aMessage) userInfo(nil);
  {$ELSE}
  inherited constructor(aMessage);
  {$ENDIF}
end;

{$IF TOFFEE}
constructor SugarException withError(aError: NSError);
begin
  inherited initWithName('SugarException') reason(aError.description) userInfo(nil);
end;
{$ENDIF}

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

class method SugarAppContextMissingException.RaiseIfMissing;
begin
  if Environment.ApplicationContext = nil then
    raise new SugarAppContextMissingException(ErrorMessage.APP_CONTEXT_MISSING);
end;

constructor SugarFileNotFoundException(aFileName: String);
begin
  inherited constructor (ErrorMessage.FILE_NOTFOUND, aFileName);
  FileName := aFileName;
end;

constructor SugarKeyNotFoundException;
begin
  inherited constructor(ErrorMessage.KEY_NOTFOUND);
end;

end.
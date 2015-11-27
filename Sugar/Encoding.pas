namespace Sugar;

interface

type
  Encoding = public class {$IF COOPER}mapped to java.nio.charset.Charset{$ELSEIF ECHOES}mapped to System.Text.Encoding{$ELSEIF NOUGAT}mapped to Foundation.NSNumber{$ENDIF}
  private
    method GetName: String;
  public
    method GetBytes(Value: array of Char): array of Byte;
    method GetBytes(Value: array of Char; Offset: Integer; Count: Integer): array of Byte;
    method GetBytes(Value: String): array of Byte;

    method GetChars(Value: array of Byte; Offset: Integer; Count: Integer): array of Char;
    method GetChars(Value: array of Byte): array of Char;

    method GetString(Value: array of Byte): String;
    method GetString(Value: array of Byte; Offset: Integer; Count: Integer): String;

    class method GetEncoding(Name: String): Encoding;

    property Name: String read GetName;

    class property ASCII: Encoding read GetEncoding("US-ASCII");
    class property UTF8: Encoding read GetEncoding("UTF-8");
    class property UTF16LE: Encoding read GetEncoding("UTF-16LE");
    class property UTF16BE: Encoding read GetEncoding("UTF-16BE");

    class property &Default: Encoding read UTF8;
    {$IF NOUGAT}
    method AsNSStringEncoding: NSStringEncoding;
    class method FromNSStringEncoding(aEncoding: NSStringEncoding): Encoding;
    {$ENDIF}
  end;

  EncodingHelpers = public static class
  private
  public
    class method GetBytes(aEncoding: Encoding; Value: array of Char; Offset: Integer; Count: Integer): array of Byte;
    class method GetBytes(aEncoding: Encoding; Value: String): array of Byte;
    class method GetChars(aEncoding: Encoding; Value: array of Byte; Offset: Integer; Count: Integer): array of Char;
    class method GetString(aEncoding: Encoding; Value: array of Byte; Offset: Integer; Count: Integer): String;
    class method GetEncoding(Name: String): Encoding;
  end;

implementation

method Encoding.GetBytes(Value: array of Char): array of Byte;
begin
  if Value = nil then
    raise new SugarArgumentNullException("Value");

  exit GetBytes(Value, 0, Value.length);
end;


method Encoding.GetChars(Value: array of Byte): array of Char;
begin
  {$IF COOPER}
  exit GetChars(Value, 0, Value.length);
  {$ELSEIF ECHOES}
  exit mapped.GetChars(Value);
  {$ELSEIF NOUGAT}
  exit GetString(Value).ToCharArray;
  {$ENDIF}
end;

method Encoding.GetString(Value: array of Byte): String;
begin
  if Value = nil then
    raise new SugarArgumentNullException("Value");

  exit GetString(Value, 0, Value.length);
end;

class method Encoding.GetEncoding(Name: String): Encoding;
begin
  exit EncodingHelpers.GetEncoding(Name);
end;

method Encoding.GetName: String;
begin
  {$IF COOPER}
  exit mapped.name;
  {$ELSEIF ECHOES}
  exit mapped.WebName;
  {$ELSEIF NOUGAT}
  var lName := CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(mapped.unsignedIntValue));
  if assigned(lName) then
    result := bridge<NSString>(lName, BridgeMode.Transfer);
  {$ENDIF}  
end;

{$IF NOUGAT}
method Encoding.AsNSStringEncoding: NSStringEncoding;
begin
  result := (self as NSNumber).unsignedIntegerValue as NSStringEncoding;
end;

class method Encoding.FromNSStringEncoding(aEncoding: NSStringEncoding): Encoding;
begin
  result := NSNumber.numberWithUnsignedInteger(aEncoding);
end;

{$ENDIF}


method Encoding.GetBytes(Value: array of Char; Offset: Integer; Count: Integer): array of Byte;
begin
  exit EncodingHelpers.GetBytes(self, Value, Offset, Count);
end;

method Encoding.GetBytes(Value: String): array of Byte;
begin
  exit EncodingHelpers.GetBytes(self, Value);
end;

method Encoding.GetChars(Value: array of Byte; Offset: Integer; Count: Integer): array of Char;
begin
  exit EncodingHelpers.GetChars(self, Value, Offset, Count);
end;

method Encoding.GetString(Value: array of Byte; Offset: Integer; Count: Integer): String;
begin
  exit EncodingHelpers.GetString(self, Value, Offset, Count);
end;

class method EncodingHelpers.GetEncoding(Name: String): Encoding;
begin
  SugarArgumentNullException.RaiseIfNil(Name, "Name");
  {$IF COOPER}
  exit java.nio.charset.Charset.forName(Name);
  {$ELSEIF WINDOWS_PHONE}
  result := CustomEncoding.ForName(Name);

  if result = nil then
    result := System.Text.Encoding.GetEncoding(Name);
  {$ELSEIF ECHOES}
  result := System.Text.Encoding.GetEncoding(Name);
  {$ELSEIF NOUGAT}
  var lEncoding := NSStringEncoding.UTF8StringEncoding;
  case Name of
    'UTF8','UTF-8': lEncoding := NSStringEncoding.UTF8StringEncoding;
    'UTF16','UTF-16': lEncoding := NSStringEncoding.UTF16StringEncoding;
    'UTF32','UTF-32': lEncoding := NSStringEncoding.UTF32StringEncoding;
    'UTF16LE','UTF-16LE': lEncoding := NSStringEncoding.UTF16LittleEndianStringEncoding;
    'UTF16BE','UTF-16BE': lEncoding := NSStringEncoding.UTF16BigEndianStringEncoding;
    'UTF32LE','UTF-32LE': lEncoding := NSStringEncoding.UTF32LittleEndianStringEncoding;
    'UTF32BE','UTF-32BE': lEncoding := NSStringEncoding.UTF32BigEndianStringEncoding;
    'US-ASCII', 'ASCII','UTF-ASCII': lEncoding := NSStringEncoding.ASCIIStringEncoding;
    else begin 
      var lH := CFStringConvertIANACharSetNameToEncoding(bridge<CFStringRef>(Name));
      if lH = kCFStringEncodingInvalidId then 
        raise new SugarArgumentException();
      lEncoding := CFStringConvertEncodingToNSStringEncoding(lH) as NSStringEncoding;
    end;
  end;
  result := NSNumber.numberWithUnsignedInt(lEncoding);
  {$ENDIF}
end;

method EncodingHelpers.GetBytes(aEncoding: Encoding; Value: array of Char; Offset: Integer; Count: Integer): array of Byte;
begin
  if Value = nil then
    raise new SugarArgumentNullException("Value");

  if Count = 0 then
    exit [];

  RangeHelper.Validate(Range.MakeRange(Offset, Count), Value.Length);
  {$IF ANDROID}
  var Buffer := java.nio.charset.Charset(aEncoding).newEncoder.
    onMalformedInput(java.nio.charset.CodingErrorAction.REPLACE).
    onUnmappableCharacter(java.nio.charset.CodingErrorAction.REPLACE).
    replaceWith([63]).
    encode(java.nio.CharBuffer.wrap(Value, Offset, Count));

  result := new Byte[Buffer.remaining];
  Buffer.get(result);
  {$ELSEIF COOPER}
  var Buffer := java.nio.charset.Charset(aEncoding).encode(java.nio.CharBuffer.wrap(Value, Offset, Count));
  result := new Byte[Buffer.remaining];
  Buffer.get(result);
  {$ELSEIF ECHOES}
  exit System.Text.Encoding(aEncoding).GetBytes(Value, Offset, Count);
  {$ELSEIF NOUGAT}
  exit GetBytes(aEncoding, new String(Value, Offset, Count));
  {$ENDIF}
end;

method EncodingHelpers.GetBytes(aEncoding: Encoding; Value: String): array of Byte;
begin
  SugarArgumentNullException.RaiseIfNil(Value, "Value");
  {$IF ANDROID}
  var Buffer := java.nio.charset.Charset(aEncoding).newEncoder.
    onMalformedInput(java.nio.charset.CodingErrorAction.REPLACE).
    onUnmappableCharacter(java.nio.charset.CodingErrorAction.REPLACE).
    replaceWith([63]).
    encode(java.nio.CharBuffer.wrap(Value));

  result := new Byte[Buffer.remaining];
  Buffer.get(result);
  {$ELSEIF COOPER}
  var Buffer := java.nio.charset.Charset(aEncoding).encode(Value);
  result := new Byte[Buffer.remaining];
  Buffer.get(result);
  {$ELSEIF ECHOES}
  exit System.Text.Encoding(aEncoding).GetBytes(Value);
  {$ELSEIF NOUGAT}
  result := ((Value as NSString).dataUsingEncoding(aEncoding.AsNSStringEncoding) allowLossyConversion(true) as Binary).ToArray;
  if not assigned(result) then
    raise new SugarFormatException("Unable to convert data");
  {$ENDIF}
end;

method EncodingHelpers.GetChars(aEncoding: Encoding; Value: array of Byte; Offset: Integer; Count: Integer): array of Char;
begin
  {$IF COOPER}
  var Buffer := java.nio.charset.Charset(aEncoding).newDecoder.
    onMalformedInput(java.nio.charset.CodingErrorAction.REPLACE).
    onUnmappableCharacter(java.nio.charset.CodingErrorAction.REPLACE).
    replaceWith("?").
    decode(java.nio.ByteBuffer.wrap(Value, Offset, Count));
  result := new Char[Buffer.remaining];
  Buffer.get(result);
  {$ELSEIF ECHOES}
  exit System.Text.Encoding(aEncoding).GetChars(Value, Offset, Count);
  {$ELSEIF NOUGAT}
  exit GetString(aEncoding, Value, Offset, Count).ToCharArray;
  {$ENDIF}
end;

method EncodingHelpers.GetString(aEncoding: Encoding; Value: array of Byte; Offset: Integer; Count: Integer): String;
begin
  if Value = nil then
    raise new SugarArgumentNullException("Value");

  if Count = 0 then
    exit "";

  RangeHelper.Validate(Range.MakeRange(Offset, Count), Value.Length);
  {$IF COOPER}
  var Buffer := java.nio.charset.Charset(aEncoding).newDecoder.
    onMalformedInput(java.nio.charset.CodingErrorAction.REPLACE).
    onUnmappableCharacter(java.nio.charset.CodingErrorAction.REPLACE).
    replaceWith("?").
    decode(java.nio.ByteBuffer.wrap(Value, Offset, Count));
  result := Buffer.toString;
  {$ELSEIF ECHOES}
  result := System.Text.Encoding(aEncoding).GetString(Value, Offset, Count);
  {$ELSEIF NOUGAT}
  result := new NSString withBytes(@Value[Offset]) length(Count) encoding(aEncoding.AsNSStringEncoding);
  if not assigned(result) then
    raise new SugarFormatException("Unable to convert input data");
  {$ENDIF}
end;

end.

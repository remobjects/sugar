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

implementation

method Encoding.GetBytes(Value: array of Char): array of Byte;
begin
  if Value = nil then
    raise new SugarArgumentNullException("Value");

  exit GetBytes(Value, 0, Value.length);
end;

method Encoding.GetBytes(Value: array of Char; Offset: Integer; Count: Integer): array of Byte;
begin
  if Value = nil then
    raise new SugarArgumentNullException("Value");

  if Count = 0 then
    exit [];

  RangeHelper.Validate(Range.MakeRange(Offset, Count), Value.Length);
  {$IF ANDROID}
  var Buffer := mapped.newEncoder.
    onMalformedInput(java.nio.charset.CodingErrorAction.REPLACE).
    onUnmappableCharacter(java.nio.charset.CodingErrorAction.REPLACE).
    replaceWith([63]).
    encode(java.nio.CharBuffer.wrap(Value, Offset, Count));

  result := new Byte[Buffer.remaining];
  Buffer.get(result);
  {$ELSEIF COOPER}
  var Buffer := mapped.encode(java.nio.CharBuffer.wrap(Value, Offset, Count));
  result := new Byte[Buffer.remaining];
  Buffer.get(result);
  {$ELSEIF ECHOES}
  exit mapped.GetBytes(Value, Offset, Count);
  {$ELSEIF NOUGAT}
  exit GetBytes(new String(Value, Offset, Count));
  {$ENDIF}
end;

method Encoding.GetBytes(Value: String): array of Byte;
begin
  SugarArgumentNullException.RaiseIfNil(Value, "Value");
  {$IF ANDROID}
  var Buffer := mapped.newEncoder.
    onMalformedInput(java.nio.charset.CodingErrorAction.REPLACE).
    onUnmappableCharacter(java.nio.charset.CodingErrorAction.REPLACE).
    replaceWith([63]).
    encode(java.nio.CharBuffer.wrap(Value));

  result := new Byte[Buffer.remaining];
  Buffer.get(result);
  {$ELSEIF COOPER}
  var Buffer := mapped.encode(Value);
  result := new Byte[Buffer.remaining];
  Buffer.get(result);
  {$ELSEIF ECHOES}
  exit mapped.GetBytes(Value);
  {$ELSEIF NOUGAT}
  result := ((Value as NSString).dataUsingEncoding(AsNSStringEncoding) as Binary).ToArray;
  if not assigned(result) then
    raise new SugarFormatException("Unable to convert data");
  {$ENDIF}
end;

method Encoding.GetChars(Value: array of Byte; Offset: Integer; Count: Integer): array of Char;
begin
  {$IF COOPER}
  var Buffer := mapped.newDecoder.
    onMalformedInput(java.nio.charset.CodingErrorAction.REPLACE).
    onUnmappableCharacter(java.nio.charset.CodingErrorAction.REPLACE).
    replaceWith("?").
    decode(java.nio.ByteBuffer.wrap(Value, Offset, Count));
  result := new Char[Buffer.remaining];
  Buffer.get(result);
  {$ELSEIF ECHOES}
  exit mapped.GetChars(Value, Offset, Count);
  {$ELSEIF NOUGAT}
  exit GetString(Value, Offset, Count).ToCharArray;
  {$ENDIF}
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

method Encoding.GetString(Value: array of Byte; Offset: Integer; Count: Integer): String;
begin
  if Value = nil then
    raise new SugarArgumentNullException("Value");

  if Count = 0 then
    exit "";

  RangeHelper.Validate(Range.MakeRange(Offset, Count), Value.Length);
  {$IF COOPER}
  var Buffer := mapped.newDecoder.
    onMalformedInput(java.nio.charset.CodingErrorAction.REPLACE).
    onUnmappableCharacter(java.nio.charset.CodingErrorAction.REPLACE).
    replaceWith("?").
    decode(java.nio.ByteBuffer.wrap(Value, Offset, Count));
  result := Buffer.toString;
  {$ELSEIF ECHOES}
  result := mapped.GetString(Value, Offset, Count);
  {$ELSEIF NOUGAT}
  var lData := new Binary(Value) as NSData;
  result := new NSString withBytes(Value) length(length(Value)) encoding(AsNSStringEncoding);
  if not assigned(result) then
    raise new SugarFormatException("Unable to convert input data");
  {$ENDIF}
end;

class method Encoding.GetEncoding(Name: String): Encoding;
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
    'ASCII','UTF-ASCII': lEncoding := NSStringEncoding.ASCIIStringEncoding;
    else lEncoding := CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding(bridge<CFStringRef>(Name))) as NSStringEncoding;
  end;
  result := NSNumber.numberWithUnsignedInt(lEncoding);
  {$ENDIF}
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

end.

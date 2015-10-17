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
  var Str := bridge<CFStringRef>(Value);
  var Range := CFRangeMake(0, CFStringGetLength(Str));
  var Bin := new Binary;
  
  while Range.length > 0 do begin
    var LocalBuffer := new Byte[100];
    var UsedLength: CFIndex;
    var NumChars := CFStringGetBytes(Str, Range, mapped.unsignedIntValue, ord('?'), false, ^UInt8(@LocalBuffer[0]), 100, var UsedLength);

    if NumChars = 0 then
      raise new SugarFormatException("Unable to convert data");

    Bin.Write(LocalBuffer, UsedLength);
    Range.location := Range.location + NumChars;
    Range.length := Range.Length - NumChars;
  end;  

  exit Bin.ToArray;
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
  exit Buffer.toString;
  {$ELSEIF ECHOES}
  exit mapped.GetString(Value, Offset, Count);
  {$ELSEIF NOUGAT}  
  if mapped.unsignedIntValue = CFStringBuiltInEncodings.kCFStringEncodingASCII then
    for i: Integer := Offset to Count - 1 do
      if Value[i] > 127 then
        Value[i] := 63;

  var Str := CFStringCreateWithBytesNoCopy(kCFAllocatorDefault, @Value[Offset], Count, mapped.unsignedIntValue, false, kCFAllocatorNull);

  if Str = nil then
    raise new SugarFormatException("Unable to convert input data");

  exit bridge<NSString>(Str, BridgeMode.Transfer);
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
    exit System.Text.Encoding.GetEncoding(Name);
  {$ELSEIF ECHOES}
  exit System.Text.Encoding.GetEncoding(Name);
  {$ELSEIF NOUGAT}
  var Enc := CFStringConvertIANACharSetNameToEncoding(bridge<CFStringRef>(Name));

  if Enc = kCFStringEncodingInvalidId then
    raise new SugarArgumentException("Encoding with name {0} can not be found", Name);

  exit NSNumber.numberWithUnsignedInt(Enc);
  {$ENDIF}
end;

method Encoding.GetName: String;
begin
  {$IF COOPER}
  exit mapped.name;
  {$ELSEIF ECHOES}
  exit mapped.WebName;
  {$ELSEIF NOUGAT}
  var Str := CFStringConvertEncodingToIANACharSetName(mapped.unsignedIntValue);

  if Str = nil then
    exit "";

  exit bridge<NSString>(Str, BridgeMode.Transfer);
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

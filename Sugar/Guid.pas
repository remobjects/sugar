namespace Sugar;

{$HIDE W0} //supress case-mismatch errors

interface

type
  GuidFormat = public enum (&Default, Braces, Parentheses);

  {$IF ECHOES}[System.Runtime.InteropServices.StructLayout(System.Runtime.InteropServices.LayoutKind.Auto, Size := 1)]{$ENDIF}
  Guid = public {$IF COOPER}class mapped to java.util.UUID{$ELSEIF ECHOES}record mapped to System.Guid{$ELSEIF NOUGAT}class{$ENDIF}
  private
    {$IF ECHOES}
    class method Exchange(Value: array of Byte; Index1, Index2: Integer);
    {$ELSEIF NOUGAT}
    fData: array of Byte;
    method AppendRange(Data: NSMutableString; Range: NSRange);
    class method InternalParse(Data: String): array of Byte;
    {$ENDIF}
  public
    constructor;
    constructor(Value: array of Byte);

    method CompareTo(Value: Guid): Integer;
    method &Equals(Value: Guid): Boolean;

    class method NewGuid: Guid;
    class method Parse(Value: String): Guid;
    class method EmptyGuid: Guid;

    method ToByteArray: array of Byte;
    method ToString(Format: GuidFormat): String;

    {$IF COOPER}
    method ToString: java.lang.String; override;
    {$ELSEIF ECHOES}
    method ToString: System.String; override;
    {$ELSEIF NOUGAT}
    method description: NSString; override;
    {$ENDIF}    
  end;


implementation

constructor Guid;
begin
  {$IF COOPER}
  exit new java.util.UUID(0, 0);
  {$ELSEIF ECHOES}
  exit mapped.Empty;
  {$ELSEIF NOUGAT}
  fData := new Byte[16];
  memset(fData, 0, 16); 
  {$ENDIF}
end;

constructor Guid(Value: array of Byte);
begin
  {$IF COOPER}
  var bb := java.nio.ByteBuffer.wrap(Value);
  exit new java.util.UUID(bb.getLong, bb.getLong);
  {$ELSEIF ECHOES}
  Exchange(Value, 0, 3);
  Exchange(Value, 1, 2);
  Exchange(Value, 4, 5);
  Exchange(Value, 6, 7);
  exit new System.Guid(Value);
  {$ELSEIF NOUGAT}
  fData := new Byte[16];
  memcpy(fData, Value, 16); 
  {$ENDIF}
end;

method Guid.CompareTo(Value: Guid): Integer;
begin
  {$IF COOPER OR ECHOES}
  exit mapped.CompareTo(Value);
  {$ELSEIF NOUGAT}
  exit memcmp(fData, Value.fData, 16);
  {$ENDIF}
end;

method Guid.Equals(Value: Guid): Boolean;
begin
  {$IF COOPER OR ECHOES}
  exit mapped.Equals(Value);
  {$ELSEIF NOUGAT}
  exit CompareTo(Value) = 0;
  {$ENDIF}
end;

class method Guid.NewGuid: Guid;
begin
  {$IF COOPER}
  exit mapped.randomUUID;
  {$ELSEIF ECHOES}
  exit mapped.NewGuid;
  {$ELSEIF NOUGAT}
  var UUID: CFUUIDRef := CFUUIDCreate(kCFAllocatorDefault);
  var RefBytes: CFUUIDBytes := CFUUIDGetUUIDBytes(UUID);
  CFRelease(UUID);

  var Data := new Byte[16];
  memcpy(Data, @RefBytes, 16);
  exit new Guid(Data);
  {$ENDIF}
end;

class method Guid.Parse(Value: String): Guid;
begin
  if (Value.Length <> 38) and (Value.Length <> 36) then
    raise new SugarFormatException(ErrorMessage.FORMAT_ERROR);

  {$IF COOPER}
  if Value.Chars[0] = '{' then begin
    if Value.Chars[37] <> '}' then
      raise new SugarFormatException(ErrorMessage.FORMAT_ERROR);
  end
  else if Value.Chars[0] = '(' then begin
    if Value.Chars[37] <> ')' then
      raise new SugarFormatException(ErrorMessage.FORMAT_ERROR);
  end;

  Value := java.lang.String(Value.ToUpper).replaceAll("[{}()]", "");
  exit mapped.fromString(Value);
  {$ELSEIF ECHOES}
  exit new System.Guid(Value);
  {$ELSEIF NOUGAT}
  var Data := InternalParse(Value);
  exit new Guid(Data);
  {$ENDIF}
end;

class method Guid.EmptyGuid: Guid;
begin
  {$IF COOPER}
  exit new java.util.UUID(0, 0);
  {$ELSEIF ECHOES}
  exit mapped.Empty;
  {$ELSEIF NOUGAT}
  exit new Guid;
  {$ENDIF}
end;

method Guid.ToByteArray: array of Byte;
begin
  {$IF COOPER}
  var buffer := java.nio.ByteBuffer.wrap(new SByte[16]);
  buffer.putLong(mapped.MostSignificantBits);
  buffer.putLong(mapped.LeastSignificantBits);
  exit buffer.array;
  {$ELSEIF ECHOES}
  var Value := mapped.ToByteArray;
  //reverse byte order to normal (.NET reverse first 4 bytes and next two 2 bytes groups)
  Exchange(Value, 0, 3);
  Exchange(Value, 1, 2);
  Exchange(Value, 4, 5);
  Exchange(Value, 6, 7);

  exit Value;
  {$ELSEIF NOUGAT}
  result := new Byte[16];
  memcpy(result, fData, 16);
  {$ENDIF}
end;

method Guid.ToString(Format: GuidFormat): String;
begin
  {$IF COOPER}
  case Format of
    Format.Default: result := mapped.toString;
    Format.Braces: result := "{"+mapped.toString+"}";
    Format.Parentheses: result := "("+mapped.toString+")";
    else
      result := mapped.toString;
  end;

  exit result.ToUpper;
  {$ELSEIF ECHOES}
  case Format of
    Format.Default: result := mapped.ToString("D");
    Format.Braces: result := mapped.ToString("B");
    Format.Parentheses: result := mapped.ToString("P");
    else
      result := mapped.ToString("D");
  end;

  exit result.ToUpper;
  {$ELSEIF NOUGAT}
  var GuidString := new NSMutableString();

  AppendRange(GuidString, NSMakeRange(0, 3));
  GuidString.appendString("-");
  AppendRange(GuidString, NSMakeRange(4, 5));
  GuidString.appendString("-");
  AppendRange(GuidString, NSMakeRange(6, 7));
  GuidString.appendString("-");
  AppendRange(GuidString, NSMakeRange(8, 9));
  GuidString.appendString("-");
  AppendRange(GuidString, NSMakeRange(10, 15));

  case Format of
    Format.Default: exit GuidString;
    Format.Braces: exit "{"+GuidString+"}";
    Format.Parentheses: exit "("+GuidString+")";
    else
      exit GuidString;
  end;
  {$ENDIF}
end;

{$IF COOPER}
method Guid.ToString: java.lang.String;
begin
  exit ToString(GuidFormat.Default);
end;
{$ELSEIF ECHOES}
method Guid.ToString: System.String;
begin
  exit ToString(GuidFormat.Default);
end;

class method Guid.Exchange(Value: array of Byte; Index1: Integer; Index2: Integer);
begin
  var Temp := Value[Index1];
  Value[Index1] := Value[Index2];
  Value[Index2] := Temp;
end;
{$ELSEIF NOUGAT}
method Guid.AppendRange(Data: NSMutableString; Range: NSRange);
begin
  for i: Integer := Range.location to Range.length do
    Data.appendFormat("%02hhX", fData[i]);
end;

method Guid.description: NSString;
begin
  exit ToString(GuidFormat.Default);
end;

class method Guid.InternalParse(Data: String): array of Byte;
begin
  var Offset: Int32;

  if (Data.Length <> 38) and (Data.Length <> 36) then
    raise new SugarFormatException(ErrorMessage.FORMAT_ERROR);

  if Data.Chars[0] = '{' then begin
    if Data.Chars[37] <> '}' then
      raise new SugarFormatException(ErrorMessage.FORMAT_ERROR);

    Offset := 1;
  end
  else if Data.Chars[0] = '(' then begin
    if Data.Chars[37] <> ')' then
      raise new SugarFormatException(ErrorMessage.FORMAT_ERROR);

    Offset := 1;
  end;

  if (Data.Chars[8+Offset] <> '-') or (Data.Chars[13+Offset] <> '-') or
     (Data.Chars[18+Offset] <> '-') or (Data.Chars[23+Offset] <> '-') then
    raise new SugarFormatException(ErrorMessage.FORMAT_ERROR);

  //Clear string from "{}()-" symbols
  var Regex := NSRegularExpression.regularExpressionWithPattern("[^A-F0-9]") options(NSRegularExpressionOptions.NSRegularExpressionCaseInsensitive) error(nil);
  var HexString := new NSMutableString withString(Regex.stringByReplacingMatchesInString(Data) options(NSMatchingOptions(0)) range(NSMakeRange(0, Data.length)) withTemplate(""));

  // We should get 32 chars
  if HexString.length <> 32 then
    raise new SugarFormatException(ErrorMessage.FORMAT_ERROR);

  Result := new Byte[16];
  var Idx: UInt32 := 0;
  var Idx2: UInt32 := 0;

  //Convert hex to byte
  while Idx < HexString.length do begin
    var Range := NSMakeRange(Idx, 2);
    var Buffer := HexString.substringWithRange(Range);
    var ByteScanner := NSScanner.scannerWithString(Buffer);
    var IntValue: uint32;
    ByteScanner.scanHexInt(var IntValue);
    Result[Idx2] := Byte(IntValue);
    inc(Idx, 2);
    inc(Idx2);
  end;
end;
{$ENDIF}

end.

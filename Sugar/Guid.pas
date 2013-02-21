namespace RemObjects.Oxygene.Sugar;

{$HIDE W0} //supress case-mismatch errors
interface

{$IF NOUGAT}
uses
  Foundation;
{$ENDIF}

type
  GuidFormat = public enum (&Default, Braces, Parentheses);

  {$IF COOPER}
  Guid = public class mapped to java.util.UUID
    method CompareTo(Value: Guid): Integer; mapped to compareTo(Value);
    method &Equals(Value: Guid): Boolean; mapped to &equals(Value);
    class method NewGuid: Guid; mapped to randomUUID;
    class method Parse(Value: String): Guid;
    class method EmptyGuid: Guid;
    class operator Equal(GuidA, GuidB: Guid): Boolean;
    class operator NotEqual(GuidA, GuidB: Guid): Boolean;
    method ToByteArray: array of byte;
    method ToString(Format: GuidFormat): String;
  end;
  {$ELSEIF ECHOES}
  [System.Runtime.InteropServices.StructLayout(System.Runtime.InteropServices.LayoutKind.Auto, Size := 1)]
  Guid = public record mapped to System.Guid
  public
    method CompareTo(Value: Guid): Integer; mapped to CompareTo(Value);
    method &Equals(Value: Guid): Boolean; mapped to &Equals(Value);
    class method NewGuid: Guid; mapped to NewGuid;
    class method Parse(Value: String): Guid;
    class method EmptyGuid: Guid; mapped to Empty;
    class operator Equal(GuidA, GuidB: Guid): Boolean;
    class operator NotEqual(GuidA, GuidB: Guid): Boolean;
    method ToByteArray: array of byte; mapped to ToByteArray;     
    method ToString(Format: GuidFormat): String;
  end;
  {$ELSEIF NOUGAT}
  Guid = public class
  private
    fData: array of Byte;
    method AppendRange(Data: NSMutableString; Range: NSRange);
    method InternalParse(Data: String): array of Byte;
  public
    method init: id; override;
    method initWithString(Value: String): id;
    method initWithBytes(Value: array of Byte): id;

    method CompareTo(Value: Guid): Integer; 
    method &Equals(Value: Guid): Boolean;
    class method NewGuid: Guid;
    class method Parse(Value: String): Guid;
    class method EmptyGuid: Guid;
    method ToByteArray: array of Byte;
    method ToString: String;
    method ToString(Format: GuidFormat): String;
  end;
  {$ENDIF}


implementation

{$IF COOPER} 
method Guid.ToByteArray: array of byte;
begin
  var buffer := java.nio.ByteBuffer.wrap(new Byte[16]);
  buffer.putLong(mapped.MostSignificantBits);
  buffer.putLong(mapped.LeastSignificantBits);
  exit buffer.array;
end;

class method Guid.EmptyGuid: Guid;
begin
  exit new Guid(0,0);
end;

method Guid.ToString(Format: GuidFormat): String;
begin
  case Format of
    Format.Default: exit mapped.toString;
    Format.Braces: exit "{"+mapped.toString+"}";
    Format.Parentheses: exit "("+mapped.toString+")";
    else
      exit mapped.toString;
  end;
end;

class method Guid.Parse(Value: String): Guid;
begin  
  if (Value.Length <> 38) and (Value.Length <> 36) then
    raise new SugarFormatException(ErrorMessage.FORMAT_ERROR);

  if Value.Chars[0] = '{' then begin
    if Value.Chars[37] <> '}' then
      raise new SugarFormatException(ErrorMessage.FORMAT_ERROR);
  end
  else if Value.Chars[0] = '(' then begin
    if Value.Chars[37] <> ')' then
      raise new SugarFormatException(ErrorMessage.FORMAT_ERROR);
  end;

  //remove {} or () symbols
  Value := java.lang.String(Value.ToUpper).replaceAll("[^A-F0-9]", "");
  exit mapped.fromString(Value);
end;
{$ENDIF}

{$IF ECHOES}
class method Guid.Parse(Value: String): Guid;
begin
  exit new Guid(Value);
end;

method Guid.ToString(Format: GuidFormat): String;
begin
  case Format of
    Format.Default: exit mapped.ToString("D");
    Format.Braces: exit mapped.ToString("B");
    Format.Parentheses: exit mapped.ToString("P");
    else
      exit mapped.ToString("D");
  end;
end;
{$ENDIF}

{$IF COOPER OR ECHOES}
class operator Guid.Equal(GuidA: Guid; GuidB: Guid): Boolean;
begin
  exit GuidA.Equals(GuidB);
end;

class operator Guid.NotEqual(GuidA, GuidB: Guid): Boolean;
begin
  exit not GuidA.Equals(GuidB);
end;
{$ENDIF}

{$IF NOUGAT}
method Guid.init: id;
begin
  fData := new Byte[16];
  memset(fData, 0, 16); 
  result := self;
end;

method Guid.initWithString(Value: String): id;
begin
  fData := InternalParse(Value);
  result := self;
end;

method Guid.initWithBytes(Value: array of Byte): id;
begin
  fData := new Byte[16];
  memcpy(fData, Value, 16);
  result := self;
end;

method Guid.CompareTo(Value: Guid): Integer;
begin
  exit memcmp(fData, Value.fData, 16);
end;

method Guid.&Equals(Value: Guid): Boolean;
begin
  exit CompareTo(Value) = 0;
end;

class method Guid.NewGuid: Guid;
begin
  var UUID: CFUUIDRef := CFUUIDCreate(kCFAllocatorDefault);
  var RefBytes: CFUUIDBytes := CFUUIDGetUUIDBytes(UUID);
  CFRelease(UUID);
  var bytes := new Byte[16];
  memcpy(bytes, @RefBytes, 16);
  exit new Guid withBytes(bytes);
end;

class method Guid.EmptyGuid: Guid;
begin
  exit new Guid;
end;

class method Guid.Parse(Value: String): Guid;
begin
  exit new Guid() withString(Value);
end;

method Guid.ToByteArray: array of Byte;
begin
  Result := new Byte[16];
  memcpy(Result, fData, 16);
end;

method Guid.AppendRange(Data: NSMutableString; Range: NSRange);
begin
  for i: Integer := Range.location to Range.length do
    Data.appendFormat("%02hhX", fData[i]);
end;

method Guid.ToString: String;
begin
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

  exit GuidString;
end;

method Guid.ToString(Format: GuidFormat): String;
begin
  case Format of
    Format.Default: exit ToString;
    Format.Braces: exit "{"+ToString+"}";
    Format.Parentheses: exit "("+ToString+")";
    else
      exit ToString;
  end;
end;

method Guid.InternalParse(Data: String): array of Byte;
begin
  var Offset := 0;

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
  var Idx, Idx2 := 0;

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

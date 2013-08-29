namespace RemObjects.Oxygene.Sugar;

{$HIDE W0} //supress case-mismatch errors

interface

type
  GuidFormat = public enum (&Default, Braces, Parentheses);

  {$IF COOPER}
  Guid = public class mapped to java.util.UUID
  public
    method CompareTo(Value: Guid): Integer; mapped to compareTo(Value);
    method &Equals(Value: Guid): Boolean; mapped to &equals(Value);
    class method NewGuid: Guid; mapped to randomUUID;
    class method Parse(Value: String): Guid;
    class method EmptyGuid: Guid;
    class operator Equal(GuidA, GuidB: Guid): Boolean;
    class operator NotEqual(GuidA, GuidB: Guid): Boolean;
    method ToByteArray: array of Byte;
    method ToString(Format: GuidFormat): String;
    method toString: java.lang.String; override;
  end;
  {$ELSEIF ECHOES}
  [System.Runtime.InteropServices.StructLayout(System.Runtime.InteropServices.LayoutKind.Auto, Size := 1)]
  Guid = public record mapped to System.Guid
  private
    method Exchange(Value: array of Byte; Index1, Index2: Integer);
  public
    method CompareTo(Value: Guid): Integer; mapped to CompareTo(Value);
    method &Equals(Value: Guid): Boolean; mapped to &Equals(Value);
    class method NewGuid: Guid; mapped to NewGuid;
    class method Parse(Value: String): Guid;
    class method EmptyGuid: Guid; mapped to Empty;
    class operator Equal(GuidA, GuidB: Guid): Boolean;
    class operator NotEqual(GuidA, GuidB: Guid): Boolean;
    method ToByteArray: array of Byte;
    method ToString(Format: GuidFormat): String;
    method ToString: System.String; override;
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
method Guid.ToByteArray: array of Byte;
begin
  var buffer := java.nio.ByteBuffer.wrap(new SByte[16]);
  buffer.putLong(mapped.MostSignificantBits);
  buffer.putLong(mapped.LeastSignificantBits);
  exit RemObjects.Oxygene.Sugar.Cooper.ArrayUtils.ToUnsignedArray(buffer.array);
end;

class method Guid.EmptyGuid: Guid;
begin
  exit new Guid(0,0);
end;

method Guid.ToString(Format: GuidFormat): String;
begin
  case Format of
    Format.Default: result := mapped.toString;
    Format.Braces: result := "{"+mapped.toString+"}";
    Format.Parentheses: result := "("+mapped.toString+")";
    else
      result := mapped.toString;
  end;

  exit result.ToUpper;
end;

method Guid.toString: java.lang.String;
begin
  exit toString(GuidFormat.Default);
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
  //Value := java.lang.String(Value.ToUpper).replaceAll("[^A-F0-9-]", "");
  Value := java.lang.String(Value.ToUpper).replaceAll("[{}()]", "");
  exit mapped.fromString(Value);
end;
{$ENDIF}

{$IF ECHOES}
class method Guid.Parse(Value: String): Guid;
begin
  if (Value.Length <> 38) and (Value.Length <> 36) then
    raise new SugarFormatException(ErrorMessage.FORMAT_ERROR);

  exit new Guid(Value);
end;

method Guid.ToString: System.String;
begin
  exit ToString(GuidFormat.Default);
end;

method Guid.ToString(Format: GuidFormat): String;
begin
  case Format of
    Format.Default: result := mapped.ToString("D");
    Format.Braces: result := mapped.ToString("B");
    Format.Parentheses: result := mapped.ToString("P");
    else
      result := mapped.ToString("D");
  end;

  exit result.ToUpper;
end;

method Guid.Exchange(Value: array of Byte; Index1: Integer; Index2: Integer);
begin
  var Temp := Value[Index1];
  Value[Index1] := Value[Index2];
  Value[Index2] := Temp;
end;

method Guid.ToByteArray: array of Byte;
begin
  result := mapped.ToByteArray;
  //reverse byte order to normal (.NET reverse first 4 bytes and next two 2 bytes groups)
  Exchange(result, 0, 3);
  Exchange(result, 1, 2);
  Exchange(result, 4, 5);
  Exchange(result, 6, 7);
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
end;

method Guid.initWithString(Value: String): id;
begin
  fData := InternalParse(Value);
end;

method Guid.initWithBytes(Value: array of Byte): id;
begin
  fData := new Byte[16];
  memcpy(fData, Value, 16);  
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
  var Idx, Idx2: UInt32 := 0;

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

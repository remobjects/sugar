namespace RemObjects.Oxygene.Sugar;

{$HIDE W0} //supress case-mismatch errors
interface

type
  {$IF COOPER}
  Guid = public class mapped to java.util.UUID
    method CompareTo(Value: Guid): Integer; mapped to compareTo(Value);
    method &Equals(Value: Guid): Boolean; mapped to &equals(Value);
    class method NewGuid: Guid; mapped to randomUUID;
    class method Parse(Value: String): Guid; mapped to fromString(Value);
    class operator Equal(GuidA, GuidB: Guid): Boolean;
    class operator NotEqual(GuidA, GuidB: Guid): Boolean;
    method ToByteArray: array of byte;
  end;
  {$ELSEIF ECHOES}
  Guid = public record mapped to System.Guid
  public
    method CompareTo(Value: Guid): Integer; mapped to CompareTo(Value);
    method &Equals(Value: Guid): Boolean; mapped to &Equals(Value);
    class method NewGuid: Guid; mapped to NewGuid;
    class method Parse(Value: String): Guid;
    class operator Equal(GuidA, GuidB: Guid): Boolean;
    class operator NotEqual(GuidA, GuidB: Guid): Boolean;
    method ToByteArray: array of byte; mapped to ToByteArray;     
  end;
  {$ELSEIF NOUGAT}
  Guid = public class
  private
    fData: array of Byte;
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
{$ENDIF}

{$IF ECHOES}
class method Guid.Parse(Value: String): Guid;
begin
  exit new Guid(Value);
end;
{$ENDIF}

{$IF COOPER OF ECHOES}
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

method Guid.ToString: String;
begin
  var GuidString := new NSMutableString();

  for i: Integer := 0 to 3 do
    GuidString.appendFormat("%02hhX", fData[i]);

  GuidString.appendString("-");

  for i: Integer := 4 to 5 do
    GuidString.appendFormat("%02hhX", fData[i]);

  GuidString.appendString("-");

  for i: Integer := 6 to 7 do
    GuidString.appendFormat("%02hhX", fData[i]);

  GuidString.appendString("-");

  for i: Integer := 8 to 9 do
    GuidString.appendFormat("%02hhX", fData[i]);

  GuidString.appendString("-");

  for i: Integer := 10 to 15 do
    GuidString.appendFormat("%02hhX", fData[i]);

  exit GuidString;
end;

method Guid.InternalParse(Data: String): array of Byte;
begin
  var Offset := 0;

  if (Data.length <> 38) and (Data.length <> 36) then
    raise new NSException;

  if Data.characterAtIndex(0) = '{' then begin
    if Data.characterAtIndex(37) <> '}' then
      raise new NSException;

    Offset := 1;
  end
  else if Data.characterAtIndex(0) = '(' then begin
    if Data.characterAtIndex(37) <> ')' then
      raise new NSException;

    Offset := 1;
  end;

  if (Data.characterAtIndex(8+Offset) <> '-') or (Data.characterAtIndex(13+Offset) <> '-') or
     (Data.characterAtIndex(18+Offset) <> '-') or (Data.characterAtIndex(23+Offset) <> '-') then
    raise new NSException;

  var Scanner := NSScanner.scannerWithString(Data.uppercaseString);
  var HexChars := NSCharacterSet.characterSetWithCharactersInString("0123456789ABCDEF");
  var HexString := NSMutableString.string;

  //Clear string from "{}()-" symbols
  while (not Scanner.isAtEnd) do begin
    var Buffer: String;
    if (Scanner.scanCharactersFromSet(HexChars) intoString(var Buffer)) then
      HexString.appendString(Buffer)
    else
      Scanner.setScanLocation(Scanner.scanLocation + 1);
  end;

  // We should get 32 chars
  if HexString.length <> 32 then
    raise new NSException;

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

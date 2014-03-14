namespace Sugar;

interface

type
  Encoding = public class {$IF COOPER}mapped to java.nio.charset.Charset{$ELSEIF ECHOES}mapped to System.Text.Encoding{$ELSEIF NOUGAT}{$ENDIF}
  public
    method GetBytes(Value: array of Char): array of Byte;
    method GetBytes(Value: array of Char; Offset: Integer; Count: Integer): array of Byte;
    method GetBytes(Value: String): array of Byte;

    method GetChars(Value: array of Byte; Offset: Integer; Count: Integer): array of Char;
    method GetChars(Value: array of Byte): array of Char;

    method GetString(Value: array of Byte): String;
    method GetString(Value: array of Byte; Offset: Integer; Count: Integer): String;

    class method GetEncoding(Name: String): Encoding;

    class property ASCII: Encoding read GetEncoding("ASCII");
    class property UTF8: Encoding read GetEncoding("UTF-8");
    class property UTF16LE: Encoding read GetEncoding("UTF-16LE");
    class property UTF16BE: Encoding read GetEncoding("UTF-16BE");
  end;

implementation

method Encoding.GetBytes(Value: array of Char): array of Byte;
begin
  {$IF COOPER}
  exit GetBytes(Value, 0, Value.length);
  {$ELSEIF ECHOES}
  exit mapped.GetBytes(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method Encoding.GetBytes(Value: array of Char; Offset: Integer; Count: Integer): array of Byte;
begin
  {$IF COOPER}
  var Buffer := mapped.encode(java.nio.CharBuffer.wrap(Value, Offset, Count));
  result := new Byte[Buffer.remaining];
  Buffer.get(result);
  {$ELSEIF ECHOES}
  exit mapped.GetBytes(Value, Offset, Count);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method Encoding.GetBytes(Value: String): array of Byte;
begin
  {$IF COOPER}
  var Buffer := mapped.encode(Value);
  result := new Byte[Buffer.remaining];
  Buffer.get(result);
  {$ELSEIF ECHOES}
  exit mapped.GetBytes(Value);
  {$ELSEIF NOUGAT}
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
  {$ENDIF}
end;

method Encoding.GetChars(Value: array of Byte): array of Char;
begin
  {$IF COOPER}
  exit GetChars(Value, 0, Value.length);
  {$ELSEIF ECHOES}
  exit mapped.GetChars(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method Encoding.GetString(Value: array of Byte): String;
begin
  {$IF COOPER}
  exit GetString(Value, 0, Value.length);
  {$ELSEIF ECHOES}
  exit mapped.GetString(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method Encoding.GetString(Value: array of Byte; Offset: Integer; Count: Integer): String;
begin
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
  {$ENDIF}
end;

class method Encoding.GetEncoding(Name: String): Encoding;
begin
  {$IF COOPER}
  exit java.nio.charset.Charset.forName(Name);
  {$ELSEIF ECHOES}
  exit System.Text.Encoding.GetEncoding(Name);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

end.

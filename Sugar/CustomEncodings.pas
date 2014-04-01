namespace Sugar;

interface

type
  CustomEncoding = public abstract class (System.Text.Encoding)
  private
    method getLookupTable: Sugar.Collections.Dictionary<Char,Byte>;
    var fLookupTable: Sugar.Collections.Dictionary<Char, Byte>;
  private
    class var Encodings: Sugar.Collections.List<CustomEncoding>;
  protected
    property Alphabet: String read; virtual; abstract;
    property LookupTable: Sugar.Collections.Dictionary<Char, Byte> read getLookupTable;
  public
    method GetBytes(chars: array of Char; charIndex: Integer; charCount: Integer; bytes: array of Byte; byteIndex: Integer): Integer; override;
    method GetChars(bytes: array of Byte; byteIndex: Integer; byteCount: Integer; chars: array of Char; charIndex: Integer): Integer; override;
    method GetByteCount(chars: array of Char; &index: Integer; count: Integer): Integer; override;
    method GetCharCount(bytes: array of Byte; &index: Integer; count: Integer): Integer; override;
    method GetMaxByteCount(charCount: Integer): Integer; override;
    method GetMaxCharCount(byteCount: Integer): Integer; override;

    class method ForName(WebName: String): CustomEncoding;
  end;

implementation

method CustomEncoding.getLookupTable: Sugar.Collections.Dictionary<Char, Byte>;
begin
  if fLookupTable = nil then begin
    var Chars := Alphabet.ToCharArray;
    fLookupTable := new Sugar.Collections.Dictionary<Char,Byte>;
    for i: Integer := 0 to Chars.Length - 1 do
      fLookupTable.Add(Chars[i], i);
  end;

  exit fLookupTable;
end;

method CustomEncoding.GetBytes(chars: array of Char; charIndex: Integer; charCount: Integer; bytes: array of Byte; byteIndex: Integer): Integer;
begin
  SugarArgumentNullException.RaiseIfNil(chars, "Chars");
  SugarArgumentNullException.RaiseIfNil(bytes, "Bytes");

  RangeHelper.Validate(Range.MakeRange(charIndex, charCount), chars.Length);
  RangeHelper.Validate(Range.MakeRange(byteIndex, charCount), bytes.Length);

  var ReplacementByte: Byte := if LookupTable.ContainsKey('?') then LookupTable['?'] else 32;

  for i: Integer := 0 to charCount - 1 do begin
    var CharValue := chars[charIndex + i];
    bytes[byteIndex + i] := if LookupTable.ContainsKey(CharValue) then LookupTable[CharValue] else ReplacementByte;
  end;

  exit charCount;
end;

method CustomEncoding.GetChars(bytes: array of Byte; byteIndex: Integer; byteCount: Integer; chars: array of Char; charIndex: Integer): Integer;
begin
  SugarArgumentNullException.RaiseIfNil(chars, "Chars");
  SugarArgumentNullException.RaiseIfNil(bytes, "Bytes");

  RangeHelper.Validate(Range.MakeRange(byteIndex, byteCount), bytes.Length);
  RangeHelper.Validate(Range.MakeRange(charIndex, byteCount), chars.Length);

  var Alpha := Alphabet.ToCharArray;
  for i: Integer := 0 to byteCount - 1 do begin
    var ByteValue := bytes[byteIndex + i];

    if ByteValue >= Alpha.Length then
      chars[charIndex + i] := '?'
    else
      chars[charIndex + i] := Alpha[ByteValue];
  end;

  exit byteCount;
end;

method CustomEncoding.GetByteCount(chars: array of Char; &index: Integer; count: Integer): Integer;
begin
  exit count;
end;

method CustomEncoding.GetCharCount(bytes: array of Byte; &index: Integer; count: Integer): Integer;
begin
  exit count;
end;

method CustomEncoding.GetMaxByteCount(charCount: Integer): Integer;
begin
  exit charCount;
end;

method CustomEncoding.GetMaxCharCount(byteCount: Integer): Integer;
begin
  exit byteCount;
end;

class method CustomEncoding.ForName(WebName: String): CustomEncoding;
begin
  if Encodings = nil then begin
    Encodings := new Sugar.Collections.List<CustomEncoding>;

    var lTypes := System.Reflection.&Assembly.GetExecutingAssembly.GetTypes;
    for i: Integer := 0 to lTypes.Length - 1 do begin
      if lTypes[i].IsSubclassOf(typeOf(CustomEncoding)) then
        Encodings.Add(Activator.CreateInstance(lTypes[i]) as CustomEncoding);
    end;
  end;

  exit Encodings.Find(item -> item.WebName.Equals(WebName, StringComparison.InvariantCultureIgnoreCase));
end;

end.
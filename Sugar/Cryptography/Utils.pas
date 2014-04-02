namespace Sugar.Cryptography;

interface

uses
  Sugar;

type
  Utils = public static class
  private
    method HexValue(C: Char): Integer;
  public
    method ToHexString(Data: array of Byte; Offset: Integer; Count: Integer): String;
    method ToHexString(Data: array of Byte; Count: Integer): String;
    method ToHexString(Data: array of Byte): String;
    method FromHexString(Data: String): array of Byte;
  end;

implementation

class method Utils.ToHexString(Data: array of Byte; Offset: Integer; Count: Integer): String;
begin
  if Data = nil then
    raise new SugarArgumentNullException("Data");

  if Count = 0 then
    exit "";

  RangeHelper.Validate(Range.MakeRange(Offset, Count), Data.Length);

  var Chars := new Char[Count * 2];
  var Num: Integer;

  for i: Integer := 0 to Count - 1 do begin
    Num := Data[Offset + i] shr 4;
    Chars[i * 2] := chr(55 + Num + (((Num - 10) shr 31) and -7));
    Num := Data[Offset + i] and $F;
    Chars[i * 2 + 1] := chr(55 + Num + (((Num - 10) shr 31) and -7));
  end;

  exit new String(Chars);
end;

class method Utils.ToHexString(Data: array of Byte; Count: Integer): String;
begin
  exit ToHexString(Data, 0, Count);
end;

class method Utils.ToHexString(Data: array of Byte): String;
begin
  if Data = nil then
    raise new SugarArgumentNullException("Data");

  exit ToHexString(Data, 0, Data.Length);
end;

class method Utils.FromHexString(Data: String): array of Byte;
begin
  SugarArgumentNullException.RaiseIfNil(Data, "Data");

  if Data.Length = 0 then
    exit [];

  if Data.Length mod 2 = 1 then
    raise new SugarFormatException("{0}. {1}", ErrorMessage.FORMAT_ERROR, "Hex string can not have odd number of chars.");

  result := new Byte[Data.Length shr 1];

  for i: Integer := 0 to result.Length - 1 do
    result[i] := Byte((HexValue(Data[i shl 1]) shl 4) + HexValue(Data[(i shl 1) + 1]));
end;

class method Utils.HexValue(C: Char): Integer;
begin
  var Value := ord(C);
  result := Value - (if Value < 58 then 48 else if Value < 97 then 55 else 87);

  if (result > 15) or (result < 0) then
    raise new SugarFormatException("{0}. Invalid character: [{1}]", ErrorMessage.FORMAT_ERROR, C);
end;

end.

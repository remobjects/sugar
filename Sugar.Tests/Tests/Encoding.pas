namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.TestFramework;

type
  EncodingTest = public class (Testcase)
  private
    method ByteArrayEquals(Expected: array of Byte; Actual: array of Byte);
    method CharArrayEquals(Expected: array of Char; Actual: array of Char);
  public
    method GetBytes;
    method GetBytes2;
    method GetChars;
    method GetString;
    method GetEncoding;
  end;

implementation

method EncodingTest.ByteArrayEquals(Expected: array of Byte; Actual: array of Byte);
begin
  Assert.CheckInt(Expected.Length, Actual.Length);
  for i: Integer := 0 to Expected.Length - 1 do
    Assert.CheckInt(Expected[i], Actual[i]);
end;

method EncodingTest.CharArrayEquals(Expected: array of Char; Actual: array of Char);
begin
  Assert.CheckInt(Expected.Length, Actual.Length);
  for i: Integer := 0 to Expected.Length - 1 do
    Assert.CheckBool(true, Expected[i] = Actual[i], String.Format("Invalid chars. Expected [{0}] but was [{1}]", Expected[i], Actual[i]));
end;

method EncodingTest.GetBytes;
begin
  ByteArrayEquals([72, 101, 108, 108, 111, 194, 169], Encoding.UTF8.GetBytes("Hello©"));
  ByteArrayEquals([72, 0, 101, 0, 108, 0, 108, 0, 111, 0], Encoding.UTF16LE.GetBytes("Hello"));
  ByteArrayEquals([0, 72, 0, 101, 0, 108, 0, 108, 0, 111], Encoding.UTF16BE.GetBytes("Hello"));  
  ByteArrayEquals([72, 101, 108, 108, 111, 63], Encoding.ASCII.GetBytes("Hello©")); // © - is outside of ASCII should be replaced by ?
  ByteArrayEquals([63, 230], Encoding.GetEncoding("Windows-1251").GetBytes("æж"));

  var Value: String := nil;
  Assert.IsException(->Encoding.UTF8.GetBytes(Value));
end;

method EncodingTest.GetBytes2;
begin
  ByteArrayEquals([72, 101, 108, 108, 111, 194, 169], Encoding.UTF8.GetBytes(['H', 'e', 'l', 'l', 'o', '©']));
  ByteArrayEquals([72, 0, 101, 0, 108, 0, 108, 0, 111, 0], Encoding.UTF16LE.GetBytes(['H', 'e', 'l', 'l', 'o']));
  ByteArrayEquals([0, 72, 0, 101, 0, 108, 0, 108, 0, 111], Encoding.UTF16BE.GetBytes(['H', 'e', 'l', 'l', 'o']));
  ByteArrayEquals([72, 101, 108, 108, 111, 63], Encoding.ASCII.GetBytes(['H', 'e', 'l', 'l', 'o', '©']));
  ByteArrayEquals([63, 230], Encoding.GetEncoding("Windows-1251").GetBytes(['æ', 'ж']));
  ByteArrayEquals([108, 108, 111], Encoding.UTF8.GetBytes(['H', 'e', 'l', 'l', 'o', '©'], 2, 3));

  Assert.IsException(->Encoding.UTF8.GetBytes(['a', 'b'], 5, 1));
  Assert.IsException(->Encoding.UTF8.GetBytes(['a', 'b'], 1, 5));
  Assert.IsException(->Encoding.UTF8.GetBytes(['a', 'b'], -1, 1));
  Assert.IsException(->Encoding.UTF8.GetBytes(['a', 'b'], 1, -1));
  var Value: array of Char := nil;
  Assert.IsException(->Encoding.UTF8.GetBytes(Value, 1, 1));
  Assert.IsException(->Encoding.UTF8.GetBytes(Value));
end;

method EncodingTest.GetChars;
begin
  CharArrayEquals(['H', 'e', 'l', 'l', 'o', '©'], Encoding.UTF8.GetChars([72, 101, 108, 108, 111, 194, 169]));
  CharArrayEquals(['H', 'e', 'l', 'l', 'o'], Encoding.UTF16LE.GetChars([72, 0, 101, 0, 108, 0, 108, 0, 111, 0]));
  CharArrayEquals(['H', 'e', 'l', 'l', 'o'], Encoding.UTF16BE.GetChars([0, 72, 0, 101, 0, 108, 0, 108, 0, 111]));
  CharArrayEquals(['H', 'e', 'l', 'l', 'o', '?'], Encoding.ASCII.GetChars([72, 101, 108, 108, 111, 214]));
  CharArrayEquals(['ж'], Encoding.GetEncoding("Windows-1251").GetChars([230]));
  CharArrayEquals(['l', 'l', 'o'], Encoding.UTF8.GetChars([72, 101, 108, 108, 111, 194, 169], 2, 3));

  var Value: array of Byte := nil;  
  Assert.IsException(->Encoding.ASCII.GetChars(Value));
  Assert.IsException(->Encoding.ASCII.GetChars(Value, 5, 1));

  Assert.IsException(->Encoding.ASCII.GetChars([1, 2], 5, 1));
  Assert.IsException(->Encoding.ASCII.GetChars([1, 2], 1, 5));
  Assert.IsException(->Encoding.ASCII.GetChars([1, 2], -1, 1));
  Assert.IsException(->Encoding.ASCII.GetChars([1, 2], 1, -1));
end;

method EncodingTest.GetString;
begin
  Assert.CheckString("Hello©", Encoding.UTF8.GetString([72, 101, 108, 108, 111, 194, 169]));
  Assert.CheckString("Hello", Encoding.UTF16LE.GetString([72, 0, 101, 0, 108, 0, 108, 0, 111, 0]));
  Assert.CheckString("Hello", Encoding.UTF16BE.GetString([0, 72, 0, 101, 0, 108, 0, 108, 0, 111]));
  Assert.CheckString("Hello?", Encoding.ASCII.GetString([72, 101, 108, 108, 111, 214])); //214 - is outside of ASCII range
  Assert.CheckString("Ёж", Encoding.GetEncoding("Windows-1251").GetString([168, 230]));
  Assert.CheckString("llo", Encoding.UTF8.GetString([72, 101, 108, 108, 111, 194, 169], 2, 3));
  Assert.CheckString("", Encoding.UTF8.GetString([]));

  var Value: array of Byte := nil;
  Assert.IsException(->Encoding.UTF8.GetString(Value));
  Assert.IsException(->Encoding.UTF8.GetString(Value, 1, 1));
  
  Assert.IsException(->Encoding.UTF8.GetString([1, 2], 5, 1));
  Assert.IsException(->Encoding.UTF8.GetString([1, 2], 1, 5));
  Assert.IsException(->Encoding.UTF8.GetString([1, 2], -1, 1));
  Assert.IsException(->Encoding.UTF8.GetString([1, 2], 1, -1));
end;

method EncodingTest.GetEncoding;
begin
  Assert.IsNotNull(Encoding.ASCII);
  Assert.IsNotNull(Encoding.UTF8);
  Assert.IsNotNull(Encoding.UTF16LE);
  Assert.IsNotNull(Encoding.UTF16BE);
  Assert.IsNotNull(Encoding.GetEncoding("Windows-1251"));
  Assert.IsNotNull(Encoding.GetEncoding("ISO-8859-7"));

  Assert.IsException(->Encoding.GetEncoding(nil));
  Assert.IsException(->Encoding.GetEncoding(""));
  Assert.IsException(->Encoding.GetEncoding("Something completely different"));
end;


end.
namespace Sugar.Test;

interface

uses
  Sugar,
  RemObjects.Elements.EUnit;

type
  EncodingTest = public class (Test)
  public
    method GetBytes;
    method GetBytes2;
    method GetChars;
    method GetString;
    method GetEncoding;
  end;

implementation

method EncodingTest.GetBytes;
begin
  Assert.AreEqual(Encoding.UTF8.GetBytes("Hello©"), [72, 101, 108, 108, 111, 194, 169]);
  Assert.AreEqual(Encoding.UTF16LE.GetBytes("Hello"), [72, 0, 101, 0, 108, 0, 108, 0, 111, 0]);
  Assert.AreEqual(Encoding.UTF16BE.GetBytes("Hello"), [0, 72, 0, 101, 0, 108, 0, 108, 0, 111]);
  Assert.AreEqual(Encoding.ASCII.GetBytes("Hello"), [72, 101, 108, 108, 111]); 
  Assert.AreEqual(Encoding.GetEncoding("Windows-1251").GetBytes("æж"), [63, 230]);

  var Value: String := nil;
  Assert.Throws(->Encoding.UTF8.GetBytes(Value));
end;

method EncodingTest.GetBytes2;
begin
  Assert.AreEqual(Encoding.UTF8.GetBytes(['H', 'e', 'l', 'l', 'o', '©']), [72, 101, 108, 108, 111, 194, 169]);
  Assert.AreEqual(Encoding.UTF16LE.GetBytes(['H', 'e', 'l', 'l', 'o']), [72, 0, 101, 0, 108, 0, 108, 0, 111, 0]);
  Assert.AreEqual(Encoding.UTF16BE.GetBytes(['H', 'e', 'l', 'l', 'o']), [0, 72, 0, 101, 0, 108, 0, 108, 0, 111]);
  Assert.AreEqual(Encoding.ASCII.GetBytes(['H', 'e', 'l', 'l', 'o']), [72, 101, 108, 108, 111]);
  Assert.AreEqual(Encoding.GetEncoding("Windows-1251").GetBytes(['æ', 'ж']), [63, 230]);
  Assert.AreEqual(Encoding.UTF8.GetBytes(['H', 'e', 'l', 'l', 'o', '©'], 2, 3), [108, 108, 111]);

  Assert.Throws(->Encoding.UTF8.GetBytes(['a', 'b'], 5, 1));
  Assert.Throws(->Encoding.UTF8.GetBytes(['a', 'b'], 1, 5));
  Assert.Throws(->Encoding.UTF8.GetBytes(['a', 'b'], -1, 1));
  Assert.Throws(->Encoding.UTF8.GetBytes(['a', 'b'], 1, -1));
  var Value: array of Char := nil;
  Assert.Throws(->Encoding.UTF8.GetBytes(Value, 1, 1));
  Assert.Throws(->Encoding.UTF8.GetBytes(Value));
end;

method EncodingTest.GetChars;
begin
  Assert.AreEqual(Encoding.UTF8.GetChars([72, 101, 108, 108, 111, 194, 169]), ['H', 'e', 'l', 'l', 'o', '©']);
  Assert.AreEqual(Encoding.UTF16LE.GetChars([72, 0, 101, 0, 108, 0, 108, 0, 111, 0]), ['H', 'e', 'l', 'l', 'o']);
  Assert.AreEqual(Encoding.UTF16BE.GetChars([0, 72, 0, 101, 0, 108, 0, 108, 0, 111]), ['H', 'e', 'l', 'l', 'o']);
  Assert.AreEqual(Encoding.ASCII.GetChars([72, 101, 108, 108, 111]), ['H', 'e', 'l', 'l', 'o']);
  Assert.AreEqual(Encoding.GetEncoding("Windows-1251").GetChars([230]), ['ж']);
  Assert.AreEqual(Encoding.UTF8.GetChars([72, 101, 108, 108, 111, 194, 169], 2, 3), ['l', 'l', 'o']);

  var Value: array of Byte := nil;  
  Assert.Throws(->Encoding.ASCII.GetChars(Value));
  Assert.Throws(->Encoding.ASCII.GetChars(Value, 5, 1));

  Assert.Throws(->Encoding.ASCII.GetChars([1, 2], 5, 1));
  Assert.Throws(->Encoding.ASCII.GetChars([1, 2], 1, 5));
  Assert.Throws(->Encoding.ASCII.GetChars([1, 2], -1, 1));
  Assert.Throws(->Encoding.ASCII.GetChars([1, 2], 1, -1));
end;

method EncodingTest.GetString;
begin
  Assert.AreEqual(Encoding.UTF8.GetString([72, 101, 108, 108, 111, 194, 169]), "Hello©");
  Assert.AreEqual(Encoding.UTF16LE.GetString([72, 0, 101, 0, 108, 0, 108, 0, 111, 0]), "Hello");
  Assert.AreEqual(Encoding.UTF16BE.GetString([0, 72, 0, 101, 0, 108, 0, 108, 0, 111]), "Hello");
  Assert.AreEqual(Encoding.ASCII.GetString([72, 101, 108, 108, 111]), "Hello"); 
  Assert.AreEqual(Encoding.GetEncoding("Windows-1251").GetString([168, 230]), "Ёж");
  Assert.AreEqual(Encoding.UTF8.GetString([72, 101, 108, 108, 111, 194, 169], 2, 3), "llo");
  Assert.AreEqual(Encoding.UTF8.GetString([]), "");

  var Value: array of Byte := nil;
  Assert.Throws(->Encoding.UTF8.GetString(Value));
  Assert.Throws(->Encoding.UTF8.GetString(Value, 1, 1));
  
  Assert.Throws(->Encoding.UTF8.GetString([1, 2], 5, 1));
  Assert.Throws(->Encoding.UTF8.GetString([1, 2], 1, 5));
  Assert.Throws(->Encoding.UTF8.GetString([1, 2], -1, 1));
  Assert.Throws(->Encoding.UTF8.GetString([1, 2], 1, -1));
end;

method EncodingTest.GetEncoding;
begin
  Assert.IsNotNil(Encoding.ASCII);
  Assert.IsNotNil(Encoding.UTF8);
  Assert.IsNotNil(Encoding.UTF16LE);
  Assert.IsNotNil(Encoding.UTF16BE);
  Assert.IsNotNil(Encoding.GetEncoding("Windows-1251"));

  Assert.Throws(->Encoding.GetEncoding(nil));
  Assert.Throws(->Encoding.GetEncoding(""));
  Assert.Throws(->Encoding.GetEncoding("Something completely different"));
end;

end.
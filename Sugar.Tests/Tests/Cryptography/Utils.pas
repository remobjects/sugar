namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.Cryptography,
  Sugar.TestFramework;

type
  UtilsTest = public class (Testcase)
  private
    method AreEquals(Expected, Actual: array of Byte);
  public
    method ToHexString;
    method FromHexString;
  end;

implementation

method UtilsTest.AreEquals(Expected: array of Byte; Actual: array of Byte);
begin
  Assert.CheckInt(Expected.Length, Actual.Length);
  for i: Integer := 0 to Expected.Length - 1 do
    Assert.CheckInt(Expected[i], Actual[i]);
end;

method UtilsTest.ToHexString;
begin
  var Data: array of Byte := [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];

  Assert.CheckString("000102030405060708090A0B0C0D0E0F", Utils.ToHexString(Data));
  Assert.CheckString("0001020304", Utils.ToHexString(Data, 5));
  Assert.CheckString("090A0B", Utils.ToHexString(Data, 9, 3));
  Assert.CheckString("", Utils.ToHexString(Data, 0));

  Assert.CheckString("D41D8CD98F00B204E9800998ECF8427E", Utils.ToHexString(new MessageDigest(DigestAlgorithm.MD5).Digest([])));
  Assert.CheckString("F7FF9E8B7BB2E09B70935A5D785E0CC5D9D0ABF0", Utils.ToHexString(new MessageDigest(DigestAlgorithm.SHA1).Digest(Encoding.UTF8.GetBytes("Hello"))));

  Assert.IsException(->Utils.ToHexString(nil));
  Assert.IsException(->Utils.ToHexString(Data, -1));
  Assert.IsException(->Utils.ToHexString(Data, 55));
  Assert.IsException(->Utils.ToHexString(Data, -1, 1));
  Assert.IsException(->Utils.ToHexString(Data, 1, -1));
  Assert.IsException(->Utils.ToHexString(Data, 54, 1));
  Assert.IsException(->Utils.ToHexString(Data, 1, 54));
end;

method UtilsTest.FromHexString;
begin
  var Data: String := "000102030405060708090A0B0C0D0E0F";
  AreEquals([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], Utils.FromHexString(Data));
  AreEquals(new MessageDigest(DigestAlgorithm.MD5).Digest([]), Utils.FromHexString("D41D8CD98F00B204E9800998ECF8427E"));
  AreEquals([], Utils.FromHexString(""));

  Assert.IsException(->Utils.FromHexString(nil));
  Assert.IsException(->Utils.FromHexString("FFF"));
  Assert.IsException(->Utils.FromHexString("FFFZ"));
  Assert.IsException(->Utils.FromHexString(#13#10));
end;

end.

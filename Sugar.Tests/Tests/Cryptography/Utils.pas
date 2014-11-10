namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.Cryptography,
  RemObjects.Elements.EUnit;

type
  UtilsTest = public class (Test)
  public
    method ToHexString;
    method FromHexString;
  end;

implementation

method UtilsTest.ToHexString;
begin
  var Data: array of Byte := [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];

  Assert.AreEqual(Utils.ToHexString(Data), "000102030405060708090A0B0C0D0E0F");
  Assert.AreEqual(Utils.ToHexString(Data, 5), "0001020304");
  Assert.AreEqual(Utils.ToHexString(Data, 9, 3), "090A0B");
  Assert.AreEqual(Utils.ToHexString(Data, 0), "");

  Assert.AreEqual(Utils.ToHexString(MessageDigest.ComputeHash([], DigestAlgorithm.MD5)), "D41D8CD98F00B204E9800998ECF8427E");
  Assert.AreEqual(Utils.ToHexString(MessageDigest.ComputeHash(Encoding.UTF8.GetBytes("Hello"), DigestAlgorithm.SHA1)), "F7FF9E8B7BB2E09B70935A5D785E0CC5D9D0ABF0");

  Assert.Throws(->Utils.ToHexString(nil));
  Assert.Throws(->Utils.ToHexString(Data, -1));
  Assert.Throws(->Utils.ToHexString(Data, 55));
  Assert.Throws(->Utils.ToHexString(Data, -1, 1));
  Assert.Throws(->Utils.ToHexString(Data, 1, -1));
  Assert.Throws(->Utils.ToHexString(Data, 54, 1));
  Assert.Throws(->Utils.ToHexString(Data, 1, 54));
end;

method UtilsTest.FromHexString;
begin
  {$WARNING Disabled #69184}
  {var Data: String := "000102030405060708090A0B0C0D0E0F";
  Assert.AreEqual(Utils.FromHexString(Data), [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]);
  Assert.AreEqual(Utils.FromHexString("D41D8CD98F00B204E9800998ECF8427E"), MessageDigest.ComputeHash([], DigestAlgorithm.MD5));
  Assert.AreEqual(Utils.FromHexString(""), []);

  Assert.Throws(->Utils.FromHexString(nil));
  Assert.Throws(->Utils.FromHexString("FFF"));
  Assert.Throws(->Utils.FromHexString("FFFZ"));
  Assert.Throws(->Utils.FromHexString(#13#10));}
end;

end.
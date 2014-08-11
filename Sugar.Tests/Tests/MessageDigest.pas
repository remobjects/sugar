namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.Cryptography,
  RemObjects.Elements.EUnit;

type
  MessageDigestTest = public class (Test)
  public
    method ComputeHash;
    method Updatable;
    method Algorithms;
    method ToHexString;
  end;

implementation

method MessageDigestTest.Algorithms;
begin
  var Data := Encoding.UTF8.GetBytes("These aren't the droids you're looking for");

  Assert.AreEqual(Utils.ToHexString(new MessageDigest(DigestAlgorithm.MD5).Digest(Data)), "6ECD7F39E50E4C52D4E383133E18AEB3");
  Assert.AreEqual(Utils.ToHexString(new MessageDigest(DigestAlgorithm.SHA1).Digest(Data)), "1BD44F7B2657CA9C9D7516885FA925D5791D624C");
  Assert.AreEqual(Utils.ToHexString(new MessageDigest(DigestAlgorithm.SHA256).Digest(Data)), "DBCE3DDA001C46C396653CF6C5435DC9833741FA9257DC031FDFF48B57DAB374");
  Assert.AreEqual(Utils.ToHexString(new MessageDigest(DigestAlgorithm.SHA384).Digest(Data)), "3729BBA3B503AC182F75586E69B6F4A6AB5B26D88569B65817EE495D4821B8B9831B8F78CD6DB407A59B321509AB9E8D");
  Assert.AreEqual(Utils.ToHexString(new MessageDigest(DigestAlgorithm.SHA512).Digest(Data)), "B9DF79CE9E94E4C014D21E2B98424FD79665CF224804761BD56164D7E704A6B0C98C4658CD937DABA449892F0A643522BA7F66C3FB7B9116A2961F999BB36463");
end;

method MessageDigestTest.ComputeHash;
begin
  var Data := Encoding.UTF8.GetBytes("Test data value");

  Assert.AreEqual(new MessageDigest(DigestAlgorithm.SHA256).Digest(Data), [17, 39, 191, 114, 255, 158, 204, 142, 164, 10, 242, 207, 178,
  103, 68, 150, 91, 239, 120, 242, 0, 247, 102, 31, 106, 135, 223, 73, 120, 212, 103, 25]);

  Assert.AreEqual(new MessageDigest(DigestAlgorithm.SHA384).Digest(Data, 4), [123, 143, 70, 84, 7, 107, 128, 235, 150, 57, 17, 241, 156, 250,
  209, 170, 244, 40, 94, 212, 142, 130, 111, 108, 222, 27, 1, 167, 154, 167,
  63, 173, 181, 68, 110, 102, 127, 196, 249, 4, 23, 120, 44, 145, 39, 5, 64, 243]);

  Assert.AreEqual(new MessageDigest(DigestAlgorithm.MD5).Digest(Data, 5, 4), [141, 119, 127, 56, 93, 61, 254, 200, 129, 93, 32, 247, 73, 96, 38, 220]);

  Assert.AreEqual(new MessageDigest(DigestAlgorithm.SHA1).Digest([]), [218, 57, 163, 238, 94, 107, 75, 13,
  50, 85, 191, 239, 149, 96, 24, 144, 175, 216, 7, 9]);

  Assert.Throws(->new MessageDigest(DigestAlgorithm.MD5).Digest(nil, 0, 1 ));
  Assert.Throws(->new MessageDigest(DigestAlgorithm.SHA1).Digest(Data, -1, 1));
  Assert.Throws(->new MessageDigest(DigestAlgorithm.SHA256).Digest(Data, 1, -1));
  Assert.Throws(->new MessageDigest(DigestAlgorithm.SHA384).Digest(Data, 55, 1));
  Assert.Throws(->new MessageDigest(DigestAlgorithm.MD5).Digest(Data, 1, 55));

  var md := new MessageDigest(DigestAlgorithm.SHA1);
  Assert.AreEqual(Utils.ToHexString(md.Digest([1, 2, 3])), "7037807198C22A7D2B0807371D763779A84FDFCF");
  Assert.AreEqual(Utils.ToHexString(md.Digest([4, 5, 6])), "E809C5D1CEA47B45E34701D23F608A9A58034DC9");
  Assert.AreEqual(Utils.ToHexString(md.Digest([7, 8, 9])), "B470CF972A0D84FBAEEEDB51A963A902269417E8");

  Assert.AreEqual(Utils.ToHexString(MessageDigest.ComputeHash([1, 2, 3], DigestAlgorithm.SHA1)), "7037807198C22A7D2B0807371D763779A84FDFCF");
  Assert.AreEqual(Utils.ToHexString(MessageDigest.ComputeHash([4, 5, 6], DigestAlgorithm.SHA1)), "E809C5D1CEA47B45E34701D23F608A9A58034DC9");
  Assert.AreEqual(Utils.ToHexString(MessageDigest.ComputeHash([7, 8, 9], DigestAlgorithm.SHA1)), "B470CF972A0D84FBAEEEDB51A963A902269417E8");

end;

method MessageDigestTest.ToHexString;
begin
  Assert.AreEqual(Utils.ToHexString(new MessageDigest(DigestAlgorithm.MD5).Digest([])), "D41D8CD98F00B204E9800998ECF8427E");
  Assert.AreEqual(Utils.ToHexString(new MessageDigest(DigestAlgorithm.SHA1).Digest(Encoding.UTF8.GetBytes("Hello"))), "F7FF9E8B7BB2E09B70935A5D785E0CC5D9D0ABF0");
  Assert.AreEqual(Utils.ToHexString([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 42]), "000102030405060708090A0B0C0D0E0F2A");
end;

method MessageDigestTest.Updatable;
begin
  var Expected: array of Byte := [153, 229, 39, 4, 70, 45, 53, 128, 219, 53, 40, 202, 215, 234, 150, 96];

  var Digest := new MessageDigest(DigestAlgorithm.MD5);
  Digest.Update(Encoding.UTF8.GetBytes("Ping"));
  var Actual := Digest.Digest(Encoding.UTF8.GetBytes("Pong"));

  Assert.AreEqual(Actual, Expected);

  Digest := new MessageDigest(DigestAlgorithm.MD5);
  Assert.Throws(->Digest.Update(nil, 1, 1));
  Assert.Throws(->Digest.Update([], -1, 1));
  Assert.Throws(->Digest.Update([], 1, -1));
  Assert.Throws(->Digest.Update([1], 5, 1));
  Assert.Throws(->Digest.Update([1], 0, 5));
  Assert.Throws(->Digest.Digest(nil, 1, 1));
  Assert.Throws(->Digest.Digest([], -1, 1));
  Assert.Throws(->Digest.Digest([], 1, -1));
  Assert.Throws(->Digest.Digest([1], 5, 1));
  Assert.Throws(->Digest.Digest([1], 0, 5));
end;

end.

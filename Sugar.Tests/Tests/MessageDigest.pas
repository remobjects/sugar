namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.TestFramework;

type
  MessageDigestTest = public class (Testcase)
  private
    method AreEquals(Expected, Actual: array of Byte);
  public
    method ComputeHash;
    method Updatable;
    method Algorithms;
    method ToHexString;
  end;

implementation

method MessageDigestTest.AreEquals(Expected: array of Byte; Actual: array of Byte);
begin
  Assert.CheckInt(length(Expected), length(Actual));
  for i: Int32 := 0 to length(Expected) - 1 do
    Assert.CheckInt(Expected[i], Actual[i]);
end;

method MessageDigestTest.Algorithms;
begin
  var Data := Encoding.UTF8.GetBytes("These aren't the droids you're looking for");

  Assert.CheckString("6ECD7F39E50E4C52D4E383133E18AEB3", MessageDigest.ToHexString(new MessageDigest(DigestAlgorithm.MD5).Digest(Data)));
  Assert.CheckString("1BD44F7B2657CA9C9D7516885FA925D5791D624C", MessageDigest.ToHexString(new MessageDigest(DigestAlgorithm.SHA1).Digest(Data)));
  Assert.CheckString("DBCE3DDA001C46C396653CF6C5435DC9833741FA9257DC031FDFF48B57DAB374", MessageDigest.ToHexString(new MessageDigest(DigestAlgorithm.SHA256).Digest(Data)));
  Assert.CheckString("3729BBA3B503AC182F75586E69B6F4A6AB5B26D88569B65817EE495D4821B8B9831B8F78CD6DB407A59B321509AB9E8D", MessageDigest.ToHexString(new MessageDigest(DigestAlgorithm.SHA384).Digest(Data)));
  Assert.CheckString("B9DF79CE9E94E4C014D21E2B98424FD79665CF224804761BD56164D7E704A6B0C98C4658CD937DABA449892F0A643522BA7F66C3FB7B9116A2961F999BB36463", MessageDigest.ToHexString(new MessageDigest(DigestAlgorithm.SHA512).Digest(Data)));
end;

method MessageDigestTest.ComputeHash;
begin
  var Data := Encoding.UTF8.GetBytes("Test data value");

  AreEquals([17, 39, 191, 114, 255, 158, 204, 142, 164, 10, 242, 207, 178,
  103, 68, 150, 91, 239, 120, 242, 0, 247, 102, 31, 106, 135, 223, 73, 120, 212, 103, 25], new MessageDigest(DigestAlgorithm.SHA256).Digest(Data));

  AreEquals([123, 143, 70, 84, 7, 107, 128, 235, 150, 57, 17, 241, 156, 250,
  209, 170, 244, 40, 94, 212, 142, 130, 111, 108, 222, 27, 1, 167, 154, 167,
  63, 173, 181, 68, 110, 102, 127, 196, 249, 4, 23, 120, 44, 145, 39, 5, 64, 243], new MessageDigest(DigestAlgorithm.SHA384).Digest(Data, 4));

  AreEquals([141, 119, 127, 56, 93, 61, 254, 200, 129, 93, 32, 247, 73, 96, 38, 220], new MessageDigest(DigestAlgorithm.MD5).Digest(Data, 5, 4));

  AreEquals([218, 57, 163, 238, 94, 107, 75, 13,
  50, 85, 191, 239, 149, 96, 24, 144, 175, 216, 7, 9], new MessageDigest(DigestAlgorithm.SHA1).Digest([]));

  Assert.IsException(->new MessageDigest(DigestAlgorithm.MD5).Digest(nil, 0, 1 ));
  Assert.IsException(->new MessageDigest(DigestAlgorithm.SHA1).Digest(Data, -1, 1));
  Assert.IsException(->new MessageDigest(DigestAlgorithm.SHA256).Digest(Data, 1, -1));
  Assert.IsException(->new MessageDigest(DigestAlgorithm.SHA384).Digest(Data, 55, 1));
  Assert.IsException(->new MessageDigest(DigestAlgorithm.MD5).Digest(Data, 1, 55));

  var md := new MessageDigest(DigestAlgorithm.SHA1);
  Assert.CheckString("7037807198C22A7D2B0807371D763779A84FDFCF", MessageDigest.ToHexString(md.Digest([1, 2, 3])));
  Assert.CheckString("E809C5D1CEA47B45E34701D23F608A9A58034DC9", MessageDigest.ToHexString(md.Digest([4, 5, 6])));
  Assert.CheckString("B470CF972A0D84FBAEEEDB51A963A902269417E8", MessageDigest.ToHexString(md.Digest([7, 8, 9])));
end;

method MessageDigestTest.ToHexString;
begin
  Assert.CheckString("D41D8CD98F00B204E9800998ECF8427E", MessageDigest.ToHexString(new MessageDigest(DigestAlgorithm.MD5).Digest([])));
  Assert.CheckString("F7FF9E8B7BB2E09B70935A5D785E0CC5D9D0ABF0", MessageDigest.ToHexString(new MessageDigest(DigestAlgorithm.SHA1).Digest(Encoding.UTF8.GetBytes("Hello"))));
  Assert.CheckString("000102030405060708090A0B0C0D0E0F2A", MessageDigest.ToHexString([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 42]));
end;

method MessageDigestTest.Updatable;
begin
  var Expected: array of Byte := [153, 229, 39, 4, 70, 45, 53, 128, 219, 53, 40, 202, 215, 234, 150, 96];

  var Digest := new MessageDigest(DigestAlgorithm.MD5);
  Digest.Update(Encoding.UTF8.GetBytes("Ping"));
  var Actual := Digest.Digest(Encoding.UTF8.GetBytes("Pong"));

  AreEquals(Expected, Actual);

  Digest := new MessageDigest(DigestAlgorithm.MD5);
  Assert.IsException(->Digest.Update(nil, 1, 1));
  Assert.IsException(->Digest.Update([], -1, 1));
  Assert.IsException(->Digest.Update([], 1, -1));
  Assert.IsException(->Digest.Update([1], 5, 1));
  Assert.IsException(->Digest.Update([1], 0, 5));
  Assert.IsException(->Digest.Digest(nil, 1, 1));
  Assert.IsException(->Digest.Digest([], -1, 1));
  Assert.IsException(->Digest.Digest([], 1, -1));
  Assert.IsException(->Digest.Digest([1], 5, 1));
  Assert.IsException(->Digest.Digest([1], 0, 5));
end;

end.

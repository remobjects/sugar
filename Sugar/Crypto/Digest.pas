namespace Sugar;

interface

uses
{$IF ECHOES}
  System.Security.Cryptography;
{$ELSEIF COOPER}
  Sugar.Cooper,
  java.security;
{$ELSEIF NOUGAT}
  rtl;
{$ENDIF}

type  
  DigestAlgorithm = public (MD5, SHA1, SHA256, SHA384, SHA512); 

  MessageDigest = public class {$IF COOPER}{$ELSEIF ECHOES}mapped to System.Security.Cryptography.HashAlgorithm{$ELSEIF NOUGAT}{$ENDIF}
  public
    constructor(Algorithm: DigestAlgorithm);

    method Update(Data: array of Byte; Offset: Integer; Count: Integer);
    method Update(Data: array of Byte; Count: Integer);
    method Update(Data: array of Byte);

    method Digest(Data: array of Byte; Offset: Integer; Count: Integer): array of Byte;
    method Digest(Data: array of Byte; Count: Integer): array of Byte;
    method Digest(Data: array of Byte): array of Byte;

    class method ToHexString(Data: array of Byte): String;
  end;

implementation

constructor MessageDigest(Algorithm: DigestAlgorithm);
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  case Algorithm of
    DigestAlgorithm.MD5: exit MD5.Create();
    DigestAlgorithm.SHA1: exit SHA1.Create;
    DigestAlgorithm.SHA256: exit SHA256.Create;
    DigestAlgorithm.SHA384: exit SHA384.Create;
    DigestAlgorithm.SHA512: exit SHA512.Create;
    else
      raise new SugarNotImplementedException;
  end;
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method MessageDigest.Update(Data: array of Byte; Offset: Integer; Count: Integer);
begin
  if Data = nil then
    raise new SugarArgumentNullException("Data");

  if not ((Offset = 0) and (Count = 0)) then
    RangeHelper.Validate(Range.MakeRange(Offset, Count), Data.Length);

  {$IF COOPER}
  {$ELSEIF ECHOES}
  mapped.TransformBlock(Data, Offset, Count, nil, 0);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method MessageDigest.Update(Data: array of Byte; Count: Integer);
begin
  Update(Data, 0, Count);
end;

method MessageDigest.Update(Data: array of Byte);
begin
  if Data = nil then
    raise new SugarArgumentNullException("Data");

  Update(Data, 0, Data.Length);
end;

method MessageDigest.Digest(Data: array of Byte; Offset: Integer; Count: Integer): array of Byte;
begin
  if Data = nil then
    raise new SugarArgumentNullException("Data");

  if not ((Offset = 0) and (Count = 0)) then
    RangeHelper.Validate(Range.MakeRange(Offset, Count), Data.Length);

  {$IF COOPER}
  {$ELSEIF ECHOES}
  mapped.TransformFinalBlock(Data, Offset, Count);
  exit mapped.Hash;
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method MessageDigest.Digest(Data: array of Byte; Count: Integer): array of Byte;
begin
  exit Digest(Data, 0, Count);
end;

method MessageDigest.Digest(Data: array of Byte): array of Byte;
begin
  if Data = nil then
    raise new SugarArgumentNullException("Data");

  exit Digest(Data, 0, Data.Length);
end;

class method MessageDigest.ToHexString(Data: array of Byte): String;
begin
  if Data = nil then
    raise new SugarArgumentNullException("Data");

  if Data.Length = 0 then
    exit "";

  var Chars := new Char[Data.Length * 2];
  var Num: Integer;

  for i: Integer := 0 to Data.Length - 1 do begin
    Num := Data[i] shr 4;
    Chars[i * 2] := chr(55 + Num + (((Num - 10) shr 31) and -7));
    Num := Data[i] and $F;
    Chars[i * 2 + 1] := chr(55 + Num + (((Num - 10) shr 31) and -7));
  end;

  exit new String(Chars);
end;

(*
class method MessageDigest.Digest(data: array of Byte; algorithm: DigestAlgorithm): array of Byte;

begin
  {$IFDEF ECHOES}
  var ha: HashAlgorithm;
  case algorithm of
    DigestAlgorithm.MD5: ha := new MD5CryptoServiceProvider;
    DigestAlgorithm.SHA1: ha := new SHA1Managed;
    DigestAlgorithm.SHA256: ha := new SHA256Managed;
    DigestAlgorithm.SHA384: ha := new SHA384Managed;
    DigestAlgorithm.SHA512: ha := new SHA512Managed;
    else // just to be sure when adding new digest types we recieve exception, not empty digest
      raise new SugarNotImplementedException; 
  end;
  exit ha.ComputeHash(data);
  {$ENDIF}
  {$IFDEF COOPER}
  var ha: MessageDigest;
  case algorithm of
    DigestAlgorithm.MD5: ha := MessageDigest.getInstance('MD5');
    DigestAlgorithm.SHA1: ha := MessageDigest.getInstance('SHA-1');
    DigestAlgorithm.SHA256: ha := MessageDigest.getInstance('SHA-256');
    DigestAlgorithm.SHA384: ha := MessageDigest.getInstance('SHA-384');
    DigestAlgorithm.SHA512: ha := MessageDigest.getInstance('SHA-512');
    else // just to be sure when adding new digest types we recieve exception, not empty digest
      raise new SugarNotImplementedException; 
  end;
  exit ArrayUtils.ToUnsignedArray(ha.digest(ArrayUtils.ToSignedArray(data)));
  {$ENDIF}
  {$IFDEF NOUGAT}
  // TODO: CC_MD5
  // https://developer.apple.com/library/mac/#documentation/Darwin/Reference/Manpages/man3/Common%20Crypto.3cc.html

  var digest: array of Byte;

  case algorithm of
    DigestAlgorithm.MD5: begin
        digest := new Byte[CC_MD5_DIGEST_LENGTH];
        CC_MD5( data, Length(data), digest );
      end;

    DigestAlgorithm.SHA1: begin
        digest := new Byte[CC_SHA1_DIGEST_LENGTH];
        CC_SHA1( data,length(data), digest );
      end;

    DigestAlgorithm.SHA256: begin
        digest := new Byte[CC_SHA256_DIGEST_LENGTH];
        CC_SHA256( data,length(data), digest );
      end;

    DigestAlgorithm.SHA384: begin
        digest := new Byte[CC_SHA384_DIGEST_LENGTH];
        CC_SHA384( data,length(data), digest );
      end;

    DigestAlgorithm.SHA512: begin
        digest := new Byte[CC_SHA512_DIGEST_LENGTH];
        CC_SHA512( data,length(data), digest );
      end;

    else // just to be sure when adding new digest types we recieve exception, not empty digest
      raise new SugarNotImplementedException;  
  end;

  exit digest;

  {$ENDIF}
end;
*)
end.

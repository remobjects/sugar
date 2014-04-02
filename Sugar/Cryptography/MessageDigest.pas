namespace Sugar.Cryptography;

interface

uses
  Sugar,
{$IF NETFX_CORE}
  Windows.Security.Cryptography.Core;
{$ELSEIF ECHOES}
  System.Security.Cryptography;
{$ELSEIF COOPER}
  Sugar.Cooper,
  java.security;
{$ELSEIF NOUGAT}
  rtl;
{$ENDIF}

type  
  DigestAlgorithm = public (MD5, SHA1, SHA256, SHA384, SHA512); 

  MessageDigest = public class {$IF COOPER}mapped to java.security.MessageDigest{$ELSEIF NETFX_CORE}mapped to CryptographicHash{$ELSEIF ECHOES}mapped to System.Security.Cryptography.HashAlgorithm{$ELSEIF NOUGAT}{$ENDIF}
  public
    constructor(Algorithm: DigestAlgorithm);

    method Reset; virtual;

    method Update(Data: array of Byte; Offset: Integer; Count: Integer); virtual;
    method Update(Data: array of Byte; Count: Integer);
    method Update(Data: array of Byte);

    method Digest(Data: array of Byte; Offset: Integer; Count: Integer): array of Byte; virtual;
    method Digest(Data: array of Byte; Count: Integer): array of Byte;
    method Digest(Data: array of Byte): array of Byte;
  end;

implementation

constructor MessageDigest(Algorithm: DigestAlgorithm);
begin
  {$IF COOPER}
  case Algorithm of
    DigestAlgorithm.MD5: exit java.security.MessageDigest.getInstance("MD5");
    DigestAlgorithm.SHA1: exit java.security.MessageDigest.getInstance("SHA-1");
    DigestAlgorithm.SHA256: exit java.security.MessageDigest.getInstance("SHA-256");
    DigestAlgorithm.SHA384: exit java.security.MessageDigest.getInstance("SHA-384");
    DigestAlgorithm.SHA512: exit java.security.MessageDigest.getInstance("SHA-512");
    else
      raise new SugarNotImplementedException;
  end;
  {$ELSEIF NETFX_CORE}
  case Algorithm of
    DigestAlgorithm.MD5: exit HashAlgorithmProvider.OpenAlgorithm(HashAlgorithmNames.Md5).CreateHash;
    DigestAlgorithm.SHA1: exit HashAlgorithmProvider.OpenAlgorithm(HashAlgorithmNames.Sha1).CreateHash;
    DigestAlgorithm.SHA256: exit HashAlgorithmProvider.OpenAlgorithm(HashAlgorithmNames.Sha256).CreateHash;
    DigestAlgorithm.SHA384: exit HashAlgorithmProvider.OpenAlgorithm(HashAlgorithmNames.Sha384).CreateHash;
    DigestAlgorithm.SHA512: exit HashAlgorithmProvider.OpenAlgorithm(HashAlgorithmNames.Sha512).CreateHash;
    else
      raise new SugarNotImplementedException;
  end;
  {$ELSEIF WINDOWS_PHONE}
  case Algorithm of
    DigestAlgorithm.MD5: exit new Sugar.Cryptography.MD5Managed;
    DigestAlgorithm.SHA1: exit new SHA1Managed;
    DigestAlgorithm.SHA256: exit new SHA256Managed;
    DigestAlgorithm.SHA384: exit new Sugar.Cryptography.SHA384Managed;
    DigestAlgorithm.SHA512: exit new Sugar.Cryptography.SHA512Managed;
    else
      raise new SugarNotImplementedException;
  end;
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
  case Algorithm of
    DigestAlgorithm.MD5: result := new MD5;
    DigestAlgorithm.SHA1: result := new SHA1;
    DigestAlgorithm.SHA256: result := new SHA256;
    DigestAlgorithm.SHA384: result := new SHA384;
    DigestAlgorithm.SHA512: result := new SHA512;
    else
      raise new SugarNotImplementedException;
  end;

  result.Reset;
  {$ENDIF}
end;

method MessageDigest.Update(Data: array of Byte; Offset: Integer; Count: Integer);
begin
  if Data = nil then
    raise new SugarArgumentNullException("Data");

  if not ((Offset = 0) and (Count = 0)) then
    RangeHelper.Validate(Range.MakeRange(Offset, Count), Data.Length);

  {$IF COOPER}
  mapped.update(Data, Offset, Count);
  {$ELSEIF NETFX_CORE}
  var lData := new Byte[Count];
  Array.Copy(Data, Offset, lData, 0, Count);
  var Buffer := Windows.Security.Cryptography.CryptographicBuffer.CreateFromByteArray(lData);
  mapped.Append(Buffer);
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
  mapped.update(Data, Offset, Count);
  result := mapped.digest;
  {$ELSEIF NETFX_CORE}
  var lData := new Byte[Count];
  Array.Copy(Data, Offset, lData, 0, Count);
  var Buffer := Windows.Security.Cryptography.CryptographicBuffer.CreateFromByteArray(lData);
  mapped.Append(Buffer);
  Buffer := mapped.GetValueAndReset;
  result := new Byte[Buffer.Length];
  Windows.Security.Cryptography.CryptographicBuffer.CopyToByteArray(Buffer, result);
  {$ELSEIF ECHOES}
  mapped.TransformFinalBlock(Data, Offset, Count);
  result := mapped.Hash;
  mapped.Initialize;
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

method MessageDigest.Reset;
begin
  {$IF COOPER}
  mapped.reset;
  {$ELSEIF NETFX_CORE}
  mapped.GetValueAndReset;
  {$ELSEIF ECHOES}  
  mapped.Initialize;
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

end.
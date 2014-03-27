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

  MessageDigest = public class {$IF COOPER}mapped to java.security.MessageDigest{$ELSEIF ECHOES}mapped to System.Security.Cryptography.HashAlgorithm{$ELSEIF NOUGAT}{$ENDIF}
  public
    constructor(Algorithm: DigestAlgorithm);

    method Update(Data: array of Byte; Offset: Integer; Count: Integer); virtual;
    method Update(Data: array of Byte; Count: Integer);
    method Update(Data: array of Byte);

    method Digest(Data: array of Byte; Offset: Integer; Count: Integer): array of Byte; virtual;
    method Digest(Data: array of Byte; Count: Integer): array of Byte;
    method Digest(Data: array of Byte): array of Byte;

    class method ToHexString(Data: array of Byte): String;
  end;

  {$IF NOUGAT}
  MD5 = private class (MessageDigest)
  private
    Context: CC_MD5_CTX;
  public
    constructor;
    method Update(Data: array of Byte; Offset: Integer; Count: Integer); override;
    method Digest(Data: array of Byte; Offset: Integer; Count: Integer): array of Byte; override;
  end;

  SHA1 = private class (MessageDigest)
  private
    Context: CC_SHA1_CTX;
  public
    constructor;
    method Update(Data: array of Byte; Offset: Integer; Count: Integer); override;
    method Digest(Data: array of Byte; Offset: Integer; Count: Integer): array of Byte; override;
  end;

  SHA256 = private class (MessageDigest)
  private
    Context: CC_SHA256_CTX;
  public
    constructor;
    method Update(Data: array of Byte; Offset: Integer; Count: Integer); override;
    method Digest(Data: array of Byte; Offset: Integer; Count: Integer): array of Byte; override;
  end;

  SHA384 = private class (MessageDigest)
  private
    Context: CC_SHA512_CTX;
  public
    constructor;
    method Update(Data: array of Byte; Offset: Integer; Count: Integer); override;
    method Digest(Data: array of Byte; Offset: Integer; Count: Integer): array of Byte; override;
  end;

  SHA512 = private class (MessageDigest)
  private
    Context: CC_SHA512_CTX;
  public
    constructor;
    method Update(Data: array of Byte; Offset: Integer; Count: Integer); override;
    method Digest(Data: array of Byte; Offset: Integer; Count: Integer): array of Byte; override;
  end;
  {$ENDIF}

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
    DigestAlgorithm.MD5: exit new MD5;
    DigestAlgorithm.SHA1: exit new SHA1;
    DigestAlgorithm.SHA256: exit new SHA256;
    DigestAlgorithm.SHA384: exit new SHA384;
    DigestAlgorithm.SHA512: exit new SHA512;
    else
      raise new SugarNotImplementedException;
  end;
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
  exit mapped.digest;
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

{$IF NOUGAT}
constructor MD5;
begin
  CC_MD5_Init(@Context);
end;

method MD5.Update(Data: array of Byte; Offset: Integer; Count: Integer);
begin
  inherited Update(Data, Offset, Count);
  CC_MD5_Update(@Context, @Data[Offset], Count);
end;

method MD5.Digest(Data: array of Byte; Offset: Integer; Count: Integer): array of Byte;
begin
  inherited Digest(Data, Offset, Count);
  CC_MD5_Update(@Context, @Data[Offset], Count);
  result := new Byte[CC_MD5_DIGEST_LENGTH];
  CC_MD5_Final(result, @Context);
end;

constructor SHA1;
begin
  CC_SHA1_Init(@Context);
end;

method SHA1.Update(Data: array of Byte; Offset: Integer; Count: Integer);
begin
  inherited Update(Data, Offset, Count);
  CC_SHA1_Update(@Context, @Data[Offset], Count);
end;

method SHA1.Digest(Data: array of Byte; Offset: Integer; Count: Integer): array of Byte;
begin
  inherited Digest(Data, Offset, Count);
  CC_SHA1_Update(@Context, @Data[Offset], Count);
  result := new Byte[CC_SHA1_DIGEST_LENGTH];
  CC_SHA1_Final(result, @Context);
end;

constructor SHA256;
begin
  CC_SHA256_Init(@Context);
end;

method SHA256.Update(Data: array of Byte; Offset: Integer; Count: Integer);
begin
  inherited Update(Data, Offset, Count);
  CC_SHA256_Update(@Context, @Data[Offset], Count);
end;

method SHA256.Digest(Data: array of Byte; Offset: Integer; Count: Integer): array of Byte;
begin
  inherited Digest(Data, Offset, Count);
  CC_SHA256_Update(@Context, @Data[Offset], Count);
  result := new Byte[CC_SHA256_DIGEST_LENGTH];
  CC_SHA256_Final(result, @Context);
end;

constructor SHA384;
begin
  CC_SHA384_Init(@Context);
end;

method SHA384.Update(Data: array of Byte; Offset: Integer; Count: Integer);
begin
  inherited Update(Data, Offset, Count);
  CC_SHA384_Update(@Context, @Data[Offset], Count);
end;

method SHA384.Digest(Data: array of Byte; Offset: Integer; Count: Integer): array of Byte;
begin
  inherited Digest(Data, Offset, Count);
  CC_SHA384_Update(@Context, @Data[Offset], Count);
  result := new Byte[CC_SHA384_DIGEST_LENGTH];
  CC_SHA384_Final(result, @Context);
end;

constructor SHA512;
begin
  CC_SHA512_Init(@Context);
end;

method SHA512.Update(Data: array of Byte; Offset: Integer; Count: Integer);
begin
  inherited Update(Data, Offset, Count);
  CC_SHA512_Update(@Context, @Data[Offset], Count);
end;

method SHA512.Digest(Data: array of Byte; Offset: Integer; Count: Integer): array of Byte;
begin
  inherited Digest(Data, Offset, Count);
  CC_SHA512_Update(@Context, @Data[Offset], Count);
  result := new Byte[CC_SHA512_DIGEST_LENGTH];
  CC_SHA512_Final(result, @Context);
end;
{$ENDIF}

end.
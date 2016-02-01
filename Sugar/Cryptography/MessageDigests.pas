namespace Sugar.Cryptography;

interface

{$IFNDEF NOUGAT}
  {$ERROR This unit is intended for Nougat only}
{$ENDIF}
{$CROSSPLATFORM OFF}

uses
  rtl;

type
  MD5 = private class (MessageDigest)
  private
    Context: CC_MD5_CTX;
  public
    method Update(Data: array of Byte; Offset: Integer; Count: Integer); override;
    method Digest(Data: array of Byte; Offset: Integer; Count: Integer): array of Byte; override;
    method Reset; override;
  end;

  SHA1 = private class (MessageDigest)
  private
    Context: CC_SHA1_CTX;
  public
    method Update(Data: array of Byte; Offset: Integer; Count: Integer); override;
    method Digest(Data: array of Byte; Offset: Integer; Count: Integer): array of Byte; override;
    method Reset; override;
  end;

  SHA256 = private class (MessageDigest)
  private
    Context: CC_SHA256_CTX;
  public
    method Update(Data: array of Byte; Offset: Integer; Count: Integer); override;
    method Digest(Data: array of Byte; Offset: Integer; Count: Integer): array of Byte; override;
    method Reset; override;
  end;

  SHA384 = private class (MessageDigest)
  private
    Context: CC_SHA512_CTX;
  public
    method Update(Data: array of Byte; Offset: Integer; Count: Integer); override;
    method Digest(Data: array of Byte; Offset: Integer; Count: Integer): array of Byte; override;
    method Reset; override;
  end;

  SHA512 = private class (MessageDigest)
  private
    Context: CC_SHA512_CTX;
  public
    method Update(Data: array of Byte; Offset: Integer; Count: Integer); override;
    method Digest(Data: array of Byte; Offset: Integer; Count: Integer): array of Byte; override;
    method Reset; override;
  end;

implementation

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
  Reset;
end;

method MD5.Reset;
begin
  CC_MD5_Init(@Context);
end;

method SHA1.Reset;
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
  Reset;
end;

method SHA256.Reset;
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
  Reset;
end;

method SHA384.Reset;
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
  Reset;
end;

method SHA512.Reset;
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
  Reset;
end;

end.

namespace Sugar;

interface

type  
  DigestAlgorithms = public (MD5, SHA1, SHA256, SHA384, SHA512); 
  Crypto = public class
  private
  protected
  public
    class method Digest(data: array of Byte; algorithm: DigestAlgorithms): array of Byte;
    //todo: class method Random
  end;

implementation

uses
{$IFDEF ECHOES}
  System.Security.Cryptography;
{$ENDIF}
{$IFDEF COOPER}
  Sugar.Cooper,
  java.security;
{$ENDIF}
{$IFDEF NOUGAT}
  rtl;
{$ENDIF}



class method Crypto.Digest(data: array of Byte; algorithm: DigestAlgorithms): array of Byte;

begin
  {$IFDEF ECHOES}
  var ha: HashAlgorithm;
  case algorithm of
    DigestAlgorithms.MD5: ha := new MD5CryptoServiceProvider;
    DigestAlgorithms.SHA1: ha := new SHA1Managed;
    DigestAlgorithms.SHA256: ha := new SHA256Managed;
    DigestAlgorithms.SHA384: ha := new SHA384Managed;
    DigestAlgorithms.SHA512: ha := new SHA512Managed;
    else // just to be sure when adding new digest types we recieve exception, not empty digest
      raise new SugarNotImplementedException; 
  end;
  exit ha.ComputeHash(data);
  {$ENDIF}
  {$IFDEF COOPER}
  var ha: MessageDigest;
  case algorithm of
    DigestAlgorithms.MD5: ha := MessageDigest.getInstance('MD5');
    DigestAlgorithms.SHA1: ha := MessageDigest.getInstance('SHA-1');
    DigestAlgorithms.SHA256: ha := MessageDigest.getInstance('SHA-256');
    DigestAlgorithms.SHA384: ha := MessageDigest.getInstance('SHA-384');
    DigestAlgorithms.SHA512: ha := MessageDigest.getInstance('SHA-512');
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
    DigestAlgorithms.MD5: begin
        digest := new Byte[CC_MD5_DIGEST_LENGTH];
        CC_MD5( data, Length(data), digest );
      end;

    DigestAlgorithms.SHA1: begin
        digest := new Byte[CC_SHA1_DIGEST_LENGTH];
        CC_SHA1( data,length(data), digest );
      end;

    DigestAlgorithms.SHA256: begin
        digest := new Byte[CC_SHA256_DIGEST_LENGTH];
        CC_SHA256( data,length(data), digest );
      end;

    DigestAlgorithms.SHA384: begin
        digest := new Byte[CC_SHA384_DIGEST_LENGTH];
        CC_SHA384( data,length(data), digest );
      end;

    DigestAlgorithms.SHA512: begin
        digest := new Byte[CC_SHA512_DIGEST_LENGTH];
        CC_SHA512( data,length(data), digest );
      end;

    else // just to be sure when adding new digest types we recieve exception, not empty digest
      raise new SugarNotImplementedException;  
  end;

  exit digest;

  {$ENDIF}
end;

end.

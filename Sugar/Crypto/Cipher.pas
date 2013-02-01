namespace RemObjects.Oxygene.Sugar.Crypto;

interface

{$IFDEF ECHOES}(*
uses 
  System.IO,
  System.IO.Compression,
  System.Security.Cryptography;

type
  Aes = public class
  private
  protected
  public
    const AESBlockLength = 16;
    const AESKeyLength = 32;
    const AesCipherMode = CipherMode.CBC;
    const AesPaddingMode = PaddingMode.PKCS7;
    class method AesFactory(myKey: AESKey := nil; myIV: AESBlock := nil): AesManaged;
    class method GenerateKeys: tuple of (AESBlock, AESKey);
    class method encryptStringToBytes(plainText: String; Key: AESKey; IV: AESBlock): array of Byte;
    class method decryptStringFromBytes(cipherText: array of Byte; Key: AESKey; IV: AESBlock): String;
  end;
  AESBlock = array[0 .. AESBlockLength - 1] of Byte;
  AESKey = array[0 .. AESKeyLength - 1] of Byte;  
*){$ENDIF}

implementation

{$IFDEF ECHOES}(*
class method Aes.AesFactory(myKey: AESKey; myIV: AESBlock): AesManaged;
begin
  result := new AesManaged(
    Mode := AesCipherMode, 
    Padding := AesPaddingMode,
    KeySize := AESKeyLength * 8,
    FeedbackSize := AESBlockLength * 8,
    BlockSize := AESBlockLength * 8);
  if assigned(myKey) and assigned(myIV) then begin
    result.Key := myKey;
    result.IV := myIV;
  end;
ensure
  result.Mode = AesCipherMode;
  result.Padding = AesPaddingMode;
  result.KeySize = AESKeyLength * 8;
  result.FeedbackSize = AESBlockLength * 8;
  result.BlockSize = AESBlockLength * 8;
end;

class method Aes.GenerateKeys: tuple of (AESBlock, AESKey);
begin
  using aes := AesFactory do
    exit(aes.IV, aes.Key);
end;

class method Aes.encryptStringToBytes(plainText: String; Key: AESKey; IV: AESBlock): array of Byte;
require
  assigned(plainText) : "The method encryptStringToBytes requires the plainText parameter to be defined.";
  plainText.Length > 0 : "The method encryptStringToBytes requires the plainText parameter to be defined.";
  assigned(Key) : "The method encryptStringToBytes requires the Key parameter to be defined.";
  assigned(IV) : "The method encryptStringToBytes requires the IV parameter to be defined.";
  Key.Length = AESKeyLength : "Invalid Key Length when calling encryptStringToBytes.";
  IV.Length = AESBlockLength : "Invalid IV Length when calling encryptStringToBytes.";
begin
  // Create an AesManaged object with the specified key and IV.
  using aesAlg := AesFactory(Key, IV) do
  // The encrytor to performs the stream transform.
  using encryptor := aesAlg.CreateEncryptor(aesAlg.Key, aesAlg.IV) do
  // The memory stream holds the output
  using output := new MemoryStream() do
  // The CryptoStream performs the encryption
  using encStrm := new CryptoStream(output, encryptor, CryptoStreamMode.Write) do
  // The DeflateStream compresses the input
  using gzip := new DeflateStream(encStrm, CompressionMode.Compress) do // in .NET 4.5 use CompressionLevel.Fastest
  // The StreamWriter takes the input 
  using writer := new StreamWriter(gzip) do begin
    //Write all data to the stream.
    writer.Write(plainText);

    // Close writer to prepare output
    writer.Close();

    exit output.ToArray();
  end;
ensure
  assigned(result) and (result.Length > 0): "Undefined result from encryptStringToBytes.";
end;

class method Aes.decryptStringFromBytes(cipherText: array of Byte; Key: AESKey; IV: AESBlock): String;
require
  assigned(cipherText) : "The method decryptStringFromBytes requires the cipherText parameter to be defined.";
  cipherText.Length > 0 : "The method decryptStringFromBytes requires the cipherText parameter to be defined.";
  assigned(Key) : "The method encryptStringToBytes requires the Key parameter to be defined.";
  assigned(IV) : "The method encryptStringToBytes requires the IV parameter to be defined.";
  Key.Length = AESKeyLength : "Invalid Key Length when calling encryptStringToBytes.";
  IV.Length = AESBlockLength : "Invalid IV Length when calling encryptStringToBytes.";
begin
  var plaintext: String;
  // Create an AesManaged object with the specified key and IV.
  using aesAlg := AesFactory(Key, IV) do
  // Create a decrytor to perform the stream transform.
  using decryptor := aesAlg.CreateDecryptor(aesAlg.Key, aesAlg.IV) do
  // Create the streams used for decryption.
  using inStrm := new MemoryStream(cipherText) do
  using decStrm := new CryptoStream(inStrm, decryptor, CryptoStreamMode.Read) do
  using gzip := new DeflateStream(decStrm, CompressionMode.Decompress) do
  using reader := new StreamReader(gzip) do begin

    // Read the decrypted bytes from the decrypting stream and place them in a string.
    plaintext := reader.ReadToEnd();
  end;
  exit plaintext;
ensure
  assigned(result) : "Undefined result from decryptStringFromBytes.";
  result.Length > 0 : "Undefined result from decryptStringFromBytes.";
end;
*){$ENDIF}

end.

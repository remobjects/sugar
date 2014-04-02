//
// MD5.pas
//
// This file is ported from the Mono project
//
//Original file:
// System.Security.Cryptography.SHA512Managed.cs
//
//Original Authors:
//	Dan Lewis (dihlewis@yahoo.co.uk)
//	Sebastien Pouliot (sebastien@ximian.com)
//
// (C) 2002
// Implementation translated from Bouncy Castle JCE (http://www.bouncycastle.org/)
// See bouncycastle.txt for license.
// Copyright (C) 2004-2005 Novell, Inc (http://www.novell.com)
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
namespace Sugar.Cryptography;

interface

type
  SHA512Managed = public class (System.Security.Cryptography.HashAlgorithm)
  private
    xBuf: array of Byte;
    xBufOff: Int32;
    ByteCount1: UInt64;
    ByteCount2: UInt64;
    H1, H2, H3, H4, H5, H6, H7, H8: UInt64;
    W: array of UInt64;
    wOff: Int32;

    method Initialize(Reuse: Boolean);
    method Update(Input: Byte);
    method ProcessWord(Input: array of Byte; Offset: Integer);
    method UnpackWord(Word: UInt64; Output: array of Byte; Offset: Integer);
    method AdjustByteCounts;
    method ProcessLength(LowW: UInt64; HiW: UInt64);
    method ProcessBlock;
    method RotateRight(X: UInt64; n: Int32): UInt64;
    method Ch(X: UInt64; Y: UInt64; Z: UInt64): UInt64;
    method Maj(X: UInt64; Y: UInt64; Z: UInt64): UInt64;
    method Sum0(X: UInt64): UInt64;
    method Sum1(X: UInt64): UInt64;
    method Sigma0(X: UInt64): UInt64;
    method Sigma1(X: UInt64): UInt64;
  private
    class var K2: array of UInt64 := [
			$428a2f98d728ae22, $7137449123ef65cd, $b5c0fbcfec4d3b2f, $e9b5dba58189dbbc,
			$3956c25bf348b538, $59f111f1b605d019, $923f82a4af194f9b, $ab1c5ed5da6d8118,
			$d807aa98a3030242, $12835b0145706fbe, $243185be4ee4b28c, $550c7dc3d5ffb4e2,
			$72be5d74f27b896f, $80deb1fe3b1696b1, $9bdc06a725c71235, $c19bf174cf692694,
			$e49b69c19ef14ad2, $efbe4786384f25e3, $0fc19dc68b8cd5b5, $240ca1cc77ac9c65,
			$2de92c6f592b0275, $4a7484aa6ea6e483, $5cb0a9dcbd41fbd4, $76f988da831153b5,
			$983e5152ee66dfab, $a831c66d2db43210, $b00327c898fb213f, $bf597fc7beef0ee4,
			$c6e00bf33da88fc2, $d5a79147930aa725, $06ca6351e003826f, $142929670a0e6e70,
			$27b70a8546d22ffc, $2e1b21385c26c926, $4d2c6dfc5ac42aed, $53380d139d95b3df,
			$650a73548baf63de, $766a0abb3c77b2a8, $81c2c92e47edaee6, $92722c851482353b,
			$a2bfe8a14cf10364, $a81a664bbc423001, $c24b8b70d0f89791, $c76c51a30654be30,
			$d192e819d6ef5218, $d69906245565a910, $f40e35855771202a, $106aa07032bbd1b8,
			$19a4c116b8d2d0c8, $1e376c085141ab53, $2748774cdf8eeb99, $34b0bcb5e19b48a8,
			$391c0cb3c5c95a63, $4ed8aa4ae3418acb, $5b9cca4f7763e373, $682e6ff3d6b2b8a3,
			$748f82ee5defb2fc, $78a5636f43172f60, $84c87814a1f0ab72, $8cc702081a6439ec,
			$90befffa23631e28, $a4506cebde82bde9, $bef9a3f7b2c67915, $c67178f2e372532b,
			$ca273eceea26619c, $d186b8c721c0c207, $eada7dd6cde0eb1e, $f57d4f7fee6ed178,
			$06f067aa72176fba, $0a637dc5a2c898a6, $113f9804bef90dae, $1b710b35131c471b,
			$28db77f523047d84, $32caab7b40c72493, $3c9ebe0a15c9bebc, $431d67c49c100d4c,
			$4cc5d4becb3e42b6, $597f299cfc657e2a, $5fcb6fab3ad6faec, $6c44198c4a475817]; readonly;
  protected
    method HashCore(&array: array of Byte; ibStart: Integer; cbSize: Integer); override;
    method HashFinal: array of Byte; override;
  public
    constructor;
    method Initialize; override;
  end;

implementation

method SHA512Managed.Initialize(Reuse: Boolean);
begin
  // SHA-512 initial hash value
  // The first 64 bits of the fractional parts of the square roots
  // of the first eight prime numbers
  H1 := $6a09e667f3bcc908;
  H2 := $bb67ae8584caa73b;
  H3 := $3c6ef372fe94f82b;
  H4 := $a54ff53a5f1d36f1;
  H5 := $510e527fade682d1;
  H6 := $9b05688c2b3e6c1f;
  H7 := $1f83d9abfb41bd6b;
  H8 := $5be0cd19137e2179;

  if Reuse then begin
    ByteCount1 := 0;
    ByteCount2 := 0;

    xBufOff := 0;

    for i: Integer := 0 to xBuf.Length - 1 do 
      xBuf[i] := 0;

    wOff := 0;
    for i: Integer := 0 to W.Length - 1 do
      W[i] := 0;
  end;
end;

method SHA512Managed.Update(Input: Byte);
begin
  xBuf[xBufOff] := Input;
  inc(xBufOff);
  if xBufOff = xBuf.Length then begin
    ProcessWord(xBuf, 0);
    xBufOff := 0;
  end;
  inc(ByteCount1);
end;

method SHA512Managed.ProcessWord(Input: array of Byte; Offset: Integer);
begin
  W[wOff] := (UInt64(Input[Offset]) shl 56) or
            (UInt64(Input[Offset + 1]) shl 48) or
            (UInt64(Input[Offset + 2]) shl 40) or
            (UInt64(Input[Offset + 3]) shl 32) or
            (UInt64(Input[Offset + 4]) shl 24) or
            (UInt64(Input[Offset + 5]) shl 16) or
            (UInt64(Input[Offset + 6]) shl 8) or
            (UInt64(Input[Offset + 7]));
  inc(wOff);
  if wOff = 16 then
    ProcessBlock;
end;

method SHA512Managed.UnpackWord(Word: UInt64; Output: array of Byte; Offset: Integer);
begin
  Output[Offset] := Byte(Word shr 56);
  Output[Offset + 1] := Byte(Word shr 48);
  Output[Offset + 2] := Byte(Word shr 40);
  Output[Offset + 3] := Byte(Word shr 32);
  Output[Offset + 4] := Byte(Word shr 24);
  Output[Offset + 5] := Byte(Word shr 16);
  Output[Offset + 6] := Byte(Word shr 8);
  Output[Offset + 7] := Byte(Word);
end;

method SHA512Managed.AdjustByteCounts;
begin
  if ByteCount1 > Int64($1fffffffffffffff) then begin
    ByteCount2 := ByteCount2 + (ByteCount1 shr 61);
    ByteCount1 := ByteCount1 and Int64($1fffffffffffffff);
  end;
end;

method SHA512Managed.ProcessLength(LowW: UInt64; HiW: UInt64);
begin
  if wOff > 14 then
    ProcessBlock;

  W[14] := HiW;
  W[15] := LowW;
end;

method SHA512Managed.ProcessBlock;
begin
  AdjustByteCounts;

  for i: Integer := 16 to 79 do
    W[i] := Sigma1(W[i - 2]) + W[i - 7] + Sigma0(W[i - 15]) + W[i - 16];

  // set up working variables.
  var a: UInt64 := H1;
  var b: UInt64 := H2;
  var c: UInt64 := H3;
  var d: UInt64 := H4;
  var e: UInt64 := H5;
  var f: UInt64 := H6;
  var g: UInt64 := H7;
  var h: UInt64 := H8;

  for i: Integer := 0 to 79 do begin
    var T1: UInt64 := h + Sum1(e) + Ch(e, f, g) + K2[i] + W[i];
    var T2: UInt64 := Sum0(a) + Maj(a, b, c);

    h := g;
    g := f;
    f := e;
    e := d + T1;
    d := c;
    c := b;
    b := a;
    a := T1 + T2;
  end;

  H1 := H1 + a;
  H2 := H2 + b;
  H3 := H3 + c;
  H4 := H4 + d;
  H5 := H5 + e;
  H6 := H6 + f;
  H7 := H7 + g;
  H8 := H8 + h;
  // reset the offset and clean out the word buffer.
  wOff := 0;

  for i: Integer := 0 to W.Length - 1 do
    W[i] := 0;
end;

method SHA512Managed.RotateRight(X: UInt64; n: Int32): UInt64;
begin
  exit (x shr n) or (x shl (64 - n));
end;

method SHA512Managed.Ch(X: UInt64; Y: UInt64; Z: UInt64): UInt64;
begin
  exit ((x and y) xor ((not x) and z));
end;

method SHA512Managed.Maj(X: UInt64; Y: UInt64; Z: UInt64): UInt64;
begin
  exit ((x and y) xor (x and z) xor (y and z));
end;

method SHA512Managed.Sum0(X: UInt64): UInt64;
begin
  exit RotateRight(x, 28) xor RotateRight(x, 34) xor RotateRight(x, 39);
end;

method SHA512Managed.Sum1(X: UInt64): UInt64;
begin
  exit RotateRight(x, 14) xor RotateRight(x, 18) xor RotateRight(x, 41);
end;

method SHA512Managed.Sigma0(X: UInt64): UInt64;
begin
  exit RotateRight(x, 1) xor RotateRight(x, 8) xor (x shr 7);
end;

method SHA512Managed.Sigma1(X: UInt64): UInt64;
begin
  exit RotateRight(x, 19) xor RotateRight(x, 61) xor (x shr 6);
end;

method SHA512Managed.HashCore(&array: array of Byte; ibStart: Integer; cbSize: Integer);
begin
  // fill the current word
  while (xBufOff <> 0) and (cbSize > 0) do begin
    update(&array[ibStart]);
    inc(ibStart);
    dec(cbSize)
  end;

  // process whole words.
  while cbSize > xBuf.Length do begin
    processWord(&array, ibStart);
    ibStart := ibStart + xBuf.Length;
    cbSize := cbSize - xBuf.Length;
    byteCount1 := byteCount1 + UInt64(xBuf.Length)
  end;

  // load in the remainder.
  while cbSize > 0 do begin
    update(&array[ibStart]);
    inc(ibStart);
    dec(cbSize)
  end;
end;

method SHA512Managed.HashFinal: array of Byte;
begin
  AdjustByteCounts;

  var LowBitLength: UInt64 := ByteCount1 shl 3;
  var HiBitLength := ByteCount2;

  Update(Byte(128));
  while xBufOff <> 0 do
    Update(Byte(0));

  ProcessLength(LowBitLength, HiBitLength);
  ProcessBlock;

  var Output := new Byte[64];
  UnpackWord(H1, Output, 0);
  UnpackWord(H2, Output, 8);
  UnpackWord(H3, Output, 16);
  UnpackWord(H4, Output, 24);
  UnpackWord(H5, Output, 32);
  UnpackWord(H6, Output, 40);
  UnpackWord(H7, Output, 48);
  UnpackWord(H8, Output, 56);

  Initialize;
  exit Output;
end;

constructor SHA512Managed;
begin
  HashSizeValue := 512;
  xBuf := new Byte[8];
  W := new UInt64[80];
  Initialize(false);// limited initialization
end;

method SHA512Managed.Initialize;
begin
  Initialize(true);
end;

end.

//
// MD5.pas
//
// This file is ported from the Mono project
//
//Original file:
// System.Security.Cryptography.SHA384Managed.cs
//
//Original Authors:
//  Dan Lewis (dihlewis@yahoo.co.uk)
//  Sebastien Pouliot (sebastien@ximian.com)
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
  SHA384Managed = public class (System.Security.Cryptography.HashAlgorithm)
  private
    xBuf: array of Byte;
    xBufOff: Int32;
    ByteCount1: UInt64;
    ByteCount2: UInt64;
    H1, H2, H3, H4, H5, H6, H7, H8: UInt64;
    W: array of UInt64;
    wOff: Int32;

    method Update(Input: Byte);
    method ProcessWord(Input: array of Byte; Offset: Integer);
    method UnpackWord(Word: UInt64; Output: array of Byte; Offset: Integer);
    method AdjustByteCounts;
    method ProcessLength(LowW: UInt64; HiW: UInt64);
    method ProcessBlock;
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
    method Initialize(Reuse: Boolean);
    method Initialize; override;
  end;

implementation

method SHA384Managed.Update(Input: Byte);
begin
  xBuf[xBufOff] := Input;
  inc(xBufOff);
  if xBufOff = xBuf.Length then begin
    ProcessWord(xBuf, 0);
    xBufOff := 0;
  end;
  inc(ByteCount1);
end;

method SHA384Managed.ProcessWord(Input: array of Byte; Offset: Integer);
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

method SHA384Managed.UnpackWord(Word: System.UInt64; Output: array of Byte; Offset: Integer);
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

// adjust the byte counts so that byteCount2 represents the
// upper long (less 3 bits) word of the byte count.
method SHA384Managed.AdjustByteCounts;
begin
  if ByteCount1 > Int64($1fffffffffffffff) then begin
    ByteCount2 := ByteCount2 + (ByteCount1 shr 61);
    ByteCount1 := ByteCount1 and Int64($1fffffffffffffff);
  end;
end;

method SHA384Managed.ProcessLength(LowW: System.UInt64; HiW: System.UInt64);
begin
  if wOff > 14 then
    ProcessBlock;

  W[14] := HiW;
  W[15] := LowW;
end;

method SHA384Managed.ProcessBlock;
begin
  var a, b, c, d, e, f, g, h: UInt64;

  // abcrem doesn't work on fields
  //var W := self.W;

  AdjustByteCounts;

  for t: Integer := 16 to 79 do begin
    a := W[t - 15];
    a := ((a shr 1) or (a shl 63)) xor ((a shr 8) or (a shl 56)) xor (a shr 7);
    b := W[t - 2];
    b := ((b shr 19) or (b shl 45)) xor ((b shr 61) or (b shl 3)) xor (b shr 6);
    W[t] := b + W[t - 7] + a + W[t - 16];
  end;

  // set up working variables.
  a := H1;
  b := H2;
  c := H3;
  d := H4;
  e := H5;
  f := H6;
  g := H7;
  h := H8;

  for t: Integer := 0 to 79 do begin
    var T1: UInt64 := ((e shr 14) or (e shl 50)) xor ((e shr 18) or (e shl 46)) xor ((e shr 41) or (e shl 23));
    T1 := T1 + h + ((e and f) xor ((not e) and g)) + K2[t] + W[t];

    var T2: UInt64 := ((a shr 28) or (a shl 36)) xor ((a shr 34) or (a shl 30)) xor ((a shr 39) or (a shl 25));
    T2 := T2 + ((a and b) xor (a and c) xor (b and c));

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

method SHA384Managed.HashCore(&array: array of Byte; ibStart: Integer; cbSize: Integer);
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

method SHA384Managed.HashFinal: array of Byte;
begin
  AdjustByteCounts;

  var LowBitLength: UInt64 := ByteCount1 shl 3;
  var HiBitLength := ByteCount2;

  Update(Byte(128));
  while xBufOff <> 0 do
    Update(Byte(0));

  ProcessLength(LowBitLength, HiBitLength);
  ProcessBlock;

  var Output := new Byte[48];
  UnpackWord(H1, Output, 0);
  UnpackWord(H2, Output, 8);
  UnpackWord(H3, Output, 16);
  UnpackWord(H4, Output, 24);
  UnpackWord(H5, Output, 32);
  UnpackWord(H6, Output, 40);

  Initialize;
  exit Output;
end;

constructor SHA384Managed;
begin
  HashSizeValue := 384;
  xBuf := new Byte[8];
  W := new UInt64[80];
  Initialize(false); //limited initialization
end;

method SHA384Managed.Initialize(Reuse: Boolean);
begin
  // SHA-384 initial hash value
  // The first 64 bits of the fractional parts of the square roots
  // of the 9th through 16th prime numbers
  H1 := $cbbb9d5dc1059ed8;
  H2 := $629a292a367cd507;
  H3 := $9159015a3070dd17;
  H4 := $152fecd8f70e5939;
  H5 := $67332667ffc00b31;
  H6 := $8eb44a8768581511;
  H7 := $db0c2e0d64f98fa7;
  H8 := $47b5481dbefa4fa4;

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

method SHA384Managed.Initialize;
begin
  Initialize(true); // reuse instance
end;

end.
//
// MD5Managed.pas
//
// This file is ported from the Mono project
//
//Original File:
// System.Security.Cryptography.MD5CryptoServiceProvider.cs
//
//Original Authors:
//  Matthew S. Ford (Matthew.S.Ford@Rose-Hulman.Edu)
//  Sebastien Pouliot (sebastien@ximian.com)
//
// Copyright 2001 by Matthew S. Ford.
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
//
namespace Sugar.Cryptography;

interface

type
  MD5Managed = public class (System.Security.Cryptography.HashAlgorithm)
  private
    _H: array of UInt32;
    Buff: array of UInt32;
    Count: UInt64;
    _ProcessingBuffer: array of Byte; // Used to start data when passed less than a block worth.
    _ProcessingBufferCount: Int32; // Counts how much data we have stored that still needs processed.
    const BLOCK_SIZE_BYTES: Int32 = 64;
  private
    method ProcessBlock(InputBuffer: array of Byte; InputOffset: Integer);
    method ProcessFinalBlock(InputBuffer: array of Byte; InputOffset: Integer; InputCount: Integer);
    method AddLength(Length: UInt64; Buffer: array of Byte; Position: Integer);
    class var K: array of UInt32 := [
      $d76aa478, $e8c7b756, $242070db, $c1bdceee,
      $f57c0faf, $4787c62a, $a8304613, $fd469501,
      $698098d8, $8b44f7af, $ffff5bb1, $895cd7be,
      $6b901122, $fd987193, $a679438e, $49b40821,
      $f61e2562, $c040b340, $265e5a51, $e9b6c7aa,
      $d62f105d, $02441453, $d8a1e681, $e7d3fbc8,
      $21e1cde6, $c33707d6, $f4d50d87, $455a14ed,
      $a9e3e905, $fcefa3f8, $676f02d9, $8d2a4c8a,
      $fffa3942, $8771f681, $6d9d6122, $fde5380c,
      $a4beea44, $4bdecfa9, $f6bb4b60, $bebfbc70,
      $289b7ec6, $eaa127fa, $d4ef3085, $04881d05,
      $d9d4d039, $e6db99e5, $1fa27cf8, $c4ac5665,
      $f4292244, $432aff97, $ab9423a7, $fc93a039,
      $655b59c3, $8f0ccc92, $ffeff47d, $85845dd1,
      $6fa87e4f, $fe2ce6e0, $a3014314, $4e0811a1,
      $f7537e82, $bd3af235, $2ad7d2bb, $eb86d391]; readonly;
  public
    constructor;
    finalizer;

    method Dispose(disposing: Boolean); override;
    method HashCore(&array: array of Byte; ibStart: Integer; cbSize: Integer); override;
    method HashFinal: array of Byte; override;
    method Initialize; override;
  end;

implementation

method MD5Managed.ProcessBlock(InputBuffer: array of Byte; InputOffset: Integer);
begin
  var a, b, c, d: UInt32;

  Count := Count + BLOCK_SIZE_BYTES;

  for i: Integer := 0 to 15 do
    Buff[i] := UInt32(InputBuffer[InputOffset + 4 * i]) or
               (UInt32((InputBuffer[InputOffset + 4 * i + 1])) shl 8) or
               (UInt32((InputBuffer[InputOffset + 4 * i + 2])) shl 16) or
               (UInt32((InputBuffer[InputOffset + 4 * i + 3])) shl 24);

  a := _H[0];
  b := _H[1];
  c := _H[2];
  d := _H[3];

  // This function was unrolled because it seems to be doubling our performance with current compiler/VM.
  // Possibly roll up if this changes.

  // ---- Round 1 --------
  a := a + (((c xor d) and b) xor d) + UInt32(K[0] + buff[0]);
  a := (a shl 7) or (a shr 25);
  a := a + b;

  d := d + (((b xor c) and a) xor c) + UInt32(K[1] + buff[1]);
  d := (d shl 12) or (d shr 20);
  d := d + a;

  c := c + (((a xor b) and d) xor b) + UInt32(K[2] + buff[2]);
  c := (c shl 17) or (c shr 15);
  c := c + d;

  b := b + (((d xor a) and c) xor a) + UInt32(K[3] + buff[3]);
  b := (b shl 22) or (b shr 10);
  b := b + c;

  a := a + (((c xor d) and b) xor d) + UInt32(K[4] + buff[4]);
  a := (a shl 7) or (a shr 25);
  a := a + b;

  d := d + (((b xor c) and a) xor c) + UInt32(K[5] + buff[5]);
  d := (d shl 12) or (d shr 20);
  d := d + a;

  c := c + (((a xor b) and d) xor b) + UInt32(K[6] + buff[6]);
  c := (c shl 17) or (c shr 15);
  c := c + d;

  b := b + (((d xor a) and c) xor a) + UInt32(K[7] + buff[7]);
  b := (b shl 22) or (b shr 10);
  b := b + c;

  a := a + (((c xor d) and b) xor d) + UInt32(K[8] + buff[8]);
  a := (a shl 7) or (a shr 25);
  a := a + b;

  d := d + (((b xor c) and a) xor c) + UInt32(K[9] + buff[9]);
  d := (d shl 12) or (d shr 20);
  d := d + a;

  c := c + (((a xor b) and d) xor b) + UInt32(K[10] + buff[10]);
  c := (c shl 17) or (c shr 15);
  c := c + d;

  b := b + (((d xor a) and c) xor a) + UInt32(K[11] + buff[11]);
  b := (b shl 22) or (b shr 10);
  b := b + c;

  a := a + (((c xor d) and b) xor d) + UInt32(K[12] + buff[12]);
  a := (a shl 7) or (a shr 25);
  a := a + b;

  d := d + (((b xor c) and a) xor c) + UInt32(K[13] + buff[13]);
  d := (d shl 12) or (d shr 20);
  d := d + a;

  c := c + (((a xor b) and d) xor b) + UInt32(K[14] + buff[14]);
  c := (c shl 17) or (c shr 15);
  c := c + d;

  b := b + (((d xor a) and c) xor a) + UInt32(K[15] + buff[15]);
  b := (b shl 22) or (b shr 10);
  b := b + c;


  // ---- Round 2 --------

  a := a + (((b xor c) and d) xor c) + UInt32(K[16] + buff[1]);
  a := (a shl 5) or (a shr 27);
  a := a + b;

  d := d + (((a xor b) and c) xor b) + UInt32(K[17] + buff[6]);
  d := (d shl 9) or (d shr 23);
  d := d + a;

  c := c + (((d xor a) and b) xor a) + UInt32(K[18] + buff[11]);
  c := (c shl 14) or (c shr 18);
  c := c + d;

  b := b + (((c xor d) and a) xor d) + UInt32(K[19] + buff[0]);
  b := (b shl 20) or (b shr 12);
  b := b + c;

  a := a + (((b xor c) and d) xor c) + UInt32(K[20] + buff[5]);
  a := (a shl 5) or (a shr 27);
  a := a + b;

  d := d + (((a xor b) and c) xor b) + UInt32(K[21] + buff[10]);
  d := (d shl 9) or (d shr 23);
  d := d + a;

  c := c + (((d xor a) and b) xor a) + UInt32(K[22] + buff[15]);
  c := (c shl 14) or (c shr 18);
  c := c + d;

  b := b + (((c xor d) and a) xor d) + UInt32(K[23] + buff[4]);
  b := (b shl 20) or (b shr 12);
  b := b + c;

  a := a + (((b xor c) and d) xor c) + UInt32(K[24] + buff[9]);
  a := (a shl 5) or (a shr 27);
  a := a + b;

  d := d + (((a xor b) and c) xor b) + UInt32(K[25] + buff[14]);
  d := (d shl 9) or (d shr 23);
  d := d + a;

  c := c + (((d xor a) and b) xor a) + UInt32(K[26] + buff[3]);
  c := (c shl 14) or (c shr 18);
  c := c + d;

  b := b + (((c xor d) and a) xor d) + UInt32(K[27] + buff[8]);
  b := (b shl 20) or (b shr 12);
  b := b + c;

  a := a + (((b xor c) and d) xor c) + UInt32(K[28] + buff[13]);
  a := (a shl 5) or (a shr 27);
  a := a + b;

  d := d + (((a xor b) and c) xor b) + UInt32(K[29] + buff[2]);
  d := (d shl 9) or (d shr 23);
  d := d + a;

  c := c + (((d xor a) and b) xor a) + UInt32(K[30] + buff[7]);
  c := (c shl 14) or (c shr 18);
  c := c + d;

  b := b + (((c xor d) and a) xor d) + UInt32(K[31] + buff[12]);
  b := (b shl 20) or (b shr 12);
  b := b + c;


  // ---- Round 3 --------

  a := a + (b xor c xor d) + UInt32(K[32] + buff[5]);
  a := (a shl 4) or (a shr 28);
  a := a + b;

  d := d + (a xor b xor c) + UInt32(K[33] + buff[8]);
  d := (d shl 11) or (d shr 21);
  d := d + a;

  c := c + (d xor a xor b) + UInt32(K[34] + buff[11]);
  c := (c shl 16) or (c shr 16);
  c := c + d;

  b := b + (c xor d xor a) + UInt32(K[35] + buff[14]);
  b := (b shl 23) or (b shr 9);
  b := b + c;

  a := a + (b xor c xor d) + UInt32(K[36] + buff[1]);
  a := (a shl 4) or (a shr 28);
  a := a + b;

  d := d + (a xor b xor c) + UInt32(K[37] + buff[4]);
  d := (d shl 11) or (d shr 21);
  d := d + a;

  c := c + (d xor a xor b) + UInt32(K[38] + buff[7]);
  c := (c shl 16) or (c shr 16);
  c := c + d;

  b := b + (c xor d xor a) + UInt32(K[39] + buff[10]);
  b := (b shl 23) or (b shr 9);
  b := b + c;

  a := a + (b xor c xor d) + UInt32(K[40] + buff[13]);
  a := (a shl 4) or (a shr 28);
  a := a + b;

  d := d + (a xor b xor c) + UInt32(K[41] + buff[0]);
  d := (d shl 11) or (d shr 21);
  d := d + a;

  c := c + (d xor a xor b) + UInt32(K[42] + buff[3]);
  c := (c shl 16) or (c shr 16);
  c := c + d;

  b := b + (c xor d xor a) + UInt32(K[43] + buff[6]);
  b := (b shl 23) or (b shr 9);
  b := b + c;

  a := a + (b xor c xor d) + UInt32(K[44] + buff[9]);
  a := (a shl 4) or (a shr 28);
  a := a + b;

  d := d + (a xor b xor c) + UInt32(K[45] + buff[12]);
  d := (d shl 11) or (d shr 21);
  d := d + a;

  c := c + (d xor a xor b) + UInt32(K[46] + buff[15]);
  c := (c shl 16) or (c shr 16);
  c := c + d;

  b := b + (c xor d xor a) + UInt32(K[47] + buff[2]);
  b := (b shl 23) or (b shr 9);
  b := b + c;


  // ---- Round 4 --------

  a := a + (((not d) or b) xor c) + UInt32(K[48] + buff[0]);
  a := (a shl 6) or (a shr 26);
  a := a + b;

  d := d + (((not c) or a) xor b) + UInt32(K[49] + buff[7]);
  d := (d shl 10) or (d shr 22);
  d := d + a;

  c := c + (((not b) or d) xor a) + UInt32(K[50] + buff[14]);
  c := (c shl 15) or (c shr 17);
  c := c + d;

  b := b + (((not a) or c) xor d) + UInt32(K[51] + buff[5]);
  b := (b shl 21) or (b shr 11);
  b := b + c;

  a := a + (((not d) or b) xor c) + UInt32(K[52] + buff[12]);
  a := (a shl 6) or (a shr 26);
  a := a + b;

  d := d + (((not c) or a) xor b) + UInt32(K[53] + buff[3]);
  d := (d shl 10) or (d shr 22);
  d := d + a;

  c := c + (((not b) or d) xor a) + UInt32(K[54] + buff[10]);
  c := (c shl 15) or (c shr 17);
  c := c + d;

  b := b + (((not a) or c) xor d) + UInt32(K[55] + buff[1]);
  b := (b shl 21) or (b shr 11);
  b := b + c;

  a := a + (((not d) or b) xor c) + UInt32(K[56] + buff[8]);
  a := (a shl 6) or (a shr 26);
  a := a + b;

  d := d + (((not c) or a) xor b) + UInt32(K[57] + buff[15]);
  d := (d shl 10) or (d shr 22);
  d := d + a;

  c := c + (((not b) or d) xor a) + UInt32(K[58] + buff[6]);
  c := (c shl 15) or (c shr 17);
  c := c + d;

  b := b + (((not a) or c) xor d) + UInt32(K[59] + buff[13]);
  b := (b shl 21) or (b shr 11);
  b := b + c;

  a := a + (((not d) or b) xor c) + UInt32(K[60] + buff[4]);
  a := (a shl 6) or (a shr 26);
  a := a + b;

  d := d + (((not c) or a) xor b) + UInt32(K[61] + buff[11]);
  d := (d shl 10) or (d shr 22);
  d := d + a;

  c := c + (((not b) or d) xor a) + UInt32(K[62] + buff[2]);
  c := (c shl 15) or (c shr 17);
  c := c + d;

  b := b + (((not a) or c) xor d) + UInt32(K[63] + buff[9]);
  b := (b shl 21) or (b shr 11);
  b := b + c;

  _H[0] := _H[0] + a;
  _H[1] := _H[1] + b;
  _H[2] := _H[2] + c;
  _H[3] := _H[3] + d;
end;

method MD5Managed.ProcessFinalBlock(InputBuffer: array of Byte; InputOffset: Integer; InputCount: Integer);
begin
  var Total: UInt64 := Count + UInt64(InputCount);
  var PaddingSize: Int32 := Int32((56 - Total mod BLOCK_SIZE_BYTES));

  if PaddingSize < 1 then
      PaddingSize := PaddingSize + BLOCK_SIZE_BYTES;

  var FooBuffer: array of Byte := new Byte[InputCount + PaddingSize + 8];

  for i: Integer := 0 to InputCount - 1 do
    FooBuffer[i] := InputBuffer[i + InputOffset];

  FooBuffer[InputCount] := $80;

  for i: Integer := InputCount + 1 to (InputCount + PaddingSize) - 1 do
    FooBuffer[i] := $0;

  // I deal in bytes. The algorithm deals in bits.
  var Size: UInt64 := Total shl 3;
  AddLength(Size, FooBuffer, InputCount + PaddingSize);
  ProcessBlock(FooBuffer, 0);

  if InputCount + PaddingSize + 8 = 128 then begin
   ProcessBlock(FooBuffer, 64);
end;

end;

method MD5Managed.AddLength(Length: System.UInt64; Buffer: array of Byte; Position: Integer);
begin
  buffer[Position] := Byte(Length);
  inc(Position);
  buffer[Position] := Byte(Length shr 8);
  inc(Position);
  buffer[Position] := Byte(Length shr 16);
  inc(Position);
  buffer[Position] := Byte(Length shr 24);
  inc(Position);
  buffer[Position] := Byte(Length shr 32);
  inc(Position);
  buffer[Position] := Byte(Length shr 40);
  inc(Position);
  buffer[Position] := Byte(Length shr 48);
  inc(Position);
  buffer[Position] := Byte(Length shr 56);
end;

constructor MD5Managed;
begin
  HashSizeValue := 128;
  _H := new UInt32[4];
  Buff := new UInt32[16];
  _ProcessingBuffer := new Byte[BLOCK_SIZE_BYTES];
  Initialize;
end;

finalizer MD5Managed;
begin
  Dispose(false);
end;

method MD5Managed.Dispose(disposing: Boolean);
begin
  if _ProcessingBuffer <> nil then begin
    Array.Clear(_ProcessingBuffer, 0, _ProcessingBuffer.Length);
    _ProcessingBuffer := nil;
  end;

  if _H <> nil then begin
    Array.Clear(_H, 0, _H.Length);
    _H := nil
  end;

  if Buff <> nil then begin
    Array.Clear(Buff, 0, Buff.Length);
    Buff := nil
  end;
end;

method MD5Managed.HashCore(&array: array of Byte; ibStart: Integer; cbSize: Integer);
begin
  var i: Int32;
  State := 1;

  if _ProcessingBufferCount <> 0 then begin
    if cbSize < (BLOCK_SIZE_BYTES - _ProcessingBufferCount) then begin
      System.Buffer.BlockCopy(&array, ibStart, _ProcessingBuffer, _ProcessingBufferCount, cbSize);
      _ProcessingBufferCount := _ProcessingBufferCount + cbSize;
      exit;
    end
    else begin
      i := BLOCK_SIZE_BYTES - _ProcessingBufferCount;
      System.Buffer.BlockCopy(&array, ibStart, _ProcessingBuffer, _ProcessingBufferCount, i);
      ProcessBlock(_ProcessingBuffer, 0);
      _ProcessingBufferCount := 0;
      ibStart := ibStart + i;
      cbSize := cbSize - i;
    end;
  end;

  i := 0;
  while i < cbSize - cbSize mod BLOCK_SIZE_BYTES do begin
    ProcessBlock(&array, ibStart + i);
    i := i + BLOCK_SIZE_BYTES;
  end;

  if cbSize mod BLOCK_SIZE_BYTES <> 0 then begin
    System.Buffer.BlockCopy(&array, cbSize - cbSize mod BLOCK_SIZE_BYTES + ibStart, _ProcessingBuffer, 0, cbSize mod BLOCK_SIZE_BYTES);
    _ProcessingBufferCount := cbSize mod BLOCK_SIZE_BYTES;
  end;
end;

method MD5Managed.HashFinal: array of Byte;
begin
  var Hash := new Byte[16];
  ProcessFinalBlock(_ProcessingBuffer, 0, _ProcessingBufferCount);

  for i: Integer := 0 to 3 do
    for j: Integer := 0 to 3 do
      Hash[i * 4 + j] := Byte(_H[i] shr (j * 8));

  exit Hash;
end;

method MD5Managed.Initialize;
begin
  Count := 0;
  _ProcessingBufferCount := 0;

  _H[0] := $67452301;
  _H[1] := $efcdab89;
  _H[2] := $98badcfe;
  _H[3] := $10325476;
end;

end.
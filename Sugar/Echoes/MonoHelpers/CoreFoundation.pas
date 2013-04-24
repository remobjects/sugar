namespace RemObjects.Sugar.MonoHelpers;

// This code has been converted from C# from https://github.com/remobjects/monohelpers

{$IF NOT ECHOES}
  {ERROR This units is intended for Echoes (Mono) only}
{$ENDIF}

// 
// CoreFoundation.cs
//  
// Author:
//       Michael Hutchinson <mhutchinson@novell.com>
//       Miguel de Icaza
// 
// Copyright (c) 2009 Novell, Inc. (http://www.novell.com)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

interface

uses
  System.Runtime.InteropServices;

type
  CoreFoundation = assembly static class
  public
    const     CFLib: System.String = '/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation';
  private

    [DllImport(CFLib)]
    class method CFStringCreateWithCString(alloc: IntPtr; str: System.String; encoding: System.Int32): IntPtr; external;

  assembly
    class method CreateString(s: System.String): IntPtr;

    [DllImport(CFLib, EntryPoint := 'CFRelease')]
    class method Release(cfRef: IntPtr); external;
  end;


implementation


class method CoreFoundation.CreateString(s: System.String): IntPtr;
begin
// The magic value is "kCFStringENcodingUTF8"
  exit CFStringCreateWithCString(IntPtr.Zero, s, $8000100)
end;

end.

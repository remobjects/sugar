namespace Sugar;

interface

type
  CustomEncoding = public abstract class (System.Text.Encoding)
  private
    method getLookupTable: Sugar.Collections.Dictionary<Char,Byte>;
    var fLookupTable: Sugar.Collections.Dictionary<Char, Byte>;
  private
    class var Encodings: Sugar.Collections.List<CustomEncoding>;
  protected
    property Alphabet: String read; virtual; abstract;
    property LookupTable: Sugar.Collections.Dictionary<Char, Byte> read getLookupTable;
  public
    method GetBytes(chars: array of Char; charIndex: Integer; charCount: Integer; bytes: array of Byte; byteIndex: Integer): Integer; override;
    method GetChars(bytes: array of Byte; byteIndex: Integer; byteCount: Integer; chars: array of Char; charIndex: Integer): Integer; override;
    method GetByteCount(chars: array of Char; &index: Integer; count: Integer): Integer; override;
    method GetCharCount(bytes: array of Byte; &index: Integer; count: Integer): Integer; override;
    method GetMaxByteCount(charCount: Integer): Integer; override;
    method GetMaxCharCount(byteCount: Integer): Integer; override;

    class method ForName(WebName: String): CustomEncoding;
  end;

  ASCIIEncoding = public class (CustomEncoding)
  protected
    property Alphabet: String read #$0#$1#$2#$3#$4#$5#$6#$7#$8#$9#$A#$B#$C#$D#$E#$F#$10#$11#$12#$13#$14#$15#$16#$17#$18#$19#$1A#$1B#$1C#$1D#$1E#$1F#$20#$21#$22#$23#$24#$25#$26#$27#$28#$29#$2A#$2B#$2C#$2D#$2E#$2F#$30#$31#$32#$33#$34#$35#$36#$37#$38#$39#$3A#$3B#$3C#$3D#$3E#$3F#$40#$41#$42#$43#$44#$45#$46#$47#$48#$49#$4A#$4B#$4C#$4D#$4E#$4F#$50#$51#$52#$53#$54#$55#$56#$57#$58#$59#$5A#$5B#$5C#$5D#$5E#$5F#$60#$61#$62#$63#$64#$65#$66#$67#$68#$69#$6A#$6B#$6C#$6D#$6E#$6F#$70#$71#$72#$73#$74#$75#$76#$77#$78#$79#$7A#$7B#$7C#$7D#$7E#$7F; override;
  public
    property WebName: System.String read "US-ASCII"; override;
  end;

  Windows1251Encoding = public class (CustomEncoding)
  protected
    property Alphabet: String read #$0#$1#$2#$3#$4#$5#$6#$7#$8#$9#$A#$B#$C#$D#$E#$F#$10#$11#$12#$13#$14#$15#$16#$17#$18#$19#$1A#$1B#$1C#$1D#$1E#$1F#$20#$21#$22#$23#$24#$25#$26#$27#$28#$29#$2A#$2B#$2C#$2D#$2E#$2F#$30#$31#$32#$33#$34#$35#$36#$37#$38#$39#$3A#$3B#$3C#$3D#$3E#$3F#$40#$41#$42#$43#$44#$45#$46#$47#$48#$49#$4A#$4B#$4C#$4D#$4E#$4F#$50#$51#$52#$53#$54#$55#$56#$57#$58#$59#$5A#$5B#$5C#$5D#$5E#$5F#$60#$61#$62#$63#$64#$65#$66#$67#$68#$69#$6A#$6B#$6C#$6D#$6E#$6F#$70#$71#$72#$73#$74#$75#$76#$77#$78#$79#$7A#$7B#$7C#$7D#$7E#$7F#$402#$403#$201A#$453#$201E#$2026#$2020#$2021#$20AC#$2030#$409#$2039#$40A#$40C#$40B#$40F#$452#$2018#$2019#$201C#$201D#$2022#$2013#$2014#$98#$2122#$459#$203A#$45A#$45C#$45B#$45F#$A0#$40E#$45E#$408#$A4#$490#$A6#$A7#$401#$A9#$404#$AB#$AC#$AD#$AE#$407#$B0#$B1#$406#$456#$491#$B5#$B6#$B7#$451#$2116#$454#$BB#$458#$405#$455#$457#$410#$411#$412#$413#$414#$415#$416#$417#$418#$419#$41A#$41B#$41C#$41D#$41E#$41F#$420#$421#$422#$423#$424#$425#$426#$427#$428#$429#$42A#$42B#$42C#$42D#$42E#$42F#$430#$431#$432#$433#$434#$435#$436#$437#$438#$439#$43A#$43B#$43C#$43D#$43E#$43F#$440#$441#$442#$443#$444#$445#$446#$447#$448#$449#$44A#$44B#$44C#$44D#$44E#$44F; override;
  public
    property WebName: System.String read "Windows-1251"; override;
  end;

  Windows1252Encoding = public class (CustomEncoding)
  protected
    property Alphabet: String read #$0#$1#$2#$3#$4#$5#$6#$7#$8#$9#$A#$B#$C#$D#$E#$F#$10#$11#$12#$13#$14#$15#$16#$17#$18#$19#$1A#$1B#$1C#$1D#$1E#$1F#$20#$21#$22#$23#$24#$25#$26#$27#$28#$29#$2A#$2B#$2C#$2D#$2E#$2F#$30#$31#$32#$33#$34#$35#$36#$37#$38#$39#$3A#$3B#$3C#$3D#$3E#$3F#$40#$41#$42#$43#$44#$45#$46#$47#$48#$49#$4A#$4B#$4C#$4D#$4E#$4F#$50#$51#$52#$53#$54#$55#$56#$57#$58#$59#$5A#$5B#$5C#$5D#$5E#$5F#$60#$61#$62#$63#$64#$65#$66#$67#$68#$69#$6A#$6B#$6C#$6D#$6E#$6F#$70#$71#$72#$73#$74#$75#$76#$77#$78#$79#$7A#$7B#$7C#$7D#$7E#$7F#$20AC#$81#$201A#$192#$201E#$2026#$2020#$2021#$2C6#$2030#$160#$2039#$152#$8D#$17D#$8F#$90#$2018#$2019#$201C#$201D#$2022#$2013#$2014#$2DC#$2122#$161#$203A#$153#$9D#$17E#$178#$A0#$A1#$A2#$A3#$A4#$A5#$A6#$A7#$A8#$A9#$AA#$AB#$AC#$AD#$AE#$AF#$B0#$B1#$B2#$B3#$B4#$B5#$B6#$B7#$B8#$B9#$BA#$BB#$BC#$BD#$BE#$BF#$C0#$C1#$C2#$C3#$C4#$C5#$C6#$C7#$C8#$C9#$CA#$CB#$CC#$CD#$CE#$CF#$D0#$D1#$D2#$D3#$D4#$D5#$D6#$D7#$D8#$D9#$DA#$DB#$DC#$DD#$DE#$DF#$E0#$E1#$E2#$E3#$E4#$E5#$E6#$E7#$E8#$E9#$EA#$EB#$EC#$ED#$EE#$EF#$F0#$F1#$F2#$F3#$F4#$F5#$F6#$F7#$F8#$F9#$FA#$FB#$FC#$FD#$FE#$FF; override;
  public
    property WebName: System.String read "Windows-1252"; override;
  end;

  Windows1253Encoding = public class (CustomEncoding)
  protected
    property Alphabet: String read #$0#$1#$2#$3#$4#$5#$6#$7#$8#$9#$A#$B#$C#$D#$E#$F#$10#$11#$12#$13#$14#$15#$16#$17#$18#$19#$1A#$1B#$1C#$1D#$1E#$1F#$20#$21#$22#$23#$24#$25#$26#$27#$28#$29#$2A#$2B#$2C#$2D#$2E#$2F#$30#$31#$32#$33#$34#$35#$36#$37#$38#$39#$3A#$3B#$3C#$3D#$3E#$3F#$40#$41#$42#$43#$44#$45#$46#$47#$48#$49#$4A#$4B#$4C#$4D#$4E#$4F#$50#$51#$52#$53#$54#$55#$56#$57#$58#$59#$5A#$5B#$5C#$5D#$5E#$5F#$60#$61#$62#$63#$64#$65#$66#$67#$68#$69#$6A#$6B#$6C#$6D#$6E#$6F#$70#$71#$72#$73#$74#$75#$76#$77#$78#$79#$7A#$7B#$7C#$7D#$7E#$7F#$20AC#$81#$201A#$192#$201E#$2026#$2020#$2021#$88#$2030#$8A#$2039#$8C#$8D#$8E#$8F#$90#$2018#$2019#$201C#$201D#$2022#$2013#$2014#$98#$2122#$9A#$203A#$9C#$9D#$9E#$9F#$A0#$385#$386#$A3#$A4#$A5#$A6#$A7#$A8#$A9#$F8F9#$AB#$AC#$AD#$AE#$2015#$B0#$B1#$B2#$B3#$384#$B5#$B6#$B7#$388#$389#$38A#$BB#$38C#$BD#$38E#$38F#$390#$391#$392#$393#$394#$395#$396#$397#$398#$399#$39A#$39B#$39C#$39D#$39E#$39F#$3A0#$3A1#$F8FA#$3A3#$3A4#$3A5#$3A6#$3A7#$3A8#$3A9#$3AA#$3AB#$3AC#$3AD#$3AE#$3AF#$3B0#$3B1#$3B2#$3B3#$3B4#$3B5#$3B6#$3B7#$3B8#$3B9#$3BA#$3BB#$3BC#$3BD#$3BE#$3BF#$3C0#$3C1#$3C2#$3C3#$3C4#$3C5#$3C6#$3C7#$3C8#$3C9#$3CA#$3CB#$3CC#$3CD#$3CE#$F8FB; override;
  public
    property WebName: System.String read "Windows-1253"; override;
  end;

  Windows1254Encoding = public class (CustomEncoding)
  protected
    property Alphabet: String read #$0#$1#$2#$3#$4#$5#$6#$7#$8#$9#$A#$B#$C#$D#$E#$F#$10#$11#$12#$13#$14#$15#$16#$17#$18#$19#$1A#$1B#$1C#$1D#$1E#$1F#$20#$21#$22#$23#$24#$25#$26#$27#$28#$29#$2A#$2B#$2C#$2D#$2E#$2F#$30#$31#$32#$33#$34#$35#$36#$37#$38#$39#$3A#$3B#$3C#$3D#$3E#$3F#$40#$41#$42#$43#$44#$45#$46#$47#$48#$49#$4A#$4B#$4C#$4D#$4E#$4F#$50#$51#$52#$53#$54#$55#$56#$57#$58#$59#$5A#$5B#$5C#$5D#$5E#$5F#$60#$61#$62#$63#$64#$65#$66#$67#$68#$69#$6A#$6B#$6C#$6D#$6E#$6F#$70#$71#$72#$73#$74#$75#$76#$77#$78#$79#$7A#$7B#$7C#$7D#$7E#$7F#$20AC#$81#$201A#$192#$201E#$2026#$2020#$2021#$2C6#$2030#$160#$2039#$152#$8D#$8E#$8F#$90#$2018#$2019#$201C#$201D#$2022#$2013#$2014#$2DC#$2122#$161#$203A#$153#$9D#$9E#$178#$A0#$A1#$A2#$A3#$A4#$A5#$A6#$A7#$A8#$A9#$AA#$AB#$AC#$AD#$AE#$AF#$B0#$B1#$B2#$B3#$B4#$B5#$B6#$B7#$B8#$B9#$BA#$BB#$BC#$BD#$BE#$BF#$C0#$C1#$C2#$C3#$C4#$C5#$C6#$C7#$C8#$C9#$CA#$CB#$CC#$CD#$CE#$CF#$11E#$D1#$D2#$D3#$D4#$D5#$D6#$D7#$D8#$D9#$DA#$DB#$DC#$130#$15E#$DF#$E0#$E1#$E2#$E3#$E4#$E5#$E6#$E7#$E8#$E9#$EA#$EB#$EC#$ED#$EE#$EF#$11F#$F1#$F2#$F3#$F4#$F5#$F6#$F7#$F8#$F9#$FA#$FB#$FC#$131#$15F#$FF; override;
  public
    property WebName: System.String read "Windows-1254"; override;
  end;


implementation

method CustomEncoding.getLookupTable: Sugar.Collections.Dictionary<Char, Byte>;
begin
  if fLookupTable = nil then begin
    var Chars := Alphabet.ToCharArray;
    fLookupTable := new Sugar.Collections.Dictionary<Char,Byte>;
    for i: Integer := 0 to Chars.Length - 1 do
      fLookupTable.Add(Chars[i], i);
  end;

  exit fLookupTable;
end;

method CustomEncoding.GetBytes(chars: array of Char; charIndex: Integer; charCount: Integer; bytes: array of Byte; byteIndex: Integer): Integer;
begin
  SugarArgumentNullException.RaiseIfNil(chars, "Chars");
  SugarArgumentNullException.RaiseIfNil(bytes, "Bytes");

  RangeHelper.Validate(Range.MakeRange(charIndex, charCount), chars.Length);
  RangeHelper.Validate(Range.MakeRange(byteIndex, charCount), bytes.Length);

  var ReplacementByte: Byte := if LookupTable.ContainsKey('?') then LookupTable['?'] else 32;

  for i: Integer := 0 to charCount - 1 do begin
    var CharValue := chars[charIndex + i];
    bytes[byteIndex + i] := if LookupTable.ContainsKey(CharValue) then LookupTable[CharValue] else ReplacementByte;
  end;

  exit charCount;
end;

method CustomEncoding.GetChars(bytes: array of Byte; byteIndex: Integer; byteCount: Integer; chars: array of Char; charIndex: Integer): Integer;
begin
  SugarArgumentNullException.RaiseIfNil(chars, "Chars");
  SugarArgumentNullException.RaiseIfNil(bytes, "Bytes");

  RangeHelper.Validate(Range.MakeRange(byteIndex, byteCount), bytes.Length);
  RangeHelper.Validate(Range.MakeRange(charIndex, byteCount), chars.Length);

  var Alpha := Alphabet.ToCharArray;
  for i: Integer := 0 to byteCount - 1 do begin
    var ByteValue := bytes[byteIndex + i];

    if ByteValue >= Alpha.Length then
      chars[charIndex + i] := '?'
    else
      chars[charIndex + i] := Alpha[ByteValue];
  end;

  exit byteCount;
end;

method CustomEncoding.GetByteCount(chars: array of Char; &index: Integer; count: Integer): Integer;
begin
  exit count;
end;

method CustomEncoding.GetCharCount(bytes: array of Byte; &index: Integer; count: Integer): Integer;
begin
  exit count;
end;

method CustomEncoding.GetMaxByteCount(charCount: Integer): Integer;
begin
  exit charCount;
end;

method CustomEncoding.GetMaxCharCount(byteCount: Integer): Integer;
begin
  exit byteCount;
end;

class method CustomEncoding.ForName(WebName: String): CustomEncoding;
begin
  if Encodings = nil then begin
    Encodings := new Sugar.Collections.List<CustomEncoding>;

    var lTypes := System.Reflection.&Assembly.GetExecutingAssembly.GetTypes;
    for i: Integer := 0 to lTypes.Length - 1 do begin
      if lTypes[i].IsSubclassOf(typeOf(CustomEncoding)) then
        Encodings.Add(Activator.CreateInstance(lTypes[i]) as CustomEncoding);
    end;
  end;

  exit Encodings.Find(item -> item.WebName.Equals(WebName, StringComparison.InvariantCultureIgnoreCase));
end;

end.
namespace Sugar;

interface

type
  PlatformString = public {$IF ECHOES}System.String{$ELSEIF TOFFEE}Foundation.NSString{$ELSEIF COOPER}java.lang.String{$ELSEIF ISLAND}RemObjects.Elements.System.String{$ENDIF};

  [assembly:DefaultStringType("Sugar", typeOf(Sugar.String))]

  String = public class mapped to {$IF COOPER}java.lang.String{$ELSEIF ECHOES}System.String{$ELSEIF TOFFEE}Foundation.NSString{$ENDIF}
  private
    method get_Chars(aIndex: Int32): Char;
    class method Compare(Value1, Value2: String): Integer;
  public
    constructor(Value: array of Byte; Encoding: Encoding := nil);
    constructor(Value: array of Char);
    constructor(Value: array of Char; Offset: Integer; Count: Integer);
    constructor(aChar: Char; aCount: Integer);

    class operator &Add(Value1: String; Value2: String): not nullable String;
    class operator &Add(Value1: String; Value2: Object): not nullable String;
    class operator &Add(Value1: Object; Value2: String): not nullable String;
    class operator Implicit(Value: Char): String;
    class operator Greater(Value1, Value2: String): Boolean;
    class operator Less(Value1, Value2: String): Boolean;
    class operator GreaterOrEqual(Value1, Value2: String): Boolean;
    class operator LessOrEqual(Value1, Value2: String): Boolean;
    class operator Equal(Value1, Value2: String): Boolean;
    class operator NotEqual(Value1, Value2: String): Boolean;

    class method Format(aFormat: String; params aParams: array of Object): not nullable String;    
    class method CharacterIsWhiteSpace(Value: Char): Boolean;
    class method IsNullOrEmpty(Value: String): Boolean;
    class method IsNullOrWhiteSpace(Value: String): Boolean;
    class method &Join(Separator: String; Values: array of String): String; 

    method CompareTo(Value: String): Integer;
    method CompareToIgnoreCase(Value: String): Integer;
    method &Equals(Value: String): Boolean;
    method EqualsIgnoringCase(Value: String): Boolean;
    method EqualsIgnoringCaseInvariant(Value: String): Boolean;

    class method &Equals(ValueA: String; ValueB: String): Boolean;
    class method EqualsIgnoringCase(ValueA: String; ValueB: String): Boolean;
    class method EqualsIgnoringCaseInvariant(ValueA: String; ValueB: String): Boolean;

    method Contains(Value: String): Boolean;
    method IndexOf(Value: Char): Int32; inline;
    method IndexOf(Value: String): Int32; inline;
    method IndexOf(Value: Char; StartIndex: Integer): Integer; 
    method IndexOf(Value: String; StartIndex: Integer): Integer; 
    method IndexOfAny(const AnyOf: array of Char): Integer; 
    method IndexOfAny(const AnyOf: array of Char; StartIndex: Integer): Integer;     
    method LastIndexOf(Value: Char): Integer;
    method LastIndexOf(Value: String): Int32;
    method LastIndexOf(Value: Char; StartIndex: Integer): Integer; 
    method LastIndexOf(const Value: String; StartIndex: Integer): Integer; 
    method Substring(StartIndex: Int32): not nullable String;
    method Substring(StartIndex: Int32; aLength: Int32): not nullable String;
    method Split(Separator: String): array of String;
    method Replace(OldValue, NewValue: String): not nullable String;
    method PadStart(TotalWidth: Integer): String; inline; 
    method PadStart(TotalWidth: Integer; PaddingChar: Char): String; 
    method PadEnd(TotalWidth: Integer): String; inline; 
    method PadEnd(TotalWidth: Integer; PaddingChar: Char): String;     
    method ToLower: not nullable String;
    method ToLowerInvariant: not nullable String;
    method ToLower(aLocale: Locale): not nullable String;
    method ToUpper: not nullable String;
    method ToUpperInvariant: not nullable String;
    method ToUpper(aLocale: Locale): not nullable String;
    method Trim: not nullable String;
    method TrimEnd: not nullable String; inline; 
    method TrimStart: not nullable String; inline; 
    method Trim(const TrimChars: array of Char): not nullable String; 
    method TrimEnd(const TrimChars: array of Char): not nullable String; 
    method TrimStart(const TrimChars: array of Char): not nullable String; 
    method StartsWith(Value: String): Boolean; inline;
    method StartsWith(Value: String; IgnoreCase: Boolean): Boolean; 
    method EndsWith(Value: String): Boolean; inline;
    method EndsWith(Value: String; IgnoreCase: Boolean): Boolean; 
    method ToByteArray: array of Byte;
    method ToByteArray(aEncoding: {not nullable} Encoding): array of Byte;
    method ToCharArray: array of Char;

    property Length: Int32 read mapped.Length;
    property Chars[aIndex: Int32]: Char read get_Chars; default;
  end;

implementation

constructor String(Value: array of Byte; Encoding: Encoding := nil);
begin
  if Value = nil then
    raise new SugarArgumentNullException("Value");

  if Encoding = nil then
    Encoding := Encoding.Default;
    
  exit Encoding.GetString(Value);
end;

constructor String(Value: array of Char);
begin
  if Value = nil then
    raise new SugarArgumentNullException("Value");

  {$IF COOPER}
  exit new java.lang.String(Value);
  {$ELSEIF ECHOES}
  exit new System.String(Value);
  {$ELSEIF TOFFEE}
  exit new Foundation.NSString withCharacters(Value) length(length(Value));
  {$ENDIF}
end;

constructor String(Value: array of Char; Offset: Integer; Count: Integer);
begin
  if Value = nil then
    raise new SugarArgumentNullException("Value");

  if Count = 0 then
    exit "";

  RangeHelper.Validate(Range.MakeRange(Offset, Count), Value.Length);

  {$IF COOPER}
  exit new java.lang.String(Value, Offset, Count);
  {$ELSEIF ECHOES}
  exit new System.String(Value, Offset, Count);
  {$ELSEIF TOFFEE}
  exit new Foundation.NSString withCharacters(@Value[Offset]) length(Count);
  {$ENDIF}
end;

constructor String(aChar: Char; aCount: Integer);
begin
  {$IF COOPER}
  var chars := new Char[aCount];
  for i: Integer := 0 to aCount-1 do
    chars[i] := aChar;
  result := new java.lang.String(chars);
  {$ELSEIF ECHOES}
  result := new System.String(aChar, aCount);
  {$ELSEIF TOFFEE}
  result := Foundation.NSString("").stringByPaddingToLength(aCount) withString(Foundation.NSString.stringWithFormat("%c", aChar)) startingAtIndex(0);
  {$ENDIF}
end;

method String.get_Chars(aIndex: Int32): Char;
begin
  if aIndex < 0 then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.NEGATIVE_VALUE_ERROR, "Index");

  {$IF COOPER}
  result := mapped.charAt(aIndex);
  {$ELSEIF ECHOES}
  result := mapped[aIndex];
  {$ELSEIF TOFFEE}
  result := mapped.characterAtIndex(aIndex);
  {$ENDIF}
end;

class operator String.Add(Value1: String; Value2: String): not nullable String;
begin
  {$IF COOPER}
  result := (java.lang.String(Value1)+java.lang.String(Value2)) as not nullable;
  {$ELSEIF ECHOES}
  result := (System.String(Value1)+System.String(Value2)) as not nullable;
  {$ELSEIF TOFFEE}
  result := (NSString(Value1) + NSString(Value2)) as not nullable;
  {$ENDIF}
end;

class operator String.Add(Value1: String; Value2: Object): not nullable String;
begin
  result := (Value1 + coalesce(Value2, "").ToString) as not nullable;
end;

class operator String.Add(Value1: Object; Value2: String): not nullable String;
begin
  result := (coalesce(Value1, "").ToString + Value2) as not nullable;
end;

class operator String.Implicit(Value: Char): String;
begin
  {$IF COOPER}
  exit new java.lang.String(Value);
  {$ELSEIF ECHOES}
  exit new System.String(Value, 1);
  {$ELSEIF TOFFEE}
  if Value = #0 then
    exit NSString.stringWithFormat(#0) as not nullable;

  exit NSString.stringWithFormat("%c", Value) as not nullable;
  {$ENDIF}
end;

class method String.Compare(Value1: String; Value2: String): Integer;
begin
  var First := {$IF COOPER}java.lang.String{$ELSEIF ECHOES}System.String{$ELSEIF TOFFEE}Foundation.NSString{$ENDIF}(Value1);
  var Second := {$IF COOPER}java.lang.String{$ELSEIF ECHOES}System.String{$ELSEIF TOFFEE}Foundation.NSString{$ENDIF}(Value2);

  if (First = nil) and (Second = nil) then
    exit 0;

  if not assigned(First) then
    exit -1;

  if not assigned(Second) then
    exit 1;

  exit {$IF COOPER}First.compareTo(Second){$ELSEIF ECHOES}First.CompareTo(Second){$ELSEIF TOFFEE}First.compare(Second){$ENDIF};
end;

class operator String.Equal(Value1: String; Value2: String): Boolean;
begin
  var First := {$IF COOPER}java.lang.String{$ELSEIF ECHOES}System.String{$ELSEIF TOFFEE}Foundation.NSString{$ENDIF}(Value1);
  var Second := {$IF COOPER}java.lang.String{$ELSEIF ECHOES}System.String{$ELSEIF TOFFEE}Foundation.NSString{$ENDIF}(Value2);

  if (First = nil) and (Second = nil) then
    exit true;

  if (First = nil) or (Second = nil) then
    exit false;

  exit {$IF COOPER}First.compareTo(Second){$ELSEIF ECHOES}First.CompareTo(Second){$ELSEIF TOFFEE}First.compare(Second){$ENDIF} = 0;  
end;

class operator String.NotEqual(Value1: String; Value2: String): Boolean;
begin
  exit Compare(Value1, Value2) <> 0;
end;

class operator String.Greater(Value1: String; Value2: String): Boolean;
begin
  exit Compare(Value1, Value2) > 0;
end;

class operator String.Less(Value1: String; Value2: String): Boolean;
begin
  exit Compare(Value1, Value2) < 0;
end;

class operator String.GreaterOrEqual(Value1: String; Value2: String): Boolean;
begin
  exit Compare(Value1, Value2) >= 0;
end;

class operator String.LessOrEqual(Value1: String; Value2: String): Boolean;
begin
  exit Compare(Value1, Value2) <= 0;
end;

class method String.Format(aFormat: String; params aParams: array of Object): not nullable String;
begin
  exit StringFormatter.FormatString(aFormat, aParams);
end;

class method String.CharacterIsWhiteSpace(Value: Char): Boolean;
begin
  {$IF COOPER}
  result := java.lang.Character.isWhitespace(Value);
  {$ELSEIF ECHOES}
  result := Char.IsWhiteSpace(Value);
  {$ELSEIF TOFFEE}
  result := Foundation.NSCharacterSet.whitespaceAndNewlineCharacterSet.characterIsMember(Value);
  {$ENDIF}
end;

class method String.IsNullOrEmpty(Value: String): Boolean;
begin
  exit (Value = nil) or (Value.Length = 0);
end;

class method String.IsNullOrWhiteSpace(Value: String): Boolean;
begin
  if Value = nil then
    exit true;

  for i: Integer := 0 to Value.Length-1 do
    if not CharacterIsWhiteSpace(Value.Chars[i]) then
      exit false;

  exit true;
end;

method String.CompareTo(Value: String): Integer;
begin
  if Value = nil then
    exit 1;

  {$IF COOPER}
  exit mapped.compareTo(Value);
  {$ELSEIF ECHOES}
  exit mapped.Compare(mapped, Value, StringComparison.Ordinal);
  {$ELSEIF TOFFEE}
  exit mapped.compare(Value);
  {$ENDIF}
end;

method String.CompareToIgnoreCase(Value: String): Integer;
begin
  {$IF COOPER}
  exit mapped.compareToIgnoreCase(Value);
  {$ELSEIF ECHOES}
  exit mapped.Compare(mapped, Value, StringComparison.OrdinalIgnoreCase);
  {$ELSEIF TOFFEE}
  exit mapped.caseInsensitiveCompare(Value);
  {$ENDIF}
end;

method String.Equals(Value: String): Boolean;
begin
  {$IF COOPER}
  exit mapped.equals(Value); {$HINT needs to take locale into account!}
  {$ELSEIF ECHOES}
  exit mapped.Equals(Value, StringComparison.Ordinal);
  {$ELSEIF TOFFEE}
  exit mapped.compare(Value) = 0;
  {$ENDIF}
end;

method String.EqualsIgnoringCase(Value: String): Boolean;
begin
  {$IF COOPER}
  exit mapped.equalsIgnoreCase(Value); {$HINT needs to take locale into account!}
  {$ELSEIF ECHOES}
  exit mapped.Equals(Value, StringComparison.OrdinalIgnoreCase);
  {$ELSEIF TOFFEE}
  exit mapped.caseInsensitiveCompare(Value) = 0;
  {$ENDIF}
end;

method String.EqualsIgnoringCaseInvariant(Value: String): Boolean;
begin
  {$IF COOPER}
  exit mapped.equalsIgnoreCase(Value); // aready invariant, on Java
  {$ELSEIF ECHOES}
  {$IF WINDOWS_PHONE OR NETFX_CORE}
  exit mapped.Equals(Value, StringComparison.OrdinalIgnoreCase); {$HINT TODO}
  {$ELSE}
  exit mapped.Equals(Value, StringComparison.InvariantCultureIgnoreCase);
  {$ENDIF}
  {$ELSEIF TOFFEE}
  // RemObjects.Elements.System.length as workaround for issue in 8.3; not needed in 8.4
  exit mapped.compare(Value) options(NSStringCompareOptions.CaseInsensitiveSearch) range(NSMakeRange(0, RemObjects.Elements.System.length(self))) locale(Locale.Invariant) = 0;
  {$ENDIF}
end;

class method String.Equals(ValueA: String; ValueB: String): Boolean;
begin
  if ValueA = ValueB then exit true;
  if (ValueA = nil) or (ValueB = nil) then exit false;
  result := ValueA.Equals(ValueB);
end;

class method String.EqualsIgnoringCase(ValueA: String; ValueB: String): Boolean;
begin
  if ValueA = ValueB then exit true;
  if (ValueA = nil) or (ValueB = nil) then exit false;
  result := ValueA.EqualsIgnoringCase(ValueB);
end;

class method String.EqualsIgnoringCaseInvariant(ValueA: String; ValueB: String): Boolean;
begin
  if ValueA = ValueB then exit true;
  if (ValueA = nil) or (ValueB = nil) then exit false;
  result := ValueA.EqualsIgnoringCaseInvariant(ValueB);
end;

method String.Contains(Value: String): Boolean;
begin
  if Value.Length = 0 then
    exit true;

  {$IF COOPER OR ECHOES}
  exit mapped.Contains(Value);
  {$ELSEIF TOFFEE}
  exit mapped.rangeOfString(Value).location <> NSNotFound;
  {$ENDIF}
end;

method String.IndexOf(Value: Char): Int32;
begin
  result := IndexOf(Value, 0);
end;

method String.IndexOf(Value: String): Int32;
begin
  result := IndexOf(Value, 0);
end;

method String.IndexOf(Value: Char; StartIndex: Integer): Integer;
begin
  {$IF COOPER OR ECHOES}
  result := mapped.indexOf(Value, StartIndex);
  {$ELSEIF TOFFEE}
  result := IndexOf(NSString.stringWithFormat("%c", Value), StartIndex);
  {$ENDIF}
end;

method String.IndexOf(Value: String; StartIndex: Integer): Integer;
begin
  if Value = nil then
    raise new SugarArgumentNullException("Value");

  if Value.Length = 0 then
    exit 0;

  {$IF COOPER OR ECHOES}
  result := mapped.indexOf(Value, StartIndex);
  {$ELSEIF TOFFEE}
  var r := mapped.rangeOfString(Value) options(NSStringCompareOptions.NSLiteralSearch) range(NSMakeRange(StartIndex, mapped.length - StartIndex));
  result := if r.location = NSNotFound then -1 else r.location;
  {$ENDIF}
end;

method String.IndexOfAny(const AnyOf: array of Char): Integer; 
begin
  {$IF COOPER OR TOFFEE}
  result := IndexOfAny(AnyOf, 0);
  {$ELSEIF ECHOES}
  result := mapped.IndexOfAny(AnyOf);
  {$ENDIF}
end;

method String.IndexOfAny(const AnyOf: array of Char; StartIndex: Integer): Integer; 
begin
  {$IF COOPER}
  for i: Integer := StartIndex to mapped.length - 1 do begin
     for each c: Char in AnyOf do begin
       if mapped.charAt(i) = c then
         exit i;
     end;
  end;
  result := -1;
  {$ELSEIF ECHOES}
  result := mapped.IndexOfAny(AnyOf, StartIndex);
  {$ELSEIF TOFFEE}
  var lChars := NSCharacterSet.characterSetWithCharactersInString(new Foundation.NSString withCharacters(AnyOf) length(AnyOf.length));
  var r := mapped.rangeOfCharacterFromSet(lChars) options(NSStringCompareOptions.NSLiteralSearch) range(NSMakeRange(StartIndex, mapped.length - StartIndex));
  result := if r.location = NSNotFound then -1 else r.location;
  {$ENDIF}
end;

method String.LastIndexOf(Value: Char): Integer;
begin
  {$IF COOPER OR ECHOES}
  result := mapped.lastIndexOf(Value);
  {$ELSEIF TOFFEE}
  result := LastIndexOf(NSString.stringWithFormat("%c", Value));
  {$ENDIF}
end;

method String.LastIndexOf(Value: String): Int32;
begin
  if Value = nil then
    raise new SugarArgumentNullException("Value");

  if Value.Length = 0 then
    exit mapped.length - 1;

  {$IF COOPER OR ECHOES}
  exit mapped.LastIndexOf(Value);
  {$ELSEIF TOFFEE}
  var r := mapped.rangeOfString(Value) options(NSStringCompareOptions.NSBackwardsSearch);
  exit if (r.location = NSNotFound) and (r.length = 0) then -1 else Int32(r.location);
  {$ENDIF}
end;

method String.LastIndexOf(Value: Char; StartIndex: Integer): Integer;
begin
  {$IF COOPER OR ECHOES}
  result := mapped.lastIndexOf(Value, StartIndex);
  {$ELSEIF TOFFEE}
  result := LastIndexOf(NSString.stringWithFormat("%c", Value), StartIndex);
  {$ENDIF}
end;

method String.LastIndexOf(const Value: String; StartIndex: Integer): Integer;
begin
  {$IF COOPER OR ECHOES}
  result := mapped.lastIndexOf(Value, StartIndex);
  if (result = StartIndex) and (Value.Length > 1) then
    result := -1;
  {$ELSEIF TOFFEE}
  var r:= mapped.rangeOfString(Value) options(NSStringCompareOptions.NSLiteralSearch or NSStringCompareOptions.NSBackwardsSearch) range(NSMakeRange(0, StartIndex + 1));
  exit if (r.location = NSNotFound) and (r.length = 0) then -1 else Int32(r.location);  
  {$ENDIF}  
end;

method String.Substring(StartIndex: Int32): not nullable String;
begin
  if (StartIndex < 0) then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.NEGATIVE_VALUE_ERROR, "StartIndex");

  {$IF COOPER OR ECHOES}
  exit mapped.Substring(StartIndex) as not nullable;
  {$ELSEIF TOFFEE}
  exit mapped.substringFromIndex(StartIndex) as not nullable;
  {$ENDIF}
end;

method String.Substring(StartIndex: Int32; aLength: Int32): not nullable String;
begin
  if (StartIndex < 0) or (aLength < 0) then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.NEGATIVE_VALUE_ERROR, "StartIndex and Length");

  {$IF COOPER}
  exit mapped.substring(StartIndex, StartIndex + aLength) as not nullable;
  {$ELSEIF ECHOES}
  exit mapped.Substring(StartIndex, aLength) as not nullable;
  {$ELSEIF TOFFEE}
  result := mapped.substringWithRange(Foundation.NSMakeRange(StartIndex, aLength));
  {$ENDIF}
end;

method String.Split(Separator: String): array of String;
begin
  if IsNullOrEmpty(Separator) then
    exit [mapped];

  {$IF COOPER}  
  exit mapped.split(java.util.regex.Pattern.quote(Separator));
  {$ELSEIF ECHOES}
  exit mapped.Split([Separator], StringSplitOptions.None);
  {$ELSEIF TOFFEE}
  var Items := mapped.componentsSeparatedByString(Separator);
  result := new String[Items.count];
  for i: Integer := 0 to Items.count - 1 do
    result[i] := Items.objectAtIndex(i);
  {$ENDIF}
end;

method String.Replace(OldValue: String; NewValue: String): not nullable String;
begin
  if IsNullOrEmpty(OldValue) then
    raise new SugarArgumentNullException("OldValue");

  if NewValue = nil then
    NewValue := "";
  {$IF COOPER OR ECHOES}
  exit mapped.Replace(OldValue, NewValue) as not nullable;
  {$ELSEIF TOFFEE}
  exit mapped.stringByReplacingOccurrencesOfString(OldValue) withString(NewValue);
  {$ENDIF}
end;

{$IF COOPER}
function StringOfChar(Value: Char; Count: Integer): String;
begin
  var sb := new StringBuilder(Count);
  for i: Integer := 0 to Count - 1 do
    sb.append(Value);
  
  result := sb.toString;
end;
{$ENDIF}

method String.PadStart(TotalWidth: Integer): String;
begin
  result := PadStart(TotalWidth, ' ');
end;

method String.PadStart(TotalWidth: Integer; PaddingChar: Char): String;
begin
  {$IF COOPER}
  var lTotal := TotalWidth - mapped.length;
  if lTotal < 0 then
    result := self
  else
    result := StringOfChar(PaddingChar, lTotal) + self;
  {$ELSEIF ECHOES}
  result := mapped.PadLeft(TotalWidth, PaddingChar);
  {$ELSEIF TOFFEE}
  var lTotal: Integer := TotalWidth - mapped.length;
  if lTotal > 0 then begin
    var lChars := NSString.stringWithFormat("%c", PaddingChar);
    lChars := lChars.stringByPaddingToLength(lTotal) withString(PaddingChar) startingAtIndex(0);
    result := lChars + self;
  end
  else
    result := self;
  {$ENDIF}
end;

method String.PadEnd(TotalWidth: Integer): String;
begin
  result := PadEnd(TotalWidth, ' ');
end;

method String.PadEnd(TotalWidth: Integer; PaddingChar: Char): String;
begin
  {$IF COOPER}
  var lTotal := TotalWidth - mapped.length;
  if lTotal < 0 then
    result := self
  else
    result := self + StringOfChar(PaddingChar, lTotal);
  {$ELSEIF ECHOES}
  result := mapped.PadRight(TotalWidth, PaddingChar);
  {$ELSEIF TOFFEE}
  result := mapped.stringByPaddingToLength(TotalWidth) withString(PaddingChar) startingAtIndex(0);
  {$ENDIF}
end;

method String.ToLower: not nullable String;
begin
  {$IF COOPER}
  exit mapped.toLowerCase(Locale.Current) as not nullable;
  {$ELSEIF ECHOES}
  exit mapped.ToLower as not nullable;
  {$ELSEIF TOFFEE}
  exit mapped.lowercaseString;
  {$ENDIF}
end;

method String.ToLowerInvariant: not nullable String;
begin
  {$IF COOPER}
  exit mapped.toLowerCase(Locale.Invariant) as not nullable;
  {$ELSEIF ECHOES}
  exit mapped.ToLowerInvariant as not nullable;
  {$ELSEIF TOFFEE}
  exit mapped.lowercaseStringWithLocale(Locale.Invariant);
  {$ENDIF}
end;

method String.ToLower(aLocale: Locale): not nullable String;
begin
  {$IF COOPER}
  exit mapped.toLowerCase(aLocale) as not nullable;
  {$ELSEIF ECHOES}
  {$IF WINDOWS_PHONE OR NETFX_CORE}
  exit mapped.ToLower as not nullable; {$HINT TODO}
  {$ELSE}
  exit mapped.ToLower(aLocale) as not nullable;
  {$ENDIF}
  {$ELSEIF TOFFEE}
  exit mapped.lowercaseStringWithLocale(aLocale);
  {$ENDIF}
end;

method String.ToUpper: not nullable String;
begin
  {$IF COOPER}
  exit mapped.toUpperCase(Locale.Current) as not nullable;
  {$ELSEIF ECHOES}
  exit mapped.ToUpper as not nullable;
  {$ELSEIF TOFFEE}
  exit mapped.uppercaseString;
  {$ENDIF}
end;

method String.ToUpperInvariant: not nullable String;
begin
  {$IF COOPER}
  exit mapped.toUpperCase(Locale.Invariant) as not nullable;
  {$ELSEIF ECHOES}
  exit mapped.ToUpperInvariant as not nullable;
  {$ELSEIF TOFFEE}
  exit mapped.uppercaseStringWithLocale(Locale.Invariant);
  {$ENDIF}
end;

method String.ToUpper(aLocale: Locale): not nullable String;
begin
  {$IF COOPER}
  exit mapped.toUpperCase(aLocale) as not nullable;
  {$ELSEIF ECHOES}
  {$IF WINDOWS_PHONE OR NETFX_CORE}
  exit mapped.ToUpper as not nullable; {$HINT TODO}
  {$ELSE}
  exit mapped.ToUpper(aLocale) as not nullable;
  {$ENDIF}
  {$ELSEIF TOFFEE}
  exit mapped.uppercaseStringWithLocale(aLocale);
  {$ENDIF}
end;

method String.Trim: not nullable String;
begin
  {$IF COOPER}
  result := mapped.trim() as not nullable; // trims #$00-#$20
  {$ELSEIF ECHOES}
  result := mapped.Trim() as not nullable; // Trim() does include CR/LF and Unicode whitespace
  {$ELSEIF TOFFEE}
  result := mapped.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet);
  {$ENDIF}
end;

method String.TrimEnd: not nullable String;
begin
  result := TrimEnd([' ']);
end;

method String.TrimStart: not nullable String;
begin
  result := TrimStart([' ']);
end;

method String.Trim(const TrimChars: array of Char): not nullable String;
begin
  {$IF COOPER}
  var lStr := TrimStart(TrimChars);
  result := lStr.TrimEnd(TrimChars);
  {$ELSEIF ECHOES}
  result := mapped.Trim(TrimChars) as not nullable;
  {$ELSEIF TOFFEE}
  result := mapped.stringByTrimmingCharactersInSet(NSCharacterSet.characterSetWithCharactersInString(new Foundation.NSString withCharacters(TrimChars) length(TrimChars.length)));
  {$ENDIF}
end;

{$IF COOPER}
function CharIsAnyOf(Value: Char; AnyOf: array of Char): Boolean;
begin
  for each c: Char in AnyOf do
    if c = Value then
      exit true;

  result := false;
end;
{$ENDIF}

method String.TrimEnd(const TrimChars: array of Char): not nullable String;
begin
  {$IF COOPER}
  if (self = nil) or (mapped.length = 0) then
    exit self;
  var i: Integer := mapped.length - 1;
  while (i >= 0) and CharIsAnyOf(mapped.charAt(i), TrimChars) do
    dec(i);

  result := mapped.substring(0, i + 1) as not nullable;
  {$ELSEIF ECHOES}
  result := mapped.TrimEnd(TrimChars) as not nullable;
  {$ELSEIF TOFFEE}
  var lCharacters := NSCharacterSet.characterSetWithCharactersInString(new Foundation.NSString withCharacters(TrimChars) length(TrimChars.length));
  var lLastWanted := mapped.rangeOfCharacterFromSet(lCharacters.invertedSet) options(NSStringCompareOptions.NSBackwardsSearch);                                                               
  result := if lLastWanted.location = NSNotFound then self else mapped.substringToIndex(lLastWanted.location + 1) as not nullable;
  {$ENDIF}
end;

method String.TrimStart(const TrimChars: array of Char): not nullable String;
begin
  {$IF COOPER}
  if (self = nil) or (mapped.length = 0) then
    exit self;
  var i: Integer := 0;
  while (i <= mapped.length) and CharIsAnyOf(mapped.charAt(i), TrimChars) do
    inc(i);

  result := mapped.substring(i) as not nullable;
  {$ELSEIF ECHOES}
  result := mapped.TrimStart(TrimChars) as not nullable;
  {$ELSEIF TOFFEE}
  var lCharacters := NSCharacterSet.characterSetWithCharactersInString(new Foundation.NSString withCharacters(TrimChars) length(TrimChars.length));
  var lFirstWanted := mapped.rangeOfCharacterFromSet(lCharacters.invertedSet);  
  result := if lFirstWanted.location = NSNotFound then self else mapped.substringFromIndex(lFirstWanted.location);
  {$ENDIF}
end;

method String.StartsWith(Value: String): Boolean;
begin
  result := StartsWith(Value, False);
end;

method String.StartsWith(Value: String; IgnoreCase: Boolean): Boolean;
begin
   if Value.Length = 0 then
    exit true;

  {$IF COOPER}
  if IgnoreCase then
    result := mapped.regionMatches(IgnoreCase, 0, Value, 0, Value.length)
  else
    result := mapped.StartsWith(Value);  
  {$ELSEIF ECHOES}
  if IgnoreCase then
    result := mapped.StartsWith(Value, StringComparison.OrdinalIgnoreCase)
  else 
    result := mapped.StartsWith(Value);
  {$ELSEIF TOFFEE}
  if Value.Length > mapped.length then
    result := false
  else begin
    if IgnoreCase then
      result := (mapped.compare(Value) options(NSStringCompareOptions.NSCaseInsensitiveSearch) range(NSMakeRange(0, Value.length)) = NSComparisonResult.NSOrderedSame)
    else
      result := mapped.hasPrefix(Value);   
  end;
  {$ENDIF}
end;

method String.EndsWith(Value: String): Boolean;
begin
  result := EndsWith(Value, False);
end;

method String.EndsWith(Value: String; IgnoreCase: Boolean): Boolean;
begin
  if Value.Length = 0 then
    exit true;

  {$IF COOPER}
  if IgnoreCase then
    result := mapped.toUpperCase.endsWith(PlatformString(Value).toUpperCase)
  else
    result := mapped.endsWith(Value);
  {$ELSEIF ECHOES}
  if IgnoreCase then
    result := mapped.EndsWith(Value, StringComparison.OrdinalIgnoreCase)
  else
    result := mapped.EndsWith(Value);
  {$ELSEIF TOFFEE}
  if Value.Length > mapped.length then
    result := false
  else begin
    if IgnoreCase then
      result := (mapped.compare(Value) options(NSStringCompareOptions.NSCaseInsensitiveSearch) range(NSMakeRange(mapped.length - Value.length, Value.length)) = NSComparisonResult.NSOrderedSame)
    else
      result := mapped.hasSuffix(Value);
  end;
  {$ENDIF}
end;

method String.ToCharArray: array of Char;
begin
  {$IF COOPER}
  exit mapped.ToCharArray;
  {$ELSEIF ECHOES}
  exit mapped.ToCharArray;
  {$ELSEIF TOFFEE}
  result := new Char[mapped.length];
  mapped.getCharacters(result) range(NSMakeRange(0, mapped.length));
  {$ENDIF}
end;

method String.ToByteArray: array of Byte;
begin
  {$IF COOPER}
  exit mapped.getBytes("UTF-8");
  {$ELSEIF ECHOES}
  exit System.Text.Encoding.UTF8.GetBytes(mapped);
  {$ELSEIF TOFFEE}
  var Data := Binary(mapped.dataUsingEncoding(NSStringEncoding.NSUTF8StringEncoding));
  exit Data.ToArray;
  {$ENDIF}
end;

method String.ToByteArray(aEncoding: {not nullable} Encoding): array of Byte;
begin
  result := aEncoding.GetBytes(self);
end;

class method String.Join(Separator: String; Values: array of String): String;
begin
  {$IF COOPER}
  var sb := new StringBuilder;
  for i: Integer := 0 to Values.length - 1 do begin
     if i <> 0 then
      sb.append(Separator);
    sb.append(Values[i]);
  end;
  result := sb.toString;
  {$ELSEIF ECHOES}
  result := System.String.Join(Separator, Values);
  {$ELSEIF TOFFEE}
  var lArray := new NSMutableArray withCapacity(Values.length);
  for i: Integer := 0 to Values.length - 1 do
    lArray.addObject(Values[i]);

  result := lArray.componentsJoinedByString(Separator);
  {$ENDIF}
end;

end.

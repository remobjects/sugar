namespace Sugar;

interface

type
  String = public class mapped to {$IF COOPER}java.lang.String{$ELSEIF ECHOES}System.String{$ELSEIF TOFFEE}Foundation.NSString{$ENDIF}
  private
    method get_Chars(aIndex: Int32): Char;
    class method Compare(Value1, Value2: String): Integer;
  public
    constructor(Value: array of Byte; Encoding: Encoding := nil);
    constructor(Value: array of Char);
    constructor(Value: array of Char; Offset: Integer; Count: Integer);
    constructor(aChar: Char; aCount: Integer);

    class operator Add(Value1: String; Value2: String): not nullable String;
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

    method CompareTo(Value: String): Integer;
    method CompareToIgnoreCase(Value: String): Integer;
    method &Equals(Value: String): Boolean;
    method EqualsIgnoreCase(Value: String): Boolean;
    method Contains(Value: String): Boolean;
    method IndexOf(Value: String): Int32;
    method LastIndexOf(Value: String): Int32;
    method Substring(StartIndex: Int32): not nullable String;
    method Substring(StartIndex: Int32; aLength: Int32): not nullable String;
    method Split(Separator: String): array of String;
    method Replace(OldValue, NewValue: String): not nullable String;
    method ToLower: not nullable String;
    method ToUpper: not nullable String;
    method Trim: not nullable String;
    //method Trim(aCharacters: array of Char): not nullable String;
    method StartsWith(Value: String): Boolean;
    method EndsWith(Value: String): Boolean;
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
  exit mapped.equals(Value);
  {$ELSEIF ECHOES}
  exit mapped.Equals(Value, StringComparison.Ordinal);
  {$ELSEIF TOFFEE}
  exit mapped.compare(Value) = 0;
  {$ENDIF}
end;

method String.EqualsIgnoreCase(Value: String): Boolean;
begin
  {$IF COOPER}
  exit mapped.equalsIgnoreCase(Value);
  {$ELSEIF ECHOES}
  exit mapped.Equals(Value, StringComparison.OrdinalIgnoreCase);
  {$ELSEIF TOFFEE}
  exit mapped.caseInsensitiveCompare(Value) = 0;
  {$ENDIF}
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

method String.IndexOf(Value: String): Int32;
begin
  if Value = nil then
    raise new SugarArgumentNullException("Value");

  if Value.Length = 0 then
    exit 0;

  {$IF COOPER OR ECHOES}
  exit mapped.IndexOf(Value);
  {$ELSEIF TOFFEE}
  var r := mapped.rangeOfString(Value);
  exit if (r.location = NSNotFound) and (r.length = 0) then -1 else Int32(r.location);
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

method String.Substring(StartIndex: Int32): not nullable String;
begin
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

method String.ToLower: not nullable String;
begin
  {$IF COOPER}
  exit mapped.toLowerCase as not nullable;
  {$ELSEIF ECHOES}
  exit mapped.ToLower as not nullable;
  {$ELSEIF TOFFEE}
  exit mapped.lowercaseString;
  {$ENDIF}
end;

method String.ToUpper: not nullable String;
begin
  {$IF COOPER}
  exit mapped.toUpperCase as not nullable;
  {$ELSEIF ECHOES}
  exit mapped.ToUpper as not nullable;
  {$ELSEIF TOFFEE}
  exit mapped.uppercaseString;
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

(*method String.Trim(aCharacters: array of Char): not nullable String;
begin
  {$IF COOPER}
  result := mapped.trim(aCharacters) as not nullable;
  {$ELSEIF ECHOES}
  result := mapped.Trim(aCharacters) as not nullable;
  {$ELSEIF TOFFEE}
  var lCharacterString := '';
  for each c in aCharacters do
    lCharacterString := lCharacterString+c;
  result := mapped.stringByTrimmingCharactersInSet(NSCharacterSet.characterSetWithCharactersInString(lCharacterString));
  {$ENDIF}
end;*)

method String.StartsWith(Value: String): Boolean;
begin
  if Value.Length = 0 then
    exit true;

  {$IF COOPER OR ECHOES}
  exit mapped.StartsWith(Value);
  {$ELSEIF TOFFEE}
  exit mapped.hasPrefix(Value);
  {$ENDIF}
end;

method String.EndsWith(Value: String): Boolean;
begin
  if Value.Length = 0 then
    exit true;

  {$IF COOPER OR ECHOES}
  exit mapped.EndsWith(Value);
  {$ELSEIF TOFFEE}
  exit mapped.hasSuffix(Value);
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

end.

namespace Sugar;

interface

type
  String = public class mapped to {$IF COOPER}java.lang.String{$ELSEIF ECHOES}System.String{$ELSEIF NOUGAT}Foundation.NSString{$ENDIF}
  private
    method get_Chars(aIndex: Int32): Char;
  public
    constructor(Value: array of Byte);
    constructor(Value: array of Char);

    class operator Add(Value1: String; Value2: String): String;
    class operator Implicit(Value: Char): String;
    class operator Greater(Value1, Value2: String): Boolean;
    class operator Less(Value1, Value2: String): Boolean;
    class operator GreaterOrEqual(Value1, Value2: String): Boolean;
    class operator LessOrEqual(Value1, Value2: String): Boolean;

    class method Format(aFormat: String; params aParams: array of Object): String;    
    class method CharacterIsWhiteSpace(Value: Char): Boolean;
    class method IsNullOrEmpty(Value: String): Boolean;
    class method IsNullOrWhiteSpace(Value: String): Boolean;

    method CompareTo(Value: String): Integer;
    method CompareToIgnoreCase(Value: String): Integer;
    method &Equals(Value: String): Boolean;
    method EqualsIngoreCase(Value: String): Boolean;
    method Contains(Value: String): Boolean;
    method IndexOf(Value: String): Int32;
    method LastIndexOf(Value: String): Int32;
    method Substring(StartIndex: Int32): String;
    method Substring(StartIndex: Int32; aLength: Int32): String;
    method Split(Separator: String): array of String;
    method Replace(OldValue, NewValue: String): String;
    method ToLower: String;
    method ToUpper: String;
    method Trim: String;
    method StartsWith(Value: String): Boolean;
    method EndsWith(Value: String): Boolean;
    method ToByteArray: array of Byte;
    method ToCharArray: array of Char;

    property Length: Int32 read mapped.Length;
    property Chars[aIndex: Int32]: Char read get_Chars; default;
  end;

implementation

constructor String(Value: array of Byte);
begin
  if Value = nil then
    raise new SugarArgumentNullException("Value");

  {$IF COOPER}
  exit new java.lang.String(Value, "UTF-8");
  {$ELSEIF ECHOES}
  exit System.Text.Encoding.UTF8.GetString(Value, 0, Value.Length);
  {$ELSEIF NOUGAT}
  exit new NSString withBytes(Value) length(length(Value)) encoding(NSStringEncoding.NSUTF8StringEncoding);
  {$ENDIF}
end;

constructor String(Value: array of Char);
begin
  if Value = nil then
    raise new SugarArgumentNullException("Value");

  {$IF COOPER}
  exit new java.lang.String(Value);
  {$ELSEIF ECHOES}
  exit new System.String(Value);
  {$ELSEIF NOUGAT}
  exit new Foundation.NSString withCharacters(Value) length(length(Value));
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
  {$ELSEIF NOUGAT}
  result := mapped.characterAtIndex(aIndex);
  {$ENDIF}
end;

class operator String.Add(Value1: String; Value2: String): String;
begin
  {$IF COOPER}
  result := java.lang.String(Value1)+java.lang.String(Value2);
  {$ELSEIF ECHOES}
  result := System.String(Value1)+System.String(Value2);
  {$ELSEIF NOUGAT}
  result := Foundation.NSString(Value1).stringByAppendingString(Value2);
  {$ENDIF}
end;

class operator String.Implicit(Value: Char): String;
begin
  {$IF COOPER}
  exit new java.lang.String(Value);
  {$ELSEIF ECHOES}
  exit new System.String(Value, 1);
  {$ELSEIF NOUGAT}
  if Value = #0 then
    exit NSString.stringWithFormat(#0);

  exit NSString.stringWithFormat("%c", Value);
  {$ENDIF}
end;

class operator String.Greater(Value1: String; Value2: String): Boolean;
begin
  {$IF COOPER}
  result := java.lang.String(Value1).compareTo(java.lang.String(Value2)) > 0;
  {$ELSEIF ECHOES}
  result := System.String(Value1).CompareTo(System.String(Value2)) > 0;
  {$ELSEIF NOUGAT}
  result := Foundation.NSString(Value1).compare(Value2) > 0;
  {$ENDIF}
end;

class operator String.Less(Value1: String; Value2: String): Boolean;
begin
  {$IF COOPER}
  result := java.lang.String(Value1).compareTo(java.lang.String(Value2)) < 0;
  {$ELSEIF ECHOES}
  result := System.String(Value1).CompareTo(System.String(Value2)) < 0;
  {$ELSEIF NOUGAT}
  result := Foundation.NSString(Value1).compare(Value2) < 0;
  {$ENDIF}
end;

class operator String.GreaterOrEqual(Value1: String; Value2: String): Boolean;
begin
  {$IF COOPER}
  result := java.lang.String(Value1).compareTo(java.lang.String(Value2)) >= 0;
  {$ELSEIF ECHOES}
  result := System.String(Value1).CompareTo(System.String(Value2)) >= 0;
  {$ELSEIF NOUGAT}
  result := Foundation.NSString(Value1).compare(Value2) >= 0;
  {$ENDIF}
end;

class operator String.LessOrEqual(Value1: String; Value2: String): Boolean;
begin
  {$IF COOPER}
  result := java.lang.String(Value1).compareTo(java.lang.String(Value2)) <= 0;
  {$ELSEIF ECHOES}
  result := System.String(Value1).CompareTo(System.String(Value2)) <= 0;
  {$ELSEIF NOUGAT}
  result := Foundation.NSString(Value1).compare(Value2) <= 0;
  {$ENDIF}
end;

class method String.Format(aFormat: String; params aParams: array of Object): String;
begin
  exit StringFormatter.FormatString(aFormat, aParams);
end;

class method String.CharacterIsWhiteSpace(Value: Char): Boolean;
begin
  {$IF COOPER}
  result := java.lang.Character.isWhitespace(Value);
  {$ELSEIF ECHOES}
  result := Char.IsWhiteSpace(Value);
  {$ELSEIF NOUGAT}
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
  {$ELSEIF NOUGAT}
  exit mapped.compare(Value);
  {$ENDIF}
end;

method String.CompareToIgnoreCase(Value: String): Integer;
begin
  {$IF COOPER}
  exit mapped.compareToIgnoreCase(Value);
  {$ELSEIF ECHOES}
  exit mapped.Compare(mapped, Value, StringComparison.OrdinalIgnoreCase);
  {$ELSEIF NOUGAT}
  exit mapped.caseInsensitiveCompare(Value);
  {$ENDIF}
end;

method String.Equals(Value: String): Boolean;
begin
  {$IF COOPER}
  exit mapped.equals(Value);
  {$ELSEIF ECHOES}
  exit mapped.Equals(Value, StringComparison.Ordinal);
  {$ELSEIF NOUGAT}
  exit mapped.compare(Value) = 0;
  {$ENDIF}
end;

method String.EqualsIngoreCase(Value: String): Boolean;
begin
  {$IF COOPER}
  exit mapped.equalsIgnoreCase(Value);
  {$ELSEIF ECHOES}
  exit mapped.Equals(Value, StringComparison.OrdinalIgnoreCase);
  {$ELSEIF NOUGAT}
  exit mapped.caseInsensitiveCompare(Value) = 0;
  {$ENDIF}
end;

method String.Contains(Value: String): Boolean;
begin
  if Value.Length = 0 then
    exit true;

  {$IF COOPER OR ECHOES}
  exit mapped.Contains(Value);
  {$ELSEIF NOUGAT}
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
  {$ELSEIF NOUGAT}
  var r := mapped.rangeOfString(Value);
  exit if (r.location = NSNotFound) and (r.length = 0) then -1 else r.location;
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
  {$ELSEIF NOUGAT}
  var r := mapped.rangeOfString(Value) options(NSStringCompareOptions.NSBackwardsSearch);
  exit if (r.location = NSNotFound) and (r.length = 0) then -1 else r.location;
  {$ENDIF}
end;

method String.Substring(StartIndex: Int32): String;
begin
  {$IF COOPER OR ECHOES}
  exit mapped.Substring(StartIndex);
  {$ELSEIF NOUGAT}
  exit mapped.substringFromIndex(StartIndex);
  {$ENDIF}
end;

method String.Substring(StartIndex: Int32; aLength: Int32): String;
begin
  if (StartIndex < 0) or (aLength < 0) then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.NEGATIVE_VALUE_ERROR, "StartIndex and Length");

  {$IF COOPER}
  exit mapped.substring(StartIndex, StartIndex + aLength);
  {$ELSEIF ECHOES}
  exit mapped.Substring(StartIndex, aLength);
  {$ELSEIF NOUGAT}
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
  {$ELSEIF NOUGAT}
  var Items := mapped.componentsSeparatedByString(Separator);
  result := new String[Items.count];
  for i: Integer := 0 to Items.count - 1 do
    result[i] := Items.objectAtIndex(i);
  {$ENDIF}
end;

method String.Replace(OldValue: String; NewValue: String): String;
begin
  if IsNullOrEmpty(OldValue) then
    raise new SugarArgumentNullException("OldValue");

  if NewValue = nil then
    NewValue := "";

  {$IF COOPER OR ECHOES}
  exit mapped.Replace(OldValue, NewValue);
  {$ELSEIF NOUGAT}
  exit mapped.stringByReplacingOccurrencesOfString(OldValue) withString(NewValue);
  {$ENDIF}
end;

method String.ToLower: String;
begin
  {$IF COOPER}
  exit mapped.toLowerCase;
  {$ELSEIF ECHOES}
  exit mapped.ToLower;
  {$ELSEIF NOUGAT}
  exit mapped.lowercaseString;
  {$ENDIF}
end;

method String.ToUpper: String;
begin
  {$IF COOPER}
  exit mapped.toUpperCase;
  {$ELSEIF ECHOES}
  exit mapped.ToUpper;
  {$ELSEIF NOUGAT}
  exit mapped.uppercaseString;
  {$ENDIF}
end;

method String.Trim: String;
begin
  {$IF COOPER OR ECHOES}
  exit mapped.Trim;
  {$ELSEIF NOUGAT}
  exit mapped.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet);
  {$ENDIF}
end;

method String.StartsWith(Value: String): Boolean;
begin
  if Value.Length = 0 then
    exit true;

  {$IF COOPER OR ECHOES}
  exit mapped.StartsWith(Value);
  {$ELSEIF NOUGAT}
  exit mapped.hasPrefix(Value);
  {$ENDIF}
end;

method String.EndsWith(Value: String): Boolean;
begin
  if Value.Length = 0 then
    exit true;

  {$IF COOPER OR ECHOES}
  exit mapped.EndsWith(Value);
  {$ELSEIF NOUGAT}
  exit mapped.hasSuffix(Value);
  {$ENDIF}
end;

method String.ToCharArray: array of Char;
begin
  {$IF COOPER}
  exit mapped.ToCharArray;
  {$ELSEIF ECHOES}
  exit mapped.ToCharArray;
  {$ELSEIF NOUGAT}
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
  {$ELSEIF NOUGAT}
  var Data := Binary(mapped.dataUsingEncoding(NSStringEncoding.NSUTF8StringEncoding));
  exit Data.ToArray;
  {$ENDIF}
end;

end.

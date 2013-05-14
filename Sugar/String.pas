namespace RemObjects.Oxygene.Sugar;

{$HIDE W0} //supress case-mismatch errors

interface

type
  {$IF COOPER}
  String = public class mapped to java.lang.String
  private
    method get_Chars(aIndex: Int32): Char;
  public
    property Length: Int32 read mapped.length;
    property Chars[aIndex: Int32]: Char read get_Chars; default;

    class method Format(aFormat: String; params aParams: array of Object): String;
    class operator Add(aStringA: String; aStringB: String): String;
    class method CharacterIsWhiteSpace(aChar: Char): Boolean;
    class method IsNullOrEmpty(Value: String): Boolean;
    class method IsNullOrWhiteSpace(Value: String): Boolean;

    method CompareTo(Value: String): Integer; mapped to compareTo(Value);
    method CompareToIgnoreCase(Value: String): Integer; mapped to compareToIgnoreCase(Value);
    method &Equals(Value: String): Boolean; mapped to &equals(Value);
    method EqualsIngoreCase(Value: String): Boolean; mapped to equalsIgnoreCase(Value);
    method Contains(Value: String): Boolean; mapped to contains(Value);

    method IndexOf(aString: String): Int32; mapped to indexOf(aString);
    method LastIndexOf(aString: String): Int32; mapped to lastIndexOf(aString);

    method Substring(aStartIndex: Int32): String; mapped to substring(aStartIndex);
    method Substring(aStartIndex: Int32; aLength: Int32): String; mapped to substring(aStartIndex, aStartIndex+aLength);
    method Replace(OldValue, NewValue: String): String; mapped to replace(OldValue, NewValue);

    method ToLower: String; mapped to toLowerCase;
    method ToUpper: String; mapped to toUpperCase;
    method Trim: String; mapped to trim;    

    method ToByteArray: array of Byte;
  end;
  {$ELSEIF ECHOES}
  String = public class mapped to System.String
  private
    method get_Chars(aIndex: Int32): Char;
  public
    property Length: Int32 read mapped.Length;
    property Chars[aIndex: Int32]: Char read get_Chars; default;

    class method Format(aFormat: String; params aParams: array of Object): String;
    class operator Add(aStringA: String; aStringB: String): String;
    class method CharacterIsWhiteSpace(aChar: Char): Boolean;
    class method IsNullOrEmpty(Value: String): Boolean; mapped to IsNullOrEmpty(Value);
    class method IsNullOrWhiteSpace(Value: String): Boolean;

    method CompareTo(Value: String): Integer; mapped to Compare(mapped, Value, StringComparison.Ordinal);
    method CompareToIgnoreCase(Value: String): Integer; mapped to Compare(mapped, Value, StringComparison.OrdinalIgnoreCase);
    method &Equals(Value: String): Boolean; mapped to &Equals(Value);
    method EqualsIngoreCase(Value: String): Boolean; mapped to &Equals(Value, StringComparison.OrdinalIgnoreCase);
    method Contains(Value: String): Boolean; mapped to Contains(Value);

    method IndexOf(aString: String): Int32; mapped to IndexOf(aString);
    method LastIndexOf(aString: String): Int32; mapped to LastIndexOf(aString);    

    method Substring(aStartIndex: Int32): String; mapped to Substring(aStartIndex);
    method Substring(aStartIndex: Int32; aLength: Int32): String; mapped to Substring(aStartIndex, aLength);
    method Replace(OldValue, NewValue: String): String; mapped to Replace(OldValue, NewValue);

    method ToLower: String; mapped to ToLower;
    method ToUpper: String; mapped to ToUpper;
    method Trim: String; mapped to Trim;

    method ToByteArray: array of Byte;
  end;
  {$ELSEIF NOUGAT}
  String = public class mapped to Foundation.NSString
  private
    method get_Chars(aIndex: Int32): Char;
  public
    property Length: Int32 read mapped.length;
    property Chars[aIndex: Int32]: Char read get_Chars; default;

    class method Format(aFormat: String; params aParams: array of Object): String;
    class operator Add(aStringA: String; aStringB: String): String;
    class method CharacterIsWhiteSpace(aChar: Char): Boolean;
    class method IsNullOrEmpty(Value: String): Boolean;
    class method IsNullOrWhiteSpace(Value: String): Boolean;

    method CompareTo(Value: String): Integer; mapped to compare(Value);
    method CompareToIgnoreCase(Value: String): Integer; mapped to caseInsensitiveCompare(Value);
    method &Equals(Value: String): Boolean; 
    method EqualsIngoreCase(Value: String): Boolean;
    method Contains(Value: String): Boolean;

    method IndexOf(aString: String): Int32;
    method LastIndexOf(aString: String): Int32;

    method Substring(aStartIndex: Int32): String; mapped to substringFromIndex(aStartIndex);
    method Substring(aStartIndex: Int32; aLength: Int32): String; 
    method Replace(OldValue, NewValue: String): String; mapped to stringByReplacingOccurrencesOfString(OldValue) withString(NewValue);

    method ToLower: String; mapped to lowercaseString;
    method ToUpper: String; mapped to uppercaseString;
    method Trim: String;    

    method ToByteArray: array of Byte;
  end;
  {$ENDIF}

implementation

{$IF NOUGAT}
uses
  Foundation;
{$ENDIF}

class method String.Format(aFormat: String; params aParams: array of Object): String;
begin
  exit StringFormatter.FormatString(aFormat, aParams);
end;

class operator String.Add(aStringA: String; aStringB: String): String;
begin
  {$IF COOPER}
  result := java.lang.String(aStringA)+java.lang.String(aStringB);
  {$ELSEIF ECHOES}
  result := System.String(aStringA)+System.String(aStringB);
  {$ELSEIF NOUGAT}
  result := Foundation.NSString(aStringA).stringByAppendingString(aStringB);
  {$ENDIF}
end;

class method String.CharacterIsWhiteSpace(aChar: Char): Boolean;
begin
  {$IF COOPER}
  result := java.lang.Character.isWhitespace(aChar);
  {$ELSEIF ECHOES}
  result := Char.IsWhiteSpace(aChar);
  {$ELSEIF NOUGAT}
  result := Foundation.NSCharacterSet.whitespaceAndNewlineCharacterSet.characterIsMember(aChar);
  {$ENDIF}
end;

{$IF COOPER OR NOUGAT}
class method String.IsNullOrEmpty(Value: String): Boolean;
begin
  exit (Value = nil) or (Value.Length = 0);
end;
{$ENDIF}

class method String.IsNullOrWhiteSpace(Value: String): Boolean;
begin
  if Value = nil then
    exit;

  for i: Integer := 0 to Value.Length-1 do
    if not CharacterIsWhiteSpace(Value.Chars[i]) then
      exit false;

  exit true;
end;

{$IF NOUGAT}
method String.IndexOf(aString: String): Int32;
begin
  result := mapped.rangeOfString(aString).location;
end;

method String.LastIndexOf(aString: String): Int32;
begin
  result := mapped.rangeOfString(aString) options(NSStringCompareOptions.NSBackwardsSearch).location;
end;

method String.Substring(aStartIndex: Int32; aLength: Int32): String; 
begin
  result := mapped.substringWithRange(Foundation.NSMakeRange(aStartIndex, aLength));
end;

method String.Trim: String;
begin
  var Range := mapped.rangeOfString("^\\s*") options(NSStringCompareOptions.NSRegularExpressionSearch);
  exit mapped.stringByReplacingCharactersInRange(Range) withString("");
end;

method String.Equals(Value: String): Boolean;
begin
  exit mapped.compare(Value) = 0;
end;

method String.EqualsIngoreCase(Value: String): Boolean;
begin
  exit mapped.caseInsensitiveCompare(Value) = 0;
end;

method String.Contains(Value: String): Boolean;
begin
  exit mapped.rangeOfString(Value).location <> NSNotFound;
end;
{$ENDIF}

method String.get_Chars(aIndex: Int32): Char;
begin
  {$IF COOPER}
  result := mapped.charAt(aIndex);
  {$ELSEIF ECHOES}
  result := mapped[aIndex];
  {$ELSEIF NOUGAT}
  result := mapped.characterAtIndex(aIndex);
  {$ENDIF}
end;

method String.ToByteArray: array of Byte;
begin
  result := new Byte[mapped.length];
  for i: Integer := 0 to mapped.length-1 do
    result[i] := Byte(Chars[i]);
end;

end.

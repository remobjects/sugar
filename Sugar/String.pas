namespace RemObjects.Oxygene.Sugar;

{$HIDE W0} //supress case-mismatch errors

interface

{$IF COOPER}
uses
  RemObjects.Oxygene.Sugar.Cooper;
{$ENDIF}

type
  {$IF COOPER}
  String = public class mapped to java.lang.String
  private
    method get_Chars(aIndex: Int32): Char;
  public
    property Length: Int32 read mapped.length;
    property Chars[aIndex: Int32]: Char read get_Chars; default;

    class operator Add(aStringA: String; aStringB: String): String;
    class operator Implicit(Value: Char): String;

    class method Format(aFormat: String; params aParams: array of Object): String;
    class method CharacterIsWhiteSpace(aChar: Char): Boolean;
    class method IsNullOrEmpty(Value: String): Boolean;
    class method IsNullOrWhiteSpace(Value: String): Boolean;
    class method FromByteArray(Value: array of Byte): String;

    method CompareTo(Value: String): Integer; mapped to compareTo(Value);
    method CompareToIgnoreCase(Value: String): Integer; mapped to compareToIgnoreCase(Value);
    method &Equals(Value: String): Boolean; mapped to &equals(Value);
    method EqualsIngoreCase(Value: String): Boolean; mapped to equalsIgnoreCase(Value);
    method Contains(Value: String): Boolean; mapped to contains(Value);

    method IndexOf(aString: String): Int32; mapped to indexOf(aString);
    method LastIndexOf(aString: String): Int32; mapped to lastIndexOf(aString);

    method Substring(aStartIndex: Int32): String; mapped to substring(aStartIndex);
    method Substring(aStartIndex: Int32; aLength: Int32): String; mapped to substring(aStartIndex, aStartIndex+aLength);
    method Split(Separator: String): array of String;
    method Replace(OldValue, NewValue: String): String; mapped to replace(OldValue, NewValue);

    method ToLower: String; mapped to toLowerCase;
    method ToUpper: String; mapped to toUpperCase;
    method Trim: String; mapped to trim;    
    method StartsWith(Value: String): Boolean; mapped to startsWith(Value);
    method EndsWith(Value: String): Boolean; mapped to endsWith(Value);

    method ToByteArray: array of Byte;
  end;
  {$ELSEIF ECHOES}
  String = public class mapped to System.String
  private
    method get_Chars(aIndex: Int32): Char;
  public
    property Length: Int32 read mapped.Length;
    property Chars[aIndex: Int32]: Char read get_Chars; default;

    class operator Add(aStringA: String; aStringB: String): String;
    class operator Implicit(Value: Char): String;

    class method Format(aFormat: String; params aParams: array of Object): String;    
    class method CharacterIsWhiteSpace(aChar: Char): Boolean;
    class method IsNullOrEmpty(Value: String): Boolean; mapped to IsNullOrEmpty(Value);
    class method IsNullOrWhiteSpace(Value: String): Boolean;
    class method FromByteArray(Value: array of Byte): String;

    method CompareTo(Value: String): Integer; mapped to Compare(mapped, Value, StringComparison.Ordinal);
    method CompareToIgnoreCase(Value: String): Integer; mapped to Compare(mapped, Value, StringComparison.OrdinalIgnoreCase);
    method &Equals(Value: String): Boolean; mapped to &Equals(Value);
    method EqualsIngoreCase(Value: String): Boolean; mapped to &Equals(Value, StringComparison.OrdinalIgnoreCase);
    method Contains(Value: String): Boolean; mapped to Contains(Value);

    method IndexOf(aString: String): Int32; mapped to IndexOf(aString);
    method LastIndexOf(aString: String): Int32; mapped to LastIndexOf(aString);    

    method Substring(aStartIndex: Int32): String; mapped to Substring(aStartIndex);
    method Substring(aStartIndex: Int32; aLength: Int32): String; mapped to Substring(aStartIndex, aLength);
    method Split(Separator: String): array of String;
    method Replace(OldValue, NewValue: String): String; mapped to Replace(OldValue, NewValue);

    method ToLower: String; mapped to ToLower;
    method ToUpper: String; mapped to ToUpper;
    method Trim: String; mapped to Trim;
    method StartsWith(Value: String): Boolean; mapped to StartsWith(Value);
    method EndsWith(Value: String): Boolean; mapped to EndsWith(Value);

    method ToByteArray: array of Byte;
  end;
  {$ELSEIF NOUGAT}
  String = public class mapped to Foundation.NSString
  private
    method get_Chars(aIndex: Int32): Char;
  public
    property Length: Int32 read mapped.length;
    property Chars[aIndex: Int32]: Char read get_Chars; default;

    class operator Add(aStringA: String; aStringB: String): String;
    class operator Implicit(Value: Char): String;

    class method Format(aFormat: String; params aParams: array of Object): String;
    class method CharacterIsWhiteSpace(aChar: Char): Boolean;
    class method IsNullOrEmpty(Value: String): Boolean;
    class method IsNullOrWhiteSpace(Value: String): Boolean;
    class method FromByteArray(Value: array of Byte): String;

    method CompareTo(Value: String): Integer; mapped to compare(Value);
    method CompareToIgnoreCase(Value: String): Integer; mapped to caseInsensitiveCompare(Value);
    method &Equals(Value: String): Boolean; 
    method EqualsIngoreCase(Value: String): Boolean;
    method Contains(Value: String): Boolean;

    method IndexOf(aString: String): Int32;
    method LastIndexOf(aString: String): Int32;

    method Substring(aStartIndex: Int32): String; mapped to substringFromIndex(aStartIndex);
    method Substring(aStartIndex: Int32; aLength: Int32): String; 
    method Split(Separator: String): array of String;
    method Replace(OldValue, NewValue: String): String; mapped to stringByReplacingOccurrencesOfString(OldValue) withString(NewValue);

    method ToLower: String; mapped to lowercaseString;
    method ToUpper: String; mapped to uppercaseString;
    method Trim: String;    
    method StartsWith(Value: String): Boolean; 
    method EndsWith(Value: String): Boolean; 

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

class operator String.Implicit(Value: Char): String;
begin
  {$IF COOPER}
  exit new java.lang.String(Value);
  {$ELSEIF ECHOES}
  exit new System.String(Value, 1);
  {$ELSEIF NOUGAT}
  exit NSString.stringWithFormat("%c", Value);
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
  exit mapped.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet);
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

method String.StartsWith(Value: String): Boolean;
begin
  exit IndexOf(Value)=0 ;
end;

method String.EndsWith(Value: String): Boolean;
begin
  exit LastIndexOf(Value)=mapped.Length;
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
  {$IF COOPER}
  exit ArrayUtils.ToUnsignedArray(mapped.getBytes("UTF-8"));
  {$ELSEIF ECHOES}
  exit System.Text.Encoding.UTF8.GetBytes(mapped);
  {$ELSEIF NOUGAT}
  var Data := Binary(mapped.dataUsingEncoding(NSStringEncoding.NSUTF8StringEncoding));
  exit Data.ToArray;
  {$ENDIF}
end;

class method String.FromByteArray(Value: array of Byte): String;
begin
  {$IF COOPER}
  exit new java.lang.String(ArrayUtils.ToSignedArray(Value), "UTF-8");
  {$ELSEIF ECHOES}
  exit System.Text.Encoding.UTF8.GetString(Value, 0, Value.Length);
  {$ELSEIF NOUGAT}
  exit new NSString withBytes(Value) length(length(Value)) encoding(NSStringEncoding.NSUTF8StringEncoding);
  {$ENDIF}
end;

method String.Split(Separator: String): array of String;
begin
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

end.

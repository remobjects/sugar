namespace RemObjects.Oxygene.Sugar;

{$HIDE W0} // sometimes case differs between .NET and Java; no sense needlessly IFDEF'ing that

interface

type
  {$IF COOPER}
  String = public class mapped to java.lang.String
  {$ELSEIF ECHOES}
  String = public class mapped to System.String
  {$ELSEIF NOUGAT}
  String = public class mapped to Foundation.NSString
  {$ENDIF}
  private
    {$IF NOUGAT}
    method NSMakeRange(loc: Int32; len: Int32): Foundation.NSRange; // temp workaround
    {$ENDIF}
    method get_Chars(aIndex: Int32): Char;

  public
    property Length: Int32 read mapped.length;
    property Chars[aIndex: Int32]: Char read get_Chars; default;

    class method Format(aFormat: String; params aParams: array of Object): String;
    class operator Add(aStringA: String; aStringB: String): String;

    class method CharacterIsWhiteSpace(aChar: Char): Boolean;

    {$IF ECHOES OR COOPER}
    method IndexOf(aString: String): Int32; mapped to IndexOf(aString);
    method LastIndexOf(aString: String): Int32; mapped to LastIndexOf(aString);
    {$ELSEIF NOUGAT}
    method IndexOf(aString: String): Int32;
    method LastIndexOf(aString: String): Int32;
    {$ENDIF}

    {$IF COOPER}
    method Substring(aStartIndex: Int32): String;                 mapped to Substring(aStartIndex);
    method Substring(aStartIndex: Int32; aLength: Int32): String; mapped to Substring(aStartIndex, aStartIndex+aLength);
    {$ELSEIF ECHOES}
    method Substring(aStartIndex: Int32): String;                 mapped to Substring(aStartIndex);
    method Substring(aStartIndex: Int32; aLength: Int32): String; mapped to Substring(aStartIndex, aLength);
    {$ELSEIF NOUGAT}
    method Substring(aStartIndex: Int32): String;                 mapped to substringFromIndex(aStartIndex);
    method Substring(aStartIndex: Int32; aLength: Int32): String; 
    {$ENDIF}

    {$IF COOPER}
    method ToLower: String; mapped to toLowerCase;
    method ToUpper: String; mapped to toUpperCase;
    {$ELSEIF ECHOES}
    method ToLower: String; mapped to ToLower;
    method ToUpper: String; mapped to ToUpper;
    {$ELSEIF NOUGAT}
    method ToLower: String; mapped to lowercaseString;
    method ToUpper: String; mapped to uppercaseString;
    {$ENDIF}

  end;

implementation

{$IF NOUGAT}
uses
  Foundation;
{$ENDIF}

class method String.Format(aFormat: String; params aParams: array of Object): String;
begin
  {$IF ECHOES}
  exit StringFormatter.FormatString(aFormat, aParams);
  {$ELSE}
  raise new SugarNotImplementedException();
  {$ENDIF}
end;

class operator String.Add(aStringA: String; aStringB: String): String;
begin
  {$IF COOPER}
  result := java.lang.String(aStringA)+java.lang.String(aStringB);
  {$ENDIF}
  {$IF ECHOES}
  result := System.String(aStringA)+System.String(aStringB);
  {$ENDIF}
  {$IF NOUGAT}
  result := Foundation.NSString(aStringA).stringByAppendingString(aStringB);
  {$ENDIF}
end;

class method String.CharacterIsWhiteSpace(aChar: Char): Boolean;
begin
  {$IF COOPER}
  result := java.lang.Character.isWhitespace(aChar);
  {$ENDIF}
  {$IF ECHOES}
  result := Char.IsWhiteSpace(aChar);
  {$ENDIF}
  {$IF NOUGAT}
  result := Foundation.NSCharacterSet.whitespaceAndNewlineCharacterSet.characterIsMember(aChar);
  {$ENDIF}
end;


{$IF NOUGAT}
method String.NSMakeRange(loc: Int32; len: Int32): Foundation.NSRange;
begin 
  result.location := loc;
  result.length := len;
end;

method String.IndexOf(aString: String): Int32;
begin
  result := mapped.rangeOfString(aString).location;
end;

method String.LastIndexOf(aString: String): Int32;
begin
  result := mapped.rangeOfString(aString) options(NSStringCompareOptions.NSBackwardsSearch).location;
end;

method String.Substring(aStartIndex: Int32; aLength: Int32): String; //59155: Nougat: support for methids with nameless parameters (foo:::)
begin
  result := mapped.substringWithRange(NSMakeRange(aStartIndex, aLength));
end;
{$ENDIF}

method String.get_Chars(aIndex: Int32): Char;
begin
  {$IF COOPER} // 59230: Improved IFDEF snytax
  result := mapped[AIndex];
  {$ENDIF}
  {$IF ECHOES}
  result := mapped[aIndex];
  {$ENDIF}
  {$IF NOUGAT}
  result := mapped.characterAtIndex(aIndex);
  {$ENDIF}
end;

end.

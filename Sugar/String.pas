namespace RemObjects.Oxygene.Sugar;

{$HIDE W0} // sometimes case differs between .NET and Java; no sense needlessly IFDEF'ing that

interface

type
  {$IF COOPER}
  String = public class mapped to java.lang.String
  {$ENDIF}
  {$IF ECHOES}
  String = public class mapped to System.String
  {$ENDIF}
  {$IF NOUGAT}
  String = public class mapped to Foundation.NSString
  {$ENDIF}
  private
    {$IF NOUGAT}
    method NSMakeRange(loc: Int32; len: Int32): Foundation.NSRange; // temp workaround
    {$ENDIF}
    method get_Chars(aIndex: Int32): Char;

  public
    class method Format(aFormat: String; params aParams: array of Object): String;
    method Length: Int32; mapped to length;
    {$IFNDEF NOUGAT}
    method IndexOf(aString: String): Int32; mapped to IndexOf(aString);
    method Substring(aStartIndex: Int32): String; mapped to Substring(aStartIndex);
    {$ELSE}
    method IndexOf(aString: String): Int32;
    method Substring(aStartIndex: Int32): String; mapped to substringFromIndex(aStartIndex);
    {$ENDIF}

    {$IF COOPER}
    method Substring(aStartIndex: Int32; aLength: Int32): String; mapped to Substring(aStartIndex, aStartIndex+aLength);
    {$ENDIF}
    {$IF ECHOES}
    method Substring(aStartIndex: Int32; aLength: Int32): String; mapped to Substring(aStartIndex, aLength);
    {$ENDIF}
    {$IF NOUGAT}
    method Substring(aStartIndex: Int32; aLength: Int32): String; //59155: Nougat: support for methids with nameless parameters (foo:::)
    {$ENDIF}

    {$IF COOPER}
    method ToLower: String; mapped to toLowerCase;
    method ToUpper: String; mapped to toUpperCase;
    {$ENDIF}
    {$IF NOUGAT}
    method ToLower: String; mapped to lowercaseString;
    method ToUpper: String; mapped to uppercaseString;
    {$ENDIF}

    property Chars[aIndex: Int32]: Char read get_Chars; default;
    class operator Add(aStringA: String; aStringB: String): String;
  end;

implementation

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

namespace RemObjects.Oxygene.Sugar;
{$HIDE W0} //supress case-mismatch errors
interface

type

  {$IF COOPER}
  StringBuilder = public class mapped to java.lang.StringBuilder
  private
    method set_Chars(aIndex: Int32; value: Char ) ;
    method set_Length(value: Integer);  
  public
    method Append(value: String): StringBuilder; mapped to append(value);
    method Append(value: Object): StringBuilder; mapped to append(value);
    method Append(value: String; startIndex, count: Integer): StringBuilder; mapped to append(value, startIndex, count);
    method Append(value: Char; repeatCount: Integer): StringBuilder;
    method AppendLine(): StringBuilder;
    method AppendLine(value: String): StringBuilder;

    method Clear; mapped to setLength(0);
    method Delete(Start, &End: Integer): StringBuilder; mapped to delete(Start, &End);
    method Replace(Start, &End: Integer; Value: String): StringBuilder; mapped to replace(Start, &End, Value);
    method Substring(Start: Integer): String; mapped to substring(Start);
    method Substring(Start, &End: Integer): String; mapped to substring(Start, &End);
    method Insert(Offset: Integer; Value: String): StringBuilder; mapped to insert(Offset, Value);

    property Length: Integer read mapped.length write set_Length;
    property Chars[aIndex: Int32]: Char read mapped.charAt(aIndex) write set_Chars; default;
  {$ELSEIF ECHOES}
  StringBuilder = public class mapped to System.Text.StringBuilder
  public
    method Append(value: String): StringBuilder; mapped to Append(value);
    method Append(value: String; startIndex, count: Integer): StringBuilder; mapped to Append(value, startIndex, count);
    method Append(value: Char; repeatCount: Integer): StringBuilder; mapped to Append(value, repeatCount);
    method AppendLine(): StringBuilder; mapped to AppendLine();
    method AppendLine(value: String): StringBuilder; mapped to AppendLine(value);

    method Clear;
    method Delete(Start, &End: Integer): StringBuilder; mapped to &Remove(Start, &End);
    method Replace(Start, &End: Integer; Value: String): StringBuilder;
    method Substring(Start: Integer): String; mapped to ToString(Start, Length);
    method Substring(Start, &End: Integer): String; mapped to ToString(Start, &End);
    method Insert(Offset: Integer; Value: String): StringBuilder; mapped to Insert(Offset, Value);

    property Length: Integer read mapped.Length write mapped.Length;
    property Chars[aIndex: Int32]: Char read mapped.Chars[aIndex] write mapped.Chars[aIndex]; default;
  {$ELSEIF NOUGAT}
  StringBuilder = public class mapped to Foundation.NSMutableString
  private
    method NSMakeRange(loc: Int32; len: Int32): Foundation.NSRange;
    method get_Chars(aIndex : Int32): Char;
    method set_Chars(aIndex : Int32; value: Char);
    method set_Length(value: Integer);  
  public
    method Append(value: String): StringBuilder;
    method Append(value: String; startIndex, count: Integer): StringBuilder;
    method Append(value: Char; repeatCount: Integer): StringBuilder;
    method AppendLine(): StringBuilder; 
    method AppendLine(value: String): StringBuilder; 

    method ToString(): String;
    method Clear; mapped to setString("");
    method Delete(Start, &End: Integer): StringBuilder;
    method Replace(Start, &End: Integer; Value: String): StringBuilder;
    method Substring(Start: Integer): String; mapped to substringFromIndex(Start);
    method Substring(Start, &End: Integer): String;
    method Insert(Offset: Integer; Value: String): StringBuilder;

    property Length: Integer read mapped.length write set_Length;
    property Chars[aIndex: Int32]: Char read get_Chars write set_Chars ; default;
  {$ENDIF}
  end;

implementation

{$IF COOPER}
method StringBuilder.set_Chars(aIndex: Int32; value: Char ) ; 
begin
  mapped.setCharAt(aIndex,value);
end;

method StringBuilder.set_Length(value: Integer);
begin
  mapped.setLength(value);
end;

method StringBuilder.Append(value: Char; repeatCount: Integer): StringBuilder;
begin
  for i: Int32 := 1 to repeatCount do mapped.append(value);
  exit mapped;
end;

method StringBuilder.AppendLine(): StringBuilder;
begin
  mapped.append(Environment.NewLine);
  exit mapped;
end;

method StringBuilder.AppendLine(value: String): StringBuilder;
begin
  mapped.append(value);
  mapped.append(Environment.NewLine);
  exit mapped;
end;


{$ELSEIF ECHOES}
method StringBuilder.Clear;
begin
  mapped.Length := 0;
end;

method StringBuilder.Replace(Start: Integer; &End: Integer; Value: String): StringBuilder;
begin
  mapped.Remove(Start, &End);
  exit mapped.Insert(Start, Value);
end;
{$ELSEIF NOUGAT}
method StringBuilder.Append(value: String): StringBuilder;
begin
  mapped.appendString(value);
  exit mapped;
end;

method StringBuilder.Append(value: Char; repeatCount: Integer): StringBuilder;
begin
  for i: Int32 := 1 to repeatCount do
    mapped.appendString(value);
  exit mapped;
end;

method StringBuilder.Append(value: String; startIndex: Integer; count: Integer): StringBuilder;
begin  
  mapped.appendString(value.Substring(startIndex, count));
  exit mapped;
end;

method StringBuilder.AppendLine(): StringBuilder;
begin
  mapped.appendString(Environment.NewLine);
  exit mapped;
end;

method StringBuilder.AppendLine(value: String): StringBuilder;
begin
  mapped.appendString(value);
  mapped.appendString(Environment.NewLine);
  exit mapped;
end;

method StringBuilder.ToString(): String;
begin
  exit Foundation.NSString.stringWithString(mapped);
end;

method StringBuilder.Insert(Offset: Integer; Value: String): StringBuilder;
begin
  mapped.insertString(Value) atIndex(Offset);
  exit mapped;
end;

method StringBuilder.NSMakeRange(loc: Int32; len: Int32): Foundation.NSRange;
begin
  result.location := loc;
  result.length := len;
end;

method StringBuilder.Replace(Start: Integer; &End: Integer; Value: String): StringBuilder;
begin
  mapped.replaceCharactersInRange(NSMakeRange(Start, &End)) withString(Value);
  exit mapped;
end;

method StringBuilder.Substring(Start: Integer; &End: Integer): String;
begin
  exit mapped.substringWithRange(NSMakeRange(Start, &End));
end;

method StringBuilder.Delete(Start: Integer; &End: Integer): StringBuilder;
begin
  mapped.deleteCharactersInRange(NSMakeRange(Start, &End));
  exit mapped;
end;

method StringBuilder.get_Chars(aIndex : Int32): Char;
begin
  result := mapped.characterAtIndex(aIndex);
end;

method StringBuilder.set_Chars(aIndex : Int32; value: Char);
begin
  mapped.replaceCharactersInRange(NSMakeRange(aIndex, aIndex)) withString(value);  
end;

method StringBuilder.set_Length(value: Integer);
begin
  mapped.deleteCharactersInRange(NSMakeRange(value, length))
end;
{$ENDIF}

end.

namespace RemObjects.Oxygene.Sugar;
{$HIDE W0} //supress case-mismatch errors
interface

type

  {$IF COOPER}
  StringBuilder = public class mapped to java.lang.StringBuilder
  private
    method set_Chars(&Index: Integer; Value: Char);
    method set_Length(Value: Integer);  
  public
    constructor; mapped to constructor();
    constructor(Capacity: Integer); mapped to constructor(Capacity);
    constructor(Data: String); mapped to constructor(Data);

    method Append(Value: String): StringBuilder;
    method Append(Value: String; StartIndex, Count: Integer): StringBuilder; 
    method Append(Value: Char; RepeatCount: Integer): StringBuilder;
    method AppendLine: StringBuilder;
    method AppendLine(Value: String): StringBuilder;

    method Clear; mapped to setLength(0);
    method Delete(StartIndex, Count: Integer): StringBuilder;
    method Replace(StartIndex, Count: Integer; Value: String): StringBuilder;
    method Substring(StartIndex: Integer): String; mapped to substring(StartIndex);
    method Substring(StartIndex, Count: Integer): String; mapped to substring(StartIndex, StartIndex + Count);
    method Insert(Offset: Integer; Value: String): StringBuilder; 

    property Length: Integer read mapped.length write set_Length;
    property Chars[&Index: Integer]: Char read mapped.charAt(&Index) write set_Chars; default;
  {$ELSEIF ECHOES}
  StringBuilder = public class mapped to System.Text.StringBuilder
  public
    constructor; mapped to constructor();
    constructor(Capacity: Integer); mapped to constructor(Capacity);
    constructor(Data: String); mapped to constructor(Data);

    method Append(Value: String): StringBuilder;
    method Append(Value: String; StartIndex, Count: Integer): StringBuilder; mapped to Append(Value, StartIndex, Count);
    method Append(Value: Char; RepeatCount: Integer): StringBuilder; mapped to Append(Value, RepeatCount);
    method AppendLine: StringBuilder; mapped to AppendLine;
    method AppendLine(Value: String): StringBuilder;

    method Clear;
    method Delete(StartIndex, Count: Integer): StringBuilder; mapped to &Remove(StartIndex, Count);
    method Replace(StartIndex, Count: Integer; Value: String): StringBuilder;
    method Substring(StartIndex: Integer): String; mapped to ToString(StartIndex, Length - StartIndex);
    method Substring(StartIndex, Count: Integer): String; mapped to ToString(StartIndex, Count);
    method Insert(Offset: Integer; Value: String): StringBuilder;

    property Length: Integer read mapped.Length write mapped.Length;
    property Chars[&Index: Integer]: Char read mapped.Chars[&Index] write mapped.Chars[&Index]; default;
  {$ELSEIF NOUGAT}
  StringBuilder = public class mapped to Foundation.NSMutableString
  private
    method get_Chars(&Index : Integer): Char;
    method set_Chars(&Index : Integer; Value: Char);
    method set_Length(Value: Integer);  
  public
    constructor; mapped to constructor();
    constructor(Capacity: Integer); mapped to initWithCapacity(Capacity);
    constructor(Data: String); mapped to stringWithString(Data);

    method Append(Value: String): StringBuilder;
    method Append(Value: String; StartIndex, Count: Integer): StringBuilder;
    method Append(Value: Char; RepeatCount: Integer): StringBuilder;
    method AppendLine: StringBuilder; 
    method AppendLine(Value: String): StringBuilder; 

    method Clear; mapped to setString("");
    method Delete(StartIndex, Count: Integer): StringBuilder;
    method Replace(StartIndex, Count: Integer; Value: String): StringBuilder;
    method Substring(StartIndex: Integer): String; mapped to substringFromIndex(StartIndex);
    method Substring(StartIndex, Count: Integer): String;
    method Insert(Offset: Integer; Value: String): StringBuilder;

    method description: NSString; override;

    property Length: Integer read mapped.length write set_Length;
    property Chars[&Index: Integer]: Char read get_Chars write set_Chars ; default;
  {$ENDIF}
  end;

implementation

{$IF COOPER}
method StringBuilder.set_Chars(&Index: Integer; Value: Char); 
begin
  mapped.setCharAt(&Index,Value);
end;

method StringBuilder.set_Length(Value: Integer);
begin
  mapped.setLength(Value);
end;

method StringBuilder.Append(Value: String): StringBuilder;
begin
  if Value = nil then
    raise new SugarArgumentNullException("Value");

  exit mapped.append(Value);
end;

method StringBuilder.Append(Value: String; StartIndex: Integer; Count: Integer): StringBuilder;
begin
  if (startIndex = 0) and (count = 0) then
    exit mapped;

  if Value = nil then
    raise new SugarArgumentNullException("Value");

  exit mapped.append(Value, startIndex, startIndex + count);
end;

method StringBuilder.Append(Value: Char; RepeatCount: Integer): StringBuilder;
begin
  if RepeatCount < 0 then
    raise new SugarArgumentOutOfRangeException("Number of repeats can not be less than zero");

  for i: Int32 := 1 to RepeatCount do 
    mapped.append(Value);

  exit mapped;
end;

method StringBuilder.AppendLine: StringBuilder;
begin
  mapped.append(Environment.NewLine);
  exit mapped;
end;

method StringBuilder.AppendLine(Value: String): StringBuilder;
begin
  if Value = nil then
    raise new SugarArgumentNullException("Value");

  mapped.append(Value);
  mapped.append(Environment.NewLine);
  exit mapped;
end;

method StringBuilder.Delete(StartIndex: Integer; Count: Integer): StringBuilder;
begin
  if Count > mapped.Length then
    raise new SugarArgumentOutOfRangeException("Count is greater than length of buffer");

  exit mapped.delete(StartIndex, StartIndex + Count);
end;

method StringBuilder.Replace(StartIndex: Integer; Count: Integer; Value: String): StringBuilder;
begin
  if Count > mapped.Length then
    raise new SugarArgumentOutOfRangeException("Count is greater than length of buffer");

  exit  mapped.replace(StartIndex, StartIndex + Count, Value);
end;

method StringBuilder.Insert(Offset: Integer; Value: String): StringBuilder;
begin
  if Value = nil then
    raise new SugarArgumentNullException("Value");

  exit mapped.insert(Offset, Value);
end;
{$ELSEIF ECHOES}
method StringBuilder.Clear;
begin
  mapped.Length := 0;
end;

method StringBuilder.Replace(StartIndex: Integer; Count: Integer; Value: String): StringBuilder;
begin
  if Value = nil then
    raise new SugarArgumentNullException("Value");

  mapped.Remove(StartIndex, Count);
  exit mapped.Insert(StartIndex, Value);
end;

method StringBuilder.Append(Value: String): StringBuilder;
begin
  if Value = nil then
    raise new SugarArgumentNullException("Value");

  exit mapped.Append(Value);
end;

method StringBuilder.AppendLine(Value: String): StringBuilder;
begin
  if Value = nil then
    raise new SugarArgumentNullException("Value");

  exit mapped.AppendLine(Value);
end;

method StringBuilder.Insert(Offset: Integer; Value: String): StringBuilder;
begin
  if Value = nil then
    raise new SugarArgumentNullException("Value");

  exit mapped.Insert(Offset, Value);
end;
{$ELSEIF NOUGAT}
method StringBuilder.Append(Value: String): StringBuilder;
begin
  mapped.appendString(Value);
  exit mapped;
end;

method StringBuilder.Append(Value: Char; repeatCount: Integer): StringBuilder;
begin
  if repeatCount < 0 then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.NEGATIVE_VALUE_ERROR, "Number of repeats");

  for i: Int32 := 1 to repeatCount do
    mapped.appendString(Value);

  exit mapped;
end;

method StringBuilder.Append(Value: String; StartIndex: Integer; Count: Integer): StringBuilder;
begin  
  if (StartIndex < 0) or (Count < 0) then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.NEGATIVE_VALUE_ERROR, "Start index and count");

  if (startIndex = 0) and (count = 0) then
    exit mapped;

  mapped.appendString(Value.Substring(StartIndex, Count));
  exit mapped;
end;

method StringBuilder.AppendLine: StringBuilder;
begin
  mapped.appendString(Environment.NewLine);
  exit mapped;
end;

method StringBuilder.AppendLine(Value: String): StringBuilder;
begin
  mapped.appendString(Value);
  mapped.appendString(Environment.NewLine);
  exit mapped;
end;

method StringBuilder.description: NSString;
begin
  exit Foundation.NSString.stringWithString(mapped);
end;

method StringBuilder.Insert(Offset: Integer; Value: String): StringBuilder;
begin
  mapped.insertString(Value) atIndex(Offset);
  exit mapped;
end;

method StringBuilder.Replace(StartIndex: Integer; Count: Integer; Value: String): StringBuilder;
begin
  mapped.replaceCharactersInRange(NSMakeRange(StartIndex, Count)) withString(Value);
  exit mapped;
end;

method StringBuilder.Substring(StartIndex: Integer; Count: Integer): String;
begin
  if (StartIndex < 0) or (Count < 0) then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.NEGATIVE_VALUE_ERROR, "Start index and count");

  exit mapped.substringWithRange(NSMakeRange(StartIndex, Count));
end;

method StringBuilder.Delete(StartIndex: Integer; Count: Integer): StringBuilder;
begin
  mapped.deleteCharactersInRange(NSMakeRange(StartIndex, Count));
  exit mapped;
end;

method StringBuilder.get_Chars(&Index : Integer): Char;
begin
  if &Index  < 0 then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.NEGATIVE_VALUE_ERROR, "Index");

  result := mapped.characterAtIndex(&Index);
end;

method StringBuilder.set_Chars(&Index : Integer; Value: Char);
begin
  if &Index  < 0 then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.NEGATIVE_VALUE_ERROR, "Index");

  mapped.replaceCharactersInRange(NSMakeRange(&Index, &Index)) withString(Value);  
end;

method StringBuilder.set_Length(Value: Integer);
begin
  if Value > mapped.length then
    Append(#0, Value - mapped.length)
  else
    mapped.deleteCharactersInRange(NSMakeRange(Value, mapped.length - Value));
end;
{$ENDIF}

end.

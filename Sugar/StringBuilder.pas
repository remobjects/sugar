namespace RemObjects.Sugar;
{$HIDE W0} //supress case-mismatch errors
interface

type
  StringBuilder = public class mapped to {$IF COOPER}java.lang.StringBuilder{$ELSEIF ECHOES}System.Text.StringBuilder{$ELSEIF NOUGAT}Foundation.NSMutableString{$ENDIF}
  private
    method get_Chars(&Index : Integer): Char;
    method set_Chars(&Index : Integer; Value: Char);
    method set_Length(Value: Integer);
  public
    constructor; mapped to constructor();
    constructor(Capacity: Integer); mapped to {$IF COOPER OR ECHOES}constructor(Capacity){$ELSEIF NOUGAT}stringWithCapacity(Capacity){$ENDIF};
    constructor(Data: String); mapped to {$IF COOPER OR ECHOES}constructor(Data){$ELSEIF NOUGAT}stringWithString(Data){$ENDIF};

    method Append(Value: String): StringBuilder;
    method Append(Value: String; StartIndex, Count: Integer): StringBuilder;
    method Append(Value: Char; RepeatCount: Integer): StringBuilder;
    method AppendLine: StringBuilder; 
    method AppendLine(Value: String): StringBuilder; 

    method Clear;
    method Delete(StartIndex, Count: Integer): StringBuilder;
    method Replace(StartIndex, Count: Integer; Value: String): StringBuilder;
    method Substring(StartIndex: Integer): String;
    method Substring(StartIndex, Count: Integer): String;
    method Insert(Offset: Integer; Value: String): StringBuilder;

    property Length: Integer read mapped.length write set_Length;
    property Chars[&Index: Integer]: Char read get_Chars write set_Chars; default;
  end;

implementation

method StringBuilder.Append(Value: Char; RepeatCount: Integer): StringBuilder;
begin
  if RepeatCount < 0 then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.NEGATIVE_VALUE_ERROR, "Number of repeats");

  {$IF COOPER}
  for i: Int32 := 1 to RepeatCount do 
    mapped.append(Value);

  exit mapped;
  {$ELSEIF ECHOES}
  exit mapped.Append(Value, RepeatCount);
  {$ELSEIF NOUGAT}
  for i: Int32 := 1 to repeatCount do
    mapped.appendString(Value);

  exit mapped;
  {$ENDIF}
end;

method StringBuilder.Append(Value: String): StringBuilder;
begin
  if Value = nil then
    raise new SugarArgumentNullException("Value");

  {$IF COOPER OR ECHOES}
  exit mapped.Append(Value);
  {$ELSEIF NOUGAT}
  mapped.appendString(Value);
  exit mapped;
  {$ENDIF}
end;

method StringBuilder.Append(Value: String; StartIndex: Integer; Count: Integer): StringBuilder;
begin
  if (StartIndex = 0) and (Count = 0) then
    exit mapped;

  if Value = nil then
    raise new SugarArgumentNullException("Value");

  if (StartIndex < 0) or (Count < 0) then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.NEGATIVE_VALUE_ERROR, "Start index and count");

  {$IF COOPER}
  exit mapped.append(Value, startIndex, startIndex + count);
  {$ELSEIF ECHOES}
  exit mapped.Append(Value, StartIndex, Count);
  {$ELSEIF NOUGAT}
  mapped.appendString(Value.Substring(StartIndex, Count));
  exit mapped;
  {$ENDIF}
end;

method StringBuilder.AppendLine(Value: String): StringBuilder;
begin
  if Value = nil then
    raise new SugarArgumentNullException("Value");

  {$IF COOPER}
  mapped.append(Value);
  mapped.append(Environment.NewLine);
  exit mapped;
  {$ELSEIF ECHOES}
  exit mapped.AppendLine(Value);
  {$ELSEIF NOUGAT}
  mapped.appendString(Value);
  mapped.appendString(Environment.NewLine);
  exit mapped;
  {$ENDIF}
end;

method StringBuilder.AppendLine: StringBuilder;
begin
  {$IF COOPER}
  mapped.append(Environment.NewLine);
  exit mapped;
  {$ELSEIF ECHOES}
  exit mapped.AppendLine;
  {$ELSEIF NOUGAT}
  mapped.appendString(Environment.NewLine);
  exit mapped;
  {$ENDIF}
end;

method StringBuilder.Clear;
begin
  {$IF COOPER}
  mapped.SetLength(0);
  {$ELSEIF ECHOES}
  mapped.Length := 0;
  {$ELSEIF NOUGAT}
  mapped.SetString("");
  {$ENDIF}
end;

method StringBuilder.Delete(StartIndex: Integer; Count: Integer): StringBuilder;
begin
  if Count > self.Length then
    raise new SugarArgumentOutOfRangeException("Count is greater than length of buffer");

  {$IF COOPER}
  exit mapped.delete(StartIndex, StartIndex + Count);
  {$ELSEIF ECHOES}
   exit mapped.&Remove(StartIndex, Count);
  {$ELSEIF NOUGAT}
  mapped.deleteCharactersInRange(NSMakeRange(StartIndex, Count));
  exit mapped;
  {$ENDIF}
end;

method StringBuilder.get_Chars(&Index: Integer): Char;
begin
  if &Index  < 0 then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.NEGATIVE_VALUE_ERROR, "Index");

  {$IF COOPER}
  exit mapped.charAt(&Index);
  {$ELSEIF ECHOES}
  exit mapped.Chars[&Index];
  {$ELSEIF NOUGAT}
  result := mapped.characterAtIndex(&Index);
  {$ENDIF}
end;

method StringBuilder.Insert(Offset: Integer; Value: String): StringBuilder;
begin
  if Value = nil then
    raise new SugarArgumentNullException("Value");

  {$IF COOPER OR ECHOES}
  exit mapped.Insert(Offset, Value);
  {$ELSEIF NOUGAT}
  mapped.insertString(Value) atIndex(Offset);
  exit mapped;
  {$ENDIF}
end;

method StringBuilder.Replace(StartIndex: Integer; Count: Integer; Value: String): StringBuilder;
begin
  if Count > self.Length then
    raise new SugarArgumentOutOfRangeException("Count is greater than length of buffer");

  if Value = nil then
    raise new SugarArgumentNullException("Value");

  {$IF COOPER}
  exit  mapped.replace(StartIndex, StartIndex + Count, Value);
  {$ELSEIF ECHOES}
  mapped.Remove(StartIndex, Count);
  exit mapped.Insert(StartIndex, Value);
  {$ELSEIF NOUGAT}
  mapped.replaceCharactersInRange(NSMakeRange(StartIndex, Count)) withString(Value);
  exit mapped;
  {$ENDIF}
end;

method StringBuilder.set_Chars(&Index: Integer; Value: Char);
begin
  if &Index  < 0 then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.NEGATIVE_VALUE_ERROR, "Index");

  {$IF COOPER}
  mapped.setCharAt(&Index,Value);
  {$ELSEIF ECHOES}
  mapped.Chars[&Index] := Value;
  {$ELSEIF NOUGAT}
  mapped.replaceCharactersInRange(NSMakeRange(&Index, &Index)) withString(Value); 
  {$ENDIF}
end;

method StringBuilder.set_Length(Value: Integer);
begin
  {$IF COOPER}
  mapped.setLength(Value);
  {$ELSEIF ECHOES}
  mapped.Length := Value;
  {$ELSEIF NOUGAT}
  if Value > mapped.length then
    Append(#0, Value - mapped.length)
  else
    mapped.deleteCharactersInRange(NSMakeRange(Value, mapped.length - Value));
  {$ENDIF}
end;

method StringBuilder.Substring(StartIndex: Integer): String;
begin
  {$IF COOPER}
  exit mapped.substring(StartIndex);
  {$ELSEIF ECHOES}
  exit mapped.ToString(StartIndex, Length - StartIndex);
  {$ELSEIF NOUGAT}
  exit mapped.substringFromIndex(StartIndex);
  {$ENDIF}
end;

method StringBuilder.Substring(StartIndex: Integer; Count: Integer): String;
begin
  if (StartIndex < 0) or (Count < 0) then
    raise new SugarArgumentOutOfRangeException(ErrorMessage.NEGATIVE_VALUE_ERROR, "Start index and count");

  {$IF COOPER}
  exit mapped.substring(StartIndex, StartIndex + Count);
  {$ELSEIF ECHOES}
  exit mapped.ToString(StartIndex, Count);
  {$ELSEIF NOUGAT}
  exit mapped.substringWithRange(NSMakeRange(StartIndex, Count));
  {$ENDIF}
end;

end.

namespace RemObjects.Oxygene.Sugar;

interface

type

  {$IF COOPER}
  StringBuilder = public class mapped to java.lang.StringBuilder
  public
    method Append(value: String): StringBuilder; mapped to append(value);
    method Append(value: String; startIndex, count: Integer): StringBuilder; mapped to append(value, startIndex, count);
    method Append(value: Char; repeatCount: Integer): StringBuilder;
    method AppendLine(): StringBuilder;
    method AppendLine(value: String): StringBuilder;
  {$ENDIF}
  {$IF ECHOES}
  StringBuilder = public class mapped to System.Text.StringBuilder
  public
    method Append(value: String): StringBuilder; mapped to Append(value);
    method Append(value: String; startIndex, count: Integer): StringBuilder; mapped to Append(value, startIndex, count);
    method Append(value: Char; repeatCount: Integer): StringBuilder; mapped to Append(value, repeatCount);
    method AppendLine(): StringBuilder; mapped to AppendLine();
    method AppendLine(value: String): StringBuilder; mapped to AppendLine(value);
  {$ENDIF}
  {$IF NOUGAT}
  StringBuilder = public class mapped to Foundation.NSMutableString
  public
    method Append(value: String): StringBuilder;
  {$ENDIF}
  end;

implementation

{$IF COOPER}
method StringBuilder.Append(value: Char; repeatCount: Integer): StringBuilder;
begin
  for i: Int32 := 1 to repeatCount do mapped.append(value);
end;

method StringBuilder.AppendLine(): StringBuilder;
begin
  mapped.append(Environment.NewLine);
end;

method StringBuilder.AppendLine(value: String): StringBuilder;
begin
  mapped.append(value);
  mapped.append(Environment.NewLine);
end;
{$ENDIF}

{$IF NOUGAT}
method StringBuilder.Append(value: String): StringBuilder;
begin
  mapped.appendString(value);
  exit mapped;
end;
{$ENDIF}

end.

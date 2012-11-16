namespace RemObjects.Oxygene.Sugar;

interface

type

  {$IF COOPER}
  StringBuilder = public class mapped to java.lang.StringBuilder
  public
    method Append(value: String): StringBuilder; mapped to append(value);
    method Append(value: String; startIndex, count: Integer): StringBuilder; mapped to append(value, startIndex, count);
    method Append(value: Char; repeatCount: Integer): StringBuilder;
  {$ENDIF}
  {$IF ECHOES}
  StringBuilder = public class mapped to System.Text.StringBuilder
  public
    method Append(value: String): StringBuilder; mapped to Append(value);
    method Append(value: String; startIndex, count: Integer): StringBuilder; mapped to Append(value, startIndex, count);
    method Append(value: Char; repeatCount: Integer): StringBuilder; mapped to Append(value, repeatCount);
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
{$ENDIF}

{$IF NOUGAT}
method StringBuilder.Append(value: String): StringBuilder;
begin
  mapped.appendString(value);
  exit mapped;
end;
{$ENDIF}

end.

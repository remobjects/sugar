namespace Sugar;

{$HIDE W0} //supress case-mismatch errors

interface

type
  GuidFormat = public enum (&Default, Braces, Parentheses);

  {$IF ECHOES}[System.Runtime.InteropServices.StructLayout(System.Runtime.InteropServices.LayoutKind.Auto, Size := 1)]{$ENDIF}
  Guid = public {$IF COOPER}class mapped to java.util.UUID{$ELSEIF ECHOES}record mapped to System.Guid{$ELSEIF NOUGAT}class{$ENDIF}
  private
    {$IF ECHOES}
    method Exchange(Value: array of Byte; Index1, Index2: Integer);
    {$ELSEIF NOUGAT}
    fData: array of Byte;
    method AppendRange(Data: NSMutableString; Range: NSRange);
    method InternalParse(Data: String): array of Byte;
    {$ENDIF}
  public
    constructor;
    constructor(Value: String);
    constructor(Value: array of Byte);

    method CompareTo(Value: Guid): Integer;
    method &Equals(Value: Guid): Boolean;

    class method NewGuid: Guid;
    class method Parse(Value: String): Guid;
    class method EmptyGuid: Guid;

    method ToByteArray: array of Byte;
    method ToString(Format: GuidFormat): String;

    {$IF COOPER}
    method ToString: java.lang.String; override;
    {$ELSEIF ECHOES}
    method ToString: System.String; override;
    {$ELSEIF NOUGAT}
    method description: NSString; override;
    {$ENDIF}    
  end;


implementation

constructor Guid;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.Empty;
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

constructor Guid(Value: String);
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.Parse(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

constructor Guid(Value: array of Byte);
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit new System.Guid(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method Guid.CompareTo(Value: Guid): Integer;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.CompareTo(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method Guid.Equals(Value: Guid): Boolean;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.Equals(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Guid.NewGuid: Guid;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.NewGuid;
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Guid.Parse(Value: String): Guid;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  if (Value.Length <> 38) and (Value.Length <> 36) then
    raise new SugarFormatException(ErrorMessage.FORMAT_ERROR);

  exit new Guid(Value);
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

class method Guid.EmptyGuid: Guid;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  exit mapped.Empty;
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method Guid.ToByteArray: array of Byte;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  var Value := mapped.ToByteArray;
  //reverse byte order to normal (.NET reverse first 4 bytes and next two 2 bytes groups)
  Exchange(Value, 0, 3);
  Exchange(Value, 1, 2);
  Exchange(Value, 4, 5);
  Exchange(Value, 6, 7);

  exit Value;
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

method Guid.ToString(Format: GuidFormat): String;
begin
  {$IF COOPER}
  {$ELSEIF ECHOES}
  case Format of
    Format.Default: result := mapped.ToString("D");
    Format.Braces: result := mapped.ToString("B");
    Format.Parentheses: result := mapped.ToString("P");
    else
      result := mapped.ToString("D");
  end;

  exit result.ToUpper;
  {$ELSEIF NOUGAT}
  {$ENDIF}
end;

{$IF COOPER}
{$ELSEIF ECHOES}
method Guid.ToString: System.String;
begin
  exit ToString(GuidFormat.Default);
end;

method Guid.Exchange(Value: array of Byte; Index1: Integer; Index2: Integer);
begin
  var Temp := Value[Index1];
  Value[Index1] := Value[Index2];
  Value[Index2] := Temp;
end;
{$ELSEIF NOUGAT}
{$ENDIF}

end.

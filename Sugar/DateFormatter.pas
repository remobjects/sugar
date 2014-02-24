namespace Sugar;

interface

uses
  Sugar.Collections;

type
  DateFormatter = public class
  private
    class method GetFormaters: List<FormatSpecifier>;
    class method AppendEscaped(Value: String; Start, Count: Integer; sb: StringBuilder);
  public
    class method Format(Value: String): String;
  end;

  FormatSpecifier = private abstract class
  protected
    method RangeCheck(Value: String; C: Char; MaxLength: Integer): Boolean;
  public
    method Supports(Value: String): Boolean; virtual; abstract;
    method Convert(Value: String): String; virtual; abstract;
  end;

  SimpleFormatSpecifier = private abstract class (FormatSpecifier)
  protected
    property CodeChar: Char read; virtual; abstract;
    property MaxLength: Integer read; virtual; abstract;
  public
    method Supports(Value: String): Boolean; override;
    method Convert(Value: String): String; override;
  end;

  YearFormatSpecifier = private class (SimpleFormatSpecifier)
  protected
    property CodeChar: Char read 'y'; override;
    property MaxLength: Integer read 4; override;
  public
    method Supports(Value: String): Boolean; override;
  end;

  MonthFormatSpecifier = private class (SimpleFormatSpecifier)
  protected
    property CodeChar: Char read 'M'; override;
    property MaxLength: Integer read 4; override;
  end;

  DayFormatSpecifier = private class (SimpleFormatSpecifier)
  protected
    property CodeChar: Char read 'd'; override;
    property MaxLength: Integer read 4; override;
  public
    method Convert(Value: String): String; override;
  end;

  Hour12FormatSpecifier = private class (SimpleFormatSpecifier)
  protected
    property CodeChar: Char read 'h'; override;
    property MaxLength: Integer read 2; override;
  end;

  Hour24FormatSpecifier = private class (SimpleFormatSpecifier)
  protected
    property CodeChar: Char read 'H'; override;
    property MaxLength: Integer read 2; override;
  end;

  MinuteFormatSpecifier = private class (SimpleFormatSpecifier)
  protected
    property CodeChar: Char read 'm'; override;
    property MaxLength: Integer read 2; override;
  end;

  SecondFormatSpecifier = private class (SimpleFormatSpecifier)
  protected
    property CodeChar: Char read 's'; override;
    property MaxLength: Integer read 2; override;
  end;

  PeriodFormatSpecifier = private class (SimpleFormatSpecifier)
  protected
    property CodeChar: Char read 'a'; override;
    property MaxLength: Integer read 1; override;
  public
    method Convert(Value: String): String; override;
  end;

implementation

class method DateFormatter.AppendEscaped(Value: String; Start: Integer; Count: Integer; sb: StringBuilder);
begin
  if Count > 0 then
    sb.Append("'");

  sb.Append(Value, Start, Count);

  if Count > 0 then
    sb.Append("'");
end;

class method DateFormatter.Format(Value: String): String;
begin
  if Value = nil then
    raise new SugarArgumentNullException('Value');

  {$IF COOPER OR NOUGAT}
  //change escape character for java
  Value := Value.Replace("\'", "''");
  {$ENDIF}

  var sb := new StringBuilder;
  var Current: Integer := 0;
  var BlockStart: Integer := 0;
  var Formaters: List<FormatSpecifier> := GetFormaters;

  while Current < Value.Length do begin
    var C: Char := Value[Current];
    inc(Current);

    //possible format specifier
    if C = '{' then begin
      //copy preceding text
      AppendEscaped(Value, BlockStart, Current - BlockStart - 1, sb);

      //check for escaped open bracket
      if Value[Current] = '{' then begin
        BlockStart := Current;
        inc(Current);
        continue;
      end;

      var StartPosition := Current;

      //Looking for the closing bracket
      while (Current < Value.Length) and (Value[Current] <> '}') do
        inc(Current);

      //closing bracket not found
      if (Current >= Value.Length) or (Value[Current] <> '}') then
        raise new SugarFormatException(ErrorMessage.FORMAT_ERROR);

      //copy format
      var UserFormat := Value.Substring(StartPosition, Current - StartPosition);
      
      if String.IsNullOrEmpty(UserFormat) then
        raise new SugarFormatException(ErrorMessage.FORMAT_ERROR);

      inc(Current);
      BlockStart := Current;

      //convert format specifier to a valid platform format
      var Formater: FormatSpecifier := nil;
      for i: Integer := 0 to Formaters.Count-1 do begin
        if Formaters[i].Supports(UserFormat) then begin
          Formater := Formaters[i];
          break;
        end;
      end;

      if Formater <> nil then
        sb.Append(Formater.Convert(UserFormat))
      else //unknown format
        raise new SugarFormatException("Unknown format specified: "+UserFormat);        
    end
    //escaped closing bracket
    else if (C = '}') and (Current < Value.Length) and (Value[Current] = '}') then begin
      AppendEscaped(Value, BlockStart, Current - BlockStart - 1, sb);
      BlockStart := Current;
      inc(Current);
    end
    //not escaped closing bracket
    else if C = '}' then
      raise new SugarFormatException(ErrorMessage.FORMAT_ERROR);
  end;

  //text left to copy
  if BlockStart < Value.Length then 
    AppendEscaped(Value, BlockStart, Value.Length - BlockStart, sb);
  exit sb.ToString();
end;

class method DateFormatter.GetFormaters: List<FormatSpecifier>;
begin
  result := new List<FormatSpecifier>;
  result.Add(new YearFormatSpecifier);
  result.Add(new MonthFormatSpecifier);
  result.Add(new DayFormatSpecifier);
  result.Add(new Hour12FormatSpecifier);
  result.Add(new Hour24FormatSpecifier);
  result.Add(new MinuteFormatSpecifier);
  result.Add(new SecondFormatSpecifier);
  result.Add(new PeriodFormatSpecifier);
end;

method FormatSpecifier.RangeCheck(Value: String; C: Char; MaxLength: Integer): Boolean;
begin
  for i: Integer := 0 to Value.Length-1 do
    if Value[i] <> C then
      exit false;

  if Value.Length > MaxLength then
    exit false;

  exit true;
end;

method SimpleFormatSpecifier.Supports(Value: String): Boolean;
begin
  exit RangeCheck(Value, CodeChar, MaxLength);
end;

method SimpleFormatSpecifier.Convert(Value: String): String;
begin
  {$IF ECHOES}
  if Value.Length = 1 then
    exit "%"+Value;
  {$ENDIF}

  exit Value;
end;

method DayFormatSpecifier.Convert(Value: String): String;
begin
  {$IF ECHOES}
  exit inherited Convert(Value);
  {$ELSE}
  if Value.Length <= 2 then
    exit Value;

  exit new StringBuilder().Append('E', Value.Length).toString;
  {$ENDIF}
end;

method PeriodFormatSpecifier.Convert(Value: String): String;
begin
  {$IF ECHOES}exit "tt";{$ELSE}exit Value;{$ENDIF}
end;

method YearFormatSpecifier.Supports(Value: String): Boolean;
begin
  result := inherited Supports(Value);

  if Value.Length in [1, 3] then
    exit false;
end;

end.
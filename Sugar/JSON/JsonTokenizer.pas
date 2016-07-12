namespace Sugar.Json;

interface

uses
  Sugar;

type
  JsonTokenizer = public class
  private
    fData: array of Char := nil;
    fPos: Integer;
    fLastRow: Integer;
    fRow: Integer;
    fLastRowStart: Integer;
    fRowStart: Integer;
    fLength: Integer;

    method CharIsIdentifier(C: Char): Boolean;
    method CharIsWhitespace(C: Char): Boolean;

    method Parse;
    method ParseIdentifier;
    method ParseWhitespace;
    method ParseNumber;
    method ParseString;
  public
    constructor (aJson: String);
    constructor (aJson: String; SkipWhitespaces: Boolean);

    method Next: Boolean;
    
    property Json: String; readonly;

    property Row: Integer read fLastRow + 1;
    property Column: Integer read fPos - fLastRowStart + 1;
    property Value: String read private write;
    property Token: JsonTokenKind read private write;
    property IgnoreWhitespaces: Boolean read write; readonly;
  end;

implementation

constructor JsonTokenizer(aJson: String);
begin
  constructor(aJson, true);
end;

constructor JsonTokenizer(aJson: String; SkipWhitespaces: Boolean);
begin
  Json := aJson;
  SugarArgumentNullException.RaiseIfNil(Json, "Json");
  self.IgnoreWhitespaces := SkipWhitespaces;
  var CharData := Json.ToCharArray;
  fData := new Char[CharData.Length + 4];
  {$IF COOPER}
  System.arraycopy(CharData, 0, fData, 0, CharData.Length);
  {$ELSEIF ECHOES}
  Array.Copy(CharData, 0, fData, 0, CharData.Length);
  {$ELSEIF TOFFEE}
  rtl.memset(@fData[0], 0, fData.length);
  memcpy(@fData[0], @CharData[0], sizeOf(Char) * CharData.Length);
  {$ENDIF} 
  Token := JsonTokenKind.BOF;
end;

method JsonTokenizer.CharIsIdentifier(C: Char): Boolean;
begin
  exit (((C >= 'a') and (C <= 'z')) or ((C >= 'A') and (C <= 'Z')) or (C = '_'));
end;

method JsonTokenizer.CharIsWhitespace(C: Char): Boolean;
begin
  exit (C = ' ') or (C = #13) or (C = #10) or (C = #9);
end;

method JsonTokenizer.Parse;
begin
  if CharIsIdentifier(fData[fPos]) then
    ParseIdentifier
  else begin
    case fData[fPos] of
      ' ', #9, #13, #10: ParseWhitespace;
      JsonConsts.VALUE_SEPARATOR: begin
             fLength := 1;
             Value := nil;
             Token := JsonTokenKind.ValueSeperator;
           end;
      JsonConsts.ARRAY_START: begin
             fLength := 1;
             Value := nil;
             Token := JsonTokenKind.ArrayStart;
           end;
      JsonConsts.ARRAY_END: begin
             fLength := 1;
             Value := nil;
             Token := JsonTokenKind.ArrayEnd;
           end;
      JsonConsts.OBJECT_START: begin
             fLength := 1;
             Value := nil;
             Token := JsonTokenKind.ObjectStart;
           end;
      JsonConsts.OBJECT_END: begin
             fLength := 1;
             Value := nil;
             Token := JsonTokenKind.ObjectEnd;
           end;
      JsonConsts.NAME_SEPARATOR: begin
             fLength := 1;
             Value := nil;
             Token := JsonTokenKind.NameSeperator;
           end;
      '-', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.': ParseNumber;
      JsonConsts.STRING_QUOTE: ParseString;
      #0: begin
            fLength := 0;
            Value := nil;
            Token := JsonTokenKind.EOF;
          end;
      else begin
        fLength := 0;
        Token := JsonTokenKind.SyntaxError;
      end;
    end;
  end;
end;

method JsonTokenizer.Next: Boolean;
begin
  if Token = JsonTokenKind.EOF then
    exit false;

  while true do begin
    fPos := fPos + fLength;
    fLastRow := fRow;
    fLastRowStart := fRowStart;
    Parse;

    if (Token = JsonTokenKind.EOF) or (Token = JsonTokenKind.SyntaxError) then
     exit false;

    if IgnoreWhitespaces and (Token = JsonTokenKind.Whitespace) then
      continue;

    exit true;
  end;
end;

method JsonTokenizer.ParseWhitespace;
begin
  if not CharIsWhitespace(fData[fPos]) then
    exit;

  var lPosition := fPos;

  while CharIsWhitespace(fData[lPosition]) do begin
    if fData[lPosition] = #13 then begin
      if fData[lPosition + 1] = #10 then
        inc(lPosition);

      fRowStart := lPosition + 1;
      inc(fRow);
    end
    else if fData[lPosition] = #10 then begin
      fRowStart := lPosition + 1;
      inc(fRow);
    end;

    inc(lPosition);
  end;

  fLength := lPosition - fPos;
  Value := nil;
  Token := JsonTokenKind.Whitespace;
end;

method JsonTokenizer.ParseNumber;
begin
  var hs: Boolean := false;
  var lPosition := fPos;

  if fData[lPosition] = '-' then
    inc(lPosition);

  while ((fData[lPosition] >= '0') and (fData[lPosition] <= '9')) or (fData[lPosition] = '.') do begin
    inc(lPosition);

    if (fData[lPosition] = '.') and (not hs) and ((fData[lPosition + 1] >= '0') and (fData[lPosition + 1] <= '9')) then begin
      hs := true;
      inc(lPosition);
    end;
  end;

  if (fData[lPosition] = 'e') or (fData[lPosition] = 'E') then begin
    inc(lPosition);
    
    if (fData[lPosition] = '-') or (fData[lPosition] = '+') then
      inc(lPosition);

    while (fData[lPosition] >= '0') and (fData[lPosition] <= '9') do
      inc(lPosition);
  end;

  Token := JsonTokenKind.Number;
  fLength := lPosition - fPos;
  Value := new String(fData, fPos, fLength);
end;

method JsonTokenizer.ParseString;
begin
  var sb := new StringBuilder;
  var lPosition := fPos + 1;

  while (fData[lPosition] <> #0) and (fData[lPosition] <> '"') do begin
    
    if fData[lPosition] = '\' then begin
      inc(lPosition);

      case fData[lPosition] of
        '\': sb.Append("\");
        '"': sb.Append("""");
        '/': sb.Append("/");
        'b': sb.Append(#8);
        'f': sb.Append(#12);
        'r': sb.Append(#13);
        'n': sb.Append(#10);
        't': sb.Append(#9);
        'u': if fData.Length > lPosition+4 then begin
               var lHex := fData[lPosition+1]+fData[lPosition+2]+fData[lPosition+3]+fData[lPosition+4];
               var lValue := Convert.HexStringToInt32(lHex);
               sb.Append(Char(lValue));
               lPosition := lPosition + 4;
              end;
      end;
    end
    else 
      sb.Append(fData[lPosition]);

    inc(lPosition);
  end;

  Value := sb.ToString;
  Token := JsonTokenKind.String;
  fLength := lPosition - fPos + 1;
end;

method JsonTokenizer.ParseIdentifier;
begin  
  var lPosition := fPos + 1;

  while CharIsIdentifier(fData[lPosition]) do
    inc(lPosition);

  fLength := lPosition - fPos;
  Value := new String(fData, fPos, fLength);
  case Value of 
    JsonConsts.NULL_VALUE: Token := JsonTokenKind.Null;
    JsonConsts.TRUE_VALUE: Token := JsonTokenKind.True;    
    JsonConsts.FALSE_VALUE: Token := JsonTokenKind.False;
    else Token := JsonTokenKind.Identifier;
  end;
end;

end.
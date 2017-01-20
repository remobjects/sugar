namespace Sugar.RegularExpressions;

interface

uses
  Sugar.Collections;

type
  Match = public class {$IF     COOPER}mapped to java.util.regex.Matcher
                       {$ELSEIF ECHOES}mapped to System.Text.RegularExpressions.Match{$ENDIF}
  protected
    {$IF TOFFEE}
    fInput: String;
    fMatch: NSTextCheckingResult;
    {$ENDIF}
    method GetEnd: Integer;
    method GetGroups: List<&Group>;
    method GetLength: Integer;
    method GetStart: Integer;
    method GetText: String;
  public
    {$IF TOFFEE}
    constructor(PlatformMatch: NSTextCheckingResult; Input: String);
    {$ENDIF}
    method FindNext: Match;

    property &End: Integer read GetEnd;
    property Groups: List<&Group> read GetGroups;
    property Length: Integer read GetLength;
    property Start: Integer read GetStart;
    property Text: String read GetText;
end;

implementation

{$IF TOFFEE}
constructor Match(PlatformMatch: NSTextCheckingResult; Input: String);
begin
  fMatch := PlatformMatch;
  fInput := Input;
end;
{$ENDIF}

method Match.FindNext: Match;
begin
  {$IF COOPER}
  exit if mapped.find() then mapped else nil;
  {$ELSEIF ECHOES}
  var NextMatch: System.Text.RegularExpressions.Match := mapped.NextMatch();
  exit if NextMatch.Success then NextMatch else nil;
  {$ELSEIF TOFFEE}
  var Offset: Integer := fMatch.range.location + fMatch.range.length;
  var NextMatch: NSTextCheckingResult := fMatch.regularExpression.
    firstMatchInString(fInput)
    options(NSMatchingOptions(0))
    range(NSMakeRange(Offset, fInput.length - Offset));
  exit if NextMatch <> nil then new Match(NextMatch, fInput) else nil;
  {$ENDIF}
end;

method Match.GetEnd: Integer;
begin
  {$IF COOPER}
  exit mapped.end() - 1;
  {$ELSEIF ECHOES}
  exit mapped.Index + mapped.Length - 1;
  {$ELSEIF TOFFEE}
  exit fMatch.range.location + fMatch.range.length - 1;
  {$ENDIF}
end;

method Match.GetGroups: List<&Group>;
begin
  var GroupCount: Integer;
  var Results: List<&Group> := new List<&Group>();

  {$IF COOPER}
  GroupCount := mapped.groupCount() + 1;
  {$ELSEIF ECHOES}
  GroupCount := mapped.Groups.Count;
  {$ELSEIF TOFFEE}
  GroupCount := fMatch.numberOfRanges;
  {$ENDIF}

  for I: Integer := 1 to GroupCount - 1 do
    Results.Add(
      {$IF COOPER}
      if mapped.group(I) <> nil then
        new &Group(mapped.start(I), mapped.end(I) - mapped.start(I), mapped.group(I))
      {$ELSEIF ECHOES}
      if mapped.Groups.Item[I].Success then
        new &Group(mapped.Groups.Item[I].Index, mapped.Groups.Item[I].Length, mapped.Groups.Item[I].Value)
      {$ELSEIF TOFFEE}
      if fMatch.rangeAtIndex(I).location <> NSNotFound then
        new &Group(fMatch.rangeAtIndex(I).location,
                   fMatch.rangeAtIndex(I).length,
                   fInput.substringWithRange(fMatch.rangeAtIndex(I)))
      {$ENDIF}
      else nil
    );

  exit Results;
end;

method Match.GetLength: Integer;
begin
  {$IF COOPER}
  exit mapped.end() - mapped.start();
  {$ELSEIF ECHOES}
  exit mapped.Length;
  {$ELSEIF TOFFEE}
  exit fMatch.range.length;
  {$ENDIF}
end;

method Match.GetStart: Integer;
begin
  {$IF COOPER}
  exit mapped.start();
  {$ELSEIF ECHOES}
  exit mapped.Index;
  {$ELSEIF TOFFEE}
  exit fMatch.range.location;
  {$ENDIF}
end;

method Match.GetText: String;
begin
  {$IF COOPER}
  exit mapped.group();
  {$ELSEIF ECHOES}
  exit mapped.Value;
  {$ELSEIF TOFFEE}
  exit fInput.substringWithRange(fMatch.range);
  {$ENDIF}
end;

end.
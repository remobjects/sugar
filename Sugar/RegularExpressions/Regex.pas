namespace Sugar.RegularExpressions;

interface

uses
  Sugar.Collections;

type
  RegexOptions = public flags (IgnoreCase, IgnoreWhitespace, Multiline, Singleline);

  Regex = public class mapped to {$IF     COOPER}java.util.regex.Pattern
                                 {$ELSEIF ECHOES}System.Text.RegularExpressions.Regex
                                 {$ELSEIF TOFFEE}NSRegularExpression{$ENDIF}
  private
    class method OptionsToBitfield(PatternOptions: RegexOptions): Integer;
  public
    constructor(Pattern: String; PatternOptions: RegexOptions);
    constructor(Pattern: String);
    method FindFirstMatch(Input: String): Match;
    method FindMatches(Input: String): List<Match>;
    method IsMatch(Input: String): Boolean;
    method ReplaceMatches(Input: String; Replacement: String): String;
  end;

implementation

constructor Regex(Pattern: String; PatternOptions: RegexOptions);
begin
  var Bitfield: Integer := OptionsToBitfield(PatternOptions);

  {$IF COOPER}
  exit java.util.regex.Pattern.compile(Pattern, Bitfield);
  {$ELSEIF ECHOES}
  exit new System.Text.RegularExpressions.Regex(Pattern, System.Text.RegularExpressions.RegexOptions(Bitfield));
  {$ELSEIF TOFFEE}
  var Error: NSError;
  exit NSRegularExpression.regularExpressionWithPattern(Pattern)
                           options(NSRegularExpressionOptions(Bitfield))
                           error(var Error);
  {$ENDIF}
end;

constructor Regex(Pattern: String);
begin
  constructor(Pattern, RegexOptions(0));
end;

method Regex.FindFirstMatch(Input: String): Match;
begin
  {$IF COOPER}
  var Matcher: java.util.regex.Matcher := mapped.matcher(Input);
  exit if Matcher.find() then Matcher else nil;
  {$ELSEIF ECHOES}
  var FirstMatch: System.Text.RegularExpressions.Match := mapped.Match(Input);
  exit if FirstMatch.Success then FirstMatch else nil;
  {$ELSEIF TOFFEE}
  var FirstMatch: NSTextCheckingResult := mapped.firstMatchInString(Input)
                                                 options(NSMatchingOptions(0))
                                                 range(NSMakeRange(0, Input.length));
  exit if FirstMatch <> nil then new Match(FirstMatch, Input) else nil;
  {$ENDIF}
end;

method Regex.FindMatches(Input: String): List<Match>;
begin
  var Matches: List<Match> := new List<Match>();

  {$IF COOPER}
  var Matcher: java.util.regex.Matcher := mapped.matcher(Input);
  while (Matcher.find()) do
    Matches.Add(Match(Matcher.toMatchResult()));
  {$ELSEIF ECHOES}
  var PlatformMatches: System.Text.RegularExpressions.MatchCollection := mapped.Matches(Input);
  for PlatformMatch in PlatformMatches do
    Matches.Add(Match(PlatformMatch));
  {$ELSEIF TOFFEE}
  var PlatformMatches: NSArray := mapped.matchesInString(Input)
                                         options(NSMatchingOptions(0))
                                         range(NSMakeRange(0, Input.length));
  for PlatformMatch in PlatformMatches do
    Matches.Add(new Match(PlatformMatch, Input));
  {$ENDIF}

  exit Matches;
end;

method Regex.IsMatch(Input: String): Boolean;
begin
  {$IF COOPER}
  exit mapped.matcher(Input).find();
  {$ELSEIF ECHOES}
  exit mapped.IsMatch(Input);
  {$ELSEIF TOFFEE}
  var MatchCount: Integer := mapped.numberOfMatchesInString(Input)
                                    options(NSMatchingOptions(0))
                                    range(NSMakeRange(0, Input.length));
  exit MatchCount > 0;
  {$ENDIF}
end;

class method Regex.OptionsToBitfield(PatternOptions: RegexOptions): Integer;
begin
  var Bitfield: Integer := 0;

  if RegexOptions.IgnoreCase in PatternOptions then Bitfield := Bitfield or
    {$IF     COOPER}java.util.regex.Pattern.CASE_INSENSITIVE
    {$ELSEIF ECHOES}System.Text.RegularExpressions.RegexOptions.IgnoreCase
    {$ELSEIF TOFFEE}NSRegularExpressionOptions.NSRegularExpressionCaseInsensitive{$ENDIF};
  if RegexOptions.IgnoreWhitespace in PatternOptions then Bitfield := Bitfield or
    {$IF     COOPER}java.util.regex.Pattern.COMMENTS
    {$ELSEIF ECHOES}System.Text.RegularExpressions.RegexOptions.IgnorePatternWhitespace
    {$ELSEIF TOFFEE}NSRegularExpressionOptions.NSRegularExpressionAllowCommentsAndWhitespace{$ENDIF};
  if RegexOptions.Multiline in PatternOptions then Bitfield := Bitfield or
    {$IF     COOPER}java.util.regex.Pattern.MULTILINE
    {$ELSEIF ECHOES}System.Text.RegularExpressions.RegexOptions.Multiline
    {$ELSEIF TOFFEE}NSRegularExpressionOptions.NSRegularExpressionAnchorsMatchLines{$ENDIF};
  if RegexOptions.Singleline in PatternOptions then Bitfield := Bitfield or
    {$IF     COOPER}java.util.regex.Pattern.DOTALL
    {$ELSEIF ECHOES}System.Text.RegularExpressions.RegexOptions.Singleline
    {$ELSEIF TOFFEE}NSRegularExpressionOptions.NSRegularExpressionDotMatchesLineSeparators{$ENDIF};

  exit Bitfield;
end;

method Regex.ReplaceMatches(Input: String; Replacement: String): String;
begin
  {$IF COOPER}
  exit mapped.matcher(Input).replaceAll(Replacement);
  {$ELSEIF ECHOES}
  exit mapped.Replace(Input, Replacement);
  {$ELSEIF TOFFEE}
  exit mapped.stringByReplacingMatchesInString(Input)
              options(NSMatchingOptions(0))
              range(NSMakeRange(0, Input.length))
              withTemplate(Replacement);
  {$ENDIF}
end;

end.

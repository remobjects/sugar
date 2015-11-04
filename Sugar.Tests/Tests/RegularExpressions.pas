namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.Collections,
  Sugar.RegularExpressions,
  RemObjects.Elements.EUnit;

type
  RegularExpressionsTest = public class (Test)
  private
    const ContactNumbers: String = "Voice: (425) 555-1234. Fax: (206) 555-5678.";
    const PhoneNumberPattern: String = "\((\d{3})\) (\d{3}-\d{4})";
    const PhoneNumberTypePattern: String = "([a-zA-Z]+):";
  public
    method FindMatchesSequentially;
    method FindMatchesAllAtOnce;
    method IgnoreCase;
    method IgnoreWhitespace;
    method Multiline;
    method ReplaceMatches;
    method Singleline;
  end;

implementation

method RegularExpressionsTest.FindMatchesSequentially;
begin
  var FirstMatch: Match := new Regex(PhoneNumberPattern).FindFirstMatch(ContactNumbers);
  Assert.IsNotNil(FirstMatch);
  Assert.AreEqual(FirstMatch.Start,  7);
  Assert.AreEqual(FirstMatch.End,    20);
  Assert.AreEqual(FirstMatch.Length, 14);
  Assert.AreEqual(FirstMatch.Text,   "(425) 555-1234");
  Assert.AreEqual(FirstMatch.Groups.Count, 2);
  Assert.AreEqual(FirstMatch.Groups.Item[0].Start,  8);
  Assert.AreEqual(FirstMatch.Groups.Item[0].End,    10);
  Assert.AreEqual(FirstMatch.Groups.Item[0].Length, 3);
  Assert.AreEqual(FirstMatch.Groups.Item[0].Text,   "425");
  Assert.AreEqual(FirstMatch.Groups.Item[1].Start,  13);
  Assert.AreEqual(FirstMatch.Groups.Item[1].End,    20);
  Assert.AreEqual(FirstMatch.Groups.Item[1].Length, 8);
  Assert.AreEqual(FirstMatch.Groups.Item[1].Text,   "555-1234");

  var SecondMatch: Match := FirstMatch.FindNext();
  Assert.IsNotNil(SecondMatch);
  Assert.AreEqual(SecondMatch.Start,  28);
  Assert.AreEqual(SecondMatch.End,    41);
  Assert.AreEqual(SecondMatch.Length, 14);
  Assert.AreEqual(SecondMatch.Text,   "(206) 555-5678");
  Assert.AreEqual(SecondMatch.Groups.Count, 2);
  Assert.AreEqual(SecondMatch.Groups.Item[0].Start,  29);
  Assert.AreEqual(SecondMatch.Groups.Item[0].End,    31);
  Assert.AreEqual(SecondMatch.Groups.Item[0].Length, 3);
  Assert.AreEqual(SecondMatch.Groups.Item[0].Text,   "206");
  Assert.AreEqual(SecondMatch.Groups.Item[1].Start,  34);
  Assert.AreEqual(SecondMatch.Groups.Item[1].End,    41);
  Assert.AreEqual(SecondMatch.Groups.Item[1].Length, 8);
  Assert.AreEqual(SecondMatch.Groups.Item[1].Text,   "555-5678");

  Assert.IsNil(SecondMatch.FindNext());
end;

method RegularExpressionsTest.FindMatchesAllAtOnce;
begin
  var Matches: List<Match> := new Regex(PhoneNumberTypePattern).FindMatches(ContactNumbers);
  Assert.AreEqual(Matches.Count, 2);

  Assert.AreEqual(Matches.Item[0].Start,  0);
  Assert.AreEqual(Matches.Item[0].End,    5);
  Assert.AreEqual(Matches.Item[0].Length, 6);
  Assert.AreEqual(Matches.Item[0].Text,   "Voice:");
  Assert.AreEqual(Matches.Item[0].Groups.Count, 1);
  Assert.AreEqual(Matches.Item[0].Groups.Item[0].Start,  0);
  Assert.AreEqual(Matches.Item[0].Groups.Item[0].End,    4);
  Assert.AreEqual(Matches.Item[0].Groups.Item[0].Length, 5);
  Assert.AreEqual(Matches.Item[0].Groups.Item[0].Text,   "Voice");

  Assert.AreEqual(Matches.Item[1].Start,  23);
  Assert.AreEqual(Matches.Item[1].End,    26);
  Assert.AreEqual(Matches.Item[1].Length, 4);
  Assert.AreEqual(Matches.Item[1].Text,   "Fax:");
  Assert.AreEqual(Matches.Item[1].Groups.Count, 1);
  Assert.AreEqual(Matches.Item[1].Groups.Item[0].Start,  23);
  Assert.AreEqual(Matches.Item[1].Groups.Item[0].End,    25);
  Assert.AreEqual(Matches.Item[1].Groups.Item[0].Length, 3);
  Assert.AreEqual(Matches.Item[1].Groups.Item[0].Text,   "Fax");
end;

method RegularExpressionsTest.IgnoreCase;
const
  Pattern: String = "FAX: (" + PhoneNumberPattern + ")";
begin
  var CaseSensitiveRegex := new Regex(Pattern);
  Assert.IsFalse(CaseSensitiveRegex.IsMatch(ContactNumbers));

  var CaseInsensitiveRegex := new Regex(Pattern, RegexOptions.IgnoreCase);
  Assert.IsTrue(CaseInsensitiveRegex.IsMatch(ContactNumbers));
end;

method RegularExpressionsTest.IgnoreWhitespace;
begin
  var RegexWithWhitespace := new Regex(PhoneNumberPattern);
  Assert.IsTrue(RegexWithWhitespace.IsMatch(ContactNumbers));
  Assert.IsFalse(RegexWithWhitespace.IsMatch(ContactNumbers.Replace(" ", "")));

  var RegexWithoutWhitespace := new Regex(PhoneNumberPattern, RegexOptions.IgnoreWhitespace);
  Assert.IsFalse(RegexWithoutWhitespace.IsMatch(ContactNumbers));
  Assert.IsTrue(RegexWithoutWhitespace.IsMatch(ContactNumbers.Replace(" ", "")));
end;

method RegularExpressionsTest.Multiline;
const
  DelimitedPhoneNumberPattern: String = "^" + PhoneNumberPattern + "$";
begin
  var MultilineContactNumbers: String := ContactNumbers.Replace(": ", ":"#10).Replace(". ", #10);

  var NonMultilineRegex := new Regex(DelimitedPhoneNumberPattern);
  Assert.IsFalse(NonMultilineRegex.IsMatch(ContactNumbers));
  Assert.IsFalse(NonMultilineRegex.IsMatch(MultilineContactNumbers));

  var MultilineRegex := new Regex(DelimitedPhoneNumberPattern, RegexOptions.Multiline);
  Assert.IsFalse(MultilineRegex.IsMatch(ContactNumbers));
  Assert.IsTrue(MultilineRegex.IsMatch(MultilineContactNumbers));
end;

method RegularExpressionsTest.ReplaceMatches;
const
  FaxPattern: String = "Fax:";
  VoicePattern: String = "Voice:";
begin
  var FaxRegex: Regex := new Regex(FaxPattern);
  var VoiceRegex: Regex := new Regex(VoicePattern);
  var AlteredContactNumbers: String := VoiceRegex.ReplaceMatches(ContactNumbers, FaxPattern);

  Assert.AreEqual(FaxRegex.FindMatches(ContactNumbers).Count, 1);
  Assert.AreEqual(VoiceRegex.FindMatches(ContactNumbers).Count, 1);
  Assert.AreEqual(FaxRegex.FindMatches(AlteredContactNumbers).Count, 2);
  Assert.AreEqual(VoiceRegex.FindMatches(AlteredContactNumbers).Count, 0);
end;

method RegularExpressionsTest.Singleline;
begin
  var MultilineContactNumbers: String := ContactNumbers.Replace(": ", ":"#10).Replace(". ", #10);

  var NonSinglelineRegex := new Regex(PhoneNumberTypePattern + ".");
  Assert.IsTrue(NonSinglelineRegex.IsMatch(ContactNumbers));
  Assert.IsFalse(NonSinglelineRegex.IsMatch(MultilineContactNumbers));

  var SinglelineRegex := new Regex(PhoneNumberTypePattern + ".", RegexOptions.Singleline);
  Assert.IsTrue(SinglelineRegex.IsMatch(ContactNumbers));
  Assert.IsTrue(SinglelineRegex.IsMatch(MultilineContactNumbers));
end;

end.

namespace Sugar.Test;

interface

{$HIDE W0} //supress case-mismatch errors

uses
  RemObjects.Oxygene.Sugar,
  RemObjects.Oxygene.Sugar.TestFramework;

type
  StringTest = public class (Testcase)
  private
    Data: String;
  public
    method Setup; override;
    method TestLength;
    method TesChars;
    method TestContactenation;
    method TestImplicistCast;
    method TestFormat; empty; //empty for now
    method TestCharacterIsWhiteSpace;
    method TestIsNullOrEmpty;
    method TestIsNullOrWhiteSpace;
    method TestFromByteArray;
    method TestCompareTo;
    method TestCompareToIgnoreCase;
    method TestEquals;
    method TestEqualsIngoreCase;
    method TestContains;
    method TestIndexOf;
    method TestLastIndexOf;
    method TestSubstring;
    method TestSplit;
    method TestReplace;
    method TestLowerUpperCase;
    method TestTrim;
    method TestStartsWith;
    method TestEndsWith;
    method TestToByteArray;
  end;

implementation

method StringTest.Setup;
begin
  Data := "Hello";
end;

method StringTest.TestLength;
begin
  Assert.CheckInt(5, Data.Length);
end;

method StringTest.TesChars;
begin
  Assert.CheckString('e', Data.Chars[1]); //chars property
  Assert.CheckString('o', Data[4]);//default property
  Assert.IsException(->Data.Chars[244]);//out of range
end;

method StringTest.TestContactenation;
begin
  //Native string
  var NativeString := Data + " World";
  Assert.CheckInt(11, NativeString.Length);
  Assert.CheckString("Hello World", NativeString);
  //Sugar string
  var SugarString: RemObjects.Oxygene.Sugar.String := Data + " World";
  Assert.CheckInt(11, SugarString.Length);
  Assert.CheckString("Hello World", SugarString);
end;

method StringTest.TestImplicistCast;
begin
  var C: Char := 'x';
  var SugarString: RemObjects.Oxygene.Sugar.String := C;
  Assert.CheckString("x", SugarString);
end;

method StringTest.TestCharacterIsWhiteSpace;
begin
  Assert.CheckBool(false, String.CharacterIsWhiteSpace(Data[2]));
  Assert.CheckBool(true, String.CharacterIsWhiteSpace(' '));
  Assert.CheckBool(false, String.CharacterIsWhiteSpace('x'));
end;

method StringTest.TestIsNullOrEmpty;
begin
  Assert.CheckBool(false, String.IsNullOrEmpty(Data));
  Assert.CheckBool(true, String.IsNullOrEmpty(nil));
  Assert.CheckBool(true, String.IsNullOrEmpty(""));
end;

method StringTest.TestIsNullOrWhiteSpace;
begin
  Assert.CheckBool(false, String.IsNullOrWhiteSpace(Data));
  Assert.CheckBool(true, String.IsNullOrWhiteSpace(nil));
  Assert.CheckBool(true, String.IsNullOrWhiteSpace(""));
  Assert.CheckBool(true, String.IsNullOrWhiteSpace("       "));
end;

method StringTest.TestFromByteArray;
begin
  var Encoded: array of Byte := [103, 114, 195, 182, 195, 159, 101, 114, 101, 110];
  var Expected: String := "größeren";
  var Actual: String := String.FromByteArray(Encoded);
  Assert.CheckInt(8, Actual.Length);
  Assert.CheckString(Expected, Actual);
end;

method StringTest.TestCompareTo;
begin
  Assert.CheckInt(0, Data.CompareTo("Hello"));
  Assert.CheckBool(true, Data.CompareTo("hElLo") <> 0); //Case sensitive
  Assert.CheckBool(true, Data.CompareTo(nil) <> 0);
  Assert.CheckBool(true, Data.CompareTo('') <> 0);
  var Sample: String := "A";
  Assert.CheckBool(true, Sample.CompareTo("B") < 0); //A is less than B
  Assert.CheckBool(true, Sample.CompareTo("a") < 0); //A is less than a
end;

method StringTest.TestCompareToIgnoreCase;
begin
  Assert.CheckInt(0, Data.CompareToIgnoreCase("Hello"));
  Assert.CheckInt(0, Data.CompareToIgnoreCase("hElLo"));
  var Sample: String := "A";
  Assert.CheckBool(true, Sample.CompareToIgnoreCase("B") < 0); //A is less than B
  Assert.CheckInt(0, Sample.CompareToIgnoreCase("a")); //A equals a
end;

method StringTest.TestEquals;
begin
  Assert.CheckBool(true, Data.Equals(Data));
  Assert.CheckBool(true, Data.Equals("Hello"));
  Assert.CheckBool(false, Data.Equals("hElLo"));
  Assert.CheckBool(false, Data.Equals(nil));
end;

method StringTest.TestEqualsIngoreCase;
begin
  Assert.CheckBool(true, Data.EqualsIngoreCase(Data));
  Assert.CheckBool(true, Data.EqualsIngoreCase("Hello"));
  Assert.CheckBool(true, Data.EqualsIngoreCase("hElLo"));
  Assert.CheckBool(false, Data.EqualsIngoreCase(nil));
end;

method StringTest.TestContains;
begin
  Assert.CheckBool(true, Data.Contains("Hello"));
  Assert.CheckBool(true, Data.Contains(Data));
  Assert.CheckBool(false, Data.Contains("hElLo")); //case sensitive
  Assert.CheckBool(true, Data.Contains('e'));
  Assert.CheckBool(false, Data.Contains('E'));
  Assert.CheckBool(true, Data.Contains("ll"));
  Assert.CheckBool(false, Data.Contains("lL"));
  Assert.CheckBool(true, Data.Contains("")); //true when check performed on empty string
  Assert.IsException(->Data.Contains(nil)); //should throw an exception
end;

method StringTest.TestIndexOf;
begin
  Assert.CheckInt(0, Data.IndexOf("Hello"));
  Assert.CheckInt(0, Data.IndexOf(Data));
  Assert.CheckInt(-1, Data.IndexOf("hElLo"));
  Assert.CheckInt(1, Data.IndexOf("e"));
  Assert.CheckInt(-1, Data.IndexOf("E"));
  Assert.CheckInt(1, Data.IndexOf('e'));
  Assert.CheckInt(-1, Data.IndexOf('E'));
  Assert.CheckInt(2, Data.IndexOf("l"));
  Assert.CheckInt(0, Data.IndexOf("")); //returns 0 if compared with empty string
  Assert.IsException(->Data.IndexOf(nil));//should throw an exception
end;

method StringTest.TestLastIndexOf;
begin
  Assert.CheckInt(0, Data.LastIndexOf("Hello"));
  Assert.CheckInt(0, Data.LastIndexOf(Data));
  Assert.CheckInt(-1, Data.LastIndexOf("hElLo"));
  Assert.CheckInt(1, Data.LastIndexOf("e"));
  Assert.CheckInt(-1, Data.LastIndexOf("E"));
  Assert.CheckInt(1, Data.LastIndexOf('e'));
  Assert.CheckInt(-1, Data.LastIndexOf('E'));
  Assert.CheckInt(3, Data.LastIndexOf("l")); //last 'l'
  Assert.CheckInt(Data.Length - 1, Data.LastIndexOf("")); //returns last index position in string if compared with empty string
  Assert.IsException(->Data.LastIndexOf(nil));//should throw an exception
end;

method StringTest.TestSubstring;
begin
  Assert.CheckString("lo", Data.Substring(3));
  Assert.CheckString(Data, Data.Substring(0)); //start index is zero based 
  Assert.CheckString("", Data.Substring(Data.Length)); //start index is equal to string length, should return empty string
  Assert.IsException(->Data.Substring(55)); //out of range

  Assert.CheckString("el", Data.Substring(1, 2));
  Assert.CheckString("", Data.Substring(Data.Length, 0)); //should be empty string if index equals to string length and length is 0
  Assert.IsException(->Data.Substring(55, 1));
  Assert.IsException(->Data.Substring(0, 244));
end;

method StringTest.TestSplit;
begin
  {$WARNING TestSplit is not completed due to compiler bug}
  var Original: String := "string; with; separator";
  {
    Should split:
    "" = no changes
    nil = no changes
    ";" = [string ]
    "; " = [string]
  }
  var Expected: array of String := ["string","with","separator"];
  
  var Actual := Original.Split("; ");
  Assert.CheckInt(3, length(Actual));
  //compiler bug: cannot assign string to system.string
  //for i: Integer := 0 to length(Actual)-1 do
  //  Assert.CheckString(Expected[i], Actual[i]);

  Actual := Original.Split(",");  
  Assert.CheckInt(1, length(Actual));
  var Value: String := Actual[0]; //bug workaround
  Assert.CheckString(Original, Value);
end;

method StringTest.TestReplace;
begin
  Assert.CheckString("HeLLo", Data.Replace("ll", "LL"));
  Assert.CheckString(Data, Data.Replace("x", "y")); //not existing
  Assert.CheckString(Data, Data.Replace("E", "x")); //case sensitive
  Assert.IsException(->Data.Replace("", "x"));
  Assert.IsException(->Data.Replace(nil, "x"));
  Assert.CheckString("Heo", Data.Replace("l", nil)); //remove
  Assert.CheckString("Heo", Data.Replace("l", "")); //remove
end;

method StringTest.TestLowerUpperCase;
begin
  Assert.CheckString("hello", Data.ToLower);
  Assert.CheckString("HELLO", Data.ToUpper);
end;

method StringTest.TestTrim;
begin
  var Original := "   Data    ";
  Assert.CheckString("Data", Original.Trim);
  Assert.CheckString("", String("").Trim);
  Assert.CheckString("", String("    ").Trim);
end;

method StringTest.TestStartsWith;
begin
  Assert.CheckBool(true, Data.StartsWith("Hell"));
  Assert.CheckBool(false, Data.StartsWith("x"));
  Assert.CheckBool(false, Data.StartsWith("hell"));
  Assert.IsException(->Data.StartsWith(nil));
  Assert.CheckBool(true, Data.StartsWith(""));
  Assert.CheckBool(true, Data.StartsWith(Data));
end;

method StringTest.TestEndsWith;
begin
  Assert.CheckBool(true, Data.EndsWith("llo"));
  Assert.CheckBool(false, Data.EndsWith("x"));
  Assert.CheckBool(false, Data.EndsWith("Llo"));
  Assert.IsException(->Data.EndsWith(nil));
  Assert.CheckBool(true, Data.EndsWith(""));
  Assert.CheckBool(true, Data.EndsWith(Data));
end;

method StringTest.TestToByteArray;
begin
  var Expected: array of Byte := [103, 114, 195, 182, 195, 159, 101, 114, 101, 110];
  
  var Value: String := "größeren";
  var Actual: array of Byte := Value.ToByteArray;

  Assert.CheckInt(10, length(Actual));
  for i: Int32 := 0 to length(Expected) -1 do
    Assert.CheckInt(Expected[i], Actual[i]);
end;

end.

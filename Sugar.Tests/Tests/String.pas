namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.TestFramework;

type
  StringTest = public class (Testcase)
  private
    Data: String;
  public
    method Setup; override;
    method LengthProperty;
    method CharsProperty;
    method Contactenation;
    method ImplicistCast;
    method Format;
    method CharacterIsWhiteSpace;
    method IsNullOrEmpty;
    method IsNullOrWhiteSpace;
    method FromByteArray;
    method CompareTo;
    method CompareToIgnoreCase;
    method &Equals;
    method EqualsIngoreCase;
    method Contains;
    method IndexOf;
    method LastIndexOf;
    method Substring;
    method Split;
    method Replace;
    method LowerUpperCase;
    method Trim;
    method StartsWith;
    method EndsWith;
    method ToByteArray;
    method Operators;
    method FromCharArray;
    method ToCharArray;
  end;

implementation

method StringTest.Setup;
begin
  Data := "Hello";
end;

method StringTest.LengthProperty;
begin
  Assert.CheckInt(5, Data.Length);
end;

method StringTest.CharsProperty;
begin
  Assert.CheckString('e', Data.Chars[1]); //chars property
  Assert.CheckString('o', Data[4]);//default property
  Assert.CheckString('H', Data[0]);  

  Assert.IsException(->Data.Chars[244]);//out of range
  Assert.IsException(->Data.Chars[5]);
  Assert.IsException(->Data.Chars[-1]);
end;

method StringTest.Contactenation;
begin
  //Native string
  var NativeString := Data + " World";
  Assert.CheckInt(11, NativeString.Length);
  Assert.CheckString("Hello World", NativeString);
  //Sugar string
  var SugarString: Sugar.String := Data + " World";
  Assert.CheckInt(11, SugarString.Length);
  Assert.CheckString("Hello World", SugarString);
end;

method StringTest.ImplicistCast;
begin
  var C: Char := 'x';
  var SugarString: Sugar.String := C;
  Assert.CheckString("x", SugarString);
end;

method StringTest.CharacterIsWhiteSpace;
begin
  Assert.CheckBool(false, String.CharacterIsWhiteSpace(Data[2]));
  Assert.CheckBool(true, String.CharacterIsWhiteSpace(' '));
  Assert.CheckBool(false, String.CharacterIsWhiteSpace('x'));
end;

method StringTest.Format;
begin
  Assert.CheckString("Hello", String.Format("{0}", "Hello"));
  Assert.CheckString("First Second Third", String.Format("First {0} Third", "Second"));
  Assert.CheckString("white is so white", String.Format("{0} is so {0}", "white"));
  Assert.CheckString("First Second Third", String.Format("{0} {1} {2}", "First", "Second", "Third"));

  //parameters are converted by using ToString method
  Assert.CheckString("42", String.Format("{0}", 42));  
  
  //accepts width
  Assert.CheckString("   Text", String.Format("{0,7}", "Text"));
  Assert.CheckString("Text   ", String.Format("{0,-7}", "Text"));

  //accepts format specifiers but the are ignored
  Assert.CheckString("255", String.Format("{0:X4}", 255));

  //all specifiers together
  Assert.CheckString("255  ", String.Format("{0,-5:X4}", 255));

  //escaping brackets
  Assert.CheckString("{42}", String.Format("{{{0}}}", 42));

  Assert.IsException(->String.Format("{0", ""));
  Assert.IsException(->String.Format("{0)", ""));
  Assert.IsException(->String.Format("(0}", ""));
  Assert.IsException(->String.Format("{0", ""));
  Assert.IsException(->String.Format("{0}", nil));
  Assert.IsException(->String.Format(nil, ""));  
  Assert.IsException(->String.Format("{a}", ""));
  Assert.IsException(->String.Format("{-1}", ""));
  Assert.IsException(->String.Format("{0", ""));
  Assert.IsException(->String.Format("{0,z}", ""));
  Assert.IsException(->String.Format("{0,f}", ""));
  Assert.IsException(->String.Format("{0,}", ""));  
end;

method StringTest.IsNullOrEmpty;
begin
  Assert.CheckBool(false, String.IsNullOrEmpty(Data));
  Assert.CheckBool(true, String.IsNullOrEmpty(nil));
  Assert.CheckBool(true, String.IsNullOrEmpty(""));
end;

method StringTest.IsNullOrWhiteSpace;
begin
  Assert.CheckBool(false, String.IsNullOrWhiteSpace(Data));
  Assert.CheckBool(true, String.IsNullOrWhiteSpace(nil));
  Assert.CheckBool(true, String.IsNullOrWhiteSpace(""));
  Assert.CheckBool(true, String.IsNullOrWhiteSpace("       "));
end;

method StringTest.FromByteArray;
begin
  var Encoded: array of Byte := [103, 114, 195, 182, 195, 159, 101, 114, 101, 110];
  var Expected: String := "größeren";
  var Actual: String := new String(Encoded, Encoding.UTF8);
  Assert.CheckInt(8, Actual.Length);
  Assert.CheckString(Expected, Actual);
  Encoded := [];
  Assert.CheckString("", new String(Encoded, Encoding.UTF8));
  Encoded := nil;
  Assert.IsException(-> new String(Encoded, Encoding.UTF8));
end;

method StringTest.CompareTo;
begin
  Assert.CheckInt(0, Data.CompareTo("Hello"));
  Assert.CheckBool(true, Data.CompareTo("hElLo") <> 0); //Case sensitive
  Assert.CheckBool(true, Data.CompareTo(nil) <> 0);
  Assert.CheckBool(true, Data.CompareTo('') <> 0);
  var Sample: String := "A";
  Assert.CheckBool(true, Sample.CompareTo("B") < 0); //A is less than B
  Assert.CheckBool(true, Sample.CompareTo("a") < 0); //A is less than a
end;

method StringTest.CompareToIgnoreCase;
begin
  Assert.CheckInt(0, Data.CompareToIgnoreCase("Hello"));
  Assert.CheckInt(0, Data.CompareToIgnoreCase("hElLo"));
  var Sample: String := "A";
  Assert.CheckBool(true, Sample.CompareToIgnoreCase("B") < 0); //A is less than B
  Assert.CheckInt(0, Sample.CompareToIgnoreCase("a")); //A equals a
end;

method StringTest.Equals;
begin
  Assert.CheckBool(true, Data.Equals(Data));
  Assert.CheckBool(true, Data.Equals("Hello"));
  Assert.CheckBool(false, Data.Equals("hElLo"));
  Assert.CheckBool(false, Data.Equals(nil));
end;

method StringTest.EqualsIngoreCase;
begin
  Assert.CheckBool(true, Data.EqualsIngoreCase(Data));
  Assert.CheckBool(true, Data.EqualsIngoreCase("Hello"));
  Assert.CheckBool(true, Data.EqualsIngoreCase("hElLo"));
  Assert.CheckBool(false, Data.EqualsIngoreCase(nil));
end;

method StringTest.Contains;
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

method StringTest.IndexOf;
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

method StringTest.LastIndexOf;
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

method StringTest.Substring;
begin
  Assert.CheckString("lo", Data.Substring(3));
  Assert.CheckString(Data, Data.Substring(0)); //start index is zero based 
  Assert.CheckString("", Data.Substring(Data.Length)); //start index is equal to string length, should return empty string
  Assert.IsException(->Data.Substring(55)); //out of range
  Assert.IsException(->Data.Substring(-1));

  Assert.CheckString("el", Data.Substring(1, 2));
  Assert.CheckString("", Data.Substring(Data.Length, 0)); //should be empty string if index equals to string length and length is 0
  Assert.CheckString("", Data.Substring(1, 0)); 
  Assert.IsException(->Data.Substring(55, 1));
  Assert.IsException(->Data.Substring(0, 244));
  Assert.IsException(->Data.Substring(-1, 1));
  Assert.IsException(->Data.Substring(1, -1));
end;

method StringTest.Split;
begin
  var Original: String := "x; x; x";
  var Actual := Original.Split("; ");
  
  Assert.CheckInt(3, length(Actual));
  for i: Integer := 0 to length(Actual)-1 do
    Assert.CheckString("x", Actual[i]);

  Actual := Original.Split(";");
  var Expected: array of String := ["x", " x", " x"];
  Assert.CheckInt(3, length(Actual));
  for i: Integer := 0 to length(Actual)-1 do
    Assert.CheckString(Expected[i], Actual[i]);

  Actual := Original.Split(","); //not exists
  Assert.CheckInt(1, length(Actual));
  Assert.CheckString(Original, Actual[0]);

  Actual := Original.Split(""); //no changes
  Assert.CheckInt(1, length(Actual));
  Assert.CheckString(Original, Actual[0]);  

  Actual := Original.Split(nil); //no changes
  Assert.CheckInt(1, length(Actual));
  Assert.CheckString(Original, Actual[0]);
end;

method StringTest.Replace;
begin
  Assert.CheckString("HeLLo", Data.Replace("ll", "LL"));
  Assert.CheckString(Data, Data.Replace("x", "y")); //not existing
  Assert.CheckString(Data, Data.Replace("E", "x")); //case sensitive
  Assert.IsException(->Data.Replace("", "x"));
  Assert.IsException(->Data.Replace(nil, "x"));
  Assert.CheckString("Heo", Data.Replace("l", nil)); //remove
  Assert.CheckString("Heo", Data.Replace("l", "")); //remove
end;

method StringTest.LowerUpperCase;
begin
  Assert.CheckString("hello", Data.ToLower);
  Assert.CheckString("HELLO", Data.ToUpper);
end;

method StringTest.Trim;
begin
  var Original: String := "   Data    ";
  Assert.CheckString("Data", Original.Trim);
  Assert.CheckString("", String("").Trim);
  Assert.CheckString("", String("    ").Trim);
end;

method StringTest.StartsWith;
begin
  Assert.CheckBool(true, Data.StartsWith("Hell"));
  Assert.CheckBool(false, Data.StartsWith("x"));
  Assert.CheckBool(false, Data.StartsWith("hell"));
  Assert.IsException(->Data.StartsWith(nil));
  Assert.CheckBool(true, Data.StartsWith(""));
  Assert.CheckBool(true, Data.StartsWith(Data));
end;

method StringTest.EndsWith;
begin
  Assert.CheckBool(true, Data.EndsWith("llo"));
  Assert.CheckBool(false, Data.EndsWith("x"));
  Assert.CheckBool(false, Data.EndsWith("Llo"));
  Assert.IsException(->Data.EndsWith(nil));
  Assert.CheckBool(true, Data.EndsWith(""));
  Assert.CheckBool(true, Data.EndsWith(Data));
end;

method StringTest.ToByteArray;
begin
  var Expected: array of Byte := [103, 114, 195, 182, 195, 159, 101, 114, 101, 110];
  
  var Value: String := "größeren";
  var Actual: array of Byte := Value.ToByteArray;

  Assert.CheckInt(10, length(Actual));
  for i: Int32 := 0 to length(Expected) -1 do
    Assert.CheckInt(Expected[i], Actual[i]);
end;

method StringTest.Operators;
begin
  Data := "A";
  var SugarString: String := "B";
  var NativeString := "B";

  Assert.CheckBool(true, Data < SugarString);
  Assert.CheckBool(true, Data < NativeString);
  Assert.CheckBool(true, SugarString > Data);
  Assert.CheckBool(true, NativeString > Data);
  
  Assert.CheckBool(false, Data > SugarString);
  Assert.CheckBool(false, Data > NativeString);
  Assert.CheckBool(false, SugarString < Data);
  Assert.CheckBool(false, NativeString < Data);

  Assert.CheckBool(true, Data <= SugarString);
  Assert.CheckBool(true, Data <= NativeString);
  Assert.CheckBool(true, SugarString >= Data);
  Assert.CheckBool(true, NativeString >= Data);
  
  Assert.CheckBool(false, Data >= SugarString);
  Assert.CheckBool(false, Data >= NativeString);
  Assert.CheckBool(false, SugarString <= Data);
  Assert.CheckBool(false, NativeString <= Data);

  Assert.CheckBool(false, Data = SugarString);
  Assert.CheckBool(false, Data = NativeString);
  Assert.CheckBool(false, SugarString = Data);
  Assert.CheckBool(false, NativeString = Data);
end;

method StringTest.FromCharArray;
begin
  var Encoded: array of Char := ['H', 'e', 'l', 'l', 'o'];
  var Expected: String := "Hello";
  var Actual: String := new String(Encoded);
  Assert.CheckInt(5, Actual.Length);
  Assert.CheckString(Expected, Actual);
  Encoded := [];
  Assert.CheckString("", new String(Encoded));
  Encoded := nil;
  Assert.IsException(-> new String(Encoded));
end;

method StringTest.ToCharArray;
begin
  var Expected: array of Char := ['g', 'r', 'ö', 'ß', 'e', 'r', 'e', 'n'];
  
  var Value: String := "größeren";
  var Actual: array of Char := Value.ToCharArray;

  Assert.CheckInt(Expected.Length, Actual.Length);
  for i: Int32 := 0 to Expected.Length -1 do
    Assert.CheckBool(true, Expected[i] = Actual[i], "Invalid character in ToCharArray");

  Value := "";
  Assert.CheckInt(0, Value.ToCharArray.Length);
end;

end.

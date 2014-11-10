namespace Sugar.Test;

interface

uses
  Sugar,
  RemObjects.Elements.EUnit;

type
  StringTest = public class (Test)
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
  Assert.AreEqual(Data.Length, 5);
  Data := "abc";
  Assert.AreEqual(Data.Length, 3);
  Assert.AreEqual(Sugar.String("").Length, 0);
end;

method StringTest.CharsProperty;
begin
  Assert.AreEqual(Data.Chars[1], 'e'); //chars property
  Assert.AreEqual(Data[4], 'o');//default property
  Assert.AreEqual(Data[0], 'H');

  Assert.Throws(->Data.Chars[244]);//out of range
  Assert.Throws(->Data.Chars[5]);
  Assert.Throws(->Data.Chars[-1]);
end;

method StringTest.Contactenation;
begin
  //Native string
  var NativeString := Data + " World";
  Assert.AreEqual(NativeString.Length, 11);
  Assert.AreEqual(NativeString, "Hello World");
  //Sugar string
  var SugarString: Sugar.String := Data + " World";
  Assert.AreEqual(SugarString.Length, 11);
  Assert.AreEqual(SugarString, "Hello World");
end;

method StringTest.ImplicistCast;
begin
  var C: Char := 'x';
  var SugarString: Sugar.String := C;
  Assert.AreEqual(SugarString, "x");
end;

method StringTest.CharacterIsWhiteSpace;
begin
  Assert.IsFalse(String.CharacterIsWhiteSpace(Data[2]));
  Assert.IsTrue(String.CharacterIsWhiteSpace(' '));
  Assert.IsFalse(String.CharacterIsWhiteSpace('x'));
end;

method StringTest.Format;
begin
  Assert.AreEqual(String.Format("{0}", "Hello"), "Hello");
  Assert.AreEqual(String.Format("First {0} Third", "Second"), "First Second Third");
  Assert.AreEqual(String.Format("{0} is so {0}", "white"), "white is so white");
  Assert.AreEqual(String.Format("{0} {1} {2}", "First", "Second", "Third"), "First Second Third");

  //parameters are converted by using ToString method
  Assert.AreEqual(String.Format("{0}", 42), "42");
  
  //accepts width
  Assert.AreEqual(String.Format("{0,7}", "Text"), "   Text");
  Assert.AreEqual(String.Format("{0,-7}", "Text"), "Text   ");

  //accepts format specifiers but the are ignored
  Assert.AreEqual(String.Format("{0:X4}", 255), "255");

  //all specifiers together
  Assert.AreEqual(String.Format("{0,-5:X4}", 255), "255  ");

  //escaping brackets
  Assert.AreEqual(String.Format("{{{0}}}", 42), "{42}");

  Assert.Throws(->String.Format("{0", ""));
  Assert.Throws(->String.Format("{0)", ""));
  Assert.Throws(->String.Format("(0}", ""));
  Assert.Throws(->String.Format("{0", ""));
  Assert.Throws(->String.Format("{0}", nil));
  Assert.Throws(->String.Format(nil, ""));  
  Assert.Throws(->String.Format("{a}", ""));
  Assert.Throws(->String.Format("{-1}", ""));
  Assert.Throws(->String.Format("{0", ""));
  Assert.Throws(->String.Format("{0,z}", ""));
  Assert.Throws(->String.Format("{0,f}", ""));
  Assert.Throws(->String.Format("{0,}", ""));  
end;

method StringTest.IsNullOrEmpty;
begin
  Assert.IsFalse(String.IsNullOrEmpty(Data));
  Assert.IsTrue(String.IsNullOrEmpty(nil));
  Assert.IsTrue(String.IsNullOrEmpty(""));
end;

method StringTest.IsNullOrWhiteSpace;
begin
  Assert.IsFalse(String.IsNullOrWhiteSpace(Data));
  Assert.IsTrue(String.IsNullOrWhiteSpace(nil));
  Assert.IsTrue(String.IsNullOrWhiteSpace(""));
  Assert.IsTrue(String.IsNullOrWhiteSpace("       "));
end;

method StringTest.FromByteArray;
begin
  var Encoded: array of Byte := [103, 114, 195, 182, 195, 159, 101, 114, 101, 110];
  var Expected: String := "größeren";
  var Actual: String := new String(Encoded, Encoding.UTF8);
  Assert.AreEqual(Actual.Length, 8);
  Assert.AreEqual(Actual, Expected);
  Encoded := [];
  Assert.AreEqual(new String(Encoded, Encoding.UTF8), "");
  Encoded := nil;
  Assert.Throws(-> new String(Encoded, Encoding.UTF8));
end;

method StringTest.CompareTo;
begin
  Assert.AreEqual(Data.CompareTo("Hello"), 0);
  Assert.AreNotEqual(Data.CompareTo("hElLo"), 0);//Case sensitive
  Assert.AreNotEqual(Data.CompareTo(nil), 0);
  Assert.AreNotEqual(Data.CompareTo(''), 0);
  var Sample: String := "A";
  
  Assert.Less(Sample.CompareTo("B"), 0); //A is less than B
  Assert.Less(Sample.CompareTo("a"), 0); //A is less than a
end;

method StringTest.CompareToIgnoreCase;
begin
  Assert.AreEqual(Data.CompareToIgnoreCase("Hello"), 0);
  Assert.AreEqual(Data.CompareToIgnoreCase("hElLo"), 0);
  var Sample: String := "A";
  Assert.Less(Sample.CompareToIgnoreCase("B"), 0); //A is less than B
  Assert.AreEqual(Sample.CompareToIgnoreCase("a"), 0); //A equals a
end;

method StringTest.Equals;
begin
  Assert.IsTrue(Data.Equals(Data));
  Assert.IsTrue(Data.Equals("Hello"));
  Assert.IsFalse(Data.Equals("hElLo"));
  Assert.IsFalse(Data.Equals(nil));
end;

method StringTest.EqualsIngoreCase;
begin
  Assert.IsTrue(Data.EqualsIngoreCase(Data));
  Assert.IsTrue(Data.EqualsIngoreCase("Hello"));
  Assert.IsTrue(Data.EqualsIngoreCase("hElLo"));
  Assert.IsFalse(Data.EqualsIngoreCase(nil));
end;

method StringTest.Contains;
begin
  Assert.IsTrue(Data.Contains("Hello"));
  Assert.IsTrue(Data.Contains(Data));
  Assert.IsFalse(Data.Contains("hElLo")); //case sensitive
  Assert.IsTrue(Data.Contains('e'));
  Assert.IsFalse(Data.Contains('E'));
  Assert.IsTrue(Data.Contains("ll"));
  Assert.IsFalse(Data.Contains("lL"));
  Assert.IsTrue(Data.Contains("")); //true when check performed on empty string
  Assert.Throws(->Data.Contains(nil)); //should throw an exception
end;

method StringTest.IndexOf;
begin
  Assert.AreEqual(Data.IndexOf("Hello"), 0);
  Assert.AreEqual(Data.IndexOf(Data), 0);
  Assert.AreEqual(Data.IndexOf("hElLo"), -1);
  Assert.AreEqual(Data.IndexOf("e"), 1);
  Assert.AreEqual(Data.IndexOf("E"), -1);
  Assert.AreEqual(Data.IndexOf('e'), 1);
  Assert.AreEqual(Data.IndexOf('E'), -1);
  Assert.AreEqual(Data.IndexOf("l"), 2);
  Assert.AreEqual(Data.IndexOf(""), 0); //returns 0 if compared with empty string
  Assert.Throws(->Data.IndexOf(nil));//should throw an exception
end;

method StringTest.LastIndexOf;
begin
  Assert.AreEqual(Data.LastIndexOf("Hello"), 0);
  Assert.AreEqual(Data.LastIndexOf(Data), 0);
  Assert.AreEqual(Data.LastIndexOf("hElLo"), -1);
  Assert.AreEqual(Data.LastIndexOf("e"), 1);
  Assert.AreEqual(Data.LastIndexOf("E"), -1);
  Assert.AreEqual(Data.LastIndexOf('e'), 1);
  Assert.AreEqual(Data.LastIndexOf('E'), -1);
  Assert.AreEqual(Data.LastIndexOf("l"), 3); //last 'l'
  Assert.AreEqual(Data.LastIndexOf(""), Data.Length - 1); //returns last index position in string if compared with empty string
  Assert.Throws(->Data.LastIndexOf(nil));//should throw an exception
end;

method StringTest.Substring;
begin
  Assert.AreEqual(Data.Substring(3), "lo");
  Assert.AreEqual(Data.Substring(0), Data); //start index is zero based 
  Assert.AreEqual(Data.Substring(Data.Length), ""); //start index is equal to string length, should return empty string
  Assert.Throws(->Data.Substring(55)); //out of range
  Assert.Throws(->Data.Substring(-1));

  Assert.AreEqual(Data.Substring(1, 2), "el");
  Assert.AreEqual(Data.Substring(Data.Length, 0), ""); //should be empty string if index equals to string length and length is 0
  Assert.AreEqual(Data.Substring(1, 0), ""); 
  Assert.Throws(->Data.Substring(55, 1));
  Assert.Throws(->Data.Substring(0, 244));
  Assert.Throws(->Data.Substring(-1, 1));
  Assert.Throws(->Data.Substring(1, -1));
end;

method StringTest.Split;
begin
  var Original: String := "x; x; x";
  var Actual := Original.Split("; ");
  
  Assert.AreEqual(length(Actual), 3);
  for i: Integer := 0 to length(Actual)-1 do
    Assert.AreEqual(Actual[i], "x");

  Actual := Original.Split(";");
  var Expected: array of String := ["x", " x", " x"];
  Assert.AreEqual(length(Actual), 3);
  for i: Integer := 0 to length(Actual)-1 do
    Assert.AreEqual(Actual[i], Expected[i]);

  Actual := Original.Split(","); //not exists
  Assert.AreEqual(length(Actual), 1);
  Assert.AreEqual(Actual[0], Original);

  Actual := Original.Split(""); //no changes
  Assert.AreEqual(length(Actual), 1);
  Assert.AreEqual(Actual[0], Original);

  Actual := Original.Split(nil); //no changes
  Assert.AreEqual(length(Actual), 1);
  Assert.AreEqual(Actual[0], Original);
end;

method StringTest.Replace;
begin
  Assert.AreEqual(Data.Replace("ll", "LL"), "HeLLo");
  Assert.AreEqual(Data.Replace("x", "y"), Data); //not existing
  Assert.AreEqual(Data.Replace("E", "x"), Data); //case sensitive
  Assert.Throws(->Data.Replace("", "x"));
  Assert.Throws(->Data.Replace(nil, "x"));
  Assert.AreEqual(Data.Replace("l", nil), "Heo"); //remove
  Assert.AreEqual(Data.Replace("l", ""), "Heo"); //remove
end;

method StringTest.LowerUpperCase;
begin
  Assert.AreEqual(Data.ToLower, "hello");
  Assert.AreEqual(Data.ToUpper, "HELLO");
end;

method StringTest.Trim;
begin
  var Original: Sugar.String := "   Data    ";
  Assert.AreEqual(Original.Trim, "Data");
  Assert.AreEqual(Sugar.String("").Trim, "");
  Assert.AreEqual(Sugar.String("    ").Trim, "");
end;

method StringTest.StartsWith;
begin
  Assert.IsTrue(Data.StartsWith("Hell"));
  Assert.IsFalse(Data.StartsWith("x"));
  Assert.IsFalse(Data.StartsWith("hell"));
  Assert.Throws(->Data.StartsWith(nil));
  Assert.IsTrue(Data.StartsWith(""));
  Assert.IsTrue(Data.StartsWith(Data));
end;

method StringTest.EndsWith;
begin
  Assert.IsTrue(Data.EndsWith("llo"));
  Assert.IsFalse(Data.EndsWith("x"));
  Assert.IsFalse(Data.EndsWith("Llo"));
  Assert.Throws(->Data.EndsWith(nil));
  Assert.IsTrue(Data.EndsWith(""));
  Assert.IsTrue(Data.EndsWith(Data));
end;

method StringTest.ToByteArray;
begin
  var Expected: array of Byte := [103, 114, 195, 182, 195, 159, 101, 114, 101, 110];
  
  var Value: String := "größeren";
  var Actual: array of Byte := Value.ToByteArray;

  Assert.AreEqual(Actual, Expected);
end;

method StringTest.Operators;
begin
  Data := "A";
  var SugarString: String := "B";
  var NativeString := "B";

  Assert.IsTrue(Data < SugarString);
  Assert.IsTrue(Data < NativeString);
  Assert.IsTrue(SugarString > Data);
  Assert.IsTrue(NativeString > Data);
  
  Assert.IsFalse(Data > SugarString);
  Assert.IsFalse(Data > NativeString);
  Assert.IsFalse(SugarString < Data);
  Assert.IsFalse(NativeString < Data);

  Assert.IsTrue(Data <= SugarString);
  Assert.IsTrue(Data <= NativeString);
  Assert.IsTrue(SugarString >= Data);
  Assert.IsTrue(NativeString >= Data);
  
  Assert.IsFalse(Data >= SugarString);
  Assert.IsFalse(Data >= NativeString);
  Assert.IsFalse(SugarString <= Data);
  Assert.IsFalse(NativeString <= Data);

  Assert.IsFalse(Data = SugarString);
  Assert.IsFalse(Data = NativeString);
  Assert.IsFalse(SugarString = Data);
  Assert.IsFalse(NativeString = Data);

  SugarString := nil;
  Assert.AreEqual(SugarString + nil, "");
  Assert.AreEqual(SugarString + "", "");
end;

method StringTest.FromCharArray;
begin
  var Encoded: array of Char := ['H', 'e', 'l', 'l', 'o'];
  var Expected: String := "Hello";
  var Actual: String := new String(Encoded);
  Assert.AreEqual(Actual.Length, 5);
  Assert.AreEqual(Actual, Expected);
  Encoded := [];
  Assert.AreEqual(new String(Encoded), "");
  Encoded := nil;
  Assert.Throws(-> new String(Encoded));
end;

method StringTest.ToCharArray;
begin
  var Expected: array of Char := ['g', 'r', 'ö', 'ß', 'e', 'r', 'e', 'n'];
  
  var Value: String := "größeren";
  var Actual: array of Char := Value.ToCharArray;

  Assert.AreEqual(Actual, Expected);
  Value := "";
  Assert.AreEqual(Value.ToCharArray.Length, 0);
end;

end.

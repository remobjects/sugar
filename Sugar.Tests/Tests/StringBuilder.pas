namespace Sugar.Test;

interface

uses
  Sugar,
  RemObjects.Elements.EUnit;

type
  StringBuilderTest = public class (Test)
  private
    Builder: StringBuilder;
  public
    method Setup; override;
    method Append;
    method AppendRange;
    method AppendChar;
    method AppendLine;
    method Clear;
    method Delete;
    method Replace;
    method Substring;
    method SubstringRange;
    method Insert;
    method Length;
    method Chars;
    method Constructors;
  end;

implementation

method StringBuilderTest.Setup;
begin
  Builder := new StringBuilder;
end;

method StringBuilderTest.Append;
begin
  Assert.IsNotNil(Builder.Append("Hello"));
  Assert.AreEqual(Builder.ToString, "Hello");

  var Value := Builder.Append(" ");
  Assert.IsNotNil(Value);
  Assert.AreEqual(Value.ToString, "Hello ");

  Assert.AreEqual(Builder.Append("").ToString, "Hello ");
  Assert.Throws(->Builder.Append(nil));
end;

method StringBuilderTest.AppendRange;
begin
  Assert.IsNotNil(Builder.Append("Hello", 1, 2));
  Assert.AreEqual(Builder.ToString, "el");

  var Value := Builder.Append("Hello", 0, 1);
  Assert.IsNotNil(Value);
  Assert.AreEqual(Value.ToString, "elH");

  Assert.AreEqual(Builder.Append("", 0, 0).ToString, "elH"); //no changes
  Assert.AreEqual(Builder.Append("qwerty", 1, 0).ToString, "elH"); //count = 0, no changes
  Assert.AreEqual(Builder.Append(nil, 0, 0).ToString, "elH"); //count = 0 and index = 0, no changes

  Assert.Throws(->Builder.Append(nil, 0, 1));
  Assert.Throws(->Builder.Append(nil, 1, 0));
  Assert.Throws(->Builder.Append("Test", 0, 50));
  Assert.Throws(->Builder.Append("Test", 50, 1));
  Assert.Throws(->Builder.Append("Test", -1, 1));
  Assert.Throws(->Builder.Append("Test", 1, -1));
end;

method StringBuilderTest.AppendChar;
begin
  Assert.IsNotNil(Builder.Append('q', 3));
  Assert.AreEqual(Builder.ToString, "qqq");

  var Value := Builder.Append('x', 2);
  Assert.IsNotNil(Value);
  Assert.AreEqual(Value.ToString, "qqqxx");

  Assert.Throws(->Builder.Append('z', -1).ToString);
end;

method StringBuilderTest.AppendLine;
begin
  var NL := Sugar.Environment.NewLine;
  Assert.IsNotNil(Builder.AppendLine("Hello"));
  Assert.AreEqual(Builder.ToString, "Hello"+NL);

  Assert.Throws(->Builder.AppendLine(nil));

  Assert.IsNotNil(Builder.AppendLine);
  Assert.AreEqual(Builder.ToString, "Hello"+NL+NL);
end;

method StringBuilderTest.Clear;
begin
  Assert.IsNotNil(Builder.Append("Hello"));
  Assert.AreEqual(Builder.ToString, "Hello");

  Builder.Clear;

  Assert.AreEqual(Builder.Length, 0);
  Assert.AreEqual(Builder.ToString, "");
end;

method StringBuilderTest.Delete;
begin
  Assert.IsNotNil(Builder.Append("Hello"));
  Assert.AreEqual(Builder.ToString, "Hello");

  Assert.IsNotNil(Builder.Delete(1, 3));
  Assert.AreEqual(Builder.ToString, "Ho");
  Assert.AreEqual(Builder.Delete(1, 0).ToString, "Ho");

  Assert.Throws(->Builder.Delete(-1, 1));
  Assert.Throws(->Builder.Delete(1, -1));
  Assert.Throws(->Builder.Delete(50, 1));
  Assert.Throws(->Builder.Delete(1, 50));
end;

method StringBuilderTest.Replace;
begin
  Assert.IsNotNil(Builder.Append("Hello"));
  Assert.AreEqual(Builder.ToString, "Hello");

  Assert.IsNotNil(Builder.Replace(2, 2, "xx"));
  Assert.AreEqual(Builder.ToString, "Hexxo");

  Assert.Throws(->Builder.Replace(1, 1, nil));
  Assert.Throws(->Builder.Replace(-1, 1, "q"));
  Assert.Throws(->Builder.Replace(1, -1, "q"));
  Assert.Throws(->Builder.Replace(50, 1, "q"));
  Assert.Throws(->Builder.Replace(0, 50, "q"));
end;

method StringBuilderTest.Substring;
begin
  Assert.IsNotNil(Builder.Append("Hello"));
  Assert.AreEqual(Builder.ToString, "Hello");

  var Value := Builder.Substring(3);
  Assert.IsNotNil(Value);
  Assert.AreEqual(Value, "lo");
  Assert.AreEqual(Builder.Substring(Builder.Length), "");
  Assert.AreEqual(Builder.Substring(0), Builder.ToString);

  Assert.Throws(->Builder.Substring(-1));
  Assert.Throws(->Builder.Substring(Builder.Length + 1));
end;

method StringBuilderTest.SubstringRange;
begin
  Assert.IsNotNil(Builder.Append("Hello"));
  Assert.AreEqual(Builder.ToString, "Hello");

  var Value := Builder.Substring(2, 3);
  Assert.IsNotNil(Value);
  Assert.AreEqual(Value, "llo");
  Assert.AreEqual(Builder.Substring(4, 1), "o");
  Assert.AreEqual(Builder.Substring(0, Builder.Length), Builder.ToString);

  Assert.Throws(->Builder.Substring(-1, 1));
  Assert.Throws(->Builder.Substring(1, -1));
  Assert.Throws(->Builder.Substring(0, 50));
  Assert.Throws(->Builder.Substring(50, 0));
end;

method StringBuilderTest.Insert;
begin
  Assert.IsNotNil(Builder.Append("Hlo"));
  Assert.AreEqual(Builder.ToString, "Hlo");

  Assert.IsNotNil(Builder.Insert(1, "el"));
  Assert.AreEqual(Builder.ToString, "Hello");
  Assert.AreEqual(Builder.Insert(2, "").ToString, "Hello");
  Assert.AreEqual(Builder.Insert(0, "z").ToString, "zHello");
  Assert.AreEqual(Builder.Insert(Builder.Length, "z").ToString, "zHelloz");
  
  Assert.Throws(->Builder.Insert(0, nil));
  Assert.Throws(->Builder.Insert(-1, "x"));
  Assert.Throws(->Builder.Insert(25, "x"));
  Assert.Throws(->Builder.Insert(25, ""));
end;

method StringBuilderTest.Length;
begin
  Assert.AreEqual(Builder.Length, 0);
  Assert.IsNotNil(Builder.Append("Hello"));
  Assert.AreEqual(Builder.ToString, "Hello");
  Assert.AreEqual(Builder.Length, 5);
  Builder.Length := 3;
  Assert.AreEqual(Builder.Length, 3);
  Assert.AreEqual(Builder.ToString, "Hel");
  Builder.Length := 0;
  Assert.AreEqual(Builder.Length, 0);
  Assert.AreEqual(Builder.ToString, "");

  //extending length
  Assert.IsNotNil(Builder.Append("Hello"));
  Builder.Length := 10;
  Assert.AreEqual(Builder.Length, 10);
  Assert.AreEqual(Builder.Chars[6], #0);
  Assert.AreEqual(Builder.ToString, "Hello"+#0#0#0#0#0);

  Assert.Throws(->begin Builder.Length := -1 end);
end;

method StringBuilderTest.Chars;
begin
  var Value: array of Char := ['H', 'e', 'l', 'l', 'o'];
  Assert.IsNotNil(Builder.Append("Hello"));
  Assert.AreEqual(Builder.ToString, "Hello");
  Assert.AreEqual(Builder.Length, 5);

  for i: Integer := 0 to Builder.Length - 1 do
    Assert.AreEqual(Builder.Chars[i], Value[i]);

  Builder.Length := 10;  
  Assert.AreEqual(Builder.Chars[6], #0);
  Assert.Throws(->Builder.Chars[-1]);
  Assert.Throws(->Builder.Chars[50]);
end;

method StringBuilderTest.Constructors;
begin
  Builder := new StringBuilder("Hello");
  Assert.AreEqual(Builder.Length, 5);
  Assert.AreEqual(Builder.ToString, "Hello");
  Builder := new StringBuilder(3);
  Assert.AreEqual(Builder.Length, 0);
  Builder.Append("Hello");
  Assert.AreEqual(Builder.Length, 5);
  Assert.AreEqual(Builder.ToString, "Hello");
end;

end.

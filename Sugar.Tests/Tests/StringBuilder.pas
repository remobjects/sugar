namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.TestFramework;

type
  StringBuilderTest = public class (Testcase)
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
  Assert.IsNotNull(Builder.Append("Hello"));
  Assert.CheckString("Hello", Builder.ToString);

  var Value := Builder.Append(" ");
  Assert.IsNotNull(Value);
  Assert.CheckString("Hello ", Value.ToString);

  Assert.CheckString("Hello ", Builder.Append("").ToString);
  Assert.IsException(->Builder.Append(nil));
end;

method StringBuilderTest.AppendRange;
begin
  Assert.IsNotNull(Builder.Append("Hello", 1, 2));
  Assert.CheckString("el", Builder.ToString);

  var Value := Builder.Append("Hello", 0, 1);
  Assert.IsNotNull(Value);
  Assert.CheckString("elH", Value.ToString);

  Assert.CheckString("elH", Builder.Append("", 0, 0).ToString); //no changes
  Assert.CheckString("elH", Builder.Append("qwerty", 1, 0).ToString); //count = 0, no changes
  Assert.CheckString("elH", Builder.Append(nil, 0, 0).ToString); //count = 0 and index = 0, no changes

  Assert.IsException(->Builder.Append(nil, 0, 1));
  Assert.IsException(->Builder.Append(nil, 1, 0));
  Assert.IsException(->Builder.Append("Test", 0, 50));
  Assert.IsException(->Builder.Append("Test", 50, 1));
  Assert.IsException(->Builder.Append("Test", -1, 1));
  Assert.IsException(->Builder.Append("Test", 1, -1));
end;

method StringBuilderTest.AppendChar;
begin
  Assert.IsNotNull(Builder.Append('q', 3));
  Assert.CheckString("qqq", Builder.ToString);

  var Value := Builder.Append('x', 2);
  Assert.IsNotNull(Value);
  Assert.CheckString("qqqxx", Value.ToString);

  Assert.IsException(->Builder.Append('z', -1).ToString);
end;

method StringBuilderTest.AppendLine;
begin
  var NL := Sugar.Environment.NewLine;
  Assert.IsNotNull(Builder.AppendLine("Hello"));
  Assert.CheckString("Hello"+NL, Builder.ToString);

  Assert.IsException(->Builder.AppendLine(nil));

  Assert.IsNotNull(Builder.AppendLine);
  Assert.CheckString("Hello"+NL+NL, Builder.ToString);
end;

method StringBuilderTest.Clear;
begin
  Assert.IsNotNull(Builder.Append("Hello"));
  Assert.CheckString("Hello", Builder.ToString);

  Builder.Clear;

  Assert.CheckInt(0, Builder.Length);
  Assert.CheckString("", Builder.ToString);
end;

method StringBuilderTest.Delete;
begin
  Assert.IsNotNull(Builder.Append("Hello"));
  Assert.CheckString("Hello", Builder.ToString);

  Assert.IsNotNull(Builder.Delete(1, 3));
  Assert.CheckString("Ho", Builder.ToString);
  Assert.CheckString("Ho", Builder.Delete(1, 0).ToString);  

  Assert.IsException(->Builder.Delete(-1, 1));
  Assert.IsException(->Builder.Delete(1, -1));
  Assert.IsException(->Builder.Delete(50, 1));
  Assert.IsException(->Builder.Delete(1, 50));
end;

method StringBuilderTest.Replace;
begin
  Assert.IsNotNull(Builder.Append("Hello"));
  Assert.CheckString("Hello", Builder.ToString);

  Assert.IsNotNull(Builder.Replace(2, 2, "xx"));
  Assert.CheckString("Hexxo", Builder.ToString);

  Assert.IsException(->Builder.Replace(1, 1, nil));
  Assert.IsException(->Builder.Replace(-1, 1, "q"));
  Assert.IsException(->Builder.Replace(1, -1, "q"));
  Assert.IsException(->Builder.Replace(50, 1, "q"));
  Assert.IsException(->Builder.Replace(0, 50, "q"));
end;

method StringBuilderTest.Substring;
begin
  Assert.IsNotNull(Builder.Append("Hello"));
  Assert.CheckString("Hello", Builder.ToString);

  var Value := Builder.Substring(3);
  Assert.IsNotNull(Value);
  Assert.CheckString("lo", Value);
  Assert.CheckString("", Builder.Substring(Builder.Length));
  Assert.CheckString(Builder.ToString, Builder.Substring(0));

  Assert.IsException(->Builder.Substring(-1));
  Assert.IsException(->Builder.Substring(Builder.Length + 1));
end;

method StringBuilderTest.SubstringRange;
begin
  Assert.IsNotNull(Builder.Append("Hello"));
  Assert.CheckString("Hello", Builder.ToString);

  var Value := Builder.Substring(2, 3);
  Assert.IsNotNull(Value);
  Assert.CheckString("llo", Value);
  Assert.CheckString("o", Builder.Substring(4, 1));  
  Assert.CheckString(Builder.ToString, Builder.Substring(0, Builder.Length));

  Assert.IsException(->Builder.Substring(-1, 1));
  Assert.IsException(->Builder.Substring(1, -1));
  Assert.IsException(->Builder.Substring(0, 50));
  Assert.IsException(->Builder.Substring(50, 0));
end;

method StringBuilderTest.Insert;
begin
  Assert.IsNotNull(Builder.Append("Hlo"));
  Assert.CheckString("Hlo", Builder.ToString);

  Assert.IsNotNull(Builder.Insert(1, "el"));
  Assert.CheckString("Hello", Builder.ToString);
  Assert.CheckString("Hello", Builder.Insert(2, "").ToString);  
  Assert.CheckString("zHello", Builder.Insert(0, "z").ToString);
  Assert.CheckString("zHelloz", Builder.Insert(Builder.Length, "z").ToString);
  
  Assert.IsException(->Builder.Insert(0, nil));
  Assert.IsException(->Builder.Insert(-1, "x"));
  Assert.IsException(->Builder.Insert(25, "x"));
  Assert.IsException(->Builder.Insert(25, ""));
end;

method StringBuilderTest.Length;
begin
  Assert.CheckInt(0, Builder.Length);
  Assert.IsNotNull(Builder.Append("Hello"));
  Assert.CheckString("Hello", Builder.ToString);
  Assert.CheckInt(5, Builder.Length);
  Builder.Length := 3;
  Assert.CheckInt(3, Builder.Length);
  Assert.CheckString("Hel", Builder.ToString);
  Builder.Length := 0;
  Assert.CheckInt(0, Builder.Length);
  Assert.CheckString("", Builder.ToString);

  //extending length
  Assert.IsNotNull(Builder.Append("Hello"));
  Builder.Length := 10;
  Assert.CheckInt(10, Builder.Length);
  Assert.CheckString(#0, Builder.Chars[6]);
  Assert.CheckString("Hello"+#0#0#0#0#0, Builder.ToString);

  Assert.IsException(->begin Builder.Length := -1 end);
end;

method StringBuilderTest.Chars;
begin
  var Value: array of Char := ['H', 'e', 'l', 'l', 'o'];
  Assert.IsNotNull(Builder.Append("Hello"));
  Assert.CheckString("Hello", Builder.ToString);
  Assert.CheckInt(5, Builder.Length);

  for i: Integer := 0 to Builder.Length - 1 do
    Assert.CheckString(Value[i], Builder.Chars[i]);

  Builder.Length := 10;  
  Assert.CheckString(#0, Builder.Chars[6]);
  Assert.IsException(->Builder.Chars[-1]);
  Assert.IsException(->Builder.Chars[50]);
end;

method StringBuilderTest.Constructors;
begin
  Builder := new StringBuilder("Hello");
  Assert.CheckInt(5, Builder.Length);
  Assert.CheckString("Hello", Builder.ToString);
  Builder := new StringBuilder(3);
  Assert.CheckInt(0, Builder.Length);
  Builder.Append("Hello");
  Assert.CheckInt(5, Builder.Length);
  Assert.CheckString("Hello", Builder.ToString);
end;

end.

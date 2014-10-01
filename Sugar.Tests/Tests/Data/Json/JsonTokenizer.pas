namespace Sugar.Test;

interface

uses
  Sugar.Data.Json,
  RemObjects.Elements.EUnit;

type
  JsonTokenizerTest = public class (Test)
  public
    method EmptyObject;
    method SimpleObjectStringValue;
    method SpaceTest;
    method SimpleObjectIntValue;
    method SimpleQuoteInString;
    method SimpleObjectFloatValue;
    method LowcaseFloatValue;
    method SimpleObjectLongValue;
    method SimpleObjectBigIntegerValue;
    method SimpleDigitArray;
    method SimpleStringArray;
    method ArrayOfEmptyObjects;
    method LowercaseUnicodeText;
    method UppercaseUnicodeText;
    method NonProtectedSlash;
    method SimpleObjectNullValue;
  end;

implementation

method JsonTokenizerTest.EmptyObject;
begin
  var Tokenizer := new JsonTokenizer("{}");
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ObjectStart);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ObjectEnd);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.EOF);
end;

method JsonTokenizerTest.SimpleObjectStringValue;
begin
  var Tokenizer := new JsonTokenizer('{ "v":"1"}');
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ObjectStart);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.String);
  Assert.AreEqual(Tokenizer.Value, "v");
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.NameSeperator);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.String);
  Assert.AreEqual(Tokenizer.Value, "1");
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ObjectEnd);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.EOF);
end;

method JsonTokenizerTest.SpaceTest;
begin
  var Tokenizer := new JsonTokenizer("{	""v""
  :""1""
  }");
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ObjectStart);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.String);
  Assert.AreEqual(Tokenizer.Value, "v");
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.NameSeperator);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.String);
  Assert.AreEqual(Tokenizer.Value, "1");
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ObjectEnd);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.EOF);
end;

method JsonTokenizerTest.SimpleObjectIntValue;
begin
  var Tokenizer := new JsonTokenizer('{"v":1}');
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ObjectStart);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.String);
  Assert.AreEqual(Tokenizer.Value, "v");
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.NameSeperator);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.Number);
  Assert.AreEqual(Tokenizer.Value, "1");
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ObjectEnd);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.EOF);
end;

method JsonTokenizerTest.SimpleQuoteInString;
begin
  var Tokenizer := new JsonTokenizer('{ "v":"ab''c"}');
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ObjectStart);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.String);
  Assert.AreEqual(Tokenizer.Value, "v");
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.NameSeperator);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.String);
  Assert.AreEqual(Tokenizer.Value, "ab'c");
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ObjectEnd);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.EOF);
end;

method JsonTokenizerTest.SimpleObjectFloatValue;
begin
  var Tokenizer := new JsonTokenizer('{ "PI":3.141E-10}');
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ObjectStart);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.String);
  Assert.AreEqual(Tokenizer.Value, "PI");
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.NameSeperator);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.Number);
  Assert.AreEqual(Tokenizer.Value, "3.141E-10");
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ObjectEnd);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.EOF);
end;

method JsonTokenizerTest.LowcaseFloatValue;
begin
  var Tokenizer := new JsonTokenizer('{ "PI":3.141e-10}');
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ObjectStart);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.String);
  Assert.AreEqual(Tokenizer.Value, "PI");
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.NameSeperator);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.Number);
  Assert.AreEqual(Tokenizer.Value, "3.141e-10");
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ObjectEnd);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.EOF);
end;

method JsonTokenizerTest.SimpleObjectLongValue;
begin
  var Tokenizer := new JsonTokenizer('{ "v":12345123456789}');
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ObjectStart);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.String);
  Assert.AreEqual(Tokenizer.Value, "v");
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.NameSeperator);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.Number);
  Assert.AreEqual(Tokenizer.Value, "12345123456789");
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ObjectEnd);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.EOF);
end;

method JsonTokenizerTest.SimpleObjectBigIntegerValue;
begin
  var Tokenizer := new JsonTokenizer('{ "v":123456789123456789123456789}');
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ObjectStart);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.String);
  Assert.AreEqual(Tokenizer.Value, "v");
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.NameSeperator);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.Number);
  Assert.AreEqual(Tokenizer.Value, "123456789123456789123456789");
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ObjectEnd);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.EOF);
end;

method JsonTokenizerTest.SimpleDigitArray;
begin
  var Tokenizer := new JsonTokenizer('[1,2,3,4]');
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ArrayStart);

  for i: Int32 := 1 to 4 do begin
    Tokenizer.Next;
    Assert.AreEqual(Tokenizer.Token, JsonTokenKind.Number);
    Assert.AreEqual(Tokenizer.Value, i.ToString);
    Tokenizer.Next;
    if i < 4 then
      Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ValueSeperator);
  end;

  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ArrayEnd);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.EOF);
end;

method JsonTokenizerTest.SimpleStringArray;
begin
  var Tokenizer := new JsonTokenizer('["1","2","3","4"]');
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ArrayStart);

  for i: Int32 := 1 to 4 do begin
    Tokenizer.Next;
    Assert.AreEqual(Tokenizer.Token, JsonTokenKind.String);
    Assert.AreEqual(Tokenizer.Value, i.ToString);
    Tokenizer.Next;
    if i < 4 then
      Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ValueSeperator);
  end;

  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ArrayEnd);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.EOF);
end;

method JsonTokenizerTest.ArrayOfEmptyObjects;
begin
  var Tokenizer := new JsonTokenizer('[ {}, {}, []]');
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ArrayStart);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ObjectStart);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ObjectEnd);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ValueSeperator);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ObjectStart);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ObjectEnd);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ValueSeperator);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ArrayStart);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ArrayEnd);
  Tokenizer.Next;  
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ArrayEnd);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.EOF);
end;

method JsonTokenizerTest.LowercaseUnicodeText;
begin
  var Tokenizer := new JsonTokenizer('{ "v":"\u0275\u023e"}');
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ObjectStart);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.String);
  Assert.AreEqual(Tokenizer.Value, "v");
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.NameSeperator);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.String);
  Assert.AreEqual(Tokenizer.Value, "ɵȾ");
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ObjectEnd);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.EOF);
end;

method JsonTokenizerTest.UppercaseUnicodeText;
begin
  var Tokenizer := new JsonTokenizer('{ "v":"\u0275\u023E"}');
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ObjectStart);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.String);
  Assert.AreEqual(Tokenizer.Value, "v");
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.NameSeperator);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.String);
  Assert.AreEqual(Tokenizer.Value, "ɵȾ");
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ObjectEnd);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.EOF);
end;

method JsonTokenizerTest.NonProtectedSlash;
begin
  var Tokenizer := new JsonTokenizer('{ "v":"hp://foo"}');
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ObjectStart);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.String);
  Assert.AreEqual(Tokenizer.Value, "v");
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.NameSeperator);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.String);
  Assert.AreEqual(Tokenizer.Value, "hp://foo");
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ObjectEnd);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.EOF);
end;

method JsonTokenizerTest.SimpleObjectNullValue;
begin
  var Tokenizer := new JsonTokenizer('{ "v": null}');
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ObjectStart);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.String);
  Assert.AreEqual(Tokenizer.Value, "v");
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.NameSeperator);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.Null);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.ObjectEnd);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.EOF);
end;

end.
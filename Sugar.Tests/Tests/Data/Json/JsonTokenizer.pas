namespace Sugar.Test;

interface

uses
  Sugar.Data.Json,
  RemObjects.Elements.EUnit;

type
  JsonTokenizerTest = public class (Test)
  private    
    Tokenizer: JsonTokenizer := nil;
    method SkipTo(Token: JsonTokenKind);
    method Expect(Expected: JsonTokenKind);
    method Expect(ExpectedToken: JsonTokenKind; ExpectedValue: String);
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
    method SimpleObjectTrueValue;
    method SimpleObjectFalseValue;
    method SimpleObjectDoubleValue;
    method MultiValuesObject;
    method NestedObject;
    method SimpleArraySingleValue;
    method MultiValuesArray;
    method ArrayWithNestedObjects;
    method NonProtectedKeys;
    method NonProtectedString;
  end;

implementation

method JsonTokenizerTest.EmptyObject;
begin
  Tokenizer := new JsonTokenizer("{}");
  Expect(JsonTokenKind.ObjectStart);
  Expect(JsonTokenKind.ObjectEnd);
  Expect(JsonTokenKind.EOF);
end;

method JsonTokenizerTest.SimpleObjectStringValue;
begin
  Tokenizer := new JsonTokenizer('{ "v":"1"}');
  Expect(JsonTokenKind.ObjectStart);
  Expect(JsonTokenKind.String, "v");
  Expect(JsonTokenKind.NameSeperator);
  Expect(JsonTokenKind.String, "1");
  Expect(JsonTokenKind.ObjectEnd);
  Expect(JsonTokenKind.EOF);
end;

method JsonTokenizerTest.SpaceTest;
begin
  Tokenizer := new JsonTokenizer("{	""v""
  :""1""
  }");
  Expect(JsonTokenKind.ObjectStart);
  Expect(JsonTokenKind.String, "v");
  Expect(JsonTokenKind.NameSeperator);
  Expect(JsonTokenKind.String, "1");
  Expect(JsonTokenKind.ObjectEnd);
  Expect(JsonTokenKind.EOF);
end;

method JsonTokenizerTest.SimpleObjectIntValue;
begin
  Tokenizer := new JsonTokenizer('{"v":1}');
  Expect(JsonTokenKind.ObjectStart);
  Expect(JsonTokenKind.String, "v");
  Expect(JsonTokenKind.NameSeperator);
  Expect(JsonTokenKind.Number, "1");
  Expect(JsonTokenKind.ObjectEnd);
  Expect(JsonTokenKind.EOF);
end;

method JsonTokenizerTest.SimpleQuoteInString;
begin
  Tokenizer := new JsonTokenizer('{ "v":"ab''c"}');
  Expect(JsonTokenKind.ObjectStart);
  Expect(JsonTokenKind.String, "v");
  Expect(JsonTokenKind.NameSeperator);
  Expect(JsonTokenKind.String, "ab'c");
  Expect(JsonTokenKind.ObjectEnd);
  Expect(JsonTokenKind.EOF);
end;

method JsonTokenizerTest.SimpleObjectFloatValue;
begin
  Tokenizer := new JsonTokenizer('{ "PI":3.141E-10}');
  Expect(JsonTokenKind.ObjectStart);
  Expect(JsonTokenKind.String, "PI");
  Expect(JsonTokenKind.NameSeperator);
  Expect(JsonTokenKind.Number, "3.141E-10");
  Expect(JsonTokenKind.ObjectEnd);
  Expect(JsonTokenKind.EOF);
end;

method JsonTokenizerTest.LowcaseFloatValue;
begin
  Tokenizer := new JsonTokenizer('{ "PI":3.141e-10}');
  Expect(JsonTokenKind.ObjectStart);
  Expect(JsonTokenKind.String, "PI");
  Expect(JsonTokenKind.NameSeperator);
  Expect(JsonTokenKind.Number, "3.141e-10");
  Expect(JsonTokenKind.ObjectEnd);
  Expect(JsonTokenKind.EOF);
end;

method JsonTokenizerTest.SimpleObjectLongValue;
begin
  Tokenizer := new JsonTokenizer('{ "v":12345123456789}');
  Expect(JsonTokenKind.ObjectStart);
  Expect(JsonTokenKind.String, "v");
  Expect(JsonTokenKind.NameSeperator);
  Expect(JsonTokenKind.Number, "12345123456789");
  Expect(JsonTokenKind.ObjectEnd);
  Expect(JsonTokenKind.EOF);
end;

method JsonTokenizerTest.SimpleObjectBigIntegerValue;
begin
  Tokenizer := new JsonTokenizer('{ "v":123456789123456789123456789}');
  Expect(JsonTokenKind.ObjectStart);
  Expect(JsonTokenKind.String, "v");
  Expect(JsonTokenKind.NameSeperator);
  Expect(JsonTokenKind.Number, "123456789123456789123456789");
  Expect(JsonTokenKind.ObjectEnd);
  Expect(JsonTokenKind.EOF);
end;

method JsonTokenizerTest.SimpleDigitArray;
begin
  Tokenizer := new JsonTokenizer('[1,2,3,4]');
  Expect(JsonTokenKind.ArrayStart);

  for i: Int32 := 1 to 4 do begin
    Expect(JsonTokenKind.Number, i.ToString);
    if i < 4 then
      Expect(JsonTokenKind.ValueSeperator);
  end;

  Expect(JsonTokenKind.ArrayEnd);
  Expect(JsonTokenKind.EOF);
end;

method JsonTokenizerTest.SimpleStringArray;
begin
  Tokenizer := new JsonTokenizer('["1","2","3","4"]');
  Expect(JsonTokenKind.ArrayStart);

  for i: Int32 := 1 to 4 do begin
    Expect(JsonTokenKind.String, i.ToString);
    if i < 4 then
      Expect(JsonTokenKind.ValueSeperator);
  end;

  Expect(JsonTokenKind.ArrayEnd);
  Expect(JsonTokenKind.EOF);
end;

method JsonTokenizerTest.ArrayOfEmptyObjects;
begin
  Tokenizer := new JsonTokenizer('[ {}, {}, []]');
  Expect(JsonTokenKind.ArrayStart);
  Expect(JsonTokenKind.ObjectStart);
  Expect(JsonTokenKind.ObjectEnd);
  Expect(JsonTokenKind.ValueSeperator);
  Expect(JsonTokenKind.ObjectStart);
  Expect(JsonTokenKind.ObjectEnd);
  Expect(JsonTokenKind.ValueSeperator);
  Expect(JsonTokenKind.ArrayStart);
  Expect(JsonTokenKind.ArrayEnd);
  Expect(JsonTokenKind.ArrayEnd);
  Expect(JsonTokenKind.EOF);
end;

method JsonTokenizerTest.LowercaseUnicodeText;
begin
  Tokenizer := new JsonTokenizer('{ "v":"\u0275\u023e"}');
  Expect(JsonTokenKind.ObjectStart);
  Expect(JsonTokenKind.String, "v");
  Expect(JsonTokenKind.NameSeperator);
  Expect(JsonTokenKind.String, "ɵȾ");
  Expect(JsonTokenKind.ObjectEnd);
  Expect(JsonTokenKind.EOF);
end;

method JsonTokenizerTest.UppercaseUnicodeText;
begin
  Tokenizer := new JsonTokenizer('{ "v":"\u0275\u023E"}');
  Expect(JsonTokenKind.ObjectStart);
  Expect(JsonTokenKind.String, "v");
  Expect(JsonTokenKind.NameSeperator);
  Expect(JsonTokenKind.String, "ɵȾ");
  Expect(JsonTokenKind.ObjectEnd);
  Expect(JsonTokenKind.EOF);
end;

method JsonTokenizerTest.NonProtectedSlash;
begin
  Tokenizer := new JsonTokenizer('{ "v":"http://foo"}');
  Expect(JsonTokenKind.ObjectStart);
  Expect(JsonTokenKind.String, "v");
  Expect(JsonTokenKind.NameSeperator);
  Expect(JsonTokenKind.String, "http://foo");
  Expect(JsonTokenKind.ObjectEnd);
  Expect(JsonTokenKind.EOF);
end;

method JsonTokenizerTest.SimpleObjectNullValue;
begin
  Tokenizer := new JsonTokenizer('{ "v": null}');
  SkipTo(JsonTokenKind.NameSeperator);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.Null);
end;

method JsonTokenizerTest.SimpleObjectTrueValue;
begin
  Tokenizer := new JsonTokenizer('{ "v": true}');
  SkipTo(JsonTokenKind.NameSeperator);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.True);
end;

method JsonTokenizerTest.SimpleObjectFalseValue;
begin
  Tokenizer := new JsonTokenizer('{ "v": false}');
  SkipTo(JsonTokenKind.NameSeperator);
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, JsonTokenKind.False);
end;

method JsonTokenizerTest.SimpleObjectDoubleValue;
begin
  Tokenizer := new JsonTokenizer('{ "v":1.7976931348623157E308}');
  SkipTo(JsonTokenKind.NameSeperator);
  Expect(JsonTokenKind.Number, "1.7976931348623157E308");
end;

method JsonTokenizerTest.MultiValuesObject;
begin
  Tokenizer := new JsonTokenizer('{ "a":1.7E308, "b": 42, "c": null, "d": "string"}');
  Expect(JsonTokenKind.ObjectStart);
  Expect(JsonTokenKind.String, "a");
  Expect(JsonTokenKind.NameSeperator);
  Expect(JsonTokenKind.Number, "1.7E308");
  Expect(JsonTokenKind.ValueSeperator);
  Expect(JsonTokenKind.String, "b");
  Expect(JsonTokenKind.NameSeperator);
  Expect(JsonTokenKind.Number, "42");
  Expect(JsonTokenKind.ValueSeperator);
  Expect(JsonTokenKind.String, "c");
  Expect(JsonTokenKind.NameSeperator);
  Expect(JsonTokenKind.Null);
  Expect(JsonTokenKind.ValueSeperator);
  Expect(JsonTokenKind.String, "d");
  Expect(JsonTokenKind.NameSeperator);
  Expect(JsonTokenKind.String, "string");
  Expect(JsonTokenKind.ObjectEnd);
  Expect(JsonTokenKind.EOF);
end;

method JsonTokenizerTest.SkipTo(Token: JsonTokenKind);
begin
  repeat
    Tokenizer.Next;
  until (Tokenizer.Token = Token) or (Tokenizer.Token = JsonTokenKind.EOF);
end;

method JsonTokenizerTest.NestedObject;
begin
  Tokenizer := new JsonTokenizer('{ "v": "abc", "a": { "v": "abc"}}');
  Expect(JsonTokenKind.ObjectStart);
  Expect(JsonTokenKind.String, "v");
  Expect(JsonTokenKind.NameSeperator);
  Expect(JsonTokenKind.String, "abc");
  Expect(JsonTokenKind.ValueSeperator);
  Expect(JsonTokenKind.String, "a");
  Expect(JsonTokenKind.NameSeperator);
  Expect(JsonTokenKind.ObjectStart);
  Expect(JsonTokenKind.String, "v");
  Expect(JsonTokenKind.NameSeperator);
  Expect(JsonTokenKind.String, "abc");
  Expect(JsonTokenKind.ObjectEnd);
  Expect(JsonTokenKind.ObjectEnd);
  Expect(JsonTokenKind.EOF);
end;

method JsonTokenizerTest.SimpleArraySingleValue;
begin
  Tokenizer := new JsonTokenizer('["a"]');
  Expect(JsonTokenKind.ArrayStart);
  Expect(JsonTokenKind.String, "a");
  Expect(JsonTokenKind.ArrayEnd);
  Expect(JsonTokenKind.EOF);
end;

method JsonTokenizerTest.MultiValuesArray;
begin
  Tokenizer := new JsonTokenizer('["a", 1, null, true]');
  Expect(JsonTokenKind.ArrayStart);
  Expect(JsonTokenKind.String, "a");
  Expect(JsonTokenKind.ValueSeperator);
  Expect(JsonTokenKind.Number, "1");
  Expect(JsonTokenKind.ValueSeperator);
  Expect(JsonTokenKind.Null);
  Expect(JsonTokenKind.ValueSeperator);
  Expect(JsonTokenKind.True);
  Expect(JsonTokenKind.ArrayEnd);
  Expect(JsonTokenKind.EOF);
end;

method JsonTokenizerTest.ArrayWithNestedObjects;
begin
  Tokenizer := new JsonTokenizer('[{"a": 1, "b": "abc"}, {"a": 2, "b": "bca"}]');
  Expect(JsonTokenKind.ArrayStart);
  Expect(JsonTokenKind.ObjectStart);
  Expect(JsonTokenKind.String, "a");
  Expect(JsonTokenKind.NameSeperator);
  Expect(JsonTokenKind.Number, "1");
  Expect(JsonTokenKind.ValueSeperator);
  Expect(JsonTokenKind.String, "b");
  Expect(JsonTokenKind.NameSeperator);
  Expect(JsonTokenKind.String, "abc");
  Expect(JsonTokenKind.ObjectEnd);
  Expect(JsonTokenKind.ValueSeperator);
  Expect(JsonTokenKind.ObjectStart);
  Expect(JsonTokenKind.String, "a");
  Expect(JsonTokenKind.NameSeperator);
  Expect(JsonTokenKind.Number, "2");
  Expect(JsonTokenKind.ValueSeperator);
  Expect(JsonTokenKind.String, "b");
  Expect(JsonTokenKind.NameSeperator);
  Expect(JsonTokenKind.String, "bca");
  Expect(JsonTokenKind.ObjectEnd);
  Expect(JsonTokenKind.ArrayEnd);
  Expect(JsonTokenKind.EOF);
end;

method JsonTokenizerTest.Expect(Expected: JsonTokenKind);
begin
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, Expected);  
end;

method JsonTokenizerTest.Expect(ExpectedToken: JsonTokenKind; ExpectedValue: String);
begin
  Tokenizer.Next;
  Assert.AreEqual(Tokenizer.Token, ExpectedToken);
  Assert.AreEqual(Tokenizer.Value, ExpectedValue);  
end;

method JsonTokenizerTest.NonProtectedKeys;
begin
  Tokenizer := new JsonTokenizer('{a: 1}');
  Expect(JsonTokenKind.ObjectStart);
  Expect(JsonTokenKind.Identifier, "a");
  Expect(JsonTokenKind.NameSeperator);
  Expect(JsonTokenKind.Number, "1");
  Expect(JsonTokenKind.ObjectEnd);
  Expect(JsonTokenKind.EOF);
end;

method JsonTokenizerTest.NonProtectedString;
begin
  Tokenizer := new JsonTokenizer('{"a": abc}');
  Expect(JsonTokenKind.ObjectStart);
  Expect(JsonTokenKind.String, "a");
  Expect(JsonTokenKind.NameSeperator);
  Expect(JsonTokenKind.Identifier, "abc");
  Expect(JsonTokenKind.ObjectEnd);
  Expect(JsonTokenKind.EOF);
end;

end.
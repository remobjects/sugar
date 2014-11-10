namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.Data.Json,
  Sugar.Collections,
  RemObjects.Elements.EUnit;

type
  JsonObjectParserTest = public class (Test)
  private
    JObj: JsonObject := nil;
  public
    method EmptyObject;
    method SimpleObjectStringValue;
    method SimpleObjectIntValue;
    method SimpleObjectFloatValue;
    method SimpleObjectLongValue;
    method SimpleObjectBigIntegerValue;
    method SimpleObjectNullValue;
    method SimpleObjectTrueValue;
    method SimpleObjectFalseValue;
    method MultiValuesObject;
    method NestedObject;
    method NestedArray;
    method UnprotectedKey;
    method UnprotectedValue;
    method NonObjectParseFails;
    method UnclosedObjectFails;
    method NilJsonFails;
    method BrokenFormatJsonFails;
  end;

implementation

method JsonObjectParserTest.EmptyObject;
begin
  JObj := JsonObject.Load("{}");
  Assert.IsNotNil(JObj);
  Assert.AreEqual(JObj.Count, 0);
end;

method JsonObjectParserTest.SimpleObjectStringValue;
begin
  JObj := JsonObject.Load('{ "v":"1"}');
  Assert.IsNotNil(JObj);
  Assert.AreEqual(JObj.Count, 1);
  Assert.AreEqual(JObj["v"].Kind, JsonValueKind.String);
  Assert.AreEqual(JObj["v"].ToStr, "1");
end;

method JsonObjectParserTest.SimpleObjectIntValue;
begin
  JObj := JsonObject.Load('{"v":1}');
  Assert.IsNotNil(JObj);
  Assert.AreEqual(JObj.Count, 1);
  Assert.AreEqual(JObj["v"].Kind, JsonValueKind.Integer);
  Assert.AreEqual(JObj["v"].ToInteger, 1);
end;

method JsonObjectParserTest.SimpleObjectFloatValue;
begin
  JObj := JsonObject.Load('{ "PI":3.141E-10}');
  Assert.IsNotNil(JObj);
  Assert.AreEqual(JObj.Count, 1);
  Assert.AreEqual(JObj["PI"].Kind, JsonValueKind.Double);
  Assert.AreEqual(JObj["PI"].ToDouble, 3.141E-10);
end;

method JsonObjectParserTest.SimpleObjectLongValue;
begin
  JObj := JsonObject.Load('{"v":12345123456789}');
  Assert.IsNotNil(JObj);
  Assert.AreEqual(JObj.Count, 1);
  Assert.AreEqual(JObj["v"].Kind, JsonValueKind.Integer);
  Assert.AreEqual(JObj["v"].ToInteger, 12345123456789);
end;

method JsonObjectParserTest.SimpleObjectBigIntegerValue;
begin
  JObj := JsonObject.Load('{"v":999999999999999999999999999999999999999999999999999999}');
  Assert.IsNotNil(JObj);
  Assert.AreEqual(JObj.Count, 1);
  Assert.AreEqual(JObj["v"].Kind, JsonValueKind.Double);
  Assert.AreEqual(JObj["v"].ToDouble, 1E+54);
end;

method JsonObjectParserTest.SimpleObjectNullValue;
begin
  JObj := JsonObject.Load('{"v":null}');
  Assert.IsNotNil(JObj);
  Assert.AreEqual(JObj.Count, 1);
  Assert.AreEqual(JObj["v"].Kind, JsonValueKind.Null);
  Assert.AreEqual(JObj["v"].IsNull, true);
end;

method JsonObjectParserTest.SimpleObjectTrueValue;
begin
  JObj := JsonObject.Load('{"v":true}');
  Assert.IsNotNil(JObj);
  Assert.AreEqual(JObj.Count, 1);
  Assert.AreEqual(JObj["v"].Kind, JsonValueKind.Boolean);
  Assert.AreEqual(JObj["v"].ToBoolean, true);
end;

method JsonObjectParserTest.SimpleObjectFalseValue;
begin
  JObj := JsonObject.Load('{"v":false}');
  Assert.IsNotNil(JObj);
  Assert.AreEqual(JObj.Count, 1);
  Assert.AreEqual(JObj["v"].Kind, JsonValueKind.Boolean);
  Assert.AreEqual(JObj["v"].ToBoolean, false);
end;

method JsonObjectParserTest.MultiValuesObject;
begin
  JObj := JsonObject.Load('{ "a":1.7E308, "b": 42, "c": null, "d": "string"}');
  Assert.IsNotNil(JObj);
  Assert.AreEqual(JObj.Count, 4);  
  Assert.AreEqual(JObj["a"].ToDouble, 1.7E308);
  Assert.AreEqual(JObj["b"].ToInteger, 42);
  Assert.AreEqual(JObj["c"].IsNull, true);
  Assert.AreEqual(JObj["d"].ToStr, "string");
end;

method JsonObjectParserTest.NestedObject;
begin
  JObj := JsonObject.Load('{ "a": "abc", "b": { "a": "abc"}}');
  Assert.IsNotNil(JObj);
  Assert.AreEqual(JObj.Count, 2);  
  Assert.AreEqual(JObj["a"].ToStr, "abc");

  Assert.AreEqual(JObj["b"].Kind, JsonValueKind.Object);
  var lObj := JObj["b"].ToObject;
  Assert.IsNotNil(lObj);
  Assert.AreEqual(lObj.Count, 1);
  Assert.AreEqual(lObj["a"].ToStr, "abc");
end;

method JsonObjectParserTest.NestedArray;
begin
  JObj := JsonObject.Load('{ "a": "abc", "b": [1, 2]}');
  Assert.IsNotNil(JObj);
  Assert.AreEqual(JObj.Count, 2);  
  Assert.AreEqual(JObj["a"].ToStr, "abc");

  Assert.AreEqual(JObj["b"].Kind, JsonValueKind.Array);
  var lObj := JObj["b"].ToArray;
  Assert.IsNotNil(lObj);
  Assert.AreEqual(lObj.Count, 2);
  Assert.AreEqual(lObj[0].ToInteger, 1);
  Assert.AreEqual(lObj[1].ToInteger, 2);
end;

method JsonObjectParserTest.UnprotectedKey;
begin
  JObj := JsonObject.Load('{ a: "abc", b: "bca"}');
  Assert.IsNotNil(JObj);
  Assert.AreEqual(JObj.Count, 2);  
  Assert.AreEqual(JObj["a"].ToStr, "abc");
  Assert.AreEqual(JObj["b"].ToStr, "bca");
end;

method JsonObjectParserTest.UnprotectedValue;
begin
  JObj := JsonObject.Load('{ a: abc, b: bca}');
  Assert.IsNotNil(JObj);
  Assert.AreEqual(JObj.Count, 2);  
  Assert.AreEqual(JObj["a"].ToStr, "abc");
  Assert.AreEqual(JObj["b"].ToStr, "bca");
end;

method JsonObjectParserTest.NonObjectParseFails;
begin
  Assert.Throws(->JsonObject.Load("[1, 2, 3]"));
end;

method JsonObjectParserTest.UnclosedObjectFails;
begin
  Assert.Throws(->JsonObject.Load('{"a": 1'));
end;

method JsonObjectParserTest.NilJsonFails;
begin
  Assert.Throws(->JsonObject.Load(nil));
end;

method JsonObjectParserTest.BrokenFormatJsonFails;
begin
  Assert.Throws(->JsonObject.Load('"a": 1'));
  Assert.Throws(->JsonObject.Load('{true: 1}'));
  Assert.Throws(->JsonObject.Load('{123: 1}'));
  Assert.Throws(->JsonObject.Load('{"a" 1}'));
  Assert.Throws(->JsonObject.Load('{"a": 1 a "b": 2}'));
end;

end.
namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.Data.JSON,
  RemObjects.Elements.EUnit;

type
  JsonObjectTest = public class (Test)
  private
    Obj: JsonObject;
  public
    method Setup; override;

    method &Add;
    method AddFailsWithDuplicate;
    method AddFailsWithNilKey;
    method AddValue;
    method AddValueFailsWithDuplicateKey;    
    method AddValueFailsWithNilKey;
    method AddValueFailsWithNilValue;
    method Clear;
    method ContainsKey;
    method ContainsKeyFailsWithNil;
    method &Remove;
    method RemoveFailsWithNil;
    method Count;
    method GetItem;
    method GetItemFailsWithNil;
    method GetItemFaulsWithMissingKey;
    method SetItemAddsNewValue;
    method SetItemUpdateExisting;
    method SetItemFailsWithNilKey;
    method SetItemFailsWithNilValue;
    method Keys;
    method Properties;
    method Enumerable;
  end;

implementation

method JsonObjectTest.Setup;
begin
  Obj := new JsonObject;
end;

method JsonObjectTest.Add;
begin
  Obj.Add("a", 42);
  Assert.AreEqual(Obj.Count, 1);
  Assert.AreEqual(Obj["a"].ToInteger, 42);
end;

method JsonObjectTest.AddFailsWithDuplicate;
begin
  &Add;
  Assert.Throws(->Obj.Add("a", 123));
end;

method JsonObjectTest.AddFailsWithNilKey;
begin
  Assert.Throws(->Obj.Add(nil, "abc"));
end;

method JsonObjectTest.AddValue;
begin
  Obj.AddValue("a", new JsonValue(42));
  Assert.AreEqual(Obj.Count, 1);
  Assert.AreEqual(Obj["a"].ToInteger, 42);
end;

method JsonObjectTest.AddValueFailsWithDuplicateKey;
begin
  AddValue;
  Assert.Throws(->Obj.AddValue("a", new JsonValue(nil)));
end;

method JsonObjectTest.AddValueFailsWithNilKey;
begin
  Assert.Throws(->Obj.AddValue(nil, new JsonValue(1)));
end;

method JsonObjectTest.AddValueFailsWithNilValue;
begin
  Assert.Throws(->Obj.AddValue("a", nil));
end;

method JsonObjectTest.Clear;
begin
  &Add;
  Obj.Clear;
  Assert.AreEqual(Obj.Count, 0);
end;

method JsonObjectTest.ContainsKey;
begin
  &Add;
  Assert.IsTrue(Obj.ContainsKey("a"));
  Assert.IsFalse(Obj.ContainsKey("b"));
end;

method JsonObjectTest.ContainsKeyFailsWithNil;
begin
  Assert.Throws(->Obj.ContainsKey(nil));
end;

method JsonObjectTest.Remove;
begin
  &Add;
  Assert.IsTrue(Obj.Remove("a"));
  Assert.IsFalse(Obj.Remove("a"));
end;

method JsonObjectTest.RemoveFailsWithNil;
begin
  Assert.Throws(->Obj.Remove(nil));
end;

method JsonObjectTest.Count;
begin
  Assert.AreEqual(Obj.Count, 0);
  &Add;
end;

method JsonObjectTest.GetItem;
begin
  &Add;
  Assert.AreEqual(Obj.Item["a"], new JsonValue(42));
  Assert.AreEqual(Obj["a"].ToInteger, 42);
end;

method JsonObjectTest.GetItemFailsWithNil;
begin
  Assert.Throws(->Obj[nil]);
end;

method JsonObjectTest.GetItemFaulsWithMissingKey;
begin
  Assert.Throws(->Obj.Item["abc"]);
end;

method JsonObjectTest.SetItemAddsNewValue;
begin
  Obj["a"] := new JsonValue(42);
  Assert.AreEqual(Obj.Count, 1);
  Assert.AreEqual(Obj["a"].ToInteger, 42);
end;

method JsonObjectTest.SetItemUpdateExisting;
begin
  &Add;
  Obj["a"] := new JsonValue(55);
  Assert.AreEqual(Obj.Count, 1);
  Assert.AreEqual(Obj["a"].ToInteger, 55);
end;

method JsonObjectTest.SetItemFailsWithNilKey;
begin
  Assert.Throws(->begin Obj[nil] := new JsonValue(1) end);
end;

method JsonObjectTest.SetItemFailsWithNilValue;
begin
  Assert.Throws(->begin Obj["a"] := nil end);
end;

method JsonObjectTest.Keys;
begin
  Assert.IsEmpty(Obj.Keys);
  &Add;
  Assert.AreEqual(Obj.Keys, ["a"]);
end;

method JsonObjectTest.Properties;
begin
  Assert.IsEmpty(Obj.Properties);
  &Add;
  Assert.AreEqual(Obj.Properties, [new Sugar.Collections.KeyValue<String,JsonValue>("a", new JsonValue(42))]);
end;

method JsonObjectTest.Enumerable;
begin
  Assert.IsEmpty(Obj);
  &Add;
  Assert.AreEqual(Obj, [new Sugar.Collections.KeyValue<String,JsonValue>("a", new JsonValue(42))]);
end;

end.
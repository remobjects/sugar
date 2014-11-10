namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.Data.JSON,
  RemObjects.Elements.EUnit;

type
  JsonArrayTest = public class (Test)
  private
    Obj: JsonArray;
  public
    method Setup; override;

    method &Add;
    method AddValue;
    method AddValueFailsWithNil;
    method Insert;
    method InsertFailsWithOutOfRange;
    method InsertValue;
    method InsertValueFailsWithNil;
    method InsertValueFailsWithOutOfRange;
    method Clear;
    method RemoveAt;
    method RemoveAtFailsWithOutOfRange;
    method Count;
    method GetItem;
    method GetItemFailsWithOutOfRange;
    method SetItem;
    method SetItemFailsWithNil;
    method SetItemFailsWithOutOfRange;
    method Enumerator;
  end;

implementation

method JsonArrayTest.Setup;
begin
  Obj := new JsonArray;
end;

method JsonArrayTest.Add;
begin
  Obj.Add(42);
  Assert.AreEqual(Obj.Count, 1);
  Assert.AreEqual(Obj[0].ToInteger, 42);
end;

method JsonArrayTest.AddValue;
begin
  Obj.AddValue(new JsonValue(42));
  Assert.AreEqual(Obj.Count, 1);
  Assert.AreEqual(Obj[0].ToInteger, 42);
end;

method JsonArrayTest.AddValueFailsWithNil;
begin
  Assert.Throws(->Obj.AddValue(nil));
end;

method JsonArrayTest.Insert;
begin
  Obj.Add(1);
  Obj.Add(2);
  Obj.Add(3);

  Obj.Insert(1, "a");
  Assert.AreEqual(Obj.Count, 4);
  Assert.AreEqual(Obj[1].ToStr, "a");
end;

method JsonArrayTest.InsertFailsWithOutOfRange;
begin
  Insert;
  Assert.Throws(->Obj.Insert(233, 1));
  Assert.Throws(->Obj.Insert(-5, 1));
end;

method JsonArrayTest.InsertValue;
begin
  Obj.Add(1);
  Obj.Add(2);
  Obj.Add(3);

  Obj.InsertValue(1, new JsonValue("a"));
  Assert.AreEqual(Obj.Count, 4);
  Assert.AreEqual(Obj[1].ToStr, "a");
end;

method JsonArrayTest.InsertValueFailsWithNil;
begin
  Assert.Throws(->Obj.InsertValue(0, nil));
end;

method JsonArrayTest.InsertValueFailsWithOutOfRange;
begin
  Insert;
  Assert.Throws(->Obj.InsertValue(233, new JsonValue(1)));
  Assert.Throws(->Obj.InsertValue(-5, new JsonValue(1)));
end;

method JsonArrayTest.Clear;
begin
  Insert;
  Obj.Clear;
  Assert.AreEqual(Obj.Count, 0);
end;

method JsonArrayTest.RemoveAt;
begin
  Insert;
  Obj.RemoveAt(1);
  Assert.AreEqual(Obj.Count, 3);
  Assert.AreEqual(Obj[1].ToInteger, 2);
end;

method JsonArrayTest.RemoveAtFailsWithOutOfRange;
begin
  Insert;
  Assert.Throws(->Obj.RemoveAt(55));
  Assert.Throws(->Obj.RemoveAt(-55));
end;

method JsonArrayTest.Count;
begin
  Assert.AreEqual(Obj.Count, 0);
  Insert;
  Assert.AreEqual(Obj.Count, 4);
end;

method JsonArrayTest.GetItem;
begin
  Insert;
  Assert.AreEqual(Obj.Item[1], new JsonValue("a"));
  Assert.AreEqual(Obj[0].ToInteger, 1);
end;

method JsonArrayTest.GetItemFailsWithOutOfRange;
begin
  Insert;
  Assert.Throws(->Obj[55]);
  Assert.Throws(->Obj.Item[-55]);
end;

method JsonArrayTest.SetItem;
begin
  Insert;
  Obj[1] := new JsonValue(true);
  Assert.AreEqual(Obj.Count, 4);
  Assert.AreEqual(Obj[1].ToBoolean, true);
end;

method JsonArrayTest.SetItemFailsWithNil;
begin
  Insert;
  Assert.Throws(->begin Obj[1] := nil; end);
end;

method JsonArrayTest.SetItemFailsWithOutOfRange;
begin
  Insert;
  Assert.Throws(->begin Obj[55] := new JsonValue(true); end);
  Assert.Throws(->begin Obj[-55] := new JsonValue(nil); end);
end;

method JsonArrayTest.Enumerator;
begin
  Assert.IsEmpty(Obj);
  Insert;
  Assert.AreEqual(Obj, [new JsonValue(1), new JsonValue("a"), new JsonValue(2), new JsonValue(3)]);
end;

end.

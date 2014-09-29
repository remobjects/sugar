namespace Sugar.Test;

interface

uses
  RemObjects.Elements.EUnit,
  Sugar,
  Sugar.Data.Json;

type
  JsonObjectReadTest = public class (Test)
  private
    const JsonData: String = "
    {
      ""name"": ""John Smith"",
      ""age"": 42,
      ""salary"": 1234.56,
      ""registered"": true,
      ""roles"": [""editor"", ""admin""],
      ""contacts"": {
        ""email"": ""j.smith@example.com"",
        ""icq"": 4364363737
      }
    }";
    var Obj: JsonObject;
  public
    method Setup; override;

    method Contains;
    method GetBoolean;
    method GetDouble;
    method GetInt32;
    method GetInt64;
    method GetJsonArray;
    method GetJsonObject;
    method GetString;
    method Keys;
    method Clear;
    method &Remove;
    method Count;
  end;

implementation

method JsonObjectReadTest.Setup;
begin
  Obj := new JsonObject(JsonData);
  Assert.IsNotNil(Obj);
end;

method JsonObjectReadTest.Contains;
begin
  Assert.IsTrue(Obj.Contains("name"));
  Assert.IsFalse(Obj.Contains("NAme"));
  Assert.IsTrue(Obj.Contains("roles"));
  Assert.IsFalse(Obj.Contains("picture"));
  Assert.IsFalse(Obj.Contains(nil));
end;

method JsonObjectReadTest.GetBoolean;
begin  
  Assert.IsTrue(Obj.GetBoolean("registered"));  
  Assert.Throws(->Obj.GetBoolean("age"));
  Assert.Throws(->Obj.GetBoolean("verified"));
  Assert.Throws(->Obj.GetBoolean(nil));
end;

method JsonObjectReadTest.GetDouble;
begin
  Assert.AreEqual(Obj.GetDouble("salary"), 1234.56);
  Assert.AreEqual(Obj.GetDouble("age"), 42);
  Assert.Throws(->Obj.GetDouble("registered"));
  Assert.Throws(->Obj.GetDouble("abc"));
  Assert.Throws(->Obj.GetDouble(nil));
  Assert.Throws(->Obj.GetDouble("name"));
end;

method JsonObjectReadTest.GetInt32;
begin
  Assert.AreEqual(Obj.GetInt32("age"), 42);
  Assert.AreEqual(Obj.GetInt32("salary"), 1234);
  Assert.Throws(->Obj.GetInt32("registered"));
  Assert.Throws(->Obj.GetInt32("abc"));
  Assert.Throws(->Obj.GetInt32(nil));
  Assert.Throws(->Obj.GetInt32("name"));
end;

method JsonObjectReadTest.GetInt64;
begin
  Assert.AreEqual(Obj.GetInt64("age"), 42);
  Assert.AreEqual(Obj.GetInt64("salary"), 1234);
  Assert.Throws(->Obj.GetInt64("registered"));
  Assert.Throws(->Obj.GetInt64("abc"));
  Assert.Throws(->Obj.GetInt64(nil));
  Assert.Throws(->Obj.GetInt64("name"));
end;

method JsonObjectReadTest.GetJsonArray;
begin
  var Roles := Obj.GetJsonArray("roles");
  Assert.IsNotNil(Roles);
  Assert.AreEqual(Roles.Count, 2);
  Assert.Throws(->Obj.GetJsonArray("contacts"));
  Assert.Throws(->Obj.GetJsonArray("abc"));
  Assert.Throws(->Obj.GetJsonArray(nil));
end;

method JsonObjectReadTest.GetJsonObject;
begin
  var Contacts := Obj.GetJsonObject("contacts");
  Assert.IsNotNil(Contacts);
  Assert.AreEqual(Contacts.Count, 2);
  Assert.Throws(->Obj.GetJsonObject("roles"));
  Assert.Throws(->Obj.GetJsonObject("abc"));
  Assert.Throws(->Obj.GetJsonObject(nil));
end;

method JsonObjectReadTest.GetString;
begin
  Assert.AreEqual(Obj.GetString("name"), "John Smith");
  Assert.Throws(->Obj.GetString("age"));
  Assert.Throws(->Obj.GetString("salary"));
  Assert.Throws(->Obj.GetString("registered"));
  Assert.Throws(->Obj.GetString("abc"));
  Assert.Throws(->Obj.GetString(nil));
end;

method JsonObjectReadTest.Keys;
begin
  Assert.IsNotEmpty(Obj.Keys);
  var Expected: array of String := ["name", "age", "salary", "registered", "roles", "contacts"];
  Assert.AreEqual(Obj.Keys, Expected, true);
end;

method JsonObjectReadTest.Clear;
begin
  Assert.AreEqual(Obj.Count, 6);
  Obj.Clear;
  Assert.AreEqual(Obj.Count, 0);
end;

method JsonObjectReadTest.Count;
begin
  Assert.AreEqual(Obj.Count, 6);
  Assert.IsTrue(Obj.Remove("name"));
  Assert.AreEqual(Obj.Count, 5);
  Obj.Clear;
  Assert.AreEqual(Obj.Count, 0);
end;

method JsonObjectReadTest.&Remove;
begin
  Assert.IsTrue(Obj.Contains("name"));
  Assert.IsTrue(Obj.Remove("name"));
  Assert.IsFalse(Obj.Contains("name"));
  Assert.IsFalse(Obj.Remove("name"));
  Assert.IsFalse(Obj.Remove(nil));
end;

end.
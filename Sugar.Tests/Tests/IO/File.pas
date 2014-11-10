namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.IO,
  RemObjects.Elements.EUnit;

type
  FileTest = public class (Test)
  private
    Dir: Folder;
    Data: File;
  public
    method Setup; override;
    method TearDown; override;
    method TestCopy;
    method Delete;
    method Move;
    method Rename;
    method FromPath;
    method PathProperty;
    method Name;
  end;

implementation

method FileTest.Setup;
begin
  Dir := Folder.UserLocal.CreateFolder("SugarFileTest", true);
  Assert.IsNotNil(Dir);
  Data := Dir.CreateFile("SugarTest.dat", true);
  Assert.IsNotNil(Data);
end;

method FileTest.TearDown;
begin
  if Dir <> nil then
    Dir.Delete;
end;

method FileTest.TestCopy;
begin
  var Temp := Dir.CreateFolder("Temp", true);
  Assert.IsNotNil(Temp);
  var Value := Data.Copy(Temp);
  Assert.IsNotNil(Value);
  Assert.IsNotNil(Temp.GetFile("SugarTest.dat"));
  Assert.IsNotNil(Dir.GetFile("SugarTest.dat"));
  Assert.Throws(->Value.Copy(Dir));
  Assert.Throws(->Value.Copy(nil));
  Value.Delete;

  Value := Data.Copy(Temp, "Test.dat");
  Assert.IsNotNil(Value);
  Assert.IsNotNil(Temp.GetFile("Test.dat"));
  Assert.IsNotNil(Dir.GetFile("SugarTest.dat"));
  Assert.Throws(->Value.Copy(Dir, "SugarTest.dat"));
  Assert.Throws(->Value.Copy(nil, "1"));
  Assert.Throws(->Value.Copy(Dir, nil));
  Assert.Throws(->Value.Copy(Dir, ""));
end;

method FileTest.Delete;
begin
  Assert.AreEqual(length(Dir.GetFiles), 1);
  Assert.IsNotNil(Dir.GetFile("SugarTest.dat"));
  Data.Delete;
  Assert.AreEqual(length(Dir.GetFiles), 0);
  Assert.IsNil(Dir.GetFile("SugarTest.dat"));
  Assert.Throws(->Data.Delete);
end;

method FileTest.Move;
begin
  var Temp := Dir.CreateFolder("Temp", true);
  Assert.IsNotNil(Temp);

  var Value := Data.Move(Temp);
  Assert.IsNotNil(Value);
  Assert.IsNotNil(Temp.GetFile("SugarTest.dat"));
  Assert.IsNil(Dir.GetFile("SugarTest.dat"));
  Assert.Throws(->Value.Move(Temp));
  Assert.Throws(->Value.Move(nil));

  Value := Value.Move(Dir, "Test.dat");
  Assert.IsNotNil(Value);
  Assert.IsNotNil(Dir.GetFile("Test.dat"));
  Assert.IsNil(Temp.GetFile("SugarTest.dat"));
  Assert.Throws(->Value.Move(Dir, "Test.dat"));
  Assert.Throws(->Value.Move(nil, "1"));
  Assert.Throws(->Value.Move(Dir, nil));
  Assert.Throws(->Value.Move(Dir, ""));
end;

method FileTest.Rename;
begin
  var Value := Data.Rename("Test.dat");
  Assert.IsNotNil(Value);
  Assert.AreEqual(Value.Name, "Test.dat");
  Assert.IsNotNil(Dir.GetFile("Test.dat"));
  Assert.IsNil(Dir.GetFile("SugarTest.dat"));
  Assert.Throws(->Data.Rename("Test.dat"));
  Assert.Throws(->Data.Rename(nil));
  Assert.Throws(->Data.Rename("/"));
  Assert.Throws(->Data.Rename(""));
end;

method FileTest.FromPath;
begin  
  Assert.IsNotNil(Dir.CreateFile("1.txt", true));
  Assert.IsNotNil(new File(Path.Combine(Dir.Path, "1.txt")));
  Assert.Throws(->new File(Path.Combine(Dir.Path, "2.txt")));
  Assert.Throws(->new File(nil));
end;

method FileTest.PathProperty;
begin
  Assert.IsFalse(String.IsNullOrEmpty(Data.Path));
  Assert.IsNotNil(Dir.CreateFile("1.txt", true));
  var Value := new File(Path.Combine(Dir.Path, "1.txt"));
  Assert.IsNotNil(Value);
  Assert.IsFalse(String.IsNullOrEmpty(Value.Path));
end;

method FileTest.Name;
begin
  Assert.IsFalse(String.IsNullOrEmpty(Data.Name));
  Assert.IsNotNil(Dir.CreateFile("1.txt", true));
  var Value := new File(Path.Combine(Dir.Path, "1.txt"));
  Assert.IsNotNil(Value);
  Assert.IsFalse(String.IsNullOrEmpty(Value.Name));
  Assert.AreEqual(Value.Name, "1.txt");
end;

end.
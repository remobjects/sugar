namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.IO,
  RemObjects.Elements.EUnit;

type
  FolderTest = public class (Test)
  private
    Data: Folder;
  public
    method Setup; override;
    method TearDown; override;
    method CreateFile;
    method CreateFolder;
    method Delete;
    method GetFile;
    method GetFiles;
    method GetFolder;
    method GetFolders;
    method Rename;
    method FromPath;
    method UserLocal;
    method PathProperty;
    method Name;
  end;

implementation

method FolderTest.Setup;
begin
  Data := Folder.UserLocal.CreateFolder("SugarTest", true);
  Assert.IsNotNil(Data);
end;

method FolderTest.TearDown;
begin
  Data.Delete;
end;

method FolderTest.CreateFile;
begin
  Assert.IsNil(Data.GetFile("Sample.txt"));
  var Value := Data.CreateFile("Sample.txt", true);
  Assert.IsNotNil(Value);
  Assert.IsNotNil(Data.GetFile("Sample.txt"));

  Value := Data.CreateFile("Sample.txt", false);
  Assert.IsNotNil(Value);
  Assert.AreEqual(length(Data.GetFiles), 1);

  Assert.Throws(->Data.CreateFile("Sample.txt", true));
  Assert.Throws(->Data.CreateFile("/", true));
  Assert.Throws(->Data.CreateFile(nil, true));
end;

method FolderTest.CreateFolder;
begin
  Assert.IsNil(Data.GetFolder("Sample"));
  var Value := Data.CreateFolder("Sample", true);
  Assert.IsNotNil(Value);
  Assert.IsNotNil(Data.GetFolder("Sample"));

  Value := Data.CreateFolder("Sample", false);
  Assert.IsNotNil(Value);
  Assert.AreEqual(length(Data.GetFolders), 1);

  Assert.Throws(->Data.CreateFolder("Sample", true));
  Assert.Throws(->Data.CreateFolder("/", true));
  Assert.Throws(->Data.CreateFolder(nil, true));
end;

method FolderTest.Delete;
begin  
  Assert.IsNil(Data.GetFolder("Sample"));
  var Value := Data.CreateFolder("Sample", true);
  Assert.IsNotNil(Value);
  Assert.IsNotNil(Data.GetFolder("Sample"));
  Assert.AreEqual(length(Data.GetFolders), 1);
  Value.Delete;
  Assert.IsNil(Data.GetFolder("Sample"));
  Assert.AreEqual(length(Data.GetFolders), 0);
  Assert.Throws(->Value.Delete);
end;

method FolderTest.GetFile;
begin
  Assert.IsNil(Data.GetFile("Sample.txt"));
  Assert.IsNotNil(Data.CreateFile("Sample.txt", true));
  var Value := Data.GetFile("Sample.txt");
  Assert.IsNotNil(Value);
  Assert.Throws(->Data.GetFile(nil));
end;

method FolderTest.GetFiles;
begin
  Assert.AreEqual(length(Data.GetFolders), 0);
  Assert.AreEqual(length(Data.GetFiles), 0);
  //setup
  Data.CreateFile("1", true);
  Data.CreateFile("2", true);
  Data.CreateFile("3", true);
  Data.CreateFolder("Temp1", true);
  Data.CreateFolder("Temp2", true);
  Assert.AreEqual(length(Data.GetFolders), 2);
  Assert.AreEqual(length(Data.GetFiles), 3);

  var Expected := new Sugar.Collections.List<String>;
  Expected.Add("1");
  Expected.Add("2");
  Expected.Add("3");
  var Value := Data.GetFiles;  
  Assert.AreEqual(length(Value), 3);
  for i: Integer := 0 to length(Value) - 1 do
    Assert.IsTrue(Expected.Contains(Value[i].Name));
end;

method FolderTest.GetFolder;
begin
  Assert.IsNil(Data.GetFolder("Sample"));
  Assert.IsNotNil(Data.CreateFolder("Sample", true));
  var Value := Data.GetFolder("Sample");
  Assert.IsNotNil(Value);
  Assert.Throws(->Data.GetFolder(nil));
end;

method FolderTest.GetFolders;
begin
  Assert.AreEqual(length(Data.GetFolders), 0);
  Assert.AreEqual(length(Data.GetFiles), 0);
  //setup
  Data.CreateFile("1", true);
  Data.CreateFile("2", true);
  Data.CreateFile("3", true);
  Data.CreateFolder("Temp1", true);
  Data.CreateFolder("Temp2", true);
  Assert.AreEqual(length(Data.GetFolders), 2);
  Assert.AreEqual(length(Data.GetFiles), 3);

  var Expected := new Sugar.Collections.List<String>;
  Expected.Add("Temp1");
  Expected.Add("Temp2");
  var Value := Data.GetFolders;
  Assert.AreEqual(length(Value), 2);
  for i: Integer := 0 to length(Value) - 1 do
    Assert.IsTrue(Expected.Contains(Value[i].Name));
end;

method FolderTest.Rename;
begin
  var Value := Data.CreateFolder("Sample", true);
  Assert.IsNotNil(Value);
  Assert.IsNotNil(Value.CreateFolder("Test", true));
  Assert.IsNotNil(Value.CreateFile("1.txt", true));
  var OldPath := Value.Path;
  Value.Rename("Temp");
  Assert.IsTrue(OldPath <> Value.Path);
  Assert.IsNil(Data.GetFolder("Sample"));
  Assert.IsNotNil(Data.GetFolder("Temp"));

  Assert.Throws(->Value.Rename("Temp"));
  Data.CreateFolder("Temp1", true);
  Assert.Throws(->Value.Rename("Temp1"));
  Assert.Throws(->Value.Rename("/"));
  Assert.Throws(->Value.Rename(nil));
  Assert.Throws(->Value.Rename(""));
end;

method FolderTest.FromPath;
begin  
  Assert.IsNotNil(Data.CreateFolder("Sample", true));
  Assert.IsNotNil(new Folder(Path.Combine(Data.Path, "Sample")));
  Assert.Throws(->new Folder(Path.Combine(Data.Path, "Unknown")));
  Assert.Throws(->new Folder(nil));
end;

method FolderTest.UserLocal;
begin
  Assert.IsNotNil(Folder.UserLocal);
end;

method FolderTest.PathProperty;
begin
  Assert.IsFalse(String.IsNullOrEmpty(Data.Path));
  Assert.IsNotNil(Data.CreateFolder("Sample", true));
  var Value := new Folder(Path.Combine(Data.Path, "Sample"));
  Assert.IsNotNil(Value);
  Assert.IsFalse(String.IsNullOrEmpty(Value.Path));
end;

method FolderTest.Name;
begin
  Assert.IsFalse(String.IsNullOrEmpty(Data.Name));
  Assert.IsNotNil(Data.CreateFolder("Sample", true));
  var Value := new Folder(Path.Combine(Data.Path, "Sample"));
  Assert.IsNotNil(Value);
  Assert.IsFalse(String.IsNullOrEmpty(Value.Name));
  Assert.AreEqual(Value.Name, "Sample");
end;

end.

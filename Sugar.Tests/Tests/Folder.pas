namespace Sugar.Test;

interface

{$HIDE W0} //supress case-mismatch errors

uses
  Sugar,
  Sugar.IO,
  Sugar.TestFramework;

type
  FolderTest = public class (Testcase)
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
    method Path;
    method Name;
  end;

implementation

method FolderTest.Setup;
begin
  Data := Folder.UserLocal.CreateFolder("SugarTest", true);
  Assert.IsNotNull(Data);
end;

method FolderTest.TearDown;
begin
  Data.Delete;
end;

method FolderTest.CreateFile;
begin
  Assert.IsNull(Data.GetFile("Sample.txt"));
  var Value := Data.CreateFile("Sample.txt", true);
  Assert.IsNotNull(Value);
  Assert.IsNotNull(Data.GetFile("Sample.txt"));

  Value := Data.CreateFile("Sample.txt", false);
  Assert.IsNotNull(Value);
  Assert.CheckInt(1, length(Data.GetFiles));

  Assert.IsException(->Data.CreateFile("Sample.txt", true));
  Assert.IsException(->Data.CreateFile("/", true));
  Assert.IsException(->Data.CreateFile(nil, true));
end;

method FolderTest.CreateFolder;
begin
  Assert.IsNull(Data.GetFolder("Sample"));
  var Value := Data.CreateFolder("Sample", true);
  Assert.IsNotNull(Value);
  Assert.IsNotNull(Data.GetFolder("Sample"));

  Value := Data.CreateFolder("Sample", false);
  Assert.IsNotNull(Value);
  Assert.CheckInt(1, length(Data.GetFolders));

  Assert.IsException(->Data.CreateFolder("Sample", true));
  Assert.IsException(->Data.CreateFolder("/", true));
  Assert.IsException(->Data.CreateFolder(nil, true));
end;

method FolderTest.Delete;
begin  
  Assert.IsNull(Data.GetFolder("Sample"));
  var Value := Data.CreateFolder("Sample", true);
  Assert.IsNotNull(Value);
  Assert.IsNotNull(Data.GetFolder("Sample"));
  Assert.CheckInt(1, length(Data.GetFolders));
  Value.Delete;
  Assert.IsNull(Data.GetFolder("Sample"));
  Assert.CheckInt(0, length(Data.GetFolders));
  Assert.IsException(->Value.Delete);
end;

method FolderTest.GetFile;
begin
  Assert.IsNull(Data.GetFile("Sample.txt"));
  Assert.IsNotNull(Data.CreateFile("Sample.txt", true));
  var Value := Data.GetFile("Sample.txt");
  Assert.IsNotNull(Value);
  Assert.IsException(->Data.GetFile(nil));
end;

method FolderTest.GetFiles;
begin
  Assert.CheckInt(0, length(Data.GetFolders));
  Assert.CheckInt(0, length(Data.GetFiles));
  //setup
  Data.CreateFile("1", true);
  Data.CreateFile("2", true);
  Data.CreateFile("3", true);
  Data.CreateFolder("Temp1", true);
  Data.CreateFolder("Temp2", true);
  Assert.CheckInt(2, length(Data.GetFolders));
  Assert.CheckInt(3, length(Data.GetFiles));

  var Expected := new Sugar.Collections.List<String>;
  Expected.Add("1");
  Expected.Add("2");
  Expected.Add("3");
  var Value := Data.GetFiles;
  Assert.CheckInt(3, length(Value));
  for i: Integer := 0 to length(Value) - 1 do
    Assert.CheckBool(true, Expected.Contains(Value[i].Name));
end;

method FolderTest.GetFolder;
begin
  Assert.IsNull(Data.GetFolder("Sample"));
  Assert.IsNotNull(Data.CreateFolder("Sample", true));
  var Value := Data.GetFolder("Sample");
  Assert.IsNotNull(Value);
  Assert.IsException(->Data.GetFolder(nil));
end;

method FolderTest.GetFolders;
begin
  Assert.CheckInt(0, length(Data.GetFolders));
  Assert.CheckInt(0, length(Data.GetFiles));
  //setup
  Data.CreateFile("1", true);
  Data.CreateFile("2", true);
  Data.CreateFile("3", true);
  Data.CreateFolder("Temp1", true);
  Data.CreateFolder("Temp2", true);
  Assert.CheckInt(2, length(Data.GetFolders));
  Assert.CheckInt(3, length(Data.GetFiles));

  var Expected := new Sugar.Collections.List<String>;
  Expected.Add("Temp1");
  Expected.Add("Temp2");
  var Value := Data.GetFolders;
  Assert.CheckInt(2, length(Value));
  for i: Integer := 0 to length(Value) - 1 do
    Assert.CheckBool(true, Expected.Contains(Value[i].Name));
end;

method FolderTest.Rename;
begin
  var Value := Data.CreateFolder("Sample", true);
  Assert.IsNotNull(Value);
  Assert.IsNotNull(Value.CreateFolder("Test", true));
  Assert.IsNotNull(Value.CreateFile("1.txt", true));
  var OldPath := Value.Path;
  Value.Rename("Temp");
  Assert.CheckBool(true, OldPath <> Value.Path);
  Assert.IsNull(Data.GetFolder("Sample"));
  Assert.IsNotNull(Data.GetFolder("Temp"));

  Assert.IsException(->Value.Rename("Temp"));
  Data.CreateFolder("Temp1", true);
  Assert.IsException(->Value.Rename("Temp1"));
  Assert.IsException(->Value.Rename("/"));
  Assert.IsException(->Value.Rename(nil));
  Assert.IsException(->Value.Rename(""));
end;

method FolderTest.FromPath;
begin
  Assert.IsNotNull(Data.CreateFolder("Sample", true));
  Assert.IsNotNull(new Folder(Data.Path +Folder.Separator+"Sample"));
  Assert.IsException(->new Folder(Data.Path +Folder.Separator+"Unknown"));
  Assert.IsException(->new Folder(nil));
end;

method FolderTest.UserLocal;
begin
  Assert.IsNotNull(Folder.UserLocal);
end;

method FolderTest.Path;
begin
  Assert.CheckBool(false, String.IsNullOrEmpty(Data.Path));
  Assert.IsNotNull(Data.CreateFolder("Sample", true));
  var Value := new Folder(Data.Path +Folder.Separator+"Sample");
  Assert.IsNotNull(Value);
  Assert.CheckBool(false, String.IsNullOrEmpty(Value.Path));
end;

method FolderTest.Name;
begin
  Assert.CheckBool(false, String.IsNullOrEmpty(Data.Name));
  Assert.IsNotNull(Data.CreateFolder("Sample", true));
  var Value := new Folder(Data.Path +Folder.Separator+"Sample");
  Assert.IsNotNull(Value);
  Assert.CheckBool(false, String.IsNullOrEmpty(Value.Name));
  Assert.CheckString("Sample", Value.Name);
end;

end.

namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.IO,
  Sugar.TestFramework;

type
  FolderUtilsTest = public class (Testcase)
  private
    FolderName: String;
    SubFolder: String;
  public
    method Setup; override;
    method TearDown; override;

    method &Create;
    method Delete;
    method Exists;
    method GetFiles;
    method GetFolders;
  end;

implementation

method FolderUtilsTest.Setup;
begin
  var lFolder := Folder.UserLocal.CreateFolder("SugarTest", false);
  FolderName := lFolder.Path;
  SubFolder := Path.Combine(lFolder.Path, "SubFolder");
end;

method FolderUtilsTest.TearDown;
begin
  if FolderUtils.Exists(FolderName) then
    FolderUtils.Delete(FolderName);
end;

method FolderUtilsTest.Create;
begin
  Assert.CheckBool(false, FolderUtils.Exists(SubFolder));
  FolderUtils.Create(SubFolder);
  Assert.CheckBool(true, FolderUtils.Exists(SubFolder));

  Assert.IsException(->FolderUtils.Create(SubFolder));
  Assert.IsException(->FolderUtils.Create(nil));
end;

method FolderUtilsTest.Delete;
begin
  Assert.CheckBool(false, FolderUtils.Exists(SubFolder));
  FolderUtils.Create(SubFolder);
  Assert.CheckBool(true, FolderUtils.Exists(SubFolder));
  FolderUtils.Delete(SubFolder);
  Assert.CheckBool(false, FolderUtils.Exists(SubFolder));

  Assert.IsException(->FolderUtils.Delete(SubFolder));
  Assert.IsException(->FolderUtils.Delete(nil));

  FolderUtils.Create(SubFolder);
  FileUtils.Create(Path.Combine(SubFolder, "1"));
  FileUtils.Create(Path.Combine(SubFolder, "2"));
  FolderUtils.Delete(FolderName);
  Assert.CheckBool(false, FolderUtils.Exists(FolderName));
end;

method FolderUtilsTest.Exists;
begin
  Assert.CheckBool(false, FolderUtils.Exists(SubFolder));
  FolderUtils.Create(SubFolder);
  Assert.CheckBool(true, FolderUtils.Exists(SubFolder));
  FolderUtils.Delete(SubFolder);
  Assert.CheckBool(false, FolderUtils.Exists(SubFolder));
  Assert.IsException(->FolderUtils.Exists(nil));
end;

method FolderUtilsTest.GetFiles;
begin
  FileUtils.Create(Path.Combine(FolderName, "1"));
  FileUtils.Create(Path.Combine(FolderName, "2"));
  FolderUtils.Create(SubFolder);
  FileUtils.Create(Path.Combine(SubFolder, "3"));
  FileUtils.Create(Path.Combine(SubFolder, "4"));

  var Actual := FolderUtils.GetFiles(FolderName, false);
  var Expected := new Sugar.Collections.List<String>;
  Expected.Add(Path.Combine(FolderName, "1"));
  Expected.Add(Path.Combine(FolderName, "2"));

  Assert.CheckInt(2, length(Actual));
  for i: Integer := 0 to length(Actual) - 1 do
    Assert.CheckBool(true, Expected.Contains(Actual[i]));

  Actual := FolderUtils.GetFiles(FolderName, true);
  Expected.Clear;
  Expected.Add(Path.Combine(FolderName, "1"));
  Expected.Add(Path.Combine(FolderName, "2"));
  Expected.Add(Path.Combine(SubFolder, "3"));
  Expected.Add(Path.Combine(SubFolder, "4"));

  Assert.CheckInt(4, length(Actual));
  for i: Integer := 0 to length(Actual) - 1 do
    Assert.CheckBool(true, Expected.Contains(Actual[i]));
end;

method FolderUtilsTest.GetFolders;
begin
  FolderUtils.Create(SubFolder);
  FileUtils.Create(Path.Combine(SubFolder, "1"));
  FolderUtils.Create(Path.Combine(SubFolder, "NewFolder"));

  var Actual := FolderUtils.GetFolders(FolderName, false);  
  Assert.CheckInt(1, length(Actual));
  Assert.CheckString(SubFolder, Actual[0]);

  Actual := FolderUtils.GetFolders(FolderName, true);
  var Expected := new Sugar.Collections.List<String>;
  Expected.Add(SubFolder);
  Expected.Add(Path.Combine(SubFolder, "NewFolder"));

  Assert.CheckInt(2, length(Actual));
  for i: Integer := 0 to length(Actual) - 1 do
    Assert.CheckBool(true, Expected.Contains(Actual[i]));
end;

end.
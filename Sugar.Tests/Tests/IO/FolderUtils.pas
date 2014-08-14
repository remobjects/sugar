namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.IO,
  RemObjects.Elements.EUnit;

type
  FolderUtilsTest = public class (Test)
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
  Assert.IsFalse(FolderUtils.Exists(SubFolder));
  FolderUtils.Create(SubFolder);
  Assert.IsTrue(FolderUtils.Exists(SubFolder));

  Assert.Throws(->FolderUtils.Create(SubFolder));
  Assert.Throws(->FolderUtils.Create(nil));
end;

method FolderUtilsTest.Delete;
begin
  Assert.IsFalse(FolderUtils.Exists(SubFolder));
  FolderUtils.Create(SubFolder);
  Assert.IsTrue(FolderUtils.Exists(SubFolder));
  FolderUtils.Delete(SubFolder);
  Assert.IsFalse(FolderUtils.Exists(SubFolder));

  Assert.Throws(->FolderUtils.Delete(SubFolder));
  Assert.Throws(->FolderUtils.Delete(nil));

  FolderUtils.Create(SubFolder);
  FileUtils.Create(Path.Combine(SubFolder, "1"));
  FileUtils.Create(Path.Combine(SubFolder, "2"));
  FolderUtils.Delete(FolderName);
  Assert.IsFalse(FolderUtils.Exists(FolderName));
end;

method FolderUtilsTest.Exists;
begin
  Assert.IsFalse(FolderUtils.Exists(SubFolder));
  FolderUtils.Create(SubFolder);
  Assert.IsTrue(FolderUtils.Exists(SubFolder));
  FolderUtils.Delete(SubFolder);
  Assert.IsFalse(FolderUtils.Exists(SubFolder));
  Assert.Throws(->FolderUtils.Exists(nil));
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
  Assert.AreEqual(Actual, Expected, true);

  Actual := FolderUtils.GetFiles(FolderName, true);
  Expected.Clear;
  Expected.Add(Path.Combine(FolderName, "1"));
  Expected.Add(Path.Combine(FolderName, "2"));
  Expected.Add(Path.Combine(SubFolder, "3"));
  Expected.Add(Path.Combine(SubFolder, "4"));
  Assert.AreEqual(Actual, Expected, true);
end;

method FolderUtilsTest.GetFolders;
begin
  FolderUtils.Create(SubFolder);
  FileUtils.Create(Path.Combine(SubFolder, "1"));
  FolderUtils.Create(Path.Combine(SubFolder, "NewFolder"));

  var Actual := FolderUtils.GetFolders(FolderName, false);  
  Assert.AreEqual(length(Actual), 1);
  Assert.AreEqual(Actual[0], SubFolder);

  Actual := FolderUtils.GetFolders(FolderName, true);
  var Expected := new Sugar.Collections.List<String>;
  Expected.Add(SubFolder);
  Expected.Add(Path.Combine(SubFolder, "NewFolder"));
  Assert.AreEqual(Actual, Expected, true);
end;

end.
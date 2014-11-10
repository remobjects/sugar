namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.IO,
  RemObjects.Elements.EUnit;

type
  PathTest = public class (Test)
  private
    property FolderPath: String read Folder.UserLocal.Path;
  public
    method ChangeExtension;
    method Combine;
    method GetParentDirectory;
    method GetExtension;
    method GetFileName;
    method GetFileNameWithoutExtension;
    method RemoveExtension;
  end;

implementation

method PathTest.ChangeExtension;
begin
  Assert.AreEqual(Path.ChangeExtension("1.txt", "jpg"), "1.jpg");
  Assert.AreEqual(Path.ChangeExtension("1.txt.jpg", "zip"), "1.txt.zip");
  Assert.AreEqual(Path.ChangeExtension("1", "txt"), "1.txt");
  Assert.AreEqual(Path.ChangeExtension("1", ".txt"), "1.txt");
  Assert.AreEqual(Path.ChangeExtension("1.", "txt"), "1.txt");
  Assert.AreEqual(Path.ChangeExtension("1.", ".txt"), "1.txt");
  Assert.AreEqual(Path.ChangeExtension("", "txt"), ".txt");
  Assert.AreEqual(Path.ChangeExtension("1", ""), "1");
  Assert.AreEqual(Path.ChangeExtension("1.", ""), "1.");
  Assert.AreEqual(Path.ChangeExtension("1.txt", nil), "1");
  Assert.AreEqual(Path.ChangeExtension(Path.Combine(FolderPath, "1.txt"), "jpg"), Path.Combine(FolderPath, "1.jpg"));

  Assert.Throws(->Path.ChangeExtension(nil, ""));
end;

method PathTest.Combine;
begin
  Assert.AreEqual(Path.Combine("", "1.txt"), "1.txt");
  Assert.AreEqual(Path.Combine(nil, "1.txt"), "1.txt");
  Assert.AreEqual(Path.Combine(FolderPath, "1.txt"), FolderPath + Folder.Separator + "1.txt");
  Assert.AreEqual(Path.Combine(FolderPath + Folder.Separator, "1.txt"), FolderPath + Folder.Separator + "1.txt");
  Assert.AreEqual(Path.Combine(FolderPath, "Folder"), FolderPath + Folder.Separator + "Folder");
  Assert.AreEqual(Path.Combine(FolderPath, ""), FolderPath);
  Assert.AreEqual(Path.Combine(FolderPath, nil), FolderPath);
  
  Assert.Throws(->Path.Combine(nil, nil));
  Assert.Throws(->Path.Combine(nil, ""));
  Assert.Throws(->Path.Combine("", ""));
  Assert.Throws(->Path.Combine("", nil));

  Assert.AreEqual(Path.Combine(FolderPath, "NewFolder", "1.txt"), FolderPath + Folder.Separator + "NewFolder" + Folder.Separator + "1.txt");
end;

method PathTest.GetParentDirectory;
begin
  Assert.AreEqual(Path.GetParentDirectory(Path.Combine("root", "1.txt")), "root");
  Assert.AreEqual(Path.GetParentDirectory(Path.Combine("root", "folder1", "folder2")), Path.Combine("root", "folder1"));
  Assert.AreEqual(Path.GetParentDirectory(Path.Combine("root", "folder1")), "root");
  Assert.IsNil(Path.GetParentDirectory("root"));
  Assert.IsNil(Path.GetParentDirectory("root" + Folder.Separator));
  Assert.IsNil(Path.GetParentDirectory("1.txt"));
  Assert.IsNil(Path.GetParentDirectory(""));

  Assert.Throws(->Path.GetParentDirectory(nil));
end;

method PathTest.GetExtension;
begin
  Assert.AreEqual(Path.GetExtension("1.txt"), ".txt");
  Assert.AreEqual(Path.GetExtension("1.txt.jpg"), ".jpg");
  Assert.AreEqual(Path.GetExtension("1"), "");
  Assert.AreEqual(Path.GetExtension("1."), "");
  Assert.AreEqual(Path.GetExtension(Path.Combine(FolderPath, "1.txt")), ".txt");

  Assert.Throws(->Path.GetExtension(nil));
end;

method PathTest.GetFileName;
begin
  Assert.AreEqual(Path.GetFileName("1.txt"), "1.txt");
  Assert.AreEqual(Path.GetFileName(Folder.Separator + "1.txt"), "1.txt");
  Assert.AreEqual(Path.GetFileName("1.txt.jpg"), "1.txt.jpg");
  Assert.AreEqual(Path.GetFileName(""), "");
  Assert.AreEqual(Path.GetFileName(Folder.Separator), "");
  Assert.AreEqual(Path.GetFileName(Path.Combine("root", "folder1", "folder2")), "folder2");
  Assert.AreEqual(Path.GetFileName(Path.Combine("root", "folder1")), "folder1");
  Assert.AreEqual(Path.GetFileName("root"), "root");
  Assert.AreEqual(Path.GetFileName("root" + Folder.Separator), "root");

  Assert.AreEqual(Path.GetFileName(Path.Combine(FolderPath, "1.txt")), "1.txt");

  Assert.Throws(->Path.GetFileName(nil));
end;

method PathTest.GetFileNameWithoutExtension;
begin
  Assert.AreEqual(Path.GetFileNameWithoutExtension("1.txt"), "1");
  Assert.AreEqual(Path.GetFileNameWithoutExtension(Folder.Separator + "1.txt"), "1");
  Assert.AreEqual(Path.GetFileNameWithoutExtension("1.txt.jpg"), "1.txt");
  Assert.AreEqual(Path.GetFileNameWithoutExtension(""), "");
  Assert.AreEqual(Path.GetFileNameWithoutExtension(Folder.Separator), "");

  Assert.AreEqual(Path.GetFileNameWithoutExtension(Path.Combine(FolderPath, "1.txt")), "1");

  Assert.Throws(->Path.GetFileNameWithoutExtension(nil));
end;

method PathTest.RemoveExtension;
begin
  Assert.AreEqual(Path.RemoveExtension("1.txt"), "1");
  Assert.AreEqual(Path.RemoveExtension("1.txt.jpg"), "1.txt");
  Assert.AreEqual(Path.RemoveExtension("1.1.txt"), "1.1");
  Assert.AreEqual(Path.RemoveExtension("1."), "1");
  Assert.AreEqual(Path.RemoveExtension("1"), "1");
  Assert.AreEqual(Path.RemoveExtension(""), "");
  
  Assert.Throws(->Path.RemoveExtension(nil));
end;

end.

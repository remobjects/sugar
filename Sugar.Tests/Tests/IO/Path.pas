namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.IO,
  Sugar.TestFramework;

type
  PathTest = public class (Testcase)
  private
    property FolderPath: String read Folder.UserLocal.Path;
  public
    method ChangeExtension;
    method Combine;
    method GetDirectoryName;
    method GetExtension;
    method GetFileName;
    method GetFileNameWithoutExtension;
    method RemoveExtension;
  end;

implementation

method PathTest.ChangeExtension;
begin
  Assert.CheckString("1.jpg", Path.ChangeExtension("1.txt", "jpg"));
  Assert.CheckString("1.txt.zip", Path.ChangeExtension("1.txt.jpg", "zip"));
  Assert.CheckString("1.txt", Path.ChangeExtension("1", "txt"));
  Assert.CheckString("1.txt", Path.ChangeExtension("1", ".txt"));
  Assert.CheckString("1.txt", Path.ChangeExtension("1.", "txt"));
  Assert.CheckString("1.txt", Path.ChangeExtension("1.", ".txt"));
  Assert.CheckString(".txt", Path.ChangeExtension("", "txt"));
  Assert.CheckString("1", Path.ChangeExtension("1", ""));
  Assert.CheckString("1.", Path.ChangeExtension("1.", ""));
  Assert.CheckString("1", Path.ChangeExtension("1.txt", nil));
  Assert.CheckString(Path.Combine(FolderPath, "1.jpg"), Path.ChangeExtension(Path.Combine(FolderPath, "1.txt"), "jpg"));

  Assert.IsException(->Path.ChangeExtension(nil, ""));
end;

method PathTest.Combine;
begin
  Assert.CheckString("1.txt", Path.Combine("", "1.txt"));
  Assert.CheckString("1.txt", Path.Combine(nil, "1.txt"));
  Assert.CheckString(FolderPath + Folder.Separator + "1.txt", Path.Combine(FolderPath, "1.txt"));
  Assert.CheckString(FolderPath + Folder.Separator + "1.txt", Path.Combine(FolderPath + Folder.Separator, "1.txt"));
  Assert.CheckString(FolderPath + Folder.Separator + "Folder", Path.Combine(FolderPath, "Folder"));
  Assert.CheckString(FolderPath, Path.Combine(FolderPath, ""));
  Assert.CheckString(FolderPath, Path.Combine(FolderPath, nil));
  
  Assert.IsException(->Path.Combine(nil, nil));
  Assert.IsException(->Path.Combine(nil, ""));
  Assert.IsException(->Path.Combine("", ""));
  Assert.IsException(->Path.Combine("", nil));

  Assert.CheckString(FolderPath + Folder.Separator + "NewFolder" + Folder.Separator + "1.txt", Path.Combine(FolderPath, "NewFolder", "1.txt"));
end;

method PathTest.GetDirectoryName;
begin
  Assert.CheckString("root", Path.GetDirectoryName(Path.Combine("root", "1.txt")));
  Assert.CheckString(Path.Combine("root", "folder1"), Path.GetDirectoryName(Path.Combine("root", "folder1", "folder2")));
  Assert.CheckString("root", Path.GetDirectoryName(Path.Combine("root", "folder1")));
  Assert.IsNull(Path.GetDirectoryName("root"));
  Assert.IsNull(Path.GetDirectoryName("root" + Folder.Separator));
  Assert.IsNull(Path.GetDirectoryName("1.txt"));
  Assert.IsNull(Path.GetDirectoryName(""));

  Assert.IsException(->Path.GetDirectoryName(nil));
end;

method PathTest.GetExtension;
begin
  Assert.CheckString("txt", Path.GetExtension("1.txt"));
  Assert.CheckString("jpg", Path.GetExtension("1.txt.jpg"));
  Assert.CheckString("", Path.GetExtension("1"));
  Assert.CheckString("", Path.GetExtension("1."));
  Assert.CheckString("txt", Path.GetExtension(Path.Combine(FolderPath, "1.txt")));

  Assert.IsException(->Path.GetExtension(nil));
end;

method PathTest.GetFileName;
begin
  Assert.CheckString("1.txt", Path.GetFileName("1.txt"));
  Assert.CheckString("1.txt", Path.GetFileName(Folder.Separator + "1.txt"));
  Assert.CheckString("1.txt.jpg", Path.GetFileName("1.txt.jpg"));
  Assert.CheckString("", Path.GetFileName(""));
  Assert.CheckString("", Path.GetFileName(Folder.Separator));

  Assert.CheckString("1.txt", Path.GetFileName(Path.Combine(FolderPath, "1.txt")));

  Assert.IsException(->Path.GetFileName(nil));
end;

method PathTest.GetFileNameWithoutExtension;
begin
  Assert.CheckString("1", Path.GetFileNameWithoutExtension("1.txt"));
  Assert.CheckString("1", Path.GetFileNameWithoutExtension(Folder.Separator + "1.txt"));
  Assert.CheckString("1.txt", Path.GetFileNameWithoutExtension("1.txt.jpg"));
  Assert.CheckString("", Path.GetFileNameWithoutExtension(""));
  Assert.CheckString("", Path.GetFileNameWithoutExtension(Folder.Separator));

  Assert.CheckString("1", Path.GetFileNameWithoutExtension(Path.Combine(FolderPath, "1.txt")));

  Assert.IsException(->Path.GetFileNameWithoutExtension(nil));
end;

method PathTest.RemoveExtension;
begin
  Assert.CheckString("1", Path.RemoveExtension("1.txt"));
  Assert.CheckString("1.txt", Path.RemoveExtension("1.txt.jpg"));
  Assert.CheckString("1.1", Path.RemoveExtension("1.1.txt"));
  Assert.CheckString("1", Path.RemoveExtension("1."));
  Assert.CheckString("1", Path.RemoveExtension("1"));
  Assert.CheckString("", Path.RemoveExtension(""));  
  
  Assert.IsException(->Path.RemoveExtension(nil));
end;

end.

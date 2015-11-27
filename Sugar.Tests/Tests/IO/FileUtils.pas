namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.IO,
  RemObjects.Elements.EUnit;

type
  FileUtilsTest = public class (Test)
  private
    const NAME: String = "sugar.testcase.txt";
  private
    FileName: String;
    CopyName: String;
  public
    method Setup; override;
    method TearDown; override;

    method CopyTest;
    method Create;
    method Delete;
    method Exists;
    method Move;
    method AppendText;
    method AppendBytes;
    method AppendBinary;
    method ReadText;
    method ReadBytes;
    method ReadBinary;
    method WriteBytes;
    method WriteText;
    method WriteBinary;
  end;

implementation

method FileUtilsTest.Setup;
begin
  var aFile := Folder.UserLocal.CreateFile(NAME, false);
  FileUtils.WriteText(aFile.Path, "");
  FileName := aFile.Path;
  CopyName := FileName+".copy";
end;

method FileUtilsTest.TearDown;
begin
  if FileUtils.Exists(FileName) then
    FileUtils.Delete(FileName);
  if FileUtils.Exists(CopyName) then
    FileUtils.Delete(CopyName);
end;

method FileUtilsTest.CopyTest;
begin
  Assert.IsTrue(FileUtils.Exists(FileName));
  Assert.IsFalse(FileUtils.Exists(CopyName));
  FileUtils.Copy(FileName, CopyName);
  Assert.IsTrue(FileUtils.Exists(FileName));
  Assert.IsTrue(FileUtils.Exists(CopyName));
  
  Assert.Throws(->FileUtils.Copy(FileName, CopyName));
  Assert.Throws(->FileUtils.Copy(nil, CopyName));
  Assert.Throws(->FileUtils.Copy(FileName, nil));
  Assert.Throws(->FileUtils.Copy(FileName+"doesnotexists", CopyName));
end;

method FileUtilsTest.Create;
begin
  Assert.IsFalse(FileUtils.Exists(CopyName));
  FileUtils.Create(CopyName);
  Assert.IsTrue(FileUtils.Exists(CopyName));
  Assert.Throws(->FileUtils.Create(CopyName));
  Assert.Throws(->FileUtils.Create(nil));
end;

method FileUtilsTest.Delete;
begin
  Assert.IsFalse(FileUtils.Exists(CopyName));
  Assert.Throws(->FileUtils.Delete(CopyName));
  Assert.Throws(->FileUtils.Delete(nil));  
  
  Assert.IsTrue(FileUtils.Exists(FileName));
  FileUtils.Delete(FileName);
  Assert.IsFalse(FileUtils.Exists(FileName));  
end;

method FileUtilsTest.Exists;
begin
  Assert.IsTrue(FileUtils.Exists(FileName));
  Assert.IsFalse(FileUtils.Exists(CopyName));
  FileUtils.Create(CopyName);
  Assert.IsTrue(FileUtils.Exists(CopyName));
  FileUtils.Delete(FileName);
  Assert.IsFalse(FileUtils.Exists(FileName));
end;

method FileUtilsTest.Move;
begin
  Assert.IsTrue(FileUtils.Exists(FileName));
  Assert.IsFalse(FileUtils.Exists(CopyName));
  FileUtils.Move(FileName, CopyName);
  Assert.IsFalse(FileUtils.Exists(FileName));
  Assert.IsTrue(FileUtils.Exists(CopyName));
  
  Assert.Throws(->FileUtils.Move(CopyName, CopyName));
  Assert.Throws(->FileUtils.Move(nil, CopyName));
  Assert.Throws(->FileUtils.Move(FileName, nil));
  Assert.Throws(->FileUtils.Move(CopyName+"doesnotexists", FileName));
end;

method FileUtilsTest.AppendText;
begin
  Assert.AreEqual(FileUtils.ReadText(FileName, Encoding.UTF8), "");
  FileUtils.AppendText(FileName, "Hello");
  Assert.AreEqual(FileUtils.ReadText(FileName, Encoding.UTF8), "Hello");
  FileUtils.AppendText(FileName, " World");
  Assert.AreEqual(FileUtils.ReadText(FileName, Encoding.UTF8), "Hello World");

  
  Assert.Throws(->FileUtils.AppendText(FileName, nil));
  Assert.Throws(->FileUtils.AppendText(nil, ""));
end;

method FileUtilsTest.AppendBytes;
begin
  Assert.AreEqual(FileUtils.ReadText(FileName, Encoding.UTF8), "");
  FileUtils.AppendBytes(FileName, String("Hello").ToByteArray);
  Assert.AreEqual(FileUtils.ReadText(FileName, Encoding.UTF8), "Hello");
  FileUtils.AppendBytes(FileName, String(" World").ToByteArray);
  Assert.AreEqual(FileUtils.ReadText(FileName, Encoding.UTF8), "Hello World");

  
  Assert.Throws(->FileUtils.AppendBytes(FileName, nil));
  Assert.Throws(->FileUtils.AppendBytes(nil, []));
end;

method FileUtilsTest.AppendBinary;
begin
  Assert.AreEqual(FileUtils.ReadText(FileName, Encoding.UTF8), "");
  FileUtils.AppendBinary(FileName, new Binary(String("Hello").ToByteArray));
  Assert.AreEqual(FileUtils.ReadText(FileName, Encoding.UTF8), "Hello");
  FileUtils.AppendBinary(FileName, new Binary(String(" World").ToByteArray));
  Assert.AreEqual(FileUtils.ReadText(FileName, Encoding.UTF8), "Hello World");

  
  Assert.Throws(->FileUtils.AppendBinary(FileName, nil));
  Assert.Throws(->FileUtils.AppendBinary(nil, new Binary));
end;

method FileUtilsTest.ReadText;
begin
  Assert.AreEqual(FileUtils.ReadText(FileName, Encoding.UTF8), "");
  FileUtils.WriteText(FileName, "Hello");
  Assert.AreEqual(FileUtils.ReadText(FileName, Encoding.UTF8), "Hello");

  Assert.Throws(->FileUtils.ReadText(nil, Encoding.UTF8));
  Assert.Throws(->FileUtils.ReadText(CopyName, Encoding.UTF8));
end;

method FileUtilsTest.ReadBytes;
begin
  Assert.AreEqual(length(FileUtils.ReadBytes(FileName)), 0);
  var Expected: array of Byte := [4, 8, 15, 16, 23, 42];
  FileUtils.WriteBytes(FileName, Expected);
  var Actual := FileUtils.ReadBytes(FileName);
  Assert.IsTrue(Actual <> nil);
  Assert.AreEqual(length(Actual), length(Expected));
  Assert.AreEqual(Actual, Expected);
  
  Assert.Throws(->FileUtils.ReadBytes(nil));
  Assert.Throws(->FileUtils.ReadBytes(CopyName));
end;

method FileUtilsTest.ReadBinary;
begin
  var Actual: Binary := FileUtils.ReadBinary(FileName);
  Assert.IsNotNil(Actual);
  Assert.AreEqual(Actual.Length, 0);
  var Expected: array of Byte := [4, 8, 15, 16, 23, 42];
  FileUtils.WriteBytes(FileName, Expected);
  Actual := FileUtils.ReadBinary(FileName);
  Assert.IsNotNil(Actual);
  Assert.AreEqual(Actual.Length, length(Expected));
  Assert.AreEqual(Actual.ToArray, Expected);

  Assert.Throws(->FileUtils.ReadBinary(nil));
  Assert.Throws(->FileUtils.ReadBinary(CopyName));
end;

method FileUtilsTest.WriteBytes;
begin
  Assert.AreEqual(FileUtils.ReadText(FileName, Encoding.UTF8), "");
  FileUtils.WriteBytes(FileName, String("Hello").ToByteArray);
  Assert.AreEqual(FileUtils.ReadText(FileName, Encoding.UTF8), "Hello");
  FileUtils.WriteBytes(FileName, String("World").ToByteArray);
  Assert.AreEqual(FileUtils.ReadText(FileName, Encoding.UTF8), "World");

  Assert.Throws(->FileUtils.WriteBytes(FileName, nil));
  Assert.Throws(->FileUtils.WriteBytes(nil, []));
end;

method FileUtilsTest.WriteText;
begin
  Assert.AreEqual(FileUtils.ReadText(FileName, Encoding.UTF8), "");
  FileUtils.WriteText(FileName, "Hello");
  Assert.AreEqual(FileUtils.ReadText(FileName, Encoding.UTF8), "Hello");
  FileUtils.WriteText(FileName, "World");
  Assert.AreEqual(FileUtils.ReadText(FileName, Encoding.UTF8), "World");

  Assert.Throws(->FileUtils.WriteText(FileName, nil));
  Assert.Throws(->FileUtils.WriteText(nil, ""));
end;

method FileUtilsTest.WriteBinary;
begin
  Assert.AreEqual(FileUtils.ReadText(FileName, Encoding.UTF8), "");
  FileUtils.WriteBinary(FileName, new Binary(String("Hello").ToByteArray));
  Assert.AreEqual(FileUtils.ReadText(FileName, Encoding.UTF8), "Hello");
  FileUtils.WriteBinary(FileName, new Binary(String("World").ToByteArray));
  Assert.AreEqual(FileUtils.ReadText(FileName, Encoding.UTF8), "World");

  Assert.Throws(->FileUtils.WriteBinary(FileName, nil));
  Assert.Throws(->FileUtils.WriteBinary(nil, new Binary));
end;

end.
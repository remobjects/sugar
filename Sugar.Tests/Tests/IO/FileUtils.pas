namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.IO,
  Sugar.TestFramework;

type
  FileUtilsTest = public class (Testcase)
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
  Assert.CheckBool(true, FileUtils.Exists(FileName));
  Assert.CheckBool(false, FileUtils.Exists(CopyName));
  FileUtils.Copy(FileName, CopyName);
  Assert.CheckBool(true, FileUtils.Exists(FileName));
  Assert.CheckBool(true, FileUtils.Exists(CopyName));
  
  Assert.IsException(->FileUtils.Copy(FileName, CopyName));
  Assert.IsException(->FileUtils.Copy(nil, CopyName));
  Assert.IsException(->FileUtils.Copy(FileName, nil));
  Assert.IsException(->FileUtils.Copy(FileName+"doesnotexists", CopyName));
end;

method FileUtilsTest.Create;
begin
  Assert.CheckBool(false, FileUtils.Exists(CopyName));
  FileUtils.Create(CopyName);
  Assert.CheckBool(true, FileUtils.Exists(CopyName));
  Assert.IsException(->FileUtils.Create(CopyName));
  Assert.IsException(->FileUtils.Create(nil));
end;

method FileUtilsTest.Delete;
begin
  Assert.CheckBool(false, FileUtils.Exists(CopyName));
  Assert.IsException(->FileUtils.Delete(CopyName));
  Assert.IsException(->FileUtils.Delete(nil));  
  
  Assert.CheckBool(true, FileUtils.Exists(FileName));
  FileUtils.Delete(FileName);
  Assert.CheckBool(false, FileUtils.Exists(FileName));  
end;

method FileUtilsTest.Exists;
begin
  Assert.CheckBool(true, FileUtils.Exists(FileName));
  Assert.CheckBool(false, FileUtils.Exists(CopyName));
  FileUtils.Create(CopyName);
  Assert.CheckBool(true, FileUtils.Exists(CopyName));
  FileUtils.Delete(FileName);
  Assert.CheckBool(false, FileUtils.Exists(FileName));
end;

method FileUtilsTest.Move;
begin
  Assert.CheckBool(true, FileUtils.Exists(FileName));
  Assert.CheckBool(false, FileUtils.Exists(CopyName));
  FileUtils.Move(FileName, CopyName);
  Assert.CheckBool(false, FileUtils.Exists(FileName));
  Assert.CheckBool(true, FileUtils.Exists(CopyName));
  
  Assert.IsException(->FileUtils.Move(CopyName, CopyName));
  Assert.IsException(->FileUtils.Move(nil, CopyName));
  Assert.IsException(->FileUtils.Move(FileName, nil));
  Assert.IsException(->FileUtils.Move(CopyName+"doesnotexists", FileName));
end;

method FileUtilsTest.AppendText;
begin
  Assert.CheckString("", FileUtils.ReadText(FileName, Encoding.UTF8));
  FileUtils.AppendText(FileName, "Hello");
  Assert.CheckString("Hello", FileUtils.ReadText(FileName, Encoding.UTF8));
  FileUtils.AppendText(FileName, " World");
  Assert.CheckString("Hello World", FileUtils.ReadText(FileName, Encoding.UTF8));

  Assert.IsException(->FileUtils.AppendText(CopyName, ""));
  Assert.IsException(->FileUtils.AppendText(FileName, nil));
  Assert.IsException(->FileUtils.AppendText(nil, ""));
end;

method FileUtilsTest.AppendBytes;
begin
  Assert.CheckString("", FileUtils.ReadText(FileName, Encoding.UTF8));
  FileUtils.AppendBytes(FileName, String("Hello").ToByteArray);
  Assert.CheckString("Hello", FileUtils.ReadText(FileName, Encoding.UTF8));
  FileUtils.AppendBytes(FileName, String(" World").ToByteArray);
  Assert.CheckString("Hello World", FileUtils.ReadText(FileName, Encoding.UTF8));

  Assert.IsException(->FileUtils.AppendBytes(CopyName, []));
  Assert.IsException(->FileUtils.AppendBytes(FileName, nil));
  Assert.IsException(->FileUtils.AppendBytes(nil, []));
end;

method FileUtilsTest.AppendBinary;
begin
  Assert.CheckString("", FileUtils.ReadText(FileName, Encoding.UTF8));
  FileUtils.AppendBinary(FileName, new Binary(String("Hello").ToByteArray));
  Assert.CheckString("Hello", FileUtils.ReadText(FileName, Encoding.UTF8));
  FileUtils.AppendBinary(FileName, new Binary(String(" World").ToByteArray));
  Assert.CheckString("Hello World", FileUtils.ReadText(FileName, Encoding.UTF8));

  Assert.IsException(->FileUtils.AppendBinary(CopyName, new Binary));
  Assert.IsException(->FileUtils.AppendBinary(FileName, nil));
  Assert.IsException(->FileUtils.AppendBinary(nil, new Binary));
end;

method FileUtilsTest.ReadText;
begin
  Assert.CheckString("", FileUtils.ReadText(FileName, Encoding.UTF8));
  FileUtils.WriteText(FileName, "Hello");
  Assert.CheckString("Hello", FileUtils.ReadText(FileName, Encoding.UTF8));

  Assert.IsException(->FileUtils.ReadText(nil, Encoding.UTF8));
  Assert.IsException(->FileUtils.ReadText(CopyName, Encoding.UTF8));
end;

method FileUtilsTest.ReadBytes;
begin
  Assert.CheckInt(0, length(FileUtils.ReadBytes(FileName)));  
  var Expected: array of Byte := [4, 8, 15, 16, 23, 42];
  FileUtils.WriteBytes(FileName, Expected);
  var Actual := FileUtils.ReadBytes(FileName);
  Assert.CheckBool(true, Actual <> nil);
  Assert.CheckInt(length(Expected), length(Actual));

  for i: Int32 := 0 to length(Expected) - 1 do
    Assert.CheckInt(Expected[i], Actual[i]);
  
  Assert.IsException(->FileUtils.ReadBytes(nil));
  Assert.IsException(->FileUtils.ReadBytes(CopyName));
end;

method FileUtilsTest.ReadBinary;
begin
  var Actual: Binary := FileUtils.ReadBinary(FileName);
  Assert.IsNotNull(Actual);
  Assert.CheckInt(0, Actual.Length);
  var Expected: array of Byte := [4, 8, 15, 16, 23, 42];
  FileUtils.WriteBytes(FileName, Expected);
  Actual := FileUtils.ReadBinary(FileName);
  Assert.IsNotNull(Actual);
  Assert.CheckInt(length(Expected), Actual.Length);

  var Temp := Actual.ToArray;
  for i: Int32 := 0 to length(Expected) - 1 do
    Assert.CheckInt(Expected[i], Temp[i]);

  Assert.IsException(->FileUtils.ReadBinary(nil));
  Assert.IsException(->FileUtils.ReadBinary(CopyName));
end;

method FileUtilsTest.WriteBytes;
begin
  Assert.CheckString("", FileUtils.ReadText(FileName, Encoding.UTF8));
  FileUtils.WriteBytes(FileName, String("Hello").ToByteArray);
  Assert.CheckString("Hello", FileUtils.ReadText(FileName, Encoding.UTF8));
  FileUtils.WriteBytes(FileName, String("World").ToByteArray);
  Assert.CheckString("World", FileUtils.ReadText(FileName, Encoding.UTF8));

  Assert.IsException(->FileUtils.WriteBytes(FileName, nil));
  Assert.IsException(->FileUtils.WriteBytes(nil, []));
  Assert.IsException(->FileUtils.WriteBytes(CopyName, []));
end;

method FileUtilsTest.WriteText;
begin
  Assert.CheckString("", FileUtils.ReadText(FileName, Encoding.UTF8));
  FileUtils.WriteText(FileName, "Hello");
  Assert.CheckString("Hello", FileUtils.ReadText(FileName, Encoding.UTF8));
  FileUtils.WriteText(FileName, "World");
  Assert.CheckString("World", FileUtils.ReadText(FileName, Encoding.UTF8));

  Assert.IsException(->FileUtils.WriteText(FileName, nil));
  Assert.IsException(->FileUtils.WriteText(nil, ""));
  Assert.IsException(->FileUtils.WriteText(CopyName, ""));
end;

method FileUtilsTest.WriteBinary;
begin
  Assert.CheckString("", FileUtils.ReadText(FileName, Encoding.UTF8));
  FileUtils.WriteBinary(FileName, new Binary(String("Hello").ToByteArray));
  Assert.CheckString("Hello", FileUtils.ReadText(FileName, Encoding.UTF8));
  FileUtils.WriteBinary(FileName, new Binary(String("World").ToByteArray));
  Assert.CheckString("World", FileUtils.ReadText(FileName, Encoding.UTF8));

  Assert.IsException(->FileUtils.WriteBinary(FileName, nil));
  Assert.IsException(->FileUtils.WriteBinary(nil, new Binary));
  Assert.IsException(->FileUtils.WriteBinary(CopyName, new Binary));
end;

end.
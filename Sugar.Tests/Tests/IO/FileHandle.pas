namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.IO,
  RemObjects.Elements.EUnit;

type
  FileHandleTest = public class (Test)
  private
    aFile: File;
    Data: Sugar.IO.FileHandle;
  public
    method Setup; override;
    method TearDown; override;
    
    method Close;
    method &Read;
    method &ReadOverloads;
    method &Write;
    method WriteOverloads;
    method Seek;
    method Mode;
    method Length;
    method Position;
  end;

implementation

method FileHandleTest.Setup;
begin
  aFile := Folder.UserLocal.CreateFile("sugar.testcase.txt", false);
  FileUtils.WriteText(aFile.Path, "");
  Data := new FileHandle(aFile.Path, FileOpenMode.ReadWrite);
end;

method FileHandleTest.TearDown;
begin
  Data.Close;
  aFile.Delete;
end;

method FileHandleTest.Close;
begin
  Data.Write([1, 2, 3]);
  Data.Close;
  Assert.Throws(->Data.Write([1, 2, 3]));
  Assert.Throws(->Data.Seek(0, SeekOrigin.Begin));
  var Actual := new Byte[1];
  Assert.Throws(->Data.Read(Actual, 1));
  Assert.Throws(->Data.Length);

  Data := new Sugar.IO.FileHandle(aFile.Path, FileOpenMode.ReadOnly); 
  Actual := new Byte[3];
  Assert.AreEqual(Data.Read(Actual, 0, 3), 3);

  for i: Integer := 0 to 2 do
    Assert.AreEqual(Actual[i], i + 1);
end;

method FileHandleTest.Read;
begin
  var Original: String := "Hello World";

  Assert.AreEqual(Data.Length, 0);
  Data.Write(Original.ToByteArray, 0, Original.Length);
  Assert.AreEqual(Data.Length, Original.Length);

  Data.Seek(0, SeekOrigin.Begin);
  Assert.AreEqual(Data.Position, 0);

  var Actual := new Byte[5];
  Assert.AreEqual(Data.Read(Actual, 0, 5), 5);

  Assert.AreEqual(new String(Actual, Encoding.UTF8), "Hello");
  
  var Full := new Byte[Original.Length + 5];
  Data.Position := 0;
  Assert.AreEqual(Data.Read(Full, 0, Original.Length + 5), Original.Length);

  Data.Position := 6;
  Assert.AreEqual(Data.Read(Actual, 0, 5), 5);
  Assert.AreEqual(new String(Actual, Encoding.UTF8), "World");

  Data.Position := 0;
  var Actual2 := new Byte[Original.Length];
  Assert.AreEqual(Data.Read(Actual2, 0, 5), 5);
  Assert.AreEqual(Data.Read(Actual2, 5, 1), 1);
  Assert.AreEqual(Data.Read(Actual2, 6, 5), 5);
  Assert.AreEqual(new String(Actual2, Encoding.UTF8), Original);

  Assert.Throws(->Data.Read(nil, 0, 1));
  Assert.Throws(->Data.Read(Actual, -1, 1));
  Assert.Throws(->Data.Read(Actual, 50, 1));
  Assert.Throws(->Data.Read(Actual, 0, -1));  
  Assert.Throws(->Data.Read(Actual, 0, 555));
  Assert.Throws(->Data.Read(Actual, 3, 5));
end;

method FileHandleTest.ReadOverloads;
begin
  Data.Write([0, 1, 2, 3]);
  Assert.AreEqual(Data.Length, 4);

  Data.Position := 0;
  var Actual := new Byte[2];
  Assert.AreEqual(Data.Read(Actual, 2), 2);
  Assert.AreEqual(Actual[0], 0);
  Assert.AreEqual(Actual[1], 1);

  Data.Position := 2;
  var Bin := Data.Read(5);
  Assert.IsNotNil(Bin);
  Assert.AreEqual(Bin.Length, 2);
  Assert.AreEqual(Bin.ToArray[0], 2);
  Assert.AreEqual(Bin.ToArray[1], 3);
end;

method FileHandleTest.Write;
begin
  var Original: String := "Hello World";
  Assert.AreEqual(Data.Length, 0);
  Data.Write(Original.ToByteArray, 0, Original.Length);
  Assert.AreEqual(Data.Length, Original.Length);
  
  var Actual := new Byte[Original.Length];
  Data.Position := 0;
  Assert.AreEqual(Data.Read(Actual, 0, Original.Length), Original.Length);
  Assert.AreEqual(new String(Actual, Encoding.UTF8), Original);

  Data.Length := 0;
  Data.Write(Original.ToByteArray, 6, 5);
  Data.Position := 0;
  var Actual2 := new Byte[5];
  Assert.AreEqual(Data.Read(Actual2, 0, 5), 5);
  Assert.AreEqual(new String(Actual2, Encoding.UTF8), "World");

  Assert.Throws(->Data.Write(nil, 0, 1));
  Assert.Throws(->Data.Write(Actual, -1, 1));
  Assert.Throws(->Data.Write(Actual, 0, -1));
  Assert.Throws(->Data.Write(Actual, 55, 1));
  Assert.Throws(->Data.Write(Actual, 0, 55));
  Assert.Throws(->Data.Write(Actual, 7, 9));
end;

method FileHandleTest.WriteOverloads;
begin
  Data.Write([0, 1, 2, 3], 2);
  Assert.AreEqual(Data.Length, 2);
  Data.Position := 0;
  var Actual := Data.Read(10);
  Assert.AreEqual(Data.Length, 2);
  Assert.AreEqual(Actual.ToArray[0], 0);
  Assert.AreEqual(Actual.ToArray[1], 1);

  Data.Length := 0;
  Data.Write([42, 42]);
  Assert.AreEqual(Data.Length, 2);
  Data.Position := 0;
  Actual := Data.Read(2);
  Assert.AreEqual(Data.Length, 2);
  Assert.AreEqual(Actual.ToArray[0], 42);
  Assert.AreEqual(Actual.ToArray[1], 42);

  var Bin := new Binary([1, 2, 3]);
  Data.Length := 0;
  Data.Write(Bin);
  Assert.AreEqual(Data.Length, 3);
  Data.Position := 0;
  Actual := Data.Read(3);
  Assert.AreEqual(Data.Length, 3);
  Assert.AreEqual(Actual.ToArray[0], 1);
  Assert.AreEqual(Actual.ToArray[1], 2);
  Assert.AreEqual(Actual.ToArray[2], 3);

  Bin := nil;
  Assert.Throws(->Data.Write(Bin));
end;

method FileHandleTest.Seek;
begin
  Data.Write([42, 42, 42, 42], 0, 4);
  Data.Seek(1, SeekOrigin.Begin);
  Assert.AreEqual(Data.Position, 1);
  Data.Seek(1, SeekOrigin.Current);
  Assert.AreEqual(Data.Position, 2);
  Data.Seek(-1, SeekOrigin.End);
  Assert.AreEqual(Data.Position, 3);
  Data.Seek(-1, SeekOrigin.Current);
  Assert.AreEqual(Data.Position, 2);
  Assert.AreEqual(Data.Length, 4);
  Data.Seek(2, SeekOrigin.End);
  Assert.AreEqual(Data.Position, 6);
  Assert.AreEqual(Data.Length, 4);
  Data.Write([42], 0, 1);
  Assert.AreEqual(Data.Length, 7);
  Assert.Throws(->Data.Seek(-1, SeekOrigin.Begin));
end;

method FileHandleTest.Mode;
begin
  Data.Write([42], 0, 1);
  var Actual := new Byte[1];
  Data.Read(Actual, 0, 1);
  Data.Close;

  Data := new Sugar.IO.FileHandle(aFile.Path, FileOpenMode.ReadOnly);  
  Data.Read(Actual, 0, 1);
  Assert.Throws(->Data.Write([42], 0, 1));  
  Data.Close;
end;

method FileHandleTest.Length;
begin
  Assert.AreEqual(Data.Length, 0);
  Data.Write([42], 0, 1);
  Assert.AreEqual(Data.Length, 1);

  Assert.AreEqual(Data.Position, 1);
  Data.Length := 5;
  Assert.AreEqual(Data.Length, 5);
  Assert.AreEqual(Data.Position, 1);
  Data.Length := 0;  
  Assert.AreEqual(Data.Length, 0);
  Assert.AreEqual(Data.Position, 0);

  Assert.Throws(->begin Data.Length := -1; end);
end;

method FileHandleTest.Position;
begin
  Assert.AreEqual(Data.Position, 0);
  Data.Write([42, 42, 42, 42], 0, 4);
  Assert.AreEqual(Data.Position, 4);
  Data.Position := 0;
  Assert.AreEqual(Data.Position, 0);
  var Actual := new Byte[4];
  Data.Read(Actual, 0, 4);
  Assert.AreEqual(Data.Position, 4);

  Assert.Throws(->begin Data.Position := -1; end);
end;

end.
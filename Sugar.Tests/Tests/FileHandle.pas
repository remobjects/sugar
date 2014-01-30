namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.IO,
  Sugar.TestFramework;

type
  FileHandleTest = public class (Testcase)
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
  aFile.WriteText("");
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
  Assert.IsException(->Data.Write([1, 2, 3]));
  Assert.IsException(->Data.Seek(0, SeekOrigin.Begin));
  var Actual := new Byte[1];
  Assert.IsException(->Data.Read(Actual, 1));
  Assert.IsException(->Data.Length);

  Data := new Sugar.IO.FileHandle(aFile.Path, FileOpenMode.ReadOnly); 
  Actual := new Byte[3];
  Assert.CheckInt(3, Data.Read(Actual, 0, 3));

  for i: Integer := 0 to 2 do
    Assert.CheckInt(i + 1, Actual[i]);
end;

method FileHandleTest.Read;
begin
  var Original: String := "Hello World";

  Assert.CheckInt(0, Data.Length);
  Data.Write(Original.ToByteArray, 0, Original.Length);
  Assert.CheckInt(Original.Length, Data.Length);

  Data.Seek(0, SeekOrigin.Begin);
  Assert.CheckInt(0, Data.Position);

  var Actual := new Byte[5];
  Assert.CheckInt(5, Data.Read(Actual, 0, 5));

  Assert.CheckString("Hello", new String(Actual));
  
  var Full := new Byte[Original.Length + 5];
  Data.Position := 0;
  Assert.CheckInt(Original.Length, Data.Read(Full, 0, Original.Length + 5));

  Data.Position := 6;
  Assert.CheckInt(5, Data.Read(Actual, 0, 5));
  Assert.CheckString("World", new String(Actual));

  Data.Position := 0;
  var Actual2 := new Byte[Original.Length];
  Assert.CheckInt(5, Data.Read(Actual2, 0, 5));
  Assert.CheckInt(1, Data.Read(Actual2, 5, 1));
  Assert.CheckInt(5, Data.Read(Actual2, 6, 5));
  Assert.CheckString(Original, new String(Actual2));

  Assert.IsException(->Data.Read(nil, 0, 1));
  Assert.IsException(->Data.Read(Actual, -1, 1));
  Assert.IsException(->Data.Read(Actual, 50, 1));
  Assert.IsException(->Data.Read(Actual, 0, -1));  
  Assert.IsException(->Data.Read(Actual, 0, 555));
  Assert.IsException(->Data.Read(Actual, 3, 5));
end;

method FileHandleTest.ReadOverloads;
begin
  Data.Write([0, 1, 2, 3]);
  Assert.CheckInt(4, Data.Length);

  Data.Position := 0;
  var Actual := new Byte[2];
  Assert.CheckInt(2, Data.Read(Actual, 2));
  Assert.CheckInt(0, Actual[0]);
  Assert.CheckInt(1, Actual[1]);

  Data.Position := 2;
  var Bin := Data.Read(5);
  Assert.IsNotNull(Bin);
  Assert.CheckInt(2, Bin.Length);
  Assert.CheckInt(2, Bin.ToArray[0]);
  Assert.CheckInt(3, Bin.ToArray[1]);
end;

method FileHandleTest.Write;
begin
  var Original: String := "Hello World";
  Assert.CheckInt(0, Data.Length);
  Data.Write(Original.ToByteArray, 0, Original.Length);
  Assert.CheckInt(Original.Length, Data.Length);
  
  var Actual := new Byte[Original.Length];
  Data.Position := 0;
  Assert.CheckInt(Original.Length, Data.Read(Actual, 0, Original.Length));
  Assert.CheckString(Original, new String(Actual));

  Data.Length := 0;
  Data.Write(Original.ToByteArray, 6, 5);
  Data.Position := 0;
  var Actual2 := new Byte[5];
  Assert.CheckInt(5, Data.Read(Actual2, 0, 5));
  Assert.CheckString("World", new String(Actual2));

  Assert.IsException(->Data.Write(nil, 0, 1));
  Assert.IsException(->Data.Write(Actual, -1, 1));
  Assert.IsException(->Data.Write(Actual, 0, -1));
  Assert.IsException(->Data.Write(Actual, 55, 1));
  Assert.IsException(->Data.Write(Actual, 0, 55));
  Assert.IsException(->Data.Write(Actual, 7, 9));
end;

method FileHandleTest.WriteOverloads;
begin
  Data.Write([0, 1, 2, 3], 2);
  Assert.CheckInt(2, Data.Length);
  Data.Position := 0;
  var Actual := Data.Read(10);
  Assert.CheckInt(2, Data.Length);
  Assert.CheckInt(0, Actual.ToArray[0]);
  Assert.CheckInt(1, Actual.ToArray[1]);

  Data.Length := 0;
  Data.Write([42, 42]);
  Assert.CheckInt(2, Data.Length);
  Data.Position := 0;
  Actual := Data.Read(2);
  Assert.CheckInt(2, Data.Length);
  Assert.CheckInt(42, Actual.ToArray[0]);
  Assert.CheckInt(42, Actual.ToArray[1]);

  var Bin := new Binary([1, 2, 3]);
  Data.Length := 0;
  Data.Write(Bin);
  Assert.CheckInt(3, Data.Length);
  Data.Position := 0;
  Actual := Data.Read(3);
  Assert.CheckInt(3, Data.Length);
  Assert.CheckInt(1, Actual.ToArray[0]);
  Assert.CheckInt(2, Actual.ToArray[1]);
  Assert.CheckInt(3, Actual.ToArray[2]);

  Bin := nil;
  Assert.IsException(->Data.Write(Bin));
end;

method FileHandleTest.Seek;
begin
  Data.Write([42, 42, 42, 42], 0, 4);
  Data.Seek(1, SeekOrigin.Begin);
  Assert.CheckInt(1, Data.Position);
  Data.Seek(1, SeekOrigin.Current);
  Assert.CheckInt(2, Data.Position);
  Data.Seek(-1, SeekOrigin.End);
  Assert.CheckInt(3, Data.Position);
  Data.Seek(-1, SeekOrigin.Current);
  Assert.CheckInt(2, Data.Position);
  Assert.CheckInt(4, Data.Length);
  Data.Seek(2, SeekOrigin.End);
  Assert.CheckInt(6, Data.Position);
  Assert.CheckInt(4, Data.Length);
  Data.Write([42], 0, 1);
  Assert.CheckInt(7, Data.Length);
  Assert.IsException(->Data.Seek(-1, SeekOrigin.Begin));
end;

method FileHandleTest.Mode;
begin
  Data.Write([42], 0, 1);
  var Actual := new Byte[1];
  Data.Read(Actual, 0, 1);
  Data.Close;

  Data := new Sugar.IO.FileHandle(aFile.Path, FileOpenMode.ReadOnly);  
  Data.Read(Actual, 0, 1);
  Assert.IsException(->Data.Write([42], 0, 1));  
  Data.Close;
end;

method FileHandleTest.Length;
begin
  Assert.CheckInt(0, Data.Length);
  Data.Write([42], 0, 1);
  Assert.CheckInt(1, Data.Length);

  Assert.CheckInt(1, Data.Position);
  Data.Length := 5;
  Assert.CheckInt(5, Data.Length);
  Assert.CheckInt(1, Data.Position);
  Data.Length := 0;  
  Assert.CheckInt(0, Data.Length);
  Assert.CheckInt(0, Data.Position);

  Assert.IsException(->begin Data.Length := -1; end);
end;

method FileHandleTest.Position;
begin
  Assert.CheckInt(0, Data.Position);
  Data.Write([42, 42, 42, 42], 0, 4);
  Assert.CheckInt(4, Data.Position);
  Data.Position := 0;
  Assert.CheckInt(0, Data.Position);
  var Actual := new Byte[4];
  Data.Read(Actual, 0, 4);
  Assert.CheckInt(4, Data.Position);

  Assert.IsException(->begin Data.Position := -1; end);
end;

end.
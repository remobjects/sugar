namespace RemObjects.Oxygene.Sugar.IO;

interface

uses
  RemObjects.Oxygene.Sugar;

type

  {$IF COOPER}
  FileInputStream = public class mapped to java.io.FileInputStream
  public
  {$ENDIF}
  {$IF ECHOES}
  FileInputStream = public class mapped to System.IO.FileStream
  public
    method &Read(): Integer; mapped to ReadByte(); 
    method &Read(aArray: array of Byte): Integer; mapped to &Read(aArray, 0, aArray.Length);
    method &Skip(aNumberOfBytes: Int64): Int64; 
  {$ENDIF}
  {$IF NOUGAT}
  FileInputStream = public class
  public
    method &Read(): Integer;
    method &Read(aArray: array of Byte): Integer;
    method &Skip(aNumberOfBytes: Int64): Int64; 
  {$ENDIF}
    class method StreamFromFile(aFileName: String): FileInputStream;
  end;

implementation

{$IF ECHOES}
method FileInputStream.&Skip(aNumberOfBytes: Int64): Int64;
begin
  var currPos := Mapped.Position;
  result := Mapped.Seek(aNumberOfBytes, System.IO.SeekOrigin.Current) - currPos;
end;

class method FileInputStream.StreamFromFile(aFileName: String): FileInputStream;
begin
  exit new FileInputStream(aFileName, System.IO.FileMode.Open);
end;
{$ENDIF}

{$IF NOUGAT}
method FileInputStream.&Read(): Integer;
begin
  raise new SugarNotImplementedException;
end;

method FileInputStream.&Read(aArray: array of Byte): Integer;
begin
  raise new SugarNotImplementedException;
end;

method FileInputStream.&Skip(aNumberOfBytes: Int64): Int64;
begin
  raise new SugarNotImplementedException;
end;

class method FileInputStream.StreamFromFile(aFileName: String): FileInputStream;
begin
  raise new SugarNotImplementedException;
end;
{$ENDIF}

{$IF COOPER}
class method FileInputStream.StreamFromFile(aFileName: String): FileInputStream;
begin
  exit new FileInputStream(aFileName);
end;
{$ENDIF}

end.

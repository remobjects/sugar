namespace RemObjects.Oxygene.Sugar.Cooper;

interface

{$IFNDEF COOPER}
{$ERROR This file is meant to be built for Cooper only }
{$ENDIF}

type
  ArrayUtils = public static class
  public
    method ToUnsignedArray(Value: array of SByte): array of Byte;
    method ToSignedArray(Value: array of Byte): array of SByte;
  end;

implementation

class method ArrayUtils.ToUnsignedArray(Value: array of SByte): array of Byte;
begin
  result := new Byte[Value.length];
  for i: Int32 := 0 to Value.length-1 do
    result[i] := Byte(Value[i]);
end;

class method ArrayUtils.ToSignedArray(Value: array of Byte): array of SByte;
begin
  result := new SByte[Value.length];
  for i: Int32 := 0 to Value.length-1 do
    result[i] := SByte(Value[i]);
end;

end.

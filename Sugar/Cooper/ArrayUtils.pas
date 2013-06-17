namespace RemObjects.Oxygene.Sugar.Cooper;

interface

{$IFNDEF COOPER}
{$ERROR This file is meant to be built for Cooper only }
{$ENDIF}

type
  ArrayUtils = public static class
  public
    method FromSigendArray(Value: array of SByte): array of Byte;
    method FromUnsigendArray(Value: array of Byte): array of SByte;
  end;

implementation

class method ArrayUtils.FromSigendArray(Value: array of SByte): array of Byte;
begin
  result := new Byte[Value.length];
  for i: Int32 := 0 to Value.length-1 do
    result[i] := Byte(Value[i]);
end;

class method ArrayUtils.FromUnsigendArray(Value: array of Byte): array of SByte;
begin
  result := new SByte[Value.length];
  for i: Int32 := 0 to Value.length-1 do
    result[i] := SByte(Value[i]);
end;

end.

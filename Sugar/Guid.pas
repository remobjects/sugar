namespace RemObjects.Oxygene.Sugar;

{$HIDE W0} //supress case-mismatch errors
interface

type
  {$IF COOPER}
  Guid = public class mapped to java.util.UUID
    method CompareTo(Value: Guid): Integer; mapped to compareTo(Value);
    method &Equals(Value: Guid): Boolean; mapped to &equals(Value);
    class method NewGuid: Guid; mapped to randomUUID;
    class method Parse(Value: String): Guid; mapped to fromString(Value);
    class operator Equal(GuidA, GuidB: Guid): Boolean;
    class operator NotEqual(GuidA, GuidB: Guid): Boolean;
    method ToByteArray: array of byte;
  end;
  {$ELSEIF ECHOES}
  Guid = public record mapped to System.Guid
  public
    method CompareTo(Value: Guid): Integer; mapped to CompareTo(Value);
    method &Equals(Value: Guid): Boolean; mapped to &Equals(Value);
    class method NewGuid: Guid; mapped to NewGuid;
    class method Parse(Value: String): Guid;
    class operator Equal(GuidA, GuidB: Guid): Boolean;
    class operator NotEqual(GuidA, GuidB: Guid): Boolean;
    method ToByteArray: array of byte; mapped to ToByteArray;     
  end;
  {$ELSEIF NOUGAT}
  Guid = public class
  end;
  {$ENDIF}


implementation

{$IF COOPER} 
method Guid.ToByteArray: array of byte;
begin
  var buffer := java.nio.ByteBuffer.wrap(new Byte[16]);
  buffer.putLong(mapped.MostSignificantBits);
  buffer.putLong(mapped.LeastSignificantBits);
  exit buffer.array;
end;
{$ENDIF}

{$IF ECHOES}
class method Guid.Parse(Value: String): Guid;
begin
  exit new Guid(Value);
end;
{$ENDIF}

class operator Guid.Equal(GuidA: Guid; GuidB: Guid): Boolean;
begin
  exit GuidA.Equals(GuidB);
end;

class operator Guid.NotEqual(GuidA, GuidB: Guid): Boolean;
begin
  exit not GuidA.Equals(GuidB);
end;

end.

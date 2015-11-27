namespace Sugar.Test;

interface

uses
  Sugar,
  RemObjects.Elements.EUnit;

type
  ExtensionsTest = public class (Test)
  private
    Data: CodeClass;
  public
    method Setup; override;

    method TestToString;
    method TestEquals;
    method TestHashCode;
  end;
  
  CodeClass = public class {$IF NOUGAT}(Foundation.INSCopying){$ENDIF} //required for other tests
  public
    constructor(aCode: Integer);

    //we must override Object methods for each platform
    method {$IF NOUGAT}isEqual(obj: id){$ELSE}&Equals(Obj: Object){$ENDIF}: Boolean; override;
    method {$IF NOUGAT}description: Foundation.NSString{$ELSEIF COOPER}ToString: java.lang.String{$ELSEIF ECHOES}ToString: System.String{$ENDIF}; override;
    method {$IF NOUGAT}hash: Foundation.NSUInteger{$ELSEIF COOPER}hashCode: Integer{$ELSEIF ECHOES}GetHashCode: Integer{$ENDIF}; override;
    {$IF NOUGAT}method copyWithZone(zone: ^Foundation.NSZone): not nullable id;{$ENDIF}

    property Code: Integer read write;
  end;
  
implementation

{ TestClass }
constructor CodeClass(aCode: Integer);
begin
  Code := aCode;
end;

method CodeClass.{$IF NOUGAT}isEqual(obj: id){$ELSE}&Equals(Obj: Object){$ENDIF}: Boolean;
begin
  if (obj = nil) or (not (obj is CodeClass)) then
    exit false;
  
  exit self.Code = CodeClass(obj).Code;
end;

method CodeClass.{$IF NOUGAT}hash: Foundation.NSUInteger{$ELSEIF COOPER}hashCode: Integer{$ELSEIF ECHOES}GetHashCode: Integer{$ENDIF};
begin
  exit Code;
end;

method CodeClass.{$IF NOUGAT}description: Foundation.NSString{$ELSEIF COOPER}ToString: java.lang.String{$ELSEIF ECHOES}ToString: System.String{$ENDIF};
begin
  exit Code.ToString;
end;

{$IF NOUGAT}
method CodeClass.copyWithZone(zone: ^Foundation.NSZone): not nullable id;
begin
  exit new CodeClass(Code);
end;
{$ENDIF}

{ ExtensionsTest }

method ExtensionsTest.Setup;
begin
  Data := new CodeClass(42);
end;

method ExtensionsTest.TestToString;
begin
  Assert.IsNotNil(Data.ToString);
  Assert.AreEqual(Data.ToString, "42");
end;

method ExtensionsTest.TestEquals;
begin
  Assert.IsTrue(Data.Equals(Data));
  Assert.IsTrue(Data.Equals(new CodeClass(42)));
  Assert.IsFalse(Data.Equals(new CodeClass(1)));
  Assert.IsFalse(Data.Equals(nil));
  Assert.IsFalse(Data.Equals(""));
end;

method ExtensionsTest.TestHashCode;
begin
  Assert.AreEqual(Data.GetHashCode, 42);
  Data.Code := 4;
  Assert.AreEqual(Data.GetHashCode, 4);
end;

end.
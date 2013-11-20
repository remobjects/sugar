namespace Sugar.Test;

interface

{$HIDE W0} //supress case-mismatch errors

uses
  RemObjects.Oxygene.Sugar,
  RemObjects.Oxygene.Sugar.TestFramework;

type
  ExtensionsTest = public class (Testcase)
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
    {$IF NOUGAT}method copyWithZone(zone: ^Foundation.NSZone): id;{$ENDIF}

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
method CodeClass.copyWithZone(zone: ^Foundation.NSZone): id;
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
  Assert.IsNotNull(Data.ToString);
  Assert.CheckString("42", Data.ToString);
end;

method ExtensionsTest.TestEquals;
begin
  Assert.CheckBool(true, Data.Equals(Data));
  Assert.CheckBool(true, Data.Equals(new CodeClass(42)));
  Assert.CheckBool(false, Data.Equals(new CodeClass(1)));
  Assert.CheckBool(false, Data.Equals(nil));
  Assert.CheckBool(false, Data.Equals(""));
end;

method ExtensionsTest.TestHashCode;
begin
  Assert.CheckInt(42, Data.GetHashCode);
  Data.Code := 4;
  Assert.CheckInt(4, Data.GetHashCode);
end;

end.
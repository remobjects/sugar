namespace Sugar.TestFramework;

interface

{$HIDE W0} //supress case-mismatch errors

type
  AssertAction = public block;

  Assert = public static class
  private
    method Combine(params Values: array of Object): String;    
    method Fail(Expected, Actual: Object);
    method FailIf(Condition: Boolean; Message: String);
    method FailIf(Condition: Boolean; Expected, Actual: Object; Message: String);
  public
    method Fail(Message: String);
    method CheckBool(Expected, Actual: Boolean; Message: String);
    method CheckBool(Expected, Actual: Boolean);
    method CheckInt(Expected, Actual: Integer; Message: String);
    method CheckInt(Expected, Actual: Integer);
    method CheckInt64(Expected, Actual: Int64; Message: String);
    method CheckInt64(Expected, Actual: Int64);
    method CheckDouble(Expected, Actual: Double; Message: String);
    method CheckDouble(Expected, Actual: Double);
    method CheckString(Expected, Actual: String; Message: String);
    method CheckString(Expected, Actual: String);
    method IsNull(Value: Object; Message: String);
    method IsNull(Value: Object);
    method IsNotNull(Value: Object; Message: String);
    method IsNotNull(Value: Object);
    method IsException(Action: AssertAction; Message: String);
    method IsException(Action: AssertAction);
  end;

implementation

class method Assert.CheckBool(Expected: Boolean; Actual: Boolean; Message: String);
begin
  FailIf(Expected <> Actual, Message);
end;

class method Assert.CheckBool(Expected: Boolean; Actual: Boolean);
begin
  {$IF NOUGAT}
  FailIf(Expected <> Actual, iif(Expected, "true", "false"), iif(Actual, "true", "false"), nil);
  {$ELSE}
  FailIf(Expected <> Actual, Expected, Actual, nil);
  {$ENDIF}
end;

class method Assert.CheckInt(Expected: Integer; Actual: Integer; Message: String);
begin
  FailIf(Expected <> Actual, Message);
end;

class method Assert.CheckInt(Expected: Integer; Actual: Integer);
begin
  FailIf(Expected <> Actual, Expected, Actual, nil);
end;

class method Assert.CheckInt64(Expected: Int64; Actual: Int64; Message: String);
begin
  FailIf(Expected <> Actual, Message);
end;

class method Assert.CheckInt64(Expected: Int64; Actual: Int64);
begin
  FailIf(Expected <> Actual, Expected, Actual, nil);
end;

class method Assert.CheckDouble(Expected: Double; Actual: Double; Message: String);
begin  
  var RetVal := {$IF COOPER}java.lang.Math.abs{$ELSEIF ECHOES}Math.Abs{$ELSEIF NOUGAT}rtl.fabs{$ENDIF}(Expected - Actual) < 0.000000000000001;
  FailIf(not RetVal, Message);
end;

class method Assert.CheckDouble(Expected: Double; Actual: Double);
begin
  var RetVal := {$IF COOPER}java.lang.Math.abs{$ELSEIF ECHOES}Math.Abs{$ELSEIF NOUGAT}rtl.fabs{$ENDIF}(Expected - Actual) < 0.000000000000001;
  FailIf(not RetVal, Expected, Actual, nil);
end;

class method Assert.CheckString(Expected: String; Actual: String; Message: String);
begin
  FailIf(Expected <> Actual, Message);
end;

class method Assert.CheckString(Expected: String; Actual: String);
begin
  FailIf(Expected <> Actual, Expected, Actual, nil);
end;

class method Assert.IsNotNull(Value: Object; Message: String);
begin
  FailIf(Value = nil, Message);
end;

class method Assert.IsNotNull(Value: Object);
begin
  IsNotNull(Value, "Value is null");
end;

class method Assert.IsNull(Value: Object; Message: String);
begin
  FailIf(Value <> nil, Message);
end;

class method Assert.IsNull(Value: Object);
begin
  IsNull(Value, "Value is not null")
end;

class method Assert.FailIf(Condition: Boolean; Message: String);
begin
  if Condition then
    Fail(Message);
end;

class method Assert.FailIf(Condition: Boolean; Expected: Object; Actual: Object; Message: String);
begin
  if Condition then
    if Message = nil then
      Fail(Expected, Actual)
    else
      Fail(Message);
end;

class method Assert.Combine(params Values: array of Object): String;
begin
  result := "";
  for i: Integer := 0 to length(Values) - 1 do
    result := result + iif(Values[i] = nil, "null", Values[i].{$IFDEF NOUGAT}description{$ELSE}ToString{$ENDIF});
end;

class method Assert.Fail(Message: String);
begin
  raise new SugarTestException(Message);
end;

class method Assert.Fail(Expected: Object; Actual: Object);
begin
  Fail(Combine("Expected: <", Expected, "> but was: <", Actual, ">"));
end;

class method Assert.IsException(Action: AssertAction; Message: String);
begin
  try
    Action();
  except
    exit;
  end;
  Fail(Message);
end;

class method Assert.IsException(Action: AssertAction);
begin
  IsException(Action, "Exception was expected but wasn't raised");
end;

end.

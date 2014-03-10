namespace Sugar.Reflection;

interface

type
  {$IF COOPER}
  MethodInfo = public class mapped to java.lang.reflect.Method
  {$ELSEIF ECHOES}
  MethodInfo = public class mapped to System.Reflection.MethodInfo
  {$ELSEIF NOUGAT}
  MethodInfo = public class
  {$ENDIF}
  private
    {$IF NOUGAT}
    //fClass: Sugar.Reflection.Type;
    fMethod: rtl.Method;
    method getReturnType: &Type;
    method getParameters: array of ParameterInfo;
    {$ENDIF}
    {$IF COOPER}
    method GetParameters: array of Sugar.Reflection.ParameterInfo;
    {$ENDIF}
  protected
  public
    {$IF ECHOES}
    property Name: String read mapped.Name;
    property ReturnType: Sugar.Reflection.Type read mapped.ReturnType;
    property IsStatic: Boolean read mapped.IsStatic;
    property IsPublic: Boolean read mapped.IsPublic;
    property IsPrivate: Boolean read mapped.IsPrivate;
    property IsFinal: Boolean read mapped.IsFinal;
    property IsAbstract: Boolean read mapped.IsAbstract;
    property Parameters: array of Sugar.Reflection.ParameterInfo read mapped.GetParameters();
    {$ENDIF}
    {$IF COOPER}
    property Name: String read mapped.getName();
    property ReturnType: Sugar.Reflection.Type read mapped.getReturnType();
    property IsStatic: Boolean read java.lang.reflect.Modifier.isStatic(mapped.getModifiers);
    property IsPublic: Boolean read java.lang.reflect.Modifier.isPublic(mapped.getModifiers);
    property IsPrivate: Boolean read java.lang.reflect.Modifier.isPrivate(mapped.getModifiers);
    property IsFinal: Boolean read java.lang.reflect.Modifier.isFinal(mapped.getModifiers);
    property IsAbstract: Boolean read java.lang.reflect.Modifier.isAbstract(mapped.getModifiers);
    property Parameters: array of Sugar.Reflection.ParameterInfo read GetParameters;
    {$ENDIF}
    {$IF NOUGAT}
    method initWithClass(aClass: Sugar.Reflection.Type) &method(aMethod: rtl.Method): instancetype;
    property Name: String read NSStringFromSelector(&Selector);
    property &Selector: SEL read method_getName(fMethod);
    property ReturnType: Sugar.Reflection.Type read getReturnType;
    property IsStatic: Boolean read false; // todo?
    property IsPublic: Boolean read true;
    property IsPrivate: Boolean read false;
    property IsFinal: Boolean read false;
    property IsAbstract: Boolean read false;
    property Parameters: array of Sugar.Reflection.ParameterInfo read getParameters;
    {$ENDIF}
  end;

implementation

{$IF NOUGAT}
method MethodInfo.initWithClass(aClass: Sugar.Reflection.Type) &method(aMethod: rtl.Method): instancetype;
begin
  self := inherited init;
  if assigned(self) then begin
    //fClass := aClass;
    fMethod := aMethod;
  end;
  result := self;
end;

const MAX_CHAR = 256;

method MethodInfo.getReturnType: &Type;
begin
  var lDestination: array[0..MAX_CHAR] of AnsiChar;
  method_getReturnType(fMethod, lDestination, MAX_CHAR);
end;

method MethodInfo.getParameters: array of ParameterInfo;
begin
  var lCount := method_getNumberOfArguments(fMethod);
  for i: Int32 := 0 to lCount-1 do begin
    var lDestination: array[0..MAX_CHAR] of AnsiChar;
    method_getArgumentType(fMethod, i, lDestination, MAX_CHAR);
  end;

end;
{$ENDIF}

{$IF COOPER}
method MethodInfo.GetParameters: array of Sugar.Reflection.ParameterInfo;
begin
  var parameterTypes := mapped.ParameterTypes;
  var parameterAttributes := mapped.ParameterAnnotations;
  result := new Sugar.Reflection.ParameterInfo[parameterTypes.length];
  for i: Integer := 0 to parameterTypes.length - 1 do
  begin
    result[i] := new Sugar.Reflection.ParameterInfo(Name := 'param' + i.toString(), 
                                                    ParameterType := parameterTypes[i], 
                                                    Position := i, 
                                                    CustomAttributes := parameterAttributes[i]);
  end;
end;
{$ENDIF}
end.

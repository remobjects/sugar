namespace Sugar.Reflection;

interface

type

  MethodInfo = public class mapped to {$IF COOPER}java.lang.reflect.Method{$ELSEIF ECHOES}System.Reflection.MethodInfo{$ENDIF}
  private
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
    method GetParameters: array of Sugar.Reflection.ParameterInfo; mapped to GetParameters();
    {$ENDIF}
    {$IF COOPER}
    property Name: String read mapped.getName();
    property ReturnType: Sugar.Reflection.Type read mapped.getReturnType();
    property IsStatic: Boolean read java.lang.reflect.Modifier.isStatic(mapped.getModifiers);
    property IsPublic: Boolean read java.lang.reflect.Modifier.isPublic(mapped.getModifiers);
    property IsPrivate: Boolean read java.lang.reflect.Modifier.isPrivate(mapped.getModifiers);
    property IsFinal: Boolean read java.lang.reflect.Modifier.isFinal(mapped.getModifiers);
    property IsAbstract: Boolean read java.lang.reflect.Modifier.isAbstract(mapped.getModifiers);
    method GetParameters: array of Sugar.Reflection.ParameterInfo;
    {$ENDIF}
  end;

implementation

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

namespace Sugar.Reflection;

interface

type

  &Type = public class mapped to {$IF COOPER}java.lang.Class{$ELSEIF ECHOES}System.Type{$ELSEIF NOUGAT}&Class{$ENDIF}
  private
  protected
  public
    {$IF ECHOES}
    method GetInterfaces: array of Sugar.Reflection.Type; mapped to GetInterfaces();
    method GetMethods: array of Sugar.Reflection.MethodInfo; mapped to GetMethods();
    property BaseType: Sugar.Reflection.Type read mapped.BaseType; 
    property IsInterface: Boolean read mapped.IsInterface;
    property IsArray: Boolean read mapped.IsArray;
    property IsEnum: Boolean read mapped.IsEnum;
    property IsValueType: Boolean read mapped.IsValueType;
    {$ENDIF}
    {$IF COOPER}
    method GetInterfaces: array of Sugar.Reflection.Type; mapped to getInterfaces();
    method GetMethods: array of Sugar.Reflection.MethodInfo; mapped to getMethods();
    property BaseType: Sugar.Reflection.Type read mapped.getSuperclass(); 
    property IsInterface: Boolean read mapped.isInterface();
    property IsArray: Boolean read mapped.isArray();
    property IsEnum: Boolean read mapped.isEnum();
    property IsValueType: Boolean read mapped.isPrimitive();
    {$ENDIF}
  end;

implementation

end.

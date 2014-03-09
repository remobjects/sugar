namespace Sugar.Reflection;

interface

type

  MethodInfo = public class mapped to {$IF COOPER}java.lang.reflect.Method{$ELSEIF ECHOES}System.Reflection.MethodInfo{$ELSEIF NOUGAT}TODO{$ENDIF}
  private
  protected
  public
    {$IF ECHOES}
    property Name: String read mapped.Name;
    property ReturnType: Sugar.Reflection.Type read mapped.ReflectedType;
    property IsStatic: Boolean read mapped.IsStatic;
    property IsPublic: Boolean read mapped.IsPublic;
    {$ENDIF}
    {$IF COOPER}
    property Name: String read mapped.getName();
    property ReturnType: Sugar.Reflection.Type read mapped.getReturnType();
    property IsStatic: Boolean read java.lang.reflect.Modifier.isStatic(mapped.getModifiers);
    property IsPublic: Boolean read java.lang.reflect.Modifier.isPublic(mapped.getModifiers);
    {$ENDIF}
  end;

implementation

end.

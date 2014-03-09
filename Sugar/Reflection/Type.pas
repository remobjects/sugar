namespace Sugar.Reflection;

interface

type

  &Type = public class mapped to {$IF COOPER}java.lang.Class{$ELSEIF ECHOES}System.Type{$ELSEIF NOUGAT}&Class{$ENDIF}
  private
  protected
  public
    {$IF ECHOES}
    method GetInterfaces: array of Sugar.Reflection.Type; mapped to GetInterfaces();
    {$ENDIF}
    {$IF COOPER}
    method GetInterfaces: array of Sugar.Reflection.Type; mapped to getInterfaces();
    {$ENDIF}
  end;

implementation

end.

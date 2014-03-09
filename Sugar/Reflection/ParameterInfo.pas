namespace Sugar.Reflection;

interface

type

  ParameterInfo = public class{$IF ECHOES} mapped to System.Reflection.ParameterInfo{$ENDIF}
  private
  protected
  public
    {$IF ECHOES}
    property Name: String read mapped.Name;
    property Position: Integer read mapped.Position;
    property ParameterType: Sugar.Reflection.Type read mapped.ParameterType;
    property CustomAttributes: array of Object read mapped.GetCustomAttributes(false);
    {$ENDIF}
    {$IF COOPER}
    property Name: String;
    property Position: Integer;
    property ParameterType: Sugar.Reflection.Type;
    property CustomAttributes: array of Object;
    {$ENDIF}
  end;

implementation


end.

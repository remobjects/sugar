namespace Sugar.Reflection;

interface

type
  {$IF ECHOES}
  ParameterInfo = public class mapped to System.Reflection.ParameterInfo
  {$ENDIF}
  {$IF COOPER}
  ParameterInfo = public class
  {$ENDIF}
  {$IF NOUGAT}
  ParameterInfo = public class
  {$ENDIF}
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
    {$IF NOUGAT}
    method initWithIndex(aPosition: Int32) &type(aType: Sugar.Reflection.Type): instancetype;
    property Name: String read nil;
    property Position: Integer; readonly;
    property ParameterType: Sugar.Reflection.Type; readonly;
    property CustomAttributes: array of Object read [];
    {$ENDIF}
  end;

implementation

{$IF NOUGAT}
method ParameterInfo.initWithIndex(aPosition: Integer) &type(aType: &Type): instancetype;
begin
  self := inherited init;
  if assigned(self) then begin
    Position := aPosition;
    &ParameterType := aType;
  end;
  result := self;
end;
{$ENDIF}

end.

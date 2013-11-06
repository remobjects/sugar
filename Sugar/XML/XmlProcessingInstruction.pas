namespace RemObjects.Oxygene.Sugar.Xml;

{$HIDE W0} //supress case-mismatch errors

interface

uses
  {$IF COOPER}
  org.w3c.dom,
  {$ELSEIF ECHOES}
  System.Xml.Linq,
  {$ELSEIF NOUGAT}
  Foundation,
  {$ENDIF}
  RemObjects.Oxygene.Sugar;

type
{$IF COOPER OR ECHOES}
  XmlProcessingInstruction = public class (XmlNode)
  private
    property ProcessingInstruction: {$IF COOPER}ProcessingInstruction{$ELSEIF ECHOES}XProcessingInstruction{$ENDIF} 
                                    read Node as {$IF COOPER}ProcessingInstruction{$ELSEIF ECHOES}XProcessingInstruction{$ENDIF};
    {$IF COOPER}method SetData(aValue: String);{$ENDIF}
  public
    {$IF ECHOES}
    property Name: String read "#processinginstruction"; override;
    property Value: String read ProcessingInstruction.Data write ProcessingInstruction.Data; override;
    {$ENDIF}
    property Data: String read ProcessingInstruction.Data write {$IF COOPER}SetData{$ELSE}ProcessingInstruction.Data{$ENDIF};
    property Target: String read ProcessingInstruction.Target;
  end;
{$ELSEIF NOUGAT}
  XmlProcessingInstruction = public class (XmlNode)
  {$IF OSX}
  private
    method GetData: String;
    method SetData(aValue: String);
  {$ENDIF}
  public
    {$IF IOS}
    property Data: String read Value write Value;
    property Target: String read Name;
    {$ELSEIF OSX}
    property Data: String read GetData write SetData;
    property Target: String read Node.Name;
    {$ENDIF}
  end;
{$ENDIF}
implementation

{$IF NOUGAT}
{$IF OSX}
method XmlProcessingInstruction.GetData: String;
begin
  exit Node.stringValue;
end;

method XmlProcessingInstruction.SetData(aValue: String);
begin
  Node.setStringValue(aValue);
end;
{$ENDIF}
{$ENDIF}

{$IF COOPER}
method XmlProcessingInstruction.SetData(aValue: String);
begin
  SugarArgumentNullException.RaiseIfNil(aValue, "Value");
  ProcessingInstruction.Data := aValue;
end;
{$ENDIF}

end.

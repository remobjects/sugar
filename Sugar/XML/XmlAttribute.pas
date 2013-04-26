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
  XmlAttribute = public class (XmlNode)
  {$IF NOT NOUGAT}
  private
    property &Attribute: {$IF COOPER}Attr{$ELSEIF ECHOES}XAttribute{$ENDIF} 
                         read Node as {$IF COOPER}Attr{$ELSEIF ECHOES}XAttribute{$ENDIF};
  {$ENDIF}
  public
    {$IF ECHOES}
    property Name: String read Attribute.Name.ToString; override;
    property Value: String read Attribute.Value write Attribute.Value; override;
    property LocalName: String read Attribute.Name.LocalName; override;
    property InnerText: String read Attribute.Value write Attribute.Value; override; 
    {$ENDIF}

    {$IF ECHOES}
    property OwnerElement: XmlElement read iif(Attribute.Parent = nil, nil, new XmlElement(Attribute.Parent));
    {$ELSEIF NOUGAT}
    property OwnerElement: XmlElement read iif(Node.parent = nil, nil, new XmlElement(Node.parent));
    {$ELSEIF COOPER}
    property OwnerElement: XmlElement read iif(Attribute.OwnerElement = nil, nil, new XmlElement(Attribute.OwnerElement));
    {$ENDIF}
    
    property Specified: Boolean read {$IF NOUGAT OR ECHOES}true{$ELSE}Attribute.Specified{$ENDIF};
  end;
implementation

end.

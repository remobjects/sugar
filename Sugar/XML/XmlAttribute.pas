namespace Sugar.Xml;

interface

uses
  {$IF COOPER}
  org.w3c.dom,
  {$ELSEIF ECHOES}
  System.Xml.Linq,
  {$ELSEIF TOFFEE}
  Foundation,
  {$ENDIF}
  Sugar;

type
  XmlAttribute = public class (XmlNode)
  {$IF NOT TOFFEE}
  private
    property &Attribute: {$IF COOPER}Attr{$ELSEIF ECHOES}XAttribute{$ENDIF} 
                         read Node as {$IF COOPER}Attr{$ELSEIF ECHOES}XAttribute{$ENDIF};
  {$ENDIF}
  public
    property NodeType: XmlNodeType read XmlNodeType.Attribute; override;
    {$IF ECHOES}
    property Name: String read Attribute.Name.ToString; override;
    property Value: String read Attribute.Value write Attribute.Value; override;
    property LocalName: String read Attribute.Name.LocalName; override;
    {$ENDIF}

    {$IF ECHOES}
    property OwnerElement: XmlElement read iif(Attribute.Parent = nil, nil, new XmlElement(Attribute.Parent));
    {$ELSEIF TOFFEE}
    property OwnerElement: XmlElement read iif(Node^.parent = nil, nil, new XmlElement(^libxml.__struct__xmlNode(Node^.parent), OwnerDocument));
    {$ELSEIF COOPER}
    property OwnerElement: XmlElement read iif(Attribute.OwnerElement = nil, nil, new XmlElement(Attribute.OwnerElement));
    {$ENDIF}    
  end;
implementation

end.

namespace RemObjects.Oxygene.Sugar.Xml;

{$HIDE W0} //supress case-mismatch errors

interface

uses
  {$IF COOPER}
  org.w3c.dom,
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  System.Xml.Linq,
  {$ELSEIF NOUGAT}
  Foundation,
  {$ENDIF}
  RemObjects.Oxygene.Sugar;

type
  XmlAttribute = public class (XmlNode)
  {$IF NOT NOUGAT}
  private
    property &Attribute: {$IF COOPER}Attr{$ELSEIF WINDOWS_PHONE OR NETFX_CORE}XAttribute{$ELSE}System.Xml.XmlAttribute{$ENDIF} 
                         read Node as {$IF COOPER}Attr{$ELSEIF WINDOWS_PHONE OR NETFX_CORE}XAttribute{$ELSE}System.Xml.XmlAttribute{$ENDIF};
  {$ENDIF}
  public
    {$IF WINDOWS_PHONE OR NETFX_CORE}
    property Name: String read Attribute.Name.ToString; override;
    property Value: String read Attribute.Value write Attribute.Value; override;
    property LocalName: String read Attribute.Name.LocalName; override;
    property InnerText: String read Attribute.Value write Attribute.Value; override; 
    {$ENDIF}

    {$IF WINDOWS_PHONE OR NETFX_CORE}
    property OwnerElement: XmlElement read iif(Attribute.Parent = nil, nil, new XmlElement(Attribute.Parent));
    {$ELSEIF NOUGAT}
    property OwnerElement: XmlElement read iif(Node.parent = nil, nil, new XmlElement(Node.parent));
    {$ELSEIF COOPER OR ECHOES}
    property OwnerElement: XmlElement read iif(Attribute.OwnerElement = nil, nil, new XmlElement(Attribute.OwnerElement));
    {$ENDIF}
    
    property Specified: Boolean read {$IF NOUGAT OR WINDOWS_PHONE OR NETFX_CORE}true{$ELSE}Attribute.Specified{$ENDIF};
  end;
implementation

end.

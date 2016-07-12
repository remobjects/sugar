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
  XmlDocumentType = public class (XmlNode)
  private
    property DocumentType: {$IF COOPER}DocumentType{$ELSEIF ECHOES}XDocumentType{$ELSEIF TOFFEE}^libxml.__struct__xmlDtd{$ENDIF}
                            read {$IF TOFFEE}^libxml.__struct__xmlDtd(Node){$ELSE}Node as {$IF COOPER}DocumentType{$ELSEIF ECHOES}XDocumentType{$ENDIF}{$ENDIF};
    method SetValue(aValue: String); empty;
  public
    {$IF ECHOES}
    property Name: String read DocumentType.Name.ToString; override;
    property LocalName: String read DocumentType.Name; override;    
    {$ENDIF}    
    property PublicId: String read {$IF TOFFEE}XmlChar.ToString(DocumentType^.ExternalID){$ELSE}iif(DocumentType.PublicId = nil, "", DocumentType.PublicId){$ENDIF};
    property SystemId: String read {$IF TOFFEE}XmlChar.ToString(DocumentType^.SystemID){$ELSE}iif(DocumentType.SystemId = nil, "", DocumentType.SystemId){$ENDIF};
    property NodeType: XmlNodeType read XmlNodeType.DocumentType; override;
    property Value: String read nil write SetValue; override;

    {$IF TOFFEE}
    property FirstChild: XmlNode read nil; override;
    property LastChild: XmlNode read nil; override;    
    property ChildCount: Integer read 0; override;
    property ChildNodes: array of XmlNode read []; override;    
    {$ENDIF}
  end;
implementation

end.

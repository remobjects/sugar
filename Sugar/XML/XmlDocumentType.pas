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
  XmlDocumentType = public class (XmlNode)
  private
    property DocumentType: {$IF COOPER}DocumentType{$ELSEIF ECHOES}XDocumentType{$ELSEIF NOUGAT}^libxml.__struct__xmlDtd{$ENDIF}
                            read {$IF NOUGAT}^libxml.__struct__xmlDtd(Node){$ELSE}Node as {$IF COOPER}DocumentType{$ELSEIF ECHOES}XDocumentType{$ENDIF}{$ENDIF};
    {$IF NOUGAT}method GetInternalSubset: String;{$ENDIF}
    method SetValue(aValue: String); empty;
  public
    {$IF ECHOES}
    property Name: String read DocumentType.Name.ToString; override;
    property LocalName: String read DocumentType.Name; override;    
    {$ENDIF}
    property InternalSubset: String read {$IF NOUGAT}GetInternalSubset{$ELSE}iif(DocumentType.InternalSubset = nil, "", DocumentType.InternalSubset){$ENDIF};
    property PublicId: String read {$IF NOUGAT}XmlChar.ToString(DocumentType^.ExternalID){$ELSE}iif(DocumentType.PublicId = nil, "", DocumentType.PublicId){$ENDIF};
    property SystemId: String read {$IF NOUGAT}XmlChar.ToString(DocumentType^.SystemID){$ELSE}iif(DocumentType.SystemId = nil, "", DocumentType.SystemId){$ENDIF};
    property NodeType: XmlNodeType read XmlNodeType.DocumentType; override;

    property Value: String read InternalSubset write SetValue; override;

    {$IF NOUGAT}
    property FirstChild: XmlNode read nil; override;
    property LastChild: XmlNode read nil; override;    
    property ChildCount: Integer read 0; override;
    property ChildNodes: array of XmlNode read []; override;    
    {$ENDIF}
  end;
implementation

{$IF NOUGAT}
method XmlDocumentType.GetInternalSubset: String;
begin
  result := self.description;
  
  if result = nil then
    exit "";

  var RegEx: NSRegularExpression := NSRegularExpression.regularExpressionWithPattern("<!DOCTYPE\s+[^\<]+|]>") options(NSRegularExpressionOptions.NSRegularExpressionCaseInsensitive) error(nil);
  exit RegEx.stringByReplacingMatchesInString(result) options(0) range(NSMakeRange(0, result.Length)) withTemplate("");
end;
{$ENDIF}

end.

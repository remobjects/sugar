namespace RemObjects.Oxygene.Sugar.Xml;

{$HIDE W0} //supress case-mismatch errors

interface

uses
  {$IF COOPER}
  org.w3c.dom,
  {$ELSEIF WINDOWS_PHONE}
  System.Xml.Linq,
  {$ELSEIF NOUGAT}
  Foundation,
  {$ENDIF}
  RemObjects.Oxygene.Sugar;

type
  XmlCharacterData = public class (XmlNode)
  private
    {$IF NOUGAT}
    method GetData: String;
    method SetData(aValue: String);
    method GetLength: Integer;
    {$ELSE}
    property CharacterData: {$IF COOPER}CharacterData{$ELSEIF WINDOWS_PHONE}XText{$ELSE}System.Xml.XmlCharacterData{$ENDIF} 
                            read Node as {$IF COOPER}CharacterData{$ELSEIF WINDOWS_PHONE}XText{$ELSE}System.Xml.XmlCharacterData{$ENDIF};
    {$ENDIF}
  public
    {$IF WINDOWS_PHONE}
    property Data: String read CharacterData.Value write CharacterData.Value; virtual;
    property Length: Integer read CharacterData.Value.Length; virtual;
    property Value: String read CharacterData.Value write CharacterData.Value; override;
    property InnerText: String read CharacterData.Value write CharacterData.Value; override; 
    {$ELSEIF COOPER OR ECHOES}
    property Data: String read CharacterData.Data write CharacterData.Data;
    property Length: Integer read CharacterData.Length;
    {$ELSEIF NOUGAT}
    property Data: String read GetData write SetData;
    property Length: Integer read GetLength;
    {$ENDIF}

    method AppendData(aValue: String);
    method DeleteData(Offset, Count: Integer);
    method InsertData(Offset: Integer; aValue: String);
    method ReplaceData(Offset, Count: Integer; WithValue: String);
    method Substring(Offset, Count: Integer): String;
  end;

  XmlCDataSection = public class (XmlCharacterData)
  {$IF WINDOWS_PHONE}
  public
    property Name: String read "#CDATA"; override;
  {$ENDIF}
  end;

  XmlComment = public class (XmlCharacterData)
  {$IF WINDOWS_PHONE}
  private
    property Comment: XComment read Node as XComment;
  public    
    property Data: String read Comment.Value write Comment.Value; override;
    property Length: Integer read Comment.Value.Length; override;
    property Value: String read Comment.Value write Comment.Value; override;
    property Name: String read "#comment"; override;
    property InnerText: String read Comment.Value write Comment.Value; override;
  {$ENDIF}
  end;

  XmlText = public class (XmlCharacterData)
  {$IF WINDOWS_PHONE}
  public
    property Name: String read "#text"; override;
  {$ENDIF}
  end;
implementation

{$IF NOUGAT}
method XmlCharacterData.GetData: String;
begin
  exit Node.stringValue;
end;

method XmlCharacterData.SetData(aValue: String);
begin
  Node.setStringValue(aValue);
end;

method XmlCharacterData.GetLength: Integer;
begin
  exit Node.stringValue.length;
end;
{$ENDIF}

method XmlCharacterData.AppendData(aValue: String);
begin
  {$IF WINDOWS_PHONE}
  Value := Value + aValue;
  {$ELSEIF COOPER OR ECHOES} 
  CharacterData.AppendData(aValue);
  {$ELSEIF NOUGAT}
  var lData: NSMutableString := NSMutableString.stringWithString(Node.stringValue);
  lData.appendString(aValue);
  Node.setStringValue(lData);
  {$ENDIF}
end;

method XmlCharacterData.DeleteData(Offset: Integer; Count: Integer);
begin
  {$IF WINDOWS_PHONE}
  Value := System.String(Value).Remove(Offset, Count);
  {$ELSEIF COOPER OR ECHOES} 
  CharacterData.DeleteData(Offset, Count);
  {$ELSEIF NOUGAT}
  var lData: NSMutableString := NSMutableString.stringWithString(Node.stringValue);
  lData.deleteCharactersInRange(NSMakeRange(Offset, Count));
  Node.setStringValue(lData);
  {$ENDIF}
end;

method XmlCharacterData.InsertData(Offset: Integer; aValue: String);
begin
  {$IF WINDOWS_PHONE}
  Value := System.String(Value).Insert(Offset, aValue);
  {$ELSEIF COOPER OR ECHOES} 
  CharacterData.InsertData(Offset, aValue);
  {$ELSEIF NOUGAT}
  var lData: NSMutableString := NSMutableString.stringWithString(Node.stringValue);
  lData.insertString(aValue) atIndex(Offset);
  Node.setStringValue(lData);
  {$ENDIF}
end;

method XmlCharacterData.ReplaceData(Offset: Integer; Count: Integer; WithValue: String);
begin
  {$IF WINDOWS_PHONE}
  DeleteData(Offset, Count);
  InsertData(Offset, WithValue);
  {$ELSEIF COOPER OR ECHOES} 
  CharacterData.ReplaceData(Offset, Count, WithValue);
  {$ELSEIF NOUGAT}
  var lData: NSMutableString := NSMutableString.stringWithString(Node.stringValue);
  lData.replaceCharactersInRange(NSMakeRange(Offset, Count)) withString(WithValue);
  Node.setStringValue(lData);
  {$ENDIF}
end;

method XmlCharacterData.Substring(Offset: Integer; Count: Integer): String;
begin
  {$IF WINDOWS_PHONE}
  exit Value.Substring(Offset, Count);
  {$ELSEIF COOPER} 
  exit CharacterData.substringData(Offset, Count);
  {$ELSEIF ECHOES}
  exit CharacterData.Substring(Offset, Count);
  {$ELSEIF NOUGAT}
  exit Node.stringValue.substringWithRange(NSMakeRange(Offset, Count));
  {$ENDIF}
end;

end.

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
  XmlCharacterData = public class (XmlNode)
  private
    {$IF NOUGAT}
    method GetData: String;
    method SetData(aValue: String);
    method GetLength: Integer;
    {$ELSE}
    property CharacterData: {$IF COOPER}CharacterData{$ELSEIF ECHOES}XText{$ENDIF} 
                            read Node as {$IF COOPER}CharacterData{$ELSEIF ECHOES}XText{$ENDIF};
    {$ENDIF}
    {$IF COOPER}method SetData(aValue: String);{$ENDIF}
  public
    {$IF ECHOES}
    property Data: String read CharacterData.Value write CharacterData.Value; virtual;
    property Length: Integer read CharacterData.Value.Length; virtual;
    property Value: String read CharacterData.Value write CharacterData.Value; override;
    {$ELSEIF COOPER}
    property Data: String read CharacterData.Data write SetData;
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
  public
    property Name: String read "#CDATA"; override;
    property NodeType: XmlNodeType read XmlNodeType.CDATA; override;
    {$IF NOUGAT}property LocalName: String read "#CDATA"; override;{$ENDIF}
  end;

  XmlComment = public class (XmlCharacterData)
  {$IF ECHOES}
  private
    property Comment: XComment read Node as XComment;
  public    
    property Data: String read Comment.Value write Comment.Value; override;
    property Length: Integer read Comment.Value.Length; override;
    property Value: String read Comment.Value write Comment.Value; override;    
  {$ENDIF}
  public
    property Name: String read "#comment"; override;
    property NodeType: XmlNodeType read XmlNodeType.Comment; override;
    {$IF NOUGAT}property LocalName: String read "#comment"; override;{$ENDIF}
  end;

  XmlText = public class (XmlCharacterData)
  public
    property Name: String read "#text"; override;
    property NodeType: XmlNodeType read XmlNodeType.Text; override;
    {$IF NOUGAT}property LocalName: String read "#text"; override;{$ENDIF}
  end;

implementation

{$IF NOUGAT}
method XmlCharacterData.GetData: String;
begin
  exit Value;
end;

method XmlCharacterData.SetData(aValue: String);
begin
  SugarArgumentNullException.RaiseIfNil(aValue, "Value");
  Value := aValue;
end;

method XmlCharacterData.GetLength: Integer;
begin
  exit Value.Length;
end;
{$ENDIF}

{$IF COOPER}
method XmlCharacterData.SetData(aValue: String);
begin
  SugarArgumentNullException.RaiseIfNil(aValue, "Value");
  CharacterData.Data := aValue;
end;
{$ENDIF}

method XmlCharacterData.AppendData(aValue: String);
begin
  if aValue = nil then
    exit;

  {$IF ECHOES}
  Value := Value + aValue;
  {$ELSEIF COOPER} 
  CharacterData.AppendData(aValue);
  {$ELSEIF NOUGAT}
  var lData: NSMutableString := NSMutableString.stringWithString(Data);
  lData.appendString(aValue);
  Value := lData;
  {$ENDIF}
end;

method XmlCharacterData.DeleteData(Offset: Integer; Count: Integer);
begin
  {$IF ECHOES}
  Value := System.String(Value).Remove(Offset, Count);
  {$ELSEIF COOPER} 
  if Offset + Count > CharacterData.Length then
    raise new SugarArgumentOutOfRangeException(String.Format(ErrorMessage.OUT_OF_RANGE_ERROR, Offset, Count, CharacterData.Length));

  CharacterData.DeleteData(Offset, Count);
  {$ELSEIF NOUGAT}
  var lData: NSMutableString := NSMutableString.stringWithString(Data);
  lData.deleteCharactersInRange(NSMakeRange(Offset, Count));
  Value := lData;
  {$ENDIF}
end;

method XmlCharacterData.InsertData(Offset: Integer; aValue: String);
begin
  {$IF ECHOES}
  Value := System.String(Value).Insert(Offset, aValue);
  {$ELSEIF COOPER} 
  CharacterData.InsertData(Offset, aValue);
  {$ELSEIF NOUGAT}
  var lData: NSMutableString := NSMutableString.stringWithString(Data);
  lData.insertString(aValue) atIndex(Offset);
  Value := lData;
  {$ENDIF}
end;

method XmlCharacterData.ReplaceData(Offset: Integer; Count: Integer; WithValue: String);
begin
  {$IF ECHOES}
  DeleteData(Offset, Count);
  InsertData(Offset, WithValue);
  {$ELSEIF COOPER} 
  if Offset + Count > CharacterData.Length then
    raise new SugarArgumentOutOfRangeException(String.Format(ErrorMessage.OUT_OF_RANGE_ERROR, Offset, Count, CharacterData.Length));

  CharacterData.ReplaceData(Offset, Count, WithValue);
  {$ELSEIF NOUGAT}
  var lData: NSMutableString := NSMutableString.stringWithString(Data);
  lData.replaceCharactersInRange(NSMakeRange(Offset, Count)) withString(WithValue);
  Value := lData;
  {$ENDIF}
end;

method XmlCharacterData.Substring(Offset: Integer; Count: Integer): String;
begin
  {$IF ECHOES}
  exit Value.Substring(Offset, Count);
  {$ELSEIF COOPER} 
  if Offset + Count > CharacterData.Length then
    raise new SugarArgumentOutOfRangeException(String.Format(ErrorMessage.OUT_OF_RANGE_ERROR, Offset, Count, CharacterData.Length));

  exit CharacterData.substringData(Offset, Count);
  {$ELSEIF NOUGAT}
  if (Offset < 0) or (Count < 0) then
    raise new SugarArgumentException(ErrorMessage.NEGATIVE_VALUE_ERROR, "Offset and Count");

  if Offset + Count > self.Length then
    raise new SugarArgumentOutOfRangeException(String.Format(ErrorMessage.OUT_OF_RANGE_ERROR, Offset, Count, self.Length));

  exit NSString(Data).substringWithRange(NSMakeRange(Offset, Count));
  {$ENDIF}
end;

end.

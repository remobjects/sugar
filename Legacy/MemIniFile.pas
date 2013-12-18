namespace RemObjects.Oxygene.Legacy;

interface
{$HIDE W0} //supress case-mismatch errors

uses
  RemObjects.Sugar,
  RemObjects.Sugar.IO,
  RemObjects.Sugar.Collections;   

type
  MemIniFile = public class
  private
    fList: Dictionary<String,Dictionary<String,String>>;
    fFile : File;
    method LoadValues;
    method int_ReadSectionValues(const Section: String; List: List<String>); 
    method Int_AddSection(const Section: String):Dictionary<String,String>;
    method Int_AddValue(const Section: Dictionary<String,String>; Ident, Value: String);    
  protected
  public
    constructor (const aFile: File);
    method Clear;
    method DeleteKey(const Section, Ident: String); 
    method EraseSection(const Section: String); 
    method GetStrings(List: List<String>);
    method ReadSection(const Section: String; List: List<String>); 
    method ReadSections(List: List<String>); 
    method ReadSectionValues(const Section: String; List: List<String>); 
    method ReadString(const Section, Ident, &Default: String): String; 
    method SetStrings(List: List<String>);
    method UpdateFile; 
    method WriteString(const Section, Ident, Value: String); 
    method SectionExists(const Section: String): Boolean;    
    method ValueExists(const Section, Ident: String): Boolean; 
    method Revert;
    property &File: File read fFile;
  end;

implementation

method String_IndexOf(Source: String; aChar : Char): Int32;
begin
  exit String_IndexOf(Source, aChar+'');
end;

method String_IndexOf(Source: String; aString : String): Int32;
begin
  result := -1;
  var llen := aString:Length;
  if llen = 0 then exit;
  var lcnt := Source:Length - llen + 1;
  if lcnt < 0 then exit;
  var i: Integer;
  var j := 0;
  for i := 0 to lcnt do begin
    while (j >= 0) and (j < llen) do begin
      if Source.Chars[i + j] = aString.Chars[j] then
        inc(j)
      else
        j := -1;
    end;
    if j >= llen then exit i;
  end;  
end;

method String_Split(Source: String; Separator : Char): List<String>;
begin
  exit String_Split(Source,Separator+'');
end;

method String_Split(Source: String; Separator : String): List<String>;
begin
  result := new List<String>;
  var ls := Source;  
  var i: Integer;
  repeat
    i := String_IndexOf(ls,Separator);
    if i = -1 then break;
    result.Add(ls.Substring(0,i));
    ls := ls.Substring(i+Separator.Length);
  until false;
  result.Add(ls);
end;

constructor MemIniFile(const aFile: File);
begin
  fFile := aFile;
  fList := new Dictionary<String,Dictionary<String,String>>();
  LoadValues;
end;

method MemIniFile.Clear;
begin
  fList.Clear;
end;

method MemIniFile.DeleteKey(Section: String; Ident: String);
begin
  if SectionExists(Section) then
    fList.Item[Section].Remove(Ident);
end;

method MemIniFile.EraseSection(Section: String);
begin
  if SectionExists(Section) then fList.Remove(Section);
end;

method MemIniFile.GetStrings(List: List<String>);
begin
  List.Clear;
  for lk in fList.Keys do begin
    List.Add('['+lk+']');
    int_ReadSectionValues(lk,List);
    List.Add('');
  end;
end;

method MemIniFile.ReadSection(Section: String; List: List<String>);
begin
  List.Clear;
  if fList.ContainsKey(Section) then
    for lk1 in fList.Item[Section].Keys do 
      List.Add(lk1);
end;

method MemIniFile.ReadSections(List: List<String>);
begin
  List.Clear;
  for lk in fList.Keys do
    List.Add(lk);
end;

method MemIniFile.ReadSectionValues(Section: String; List: List<String>);
begin
  List.Clear;
  int_ReadSectionValues(Section,List);
end;

method MemIniFile.ReadString(Section: String; Ident: String; &Default: String): String;
begin
  result := &Default;
  if SectionExists(Section) then begin
    var lDict := fList.Item[Section];
    if lDict.ContainsKey(Ident) then result := lDict.Item[Ident];
  end;
end;

method MemIniFile.SetStrings(List: List<String>);
begin
  Clear;
  var ldict: Dictionary<String,String> := nil;
  var i: Integer;
  var lSectionfound := false;
  for i := 0 to List.Count - 1 do begin
    var lname := List[i].Trim;
    if String.IsNullOrEmpty(lname) or (lname[0] = ';') then continue;
    if (lname[0] = '[') and (lname[lname.Length-1] = ']') then begin
      lSectionfound := true;
      ldict := Int_AddSection(lname.Substring(1, lname.Length-2).Trim);      
    end
    else begin
      if lSectionfound then begin
        var lvalue := '';
        var lindex := String_IndexOf(lname,'=');
        if lindex <>-1 then begin
          lvalue:= lname.Substring(lindex+1).Trim;
          lname := lname.Substring(0, lindex).Trim;
        end;
        Int_AddValue(ldict,lname,lvalue);
      end;
    end;
  end;
end;

method MemIniFile.UpdateFile;
begin
  var lList := new List<String>;
  var lsb := new StringBuilder;
  GetStrings(lList);
  var i: Integer;
  for i:=0 to lList.Count do
    lsb.AppendLine(lList[i]);
  File.WriteText(lsb.ToString);
end;

method MemIniFile.WriteString(Section: String; Ident: String; Value: String);
begin
  Int_AddValue(Int_AddSection(Section), Ident, Value);
end;

method MemIniFile.LoadValues;
begin
  Clear; 
  SetStrings(String_Split(fFile.ReadText.Replace(#13#10,#10),#10));
end;

method MemIniFile.SectionExists(Section: String): Boolean;
begin
  result := fList.ContainsKey(Section);
end;


method MemIniFile.ValueExists(Section: String; Ident: String): Boolean;
begin
  result := true;
  if SectionExists(Section) then begin
    var lDict := fList.Item[Section];
    result := lDict.ContainsKey(Ident);
  end;
end;

method MemIniFile.int_ReadSectionValues(Section: String; List: List<String>);
begin
  if fList.ContainsKey(Section) then begin
    var lv := fList.Item[Section];
    for lk1 in lv.Keys do 
      List.Add(lk1+'='+lv.Item[lk1]);
  end;
end;

method MemIniFile.Int_AddSection(Section: String): Dictionary<String, String>;
begin
  if fList.ContainsKey(Section) then exit fList[Section];
  result := new Dictionary<String, String>;
  fList.Add(Section,result);  
end;

method MemIniFile.Int_AddValue(Section: Dictionary<String, String>; Ident: String; Value: String);
begin
  if Section.ContainsKey(Ident) then 
    Section.Item[Ident] := Value
  else
    Section.Add(Ident,Value);
end;

method MemIniFile.Revert;
begin
  LoadValues;
end;

end.

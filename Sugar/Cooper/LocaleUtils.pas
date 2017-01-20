namespace Sugar.Cooper;

interface

{$IFNDEF COOPER}
  {$ERROR This unit is intended for Cooper only}
{$ENDIF}

uses
  Sugar,
  java.util;

type
  LocaleUtils = public static class
  private
    method Exists(Value: java.lang.String; Items: array of java.lang.String): Boolean;
    method Verify(Tag: java.lang.String): tuple of (java.lang.String, java.lang.String);
  public
    method ForLanguageTag(Tag: java.lang.String): Locale;
  end;

implementation

class method LocaleUtils.Exists(Value: java.lang.String; Items: array of java.lang.String): Boolean;
begin
  if Value = nil then
    exit false;

  if Value = '' then
    exit false;

  for item in Items do
    if Value.equalsIgnoreCase(item) then
      exit true;

  exit false;
end;

class method LocaleUtils.ForLanguageTag(Tag: java.lang.String): Locale;
begin
  var Codes := Verify(Tag);
  if Codes.Item2 = nil then
    exit new Locale(Codes.Item1)
  else
    exit new Locale(Codes.Item1, Codes.Item2);
end;

class method LocaleUtils.Verify(Tag: java.lang.String): tuple of (java.lang.String, java.lang.String);
begin
  var Codes: array of java.lang.String;

  if Tag.indexOf("-") <> -1 then
    Codes := Tag.split("-")
  else if Tag.indexOf("_") <> -1 then
    Codes := Tag.split("_")
  else
    Codes := [Tag];

  //language
  var Language := Codes[0];

  if not Exists(Language, Locale.getISOLanguages) then
    raise new SugarFormatException(ErrorMessage.FORMAT_ERROR);

  //Country
  if Codes.length = 2 then begin
    var Country := Codes[1];

    if not Exists(Country, Locale.getISOCountries) then
      raise new SugarFormatException(ErrorMessage.FORMAT_ERROR);

    exit (Language, Country);
  end;

  //without country
  exit (Language, nil);
end;

end.
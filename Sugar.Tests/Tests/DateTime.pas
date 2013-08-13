namespace Sugar.Test;

interface

{$HIDE W0} //supress case-mismatch errors

uses
  RemObjects.Oxygene.Sugar,
  RemObjects.Oxygene.Sugar.TestFramework;

type
  DateTimeTest = public class (Testcase)
  private
    Data: DateTime;
    method AreEqual(Expected, Actual: DateTime);
    method AssertFormat(Expected: String; Date: DateTime; Locale: String; Format: String);
    method AssertFormat(Expected: String; Date: DateTime; Format: String);
    method AssertFormat(Expected: String; Locale: String; Format: String);
    method AssertFormat(Expected: String; Format: String);
  public
    method Setup; override;
    method AddDays;
    method AddHours;
    method AddMinutes;
    method AddMonths;
    method AddSeconds;
    method AddYears;
    method CompareTo;

    //Formats
    method FormatYears;
    method FormatMonths;
    method FormatDays;
    method FormatHours;
    method FormatMinutesSeconds;
    method ToStringFormat;

    //fields
    method Fields;
  end;

implementation

method DateTimeTest.Setup;
begin
  Data := new DateTime(1961, 4, 12, 6, 7, 0);
end;

method DateTimeTest.AreEqual(Expected: DateTime; Actual: DateTime);
begin
  Assert.CheckInt(Expected.Year, Actual.Year);
  Assert.CheckInt(Expected.Month, Actual.Month);
  Assert.CheckInt(Expected.Day, Actual.Day);
  Assert.CheckInt(Expected.Hour, Actual.Hour);
  Assert.CheckInt(Expected.Minute, Actual.Minute);
  Assert.CheckInt(Expected.Second, Actual.Second);
end;

method DateTimeTest.AssertFormat(Expected: String; Date: DateTime; Locale: String; Format: String);
begin
  Assert.CheckString(Expected, Date.ToString(Format, Locale));
end;

method DateTimeTest.AssertFormat(Expected: String; Date: DateTime; Format: String);
begin
  AssertFormat(Expected, Date, nil, Format);
end;

method DateTimeTest.AssertFormat(Expected: String; Locale: String; Format: String);
begin
  AssertFormat(Expected, Data, Locale, Format);
end;

method DateTimeTest.AssertFormat(Expected: String; Format: String);
begin
  AssertFormat(Expected, Data, Format);
end;

method DateTimeTest.AddDays;
begin
  var Value := Data.AddDays(1);
  Assert.CheckInt(13, Value.Day);
  Value := Data.AddDays(-1);
  Assert.CheckInt(11, Value.Day);

  Value := Data.AddDays(19); //next month
  Assert.CheckInt(1, Value.Day);
  Assert.CheckInt(5, Value.Month);
end;

method DateTimeTest.AddHours;
begin
  var Value := Data.AddHours(1);
  Assert.CheckInt(7, Value.Hour);
  Value := Data.AddHours(-1);
  Assert.CheckInt(5, Value.Hour);

  Value := Data.AddHours(19); //next day
  Assert.CheckInt(13, Value.Day);
  Assert.CheckInt(1, Value.Hour);
end;

method DateTimeTest.AddMinutes;
begin
  var Value := Data.AddMinutes(1);
  Assert.CheckInt(8, Value.Minute);
  Value := Data.AddMinutes(-1);
  Assert.CheckInt(6, Value.Minute);

  Value := Data.AddMinutes(53); //next hour
  Assert.CheckInt(0, Value.Minute);
  Assert.CheckInt(7, Value.Hour);
end;

method DateTimeTest.AddMonths;
begin
  var Value := Data.AddMonths(1);
  Assert.CheckInt(5, Value.Month);
  Value := Data.AddMonths(-1);
  Assert.CheckInt(3, Value.Month);

  Value := Data.AddMonths(9); //next year
  Assert.CheckInt(1, Value.Month);
  Assert.CheckInt(1962, Value.Year);
end;

method DateTimeTest.AddSeconds;
begin
  var Value := Data.AddSeconds(1);
  Assert.CheckInt(1, Value.Second);
  Value := Data.AddSeconds(-1);
  Assert.CheckInt(59, Value.Second);

  Value := Data.AddSeconds(60); //next year
  Assert.CheckInt(0, Value.Second);
  Assert.CheckInt(8, Value.Minute);
end;

method DateTimeTest.AddYears;
begin
  var Value := Data.AddYears(1);
  Assert.CheckInt(1962, Value.Year);
  Value := Data.AddYears(-1);
  Assert.CheckInt(1960, Value.Year);
end;

method DateTimeTest.CompareTo;
begin
  Assert.CheckInt(0, Data.CompareTo(Data));
  Assert.CheckBool(true, Data.CompareTo(Data.AddDays(10)) <> 0);
  Assert.CheckInt(0, Data.CompareTo(new DateTime(1961, 4, 12, 6, 7, 0)));
end;

method DateTimeTest.FormatYears;
begin
  //single digit not supported
  Assert.IsException(->Data.ToString("{y}"));

  AssertFormat("61", "{yy}");
  AssertFormat("1961", "{yyy}");
  AssertFormat("1961", "{yyyy}");

  AssertFormat("05", new DateTime(5, 1, 1), "{yy}");
  AssertFormat("005", new DateTime(5, 1, 1), "{yyy}");
  AssertFormat("0005", new DateTime(5, 1, 1), "{yyyy}");

  AssertFormat("25", new DateTime(25, 1, 1), "{yy}");
  AssertFormat("025", new DateTime(25, 1, 1), "{yyy}");
  AssertFormat("0025", new DateTime(25, 1, 1), "{yyyy}");

  AssertFormat("25", new DateTime(325, 1, 1), "{yy}");
  AssertFormat("325", new DateTime(325, 1, 1), "{yyy}");
  AssertFormat("0325", new DateTime(325, 1, 1), "{yyyy}");

  AssertFormat("05", new DateTime(2305, 1, 1), "{yy}");
  AssertFormat("2305", new DateTime(2305, 1, 1), "{yyy}");
  AssertFormat("2305", new DateTime(2305, 1, 1), "{yyyy}");
end;

method DateTimeTest.FormatMonths;
begin
  AssertFormat("4", "{M}");
  AssertFormat("04", "{MM}");
  AssertFormat("1", new DateTime(1,1,1), "{M}");
  AssertFormat("01", new DateTime(1,1,1), "{MM}");  
  AssertFormat("апр", "ru-RU", "{MMM}");
  AssertFormat("Апрель", "ru-RU", "{MMMM}");
 

  //short
  AssertFormat("Jan", new DateTime(1, 1, 1), "en-US", "{MMM}");
  AssertFormat("Feb", new DateTime(1, 2, 1), "en-US", "{MMM}");
  AssertFormat("Mar", new DateTime(1, 3, 1), "en-US", "{MMM}");
  AssertFormat("Apr", new DateTime(1, 4, 1), "en-US", "{MMM}");
  AssertFormat("May", new DateTime(1, 5, 1), "en-US", "{MMM}");
  AssertFormat("Jun", new DateTime(1, 6, 1), "en-US", "{MMM}");
  AssertFormat("Jul", new DateTime(1, 7, 1), "en-US", "{MMM}");
  AssertFormat("Aug", new DateTime(1, 8, 1), "en-US", "{MMM}");
  AssertFormat("Sep", new DateTime(1, 9, 1), "en-US", "{MMM}");
  AssertFormat("Oct", new DateTime(1, 10, 1), "en-US", "{MMM}");
  AssertFormat("Nov", new DateTime(1, 11, 1), "en-US", "{MMM}");
  AssertFormat("Dec", new DateTime(1, 12, 1), "en-US", "{MMM}");

  AssertFormat("janv.", new DateTime(1, 1, 1), "fr-FR", "{MMM}");
  AssertFormat("févr.", new DateTime(1, 2, 1), "fr-FR", "{MMM}");
  AssertFormat("mars", new DateTime(1, 3, 1), "fr-FR", "{MMM}");
  AssertFormat("avr.", new DateTime(1, 4, 1), "fr-FR", "{MMM}");
  AssertFormat("mai", new DateTime(1, 5, 1), "fr-FR", "{MMM}");
  AssertFormat("juin", new DateTime(1, 6, 1), "fr-FR", "{MMM}");
  AssertFormat("juil.", new DateTime(1, 7, 1), "fr-FR", "{MMM}");
  AssertFormat("août", new DateTime(1, 8, 1), "fr-FR", "{MMM}");
  AssertFormat("sept.", new DateTime(1, 9, 1), "fr-FR", "{MMM}");
  AssertFormat("oct.", new DateTime(1, 10, 1), "fr-FR", "{MMM}");
  AssertFormat("nov.", new DateTime(1, 11, 1), "fr-FR", "{MMM}");
  AssertFormat("déc.", new DateTime(1, 12, 1), "fr-FR", "{MMM}");

  //long
  AssertFormat("January", new DateTime(1, 1, 1), "en-US", "{MMMM}");
  AssertFormat("February", new DateTime(1, 2, 1), "en-US", "{MMMM}");
  AssertFormat("March", new DateTime(1, 3, 1), "en-US", "{MMMM}");
  AssertFormat("April", new DateTime(1, 4, 1), "en-US", "{MMMM}");
  AssertFormat("May", new DateTime(1, 5, 1), "en-US", "{MMMM}");
  AssertFormat("June", new DateTime(1, 6, 1), "en-US", "{MMMM}");
  AssertFormat("July", new DateTime(1, 7, 1), "en-US", "{MMMM}");
  AssertFormat("August", new DateTime(1, 8, 1), "en-US", "{MMMM}");
  AssertFormat("September", new DateTime(1, 9, 1), "en-US", "{MMMM}");
  AssertFormat("October", new DateTime(1, 10, 1), "en-US", "{MMMM}");
  AssertFormat("November", new DateTime(1, 11, 1), "en-US", "{MMMM}");
  AssertFormat("December", new DateTime(1, 12, 1), "en-US", "{MMMM}");

  AssertFormat("janvier", new DateTime(1, 1, 1), "fr-FR", "{MMMM}");
  AssertFormat("février", new DateTime(1, 2, 1), "fr-FR", "{MMMM}");
  AssertFormat("mars", new DateTime(1, 3, 1), "fr-FR", "{MMMM}");
  AssertFormat("avril", new DateTime(1, 4, 1), "fr-FR", "{MMMM}");
  AssertFormat("mai", new DateTime(1, 5, 1), "fr-FR", "{MMMM}");
  AssertFormat("juin", new DateTime(1, 6, 1), "fr-FR", "{MMMM}");
  AssertFormat("juillet", new DateTime(1, 7, 1), "fr-FR", "{MMMM}");
  AssertFormat("août", new DateTime(1, 8, 1), "fr-FR", "{MMMM}");
  AssertFormat("septembre", new DateTime(1, 9, 1), "fr-FR", "{MMMM}");
  AssertFormat("octobre", new DateTime(1, 10, 1), "fr-FR", "{MMMM}");
  AssertFormat("novembre", new DateTime(1, 11, 1), "fr-FR", "{MMMM}");
  AssertFormat("décembre", new DateTime(1, 12, 1), "fr-FR", "{MMMM}");
end;

method DateTimeTest.FormatDays;
begin
  AssertFormat("12", "{d}");
  AssertFormat("12", "{dd}");
  AssertFormat("Ср", "ru-RU", "{ddd}");
  AssertFormat("среда", "ru-RU", "{dddd}");
  
  AssertFormat("5", new DateTime(1, 1, 5), "{d}");
  AssertFormat("05", new DateTime(1, 1, 5), "{dd}");

  //short
  AssertFormat("Mon", new DateTime(2013, 7, 1), "en-US", "{ddd}");
  AssertFormat("Tue", new DateTime(2013, 7, 2), "en-US", "{ddd}");
  AssertFormat("Wed", new DateTime(2013, 7, 3), "en-US", "{ddd}");
  AssertFormat("Thu", new DateTime(2013, 7, 4), "en-US", "{ddd}");
  AssertFormat("Fri", new DateTime(2013, 7, 5), "en-US", "{ddd}");
  AssertFormat("Sat", new DateTime(2013, 7, 6), "en-US", "{ddd}");
  AssertFormat("Sun", new DateTime(2013, 7, 7), "en-US", "{ddd}");

  AssertFormat("lun.", new DateTime(2013, 7, 1), "fr-FR", "{ddd}");
  AssertFormat("mar.", new DateTime(2013, 7, 2), "fr-FR", "{ddd}");
  AssertFormat("mer.", new DateTime(2013, 7, 3), "fr-FR", "{ddd}");
  AssertFormat("jeu.", new DateTime(2013, 7, 4), "fr-FR", "{ddd}");
  AssertFormat("ven.", new DateTime(2013, 7, 5), "fr-FR", "{ddd}");
  AssertFormat("sam.", new DateTime(2013, 7, 6), "fr-FR", "{ddd}");
  AssertFormat("dim.", new DateTime(2013, 7, 7), "fr-FR", "{ddd}");

  //long
  AssertFormat("Monday", new DateTime(2013, 7, 1), "en-US", "{dddd}");
  AssertFormat("Tuesday", new DateTime(2013, 7, 2), "en-US", "{dddd}");
  AssertFormat("Wednesday", new DateTime(2013, 7, 3), "en-US", "{dddd}");
  AssertFormat("Thursday", new DateTime(2013, 7, 4), "en-US", "{dddd}");
  AssertFormat("Friday", new DateTime(2013, 7, 5), "en-US", "{dddd}");
  AssertFormat("Saturday", new DateTime(2013, 7, 6), "en-US", "{dddd}");
  AssertFormat("Sunday", new DateTime(2013, 7, 7), "en-US", "{dddd}");

  AssertFormat("lundi", new DateTime(2013, 7, 1), "fr-FR", "{dddd}");
  AssertFormat("mardi", new DateTime(2013, 7, 2), "fr-FR", "{dddd}");
  AssertFormat("mercredi", new DateTime(2013, 7, 3), "fr-FR", "{dddd}");
  AssertFormat("jeudi", new DateTime(2013, 7, 4), "fr-FR", "{dddd}");
  AssertFormat("vendredi", new DateTime(2013, 7, 5), "fr-FR", "{dddd}");
  AssertFormat("samedi", new DateTime(2013, 7, 6), "fr-FR", "{dddd}");
  AssertFormat("dimanche", new DateTime(2013, 7, 7), "fr-FR", "{dddd}");
end;

method DateTimeTest.FormatHours;
begin
  AssertFormat("6", "{h}");
  AssertFormat("6", "{H}");

  //1-12
  AssertFormat("1", new DateTime(1, 1, 1, 1, 0, 0), "{h}");
  AssertFormat("01", new DateTime(1, 1, 1, 1, 0, 0), "{hh}");
  AssertFormat("12", new DateTime(1, 1, 1, 12, 0, 0), "{h}");
  AssertFormat("1", new DateTime(1, 1, 1, 13, 0, 0), "{h}");
  AssertFormat("01", new DateTime(1, 1, 1, 13, 0, 0), "{hh}");
  AssertFormat("12", new DateTime(1, 1, 1, 0, 0, 0), "{h}");
  AssertFormat("05", new DateTime(1, 1, 1, 5, 0, 0), "{hh}");

  //0-23
  AssertFormat("1", new DateTime(1, 1, 1, 1, 0, 0), "{H}");
  AssertFormat("01", new DateTime(1, 1, 1, 1, 0, 0), "{HH}");
  AssertFormat("12", new DateTime(1, 1, 1, 12, 0, 0), "{H}");
  AssertFormat("13", new DateTime(1, 1, 1, 13, 0, 0), "{H}");
  AssertFormat("13", new DateTime(1, 1, 1, 13, 0, 0), "{HH}");
  AssertFormat("0", new DateTime(1, 1, 1, 0, 0, 0), "{H}");
  AssertFormat("00", new DateTime(1, 1, 1, 0, 0, 0), "{HH}");
  AssertFormat("23", new DateTime(1, 1, 1, 23, 0, 0), "{H}");

  //AM/PM sign
  AssertFormat("AM", new DateTime(1, 1, 1, 1, 0, 0), "en-US", "{a}");
  AssertFormat("PM", new DateTime(1, 1, 1, 13, 0, 0), "en-US", "{a}");
  AssertFormat("", new DateTime(1, 1, 1, 1, 0, 0), "fr-FR", "{a}"); //not available in some cultures
  AssertFormat("", new DateTime(1, 1, 1, 13, 0, 0), "fr-FR", "{a}");
end;

method DateTimeTest.FormatMinutesSeconds;
begin
  //minutes
  AssertFormat("0", new DateTime(1, 1, 1, 1, 0, 0), "{m}");
  AssertFormat("30", new DateTime(1, 1, 1, 1, 30, 0), "{m}");
  AssertFormat("59", new DateTime(1, 1, 1, 1, 59, 0), "{m}");

  AssertFormat("00", new DateTime(1, 1, 1, 1, 0, 0), "{mm}");
  AssertFormat("07", new DateTime(1, 1, 1, 1, 7, 0), "{mm}");
  AssertFormat("59", new DateTime(1, 1, 1, 1, 59, 0), "{mm}");

  //seconds
  AssertFormat("0", new DateTime(1, 1, 1, 1, 0, 0), "{s}");
  AssertFormat("30", new DateTime(1, 1, 1, 1, 0, 30), "{s}");
  AssertFormat("59", new DateTime(1, 1, 1, 1, 0, 59), "{s}");

  AssertFormat("00", new DateTime(1, 1, 1, 1, 0, 0), "{ss}");
  AssertFormat("07", new DateTime(1, 1, 1, 1, 0, 7), "{ss}");
  AssertFormat("59", new DateTime(1, 1, 1, 1, 0, 59), "{ss}");
end;

method DateTimeTest.ToStringFormat;
begin
  AssertFormat("1961/04/12 06:07:00", "{yyyy}/{MM}/{dd} {HH}:{mm}:{ss}");
  AssertFormat("On Wednesday, 12 April, 1961 at 6:07 – the first human traveled into outer space", "en-US",
              "On {dddd}, {dd} {MMMM}, {yyyy} at {h}:{mm} – the first human traveled into outer space");
  AssertFormat("Formating year 1961, 1961, 61", "Formating year {yyyy}, {yyy}, {yy}");
  AssertFormat("Time is 6 o'clock", "Time is {h} o\'clock");
  Assert.IsException(->Data.ToString(nil));
  Assert.IsException(->Data.ToString("Year is {yyyy"));
  Assert.IsException(->Data.ToString("Year is yyyy}"));
  Assert.IsException(->Data.ToString("Year is {}"));
  Assert.IsException(->Data.ToString("Year is {Yyyy}"));  
  {$WARNING Not completed due to compiler bug #63608}
  //Assert.IsException(->Data.ToString("{dd}", ""));
  Assert.CheckString('', Data.ToString(''));
end;

method DateTimeTest.Fields;
begin
  Assert.CheckInt(1961, Data.Year);
  Assert.CheckInt(4, Data.Month);
  Assert.CheckInt(12, Data.Day);
  Assert.CheckInt(6, Data.Hour);
  Assert.CheckInt(7, Data.Minute);
  Assert.CheckInt(35, new DateTime(1,1,1,1,1,35).Second);

  AreEqual(new DateTime(1961, 4, 12), Data.Date);
  Assert.CheckInt(0, Data.Date.Hour);
end;

end.

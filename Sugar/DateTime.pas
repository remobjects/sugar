namespace Sugar;

interface

{$IF COOPER}
uses
  java.nio,
  java.util;
{$ELSEIF TOFFEE}
uses
  Foundation;
{$ENDIF}

type
  {$IF TOFFEE}
  DateTimeHelpers = public static class
  public
    method GetComponent(aSelf: NSDate; Component: NSCalendarUnit): Integer;
    method AdjustDate(aSelf: NSDate; Component: NSCalendarUnit; Value: Integer): DateTime;
    class property LocalTimezone: NSTimeZone := NSTimeZone.localTimeZone;
  end;
  {$ENDIF}

  {$IF ECHOES}[System.Runtime.InteropServices.StructLayout(System.Runtime.InteropServices.LayoutKind.Auto, Size := 1)]{$ENDIF}
  DateTime = public {$IF COOPER}class mapped to java.util.Calendar{$ELSEIF ECHOES}record mapped to System.DateTime{$ELSEIF TOFFEE}class mapped to NSDate{$ENDIF}
  private
  private
    const DEFAULT_FORMAT = "dd/MM/yyyy hh:mm:ss";
    const DEFAULT_FORMAT_DATE = "dd/MM/yyyy";
    const DEFAULT_FORMAT_DATE_SHORT = "d/M/yyyy";
    const DEFAULT_FORMAT_TIME = "hh:mm:ss";
    const DEFAULT_FORMAT_TIME_SHORT = "hh:mm";
  public
    constructor;
    constructor(aTicks: Int64);
    constructor(aYear, aMonth, aDay: Integer);
    constructor(aYear, aMonth, aDay, anHour, aMinute: Integer);
    constructor(aYear, aMonth, aDay, anHour, aMinute, aSecond: Integer);
    {$IF COOPER}
    constructor(aDate: date);
    {$ENDIF}

    method AddDays(Value: Integer): DateTime;
    method AddHours(Value: Integer): DateTime;
    method AddMinutes(Value: Integer): DateTime;
    method AddMonths(Value: Integer): DateTime;
    method AddSeconds(Value: Integer): DateTime;
    method AddYears(Value: Integer): DateTime;

    method CompareTo(Value: DateTime): Integer;
    method ToString(aTimeZone: TimeZone): String;
    method ToString(Format: String; aTimeZone: TimeZone := nil): String;
    method ToString(Format: String; Culture: String; aTimeZone: TimeZone := nil): String;

    method ToShortDateString(aTimeZone: TimeZone := nil): String;
    method ToShortTimeString(aTimeZone: TimeZone := nil): String;

    method ToShortPrettyDateString(aTimeZone: TimeZone := nil): String;
    method ToLongPrettyDateString(aTimeZone: TimeZone := nil): String;

    {$IF COOPER}
    method ToString: java.lang.String; override;
    {$ELSEIF ECHOES}
    method ToString: System.String; override;
    {$ELSEIF TOFFEE}
    method description: NSString; override; inline;
    {$ENDIF}

    property Hour: Integer read {$IF COOPER}mapped.get(Calendar.HOUR_OF_DAY){$ELSEIF ECHOES}mapped.Hour{$ELSEIF TOFFEE}DateTimeHelpers.GetComponent(mapped, NSCalendarUnit.NSHourCalendarUnit){$ENDIF};
    property Minute: Integer read {$IF COOPER}mapped.get(Calendar.MINUTE){$ELSEIF ECHOES}mapped.Minute{$ELSEIF TOFFEE}DateTimeHelpers.GetComponent(mapped, NSCalendarUnit.NSMinuteCalendarUnit){$ENDIF};
    property Second: Integer read {$IF COOPER}mapped.get(Calendar.SECOND){$ELSEIF ECHOES}mapped.Second{$ELSEIF TOFFEE}DateTimeHelpers.GetComponent(mapped, NSCalendarUnit.NSSecondCalendarUnit){$ENDIF};
    property Year: Integer read {$IF COOPER}mapped.get(Calendar.YEAR){$ELSEIF ECHOES}mapped.Year{$ELSEIF TOFFEE}DateTimeHelpers.GetComponent(mapped, NSCalendarUnit.NSYearCalendarUnit){$ENDIF};
    property Month: Integer read {$IF COOPER}mapped.get(Calendar.MONTH)+1{$ELSEIF ECHOES}mapped.Month{$ELSEIF TOFFEE}DateTimeHelpers.GetComponent(mapped, NSCalendarUnit.NSMonthCalendarUnit){$ENDIF};
    property Day: Integer read {$IF COOPER}mapped.get(Calendar.DAY_OF_MONTH){$ELSEIF ECHOES}mapped.Day{$ELSEIF TOFFEE}DateTimeHelpers.GetComponent(mapped, NSCalendarUnit.NSDayCalendarUnit){$ENDIF};
    property DayOfWeek: Integer read {$IF COOPER}mapped.get(Calendar.DAY_OF_WEEK){$ELSEIF ECHOES}Integer(mapped.DayOfWeek)+1{$ELSEIF TOFFEE}DateTimeHelpers.GetComponent(mapped, NSCalendarUnit.NSWeekdayCalendarUnit){$ENDIF};
    property Date: DateTime read {$IF COOPER OR TOFFEE}new DateTime(self.Year, self.Month, self.Day, 0, 0, 0){$ELSEIF ECHOES}mapped.Date{$ENDIF};

    class property Today: DateTime read {$IF COOPER OR TOFFEE}UtcNow.Date{$ELSEIF ECHOES}mapped.Today{$ENDIF};
    class property UtcNow: DateTime read {$IF COOPER OR TOFFEE}new DateTime(){$ELSEIF ECHOES}mapped.UtcNow{$ENDIF};
    const TicksSince1970: Int64 = 621355968000000000;

    property TimeSince: TimeSpan read (UtcNow-self);
    class method TimeSince(aOtherDateTime: DateTime): TimeSpan;

    property Ticks: Int64 read{$IFDEF COOPER}(mapped.TimeInMillis +mapped.TimeZone.getOffset(mapped.TimeInMillis)) * TimeSpan.TicksPerMillisecond + TicksSince1970{$ELSEIF ECHOES}mapped.Ticks{$ELSE}Int64((mapped.timeIntervalSince1970 + DateTimeHelpers.LocalTimezone.secondsFromGMTForDate(mapped)) * TimeSpan.TicksPerSecond) + TicksSince1970{$ENDIF};
    class operator &Add(a: DateTime; b: TimeSpan): DateTime;
    class operator Subtract(a: DateTime; b: DateTime): TimeSpan;
    class operator Subtract(a: DateTime; b: TimeSpan): DateTime;

    class operator Equal(a,b: DateTime): Boolean;
    class operator NotEqual(a,b: DateTime): Boolean;
    class operator Less(a,b: DateTime): Boolean;
    class operator LessOrEqual(a,b: DateTime): Boolean;
    class operator Greater(a, b: DateTime): Boolean;
    class operator GreaterOrEqual(a,b: DateTime): Boolean;
  end;

implementation

constructor DateTime;
begin
  {$IF COOPER}
  exit Calendar.Instance;
  {$ELSEIF ECHOES}
  exit new System.DateTime;
  {$ELSEIF TOFFEE}
  exit new NSDate;
  {$ENDIF}
end;

constructor DateTime(aYear: Integer; aMonth: Integer; aDay: Integer);
begin
  {$IF COOPER OR TOFFEE}
  constructor(aYear, aMonth, aDay, 0, 0, 0);
  {$ELSEIF ECHOES}
  exit new System.DateTime(aYear, aMonth, aDay);
  {$ENDIF}
end;

constructor DateTime(aYear: Integer; aMonth: Integer; aDay: Integer; anHour: Integer; aMinute: Integer);
begin
  {$IF COOPER OR TOFFEE}
  constructor(aYear, aMonth, aDay, anHour, aMinute, 0);
  {$ELSEIF ECHOES}
  exit new System.DateTime(aYear, aMonth, aDay, anHour, aMinute, 0);
  {$ENDIF}
end;

constructor DateTime(aYear: Integer; aMonth: Integer; aDay: Integer; anHour: Integer; aMinute: Integer; aSecond: Integer);
begin
  {$IF COOPER}
  var lCalendar := Calendar.Instance;
  lCalendar.Time := new Date;
  lCalendar.set(Calendar.YEAR, aYear);
  lCalendar.set(Calendar.MONTH, aMonth-1);
  lCalendar.set(Calendar.DATE, aDay);
  lCalendar.set(Calendar.HOUR_OF_DAY, anHour);
  lCalendar.set(Calendar.MINUTE, aMinute);
  lCalendar.set(Calendar.SECOND, aSecond);
  lCalendar.set(Calendar.MILLISECOND, 0);
  exit lCalendar;
  {$ELSEIF ECHOES}
  exit new System.DateTime(aYear, aMonth, aDay, anHour, aMinute, aSecond);
  {$ELSEIF TOFFEE}
  var Components: NSDateComponents := new NSDateComponents();
  Components.setYear(aYear);
  Components.setMonth(aMonth);
  Components.setDay(aDay);
  Components.setHour(anHour);
  Components.setMinute(aMinute);
  Components.setSecond(aSecond);
  var lCalendar := NSCalendar.currentCalendar();
  exit lCalendar.dateFromComponents(Components);
  {$ENDIF}
end;

constructor DateTime(aTicks: Int64);
begin
  {$IFDEF COOPER}
  var lCalendar := Calendar.Instance;
  var dt := (aTicks - TicksSince1970) / TimeSpan.TicksPerMillisecond;
  lCalendar.Time := new Date(dt - lCalendar.TimeZone.getOffset(dt));

  exit lCalendar;
  {$ELSEIF ECHOES}
  exit new System.DateTime(aTicks);
  {$ELSEIF TOFFEE}
  var dt := NSDate.dateWithTimeIntervalSince1970(Double(aTicks - TicksSince1970) / TimeSpan.TicksPerSecond);

  exit NSDate.dateWithTimeInterval(-DateTimeHelpers.LocalTimezone.secondsFromGMTForDate(dt)) sinceDate(dt);
  {$ENDIF}
end;

{$IF COOPER}
constructor DateTime(aDate: Date);
begin
  result := Calendar.Instance;
  (result as Calendar).Time := aDate;
end;
{$ENDIF}

class method DateTime.TimeSince(aOtherDateTime: DateTime): TimeSpan;
begin
  result := (UtcNow-aOtherDateTime);
end;

//
// ToString
//

{$IF COOPER}
method DateTime.ToString: java.lang.String;
{$ELSEIF ECHOES}
method DateTime.ToString: System.String;
{$ELSEIF TOFFEE}
method DateTime.description: NSString;
{$ENDIF}
begin
  exit ToString(DEFAULT_FORMAT);
end;

method DateTime.ToString(Format: String; aTimeZone: TimeZone := nil): String;
begin
  exit ToString(Format, nil, aTimeZone);
end;

method DateTime.ToString(Format: String; Culture: String; aTimeZone: TimeZone := nil): String;
begin
  {$IF COOPER}
  var lFormatter := if String.IsNullOrEmpty(Culture) then
                      new java.text.SimpleDateFormat(DateFormatter.Format(Format))
                    else
                      new java.text.SimpleDateFormat(DateFormatter.Format(Format), Sugar.Cooper.LocaleUtils.ForLanguageTag(Culture));
  lFormatter.timeZone := coalesce(aTimeZone, TimeZone.Utc);
  result := lFormatter.format(mapped.Time);
  {$ELSEIF ECHOES}
  if Format = "" then
    exit "";

  if String.IsNullOrEmpty(Culture) then
    exit mapped.ToString(DateFormatter.Format(Format))
  else
    exit mapped.ToString(DateFormatter.Format(Format), new System.Globalization.CultureInfo(Culture));
  {$ELSEIF TOFFEE}
  var lFormatter := new NSDateFormatter();
  lFormatter.timeZone := coalesce(aTimeZone, TimeZone.Utc);
  if not String.IsNullOrEmpty(Culture) then begin
    var Locale := new NSLocale withLocaleIdentifier(Culture);
    lFormatter.locale := Locale;
  end;
  lFormatter.setDateFormat(DateFormatter.Format(Format));
  exit lFormatter.stringFromDate(mapped);
  {$ENDIF}
end;

method DateTime.ToString(aTimeZone: TimeZone := nil): String;
begin
  exit ToString(DEFAULT_FORMAT, nil, aTimeZone);
end;

method DateTime.ToShortDateString(aTimeZone: TimeZone := nil): String;
begin
  {$IF COOPER}
  var lFormatter := java.text.DateFormat.getDateInstance(java.text.DateFormat.SHORT);
  lFormatter.timeZone := coalesce(aTimeZone, TimeZone.Utc);
  result := lFormatter.format(mapped.Time);
  {$ELSEIF ECHOES}
    {$IF WINDOWS_PHONE OR NETFX_CORE}
    result := mapped.ToString;
    {$ELSE}
    result := mapped.ToShortDateString;
    {$ENDIF}
  {$ELSEIF TOFFEE}
  var lFormatter: NSDateFormatter := new NSDateFormatter();
  lFormatter.timeZone := coalesce(aTimeZone, TimeZone.Utc);
  lFormatter.dateStyle := NSDateFormatterStyle.ShortStyle;
  lFormatter.timeStyle := NSDateFormatterStyle.NoStyle;
  result := lFormatter.stringFromDate(mapped);
  {$ENDIF}
end;

method DateTime.ToShortTimeString(aTimeZone: TimeZone := nil): String;
begin
  {$IF COOPER}
  var lFormatter := java.text.DateFormat.getTimeInstance(java.text.DateFormat.SHORT);
  lFormatter.timeZone := coalesce(aTimeZone, TimeZone.Utc);
  result := lFormatter.format(mapped.Time);
  {$ELSEIF ECHOES}
    {$IF WINDOWS_PHONE OR NETFX_CORE}
    result := mapped.ToString();
    {$ELSE}
    result := mapped.ToShortTimeString();
    {$ENDIF}
  {$ELSEIF TOFFEE}
  var lFormatter: NSDateFormatter := new NSDateFormatter();
  lFormatter.timeZone := coalesce(aTimeZone, TimeZone.Utc);
  lFormatter.dateStyle := NSDateFormatterStyle.NoStyle;
  lFormatter.timeStyle := NSDateFormatterStyle.ShortStyle;
  result := lFormatter.stringFromDate(mapped);
  {$ENDIF}
end;

method DateTime.ToShortPrettyDateString(aTimeZone: TimeZone := nil): String;
begin
  {$IF COOPER}
  var lFormatter := java.text.DateFormat.getDateInstance(java.text.DateFormat.SHORT);
  lFormatter.timeZone := coalesce(aTimeZone, TimeZone.Utc);
  result := lFormatter.format(mapped.Time);
  {$ELSEIF ECHOES}
    {$IF WINDOWS_PHONE OR NETFX_CORE}
    result := ToShortDateString();
    {$ELSE}
    result := ToShortDateString();
    {$ENDIF}
  {$ELSEIF TOFFEE}
  var lFormatter: NSDateFormatter := new NSDateFormatter();
  lFormatter.timeZone := coalesce(aTimeZone, TimeZone.Utc);
  lFormatter.dateStyle := NSDateFormatterStyle.MediumStyle;
  lFormatter.timeStyle := NSDateFormatterStyle.NoStyle;
  result := lFormatter.stringFromDate(mapped);
  {$ENDIF}
end;

method DateTime.ToLongPrettyDateString(aTimeZone: TimeZone := nil): String;
begin
  {$IF COOPER}
  var lFormatter := java.text.DateFormat.getDateInstance(java.text.DateFormat.LONG);
  lFormatter.timeZone := coalesce(aTimeZone, TimeZone.Utc);
  result := lFormatter.format(mapped.Time);
  {$ELSEIF ECHOES}
    {$IF WINDOWS_PHONE OR NETFX_CORE}
    result := mapped.ToString;
    {$ELSE}
    result := mapped.ToShortDateString;
    {$ENDIF}
  {$ELSEIF TOFFEE}
  var lFormatter: NSDateFormatter := new NSDateFormatter();
  lFormatter.timeZone := coalesce(aTimeZone, TimeZone.Utc);
  lFormatter.dateStyle := NSDateFormatterStyle.LongStyle;
  lFormatter.timeStyle := NSDateFormatterStyle.NoStyle;
  result := lFormatter.stringFromDate(mapped);
  {$ENDIF}
end;

//
// Mutating Dates
//

{$IF TOFFEE}
method DateTimeHelpers.AdjustDate(aSelf: NSDate; Component: NSCalendarUnit; Value: Integer): DateTime;
begin
  var Components: NSDateComponents := new NSDateComponents();

  case Component of
    NSCalendarUnit.NSDayCalendarUnit: Components.setDay(Value);
    NSCalendarUnit.NSHourCalendarUnit: Components.setHour(Value);
    NSCalendarUnit.NSMinuteCalendarUnit: Components.setMinute(Value);
    NSCalendarUnit.NSMonthCalendarUnit: Components.setMonth(Value);
    NSCalendarUnit.NSSecondCalendarUnit: Components.setSecond(Value);
    NSCalendarUnit.NSYearCalendarUnit: Components.setYear(Value);
  end;

  var lCalendar := NSCalendar.currentCalendar();
  exit lCalendar.dateByAddingComponents(Components) toDate(aSelf) options(0);
end;

method DateTimeHelpers.GetComponent(aSelf: NSDate; Component: NSCalendarUnit): Integer;
begin
  var lComponents := NSCalendar.currentCalendar().components(Component) fromDate(aSelf);
  case Component of
    NSCalendarUnit.NSDayCalendarUnit: exit lComponents.day;
    NSCalendarUnit.NSHourCalendarUnit: exit lComponents.hour;
    NSCalendarUnit.NSMinuteCalendarUnit: exit lComponents.minute;
    NSCalendarUnit.NSMonthCalendarUnit: exit lComponents.month;
    NSCalendarUnit.NSSecondCalendarUnit: exit lComponents.second;
    NSCalendarUnit.NSYearCalendarUnit: exit lComponents.year;
  end;
end;
{$ENDIF}

method DateTime.AddDays(Value: Integer): DateTime;
begin
  {$IF COOPER}
  result := DateTime(mapped.clone);
  Calendar(result).add(Calendar.DATE, Value);
  exit;
  {$ELSEIF ECHOES}
  exit mapped.AddDays(Value);
  {$ELSEIF TOFFEE}
  exit DateTimeHelpers.AdjustDate(mapped, NSCalendarUnit.NSDayCalendarUnit, Value);
  {$ENDIF}
end;

method DateTime.AddHours(Value: Integer): DateTime;
begin
  {$IF COOPER}
  result := DateTime(mapped.clone);
  Calendar(result).add(Calendar.HOUR_OF_DAY, Value);
  exit;
  {$ELSEIF ECHOES}
  exit mapped.AddHours(Value);
  {$ELSEIF TOFFEE}
  exit DateTimeHelpers.AdjustDate(mapped, NSCalendarUnit.NSHourCalendarUnit, Value);
  {$ENDIF}
end;

method DateTime.AddMinutes(Value: Integer): DateTime;
begin
  {$IF COOPER}
  result := DateTime(mapped.clone);
  Calendar(result).add(Calendar.MINUTE, Value);
  exit;
  {$ELSEIF ECHOES}
  exit mapped.AddMinutes(Value);
  {$ELSEIF TOFFEE}
  exit DateTimeHelpers.AdjustDate(mapped, NSCalendarUnit.NSMinuteCalendarUnit, Value);
  {$ENDIF}
end;

method DateTime.AddMonths(Value: Integer): DateTime;
begin
  {$IF COOPER}
  result := DateTime(mapped.clone);
  Calendar(result).add(Calendar.MONTH, Value);
  exit;
  {$ELSEIF ECHOES}
  exit mapped.AddMonths(Value);
  {$ELSEIF TOFFEE}
  exit DateTimeHelpers.AdjustDate(mapped, NSCalendarUnit.NSMonthCalendarUnit, Value);
  {$ENDIF}
end;

method DateTime.AddSeconds(Value: Integer): DateTime;
begin
  {$IF COOPER}
  result := DateTime(mapped.clone);
  Calendar(result).add(Calendar.SECOND, Value);
  exit;
  {$ELSEIF ECHOES}
  exit mapped.AddSeconds(Value);
  {$ELSEIF TOFFEE}
  exit DateTimeHelpers.AdjustDate(mapped, NSCalendarUnit.NSSecondCalendarUnit, Value);
  {$ENDIF}
end;

method DateTime.AddYears(Value: Integer): DateTime;
begin
  {$IF COOPER}
  result := DateTime(mapped.clone);
  Calendar(result).add(Calendar.YEAR, Value);
  exit;
  {$ELSEIF ECHOES}
  exit mapped.AddYears(Value);
  {$ELSEIF TOFFEE}
  exit DateTimeHelpers.AdjustDate(mapped, NSCalendarUnit.NSYearCalendarUnit, Value);
  {$ENDIF}
end;

operator DateTime.Add(a: DateTime; b: TimeSpan): DateTime;
begin
  exit new DateTime(a.Ticks + b.Ticks);
end;

operator DateTime.Subtract(a: DateTime; b: DateTime): TimeSpan;
begin
  exit new TimeSpan(a.Ticks - b.Ticks);
end;

operator DateTime.Subtract(a: DateTime; b: TimeSpan): DateTime;
begin
  exit new DateTime(a.Ticks - b.Ticks);
end;

//
// Comparing Dates
//

method DateTime.CompareTo(Value: DateTime): Integer;
begin
  {$IF COOPER}
  exit mapped.compareTo(new DateTime(Value.Year, Value.Month, Value.Day, Value.Hour, Value.Minute, Value.Second));
  {$ELSEIF ECHOES}
  exit mapped.CompareTo(Value);
  {$ELSEIF TOFFEE}
  exit mapped.compare(new DateTime(Value.Year, Value.Month, Value.Day, Value.Hour, Value.Minute, Value.Second));
  {$ENDIF}
end;

operator DateTime.Equal(a: DateTime; b: DateTime): Boolean;
begin
  {$IF NOT ECHOES}
  if (Object(a) = nil) and (Object(b) = nil) then exit true;
  if (Object(a) = nil) or (Object(b) = nil) then exit false;
  {$ENDIF}
  exit a.Ticks = b.Ticks;
end;

operator DateTime.NotEqual(a: DateTime; b: DateTime): Boolean;
begin
  {$IF NOT ECHOES}
  if (Object(a) = nil) and (Object(b) = nil) then exit false;
  if (Object(a) = nil) or (Object(b) = nil) then exit true;
  {$ENDIF}
  exit a.Ticks <> b.Ticks;
end;

operator DateTime.Less(a: DateTime; b: DateTime): Boolean;
begin
  {$IF NOT ECHOES}
  if (Object(a) = nil) and (Object(b) = nil) then exit false;
  if (Object(a) = nil) then exit true;
  if (Object(b) = nil) then exit false;
  {$ENDIF}
  exit a.Ticks < b.Ticks;
end;

operator DateTime.LessOrEqual(a: DateTime; b: DateTime): Boolean;
begin
  {$IF NOT ECHOES}
  if (Object(a) = nil) and (Object(b) = nil) then exit true;
  if (Object(a) = nil) then exit true;
  if (Object(b) = nil) then exit false;
  {$ENDIF}
  exit a.Ticks <= b.Ticks;
end;

operator DateTime.Greater(a: DateTime; b: DateTime): Boolean;
begin
  {$IF NOT ECHOES}
  if (Object(a) = nil) and (Object(b) = nil) then exit false;
  if (Object(a) = nil) then exit false;
  if (Object(b) = nil) then exit true;
  {$ENDIF}
  exit a.Ticks > b.Ticks;
end;

operator DateTime.GreaterOrEqual(a: DateTime; b: DateTime): Boolean;
begin
  {$IF NOT ECHOES}
  if (Object(a) = nil) and (Object(b) = nil) then exit true;
  if (Object(a) = nil) then exit false;
  if (Object(b) = nil) then exit true;
  {$ENDIF}
  exit a.Ticks >= b.Ticks;
end;

end.
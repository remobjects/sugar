namespace RemObjects.Oxygene.Sugar;
{$HIDE W0} //supress case-mismatch errors
interface

{$IF COOPER}
uses
  java.util;
{$ELSEIF NOUGAT}
uses
  Foundation;
{$ENDIF}

type
  {$IF COOPER}
  DateTime = public record
  private
    fDate: Date; readonly;
    fCalendar: Calendar := Calendar.Instance; readonly;

    method InternalGetDate: DateTime;
    method AddComponent(Component: Integer; Value: Integer): Calendar;
    constructor(aDate: Date);
  public
    constructor;    
    constructor(aYear, aMonth, aDay: Integer);
    constructor(aYear, aMonth, aDay, anHour, aMinute: Integer);
    constructor(aYear, aMonth, aDay, anHour, aMinute, aSecond: Integer);
    method AddDays(Value: Integer): DateTime;
    method AddHours(Value: Integer): DateTime;
    method AddMilliseconds(Value: Integer): DateTime;
    method AddMinutes(Value: Integer): DateTime;
    method AddMonths(Value: Integer): DateTime;
    method AddSeconds(Value: Integer): DateTime;
    method AddYears(Value: Integer): DateTime;

    method CompareTo(Value: DateTime): Integer;
    method ToString: java.lang.String; override;
    method ToString(Format: String): String;
    method ToString(Format: String; Culture: String): String;

    property Date: DateTime read InternalGetDate;
    property Day: Integer read fCalendar.get(Calendar.DAY_OF_MONTH);
    property Hour: Integer read fCalendar.get(Calendar.HOUR_OF_DAY); //Field Hour is for 12h, Hour_of_Day for 24h
    property Minute: Integer read fCalendar.get(Calendar.MINUTE);
    property Month: Integer read fCalendar.get(Calendar.MONTH)+1; //in java month are 0-based
    class property Now: DateTime read new DateTime;
    property Second: Integer read fCalendar.get(Calendar.SECOND);
    class property Today: DateTime read Now.Date;
    property Year: Integer read fCalendar.get(Calendar.YEAR);    
  end;
  {$ELSEIF ECHOES}
  [System.Runtime.InteropServices.StructLayout(System.Runtime.InteropServices.LayoutKind.Auto, Size := 1)]
  DateTime = public record mapped to System.DateTime
  public
    method AddDays(Value: Integer): DateTime; mapped to AddDays(Value);
    method AddHours(Value: Integer): DateTime; mapped to AddHours(Value);
    method AddMilliseconds(Value: Integer): DateTime; mapped to AddMilliseconds(Value);
    method AddMinutes(Value: Integer): DateTime; mapped to AddMinutes(Value);
    method AddMonths(Value: Integer): DateTime; mapped to AddMonths(Value);
    method AddSeconds(Value: Integer): DateTime; mapped to AddSeconds(Value);
    method AddYears(Value: Integer): DateTime; mapped to AddYears(Value);
    
    method CompareTo(Value: DateTime): Integer; mapped to CompareTo(Value);
    method ToString: System.String; override;
    method ToString(Format: String): String;
    method ToString(Format: String; Culture: String): String;

    property Date: DateTime read mapped.Date;
    property Day: Integer read mapped.Day;
    property Hour: Integer read mapped.Hour;
    property Minute: Integer read mapped.Minute;
    property Month: Integer read mapped.Month;
    class property Now: DateTime read mapped.Now;
    property Second: Integer read mapped.Second;
    class property Today: DateTime read mapped.Today;
    property Year: Integer read mapped.Year;
  end;

  {$ELSEIF NOUGAT}
  DateTime = public class
  private
    fDate: NSDate;
    fCalendar: NSCalendar := NSCalendar.currentCalendar;  readonly;

    method InternalGetDate: DateTime;
    method GetComponent(Component: NSCalendarUnit): Integer;
    method FormatWithStyle(DateStyle, TimeStyle: NSDateFormatterStyle): String;
    method initWithDate(aDate: NSDate): id;
  public
    method init: id; override;
    constructor(aYear, aMonth, aDay: Integer);
    constructor(aYear, aMonth, aDay, anHour, aMinute: Integer);
    constructor(aYear, aMonth, aDay, anHour, aMinute, aSecond: Integer);
    method AddDays(Value: Integer): DateTime;
    method AddHours(Value: Integer): DateTime;
    method AddMilliseconds(Value: Integer): DateTime;
    method AddMinutes(Value: Integer): DateTime;
    method AddMonths(Value: Integer): DateTime;
    method AddSeconds(Value: Integer): DateTime;
    method AddYears(Value: Integer): DateTime;

    method CompareTo(Value: DateTime): Integer;
    method description: NSString; override;
    method ToString(Format: String): String;
    method ToString(Format: String; Culture: String): String;

    property Date: DateTime read InternalGetDate;
    property Day: Integer read GetComponent(NSCalendarUnit.NSDayCalendarUnit);
    property Hour: Integer read GetComponent(NSCalendarUnit.NSHourCalendarUnit);
    property Minute: Integer read GetComponent(NSCalendarUnit.NSMinuteCalendarUnit);
    property Month: Integer read GetComponent(NSCalendarUnit.NSMonthCalendarUnit);
    class property Now: DateTime read new DateTime;
    property Second: Integer read GetComponent(NSCalendarUnit.NSSecondCalendarUnit);
    class property Today: DateTime read Now.Date;
    property Year: Integer read GetComponent(NSCalendarUnit.NSYearCalendarUnit);
  end;
  {$ENDIF}

implementation

{$IF ECHOES}
method DateTime.ToString(Format: String): String;
begin
  exit ToString(Format, nil);
end;

method DateTime.ToString: System.String;
begin
  exit ToString("{dd}/{MM}/{yyyy} {hh}:{mm}:{ss}");
end;

method DateTime.ToString(Format: String; Culture: String): String;
begin
  if Format = '' then
    exit '';

  if String.IsNullOrEmpty(Culture) then
    exit mapped.ToString(DateFormater.Format(Format))
  else
    exit mapped.ToString(DateFormater.Format(Format), new System.Globalization.CultureInfo(Culture));
end;
{$ENDIF}

{$IF COOPER}
constructor DateTime;
begin
  constructor(new Date);
end;

constructor DateTime(aYear: Integer; aMonth: Integer; aDay: Integer; anHour: Integer; aMinute: Integer; aSecond: Integer);
begin
  var lCalendar := Calendar.Instance;
  lCalendar.Time := new Date;
  lCalendar.set(Calendar.YEAR, aYear);
  lCalendar.set(Calendar.MONTH, aMonth-1);
  lCalendar.set(Calendar.DATE, aDay);
  lCalendar.set(Calendar.HOUR_OF_DAY, anHour);
  lCalendar.set(Calendar.MINUTE, aMinute);
  lCalendar.set(Calendar.SECOND, aSecond);
  lCalendar.set(Calendar.MILLISECOND, 0);
  constructor(lCalendar.Time);
end;

constructor DateTime(aYear: Integer; aMonth: Integer; aDay: Integer; anHour: Integer; aMinute: Integer);
begin
  constructor(aYear, aMonth, aDay, anHour, aMinute, 0);
end;

constructor DateTime(aYear: Integer; aMonth: Integer; aDay: Integer);
begin
  constructor(aYear, aMonth, aDay, 0, 0, 0);
end;

constructor DateTime(aDate: Date);
begin
  fDate := aDate;
  fCalendar.Time := fDate;
end;

method DateTime.InternalGetDate: DateTime;
begin
  var lCalendar := Calendar.Instance;
  lCalendar.Time := fDate;
  lCalendar.set(Calendar.HOUR_OF_DAY, 0);
  lCalendar.set(Calendar.MINUTE, 0);
  lCalendar.set(Calendar.SECOND, 0);
  lCalendar.set(Calendar.MILLISECOND, 0);
  exit new DateTime(lCalendar.Time);
end;

method DateTime.AddDays(Value: Integer): DateTime;
begin
  exit new DateTime(AddComponent(Calendar.DATE, Value).Time);
end;

method DateTime.AddHours(Value: Integer): DateTime;
begin
  exit new DateTime(AddComponent(Calendar.HOUR_OF_DAY, Value).Time);
end;

method DateTime.AddMilliseconds(Value: Integer): DateTime;
begin
  exit new DateTime(AddComponent(Calendar.MILLISECOND, Value).Time);
end;

method DateTime.AddMinutes(Value: Integer): DateTime;
begin
  exit new DateTime(AddComponent(Calendar.MINUTE, Value).Time);
end;

method DateTime.AddMonths(Value: Integer): DateTime;
begin
  exit new DateTime(AddComponent(Calendar.MONTH, Value).Time);
end;

method DateTime.AddSeconds(Value: Integer): DateTime;
begin
  exit new DateTime(AddComponent(Calendar.SECOND, Value).Time);
end;

method DateTime.AddYears(Value: Integer): DateTime;
begin
  exit new DateTime(AddComponent(Calendar.YEAR, Value).Time);
end;

method DateTime.AddComponent(Component: Integer; Value: Integer): Calendar;
begin
  result := Calendar.Instance;
  result.Time := fDate;
  result.add(Component, Value);
end;

method DateTime.CompareTo(Value: DateTime): Integer;
begin
  exit fDate.compareTo(Value.fDate);
end;

method DateTime.ToString: java.lang.String;
begin
  exit ToString("{dd}/{MM}/{yyyy} {hh}:{mm}:{ss}");
end;

method DateTime.ToString(Format: String): String;
begin
  exit ToString(Format, nil);
end;

method DateTime.ToString(Format: String; Culture: String): String;
begin
  var Formatter: java.text.SimpleDateFormat;

  if String.IsNullOrEmpty(Culture) then
    Formatter := new java.text.SimpleDateFormat(DateFormater.Format(Format))
  else    
    Formatter := new java.text.SimpleDateFormat(DateFormater.Format(Format), RemObjects.Oxygene.Sugar.Cooper.LocaleUtils.ForLanguageTag(Culture));
    
  exit Formatter.format(fDate);
end;
{$ELSEIF NOUGAT}
method DateTime.init: id;
begin  
  fDate := new NSDate();
  result := inherited;
end;

method DateTime.initWithDate(aDate: NSDate): id;
begin
  fDate := aDate;
  result := self;
end;

constructor DateTime(aYear: Integer; aMonth: Integer; aDay: Integer);
begin
  constructor(aYear, aMonth, aDay, 0, 0, 0);
end;

constructor DateTime(aYear: Integer; aMonth: Integer; aDay: Integer; anHour: Integer; aMinute: Integer);
begin
  constructor(aYear, aMonth, aDay, aDay, anHour, 0);
end;

constructor DateTime(aYear: Integer; aMonth: Integer; aDay: Integer; anHour: Integer; aMinute: Integer; aSecond: Integer);
begin
  var Components: NSDateComponents := new NSDateComponents();  
  Components.setYear(aYear);
  Components.setMonth(aMonth);
  Components.setDay(aDay);
  Components.setHour(anHour);
  Components.setMinute(aMinute);
  Components.setSecond(aSecond);
  exit new DateTime withDate(fCalendar.dateFromComponents(Components));
end;

method DateTime.AddDays(Value: Integer): DateTime;
begin
  var Component: NSDateComponents := new NSDateComponents();  
  Component.setDay(Value);
  exit new DateTime withDate(fCalendar.dateByAddingComponents(Component) toDate(fDate) options(0));  
end;

method DateTime.AddHours(Value: Integer): DateTime;
begin
  var Component: NSDateComponents := new NSDateComponents();  
  Component.setHour(Value);
  exit new DateTime withDate(fCalendar.dateByAddingComponents(Component) toDate(fDate) options(0));
end;

method DateTime.AddMilliseconds(Value: Integer): DateTime;
begin
  exit new DateTime withDate(fDate.dateByAddingTimeInterval(Value / 1000));
end;

method DateTime.AddMinutes(Value: Integer): DateTime;
begin
  var Component: NSDateComponents := new NSDateComponents();  
  Component.setMinute(Value);
  exit new DateTime withDate(fCalendar.dateByAddingComponents(Component) toDate(fDate) options(0));
end;

method DateTime.AddMonths(Value: Integer): DateTime;
begin
  var Component: NSDateComponents := new NSDateComponents();  
  Component.setMonth(Value);
  exit new DateTime withDate(fCalendar.dateByAddingComponents(Component) toDate(fDate) options(0));
end;

method DateTime.AddSeconds(Value: Integer): DateTime;
begin
 exit new DateTime withDate(fDate.dateByAddingTimeInterval(Value / 1000));
end;

method DateTime.AddYears(Value: Integer): DateTime;
begin
  var Component: NSDateComponents := new NSDateComponents();  
  Component.setYear(Value);
  exit new DateTime withDate(fCalendar.dateByAddingComponents(Component) toDate(fDate) options(0));
end;

method DateTime.CompareTo(Value: DateTime): Integer;
begin
  exit fDate.compare(Value.fDate);
end;

method DateTime.ToString(Format: String): String;
begin
  exit ToString(Format, nil);
end;

method DateTime.ToString(Format: String; Culture: String): String;
begin
  var Formatter: NSDateFormatter := new NSDateFormatter();

  if not String.IsNullOrEmpty(Culture) then begin
    var Locale := new NSLocale withLocaleIdentifier(Culture);
    Formatter.locale := Locale;
  end;

  Formatter.setDateFormat(DateFormater.Format(Format));
  exit Formatter.stringFromDate(fDate);
end;

method DateTime.FormatWithStyle(DateStyle, TimeStyle: NSDateFormatterStyle): String;
begin
  var lFormater: NSDateFormatter := new NSDateFormatter();
  lFormater.setDateStyle(DateStyle);
  lFormater.setTimeStyle(TimeStyle);
  exit lFormater.stringFromDate(fDate);
end;

method DateTime.GetComponent(Component: NSCalendarUnit): Integer;
begin
  var lComponents := fCalendar.components(Component) fromDate(fDate);
  case Component of
    NSCalendarUnit.NSDayCalendarUnit: exit lComponents.day;
    NSCalendarUnit.NSHourCalendarUnit: exit lComponents.hour;
    NSCalendarUnit.NSMinuteCalendarUnit: exit lComponents.minute;
    NSCalendarUnit.NSMonthCalendarUnit: exit lComponents.month;
    NSCalendarUnit.NSSecondCalendarUnit: exit lComponents.second;
    NSCalendarUnit.NSYearCalendarUnit: exit lComponents.year;
  end;
end;

method DateTime.InternalGetDate: DateTime;
begin
  var lCalendar: NSCalendar := NSCalendar.currentCalendar;
  var lDate: NSDate := new NSDate();
  var lComponents := lCalendar.components(NSCalendarUnit.NSYearCalendarUnit or 
    NSCalendarUnit.NSMonthCalendarUnit or NSCalendarUnit.NSDayCalendarUnit) fromDate(lDate);
  exit new DateTime withDate(lCalendar.dateFromComponents(lComponents));
end;

method DateTime.description: NSString;
begin
  exit ToString("{dd}/{MM}/{yyyy} {hh}:{mm}:{ss}");
end;
{$ENDIF}

end.

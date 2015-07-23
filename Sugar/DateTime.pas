namespace Sugar;

interface

{$IF COOPER}
uses
  java.nio,
  java.util;
{$ELSEIF NOUGAT}
uses
  Foundation;
{$ENDIF}

type
  {$IF ECHOES}[System.Runtime.InteropServices.StructLayout(System.Runtime.InteropServices.LayoutKind.Auto, Size := 1)]{$ENDIF}
  DateTime = public {$IF COOPER}class mapped to java.util.Calendar{$ELSEIF ECHOES}record mapped to System.DateTime{$ELSEIF NOUGAT}class mapped to NSDate{$ENDIF}
  private
  {$IF NOUGAT}
    method GetComponent(Component: NSCalendarUnit): Integer;
    method AdjustDate(Component: NSCalendarUnit; Value: Integer): DateTime;
  {$ENDIF}
  private
    const DEFAULT_FORMAT = "{dd}/{MM}/{yyyy} {hh}:{mm}:{ss}";
  public
    constructor;
    constructor(aYear, aMonth, aDay: Integer);
    constructor(aYear, aMonth, aDay, anHour, aMinute: Integer);
    constructor(aYear, aMonth, aDay, anHour, aMinute, aSecond: Integer);

    method AddDays(Value: Integer): DateTime;
    method AddHours(Value: Integer): DateTime;
    method AddMinutes(Value: Integer): DateTime;
    method AddMonths(Value: Integer): DateTime;
    method AddSeconds(Value: Integer): DateTime;
    method AddYears(Value: Integer): DateTime;

    method CompareTo(Value: DateTime): Integer;
    method ToString(Format: String): String;
    method ToString(Format: String; Culture: String): String;

    {$IF COOPER}
    method ToString: java.lang.String; override;
    {$ELSEIF ECHOES}
    method ToString: System.String; override;
    {$ELSEIF NOUGAT}
    method description: NSString; override;
    {$ENDIF}    
    
    property Hour: Integer read {$IF COOPER}mapped.get(Calendar.HOUR){$ELSEIF ECHOES}mapped.Hour{$ELSEIF NOUGAT}GetComponent(NSCalendarUnit.NSHourCalendarUnit){$ENDIF};
    property Minute: Integer read {$IF COOPER}mapped.get(Calendar.MINUTE){$ELSEIF ECHOES}mapped.Minute{$ELSEIF NOUGAT}GetComponent(NSCalendarUnit.NSMinuteCalendarUnit){$ENDIF};
    property Second: Integer read {$IF COOPER}mapped.get(Calendar.SECOND){$ELSEIF ECHOES}mapped.Second{$ELSEIF NOUGAT}GetComponent(NSCalendarUnit.NSSecondCalendarUnit){$ENDIF};
    property Year: Integer read {$IF COOPER}mapped.get(Calendar.YEAR){$ELSEIF ECHOES}mapped.Year{$ELSEIF NOUGAT}GetComponent(NSCalendarUnit.NSYearCalendarUnit){$ENDIF};
    property Month: Integer read {$IF COOPER}mapped.get(Calendar.MONTH)+1{$ELSEIF ECHOES}mapped.Month{$ELSEIF NOUGAT}GetComponent(NSCalendarUnit.NSMonthCalendarUnit){$ENDIF};    
    property Day: Integer read {$IF COOPER}mapped.get(Calendar.DAY_OF_MONTH){$ELSEIF ECHOES}mapped.Day{$ELSEIF NOUGAT}GetComponent(NSCalendarUnit.NSDayCalendarUnit){$ENDIF};
    property Date: DateTime read {$IF COOPER OR NOUGAT}new DateTime(self.Year, self.Month, self.Day, 0, 0, 0){$ELSEIF ECHOES}mapped.Date{$ENDIF};  
    
    class property Today: DateTime read {$IF COOPER OR NOUGAT}Now.Date{$ELSEIF ECHOES}mapped.Today{$ENDIF};
    class property Now: DateTime read {$IF COOPER OR NOUGAT}new DateTime(){$ELSEIF ECHOES}mapped.Now{$ENDIF};    
  end;

implementation

constructor DateTime;
begin
  {$IF COOPER}
  exit Calendar.Instance;
  {$ELSEIF ECHOES}
  exit new System.DateTime;
  {$ELSEIF NOUGAT}
  exit new NSDate;
  {$ENDIF}
end;

constructor DateTime(aYear: Integer; aMonth: Integer; aDay: Integer);
begin
  {$IF COOPER OR NOUGAT}
  constructor(aYear, aMonth, aDay, 0, 0, 0);
  {$ELSEIF ECHOES}
  exit new System.DateTime(aYear, aMonth, aDay);
  {$ENDIF}
end;

constructor DateTime(aYear: Integer; aMonth: Integer; aDay: Integer; anHour: Integer; aMinute: Integer);
begin
  {$IF COOPER OR NOUGAT}
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
  {$ELSEIF NOUGAT}
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

method DateTime.AddDays(Value: Integer): DateTime;
begin
  {$IF COOPER}
  mapped.add(Calendar.DATE, Value);
  exit mapped;
  {$ELSEIF ECHOES}
  exit mapped.AddDays(Value);
  {$ELSEIF NOUGAT}
  exit AdjustDate(NSCalendarUnit.NSDayCalendarUnit, Value);
  {$ENDIF}
end;

method DateTime.AddHours(Value: Integer): DateTime;
begin
  {$IF COOPER}
  mapped.add(Calendar.HOUR, Value);
  exit mapped;
  {$ELSEIF ECHOES}
  exit mapped.AddHours(Value);
  {$ELSEIF NOUGAT}
  exit AdjustDate(NSCalendarUnit.NSHourCalendarUnit, Value);
  {$ENDIF}
end;

method DateTime.AddMinutes(Value: Integer): DateTime;
begin
  {$IF COOPER}
  mapped.add(Calendar.MINUTE, Value);
  exit mapped;
  {$ELSEIF ECHOES}
  exit mapped.AddMinutes(Value);
  {$ELSEIF NOUGAT}
  exit AdjustDate(NSCalendarUnit.NSMinuteCalendarUnit, Value);
  {$ENDIF}
end;

method DateTime.AddMonths(Value: Integer): DateTime;
begin
  {$IF COOPER}
  mapped.add(Calendar.MONTH, Value);
  exit mapped;
  {$ELSEIF ECHOES}
  exit mapped.AddMonths(Value);
  {$ELSEIF NOUGAT}
  exit AdjustDate(NSCalendarUnit.NSMonthCalendarUnit, Value);
  {$ENDIF}
end;

method DateTime.AddSeconds(Value: Integer): DateTime;
begin
  {$IF COOPER}
  mapped.add(Calendar.SECOND, Value);
  exit mapped;
  {$ELSEIF ECHOES}
  exit mapped.AddSeconds(Value);
  {$ELSEIF NOUGAT}
  exit AdjustDate(NSCalendarUnit.NSSecondCalendarUnit, Value);
  {$ENDIF}
end;

method DateTime.AddYears(Value: Integer): DateTime;
begin
  {$IF COOPER}
  mapped.add(Calendar.YEAR, Value);
  exit mapped;
  {$ELSEIF ECHOES}
  exit mapped.AddYears(Value);
  {$ELSEIF NOUGAT}
  exit AdjustDate(NSCalendarUnit.NSYearCalendarUnit, Value);
  {$ENDIF}
end;

method DateTime.CompareTo(Value: DateTime): Integer;
begin
  {$IF COOPER}
  exit mapped.compareTo(new DateTime(Value.Year, Value.Month, Value.Day, Value.Hour, Value.Minute, Value.Second));
  {$ELSEIF ECHOES}
  exit mapped.CompareTo(Value);
  {$ELSEIF NOUGAT}
  exit mapped.compare(new DateTime(Value.Year, Value.Month, Value.Day, Value.Hour, Value.Minute, Value.Second));
  {$ENDIF}
end;

method DateTime.ToString(Format: String): String;
begin
  exit ToString(Format, nil);
end;

method DateTime.ToString(Format: String; Culture: String): String;
begin
  {$IF COOPER}
  var Formatter: java.text.SimpleDateFormat;

  if String.IsNullOrEmpty(Culture) then
    Formatter := new java.text.SimpleDateFormat(DateFormatter.Format(Format))
  else    
    Formatter := new java.text.SimpleDateFormat(DateFormatter.Format(Format), Sugar.Cooper.LocaleUtils.ForLanguageTag(Culture));
    
  exit Formatter.format(mapped.Time);
  {$ELSEIF ECHOES}
  if Format = "" then
    exit "";

  if String.IsNullOrEmpty(Culture) then
    exit mapped.ToString(DateFormatter.Format(Format))
  else
    exit mapped.ToString(DateFormatter.Format(Format), new System.Globalization.CultureInfo(Culture));
  {$ELSEIF NOUGAT}
  var Formatter: NSDateFormatter := new NSDateFormatter();

  if not String.IsNullOrEmpty(Culture) then begin
    var Locale := new NSLocale withLocaleIdentifier(Culture);
    Formatter.locale := Locale;
  end;

  Formatter.setDateFormat(DateFormatter.Format(Format));
  exit Formatter.stringFromDate(mapped);
  {$ENDIF}
end;

{$IF COOPER}
method DateTime.ToString: java.lang.String;
begin
  exit ToString(DEFAULT_FORMAT);
end;
{$ELSEIF ECHOES}
method DateTime.ToString: System.String;
begin
  exit ToString(DEFAULT_FORMAT);
end;
{$ELSEIF NOUGAT}
method DateTime.AdjustDate(Component: NSCalendarUnit; Value: Integer): DateTime;
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
  exit lCalendar.dateByAddingComponents(Components) toDate(mapped) options(0);  
end;

method DateTime.description: NSString;
begin
  exit ToString(DEFAULT_FORMAT);
end;

method DateTime.GetComponent(Component: NSCalendarUnit): Integer;
begin
  var lComponents := NSCalendar.currentCalendar().components(Component) fromDate(mapped);
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

end.

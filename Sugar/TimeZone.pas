namespace Sugar;

interface

type
  TimeZone = public class mapped to {$IFDEF ECHOES}System.TimeZoneInfo{$ELSEIF TOFFEE}NSTimeZone{$ELSEIF COOPER}java.util.TimeZone{$ENDIF}
  private
    class method get_LocalTimeZone: not nullable TimeZone; 
    class method get_UtcTimeZone: not nullable TimeZone;
    class method get_TimeZoneWithAbreviation(aAbbreviation: String): nullable TimeZone;
    class method get_TimeZoneWithName(aName: String): nullable TimeZone;
    class method get_TimeZoneNames: not nullable sequence of String;
  protected
  public
    class property Local: not nullable TimeZone read get_LocalTimeZone;
    class property Utc: not nullable TimeZone read get_UtcTimeZone;
    //class property TimeZone[aAbbreviation: String]: nullable TimeZone read get_TimeZoneWithAbreviation;
    class property TimeZoneByName[aName: String]: nullable TimeZone read get_TimeZoneWithName;
    class property TimeZoneNames: not nullable sequence of String read get_TimeZoneNames;
  end;

implementation

{$IF ECHOES}
uses
  System.Linq;
{$ENDIF}

class method TimeZone.get_TimeZoneNames: not nullable sequence of String;
begin
  {$IF COOPER}
  result := java.util.TimeZone.getAvailableIDs() as not nullable;
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  // Windows Phone 8.1 and Windows 8.1 do not expose any managed API for enumerating TimeZones
  raise new NotSupportedException();
  {$ELSEIF ECHOES}
  result := System.TimeZoneInfo.GetSystemTimeZones().Select(tz -> tz.Id) as not nullable;
  {$ELSEIF TOFFEE}
  result := NSTimeZone.knownTimeZoneNames as not nullable;
  {$ENDIF}
end;

class method TimeZone.get_TimeZoneWithAbreviation(aAbbreviation: String): nullable TimeZone;
begin
  {$IF COOPER}
  result := java.util.TimeZone.getTimeZone(aAbbreviation);
  {$ELSEIF ECHOES}
   raise new NotSupportedException();
  {$ELSEIF TOFFEE}
  result := NSTimeZone.timeZoneWithAbbreviation(aAbbreviation);
  {$ENDIF}
end;

class method TimeZone.get_TimeZoneWithName(aName: String): nullable TimeZone;
begin
  {$IF COOPER}
  result := java.util.TimeZone.getTimeZone(aName);
  {$ELSEIF WINDOWS_PHONE OR NETFX_CORE}
  // Windows Phone 8.1 and Windows 8.1 do not expose any managed API for this
  raise new NotSupportedException();
  {$ELSEIF ECHOES}
  result := System.TimeZoneInfo.FindSystemTimeZoneById(aName);
  {$ELSEIF TOFFEE}
  result := NSTimeZone.timeZoneWithName(aName);
  {$ENDIF}
end;

class method TimeZone.get_LocalTimeZone: not nullable TimeZone;
begin
  {$IF COOPER}
  result := java.util.TimeZone.getDefault() as not nullable;
  {$ELSEIF ECHOES}
  result := System.TimeZoneInfo.Local as not nullable;
  {$ELSEIF TOFFEE}
  result := NSTimeZone.localTimeZone as not nullable;
  {$ENDIF}
end;

class method TimeZone.get_UtcTimeZone: not nullable TimeZone; 
begin
  {$IF COOPER}
  result := java.util.TimeZone.getTimeZone("UTC") as not nullable;
  {$ELSEIF ECHOES}
  result := System.TimeZoneInfo.Utc as not nullable;
  {$ELSEIF TOFFEE}
  result := NSTimeZone.timeZoneWithAbbreviation("UTC") as not nullable;
  {$ENDIF}
end;


end.

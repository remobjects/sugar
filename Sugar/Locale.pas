namespace Sugar;

interface

type
  Locale = public class mapped to {$IF ECHOES}System.Globalization.CultureInfo{$ELSEIF COOPER}java.util.Locale{$ELSEIF TOFFEE}Foundation.NSLocale{$ENDIF}
  private
  protected
  public
    {$IF COOPER}
    class property Invariant: Locale read java.util.Locale.US;
    class property Current: Locale read java.util.Locale.Default;
    {$ELSEIF ECHOES}
    class property Invariant: Locale read System.Globalization.CultureInfo.InvariantCulture;
    class property Current: Locale read System.Globalization.CultureInfo.CurrentCulture;
    {$ELSEIF TOFFEE}
    class property Invariant: Locale read NSLocale.systemLocale;
    class property Current: Locale read NSLocale.currentLocale;
    {$ENDIF}
  end;

implementation

end.

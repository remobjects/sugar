namespace RemObjects.Oxygene.Sugar;

interface

type
  {$IF ECHOES}
    {$IF WINDOWS_PHONE}
    Color = public static class
    public
      class method colorWithRGBAPercentage(aRed, aGreen, aBlue, aAlpha: Single): System.Windows.Media.Color;
      class method colorWithRGBA256(aRed, aGreen, aBlue, aAlpha: Byte): System.Windows.Media.Color;
    end;
    {$ELSE}
    Color = public static class
    public
      class method colorWithRGBAPercentage(aRed, aGreen, aBlue, aAlpha: Single): System.Drawing.Color; 
      class method colorWithRGBA256(aRed, aGreen, aBlue, aAlpha: Byte): System.Drawing.Color;
    end;
    {$ENDIF}
  {$ELSEIF COOPER}
  Color = public class mapped to Int64
  public
    class method colorWithRGBAPercentage(aRed, aGreen, aBlue, aAlpha: Single): Color;
    class method colorWithRGBA256(aRed, aGreen, aBlue, aAlpha: Byte): Color;
  end;
  {$ELSE NOUGAT}
    
    {$IF TARGET_OS_IPHONE}
    Color = public class mapped to UIKit.UIColor
    public
      class method colorWithRGBAPercentage(aRed, aGreen, aBlue, aAlpha: Single): Color; mapped to colorWithRed(aRed) green(aGreen) blue(aBlue) alpha(aAlpha);
      class method colorWithRGBA256(aRed, aGreen, aBlue, aAlpha: Byte): Color; mapped to colorWithRed(aRed/256.0) green(aGreen/256.0) blue(aBlue/256.0) alpha(aAlpha/256.0);
    end;
    {$ELSEIF TARGET_OS_MAC}
    Color = public class mapped to AppKit.NSColor
    public
      class method colorWithRGBAPercentage(aRed, aGreen, aBlue, aAlpha: Single): Color; mapped to colorWithCalibratedRed(aRed) green(aGreen) blue(aBlue) alpha(aAlpha);
      class method colorWithRGBA256(aRed, aGreen, aBlue, aAlpha: Byte): Color; mapped to colorWithCalibratedRed(aRed/256.0) green(aGreen/256.0) blue(aBlue/256.0) alpha(aAlpha/256.0);
    end;
    {$ENDIF}
  {$ENDIF}

implementation

{$IF ECHOES}
class method Color.colorWithRGBAPercentage(aRed: Single; aGreen: Single; aBlue: Single; aAlpha: Single): {$IF WINDOWS_PHONE}System.Windows.Media.Color{$ELSE}System.Drawing.Color{$ENDIF};
begin
  result := {$IF WINDOWS_PHONE}System.Windows.Media.Color{$ELSE}System.Drawing.Color{$ENDIF}.FromArgb(aAlpha*256 as Int32, aRed*256 as Int32, aGreen*256 as Int32, aBlue*256 as Int32);
end;

class method Color.colorWithRGBA256(aRed: Byte; aGreen: Byte; aBlue: Byte; aAlpha: Byte): {$IF WINDOWS_PHONE}System.Windows.Media.Color{$ELSE}System.Drawing.Color{$ENDIF};
begin
  result := {$IF WINDOWS_PHONE}System.Windows.Media.Color{$ELSE}System.Drawing.Color{$ENDIF}.FromArgb(aAlpha, aRed, aGreen, aBlue);
end;

{$ELSEIF COOPER}
class method Color.colorWithRGBAPercentage(aRed: Single; aGreen: Single; aBlue: Single; aAlpha: Single): Color;
begin
  result := colorWithRGBA256(aRed*256 as Byte, aGreen*256 as Byte, aBlue*256 as Byte, aAlpha*256 as Byte);
end;

class method Color.colorWithRGBA256(aRed: Byte; aGreen: Byte; aBlue: Byte; aAlpha: Byte): Color;
begin
  result := (aAlpha shl 24) and (aRed shl 16) and (aGreen shl 8) and (aBlue) as Color;
end;
{$ENDIF}

end.

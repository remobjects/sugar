namespace RemObjects.Oxygene.Legacy.Echoes;

interface

type
  OneBasedString = public class mapped to String
  private
    method get_OneBasedCharacters(aIndex: Int32): Char;
  protected
  public
    property OneBasedCharacters[aIndex: Int32]: Char read get_OneBasedCharacters; default;
  end;
  
implementation

method OneBasedString.get_OneBasedCharacters(aIndex: Int32): Char;
begin
  {$IF ECHOES}
  result := mapped.Chars[aIndex-1];
  {$ENDIF}
  {$IF COOPER}
  result := mapped.charAt(aIndex-1);
  {$ENDIF}
  {$IF NOUGAT}
  result := mapped.characterAtIndex(aIndex-1);
  {$ENDIF}

  // result := mapped[aIndex-1]; // i dint believe this works safely yet. needs review
end;

end.

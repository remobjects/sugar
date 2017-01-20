namespace Sugar.RegularExpressions;

interface

type
  &Group = public class
  protected
    fLength: Integer;
    fStart: Integer;
    fText: String;
  public
    constructor(aStart: Integer; aLength: Integer; aText: String);

    property &End: Integer read fStart + fLength - 1;
    property Length: Integer read fLength;
    property Start: Integer read fStart;
    property Text: String read fText;
  end;

implementation

constructor &Group(aStart: Integer; aLength: Integer; aText: String);
begin
  fLength := aLength;
  fStart := aStart;
  fText := aText;
end;

end.
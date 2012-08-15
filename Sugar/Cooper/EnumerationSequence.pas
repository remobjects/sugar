namespace RemObjects.Oxygene.Sugar;

interface

{$IFNDEF COOPER}
{$ERROR This file is meant to be built for Cooper only }
{$ENDIF}

type
  EnumerationSequence<T> = assembly class(sequence of T)
  private
    fEnumeration: java.util.Enumeration<T>;
  assembly
    constructor(aEnumeration: java.util.Enumeration<T>);
  public
     method &iterator: java.util.&Iterator<T>; iterator;
  end;

implementation

constructor EnumerationSequence<T>(aEnumeration: java.util.Enumeration<T>);
begin
  fEnumeration := aEnumeration;
end;

method EnumerationSequence<T>.&iterator: java.util.&Iterator<T>;
begin
  while fEnumeration.hasMoreElements do yield fEnumeration.nextElement;
end;

end.

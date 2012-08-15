namespace RemObjects.Oxygene.Legacy;

{$HIDE W0} // sometimes case differs between .NET and Java; no sense needlessly IFDEF'ing that

interface

// all methods in this module ar eone-based, as they are for Delphi compatibility.

method &Copy(aString: String; aStart, aLength: Int32): String;
method Pos(aSubString: String; aString: String): Int32;

implementation

method Pos(aSubString: String; aString: String): Int32;
begin
  result := aString:IndexOf(aSubString) + 1;
end;

method &Copy(aString: String; aStart: Int32; aLength: Int32): String;
begin
  if not assigned(aString) then exit ''; 

  // Delphi's copy() handes lenthds that exceed the string, and returns whats there.
  var l := aString.Length;
  if (aStart-1)+aLength > l then aLength := l-(aStart+1); 
  
  result := aString.Substring(aStart-1, aLength);
end;

end.

namespace RemObjects.Oxygene.Legacy;

{$HIDE W0} //supress case-mismatch errors

interface

uses RemObjects.Oxygene.Sugar;

// all methods in this module are one-based, as they are for Delphi compatibility.

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

  // Delphi's copy() handels lenths that exceed the string, and returns what's there. 
  // .NET and Sugar's SubString would throw an exception, so we need to account for that.
  var l := aString.Length;
  if (aStart-1)+aLength > l then aLength := l-(aStart+1); 
  
  result := aString.Substring(aStart-1, aLength);
end;

end.

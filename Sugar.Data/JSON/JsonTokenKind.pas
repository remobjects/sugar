namespace Sugar.Data.JSON;

interface

type
  JsonTokenKind = public enum(
    BOF,
    EOF, 
    Whitespace, 
    String, 
    Number, 
    Null, 
    &True, 
    &False, 
    ArrayStart, 
    ArrayEnd, 
    ObjectStart, 
    ObjectEnd, 
    NameSeperator, 
    ValueSeperator, 
    Identifier, 
    SyntaxError);

implementation
end.
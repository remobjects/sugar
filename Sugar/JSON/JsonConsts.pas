namespace Sugar.Json;

interface

type

  JsonConsts = assembly static class
  public
    const VALUE_SEPARATOR: Char = ',';
    const ARRAY_START: Char = '[';
    const ARRAY_END: Char = ']';
    const OBJECT_START: Char = '{';
    const OBJECT_END: Char = '}';
    const NAME_SEPARATOR: Char = ':';
    const STRING_QUOTE: Char = '"';
    const TRUE_VALUE: String = "true";
    const FALSE_VALUE: String = "false";
    const NULL_VALUE: String = "null";
  end;

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
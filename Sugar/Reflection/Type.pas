namespace Sugar.Reflection;

interface

{$IF NOUGAT AND (TARGET_OS_IPHONE OR TARGET_IPHONESIMULATOR)} 
type Protocol = id;
{$ENDIF}

type
  {$IF ECHOES}
  &Type = public class mapped to System.Type
  {$ENDIF}
  {$IF COOPER}
  &Type = public class mapped to java.lang.Class
  {$ENDIF}
  {$IF NOUGAT}
  &Type = public class
  {$ENDIF}
  private
    {$IF NOUGAT}
    fIsID: Boolean;
    fClass: &Class;
    fProtocol: Protocol;
    fSimpleType: String;
    method GetName: String;
    {$ENDIF}
  public
    {$IF ECHOES}
    method GetInterfaces: array of Sugar.Reflection.Type; mapped to GetInterfaces();
    method GetMethods: array of Sugar.Reflection.MethodInfo; mapped to GetMethods();
    property BaseType: Sugar.Reflection.Type read mapped.BaseType; 
    property IsClass: Boolean read mapped.IsClass;
    property IsInterface: Boolean read mapped.IsInterface;
    property IsArray: Boolean read mapped.IsArray;
    property IsEnum: Boolean read mapped.IsEnum;
    property IsValueType: Boolean read mapped.IsValueType;
    {$ENDIF}
    {$IF COOPER}
    method GetInterfaces: array of Sugar.Reflection.Type; mapped to getInterfaces();
    method GetMethods: array of Sugar.Reflection.MethodInfo; mapped to getMethods();
    property BaseType: Sugar.Reflection.Type read mapped.getSuperclass(); 
    property IsClass: Boolean read (not mapped.isInterface()) and (not mapped.isPrimitive());
    property IsInterface: Boolean read mapped.isInterface();
    property IsArray: Boolean read mapped.isArray();
    property IsEnum: Boolean read mapped.isEnum();
    property IsValueType: Boolean read mapped.isPrimitive();
    {$ENDIF}
    {$IF NOUGAT}
    method initWithID: instancetype;
    method initWithClass(aClass: &Class): instancetype;
    method initWithProtocol(aProtocol: id): instancetype;
    method initWithSimpleType(aTypeEncoding: String): instancetype;
    method GetInterfaces: NSArray<Sugar.Reflection.Type>; 
    method GetMethods: NSArray<Sugar.Reflection.MethodInfo>;
    //operator Explicit(aClass: rtl.Class): &Type;
    //operator Explicit(aProtocol: Protocol): &Type;
    property name: String read getName;
    property BaseType: Sugar.Reflection.Type read if IsClass then new &Type withClass(class_getSuperclass(self)); 
    property IsClass: Boolean read assigned(fClass) or fIsID;
    property IsInterface: Boolean read assigned(fProtocol);
    property IsArray: Boolean read false;
    property IsEnum: Boolean read false;
    property IsValueType: Boolean read false;
    {$ENDIF}
  end;

implementation

{$IF NOUGAT}
method &Type.initWithID: instancetype;
begin
  self := inherited init;
  if assigned(self) then begin
    fIsID := true;
  end;
  result := self;
end;

method &Type.initWithClass(aClass: &Class): instancetype;
begin
  self := inherited init;
  if assigned(self) then begin
    fClass := aClass;
  end;
  result := self;
end;

method &Type.initWithProtocol(aProtocol: id): instancetype;
begin
  self := inherited init;
  if assigned(self) then begin
    fprotocol := aProtocol;
  end;
  result := self;
end;

method &Type.initWithSimpleType(aTypeEncoding: String): instancetype;
begin
  self := inherited init;
  if assigned(self) then begin
    fSimpleType := aTypeEncoding;
  end;
  result := self;
end;

method &Type.GetName: String;
begin
  if fIsID then exit ('id');
  if assigned(fClass) then exit fClass.description;
  if assigned(fProtocol) then exit fProtocol.description;
  if assigned(fSimpleType) then begin
    case fSimpleType of
      'c': exit 'char';
      'i': exit 'NSInteger';
      's': exit 'Int16';
      'l': exit 'Int32';
      'q': exit 'Int64';
      'C': exit 'Char';
      'I': exit 'NSUInteger';
      'S': exit 'UInt16';
      'L': exit 'UInt32';
      'Q': exit 'UInt64';
      'f': exit 'Float';
      'd': exit 'Double';
      'B': exit 'Boolean';
      'v': exit 'Void';
      '*': exit 'Char *';
      '@': exit 'id';
      '#': exit 'Class';
      ':': exit 'SEL';
      '?': exit '<Unknown Type>';
    end;
  end;

  // Todo: handle simple types;
end;

method &Type.GetInterfaces: NSArray<Sugar.Reflection.Type>;
begin
end;

method &Type.GetMethods: NSArray<Sugar.Reflection.MethodInfo>;
begin
  var methodInfos: ^rtl.Method;
  var methodCount: UInt32;
  methodInfos := class_copyMethodList(self, var methodCount);
  result := NSMutableArray.arrayWithCapacity(methodCount);
  for i: Int32 := 0 to methodCount-1 do
    NSMutableArray(result).addObject(new Sugar.Reflection.MethodInfo withClass(self) &method(methodInfos[i]));
end;

{$ENDIF}

end.

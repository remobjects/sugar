namespace Sugar.Reflection;

interface

uses
  {$IF NETFX_CORE}System.Reflection,{$ENDIF}
  {$IF ECHOES}System.Linq,{$ENDIF}
  {$IF COOPER}com.remobjects.elements.linq,{$ENDIF}
  Sugar.Collections;

{$IF TOFFEE AND (TARGET_OS_IPHONE OR TARGET_IPHONESIMULATOR)}
type Protocol = id;
{$ENDIF}

type
  {$IF ECHOES}
  &Type = public class mapped to System.Type
  {$ENDIF}
  {$IF COOPER}
  &Type = public class mapped to java.lang.Class
  {$ENDIF}
  {$IF TOFFEE}
  &Type = public class
  {$ENDIF}
  private
    {$IF TOFFEE}
    fIsID: Boolean;
    fClass: &Class;
    fProtocol: Protocol;
    fSimpleType: String;
    method GetName: String;
    method Get_Interfaces: List<Sugar.Reflection.Type>;
    method Get_Methods: List<Sugar.Reflection.MethodInfo>;
    {$ENDIF}
    {$IF NETFX_CORE}
    method Get_Interfaces: List<Sugar.Reflection.Type>;
    method Get_Methods: List<Sugar.Reflection.MethodInfo>;
    {$ENDIF}

  public
    {$IFDEF NETFX_CORE}
    property Interfaces: List<Sugar.Reflection.Type> read Get_Interfaces;
    property Methods: List<Sugar.Reflection.MethodInfo> read Get_Methods;
    property Name: String read mapped.Name;
    property BaseType: Sugar.Reflection.Type read mapped.GetTypeInfo().BaseType;
    property IsClass: Boolean read mapped.GetTypeInfo().IsClass;
    property IsInterface: Boolean read mapped.GetTypeInfo().IsInterface;
    property IsArray: Boolean read mapped.IsArray;
    property IsEnum: Boolean read mapped.GetTypeInfo().IsEnum;
    property IsValueType: Boolean read mapped.GetTypeInfo().IsValueType;
    {$ELSEIF ECHOES}
    property Interfaces: List<Sugar.Reflection.Type> read mapped.GetInterfaces().ToList();
    property Methods: List<Sugar.Reflection.MethodInfo> read mapped.GetMethods().ToList();
    //property Attributes: List<Sugar.Reflection.AttributeInfo> read mapped.().ToList();
    property Name: String read mapped.Name;
    property BaseType: Sugar.Reflection.Type read mapped.BaseType;
    property IsClass: Boolean read mapped.IsClass;
    property IsInterface: Boolean read mapped.IsInterface;
    property IsArray: Boolean read mapped.IsArray;
    property IsEnum: Boolean read mapped.IsEnum;
    property IsValueType: Boolean read mapped.IsValueType;
    {$ENDIF}
    {$IF COOPER}
    property Interfaces: List<Sugar.Reflection.Type> read mapped.getInterfaces().ToList() as List<Sugar.Reflection.Type>;
    property Methods: List<Sugar.Reflection.MethodInfo> read mapped.getMethods().ToList();
    //property Attributes: List<Sugar.Reflection.AttributeInfo> read mapped.().ToList();
    property Name: String read mapped.Name;
    property BaseType: Sugar.Reflection.Type read mapped.getSuperclass();
    property IsClass: Boolean read (not mapped.isInterface()) and (not mapped.isPrimitive());
    property IsInterface: Boolean read mapped.isInterface();
    property IsArray: Boolean read mapped.isArray();
    property IsEnum: Boolean read mapped.isEnum();
    property IsValueType: Boolean read mapped.isPrimitive();
    {$ENDIF}
    {$IF TOFFEE}
    method initWithID: instancetype;
    method initWithClass(aClass: &Class): instancetype;
    method initWithProtocol(aProtocol: id): instancetype;
    method initWithSimpleType(aTypeEncoding: String): instancetype;
    property Interfaces: List<Sugar.Reflection.Type> read Get_Interfaces();
    property Methods: List<Sugar.Reflection.MethodInfo> read Get_Methods();
    //property Attributes: List<Sugar.Reflection.AttributeInfo> read mapped.().ToList();
    //operator Explicit(aClass: rtl.Class): &Type;
    //operator Explicit(aProtocol: Protocol): &Type;
    property Name: String read getName;
    property BaseType: Sugar.Reflection.Type read if IsClass then new &Type withClass(class_getSuperclass(fClass));
    property IsClass: Boolean read assigned(fClass) or fIsID;
    property IsInterface: Boolean read assigned(fProtocol);
    property IsArray: Boolean read false;
    property IsEnum: Boolean read false;
    property IsValueType: Boolean read false;
    {$ENDIF}
  end;

implementation

{$IF TOFFEE}
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
    fProtocol := aProtocol;
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

method &Type.Get_Interfaces: List<Sugar.Reflection.Type>;
begin
end;

method &Type.Get_Methods: List<Sugar.Reflection.MethodInfo>;
begin
  var methodInfos: ^rtl.Method;
  var methodCount: UInt32;
  methodInfos := class_copyMethodList(fClass, var methodCount);
  result := NSMutableArray.arrayWithCapacity(methodCount);
  for i: Int32 := 0 to methodCount-1 do
    NSMutableArray(result).addObject(new Sugar.Reflection.MethodInfo withClass(fClass) &method(methodInfos[i]));
end;

{$ENDIF}


{$IF NETFX_CORE}
method &Type.Get_Interfaces: List<Sugar.Reflection.Type>;
begin
  exit System.Linq.Enumerable.ToArray( mapped.GetTypeInfo().ImplementedInterfaces);
end;

method &Type.Get_Methods: List<Sugar.Reflection.MethodInfo>;
begin
  exit System.Linq.Enumerable.ToArray(System.Linq.Enumerable.OfType<MethodInfo>(mapped.GetTypeInfo().DeclaredMembers));
end;
{$ENDIF}
end.
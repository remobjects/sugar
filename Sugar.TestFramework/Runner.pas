namespace RemObjects.Sugar.TestFramework;
{$HIDE W0}
interface

type
  TestRunner = public static class
  private
    method HandleException(Name: String; Ex: Exception): TestResult;
    {$IF COOPER}
    method ProcessMethod(Obj: Testcase; M: java.lang.reflect.&Method): TestResult;
    {$ELSEIF ECHOES}
    method ProcessMethod(Obj: Testcase; M: System.Reflection.MethodInfo): TestResult;
    {$ELSEIF NOUGAT}
    method ProcessMethod(Obj: Testcase; M: &Method): TestResult;
    {$ENDIF}
  public
    method Run(Test: Testcase): TestcaseResult;
    method RunAll(params Tests: array of Testcase): List<TestcaseResult>;
    {$IF COOPER}
      {$IF ANDROID}
      method RunAll(Context: android.content.Context): List<TestcaseResult>;
      {$ELSE}
      method RunAll(P: Package): List<TestcaseResult>;
      method RunAll(PackageName: String): List<TestcaseResult>;    
      {$ENDIF}
    {$ELSEIF ECHOES}
    method RunAll(Asm: System.Reflection.&Assembly): List<TestcaseResult>;
    method RunAll(Domain: AppDomain): List<TestcaseResult>;
    method RunAll: List<TestcaseResult>;
    {$ELSEIF NOUGAT}
    method RunAll: List<TestcaseResult>;
    {$ENDIF}
  end;

implementation

class method TestRunner.HandleException(Name: String; Ex: Exception): TestResult;
begin
  {$IF COOPER}
  if Ex is java.lang.reflect.InvocationTargetException then
    Ex := Exception(java.lang.reflect.InvocationTargetException(Ex).TargetException);
  {$ELSEIF ECHOES}
  if Ex is System.Reflection.TargetInvocationException then
    Ex := System.Reflection.TargetInvocationException(Ex).InnerException
  else if Ex is System.AggregateException then
    Ex := System.AggregateException(Ex).InnerException;
  {$ENDIF}
  var Message: String := Ex.{$IF NOUGAT}reason{$ELSE}Message{$ENDIF};
  if Message = nil then
  {$IF COOPER}
    Message := Ex.Class.Name;
  {$ELSEIF ECHOES}
    Message := Ex.GetType.FullName;
  {$ELSEIF NOUGAT}
    Message := Foundation.NSString.stringWithUTF8String(class_getName(Ex.class));
  {$ENDIF}

  if Ex is SugarTestException then
    exit new TestResult(Name, true, Message)
  else
    exit new TestResult(Name, true, "<Exception>: "+Message);
end;

{$IF COOPER}
class method TestRunner.ProcessMethod(Obj: Testcase; M: java.lang.reflect.&Method): TestResult;
begin
  try
    //invoke test method
    M.invoke(Obj, nil);
    //test passed
    exit new TestResult(M.Name, false, "");
  except
    on E: Exception do
      exit HandleException(M.Name, E);
  end;
end;

class method TestRunner.Run(Test: Testcase): TestcaseResult;
begin
  var lType := Test.Class;
  var RetVal := new TestcaseResult(lType.SimpleName);

  //setup
  var Setup := method begin
    try
      Test.Setup;
    except
      on E: Exception do 
        RetVal.TestResults.Add(HandleException("Setup", E));
    end;
  end;

  //teardown
  var TearDown := method begin
    try
      Test.TearDown;
    except
      on E: Exception do 
        RetVal.TestResults.Add(HandleException("TearDown", E));
    end;
  end;

  var lMethods := lType.getMethods;
  for lMethod in lMethods do begin
    //we take methods with no parameters
    if lMethod.getParameterTypes.length <> 0 then
      continue;
    //and no return type
    if not lMethod.ReturnType.Name.equals("void") then
      continue;
    //no overriden methods
    if lMethod.DeclaringClass <> lType then
      continue;
    //skip setup/teardown
    if lMethod.Name.equals("Setup") or lMethod.Name.equals("TearDown") then
      continue;

    Setup();
    RetVal.TestResults.Add(ProcessMethod(Test, lMethod));
    TearDown();
  end;

  exit RetVal;
end;
  {$IF ANDROID}
method TestRunner.RunAll(Context: android.content.Context): List<TestcaseResult>;
begin
  result := new List<TestcaseResult>;
  
  if Context = nil then
    exit;

  try
    var Content := new dalvik.system.DexFile(Context.PackageCodePath):entries;

    if Content = nil then
      exit;

    for Item: String in Content do begin
      if (Item <> nil) and (not Item.contains("%")) then begin
        var C := &Class.forName(Item);
        if typeOf(Testcase).isAssignableFrom(C) then begin
          var ctor := C.getConstructor([]);            
          result.Add(Run(Testcase(ctor.newInstance(nil))));
        end;
      end;
    end;

  except
    on E: Exception do begin
      var RetVal := new TestcaseResult(Context.PackageName);
      RetVal.TestResults.Add(HandleException("RunAll", E));
      result.Add(RetVal);
    end;
  end;
end;
  {$ELSE}
method TestRunner.RunAll(P: Package): List<TestcaseResult>;
begin
  result := new List<TestcaseResult>;

  if P = nil then
    exit;
  
  var Loader : ClassLoader := Thread.currentThread.ContextClassLoader;
  var Res := Loader.getResources(P.Name.replace(".", "/"));

  while Res.hasMoreElements do begin
    var item := Res.nextElement;
    var RelPath := P.Name.replace(".", "/");
    var JarPath := Item.Path.replaceFirst("[.]jar[!].*", ".jar").replaceFirst("file:", "");

    try
      var file := new java.util.jar.JarFile(JarPath);

      for entry: java.util.jar.JarEntry in file.entries do begin
        var ClassName: String := nil;
        if (entry.Name.endsWith(".class") and entry.Name.startsWith(RelPath) and (entry.Name.length > (RelPath.length + 1))) then
          ClassName := entry.Name.replace("/", ".").replace("\\", ".").replace(".class", "");

        if (ClassName <> nil) and (not ClassName.contains("$")) then begin
          var C := &Class.forName(ClassName);
          if typeOf(Testcase).isAssignableFrom(C) then begin
            var ctor := C.getConstructor([]);            
            result.Add(Run(Testcase(ctor.newInstance(nil))));
          end;
        end;
      end;      
    except 
      on E: Exception do begin
        var RetVal := new TestcaseResult(P.Name);
        RetVal.TestResults.Add(HandleException("RunAll", E));
        result.Add(RetVal);
      end;
    end;
  end;
end;

method TestRunner.RunAll(PackageName: String): List<TestcaseResult>;
begin
  exit RunAll(Package.Package[PackageName]);
end;
  {$ENDIF}
{$ELSEIF ECHOES}
class method TestRunner.ProcessMethod(Obj: Testcase; M: System.Reflection.MethodInfo): TestResult;
begin
  try
    //invoke test method
    M.Invoke(Obj, nil);
    //test passed
    exit new TestResult(M.Name, false, "");
  except
    on E: Exception do
      exit HandleException(M.Name, E);
  end;
end;

class method TestRunner.Run(Test: Testcase): TestcaseResult;
begin
  var lType := Test.GetType;
  var RetVal := new TestcaseResult(Test.GetType.Name);

  //setup
  var Setup := method begin
    try
      Test.Setup;
    except
      on E: Exception do 
        RetVal.TestResults.Add(HandleException("Setup", E));
    end;
  end;

  //teardown
  var TearDown := method begin
    try
      Test.TearDown;
    except
      on E: Exception do 
        RetVal.TestResults.Add(HandleException("TearDown", E));
    end;
  end;

  //processing all methods
  var lMethods := lType.GetMethods(System.Reflection.BindingFlags.Public or System.Reflection.BindingFlags.Instance); 
  for lMethod in lMethods do begin

    //we take methods with no parameters
    if lMethod.GetParameters.Length <> 0 then
      continue;
    //and no return type
    if not lMethod.ReturnType.Name.Equals("Void") then
      continue;
    //no overriden methods
    if lMethod.DeclaringType <> Test.GetType then
      continue;
    //skip setup/teardown
    if lMethod.Name.Equals("Setup") or lMethod.Name.Equals("TearDown") then
      continue;

    Setup;
    RetVal.TestResults.Add(ProcessMethod(Test, lMethod));
    TearDown;
  end;

  exit RetVal;
end;

class method TestRunner.RunAll(Asm: System.Reflection.Assembly): List<TestcaseResult>;
begin
  result := new List<TestcaseResult>;

  if Asm = nil then
    exit;

  var lTypes := Asm.GetTypes;
  var lTestcaseType := typeOf(Testcase);
  for lType in lTypes do begin
    if lTestcaseType.IsAssignableFrom(lType) and (not lType.Equals(lTestcaseType)) then begin
      try
        var Instance := Testcase(Asm.CreateInstance(lType.FullName));
        result.AddRange(RunAll(Instance));
      except
        on Ex: Exception do
          HandleException(lType.Name, Ex);
      end;
    end;
  end;
end;

class method TestRunner.RunAll(Domain: AppDomain): List<TestcaseResult>;
begin
  result := new List<TestcaseResult>;

  if Domain = nil then
    exit;

  var lAssemblies := Domain.GetAssemblies;
  for lAssembly in lAssemblies do
    result.AddRange(RunAll(lAssembly));
end;

class method TestRunner.RunAll: List<TestcaseResult>;
begin
  exit RunAll(AppDomain.CurrentDomain);
end;
{$ELSEIF NOUGAT}
class method TestRunner.ProcessMethod(Obj: Testcase; M: &Method): TestResult;
begin
  var MethodSelector := method_getName(M);
  var MethodName: String := String.stringWithUTF8String(sel_getName(MethodSelector));  
  try
    //invoke test method
    var Signature := Obj.methodSignatureForSelector(MethodSelector);
    var Invocation := Foundation.NSInvocation.invocationWithMethodSignature(Signature);
    Invocation.target := Obj;
    Invocation.selector := MethodSelector;
    Invocation.invoke;
    
    //test passed
    exit new TestResult(MethodName, false, "");
  except
    on E: Exception do
      exit HandleException(MethodName, E);
  end;
end;

class method TestRunner.Run(Test: Testcase): TestcaseResult;
begin  
  //Not available due to compiler bug
  var RetVal := new TestcaseResult(Foundation.NSString.stringWithUTF8String(class_getName(Test.class)));

  //setup
  var Setup := method begin
    try
      Test.Setup;
    except
      on E: Exception do 
        RetVal.TestResults.Add(HandleException("Setup", E));
    end;
  end;

  //teardown
  var TearDown := method begin
    try
      Test.TearDown;
    except
      on E: Exception do 
        RetVal.TestResults.Add(HandleException("TearDown", E));
    end;
  end;

  //processing all methods
  var lMethodsCount: UInt32 := 0;
  var lMethods := class_copyMethodList(Test.class, var lMethodsCount);

  for i: Integer := 0 to lMethodsCount - 1 do begin
    var lMethod := lMethods[i];

    //no parameters
    if method_getNumberOfArguments(lMethod) > 2 then
      continue;

    //no return type
    //var buf := method_copyReturnType(lMethod);
    //var Data: String := String.stringWithUTF8String(buf);
    //if Data.caseInsensitiveCompare("v") <> 0 then
    //  continue;

    //not overriden
    var superclass := class_getSuperclass(Test.class);
    if superclass <> nil then begin
      var supermethod := class_getClassMethod(superclass, method_getName(lMethod));
      if supermethod <> nil then
        if lMethod = supermethod then
          continue;
    end;

    //no setup/teardown
    var MethodName: String := String.stringWithUTF8String(sel_getName(method_getName(lMethod)));
    if (MethodName = "Setup") or (MethodName = "TearDown") then
      continue;

    if MethodName.hasPrefix(".") then
      continue;

    Setup;
    RetVal.TestResults.Add(ProcessMethod(Test, lMethod));
    TearDown;
  end;
  

  exit RetVal;
end;

class method TestRunner.RunAll: List<TestcaseResult>;
begin
  result := new List<TestcaseResult>;
  
  var Count := objc_getClassList(nil, 0);
  if Count <= 0 then
    exit;

  var Classes := new unretained &Class[Count];
  Count := objc_getClassList(Classes, Count);

  for i: Integer := 0 to Count - 1 do begin
    var lClass: unretained &Class := Classes[i];
    var Super: &Class := class_getSuperclass(lClass);

    while Super <> nil do begin

      //inherits from Testcase
      if Super = Testcase.class then begin
        var Instance := Foundation.NSClassFromString(class_getName(lClass)).alloc.init;
        result.Add(Run(Instance));
        break;
      end;

      Super := class_getSuperclass(Super);
    end;
  end;
end;
{$ENDIF}

class method TestRunner.RunAll(params Tests: array of Testcase): List<TestcaseResult>;
begin
  result := new List<TestcaseResult>;

  for i: Integer := 0 to length(Tests) - 1 do
    result.Add(Run(Tests[i]));
end;

end.

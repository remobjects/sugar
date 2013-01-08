namespace RemObjects.Oxygene.Sugar;
{$HIDE W0} //supress case-mismatch errors
interface

{$IF COOPER}
uses
  java.util.concurrent;
{$ENDIF}

type
  {$IF COOPER}
  ThreadPool = public static class 
  private
    var fExecutor: ThreadPoolExecutor := new ThreadPoolExecutor(4, 1000, 0, TimeUnit.MILLISECONDS, new LinkedBlockingQueue<Runnable>()); readonly;
  public
    method QueueUserWorkItem(Callback: Runnable);
    method Terminate; //must be called in Java

    property MinThreads: Integer read fExecutor.CorePoolSize write fExecutor.CorePoolSize;
    property MaxThreads: Integer read fExecutor.MaximumPoolSize write fExecutor.MaximumPoolSize;
    property AvailableThreads: Integer read fExecutor.MaximumPoolSize - fExecutor.ActiveCount;
  end;
  {$ELSEIF ECHOES}
  ThreadPool = public class mapped to System.Threading.ThreadPool
  private
    class method GetMinThreads: Integer;
    class method GetMaxThreads: Integer;
    class method SetMinThreads(Value: Integer);
    class method SetMaxThreads(Value: Integer);
    class method GetAvailableThreads: Integer;
  public
    class method QueueUserWorkItem(Callback: System.Threading.WaitCallback); mapped to QueueUserWorkItem(Callback);
    class property MinThreads: Integer read GetMinThreads write SetMinThreads;
    class property MaxThreads: Integer read GetMaxThreads write SetMaxThreads;
    class property AvailableThreads: Integer read GetAvailableThreads;
  end;
  {$ENDIF}
  {$IF NOUGAT}
  ThreadPool = public static class
  end;
  {$ENDIF}

implementation

{$IF COOPER}
class method ThreadPool.QueueUserWorkItem(Callback: Runnable);
begin
  fExecutor.execute(Callback);
end;

class method ThreadPool.Terminate;
begin
  fExecutor.shutdown;
end;

{$ELSEIF ECHOES}
class method ThreadPool.GetMinThreads: Integer;
begin
  var WorkerThreads: Integer;
  var IOThreads: Integer;
  System.Threading.ThreadPool.GetMinThreads(out WorkerThreads, out IOThreads);
  exit WorkerThreads;
end;

class method ThreadPool.GetMaxThreads: Integer;
begin
  var WorkerThreads: Integer;
  var IOThreads: Integer;
  System.Threading.ThreadPool.GetMaxThreads(out WorkerThreads, out IOThreads);
  exit WorkerThreads;
end;

class method ThreadPool.GetAvailableThreads: Integer;
begin
  var WorkerThreads: Integer;
  var IOThreads: Integer;
  System.Threading.ThreadPool.GetAvailableThreads(out WorkerThreads, out IOThreads);
  exit WorkerThreads;
end;

class method ThreadPool.SetMinThreads(Value: Integer);
begin
  var WorkerThreads: Integer;
  var IOThreads: Integer;
  System.Threading.ThreadPool.GetMinThreads(out WorkerThreads, out IOThreads);
  System.Threading.ThreadPool.SetMinThreads(Value, IOThreads);
end;

class method ThreadPool.SetMaxThreads(Value: Integer);
begin
  var WorkerThreads: Integer;
  var IOThreads: Integer;
  System.Threading.ThreadPool.GetMaxThreads(out WorkerThreads, out IOThreads);
  System.Threading.ThreadPool.SetMaxThreads(Value, IOThreads);
end;
{$ENDIF}

end.

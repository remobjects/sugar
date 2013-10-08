namespace sugar.cooper.android.test;

interface

uses
  java.util,
  android.app,
  android.content,
  android.os,
  android.util,
  android.view,
  remobjects.oxygene.sugar.testframework,
  Sugar.Test,
  android.widget;

type
  MainActivity = public class(Activity)
  private
    class property Instance: MainActivity read write;
  public
    method onCreate(savedInstanceState: Bundle); override;
    class method CurrentContext: Context;
  end;

implementation

method MainActivity.onCreate(savedInstanceState: Bundle);
begin
  inherited;
  Instance := self;
  ContentView := R.layout.main;

  var results := TestRunner.RunAll(self);
  var output := new StringPrinter(results);

  var MaxLogSize := 1000;

  for i: Integer := 0 to output.Result.Length / MaxLogSize do begin
    var Start := i * MaxLogSize;
    var Count := if Start + MaxLogSize > output.Result.Length then output.Result.Length - Start else MaxLogSize;
    Log.i("Sugar.Test", output.Result.Substring(Start, Count));
  end;

  self.finish;
end;

class method MainActivity.CurrentContext: Context;
begin
  exit Instance;
end;

end.

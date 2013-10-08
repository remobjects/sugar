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

  var results := TestRunner.RunAll([new BinaryTest, new DateTimeTest, new DictionaryTest, new ExtensionsTest, new GuidTest, new HashSetTest,
                                    new ListTest, new QueueTest, new StackTest, new StringTest, new StringBuilderTest, new UserSettingsTest]);//RunAll("sugar.test");
  var output := new StringPrinter(results);

  var MaxLogSize := 1000;

  for i: Integer := 0 to output.Result.Length / MaxLogSize do begin
    var Start := i * MaxLogSize;
    var Count := if Start + MaxLogSize > output.Result.Length then output.Result.Length - Start else MaxLogSize;
    Log.v("Sugar.Test", output.Result.Substring(Start, Count));
  end;
end;

class method MainActivity.CurrentContext: Context;
begin
  exit Instance;
end;

end.

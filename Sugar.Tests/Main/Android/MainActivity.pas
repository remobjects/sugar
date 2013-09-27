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
  public
    method onCreate(savedInstanceState: Bundle); override;
  end;

implementation

method MainActivity.onCreate(savedInstanceState: Bundle);
begin
  inherited;
  ContentView := R.layout.main;

  var results := TestRunner.RunAll(new StringTest, new BinaryTest, new DateTimeTest, new GuidTest, new StringBuilderTest, new StackTest, new HashSetTest, new ListTest);
  var output := new StringPrinter(results);

  var MaxLogSize := 1000;

  for i: Integer := 0 to output.Result.Length / MaxLogSize do begin
    var Start := i * MaxLogSize;
    var Count := if Start + MaxLogSize > output.Result.Length then output.Result.Length - Start else MaxLogSize;
    Log.v("Sugar.Test", output.Result.Substring(Start, Count));
  end;
end;

end.

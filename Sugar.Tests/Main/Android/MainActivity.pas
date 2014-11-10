namespace sugar.cooper.android.test;

interface

uses
  java.util,
  android.app,
  android.content,
  android.os,
  android.util,
  android.view,
  RemObjects.Elements.eunit,
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
  Sugar.Environment.ApplicationContext := self.ApplicationContext;
  ContentView := R.layout.main;
  
  Runner.RunAsync(Discovery.FromContext(self), tested -> begin
    var Writer := new StringWriter(Tested);

      Writer.WriteFull;
      Writer.WriteLine("====================================");
      Writer.WriteSummary;
      var MaxLogSize := 1000;
      var Output := Writer.Output;

      for i: Integer := 0 to Output.Length / MaxLogSize do begin
        var Start := i * MaxLogSize;
        var Count := if Start + MaxLogSize > Output.Length then Output.Length - Start else MaxLogSize;
        Log.i("Sugar.Test", Output.Substring(Start, Count));
      end;

      self.finish;
  end);
end;


end.

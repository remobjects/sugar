namespace Sugar.Echoes.WP8.Test;

interface

uses
  System,
  System.Collections.Generic,
  System.Linq,
  System.Net,
  System.Windows,
  System.Windows.Controls,
  System.Windows.Media,
  System.Windows.Navigation,
  Microsoft.Phone.Controls,
  Microsoft.Phone.Shell,
  Sugar.Echoes.WP8.Test.Resources;

type
  MainPage = public partial class(PhoneApplicationPage)
  public
    constructor;
  private
    method RunTests;
  end;

implementation

constructor MainPage;
begin
  InitializeComponent();
  RunTests;
end;

method MainPage.RunTests;
begin
  var Results := RemObjects.Oxygene.Sugar.TestFramework.TestRunner.RunAll;
  var Output := new Sugar.Test.StringPrinter(Results);
  System.Diagnostics.Debug.WriteLine(Output.Result);
end;

end.
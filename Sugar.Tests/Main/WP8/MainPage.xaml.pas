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
  RemObjects.Elements.EUnit,
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
  Runner.RunAsync(Discovery.FromAppDomain(AppDomain.CurrentDomain), tested -> begin
    var Writer := new StringWriter(Tested);

      Writer.WriteFull;
      Writer.WriteLine("====================================");
      Writer.WriteSummary;
      System.Diagnostics.Debug.WriteLine(Writer.Output);
      Application.Current.Terminate;      
  end);
end;

end.
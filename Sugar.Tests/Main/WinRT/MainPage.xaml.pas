namespace MetroApplication1;

interface

uses
  System,
  System.Collections.Generic,
  System.IO,
  System.Linq,
  Windows.Foundation,
  Windows.Foundation.Collections,
  Windows.UI.Xaml,
  Windows.UI.Xaml.Controls,
  Windows.UI.Xaml.Controls.Primitives,
  Windows.UI.Xaml.Data,
  Windows.UI.Xaml.Input,
  Windows.UI.Xaml.Media,
  Windows.UI.Xaml.Navigation;

// The Blank Page item template is documented at http://go.microsoft.com/fwlink/?LinkId=234238

/// <summary>
/// An empty page that can be used on its own or navigated to within a Frame.
/// </summary>
type
  MainPage = partial class(Page)
  public
    constructor ;

  /// <summary>
  /// Invoked when this page is about to be displayed in a Frame.
  /// </summary>
  /// <param name="e">Event data that describes how this page was reached.  The Parameter
  /// property is typically used to configure the page.</param>
  protected
    method OnNavigatedTo(e: NavigationEventArgs); override;
  end;

implementation

constructor MainPage;
begin
  self.InitializeComponent()
end;

method MainPage.OnNavigatedTo(e: NavigationEventArgs);
begin
end;

end.

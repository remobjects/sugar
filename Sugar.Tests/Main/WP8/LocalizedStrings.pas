namespace Sugar.Echoes.WP8.Test;

interface

uses
  Sugar.Echoes.WP8.Test.Resources;

type
  /// <summary>
  /// Provides access to string resources.
  /// </summary>
  LocalizedStrings = public class
  private
    class var _localizedResources: AppResources := new AppResources();

  public
    property LocalizedResources: AppResources read _localizedResources;
  end;

implementation

end.
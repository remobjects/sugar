namespace;

interface

uses System.Reflection, 
  System.Runtime.CompilerServices,
  System.Runtime.InteropServices;

[assembly: AssemblyTitle('RemObjects Sugar')]
[assembly: AssemblyDescription('RemObjects Sugar Corss-PLatform Library')]
[assembly: AssemblyCompany('RemObjects Software')]
[assembly: AssemblyProduct('')]
[assembly: AssemblyCopyright('RemObjects Software')]
[assembly: AssemblyTrademark('')]
[assembly: AssemblyCulture('')]
[assembly: AssemblyVersion('1.0.0.1')]
[assembly: ComVisible(false)]

[assembly: AssemblyDelaySign(false)]
[assembly: AssemblyKeyFile('')]
{$IF CODESIGN}
[assembly: AssemblyKeyName('RemObjectsSoftware')]
{$ENDIF}

implementation

end.
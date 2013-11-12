<?xml version="1.0" encoding="utf-8"?>
<Project DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003" ToolsVersion="4.0">
  <PropertyGroup>
    <RootNamespace>Sugar.Nougat.iOS.Test</RootNamespace>
    <ProjectGuid>{e8cdf7d0-43b8-48f4-a06d-37748b1fa463}</ProjectGuid>
    <OutputType>Executable</OutputType>
    <AssemblyName>SugarTest</AssemblyName>
    <AllowGlobals>False</AllowGlobals>
    <AllowLegacyWith>False</AllowLegacyWith>
    <AllowLegacyOutParams>False</AllowLegacyOutParams>
    <AllowLegacyCreate>False</AllowLegacyCreate>
    <AllowUnsafeCode>False</AllowUnsafeCode>
    <Configuration Condition="'$(Configuration)' == ''">Release</Configuration>
    <SDK>iOS</SDK>
    <CreateAppBundle>True</CreateAppBundle>
    <InfoPListFile>Main\iOS\Resources\Info.plist</InfoPListFile>
    <DeploymentTargetVersion>5.1</DeploymentTargetVersion>
    <Name>Sugar.Nougat.iOS.Test</Name>
    <DefaultUses />
    <StartupClass />
    <CreateHeaderFile>False</CreateHeaderFile>
    <BundleExtension />
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)' == 'Debug' ">
    <Optimize>false</Optimize>
    <OutputPath>.\bin\Debug</OutputPath>
    <DefineConstants>DEBUG;TRACE;</DefineConstants>
    <GenerateDebugInfo>True</GenerateDebugInfo>
    <EnableAsserts>True</EnableAsserts>
    <TreatWarningsAsErrors>False</TreatWarningsAsErrors>
    <CaptureConsoleOutput>False</CaptureConsoleOutput>
    <WarnOnCaseMismatch>True</WarnOnCaseMismatch>
    <SimulatorArchitectures>i386</SimulatorArchitectures>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)' == 'Release' ">
    <Optimize>true</Optimize>
    <OutputPath>.\bin\Release</OutputPath>
    <GenerateDebugInfo>False</GenerateDebugInfo>
    <EnableAsserts>False</EnableAsserts>
    <TreatWarningsAsErrors>False</TreatWarningsAsErrors>
    <CaptureConsoleOutput>False</CaptureConsoleOutput>
    <WarnOnCaseMismatch>True</WarnOnCaseMismatch>
    <CreateIPA>True</CreateIPA>
  </PropertyGroup>
  <ItemGroup>
    <Reference Include="CoreGraphics.fx" />
    <Reference Include="Foundation.fx" />
    <Reference Include="libxml2.fx">
      <HintPath>C:\Program Files\Embarcadero\Delphi Prism\Nougat\Libraries\libxml2\iOS\libxml2.fx</HintPath>
    </Reference>
    <Reference Include="UIKit.fx" />
    <Reference Include="rtl.fx" />
    <Reference Include="libNougat.fx" />
  </ItemGroup>
  <ItemGroup>
    <Compile Include="Main\iOS\Program.pas" />
    <Compile Include="Printer\Printer.pas" />
    <Compile Include="Tests\Binary.pas" />
    <Compile Include="Tests\DateTime.pas" />
    <Compile Include="Tests\Dictionary.pas" />
    <Compile Include="Tests\Extensions.pas" />
    <Compile Include="Tests\Folder.pas" />
    <Compile Include="Tests\File.pas" />
    <Compile Include="Tests\Guid.pas" />
    <Compile Include="Tests\HashSet.pas" />
    <Compile Include="Tests\List.pas" />
    <Compile Include="Tests\Math.pas" />
    <Compile Include="Tests\Queue.pas" />
    <Compile Include="Tests\Random.pas" />
    <Compile Include="Tests\Stack.pas" />
    <Compile Include="Tests\String.pas" />
    <Compile Include="Tests\StringBuilder.pas" />
    <Compile Include="Tests\Url.pas" />
    <Compile Include="Tests\UserSettings.pas" />
    <Compile Include="Tests\Xml\CharacterData.pas" />
    <Compile Include="Tests\Xml\DocumentType.pas" />
    <Compile Include="Tests\Xml\Element.pas" />
    <Compile Include="Tests\Xml\Node.pas" />
    <Compile Include="Tests\Xml\ProcessingInstruction.pas" />
    <Compile Include="Tests\Xml\TestData.pas" />
  </ItemGroup>
  <ItemGroup>
    <Content Include="Main\iOS\Resources\Info.plist" />
    <AppResource Include="Main\iOS\Resources\App Icons\App-29.png" />
    <AppResource Include="Main\iOS\Resources\App Icons\App-48.png" />
    <AppResource Include="Main\iOS\Resources\App Icons\App-57.png" />
    <AppResource Include="Main\iOS\Resources\App Icons\App-58.png" />
    <AppResource Include="Main\iOS\Resources\App Icons\App-72.png" />
    <AppResource Include="Main\iOS\Resources\App Icons\App-96.png" />
    <AppResource Include="Main\iOS\Resources\App Icons\App-114.png" />
    <AppResource Include="Main\iOS\Resources\App Icons\App-144.png" />
    <None Include="Main\iOS\Resources\App Icons\App-512.png" />
    <None Include="Main\iOS\Resources\App Icons\App-1024.png" />
    <AppResource Include="Main\iOS\Resources\Launch Images\Default.png" />
    <AppResource Include="Main\iOS\Resources\Launch Images\Default@2x.png" />
    <AppResource Include="Main\iOS\Resources\Launch Images\Default-568h@2x.png" />
    <AppResource Include="Main\iOS\Resources\Launch Images\Default-Portrait.png" />
    <AppResource Include="Main\iOS\Resources\Launch Images\Default-Portrait@2x.png" />
    <AppResource Include="Main\iOS\Resources\Launch Images\Default-Landscape.png" />
    <AppResource Include="Main\iOS\Resources\Launch Images\Default-Landscape@2x.png" />
  </ItemGroup>
  <ItemGroup>
    <Folder Include="Main\" />
    <Folder Include="Main\iOS\" />
    <Folder Include="Properties\" />
    <Folder Include="Main\iOS\Resources\" />
    <Folder Include="Main\iOS\Resources\App Icons\" />
    <Folder Include="Main\iOS\Resources\Launch Images\" />
    <Folder Include="Printer\" />
    <Folder Include="Tests" />
    <Folder Include="Tests\Xml" />
  </ItemGroup>
  <ItemGroup>
    <ProjectReference Include="..\Sugar.TestFramework\RemObjects.Oxygene.Sugar.Nougat.iOS.TestFramework.oxygene">
      <Name>RemObjects.Oxygene.Sugar.Nougat.iOS.TestFramework</Name>
      <Project>{e132a412-2431-41c6-9d98-63f942a32b8e}</Project>
      <Private>True</Private>
      <HintPath>..\Sugar.TestFramework\bin\Debug\iOS Simulator\libSugarTestFramework.fx</HintPath>
    </ProjectReference>
    <ProjectReference Include="..\Sugar\RemObjects.Oxygene.Sugar.Nougat.iOS.oxygene">
      <Name>RemObjects.Oxygene.Sugar.Nougat.iOS</Name>
      <Project>{91b301fc-331e-48a7-803b-4cbe3fff6ed7}</Project>
      <Private>True</Private>
      <HintPath>..\Sugar\bin\Debug\iOS Simulator\libSugar.fx</HintPath>
    </ProjectReference>
  </ItemGroup>
  <Import Project="$(MSBuildExtensionsPath)\RemObjects Software\Oxygene\RemObjects.Oxygene.Nougat.targets" />
  <PropertyGroup>
    <PreBuildEvent />
  </PropertyGroup>
</Project>
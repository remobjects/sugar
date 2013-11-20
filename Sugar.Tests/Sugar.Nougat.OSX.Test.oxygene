<?xml version="1.0" encoding="utf-8"?>
<Project DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003" ToolsVersion="4.0">
  <PropertyGroup>
    <RootNamespace>Sugar.Nougat.OSX.Test</RootNamespace>
    <ProjectGuid>{e05279de-3031-4a1d-8c31-ff14ba511f66}</ProjectGuid>
    <OutputType>Executable</OutputType>
    <AssemblyName>SugarTest</AssemblyName>
    <AllowGlobals>False</AllowGlobals>
    <AllowLegacyWith>False</AllowLegacyWith>
    <AllowLegacyOutParams>False</AllowLegacyOutParams>
    <AllowLegacyCreate>False</AllowLegacyCreate>
    <AllowUnsafeCode>False</AllowUnsafeCode>
    <Configuration Condition="'$(Configuration)' == ''">Release</Configuration>
    <SDK>OS X</SDK>
    <EntitlementsFile>Entitlements.entitlements</EntitlementsFile>
    <DeploymentTargetVersion>10.7</DeploymentTargetVersion>
    <Name>Sugar.Nougat.OSX.Test</Name>
    <DefaultUses>Foundation</DefaultUses>
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
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)' == 'Release' ">
    <Optimize>true</Optimize>
    <OutputPath>.\bin\Release</OutputPath>
    <GenerateDebugInfo>False</GenerateDebugInfo>
    <EnableAsserts>False</EnableAsserts>
    <TreatWarningsAsErrors>False</TreatWarningsAsErrors>
    <CaptureConsoleOutput>False</CaptureConsoleOutput>
    <WarnOnCaseMismatch>True</WarnOnCaseMismatch>
  </PropertyGroup>
  <ItemGroup>
    <Reference Include="Foundation.fx" />
    <Reference Include="libNougat.fx" />
    <Reference Include="libxml2.fx" />
    <Reference Include="rtl.fx" />
  </ItemGroup>
  <ItemGroup>
    <Compile Include="Main\OSX\Program.pas" />
    <None Include="Entitlements.entitlements" />
    <Compile Include="Printer\Printer.pas" />
    <Compile Include="Tests\Binary.pas" />
    <Compile Include="Tests\DateTime.pas" />
    <Compile Include="Tests\Dictionary.pas" />
    <Compile Include="Tests\Extensions.pas" />
    <Compile Include="Tests\Folder.pas" />
    <Compile Include="Tests\File.pas" />
    <Compile Include="Tests\Guid.pas" />
    <Compile Include="Tests\HashSet.pas" />
    <Compile Include="Tests\HTTP.pas" />
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
    <Compile Include="Tests\Xml\Document.pas" />
    <Compile Include="Tests\Xml\DocumentType.pas" />
    <Compile Include="Tests\Xml\Element.pas" />
    <Compile Include="Tests\Xml\Node.pas" />
    <Compile Include="Tests\Xml\ProcessingInstruction.pas" />
    <Compile Include="Tests\Xml\TestData.pas" />
  </ItemGroup>
  <ItemGroup>
    <Folder Include="Main\" />
    <Folder Include="Main\OSX\" />
    <Folder Include="Printer\" />
    <Folder Include="Tests" />
    <Folder Include="Properties\" />
    <Folder Include="Tests\Xml" />
  </ItemGroup>
  <ItemGroup>
    <ProjectReference Include="..\Sugar.TestFramework\RemObjects.Oxygene.Sugar.Nougat.OSX.TestFramework.oxygene">
      <Name>RemObjects.Oxygene.Sugar.Nougat.OSX.TestFramework</Name>
      <Project>{1d894b7c-0117-4154-a1f2-fd22691f0f13}</Project>
      <Private>True</Private>
      <HintPath>..\Sugar.TestFramework\bin\Debug\OS X\libSugarTestFramework.fx</HintPath>
    </ProjectReference>
    <ProjectReference Include="..\Sugar\RemObjects.Oxygene.Sugar.Nougat.OSX.oxygene">
      <Name>RemObjects.Oxygene.Sugar.Nougat.OSX</Name>
      <Project>{ab7ab88b-2370-43bf-844b-54d015da9e57}</Project>
      <Private>True</Private>
      <HintPath>..\Sugar\bin\Debug\OS X\libSugar.fx</HintPath>
    </ProjectReference>
  </ItemGroup>
  <Import Project="$(MSBuildExtensionsPath)\RemObjects Software\Oxygene\RemObjects.Oxygene.Nougat.targets" />
  <PropertyGroup>
    <PreBuildEvent />
  </PropertyGroup>
</Project>
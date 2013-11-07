<?xml version="1.0" encoding="utf-8"?>
<Project DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003" ToolsVersion="4.0">
  <PropertyGroup>
    <ProductVersion>3.5</ProductVersion>
    <RootNamespace>Sugar.Test</RootNamespace>
    <ProjectGuid>{9f930a22-be43-4d5a-83f6-4afc91282e23}</ProjectGuid>
    <OutputType>Exe</OutputType>
    <AssemblyName>Sugar.Test</AssemblyName>
    <AllowGlobals>False</AllowGlobals>
    <AllowLegacyWith>False</AllowLegacyWith>
    <AllowLegacyOutParams>False</AllowLegacyOutParams>
    <AllowLegacyCreate>False</AllowLegacyCreate>
    <AllowUnsafeCode>False</AllowUnsafeCode>
    <Configuration Condition="'$(Configuration)' == ''">Release</Configuration>
    <TargetFrameworkVersion>v4.0</TargetFrameworkVersion>
    <Name>Sugar.Echoes.Test</Name>
    <DefaultUses />
    <StartupClass />
    <InternalAssemblyName />
    <ApplicationIcon />
    <TargetFrameworkProfile />
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)' == 'Debug' ">
    <Optimize>false</Optimize>
    <OutputPath>.\bin\Debug\.NET</OutputPath>
    <DefineConstants>DEBUG;TRACE;</DefineConstants>
    <GeneratePDB>True</GeneratePDB>
    <GenerateMDB>True</GenerateMDB>
    <EnableAsserts>True</EnableAsserts>
    <TreatWarningsAsErrors>False</TreatWarningsAsErrors>
    <CaptureConsoleOutput>False</CaptureConsoleOutput>
    <StartMode>Project</StartMode>
    <RegisterForComInterop>False</RegisterForComInterop>
    <CpuType>anycpu</CpuType>
    <RuntimeVersion>v25</RuntimeVersion>
    <XmlDoc>False</XmlDoc>
    <XmlDocWarningLevel>WarningOnPublicMembers</XmlDocWarningLevel>
    <EnableUnmanagedDebugging>False</EnableUnmanagedDebugging>
    <WarnOnCaseMismatch>True</WarnOnCaseMismatch>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)' == 'Release' ">
    <Optimize>true</Optimize>
    <OutputPath>.\bin\Release\.NET</OutputPath>
    <GeneratePDB>False</GeneratePDB>
    <GenerateMDB>False</GenerateMDB>
    <EnableAsserts>False</EnableAsserts>
    <TreatWarningsAsErrors>False</TreatWarningsAsErrors>
    <CaptureConsoleOutput>False</CaptureConsoleOutput>
    <StartMode>Project</StartMode>
    <RegisterForComInterop>False</RegisterForComInterop>
    <CpuType>anycpu</CpuType>
    <RuntimeVersion>v25</RuntimeVersion>
    <XmlDoc>False</XmlDoc>
    <XmlDocWarningLevel>WarningOnPublicMembers</XmlDocWarningLevel>
    <EnableUnmanagedDebugging>False</EnableUnmanagedDebugging>
    <WarnOnCaseMismatch>True</WarnOnCaseMismatch>
  </PropertyGroup>
  <ItemGroup>
    <Reference Include="mscorlib" />
    <Reference Include="System" />
    <Reference Include="System.Configuration">
      <HintPath>C:\Program Files\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.0\System.configuration.dll</HintPath>
    </Reference>
    <Reference Include="System.Data" />
  </ItemGroup>
  <ItemGroup>
    <Compile Include="Main\Echoes\Program.pas" />
    <Compile Include="Printer\Printer.pas" />
    <Compile Include="Properties\AssemblyInfo.pas" />
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
    <Compile Include="Tests\Xml\Element.pas" />
    <Compile Include="Tests\Xml\Node.pas" />
    <Compile Include="Tests\Xml\ProcessingInstruction.pas" />
    <Compile Include="Tests\Xml\TestData.pas" />
  </ItemGroup>
  <ItemGroup>
    <Folder Include="Main\" />
    <Folder Include="Main\Echoes\" />
    <Folder Include="Printer\" />
    <Folder Include="Tests" />
    <Folder Include="Properties\" />
    <Folder Include="Tests\Xml" />
  </ItemGroup>
  <ItemGroup>
    <ProjectReference Include="..\Sugar.TestFramework\RemObjects.Oxygene.Sugar.Echoes.TestFramework.oxygene">
      <Name>RemObjects.Oxygene.Sugar.Echoes.TestFramework</Name>
      <Project>{532c6e08-1256-4168-8973-08c9d3d7b239}</Project>
      <Private>True</Private>
      <HintPath>..\Sugar.TestFramework\bin\Debug\RemObjects.Oxygene.Sugar.TestFramework.dll</HintPath>
    </ProjectReference>
    <ProjectReference Include="..\Sugar\RemObjects.Oxygene.Sugar.Echoes.oxygene">
      <Name>RemObjects.Oxygene.Sugar.Echoes</Name>
      <Project>{79301a0c-1f95-4fb0-9605-207e288c6171}</Project>
      <Private>True</Private>
      <HintPath>..\Sugar\bin\Debug\.NET\RemObjects.Oxygene.Sugar.dll</HintPath>
    </ProjectReference>
  </ItemGroup>
  <Import Project="$(MSBuildExtensionsPath)\RemObjects Software\Oxygene\RemObjects.Oxygene.Echoes.targets" />
  <PropertyGroup>
    <PreBuildEvent />
  </PropertyGroup>
</Project>
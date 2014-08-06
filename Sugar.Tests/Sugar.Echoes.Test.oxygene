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
    <Optimize>False</Optimize>
    <OutputPath>bin\Debug\.NET\</OutputPath>
    <DefineConstants>DEBUG;TRACE;</DefineConstants>
    <GeneratePDB>True</GeneratePDB>
    <GenerateMDB>True</GenerateMDB>
    <CaptureConsoleOutput>False</CaptureConsoleOutput>
    <StartMode>Project</StartMode>
    <CpuType>anycpu</CpuType>
    <RuntimeVersion>v25</RuntimeVersion>
    <XmlDoc>False</XmlDoc>
    <XmlDocWarningLevel>WarningOnPublicMembers</XmlDocWarningLevel>
    <EnableUnmanagedDebugging>False</EnableUnmanagedDebugging>
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
  </PropertyGroup>
  <ItemGroup>
    <Reference Include="mscorlib" />
    <Reference Include="RemObjects.Elements.EUnit" />
    <Reference Include="System" />
    <Reference Include="System.Configuration" />
    <Reference Include="System.Data" />
  </ItemGroup>
  <ItemGroup>
    <Compile Include="Main\Echoes\Program.pas" />
    <None Include="Printer\Printer.pas" />
    <Compile Include="Properties\AssemblyInfo.pas" />
    <Compile Include="Tests\AutoreleasePool.pas" />
    <Compile Include="Tests\Binary.pas" />
    <Compile Include="Tests\Convert.pas" />
    <None Include="Tests\Cryptography\Utils.pas" />
    <Compile Include="Tests\DateTime.pas" />
    <Compile Include="Tests\Dictionary.pas" />
    <None Include="Tests\Encoding.pas" />
    <Compile Include="Tests\Extensions.pas" />
    <Compile Include="Tests\Guid.pas" />
    <Compile Include="Tests\HashSet.pas" />
    <None Include="Tests\HTTP.pas" />
    <None Include="Tests\IO\File.pas" />
    <None Include="Tests\IO\FileHandle.pas" />
    <None Include="Tests\IO\FileUtils.pas" />
    <None Include="Tests\IO\Folder.pas" />
    <None Include="Tests\IO\FolderUtils.pas" />
    <None Include="Tests\IO\Path.pas" />
    <Compile Include="Tests\List.pas" />
    <None Include="Tests\Math.pas" />
    <None Include="Tests\MessageDigest.pas" />
    <None Include="Tests\Queue.pas" />
    <Compile Include="Tests\Random.pas" />
    <Compile Include="Tests\Stack.pas" />
    <None Include="Tests\String.pas" />
    <None Include="Tests\StringBuilder.pas" />
    <None Include="Tests\Url.pas" />
    <None Include="Tests\UserSettings.pas" />
    <None Include="Tests\Xml\CharacterData.pas" />
    <None Include="Tests\Xml\Document.pas" />
    <None Include="Tests\Xml\DocumentType.pas" />
    <None Include="Tests\Xml\Element.pas" />
    <None Include="Tests\Xml\Node.pas" />
    <None Include="Tests\Xml\ProcessingInstruction.pas" />
    <None Include="Tests\Xml\TestData.pas" />
  </ItemGroup>
  <ItemGroup>
    <Folder Include="Main\" />
    <Folder Include="Main\Echoes\" />
    <Folder Include="Printer\" />
    <Folder Include="Tests" />
    <Folder Include="Properties\" />
    <Folder Include="Tests\IO" />
    <Folder Include="Tests\Cryptography" />
    <Folder Include="Tests\Xml" />
  </ItemGroup>
  <ItemGroup>
    <ProjectReference Include="..\Sugar\Sugar.Echoes.oxygene">
      <Name>Sugar.Echoes</Name>
      <Project>{79301a0c-1f95-4fb0-9605-207e288c6171}</Project>
      <Private>True</Private>
      <HintPath>..\Sugar\bin\.NET\Sugar.dll</HintPath>
    </ProjectReference>
  </ItemGroup>
  <Import Project="$(MSBuildExtensionsPath)\RemObjects Software\Oxygene\RemObjects.Oxygene.Echoes.targets" />
  <PropertyGroup>
    <PreBuildEvent />
  </PropertyGroup>
</Project>
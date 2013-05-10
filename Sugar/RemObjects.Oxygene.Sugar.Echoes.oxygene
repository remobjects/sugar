<?xml version="1.0" encoding="utf-8"?>
<Project DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003" ToolsVersion="4.0">
  <PropertyGroup>
    <ProductVersion>3.5</ProductVersion>
    <RootNamespace>RemObjects.Oxygene.Sugar</RootNamespace>
    <StartupClass />
    <OutputType>Library</OutputType>
    <AssemblyName>RemObjects.Oxygene.Sugar</AssemblyName>
    <AllowGlobals>
    </AllowGlobals>
    <AllowLegacyWith>
    </AllowLegacyWith>
    <AllowLegacyOutParams>False</AllowLegacyOutParams>
    <AllowLegacyCreate>False</AllowLegacyCreate>
    <AllowUnsafeCode>
    </AllowUnsafeCode>
    <ApplicationIcon />
    <Configuration Condition="'$(Configuration)' == ''">Release</Configuration>
    <TargetFrameworkVersion>v4.0</TargetFrameworkVersion>
    <Name>RemObjects.Oxygene.Sugar.Echoes</Name>
    <ProjectGuid>{79301a0c-1f95-4fb0-9605-207e288c6171}</ProjectGuid>
    <DefaultUses />
    <InternalAssemblyName />
    <TargetFrameworkProfile />
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)' == 'Debug' ">
    <Optimize>False</Optimize>
    <OutputPath>bin\Debug\</OutputPath>
    <DefineConstants>DEBUG;TRACE</DefineConstants>
    <GeneratePDB>True</GeneratePDB>
    <GenerateMDB>True</GenerateMDB>
    <CaptureConsoleOutput>False</CaptureConsoleOutput>
    <StartMode>Project</StartMode>
    <CpuType>anycpu</CpuType>
    <RuntimeVersion>v25</RuntimeVersion>
    <XmlDoc>False</XmlDoc>
    <XmlDocWarningLevel>WarningOnPublicMembers</XmlDocWarningLevel>
    <EnableUnmanagedDebugging>False</EnableUnmanagedDebugging>
    <WarnOnCaseMismatch>True</WarnOnCaseMismatch>
    <SuppressWarnings />
    <FutureHelperClassName />
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)' == 'Release' ">
    <OutputPath>bin\Release\</OutputPath>
    <EnableAsserts>False</EnableAsserts>
    <CaptureConsoleOutput>False</CaptureConsoleOutput>
    <StartMode>Project</StartMode>
    <CpuType>anycpu</CpuType>
    <RuntimeVersion>v25</RuntimeVersion>
    <XmlDoc>False</XmlDoc>
    <XmlDocWarningLevel>WarningOnPublicMembers</XmlDocWarningLevel>
    <EnableUnmanagedDebugging>False</EnableUnmanagedDebugging>
    <WarnOnCaseMismatch>True</WarnOnCaseMismatch>
    <DefineConstants>
    </DefineConstants>
    <SuppressWarnings />
    <FutureHelperClassName />
  </PropertyGroup>
  <ItemGroup>
    <Reference Include="mscorlib" />
    <Reference Include="System" />
    <Reference Include="System.Configuration" />
    <Reference Include="System.Data" />
    <Reference Include="System.Drawing">
      <HintPath>C:\Windows\Microsoft.NET\Framework\v2.0.50727\System.Drawing.dll</HintPath>
    </Reference>
    <Reference Include="System.Xml" />
    <Reference Include="System.Core">
      <RequiredTargetFramework>3.5</RequiredTargetFramework>
    </Reference>
    <Reference Include="System.Xml.Linq">
      <RequiredTargetFramework>3.5</RequiredTargetFramework>
    </Reference>
    <Reference Include="System.Data.DataSetExtensions">
      <RequiredTargetFramework>3.5</RequiredTargetFramework>
    </Reference>
  </ItemGroup>
  <ItemGroup>
    <Compile Include="AutoreleasePool.pas" />
    <Compile Include="Binary.pas" />
    <Compile Include="Collections\Dictionary.pas" />
    <Compile Include="Collections\HashSet.pas" />
    <Compile Include="Collections\List.pas" />
    <Compile Include="Collections\Queue.pas" />
    <Compile Include="Collections\Stack.pas" />
    <Compile Include="Color.pas" />
    <Compile Include="Console.pas" />
    <Compile Include="Crypto\Cipher.pas">
      <SubType>Code</SubType>
    </Compile>
    <Compile Include="Crypto\Digest.pas" />
    <Compile Include="DateTime.pas" />
    <Compile Include="Dispatch.pas" />
    <Compile Include="Echoes\MonoHelpers\CoreFoundation.pas" />
    <Compile Include="Echoes\MonoHelpers\MacFolders.pas" />
    <Compile Include="Echoes\MonoHelpers\PlatformDetection.pas" />
    <Compile Include="HTTP.pas" />
    <Compile Include="IO\File.pas" />
    <Compile Include="IO\Folder.pas" />
    <Compile Include="IO\StandardFolders.pas" />
    <Compile Include="Random.pas" />
    <Compile Include="Environment.pas" />
    <Compile Include="Exceptions.pas" />
    <Compile Include="Guid.pas" />
    <Compile Include="Threading\AutoResetEvent.pas" />
    <Compile Include="Threading\ManualResetEvent.pas" />
    <Compile Include="Threading\Semaphore.pas" />
    <Compile Include="Threading\Thread.pas" />
    <Compile Include="Threading\ThreadPool.pas" />
    <Compile Include="UserSettings.pas" />
    <Compile Include="Math.pas" />
    <Compile Include="Properties\AssemblyInfo.pas" />
    <Compile Include="String.pas" />
    <Compile Include="StringBuilder.pas" />
    <Compile Include="StringFormatter.pas" />
    <Compile Include="Url.pas" />
    <Compile Include="XML\XmlAttribute.pas" />
    <Compile Include="XML\XmlCharacterData.pas" />
    <Compile Include="XML\XmlDocument.pas" />
    <Compile Include="XML\XmlDocumentType.pas" />
    <Compile Include="XML\XmlElement.pas" />
    <Compile Include="XML\XmlNode.pas" />
    <Compile Include="XML\XmlProcessingInstruction.pas" />
  </ItemGroup>
  <ItemGroup>
    <Folder Include="Crypto" />
    <Folder Include="Echoes" />
    <Folder Include="Echoes\MonoHelpers" />
    <Folder Include="XML" />
    <Folder Include="Properties\" />
    <Folder Include="Collections" />
    <Folder Include="Threading" />
    <Folder Include="IO" />
  </ItemGroup>
  <Import Project="$(MSBuildExtensionsPath)\RemObjects Software\Oxygene\RemObjects.Oxygene.Echoes.targets" />
  <PropertyGroup>
    <PreBuildEvent />
  </PropertyGroup>
</Project>
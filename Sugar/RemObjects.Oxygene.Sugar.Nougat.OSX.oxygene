<?xml version="1.0" encoding="utf-8"?>
<Project DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003" ToolsVersion="4.0">
  <PropertyGroup>
    <ProductVersion>3.5</ProductVersion>
    <OutputType>StaticLibrary</OutputType>
    <Configuration Condition="'$(Configuration)' == ''">Release</Configuration>
    <AllowLegacyCreate>False</AllowLegacyCreate>
    <Name>RemObjects.Oxygene.Sugar.Nougat.OSX</Name>
    <RootNamespace>RemObjects.Oxygene.Sugar</RootNamespace>
    <SDK>OS X</SDK>
    <ProjectGuid>{ab7ab88b-2370-43bf-844b-54d015da9e57}</ProjectGuid>
    <AssemblyName>Sugar</AssemblyName>
    <DefaultUses>Foundation</DefaultUses>
    <StartupClass />
    <DeploymentTargetVersion>10.6</DeploymentTargetVersion>
    <BundleIdentifier>org.me.RemObjects.Oxygene.Sugar</BundleIdentifier>
    <AllowLegacyOutParams>False</AllowLegacyOutParams>
    <CreateHeaderFile>True</CreateHeaderFile>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)' == 'Debug' ">
    <Optimize>False</Optimize>
    <OutputPath>.\bin\Debug</OutputPath>
    <DefineConstants>DEBUG;TRACE;OSX</DefineConstants>
    <GenerateDebugInfo>True</GenerateDebugInfo>
    <EnableAsserts>True</EnableAsserts>
    <TreatWarningsAsErrors>False</TreatWarningsAsErrors>
    <CaptureConsoleOutput>False</CaptureConsoleOutput>
    <StartMode>Project</StartMode>
    <CpuType>anycpu</CpuType>
    <RuntimeVersion>v25</RuntimeVersion>
    <XmlDoc>False</XmlDoc>
    <XmlDocWarningLevel>WarningOnPublicMembers</XmlDocWarningLevel>
    <WarnOnCaseMismatch>True</WarnOnCaseMismatch>
    <EnableUnmanagedDebugging>False</EnableUnmanagedDebugging>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)' == 'Release' ">
    <Optimize>True</Optimize>
    <OutputPath>.\bin\Release</OutputPath>
    <GenerateDebugInfo>False</GenerateDebugInfo>
    <EnableAsserts>False</EnableAsserts>
    <DefineConstants>OSX</DefineConstants>
    <CaptureConsoleOutput>False</CaptureConsoleOutput>
    <StartMode>Project</StartMode>
    <CpuType>anycpu</CpuType>
    <RuntimeVersion>v25</RuntimeVersion>
    <XmlDoc>False</XmlDoc>
    <XmlDocWarningLevel>WarningOnPublicMembers</XmlDocWarningLevel>
    <WarnOnCaseMismatch>True</WarnOnCaseMismatch>
    <EnableUnmanagedDebugging>False</EnableUnmanagedDebugging>
  </PropertyGroup>
  <ItemGroup>
    <Reference Include="AppKit.fx">
      <HintPath>C:\Program Files (x86)\RemObjects Software\Oxygene\Nougat\SDKs\OS X 10.8\AppKit.fx</HintPath>
    </Reference>
    <Reference Include="CoreServices.fx">
      <HintPath>C:\Program Files (x86)\RemObjects Software\Oxygene\Nougat\SDKs\OS X 10.8\CoreServices.fx</HintPath>
    </Reference>
    <Reference Include="Foundation.fx" />
    <Reference Include="rtl.fx" />
  </ItemGroup>
  <ItemGroup>
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
    <None Include="HTTP.pas" />
    <Compile Include="IO\File.pas" />
    <Compile Include="IO\Folder.pas" />
    <Compile Include="IO\StandardFolders.pas" />
    <Compile Include="Random.pas" />
    <Compile Include="Dispatch.pas" />
    <Compile Include="Environment.pas" />
    <Compile Include="UserSettings.pas" />
    <Compile Include="Threading\AutoResetEvent.pas" />
    <Compile Include="Threading\ManualResetEvent.pas" />
    <Compile Include="Threading\Semaphore.pas" />
    <Compile Include="Threading\Thread.pas" />
    <Compile Include="Threading\ThreadPool.pas" />
    <Compile Include="Exceptions.pas" />
    <Compile Include="Guid.pas" />
    <Compile Include="Math.pas" />
    <Compile Include="Object.pas" />
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
    <Folder Include="Properties\" />
    <Folder Include="Collections" />
    <Folder Include="Threading" />
    <Folder Include="IO" />
    <Folder Include="XML\" />
  </ItemGroup>
  <Import Project="$(MSBuildExtensionsPath)\RemObjects Software\Oxygene\RemObjects.Oxygene.Nougat.targets" />
  <PropertyGroup>
    <PreBuildEvent />
  </PropertyGroup>
</Project>
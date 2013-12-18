<?xml version="1.0" encoding="utf-8"?>
<Project DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003" ToolsVersion="4.0">
  <PropertyGroup>
    <ProductVersion>3.5</ProductVersion>
    <OutputType>StaticLibrary</OutputType>
    <Configuration Condition="'$(Configuration)' == ''">Release</Configuration>
    <AllowLegacyCreate>False</AllowLegacyCreate>
    <Name>RemObjects.Sugar.Nougat.iOS</Name>
    <RootNamespace>RemObjects.Sugar</RootNamespace>
    <SDK>iOS</SDK>
    <ProjectGuid>{91B301FC-331E-48A7-803B-4CBE3FFF6ED7}</ProjectGuid>
    <AssemblyName>Sugar</AssemblyName>
    <DefaultUses>Foundation</DefaultUses>
    <StartupClass />
    <DeploymentTargetVersion>6.0</DeploymentTargetVersion>
    <BundleIdentifier>org.me.RemObjects.Sugar</BundleIdentifier>
    <AllowLegacyOutParams>False</AllowLegacyOutParams>
    <CreateHeaderFile>True</CreateHeaderFile>
    <BundleExtension />
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)' == 'Debug' ">
    <Optimize>False</Optimize>
    <OutputPath>.\bin</OutputPath>
    <DefineConstants>DEBUG;TRACE;IOS</DefineConstants>
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
    <SimulatorArchitectures>i386;x86_64</SimulatorArchitectures>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)' == 'Release' ">
    <Optimize>True</Optimize>
    <OutputPath>.\bin</OutputPath>
    <GenerateDebugInfo>False</GenerateDebugInfo>
    <EnableAsserts>False</EnableAsserts>
    <CaptureConsoleOutput>False</CaptureConsoleOutput>
    <StartMode>Project</StartMode>
    <CpuType>anycpu</CpuType>
    <RuntimeVersion>v25</RuntimeVersion>
    <XmlDoc>False</XmlDoc>
    <XmlDocWarningLevel>WarningOnPublicMembers</XmlDocWarningLevel>
    <WarnOnCaseMismatch>True</WarnOnCaseMismatch>
    <EnableUnmanagedDebugging>False</EnableUnmanagedDebugging>
    <DefineConstants>IOS</DefineConstants>
    <SimulatorArchitectures>i386;x86_64</SimulatorArchitectures>
  </PropertyGroup>
  <ItemGroup>
    <Reference Include="Foundation.fx" />
    <Reference Include="libNougat.fx" />
    <Reference Include="libxml2.fx" />
    <Reference Include="rtl.fx" />
    <Reference Include="UIKit.fx" />
  </ItemGroup>
  <ItemGroup>
    <Compile Include="Binary.pas" />
    <Compile Include="Collections\Dictionary.pas" />
    <Compile Include="Collections\HashSet.pas" />
    <Compile Include="Collections\KeyValue.pas" />
    <Compile Include="Collections\List.pas" />
    <Compile Include="Collections\Queue.pas" />
    <Compile Include="Collections\Stack.pas" />
    <Compile Include="Color.pas" />
    <None Include="Crypto\Cipher.pas" />
    <None Include="Crypto\Digest.pas" />
    <Compile Include="DateTime.pas" />
    <Compile Include="DateFormatter.pas" />
    <Compile Include="HTTP.pas" />
    <Compile Include="IO\File.pas" />
    <Compile Include="IO\Folder.pas" />
    <Compile Include="Random.pas" />
    <Compile Include="Environment.pas" />
    <Compile Include="UserSettings.pas" />
    <None Include="Threading\AutoResetEvent.pas" />
    <None Include="Threading\ManualResetEvent.pas" />
    <None Include="Threading\Semaphore.pas" />
    <None Include="Threading\Thread.pas" />
    <None Include="Threading\ThreadPool.pas" />
    <Compile Include="Exceptions.pas" />
    <Compile Include="Guid.pas" />
    <Compile Include="Math.pas" />
    <Compile Include="Extensions.pas" />
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
    <Folder Include="XML" />
  </ItemGroup>
  <Import Project="$(MSBuildExtensionsPath)\RemObjects Software\Oxygene\RemObjects.Oxygene.Nougat.targets" />
  <PropertyGroup>
    <PreBuildEvent />
  </PropertyGroup>
</Project>
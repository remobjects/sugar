<?xml version="1.0" encoding="utf-8"?>
<Project DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003" ToolsVersion="4.0">
  <PropertyGroup>
    <ProductVersion>3.5</ProductVersion>
    <OutputType>StaticLibrary</OutputType>
    <Configuration Condition="'$(Configuration)' == ''">Release</Configuration>
    <AllowLegacyCreate>False</AllowLegacyCreate>
    <Name>Sugar.Nougat.OSX</Name>
    <RootNamespace>Sugar</RootNamespace>
    <SDK>OS X</SDK>
    <ProjectGuid>{ab7ab88b-2370-43bf-844b-54d015da9e57}</ProjectGuid>
    <AssemblyName>Sugar</AssemblyName>
    <DefaultUses>Foundation</DefaultUses>
    <StartupClass />
    <DeploymentTargetVersion>10.6</DeploymentTargetVersion>
    <AllowLegacyOutParams>False</AllowLegacyOutParams>
    <CreateHeaderFile>False</CreateHeaderFile>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)' == 'Debug' ">
    <Optimize>False</Optimize>
    <OutputPath>bin\</OutputPath>
    <DefineConstants>DEBUG;TRACE;OSX</DefineConstants>
    <CaptureConsoleOutput>False</CaptureConsoleOutput>
    <StartMode>Project</StartMode>
    <XmlDoc>False</XmlDoc>
    <XmlDocWarningLevel>WarningOnPublicMembers</XmlDocWarningLevel>
    <EnableUnmanagedDebugging>False</EnableUnmanagedDebugging>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)' == 'Release' ">
    <Optimize>True</Optimize>
    <OutputPath>.\bin</OutputPath>
    <GenerateDebugInfo>True</GenerateDebugInfo>
    <EnableAsserts>False</EnableAsserts>
    <DefineConstants>OSX</DefineConstants>
    <CaptureConsoleOutput>False</CaptureConsoleOutput>
    <StartMode>Project</StartMode>
    <XmlDoc>False</XmlDoc>
    <XmlDocWarningLevel>WarningOnPublicMembers</XmlDocWarningLevel>
    <EnableUnmanagedDebugging>False</EnableUnmanagedDebugging>
  </PropertyGroup>
  <ItemGroup>
    <Reference Include="AppKit.fx" />
    <Reference Include="CoreServices.fx" />
    <Reference Include="Foundation.fx" />
    <Reference Include="libNougat.fx" />
    <Reference Include="libxml2.fx" />
    <Reference Include="rtl.fx" />
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
    <Compile Include="Consts.pas" />
    <Compile Include="Convert.pas" />
    <Compile Include="DateTime.pas" />
    <Compile Include="DateFormatter.pas" />
    <Compile Include="HTTP.pas" />
    <Compile Include="IO\File.pas" />
    <Compile Include="IO\FileHandle.pas" />
    <Compile Include="IO\FileUtils.pas" />
    <Compile Include="IO\Folder.pas" />
    <Compile Include="IO\FolderUtils.pas" />
    <Compile Include="IO\Path.pas" />
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
    <Folder Include="XML\" />
  </ItemGroup>
  <Import Project="$(MSBuildExtensionsPath)\RemObjects Software\Oxygene\RemObjects.Oxygene.Nougat.targets" />
  <PropertyGroup>
    <PreBuildEvent>rmdir /s /q $(ProjectDir)\Obj</PreBuildEvent>
  </PropertyGroup>
</Project>
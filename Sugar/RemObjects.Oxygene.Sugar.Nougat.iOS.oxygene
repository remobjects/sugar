<?xml version="1.0" encoding="utf-8"?>
<Project DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003" ToolsVersion="4.0">
  <PropertyGroup>
    <ProductVersion>3.5</ProductVersion>
    <OutputType>StaticLibrary</OutputType>
    <Configuration Condition="'$(Configuration)' == ''">Release</Configuration>
    <AllowLegacyCreate>False</AllowLegacyCreate>
    <Name>RemObjects.Oxygene.Sugar.Nougat</Name>
    <RootNamespace>RemObjects.Oxygene.Sugar</RootNamespace>
    <SDK>iOS</SDK>
    <ProjectGuid>{91B301FC-331E-48A7-803B-4CBE3FFF6ED7}</ProjectGuid>
    <AssemblyName>Sugar</AssemblyName>
    <DefaultUses />
    <StartupClass />
    <DeploymentTargetVersion>10.6</DeploymentTargetVersion>
    <BundleIdentifier>org.me.RemObjects.Oxygene.Sugar</BundleIdentifier>
    <AllowLegacyOutParams>False</AllowLegacyOutParams>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)' == 'Debug' ">
    <Optimize>False</Optimize>
    <OutputPath>.\bin\Debug</OutputPath>
    <DefineConstants>DEBUG;TRACE</DefineConstants>
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
    <Compile Include="Environment.pas" />
    <Compile Include="Exceptions.pas" />
    <Compile Include="Properties.pas" />
    <Compile Include="IO\Directory.pas" />
    <Compile Include="IO\File.pas" />
    <Compile Include="IO\FileStream.pas" />
    <Compile Include="IO\MemoryStream.pas" />
    <Compile Include="IO\Path.pas" />
    <Compile Include="UserSettings.pas" />
    <Compile Include="Threading\AutoResetEvent.pas" />
    <Compile Include="Threading\ManualResetEvent.pas" />
    <Compile Include="Threading\Semaphore.pas" />
    <Compile Include="Threading\Thread.pas" />
    <Compile Include="Threading\ThreadPool.pas" />
    <Compile Include="Math.pas" />
    <Compile Include="Object.pas" />
    <Compile Include="String.pas" />
    <Compile Include="StringBuilder.pas" />
    <Compile Include="StringFormatter.pas" />
    <Compile Include="Xml.pas" />
    <Compile Include="Url.pas" />
  </ItemGroup>
  <ItemGroup>
    <Folder Include="Properties\" />
    <Folder Include="Collections" />
    <Folder Include="Threading" />
    <Folder Include="IO" />
  </ItemGroup>
  <Import Project="$(MSBuildExtensionsPath)\RemObjects Software\Oxygene\RemObjects.Oxygene.Nougat.targets" />
  <PropertyGroup>
    <PreBuildEvent />
  </PropertyGroup>
</Project>
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
    <DefaultUses />
    <StartupClass />
    <DeploymentTargetVersion>10.6</DeploymentTargetVersion>
    <BundleIdentifier>org.me.RemObjects.Oxygene.Sugar</BundleIdentifier>
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
    <Reference Include="CoreServices.fx">
      <HintPath>C:\Program Files (x86)\RemObjects Software\Oxygene\Nougat\SDKs\OS X 10.8\CoreServices.fx</HintPath>
    </Reference>
    <Reference Include="Foundation.fx" />
    <Reference Include="rtl.fx" />
  </ItemGroup>
  <ItemGroup>
    <Compile Include="Binary.pas" />
    <Compile Include="Console.pas" />
    <Compile Include="Dictionary.pas" />
    <Compile Include="DateTime.pas" />
    <Compile Include="Dispatch.pas" />
    <Compile Include="Environment.pas" />
    <Compile Include="Exceptions.pas" />
    <Compile Include="Properties.pas" />
    <Compile Include="File.pas" />
    <Compile Include="UserSettings.pas" />
    <Compile Include="Directory.pas" />
    <Compile Include="Stack.pas" />
    <Compile Include="Queue.pas" />
    <Compile Include="MemoryStream.pas" />
    <Compile Include="FileStreams.pas" />
    <Compile Include="List.pas" />
    <Compile Include="HashSet.pas" />
    <Compile Include="Xml.pas" />
    <Compile Include="Math.pas" />
    <Compile Include="Object.pas" />
    <Compile Include="Path.pas" />
    <Compile Include="String.pas" />
    <Compile Include="StringBuilder.pas" />
    <Compile Include="StringFormatter.pas" />
    <Compile Include="Thread.pas" />
    <Compile Include="ThreadPool.pas" />
    <Compile Include="Url.pas" />
  </ItemGroup>
  <ItemGroup>
    <Folder Include="Properties\" />
  </ItemGroup>
  <Import Project="$(MSBuildExtensionsPath)\RemObjects Software\Oxygene\RemObjects.Oxygene.Nougat.targets" />
  <PropertyGroup>
    <PreBuildEvent />
  </PropertyGroup>
</Project>
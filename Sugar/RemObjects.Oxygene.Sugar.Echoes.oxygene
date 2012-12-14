<?xml version="1.0" encoding="utf-8"?>
<Project DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003" ToolsVersion="4.0">
  <PropertyGroup>
    <ProductVersion>3.5</ProductVersion>
    <RootNamespace>RemObjects.Oxygene.Sugar</RootNamespace>
    <StartupClass />
    <OutputType>Library</OutputType>
    <AssemblyName>RemObjects.Oxygene.Sugar</AssemblyName>
    <AllowGlobals>False</AllowGlobals>
    <AllowLegacyWith>False</AllowLegacyWith>
    <AllowLegacyOutParams>False</AllowLegacyOutParams>
    <AllowLegacyCreate>False</AllowLegacyCreate>
    <AllowUnsafeCode>False</AllowUnsafeCode>
    <ApplicationIcon />
    <Configuration Condition="'$(Configuration)' == ''">Release</Configuration>
    <TargetFrameworkVersion>v3.5</TargetFrameworkVersion>
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
    <Compile Include="Binary.pas" />
    <Compile Include="Console.pas" />
    <Compile Include="Dictionary.pas" />
    <Compile Include="DateTime.pas" />
    <Compile Include="Environment.pas" />
    <Compile Include="Exceptions.pas" />
    <Compile Include="UserSettings.pas" />
    <Compile Include="Properties.pas" />
    <Compile Include="File.pas" />
    <Compile Include="Directory.pas" />
    <Compile Include="FileStreams.pas" />
    <Compile Include="List.pas" />
    <Compile Include="Thread.pas" />
    <Compile Include="MemoryStream.pas" />
    <Compile Include="ManualResetEvent.pas" />
    <Compile Include="AutoResetEvent.pas" />
    <Compile Include="Semaphore.pas" />
    <Compile Include="Xml.pas" />
    <Compile Include="ThreadPool.pas" />
    <Compile Include="Queue.pas" />
    <Compile Include="Stack.pas" />
    <Compile Include="HashSet.pas" />
    <Compile Include="Math.pas" />
    <Compile Include="Path.pas" />
    <Compile Include="Properties\AssemblyInfo.pas" />
    <Compile Include="String.pas" />
    <Compile Include="StringBuilder.pas" />
    <Compile Include="StringFormatter.pas" />
    <Compile Include="Url.pas" />
  </ItemGroup>
  <ItemGroup>
    <Folder Include="Properties\" />
  </ItemGroup>
  <Import Project="$(MSBuildExtensionsPath)\RemObjects Software\Oxygene\RemObjects.Oxygene.targets" />
  <PropertyGroup>
    <PreBuildEvent />
  </PropertyGroup>
</Project>
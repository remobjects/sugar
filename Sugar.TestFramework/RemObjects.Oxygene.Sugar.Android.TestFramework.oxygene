<?xml version="1.0" encoding="utf-8"?>
<Project DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003" ToolsVersion="4.0">
  <PropertyGroup>
    <ProductVersion>3.5</ProductVersion>
    <ProjectGuid>{d4c017d4-e773-4138-872d-72adae69da3d}</ProjectGuid>
    <OutputType>Library</OutputType>
    <Configuration Condition="'$(Configuration)' == ''">Release</Configuration>
    <AllowLegacyCreate>False</AllowLegacyCreate>
    <Name>RemObjects.Oxygene.Sugar.Android.TestFramework</Name>
    <RootNamespace>RemObjects.Oxygene.Sugar.TestFramework</RootNamespace>
    <DefaultUses />
    <StartupClass />
    <AssemblyName>RemObjects.Oxygene.Sugar.TestFramework</AssemblyName>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)' == 'Debug' ">
    <Optimize>false</Optimize>
    <OutputPath>.\bin\Debug\Android</OutputPath>
    <DefineConstants>DEBUG;TRACE;Android;</DefineConstants>
    <GenerateDebugInfo>True</GenerateDebugInfo>
    <EnableAsserts>True</EnableAsserts>
    <TreatWarningsAsErrors>False</TreatWarningsAsErrors>
    <CaptureConsoleOutput>False</CaptureConsoleOutput>
    <StartMode>Project</StartMode>
    <RegisterForComInterop>False</RegisterForComInterop>
    <CpuType>anycpu</CpuType>
    <RuntimeVersion>v25</RuntimeVersion>
    <XmlDoc>False</XmlDoc>
    <XmlDocWarningLevel>WarningOnPublicMembers</XmlDocWarningLevel>
    <WarnOnCaseMismatch>True</WarnOnCaseMismatch>
    <EnableUnmanagedDebugging>False</EnableUnmanagedDebugging>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)' == 'Release' ">
    <Optimize>true</Optimize>
    <OutputPath>.\bin\Release\Android</OutputPath>
    <DefineConstants>Android;</DefineConstants>
    <GenerateDebugInfo>False</GenerateDebugInfo>
    <EnableAsserts>False</EnableAsserts>
    <TreatWarningsAsErrors>False</TreatWarningsAsErrors>
    <CaptureConsoleOutput>False</CaptureConsoleOutput>
    <StartMode>Project</StartMode>
    <RegisterForComInterop>False</RegisterForComInterop>
    <CpuType>anycpu</CpuType>
    <RuntimeVersion>v25</RuntimeVersion>
    <XmlDoc>False</XmlDoc>
    <XmlDocWarningLevel>WarningOnPublicMembers</XmlDocWarningLevel>
    <WarnOnCaseMismatch>True</WarnOnCaseMismatch>
    <EnableUnmanagedDebugging>False</EnableUnmanagedDebugging>
  </PropertyGroup>
  <ItemGroup>
    <Compile Include="Assert.pas" />
    <Compile Include="Exceptions.pas" />
    <Compile Include="List.pas" />
    <Compile Include="Runner.pas" />
    <Compile Include="Testcase.pas" />
    <Compile Include="TestResult.pas" />
  </ItemGroup>
  <ItemGroup>
    <Folder Include="Properties\" />
  </ItemGroup>
  <ItemGroup>
    <Reference Include="android.jar" />
  </ItemGroup>
  <Import Project="$(MSBuildExtensionsPath)\RemObjects Software\Oxygene\RemObjects.Oxygene.Cooper.Android.targets" />
  <PropertyGroup>
    <PreBuildEvent />
  </PropertyGroup>
</Project>
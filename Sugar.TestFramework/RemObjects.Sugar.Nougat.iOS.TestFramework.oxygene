<?xml version="1.0" encoding="utf-8"?>
<Project DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003" ToolsVersion="4.0">
  <PropertyGroup>
    <RootNamespace>RemObjects.Sugar.TestFramework</RootNamespace>
    <ProjectGuid>{e132a412-2431-41c6-9d98-63f942a32b8e}</ProjectGuid>
    <OutputType>StaticLibrary</OutputType>
    <AssemblyName>SugarTestFramework</AssemblyName>
    <AllowGlobals>False</AllowGlobals>
    <AllowLegacyWith>False</AllowLegacyWith>
    <AllowLegacyOutParams>False</AllowLegacyOutParams>
    <AllowLegacyCreate>False</AllowLegacyCreate>
    <AllowUnsafeCode>False</AllowUnsafeCode>
    <Configuration Condition="'$(Configuration)' == ''">Release</Configuration>
    <SDK>iOS</SDK>
    <DeploymentTargetVersion>6.0</DeploymentTargetVersion>
    <CreateHeaderFile>True</CreateHeaderFile>
    <Name>RemObjects.Sugar.Nougat.iOS.TestFramework</Name>
    <DefaultUses />
    <StartupClass />
    <BundleIdentifier>org.me.RemObjects.Sugar.TestFramework</BundleIdentifier>
    <BundleExtension />
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)' == 'Debug' ">
    <Optimize>False</Optimize>
    <OutputPath>bin\</OutputPath>
    <DefineConstants>DEBUG;TRACE;iOS</DefineConstants>
    <CaptureConsoleOutput>False</CaptureConsoleOutput>
    <WarnOnCaseMismatch>True</WarnOnCaseMismatch>
    <XmlDocWarningLevel>WarningOnPublicMembers</XmlDocWarningLevel>
    <SimulatorArchitectures>i386</SimulatorArchitectures>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)' == 'Release' ">
    <Optimize>true</Optimize>
    <OutputPath>bin\</OutputPath>
    <GenerateDebugInfo>False</GenerateDebugInfo>
    <EnableAsserts>False</EnableAsserts>
    <TreatWarningsAsErrors>False</TreatWarningsAsErrors>
    <CaptureConsoleOutput>False</CaptureConsoleOutput>
    <WarnOnCaseMismatch>True</WarnOnCaseMismatch>
  </PropertyGroup>
  <ItemGroup>
    <Reference Include="Foundation.fx" />
    <Reference Include="rtl.fx" />
  </ItemGroup>
  <ItemGroup>
    <Compile Include="AsyncToken.pas" />
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
  <Import Project="$(MSBuildExtensionsPath)\RemObjects Software\Oxygene\RemObjects.Oxygene.Nougat.targets" />
  <PropertyGroup>
    <PreBuildEvent />
  </PropertyGroup>
</Project>
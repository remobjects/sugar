<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<Project xmlns="http://schemas.microsoft.com/developer/msbuild/2003" DefaultTargets="Build" ToolsVersion="4.0">
  <PropertyGroup>
    <ProductVersion>3.5</ProductVersion>
    <OutputType>StaticLibrary</OutputType>
    <Configuration Condition="'$(Configuration)' == ''">Release</Configuration>
    <AllowLegacyCreate>False</AllowLegacyCreate>
    <Name>Sugar.Data.Nougat.iOS</Name>
    <RootNamespace>Sugar</RootNamespace>
    <SDK>iOS</SDK>
    <ProjectGuid>{15939baf-3d02-4074-a4f1-6adbd2a5f28d}</ProjectGuid>
    <AssemblyName>Sugar.Data</AssemblyName>
    <DefaultUses>Foundation</DefaultUses>
    <DeploymentTargetVersion>6.0</DeploymentTargetVersion>
    <AllowLegacyOutParams>False</AllowLegacyOutParams>
    <CreateHeaderFile>False</CreateHeaderFile>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)' == 'Debug' ">
    <Optimize>False</Optimize>
    <OutputPath>bin\</OutputPath>
    <DefineConstants>DEBUG;TRACE;IOS</DefineConstants>
    <CaptureConsoleOutput>False</CaptureConsoleOutput>
    <StartMode>Project</StartMode>
    <XmlDoc>False</XmlDoc>
    <XmlDocWarningLevel>WarningOnPublicMembers</XmlDocWarningLevel>
    <EnableUnmanagedDebugging>False</EnableUnmanagedDebugging>
    <SimulatorArchitectures>i386;x86_64</SimulatorArchitectures>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)' == 'Release' ">
    <Optimize>True</Optimize>
    <OutputPath>.\bin</OutputPath>
    <GenerateDebugInfo>True</GenerateDebugInfo>
    <EnableAsserts>False</EnableAsserts>
    <CaptureConsoleOutput>False</CaptureConsoleOutput>
    <StartMode>Project</StartMode>
    <XmlDoc>False</XmlDoc>
    <XmlDocWarningLevel>WarningOnPublicMembers</XmlDocWarningLevel>
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
    <Compile Include="JSON\Exceptions.pas" />
    <Compile Include="JSON\JsonConsts.pas" />
    <Compile Include="JSON\JsonDeserializer.pas" />
    <Compile Include="JSON\JsonSerializer.pas" />
    <Compile Include="JSON\JsonTokenizer.pas" />
    <Compile Include="JSON\JsonTokenKind.pas" />
    <Compile Include="JSON\Objects\JsonArray.pas" />
    <Compile Include="JSON\Objects\JsonObject.pas" />
    <Compile Include="JSON\Objects\JsonValue.pas" />
  </ItemGroup>
  <ItemGroup>
    <Folder Include="JSON" />
    <Folder Include="JSON\Objects" />
    <Folder Include="Properties\" />
  </ItemGroup>
  <ItemGroup>
    <ProjectReference Include="..\Sugar\Sugar.Nougat.iOS.oxygene">
      <Name>Sugar.Nougat.iOS</Name>
      <Project>{91b301fc-331e-48a7-803b-4cbe3fff6ed7}</Project>
      <Private>True</Private>
      <HintPath>..\Sugar\bin\iOS Simulator\libSugar.fx</HintPath>
    </ProjectReference>
  </ItemGroup>
  <Import Project="$(MSBuildExtensionsPath)\RemObjects Software\Oxygene\RemObjects.Oxygene.Nougat.targets" />
  <PropertyGroup>
    <PreBuildEvent />
  </PropertyGroup>
</Project>
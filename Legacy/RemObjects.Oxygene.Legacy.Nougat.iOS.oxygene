<?xml version="1.0" encoding="utf-8"?>
<Project DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003" ToolsVersion="4.0">
  <PropertyGroup>
    <ProductVersion>3.5</ProductVersion>
    <RootNamespace>RemObjects.Oxygene.Legacy</RootNamespace>
    <ProjectGuid>{731210B4-23B2-4D29-9098-0AC41A551241}</ProjectGuid>
    <OutputType>StaticLibrary</OutputType>
    <AssemblyName>SugarLegacy</AssemblyName>
    <AllowGlobals>
    </AllowGlobals>
    <AllowLegacyWith>
    </AllowLegacyWith>
    <AllowLegacyOutParams>False</AllowLegacyOutParams>
    <AllowLegacyCreate>False</AllowLegacyCreate>
    <AllowUnsafeCode>True</AllowUnsafeCode>
    <Configuration Condition="'$(Configuration)' == ''">Release</Configuration>
    <TargetFrameworkVersion>v3.5</TargetFrameworkVersion>
    <Name>RemObjects.Oxygene.Legacy.Nougat.iOS</Name>
    <DefaultUses />
    <StartupClass />
    <InternalAssemblyName />
    <ApplicationIcon />
    <TargetFrameworkProfile />
    <CreateHeaderFile>True</CreateHeaderFile>
    <SDK>iOS</SDK>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)' == 'Debug' ">
    <Optimize>false</Optimize>
    <OutputPath>.\bin\Debug</OutputPath>
    <DefineConstants>DEBUG;TRACE;</DefineConstants>
    <GeneratePDB>True</GeneratePDB>
    <GenerateMDB>True</GenerateMDB>
    <EnableAsserts>True</EnableAsserts>
    <TreatWarningsAsErrors>False</TreatWarningsAsErrors>
    <CaptureConsoleOutput>False</CaptureConsoleOutput>
    <StartMode>Project</StartMode>
    <RegisterForComInterop>False</RegisterForComInterop>
    <CpuType>anycpu</CpuType>
    <RuntimeVersion>v25</RuntimeVersion>
    <XmlDoc>False</XmlDoc>
    <XmlDocWarningLevel>WarningOnPublicMembers</XmlDocWarningLevel>
    <EnableUnmanagedDebugging>False</EnableUnmanagedDebugging>
    <WarnOnCaseMismatch>True</WarnOnCaseMismatch>
    <SimulatorArchitectures>i386</SimulatorArchitectures>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)' == 'Release' ">
    <Optimize>true</Optimize>
    <OutputPath>.\bin\Release</OutputPath>
    <GeneratePDB>False</GeneratePDB>
    <GenerateMDB>False</GenerateMDB>
    <EnableAsserts>False</EnableAsserts>
    <TreatWarningsAsErrors>False</TreatWarningsAsErrors>
    <CaptureConsoleOutput>False</CaptureConsoleOutput>
    <StartMode>Project</StartMode>
    <RegisterForComInterop>False</RegisterForComInterop>
    <CpuType>anycpu</CpuType>
    <RuntimeVersion>v25</RuntimeVersion>
    <XmlDoc>False</XmlDoc>
    <XmlDocWarningLevel>WarningOnPublicMembers</XmlDocWarningLevel>
    <EnableUnmanagedDebugging>False</EnableUnmanagedDebugging>
    <WarnOnCaseMismatch>True</WarnOnCaseMismatch>
  </PropertyGroup>
  <ItemGroup>
    <Reference Include="Foundation.fx" />
    <Reference Include="libxml2.fx" />
  </ItemGroup>
  <ItemGroup>
    <Compile Include="MemIniFile.pas" />
    <Compile Include="OneBasedString.pas" />
    <Compile Include="String Functions.pas" />
  </ItemGroup>
  <ItemGroup>
    <Folder Include="Properties\" />
  </ItemGroup>
  <ItemGroup>
    <ProjectReference Include="..\Sugar\RemObjects.Sugar.Nougat.iOS.oxygene">
      <Name>RemObjects.Sugar.Nougat.iOS</Name>
      <Project>{91b301fc-331e-48a7-803b-4cbe3fff6ed7}</Project>
      <Private>True</Private>
      <HintPath>..\Sugar\bin\Debug\Sugar.exe</HintPath>
    </ProjectReference>
  </ItemGroup>
  <Import Project="$(MSBuildExtensionsPath)\RemObjects Software\Oxygene\RemObjects.Oxygene.Nougat.targets" />
  <PropertyGroup>
    <PreBuildEvent />
  </PropertyGroup>
</Project>
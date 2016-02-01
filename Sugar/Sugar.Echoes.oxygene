<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<Project xmlns="http://schemas.microsoft.com/developer/msbuild/2003" DefaultTargets="Build" ToolsVersion="4.0">
    <PropertyGroup>
        <ProductVersion>3.5</ProductVersion>
        <RootNamespace>Sugar</RootNamespace>
        <OutputType>Library</OutputType>
        <AssemblyName>Sugar</AssemblyName>
        <AllowLegacyOutParams>False</AllowLegacyOutParams>
        <AllowLegacyCreate>False</AllowLegacyCreate>
        <Configuration Condition="'$(Configuration)' == ''">Release</Configuration>
        <TargetFrameworkVersion>v4.0</TargetFrameworkVersion>
        <Name>Sugar.Echoes</Name>
        <ProjectGuid>{79301a0c-1f95-4fb0-9605-207e288c6171}</ProjectGuid>
        <WarnOnCaseMismatch>True</WarnOnCaseMismatch>
        <CrossPlatform>True</CrossPlatform>
    </PropertyGroup>
    <PropertyGroup Condition=" '$(Configuration)' == 'Debug' ">
        <Optimize>False</Optimize>
        <OutputPath>bin\.NET\</OutputPath>
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
    </PropertyGroup>
    <PropertyGroup Condition=" '$(Configuration)' == 'Release' ">
        <OutputPath>bin\.NET\</OutputPath>
        <GeneratePDB>True</GeneratePDB>
        <GenerateMDB>True</GenerateMDB>
        <EnableAsserts>False</EnableAsserts>
        <CaptureConsoleOutput>False</CaptureConsoleOutput>
        <StartMode>Project</StartMode>
        <CpuType>anycpu</CpuType>
        <RuntimeVersion>v25</RuntimeVersion>
        <XmlDoc>False</XmlDoc>
        <XmlDocWarningLevel>WarningOnPublicMembers</XmlDocWarningLevel>
        <EnableUnmanagedDebugging>False</EnableUnmanagedDebugging>
        <DefineConstants>SIGN</DefineConstants>
    </PropertyGroup>
    <ItemGroup>
        <Reference Include="mscorlib"/>
        <Reference Include="System"/>
        <Reference Include="System.Configuration"/>
        <Reference Include="System.Data"/>
        <Reference Include="System.Drawing"/>
        <Reference Include="System.Xml"/>
        <Reference Include="System.Core">
            <RequiredTargetFramework>3.5</RequiredTargetFramework>
        </Reference>
        <Reference Include="System.Xml.Linq">
            <RequiredTargetFramework>3.5</RequiredTargetFramework>
        </Reference>
        <Reference Include="System.Data.DataSetExtensions">
            <RequiredTargetFramework>3.5</RequiredTargetFramework>
        </Reference>
        <Reference Include="System.Web.dll"/>
    </ItemGroup>
    <ItemGroup>
        <Folder Include="Properties\"/>
    </ItemGroup>
    <Import Project="$(MSBuildExtensionsPath)/RemObjects Software/Oxygene/RemObjects.Oxygene.Echoes.targets"/>
    <PropertyGroup>
        <PreBuildEvent Condition="'$(OS)' != 'Unix'">rmdir /s /q $(ProjectDir)\Obj</PreBuildEvent>
    </PropertyGroup>
    <Import Project="Sugar.Shared.projitems" Label="Shared"/>
</Project>
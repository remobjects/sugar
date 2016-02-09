<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<Project xmlns="http://schemas.microsoft.com/developer/msbuild/2003" DefaultTargets="Build" ToolsVersion="4.0">
    <PropertyGroup>
        <ProductVersion>3.5</ProductVersion>
        <OutputType>StaticLibrary</OutputType>
        <Configuration Condition="'$(Configuration)' == ''">Release</Configuration>
        <AllowLegacyCreate>False</AllowLegacyCreate>
        <Name>Sugar (watchOS)</Name>
        <RootNamespace>Sugar</RootNamespace>
        <SDK>watchOS</SDK>
        <ProjectGuid>{A0CD6BB4-9336-4E25-9084-D1C63C03BF78}</ProjectGuid>
        <AssemblyName>Sugar</AssemblyName>
        <DefaultUses>Foundation</DefaultUses>
        <DeploymentTargetVersion>2.0</DeploymentTargetVersion>
        <AllowLegacyOutParams>False</AllowLegacyOutParams>
        <CreateHeaderFile>False</CreateHeaderFile>
        <CrossPlatform>True</CrossPlatform>
        <WarnOnCaseMismatch>True</WarnOnCaseMismatch>
    </PropertyGroup>
    <PropertyGroup Condition=" '$(Configuration)' == 'Debug' ">
        <Optimize>False</Optimize>
        <OutputPath>bin\</OutputPath>
        <DefineConstants>DEBUG;TRACE;WATCHOS</DefineConstants>
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
        <CaptureConsoleOutput>False</CaptureConsoleOutput>
        <StartMode>Project</StartMode>
        <XmlDoc>False</XmlDoc>
        <XmlDocWarningLevel>WarningOnPublicMembers</XmlDocWarningLevel>
        <EnableUnmanagedDebugging>False</EnableUnmanagedDebugging>
        <DefineConstants>WATCHOS</DefineConstants>
        <GenerateBitcode>True</GenerateBitcode>
    </PropertyGroup>
    <ItemGroup>
        <Reference Include="Foundation"/>
        <Reference Include="libNougat"/>
        <Reference Include="libxml2"/>
        <Reference Include="rtl"/>
        <Reference Include="UIKit"/>
    </ItemGroup>
    <ItemGroup>
        <Folder Include="Cryptography\"/>
        <Folder Include="Properties\"/>
    </ItemGroup>
    <Import Project="$(MSBuildExtensionsPath)/RemObjects Software/Oxygene/RemObjects.Oxygene.Nougat.targets"/>
    <PropertyGroup>
        <PreBuildEvent/>
    </PropertyGroup>
    <Import Project="Sugar.Shared.projitems" Label="Shared"/>
</Project>
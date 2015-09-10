<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<Project xmlns="http://schemas.microsoft.com/developer/msbuild/2003" DefaultTargets="Build" ToolsVersion="4.0">
    <PropertyGroup>
        <ProductVersion>3.5</ProductVersion>
        <OutputType>StaticLibrary</OutputType>
        <Configuration Condition="'$(Configuration)' == ''">Release</Configuration>
        <AllowLegacyCreate>False</AllowLegacyCreate>
        <Name>Sugar (tvOS)</Name>
        <RootNamespace>Sugar</RootNamespace>
        <SDK>tvOS</SDK>
        <ProjectGuid>{D1B6AAB1-96D4-4498-AA31-E7048D68147C}</ProjectGuid>
        <AssemblyName>Sugar</AssemblyName>
        <DefaultUses>Foundation</DefaultUses>
        <DeploymentTargetVersion>2.0</DeploymentTargetVersion>
        <AllowLegacyOutParams>False</AllowLegacyOutParams>
        <CreateHeaderFile>False</CreateHeaderFile>
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
    </PropertyGroup>
    <ItemGroup>
        <Reference Include="Foundation.fx"/>
        <Reference Include="libNougat.fx"/>
        <Reference Include="libxml2.fx"/>
        <Reference Include="rtl.fx"/>
        <Reference Include="UIKit.fx"/>
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

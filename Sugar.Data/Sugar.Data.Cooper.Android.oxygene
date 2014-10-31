<?xml version="1.0" encoding="utf-8"?>
<Project DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003" ToolsVersion="4.0">
  <PropertyGroup>
    <ProductVersion>3.5</ProductVersion>
    <ProjectGuid>{d5492a3d-13b2-4ef5-8835-81bc392b5a74}</ProjectGuid>
    <OutputType>Library</OutputType>
    <Configuration Condition="'$(Configuration)' == ''">Release</Configuration>
    <AllowLegacyCreate>False</AllowLegacyCreate>
    <Name>Sugar.Data.Cooper.Android</Name>
    <RootNamespace>sugar</RootNamespace>
    <AssemblyName>sugar.data</AssemblyName>
    <DefaultUses />
    <StartupClass />
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)' == 'Debug' ">
    <Optimize>False</Optimize>
    <OutputPath>bin\Android\</OutputPath>
    <DefineConstants>DEBUG;TRACE;Android;</DefineConstants>
    <CaptureConsoleOutput>False</CaptureConsoleOutput>
    <StartMode>Project</StartMode>
    <RegisterForComInterop>False</RegisterForComInterop>
    <CpuType>anycpu</CpuType>
    <RuntimeVersion>v25</RuntimeVersion>
    <XmlDoc>False</XmlDoc>
    <XmlDocWarningLevel>WarningOnPublicMembers</XmlDocWarningLevel>
    <EnableUnmanagedDebugging>False</EnableUnmanagedDebugging>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)' == 'Release' ">
    <Optimize>true</Optimize>
    <OutputPath>bin\Android\</OutputPath>
    <GenerateDebugInfo>True</GenerateDebugInfo>
    <DefineConstants>Android;</DefineConstants>
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
  </PropertyGroup>
  <ItemGroup>
    <Reference Include="android.jar" />
    <Reference Include="com.remobjects.elements.rtl.jar">
      <Private>False</Private>
    </Reference>
  </ItemGroup>
  <ItemGroup>
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
    <ProjectReference Include="..\Sugar\Sugar.Cooper.Android.oxygene">
      <Name>Sugar.Cooper.Android</Name>
      <Project>{8dac177a-64eb-4175-ac9c-e6b121b6f34b}</Project>
      <Private>True</Private>
      <HintPath>..\Sugar\bin\Android\sugar.jar</HintPath>
    </ProjectReference>
  </ItemGroup>
  <Import Project="$(MSBuildExtensionsPath)\RemObjects Software\Oxygene\RemObjects.Oxygene.Cooper.Android.targets" />
  <PropertyGroup>
    <PreBuildEvent>rmdir /s /q $(ProjectDir)\Obj</PreBuildEvent>
  </PropertyGroup>
</Project>
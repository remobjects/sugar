<?xml version="1.0" encoding="utf-8"?>
<Project DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003" ToolsVersion="4.0">
  <PropertyGroup>
    <ProductVersion>3.5</ProductVersion>
    <ProjectGuid>{fcf05218-9631-4c24-a6b7-8c78434cad94}</ProjectGuid>
    <OutputType>Library</OutputType>
    <Configuration Condition="'$(Configuration)' == ''">Release</Configuration>
    <AllowLegacyCreate>False</AllowLegacyCreate>
    <Name>sugar.cooper.android.test</Name>
    <RootNamespace>sugar.cooper.android.test</RootNamespace>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)' == 'Debug' ">
    <Optimize>false</Optimize>
    <OutputPath>.\bin\Debug\Android</OutputPath>
    <DefineConstants>DEBUG;TRACE;</DefineConstants>
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
    <EnableUnmanagedDebugging>False</EnableUnmanagedDebugging>
    <WarnOnCaseMismatch>True</WarnOnCaseMismatch>
  </PropertyGroup>
  <ItemGroup>
    <Folder Include="Main\" />
    <Folder Include="Properties\" />
    <Folder Include="Main\Android\" />
    <Folder Include="res\" />
    <Folder Include="res\drawable-hdpi\" />
    <Folder Include="res\drawable-ldpi\" />
    <Folder Include="res\drawable-mdpi\" />
    <Folder Include="res\drawable-xhdpi\" />
    <Folder Include="res\values\" />
    <Folder Include="res\layout\" />
    <Folder Include="Printer\" />
    <Folder Include="Tests" />
  </ItemGroup>
  <ItemGroup>
    <None Include="res\values\strings.android-xml">
      <SubType>Content</SubType>
    </None>
    <None Include="res\layout\main.layout-xml">
      <SubType>Content</SubType>
    </None>
    <None Include="res\drawable-hdpi\icon.png">
      <SubType>Content</SubType>
    </None>
    <None Include="res\drawable-mdpi\icon.png">
      <SubType>Content</SubType>
    </None>
    <None Include="res\drawable-ldpi\icon.png">
      <SubType>Content</SubType>
    </None>
    <None Include="res\drawable-xhdpi\icon.png">
      <SubType>Content</SubType>
    </None>
  </ItemGroup>
  <ItemGroup>
    <AndroidManifest Include="Properties\AndroidManifest.android-xml" />
  </ItemGroup>
  <ItemGroup>
    <Reference Include="android.jar" />
    <Reference Include="com.remobjects.oxygene.rtl.jar">
      <Private>True</Private>
    </Reference>
  </ItemGroup>
  <ItemGroup>
    <Compile Include="Main\Android\MainActivity.pas" />
    <Compile Include="Printer\Printer.pas" />
    <Compile Include="Tests\Binary.pas" />
    <Compile Include="Tests\DateTime.pas" />
    <Compile Include="Tests\Guid.pas" />
    <Compile Include="Tests\HashSet.pas" />
    <Compile Include="Tests\List.pas" />
    <Compile Include="Tests\Stack.pas" />
    <Compile Include="Tests\String.pas" />
    <Compile Include="Tests\StringBuilder.pas" />
  </ItemGroup>
  <ItemGroup>
    <ProjectReference Include="..\Sugar.TestFramework\RemObjects.Oxygene.Sugar.Cooper.TestFramework.oxygene">
      <Name>RemObjects.Oxygene.Sugar.Cooper.TestFramework</Name>
      <Project>{dba17ca8-59bc-4544-a0f5-c632737d5aa0}</Project>
      <Private>True</Private>
      <HintPath>..\Sugar.TestFramework\bin\Debug\RemObjects.Oxygene.Sugar.TestFramework.jar</HintPath>
    </ProjectReference>
    <ProjectReference Include="..\Sugar\RemObjects.Oxygene.Sugar.Cooper.oxygene">
      <Name>RemObjects.Oxygene.Sugar.Cooper</Name>
      <Project>{d1ee6c41-515b-4175-873f-ee188ac43450}</Project>
      <Private>True</Private>
      <HintPath>..\Sugar\bin\Debug\Java\RemObjects.Oxygene.Sugar.jar</HintPath>
    </ProjectReference>
  </ItemGroup>
  <Import Project="$(MSBuildExtensionsPath)\RemObjects Software\Oxygene\RemObjects.Oxygene.Cooper.Android.targets" />
  <PropertyGroup>
    <PreBuildEvent />
  </PropertyGroup>
</Project>
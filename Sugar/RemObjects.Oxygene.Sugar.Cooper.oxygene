<?xml version="1.0" encoding="utf-8"?>
<Project DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003" ToolsVersion="4.0">
  <PropertyGroup>
    <ProductVersion>3.5</ProductVersion>
    <OutputType>Library</OutputType>
    <Configuration Condition="'$(Configuration)' == ''">Release</Configuration>
    <AllowLegacyCreate>False</AllowLegacyCreate>
    <Name>RemObjects.Oxygene.Sugar.Cooper</Name>
    <RootNamespace>RemObjects.Oxygene.Sugar</RootNamespace>
    <ProjectGuid>{d1ee6c41-515b-4175-873f-ee188ac43450}</ProjectGuid>
    <AssemblyName>RemObjects.Oxygene.Sugar</AssemblyName>
    <DefaultUses />
    <StartupClass />
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)' == 'Debug' ">
    <Optimize>False</Optimize>
    <OutputPath>bin\Debug\</OutputPath>
    <DefineConstants>DEBUG;TRACE</DefineConstants>
    <CaptureConsoleOutput>False</CaptureConsoleOutput>
    <StartMode>Project</StartMode>
    <RegisterForComInterop>False</RegisterForComInterop>
    <CpuType>anycpu</CpuType>
    <RuntimeVersion>v25</RuntimeVersion>
    <XmlDoc>False</XmlDoc>
    <XmlDocWarningLevel>WarningOnPublicMembers</XmlDocWarningLevel>
    <WarnOnCaseMismatch>True</WarnOnCaseMismatch>
    <EnableUnmanagedDebugging>False</EnableUnmanagedDebugging>
    <SuppressWarnings />
    <FutureHelperClassName />
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)' == 'Release' ">
    <OutputPath>bin\Release\</OutputPath>
    <GenerateDebugInfo>False</GenerateDebugInfo>
    <EnableAsserts>False</EnableAsserts>
    <CaptureConsoleOutput>False</CaptureConsoleOutput>
    <StartMode>Project</StartMode>
    <RegisterForComInterop>False</RegisterForComInterop>
    <CpuType>anycpu</CpuType>
    <RuntimeVersion>v25</RuntimeVersion>
    <XmlDoc>False</XmlDoc>
    <XmlDocWarningLevel>WarningOnPublicMembers</XmlDocWarningLevel>
    <WarnOnCaseMismatch>True</WarnOnCaseMismatch>
    <EnableUnmanagedDebugging>False</EnableUnmanagedDebugging>
    <DefineConstants>
    </DefineConstants>
    <SuppressWarnings />
    <FutureHelperClassName />
  </PropertyGroup>
  <ItemGroup>
    <Reference Include="com.remobjects.oxygene.rtl.jar">
      <Private>True</Private>
    </Reference>
    <Reference Include="rt.jar" />
  </ItemGroup>
  <ItemGroup>
    <Compile Include="AutoreleasePool.pas" />
    <Compile Include="Binary.pas" />
    <Compile Include="Collections\Dictionary.pas" />
    <Compile Include="Collections\HashSet.pas" />
    <Compile Include="Collections\List.pas" />
    <Compile Include="Collections\Queue.pas" />
    <Compile Include="Collections\Stack.pas" />
    <Compile Include="Color.pas" />
    <Compile Include="Console.pas" />
    <Compile Include="Cooper\ArrayUtils.pas" />
    <Compile Include="Cooper\EnumerationSequence.pas" />
    <Compile Include="Crypto\Cipher.pas">
      <SubType>Code</SubType>
    </Compile>
    <Compile Include="Crypto\Digest.pas" />
    <Compile Include="DateTime.pas" />
    <Compile Include="DateFormatter.pas" />
    <Compile Include="HTTP.pas" />
    <Compile Include="IO\File.pas" />
    <Compile Include="IO\Folder.pas" />
    <Compile Include="IO\StandardFolders.pas" />
    <Compile Include="Random.pas" />
    <Compile Include="Environment.pas" />
    <Compile Include="Exceptions.pas" />
    <Compile Include="Guid.pas" />
    <Compile Include="StringFormatter.pas" />
    <Compile Include="Threading\AutoResetEvent.pas" />
    <Compile Include="Threading\ManualResetEvent.pas" />
    <Compile Include="Threading\Semaphore.pas" />
    <Compile Include="Threading\Thread.pas" />
    <Compile Include="Threading\ThreadPool.pas" />
    <Compile Include="UserSettings.pas" />
    <Compile Include="Math.pas" />
    <Compile Include="String.pas" />
    <Compile Include="StringBuilder.pas" />
    <Compile Include="Url.pas" />
    <Compile Include="XML\XmlAttribute.pas" />
    <Compile Include="XML\XmlCharacterData.pas" />
    <Compile Include="XML\XmlDocument.pas" />
    <Compile Include="XML\XmlDocumentType.pas" />
    <Compile Include="XML\XmlElement.pas" />
    <Compile Include="XML\XmlNode.pas" />
    <Compile Include="XML\XmlProcessingInstruction.pas" />
  </ItemGroup>
  <ItemGroup>
    <Folder Include="Cooper" />
    <Folder Include="Collections" />
    <Folder Include="IO" />
    <Folder Include="Crypto" />
    <Folder Include="Threading" />
    <Folder Include="Properties\" />
    <Folder Include="XML\" />
  </ItemGroup>
  <Import Project="$(MSBuildExtensionsPath)\RemObjects Software\Oxygene\RemObjects.Oxygene.Cooper.targets" />
  <PropertyGroup>
    <PreBuildEvent />
  </PropertyGroup>
</Project>
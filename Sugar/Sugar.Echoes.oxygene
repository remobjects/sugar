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
    </ItemGroup>
    <ItemGroup>
        <Compile Include="AutoreleasePool.pas"/>
        <Compile Include="Binary.pas"/>
        <Compile Include="Collections\Dictionary.pas"/>
        <Compile Include="Collections\HashSet.pas"/>
        <Compile Include="Collections\KeyValue.pas"/>
        <Compile Include="Collections\List.pas"/>
        <Compile Include="Collections\Queue.pas"/>
        <Compile Include="Collections\Stack.pas"/>
        <Compile Include="Color.pas"/>
        <Compile Include="Consts.pas"/>
        <Compile Include="Convert.pas"/>
        <None Include="Cryptography\Cipher.pas"/>
        <Compile Include="Cryptography\MessageDigest.pas"/>
        <Compile Include="Cryptography\Utils.pas"/>
        <Compile Include="DateTime.pas"/>
        <Compile Include="DateFormatter.pas"/>
        <Compile Include="Encoding.pas"/>
        <Compile Include="HTTP.pas"/>
        <Compile Include="IO\File.pas"/>
        <Compile Include="IO\FileHandle.pas"/>
        <Compile Include="IO\FileUtils.pas"/>
        <Compile Include="IO\Folder.pas"/>
        <Compile Include="IO\FolderUtils.pas"/>
        <Compile Include="IO\Path.pas"/>
        <Compile Include="Random.pas"/>
        <Compile Include="Environment.pas"/>
        <Compile Include="Exceptions.pas"/>
        <Compile Include="Extensions.pas"/>
        <Compile Include="Guid.pas"/>
        <None Include="Threading\AutoResetEvent.pas"/>
        <None Include="Threading\ManualResetEvent.pas"/>
        <None Include="Threading\Semaphore.pas"/>
        <None Include="Threading\Thread.pas"/>
        <None Include="Threading\ThreadPool.pas"/>
        <Compile Include="Reflection\MethodInfo.pas"/>
        <Compile Include="Reflection\ParameterInfo.pas"/>
        <Compile Include="Reflection\Type.pas"/>
        <Compile Include="UserSettings.pas"/>
        <Compile Include="Math.pas"/>
        <Compile Include="Properties\AssemblyInfo.pas"/>
        <Compile Include="String.pas"/>
        <Compile Include="StringBuilder.pas"/>
        <Compile Include="StringFormatter.pas"/>
        <Compile Include="Url.pas"/>
        <Compile Include="XML\XmlAttribute.pas"/>
        <Compile Include="XML\XmlCharacterData.pas"/>
        <Compile Include="XML\XmlDocument.pas"/>
        <Compile Include="XML\XmlDocumentType.pas"/>
        <Compile Include="XML\XmlElement.pas"/>
        <Compile Include="XML\XmlNode.pas"/>
        <Compile Include="XML\XmlProcessingInstruction.pas"/>
        <Compile Include="Collections\LINQ.pas"/>
    </ItemGroup>
    <ItemGroup>
        <Folder Include="Cryptography"/>
        <Folder Include="Reflection"/>
        <Folder Include="XML"/>
        <Folder Include="Properties\"/>
        <Folder Include="Collections"/>
        <Folder Include="Threading"/>
        <Folder Include="IO"/>
    </ItemGroup>
    <Import Project="$(MSBuildExtensionsPath)\RemObjects Software\Oxygene\RemObjects.Oxygene.Echoes.targets"/>
    <PropertyGroup>
        <PreBuildEvent Condition="'$(OS)' != 'Unix'">rmdir /s /q $(ProjectDir)\Obj</PreBuildEvent>
    </PropertyGroup>
</Project>
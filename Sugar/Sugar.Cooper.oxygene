<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<Project xmlns="http://schemas.microsoft.com/developer/msbuild/2003" DefaultTargets="Build" ToolsVersion="4.0">
    <PropertyGroup>
        <ProductVersion>3.5</ProductVersion>
        <OutputType>Library</OutputType>
        <Configuration Condition="'$(Configuration)' == ''">Release</Configuration>
        <AllowLegacyCreate>False</AllowLegacyCreate>
        <Name>Sugar.Cooper</Name>
        <RootNamespace>sugar</RootNamespace>
        <ProjectGuid>{d1ee6c41-515b-4175-873f-ee188ac43450}</ProjectGuid>
        <AssemblyName>sugar</AssemblyName>
    </PropertyGroup>
    <PropertyGroup Condition=" '$(Configuration)' == 'Debug' ">
        <Optimize>False</Optimize>
        <OutputPath>bin\Java\</OutputPath>
        <DefineConstants>DEBUG;TRACE</DefineConstants>
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
        <OutputPath>bin\Java\</OutputPath>
        <GenerateDebugInfo>True</GenerateDebugInfo>
        <EnableAsserts>False</EnableAsserts>
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
        <Reference Include="com.remobjects.elements.rtl.jar">
            <Private>True</Private>
        </Reference>
        <Reference Include="rt.jar"/>
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
        <Compile Include="Cooper\EnumerationSequence.pas"/>
        <Compile Include="Cooper\LocaleUtils.pas"/>
        <None Include="Cryptography\Cipher.pas"/>
        <Compile Include="Cryptography\MessageDigest.pas"/>
        <Compile Include="Cryptography\Utils.pas"/>
        <Compile Include="Consts.pas"/>
        <Compile Include="Convert.pas"/>
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
        <Compile Include="StringFormatter.pas"/>
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
        <Compile Include="String.pas"/>
        <Compile Include="StringBuilder.pas"/>
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
        <Folder Include="Cooper"/>
        <Folder Include="Collections"/>
        <Folder Include="IO"/>
        <Folder Include="Cryptography"/>
        <Folder Include="Reflection"/>
        <Folder Include="Threading"/>
        <Folder Include="Properties\"/>
        <Folder Include="XML\"/>
    </ItemGroup>
    <Import Project="$(MSBuildExtensionsPath)\RemObjects Software\Oxygene\RemObjects.Oxygene.Cooper.targets"/>
    <PropertyGroup>
      <PreBuildEvent Condition="'$(OS)' != 'Unix'">rmdir /s /q $(ProjectDir)\Obj</PreBuildEvent>
    </PropertyGroup>
</Project>

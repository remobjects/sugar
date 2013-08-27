<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<Project xmlns="http://schemas.microsoft.com/developer/msbuild/2003" ToolsVersion="4.0" DefaultTargets="Build">
    <PropertyGroup>
        <Configuration Condition=" '$(Configuration)' == '' ">Debug</Configuration>
        <Platform Condition=" '$(Platform)' == '' ">AnyCPU</Platform>
        <ProjectGuid>3ab69816-9882-4fa6-abe5-c146199f5279</ProjectGuid>
        <OutputType>Library</OutputType>
        <AppDesignerFolder>Properties</AppDesignerFolder>
        <RootNamespace>RemObjects.Oxygene.Sugar.Echoes.WinRT</RootNamespace>
        <AssemblyName>RemObjects.Oxygene.Sugar.Echoes.WinRT</AssemblyName>
        <DefaultLanguage>en-US</DefaultLanguage>
        <ProjectTypeGuids>{BC8A1FFA-BEE3-4634-8014-F334798102B3};{656346D9-4656-40DA-A068-22D5425D4639}</ProjectTypeGuids>
        <Name>RemObjects.Oxygene.Sugar.Echoes.WinRT</Name>
    </PropertyGroup>
    <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Debug|AnyCPU' ">
        <GeneratePDB>True</GeneratePDB>
        <GenerateMDB>False</GenerateMDB>
        <Optimize>false</Optimize>
        <OutputPath>bin\Debug\</OutputPath>
        <DefineConstants>DEBUG;TRACE;NETFX_CORE</DefineConstants>
    </PropertyGroup>
    <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Release|AnyCPU' ">
        <GeneratePDB>True</GeneratePDB>
        <GenerateMDB>False</GenerateMDB>
        <Optimize>true</Optimize>
        <OutputPath>bin\Release\</OutputPath>
        <DefineConstants>TRACE;NETFX_CORE</DefineConstants>
    </PropertyGroup>
    <PropertyGroup Condition="'$(Configuration)|$(Platform)' == 'Debug|ARM'">
        <GeneratePDB>True</GeneratePDB>
        <GenerateMDB>False</GenerateMDB>
        <OutputPath>bin\ARM\Debug\</OutputPath>
        <DefineConstants>DEBUG;TRACE;NETFX_CORE</DefineConstants>
        <CpuType>ARM</CpuType>
        <Prefer32Bit>true</Prefer32Bit>
    </PropertyGroup>
    <PropertyGroup Condition="'$(Configuration)|$(Platform)' == 'Release|ARM'">
        <GeneratePDB>True</GeneratePDB>
        <GenerateMDB>False</GenerateMDB>
        <OutputPath>bin\ARM\Release\</OutputPath>
        <DefineConstants>TRACE;NETFX_CORE</DefineConstants>
        <Optimize>true</Optimize>
        <CpuType>ARM</CpuType>
        <Prefer32Bit>true</Prefer32Bit>
    </PropertyGroup>
    <PropertyGroup Condition="'$(Configuration)|$(Platform)' == 'Debug|x64'">
        <GeneratePDB>True</GeneratePDB>
        <GenerateMDB>False</GenerateMDB>
        <OutputPath>bin\x64\Debug\</OutputPath>
        <DefineConstants>DEBUG;TRACE;NETFX_CORE</DefineConstants>
        <CpuType>x64</CpuType>
        <Prefer32Bit>true</Prefer32Bit>
    </PropertyGroup>
    <PropertyGroup Condition="'$(Configuration)|$(Platform)' == 'Release|x64'">
        <GeneratePDB>True</GeneratePDB>
        <GenerateMDB>False</GenerateMDB>
        <OutputPath>bin\x64\Release\</OutputPath>
        <DefineConstants>TRACE;NETFX_CORE</DefineConstants>
        <Optimize>true</Optimize>
        <CpuType>x64</CpuType>
        <Prefer32Bit>true</Prefer32Bit>
    </PropertyGroup>
    <PropertyGroup Condition="'$(Configuration)|$(Platform)' == 'Debug|x86'">
        <GeneratePDB>True</GeneratePDB>
        <DebugSymbols>true</DebugSymbols>
        <OutputPath>bin\Debug\</OutputPath>
        <DefineConstants>DEBUG;TRACE;NETFX_CORE</DefineConstants>
        <CpuType>x86</CpuType>
        <Prefer32Bit>true</Prefer32Bit>
        <XmlDocWarningLevel>WarningOnPublicMembers</XmlDocWarningLevel>
    </PropertyGroup>
    <PropertyGroup Condition="'$(Configuration)|$(Platform)' == 'Release|x86'">
        <GeneratePDB>True</GeneratePDB>
        <GenerateMDB>False</GenerateMDB>
        <OutputPath>bin\x86\Release\</OutputPath>
        <DefineConstants>TRACE;NETFX_CORE</DefineConstants>
        <Optimize>true</Optimize>
        <CpuType>x86</CpuType>
        <Prefer32Bit>true</Prefer32Bit>
    </PropertyGroup>
    <ItemGroup>
        <!-- A reference to the entire .Net Framework and Windows SDK are automatically included -->
        <Folder Include="Collections\"/>
        <Folder Include="IO\"/>
        <Folder Include="Properties\"/>
        <Folder Include="Threading\"/>
        <Folder Include="XML\"/>
    </ItemGroup>
    <ItemGroup>
        <Compile Include="Collections\Dictionary.pas"/>
        <Compile Include="Collections\HashSet.pas"/>
        <Compile Include="Collections\List.pas"/>
        <Compile Include="Collections\Queue.pas"/>
        <Compile Include="Collections\Stack.pas"/>
        <Compile Include="IO\File.pas"/>
        <Compile Include="IO\Folder.pas"/>
        <Compile Include="IO\StandardFolders.pas"/>
        <Compile Include="Threading\AutoResetEvent.pas"/>
        <Compile Include="Threading\ManualResetEvent.pas"/>
        <Compile Include="Threading\Semaphore.pas"/>
        <Compile Include="AutoreleasePool.pas"/>
        <Compile Include="Binary.pas"/>
        <Compile Include="Color.pas"/>
        <Compile Include="DateTime.pas"/>
        <Compile Include="DateFormatter.pas"/>
        <Compile Include="Environment.pas"/>
        <Compile Include="Exceptions.pas"/>
        <Compile Include="Guid.pas"/>
        <Compile Include="Properties\AssemblyInfo_WinRT.pas"/>
        <Compile Include="Math.pas"/>
        <Compile Include="Random.pas"/>
        <Compile Include="String.pas"/>
        <Compile Include="StringBuilder.pas"/>
        <Compile Include="StringFormatter.pas"/>
        <Compile Include="Url.pas"/>
        <Compile Include="UserSettings.pas"/>
        <Compile Include="XML\XmlAttribute.pas"/>
        <Compile Include="XML\XmlCharacterData.pas"/>
        <Compile Include="XML\XmlDocument.pas"/>
        <Compile Include="XML\XmlDocumentType.pas"/>
        <Compile Include="XML\XmlElement.pas"/>
        <Compile Include="XML\XmlNode.pas"/>
        <Compile Include="XML\XmlProcessingInstruction.pas"/>
    </ItemGroup>
    <PropertyGroup Condition=" '$(VisualStudioVersion)' == '' or '$(VisualStudioVersion)' &lt; '11.0' ">
        <VisualStudioVersion>11.0</VisualStudioVersion>
    </PropertyGroup>
    <!-- To modify your build process, add your task inside one of the targets below and uncomment it. 
       Other similar extension points exist, see Microsoft.Common.targets.
  <Target Name="BeforeBuild">
  </Target>
  <Target Name="AfterBuild">
  </Target>
  -->
    <Import Project="$(MSBuildExtensionsPath)\$(MSBuildToolsVersion)\Microsoft.Common.props" Condition="Exists('$(MSBuildExtensionsPath)\$(MSBuildToolsVersion)\Microsoft.Common.props')"/>
    <Import Project="$(MSBuildExtensionsPath)\RemObjects Software\Oxygene\RemObjects.Oxygene.Echoes.WinRT.targets"/>
    <PropertyGroup>
        <PreBuildEvent/>
    </PropertyGroup>
</Project>
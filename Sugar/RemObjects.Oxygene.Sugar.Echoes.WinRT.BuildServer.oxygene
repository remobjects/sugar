<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<Project xmlns="http://schemas.microsoft.com/developer/msbuild/2003" ToolsVersion="4.0" DefaultTargets="Build">
    <PropertyGroup>
        <Configuration Condition=" '$(Configuration)' == '' ">Debug</Configuration>
        <Platform Condition=" '$(Platform)' == '' ">AnyCPU</Platform>
        <ProjectGuid>3ab69816-9882-4fa6-abe5-c146199f5279</ProjectGuid>
        <OutputType>Library</OutputType>
        <AppDesignerFolder>Properties</AppDesignerFolder>
        <RootNamespace>RemObjects.Oxygene.Sugar.Echoes.WinRT</RootNamespace>
        <AssemblyName>RemObjects.Oxygene.Sugar.WinRT</AssemblyName>
        <DefaultLanguage>en-US</DefaultLanguage>
        <ProjectTypeGuids>{BC8A1FFA-BEE3-4634-8014-F334798102B3};{656346D9-4656-40DA-A068-22D5425D4639}</ProjectTypeGuids>
        <Name>RemObjects.Oxygene.Sugar.Echoes.WinRT</Name>
    </PropertyGroup>
    <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Debug|AnyCPU' ">
        <GeneratePDB>True</GeneratePDB>
        <GenerateMDB>False</GenerateMDB>
        <Optimize>false</Optimize>
        <OutputPath>bin\WinRT\</OutputPath>
        <DefineConstants>DEBUG;TRACE;NETFX_CORE</DefineConstants>
    </PropertyGroup>
    <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Release|AnyCPU' ">
        <GeneratePDB>True</GeneratePDB>
        <GenerateMDB>False</GenerateMDB>
        <Optimize>true</Optimize>
        <OutputPath>bin\WinRT\</OutputPath>
        <DefineConstants>TRACE;NETFX_CORE</DefineConstants>
    </PropertyGroup>
    <PropertyGroup Condition="'$(Configuration)|$(Platform)' == 'Debug|ARM'">
        <GeneratePDB>True</GeneratePDB>
        <GenerateMDB>False</GenerateMDB>
        <OutputPath>bin\WinRT\</OutputPath>
        <DefineConstants>DEBUG;TRACE;NETFX_CORE</DefineConstants>
        <CpuType>ARM</CpuType>
        <Prefer32Bit>true</Prefer32Bit>
    </PropertyGroup>
    <PropertyGroup Condition="'$(Configuration)|$(Platform)' == 'Release|ARM'">
        <GeneratePDB>True</GeneratePDB>
        <GenerateMDB>False</GenerateMDB>
        <OutputPath>bin\WinRT\</OutputPath>
        <DefineConstants>TRACE;NETFX_CORE</DefineConstants>
        <Optimize>true</Optimize>
        <CpuType>ARM</CpuType>
        <Prefer32Bit>true</Prefer32Bit>
    </PropertyGroup>
    <PropertyGroup Condition="'$(Configuration)|$(Platform)' == 'Debug|x64'">
        <GeneratePDB>True</GeneratePDB>
        <GenerateMDB>False</GenerateMDB>
        <OutputPath>bin\WinRT\</OutputPath>
        <DefineConstants>DEBUG;TRACE;NETFX_CORE</DefineConstants>
        <CpuType>x64</CpuType>
        <Prefer32Bit>true</Prefer32Bit>
    </PropertyGroup>
    <PropertyGroup Condition="'$(Configuration)|$(Platform)' == 'Release|x64'">
        <GeneratePDB>True</GeneratePDB>
        <GenerateMDB>False</GenerateMDB>
        <OutputPath>bin\WinRT\</OutputPath>
        <DefineConstants>TRACE;NETFX_CORE</DefineConstants>
        <Optimize>true</Optimize>
        <CpuType>x64</CpuType>
        <Prefer32Bit>true</Prefer32Bit>
    </PropertyGroup>
    <PropertyGroup Condition="'$(Configuration)|$(Platform)' == 'Debug|x86'">
        <GeneratePDB>True</GeneratePDB>
        <DebugSymbols>true</DebugSymbols>
        <OutputPath>bin\WinRT\</OutputPath>
        <DefineConstants>DEBUG;TRACE;NETFX_CORE</DefineConstants>
        <CpuType>x86</CpuType>
        <Prefer32Bit>true</Prefer32Bit>
        <XmlDocWarningLevel>WarningOnPublicMembers</XmlDocWarningLevel>
    </PropertyGroup>
    <PropertyGroup Condition="'$(Configuration)|$(Platform)' == 'Release|x86'">
        <GeneratePDB>True</GeneratePDB>
        <GenerateMDB>False</GenerateMDB>
        <OutputPath>bin\WinRT\</OutputPath>
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
    <Compile Include="AutoreleasePool.pas" />
    <Compile Include="Binary.pas" />
    <Compile Include="Collections\Dictionary.pas" />
    <Compile Include="Collections\HashSet.pas" />
    <Compile Include="Collections\List.pas" />
    <Compile Include="Collections\Queue.pas" />
    <Compile Include="Collections\Stack.pas" />
    <Compile Include="Color.pas" />
    <None Include="Crypto\Cipher.pas" />
    <None Include="Crypto\Digest.pas" />
    <Compile Include="DateTime.pas" />
    <Compile Include="DateFormatter.pas" />
    <Compile Include="HTTP.pas" />
    <Compile Include="IO\File.pas" />
    <Compile Include="IO\Folder.pas" />
    <Compile Include="Random.pas" />
    <Compile Include="Environment.pas" />
    <Compile Include="Exceptions.pas" />
    <Compile Include="Extensions.pas" />
    <Compile Include="Guid.pas" />
    <None Include="Threading\AutoResetEvent.pas" />
    <None Include="Threading\ManualResetEvent.pas" />
    <None Include="Threading\Semaphore.pas" />
    <None Include="Threading\Thread.pas" />
    <None Include="Threading\ThreadPool.pas" />
    <Compile Include="UserSettings.pas" />
    <Compile Include="Math.pas" />
    <Compile Include="Properties\AssemblyInfo_WinRT.pas" />
    <Compile Include="String.pas" />
    <Compile Include="StringBuilder.pas" />
    <Compile Include="StringFormatter.pas" />
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
    <Reference Include="mscorlib" >
      <HintPath>Build\WinRT\mscorlib.dll</HintPath>
    </Reference>
    <Reference Include="Windows" >
       <HintPath>Build\WinRT\Windows.winmd</HintPath>
    </Reference>
    <Reference Include="System.Xml" >
       <HintPath>Build\WinRT\System.Xml.dll</HintPath>
    </Reference>
    <Reference Include="System.Xml.Linq" >
       <HintPath>Build\WinRT\System.Xml.Linq.dll</HintPath>
    </Reference>
    <Reference Include="System.Xml.ReaderWriter" >
       <HintPath>Build\WinRT\System.Xml.ReaderWriter.dll</HintPath>
    </Reference>
    <Reference Include="System.Reflection" >
       <HintPath>Build\WinRT\System.Reflection.dll</HintPath>
    </Reference>
    <Reference Include="System.Runtime" >
       <HintPath>Build\WinRT\System.Runtime.dll</HintPath>
    </Reference>
    <Reference Include="System.Runtime.InteropServices" >
       <HintPath>Build\WinRT\System.Runtime.InteropServices.dll</HintPath>
    </Reference>
    <Reference Include="System.System.Globalization" >
       <HintPath>Build\WinRT\System.System.Globalization.dll</HintPath>
    </Reference>
    <Reference Include="System.Runtime.WindowsRuntime" >
       <HintPath>Build\WinRT\System.Runtime.WindowsRuntime.dll</HintPath>
    </Reference>
    <Reference Include="System.Threading" >
       <HintPath>Build\WinRT\System.Threading.dll</HintPath>
    </Reference>
    <Reference Include="System.Threading.Tasks" >
       <HintPath>Build\WinRT\System.Threading.Tasks.dll</HintPath>
    </Reference>
    <Reference Include="System.IO" >
       <HintPath>Build\WinRT\System.XDocument.dll</HintPath>
    </Reference>
    <Reference Include="System.IO" >
       <HintPath>Build\WinRT\System.XDocument.dll</HintPath>
    </Reference>
    <Reference Include="System.Linq" >
       <HintPath>Build\WinRT\System.Linq.dll</HintPath>
    </Reference>
    <Reference Include="System.Collections" >
       <HintPath>Build\WinRT\System.Collections.dll</HintPath>
    </Reference>
    <Reference Include="System.Text.Encoding" >
       <HintPath>Build\WinRT\System.Text.Encoding.dll</HintPath>
    </Reference>
    <Reference Include="System.Diagnostics.Debug" >
       <HintPath>Build\WinRT\System.Diagnostics.Debug.dll</HintPath>
    </Reference>
    <Reference Include="System.Runtime.Extensions" >
       <HintPath>Build\WinRT\System.Runtime.Extensions.dll</HintPath>
    </Reference>
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
    <Import Project="Build\WinRT\Microsoft.Windows.UI.Xaml.Oxygene.targets" />
    <PropertyGroup>
        <PreBuildEvent/>
    </PropertyGroup>
</Project>
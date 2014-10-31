<?xml version="1.0" encoding="utf-8"?>
<Project DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003" ToolsVersion="4.0">
  <PropertyGroup>
    <ProductVersion>3.5</ProductVersion>
    <ProjectGuid>{d6d563f4-0983-4ab5-b167-3e684b6080b2}</ProjectGuid>
    <OutputType>exe</OutputType>
    <Configuration Condition="'$(Configuration)' == ''">Release</Configuration>
    <AllowLegacyCreate>False</AllowLegacyCreate>
    <Name>Sugar.Cooper.Test</Name>
    <RootNamespace>Sugar.Test</RootNamespace>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)' == 'Debug' ">
    <Optimize>False</Optimize>
    <OutputPath>bin\Debug\Java\</OutputPath>
    <DefineConstants>DEBUG;TRACE;</DefineConstants>
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
    <OutputPath>.\bin\Release\Java</OutputPath>
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
  </PropertyGroup>
  <ItemGroup>
    <Reference Include="com.remobjects.elements.rtl.jar">
      <Private>True</Private>
    </Reference>
    <Reference Include="RemObjects.Elements.EUnit.jar">
      <Private>True</Private>
    </Reference>
    <Reference Include="rt.jar" />
  </ItemGroup>
  <ItemGroup>
    <Compile Include="Main\Cooper\Program.pas" />
    <Compile Include="Tests\AutoreleasePool.pas" />
    <Compile Include="Tests\Binary.pas" />
    <Compile Include="Tests\Convert.pas" />
    <Compile Include="Tests\Cryptography\Utils.pas" />
    <Compile Include="Tests\Data\Json\JsonArray.pas" />
    <Compile Include="Tests\Data\Json\JsonObject.pas" />
    <Compile Include="Tests\Data\Json\JsonObjectParser.pas" />
    <Compile Include="Tests\Data\Json\JsonTokenizer.pas" />
    <Compile Include="Tests\Data\Json\JsonValueTest.pas" />
    <Compile Include="Tests\DateTime.pas" />
    <Compile Include="Tests\Dictionary.pas" />
    <Compile Include="Tests\Encoding.pas" />
    <Compile Include="Tests\Extensions.pas" />
    <Compile Include="Tests\Guid.pas" />
    <Compile Include="Tests\HashSet.pas" />
    <Compile Include="Tests\HTTP.pas" />
    <Compile Include="Tests\IO\File.pas" />
    <Compile Include="Tests\IO\FileHandle.pas" />
    <Compile Include="Tests\IO\FileUtils.pas" />
    <Compile Include="Tests\IO\Folder.pas" />
    <Compile Include="Tests\IO\FolderUtils.pas" />
    <Compile Include="Tests\IO\Path.pas" />
    <Compile Include="Tests\List.pas" />
    <Compile Include="Tests\Math.pas" />
    <Compile Include="Tests\MessageDigest.pas" />
    <Compile Include="Tests\Queue.pas" />
    <Compile Include="Tests\Random.pas" />
    <Compile Include="Tests\Stack.pas" />
    <Compile Include="Tests\String.pas" />
    <Compile Include="Tests\StringBuilder.pas" />
    <Compile Include="Tests\Url.pas" />
    <Compile Include="Tests\UserSettings.pas" />
    <Compile Include="Tests\Xml\CharacterData.pas" />
    <Compile Include="Tests\Xml\Document.pas" />
    <Compile Include="Tests\Xml\DocumentType.pas" />
    <Compile Include="Tests\Xml\Element.pas" />
    <Compile Include="Tests\Xml\Node.pas" />
    <Compile Include="Tests\Xml\ProcessingInstruction.pas" />
    <Compile Include="Tests\Xml\TestData.pas" />
  </ItemGroup>
  <ItemGroup>
    <Folder Include="Main\" />
    <Folder Include="Main\Cooper\" />
    <Folder Include="Tests" />
    <Folder Include="Tests\Data\" />
    <Folder Include="Tests\Data\Json\" />
    <Folder Include="Tests\Xml" />
    <Folder Include="Tests\IO" />
    <Folder Include="Tests\Cryptography" />
    <Folder Include="Properties\" />
  </ItemGroup>
  <ItemGroup>
    <ProjectReference Include="..\Sugar.Data\Sugar.Data.Cooper.oxygene">
      <Name>Sugar.Data.Cooper</Name>
      <Project>{83e22c95-cbc5-4977-87f6-0b18b8181703}</Project>
      <Private>True</Private>
      <HintPath>..\Sugar.Data\bin\Java\sugar.data.jar</HintPath>
    </ProjectReference>
    <ProjectReference Include="..\Sugar\Sugar.Cooper.oxygene">
      <Name>Sugar.Cooper</Name>
      <Project>{d1ee6c41-515b-4175-873f-ee188ac43450}</Project>
      <Private>True</Private>
      <HintPath>..\Sugar\bin\Java\sugar.jar</HintPath>
    </ProjectReference>
  </ItemGroup>
  <Import Project="$(MSBuildExtensionsPath)\RemObjects Software\Oxygene\RemObjects.Oxygene.Cooper.targets" />
  <PropertyGroup>
    <PreBuildEvent />
  </PropertyGroup>
</Project>
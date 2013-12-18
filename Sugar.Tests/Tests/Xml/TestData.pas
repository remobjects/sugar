namespace Sugar.Test;

interface

{$HIDE W0} //supress case-mismatch errors

uses
  Sugar;

type
  XmlTestData = public static class
  public
    method RssXml: String;
    method PIXml: String;
    method CharXml: String;
    method DTDXml: String;
  end;

implementation

method XmlTestData.RssXml: String;
begin
  exit "<?xml version=""1.0"" encoding=""UTF-8""?>
<rss version=""2.0""
	xmlns:content=""http://purl.org/rss/1.0/modules/content/""
	xmlns:wfw=""http://wellformedweb.org/CommentAPI/""
	xmlns:dc=""http://purl.org/dc/elements/1.1/""
	xmlns:atom=""http://www.w3.org/2005/Atom""
	xmlns:sy=""http://purl.org/rss/1.0/modules/syndication/""
	xmlns:slash=""http://purl.org/rss/1.0/modules/slash/"">
 <channel>  
	<title>RemObjects Blogs</title>
	<atom:link href=""http://blogs.remobjects.com/feed"" rel=""self"" type=""application/rss+xml"" />
	<link>http://blogs.remobjects.com</link>
	<description>Remobjects Software Blogs</description>
	<lastBuildDate>Mon, 04 Nov 2013 18:10:49 +0000</lastBuildDate>
  <!--Rss-->
	<language>en-US</language>
	<sy:updatePeriod>hourly</sy:updatePeriod>
	<sy:updateFrequency>1</sy:updateFrequency>
	<generator>http://wordpress.org/?v=3.5</generator>
		<item>
		 <title>Announcing the Oxygene &#8220;October 2013&#8243; Update</title>
		 <link>http://blogs.remobjects.com/blogs/mh/2013/11/04/p6509</link>
		 <comments>http://blogs.remobjects.com/blogs/mh/2013/11/04/p6509#comments</comments>
		 <pubDate>Mon, 04 Nov 2013 18:10:49 +0000</pubDate>
		 <dc:creator>marc</dc:creator>
		 <category><![CDATA[iOS]]></category>
		 <category><![CDATA[Nougat]]></category>
		 <category><![CDATA[Oxygene]]></category>
		 <guid isPermaLink=""false"">http://blogs.remobjects.com/?p=6509</guid>
		 <description><![CDATA[Description]]></description>
		 <content:encoded><![CDATA[Content]]></content:encoded>
		 <wfw:commentRss>http://blogs.remobjects.com/blogs/mh/2013/11/04/p6509/feed</wfw:commentRss>
		 <slash:comments>0</slash:comments>
		</item>
	</channel>
</rss>";
end;

class method XmlTestData.PIXml: String;
begin
  exit 
  "<?xml version=""1.0"" encoding=""UTF-8""?>
  <?xml-stylesheet type=""text/xsl"" href=""test""?>
  <?custom?>
  <Root>
    <Readers>
      <User Name=""First"" Id=""1"">      
        <Config xmlns:cfg=""http://example.com/config/"">
          <cfg:mail cfg:verified=""true"">first@example.com</cfg:mail>
          <cfg:autologin>true</cfg:autologin>
          <cfg:savepassword>true</cfg:savepassword>
        </Config>
      </User>
      <User Name=""Second"" Id=""2""/>
      <User Name=""Third"" Id=""3""/>
    </Readers>
    <Admins>
      <User Name=""Admin"" Id=""0""/>
    </Admins>
  </Root>
  ";
end;

class method XmlTestData.CharXml: String;
begin
  exit 
  "<?xml version=""1.0"" encoding=""UTF-8""?>
  <!DOCTYPE html PUBLIC
  ""-//W3C//DTD XHTML 1.0 Transitional//EN""
  ""http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"">  
   <Book>
    <Title>Text</Title>
    <Description><![CDATA[Description]]></Description>
    <!--Comment-->
   </Book>";
end;

class method XmlTestData.DTDXml: String;
begin
  exit
  "<?xml version=""1.0""?>
  <!DOCTYPE note [
  <!ELEMENT note (to,from,heading,body)>
  <!ELEMENT to (#PCDATA)>
  <!ELEMENT from (#PCDATA)>
  <!ELEMENT heading (#PCDATA)>
  <!ELEMENT body (#PCDATA)>
  ]>
  <note>
    <to>Tove</to>
    <from>Jani</from>
    <heading>Reminder</heading>
    <body>Don't forget me this weekend</body>
  </note>";
end;

end.

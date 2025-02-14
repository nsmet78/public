<!-- Conversion XML Designer vers XML Pivot -->
<!-- Remarque : le XML Pivot en sortie est forcement "plat" mais chaque item comporte un attribut @type afin de les différencier  -->

<xsl:stylesheet  version="1.0" xmlns:xml="http://www.w3.org/XML/1998/namespace" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/> 
<xsl:strip-space elements="*"/> 
 
<xsl:template match="/doc"> 
 <xsl:element name="data"> 
 <xsl:apply-templates select="@*|node()"/> 
 </xsl:element> 
 </xsl:template> 
  
 
<xsl:template match="/doc/page"> 
 <xsl:element name="doc"> 
 <xsl:attribute name="type"> 
 <xsl:value-of select="@name"/> 
 </xsl:attribute> 
 <xsl:apply-templates select="@*[name() != 'name']|node()"/> 
 </xsl:element> 
 </xsl:template> 
  
 
<xsl:template match="/doc/page/field|/doc/page/group/line/field"> 
 <xsl:element name="field"> 
 <xsl:attribute name="id"> 
 <xsl:value-of select="@name"/> 
 </xsl:attribute> 
 <xsl:apply-templates select="@*[name() != 'name']|node()"/> 
 </xsl:element> 
 </xsl:template> 
  
 
<xsl:template match="/doc/page/group"> 
 <xsl:element name="list"> 
 <xsl:attribute name="id"> 
 <xsl:value-of select="@name"/> 
 </xsl:attribute> 
 <xsl:apply-templates select="@*[name() != 'name']|node()"/> 
 </xsl:element> 
 </xsl:template> 
  
 
<xsl:template match="/doc/page/group/line"> 
 <xsl:element name="item"> 
 <xsl:attribute name="type"> 
 <xsl:value-of select="@name"/> 
 </xsl:attribute> 
 <xsl:apply-templates select="@*[name() != 'name']|node()"/> 
 </xsl:element> 
 </xsl:template> 
  
 
<xsl:template match="@*|node()"> 
 <xsl:copy> 
 <xsl:apply-templates select="@*|node()"/> 
 </xsl:copy> 
 </xsl:template> 
  
</xsl:stylesheet> 
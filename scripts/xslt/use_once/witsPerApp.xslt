<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:h="http://www.w3.org/1999/xhtml"
  xmlns:d="http://www.oxygenxml.com/ns/doc/xsl"
  exclude-result-prefixes="#all"
  xmlns:xi="http://www.w3.org/2001/XInclude"
  xmlns="http://www.tei-c.org/ns/1.0"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  version="2.0">

  <d:doc>
    <d:desc>To use:
      <h:tt>time saxon.bash one-offs/appsOnly.xslt data/on_walden_pond.xml | xmllint --format - | perl -pe 's,&lt;apps>,&lt;apps>\n,g;s,&lt;/app>,&lt;/app>\n,g;' | nons > /tmp/appsOnly.xml</h:tt>
    </d:desc>
  </d:doc>
 
  <xsl:output method="xml" indent="yes"/>
  
  <xsl:template match="/*">
    <apps>
      <xsl:apply-templates select="//app"/>
    </apps>
  </xsl:template>
  
  <xsl:template match="app">
    <xsl:text>&#x0A;</xsl:text>
    <xsl:value-of select="concat('app ',@xml:id,':')"/>
    <xsl:if test="processing-instruction()">
      <xsl:text>&#x0A;</xsl:text>
      <xsl:apply-templates select="processing-instruction()"/>
    </xsl:if>
    <xsl:apply-templates select="lem|rdg"/>
  </xsl:template>
  
  <xsl:template match="lem|rdg">
    <xsl:text>&#x0A;</xsl:text>
    <xsl:value-of select="concat('  ',substring(local-name(.),1,1),'=',@wit)"/>
  </xsl:template>

  <xsl:template match="processing-instruction()">
    <xsl:copy/>
  </xsl:template>

</xsl:stylesheet>
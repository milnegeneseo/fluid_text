<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:d="http://www.oxygenxml.com/ns/doc/xsl"
  exclude-result-prefixes="d"
  xmlns="http://www.tei-c.org/ns/1.0"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  version="2.0">
  
  <d:doc scope="stylesheet">
    <d:desc>
      <d:p>Reads in a text from the Digital Thoreau project and writes
      out a version of the same with the <tt>xml:id</tt>s of cardinal
        versions fixed up for use in the Versioning Machine.</d:p>
      <d:p>Written 2013-12-08 by Syd Bauman for the Digital Thoreau project at SUNY Geneseo.</d:p>
      <d:p>Copyleft 2013 Syd Bauman: although I haven't fretted over a particular license
        yet, this is open source software. Nobody, including those who wrote or paid for it
        (the Digital Thoreau project at SUNY Geneseo) can tell you that you can't copy, use,
        modify, or publish this code. (We can ask that you acknowledge us, though.)
      You, of course, can not release this or the modified version any more restrictively.</d:p>
    </d:desc>
  </d:doc>
  
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="witness/@xml:id | change/@xml:id | @wit | @change[not(parent::ab)]">
    <xsl:attribute name="{name(.)}">
      <xsl:choose>
        <xsl:when test="contains( . ,'wc_0')">
          <xsl:value-of select="replace( upper-case(.), 'WC_0','Version_')"/>
        </xsl:when>
        <xsl:when test="contains( . ,'wc_base')">
          <xsl:value-of select="replace( ., 'wc_base','Princeton_Ed')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>
  
</xsl:stylesheet>

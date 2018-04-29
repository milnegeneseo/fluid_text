<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <xsl:template match="@*|node()" priority="1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="comment()[contains(.,'&amp;')]" priority="2">
    <xsl:message><xsl:value-of select="."/> -> <xsl:value-of select="replace( ., '&amp;amp;','&amp;')"/>?</xsl:message>
    <xsl:copy>
      <xsl:value-of select="replace( ., '&amp;amp;','&amp;')"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>

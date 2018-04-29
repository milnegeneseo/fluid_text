<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:h="http://www.w3.org/1999/xhtml"
  xmlns:d="http://www.oxygenxml.com/ns/doc/xsl"
  exclude-result-prefixes="xs d h"
  xmlns="http://www.tei-c.org/ns/1.0"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  version="2.0">
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="lem[contains(@wit,'_c')]">
    <lem wit="#wc_base">
      <xsl:apply-templates select="node()"/>
    </lem>
    <xsl:text>&#x0A;</xsl:text>
    <rdg wit="#wc_b #wc_c">
      <xsl:apply-templates select="node()"/>
    </rdg>
  </xsl:template>
  
</xsl:stylesheet>
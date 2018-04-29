<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:d="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:h="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="xs d h"
  xmlns="http://www.tei-c.org/ns/1.0"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0" version="2.0">

  <d:doc scope="stylesheet">
    <d:desc>
      <d:p>separate <h:tt>&lt;rdg></h:tt> elements that have
      multiple values in <h:tt>@wit</h:tt> into multiple
      <h:tt>&lt;rdg></h:tt>s that have single values on
      <h:tt>@wit</h:tt>.</d:p>
      <d:p>Copyleft 2013 Syd Bauman: although I haven't fretted over a
      particular license yet, this is open source software. Nobody,
      including those who wrote or paid for it (Digital Thoreau at
      SUNY Geneseo) can tell you that you can't copy, use, modify, or
      publish this code. (We can ask that you acknowledge us, though.)
      You, of course, can not release this or the modified version any
      more restrictively.</d:p>
    </d:desc>
  </d:doc>

  <xsl:output method="xml" indent="yes"/>
  
  <!--
    identity transform: anything not matched below (which is only
    <rdg> and its descendants) is just copied
  -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/">
    <xsl:apply-templates select="node()"/>
  </xsl:template>

  <xsl:template match="rdg">
    <xsl:variable name="me" select="."/>
    <xsl:variable name="wits" select="tokenize( normalize-space(@wit),' ')"/>
    <xsl:for-each select="$wits">
      <rdg>
        <xsl:apply-templates select="$me/@* except $me/@wit"/>
        <xsl:attribute name="wit" select="."/>
        <xsl:apply-templates select="$me/node()"/>
      </rdg>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>

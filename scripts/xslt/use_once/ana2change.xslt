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
      out a version of the same with <tt>&lt;witness></tt> elements turned into
        <tt>&lt;change></tt> elements, and <tt>@ana</tt> into <tt>@change</tt>.</d:p>
      <d:p>Written 2014-01 by Syd Bauman for the Digital Thoreau project at SUNY Geneseo.</d:p>
      <d:p>Modified 2014-01-14 by Joe Easterly: Also remove note elements with a resp= of
        "harding", and remove processing instructions.</d:p>
      <d:p>Copyleft 2014 Syd Bauman: although I haven't fretted over a particular license
        yet, this is open source software. Nobody, including those who wrote or paid for it
        (Digital Thoreau project at SUNY Geneseo) can tell you that you can't copy, use,
        modify, or publish this code. (We can ask that you acknowledge us, though.)
      You, of course, can not release this or the modified version any more restrictively.</d:p>
    </d:desc>
  </d:doc>
  
  <xsl:param name="myfn" select="replace( document-uri(/), '^.*/([^/]+)$','$1')"/>
  
  <xsl:output method="xml" indent="yes"/>
  
  <xsl:template match="/">
    <xsl:apply-templates select="node()"/>
    <xsl:if test="//note[@resp='#harding']">
      <xsl:result-document href="hn{$myfn}">
        <xsl:processing-instruction name="xml-model">href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"</xsl:processing-instruction>
        <xsl:processing-instruction name="xml-model">href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.isosch" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:processing-instruction>
        <TEI>
          <teiHeader>
            <fileDesc>
              <titleStmt>
                <title>Harding's Critical Notes from Walden</title>
              </titleStmt>
              <publicationStmt>
                <publisher>Digital Thoreau Project</publisher>
                <availability>
                  <licence target="http://creativecommons.org/licenses/by-sa/3.0/deed.en_US">
                    <p>This work is licensed under a Creative Commons Attribution-ShareAlike 3.0 Unported
                      License.</p>
                  </licence>
                </availability>
              </publicationStmt>
              <sourceDesc>
                <p>Extracted from svn://bauman.zapto.org/syd/trunk/Documents/ridgeback/digitalThoreau/data/<xsl:value-of select="$myfn"/>#1791
                  by svn://bauman.zapto.org/syd/trunk/Documents/ridgeback/digitalThoreau/one-offs/ana2change.xslt#1791</p>
              </sourceDesc>
            </fileDesc>
          </teiHeader>
          <text>
            <body>
              <div type="notes">
                <xsl:apply-templates select="//note[@resp='#harding']" mode="fix"/>
              </div>
            </body>
          </text>
        </TEI>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="@*|*|text()|comment()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@ana[not( parent::note )]">
    <xsl:attribute name="change" select="."/>
  </xsl:template>
  
  <xsl:template match="listWit"/>
  
  <xsl:template match="encodingDesc">
    <profileDesc>
      <creation>
          <xsl:apply-templates mode="fix"
            select="preceding-sibling::fileDesc//listWit"/>
      </creation>
    </profileDesc>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template mode="fix" match="listWit">
    <listChange>
      <xsl:apply-templates mode="fix" select="@*|node()"/>
    </listChange>
  </xsl:template>
  
  <xsl:template mode="fix" match="witness">
    <change xml:id="{@xml:id}"><xsl:value-of select="."/></change>
  </xsl:template>
  
  <xsl:template match="processing-instruction()"/>
  
  <xsl:template match="note[@resp='#harding']">
    <xsl:variable name="id" select="concat(
      'hn-',
      substring-before( $myfn, '.xml'),
      '-',
      format-number( count(preceding::note[@resp='#harding'] )+1,'000')
      )"/>
    <anchor type="criticalNote-Harding" xml:id="{$id}"/>
  </xsl:template>
  
  <xsl:template match="note" mode="fix">
    <xsl:copy>
      <xsl:variable name="target" select="concat(
        $myfn,
        '#hn-',
        substring-before( $myfn, '.xml'),
        '-',
        format-number( count(preceding::note[@resp='#harding'] )+1,'000')
        )"/>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="target" select="$target"/>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>

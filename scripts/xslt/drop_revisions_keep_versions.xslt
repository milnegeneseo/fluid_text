<?xml version="1.0" encoding="utf-8"?>
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
  
  <xsl:template match="*[self::rdg|self::lem][not( matches( @wit,'wc_(0|ba)') )]"/>
  <xsl:template match="*[self::change|self::witness][not( matches( @xml:id,'wc_(0|ba)') )]" priority="5"/>
  
  <xsl:template match="@wit|@change[not(parent::ab)]|@xml:id[starts-with(.,'wc_')]">
    <xsl:variable name="myElement" select=".."/>
    <xsl:variable name="me" select="."/>
    <xsl:variable name="selWits">
      <xsl:for-each select="distinct-values( tokenize( .,'\s+') )">
        <xsl:if test="matches( ., 'wc_(0|ba)')">
          <xsl:value-of select="concat(.,' ')"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="newWits">
      <xsl:for-each select="distinct-values( tokenize( normalize-space($selWits),'\s+') )">
        <xsl:choose>
          <xsl:when test="matches( ., 'wc_0')">
            <xsl:value-of select="concat('Version_',upper-case( substring-after( .,'wc_0')), ' ')"/>
          </xsl:when>
          <xsl:when test="contains( .,'wc_base')">
            <xsl:text>Princeton_Ed </xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:message>ERROR assigning new witness name to <xsl:value-of
              select="concat( local-name($myElement),'/@',name($me),'=',$me,' (',.,')')"/>.</xsl:message>
            <xsl:value-of select="concat( ., ' ')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>
    <xsl:if test="normalize-space($newWits) ne ''">
      <xsl:attribute name="{name(.)}" select="normalize-space($newWits)"/>
    </xsl:if>
  </xsl:template>

  <!-- Yes, the following templates generates invalid TEI, as it -->
  <!-- leaves the <witList> in the wrong place. Versioning Machine -->
  <!-- doesn't care. -->
  <xsl:template match="listChange">
    <listWit>
      <xsl:apply-templates select="@*|node()"/>
    </listWit>
  </xsl:template>
  <xsl:template match="listChange/change">
    <witness>
      <xsl:apply-templates select="@*|node()"/>
    </witness>
  </xsl:template>
  
</xsl:stylesheet>
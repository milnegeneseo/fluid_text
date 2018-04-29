<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:h="http://www.w3.org/1999/xhtml"
  xmlns:d="http://www.oxygenxml.com/ns/doc/xsl"
  exclude-result-prefixes="#all"
  xmlns="http://www.w3.org/1999/xhtml"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  version="2.0">

  <xsl:template match="/">
    <html>
      <head>
        <title>info</title>
        <style type="text/css">
          td {
          padding: 0.2ex 0.5ex 0.2ex 0.5ex;
          text-align: center;
            }
        </style>
      </head>
      <body>
        <p>Table of information about each <tt>&lt;note type=header></tt> that
        is <em>not</em> inside an <tt>&lt;app></tt>.</p>
        <dl>
          <dt>chap</dt>
          <dd>chapter number</dd>
          <dt>gi</dt>
          <dd>the element type of the closest ancester with a <tt>change=</tt> attr</dd>
          <dt>n=</dt>
          <dd>the value of the <tt>n=</tt> attr of that closest ancestor</dd>
          <dt>change=</dt>
          <dd>the value of the <tt>change=</tt> attr of that closest ancestor</dd>
          <dt>written</dt>
          <dd>the value of the <tt>&lt;seg type=written></tt></dd>
          <dt style="color:red">red</dt>
          <dd>change= and written differ</dd>
          <dt style="color:blue">blue</dt>
          <dd>written is missing</dd>
        </dl>
        <table border="1">
          <tr>
            <td>chap</td>
            <td>gi</td>
            <td><tt>n=</tt></td>
            <td><tt>change=</tt></td>
            <td><i>written</i></td>
          </tr>
          <xsl:apply-templates select="//note[@type='header'][not(ancestor::app)]"/>
        </table>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="note">
    <xsl:variable name="chap" select="ancestor::TEI/@n"/>
    <xsl:variable name="ancCha" select="ancestor::*[@change][1]"/>
    <xsl:variable name="gi" select="local-name($ancCha)"/>
    <xsl:variable name="n" select="$ancCha/@n"/>
    <xsl:variable name="change" select="$ancCha/@change"/>
    <xsl:variable name="written" select="ab[@type='parsed']/seg[@type='written']"/>
    <xsl:variable name="style">
      <xsl:choose>
        <xsl:when test="not($written)">color: blue;</xsl:when>
        <xsl:when test="lower-case( $written ) ne substring-after( $change, '#wc_0')">
          color: red;
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:variable>
    <tr>
      <td style="text-align: right;"><xsl:value-of select="$chap"/></td>
      <td><xsl:value-of select="$gi"/></td>
      <td><tt><xsl:value-of select="$n"/></tt></td>
      <td style="{$style}"><tt><xsl:value-of select="$change"/></tt></td>
      <td style="{$style}"><xsl:value-of select="$written"/></td>
    </tr>
  </xsl:template>

</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  version="2.0">
  
  <!-- run against combined chapters, i.e. the output of -->
  <!-- xmllint ==xinclude ../data/walden.xml -->

  <xsl:variable name="first" select="(
    'wc_0a',
    'wc_0b',
    'wc_0c',
    'wc_0d',
    'wc_0e',
    'wc_0f',
    'wc_0g',
    'wc_0a',
    'wc_0b',
    'wc_0c',
    'wc_0d',
    'wc_0e',
    'wc_0f',
    'wc_0g',
    'wc_0a',
    'wc_0b',
    'wc_0c',
    'wc_0d',
    'wc_0e',
    'wc_0f',
    'wc_0g',
    'wc_a1',
    'wc_b1',
    'wc_c1',
    'wc_d1',
    'wc_e1',
    'wc_f1',
    'wc_g1',
    'wc_a1',
    'wc_b1',
    'wc_c1',
    'wc_d1',
    'wc_e1',
    'wc_f1',
    'wc_g1',
    'wc_a2',
    'wc_b2',
    'wc_c2',
    'wc_d2',
    'wc_e2',
    'wc_f2',
    'wc_g2',
    'wc_a2',
    'wc_b2',
    'wc_c2',
    'wc_d2',
    'wc_e2',
    'wc_f2',
    'wc_g2',
    'wc_a3',
    'wc_b3',
    'wc_c3',
    'wc_d3',
    'wc_e3',
    'wc_f3',
    'wc_g3',
    'wc_a3',
    'wc_b3',
    'wc_c3',
    'wc_d3',
    'wc_e3',
    'wc_f3',
    'wc_g3'
    )"/>
  
  <xsl:variable name="second" select="(
    'wc_a1',
    'wc_b1',
    'wc_c1',
    'wc_d1',
    'wc_e1',
    'wc_f1',
    'wc_g1',
    'wc_a2',
    'wc_b2',
    'wc_c2',
    'wc_d2',
    'wc_e2',
    'wc_f2',
    'wc_g2',
    'wc_a3',
    'wc_b3',
    'wc_c3',
    'wc_d3',
    'wc_e3',
    'wc_f3',
    'wc_g3',
    'wc_a2',
    'wc_b2',
    'wc_c2',
    'wc_d2',
    'wc_e2',
    'wc_f2',
    'wc_g2',
    'wc_a3',
    'wc_b3',
    'wc_c3',
    'wc_d3',
    'wc_e3',
    'wc_f3',
    'wc_g3',
    'wc_a1',
    'wc_b1',
    'wc_c1',
    'wc_d1',
    'wc_e1',
    'wc_f1',
    'wc_g1',
    'wc_a3',
    'wc_b3',
    'wc_c3',
    'wc_d3',
    'wc_e3',
    'wc_f3',
    'wc_g3',
    'wc_a1',
    'wc_b1',
    'wc_c1',
    'wc_d1',
    'wc_e1',
    'wc_f1',
    'wc_g1',
    'wc_a2',
    'wc_b2',
    'wc_c2',
    'wc_d2',
    'wc_e2',
    'wc_f2',
    'wc_g2'
    )"/>
  <xsl:variable name="sequence" select="(
        01, 02, 03, 04, 05, 06, 07, 08, 09,
    10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35, 36, 37, 38, 39,
    40, 41, 42, 43, 44, 45, 46, 47, 48, 49,
    50, 51, 52, 53, 54, 55, 56, 57, 58, 59,
    60, 61, 62, 63
    )"></xsl:variable>
  
  <xsl:template match="/">
    <xsl:variable name="text" select="/teiCorpus/TEI/text"/>
    <html>
      <head>
        <title>Wvc</title>
        <xsl:variable name="date" select="current-dateTime()"/>
        <meta content="generated {current-dateTime()} by svn://bauman.zapto.org/syd/trunk/Documents/ridgeback/digitalThoreau/one-offs/seek.xslt" name="info"/>
        <style type="text/css">
          tr:first-child { background-color: #D8E0E8; }
          td { padding: 1ex; }
        </style>
      </head>
      <body>
        <h1>seeking hard cases in Walden re-work</h1>
        <p>In table below, a &#x2018;conflict&#x2019; is when both occur
        in an <tt>@wit</tt> in a single <tt>&lt;app></tt>.</p>
        <table border="1">
          <tr>
            <td>first</td>
            <td>second</td>
            <td># conflicts</td>
            <td>IDs of conflicts</td>
          </tr>
          <xsl:for-each select="$sequence">
            <xsl:variable name="seq" select="."/>
            <xsl:variable name="one" select="$first[$seq]"/>
            <xsl:variable name="two" select="$second[$seq]"/>
            <xsl:variable name="result"
              select="$text//app[rdg[contains(@wit,$one)] and rdg[contains(@wit,$two)]]"></xsl:variable>
            <tr>
              <td><xsl:value-of select="$one"/></td>
              <td><xsl:value-of select="$two"></xsl:value-of></td>
              <td>
                <xsl:value-of select="count( $result )"/>
              </td>
              <td>
                <xsl:variable name="IDlist">
                  <xsl:apply-templates select="$result"/>
                </xsl:variable>
                <xsl:choose>
                  <xsl:when test="string-length($IDlist) > 0">
                    <xsl:value-of select="$IDlist"/>
                  </xsl:when>
                  <xsl:otherwise><xsl:text>&#xA0;</xsl:text></xsl:otherwise>
                </xsl:choose>
              </td>
            </tr>
          </xsl:for-each>
        </table>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="app">
    <xsl:value-of select="@xml:id"/>
    <xsl:if test="position() &lt; last()">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="unused_stuff_I_started_trying_at_one_point">
    <table border="1">
      <xsl:for-each select="'4', '1', '2', '3'">
        <xsl:variable name="dig" select="."/>
        <xsl:for-each select="'a', 'b', 'c', 'd', 'e', 'f', 'g'">
          <xsl:variable name="let" select="."/>
          <xsl:variable name="first">
            <xsl:choose>
              <xsl:when test="$dig eq '0'">
                <xsl:value-of select="concat( $dig, $let )"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat( $let, $dig )"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <tr>
            <xsl:comment> <xsl:value-of select="$first"/> </xsl:comment>
          </tr>
        </xsl:for-each>
      </xsl:for-each>
    </table>
  </xsl:template>

</xsl:stylesheet>
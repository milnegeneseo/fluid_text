<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:h="http://www.w3.org/1999/xhtml"
  xmlns:d="http://www.oxygenxml.com/ns/doc/xsl"
  exclude-result-prefixes="#all"
  xmlns="http://www.w3.org/1999/xhtml"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  version="2.0">
  
  <d:doc scope="stylesheet">
    <d:desc>
      <d:p>Reads in a text from the Digital Thoreau project and writes
      out a report of any 'rdg' or 'lem' elements that have a wit= value
      that is 'older' than the ana= of their ancestor paragraph</d:p>
        <d:p>Written 2014-01 by Syd Bauman for the Digital Thoreau project at SUNY Geneseo.</d:p>
      <d:p>Copyleft 2014 Syd Bauman: although I haven't fretted over a particular license
        yet, this is open source software. Nobody, including those who wrote or paid for it
        (Digital Thoreau at SUNY Geneseo) can tell you that you can't copy, use,
        modify, or publish this code. (We can ask that you acknowledge us, though.)
      You, of course, can not release this or the modified version any more restrictively.</d:p>
    </d:desc>
  </d:doc>
  
  <xsl:output method="xhtml" indent="yes"/>
  
  <d:doc>
    <d:desc>Create a sequence of pointers to <d:i>witness</d:i>es. Order is
    important, here, as we make inferences based on chronology. Once we have
    this sequence, we can access, e.g., the pointer to the last 1849 draft
    with <d:b>$witness[6]</d:b>.</d:desc>
  </d:doc>
  <xsl:variable name="witnesses" select="(
    '#wc_0a',
    '#wc_a1',
    '#wc_a2',
    '#wc_0b',
    '#wc_b1',
    '#wc_b2',
    '#wc_0c',
    '#wc_c1',
    '#wc_c2',
    '#wc_0d',
    '#wc_d1',
    '#wc_d2',
    '#wc_d3',
    '#wc_0e',
    '#wc_e1',
    '#wc_e2',
    '#wc_e3',
    '#wc_0f',
    '#wc_f1',
    '#wc_f2',
    '#wc_f3',
    '#wc_0g',
    '#wc_g1',
    '#wc_g2',
    '#wc_base'
    )"/>
  
  <xsl:template match="/">
    <html>
      <head>
        <title>wit= older than parent p</title>
      </head>
      <body>
        <table border="1">
          <tr>
            <td>chap</td>
            <td>app</td>
          </tr>
          <xsl:apply-templates select="//*[@wit][ancestor-or-self::*/@change]"/>
        </table>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="*">
    <xsl:variable name="parentWit" select="ancestor-or-self::*[contains(@change,'#wc')][1]/@change"/>
    <xsl:variable name="parentNum" select="index-of( $witnesses, $parentWit )"/>
    <xsl:variable name="lowestWit" select="min( for $wit in distinct-values( .//@wit/tokenize(.,'\s+') ) return index-of( $witnesses, $wit ) )"/>
    <xsl:if test="$parentNum > $lowestWit">
      <tr>
        <td><xsl:value-of select="ancestor::TEI/@n"/></td>
        <td><xsl:value-of select="ancestor::app/@xml:id"/></td>
      </tr>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>

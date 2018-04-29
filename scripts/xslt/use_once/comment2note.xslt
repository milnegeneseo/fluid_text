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
      out a version of the same with certain comments that precede certain
      elements transformed into <tt>&lt;note></tt>s</d:p>
      <d:p>Written 2013-12 by Syd Bauman for the Digital Thoreau project at SUNY Geneseo.</d:p>
      <d:p>Copyleft 2013 Syd Bauman: although I haven't fretted over a particular license
        yet, this is open source software. Nobody, including those who wrote or paid for it
        (Digital Thoreau project at SUNY Geneseo) can tell you that you can't copy, use,
        modify, or publish this code. (We can ask that you acknowledge us, though.)
      You, of course, can not release this or the modified version any more restrictively.</d:p>
    </d:desc>
  </d:doc>
  
  <xsl:output method="xml" indent="yes"/>
  
  <d:doc>
    <d:desc>Exact titles of chapters, in order.</d:desc>
  </d:doc>
  <xsl:variable name="chaps" select="(
    'Economy',
    'Where I Lived, and What I Lived For',
    'Reading',
    'Sounds',
    'Solitude',
    'Visitors',
    'Bean-Field',
    'Village',
    'Ponds',
    'Baker Farm',
    'Higher Laws',
    'Brute Neighbors',
    'The House-Warming',
    'Former Inhabitants',
    'Winter Animals',
    'The Pond in Winter',
    'Spring',
    'Conclusion'
    )"/>
  
  <d:doc>
    <d:desc>a sequence of the chapt</d:desc>
  </d:doc>
  <xsl:variable name="chapRegex">
    <xsl:value-of select="$chaps" separator="|"/>
  </xsl:variable>
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="comment()[contains(.,'&lt;p')]"/>
  <xsl:template match="note
    [parent::p|parent::seg]
    [@resp='#clapper']
    [not(preceding-sibling::*[not(self::note)])]
    "/>
  
  <xsl:template match="
    //*
       [ self::p | self::seg ]
       [ 
         preceding-sibling::comment()
         [1]
         [ following-sibling::*[1] eq current() ]
         [ starts-with( normalize-space(.),'&lt;p' ) ]
       ]
    ">
    <xsl:variable name="comtxt0" select="normalize-space( preceding-sibling::comment()[1] )"/>
    <xsl:variable name="comtxt1" select="replace( $comtxt0, '&lt;/?p[^>]*>','')"/>
    <xsl:variable name="comtxt2" select="concat( normalize-space( $comtxt1 ),'.' )"/>
    <xsl:variable name="comtxt3" select="replace( $comtxt2, '\.\.', '.')"/>
    <xsl:variable name="comtxt4" select="replace( $comtxt3, '&amp;amp;','&amp;')"/>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <note type="header" resp="#clapper">
        <ab type="string"><xsl:value-of select="$comtxt4"/></ab>
        <xsl:variable name="comtxt5" select="substring( $comtxt4, 1, string-length( $comtxt4 )-1 )"/>
        <ab type="parsed">
          <xsl:variable name="regex" select="concat(
            '(',
            $chapRegex,
            ') ([0-9]+[a-z]?.*) (written:? ([^;]*)(; rewritten:? (.*))?|\[not.*)'
            )"/>
          <xsl:analyze-string select="$comtxt5" regex="{$regex}">
            <xsl:matching-substring>
              <xsl:variable name="chapTitle" select="normalize-space( regex-group(1) )"/>
              <xsl:variable name="chapNum" select="index-of( $chaps, $chapTitle )"/>
              <xsl:variable name="para" select="regex-group(2)"/>
              <xsl:variable name="writtenORnot" select="regex-group(3)"/>
              <xsl:variable name="written" select="regex-group(4)"/>
              <xsl:variable name="rewritten" select="normalize-space( regex-group(6) )"/>
              <seg type="chapterNum"><xsl:value-of select="$chapNum"/></seg>
              <seg type="chapterTitle"><xsl:value-of select="$chapTitle"/></seg>
              <seg type="paragraph"><xsl:value-of select="$para"/></seg>
              <xsl:choose>
                <xsl:when test="contains( $writtenORnot, 'not in m')">
                  <anchor type="not-in-MS"/>
                </xsl:when>
                <xsl:otherwise>
                  <seg type="written"><xsl:value-of select="$written"/></seg>
                  <xsl:if test="$rewritten ne ''">
                    <seg type="rewritten"><xsl:value-of select="$rewritten"/></seg>
                  </xsl:if>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
              <xsl:message>'<xsl:value-of select="$comtxt5"/>' !m "<xsl:value-of select="$regex"/>".</xsl:message>
            </xsl:non-matching-substring>
          </xsl:analyze-string>
        </ab>
        <xsl:apply-templates select="note
          [@resp='#clapper']
          [not(preceding-sibling::*[not(self::note)])]" mode="note2ab"/>
      </note>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="note" mode="note2ab">
    <xsl:if test="@type ne 'critical'">
      <xsl:message>What??</xsl:message>
    </xsl:if>
    <ab>
      <xsl:apply-templates select="@* except ( @resp, @type )"/>
      <xsl:apply-templates select="node()"/>
    </ab>
  </xsl:template>

  <!-- 
  patterns to match:
  * CHAPTIT = one of $chaps
  * # = digit+
  * ! = [a-g]
  * @ = [A-G]
  * W = written

    138 CHAPTIT #! W: @; reW: @
    116 CHAPTIT # W: @; reW: @
    103 CHAPTIT #! W: @
     92 CHAPTIT # W: @
     90 CHAPTIT #! W: @; reW: @, @
     34 CHAPTIT # W: @; reW: @, @
     23 CHAPTIT #! W: @; reW: @, @, @
     13 CHAPTIT # [not in manuscript]
      8 CHAPTIT # W: @; reW: @, @, @
      8 CHAPTIT #! W @
      5 CHAPTIT #! W @; reW @
      3 CHAPTIT # W @; reW @, @
      3 CHAPTIT # W @
      3 CHAPTIT # &amp;amp; # W: @
      2 CHAPTIT #! W: @; reW: @, @, @, @
      2 CHAPTIT #! W @; reW @, @, @
      2 CHAPTIT #! W @; reW @, @
      2 CHAPTIT # W @; reW: @
      2 CHAPTIT # W @; reW @
      1 CHAPTIT #! W @ W: @
      1 CHAPTIT #! W: @; reW: @. @, @    # in error?
      1 CHAPTIT #! W: @; reW: @. @       # in error?
      1 CHAPTIT #! W: @; reW: @,@
      1 CHAPTIT #! W: @; reW; @          # in ERROR, fixed
      1 CHAPTIT #! W: @, reW: @, @       # in error? fixed s/,/;/1;
      1 CHAPTIT #, #, # W: @; reW: @
      1 CHAPTIT # W: @; reW: @ , @
      1 CHAPTIT # W @; reW: @, @
      1 CHAPTIT #! [not in manuscript]
      1 CHAPTIT #k W: @, reW: @, @       # in error? fixed s/,/;/1;
      1 CHAPTIT #j W: @; reW: @
      1 CHAPTIT #i W: @; reW: @
      1 CHAPTIT #h W: @; reW: @
  -->
  
  
  
  <!-- my 1st attempt was match="*[ self::p | self::seg ]
                        [
                          ( preceding-sibling::comment() | preceding-sibling::* )
                           [1]
                           [ self::comment() ]
                           [ starts-with( normalize-space(.),'&lt;p' ) ]
                         ]", but that didn't work -->
  
</xsl:stylesheet>

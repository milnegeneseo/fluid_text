<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:d="http://www.oxygenxml.com/ns/doc/xsl"
  exclude-result-prefixes="d"
  xmlns="http://www.tei-c.org/ns/1.0"
  xmlns:h="http://www.w3.org/1999/xhtml"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  version="2.0">

  <d:doc scope="stylesheet">
    <d:desc>
      <d:p>Reprocessing Internal Revisions, take 2</d:p>
      <d:p>Reads in a text from the Digital Thoreau project and writes
        out a version of the same with processing as per “Visualization:
        Reprocessing Internal Revisions”. Note, though, that this version
        tries to handle <h:tt>&lt;rdg></h:tt> elements with more than
        one witness specified on <h:tt>wit=</h:tt>, which (it turns out)
        won’t happen because our input should have already had that <h:tt>&lt;rdg></h:tt>
        split up into multiple <h:tt>&lt;rdg></h:tt>s with one witness each.</d:p>
      <d:p>Written 2013-12-24 by Syd Bauman for the Digital Thoreau project at SUNY Geneseo.</d:p>
      <d:p>Copyleft 2013 Syd Bauman: although I haven’t fretted over a particular license
        yet, this is open source software. Nobody, including those who wrote or paid for it
        (the Digital Thoreau project at SUNY Geneseo) can tell you that you can’t copy, use,
        modify, or publish this code. (We can ask that you acknowledge us, though.)
        You, of course, can not release this or the modified version any more restrictively.</d:p>
    </d:desc>
  </d:doc>

  <xsl:output method="xml" indent="yes"/>
  <xsl:variable name="root" select="/"/>

  <d:doc>
    <d:desc>IDentity transform all except <tt>&lt;app></tt></d:desc>
  </d:doc>
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="app[ not( @type eq 'header') ]">
    <xsl:variable name="me" select="."/>
    <!-- make an array of each witness contained by this <app>, sorted: -->
    <xsl:variable name="mywits" select="string-join( rdg/@wit/normalize-space(), ' ')"/>
    <xsl:variable name="rdgs">
      <xsl:for-each select="distinct-values( tokenize( $mywits,' ') )">
        <xsl:sort/>
        <xsl:variable name="thiswit" select="."/>
        <!-- problem: following template will fire for *each* <rdg> that has this witness. -->
        <!-- sometimes there are 2+ … not sure what we should do in that case -->
        <xsl:apply-templates select="$me/rdg[ contains( @wit, $thiswit ) ]" mode="witrep">
          <!-- the 'witrep' (for copy w/ witness replacement) -->
          <xsl:with-param name="newWit" select="$thiswit"/>
        </xsl:apply-templates>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="num_revs" select="count( $rdgs/rdg[@type='revs'] )"/>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="lem"/>
      <xsl:apply-templates select="$rdgs/rdg[@type='vers']"/>
      <xsl:choose>
        <xsl:when test="$num_revs = 0"/>
        <xsl:when test="$num_revs = 1">
          <xsl:variable name="myself" select="$rdgs/rdg[ @type='revs']"/>
          <xsl:apply-templates select="$rdgs/rdg[ @type='revs']" mode="witrep">
            <xsl:with-param name="newWit" select="replace( $myself/@wit,'wc_([a-z])[1-9]','wc_0$1')"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="$num_revs > 1">
          <xsl:variable name="us" select="$rdgs/rdg[ @type='revs']"/>
          <xsl:variable name="note">
            <note type="revision">
              <xsl:for-each select="$us[ last() > position() ]">
                <xsl:if test="position() > 1">
                  <lb/>
                </xsl:if>
                <xsl:value-of select="upper-case( substring( @wit, 5, 2 ) )"/>
                <xsl:text>: </xsl:text>
                <xsl:apply-templates/>
              </xsl:for-each>
            </note>
          </xsl:variable>
          <xsl:apply-templates select="$us[ position() eq last() ]" mode="witrep">
            <xsl:with-param name="newWit" select="replace( $us[ position() eq last() ]/@wit,'wc_([a-z])[1-9]','wc_0$1')"/>
            <xsl:with-param name="firstChild" select="$note"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise><ERROR/></xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()[ not( self::lem | self::rdg | self::text()[ normalize-space(.) eq '' ] ) ]"/>
    </xsl:copy>
  </xsl:template>

  <d:doc>
    <d:desc>make a copy of a <tt>&lt;rdg></tt> with a different <tt>wit=</tt> attribute
    and an added <tt>type=</tt> attribute</d:desc>
  </d:doc>
  <xsl:template match="rdg" mode="witrep">
    <xsl:param name="newWit"/>
    <xsl:param name="firstChild"/>
    <xsl:copy>
      <xsl:apply-templates select="@* except ( @wit, @type )"/>
      <xsl:attribute name="wit" select="$newWit"/>
      <xsl:attribute name="type">
        <xsl:choose>
          <xsl:when test="matches( $newWit,'wc_0')"         >vers</xsl:when>
          <xsl:when test="matches( $newWit,'wc_[a-z][1-9]')">revs</xsl:when>
          <xsl:otherwise>ERR</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:copy-of select="$firstChild"/>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

  <!--
      <xsl:apply-templates select="$rdgs/rdg[@type='revs']" mode="parentVersOrNote">
        <xsl:sort select="@wit" order="descending"/>
      </xsl:apply-templates>
      ...
  <xsl:template match="rdg" mode="parentVersOrNote">
    <xsl:choose>
      <xsl:when test="position() eq 1">
        <xsl:apply-templates select="." mode="witrep">
          <xsl:with-param name="newWit" select="replace( @wit,'wc_([a-z])[1-9]','wc_0$1')"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>

      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

    <xsl:variable name="witS" select="tokenize( string-join( rdg/@wit/normalize-space(), ' '),' ')"/>
    <xsl:variable name="wits">
        <xsl:for-each select="$witS">
          <xsl:sort/>
          <wit><xsl:value-of select="."/></wit>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="vers">
      <xsl:copy-of select="$wits/wit[ matches(.,'wc_0') ]"/>
    </xsl:variable>
    <xsl:variable name="verS" select="string-join( $vers,' ')"/>
    <xsl:variable name="revs">
        <xsl:copy-of select="$wits/wit[ matches(.,'wc_[a-z][1-9]') ]"/>
    </xsl:variable>
    <xsl:variable name="revS" select="string-join( $revs,' ')"/>
    <xsl:for-each select="tokenize"></xsl:for-each>
 -->
  <!--
-->
</xsl:stylesheet>

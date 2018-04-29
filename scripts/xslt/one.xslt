<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:h="http://www.w3.org/1999/xhtml"
  xmlns:d="http://www.oxygenxml.com/ns/doc/xsl"
  exclude-result-prefixes="xs d h"
  xmlns="http://www.tei-c.org/ns/1.0"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  version="2.0">

  <d:doc scope="stylesheet">
    <d:desc>
      <d:p>Reads in a text from the Digital Thoreau project and writes
      out a version of the same with
      <d:ul>
        <d:li>every extant <h:tt>&lt;app></h:tt> element
          expanded so that there is one <h:tt>&lt;rdg></h:tt> per reading, whether
          present in the input or inferred.</d:li>
        <d:li>every span of text that is in a paragraph but <d:b>not</d:b> inside
        an <d:i>app</d:i> or <d:i>note</d:i> placed inside a new <d:i>app</d:i>
          (which thus won't bear an <d:i>xml:id</d:i> attr) for every witness
          after that listed on the paragraph's <d:i>change</d:i> attribute.</d:li>
      </d:ul>
      </d:p>
      <d:p>Written 2013-07 by Syd Bauman for the Digital Thoreau project at SUNY Geneseo.</d:p>
      <d:p>Copyleft 2013 Syd Bauman: although I haven't fretted over a particular license
        yet, this is open source software. Nobody, including those who wrote or paid for it
        (Digital Thoreau at SUNY Geneseo) can tell you that you can't copy, use,
        modify, or publish this code. (We can ask that you acknowledge us, though.)
      You, of course, can not release this or the modified version any more restrictively.</d:p>
    </d:desc>
  </d:doc>
  
  <xsl:output method="xml" indent="yes"/>
  
  <d:doc>
    <d:desc>a <h:tt>@type</h:tt> value; currently unused</d:desc>
  </d:doc>
  <xsl:variable name="type" select="'auto-inferred'"/>
  
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
  
  <d:doc>
    <d:desc>Create a sequence of pointers like above, but
      only to major versoin <d:i>witness</d:i>es..</d:desc>
  </d:doc>
  <xsl:variable name="versions" select="(
    '#wc_0a',
    '#wc_0b',
    '#wc_0c',
    '#wc_0d',
    '#wc_0e',
    '#wc_0f',
    '#wc_0g',
    '#wc_base'
    )"/>
  
  <d:doc>
    <d:desc>Identity transform</d:desc>
  </d:doc>
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <d:doc>
    <d:desc>There are a few <h:tt>&lt;app></h:tt> elements with no <h:tt>&lt;rdg></h:tt> children;
    I don't know what to do with those. So here we just copy 'em over, but also
    insert a message (in an 'sdb' processing instruction) that warns Joe.</d:desc>
  </d:doc>
  <xsl:template match="app[not(child::rdg)]">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:processing-instruction name="sdb"> hand-process (no &lt;rdg> children) </xsl:processing-instruction>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>
  
  <d:doc>
    <d:desc>When there is an input <h:tt>&lt;app></h:tt> that has <h:tt>&lt;rdg></h:tt> children,
    put it into the output stream with one <h:tt>&lt;rdg></h:tt> child for each possible
    witness. (Yes, that's ridiculously inefficient; but the software DT is using
    is OK with it, and we can then process it down to something more reasonable).</d:desc>
  </d:doc>
  <xsl:template match="app">
    
    <!-- Later we are going to be iterating over the witness pointers, and thus lose -->
    <!-- our current context. So here we save it. "Everyone, remember where we parked" -->
    <xsl:variable name="me" select="."/>
    
    <!-- Ascertain the witness in which this passage first appears (and its index -->
    <!-- number into our array of witnesses) -->
    <xsl:variable name="start">
      <xsl:choose>
        <xsl:when test="ancestor-or-self::*[contains(@change,'#wc')]">
          <!-- Note: we only look for 1 value inside change=, because although -->
          <!-- lots of change= attrs have multiple witness pointers, none of those -->
          <!-- have <app> descendants, so we won't have that situation. -->
          <xsl:value-of select="ancestor-or-self::*[contains(@change,'#wc')][1]/@change"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>#wc_base</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="startNum" select="index-of( $versions, $start )"/>
    
    <!-- Ascertain the latest witness that is explicitly mentioned in the input -->
    <!-- <app>, as an integer -->
    <xsl:variable name="highestMentioned_str">
      <xsl:choose>
        <xsl:when test=".//@wit">
          <xsl:value-of select="max( for $wit in distinct-values( .//@wit/tokenize(.,'\s+') ) return index-of( $versions, $wit ) )"/>
        </xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="highestMentioned" select="xs:integer( $highestMentioned_str )"/>
    
    <!-- Ascertain the earliest witness that is explicitly mentioned in the input -->
    <!-- <app>, as an integer -->
    <xsl:variable name="lowestMentioned_str">
      <xsl:choose>
        <xsl:when test=".//@wit">
          <xsl:value-of select="min( for $wit in distinct-values( .//@wit/tokenize(.,'\s+') ) return index-of( $versions, $wit ) )"/>
        </xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="lowestMentioned" select="xs:integer( $lowestMentioned_str )"/>
    
    <!-- copy over the <app> ... -->
    <xsl:copy>
      <!-- ... including its attrs -->
      <xsl:apply-templates select="@*"/>
      <!-- ... but for content, iterate over the available witnesses, and for each -->
      <!-- put out a <rdg> based on its chronological position, as follows. -->
      <!-- * less than first witness this passage appeared in: empty <rdg type=inferred> -->
      <!-- * between first and lowest mentioned witness: -->
      <!--   - (note: nothing to be done if first = lowest) -->
      <!--   - (if there are any, they are definitionally not attested) -->
      <!--   - copy of <rdg> with lowest mentioned input witness, but add type=inferred -->
      <!-- * between lowest and highest mentioned witness: -->
      <!--   - attested: copy of input attesting <rdg> -->
      <!--   - not attested: copy of input <rdg> that is from the latest witness that -->
      <!--     earlier than this one -->
      <!-- * greater than highest mentioned: copy of input <lem> -->
      <xsl:if test="@xml:id eq 'walc01-app-0062'">
        <xsl:message>DEBUG:</xsl:message>
        <xsl:message> start=<xsl:value-of select="$start"/>, startNum=<xsl:value-of select="$startNum"/></xsl:message>
        <xsl:message> highestMentioned_str=<xsl:value-of select="$highestMentioned_str"/>, highestMentioned=<xsl:value-of select="$highestMentioned"/></xsl:message>
        <xsl:message> lowestMentioned_str=<xsl:value-of select="$lowestMentioned_str"/>, lowestMentioned=<xsl:value-of select="$lowestMentioned"/></xsl:message>
        <xsl:for-each select="rdg">
          <xsl:message> wit=<xsl:value-of select="@wit"/></xsl:message>
        </xsl:for-each>
      </xsl:if>
      <xsl:for-each select="$versions[ position() lt $startNum ]">
        <xsl:if test="$me/@xml:id eq 'walc01-app-0062'">
          <xsl:message>DEBUG: testing <xsl:value-of select="."/> -> 1st -> empty</xsl:message>
        </xsl:if>
          <rdg wit="{.}" type="inferred"/>
      </xsl:for-each>
      <xsl:for-each select="$versions[ position() ge $startNum  and  position() lt $lowestMentioned ]">
        <xsl:if test="$me/@xml:id eq 'walc01-app-0062'">
          <xsl:message>DEBUG: testing <xsl:value-of select="."/> -> 2nd -> only(<xsl:value-of select="normalize-space($me/*[contains( @wit, $versions[$lowestMentioned])])"/>)</xsl:message>
        </xsl:if>
        <xsl:variable name="thisWit" select="."/>
        <xsl:variable name="thisWitNum" select="index-of( $versions, $thisWit )"/>
        <xsl:apply-templates select="$me/*[contains( @wit, $versions[$lowestMentioned] )]" mode="only">
          <xsl:with-param name="wit" select="$thisWit"/>
          <xsl:with-param name="type" select="'inferred'"/>
        </xsl:apply-templates>
      </xsl:for-each>
      <xsl:for-each select="$versions[ position() ge $lowestMentioned  and  position() le $highestMentioned ]">
        <xsl:if test="$me/@xml:id eq 'walc01-app-0062'">
          <xsl:message>DEBUG: testing <xsl:value-of select="."/> -> 3rd -> only( choice )</xsl:message>
        </xsl:if>
        <xsl:variable name="thisWit" select="."/>
        <xsl:variable name="thisWitNum" select="index-of( $versions, $thisWit )"/>
        <xsl:choose>
          <xsl:when test="count( $me/*[ $thisWit = tokenize(@wit,'\s+') ] ) gt 1">
            <xsl:processing-instruction name="sdb">ERROR: 2 or more children of app <xsl:value-of select="$me/@xml:id"
            /> have wit=<xsl:value-of select="$thisWit"/>!</xsl:processing-instruction>
            <xsl:copy-of select="$me/*[ $thisWit = tokenize(@wit,'\s+') ]"/>
          </xsl:when>
          <xsl:when test="count( $me/*[ $thisWit = tokenize(@wit,'\s+') ] ) eq 1">
            <xsl:apply-templates select="$me/*[ $thisWit = tokenize(@wit,'\s+') ]" mode="only">
              <xsl:with-param name="wit" select="$thisWit"/>
              <xsl:with-param name="type" select="''"/>
            </xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="closestEarlier_str">
              <xsl:choose>
                <xsl:when test="$me//@wit">
                  <xsl:value-of select="max(
                    for $wit in distinct-values( $me//@wit/tokenize(.,'\s+') ) return
                      if ( index-of( $versions, $wit ) lt $thisWitNum )
                        then index-of( $versions, $wit )
                        else 0
                    )"/>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="closestEarlier" select="xs:integer( $closestEarlier_str )"/>
            <xsl:apply-templates select="$me/*[$versions[$closestEarlier] = tokenize(@wit,'\s+')]" mode="only">
              <xsl:with-param name="wit" select="$thisWit"/>
              <xsl:with-param name="type" select="'inferred'"/>
            </xsl:apply-templates>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      <xsl:for-each select="$versions[ position() gt $highestMentioned ]">
        <xsl:if test="$me/@xml:id eq 'walc01-app-0062'">
          <xsl:message>DEBUG: testing <xsl:value-of select="."/> -> 4th -> only( &lt;lem> )</xsl:message>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="$me/lem">
            <rdg wit="{.}">
              <xsl:if test=". ne '#wc_base'">
                <xsl:attribute name="type" select="'inferred'"/>
              </xsl:if>
              <xsl:apply-templates select="$me/lem/node()"/>
            </rdg>
          </xsl:when>
          <xsl:otherwise>
            <xsl:processing-instruction name="sdb">Missing &lt;lem>?</xsl:processing-instruction>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>

  <d:doc>
    <d:desc>Copy an element (presumably a <h:tt>&lt;rdg></h:tt> or <h:tt>&lt;lem></h:tt>)
    but replace its <h:tt>@wit</h:tt> (which presumably contains the provided pointer to
    a witness, but may contain others as well) with a <h:tt>@wit</h:tt> that lists
      <d:b>only</d:b> the witness pointer supplied as a parameter.</d:desc>
  </d:doc>
  <xsl:template match="*" mode="only">
    <xsl:param name="wit"/>
    <xsl:param name="type"/>
    <xsl:copy>
      <xsl:apply-templates select="@* except @wit"/>
      <xsl:attribute name="wit" select="$wit"/>
      <xsl:if test="string-length($type) > 1">
        <xsl:attribute name="type" select="$type"/>
      </xsl:if>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>
  
  
  <!-- Keep this last Template (lines 224-251).
       However, it will need to be modified so that notes with an ana of #wc_c2
       are put into column C, etc. Joe. -->
  <d:doc>
    <d:desc>If there is text lying around (other than whitespace-only nodes) that
    is <d:b>not</d:b> inside an <d:i>app</d:i> or a <d:i>note</d:i>, but is <d:b>is</d:b> within an
    element that declares in which witness it first appeared (with <d:i>change</d:i>),
    then wrap it in an <d:i>app</d:i>/<d:i>lem</d:i>.</d:desc>
  </d:doc>
  <xsl:template match="text()
    [ not( normalize-space(.) eq '' ) ]
    [ not(ancestor::app or ancestor::note) ]
    [ ancestor::*/@change[ contains( .,'#wc' ) ] ]
    ">
    <xsl:variable name="start-to-end">
      <xsl:call-template name="start-to-end">
        <xsl:with-param name="me" select="."/>
      </xsl:call-template>
    </xsl:variable>
    <app>
      <lem wit="{$start-to-end}"><xsl:copy/></lem>
    </app>
  </xsl:template>
  
  <d:doc>
    <d:desc>If there is a header note lying around that
      is <d:b>not</d:b> inside an <d:i>app</d:i> or a <d:i>note</d:i>, but is <d:b>is</d:b> within an
      element that declares in which witness it first appeared (with <d:i>ana</d:i>),
      then wrap it in an <d:i>app</d:i>/<d:i>rdg</d:i>.</d:desc>
  </d:doc>
  <xsl:template match="note[@type='header'][not( ancestor::app )]">
    <app type="header">
      <rdg>
        <xsl:attribute name="wit">
          <xsl:call-template name="start-to-end">
            <xsl:with-param name="me" select="."/>
            <xsl:with-param name="of" select="$versions"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </rdg>
    </app>
  </xsl:template>

  <d:doc>
    <d:desc>Given a node (as a parameter) generate a list of either all
    witness references or (if supplied as "of" parameter) only version
    references that runs from revision in which this node first appeared
    (as indicated by change= on closest ancestor) to end of list.</d:desc>
  </d:doc>
  <xsl:template name="start-to-end">
    <xsl:param name="me"/>
    <xsl:param name="of" select="$versions"/>
    <xsl:variable name="start">
      <xsl:value-of select="$me/ancestor::*[contains(@change,'#wc')][1]/@change"/>
    </xsl:variable>
    <xsl:variable name="startNum" select="index-of( $of, $start )"/>
    <xsl:for-each select="$of[ position() ge $startNum ]">
      <xsl:value-of select="."/>
      <xsl:if test="position() ne last()">
        <xsl:text> </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>

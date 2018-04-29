<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:d="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:h="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="xs d h"
  xmlns="http://www.tei-c.org/ns/1.0"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0" version="2.0">

  <d:doc scope="stylesheet">
    <d:desc>
      <d:p>consolidate identical <h:tt>&lt;rdg></h:tt> elements with
      different <h:tt>@wit</h:tt> values into one
      <h:tt>&lt;rdg></h:tt> with combined values on
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

  <!--
    identity transform: anything not matched below (which is only
    <app> and its descendants) is just copied
  -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/">
    <xsl:apply-templates select="node()"/>
  </xsl:template>
  
  <!--
    fix <app>s
    Plan: grab child <rdg> elements in order of their *content*, and for
    each set with the same content, generate a single output <rdg> with
    a wit= attribute that combines all the input wit= attrs.
    This means we will be putting out a chunk of <rdg> elements at one
    shot, and if another node was interspersed among the <rdg>s, it will
    end up being "moved". (We could have moved them to after the <rdg>
    block, but I've chosen to move them to before the <rdg> block.)
  -->
  <xsl:template match="app">
    <!-- first, make a copy of this <app> we just matched -->
    <xsl:copy>
      <!-- decorate it with all of its own attributes -->
      <xsl:apply-templates select="@*"/>
      <!--
        test for processing instructions that occur after a <rdg>,
        and warn user we'll be moving it (them) if there is one (or more)
      -->
      <xsl:if test="processing-instruction()[preceding-sibling::rdg]">
        <xsl:message>WARNING: processing instruction(s) in &lt;app> #<xsl:value-of select="count(preceding::app)+1"/> is being moved to before &lt;rdg>s</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="processing-instruction()"/>
      <!--
        test for comments that occur after a <rdg>,
        and warn user we'll be moving it (them) if there is one (or more)
      -->
      <xsl:if test="comment()[preceding-sibling::rdg]">
        <xsl:message>WARNING: comment(s) in &lt;app> #<xsl:value-of select="count(preceding::app)+1"/> is being moved to before &lt;rdg>s</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="comment()"/>
      <!-- copy over any <lem> children (there should only be 0 or 1)  -->
      <xsl:apply-templates select="lem"/>
      <!--
        test for elements (other than <lem> or <rdg>) that occur after a <rdg>,
        and warn user we'll be moving it (them) if there is one (or more)
      -->
      <xsl:if test="*[not( self::lem | self::rdg ) ][preceding-sibling::rdg]">
        <xsl:message>WARNING: child element(s) in &lt;app> #<xsl:value-of select="count(preceding::app)+1"/> is not a &lt;lem> or a &lt;rdg>, and thus is being shifted to before &lt;rdg>s</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*[not( self::lem | self::rdg ) ]"/>
      <!--
        Now the interesting bit. Collect all my <rdg> children (remember, I
        am an <app>) in groups, depending on their content and attributes.
        That is, all my <rdg> children with a particular set of attribute
        values and the same content go into the same group. These groups are
        quite exclusive cliquey little clubs. If any attribute is different,
        or even one character of content is different, a <rdg> will not be
        allowed into the group, and is thus in a different one.
        After we've assembled the groups, we then put out
        a single <rdg> for each group, giving that output <rdg> the same
        attributes
        and content that the <rdg>s in the input group had (remember, they're
        all the same since we set the groups up based on attributes and content),
        and giving it a wit= that contains the wit= values of each of the
        input <rdg>s.
      -->
      <xsl:for-each-group select="rdg"
        group-by="concat(
        'type=', @type, ' ',
        'resp=', @resp, ' ',
        'cert=', @cert, ' ',
        '@@',
        string-join(
        for $n in ( .//node() ) return ( 
        if      ( $n instance of element()   ) then concat( name($n),'>:')
        else if ( $n instance of attribute() ) then concat( name($n), string($n) )
        else if ( $n instance of comment()   ) then concat('COM=', string($n) )
        else if ( $n instance of text()      ) then string($n)
        else ''
        ), ' ') )">
        <rdg>
          <!-- copy over attrs (except @wit) -->
          <xsl:apply-templates select="current-group()[1]/@*[ not( name(.) eq 'wit' ) ]"/>
          <!-- generate new @wit -->
          <xsl:attribute name="wit">
            <xsl:value-of select="current-group()/@wit" separator=" "/>
          </xsl:attribute>
          <!-- copy over content -->
          <xsl:apply-templates select="current-group()[1]/node()"/>
        </rdg>
      </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  version="2.0">
  
  <!-- run against combined chapters, i.e. the output of -->
  <!-- xmllint ==xinclude ../data/walden.xml -->

  <xsl:template match="/teiCorpus">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <title>Walden comments</title>
        <script type="text/javascript" src="./js/sortTable.js"/>
        <link rel="stylesheet" href="css/JSSTable.css"/>
        <style type="text/css">                                                                                                                                                    
          td { padding: 0.2ex 0.6ex 0.2ex 0.6ex; }                                                                                                                                 
          tr > td.f { text-align: center; color: red; }                                                                                                                            
          tr > td.COM { font-family: monospace; }                                                                                                                                  
        </style>
      </head>
      <body>
        <h2>Comments in Walden</h2>
        <p>Data extracted from                                                                                                                                                       
          <tt>svn://bauman.zapto.org/syd/trunk/Documents/ridgeback/digitalThoreau/data/on_walden_pond.xml#1671</tt>.</p>
        <h3>column explanation</h3>
        <dl>
          <dt>seq</dt><dd>a the sequence number of the comment within Walden (excluding <tt>&lt;teiHeader></tt>)</dd>
          <dt>ID</dt><dd>the <tt>xml:id</tt> of the closest ancestor that has one, and then the comment number within that ancestor</dd>
          <dt>comment</dt><dd>The space-normalized text content of the comment</dd>
          <dt>fol</dt><dd>The GI of the first following-sibling element; in red unless null, <tt>&lt;p></tt>, or <tt>&lt;seg></tt>.</dd>
        </dl>
          <table class="JSSTable" id="JSSTable" border="1">
            <thead>
              <tr>
                <th onclick="SortJSSTable(this)">seq</th>
                <th onclick="SortJSSTable(this)">in ID</th>
                <th onclick="SortJSSTable(this)">comment</th>
                <th onclick="SortJSSTable(this)">fol</th>
              </tr>
            </thead>
            <tbody id="JSSTableBody">
              <xsl:apply-templates select="//text//comment()"/>
            </tbody>
        </table>
      </body>
    </html>
  </xsl:template>  

  <xsl:template match="comment()">
    <tr>
      <td class="n"><xsl:value-of select="format-number( position(),'0000')"/></td>
      <xsl:variable name="ID" select="ancestor::*[@xml:id][1]/@xml:id"/>
      <xsl:variable name="COMcnt" select="count( ancestor::*[@xml:id][1]//comment()[ . &lt;&lt; current() ] ) +1"/>
      <td class="id"><xsl:value-of select="$ID"/> #<xsl:value-of select="format-number($COMcnt,'000')"/></td>
      <td class="COM"><xsl:value-of select="normalize-space(.)"/></td>
      <td>
        <xsl:attribute name="class">
          <xsl:choose>
            <xsl:when test="following-sibling::*[1][ self::p or self::seg ]">
              f-OK
            </xsl:when>
            <xsl:when test="following-sibling::*[1]">
              f
            </xsl:when>
            <xsl:otherwise>f-OK</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:value-of select="local-name( following-sibling::*[1] )"/>
      </td>
    </tr>
  </xsl:template>
  
</xsl:stylesheet>
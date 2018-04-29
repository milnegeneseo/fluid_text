<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
    xmlns:d="http://www.oxygenxml.com/ns/doc/xsl">
    <d:doc>
        <d:desc>
            <d:p>Data Dictonary Generator</d:p>
            <d:p>Usage: This tool is intended to help editors of TEI-based texts develop editorial
                guidelines for their projects. It accomplishes this by automatically generating a
                list of all TEI elements and attributes used in a document along with their <d:ul>
                    <d:li>Current definition from the TEI specification,</d:li>
                    <d:li>Usage count in the document,</d:li>
                    <d:li>For elements, a list of their parent elements, child elements, and
                        attributes,</d:li>
                    <d:li>For attributes, a list of their acceptable values and parent elements,
                        and</d:li>
                    <d:li>If provided by the editor, a local definition and
                        requirements/restrictions on use</d:li>
                </d:ul> Especially for editors new to TEI, developing editorial guidelines for a TEI
                project can be a daunting and unwieldly endeavor. This generator was developed with
                these users in mind. Its goal is to quickly give editors a sense of how TEI elements
                are currently being used in their project so they can draft and ultimately publish their editorial guidelines.  </d:p>
            <d:p>This tool was developed by Joe Easterly, ELectronic Resources &amp; Digital
                Scholarship Librarian at SUNY Geneseo.</d:p>
        </d:desc>
    </d:doc>
    <xsl:key name="elements" match="*" use="name()"/>
    <xsl:key name="attributes" match="@*" use="name()"/>
    <xsl:variable name="dictFile" select="'dictionary_entries.xml'"/>
    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>
                    <xsl:value-of select="document($dictFile)//titleStmt/title"/>
                </title>
                <link rel="stylesheet" type="text/css" href="data_dictionary.css"/>
            </head>
            <body>
                <div class="body_content">
                    <!--Display the dictonary title-->
                    <div class="dict_title">
                        <xsl:value-of select="document($dictFile)//titleStmt/title"/>
                    </div>

                    <!--Start working on the element list-->
                    <xsl:for-each
                        select="//*[generate-id(.)=generate-id(key('elements',name())[1])]">
                        <xsl:sort select="name()"/>
                        <xsl:variable name="elementName" select="name()"/>
                        <xsl:variable name="teiFile">
                            <xsl:text>specs/</xsl:text>
                            <xsl:value-of select="$elementName"/>
                            <xsl:text>.xml</xsl:text>
                        </xsl:variable>
                        <xsl:variable name="teiGloss"
                            select="document($teiFile)/elementSpec/gloss[@xml:lang='en']"/>
                        <xsl:variable name="teiDesc"
                            select="document($teiFile)/elementSpec/desc[@xml:lang='en']"/>
                        <xsl:variable name="dictEntries"
                            select="document($dictFile)//body/div[@corresp eq $elementName][@type='element']"/>
                        <xsl:for-each select="key('elements', name())">
                            <xsl:if test="position()=1">

                                <!--For the elements in the dictionary, start grabbing metadata from the source document-->
                                <xsl:variable name="eleCount"
                                    select="count(//*[name()=name(current())])"/>
                                <xsl:variable name="eleContainedBy"
                                    select="distinct-values(//*[name()=name(current())]/parent::*/name())"/>
                                <xsl:variable name="eleMayContain"
                                    select="distinct-values(//*[name()=name(current())]/child::*/name())"/>
                                <xsl:variable name="eleAttributes"
                                    select="distinct-values(//*[name()=name(current())]/@*/name())"/>
                                <div class="entry_heading">
                                    <span class="entry_heading_name">
                                        <xsl:attribute name="id">
                                            <xsl:text>e.</xsl:text>
                                            <xsl:value-of select="$elementName"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="$elementName"/>
                                        <xsl:if test="$teiGloss !=''">
                                            <xsl:text> &#149; </xsl:text>
                                            <xsl:value-of select="$teiGloss"/>
                                        </xsl:if>
                                    </span>

                                    <span class="entry_count">
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="$eleCount"/>
                                    </span>
                                </div>
                                <div class="entry_contents">
                                    <xsl:if test="$teiDesc != ''">
                                        <div class="entry_contents_tei">
                                            <span class="tei_description">
                                                <span class="definition_marker">
                                                  <xsl:text>TEI Definition: </xsl:text>
                                                </span>
                                                <xsl:value-of select="$teiDesc"/>
                                                <span class="tei_link">
                                                  <xsl:text> </xsl:text>
                                                  <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:text>http://www.tei-c.org/release/doc/tei-p5-doc/en/html/ref-</xsl:text>
                                                  <xsl:value-of select="$elementName"/>
                                                  <xsl:text>.html</xsl:text>
                                                  </xsl:attribute>
                                                  <xsl:attribute name="target"
                                                  >_blank</xsl:attribute>
                                                  <xsl:text>[more]</xsl:text>
                                                  </a>
                                                </span>
                                            </span>
                                        </div>
                                    </xsl:if>
                                    <xsl:if test="count($dictEntries) ge 1">
                                        <div class="entry_contents_local">
                                            <span class="definition_marker">
                                                <xsl:text>Project Definition: </xsl:text>
                                            </span>
                                            <xsl:for-each select="$dictEntries/div">
                                                <span class="tei_description">
                                                  <xsl:value-of select="span[@type='definition']"/>
                                                  <xsl:if
                                                  test="count($dictEntries/div[@type='entry']) ge 2">
                                                  <xsl:text> &#149; </xsl:text>
                                                  </xsl:if>
                                                </span>
                                            </xsl:for-each>
                                        </div>
                                    </xsl:if>
                                    <div class="entry_struct_notes">
                                        <span class="definition_marker">
                                            <xsl:text>Local Distribution</xsl:text>
                                        </span>
                                        <xsl:if test="$eleContainedBy !=''">
                                            <div class="note">
                                                <span class="struct_note_marker">
                                                  <xsl:text> &#149; </xsl:text>
                                                  <xsl:text>Contained by: </xsl:text>
                                                </span>
                                                <xsl:for-each
                                                  select="distinct-values($eleContainedBy)">
                                                  <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:text>#</xsl:text>
                                                  <xsl:text>e.</xsl:text>
                                                  <xsl:value-of select="."/>
                                                  </xsl:attribute>
                                                  <xsl:value-of select="."/>
                                                  </a>
                                                  <xsl:if test="position() != last()">
                                                  <xsl:text>, </xsl:text>
                                                  </xsl:if>
                                                </xsl:for-each>
                                            </div>
                                        </xsl:if>

                                        <xsl:if test="$eleMayContain !=''">
                                            <div class="note">
                                                <span class="struct_note_marker">
                                                  <xsl:text> &#149; </xsl:text>
                                                  <xsl:text>May contain: </xsl:text>
                                                </span>
                                                <xsl:for-each
                                                  select="distinct-values($eleMayContain)">
                                                  <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:text>#</xsl:text>
                                                  <xsl:text>e.</xsl:text>
                                                  <xsl:value-of select="."/>
                                                  </xsl:attribute>
                                                  <xsl:value-of select="."/>
                                                  </a>
                                                  <xsl:if test="position() != last()">
                                                  <xsl:text>, </xsl:text>
                                                  </xsl:if>
                                                </xsl:for-each>
                                            </div>
                                        </xsl:if>

                                        <xsl:if test="$eleAttributes !=''">
                                            <div class="note">
                                                <span class="struct_note_marker">
                                                  <xsl:text> &#149; </xsl:text>
                                                  <xsl:text>Attributes: </xsl:text>
                                                </span>
                                                <xsl:for-each
                                                  select="distinct-values($eleAttributes)">
                                                  <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:text>#</xsl:text>
                                                  <xsl:text>a.</xsl:text>
                                                  <xsl:value-of select="."/>
                                                  </xsl:attribute>
                                                  <xsl:value-of select="."/>
                                                  </a>
                                                  <xsl:if test="position() != last()">
                                                  <xsl:text>, </xsl:text>
                                                  </xsl:if>
                                                </xsl:for-each>
                                            </div>
                                        </xsl:if>
                                    </div>
                                </div>

                            </xsl:if>
                        </xsl:for-each>

                    </xsl:for-each>
                    <hr/>
                    <!--Start working on the attribute list-->
                    <xsl:for-each
                        select="//@*[generate-id(.)=generate-id(key('attributes',name())[1])]">
                        <xsl:sort select="name()"/>
                        <xsl:variable name="attName" select="name()"/>
                        <xsl:variable name="attFile">
                            <xsl:text>specs/</xsl:text>
                            <xsl:text>attributeList.xml</xsl:text>
                        </xsl:variable>
                        <xsl:variable name="teiGloss"
                            select="document($attFile)/(//attDef)[@ident eq $attName][1]/gloss[@xml:lang eq 'en']"/>
                        <xsl:variable name="teiURL"
                            select="document($dictFile)//body/div[@corresp eq $attName][@type eq 'attribute']/span[@type eq 'teiurl']"/>
                        <xsl:variable name="teiAttDescSet"
                            select="document($attFile)//classSpec[descendant::attDef/@ident = $attName]"/>
                        <xsl:variable name="localGloss"
                            select="document($dictFile)//body/div[@corresp eq $attName][@type eq 'attribute']/span[@type eq 'localgloss']"/>
                        <xsl:variable name="localUsageReq"
                            select="document($dictFile)//body/div[@corresp eq $attName][@type eq 'attribute']/span[@type eq 'usagereq']"/>

                        <xsl:variable name="attContents"
                            select="document($dictFile)//body/div[@corresp eq $attName][@type eq 'attribute']/span[@type eq 'maycontain']"/>

                        <xsl:for-each select="key('attributes', name())">
                            <xsl:if test="position()=1">

                                <!--For the attributes in the dictionary, start grabbing metadata from the source document-->
                                <xsl:variable name="attCount"
                                    select="count(//@*[name()=name(current())])"/>
                                <xsl:variable name="attContainedBy"
                                    select="distinct-values(//@*[name()=name(current())]/parent::*/name())"/>
                                <xsl:variable name="attMayContain">
                                    <xsl:choose>
                                        <xsl:when test="$attContents !=''">
                                            <xsl:value-of select="$attContents"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of
                                                select="distinct-values(//@*[name()=name(current())])"
                                            />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <div class="entry_heading">
                                    <span class="entry_heading_name">
                                        <xsl:attribute name="id">
                                            <xsl:text>a.</xsl:text>
                                            <xsl:value-of select="$attName"/>
                                        </xsl:attribute>
                                        <xsl:text>@</xsl:text>
                                        <xsl:value-of select="$attName"/>
                                        <xsl:if test="$teiGloss !=''">
                                            <xsl:text> &#149; </xsl:text>
                                            <xsl:value-of select="$teiGloss"/>
                                        </xsl:if>
                                    </span>
                                    <span class="entry_count">
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="$attCount"/>
                                    </span>
                                </div>
                                <div class="entry_contents">
                                    <xsl:if test="count($teiAttDescSet) ge 1">
                                        <div class="entry_contents_tei">
                                            <span class="definition_marker">
                                                <xsl:text>TEI Definition: </xsl:text>
                                            </span>
                                            <xsl:for-each select="$teiAttDescSet">
                                                <span class="tei_description">
                                                  <xsl:value-of
                                                  select="attList/attDef[@ident = $attName]/desc[@xml:lang='en']"/>
                                                  <xsl:text> (</xsl:text>
                                                  <xsl:value-of select="@ident"/>
                                                  <xsl:text>)</xsl:text>
                                                  <span class="tei_link">
                                                  <xsl:text> </xsl:text>
                                                  <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:text>http://www.tei-c.org/release/doc/tei-p5-doc/en/html/ref-</xsl:text>
                                                  <xsl:value-of select="@ident"/>
                                                  <xsl:text>.html</xsl:text>
                                                  </xsl:attribute>
                                                  <xsl:attribute name="target"
                                                  >_blank</xsl:attribute>
                                                  <xsl:text>[more]</xsl:text>
                                                  </a>
                                                  </span>
                                                  <xsl:if test="count($teiAttDescSet) ge 2">
                                                  <xsl:text> &#149; </xsl:text>
                                                  </xsl:if>
                                                </span>
                                            </xsl:for-each>
                                        </div>
                                    </xsl:if>
                                    <div class="entry_contents_local">
                                        <xsl:if test="$localGloss !=''">
                                            <span class="local_description">
                                                <span class="definition_marker">
                                                  <xsl:text>Project Definition: </xsl:text>
                                                </span>
                                                <xsl:value-of select="$localGloss"/>
                                            </span>
                                        </xsl:if>
                                        <div class="entry_struct_notes">
                                            <xsl:if test="$localUsageReq !=''">
                                                <div class="note">
                                                  <span class="struct_note_marker">
                                                  <xsl:text>Usage Requirements: </xsl:text>
                                                  </span>
                                                  <xsl:value-of select="$localUsageReq"/>
                                                </div>
                                            </xsl:if>
                                            <xsl:if test="$attContainedBy !=''">
                                                <div class="note">
                                                  <span class="definition_marker">
                                                  <xsl:text>Local Distribution</xsl:text>
                                                  </span>
                                                  <br/>
                                                  <span class="struct_note_marker">
                                                  <xsl:text> &#149; </xsl:text>
                                                  <xsl:text>Contained by: </xsl:text>
                                                  </span>
                                                  <xsl:for-each
                                                  select="distinct-values($attContainedBy)">
                                                  <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:text>#</xsl:text>
                                                  <xsl:text>e.</xsl:text>
                                                  <xsl:value-of select="."/>
                                                  </xsl:attribute>
                                                  <xsl:value-of select="."/>
                                                  </a>
                                                  <xsl:if test="position() != last()">
                                                  <xsl:text>, </xsl:text>
                                                  </xsl:if>
                                                  </xsl:for-each>
                                                </div>
                                            </xsl:if>

                                            <xsl:if test="$attMayContain !=''">
                                                <div class="note">
                                                  <span class="struct_note_marker">
                                                  <xsl:text> &#149; </xsl:text>
                                                  <xsl:text>May contain: </xsl:text>
                                                  </span>
                                                  <xsl:value-of select="$attMayContain"/>
                                                </div>
                                            </xsl:if>

                                        </div>
                                    </div>
                                </div>
                            </xsl:if>
                        </xsl:for-each>

                    </xsl:for-each>
                </div>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>

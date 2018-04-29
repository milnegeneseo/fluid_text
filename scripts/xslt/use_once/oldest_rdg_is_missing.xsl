<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:d="http://www.oxygenxml.com/ns/doc/xsl"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" version="2.0">
    <d:doc scope="stylesheet">
        <d:desc>Outputs a tab-delimited table which lists all app element
            for which their parent @change is not present in at least cardinal form in any child 
            rdg @wits. This is a problem because these child elements should probably
            not be missing in the versioning machine.            
        </d:desc>
    </d:doc>
    <xsl:output method="text"/>

    <d:doc scope="component">
        <d:desc><p>Output a descritpion on its own row, and then generate a header row.</p>
            <p>Then, output only the search results for the missing attributes</p>
        </d:desc>
    </d:doc>
    <xsl:template match="/">        
        <xsl:text>TABLE: All app elements for which their parent @change is not present in any child rdg @wits</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>App_ID</xsl:text>
        <xsl:text>&#09;</xsl:text>
        <xsl:text>Parent_Num</xsl:text>
        <xsl:text>&#09;</xsl:text>
        <xsl:text>Parent_Change</xsl:text>
        <xsl:text>&#09;</xsl:text>
        <xsl:text>Readings</xsl:text>
        <xsl:text>&#09;</xsl:text>
        <xsl:text>Lemma</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:apply-templates select="//app[not(child::rdg[contains(@wit, parent::app/parent::*/@change/substring(.,string-length(.),1))])]"/>    
    </xsl:template>
    
    <d:doc>
        <d:desc>From the search results, build a delimited table of values which correspond to the headers above.</d:desc>
    </d:doc>
    <xsl:template match="app">
        <xsl:value-of select="@xml:id"/>
        <xsl:text>&#09;</xsl:text>
        <xsl:value-of select="parent::*/@n"/>
        <xsl:text>&#09;</xsl:text>
        <xsl:value-of select="parent::*/@change"/>
        <xsl:text>&#09;</xsl:text>
        <xsl:value-of select="child::rdg[1]/@wit"/>
        <xsl:text>&#09;</xsl:text>
        <xsl:value-of select="./lem/tokenize(normalize-space(.),' ')[position()&lt;6]"/>
        <xsl:text>&#10;</xsl:text>
    </xsl:template>
</xsl:stylesheet>
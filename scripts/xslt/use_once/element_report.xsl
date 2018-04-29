<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="text"/>
    <xsl:key name="elements" match="*" use="name()"/>    
    <xsl:template match="/">
        <xsl:text>Summary of Elements</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:for-each select="//*[generate-id(.)=generate-id(key('elements',name())[1])]">
            <xsl:sort select="name()"/>
            <xsl:for-each select="key('elements', name())">
                <xsl:if test="position()=1">
                    <xsl:value-of select="name()"/>
                    <xsl:text>&#09;</xsl:text>
                    <xsl:value-of select="count(//*[name()=name(current())])"/>
                    <xsl:text>&#10;</xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>There are </xsl:text>
        <xsl:value-of select="count(//*)"/>
        <xsl:text> elements in all.</xsl:text>
    </xsl:template>
</xsl:stylesheet>
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    
    <!-- XSLT Template to copy anything, priority="-1" -->
    <xsl:template match="@*|node()" priority="-1">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- If I were to do something different for an element here is how I'd do it. -->
    <xsl:template match="fooBar">
        <barFoo><xsl:apply-templates/></barFoo>
    </xsl:template>
    
</xsl:stylesheet>
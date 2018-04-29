<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
    xmlns:d="http://www.oxygenxml.com/ns/doc/xsl">
    <xsl:output method="xml" version="1.0"
        encoding="UTF-8" indent="yes"/>
    <xsl:template match="/">
        <TEI xmlns="http://www.tei-c.org/ns/1.0">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title></title>
                    </titleStmt>
                    <publicationStmt><p>Created for Digtital Thoreau</p></publicationStmt>
                    <sourceDesc><ab>Automatically generated from Attribute files</ab></sourceDesc>
                </fileDesc>
            </teiHeader>
            <text>  
                <body>
                    <specGrp>
            <xsl:copy-of select="document('specs/att.ascribed.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.breaking.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.canonical.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.citing.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.combinable.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.coordinated.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.cReferencing.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.damaged.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.datable.custom.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.datable.iso.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.datable.w3c.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.datable.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.datcat.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.declarable.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.declaring.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.deprecated.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.dimensions.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.divLike.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.docStatus.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.duration.iso.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.duration.w3c.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.duration.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.edition.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.editLike.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.enjamb.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.entryLike.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.fragmentable.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.global.analytic.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.global.change.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.global.facs.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.global.linking.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.global.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.handFeatures.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.identified.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.internetMedia.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.interpLike.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.lexicographic.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.measurement.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.media.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.metrical.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.milestoneUnit.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.msExcerpt.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.namespaceable.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.naming.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.patternReplacement.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.personal.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.placement.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.pointing.group.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.pointing.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.ptrLike.form.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.ranging.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.rdgPart.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.readFrom.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.repeatable.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.resourced.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.responsibility.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.scoping.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.segLike.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.sortable.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.source.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.spanning.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.styleDef.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.tableDecoration.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.textCritical.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.timed.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.transcriptional.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.translatable.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.typed.xml')/classSpec"/>
            <xsl:copy-of select="document('specs/att.witnessed.xml')/classSpec"/>
                    </specGrp>
                </body>
            </text>
        </TEI>
    </xsl:template>
</xsl:stylesheet>

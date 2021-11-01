<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
   
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="record">
    <xsl:choose>
        <xsl:when test="@pageTitle!='Cover' and @pageTitle!='Cover1' and @pageTitle!='Cover 1' and @pageTitle!='Cover2' and @pageTitle!='Cover 2' and @pageTitle!='Back' and @pageTitle!='Back1' and @pageTitle!='Back Cover1' and @pageTitle!='Back Cover2' and @pageTitle!='Back2' and @pageTitle!='Back 2' and @pageTitle!='Back cover'">
            <xsl:copy>
                <xsl:apply-templates select="@*|node()"/>
            </xsl:copy>
        </xsl:when>
        <xsl:otherwise/>
    </xsl:choose>
    </xsl:template>
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:local="http://www.loc.org/namespace"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    exclude-result-prefixes="xs xsi xsl marc local skos"
    version="2.0">
    
    
    <xsl:output indent="yes" method="xml" encoding="UTF-8"/>    
    <xsl:strip-space elements="*"/>
    <xsl:include href="MARC21slimUtils.xsl"/>
    
    <xsl:variable name="filename" select="substring-before(tokenize(base-uri(),'/')[last()],'_marcxml.xml')"/>
    <xsl:key name="relatorTermCodeConversion" match="pair" use="@relatorTerm"/>
    <xsl:key name="languageCodeTermConversion" match="pair" use="@languageCode"/>
    <xsl:variable name="language" select="normalize-space(substring(//marc:controlfield[@tag='008'],36,3))"/>
    
    <xsl:template match="marc:record">
        <xsl:result-document href="{concat($filename,'_mods.xml')}">
            <mods:mods version="3.7">
                <!-- create fields in order -->
                <xsl:for-each select="marc:datafield[@tag='245']">
                    <xsl:call-template name="title-245"/>
                </xsl:for-each>
                <xsl:for-each select="marc:datafield[@tag='246']">
                    <xsl:call-template name="altTitle-246"/>
                </xsl:for-each>
                <xsl:for-each select="marc:datafield[@tag='100']">
                    <xsl:call-template name="name-100-700"/>
                </xsl:for-each>
                <xsl:for-each select="marc:datafield[@tag='110' and not(marc:subfield[@code='t'])]">
                    <xsl:call-template name="name-110-710"/>
                </xsl:for-each>
                <xsl:for-each select="marc:datafield[@tag='700']">
                    <xsl:call-template name="name-100-700"/>
                </xsl:for-each>            
                <xsl:for-each select="marc:datafield[@tag='710' and not(marc:subfield[@code='t'])]">
                    <xsl:call-template name="name-110-710"/>
                </xsl:for-each>                
                <mods:typeOfResource>cartographic</mods:typeOfResource>
                <mods:genre authority="dct"
                    authorityURI="http://purl.org/dc/terms/DCMIType"
                    valueURI="http://purl.org/dc/dcmitype/StillImage">StillImage</mods:genre>
                <mods:genre authority="aat" 
                    authorityURI="http://vocab.getty.edu/aat" 
                    valueURI="http://vocab.getty.edu/aat/300028094">Maps (documents)</mods:genre>
                <xsl:for-each select="marc:datafield[@tag='655']">
                    <xsl:call-template name="genre-655"/>
                </xsl:for-each>
<!--                <xsl:for-each select="marc:datafield[@tag='534']">
                    <xsl:call-template name="publisher-534"/>
                </xsl:for-each>-->
                
                    <xsl:for-each select="marc:datafield[@tag='260']">
                        <xsl:call-template name="publisher-26x"/>
                    </xsl:for-each>
                    <xsl:for-each select="marc:datafield[@tag='264' and @ind2='1']">
                        <xsl:call-template name="publisher-26x"/>
                    </xsl:for-each>
                             
                <xsl:choose>
                    <xsl:when test="marc:datafield[@tag='041']">
                        <xsl:for-each select="marc:datafield[@tag='041']">
                            <xsl:call-template name="language-041"/>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select="marc:controlfield[@tag='008']">
                            <xsl:call-template name="language-008"/>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose> 
                <xsl:for-each select="marc:datafield[@tag='300']">
                    <xsl:call-template name="physDesc-300"/>
                </xsl:for-each>
                <xsl:if test="marc:datafield[@tag='520']">
                    <xsl:call-template name="abstract-520"/>
                </xsl:if>
                <xsl:if test="marc:datafield[@tag='500']">
                    <xsl:call-template name="note-500"/>
                </xsl:if>
                <xsl:for-each select="marc:datafield[@tag='255']">
                    <xsl:call-template name="subjects-255"/>
                </xsl:for-each>
                <xsl:for-each select="marc:datafield[@tag='043']">
                    <xsl:call-template name="subjects-043"/>
                </xsl:for-each>
                <xsl:for-each select="marc:datafield[@tag='600']">
                    <xsl:call-template name="subjects-600"/>
                </xsl:for-each>
                <xsl:for-each select="marc:datafield[@tag='610']">
                    <xsl:call-template name="subjects-610"/>
                </xsl:for-each>
                <xsl:for-each select="marc:datafield[@tag='611']">
                    <xsl:call-template name="subjects-611"/>
                </xsl:for-each>
                <xsl:for-each select="marc:datafield[@tag='630']">
                    <xsl:call-template name="subjects-630"/>
                </xsl:for-each>
                <xsl:for-each select="marc:datafield[@tag='648']">
                    <xsl:call-template name="subjects-648"/>
                </xsl:for-each>
                <xsl:for-each select="marc:datafield[@tag='650']">
                    <xsl:call-template name="subjects-650"/>
                </xsl:for-each>
                <xsl:for-each select="marc:datafield[@tag='651']">
                    <xsl:call-template name="subjects-651"/>
                </xsl:for-each>
                <xsl:for-each select="marc:datafield[@tag='662']">
                    <xsl:call-template name="subjects-662"/>
                </xsl:for-each>
                <xsl:for-each select="marc:controlfield[@tag='001']">
                    <xsl:call-template name="catalog-link"/>
                </xsl:for-each>
                <mods:relatedItem type="host">
                    <mods:titleInfo>
                        <mods:title>Maps</mods:title>                    
                    </mods:titleInfo>
                    <mods:identifier type="oai_set">maps_root</mods:identifier>
                </mods:relatedItem>
                <xsl:for-each select="marc:datafield[@tag='110' and marc:subfield[@code='t']]">
                    <xsl:call-template name="title-7xx"/>
                </xsl:for-each>
                <xsl:for-each select="marc:datafield[@tag='710' and marc:subfield[@code='t']]">
                    <xsl:call-template name="title-7xx"/>
                </xsl:for-each>
                <mods:identifier type="filename">
                    <xsl:value-of select="$filename"/>
                </mods:identifier>
                <mods:accessCondition type="use and reproduction">Creative Commons Public Domain Mark 1.0: This work has been identified as being free of known restrictions under copyright law, including all related and neighboring rights. You can copy, modify, distribute and perform the work, even for commercial purposes, all without asking permission.</mods:accessCondition>
                <mods:accessCondition type="dpla" xlink:href="https://creativecommons.org/publicdomain/mark/1.0/">No Copyright</mods:accessCondition>
                <xsl:for-each select="marc:leader">
                    <xsl:call-template name="recordInfo-leader"/>
                </xsl:for-each>
            </mods:mods>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template name="title-245">
        <mods:titleInfo>
            <mods:title>
                <xsl:call-template name="chopPunctuationFront">
                    <xsl:with-param name="chopString">
                        <xsl:call-template name="chopPunctuationBack">
                            <xsl:with-param name="chopString" select="replace(marc:subfield[@code='a'],'\[','')"/>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:if test="ends-with(marc:subfield[@code='a'],'Co.') or ends-with(marc:subfield[@code='a'],'Co.].')">
                    <xsl:text>.</xsl:text>
                </xsl:if>
            </mods:title>
            <xsl:if test="marc:subfield[@code='b']">
                <mods:subTitle>
                    <xsl:call-template name="chopPunctuationFront">
                        <xsl:with-param name="chopString">
                            <xsl:call-template name="chopPunctuationBack">
                                <xsl:with-param name="chopString" select="marc:subfield[@code='b']"/>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </mods:subTitle>
            </xsl:if>
            <xsl:if test="marc:subfield[@code='n']">
                <mods:partNumber>
                    <xsl:call-template name="chopPunctuationFront">
                        <xsl:with-param name="chopString">
                            <xsl:call-template name="chopPunctuationBack">
                                <xsl:with-param name="chopString" select="replace(marc:subfield[@code='n'],'Pt.','Part')"/>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </mods:partNumber>
            </xsl:if>
            <xsl:if test="marc:subfield[@code='p']">
                <mods:partName>
                    <xsl:call-template name="chopPunctuationFront">
                        <xsl:with-param name="chopString">
                            <xsl:call-template name="chopPunctuationBack">
                                <xsl:with-param name="chopString" select="marc:subfield[@code='p']"/>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </mods:partName>
            </xsl:if>
        </mods:titleInfo>
    </xsl:template>
    
    <xsl:template name="altTitle-246">
        <mods:titleInfo type="alternative">
            <mods:title>
                <xsl:call-template name="chopPunctuationFront">
                    <xsl:with-param name="chopString">
                        <xsl:call-template name="chopPunctuationBack">
                            <xsl:with-param name="chopString" select="marc:subfield[@code='a']"/>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:if test="ends-with(marc:subfield[@code='a'],'Co.') or ends-with(marc:subfield[@code='a'],'Co.].')">
                    <xsl:text>.</xsl:text>
                </xsl:if>
            </mods:title>
            <xsl:if test="marc:subfield[@code='b']">
                <mods:subTitle>
                    <xsl:call-template name="chopPunctuationFront">
                        <xsl:with-param name="chopString">
                            <xsl:call-template name="chopPunctuationBack">
                                <xsl:with-param name="chopString" select="marc:subfield[@code='b']"/>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </mods:subTitle>
            </xsl:if>
            <xsl:if test="marc:subfield[@code='n']">
                <mods:partNumber>
                    <xsl:call-template name="chopPunctuationFront">
                        <xsl:with-param name="chopString">
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString" select="replace(marc:subfield[@code='n'],'Pt.','Part')"/>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </mods:partNumber>
            </xsl:if>
            <xsl:if test="marc:subfield[@code='p']">
                <mods:partName>
                    <xsl:call-template name="chopPunctuationFront">
                        <xsl:with-param name="chopString">
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString" select="marc:subfield[@code='p']"/>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </mods:partName>
            </xsl:if>
        </mods:titleInfo>
    </xsl:template>
    
    <!-- names -->
    <xsl:template name="name-100-700">
        <mods:name>
            <xsl:if test="@tag='100'">
                <xsl:attribute name="usage" select="'primary'"/>
            </xsl:if>
            <xsl:attribute name="type" select="'personal'"/>
            <!-- added [1] because some records from the catalog erroneously contain two subf. 0 -->
            <xsl:if test="contains(marc:subfield[@code='0'][1],'id.loc.gov')">
                <xsl:attribute name="authority" select="'naf'"/>
                <xsl:attribute name="authorityURI" select="'http://id.loc.gov/authorities/names'"/>
                <xsl:attribute name="valueURI" select="marc:subfield[@code='0']"/>
            </xsl:if>
            <mods:namePart>                
                <xsl:variable name="nameParts-concat">    
                    <xsl:for-each select="marc:subfield">
                        <xsl:choose>
                            <xsl:when test="@code='0'"/>
                            <xsl:when test="@code='d'"/>
                            <xsl:when test="@code='t'"/>
                            <xsl:when test="@code='e'"/>
                            <xsl:when test="@code='1'"/>
                            <xsl:when test="@code='4'"/>
                            <xsl:otherwise>
                                <xsl:value-of select="concat(.,' ')"/>
                            </xsl:otherwise>
                        </xsl:choose>                        
                    </xsl:for-each>
                </xsl:variable>
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString" select="$nameParts-concat"/>
                </xsl:call-template>
                <!-- add final period back in for names ending with an initial, Jr., or Sr. -->
                <xsl:if test="matches($nameParts-concat,' [A-Z]{1}\.?,? ?$') or matches($nameParts-concat,' Jr\.?,? ?$') or matches($nameParts-concat,' Sr\.?,? ?$')">
                    <xsl:text>.</xsl:text>
                </xsl:if>
            </mods:namePart>
            <xsl:if test="marc:subfield[@code='d']">
                <mods:namePart type="date">
                    <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString" select="marc:subfield[@code='d']"/>
                    </xsl:call-template>
                </mods:namePart>
            </xsl:if>
            <xsl:if test="marc:subfield[@code='t']">
                <mods:titleInfo>
                    <mods:title>
                        <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString" select="marc:subfield[@code='t']"/>
                        </xsl:call-template>
                    </mods:title>
                </mods:titleInfo>
            </xsl:if>   
            <xsl:call-template name="roleTerm"/>  
        </mods:name>
 
    </xsl:template>
    
    <xsl:template name="name-110-710">
        <xsl:if test=".[@tag = '110'] or .[@tag='710']">
            <xsl:choose>
                <!-- don't add MSU Map Library as a mods:name -->
                <xsl:when test="starts-with(marc:subfield[@code='a'],'Michigan State University') and starts-with(marc:subfield[@code='b'][position()=last()],'Map Library')" />                             
                <xsl:otherwise>
                    <mods:name>
                        <xsl:if test="@tag='110'">
                            <xsl:attribute name="usage" select="'primary'"/>
                        </xsl:if>
                        <xsl:attribute name="type" select="'corporate'"/>
                        <!-- added [1] because some records from the catalog erroneously contain two subf. 0 -->
                        <xsl:if test="contains(marc:subfield[@code='0'][1],'id.loc.gov')">
                            <xsl:attribute name="authority" select="'naf'"/>
                            <xsl:attribute name="authorityURI" select="'http://id.loc.gov/authorities/names'"/>
                            <xsl:attribute name="valueURI" select="marc:subfield[@code='0']"/>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="marc:subfield[@code = '0']">
                                <xsl:attribute name="authority">
                                    <xsl:text>naf</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="authorityURI">
                                    <xsl:text>http://id.loc.gov/authorities/names</xsl:text>
                                </xsl:attribute>
                                <xsl:call-template name="uri"/>
                                <mods:namePart>
                                    <xsl:call-template name="chopPunctuation">
                                        <xsl:with-param name="chopString">
                                            <xsl:value-of select="marc:subfield[@code = 'a']"/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                    <xsl:if test="ends-with(marc:subfield[@code = 'a'],'Co.') or ends-with(marc:subfield[@code = 'a'],'Co.,')">
                                        <xsl:text>.</xsl:text>
                                    </xsl:if>
                                </mods:namePart>
                                <xsl:for-each select="marc:subfield[@code = 'b']">
                                    <mods:namePart>
                                        <xsl:call-template name="chopPunctuation">
                                            <xsl:with-param name="chopString">
                                                <xsl:value-of select="."/>
                                            </xsl:with-param>
                                        </xsl:call-template>
                                    </mods:namePart>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="marc:subfield[@code = 'a']">
                                        <mods:namePart>
                                            <xsl:call-template name="chopPunctuation">
                                                <xsl:with-param name="chopString">
                                                    <xsl:value-of select="marc:subfield[@code = 'a']"/>
                                                </xsl:with-param>
                                            </xsl:call-template>
                                            <xsl:if test="ends-with(marc:subfield[@code = 'a'],'Co.') or ends-with(marc:subfield[@code = 'a'],'Co.,')">
                                                <xsl:text>.</xsl:text>
                                            </xsl:if>
                                            <xsl:if test="marc:subfield[@code = 'b'][1]">
                                                <xsl:text>. </xsl:text>
                                                <xsl:call-template name="chopPunctuation">
                                                    <xsl:with-param name="chopString">
                                                        <xsl:value-of select="marc:subfield[@code = 'b'][1]"/>
                                                    </xsl:with-param>
                                                </xsl:call-template>
                                            </xsl:if>
                                            <xsl:if test="marc:subfield[@code = 'n']">
                                                <xsl:text> </xsl:text>
                                                <xsl:call-template name="chopPunctuation">
                                                    <xsl:with-param name="chopString">
                                                        <xsl:value-of select="marc:subfield[@code = 'n']"/>
                                                    </xsl:with-param>
                                                </xsl:call-template>
                                            </xsl:if>
                                            <xsl:if test="marc:subfield[@code = 'd']">
                                                <xsl:text> : </xsl:text>
                                                <xsl:call-template name="chopPunctuation">
                                                    <xsl:with-param name="chopString">
                                                        <xsl:value-of select="marc:subfield[@code = 'd']"/>
                                                    </xsl:with-param>
                                                </xsl:call-template>
                                            </xsl:if>
                                            <xsl:if test="marc:subfield[@code = 'b'][2]">
                                                <xsl:text>. </xsl:text>
                                                <xsl:call-template name="chopPunctuation">
                                                    <xsl:with-param name="chopString">
                                                        <xsl:value-of select="marc:subfield[@code = 'b'][2]"/>
                                                    </xsl:with-param>
                                                </xsl:call-template>
                                            </xsl:if>
                                        </mods:namePart>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:call-template name="roleTerm"/>  
                    </mods:name>
                </xsl:otherwise>
            </xsl:choose>            
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="roleTerm">
        <xsl:choose>
            <xsl:when test="marc:subfield[@code='e']">
                <xsl:for-each select="marc:subfield[@code='e']">
                    <xsl:variable name="relatorTermChopPunct">
                        <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString" select="."/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:choose>                
                        <xsl:when test="$relatorTermChopPunct = 'current owner'">
                            <mods:role>
                                <mods:roleTerm authority="marcrelator"
                                    type="text"
                                    authorityURI="http://id.loc.gov/vocabulary/relators"
                                    valueURI="http://id.loc.gov/vocabulary/relators/own">owner</mods:roleTerm>
                            </mods:role>
                        </xsl:when>
                        <xsl:when test="$relatorTermChopPunct = 'digitizer'"/>  
                        <xsl:otherwise>
                            <mods:role>
                                <mods:roleTerm type="text">                            
                                    <xsl:if test="key('relatorTermCodeConversion',$relatorTermChopPunct,document('relatorTermCodeConversionTable.xml'))">
                                        <xsl:attribute name="authority">marcrelator</xsl:attribute>
                                        <xsl:attribute name="authorityURI">http://id.loc.gov/vocabulary/relators</xsl:attribute>
                                        <xsl:attribute name="valueURI">
                                            <xsl:text>http://id.loc.gov/vocabulary/relators/</xsl:text>
                                            <xsl:for-each select="key('relatorTermCodeConversion',$relatorTermChopPunct,document('relatorTermCodeConversionTable.xml'))">
                                                <xsl:value-of select="@relatorCode"/>
                                            </xsl:for-each>
                                        </xsl:attribute>
                                    </xsl:if>   
                                    <xsl:call-template name="chopPunctuation">
                                        <xsl:with-param name="chopString" select="."/>
                                    </xsl:call-template>
                                </mods:roleTerm>
                            </mods:role>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test=".[@tag='100']">
                        <mods:role>
                            <mods:roleTerm authority="marcrelator"
                                type="text"
                                authorityURI="http://id.loc.gov/vocabulary/relators"
                                valueURI="http://id.loc.gov/vocabulary/relators/cre">creator</mods:roleTerm>
                        </mods:role>
                    </xsl:when>
                    <xsl:otherwise>
                        <mods:role>
                            <mods:roleTerm authority="marcrelator"
                                type="text"
                                authorityURI="http://id.loc.gov/vocabulary/relators"
                                valueURI="http://id.loc.gov/vocabulary/relators/ctb">contributor</mods:roleTerm>
                        </mods:role>
                    </xsl:otherwise>
                </xsl:choose>                
            </xsl:otherwise>
        </xsl:choose>        
    </xsl:template>
    
    <xsl:template name="title-7xx">
        <xsl:choose>
            <xsl:when test="@ind2=' '">
                <mods:relatedItem otherType="containedIn">
                    <!-- only add link if exact match of entire subject string -->
                    <xsl:if test="marc:subfield[@code='0']">
                        <xsl:variable name="concatSubjects" select="normalize-unicode(replace(normalize-unicode(replace(replace(substring-before(substring-after(.,':'),'http'),'^(.*)[\.:,]$', '$1'),' ',''),'NFKD'),'\p{Mn}',''),'NFKC')"/>
                        <xsl:variable name="subf0">
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString" select="marc:subfield[@code='0'][1]"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="prefLabel" select="document(concat($subf0,'.skos.rdf'))//replace(normalize-unicode(replace(normalize-unicode(replace(replace(skos:prefLabel,'--',''),' ',''),'NFKD'),'\p{Mn}',''),'NFKC'),'^(.*)[\.:,]$', '$1')"/>
                        <xsl:if test="$prefLabel=$concatSubjects">
                            <xsl:attribute name="xlink:href">
                                <xsl:value-of select="replace(marc:subfield[@code='0'][1],'^(.*)[\.:,]$', '$1')"/>
                            </xsl:attribute>
                        </xsl:if>
                    </xsl:if>
                    <xsl:for-each select="marc:subfield[@code='a']">
                        <mods:name>
                            <xsl:choose>
                                <xsl:when test="../@tag='700'">
                                    <xsl:attribute name="type" select="'personal'"/>
                                </xsl:when>
                                <xsl:when test="../@tag='710'">
                                    <xsl:attribute name="type" select="'corporate'"/>
                                </xsl:when>
                            </xsl:choose>
                            <mods:namePart>
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString">
                                        <xsl:value-of select="."/>
                                    </xsl:with-param>
                                </xsl:call-template>
                                <xsl:if test="ends-with(.,'Co.,')">
                                    <xsl:text>.</xsl:text>
                                </xsl:if>
                            </mods:namePart>
                            <xsl:if test="following-sibling::marc:subfield[@code='d']">
                                <mods:namePart type="date">
                                    <xsl:call-template name="chopPunctuation">
                                        <xsl:with-param name="chopString" select="following-sibling::marc:subfield[@code='d']"/>
                                    </xsl:call-template>
                                </mods:namePart>
                            </xsl:if>
                        </mods:name>
                    </xsl:for-each>
                    <xsl:for-each select="marc:subfield[@code='t']">
                        <mods:titleInfo>
                            <mods:title>
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString">
                                        <xsl:value-of select="."/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </mods:title>
                        </mods:titleInfo>
                    </xsl:for-each>
                </mods:relatedItem>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- publication -->
    <xsl:template name="publisher-26x">
        <mods:originInfo eventType="publication">
            <xsl:for-each select="marc:subfield[@code='a']">
            <mods:place>
                <mods:placeTerm type="text">
                    <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString">
                            <xsl:call-template name="chopPunctuationFront">
                                <xsl:with-param name="chopString" select="replace(replace(.,'\[',''),'\]','')"/>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                    <xsl:if test="ends-with(.,'Ill. :') or ends-with(.,'Mich. :') or ends-with(.,'Mich :')">
                        <xsl:text>.</xsl:text>
                    </xsl:if>
                </mods:placeTerm>
            </mods:place>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='b']">
            <xsl:choose>
                <xsl:when test="contains(lower-case(.),'publisher not identified')"/>                       
                <xsl:otherwise>
                    <mods:publisher>
                        <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString">
                                <xsl:call-template name="chopPunctuationFront">
                                    <xsl:with-param name="chopString" select="replace(replace(.,'\[',''),'\]','')"/>
                                </xsl:call-template>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:if test="ends-with(.,'Co.,')">
                            <xsl:text>.</xsl:text>
                        </xsl:if>
                    </mods:publisher>
                </xsl:otherwise>
            </xsl:choose>   
            </xsl:for-each>
            <xsl:if test="preceding-sibling::marc:datafield[@tag='250']">
                <mods:edition>
                    <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString" select="preceding-sibling::marc:datafield[@tag='250']/marc:subfield[@code='a']"/>
                    </xsl:call-template>
                </mods:edition>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="substring(preceding-sibling::marc:controlfield[@tag='008'],7,1) = 's' or substring(preceding-sibling::marc:controlfield[@tag='008'],7,1) = 't' or substring(preceding-sibling::marc:controlfield[@tag='008'],7,1) = 'u'">
                    <mods:dateIssued keyDate="yes" encoding="edtf">
                        <xsl:value-of select="replace(substring(preceding-sibling::marc:controlfield[@tag='008'],8,4),'u','x')"/>
                    </mods:dateIssued>
                    <mods:dateOther type="year" encoding="edtf">
                        <xsl:value-of select="replace(substring(preceding-sibling::marc:controlfield[@tag='008'],8,4),'u','x')"/>
                    </mods:dateOther>
                </xsl:when>
                <xsl:when test="substring(preceding-sibling::marc:controlfield[@tag='008'],7,1) = 'r'">
                    <mods:dateIssued keyDate="yes" encoding="edtf">
                        <xsl:value-of select="replace(substring(preceding-sibling::marc:controlfield[@tag='008'],12,4),'u','x')"/>
                    </mods:dateIssued>
                    <mods:dateOther type="year" encoding="edtf">
                        <xsl:value-of select="replace(substring(preceding-sibling::marc:controlfield[@tag='008'],12,4),'u','x')"/>
                    </mods:dateOther>
                </xsl:when>
                <xsl:when test="substring(preceding-sibling::marc:controlfield[@tag='008'],7,1) = 'q'">
                    <mods:dateIssued keyDate="yes" encoding="edtf">
                        <xsl:value-of select="concat(replace(substring(preceding-sibling::marc:controlfield[@tag='008'],8,4),'u','x'),'/',replace(substring(preceding-sibling::marc:controlfield[@tag='008'],12,4),'u','x'))"/>
                    </mods:dateIssued>
                    <mods:dateOther type="year" encoding="edtf">
                        <!--<xsl:value-of select="concat(substring(preceding-sibling::marc:controlfield[@tag='008'],8,2),'xx')"/>-->
                        <xsl:choose>
                            <xsl:when test="substring(preceding-sibling::marc:controlfield[@tag='008'],10,1)='3' and substring(preceding-sibling::marc:controlfield[@tag='008'],14,1)='3'">
                                <xsl:text>193x</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat(substring(preceding-sibling::marc:controlfield[@tag='008'],8,2),'xx')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                    </mods:dateOther>
                </xsl:when>
            </xsl:choose>
        </mods:originInfo>
    </xsl:template>
    
    <!-- language -->
    <xsl:template name="language-041">
        <xsl:for-each select="marc:subfield[@code='a']">
            <mods:language>
                <mods:languageTerm authority="iso639-2b" authorityURI="http://id.loc.gov/vocabulary/iso639-2" type="code">
                    <xsl:attribute name="valueURI">
                        <xsl:text>http://id.loc.gov/vocabulary/iso639-2/</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </mods:languageTerm>
                <mods:languageTerm authority="iso639-2b" authorityURI="http://id.loc.gov/vocabulary/iso639-2" type="text">
                    <xsl:attribute name="valueURI">
                        <xsl:text>http://id.loc.gov/vocabulary/iso639-2/</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                    <xsl:for-each select="key('languageCodeTermConversion',.,document('languageCodeTermConversion.xml'))">
                        <xsl:value-of select="@languageTerm"/>
                    </xsl:for-each>
                </mods:languageTerm>
            </mods:language>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='b']">
            <mods:language objectPart="abstract">
                <mods:languageTerm authority="iso639-2b" authorityURI="http://id.loc.gov/vocabulary/iso639-2" type="code">
                    <xsl:attribute name="valueURI">
                        <xsl:text>http://id.loc.gov/vocabulary/iso639-2/</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </mods:languageTerm>
                <mods:languageTerm authority="iso639-2b" authorityURI="http://id.loc.gov/vocabulary/iso639-2" type="text">
                    <xsl:attribute name="valueURI">
                        <xsl:text>http://id.loc.gov/vocabulary/iso639-2/</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                    <xsl:for-each select="key('languageCodeTermConversion',.,document('languageCodeTermConversion.xml'))">
                        <xsl:value-of select="@languageTerm"/>
                    </xsl:for-each>
                </mods:languageTerm>
            </mods:language>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="language-008">        
        <mods:language>
            <mods:languageTerm authority="iso639-2b" authorityURI="http://id.loc.gov/vocabulary/iso639-2" type="code">
                <xsl:attribute name="valueURI">
                    <xsl:text>http://id.loc.gov/vocabulary/iso639-2/</xsl:text>
                    <xsl:value-of select="$language"/>
                </xsl:attribute>
                <xsl:value-of select="$language"/>
            </mods:languageTerm>
            <mods:languageTerm authority="iso639-2b" authorityURI="http://id.loc.gov/vocabulary/iso639-2" type="text">
                <xsl:attribute name="valueURI">
                    <xsl:text>http://id.loc.gov/vocabulary/iso639-2/</xsl:text>
                    <xsl:value-of select="$language"/>
                </xsl:attribute>
                <xsl:for-each select="key('languageCodeTermConversion',$language,document('languageCodeTermConversion.xml'))">
                    <xsl:value-of select="@languageTerm"/>
                </xsl:for-each>
            </mods:languageTerm>
        </mods:language>
    </xsl:template>
    
    <!-- physical description -->
    <xsl:template name="physDesc-300">
        <mods:physicalDescription>
            <mods:form authority="marccategory"
                authorityURI="http://id.loc.gov/vocabulary/genreFormSchemes/marccategory">electronic resource</mods:form>
            <mods:digitalOrigin>reformatted digital</mods:digitalOrigin>
            <mods:extent>
                <xsl:value-of select="substring-before(substring-after(marc:subfield[@code='a'],'('),')')"/>
            </mods:extent>
        </mods:physicalDescription>
    </xsl:template>
    
    <!-- abstract -->
    <xsl:template name="abstract-520">
        <mods:abstract>
            <xsl:for-each select="marc:datafield[@tag='520']">
                <xsl:value-of select="."/>
                <xsl:if test="not(position() = last())">
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </mods:abstract>
    </xsl:template>
    
    <!-- note -->
    <xsl:template name="note-500">
        <xsl:for-each select="marc:datafield[@tag='500']">
            <xsl:choose>
                <xsl:when test="starts-with(marc:subfield[@code='a'],'Title supplied')"/>
                <xsl:when test="starts-with(marc:subfield[@code='a'],'Title from cover')"/>
                <xsl:when test="starts-with(marc:subfield[@code='a'],'&quot;')"/>
                <xsl:otherwise>
                    <mods:note>
                        <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString">
                                <xsl:call-template name="chopPunctuationFront">
                                    <xsl:with-param name="chopString" select="replace(replace(marc:subfield[@code='a'],'\[',''),'\]','')"/>
                                </xsl:call-template>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:text>.</xsl:text>

                        <!--<xsl:value-of select="marc:subfield[@code='a']"/>-->
                    </mods:note>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>     
    </xsl:template>
    
    <!-- record info -->
    <xsl:template name="recordInfo-leader">
        <mods:recordInfo>
            <xsl:choose>
                <xsl:when test="substring(.,19,1)='a'">
                    <mods:descriptionStandard>aacr</mods:descriptionStandard>
                </xsl:when>
                <xsl:when test="substring(.,19,1)='i'">
                    <mods:descriptionStandard>rda</mods:descriptionStandard>
                </xsl:when>
            </xsl:choose>            
            <xsl:for-each select="following-sibling::marc:datafield[@tag=040]">                
                <xsl:if test="marc:subfield[@code='a']='EEM'">
                    <mods:recordContentSource authority="marcorg" authorityURI="http://id.loc.gov/vocabulary/organizations" valueURI="http://id.loc.gov/vocabulary/organizations/miem">
                        <xsl:text>MiEM</xsl:text>
                    </mods:recordContentSource>
                    <mods:recordContentSource authority="naf" authorityURI="http://id.loc.gov/authorities/names" valueURI="http://id.loc.gov/authorities/names/n93024323">
                        <xsl:text>Michigan State University. Libraries</xsl:text>
                    </mods:recordContentSource>
                </xsl:if>
                <xsl:if test="marc:subfield[@code='a']='EEX'">
                    <mods:recordContentSource authority="marcorg" authorityURI="http://id.loc.gov/vocabulary/organizations" valueURI="http://id.loc.gov/vocabulary/organizations/mi">
                        <xsl:text>Mi</xsl:text>
                    </mods:recordContentSource>
                    <mods:recordContentSource authority="naf" authorityURI="http://id.loc.gov/authorities/names" valueURI="http://id.loc.gov/authorities/names/n85000969">
                        <xsl:text>Library of Michigan</xsl:text>
                    </mods:recordContentSource>
                </xsl:if>
                <xsl:if test="marc:subfield[@code='a']='IUL'">
                    <mods:recordContentSource authority="marcorg" authorityURI="http://id.loc.gov/vocabulary/organizations" valueURI="http://id.loc.gov/vocabulary/organizations/mi">
                        <xsl:text>InU</xsl:text>
                    </mods:recordContentSource>
                    <mods:recordContentSource authority="naf" authorityURI="http://id.loc.gov/authorities/names" valueURI="http://id.loc.gov/authorities/names/no2011052165">
                        <xsl:text>Indiana University, Bloomington. Libraries</xsl:text>
                    </mods:recordContentSource>
                </xsl:if>
            </xsl:for-each>
            <xsl:choose>
                <xsl:when test="following-sibling::marc:controlfield[@tag=005]">
                    <xsl:for-each select="following-sibling::marc:controlfield[@tag=005]">
                        <mods:recordCreationDate encoding="edtf">
                            <xsl:value-of select="concat(substring(.,1,4),'-',substring(.,5,2),'-',substring(.,7,2))"/>
                        </mods:recordCreationDate>
                    </xsl:for-each>            
                    <xsl:for-each select="following-sibling::marc:controlfield[@tag=005]">
                        <mods:recordChangeDate encoding="edtf">
                            <xsl:value-of select="substring(string(current-date()),1,10)"/>
                        </mods:recordChangeDate>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <mods:recordCreationDate encoding="edtf">
                        <xsl:value-of select="substring(string(current-date()),1,10)"/>
                    </mods:recordCreationDate>
                </xsl:otherwise>
            </xsl:choose>            
            <xsl:for-each select="following-sibling::marc:controlfield[@tag=001]">
                <mods:recordIdentifier>
                    <xsl:if test="../marc:controlfield[@tag=003]">
                        <xsl:attribute name="source">
                            <xsl:value-of select="../marc:controlfield[@tag=003]"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="contains(.,'ocn')">
                            <xsl:value-of select="substring-after(.,'ocn')"/>
                        </xsl:when>
                        <xsl:when test="contains(.,'ocm')">
                            <xsl:value-of select="substring-after(.,'ocm')"/>
                        </xsl:when>
                        <xsl:when test="contains(.,'on')">
                            <xsl:value-of select="substring-after(.,'on')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </mods:recordIdentifier>
            </xsl:for-each>
            
            <mods:recordOrigin>Converted from MARCXML to MODS version 3.7 using a custom XSLT.</mods:recordOrigin>
            
            <xsl:for-each select="following-sibling::marc:datafield[@tag=040]/marc:subfield[@code='b']">
                <mods:languageOfCataloging>
                    <mods:languageTerm authority="iso639-2b" type="code">
                        <xsl:value-of select="."/>
                    </mods:languageTerm>
                </mods:languageOfCataloging>
            </xsl:for-each>
        </mods:recordInfo>
    </xsl:template>
    
    <!-- subjects -->
    <xsl:template name="subjects-255">
        <mods:subject>
            <mods:cartographics>
                <xsl:if test="marc:subfield[@code='c']">
                    <mods:coordinates>
                        <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString" select="replace(replace(marc:subfield[@code='c'],'\(',''),'\)','')"/>
                        </xsl:call-template>
                    </mods:coordinates>
                </xsl:if>
                <xsl:if test="marc:subfield[@code='a']">
                    <mods:scale>
                        <xsl:choose>
                            <xsl:when test="ends-with(marc:subfield[@code='a'],'in.')">
                                <xsl:value-of select="replace(marc:subfield[@code='a'],'in.','inch')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString" select="marc:subfield[@code='a']"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </mods:scale>
                </xsl:if>
                <xsl:if test="marc:subfield[@code='b']">
                    <mods:projection>
                        <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString" select="marc:subfield[@code='b']"/>
                        </xsl:call-template>
                    </mods:projection>
                </xsl:if>
            </mods:cartographics>
        </mods:subject>
    </xsl:template>
    
    <xsl:template name="subjects-043">
        <xsl:for-each select="marc:subfield[@code='a']">
            <mods:subject>
                <!-- Add authority atributes based on subcodes-->
                <xsl:if test="@code='a'">
                    <xsl:attribute name="authority">
                        <xsl:text>marcgac</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="authorityURI">
                        <xsl:text>http://id.loc.gov/vocabulary/geographicAreas</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="valueURI">
                        <xsl:text>http://id.loc.gov/vocabulary/geographicAreas/</xsl:text>
                        <xsl:value-of select="replace(replace(replace(.,'---$',''),'--$',''),'-$','')"/>
                    </xsl:attribute>
                </xsl:if>
                <mods:geographicCode>
                    <xsl:value-of select="."/>
                </mods:geographicCode>
            </mods:subject>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="subjects-600">
        <xsl:choose>
            <xsl:when test="@ind2='0'">
                <mods:subject authority="lcsh" authorityURI="http://id.loc.gov/authorities/subjects">
                    <!-- only add valueURI if exact match of entire subject string -->
                    <xsl:if test="marc:subfield[@code='0'] and .[@ind2='0']">
                        <xsl:variable name="concatSubjects" select="normalize-unicode(replace(normalize-unicode(replace(replace(substring-before(.,'http'),'^(.*)[\.:,]$', '$1'),' ',''),'NFKD'),'\p{Mn}',''),'NFKC')"/>
                        <xsl:variable name="lcshRDF" select="concat(marc:subfield[@code='0'][1],'.skos.rdf')"/>
                        <xsl:variable name="subf0">
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString" select="marc:subfield[@code='0'][1]"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="prefLabel" select="document(concat($subf0,'.skos.rdf'))//replace(normalize-unicode(replace(normalize-unicode(replace(replace(skos:prefLabel,'--',''),' ',''),'NFKD'),'\p{Mn}',''),'NFKC'),'^(.*)[\.:,]$', '$1')"/>
                        <xsl:if test="$prefLabel=$concatSubjects">
                            <xsl:attribute name="valueURI">
                                <xsl:value-of select="replace(marc:subfield[@code='0'][1],'^(.*)[\.:,]$', '$1')"/>
                            </xsl:attribute>
                        </xsl:if>
                    </xsl:if>
                    <mods:name type="personal">
                        <mods:namePart>
                            <xsl:variable name="nameParts-concat">
                                <xsl:for-each select="marc:subfield">
                                    <xsl:choose>
                                        <xsl:when test="@code='0'"/>
                                        <xsl:when test="@code='d'"/>
                                        <xsl:when test="@code='e'"/>
                                        <xsl:when test="@code='t'"/>
                                        <xsl:when test="@code='v'"/>
                                        <xsl:when test="@code='x'"/>
                                        <xsl:when test="@code='y'"/>
                                        <xsl:when test="@code='z'"/>
                                        <xsl:when test="@code='4'"/>
                                        <xsl:otherwise>
                                            <xsl:value-of select="concat(.,' ')"/>
                                        </xsl:otherwise>
                                    </xsl:choose>                        
                                </xsl:for-each>                                
                            </xsl:variable>
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString" select="$nameParts-concat"/>
                            </xsl:call-template>
                            <!-- add final period back in for names ending with an initial -->
                            <xsl:if test="matches($nameParts-concat,' [A-Z]{1}\.?,? ?$') or matches($nameParts-concat,' Jr\.?,? ?$') or matches($nameParts-concat,' Sr\.?,? ?$')">
                                <xsl:text>.</xsl:text>
                            </xsl:if>
                        </mods:namePart>
                        <xsl:if test="marc:subfield[@code='d']">
                            <mods:namePart type="date">
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString" select="marc:subfield[@code='d']"/>
                                </xsl:call-template>
                            </mods:namePart>
                        </xsl:if>
                    </mods:name>
                    <xsl:for-each select="marc:subfield[@code='t']">
                        <mods:titleInfo>
                            <mods:title>
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString" select="."/>
                                </xsl:call-template>
                            </mods:title>
                        </mods:titleInfo>
                    </xsl:for-each>
                    <xsl:for-each select="marc:subfield[@code='x']">
                        <mods:topic>
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString" select="."/>
                            </xsl:call-template>
                        </mods:topic>
                    </xsl:for-each>
                    <xsl:for-each select="marc:subfield[@code='z']">
                        <mods:geographic>
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString" select="."/>
                            </xsl:call-template>
                        </mods:geographic>
                    </xsl:for-each>
                    <xsl:for-each select="marc:subfield[@code='v']">
                        <mods:genre>
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString" select="."/>
                            </xsl:call-template>
                            <xsl:if test="ends-with(.,'etc.')">
                                <xsl:text>.</xsl:text>
                            </xsl:if>
                        </mods:genre>                        
                    </xsl:for-each>
                </mods:subject>
            </xsl:when>
            <xsl:when test="@ind2='7' and marc:subfield[@code='2']='fast'">
                <mods:subject authority="fast" authorityURI="http://id.worldcat.org/fast">                     
                    <xsl:attribute name="valueURI">
                        <xsl:choose>
                            <xsl:when test="starts-with(marc:subfield[@code='0'],'http')">
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString" select="marc:subfield[@code='0']"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="fast-valueURI">
                                    <xsl:with-param name="fast-uri" select="marc:subfield[@code='0']"/>
                                </xsl:call-template>  
                            </xsl:otherwise>
                        </xsl:choose>                        
                    </xsl:attribute>
                    <mods:name type="personal">
                        <mods:namePart>
                            <xsl:variable name="nameParts-concat">
                                <xsl:value-of select="marc:subfield[@code='a']"/>
                                <xsl:if test="marc:subfield[@code='b']">
                                    <xsl:value-of select="concat(' ',marc:subfield[@code='b'])"/>
                                </xsl:if>
                                <xsl:if test="marc:subfield[@code='c']">
                                    <xsl:value-of select="concat(' ',marc:subfield[@code='c'])"/>                    
                                </xsl:if>
                                <xsl:if test="marc:subfield[@code='q']">
                                    <xsl:value-of select="concat(' ',marc:subfield[@code='q'])"/>
                                </xsl:if>
                            </xsl:variable>
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString" select="$nameParts-concat"/>
                            </xsl:call-template>
                            <!-- add final period back in for names ending with an initial -->
                            <xsl:if test="matches($nameParts-concat,' [A-Z]{1}\.$') or matches($nameParts-concat,' [A-Z]{1}\.,$')">
                                <xsl:text>.</xsl:text>
                            </xsl:if>
                        </mods:namePart>
                        <xsl:if test="marc:subfield[@code='d']">
                            <mods:namePart type="date">
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString" select="marc:subfield[@code='d']"/>
                                </xsl:call-template>
                            </mods:namePart>
                        </xsl:if>
                    </mods:name>
                </mods:subject>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="subjects-610">
        <xsl:choose>
            <xsl:when test="@ind2='0'">
                <mods:subject authority="lcsh" authorityURI="http://id.loc.gov/authorities/subjects">
                    <!-- only add valueURI if exact match of entire subject string -->
                    <xsl:if test="marc:subfield[@code='0'] and .[@ind2='0']">
                        <xsl:variable name="lcshRDF" select="concat(marc:subfield[@code='0'][1],'.skos.rdf')"/>
                        <xsl:variable name="concatSubjects" select="normalize-unicode(replace(normalize-unicode(replace(replace(substring-before(.,'http'),'^(.*)[\.:,]$', '$1'),' ',''),'NFKD'),'\p{Mn}',''),'NFKC')"/>
                        <xsl:variable name="subf0">
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString" select="marc:subfield[@code='0'][1]"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="prefLabel" select="document(concat($subf0,'.skos.rdf'))//replace(normalize-unicode(replace(normalize-unicode(replace(replace(skos:prefLabel,'--',''),' ',''),'NFKD'),'\p{Mn}',''),'NFKC'),'^(.*)[\.:,]$', '$1')"/>
                        <xsl:if test="$prefLabel=$concatSubjects">
                            <xsl:attribute name="valueURI">
                                <xsl:value-of select="replace(marc:subfield[@code='0'][1],'^(.*)[\.:,]$', '$1')"/>
                            </xsl:attribute>
                        </xsl:if>
                    </xsl:if>
                    <mods:name type="corporate">
                        <mods:namePart>
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString" select="marc:subfield[@code='a']"/>
                            </xsl:call-template>
                        </mods:namePart>
                        <xsl:for-each select="marc:subfield[@code='b']">
                            <mods:namePart>
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString" select="."/>
                                </xsl:call-template>
                            </mods:namePart>
                        </xsl:for-each>
                    </mods:name>
                    <xsl:for-each select="marc:subfield[@code='x']">
                        <mods:topic>
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString" select="."/>
                            </xsl:call-template>
                        </mods:topic>
                    </xsl:for-each>
                    <xsl:for-each select="marc:subfield[@code='z']">
                        <mods:geographic>
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString" select="."/>
                            </xsl:call-template>
                        </mods:geographic>
                    </xsl:for-each>
                    <xsl:for-each select="marc:subfield[@code='v']">
                        <mods:genre>
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString" select="."/>
                            </xsl:call-template>
                            <xsl:if test="ends-with(.,'etc.')">
                                <xsl:text>.</xsl:text>
                            </xsl:if>
                        </mods:genre>
                    </xsl:for-each>
                </mods:subject>
            </xsl:when>
            <xsl:when test="@ind2='7' and marc:subfield[@code='2']='fast'">
                <mods:subject authority="fast" authorityURI="http://id.worldcat.org/fast">
                    <xsl:attribute name="valueURI">
                        <xsl:choose>
                            <xsl:when test="starts-with(marc:subfield[@code='0'],'http')">
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString" select="marc:subfield[@code='0']"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="fast-valueURI">
                                    <xsl:with-param name="fast-uri" select="marc:subfield[@code='0']"/>
                                </xsl:call-template>  
                            </xsl:otherwise>
                        </xsl:choose>                        
                    </xsl:attribute>
                    <mods:name type="corporate">
                        <mods:namePart>
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString" select="marc:subfield[@code='a']"/>
                            </xsl:call-template>
                        </mods:namePart>
                        <xsl:for-each select="marc:subfield[@code='b']">
                            <mods:namePart>
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString" select="."/>
                                </xsl:call-template>
                            </mods:namePart>
                        </xsl:for-each>
                    </mods:name>
                </mods:subject>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="subjects-611">
        <xsl:choose>
            <xsl:when test="@ind2='0'">
                <mods:subject authority="lcsh" authorityURI="http://id.loc.gov/authorities/subjects">
                    <!-- only add valueURI if exact match of entire subject string -->
                    <xsl:if test="marc:subfield[@code='0'] and .[@ind2='0']">
                        <xsl:variable name="lcshRDF" select="concat(marc:subfield[@code='0'][1],'.skos.rdf')"/>
                        <xsl:variable name="concatSubjects" select="normalize-unicode(replace(normalize-unicode(replace(replace(substring-before(.,'http'),'^(.*)[\.:,]$', '$1'),' ',''),'NFKD'),'\p{Mn}',''),'NFKC')"/>
                        <xsl:variable name="subf0">
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString" select="marc:subfield[@code='0'][1]"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="prefLabel" select="document(concat($subf0,'.skos.rdf'))//replace(normalize-unicode(replace(normalize-unicode(replace(replace(skos:prefLabel,'--',''),' ',''),'NFKD'),'\p{Mn}',''),'NFKC'),'^(.*)[\.:,]$', '$1')"/>
                        <xsl:if test="$prefLabel=$concatSubjects">
                            <xsl:attribute name="valueURI">
                                <xsl:value-of select="replace(marc:subfield[@code='0'][1],'^(.*)[\.:,]$', '$1')"/>
                            </xsl:attribute>
                        </xsl:if>
                    </xsl:if>
                    <mods:name type="conference">
                        <mods:namePart>
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString" select="marc:subfield[@code='a']"/>
                            </xsl:call-template>
                            <xsl:for-each select="marc:subfield[@code='n']">
                                <xsl:value-of select="concat(' ',.)"/>
                            </xsl:for-each>
                            <xsl:for-each select="marc:subfield[@code='d']">
                                <xsl:value-of select="concat(' ',.)"/>
                            </xsl:for-each>
                            <xsl:for-each select="marc:subfield[@code='c']">
                                <xsl:value-of select="concat(' ',.)"/>
                            </xsl:for-each>
                        </mods:namePart>
                    </mods:name>
                    <xsl:for-each select="marc:subfield[@code='x']">
                        <mods:topic>
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString" select="."/>
                            </xsl:call-template>
                        </mods:topic>
                    </xsl:for-each>
                </mods:subject>
            </xsl:when>
            <xsl:when test="@ind2='7' and marc:subfield[@code='2']='fast'">
                <mods:subject authority="fast" authorityURI="http://id.worldcat.org/fast">
                    <xsl:attribute name="valueURI">
                        <xsl:choose>
                            <xsl:when test="starts-with(marc:subfield[@code='0'],'http')">
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString" select="marc:subfield[@code='0']"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="fast-valueURI">
                                    <xsl:with-param name="fast-uri" select="marc:subfield[@code='0']"/>
                                </xsl:call-template>  
                            </xsl:otherwise>
                        </xsl:choose>                        
                    </xsl:attribute>
                    <mods:name type="conference">
                        <mods:namePart>
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString" select="marc:subfield[@code='a']"/>
                            </xsl:call-template>
                        </mods:namePart>
                    </mods:name>
                </mods:subject>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="subjects-630">
        <xsl:choose>
            <xsl:when test="@ind2='0'">
                <mods:subject authority="lcsh" authorityURI="http://id.loc.gov/authorities/subjects">
                    <!-- only add valueURI if exact match of entire subject string -->
                    <xsl:if test="marc:subfield[@code='0'] and .[@ind2='0']">
                        <xsl:variable name="concatSubjects" select="normalize-unicode(replace(normalize-unicode(replace(replace(substring-before(.,'http'),'^(.*)[\.:,]$', '$1'),' ',''),'NFKD'),'\p{Mn}',''),'NFKC')"/>
                        <xsl:variable name="prefLabel" select="document(concat(marc:subfield[@code='0'][1],'.skos.rdf'))//replace(normalize-unicode(replace(normalize-unicode(replace(replace(skos:prefLabel,'--',''),' ',''),'NFKD'),'\p{Mn}',''),'NFKC'),'^(.*)[\.:,]$', '$1')"/>
                        <xsl:variable name="subf0">
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString" select="marc:subfield[@code='0'][1]"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:if test="$prefLabel=$concatSubjects">
                            <xsl:attribute name="valueURI">
                                <xsl:value-of select="replace($subf0,'^(.*)[\.:,]$', '$1')"/>
                            </xsl:attribute>
                        </xsl:if>
                    </xsl:if>
                    <mods:titleInfo type="uniform">
                        <mods:title>
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString" select="marc:subfield[@code='a']"/>
                            </xsl:call-template>
                        </mods:title>
                        <xsl:if test="marc:subfield[@code='p']">
                            <mods:partName>
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString" select="marc:subfield[@code='p']"/>
                                </xsl:call-template>
                            </mods:partName>
                        </xsl:if>
                        <xsl:if test="marc:subfield[@code='n']">
                            <mods:partNumber>
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString" select="marc:subfield[@code='n']"/>
                                </xsl:call-template>
                            </mods:partNumber>
                        </xsl:if>
                    </mods:titleInfo>
                    <xsl:for-each select="marc:subfield[@code='x']">
                        <mods:topic>
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString" select="."/>
                            </xsl:call-template>
                        </mods:topic>
                    </xsl:for-each>                       
                    <xsl:for-each select="marc:subfield[@code='v']">
                        <mods:genre>
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString" select="."/>
                            </xsl:call-template>
                        </mods:genre>
                    </xsl:for-each>
                </mods:subject>
            </xsl:when>
            <xsl:when test="@ind2='7'">
                <mods:subject authority="fast" authorityURI="http://id.worldcat.org/fast">
                    <xsl:attribute name="valueURI">
                        <xsl:choose>
                            <xsl:when test="starts-with(marc:subfield[@code='0'],'http')">
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString" select="marc:subfield[@code='0']"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="fast-valueURI">
                                    <xsl:with-param name="fast-uri" select="marc:subfield[@code='0']"/>
                                </xsl:call-template>  
                            </xsl:otherwise>
                        </xsl:choose>                        
                    </xsl:attribute>
                    <mods:titleInfo type="uniform">
                        <mods:title>
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString" select="marc:subfield[@code='a']"/>
                            </xsl:call-template>
                        </mods:title>
                        <xsl:if test="marc:subfield[@code='p']">
                            <mods:partName>
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString" select="marc:subfield[@code='p']"/>
                                </xsl:call-template>
                            </mods:partName>
                        </xsl:if>
                        <xsl:if test="marc:subfield[@code='n']">
                            <mods:partNumber>
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString" select="marc:subfield[@code='n']"/>
                                </xsl:call-template>
                            </mods:partNumber>
                        </xsl:if>
                    </mods:titleInfo>
                </mods:subject>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="subjects-648">
        <mods:subject authority="fast" authorityURI="http://id.worldcat.org/fast">
            <mods:temporal>
                <xsl:value-of select="marc:subfield[@code='a']"/>
            </mods:temporal>
        </mods:subject>
    </xsl:template>
    
    <xsl:template name="subjects-650">
        <xsl:choose>
            <xsl:when test="@ind2='0'">
                <mods:subject authority="lcsh" authorityURI="http://id.loc.gov/authorities/subjects">
                    <!-- only add valueURI if exact match of entire subject string -->
                    <xsl:if test="marc:subfield[@code='0'] and .[@ind2='0']">
                        <xsl:variable name="concatSubjects" select="normalize-unicode(replace(normalize-unicode(replace(replace(substring-before(.,'http'),'^(.*)[\.:,]$', '$1'),' ',''),'NFKD'),'\p{Mn}',''),'NFKC')"/>
                        <xsl:variable name="subf0">
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString" select="marc:subfield[@code='0'][1]"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="prefLabel" select="document(concat($subf0,'.skos.rdf'))//replace(normalize-unicode(replace(normalize-unicode(replace(replace(skos:prefLabel,'--',''),' ',''),'NFKD'),'\p{Mn}',''),'NFKC'),'^(.*)[\.:,]$', '$1')"/>
                        <xsl:if test="$prefLabel=$concatSubjects">
                            <xsl:attribute name="valueURI">
                                <xsl:value-of select="replace(marc:subfield[@code='0'][1],'^(.*)[\.:,]$', '$1')"/>
                            </xsl:attribute>
                        </xsl:if>
                    </xsl:if>
                    <xsl:for-each select="marc:subfield">
                        <xsl:if test="@code='a'">
                            <mods:topic>
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString" select=".[@code='a']"/>
                                </xsl:call-template>
                            </mods:topic>
                        </xsl:if>
                        <xsl:if test="@code='x'">
                            <mods:topic>
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString" select=".[@code='x']"/>
                                </xsl:call-template>
                            </mods:topic>
                        </xsl:if>
                        <xsl:if test="@code='y'">
                            <mods:temporal>
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString" select=".[@code='y']"/>
                                </xsl:call-template>
                            </mods:temporal>
                        </xsl:if>
                        <xsl:if test="@code='z'">
                            <mods:geographic>
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString" select=".[@code='z']"/>
                                </xsl:call-template>
                            </mods:geographic>
                        </xsl:if>
                        <xsl:if test="@code='v'">
                            <mods:genre>
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString" select=".[@code='v']"/>
                                </xsl:call-template>
                                <xsl:if test="ends-with(.[@code='v'],'etc.')">
                                    <xsl:text>.</xsl:text>
                                </xsl:if>
                            </mods:genre>
                        </xsl:if>
                    </xsl:for-each>
                </mods:subject>
            </xsl:when>
            <xsl:when test="@ind2='7' and marc:subfield[@code='2']='fast'">
                <mods:subject authority="fast" authorityURI="http://id.worldcat.org/fast">
                    <xsl:attribute name="valueURI">
                        <xsl:choose>
                            <xsl:when test="starts-with(marc:subfield[@code='0'],'http')">
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString" select="marc:subfield[@code='0']"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="fast-valueURI">
                                    <xsl:with-param name="fast-uri" select="marc:subfield[@code='0']"/>
                                </xsl:call-template>                               
                            </xsl:otherwise>
                        </xsl:choose>                        
                    </xsl:attribute>
                    <mods:topic>
                        <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString" select="marc:subfield[@code='a']"/>
                        </xsl:call-template>
                    </mods:topic>
                    <xsl:for-each select="marc:subfield[@code='x']">
                        <mods:topic>
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString" select="."/>
                            </xsl:call-template>
                        </mods:topic>
                    </xsl:for-each>
                </mods:subject>
            </xsl:when>
            <xsl:when test="@ind2='7' and marc:subfield[@code='2']='umi'">
                <mods:subject authority="umi">
                    <mods:topic>
                        <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString" select="marc:subfield[@code='a']"/>
                        </xsl:call-template>
                    </mods:topic>
                    <xsl:for-each select="marc:subfield[@code='x']">
                        <mods:topic>
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString" select="."/>
                            </xsl:call-template>
                        </mods:topic>
                    </xsl:for-each>
                </mods:subject>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="subjects-651">
        <xsl:choose>
            <xsl:when test="@ind2='0'">
                <mods:subject authority="lcsh" authorityURI="http://id.loc.gov/authorities/subjects">
                    <xsl:for-each select="marc:subfield">
                        <xsl:if test="@code='a'">
                            <mods:geographic>
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString" select=".[@code='a']"/>
                                </xsl:call-template>
                            </mods:geographic>
                        </xsl:if>
                        <xsl:if test="@code='z'">
                            <mods:geographic>
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString" select=".[@code='z']"/>
                                </xsl:call-template>
                            </mods:geographic>
                        </xsl:if>
                        <xsl:if test="@code='x'">
                            <mods:topic>
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString" select=".[@code='x']"/>
                                </xsl:call-template>
                            </mods:topic>
                        </xsl:if>
                        <xsl:if test="@code='y'">
                            <mods:temporal>
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString" select=".[@code='y']"/>
                                </xsl:call-template>
                            </mods:temporal>
                        </xsl:if>
                        <xsl:if test="@code='v'">
                            <mods:genre>
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString" select=".[@code='v']"/>
                                </xsl:call-template>
                                <xsl:if test="ends-with(.[@code='v'],'etc.')">
                                    <xsl:text>.</xsl:text>
                                </xsl:if>
                            </mods:genre>
                        </xsl:if>
                    </xsl:for-each>
                </mods:subject>
            </xsl:when>
            <xsl:when test="@ind2='7' and marc:subfield[@code='2']='fast'">
                <mods:subject authority="fast" authorityURI="http://id.worldcat.org/fast">
                    <xsl:attribute name="valueURI">
                        <xsl:choose>
                            <xsl:when test="starts-with(marc:subfield[@code='0'],'http')">
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString" select="marc:subfield[@code='0']"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="fast-valueURI">
                                    <xsl:with-param name="fast-uri" select="marc:subfield[@code='0']"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>                        
                    </xsl:attribute>
                    <mods:geographic>
                        <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString" select="marc:subfield[@code='a']"/>
                        </xsl:call-template>
                    </mods:geographic>
                    <xsl:for-each select="marc:subfield[@code='z']">
                        <mods:geographic>
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString" select="."/>
                            </xsl:call-template>
                        </mods:geographic>
                    </xsl:for-each>
                </mods:subject>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name ="genre-655">
        <xsl:if test="marc:subfield[@code='a']='Cadastral maps.' and marc:subfield[@code='2']='lcgft'">
            <mods:genre authority="aat" 
                authorityURI="http://vocab.getty.edu/aat" 
                valueURI="http://vocab.getty.edu/aat/300028102">Cadastral maps</mods:genre>
            <mods:genre authority="aat" 
                authorityURI="http://vocab.getty.edu/aat" 
                valueURI="http://vocab.getty.edu/aat/300028125">Plats (maps)</mods:genre>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="subjects-662">
        <mods:subject authority="tgn" authorityURI="http://vocab.getty.edu/tgn">
            <xsl:choose>
                <xsl:when test="contains(marc:subfield[@code='0'],')')">
                    <xsl:attribute name="valueURI">
                        <xsl:text>http://vocab.getty.edu/tgn/</xsl:text>
                        <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString" select="substring-after(marc:subfield[@code='0'],')')"/>
                        </xsl:call-template>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>            
            <mods:hierarchicalGeographic>
                <xsl:for-each select="marc:subfield[@code='a']">
                    <xsl:choose>
                        <xsl:when test="contains(.,'(continent)')">
                            <mods:continent>
                                <xsl:value-of select="."/>
                            </mods:continent>
                        </xsl:when>
                        <xsl:when test="contains(.,'(nation)')">
                            <mods:country>
                                <xsl:value-of select="."/>
                            </mods:country>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
                <xsl:for-each select="marc:subfield[@code='b']">
                    <xsl:choose>
                        <xsl:when test="contains(.,'(state)')">
                            <mods:state>
                                <xsl:value-of select="."/>
                            </mods:state>
                        </xsl:when>
                        <xsl:when test="contains(.,'(national district)')">
                            <mods:region>
                                <xsl:value-of select="."/>
                            </mods:region>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
                <xsl:for-each select="marc:subfield[@code='c']">
                    <mods:county>
                        <xsl:value-of select="."/>
                    </mods:county>
                </xsl:for-each>
                <xsl:for-each select="marc:subfield[@code='d']">
                    <mods:city>
                        <xsl:value-of select="."/>
                    </mods:city>
                </xsl:for-each>
                <xsl:for-each select="marc:subfield[@code='f']">
                    <mods:citySection>
                        <xsl:value-of select="."/>
                    </mods:citySection>
                </xsl:for-each>
                <xsl:for-each select="marc:subfield[@code='g']">
                    <mods:area>
                        <xsl:value-of select="."/>
                    </mods:area>
                </xsl:for-each>
            </mods:hierarchicalGeographic>
        </mods:subject>
    </xsl:template>
    
    <!-- catalog link -->
    <xsl:template name="catalog-link">
        <mods:relatedItem type="isReferencedBy">
            <mods:location>
                <mods:url note="catalog_record">
                    <xsl:variable name="opacRecord" select="document(concat('http://catalog.lib.msu.edu/xmlopac/o',replace(.,'\D','')))"/>
                            <xsl:variable name="bibnumber" select="$opacRecord//RecordId/RecordKey"/>
                            <xsl:value-of select="concat('http://catalog.lib.msu.edu/record=',$bibnumber)"/>
                </mods:url>
            </mods:location>
        </mods:relatedItem>
    </xsl:template>
    
    <!-- convert subf0 to valueURI for FAST subjects -->
    <xsl:template name="fast-valueURI">
        <xsl:param name="fast-uri"/>
        <xsl:text>http://id.worldcat.org/fast/</xsl:text>
        <xsl:call-template name="chopPunctuation">
            <xsl:with-param name="chopString">
                <xsl:call-template name="normalizeID">
                    <xsl:with-param name="id" select="substring-after($fast-uri,'fst')"/>
                </xsl:call-template>
            </xsl:with-param>                                       
        </xsl:call-template>
    </xsl:template>
    
    <!-- Chop initial 0's from FAST ID and remove spaces from identifiers -->
    <xsl:template name="normalizeID">
        <xsl:param name="id"/>
        <xsl:choose>
            <xsl:when test="starts-with($id,'00')">
                <xsl:call-template name="normalizeID">
                    <xsl:with-param name="id" select="substring($id,3)"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with($id,'0')">
                <xsl:call-template name="normalizeID">
                    <xsl:with-param name="id" select="substring($id,2)"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="replace($id,' ','')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- uri template -->
    <xsl:template name="uri">
        <xsl:for-each select="marc:subfield[@code = '0']">
            <xsl:attribute name="valueURI">
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString">
                        <xsl:value-of select="."/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:attribute>
        </xsl:for-each>
    </xsl:template>
    
    
</xsl:stylesheet>
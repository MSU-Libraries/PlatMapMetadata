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
    <xsl:key name="marcRecords" match="pair" use="@oclc"/>
 
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
  
    <xsl:template match="record">
        <xsl:variable name="marcRecord" select="document(concat(@oclc,'_marcxml.xml'))"/>
        <xsl:result-document href="{concat(@repoFileName,'_mods.xml')}">
     <xsl:choose>
         <xsl:when test="@pageTitle='Advertisements'">
             <xsl:call-template name="Advertisements">
                 <xsl:with-param name="marcRecord" select="$marcRecord"/>
             </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
    
    <mods:mods xmlns:mods="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink" version="3.7">
        <mods:titleInfo>
            <mods:title>
                <xsl:choose>
                    <xsl:when test="@pageTitle!='' and @pageTitle!='no' and @township!='' and @township!='no'">
                        <xsl:value-of select="@pageTitle"/>
                        <xsl:text>, Township </xsl:text>
                        <xsl:value-of select="@township"/>
                        <xsl:text> Range </xsl:text>
                        <xsl:value-of select="@range"/>
                    </xsl:when>
                    <xsl:when test="@pageTitle='' and @township!=''">
                        <xsl:text>Township </xsl:text>
                        <xsl:value-of select="@township"/>
                        <xsl:text> Range </xsl:text>
                        <xsl:value-of select="@range"/>
                    </xsl:when>
                    <xsl:when test="@pageTitle!='' and @township=''">
                        <xsl:value-of select="@pageTitle"/>
                    </xsl:when>
                    <xsl:when test="@township='no' and @pageTitle!='no'">
                        <xsl:value-of select="@pageTitle"/>
                    </xsl:when>
                </xsl:choose>
            </mods:title>
        </mods:titleInfo>
        <mods:name authority="naf" authorityURI="http://id.loc.gov/authorities/names" type="corporate"
            valueURI="http://id.loc.gov/authorities/names/n86863380">
            <mods:namePart>W.W. Hixson &amp; Co.</mods:namePart>
            <mods:role>
                <mods:roleTerm authority="marcrelator" authorityURI="http://id.loc.gov/vocabulary/relators"
                    type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctg">cartographer</mods:roleTerm>
            </mods:role>
            <mods:role>
                <mods:roleTerm authority="marcrelator" authorityURI="http://id.loc.gov/vocabulary/relators"
                    type="text" valueURI="http://id.loc.gov/vocabulary/relators/pbl">publisher</mods:roleTerm>
            </mods:role>
        </mods:name>
        
        <mods:typeOfResource>cartographic</mods:typeOfResource>
        <mods:genre authority="dct" authorityURI="http://purl.org/dc/terms/DCMIType" valueURI="http://purl.org/dc/dcmitype/StillImage">StillImage</mods:genre>
        <mods:genre authority="aat" authorityURI="http://vocab.getty.edu/aat" valueURI="http://vocab.getty.edu/aat/300028125">Plats (maps)</mods:genre>
        <mods:genre authority="aat" authorityURI="http://vocab.getty.edu/aat" valueURI="http://vocab.getty.edu/aat/300028102">Cadastral maps</mods:genre>
        <mods:genre authority="lcgft" authorityURI="http://id.loc.gov/authorities/genreForms" valueURI="http://id.loc.gov/authorities/genreForms/gf2011026106">Cadastral maps</mods:genre>
        <mods:genre authority="aat" authorityURI="http://vocab.getty.edu/aat" valueURI="http://vocab.getty.edu/aat/300028094">Maps (documents)</mods:genre>
        
        
        <!-- publication -->
        <xsl:for-each select="$marcRecord//marc:datafield[@tag='264' or @tag='260']">
            <mods:originInfo eventType="publication">
                <mods:place>
                    <mods:placeTerm type="text">
                        <xsl:text>Rockford, Illinois</xsl:text>
<!--                        <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString">
                                <xsl:call-template name="chopPunctuationFront">
                                    <xsl:with-param name="chopString" select="replace(replace(marc:subfield[@code='a'],'\[',''),'\]','')"/>
                                </xsl:call-template>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:if test="ends-with(marc:subfield[@code='a'],'Ill. :')">
                            <xsl:text>.</xsl:text>
                        </xsl:if>-->
                    </mods:placeTerm>
                </mods:place>
                <xsl:choose>
                    <xsl:when test="contains(lower-case(marc:subfield[@code='b']),'publisher not identified')"/>                       
                    <xsl:otherwise>
                        <mods:publisher>
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString">
                                    <xsl:call-template name="chopPunctuationFront">
                                        <xsl:with-param name="chopString" select="replace(replace(marc:subfield[@code='b'],'\[',''),'\]','')"/>
                                    </xsl:call-template>
                                </xsl:with-param>
                            </xsl:call-template>
                            <xsl:if test="ends-with(marc:subfield[@code='b'],'Co.,')">
                                <xsl:text>.</xsl:text>
                            </xsl:if>
                        </mods:publisher>
                    </xsl:otherwise>
                </xsl:choose>                
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
        </xsl:for-each>
        
        <mods:language>
            <mods:languageTerm authority="iso639-2b" authorityURI="http://id.loc.gov/vocabulary/iso639-2" type="code" valueURI="http://id.loc.gov/vocabulary/iso639-2/eng">eng</mods:languageTerm>
            <mods:languageTerm authority="iso639-2b" authorityURI="http://id.loc.gov/vocabulary/iso639-2" type="text" valueURI="http://id.loc.gov/vocabulary/iso639-2/eng">English</mods:languageTerm>
        </mods:language>
        
        <mods:physicalDescription>
            <mods:form authority="marccategory" authorityURI="http://id.loc.gov/vocabulary/genreFormSchemes/marccategory">electronic resource</mods:form>
            <mods:digitalOrigin>reformatted digital</mods:digitalOrigin>
            <mods:extent>1 map</mods:extent>
        </mods:physicalDescription>
        
        <!-- Host of the book -->
        <mods:note>
            <xsl:text>Page from: </xsl:text>
            <xsl:for-each select="$marcRecord//marc:datafield[@tag='245']">
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
                
                <xsl:if test="marc:subfield[@code='b']">
                    <xsl:text> : </xsl:text>
                    <xsl:call-template name="chopPunctuationFront">
                        <xsl:with-param name="chopString">
                            <xsl:call-template name="chopPunctuationBack">
                                <xsl:with-param name="chopString" select="marc:subfield[@code='b']"/>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
            </xsl:for-each>
        </mods:note>
        
        <!-- subjects - map coordinates and scale-->
        <mods:subject>
            <mods:cartographics>
                <!-- pull from spreadsheet -->
                    <mods:coordinates>
                        <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString" select="replace(replace(@coordinates_255,'\(',''),'\)','')"/>
                        </xsl:call-template>
                       <!-- <xsl:value-of select="@coordinates_255"/>-->
                    </mods:coordinates>
                
                <!-- take from MARC record? -->
                <xsl:for-each select="$marcRecord//marc:datafield[@tag='255']">
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
                </xsl:for-each>
            </mods:cartographics>
        </mods:subject>
        
        <!-- 043 field -->
        <xsl:for-each select="$marcRecord//marc:datafield[@tag='043']">
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
        </xsl:for-each>
        
        <xsl:for-each select="$marcRecord//marc:datafield[@tag='650'][not(matches(marc:subfield[@code='a'],'Small business','i'))]">
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
        </xsl:for-each>
        
        <xsl:for-each select="$marcRecord//marc:datafield[@tag='651']">
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
        </xsl:for-each>
        
        
        
        <!-- catalog link -->
        <xsl:for-each select="$marcRecord//marc:datafield[@tag='907']">
            <mods:relatedItem type="isReferencedBy">
                <mods:location>
                    <mods:url note="catalog_record">
                        <xsl:variable name="bib-number" select="substring-after(marc:subfield[@code='a'],'.')"/>
                        <xsl:value-of select="concat('http://catalog.lib.msu.edu/record=',substring($bib-number,1,string-length($bib-number)-1))"/>
                    </mods:url>
                </mods:location>
            </mods:relatedItem>    
        </xsl:for-each>
        
<!--        <xsl:for-each select="$marcRecord//marc:datafield[@tag='907']">
            <mods:relatedItem type="isReferencedBy">
                <mods:location>
                    <mods:url note="catalog_record">
                        <xsl:for-each select="marc:subfield[@code='a']">
                            <xsl:value-of select="concat('http://catalog.lib.msu.edu/record=b',replace(.,'\D',''))"/>
                        </xsl:for-each>
                    </mods:url>
                </mods:location>
            </mods:relatedItem>
        </xsl:for-each>-->
        
        
            <mods:relatedItem type="host">
                <mods:titleInfo>
                    <mods:title>Maps</mods:title>                    
                </mods:titleInfo>
                <mods:identifier type="oai_set">maps_root</mods:identifier>
            </mods:relatedItem>
            <mods:identifier type="filename">
                <xsl:value-of select="@repoFileName"/>
            </mods:identifier>
        <mods:accessCondition type="use and reproduction">Creative Commons Public Domain Mark 1.0: This work has been identified as being free of known restrictions under copyright law, including all related and neighboring rights. You can copy, modify, distribute and perform the work, even for commercial purposes, all without asking permission.</mods:accessCondition><mods:accessCondition xmlns:xlink="http://www.w3.org/1999/xlink" type="dpla" xlink:href="https://creativecommons.org/publicdomain/mark/1.0/">No Copyright</mods:accessCondition>
        
        <mods:recordInfo>
            <xsl:for-each select="$marcRecord//marc:leader">
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
            </xsl:for-each>
            
            <xsl:call-template name="recordID"/>
            
            <mods:recordOrigin>Converted from MARCXML to MODS version 3.7 using a custom XSLT.</mods:recordOrigin>
            
            <xsl:for-each select="$marcRecord//marc:datafield[@tag='040']">
                <xsl:for-each select="marc:subfield[@code='b']">
                    <mods:languageOfCataloging>
                        <mods:languageTerm authority="iso639-2b" type="code">
                            <xsl:value-of select="."/>
                        </mods:languageTerm>
                    </mods:languageOfCataloging>
                </xsl:for-each>
            </xsl:for-each>
        </mods:recordInfo>
    </mods:mods>
         </xsl:otherwise>
     </xsl:choose>
        </xsl:result-document>
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
    
    <xsl:template name="Advertisements">
        <xsl:param name="marcRecord"/>
        <mods:mods xmlns:mods="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink" version="3.7">        <mods:titleInfo>
            <mods:title>Advertisements</mods:title>
        </mods:titleInfo>
        <mods:name authority="naf" authorityURI="http://id.loc.gov/authorities/names" type="corporate"
            valueURI="http://id.loc.gov/authorities/names/n86863380">
            <mods:namePart>W.W. Hixson &amp; Co.</mods:namePart>
            <mods:role>
                <mods:roleTerm authority="marcrelator" authorityURI="http://id.loc.gov/vocabulary/relators"
                    type="text" valueURI="http://id.loc.gov/vocabulary/relators/pbl">publisher</mods:roleTerm>
            </mods:role>
        </mods:name>
        
        <mods:typeOfResource>text</mods:typeOfResource>
            <mods:genre authority="dct" authorityURI="http://purl.org/dc/terms/DCMIType" valueURI="http://purl.org/dc/dcmitype/Text">Text</mods:genre>
            <mods:genre authority="aat" authorityURI="http://vocab.getty.edu/aat" valueURI="http://vocab.getty.edu/aat/300193993">Advertisements</mods:genre>
            
        
        <!-- publication 264 or 260-->
            <xsl:for-each select="$marcRecord//marc:datafield[@tag='264' or @tag='260']">
        <mods:originInfo eventType="publication">
            <mods:place>
                <mods:placeTerm type="text">
                    <xsl:text>Rockford, Illinois</xsl:text>
                   <!-- <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString">
                            <xsl:call-template name="chopPunctuationFront">
                                <xsl:with-param name="chopString" select="replace(replace(marc:subfield[@code='a'],'\[',''),'\]','')"/>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                    <xsl:if test="ends-with(marc:subfield[@code='a'],'Ill. :')">
                        <xsl:text>.</xsl:text>
                    </xsl:if>-->
                </mods:placeTerm>
            </mods:place>
            <xsl:choose>
                <xsl:when test="contains(lower-case(marc:subfield[@code='b']),'publisher not identified')"/>                       
                <xsl:otherwise>
                    <mods:publisher>
                        <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString">
                                <xsl:call-template name="chopPunctuationFront">
                                    <xsl:with-param name="chopString" select="replace(replace(marc:subfield[@code='b'],'\[',''),'\]','')"/>
                                </xsl:call-template>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:if test="ends-with(marc:subfield[@code='b'],'Co.,')">
                            <xsl:text>.</xsl:text>
                        </xsl:if>
                    </mods:publisher>
                </xsl:otherwise>
            </xsl:choose>                
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
        </xsl:for-each>
       
        <mods:language>
            <mods:languageTerm authority="iso639-2b" authorityURI="http://id.loc.gov/vocabulary/iso639-2" type="code" valueURI="http://id.loc.gov/vocabulary/iso639-2/eng">eng</mods:languageTerm>
            <mods:languageTerm authority="iso639-2b" authorityURI="http://id.loc.gov/vocabulary/iso639-2" type="text" valueURI="http://id.loc.gov/vocabulary/iso639-2/eng">English</mods:languageTerm>
        </mods:language>
        
        <mods:physicalDescription>
            <mods:form authority="marccategory" authorityURI="http://id.loc.gov/vocabulary/genreFormSchemes/marccategory">electronic resource</mods:form>
            <mods:digitalOrigin>reformatted digital</mods:digitalOrigin>
            <mods:extent>1 page</mods:extent>
        </mods:physicalDescription>
        
        <!-- Host of the book -->
        <mods:note>
            <xsl:text>Page from: </xsl:text>
            <xsl:for-each select="$marcRecord//marc:datafield[@tag='245']">
                <xsl:call-template name="chopPunctuationFront">
                    <xsl:with-param name="chopString">
                        <xsl:call-template name="chopPunctuationBack">
                            <xsl:with-param name="chopString" select="marc:subfield[@code='a']"/>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:if test="marc:subfield[@code='b']">
                    <xsl:text> : </xsl:text>
                    <xsl:call-template name="chopPunctuationFront">
                        <xsl:with-param name="chopString">
                            <xsl:call-template name="chopPunctuationBack">
                                <xsl:with-param name="chopString" select="marc:subfield[@code='b']"/>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
            </xsl:for-each>
        </mods:note>
        

        
        <!-- 043 field -->
        <xsl:for-each select="$marcRecord//marc:datafield[@tag='043']">
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
        </xsl:for-each>
        
            <xsl:for-each select="$marcRecord//marc:datafield[@tag='650'][matches(marc:subfield[@code='a'],'Small business','i')]">
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
               
            </xsl:choose>
        </xsl:for-each>
            
            <xsl:for-each select="$marcRecord//marc:datafield[@tag='651']">
                <xsl:choose>
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
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:for-each>
        
        
        <!-- catalog link -->
        <xsl:for-each select="$marcRecord//marc:datafield[@tag='907']">
            <mods:relatedItem type="isReferencedBy">
                <mods:location>
                    <mods:url note="catalog_record">
                        <xsl:variable name="bib-number" select="substring-after(marc:subfield[@code='a'],'.')"/>
                        <xsl:value-of select="concat('http://catalog.lib.msu.edu/record=',substring($bib-number,1,string-length($bib-number)-1))"/>
                    </mods:url>
                </mods:location>
            </mods:relatedItem>    
        </xsl:for-each>
       
        
            <mods:relatedItem type="host">
                <mods:titleInfo>
                    <mods:title>Maps</mods:title>                    
                </mods:titleInfo>
                <mods:identifier type="oai_set">maps_root</mods:identifier>
            </mods:relatedItem>
            <mods:identifier type="filename">
                <xsl:value-of select="@repoFileName"/>
            </mods:identifier>
            <mods:accessCondition type="use and reproduction">Creative Commons Public Domain Mark 1.0: This work has been identified as being free of known restrictions under copyright law, including all related and neighboring rights. You can copy, modify, distribute and perform the work, even for commercial purposes, all without asking permission.</mods:accessCondition>
        <mods:accessCondition xmlns:xlink="http://www.w3.org/1999/xlink" type="dpla" xlink:href="https://creativecommons.org/publicdomain/mark/1.0/">No Copyright</mods:accessCondition>
                    <mods:recordInfo>
                        <xsl:for-each select="$marcRecord//marc:leader">
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
                        </xsl:for-each>
                        
                        <xsl:call-template name="recordID"/>
                                                
                        <mods:recordOrigin>Converted from MARCXML to MODS version 3.7 using a custom XSLT.</mods:recordOrigin>
                        <xsl:for-each select="$marcRecord//marc:datafield[@tag='040']">
                        <xsl:for-each select="marc:subfield[@code='b']">
                            <mods:languageOfCataloging>
                                <mods:languageTerm authority="iso639-2b" type="code">
                                    <xsl:value-of select="."/>
                                </mods:languageTerm>
                            </mods:languageOfCataloging>
                        </xsl:for-each>
                        </xsl:for-each>
                    </mods:recordInfo>
    </mods:mods>
    </xsl:template>
    
    <xsl:template name="recordID">
        <mods:recordIdentifier source="MiEM">
            <xsl:text>maps:</xsl:text>
            <xsl:value-of select="@repoFileName"/>
        </mods:recordIdentifier>
    </xsl:template>
    
</xsl:stylesheet>
To create children objects, run hixsonPlatMaps over the Hixson_plat_maps_spreadsheet. It will pull in the relevant Marc records.
To create parent objects, run marc2mods.xsl.
To create the DC, change the filename generator to: <xsl:result-document href="{substring-before(base-uri(),'_mods')}_dc.xml">

Cataloged Hixson plat books not scanned:
1108754056 Berrien County, Michigan
1065524642 Presque Isle, Michigan
1108754320 Montgomery County, Indiana

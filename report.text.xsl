<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:str="xalan://java.lang.String"  version="1.0">
	<xsl:output method="text"/>
	<xsl:template match="/OWASPZAPReport">
		<xsl:apply-templates select="descendant::alertitem">
			<xsl:sort order="descending" data-type="number" select="riskcode"/>
			<xsl:sort order="descending" data-type="number" select="confidence"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="alertitem">
		<xsl:variable name="descValue">
			<xsl:value-of select="str:replaceAll(str:new(desc),'&lt;/*p&gt;','')"/>
		</xsl:variable>
		<xsl:variable name="refValue1">
			<xsl:value-of select="str:replaceAll(str:new(reference),'&lt;p&gt;','')"/>
		</xsl:variable>
		<xsl:variable name="refValue">
			<xsl:value-of select="str:replaceAll(str:new($refValue1),'&lt;/p&gt;',' ')"/>
		</xsl:variable>
		<xsl:value-of select="concat(cweid, '¦', riskcode, '¦', riskdesc, '¦', name, '¦', $descValue, '¦', $refValue, '&#13;')"/>
	</xsl:template>
</xsl:stylesheet>

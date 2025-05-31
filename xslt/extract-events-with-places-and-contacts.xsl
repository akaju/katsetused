<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:ext="http://exslt.org/common"
		extension-element-prefixes="ext">

<xsl:variable name="places" select="document('places.xml')/places" /> 

<xsl:template match="/">
  <test>
    <xsl:apply-templates select="events" />
  </test>
</xsl:template>

<xsl:template match="event">
  <!-- save place id from parent place element -->
  <xsl:variable name="placeid" select="../@id"/>
  <!-- find place element from places catalog -->
  <xsl:variable name="place" select="$places//place[@id=$placeid][position()=1]" />
  <!-- find contact element from places catalog -->
  <xsl:variable name="contact" select="$places//contact[place[@id=$placeid]][position()=1]" />
  <event>
    <xsl:attribute name="id"><xsl:value-of select="@id" /></xsl:attribute>
    <xsl:attribute name="name"><xsl:value-of select="@name" /></xsl:attribute>
    <xsl:attribute name="place"><xsl:value-of select="$placeid" /></xsl:attribute>
    <!-- full copy of place element from catalog -->
    <xsl:copy-of select="$place" />
    <!-- partial copy of contact element from catalog, we don't want to have child elements copied -->
    <xsl:if test="$contact">
      <contact>
	<xsl:attribute name="id"><xsl:value-of select="$contact/@id" /></xsl:attribute>
	<xsl:attribute name="email"><xsl:value-of select="$contact/@email" /></xsl:attribute>
      </contact>
    </xsl:if>
  </event>
</xsl:template>

</xsl:stylesheet>

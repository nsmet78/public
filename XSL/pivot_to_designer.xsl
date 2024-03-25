<!-- Conversion XML Pivot vers XML Designer -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <!-- Le noeud racine devient "doc" --> 
  <xsl:template match="/*">
    <doc>
	<!-- continuer sur les éléments <doc> uniquement afin de ne pas récupérer les <field> globaux à ce stade --> 
      <xsl:apply-templates select="doc"/>
    </doc>
  </xsl:template>


  <!-- Les noeuds "doc" deviennent "page" et leur attribut "type" deviennent "name" -->
  <!-- Si absence de l'attribut @type, nommage avec la valeur "normal" -->
 <xsl:template match="/*/doc">
		<page>
			<xsl:apply-templates select="/*/field"/>
			<xsl:attribute name="name">
				<xsl:if test="@type != ''">
					<xsl:value-of select="@type"/>
				</xsl:if>
				<xsl:if test="@type = ''">
					<xsl:value-of select="'DEFAUT'"/>
				</xsl:if>
				<xsl:if test="not(@type)">
					<xsl:value-of select="'DEFAUT'"/>
				</xsl:if>
			</xsl:attribute>
			<xsl:apply-templates select="node()"/>
		</page>
	</xsl:template>


  <!-- Les noeuds "field" sont conservés leur attribut "id" devient "name" -->
  <!-- Si l'attribut @title est présent on le conserve --> 
  <xsl:template match="doc/field|item/field">
    <field>
      <xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute> 
      <xsl:if test="@title">
          <xsl:attribute name="title"><xsl:value-of select="@title"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="node()"/>
    </field>
  </xsl:template>

	
  <!-- Les noeuds "field" globaux sont ajoutés à chaque document <doc> et préfixés par "GLOBAL_"  -->
  <xsl:template match="/*/field">
    <field>
      <xsl:attribute name="name"><xsl:value-of select="'GLOBAL_'"/><xsl:value-of select="@id"/></xsl:attribute> 
      <xsl:if test="@title">
          <xsl:attribute name="title"><xsl:value-of select="@title"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="node()"/>
    </field>
  </xsl:template>


  <!-- Les noeuds "list" de premier niveau deviennent "group" et leur attribut "id" devient "name" --> 
  <xsl:template match="doc/list">
    <group>
      <xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute>
      <xsl:apply-templates select="node()"/>
    </group>
  </xsl:template>


  <!-- Les noeuds "list" niveaux suivants sont supprimés --> 
  <xsl:template match="item/list">
    <xsl:apply-templates select="node()"/>
  </xsl:template>


  <!-- Les noeuds "item" deviennent "line" --> 
  <!-- Leur attribut "name" est renseigné avec le nom de la liste parent -->
  <!-- Si présence de l'attribut @type, nommage avec cette valeur --> 
  <xsl:template match="item">
    <line>
        <xsl:if test="@type">
          <!-- Nommage avec l'attribut @type --> 
          <xsl:attribute name="name"><xsl:value-of select="@type"/></xsl:attribute>
        </xsl:if>
        <xsl:if  test="not(@type)">
          <!-- Nommage avec le nom de la liste parent --> 
          <xsl:attribute name="name"><xsl:value-of select="../@id"/></xsl:attribute> 
        </xsl:if>
      <xsl:apply-templates select="field"/>
    </line>
    <xsl:apply-templates select="list"/>
  </xsl:template>

</xsl:stylesheet>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <xsl:strip-space elements="*"/>

	<!-- This XSL is designed to add a grouping of list items to a data xml intended for Mapping - Processing based on XSLT/Muenchian grouping algorithm -->

	<!--*********** CUSTOM PARAMETERS ***********-->

	<!-- New grouping list name -->
  <!-- Example: <xsl:param name="grouping-list">supplier</xsl:param> -->
	<xsl:param name="grouping-list"></xsl:param>

	<!-- List on which to apply grouping -->
  <!-- Example: <xsl:param name="list">products</xsl:param> -->
	<xsl:param name="list"></xsl:param>

	<!-- fields used as grouping key -->
  <!-- Example: <xsl:param name="grouping-key1">supplier-id</xsl:param> -->
	<xsl:param name="grouping-key1"></xsl:param>
	<xsl:param name="grouping-key2"></xsl:param>

	<!-- Key declaration -->
	<!-- Replace "origin-list", "field-id_key-1" and "field-id_key-2" of example with the values as above -->
	<!-- Example: <xsl:key name="grouping-key" match="list[@id='products']/item" use="concat(../../node(),'|',field[@id='supplier-id'],'|')"/> -->
	<xsl:key name="grouping-key" match="list[@id='origin-list']/item" use="concat(../../node(),'|',field[@id='field-id_key-1'],'|','field[@id='field-id_key-2']')"/>


	<!-- fields to add in the grouping level -->
	<xsl:param name="field1"></xsl:param>
	<xsl:param name="field2"></xsl:param>
	<xsl:param name="field3"></xsl:param>
	<xsl:param name="field4"></xsl:param>
	<xsl:param name="field5"></xsl:param>


	<!-- totals -->
	<xsl:param name="sum1"></xsl:param>
	<xsl:param name="sum2"></xsl:param>
	<xsl:param name="sum3"></xsl:param>
	<xsl:param name="sum4"></xsl:param>
	<xsl:param name="sum5"></xsl:param>

	<!-- totals (from sublist) -->
	<xsl:param name="sum11"></xsl:param><xsl:param name="sum11_sublistid"></xsl:param>
	<xsl:param name="sum12"></xsl:param>   <xsl:param name="sum12_sublistid"></xsl:param>
	<xsl:param name="sum13"></xsl:param>   <xsl:param name="sum13_sublistid"></xsl:param>
	<xsl:param name="sum14"></xsl:param>   <xsl:param name="sum14_sublistid"></xsl:param>
	<xsl:param name="sum15"></xsl:param>   <xsl:param name="sum15_sublistid"></xsl:param>


	<!-- sorting keys-->
	<xsl:param name="sort-key1">ligne.ordre</xsl:param>
	<xsl:param name="sort-key2"></xsl:param>
	<xsl:param name="sort-key3"></xsl:param>
	<xsl:param name="sort-key4"></xsl:param>
  <xsl:param name="sort-key5"></xsl:param>

	<!-- sorting options - type : text or number - order : ascending or descending -->
	<xsl:param name="sort-key1-type">number</xsl:param>
	<xsl:param name="sort-key1-order">ascending</xsl:param>
	<xsl:param name="sort-key2-type">text</xsl:param>
	<xsl:param name="sort-key2-order">ascending</xsl:param>
	<xsl:param name="sort-key3-type">text</xsl:param>
	<xsl:param name="sort-key3-order">ascending</xsl:param>
	<xsl:param name="sort-key4-type">text</xsl:param>
	<xsl:param name="sort-key4-order">ascending</xsl:param>
  <xsl:param name="sort-key5-type">text</xsl:param>
	<xsl:param name="sort-key5-order">ascending</xsl:param>



	<!--***************-->
	<!--   TREATMENT   -->
	<!-- DO NOT MODIFY -->
	<!-- THIS  SECTION -->
	<!--***************-->
	<xsl:template match="list[@id=$list]">
		<list>
			<xsl:attribute name="id"><xsl:value-of select="$grouping-list"/></xsl:attribute>
			<xsl:for-each select="item[not(@type)][count(. | key('grouping-key',concat(../../node(),'|',field[@id=$grouping-key1],'|',field[@id=$grouping-key2]))[1]) = 1]">
				<xsl:sort select="field[@id=$sort-key1]" order="{$sort-key1-order}" data-type="{$sort-key1-type}" />
				<xsl:sort select="field[@id=$sort-key2]" order="{$sort-key2-order}" data-type="{$sort-key2-type}" />
				<xsl:sort select="field[@id=$sort-key3]" order="{$sort-key3-order}" data-type="{$sort-key3-type}" />
				<xsl:sort select="field[@id=$sort-key4]" order="{$sort-key4-order}" data-type="{$sort-key4-type}" />
        <xsl:sort select="field[@id=$sort-key5]" order="{$sort-key5-order}" data-type="{$sort-key5-type}" />
				<xsl:variable name="current-grouping-key" select="concat(../../node(),'|',field[@id=$grouping-key1],'|',field[@id=$grouping-key2])" />
				<xsl:variable name="current-item" select="key('grouping-key',$current-grouping-key)" />
				<item>
					<!-- key1 field and its value -->
					<field>
						<xsl:attribute name="id"><xsl:value-of select="$grouping-key1"/></xsl:attribute>
						<xsl:value-of select="field[@id=$grouping-key1]" />
					</field>

					<!-- key2 field and its value -->
					<field>
						<xsl:attribute name="id"><xsl:value-of select="$grouping-key2"/></xsl:attribute>
						<xsl:value-of select="field[@id=$grouping-key2]" />
					</field>



					<!-- fields -->
					<field>
						<xsl:attribute name="id"><xsl:value-of select="$field1"/></xsl:attribute>
						<xsl:value-of select="$current-item/field[@id=$field1]"/>
					</field>
					<field>
						<xsl:attribute name="id"><xsl:value-of select="$field2"/></xsl:attribute>
						<xsl:value-of select="$current-item/field[@id=$field2]"/>
					</field>
					<field>
						<xsl:attribute name="id"><xsl:value-of select="$field3"/></xsl:attribute>
						<xsl:value-of select="$current-item/field[@id=$field3]"/>
					</field>
					<field>
						<xsl:attribute name="id"><xsl:value-of select="$field4"/></xsl:attribute>
						<xsl:value-of select="$current-item/field[@id=$field4]"/>
					</field>
					<field>
						<xsl:attribute name="id"><xsl:value-of select="$field5"/></xsl:attribute>
						<xsl:value-of select="$current-item/field[@id=$field5]"/>
					</field>



					<!-- totals -->
					<field>
						<xsl:attribute name="id">count</xsl:attribute>
						<xsl:value-of select="count($current-item)"/>
					</field>
					<field>
						<xsl:attribute name="id">sum_<xsl:value-of select="$sum1"/></xsl:attribute>
						<xsl:value-of select="sum($current-item/field[@id=$sum1])"/>
					</field>
					<field>
						<xsl:attribute name="id">sum_<xsl:value-of select="$sum2"/></xsl:attribute>
						<xsl:value-of select="sum($current-item/field[@id=$sum2])"/>
					</field>
					<field>
						<xsl:attribute name="id">sum_<xsl:value-of select="$sum3"/></xsl:attribute>
						<xsl:value-of select="sum($current-item/field[@id=$sum3])"/>
					</field>
					<field>
						<xsl:attribute name="id">sum_<xsl:value-of select="$sum4"/></xsl:attribute>
						<xsl:value-of select="sum($current-item/field[@id=$sum4])"/>
					</field>
					<field>
						<xsl:attribute name="id">sum_<xsl:value-of select="$sum5"/></xsl:attribute>
						<xsl:value-of select="sum($current-item/field[@id=$sum5])"/>
					</field>

					<!-- totals (from sublist) -->

					<field>
						<xsl:attribute name="id">sum_<xsl:value-of select="$sum11_sublistid"/>_<xsl:value-of select="$sum11"/></xsl:attribute>
						<xsl:value-of select="sum($current-item/list[@id=$sum11_sublistid]/item/field[@id=$sum11])"/>
					</field>
					<field>
						<xsl:attribute name="id">sum_<xsl:value-of select="$sum12_sublistid"/>_<xsl:value-of select="$sum12"/></xsl:attribute>
						<xsl:value-of select="sum($current-item/list[@id=$sum12_sublistid]/item/field[@id=$sum12])"/>
					</field>
					<field>
						<xsl:attribute name="id">sum_<xsl:value-of select="$sum13_sublistid"/>_<xsl:value-of select="$sum13"/></xsl:attribute>
						<xsl:value-of select="sum($current-item/list[@id=$sum13_sublistid]/item/field[@id=$sum13])"/>
					</field>
					<field>
						<xsl:attribute name="id">sum_<xsl:value-of select="$sum14_sublistid"/>_<xsl:value-of select="$sum14"/></xsl:attribute>
						<xsl:value-of select="sum($current-item/list[@id=$sum14_sublistid]/item/field[@id=$sum14])"/>
					</field>
					<field>
						<xsl:attribute name="id">sum_<xsl:value-of select="$sum15_sublistid"/>_<xsl:value-of select="$sum15"/></xsl:attribute>
						<xsl:value-of select="sum($current-item/list[@id=$sum15_sublistid]/item/field[@id=$sum15])"/>
					</field>


					<!-- Sub list -->
					<list>
						<xsl:attribute name="id"><xsl:value-of select="$list"/></xsl:attribute>
						<xsl:for-each select="$current-item">
							<xsl:sort select="field[@id=$sort-key1]" order="{$sort-key1-order}" data-type="{$sort-key1-type}" />
							<xsl:sort select="field[@id=$sort-key2]" order="{$sort-key2-order}" data-type="{$sort-key2-type}" />
							<xsl:sort select="field[@id=$sort-key3]" order="{$sort-key3-order}" data-type="{$sort-key3-type}" />
							<xsl:sort select="field[@id=$sort-key4]" order="{$sort-key4-order}" data-type="{$sort-key4-type}" />
              <xsl:sort select="field[@id=$sort-key5]" order="{$sort-key5-order}" data-type="{$sort-key5-type}" />
							<xsl:copy>
								<xsl:apply-templates select="@*|*|text()|processing-instruction()"/>
							</xsl:copy>
						</xsl:for-each>
					</list>
				</item>
			</xsl:for-each>
		</list>
		<list>
			<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
      <xsl:for-each select="item[@type!='']">
        <xsl:copy>
          <xsl:apply-templates select="@*|*|text()|processing-instruction()"/>
        </xsl:copy>
      </xsl:for-each>
	   </list>

	</xsl:template>


	<xsl:template match="@*|*|comment()">
		<xsl:copy>
			<xsl:apply-templates select="@*|*|text()|processing-instruction()"/>
		</xsl:copy>
	</xsl:template>


</xsl:stylesheet>

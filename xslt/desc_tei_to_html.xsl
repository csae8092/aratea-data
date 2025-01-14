<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:html="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="#all"
	version="2.0">
	<xsl:variable name="Status"></xsl:variable>
	<xsl:variable name="showAuthorname">yes</xsl:variable>
	<xsl:variable name="full_path">
		<xsl:value-of select="document-uri(/)"/>
	</xsl:variable>
	<xsl:variable name="gbv"/>
	<xsl:variable name="githubPages">https://ivanadob.github.io/aratea-data/</xsl:variable>
	<xsl:variable name="facsimileData"/>
	<xsl:variable name="startfile"/>
	<xsl:variable name="imageParameter"/>
	<xsl:variable name="listPerson">../data/indices/listperson.xml</xsl:variable>
	<xsl:variable name="listBibl">../data/indices/listbibl.xml</xsl:variable>
	<xsl:variable name="lang"/>
	<xsl:variable name="gitData">https://github.com/ivanadob/aratea-data/blob/master/data/descriptions/</xsl:variable>
	<xsl:import href="nav_bar.xsl"/>
	
	<!-- version: 5.2 /2014/ (c) Herzog August Bibliothek / schassan@hab.de -->

	<!-- falls das Skript lokal genutzt werden soll, bitte folgende Adresse eintragen:  -->
	<xsl:import href="../xslt/hab-xsl/params/params.xsl"/>
	
	<xsl:output encoding="UTF-8" indent="no"/>
	<xsl:strip-space elements="*"/>

	<xsl:variable name="bibliography">
		<xsl:choose>
			<xsl:when test="//tei:list[@type = 'bibliography']">
				<xsl:copy-of select="//tei:list[@type = 'bibliography']"/>
			</xsl:when>
			<xsl:when test="not($listBibl = '')">
				<xsl:copy-of select="doc($listBibl)"/>
			</xsl:when>
		</xsl:choose>
	</xsl:variable>


<xsl:template match="/">
	<xsl:call-template name="DateiAusgeben">
				<xsl:with-param name="start"/>
			</xsl:call-template>
</xsl:template>

<xsl:template match="tei:*">
	<xsl:apply-templates/>
	<xsl:call-template name="Leerzeichen"/>
</xsl:template>

<xsl:template match="tei:abbr[not(normalize-space(.)='')]">
	<xsl:choose>
		<xsl:when test="parent::tei:bibl">
			<span>
				<xsl:attribute name="class">author</xsl:attribute>
				<xsl:call-template name="resolveAbbr"/>
			</span>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="resolveAbbr"/>
		</xsl:otherwise>
		</xsl:choose>
	<xsl:call-template name="Leerzeichen"/>	
</xsl:template>

<xsl:template name="resolveAbbr">
	<a>
		<xsl:attribute name="href">
			<xsl:text>#</xsl:text>
			<xsl:value-of select="translate(doc($listBibl)//tei:list[@type = 'bibliography']/tei:item/tei:label[. = current()][1],' ()','_')"/>
		</xsl:attribute>
		<xsl:apply-templates/>
	</a>
        <!--<xsl:choose>
            <!-\-<xsl:when test="ancestor::tei:source">
                <xsl:value-of select="$bibliography//tei:list[@type = 'bibliography']/tei:item[tei:label=current()]/tei:bibl"/>
            </xsl:when>-\->
            <xsl:when test="parent::tei:bibl and ((. = doc($listBibl)//tei:list[@type = 'bibliography'][not(preceding::tei:list[@type = 'bibliography'])]/tei:item/tei:label) or (@target = doc($listBibl)//tei:list[@type = 'bibliography'][not(preceding::tei:list[@type = 'bibliography'])]/tei:item/@xml:id))">
                <a>
                    <xsl:attribute name="href">
                        <xsl:text>#</xsl:text>
                        <xsl:value-of select="translate(doc($listBibl)//tei:list[@type = 'bibliography']/tei:item/tei:label[. = current()][1],' ()','_')"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </a>
            </xsl:when>
            <!-\-<xsl:when test="($listAbbreviatedTitles = 'yes') and parent::tei:bibl and    ((. = $bibliography//tei:list[@type = 'bibliography'][not(preceding::tei:list[@type = 'bibliography'])]/tei:item/tei:label) or    (@target = $bibliography//tei:list[@type = 'bibliography'][not(preceding::tei:list[@type = 'bibliography'])]/tei:item/@xml:id))">
                <a>
                    <xsl:attribute name="href">
                        <xsl:text>#</xsl:text>
                        <xsl:value-of select="translate($bibliography//tei:list[@type = 'bibliography'][not(preceding::tei:list[@type = 'bibliography'])]/tei:item[tei:label = current()]/tei:label,' ()','_')"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </a>
            </xsl:when>
            <xsl:when test="($listAbbreviatedTitles = 'no') and parent::tei:bibl and    ((. = $bibliography//tei:list[@type = 'bibliography'][not(preceding::tei:list[@type = 'bibliography'])]/tei:item/tei:label) or     (@target = $bibliography//tei:list[@type = 'bibliography'][not(preceding::tei:list[@type = 'bibliography'])]/tei:item/@xml:id))">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="$opac"/>
                        <xsl:choose>
                            <xsl:when test=". = $bibliography//tei:list[@type = 'bibliography'][not(preceding::tei:list[@type = 'bibliography'])]/tei:item/tei:label">
                                <xsl:value-of select="substring-after($bibliography//tei:list[@type = 'bibliography'][not(preceding::tei:list[@type = 'bibliography'])]/tei:item[tei:label=current()]/@xml:id,'opac_')"/>
                            </xsl:when>
                            <xsl:when test="@target = $bibliography//tei:list[@type = 'bibliography'][not(preceding::tei:list[@type = 'bibliography'])]/tei:item/@xml:id">
                                <xsl:value-of select="substring-after($bibliography//tei:list[@type = 'bibliography'][not(preceding::tei:list[@type = 'bibliography'])]/tei:item[@xml:id=current()/@target]/@xml:id,'opac_')"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:attribute>
                    <span>
                        <xsl:if test="self::tei:abbr">
                            <xsl:attribute name="class">author</xsl:attribute>
                        </xsl:if>
                        <xsl:apply-templates/>
                    </span>
                </a>
            </xsl:when>-\->
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>-->
    </xsl:template>
<xsl:template match="tei:accMat[not(normalize-space(.)='')] | tei:bindingDesc[not(normalize-space(.)='')]">
	<p>
		<xsl:attribute name="class">physDesc</xsl:attribute>
		<xsl:apply-templates/>
	</p>
</xsl:template>

<xsl:template match="tei:add[not(normalize-space(.)='')]">
	<span>
		<xsl:attribute name="class">normal</xsl:attribute>
		<xsl:text>[</xsl:text>
		<xsl:choose>
			<xsl:when test="@place = 'supralinear' ">über der Zeile: </xsl:when>
		</xsl:choose>
	</span>
	<xsl:apply-templates/>
	<span>
		<xsl:attribute name="class">normal</xsl:attribute>
		<xsl:text>]</xsl:text>
	</span>
</xsl:template>

<xsl:template match="tei:additional[not(normalize-space(.)='')]">
	<p>
		<xsl:attribute name="class">additional</xsl:attribute>
		<xsl:apply-templates select="tei:listBibl"/>
	</p>
</xsl:template>

<xsl:template match="tei:msIdentifier | tei:altIdentifier" mode="msPart">
	<p>
		<xsl:attribute name="class">part</xsl:attribute>
		<xsl:if test="tei:settlement != ancestor::tei:msDesc/tei:msIdentifier/tei:settlement">
			<xsl:value-of select="tei:settlement"/>
			<xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:if test="tei:institution != ancestor::tei:msDesc/tei:msIdentifier/tei:institution">
			<xsl:value-of select="tei:institution"/>
			<xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:if test="tei:repository != ancestor::tei:msDesc/tei:msIdentifier/tei:repository">
			<xsl:value-of select="tei:repository"/>
			<xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:if test="tei:collection != ancestor::tei:msDesc/tei:msIdentifier/tei:collection">
			<xsl:value-of select="tei:collection"/>
			<xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:value-of select="tei:idno"/>
	</p>
</xsl:template>

<xsl:template match="tei:altIdentifier">
	<xsl:choose>
		<xsl:when test="@type='siglum'">
			<div id="{generate-id()}">
				<span><xsl:attribute name="class">head</xsl:attribute>Sigle: </span>
				<xsl:apply-templates/>
			</div>
		</xsl:when>
	</xsl:choose>
</xsl:template>
<xsl:template match="tei:altIdentifier[@type='former']
	[not(@rend='doNotShow')]
	[not(contains(preceding-sibling::tei:idno, 'olim')) and not(contains(preceding-sibling::tei:idno, tei:idno))]" mode="Schlagzeile">
	<xsl:if test="not(preceding-sibling::tei:altIdentifier[@type='former'][not(@rend='doNotShow')])">
		<xsl:text> (olim: </xsl:text>
	</xsl:if>
	<xsl:if test="preceding-sibling::tei:altIdentifier[@type='former'][not(@rend='doNotShow')]">
		<xsl:text> / </xsl:text>
	</xsl:if>
	
	<xsl:apply-templates mode="Schlagzeile"/>
	<xsl:text>)</xsl:text>
</xsl:template>
	
<xsl:template match="tei:author[not(. = '')]">
		<span>
			<xsl:choose>
				<xsl:when test="parent::tei:msItem">
					<xsl:attribute name="class">msItemAuthor</xsl:attribute>
				</xsl:when>
				<xsl:when test="parent::tei:bibl">
					<xsl:attribute name="class">biblAuthor</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<xsl:if test="@rend='supplied'">[</xsl:if>
			<xsl:choose>
				<xsl:when test=" @ref != ' ' ">
					<a>
						<xsl:attribute name="href">
							<xsl:value-of select="concat($githubPages, 'listperson.html', @ref)"/>
						</xsl:attribute>	
						<xsl:value-of select="."/>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:choose>
				<xsl:when test="following-sibling::tei:author and 
					not(starts-with(substring-after(..,.),',')) and 
					not(starts-with(substring-after(..,.),':')) and 
					not(starts-with(substring-after(..,.),'.')) and
					not(contains(.,':'))">
					<xsl:text>, </xsl:text>
				</xsl:when>
				<xsl:when test="following-sibling::tei:title and 
					not(starts-with(substring-after(..,.),',')) and 
					not(starts-with(substring-after(..,.),':')) and 
					not(starts-with(substring-after(..,.),'.')) and
					not(contains(.,':'))">
					<xsl:text>: </xsl:text>
				</xsl:when>
				<xsl:when test="not(following-sibling::node()[name() = current()/name()]) and parent::tei:msItem and
					not(following-sibling::tei:title) and 
					not(starts-with(substring-after(..,.),',')) and 
					not(starts-with(substring-after(..,.),':')) and 
					not(starts-with(substring-after(..,.),'.')) and
					not(contains(.,':'))">
					<xsl:text>. </xsl:text>
				</xsl:when>
				<xsl:when test="not(parent::tei:bibl) and preceding-sibling::tei:ptr and normalize-space(following-sibling::text()[1])">
					<xsl:call-template name="Leerzeichen"/>
				</xsl:when>				
			</xsl:choose>
			<xsl:if test="@rend='supplied' and not(following-sibling::tei:title[1][@rend='supplied'])">]</xsl:if>
		</span>
	
</xsl:template>
	
	
<!--<xsl:template match="tei:author[not(normalize-space(.)='')] | tei:editor[not(normalize-space(.)='')]">
	<span>
		<xsl:attribute name="class">author</xsl:attribute>
		<xsl:if test=" @rend = 'supplied' "><xsl:text>[</xsl:text></xsl:if>
		<!-\-<xsl:choose>
			<xsl:when test="parent::tei:bibl">
				<xsl:choose>
					<xsl:when test="contains(@n,concat($searchfield,'_'))">
						<a>
							<xsl:attribute name="target">_blank</xsl:attribute>
							<xsl:attribute name="href">
								<xsl:value-of select="$opac"/>
								<xsl:choose>
									<xsl:when test="contains(substring-after(@n,concat($searchfield,'_')),';')">
										<xsl:value-of select="substring-before(substring-after(@n,concat($searchfield,'_')),';')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="substring-after(@n,concat($searchfield,'_'))"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:apply-templates/>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>-\->
		<xsl:if test=" @rend = 'supplied' and not( following-sibling::tei:title[ @rend = 'supplied' ]) "><xsl:text>]</xsl:text></xsl:if>
	</span>
	
</xsl:template>-->


<xsl:template match="tei:author" mode="Register">
	<xsl:if test="not(preceding::tei:author[. = current()])">
		<li>
			<xsl:choose>
				<!--<xsl:when test="starts-with(@ref, '#') and //@xml:id[.=substring(@ref,2)]">
					<xsl:apply-templates select="//*[@xml:id[.=substring(current()/@ref,2)]]" mode="Register"/>
				</xsl:when>-->
				<xsl:when test="starts-with(@ref, '#') and doc($listPerson)//tei:person[@xml:id]">
					<xsl:apply-templates select="//*[@ref=current()/@ref]" mode="Register"/>
				</xsl:when>
				<xsl:when test="contains(@ref, '_') and contains(@ref, '#')">
					<xsl:text>_keine Normdaten vorhanden: </xsl:text>
					<xsl:value-of select="translate(@ref, '_#', ' ')"/>
				</xsl:when>
				<xsl:when test="contains(@ref, '_')">
					<xsl:value-of select="translate(@ref, '_', ' ')"/>
				</xsl:when>
				<xsl:when test="contains(@ref, '#')">
					<xsl:value-of select="translate(@ref, '#', '')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
			<ul>
				<xsl:for-each select="//tei:author[. = current()]">
					<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="."/>
					<li>
						<xsl:apply-templates select="following-sibling::tei:title[1][not(. = preceding::tei:title)]" mode="Register"/>
						<xsl:if test="($publishSingleFiles = 'no')">
							<xsl:text> </xsl:text>
							<a>
								<xsl:attribute name="style">font-weight:bold</xsl:attribute>
								<xsl:attribute name="href" select="concat('#',ancestor::tei:TEI/@xml:id)"/>
								<xsl:choose>
									<xsl:when test="not($ignoreInIdno = '') and contains(ancestor::tei:msDesc/tei:msIdentifier/tei:idno,$ignoreInIdno)">
										<xsl:value-of select="substring-after(ancestor::tei:msDesc/tei:msIdentifier/tei:idno,$ignoreInIdno)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="ancestor::tei:msDesc/tei:msIdentifier/tei:idno"/>
									</xsl:otherwise>
								</xsl:choose>
							</a>
						</xsl:if>
						<xsl:choose>
							<xsl:when test="preceding-sibling::tei:locus">
								<xsl:text> </xsl:text>
								<xsl:apply-templates select="preceding-sibling::tei:locus[1]" mode="Register"/>
							</xsl:when>
							<xsl:when test="ancestor::tei:msItem/tei:locus">
								<xsl:text> </xsl:text>
								<xsl:apply-templates select="ancestor::tei:msItem[tei:locus][1]/tei:locus[1]" mode="Register"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text> </xsl:text>
								<xsl:apply-templates select="parent::tei:msItem/preceding-sibling::tei:msItem[tei:locus][1]/tei:locus[1]"/>
							</xsl:otherwise>
						</xsl:choose>
					</li>
				</xsl:for-each>
			</ul>
		</li>
	</xsl:if>
</xsl:template>
	<xsl:template match="tei:binding">
		<xsl:if test="not(normalize-space(.) = '')">
			<p>
				<xsl:attribute name="class">physDesc</xsl:attribute>
				
					<span class="head"><xsl:text>Binding: </xsl:text></span>
				
				<xsl:apply-templates/>
			</p>
		</xsl:if>
	</xsl:template>

<xsl:template match="tei:bibl[not(normalize-space(.)='')]">
	<xsl:choose>
		<xsl:when test=" ($showAllElements = 'yes') and (not(@rend='onlineOnly'))">
			<xsl:choose>
				<xsl:when test="@xml:id">
					<a>
						<xsl:attribute name="name"><xsl:value-of select="@xml:id"/></xsl:attribute>
						<xsl:choose>
							<xsl:when test="contains(@xml:id,'gbv')">
								<xsl:attribute name="href"><xsl:value-of select="concat($gbv,substring-after(@xml:id,'gbv_'))"/></xsl:attribute>
							</xsl:when>
						</xsl:choose>
						<xsl:apply-templates/>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="ancestor::tei:additional and parent::tei:listBibl and following-sibling::tei:bibl[not(normalize-space(.)='')] and 
							not(substring(.,string-length(.)-1)=';') and not(substring(.,string-length(.)-1)='.')">
					<xsl:value-of select="$Trennzeichen"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="Leerzeichen"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:cell[not(normalize-space(.)='')]">
	<xsl:choose>
		<xsl:when test="(@role='label')">
			<th>
				<xsl:attribute name="nowrap">nowrap</xsl:attribute>
				<xsl:apply-templates/>
			</th>
		</xsl:when>
		<xsl:otherwise>
			<td>
				<xsl:if test="contains(@rend,'nowrap')"><xsl:attribute name="nowrap">nowrap</xsl:attribute></xsl:if>
				<xsl:apply-templates/>
			</td>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:choice">
	<xsl:apply-templates select="tei:orig | tei:sic"/>
	<span>
		<xsl:attribute name="class">normal</xsl:attribute>
		<xsl:text>[=</xsl:text>
		<xsl:apply-templates select="tei:reg | tei:corr"/>
		<xsl:text>]</xsl:text>
	</span>
</xsl:template>

<xsl:template match="tei:collation[not(normalize-space(.)='')]">	
	<xsl:apply-templates/>
	<xsl:call-template name="Leerzeichen"/>
</xsl:template>

<xsl:template match="tei:collection" mode="Schlagzeile"/>

<xsl:template match="tei:colophon[not(normalize-space(.)='')]">
	<span>
		<xsl:attribute name="class">colophon</xsl:attribute>
		<xsl:apply-templates/>
	</span>
	<xsl:call-template name="Satzzeichen"/>
</xsl:template>

<xsl:template match="tei:date[not(normalize-space(.)='')]">
	<xsl:apply-templates/>
	<xsl:if test="(parent::tei:rubric or parent::tei:incipit or parent::tei:quote or parent::tei:explicit or parent::tei:colophon or parent::tei:finalRubric) and not(contains(.,@when))">
		<span>
			<xsl:attribute name="class">normal</xsl:attribute>
			<xsl:text> [</xsl:text>
			<xsl:call-template name="Datum-ausgeben">
				<xsl:with-param name="date" select="@when"/>
			</xsl:call-template>
			<xsl:text>]</xsl:text>
		</span>
	</xsl:if>
	<xsl:call-template name="Leerzeichen"/>
</xsl:template>

<xsl:template match="tei:dimensions[not(normalize-space(.)='')][(@type = 'leaf')]" mode="Schlagzeile">
	<xsl:apply-templates/>
	<xsl:choose>
		<xsl:when test="@unit and not(tei:height/@unit) and not(tei:width/@unit) and not(tei:depth/@unit)">
			<xsl:value-of select="concat(' ',@unit)"/>
		</xsl:when>
		<xsl:when test="tei:height/@unit or tei:width/@unit"/>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:dimensions[not(normalize-space(.)='')]" mode="#default condensed">
	<xsl:if test="(@type='written') and not(contains(preceding-sibling::text()[1], 'Written space'))">
		<xsl:text>Written space: </xsl:text>
	</xsl:if>
	<xsl:choose>
		<xsl:when test="ancestor::tei:accMat or ancestor::tei:msPart[@rend = 'condensed']">
			<xsl:apply-templates mode="#current"/>
			<xsl:choose>
				<xsl:when test="tei:height/@unit or tei:width/@unit or tei:depth/@unit"/>
				<xsl:when test="@unit">
					<xsl:value-of select="concat(' ', @unit)"/>
				</xsl:when>
			</xsl:choose>
		</xsl:when>
		<xsl:when test="(@type = 'leaf') and ancestor::tei:physDesc[parent::tei:msDesc]"/>
		<xsl:otherwise>
			<xsl:apply-templates mode="#current"/>
			<xsl:choose>
				<xsl:when test="tei:height/@unit or tei:width/@unit or tei:depth/@unit"/>
				<xsl:when test="@unit">
					<xsl:value-of select="concat(' ', @unit)"/>
				</xsl:when>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose>
<xsl:call-template name="Satzzeichen"/>
</xsl:template>

<xsl:template match="tei:height[not(normalize-space(.)='')]" mode="#default condensed">
	<xsl:value-of select="."/>
	<xsl:if test="@unit and not(../tei:width/@unit) and not(../tei:depth/@unit)">
		<xsl:text> </xsl:text>
		<xsl:value-of select="@unit"/>
	</xsl:if>
	<xsl:if test="../tei:width or ../tei:depth">
		<xsl:text> &#x00D7; </xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="tei:width[not(normalize-space(.)='')]" mode="#default condensed">
	<xsl:value-of select="."/>
	<xsl:if test="@unit and not(../tei:depth/@unit)">
		<xsl:text> </xsl:text>
		<xsl:value-of select="@unit"/>
	</xsl:if>
	<xsl:if test="../tei:depth">
		<xsl:text> &#x00D7; </xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="tei:depth[not(normalize-space(.)='')]" mode="#default condensed">
	<xsl:value-of select="."/>
	<xsl:if test="@unit">
		<xsl:text> </xsl:text>
		<xsl:value-of select="@unit"/>
	</xsl:if>
</xsl:template>

<xsl:template match="tei:edition[not(normalize-space(.)='')]">
	<sup>
		<xsl:apply-templates/>
	</sup>
	<xsl:if test="not(parent::tei:bibl)">
		<xsl:call-template name="Leerzeichen"/>
	</xsl:if>
</xsl:template>

<xsl:template match="tei:explicit[not(normalize-space(.)='')]">
	<xsl:choose>
		<xsl:when test="starts-with(., tei:locus) and (preceding-sibling::tei:incipit or contains(@rend, 'dottedBegin'))">
			<xsl:apply-templates select="node()[1][self::tei:locus]"/>
			<xsl:text> &#x2026; </xsl:text>
		</xsl:when>
		<xsl:when test="preceding-sibling::tei:incipit or contains(@rend, 'dottedBegin')">
			<xsl:text> &#x2026; </xsl:text>
		</xsl:when>
	</xsl:choose>
	<span>
		<xsl:attribute name="class">explicit</xsl:attribute>
		<xsl:apply-templates select="node()[not(position='1')][not(self::tei:locus)]"/>
	</span>
	<xsl:choose>
		<xsl:when test="contains(@rend, 'dottedEnd') or contains(@defective, 'true') or following-sibling::tei:explicit"><xsl:text> &#x2026; </xsl:text></xsl:when>
		<xsl:otherwise><xsl:call-template name="Satzzeichen"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!--<xsl:template match="tei:extent"></xsl:template>-->

<xsl:template match="tei:extent[not(normalize-space(.)='')]" mode="Schlagzeile">
	<xsl:if test="(ancestor::tei:physDesc/preceding-sibling::tei:msIdentifier/tei:altIdentifier[@type='former'][not(@rend='doNotShow')] 
		and not(contains(ancestor::tei:physDesc/preceding-sibling::tei:msIdentifier/tei:idno,concat('olim ',ancestor::tei:physDesc/preceding-sibling::tei:msIdentifier/tei:altIdentifier[@type='former'][not(@rend='doNotShow')][1]/tei:idno))))
		or 
		(ancestor::tei:physDesc/tei:objectDesc/tei:supportDesc/@material 
		or (normalize-space(ancestor::tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support//tei:material) != ''))">
		<xsl:value-of select="$Trennzeichen"/>
	</xsl:if>
	
	<xsl:choose>
		<xsl:when test="descendant::tei:measure[@type = 'leavesCount']">
			<xsl:choose>
				<xsl:when test="not(contains(.,'fols'))">
					<xsl:value-of select="descendant::tei:measure[@type = 'leavesCount']"/><xsl:text> fols.</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="descendant::tei:measure[@type = 'leavesCount']"/>
				</xsl:otherwise>
			</xsl:choose>
			
		</xsl:when>
		<xsl:when test="descendant::tei:measure[@type = 'pagesCount']">
			<xsl:value-of select="descendant::tei:measure[@type = 'pagesCount']"/> <xsl:text> pp.</xsl:text>
		</xsl:when>
	</xsl:choose>
	<xsl:choose>
		<xsl:when test="descendant::tei:measure[@type = 'leavesCount'] 
			and descendant::tei:measure[(@type = 'pageDimensions') or (@type = 'leavesSize')]">
			<xsl:value-of select="$Trennzeichen"/>
			<xsl:value-of select="descendant::tei:measure[(@type = 'pageDimensions') or (@type = 'leavesSize')]"/>
		</xsl:when>
		<xsl:when test="descendant::tei:measure[@type = 'leavesCount'] 
			and descendant::tei:dimensions[(@type = 'leaf')]">
			<xsl:value-of select="$Trennzeichen"/>
			<xsl:apply-templates select="descendant::tei:dimensions[(@type = 'leaf')]" mode="Schlagzeile"/>
		</xsl:when>
		<xsl:when test="descendant::tei:measure[@type = 'pageDimensions']">
			<xsl:apply-templates select="descendant::tei:measure[@type = 'pageDimensions']" mode="Schlagzeile"/>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:gap">
	<xsl:choose>
		<xsl:when test="@reason">
			<span>
				<xsl:attribute name="class">normal</xsl:attribute>
				<xsl:attribute name="title"><xsl:value-of select="@reason"/></xsl:attribute>
				<xsl:text>&#x2026;</xsl:text>
			</span>
		</xsl:when>
		<xsl:otherwise><xsl:text>&#x2026;</xsl:text></xsl:otherwise>
	</xsl:choose>
	<!--xsl:call-template name="Leerzeichen"/-->
</xsl:template>

<xsl:template match="tei:head[not(normalize-space(.)='')]" mode="Schlagzeile">
	<p>
		<xsl:attribute name="class">schlagzeile</xsl:attribute>
		<xsl:choose>
			<xsl:when test="(tei:note[@type = 'caption'] != '')">
				<xsl:value-of select="tei:note[@type = 'caption']"/>
			</xsl:when>
			<xsl:otherwise>
				<!--<xsl:choose>
					<xsl:when test="preceding-sibling::tei:msIdentifier/tei:altIdentifier[@type='former'][not(@rend='doNotShow')][not(contains(preceding-sibling::tei:idno, tei:idno))]">
						<xsl:apply-templates select="preceding-sibling::tei:msIdentifier/tei:altIdentifier[@type='former'][not(@rend='doNotShow')][not(contains(preceding-sibling::tei:idno, tei:idno))]" mode="Schlagzeile"/>
					</xsl:when>
					<xsl:when test="parent::tei:msPart">
						<xsl:apply-templates select="preceding-sibling::tei:altIdentifier[@type='former'][not(@rend='doNotShow')]" mode="Schlagzeile"/>
					</xsl:when>
				</xsl:choose>-->
				<xsl:apply-templates select="following-sibling::tei:physDesc/descendant::tei:supportDesc" mode="Schlagzeile"/>
				<xsl:choose>
					<xsl:when test="(tei:origPlace != '')">
						<xsl:if test="preceding-sibling::tei:msIdentifier/tei:altIdentifier[@type='former'][not(@rend='doNotShow')] 
							and not(contains(preceding-sibling::tei:msIdentifier/tei:idno,concat('olim ',preceding-sibling::tei:msIdentifier/tei:altIdentifier[@type='former'][not(@rend='doNotShow')][1]/tei:idno)))
							or following-sibling::tei:physDesc/descendant::tei:supportDesc">
							<xsl:value-of select="$Trennzeichen"/>
						</xsl:if>
						<xsl:apply-templates select="tei:origPlace" mode="Schlagzeile"/>
					</xsl:when>
					<xsl:when test="(following-sibling::tei:history/tei:origin//tei:origPlace != '')">
						<xsl:if test="preceding-sibling::tei:msIdentifier/tei:altIdentifier[@type='former'][not(@rend='doNotShow')] 
							and not(contains(preceding-sibling::tei:msIdentifier/tei:idno,concat('olim ',preceding-sibling::tei:msIdentifier/tei:altIdentifier[@type='former'][not(@rend='doNotShow')][1]/tei:idno)))
							or following-sibling::tei:physDesc/descendant::tei:supportDesc">
							<xsl:value-of select="$Trennzeichen"/>
						</xsl:if>
						<xsl:apply-templates select="following-sibling::tei:history/tei:origin//tei:origPlace" mode="Schlagzeile"/>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="(tei:origDate != '')">
						<xsl:if test="preceding-sibling::tei:msIdentifier/tei:altIdentifier[@type='former'][not(@rend='doNotShow')] 
							and not(contains(preceding-sibling::tei:msIdentifier/tei:idno,concat('olim ',preceding-sibling::tei:msIdentifier/tei:altIdentifier[@type='former'][not(@rend='doNotShow')][1]/tei:idno)))
							or following-sibling::tei:physDesc/descendant::tei:supportDesc
							or tei:origPlace or following-sibling::tei:history/tei:origin//tei:origPlace">
							<xsl:value-of select="$Trennzeichen"/>
						</xsl:if>
						<xsl:apply-templates select="tei:origDate" mode="Schlagzeile"/>
					</xsl:when>
					<xsl:when test="(following-sibling::tei:history/tei:origin//tei:origDate != '')">
						<xsl:if test="preceding-sibling::tei:msIdentifier/tei:altIdentifier[@type='former'][not(@rend='doNotShow')] 
							and not(contains(preceding-sibling::tei:msIdentifier/tei:idno,concat('olim ',preceding-sibling::tei:msIdentifier/tei:altIdentifier[@type='former'][not(@rend='doNotShow')][1]/tei:idno)))
							or following-sibling::tei:physDesc/descendant::tei:supportDesc
							or tei:origPlace or following-sibling::tei:history/tei:origin//tei:origPlace">
							<xsl:value-of select="$Trennzeichen"/>
						</xsl:if>
						<xsl:apply-templates select="following-sibling::tei:history/tei:origin//tei:origDate" mode="Schlagzeile"/>
					</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</p>
	<xsl:choose>
		<xsl:when test="(tei:note[@type = 'summary'] != '')">
			<p> 
				<xsl:attribute name="class">schlagzeile</xsl:attribute>
				<xsl:apply-templates select="tei:note[@type = 'summary']"/>
			</p>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:hi[not(normalize-space(.)='')]">
	<xsl:choose>
		<xsl:when test="contains( @rend, 'font-weight:' ) 
			or contains( @rend, 'font-variant:' ) 
			or contains( @rend, 'font-size:' )">
			<span>
				<xsl:attribute name="style" select="@rend"/>
				<xsl:apply-templates/>
			</span>
		</xsl:when>
		<xsl:when test="( @rend = 'rubricated' )">
			<span>
				<xsl:attribute name="class">smaller</xsl:attribute>
				<xsl:text>&#x203A;</xsl:text>
			</span>
			<xsl:apply-templates/>
			<span>
				<xsl:attribute name="class">smaller</xsl:attribute>
				<xsl:text>&#x2039;</xsl:text>
			</span>
		</xsl:when>
		<xsl:when test="contains( @rend, 'smallCaps' )">
			<span>
				<xsl:attribute name="style">
					<xsl:text>font-variant:small-caps</xsl:text>
				</xsl:attribute>
				<xsl:apply-templates/>
			</span>
		</xsl:when>
		<xsl:when test="( @rend = 'normal' )">
			<span>
				<xsl:attribute name="style">
					<xsl:text>font-variant:normal</xsl:text>
				</xsl:attribute>
				<xsl:apply-templates/>
			</span>
		</xsl:when>
		<xsl:when test="( @rend = 'sup' )">
			<sup>
				<xsl:apply-templates/>
			</sup>
		</xsl:when>
		<xsl:when test="contains( @rend, 'italic' )">
			<i>
				<xsl:apply-templates/>
			</i>
		</xsl:when>
		<xsl:when test="( @rend = 'bold' )">
			<b>
				<xsl:apply-templates/>
			</b>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:history[not(normalize-space(.)='')]">
	<xsl:if test="not(normalize-space(.) = '')">
		<p>
			<xsl:attribute name="class">history</xsl:attribute>
			<xsl:if test="not(contains(.,'History: '))">
				<span class="head"><xsl:text>History: </xsl:text></span>
			</xsl:if>
			<xsl:apply-templates/>
		</p>
	</xsl:if>
</xsl:template>

<xsl:template match="tei:idno[not(normalize-space(.)='')]" mode="Signatur">
	<p>
		<xsl:attribute name="class">shelfmark</xsl:attribute>
		<a>
			<xsl:attribute name="name" select="ancestor::tei:msDesc/@xml:id"/>
		</a>
		<xsl:if test="preceding-sibling::tei:settlement and not(preceding-sibling::tei:settlement = $ignoreInSettlement)">
			<xsl:value-of select="preceding-sibling::tei:settlement"/>
			<xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:if test="preceding-sibling::tei:institution and not(preceding-sibling::tei:institution = $ignoreInInstitution)">
			<xsl:value-of select="preceding-sibling::tei:institution"/>
			<xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:if test="not(preceding-sibling::tei:repository = $ignoreInRepository)">
			<xsl:value-of select="preceding-sibling::tei:repository"/>
			<xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:if test="preceding-sibling::tei:collection and not(preceding-sibling::tei:collection = $ignoreInCollection)">
			<xsl:value-of select="preceding-sibling::tei:collection"/>
			<xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:apply-templates/>
	</p>
</xsl:template>

<xsl:template match="tei:idno[not(normalize-space(.)='')]" mode="Schlagzeile">
	<xsl:choose>
		<xsl:when test="ancestor::tei:msDesc/@xml:id">
			<a name="{ancestor::tei:msDesc/@xml:id}"/>
		</xsl:when>
		<xsl:when test="ancestor::tei:TEI/@xml:id">
			<a name="{ancestor::tei:TEI/@xml:id}"/>
		</xsl:when>
	</xsl:choose>
	<xsl:if test="preceding-sibling::tei:settlement and not(preceding-sibling::tei:settlement = $ignoreInSettlement)
		or preceding-sibling::tei:institution and not(preceding-sibling::tei:institution = $ignoreInInstitution)
		or preceding-sibling::tei:repository and not(preceding-sibling::tei:repository = $ignoreInRepository)
		or preceding-sibling::tei:collection and not(preceding-sibling::tei:collection = $ignoreInCollection)">
		<xsl:text>, </xsl:text>
	</xsl:if>
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="tei:idno[not(normalize-space(.)='')] | tei:settlement[not(normalize-space(.)='')]">
	<xsl:choose>
		<xsl:when test="ancestor::tei:msPart and not(text() = ancestor::tei:msDesc/tei:msIdentifier[tei:settlement and tei:idno]/text())">
			<xsl:apply-templates/>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:incipit[not(normalize-space(.)='')]">
	<xsl:if test="contains(@defective, 'true')"><xsl:text>&#x2026; </xsl:text></xsl:if>
	<span>
		<xsl:attribute name="class"><xsl:text>incipit</xsl:text></xsl:attribute>
		<xsl:apply-templates/>
	</span>
	<xsl:choose>
		<xsl:when test="tei:gap[not(following-sibling::node())]">
			<xsl:text> </xsl:text>
		</xsl:when>		
		<xsl:when test="following-sibling::tei:explicit or following-sibling::tei:finalRubric">
			<xsl:text> &#x2026; &#x2014; </xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="Satzzeichen"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:incipit[not(normalize-space(.)='')]" mode="Register">
	<li>
		<span>
			<xsl:attribute name="class">
				<xsl:text>incipit</xsl:text>
			</xsl:attribute>
			<xsl:apply-templates/>
		</span>
		<xsl:text> </xsl:text>
		<xsl:if test="($publishSingleFiles = 'no')">
			<xsl:text> </xsl:text>
			<a>
				<xsl:attribute name="style">font-weight:bold</xsl:attribute>
				<xsl:attribute name="href" select="concat('#',ancestor::tei:TEI/@xml:id)"/>
				<xsl:choose>
					<xsl:when test="not($ignoreInIdno = '') and contains(ancestor::tei:msDesc/tei:msIdentifier/tei:idno,$ignoreInIdno)">
						<xsl:value-of select="substring-after(ancestor::tei:msDesc/tei:msIdentifier/tei:idno,$ignoreInIdno)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="ancestor::tei:msDesc/tei:msIdentifier/tei:idno"/>
					</xsl:otherwise>
				</xsl:choose>
			</a>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="preceding-sibling::tei:locus">
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="preceding-sibling::tei:locus[1]" mode="Register"/>
			</xsl:when>
			<xsl:when test="ancestor::tei:msItem/tei:locus">
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="ancestor::tei:msItem[tei:locus][1]/tei:locus[1]" mode="Register"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="parent::tei:msItem/preceding-sibling::tei:msItem[tei:locus][1]/tei:locus[1]"/>
			</xsl:otherwise>
		</xsl:choose>
	</li>
</xsl:template>

<xsl:template match="tei:index[not(normalize-space(.)='')]" mode="Register">
	<li>
		<xsl:text>*</xsl:text>
		<span>
			<xsl:attribute name="class">indexOnly</xsl:attribute>
			<xsl:apply-templates mode="Register"/>
		</span>
	</li>
</xsl:template>

<xsl:template match="tei:item[not(normalize-space(.)='')]">
	<xsl:choose>
		<xsl:when test="ancestor::tei:list[@type = 'bibliography']">
			<li>
				<xsl:apply-templates/>
			</li>
		</xsl:when>
<!--		the following added by ID - more general ?-->
		<xsl:when test="parent::tei:list">
					<li>
						<xsl:apply-templates/>
					</li>
				</xsl:when>
		<xsl:otherwise>			
			<xsl:apply-templates/>
			<xsl:call-template name="Satzzeichen"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:l[not(normalize-space(.)='')]">
	<xsl:apply-templates/>
	<xsl:if test="following-sibling::tei:l">
		<xsl:text> | </xsl:text>
	</xsl:if>
</xsl:template>

	<xsl:template match="tei:layout[not(normalize-space(.)='')]">
	<span class="head"><xsl:text>Layout: </xsl:text></span>
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="tei:lb">
	<xsl:choose>
		<xsl:when test="parent::tei:rubric or parent::tei:incipit or parent::tei:quote or parent::tei:explicit or parent::tei:colophon or parent::tei:finalRubric">
			<xsl:text> | </xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<br/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:list[not(normalize-space(.)='')]">
	<!--<xsl:choose>
		<xsl:when test="ancestor::tei:physDesc or ancestor::tei:msItem">
			<xsl:apply-templates/>
		</xsl:when>
		<xsl:otherwise>
			<ul>
				<xsl:apply-templates/>
			</ul>
		</xsl:otherwise>
	</xsl:choose>-->
	<ul>
		<xsl:apply-templates/>
	</ul>
</xsl:template>
	

<xsl:template match="tei:listBibl[tei:bibl[normalize-space(.)]]">
	<xsl:choose>
		<xsl:when test="parent::tei:additional">
			<xsl:choose>
				<xsl:when test="tei:head">
				<span>
					<xsl:attribute name="class">listBiblHead</xsl:attribute>
					<span class="head"><xsl:value-of select="tei:head"/></span>
					<xsl:if test="not(contains(tei:head,':'))"><xsl:text>: </xsl:text></xsl:if>
				</span>
				</xsl:when>
				<xsl:otherwise>
					<span>
						<xsl:attribute name="class">listBiblHead</xsl:attribute>
						<span class="head">Selected literature: </span>						
					</span>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="*[not(self::tei:head)]"/>			
		</xsl:when>
	</xsl:choose>
	<xsl:call-template name="Leerzeichen"/>
</xsl:template>

<xsl:template match="tei:locus[not(normalize-space(.)='')]">
        <xsl:param name="index"/>
        <xsl:choose>
            <xsl:when test="parent::tei:rubric or parent::tei:incipit or parent::tei:quote or parent::tei:explicit or parent::tei:colophon or parent::tei:finalRubric or ancestor::tei:index">
                <span>
                    <xsl:attribute name="class">normal</xsl:attribute>
                    <xsl:call-template name="constructLocus">
                        <xsl:with-param name="index" select="$index"/>
                    </xsl:call-template>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="constructLocus">
                    <xsl:with-param name="index" select="$index"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="parent::tei:locusGrp and following-sibling::tei:locus">
                <xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:when test="following-sibling::*">
                <xsl:call-template name="Leerzeichen"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

<xsl:template name="constructLocus">
        <xsl:param name="index"/>
        <xsl:if test="(parent::tei:msItem/parent::tei:msItem or (parent::tei:locusGrp/parent::tei:msItem/parent::tei:msItem and not(preceding-sibling::tei:locus)) or parent::tei:item/ancestor::tei:msItem or parent::tei:explicit)    and not(ancestor::tei:index)    and not($index='yes')    and not(contains(., '('))   and not(following-sibling::tei:note[. = 'blank.'])">
            <xsl:text>(</xsl:text>
        </xsl:if>
        <xsl:if test="(parent::tei:msItem/parent::tei:msItem or parent::tei:item/ancestor::tei:msItem)    and not(ancestor::tei:index)    and not($index='yes')    and not(contains(., '('))   and following-sibling::tei:note[. = 'blank.']">
            <xsl:text> — </xsl:text>
        </xsl:if>
        <xsl:if test="not(parent::tei:ref[@type='altMs'])">
            <xsl:choose>
                <xsl:when test="$index='yes'">
                    <xsl:choose>
                        <xsl:when test="@from">
                            <xsl:value-of select="@from"/>
                        </xsl:when>
                        <xsl:when test="starts-with(., 'Fol. ') or starts-with(., 'fol. ')">
                            <xsl:value-of select="substring(., 6)"/>
                        </xsl:when>
                    	<xsl:when test="starts-with(., 'Ff. ') or starts-with(., 'ff. ')">
                    		<xsl:value-of select="substring(., 5)"/>
                    	</xsl:when>
                    	<xsl:when test="starts-with(., 'Ff.') or starts-with(., 'ff.')">
                    		<xsl:value-of select="substring(., 4)"/>
                    	</xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="@from and @to and contains(.,'-')">
                    <xsl:choose>
                        <xsl:when test="contains(.,'Fol. ') or contains(.,'fol. ') or contains(.,'ff. ')or contains(.,'f. ') or                       contains(.,'P. ') or contains(.,'p. ') or contains(.,'Pp. ') or contains(.,'pp. ') or                       contains(.,'S. ') or                       contains(.,'c. ') or contains(.,'cc. ')">
                            <xsl:value-of select="concat(substring-before(.,'. '),'. ')"/>
                            <xsl:call-template name="locus-verlinken">
                                <xsl:with-param name="attribute">
                                    <xsl:value-of select="@from"/>
                                </xsl:with-param>
                                <xsl:with-param name="content">
                                    <xsl:value-of select="substring-after(substring-before(.,'-'),'. ')"/>
                                </xsl:with-param>
                            </xsl:call-template>
                            <xsl:text>-</xsl:text>
                            <xsl:call-template name="locus-verlinken">
                                <xsl:with-param name="attribute">
                                    <xsl:value-of select="@to"/>
                                </xsl:with-param>
                                <xsl:with-param name="content">
                                    <xsl:value-of select="substring-after(.,'-')"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="locus-verlinken">
                                <xsl:with-param name="attribute">
                                    <xsl:value-of select="@from"/>
                                </xsl:with-param>
                                <xsl:with-param name="content">
                                    <xsl:value-of select="substring-before(.,'-')"/>
                                </xsl:with-param>
                            </xsl:call-template>
                            <xsl:text>-</xsl:text>
                            <xsl:call-template name="locus-verlinken">
                                <xsl:with-param name="attribute">
                                    <xsl:value-of select="@to"/>
                                </xsl:with-param>
                                <xsl:with-param name="content">
                                    <xsl:value-of select="substring-after(.,'-')"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="@from and @to and contains(.,'—')">
                    <xsl:choose>
                        <xsl:when test="contains(.,'Fol. ') or contains(.,'fol. ') or contains(.,'ff. ') or contains(.,'f. ')or           contains(.,'P. ') or contains(.,'p. ') or contains(.,'Pp. ') or contains(.,'pp. ') or           contains(.,'S. ') or           contains(.,'c. ') or contains(.,'cc. ')">
                            <xsl:value-of select="concat(substring-before(.,'. '),'. ')"/>
                            <xsl:call-template name="locus-verlinken">
                                <xsl:with-param name="attribute">
                                    <xsl:value-of select="@from"/>
                                </xsl:with-param>
                                <xsl:with-param name="content">
                                    <xsl:value-of select="substring-after(substring-before(.,'—'),'. ')"/>
                                </xsl:with-param>
                            </xsl:call-template>
                            <xsl:text>—</xsl:text>
                            <xsl:call-template name="locus-verlinken">
                                <xsl:with-param name="attribute">
                                    <xsl:value-of select="@to"/>
                                </xsl:with-param>
                                <xsl:with-param name="content">
                                    <xsl:value-of select="substring-after(.,'—')"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="locus-verlinken">
                                <xsl:with-param name="attribute">
                                    <xsl:value-of select="@from"/>
                                </xsl:with-param>
                                <xsl:with-param name="content">
                                    <xsl:value-of select="substring-before(.,'—')"/>
                                </xsl:with-param>
                            </xsl:call-template>
                            <xsl:text>—</xsl:text>
                            <xsl:call-template name="locus-verlinken">
                                <xsl:with-param name="attribute">
                                    <xsl:value-of select="@to"/>
                                </xsl:with-param>
                                <xsl:with-param name="content">
                                    <xsl:value-of select="substring-after(.,'—')"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="@from and @to and contains(.,'–')">
                    <xsl:choose>
                        <xsl:when test="contains(.,'Fol. ') or contains(.,'fol. ') or contains(.,'ff. ') or contains(.,'f. ')or           contains(.,'P. ') or contains(.,'p. ') or contains(.,'Pp. ') or contains(.,'pp. ') or           contains(.,'S. ') or           contains(.,'c. ') or contains(.,'cc. ')">
                            <xsl:value-of select="concat(substring-before(.,'. '),'. ')"/>
                            <xsl:call-template name="locus-verlinken">
                                <xsl:with-param name="attribute">
                                    <xsl:value-of select="@from"/>
                                </xsl:with-param>
                                <xsl:with-param name="content">
                                    <xsl:value-of select="substring-after(substring-before(.,'–'),'. ')"/>
                                </xsl:with-param>
                            </xsl:call-template>
                            <xsl:text>–</xsl:text>
                            <xsl:call-template name="locus-verlinken">
                                <xsl:with-param name="attribute">
                                    <xsl:value-of select="@to"/>
                                </xsl:with-param>
                                <xsl:with-param name="content">
                                    <xsl:value-of select="substring-after(.,'–')"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="locus-verlinken">
                                <xsl:with-param name="attribute">
                                    <xsl:value-of select="@from"/>
                                </xsl:with-param>
                                <xsl:with-param name="content">
                                    <xsl:value-of select="substring-before(.,'–')"/>
                                </xsl:with-param>
                            </xsl:call-template>
                            <xsl:text>–</xsl:text>
                            <xsl:call-template name="locus-verlinken">
                                <xsl:with-param name="attribute">
                                    <xsl:value-of select="@to"/>
                                </xsl:with-param>
                                <xsl:with-param name="content">
                                    <xsl:value-of select="substring-after(.,'–')"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="@from and @to and contains(.,'/')">
                    <xsl:choose>
                        <xsl:when test="contains(.,'Fol. ') or contains(.,'fol. ') or contains(.,'ff. ') or contains(.,'f. ')or                       contains(.,'P. ') or contains(.,'p. ') or contains(.,'Pp. ') or contains(.,'pp. ') or                       contains(.,'S. ') or                       contains(.,'c. ') or contains(.,'cc. ')">
                            <xsl:value-of select="concat(substring-before(.,'. '),'. ')"/>
                            <xsl:call-template name="locus-verlinken">
                                <xsl:with-param name="attribute">
                                    <xsl:value-of select="@from"/>
                                </xsl:with-param>
                                <xsl:with-param name="content">
                                    <xsl:value-of select="substring-after(substring-before(.,'/'),'. ')"/>
                                </xsl:with-param>
                            </xsl:call-template>
                            <xsl:text>/</xsl:text>
                            <xsl:call-template name="locus-verlinken">
                                <xsl:with-param name="attribute">
                                    <xsl:value-of select="@to"/>
                                </xsl:with-param>
                                <xsl:with-param name="content">
                                    <xsl:value-of select="substring-after(.,'/')"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="locus-verlinken">
                                <xsl:with-param name="attribute">
                                    <xsl:value-of select="@from"/>
                                </xsl:with-param>
                                <xsl:with-param name="content">
                                    <xsl:value-of select="substring-before(.,'/')"/>
                                </xsl:with-param>
                            </xsl:call-template>
                            <xsl:text>/</xsl:text>
                            <xsl:call-template name="locus-verlinken">
                                <xsl:with-param name="attribute">
                                    <xsl:value-of select="@to"/>
                                </xsl:with-param>
                                <xsl:with-param name="content">
                                    <xsl:value-of select="substring-after(.,'/')"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="@from">
                    <xsl:choose>
                        <xsl:when test="contains(.,'Foll. ') or contains(.,'Fol. ') or contains(.,'fol. ') or contains(.,'ff. ') or contains(.,'f. ') or                       contains(.,'P. ') or contains(.,'p. ') or contains(.,'Pp. ') or contains(.,'pp. ') or                       contains(.,'S. ') or                       contains(.,'c. ') or contains(.,'cc. ')">
                            <xsl:value-of select="concat(substring-before(.,'. '),'. ')"/>
                            <xsl:call-template name="locus-verlinken">
                                <xsl:with-param name="attribute">
                                    <xsl:value-of select="@from"/>
                                </xsl:with-param>
                                <xsl:with-param name="content">
                                    <xsl:value-of select="substring-after(.,'. ')"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="locus-verlinken">
                                <xsl:with-param name="attribute">
                                    <xsl:value-of select="@from"/>
                                </xsl:with-param>
                                <xsl:with-param name="content">
                                    <xsl:value-of select="."/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="@target and not(contains(@target,' '))">
                    <xsl:choose>
                        <xsl:when test="contains(.,'Foll. ') or contains(.,'Fol. ') or contains(.,'fol. ') or contains(.,'ff. ') or contains(.,'f. ') or                       contains(.,'P. ') or contains(.,'p. ') or contains(.,'Pp. ') or contains(.,'pp. ') or                       contains(.,'S. ') or                       contains(.,'c. ') or contains(.,'cc. ')">
                            <xsl:value-of select="concat(substring-before(.,'. '),'. ')"/>
                            <xsl:call-template name="locus-verlinken">
                                <xsl:with-param name="attribute">
                                    <xsl:value-of select="@target"/>
                                </xsl:with-param>
                                <xsl:with-param name="content">
                                    <xsl:value-of select="substring-after(.,'. ')"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="locus-verlinken">
                                <xsl:with-param name="attribute">
                                    <xsl:value-of select="@target"/>
                                </xsl:with-param>
                                <xsl:with-param name="content">
                                    <xsl:value-of select="."/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="contains(.,'-')">
                    <xsl:choose>
                        <xsl:when test="contains(.,'Fol. ') or contains(.,'fol. ') or contains(.,'ff. ') or contains(.,'f. ')or           contains(.,'P. ') or contains(.,'p. ') or contains(.,'Pp. ') or contains(.,'pp. ') or           contains(.,'S. ') or           contains(.,'c. ') or contains(.,'cc. ')">
                            <xsl:value-of select="concat(substring-before(.,'. '),'. ')"/>
                            <xsl:call-template name="locus-verlinken">
                                <xsl:with-param name="attribute">
                                    <xsl:value-of select="substring-before(.,'-')"/>
                                </xsl:with-param>
                                <xsl:with-param name="content">
                                    <xsl:value-of select="substring-after(substring-before(.,'-'),'. ')"/>
                                </xsl:with-param>
                            </xsl:call-template>
                            <xsl:text>-</xsl:text>
                            <xsl:call-template name="locus-verlinken">
                                <xsl:with-param name="attribute">
                                    <xsl:value-of select="substring-after(.,'-')"/>
                                </xsl:with-param>
                                <xsl:with-param name="content">
                                    <xsl:value-of select="substring-after(.,'-')"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="locus-verlinken">
                                <xsl:with-param name="attribute">
                                    <xsl:value-of select="substring-before(.,'-')"/>
                                </xsl:with-param>
                                <xsl:with-param name="content">
                                    <xsl:value-of select="substring-before(.,'-')"/>
                                </xsl:with-param>
                            </xsl:call-template>
                            <xsl:text>-</xsl:text>
                            <xsl:call-template name="locus-verlinken">
                                <xsl:with-param name="attribute">
                                    <xsl:value-of select="substring-after(.,'-')"/>
                                </xsl:with-param>
                                <xsl:with-param name="content">
                                    <xsl:value-of select="substring-after(.,'-')"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="contains(.,'/')">
                    <xsl:choose>
                        <xsl:when test="contains(.,'Fol. ') or contains(.,'fol. ') or contains(.,'ff. ') or contains(.,'f. ')or           contains(.,'P. ') or contains(.,'p. ') or contains(.,'Pp. ') or contains(.,'pp. ') or           contains(.,'S. ') or           contains(.,'c. ') or contains(.,'cc. ')">
                            <xsl:value-of select="concat(substring-before(.,'. '),'. ')"/>
                            <xsl:call-template name="locus-verlinken">
                                <xsl:with-param name="attribute">
                                    <xsl:value-of select="substring-before(.,'/')"/>
                                </xsl:with-param>
                                <xsl:with-param name="content">
                                    <xsl:value-of select="substring-after(substring-before(.,'/'),'. ')"/>
                                </xsl:with-param>
                            </xsl:call-template>
                            <xsl:text>/</xsl:text>
                            <xsl:call-template name="locus-verlinken">
                                <xsl:with-param name="attribute">
                                    <xsl:value-of select="substring-after(.,'/')"/>
                                </xsl:with-param>
                                <xsl:with-param name="content">
                                    <xsl:value-of select="substring-after(.,'/')"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="locus-verlinken">
                                <xsl:with-param name="attribute">
                                    <xsl:value-of select="substring-before(.,'/')"/>
                                </xsl:with-param>
                                <xsl:with-param name="content">
                                    <xsl:value-of select="substring-before(.,'/')"/>
                                </xsl:with-param>
                            </xsl:call-template>
                            <xsl:text>/</xsl:text>
                            <xsl:call-template name="locus-verlinken">
                                <xsl:with-param name="attribute">
                                    <xsl:value-of select="substring-after(.,'/')"/>
                                </xsl:with-param>
                                <xsl:with-param name="content">
                                    <xsl:value-of select="substring-after(.,'/')"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="locus-verlinken">
                        <xsl:with-param name="content">
                            <xsl:value-of select="."/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="parent::tei:ref[@type='altMs']">
            <xsl:value-of select="."/>
        </xsl:if>
        <xsl:if test="(parent::tei:msItem/parent::tei:msItem or (parent::tei:locusGrp/parent::tei:msItem/parent::tei:msItem and not(following-sibling::tei:locus)) or parent::tei:item/ancestor::tei:msItem or parent::tei:explicit)    and not(ancestor::tei:index)    and not($index='yes')    and not(contains(., '('))   and not(following-sibling::tei:note[. = 'leer.'])">
            <xsl:text>) </xsl:text>
        </xsl:if>
    </xsl:template>
<xsl:template match="tei:material[not(normalize-space(.)='')]" mode="Schlagzeile">
<!--	<xsl:if test="ancestor::tei:physDesc/preceding-sibling::tei:msIdentifier/tei:altIdentifier[@type='former'][not(@rend='doNotShow')] 
		and not(contains(ancestor::tei:physDesc/preceding-sibling::tei:msIdentifier/tei:idno,concat('olim ',ancestor::tei:physDesc/preceding-sibling::tei:msIdentifier/tei:altIdentifier[@type='former'][not(@rend='doNotShow')]/tei:idno)))">
		<xsl:value-of select="$Trennzeichen"/>
	</xsl:if>-->
	<xsl:if test="preceding-sibling::tei:material">
		<xsl:apply-templates select="preceding-sibling::tei:locus[position() = 1]"/>
		<xsl:call-template name="Leerzeichen"/>
	</xsl:if>
	<xsl:choose>
		<xsl:when test="following-sibling::tei:material">
			<xsl:value-of select="."/>
			<xsl:text>, </xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="."/>
<!--		    <xsl:value-of select="$Trennzeichen"/>-->
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:measure[not(normalize-space(.)='')]">
	<xsl:choose>
		<xsl:when test="(@type='written')">
			<xsl:choose>
				<xsl:when test="not(starts-with(.,'Written space'))">
					<xsl:text>Written space: </xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:when>
	</xsl:choose>
	<xsl:choose>
		<xsl:when test="(@type='pageDimensions') and parent::tei:accMat"><xsl:apply-templates/></xsl:when>
		<xsl:when test="(@type='pageDimensions')"/>
		<xsl:when test="contains(.,'cm') or contains(.,'mm')">
			<xsl:apply-templates/>
		</xsl:when>
		<xsl:when test="not(contains(.,'cm') or contains(.,'mm')) and @unit">
			<xsl:apply-templates/>
			<xsl:value-of select="concat(' ',@unit)"/>
		</xsl:when>
		
	</xsl:choose>
	<xsl:call-template name="Satzzeichen"/>
</xsl:template>

<xsl:template match="tei:msDesc">
	<xsl:param name="xmlid"><xsl:value-of select="replace(replace(replace(replace(replace(replace(replace(translate(translate(lower-case(tei:msIdentifier/tei:idno),'.',''),' ','-'),'fol','2f'),'4to','4f'),'8vo','8f'),'12mo','12f'),'&#x03B1;','alpha'),'&#x03B2;','beta'),'&#x2014;','--')"/></xsl:param>
	<!--<xsl:if test="preceding::tei:msDesc">
		<hr style="margin-top:15px;margin-bottom:15px"/>
	</xsl:if>-->
	<!--<xsl:apply-templates select="tei:msIdentifier/tei:idno" mode="Signatur"/>-->
	<!--<xsl:if test="not($Status='draft') and ($showAuthorname='yes')">
		<xsl:call-template name="source"/>
	</xsl:if>-->
	<xsl:call-template name="Ueberschrift"/>
	<xsl:apply-templates select="tei:head[1]" mode="Schlagzeile"/>
	<xsl:call-template name="Hauptverteiler"/>
</xsl:template>
<xsl:template match="tei:msDesc" mode="Einzeldatei">
	<xsl:result-document href="{concat($pathFromHere,translate(ancestor-or-self::tei:TEI/@xml:id,'_','/'),'/tei-msDesc.html')}">
		<xsl:call-template name="DateiAusgeben">
			<xsl:with-param name="start">msDesc</xsl:with-param>
		</xsl:call-template>
	</xsl:result-document>
</xsl:template>

<xsl:template match="tei:msItem">
	<xsl:choose>
		<xsl:when test="parent::tei:msContents and not(ancestor::tei:msPart[@rend='condensed'])">
			<p>
				<xsl:attribute name="class">msitem</xsl:attribute>
				<xsl:apply-templates/>
				<xsl:call-template name="Satzzeichen"/>
			</p>
		</xsl:when>
		<xsl:when test="(parent::tei:msItem[parent::tei:msContents] 
			and descendant::tei:msItem 
			and (number(substring-before(tei:locus[1]/@from, 'r') or substring-before(tei:locus[1]/@from, 'v')) gt number(substring-before(parent::*/tei:locus[1]/@from, 'r') or substring-before(parent::*/tei:locus[1]/@from, 'v'))))
			or (contains(@rend, 'break'))">
			<br/>
			<xsl:apply-templates/>
			<xsl:call-template name="Satzzeichen"/>
		</xsl:when>
		<xsl:when test="parent::tei:msItem[parent::tei:msContents]">
			<!--and descendant::tei:msItem[tei:note[.='leer.']] 
			and (number(substring-before(tei:locus[1]/@from, 'r') or substring-before(tei:locus[1]/@from, 'v')) le number(substring-before(parent::*/tei:locus[1]/@from, 'r') or substring-before(parent::*/tei:locus[1]/@from, 'v')))-->
			<ul>
				
					<li>
						<xsl:apply-templates/>
						<xsl:call-template name="Satzzeichen"/>
					</li>
				
			</ul>
			<!--<xsl:text> &#x2013; </xsl:text>
			<xsl:apply-templates/>
			<xsl:call-template name="Satzzeichen"/>-->
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates/>
			<xsl:call-template name="Satzzeichen"/>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:choose>
		<xsl:when test="contains(@rend,'after:content')">
			<xsl:value-of select="concat(' ',substring-before(substring-after(@rend,'after:content('),')'))"/>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:msName[not(normalize-space(.)='')]">
	<xsl:if test="preceding-sibling::tei:msName"><xsl:value-of select="$Trennzeichen"/></xsl:if>
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="tei:msPart[not(@rend = 'condensed')]">
	<xsl:apply-templates select="tei:msIdentifier | tei:altIdentifier" mode="msPart"/>
	<xsl:if test="($showMsPartTitles = 'yes')"><xsl:call-template name="Ueberschrift"/></xsl:if>
	<xsl:apply-templates select="tei:head" mode="Schlagzeile"/>
	<xsl:call-template name="Hauptverteiler"/>
</xsl:template>

<xsl:template match="tei:name" mode="meta">
	<xsl:if test="preceding-sibling::*[1][self::tei:name]">, </xsl:if>
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="tei:note[not(normalize-space(.)='')]">
	<xsl:if test="@rend='supplied'"><xsl:text>[</xsl:text></xsl:if>
	<xsl:choose>
		<xsl:when test="parent::tei:rubric or parent::tei:incipit or parent::tei:quote or parent::tei:explicit or parent::tei:colophon or parent::tei:finalRubric">
			<span>
				<xsl:attribute name="class">normal</xsl:attribute>
				<xsl:text> (</xsl:text>
				<xsl:apply-templates/>
				<xsl:text>)</xsl:text>
			</span>
		</xsl:when>
		<xsl:when test="parent::tei:title">
			<span>
				<xsl:attribute name="class">normal</xsl:attribute>
				<xsl:apply-templates/>
			</span>
		</xsl:when>
		<xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
	</xsl:choose>
	<xsl:choose>
		<xsl:when test="@rend='supplied'"><xsl:text>] </xsl:text></xsl:when>
		<xsl:otherwise><xsl:call-template name="Satzzeichen"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:origin[not(normalize-space(.)='')] | tei:acquisition[not(normalize-space(.)='')]">
	<xsl:if test="(preceding-sibling::tei:origin[not(normalize-space(.) = '')] or preceding-sibling::tei:provenance[not(. = '')]) 
		and not(normalize-space(.) = '')">
		<xsl:value-of select="$Trennzeichen"/>
	</xsl:if>
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="tei:provenance[not(normalize-space(.)='')]">
	<xsl:choose>
		<xsl:when test="(preceding-sibling::tei:origin[not(normalize-space(.) = '')] and not(preceding-sibling::tei:provenance[not(. = '')])) 
			and not(normalize-space(.) = '')">
			<xsl:value-of select="$Trennzeichen"/>
		</xsl:when>
		<xsl:when test="preceding-sibling::tei:provenance[not(. = '')]">
			<xsl:text> </xsl:text>
		</xsl:when>
	</xsl:choose>
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="tei:org" mode="Register">
	<xsl:choose>
		<xsl:when test="tei:label"><xsl:value-of select="tei:label"/></xsl:when>
		<xsl:when test="tei:orgName"><xsl:value-of select="tei:orgName"/></xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:origDate[not(normalize-space(.)='')]" mode="Schlagzeile">
	<!-- Entstehungszeit -->
	<xsl:if test="preceding-sibling::tei:origDate">
		<xsl:text> / </xsl:text>
	</xsl:if>
	<xsl:choose>
		<xsl:when test="parent::tei:head">
			<xsl:value-of select="."/>
		</xsl:when>
		<xsl:when test="ancestor::tei:origin">
			<xsl:choose>
				<xsl:when test="not(ancestor::tei:msPart)">
					<xsl:if test="not(preceding-sibling::tei:origDate)">
						<xsl:value-of select="$Trennzeichen"/>
					</xsl:if>
					<xsl:value-of select="."/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="not(preceding::tei:msPart) and not(preceding-sibling::tei:origDate)">
						<xsl:value-of select="$Trennzeichen"/>
					</xsl:if>
					<xsl:value-of select="ancestor::tei:msPart/tei:altIdentifier/tei:idno"/>
					<xsl:text>: </xsl:text>
					<xsl:value-of select="."/>
					<xsl:if test="following::tei:msPart/descendant::tei:origDate">
						<xsl:text> / </xsl:text>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:origPlace[not(normalize-space(.)='')]" mode="Schlagzeile">
	<!-- Entstehungsort -->
	<xsl:if test="preceding-sibling::tei:origPlace">
		<xsl:text> / </xsl:text>
	</xsl:if>
	<xsl:choose>
		<xsl:when test="parent::tei:head">
			<xsl:value-of select="."/>
		</xsl:when>
		<xsl:when test="ancestor::tei:origin">
			<xsl:choose>
				<xsl:when test="not(ancestor::tei:msPart)">
					<xsl:if test="not(preceding-sibling::tei:origPlace)">
						<xsl:value-of select="$Trennzeichen"/>
					</xsl:if>
					<xsl:value-of select="."/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="not(preceding::tei:msPart) and not(preceding-sibling::tei:origPlace)">
						<xsl:value-of select="$Trennzeichen"/>
					</xsl:if>
					<xsl:value-of select="ancestor::tei:msPart/tei:altIdentifier/tei:idno"/>
					<xsl:text>: </xsl:text>
					<xsl:value-of select="."/>
					<xsl:if test="following::tei:msPart/descendant::tei:origPlace">
						<xsl:text> / </xsl:text>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:p[not(normalize-space(.)='')]">
	<xsl:choose>
		<xsl:when test="(normalize-space(.) = 'Papier')
			or (normalize-space(.) = 'Pergament')
			or (normalize-space(.) = 'Pergament und Papier')
			or (normalize-space(.) = 'Papier und Pergament')"/>
		<xsl:otherwise>
			<xsl:if test="@xml:id and preceding-sibling::tei:p">
				<br/>
			</xsl:if>
			<xsl:if test="@xml:id">
				<a>
					<xsl:attribute name="name">
						<xsl:value-of select="@xml:id"/>
					</xsl:attribute>
				</a>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="(tei:origPlace or tei:origDate) and not(text())"/>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="Leerzeichen"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:persName" mode="Register">
	
	<xsl:if test="ancestor::tei:msItem or not(preceding::tei:persName[. = current()])">
		<li>
			<xsl:apply-templates mode="Register"/>
			<xsl:text> </xsl:text>
			<a>
				<xsl:attribute name="style">font-weight:bold</xsl:attribute>
				<xsl:attribute name="href" select="concat('#',ancestor::tei:TEI/@xml:id)"/>
				<xsl:choose>
					<xsl:when test="not($ignoreInIdno = '') and contains(ancestor::tei:msDesc/tei:msIdentifier/tei:idno,$ignoreInIdno)">
						<xsl:value-of select="substring-after(ancestor::tei:msDesc/tei:msIdentifier/tei:idno,$ignoreInIdno)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="ancestor::tei:msDesc/tei:msIdentifier/tei:idno"/>
					</xsl:otherwise>
				</xsl:choose>
			</a>
			<xsl:if test="ancestor::tei:msItem">
				<xsl:choose>
					<xsl:when test="preceding-sibling::tei:locus">
						<xsl:text> </xsl:text>
						<xsl:apply-templates select="preceding-sibling::tei:locus[1]" mode="Register"/>
					</xsl:when>
					<xsl:when test="ancestor::tei:msItem/tei:locus">
						<xsl:text> </xsl:text>
						<xsl:apply-templates select="ancestor::tei:msItem[tei:locus][1]/tei:locus[1]" mode="Register"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text> </xsl:text>
						<xsl:apply-templates select="parent::tei:msItem/preceding-sibling::tei:msItem[tei:locus][1]/tei:locus[1]"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</li>
	</xsl:if>
</xsl:template>
	
	<xsl:template match="tei:handDesc">	
		<xsl:if test="not(normalize-space(.) = '')">
				<p class="physDesc">
					<span class="head"><xsl:text>Hands: </xsl:text></span>
				<xsl:apply-templates/>	
				</p>			
						
		</xsl:if>
	</xsl:template>
	<xsl:template match="tei:scriptDesc">	
		<xsl:if test="not(normalize-space(.) = '')">
			<p>
				<xsl:attribute name="class">physDesc</xsl:attribute>
				<xsl:if test="not(contains(.,'Script: '))">
					<span class="head"><xsl:text>Script: </xsl:text></span>
				</xsl:if>
				<xsl:apply-templates/>				
			</p>			
		</xsl:if>
	</xsl:template>
	
	
<xsl:template match="tei:physDesc">
	<p>
		<xsl:attribute name="class">physDesc</xsl:attribute>
		<xsl:apply-templates select="*[not(self::tei:handDesc) and not(self::tei:scriptDesc) and not(self::tei:layout) and not(self::tei:accMat) and not(self::tei:additions) and not(self::tei:bindingDesc) and not(self::tei:decoDesc)]"/>
		<xsl:apply-templates select="tei:layout"/>
		<xsl:apply-templates select="tei:scriptDesc"/>
		<xsl:apply-templates select="tei:handDesc"/>
		<xsl:apply-templates select="tei:additions"/>
		<xsl:apply-templates select="tei:decoDesc"/>
	</p>
	<xsl:apply-templates select="tei:bindingDesc"/>
	<xsl:apply-templates select="tei:accMat"/>
</xsl:template>

<xsl:template match="tei:quote[not(normalize-space(.)='')]"> <!--| tei:signatures[not(normalize-space(.)='')]-->>
	<xsl:if test="@type = 'rubric' ">
		<span>
			<xsl:attribute name="class">smaller</xsl:attribute>
			<xsl:text>&#x203A;</xsl:text>
		</span>
	</xsl:if>
	<xsl:if test="contains(@rend, 'dottedBegin')">
		<xsl:text>&#x2026; </xsl:text>
	</xsl:if>
	<xsl:choose>
		<xsl:when test="contains(@rend,'before:content')">
			<xsl:value-of select="substring-before(substring-after(@rend,'before:content('),')')"/>
		</xsl:when>
	</xsl:choose>	
	<span>
		<xsl:attribute name="class">quote</xsl:attribute>
		<xsl:apply-templates/>
	</span>
	<xsl:choose>
		<xsl:when test="contains(@rend,'after:content')">
			<xsl:value-of select="substring-before(substring-after(@rend,'after:content('),')')"/>
		</xsl:when>
	</xsl:choose>
	<xsl:if test="@rend = 'dottedEnd' ">
		<xsl:text> &#x2026;</xsl:text>
	</xsl:if>
	<xsl:if test="@type='rubric'">
		<span>
			<xsl:attribute name="class">smaller</xsl:attribute>
			<xsl:text>&#x2039;</xsl:text>
		</span>
	</xsl:if>
	<xsl:choose>
<!--
		<xsl:when test="(@type='rubric') and following-sibling::node()[1][self::tei:quote[@type='incipit']]">
			<xsl:text> … </xsl:text>
		</xsl:when>
-->
		<xsl:when test="(@type='incipit') and following-sibling::node()[1][self::tei:quote[@type='explicit']]">
			<xsl:text> &#x2026; &#x2014; &#x2026; </xsl:text>
		</xsl:when>
		<xsl:when test="tei:gap[not(following-sibling::text())]"><xsl:call-template name="Leerzeichen"/></xsl:when>
	</xsl:choose>
</xsl:template>

	<xsl:template match="tei:ref">
		<xsl:choose>
			<xsl:when test="starts-with(data(@target), 'http')">
				<a>
					<xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
					<xsl:value-of select="."/>
				</a>
			</xsl:when>
			<xsl:when test="starts-with(data(@target), '#desc')">
				<xsl:variable name="desc">
					<xsl:value-of select="replace(tokenize(@target, '/')[last()], '.xml', '.html')"/>
				</xsl:variable>
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="concat($githubPages,(substring-after($desc,'#')))"/>
					</xsl:attribute>
					<xsl:value-of select="."/>
				</a>
			</xsl:when>
			<xsl:when test="starts-with(data(@target), '#text')">
				<xsl:variable name="text">
					<xsl:value-of select="replace(tokenize(@target, '/')[last()], '.xml', '.html')"/>
				</xsl:variable>
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="concat($githubPages,(substring-after($text,'#')))"/>
					</xsl:attribute>
					<xsl:value-of select="."/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
<xsl:template match="tei:ref[not(normalize-space(.)='')] | tei:ptr">
	<xsl:choose>
		<!--<xsl:when test="@target and @type='entity'">
			<a>
				<xsl:attribute name="href">
					<xsl:value-of select="unparsed-entity-uri(@target)"/>
					<xsl:if test="@n">
						<xsl:value-of select="@n"/>
					</xsl:if>
				</xsl:attribute>
				<xsl:apply-templates/>
			</a>
		</xsl:when>-->
		<xsl:when test="@target">
			<a>
				<xsl:attribute name="href">
					<xsl:value-of select="@target"/>
				</xsl:attribute>
				<xsl:apply-templates/>
			</a>
		</xsl:when>
		<xsl:when test="not(@target) and starts-with(., 'http://')">
			<a>
				<xsl:attribute name="href">
					<xsl:choose>
						<xsl:when test="contains(., ' ')">
							<xsl:value-of select="substring-before(., ' ')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="."/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:apply-templates/>
			</a>
		</xsl:when>
		<!--<xsl:when test="@type='urn'">
			<a>
				<xsl:attribute name="href">
					<xsl:value-of select="$urn-resolver"/>
					<xsl:value-of select="."/>
				</xsl:attribute>
				<xsl:apply-templates/>
			</a>
		</xsl:when>-->
		<!--<xsl:when test="@type='biblical' and @cRef">
			<xsl:if test="not(normalize-space(.) = translate(@cRef, '_.', '  '))"><xsl:apply-templates/></xsl:if>
			<xsl:if test="not(self::tei:ptr) and normalize-space(.) = normalize-space(parent::node())">
<!-\-
				<span>
					<xsl:attribute name="class">smaller</xsl:attribute>
					<xsl:text>‹</xsl:text>
				</span>
-\->
				<xsl:call-template name="Satzzeichen"/>
			</xsl:if>
			<a>
				<xsl:attribute name="href">
					<xsl:value-of select="$cRef-biblical-start"/>
					<xsl:choose>
						<xsl:when test="starts-with(@cRef, 'IV_')">
							<xsl:value-of select="replace(translate(translate(translate(@cRef,' ','+'),',',':'),'_',' '), 'IV', '4')"/>
						</xsl:when>
						<xsl:when test="starts-with(@cRef, 'III_')">
							<xsl:value-of select="replace(translate(translate(translate(@cRef,' ','+'),',',':'),'_',' '), 'III', '3')"/>
						</xsl:when>
						<xsl:when test="starts-with(@cRef, 'II_')">
							<xsl:value-of select="replace(translate(translate(translate(@cRef,' ','+'),',',':'),'_',' '), 'II', '2')"/>
						</xsl:when>
						<xsl:when test="starts-with(@cRef, 'I_')">
							<xsl:value-of select="replace(translate(translate(translate(@cRef,' ','+'),',',':'),'_',' '), 'I', '1')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="translate(translate(translate(@cRef,' ','+'),',',':'),'_',' ')"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:value-of select="$cRef-biblical-end"/>
				</xsl:attribute>
				<xsl:choose>
					<xsl:when test="(ancestor::tei:rubric or ancestor::tei:incipit or ancestor::tei:quote or ancestor::tei:explicit or ancestor::tei:colophon or ancestor::tei:finalRubric or ancestor::tei:index or ancestor::tei:title) and not(parent::note)">
						<span>
							<xsl:attribute name="class">normal</xsl:attribute>
							<xsl:call-template name="constructCRef"/>
						</span>
					</xsl:when>
					<xsl:otherwise>
                            <xsl:call-template name="constructCRef"/>
                        </xsl:otherwise>
				</xsl:choose>
				</a>
		</xsl:when>-->
		<!--<xsl:when test="@type='cao' and @cRef">
			<xsl:apply-templates/>
			<xsl:text> [</xsl:text>
			<a>
				<xsl:attribute name="href"><xsl:text>#cao</xsl:text></xsl:attribute>
				<xsl:text>CAO</xsl:text>
			</a>
			<xsl:text> </xsl:text>
			<xsl:value-of select="@cRef"/>
			<xsl:text>]</xsl:text>
			<xsl:call-template name="Satzzeichen"/>
		</xsl:when>-->
		<xsl:when test="(@type = 'biblical') or (@type = 'classical') or (@type = 'medieval') ">
			<xsl:apply-templates/>
			
			<xsl:choose>
				<xsl:when test="(ancestor::tei:rubric or ancestor::tei:incipit or ancestor::tei:quote or ancestor::tei:explicit or ancestor::tei:colophon or ancestor::tei:finalRubric or ancestor::tei:index) and not(parent::note)">
                        <span>
                            <xsl:attribute name="class">normal</xsl:attribute>
                            <xsl:text> [</xsl:text>
                            <xsl:value-of select="translate(translate(@cRef,' ','+'),'_',' ')"/>
                            <xsl:text>]</xsl:text>
                        </span>
                    </xsl:when>
			<xsl:otherwise>
                        <xsl:text> [</xsl:text>
                        <xsl:value-of select="translate(translate(@cRef,' ','+'),'_',' ')"/>
                        <xsl:text>]</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
			</xsl:when>
		<!--<xsl:when test="@type='mss' and @cRef">
			<a>
				<xsl:attribute name="href"><xsl:value-of select="concat($pathFromHere,@cRef,'.html')"/></xsl:attribute>
				<xsl:apply-templates/>
			</a>
		</xsl:when>-->	
		
		
		<!--<xsl:when test="@type='gbv' and @cRef">
			<a>
				<xsl:attribute name="href">
					<xsl:value-of select="concat($gbv, @cRef)"/>
				</xsl:attribute>
				<xsl:apply-templates/>
			</a>
		</xsl:when>-->
		
		<xsl:when test="($listAbbreviatedTitles = 'yes') and parent::tei:bibl and
			((.=//tei:list[@type = 'bibliography'][not(preceding::tei:list[@type = 'bibliography'])]/tei:item/tei:label) or
			(@target=//tei:list[@type = 'bibliography'][not(preceding::tei:list[@type = 'bibliography'])]/tei:item/@xml:id))">
			<a>
				<xsl:attribute name="href">
					<xsl:text>#</xsl:text>
					<xsl:value-of select="translate(//tei:list[@type = 'bibliography'][not(preceding::tei:list[@type = 'bibliography'])]/tei:item[tei:label=current()]/tei:label,' ()','_')"/>
				</xsl:attribute>
				<xsl:apply-templates/>
			</a>
		</xsl:when>
		<!--<xsl:when test="($listAbbreviatedTitles = 'no') and parent::tei:bibl and
			((.=//tei:list[@type = 'bibliography'][not(preceding::tei:list[@type = 'bibliography'])]/tei:item/tei:label) or 
			 (@target=//tei:list[@type = 'bibliography'][not(preceding::tei:list[@type = 'bibliography'])]/tei:item/@xml:id))">
			<a>
				<xsl:attribute name="href">
					
					<xsl:choose>
						<xsl:when test=".=//tei:list[@type = 'bibliography'][not(preceding::tei:list[@type = 'bibliography'])]/tei:item/tei:label">
							<xsl:value-of select="substring-after(//tei:list[@type = 'bibliography'][not(preceding::tei:list[@type = 'bibliography'])]/tei:item[tei:label=current()]/@xml:id,'opac_')"/>
						</xsl:when>
						<xsl:when test="@target=//tei:list[@type = 'bibliography'][not(preceding::tei:list[@type = 'bibliography'])]/tei:item/@xml:id">
							<xsl:value-of select="substring-after(//tei:list[@type = 'bibliography'][not(preceding::tei:list[@type = 'bibliography'])]/tei:item[@xml:id=current()/@target]/@xml:id,'opac_')"/>
						</xsl:when>
					</xsl:choose>
				</xsl:attribute>
				<xsl:apply-templates/>
			</a>
		</xsl:when>-->
		<xsl:otherwise>
			<xsl:apply-templates/>
		</xsl:otherwise>
	</xsl:choose>
	<!--<xsl:if test="parent::tei:bibl and not(@type='purl') and not(@type='mss') and not(@type='altMs')">
		<xsl:text disable-output-escaping="yes"></span></xsl:text>
	</xsl:if>-->
	<xsl:if test="not(tei:hi) and not(parent::tei:bibl)">
		<xsl:call-template name="Leerzeichen"/>
	</xsl:if>
</xsl:template>

<xsl:template name="constructCRef">
        <xsl:if test="ancestor::tei:rubric or ancestor::tei:incipit or ancestor::tei:quote or ancestor::tei:explicit or ancestor::tei:colophon or ancestor::tei:finalRubric or ancestor::tei:index or ancestor::tei:title">
            <xsl:text> [</xsl:text>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="not(normalize-space(.) = translate(@cRef, '_', ' '))">
                <xsl:choose>
                    <xsl:when test="starts-with(@cRef, 'Lao')">
                        <xsl:value-of select="translate(translate(translate(translate(@cRef,'+',' '),':',','),'_',' '), 'Lao', 'Laod')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="translate(translate(translate(@cRef,'+',' '),':',','),'_',' ')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="ancestor::tei:rubric or ancestor::tei:incipit or ancestor::tei:quote or ancestor::tei:explicit or ancestor::tei:colophon or ancestor::tei:finalRubric or ancestor::tei:index or ancestor::tei:title">
            <xsl:text>]</xsl:text>
        </xsl:if>
    </xsl:template>
<xsl:template match="tei:resp" mode="meta">
	<xsl:apply-templates/>
	<xsl:call-template name="Leerzeichen"/>
</xsl:template>

<xsl:template match="tei:row[not(normalize-space(.)='')]">
	<xsl:choose>
		<xsl:when test="(@role='label')">
			<th>
				<!--xsl:attribute name="nowrap">nowrap</xsl:attribute-->
				<xsl:apply-templates/>
			</th>
		</xsl:when>
		<xsl:otherwise>
			<tr>
				<xsl:apply-templates/>
			</tr>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:rs[not(normalize-space(.)='')]">
	<xsl:choose>
		<xsl:when test=" (@type = 'author') ">
			<span>
				<xsl:attribute name="class">author</xsl:attribute>
				<xsl:apply-templates/>
			</span>
			<xsl:call-template name="Leerzeichen"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates/>
			<xsl:call-template name="Leerzeichen"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
	
	

<xsl:template match="tei:rs[not(normalize-space(.)='')][@type = 'person'] | tei:author" mode="Register">
	<xsl:if test="not(preceding::tei:rs[@type = 'person'][. = current()] or preceding::tei:persName[. = current()] or preceding::tei:author[. = current()]) and
		(not(preceding::tei:rs[@type = 'person'][@ref = current()/@ref])
		or not(preceding::tei:rs[@type = 'person'][. = current()]))">
		<xsl:choose>
			<xsl:when test="doc($listPerson)//*[@xml:id=substring(current()/@ref, 2)]">
				<xsl:value-of select="doc($listPerson)//*[@xml:id=substring(current()/@ref, 2)]/tei:persName[@xml:id]"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="Register"/>
			</xsl:otherwise>
		</xsl:choose>
		<!--<xsl:apply-templates mode="Register"/>-->
		<xsl:text> </xsl:text>
		<a>
			<xsl:attribute name="style">font-weight:bold</xsl:attribute>
			<xsl:attribute name="href" select="concat('#',ancestor::tei:TEI/@xml:id)"/>
			<xsl:choose>
				<xsl:when test="not($ignoreInIdno = '')">
					<xsl:value-of select="substring-after(ancestor::tei:msDesc/tei:msIdentifier/tei:idno,$ignoreInIdno)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="ancestor::tei:msDesc/tei:msIdentifier/tei:idno"/>
				</xsl:otherwise>
			</xsl:choose>
		</a>
	</xsl:if>
</xsl:template>

<xsl:template match="tei:rubric[not(normalize-space(.)='')] | tei:finalRubric[not(normalize-space(.)='')]">
	<xsl:choose>
		<xsl:when test="(@type = 'supplied')">
			<span>
				<xsl:attribute name="class">normal</xsl:attribute>
				<xsl:if test="not(starts-with(.,'['))">[</xsl:if>
				<xsl:apply-templates/>
				<xsl:if test="not(contains(.,']'))">]</xsl:if>
			</span>
		</xsl:when>
		<xsl:otherwise>
			<span>
				<xsl:attribute name="class">smaller</xsl:attribute>
				<xsl:text>&#x203A;</xsl:text>
			</span>
			<xsl:choose>
				<xsl:when test="contains(@rend,'before:content')">
					<xsl:value-of select="substring-before(substring-after(@rend,'before:content('),')')"/>
				</xsl:when>
			</xsl:choose>
			<span>
				<xsl:attribute name="class">rubric</xsl:attribute>
				<xsl:apply-templates/>
			</span>
			<xsl:choose>
				<xsl:when test="contains(@rend,'after:content')">
					<xsl:value-of select="substring-before(substring-after(@rend,'after:content('),')')"/>
				</xsl:when>
			</xsl:choose>
			<xsl:if test="not(normalize-space(.) = normalize-space(tei:ref))">
				<span>
					<xsl:attribute name="class">smaller</xsl:attribute>
					<xsl:text>&#x2039;</xsl:text>
				</span>
			</xsl:if>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:choose>
		<xsl:when test="contains(@rend, 'dottedEnd')">
			<xsl:text> &#x2026; </xsl:text>
		</xsl:when>
		<xsl:when test="following-sibling::*[1][self::tei:finalRubric]">
			<xsl:text> &#x2026; &#x2014; &#x2026; </xsl:text>
		</xsl:when>
		<xsl:when test="not(normalize-space(.) = normalize-space(tei:ref))">
			<xsl:call-template name="Satzzeichen"/>
		</xsl:when>
	</xsl:choose>
</xsl:template>
	
	

	<xsl:template match="tei:sic[not(normalize-space(.)='')]">
	<xsl:apply-templates/>
	<xsl:if test="not(parent::tei:choice) and not(contains(.,'['))">
		<span>
			<xsl:attribute name="class">normal</xsl:attribute>
			<xsl:text disable-output-escaping="yes"> [!]</xsl:text>
		</span>
	</xsl:if>
<!--	<xsl:call-template name="Leerzeichen"/>-->
</xsl:template>

<xsl:template match="tei:soCalled[not(normalize-space(.)='')]">
	<xsl:text>&quot;</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>&quot;</xsl:text>
</xsl:template>

<xsl:template match="tei:summary[not(normalize-space(.)='')]">
	<xsl:choose>
		<xsl:when test="tei:p"><p id="{generate-id()}"><xsl:apply-templates/></p></xsl:when>
		<xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:supplied[not(normalize-space(.)='')]">
	<span>
		<xsl:attribute name="class">normal</xsl:attribute>
		<xsl:if test="not(starts-with(.,'['))">[</xsl:if>
		<xsl:apply-templates/>
		<xsl:if test="not(contains(.,']'))">]</xsl:if>
	</span>
	<xsl:if test="not(parent::tei:w)"><xsl:call-template name="Leerzeichen"/></xsl:if>
</xsl:template>

<xsl:template match="tei:support">
	<xsl:choose>
		<xsl:when test="(normalize-space(.) = 'Pergament') 
			or (normalize-space(.) = 'Perg.') 
			or (normalize-space(.) = 'Papier') 
			or (normalize-space(.) = 'Pap.') 
			or (normalize-space(.) = 'Pergament und Papier') 
			or (normalize-space(.) = 'Papier und Pergament')"/>
		<xsl:otherwise>
			<xsl:apply-templates/>
			<xsl:call-template name="Leerzeichen"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:supportDesc">
	<xsl:choose>
		<xsl:when test="not(tei:p)">
			<!--<xsl:apply-templates select="tei:support"/>-->
			<!--<xsl:apply-templates select="tei:extent"/>-->
			
			<xsl:if test="tei:collation">
				<p class="physDesc">
					<span class="head"><xsl:text>Collation: </xsl:text></span>	
					<xsl:if test="tei:foliation">
						<xsl:apply-templates select="tei:foliation"/>
					</xsl:if>
					<xsl:apply-templates select="tei:collation"/>
				</p>
			</xsl:if>
			<!--alternative for presenting foliation as a separate paragraph with heading
				
				<xsl:if test="tei:foliation">
			<p class="physDesc">
				<span class="head"><xsl:text>Foliation: </xsl:text></span>
				<xsl:apply-templates select="tei:foliation"/>
			</p>
			</xsl:if>-->
			<xsl:apply-templates select="tei:condition"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:supportDesc" mode="Schlagzeile">
	<!-- Beschreibstoff -->
	<!-- später Datenprüfung durch das Schema -->
	<xsl:choose>
		<xsl:when test="normalize-space(tei:support/descendant::tei:material) != '' ">
			<xsl:apply-templates select="tei:support/descendant::tei:material" mode="Schlagzeile"/>
		</xsl:when>
		<xsl:when test="(@material != '') and not(@material = 'mixed')">
			<xsl:choose>
				<xsl:when test="@material = 'perg' "><xsl:text>Parchment</xsl:text></xsl:when>
				<xsl:when test="@material = 'chart' "><xsl:text>Paper</xsl:text></xsl:when>
				<xsl:when test="@material = 'papyrus' "><xsl:text>Papyrus</xsl:text></xsl:when>
			</xsl:choose>
		</xsl:when>
		<xsl:when test="(@material = 'mixed') and (normalize-space(tei:support/tei:p[. = tei:material]) != '')">
			<xsl:value-of select="tei:support/tei:p[. = tei:material]"/>
		</xsl:when>
		<xsl:when test="(@material = 'mixed')">
			<xsl:value-of select="tei:support"/>
		</xsl:when>
	</xsl:choose>
	<xsl:apply-templates select="descendant::tei:extent" mode="Schlagzeile"/>
</xsl:template>

<xsl:template match="tei:table[not(normalize-space(.)='')]">
	<table>
		<xsl:apply-templates/>
	</table>
</xsl:template>

<xsl:template match="tei:term[not(normalize-space(.)='')]" mode="Register">
	<xsl:if test="not(. = preceding::tei:term[not(ancestor::tei:index)])">
		<xsl:choose>
			<xsl:when test="(@type='script') or ancestor::tei:handNote">
				<xsl:apply-templates select="*[not(self::tei:locus)]"/>
				<xsl:apply-templates select="tei:locus" mode="Register"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="*[not(self::tei:locus)]"/>
				<xsl:apply-templates select="tei:locus" mode="Register"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="not(tei:locus) and ($publishSingleFiles = 'no')">
			<a>
				<xsl:attribute name="style">font-weight:bold</xsl:attribute>
				<xsl:attribute name="href" select="concat('#',ancestor::tei:TEI/@xml:id)"/>
				<xsl:choose>
					<xsl:when test="not($ignoreInIdno = '') and contains(ancestor::tei:msDesc/tei:msIdentifier/tei:idno,$ignoreInIdno)">
						<xsl:value-of select="substring-after(ancestor::tei:msDesc/tei:msIdentifier/tei:idno,$ignoreInIdno)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="ancestor::tei:msDesc/tei:msIdentifier/tei:idno"/>
					</xsl:otherwise>
				</xsl:choose>
			</a>
		</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="tei:textLang[not(normalize-space(.)='')]">
	<xsl:choose>
		<xsl:when test="parent::tei:msContents">
			<p>
				<xsl:attribute name="class">textLang</xsl:attribute>
				<xsl:apply-templates/>
			</p>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:title[not(normalize-space(.)='')]">
	<xsl:choose>
		<xsl:when test="parent::tei:head">
			<xsl:if test="parent::tei:head/preceding-sibling::tei:head/tei:title">
				<xsl:value-of select="$Trennzeichen"/>
			</xsl:if>
			<xsl:apply-templates/>
		</xsl:when>
		<xsl:when test="not(parent::tei:bibl) and not(@type='sub')">
			<span>
				<xsl:attribute name="class">titlemain</xsl:attribute>				
				<xsl:if test=" @rend = 'supplied' and not(preceding-sibling::tei:author[ @rend = 'supplied' ]) "><xsl:text>[</xsl:text></xsl:if>
				<xsl:choose>
					<xsl:when test=" @ref != ' ' ">
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="concat($githubPages, 'listtitle.html', @ref)"/>
							</xsl:attribute>	
							<xsl:value-of select="."/>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test=" @rend = 'supplied' "><xsl:text>]</xsl:text></xsl:if>
			</span>
		</xsl:when>
		<xsl:when test="not(parent::tei:bibl)">
			<span>
				<xsl:attribute name="class">normal</xsl:attribute>
				<xsl:apply-templates/>
			</span>
		</xsl:when>
		
		<xsl:when test="parent::tei:bibl">
			<span>
				<xsl:attribute name="class">italic</xsl:attribute>
				<xsl:value-of select="."/>
			</span>
		</xsl:when>		
		<xsl:otherwise>
			<xsl:apply-templates/>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:if test="not(text() = '') and not(following-sibling::node()[1][self::tei:edition]) and not(ancestor::tei:bibl) and not(parent::tei:head)">
		<xsl:call-template name="Satzzeichen"/>
	</xsl:if>
</xsl:template>

<xsl:template match="tei:title[not(normalize-space(.)='')]" mode="Register">
	<xsl:apply-templates select="node()[not(local-name()='note')]" mode="Register"/>
</xsl:template>

<xsl:template match="tei:unclear[not(normalize-space(.)='')]">
	<xsl:apply-templates/>
	<span>
		<xsl:attribute name="class">normal</xsl:attribute>
		<xsl:text> (?)</xsl:text>
	</span>
	<xsl:if test="following-sibling::node()">
		<xsl:call-template name="Leerzeichen"/>
	</xsl:if>
</xsl:template>

<!-- benannte Templates -->
<!--<xsl:template name="Autor">
	<xsl:param name="author"/>
	<p>
		<xsl:attribute name="class">foot</xsl:attribute>
		<xsl:value-of select="$author"/>
	</p>
</xsl:template>-->

<xsl:template name="BibliographieAusgeben">
	<hr/>	
	<p>
		<xsl:attribute name="class">head</xsl:attribute>
		<xsl:text>Abreviated Literature:</xsl:text>
	</p>
	<table>
		<xsl:attribute name="class">bibliography</xsl:attribute>
		<xsl:for-each select="$bibliography//tei:label[. = current()//tei:abbr[parent::tei:bibl[not(ancestor::tei:source)]][not(ancestor::tei:list[@type = 'bibliography'])]]">
			<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="if (starts-with(., tei:hi[@rend = 'sup'])) then substring-after(lower-case(.), tei:hi[@rend = 'sup']) else lower-case(.)"/>
			<tr>
				<td>
					<xsl:attribute name="style">vertical-align:top</xsl:attribute>
					<xsl:attribute name="nowrap">nowrap</xsl:attribute>
					<xsl:choose>						
						<xsl:when test="contains(parent::tei:item/@xml:id, 'gbv_')">
							<a>
								<xsl:attribute name="href">
									<xsl:text>https://kxp.k10plus.de/DB=2.1/PPNSET?PPN=</xsl:text>
									<xsl:value-of select="substring-after(parent::tei:item/@xml:id, 'gbv_')"/>
								</xsl:attribute>
								<xsl:attribute name="name">
									<xsl:value-of select="translate(.,' ()','_')"/>
								</xsl:attribute>
								<span>
									<xsl:attribute name="class">author</xsl:attribute>
									<xsl:apply-templates/>
								</span>
							</a>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="name">
								<xsl:value-of select="translate(.,' ()','_')"/>
							</xsl:attribute>
							<span>
								<xsl:attribute name="class">author</xsl:attribute>
								<xsl:apply-templates/>
							</span>
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td>
					<xsl:apply-templates select="following-sibling::tei:bibl[1]"/>
				</td>
			</tr>
		</xsl:for-each>
	</table>
	<!--<xsl:if test="//tei:abbr[parent::tei:bibl][not(. = $bibliography//tei:label)][not(substring-after(@corresp, '#') = //tei:bibl/@xml:id)]">
		<hr/>
		<p>
			<xsl:attribute name="style">color:red</xsl:attribute>
			<xsl:text>Abgekürzte, aber nicht nachgewiesene Literatur</xsl:text>
		</p>
		<ul>
			<xsl:for-each select="distinct-values(//tei:abbr[parent::tei:bibl][not(. = $bibliography//tei:label)])">
				<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="current()"/>
				<li><xsl:value-of select="concat('&quot;', ., '&quot;')"/></li>
			</xsl:for-each>
		</ul>
	</xsl:if>-->
</xsl:template>

<xsl:template name="DateiAusgeben">
	<xsl:param name="start"/>
	<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
			<title>
				<xsl:value-of select="descendant-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='sub']"/> <xsl:text> - </xsl:text> <xsl:value-of select="descendant-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='main']"/>				
			</title>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>	
			<!--<link rel="stylesheet" type="text/css" href="http://diglib.hab.de/rules/styles/mss/TEI-P5-to-Print/druck.css"/>-->
			<link rel="stylesheet" type="text/css" href="css/aratea.css"/>
			<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" />
		</head>
		<body>
			<xsl:call-template name="nav_bar"/>
			<div class="container">
			<xsl:call-template name="Title"/>
				
			<xsl:apply-templates select="descendant-or-self::tei:msDesc"/>
			<xsl:if test="($listAbbreviatedTitles = 'yes') and 
				$bibliography//tei:label[. = current()//tei:abbr[parent::tei:bibl[not(ancestor::tei:source)]][not(ancestor::tei:list[@type = 'bibliography'])]]">
				<xsl:call-template name="BibliographieAusgeben"/>
			</xsl:if>			
			<!--<xsl:if test="($showIndex = 'yes') and ( 
				descendant::tei:author[parent::tei:msItem] 
				or descendant::tei:incipit 
				or descendant::tei:index 
				or descendant::tei:ref[(@type='mss') or (@type='altMs')]
				or descendant::tei:rs[(@type='person') or (@type='place') or (@type='org') or (@type='corporate')]
				or descendant::tei:title[parent::tei:msItem]
				) ">
<!-\-				<xsl:call-template name="registerAusgeben"/>-\->
			</xsl:if>-->
				<hr/>
				<div class="copyright">
					<a rel="license" href="http://creativecommons.org/licenses/by/4.0/" target="_blank"><img src="https://licensebuttons.net/l/by/4.0/88x31.png" width="88" height="31" alt="Creative Commons License"></img></a>
					<p><xsl:apply-templates select="descendant-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:respStmt"/></p>
				</div>
				<xsl:choose>
					<xsl:when test="descendant-or-self::tei:TEI/tei:teiHeader/tei:revisionDesc/@status = 'draft' ">
						<xsl:text> (draft version: </xsl:text>
						<xsl:value-of select="descendant-or-self::tei:TEI/tei:teiHeader/tei:revisionDesc/tei:change/@when"/><xsl:text>)</xsl:text>		
					</xsl:when>
					<xsl:when test="descendant-or-self::tei:TEI/tei:teiHeader/tei:revisionDesc/@status = 'complete' ">
						<xsl:text> (last change: </xsl:text>
						<xsl:value-of select="descendant-or-self::tei:TEI/tei:teiHeader/tei:revisionDesc/tei:change[1]/@when"/><xsl:text>)</xsl:text>
					</xsl:when>
				</xsl:choose>
			<div id="{generate-id()}">
				<xsl:text>How to quote: </xsl:text>
				<xsl:apply-templates select="descendant-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:respStmt/tei:name | descendant-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:respStmt/tei:persName"/><xsl:text>, '</xsl:text>
				<xsl:value-of select="descendant-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='sub']"/> <xsl:text> - </xsl:text> <xsl:value-of select="descendant-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='main']"/> <xsl:text>' (</xsl:text>
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="concat($gitData,replace(tokenize($full_path, '/')[last()], '.html', '.xml'))"/>
					</xsl:attribute>
					<xsl:value-of select="concat($gitData,replace(tokenize($full_path, '/')[last()], '.html', '.xml'))"/>
				</a>
				<xsl:text> last update: </xsl:text><xsl:value-of select="descendant-or-self::tei:TEI/tei:teiHeader/tei:revisionDesc/tei:change[1]/@when"/><xsl:text>).</xsl:text>
			</div>
				<hr/>
			</div>
			<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"  />
			<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"  />
			<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"  />
		</body>
	</html>
</xsl:template>

	<xsl:template name="Title">
		<div id="{generate-id()}">
			<span class="header">
				<xsl:value-of select="descendant-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='sub']"/>
				<xsl:choose>
					<xsl:when test="descendant-or-self::tei:TEI/tei:text/tei:body/tei:msDesc/tei:msIdentifier/tei:altIdentifier[@type='former'][not(@rend='doNotShow')][not(contains(preceding-sibling::tei:idno, tei:idno))]">						
						<xsl:apply-templates select="descendant-or-self::tei:TEI/tei:text/tei:body/tei:msDesc/tei:msIdentifier/tei:altIdentifier[@type='former'][not(@rend='doNotShow')][not(contains(preceding-sibling::tei:idno, tei:idno))]" mode="Schlagzeile"/>
					</xsl:when>					
				</xsl:choose>
			</span>			
		</div>	
		<hr/>		
		<xsl:choose>
			<xsl:when test="descendant-or-self::tei:TEI/tei:text/tei:body/tei:msDesc/tei:head/tei:note[@type='facs']">
				<a class="btn btn-outline-dark" href="{descendant-or-self::tei:TEI/tei:text/tei:body/tei:msDesc/tei:head/tei:note[@type='facs']/tei:ref/@target}">
					<xsl:text>Facsimile</xsl:text>
				</a>
			</xsl:when>
		</xsl:choose>
		
		<div class="divider"/>
		
		<xsl:choose>
			<xsl:when test="descendant-or-self::tei:TEI/tei:text/tei:body/tei:msDesc/tei:head/tei:note[@type='catalogue']">
				<a class="btn btn-outline-dark" href="{descendant-or-self::tei:TEI/tei:text/tei:body/tei:msDesc/tei:head/tei:note[@type='catalogue']/tei:ref/@target}">
					<xsl:text>Library catalogue</xsl:text>
				</a>
			</xsl:when>
		</xsl:choose>
		
		<div class="divider"/>
		<a class="btn btn-outline-dark">
			<xsl:attribute name="href">		
				<xsl:variable name="full_path">
					<xsl:value-of select="document-uri(/)"/>
				</xsl:variable>
				<xsl:value-of select="concat($gitData,replace(tokenize($full_path, '/')[last()], '.html', '.xml'))"/>
			</xsl:attribute>
			<xsl:text>Show TEI-XML</xsl:text>
		</a>
		<hr/>		
		<!--<p>
			<xsl:attribute name="class">Hinweis</xsl:attribute>
			<xsl:choose>
				<!-\-<xsl:when test="descendant-or-self::tei:teiCorpus and ($publishSingleFiles = 'no')">
				<xsl:apply-templates select="descendant-or-self::tei:teiCorpus/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
				<xsl:apply-templates select="descendant-or-self::tei:teiCorpus/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author"/>
				<xsl:apply-templates select="descendant-or-self::tei:teiCorpus/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:respStmt"/>
			</xsl:when>-\->
				<xsl:when test="descendant::tei:msDesc[2] and ($publishSingleFiles = 'no')">
					<xsl:apply-templates select="descendant-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
					<xsl:apply-templates select="descendant-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author"/>
					<xsl:apply-templates select="descendant-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:respStmt"/>
				</xsl:when>
				<xsl:when test="($publishSingleFiles = 'yes') and not(descendant::tei:additional/tei:adminInfo/tei:recordHist/tei:source = '')">
					<xsl:apply-templates select="descendant::tei:additional/tei:adminInfo/tei:recordHist/tei:source"/>
				</xsl:when>
				<xsl:when test="not(descendant::tei:additional/tei:adminInfo/tei:recordHist/tei:source = '')">
					<xsl:apply-templates select="descendant::tei:additional/tei:adminInfo/tei:recordHist/tei:source"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="descendant-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
					<xsl:apply-templates select="descendant-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author"/>
					<xsl:apply-templates select="descendant-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:respStmt"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="descendant::tei:fileDesc/tei:titleStmt/tei:funder">
				<br/>
				<xsl:for-each select="descendant::tei:fileDesc/tei:titleStmt/tei:funder[not(.=preceding::tei:fileDesc/tei:titleStmt/tei:funder)]">
					<xsl:if test="preceding-sibling::tei:funder"><xsl:text>, </xsl:text></xsl:if>
					<xsl:apply-templates/>
				</xsl:for-each>
			</xsl:if>			
		</p>-->
	</xsl:template>	
	
	<xsl:template name="Ueberschrift">
	<p>
		<xsl:attribute name="class">head</xsl:attribute>
		<xsl:choose>
			<xsl:when test="tei:head/tei:title">
				<xsl:apply-templates select="tei:head/tei:title"/>
			</xsl:when>
			<xsl:when test="not(tei:head/tei:title) and tei:msIdentifier/tei:msName">
				<xsl:apply-templates select="tei:msIdentifier/tei:msName"/>
			</xsl:when>
			<!--<xsl:otherwise>
				<xsl:for-each
					select="tei:msContents/tei:msItem[tei:author or tei:title] | tei:msPart/tei:msContents/tei:msItem[tei:author or tei:title]">
					<xsl:if test="preceding-sibling::tei:msItem[tei:author or tei:title]">
						<xsl:value-of select="$Trennzeichen"/>
					</xsl:if>
					<xsl:value-of select="tei:author"/>
					<xsl:if test="tei:author and tei:title">
						<xsl:text>: </xsl:text>
					</xsl:if>
					<xsl:value-of select="tei:title"/>
				</xsl:for-each>
			</xsl:otherwise>-->
		</xsl:choose>
		
	</p>
	<p>
		<xsl:choose>
			<xsl:when test="tei:head/tei:note[@type='aratea']">
				<span><xsl:text>Aratea text: </xsl:text>
					<xsl:for-each select="tei:head/tei:note[@type='aratea']">	
						<xsl:variable name="githubPages">https://ivanadob.github.io/aratea-data/</xsl:variable>
						<xsl:variable name="nohashtag">
							<xsl:value-of select="substring-after(tei:rs/@ref, '#')"/>
						</xsl:variable>
						<a> 
							<xsl:attribute name="href">
								<xsl:value-of select="concat($githubPages,replace(tokenize($nohashtag, '/')[last()], '.xml', '.html'))"/>
							</xsl:attribute>
							
							<xsl:value-of select="."/>
							<xsl:if test="following-sibling::tei:note[@type='aratea']">
								<xsl:text>; </xsl:text>
							</xsl:if>
						</a>
					</xsl:for-each>
				</span>
			</xsl:when>
		</xsl:choose>
	</p>
</xsl:template>

<xsl:template name="Datum-ausgeben">
	<xsl:param name="date"/>
	<xsl:analyze-string select="$date" regex="(\d+)-(\d+)-(\d+)">
		<xsl:matching-substring>
			<xsl:value-of select="concat(number(regex-group(3)), '.', number(regex-group(2)), '.', number(regex-group(1)))"/>
		</xsl:matching-substring>
		<xsl:non-matching-substring>
			<xsl:analyze-string select="$date" regex="--(\d+)-(\d+)">
				<xsl:matching-substring>
					<xsl:value-of select="concat(number(regex-group(2)), '.', number(regex-group(1)))"/>
				</xsl:matching-substring>
				<xsl:non-matching-substring><xsl:value-of select="$date"/></xsl:non-matching-substring>
			</xsl:analyze-string>
		</xsl:non-matching-substring>
	</xsl:analyze-string>
</xsl:template>

<xsl:template name="Fusszeile">
	<xsl:if test="descendant-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt[not(tei:author) and not(tei:title)] or normalize-space(descendant-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt)">
		<hr/>
		<p>
			<xsl:attribute name="class">foot</xsl:attribute>
			<xsl:value-of select="descendant-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/*[not(self::tei:author) and not(self::tei:title)]"/>
			<br/>
			<xsl:apply-templates select="descendant-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/node()"/>
		</p>
	</xsl:if>
</xsl:template>
	
	
<!--<xsl:template name="HandschriftenErwaehnteAusgeben">
	<ul>
		<xsl:for-each-group select="descendant::tei:ref[(@type='mss') or (@type='altMs')]" group-by="if (@cRef) then @cRef else normalize-space(.)">
			
			<li>
				<xsl:call-template name="SignaturAusgeben">
					<xsl:with-param name="Value" select="current-grouping-key()"/>
				</xsl:call-template>
				<xsl:for-each-group select="current-group()" group-by="ancestor::tei:msDesc/@xml:id">
					<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="current-grouping-key()"/>
					<xsl:text> </xsl:text>
					<span>
						<xsl:attribute name="class">idno</xsl:attribute>
                            <a href="#{current-grouping-key()}">
							<xsl:choose>
								<xsl:when test="contains(current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno, $ignoreInIdno)">
									<xsl:value-of select="substring-after(current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno, $ignoreInIdno)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno"/>
								</xsl:otherwise>
							</xsl:choose>
						</a>
					</span>
					<!-\-
					<xsl:for-each select="current-group()/ancestor::node()[tei:locus]/tei:locus[1]">
						<xsl:text> </xsl:text>
						<xsl:apply-templates select="self::node()">
							<xsl:with-param name="index">yes</xsl:with-param>
						</xsl:apply-templates>
						<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
					</xsl:for-each>
					-\->
					<xsl:if test="not(position() = last())"><xsl:text>;</xsl:text></xsl:if>
				</xsl:for-each-group>
			</li>
		</xsl:for-each-group>
		<xsl:for-each-group select="descendant::tei:msIdentifier[parent::tei:bibl]" group-by="tei:settlement">
			<li>
				<xsl:value-of select="current-grouping-key()"/>
				<ul>
					<xsl:for-each-group select="current-group()" group-by="tei:repository">
						<li>
							<xsl:value-of select="current-grouping-key()"/>
							<ul>
								<xsl:for-each-group select="current-group()" group-by="tei:idno">
									<li>
										<xsl:value-of select="current-grouping-key()"/>
										<xsl:for-each-group select="current-group()" group-by="ancestor::tei:msDesc/@xml:id">
											<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="current-grouping-key()"/>
											<xsl:text> </xsl:text>
											<span>
												<xsl:attribute name="class">idno</xsl:attribute>
                                                    <a href="#{current-grouping-key()}">
													<xsl:choose>
														<xsl:when test="contains(current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno, $ignoreInIdno)">
															<xsl:value-of select="substring-after(current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno, $ignoreInIdno)"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno"/>
														</xsl:otherwise>
													</xsl:choose>
												</a>
											</span>
											<!-\-
											<xsl:for-each select="current-group()/ancestor::node()[tei:locus]/tei:locus[1]">
												<xsl:text> </xsl:text>
												<xsl:apply-templates select="self::node()">
													<xsl:with-param name="index">yes</xsl:with-param>
												</xsl:apply-templates>
												<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
											</xsl:for-each>
											-\->
											<xsl:if test="not(position() = last())"><xsl:text>;</xsl:text></xsl:if>
										</xsl:for-each-group>
									</li>
								</xsl:for-each-group>
							</ul>
						</li>
					</xsl:for-each-group>
				</ul>
			</li>
		</xsl:for-each-group>
	</ul>
</xsl:template>-->
<!--<xsl:template name="SignaturAusgeben">
	<xsl:param name="Value"/>
	<xsl:value-of select="$Value"/>
</xsl:template>-->

<xsl:template name="Hauptverteiler">
	<xsl:apply-templates select="tei:physDesc"/>
	<xsl:apply-templates select="tei:history"/><!--
	<xsl:call-template name="msPartCondensed"/>-->
	<xsl:apply-templates select="tei:additional"/>
	<xsl:apply-templates select="tei:msContents"/>
	<xsl:apply-templates select="tei:msPart[not(@rend = 'condensed')]"/>
</xsl:template>

<!--<xsl:template name="JavascriptEinfuegen">
	<script>
		<xsl:attribute name="type">text/javascript</xsl:attribute><![CDATA[
function Go (select) {
	var wert = select.options[select.options.selectedIndex].value;
	if (wert == "leer")
	{
		select.form.reset();
		parent.focus();
		return;
	} else 
	{
		if (wert == "ende") 
		{
		  top.location.href = parent.location.href;
		} else 
		{
		  parent.location.href = wert;
		  select.form.reset();
		  parent.focus();
		}
	}
}
]]></script>
</xsl:template>-->



<xsl:template name="Leerzeichen">
    <xsl:if test="(
    	not(ends-with(normalize-space(parent::*), normalize-space(.))) and
    	not(starts-with(following-sibling::node()[1],')')) and
    	not(starts-with(following-sibling::node()[1],',')) and
    	not(starts-with(following-sibling::node()[1],';')) and
    	not(starts-with(following-sibling::node()[1],'.')) and
    	not(starts-with(following-sibling::node()[1],':')) and
    	not(starts-with(following-sibling::node()[1],'-')) and
    	not(starts-with(following-sibling::node()[1],'–')) and
    	not(starts-with(following-sibling::node()[1],']'))
    	) or starts-with(following-sibling::node()[1],'&#x2026;')">
      <xsl:text> </xsl:text>
    </xsl:if>
</xsl:template>


<xsl:template name="locus-verlinken">
	<xsl:param name="attribute"/>
	<xsl:param name="content"/>
	<xsl:variable name="xmlid">
		<xsl:choose>
			<xsl:when test="ancestor::tei:TEI/@xml:base">
				<xsl:value-of select="ancestor::tei:TEI/@xml:base"/>
			</xsl:when>
			<xsl:when test="ancestor::tei:TEI/tei:facsimile/@xml:id[contains(., $collection)]">
				<xsl:value-of select="substring-after(ancestor::tei:TEI/tei:facsimile/@xml:id, concat($collection, '_'))"/>
			</xsl:when>
			<xsl:when test="contains(ancestor::tei:TEI/@xml:id, '_') and contains(ancestor::tei:TEI/@xml:id, 'tei-msDesc')">
				<xsl:value-of select="substring-before(substring-after(ancestor::tei:TEI/@xml:id, concat($collection, '_')), '_tei-msDesc')"/>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="ancestor::tei:TEI/@xml:id"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="facsimile">
		<xsl:choose>
			<xsl:when test="ancestor-or-self::tei:TEI/tei:facsimile">
				<xsl:copy-of select="ancestor-or-self::tei:TEI/tei:facsimile"/>
			</xsl:when>
			<!--
			<xsl:when test="doc-available('tei-msDesc.xml') and doc('tei-msDesc.xml')//tei:facsimile"><xsl:copy-of select="doc('tei-msDesc.xml')//tei:facsimile"/></xsl:when>
			<xsl:when test="doc-available(concat($server, $collection, '/', $xmlid, '/', $facsimileData))"><xsl:copy-of select="doc(concat($server, $collection, '/', $xmlid, '/', $facsimileData))"/></xsl:when>-->
		</xsl:choose>
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="$facsimile/*:facsimile/*:graphic/@n[.=$attribute]">
			<a href="{$facsimile/*:facsimile/*:graphic[@n=$attribute]/@url}">
				<xsl:value-of select="$content"/>
			</a>
		</xsl:when>
		<!--<xsl:when test="$facsimile/*:facsimile/*:graphic/@n[.=$attribute]">
			<a href="{substring-after($facsimile/*:facsimile/*:graphic[@n=$attribute]/@xml:id, concat($xmlid,'_'))}">
				<xsl:value-of select="$content"/>
			</a>
		</xsl:when>
		<xsl:when test="$facsimile/*:facsimile/*:graphic/@n[.=substring-before($attribute,'a')]">
			<a href="{$server}{$collection}/{$xmlid}/{$startfile}{$imageParameter}{substring-after($facsimile/*:facsimile/*:graphic[@n=substring-before($attribute,'a')]/@xml:id, concat($xmlid,'_'))}">
				<xsl:value-of select="$content"/>
			</a>
		</xsl:when>
		<xsl:when test="$facsimile/*:facsimile/*:graphic/@n[.=substring-before($attribute,'b')]">
			<a href="{$server}{$collection}/{$xmlid}/{$startfile}{$imageParameter}{substring-after($facsimile/*:facsimile/*:graphic[@n=substring-before($attribute,'b')]/@xml:id, concat($xmlid,'_'))}">
				<xsl:value-of select="$content"/>
			</a>
		</xsl:when>
		<xsl:when test="$facsimile/*:facsimile/*:graphic/@n[.=substring-before($attribute,'c')]">
			<a href="{$server}{$collection}/{$xmlid}/{$startfile}{$imageParameter}{substring-after($facsimile/*:facsimile/*:graphic[@n=substring-before($attribute,'c')]/@xml:id, concat($xmlid,'_'))}">
				<xsl:value-of select="$content"/>
			</a>
		</xsl:when>
		<xsl:when test="$facsimile/*:facsimile/*:graphic/@n[.=substring-before($attribute,'d')]">
			<a href="{$server}{$collection}/{$xmlid}/{$startfile}{$imageParameter}{substring-after($facsimile/*:facsimile/*:graphic[@n=substring-before($attribute,'d')]/@xml:id, concat($xmlid,'_'))}">
				<xsl:value-of select="$content"/>
			</a>
		</xsl:when>-->
		<xsl:otherwise>
			<xsl:value-of select="$content"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!--<xsl:template name="msPartCondensed">
	<xsl:if test="tei:msPart[@rend = 'condensed']">
		<xsl:choose>
			<xsl:when test="not(tei:msPart[2]) and tei:msPart[@rend = 'condensed'][not(tei:head)and not(tei:msContents) and not(tei:physDesc) and not(tei:history) and not(tei:additional) and not(tei:p)]">
				<div id="{generate-id()}">
					<xsl:attribute name="class">fragments</xsl:attribute>
					<xsl:value-of select="tei:altIdentifier/tei:idno"/>
				</div>
			</xsl:when>
			<xsl:when test="contains(tei:msPart[@rend='condensed'][1]/tei:altIdentifier/tei:idno,'Fragment')"/>
			<xsl:when test="tei:msPart[2]">
				<div id="{generate-id()}">
					<xsl:attribute name="class">fragments</xsl:attribute>
					<xsl:text>Fragmente</xsl:text>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<div id="{generate-id()}">
					<xsl:attribute name="class">fragments</xsl:attribute>
					<xsl:text>Fragment</xsl:text>
				</div>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="not(tei:msPart[2]) and tei:msPart[@rend = 'condensed'][not(tei:head)and not(tei:msContents) and not(tei:physDesc) and not(tei:history) and not(tei:additional) and not(tei:p)]">
				<ol>
					<xsl:attribute name="class">condensed</xsl:attribute>
					<xsl:for-each select="tei:msPart/tei:msPart[@rend = 'condensed']">
						<li>
							<xsl:if test="not(normalize-space(tei:altIdentifier/*) = string(position()))"><xsl:value-of select="concat(normalize-space(tei:altIdentifier/*),'. ')"/></xsl:if>
							<xsl:apply-templates select="tei:head/*" mode="condensed"/>
							<xsl:apply-templates select="tei:physDesc/*" mode="condensed"/>
							<!-\-					<xsl:for-each select="tei:head/*">
								<xsl:value-of select="concat(.,'. ')"/>
								</xsl:for-each>
								<xsl:for-each select="tei:physDesc/*">
								<xsl:value-of select="concat(.,' ')"/>
								</xsl:for-each>-\->
							<xsl:apply-templates select="*[not(self::tei:altIdentifier) and not(self::tei:head) and not(self::tei:physDesc)]" mode="condensed"/>
						</li>
					</xsl:for-each>
				</ol>
			</xsl:when>
			<xsl:otherwise>
				<ol>
					<xsl:attribute name="class">condensed</xsl:attribute>
					<xsl:for-each select="tei:msPart[@rend = 'condensed']">
						<li>
							<xsl:if test="not(normalize-space(tei:altIdentifier/*) = string(position()))"><xsl:value-of select="concat(normalize-space(tei:altIdentifier/*),'. ')"/></xsl:if>
							<xsl:apply-templates select="tei:head/*" mode="condensed"/>
							<xsl:apply-templates select="tei:physDesc/*" mode="condensed"/>
							<!-\-					<xsl:for-each select="tei:head/*">
								<xsl:value-of select="concat(.,'. ')"/>
								</xsl:for-each>
								<xsl:for-each select="tei:physDesc/*">
								<xsl:value-of select="concat(.,' ')"/>
								</xsl:for-each>-\->
							<xsl:apply-templates select="*[not(self::tei:altIdentifier) and not(self::tei:head) and not(self::tei:physDesc)]" mode="condensed"/>
						</li>
					</xsl:for-each>
				</ol>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
</xsl:template>-->

<!--<xsl:template match="*[not(normalize-space(.)='')]" mode="condensed">
	<xsl:apply-templates/>
	<xsl:if test="
		not(ends-with(normalize-space(.), ',')) and
		not(ends-with(normalize-space(.), ';')) and
		not(ends-with(normalize-space(.), '.')) and
		not(ends-with(normalize-space(.), ':')) and
		not(ends-with(normalize-space(.), '!')) and
		not(ends-with(normalize-space(parent::*), normalize-space(.)))">
		<xsl:text>.</xsl:text>
	</xsl:if>
	<xsl:text> </xsl:text>
</xsl:template>-->

<!--<xsl:template name="registerAusgeben">
	<hr/>
	<p>
		<xsl:attribute name="class">head</xsl:attribute>
		<xsl:text>Personen-, Orts- und Sachregister</xsl:text>
	</p>
	<ul>
		<xsl:variable name="temporäresRegister">
			<xsl:for-each-group select="descendant::tei:msItem[tei:author[not(. = '')]]" group-by="tei:author">
				<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="current-grouping-key()"/>
				<li>
					<xsl:choose>
						<xsl:when test="starts-with(current-grouping-key(), 'http://')">
							<xsl:value-of select="."/>
						</xsl:when>
						<!-\-<xsl:when test="starts-with(current-grouping-key(), '#') and //@xml:id[.=substring(current-grouping-key(),2)]">
							<xsl:apply-templates select="//*[@xml:id[.=substring(current-grouping-key(),2)]]" mode="Register"/>
						</xsl:when>-\->
						<xsl:when test="starts-with(current-grouping-key(), '#') and doc($listPerson)//tei:person[@xml:id[.=substring(current-grouping-key(),2)]]">
							<xsl:apply-templates select="//*[@ref=current-grouping-key()]" mode="Register"/>
						</xsl:when>
						<!-\-<xsl:when test="contains(current-grouping-key(), '_') and contains(current-grouping-key(), '#')">
							<xsl:text>_keine Normdaten vorhanden: </xsl:text>
							<xsl:value-of select="translate(current-grouping-key(), '_#', ' ')"/>
						</xsl:when>
						<xsl:when test="contains(current-grouping-key(), '_')">
							<xsl:value-of select="translate(current-grouping-key(), '_', ' ')"/>
						</xsl:when>
						<xsl:when test="contains(current-grouping-key(), '#')">
							<xsl:value-of select="translate(current-grouping-key(), '#', '')"/>
						</xsl:when>-\->
						<xsl:otherwise>
							<xsl:value-of select="current-grouping-key()"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="current-group()/tei:title[not(@type='sub')]">
							<ul>
								<xsl:for-each-group select="current-group()/tei:title[not(@type='sub')]" group-by=".">
									<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="current-grouping-key()"/>
									<li>
										<xsl:apply-templates select="." mode="Register"/>
										<xsl:for-each-group select="current-group()" group-by="ancestor::tei:msDesc/@xml:id">
											<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="current-grouping-key()"/>
											<xsl:text> </xsl:text>
											<span>
												<xsl:attribute name="class">idno</xsl:attribute>
                                                    <a href="#{current-grouping-key()}">
													<xsl:choose>
														<xsl:when test="contains(current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno, $ignoreInIdno)">
															<xsl:value-of select="substring-after(current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno, $ignoreInIdno)"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno"/>
														</xsl:otherwise>
													</xsl:choose>
												</a>
											</span>
											<xsl:for-each select="current-group()/preceding::tei:locus[1]">
												<xsl:text> </xsl:text>
												<xsl:apply-templates select="self::node()">
													<xsl:with-param name="index">yes</xsl:with-param>
												</xsl:apply-templates>
												<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
											</xsl:for-each>
										</xsl:for-each-group>
									</li>
								</xsl:for-each-group>
							</ul>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="current-group()/preceding::tei:locus[1]"/>
						</xsl:otherwise>
					</xsl:choose>
				</li>
			</xsl:for-each-group>
			<li>Origin
				<ul>
					<xsl:for-each-group select="descendant::tei:origPlace[not(. = '')]" group-by=".">
						<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="current-grouping-key()"/>
						<li>
							<xsl:value-of select="current-grouping-key()"/>
							<xsl:for-each-group select="current-group()" group-by="ancestor::tei:msDesc/@xml:id">
								<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="current-grouping-key()"/>
								<xsl:text> </xsl:text>
								<span>
									<xsl:attribute name="class">idno</xsl:attribute>
                                        <a href="#{current-grouping-key()}">
										<xsl:choose>
											<xsl:when test="contains(current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno, $ignoreInIdno)">
												<xsl:value-of select="substring-after(current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno, $ignoreInIdno)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno"/>
											</xsl:otherwise>
										</xsl:choose>
									</a>
								</span>
								<xsl:for-each select="current-group()/preceding::tei:locus[1]">
									<xsl:text> </xsl:text>
									<xsl:apply-templates select="self::node()">
										<xsl:with-param name="index">yes</xsl:with-param>
									</xsl:apply-templates>
									<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
								</xsl:for-each>
							</xsl:for-each-group>
						</li>
					</xsl:for-each-group>
				</ul>
			</li>
			<xsl:for-each-group select="descendant::tei:title[not(@type='sub')][not(preceding-sibling::tei:author[not(. = '')])][parent::tei:msItem[parent::tei:msContents] or ancestor::tei:accMat]" group-by=".">
				<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="current-grouping-key()"/>
				<li>
					<xsl:apply-templates select="." mode="Register"/>
					<xsl:for-each-group select="current-group()" group-by="ancestor::tei:msDesc/@xml:id">
						<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="current-grouping-key()"/>
						<xsl:text> </xsl:text>
						<span>
							<xsl:attribute name="class">idno</xsl:attribute>
                                <a href="#{current-grouping-key()}">
								<xsl:choose>
									<xsl:when test="contains(current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno, $ignoreInIdno)">
										<xsl:value-of select="substring-after(current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno, $ignoreInIdno)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno"/>
									</xsl:otherwise>
								</xsl:choose>
							</a>
						</span>
						<xsl:for-each select="current-group()/preceding::tei:locus[1]">
							<xsl:text> </xsl:text>
							<xsl:apply-templates select="self::node()">
								<xsl:with-param name="index">yes</xsl:with-param>
							</xsl:apply-templates>
							<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
						</xsl:for-each>
					</xsl:for-each-group>
				</li>
			</xsl:for-each-group>
			<xsl:for-each-group select="descendant::tei:index[not(parent::tei:index)]" group-by="tei:term">
				<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="current-grouping-key()"/>
				<li>
					<xsl:value-of select="current-grouping-key()"/>
					<xsl:choose>
						<xsl:when test="current-group()/tei:index">
							<ul>
								<xsl:for-each-group select="current-group()/tei:index" group-by="tei:term">
									<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="current-grouping-key()"/>
									<li>
										<xsl:value-of select="current-grouping-key()"/>
										<xsl:choose>
											<xsl:when test="current-group()/tei:index">
												<ul>
													<xsl:for-each-group select="current-group()/tei:index" group-by="tei:term">
														<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="current-grouping-key()"/>
														<li>
															<xsl:value-of select="current-grouping-key()"/>
															<xsl:for-each-group select="current-group()" group-by="ancestor::tei:msDesc/@xml:id">
																<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="current-grouping-key()"/>
																<xsl:text> </xsl:text>
																<span>
																	<xsl:attribute name="class">idno</xsl:attribute>
                                                                        <a href="#{current-grouping-key()}">
																		<xsl:choose>
																			<xsl:when test="contains(current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno, $ignoreInIdno)">
																				<xsl:value-of select="substring-after(current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno, $ignoreInIdno)"/>
																			</xsl:when>
																			<xsl:otherwise>
																				<xsl:value-of select="current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno"/>
																			</xsl:otherwise>
																		</xsl:choose>
																	</a>
																</span>
																<xsl:for-each select="current-group()/preceding::tei:locus[1]">
																	<xsl:text> </xsl:text>
																	<xsl:apply-templates select="self::node()">
																		<xsl:with-param name="index">yes</xsl:with-param>
																	</xsl:apply-templates>
																	<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
																</xsl:for-each>
																<xsl:if test="not(position() = last())"><xsl:text>;</xsl:text></xsl:if>
															</xsl:for-each-group>
														</li>
													</xsl:for-each-group>
												</ul>
											</xsl:when>
											<xsl:otherwise>
												<xsl:for-each-group select="current-group()[not(tei:index)]" group-by="ancestor::tei:msDesc/@xml:id">
													<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="current-grouping-key()"/>
													<xsl:text> </xsl:text>
													<span>
														<xsl:attribute name="class">idno</xsl:attribute>
                                                        <a href="#{current-grouping-key()}">
															<xsl:choose>
																<xsl:when test="contains(current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno, $ignoreInIdno)">
																	<xsl:value-of select="substring-after(current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno, $ignoreInIdno)"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno"/>
																</xsl:otherwise>
															</xsl:choose>
														</a>
													</span>
													<xsl:for-each select="current-group()/preceding::tei:locus[1]">
														<xsl:text> </xsl:text>
														<xsl:apply-templates select="self::node()">
															<xsl:with-param name="index">yes</xsl:with-param>
														</xsl:apply-templates>
														<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
													</xsl:for-each>
													<xsl:if test="not(position() = last())"><xsl:text>;</xsl:text></xsl:if>
												</xsl:for-each-group>
											</xsl:otherwise>
										</xsl:choose>
									</li>
								</xsl:for-each-group>
							</ul>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each-group select="current-group()[not(tei:index)]" group-by="ancestor::tei:msDesc/@xml:id">
								<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="current-grouping-key()"/>
								<xsl:text> </xsl:text>
								<span>
									<xsl:attribute name="class">idno</xsl:attribute>
                                    <a href="#{current-grouping-key()}">
										<xsl:choose>
											<xsl:when test="contains(current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno, $ignoreInIdno)">
												<xsl:value-of select="substring-after(current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno, $ignoreInIdno)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno"/>
											</xsl:otherwise>
										</xsl:choose>
									</a>
								</span>
								<xsl:for-each select="current-group()/preceding::tei:locus[1]">
									<xsl:text> </xsl:text>
									<xsl:apply-templates select="self::node()">
										<xsl:with-param name="index">yes</xsl:with-param>
									</xsl:apply-templates>
									<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
								</xsl:for-each>
								<xsl:if test="not(position() = last())"><xsl:text>;</xsl:text></xsl:if>
							</xsl:for-each-group>
						</xsl:otherwise>
					</xsl:choose>
				</li>
			</xsl:for-each-group>
			<xsl:if test="descendant::tei:decoNote[@type or descendant::tei:term[not(.='Buchschmuck')]]">
				<li>
					<xsl:text>Buchschmuck</xsl:text>
					<ul>
						<xsl:for-each-group select="descendant::tei:decoNote[not(descendant::tei:index/tei:term[.='Buchschmuck'])][@type]" group-by="@type">
							<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="current-grouping-key()"/>
							<li>
								<xsl:choose>
									<xsl:when test="current-grouping-key()='illustration'"><xsl:text>Illustrationen</xsl:text></xsl:when>
									<xsl:when test="current-grouping-key()='initial'"><xsl:text>Initialen</xsl:text></xsl:when>
									<xsl:when test="current-grouping-key()='miniature'"><xsl:text>Miniaturen</xsl:text></xsl:when>
									<xsl:otherwise><xsl:value-of select="current-grouping-key()"/></xsl:otherwise>
								</xsl:choose>
								<ul>
									<xsl:for-each-group select="descendant::tei:term[not(parent::tei:index)]" group-by=".">
										<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="current-grouping-key()"/>
										<li>
											<xsl:value-of select="current-grouping-key()"/>
											<xsl:for-each-group select="current-group()" group-by="ancestor::tei:msDesc/@xml:id">
												<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="current-grouping-key()"/>
												<xsl:text> </xsl:text>
												<span>
													<xsl:attribute name="class">idno</xsl:attribute>
                                                    <a href="#{current-grouping-key()}">
														<xsl:choose>
															<xsl:when test="contains(current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno, $ignoreInIdno)">
																<xsl:value-of select="substring-after(current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno, $ignoreInIdno)"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno"/>
															</xsl:otherwise>
														</xsl:choose>
													</a>
												</span>
												<xsl:for-each select="current-group()/ancestor::node()[tei:locus]/tei:locus[1]">
													<xsl:text> </xsl:text>
													<xsl:apply-templates select="self::node()">
														<xsl:with-param name="index">yes</xsl:with-param>
													</xsl:apply-templates>
													<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
												</xsl:for-each>
												<xsl:if test="not(position() = last())"><xsl:text>;</xsl:text></xsl:if>
											</xsl:for-each-group>
										</li>
									</xsl:for-each-group>
								</ul>
							</li>
						</xsl:for-each-group>
					</ul>
				</li>
			</xsl:if>
			<xsl:for-each-group select="descendant::tei:rs[(@type='person') or (@type='place') or (@type='org') or (@type='corporate') or (@type='object')][ancestor::tei:msDesc] 
				| descendant::tei:persName[not(ancestor::tei:adminInfo)][ancestor::tei:msDesc] 
				| descendant::tei:placeName[ancestor::tei:msDesc]" group-by=" if (@ref) then @ref else normalize-space(.)">
				<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="current-grouping-key()"/>
				<li>
					<xsl:choose>
						<xsl:when test="starts-with(current-grouping-key(), 'http://')">
							<xsl:value-of select="."/>
						</xsl:when>
						<xsl:when test="starts-with(current-grouping-key(), '#') and //@xml:id[.=substring(current-grouping-key(),2)]">
							<xsl:apply-templates select="//*[@xml:id[.=substring(current-grouping-key(),2)]]" mode="Register"/>
						</xsl:when>
						<xsl:when test="starts-with(current-grouping-key(), '#') and doc($listPerson)//tei:person[@xml:id[.=substring(current-grouping-key(),2)]]">
							<xsl:apply-templates select="//*[@ref=current-grouping-key()]" mode="Register"/>
						</xsl:when>
						<xsl:when test="starts-with(current-grouping-key(), '#') and doc($listPlace)//tei:place[@xml:id[.=substring(current-grouping-key(),2)]]">
							<xsl:apply-templates select="//*[@ref=current-grouping-key()]" mode="Register"/>
						</xsl:when>
						<xsl:when test="starts-with(current-grouping-key(), '#') and doc($listOrg)//tei:org[@xml:id[.=substring(current-grouping-key(),2)]]">
							<xsl:apply-templates select="//*[@ref=current-grouping-key()]" mode="Register"/>
						</xsl:when>
						<xsl:when test="contains(current-grouping-key(), '_') and contains(current-grouping-key(), '#')">
							<xsl:text>_keine Normdaten vorhanden: </xsl:text>
							<xsl:value-of select="translate(current-grouping-key(), '_#', ' ')"/>
						</xsl:when>
						<xsl:when test="contains(current-grouping-key(), '_')">
							<xsl:value-of select="translate(current-grouping-key(), '_', ' ')"/>
						</xsl:when>
						<xsl:when test="contains(current-grouping-key(), '#')">
							<xsl:value-of select="translate(current-grouping-key(), '#', '')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="current-grouping-key()"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:for-each-group select="current-group()" group-by="ancestor::tei:msDesc/@xml:id">
						<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="current-grouping-key()"/>
						<xsl:text> </xsl:text>
						<span>
							<xsl:attribute name="class">idno</xsl:attribute>
                            <a href="#{current-grouping-key()}">
								<xsl:choose>
									<xsl:when test="contains(current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno, $ignoreInIdno)">
										<xsl:value-of select="substring-after(current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno, $ignoreInIdno)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno"/>
									</xsl:otherwise>
								</xsl:choose>
							</a>
						</span>
						<xsl:for-each select="current-group()[ancestor::tei:msItem]/preceding::tei:locus[ancestor::tei:msItem = current()/ancestor::tei:msItem][1]">
							<xsl:text> </xsl:text>
							<xsl:apply-templates select="self::node()">
								<xsl:with-param name="index">yes</xsl:with-param>
							</xsl:apply-templates>
							<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
						</xsl:for-each>
						<xsl:if test="not(position() = last())"><xsl:text>;</xsl:text></xsl:if>
					</xsl:for-each-group>
				</li>
			</xsl:for-each-group>
			<xsl:if test="descendant::tei:ref[(@type='mss') or (@type='altMs')] or descendant::tei:msIdentifier[parent::tei:bibl]">
				<li>Handschriften, erwähnte
					<xsl:choose>
						<xsl:when test="$listMssSeperately = 'yes' "><xsl:text> siehe separates Register</xsl:text></xsl:when>
						<xsl:otherwise><xsl:call-template name="HandschriftenErwaehnteAusgeben"/></xsl:otherwise>
					</xsl:choose>
				</li>
			</xsl:if>
			<xsl:if test="descendant::tei:handNote[@scribe]">
				<li>Schreiber
					<ul>
						<xsl:for-each-group select="//tei:handNote[@scribe]" group-by="@scribe">
							<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="@scribe"/>
							<li>
								<xsl:choose>
									<xsl:when test="contains(current-grouping-key(), '_')">
										<xsl:value-of select="translate(current-grouping-key(), '_', ' ')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="current-grouping-key()"/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:for-each-group select="current-group()" group-by="ancestor::tei:msDesc/@xml:id">
									<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="current-grouping-key()"/>
									<xsl:text> </xsl:text>
									<span>
										<xsl:attribute name="class">idno</xsl:attribute>
                                        <a href="#{current-grouping-key()}">
											<xsl:choose>
												<xsl:when test="contains(current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno, $ignoreInIdno)">
													<xsl:value-of select="substring-after(current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno, $ignoreInIdno)"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno"/>
												</xsl:otherwise>
											</xsl:choose>
										</a>
									</span>
									<!-\-
										<xsl:for-each select="current-group()/ancestor::node()[tei:locus]/tei:locus[1]">
										<xsl:text> </xsl:text>
										<xsl:apply-templates select="self::node()">
										<xsl:with-param name="index">yes</xsl:with-param>
										</xsl:apply-templates>
										<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
										</xsl:for-each>
									-\->
									<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
								</xsl:for-each-group>
							</li>
						</xsl:for-each-group>
					</ul>
				</li>
			</xsl:if>
			<li>Datierung der Handschriften
				<xsl:if test="descendant::tei:origDate[parent::tei:head/parent::tei:msDesc or parent::tei:head/parent::tei:msPart][(@notBefore = @notAfter) or (@notBefore and not(@notAfter))]">
					<ul>
						<li>Datierte Handschriften
							<ul>
								<xsl:for-each-group select="//tei:origDate[parent::tei:head/parent::tei:msDesc or parent::tei:head/parent::tei:msPart][@when or (@notBefore = @notAfter) or (@notBefore and not(@notAfter))]" group-by=".">
									<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="current-grouping-key()"/>
									<li>
										<xsl:value-of select="current-grouping-key()"/>
										<xsl:for-each-group select="current-group()" group-by="ancestor::tei:msDesc/@xml:id">
											<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="current-grouping-key()"/>
											<xsl:text> </xsl:text>
											<span>
												<xsl:attribute name="class">idno</xsl:attribute>
                                                <a href="#{current-grouping-key()}">
													<xsl:choose>
														<xsl:when test="contains(current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno, $ignoreInIdno)">
															<xsl:value-of select="substring-after(current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno, $ignoreInIdno)"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno"/>
														</xsl:otherwise>
													</xsl:choose>
												</a>
											</span>
											<xsl:if test="not(position() = last())"><xsl:text>;</xsl:text></xsl:if>
										</xsl:for-each-group>
									</li>
								</xsl:for-each-group>
							</ul>
						</li>
					</ul>
				</xsl:if>
				<xsl:if test="descendant::tei:origDate[parent::tei:head/parent::tei:msDesc or parent::tei:head/parent::tei:msPart][@notBefore != @notAfter]">
					<ul>
						<li>Zeiträume
							<ul>
								<xsl:for-each-group select="//tei:origDate[parent::tei:head/parent::tei:msDesc or parent::tei:head/parent::tei:msPart][@notBefore != @notAfter]" group-by=".">
									<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="@notBefore"/>
									<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="@notAfter"/>
									<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="current-grouping-key()"/>
									<li>
										<xsl:value-of select="current-grouping-key()"/>
										<xsl:for-each-group select="current-group()" group-by="ancestor::tei:msDesc/@xml:id">
											<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="current-grouping-key()"/>
											<xsl:text> </xsl:text>
											<span>
												<xsl:attribute name="class">idno</xsl:attribute>
                                                <a href="#{current-grouping-key()}">
													<xsl:choose>
														<xsl:when test="contains(current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno, $ignoreInIdno)">
															<xsl:value-of select="substring-after(current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno, $ignoreInIdno)"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno"/>
														</xsl:otherwise>
													</xsl:choose>
												</a>
											</span>
											<xsl:if test="not(position() = last())"><xsl:text>;</xsl:text></xsl:if>
										</xsl:for-each-group>
									</li>
								</xsl:for-each-group>
							</ul>
						</li>
					</ul>
				</xsl:if>
			</li>
			<xsl:if test="descendant::tei:colophon and not(descendant::tei:term[.='Kolophon'])">
				<li>Kolophon
					<xsl:for-each select="descendant::tei:colophon">
						<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="ancestor::tei:msDesc/@xml:id"/>
						<span>
							<xsl:attribute name="class">idno</xsl:attribute>
                            <a href="#{ancestor::tei:msDesc/@xml:id}">
								<xsl:choose>
									<xsl:when test="contains(ancestor::tei:msDesc/tei:msIdentifier/tei:idno, $ignoreInIdno)">
										<xsl:value-of select="substring-after(ancestor::tei:msDesc/tei:msIdentifier/tei:idno, $ignoreInIdno)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="ancestor::tei:msDesc/tei:msIdentifier/tei:idno"/>
									</xsl:otherwise>
								</xsl:choose>
							</a>
							</span>
					<xsl:for-each select="preceding::tei:locus[1]">
							<xsl:text> </xsl:text>
							<xsl:apply-templates select="self::node()">
								<xsl:with-param name="index">yes</xsl:with-param>
							</xsl:apply-templates>
							<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
						</xsl:for-each>
					</xsl:for-each>
				</li>
			</xsl:if>
			<xsl:if test="descendant::tei:head/tei:title[contains(., 'Palimpsest')]">
				<li>Palimpsest
					<ul>
						<xsl:for-each select="descendant::tei:head/tei:title[contains(., 'Palimpsest')]">
							<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="ancestor::tei:msDesc/@xml:id"/>
							<li>
								<span>
									<xsl:attribute name="class">idno</xsl:attribute>
                                    <a href="#{ancestor::tei:msDesc/@xml:id}">
										<xsl:choose>
											<xsl:when test="contains(ancestor::tei:msDesc/tei:msIdentifier/tei:idno, $ignoreInIdno)">
												<xsl:value-of select="substring-after(ancestor::tei:msDesc/tei:msIdentifier/tei:idno, $ignoreInIdno)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="ancestor::tei:msDesc/tei:msIdentifier/tei:idno"/>
											</xsl:otherwise>
										</xsl:choose>
									</a>
								</span>
								<xsl:for-each select="preceding::tei:locus[1]">
									<xsl:text> </xsl:text>
									<xsl:apply-templates select="self::node()">
										<xsl:with-param name="index">yes</xsl:with-param>
									</xsl:apply-templates>
									<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
								</xsl:for-each>
							</li>
						</xsl:for-each>
					</ul>
				</li>
			</xsl:if>

<xsl:if test="descendant::tei:accMat[not(descendant::tei:term[contains(., 'Fragment')])] 
					   or descendant::tei:msPart[contains(tei:msIdentifier/tei:idno, 'Fragment')][not(descendant::tei:term[contains(., 'Fragment')])]">
				<li>Fragmente
					<ul>
						<xsl:for-each-group select="descendant::tei:accMat[not(descendant::tei:term[contains(., 'Fragment')])]" group-by="tei:title">
							<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="ancestor::tei:msDesc/@xml:id"/>
							<li>
								<xsl:text> </xsl:text>
								<span>
									<xsl:attribute name="class">idno</xsl:attribute>
                                    <a href="#{current-grouping-key()}">
										<xsl:choose>
											<xsl:when test="contains(current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno, $ignoreInIdno)">
												<xsl:value-of select="substring-after(current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno, $ignoreInIdno)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="current-group()/ancestor::tei:msDesc/tei:msIdentifier/tei:idno"/>
											</xsl:otherwise>
										</xsl:choose>
									</a>
								</span>
								<xsl:for-each select="current-group()/preceding::tei:locus[1]">
									<xsl:text> </xsl:text>
									<xsl:apply-templates select="self::node()">
										<xsl:with-param name="index">yes</xsl:with-param>
									</xsl:apply-templates>
									<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
								</xsl:for-each>
								<xsl:if test="not(position() = last())"><xsl:text>;</xsl:text></xsl:if>
							</li>
						</xsl:for-each-group>
					</ul>
				</li>
			</xsl:if>

<!-\- 
	<xsl:if test="//tei:term[not(parent::tei:index)][(@type = 'script') or parent::tei:handNote]">
	<li>
	<xsl:text>Schriftarten, besondere</xsl:text>
	<ul>
	<xsl:apply-templates select="//tei:term[not(parent::tei:index)][(@type = 'script') or parent::tei:handNote]" mode="Register">
	<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="current-grouping-key()"/>
	</xsl:apply-templates>
	</ul>
	</li>
	</xsl:if>
-\->

		</xsl:variable>
		<xsl:for-each select="$temporäresRegister/li[not(.=preceding-sibling::li)]">
			<xsl:sort lang="de" collation="http://saxon.sf.net/collation?lang=de;alphanumeric=yes" select="normalize-space(.)"/>
			<xsl:copy-of select="."/>
		</xsl:for-each>
	</ul>
	
	
	<xsl:if test="$listMssSeperately = 'yes' ">
		<hr/>
		<p>
			<xsl:attribute name="class">head</xsl:attribute>
			<xsl:text>Handschriften, erwähnte</xsl:text>
		</p>
		<xsl:call-template name="HandschriftenErwaehnteAusgeben"/>
	</xsl:if>
	
	

	
</xsl:template>-->

<xsl:template name="Satzzeichen">

	<xsl:if test="
		not(descendant::tei:gap[not(following-sibling::text())]) and
		not(descendant-or-self::node()[@rend = 'dottedEnd']) and
		not(descendant-or-self::node()[(@type='recipe') or (@type='sermon')]) and
		not(ends-with(normalize-space(.), ',')) and
		not(ends-with(normalize-space(.), ';')) and
		not(ends-with(normalize-space(.), '.')) and
		not(ends-with(normalize-space(.), ':')) and
		not(ends-with(normalize-space(.), '!')) and
		not(starts-with(substring-after(.., normalize-space(.)), ',')) and
		(self::tei:msItem and (not(parent::tei:msItem)) or not(ends-with(normalize-space(parent::*), normalize-space(.)))) and
		not(parent::tei:abbr) and not(parent::tei:ptr) and not(parent::tei:ref) and
		not(parent::tei:rubric) and not(parent::tei:incipit) and not(parent::tei:quote) and not(parent::tei:explicit) and not(parent::tei:finalRubric) and not(parent::tei:colophon) and
		not(parent::tei:title) and not(parent::tei:note) and not(parent::tei:item)">
		
		<!--<xsl:choose>
			<xsl:when test="self::tei:item"><xsl:text>,</xsl:text></xsl:when>
			<xsl:otherwise><xsl:text>.</xsl:text></xsl:otherwise>
		</xsl:choose>-->
	</xsl:if>
	<xsl:call-template name="Leerzeichen"/>
</xsl:template>

<xsl:template name="source">
	<div id="{generate-id()}">
		<xsl:attribute name="class">source</xsl:attribute>
		<xsl:value-of select="descendant::tei:source/tei:bibl"></xsl:value-of>
	</div>
</xsl:template>



<xsl:template match="tei:back | tei:body | tei:index | tei:publicationStmt | tei:text | tei:titleStmt"/>
<xsl:template match="tei:settlement[. = $ignoreInSettlement] | 
	tei:institution[. = $ignoreInInstitution] | 
	tei:repository[. = $ignoreInRepository] | 
	tei:collection[. = $ignoreInCollection]" mode="Schlagzeile"/>
<xsl:template match="tei:settlement[not(. = $ignoreInSettlement)] | 
	tei:institution[not(. = $ignoreInInstitution)] | 
	tei:repository[not(. = $ignoreInRepository)] | 
	tei:collection[not(. = $ignoreInCollection)]" mode="Schlagzeile">
	<xsl:if test="parent::tei:altIdentifier and not(. = ancestor::tei:msIdentifier/node()[name() = current()/name()])">
		<xsl:value-of select="."/>
		<xsl:if test="preceding-sibling::tei:settlement 
			or preceding-sibling::tei:institution 
			or preceding-sibling::tei:repository"><xsl:text>, </xsl:text></xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="tei:msContents | tei:msIdentifier | tei:reg">
	<xsl:apply-templates/>
</xsl:template>
	
	<!-- from msDesc consolidated These next templates act on HTML already generated from the source TEI, as a post-processing phase to strip out 
         empty elements. These can confuse web browsers (whose parsers assume that, for example, an empty div element
         was someone's handcoded mistake and ignores the closing div tag) causing display issues especially in IE/Edge -->
	
	<xsl:template match="*" mode="stripoutempty">
		<xsl:if test="child::* or text() or processing-instruction() or local-name() = ('img', 'br', 'hr', 'title')">
			<xsl:copy>
				<xsl:copy-of select="@*"/>
				<xsl:apply-templates mode="stripoutempty"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>
	<xsl:template match="text()|processing-instruction()|comment()" mode="stripoutempty"><xsl:copy/></xsl:template>

</xsl:stylesheet>

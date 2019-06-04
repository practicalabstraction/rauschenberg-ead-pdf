<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:ns2="http://www.w3.org/1999/xlink" xmlns:local="http://www.yoursite.org/namespace"
                xmlns:ead="urn:isbn:1-931666-22-9" xmlns:fo="http://www.w3.org/1999/XSL/Format" version="2.0"  exclude-result-prefixes="#all">
  <xsl:output method="xml" encoding="utf-8" indent="yes"/>

  <!-- Calls a stylesheet with local functions and lookup lists for languages and subject authorities -->
  <xsl:include href="as-helper-functions.xsl"/>

  <xsl:strip-space elements="*"/>

  <!-- The following attribute sets are reusable styles used throughout the stylesheet. -->
  <!-- Headings -->
  <xsl:attribute-set name="h1">
    <xsl:attribute name="font-size">22pt
    </xsl:attribute>
    <xsl:attribute name="font-weight">bold
    </xsl:attribute>
    <xsl:attribute name="margin-top">16pt
    </xsl:attribute>
    <xsl:attribute name="margin-bottom">8pt
    </xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="h2">
    <xsl:attribute name="font-size">16pt
    </xsl:attribute>
    <xsl:attribute name="font-weight">700</xsl:attribute>
    <xsl:attribute name="margin-bottom">12pt
    </xsl:attribute>
    <xsl:attribute name="margin-top">4pt
    </xsl:attribute>
    <xsl:attribute name="padding-top">8pt
    </xsl:attribute>
    <xsl:attribute name="padding-bottom">8pt
    </xsl:attribute>
    <xsl:attribute name="keep-with-next.within-page">always
    </xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="h3">
    <xsl:attribute name="font-size">14pt
    </xsl:attribute>
    <xsl:attribute name="font-weight">bold
    </xsl:attribute>
    <xsl:attribute name="margin-bottom">4pt
    </xsl:attribute>
    <xsl:attribute name="padding-bottom">0
    </xsl:attribute>
    <xsl:attribute name="keep-with-next.within-page">always
    </xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="h4">
    <xsl:attribute name="font-size">12pt
    </xsl:attribute>
    <xsl:attribute name="font-weight">bold
    </xsl:attribute>
    <xsl:attribute name="margin-bottom">4pt
    </xsl:attribute>
    <xsl:attribute name="padding-bottom">0
    </xsl:attribute>
    <xsl:attribute name="keep-with-next.within-page">always
    </xsl:attribute>
  </xsl:attribute-set>

  <!-- Headings with id attribute -->
  <xsl:attribute-set name="h1ID" use-attribute-sets="h1">
    <xsl:attribute name="id">
      <xsl:value-of select="local:buildID(.)"/>
    </xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="h2ID" use-attribute-sets="h2">
    <xsl:attribute name="id">
      <xsl:value-of select="local:buildID(.)"/>
    </xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="h3ID" use-attribute-sets="h3">
    <xsl:attribute name="id">
      <xsl:value-of select="local:buildID(.)"/>
    </xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="h4ID" use-attribute-sets="h4">
    <xsl:attribute name="id">
      <xsl:value-of select="local:buildID(.)"/>
    </xsl:attribute>
  </xsl:attribute-set>

  <!-- Linking attributes styles -->
  <xsl:attribute-set name="ref">
    <xsl:attribute name="color">#0D6CB6
    </xsl:attribute>
    <xsl:attribute name="text-decoration">underline
    </xsl:attribute>
  </xsl:attribute-set>

  <!-- Standard margin and padding for most fo:block elements, including paragraphs -->
  <xsl:attribute-set name="smp">
    <xsl:attribute name="margin">4pt</xsl:attribute>
    <xsl:attribute name="padding">4pt</xsl:attribute>
  </xsl:attribute-set>

  <!-- Standard margin and padding for elements with in the dsc table -->
  <xsl:attribute-set name="smpDsc">
    <xsl:attribute name="margin">2pt</xsl:attribute>
    <xsl:attribute name="padding">2pt</xsl:attribute>
  </xsl:attribute-set>

  <!-- Styles for main sections -->
  <xsl:attribute-set name="section">
    <xsl:attribute name="margin">4pt</xsl:attribute>
    <xsl:attribute name="padding">4pt</xsl:attribute>
  </xsl:attribute-set>

  <!-- Table attributes for tables with borders -->
  <xsl:attribute-set name="tableBorder">
    <xsl:attribute name="table-layout">fixed
    </xsl:attribute>
    <xsl:attribute name="width">100%
    </xsl:attribute>
    <xsl:attribute name="border">.5pt solid #ccc
    </xsl:attribute>
    <xsl:attribute name="border-collapse">separate
    </xsl:attribute>
    <xsl:attribute name="space-after">12pt
    </xsl:attribute>
  </xsl:attribute-set>
  <!-- Table headings -->
  <xsl:attribute-set name="th">
    <xsl:attribute name="background-color">#ccc
    </xsl:attribute>
    <xsl:attribute name="font-weight">bold
    </xsl:attribute>
    <xsl:attribute name="text-align">left
    </xsl:attribute>
  </xsl:attribute-set>
  <!-- Table cells with borders -->
  <xsl:attribute-set name="tdBorder">
    <xsl:attribute name="border">.5pt solid #ccc
    </xsl:attribute>
    <xsl:attribute name="border-collapse">separate
    </xsl:attribute>
  </xsl:attribute-set>

  <!--  Start main page design and layout -->
  <xsl:template match="/">
    <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" font-size="11pt" font-family="Verdana, sans-serif">
      <!-- Set up page types and page layouts -->
      <fo:layout-master-set>
        <!-- Page master for Finding Aid Contents -->
        <fo:simple-page-master master-name="contents" page-width="8.5in" page-height="11in" margin="0.5in">
          <fo:region-body margin-top="0.25in" margin-bottom="0.25in"/>
          <fo:region-before extent="0.5in"/>
          <fo:region-after extent="0.2in"/>
        </fo:simple-page-master>
      </fo:layout-master-set>
      <!-- Builds PDF bookmarks for all major sections  -->
      <xsl:apply-templates select="/ead:ead/ead:archdesc" mode="bookmarks"/>
      <!-- The fo:page-sequence establishes headers, footers and the body of the page.-->

      <!-- All the rest -->
      <fo:page-sequence master-reference="contents">
        <!-- Page footer-->
        <fo:static-content flow-name="xsl-region-after">
          <fo:block text-align="right" font-size="10pt">
            <xsl:text>Page
            </xsl:text>
            <fo:page-number/>
            <xsl:text>
            </xsl:text>
          </fo:block>
        </fo:static-content>
        <!-- Content of page -->
        <fo:flow flow-name="xsl-region-body">
          <xsl:apply-templates select="/ead:ead/ead:eadheader/ead:filedesc/ead:titlestmt" mode="summary"/>
          <xsl:apply-templates select="/ead:ead/ead:archdesc"/>
        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>

  <xsl:template match="ead:titleproper">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="ead:titleproper/ead:num">
  </xsl:template>
  <!-- Cover page templates -->
  <!-- Builds title -->
  <xsl:template match="ead:titlestmt" mode="pageHeader">
    <!-- Uses filing type title if present -->
    <xsl:choose>
      <xsl:when test="ead:titleproper[@type='filing']">
        <xsl:apply-templates select="ead:titleproper[@type='filing']"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="ead:titleproper[1]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="ead:titlestmt" mode="summary">
    <fo:table table-layout="fixed" width="100%">
      <fo:table-column column-width="50%" />
      <fo:table-column column-width="50%" />
      <fo:table-body>
        <fo:table-row>
          <fo:table-cell>
            <fo:block text-align="left">
              <fo:external-graphic src="RRF_logo_RGB.jpg" content-width="3.0in"/>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell text-align="right" vertical-align="middle">
            <fo:block text-align="right" font-size="8" font-weight="bold" color="#ccc" break-before="column" margin-left="1.5in" margin-top="0.5in" width="100%" vertical-align="middle" height="100%">
              <fo:block text-align="left" padding-top="10pt">
                Robert Rauschenberg Foundation
              </fo:block>
              <fo:block text-align="left">
                381 Lafayette Street
              </fo:block>
              <fo:block text-align="left">
                New York, New York 10003
              </fo:block>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>

    <fo:block xsl:use-attribute-sets="h1" text-align="center" margin-left="1in" margin-right="1in">
      <xsl:choose>
        <xsl:when test="ead:titleproper[@type='filing']">
          <xsl:apply-templates select="ead:titleproper[@type='filing']"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="ead:titleproper[1]"/>
        </xsl:otherwise>
      </xsl:choose>
    </fo:block>
    <xsl:if test="ead:subtitle">
      <fo:block font-size="16" font-weight="bold">
        <xsl:apply-templates select="ead:subtitle"/>
      </fo:block>
    </xsl:if>

  </xsl:template>
  <xsl:template match="ead:publicationstmt" mode="summary">
    <fo:block margin="0 1in">
      <fo:block>
        <xsl:apply-templates select="ead:publisher"/>
        <xsl:if test="ead:date">&#160;
        <xsl:apply-templates select="ead:date"/>
        </xsl:if>
      </fo:block>
      <xsl:apply-templates select="ead:address"/>
    </fo:block>
  </xsl:template>
  <xsl:template match="ead:profiledesc/child::*">
    <fo:block>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <xsl:template match="ead:profiledesc/ead:language">
    <xsl:value-of select="."/>
  </xsl:template>
  <xsl:template match="ead:profiledesc/ead:creation/ead:date">
    <!--
        Uses local function to format date into Month, day year.
        To print date as seen in xml change to select="."
    -->
    <xsl:apply-templates select="local:parseDate(.)"/>
  </xsl:template>
  <!--
      This template can be modified to include repository specific icons,
      use the template as an example. PDF exports only support this single
      icon template for an image in this directory specified by filename
      i.e. src="myicon.png"
  -->
  <xsl:template name="icon">
    <fo:block text-align="left" margin-left="-.75in" margin-top="-.5in">
      <fo:external-graphic src="RRF_logo_RGB.jpg" content-height="75%" content-width="75%"/>
    </fo:block>
  </xsl:template>

  <!-- Generates PDF Bookmarks -->
  <xsl:template match="ead:archdesc" mode="bookmarks">
    <fo:bookmark-tree>
      <xsl:if test="ead:did">
        <fo:bookmark internal-destination="{local:buildID(ead:did)}">
          <fo:bookmark-title>
            <xsl:value-of select="local:tagName(ead:did)"/>
          </fo:bookmark-title>
        </fo:bookmark>
      </xsl:if>
      <xsl:if test="ead:bioghist">
        <fo:bookmark internal-destination="{local:buildID(ead:bioghist[1])}">
          <fo:bookmark-title>
            <xsl:value-of select="local:tagName(ead:bioghist[1])"/>
          </fo:bookmark-title>
        </fo:bookmark>
      </xsl:if>
      <xsl:if test="ead:scopecontent">
        <fo:bookmark internal-destination="{local:buildID(ead:scopecontent[1])}">
          <fo:bookmark-title>
            <xsl:value-of select="local:tagName(ead:scopecontent[1])"/>
          </fo:bookmark-title>
        </fo:bookmark>
      </xsl:if>
      <xsl:if test="ead:arrangement">
        <fo:bookmark internal-destination="{local:buildID(ead:arrangement[1])}">
          <fo:bookmark-title>
            <xsl:value-of select="local:tagName(ead:arrangement[1])"/>
          </fo:bookmark-title>
        </fo:bookmark>
      </xsl:if>
      <xsl:if test="ead:fileplan">
        <fo:bookmark internal-destination="{local:buildID(ead:fileplan[1])}">
          <fo:bookmark-title>
            <xsl:value-of select="local:tagName(ead:fileplan[1])"/>
          </fo:bookmark-title>
        </fo:bookmark>
      </xsl:if>

      <!-- Administrative Information  -->
      <xsl:if test="ead:accessrestrict or ead:userestrict or
                    ead:custodhist or ead:accruals or ead:altformavail or ead:acqinfo or
                    ead:processinfo or ead:appraisal or ead:originalsloc or
                    /ead:ead/ead:eadheader/ead:filedesc/ead:publicationstmt or /ead:ead/ead:eadheader/ead:revisiondesc">
                    <fo:bookmark internal-destination="adminInfo">
                      <fo:bookmark-title>Administrative Information
                      </fo:bookmark-title>
                    </fo:bookmark>
      </xsl:if>

      <!-- Related Materials -->
      <xsl:if test="ead:relatedmaterial or ead:separatedmaterial">
        <fo:bookmark internal-destination="relMat">
          <fo:bookmark-title>Related Materials
          </fo:bookmark-title>
        </fo:bookmark>
      </xsl:if>

      <xsl:if test="ead:controlaccess">
        <fo:bookmark internal-destination="{local:buildID(ead:controlaccess[1])}">
          <fo:bookmark-title>
            <xsl:value-of select="local:tagName(ead:controlaccess[1])"/>
          </fo:bookmark-title>
        </fo:bookmark>
      </xsl:if>
      <xsl:if test="ead:otherfindaid">
        <fo:bookmark internal-destination="{local:buildID(ead:otherfindaid[1])}">
          <fo:bookmark-title>
            <xsl:value-of select="local:tagName(ead:otherfindaid[1])"/>
          </fo:bookmark-title>
        </fo:bookmark>
      </xsl:if>
      <xsl:if test="ead:phystech">
        <fo:bookmark internal-destination="{local:buildID(ead:phystech[1])}">
          <fo:bookmark-title>
            <xsl:value-of select="local:tagName(ead:phystech[1])"/>
          </fo:bookmark-title>
        </fo:bookmark>
      </xsl:if>
      <xsl:if test="ead:odd">
        <fo:bookmark internal-destination="{local:buildID(ead:odd[1])}">
          <fo:bookmark-title>
            <xsl:value-of select="local:tagName(ead:odd[1])"/>
          </fo:bookmark-title>
        </fo:bookmark>
      </xsl:if>
      <xsl:if test="ead:bibliography">
        <fo:bookmark internal-destination="{local:buildID(ead:bibliography[1])}">
          <fo:bookmark-title>
            <xsl:value-of select="local:tagName(ead:bibliography[1])"/>
          </fo:bookmark-title>
        </fo:bookmark>
      </xsl:if>
      <xsl:if test="ead:index">
        <fo:bookmark internal-destination="{local:buildID(ead:index[1])}">
          <fo:bookmark-title>
            <xsl:value-of select="local:tagName(ead:index[1])"/>
          </fo:bookmark-title>
        </fo:bookmark>
      </xsl:if>

      <!-- Build Container List menu and submenu -->
      <xsl:for-each select="ead:dsc">
        <xsl:if test="child::*">
          <fo:bookmark internal-destination="{local:buildID(.)}">
            <fo:bookmark-title>
              <xsl:value-of select="local:tagName(.)"/>
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:if>
        <!--Creates a submenu for collections, record groups and series and fonds-->
        <xsl:for-each select="child::*[@level = 'collection']  | child::*[@level = 'recordgrp']  | child::*[@level = 'series'] | child::*[@level = 'fonds']">
          <fo:bookmark internal-destination="{local:buildID(.)}">
            <fo:bookmark-title>
              <xsl:choose>
                <xsl:when test="ead:head">
                  <xsl:apply-templates select="child::*/ead:head"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="ead:did/ead:unittitle"/>
                </xsl:otherwise>
              </xsl:choose>
            </fo:bookmark-title>
          </fo:bookmark>
          <!-- Creates a submenu for subfonds, subgrp or subseries -->
          <xsl:for-each select="child::*[@level = 'subfonds'] | child::*[@level = 'subgrp']  | child::*[@level = 'subseries']">
            <fo:bookmark internal-destination="{local:buildID(.)}">
              <fo:bookmark-title>
                <xsl:choose>
                  <xsl:when test="ead:head">
                    <xsl:apply-templates select="child::*/ead:head"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="ead:did/ead:unittitle"/>
                  </xsl:otherwise>
                </xsl:choose>
              </fo:bookmark-title>
            </fo:bookmark>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:for-each>
    </fo:bookmark-tree>
  </xsl:template>

  <!--
      Formats children of archdesc. This template orders the children of the archdesc,
      if order is changed it must also be changed in the table of contents.
  -->
  <xsl:template match="ead:archdesc">
    <xsl:apply-templates select="ead:did"/>
    <xsl:if test="ead:accessrestrict or ead:userestrict or
                  ead:custodhist or ead:accruals or ead:altformavail or ead:acqinfo or
                  ead:processinfo or ead:appraisal or ead:originalsloc or
                  /ead:ead/ead:eadheader/ead:filedesc/ead:publicationstmt or /ead:ead/ead:eadheader/ead:revisiondesc">
                  <xsl:apply-templates select="." mode="admin-info" />
    </xsl:if>
    <xsl:apply-templates select="ead:bioghist"/>
    <xsl:apply-templates select="ead:scopecontent"/>
    <xsl:apply-templates select="ead:arrangement"/>
    <xsl:apply-templates select="ead:controlaccess"/>
    <xsl:apply-templates select="ead:dsc"/>
  </xsl:template>

  <!-- Administrative Information  -->
  <xsl:template match="ead:archdesc" mode="admin-info">
    <fo:block xsl:use-attribute-sets="section">
      <fo:block xsl:use-attribute-sets="h2" id="adminInfo">Administrative Information
      </fo:block>
      <fo:table table-layout="fixed" width="100%">
        <fo:table-column column-width="2in"/>
        <fo:table-column column-width="5in"/>
        <fo:table-body>
          <xsl:apply-templates select="ead:acqinfo" mode="overview"/>
          <xsl:apply-templates select="ead:langmaterial" mode="overview"/>
          <xsl:apply-templates select="ead:accessrestrict" mode="overview"/>
          <xsl:apply-templates select="ead:userestrict" mode="overview"/>
          <xsl:apply-templates select="ead:phystech" mode="overview"/>
          <xsl:apply-templates select="ead:prefercite" mode="overview"/>
          <xsl:apply-templates select="ead:processinfo" mode="overview"/>
          <xsl:apply-templates select="ead:revisiondesc" mode="overview"/>
        </fo:table-body>
      </fo:table>
    </fo:block>
  </xsl:template>

  <!-- Formats archdesc did -->
  <xsl:template match="ead:archdesc/ead:did">
    <fo:block xsl:use-attribute-sets="section">
      <fo:block xsl:use-attribute-sets="h2ID">Summary
      </fo:block>
      <!--
          Determines the order in wich elements from the archdesc did appear,
          to change the order of appearance change the order of the following
          apply-template statements.
      -->

      <fo:table table-layout="fixed" width="100%">
        <fo:table-column column-width="2in"/>
        <fo:table-column column-width="5in"/>
        <fo:table-body>
          <!--
              <xsl:apply-templates select="ead:repository" mode="overview"/> -->
          <xsl:apply-templates select="ead:origination[@label='creator']" mode="overview"/>
          <xsl:apply-templates select="ead:unittitle" mode="overview"/>
          <xsl:apply-templates select="ead:unitid" mode="overview"/>
          <xsl:call-template name="unitdatesOverview" />
          <xsl:apply-templates select="ead:physdesc" mode="overview"/>
          <xsl:apply-templates select="ead:physloc" mode="overview"/>
          <xsl:apply-templates select="ead:abstract" mode="overview"/>
        </fo:table-body>
      </fo:table>
    </fo:block>
  </xsl:template>

  <!-- Formats children of arcdesc/did -->
  <xsl:template match="ead:repository | ead:origination | ead:unittitle | ead:unitdate | ead:unitid | ead:physdesc | ead:physloc | ead:dao | ead:daogrp | ead:langmaterial | ead:materialspec | ead:container | ead:acqinfo | ead:abstract | ead:note | ead:langmaterial | ead:accessrestrict | ead:userestrict | ead:phystech | ead:prefercite | ead:processinfo | ead:revisiondesc" mode="overview">
    <fo:table-row>
      <fo:table-cell padding-bottom="8pt" padding-right="16pt" text-align="left" font-weight="bold">
        <fo:block>
          <xsl:choose>
            <!-- Test for label attribute used by origination element -->
            <xsl:when test="@label">
              <xsl:value-of select="concat(upper-case(substring(@label,1,1)),substring(@label,2))">
              </xsl:value-of>
              <xsl:if test="@type"> [
              <xsl:value-of select="@type"/>]
              </xsl:if>
              <xsl:if test="self::ead:origination">
                <xsl:choose>
                  <xsl:when test="ead:persname[@role != ''] and contains(ead:persname/@role,' (')">
                    -
                    <xsl:value-of select="substring-before(ead:persname/@role,' (')"/>
                  </xsl:when>
                  <xsl:when test="ead:persname[@role != '']">
                    -
                    <xsl:value-of select="ead:persname/@role"/>
                  </xsl:when>
                  <xsl:otherwise/>
                </xsl:choose>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="name(.) = 'unitid'">
                  <xsl:text>Call Number
                  </xsl:text>
                </xsl:when>
                <xsl:when test="name(.) = 'physdesc'">
                  <xsl:text>Extent
                  </xsl:text>
                </xsl:when>
                <xsl:when test="name(.) = 'physloc'">
                  <xsl:text>Repository
                  </xsl:text>
                </xsl:when>
                <xsl:when test="name(.) = 'acqinfo'">
                  <xsl:text>Provenance
                  </xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="local:tagName(.)"/>
                </xsl:otherwise>
              </xsl:choose>
              <!-- Test for type attribute used by unitdate -->
              <xsl:if test="@type"> [
              <xsl:value-of select="@type"/>]
              </xsl:if>
            </xsl:otherwise>
            </xsl:choose>:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell padding-bottom="8pt">
        <xsl:choose>
          <xsl:when test="name(.) = 'processinfo'">
            <xsl:if test="string-length(//ead:titlestmt/ead:author)">
              <fo:block padding-bottom="2pt">
                Collection processed by
                <xsl:value-of select="//ead:titlestmt/ead:author"/>
                <xsl:if test="string-length(//ead:publicationstmt/ead:date)">
                  <xsl:text> in
                  </xsl:text>
                  <xsl:value-of select="//ead:publicationstmt/ead:date" />
                  </xsl:if>.
              </fo:block>
            </xsl:if>
            <fo:block>
              <xsl:apply-templates mode="overview"/>
            </fo:block>
          </xsl:when>
          <xsl:otherwise>
            <fo:block>
              <xsl:apply-templates mode="overview"/>
            </fo:block>
          </xsl:otherwise>
        </xsl:choose>
      </fo:table-cell>
    </fo:table-row>
  </xsl:template>
  <!-- Adds space between extents -->
  <xsl:template match="ead:extent">
    <xsl:apply-templates/>&#160;
  </xsl:template>

  <!-- Formats children of arcdesc not in administrative or related materials sections-->
  <xsl:template match="ead:bibliography | ead:odd | ead:phystech | ead:otherfindaid |
                       ead:bioghist | ead:scopecontent | ead:arrangement | ead:fileplan">
                       <fo:block xsl:use-attribute-sets="section">
                         <fo:block xsl:use-attribute-sets="h2ID">
                           <xsl:value-of select="local:tagName(.)"/>
                         </fo:block>
                         <xsl:apply-templates/>
                       </fo:block>
  </xsl:template>

  <!-- Formats children of arcdesc in administrative and related materials sections -->
  <xsl:template match="ead:relatedmaterial | ead:separatedmaterial | ead:accessrestrict | ead:userestrict |
                       ead:custodhist | ead:accruals | ead:altformavail |
                       ead:processinfo | ead:appraisal | ead:originalsloc">
                       <fo:block xsl:use-attribute-sets="section">
                         <fo:block xsl:use-attribute-sets="h3ID">
                           <xsl:value-of select="local:tagName(.)"/>
                         </fo:block>
                         <xsl:apply-templates/>
                       </fo:block>
  </xsl:template>

  <!-- Publication statement included in administrative information section -->
  <xsl:template match="ead:publicationstmt">
    <fo:block xsl:use-attribute-sets="section">
      <fo:block xsl:use-attribute-sets="h3">
        <xsl:value-of select="local:tagName(.)"/>
      </fo:block>
      <fo:block xsl:use-attribute-sets="smp">
        <xsl:apply-templates select="ead:publisher"/>
        <xsl:if test="ead:date">&#160;
        <xsl:apply-templates select="ead:date"/>
        </xsl:if>
      </fo:block>
      <xsl:apply-templates select="ead:address"/>
    </fo:block>
  </xsl:template>

  <!-- Formats Address elements -->
  <xsl:template match="ead:address">
    <fo:block xsl:use-attribute-sets="smp">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <xsl:template match="ead:addressline">
    <xsl:choose>
      <xsl:when test="contains(.,'@')">
        <fo:block>
          <fo:basic-link external-destination="url('mailto:{.}')" xsl:use-attribute-sets="ref">
            <xsl:value-of select="."/>
          </fo:basic-link>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Templates for revision description  -->
  <xsl:template match="ead:revisiondesc">
    <fo:block xsl:use-attribute-sets="section">
      <fo:block xsl:use-attribute-sets="h3ID">
        <xsl:value-of select="local:tagName(.)"/>
      </fo:block>
      <xsl:if test="ead:change/ead:item">
        <xsl:value-of select="ead:change/ead:item"/>
      </xsl:if>
      <xsl:if test="ead:change/ead:date">&#160;
      <xsl:value-of select="ead:change/ead:date"/>
      </xsl:if>
    </fo:block>
  </xsl:template>

  <!-- Formats controlled access terms -->
  <xsl:template match="ead:controlaccess">
    <fo:block xsl:use-attribute-sets="section">
      <fo:block xsl:use-attribute-sets="h2ID">Subjects
      </fo:block>
      <fo:block margin="4pt" padding="4pt">
        <xsl:apply-templates/>
      </fo:block>
    </fo:block>
  </xsl:template>
  <xsl:template match="ead:controlaccess/child::*">
    <fo:block>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <!-- Formats index and child elements, groups indexentry elements by type (i.e. corpname, subject...) -->
  <xsl:template match="ead:index">
    <fo:block xsl:use-attribute-sets="section">
      <fo:block xsl:use-attribute-sets="h2ID">
        <xsl:value-of select="local:tagName(.)"/>
      </fo:block>
      <xsl:apply-templates select="child::*[not(self::ead:indexentry)]"/>
      <fo:list-block xsl:use-attribute-sets="smp">
        <xsl:apply-templates select="ead:indexentry"/>
      </fo:list-block>
    </fo:block>
  </xsl:template>
  <xsl:template match="ead:indexentry">
    <fo:list-item>
      <fo:list-item-label  end-indent="label-end()">
        <fo:block>&#x2022;
        </fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block>
          <xsl:apply-templates/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <!-- Formats a simple table. The width of each column is defined by the colwidth attribute in a colspec element. -->
  <xsl:template match="ead:table">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="ead:table/ead:thead">
    <fo:block xsl:use-attribute-sets="h4ID">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <xsl:template match="ead:tgroup">
    <fo:table xsl:use-attribute-sets="tableBorder">
      <xsl:apply-templates/>
      <fo:table-body>
        <xsl:apply-templates select="*[not(ead:colspec)]"/>
      </fo:table-body>
    </fo:table>
  </xsl:template>
  <xsl:template match="ead:colspec">
    <fo:table-column column-width="{@colwidth}"/>
  </xsl:template>
  <xsl:template match="ead:thead">
    <xsl:apply-templates mode="thead"/>
  </xsl:template>
  <xsl:template match="ead:tbody">
    <fo:table-body>
      <xsl:apply-templates/>
    </fo:table-body>
  </xsl:template>
  <xsl:template match="ead:row" mode="thead">
    <fo:table-row xsl:use-attribute-sets="th">
      <xsl:apply-templates/>
    </fo:table-row>
  </xsl:template>
  <xsl:template match="ead:row">
    <fo:table-row>
      <xsl:apply-templates/>
    </fo:table-row>
  </xsl:template>
  <xsl:template match="ead:entry">
    <fo:table-cell xsl:use-attribute-sets="tdBorder">
      <fo:block xsl:use-attribute-sets="smp">
        <xsl:apply-templates/>
      </fo:block>
    </fo:table-cell>
  </xsl:template>

  <!--Bibref citation  inline, if there is a parent element.-->
  <xsl:template match="ead:p/ead:bibref">
    <xsl:choose>
      <xsl:when test="@*:href">
        <fo:basic-link external-destination="url('{@*:href}')" xsl:use-attribute-sets="ref">
          <xsl:apply-templates/>
        </fo:basic-link>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--Bibref citation on its own line, typically when it is a child of the bibliography element-->
  <xsl:template match="ead:bibref">
    <fo:block>
      <xsl:choose>
        <xsl:when test="@*:href">
          <fo:basic-link external-destination="url('{@*:href}')" xsl:use-attribute-sets="ref">
            <xsl:apply-templates/>
          </fo:basic-link>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </fo:block>
  </xsl:template>

  <!-- Lists -->
  <!-- Lists with listhead element are output as tables -->
  <xsl:template match="ead:list[ead:listhead]">
    <xsl:apply-templates select="ead:head"/>
    <fo:table xsl:use-attribute-sets="tableBorder">
      <fo:table-body>
        <fo:table-row xsl:use-attribute-sets="th">
          <fo:table-cell xsl:use-attribute-sets="tdBorder">
            <fo:block xsl:use-attribute-sets="smp">
              <xsl:value-of select="ead:listhead/ead:head01"/>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="tdBorder">
            <fo:block>
              <xsl:value-of select="ead:listhead/ead:head02"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
        <xsl:apply-templates select="ead:defitem" mode="listTable"/>
      </fo:table-body>
    </fo:table>
  </xsl:template>
  <!-- Formats ordered and definition lists -->
  <xsl:template match="ead:list">
    <xsl:apply-templates select="ead:head"/>
    <fo:list-block xsl:use-attribute-sets="smp">
      <xsl:choose>
        <xsl:when test="@type='deflist'">
          <xsl:apply-templates select="ead:defitem"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="ead:item"/>
        </xsl:otherwise>
      </xsl:choose>
    </fo:list-block>
  </xsl:template>
  <xsl:template match="ead:item">
    <fo:list-item>
      <fo:list-item-label  end-indent="label-end()">
        <fo:block>
          <xsl:choose>
            <xsl:when test="../@type='ordered' and ../@numeration = 'arabic'">
              <xsl:number format="1"/>
            </xsl:when>
            <xsl:when test="../@type='ordered' and ../@numeration = 'upperalpha'">
              <xsl:number format="A"/>
            </xsl:when>
            <xsl:when test="../@type='ordered' and ../@numeration = 'loweralpha'">
              <xsl:number format="a"/>
            </xsl:when>
            <xsl:when test="../@type='ordered' and ../@numeration = 'upperroman'">
              <xsl:number format="I"/>
            </xsl:when>
            <xsl:when test="../@type='ordered' and ../@numeration = 'upperalpha'">
              <xsl:number format="i"/>
            </xsl:when>
            <xsl:when test="../@type='ordered' and not(../@numeration)">
              <xsl:number format="1"/>
            </xsl:when>
            <xsl:otherwise>&#x2022;
            </xsl:otherwise>
          </xsl:choose>
        </fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block>
          <xsl:apply-templates/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>
  <xsl:template match="ead:defitem">
    <fo:list-item>
      <fo:list-item-label  end-indent="label-end()">
        <fo:block/>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block font-weight="bold">
          <xsl:apply-templates select="ead:label"/>
        </fo:block>
        <fo:block margin-left="18pt">
          <xsl:apply-templates select="ead:item" mode="deflist"/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <!-- Formats list as table if list has listhead element  -->
  <xsl:template match="ead:defitem" mode="listTable">
    <fo:table-row>
      <fo:table-cell xsl:use-attribute-sets="tdBorder">
        <fo:block xsl:use-attribute-sets="smp">
          <xsl:apply-templates select="ead:label"/>
        </fo:block>
      </fo:table-cell>
      <fo:table-cell xsl:use-attribute-sets="tdBorder">
        <fo:block xsl:use-attribute-sets="smp">
          <xsl:apply-templates select="ead:item"/>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
  </xsl:template>

  <!-- Output chronlist and children in a table -->
  <xsl:template match="ead:chronlist">
    <fo:table xsl:use-attribute-sets="tableBorder">
      <fo:table-body>
        <xsl:apply-templates/>
      </fo:table-body>
    </fo:table>
  </xsl:template>
  <xsl:template match="ead:chronlist/ead:listhead">
    <fo:table-row xsl:use-attribute-sets="th">
      <fo:table-cell xsl:use-attribute-sets="tdBorder">
        <fo:block xsl:use-attribute-sets="smp">
          <xsl:apply-templates select="ead:head01"/>
        </fo:block>
      </fo:table-cell>
      <fo:table-cell xsl:use-attribute-sets="tdBorder">
        <fo:block xsl:use-attribute-sets="smp">
          <xsl:apply-templates select="ead:head02"/>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
  </xsl:template>
  <xsl:template match="ead:chronlist/ead:head">
    <fo:table-row>
      <fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="th">
        <fo:block xsl:use-attribute-sets="smp">
          <xsl:apply-templates/>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
  </xsl:template>
  <xsl:template match="ead:chronitem">
    <fo:table-row>
      <!-- Adds alternating colors to table rows -->
      <xsl:attribute name="background-color">
        <xsl:choose>
          <xsl:when test="(position() mod 2 = 0)">#fff
          </xsl:when>
          <xsl:otherwise>#eee
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <fo:table-cell  xsl:use-attribute-sets="tdBorder">
        <fo:block xsl:use-attribute-sets="smp">
          <xsl:apply-templates select="ead:date"/>
        </fo:block>
      </fo:table-cell>
      <fo:table-cell  xsl:use-attribute-sets="tdBorder">
        <fo:block xsl:use-attribute-sets="smp">
          <xsl:apply-templates select="descendant::ead:event"/>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
  </xsl:template>
  <xsl:template match="ead:event">
    <xsl:choose>
      <xsl:when test="following-sibling::*">
        <fo:block>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Formats notestmt and notes -->
  <xsl:template match="ead:notestmt">
    <fo:block xsl:use-attribute-sets="section">
      <fo:block xsl:use-attribute-sets="h4ID">Note
      </fo:block>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <xsl:template match="ead:note">
    <xsl:choose>
      <xsl:when test="parent::ead:notestmt">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="@label">
            <fo:block xsl:use-attribute-sets="h4ID">
              <xsl:value-of select="@label"/>
            </fo:block>
            <xsl:apply-templates/>
          </xsl:when>
          <xsl:otherwise>
            <fo:block xsl:use-attribute-sets="h4ID">Note
            </fo:block>
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Formats legalstatus -->
  <xsl:template match="ead:legalstatus">
    <fo:block xsl:use-attribute-sets="smp">
      <fo:inline font-weight="bold">
        <xsl:value-of select="local:tagName(.)"/>:&#160;
      </fo:inline>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <!-- General headings -->
  <!-- Children of the archdesc are handled by the local:tagName function -->
  <xsl:template match="ead:head[parent::*/parent::ead:archdesc]"/>
  <!-- All other headings -->
  <xsl:template match="ead:head">
    <fo:block xsl:use-attribute-sets="h4" id="{local:buildID(parent::*)}">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <!-- Linking elmenets -->
  <xsl:template match="ead:ref">
    <fo:basic-link internal-destination="{@target}" xsl:use-attribute-sets="ref">
      <xsl:choose>
        <xsl:when test="text()">
          <xsl:value-of select="."/>
        </xsl:when>
        <xsl:when test="@*:title">
          <xsl:value-of select="@*:title"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@target"/>
        </xsl:otherwise>
      </xsl:choose>
    </fo:basic-link>
  </xsl:template>
  <xsl:template match="ead:ptr">
    <fo:basic-link external-destination="url('{@target}')" xsl:use-attribute-sets="ref">
      <xsl:choose>
        <xsl:when test="child::*">
          <xsl:value-of select="."/>
        </xsl:when>
        <xsl:when test="@*:title">
          <xsl:value-of select="@*:title"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@target"/>
        </xsl:otherwise>
      </xsl:choose>
    </fo:basic-link>
  </xsl:template>
  <xsl:template match="ead:extref">
    <fo:basic-link external-destination="url('{@*:href}')" xsl:use-attribute-sets="ref">
      <xsl:choose>
        <xsl:when test="text()">
          <xsl:value-of select="."/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@*:href"/>
        </xsl:otherwise>
      </xsl:choose>
    </fo:basic-link>
  </xsl:template>
  <xsl:template match="ead:extrefloc">
    <fo:basic-link external-destination="url('{@*:href}')" xsl:use-attribute-sets="ref">
      <xsl:choose>
        <xsl:when test="text()">
          <xsl:value-of select="."/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@*:href"/>
        </xsl:otherwise>
      </xsl:choose>
    </fo:basic-link>
  </xsl:template>
  <xsl:template match="ead:extptr[@*:entityref]">
    <fo:basic-link external-destination="url('{@*:entityref}')" xsl:use-attribute-sets="ref">
      <xsl:choose>
        <xsl:when test="@*:title">
          <xsl:value-of select="@*:title"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@*:entityref"/>
        </xsl:otherwise>
      </xsl:choose>
    </fo:basic-link>
  </xsl:template>
  <xsl:template match="ead:extptr[@*:href]">
    <fo:basic-link external-destination="url('{@*:href}')" xsl:use-attribute-sets="ref">
      <xsl:choose>
        <xsl:when test="@*:title">
          <xsl:value-of select="@*:title"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@*:href"/>
        </xsl:otherwise>
      </xsl:choose>
    </fo:basic-link>
  </xsl:template>
  <xsl:template match="ead:dao">
    <xsl:variable name="linkTitle">
      <xsl:choose>
        <xsl:when test="child::*">
          <xsl:apply-templates/>
        </xsl:when>
        <xsl:when test="@*:title">
          <xsl:value-of select="@*:title"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@*:href"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <fo:basic-link external-destination="url('{@*:href}')" xsl:use-attribute-sets="ref">
      <xsl:value-of select="$linkTitle"/>
    </fo:basic-link>
  </xsl:template>
  <xsl:template match="ead:daogrp">
    <fo:block>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <xsl:template match="ead:daoloc">
    <fo:basic-link external-destination="url('{@*:href}')" xsl:use-attribute-sets="ref">
      <xsl:choose>
        <xsl:when test="text()">
          <xsl:value-of select="."/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@*:href"/>
        </xsl:otherwise>
      </xsl:choose>
    </fo:basic-link>
  </xsl:template>

  <!--Render elements -->
  <xsl:template match="*[@render = 'bold'] | *[@altrender = 'bold'] ">
    <fo:inline font-weight="bold">
      <xsl:if test="preceding-sibling::*"> &#160;
      </xsl:if>
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  <xsl:template match="*[@render = 'bolddoublequote'] | *[@altrender = 'bolddoublequote']">
    <fo:inline font-weight="bold">
      <xsl:if test="preceding-sibling::*">
        &#160;
        </xsl:if>"
        <xsl:apply-templates/>"
    </fo:inline>
  </xsl:template>
  <xsl:template match="*[@render = 'boldsinglequote'] | *[@altrender = 'boldsinglequote']">
    <fo:inline font-weight="bold">
      <xsl:if test="preceding-sibling::*">
        &#160;
        </xsl:if>'
        <xsl:apply-templates/>'
    </fo:inline>
  </xsl:template>
  <xsl:template match="*[@render = 'bolditalic'] | *[@altrender = 'bolditalic']">
    <fo:inline font-weight="bold" font-style="italic">
      <xsl:if test="preceding-sibling::*"> &#160;
      </xsl:if>
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  <xsl:template match="*[@render = 'boldsmcaps'] | *[@altrender = 'boldsmcaps']">
    <fo:inline font-weight="bold" font-variant="small-caps">
      <xsl:if test="preceding-sibling::*"> &#160;
      </xsl:if>
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  <xsl:template match="*[@render = 'boldunderline'] | *[@altrender = 'boldunderline']">
    <fo:inline font-weight="bold" border-bottom="1pt solid #000">
      <xsl:if test="preceding-sibling::*"> &#160;
      </xsl:if>
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  <xsl:template match="*[@render = 'doublequote'] | *[@altrender = 'doublequote']">
    <xsl:if test="preceding-sibling::*"> &#160;
    </xsl:if>"
    <xsl:apply-templates/>"
  </xsl:template>
  <xsl:template match="*[@render = 'italic'] | *[@altrender = 'italic']">
    <fo:inline font-style="italic">
      <!-- <xsl:if test="preceding-sibling::*"> &#160; -->
      <!-- </xsl:if> -->
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  <xsl:template match="*[@render = 'singlequote'] | *[@altrender = 'singlequote']">
    <xsl:if test="preceding-sibling::*"> &#160;
    </xsl:if>'
    <xsl:apply-templates/>'
  </xsl:template>
  <xsl:template match="*[@render = 'smcaps'] | *[@altrender = 'smcaps']">
    <fo:inline font-variant="small-caps">
      <xsl:if test="preceding-sibling::*"> &#160;
      </xsl:if>
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  <xsl:template match="*[@render = 'sub'] | *[@altrender = 'sub']">
    <fo:inline baseline-shift="sub">
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  <xsl:template match="*[@render = 'super'] | *[@altrender = 'super']">
    <fo:inline baseline-shift="super">
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  <xsl:template match="*[@render = 'underline'] | *[@altrender = 'underline']">
    <fo:inline text-decoration="underline">
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>

  <!-- Formatting elements -->
  <xsl:template match="ead:p">
    <fo:block xsl:use-attribute-sets="smp">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <xsl:template match="ead:br">
    <fo:block>
      <xsl:attribute name="linefeed-treatment">preserve</xsl:attribute>
      <xsl:text>&#xA;</xsl:text>
    </fo:block>
  </xsl:template>
  <xsl:template match="ead:p" mode="overview">
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="ead:head" mode="overview">
    <!--omit-->
  </xsl:template>
  <xsl:template match="ead:lb">
    <fo:block/>
  </xsl:template>
  <xsl:template match="ead:blockquote">
    <fo:block margin="4pt 18pt">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <xsl:template match="ead:emph[not(@render)]">
    <fo:inline font-style="italic">
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>

  <!-- Collection Inventory (dsc) templates -->
  <xsl:template match="ead:archdesc/ead:dsc">
    <xsl:if test="count(child::*) >= 1">
      <fo:block xsl:use-attribute-sets="section">
        <fo:block xsl:use-attribute-sets="h2ID">
          <xsl:value-of select="local:tagName(.)"/>
        </fo:block>
        <xsl:if test="child::*[@level][1][@level='item' or @level='file' or @level='otherlevel']">
          <fo:table table-layout="fixed" space-after="12pt" width="100%" font-size="10pt">
            <fo:table-column column-number="1" column-width="0.75in"/>
            <fo:table-column column-number="2" column-width="0.75in"/>
            <fo:table-column column-number="3" column-width="4.5in"/>
            <fo:table-column column-number="4" column-width="1in"/>
            <xsl:call-template name="tableHeaders"/>
            <fo:table-body>
              <xsl:apply-templates select="child::*[@level='item' or @level='file' or @level='otherlevel']"/>
            </fo:table-body>
          </fo:table>
        </xsl:if>
      </fo:block>
    </xsl:if>
  </xsl:template>

  <!--
      Calls the clevel template passes the calculates the level of current component in xml tree and passes it to clevel template via the level parameter
      Adds a row to with a link to top if level series
  -->
  <xsl:template match="ead:c | ead:c01 | ead:c02 | ead:c03 | ead:c04 | ead:c05 | ead:c06 | ead:c07 | ead:c08 | ead:c09 | ead:c10 | ead:c11 | ead:c12">
    <xsl:variable name="findClevel" select="count(ancestor::*[not(ead:dsc or ead:archdesc or ead:ead)])"/>
    <xsl:variable name="cPosition" select="position()" />
    <xsl:call-template name="clevel">
      <xsl:with-param name="level" select="$findClevel">
      </xsl:with-param>
      <xsl:with-param name="position" select="$cPosition">
      </xsl:with-param>

    </xsl:call-template>
  </xsl:template>
  <!--This is a named template that processes all the components  -->
  <xsl:template name="clevel">
    <!-- Establishes which level is being processed in order to provided indented displays. -->
    <xsl:param name="level" />
    <xsl:param name="position" />
    <xsl:choose>
      <!--Formats Series and Groups  -->
      <xsl:when test="@level='subcollection' or @level='subgrp' or @level='series'
                      or @level='subseries' or @level='collection'or @level='fonds' or
                      @level='recordgrp' or @level='subfonds' or @level='class' or (@level='otherlevel' and not(child::ead:did/ead:container))">
                      <xsl:apply-templates select="ead:did" mode="dscSeriesTitle">
                        <xsl:with-param name="position">
                          <xsl:value-of select="$position" />
                        </xsl:with-param>
                      </xsl:apply-templates>
                      <xsl:apply-templates select="ead:did" mode="dscSeries"/>
                      <xsl:apply-templates select="child::*[not(ead:did) and not(self::ead:did)]" mode="dsc"/>
                      <xsl:choose>
                        <xsl:when test="child::*[@level][1][@level='item' or @level='file' or @level='otherlevel']">
                          <fo:table table-layout="fixed" space-after="12pt" width="100%" font-size="10pt">
                            <fo:table-column column-number="1" column-width="0.75in" xsl:use-attribute-sets="tableBorder"/>
                            <fo:table-column column-number="2" column-width="0.75in" xsl:use-attribute-sets="tableBorder"/>
                            <fo:table-column column-number="3" column-width="4.5in" xsl:use-attribute-sets="tableBorder"/>
                            <fo:table-column column-number="4" column-width="1in" xsl:use-attribute-sets="tableBorder"/>
                            <xsl:call-template name="tableHeaders"/>
                            <fo:table-body>
                              <xsl:apply-templates select="child::*[@level='item' or @level='file' or @level='otherlevel']"/>
                            </fo:table-body>
                          </fo:table>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:apply-templates select="child::*[not(ead:did) and not(self::ead:did)]" mode="dsc"/>
                        </xsl:otherwise>
                      </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <fo:table-row border-top="1px solid #ccc" border-bottom="1px solid #ccc" keep-together.within-page="always">
          <fo:table-cell>
            <fo:block margin="4pt 0">
              <xsl:for-each select="ead:did/ead:container[@type='box']">
                <fo:block>
                  <xsl:value-of select="text()"/>
                </fo:block>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block margin="4pt 0">
              <xsl:for-each select="ead:did/ead:container[@type='folder']">
                <fo:block>
                  <xsl:value-of select="text()"/>
                </fo:block>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block margin="4pt 0">
              <xsl:choose>
                <xsl:when test="$level &gt; 3">
                  <xsl:attribute name="margin-left">14pt</xsl:attribute>
                </xsl:when>
                <xsl:when test="$level = 3">
                  <xsl:attribute name="margin-left">10pt</xsl:attribute>
                </xsl:when>
              </xsl:choose>
              <xsl:apply-templates select="ead:did/ead:unittitle"/>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block margin="4pt 0">
              <xsl:for-each select="ead:did/ead:unitdate">
                <xsl:apply-templates select="." mode="did"/>
                <xsl:if test="position()!=last()">
                  <xsl:text>,
                  </xsl:text>
                </xsl:if>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
        <xsl:apply-templates select="ead:c | ead:c01 | ead:c02 | ead:c03 | ead:c04 | ead:c05 | ead:c06 | ead:c07 | ead:c08 | ead:c09 | ead:c10 | ead:c11 | ead:c12"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- Named template to generate table headers -->
  <xsl:template name="tableHeaders">
    <fo:table-header>
      <fo:table-cell>
        <fo:block font-weight="bold" padding="2pt">
          Box
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block font-weight="bold" padding="2pt">
          Folder
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block font-weight="bold" padding="2pt">
          Title
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block font-weight="bold" padding="2pt">
          Date
        </fo:block>
      </fo:table-cell>
    </fo:table-header>
  </xsl:template>
  <!-- Formats did containers -->
  <xsl:template match="ead:container">
    <fo:table-cell>
      <fo:block margin="4pt 0">
        <xsl:value-of select="@type"/>
        <xsl:text>
        </xsl:text>
        <xsl:value-of select="."/>
      </fo:block>
    </fo:table-cell>
  </xsl:template>

  <!-- Series titles -->
  <xsl:template match="ead:did" mode="dscSeriesTitle">
    <xsl:param name="position" />
    <fo:block xsl:use-attribute-sets="smp" font-weight="bold" id="{local:buildID(parent::*)}">
      <!-- Uncomment the following to add 'Series' to series titles  -->
      <xsl:variable name="number">
        <xsl:choose>
          <xsl:when test="ead:unitid">
            <xsl:value-of select="ead:unitid" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$position" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="../@level='series'">Series
        <xsl:value-of select="$number"/>:
        </xsl:when>
        <xsl:when test="../@level='subseries'">Subseries
        <xsl:value-of select="$number"/>:
        </xsl:when>
        <xsl:when test="../@level='subsubseries'">Sub-Subseries
        <xsl:value-of select="$number"/>:
        </xsl:when>
        <xsl:when test="../@level='collection'">Collection
        <xsl:value-of select="$number"/>:
        </xsl:when>
        <xsl:when test="../@level='subcollection'">Subcollection
        <xsl:value-of select="$number"/>:
        </xsl:when>
        <xsl:when test="../@level='fonds'">Fonds
        <xsl:value-of select="$number"/>:
        </xsl:when>
        <xsl:when test="../@level='subfonds'">Subfonds
        <xsl:value-of select="$number"/>:
        </xsl:when>
        <xsl:when test="../@level='recordgrp'">Record Group
        <xsl:value-of select="$number"/>:
        </xsl:when>
        <xsl:when test="../@level='subgrp'">Subgroup
        <xsl:value-of select="$number"/>:
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$number"/>:
        </xsl:otherwise>
      </xsl:choose>

      <xsl:apply-templates select="ead:unittitle"/>
    </fo:block>
    <xsl:if test="ead:unitdate">
      <fo:block xsl:use-attribute-sets="smp">
        <fo:inline font-weight="bold">Dates:
        </fo:inline>
        <xsl:for-each select="ead:unitdate">
          <xsl:apply-templates select="." mode="did"/>
          <xsl:if test="position()!=last()">
            <xsl:text>,
            </xsl:text>
          </xsl:if>
        </xsl:for-each>
      </fo:block>
    </xsl:if>
    <xsl:if test="ead:extent">
      <fo:block xsl:use-attribute-sets="smp">
        <fo:inline font-weight="bold">Extent:
        </fo:inline>
        <xsl:for-each select="ead:extent">
          <xsl:apply-templates select="." mode="did"/>
          <xsl:if test="position()!=last()">
            <xsl:text>,
            </xsl:text>
          </xsl:if>
        </xsl:for-each>
      </fo:block>
    </xsl:if>
  </xsl:template>




  <!-- Series child elements -->
  <xsl:template match="ead:did" mode="dscSeries">
    <fo:block margin-bottom="4pt" margin-top="0">
      <xsl:apply-templates select="ead:repository" mode="dsc"/>
      <xsl:apply-templates select="ead:origination" mode="dsc"/>
      <xsl:apply-templates select="ead:unitdate" mode="dsc"/>
      <xsl:apply-templates select="ead:physdesc" mode="dsc"/>
      <xsl:apply-templates select="ead:physloc" mode="dsc"/>
      <xsl:apply-templates select="ead:dao"/>
      <xsl:apply-templates select="ead:daogrp"/>
      <xsl:apply-templates select="ead:langmaterial" mode="dsc"/>
      <xsl:apply-templates select="ead:materialspec" mode="dsc"/>
      <xsl:apply-templates select="ead:abstract" mode="dsc"/>
      <xsl:apply-templates select="ead:note" mode="dsc"/>
    </fo:block>
  </xsl:template>

  <!-- Unittitles and all other clevel elements -->
  <xsl:template match="ead:did" mode="dsc">
    <fo:block margin-bottom="0">
      <xsl:apply-templates select="ead:unittitle"/>
      <xsl:if test="(string-length(ead:unittitle[1]) &gt; 1) and (string-length(ead:unitdate[1]) &gt; 1)">,
      </xsl:if>
      <xsl:for-each select="ead:unitdate">
        <xsl:apply-templates select="." mode="did"/>
        <xsl:if test="position()!=last()">
          <xsl:text>,
          </xsl:text>
        </xsl:if>
      </xsl:for-each>
    </fo:block>
    <fo:block margin-bottom="4pt" margin-top="0">
      <xsl:apply-templates select="ead:repository" mode="dsc"/>
      <xsl:apply-templates select="ead:origination" mode="dsc"/>
      <xsl:apply-templates select="ead:unitdate" mode="dsc"/>
      <xsl:apply-templates select="ead:physdesc" mode="dsc"/>
      <xsl:apply-templates select="ead:physloc" mode="dsc"/>
      <xsl:apply-templates select="ead:dao" mode="dsc"/>
      <xsl:apply-templates select="ead:daogrp" mode="dsc"/>
      <xsl:apply-templates select="ead:langmaterial" mode="dsc"/>
      <xsl:apply-templates select="ead:materialspec" mode="dsc"/>
      <xsl:apply-templates select="ead:abstract" mode="dsc"/>
      <xsl:apply-templates select="ead:note" mode="dsc"/>
    </fo:block>
  </xsl:template>
  <!-- Formats unitdates -->
  <xsl:template match="ead:unitdate[@type = 'bulk']" mode="did">
    <!-- <xsl:text>( -->
    <!-- </xsl:text> -->
    <xsl:apply-templates/>
    <!-- <xsl:text>) -->
    <!-- </xsl:text> -->
  </xsl:template>
  <xsl:template match="ead:unitdate" mode="did">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Special formatting for elements in the collection inventory list -->
  <xsl:template match="ead:repository | ead:origination | ead:unitid
                       | ead:physdesc | ead:physloc | ead:langmaterial | ead:materialspec | ead:container
                       | ead:abstract | ead:note" mode="dsc">
                       <xsl:if test="normalize-space()">
                         <fo:block xsl:use-attribute-sets="smpDsc">
                           <fo:inline text-decoration="underline">
                             <xsl:choose>
                               <!-- Test for label attribute used by origination element -->
                               <xsl:when test="@label">
                                 <xsl:value-of select="concat(upper-case(substring(@label,1,1)),substring(@label,2))">
                                 </xsl:value-of>
                                 <xsl:if test="@type"> [
                                 <xsl:value-of select="@type"/>]
                                 </xsl:if>
                                 <xsl:if test="self::ead:origination">
                                   <xsl:choose>
                                     <xsl:when test="ead:persname[@role != ''] and contains(ead:persname/@role,' (')">
                                       -
                                       <xsl:value-of select="substring-before(ead:persname/@role,' (')"/>
                                     </xsl:when>
                                     <xsl:when test="ead:persname[@role != '']">
                                       -
                                       <xsl:value-of select="ead:persname/@role"/>
                                     </xsl:when>
                                     <xsl:otherwise/>
                                   </xsl:choose>
                                 </xsl:if>
                               </xsl:when>
                               <xsl:otherwise>
                                 <xsl:value-of select="local:tagName(.)"/>
                                 <!-- Test for type attribute used by unitdate -->
                                 <xsl:if test="@type"> [
                                 <xsl:value-of select="@type"/>]
                                 </xsl:if>
                               </xsl:otherwise>
                             </xsl:choose>
                             </fo:inline>:
                             <xsl:apply-templates/>
                             <!-- Test for certainty attribute used by unitdate -->
                             <xsl:if test="@certainty" >
                               <fo:inline font-style="italic"> (
                               <xsl:value-of select="@certainty"/>)
                               </fo:inline>
                             </xsl:if>
                         </fo:block>
                       </xsl:if>
  </xsl:template>
  <xsl:template match="ead:relatedmaterial | ead:separatedmaterial | ead:accessrestrict | ead:userestrict |
                       ead:custodhist | ead:accruals | ead:altformavail |
                       ead:processinfo | ead:appraisal | ead:originalsloc" mode="dsc">
                       <xsl:if test="child::*">
                         <fo:block xsl:use-attribute-sets="smpDsc">
                           <fo:inline text-decoration="underline">
                             <xsl:value-of select="local:tagName(.)"/>:
                           </fo:inline>
                           <xsl:apply-templates select="child::*[not(ead:head)]"/>
                         </fo:block>
                       </xsl:if>
  </xsl:template>
  <xsl:template match="ead:index" mode="dsc">
    <xsl:apply-templates select="child::*[not(self::ead:indexentry)]"/>
    <fo:list-block xsl:use-attribute-sets="smpDsc">
      <xsl:apply-templates select="ead:indexentry"/>
    </fo:list-block>
  </xsl:template>
  <xsl:template match="ead:controlaccess" mode="dsc">
    <fo:block xsl:use-attribute-sets="smpDsc" text-decoration="underline">
      <xsl:value-of select="local:tagName(.)"/>:
    </fo:block>
    <fo:list-block xsl:use-attribute-sets="smpDsc">
      <xsl:apply-templates/>
    </fo:list-block>
    <!--
        To group controlled access terms by type
        <xsl:for-each-group select="child::*" group-by="name(.)">
        <xsl:sort select="current-grouping-key()"/>
        <fo:block margin-left="8pt" text-decoration="underline">
        <xsl:value-of select="local:tagName(.)"/>
        </fo:block>
        <fo:list-block xsl:use-attribute-sets="smpDsc">
        <xsl:for-each select="current-group()">
        <fo:list-item>
        <fo:list-item-label end-indent="label-end()">
        <fo:block>
        </fo:block>
        </fo:list-item-label>
        <fo:list-item-body start-indent="body-start()">
        <fo:block>
        <xsl:apply-templates/>
        </fo:block>
        </fo:list-item-body>
        </fo:list-item>
        </xsl:for-each>
        </fo:list-block>
        </xsl:for-each-group>
    -->
  </xsl:template>
  <xsl:template match="ead:dao" mode="dsc">
    <xsl:variable name="title">
      <xsl:choose>
        <xsl:when test="child::*">
          <xsl:apply-templates/>
        </xsl:when>
        <xsl:when test="@*:title">
          <xsl:value-of select="@*:title"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@*:href"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <fo:block xsl:use-attribute-sets="smpDsc">
      <fo:inline text-decoration="underline">
        <xsl:choose>
          <!-- Test for label attribute used by origination element -->
          <xsl:when test="@label">
            <xsl:value-of select="concat(upper-case(substring(@label,1,1)),substring(@label,2))">
            </xsl:value-of>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="local:tagName(.)"/>
          </xsl:otherwise>
        </xsl:choose>
        </fo:inline>:
        <!--
            <fo:basic-link external-destination="url('{@*:href}')" xsl:use-attribute-sets="ref"> -->
        <!--
            <xsl:value-of select="$title"/> -->
        <!--
            </fo:basic-link> -->
    </fo:block>
  </xsl:template>
  <xsl:template mode="dsc" match="ead:scopecontent">
    <xsl:if test="child::*">
      <fo:block xsl:use-attribute-sets="smp">
        <fo:inline font-weight="bold">Scope and Content Note:
        </fo:inline>
        <xsl:apply-templates mode="overview"/>
      </fo:block>
    </xsl:if>
  </xsl:template>

  <xsl:template mode="dsc" match="ead:arrangement">
    <xsl:if test="child::*">
      <fo:block xsl:use-attribute-sets="smp">
        <fo:inline font-weight="bold">Arrangement:
        </fo:inline>
        <xsl:apply-templates mode="overview"/>
      </fo:block>
    </xsl:if>
  </xsl:template>

  <xsl:template mode="dsc" match="ead:physdesc">
    <xsl:if test="child::*">
      <fo:block xsl:use-attribute-sets="smp">
        <fo:inline font-weight="bold">Physical Characteristics and Technical Requirements:
        </fo:inline>
        <xsl:apply-templates mode="overview"/>
      </fo:block>
    </xsl:if>
  </xsl:template>


  <!-- Everything else in the dsc -->
  <xsl:template mode="dsc" match="*">
    <xsl:if test="child::*">
      <fo:block xsl:use-attribute-sets="smpDsc">
        <xsl:apply-templates/>
      </fo:block>
    </xsl:if>
  </xsl:template>

  <!-- replaces AS default unitdate row in overview-->
  <xsl:template name="unitdatesOverview">
    <fo:table-row>
      <fo:table-cell padding-bottom="8pt" padding-right="16pt" text-align="left" font-weight="bold">
        <fo:block>
          Dates:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell padding-bottom="2pt">
        <fo:block>
          <xsl:value-of select="ead:unitdate[@type = 'inclusive']" />
          <xsl:if test="ead:unitdate[@type = 'bulk']">
            <xsl:text>
              </xsl:text>(Bulk
              <xsl:value-of select="ead:unitdate[@type='bulk']" />)
          </xsl:if>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
  </xsl:template>
</xsl:stylesheet>

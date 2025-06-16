<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:gml="http://www.opengis.net/gml"
                xmlns:gmd="http://standards.iso.org/iso/19115/-3/gmd"
                xmlns:gmx="http://standards.iso.org/iso/19115/-3/gmx"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:srv="http://standards.iso.org/iso/19115/-3/srv/2.0"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
                xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                xmlns:mrs="http://standards.iso.org/iso/19115/-3/mrs/1.0"
                xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
                xmlns:mco="http://standards.iso.org/iso/19115/-3/mco/1.0"
                xmlns:msr="http://standards.iso.org/iso/19115/-3/msr/2.0"
                xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
                xmlns:gcx="http://standards.iso.org/iso/19115/-3/gcx/1.0"
                xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
                xmlns:dqm="http://standards.iso.org/iso/19157/-2/dqm/1.0"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:mdq="http://standards.iso.org/iso/19157/-2/mdq/1.0"
                xmlns:mrl="http://standards.iso.org/iso/19115/-3/mrl/2.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                exclude-result-prefixes="#all"
                version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is
      the preferred method for meta-stylesheets to use where possible.
    -->
<xsl:param name="archiveDirParameter"/>
   <xsl:param name="archiveNameParameter"/>
   <xsl:param name="fileNameParameter"/>
   <xsl:param name="fileDirParameter"/>
   <xsl:variable name="document-uri">
      <xsl:value-of select="document-uri(/)"/>
   </xsl:variable>

   <!--PHASES-->


<!--PROLOG-->
<xsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" method="xml"
               omit-xml-declaration="no"
               standalone="yes"
               indent="yes"/>
   <xsl:include xmlns:svrl="http://purl.oclc.org/dsdl/svrl" href="../../../xsl/utils-fn.xsl"/>
   <xsl:param xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="lang"/>
   <xsl:param xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="thesaurusDir"/>
   <xsl:param xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="rule"/>
   <xsl:variable xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="loc">
      <xsl:choose>
         <xsl:when test="document(concat('../loc/', $lang, '/', $rule, '.xml'))">
            <xsl:copy-of select="document(concat('../loc/', $lang, '/', $rule, '.xml'))"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="document(concat('../loc/', 'eng', '/', $rule, '.xml'))"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
         <xsl:when test="count(document(concat('../loc/', $lang, '/', 'schematron-shared.xml')))">
            <xsl:copy-of select="document(concat('../loc/', $lang, '/', 'schematron-shared.xml'))"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="document(concat('../loc/', 'eng', '/', 'schematron-shared.xml'))"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:variable>

   <!--XSD TYPES FOR XSLT2-->


<!--KEYS AND FUNCTIONS-->


<!--DEFAULT RULES-->


<!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators
    -->
<xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path"/>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators
    -->
<xsl:template match="*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
            <xsl:variable name="p_1"
                          select="1+       count(preceding-sibling::*[name()=name(current())])"/>
            <xsl:if test="$p_1&gt;1 or following-sibling::*[name()=name(current())]">[<xsl:value-of select="$p_1"/>]</xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>']</xsl:text>
            <xsl:variable name="p_2"
                          select="1+     count(preceding-sibling::*[local-name()=local-name(current())])"/>
            <xsl:if test="$p_2&gt;1 or following-sibling::*[local-name()=local-name(current())]">[<xsl:value-of select="$p_2"/>]</xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@
              <xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-2-->
<!--This mode can be used to generate prefixed XPath for humans-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@
        <xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
<!--This mode can be used to generate prefixed XPath for humans
      (Top-level element has index)
    -->
<xsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="parent::*">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@
        <xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>

   <!--MODE: GENERATE-ID-FROM-PATH-->
<xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>

   <!--MODE: GENERATE-ID-2-->
<xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters--><xsl:template match="text()" priority="-1"/>

   <!--SCHEMA SETUP-->
<xsl:template match="/">
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                              title="DCAT-AP High Value Dataset (HVD)"
                              schemaVersion="">
         <xsl:comment>
            <xsl:value-of select="$archiveDirParameter"/>
         
        <xsl:value-of select="$archiveNameParameter"/>
         
        <xsl:value-of select="$fileNameParameter"/>
         
        <xsl:value-of select="$fileDirParameter"/>
         </xsl:comment>
         <svrl:ns-prefix-in-attribute-values uri="http://www.opengis.net/gml" prefix="gml"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/gmd" prefix="gmd"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/gmx" prefix="gmx"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.fao.org/geonetwork" prefix="geonet"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/2004/02/skos/core#" prefix="skos"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/1999/xlink" prefix="xlink"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/srv/2.0" prefix="srv"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/mdb/2.0" prefix="mdb"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/mcc/1.0" prefix="mcc"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/mri/1.0" prefix="mri"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/mrs/1.0" prefix="mrs"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/mrd/1.0" prefix="mrd"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/mco/1.0" prefix="mco"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/msr/2.0" prefix="msr"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/lan/1.0" prefix="lan"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/gcx/1.0" prefix="gcx"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/gex/1.0" prefix="gex"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19157/-2/dqm/1.0" prefix="dqm"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/cit/2.0" prefix="cit"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19157/-2/mdq/1.0" prefix="mdq"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/mrl/2.0" prefix="mrl"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/gco/1.0" prefix="gco"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">HVD</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M55"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">HVD (dataset)</xsl:attribute>
            <xsl:attribute name="name">HVD (dataset)</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M56"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">HVD (service)</xsl:attribute>
            <xsl:attribute name="name">HVD (service)</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M57"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">DCAT-AP High Value Dataset (HVD)</svrl:text>
   <svrl:diagnostic-reference xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                              diagnostic="rule.hvd.legislation.mandatory-failure-en">
      <xsl:attribute name="xml:lang">en</xsl:attribute>

    Applicable legislation is mandatory. Use a keyword with an Anchor pointing to
    http://data.europa.eu/eli/reg_impl/2023/138/oj.
  </svrl:diagnostic-reference>
   <svrl:diagnostic-reference xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                              diagnostic="rule.hvd.legislation.mandatory-failure-fr">
      <xsl:attribute name="xml:lang">fr</xsl:attribute>

    La législation applicable est obligatoire. Utilisez un mot-clé avec une ancre pointant vers
    http://data.europa.eu/eli/reg_impl/2023/138/oj.
  </svrl:diagnostic-reference>
   <svrl:diagnostic-reference xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                              diagnostic="rule.hvd.legislation.mandatory-success-en">
      <xsl:attribute name="xml:lang">en</xsl:attribute>
Applicable legislation keyword found.
  </svrl:diagnostic-reference>
   <svrl:diagnostic-reference xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                              diagnostic="rule.hvd.legislation.mandatory-success-fr">
      <xsl:attribute name="xml:lang">fr</xsl:attribute>
La législation applicable HVD est encodée.
  </svrl:diagnostic-reference>
   <svrl:diagnostic-reference xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                              diagnostic="rule.hvd.conformity.mandatory-failure-en">
      <xsl:attribute name="xml:lang">en</xsl:attribute>

    No implementing rule or other specification found. Check the data quality
    report specification to add one. For INSPIRE datasets, this is a data specification conformity.
  </svrl:diagnostic-reference>
   <svrl:diagnostic-reference xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                              diagnostic="rule.hvd.conformity.mandatory-failure-fr">
      <xsl:attribute name="xml:lang">fr</xsl:attribute>

    Aucune règle d'implémentation ou autre spécification n'a été trouvée. Vérifiez la spécification du rapport de
    qualité des données
    pour en ajouter une. Pour les ensembles de données INSPIRE, il s'agit d'une conformité aux spécifications des
    données.
  </svrl:diagnostic-reference>
   <svrl:diagnostic-reference xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                              diagnostic="rule.hvd.conformity.mandatory-success-en">
      <xsl:attribute name="xml:lang">en</xsl:attribute>

    Implementing rules or specifications found:<xsl:text/>
      <xsl:copy-of select="concat(' ', string-join($implementingRules, ', '))"/>
      <xsl:text/>.
  </svrl:diagnostic-reference>
   <svrl:diagnostic-reference xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                              diagnostic="rule.hvd.conformity.mandatory-success-fr">
      <xsl:attribute name="xml:lang">fr</xsl:attribute>

    Règles ou spécifications encodées :<xsl:text/>
      <xsl:copy-of select="concat(' ', string-join($implementingRules, ', '))"/>
      <xsl:text/>.
  </svrl:diagnostic-reference>
   <svrl:diagnostic-reference xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                              diagnostic="rule.hvd.contactPoint.mandatory-failure-en">
      <xsl:attribute name="xml:lang">en</xsl:attribute>

    Contact information that can be used for sending comments about the Dataset is missing.
  </svrl:diagnostic-reference>
   <svrl:diagnostic-reference xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                              diagnostic="rule.hvd.contactPoint.mandatory-failure-fr">
      <xsl:attribute name="xml:lang">fr</xsl:attribute>

    Les informations de contact pouvant être utilisées pour envoyer des commentaires sur l'ensemble de données sont
    manquantes.
  </svrl:diagnostic-reference>
   <svrl:diagnostic-reference xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                              diagnostic="rule.hvd.contactPoint.mandatory-success-en">
      <xsl:attribute name="xml:lang">en</xsl:attribute>

    Contact information that can be used for sending comments about the Dataset defined:<xsl:text/>
      <xsl:copy-of select="concat(' ', string-join($resourcePointOfContact, ', '))"/>
      <xsl:text/>.
  </svrl:diagnostic-reference>
   <svrl:diagnostic-reference xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                              diagnostic="rule.hvd.contactPoint.mandatory-success-fr">
      <xsl:attribute name="xml:lang">fr</xsl:attribute>

    Contact pouvant être utilisées pour envoyer des commentaires sur l'ensemble de données encodé :<xsl:text/>
      <xsl:copy-of select="concat(' ', string-join($resourcePointOfContact, ', '))"/>
      <xsl:text/>.
  </svrl:diagnostic-reference>
   <svrl:diagnostic-reference xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                              diagnostic="rule.hvd.category.mandatory-failure-en">
      <xsl:attribute name="xml:lang">en</xsl:attribute>

    The HVD category to which this Dataset belongs is missing.
  </svrl:diagnostic-reference>
   <svrl:diagnostic-reference xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                              diagnostic="rule.hvd.category.mandatory-failure-fr">
      <xsl:attribute name="xml:lang">fr</xsl:attribute>

    La catégorie HVD à laquelle appartient cet ensemble de données est manquante.
  </svrl:diagnostic-reference>
   <svrl:diagnostic-reference xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                              diagnostic="rule.hvd.category.mandatory-success-en">
      <xsl:attribute name="xml:lang">en</xsl:attribute>

    HVD categories found:<xsl:text/>
      <xsl:copy-of select="concat(' ', string-join($hvdCategories, ', '))"/>
      <xsl:text/>.
  </svrl:diagnostic-reference>
   <svrl:diagnostic-reference xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                              diagnostic="rule.hvd.category.mandatory-success-fr">
      <xsl:attribute name="xml:lang">fr</xsl:attribute>

    Catégories HVD encodées :<xsl:text/>
      <xsl:copy-of select="concat(' ', string-join($hvdCategories, ', '))"/>
      <xsl:text/>.
  </svrl:diagnostic-reference>
   <svrl:diagnostic-reference xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                              diagnostic="rule.hvd.distribution.mandatory-failure-en">
      <xsl:attribute name="xml:lang">en</xsl:attribute>

    The HVD IR is a quality improvement of existing datasets. The intention is that HVD datasets are publicly and open
    accessible. Therefore a Distribution is expected to be present. Add an online resource with a download protocol or
    function.
  </svrl:diagnostic-reference>
   <svrl:diagnostic-reference xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                              diagnostic="rule.hvd.distribution.mandatory-failure-fr">
      <xsl:attribute name="xml:lang">fr</xsl:attribute>

    Les règles d'implémentation HVD ont pour objectif une amélioration de la qualité des ensembles de données existants.
    L'objectif est que les ensembles de données HVD soient accessibles au public et en libre accès. Par conséquent, une
    distribution est attendue. Ajoutez une ressource en ligne avec un protocole ou une fonction de téléchargement.
  </svrl:diagnostic-reference>
   <svrl:diagnostic-reference xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                              diagnostic="rule.hvd.distribution.mandatory-success-en">
      <xsl:attribute name="xml:lang">en</xsl:attribute>

    Distribution URLs found:<xsl:text/>
      <xsl:copy-of select="concat(' ', string-join($distributions, ', '))"/>
      <xsl:text/>.
  </svrl:diagnostic-reference>
   <svrl:diagnostic-reference xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                              diagnostic="rule.hvd.distribution.mandatory-success-fr">
      <xsl:attribute name="xml:lang">fr</xsl:attribute>

    URL(s) de distribution encodées :<xsl:text/>
      <xsl:copy-of select="concat(' ', string-join($distributions, ', '))"/>
      <xsl:text/>.
  </svrl:diagnostic-reference>
   <svrl:diagnostic-reference xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                              diagnostic="rule.hvd.endpointurl.mandatory-failure-en">
      <xsl:attribute name="xml:lang">en</xsl:attribute>

    The root location or primary endpoint of the service (an IRI) is missing. Add an operation with a protocol which is
    not considered as an endpoint description (ie.<xsl:text/>
      <xsl:copy-of select="concat(' ', $endpointDescriptionProtocolsExpression)"/>
      <xsl:text/>) or a URL containing <xsl:text/>
      <xsl:copy-of select="$endpointDescriptionUrllExpression"/>
      <xsl:text/>.
  </svrl:diagnostic-reference>
   <svrl:diagnostic-reference xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                              diagnostic="rule.hvd.endpointurl.mandatory-failure-fr">
      <xsl:attribute name="xml:lang">fr</xsl:attribute>

    L'URL principale du service (un IRI) est manquant. Ajoutez une opération avec un protocole qui n'est pas une
    description de service
    (ie.<xsl:text/>
      <xsl:copy-of select="concat(' ', $endpointDescriptionProtocolsExpression)"/>
      <xsl:text/>) ou une URL contenant <xsl:text/>
      <xsl:copy-of select="$endpointDescriptionUrllExpression"/>
      <xsl:text/>.
  </svrl:diagnostic-reference>
   <svrl:diagnostic-reference xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                              diagnostic="rule.hvd.endpointurl.mandatory-success-en">
      <xsl:attribute name="xml:lang">en</xsl:attribute>

    End point URL found:<xsl:text/>
      <xsl:copy-of select="concat(' ', string-join($endpointUrls, ', '))"/>
      <xsl:text/>.
  </svrl:diagnostic-reference>
   <svrl:diagnostic-reference xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                              diagnostic="rule.hvd.endpointurl.mandatory-success-fr">
      <xsl:attribute name="xml:lang">fr</xsl:attribute>

    URL(s) du service encodées :<xsl:text/>
      <xsl:copy-of select="concat(' ', string-join($endpointUrls, ', '))"/>
      <xsl:text/>.
  </svrl:diagnostic-reference>
   <svrl:diagnostic-reference xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                              diagnostic="rule.hvd.operateson.mandatory-failure-en">
      <xsl:attribute name="xml:lang">en</xsl:attribute>

    An API in the context of HVD is not a standalone resource. It is used to open up HVD datasets. Therefore each Data
    Service is at least tightly connected with a Dataset.
    Add at least one operatesOn element with a xlink:href or uuidref.
  </svrl:diagnostic-reference>
   <svrl:diagnostic-reference xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                              diagnostic="rule.hvd.operateson.mandatory-failure-fr">
      <xsl:attribute name="xml:lang">fr</xsl:attribute>

    Une API dans le contexte de HVD n'est pas une ressource autonome. Elle est utilisée pour ouvrir des ensembles de
    données HVD. Par conséquent, chaque service de données est au moins étroitement lié à un ensemble de données.
    Ajoutez au moins un élément operateOn avec un xlink:href ou un uuidref.
  </svrl:diagnostic-reference>
   <svrl:diagnostic-reference xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                              diagnostic="rule.hvd.operateson.mandatory-success-en">
      <xsl:attribute name="xml:lang">en</xsl:attribute>

    Operates on dataset found:<xsl:text/>
      <xsl:copy-of select="concat(' ', string-join($operatesOnDatasets, ', '))"/>
      <xsl:text/>.
  </svrl:diagnostic-reference>
   <svrl:diagnostic-reference xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                              diagnostic="rule.hvd.operateson.mandatory-success-fr">
      <xsl:attribute name="xml:lang">fr</xsl:attribute>

    Données associées encodées :<xsl:text/>
      <xsl:copy-of select="concat(' ', string-join($operatesOnDatasets, ', '))"/>
      <xsl:text/>.
  </svrl:diagnostic-reference>
   <svrl:diagnostic-reference xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                              diagnostic="rule.hvd.servicedocumentation.mandatory-failure-en">
      <xsl:attribute name="xml:lang">en</xsl:attribute>

    A page that provides additional information about the Data Service is missing.
    Add at least one online resource with a function documentation, an additional documentation or a URL pointing to https://directory.spatineo.com.
  </svrl:diagnostic-reference>
   <svrl:diagnostic-reference xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                              diagnostic="rule.hvd.servicedocumentation.mandatory-failure-fr">
      <xsl:attribute name="xml:lang">fr</xsl:attribute>

    Il manque une page qui fournit des informations supplémentaires sur le service de données.
    Ajoutez au moins une ressource en ligne avec une function documentation, une documentation supplémentaire ou une URL pointant vers https://directory.spatineo.com.
  </svrl:diagnostic-reference>
   <svrl:diagnostic-reference xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                              diagnostic="rule.hvd.servicedocumentation.mandatory-success-en">
      <xsl:attribute name="xml:lang">en</xsl:attribute>

    Documentation pages found:<xsl:text/>
      <xsl:copy-of select="concat(' ', string-join($documentationUrls, ', '))"/>
      <xsl:text/>.
  </svrl:diagnostic-reference>
   <svrl:diagnostic-reference xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                              diagnostic="rule.hvd.servicedocumentation.mandatory-success-fr">
      <xsl:attribute name="xml:lang">fr</xsl:attribute>

    Documentations encodées :<xsl:text/>
      <xsl:copy-of select="concat(' ', string-join($documentationUrls, ', '))"/>
      <xsl:text/>.
  </svrl:diagnostic-reference>

   <!--PATTERN
        HVD-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">HVD</svrl:text>

  <!--RULE
      -->
<xsl:template match="//*:MD_Metadata" priority="1000" mode="M55">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//*:MD_Metadata"/>
      <xsl:variable name="hasOneKeywordEncodingApplicableLegislationAsAnchor"
                    select="count(*:identificationInfo/*/*:descriptiveKeywords/*/                               *:keyword[*:Anchor/@xlink:href                                   = 'http://data.europa.eu/eli/reg_impl/2023/138/oj']) = 1"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$hasOneKeywordEncodingApplicableLegislationAsAnchor"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$hasOneKeywordEncodingApplicableLegislationAsAnchor">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.hvd.legislation.mandatory-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>

    Applicable legislation is mandatory. Use a keyword with an Anchor pointing to
    http://data.europa.eu/eli/reg_impl/2023/138/oj.
  </svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.hvd.legislation.mandatory-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>

    La législation applicable est obligatoire. Utilisez un mot-clé avec une ancre pointant vers
    http://data.europa.eu/eli/reg_impl/2023/138/oj.
  </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="$hasOneKeywordEncodingApplicableLegislationAsAnchor">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$hasOneKeywordEncodingApplicableLegislationAsAnchor">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.hvd.legislation.mandatory-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
Applicable legislation keyword found.
  </svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.hvd.legislation.mandatory-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
La législation applicable HVD est encodée.
  </svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:variable name="hvdCategories"
                    select="*:identificationInfo/*/*:descriptiveKeywords/*[                *:thesaurusName/*/*:title/*:CharacterString = 'High-value dataset categories'                or *:thesaurusName/*/*:title/*:Anchor/@xlink:href = 'http://data.europa.eu/bna/asd487ae75']/*:keyword/*[text() != '']"/>
      <xsl:variable name="hasOneOrMoreKeywordEncodingHvdCategory"
                    select="count($hvdCategories) &gt; 0"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$hasOneOrMoreKeywordEncodingHvdCategory"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$hasOneOrMoreKeywordEncodingHvdCategory">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.hvd.category.mandatory-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>

    The HVD category to which this Dataset belongs is missing.
  </svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.hvd.category.mandatory-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>

    La catégorie HVD à laquelle appartient cet ensemble de données est manquante.
  </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="$hasOneOrMoreKeywordEncodingHvdCategory">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$hasOneOrMoreKeywordEncodingHvdCategory">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.hvd.category.mandatory-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>

    HVD categories found:<xsl:text/>
               <xsl:copy-of select="concat(' ', string-join($hvdCategories, ', '))"/>
               <xsl:text/>.
  </svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.hvd.category.mandatory-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>

    Catégories HVD encodées :<xsl:text/>
               <xsl:copy-of select="concat(' ', string-join($hvdCategories, ', '))"/>
               <xsl:text/>.
  </svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:variable name="resourcePointOfContact"
                    select="*:identificationInfo/*/*:pointOfContact[*/*:role/*/@codeListValue = 'pointOfContact']"/>
      <xsl:variable name="hasOneOrMorePointOfContact" select="count($resourcePointOfContact) &gt; 0"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$hasOneOrMorePointOfContact"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$hasOneOrMorePointOfContact">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.hvd.contactPoint.mandatory-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>

    Contact information that can be used for sending comments about the Dataset is missing.
  </svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.hvd.contactPoint.mandatory-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>

    Les informations de contact pouvant être utilisées pour envoyer des commentaires sur l'ensemble de données sont
    manquantes.
  </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="$hasOneOrMorePointOfContact">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$hasOneOrMorePointOfContact">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.hvd.contactPoint.mandatory-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>

    Contact information that can be used for sending comments about the Dataset defined:<xsl:text/>
               <xsl:copy-of select="concat(' ', string-join($resourcePointOfContact, ', '))"/>
               <xsl:text/>.
  </svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.hvd.contactPoint.mandatory-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>

    Contact pouvant être utilisées pour envoyer des commentaires sur l'ensemble de données encodé :<xsl:text/>
               <xsl:copy-of select="concat(' ', string-join($resourcePointOfContact, ', '))"/>
               <xsl:text/>.
  </svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M55"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M55"/>
   <xsl:template match="@*|node()" priority="-2" mode="M55">
      <xsl:apply-templates select="*" mode="M55"/>
   </xsl:template>

   <!--PATTERN
        HVD (dataset)-->


  <!--RULE
      -->
<xsl:template match="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue = 'dataset']"
                 priority="1000"
                 mode="M56">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue = 'dataset']"/>
      <xsl:variable name="implementingRules"
                    select="*:dataQualityInfo/*/*:report/*/*:result/*/*:specification/*/                                     *:title[starts-with(*:Anchor/@xlink:href, 'https://inspire.ec.europa.eu/id/document')]"/>
      <xsl:variable name="hasOneOrMoreDataSpecConformityForINSPIRE"
                    select="count($implementingRules) &gt; 0"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$hasOneOrMoreDataSpecConformityForINSPIRE"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$hasOneOrMoreDataSpecConformityForINSPIRE">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.hvd.conformity.mandatory-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>

    No implementing rule or other specification found. Check the data quality
    report specification to add one. For INSPIRE datasets, this is a data specification conformity.
  </svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.hvd.conformity.mandatory-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>

    Aucune règle d'implémentation ou autre spécification n'a été trouvée. Vérifiez la spécification du rapport de
    qualité des données
    pour en ajouter une. Pour les ensembles de données INSPIRE, il s'agit d'une conformité aux spécifications des
    données.
  </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="$hasOneOrMoreDataSpecConformityForINSPIRE">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$hasOneOrMoreDataSpecConformityForINSPIRE">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.hvd.conformity.mandatory-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>

    Implementing rules or specifications found:<xsl:text/>
               <xsl:copy-of select="concat(' ', string-join($implementingRules, ', '))"/>
               <xsl:text/>.
  </svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.hvd.conformity.mandatory-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>

    Règles ou spécifications encodées :<xsl:text/>
               <xsl:copy-of select="concat(' ', string-join($implementingRules, ', '))"/>
               <xsl:text/>.
  </svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:variable name="distributions"
                    select="*:distributionInfo//*:onLine/*[*:linkage/(*:CharacterString|*:URL)/text() != ''][not(                                         cit:function/*/@codeListValue = ('information', 'search', 'completeMetadata', 'browseGraphic', 'upload', 'emailService')                                         or (not(cit:function/*/@codeListValue) and matches(*:protocol/*/text(), 'WWW:LINK.*')))]/*:linkage/(*:CharacterString|*:URL)"/>
      <xsl:variable name="hasOneOrMoreDistributions" select="count($distributions) &gt; 0"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$hasOneOrMoreDistributions"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$hasOneOrMoreDistributions">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.hvd.distribution.mandatory-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>

    The HVD IR is a quality improvement of existing datasets. The intention is that HVD datasets are publicly and open
    accessible. Therefore a Distribution is expected to be present. Add an online resource with a download protocol or
    function.
  </svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.hvd.distribution.mandatory-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>

    Les règles d'implémentation HVD ont pour objectif une amélioration de la qualité des ensembles de données existants.
    L'objectif est que les ensembles de données HVD soient accessibles au public et en libre accès. Par conséquent, une
    distribution est attendue. Ajoutez une ressource en ligne avec un protocole ou une fonction de téléchargement.
  </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="$hasOneOrMoreDistributions">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$hasOneOrMoreDistributions">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.hvd.distribution.mandatory-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>

    Distribution URLs found:<xsl:text/>
               <xsl:copy-of select="concat(' ', string-join($distributions, ', '))"/>
               <xsl:text/>.
  </svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.hvd.distribution.mandatory-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>

    URL(s) de distribution encodées :<xsl:text/>
               <xsl:copy-of select="concat(' ', string-join($distributions, ', '))"/>
               <xsl:text/>.
  </svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M56"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M56"/>
   <xsl:template match="@*|node()" priority="-2" mode="M56">
      <xsl:apply-templates select="*" mode="M56"/>
   </xsl:template>

   <!--PATTERN
        HVD (service)-->


  <!--RULE
      -->
<xsl:template match="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue = 'service']"
                 priority="1000"
                 mode="M57">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue = 'service']"/>
      <xsl:variable name="onlineResource"
                    select=".//(*:distributionInfo//mrd:onLine                             |*:portrayalCatalogueCitation/*/*:onlineResource                             |*:additionalDocumentation/*/*:onlineResource                             |*:reportReference/*/*:onlineResource                             |*:specification/*/*:onlineResource                             |*:featureCatalogueCitation/*/*:onlineResource)"/>
      <xsl:variable name="documentationUrls"
                    select="$onlineResource[*/*:function/*/@codeListValue = ('documentation')                                   or count(ancestor::*:additionalDocumentation) = 1                                   or starts-with(*/*:linkage/(*:CharacterString|*:URL), 'https://directory.spatineo.com')]/*/*:linkage/(*:CharacterString|*:URL)"/>
      <xsl:variable name="hasOneOrMoreDocumentation" select="count($documentationUrls) &gt; 0"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$hasOneOrMoreDocumentation"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$hasOneOrMoreDocumentation">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.hvd.servicedocumentation.mandatory-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>

    A page that provides additional information about the Data Service is missing.
    Add at least one online resource with a function documentation, an additional documentation or a URL pointing to https://directory.spatineo.com.
  </svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.hvd.servicedocumentation.mandatory-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>

    Il manque une page qui fournit des informations supplémentaires sur le service de données.
    Ajoutez au moins une ressource en ligne avec une function documentation, une documentation supplémentaire ou une URL pointant vers https://directory.spatineo.com.
  </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="$hasOneOrMoreDocumentation">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$hasOneOrMoreDocumentation">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.hvd.servicedocumentation.mandatory-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>

    Documentation pages found:<xsl:text/>
               <xsl:copy-of select="concat(' ', string-join($documentationUrls, ', '))"/>
               <xsl:text/>.
  </svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.hvd.servicedocumentation.mandatory-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>

    Documentations encodées :<xsl:text/>
               <xsl:copy-of select="concat(' ', string-join($documentationUrls, ', '))"/>
               <xsl:text/>.
  </svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:variable name="endpointDescriptionUrllExpression" select="'GetCapabilities|WSDL'"/>
      <xsl:variable name="endpointDescriptionProtocolsExpression"
                    select="'OpenAPI|Swagger|GetCapabilities|WSDL|Description'"/>
      <xsl:variable name="endpointUrls"
                    select=".//*:containsOperations/*/*:connectPoint/*[not(                                 matches(*:protocol/(*:CharacterString|*:Anchor)/text(), $endpointDescriptionProtocolsExpression, 'i')                                 or matches(*:linkage/(*:CharacterString|*:Anchor)/text(), $endpointDescriptionUrllExpression, 'i'))]/(*:linkage|*:URL)/*/text()"/>
      <xsl:variable name="hasOneOrMoreEndPointUrls" select="count($endpointUrls) &gt; 0"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$hasOneOrMoreEndPointUrls"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$hasOneOrMoreEndPointUrls">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.hvd.endpointurl.mandatory-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>

    The root location or primary endpoint of the service (an IRI) is missing. Add an operation with a protocol which is
    not considered as an endpoint description (ie.<xsl:text/>
                  <xsl:copy-of select="concat(' ', $endpointDescriptionProtocolsExpression)"/>
                  <xsl:text/>) or a URL containing <xsl:text/>
                  <xsl:copy-of select="$endpointDescriptionUrllExpression"/>
                  <xsl:text/>.
  </svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.hvd.endpointurl.mandatory-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>

    L'URL principale du service (un IRI) est manquant. Ajoutez une opération avec un protocole qui n'est pas une
    description de service
    (ie.<xsl:text/>
                  <xsl:copy-of select="concat(' ', $endpointDescriptionProtocolsExpression)"/>
                  <xsl:text/>) ou une URL contenant <xsl:text/>
                  <xsl:copy-of select="$endpointDescriptionUrllExpression"/>
                  <xsl:text/>.
  </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="$hasOneOrMoreEndPointUrls">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$hasOneOrMoreEndPointUrls">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.hvd.endpointurl.mandatory-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>

    End point URL found:<xsl:text/>
               <xsl:copy-of select="concat(' ', string-join($endpointUrls, ', '))"/>
               <xsl:text/>.
  </svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.hvd.endpointurl.mandatory-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>

    URL(s) du service encodées :<xsl:text/>
               <xsl:copy-of select="concat(' ', string-join($endpointUrls, ', '))"/>
               <xsl:text/>.
  </svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:variable name="operatesOnDatasets"
                    select=".//*:operatesOn/(@xlink:href[. != ''], @uuidref[. != ''])[1]"/>
      <xsl:variable name="hasOneOrMoreOperatesOn" select="count($operatesOnDatasets) &gt; 0"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$hasOneOrMoreOperatesOn"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$hasOneOrMoreOperatesOn">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.hvd.operateson.mandatory-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>

    An API in the context of HVD is not a standalone resource. It is used to open up HVD datasets. Therefore each Data
    Service is at least tightly connected with a Dataset.
    Add at least one operatesOn element with a xlink:href or uuidref.
  </svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.hvd.operateson.mandatory-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>

    Une API dans le contexte de HVD n'est pas une ressource autonome. Elle est utilisée pour ouvrir des ensembles de
    données HVD. Par conséquent, chaque service de données est au moins étroitement lié à un ensemble de données.
    Ajoutez au moins un élément operateOn avec un xlink:href ou un uuidref.
  </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="$hasOneOrMoreOperatesOn">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$hasOneOrMoreOperatesOn">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.hvd.operateson.mandatory-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>

    Operates on dataset found:<xsl:text/>
               <xsl:copy-of select="concat(' ', string-join($operatesOnDatasets, ', '))"/>
               <xsl:text/>.
  </svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.hvd.operateson.mandatory-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>

    Données associées encodées :<xsl:text/>
               <xsl:copy-of select="concat(' ', string-join($operatesOnDatasets, ', '))"/>
               <xsl:text/>.
  </svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M57"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M57"/>
   <xsl:template match="@*|node()" priority="-2" mode="M57">
      <xsl:apply-templates select="*" mode="M57"/>
   </xsl:template>
</xsl:stylesheet>
<?xml version="1.0"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY nme '<b>
   <xsl:text>&lt;</xsl:text>
   <xsl:value-of select="@name"/>
   <xsl:text>&gt;</xsl:text>
   </b>' >

<!ENTITY refmodel '<xsl:value-of select="$refmodel"/>' >
<!ENTITY model '<xsl:value-of select="$model"/>' >

]>
<xsl:stylesheet
        version="2.0" 
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 >
	
	
	<xsl:output
        method="html"
        omit-xml-declaration="yes"
        indent="yes"
		  />



    <xsl:param name="refpath" select="'https://raw.githubusercontent.com/jeffbeckncbi/numm/master/models/'"/>
    <xsl:param name="reffile" select="'jats1.xml'"/>
	 <xsl:param name="report" select="'no'"/>
	 
    <xsl:variable name="refdoc" select="doc(concat($refpath,$reffile))"/>
    <xsl:variable name="ref" select="$refdoc/numm/structures"/>

    <xsl:variable name="refmodel" select="$refdoc/numm/head/model"/>
    <xsl:variable name="model" select="/numm/head/model"/>
    
    <xsl:variable name="element-thead">
        <tr>
            <th>Name</th>
            <th>Superstructure<br/>Element?</th>
            <th>Element Content Only<br/>or #PCDATA/EMPTY</th>      
            <th>Role in &lt;sec&gt;</th>
            <th>Section Model?</th>
            <th>Alternatives<br/>Wrapper?</th>
            <th>Points with<br/>@rid?</th>
        </tr>
    </xsl:variable>


<!-- **************************************************************************************** -->
<!-- **************************************************************************************** -->
<!--                             RUN TESTS AS VARIABLES                                       -->
<!-- **************************************************************************************** -->
<!-- **************************************************************************************** -->

    <xsl:variable name="attribute-change-type">
        <xsl:for-each select="numm/structures/structure[@type='attribute']">
            <xsl:sort order="ascending" select="@name"/>
            <xsl:variable name="attname" select="@name"/>
            <xsl:variable name="atttype" select="if (@att-type) then (@att-type) else 'NONE'"/>
            <xsl:if test="$ref/structure[@name=$attname and @att-type and @att-type!=$atttype]">
                <li>
                    <b>
                        <xsl:text>@</xsl:text>
                        <xsl:value-of select="@name"/>
                    </b>
                    <xsl:text> attribute type was "</xsl:text>
                    <xsl:value-of select="upper-case($ref/structure[@name=$attname]/@att-type)"/>
                    <xsl:text>" but is now "</xsl:text>
                    <xsl:value-of select="upper-case($atttype)"/>
                    <xsl:text>".</xsl:text>
                </li>
                </xsl:if>
            </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="has-attribute-change-type" select="if ($attribute-change-type/li) then 1 else 0"/>
 
    <xsl:variable name="elements-were-superstructure">
        <xsl:for-each select="numm/structures/structure[@type='element']">
            <xsl:sort order="ascending" select="@name"/>
            <xsl:variable name="elname" select="@name"/>
            <xsl:variable name="ss" select="if (@superstructure) then (@superstructure) else 'NONE'"/>
            <xsl:if test="$ref/structure[@name=$elname and @superstructure='yes' and $ss!='yes' and @type='element']">
                <li>
                    &nme;
                    <xsl:text>  was a SUPERSTRUCTURE element in </xsl:text>
                    &refmodel;
                    <xsl:text> model but is not in </xsl:text>
						  &model;
						  <xsl:text>.</xsl:text>
                </li>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="has-elements-were-superstructure" select="if ($elements-were-superstructure/li) then 1 else 0"/>

    <xsl:variable name="elements-became-superstructure">
        <xsl:for-each select="numm/structures/structure[@type='element']">
            <xsl:sort order="ascending" select="@name"/>
            <xsl:variable name="elname" select="@name"/>
            <xsl:variable name="ss" select="if (@superstructure) then (@superstructure) else 'NONE'"/>
            <xsl:if test="$ref/structure[@name=$elname and (not(@superstructure) or @superstructure!='yes') and $ss='yes' and @type='element']">
                <li>
                    &nme;
                    <xsl:text> has become a SUPERSTRUCTURE element in </xsl:text>
                    <xsl:value-of select="/numm/head/model"/>
                    <xsl:text> but it was not SUPERSTRUCTURE in </xsl:text>
                    &refmodel;
                    <xsl:text>.</xsl:text>
                </li>
            </xsl:if>
        </xsl:for-each>
        </xsl:variable>
    <xsl:variable name="has-elements-became-superstructure" select="if ($elements-became-superstructure/li) then 1 else 0"/>
    

    <xsl:variable name="was-element-only">
        <xsl:for-each select="numm/structures/structure[@type='element']">
            <xsl:sort order="ascending" select="@name"/>
            <xsl:variable name="elname" select="@name"/>
            <xsl:variable name="eo" select="if (@element-only) then (@element-only) else 'NONE'"/>
            <xsl:if test="$ref/structure[@name=$elname and @element-only='yes' and $eo='no' ]">
                <li>
                    &nme;
                    <xsl:text>  had an ELEMENT ONLY model in </xsl:text>
                    &refmodel;
                    <xsl:text>, but it has a #PCDATA/EMPTY model in </xsl:text>
						  &model;
						  <xsl:text>.</xsl:text>
                </li>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
    <xsl:variable name="has-was-element-only" select="if ($was-element-only/li) then 1 else 0"/>


    <xsl:variable name="became-element-only">
        <xsl:for-each select="numm/structures/structure[@type='element']">
            <xsl:sort order="ascending" select="@name"/>
            <xsl:variable name="elname" select="@name"/>
            <xsl:variable name="eo" select="if (@element-only) then (@element-only) else 'NONE'"/>
            <xsl:if test="$ref/structure[@name=$elname and @element-only='no' and @element-only!=$eo]">
                <li>
                    &nme;
                    <xsl:text>  had a MIXED or EMPTY model in </xsl:text>
                    &refmodel;
                    <xsl:text>, but it has an ELEMENT model in </xsl:text>
						  &model;
						  <xsl:text>.</xsl:text>
                </li>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
    <xsl:variable name="has-became-element-only" select="if ($became-element-only/li) then 1 else 0"/>


    <xsl:variable name="was-sec-model">
        <xsl:for-each select="numm/structures/structure[@type='element']">
            <xsl:sort order="ascending" select="@name"/>
            <xsl:variable name="elname" select="@name"/>
            <xsl:variable name="sm" select="if (@section-model) then (@section-model) else 'NONE'"/>
            <xsl:if test="$ref/structure[@name=$elname and @section-model='yes' and ($sm='no' or $sm='NONE') ]">
                <li>
                    &nme;
                    <xsl:text>  had a section model in </xsl:text>
                    &refmodel;
                    <xsl:text>, but it does not in </xsl:text>
						  &model;
						  <xsl:text>.</xsl:text>
                </li>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
    <xsl:variable name="has-was-sec-model" select="if ($was-sec-model/li) then 1 else 0"/>


    <xsl:variable name="became-sec-model">
        <xsl:for-each select="numm/structures/structure[@type='element']">
            <xsl:sort order="ascending" select="@name"/>
            <xsl:variable name="elname" select="@name"/>
            <xsl:variable name="sm" select="if (@section-model) then (@section-model) else 'NONE'"/>
            <xsl:if test="$ref/structure[@name=$elname and (@section-model='no' or not(@section-model)) and $sm='yes']">
                <li>
                    &nme;
                    <xsl:text>  did not have a section model in </xsl:text>
                    &refmodel;
                    <xsl:text>, but it has a section model in </xsl:text>
						  &model;
						  <xsl:text>.</xsl:text>
                </li>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
    <xsl:variable name="has-became-sec-model" select="if ($became-sec-model/li) then 1 else 0"/>


    <xsl:variable name="was-alternatives">
        <xsl:for-each select="numm/structures/structure[@type='element']">
            <xsl:sort order="ascending" select="@name"/>
            <xsl:variable name="elname" select="@name"/>
            <xsl:variable name="alt" select="if (@alternatives) then (@alternatives) else 'NONE'"/>
            <xsl:if test="$ref/structure[@name=$elname and @alternatives='yes' and ($alt='no' or $alt='NONE') ]">
                <li>
                    &nme;
                    <xsl:text>  was an element that held alternatives in </xsl:text>
                    &refmodel;
                    <xsl:text>, but it can not in </xsl:text>
						  &model;
						  <xsl:text>.</xsl:text>
                </li>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
    <xsl:variable name="has-was-alternatives" select="if ($was-alternatives/li) then 1 else 0"/>


    <xsl:variable name="became-alternatives">
        <xsl:for-each select="numm/structures/structure[@type='element']">
            <xsl:sort order="ascending" select="@name"/>
            <xsl:variable name="elname" select="@name"/>
            <xsl:variable name="alt" select="if (@alternatives) then (@alternatives) else 'NONE'"/>
            <xsl:if test="$ref/structure[@name=$elname and (@alternatives='no' or not(@alternatives)) and $alt='yes']">
                <li>
                    &nme;
                    <xsl:text>  was not an element that held alternatives in </xsl:text>
                    &refmodel;
                    <xsl:text>, but holds alternatives in </xsl:text>
						  &model;
						  <xsl:text>.</xsl:text>
                </li>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
    <xsl:variable name="has-became-alternatives" select="if ($became-alternatives/li) then 1 else 0"/>




<!-- **************************************************************************************** -->
<!-- **************************************************************************************** -->
<!--                                PROCESS THE MODEL                                         -->
<!-- **************************************************************************************** -->
<!-- **************************************************************************************** -->
	<xsl:template match="numm">
        <html>
            <head>
                <title>Model Compare</title>
            </head>
            <body>
                <h1>
                    <xsl:text>Comparing </xsl:text>
                    <xsl:value-of select="head/model"/>
                    <xsl:text> against </xsl:text>
                    &refmodel;
                </h1>
                <h3>Summary</h3>
                <xsl:choose>
                    <xsl:when test="$has-elements-were-superstructure =1 or
                                    $has-elements-became-superstructure=1 or
												$has-became-element-only=1 or
												$has-was-element-only">
                        &model;
                        <xsl:text> IS NOT compatible with </xsl:text>
                        &refmodel;
                        <xsl:text>. Details are below.</xsl:text>
                    </xsl:when>
                       <xsl:otherwise>
                           &model;
                           <xsl:text> is compatible with </xsl:text>
                           &refmodel;
                           <xsl:text>. </xsl:text>
                           
                       </xsl:otherwise>
                </xsl:choose>
                
                <xsl:call-template name="attribute-tests"/>
                <xsl:call-template name="element-tests"/>
                
                <!-- added items report below -->
					 <xsl:if test ="$report='yes'">
                	<h3>Added Structures Are Listed Below</h3>
                	<xsl:call-template name="added-els"/>
                	<xsl:call-template name="added-atts"/>
                	</xsl:if>
            </body>
         </html>
	</xsl:template>

    
    
    
    
<!-- **************************************************************************************** -->
<!-- **************************************************************************************** -->
<!--                               ATTRIBUTE TESTS                                            -->
<!-- **************************************************************************************** -->
<!-- **************************************************************************************** -->
   
    <xsl:template name="attribute-tests">
         <xsl:call-template name="attribute-type"/>
    </xsl:template>

     <xsl:template name="attribute-type">
        <xsl:if test="$has-attribute-change-type=1">
            <h3>Attribute Type Changes</h3>
            <div class="id-idref" style="border:top;">
                 <ul>
                    <xsl:copy-of select="$attribute-change-type"/>
                </ul>
          </div>
		  </xsl:if>
    </xsl:template>




<!-- **************************************************************************************** -->
<!-- **************************************************************************************** -->
<!--                                 ELEMENT TESTS                                            -->
<!-- **************************************************************************************** -->
<!-- **************************************************************************************** -->
   
    <xsl:template name="element-tests">
        	<xsl:call-template name="superstructure"/>
			<xsl:call-template name="element-only"/>
			<xsl:call-template name="section-model"/>
			<xsl:call-template name="alternatives-model"/>
    </xsl:template>
    
    <xsl:template name="superstructure">
        <xsl:if test="$has-elements-were-superstructure=1 or $has-elements-became-superstructure=1">
        <h3>Superstructure Changes</h3>
        <div class="id-idref" style="border:top;">
            <xsl:if test="$has-elements-were-superstructure=1">
                <ul>
                    <xsl:copy-of select="$elements-were-superstructure"/>
                </ul>
            </xsl:if>
           <xsl:if test="$has-elements-became-superstructure=1">
                <ul>
                    <xsl:copy-of select="$elements-became-superstructure"/>
                </ul>
            </xsl:if>
         </div>
        </xsl:if>
    </xsl:template>
    
    
    <xsl:template name="element-only">
        <xsl:if test="$has-was-element-only=1 or $has-became-element-only=1">
        <h3>Element Only or #PCDATA/EMPTY Changes</h3>
        <div class="id-idref" style="border:top;">
            <xsl:if test="$has-was-element-only=1">
                <ul>
                    <xsl:copy-of select="$was-element-only"/>
                </ul>
            </xsl:if>
           <xsl:if test="$has-became-element-only=1">
                <ul>
                    <xsl:copy-of select="$became-element-only"/>
                </ul>
            </xsl:if>
         </div>
        </xsl:if>
    </xsl:template>
    
    
    <xsl:template name="section-model">
        <xsl:if test="$has-was-sec-model=1 or $has-became-sec-model=1">
        <h3>Section Model Changes</h3>
        <div class="id-idref" style="border:top;">
            <xsl:if test="$has-was-sec-model=1">
                <ul>
                    <xsl:copy-of select="$was-sec-model"/>
                </ul>
            </xsl:if>
           <xsl:if test="$has-became-sec-model=1">
                <ul>
                    <xsl:copy-of select="$became-sec-model"/>
                </ul>
            </xsl:if>
         </div>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="alternatives-model">
        <xsl:if test="$has-was-alternatives=1 or $has-became-alternatives=1">
        <h3>Alternatives Model Changes</h3>
        <div class="id-idref" style="border:top;">
            <xsl:if test="$has-was-alternatives=1">
                <ul>
                    <xsl:copy-of select="$was-alternatives"/>
                </ul>
            </xsl:if>
           <xsl:if test="$has-became-alternatives=1">
                <ul>
                    <xsl:copy-of select="$became-alternatives"/>
                </ul>
            </xsl:if>
         </div>
        </xsl:if>
    </xsl:template>
    
    
    
	 
	 
	 
<!-- **************************************************************************************** -->
<!-- **************************************************************************************** -->
<!--                           ADDED STRUCTURES (REPORT ONLY)                                 -->
<!-- **************************************************************************************** -->
<!-- **************************************************************************************** -->

    <xsl:template name="added-els">
        <div class="added-atts">
            <h4>Added Elements</h4>
           <table border="yes">
               <xsl:copy-of select="$element-thead"/>
               <xsl:for-each select="structures/structure[@type='element']">
                    <xsl:sort order="ascending" select="@name"/>
                    <xsl:variable name="elname" select="@name"/>
                    <xsl:if test="not($ref/structure[@name=$elname])">
                        <tr>
                            <td>
                                <b><xsl:text>&lt;</xsl:text>
                                <xsl:value-of select="$elname"/>
                                <xsl:text>&gt;</xsl:text></b>
                            </td>
                            <td>
                                <xsl:value-of select="if (@superstructure='yes') then 'Superstructure' else ''"/>
                            </td>
                            <td>
                                <xsl:value-of select="if (@element-only='yes') then 'Element Content' else (if (@element-only='no') then '#PCDATA/EMPTY' else ' ')"/>
                            </td>
                            <td>
                                <xsl:value-of select="@role-in-section"/>
                            </td>
                            <td>
                                <xsl:value-of select="if (@section-model='yes') then 'Yes' else ''"/>
                            </td>
                            <td>
                                <xsl:value-of select="if (@alternatives='yes') then 'Yes' else ''"/>
                            </td>
                            <td>
                                <xsl:value-of select="if (@points-with-rid='yes') then 'Has @rid' else ''"/>
                            </td>
                        </tr>
                    </xsl:if>
                </xsl:for-each>
               <xsl:copy-of select="$element-thead"/>
            </table>
        </div>
    </xsl:template>
    

   <xsl:template name="added-atts">
        <div class="added-atts">
            <h4>Added Attributes</h4>
            <ul>
            <xsl:for-each select="structures/structure[@type='attribute']">
                <xsl:sort order="ascending" select="@name"/>
                <xsl:variable name="attname" select="@name"/>
                <xsl:if test="not($ref/structure[@name=$attname])">
                    <li>
                        <xsl:value-of select="$attname"/>
                        <xsl:if test="@att-type">
                            <xsl:text>, Attriute-Type="</xsl:text>
                            <xsl:value-of select="@att-type"/>
                            <xsl:text>"</xsl:text>
                        </xsl:if>
                    </li>
                </xsl:if>
            </xsl:for-each>
            </ul>
        </div>
    </xsl:template>

	 
 	</xsl:stylesheet>

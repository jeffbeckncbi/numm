<?xml version="1.0"?>

<xsl:stylesheet
        version="2.0" 
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 >
	
	
	<xsl:output
        method="html"
        omit-xml-declaration="yes"
        indent="yes"
		  />

    <xsl:variable name="refdoc" select="doc('jats1.xml')"/>
    <xsl:variable name="ref" select="$refdoc/numm/structures"/>

    <xsl:variable name="refmodel" select="$refdoc/numm/head/model"/>

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
                    <xsl:value-of select="$refmodel"/>
                </h1>
                
                <xsl:call-template name="attribute-tests"/>
                <xsl:call-template name="element-tests"/>
            </body>
         </html>
	</xsl:template>

    <xsl:template name="attribute-tests">
        <h2>Attribute Tests</h2>
        <xsl:call-template name="added-atts"/>
        <xsl:call-template name="id-idref"/>
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

    <xsl:template name="id-idref">
        <div class="id-idref" style="border:top;">
            
            <h4>Attributes from <xsl:value-of select="$refmodel"/> whose attribute types have changed</h4>  
            <ul>
            <xsl:for-each select="structures/struct[@role='attribute']">
                <xsl:sort order="ascending" select="@name"/>
                <xsl:variable name="attname" select="@name"/>
                <xsl:variable name="atttype" select="if (@att-type) then (@att-type) else 'none'"/>
                
                <xsl:if test="$ref/struct[@name=$attname and @att-type and @att-type!=$atttype]">
                     <li>
                        <xsl:value-of select="@name"/>
                        <xsl:text> attribute type was "</xsl:text>
                        <xsl:value-of select="upper-case($ref/struct[@name=$attname]/@att-type)"/>
                        <xsl:text>" but is now "</xsl:text>
                        <xsl:value-of select="upper-case($atttype)"/>
                        <xsl:text>".</xsl:text>
                     </li>
                </xsl:if>
            </xsl:for-each>
            </ul>
        </div>
    </xsl:template>




    <xsl:template name="element-tests">
        <h2>Element Tests</h2>
        <xsl:call-template name="added-els"/>
        <xsl:call-template name="superstructure"/>
        <xsl:call-template name="role-change"/>
        <xsl:call-template name="was-el-only"/>
        <xsl:call-template name="now-el-only"/>
    </xsl:template>
    

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
    
    <xsl:template name="superstructure">
        <h3>Superstructure Consistency</h3>
        <div class="id-idref" style="border:top;">
            
            <h4>Elements from <xsl:value-of select="$refmodel"/> that are no longer "SUPERSTRUCTURE".</h4>  
            <ul>
                <xsl:for-each select="structures/structure[@type='element']">
                    <xsl:sort order="ascending" select="@name"/>
                    <xsl:variable name="elname" select="@name"/>
                    <xsl:variable name="ss" select="if (@superstructure) then (@superstructure) else 'NONE'"/>
                    
                    <xsl:if test="$ref/structure[@name=$elname and @superstructure='yes' and $ss!='yes' and @type='element']">
                        <li>
                            <xsl:value-of select="@name"/>
                            <xsl:text>  was a SUPERSTRUCTURE element in </xsl:text>
                            <xsl:value-of select="$refmodel"/>
                            <xsl:text> model but is not any longer.</xsl:text>
                        </li>
                    </xsl:if>
                </xsl:for-each>
            </ul>
            
            <h4>Elements from <xsl:value-of select="$refmodel"/> that have become "SUPERSTRUCTURE".</h4>  
            <ul>
                <xsl:for-each select="structures/structure[@type='element']">
                    <xsl:sort order="ascending" select="@name"/>
                    <xsl:variable name="elname" select="@name"/>
                    <xsl:variable name="ss" select="if (@superstructure) then (@superstructure) else 'NONE'"/>
                    
                    <xsl:if test="$ref/structure[@name=$elname and (not(@superstructure) or @superstructure!='yes') and $ss='yes' and @type='element']">
                        <li>
                            <xsl:value-of select="@name"/>
                            <xsl:text> has become a SUPERSTRUCTURE element in </xsl:text>
                            <xsl:value-of select="/numm/head/model"/>
                            <xsl:text> model but it was not SUPERSTRUCTURE in </xsl:text>
                            <xsl:value-of select="$refmodel"/>
                            <xsl:text>.</xsl:text>
                        </li>
                    </xsl:if>
                </xsl:for-each>
            </ul>
        </div>
        
    </xsl:template>
    
    
    
    <xsl:template name="role-change">
        <div class="id-idref" style="border:top;">
            
            <h4>Elements from <xsl:value-of select="$refmodel"/> whose roles have changed</h4>  
            <ul>
                <xsl:for-each select="structures/struct[@role!='attribute']">
                    <xsl:sort order="ascending" select="@name"/>
                    <xsl:variable name="elname" select="@name"/>
                    <xsl:variable name="rolename" select="if (@role) then (@role) else 'NONE'"/>
                    
                    <xsl:if test="$ref/struct[@name=$elname and @role and @role!=$rolename and @role!='attribute']">
                        <li>
                            <xsl:value-of select="@name"/>
                            <xsl:text> role  was "</xsl:text>
                            <xsl:value-of select="$ref/struct[@name=$elname]/@role"/>
                            <xsl:text>" but is now "</xsl:text>
                            <xsl:value-of select="$rolename"/>
                            <xsl:text>".</xsl:text>
                        </li>
                    </xsl:if>
                </xsl:for-each>
            </ul>
        </div>
    </xsl:template>
    
   
        
    <xsl:template name="was-el-only">
        <div class="id-idref" style="border:top;">
            
            <h4>Elements from <xsl:value-of select="$refmodel"/> that are no longer "ELEMENT ONLY".</h4>  
            <ul>
                <xsl:for-each select="structures/structure[@role!='attribute']">
                    <xsl:sort order="ascending" select="@name"/>
                    <xsl:variable name="elname" select="@name"/>
                    <xsl:variable name="eo" select="if (@element-only) then (@element-only) else 'NONE'"/>
                    
                    <xsl:if test="$ref/struct[@name=$elname and @element-only='yes' and @element-only!=$eo and @role!='attribute']">
                        <li>
                            <xsl:value-of select="@name"/>
                            <xsl:text>  had an ELEMENT ONLY model, but it does not any longer.</xsl:text>
                        </li>
                    </xsl:if>
                </xsl:for-each>
            </ul>
        </div>
    </xsl:template>
    
    
    <xsl:template name="now-el-only">
        <div class="id-idref" style="border:top;">
            
            <h4>Elements from <xsl:value-of select="$refmodel"/> that are no longer allow PCDATA.</h4>  
            <ul>
                <xsl:for-each select="structures/struct[@role!='attribute']">
                    <xsl:sort order="ascending" select="@name"/>
                    <xsl:variable name="elname" select="@name"/>
                    <xsl:variable name="eo" select="if (@element-only) then (@element-only) else 'NONE'"/>
                    
                    <xsl:if test="$ref/struct[@name=$elname and @element-only='no' and @element-only!=$eo and @role!='attribute']">
                        <li>
                            <xsl:value-of select="@name"/>
                            <xsl:text>  had a MIXED or EMPTY model, but it does not any longer.</xsl:text>
                        </li>
                    </xsl:if>
                </xsl:for-each>
            </ul>
        </div>
    </xsl:template>
    
    

		
	</xsl:stylesheet>

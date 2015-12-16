# numm

This is preliminary work for the NISO Uber Meta Model.

There are two directories here: models and xslt

Currently numm/models contains three fies:
  * jats1.xml - an xml representation of the numm properties of JATS 1.1d3.
  * bits1.xml - an xml representation of the numm properties of BITS 1.0.
  * bits1-test.xml - a copy of bits1.xml with changes that will fail the compatibility tests. 

There is one transform in numm/xslt: compare-models.xsl

This transform will compare a numm model XML for compatibility against a reference model. The JATS 1.1d3 model is set up as the default reference model in the transform with two stylesheet-level parameters and a variable:

```xml
 <xsl:param name="refpath" select="'https://raw.githubusercontent.com/jeffbeckncbi/numm/master/models/'"/>
 <xsl:param name="reffile" select="'jats1.xml'"/>
          
<xsl:variable name="refdoc" select="doc(concat($refpath,$reffile))"/>
```
By default the JATS 1.1d3 numm model will be used from this GitHub reposityr, but you can pass in a $refpath and $reffile.

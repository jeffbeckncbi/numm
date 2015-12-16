# numm

This is preliminary work for the NISO Uber Meta Model.

There are two directories here: numm/models and numm/xslt

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
By default the JATS 1.1d3 numm model will be used from this GitHub repository, but you can pass in a $refpath and $reffile to the transform to compare your numm model against any reference model you like. 

Running this transform on a numm xml model will compare it with the reference model. If the model is compatible with the reference model, the tranform will return a message that the nodels are compatible. If any of the tests fail, it will return a message that the model is not compatible with the reference model and give details on the specific tests that have failed. 

The specific tests are:
# Attribute type changes. Only two attribute types are tracked in numm: ID and IDREF. A change in the value of any ID or IDREF attribute from the reference model will be an error. That is, if @rid is defined as IDREF in the reference model and it is changed to CDATA in the extension, the extension will NOT be comaptible with the reference model.

# Superstructure element changes. Some elements are defined as "superstructure" elements. These are elements that define the general skeleton of the document that the content hangs on. For example, for HTML, <html>, <head>, and <body> would be superstructure elements. 
Any element defined as a Superstructure element in the reference model must be a Superstructure element in the extension model. Also, any element that is not a Superstructure element in the reference model should not become a Superstructure element in the extension

# next





There is one more stylesheet-level 
```xml
<xsl:param name="report" select="'no'"/>
```
$report will turn on the new objects report, which lists elements and attributes in the model that are not in the reference model.

